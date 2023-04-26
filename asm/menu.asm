
INK = 16
PAPER = 17
FLASH = 18
BRIGHT = 19

MENU_COIN1_X = 3
MENU_COIN1_Y = 3
MENU_COIN1_ATTR = COIN1_ATTR
MENU_COIN2_X = 28
MENU_COIN2_Y = 3
MENU_COIN2_ATTR = COIN2_ATTR

                section code_low

msgMainMenu:    db      INK,7,PAPER,1,BRIGHT,1,FLASH,0
                db      22, 2,5,"                      "
                db      22, 3,5," -= COINZ ARE MINE =- "
                db      22, 4,5,"                      "
                db      PAPER,0
                db      22,10,1,"[1] Single player"
                db      22,12,1,"[2] 2 player capture the coin"
                db      22,14,1,"[K] Redefine keys"
                db      PAPER,0
                db      22,20,4,"Code by Nikolay Zapolnov"
                db      22,21,1,"Gfx by Dexus, Music by n1k-o"
                db      22,22,7,"Levels by Nill:Rem"
                db      0xff

msgRedefine1:   db      INK,7,BRIGHT,1,FLASH,0
                db      PAPER,2
                db      22,10,11," PLAYER 1 "
                db      0xff

msgRedefine2:   db      INK,7,BRIGHT,1,FLASH,0
                db      PAPER,3
                db      22,10,11," PLAYER 2 "
                db      0xff

msgRedefine3:   db      PAPER,0
                db      22,11,11,"          "
                db      22,12,11," Left   ",FLASH,1," ",FLASH,0," "
                db      22,13,11," Right    "
                db      22,14,11," Up       "
                db      22,15,11," Down     "
                db      22,16,11," Fire     "
                db      22,17,11,"          "
                db      0xff

                section code_high

msgRight1:      db      22,12,19,FLASH,0," "
                db      22,13,19,FLASH,1," "
                db      0xff

msgUp1:         db      22,13,19,FLASH,0," "
                db      22,14,19,FLASH,1," "
                db      0xff

msgDown1:       db      22,14,19,FLASH,0," "
                db      22,15,19,FLASH,1," "
                db      0xff

msgFire1:       db      22,15,19,FLASH,0," "
                db      22,16,19,FLASH,1," "
                db      0xff

msgChooseLevel: db      22,12,5," Choose level [1-4]:",FLASH,1," ",FLASH,0," "
                db      0xff

MainMenuInit:   di
                ; install interrupt handler
                ld      a, InterruptVectors / 256
                ld      i, a
                im      2
                ; display language selection menu
                ei
                jp      MainMenu

                section code_low

MainMenu:       ld      hl, MenuPT3
                ld      a, 1
                call    PlayMusic

                if      PROFILER_ENABLED
                xor     a
                out     (0xfe), a
                endif

                call    ClearAttrib
                call    ClearScreen
                ld      ix, MainMenuFrame
                call    MenuFrame

                ld      hl, msgMainMenu
                call    DrawString

                call    XorCoin1
                call    XorCoin2

                call    WaitKeyReleased

@@loop:         halt
                if      PROFILER_ENABLED
                xor     a
                out     (0xfe), a
                endif

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

@@single:       xor     a
                ld      (CurrentLevel), a
                inc     a
                ld      (SinglePlayer), a
                call    Campaign
                jr      MainMenu

@@pvp:          xor     a
                ld      (SinglePlayer), a

                halt
                if      PROFILER_ENABLED
                xor     a
                out     (0xfe), a
                endif
                call    DimScreen
                ld      ix, PvpFrame
                call    MenuFrame

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
                cp      0x0c        ; 4
                jr      z, @@pvp4
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

@@pvp4:         ld      hl, PvpLevel4
                ld      de, PvpLevel4_size
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
                if      PROFILER_ENABLED
                xor     a
                out     (0xfe), a
                endif
                call    DimScreen
                ld      ix, RedefineFrame
                call    MenuFrame

                ld      hl, msgRedefine1
                call    DrawString
                ld      hl, msgRedefine3
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
                call    DrawString
                ld      hl, msgRedefine3
                call    @@redefine
                ld      (Player2 + Player_keyLeft_mask), bc
                ld      hl, msgRight1
                call    @@redefine
                ld      (Player2 + Player_keyRight_mask), bc
                ld      hl, msgUp1
                call    @@redefine
                ld      (Player2 + Player_keyUp_mask), bc
                ld      hl, msgDown1
                call    @@redefine
                ld      (Player2 + Player_keyDown_mask), bc
                ld      hl, msgFire1
                call    @@redefine
                ld      (Player2 + Player_keyFire_mask), bc

                ret

@@redefine:     call    DrawString
                call    WaitAnyKey
                call    WaitKeyReleased
                ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DimScreen:      ld          de, 0x5800
                ld          ixl, 3
@@outerLoop:    ld          b, 0                    ; 3 * 256 = 768
@@innerLoop:    ld          a, (de)
                and         7
                jr          z, @@inkIsZero
                ld          c, a                    ; C <- ink
                ld          a, (de)
                rrca
                rrca
                rrca
                and         7                       ; A <- paper
                jr          z, @@paperIsZero
                cp          c
                jr          nc, @@paperBrighter     ; ink > paper
@@inkBrighter:  ld          a, 0x01                 ; ink <- blue, paper <- black
                jr          @@done
@@inkIsZero:    ld          a, (de)
                and         0x38
                jr          z, @@done               ; ink & paper are both zero => keep as is
@@paperBrighter:ld          a, 0x08-1               ; ink <- black, paper <- blue
@@paperIsZero:  inc         a                       ; ink <- blue
@@done:         ld          (de), a
                inc         de
                djnz        @@innerLoop
                dec         ixl
                jr          nz, @@outerLoop
                ld          hl, 0x4000
                ld          e, 192
@@loop1:        ld          b, 32
@@loop2:        ld          a, h
                and         1
                ld          a, 0xaa
                jr          z, @@do
                ld          a, 0x55
@@do:           and         (hl)
                ld          (hl), a
                inc         hl
                djnz        @@loop2
                dec         e
                jr          nz, @@loop1
                ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Frame_cornerAttrib = 0
Frame_lineAttrib = 1
Frame_x = 2
Frame_y = 3
Frame_w = 4
Frame_h = 5
Frame_topLeft = 6
Frame_top = 8
Frame_topRight = 10
Frame_left = 12
Frame_right = 14
Frame_bottomLeft = 16
Frame_bottom = 18
Frame_bottomRight = 20
Frame_bottomCornerAttrib = 22

PvpFrame:       db      0x46                    ; corner attrib
                db      0x06                    ; lines attrib
                db      4                       ; x
                db      11                      ; y
                db      24                      ; w
                db      3                       ; h
                dw      BorderTopLeft
                dw      BorderTopCenter
                dw      BorderTopRight
                dw      BorderLeft
                dw      BorderRight
                dw      BorderBottomLeft
                dw      BorderBottomCenter
                dw      BorderBottomRight
                db      0x46                    ; bottom corner attrib

RedefineFrame:  db      0x46                    ; corner attrib
                db      0x06                    ; lines attrib
                db      10                      ; x
                db      9                       ; y
                db      12                      ; w
                db      10                      ; h
                dw      BorderTopLeft
                dw      BorderTopCenter
                dw      BorderTopRight
                dw      BorderLeft
                dw      BorderRight
                dw      BorderBottomLeft
                dw      BorderBottomCenter
                dw      BorderBottomRight
                db      0x46                    ; bottom corner attrib

MainMenuFrame:  db      0x45                    ; corner attrib
                db      0x05                    ; lines attrib
                db      1                       ; x
                db      0                       ; y
                db      30                      ; w
                db      7                       ; h
                dw      BorderTopLeft
                dw      BorderTopCenter
                dw      BorderTopRight
                dw      BorderLeft
                dw      BorderRight
                dw      BorderBottomLeft
                dw      BorderBottomCenter
                dw      BorderBottomRight
                db      0x45                    ; bottom corner attrib

LevelCompleteFrame:
                db      0x46                    ; corner attrib
                db      0x06                    ; lines attrib
                db      4                       ; x
                db      10                      ; y
                db      24                      ; w
                db      5                       ; h
                dw      Border1TopLeft
                dw      Border1TopCenter
                dw      Border1TopRight
                dw      Border1Left
                dw      Border1Right
                dw      Border1BottomLeft
                dw      Border1BottomCenter
                dw      Border1BottomRight
                db      0x06                    ; bottom corner attrib

RestartFrame:
                db      0x42                    ; corner attrib
                db      0x02                    ; lines attrib
                db      5                       ; x
                db      8                       ; y
                db      23                      ; w
                db      7                       ; h
                dw      Border1TopLeft
                dw      Border1TopCenter
                dw      Border1TopRight
                dw      Border1Left
                dw      Border1Right
                dw      Border1BottomLeft
                dw      Border1BottomCenter
                dw      Border1BottomRight
                db      0x02                    ; bottom corner attrib

HudFrame:       db      0x47                    ; corner attrib
                db      0x07                    ; lines attrib
                db      0                       ; x
                db      0                       ; y
                db      32                      ; w
                db      4                       ; h
                dw      BorderTopLeft
                dw      BorderTopCenter
                dw      BorderTopRight
                dw      BorderLeft
                dw      BorderRight
                dw      BorderBottomLeft
                dw      BorderBottomCenter
                dw      BorderBottomRight
                db      0x47                    ; bottom corner attrib

MenuFrame:      ld      b, (ix+Frame_cornerAttrib)
                ld      l, (ix+Frame_topLeft)
                ld      h, (ix+Frame_topLeft+1)
                ld      d, (ix+Frame_y)
                ld      e, (ix+Frame_x)
                call    DrawPixels
                ld      b, (ix+Frame_lineAttrib)
                ld      d, (ix+Frame_y)
                ld      a, (ix+Frame_x)
                add     a, (ix+Frame_w)
                dec     a
                ld      e, a
                push    de
                dec     e
@@loop1:        ld      l, (ix+Frame_top)
                ld      h, (ix+Frame_top+1)
                push    de
                call    DrawPixels
                pop     de
                dec     e
                ld      a, (ix+Frame_x)
                cp      e
                jr      nz, @@loop1
                ld      b, (ix+Frame_cornerAttrib)
                ld      l, (ix+Frame_topRight)
                ld      h, (ix+Frame_topRight+1)
                pop     de
                call    DrawPixels
                ld      b, (ix+Frame_lineAttrib)
                ld      a, (ix+Frame_y)
                add     a, (ix+Frame_h)
                dec     a
                ld      d, a
                push    de
                dec     d
@@loop2:        ld      l, (ix+Frame_left)
                ld      h, (ix+Frame_left+1)
                ld      e, (ix+Frame_x)
                push    de
                call    DrawPixels
                pop     de
                ld      l, (ix+Frame_right)
                ld      h, (ix+Frame_right+1)
                ld      a, (ix+Frame_w)
                add     a, e
                dec     a
                ld      e, a
                push    de
                call    DrawPixels
                pop     de
                dec     d
                ld      a, (ix+Frame_y)
                cp      d
                jr      nz, @@loop2
                pop     de
                ld      b, (ix+Frame_bottomCornerAttrib)
                ld      l, (ix+Frame_bottomLeft)
                ld      h, (ix+Frame_bottomLeft+1)
                ld      e, (ix+Frame_x)
                push    de
                call    DrawPixels
                pop     de
                ld      b, (ix+Frame_lineAttrib)
                ld      a, (ix+Frame_x)
                add     a, (ix+Frame_w)
                dec     a
                ld      e, a
                push    de
                dec     e
@@loop3:        ld      l, (ix+Frame_bottom)
                ld      h, (ix+Frame_bottom+1)
                push    de
                call    DrawPixels
                pop     de
                dec     e
                ld      a, (ix+Frame_x)
                cp      e
                jr      nz, @@loop3
                pop     de
                ld      b, (ix+Frame_bottomCornerAttrib)
                ld      l, (ix+Frame_bottomRight)
                ld      h, (ix+Frame_bottomRight+1)
                jr      DrawPixels

                ; Input:
                ;   D = Y
                ;   E = X
                ;   B = attr
                ;   HL => pixels

DrawPixels:     ; calculate screen address
                ld      a, d
                rrca
                rrca
                rrca
                and     0xe0
                or      e
                ld      e, a
                ld      a, 0x18
                and     d
                or      0x40
                ld      d, a
                ; draw pixels
                repeat  7
                ld      a, (hl)
                ld      (de), a
                inc     hl
                inc     d
                endrepeat
                ld      a, (hl)
                ld      (de), a
                ; calc attrib addr
                ld      a, d
                rrca
                rrca
                rrca
                and     3
                or      0x58
                ld      d, a
                ; draw attrib
                ld      a, b
                ld      (de), a
                ret

                ; Input:
                ;   A = char

X               db      0
Y               db      0
Attr            db      0

DrawChar:       ld      de, 0x3d00-32*8;(23606)
                ld      h, 0
                ld      l, a
                add     hl, hl
                add     hl, hl
                add     hl, hl
                add     hl, de
                ld      de, (X)
                ; calculate screen address
                ld      a, d
                rrca
                rrca
                rrca
                and     0xe0
                or      e
                ld      e, a
                ld      a, 0x18
                and     d
                or      0x40
                ld      d, a
                ; draw pixels
                repeat  4
                ld      a, (hl)
                ld      (de), a
                inc     hl
                inc     d
                endrepeat
                repeat  3
                ld      a, (hl)
                rla
                or      (hl)
                ld      (de), a
                inc     hl
                inc     d
                endrepeat
                ld      a, (hl)
                rla
                or      (hl)
                ld      (de), a
                ; calc attrib addr
                ld      a, d
                rrca
                rrca
                rrca
                and     3
                or      0x58
                ld      d, a
                ; draw attrib
                ld      a, b
                ld      (de), a
                ret

                ; Input:
                ;   B => attr
                ;   HL => string

DrawString:     ld      a, (hl)
                cp      0xff
                ret     z
                cp      22
                jr      z, @@at
                cp      INK
                jr      z, @@ink
                cp      PAPER
                jr      z, @@paper
                cp      FLASH
                jr      z, @@flash
                cp      BRIGHT
                jr      z, @@bright
                ld      bc, (Attr-1)
                inc     hl
                push    hl
                call    DrawChar
                ld      hl, X
                inc     (hl)
                pop     hl
                jr      DrawString
@@at:           inc     hl
                ld      a, (hl)
                ld      (Y), a
                inc     hl
                ld      a, (hl)
                ld      (X), a
                inc     hl
                jr      DrawString
@@ink:          inc     hl
                ld      a, (Attr)
                and     ~7
                or      (hl)
                ld      (Attr), a
                inc     hl
                jr      DrawString
@@paper:        inc     hl
                ld      a, (hl)
                rlca
                rlca
                rlca
                ld      b, a
                ld      a, (Attr)
                and     ~0x38
                or      b
                ld      (Attr), a
                inc     hl
                jr      DrawString
@@flash:        inc     hl
                ld      a, (hl)
                rrca
                and     0x80
                ld      b, a
                ld      a, (Attr)
                and     0x7f
                or      b
                ld      (Attr), a
                inc     hl
                jr      DrawString
@@bright:       inc     hl
                ld      a, (hl)
                rrca
                rrca
                and     0x40
                ld      b, a
                ld      a, (Attr)
                and     0xbf
                or      b
                ld      (Attr), a
                inc     hl
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
                if      PROFILER_ENABLED
                xor         a
                out         (0xfe), a
                endif
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
                ret         z
                if          PROFILER_ENABLED
                xor         a
                out         (0xfe), a
                endif
                jr          WaitKeyReleased
                ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

                section     data_menu

DefaultInput1:  db          0x01, 0xFD  ; A
                db          0x04, 0xFD  ; D
                db          0x02, 0xFB  ; W
                db          0x02, 0xFD  ; S
                db          0x01, 0x7F  ; Space

                section     code_low

DefaultInput2:  db          0x08, 0xBF  ; J
                db          0x02, 0xBF  ; L
                db          0x04, 0xDF  ; I
                db          0x04, 0xBF  ; K
                db          0x04, 0x7F  ; M
