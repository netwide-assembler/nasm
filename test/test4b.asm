	use32
	cpu	186

start:	jmp	able
	xor	ax,ax
	jc	start
	jnc	able
	jc	charlie
	times	100 nop
able:	jc	start
	times	100 nop
baker:	jc	start
	times	100 nop
charlie: jc	baker
	jnc	able
	jmp	start
end:	db	0
