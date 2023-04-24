
sizeof_Enemy = 11
Enemy_phys_x = 0
Enemy_phys_y = 1
Enemy_phys_flags = 2
Enemy_phys_speed = 3
Enemy_phys_accel = 4
Enemy_originalX = 5
Enemy_originalY = 6
Enemy_sprites = 7
Enemy_index = 9
Enemy_state = 10

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

                section bss

Enemies:        repeat  MAX_ENEMIES
                db      0   ; phys.x
                db      0   ; phys.y
                db      0   ; phys.flags
                db      0   ; phys.speed
                db      0   ; phys.accel
                db      0   ; originalX
                db      0   ; originalY
                dw      0   ; sprites
                db      0   ; index
                db      0   ; state
                endrepeat

EnemyCount      db      0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

                section code_enemies

                ; Input:
                ;   IX => player

/*
DoPlayer:       ld      a, (ix+Player_cooldown)



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
*/
