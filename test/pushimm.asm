%include "test.inc"

	push ax
	push 0x1234
	push word 0x1234
	push byte -1
	push word -1
	o16 push 0x1234
	o16 push -1
	o16 push word 0x1234
	o16 push 0x1234
	pop ax

_dq	push 0x12345678

_wd	push eax
_wd	push dword 0x12345678
_wd	push dword -1
_wd	o32 push 0x12345678
_wd	o32 push -1
_wd	o32 push dword 0x12345678
_wd	o32 push dword -1
_wd	pop eax

_q	push rax
;_q	push dword 0x12345678
_q	push qword 0x12345678
_q	push qword -1
_q	pop rax
