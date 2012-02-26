	bits 32

	xacquire lock add [esi],eax
	xacquire xchg [eax],ebx
	xrelease lock mov [eax],ecx
	xrelease mov [eax],ecx
	xacquire add ecx,[eax]
	xrelease mov [eax],ecx

	; Different opcodes!
	mov [sym],eax
	xrelease mov [sym],eax
	xacquire mov [sym],eax

sym	dd 0
