	segment text
	bits	16

	imul	edx,[addr],10
	imul	eax,20
	imul	edx,eax,130

	push	0x40
	push	word 0x40
	push	word 4095
	push	byte 0x40
	push	dword 0x40
	push	dword 4095

	add	ax,1
	add	bx,1
	cmp	cx,0
	sub	dx,3
	sbb	si,-1
	xor	ax,0xffff
	xor	ax,-1
	xor	bx,0xffff
	xor	bx,-1


        adc     bx,add1
        adc	bx,-7
        adc     bx,-128
        adc     bx,-129
	adc	bx,addr
        adc     bx,byte -7
add1:   adc     bx,word -7
        adc     bx,add1
	resb	256
addr:	nop
        adc     bx,addr
        adc     eax,5
	adc	eax,500
	adc	eax,byte 5
	adc	ax,4
	adc	ebx,7
	adc	ebx,700
	adc	ebx,byte 7
	adc	ecx,1
	adc	eax,1

        shr     edx,mmm
        shr     edx,one
	adc	ebx,byte mmm
m1:	adc	ebx,mmm
mmm	equ	9
m2:	adc	ebx,mmm
one     equ     1
        shr     edx,mmm
        shr     edx,one
        shr     edx,1
tend	dw	tend

	segment data
	db	'abc'
	db	'', 12, 13, 0

