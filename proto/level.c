#include "proto.h"

typedef struct Tile { const byte* image; byte attr; } Tile;

const Tile AppleTopTile  = { AppleTop,  PASSABLE_ATTR };
const Tile AppleTop1Tile = { AppleTop1, PASSABLE_ATTR };
const Tile AppleTop2Tile = { AppleTop2, PASSABLE_ATTR };

static Tile Tiles[] = {
        { Empty,            PASSABLE_ATTR },    /* 0 */
        { Bricks,           0x57 },             /* 1 */
        { AppleTopLeft,     PASSABLE_ATTR },    /* 2 */
        { AppleTopRight,    PASSABLE_ATTR },    /* 3 */
        { AppleLeft,        PASSABLE_ATTR },    /* 4 */
        { AppleRight,       PASSABLE_ATTR },    /* 5 */
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
            if (value < 0x80)
                DrawTile(x, y, &Tiles[value]);
            else {
                switch (value & 0x7f) {
                    case PLAYER_1_START:
                        InitPhysObject(&player1.phys, x << 3, y << 3);
                        DrawTile(x, y, &Tiles[0]);
                        break;
                    case PLAYER_2_START:
                        InitPhysObject(&player2.phys, x << 3, y << 3);
                        DrawTile(x, y, &Tiles[0]);
                        break;
                    case PLAYER_1_APPLE:
                        if (SinglePlayer)
                            DrawTile(x, y, &Tiles[0]);
                        else
                            PlaceItem(x << 3, y << 3, Apple1, APPLE1_ATTR);
                        break;
                    case PLAYER_2_APPLE:
                        PlaceItem(x << 3, y << 3, Apple1, APPLE2_ATTR);
                        break;
                    case PLAYER_1_TOP:
                        player1.gatesX = (x << 3) - 8;
                        player1.gatesY = (y << 3) + 8;
                        DrawTile(x, y, (SinglePlayer ? &AppleTopTile : &AppleTop1Tile));
                        break;
                    case PLAYER_2_TOP:
                        player2.gatesX = (x << 3) - 8;
                        player2.gatesY = (y << 3) + 8;
                        DrawTile(x, y, (SinglePlayer ? &AppleTopTile : &AppleTop2Tile));
                        break;
                }
            }

            if (++x == 32) {
                x = 0;
                ++y;
            }
        }
    }
}
