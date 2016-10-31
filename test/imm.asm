	bits 64

	mov eax,1
	mov eax,-1
	mov eax,0x11111111
	mov ecx,2
	add ecx,-6
	add ecx,strict dword -6
	add ecx,4
	add ecx,strict dword 4
	add ecx,10000
