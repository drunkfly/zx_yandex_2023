;Tritone v2 beeper music engine by Shiru (shiru@mail.ru) 03'11
;Three channels of tone, per-pattern tempo
;One channel of interrupting drums
;Feel free to do whatever you want with the code, it is PD

;OP_NOP	equ #00
;OP_SCF	equ #37
;OP_ORC	equ #b1

OP_JP	EQU	195
OP_LDHL	EQU	33

	define NO_VOLUME	;define this if you want to have the same volume for all the channels

	;define	HD_MOD
	define	HD_FACTOR 8

	IFDEF	HD_MOD
	display	"play this file in unreal with ", /D, 71680*(HD_FACTOR*4+1), " tacts"
	ENDIF

	module tritone

play
	di
	ld (nextPos.pos),hl
;	ld c,16
	push iy
	exx
	push hl
;	ld (stopPlayer.prevSP),sp
	xor a
	ld h,a
	ld l,h
;	ld (playRow.cnt0),hl
	ld bc,0
;	ld (playRow.cnt1),hl
	exx
	ld de,0
	ld bc,0
	exx
;	ld (playRow.cnt2),hl
	ld (soundLoop.duty0),a
	ld (soundLoop.duty1),a
	ld (soundLoop.duty2),a
	ld a,OP_JP
	ld (nextRow.skipDrum),a
;	in a,(#1f)
;	and #1f
;	ld a,OP_NOP
;	jr nz,$+4
;	ld a,OP_ORC
;	ld (soundLoop.checkKempston),a
	jr nextPos

orderLoop
	ld e,(hl)
	inc hl
	ld d,(hl)
	ex de,hl
	jr nextPos.read

nextPos
.pos=$+1
	ld hl,0
.read
	ld e,(hl)
	inc hl
	ld d,(hl)
	inc hl
	ld a,d
	or e
	jr z,orderLoop
;	jp z,stopPlayer
	ld (.pos),hl
	ex de,hl
		push bc
	ld c,(hl)
	inc hl
	ld b,(hl)
	inc hl
	;dec b
	ld a,c : sub 32 : ld c,a
	jr nc,$+3 : dec b
	ld (playRow.speed),bc
		pop bc
	;ld (nextRow.pos),hl
;	jp nextRow
	jr nextRow.posKnown

ch0pause
	ld b,a
	ld c,a
	jp nextRow.ch0set

ch1pause
	exx
	ld d,a
	ld e,a
	exx
	jp nextRow.ch1set

ch2pause
	exx
	ld b,a
	ld c,a
	exx
	jp nextRow.ch2set

nextRow
.pos=$+1
	ld hl,0
.posKnown
	ld a,(hl)
	inc hl

	IFDEF NEWSTYLE

	ld a,(hl)
	inc hl
	dec a
	jr nz,ch0
	ld a,(hl)
	inc hl
	dec a
	jr nz,ch1
	ld a,(hl)
	inc hl
	dec a
	jr nz,ch2
	ld (.pos),hl
	jp playRow	; 10+7+6+4+7 + 7+6+4+7 + 7+6+4+7 + 16+10 = 108t

	ENDIF

		dec a
		jp z,.ch1
		inc a
		jr z,ch0pause	; 10+7+6 +4+10 = 37t

;	cp 2
;	jr c,.ch0	; 10+7+6+7+12=42t

	;cp 128
	;jp nc,.ch0note
	;jr drumSound
	jp p,drumSound

.ch0note
	ld e,a
	and #0f
	ld b,a
	ld c,(hl)
	inc hl
	;ld a,e
	;and #f0
	xor e

;		jp .ch0note
;.ch0
;	ld d,1
;	cp d
;	jr z,.ch1	; 7+4+12=23t

;	or a
;	jr nz,.ch0note
.ch0set
	ld (soundLoop.duty0),a
;	ld (playRow.cnt0),bc

.ch1
	ld a,(hl)
	inc hl
	dec a	;cp d
	jp z,.ch2	; 7+6+4+10=27t

	inc a	;or a
	jr z,ch1pause
;		push bc
;	ld b,a
;	ld c,a
;	exx
;	ld d,a
;	ld e,a
;	exx
;	jp .ch1set
.ch1note
	ld e,a
	ex af,af'
	ld a,(hl)
	inc hl
	exx
	ld e,a
	ex af,af'
	and #0f
	ld d,a
	exx
	xor e ; 4+4+7+6+4+4+4+7+4+4+4 = 52t

;	ld e,a
;	and #0f
;	exx
;	ld d,a
;	exx
;	ld a,(hl)
;	inc hl
;	exx
;	ld e,a
;	exx
;	ld a,e
;	and #f0 ; 4+7+3+3+3+7+6+4+4+4+4+7 = 56t

.ch1set
	ld (soundLoop.duty1),a
;	ld (playRow.cnt1),bc
;		pop bc

.ch2
	ld a,(hl)
	inc hl
	dec a	;cp d
	jp z,.skip	; 7+6+4+12=27t

	inc a	;or a
	jr z,ch2pause
;		push bc
;	exx
;	ld b,a
;	ld c,a
;	exx
;	jp .ch2set
.ch2note
	ld e,a
	ex af,af'
	ld a,(hl)
	inc hl
	exx
	ld c,a
	ex af,af'
	and #0f
	ld b,a
	exx
	xor e

;	ld e,a
;	and #0f
;	exx
;	ld b,a
;	exx
;	ld a,(hl)
;	inc hl
;	exx
;	ld c,a
;	exx
;	ld a,e
;	and #f0
.ch2set
	ld (soundLoop.duty2),a
;	ld (playRow.cnt2),bc
;		pop bc

.skip
	ld (.pos),hl
.skipDrum=$
;	scf
	jp playRow	; 16+10=26t

	ld a,OP_JP
	ld (.skipDrum),a

	ld hl,(playRow.speed)
	ld de,-150
	add hl,de
	ex de,hl
	jr c,$+5
	ld de,257
	ld a,d
	or a
	jr nz,$+3
	inc d
	ld a,e
	or a
	jr nz,$+3
	inc e
	jp playRow.drum;jr playRow.drum

drumSound
	cp 127;255
	jp z,nextPos
	ld (nextRow.pos),hl
	push bc

	add a,a
	ld ixl,a
	ld ixh,0
	ld bc,drumSettings-4
	add ix,bc
	cp 14*2
	ld a,OP_LDHL
	ld (nextRow.skipDrum),a
	jr nc,drumNoise

drumTone
	ld bc,2
	ld a,b
	ld de,#1001
	ld l,(ix)
.l0
	IFDEF	HD_MOD
	DUP	HD_FACTOR*20
	nop
	EDUP
	ENDIF
	bit 0,b		; 8+12 = 20t
	jp z,.l1;jr z,.l1

	IFDEF	HD_MOD
	DUP	HD_FACTOR*11
	nop
	EDUP
	ENDIF
	dec e		; 4+12-5 = 11t
	jp nz,.l1;jr nz,.l1

	IFDEF	HD_MOD
	DUP	HD_FACTOR*38
	nop
	EDUP
	ENDIF
	ld e,l		; 4+4+4+19+4+4+4-5 = 38t
	exa
	ld a,l
	add a,(ix+1)
	ld l,a
	exa
	xor d
.l1
	IFDEF	HD_MOD
	DUP	HD_FACTOR*24
	nop
	EDUP
	ENDIF
	out (#fe),a	; 11+13 = 24t
	dec b : jp nz,.l0 ;djnz .l0

	IFDEF	HD_MOD
	DUP	HD_FACTOR*14
	nop
	EDUP
	ENDIF
	dec c		; 4+10 = 14t
	jp nz,.l0

	pop bc
	jp nextRow

drumNoise
	ld b,0
	ld h,b
	ld l,h
	ld de,#1001
.l0
	IFDEF	HD_MOD
	DUP	HD_FACTOR*11
	nop
	EDUP
	ENDIF
	ld a,(hl)	; 11t
	and d

	IFDEF	HD_MOD
	DUP	HD_FACTOR*26
	nop
	EDUP
	ENDIF
	out (#fe),a	; 11+11+4 = 26t
	and (ix)
	dec e

	IFDEF	HD_MOD
	DUP	HD_FACTOR*23
	nop
	EDUP
	ENDIF
	out (#fe),a	; 11+12 = 23t
	jp nz,.l1

	IFDEF	HD_MOD
	DUP	HD_FACTOR*20
	nop
	EDUP
	ENDIF
	ld e,(ix+1)	; 19+6-5 = 20t
	inc hl
.l1
	IFDEF	HD_MOD
	DUP	HD_FACTOR*13
	nop
	EDUP
	ENDIF
	dec b
	jp nz, .l0
	;djnz .l0	; 13t

	pop bc
	jp nextRow

playRow
.speed=$+1
	ld de,0
.drum
;.cnt0=$+1
;	ld bc,0
.prevHL=$+1
	ld hl,0

;		add hl,bc
;		exx
;		add ix,de
;		add hl,bc
;		exx

;	exx
;.cnt1=$+1
;	ld de,0
;.cnt2=$+1
;	ld bc,0
;	exx	; 10+10+10+4+10+10+4=58t
			; originally it was: 20+58 + 42+23+29+29+30 + 58 = 289t - this is where the row transition noise comes from
			; now it is: 16+10 + 37+27+27+26 + 20 = 163t
			; potential: 16+10 + 108 + 20 = 154t

soundLoop
	ifdef NO_VOLUME		;all the channels has the same volume

	DEFINE WAY2
	IFDEF WAY2

	ld iyh,d
	ld d,16

.soundLoopInner

		add hl,bc	;11
	ld a,h		;4
.duty0=$+1
	cp 128		;7
	sbc a,a		;4
	and d		;4
	out (#fe),a	;11	; 15+4+6+4+10 + 11+4+7+4+4+11 = 80t (channel 3)

	ld a,ixh	;8
.duty1=$+1
	cp 128		;7
	sbc a,a		;4
	and d		;4
		dec de		;6
	out (#fe),a	;11	; 8+7+4+4+6+11 = 40t (channel 1)

	exx		;4
		add hl,bc	;11
	ld a,h		;4
.duty2=$+1
	cp 128		;7
	sbc a,a		;4
	and 16		;7
;		nop		;4
	out (#fe),a	;11	; 4+11+4+7+4+7+11 = 48t (channel 2)

		add ix,de	;15
		exx		;4
		inc de		;6

;		nop		;4
		dec e		;4
	jp nz,.soundLoopInner	;10

	ld d,iyh

	ENDIF

	;DEFINE WAY1
	IFDEF WAY1
	
	add hl,bc	;11
	ld a,h		;4
.duty0=$+1
	cp 128		;7
	sbc a,a		;4
	exx		;4
	and 16		;4

		; 11 + 4+12 + 11+4+7+4+4+7 = 64t (channel 3)

	out (#fe),a	;11	; 4+12 + 11+4+7+4+4+7+4+11 = 64t

	add ix,de	;15
	ld a,ixh	;8
.duty1=$+1
	cp 128		;7
	sbc a,a		;4
	and 16		;7
	nop
		; 11 + 15+8+7+4+7+4 = 56t (channel 1)

	out (#fe),a	;11	; 15+8+7+4+7+4+11 = 56t

	add hl,bc	;11
	ld a,h		;4
.duty2=$+1
	cp 128		;7
	sbc a,a		;4
	and 16		;7
	exx		;4

		; 11 + 11+4+7+4+7+4 = 48t (channel 2)

	out (#fe),a	;11	; 11+4+7+4+7+4+11 = 48t

	dec e		;4
	jr nz,soundLoop	;10=153t (was 153; now 64+56+48=168t)

	ENDIF

	xor a
	in a,(254)
	cpl
	and 31
	jr nz,stopPlayer	; 4+11+4+7+7=33t

	ld (playRow.prevHL),hl	; 16t

	dec d		;4
	jr nz,soundLoop	;12	; 4+7 + 33 + 4+12 + 11+4+7+4+4+7+4+11 = 112t

	jp nextRow
	
	else				; all the channels has different volume

	add hl,bc	;11
	ld a,h		;4
	exx			;4
.duty0=$+1
	cp 128		;7
	sbc a,a		;4
	and c		;4
	add ix,de	;15

	IFDEF	HD_MOD
	DUP	HD_FACTOR*70
	nop
	EDUP
	ENDIF

	out (#fe),a	;11	; 11+8+7+4+4 = 34t
	ld a,ixh	;8
.duty1=$+1
	cp 128		;7
	sbc a,a		;4
	and c		;4

	IFDEF	HD_MOD
	DUP	HD_FACTOR*34
	nop
	EDUP
	ENDIF

	out (#fe),a	;11	; 11+11+4+7+4+4+4+4 = 49t
	add hl,sp	;11
	ld a,h		;4
.duty2=$+1
	cp 128		;7
	sbc a,a		;4
	and c		;4
	exx			;4
	dec e		;4

	IFDEF	HD_MOD
	DUP	HD_FACTOR*49
	nop
	EDUP
	ENDIF

	out (#fe),a	;11	; 11+10+11+4+4+7+4+4+15 = 70t (check: 34+49+70=153t)
	jp nz,soundLoop	;10=153t

	IFDEF	HD_MOD
	;DUP	HD_FACTOR*14
	;nop
	;EDUP
	ENDIF

	dec d		;4
	jp nz,soundLoop	;10
	
	endif

	;xor a
	;out (#fe),a

	ld (playRow.prevHL),hl	; 16t

	;in a,(#1f)
	;and #1f
	;ld c,a
;	xor a
;	in a,(#fe)
;	cpl
;.checkKempston=$
;	or c
;	and #1f
;	jp z,nextRow	; 4+11+4+7+10=36t

stopPlayer
;.prevSP=$+1
;	ld sp,0
	pop hl
	exx
	pop iy
	ei
	ret

drumSettings
	db #01,#01	;tone,highest
	db #01,#02
	db #01,#04
	db #01,#08
	db #01,#20
	db #20,#04
	db #40,#04
	db #40,#08	;lowest
	db #04,#80	;special
	db #08,#80
	db #10,#80
	db #10,#02
	db #20,#02
	db #40,#02
	db #16,#01	;noise,highest
	db #16,#02
	db #16,#04
	db #16,#08
	db #16,#10
	db #00,#01
	db #00,#02
	db #00,#04
	db #00,#08
	db #00,#10

	endmodule