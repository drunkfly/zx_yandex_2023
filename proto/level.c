#include "proto.h"

typedef struct Tile { const byte* image; byte attr; } Tile;

static Tile Tiles[] = {
        { Empty,  PASSABLE_ATTR },
        { Bricks, 0x57 },
    };

static void DrawTile(byte x, byte y, const Tile* tile)
{
    y += LEVEL_Y;
    const byte* pixels = tile->image;
    for (byte yy = 0; yy < 8; yy++)
        SpectrumScreen[ZXCOORD(x, (y * 8 + yy))] ^= *pixels++;
    SpectrumScreen[6144 + (y * 32 + x)] = tile->attr;
}

void DrawLevel(const byte* level)
{
    byte x = 0, y = 0;

    for (;;) {
        byte count = *level++;
        if (count == 0)
            break;
        byte value = *level++;
        while (count-- > 0) {
            if (value == 254) {
                player1.x = x << 3;
                player1.y = y << 3;
                DrawTile(x, y, &Tiles[0]);
            } else if (value == 255) {
                player2.x = x << 3;
                player2.y = y << 3;
                DrawTile(x, y, &Tiles[0]);
            } else
                DrawTile(x, y, &Tiles[value]);

            if (++x == 32) {
                x = 0;
                ++y;
            }
        }
    }
}
