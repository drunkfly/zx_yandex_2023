#include "proto.h"

#define MAX_FLYING 8

typedef struct FlyingItem {
    PhysObject phys;
    bool moveHorz;
    bool didMirror;
    byte stoppedY;
    const byte* sprite;
    byte attr;
} FlyingItem;

FlyingItem flying[MAX_FLYING];
byte flyingCount;

bool CanGoUp(PhysObject* obj, byte h)
{
    if ((obj->y & 7) != 0)
        return true;
    if (obj->y == 0)
        return false;

    int off = 6144 + ((obj->y >> 3) - h + LEVEL_Y) * 32 + (obj->x >> 3);
    byte attr = SpectrumScreen[off];
    if (attr != PASSABLE_ATTR)
        return false;

    if ((obj->x & 7) != 0) {
        attr = SpectrumScreen[off + 1];
        if (attr != PASSABLE_ATTR)
            return false;
    }

    return true;
}

bool CanGoDown(PhysObject* obj)
{
    if ((obj->y & 7) != 0)
        return true;
    if (obj->y >= (LEVEL_HEIGHT * 8) - 8)
        return false;

    int off = 6144 + ((obj->y >> 3) + 1 + LEVEL_Y) * 32 + (obj->x >> 3);
    byte attr = SpectrumScreen[off];
    if (attr != PASSABLE_ATTR)
        return false;

    if ((obj->x & 7) != 0) {
        attr = SpectrumScreen[off + 1];
        if (attr != PASSABLE_ATTR)
            return false;
    }

    return true;
}

bool CanGoLeft(PhysObject* obj)
{
    if ((obj->x & 7) != 0)
        return true;
    if (obj->x == 0)
        return false;

    int off = 6144 + ((obj->y >> 3) + LEVEL_Y) * 32 + (obj->x >> 3) - 1;
    byte attr = SpectrumScreen[off];
    if (attr != PASSABLE_ATTR)
        return false;

    if ((obj->y & 7) != 0) {
        attr = SpectrumScreen[off + 32];
        if (attr != PASSABLE_ATTR)
            return false;
    }

    return true;
}

bool CanGoLeftWithItem(PhysObject* obj)
{
    if ((obj->x & 7) != 0)
        return true;
    if (obj->x == 0)
        return false;

    int off = 6144 + ((obj->y >> 3) + LEVEL_Y) * 32 + (obj->x >> 3) - 1;
    byte attr = SpectrumScreen[off];
    if (attr != PASSABLE_ATTR)
        return false;

    if ((obj->y & 7) != 0) {
        attr = SpectrumScreen[off + 32];
        if (attr != PASSABLE_ATTR)
            return false;
    }

    attr = SpectrumScreen[off - 32];
    if (attr != PASSABLE_ATTR)
        return false;

    return true;
}

bool CanGoRight(PhysObject* obj)
{
    if ((obj->x & 7) != 0)
        return true;
    if (obj->x >= (LEVEL_WIDTH * 8) - 8)
        return false;

    int off = 6144 + ((obj->y >> 3) + LEVEL_Y) * 32 + (obj->x >> 3) + 1;
    byte attr = SpectrumScreen[off];
    if (attr != PASSABLE_ATTR)
        return false;

    if ((obj->y & 7) != 0) {
        attr = SpectrumScreen[off + 32];
        if (attr != PASSABLE_ATTR)
            return false;
    }

    return true;
}

bool CanGoRightWithItem(PhysObject* obj)
{
    if ((obj->x & 7) != 0)
        return true;
    if (obj->x >= (LEVEL_WIDTH * 8) - 8)
        return false;

    int off = 6144 + ((obj->y >> 3) + LEVEL_Y) * 32 + (obj->x >> 3) + 1;
    byte attr = SpectrumScreen[off];
    if (attr != PASSABLE_ATTR)
        return false;

    if ((obj->y & 7) != 0) {
        attr = SpectrumScreen[off + 32];
        if (attr != PASSABLE_ATTR)
            return false;
    }

    attr = SpectrumScreen[off - 32];
    if (attr != PASSABLE_ATTR)
        return false;

    return true;
}

void InitPhysObject(PhysObject* obj, byte x, byte y)
{
    obj->x = x;
    obj->y = y;
    obj->flags = 0;
    obj->speed = 0;
    obj->accel = 0;
}

void JumpPhysObject(PhysObject* obj, byte dir, byte speed)
{
    obj->flags = (dir & PHYS_DIRECTION) | PHYS_UP;
    obj->speed = speed;
    obj->accel = 0x01;
}

bool UpdatePhysObject(PhysObject* obj, byte h)
{
    if ((obj->flags & PHYS_VERTICAL) == PHYS_UP) {
        if (obj->speed <= obj->accel)
            goto fall;
        obj->speed -= obj->accel;
        if (obj->speed < 0x07)
            goto fall;
        obj->accel++;
        byte n = (obj->speed >> 5) & 7;
        for (byte i = 0; i < n; i++) {
            if (CanGoUp(obj, h))
                --obj->y;
            else {
              fall:
                obj->flags = (obj->flags & ~PHYS_VERTICAL) | PHYS_DOWN;
                obj->speed = 0;
                goto falling;
            }
        }
        return true;
    } else {
      falling:
        if (obj->speed < 0xf0)
            obj->speed += 0x08;
        byte n = (obj->speed >> 5) & 7;
        if (n == 0)
            return CanGoDown(obj);
        for (byte i = 0; i < n; i++) {
            if (!CanGoDown(obj)) {
                obj->speed = 0;
                return false;
            }
            obj->y += 1;
        }
        return true;
    }
}

bool SpawnFlyingItem(byte x, byte y, byte dir, const byte* sprite, byte attr, byte speed)
{
    if (flyingCount >= MAX_FLYING)
        return false;

    InitPhysObject(&flying[flyingCount].phys, x, y);
    JumpPhysObject(&flying[flyingCount].phys, dir, speed);
    flying[flyingCount].sprite = sprite;
    flying[flyingCount].attr = attr;
    flying[flyingCount].moveHorz = true;
    flying[flyingCount].didMirror = false;
    XorSprite(x, y, sprite);
    ++flyingCount;

    return true;
}

static void RemoveFlying(byte index)
{
    flying[index] = flying[flyingCount - 1];
    --flyingCount;
}

static bool CollidesWithPlayer(const FlyingItem* flying, const Player* player)
{
    if (player->phys.x + 2 < flying->phys.x + 8 &&
        player->phys.x + 6 > flying->phys.x &&
        player->phys.y + 1 < flying->phys.y + 8 &&
        player->phys.y + 7 > flying->phys.y) {
        return true;
    }
    return false;
}

static bool CollidesWithPlayerFull(const FlyingItem* flying, const Player* player)
{
    if (player->phys.x < flying->phys.x + 8 &&
        player->phys.x + 8 > flying->phys.x &&
        player->phys.y < flying->phys.y + 8 &&
        player->phys.y + 8 > flying->phys.y) {
        return true;
    }
    return false;
}

void UpdateFlying(void)
{
    for (byte i = 0; i < flyingCount; i++) {
        XorSprite(flying[i].phys.x, flying[i].phys.y, flying[i].sprite);

        if (!flying[i].moveHorz) {
            if ((flying[i].phys.y >> 3) != flying[i].stoppedY)
                flying[i].didMirror = false;
        }

        if (!UpdatePhysObject(&flying[i].phys, 1)) {
            byte x = flying[i].phys.x & 7;
            if (x == 0) {
                bool canMoveHorz = !flying[i].didMirror || flying[i].moveHorz;
                if (ItemAt(flying[i].phys.x, flying[i].phys.y + 8) && canMoveHorz)
                    flying[i].moveHorz = true;
                else if (CollidesWithPlayerFull(&flying[i], &player1) && canMoveHorz)
                    flying[i].moveHorz = true;
                else if (CollidesWithPlayerFull(&flying[i], &player2) && canMoveHorz)
                    flying[i].moveHorz = true;
                else {
                    PlaceItem(flying[i].phys.x, flying[i].phys.y, flying[i].sprite, flying[i].attr);
                    RemoveFlying(i);
                    continue;
                }
            }
        }

        if (CollidesWithPlayer(&flying[i], &player1))
            KillPlayer(&player1, false);

        if (CollidesWithPlayer(&flying[i], &player2))
            KillPlayer(&player2, false);

        if (flying[i].moveHorz) {
            if ((flying[i].phys.flags & PHYS_DIRECTION) == PHYS_LEFT) {
                if (CanGoLeft(&flying[i].phys))
                    flying[i].phys.x--;
                else if (!flying[i].didMirror) {
                    flying[i].didMirror = true;
                    flying[i].phys.flags = (flying[i].phys.flags & ~PHYS_DIRECTION) | PHYS_RIGHT;
                } else {
                    flying[i].moveHorz = false;
                    flying[i].stoppedY = flying[i].phys.y >> 3;
                }
            } else {
                if (CanGoRight(&flying[i].phys))
                    flying[i].phys.x++;
                else if (!flying[i].didMirror) {
                    flying[i].didMirror = true;
                    flying[i].phys.flags = (flying[i].phys.flags & ~PHYS_DIRECTION) | PHYS_LEFT;
                } else {
                    flying[i].moveHorz = false;
                    flying[i].stoppedY = flying[i].phys.y >> 3;
                }
            }
        }

        XorSprite(flying[i].phys.x, flying[i].phys.y, flying[i].sprite);
    }
}
