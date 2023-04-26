
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
                jr      RunLevel@@win1

RunLevel:       call    LoadLevel
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
                xor     a
                out     (0xfe), a
                jp      @@loop

@@win:          ld      (PlayerWinner), a
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

msgGameComplete:
                db      INK,7,PAPER,0,BRIGHT,1,22,12,8,' GAME COMPLETE! '
                db      0xff
