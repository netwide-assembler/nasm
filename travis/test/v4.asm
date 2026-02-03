	bits 64

	v4fmaddps zmm0,zmm1+3,[rax]
	v4fnmaddps zmm2,zmm3,[rax]
	v4fmaddss xmm4,xmm5+3,[rax]
	v4fnmaddss xmm6,xmm7+3,[rax]

	vp4dpwssds zmm8,zmm9,[rax]
	vp4dpwssd zmm10,zmm11+3,[rax]
	vp4dpwssd zmm10+0,zmm11+3,[rax]

%ifdef ERROR
	v4dpwssd zmm10+1,zmm11+3,[rax]
	v4dpwssd zmm10,zmm11+4,[rax]
	v4dpwssd zmm10,zmm11+7,[rax]
%endif
