	bits 32
%define bluttan 66h
foo:
	db bluttan
%warning "bluttan" = bluttan
	db 67h
        db 60000,60000
%note "bluttan" = bluttan
	nop

%macro warnalot 0.nolist
	db 60000,60000
	db 60000,60000
%endmacro

	warnalot

%macro warnalotl 0
        db 60000,60000
	db 60000,60000
%endmacro

	warnalotl
