	bits 64

%macro amx 3
  %define treg tmm %+ %1
  %define treg2 tmm %+ %2
  %define treg3 tmm %+ %3

	ldtilecfg [rsi]
	sttilecfg [rdi]

	tilezero treg

	tileloadd treg, [rax]
	tileloadd treg, [rax,rdx]
	tileloadd treg, [rax,rdx*2]

	tileloaddt1 treg, [rax]
	tileloaddt1 treg, [rax,rdx]
	tileloaddt1 treg, [rax,rdx*2]

	tdpbf16ps treg, treg2, treg3
	tdpbssd treg, treg2, treg3
	tdpbusd treg, treg2, treg3
	tdpbsud treg, treg2, treg3
	tdpbuud treg, treg2, treg3
	tdpfp16ps treg, treg2, treg3
	tcmmimfp16ps treg, treg2, treg3
	tcmmrlfp16ps treg, treg2, treg3

	tilestored [rax], treg
	tilestored [rax,rdx], treg
	tilestored [rax,rdx*2], treg

	tilerelease
%endmacro

%assign n 0
%assign m 1
%assign l 2
  %rep 8
	amx n, m, l
    %assign n ((n+1) % 8)
    %assign m ((m+1) % 8)
    %assign l ((l+1) % 8)
  %endrep
