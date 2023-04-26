
                section     code_high

                ; Input:
                ;   HL => pitch
                ;   DE => duration
                ; Output:
                ;   EXX swapped!
                ; Preserves:
                ;   IY
                ; Trashes:
                ;   A, BC, DE, HL, IX

MakeBeep:       ld          a, l
                srl         l
                srl         l
                cpl
                and         3
                ld          c, a
                ld          b, 0
                ld          ix, @@delay
                add         ix, bc
@@border:       ld          a, 8
@@delay:        nop
                nop
                nop
                inc         b
                inc         c
@@wait:         dec         c
                jr          nz, @@wait
                ld          c, 0x3f
                dec         b
                jp          nz, @@wait
@@speakerBit:   xor         0x10                ; Speaker bit
                out         (0xfe), a
                ld          b, h
                ld          c, a
                bit         4, a
                jr          nz, @@again
                ld          a, d
                or          e
                jr          z, @@end
                ld          a, c
                ld          c, l
                dec         de
                jp          (ix)
@@again:        ld          c, l
                inc         c
                jp          (ix)
@@end:          exx
                ret
