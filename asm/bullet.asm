
                section bss

sizeof_Bullet       = 3
Bullet_dir          = 0
Bullet_x            = 1
Bullet_y            = 2

Bullets:        repeat  MAX_BULLETS
                db      0           ; dir
                db      0           ; x
                db      0           ; y
                endrepeat

BulletCount     db      0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

                section data_bullets

BulletSprites   db      0x80, 0x40, 0x20, 0x10, 0x08, 0x04, 0x02, 0x01

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

                section code_low

                ; Input:
                ;   A = bullet index
                ;   BC = base
                ; Output:
                ;   HL => sprite
                ; Preserves:
                ;   DE, IX

CalcBulletAddr: ld      bc, Bullets
@@raw:          ld      h, a
                add     a, a        ; *= 2
                add     a, h        ; *= 3
                ld      l, a
                ld      h, 0
                add     hl, bc
                ret

                ; Input:
                ;   B = bullet Y
                ;   C = bullet X
                ;   IX => player
                ; Output:
                ;   CF=0: no collision, CF=1: collision
                ; Preserves:
                ;   BC, IX, HL

BulletCollidesWithPlayer:
                ld      a, (ix+Player_phys_x)
                inc     a
                cp      c
                ret     nc
                add     a, 6-1
                cp      c
                jr      c, @@noCollision
                ld      a, (ix+Player_phys_y)
                add     a, 8
                cp      b
                jr      c, @@noCollision
                sub     a, 5+1
                ld      e, a
                ld      a, (ix+Player_state)
                cp      PLAYER_SITTING
                ld      a, e
                jr      z, @@sitting
                sub     a, 3
@@sitting:      cp      b
                ret
@@noCollision:  ccf
                ret

                ; Input:
                ;   HL => bullet
                ; Preserves:
                ;   IX

XorBullet:      ; calculate screen address
                inc     hl
                inc     hl
@@1:            ld      a, (hl)             ; Bullet_y
                ld      d, a
                rlca
                rlca
                and     0xe0
                ld      c, a                ; C = Y5 Y4 Y3  0  0  0  0  0
                ld      a, d
                rrca
                rrca
                rrca
                and     a, 0x18
                ld      b, a                ; B =  0  0  0 Y7 Y6  0  0  0 
                ld      a, d
                and     7                   ; A =  0  0  0  0  0 Y2 Y1 Y0
                or      b                   ; A =  0  0  0 Y7 Y6 Y2 Y1 Y0
                or      0x40
                ld      d, a                ; D =  0  1  0 Y7 Y6 Y2 Y1 Y0
                dec     hl
                ld      a, (hl)             ; Bullet_x
                ld      e, a
                ; choose bit
                and     7
                add     a, 0xff & BulletSprites
                exx
                ld      l, a
                ld      h, BulletSprites >> 8
                ld      a, (hl)
                exx
                ; draw
                ex      af, af'
                ld      a, e
                rrca
                rrca
                rrca
                and     0x1f
                or      c
                ld      e, a
                ex      af, af'
                ; xor bullet
                ex      de, hl
                xor     (hl)
                ld      (hl), a
                ex      de, hl
                ret

                ; Input:
                ;   D = Y
                ;   E = X
                ;   IXL = dir

SpawnBullet:    ld      a, (BulletCount)
                cp      MAX_BULLETS
                ret     z
                inc     a
                ld      (BulletCount), a
                ld      bc, Bullets-sizeof_Bullet
                call    CalcBulletAddr@@raw
                ld      a, ixl
                and     PHYS_HORIZONTAL
                jr      z, @@left
                ld      (hl), 1
                jr      @@done
@@left:         ld      (hl), -1
@@done:         inc     hl
                ld      (hl), e
                inc     hl
                ld      (hl), d
                jr      XorBullet@@1

                ; Input:
                ;   HL => bullet

DestroyBullet:  call    XorBullet
                dec     hl
                ex      de, hl
                ld      a, (BulletCount)
                dec     a
                ld      (BulletCount), a
                call    CalcBulletAddr
                repeat  sizeof_Bullet
                ldi
                endrepeat
                ret

                ; Input:
                ;   None

PassableAttr1 = UpdateDrawBullets@@passable1 + 1

UpdateDrawBullets:
                ld      a, (BulletCount)
                or      a
                ret     z
                ld      ixl, a
                ld      hl, Bullets
@@loop:         call    XorBullet
                dec     hl
                ld      c, (hl)     ; Bullet_dir
                inc     hl
                ld      a, (hl)     ; Bullet_x
                add     a, c
                add     a, c
                add     a, c
                ld      c, a
                ld      (hl), a
                inc     hl
                ld      b, (hl)     ; Bullet_y
                push    bc
                call    XorBullet@@1
                inc     hl
                pop     bc

                push    hl
                push    bc
                call    EnemyCollidesBullet
                pop     bc
                ld      a, h
                or      a
                jr      z, @@noEnemy
                call    KillEnemy
                jr      nz, @@noEnemy
                pop     hl
                jr      @@destroy
@@noEnemy:

                ld      de, 0
                call    ReadCollision
                cp      PASSABLE_ATTR
                pop     hl
                jr      z, @@notDestroy
@@passable1:    cp      0
                jr      nz, @@destroy
@@notDestroy:

                push    ix
                ld      ix, Player1
                call    BulletCollidesWithPlayer
                jr      c, @@killPlayer
                ld      a, (SinglePlayer)
                or      a
                jr      nz, @@skipPlayer2
                ld      ix, Player2
                call    BulletCollidesWithPlayer
                jr      c, @@killPlayer
@@skipPlayer2:  pop     ix

                inc     hl
@@continue:     dec     ixl
                jr      nz, @@loop
                ret
                
@@killPlayer:   ld      b, REASON_BULLET
                push    hl
                call    KillPlayer
                pop     hl
                pop     ix
@@destroy:      dec     hl
                dec     hl
                push    hl
                call    DestroyBullet
                pop     hl
                jr      @@continue
