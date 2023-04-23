
                section code_draw

                ; Input:
                ;   None

ClearAttrib:    ld      hl, 0x5800
                ld      de, 0x5801
                xor     a
                ld      (hl), a
                ld      bc, 768
                ldir
                ret

                ; Input:
                ;   B = Y
                ;   C = X
                ; Preserves:
                ;   DE

CalcAttribAddr: ld      a, b
                rrca
                rrca
                rrca
                and     0x1f
                add     a, a        ; *= 2
                add     a, a        ; *= 4
                ld      l, a
                ld      h, 0
                add     hl, hl      ; *= 8
                add     hl, hl      ; *= 16
                add     hl, hl      ; *= 32
                ld      a, c
                rrca
                rrca
                rrca
                and     0x1f
                or      l
                ld      l, a
                ld      bc, 0x5800
                add     hl, bc
                ret

                ; Input:
                ;   E = tile X
                ;   D = tile Y
                ;   HL => pixels
                ; Preserves:
                ;   IXH

XorTile:        ; calculate screen address
                ld      a, d
                rrca
                rrca
                rrca
                and     0xe0
                or      e
                ld      e, a
                ld      a, 0x18
                and     d
                or      0x40
                ld      d, a
                ; draw pixels
                repeat  7
                ld      a, (hl)
                ld      (de), a
                inc     hl
                inc     d
                endrepeat
                ld      a, (hl)
                ld      (de), a
                ret

                ; Input:
                ;   E = tile X
                ;   D = tile Y
                ;   HL => pixels
                ;   IXH = attribute
                ; Preserves:
                ;   IXH

XorColoredTile: call    XorTile
                ld      a, d
                rrca
                rrca
                rrca
                and     3
                or      0x58
                ld      d, a
                ld      a, ixh
                ld      (de), a
                ret

                ; Input:
                ;   E = sprite X
                ;   D = sprite Y
                ;   HL => pixels
                ; Preserves:
                ;   IX

XorSprite:      ; calculate screen address
                ld      a, d
                rlca
                rlca
                and     0xe0
                ld      c, a                ; C = Y5 Y4 Y3  0  0  0  0  0
                ld      a, d
                rrca
                rrca
                rrca
                and     a, 0x18
                ld      b, a                ; B =  0  0  0 Y7 Y6  0  0  0 
                ld      a, d
                and     7                   ; A =  0  0  0  0  0 Y2 Y1 Y0
                or      b                   ; A =  0  0  0 Y7 Y6 Y2 Y1 Y0
                or      0x40
                ld      d, a                ; D =  0  1  0 Y7 Y6 Y2 Y1 Y0
                ; jump to proper routine
                ld      a, e
                rrca
                jr      c, @@__1
@@__0:          rrca
                jp      c, @@_10
@@_00:          rrca
                jp      c, @@100
                ; draw sprite with offset 0
@@000:          and     0x1f
                or      c
                ld      e, a
                ex      de, hl
                repeat  8, N
                ld      a, (de)
                xor     (hl)
                ld      (hl), a
                if      N < 7
                inc     de
                inc     h
                ld      a, 7
                and     h
                call    z, @@downHL
                endif
                endrepeat
                ret
                ; jump to proper routine
@@__1:          rrca
                jp      c, @@_11
@@_01:          rrca
                jp      c, @@101
                ; draw sprite with offset 1
@@001:          and     0x1f
                or      c
                ld      e, a
                ex      de, hl
                repeat  8, N
                ld      a, (de)
                rrca
                ld      b, a
                and     0x7f
                xor     (hl)
                ld      (hl), a
                inc     l
                ld      a, b
                and     0x80
                xor     (hl)
                ld      (hl), a
                if      N < 7
                inc     de
                dec     l
                inc     h
                ld      a, 7
                and     h
                call    z, @@downHL
                endif
                endrepeat
                ret
                ; jump to proper routine
@@_10:          rrca
                jp      c, @@110
                ; draw sprite with offset 2
@@010:          and     0x1f
                or      c
                ld      e, a
                ex      de, hl
                repeat  8, N
                ld      a, (de)
                rrca
                rrca
                ld      b, a
                and     0x3f
                xor     (hl)
                ld      (hl), a
                inc     l
                ld      a, b
                and     0xc0
                xor     (hl)
                ld      (hl), a
                if      N < 7
                inc     de
                dec     l
                inc     h
                ld      a, 7
                and     h
                call    z, @@downHL
                endif
                endrepeat
                ret
                ; jump to proper routine
@@_11:          rrca
                jp      c, @@111
                ; draw sprite with offset 3
@@011:          and     0x1f
                or      c
                ld      e, a
                ex      de, hl
                repeat  8, N
                ld      a, (de)
                rrca
                rrca
                rrca
                ld      b, a
                and     0x1f
                xor     (hl)
                ld      (hl), a
                inc     l
                ld      a, b
                and     0xe0
                xor     (hl)
                ld      (hl), a
                if      N < 7
                inc     de
                dec     l
                inc     h
                ld      a, 7
                and     h
                call    z, @@downHL
                endif
                endrepeat
                ret
                ; draw sprite with offset 4
@@100:          and     0x1f
                or      c
                ld      e, a
                ex      de, hl
                repeat  8, N
                ld      a, (de)
                rrca
                rrca
                rrca
                rrca
                ld      b, a
                and     0x0f
                xor     (hl)
                ld      (hl), a
                inc     l
                ld      a, b
                and     0xf0
                xor     (hl)
                ld      (hl), a
                if      N < 7
                inc     de
                dec     l
                inc     h
                ld      a, 7
                and     h
                call    z, @@downHL
                endif
                endrepeat
                ret
                ; draw sprite with offset 5
@@101:          and     0x1f
                or      c
                ld      e, a
                ex      de, hl
                repeat  8, N
                ld      a, (de)
                rlca
                rlca
                rlca
                ld      b, a
                and     0x07
                xor     (hl)
                ld      (hl), a
                inc     l
                ld      a, b
                and     0xf8
                xor     (hl)
                ld      (hl), a
                if      N < 7
                inc     de
                dec     l
                inc     h
                ld      a, 7
                and     h
                call    z, @@downHL
                endif
                endrepeat
                ret
                ; draw sprite with offset 6
@@110:          and     0x1f
                or      c
                ld      e, a
                ex      de, hl
                repeat  8, N
                ld      a, (de)
                rlca
                rlca
                ld      b, a
                and     0x03
                xor     (hl)
                ld      (hl), a
                inc     l
                ld      a, b
                and     0xfc
                xor     (hl)
                ld      (hl), a
                if      N < 7
                inc     de
                dec     l
                inc     h
                ld      a, 7
                and     h
                call    z, @@downHL
                endif
                endrepeat
                ret
                ; draw sprite with offset 7
@@111:          and     0x1f
                or      c
                ld      e, a
                ex      de, hl
                repeat  8, N
                ld      a, (de)
                rlca
                ld      b, a
                and     0x01
                xor     (hl)
                ld      (hl), a
                inc     l
                ld      a, b
                and     0xfe
                xor     (hl)
                ld      (hl), a
                if      N < 7
                inc     de
                dec     l
                inc     h
                ld      a, 7
                and     h
                call    z, @@downHL
                endif
                endrepeat
                ret
                ; adjust HL to skip through ZX Spectrum screen discontinuity
@@downHL:       ld      a, l
                sub     -32
                ld      l, a
                sbc     a, a
                and     -8
                add     a, h
                ld      h, a
                ret
