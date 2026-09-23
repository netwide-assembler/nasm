; Disassembly of file: /tmp/tmp.nI6tVRATzy.o
; Wed Sep 23 14:43:28 2026
; Type: ELF64
; Syntax: NASM
; Instruction set: 8086, x64

default rel

global dump_expr: function

extern puts                                             ; near
extern printf                                           ; near
extern putchar                                          ; near
extern snprintf                                         ; near
extern location                                         ; dword
extern nasm_reg_names                                   ; byte


SECTION .text   align=1 exec                            ; section number 1, code

expr_type:; Local function
        push    rbp                                     ; 0000 _ 55
        mov     rbp, rsp                                ; 0001 _ 48: 89. E5
        sub     rsp, 16                                 ; 0004 _ 48: 83. EC, 10
        mov     dword [rbp-4H], edi                     ; 0008 _ 89. 7D, FC
        cmp     dword [rbp-4H], 348                     ; 000B _ 81. 7D, FC, 0000015C
        jz      ?_005                                   ; 0012 _ 74, 6E
        cmp     dword [rbp-4H], 348                     ; 0014 _ 81. 7D, FC, 0000015C
        jg      ?_006                                   ; 001B _ 7F, 71
        cmp     dword [rbp-4H], 347                     ; 001D _ 81. 7D, FC, 0000015B
        jz      ?_004                                   ; 0024 _ 74, 50
        cmp     dword [rbp-4H], 347                     ; 0026 _ 81. 7D, FC, 0000015B
        jg      ?_006                                   ; 002D _ 7F, 5F
        cmp     dword [rbp-4H], 346                     ; 002F _ 81. 7D, FC, 0000015A
        jz      ?_003                                   ; 0036 _ 74, 32
        cmp     dword [rbp-4H], 346                     ; 0038 _ 81. 7D, FC, 0000015A
        jg      ?_006                                   ; 003F _ 7F, 4D
        cmp     dword [rbp-4H], 0                       ; 0041 _ 83. 7D, FC, 00
        jz      ?_001                                   ; 0045 _ 74, 0B
        cmp     dword [rbp-4H], 345                     ; 0047 _ 81. 7D, FC, 00000159
        jz      ?_002                                   ; 004E _ 74, 0E
        jmp     ?_006                                   ; 0050 _ EB, 3C

?_001:  lea     rax, [rel ?_014]                        ; 0052 _ 48: 8D. 05, 00000000(rel)
        jmp     ?_011                                   ; 0059 _ E9, 000000C7

?_002:  lea     rax, [rel ?_015]                        ; 005E _ 48: 8D. 05, 00000000(rel)
        jmp     ?_011                                   ; 0065 _ E9, 000000BB

?_003:  lea     rax, [rel ?_016]                        ; 006A _ 48: 8D. 05, 00000000(rel)
        jmp     ?_011                                   ; 0071 _ E9, 000000AF

?_004:  lea     rax, [rel ?_017]                        ; 0076 _ 48: 8D. 05, 00000000(rel)
        jmp     ?_011                                   ; 007D _ E9, 000000A3

?_005:  lea     rax, [rel ?_018]                        ; 0082 _ 48: 8D. 05, 00000000(rel)
        jmp     ?_011                                   ; 0089 _ E9, 00000097

?_006:  nop                                             ; 008E _ 90
        cmp     dword [rbp-4H], 0                       ; 008F _ 83. 7D, FC, 00
        jle     ?_007                                   ; 0093 _ 7E, 26
        cmp     dword [rbp-4H], 344                     ; 0095 _ 81. 7D, FC, 00000158
        jg      ?_007                                   ; 009C _ 7F, 1D
        mov     eax, dword [rbp-4H]                     ; 009E _ 8B. 45, FC
        sub     eax, 1                                  ; 00A1 _ 83. E8, 01
        cdqe                                            ; 00A4 _ 48: 98
        lea     rdx, [rax*8]                            ; 00A6 _ 48: 8D. 14 C5, 00000000
        lea     rax, [rel nasm_reg_names]               ; 00AE _ 48: 8D. 05, 00000000(rel)
        mov     rax, qword [rdx+rax]                    ; 00B5 _ 48: 8B. 04 02
        jmp     ?_011                                   ; 00B9 _ EB, 6A

?_007:  cmp     dword [rbp-4H], 348                     ; 00BB _ 81. 7D, FC, 0000015C
        jle     ?_010                                   ; 00C2 _ 7E, 5A
        mov     eax, dword [rbp-4H]                     ; 00C4 _ 8B. 45, FC
        sub     eax, 349                                ; 00C7 _ 2D, 0000015D
        movsxd  rcx, eax                                ; 00CC _ 48: 63. C8
        mov     eax, dword [rbp-4H]                     ; 00CF _ 8B. 45, FC
        lea     edx, [rax-15DH]                         ; 00D2 _ 8D. 90, FFFFFEA3
        mov     eax, dword [rel location+8H]            ; 00D8 _ 8B. 05, 00000000(rel)
        cmp     edx, eax                                ; 00DE _ 39. C2
        jnz     ?_008                                   ; 00E0 _ 75, 09
        lea     rax, [rel ?_019]                        ; 00E2 _ 48: 8D. 05, 00000000(rel)
        jmp     ?_009                                   ; 00E9 _ EB, 07

?_008:  lea     rax, [rel ?_020]                        ; 00EB _ 48: 8D. 05, 00000000(rel)
?_009:  lea     rdx, [rel ?_021]                        ; 00F2 _ 48: 8D. 15, 00000000(rel)
        lea     rdi, [rel seg_str.0]                    ; 00F9 _ 48: 8D. 3D, 00000000(rel)
        mov     r8, rcx                                 ; 0100 _ 49: 89. C8
        mov     rcx, rax                                ; 0103 _ 48: 89. C1
        mov     esi, 64                                 ; 0106 _ BE, 00000040
        mov     eax, 0                                  ; 010B _ B8, 00000000
        call    snprintf                                ; 0110 _ E8, 00000000(PLT r)
        lea     rax, [rel seg_str.0]                    ; 0115 _ 48: 8D. 05, 00000000(rel)
        jmp     ?_011                                   ; 011C _ EB, 07

?_010:  lea     rax, [rel ?_022]                        ; 011E _ 48: 8D. 05, 00000000(rel)
?_011:  leave                                           ; 0125 _ C9
        ret                                             ; 0126 _ C3

dump_expr:; Function begin
        push    rbp                                     ; 0127 _ 55
        mov     rbp, rsp                                ; 0128 _ 48: 89. E5
        push    r12                                     ; 012B _ 41: 54
        push    rbx                                     ; 012D _ 53
        sub     rsp, 16                                 ; 012E _ 48: 83. EC, 10
        mov     qword [rbp-18H], rdi                    ; 0132 _ 48: 89. 7D, E8
        mov     edi, 91                                 ; 0136 _ BF, 0000005B
        call    putchar                                 ; 013B _ E8, 00000000(PLT r)
        jmp     ?_013                                   ; 0140 _ EB, 3C

?_012:  mov     rax, qword [rbp-18H]                    ; 0142 _ 48: 8B. 45, E8
        mov     r12, qword [rax+8H]                     ; 0146 _ 4C: 8B. 60, 08
        mov     rax, qword [rbp-18H]                    ; 014A _ 48: 8B. 45, E8
        mov     ebx, dword [rax]                        ; 014E _ 8B. 18
        mov     rax, qword [rbp-18H]                    ; 0150 _ 48: 8B. 45, E8
        mov     eax, dword [rax]                        ; 0154 _ 8B. 00
        mov     edi, eax                                ; 0156 _ 89. C7
        call    expr_type                               ; 0158 _ E8, FFFFFEA3
        mov     rsi, rax                                ; 015D _ 48: 89. C6
        lea     rax, [rel ?_023]                        ; 0160 _ 48: 8D. 05, 00000000(rel)
        mov     rcx, r12                                ; 0167 _ 4C: 89. E1
        mov     edx, ebx                                ; 016A _ 89. DA
        mov     rdi, rax                                ; 016C _ 48: 89. C7
        mov     eax, 0                                  ; 016F _ B8, 00000000
        call    printf                                  ; 0174 _ E8, 00000000(PLT r)
        add     qword [rbp-18H], 16                     ; 0179 _ 48: 83. 45, E8, 10
?_013:  mov     rax, qword [rbp-18H]                    ; 017E _ 48: 8B. 45, E8
        mov     eax, dword [rax]                        ; 0182 _ 8B. 00
        test    eax, eax                                ; 0184 _ 85. C0
        jnz     ?_012                                   ; 0186 _ 75, BA
        lea     rax, [rel ?_024]                        ; 0188 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 018F _ 48: 89. C7
        call    puts                                    ; 0192 _ E8, 00000000(PLT r)
        nop                                             ; 0197 _ 90
        add     rsp, 16                                 ; 0198 _ 48: 83. C4, 10
        pop     rbx                                     ; 019C _ 5B
        pop     r12                                     ; 019D _ 41: 5C
        pop     rbp                                     ; 019F _ 5D
        ret                                             ; 01A0 _ C3
; dump_expr End of function


SECTION .data   align=1 noexec                          ; section number 2, data


SECTION .bss    align=32 noexec                         ; section number 3, bss

seg_str.0:                                              ; zword
        resb    64                                      ; 0000


SECTION .rodata align=1 noexec                          ; section number 4, const

?_014:                                                  ; byte
        db 6EH, 75H, 6CH, 6CH, 00H                      ; 0000 _ null.

?_015:                                                  ; byte
        db 75H, 6EH, 6BH, 6EH, 6FH, 77H, 6EH, 00H       ; 0005 _ unknown.

?_016:                                                  ; byte
        db 73H, 69H, 6DH, 70H, 6CH, 65H, 00H            ; 000D _ simple.

?_017:                                                  ; byte
        db 77H, 72H, 74H, 00H                           ; 0014 _ wrt.

?_018:                                                  ; byte
        db 73H, 61H, 65H, 00H                           ; 0018 _ sae.

?_019:                                                  ; byte
        db 74H, 68H, 69H, 73H, 20H, 00H                 ; 001C _ this .

?_020:                                                  ; byte
        db 00H                                          ; 0022 _ .

?_021:                                                  ; byte
        db 25H, 73H, 73H, 65H, 67H, 20H, 25H, 6CH       ; 0023 _ %sseg %l
        db 75H, 00H                                     ; 002B _ u.

?_022:                                                  ; byte
        db 45H, 52H, 52H, 00H                           ; 002D _ ERR.

?_023:                                                  ; byte
        db 3CH, 25H, 73H, 28H, 25H, 64H, 29H, 2CH       ; 0031 _ <%s(%d),
        db 25H, 6CH, 64H, 3EH, 00H                      ; 0039 _ %ld>.

?_024:                                                  ; byte
        db 5DH, 00H                                     ; 003E _ ].


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
        dd expr_type-$-20H                              ; 0020 _ 00000000 (rel)
        dd 00000127H, 100E4100H                         ; 0024 _ 295 269369600 
        dd 0D430286H, 01220306H                         ; 002C _ 222495366 19006214 
        dd 0008070CH, 00000024H                         ; 0034 _ 526092 36 
        dd 0000003CH                                    ; 003C _ 60 
        dd expr_type-$+0E7H                             ; 0040 _ 00000000 (rel)
        dd 0000007AH, 100E4100H                         ; 0044 _ 122 269369600 
        dd 0D430286H, 038C4706H                         ; 004C _ 222495366 59524870 
        dd 6E020483H, 0008070CH                         ; 0054 _ 1845625987 526092 
        dd 00000000H                                    ; 005C _ 0 


