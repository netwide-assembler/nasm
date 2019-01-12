%assign n 0
%rep 10000
	section .text %+ n progbits exec
	nop
%assign n n+1
%endrep
