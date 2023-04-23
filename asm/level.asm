
                section tiles

Tiles:          db      PASSABLE_ATTR       ; 0
                dw      0x5800;Empty
                db      0x57                ; 1
                dw      Bricks
                db      PASSABLE_ATTR       ; 2
                dw      CoinTopLeft
                db      PASSABLE_ATTR       ; 3
                dw      CoinTopRight
                db      PASSABLE_ATTR       ; 4
                dw      CoinLeft
                db      PASSABLE_ATTR       ; 5
                dw      CoinRight

                section main

                ; Input:
                ;   HL => compressed level data
                ;   DE => 0x4000 + compressed level size

LoadLevel:      xor     a
                ld      (SpriteCount), a
                push    de
                push    hl
                halt
                call    ClearAttrib
                pop     hl
                ld      de, 0x4000
                call    Unzx7
                pop     de
                ; DE => pointer to data
                ; B,C => y,x
                ld      bc, 256*(LEVEL_Y+LEVEL_HEIGHT-1)+0
@@loop:         ; check for end
                ld      a, e
                or      a
                jr      nz, @@cont
                ld      a, d
                cp      0x40
                ret     z
@@cont:         ; read next byte
                dec     de
                ld      a, (de)
                bit     6, a                ; bit 6 = single item
                jr      nz, @@single
                bit     7, a                ; bit 7 = single object
                jr      nz, @@object
                ; save counter
                ld      ixl, a
                ; read value
                dec     de
                ld      a, (de)
                ; resolve tile address
@@do:           ld      l, a
                rlca                        ; A *= 2
                add     a, l                ; A *= 3
                ld      l, a
                ld      h, Tiles >> 8
                ; read attribute
                ld      a, (hl)
                ld      ixh, a
                inc     hl
                ; read pixels address
                ld      a, (hl)
                inc     hl
                ld      h, (hl)
                ld      l, a
                ; draw tiles
@@rleLoop:      push    hl
                push    de
                push    bc
                ld      e, c
                ld      d, b
                call    XorColoredTile
                pop     bc
                pop     de
                pop     hl
                call    @@advance
                dec     ixl
                jr      nz, @@rleLoop
                jr      @@loop
@@single:       ld      ixl, 1
                and     0x3f
                jr      @@do
@@object:       and     0x7f
                cp      OBJ_PLAYER1_START
                jr      z, @@player1start
                cp      OBJ_PLAYER2_START
                jr      z, @@player2start
                xor     a
                jr      @@single

@@player1start: ld      ix, Player1
                jr      @@playerStart
@@player2start: ld      ix, Player2
@@playerStart:  push    bc
                sla     b
                sla     b
                sla     b
                sla     c
                sla     c
                sla     c
                call    InitPlayer
                pop     bc
                jr      @@doneEmpty

@@doneEmpty:    xor     a
                jr      @@single
@@doneObject:   call    @@advance
                jr      @@loop

@@advance:      inc     c
                ld      a, 32
                cp      c
                ret     nz
                ld      c, 0
                dec     b
                ret
