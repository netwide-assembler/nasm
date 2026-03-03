%macro error 1+
 %ifdef ERROR
  %1
 %endif
%endmacro

	add edx,-1
	add edx,byte -1
	add edx,dword -1


error	add [ebx],-1
	add [edx],byte -1
	add [edx],dword -1

	add byte [ebx],-1
	add byte [edx],byte -1
error	add byte [edx],dword -1

	add dword [ebx],-1
	add dword [edx],byte -1
	add dword [edx],dword -1
