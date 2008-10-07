;Testname=test; Arguments=-fbin -ojmp64.bin; Files=stdout stderr jmp64.bin

	bits 64
	jmp rcx
	jmp [rax]
	jmp qword [rax]
	jmp far [rax]
	jmp far dword [rax]
	jmp far qword [rax]
	call rcx
	call [rax]
	call qword [rax]
	call far [rax]
	call far dword [rax]
	call far qword [rax]
