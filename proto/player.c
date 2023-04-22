#include "proto.h"

#define IDLE 0
#define MOVING 1
#define JUMPING 2
#define FALLING 3

#define LEFT 0
#define RIGHT 1

Player player1;
Player player2;

static const byte* PlayerLeft[] = {
        PlayerLeft1,
        PlayerLeft2,
        PlayerLeft3,
        PlayerLeft4,
        PlayerLeft5,
    };

static const byte* PlayerRight[] = {
        PlayerRight1,
        PlayerRight2,
        PlayerRight3,
        PlayerRight4,
        PlayerRight5,
    };

static bool CanJumpUp(Player* player)
{
    if ((player->y & 7) != 0)
        return true;
    if (player->y == 0)
        return false;

    int off = 6144 + ((player->y >> 3) - 1 + LEVEL_Y) * 32 + (player->x >> 3);
    byte attr = SpectrumScreen[off];
    if (attr != PASSABLE_ATTR)
        return false;

    if ((player->x & 7) != 0) {
        byte attr = SpectrumScreen[off + 1];
        if (attr != PASSABLE_ATTR)
            return false;
    }

    return true;
}

static bool CanFallDown(Player* player)
{
    if ((player->y & 7) != 0)
        return true;
    if (player->y >= (LEVEL_HEIGHT * 8) - 8)
        return false;

    int off = 6144 + ((player->y >> 3) + 1 + LEVEL_Y) * 32 + (player->x >> 3);
    byte attr = SpectrumScreen[off];
    if (attr != PASSABLE_ATTR)
        return false;

    if ((player->x & 7) != 0) {
        byte attr = SpectrumScreen[off + 1];
        if (attr != PASSABLE_ATTR)
            return false;
    }

    return true;
}

static bool CanGoLeft(Player* player)
{
    if ((player->x & 7) != 0)
        return true;
    if (player->x == 0)
        return false;

    int off = 6144 + ((player->y >> 3) + LEVEL_Y) * 32 + (player->x >> 3) - 1;
    byte attr = SpectrumScreen[off];
    if (attr != PASSABLE_ATTR)
        return false;

    if ((player->y & 7) != 0) {
        byte attr = SpectrumScreen[off + 32];
        if (attr != PASSABLE_ATTR)
            return false;
    }

    return true;
}

static bool CanGoRight(Player* player)
{
    if ((player->x & 7) != 0)
        return true;
    if (player->x >= (LEVEL_WIDTH * 8) - 8)
        return false;

    int off = 6144 + ((player->y >> 3) + LEVEL_Y) * 32 + (player->x >> 3) + 1;
    byte attr = SpectrumScreen[off];
    if (attr != PASSABLE_ATTR)
        return false;

    if ((player->y & 7) != 0) {
        byte attr = SpectrumScreen[off + 32];
        if (attr != PASSABLE_ATTR)
            return false;
    }

    return true;
}

static bool MoveLeftRight(Player* player)
{
    if (KeyPressed[KEY_LEFT]) {
        if (CanGoLeft(player))
            --player->x;
        player->dir = LEFT;
        return true;
    }
    if (KeyPressed[KEY_RIGHT]) {
        if (CanGoRight(player))
            ++player->x;
        player->dir = RIGHT;
        return true;
    }
    return false;
}

static void FallDown(Player* player)
{
    player->accel += 0x08;
    for (byte i = 0; i < ((player->accel >> 5) & 7); i++) {
        if (!CanFallDown(player))
            return;
        player->y += 1;
    }
}

void DoPlayer(Player* player)
{
    byte oldX = player->x;
    byte oldY = player->y;

    bool onGround = true;
    if (CanFallDown(player))
        onGround = false;
    else
        player->accel = 0;

    switch (player->state) {
        case IDLE:
        case MOVING:
        idle:
            player->state = IDLE;
            if (MoveLeftRight(player))
                player->state = MOVING;
            if (!onGround)
                FallDown(player);
            else {
                if (KeyPressed[KEY_UP]) {
                    player->state = JUMPING;
                    player->speed = 4 << 5;
                    player->decel = 0x01;
                }
            }
            break;

        case FALLING:
        falling:
            if (onGround)
                goto idle;
            FallDown(player);
            MoveLeftRight(player);
            break;

        case JUMPING:
            if (player->speed <= player->decel) {
                player->state = FALLING;
                goto falling;
            }
            player->speed -= player->decel;
            if (player->speed < 0x07) {
                player->state = FALLING;
                goto falling;
            }
            player->decel++;
            MoveLeftRight(player);
            for (byte i = 0; i < ((player->speed >> 5) & 7); i++) {
                if (CanJumpUp(player))
                    --player->y;
                else {
                    player->state = FALLING;
                    goto falling;
                }
            }
            break;
    }

    const byte* newSprite;
    switch (player->state) {
        case IDLE:
            player->count = 1 << 2;
            newSprite = (player->dir == LEFT ? PlayerLeft[0] : PlayerRight[0]);
            break;
        case MOVING:
            newSprite = (player->dir == LEFT ? PlayerLeft[player->count >> 2] : PlayerRight[player->count >> 2]);
            if (++player->count >= (5 << 2))
                player->count = 0;
            break;
        case JUMPING:
        case FALLING:
            newSprite = (player->dir == LEFT ? PlayerLeftJump : PlayerRightJump);
            break;
    }

    if (player->oldSprite)
        XorSprite(oldX, oldY, player->oldSprite);
    XorSprite(player->x, player->y, newSprite);
    player->oldSprite = newSprite;
}

void InitPlayers()
{
    player1.y = (LEVEL_HEIGHT * 8) - 8;
}

void DoPlayers(void)
{
    DoPlayer(&player1);
}
