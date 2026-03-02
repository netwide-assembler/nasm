;;;
;;; Some common macros for tests
;;;

%ifndef _TEST_INC

%ifndef BITS
 %xdefine BITS __BITS__
%endif

	bits BITS

%assign w __BITS__ == 16
%assign d __BITS__ == 32
%assign q __BITS__ == 64

%macro _err 1+.nolist
 %ifdef ERROR
	%1
 %endif
%endmacro

%macro _ok 2+.nolist
 %if %1
	%2
 %elifdef ERROR
	%2
 %endif
%endmacro

%macro _w 1+.nolist
	_ok w,%1
%endmacro
%macro _d 1+.nolist
	_ok d,%1
%endmacro
%macro _q 1+.nolist
	_ok q,%1
%endmacro
%macro _wd 1+.nolist
	_ok w|d,%1
%endmacro
%macro _dq 1+.nolist
	_ok d|q,%1
%endmacro
%macro _wq 1+.nolist
	_ok w|q,%1
%endmacro

%endif
