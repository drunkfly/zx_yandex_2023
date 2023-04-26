    device zxspectrum48

	org #8000

begin
	ld hl,musicData
	call tritone.play
	jr $


	include "tritone_std.asm"

musicData
	include "nq-16k-game-1-std.asm"

end
	display /d,end-begin

	savesna "nq-16k-game-1-std.sna",begin
