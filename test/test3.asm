debugdump001:
        jc	baker
	jmp	able - 20
	jmp	able
baker:	nop
	times 125 nop
able:	jmp	baker
	jmp	baker + 20
	times 122  nop
	jmp	able
loc:	nop
	jc	able+20

	jmp	able1 - 20
	jmp	able1
baker1: nop
	times 126 nop
able1:	jmp	near baker1
	jmp	baker1 + 20
	times 122  nop
	jmp	able1
loc1:	nop

able2:  jmp     baker2
        times 124 nop
        jmp     able2
	nop
baker2:	nop



able3:  jmp     baker3
        times 124 nop
        jmp     able3
	nop
	nop
baker3:	nop
debugdump099: nop






	
