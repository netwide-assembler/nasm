%macro pushm 1-*
%rep %0
%rotate -1
push	%1
%endrep
%endmacro

%macro popm 1-*
%rep %0
pop	%1
%rotate 1
%endrep
%endmacro

%macro pusha 0
push ax
push cx
push dx
push bx
push bp
mov bp,sp
lea bp,[bp+10]
xchg bp,[bp-10]
push bp
push si
push di
%endmacro

%macro popa 0
pop di
pop si
pop bp
pop bx
pop bx
pop dx
pop cx
pop ax
%endmacro

	pushm	ax,bx,cx,dx
	popm	ax,bx,cx,dx
	pusha
	popa
