
                section code_entry

Start:          ld      sp, 0x5d0b

                xor     a
                ld      (Player1 + Player_kempston), a
                ld      (Player2 + Player_kempston), a
                ld      hl, DefaultInput1
                ld      de, Player1 + Player_keyLeft_mask
                ld      bc, 10
                ldir
                ld      hl, DefaultInput2
                ld      de, Player2 + Player_keyLeft_mask
                ld      bc, 10
                ldir

                ld      hl, COIN2_ATTR*256 + COIN1_ATTR
                ld      (Player1 + Player_myCoin), hl
                ld      hl, COIN1_ATTR*256 + COIN2_ATTR
                ld      (Player2 + Player_myCoin), hl

                xor     a
                out     (0xfe), a

                ld      a, 2
                call    0x1601            ; open screen
                ld      hl, msgPressAnyKey
                call    DrawString
                call    WaitAnyKey
                jp      MainMenu

msgPressAnyKey: db      PAPER,7,INK,1,FLASH,1,BRIGHT,1
                db      22,21,23,"  PRESS  "
                db      22,22,23," ANY KEY ",0xff
