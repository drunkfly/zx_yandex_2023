;Tritone v2 beeper music engine by Shiru (shiru@mail.ru) 03'11
;Three channels of tone, per-pattern tempo
;One channel of interrupting drums
;Feel free to do whatever you want with the code, it is PD

OP_NOP	equ #00
OP_SCF	equ #37
OP_ORC	equ #b1

	;define NO_VOLUME	;define this if you want to have the same volume for all the channels

	module tritone

play
	di
	ld (nextPos.pos),hl
	ld c,16
	push iy
	exx
	push hl
	ld (stopPlayer.prevSP),sp
	xor a
	ld h,a
	ld l,h
	ld (playRow.cnt0),hl
	ld (playRow.cnt1),hl
	ld (playRow.cnt2),hl
	ld (soundLoop.duty0),a
	ld (soundLoop.duty1),a
	ld (soundLoop.duty2),a
	ld (nextRow.skipDrum),a
	in a,(#1f)
	and #1f
	ld a,OP_NOP
	jr nz,$+4
	ld a,OP_ORC
	ld (soundLoop.checkKempston),a
	jp nextPos

nextRow
.pos=$+1
	ld hl,0
	ld a,(hl)
	inc hl
	cp 2
	jr c,.ch0
	cp 128
	jr c,drumSound
	cp 255
	jp z,nextPos

.ch0
	ld d,1
	cp d
	jr z,.ch1
	or a
	jr nz,.ch0note
	ld b,a
	ld c,a
	jr .ch0set
.ch0note
	ld e,a
	and #0f
	ld b,a
	ld c,(hl)
	inc hl
	ld a,e
	and #f0
.ch0set
	ld (soundLoop.duty0),a
	ld (playRow.cnt0),bc
.ch1
	ld a,(hl)
	inc hl
	cp d
	jr z,.ch2
	or a
	jr nz,.ch1note
	ld b,a
	ld c,a
	jr .ch1set
.ch1note
	ld e,a
	and #0f
	ld b,a
	ld c,(hl)
	inc hl
	ld a,e
	and #f0
.ch1set
	ld (soundLoop.duty1),a
	ld (playRow.cnt1),bc
.ch2
	ld a,(hl)
	inc hl
	cp d
	jr z,.skip
	or a
	jr nz,.ch2note
	ld b,a
	ld c,a
	jr .ch2set
.ch2note
	ld e,a
	and #0f
	ld b,a
	ld c,(hl)
	inc hl
	ld a,e
	and #f0
.ch2set
	ld (soundLoop.duty2),a
	ld (playRow.cnt2),bc

.skip
	ld (.pos),hl
.skipDrum=$
	scf
	jp nc,playRow
	ld a,OP_NOP
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
	jr playRow.drum

drumSound
	ld (nextRow.pos),hl

	add a,a
	ld ixl,a
	ld ixh,0
	ld bc,drumSettings-4
	add ix,bc
	cp 14*2
	ld a,OP_SCF
	ld (nextRow.skipDrum),a
	jr nc,drumNoise

drumTone
	ld bc,2
	ld a,b
	ld de,#1001
	ld l,(ix)
.l0
	bit 0,b
	jr z,.l1
	dec e
	jr nz,.l1
	ld e,l
	exa
	ld a,l
	add a,(ix+1)
	ld l,a
	exa
	xor d
.l1
	out (#fe),a
	djnz .l0
	dec c
	jp nz,.l0

	jp nextRow

drumNoise
	ld b,0
	ld h,b
	ld l,h
	ld de,#1001
.l0
	ld a,(hl)
	and d
	out (#fe),a
	and (ix)
	dec e
	out (#fe),a
	jr nz,.l1
	ld e,(ix+1)
	inc hl
.l1
	djnz .l0

	jp nextRow

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
	ld (.pos),hl
	ex de,hl
	ld c,(hl)
	inc hl
	ld b,(hl)
	inc hl
	ld (nextRow.pos),hl
	ld (playRow.speed),bc
	jp nextRow

orderLoop
	ld e,(hl)
	inc hl
	ld d,(hl)
	ex de,hl
	jr nextPos.read

playRow
.speed=$+1
	ld de,0
.drum
.cnt0=$+1
	ld bc,0
.prevHL=$+1
	ld hl,0
	exx
.cnt1=$+1
	ld de,0
.cnt2=$+1
	ld sp,0
	exx

soundLoop
	ifdef NO_VOLUME		;all the channels has the same volume
	
	add hl,bc	;11
	ld a,h		;4
.duty0=$+1
	cp 128		;7
	sbc a,a		;4
	exx			;4
	and c		;4
	out (#fe),a	;11
	add ix,de	;15
	ld a,ixh	;8
.duty1=$+1
	cp 128		;7
	sbc a,a		;4
	and c		;4
	out (#fe),a	;11
	add hl,sp	;11
	ld a,h		;4
.duty2=$+1
	cp 128		;7
	sbc a,a		;4
	and c		;4
	exx			;4
	dec e		;4
	out (#fe),a	;11
	jp nz,soundLoop	;10=153t
	dec d		;4
	jp nz,soundLoop	;10
	
	else				; all the channels has different volume

	add hl,bc	;11
	ld a,h		;4
	exx			;4
.duty0=$+1
	cp 128		;7
	sbc a,a		;4
	and c		;4
	add ix,de	;15
	out (#fe),a	;11
		; 10 + 11+4+4+7+4+4+15+11 = 70t (channel 3)
	ld a,ixh	;8
.duty1=$+1
	cp 128		;7
	sbc a,a		;4
	and c		;4
	out (#fe),a	;11
		; 8+7+4+4+11 = 34t (channel 1)
	add hl,sp	;11
	ld a,h		;4
.duty2=$+1
	cp 128		;7
	sbc a,a		;4
	and c		;4
	exx			;4
	dec e		;4
	out (#fe),a	;11
		; 11+4+7+4+4+4+4+11 = 49t (channel 2)
	jp nz,soundLoop	;10=153t
	dec d		;4
	jp nz,soundLoop	;10
	
	endif

	xor a
	out (#fe),a

	ld (playRow.prevHL),hl

	in a,(#1f)
	and #1f
	ld c,a
	in a,(#fe)
	cpl
.checkKempston=$
	or c
	and #1f
	jp z,nextRow

stopPlayer
.prevSP=$+1
	ld sp,0
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