***************
*** 26,32 ****
  
  	  jmp start		; [6]
  
- end	  mov ax,0x4c00		; [1]
  	  int 0x21
  
  start	  mov byte [bss_sym],',' ; [1] [8]
--- 26,32 ----
  
  	  jmp start		; [6]
  
+ endX	  mov ax,0x4c00		; [1]
  	  int 0x21
  
  start	  mov byte [bss_sym],',' ; [1] [8]
***************
*** 49,55 ****
  datasym	  db 'hello  world', 13, 10, '$' ; [2]
  bssptr	  dw bss_sym		; [2] [11]
  dataptr	  dw datasym+5		; [2] [10]
- textptr	  dw end		; [2] [9]
  
  	  SECTION .bss
  
--- 49,55 ----
  datasym	  db 'hello  world', 13, 10, '$' ; [2]
  bssptr	  dw bss_sym		; [2] [11]
  dataptr	  dw datasym+5		; [2] [10]
+ textptr	  dw endX		; [2] [9]
  
  	  SECTION .bss
  
