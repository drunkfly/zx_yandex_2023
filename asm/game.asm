
                section y_bss_game

SinglePlayer:   db      0

                section code_game

RunLevel:       call    LoadLevel
@@loop:         halt
                ld      a, 3
                out     (0xfe), a
                call    DrawSprites
                ld      a, 4
                out     (0xfe), a
                call    UpdateItems
                call    UpdateFlying
                ld      ix, Player1
                call    DoPlayer
                ; if (!DoPlayer(&player1))
                ;   return false;
                ld      a, (SinglePlayer)
                or      a
                jr      nz, @@skipPlayer2
                ld      ix, Player2
                call    DoPlayer
                ;   if (!DoPlayer(&player2))
                ;   return false;
@@skipPlayer2:
                ld      a, 7
                out     (0xfe), a
                jp      @@loop
