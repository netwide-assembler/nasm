	bits 64
	ccmpnz {dfv=} rax,rbx
	ccmpnz {dfv=cf} rax,rbx
	ccmpnz {dfv=zf} rax,rbx
	ccmpnz {dfv=sf} rax,rbx
	ccmpnz {dfv=of} rax,rbx
	ccmpnz {dfv=of,cf} rax,rbx
	ccmpnz {dfv=of,cf} [rax],rbx
	ccmpnz {dfv=of,cf} dword [rax],3
	ccmpnz {dfv=of,cf} dword [r31],3
	ccmpnz 15, dword [r31], 3

	ccmpnz {dfv=of,cf} dword [r31], byte 3
	ccmpnz {dfv=of,cf} dword [r31], 3
	ccmpnz {dfv=of,cf} dword [r31], dword 3
	ccmpnz {dfv=of,cf} dword [r31], strict dword 3
	ccmpnz {dfv=of,cf} dword [r31], 0xaabbccdd
	ccmpnz {dfv=of,cf} dword [r31], dword 0xaabbccdd
	ccmpnz {dfv=of,cf} qword [r31], 0xaabbccdd

	push rax
	pushp rax
	push rax, rbx
	push rax:rbx

	pop rax:rbx
	pop rbx, rax

	add      al,[rdx],cl
	add {nf} al,[rdx],cl
	add      [rdx],cl
	add {evex} [rdx],cl
	add {nf} [rdx],cl

	add      al,[rdx],r25b
	add {nf} al,[rdx],r25b
	add      [rdx],r25b
	add {evex} [rdx],r25b
	add {nf} [rdx],r25b

	add      al,[r27],cl
	add {nf} al,[r27],cl
	add      [r27],cl
	add {evex} [r27],cl
	add {nf} [r27],cl

	add      al,[r27],r25b
	add {nf} al,[r27],r25b
	add      [r27],r25b
	add {evex} [r27],r25b
	add {nf} [r27],r25b

	add      eax,[rdx],ecx
	add {nf} eax,[rdx],ecx
	add      [rdx],ecx
	add {evex} [rdx],ecx
	add {nf} [rdx],ecx

	add      eax,[rdx],r25d
	add {nf} eax,[rdx],r25d
	add      [rdx],r25d
	add {evex} [rdx],r25d
	add {nf} [rdx],r25d

	add      eax,[r27],ecx
	add {nf} eax,[r27],ecx
	add      [r27],ecx
	add {evex} [r27],ecx
	add {nf} [r27],ecx

	add      eax,[r27],r25d
	add {nf} eax,[r27],r25d
	add      [r27],r25d
	add {evex} [r27],r25d
	add {nf} [r27],r25d
