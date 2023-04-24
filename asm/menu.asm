
INK = 16
PAPER = 17
FLASH = 18
BRIGHT = 19

MENU_COIN1_X = 3
MENU_COIN1_Y = 2
MENU_COIN1_ATTR = COIN1_ATTR
MENU_COIN2_X = 28
MENU_COIN2_Y = 2
MENU_COIN2_ATTR = COIN2_ATTR

                section code_menu

msgMainMenu:    db      INK,7,PAPER,1,BRIGHT,1,FLASH,0
                db      22, 1,5,"                      "
                db      22, 2,5," -= COINZ ARE MINE =- "
                db      22, 3,5,"                      "
                db      PAPER,0
                db      22, 7,1,"[1] SINGLE PLAYER"
                db      22, 9,1,"[2] 2 PLAYER: CAPTURE THE COIN"
                db      22,11,1,"[K] REDEFINE KEYS"
                db      PAPER,0
                db      22,20,4,"CODE BY NIKOLAY ZAPOLNOV"
                db      22,21,1,"GFX BY VOLUTAR, MUSIC BY N1K-O"
                db      22,22,7,"LEVELS BY NILL:REM"
                db      0xff

msgRedefineMenu:db      INK,7,PAPER,0,BRIGHT,1,FLASH,0
                db      22, 2,1,"REDEFINE KEYS:"
                db      PAPER,1
                db      22, 4,1," PLAYER 1 "
                db      PAPER,0
                db      22, 6,2,"LEFT  "
                db      FLASH,1," "
                db      0xff

msgRight1:      db      FLASH,0
                db      22, 6,8," "
                db      22, 7,2,"RIGHT "
                db      FLASH,1," "
                db      0xff

msgUp1:         db      FLASH,0
                db      22, 7,8," "
                db      22, 8,2,"UP"
                db      22, 8,8,FLASH,1," "
                db      0xff

msgDown1:       db      FLASH,0
                db      22, 8,8," "
                db      22, 9,2,"DOWN  "
                db      FLASH,1," "
                db      0xff

msgFire1:       db      FLASH,0
                db      22, 9,8," "
                db      22,10,2,"FIRE  "
                db      FLASH,1," "
                db      0xff

msgRedefine2:   db      FLASH,0
                db      22,10,8," "
                db      PAPER,1
                db      22,12,1," PLAYER 2 "
                db      PAPER,0
                db      22,14,2,"LEFT  "
                db      FLASH,1," "
                db      0xff

msgRight2:      db      FLASH,0
                db      22,14,8," "
                db      22,15,2,"RIGHT "
                db      FLASH,1," "
                db      0xff

msgUp2:         db      FLASH,0
                db      22,15,8," "
                db      22,16,2,"UP"
                db      22,16,8,FLASH,1," "
                db      0xff

msgDown2:       db      FLASH,0
                db      22,16,8," "
                db      22,17,2,"DOWN  "
                db      FLASH,1," "
                db      0xff

msgFire2:       db      FLASH,0
                db      22,17,8," "
                db      22,18,2,"FIRE  "
                db      FLASH,1," "
                db      0xff

msgChooseLevel: db      22,2,2,"CHOOSE LEVEL [1-3]: ",FLASH,1," "
                db      0xff

                ; Input:
                ;   none

MainMenu:       halt
                call    ClearAttrib
                call    ClearScreen

                ld      hl, msgMainMenu
                call    DrawString

                call    XorCoin1
                call    XorCoin2

                call    WaitKeyReleased

@@loop:         halt

                ld      a, (Timer)
                and     7
                cp      7
                jr      nz, @@skipCoins
                call    XorCoin1
                call    XorCoin2
                ld      hl, CoinIndex
                inc     (hl)
                call    XorCoin1
                call    XorCoin2
@@skipCoins:

                call    0x028E
                ld      a, e
                cp      0xff
                jr      z, @@loop

                push    af
                call    WaitKeyReleased
                pop     af

                cp      0x11        ; K
                jr      z, @@redefine
                cp      0x24        ; 1
                jr      z, @@single
                cp      0x1c        ; 2
                jr      z, @@pvp
                jr      @@loop

@@redefine:     call    RedefineMenu
                jr      MainMenu

@@single:       ld      a, 1
                ld      (SinglePlayer), a
                call    Campaign
                jr      MainMenu

@@pvp:          xor     a
                ld      (SinglePlayer), a

                halt
                call    ClearAttrib
                call    ClearScreen

                ld      hl, msgChooseLevel
                call    DrawString

@@pvpLoop:      call    0x028E
                ld      a, e
                cp      0xff
                jr      z, @@pvpLoop

                push    af
                call    WaitKeyReleased
                pop     af

                cp      0x24        ; 1
                jr      z, @@pvp1
                cp      0x1c        ; 2
                jr      z, @@pvp2
                cp      0x14        ; 3
                jr      z, @@pvp3
                jr      @@pvpLoop

@@pvp1:         ld      hl, PvpLevel2
                ld      de, PvpLevel2_size
@@runPvp:       call    RunLevel
                jp      MainMenu

@@pvp2:         ld      hl, PvpLevel1
                ld      de, PvpLevel1_size
                jr      @@runPvp

@@pvp3:         ld      hl, PvpLevel3
                ld      de, PvpLevel3_size
                jr      @@runPvp

                ; Input:
                ;   A = sprite index

XorCoin1:       ld      hl, 0x5800 + MENU_COIN1_Y * 32 + MENU_COIN1_X
                ld      de, MENU_COIN1_Y*8*256 + MENU_COIN1_X*8
                ld      b, MENU_COIN1_ATTR
                jr      XorCoin
XorCoin2:       ld      hl, 0x5800 + MENU_COIN2_Y * 32 + MENU_COIN2_X
                ld      de, MENU_COIN2_Y*8*256 + MENU_COIN2_X*8
                ld      b, MENU_COIN2_ATTR
CoinIndex = XorCoin + 1
XorCoin:        ld      a, 0
                and     3
                add     a, SPRITE_Coin1
                ld      (hl), b
                jp      DrawSprites@@draw

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

                ; Input:
                ;   none

RedefineMenu:   halt
                call    ClearAttrib
                call    ClearScreen

                ld      hl, msgRedefineMenu
                call    @@redefine
                ld      (Player1 + Player_keyLeft_mask), bc
                ld      hl, msgRight1
                call    @@redefine
                ld      (Player1 + Player_keyRight_mask), bc
                ld      hl, msgUp1
                call    @@redefine
                ld      (Player1 + Player_keyUp_mask), bc
                ld      hl, msgDown1
                call    @@redefine
                ld      (Player1 + Player_keyDown_mask), bc
                ld      hl, msgFire1
                call    @@redefine
                ld      (Player1 + Player_keyFire_mask), bc

                ld      hl, msgRedefine2
                call    @@redefine
                ld      (Player2 + Player_keyLeft_mask), bc
                ld      hl, msgRight2
                call    @@redefine
                ld      (Player2 + Player_keyRight_mask), bc
                ld      hl, msgUp2
                call    @@redefine
                ld      (Player2 + Player_keyUp_mask), bc
                ld      hl, msgDown2
                call    @@redefine
                ld      (Player2 + Player_keyDown_mask), bc
                ld      hl, msgFire2
                call    @@redefine
                ld      (Player2 + Player_keyFire_mask), bc

                ret

@@redefine:     call    DrawString
                call    WaitAnyKey
                call    WaitKeyReleased
                ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

                ; Input:
                ;   HL => string

DrawString:     ld      a, (hl)
                cp      0xff
                ret     z
                inc     hl
                rst     0x10
                jr      DrawString

                ; Output:
                ;   B => port
                ;   C => mask

WaitAnyKey:     ld          bc, 0xFEFE
@@loop:         in          a, (c)
                and         0x1f
                cp          0x1f
                jr          nz, @@found
                rlc         b
                jr          @@loop
@@found:        ld          c, 1
                rrca
                ret         nc
                inc         c       ; 2
                rrca
                ret         nc
                ld          c, 4
                rrca
                ret         nc
                ld          c, 8
                rrca
                ret         nc
                ld          c, 0x10
                ret

                ; Input:
                ;   None
                ; Preserves:
                ;   BC

WaitKeyReleased:xor         a
                in          a, (0xfe)
                and         0x1f
                cp          0x1f
                jr          nz, WaitKeyReleased
                ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

                section     data_menu

DefaultInput1:  db          0x01, 0xFD  ; A
                db          0x04, 0xFD  ; D
                db          0x02, 0xFB  ; W
                db          0x02, 0xFD  ; S
                db          0x01, 0x7F  ; Space
DefaultInput2:  db          0x08, 0xBF  ; J
                db          0x02, 0xBF  ; L
                db          0x04, 0xDF  ; I
                db          0x04, 0xBF  ; K
                db          0x04, 0x7F  ; M
