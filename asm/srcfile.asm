; Disassembly of file: /tmp/tmp.kIykWta8fc.o
; Wed Sep 23 14:43:25 2026
; Type: ELF64
; Syntax: NASM
; Instruction set: 8086, x64

default rel

global src_init: function
global src_free: function
global src_set_fname: function
global src_set: function
global src_macro_push: function
global src_macro_pop: function
global _src_top
global _src_bottom
global _src_error

extern nasm_free                                        ; near
extern nasm_zalloc                                      ; near
extern __stack_chk_fail                                 ; near
extern hash_add                                         ; near
extern nasm_strdup                                      ; near
extern hash_find                                        ; near
extern hash_free_all                                    ; near


SECTION .text   align=1 exec                            ; section number 1, code

src_set_linnum:; Local function
        push    rbp                                     ; 0000 _ 55
        mov     rbp, rsp                                ; 0001 _ 48: 89. E5
        mov     dword [rbp-14H], edi                    ; 0004 _ 89. 7D, EC
        mov     rax, qword [rel _src_bottom]            ; 0007 _ 48: 8B. 05, 00000000(rel)
        mov     eax, dword [rax+8H]                     ; 000E _ 8B. 40, 08
        mov     dword [rbp-4H], eax                     ; 0011 _ 89. 45, FC
        mov     rax, qword [rel _src_bottom]            ; 0014 _ 48: 8B. 05, 00000000(rel)
        mov     edx, dword [rbp-14H]                    ; 001B _ 8B. 55, EC
        mov     dword [rax+8H], edx                     ; 001E _ 89. 50, 08
        mov     eax, dword [rbp-4H]                     ; 0021 _ 8B. 45, FC
        pop     rbp                                     ; 0024 _ 5D
        ret                                             ; 0025 _ C3

src_init:; Function begin
        push    rbp                                     ; 0026 _ 55
        mov     rbp, rsp                                ; 0027 _ 48: 89. E5
        nop                                             ; 002A _ 90
        pop     rbp                                     ; 002B _ 5D
        ret                                             ; 002C _ C3
; src_init End of function

src_free:; Function begin
        push    rbp                                     ; 002D _ 55
        mov     rbp, rsp                                ; 002E _ 48: 89. E5
        lea     rax, [rel filename_hash]                ; 0031 _ 48: 8D. 05, 00000000(rel)
        mov     esi, 0                                  ; 0038 _ BE, 00000000
        mov     rdi, rax                                ; 003D _ 48: 89. C7
        call    hash_free_all                           ; 0040 _ E8, 00000000(PLT r)
        nop                                             ; 0045 _ 90
        pop     rbp                                     ; 0046 _ 5D
        ret                                             ; 0047 _ C3
; src_free End of function

src_set_fname:; Function begin
        push    rbp                                     ; 0048 _ 55
        mov     rbp, rsp                                ; 0049 _ 48: 89. E5
        sub     rsp, 96                                 ; 004C _ 48: 83. EC, 60
        mov     qword [rbp-58H], rdi                    ; 0050 _ 48: 89. 7D, A8
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        mov     rax, qword [fs:abs 28H]                 ; 0054 _ 64 48: 8B. 04 25, 00000028
        mov     qword [rbp-8H], rax                     ; 005D _ 48: 89. 45, F8
        xor     eax, eax                                ; 0061 _ 31. C0
        cmp     qword [rbp-58H], 0                      ; 0063 _ 48: 83. 7D, A8, 00
        jz      ?_002                                   ; 0068 _ 74, 59
        lea     rdx, [rbp-40H]                          ; 006A _ 48: 8D. 55, C0
        mov     rax, qword [rbp-58H]                    ; 006E _ 48: 8B. 45, A8
        lea     rcx, [rel filename_hash]                ; 0072 _ 48: 8D. 0D, 00000000(rel)
        mov     rsi, rax                                ; 0079 _ 48: 89. C6
        mov     rdi, rcx                                ; 007C _ 48: 89. CF
        call    hash_find                               ; 007F _ E8, 00000000(PLT r)
        mov     qword [rbp-50H], rax                    ; 0084 _ 48: 89. 45, B0
        cmp     qword [rbp-50H], 0                      ; 0088 _ 48: 83. 7D, B0, 00
        jz      ?_001                                   ; 008D _ 74, 0D
        mov     rax, qword [rbp-50H]                    ; 008F _ 48: 8B. 45, B0
        mov     rax, qword [rax]                        ; 0093 _ 48: 8B. 00
        mov     qword [rbp-58H], rax                    ; 0096 _ 48: 89. 45, A8
        jmp     ?_002                                   ; 009A _ EB, 27

?_001:  mov     rax, qword [rbp-58H]                    ; 009C _ 48: 8B. 45, A8
        mov     rdi, rax                                ; 00A0 _ 48: 89. C7
        call    nasm_strdup                             ; 00A3 _ E8, 00000000(PLT r)
        mov     qword [rbp-58H], rax                    ; 00A8 _ 48: 89. 45, A8
        mov     rdx, qword [rbp-58H]                    ; 00AC _ 48: 8B. 55, A8
        mov     rcx, qword [rbp-58H]                    ; 00B0 _ 48: 8B. 4D, A8
        lea     rax, [rbp-40H]                          ; 00B4 _ 48: 8D. 45, C0
        mov     rsi, rcx                                ; 00B8 _ 48: 89. CE
        mov     rdi, rax                                ; 00BB _ 48: 89. C7
        call    hash_add                                ; 00BE _ E8, 00000000(PLT r)
?_002:  mov     rax, qword [rel _src_bottom]            ; 00C3 _ 48: 8B. 05, 00000000(rel)
        mov     rax, qword [rax]                        ; 00CA _ 48: 8B. 00
        mov     qword [rbp-48H], rax                    ; 00CD _ 48: 89. 45, B8
        mov     rax, qword [rel _src_bottom]            ; 00D1 _ 48: 8B. 05, 00000000(rel)
        mov     rdx, qword [rbp-58H]                    ; 00D8 _ 48: 8B. 55, A8
        mov     qword [rax], rdx                        ; 00DC _ 48: 89. 10
        mov     rax, qword [rbp-48H]                    ; 00DF _ 48: 8B. 45, B8
        mov     rdx, qword [rbp-8H]                     ; 00E3 _ 48: 8B. 55, F8
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        sub     rdx, qword [fs:abs 28H]                 ; 00E7 _ 64 48: 2B. 14 25, 00000028
        jz      ?_003                                   ; 00F0 _ 74, 05
        call    __stack_chk_fail                        ; 00F2 _ E8, 00000000(PLT r)
?_003:  leave                                           ; 00F7 _ C9
        ret                                             ; 00F8 _ C3
; src_set_fname End of function

src_set:; Function begin
        push    rbp                                     ; 00F9 _ 55
        mov     rbp, rsp                                ; 00FA _ 48: 89. E5
        sub     rsp, 16                                 ; 00FD _ 48: 83. EC, 10
        mov     dword [rbp-4H], edi                     ; 0101 _ 89. 7D, FC
        mov     qword [rbp-10H], rsi                    ; 0104 _ 48: 89. 75, F0
        mov     rax, qword [rbp-10H]                    ; 0108 _ 48: 8B. 45, F0
        mov     rdi, rax                                ; 010C _ 48: 89. C7
        call    src_set_fname                           ; 010F _ E8, 00000000(PLT r)
        mov     eax, dword [rbp-4H]                     ; 0114 _ 8B. 45, FC
        mov     edi, eax                                ; 0117 _ 89. C7
        call    src_set_linnum                          ; 0119 _ E8, FFFFFEE2
        nop                                             ; 011E _ 90
        leave                                           ; 011F _ C9
        ret                                             ; 0120 _ C3
; src_set End of function

src_macro_push:; Function begin
        push    rbp                                     ; 0121 _ 55
        mov     rbp, rsp                                ; 0122 _ 48: 89. E5
        sub     rsp, 48                                 ; 0125 _ 48: 83. EC, 30
        mov     qword [rbp-18H], rdi                    ; 0129 _ 48: 89. 7D, E8
        mov     rax, rsi                                ; 012D _ 48: 89. F0
        mov     rcx, rdx                                ; 0130 _ 48: 89. D1
; Filling space: 3H
; Filler type: mov with same source and destination
;       db 48H, 89H, 0C0H

ALIGN   2
        mov     edx, 0                                  ; 0136 _ BA, 00000000
        mov     rdx, rcx                                ; 013B _ 48: 89. CA
        mov     qword [rbp-30H], rax                    ; 013E _ 48: 89. 45, D0
        mov     qword [rbp-28H], rdx                    ; 0142 _ 48: 89. 55, D8
        mov     edi, 40                                 ; 0146 _ BF, 00000028
        call    nasm_zalloc                             ; 014B _ E8, 00000000(PLT r)
        mov     qword [rbp-8H], rax                     ; 0150 _ 48: 89. 45, F8
        mov     rcx, qword [rbp-8H]                     ; 0154 _ 48: 8B. 4D, F8
        mov     rax, qword [rbp-30H]                    ; 0158 _ 48: 8B. 45, D0
        mov     rdx, qword [rbp-28H]                    ; 015C _ 48: 8B. 55, D8
        mov     qword [rcx], rax                        ; 0160 _ 48: 89. 01
        mov     qword [rcx+8H], rdx                     ; 0163 _ 48: 89. 51, 08
        mov     rax, qword [rbp-8H]                     ; 0167 _ 48: 8B. 45, F8
        mov     rdx, qword [rbp-18H]                    ; 016B _ 48: 8B. 55, E8
        mov     qword [rax+20H], rdx                    ; 016F _ 48: 89. 50, 20
        mov     rdx, qword [rel _src_bottom]            ; 0173 _ 48: 8B. 15, 00000000(rel)
        mov     rax, qword [rbp-8H]                     ; 017A _ 48: 8B. 45, F8
        mov     qword [rax+10H], rdx                    ; 017E _ 48: 89. 50, 10
        mov     rax, qword [rel _src_bottom]            ; 0182 _ 48: 8B. 05, 00000000(rel)
        mov     rdx, qword [rbp-8H]                     ; 0189 _ 48: 8B. 55, F8
        mov     qword [rax+18H], rdx                    ; 018D _ 48: 89. 50, 18
        mov     rax, qword [rbp-8H]                     ; 0191 _ 48: 8B. 45, F8
        mov     qword [rel _src_bottom], rax            ; 0195 _ 48: 89. 05, 00000000(rel)
        nop                                             ; 019C _ 90
        leave                                           ; 019D _ C9
        ret                                             ; 019E _ C3
; src_macro_push End of function

src_macro_pop:; Function begin
        push    rbp                                     ; 019F _ 55
        mov     rbp, rsp                                ; 01A0 _ 48: 89. E5
        sub     rsp, 16                                 ; 01A3 _ 48: 83. EC, 10
        mov     rax, qword [rel _src_bottom]            ; 01A7 _ 48: 8B. 05, 00000000(rel)
        mov     qword [rbp-8H], rax                     ; 01AE _ 48: 89. 45, F8
        mov     rax, qword [rbp-8H]                     ; 01B2 _ 48: 8B. 45, F8
        mov     rax, qword [rax+10H]                    ; 01B6 _ 48: 8B. 40, 10
        mov     qword [rel _src_bottom], rax            ; 01BA _ 48: 89. 05, 00000000(rel)
        mov     rax, qword [rel _src_bottom]            ; 01C1 _ 48: 8B. 05, 00000000(rel)
        mov     qword [rax+18H], 0                      ; 01C8 _ 48: C7. 40, 18, 00000000
        mov     rax, qword [rbp-8H]                     ; 01D0 _ 48: 8B. 45, F8
        mov     rdi, rax                                ; 01D4 _ 48: 89. C7
        call    nasm_free                               ; 01D7 _ E8, 00000000(PLT r)
        nop                                             ; 01DC _ 90
        leave                                           ; 01DD _ C9
        ret                                             ; 01DE _ C3
; src_macro_pop End of function


SECTION .data   align=1 noexec                          ; section number 2, data


SECTION .bss    align=32 noexec                         ; section number 3, bss

_src_top:                                               ; byte
        resb    64                                      ; 0000

filename_hash:                                          ; yword
        resb    32                                      ; 0040


SECTION .data.rel.local align=8 noexec                  ; section number 4, data

_src_bottom:                                            ; qword
        dq _src_top                                     ; 0000 _ 0000000000000000 (d)

_src_error:                                             ; qword
        dq _src_top                                     ; 0008 _ 0000000000000000 (d)


SECTION .note.gnu.property align=8 noexec               ; section number 5, const

        db 04H, 00H, 00H, 00H, 20H, 00H, 00H, 00H       ; 0000 _ .... ...
        db 05H, 00H, 00H, 00H, 47H, 4EH, 55H, 00H       ; 0008 _ ....GNU.
        db 02H, 00H, 01H, 0C0H, 04H, 00H, 00H, 00H      ; 0010 _ ........
        db 01H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0018 _ ........
        db 01H, 00H, 01H, 0C0H, 04H, 00H, 00H, 00H      ; 0020 _ ........
        db 01H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0028 _ ........


SECTION .eh_frame align=8 noexec                        ; section number 6, const

        db 14H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0000 _ ........
        db 01H, 7AH, 52H, 00H, 01H, 78H, 10H, 01H       ; 0008 _ .zR..x..
        db 1BH, 0CH, 07H, 08H, 90H, 01H, 00H, 00H       ; 0010 _ ........
        db 1CH, 00H, 00H, 00H, 1CH, 00H, 00H, 00H       ; 0018 _ ........
        dd src_set_linnum-$-20H                         ; 0020 _ 00000000 (rel)
        dd 00000026H, 100E4100H                         ; 0024 _ 38 269369600 
        dd 0D430286H, 070C6106H                         ; 002C _ 222495366 118251782 
        dd 00000008H, 0000001CH                         ; 0034 _ 8 28 
        dd 0000003CH                                    ; 003C _ 60 
        dd src_set_linnum-$-1AH                         ; 0040 _ 00000000 (rel)
        dd 00000007H, 100E4100H                         ; 0044 _ 7 269369600 
        dd 0D430286H, 070C4206H                         ; 004C _ 222495366 118243846 
        dd 00000008H, 0000001CH                         ; 0054 _ 8 28 
        dd 0000005CH                                    ; 005C _ 92 
        dd src_set_linnum-$-33H                         ; 0060 _ 00000000 (rel)
        dd 0000001BH, 100E4100H                         ; 0064 _ 27 269369600 
        dd 0D430286H, 070C5606H                         ; 006C _ 222495366 118248966 
        dd 00000008H, 0000001CH                         ; 0074 _ 8 28 
        dd 0000007CH                                    ; 007C _ 124 
        dd src_set_linnum-$-38H                         ; 0080 _ 00000000 (rel)
        dd 000000B1H, 100E4100H                         ; 0084 _ 177 269369600 
        dd 0D430286H, 0CAC0206H                         ; 008C _ 222495366 212599302 
        dd 00000807H, 0000001CH                         ; 0094 _ 2055 28 
        dd 0000009CH                                    ; 009C _ 156 
        dd src_set_linnum-$+59H                         ; 00A0 _ 00000000 (rel)
        dd 00000028H, 100E4100H                         ; 00A4 _ 40 269369600 
        dd 0D430286H, 070C6306H                         ; 00AC _ 222495366 118252294 
        dd 00000008H, 0000001CH                         ; 00B4 _ 8 28 
        dd 000000BCH                                    ; 00BC _ 188 
        dd src_set_linnum-$+61H                         ; 00C0 _ 00000000 (rel)
        dd 0000007EH, 100E4100H                         ; 00C4 _ 126 269369600 
        dd 0D430286H, 0C790206H                         ; 00CC _ 222495366 209256966 
        dd 00000807H, 0000001CH                         ; 00D4 _ 2055 28 
        dd 000000DCH                                    ; 00DC _ 220 
        dd src_set_linnum-$+0BFH                        ; 00E0 _ 00000000 (rel)
        dd 00000040H, 100E4100H                         ; 00E4 _ 64 269369600 
        dd 0D430286H, 070C7B06H                         ; 00EC _ 222495366 118258438 
        dd 00000008H                                    ; 00F4 _ 8 


