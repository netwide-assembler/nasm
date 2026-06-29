;Testname=test; Arguments=-fbin -ofpu.bin; Files=stdout stderr fpu.bin

; relaxed encodings for FPU instructions, which NASM should support
; -----------------------------------------------------------------

%define void
%define reg_fpu0 st0
%define reg_fpu st1

%macro src 2
	%1	%2
	%1	reg_fpu0,%2
%endmacro
%macro dst 2
	%1	to %2
	%1	%2,reg_fpu0
%endmacro
%macro dsp 2
	%1	%2
	%1	%2,reg_fpu0
	%1
%endmacro

; no operands instead of one operand:

  ; F(U)COM(P), FCOM2, FCOMP3, FCOMP5

    FCOM            void
    FCOMP           void
    FUCOM           void
    FUCOMP          void
;    FCOM2           void
;    FCOMP3          void
;    FCOMP5          void

  ; FLD, FST, FSTP, FSTP1, FSTP8, FSTP9

    FLD             void
    FST             void
    FSTP            void
;    FSTP1           void
;    FSTP8           void
;    FSTP9           void

  ; FXCH, FXCH4, FXCH7, FFREE, FFREEP

    FXCH            void
;    FXCH4           void
;    FXCH7           void
    FFREE           void
    FFREEP          void

; no operands instead of two operands:

  ; FADD(P), FMUL(P), FSUBR(P), FSUB(P), FDIVR(P), FDIV(P)

    FADD            void
    FADDP           void
    FMUL            void
    FMULP           void
    FSUBR           void
    FSUBRP          void
    FSUB            void
    FSUBP           void
    FDIVR           void
    FDIVRP          void
    FDIV            void
    FDIVP           void

; one operand instead of two operands:

  ; FADD, FMUL, FSUB, FSUBR, FDIV, FDIVR

src    FADD            , reg_fpu
src    FMUL            , reg_fpu
src    FSUB            , reg_fpu
src    FSUBR           , reg_fpu
src    FDIV            , reg_fpu
src    FDIVR           , reg_fpu

  ; FADD, FMUL, FSUBR, FSUB, FDIVR, FDIV (with TO qualifier)

dst    FADD            , reg_fpu
dst    FMUL            , reg_fpu
dst    FSUBR           , reg_fpu
dst    FSUB            , reg_fpu
dst    FDIVR           , reg_fpu
dst    FDIV            , reg_fpu

  ; FADDP, FMULP, FSUBRP, FSUBP, FDIVRP, FDIVP

dsp FADDP           , reg_fpu
dsp FMULP           , reg_fpu
dsp FSUBRP          , reg_fpu
dsp FSUBP           , reg_fpu
dsp FDIVRP          , reg_fpu
dsp FDIVP           , reg_fpu

  ; FCMOV(N)B, FCMOV(N)E, FCMOV(N)BE, FCMOV(N)U, and F(U)COMI(P)

src FCMOVB          , reg_fpu
src FCMOVNB         , reg_fpu
src FCMOVE          , reg_fpu
src FCMOVNE         , reg_fpu
src FCMOVBE         , reg_fpu
src FCMOVNBE        , reg_fpu
src FCMOVU          , reg_fpu
src FCMOVNU         , reg_fpu
src FCOMI           , reg_fpu
src FCOMIP          , reg_fpu
src FUCOMI          , reg_fpu
src FUCOMIP         , reg_fpu

; two operands instead of one operand:

  ; these don't really exist, and thus are _NOT_ supported:

;   FCOM            reg_fpu,reg_fpu0
;   FCOM            reg_fpu0,reg_fpu
;   FUCOM           reg_fpu,reg_fpu0
;   FUCOM           reg_fpu0,reg_fpu
;   FCOMP           reg_fpu,reg_fpu0
;   FCOMP           reg_fpu0,reg_fpu
;   FUCOMP          reg_fpu,reg_fpu0
;   FUCOMP          reg_fpu0,reg_fpu

;   FCOM2           reg_fpu,reg_fpu0
;   FCOM2           reg_fpu0,reg_fpu
;   FCOMP3          reg_fpu,reg_fpu0
;   FCOMP3          reg_fpu0,reg_fpu
;   FCOMP5          reg_fpu,reg_fpu0
;   FCOMP5          reg_fpu0,reg_fpu

;   FXCH            reg_fpu,reg_fpu0
;   FXCH            reg_fpu0,reg_fpu
;   FXCH4           reg_fpu,reg_fpu0
;   FXCH4           reg_fpu0,reg_fpu
;   FXCH7           reg_fpu,reg_fpu0
;   FXCH7           reg_fpu0,reg_fpu

; EOF
