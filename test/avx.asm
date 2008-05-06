		bits 64
		vpermil2ps	xmm0,xmm1,[rdi],xmm3,0
		times 16 nop
		vpermil2ps	xmm0,xmm1,xmm2,[rdi],1
		times 16 nop
		vpermil2ps	ymm0,ymm1,ymm2,ymm3,2
		times 16 nop
		vpermil2ps	ymm0,ymm1,ymm2,[rdi],3
		times 16 nop
		vpermil2ps	ymm0,ymm1,[rdi],ymm3,2
		times 16 nop
		vpermil2ps	ymm0,ymm1,ymm2,[rdi],3
		times 16 nop

