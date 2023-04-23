; -----------------------------------------------------------------------------
; ZX7 decoder by Einar Saukas, Antonio Villena & Metalbrain
; "Standard" version (69 bytes only)
; -----------------------------------------------------------------------------
; Parameters:
;   HL: source address (compressed data)
;   DE: destination address (decompressing)
; -----------------------------------------------------------------------------

                section main

Unzx7:          ld      a, 0x80
@@copyByte:     ldi                         ; copy literal byte
@@mainLoop:     call    @@nextBit
                jr      nc, @@copyByte      ; next bit indicates either literal or sequence
                ; determine number of bits used for length (Elias gamma coding)
                push    de
                ld      bc, 0
                ld      d, b
@@sizeLoop:     inc     d
                call    @@nextBit
                jr      nc, @@sizeLoop
                ; determine length
@@lenValueLoop: call    nc, @@nextBit
                rl      c
                rl      b
                jr      c, @@exit           ; check end marker
                dec     d
                jr      nz, @@lenValueLoop
                inc     bc                  ; adjust length
                ; determine offset
                ld      e, (hl)             ; load offset flag (1 bit) + offset value (7 bits)
                inc     hl
                db      0xcb, 0x33          ; opcode for undocumented instruction "SLL E" aka "SLS E"
                jr      nc, @@offsetEnd     ; if offset flag is set, load 4 extra bits
                ld      d, 0x10             ; bit marker to load 4 bits
@@rldNextBit:   call    @@nextBit
                rl      d                   ; insert next bit into D
                jr      nc, @@rldNextBit    ; repeat 4 times, until bit marker is out
                inc     d                   ; add 128 to DE
                srl	    d			        ; retrieve fourth bit from D
@@offsetEnd:    rr      e                   ; insert fourth bit into E
                ; copy previous sequence
                ex      (sp), hl            ; store source, restore destination
                push    hl                  ; store destination
                sbc     hl, de              ; HL = destination - offset - 1
                pop     de                  ; DE = destination
                ldir
@@exit:         pop     hl                  ; restore source address (compressed data)
                jr      nc, @@mainLoop
@@nextBit:      add     a, a                ; check next bit
                ret     nz                  ; no more bits left?
                ld      a, (hl)             ; load another group of 8 bits
                inc     hl
                rla
                ret
