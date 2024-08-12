	bits 64
baz:
	nop
bar:
	times 128 jmp baz

	ret
