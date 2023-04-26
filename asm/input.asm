
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

                section code_high

KCounter        db      0
KLastValue      db      0

KList           db      KEMPSTON_UP,0
                db      KEMPSTON_UP,0
                db      KEMPSTON_DOWN,0
                db      KEMPSTON_DOWN,0
                db      KEMPSTON_LEFT,0
                db      KEMPSTON_RIGHT,0
                db      KEMPSTON_LEFT,0
                db      KEMPSTON_RIGHT,0
                db      KEMPSTON_FIRE,0
                db      KEMPSTON_FIRE,0xff

ResetKC:        xor     a
                ld      (KLastValue), a
                ld      (KCounter), a
                ret

CheckKC:        call    GetKCInput
                ld      a, (KLastValue)
                cp      e
                ret     z   ; ZF=1
                ld      a, e
                ld      (KLastValue), a
                ld      a, (KCounter)
                ld      l, a
                ld      h, 0
                ld      bc, KList
                add     hl, bc
                ld      a, (hl)
                cp      0xff
                jr      z, @@last
                cp      e
                jr      nz, @@fail
                ld      hl, KCounter
                inc     (hl)
                xor     a
                ret     ; ZF=1
@@last:         xor     a
                cp      e
                jr      nz, @@fail
                inc     a   ; ZF=0
                ret
@@fail:         xor     a
                ld      (KCounter), a
                ret     ; ZF=1

GetKCInput:     ld      ix, Player1
                ld      e, 0
                ld      b, (ix+Player_keyUp_port)
                ld      a, (ix+Player_keyUp_mask)
                ld      l, KEMPSTON_UP
                call    CheckKCKey
                ld      b, (ix+Player_keyDown_port)
                ld      a, (ix+Player_keyDown_mask)
                ld      l, KEMPSTON_DOWN
                call    CheckKCKey
                ld      b, (ix+Player_keyLeft_port)
                ld      a, (ix+Player_keyLeft_mask)
                ld      l, KEMPSTON_LEFT
                call    CheckKCKey
                ld      b, (ix+Player_keyRight_port)
                ld      a, (ix+Player_keyRight_mask)
                ld      l, KEMPSTON_RIGHT
                call    CheckKCKey
                ld      b, (ix+Player_keyFire_port)
                ld      a, (ix+Player_keyFire_mask)
                ld      l, KEMPSTON_FIRE
CheckKCKey:     push    de
                push    hl
                call    KeyPressed
                pop     hl
                pop     de
                ret     nz
                ld      a, l
                or      e
                ld      e, a
                ret
