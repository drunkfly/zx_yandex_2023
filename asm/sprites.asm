
                section bss

sizeof_Sprite       = 7
Sprite_oldX         = 0
Sprite_oldY         = 1
Sprite_oldSprite    = 2
Sprite_newX         = 3
Sprite_newY         = 4
Sprite_newSprite    = 5
Sprite_inUse        = 6

Sprites:        repeat  MAX_SPRITES
                db      0           ; oldX
                db      0           ; oldY
                db      0           ; oldSprite
                db      0           ; newX
                db      0           ; newY
                db      0           ; newSprite
                db      0           ; inUse
                endrepeat

SpriteCount     db      0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

                section code_low

                ; Input:
                ;   A = sprite index
                ;   BC = base
                ; Output:
                ;   HL => sprite
                ; Preserves:
                ;   DE, IX

CalcSpriteAddr: ld      bc, Sprites
@@raw:          ld      h, a
                add     a, a        ; *= 2
                ld      l, a
                add     a, a        ; *= 4
                add     a, l        ; *= 6
                add     a, h        ; *= 7
                ld      l, a
                ld      h, 0
                add     hl, bc
                ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

                section code_mid

                ; Input:
                ;   None
                ; Output:
                ;   A = sprite index
                ; Preserves:
                ;   IX, DE

AllocSprite:    ld      a, (SpriteCount)
                or      a
                jr      z, @@notFound
                ld      b, a
                ld      c, 0
                ld      hl, Sprites+Sprite_inUse
                push    de
                ld      de, sizeof_Sprite
@@loop:         ld      a, (hl)
                or      a
                jr      z, @@found
                inc     c
                add     hl, de
                djnz    @@loop
                pop     de
                jr      @@notFound
@@found:        pop     de
                ld      a, c
                jr      @@init
@@notFound:     ld      a, (SpriteCount)
                cp      MAX_SPRITES
                jr      z, @@overflow
                inc     a
                ld      (SpriteCount), a
                dec     a
@@init:         ld      bc, Sprites+Sprite_oldSprite
                push    af
                call    CalcSpriteAddr@@raw
                xor     a ; SPRITE_EMPTY
                ld      (hl), a
                inc     hl
                inc     hl
                inc     hl
                ld      (hl), a
                inc     hl
                ld      (hl), 1
                pop     af
                ret
@@overflow:     xor     a
                ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

                section code_low

                ; Input:
                ;   A = sprite index
                ; Preserves:
                ;   IX

ReleaseSprite:  call    CalcSpriteAddr
                push    hl
                call    DrawSprites@@xor
                pop     hl
                xor     a ; SPRITE_EMPTY
                inc     hl
                inc     hl
                ld      (hl), a
                inc     hl
                inc     hl
                inc     hl
                ld      (hl), a
                inc     hl
                ld      (hl), a ; inUse = 0
                ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

                ; Input:
                ;   A = Sprite index
                ;   E = X
                ;   D = Y
                ;   B = Sprite ID
                ; Preserves:
                ;   IX

SetSprite:      push    bc
                ld      bc, Sprites+Sprite_newX
                call    CalcSpriteAddr@@raw
                pop     bc
                ld      (hl), e
                inc     hl
                ld      (hl), d
                inc     hl
                ld      (hl), b
                ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawSprites:    ; draw
                ld      a, (SpriteCount)
                or      a
                ret     z
                ld      ixl, a
                ld      hl, Sprites
@@loop1:        ; erase
                call    @@xor
                ; draw
                call    @@xor
                inc     hl
                dec     ixl
                jr      nz, @@loop1
                ; update
                ld      a, (SpriteCount)
                ld      b, a
@@loop2:        dec     hl
                dec     hl
                ld      a, (hl)
                dec     hl
                ld      d, (hl)
                dec     hl
                ld      e, (hl)
                dec     hl
                ld      (hl), a
                dec     hl
                ld      (hl), d
                dec     hl
                ld      (hl), e
                djnz    @@loop2
                ret
@@xor:          ld      e, (hl)
                inc     hl
                ld      d, (hl)
                inc     hl
                ld      a, (hl)
                inc     hl
@@draw:         push    hl
                ld      h, 0
                ld      l, a
                add     hl, hl
                add     hl, hl
                add     hl, hl
                ld      bc, Empty
                add     hl, bc
                call    XorSprite
                pop     hl
                ret
