; test6.asm
;   assemble with;   nasm -O2 ...
;
%rep 20000
	jmp	forward
%endrep
forward:  dd	forward

	