;Testname=unoptimized; Arguments=-fbin -oriprel2.bin -O0; Files=stdout stderr riprel.bin
;Testname=optimized;   Arguments=-fbin -oriprel2.bin -Ox; Files=stdout stderr riprel.bin

	bits 64

	default rel, fs:abs, gs:rel
	mov dword [foo],12345678h
	mov qword [foo],12345678h
	mov [foo],rax

	mov dword [es:foo],12345678h
	mov qword [es:foo],12345678h
	mov [es:foo],rax

	mov dword [fs:foo],12345678h
	mov qword [fs:foo],12345678h
	mov [fs:foo],rax

	mov dword [gs:foo],12345678h
	mov qword [gs:foo],12345678h
	mov [gs:foo],rax
foo:
