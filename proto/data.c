#include "proto.h"
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

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

byte PlayerLeftJump[8];
byte PlayerRightJump[8];
byte PlayerHandsLeftJump[8];
byte PlayerHandsRightJump[8];

byte Empty[8];
byte Bricks[8];

byte AppleLeft[8];
byte AppleTopLeft[8];
byte AppleTop[8];
byte AppleTop1[8];
byte AppleTop2[8];
byte AppleTopRight[8];
byte AppleRight[8];
byte Apple1[8];

byte Level1[1024];

static byte data[6912];

static void GetSprite(byte* dst, byte x, byte y)
{
    for (int i = 0; i < 8; i++)
        *dst++ = data[ZXCOORD((x >> 3), (y + i))];
}

static void GetMirrorSprite(byte* dst, byte x, byte y)
{
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
    }
}

static const char* Level1Data[] = {
      /* 01234567890123456789012345678901 */
        "################################", /*  0 */
        "#                           ---#", /*  1 */
        "#                          2|A|#", /*  2 */
        "#          ####        #########", /*  3 */
        "#                ####          #", /*  4 */
        "#       ##                     #", /*  5 */
        "#                              #", /*  6 */
        "#   ##                         #", /*  7 */
        "#                              #", /*  8 */
        "#      ###                     #", /*  9 */
        "#                              #", /* 10 */
        "#           ##                 #", /* 11 */
        "#                ##   ###      #", /* 12 */
        "#                              #", /* 13 */
        "#           ###            #   #", /* 14 */
        "#                              #", /* 15 */
        "#                      ###     #", /* 16 */
        "#                              #", /* 17 */
        "#                 ##           #", /* 18 */
        "#---                           #", /* 19 */
        "#|A|1       #                  #", /* 20 */
        "################################", /* 21 */
    };

static void GenerateLevel(byte* level, const char* const* data)
{
    byte count = 0;
    byte value;

    for (int y = 0; y < LEVEL_HEIGHT; y++) {
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
                
                if (count > 0) {
                    *level++ = count;
                    *level++ = value;
                    count = 0;
                }

                *level++ = 1; *level++ = 2;
                *level++ = 1; *level++ = 0x80 | (num == 1 ? PLAYER_1_TOP : PLAYER_2_TOP);
                *level++ = 1; *level++ = 3;

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

                if (count > 0) {
                    *level++ = count;
                    *level++ = value;
                    count = 0;
                }

                *level++ = 1; *level++ = 4;
                *level++ = 1; *level++ = 0x80 | (num == 1 ? PLAYER_1_APPLE : PLAYER_2_APPLE);
                *level++ = 1; *level++ = 5;

                x += 2;
                continue;
            }

            switch (data[y][x]) {
                case ' ': b = 0; break;
                case '-': b = 0; break;
                case '#': b = 1; break;
                case '1': b = 0x80 | PLAYER_1_START; break;
                case '2': b = 0x80 | PLAYER_2_START; break;
                default: abort();
            }

            if (count == 0) {
                value = b;
                ++count;
            } else {
                if (b == value && count < 127)
                    ++count;
                else {
                    *level++ = count;
                    *level++ = value;
                    count = 1;
                    value = b;
                }
            }
        }
    }

    if (count > 0) {
        *level++ = count;
        *level++ = value;
    }

    *level = 0;
}

void LoadData(void)
{
    char buf[256] = __FILE__;
    strcat(buf, ".scr");
    FILE* f = fopen(buf, "rb");
    if (!f)
        f = fopen("data.c.scr", "rb");
    fread(data, 1, 6912, f);
    fclose(f);

    GetSprite(Bricks, 64, 24);
    GetSprite(AppleLeft, 72, 128);
    GetSprite(AppleTopLeft, 72, 120);
    GetSprite(AppleTop, 112, 120);
    GetSprite(AppleTop1, 80, 120);
    GetSprite(AppleTop2, 96, 120);
    GetSprite(AppleTopRight, 88, 120);
    GetSprite(AppleRight, 88, 128);

    GetSprite(Apple1, 80, 128);

    GenerateLevel(Level1, Level1Data);

    GetMirrorSprite(PlayerLeft1, 32, 128);
    GetMirrorSprite(PlayerLeft2, 40, 128); 
    GetMirrorSprite(PlayerLeft3, 48, 128);
    GetMirrorSprite(PlayerLeft4, 56, 128);
    GetMirrorSprite(PlayerLeft5, 64, 128);
    GetMirrorSprite(PlayerLeftJump, 24, 128);
    GetSprite(PlayerRight1, 32, 128);
    GetSprite(PlayerRight2, 40, 128); 
    GetSprite(PlayerRight3, 48, 128);
    GetSprite(PlayerRight4, 56, 128);
    GetSprite(PlayerRight5, 64, 128);
    GetSprite(PlayerRightJump, 24, 128);

    GetMirrorSprite(PlayerHandsLeft1, 32, 136);
    GetMirrorSprite(PlayerHandsLeft2, 40, 136); 
    GetMirrorSprite(PlayerHandsLeft3, 48, 136);
    GetMirrorSprite(PlayerHandsLeft4, 56, 136);
    GetMirrorSprite(PlayerHandsLeft5, 64, 136);
    GetMirrorSprite(PlayerHandsLeftJump, 24, 136);
    GetSprite(PlayerHandsRight1, 32, 136);
    GetSprite(PlayerHandsRight2, 40, 136); 
    GetSprite(PlayerHandsRight3, 48, 136);
    GetSprite(PlayerHandsRight4, 56, 136);
    GetSprite(PlayerHandsRight5, 64, 136);
    GetSprite(PlayerHandsRightJump, 24, 136);
}
