		bits 64
		vpermil2ps	xmm0,xmm1,[rdi],xmm3,0
		vpermil2ps	xmm0,xmm1,xmm2,[rdi],1
		vpermil2ps	ymm0,ymm1,ymm2,ymm3,2
		vpermil2ps	ymm0,ymm1,ymm2,[rdi],3
		vpermil2ps	ymm0,ymm1,[rdi],ymm3,2
		vpermil2ps	ymm0,ymm1,ymm2,[rdi],3
