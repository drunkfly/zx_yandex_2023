#include "proto.h"

#define MAX_ENEMIES 16

#define APPEAR 0
#define ALIVE 1
#define DYING 2
#define WAITING 3

const byte* const GhostSprites[] = {
        GhostAppear1,
        GhostAppear2,
        GhostAppear3,
        GhostAppear4,
        GhostAppear1,
        GhostAppear2,
        GhostAppear3,
        GhostAppear4,

        GhostRight1,
        GhostRight2,
        GhostRight3,
        GhostRight4,
        GhostLeft1,
        GhostLeft2,
        GhostLeft3,
        GhostLeft4,

        GhostDeath1,
        GhostDeath2,
        GhostDeath3,
        GhostDeath4,
        GhostDeath1,
        GhostDeath2,
        GhostDeath3,
        GhostDeath4,
    };

Enemy enemies[MAX_ENEMIES];
byte enemyCount;

static void XorEnemy(Enemy* enemy)
{
    if (enemy->state == WAITING)
        return;

    XorSprite(enemy->phys.x, enemy->phys.y,
        enemy->sprites[enemy->state * 8 +
        ((enemy->phys.flags & PHYS_DIRECTION) == PHYS_LEFT ? 0 : 4) + enemy->index]);
}

void SpawnEnemy(byte x, byte y, const byte* const* sprites)
{
    if (enemyCount >= MAX_ENEMIES)
        return;

    InitPhysObject(&enemies[enemyCount].phys, x, y);
    enemies[enemyCount].originalX = x;
    enemies[enemyCount].originalY = y;
    enemies[enemyCount].sprites = sprites;
    enemies[enemyCount].index = 0;
    enemies[enemyCount].state = APPEAR;
    XorEnemy(&enemies[enemyCount]);

    ++enemyCount;
}

void KillEnemy(byte index)
{
    if (enemies[index].state == ALIVE) {
        XorEnemy(&enemies[index]);
        enemies[index].state = DYING;
        enemies[index].index = 0;
        XorEnemy(&enemies[index]);
    }
}

byte EnemyCollides(byte x, byte y)
{
    x &= ~7;
    y &= ~7;
    for (byte i = 0; i < MAX_ENEMIES; i++) {
        if ((enemies[i].phys.x & ~7) == x && (enemies[i].phys.y & ~7) == y)
            return i;
    }
    return 0xff;
}

void UpdateEnemies(void)
{
    for (byte i = 0; i < enemyCount; i++) {
        if (enemies[i].state == DYING) {
            if ((Timer & 31) != 31)
                continue;
        }

        XorEnemy(&enemies[i]);

        if (enemies[i].state == ALIVE) {
            if ((player1.phys.x & ~7) == (enemies[i].phys.x & ~7) && (player1.phys.y & ~7) == (enemies[i].phys.y & ~7))
                KillPlayer(&player1, REASON_ENEMY);

            if (!SinglePlayer && (player2.phys.x & ~7) == (enemies[i].phys.x & ~7) && (player2.phys.y & ~7) == (enemies[i].phys.y & ~7))
                KillPlayer(&player2, REASON_ENEMY);

            if ((Timer & 1) == 1) {
                if ((enemies[i].phys.flags & PHYS_DIRECTION) == PHYS_LEFT) {
                    if (CanGoLeft(&enemies[i].phys))
                        enemies[i].phys.x--;
                    else
                        enemies[i].phys.flags = (enemies[i].phys.flags & ~PHYS_DIRECTION) | PHYS_RIGHT;
                } else {
                    if (CanGoRight(&enemies[i].phys))
                        enemies[i].phys.x++;
                    else
                        enemies[i].phys.flags = (enemies[i].phys.flags & ~PHYS_DIRECTION) | PHYS_LEFT;
                }
            }
        }

        if ((Timer & 7) == 7) {
            enemies[i].index++;
            if (enemies[i].index == (enemies[i].state == WAITING ? 10 : 4)) {
                enemies[i].index = 0;
                switch (enemies[i].state) {
                    case APPEAR: enemies[i].state = ALIVE; break;
                    case ALIVE: break;
                    case DYING: enemies[i].state = WAITING; break;
                    case WAITING:
                        enemies[i].phys.x = enemies[i].originalX;
                        enemies[i].phys.y = enemies[i].originalY;
                        enemies[i].state = APPEAR;
                        break;
                }
            }
        }

        XorEnemy(&enemies[i]);
    }
}
