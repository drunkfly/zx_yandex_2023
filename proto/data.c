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

byte PlayerLeftJump[8];
byte PlayerRightJump[8];

byte Empty[8];
byte Bricks[8];

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
        "#                              #", /*  1 */
        "#                              #", /*  2 */
        "#                              #", /*  3 */
        "#                              #", /*  4 */
        "#                              #", /*  5 */
        "#                              #", /*  6 */
        "#                              #", /*  7 */
        "#                              #", /*  8 */
        "#                              #", /*  9 */
        "#                              #", /* 10 */
        "#                              #", /* 11 */
        "#                #    #        #", /* 12 */
        "#            2                 #", /* 13 */
        "#           ###            #   #", /* 14 */
        "#                              #", /* 15 */
        "#                      ###     #", /* 16 */
        "#                              #", /* 17 */
        "#                 ##           #", /* 18 */
        "#                              #", /* 19 */
        "#  1        #                  #", /* 20 */
        "################################", /* 21 */
    };

static void GenerateLevel(byte* level, const char* const* data)
{
    byte count = 0;
    byte value;

    for (int y = 0; y < LEVEL_HEIGHT; y++) {
        for (int x = 0; x < LEVEL_WIDTH; x++) {
            byte b;
            switch (data[y][x]) {
                case ' ': b = 0; break;
                case '#': b = 1; break;
                case '1': b = 254; break;
                case '2': b = 255; break;
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
    fread(data, 1, 6912, f);
    fclose(f);

    GetSprite(Bricks, 64, 24);

    GenerateLevel(Level1, Level1Data);

    GetMirrorSprite(PlayerLeft1, 32, 112);
    GetMirrorSprite(PlayerLeft2, 40, 112); 
    GetMirrorSprite(PlayerLeft3, 48, 112);
    GetMirrorSprite(PlayerLeft4, 56, 112);
    GetMirrorSprite(PlayerLeft5, 64, 112);
    GetMirrorSprite(PlayerLeftJump, 64, 96);
    GetSprite(PlayerRight1, 32, 112);
    GetSprite(PlayerRight2, 40, 112); 
    GetSprite(PlayerRight3, 48, 112);
    GetSprite(PlayerRight4, 56, 112);
    GetSprite(PlayerRight5, 64, 112);
    GetSprite(PlayerRightJump, 64, 96);
}
