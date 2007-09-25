	bits 64

	mov rax,1234567890abcdefh
	mov eax,1234567890abcdefh
	mov rax,dword 1234567890abcdefh
	mov rax,qword 1234567890abcdefh
	mov dword [rsi],1234567890abcdefh
	mov qword [rsi],1234567890abcdefh
	mov dword [rsi],dword 1234567890abcdefh
	mov qword [rsi],dword 1234567890abcdefh
;	mov qword [rsi],qword 1234567890abcdefh		; Error
;	mov [rsi],qword 1234567890abcdefh		; Error
	mov [rsi],dword 1234567890abcdefh
