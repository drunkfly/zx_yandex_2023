
                section data_tiles

Tiles:          db      PASSABLE_ATTR       ; 0
                dw      Empty
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

CoinTopTile:    db      PASSABLE_ATTR
                dw      CoinTop
CoinTop1Tile:   db      PASSABLE_ATTR
                dw      CoinTop1
CoinTop2Tile:   db      PASSABLE_ATTR
                dw      CoinTop2

                section code_level

                ; Input:
                ;   HL => compressed level data
                ;   DE => 0x4000 + compressed level size

LoadLevel:      xor     a
                ld      (SpriteCount), a
                ld      (ItemCount), a
                ld      (FlyingCount), a
                ld      (EnemyCount), a
                ld      (GameLevelDone), a
                push    de
                push    hl
                halt
                call    ClearAttrib
                call    ClearScreen
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
@@drawTile:     ld      a, (hl)
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
                cp      OBJ_PLAYER1_TOP
                jr      z, @@player1top
                cp      OBJ_PLAYER2_TOP
                jr      z, @@player2top
                cp      OBJ_PLAYER1_COIN
                jr      z, @@player1coin
                cp      OBJ_PLAYER2_COIN
                jr      z, @@player2coin
                cp      OBJ_STONE
                jp      z, @@stone
                cp      OBJ_GHOST
                jr      z, @@ghost
@@doneEmpty:    xor     a
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

@@player2coin:  push    de
                ld      d, COIN2_ATTR
                jr      @@playerCoin
@@player1coin:  ld      a, (SinglePlayer)
                or      a
                jr      nz, @@doneEmpty
                push    de
                ld      d, COIN1_ATTR
@@playerCoin:   ld      e, SPRITE_Coin1
                push    bc
                sla     b
                sla     b
                sla     b
                sla     c
                sla     c
                sla     c
                call    PlaceItem
                pop     bc
                pop     de
                jr      @@doneObject

@@player1top:   ld      ix, Player1
                ld      hl, CoinTop1Tile
                jr      @@playerTop
@@player2top:   ld      ix, Player2
                ld      hl, CoinTop2Tile
@@playerTop:    ld      a, (SinglePlayer)
                or      a
                jr      z, @@playerTop1
                ld      hl, CoinTopTile
@@playerTop1:   push    bc
                sla     c
                sla     c
                sla     c
                ld      a, c
                sub     a, 8
                ld      (ix+Player_gatesX), a
                sla     b
                sla     b
                sla     b
                ld      a, b
                add     a, 8
                ld      (ix+Player_gatesY), a
                pop     bc
                ld      ixl, 1
                jp      @@drawTile

@@ghost:        push    bc
                push    de
                sla     b
                sla     b
                sla     b
                sla     c
                sla     c
                sla     c
                ;ld      de, GhostSprites
                ;call    SpawnEnemy
                pop     de
                pop     bc

@@stone:        push    bc
                push    de
                sla     b
                sla     b
                sla     b
                sla     c
                sla     c
                sla     c
                ld      e, SPRITE_Stone
                ld      d, STONE_ATTR
                call    PlaceItem
                pop     de
                pop     bc
@@doneObject:   call    @@advance
                jp      @@loop

@@advance:      inc     c
                ld      a, 32
                cp      c
                ret     nz
                ld      c, 0
                dec     b
                ret
