
                section bss

SinglePlayer:   db      0
GameLevelDone:  db      0
CurrentLevel:   db      0

                section code_high

Levels:         dw      Level1, Level1_size
                dw      Level2, Level2_size
                dw      Level3, Level3_size
                dw      Level4, Level4_size
                dw      Level5, Level5_size
                dw      Level6, Level6_size
                dw      Level7, Level7_size
                dw      Level8, Level8_size
                dw      Level9, Level9_size
                dw      Level10, Level10_size
                dw      Level11, Level11_size
                dw      Level12, Level12_size
                dw      Level13, Level13_size
                dw      Level14, Level14_size
                dw      Level15, Level15_size
                dw      Level16, Level16_size
                dw      Level17, Level17_size
                dw      0

Campaign:       ld      a, (CurrentLevel)
                ld      ixl, a
                ld      ixh, 0
                add     ix, ix
                add     ix, ix
                ld      de, Levels
                add     ix, de
                ld      l, (ix+0)
                ld      h, (ix+1)
                xor     a
                cp      h
                jr      z, @@done
                ld      e, (ix+2)
                ld      d, (ix+3)
                call    RunLevel
                ;or      a
                ;ret     z
                ld      hl, CurrentLevel
                inc     (hl)
                jr      Campaign
@@done:         halt
                if      PROFILER_ENABLED
                xor     a
                out     (0xfe), a
                endif
                call    ClearAttrib
                ld      hl, msgGameComplete
                jp      RunLevel@@win1

                section code_low

                ; Input
                ;   HL => level data
                ;   DE => level data size
                ; Output:
                ;   A=0: exit to menu, A=1: restart

RunLevel:       push    hl
                push    de
                ld      hl, GamePT3
                call    PlayMusic
                pop     de
                pop     hl
                push    hl
                push    de
                call    LoadLevel
                ld      ix, HudFrame
                call    MenuFrame
                ld      hl, msgHud
                call    DrawString
                ld      a, 1
                ld      (SpritesEnabled), a
@@loop:         halt
                call    UpdateItems
                call    UpdateEnemies
                call    UpdateFlying
                call    UpdateDrawBullets
                ld      ix, Player1
                call    DoPlayer
                ld      a, (GameLevelDone)
                or      a
                ld      a, 0x31
                jr      nz, @@win
                ld      a, (SinglePlayer)
                or      a
                jr      nz, @@skipPlayer2
                ld      ix, Player2
                call    DoPlayer
                ld      a, (GameLevelDone)
                or      a
                ld      a, 0x32
                jr      nz, @@win
@@skipPlayer2:  if      PROFILER_ENABLED
                xor     a
                out     (0xfe), a
                endif
                ld      bc, 0xFEFE
                in      a, (c)
                and     1
                jr      nz, @@noQuit
                ld      bc, 0x7FFE
                in      a, (c)
                and     1
                jr      z, @@quit
@@noQuit:       jp      @@loop

@@quit:         xor     a
                ld      (SpritesEnabled), a
                halt
                if      PROFILER_ENABLED
                xor     a
                out     (0xfe), a
                endif
                call    DimScreen
                ld      ix, RestartFrame
                call    MenuFrame
                ld      hl, msgRestartQuit
                call    DrawString
@@quitLoop:     call    0x028E
                ld      a, e
                cp      0xff
                jr      z, @@quitLoop
                push    af
                call    WaitKeyReleased
                pop     af
                cp      0x0d        ; R
                jr      z, @@restart
                cp      0x25        ; Q
                jr      z, @@returnToMenu
                jr      @@quitLoop
@@restart:      pop     de
                pop     hl
                jp      RunLevel
@@returnToMenu: pop     de
                pop     hl
                xor     a
                ret

@@win:          pop     de
                pop     hl
                ld      (PlayerWinner), a
                xor     a
                ld      (SpritesEnabled), a
                halt
                if      PROFILER_ENABLED
                xor     a
                out     (0xfe), a
                endif
                call    DimScreen
                ld      ix, LevelCompleteFrame
                call    MenuFrame
                ld      hl, msgPlayerWin
                ld      a, (SinglePlayer)
                or      a
                jr      z, @@win1
                ld      hl, msgLevelComplete
@@win1:         call    DrawString
                call    WaitKeyReleased
                call    WaitAnyKey
                call    WaitKeyReleased
                ld      a, 1
                ret

msgHud:         db      INK,7,PAPER,0,BRIGHT,1
                db      22,1,1,'Level '
LevelNumber:    db      '00 OF 00'
                db      22,2,5,'[SHIFT+SPACE] RESTART/EXIT'
                db      0xff

msgPlayerWin:   db      INK,7,PAPER,0,BRIGHT,1
                db      22,11,5,'                      '
                db      22,12,5,'    PLAYER ' 
PlayerWinner:   db      '1'
                db      ' WIN!     '
                db      22,13,5,'                      '
                db      0xff

msgLevelComplete:
                db      INK,7,PAPER,0,BRIGHT,1
                db      22,11,5,'                      '
                db      22,12,5,'    LEVEL COMPLETE!   '
                db      22,13,5,'                      '
                db      0xff

msgRestartQuit: db      INK,7,PAPER,0,BRIGHT,1
                db      22,10,6,'                     '
                db      22,11,6,'  [R] Restart level  '
                db      22,12,6,'  [Q] Quit to menu   '
                db      22,13,6,'                     '
                db      0xff

msgGameComplete:
                db      INK,7,PAPER,0,BRIGHT,1,22,12,8,' GAME COMPLETE! '
                db      0xff
