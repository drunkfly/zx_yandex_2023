section data_player_jumps_1 [base 0x5fee]
section data_player_tables [base 0x6060]
section data_player_jumps_2 [base 0x60ee]
section data_tiles [base 0x6100]     ; aligned on 256 bytes

section data_gfx
section data_level1 [compress=zx7]
section data_tiles

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

section y_bss_game
section y_bss_player
section y_bss_sprites
section y_bss_items
section y_bss_flying
