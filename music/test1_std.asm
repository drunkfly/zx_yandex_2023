    device zxspectrum48

	org #c000

begin
	ld hl,musicData
	call tritone.play
    ret


	include "tritone_std.asm"

musicData
	include "nq-16k-game-1-std.asm"

end
	display /d,end-begin

	;savesna "nq-16k-game-1-std.sna",begin
    savebin "beeper-std.bin",$C000,$768
