	bits 32

	pavgb mm0,[ebx]
	pavgb mm0,qword [ebx]
	pavgw mm0,[ebx]
	pavgw mm0,qword [ebx]
	pavgb xmm0,[ebx]
	pavgb xmm0,oword [ebx]
	pavgw xmm0,[ebx]
	pavgw xmm0,oword [ebx]

	bits 64

	pavgb mm0,[rbx]
	pavgb mm0,qword [rbx]
	pavgw mm0,[rbx]
	pavgw mm0,qword [rbx]
	pavgb xmm0,[rbx]
	pavgb xmm0,oword [rbx]
	pavgw xmm0,[rbx]
	pavgw xmm0,oword [rbx]

