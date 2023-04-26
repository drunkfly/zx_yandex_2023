
                section data_tiles

Tiles:          db      PASSABLE_ATTR       ; 0
                dw      Empty
                db      BRICKS_ATTR         ; 1
                dw      Bricks
                db      PASSABLE_ATTR       ; 2
                dw      CoinTopLeft
                db      PASSABLE_ATTR       ; 3
                dw      CoinTopRight
                db      PASSABLE_ATTR       ; 4
                dw      CoinLeft
                db      PASSABLE_ATTR       ; 5
                dw      CoinRight
                ; bricks
                db      BRICKS_ATTR         ; 6     ++
                dw      Bricks5
                db      BRICKS_ATTR         ; 7
                dw      Bricks6
                db      BRICKS_ATTR         ; 8
                dw      Bricks1
                db      BRICKS_ATTR         ; 9
                dw      Bricks4
                db      BRICKS_ATTR         ; 10    ++
                dw      Bricks2
                db      BRICKS_ATTR         ; 11
                dw      Bricks3
                ; bricks 2
                db      BRICKS2_ATTR        ; 12    ++
                dw      Bricks5
                db      BRICKS2_ATTR        ; 13
                dw      Bricks6
                db      BRICKS2_ATTR        ; 14
                dw      Bricks1
                db      BRICKS2_ATTR        ; 15
                dw      Bricks4
                db      BRICKS2_ATTR        ; 16    ++
                dw      Bricks2
                db      BRICKS2_ATTR        ; 17
                dw      Bricks3
                ; stones 1
                db      STONES1_ATTR        ; 18    ++
                dw      Stones1
                db      STONES1_ATTR        ; 19
                dw      Stones2
                ; bricks 3
                db      BRICKS3_ATTR        ; 20    ++
                dw      Bricks5
                db      BRICKS3_ATTR        ; 21
                dw      Bricks6
                db      BRICKS3_ATTR        ; 22
                dw      Bricks1
                db      BRICKS3_ATTR        ; 23
                dw      Bricks4
                db      BRICKS3_ATTR        ; 24    ++
                dw      Bricks2
                db      BRICKS3_ATTR        ; 25
                dw      Bricks3
                ; bricks 4
                db      BRICKS4_ATTR        ; 26    ++
                dw      Bricks5
                db      BRICKS4_ATTR        ; 27
                dw      Bricks6
                db      BRICKS4_ATTR        ; 28
                dw      Bricks1
                db      BRICKS4_ATTR        ; 29
                dw      Bricks4
                db      BRICKS4_ATTR        ; 30    ++
                dw      Bricks2
                db      BRICKS4_ATTR        ; 31
                dw      Bricks3
                ; stones 2
                db      STONES2_ATTR        ; 32    ++
                dw      Stones1
                db      STONES2_ATTR        ; 33
                dw      Stones2
                ; stones 3
                db      STONES3_ATTR        ; 34    ++
                dw      Stones1
                db      STONES3_ATTR        ; 35
                dw      Stones2
                ; stones 4
                db      STONES4_ATTR        ; 36    ++
                dw      Stones1
                db      STONES4_ATTR        ; 37
                dw      Stones2
                ; stones 5
                db      STONES5_ATTR        ; 38    ++
                dw      Stones1
                db      STONES5_ATTR        ; 39
                dw      Stones2
                ; bricks 5
                db      BRICKS5_ATTR        ; 40    ++
                dw      Bricks5
                db      BRICKS5_ATTR        ; 41
                dw      Bricks6
                db      BRICKS5_ATTR        ; 42
                dw      Bricks1
                db      BRICKS5_ATTR        ; 43
                dw      Bricks4
                db      BRICKS5_ATTR        ; 44    ++
                dw      Bricks2
                db      BRICKS5_ATTR        ; 45
                dw      Bricks3
                ; chains
ChainsAttr1:    db      0                   ; 46    ++
                dw      Chains1
ChainsAttr2:    db      0                   ; 47
                dw      Chains2
                ; mushrooms
                db      0x06                ; 48
                dw      Mushroom1
                db      0x06                ; 49
                dw      Mushroom2
                db      0x05                ; 50
                dw      Mushroom1
                db      0x05                ; 51
                dw      Mushroom2
                db      0x02                ; 52
                dw      Mushroom1
                db      0x02                ; 53
                dw      Mushroom2
                db      0x03                ; 54
                dw      Mushroom1
                db      0x03                ; 55
                dw      Mushroom2

CoinTopTile:    db      PASSABLE_ATTR
                dw      CoinTop
CoinTop1Tile:   db      PASSABLE_ATTR
                dw      CoinTop1
CoinTop2Tile:   db      PASSABLE_ATTR
                dw      CoinTop2

                section code_low

                ; Input:
                ;   HL => compressed level data
                ;   DE => 0x4000 + compressed level size

LoadLevel:      xor     a
                ld      (SpriteCount), a
                ld      (ItemCount), a
                ld      (FlyingCount), a
                ld      (EnemyCount), a
                ld      (BulletCount), a
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
                dec     de
                ld      a, (de)
                ld      (PassableAttr1), a
                ld      (PassableAttr2), a
                ld      (PassableAttr3), a
                ld      (PassableAttr4), a
                ld      (PassableAttr5), a
                ld      (PassableAttr6), a
                ld      (PassableAttr7), a
                ld      (ChainsAttr1), a
                ld      (ChainsAttr2), a
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
                jp      nz, @@single
                bit     7, a                ; bit 7 = single object
                jp      nz, @@object
                ; save counter
                ld      ixl, a
                ; read value
                dec     de
@@rleLoop:      ld      a, (de)
                cp      6
                jr      z, @@randomize
                cp      10
                jr      z, @@randomize
                cp      12
                jr      z, @@randomize
                cp      16
                jr      z, @@randomize
                cp      18
                jr      z, @@randomize
                cp      20
                jr      z, @@randomize
                cp      24
                jr      z, @@randomize
                cp      26
                jr      z, @@randomize
                cp      30
                jr      z, @@randomize
                cp      32
                jr      z, @@randomize
                cp      34
                jr      z, @@randomize
                cp      36
                jr      z, @@randomize
                cp      38
                jr      z, @@randomize
                cp      40
                jr      z, @@randomize
                cp      44
                jr      z, @@randomize
                cp      46
                jr      nz, @@do
@@randomize:    ex      af, af'
                ld      hl, 0x500-0x4000
                add     hl, de
                ld      a, r
                xor     (hl)
                rrca
                xor     (hl)
                rrca
                xor     (hl)
                and     2
                ld      l, 1
                jr      z, @@do1
                dec     l
@@do1:          ex      af, af'
                add     a, l
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
                push    hl
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
                jp      @@loop
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
                jp      z, @@ghost
                cp      OBJ_BAT
                jp      z, @@bat
                cp      OBJ_FLOWER_LEFT
                jp      z, @@flowerLeft
                cp      OBJ_FLOWER_RIGHT
                jp      z, @@flowerRight
                cp      OBJ_FLOWER_AUTO
                jp      z, @@flowerAuto
                cp      OBJ_WEAPON
                jr      z, @@weapon
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

@@weapon:       push    de
                ld      de, WEAPON_ATTR*256 + SPRITE_Weapon1
                jr      @@placeItem

@@player2coin:  push    de
                ld      d, COIN2_ATTR
                jr      @@playerCoin
@@player1coin:  ld      a, (SinglePlayer)
                or      a
                jr      nz, @@doneEmpty
                push    de
                ld      d, COIN1_ATTR
@@playerCoin:   ld      e, SPRITE_Coin1
@@placeItem:    push    bc
                sla     b
                sla     b
                sla     b
                sla     c
                sla     c
                sla     c
                call    PlaceItem
                pop     bc
                pop     de
                jp      @@doneObject

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

@@ghost:        push    de
                ld      de, GhostSprites
                jr      @@enemy
@@bat:          push    de
                ld      de, BatSprites
                jr      @@enemy
@@flowerLeft:   push    de
                ld      de, FlowerSprites
@@enemy:        call    @@spawnEnemy
@@doneSpawn:    pop     de
                jp      @@doneEmpty

@@flowerRight:  push    de
                ld      de, FlowerSprites
                call    @@spawnEnemy
                set     0, (ix+Enemy_phys_flags)    ; PHYS_RIGHT
                jr      @@doneSpawn

@@flowerAuto:   push    de
                ld      de, FlowerSprites
                call    @@spawnEnemy
                set     6, (ix+Enemy_state)         ; ENEMY_FLIP_AFTER_SHOOT
                jr      @@doneSpawn

@@spawnEnemy:   push    bc
                sla     b
                sla     b
                sla     b
                sla     c
                sla     c
                sla     c
                call    SpawnEnemy
                pop     bc
                ret

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
