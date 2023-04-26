    device zxspectrum48

	org #c000

begin
	ld hl,musicData
	call tritone.play
    ret


	include "tritone_new.asm"

musicData
	include "nq-16k-game-1-new.asm"

end
	display /d,end-begin

	;savesna "nq-16k-game-1-new.sna",begin
    savebin "beeper-new.bin",$C000,$758
