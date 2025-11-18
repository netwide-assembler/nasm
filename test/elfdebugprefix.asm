;Testname=unoptimized; Arguments=-O0 --debug-prefix-map elf=ELF -felf -oelfdebugprefix.o; Files=stdout stderr elfdebugprefix.o; Validate=readelf --wide --symbols elfdebugprefix.o | grep 'FILE.*ELFdebugprefix.asm'

	  SECTION .text
test:			; [1]
	  ret

