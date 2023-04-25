#include "proto.h"
#include <stdlib.h>

typedef struct Tile { const byte* image; byte attr; } Tile;

enum {
BRICKS_ATTR = 0x02,
BRICKS2_ATTR = 0x03,
BRICKS3_ATTR = 0x05,
BRICKS4_ATTR = 0x06,
STONES1_ATTR = 0x42,
STONES2_ATTR = 0x43,
STONES3_ATTR = 0x45,
STONES4_ATTR = 0x46,
};

const Tile AppleTopTile  = { AppleTop,  PASSABLE_ATTR };
const Tile AppleTop1Tile = { AppleTop1, PASSABLE_ATTR };
const Tile AppleTop2Tile = { AppleTop2, PASSABLE_ATTR };

static Tile Tiles[] = {
        { Empty,            PASSABLE_ATTR },    /* 0 */
        { Bricks,           BRICKS_ATTR },      /* 1 */
        { AppleTopLeft,     PASSABLE_ATTR },    /* 2 */
        { AppleTopRight,    PASSABLE_ATTR },    /* 3 */
        { AppleLeft,        PASSABLE_ATTR },    /* 4 */
        { AppleRight,       PASSABLE_ATTR },    /* 5 */
        { Bricks5,          BRICKS_ATTR },      /* 6 */
        { Bricks6,          BRICKS_ATTR },      /* 7 */
        { Bricks1,          BRICKS_ATTR },      /* 8 */
        { Bricks4,          BRICKS_ATTR },      /* 9 */
        { Bricks2,          BRICKS_ATTR },      /* 10 */
        { Bricks3,          BRICKS_ATTR },      /* 11 */
        { Bricks5,          BRICKS2_ATTR },     /* 12 */
        { Bricks6,          BRICKS2_ATTR },     /* 13 */
        { Bricks1,          BRICKS2_ATTR },     /* 14 */
        { Bricks4,          BRICKS2_ATTR },     /* 15 */
        { Bricks2,          BRICKS2_ATTR },     /* 16 */
        { Bricks3,          BRICKS2_ATTR },     /* 17 */
        { Stones1,          STONES1_ATTR },     /* 18 */
        { Stones2,          STONES1_ATTR },     /* 19 */
        { Bricks5,          BRICKS3_ATTR },     /* 20 */
        { Bricks6,          BRICKS3_ATTR },     /* 21 */
        { Bricks1,          BRICKS3_ATTR },     /* 22 */
        { Bricks4,          BRICKS3_ATTR },     /* 23 */
        { Bricks2,          BRICKS3_ATTR },     /* 24 */
        { Bricks3,          BRICKS3_ATTR },     /* 25 */
        { Bricks5,          BRICKS4_ATTR },     /* 26 */
        { Bricks6,          BRICKS4_ATTR },     /* 27 */
        { Bricks1,          BRICKS4_ATTR },     /* 28 */
        { Bricks4,          BRICKS4_ATTR },     /* 29 */
        { Bricks2,          BRICKS4_ATTR },     /* 30 */
        { Bricks3,          BRICKS4_ATTR },     /* 31 */
        { Stones1,          STONES2_ATTR },     /* 32 */
        { Stones2,          STONES2_ATTR },     /* 33 */
        { Stones1,          STONES3_ATTR },     /* 34 */
        { Stones2,          STONES3_ATTR },     /* 35 */
        { Stones1,          STONES4_ATTR },     /* 36 */
        { Stones2,          STONES4_ATTR },     /* 37 */
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
    byte x = 0, y = LEVEL_HEIGHT - 1;

    for (;;) {
        byte count = *level++;

        if (count == 0)
            break;

        if ((count & 0x40) != 0) {
            DrawTile(x, y, &Tiles[count & 0x3f]);
            goto cont;
        }

        if ((count & 0x80) != 0) {
            switch (count & 0x7f) {
                case PLAYER_1_START:
                    player1.originalX = x << 3;
                    player1.originalY = y << 3;
                    InitPhysObject(&player1.phys, player1.originalX, player1.originalY);
                    DrawTile(x, y, &Tiles[0]);
                    break;
                case PLAYER_2_START:
                    player2.originalX = x << 3;
                    player2.originalY = y << 3;
                    InitPhysObject(&player2.phys, player2.originalX, player2.originalY);
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
                case STONE:
                    PlaceItem(x << 3, y << 3, Stone, STONE_ATTR);
                    break;
                case GHOST:
                    DrawTile(x, y, &Tiles[0]);
                    SpawnEnemy(x << 3, y << 3, GhostSprites);
                    break;
            }
          cont:
            if (++x == 32) {
                x = 0;
                --y;
            }
            continue;
        }

        byte value = *level++;
        while (count-- > 0) {
            byte id = value;
            if (value == 6 || value == 10 || value == 12 || value == 16 || value == 18
                    || value == 20 || value == 24 || value == 26 || value == 30 || value == 32
                    || value == 34 || value == 36) {
                if (rand() % 2 == 0)
                    value++;
            }
            DrawTile(x, y, &Tiles[value]);
            if (++x == 32) {
                x = 0;
                --y;
            }
        }
    }
}
