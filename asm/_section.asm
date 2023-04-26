section data_intro [file "INTRO", base 0x4000]
section beeper [file "BEEPER", base 0xc000]

section bss [base 0x5d0b, imaginary]

section data_player_jumps_1 [base 0x5fee]
section data_bullets [base 0x60b6]
section data_player_tables [base 0x60be]
section data_player_jumps_2 [base 0x60ee]
section data_tiles [base 0x6100]     ; aligned on 256 bytes

section data_gfx
section data_level1 [compress=zx7]
section data_level2 [compress=zx7]
section data_level3 [compress=zx7]
section data_level4 [compress=zx7]
section data_level5 [compress=zx7]
section data_level6 [compress=zx7]
section data_level7 [compress=zx7]
section data_level8 [compress=zx7]
section data_level9 [compress=zx7]
section data_level10 [compress=zx7]
section data_level11 [compress=zx7]
section data_level12 [compress=zx7]
section data_pvpLevel1 [compress=zx7]
section data_pvpLevel2 [compress=zx7]
section data_pvpLevel3 [compress=zx7]
section data_pvpLevel4 [compress=zx7]
section data_tiles
section data_menu

section code_entry [base 0x6000]
section code_draw
section code_level
section code_physics
section code_player
section code_sprites
section code_zx7
section code_items
section code_game
section code_flying
section code_enemies
