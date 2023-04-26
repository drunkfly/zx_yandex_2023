
                section code_low

                ; Input:
                ;   B = object Y
                ;   C = object X
                ;   IX => player
                ; Output:
                ;   ZF=1: false, ZF=0: true
                ; Preserves:
                ;   BC

CollidesWithPlayer:
                ld      a, (ix+Player_phys_x)
                add     a, 2-8
                cp      c
                jr      nc, @@retFalse
                add     a, 5-(2-8)
                cp      c
                jr      c, @@retFalse
                ld      a, (ix+Player_phys_y)
                add     a, 6
                cp      b
                jr      c, @@retFalse
                ld      e, a
                ld      a, (ix+Player_state)
                cp      PLAYER_SITTING
                jr      nz, @@notSitting
                ld      a, 4-8-(6)
                add     a, e
                cp      b
                jr      nc, @@retFalse
@@retTrue:      xor     a
                inc     a
                ret
@@notSitting:   ld      a, 1-8-(6)
                add     a, e
                cp      b
                jr      c, @@retTrue
@@retFalse:     xor     a
                ret

                ; Input:
                ;   B = object Y
                ;   C = object X
                ;   IX => player
                ; Output:
                ;   ZF=1: false, ZF=0: true
                ; Preserves:
                ;   BC

CollidesWithPlayerFull:
                ld      a, (ix+Player_phys_x)
                add     a, -8
                cp      c
                jr      nc, CollidesWithPlayer@@retFalse
                add     a, 7+8
                cp      c
                jr      c, CollidesWithPlayer@@retFalse
                ld      a, (ix+Player_phys_y)
                add     a, -8
                cp      b
                jr      nc, CollidesWithPlayer@@retFalse
                add     a, 7+8
                cp      b
                jr      c, CollidesWithPlayer@@retFalse
@@retTrue:      xor     a
                inc     a
                ret
