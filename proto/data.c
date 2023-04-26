#include "proto.h"
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

static FILE* f;

byte PlayerLeft1[8];
byte PlayerLeft2[8];
byte PlayerLeft3[8];
byte PlayerLeft4[8];
byte PlayerLeft5[8];
byte PlayerRight1[8];
byte PlayerRight2[8];
byte PlayerRight3[8];
byte PlayerRight4[8];
byte PlayerRight5[8];
byte PlayerHandsLeft1[8];
byte PlayerHandsLeft2[8];
byte PlayerHandsLeft3[8];
byte PlayerHandsLeft4[8];
byte PlayerHandsLeft5[8];
byte PlayerHandsRight1[8];
byte PlayerHandsRight2[8];
byte PlayerHandsRight3[8];
byte PlayerHandsRight4[8];
byte PlayerHandsRight5[8];
byte PlayerGunLeft1[8];
byte PlayerGunLeft2[8];
byte PlayerGunLeft3[8];
byte PlayerGunLeft4[8];
byte PlayerGunLeft5[8];
byte PlayerGunRight1[8];
byte PlayerGunRight2[8];
byte PlayerGunRight3[8];
byte PlayerGunRight4[8];
byte PlayerGunRight5[8];

byte PlayerLeftJump[8];
byte PlayerRightJump[8];
byte PlayerHandsLeftJump[8];
byte PlayerHandsRightJump[8];
byte PlayerGunLeftJump[8];
byte PlayerGunRightJump[8];
byte PlayerDead1Left[8];
byte PlayerDead2Left[8];
byte PlayerDead3Left[8];
byte PlayerDead1Right[8];
byte PlayerDead2Right[8];
byte PlayerDead3Right[8];

byte PlayerDuckLeft[8];
byte PlayerDuckRight[8];
byte PlayerHandsDuckLeft[8];
byte PlayerHandsDuckRight[8];
byte PlayerGunDuckLeft[8];
byte PlayerGunDuckRight[8];

byte GhostLeft1[8];
byte GhostLeft2[8];
byte GhostLeft3[8];
byte GhostLeft4[8];
byte GhostRight1[8];
byte GhostRight2[8];
byte GhostRight3[8];
byte GhostRight4[8];

byte GhostDeath1[8];
byte GhostDeath2[8];
byte GhostDeath3[8];
byte GhostDeath4[8];

byte GhostAppear1[8];
byte GhostAppear2[8];
byte GhostAppear3[8];
byte GhostAppear4[8];

byte Weapon1[8];
byte Weapon2[8];
byte Weapon3[8];
byte Weapon4[8];
byte Weapon5[8];
byte Weapon6[8];

byte BatLeft1[8];
byte BatLeft2[8];
byte BatLeft3[8];
byte BatLeft4[8];
byte BatRight1[8];
byte BatRight2[8];
byte BatRight3[8];
byte BatRight4[8];

byte BatFall1[8];
byte BatFall2[8];
byte BatRevive[8];

byte FlowerLeft1[8];
byte FlowerLeft2[8];
byte FlowerLeft3[8];
byte FlowerLeft4[8];
byte FlowerRight1[8];
byte FlowerRight2[8];
byte FlowerRight3[8];
byte FlowerRight4[8];

byte FlowerDeathLeft1[8];
byte FlowerDeathLeft2[8];
byte FlowerDeathRight1[8];
byte FlowerDeathRight2[8];
byte FlowerReviveLeft[8];
byte FlowerReviveRight[8];

byte Empty[8];
byte Bricks[8];
byte Bricks1[8];
byte Bricks2[8];
byte Bricks3[8];
byte Bricks4[8];
byte Bricks5[8];
byte Bricks6[8];
byte Stones1[8];
byte Stones2[8];

byte Stone[8];

byte AppleLeft[8];
byte AppleTopLeft[8];
byte AppleTop[8];
byte AppleTop1[8];
byte AppleTop2[8];
byte AppleTopRight[8];
byte AppleRight[8];
byte Apple1[8];
byte Apple2[8];
byte Apple3[8];
byte Apple4[8];

byte BorderTopLeft[8];
byte BorderTopCenter[8];
byte BorderTopRight[8];
byte BorderLeft[8];
byte BorderRight[8];
byte BorderBottomLeft[8];
byte BorderBottomCenter[8];
byte BorderBottomRight[8];

byte Border1TopLeft[8];
byte Border1TopCenter[8];
byte Border1TopRight[8];
byte Border1Left[8];
byte Border1Right[8];
byte Border1BottomLeft[8];
byte Border1BottomCenter[8];
byte Border1BottomRight[8];

byte Chains1[8];
byte Chains2[8];
byte Mushroom1[8];
byte Mushroom2[8];

byte Gates1_1[8];
byte Gates1_2[8];
byte Gates2_1[8];
byte Gates2_2[8];
byte Gates3_1[8];
byte Gates3_2[8];
byte Gates4_1[8];
byte Gates4_2[8];

byte SwitchOff[8];
byte SwitchOn[8];

byte Level1[1024];

static byte data[6912];
static int spriteCounter = 0;

static void GetSprite(const char* name, byte* dst, byte x, byte y)
{
    char buf[128];
    strcpy(buf, name);
    //for (char* p = buf; *p; ++p)
    //    *p = toupper(*p);

    ++spriteCounter;
    fprintf(f, "\nSPRITE_%s = %d\n", buf, spriteCounter);
    fprintf(f, "%s:\n", name);

    for (int i = 0; i < 8; i++) {
        *dst = data[ZXCOORD((x >> 3), (y + i))];
        fprintf(f, "db 0x%02X\n", *dst);
        ++dst;
    }
}

static void GetMirrorSprite(const char* name, byte* dst, byte x, byte y)
{
    char buf[128];
    strcpy(buf, name);
    //for (char* p = buf; *p; ++p)
    //    *p = toupper(*p);

    ++spriteCounter;
    fprintf(f, "\nSPRITE_%s = %d\n", buf, spriteCounter);
    fprintf(f, "%s:\n", name);

    for (int i = 0; i < 8; i++) {
        byte j = data[ZXCOORD((x >> 3), (y + i))];
        byte k = ((j >> 7) & 0x01)
               | (((j >> 6) & 0x01) << 1)
               | (((j >> 5) & 0x01) << 2)
               | (((j >> 4) & 0x01) << 3)
               | (((j >> 3) & 0x01) << 4)
               | (((j >> 2) & 0x01) << 5)
               | (((j >> 1) & 0x01) << 6)
               | (((j >> 0) & 0x01) << 7);
        *dst++ = k;
        fprintf(f, "db 0x%02X\n", k);
    }
}

#include "data_levels.h"
#include "data_levels_2.h"

static void GenerateLevel(const char* section, const char* name, byte* level, const char* const* data, byte chainsAttr)
{
    byte count = 0;
    byte value;

    fprintf(f, "section data_%s\n", section);
    fprintf(f, "%s:\n", name);
    byte* start = level;

    #define FLUSH() \
        if (count > 0) { \
            if (count == 1) \
                *level++ = 0x40 | value; \
            else { \
                *level++ = count; \
                *level++ = value; \
            } \
            count = 0; \
        }

    *level++ = chainsAttr;

    for (int y = LEVEL_HEIGHT - 1; y >= 0; y--) {
        if (strlen(data[y]) != LEVEL_WIDTH)
            abort();

        for (int x = 0; x < LEVEL_WIDTH; x++) {
            byte b;

            if (data[y][x] == '-' && data[y][x + 1] == '-' && data[y][x + 2] == '-') {
                int num;
                if (data[y + 1][x - 1] == '1' || data[y + 1][x - 1] == '2')
                    num = data[y + 1][x - 1] - '0';
                else if (data[y + 1][x + 3] == '1' || data[y + 1][x + 3] == '2')
                    num = data[y + 1][x + 3] - '0';
                else
                    abort();

                FLUSH();

                *level++ = 0x40 | 2;
                *level++ = 0x80 | (num == 1 ? PLAYER_1_TOP : PLAYER_2_TOP);
                *level++ = 0x40 | 3;

                x += 2;
                continue;
            }

            if (data[y][x] == '|' && data[y][x + 1] == 'A' && data[y][x + 2] == '|') {
                int num;
                if (data[y][x - 1] == '1' || data[y][x - 1] == '2')
                    num = data[y][x - 1] - '0';
                else if (data[y][x + 3] == '1' || data[y][x + 3] == '2')
                    num = data[y][x + 3] - '0';
                else
                    abort();

                FLUSH();

                *level++ = 0x40 | 4;
                *level++ = 0x80 | (num == 1 ? PLAYER_1_APPLE : PLAYER_2_APPLE);
                *level++ = 0x40 | 5;

                x += 2;
                continue;
            }

            switch (data[y][x]) {
                case ' ': b = 0; break;
                case '-': b = 0; break;
                case '#': {
                    bool hasLeft = (x != 0 && data[y][x-1] == '#');
                    bool hasRight = (x < LEVEL_WIDTH-1 && data[y][x+1] == '#');
                    if (!hasLeft && !hasRight)
                        b = 6;
                    else if (!hasLeft && hasRight)
                        b = 8;
                    else if (hasLeft && !hasRight)
                        b = 9;
                    else
                        b = 10;
                    break;
                }
                case '@': {
                    bool hasLeft = (x != 0 && data[y][x-1] == '@');
                    bool hasRight = (x < LEVEL_WIDTH-1 && data[y][x+1] == '@');
                    if (!hasLeft && !hasRight)
                        b = 12;
                    else if (!hasLeft && hasRight)
                        b = 14;
                    else if (hasLeft && !hasRight)
                        b = 15;
                    else
                        b = 16;
                    break;
                }
                case '%': {
                    bool hasLeft = (x != 0 && data[y][x-1] == '%');
                    bool hasRight = (x < LEVEL_WIDTH-1 && data[y][x+1] == '%');
                    if (!hasLeft && !hasRight)
                        b = 20;
                    else if (!hasLeft && hasRight)
                        b = 22;
                    else if (hasLeft && !hasRight)
                        b = 23;
                    else
                        b = 24;
                    break;
                }
                case '?': {
                    bool hasLeft = (x != 0 && data[y][x-1] == '?');
                    bool hasRight = (x < LEVEL_WIDTH-1 && data[y][x+1] == '?');
                    if (!hasLeft && !hasRight)
                        b = 26;
                    else if (!hasLeft && hasRight)
                        b = 28;
                    else if (hasLeft && !hasRight)
                        b = 29;
                    else
                        b = 30;
                    break;
                }
                case '&': {
                    bool hasLeft = (x != 0 && data[y][x-1] == '&');
                    bool hasRight = (x < LEVEL_WIDTH-1 && data[y][x+1] == '&');
                    if (!hasLeft && !hasRight)
                        b = 40;
                    else if (!hasLeft && hasRight)
                        b = 42;
                    else if (hasLeft && !hasRight)
                        b = 43;
                    else
                        b = 44;
                    break;
                }
                case 'X': b = 18; break;
                case 'x': b = 32; break;
                case 'Y': b = 34; break;
                case 'y': b = 36; break;
                case 'Z': b = 38; break;
                case 'C': b = 46; break;
                case 'M': b = 48; break;
                case 'm': b = 49; break;
                case 'N': b = 50; break;
                case 'n': b = 51; break;
                case 'P': b = 52; break;
                case 'p': b = 53; break;
                case 'Q': b = 54; break;
                case 'q': b = 55; break;
                case '1': FLUSH(); *level++ = 0x80 | PLAYER_1_START; continue;
                case '2': FLUSH(); *level++ = 0x80 | PLAYER_2_START; continue;
                case 'O': FLUSH(); *level++ = 0x80 | STONE; continue;
                case 'G': FLUSH(); *level++ = 0x80 | GHOST; continue;
                case 'B': FLUSH(); *level++ = 0x80 | BAT; continue;
                case 'W': FLUSH(); *level++ = 0x80 | WEAPON; continue;
                case 'F': FLUSH(); *level++ = 0x80 | FLOWER_LEFT; continue;
                case 'f': FLUSH(); *level++ = 0x80 | FLOWER_RIGHT; continue;
                case 'L': FLUSH(); *level++ = 0x80 | FLOWER_AUTO; continue;
                case 'D': FLUSH(); *level++ = 0x80 | DOOR_TOP; continue;
                case 'd': FLUSH(); *level++ = 0x80 | DOOR_BOTTOM; continue;
                case 'S': FLUSH(); *level++ = 0x80 | SWITCH; continue;
                default: abort();
            }

            if (count == 0) {
                value = b;
                ++count;
            } else {
                if (b == value && count < 63)
                    ++count;
                else {
                    FLUSH();
                    count = 1;
                    value = b;
                }
            }
        }
    }

    if (count > 0) {
        if (count == 1)
            *level++ = 0x40 | value;
        else {
            *level++ = count;
            *level++ = value;
        }
    }

    *level = 0;

    fprintf(f, "%s_size = 0x4000 + %d\n", name, (int)(level - start));
    while (level > start)
        fprintf(f, "db 0x%02X\n", *--level);
}

char tmp[6912];
char tmp2[6912];
char tmp3[6912];

void LoadData(void)
{
    char buf[256] = __FILE__;
    strcat(buf, ".scr");
    f = fopen(buf, "rb");
    if (!f)
        f = fopen("data.c.scr", "rb");
    fread(data, 1, 6912, f);
    fclose(f);

    strcpy(buf, __FILE__);
    for (char* p = buf; *p; ++p) {
        if (*p == '\\')
            *p = '/';
    }
    *(strrchr(buf, '/') + 1) = 0;
    strcat(buf, "coinz3b.scr");
    f = fopen(buf, "rb");
    fread(tmp, 1, 6912, f);
    fclose(f);
    *(strrchr(buf, '/') + 1) = 0;
    strcat(buf, "../asm/data_intro.asm");
    f = fopen(buf, "w");
    fprintf(f, "section data_intro\n");
    for (int i = 0; i < 6912; i++)
        fprintf(f, "db 0x%02X\n", (unsigned char)tmp[i]);
    fclose(f);

    strcpy(buf, __FILE__);
    for (char* p = buf; *p; ++p) {
        if (*p == '\\')
            *p = '/';
    }
    *(strrchr(buf, '/') + 1) = 0;
    strcat(buf, "win.scr");
    f = fopen(buf, "rb");
    fread(tmp, 1, 6912, f);
    fclose(f);
    *(strrchr(buf, '/') + 1) = 0;
    strcat(buf, "win2.scr");
    f = fopen(buf, "rb");
    fread(tmp2, 1, 6912, f);
    fclose(f);
    *(strrchr(buf, '/') + 1) = 0;
    strcat(buf, "../asm/data_win.asm");
    f = fopen(buf, "w");
    fprintf(f, "section data_win_1\n");
    fprintf(f, "Win1:\n");
    for (int y = 0; y < 64; y++) {
        fprintf(f, "db ");
        for (int x = 0; x < 8; x++) {
            fprintf(f, "0x%02X", (unsigned char)~tmp[ZXCOORD(x, y)]);
            if (x != 7)
                fprintf(f, ",");
        }
        fprintf(f, "\n");
    }
    fprintf(f, "section data_win_2\n");
    fprintf(f, "Win2:\n");
    for (int y = 0; y < 64; y++) {
        fprintf(f, "db ");
        for (int x = 0; x < 8; x++) {
            fprintf(f, "0x%02X", (unsigned char)~tmp2[ZXCOORD(x, y)]);
            if (x != 7)
                fprintf(f, ",");
        }
        fprintf(f, "\n");
    }
    fclose(f);

    strcpy(buf, __FILE__);
    for (char* p = buf; *p; ++p) {
        if (*p == '\\')
            *p = '/';
    }
    *(strrchr(buf, '/') + 1) = 0;
    strcat(buf, "../music/beeper-std.bin");
    f = fopen(buf, "rb");
    size_t beeperLen = fread(tmp, 1, 6912, f);
    fclose(f);

    *(strrchr(buf, '/') + 1) = 0;
    strcat(buf, "../asm/data_beeper.asm");
    f = fopen(buf, "w");
    fprintf(f, "section beeper\n");
    for (size_t i = 0; i < beeperLen; i++)
        fprintf(f, "db 0x%02X\n", (unsigned char)tmp[i]);
    fclose(f);

    *(strrchr(buf, '/') + 1) = 0;
    strcat(buf, "../proto/nq-Old-School-Threads.pt3");
    f = fopen(buf, "rb");
    size_t pt3Len = fread(tmp, 1, 6912, f);
    fclose(f);

    *(strrchr(buf, '/') + 1) = 0;
    strcat(buf, "nq-Old-School-Threads.pt3");
    f = fopen(buf, "rb");
    size_t pt3Len2 = fread(tmp2, 1, 6912, f);
    fclose(f);

    *(strrchr(buf, '/') + 1) = 0;
    strcat(buf, "nq-Coinz-are-mine-menu.pt3");
    f = fopen(buf, "rb");
    size_t pt3Len3 = fread(tmp3, 1, 6912, f);
    fclose(f);

    size_t maxLen = pt3Len;
    if (pt3Len2 > maxLen)
        maxLen = pt3Len2;
    if (pt3Len3 > maxLen)
        maxLen = pt3Len3;

    *(strrchr(buf, '/') + 1) = 0;
    strcat(buf, "../asm/data_pt3.asm");
    f = fopen(buf, "w");
    fprintf(f, "section bss_music\n");
    fprintf(f, "MusicBuffer:\n");
    fprintf(f, "repeat %d\n", (int)maxLen);
    fprintf(f, "db 0\n");
    fprintf(f, "endrepeat\n");
    fprintf(f, "section pt3_game\n");
    fprintf(f, "GamePT3:\n");
    for (size_t i = 100; i < pt3Len; i++)
        fprintf(f, "db 0x%02X\n", (unsigned char)tmp[i]);
    fprintf(f, "section pt3_win\n");
    fprintf(f, "WinPT3:\n");
    for (size_t i = 100; i < pt3Len2; i++)
        fprintf(f, "db 0x%02X\n", (unsigned char)tmp2[i]);
    fprintf(f, "section pt3_menu\n");
    fprintf(f, "MenuPT3:\n");
    for (size_t i = 100; i < pt3Len3; i++)
        fprintf(f, "db 0x%02X\n", (unsigned char)tmp3[i]);
    fclose(f);

    *(strrchr(buf, '/') + 1) = 0;
    strcat(buf, "data_levels.asm");
    f = fopen(buf, "w");

    GenerateLevel("level2", "Level2", Level1, Level2Data, Level2Chains);
    GenerateLevel("level3", "Level3", Level1, Level3Data, Level3Chains);
    GenerateLevel("level4", "Level4", Level1, Level4Data, Level4Chains);
    GenerateLevel("level5", "Level5", Level1, Level5Data, Level5Chains);
    GenerateLevel("level6", "Level6", Level1, Level6Data, Level6Chains);
    GenerateLevel("level7", "Level7", Level1, Level7Data, Level7Chains);
    GenerateLevel("level8", "Level8", Level1, Level8Data, Level8Chains);
    GenerateLevel("level9", "Level9", Level1, Level9Data, Level9Chains);
    GenerateLevel("level10", "Level10", Level1, Level10Data, Level10Chains);
    GenerateLevel("level11", "Level11", Level1, Level11Data, Level11Chains);
    GenerateLevel("level12", "Level12", Level1, Level12Data, Level12Chains);
    GenerateLevel("level13", "Level13", Level1, Level13Data, Level13Chains);
    GenerateLevel("level14", "Level14", Level1, Level14Data, Level14Chains);
    GenerateLevel("level15", "Level15", Level1, Level15Data, Level15Chains);
    GenerateLevel("level16", "Level16", Level1, Level16Data, Level16Chains);
    GenerateLevel("level17", "Level17", Level1, Level17Data, Level17Chains);

    GenerateLevel("pvpLevel1", "PvpLevel1", Level1, PvpLevel1Data, PvpLevel1Chains);
    GenerateLevel("pvpLevel2", "PvpLevel2", Level1, PvpLevel2Data, PvpLevel2Chains);
    GenerateLevel("pvpLevel3", "PvpLevel3", Level1, PvpLevel3Data, PvpLevel3Chains);
    GenerateLevel("pvpLevel4", "PvpLevel4", Level1, PvpLevel4Data, PvpLevel4Chains);

    GenerateLevel("level1", "Level1", Level1, Level1Data, Level1Chains);

    fclose(f);
    
    *(strrchr(buf, '/') + 1) = 0;
    strcat(buf, "data_gfx.asm");
    f = fopen(buf, "w");

    fprintf(f, "section data_gfx\n");
    fprintf(f, "\nSPRITE_EMPTY = 0\n");
    fprintf(f, "Empty:\n");
    fprintf(f, "db 0, 0, 0, 0, 0, 0, 0, 0\n");

    GetSprite("Bricks", Bricks, 0, 16);//64, 24);
    GetSprite("Bricks1", Bricks1,  0, 24);
    GetSprite("Bricks2", Bricks2,  8, 24);
    GetSprite("Bricks3", Bricks3, 16, 24);
    GetSprite("Bricks4", Bricks4, 24, 24);
    GetSprite("Bricks5", Bricks5, 32, 24);
    GetSprite("Bricks6", Bricks6, 40, 24);
    GetSprite("Stones1", Stones1, 0, 32);
    GetSprite("Stones2", Stones2, 8, 32);

    GetSprite("CoinLeft", AppleLeft, 72, 128);
    GetSprite("CoinTopLeft", AppleTopLeft, 72, 120);
    GetSprite("CoinTop", AppleTop, 112, 120);
    GetSprite("CoinTop1", AppleTop1, 80, 120);
    GetSprite("CoinTop2", AppleTop2, 96, 120);
    GetSprite("CoinTopRight", AppleTopRight, 88, 120);
    GetSprite("CoinRight", AppleRight, 88, 128);

    GetSprite("Coin1", Apple1, 32, 152);
    GetSprite("Coin2", Apple2, 40, 152);
    GetSprite("Coin3", Apple3, 48, 152);
    GetSprite("Coin4", Apple4, 56, 152);

    GetMirrorSprite("PlayerLeft1", PlayerLeft1, 32, 128);
    GetMirrorSprite("PlayerLeft2", PlayerLeft2, 40, 128); 
    GetMirrorSprite("PlayerLeft3", PlayerLeft3, 48, 128);
    GetMirrorSprite("PlayerLeft4", PlayerLeft4, 56, 128);
    GetMirrorSprite("PlayerLeft5", PlayerLeft5, 64, 128);
    GetMirrorSprite("PlayerLeftJump", PlayerLeftJump, 24, 128);
    GetSprite("PlayerRight1", PlayerRight1, 32, 128);
    GetSprite("PlayerRight2", PlayerRight2, 40, 128); 
    GetSprite("PlayerRight3", PlayerRight3, 48, 128);
    GetSprite("PlayerRight4", PlayerRight4, 56, 128);
    GetSprite("PlayerRight5", PlayerRight5, 64, 128);
    GetSprite("PlayerRightJump", PlayerRightJump, 24, 128);

    GetMirrorSprite("PlayerHandsLeft1", PlayerHandsLeft1, 32, 136);
    GetMirrorSprite("PlayerHandsLeft2", PlayerHandsLeft2, 40, 136); 
    GetMirrorSprite("PlayerHandsLeft3", PlayerHandsLeft3, 48, 136);
    GetMirrorSprite("PlayerHandsLeft4", PlayerHandsLeft4, 56, 136);
    GetMirrorSprite("PlayerHandsLeft5", PlayerHandsLeft5, 64, 136);
    GetMirrorSprite("PlayerHandsLeftJump", PlayerHandsLeftJump, 24, 136);
    GetSprite("PlayerHandsRight1", PlayerHandsRight1, 32, 136);
    GetSprite("PlayerHandsRight2", PlayerHandsRight2, 40, 136); 
    GetSprite("PlayerHandsRight3", PlayerHandsRight3, 48, 136);
    GetSprite("PlayerHandsRight4", PlayerHandsRight4, 56, 136);
    GetSprite("PlayerHandsRight5", PlayerHandsRight5, 64, 136);
    GetSprite("PlayerHandsRightJump", PlayerHandsRightJump, 24, 136);

    GetMirrorSprite("PlayerGunLeft1", PlayerGunLeft1, 32, 120);
    GetMirrorSprite("PlayerGunLeft2", PlayerGunLeft2, 40, 120); 
    GetMirrorSprite("PlayerGunLeft3", PlayerGunLeft3, 48, 120);
    GetMirrorSprite("PlayerGunLeft4", PlayerGunLeft4, 56, 120);
    GetMirrorSprite("PlayerGunLeft5", PlayerGunLeft5, 64, 120);
    GetMirrorSprite("PlayerGunLeftJump", PlayerGunLeftJump, 24, 120);
    GetSprite("PlayerGunRight1", PlayerGunRight1, 32, 120);
    GetSprite("PlayerGunRight2", PlayerGunRight2, 40, 120); 
    GetSprite("PlayerGunRight3", PlayerGunRight3, 48, 120);
    GetSprite("PlayerGunRight4", PlayerGunRight4, 56, 120);
    GetSprite("PlayerGunRight5", PlayerGunRight5, 64, 120);
    GetSprite("PlayerGunRightJump", PlayerGunRightJump, 24, 120);

    GetMirrorSprite("PlayerDead1Left", PlayerDead1Left, 16, 144);
    GetMirrorSprite("PlayerDead2Left", PlayerDead2Left, 24, 144);
    GetMirrorSprite("PlayerDead3Left", PlayerDead3Left, 32, 144);
    GetSprite("PlayerDead1Right", PlayerDead1Right, 16, 144);
    GetSprite("PlayerDead2Right", PlayerDead2Right, 24, 144);
    GetSprite("PlayerDead3Right", PlayerDead3Right, 32, 144);

    GetMirrorSprite("PlayerDuckLeft", PlayerDuckLeft, 8, 128);
    GetMirrorSprite("PlayerHandsDuckLeft", PlayerHandsDuckLeft, 8, 136);
    GetMirrorSprite("PlayerGunDuckLeft", PlayerGunDuckLeft, 8, 120);
    GetSprite("PlayerDuckRight", PlayerDuckRight, 8, 128);
    GetSprite("PlayerHandsDuckRight", PlayerHandsDuckRight, 8, 136);
    GetSprite("PlayerGunDuckRight", PlayerGunDuckRight, 8, 120);

    GetSprite("Stone", Stone, 0, 8);

    GetMirrorSprite("GhostLeft1", GhostLeft1, 112, 96);
    GetMirrorSprite("GhostLeft2", GhostLeft2, 120, 96);
    GetMirrorSprite("GhostLeft3", GhostLeft3, 128, 96);
    GetMirrorSprite("GhostLeft4", GhostLeft4, 136, 96);
    GetSprite("GhostRight1", GhostRight1, 112, 96);
    GetSprite("GhostRight2", GhostRight2, 120, 96);
    GetSprite("GhostRight3", GhostRight3, 128, 96);
    GetSprite("GhostRight4", GhostRight4, 136, 96);

    GetSprite("GhostAppear1", GhostAppear1, 136, 104);
    GetSprite("GhostAppear2", GhostAppear2, 128, 104);
    GetSprite("GhostAppear3", GhostAppear3, 128, 112);
    GetSprite("GhostAppear4", GhostAppear4, 120, 104);

    GetSprite("GhostDeath1", GhostDeath1, 112, 80);
    GetSprite("GhostDeath2", GhostDeath2, 120, 80);
    GetSprite("GhostDeath3", GhostDeath3, 128, 80);
    GetSprite("GhostDeath4", GhostDeath4, 136, 80);

    GetSprite("Weapon1", Weapon1,  80, 160);
    GetSprite("Weapon2", Weapon2,  88, 160);
    GetSprite("Weapon3", Weapon3,  96, 160);
    GetSprite("Weapon4", Weapon4, 104, 160);
    GetSprite("Weapon5", Weapon5, 112, 160);
    GetSprite("Weapon6", Weapon6, 120, 160);

    GetMirrorSprite("BatLeft1", BatLeft1, 112, 48);
    GetMirrorSprite("BatLeft2", BatLeft2, 120, 48);
    GetMirrorSprite("BatLeft3", BatLeft3, 128, 48);
    GetMirrorSprite("BatLeft4", BatLeft4, 136, 48);
    GetSprite("BatRight1", BatRight1, 112, 48);
    GetSprite("BatRight2", BatRight2, 120, 48);
    GetSprite("BatRight3", BatRight3, 128, 48);
    GetSprite("BatRight4", BatRight4, 136, 48);

    GetSprite("BatFall1", BatFall1, 144, 48);
    GetSprite("BatFall2", BatFall2, 152, 48);
    GetSprite("BatRevive", BatRevive, 160, 48);

    GetMirrorSprite("FlowerLeft1", FlowerLeft1, 112, 56);
    GetMirrorSprite("FlowerLeft2", FlowerLeft2, 120, 56);
    GetMirrorSprite("FlowerLeft3", FlowerLeft3, 128, 56);
    GetMirrorSprite("FlowerLeft4", FlowerLeft4, 136, 56);
    GetSprite("FlowerRight1", FlowerRight1, 112, 56);
    GetSprite("FlowerRight2", FlowerRight2, 120, 56);
    GetSprite("FlowerRight3", FlowerRight3, 128, 56);
    GetSprite("FlowerRight4", FlowerRight4, 136, 56);

    GetMirrorSprite("FlowerDeathRight1", FlowerDeathRight1, 144, 56);
    GetMirrorSprite("FlowerDeathRight2", FlowerDeathRight2, 152, 56);
    GetMirrorSprite("FlowerReviveRight", FlowerReviveRight, 160, 56);
    GetSprite("FlowerDeathLeft1", FlowerDeathLeft1, 144, 56);
    GetSprite("FlowerDeathLeft2", FlowerDeathLeft2, 152, 56);
    GetSprite("FlowerReviveLeft", FlowerReviveLeft, 160, 56);

    GetSprite("BorderTopLeft",      BorderTopLeft,      160, 8);
    GetSprite("BorderTopCenter",    BorderTopCenter,    168, 8);
    GetSprite("BorderTopRight",     BorderTopRight,     176, 8);
    GetSprite("BorderLeft",         BorderLeft,         160, 16);
    GetSprite("BorderRight",        BorderRight,        176, 16);
    GetSprite("BorderBottomLeft",   BorderBottomLeft,   160, 24);
    GetSprite("BorderBottomCenter", BorderBottomCenter, 168, 24);
    GetSprite("BorderBottomRight",  BorderBottomRight,  176, 24);

    GetSprite("Border1TopLeft",      Border1TopLeft,      184, 8);
    GetSprite("Border1TopCenter",    Border1TopCenter,    192, 8);
    GetSprite("Border1TopRight",     Border1TopRight,     200, 8);
    GetSprite("Border1Left",         Border1Left,         184, 16);
    GetSprite("Border1Right",        Border1Right,        200, 16);
    GetSprite("Border1BottomLeft",   Border1BottomLeft,   168, 80);
    GetSprite("Border1BottomCenter", Border1BottomCenter, 192, 24);
    GetSprite("Border1BottomRight",  Border1BottomRight,  240, 80);

    GetSprite("Chains1", Chains1, 88, 16);
    GetSprite("Chains2", Chains2, 96, 16);
    GetSprite("Mushroom1", Mushroom1, 56, 72);
    GetSprite("Mushroom2", Mushroom2, 72, 72);

    GetSprite("Gates1_1", Gates1_1, 24, 56);
    GetSprite("Gates1_2", Gates1_2, 24, 64);
    GetSprite("Gates2_1", Gates2_1, 32, 56);
    GetSprite("Gates2_2", Gates2_2, 32, 64);
    GetSprite("Gates3_1", Gates3_1, 40, 56);
    GetSprite("Gates3_2", Gates3_2, 40, 64);
    GetSprite("Gates4_1", Gates4_1, 48, 56);
    GetSprite("Gates4_2", Gates4_2, 48, 64);

    GetSprite("SwitchOff", SwitchOff, 48, 16);
    GetSprite("SwitchOn", SwitchOff, 56, 16);

    fclose(f);
}
