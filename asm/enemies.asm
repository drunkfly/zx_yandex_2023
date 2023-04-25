
ENEMY_APPEAR = 0
ENEMY_ALIVE = 1
ENEMY_DYING = 2
ENEMY_WAITING = 3

ENEMY_STATE_MASK = 0x0f
ENEMY_SHOOTING = 0x10
ENEMY_STATIC = 0x20

ENEMY_VISIBLE_WHEN_DEAD = 0x02
ENEMY_FALL_WHEN_DEAD = 0x04
ENEMY_RESPAWN_WHERE_DIED = 0x08
ENEMY_MOVE_VERTICALLY = 0x10

sizeof_Enemy = 12
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
Enemy_spriteRef = 11

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
                db      0   ; spriteRef
                endrepeat

EnemyCount      db      0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

                section data_enemies

                db      31
                db      ENEMY_ALIVE
                db      (3 << 5) | ENEMY_MOVE_VERTICALLY | ENEMY_RESPAWN_WHERE_DIED | ENEMY_FALL_WHEN_DEAD | ENEMY_VISIBLE_WHEN_DEAD
BatSprites:     db      SPRITE_BatRevive
                db      SPRITE_BatFall2
                db      SPRITE_BatRevive
                db      SPRITE_BatFall2
                db      SPRITE_BatRevive
                db      SPRITE_BatFall2
                db      SPRITE_BatRevive
                db      SPRITE_BatFall2

                db      SPRITE_BatRight1
                db      SPRITE_BatRight2
                db      SPRITE_BatRight3
                db      SPRITE_BatRight4
                db      SPRITE_BatLeft1
                db      SPRITE_BatLeft2
                db      SPRITE_BatLeft3
                db      SPRITE_BatLeft4

                db      SPRITE_BatFall1
                db      SPRITE_BatFall1
                db      SPRITE_BatFall1
                db      SPRITE_BatFall1
                db      SPRITE_BatFall2
                db      SPRITE_BatFall2
                db      SPRITE_BatFall2
                db      SPRITE_BatFall2

                db      SPRITE_BatFall2
                db      SPRITE_BatFall2

                db      31
                db      ENEMY_ALIVE
                db      (7 << 5)
GhostSprites:   db      SPRITE_GhostAppear1
                db      SPRITE_GhostAppear2
                db      SPRITE_GhostAppear3
                db      SPRITE_GhostAppear4
                db      SPRITE_GhostAppear1
                db      SPRITE_GhostAppear2
                db      SPRITE_GhostAppear3
                db      SPRITE_GhostAppear4

                db      SPRITE_GhostRight1
                db      SPRITE_GhostRight2
                db      SPRITE_GhostRight3
                db      SPRITE_GhostRight4
                db      SPRITE_GhostLeft1
                db      SPRITE_GhostLeft2
                db      SPRITE_GhostLeft3
                db      SPRITE_GhostLeft4

                db      SPRITE_GhostDeath1
                db      SPRITE_GhostDeath2
                db      SPRITE_GhostDeath3
                db      SPRITE_GhostDeath4
                db      SPRITE_GhostDeath1
                db      SPRITE_GhostDeath2
                db      SPRITE_GhostDeath3
                db      SPRITE_GhostDeath4

                db      7
                db      ENEMY_ALIVE | ENEMY_SHOOTING | ENEMY_STATIC
                db      (7 << 5) | ENEMY_RESPAWN_WHERE_DIED | ENEMY_VISIBLE_WHEN_DEAD
FlowerSprites:  db      SPRITE_FlowerReviveLeft
                db      SPRITE_FlowerDeathLeft2
                db      SPRITE_FlowerReviveLeft
                db      SPRITE_FlowerDeathLeft2
                db      SPRITE_FlowerReviveRight
                db      SPRITE_FlowerDeathRight2
                db      SPRITE_FlowerReviveRight
                db      SPRITE_FlowerDeathRight2

                db      SPRITE_FlowerRight1
                db      SPRITE_FlowerRight2
                db      SPRITE_FlowerRight3
                db      SPRITE_FlowerRight4
                db      SPRITE_FlowerLeft1
                db      SPRITE_FlowerLeft2
                db      SPRITE_FlowerLeft3
                db      SPRITE_FlowerLeft4

                db      SPRITE_FlowerDeathLeft1
                db      SPRITE_FlowerDeathLeft1
                db      SPRITE_FlowerDeathLeft2
                db      SPRITE_FlowerDeathLeft2
                db      SPRITE_FlowerDeathRight1
                db      SPRITE_FlowerDeathRight1
                db      SPRITE_FlowerDeathRight2
                db      SPRITE_FlowerDeathRight2

                db      SPRITE_FlowerDeathLeft2
                db      SPRITE_FlowerDeathRight2

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

                section code_enemies

                ; Input:
                ;   A = item index
                ;   BC = base
                ; Output:
                ;   IX => item
                ; Preserves:
                ;   DE, HL

CalcEnemyAddr:  ld      bc, Enemies
@@raw:          add     a, a        ; *= 2
                add     a, a        ; *= 4
                ld      ixl, a
                add     a, a        ; *= 8
                add     a, ixl      ; *= 12
                ld      ixl, a
                ld      ixh, 0
                add     ix, bc
                ret

                ; Input:
                ;   B = Y
                ;   C = X
                ;   DE => sprites

SpawnEnemy:     ld      a, (EnemyCount)
                cp      MAX_ENEMIES
                ret     z
                inc     a
                ld      (EnemyCount), a
                push    bc
                ld      bc, Enemies-sizeof_Enemy
                call    CalcEnemyAddr@@raw
                pop     bc
                call    InitPhysObject
                ld      (ix+Enemy_originalX), c
                ld      (ix+Enemy_originalY), b
                ld      (ix+Enemy_sprites), e
                ld      (ix+Enemy_sprites+1), d
                dec     de
                ld      a, (de)
                and     PHYS_USERDATA
                or      (ix+Enemy_phys_flags)
                ld      (ix+Enemy_phys_flags), a
                dec     de
                ld      a, (de)
                ld      (ix+Enemy_state), a
                and     a, ENEMY_SHOOTING
                jr      z, @@notShooting
                ld      (ix+Enemy_originalX), ENEMY_SHOOT_COOLDOWN
@@notShooting:  ld      (ix+Enemy_index), 0
                call    AllocSprite
                ld      (ix+Enemy_spriteRef), a
                ret

                ; Input:
                ;   HL => enemy
                ; Output:
                ;   ZF=1: killed, ZF=0: not killed
                ; Preserves:
                ;   BC, IX

KillEnemy:      ld      de, Enemy_state
                add     hl, de
                ld      a, (hl)
                ld      e, a
                and     ENEMY_STATE_MASK
                cp      ENEMY_ALIVE
                ret     nz
                ld      a, e
                and     ~ENEMY_STATE_MASK
                or      ENEMY_DYING
                ld      (hl), a
                dec     hl
                xor     a
                ld      (hl), a     ; Enemy_index
                ret     ; ZF=1 killed

                ; Input:
                ;   B = Y
                ;   C = X
                ; Output:
                ;   HL => enemy, or H = 0 if no collision
                ; Preserves:
                ;   BC, IX

EnemyCollides:  ld      a, (EnemyCount)
                or      a
                jr      z, @@notFound
                push    ix
                ld      hl, Enemies
                ld      de, sizeof_Enemy-1
                ld      ixl, a
@@loop:         ld      a, (hl)             ; x
                inc     hl
                add     a, -8
                cp      c
                jr      nc, @@noCollision
                add     a, 7+8
                cp      c
                jr      c, @@noCollision
                ld      a, (hl)             ; y
                add     a, -8
                cp      b
                jr      nc, @@noCollision
                add     a, 7+8
                cp      b
                jr      c, @@noCollision
                pop     ix
                dec     hl
                ret
@@noCollision:  add     hl, de
                dec     ixl
                jr      nz, @@loop
                pop     ix
@@notFound:     ld      h, 0
                ret

                ; Input:
                ;   B = Y
                ;   C = X
                ; Output:
                ;   HL => enemy, or H = 0 if no collision
                ; Preserves:
                ;   IX

EnemyCollidesBullet:
                ld      a, (EnemyCount)
                or      a
                jr      z, @@notFound
                push    ix
                ld      hl, Enemies
                ld      de, sizeof_Enemy-1
                ld      ixl, a
                ld      a, b
                and     ~7
                ld      b, a
                ld      a, c
                and     ~7
                ld      c, a
@@loop:         ld      a, (hl)             ; x
                inc     hl
                and     ~7
                cp      c
                jr      nz, @@noCollision
                ld      a, (hl)             ; y
                and     ~7
                cp      b
                jr      nz, @@noCollision
                pop     ix
                dec     hl
                ret
@@noCollision:  add     hl, de
                dec     ixl
                jr      nz, @@loop
                pop     ix
@@notFound:     ld      h, 0
                ret

                ; Input:
                ;   none

UpdateEnemies:  ld      a, (EnemyCount)
                or      a
                ret     z
                ld      ix, Enemies
                ld      e, a
@@loop:         push    de
                ld      a, (ix+Enemy_state)
                ld      e, a
                and     ENEMY_STATE_MASK
                cp      ENEMY_DYING
                jr      nz, @@notDying
                ld      a, e
                and     ENEMY_STATIC
                call    z, @@maybeFallDown
                ld      l, (ix+Enemy_sprites)
                ld      h, (ix+Enemy_sprites+1)
                dec     hl
                dec     hl
                dec     hl
                ld      l, (hl)
                ld      a, (Timer)
                and     l
                cp      l
                jp      nz, @@setSprite
@@notDying:     ld      a, (ix+Enemy_state)
                and     ENEMY_STATE_MASK
                cp      ENEMY_ALIVE
                jp      nz, @@doneAlive
                ld      c, (ix+Enemy_phys_x)
                ld      b, (ix+Enemy_phys_y)
                push    ix
                ld      ix, Player1
                call    CollidesWithPlayer
                jr      z, @@notHit1
                push    bc
                ld      b, REASON_ENEMY
                call    KillPlayer
                pop     bc
@@notHit1:      ld      a, (SinglePlayer)
                or      a
                jr      nz, @@notHit2
                ld      ix, Player2
                call    CollidesWithPlayer
                jr      z, @@notHit2
                ld      b, REASON_ENEMY
                call    KillPlayer
@@notHit2:      pop     ix
                ld      a, (Timer)
                and     1
                jr      z, @@doneAlive
                bit     5, (ix+Enemy_state)         ; ENEMY_STATIC
                jr      nz, @@doneAlive
                bit     0, (ix+Enemy_phys_flags)    ; PHYS_HORIZONTAL
                jr      nz, @@right
                call    CanGoLeft
                jr      z, @@cantLeft
                dec     (ix+Enemy_phys_x)
                jr      @@doneHorz
@@cantLeft:     set     0, (ix+Enemy_phys_flags)    ; PHYS_RIGHT
                jr      @@doneHorz
@@right:        call    CanGoRight
                jr      z, @@cantRight
                inc     (ix++Enemy_phys_x)
                jr      @@doneHorz
@@cantRight:    res     0, (ix+Enemy_phys_flags)    ; PHYS_LEFT
@@doneHorz:     bit     4, (ix+Enemy_phys_flags)    ; ENEMY_MOVE_VERTICALLY
                jr      z, @@doneAlive
                bit     1, (ix+Enemy_phys_flags)    ; PHYS_VERTICAL
                jr      nz, @@up
                call    CanGoDown
                jr      z, @@cantDown
                inc     (ix+Enemy_phys_y)
                jr      @@doneAlive
@@cantDown:     set     1, (ix+Enemy_phys_flags)    ; PHYS_UP
                jr      @@doneAlive
@@up:           ld      d, 1
                call    CanGoUp
                jr      z, @@cantUp
                dec     (ix+Enemy_phys_y)
                jr      @@doneAlive
@@cantUp:       res     1, (ix+Enemy_phys_flags)    ; PHYS_DOWN
@@doneAlive:    ld      a, (ix+Enemy_state)
                and     ENEMY_STATE_MASK
                ld      b, a
                cp      ENEMY_WAITING
                jr      nz, @@notWaiting
                ; waiting
                ld      a, (ix+Enemy_index)
                inc     a
                cp      ENEMY_RESPAWN_TIME
                jr      c, @@updateIndex
                ld      c, (ix+Enemy_sprites)
                ld      b, (ix+Enemy_sprites+1)
                dec     bc
                ld      a, (bc)
                and     ENEMY_RESPAWN_WHERE_DIED
                jr      nz, @@respawn
                ld      c, (ix+Enemy_originalX)
                ld      b, (ix+Enemy_originalY)
                ld      (ix+Enemy_phys_x), c
                ld      (ix+Enemy_phys_y), b
@@respawn:      ld      a, (ix+Enemy_state)
                and     ~ENEMY_STATE_MASK
                or      ENEMY_APPEAR
                ld      (ix+Enemy_state), a
                xor     a
@@updateIndex:  ld      (ix+Enemy_index), a
                jr      @@setSprite
@@notWaiting:   ld      a, (ix+Enemy_phys_flags)
                rlca
                rlca
                rlca
                and     7
                ld      c, a
                ld      a, (Timer)
                and     c
                cp      c
                jr      nz, @@setSprite
                ld      a, (ix+Enemy_index)
                inc     a
                and     3
                ld      (ix+Enemy_index), a
                jr      nz, @@setSprite
                ld      a, b
                cp      ENEMY_APPEAR
                jr      z, @@appear
                cp      ENEMY_DYING
                ld      a, (ix+Enemy_state)
                jr      z, @@dying
                and     ENEMY_SHOOTING
                jr      z, @@setSprite
                ld      a, (ix+Enemy_originalX)
                dec     a
                ld      (ix+Enemy_originalX), a
                jr      nz, @@setSprite
                ld      (ix+Enemy_originalX), ENEMY_SHOOT_COOLDOWN
                push    ix
                push    de
                ld      a, (ix+Enemy_phys_x)
                dec     a
                ld      c, (ix+Enemy_phys_flags)
                bit     0, c                        ; PHYS_HORIZONTAL
                jr      z, @@shootLeft              ; PHYS_LEFT
                add     a, 9
@@shootLeft:    ld      e, a
                ld      a, (ix+Enemy_phys_y)
                add     a, 2
                ld      d, a
                ld      ixl, c
                call    SpawnBullet
                pop     de
                pop     ix
                jr      @@setSprite
@@dying:        and     ~ENEMY_STATE_MASK
                or      ENEMY_WAITING
                ld      (ix+Enemy_state), a
                jr      @@setSprite
@@appear:       ld      a, (ix+Enemy_state)
                and     ~ENEMY_STATE_MASK
                or      ENEMY_ALIVE
                ld      (ix+Enemy_state), a
@@setSprite:    ld      a, (ix+Enemy_state)
                and     ENEMY_STATE_MASK
                cp      ENEMY_WAITING
                jr      z, @@isWaiting
                rlca
                rlca
                rlca
                add     a, (ix+Enemy_index)
                bit     0, (ix+Enemy_phys_flags)    ; PHYS_HORIZONTAL
                jr      z, @@getSprite              ; PHYS_LEFT
                add     a, 4
@@getSprite:    ld      e, a
                ld      d, 0
                ld      l, (ix+Enemy_sprites)
                ld      h, (ix+Enemy_sprites+1)
                add     hl, de
                ld      b, (hl)
                jr      @@applySprite
@@removeSprite: ld      b, SPRITE_EMPTY
@@applySprite:  ld      a, (ix+Enemy_spriteRef)
                ld      e, (ix+Enemy_phys_x)
                ld      d, (ix+Enemy_phys_y)
                call    SetSprite
@@continue:     ld      de, sizeof_Enemy
                add     ix, de
                pop     de
                dec     e
                jp      nz, @@loop
                ret

@@isWaiting:    ld      l, (ix+Enemy_sprites)
                ld      h, (ix+Enemy_sprites+1)
                dec     hl
                ld      a, (hl)
                and     ENEMY_FALL_WHEN_DEAD
                call    nz, @@maybeFallDown
                ld      a, ENEMY_VISIBLE_WHEN_DEAD
                and     (hl)
                jr      z, @@removeSprite
                ld      a, ENEMY_WAITING << 3
                bit     0, (ix+Enemy_phys_flags)    ; PHYS_HORIZONTAL
                jr      z, @@getSprite              ; PHYS_LEFT
                inc     a
                jr      @@getSprite

@@maybeFallDown:push    hl
                bit     4, (ix+Enemy_phys_flags)    ; ENEMY_MOVING_VERTICALLY
                jr      z, @@notFalling
                ld      c, (ix+Enemy_phys_x)
                ld      b, (ix+Enemy_phys_y)
                call    CanGoDown
                jr      z, @@notFalling
                res     0, (ix+Enemy_phys_flags)    ; PHYS_LEFT
                inc     b
                ld      (ix+Enemy_phys_y), b
                call    CanGoDown
                jr      z, @@notFalling
                inc     (ix+Enemy_phys_y)
                jr      @@doneFalling
@@notFalling:   set     0, (ix+Enemy_phys_flags)    ; PHYS_RIGHT
@@doneFalling:  pop     hl
                ret
