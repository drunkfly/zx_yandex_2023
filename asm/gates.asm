
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

                section code_high

DoorX           db      0
DoorY           db      0

SwitchCount     db      0
GateOpen        db      0
GateAnim        db      0
GateTimer       db      0

sizeof_Switch = 2
Switch_x = 0
Switch_y = 1

Switches:       repeat  MAX_SWITCHES
                db      0       ; x
                db      0       ; y
                endrepeat

                ; Input:
                ;   HL = top sprite
                ;   DE = bottom sprite
                ;   IXH = attribute

DrawGates:      push    ix
                push    de
                ld      de, (DoorX)
                call    XorColoredTile
                pop     hl
                pop     ix
                ld      de, (DoorX)
                inc     d
                jp      XorColoredTile

                ; Input:
                ;   B = player Y
                ;   C = player X
                ; Preserves:
                ;   BC, IX

GateToggleSwtch:ld      a, (GateAnim)
                or      a
                ret     nz
                ld      a, (SwitchCount)
                or      a
                ret     z

                push    ix
                push    bc
                ld      ixl, a

                ld      a, b
                rrca
                rrca
                rrca
                and     0x1f
                ld      b, a
                ld      a, c
                rrca
                rrca
                rrca
                and     0x1f
                ld      c, a

                ld      hl, Switches
                push    ix

@@search:       ld      a, (hl)
                inc     hl
                cp      c
                jr      nz, @@notFound
                ld      a, (hl)
                inc     hl
                cp      b
                jr      nz, @@notFound2

                pop     ix
                jr      @@found
                
@@notFound:     inc     hl
@@notFound2:    dec     ixl
                jr      nz, @@search

                pop     ix
                pop     bc
                pop     ix
                ret

@@found:        ld      a, (GateOpen)
                or      a
                ld      de, SwitchOff
                ld      a, 0
                jr      nz, @@isOpen
                ld      de, SwitchOn
                ld      a, 1
@@isOpen:       ld      (GateOpen), a
                ld      a, 4
                ld      (GateAnim), a
                ld      a, GATE_DELAY
                ld      (GateTimer), a

                ld      hl, Switches
@@loop:         push    de
                push    bc
                ld      c, (hl)
                inc     hl
                ld      a, (hl)
                inc     hl
                push    hl
                ld      h, a
                ld      l, c
                ex      de, hl
                ld      ixh, SWITCH_ATTR
                call    XorColoredTile
                pop     hl
                pop     bc
                pop     de
                dec     ixl
                jr      nz, @@loop

                push    iy
                call    _PlayShieldDestroySound2
                pop     iy

                pop     bc
                pop     ix
                ret

                ; Input:
                ;  None

UpdateGates:    ld      a, (GateAnim)
                ld      b, a
                or      a
                ret     z
                ld      a, (GateTimer)
                dec     a
                ld      (GateTimer), a
                jr      z, @@nextTimer
                and     3
                ret     nz
                push    iy
                call    _PlayElevatorSound
                pop     iy
                ret
@@nextTimer:    ld      a, GATE_DELAY
                ld      (GateTimer), a
                ld      a, (GateOpen)
                rrca
                ld      c, a
                ld      a, b
                dec     a
                ld      (GateAnim), a
                or      c

                cp      0x83
                jr      z, @@close1
                cp      0x82
                jr      z, @@close2
                cp      0x81
                jr      z, @@close3
                cp      0x80
                jr      z, @@close4

                cp      0x03
                jr      z, @@open1
                cp      0x02
                jr      z, @@open2
                cp      0x01
                jr      z, @@open3
                cp      0x00
                jr      z, @@open4
                ret

@@close1:       ld      hl, Gates2_1
                ld      de, Gates2_2
                ld      ixh, DOOR_ATTR
                jp      DrawGates

@@close2:       ld      hl, Gates3_1
                ld      de, Gates3_2
                ld      ixh, DOOR_ATTR
                jp      DrawGates

@@close3:       ld      hl, Gates4_1
                ld      de, Gates4_2
                ld      ixh, DOOR_ATTR
                jp      DrawGates

@@close4:       ld      hl, Empty
                ld      de, Empty
                ld      ixh, PASSABLE_ATTR
                jp      DrawGates

@@open1:        ld      hl, Gates4_1
                ld      de, Gates4_2
                ld      ixh, DOOR_ATTR
                jp      DrawGates

@@open2:        ld      hl, Gates3_1
                ld      de, Gates3_2
                ld      ixh, DOOR_ATTR
                jp      DrawGates

@@open3:        ld      hl, Gates2_1
                ld      de, Gates2_2
                ld      ixh, DOOR_ATTR
                jp      DrawGates

@@open4:        ld      hl, Gates1_1
                ld      de, Gates1_2
                ld      ixh, DOOR_ATTR
                jp      DrawGates
