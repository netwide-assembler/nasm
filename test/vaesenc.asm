;; BR 3392454

	bits 64
	aesenc xmm0,xmm4
	vaesenc zmm0,zmm0,zmm4
	vpclmullqlqdq zmm1,zmm1,zmm5
