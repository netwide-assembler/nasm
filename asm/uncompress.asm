; Disassembly of file: /tmp/tmp.di6g72w9BA.o
; Wed Sep 23 14:43:23 2026
; Type: ELF64
; Syntax: NASM
; Instruction set: 8086, x64

default rel

global uncompress_stdmac: function

extern __stack_chk_fail                                 ; near
extern inflateEnd                                       ; near
extern inflate                                          ; near
extern nasm_panic_from_macro                            ; near
extern inflateInit2_                                    ; near
extern memset                                           ; near
extern nasm_malloc                                      ; near
extern nasm_free                                        ; near
extern nasm_calloc                                      ; near


SECTION .text   align=1 exec                            ; section number 1, code

nasm_z_alloc:; Local function
        push    rbp                                     ; 0000 _ 55
        mov     rbp, rsp                                ; 0001 _ 48: 89. E5
        sub     rsp, 16                                 ; 0004 _ 48: 83. EC, 10
        mov     qword [rbp-8H], rdi                     ; 0008 _ 48: 89. 7D, F8
        mov     dword [rbp-0CH], esi                    ; 000C _ 89. 75, F4
        mov     dword [rbp-10H], edx                    ; 000F _ 89. 55, F0
        mov     edx, dword [rbp-10H]                    ; 0012 _ 8B. 55, F0
        mov     eax, dword [rbp-0CH]                    ; 0015 _ 8B. 45, F4
        mov     rsi, rdx                                ; 0018 _ 48: 89. D6
        mov     rdi, rax                                ; 001B _ 48: 89. C7
        call    nasm_calloc                             ; 001E _ E8, 00000000(PLT r)
        leave                                           ; 0023 _ C9
        ret                                             ; 0024 _ C3

nasm_z_free:; Local function
        push    rbp                                     ; 0025 _ 55
        mov     rbp, rsp                                ; 0026 _ 48: 89. E5
        sub     rsp, 16                                 ; 0029 _ 48: 83. EC, 10
        mov     qword [rbp-8H], rdi                     ; 002D _ 48: 89. 7D, F8
        mov     qword [rbp-10H], rsi                    ; 0031 _ 48: 89. 75, F0
        mov     rax, qword [rbp-10H]                    ; 0035 _ 48: 8B. 45, F0
        mov     rdi, rax                                ; 0039 _ 48: 89. C7
        call    nasm_free                               ; 003C _ E8, 00000000(PLT r)
        nop                                             ; 0041 _ 90
        leave                                           ; 0042 _ C9
        ret                                             ; 0043 _ C3

uncompress_stdmac:; Function begin
        push    rbp                                     ; 0044 _ 55
        mov     rbp, rsp                                ; 0045 _ 48: 89. E5
        sub     rsp, 160                                ; 0048 _ 48: 81. EC, 000000A0
        mov     qword [rbp-98H], rdi                    ; 004F _ 48: 89. BD, FFFFFF68
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        mov     rax, qword [fs:abs 28H]                 ; 0056 _ 64 48: 8B. 04 25, 00000028
        mov     qword [rbp-8H], rax                     ; 005F _ 48: 89. 45, F8
        xor     eax, eax                                ; 0063 _ 31. C0
        mov     rax, qword [rbp-98H]                    ; 0065 _ 48: 8B. 85, FFFFFF68
        mov     eax, dword [rax]                        ; 006C _ 8B. 00
        mov     eax, eax                                ; 006E _ 89. C0
        mov     rdi, rax                                ; 0070 _ 48: 89. C7
        call    nasm_malloc                             ; 0073 _ E8, 00000000(PLT r)
        mov     qword [rbp-88H], rax                    ; 0078 _ 48: 89. 85, FFFFFF78
        lea     rax, [rbp-80H]                          ; 007F _ 48: 8D. 45, 80
        mov     edx, 112                                ; 0083 _ BA, 00000070
        mov     esi, 0                                  ; 0088 _ BE, 00000000
        mov     rdi, rax                                ; 008D _ 48: 89. C7
        call    memset                                  ; 0090 _ E8, 00000000(PLT r)
        mov     rax, qword [rbp-98H]                    ; 0095 _ 48: 8B. 85, FFFFFF68
        mov     rax, qword [rax+8H]                     ; 009C _ 48: 8B. 40, 08
        mov     qword [rbp-80H], rax                    ; 00A0 _ 48: 89. 45, 80
        mov     rax, qword [rbp-98H]                    ; 00A4 _ 48: 8B. 85, FFFFFF68
        mov     eax, dword [rax+4H]                     ; 00AB _ 8B. 40, 04
        mov     dword [rbp-78H], eax                    ; 00AE _ 89. 45, 88
        mov     rax, qword [rbp-88H]                    ; 00B1 _ 48: 8B. 85, FFFFFF78
        mov     qword [rbp-68H], rax                    ; 00B8 _ 48: 89. 45, 98
        mov     rax, qword [rbp-98H]                    ; 00BC _ 48: 8B. 85, FFFFFF68
        mov     eax, dword [rax]                        ; 00C3 _ 8B. 00
        mov     dword [rbp-60H], eax                    ; 00C5 _ 89. 45, A0
        lea     rax, [rel nasm_z_alloc]                 ; 00C8 _ 48: 8D. 05, FFFFFF31(rel)
        mov     qword [rbp-40H], rax                    ; 00CF _ 48: 89. 45, C0
        lea     rax, [rel nasm_z_free]                  ; 00D3 _ 48: 8D. 05, FFFFFF4B(rel)
        mov     qword [rbp-38H], rax                    ; 00DA _ 48: 89. 45, C8
        lea     rdx, [rel ?_004]                        ; 00DE _ 48: 8D. 15, 00000000(rel)
        lea     rax, [rbp-80H]                          ; 00E5 _ 48: 8D. 45, 80
        mov     ecx, 112                                ; 00E9 _ B9, 00000070
        mov     esi, 15                                 ; 00EE _ BE, 0000000F
        mov     rdi, rax                                ; 00F3 _ 48: 89. C7
        call    inflateInit2_                           ; 00F6 _ E8, 00000000(PLT r)
        test    eax, eax                                ; 00FB _ 85. C0
        jz      ?_001                                   ; 00FD _ 74, 1E
        lea     rcx, [rel ?_005]                        ; 00FF _ 48: 8D. 0D, 00000000(rel)
        lea     rax, [rel __func__.0]                   ; 0106 _ 48: 8D. 05, 00000000(rel)
        mov     edx, 44                                 ; 010D _ BA, 0000002C
        mov     rsi, rcx                                ; 0112 _ 48: 89. CE
        mov     rdi, rax                                ; 0115 _ 48: 89. C7
        call    nasm_panic_from_macro                   ; 0118 _ E8, 00000000(PLT r)
?_001:  lea     rax, [rbp-80H]                          ; 011D _ 48: 8D. 45, 80
        mov     esi, 4                                  ; 0121 _ BE, 00000004
        mov     rdi, rax                                ; 0126 _ 48: 89. C7
        call    inflate                                 ; 0129 _ E8, 00000000(PLT r)
        cmp     eax, 1                                  ; 012E _ 83. F8, 01
        jz      ?_002                                   ; 0131 _ 74, 1E
        lea     rcx, [rel ?_005]                        ; 0133 _ 48: 8D. 0D, 00000000(rel)
        lea     rax, [rel __func__.0]                   ; 013A _ 48: 8D. 05, 00000000(rel)
        mov     edx, 47                                 ; 0141 _ BA, 0000002F
        mov     rsi, rcx                                ; 0146 _ 48: 89. CE
        mov     rdi, rax                                ; 0149 _ 48: 89. C7
        call    nasm_panic_from_macro                   ; 014C _ E8, 00000000(PLT r)
?_002:  lea     rax, [rbp-80H]                          ; 0151 _ 48: 8D. 45, 80
        mov     rdi, rax                                ; 0155 _ 48: 89. C7
        call    inflateEnd                              ; 0158 _ E8, 00000000(PLT r)
        mov     rax, qword [rbp-88H]                    ; 015D _ 48: 8B. 85, FFFFFF78
        mov     rdx, qword [rbp-8H]                     ; 0164 _ 48: 8B. 55, F8
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        sub     rdx, qword [fs:abs 28H]                 ; 0168 _ 64 48: 2B. 14 25, 00000028
        jz      ?_003                                   ; 0171 _ 74, 05
        call    __stack_chk_fail                        ; 0173 _ E8, 00000000(PLT r)
?_003:  leave                                           ; 0178 _ C9
        ret                                             ; 0179 _ C3
; uncompress_stdmac End of function


SECTION .data   align=1 noexec                          ; section number 2, data


SECTION .bss    align=1 noexec                          ; section number 3, bss


SECTION .rodata align=16 noexec                         ; section number 4, const

?_004:                                                  ; byte
        db 31H, 2EH, 33H, 2EH, 32H, 00H                 ; 0000 _ 1.3.2.

?_005:                                                  ; byte
        db 2EH, 2FH, 61H, 73H, 6DH, 2FH, 75H, 6EH       ; 0006 _ ./asm/un
        db 63H, 6FH, 6DH, 70H, 72H, 65H, 73H, 73H       ; 000E _ compress
        db 2EH, 63H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0016 _ .c......
        db 00H, 00H                                     ; 001E _ ..

__func__.0:                                             ; byte
        db 75H, 6EH, 63H, 6FH, 6DH, 70H, 72H, 65H       ; 0020 _ uncompre
        db 73H, 73H, 5FH, 73H, 74H, 64H, 6DH, 61H       ; 0028 _ ss_stdma
        db 63H, 00H                                     ; 0030 _ c.


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
        dd nasm_z_alloc-$-20H                           ; 0020 _ 00000000 (rel)
        dd 00000025H, 100E4100H                         ; 0024 _ 37 269369600 
        dd 0D430286H, 070C6006H                         ; 002C _ 222495366 118251526 
        dd 00000008H, 0000001CH                         ; 0034 _ 8 28 
        dd 0000003CH                                    ; 003C _ 60 
        dd nasm_z_alloc-$-1BH                           ; 0040 _ 00000000 (rel)
        dd 0000001FH, 100E4100H                         ; 0044 _ 31 269369600 
        dd 0D430286H, 070C5A06H                         ; 004C _ 222495366 118249990 
        dd 00000008H, 0000001CH                         ; 0054 _ 8 28 
        dd 0000005CH                                    ; 005C _ 92 
        dd nasm_z_alloc-$-1CH                           ; 0060 _ 00000000 (rel)
        dd 00000136H, 100E4100H                         ; 0064 _ 310 269369600 
        dd 0D430286H, 01310306H                         ; 006C _ 222495366 19989254 
        dd 0008070CH                                    ; 0074 _ 526092 


