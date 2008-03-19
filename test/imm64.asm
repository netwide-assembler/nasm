	bits 64
	mov rax,11223344h
	mov rax,dword 11223344h
	mov eax,11223344h
	mov [rax],dword 11223344h		; 32-bit operation
	mov qword [rax],11223344h
	mov qword [rax],dword 11223344h
