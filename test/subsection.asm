;
; subsection.asm
;
; Test of Mach-O subsection_by_symbol
;

%pragma output subsections_via_symbols
%pragma asm gprefix _
%pragma asm lprefix L_

	bits 32

	global foo, bar
	static quux

foo:
	jmp foo
	jmp bar
	jmp baz
	jmp quux

bar:
	jmp foo
	jmp bar
	jmp baz
	jmp quux

baz:
	jmp foo
	jmp bar
	jmp baz
	jmp quux

quux:
	jmp foo
	jmp bar
	jmp baz
	jmp quux
