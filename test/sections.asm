	bits 16

	section s_start exec
s_start	equ seg $$
	global _start
_start:
	nop
	nop
	nop
	nop
	ret
	
	section s_foo exec
s_foo	equ seg $$
	hlt
	hlt
	hlt
wibble:
	hlt
	hlt
	hlt
	hlt
	
	global g_bar, g_anear, g_afar
	extern e_meep, e_note, e_note~b
g_bar:	add eax,edx
	add eax,[g_bar]
	add eax,[g_bar wrt s_start]
	add eax,[g_bar wrt s_foo]
	mov ax,seg e_note~b
	mov es,ax
	add eax,[es:e_note]
	add eax,[es:e_note wrt seg e_note~b]
	
	jmp s_foo:g_bar
	jmp s_start:_start
	jmp e_meep
	jmp far e_meep

	sub eax,[e_note wrt 0]

g_anear	equ 3333h
g_afar	equ 4444h:5555h
g_meh	equ g_bar

	dw e_meep, seg e_meep
	dw e_note, seg e_note
	dw g_afar, seg g_afar
