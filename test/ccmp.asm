	bits 64

%macro cxx 1-2+
	%1 {dfv=%2} dl,sil
	%1 {dfv=%2} dx,si
	%1 {dfv=%2} edx,esi
	%1 {dfv=%2} rdx,rsi
	%1 {dfv=%2} rdx,r14
	%1 {dfv=%2} rdx,r30
	%1 {dfv=%2} cl,[rbx]
	%1 {dfv=%2} cx,[rbx]
	%1 {dfv=%2} ecx,[rbx]
	%1 {dfv=%2} rcx,[rbx]
	%1 {dfv=%2} cl, 0x10
	%1 {dfv=%2} cx, 0x10
	%1 {dfv=%2} cx, 0x1000
	%1 {dfv=%2} ecx, 0x10
	%1 {dfv=%2} ecx, 0x1000
	%1 {dfv=%2} rcx, 0x10
	%1 {dfv=%2} rcx, 0x1000
%endmacro

%macro cx 1
	cxx %1
	cxx %1,cf
	cxx %1,zf
	cxx %1,cf,zf
	cxx %1,sf
	cxx %1,sf,cf
	cxx %1,sf,zf
	cxx %1,sf,cf,zf
	cxx %1,of
	cxx %1,of,cf
	cxx %1,of,zf
	cxx %1,of,cf,zf
	cxx %1,of,sf
	cxx %1,of,sf,cf
	cxx %1,of,sf,zf
	cxx %1,of,sf,cf,zf
%endmacro

%macro c 1
	cx %{1}o
	cx %{1}no
	cx %{1}c
	cx %{1}nc
	cx %{1}z
	cx %{1}nz
	cx %{1}na
	cx %{1}a
	cx %{1}s
	cx %{1}ns
	cx %{1}f
	cx %{1}t
	cx %{1}l
	cx %{1}nl
	cx %{1}ng
	cx %{1}g
%endmacro

	c ccmp
