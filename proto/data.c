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

static void GenerateLevel(const char* section, const char* name, byte* level, const char* const* data)
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
                    bool hasLeft = (x != 0 && data[y][x-1] == '&');
                    bool hasRight = (x < LEVEL_WIDTH-1 && data[y][x+1] == '&');
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
                case 'X': b = 18; break;
                case 'x': b = 32; break;
                case 'Y': b = 34; break;
                case 'y': b = 36; break;
                case '1': FLUSH(); *level++ = 0x80 | PLAYER_1_START; continue;
                case '2': FLUSH(); *level++ = 0x80 | PLAYER_2_START; continue;
                case 'O': FLUSH(); *level++ = 0x80 | STONE; continue;
                case 'G': FLUSH(); *level++ = 0x80 | GHOST; continue;
                case 'B': FLUSH(); *level++ = 0x80 | BAT; continue;
                case 'W': FLUSH(); *level++ = 0x80 | WEAPON; continue;
                case 'F': FLUSH(); *level++ = 0x80 | FLOWER_LEFT; continue;
                case 'f': FLUSH(); *level++ = 0x80 | FLOWER_RIGHT; continue;
                case 'L': FLUSH(); *level++ = 0x80 | FLOWER_AUTO; continue;
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

    *(strrchr(buf, '/') + 1) = 0;
    strcat(buf, "../asm/data_levels.asm");
    f = fopen(buf, "w");

    GenerateLevel("level1", "Level1", Level1, Level1Data);
    GenerateLevel("level2", "Level2", Level1, Level2Data);
    GenerateLevel("level3", "Level3", Level1, Level3Data);
    GenerateLevel("level4", "Level4", Level1, Level4Data);
    GenerateLevel("level5", "Level5", Level1, Level5Data);
    GenerateLevel("level6", "Level6", Level1, Level6Data);
    GenerateLevel("level7", "Level7", Level1, Level7Data);
    GenerateLevel("level8", "Level8", Level1, Level8Data);
    GenerateLevel("level9", "Level9", Level1, Level9Data);
    GenerateLevel("level10", "Level10", Level1, Level10Data);
    GenerateLevel("level11", "Level11", Level1, Level11Data);
    GenerateLevel("level12", "Level12", Level1, Level12Data);

    GenerateLevel("pvpLevel1", "PvpLevel1", Level1, PvpLevel1Data);
    GenerateLevel("pvpLevel2", "PvpLevel2", Level1, PvpLevel2Data);
    GenerateLevel("pvpLevel3", "PvpLevel3", Level1, PvpLevel3Data);
    GenerateLevel("pvpLevel4", "PvpLevel4", Level1, PvpLevel4Data);

    fclose(f);
    
    *(strrchr(buf, '/') + 1) = 0;
    strcat(buf, "../asm/data_gfx.asm");
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

    fclose(f);
}
