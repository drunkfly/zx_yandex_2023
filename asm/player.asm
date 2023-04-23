
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
Player_visualCooldown   = 7
Player_itemSprite       = 8
Player_itemAttr         = 9
Player_gatesX           = 10
Player_gatesY           = 11
Player_originalX        = 12
Player_originalY        = 13
Player_keyLeft_port     = 14
Player_keyLeft_mask     = 15
Player_keyRight_port    = 16
Player_keyRight_mask    = 17
Player_keyUp_port       = 18
Player_keyUp_mask       = 19
Player_keyDown_port     = 20
Player_keyDown_mask     = 21
Player_keyFire_port     = 22
Player_keyFire_mask     = 23
Player_sprite           = 24

Player1:        db      0           ; phys.x
                db      0           ; phys.y
                db      0           ; phys.flags
                db      0           ; phys.speed
                db      0           ; phys.accel
                db      0           ; state
                db      0           ; cooldown
                db      0           ; visualCooldown
                db      0           ; itemSprite
                db      0           ; itemAttr
                db      0           ; gatesX
                db      0           ; gatesY
                db      0           ; originalX
                db      0           ; originalY
                db      0xDF        ; keyLeft.port      ; O
                db      0x02        ; keyLeft.mask
                db      0xDF        ; keyRight.port     ; P
                db      0x01        ; keyRight.mask
                db      0xFB        ; keyUp.port        ; Q
                db      0x01        ; keyUp.mask
                db      0xFD        ; keyDown.port      ; A
                db      0x01        ; keyDown.mask
                db      0x7F        ; keyFire.port      ; M
                db      0x04        ; keyFire.mask
                db      0           ; sprite

Player2:        db      0           ; phys.x
                db      0           ; phys.y
                db      0           ; phys.flags
                db      0           ; phys.speed
                db      0           ; phys.accel
                db      0           ; state
                db      0           ; cooldown
                db      0           ; visualCooldown
                db      0           ; itemSprite
                db      0           ; itemAttr
                db      0           ; gatesX
                db      0           ; gatesY
                db      0           ; originalX
                db      0           ; originalY
                db      0xBF        ; keyLeft.port      ; K
                db      0x04        ; keyLeft.mask
                db      0xBF        ; keyRight.port     ; L
                db      0x02        ; keyRight.mask
                db      0xFB        ; keyUp.port        ; W
                db      0x02        ; keyUp.mask
                db      0xFD        ; keyDown.port      ; S
                db      0x02        ; keyDown.mask
                db      0x7F        ; keyFire.port      ; Space
                db      0x01        ; keyFire.mask
                db      0           ; sprite

onGround        db      0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

                section player_jumps_1

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

                section player_jumps_2

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

                section player_tables

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

                section main

                ; Input:
                ;   B = port
                ;   A = mask
                ; Output:
                ;   ZF=0 = Key Pressed

KeyPressed:     ld      c, 0xFE
                in      c, (c)
                and     c
                ret     z               ; ZF=0 = Key Pressed
                ; FIXME: kempston
                ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

                ; Input
                ;   B = Y
                ;   C = X
                ;   IX => player

InitPlayer:     ld      (ix+Player_originalX), c
                ld      (ix+Player_originalY), b
ld (ix+Player_phys_x), c
ld (ix+Player_phys_y), b
                ;InitPhysObject(&player1.phys, player1.originalX, player1.originalY);
                call    AllocSprite
                ld      (ix+Player_sprite), a
                ld      (ix+Player_state), PLAYER_IDLE
                xor     a
                ld      (ix+Player_itemAttr), a
                ld      (ix+Player_itemSprite), a
                ld      (ix+Player_cooldown), a
                ld      (ix+Player_visualCooldown), a
                ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

                ; Input:
                ;   IX => Player
                ; Return:
                ;   CF=0: Moved; CF=1: Didn't Move

MoveLeftRight:  ld      b, (ix+Player_keyLeft_port)
                ld      a, (ix+Player_keyLeft_mask)
                call    KeyPressed
                jr      nz, @@noLeft
                ;if (CanGoLeft(&player->phys)) {
                ld      a, (ix+Player_itemAttr)
                or      a
                jr      z, @@leftOk
                ld      a, (Timer)
                and     1
                jr      nz, @@skipLeft
@@leftOk:       dec     (ix+Player_phys_x)
@@skipLeft:     jr      @@didLeft
                ;} else
                ;TryGetItem(player, -8, oldX, oldY, oldState);
@@didLeft:      ld      a, (ix+Player_phys_flags)
                and     ~PHYS_HORIZONTAL
                ;or      PHYS_LEFT
                ret     ; CF=0: return true
@@noLeft:       ld      b, (ix+Player_keyRight_port)
                ld      a, (ix+Player_keyRight_mask)
                call    KeyPressed
                jr      nz, @@noRight
                ;if (CanGoRight(&player->phys)) {
                ld      a, (ix+Player_itemAttr)
                or      a
                jr      z, @@rightOk
                ld      a, (Timer)
                and     1
                jr      nz, @@skipRight
@@rightOk:      inc     (ix+Player_phys_x)
@@skipRight:    jr      @@didRight
                ;} else
                ;TryGetItem(player, 8, oldX, oldY, oldState);
@@didRight:     ld      a, (ix+Player_phys_flags)
                and     ~PHYS_HORIZONTAL
                or      PHYS_RIGHT
                ret     ; CF=0: return true
@@noRight:      scf
                ret     ; CF=1: return false

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

TryShoot:
                ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

                ; Input:
                ;   IX => player

DoPlayer:       ld      a, (ix+Player_cooldown)
                or      a
                jr      z, @@1
                dec     (ix+Player_cooldown)
@@1:

                ld      a, (ix+Player_visualCooldown)
                or      a
                jr      z, @@2
                dec     (ix+Player_visualCooldown)
@@2:

                ld      a, 1
                ld      (onGround), a
                ;byte upAdj = (player->itemAttr ? 2 : 1);
                ;if (UpdatePhysObject(&player->phys, upAdj))
                ;   onGround = false;

                ld      a, (ix+Player_state)
                ld      l, a
                ld      h, PlayerActions >> 8
                ld      a, (hl)
                inc     hl
                ld      h, (hl)
                ld      l, a
                jp      (hl)

@@idle:
@@moving:       ld      a, (onGround)
                or      a
                jr      z, @@noDuck
@@idleOnGround: ; check if we can jump
                ld      b, (ix+Player_keyUp_port)
                ld      a, (ix+Player_keyUp_mask)
                call    KeyPressed
                jr      nz, @@noJump
                ; FIXME: CanGoUp
                jr      nz, @@noJump
                ld      (ix+Player_state), PLAYER_JUMPING
                ; JumpPhysObject(&player->phys, player->phys.flags, 4 << 5);
                jr      @@jumping
@@noJump:       ; check if we can duck
                ld      b, (ix+Player_keyDown_port)
                ld      a, (ix+Player_keyDown_mask)
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
                jr      z, @@draw
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
                ld      (ix+Player_state), PLAYER_IDLE
                jr      @@draw

@@sitting:      ld      a, (onGround)
                or      a
                jr      nz, @@sitOnGround
                ld      (ix+Player_state), PLAYER_JUMPING
                jr      @@jumpingInAir
@@sitOnGround:  ld      b, (ix+Player_keyDown_port)
                ld      a, (ix+Player_keyDown_mask)
                call    KeyPressed
                jr      z, @@continueSit
                ld      (ix+Player_state), PLAYER_IDLE
                jp      @@idleOnGround
@@continueSit:  call    TryShoot

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
                jr      @@setSpriteResetCooldown
@@drawIdle1:    ld      a, (ix+Player_visualCooldown)
                or      a
                jr      z, @@drawIdle2
                ld      hl, PlayerGun
                jp      @@setSprite
@@drawIdle2:    ld      hl, PlayerNormal
                jp      @@setSprite

@@drawMoving:   ld      a, (Timer)
                rrca
                rrca
                and     3
                inc     a
                ld      c, a
                ld      b, 0
                ld      a, (ix+Player_itemAttr)
                or      a
                jr      z, @@drawMoving1
                ld      (ix+Player_visualCooldown), 0
                ld      hl, PlayerHands
                jr      @@drawMoving3
@@drawMoving1:  ld      a, (ix+Player_visualCooldown)
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
                jr      @@setSpriteResetCooldown
@@drawJumping1: ld      a, (ix+Player_visualCooldown)
                or      a
                jr      z, @@drawJumping2
                ld      hl, PlayerGunJump
                jr      @@setSprite
@@drawJumping2: ld      hl, PlayerJump
                jr      @@setSprite

@@drawDeadFalling:
@@drawDeadFallingRespawn:
                ld      hl, PlayerDead1
                jr      @@setSpriteResetCooldown

@@drawDead:
@@drawDeadRespawn:
                ld      a, (ix+Player_cooldown)
                and     31
                cp      15
                ld      hl, PlayerDead2
                jr      nc, @@setSpriteResetCooldown ; >= 15
                ld      hl, PlayerDead1
                jr      @@setSpriteResetCooldown

@@drawWakingUp: ld      hl, PlayerDead3
                jr      @@setSpriteResetCooldown

@@drawSitting:  ld      a, (ix+Player_itemAttr)
                or      a
                jr      z, @@drawSitting1
                ld      hl, PlayerHandsDuck
@@setSpriteResetCooldown:
                ld      (ix+Player_visualCooldown), 0
                jr      @@setSprite
@@drawSitting1: ld      a, (ix+Player_visualCooldown)
                or      a
                jr      z, @@drawSitting2
                ld      hl, PlayerGunDuck
                jr      @@setSprite
@@drawSitting2: ld      hl, PlayerDuck
                jr      @@setSprite

@@setSprite:    bit     1, (ix+Player_phys_flags)   ; PHYS_HORIZONTAL
                jr      z, @@3
                inc     hl
@@3:            ld      b, (hl)
                ld      d, (ix+Player_phys_y)
                ld      e, (ix+Player_phys_x)
                ld      a, (ix+Player_sprite)
                call    SetSprite

/*
@@4:
    XorSprite(player->phys.x, player->phys.y, newSprite);
    if (player->itemAttr)
        XorSprite(player->phys.x, player->phys.y - (player->state == SITTING ? 7 : 9), player->itemSprite);
    player->oldSprite = newSprite;

    if ((player->state != DEAD && player->state != DEAD_FALLING && player->state != DEAD_FALLING_RESPAWN && player->state != DEAD_RESPAWN)
            && player->phys.x + 8 >= player->gatesX + 6 && player->phys.x <= player->gatesX + 3 * 8 - 6
            && player->phys.y + 8 >= player->gatesY && player->phys.y <= player->gatesY + 8) {
        byte myApple = (player == &player1 ? APPLE1_ATTR : APPLE2_ATTR);
        byte enemyApple = (player == &player1 ? APPLE2_ATTR : APPLE1_ATTR);

        if (player->itemAttr == myApple) {
            XorSprite(player->phys.x, player->phys.y - (player->state == SITTING ? 7 : 9), player->itemSprite);
            PlaceItem(player->gatesX + 8, player->gatesY, player->itemSprite, player->itemAttr);
            player->itemSprite = NULL;
            player->itemAttr = 0;
        }

        const Item* itemAtOurGates1 = ItemAt(player->gatesX + 8, player->gatesY);
        const Item* itemAtOurGates2 = ItemAt(player->gatesX, player->gatesY);
        const Item* itemAtOurGates3 = ItemAt(player->gatesX + 16, player->gatesY);

        bool haveEnemyCoin = (player->itemAttr == enemyApple ||
            (itemAtOurGates1 != NULL && itemAtOurGates1->attr == enemyApple) ||
            (itemAtOurGates2 != NULL && itemAtOurGates2->attr == enemyApple) ||
            (itemAtOurGates3 != NULL && itemAtOurGates3->attr == enemyApple));

        bool haveOurCoin = (player->itemAttr == myApple ||
            (itemAtOurGates1 != NULL && itemAtOurGates1->attr == myApple) ||
            (itemAtOurGates2 != NULL && itemAtOurGates2->attr == myApple) ||
            (itemAtOurGates3 != NULL && itemAtOurGates3->attr == myApple));

        if (haveOurCoin && haveEnemyCoin)
            return false;
    }

    return true;
}
*/

                ret
