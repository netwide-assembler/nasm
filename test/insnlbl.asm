;Testname=test; Arguments=-fbin -oinsnlbl.bin; Files=.stdout .stderr insnlbl.bin

;
; Test "instruction as label" -- make opcodes legal as labels if
; they are followed by a colon.
;

do:	jmp incbin+2
	dw do, add, sub, incbin
add:	jmp add-2
sub:	jmp do+2
incbin:	dw $-sub
