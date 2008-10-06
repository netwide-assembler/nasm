;Testname=onowarn; Arguments=-Ox -DOPT=1 -DWARN=0 -fbin -oimmwarn.bin; Files=.stdout .stderr immwarn.bin
;Testname=owarn; Arguments=-Ox -DOPT=1 -DWARN=1 -fbin -oimmwarn.bin; Files=.stdout .stderr immwarn.bin
;Testname=nowarn; Arguments=-O0 -DOPT=0 -DWARN=0 -fbin -oimmwarn.bin; Files=.stdout .stderr immwarn.bin
;Testname=warn; Arguments=-O0 -DOPT=1 -DWARN=1 -fbin -oimmwarn.bin; Files=.stdout .stderr immwarn.bin

%ifndef WARN
  %define WARN 1
%endif

	bits 16
	push 1
%if WARN
	push 0ffffffffh
%endif
	push -1
	push 0ffffh

	add ax,0FFFFh
%if WARN
	add ax,0FFFFFFFFh
%endif
	add ax,-1

	bits 32
	push 1
	push 0ffffffffh
	push -1
	push 0ffffh

	push byte 1
%if WARN
	push byte 0ffffffffh
%endif
	push byte -1

	push word 1
	push word 0ffffh
	push word -1

	push dword 1
	push dword 0ffffffffh
	push dword -1

	add eax,0FFFFh
	add eax,0FFFFFFFFh
	add eax,-1

	bits 64
	mov rax,7fffffffh
	mov rax,80000000h
;	mov rax,dword 80000000h
	add rax,0FFFFh
	add rax,0FFFFFFFFh
	add rax,-1
