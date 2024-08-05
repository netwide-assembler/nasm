bits 64
	cpu latevex
	vpmadd52luq	xmm0, xmm1, [rax]
	vpmadd52luq	ymm2, ymm3, [rbx]
	vpmadd52huq	xmm14, xmm5, [rax+rbx]
	vpmadd52huq	ymm12, ymm7, [rax*2]
