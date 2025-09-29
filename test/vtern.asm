%use vtern

	bits 64

	vpternlogd zmm3, zmm4, zmm5, (A|b)&C
	vpternlogq zmm3, zmm4, zmm5, (a|B)&c
