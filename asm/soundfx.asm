
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

                section     code_high

PlaySoundThunk: pop         hl
                ld          a, (hl)
                ld          iyl, a
                inc         hl
                ld          a, (hl)
                ld          iyh, a
                jp          PlaySound@@1

_PlayCollectSound:
                call        PlaySoundThunk
                dw          CollectSound

_PlayPlayerHitSound:
                call        PlaySoundThunk
                dw          HitSound

_PlayShootSound:
                call        PlaySoundThunk
                dw          ShootSound

_PlayPressSound:
                call        PlaySoundThunk
                dw          PressSound

_PlayFlyingSound:
                call        PlaySoundThunk
                dw          FlyingSound

_PlaySpiderAppearingSound:
                call        PlaySoundThunk
                dw          SpiderAppearingSound

_PlayElevatorSound:
                call        PlaySoundThunk
                dw          ElevatorSound

_PlayAirlockSound:
                call        PlaySoundThunk
                dw          AirlockSound

_PlayAirlockSmokeSound:
                call        PlaySoundThunk
                dw          AirlockSmokeSound

_PlayShieldDestroySound1:
                call        PlaySoundThunk
                dw          ShieldDestroySound1

_PlayShieldDestroySound2:
                call        PlaySoundThunk
                dw          ShieldDestroySound2

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

                section     code_high

                ; Input:
                ;   Stack[top  ] => note table
                ;   Stack[top-1] => return address
                ; Output:
                ;   None
                ; Trashes:
                ;   A, BC, DE, HL, BC', DE', HL', IX, IY

PlaySound:      pop         iy
@@1:            ld          a, (iy+0)
                or          a, a
                ret         z
                ld          l, (iy+1)
                ld          h, (iy+2)
                ld          de, 3
                add         iy, de
                ld          e, a
                call        MakeBeep
                jr          @@1

;PlayMenuSound:
                call        PlaySound
_MenuSound:
                db          0x05                        ; PlayNote(NOTE_A / 3, 0.035);
                dw          0x0b96
                db          0x1d                        ; PlayNote(NOTE_G * 3, 0.025);
                dw          0x0156
                db          0x05                        ; PlayNote(NOTE_A / 3, 0.035);
                dw          0x0b96
                db          0

CollectSound:
                db          0x11                        ; PlayNote(NOTE_F * 2, 0.025);
                dw          0x0254
                db          0x13                        ; PlayNote(NOTE_G * 2, 0.025);
                dw          0x0210
                db          0x16                        ; PlayNote(NOTE_A * 2, 0.025);
                dw          0x1d3
                db          0

HitSound:       db          0x06                        ; PlayNote(NOTE_A / 4, 0.06);
                dw          0x0f6b
                db          0

PlayMenuSound:
;_PlaySaveGameSound:
                call        PlaySound
ShootSound:
                db          0x05                        ; PlayNote(NOTE_A / 3, 0.035);
                dw          0x0b96
                db          0

PressSound:
                db          0x04                        ; PlayNote(NOTE_A / 3, 0.035);
                dw          0x0796
                db          0

EnemyDeadSound:
                db          0x02                        ; PlayNote(NOTE_C / 3, 0.03);
                dw          0x1386
                db          0x04                        ; PlayNote(NOTE_B / 3, 0.03);
                dw          0x0a4d
                db          0x03                        ; PlayNote(NOTE_F / 3, 0.03);
                dw          0x0e9d
                db          0

RocketShootSound:
                ;db          0x03
                ;dw          0x1386
                db          0x05
                dw          0x0a4d
                ;db          0x04
                ;dw          0x0e9d
                db          0

FlyingSound:
                db          0x02                        ; PlayNote(NOTE_B * 6, 0.001);
                dw          0x0075
                db          0

SpiderAppearingSound:
                db          0x02                        ; PlayNote(NOTE_B * 6, 0.001);
                dw          0x0045
                db          0

ElevatorSound:
                db          0x02
                dw          0x0025
                db          0

_PlayDialogSound:
                call        PlaySound
AirlockSound:
                db          0x02
                dw          0x0175
                db          0

AirlockSmokeSound:
                db          0x01
                dw          0x0075
                db          0

ShieldDestroySound1:
                db          0x05
                dw          0x0a4d
                db          0x04
                dw          0x0e9d
                db          0

ShieldDestroySound2:
                db          0x11
                dw          0x04c0
                db          0x11
                dw          0x0510
                db          0
