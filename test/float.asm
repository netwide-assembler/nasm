;
; Test of floating-point formats
;

; 16-bit
	dw 1.0
	dw +1.0
	dw -1.0
	dw 1.5
	dw +1.5
	dw -1.5
	dw 0.0
	dw +0.0
	dw -0.0
	dw 1.83203125
	dw +1.83203125
	dw -1.83203125
	dw 1.83203125e3
	dw +1.83203125e3
	dw -1.83203125e3
	dw 1.83203125e-3
	dw +1.83203125e-3
	dw -1.83203125e-3
	dw 1.83203125e-6		; Denormal!
	dw +1.83203125e-6		; Denormal!
	dw -1.83203125e-6		; Denormal!
	dw __Infinity__
	dw +__Infinity__
	dw -__Infinity__
	dw __NaN__
	dw __QNaN__
	dw __SNaN__

; 32-bit
	dd 1.0
	dd +1.0
	dd -1.0
	dd 1.5
	dd +1.5
	dd -1.5
	dd 0.0
	dd +0.0
	dd -0.0
	dd 1.83203125
	dd +1.83203125
	dd -1.83203125
	dd 1.83203125e15
	dd +1.83203125e15
	dd -1.83203125e15
	dd 1.83203125e-15
	dd +1.83203125e-15
	dd -1.83203125e-15
	dd 1.83203125e-40		; Denormal!
	dd +1.83203125e-40		; Denormal!
	dd -1.83203125e-40		; Denormal!
	dd __Infinity__
	dd +__Infinity__
	dd -__Infinity__
	dd __NaN__
	dd __QNaN__
	dd __SNaN__

; 64-bit
	dq 1.0
	dq +1.0
	dq -1.0
	dq 1.5
	dq +1.5
	dq -1.5
	dq 0.0
	dq +0.0
	dq -0.0
	dq 1.83203125
	dq +1.83203125
	dq -1.83203125
	dq 1.83203125e300
	dq +1.83203125e300
	dq -1.83203125e300
	dq 1.83203125e-300
	dq +1.83203125e-300
	dq -1.83203125e-300
	dq 1.83203125e-320		; Denormal!
	dq +1.83203125e-320		; Denormal!
	dq -1.83203125e-320		; Denormal!
	dq __Infinity__
	dq +__Infinity__
	dq -__Infinity__
	dq __NaN__
	dq __QNaN__
	dq __SNaN__

; 80-bit
	dt 1.0
	dt +1.0
	dt -1.0
	dt 1.5
	dt +1.5
	dt -1.5
	dt 0.0
	dt +0.0
	dt -0.0
	dt 1.83203125
	dt +1.83203125
	dt -1.83203125
	dt 1.83203125e+4000
	dt +1.83203125e+4000
	dt -1.83203125e+4000
	dt 1.83203125e-4000
	dt +1.83203125e-4000
	dt -1.83203125e-4000
	dt 1.83203125e-4940		; Denormal!
	dt +1.83203125e-4940		; Denormal!
	dt -1.83203125e-4940		; Denormal!
	dt __Infinity__
	dt +__Infinity__
	dt -__Infinity__
	dt __NaN__
	dt __QNaN__
	dt __SNaN__

; 128-bit
	do 1.0
	do +1.0
	do -1.0
	do 1.5
	do +1.5
	do -1.5
	do 0.0
	do +0.0
	do -0.0
	do 1.83203125
	do +1.83203125
	do -1.83203125
	do 1.83203125e+4000
	do +1.83203125e+4000
	do -1.83203125e+4000
	do 1.83203125e-4000
	do +1.83203125e-4000
	do -1.83203125e-4000
	do 1.83203125e-4940		; Denormal!
	do +1.83203125e-4940		; Denormal!
	do -1.83203125e-4940		; Denormal!
	do __Infinity__
	do +__Infinity__
	do -__Infinity__
	do __NaN__
	do __QNaN__
	do __SNaN__
