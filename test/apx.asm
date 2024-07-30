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
