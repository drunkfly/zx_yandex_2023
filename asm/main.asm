

                section main

Start:          

                ld      e, 0
                ld      d, 0

                ld      hl, GhostRight1
                push    de
                call    XorSprite
                pop     de

@@loop:         ld      hl, GhostRight1
                push    de
                call    XorSprite
                pop     de

                inc     e
                inc     d

                ld      hl, GhostRight1
                push    de
                call    XorSprite
                pop     de

                halt
                halt
                halt
                halt
                halt
                halt
                halt
                halt

                jp @@loop


loop:           jp      loop
