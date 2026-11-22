	;; {vex2} on a register move whose first form needs VEX.B: the
	;; store form (ModRM.reg holds the high register) fits VEX2
	bits 64
	{vex2} vmovdqa ymm0,ymm8
	{vex2} vmovdqa xmm0,xmm8
	{vex2} vmovdqu ymm1,ymm9
	{vex2} vmovaps ymm2,ymm10
	{vex2} vmovapd xmm3,xmm11
	{vex2} vmovups ymm4,ymm12
	;; the first form already fits VEX2, and no prefix: unchanged
	{vex2} vmovdqa ymm8,ymm0
	vmovdqa ymm0,ymm8

%ifdef ERROR
	;; no form fits VEX2: the same error as before
	{vex2} vmovdqa ymm8,ymm9
	{vex2} vmovdqa ymm0,[r8]
	{vex2} vpaddb ymm0,ymm1,ymm8
%endif
