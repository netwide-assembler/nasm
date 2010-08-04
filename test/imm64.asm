;Testname=imm64-O0; Arguments=-O0 -fbin -oimm64.bin; Files=stdout stderr imm64.bin
;Testname=imm64-O1; Arguments=-O1 -fbin -oimm64.bin; Files=stdout stderr imm64.bin
;Testname=imm64-Ox; Arguments=-Ox -fbin -oimm64.bin; Files=stdout stderr imm64.bin

	bits 64
	mov rax,11223344h
	mov rax,dword 11223344h
	mov eax,11223344h
	mov [rax],dword 11223344h		; 32-bit operation
	mov qword [rax],11223344h
	mov qword [rax],dword 11223344h
