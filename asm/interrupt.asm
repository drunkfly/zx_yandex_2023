
DEBUG_ENABLED = 1

                section     intvec [align 256]

InterruptVectors:
                repeat      257
                db          InterruptEntry / 256
                endrepeat

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

                section     code_low

MusicEnabled    db          0
SpritesEnabled  db          0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

                section     interrupt

InterruptEntry: push        af
                push        bc
                push        de
                push        hl
                ex          af, af'
                exx
                push        af
                push        bc
                push        de
                push        hl
                push        ix
                push        iy
                if          DEBUG_ENABLED
                ld          a, 1
                out         (0xfe), a
                endif
                ; Sprites
                ld          a, (SpritesEnabled)
                or          a
                jr          z, @@skipSprites
                call        DrawSprites
@@skipSprites:  if          DEBUG_ENABLED
                ld          a, 2
                out         (0xfe), a
                endif
                ; Music
                ld          a, (MusicEnabled)
                or          a
                jr          z, @@skipMusic
                call        MusicPlayer@@play
@@skipMusic:    ; Timer
                ld          hl, Timer
                inc         (hl)
                if          DEBUG_ENABLED
                ld          a, 3
                out         (0xfe), a
                endif
                ; restore registers
                pop         iy
                pop         ix
                pop         hl
                pop         de
                pop         bc
                pop         af
                exx
                ex          af, af'
                pop         hl
                pop         de
                pop         bc
                pop         af
                ei
                ret
