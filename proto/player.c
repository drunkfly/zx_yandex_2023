#include "proto.h"

#define IDLE 0
#define MOVING 1
#define JUMPING 2
#define FALLING 3

#define LEFT 0
#define RIGHT 1

typedef struct Player {
    const byte* oldSprite;
    byte x;
    byte y;
    byte state : 2;
    byte dir : 1;
    byte speed;
    byte accel;
    byte decel;
} Player;

Player player1;
Player player2;

static const byte* PlayerLeft[] = {
        PlayerLeft1,
        PlayerLeft2,
        PlayerLeft3,
        PlayerLeft4,
};

static const byte* PlayerRight[] = {
        PlayerRight1,
        PlayerRight2,
        PlayerRight3,
        PlayerRight4,
    };

static bool MoveLeftRight(Player* player)
{
    if (KeyPressed[KEY_LEFT]) {
        if (player->x > 0)
            --player->x;
        player->dir = LEFT;
        return true;
    }
    if (KeyPressed[KEY_RIGHT]) {
        if (player->x < 256 - 8)
            ++player->x;
        player->dir = RIGHT;
        return true;
    }
    return false;
}

static bool CanFallDown(Player* player)
{
    return player->y < 192 - 8;
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
                if (player->y > 0)
                    --player->y;
            }
            break;
    }

    const byte* newSprite;
    switch (player->state) {
        case IDLE:
            newSprite = (player->dir == LEFT ? PlayerLeft[0] : PlayerRight[0]);
            break;
        case MOVING:
            newSprite = (player->dir == LEFT ? PlayerLeft[(Timer >> 2) & 3] : PlayerRight[(Timer >> 2) & 3]);
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
    player1.y = 192 - 8;
}

void DoPlayers(void)
{
    DoPlayer(&player1);
}
