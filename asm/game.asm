
                section y_bss_game

SinglePlayer:   db      1

                section code_game

RunLevel:       call    LoadLevel
@@loop:         halt
                call    DrawSprites
                call    UpdateItems
                ld      ix, Player1
                call    DoPlayer
                ; if (!DoPlayer(&player1))
                ;   return false;
                ; if (!SinglePlayer) {
                ;   if (!DoPlayer(&player2))
                ;   return false;
                ; }
                jp      @@loop
