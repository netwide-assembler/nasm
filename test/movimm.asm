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

	; The optimizer probably should compact these forms, doesn't yet?
	mov rax,12345678h
	mov eax,12345678h
	mov rax,dword 12345678h
	mov rax,qword 12345678h
	mov dword [rsi],12345678h
	mov qword [rsi],12345678h
	mov dword [rsi],dword 12345678h
	mov qword [rsi],dword 12345678h
;	mov qword [rsi],qword 12345678h			; Error
;	mov [rsi],qword 12345678h			; Error
	mov [rsi],dword 12345678h
