	;; With APX disabled, APX-only encodings must be rejected
	bits 64
	cpu noapx

	;; These should error
	sub ecx, eax, ebx
	sub ecx, eax, [rel x]
	{nf} add eax, ebx
	push2 rax, rbx
	pop2 rbx, rax
	ccmpz {dfv=} eax, ebx
	cfcmovz eax, ebx
	jmpabs 0x1234
	add r16d, eax

	;; These should work
	sub ecx, eax
	shlx eax, ebx, ecx
	andn eax, ebx, ecx

x:	dd 0
