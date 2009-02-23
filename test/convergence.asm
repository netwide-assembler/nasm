;Testname=O0; Arguments=-O0 -fbin -oconvergence.bin; Files=stdout stderr convergence.bin
;Testname=O1; Arguments=-O1 -fbin -oconvergence.bin; Files=stdout stderr convergence.bin
;Testname=Ox; Arguments=-Ox -fbin -oconvergence.bin; Files=stdout stderr convergence.bin

BITS 32

jmp foo
times 124 nop
foo:

jmp bar
times 125 nop
bar:

db 0

jmp baz
times 126 nop
baz:

jmp car
times 127 nop
car:

add eax, quux2 - quux1
quux1:
times 127 nop
quux2:

; currently fails - short add possible but converges to long form
corge1:
add eax, corge2 - corge1
times 124 nop
corge2:
