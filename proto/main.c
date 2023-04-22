#include "proto.h"
#include <SDL.h>
#include <SDL_main.h>
#include <stdio.h>
#include <stdlib.h>

bool AnyKeyPressed;
bool KeyPressed[256];

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/// Screen

enum {
    DesiredFPS = 50,
    FrameLength = 1000 / DesiredFPS,
    BlinkLength = 32 * FrameLength
};

typedef struct Color { byte r, g, b; } Color;
static const Color SpectrumColors[] = {
        {   0,   0,   0 },
        {   0,   0, 192 },
        { 192,   0,   0 },
        { 192,   0, 192 },
        {   0, 192,   0 },
        {   0, 192, 192 },
        { 192, 192,   0 },
        { 192, 192, 192 },
        {   0,   0,   0 },
        {   0,   0, 255 },
        { 255,   0,   0 },
        { 255,   0, 255 },
        {   0, 255,   0 },
        {   0, 255, 255 },
        { 255, 255,   0 },
        { 255, 255, 255 },
    };

byte SpectrumBorder;

static SDL_Window* g_window;
static SDL_Renderer* g_renderer;
static SDL_PixelFormat* g_pixelFormat;
static SDL_Texture* g_texture;
static Uint32 g_spectrumBuffer[FULL_SCREEN_WIDTH * FULL_SCREEN_HEIGHT];
static bool g_blinkPhase2;

byte SpectrumScreen[6912];

static SDL_Texture* CreateTexture(SDL_Renderer* renderer, Uint32 format, int w, int h, int mode)
{
    SDL_Texture* texture = SDL_CreateTexture(renderer, format, SDL_TEXTUREACCESS_STREAMING, w, h);
    if (!texture)
        ErrorExit("Unable to create texture: %s", SDL_GetError());

    SDL_SetTextureBlendMode(texture, mode);

    return texture;
}

static void DestroyTexture(SDL_Texture** texture)
{
    if (*texture) {
        SDL_DestroyTexture(*texture);
        *texture = NULL;
    }
}

static void InitScreen(void)
{
    SDL_ClearError();
    g_window = SDL_CreateWindow("16K", 3000, SDL_WINDOWPOS_CENTERED,
        FULL_SCREEN_WIDTH * SCREEN_SCALE, FULL_SCREEN_HEIGHT * SCREEN_SCALE, 0);
    if (!g_window)
        ErrorExit("Unable to initialize video mode: %s", SDL_GetError());

    g_renderer = SDL_CreateRenderer(g_window, -1, SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC);
    if (!g_renderer)
        ErrorExit("Unable to initialize renderer: %s", SDL_GetError());

    const unsigned format = SDL_PIXELFORMAT_BGRA32;
    g_pixelFormat = SDL_AllocFormat(format);
    if (!g_pixelFormat)
        ErrorExit("Unable to allocate pixel format: %s", SDL_GetError());

    g_texture = CreateTexture(g_renderer, format, FULL_SCREEN_WIDTH, FULL_SCREEN_HEIGHT, SDL_BLENDMODE_NONE);
}

static void CleanupScreen(void)
{
    DestroyTexture(&g_texture);

    if (g_pixelFormat) {
        SDL_FreeFormat(g_pixelFormat);
        g_pixelFormat = NULL;
    }

    if (g_renderer) {
        SDL_DestroyRenderer(g_renderer);
        g_renderer = NULL;
    }

    if (g_window) {
        SDL_DestroyWindow(g_window);
        g_window = NULL;
    }
}

static Uint32 MapColorZX(SDL_PixelFormat* pixelFormat, int color)
{
    Color c = SpectrumColors[color];
    return SDL_MapRGBA(pixelFormat, c.r, c.g, c.b, 0xff);
}

static Color GetBackgroundColor(int attrib, bool blinkPhase2);

static Color GetForegroundColor(int attrib, bool blinkPhase2)
{
    if ((attrib & 0x80) != 0 && blinkPhase2)
        return GetBackgroundColor(attrib, false);

    return SpectrumColors[(attrib & 7) | ((attrib & 0x40) >> 3)];
}

static Color GetBackgroundColor(int attrib, bool blinkPhase2)
{
    if ((attrib & 0x80) != 0 && blinkPhase2)
        return GetForegroundColor(attrib, false);

    return SpectrumColors[((attrib >> 3) & 7) | ((attrib & 0x40) >> 3)];
}

static void RenderSpectrumScreen(Uint32* dst, SDL_PixelFormat* pixelFormat, bool blinkPhase2)
{
    Uint32 border = MapColorZX(pixelFormat, SpectrumBorder);
    int x, y;

    for (y = 0; y < SCREEN_BORDER_SIZE; y++) {
        for (x = 0; x < FULL_SCREEN_WIDTH; x++)
            *dst++ = border;
    }

    for (y = 0; y < SCREEN_HEIGHT; y++) {
        int off = (y + SCREEN_BORDER_SIZE) * FULL_SCREEN_WIDTH;
        for (x = 0; x < SCREEN_BORDER_SIZE; x++)
            *dst++ = border;

        for (x = 0; x < SCREEN_WIDTH; x++) {
            int xx = x >> 3;
            int pixels = SpectrumScreen[ZXCOORD(xx, y)];
            int attrib = SpectrumScreen[6144 + 32 * (y >> 3) + xx];

            Color color;
            if ((pixels & (1 << (7 - (x & 7)))) != 0)
                color = GetForegroundColor(attrib, blinkPhase2);
            else
                color = GetBackgroundColor(attrib, blinkPhase2);

            *dst++ = SDL_MapRGBA(pixelFormat, color.r, color.g, color.b, 0xff);
        }

        for (x = 0; x < SCREEN_BORDER_SIZE; x++)
            *dst++ = border;
    }

    for (y = 0; y < SCREEN_BORDER_SIZE; y++) {
        for (x = 0; x < FULL_SCREEN_WIDTH; x++)
            *dst++ = border;
    }
}

static void DoRenderScreen(void)
{
    RenderSpectrumScreen(g_spectrumBuffer, g_pixelFormat, g_blinkPhase2);

    SDL_UpdateTexture(g_texture, NULL, g_spectrumBuffer, FULL_SCREEN_WIDTH * sizeof(Uint32));

    Color c = SpectrumColors[SpectrumBorder];
    SDL_SetRenderDrawColor(g_renderer, c.r, c.g, c.b, 0);
    SDL_RenderClear(g_renderer);

    int screenW = FULL_SCREEN_WIDTH * SCREEN_SCALE;
    int screenH = FULL_SCREEN_HEIGHT * SCREEN_SCALE;
    SDL_GetRendererOutputSize(g_renderer, &screenW, &screenH);

    SDL_Rect dstRect;
    dstRect.w = FULL_SCREEN_WIDTH * SCREEN_SCALE;
    dstRect.h = FULL_SCREEN_HEIGHT * SCREEN_SCALE;
    dstRect.x = (screenW - dstRect.w) / 2;
    dstRect.y = (screenH - dstRect.h) / 2;

    SDL_RenderCopy(g_renderer, g_texture, NULL, &dstRect);
    SDL_RenderPresent(g_renderer);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/// Input

static int MapKey(SDL_Scancode sym)
{
    switch (sym) {
        case SDL_SCANCODE_0: return KEY_0;
        case SDL_SCANCODE_1: return KEY_1;
        case SDL_SCANCODE_2: return KEY_2;
        case SDL_SCANCODE_3: return KEY_3;
        case SDL_SCANCODE_4: return KEY_4;
        case SDL_SCANCODE_5: return KEY_5;
        case SDL_SCANCODE_6: return KEY_6;
        case SDL_SCANCODE_7: return KEY_7;
        case SDL_SCANCODE_8: return KEY_8;
        case SDL_SCANCODE_9: return KEY_9;
        case SDL_SCANCODE_A: return KEY_A;
        case SDL_SCANCODE_APOSTROPHE: return KEY_QUOTES;
        case SDL_SCANCODE_B: return KEY_B;
        case SDL_SCANCODE_BACKSLASH: return KEY_PC_BCKSLASH;
        case SDL_SCANCODE_BACKSPACE: return KEY_PC_BCKSPACE;
        case SDL_SCANCODE_C: return KEY_C;
        case SDL_SCANCODE_CAPSLOCK: return KEY_CAPS_LOCK;
        case SDL_SCANCODE_COMMA: return KEY_COMMA;
        case SDL_SCANCODE_D: return KEY_D;
        case SDL_SCANCODE_DELETE: return KEY_DELETE;
        case SDL_SCANCODE_DOWN: return KEY_DOWN;
        case SDL_SCANCODE_E: return KEY_E;
        case SDL_SCANCODE_END: return KEY_PC_END;
        case SDL_SCANCODE_EQUALS: return KEY_PC_EQUALS;
        case SDL_SCANCODE_ESCAPE: return KEY_BREAK;
        case SDL_SCANCODE_F: return KEY_F;
        case SDL_SCANCODE_F1: return KEY_PC_F1;
        case SDL_SCANCODE_F2: return KEY_PC_F2;
        case SDL_SCANCODE_F3: return KEY_PC_F3;
        case SDL_SCANCODE_F4: return KEY_PC_F4;
        case SDL_SCANCODE_F5: return KEY_INV_VIDEO;
        case SDL_SCANCODE_F6: return KEY_TRUE_VIDEO;
        case SDL_SCANCODE_F7: return KEY_EXTEND;
        case SDL_SCANCODE_F8: return KEY_GRAPH;
        case SDL_SCANCODE_G: return KEY_G;
        case SDL_SCANCODE_GRAVE: return KEY_PC_GRAVE;
        case SDL_SCANCODE_H: return KEY_H;
        case SDL_SCANCODE_HOME: return KEY_PC_HOME;
        case SDL_SCANCODE_I: return KEY_I;
        case SDL_SCANCODE_INSERT: return KEY_EDIT;
        case SDL_SCANCODE_J: return KEY_J;
        case SDL_SCANCODE_K: return KEY_K;
        case SDL_SCANCODE_KP_0: return KEY_0;
        case SDL_SCANCODE_KP_1: return KEY_1;
        case SDL_SCANCODE_KP_2: return KEY_2;
        case SDL_SCANCODE_KP_3: return KEY_3;
        case SDL_SCANCODE_KP_4: return KEY_4;
        case SDL_SCANCODE_KP_5: return KEY_5;
        case SDL_SCANCODE_KP_6: return KEY_6;
        case SDL_SCANCODE_KP_7: return KEY_7;
        case SDL_SCANCODE_KP_8: return KEY_8;
        case SDL_SCANCODE_KP_9: return KEY_9;
        case SDL_SCANCODE_KP_MINUS: return KEY_PC_MINUS;
        case SDL_SCANCODE_KP_MULTIPLY: return KEY_PC_KPADMULT;
        case SDL_SCANCODE_KP_PERIOD: return KEY_PERIOD;
        case SDL_SCANCODE_KP_PLUS: return KEY_PC_KPADPLUS;
        case SDL_SCANCODE_KP_ENTER: return KEY_ENTER;
        case SDL_SCANCODE_L: return KEY_L;
        case SDL_SCANCODE_LALT: return KEY_SYMB_SHIFT;
        case SDL_SCANCODE_LCTRL: return KEY_PC_CTRL;
        case SDL_SCANCODE_LEFT: return KEY_LEFT;
        case SDL_SCANCODE_LEFTBRACKET: return KEY_PC_LBRACKET;
        case SDL_SCANCODE_LSHIFT: return KEY_CAPS_SHIFT;
        case SDL_SCANCODE_M: return KEY_M;
        case SDL_SCANCODE_MINUS: return KEY_PC_MINUS;
        case SDL_SCANCODE_N: return KEY_N;
        case SDL_SCANCODE_O: return KEY_O;
        case SDL_SCANCODE_P: return KEY_P;
        case SDL_SCANCODE_PAUSE: return KEY_PC_PAUSE;
        case SDL_SCANCODE_PERIOD: return KEY_PERIOD;
        case SDL_SCANCODE_Q: return KEY_Q;
        case SDL_SCANCODE_R: return KEY_R;
        case SDL_SCANCODE_RALT: return KEY_SYMB_SHIFT;
        case SDL_SCANCODE_RCTRL: return KEY_PC_CTRL;
        case SDL_SCANCODE_RETURN: return KEY_ENTER;
        case SDL_SCANCODE_RETURN2: return KEY_ENTER;
        case SDL_SCANCODE_RIGHT: return KEY_RIGHT;
        case SDL_SCANCODE_RIGHTBRACKET: return KEY_PC_RBRACKET;
        case SDL_SCANCODE_RSHIFT: return KEY_CAPS_SHIFT;
        case SDL_SCANCODE_S: return KEY_S;
        case SDL_SCANCODE_SCROLLLOCK: return KEY_PC_SCRLLOCK;
        case SDL_SCANCODE_SEMICOLON: return KEY_SEMICOLON;
        case SDL_SCANCODE_SLASH: return KEY_PC_SLASH;
        case SDL_SCANCODE_SPACE: return KEY_SPACE;
        case SDL_SCANCODE_T: return KEY_T;
        case SDL_SCANCODE_TAB: return KEY_PC_TAB;
        case SDL_SCANCODE_U: return KEY_U;
        case SDL_SCANCODE_UP: return KEY_UP;
        case SDL_SCANCODE_V: return KEY_V;
        case SDL_SCANCODE_W: return KEY_W;
        case SDL_SCANCODE_X: return KEY_X;
        case SDL_SCANCODE_Y: return KEY_Y;
        case SDL_SCANCODE_Z: return KEY_Z;
    }
    return -1;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/// Main

Uint32 g_prevTicks;
Uint32 g_blinkPrevTicks;

static void Cleanup(void);

static void Init()
{
    int r = SDL_Init(SDL_INIT_VIDEO | SDL_INIT_AUDIO);
    if (r != 0)
        ErrorExit("Unable to initialize SDL: %s", SDL_GetError());

    atexit(Cleanup);

    InitScreen();
}

static void Cleanup()
{
    CleanupScreen();

    SDL_Quit();
}

void ErrorExit(const char* fmt, ...)
{
    char buf[2048];
    va_list args;

    va_start(args, fmt);
    vsnprintf(buf, sizeof(buf), fmt, args);
    va_end(args);

    Cleanup();

    SDL_LogError(SDL_LOG_CATEGORY_APPLICATION, "%s", buf);
    SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR, "Error", buf, NULL);

    exit(1);
}

static bool PollEvent()
{
    SDL_Event event;
    if (SDL_PollEvent(&event)) {
        switch (event.type) {
            case SDL_QUIT:
                exit(0);

            case SDL_KEYDOWN: {
                AnyKeyPressed = true;
                int key = MapKey(event.key.keysym.scancode);
                if (key >= 0)
                    KeyPressed[key] = true;
                break;
            }

            case SDL_KEYUP: {
                int key = MapKey(event.key.keysym.scancode);
                if (key >= 0)
                    KeyPressed[key] = false;
                break;
            }
        }
    }

    Uint32 ticks = SDL_GetTicks();
    bool render = false;

    if ((Sint32)(ticks - g_prevTicks) > 100) {
        g_prevTicks = ticks;
        g_blinkPrevTicks = ticks;
    }

    if (SDL_TICKS_PASSED(ticks, g_blinkPrevTicks + BlinkLength)) {
        g_blinkPrevTicks += BlinkLength;
        g_blinkPhase2 = !g_blinkPhase2;
        render = true;
    }

    if (SDL_TICKS_PASSED(ticks, g_prevTicks + FrameLength)) {
        g_prevTicks += FrameLength;
        return true;
    }

    if (render)
        DoRenderScreen();

    return false;
}

void HandleEvents(void)
{
    Interrupt();
    DoRenderScreen();

    while (!PollEvent())
        ;
}

int main(int argc, char** argv)
{
    Init();
    LoadData();

    g_prevTicks = SDL_GetTicks();
    g_blinkPrevTicks = g_prevTicks;

    Game();

    return 0;
}
