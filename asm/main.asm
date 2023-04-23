
                section code_entry

Start:          ld      hl, Level1
                ld      de, Level1_size
                call    RunLevel

RunLevel:       call    LoadLevel
@@loop:         halt
                call    DrawSprites
                ld      ix, Player1
                call    DoPlayer
                ; if (!DoPlayer(&player1))
                ;   return false;
                ; if (!SinglePlayer) {
                ;   if (!DoPlayer(&player2))
                ;   return false;
                ; }
                jp      @@loop
