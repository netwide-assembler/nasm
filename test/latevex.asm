	bits 64

%define YMMWORD yword
	
	vpmadd52luq	ymm3,ymm1,YMMWORD[rsi]
	vpmadd52luq	ymm16,ymm1,YMMWORD[32+rsi]
	vpmadd52luq	ymm17,ymm1,YMMWORD[64+rsi]
	vpmadd52luq	ymm18,ymm1,YMMWORD[96+rsi]
	vpmadd52luq	ymm19,ymm1,YMMWORD[128+rsi]

	vpmadd52luq	ymm3,ymm2,YMMWORD[rcx]
	vpmadd52luq	ymm16,ymm2,YMMWORD[32+rcx]
	vpmadd52luq	ymm17,ymm2,YMMWORD[64+rcx]
	vpmadd52luq	ymm18,ymm2,YMMWORD[96+rcx]
	vpmadd52luq	ymm19,ymm2,YMMWORD[128+rcx]

 {vex}	vpmadd52luq	ymm3,ymm1,YMMWORD[rsi]
 {vex}	vpmadd52luq	ymm3,ymm2,YMMWORD[rcx]

	cpu latevex

	vpmadd52luq	ymm3,ymm1,YMMWORD[rsi]
	vpmadd52luq	ymm16,ymm1,YMMWORD[32+rsi]
	vpmadd52luq	ymm17,ymm1,YMMWORD[64+rsi]
	vpmadd52luq	ymm18,ymm1,YMMWORD[96+rsi]
	vpmadd52luq	ymm19,ymm1,YMMWORD[128+rsi]

	vpmadd52luq	ymm3,ymm2,YMMWORD[rcx]
	vpmadd52luq	ymm16,ymm2,YMMWORD[32+rcx]
	vpmadd52luq	ymm17,ymm2,YMMWORD[64+rcx]
	vpmadd52luq	ymm18,ymm2,YMMWORD[96+rcx]
	vpmadd52luq	ymm19,ymm2,YMMWORD[128+rcx]
	
