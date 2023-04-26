
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
                dw      Level18, Level18_size
                dw      Level19, Level19_size
                dw      Level20, Level20_size
LevelsEnd:      dw      0

LevelCount = (LevelsEnd - Levels) / 4

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
                if      !PROFILER_ENABLED
                or      a
                ret     z
                endif
                ld      hl, CurrentLevel
                inc     (hl)
                jr      Campaign
@@done:         halt
                if      PROFILER_ENABLED
                xor     a
                out     (0xfe), a
                ;jr      @@doneWin
                endif
                call    ClearAttrib
                call    ClearScreen
                ld      hl, Win1
                ld      de, TempBuffer
                call    Unzx7
                ld      hl, TempBuffer
                call    DrawPicture
                ld      hl, WinPT3
                ld      a, 3
                call    PlayMusic
                ld      hl, 0x5800
                ld      de, 0x5801
                ld      (hl), 0x47
                ld      bc, 768
                ldir
                ld      hl, Win2
                ld      de, TempBuffer
                call    Unzx7
                ld      hl, msgGameComplete
                call    DrawString
                call    WaitKeyReleased
@@doneLoop:     halt
                if      PROFILER_ENABLED
                xor     a
                out     (0xfe), a
                endif
                call    CheckKC
                jr      nz, @@easterEgg
                call    CheckPauseKey
                jr      z, @@doneWin
                jr      @@doneLoop
@@easterEgg:    ld      hl, TempBuffer
                call    DrawPicture
@@doneLoop2:    halt
                if      PROFILER_ENABLED
                xor     a
                out     (0xfe), a
                endif
                call    CheckPauseKey
                jr      nz, @@doneLoop2
@@doneWin:      call    WaitKeyReleased
                ld      a, 1
                ret

                section code_low

                ; Input
                ;   HL => level data
                ;   DE => level data size
                ; Output:
                ;   A=0: exit to menu, A=1: restart

RunLevel:       push    hl
                push    de
                ld      hl, GamePT3
                ld      a, 0
                call    PlayMusic
                pop     de
                pop     hl
                push    hl
                push    de
                call    LoadLevel
                ld      ix, HudFrame
                call    MenuFrame
                ld      a, (SinglePlayer)
                or      a
                jr      z, @@multi
                call    UpdateLevelCounter
                ld      hl, msgHud
                call    DrawString
                jr      @@doneHud
@@multi:        ld      hl, msgHudMulti
                call    DrawString
@@doneHud:      ld      hl, msgHudBottom
                call    DrawString
                ld      a, 1
                ld      (SpritesEnabled), a
@@loop:         halt
                if      PROFILER_ENABLED
                ld      a, 4
                out     (0xfe), a
                endif
@@loop1:        call    UpdateItems
                call    UpdateEnemies
                call    UpdateFlying
                call    UpdateDrawBullets
                call    UpdateGates
                ld      ix, Player1
                call    DoPlayer
                ld      a, (GameLevelDone)
                or      a
                ld      a, 0x31
                jp      nz, @@win
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
                call    CheckPauseKey
                jp      nz, @@loop
@@quit:         xor     a
                ld      (SpritesEnabled), a
                halt
                if      PROFILER_ENABLED
                xor     a
                out     (0xfe), a
                endif
                call    PlayMenuSound
                ld      hl, 0x4000
                ld      de, TempBuffer
                ld      bc, 6912
                ldir
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
                call    PlayMenuSound
                call    WaitKeyReleased
                pop     af
                cp      0x0f        ; C
                jr      z, @@returnToGame
                cp      0x0d        ; R
                jr      z, @@restart
                cp      0x25        ; Q
                jr      z, @@returnToMenu
                jr      @@quitLoop
@@returnToGame: halt
                if      PROFILER_ENABLED
                xor     a
                out     (0xfe), a
                endif
                ld      hl, TempBuffer
                ld      de, 0x4000
                ld      bc, 6912
                ldir
                ld      a, 1
                ld      (SpritesEnabled), a
                jp      @@loop1
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
                push    af
                push    iy
                push    de
                call    _PlayCollectSound
                pop     de
                pop     iy
                pop     af
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
LevelNumber:    db      '00 of '
LevelTotal:     db      '00'
                db      0xff

msgHudMulti:    db      INK,7,PAPER,0,BRIGHT,1
                db      22,1,1,'PvP level '
PvpLevelNumber: db      '0'
                db      0xff

msgHudBottom:   db      22,2,8,'[Caps+Space] Pause menu'
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
                db      22, 9,6,'                     '
                db      22,10,6,'  [C] Continue       '
                db      22,11,6,'  [R] Restart level  '
                db      22,12,6,'  [Q] Quit to menu   '
                db      22,13,6,'                     '
                db      0xff

                section code_high

msgGameComplete:
                db      INK,6,PAPER,0,BRIGHT,1
                db      22,(PICTURE_Y/8+8+2),11,'WELL DONE!'
                db      INK,7,BRIGHT,0
                db      22,(PICTURE_Y/8+8+4),3,'Press CAPS+SPACE to return'
                db      22,(PICTURE_Y/8+8+5),10,'to main menu'
                db      0xff

CheckPauseKey:  ld      bc, 0xFEFE
                in      a, (c)
                and     1
                ret     nz
                ld      bc, 0x7FFE
                in      a, (c)
                and     1
                ret

UpdateLevelCounter:
                ld      a, (CurrentLevel)
                inc     a
                call    NumToString
                ld      a, (NumToStrBuf+1)
                add     a, 0x30
                ld      (LevelNumber), a
                ld      a, (NumToStrBuf+2)
                add     a, 0x30
                ld      (LevelNumber+1), a
                ld      a, LevelCount
                call    NumToString
                ld      a, (NumToStrBuf+1)
                add     a, 0x30
                ld      (LevelTotal), a
                ld      a, (NumToStrBuf+2)
                add     a, 0x30
                ld      (LevelTotal+1), a
                ret
