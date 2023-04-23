
PhysObject_x = 0
PhysObject_y = 1
PhysObject_flags = 2
PhysObject_speed = 3
PhysObject_accel = 4

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

                section code_physics

                ; Input:
                ;   B = Y
                ;   C = X
                ;   IX => PhysObject
                ; Preserves:
                ;   DE

InitPhysObject: ld      (ix+PhysObject_x), c
                ld      (ix+PhysObject_y), b
                xor     a
                ld      (ix+PhysObject_flags), a
                ld      (ix+PhysObject_speed), a
                ld      (ix+PhysObject_accel), a
                ret

                ; Input:
                ;   C = speed
                ;   A = dir
                ;   IX => PhysObject

JumpPhysObject: and     PHYS_HORIZONTAL
                or      PHYS_UP
                ld      (ix+PhysObject_flags), a
                ld      (ix+PhysObject_speed), c
                ld      (ix+PhysObject_accel), 1
                ret

                ; Input:
                ;   D = height
                ;   IX => PhysObject
                ; Return:
                ;   ZF=0: true; ZF=1: false

UpdatePhysObject:
                bit     1, (ix+PhysObject_flags)    ; PHYS_UP
                ld      a, (ix+PhysObject_speed)
                jr      z, @@falling
                sub     a, (ix+PhysObject_accel)
                jr      c, @@fall
                jr      z, @@fall
                cp      7
                jr      c, @@fall
                ld      (ix+PhysObject_speed), a
                inc     (ix+PhysObject_accel)
                rlca
                rlca
                rlca
                and     7
                jr      z, @@retTrue
                ld      e, a
@@loop1:        push    de
                call    CanGoUp
                pop     de
                jr      nz, @@canGoUp
@@fall:         ld      a, (ix+PhysObject_flags)
                and     ~PHYS_VERTICAL
                ;or      PHYS_DOWN
                ld      (ix+PhysObject_flags), a
                xor     a
                jr      @@falling1
@@canGoUp:      dec     (ix+PhysObject_y)
                dec     e
                jr      nz, @@loop1
@@retTrue:      inc     a       ; return true
                ret
@@falling:      cp      0xf0
                jr      nc, @@1
@@falling1:     add     a, 8
                ld      (ix+PhysObject_speed), a
@@1:            rlca
                rlca
                rlca
                and     7
                jr      z, CanGoDown
                ld      e, a
@@loop2:        push    de
                call    CanGoDown
                pop     de
                jr      nz, @@canGoDown
                xor     a       ; return false
                ld      (ix+PhysObject_speed), a
                ret     
@@canGoDown:    inc     (ix+PhysObject_y)
                dec     e
                jr      nz, @@loop2
                inc     a       ; return true
                ret

                ; Input:
                ;   C = PhysObject.x
                ;   B = PhysObject.y
                ;   D = height
                ;   E = width
                ;   IX => PhysObject
                ; Output:
                ;   HL => address
                ;   A = attribute

ReadCollision:  ld      a, b
                rrca
                rrca
                rrca
                and     0x1f
                sub     a, d
                ;add     a, LEVEL_Y
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
                sub     e
                ld      l, a
                ld      de, 0x5800
                add     hl, de
                ld      a, (hl)
                ret

                ; Input:
                ;   D = height
                ;   IX => PhysObject
                ; Return:
                ;   ZF=0: true; ZF=1: false

CanGoUp:        ld      a, (ix+PhysObject_y)
                ld      b, a
                and     7
                ret     nz      ; return true
                ld      a, b
                cp      LEVEL_Y
                jr      c, @@retFalse
                ld      e, 0
                ld      c, (ix+PhysObject_x)
                call    ReadCollision
                cp      PASSABLE_ATTR
                jr      z, @@1
@@retFalse:     xor     a       ; return false
                ret
@@1:            ld      a, c
                and     7
                jr      z, @@retTrue
                inc     hl
@@2:            ld      a, (hl)
                cp      PASSABLE_ATTR
                jr      nz, @@retFalse
@@retTrue:      inc     a       ; return true
                ret

                ; Input:
                ;   IX => PhysObject
                ; Return:
                ;   ZF=0: true; ZF=1: false

CanGoDown:      ld      a, (ix+PhysObject_y)
                ld      b, a
                and     7
                ret     nz      ; return true
                ld      a, b
                cp      -8 + (LEVEL_Y + LEVEL_HEIGHT * 8)
                jr      nc, @@retFalse
                ld      de, 0xff00  ; D = -1, E = 0
                ld      c, (ix+PhysObject_x)
                call    ReadCollision
                cp      PASSABLE_ATTR
                jr      z, CanGoUp@@1
@@retFalse:     xor     a       ; return false
                ret

                ; Input:
                ;   IX => PhysObject
                ; Return:
                ;   ZF=0: true; ZF=1: false

CanGoLeft:      ld      a, (ix+PhysObject_x)
                or      a
                ret     z       ; return false
                ld      c, a
                and     7
                ret     nz      ; return true
                ld      de, 0x0001  ; D = 0, E = 1
@@check:        ld      b, (ix+PhysObject_y)
                call    ReadCollision
                cp      PASSABLE_ATTR
                jr      nz, CanGoDown@@retFalse
                ld      a, b
                and     7
                jr      z, CanGoUp@@retTrue
                ld      de, 32
                add     hl, de
                jr      CanGoUp@@2

                ; Input:
                ;   IX => PhysObject
                ; Return:
                ;   ZF=0: true; ZF=1: false

CanGoLeftWithItem:
                ld      a, (ix+PhysObject_x)
                or      a
                ret     z       ; return false
                ld      c, a
                and     7
                ret     nz      ; return true
                ld      de, 0x0001  ; D = 0, E = 1
@@check:        ld      b, (ix+PhysObject_y)
                call    ReadCollision
                cp      PASSABLE_ATTR
                jr      nz, CanGoDown@@retFalse
                ld      a, b
                and     7       ; clears CF
                ld      de, -32
                jr      z, @@1
                sbc     hl, de  ; +32
                ld      a, (hl)
                cp      PASSABLE_ATTR
                jr      nz, CanGoUp@@retFalse
                ld      de, -64
@@1:            add     hl, de  ; -32
                jr      CanGoUp@@2

                ; Input:
                ;   IX => PhysObject
                ; Return:
                ;   ZF=0: true; ZF=1: false

CanGoRight:     ld      a, (ix+PhysObject_x)
                ld      c, a
                and     7
                ret     nz      ; return true
                ld      a, c
                cp      -8 + (LEVEL_WIDTH * 8)
                jr      nc, CanGoDown@@retFalse
                ld      de, 0x00ff  ; D = 0, E = -1
                jr      CanGoLeft@@check

                ; Input:
                ;   IX => PhysObject
                ; Return:
                ;   ZF=0: true; ZF=1: false

CanGoRightWithItem:
                ld      a, (ix+PhysObject_x)
                ld      c, a
                and     7
                ret     nz      ; return true
                ld      a, c
                cp      -8 + (LEVEL_WIDTH * 8)
                jr      nc, CanGoDown@@retFalse
                ld      de, 0x00ff  ; D = 0, E = -1
                jr      CanGoLeftWithItem@@check
