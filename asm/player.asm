
PLAYER_IDLE                 = 0xee + 0*2
PLAYER_MOVING               = 0xee + 1*2
PLAYER_JUMPING              = 0xee + 2*2
PLAYER_DEAD_FALLING         = 0xee + 3*2
PLAYER_DEAD                 = 0xee + 4*2
PLAYER_WAKING_UP            = 0xee + 5*2
PLAYER_SITTING              = 0xee + 6*2
PLAYER_DEAD_FALLING_RESPAWN = 0xee + 7*2
PLAYER_DEAD_RESPAWN         = 0xee + 8*2

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

                section bss

Player_phys_x           = 0
Player_phys_y           = 1
Player_phys_flags       = 2
Player_phys_speed       = 3
Player_phys_accel       = 4
Player_state            = 5
Player_cooldown         = 6
Player_gunCount         = 7
Player_itemSpriteID     = 8
Player_itemAttr         = 9
Player_gatesX           = 10
Player_gatesY           = 11
Player_originalX        = 12
Player_originalY        = 13
Player_keyLeft_mask     = 14
Player_keyLeft_port     = 15
Player_keyRight_mask    = 16
Player_keyRight_port    = 17
Player_keyUp_mask       = 18
Player_keyUp_port       = 19
Player_keyDown_mask     = 20
Player_keyDown_port     = 21
Player_keyFire_mask     = 22
Player_keyFire_port     = 23
Player_spriteRef        = 24
Player_itemSpriteRef    = 25
Player_invincibility    = 26
Player_myCoin           = 27
Player_enemyCoin        = 28
Player_onGroundPrev     = 29

Player1:        db      0           ; phys.x
                db      0           ; phys.y
                db      0           ; phys.flags
                db      0           ; phys.speed
                db      0           ; phys.accel
                db      0           ; state
                db      0           ; cooldown
                db      0           ; gunCount
                db      0           ; itemSpriteID
                db      0           ; itemAttr
                db      0           ; gatesX
                db      0           ; gatesY
                db      0           ; originalX
                db      0           ; originalY
                db      0x02        ; keyLeft.mask
                db      0xDF        ; keyLeft.port      ; O
                db      0x01        ; keyRight.mask
                db      0xDF        ; keyRight.port     ; P
                db      0x01        ; keyUp.mask
                db      0xFB        ; keyUp.port        ; Q
                db      0x01        ; keyDown.mask
                db      0xFD        ; keyDown.port      ; A
                db      0x04        ; keyFire.mask
                db      0x7F        ; keyFire.port      ; M
                db      0           ; spriteRef
                db      0           ; itemSpriteRef
                db      0           ; invincibility
                db      0           ; myCoin
                db      0           ; enemyCoin
                db      0           ; onGroundPrev

Player2:        db      0           ; phys.x
                db      0           ; phys.y
                db      0           ; phys.flags
                db      0           ; phys.speed
                db      0           ; phys.accel
                db      0           ; state
                db      0           ; cooldown
                db      0           ; gunCount
                db      0           ; itemSpriteID
                db      0           ; itemAttr
                db      0           ; gatesX
                db      0           ; gatesY
                db      0           ; originalX
                db      0           ; originalY
                db      0x04        ; keyLeft.mask
                db      0xBF        ; keyLeft.port      ; K
                db      0x02        ; keyRight.mask
                db      0xBF        ; keyRight.port     ; L
                db      0x02        ; keyUp.mask
                db      0xFB        ; keyUp.port        ; W
                db      0x02        ; keyDown.mask
                db      0xFD        ; keyDown.port      ; S
                db      0x01        ; keyFire.mask
                db      0x7F        ; keyFire.port      ; Space
                db      0           ; spriteRef
                db      0           ; itemSpriteRef
                db      0           ; invincibility
                db      0           ; myCoin
                db      0           ; enemyCoin
                db      0           ; onGroundPrev

onGround        db      0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

                section data_player_jumps_1

PlayerActions:  dw      DoPlayer@@idle
                dw      DoPlayer@@moving
                dw      DoPlayer@@jumping
                dw      DoPlayer@@deadFalling
                dw      DoPlayer@@dead
                dw      DoPlayer@@wakingUp
                dw      DoPlayer@@sitting
                dw      DoPlayer@@deadFallingRespawn
                dw      DoPlayer@@deadRespawn

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

                section data_player_jumps_2

PlayerDrawing:  dw      DoPlayer@@drawIdle
                dw      DoPlayer@@drawMoving
                dw      DoPlayer@@drawJumping
                dw      DoPlayer@@drawDeadFalling
                dw      DoPlayer@@drawDead
                dw      DoPlayer@@drawWakingUp
                dw      DoPlayer@@drawSitting
                dw      DoPlayer@@drawDeadFallingRespawn
                dw      DoPlayer@@drawDeadRespawn

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

                section data_player_tables

PlayerHands:    db      SPRITE_PlayerHandsLeft1
                db      SPRITE_PlayerHandsRight1
                db      SPRITE_PlayerHandsLeft2
                db      SPRITE_PlayerHandsRight2
                db      SPRITE_PlayerHandsLeft3
                db      SPRITE_PlayerHandsRight3
                db      SPRITE_PlayerHandsLeft4
                db      SPRITE_PlayerHandsRight4
                db      SPRITE_PlayerHandsLeft5
                db      SPRITE_PlayerHandsRight5

PlayerHandsJump:db      SPRITE_PlayerHandsLeftJump
                db      SPRITE_PlayerHandsRightJump

PlayerHandsDuck:db      SPRITE_PlayerHandsDuckLeft
                db      SPRITE_PlayerHandsDuckRight

PlayerGun:      db      SPRITE_PlayerGunLeft1
                db      SPRITE_PlayerGunRight1
                db      SPRITE_PlayerGunLeft2
                db      SPRITE_PlayerGunRight2
                db      SPRITE_PlayerGunLeft3
                db      SPRITE_PlayerGunRight3
                db      SPRITE_PlayerGunLeft4
                db      SPRITE_PlayerGunRight4
                db      SPRITE_PlayerGunLeft5
                db      SPRITE_PlayerGunRight5

PlayerGunJump:  db      SPRITE_PlayerGunLeftJump
                db      SPRITE_PlayerGunRightJump

PlayerGunDuck:  db      SPRITE_PlayerGunDuckLeft
                db      SPRITE_PlayerGunDuckRight

PlayerNormal:   db      SPRITE_PlayerLeft1
                db      SPRITE_PlayerRight1
                db      SPRITE_PlayerLeft2
                db      SPRITE_PlayerRight2
                db      SPRITE_PlayerLeft3
                db      SPRITE_PlayerRight3
                db      SPRITE_PlayerLeft4
                db      SPRITE_PlayerRight4
                db      SPRITE_PlayerLeft5
                db      SPRITE_PlayerRight5

PlayerJump:     db      SPRITE_PlayerLeftJump
                db      SPRITE_PlayerRightJump

PlayerDuck:     db      SPRITE_PlayerDuckLeft
                db      SPRITE_PlayerDuckRight

PlayerDead1:    db      SPRITE_PlayerDead1Left
                db      SPRITE_PlayerDead1Right

PlayerDead2:    db      SPRITE_PlayerDead2Left
                db      SPRITE_PlayerDead2Right

PlayerDead3:    db      SPRITE_PlayerDead3Left
                db      SPRITE_PlayerDead3Right

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

                section code_low

SkipDropSound   db      0

                ; Input:
                ;   B = port
                ;   A = mask
                ;   L = kempston bit
                ;   IX => player
                ; Output:
                ;   ZF=0 = Key Pressed
                ; Preserves:
                ;   IX

KeyPressed:     ld      c, 0xFE
                in      c, (c)
                and     c
                ret     z               ; ZF=0 = Key Pressed
                ld      a, (KempstonMode)
                sub     a, 1
                ret     c               ; ZF=1 = Not pressed
                ld      a, Player1 & 0xff
                jr      z, @@kempston
                ld      a, Player2 & 0xff
@@kempston:     cp      ixl
                ret     nz              ; ZF=1 = Not pressed
                in      a, (0x1f)
                cpl
                and     l
                ret
@@retFalse:     xor     a
                inc     a
                ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

                ; Input:
                ;   B = Y
                ;   C = X
                ;   IX => player
                ; Preserves:
                ;   DE

InitPlayer:     ld      (ix+Player_originalX), c
                ld      (ix+Player_originalY), b
                call    InitPhysObject
                call    AllocSprite
                ld      (ix+Player_spriteRef), a
                ld      (ix+Player_state), PLAYER_IDLE
                xor     a
                ld      (ix+Player_itemAttr), a
                ld      (ix+Player_itemSpriteID), a
                ld      (ix+Player_cooldown), a
                ld      (ix+Player_gunCount), a
                ld      (ix+Player_invincibility), a
                ld      (ix+Player_onGroundPrev), a
                dec     a
                ld      (ix+Player_itemSpriteRef), a    ; 0xff
                ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

                ; Input:
                ;   IX => player
                ;   C = offset
                ;   D = Item sprite ID if only grab specific item, 0 if any

TryGetItem:     ld      a, (ix+Player_state)
                cp      PLAYER_IDLE
                jr      z, @@stateGood
                cp      PLAYER_MOVING
                jr      z, @@stateGood
                cp      PLAYER_JUMPING
                ret     nz
@@stateGood:    ld      b, (ix+Player_phys_y)
                ld      a, (ix+Player_phys_x)
                add     a, c
                ld      c, a
                call    GateToggleSwtch
                ld      a, (ix+Player_itemAttr)
                or      a
                ld      d, 0
                jr      z, @@grab
                ld      d, SPRITE_Weapon1
@@grab:         call    TryGrabItem
                ld      a, e
                or      a
                ret     z
                push    af
                push    iy
                push    ix
                push    de
                call    _PlayPressSound
                pop     de
                pop     ix
                pop     iy
                pop     af
                ld      a, SPRITE_Weapon1
                cp      d
                jr      z, @@weapon
                ld      (ix+Player_itemAttr), e
                ld      (ix+Player_itemSpriteID), d
                call    AllocSprite
                ld      (ix+Player_itemSpriteRef), a
                ret
@@weapon:       inc     (ix+Player_gunCount)
                ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

                ; Input:
                ;   IX => Player
                ; Return:
                ;   CF=0: Moved; CF=1: Didn't Move

MoveLeftRight:  ld      b, (ix+Player_keyLeft_port)
                ld      a, (ix+Player_keyLeft_mask)
                ld      l, KEMPSTON_LEFT
                call    KeyPressed
                jr      nz, @@noLeft
                ld      a, (ix+Player_state)
                cp      PLAYER_SITTING
                jr      z, @@didLeft
                ld      a, (ix+Player_itemAttr)
                or      a
                jr      z, @@1
                call    CanGoLeftWithItem
                jr      @@2
@@1:            call    CanGoLeft
@@2:            jr      z, @@cantLeft
                ld      a, (ix+Player_itemAttr)
                or      a
                jr      z, @@leftOk
                ld      a, (Timer)
                and     1
                jr      nz, @@didLeft
@@leftOk:       dec     (ix+Player_phys_x)
                jr      @@didLeft
@@cantLeft:     ld      c, -8
                call    TryGetItem
@@didLeft:      ;ld      a, (ix+Player_phys_flags)
                ;and     ~PHYS_HORIZONTAL
                ;or      PHYS_LEFT
                ;ld      (ix+Player_phys_flags), a
                res     0, (ix+Player_phys_flags)   ; PHYS_LEFT
                ret     ; CF=0: return true
@@noLeft:       ld      b, (ix+Player_keyRight_port)
                ld      a, (ix+Player_keyRight_mask)
                ld      l, KEMPSTON_RIGHT
                call    KeyPressed
                jr      nz, @@noRight
                ld      a, (ix+Player_state)
                cp      PLAYER_SITTING
                jr      z, @@didRight
                ld      a, (ix+Player_itemAttr)
                or      a
                jr      z, @@3
                call    CanGoRightWithItem
                jr      @@4
@@3:            call    CanGoRight
@@4:            jr      z, @@cantRight
                ld      a, (ix+Player_itemAttr)
                or      a
                jr      z, @@rightOk
                ld      a, (Timer)
                and     1
                jr      nz, @@didRight
@@rightOk:      inc     (ix+Player_phys_x)
                jr      @@didRight
@@cantRight:    ld      c, 8
                call    TryGetItem
@@didRight:     ;ld      a, (ix+Player_phys_flags)
                ;and     ~PHYS_HORIZONTAL
                ;or      PHYS_RIGHT
                ;ld      (ix+Player_phys_flags), a
                set     0, (ix+Player_phys_flags)   ; PHYS_RIGHT
                ret     ; CF=0: return true
@@noRight:      scf
                ret     ; CF=1: return false

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

TryShoot:       ld      b, (ix+Player_keyFire_port)
                ld      a, (ix+Player_keyFire_mask)
                ld      l, KEMPSTON_FIRE
                call    KeyPressed
                ret     nz
                ld      a, (ix+Player_cooldown)
                or      a
                ret     nz
                ld      a, (ix+Player_itemAttr)
                or      a
                jr      z, @@weapon
                ld      l, 4 << 5
@@dropItem:     ld      c, (ix+Player_phys_x)
                ld      a, (ix+Player_state)
                cp      PLAYER_SITTING
                ld      a, -6
                jr      z, @@itemSitting
                ld      a, -8
@@itemSitting:  add     a, (ix+Player_phys_y)
                ld      b, a
                ld      e, (ix+Player_itemSpriteID)
                ld      d, (ix+Player_itemAttr)
                ld      h, (ix+Player_phys_flags)
                push    ix
                call    SpawnFlyingItem
                push    iy
                push    af
                ld      a, (SkipDropSound)
                or      a
                jr      nz, @@skipDropSound
                call    _PlayShootSound
@@skipDropSound:xor     a
                ld      (SkipDropSound), a
                pop     af
                pop     iy
                pop     ix
                ret     z
                ld      (ix+Player_cooldown), SHOOT_COOLDOWN
@@freeItemSprte:ld      a, (ix+Player_itemSpriteRef)
                cp      0xff
                jr      z, @@skipRelSprte
                call    ReleaseSprite
@@skipRelSprte: xor     a
                ld      (ix+Player_itemSpriteID), a
                ld      (ix+Player_itemAttr), a
                dec     a
                ld      (ix+Player_itemSpriteRef), a    ; 0xff
                ret     ; return ZF == 0
@@weapon:       ld      a, (ix+Player_gunCount)
                or      a
                ret     z
                ld      a, (ix+Player_state)
                cp      PLAYER_SITTING
                jr      nz, @@notSitting
                ld      a, 4
                jr      @@selected
@@notSitting:   cp      PLAYER_MOVING
                jr      nz, @@notMoving
                ld      a, (Timer)
                rrca
                rrca
                and     3
                cp      3
                jr      nz, @@notMoving
                ld      a, 3
                jr      @@selected
@@notMoving:    ld      a, 2
@@selected:     add     a, (ix+Player_phys_y)
                ld      d, a
                ld      a, (ix+Player_phys_x)
                inc     a
                ld      b, (ix+Player_phys_flags)   ; PHYS_HORIZONTAL
                bit     0, b
                jr      z, @@left                   ; PHYS_LEFT
                add     a, 6-1
@@left:         ld      e, a
                push    ix
                ld      ixl, b
                call    SpawnBullet
                push    iy
                call    _PlayShootSound
                pop     iy
                pop     ix
                ld      (ix+Player_cooldown), SHOOT_COOLDOWN
                ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

                ; Input:
                ;   IX => player

DoPlayer:       ld      a, (ix+Player_cooldown)
                or      a
                jr      z, @@1
                dec     (ix+Player_cooldown)
@@1:

                ld      a, (ix+Player_invincibility)
                or      a
                jr      z, @@2
                dec     (ix+Player_invincibility)
@@2:

                ld      a, 1
                ld      (onGround), a
                ld      a, (ix+Player_itemAttr)
                ld      d, 1
                or      a
                jr      z, @@3
                inc     d
@@3:            call    UpdatePhysObject
                jr      nz, @@4
                cp      WEAPON_ATTR
                jr      nz, @@5
                ld      a, (ix+Player_phys_y)
                and     ~7
                add     a, 8
                ld      b, a
                ld      a, (ix+Player_phys_x)
                and     ~7
                ld      c, a
                ld      d, SPRITE_Weapon1
                call    TryGetItem@@grab
                ld      a, (ix+Player_phys_y)
                and     ~7
                add     a, 8
                ld      b, a
                ld      a, (ix+Player_phys_x)
                ld      c, a
                and     7
                jr      z, @@5
                ld      a, c
                and     ~7
                add     a, 8
                ld      c, a
                ld      d, SPRITE_Weapon1
                call    TryGetItem@@grab
                jr      @@5
@@4:            xor     a
                ld      (onGround), a
@@5:

                ld      a, (ix+Player_state)
                ld      l, a
                ld      h, PlayerActions >> 8
                ld      a, (hl)
                inc     hl
                ld      h, (hl)
                ld      l, a
                jp      (hl)

@@idle:
@@moving:       ld      a, (ix+Player_onGroundPrev);(onGround)
                or      a
                ld      a, (onGround)
                ld      (ix+Player_onGroundPrev), a
                jr      z, @@noDuck
@@idleOnGround: ; check if we can jump
                ld      b, (ix+Player_keyUp_port)
                ld      a, (ix+Player_keyUp_mask)
                ld      l, KEMPSTON_UP
                call    KeyPressed
                jr      nz, @@noJump
                call    CanGoUp
                jr      z, @@noJump
                ld      (ix+Player_state), PLAYER_JUMPING
                ld      a, (ix+Player_itemAttr)
                or      a
                ld      c, 4 << 5
                jr      z, @@jumpNoItem
                ld      c, 7 | (3 << 5)
@@jumpNoItem:   ld      a, (ix+Player_phys_flags)
                call    JumpPhysObject
                push    ix
                push    iy
                call    _PlayAirlockSound
                pop     iy
                pop     ix
                jr      @@jumpingInAir
@@noJump:       ; check if we can duck
                ld      b, (ix+Player_keyDown_port)
                ld      a, (ix+Player_keyDown_mask)
                ld      l, KEMPSTON_DOWN
                call    KeyPressed
                jr      nz, @@noDuck
                ld      (ix+Player_state), PLAYER_SITTING
                jp      @@sitOnGround
@@noDuck:       ; check if we can move or shoot
                ld      (ix+Player_state), PLAYER_IDLE
                call    MoveLeftRight
                jr      c, @@noMove
                ld      (ix+Player_state), PLAYER_MOVING
@@noMove:       call    TryShoot
                jp      @@draw

@@jumping:      ld      a, (onGround)
                or      a
                jr      nz, @@idleOnGround
@@jumpingInAir: call    MoveLeftRight
                call    TryShoot
                jp      @@draw

@@deadFalling:  ld      a, (onGround)
                or      a
                jp      z, @@draw
                ld      (ix+Player_state), PLAYER_DEAD
                jr      @@draw

@@deadFallingRespawn:
                ld      a, (onGround)
                or      a
                jr      z, @@draw
                ld      (ix+Player_state), PLAYER_DEAD_RESPAWN
                jr      @@draw

@@dead:         ld      a, (onGround)
                or      a
                jr      nz, @@deadCooldown
                ld      (ix+Player_state), PLAYER_DEAD_FALLING
                jr      @@draw
@@deadCooldown: ld      a, (ix+Player_cooldown)
                or      a
                jr      nz, @@draw
@@wakeup:       ld      (ix+Player_cooldown), 10
                ld      (ix+Player_state), PLAYER_WAKING_UP
                jr      @@draw

@@deadRespawn:  ld      a, (onGround)
                or      a
                jr      nz, @@respawnCooldn
                ld      (ix+Player_state), PLAYER_DEAD_FALLING_RESPAWN
                jr      @@draw
@@respawnCooldn:ld      a, (ix+Player_cooldown)
                or      a
                jr      nz, @@draw
                ld      a, (ix+Player_originalX)
                ld      (ix+Player_phys_x), a
                ld      a, (ix+Player_originalY)
                ld      (ix+Player_phys_y), a
                jr      @@wakeup

@@wakingUp:     ld      a, (ix+Player_cooldown)
                or      a
                jr      nz, @@draw
                ld      (ix+Player_invincibility), AFTER_REVIVE_INVINC_TIME
                ld      (ix+Player_state), PLAYER_IDLE
                jr      @@draw

@@sitting:      ld      a, (onGround)
                or      a
                jr      nz, @@sitOnGround
                ld      (ix+Player_state), PLAYER_JUMPING
                jr      @@jumpingInAir
@@sitOnGround:  ld      b, (ix+Player_keyDown_port)
                ld      a, (ix+Player_keyDown_mask)
                ld      l, KEMPSTON_DOWN
                call    KeyPressed
                jr      z, @@continueSit
                ld      (ix+Player_state), PLAYER_IDLE
                jp      @@idleOnGround
@@continueSit:  call    MoveLeftRight
                call    TryShoot

@@draw:         ld      a, (ix+Player_state)
                ld      l, a
                ld      h, PlayerDrawing >> 8
                ld      a, (hl)
                inc     hl
                ld      h, (hl)
                ld      l, a
                jp      (hl)

@@drawIdle:     ld      a, (ix+Player_itemAttr)
                or      a
                jr      z, @@drawIdle1
                ld      hl, PlayerHands
                jp      @@setSprite
@@drawIdle1:    ld      a, (ix+Player_gunCount)
                or      a
                jr      z, @@drawIdle2
                ld      hl, PlayerGun
                jp      @@setSprite
@@drawIdle2:    ld      hl, PlayerNormal
                jp      @@setSprite

@@drawMoving:   ld      a, (Timer)
                rrca
                and     6
                add     a, 2
                ld      c, a
                ld      b, 0
                ld      a, (ix+Player_itemAttr)
                or      a
                jr      z, @@drawMoving1
                ld      hl, PlayerHands
                jr      @@drawMoving3
@@drawMoving1:  ld      a, (ix+Player_gunCount)
                or      a
                jr      z, @@drawMoving2
                ld      hl, PlayerGun
                jr      @@drawMoving3
@@drawMoving2:  ld      hl, PlayerNormal
@@drawMoving3:  add     hl, bc
                jr      @@setSprite

@@drawJumping:  ld      a, (ix+Player_itemAttr)
                or      a
                jr      z, @@drawJumping1
                ld      hl, PlayerHandsJump
                jr      @@setSprite
@@drawJumping1: ld      a, (ix+Player_gunCount)
                or      a
                jr      z, @@drawJumping2
                ld      hl, PlayerGunJump
                jr      @@setSprite
@@drawJumping2: ld      hl, PlayerJump
                jr      @@setSprite

@@drawDeadFalling:
@@drawDeadFallingRespawn:
                ld      hl, PlayerDead1
                jr      @@setSprite

@@drawDead:
@@drawDeadRespawn:
                ld      a, (ix+Player_cooldown)
                and     31
                cp      15
                ld      hl, PlayerDead2
                jr      nc, @@setSprite ; >= 15
                ld      hl, PlayerDead1
                jr      @@setSprite

@@drawWakingUp: ld      hl, PlayerDead3
                jr      @@setSprite

@@drawSitting:  ld      a, (ix+Player_itemAttr)
                or      a
                jr      z, @@drawSitting1
                ld      hl, PlayerHandsDuck
                jr      @@setSprite
@@drawSitting1: ld      a, (ix+Player_gunCount)
                or      a
                jr      z, @@drawSitting2
                ld      hl, PlayerGunDuck
                jr      @@setSprite
@@drawSitting2: ld      hl, PlayerDuck
                jr      @@setSprite

@@setSprite:    bit     0, (ix+Player_phys_flags)   ; PHYS_HORIZONTAL
                jr      z, @@6
                inc     hl
@@6:            ld      b, (hl)
                ld      d, (ix+Player_phys_y)
                ld      e, (ix+Player_phys_x)
                ld      a, (ix+Player_invincibility)
                and     15
                cp      7
                ld      a, (ix+Player_spriteRef)
                jr      c, @@doSetSprite
                ld      b, 0
@@doSetSprite:  call    SetSprite
                ld      a, (ix+Player_itemAttr)
                or      a
                jr      z, @@noItem
                ld      a, (ix+Player_state)
                cp      PLAYER_SITTING
                ld      d, 7
                jr      z, @@itemSitting
                ld      d, 9
@@itemSitting:  ld      a, (ix+Player_phys_y)
                sub     a, d
                ld      d, a
                ld      e, (ix+Player_phys_x)
                ld      a, (ix+Player_itemSpriteRef)
                ld      b, (ix+Player_itemSpriteID)
                call    SetSprite
@@noItem:       ld      a, (ix+Player_state)
                cp      PLAYER_DEAD
                ret     z
                cp      PLAYER_DEAD_FALLING
                ret     z
                cp      PLAYER_DEAD_FALLING_RESPAWN
                ret     z
                cp      PLAYER_DEAD_RESPAWN
                ret     z
                ld      a, (ix+Player_phys_x)
                add     a, -6+8
                cp      (ix+Player_gatesX)
                ret     c
                ld      a, (ix+Player_gatesX)
                add     a, 3*8 - 6
                cp      (ix+Player_phys_x)
                ret     c
                ld      a, (ix+Player_phys_y)
                add     a, 8
                cp      (ix+Player_gatesY)
                ret     c
                add     a, -8-8-1
                cp      (ix+Player_gatesY)
                ret     nc

                ld      a, (ix+Player_itemAttr)
                cp      (ix+Player_myCoin)
                jr      nz, @@notMyCoin

                ld      a, (ix+Player_gatesX)
                add     a, 8
                ld      c, a
                ld      b, (ix+Player_gatesY)
                ld      e, (ix+Player_itemSpriteID)
                ld      d, (ix+Player_itemAttr)
                call    PlaceItem
                call    TryShoot@@freeItemSprte

@@notMyCoin:    ld      b, (ix+Player_gatesY)
                ld      c, (ix+Player_gatesX)
                ld      a, 8
                call    @@itemAtGates
                ld      (@@itemAtGates1+1), a
                ld      a, 16
                call    @@itemAtGates
                ld      (@@itemAtGates2+1), a
                xor     a
                call    @@itemAtGates
                ld      b, a

                ld      a, (ix+Player_enemyCoin)
                ld      c, (ix+Player_itemAttr)
                cp      c
                jr      z, @@haveEnemyCoin
                cp      b
                jr      z, @@haveEnemyCoin
@@itemAtGates1: cp      0
                jr      z, @@haveEnemyCoin
@@itemAtGates2: cp      0
                ret     nz
@@haveEnemyCoin:ld      a, (SinglePlayer)
                or      a
                jr      nz, @@haveOurCoin
                ld      a, (ix+Player_myCoin)
                cp      c
                jr      z, @@haveOurCoin
                cp      b
                jr      z, @@haveOurCoin
                ld      hl, @@itemAtGates1+1
                cp      (hl)
                jr      z, @@haveOurCoin
                ld      hl, @@itemAtGates2+1
                cp      (hl)
                ret     nz
@@haveOurCoin:  ld      (GameLevelDone), a
                ret

@@itemAtGates:  push    bc
                add     a, c
                ld      c, a
                call    ItemAt
                pop     bc
                ld      a, h
                or      a
                jr      z, @@none
                inc     hl
                inc     hl
                inc     hl
                ld      a, (hl)
                ret
@@none:         ld      a, 0xff
                ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

                section code_high

                ; Input:
                ;   IX => player
                ;   B = reason
                ; Output:
                ;   ZF=0: player killed, ZF=1: not killed

KillPlayer:     ld      a, (ix+Player_state)
                cp      PLAYER_DEAD
                ret     z
                cp      PLAYER_DEAD_FALLING
                ret     z
                cp      PLAYER_DEAD_RESPAWN
                ret     z
                cp      PLAYER_DEAD_FALLING_RESPAWN
                ret     z
                ld      a, (ix+Player_invincibility)
                or      a
                jr      z, @@notInvincible
                xor     a   ; ZF=1
                ret
@@notInvincible:push    ix
                push    bc
                push    iy
                call    _PlayPlayerHitSound
                pop     iy
                pop     bc
                pop     ix
                ld      a, (ix+Player_itemAttr)
                or      a
                jr      z, @@noItem
                push    bc
                call    @@dropItem
                pop     bc
@@noItem:       ld      a, (ix+Player_gunCount)
                or      a
                jr      z, @@noGun
                push    bc
                ld      b, a
                ld      (ix+Player_gunCount), 0
                ld      l, 3 | (1 << 5)
@@dropGunLoop:  ld      (ix+Player_itemSpriteID), SPRITE_Weapon1
                ld      (ix+Player_itemAttr), WEAPON_ATTR
                ld      (ix+Player_itemSpriteRef), 0xff
                ld      a, (ix+Player_phys_flags)
                xor     1
                ld      (ix+Player_phys_flags), a
                push    bc
                push    hl
                call    @@dropItem1
                pop     hl
                pop     bc
                ld      a, 4
                add     a, l
                ld      l, a
                dec     b
                jr      nz, @@dropGunLoop
                pop     bc
@@noGun:        ld      a, b
                cp      REASON_ENEMY
                jr      z, @@enemy
                cp      REASON_ITEM
                jr      z, @@item

@@bullet:       ld      a, (SinglePlayer)
                or      a
                jr      nz, @@respawn
                ld      (ix+Player_state), PLAYER_DEAD_FALLING
                jr      @@shootCooldown

@@item:         ld      (ix+Player_state), PLAYER_DEAD_FALLING
                ld      (ix+Player_cooldown), DEATH_STONE_COOLDOWN
                xor     a
                inc     a   ; ZF=0
                ret

@@enemy:        ld      a, (SinglePlayer)
                or      a
                jr      z, @@item
@@respawn:      ld      (ix+Player_state), PLAYER_DEAD_FALLING_RESPAWN
@@shootCooldown:ld      (ix+Player_cooldown), DEATH_SHOOT_COOLDOWN
                xor     a
                inc     a   ; ZF=0
                ret

@@dropItem:     ld      l, 3 | (1 << 5)
@@dropItem1:    call    TryShoot@@dropItem
                ld      a, 1
                ld      (SkipDropSound), a
                ret     nz
                ld      b, (ix+Player_phys_y)
                ld      c, (ix+Player_phys_x)
                ld      e, (ix+Player_itemSpriteID)
                ld      d, (ix+Player_itemAttr)
                call    PlaceItem
                jp      TryShoot@@freeItemSprte
