	use32
	cpu	P3

debugdump001:
goo:	jmp	foo
;  cpu 386
	jc	near foo
	mov	ax,[si+5]
	mov	ax,[si-7]
	mov	ax,[si+n]
	align	16
;  cpu 486
	bswap	edx
;  cpu 186
	resb	10
foo:	jmp	goo
	jc	goo
	jmp	short goo
debugdump002:	push	0
n	equ	3


