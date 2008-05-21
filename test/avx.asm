		bits 64
		vblendvpd	xmm2,xmm1,xmm0,xmm0
		vblendvpd	xmm2,xmm1,xmm0
		vblendvpd	ymm2,ymm1,ymm0,ymm0
		vblendvpd	ymm2,ymm1,ymm0

		vcvtsi2sd	xmm9,xmm10,ecx
		vcvtsi2sd	xmm9,xmm10,rcx
		vcvtsi2sd	xmm9,xmm10,dword [rdi]
		vcvtsi2sd	xmm9,xmm10,qword [rdi] 

		vpermil2ps	xmm0,xmm1,[rdi],xmm3,0
		vpermil2ps	xmm0,xmm1,xmm2,[rdi],1
		vpermil2ps	ymm0,ymm1,ymm2,ymm3,2
		vpermil2ps	ymm0,ymm1,ymm2,[rdi],3
		vpermil2ps	ymm0,ymm1,[rdi],ymm3,2
		vpermil2ps	ymm0,ymm1,ymm2,[rdi],3
