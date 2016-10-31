	bits 64

	extern bar

	section .data
foo:	dd bar
	dd foo - $
;	dd foo*2
	dd bar - $
