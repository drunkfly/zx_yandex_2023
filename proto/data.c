#include "proto.h"
#include <string.h>
#include <stdio.h>

byte PlayerLeft1[8];
byte PlayerLeft2[8];
byte PlayerLeft3[8];
byte PlayerLeft4[8];
byte PlayerRight1[8];
byte PlayerRight2[8];
byte PlayerRight3[8];
byte PlayerRight4[8];

byte PlayerLeftJump[8];
byte PlayerRightJump[8];

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

void LoadData(void)
{
    char buf[256] = __FILE__;
    strcat(buf, ".scr");
    FILE* f = fopen(buf, "rb");
    fread(data, 1, 6912, f);
    fclose(f);
    GetMirrorSprite(PlayerLeft1, 32, 96);
    GetMirrorSprite(PlayerLeft2, 40, 96); 
    GetMirrorSprite(PlayerLeft3, 48, 96);
    GetMirrorSprite(PlayerLeft4, 56, 96);
    GetMirrorSprite(PlayerLeftJump, 64, 96);
    GetSprite(PlayerRight1, 32, 96);
    GetSprite(PlayerRight2, 40, 96); 
    GetSprite(PlayerRight3, 48, 96);
    GetSprite(PlayerRight4, 56, 96);
    GetSprite(PlayerRightJump, 64, 96);
}
