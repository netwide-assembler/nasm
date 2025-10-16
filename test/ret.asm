	;; All the flavors of RET
	bits 16

	ret
	retn
	retf
	retw
	retnw
	retfw
	retd
	retnd
	retfd
	o16 ret
	o16 retn
	o16 retf
	o32 ret
	o32 retn
	o32 retf
%ifdef ERROR
	retq
	retnq
	retfq
	o64 ret
	o64 retn
	o64 retf
%endif

	bits 32

	ret
	retn
	retf
	retw
	retnw
	retfw
	retd
	retnd
	retfd
%ifdef ERROR
	retq
	retnq
	retfq
	o64 ret
	o64 retn
	o64 retf
%endif

	bits 64

	ret
	retn
	retf		; Probably should have been RETFQ, but: legacy...
	retw
	retnw
	retfw
	o16 ret
	o16 retn
	o16 retf
%ifdef ERROR
	retd
	retnd
	o32 ret
	o32 retn
%endif
	retfd
	o32 retf
	retq
	retnq
	retfq
	o64 ret
	o64 retn
	o64 retf
