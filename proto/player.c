#include "proto.h"

#define SHOOT_COOLDOWN 25
#define DEATH_SHOOT_COOLDOWN 50*2
#define DEATH_STONE_COOLDOWN 255

#define GUN_VISUAL_COOLDOWN 40

Player player1;
Player player2;

static byte ShootY[] = {
        2,
        2,
        2,
        2,
        3,
        4,
    };

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

static const byte* PlayerGunLeft[] = {
        PlayerGunLeft1,
        PlayerGunLeft2,
        PlayerGunLeft3,
        PlayerGunLeft4,
        PlayerGunLeft5,
};

static const byte* PlayerGunRight[] = {
        PlayerGunRight1,
        PlayerGunRight2,
        PlayerGunRight3,
        PlayerGunRight4,
        PlayerGunRight5,
};

static void TryGetItem(Player* player, sbyte offs, byte oldX, byte oldY, byte oldState)
{
    if (player->state == IDLE || player->state == MOVING || player->state == JUMPING) {
        if (player->itemAttr)
            return;

        Item item = TryGrabItem(player->phys.x + offs, player->phys.y);
        if (item.attr) {
            XorSprite(oldX, oldY - (oldState == SITTING ? 7 : 9), item.sprite);
            player->itemAttr = item.attr;
            player->itemSprite = item.sprite;
        }
    }
}

static bool MoveLeftRight(Player* player, byte oldX, byte oldY, byte oldState)
{
    if (KeyPressed[(player == &player1 ? KEY_LEFT : KEY_A)]) {
        if (CanGoLeft(&player->phys)) {
            if (!player->itemAttr || (Timer & 1) == 0)
                --player->phys.x;
        } else
            TryGetItem(player, -8, oldX, oldY, oldState);
        player->phys.flags = (player->phys.flags & ~PHYS_DIRECTION) | PHYS_LEFT;
        return true;
    }
    if (KeyPressed[(player == &player1 ? KEY_RIGHT : KEY_D)]) {
        if (CanGoRight(&player->phys)) {
            if (!player->itemAttr || (Timer & 1) == 0)
                ++player->phys.x;
        } else
            TryGetItem(player, 8, oldX, oldY, oldState);
        player->phys.flags = (player->phys.flags & ~PHYS_DIRECTION) | PHYS_RIGHT;
        return true;
    }
    return false;
}

static void TryShoot(Player* player, byte oldX, byte oldY, byte oldState)
{
    if (!KeyPressed[(player == &player1 ? KEY_ENTER : KEY_CAPS_SHIFT)])
        return;

    if (player->cooldown == 0) {
        if (player->itemAttr) {
            XorSprite(oldX, oldY - (oldState == SITTING ? 7 : 9), player->itemSprite);
            if (SpawnFlyingItem(player->phys.x, player->phys.y - (player->state == SITTING ? 6 : 8), player->phys.flags, player->itemSprite, player->itemAttr, 4 << 5)) {
                player->itemSprite = NULL;
                player->itemAttr = 0;
                player->cooldown = SHOOT_COOLDOWN;
            }
        } else {
            byte xx;
            if ((player->phys.flags & PHYS_DIRECTION) == PHYS_LEFT)
                xx = player->phys.x + 1;
            else
                xx = player->phys.x + 6;
            byte id = (player->state == SITTING ? 5 :
                        (player->state == MOVING ? 1 + ((Timer >> 2) & 3) : 0));
            SpawnBullet(xx, player->phys.y + ShootY[id], player->phys.flags & PHYS_DIRECTION);
            player->cooldown = SHOOT_COOLDOWN;
            player->visualCooldown = GUN_VISUAL_COOLDOWN;
        }
    }
}

bool DoPlayer(Player* player)
{
    byte oldX = player->phys.x;
    byte oldY = player->phys.y;
    byte oldState = player->state;

    if (player->cooldown != 0)
        --player->cooldown;
    if (player->visualCooldown != 0)
        --player->visualCooldown;

    bool onGround = true;
    byte upAdj = (player->itemAttr ? 2 : 1);
    if (UpdatePhysObject(&player->phys, upAdj))
        onGround = false;

    switch (player->state) {
        case IDLE:
        case MOVING:
        idle:
            player->state = IDLE;
            if (onGround && KeyPressed[player == &player1 ? KEY_DOWN : KEY_S]) {
                player->state = SITTING;
                goto sitting;
            } else if (MoveLeftRight(player, oldX, oldY, oldState))
                player->state = MOVING;
            TryShoot(player, oldX, oldY, oldState);
            if (onGround) {
                if (KeyPressed[(player == &player1 ? KEY_UP : KEY_W)] && CanGoUp(&player->phys, upAdj)) {
                    player->state = JUMPING;
                    JumpPhysObject(&player->phys, player->phys.flags, 4 << 5);
                }
            }
            break;

        case JUMPING:
            if (onGround)
                goto idle;
         jumping:
            MoveLeftRight(player, oldX, oldY, oldState);
            TryShoot(player, oldX, oldY, oldState);
            break;

        case DEAD_FALLING:
            if (onGround)
                player->state = DEAD;
            break;

        case DEAD_FALLING_RESPAWN:
            if (onGround)
                player->state = DEAD_RESPAWN;
            break;

        case DEAD:
            if (!onGround)
                player->state = DEAD_FALLING;
            else if (player->cooldown == 0) {
                player->cooldown = 10;
                player->state = WAKING_UP;
            }
            break;

        case DEAD_RESPAWN:
            if (!onGround)
                player->state = DEAD_FALLING_RESPAWN;
            else if (player->cooldown == 0) {
                player->phys.x = player->originalX;
                player->phys.y = player->originalY;
                player->cooldown = 10;
                player->state = WAKING_UP;
            }
            break;

        case WAKING_UP:
            if (player->cooldown == 0)
                player->state = IDLE;
            break;

        case SITTING:
            if (!onGround) {
                player->state = JUMPING;
                goto jumping;
            }
          sitting:
            if (!KeyPressed[player == &player1 ? KEY_DOWN : KEY_S]) {
                player->state = IDLE;
                goto idle;
            }
            TryShoot(player, oldX, oldY, oldState);
            break;
    }

    const byte* newSprite;
    switch (player->state) {
        case IDLE:
            if (player->itemAttr) {
                player->visualCooldown = 0;
                newSprite = ((player->phys.flags & PHYS_DIRECTION) == PHYS_LEFT ? PlayerHandsLeft[0] : PlayerHandsRight[0]);
            } else if (player->visualCooldown)
                newSprite = ((player->phys.flags & PHYS_DIRECTION) == PHYS_LEFT ? PlayerGunLeft[0] : PlayerGunRight[0]);
            else
                newSprite = ((player->phys.flags & PHYS_DIRECTION) == PHYS_LEFT ? PlayerLeft[0] : PlayerRight[0]);
            break;
        case MOVING: {
            byte id = 1 + ((Timer >> 2) & 3);
            if (player->itemAttr) {
                player->visualCooldown = 0;
                newSprite = ((player->phys.flags & PHYS_DIRECTION) == PHYS_LEFT ? PlayerHandsLeft[id] : PlayerHandsRight[id]);
            } else if (player->visualCooldown)
                newSprite = ((player->phys.flags & PHYS_DIRECTION) == PHYS_LEFT ? PlayerGunLeft[id] : PlayerGunRight[id]);
            else
                newSprite = ((player->phys.flags & PHYS_DIRECTION) == PHYS_LEFT ? PlayerLeft[id] : PlayerRight[id]);
            break;
        }
        case JUMPING:
            if (player->itemAttr) {
                player->visualCooldown = 0;
                newSprite = ((player->phys.flags & PHYS_DIRECTION) == PHYS_LEFT ? PlayerHandsLeftJump : PlayerHandsRightJump);
            } else if (player->visualCooldown)
                newSprite = ((player->phys.flags & PHYS_DIRECTION) == PHYS_LEFT ? PlayerGunLeftJump : PlayerGunRightJump);
            else
                newSprite = ((player->phys.flags & PHYS_DIRECTION) == PHYS_LEFT ? PlayerLeftJump : PlayerRightJump);
            break;
        case DEAD_FALLING:
        case DEAD_FALLING_RESPAWN:
            player->visualCooldown = 0;
            newSprite = ((player->phys.flags & PHYS_DIRECTION) == PHYS_LEFT ? PlayerDead1Left : PlayerDead1Right);
            break;
        case DEAD:
        case DEAD_RESPAWN:
            player->visualCooldown = 0;
            if ((player->cooldown & 31) < 15)
                newSprite = ((player->phys.flags & PHYS_DIRECTION) == PHYS_LEFT ? PlayerDead1Left : PlayerDead1Right);
            else
                newSprite = ((player->phys.flags & PHYS_DIRECTION) == PHYS_LEFT ? PlayerDead2Left : PlayerDead2Right);
            break;
        case WAKING_UP:
            player->visualCooldown = 0;
            newSprite = ((player->phys.flags & PHYS_DIRECTION) == PHYS_LEFT ? PlayerDead3Left : PlayerDead3Right);
            break;
        case SITTING:
            if (player->itemAttr) {
                player->visualCooldown = 0;
                newSprite = ((player->phys.flags & PHYS_DIRECTION) == PHYS_LEFT ? PlayerHandsDuckLeft : PlayerHandsDuckRight);
            } else if (player->visualCooldown)
                newSprite = ((player->phys.flags & PHYS_DIRECTION) == PHYS_LEFT ? PlayerGunDuckLeft : PlayerGunDuckRight);
            else
                newSprite = ((player->phys.flags & PHYS_DIRECTION) == PHYS_LEFT ? PlayerDuckLeft : PlayerDuckRight);
            break;
    }

    if (player->oldSprite) {
        XorSprite(oldX, oldY, player->oldSprite);
        if (player->itemAttr)
            XorSprite(oldX, oldY - (oldState == SITTING ? 7 : 9), player->itemSprite);
    }
    XorSprite(player->phys.x, player->phys.y, newSprite);
    if (player->itemAttr)
        XorSprite(player->phys.x, player->phys.y - (player->state == SITTING ? 7 : 9), player->itemSprite);
    player->oldSprite = newSprite;

    if ((player->state != DEAD && player->state != DEAD_FALLING && player->state != DEAD_FALLING_RESPAWN && player->state != DEAD_RESPAWN)
            && player->phys.x + 8 >= player->gatesX + 6 && player->phys.x <= player->gatesX + 3 * 8 - 6
            && player->phys.y + 8 >= player->gatesY && player->phys.y <= player->gatesY + 8) {
        byte myApple = (player == &player1 ? APPLE1_ATTR : APPLE2_ATTR);
        byte enemyApple = (player == &player1 ? APPLE2_ATTR : APPLE1_ATTR);

        if (player->itemAttr == myApple) {
            XorSprite(player->phys.x, player->phys.y - (player->state == SITTING ? 7 : 9), player->itemSprite);
            PlaceItem(player->gatesX + 8, player->gatesY, player->itemSprite, player->itemAttr);
            player->itemSprite = NULL;
            player->itemAttr = 0;
        }

        const Item* itemAtOurGates1 = ItemAt(player->gatesX + 8, player->gatesY);
        const Item* itemAtOurGates2 = ItemAt(player->gatesX, player->gatesY);
        const Item* itemAtOurGates3 = ItemAt(player->gatesX + 16, player->gatesY);

        bool haveEnemyCoin = (player->itemAttr == enemyApple ||
            (itemAtOurGates1 != NULL && itemAtOurGates1->attr == enemyApple) ||
            (itemAtOurGates2 != NULL && itemAtOurGates2->attr == enemyApple) ||
            (itemAtOurGates3 != NULL && itemAtOurGates3->attr == enemyApple));

        bool haveOurCoin = (player->itemAttr == myApple ||
            (itemAtOurGates1 != NULL && itemAtOurGates1->attr == myApple) ||
            (itemAtOurGates2 != NULL && itemAtOurGates2->attr == myApple) ||
            (itemAtOurGates3 != NULL && itemAtOurGates3->attr == myApple));

        if (haveOurCoin && haveEnemyCoin)
            return false;
    }

    return true;
}

void KillPlayer(Player* player, byte reason)
{
    if (player->state != DEAD && player->state != DEAD_FALLING && player->state != DEAD_FALLING_RESPAWN && player->state != DEAD_RESPAWN) {
        if (player->itemAttr) {
            XorSprite(player->phys.x, player->phys.y - (player->state == SITTING ? 7 : 9), player->itemSprite);
            if (SpawnFlyingItem(player->phys.x, player->phys.y - (player->state == SITTING ? 6 : 8), player->phys.flags,
                    player->itemSprite, player->itemAttr, (1 << 5) | 3)) {
                player->itemAttr = 0;
                player->itemSprite = NULL;
            } else {
                PlaceItem(player->phys.x, player->phys.y, player->itemSprite, player->itemAttr);
            }
        }
        switch (reason) {
            case REASON_BULLET:
                player->state = DEAD_FALLING;
                player->cooldown = DEATH_SHOOT_COOLDOWN;
                break;
            case REASON_ITEM:
                player->state = DEAD_FALLING;
                player->cooldown = DEATH_STONE_COOLDOWN;
                break;
            case REASON_ENEMY:
                if (SinglePlayer) {
                    player->state = DEAD_FALLING_RESPAWN;
                    player->cooldown = DEATH_SHOOT_COOLDOWN;
                } else {
                    player->state = DEAD_FALLING;
                    player->cooldown = DEATH_STONE_COOLDOWN;
                }
                break;
        }
    }
}

bool DoPlayers(void)
{
    if (!DoPlayer(&player1))
        return false;

    if (!SinglePlayer) {
        if (!DoPlayer(&player2))
            return false;
    }

    return true;
}
