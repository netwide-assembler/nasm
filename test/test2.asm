	USE16
	CPU	386

debugdump001:
goo:	jmp	foo
	jc	near foo
	mov	ax,[si+5]
	mov	ax,[si-7]
	mov	ax,[si+n]
	nop
	resb	10
foo:	jmp	goo
	jc	goo
	jmp	short goo
debugdump002:	push	0
n	equ	3


