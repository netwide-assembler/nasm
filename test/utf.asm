;Testname=test;  Arguments=-fbin -outf.bin;         Files=stdout stderr utf.bin
;Testname=error; Arguments=-fbin -outf.bin -DERROR; Files=stdout stderr utf.bin
%define u(x) __utf16__(x)
%define w(x) __utf32__(x)

	db `Test \u306a\U0001abcd\n`
	dw u(`Test \u306a\U0001abcd\n`)
	dd w(`Test \u306a\U0001abcd\n`)

	db `\u306a`
	db `\xe3\x81\xaa`

	dw __utf16__ "Hello, World!"

	nop

	mov ax,u(`a`)
	mov bx,u(`\u306a`)
	mov cx,u(`\xe3\x81\xaa`)
	mov eax,u(`ab`)
	mov ebx,u(`\U0001abcd`)
	mov ecx,w(`\U0001abcd`)

%ifdef ERROR
	dw __utf16__ 33
	dw __utf16__, 46
	dw __utf16__("Hello, World!",16)
	dw __utf16__("Hello, World!",16
	dw u(`\xff`)
%endif
