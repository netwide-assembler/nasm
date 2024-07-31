	bits 64
start:
	jmp [rel .next]
.next:
	dq hello

	align 16
	jmp abs hello
	jmpabs hello
	jmp abs qword hello
	jmpabs qword hello

	align 16
hello:
	nop
