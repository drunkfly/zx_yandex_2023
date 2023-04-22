#include "proto.h"

#define IDLE 0
#define MOVING 1
#define JUMPING 2
#define FALLING 3

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

static const byte* PlayerHandsLeft[] = {
        PlayerHandsLeft1,
        PlayerHandsLeft2,
        PlayerHandsLeft3,
        PlayerHandsLeft4,
        PlayerHandsLeft5,
};

static const byte* PlayerHandsRight[] = {
        PlayerHandsRight1,
        PlayerHandsRight2,
        PlayerHandsRight3,
        PlayerHandsRight4,
        PlayerHandsRight5,
};

static Player* OppositePlayer(Player* player)
{
    if (player == &player1)
        return &player2;
    else
        return &player1;
}

static bool CanJumpUp(Player* player)
{
    if ((player->y & 7) != 0)
        return true;
    if (player->y == 0)
        return false;

    Player* opp = OppositePlayer(player);
    if (opp->appleStolen && player->y <= 8)
        return false;

    byte yOff = 1;
    if (opp->appleStolen)
        yOff = 2;

    int off = 6144 + ((player->y >> 3) - yOff + LEVEL_Y) * 32 + (player->x >> 3);
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

    Player* opp = OppositePlayer(player);
    if (opp->appleStolen) {
        byte attr = SpectrumScreen[off - 32];
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

    Player* opp = OppositePlayer(player);
    if (opp->appleStolen) {
        byte attr = SpectrumScreen[off - 32];
        if (attr != PASSABLE_ATTR)
            return false;
    }

    return true;
}

static sbyte off[] = { 1, 0, 1, 0 };

static void TryGetApple(Player* player, sbyte offs)
{
    if (player->state == IDLE || player->state == MOVING) {
        Player* opp = OppositePlayer(player);
        if (opp->appleStolen)
            return;
        /*
        if (player->x < opp->appleX + 8 &&
            player->x + 8 > opp->appleX &&
            player->y < opp->appleY + 8 &&
            player->y + 8 > opp->appleY) {
        }
        */
        byte px = player->x >> 3;
        byte py = player->y >> 3;
        byte ax = opp->appleX >> 3;
        byte ay = opp->appleY >> 3;
        if (py == ay && px + offs == ax) {
            opp->appleStolen = 1;
            XorSprite(opp->appleX, opp->appleY + off[opp->appleCounter], Apple1);
            XorSprite(player->x, player->y - 9, Apple1);
        }
    }
}

static bool MoveLeftRight(Player* player)
{
    if (KeyPressed[(player == &player1 ? KEY_LEFT : KEY_A)]) {
        if (CanGoLeft(player)) {
            if (!OppositePlayer(player)->appleStolen || (Timer & 1) == 0)
                --player->x;
        } else
            TryGetApple(player, -1);
        player->dir = LEFT;
        return true;
    }
    if (KeyPressed[(player == &player1 ? KEY_RIGHT : KEY_D)]) {
        if (CanGoRight(player)) {
            if (!OppositePlayer(player)->appleStolen || (Timer & 1) == 0)
                ++player->x;
        } else
            TryGetApple(player, 1);
        player->dir = RIGHT;
        return true;
    }
    return false;
}

static void TryShoot(Player* player)
{
    if (KeyPressed[(player == &player1 ? KEY_ENTER : KEY_CAPS_SHIFT)] && player->cooldown == 0) {
        byte xx;
        if (player->dir == LEFT)
            xx = player->x + 1;
        else
            xx = player->x + 6;
        SpawnBullet(xx, player->y + 4, player->dir);
        player->cooldown = 5;
    }
}

static void FallDown(Player* player)
{
    if (player->accel < 0xf0)
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

    if (player->cooldown != 0)
        --player->cooldown;

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
            TryShoot(player);
            if (!onGround)
                FallDown(player);
            else {
                if (KeyPressed[(player == &player1 ? KEY_UP : KEY_W)] && CanJumpUp(player)) {
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
            TryShoot(player);
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
            TryShoot(player);
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
            if (OppositePlayer(player)->appleStolen)
                newSprite = (player->dir == LEFT ? PlayerHandsLeft[0] : PlayerHandsRight[0]);
            else
                newSprite = (player->dir == LEFT ? PlayerLeft[0] : PlayerRight[0]);
            break;
        case MOVING:
            if (OppositePlayer(player)->appleStolen)
                newSprite = (player->dir == LEFT ? PlayerHandsLeft[1 + ((Timer >> 2) & 3)] : PlayerHandsRight[1 + ((Timer >> 2) & 3)]);
            else
                newSprite = (player->dir == LEFT ? PlayerLeft[1 + ((Timer >> 2) & 3)] : PlayerRight[1 + ((Timer >> 2) & 3)]);
            break;
        case JUMPING:
        case FALLING:
            if (OppositePlayer(player)->appleStolen)
                newSprite = (player->dir == LEFT ? PlayerHandsLeftJump : PlayerHandsRightJump);
            else
                newSprite = (player->dir == LEFT ? PlayerLeftJump : PlayerRightJump);
            break;
    }

    if (player->oldSprite) {
        XorSprite(oldX, oldY, player->oldSprite);
        if (OppositePlayer(player)->appleStolen)
            XorSprite(oldX, oldY - 9, Apple1);
    }
    XorSprite(player->x, player->y, newSprite);
    if (OppositePlayer(player)->appleStolen)
        XorSprite(player->x, player->y - 9, Apple1);
    player->oldSprite = newSprite;

    if (!player->appleStolen) {
        if ((Timer & 15) == 15) {
            XorSprite(player->appleX, player->appleY + off[player->appleCounter], Apple1);
            ++player->appleCounter;
            player->appleCounter &= 3;
            XorSprite(player->appleX, player->appleY + off[player->appleCounter], Apple1);
        }
    }
}

void InitPlayers()
{
    player1.y = (LEVEL_HEIGHT * 8) - 8;
    player1.appleCounter = 1;
    player2.appleCounter = 1;
}

void DoPlayers(void)
{
    DoPlayer(&player1);
    if (!SinglePlayer)
        DoPlayer(&player2);
}
