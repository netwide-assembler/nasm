;Testname=preproc; Arguments=-E; Files=stdout stderr
;Testname=bin; Arguments=-fbin -oweirdpaste.bin; Files=stdout stderr weirdpaste.bin

	%define foo xyzzy
%define bar 1e+10

%define xyzzy1e 15

%macro dx 2
%assign	xx %1%2
	dw xx
%endmacro

	dx foo, bar
