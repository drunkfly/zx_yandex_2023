
                section bss

SinglePlayer:   db      0
GameLevelDone:  db      0

                section code_game

Campaign:       ld      hl, Level1
                ld      de, Level1_size
                call    RunLevel
                ld      hl, Level2
                ld      de, Level2_size
                call    RunLevel
                ld      hl, Level3
                ld      de, Level3_size
                call    RunLevel
                ld      hl, Level4
                ld      de, Level4_size
                call    RunLevel
                ld      hl, Level5
                ld      de, Level5_size
                call    RunLevel
                ld      hl, Level6
                ld      de, Level6_size
                call    RunLevel
                ld      hl, Level7
                ld      de, Level7_size
                call    RunLevel
                ld      hl, Level8
                ld      de, Level8_size
                call    RunLevel
                ld      hl, Level9
                ld      de, Level9_size
                call    RunLevel
                ld      hl, Level10
                ld      de, Level10_size
                call    RunLevel
                ld      hl, Level11
                ld      de, Level11_size
                call    RunLevel
                ld      hl, Level12
                ld      de, Level12_size
                call    RunLevel
                halt
                call    ClearAttrib
                ld      hl, msgGameComplete
                jp      RunLevel@@win1

RunLevel:       push    hl
                push    de
                call    LoadLevel
                ld      ix, HudFrame
                call    MenuFrame
                ld      hl, msgHud
                call    DrawString
@@loop:         halt
                ld      a, 3
                out     (0xfe), a
                call    DrawSprites
                ld      a, 4
                out     (0xfe), a
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
@@skipPlayer2:
                ld      bc, 0xFEFE
                in      a, (c)
                and     1
                jr      nz, @@noQuit
                ld      bc, 0x7FFE
                in      a, (c)
                and     1
                jr      z, @@quit
@@noQuit:
          ; FIXME
          ld a, 5
          out (0xfe), a
          call MusicPlayer@@play
                xor     a
                out     (0xfe), a
                jp      @@loop

@@quit:         halt
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
                ret

@@win:          pop     de
                pop     hl
                ld      (PlayerWinner), a
                halt
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
                db      22,10,6,'               '
                db      22,11,6,'  [R] Restart level  '
                db      22,12,6,'  [Q] Quit to menu   '
                db      22,13,6,'                     '
                db      0xff

msgGameComplete:
                db      INK,7,PAPER,0,BRIGHT,1,22,12,8,' GAME COMPLETE! '
                db      0xff
