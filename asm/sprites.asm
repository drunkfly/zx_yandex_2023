
                section y_bss_sprites

sizeof_Sprite       = 6
Sprite_oldX         = 0
Sprite_oldY         = 1
Sprite_oldSprite    = 2
Sprite_newX         = 3
Sprite_newY         = 4
Sprite_newSprite    = 5

Sprites:        repeat  MAX_SPRITES
                db      0           ; oldX
                db      0           ; oldY
                db      0           ; oldSprite
                db      0           ; newX
                db      0           ; newY
                db      0           ; newSprite
                endrepeat

SpriteCount     db      0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

                section code_sprites

                ; Input:
                ;   A = sprite index
                ;   BC = base
                ; Output:
                ;   HL => sprite
                ; Preserves:
                ;   DE

CalcSpriteAddr: ld      bc, Sprites
@@raw:          add     a, a        ; *= 2
                ld      l, a
                add     a, a        ; *= 4
                add     a, l        ; *= 6
                ld      l, a
                ld      h, 0
                add     hl, bc
                ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

                ; Input:
                ;   None
                ; Output:
                ;   A = sprite ID
                ; Preserves:
                ;   IX, DE

AllocSprite:    ld      a, (SpriteCount)
                cp      MAX_SPRITES
                jr      z, @@overflow
                push    af
                inc     a
                ld      (SpriteCount), a
                ld      bc, Sprites+2-sizeof_Sprite
                call    CalcSpriteAddr@@raw
                ld      (hl), SPRITE_EMPTY
                inc     hl
                inc     hl
                ld      (hl), SPRITE_EMPTY
                pop     af
                ret
@@overflow:     xor     a
                ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

                ; Input:
                ;   A = sprite index

ReleaseSprite:  call    CalcSpriteAddr
                push    hl
                call    DrawSprites@@xor
                ld      a, (SpriteCount)
                dec     a
                ld      (SpriteCount), a
                call    CalcSpriteAddr
                pop     de
                repeat  sizeof_Sprite
                ldi
                endrepeat
                ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

                ; Input:
                ;   A = Sprite index
                ;   E = X
                ;   D = Y
                ;   B = Sprite ID

SetSprite:      ld      ixl, b
                ld      bc, Sprites+3
                call    CalcSpriteAddr@@raw
                ld      (hl), e
                inc     hl
                ld      (hl), d
                inc     hl
                ld      a, ixl
                ld      (hl), a
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
                dec     ixl
                jr      nz, @@loop1
                ; update
                ld      a, (SpriteCount)
                ld      b, a
@@loop2:        dec     hl
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
