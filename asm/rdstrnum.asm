; Disassembly of file: /tmp/tmp.YqGetLLgIK.o
; Wed Sep 23 14:43:24 2026
; Type: ELF64
; Syntax: NASM
; Instruction set: 80386, x64

default rel

global readstrnum: function


SECTION .text   align=1 exec                            ; section number 1, code

readstrnum:; Function begin
        push    rbp                                     ; 0000 _ 55
        mov     rbp, rsp                                ; 0001 _ 48: 89. E5
        mov     qword [rbp-18H], rdi                    ; 0004 _ 48: 89. 7D, E8
        mov     dword [rbp-1CH], esi                    ; 0008 _ 89. 75, E4
        mov     qword [rbp-28H], rdx                    ; 000B _ 48: 89. 55, D8
        mov     qword [rbp-8H], 0                       ; 000F _ 48: C7. 45, F8, 00000000
        mov     rax, qword [rbp-28H]                    ; 0017 _ 48: 8B. 45, D8
        mov     byte [rax], 0                           ; 001B _ C6. 00, 00
        cmp     dword [rbp-1CH], 8                      ; 001E _ 83. 7D, E4, 08
        jle     ?_001                                   ; 0022 _ 7E, 0E
        mov     rax, qword [rbp-28H]                    ; 0024 _ 48: 8B. 45, D8
        mov     byte [rax], 1                           ; 0028 _ C6. 00, 01
        mov     dword [rbp-1CH], 8                      ; 002B _ C7. 45, E4, 00000008
?_001:  mov     dword [rbp-0CH], 0                      ; 0032 _ C7. 45, F4, 00000000
        jmp     ?_003                                   ; 0039 _ EB, 2C

?_002:  mov     rax, qword [rbp-18H]                    ; 003B _ 48: 8B. 45, E8
        lea     rdx, [rax+1H]                           ; 003F _ 48: 8D. 50, 01
        mov     qword [rbp-18H], rdx                    ; 0043 _ 48: 89. 55, E8
        movzx   eax, byte [rax]                         ; 0047 _ 0F B6. 00
        movzx   edx, al                                 ; 004A _ 0F B6. D0
        mov     eax, dword [rbp-0CH]                    ; 004D _ 8B. 45, F4
        shl     eax, 3                                  ; 0050 _ C1. E0, 03
        mov     ecx, eax                                ; 0053 _ 89. C1
        shl     rdx, cl                                 ; 0055 _ 48: D3. E2
        mov     rax, qword [rbp-8H]                     ; 0058 _ 48: 8B. 45, F8
        add     rax, rdx                                ; 005C _ 48: 01. D0
        mov     qword [rbp-8H], rax                     ; 005F _ 48: 89. 45, F8
        add     dword [rbp-0CH], 1                      ; 0063 _ 83. 45, F4, 01
?_003:  mov     eax, dword [rbp-0CH]                    ; 0067 _ 8B. 45, F4
        cmp     eax, dword [rbp-1CH]                    ; 006A _ 3B. 45, E4
        jl      ?_002                                   ; 006D _ 7C, CC
        mov     rax, qword [rbp-8H]                     ; 006F _ 48: 8B. 45, F8
        pop     rbp                                     ; 0073 _ 5D
        ret                                             ; 0074 _ C3
; readstrnum End of function


SECTION .data   align=1 noexec                          ; section number 2, data


SECTION .bss    align=1 noexec                          ; section number 3, bss


SECTION .note.gnu.property align=8 noexec               ; section number 4, const

        db 04H, 00H, 00H, 00H, 20H, 00H, 00H, 00H       ; 0000 _ .... ...
        db 05H, 00H, 00H, 00H, 47H, 4EH, 55H, 00H       ; 0008 _ ....GNU.
        db 02H, 00H, 01H, 0C0H, 04H, 00H, 00H, 00H      ; 0010 _ ........
        db 01H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0018 _ ........
        db 01H, 00H, 01H, 0C0H, 04H, 00H, 00H, 00H      ; 0020 _ ........
        db 01H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0028 _ ........


SECTION .eh_frame align=8 noexec                        ; section number 5, const

        db 14H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0000 _ ........
        db 01H, 7AH, 52H, 00H, 01H, 78H, 10H, 01H       ; 0008 _ .zR..x..
        db 1BH, 0CH, 07H, 08H, 90H, 01H, 00H, 00H       ; 0010 _ ........
        db 1CH, 00H, 00H, 00H, 1CH, 00H, 00H, 00H       ; 0018 _ ........
        dd readstrnum-$-20H                             ; 0020 _ 00000000 (rel)
        dd 00000075H, 100E4100H                         ; 0024 _ 117 269369600 
        dd 0D430286H, 0C700206H                         ; 002C _ 222495366 208667142 
        dd 00000807H                                    ; 0034 _ 2055 


