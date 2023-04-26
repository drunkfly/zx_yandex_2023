
FLYING_MOVE_HORZ = 0x01
FLYING_DID_MIRROR = 0x02

sizeof_Flying = 10
Flying_phys_x = 0
Flying_phys_y = 1
Flying_phys_flags = 2
Flying_phys_speed = 3
Flying_phys_accel = 4
Flying_flags = 5
Flying_stoppedY = 6
Flying_spriteID = 7
Flying_attr = 8
Flying_spriteRef = 9

                section bss

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Flying:         repeat  MAX_FLYING
                db      0           ; phys.x
                db      0           ; phys.y
                db      0           ; phys.flags
                db      0           ; phys.speed
                db      0           ; phys.accel
                db      0           ; flags
                db      0           ; stoppedY
                db      0           ; spriteID
                db      0           ; attr
                db      0           ; spriteRef
                endrepeat

FlyingCount     db      0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

                section code_low

                ; Input:
                ;   A = item index
                ;   BC = base
                ; Output:
                ;   IX => item
                ; Preserves:
                ;   DE, HL

CalcFlyingAddr: ld      bc, Flying
@@raw:          add     a, a        ; *= 2
                ld      ixl, a
                add     a, a        ; *= 4
                add     a, a        ; *= 8
                add     a, ixl      ; *= 10
                ld      ixl, a
                ld      ixh, 0
                add     ix, bc
                ret

                ; Input:
                ;   B = Y
                ;   C = X
                ;   E = sprite ID
                ;   D = attr
                ;   H = dir
                ;   L = speed
                ; Output:
                ;   ZF=1: false, ZF=0: true

SpawnFlyingItem:ld      a, (FlyingCount)
                cp      MAX_FLYING
                ret     z       ; return false
                inc     a
                ld      (FlyingCount), a
                push    bc
                ld      bc, Flying-sizeof_Flying
                call    CalcFlyingAddr@@raw
                ld      (ix+Flying_spriteID), e
                ld      (ix+Flying_attr), d
                ld      (ix+Flying_flags), FLYING_MOVE_HORZ
                pop     bc
                push    bc
                call    InitPhysObject
                ld      a, h
                ld      c, l
                call    JumpPhysObject
                call    AllocSprite
                ld      b, e
                pop     de
                ld      (ix+Flying_spriteRef), a
                call    SetSprite
                xor     a
                inc     a       ; return true
                ret

                section code_high

                ; Input:
                ;   None

UpdateFlying:   ld      a, (FlyingCount)
                or      a
                ret     z
                ld      b, a
                ld      ix, Flying
@@loop:         push    bc
                bit     0, (ix+Flying_flags)    ; FLYING_MOVE_HORZ
                jr      nz, @@noResetMirror
                ld      a, (ix+Flying_phys_y)
                rrca
                rrca
                rrca
                and     0x1f
                cp      (ix+Flying_stoppedY)
                jr      z, @@noResetMirror
                set     1, (ix+Flying_flags)    ; FLYING_DID_MIRROR
@@noResetMirror:ld      b, (ix+Flying_phys_y)
                ld      c, (ix+Flying_phys_x)
                call    EnemyCollides
                ld      a, h
                or      a
                call    nz, KillEnemy
                push    ix
                ld      ix, Player1
                call    CollidesWithPlayer
                pop     ix
                jr      z, @@noHit1
                push    bc
                push    ix
                ld      ix, Player1
                ld      b, REASON_ITEM
                call    KillPlayer
                pop     ix
                pop     bc
@@noHit1:       ld      a, (SinglePlayer)
                or      a
                jr      nz, @@noHit2
                push    ix
                ld      ix, Player2
                call    CollidesWithPlayer
                pop     ix
                jr      z, @@noHit2
                push    ix
                ld      ix, Player2
                ld      b, REASON_ITEM
                call    KillPlayer
                pop     ix
@@noHit2:       ld      d, 1
                call    UpdatePhysObject
                jp      nz, @@stillFlying
                ld      a, (ix+Flying_phys_x)
                ld      b, a
                and     7
                jp      nz, @@stillFlying
                ld      a, (ix+Flying_flags)
                bit     1, a                    ; FLYING_DID_MIRROR
                jr      z, @@canMoveHorz
                bit     0, a                    ; FLYING_MOVE_HORZ
                jr      z, @@cantMoveHorz
@@canMoveHorz:  ld      a, (ix+Flying_phys_y)
                add     a, 8
                ld      c, a
                call    ItemAt
                ld      a, h
                or      a
                jr      nz, @@flyAgain
                ld      b, (ix+Flying_phys_y)
                ld      c, (ix+Flying_phys_x)
                push    ix
                ld      ix, Player1
                call    CollidesWithPlayerFull
                pop     ix
                jr      nz, @@flyAgain
                ld      a, (SinglePlayer)
                or      a
                jr      nz, @@maybeEnemy
                push    ix
                ld      ix, Player2
                call    CollidesWithPlayerFull
                pop     ix
                jr      nz, @@flyAgain
@@maybeEnemy:   call    EnemyCollides
                ld      a, h
                or      a
                jr      nz, @@flyAgain
@@cantMoveHorz: ld      b, (ix+Flying_phys_y)
                ld      c, (ix+Flying_phys_x)
                ld      e, (ix+Flying_spriteID)
                ld      d, (ix+Flying_attr)
                call    PlaceItem
                ; release sprite
                ld      a, (ix+Flying_spriteRef)
                call    ReleaseSprite
                ; remove item
                push    ix
                push    ix
                ld      a, (FlyingCount)
                dec     a
                ld      (FlyingCount), a
                call    CalcFlyingAddr
                push    ix
                pop     hl
                pop     de
                repeat  sizeof_Flying
                ldi
                endrepeat
                pop     ix
                ; continue
@@continue:     pop     bc
                dec     b
                jp      nz, @@loop
                ret
@@flyAgain:     set     0, (ix+Flying_flags)    ; FLYING_MOVE_HORZ
@@stillFlying:  bit     0, (ix+Flying_flags)    ; FLYING_MOVE_HORZ
                jr      z, @@setSprite
                bit     0, (ix+Flying_phys_flags);PHYS_HORIZONTAL
                jr      nz, @@right              ; PHYS_RIGHT
                call    CanGoLeft
                jr      z, @@cantGoLeft
                dec     (ix+Flying_phys_x)
                jr      @@setSprite
@@cantGoLeft:   bit     1, (ix+Flying_flags)    ; FLYING_DID_MIRROR
                jr      nz, @@cantMirror
                set     0, (ix+Flying_phys_flags);PHYS_RIGHT
@@didMirror:    set     1, (ix+Flying_flags)    ; FLYING_DID_MIRROR
                jr      @@setSprite
@@cantMirror:   res     0, (ix+Flying_flags)    ; FLYING_MOVE_HORZ
                ld      a, (ix+Flying_phys_y)
                rrca
                rrca
                rrca
                and     0x1f
                ld      (ix+Flying_stoppedY), a
                jr      @@setSprite
@@right:        call    CanGoRight
                jr      z, @@cantGoRight
                inc     (ix+Flying_phys_x)
                jr      @@setSprite
@@cantGoRight:  bit     1, (ix+Flying_flags)    ; FLYING_DID_MIRROR
                jr      nz, @@cantMirror
                res     0, (ix+Flying_phys_flags);PHYS_LEFT
                jr      @@didMirror
@@setSprite:    ld      a, (ix+Flying_spriteRef)
                ld      e, (ix+Flying_phys_x)
                ld      d, (ix+Flying_phys_y)
                ld      b, (ix+Flying_spriteID)
                call    SetSprite
                ld      de, sizeof_Flying
                add     ix, de
                jr      @@continue
                ret
