#include "proto.h"

void XorSprite0(byte x, byte y, const byte* pixels)
{
    for (byte yy = 0; yy < 8; yy++)
        SpectrumScreen[ZXCOORD(x, (y + yy))] ^= *pixels++;
}

void XorSprite1(byte x, byte y, const byte* pixels)
{
    for (byte yy = 0; yy < 8; yy++) {
        SpectrumScreen[ZXCOORD((x + 0), (y + yy))] ^= (*pixels >> 1) & 0x7f;
        SpectrumScreen[ZXCOORD((x + 1), (y + yy))] ^= (*pixels << 7) & 0x80;
        ++pixels;
    }
}

void XorSprite2(byte x, byte y, const byte* pixels)
{
    for (byte yy = 0; yy < 8; yy++) {
        SpectrumScreen[ZXCOORD((x + 0), (y + yy))] ^= (*pixels >> 2) & 0x3f;
        SpectrumScreen[ZXCOORD((x + 1), (y + yy))] ^= (*pixels << 6) & 0xc0;
        ++pixels;
    }
}

void XorSprite3(byte x, byte y, const byte* pixels)
{
    for (byte yy = 0; yy < 8; yy++) {
        SpectrumScreen[ZXCOORD((x + 0), (y + yy))] ^= (*pixels >> 3) & 0x1f;
        SpectrumScreen[ZXCOORD((x + 1), (y + yy))] ^= (*pixels << 5) & 0xe0;
        ++pixels;
    }
}

void XorSprite4(byte x, byte y, const byte* pixels)
{
    for (byte yy = 0; yy < 8; yy++) {
        SpectrumScreen[ZXCOORD((x + 0), (y + yy))] ^= (*pixels >> 4) & 0x0f;
        SpectrumScreen[ZXCOORD((x + 1), (y + yy))] ^= (*pixels << 4) & 0xf0;
        ++pixels;
    }
}

void XorSprite5(byte x, byte y, const byte* pixels)
{
    for (byte yy = 0; yy < 8; yy++) {
        SpectrumScreen[ZXCOORD((x + 0), (y + yy))] ^= (*pixels >> 5) & 0x07;
        SpectrumScreen[ZXCOORD((x + 1), (y + yy))] ^= (*pixels << 3) & 0xf8;
        ++pixels;
    }
}

void XorSprite6(byte x, byte y, const byte* pixels)
{
    for (byte yy = 0; yy < 8; yy++) {
        SpectrumScreen[ZXCOORD((x + 0), (y + yy))] ^= (*pixels >> 6) & 0x03;
        SpectrumScreen[ZXCOORD((x + 1), (y + yy))] ^= (*pixels << 2) & 0xfc;
        ++pixels;
    }
}

void XorSprite7(byte x, byte y, const byte* pixels)
{
    for (byte yy = 0; yy < 8; yy++) {
        SpectrumScreen[ZXCOORD((x + 0), (y + yy))] ^= (*pixels >> 7) & 0x01;
        SpectrumScreen[ZXCOORD((x + 1), (y + yy))] ^= (*pixels << 1) & 0xfe;
        ++pixels;
    }
}

void XorSprite(byte x, byte y, const byte* pixels)
{
    byte xx = x >> 3;
    switch (x & 7) {
        case 0: XorSprite0(xx, y, pixels); break;
        case 1: XorSprite1(xx, y, pixels); break;
        case 2: XorSprite2(xx, y, pixels); break;
        case 3: XorSprite3(xx, y, pixels); break;
        case 4: XorSprite4(xx, y, pixels); break;
        case 5: XorSprite5(xx, y, pixels); break;
        case 6: XorSprite6(xx, y, pixels); break;
        case 7: XorSprite7(xx, y, pixels); break;
    }
}
