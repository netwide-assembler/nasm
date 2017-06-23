	bits 64
	default rel

	section .bss
bar:	resd 0

	section .rodata
rod1:	dd 0x01234567
rod2:	dd 0x89abcdef

	section .text
start:
	lea rax, [rod1]
	lea rcx, [rod2]
	lea rdx, [bar]
	lea rbx, [foo]
	
	lea rax, [rax+rod1-$$]
	lea rcx, [rax+rod2-$$]
	lea rdx, [rax+bar-$$]
	lea rbx, [rax+foo-$$]
	
	mov rax, [rax+rod1-$$]
	mov rcx, [rax+rod2-$$]
	mov rdx, [rax+bar-$$]
	mov rbx, [rax+foo-$$]

	mov rax, dword rod1-$$
	mov rcx, dword rod2-$$
	mov rdx, dword bar-$$
	mov rbx, dword foo-$$
	
	section .data
	dq rod1
	dq rod2
	dq bar
	dq foo
foo:
	dd rod1 - $
	dd rod1 - $$
	dd rod2 - $
	dd rod2 - $$
	dd bar - $
	dd bar - $$
	dd foo - $
	dd foo - $$
