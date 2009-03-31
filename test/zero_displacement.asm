;Testname=O0; Arguments=-O0 -fbin -ozero_displacement.bin; Files=stdout stderr zero_displacement.bin
;Testname=OL; Arguments=-OL -fbin -ozero_displacement.bin; Files=stdout stderr zero_displacement.bin
;Testname=O1; Arguments=-O1 -fbin -ozero_displacement.bin; Files=stdout stderr zero_displacement.bin
;Testname=Ox; Arguments=-Ox -fbin -ozero_displacement.bin; Files=stdout stderr zero_displacement.bin

bits 16

mov ax, [bx]
mov ax, [bx+0]

mov ax, [bx+di]
mov ax, [bx+di+0]

mov ax, [bp]
mov ax, [bp+0]

bits 32

mov eax, [eax]
mov eax, [eax+0]

mov eax, [eax+ebx]
mov eax, [eax+ebx+0]

mov eax, [ebp]
mov eax, [ebp+0]

bits 64

mov eax, [rax]
mov eax, [rax+0]

mov eax, [rax+rbx]
mov eax, [rax+rbx+0]

mov eax, [rbp]
mov eax, [rbp+0]
