
                section     music

                ; Input:
                ;   HL => compressed music

PlayMusic:      xor         a
                ld          (MusicEnabled), a
                ld          de, MusicBuffer
                call        Unzx7
                ld          a, 1
                ld          (MusicEnabled), a
                ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

                ; Vortex Tracker II v1.0 PT3 player for ZX Spectrum
                ; (c)2004,2007 S.V.Bulba <vorobey@mail.khstu.ru>
                ; http://bulba.untergrund.net (http://bulba.at.kz)
                ;
                ; Features
                ; --------
                ; * Can be compiled at any address (i.e. no need rounding ORG address).
                ; * Variables (VARS) can be located at any address (not only after code block).
                ; * INIT subroutine detects module version and rightly generates both note and
                ;   volume tables outside of code block (in VARS).
                ; * Two portamento (spc. command 3xxx) algorithms (depending of module version).
                ; * New 1.XX and 2.XX special command behaviour (only for PT v3.7 and higher).
                ; * Any Tempo value are accepted (including Tempo=1 and Tempo=2).
                ; * Fully compatible with Ay_Emul PT3 player codes.
                ;
                ; Limitations
                ; -----------
                ; * Can run in RAM only (self-modified code is used).
                ;
                ;;Warning!!! PLAY subroutine can crash if no module are loaded into RAM or INIT
                ; subroutine was not called before.
                ;
                ; Call MUTE or INIT one more time to mute sound after stopping playing.
                ;
                ; Notes
                ; -----
                ;
                ; Tests in IMMATION TESTER V1.0 by Andy Man/POS (thanks to Himik's ZxZ for help):
                ; Module/author     Min tacts   Max tacts   Average
                ; Spleen/Nik-O      1720        9256        5500
                ; Chuta/Miguel      1720        9496        5500
                ; Zhara/Macros      4536        8744        5500
                ;
                ; Pro Tracker 3.4r can not be detected by header, so PT3.4r tone tables really
                ; used only for modules of 3.3 and older versions.

MusicPlayer:

@@CurESld = @@CurESld_ + 1
@@Ns_Base_AddToNs = @@Ns_Base_AddToNS_ + 1
@@Ns_Base = @@Ns_Base_AddToNs
@@AddToNs = @@Ns_Base_AddToNs + 1

                @@TonA      = 0
                @@TonB      = 2
                @@TonC      = 4
                @@Noise     = 6
                @@Mixer     = 7
                @@AmplA     = 8
                @@AmplB     = 9
                @@AmplC     = 10
                @@Env       = 11
                @@EnvTp     = 13

;@@flags:        db          0       ; set bit0 to 1, if you want to play without looping
                                    ; bit7 is set each time, when loop point is passed
;@@currentPos:   dw          0
@@currentPos = @@currentPos_ + 1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;@@checkLoop:    ld          hl, @@flags
                ;set         7, (hl)
                ;bit         0, (hl)
                ;ret         z
                ;pop         hl
                ;ld          hl, @@DelyCnt
                ;inc         (hl)
                ;ld          hl, @@ChanA + @@CHP_NtSkCn
                ;inc         (hl)
@@mute:         xor         a
                ld          h, a
                ld          l, a
                ld          (@@AYREGS + @@AmplA), a
                ld          (@@AYREGS + @@AmplB), hl
                jp          @@ROUT_A0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

                ; HL - AddressOfModule
@@init:         ld          hl, MusicBuffer - 100
                ld          (@@MODADDR + 1), hl
                ld          (@@MDADDR2 + 1), hl
                push        hl
                ld          de, 100
                add         hl, de
                ld          a, (hl)
                ld          (@@delay + 1), a
                push        hl
                pop         ix
                add         hl, de
                ld          (@@currentPos), hl
                ld          e, (ix+102-100)
                add         hl, de
                inc         hl
                ld          (@@LPosPtr + 1), hl
                pop         de
                ld          l, (ix+103-100)
                ld          h, (ix+104-100)
                add         hl, de
                ld          (@@PatsPtr + 1), hl
                ld          hl, 169
                add         hl, de
                ld          (@@OrnPtrs + 1), hl
                ld          hl, 105
                add         hl, de
                ld          (@@SamPtrs + 1), hl
                ;ld          hl, @@flags
                ;res         7, (hl)
                ;note table data depacker
;                ld          de, @@packedNoteTable
;                ld          bc, @@T1_ + (2 * 49) - 1
;@@TP_0:         ld          a, (de)
;                inc         de
;                cp          15*2
;                jr          nc, @@TP_1
;                ld          h, a
;                ld          a, (de)
;                ld          l, a
;                inc         de
;                jr          @@TP_2
;@@TP_1:         push        de
;                ld          d, 0
;                ld          e, a
;                add         hl, de
;                add         hl, de
;                pop         de
;@@TP_2:         ld          a, h
;                ld          (bc), a
;                dec         bc
;                ld          a, l
;                ld          (bc), a
;                dec         bc
;                sub         0xff & (0xf8 * 2)
;                jr          nz, @@TP_0
              xor a
                ;
                ld          hl, @@VARS
                ld          (hl), a
                ld          de, @@VARS + 1
                ld          bc, @@VAR0END - @@VARS - 1
                ldir
                inc         a
                ld          (@@DelyCnt), a
                ld          hl, 0xf001                      ; H - CHP.Volume, L - CHP.NtSkCn
                ld          (@@ChanA + @@CHP_NtSkCn), hl
                ld          (@@ChanB + @@CHP_NtSkCn), hl
                ld          (@@ChanC + @@CHP_NtSkCn), hl
                ;
                ld          hl, @@EMPTYSAMORN
                ld          (@@AdInPtA + 1), hl             ; ptr to zero
                ld          (@@ChanA + @@CHP_OrnPtr), hl    ; ornament 0 is "0,1,0"
                ld          (@@ChanB + @@CHP_OrnPtr), hl    ; in all versions from
                ld          (@@ChanC + @@CHP_OrnPtr), hl    ; 3.xx to 3.6x and VTII
                ;
                ld          (@@ChanA + @@CHP_SamPtr), hl    ; S1 There is no default
                ld          (@@ChanB + @@CHP_SamPtr), hl    ; S2 sample in PT3, so, you
                ld          (@@ChanC + @@CHP_SamPtr), hl    ; S3 can comment S1,2,3; see
                                                            ; also EMPTYSAMORN comment
                ;ld          a, (ix + 13 - 100)              ; EXTRACT VERSION NUMBER
                ;sub         0x30
                ;jr          c, @@L20
                ;cp          10
                ;jr          c, @@L21
;@@L20:          ld          a, 6
;@@L21:          ld          (@@Version + 1), a
                ;push        af
                ;cp          4
                ;ld          a, (ix + 99 - 100)              ; TONE TABLE NUMBER
                ;rla
                ;and         7
                ; NoteTableCreator (c) Ivan Roshin
                ; A - NoteTableNumber * 2 + VersionForNoteTable
                ; (xx1b - 3.xx..3.4r, xx0b - 3.4x..3.6x..VTII1.0)
                ;ld          hl, @@NT_DATA
                ;push        de
                ;ld          d, b
                ;add         a, a
                ;ld          e, a
                ;add         hl, de
                ;ld          e, (hl)
                ;inc         hl
                ;srl         e
                ;sbc         a, a
                ;and         0xa7                            ; #00 (NOP) or #A7 (AND A)
                ;ld          (@@L3), a
                ;ex          de, hl
                ;pop         bc                              ; BC=T1_
                ;add         hl, bc
                ;
                ;ld          a, (de)
                ;add         a, @@T_ & 0xff
                ;ld          c, a
                ;adc         a, @@T_ / 256
                ;sub         c
                ;ld          b, a
;                push        bc
;                ld          de, @@NT_
;                push        de
;                ;
;                ld          b, 12
;@@L1:           push        bc
;                ld          c, (hl)
;                inc         hl
;                push        hl
;                ld          b, (hl)
;                ;
;                push        de
;                ex          de, hl
;                ld          de, 23
;                ld          ixh, 8
;                ;
;@@L2:           srl         b
;                rr          c
;;@@L3:           db          0x19                            ; AND A or NOP
;                ld          a, c
;                adc         a, d                            ; = ADC 0
;                ld          (hl), a
;                inc         hl
;                ld          a, b
;                adc         a, d
;                ld          (hl), a
;                add         hl, de
;                dec         ixh
;                jr          nz, @@L2
;                ;
;                pop         de
;                inc         de
;                inc         de
;                pop         hl
;                inc         hl
;                pop         bc
;                djnz        @@L1
;                ;
;                pop         hl
;                pop         de
;                ;
                ;ld          a, e
                ;cp          @@TCOLD_1 & 0xff
                ;jr          nz, @@CORR_1
                ;ld          a, 0xfd
                ;ld          (@@NT_ + 0x2e), a
                ;
;@@CORR_1:       ld          a, (de)
;                and         a
;                jr          z, @@TC_EXIT
;                rra
;                push        af
;                add         a, a
;                ld          c, a
;                add         hl, bc
;                pop         af
;                jr          nc, @@CORR_2
;                dec         (hl)
;                dec         (hl)
;@@CORR_2:       inc         (hl)
;                and         a
;                sbc         hl, bc
;                inc         de
;                jr          @@CORR_1
;@@TC_EXIT:      ;pop         af                              ; pop version number
                ; VolTableCreator (c) Ivan Roshin
                ; A - VersionForVolumeTable (0..4 - 3.xx..3.4x;
                ; 5.. - 3.5x..3.6x..VTII1.0)
;                ;cp          5
;                ld          hl, 0x11
;                ld          d, h
;                ld          e, h
;                ;ld          a, 0x17
;                ;jr          nc, @@M1
;                ;dec         l
;                ;ld          e, l
;                ;xor         a
;;@@M1:           ld          (@@M2), a
;                ;
;                ld          ix, @@VT_ + 16
;                ld          c, 0x10
;                ;
;@@INITV2:       push        hl
;                ;
;                add         hl, de
;                ex          de, hl
;                sbc         hl, hl
;                ;
;@@INITV1:       ld          a, l
;@@M2:           db          0x17 ;0x7d
;                ld          a, h
;                adc         a, 0
;                ld          (ix), a
;                inc         ix
;                add         hl, de
;                inc         c
;                ld          a, c
;                and         15
;                jr          nz, @@INITV1
;                ;
;                pop         hl
;                ld          a, e
;                cp          0x77
;                jr          nz, @@M3
;                inc         e
;@@M3:           ld          a, c
;                and         a
;                jr          nz, @@INITV2
                jp          @@ROUT_A0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

                ; pattern decoder

@@PD_OrSm:      ld          (ix + @@CHP_Env_En - 12), 0
                call        @@SETORN
                ld          a, (bc)
                inc         bc
                rrca
                ;
@@PD_SAM:       add         a, a
@@PD_SAM_:      ld          e, a
                ld          d, 0
@@SamPtrs:      ld          hl, 0x2121
                add         hl, de
                ld          e, (hl)
                inc         hl
                ld          d, (hl)
@@MODADDR:      ld          hl, 0x2121
                add         hl, de
                ld          (ix + @@CHP_SamPtr - 12), l
                ld          (ix + @@CHP_SamPtr + 1 - 12), h
                jr          @@PD_LOOP
                ;
@@PD_VOL:       rlca
                rlca
                rlca
                rlca
                ld          (ix + @@CHP_Volume - 12), a
                jr          @@PD_LP2
                ;
@@PD_EOff:      ld          (ix + @@CHP_Env_En - 12), a
                ld          (ix + @@CHP_PsInOr - 12), a
                jr          @@PD_LP2
                ;
@@PD_SorE:      dec         a
                jr          nz, @@PD_ENV
                ld          a, (bc)
                inc         bc
                ld          (ix + @@CHP_NNtSkp - 12), a
                jr          @@PD_LP2
                ;
@@PD_ENV:       call        @@SETENV
                jr          @@PD_LP2
                ;
@@PD_ORN:       call        @@SETORN
                jr          @@PD_LOOP
                ;
@@PD_ESAM:      ld          (ix + @@CHP_Env_En - 12), a
                ld          (ix + @@CHP_PsInOr - 12), a
                call        nz, @@SETENV
                ld          a, (bc)
                inc         bc
                jr          @@PD_SAM_
                ;
@@PTDECOD:      ld          a, (ix + @@CHP_Note - 12)
                ld          (@@PrNote + 1), a
                ld          l, (ix + @@CHP_CrTnSl - 12)
                ld          h, (ix + @@CHP_CrTnSl - 12 + 1)
                ld          (@@PrSlide + 1), hl
                ;
@@PD_LOOP:      ld          de, 0x2010
@@PD_LP2:       ld          a, (bc)
                inc         bc
                add         a, e
                jr          c, @@PD_OrSm
                add         a, d
                jr          z, @@PD_FIN
                jr          c, @@PD_SAM
                add         a, e
                jr          z, @@PD_REL
                jr          c, @@PD_VOL
                add         a, e
                jr          z, @@PD_EOff
                jr          c, @@PD_SorE
                add         a, 96
                jr          c, @@PD_NOTE
                add         a, e
                jr          c, @@PD_ORN
                add         a, d
                jr          c, @@PD_NOIS
                add         a, e
                jr          c, @@PD_ESAM
                add         a, a
                ld          e, a
                ld          hl, 0xffff & (@@SPCCOMS + 0xFF20 - 0x2000)
                add         hl, de
                ld          e, (hl)
                inc         hl
                ld          d, (hl)
                push        de
                jr          @@PD_LOOP
                ;
@@PD_NOIS:      ld          (@@Ns_Base), a
                jr          @@PD_LP2
                ;
@@PD_REL:       res         0, (ix + @@CHP_Flags - 12)
                jr          @@PD_RES
                ;
@@PD_NOTE:      ld          (ix + @@CHP_Note - 12), a
                set         0, (ix + @@CHP_Flags - 12)
                xor         a
                ;
@@PD_RES:       ld          (@@PDSP_+1), sp
                ld          sp, ix
                ld          h, a
                ld          l, a
                push        hl
                push        hl
                push        hl
                push        hl
                push        hl
                push        hl
@@PDSP_:        ld          sp, 0x3131
                ;
@@PD_FIN:       ld          a, (ix + @@CHP_NNtSkp - 12)
                ld          (ix + @@CHP_NtSkCn - 12), a
                ret
                ;
@@C_PORTM:      res         2, (ix + @@CHP_Flags - 12)
                ld          a, (bc)
                inc         bc
                ; SKIP PRECALCULATED TONE DELTA (BECAUSE CANNOT BE RIGHT AFTER PT3 COMPILATION)
                inc         bc
                inc         bc
                ld          (ix + @@CHP_TnSlDl - 12), a
                ld          (ix + @@CHP_TSlCnt - 12), a
                ld          de, @@NT_
                ld          a, (ix + @@CHP_Note - 12)
                ld          (ix + @@CHP_SlToNt - 12), a
                add         a, a
                ld          l, a
                ld          h, 0
                add         hl, de
                ld          a, (hl)
                inc         hl
                ld          h, (hl)
                ld          l, a
                push        hl
@@PrNote:       ld          a, 0x3e
                ld          (ix + @@CHP_Note - 12), a
                add         a, a
                ld          l, a
                ld          h, 0
                add         hl, de
                ld          e, (hl)
                inc         hl
                ld          d, (hl)
                pop         hl
                sbc         hl, de
                ld          (ix + @@CHP_TnDelt - 12), l
                ld          (ix + @@CHP_TnDelt - 12 + 1), h
                ld          e, (ix + @@CHP_CrTnSl - 12)
                ld          d, (ix + @@CHP_CrTnSl - 12 + 1)
;@@Version:      ld          a, 0x3e
;                cp          6
;                jr          c, @@OLDPRTM                    ; Old 3xxx for PT v3.5-
@@PrSlide:      ld          de, 0x1111
                ld          (ix + @@CHP_CrTnSl - 12), e
                ld          (ix + @@CHP_CrTnSl - 12 + 1), d
@@OLDPRTM:      ld          a, (bc)                         ; SIGNED TONE STEP
                inc         bc
                ex          af, af'
                ld          a, (bc)
                inc         bc
                and         a
                jr          z, @@NOSIG
                ex          de, hl
@@NOSIG:        sbc         hl, de
                jp          p, @@SET_STP
                cpl
                ex          af, af'
                neg
                ex          af, af'
@@SET_STP:      ld          (ix + @@CHP_TSlStp - 12 + 1), a
                ex          af, af'
                ld          (ix + @@CHP_TSlStp - 12), a
                ld          (ix + @@CHP_COnOff - 12), 0
                ret

@@C_GLISS:      set         2, (ix + @@CHP_Flags - 12)
                ld          a, (bc)
                inc         bc
                ld          (ix + @@CHP_TnSlDl - 12), a
                and         a
                jr          nz, @@GL36
                ;ld          a, (@@Version + 1)              ; AlCo PT3.7+
                ;cp          7
                ;sbc         a, a
                inc         a
@@GL36:         ld          (ix + @@CHP_TSlCnt - 12), a
                ld          a, (bc)
                inc         bc
                ex          af, af'
                ld          a, (bc)
                inc         bc
                jr          @@SET_STP

@@C_SMPOS:      ld          a, (bc)
                inc         bc
                ld          (ix + @@CHP_PsInSm - 12), a
                ret

@@C_ORPOS:      ld          a, (bc)
                inc         bc
                ld          (ix + @@CHP_PsInOr - 12), a
                ret

@@C_VIBRT:      ld          a, (bc)
                inc         bc
                ld          (ix + @@CHP_OnOffD - 12), a
                ld          (ix + @@CHP_COnOff - 12), a
                ld          a, (bc)
                inc         bc
                ld          (ix + @@CHP_OffOnD - 12), a
                xor         a
                ld          (ix + @@CHP_TSlCnt - 12), a
                ld          (ix + @@CHP_CrTnSl - 12), a
                ld          (ix + @@CHP_CrTnSl - 12 + 1), a
                ret

@@C_ENGLS:      ld          a, (bc)
                inc         bc
                ld          (@@Env_Del + 1), a
                ld          (@@CurEDel), a
                ld          a, (bc)
                inc         bc
                ld          l, a
                ld          a, (bc)
                inc         bc
                ld          h, a
                ld          (@@ESldAdd + 1), hl
                ret

@@C_DELAY:      ld          a, (bc)
                inc         bc
                ld          (@@delay + 1), a
                ret

@@SETENV:       ld          (ix + @@CHP_Env_En - 12), e
                ld          (@@AYREGS + @@EnvTp), a
                ld          a, (bc)
                inc         bc
                ld          h, a
                ld          a, (bc)
                inc         bc
                ld          l, a
                ld          (@@EnvBase), hl
                xor         a
                ld          (ix + @@CHP_PsInOr - 12), a
                ld          (@@CurEDel), a
                ld          h, a
                ld          l, a
                ld          (@@CurESld), hl
@@C_NOP:        ret

@@SETORN:       add         a, a
                ld          e, a
                ld          d, 0
                ld          (ix + @@CHP_PsInOr - 12), d
@@OrnPtrs:      ld          hl, 0x2121
                add         hl, de
                ld          e, (hl)
                inc         hl
                ld          d, (hl)
@@MDADDR2:      ld          hl, 0x2121
                add         hl, de
                ld          (ix + @@CHP_OrnPtr - 12), l
                ld          (ix + @@CHP_OrnPtr - 12 + 1), h
                ret

                ; ALL 16 ADDRESSES TO PROTECT FROM BROKEN PT3 MODULES
@@SPCCOMS:      dw          @@C_NOP
                dw          @@C_GLISS
                dw          @@C_PORTM
                dw          @@C_SMPOS
                dw          @@C_ORPOS
                dw          @@C_VIBRT
                dw          @@C_NOP
                dw          @@C_NOP
                dw          @@C_ENGLS
                dw          @@C_DELAY
                ;dw          @@C_NOP
                ;dw          @@C_NOP
                ;dw          @@C_NOP
                ;dw          @@C_NOP
                ;dw          @@C_NOP
                ;dw          @@C_NOP

@@CHREGS:       xor         a
                ld          (@@Ampl), a
                bit         0, (ix + @@CHP_Flags)
                push        hl
                jp          z, @@CH_EXIT
                ld          (@@CSP_ + 1), sp
                ld          l, (ix + @@CHP_OrnPtr)
                ld          h, (ix + @@CHP_OrnPtr + 1)
                ld          sp, hl
                pop         de
                ld          h, a
                ld          a, (ix + @@CHP_PsInOr)
                ld          l, a
                add         hl, sp
                inc         a
                cp          d
                jr          c, @@CH_ORPS
                ld          a, e
@@CH_ORPS:      ld          (ix + @@CHP_PsInOr), a
                ld          a, (ix + @@CHP_Note)
                add         a,(hl)
                jp          p, @@CH_NTP
                xor         a
@@CH_NTP:       cp          96
                jr          c, @@CH_NOK
                ld          a, 95
@@CH_NOK:       add         a, a
                ex          af, af'
                ld          l, (ix + @@CHP_SamPtr)
                ld          h, (ix + @@CHP_SamPtr + 1)
                ld          sp, hl
                pop         de
                ld          h, 0
                ld          a, (ix + @@CHP_PsInSm)
                ld          b, a
                add         a, a
                add         a, a
                ld          l, a
                add         hl, sp
                ld          sp, hl
                ld          a, b
                inc         a
                cp          d
                jr          c, @@CH_SMPS
                ld          a, e
@@CH_SMPS:      ld          (ix + @@CHP_PsInSm), a
                pop         bc
                pop         hl
                ld          e, (ix + @@CHP_TnAcc)
                ld          d, (ix + @@CHP_TnAcc + 1)
                add         hl, de
                bit         6, b
                jr          z, @@CH_NOAC
                ld          (ix + @@CHP_TnAcc), l
                ld          (ix + @@CHP_TnAcc + 1), h
@@CH_NOAC:      ex          de, hl
                ex          af, af'
                ld          l, a
                ld          h, 0
                ld          sp, @@NT_
                add         hl, sp
                ld          sp, hl
                pop         hl
                add         hl, de
                ld          e, (ix + @@CHP_CrTnSl)
                ld          d, (ix + @@CHP_CrTnSl + 1)
                add         hl, de
@@CSP_:         ld          sp, 0x3131
                ex          (sp), hl
                xor         a
                or          (ix + @@CHP_TSlCnt)
                jr          z, @@CH_AMP
                dec         (ix + @@CHP_TSlCnt)
                jr          nz, @@CH_AMP
                ld          a, (ix + @@CHP_TnSlDl)
                ld          (ix + @@CHP_TSlCnt), a
                ld          l, (ix + @@CHP_TSlStp)
                ld          h, (ix + @@CHP_TSlStp + 1)
                ld          a, h
                add         hl, de
                ld          (ix + @@CHP_CrTnSl), l
                ld          (ix + @@CHP_CrTnSl + 1), h
                bit         2, (ix + @@CHP_Flags)
                jr          nz, @@CH_AMP
                ld          e, (ix + @@CHP_TnDelt)
                ld          d, (ix + @@CHP_TnDelt + 1)
                and         a
                jr          z, @@CH_STPP
                ex          de, hl
@@CH_STPP:      sbc         hl, de
                jp          m, @@CH_AMP
                ld          a, (ix + @@CHP_SlToNt)
                ld          (ix + @@CHP_Note), a
                xor         a
                ld          (ix + @@CHP_TSlCnt), a
                ld          (ix + @@CHP_CrTnSl), a
                ld          (ix + @@CHP_CrTnSl + 1), a
@@CH_AMP:       ld          a, (ix + @@CHP_CrAmSl)
                bit         7, c
                jr          z, @@CH_NOAM
                bit         6, c
                jr          z, @@CH_AMIN
                cp          15
                jr          z, @@CH_NOAM
                inc         a
                jr          @@CH_SVAM
@@CH_AMIN:      cp          -15
                jr          z, @@CH_NOAM
                dec         a
@@CH_SVAM:      ld          (ix + @@CHP_CrAmSl), a
@@CH_NOAM:      ld          l, a
                ld          a, b
                and         15
                add         a, l
                jp          p, @@CH_APOS
                xor         a
@@CH_APOS:      cp          16
                jr          c, @@CH_VOL
                ld          a, 15
@@CH_VOL:       or          (ix + @@CHP_Volume)
                ld          l, a
                ld          h, 0
                ld          de, @@VT_
                add         hl, de
                ld          a, (hl)
@@CH_ENV:       bit         0, c
                jr          nz, @@CH_NOEN
                or          (ix + @@CHP_Env_En)
@@CH_NOEN:      ld          (@@Ampl), a
                bit         7, b
                ld          a, c
                jr          z, @@NO_ENSL
                rla
                rla
                sra         a
                sra         a
                sra         a
                add         a, (ix + @@CHP_CrEnSl)          ; SEE COMMENT BELOW
                bit         5, b
                jr          z, @@NO_ENAC
                ld          (ix + @@CHP_CrEnSl), a
@@NO_ENAC:      ld          hl, @@AddToEn + 1
                add         a, (hl)                         ; BUG IN PT3 - NEED WORD HERE.
                                                            ; FIX IT IN NEXT VERSION?
                pushAllowWrite @@AddToEn + 1, 1
                popAllowWriteAfter @@AddToEn + 1, 1
                ld          (hl), a
                jr          @@CH_MIX
@@NO_ENSL:      rra
                add         a, (ix + @@CHP_CrNsSl)
                ld          (@@AddToNs), a
                bit         5, b
                jr          z, @@CH_MIX
                ld          (ix + @@CHP_CrNsSl), a
@@CH_MIX:       ld          a, b
                rra
                and         0x48
@@CH_EXIT:      ld          hl, @@AYREGS + @@Mixer
                or          (hl)
                rrca
                ld          (hl), a
                pop         hl
                xor         a
                or          (ix + @@CHP_COnOff)
                ret         z
                dec         (ix + @@CHP_COnOff)
                ret         nz
                xor         (ix + @@CHP_Flags)
                ld          (ix + @@CHP_Flags), a
                rra
                ld          a, (ix + @@CHP_OnOffD)
                jr          c, @@CH_ONDL
                ld          a, (ix + @@CHP_OffOnD)
@@CH_ONDL:      ld          (ix + @@CHP_COnOff), a
                ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

@@_CurrentMusic db          0

@@play:         ld          a, (@@_CurrentMusic)
@@currentMusic: cp          0xff
                jr          z, @@doPlay
                ld          (@@currentMusic + 1), a
                cp          0xff
                jr          z, @@doPlay
                ;ld          hl, MusicTracks
                ;ld          e, a
                ;ld          d, 0
                ;add         hl, de
                ;ld          a, (hl)
                ;inc         hl
                ;ld          h, (hl)
                ;ld          l, a
                push        af
                call        @@init
                pop         af
@@doPlay:       cp          0xff
                jp          z, @@mute
                xor         a
                ld          (@@AddToEn + 1), a
                ld          (@@AYREGS + @@Mixer), a
                dec         a
                ld          (@@AYREGS + @@EnvTp), a
                ld          hl, @@DelyCnt
                dec         (hl)
                jr          nz, @@PL2
                ld          hl, @@ChanA + @@CHP_NtSkCn
                dec         (hl)
                jr          nz, @@PL1B
@@AdInPtA:      ld          bc, 0x0101
                ld          a, (bc)
                and         a
                jr          nz, @@PL1A
                ld          d, a
                ld          (@@Ns_Base), a
@@currentPos_:  ld          hl, 0xcafe
                inc         hl
                ld          a, (hl)
                inc         a
                jr          nz, @@PLNLP
                ;call        @@checkLoop
@@LPosPtr:      ld          hl, 0x2121
                ld          a, (hl)
                inc         a
@@PLNLP:        ld          (@@currentPos), hl
                dec         a
                add         a, a
                ld          e, a
                rl          d
@@PatsPtr:      ld          hl, 0x2121
                add         hl, de
                ld          de, (@@MODADDR + 1)
                ld          (@@PSP_ + 1), sp
                ld          sp, hl
                pop         hl
                add         hl, de
                ld          b, h
                ld          c, l
                pop         hl
                add         hl, de
                ld          (@@AdInPtB + 1), hl
                pop         hl
                add         hl, de
                ld          (@@AdInPtC + 1), hl
@@PSP_:         ld          sp, 0x3131
@@PL1A:         ld          ix, @@ChanA + 12
                call        @@PTDECOD
                ld          (@@AdInPtA + 1), bc
                ;
@@PL1B:         ld          hl, @@ChanB + @@CHP_NtSkCn
                dec         (hl)
                jr          nz, @@PL1C
                ld          ix, @@ChanB + 12
@@AdInPtB:      ld          bc, 0x0101
                call        @@PTDECOD
                ld          (@@AdInPtB + 1),bc
                ;
@@PL1C:         ld          hl, @@ChanC + @@CHP_NtSkCn
                dec         (hl)
                jr          nz, @@delay
                ld          ix, @@ChanC + 12
@@AdInPtC:      ld          bc, 0x0101
                call        @@PTDECOD
                ld          (@@AdInPtC + 1), bc
                ;
@@delay:        ld          a, 0x3e
                ld          (@@DelyCnt), a
                ;
@@PL2:          ld          ix, @@ChanA
                ld          hl, (@@AYREGS + @@TonA)
                call        @@CHREGS
                ld          (@@AYREGS + @@TonA), hl
                ld          a, (@@Ampl)
                ld          (@@AYREGS + @@AmplA), a
                ld          ix ,@@ChanB
                ld          hl, (@@AYREGS + @@TonB)
                call        @@CHREGS
                ld          (@@AYREGS + @@TonB), hl
                ld          a, (@@Ampl)
                ld          (@@AYREGS + @@AmplB), a
                ld          ix, @@ChanC
                ld          hl, (@@AYREGS + @@TonC)
                call        @@CHREGS
                ;ld         a, (Ampl)                       ; Ampl = AYREGS+AmplC
                ;ld         (AYREGS + AmplC), a
                ld          (@@AYREGS + @@TonC), hl
                ;
@@Ns_Base_AddToNS_:
                ld          hl, 0xc0de
                ld          a, h
                add         a, l
                ld          (@@AYREGS + @@Noise), a
@@AddToEn:      ld          a, 0x3e
                ld          e, a
                add         a, a
                sbc         a, a
                ld          d, a
                ld          hl, (@@EnvBase)
                add         hl, de
@@CurESld_:     ld          de, 0xbabe
                add         hl, de
                ld          (@@AYREGS + @@Env), hl
                ;
                xor         a
                ld          hl, @@CurEDel
                or          (hl)
                jr          z, @@ROUT_A0
                dec         (hl)
                jr          nz, @@ROUT
@@Env_Del:      ld          a, 0x3e
                ld          (hl), a
@@ESldAdd:      ld          hl, 0x2121
                add         hl, de
                ld          (@@CurESld), hl
@@ROUT:         xor         a
@@ROUT_A0:      ld          de, 0xffbf
                ld          bc, 0xfffd
                ld          hl, @@AYREGS
@@LOUT:         out         (c), a
                ld          b, e
                outi
                ld          b, d
                inc         a
                cp          13
                jr          nz, @@LOUT
                out         (c), a
                ld          a, (hl)
                and         a
                ret         m
                ld          b, e
                out         (c), a
                ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;@@NT_DATA       db          (@@T_NEW_0 - @@T1_) * 2
                ;db          (@@TCNEW_0 - @@T_)
                ;db          (@@T_OLD_0 - @@T1_) * 2 + 1
                ;db          (@@TCOLD_0 - @@T_)
                ;db          (@@T_NEW_1 - @@T1_) * 2 + 1
                ;db          (@@TCNEW_1 - @@T_)
                ;db          (@@T_OLD_1 - @@T1_) * 2 + 1
                ;db          (@@TCOLD_1 - @@T_)
                ;db          (@@T_NEW_2 - @@T1_) * 2
                ;db          (@@TCNEW_2 - @@T_)
                ;db          (@@T_OLD_2 - @@T1_) * 2
                ;db          (@@TCOLD_2 - @@T_)
                ;db          (@@T_NEW_3 - @@T1_) * 2
                ;db          (@@TCNEW_3 - @@T_)
                ;db          (@@T_OLD_3 - @@T1_) * 2
                ;db          (@@TCOLD_3 - @@T_)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

@@T_:
;@@TCOLD_0       db          0x00+1, 0x04+1, 0x08+1, 0x0A+1, 0x0C+1, 0x0E+1, 0x12+1, 0x14+1, 0x18+1, 0x24+1, 0x3C+1, 0
;@@TCOLD_1       db          0x5C+1, 0
;@@TCOLD_2       db          0x30+1, 0x36+1, 0x4C+1, 0x52+1, 0x5E+1, 0x70+1
;                db          0x82, 0x8C, 0x9C, 0x9E, 0xA0, 0xA6, 0xA8, 0xAA, 0xAC, 0xAE, 0xAE, 0
;@@TCNEW_3       db          0x56+1
;@@TCOLD_3       db          0x1E+1, 0x22+1, 0x24+1, 0x28+1, 0x2C+1, 0x2E+1, 0x32+1, 0xBE+1, 0
;@@TCNEW_0       db          0x1C+1, 0x20+1, 0x22+1, 0x26+1, 0x2A+1, 0x2C+1, 0x30+1, 0x54+1, 0xBC+1, 0xBE+1,0
;@@TCNEW_1       = @@TCOLD_1
@@TCNEW_2       db          0x1A+1, 0x20+1, 0x24+1, 0x28+1, 0x2A+1, 0x3A+1, 0x4C+1, 0x5E+1, 0xBA+1, 0xBC+1, 0xBE+1, 0

@@EMPTYSAMORN   = @@EMPTYSAMORN_1 - 1
@@EMPTYSAMORN_1:db          1, 0, 0x90                      ; delete #90 if you don't need default sample

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

                section     music

                ; vars from here can be stripped
                ; you can move VARS to any other address

@@VARS:

                ; ChannelsVars
                ;   STRUCT CHP
                ; reset group
@@CHP_PsInOr    = 0     ; db 0
@@CHP_PsInSm    = 1     ; db 0
@@CHP_CrAmSl    = 2     ; db 0
@@CHP_CrNsSl    = 3     ; db 0
@@CHP_CrEnSl    = 4     ; db 0
@@CHP_TSlCnt    = 5     ; db 0
@@CHP_CrTnSl    = 6     ; dw 0
@@CHP_TnAcc     = 8     ; dw 0
@@CHP_COnOff    = 10    ; db 0
                ; reset group
@@CHP_OnOffD    = 11    ; db 0
                ; IX for PTDECOD here (+12)
@@CHP_OffOnD    = 12    ; db 0
@@CHP_OrnPtr    = 13    ; dw 0
@@CHP_SamPtr    = 15    ; dw 0
@@CHP_NNtSkp    = 17    ; db 0
@@CHP_Note      = 18    ; db 0
@@CHP_SlToNt    = 19    ; db 0
@@CHP_Env_En    = 20    ; db 0
@@CHP_Flags     = 21    ; db 0
                 ; Enabled - 0,SimpleGliss - 2
@@CHP_TnSlDl    = 22    ; db 0
@@CHP_TSlStp    = 23    ; dw 0
@@CHP_TnDelt    = 25    ; dw 0
@@CHP_NtSkCn    = 27    ; db 0
@@CHP_Volume    = 28    ; db 0
                ; ENDS

@@ChanA:        repeat 29   ; DS CHP
                db          0
                endrepeat
@@ChanB:        repeat 29   ; DS CHP
                db          0
                endrepeat
@@ChanC:        repeat 29   ; DS CHP
                db          0
                endrepeat

                ; GlobalVars
@@DelyCnt       db          0
@@CurEDel       db          0

@@AYREGS:
@@VT_:          repeat      256                             ; DS 256 ; CreatedVolumeTableAddress
                db          0
                endrepeat

@@EnvBase       = @@VT_ + 14
@@T1_           = @@VT_ + 16                                ; Tone tables data depacked here
@@T_OLD_1       = @@T1_
@@T_OLD_2       = @@T_OLD_1 + 24
@@T_OLD_3       = @@T_OLD_2 + 24
@@T_OLD_0       = @@T_OLD_3 + 2
@@T_NEW_0       = @@T_OLD_0
;@@T_NEW_1       = @@T_OLD_1
@@T_NEW_2       = @@T_NEW_0 + 24
;@@T_NEW_3       = @@T_OLD_3

@@NT_:          repeat 192                                  ; DS 192 ; CreatedNoteTableAddress
                db          0
                endrepeat

                ; local var
@@Ampl          = @@AYREGS + @@AmplC
@@VAR0END       = @@VT_ + 16                                ; INIT zeroes from VARS to VAR0END-1
@@VARSEND:


InitMusicPlayer:;note table data depacker
                ld          de, @@packedNoteTable
                ld          bc, MusicPlayer@@T1_ + (2 * 49) - 1
@@TP_0:         ld          a, (de)
                inc         de
                cp          15*2
                jr          nc, @@TP_1
                ld          h, a
                ld          a, (de)
                ld          l, a
                inc         de
                jr          @@TP_2
@@TP_1:         push        de
                ld          d, 0
                ld          e, a
                add         hl, de
                add         hl, de
                pop         de
@@TP_2:         ld          a, h
                ld          (bc), a
                dec         bc
                ld          a, l
                ld          (bc), a
                dec         bc
                sub         0xff & (0xf8 * 2)
                jr          nz, @@TP_0
                ; NoteTableCreator (c) Ivan Roshin
                ld          hl, MusicPlayer@@T_NEW_2
                ld          bc, MusicPlayer@@TCNEW_2
                push        bc
                ld          de, MusicPlayer@@NT_
                push        de
                ;
                ld          b, 12
@@L1:           push        bc
                ld          c, (hl)
                inc         hl
                push        hl
                ld          b, (hl)
                ;
                push        de
                ex          de, hl
                ld          de, 23
                ld          ixh, 8
                ;
@@L2:           srl         b
                rr          c
                ld          a, c
                adc         a, d                            ; = ADC 0
                ld          (hl), a
                inc         hl
                ld          a, b
                adc         a, d
                ld          (hl), a
                add         hl, de
                dec         ixh
                jr          nz, @@L2
                ;
                pop         de
                inc         de
                inc         de
                pop         hl
                inc         hl
                pop         bc
                djnz        @@L1
                ;
                pop         hl
                pop         de
@@CORR_1:       ld          a, (de)
                and         a
                jr          z, @@TC_EXIT
                rra
                push        af
                add         a, a
                ld          c, a
                add         hl, bc
                pop         af
                jr          nc, @@CORR_2
                dec         (hl)
                dec         (hl)
@@CORR_2:       inc         (hl)
                and         a
                sbc         hl, bc
                inc         de
                jr          @@CORR_1
@@TC_EXIT:      ; VolTableCreator (c) Ivan Roshin
                ld          hl, 0x11
                ld          d, h
                ld          e, h
                ;
                ld          ix, MusicPlayer@@VT_ + 16
                ld          c, 0x10
                ;
@@INITV2:       push        hl
                ;
                add         hl, de
                ex          de, hl
                sbc         hl, hl
                ;
@@INITV1:       ld          a, l
                db          0x17
                ld          a, h
                adc         a, 0
                ld          (ix), a
                inc         ix
                add         hl, de
                inc         c
                ld          a, c
                and         15
                jr          nz, @@INITV1
                ;
                pop         hl
                ld          a, e
                cp          0x77
                jr          nz, @@M3
                inc         e
@@M3:           ld          a, c
                and         a
                jr          nz, @@INITV2
                ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

                ; first 12 values of tone tables (packed)

@@packedNoteTable:
                db          0xff & (0x06EC * 2 / 256), 0xff & (0x06EC * 2)
                db          0x0755 - 0x06EC
                db          0x07C5 - 0x0755
                db          0x083B - 0x07C5
                db          0x08B8 - 0x083B
                db          0x093D - 0x08B8
                db          0x09CA - 0x093D
                db          0x0A5F - 0x09CA
                db          0x0AFC - 0x0A5F
                db          0x0BA4 - 0x0AFC
                db          0x0C55 - 0x0BA4
                db          0x0D10 - 0x0C55
                db          0xff & (0x066D * 2 / 256), 0xff & (0x066D * 2)
                db          0x06CF - 0x066D
                db          0x0737 - 0x06CF
                db          0x07A4 - 0x0737
                db          0x0819 - 0x07A4
                db          0x0894 - 0x0819
                db          0x0917 - 0x0894
                db          0x09A1 - 0x0917
                db          0x0A33 - 0x09A1
                db          0x0ACF - 0x0A33
                db          0x0B73 - 0x0ACF
                db          0x0C22 - 0x0B73
                db          0x0CDA - 0x0C22
                db          0xff & (0x0704 * 2 / 256), 0xff & (0x0704 * 2)
                db          0x076E - 0x0704
                db          0x07E0 - 0x076E
                db          0x0858 - 0x07E0
                db          0x08D6 - 0x0858
                db          0x095C - 0x08D6
                db          0x09EC - 0x095C
                db          0x0A82 - 0x09EC
                db          0x0B22 - 0x0A82
                db          0x0BCC - 0x0B22
                db          0x0C80 - 0x0BCC
                db          0x0D3E - 0x0C80
                db          0xff & (0x07E0 * 2 / 256), 0xff & (0x07E0 * 2)
                db          0x0858 - 0x07E0
                db          0x08E0 - 0x0858
                db          0x0960 - 0x08E0
                db          0x09F0 - 0x0960
                db          0x0A88 - 0x09F0
                db          0x0B28 - 0x0A88
                db          0x0BD8 - 0x0B28
                db          0x0C80 - 0x0BD8
                db          0x0D60 - 0x0C80
                db          0x0E10 - 0x0D60
                db          0x0EF8 - 0x0E10
