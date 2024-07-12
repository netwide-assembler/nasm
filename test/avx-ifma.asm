bits 32
	cpu latevex
	vpmadd52luq	xmm0, xmm1, [eax]
	vpmadd52luq	ymm2, ymm3, [ebx]
	vpmadd52huq	xmm4, xmm5, [eax+ebx]
	vpmadd52huq	ymm6, ymm7, [eax*2]

