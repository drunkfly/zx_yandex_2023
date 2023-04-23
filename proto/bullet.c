#include "proto.h"

#define MAX_BULLETS 64

typedef struct Bullet { byte x; byte y; sbyte dir; } Bullet;
Bullet bullets[MAX_BULLETS];
byte bulletCount;

static byte BulletSprites[8] = {
        0x80,
        0x40,
        0x20,
        0x10,
        0x08,
        0x04,
        0x02,
        0x01,
    };

static bool BulletCollidesWithWall(const Bullet* bullet)
{
    int off = 6144 + ((bullet->y >> 3) + LEVEL_Y) * 32 + (bullet->x >> 3);
    return SpectrumScreen[off] != PASSABLE_ATTR;
}

static bool BulletCollidesWithPlayer(const Bullet* bullet, const Player* player)
{
    if (player->state == SITTING) {
        return (bullet->x >= player->phys.x + 2 && bullet->y >= player->phys.y + 3 &&
            bullet->x <= player->phys.x + 6 && bullet->y <= player->phys.y + 8);
    } else {
        return (bullet->x >= player->phys.x + 2 && bullet->y >= player->phys.y &&
            bullet->x <= player->phys.x + 6 && bullet->y <= player->phys.y + 8);
    }
}

static void XorBullet(const Bullet* bullet)
{
    SpectrumScreen[ZXCOORD((bullet->x >> 3), (bullet->y + (LEVEL_Y * 8)))] ^= BulletSprites[bullet->x & 7];
}

void SpawnBullet(byte x, byte y, byte dir)
{
    if (bulletCount >= MAX_BULLETS)
        return;

    bullets[bulletCount].x = x;
    bullets[bulletCount].y = y;
    bullets[bulletCount].dir = (dir == PHYS_LEFT ? -1 : 1);
    XorBullet(&bullets[bulletCount]);
    ++bulletCount;
}

static void DestroyBullet(byte index)
{
    bullets[index] = bullets[bulletCount - 1];
    --bulletCount;
}

void UpdateDrawBullets(void)
{
    for (byte i = 0; i < bulletCount; i++) {
        XorBullet(&bullets[i]);
        bullets[i].x += bullets[i].dir;
        bullets[i].x += bullets[i].dir;
        bullets[i].x += bullets[i].dir;
        if (BulletCollidesWithWall(&bullets[i]))
            DestroyBullet(i);
        else if (BulletCollidesWithPlayer(&bullets[i], &player1)) {
            KillPlayer(&player1, REASON_BULLET);
            DestroyBullet(i);
        } else if (!SinglePlayer && BulletCollidesWithPlayer(&bullets[i], &player2)) {
            KillPlayer(&player2, REASON_BULLET);
            DestroyBullet(i);
        } else {
            byte enemy = EnemyCollides(bullets[i].x, bullets[i].y);
            if (enemy != 0xff) {
                DestroyBullet(i);
                KillEnemy(enemy);
            }
            else
                XorBullet(&bullets[i]);
        }
    }
}
