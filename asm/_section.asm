section data_intro [file "INTRO", base 0x4000]
section beeper [file "BEEPER", base 0xc000]

section bss [base 0x5d0a, imaginary]
section bss_music [base 0xc000, imaginary]
section bss_temp [base 0xe000, imaginary]
TempBuffer:

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
section data_level13 [compress=zx7]
section data_level14 [compress=zx7]
section data_level15 [compress=zx7]
section data_level16 [compress=zx7]
section data_level17 [compress=zx7]
section data_pvpLevel1 [compress=zx7]
section data_pvpLevel2 [compress=zx7]
section data_pvpLevel3 [compress=zx7]
section data_pvpLevel4 [compress=zx7]
section data_tiles
section data_menu [base 0x60ac]

section code_entry [base 0x6000]
section code_low [base 0x61b1]
section code_mid [base 0x8101]
section code_zx7 [base 0x6067]

section intvec [base 0x8000]
section interrupt [base 0x8181]

section pt3_game [compress=zx7]
