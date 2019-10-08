%macro testrep 0.nolist
  %assign i 1
  %rep 4
    mov eax,i
    %if i==3
      %exitrep
    %endif
    mov ebx,i
    %if i >= 3
	%error iteration i should not be seen
    %endif
    %assign i i+1
  %endrep
%endmacro

testrep
