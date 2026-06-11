; Regression test: forward jcc/jmp self-shrink in jmp_match.
;
; Without the self-shrink-aware rel8 check, NASM keeps `jmp B` at
; offset 0x1d9 as a 5-byte near jump (e9 7f 00 00 00). With the fix it
; emits a 2-byte short jump (eb 7f, rel8 = 127), saving 3 bytes.
; Total binary: 605 bytes stock vs 602 bytes patched.

bits 32
        times 43 jmp A
        times 256 db 0
        je A
A:
        jmp B
        times 127 db 0
B:
