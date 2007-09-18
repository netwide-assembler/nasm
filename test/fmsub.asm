	bits 64

	fmsubps xmm0,xmm0,xmm1,xmm2
	fmsubps xmm0,xmm0,xmm1,[rax]
	fmsubps xmm0,xmm0,xmm1,[rax+0x77]
	fmsubps xmm0,xmm0,xmm1,[rax+0x7777]
	fmsubps xmm1,xmm2,xmm3,xmm1
	fmsubps xmm1,xmm2,[rax],xmm1
	fmsubps xmm1,xmm2,[rax+0x77],xmm1
	fmsubps xmm1,xmm2,[rax+0x7777],xmm1
	fmsubps xmm0,[rax],xmm2,xmm0
	fmsubps xmm0,[rax+0x77],xmm2,xmm0
	fmsubps xmm0,[rax+0x7777],xmm2,xmm0
	fmsubps xmm14,[rax],xmm2,xmm14
	fmsubps xmm14,[rax+0x77],xmm2,xmm14
	fmsubps xmm14,[rax+0x7777],xmm2,xmm14
