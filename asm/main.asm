
                section code_entry

msgPressAnyKey: db      PAPER,7,INK,1,FLASH,1,BRIGHT,1
                db      22,21,22,"  PRESS  "
                db      22,22,22," ANY KEY ",0xff

Start:          ld      sp, 0x5d80

                xor         a
                ld          (Player1 + Player_kempston), a
                ld          (Player2 + Player_kempston), a
                ld          hl, DefaultInput1
                ld          de, Player1 + Player_keyLeft_mask
                ld          bc, 10
                ldir
                ld          hl, DefaultInput2
                ld          de, Player2 + Player_keyLeft_mask
                ld          bc, 10
                ldir

;                xor     a
                ;out     (0xfe), a
                ld      a, 2
                call    0x1601            ; open screen
                ld      hl, msgPressAnyKey
                call    DrawString
                call    WaitAnyKey
                jp      MainMenu
