; Disassembly of file: /tmp/tmp.1JPa4y6NaB.o
; Wed Sep 23 14:43:23 2026
; Type: ELF64
; Syntax: NASM
; Instruction set: 80386, x64

default rel

global parse_line: function
global cleanup_insn: function

extern nasm_nonfatalf                                   ; near
extern nasm_fatal                                       ; near
extern reloc_wrt                                        ; near
extern reloc_seg                                        ; near
extern reloc_value                                      ; near
extern expr_class                                       ; near
extern stdscan_pushback                                 ; near
extern define_label                                     ; near
extern absolute                                         ; dword
extern in_absolute                                      ; byte
extern optimizing                                       ; dword
extern stdscan_reset                                    ; near
extern __stack_chk_fail                                 ; near
extern is_simple                                        ; near
extern evaluate                                         ; near
extern _GLOBAL_OFFSET_TABLE_                            ; byte
extern float_const                                      ; near
extern nasm_realloc                                     ; near
extern float_deffmt                                     ; near
extern stdscan_set                                      ; near
extern stdscan_get                                      ; near
extern string_transform                                 ; near
extern nasm_free                                        ; near
extern nasm_zalloc                                      ; near
extern nasm_warn_                                       ; near
extern globl                                            ; dword
extern nasm_assert_failed                               ; near
extern location                                         ; qword
extern memset                                           ; near
extern stdscan                                          ; near
extern nasm_regvals                                     ; byte
extern nasm_nonfatal                                    ; near
extern tasm_compatible_mode                             ; byte
extern nasm_asprintf                                    ; near
extern nasm_strdup                                      ; near
extern _passn                                           ; qword
extern _pass_type                                       ; dword
extern warning_state                                    ; byte
extern erropt                                           ; dword
extern nasm_reg_flags                                   ; byte


SECTION .text   align=1 exec                            ; section number 1, code

is_class:; Local function
        push    rbp                                     ; 0000 _ 55
        mov     rbp, rsp                                ; 0001 _ 48: 89. E5
        mov     qword [rbp-8H], rdi                     ; 0004 _ 48: 89. 7D, F8
        mov     qword [rbp-10H], rsi                    ; 0008 _ 48: 89. 75, F0
        mov     rax, qword [rbp-10H]                    ; 000C _ 48: 8B. 45, F0
        not     rax                                     ; 0010 _ 48: F7. D0
        and     rax, qword [rbp-8H]                     ; 0013 _ 48: 23. 45, F8
        test    rax, rax                                ; 0017 _ 48: 85. C0
        sete    al                                      ; 001A _ 0F 94. C0
        pop     rbp                                     ; 001D _ 5D
        ret                                             ; 001E _ C3

is_register:; Local function
        push    rbp                                     ; 001F _ 55
        mov     rbp, rsp                                ; 0020 _ 48: 89. E5
        mov     dword [rbp-4H], edi                     ; 0023 _ 89. 7D, FC
        cmp     dword [rbp-4H], 0                       ; 0026 _ 83. 7D, FC, 00
        jle     ?_001                                   ; 002A _ 7E, 10
        cmp     dword [rbp-4H], 344                     ; 002C _ 81. 7D, FC, 00000158
        jg      ?_001                                   ; 0033 _ 7F, 07
        mov     eax, 1                                  ; 0035 _ B8, 00000001
        jmp     ?_002                                   ; 003A _ EB, 05

?_001:  mov     eax, 0                                  ; 003C _ B8, 00000000
?_002:  and     eax, 01H                                ; 0041 _ 83. E0, 01
        pop     rbp                                     ; 0044 _ 5D
        ret                                             ; 0045 _ C3

is_reg_class:; Local function
        push    rbp                                     ; 0046 _ 55
        mov     rbp, rsp                                ; 0047 _ 48: 89. E5
        sub     rsp, 16                                 ; 004A _ 48: 83. EC, 10
        mov     qword [rbp-8H], rdi                     ; 004E _ 48: 89. 7D, F8
        mov     dword [rbp-0CH], esi                    ; 0052 _ 89. 75, F4
        mov     eax, dword [rbp-0CH]                    ; 0055 _ 8B. 45, F4
        mov     edi, eax                                ; 0058 _ 89. C7
        call    is_register                             ; 005A _ E8, FFFFFFC0
        xor     eax, 01H                                ; 005F _ 83. F0, 01
        test    al, al                                  ; 0062 _ 84. C0
        jz      ?_003                                   ; 0064 _ 74, 07
        mov     eax, 0                                  ; 0066 _ B8, 00000000
        jmp     ?_004                                   ; 006B _ EB, 27

?_003:  mov     eax, dword [rbp-0CH]                    ; 006D _ 8B. 45, F4
        cdqe                                            ; 0070 _ 48: 98
        lea     rdx, [rax*8]                            ; 0072 _ 48: 8D. 14 C5, 00000000
        lea     rax, [rel nasm_reg_flags]               ; 007A _ 48: 8D. 05, 00000000(rel)
        mov     rdx, qword [rdx+rax]                    ; 0081 _ 48: 8B. 14 02
        mov     rax, qword [rbp-8H]                     ; 0085 _ 48: 8B. 45, F8
        mov     rsi, rdx                                ; 0089 _ 48: 89. D6
        mov     rdi, rax                                ; 008C _ 48: 89. C7
        call    is_class                                ; 008F _ E8, FFFFFF6C
?_004:  leave                                           ; 0094 _ C9
        ret                                             ; 0095 _ C3

warn_active:; Local function
        push    rbp                                     ; 0096 _ 55
        mov     rbp, rsp                                ; 0097 _ 48: 89. E5
        mov     dword [rbp-4H], edi                     ; 009A _ 89. 7D, FC
        mov     eax, dword [rel erropt+0CH]             ; 009D _ 8B. 05, 00000000(rel)
        and     eax, dword [rbp-4H]                     ; 00A3 _ 23. 45, FC
        test    eax, eax                                ; 00A6 _ 85. C0
        jz      ?_005                                   ; 00A8 _ 74, 07
        mov     eax, 0                                  ; 00AA _ B8, 00000000
        jmp     ?_006                                   ; 00AF _ EB, 16

?_005:  mov     eax, dword [rbp-4H]                     ; 00B1 _ 8B. 45, FC
        shr     eax, 16                                 ; 00B4 _ C1. E8, 10
        mov     edx, eax                                ; 00B7 _ 89. C2
        lea     rax, [rel warning_state]                ; 00B9 _ 48: 8D. 05, 00000000(rel)
        movzx   eax, byte [rdx+rax]                     ; 00C0 _ 0F B6. 04 02
        and     eax, 01H                                ; 00C4 _ 83. E0, 01
?_006:  pop     rbp                                     ; 00C7 _ 5D
        ret                                             ; 00C8 _ C3

pass_type:; Local function
        push    rbp                                     ; 00C9 _ 55
        mov     rbp, rsp                                ; 00CA _ 48: 89. E5
        mov     eax, dword [rel _pass_type]             ; 00CD _ 8B. 05, 00000000(rel)
        pop     rbp                                     ; 00D3 _ 5D
        ret                                             ; 00D4 _ C3

pass_stable:; Local function
        push    rbp                                     ; 00D5 _ 55
        mov     rbp, rsp                                ; 00D6 _ 48: 89. E5
        call    pass_type                               ; 00D9 _ E8, FFFFFFEB
        cmp     eax, 3                                  ; 00DE _ 83. F8, 03
        seta    al                                      ; 00E1 _ 0F 97. C0
        pop     rbp                                     ; 00E4 _ 5D
        ret                                             ; 00E5 _ C3

pass_final:; Local function
        push    rbp                                     ; 00E6 _ 55
        mov     rbp, rsp                                ; 00E7 _ 48: 89. E5
        call    pass_type                               ; 00EA _ E8, FFFFFFDA
        cmp     eax, 4                                  ; 00EF _ 83. F8, 04
        seta    al                                      ; 00F2 _ 0F 97. C0
        pop     rbp                                     ; 00F5 _ 5D
        ret                                             ; 00F6 _ C3

pass_count:; Local function
        push    rbp                                     ; 00F7 _ 55
        mov     rbp, rsp                                ; 00F8 _ 48: 89. E5
        mov     rax, qword [rel _passn]                 ; 00FB _ 48: 8B. 05, 00000000(rel)
        pop     rbp                                     ; 0102 _ 5D
        ret                                             ; 0103 _ C3

opcode_is_db:; Local function
        push    rbp                                     ; 0104 _ 55
        mov     rbp, rsp                                ; 0105 _ 48: 89. E5
        mov     dword [rbp-4H], edi                     ; 0108 _ 89. 7D, FC
        cmp     dword [rbp-4H], 0                       ; 010B _ 83. 7D, FC, 00
        js      ?_007                                   ; 010F _ 78, 0D
        cmp     dword [rbp-4H], 7                       ; 0111 _ 83. 7D, FC, 07
        jg      ?_007                                   ; 0115 _ 7F, 07
        mov     eax, 1                                  ; 0117 _ B8, 00000001
        jmp     ?_008                                   ; 011C _ EB, 05

?_007:  mov     eax, 0                                  ; 011E _ B8, 00000000
?_008:  and     eax, 01H                                ; 0123 _ 83. E0, 01
        pop     rbp                                     ; 0126 _ 5D
        ret                                             ; 0127 _ C3

db_bytes:; Local function
        push    rbp                                     ; 0128 _ 55
        mov     rbp, rsp                                ; 0129 _ 48: 89. E5
        mov     dword [rbp-4H], edi                     ; 012C _ 89. 7D, FC
        cmp     dword [rbp-4H], 7                       ; 012F _ 83. 7D, FC, 07
        je      ?_015                                   ; 0133 _ 0F 84, 00000093
        cmp     dword [rbp-4H], 7                       ; 0139 _ 83. 7D, FC, 07
        jg      ?_017                                   ; 013D _ 0F 8F, 00000097
        cmp     dword [rbp-4H], 6                       ; 0143 _ 83. 7D, FC, 06
        jz      ?_014                                   ; 0147 _ 74, 7C
        cmp     dword [rbp-4H], 6                       ; 0149 _ 83. 7D, FC, 06
        jg      ?_017                                   ; 014D _ 0F 8F, 00000087
        cmp     dword [rbp-4H], 5                       ; 0153 _ 83. 7D, FC, 05
        jz      ?_013                                   ; 0157 _ 74, 65
        cmp     dword [rbp-4H], 5                       ; 0159 _ 83. 7D, FC, 05
        jg      ?_017                                   ; 015D _ 7F, 7B
        cmp     dword [rbp-4H], 4                       ; 015F _ 83. 7D, FC, 04
        jz      ?_012                                   ; 0163 _ 74, 52
        cmp     dword [rbp-4H], 4                       ; 0165 _ 83. 7D, FC, 04
        jg      ?_017                                   ; 0169 _ 7F, 6F
        cmp     dword [rbp-4H], 3                       ; 016B _ 83. 7D, FC, 03
        jz      ?_011                                   ; 016F _ 74, 3F
        cmp     dword [rbp-4H], 3                       ; 0171 _ 83. 7D, FC, 03
        jg      ?_017                                   ; 0175 _ 7F, 63
        cmp     dword [rbp-4H], 2                       ; 0177 _ 83. 7D, FC, 02
        jz      ?_010                                   ; 017B _ 74, 2C
        cmp     dword [rbp-4H], 2                       ; 017D _ 83. 7D, FC, 02
        jg      ?_017                                   ; 0181 _ 7F, 57
        cmp     dword [rbp-4H], 1                       ; 0183 _ 83. 7D, FC, 01
        jz      ?_009                                   ; 0187 _ 74, 19
        cmp     dword [rbp-4H], 1                       ; 0189 _ 83. 7D, FC, 01
        jg      ?_017                                   ; 018D _ 7F, 4B
        cmp     dword [rbp-4H], -1                      ; 018F _ 83. 7D, FC, FF
        jz      ?_016                                   ; 0193 _ 74, 3E
        cmp     dword [rbp-4H], 0                       ; 0195 _ 83. 7D, FC, 00
        jnz     ?_017                                   ; 0199 _ 75, 3F
        mov     eax, 1                                  ; 019B _ B8, 00000001
        jmp     ?_018                                   ; 01A0 _ EB, 3D

?_009:  mov     eax, 2                                  ; 01A2 _ B8, 00000002
        jmp     ?_018                                   ; 01A7 _ EB, 36

?_010:  mov     eax, 4                                  ; 01A9 _ B8, 00000004
        jmp     ?_018                                   ; 01AE _ EB, 2F

?_011:  mov     eax, 8                                  ; 01B0 _ B8, 00000008
        jmp     ?_018                                   ; 01B5 _ EB, 28

?_012:  mov     eax, 10                                 ; 01B7 _ B8, 0000000A
        jmp     ?_018                                   ; 01BC _ EB, 21

?_013:  mov     eax, 16                                 ; 01BE _ B8, 00000010
        jmp     ?_018                                   ; 01C3 _ EB, 1A

?_014:  mov     eax, 32                                 ; 01C5 _ B8, 00000020
        jmp     ?_018                                   ; 01CA _ EB, 13

?_015:  mov     eax, 64                                 ; 01CC _ B8, 00000040
        jmp     ?_018                                   ; 01D1 _ EB, 0C

?_016:  mov     eax, 4294967295                         ; 01D3 _ B8, FFFFFFFF
        jmp     ?_018                                   ; 01D8 _ EB, 05

?_017:  mov     eax, 0                                  ; 01DA _ B8, 00000000
?_018:  pop     rbp                                     ; 01DF _ 5D
        ret                                             ; 01E0 _ C3

tokstr: ; Local function
        push    rbp                                     ; 01E1 _ 55
        mov     rbp, rsp                                ; 01E2 _ 48: 89. E5
        sub     rsp, 16                                 ; 01E5 _ 48: 83. EC, 10
        mov     qword [rbp-8H], rdi                     ; 01E9 _ 48: 89. 7D, F8
        mov     rax, qword [rbp-8H]                     ; 01ED _ 48: 8B. 45, F8
        mov     eax, dword [rax+24H]                    ; 01F1 _ 8B. 40, 24
        test    eax, eax                                ; 01F4 _ 85. C0
        jnz     ?_019                                   ; 01F6 _ 75, 11
        lea     rax, [rel ?_356]                        ; 01F8 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 01FF _ 48: 89. C7
        call    nasm_strdup                             ; 0202 _ E8, 00000000(PLT r)
        jmp     ?_021                                   ; 0207 _ EB, 41

?_019:  mov     rax, qword [rbp-8H]                     ; 0209 _ 48: 8B. 45, F8
        mov     eax, dword [rax+20H]                    ; 020D _ 8B. 40, 20
        test    eax, eax                                ; 0210 _ 85. C0
        jz      ?_020                                   ; 0212 _ 74, 27
        mov     rax, qword [rbp-8H]                     ; 0214 _ 48: 8B. 45, F8
        mov     rdx, qword [rax+18H]                    ; 0218 _ 48: 8B. 50, 18
        mov     rax, qword [rbp-8H]                     ; 021C _ 48: 8B. 45, F8
        mov     eax, dword [rax+20H]                    ; 0220 _ 8B. 40, 20
        lea     rcx, [rel ?_357]                        ; 0223 _ 48: 8D. 0D, 00000000(rel)
        mov     esi, eax                                ; 022A _ 89. C6
        mov     rdi, rcx                                ; 022C _ 48: 89. CF
        mov     eax, 0                                  ; 022F _ B8, 00000000
        call    nasm_asprintf                           ; 0234 _ E8, 00000000(PLT r)
        jmp     ?_021                                   ; 0239 _ EB, 0F

?_020:  lea     rax, [rel ?_358]                        ; 023B _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 0242 _ 48: 89. C7
        call    nasm_strdup                             ; 0245 _ E8, 00000000(PLT r)
?_021:  leave                                           ; 024A _ C9
        ret                                             ; 024B _ C3

process_size_override:; Local function
        push    rbp                                     ; 024C _ 55
        mov     rbp, rsp                                ; 024D _ 48: 89. E5
        sub     rsp, 16                                 ; 0250 _ 48: 83. EC, 10
        mov     qword [rbp-8H], rdi                     ; 0254 _ 48: 89. 7D, F8
        mov     qword [rbp-10H], rsi                    ; 0258 _ 48: 89. 75, F0
        movzx   eax, byte [rel tasm_compatible_mode]    ; 025C _ 0F B6. 05, 00000000(rel)
        test    al, al                                  ; 0263 _ 84. C0
        je      ?_029                                   ; 0265 _ 0F 84, 00000151
        mov     rax, qword [rel tokval]                 ; 026B _ 48: 8B. 05, 00000000(rel)
        cmp     rax, 380                                ; 0272 _ 48: 3D, 0000017C
        je      ?_027                                   ; 0278 _ 0F 84, 00000105
        cmp     rax, 380                                ; 027E _ 48: 3D, 0000017C
        jg      ?_028                                   ; 0284 _ 0F 8F, 00000119
        cmp     rax, 379                                ; 028A _ 48: 3D, 0000017B
        je      ?_026                                   ; 0290 _ 0F 84, 000000CD
        cmp     rax, 379                                ; 0296 _ 48: 3D, 0000017B
        jg      ?_028                                   ; 029C _ 0F 8F, 00000101
        cmp     rax, 378                                ; 02A2 _ 48: 3D, 0000017A
        je      ?_025                                   ; 02A8 _ 0F 84, 00000095
        cmp     rax, 378                                ; 02AE _ 48: 3D, 0000017A
        jg      ?_028                                   ; 02B4 _ 0F 8F, 000000E9
        cmp     rax, 377                                ; 02BA _ 48: 3D, 00000179
        jg      ?_028                                   ; 02C0 _ 0F 8F, 000000DD
        cmp     rax, 376                                ; 02C6 _ 48: 3D, 00000178
        jge     ?_024                                   ; 02CC _ 7D, 55
        cmp     rax, 374                                ; 02CE _ 48: 3D, 00000176
        jz      ?_022                                   ; 02D4 _ 74, 0D
        cmp     rax, 375                                ; 02D6 _ 48: 3D, 00000177
        jz      ?_023                                   ; 02DC _ 74, 25
        jmp     ?_028                                   ; 02DE _ E9, 000000C0

?_022:  mov     rax, qword [rbp-10H]                    ; 02E3 _ 48: 8B. 45, F0
        mov     rax, qword [rax]                        ; 02E7 _ 48: 8B. 00
        mov     rdx, qword 100000000H                   ; 02EA _ 48: BA, 0000000100000000
        or      rdx, rax                                ; 02F4 _ 48: 09. C2
        mov     rax, qword [rbp-10H]                    ; 02F7 _ 48: 8B. 45, F0
        mov     qword [rax], rdx                        ; 02FB _ 48: 89. 10
        jmp     ?_041                                   ; 02FE _ E9, 0000028F

?_023:  mov     rax, qword [rbp-10H]                    ; 0303 _ 48: 8B. 45, F0
        mov     rax, qword [rax]                        ; 0307 _ 48: 8B. 00
        mov     rdx, qword 200000000H                   ; 030A _ 48: BA, 0000000200000000
        or      rdx, rax                                ; 0314 _ 48: 09. C2
        mov     rax, qword [rbp-10H]                    ; 0317 _ 48: 8B. 45, F0
        mov     qword [rax], rdx                        ; 031B _ 48: 89. 10
        jmp     ?_041                                   ; 031E _ E9, 0000026F

?_024:  mov     rax, qword [rbp-10H]                    ; 0323 _ 48: 8B. 45, F0
        mov     rax, qword [rax]                        ; 0327 _ 48: 8B. 00
        mov     rdx, qword 400000000H                   ; 032A _ 48: BA, 0000000400000000
        or      rdx, rax                                ; 0334 _ 48: 09. C2
        mov     rax, qword [rbp-10H]                    ; 0337 _ 48: 8B. 45, F0
        mov     qword [rax], rdx                        ; 033B _ 48: 89. 10
        jmp     ?_041                                   ; 033E _ E9, 0000024F

?_025:  mov     rax, qword [rbp-10H]                    ; 0343 _ 48: 8B. 45, F0
        mov     rax, qword [rax]                        ; 0347 _ 48: 8B. 00
        mov     rdx, qword 800000000H                   ; 034A _ 48: BA, 0000000800000000
        or      rdx, rax                                ; 0354 _ 48: 09. C2
        mov     rax, qword [rbp-10H]                    ; 0357 _ 48: 8B. 45, F0
        mov     qword [rax], rdx                        ; 035B _ 48: 89. 10
        jmp     ?_041                                   ; 035E _ E9, 0000022F

?_026:  mov     rax, qword [rbp-10H]                    ; 0363 _ 48: 8B. 45, F0
        mov     rax, qword [rax]                        ; 0367 _ 48: 8B. 00
        mov     rdx, qword 1000000000H                  ; 036A _ 48: BA, 0000001000000000
        or      rdx, rax                                ; 0374 _ 48: 09. C2
        mov     rax, qword [rbp-10H]                    ; 0377 _ 48: 8B. 45, F0
        mov     qword [rax], rdx                        ; 037B _ 48: 89. 10
        jmp     ?_041                                   ; 037E _ E9, 0000020F

?_027:  mov     rax, qword [rbp-10H]                    ; 0383 _ 48: 8B. 45, F0
        mov     rax, qword [rax]                        ; 0387 _ 48: 8B. 00
        mov     rdx, qword 2000000000H                  ; 038A _ 48: BA, 0000002000000000
        or      rdx, rax                                ; 0394 _ 48: 09. C2
        mov     rax, qword [rbp-10H]                    ; 0397 _ 48: 8B. 45, F0
        mov     qword [rax], rdx                        ; 039B _ 48: 89. 10
        jmp     ?_041                                   ; 039E _ E9, 000001EF

?_028:  lea     rax, [rel ?_359]                        ; 03A3 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 03AA _ 48: 89. C7
        mov     eax, 0                                  ; 03AD _ B8, 00000000
        call    nasm_nonfatal                           ; 03B2 _ E8, 00000000(PLT r)
        jmp     ?_041                                   ; 03B7 _ E9, 000001D6

?_029:  mov     rax, qword [rel tokval]                 ; 03BC _ 48: 8B. 05, 00000000(rel)
        cmp     rax, 387                                ; 03C3 _ 48: 3D, 00000183
        je      ?_032                                   ; 03C9 _ 0F 84, 000000BE
        cmp     rax, 387                                ; 03CF _ 48: 3D, 00000183
        jg      ?_040                                   ; 03D5 _ 0F 8F, 000001A2
        cmp     rax, 386                                ; 03DB _ 48: 3D, 00000182
        je      ?_031                                   ; 03E1 _ 0F 84, 0000008E
        cmp     rax, 386                                ; 03E7 _ 48: 3D, 00000182
        jg      ?_040                                   ; 03ED _ 0F 8F, 0000018A
        cmp     rax, 383                                ; 03F3 _ 48: 3D, 0000017F
        je      ?_033                                   ; 03F9 _ 0F 84, 000000A6
        cmp     rax, 383                                ; 03FF _ 48: 3D, 0000017F
        jg      ?_040                                   ; 0405 _ 0F 8F, 00000172
        cmp     rax, 378                                ; 040B _ 48: 3D, 0000017A
        je      ?_039                                   ; 0411 _ 0F 84, 00000149
        cmp     rax, 378                                ; 0417 _ 48: 3D, 0000017A
        jg      ?_040                                   ; 041D _ 0F 8F, 0000015A
        cmp     rax, 377                                ; 0423 _ 48: 3D, 00000179
        jg      ?_040                                   ; 0429 _ 0F 8F, 0000014E
        cmp     rax, 376                                ; 042F _ 48: 3D, 00000178
        jge     ?_038                                   ; 0435 _ 0F 8D, 00000108
        cmp     rax, 375                                ; 043B _ 48: 3D, 00000177
        je      ?_037                                   ; 0441 _ 0F 84, 000000DF
        cmp     rax, 375                                ; 0447 _ 48: 3D, 00000177
        jg      ?_040                                   ; 044D _ 0F 8F, 0000012A
        cmp     rax, 347                                ; 0453 _ 48: 3D, 0000015B
        jg      ?_030                                   ; 0459 _ 7F, 0D
        cmp     rax, 345                                ; 045B _ 48: 3D, 00000159
        jge     ?_035                                   ; 0461 _ 7D, 7A
        jmp     ?_040                                   ; 0463 _ E9, 00000115

?_030:  cmp     rax, 374                                ; 0468 _ 48: 3D, 00000176
        jz      ?_034                                   ; 046E _ 74, 4D
        jmp     ?_040                                   ; 0470 _ E9, 00000108

?_031:  mov     rax, qword [rbp-10H]                    ; 0475 _ 48: 8B. 45, F0
        mov     eax, dword [rax+34H]                    ; 0479 _ 8B. 40, 34
        or      eax, 04H                                ; 047C _ 83. C8, 04
        mov     edx, eax                                ; 047F _ 89. C2
        mov     rax, qword [rbp-10H]                    ; 0481 _ 48: 8B. 45, F0
        mov     dword [rax+34H], edx                    ; 0485 _ 89. 50, 34
        jmp     ?_041                                   ; 0488 _ E9, 00000105

?_032:  mov     rax, qword [rbp-10H]                    ; 048D _ 48: 8B. 45, F0
        mov     eax, dword [rax+34H]                    ; 0491 _ 8B. 40, 34
        or      eax, 08H                                ; 0494 _ 83. C8, 08
        mov     edx, eax                                ; 0497 _ 89. C2
        mov     rax, qword [rbp-10H]                    ; 0499 _ 48: 8B. 45, F0
        mov     dword [rax+34H], edx                    ; 049D _ 89. 50, 34
        jmp     ?_041                                   ; 04A0 _ E9, 000000ED

?_033:  mov     rax, qword [rbp-10H]                    ; 04A5 _ 48: 8B. 45, F0
        mov     eax, dword [rax+34H]                    ; 04A9 _ 8B. 40, 34
        or      eax, 10H                                ; 04AC _ 83. C8, 10
        mov     edx, eax                                ; 04AF _ 89. C2
        mov     rax, qword [rbp-10H]                    ; 04B1 _ 48: 8B. 45, F0
        mov     dword [rax+34H], edx                    ; 04B5 _ 89. 50, 34
        jmp     ?_041                                   ; 04B8 _ E9, 000000D5

?_034:  mov     rax, qword [rbp-10H]                    ; 04BD _ 48: 8B. 45, F0
        mov     byte [rax+43H], 8                       ; 04C1 _ C6. 40, 43, 08
        mov     rax, qword [rbp-10H]                    ; 04C5 _ 48: 8B. 45, F0
        mov     eax, dword [rax+34H]                    ; 04C9 _ 8B. 40, 34
        or      eax, 01H                                ; 04CC _ 83. C8, 01
        mov     edx, eax                                ; 04CF _ 89. C2
        mov     rax, qword [rbp-10H]                    ; 04D1 _ 48: 8B. 45, F0
        mov     dword [rax+34H], edx                    ; 04D5 _ 89. 50, 34
        jmp     ?_041                                   ; 04D8 _ E9, 000000B5

?_035:  mov     rax, qword [rbp-8H]                     ; 04DD _ 48: 8B. 45, F8
        mov     eax, dword [rax+20H]                    ; 04E1 _ 8B. 40, 20
        test    eax, eax                                ; 04E4 _ 85. C0
        jz      ?_036                                   ; 04E6 _ 74, 2C
        mov     rax, qword [rbp-8H]                     ; 04E8 _ 48: 8B. 45, F8
        mov     eax, dword [rax+20H]                    ; 04EC _ 8B. 40, 20
        movsxd  rdx, eax                                ; 04EF _ 48: 63. D0
        mov     rax, qword [rel tokval]                 ; 04F2 _ 48: 8B. 05, 00000000(rel)
        cmp     rdx, rax                                ; 04F9 _ 48: 39. C2
        jz      ?_036                                   ; 04FC _ 74, 16
        lea     rax, [rel ?_360]                        ; 04FE _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 0505 _ 48: 89. C7
        mov     eax, 0                                  ; 0508 _ B8, 00000000
        call    nasm_nonfatal                           ; 050D _ E8, 00000000(PLT r)
        jmp     ?_041                                   ; 0512 _ EB, 7E

?_036:  mov     rax, qword [rel tokval]                 ; 0514 _ 48: 8B. 05, 00000000(rel)
        mov     edx, eax                                ; 051B _ 89. C2
        mov     rax, qword [rbp-8H]                     ; 051D _ 48: 8B. 45, F8
        mov     dword [rax+20H], edx                    ; 0521 _ 89. 50, 20
        jmp     ?_041                                   ; 0524 _ EB, 6C

?_037:  mov     rax, qword [rbp-10H]                    ; 0526 _ 48: 8B. 45, F0
        mov     byte [rax+43H], 16                      ; 052A _ C6. 40, 43, 10
        mov     rax, qword [rbp-10H]                    ; 052E _ 48: 8B. 45, F0
        mov     eax, dword [rax+34H]                    ; 0532 _ 8B. 40, 34
        or      eax, 02H                                ; 0535 _ 83. C8, 02
        mov     edx, eax                                ; 0538 _ 89. C2
        mov     rax, qword [rbp-10H]                    ; 053A _ 48: 8B. 45, F0
        mov     dword [rax+34H], edx                    ; 053E _ 89. 50, 34
        jmp     ?_041                                   ; 0541 _ EB, 4F

?_038:  mov     rax, qword [rbp-10H]                    ; 0543 _ 48: 8B. 45, F0
        mov     byte [rax+43H], 32                      ; 0547 _ C6. 40, 43, 20
        mov     rax, qword [rbp-10H]                    ; 054B _ 48: 8B. 45, F0
        mov     eax, dword [rax+34H]                    ; 054F _ 8B. 40, 34
        or      eax, 02H                                ; 0552 _ 83. C8, 02
        mov     edx, eax                                ; 0555 _ 89. C2
        mov     rax, qword [rbp-10H]                    ; 0557 _ 48: 8B. 45, F0
        mov     dword [rax+34H], edx                    ; 055B _ 89. 50, 34
        jmp     ?_041                                   ; 055E _ EB, 32

?_039:  mov     rax, qword [rbp-10H]                    ; 0560 _ 48: 8B. 45, F0
        mov     byte [rax+43H], 64                      ; 0564 _ C6. 40, 43, 40
        mov     rax, qword [rbp-10H]                    ; 0568 _ 48: 8B. 45, F0
        mov     eax, dword [rax+34H]                    ; 056C _ 8B. 40, 34
        or      eax, 02H                                ; 056F _ 83. C8, 02
        mov     edx, eax                                ; 0572 _ 89. C2
        mov     rax, qword [rbp-10H]                    ; 0574 _ 48: 8B. 45, F0
        mov     dword [rax+34H], edx                    ; 0578 _ 89. 50, 34
        jmp     ?_041                                   ; 057B _ EB, 15

?_040:  lea     rax, [rel ?_361]                        ; 057D _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 0584 _ 48: 89. C7
        mov     eax, 0                                  ; 0587 _ B8, 00000000
        call    nasm_nonfatal                           ; 058C _ E8, 00000000(PLT r)
        nop                                             ; 0591 _ 90
?_041:  nop                                             ; 0592 _ 90
        leave                                           ; 0593 _ C9
        ret                                             ; 0594 _ C3

parse_decorators:; Local function
        push    rbp                                     ; 0595 _ 55
        mov     rbp, rsp                                ; 0596 _ 48: 89. E5
        sub     rsp, 32                                 ; 0599 _ 48: 83. EC, 20
        mov     qword [rbp-18H], rdi                    ; 059D _ 48: 89. 7D, E8
        mov     eax, dword [rel ?_354]                  ; 05A1 _ 8B. 05, 00000000(rel)
        mov     dword [rbp-8H], eax                     ; 05A7 _ 89. 45, F8
?_042:  cmp     dword [rbp-8H], 287                     ; 05AA _ 81. 7D, F8, 0000011F
        jz      ?_043                                   ; 05B1 _ 74, 40
        cmp     dword [rbp-8H], 287                     ; 05B3 _ 81. 7D, F8, 0000011F
        jg      ?_051                                   ; 05BA _ 0F 8F, 0000013B
        cmp     dword [rbp-8H], 284                     ; 05C0 _ 81. 7D, F8, 0000011C
        je      ?_045                                   ; 05C7 _ 0F 84, 000000A5
        cmp     dword [rbp-8H], 284                     ; 05CD _ 81. 7D, F8, 0000011C
        jg      ?_051                                   ; 05D4 _ 0F 8F, 00000121
        cmp     dword [rbp-8H], 0                       ; 05DA _ 83. 7D, F8, 00
        je      ?_050                                   ; 05DE _ 0F 84, 00000110
        cmp     dword [rbp-8H], 44                      ; 05E4 _ 83. 7D, F8, 2C
        je      ?_050                                   ; 05E8 _ 0F 84, 00000106
        jmp     ?_051                                   ; 05EE _ E9, 00000108

?_043:  mov     rax, qword [rbp-18H]                    ; 05F3 _ 48: 8B. 45, E8
        movzx   eax, word [rax]                         ; 05F7 _ 0F B7. 00
        movzx   eax, ax                                 ; 05FA _ 0F B7. C0
        and     eax, 0FH                                ; 05FD _ 83. E0, 0F
        test    rax, rax                                ; 0600 _ 48: 85. C0
        jz      ?_044                                   ; 0603 _ 74, 3A
        mov     rax, qword [rbp-18H]                    ; 0605 _ 48: 8B. 45, E8
        movzx   eax, word [rax]                         ; 0609 _ 0F B7. 00
        movzx   eax, ax                                 ; 060C _ 0F B7. C0
        and     eax, 0FH                                ; 060F _ 83. E0, 0F
        mov     rdx, rax                                ; 0612 _ 48: 89. C2
        lea     rax, [rel ?_362]                        ; 0615 _ 48: 8D. 05, 00000000(rel)
        mov     rsi, rdx                                ; 061C _ 48: 89. D6
        mov     rdi, rax                                ; 061F _ 48: 89. C7
        mov     eax, 0                                  ; 0622 _ B8, 00000000
        call    nasm_nonfatal                           ; 0627 _ E8, 00000000(PLT r)
        mov     rax, qword [rbp-18H]                    ; 062C _ 48: 8B. 45, E8
        movzx   eax, word [rax]                         ; 0630 _ 0F B7. 00
        and     eax, 0FFFFFFF0H                         ; 0633 _ 83. E0, F0
        mov     edx, eax                                ; 0636 _ 89. C2
        mov     rax, qword [rbp-18H]                    ; 0638 _ 48: 8B. 45, E8
        mov     word [rax], dx                          ; 063C _ 66: 89. 10
?_044:  mov     rax, qword [rbp-18H]                    ; 063F _ 48: 8B. 45, E8
        movzx   ecx, word [rax]                         ; 0643 _ 0F B7. 08
        mov     rax, qword [rel tokval]                 ; 0646 _ 48: 8B. 05, 00000000(rel)
        lea     rdx, [rax*4]                            ; 064D _ 48: 8D. 14 85, 00000000
        lea     rax, [rel nasm_regvals]                 ; 0655 _ 48: 8D. 05, 00000000(rel)
        mov     eax, dword [rdx+rax]                    ; 065C _ 8B. 04 02
        and     eax, 0FH                                ; 065F _ 83. E0, 0F
        or      ecx, eax                                ; 0662 _ 09. C1
        mov     edx, ecx                                ; 0664 _ 89. CA
        mov     rax, qword [rbp-18H]                    ; 0666 _ 48: 8B. 45, E8
        mov     word [rax], dx                          ; 066A _ 66: 89. 10
        jmp     ?_052                                   ; 066D _ E9, 000000A4

?_045:  mov     rax, qword [rel tokval]                 ; 0672 _ 48: 8B. 05, 00000000(rel)
        mov     dword [rbp-4H], eax                     ; 0679 _ 89. 45, FC
        cmp     dword [rbp-4H], 395                     ; 067C _ 81. 7D, FC, 0000018B
        jg      ?_046                                   ; 0683 _ 7F, 0B
        cmp     dword [rbp-4H], 391                     ; 0685 _ 81. 7D, FC, 00000187
        jge     ?_047                                   ; 068C _ 7D, 20
        jmp     ?_048                                   ; 068E _ EB, 43

?_046:  cmp     dword [rbp-4H], 401                     ; 0690 _ 81. 7D, FC, 00000191
        jnz     ?_048                                   ; 0697 _ 75, 3A
        mov     rax, qword [rbp-18H]                    ; 0699 _ 48: 8B. 45, E8
        movzx   eax, word [rax]                         ; 069D _ 0F B7. 00
        or      eax, 10H                                ; 06A0 _ 83. C8, 10
        mov     edx, eax                                ; 06A3 _ 89. C2
        mov     rax, qword [rbp-18H]                    ; 06A5 _ 48: 8B. 45, E8
        mov     word [rax], dx                          ; 06A9 _ 66: 89. 10
        jmp     ?_049                                   ; 06AC _ EB, 44

?_047:  mov     rax, qword [rbp-18H]                    ; 06AE _ 48: 8B. 45, E8
        movzx   edx, word [rax]                         ; 06B2 _ 0F B7. 10
        mov     eax, dword [rbp-4H]                     ; 06B5 _ 8B. 45, FC
; Note: Length-changing prefix causes delay on old Intel processors
        sub     ax, 391                                 ; 06B8 _ 66: 2D, 0187
        shl     eax, 12                                 ; 06BC _ C1. E0, 0C
; Note: Length-changing prefix causes delay on old Intel processors
        and     ax, 7000H                               ; 06BF _ 66: 25, 7000
        or      eax, edx                                ; 06C3 _ 09. D0
        or      eax, 20H                                ; 06C5 _ 83. C8, 20
        mov     edx, eax                                ; 06C8 _ 89. C2
        mov     rax, qword [rbp-18H]                    ; 06CA _ 48: 8B. 45, E8
        mov     word [rax], dx                          ; 06CE _ 66: 89. 10
        jmp     ?_049                                   ; 06D1 _ EB, 1F

?_048:  mov     rax, qword [rel ?_351]                  ; 06D3 _ 48: 8B. 05, 00000000(rel)
        lea     rdx, [rel ?_363]                        ; 06DA _ 48: 8D. 15, 00000000(rel)
        mov     rsi, rax                                ; 06E1 _ 48: 89. C6
        mov     rdi, rdx                                ; 06E4 _ 48: 89. D7
        mov     eax, 0                                  ; 06E7 _ B8, 00000000
        call    nasm_nonfatal                           ; 06EC _ E8, 00000000(PLT r)
        nop                                             ; 06F1 _ 90
?_049:  jmp     ?_052                                   ; 06F2 _ EB, 22

?_050:  mov     eax, 0                                  ; 06F4 _ B8, 00000000
        jmp     ?_053                                   ; 06F9 _ EB, 37

?_051:  lea     rax, [rel ?_364]                        ; 06FB _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 0702 _ 48: 89. C7
        mov     eax, 0                                  ; 0705 _ B8, 00000000
        call    nasm_nonfatal                           ; 070A _ E8, 00000000(PLT r)
        mov     eax, 1                                  ; 070F _ B8, 00000001
        jmp     ?_053                                   ; 0714 _ EB, 1C

?_052:  lea     rax, [rel tokval]                       ; 0716 _ 48: 8D. 05, 00000000(rel)
        mov     rsi, rax                                ; 071D _ 48: 89. C6
        mov     edi, 0                                  ; 0720 _ BF, 00000000
        call    stdscan                                 ; 0725 _ E8, 00000000(PLT r)
        mov     dword [rbp-8H], eax                     ; 072A _ 89. 45, F8
        jmp     ?_042                                   ; 072D _ E9, FFFFFE78

?_053:  ; Local function
        leave                                           ; 0732 _ C9
        ret                                             ; 0733 _ C3

init_operand:; Local function
        push    rbp                                     ; 0734 _ 55
        mov     rbp, rsp                                ; 0735 _ 48: 89. E5
        sub     rsp, 16                                 ; 0738 _ 48: 83. EC, 10
        mov     qword [rbp-8H], rdi                     ; 073C _ 48: 89. 7D, F8
        mov     dword [rbp-0CH], esi                    ; 0740 _ 89. 75, F4
        mov     rax, qword [rbp-8H]                     ; 0743 _ 48: 8B. 45, F8
        mov     edx, 72                                 ; 0747 _ BA, 00000048
        mov     esi, 0                                  ; 074C _ BE, 00000000
        mov     rdi, rax                                ; 0751 _ 48: 89. C7
        call    memset                                  ; 0754 _ E8, 00000000(PLT r)
        mov     rax, qword [rbp-8H]                     ; 0759 _ 48: 8B. 45, F8
        mov     dword [rax+10H], -1                     ; 075D _ C7. 40, 10, FFFFFFFF
        mov     rax, qword [rbp-8H]                     ; 0764 _ 48: 8B. 45, F8
        mov     dword [rax+14H], -1                     ; 0768 _ C7. 40, 14, FFFFFFFF
        mov     rax, qword [rbp-8H]                     ; 076F _ 48: 8B. 45, F8
        mov     dword [rax+24H], -1                     ; 0773 _ C7. 40, 24, FFFFFFFF
        mov     rax, qword [rbp-8H]                     ; 077A _ 48: 8B. 45, F8
        mov     dword [rax+30H], -1                     ; 077E _ C7. 40, 30, FFFFFFFF
        mov     eax, dword [rbp-0CH]                    ; 0785 _ 8B. 45, F4
        mov     edx, eax                                ; 0788 _ 89. C2
        mov     rax, qword [rbp-8H]                     ; 078A _ 48: 8B. 45, F8
        mov     byte [rax+44H], dl                      ; 078E _ 88. 50, 44
        nop                                             ; 0791 _ 90
        leave                                           ; 0792 _ C9
        ret                                             ; 0793 _ C3

parse_mref:; Local function
        push    rbp                                     ; 0794 _ 55
        mov     rbp, rsp                                ; 0795 _ 48: 89. E5
        sub     rsp, 48                                 ; 0798 _ 48: 83. EC, 30
        mov     qword [rbp-28H], rdi                    ; 079C _ 48: 89. 7D, D8
        mov     qword [rbp-30H], rsi                    ; 07A0 _ 48: 89. 75, D0
        mov     rax, qword [rbp-28H]                    ; 07A4 _ 48: 8B. 45, D8
        mov     eax, dword [rax+10H]                    ; 07A8 _ 8B. 40, 10
        mov     dword [rbp-1CH], eax                    ; 07AB _ 89. 45, E4
        mov     rax, qword [rbp-28H]                    ; 07AE _ 48: 8B. 45, D8
        mov     eax, dword [rax+14H]                    ; 07B2 _ 8B. 40, 14
        mov     dword [rbp-18H], eax                    ; 07B5 _ 89. 45, E8
        mov     rax, qword [rbp-28H]                    ; 07B8 _ 48: 8B. 45, D8
        mov     eax, dword [rax+18H]                    ; 07BC _ 8B. 40, 18
        mov     dword [rbp-14H], eax                    ; 07BF _ 89. 45, EC
        mov     rax, qword [rbp-28H]                    ; 07C2 _ 48: 8B. 45, D8
        mov     rax, qword [rax+28H]                    ; 07C6 _ 48: 8B. 40, 28
        mov     qword [rbp-10H], rax                    ; 07CA _ 48: 89. 45, F0
        jmp     ?_070                                   ; 07CE _ E9, 0000023D

?_054:  mov     rax, qword [rbp-30H]                    ; 07D3 _ 48: 8B. 45, D0
        mov     rax, qword [rax+8H]                     ; 07D7 _ 48: 8B. 40, 08
        test    rax, rax                                ; 07DB _ 48: 85. C0
        je      ?_068                                   ; 07DE _ 0F 84, 00000226
        mov     rax, qword [rbp-30H]                    ; 07E4 _ 48: 8B. 45, D0
        mov     eax, dword [rax]                        ; 07E8 _ 8B. 00
        cmp     eax, 344                                ; 07EA _ 3D, 00000158
        jg      ?_060                                   ; 07EF _ 0F 8F, 000000D5
        mov     rax, qword [rbp-30H]                    ; 07F5 _ 48: 8B. 45, D0
        mov     eax, dword [rax]                        ; 07F9 _ 8B. 00
        cdqe                                            ; 07FB _ 48: 98
        lea     rdx, [rax*8]                            ; 07FD _ 48: 8D. 14 C5, 00000000
        lea     rax, [rel nasm_reg_flags]               ; 0805 _ 48: 8D. 05, 00000000(rel)
        mov     rax, qword [rdx+rax]                    ; 080C _ 48: 8B. 04 02
        mov     qword [rbp-8H], rax                     ; 0810 _ 48: 89. 45, F8
        mov     rax, qword [rbp-8H]                     ; 0814 _ 48: 8B. 45, F8
        mov     rsi, rax                                ; 0818 _ 48: 89. C6
        mov     edi, 261                                ; 081B _ BF, 00000105
        call    is_class                                ; 0820 _ E8, FFFFF7DB
        mov     byte [rbp-1DH], al                      ; 0825 _ 88. 45, E3
        cmp     byte [rbp-1DH], 0                       ; 0828 _ 80. 7D, E3, 00
        jz      ?_055                                   ; 082C _ 74, 22
        mov     rax, qword [rbp-30H]                    ; 082E _ 48: 8B. 45, D0
        mov     rax, qword [rax+8H]                     ; 0832 _ 48: 8B. 40, 08
        cmp     rax, 1                                  ; 0836 _ 48: 83. F8, 01
        jnz     ?_055                                   ; 083A _ 75, 14
        cmp     dword [rbp-1CH], -1                     ; 083C _ 83. 7D, E4, FF
        jnz     ?_055                                   ; 0840 _ 75, 0E
        mov     rax, qword [rbp-30H]                    ; 0842 _ 48: 8B. 45, D0
        mov     eax, dword [rax]                        ; 0846 _ 8B. 00
        mov     dword [rbp-1CH], eax                    ; 0848 _ 89. 45, E4
        jmp     ?_069                                   ; 084B _ E9, 000001BB

?_055:  cmp     dword [rbp-18H], -1                     ; 0850 _ 83. 7D, E8, FF
        jnz     ?_056                                   ; 0854 _ 75, 19
        mov     rax, qword [rbp-30H]                    ; 0856 _ 48: 8B. 45, D0
        mov     eax, dword [rax]                        ; 085A _ 8B. 00
        mov     dword [rbp-18H], eax                    ; 085C _ 89. 45, E8
        mov     rax, qword [rbp-30H]                    ; 085F _ 48: 8B. 45, D0
        mov     rax, qword [rax+8H]                     ; 0863 _ 48: 8B. 40, 08
        mov     dword [rbp-14H], eax                    ; 0867 _ 89. 45, EC
        jmp     ?_069                                   ; 086A _ E9, 0000019C

?_056:  cmp     dword [rbp-1CH], -1                     ; 086F _ 83. 7D, E4, FF
        jnz     ?_057                                   ; 0873 _ 75, 16
        lea     rax, [rel ?_365]                        ; 0875 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 087C _ 48: 89. C7
        mov     eax, 0                                  ; 087F _ B8, 00000000
        call    nasm_nonfatal                           ; 0884 _ E8, 00000000(PLT r)
        jmp     ?_059                                   ; 0889 _ EB, 35

?_057:  movzx   eax, byte [rbp-1DH]                     ; 088B _ 0F B6. 45, E3
        xor     eax, 01H                                ; 088F _ 83. F0, 01
        test    al, al                                  ; 0892 _ 84. C0
        jz      ?_058                                   ; 0894 _ 74, 16
        lea     rax, [rel ?_366]                        ; 0896 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 089D _ 48: 89. C7
        mov     eax, 0                                  ; 08A0 _ B8, 00000000
        call    nasm_nonfatal                           ; 08A5 _ E8, 00000000(PLT r)
        jmp     ?_059                                   ; 08AA _ EB, 14

?_058:  lea     rax, [rel ?_367]                        ; 08AC _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 08B3 _ 48: 89. C7
        mov     eax, 0                                  ; 08B6 _ B8, 00000000
        call    nasm_nonfatal                           ; 08BB _ E8, 00000000(PLT r)
?_059:  mov     eax, 4294967295                         ; 08C0 _ B8, FFFFFFFF
        jmp     ?_071                                   ; 08C5 _ E9, 00000183

?_060:  mov     rax, qword [rbp-30H]                    ; 08CA _ 48: 8B. 45, D0
        mov     eax, dword [rax]                        ; 08CE _ 8B. 00
        cmp     eax, 345                                ; 08D0 _ 3D, 00000159
        jnz     ?_061                                   ; 08D5 _ 75, 18
        mov     rax, qword [rbp-28H]                    ; 08D7 _ 48: 8B. 45, D8
        mov     eax, dword [rax+38H]                    ; 08DB _ 8B. 40, 38
        or      eax, 04H                                ; 08DE _ 83. C8, 04
        mov     edx, eax                                ; 08E1 _ 89. C2
        mov     rax, qword [rbp-28H]                    ; 08E3 _ 48: 8B. 45, D8
        mov     dword [rax+38H], edx                    ; 08E7 _ 89. 50, 38
        jmp     ?_069                                   ; 08EA _ E9, 0000011C

?_061:  mov     rax, qword [rbp-30H]                    ; 08EF _ 48: 8B. 45, D0
        mov     eax, dword [rax]                        ; 08F3 _ 8B. 00
        cmp     eax, 346                                ; 08F5 _ 3D, 0000015A
        jnz     ?_062                                   ; 08FA _ 75, 11
        mov     rax, qword [rbp-30H]                    ; 08FC _ 48: 8B. 45, D0
        mov     rax, qword [rax+8H]                     ; 0900 _ 48: 8B. 40, 08
        add     qword [rbp-10H], rax                    ; 0904 _ 48: 01. 45, F0
        jmp     ?_069                                   ; 0908 _ E9, 000000FE

?_062:  mov     rax, qword [rbp-30H]                    ; 090D _ 48: 8B. 45, D0
        mov     eax, dword [rax]                        ; 0911 _ 8B. 00
        cmp     eax, 347                                ; 0913 _ 3D, 0000015B
        jnz     ?_063                                   ; 0918 _ 75, 16
        mov     rax, qword [rbp-30H]                    ; 091A _ 48: 8B. 45, D0
        mov     rax, qword [rax+8H]                     ; 091E _ 48: 8B. 40, 08
        mov     edx, eax                                ; 0922 _ 89. C2
        mov     rax, qword [rbp-28H]                    ; 0924 _ 48: 8B. 45, D8
        mov     dword [rax+30H], edx                    ; 0928 _ 89. 50, 30
        jmp     ?_069                                   ; 092B _ E9, 000000DB

?_063:  mov     rax, qword [rbp-30H]                    ; 0930 _ 48: 8B. 45, D0
        mov     eax, dword [rax]                        ; 0934 _ 8B. 00
        cmp     eax, 348                                ; 0936 _ 3D, 0000015C
        jle     ?_067                                   ; 093B _ 0F 8E, 000000AE
        mov     rax, qword [rbp-30H]                    ; 0941 _ 48: 8B. 45, D0
        mov     rax, qword [rax+8H]                     ; 0945 _ 48: 8B. 40, 08
        cmp     rax, 1                                  ; 0949 _ 48: 83. F8, 01
        jnz     ?_065                                   ; 094D _ 75, 3F
        mov     rax, qword [rbp-28H]                    ; 094F _ 48: 8B. 45, D8
        mov     eax, dword [rax+24H]                    ; 0953 _ 8B. 40, 24
        cmp     eax, -1                                 ; 0956 _ 83. F8, FF
        jz      ?_064                                   ; 0959 _ 74, 1E
        lea     rax, [rel ?_368]                        ; 095B _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 0962 _ 48: 89. C7
        mov     eax, 0                                  ; 0965 _ B8, 00000000
        call    nasm_nonfatal                           ; 096A _ E8, 00000000(PLT r)
        mov     eax, 4294967295                         ; 096F _ B8, FFFFFFFF
        jmp     ?_071                                   ; 0974 _ E9, 000000D4

?_064:  mov     rax, qword [rbp-30H]                    ; 0979 _ 48: 8B. 45, D0
        mov     eax, dword [rax]                        ; 097D _ 8B. 00
        lea     edx, [rax-15DH]                         ; 097F _ 8D. 90, FFFFFEA3
        mov     rax, qword [rbp-28H]                    ; 0985 _ 48: 8B. 45, D8
        mov     dword [rax+24H], edx                    ; 0989 _ 89. 50, 24
        jmp     ?_069                                   ; 098C _ EB, 7D

?_065:  mov     rax, qword [rbp-30H]                    ; 098E _ 48: 8B. 45, D0
        mov     rax, qword [rax+8H]                     ; 0992 _ 48: 8B. 40, 08
        cmp     rax, -1                                 ; 0996 _ 48: 83. F8, FF
        jnz     ?_066                                   ; 099A _ 75, 38
        mov     rax, qword [rbp-30H]                    ; 099C _ 48: 8B. 45, D0
        mov     edx, dword [rax]                        ; 09A0 _ 8B. 10
        mov     eax, dword [rel location+8H]            ; 09A2 _ 8B. 05, 00000000(rel)
        add     eax, 349                                ; 09A8 _ 05, 0000015D
        cmp     edx, eax                                ; 09AD _ 39. C2
        jnz     ?_066                                   ; 09AF _ 75, 23
        mov     rax, qword [rbp-28H]                    ; 09B1 _ 48: 8B. 45, D8
        mov     eax, dword [rax+38H]                    ; 09B5 _ 8B. 40, 38
        and     eax, 08H                                ; 09B8 _ 83. E0, 08
        test    eax, eax                                ; 09BB _ 85. C0
        jnz     ?_066                                   ; 09BD _ 75, 15
        mov     rax, qword [rbp-28H]                    ; 09BF _ 48: 8B. 45, D8
        mov     eax, dword [rax+38H]                    ; 09C3 _ 8B. 40, 38
        or      eax, 08H                                ; 09C6 _ 83. C8, 08
        mov     edx, eax                                ; 09C9 _ 89. C2
        mov     rax, qword [rbp-28H]                    ; 09CB _ 48: 8B. 45, D8
        mov     dword [rax+38H], edx                    ; 09CF _ 89. 50, 38
        jmp     ?_069                                   ; 09D2 _ EB, 37

?_066:  lea     rax, [rel ?_369]                        ; 09D4 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 09DB _ 48: 89. C7
        mov     eax, 0                                  ; 09DE _ B8, 00000000
        call    nasm_nonfatal                           ; 09E3 _ E8, 00000000(PLT r)
        mov     eax, 4294967295                         ; 09E8 _ B8, FFFFFFFF
        jmp     ?_071                                   ; 09ED _ EB, 5E

?_067:  lea     rax, [rel ?_370]                        ; 09EF _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 09F6 _ 48: 89. C7
        mov     eax, 0                                  ; 09F9 _ B8, 00000000
        call    nasm_nonfatal                           ; 09FE _ E8, 00000000(PLT r)
        mov     eax, 4294967295                         ; 0A03 _ B8, FFFFFFFF
        jmp     ?_071                                   ; 0A08 _ EB, 43

?_068:  nop                                             ; 0A0A _ 90
?_069:  add     qword [rbp-30H], 16                     ; 0A0B _ 48: 83. 45, D0, 10
?_070:  mov     rax, qword [rbp-30H]                    ; 0A10 _ 48: 8B. 45, D0
        mov     eax, dword [rax]                        ; 0A14 _ 8B. 00
        test    eax, eax                                ; 0A16 _ 85. C0
        jne     ?_054                                   ; 0A18 _ 0F 85, FFFFFDB5
        mov     rax, qword [rbp-28H]                    ; 0A1E _ 48: 8B. 45, D8
        mov     edx, dword [rbp-1CH]                    ; 0A22 _ 8B. 55, E4
        mov     dword [rax+10H], edx                    ; 0A25 _ 89. 50, 10
        mov     rax, qword [rbp-28H]                    ; 0A28 _ 48: 8B. 45, D8
        mov     edx, dword [rbp-18H]                    ; 0A2C _ 8B. 55, E8
        mov     dword [rax+14H], edx                    ; 0A2F _ 89. 50, 14
        mov     rax, qword [rbp-28H]                    ; 0A32 _ 48: 8B. 45, D8
        mov     edx, dword [rbp-14H]                    ; 0A36 _ 8B. 55, EC
        mov     dword [rax+18H], edx                    ; 0A39 _ 89. 50, 18
        mov     rax, qword [rbp-28H]                    ; 0A3C _ 48: 8B. 45, D8
        mov     rdx, qword [rbp-10H]                    ; 0A40 _ 48: 8B. 55, F0
        mov     qword [rax+28H], rdx                    ; 0A44 _ 48: 89. 50, 28
        mov     eax, 0                                  ; 0A48 _ B8, 00000000
?_071:  leave                                           ; 0A4D _ C9
        ret                                             ; 0A4E _ C3

mref_set_optype:; Local function
        push    rbp                                     ; 0A4F _ 55
        mov     rbp, rsp                                ; 0A50 _ 48: 89. E5
        sub     rsp, 64                                 ; 0A53 _ 48: 83. EC, 40
        mov     qword [rbp-38H], rdi                    ; 0A57 _ 48: 89. 7D, C8
        mov     rax, qword [rbp-38H]                    ; 0A5B _ 48: 8B. 45, C8
        mov     eax, dword [rax+10H]                    ; 0A5F _ 8B. 40, 10
        mov     dword [rbp-30H], eax                    ; 0A62 _ 89. 45, D0
        mov     rax, qword [rbp-38H]                    ; 0A65 _ 48: 8B. 45, C8
        mov     eax, dword [rax+14H]                    ; 0A69 _ 8B. 40, 14
        mov     dword [rbp-2CH], eax                    ; 0A6C _ 89. 45, D4
        mov     rax, qword [rbp-38H]                    ; 0A6F _ 48: 8B. 45, C8
        mov     eax, dword [rax+18H]                    ; 0A73 _ 8B. 40, 18
        mov     dword [rbp-28H], eax                    ; 0A76 _ 89. 45, D8
        mov     rax, qword [rbp-38H]                    ; 0A79 _ 48: 8B. 45, C8
        mov     rax, qword [rax]                        ; 0A7D _ 48: 8B. 00
        or      rax, 7001F90CH                          ; 0A80 _ 48: 0D, 7001F90C
        mov     rdx, rax                                ; 0A86 _ 48: 89. C2
        mov     rax, qword [rbp-38H]                    ; 0A89 _ 48: 8B. 45, C8
        mov     qword [rax], rdx                        ; 0A8D _ 48: 89. 10
        cmp     dword [rbp-2CH], -1                     ; 0A90 _ 83. 7D, D4, FF
        setne   al                                      ; 0A94 _ 0F 95. C0
        movzx   eax, al                                 ; 0A97 _ 0F B6. C0
        test    rax, rax                                ; 0A9A _ 48: 85. C0
        jz      ?_072                                   ; 0A9D _ 74, 31
        cmp     dword [rbp-28H], 0                      ; 0A9F _ 83. 7D, D8, 00
        setle   al                                      ; 0AA3 _ 0F 9E. C0
        movzx   eax, al                                 ; 0AA6 _ 0F B6. C0
        test    rax, rax                                ; 0AA9 _ 48: 85. C0
        jz      ?_072                                   ; 0AAC _ 74, 22
        lea     rdx, [rel ?_371]                        ; 0AAE _ 48: 8D. 15, 00000000(rel)
        lea     rsi, [rel __func__.1]                   ; 0AB5 _ 48: 8D. 35, 00000000(rel)
        lea     rax, [rel ?_372]                        ; 0ABC _ 48: 8D. 05, 00000000(rel)
        mov     ecx, 283                                ; 0AC3 _ B9, 0000011B
        mov     rdi, rax                                ; 0AC8 _ 48: 89. C7
        call    nasm_assert_failed                      ; 0ACB _ E8, 00000000(PLT r)
?_072:  mov     rax, qword [rbp-38H]                    ; 0AD0 _ 48: 8B. 45, C8
        mov     eax, dword [rax+34H]                    ; 0AD4 _ 8B. 40, 34
        and     eax, 300H                               ; 0AD7 _ 25, 00000300
        test    eax, eax                                ; 0ADC _ 85. C0
        jnz     ?_073                                   ; 0ADE _ 75, 12
        mov     rax, qword [rbp-38H]                    ; 0AE0 _ 48: 8B. 45, C8
        mov     eax, dword [rax+34H]                    ; 0AE4 _ 8B. 40, 34
        or      al, 80H                                 ; 0AE7 _ 0C, 80
        mov     edx, eax                                ; 0AE9 _ 89. C2
        mov     rax, qword [rbp-38H]                    ; 0AEB _ 48: 8B. 45, C8
        mov     dword [rax+34H], edx                    ; 0AEF _ 89. 50, 34
?_073:  cmp     dword [rbp-30H], -1                     ; 0AF2 _ 83. 7D, D0, FF
        jz      ?_074                                   ; 0AF6 _ 74, 3C
        mov     eax, dword [rbp-30H]                    ; 0AF8 _ 8B. 45, D0
        cdqe                                            ; 0AFB _ 48: 98
        lea     rdx, [rax*8]                            ; 0AFD _ 48: 8D. 14 C5, 00000000
        lea     rax, [rel nasm_reg_flags]               ; 0B05 _ 48: 8D. 05, 00000000(rel)
        mov     rax, qword [rdx+rax]                    ; 0B0C _ 48: 8B. 04 02
        mov     qword [rbp-18H], rax                    ; 0B10 _ 48: 89. 45, E8
        mov     rax, qword [rbp-38H]                    ; 0B14 _ 48: 8B. 45, C8
        mov     rdx, qword [rax]                        ; 0B18 _ 48: 8B. 10
        mov     rax, qword [rbp-18H]                    ; 0B1B _ 48: 8B. 45, E8
        or      rax, 0FFFFFFFFEFFFFFFFH                 ; 0B1F _ 48: 0D, EFFFFFFF
        and     rdx, rax                                ; 0B25 _ 48: 21. C2
        mov     rax, qword [rbp-38H]                    ; 0B28 _ 48: 8B. 45, C8
        mov     qword [rax], rdx                        ; 0B2C _ 48: 89. 10
        jmp     ?_079                                   ; 0B2F _ E9, 000000E3

?_074:  cmp     dword [rbp-2CH], -1                     ; 0B34 _ 83. 7D, D4, FF
        jne     ?_079                                   ; 0B38 _ 0F 85, 000000D9
        mov     qword [rbp-20H], 262156                 ; 0B3E _ 48: C7. 45, E0, 0004000C
        mov     eax, dword [rel globl]                  ; 0B46 _ 8B. 05, 00000000(rel)
        cmp     eax, 64                                 ; 0B4C _ 83. F8, 40
        jne     ?_078                                   ; 0B4F _ 0F 85, 000000AD
        mov     rax, qword [rbp-38H]                    ; 0B55 _ 48: 8B. 45, C8
        mov     eax, dword [rax+34H]                    ; 0B59 _ 8B. 40, 34
        and     eax, 10H                                ; 0B5C _ 83. E0, 10
        test    eax, eax                                ; 0B5F _ 85. C0
        jne     ?_078                                   ; 0B61 _ 0F 85, 0000009B
        mov     rax, qword [rbp-38H]                    ; 0B67 _ 48: 8B. 45, C8
        mov     eax, dword [rax+34H]                    ; 0B6B _ 8B. 40, 34
        and     eax, 08H                                ; 0B6E _ 83. E0, 08
        test    eax, eax                                ; 0B71 _ 85. C0
        jz      ?_075                                   ; 0B73 _ 74, 0D
        mov     qword [rbp-20H], 524300                 ; 0B75 _ 48: C7. 45, E0, 0008000C
        jmp     ?_078                                   ; 0B7D _ E9, 00000080

?_075:  mov     edx, dword [rel globl+4H]               ; 0B82 _ 8B. 15, 00000000(rel)
        mov     rax, qword [rbp-38H]                    ; 0B88 _ 48: 8B. 45, C8
        mov     eax, dword [rax+34H]                    ; 0B8C _ 8B. 40, 34
        and     eax, edx                                ; 0B8F _ 21. D0
        test    eax, eax                                ; 0B91 _ 85. C0
        jz      ?_076                                   ; 0B93 _ 74, 08
        mov     qword [rbp-20H], 524300                 ; 0B95 _ 48: C7. 45, E0, 0008000C
?_076:  mov     edx, dword [rel globl+8H]               ; 0B9D _ 8B. 15, 00000000(rel)
        mov     rax, qword [rbp-38H]                    ; 0BA3 _ 48: 8B. 45, C8
        mov     eax, dword [rax+34H]                    ; 0BA7 _ 8B. 40, 34
        and     eax, edx                                ; 0BAA _ 21. D0
        test    eax, eax                                ; 0BAC _ 85. C0
        jnz     ?_078                                   ; 0BAE _ 75, 52
        call    pass_count                              ; 0BB0 _ E8, FFFFF542
        mov     rdx, rax                                ; 0BB5 _ 48: 89. C2
        mov     rax, qword [rel pass_last_seen.0]       ; 0BB8 _ 48: 8B. 05, 00000000(rel)
        cmp     rdx, rax                                ; 0BBF _ 48: 39. C2
        jz      ?_078                                   ; 0BC2 _ 74, 3E
        mov     dword [rbp-24H], 655360                 ; 0BC4 _ C7. 45, DC, 000A0000
        mov     eax, dword [rbp-24H]                    ; 0BCB _ 8B. 45, DC
        mov     edi, eax                                ; 0BCE _ 89. C7
        call    warn_active                             ; 0BD0 _ E8, FFFFF4C1
        movzx   eax, al                                 ; 0BD5 _ 0F B6. C0
        test    rax, rax                                ; 0BD8 _ 48: 85. C0
        jz      ?_077                                   ; 0BDB _ 74, 19
        lea     rdx, [rel ?_373]                        ; 0BDD _ 48: 8D. 15, 00000000(rel)
        mov     eax, dword [rbp-24H]                    ; 0BE4 _ 8B. 45, DC
        mov     rsi, rdx                                ; 0BE7 _ 48: 89. D6
        mov     edi, eax                                ; 0BEA _ 89. C7
        mov     eax, 0                                  ; 0BEC _ B8, 00000000
        call    nasm_warn_                              ; 0BF1 _ E8, 00000000(PLT r)
?_077:  call    pass_count                              ; 0BF6 _ E8, FFFFF4FC
        mov     qword [rel pass_last_seen.0], rax       ; 0BFB _ 48: 89. 05, 00000000(rel)
?_078:  mov     rax, qword [rbp-38H]                    ; 0C02 _ 48: 8B. 45, C8
        mov     rax, qword [rax]                        ; 0C06 _ 48: 8B. 00
        or      rax, qword [rbp-20H]                    ; 0C09 _ 48: 0B. 45, E0
        mov     rdx, rax                                ; 0C0D _ 48: 89. C2
        mov     rax, qword [rbp-38H]                    ; 0C10 _ 48: 8B. 45, C8
        mov     qword [rax], rdx                        ; 0C14 _ 48: 89. 10
?_079:  cmp     dword [rbp-2CH], -1                     ; 0C17 _ 83. 7D, D4, FF
        je      ?_082                                   ; 0C1B _ 0F 84, 000000BF
        mov     eax, dword [rbp-2CH]                    ; 0C21 _ 8B. 45, D4
        cdqe                                            ; 0C24 _ 48: 98
        lea     rdx, [rax*8]                            ; 0C26 _ 48: 8D. 14 C5, 00000000
        lea     rax, [rel nasm_reg_flags]               ; 0C2E _ 48: 8D. 05, 00000000(rel)
        mov     rax, qword [rdx+rax]                    ; 0C35 _ 48: 8B. 04 02
        mov     qword [rbp-10H], rax                    ; 0C39 _ 48: 89. 45, F0
        mov     rax, qword [rbp-38H]                    ; 0C3D _ 48: 8B. 45, C8
        mov     rdx, qword [rax]                        ; 0C41 _ 48: 8B. 10
        mov     rax, qword [rbp-10H]                    ; 0C44 _ 48: 8B. 45, F0
        or      rax, 0FFFFFFFFEFFFFFFFH                 ; 0C48 _ 48: 0D, EFFFFFFF
        and     rdx, rax                                ; 0C4E _ 48: 21. C2
        mov     rax, qword [rbp-38H]                    ; 0C51 _ 48: 8B. 45, C8
        mov     qword [rax], rdx                        ; 0C55 _ 48: 89. 10
        mov     rax, qword [rbp-10H]                    ; 0C58 _ 48: 8B. 45, F0
        mov     rsi, rax                                ; 0C5C _ 48: 89. C6
        mov     edi, 4101                               ; 0C5F _ BF, 00001005
        call    is_class                                ; 0C64 _ E8, FFFFF397
        test    al, al                                  ; 0C69 _ 84. C0
        jz      ?_080                                   ; 0C6B _ 74, 19
        mov     rax, qword [rbp-38H]                    ; 0C6D _ 48: 8B. 45, C8
        mov     rax, qword [rax]                        ; 0C71 _ 48: 8B. 00
        or      rax, 10000CH                            ; 0C74 _ 48: 0D, 0010000C
        mov     rdx, rax                                ; 0C7A _ 48: 89. C2
        mov     rax, qword [rbp-38H]                    ; 0C7D _ 48: 8B. 45, C8
        mov     qword [rax], rdx                        ; 0C81 _ 48: 89. 10
        jmp     ?_082                                   ; 0C84 _ EB, 5A

?_080:  mov     rax, qword [rbp-10H]                    ; 0C86 _ 48: 8B. 45, F0
        mov     rsi, rax                                ; 0C8A _ 48: 89. C6
        mov     edi, 8197                               ; 0C8D _ BF, 00002005
        call    is_class                                ; 0C92 _ E8, FFFFF369
        test    al, al                                  ; 0C97 _ 84. C0
        jz      ?_081                                   ; 0C99 _ 74, 19
        mov     rax, qword [rbp-38H]                    ; 0C9B _ 48: 8B. 45, C8
        mov     rax, qword [rax]                        ; 0C9F _ 48: 8B. 00
        or      rax, 20000CH                            ; 0CA2 _ 48: 0D, 0020000C
        mov     rdx, rax                                ; 0CA8 _ 48: 89. C2
        mov     rax, qword [rbp-38H]                    ; 0CAB _ 48: 8B. 45, C8
        mov     qword [rax], rdx                        ; 0CAF _ 48: 89. 10
        jmp     ?_082                                   ; 0CB2 _ EB, 2C

?_081:  mov     rax, qword [rbp-10H]                    ; 0CB4 _ 48: 8B. 45, F0
        mov     rsi, rax                                ; 0CB8 _ 48: 89. C6
        mov     edi, 16389                              ; 0CBB _ BF, 00004005
        call    is_class                                ; 0CC0 _ E8, FFFFF33B
        test    al, al                                  ; 0CC5 _ 84. C0
        jz      ?_082                                   ; 0CC7 _ 74, 17
        mov     rax, qword [rbp-38H]                    ; 0CC9 _ 48: 8B. 45, C8
        mov     rax, qword [rax]                        ; 0CCD _ 48: 8B. 00
        or      rax, 40000CH                            ; 0CD0 _ 48: 0D, 0040000C
        mov     rdx, rax                                ; 0CD6 _ 48: 89. C2
        mov     rax, qword [rbp-38H]                    ; 0CD9 _ 48: 8B. 45, C8
        mov     qword [rax], rdx                        ; 0CDD _ 48: 89. 10
?_082:  mov     rax, qword [rbp-38H]                    ; 0CE0 _ 48: 8B. 45, C8
        mov     rax, qword [rax]                        ; 0CE4 _ 48: 8B. 00
        mov     rdx, qword 0FFFF00000000H               ; 0CE7 _ 48: BA, 0000FFFF00000000
        and     rax, rdx                                ; 0CF1 _ 48: 21. D0
        mov     qword [rbp-8H], rax                     ; 0CF4 _ 48: 89. 45, F8
        cmp     qword [rbp-8H], 0                       ; 0CF8 _ 48: 83. 7D, F8, 00
        jz      ?_083                                   ; 0CFD _ 74, 10
        mov     rax, qword 200000000H                   ; 0CFF _ 48: B8, 0000000200000000
        cmp     qword [rbp-8H], rax                     ; 0D09 _ 48: 39. 45, F8
        jnz     ?_084                                   ; 0D0D _ 75, 16
?_083:  mov     rax, qword [rbp-38H]                    ; 0D0F _ 48: 8B. 45, C8
        mov     rax, qword [rax]                        ; 0D13 _ 48: 8B. 00
        mov     edx, 2147483652                         ; 0D16 _ BA, 80000004
        or      rdx, rax                                ; 0D1B _ 48: 09. C2
        mov     rax, qword [rbp-38H]                    ; 0D1E _ 48: 8B. 45, C8
        mov     qword [rax], rdx                        ; 0D22 _ 48: 89. 10
?_084:  nop                                             ; 0D25 _ 90
        leave                                           ; 0D26 _ C9
        ret                                             ; 0D27 _ C3

value_to_extop:; Local function
        push    rbp                                     ; 0D28 _ 55
        mov     rbp, rsp                                ; 0D29 _ 48: 89. E5
        mov     qword [rbp-8H], rdi                     ; 0D2C _ 48: 89. 7D, F8
        mov     qword [rbp-10H], rsi                    ; 0D30 _ 48: 89. 75, F0
        mov     dword [rbp-14H], edx                    ; 0D34 _ 89. 55, EC
        mov     rax, qword [rbp-10H]                    ; 0D37 _ 48: 8B. 45, F0
        mov     dword [rax+28H], 5                      ; 0D3B _ C7. 40, 28, 00000005
        mov     rax, qword [rbp-10H]                    ; 0D42 _ 48: 8B. 45, F0
        mov     qword [rax+8H], 0                       ; 0D46 _ 48: C7. 40, 08, 00000000
        mov     rax, qword [rbp-10H]                    ; 0D4E _ 48: 8B. 45, F0
        mov     dword [rax+14H], -1                     ; 0D52 _ C7. 40, 14, FFFFFFFF
        mov     rax, qword [rbp-10H]                    ; 0D59 _ 48: 8B. 45, F0
        mov     edx, dword [rax+14H]                    ; 0D5D _ 8B. 50, 14
        mov     rax, qword [rbp-10H]                    ; 0D60 _ 48: 8B. 45, F0
        mov     dword [rax+10H], edx                    ; 0D64 _ 89. 50, 10
        mov     rax, qword [rbp-10H]                    ; 0D67 _ 48: 8B. 45, F0
        mov     byte [rax+18H], 0                       ; 0D6B _ C6. 40, 18, 00
        jmp     ?_094                                   ; 0D6F _ E9, 00000129

?_085:  mov     rax, qword [rbp-8H]                     ; 0D74 _ 48: 8B. 45, F8
        mov     rax, qword [rax+8H]                     ; 0D78 _ 48: 8B. 40, 08
        test    rax, rax                                ; 0D7C _ 48: 85. C0
        je      ?_092                                   ; 0D7F _ 0F 84, 00000112
        mov     rax, qword [rbp-8H]                     ; 0D85 _ 48: 8B. 45, F8
        mov     eax, dword [rax]                        ; 0D89 _ 8B. 00
        cmp     eax, 344                                ; 0D8B _ 3D, 00000158
        jg      ?_086                                   ; 0D90 _ 7F, 0A
        mov     eax, 4294967295                         ; 0D92 _ B8, FFFFFFFF
        jmp     ?_095                                   ; 0D97 _ E9, 00000114

?_086:  mov     rax, qword [rbp-8H]                     ; 0D9C _ 48: 8B. 45, F8
        mov     eax, dword [rax]                        ; 0DA0 _ 8B. 00
        cmp     eax, 345                                ; 0DA2 _ 3D, 00000159
        jnz     ?_087                                   ; 0DA7 _ 75, 0A
        mov     eax, 0                                  ; 0DA9 _ B8, 00000000
        jmp     ?_095                                   ; 0DAE _ E9, 000000FD

?_087:  mov     rax, qword [rbp-8H]                     ; 0DB3 _ 48: 8B. 45, F8
        mov     eax, dword [rax]                        ; 0DB7 _ 8B. 00
        cmp     eax, 346                                ; 0DB9 _ 3D, 0000015A
        jnz     ?_088                                   ; 0DBE _ 75, 20
        mov     rax, qword [rbp-10H]                    ; 0DC0 _ 48: 8B. 45, F0
        mov     rdx, qword [rax+8H]                     ; 0DC4 _ 48: 8B. 50, 08
        mov     rax, qword [rbp-8H]                     ; 0DC8 _ 48: 8B. 45, F8
        mov     rax, qword [rax+8H]                     ; 0DCC _ 48: 8B. 40, 08
        add     rdx, rax                                ; 0DD0 _ 48: 01. C2
        mov     rax, qword [rbp-10H]                    ; 0DD3 _ 48: 8B. 45, F0
        mov     qword [rax+8H], rdx                     ; 0DD7 _ 48: 89. 50, 08
        jmp     ?_093                                   ; 0DDB _ E9, 000000B8

?_088:  mov     rax, qword [rbp-10H]                    ; 0DE0 _ 48: 8B. 45, F0
        mov     eax, dword [rax+14H]                    ; 0DE4 _ 8B. 40, 14
        cmp     eax, -1                                 ; 0DE7 _ 83. F8, FF
        jnz     ?_089                                   ; 0DEA _ 75, 2F
        mov     rax, qword [rbp-10H]                    ; 0DEC _ 48: 8B. 45, F0
        movzx   eax, byte [rax+18H]                     ; 0DF0 _ 0F B6. 40, 18
        xor     eax, 01H                                ; 0DF4 _ 83. F0, 01
        test    al, al                                  ; 0DF7 _ 84. C0
        jz      ?_089                                   ; 0DF9 _ 74, 20
        mov     rax, qword [rbp-8H]                     ; 0DFB _ 48: 8B. 45, F8
        mov     eax, dword [rax]                        ; 0DFF _ 8B. 00
        cmp     eax, 347                                ; 0E01 _ 3D, 0000015B
        jnz     ?_089                                   ; 0E06 _ 75, 13
        mov     rax, qword [rbp-8H]                     ; 0E08 _ 48: 8B. 45, F8
        mov     rax, qword [rax+8H]                     ; 0E0C _ 48: 8B. 40, 08
        mov     edx, eax                                ; 0E10 _ 89. C2
        mov     rax, qword [rbp-10H]                    ; 0E12 _ 48: 8B. 45, F0
        mov     dword [rax+14H], edx                    ; 0E16 _ 89. 50, 14
        jmp     ?_093                                   ; 0E19 _ EB, 7D

?_089:  mov     rax, qword [rbp-10H]                    ; 0E1B _ 48: 8B. 45, F0
        movzx   eax, byte [rax+18H]                     ; 0E1F _ 0F B6. 40, 18
        xor     eax, 01H                                ; 0E23 _ 83. F0, 01
        test    al, al                                  ; 0E26 _ 84. C0
        jz      ?_090                                   ; 0E28 _ 74, 2A
        mov     rax, qword [rbp-8H]                     ; 0E2A _ 48: 8B. 45, F8
        mov     edx, dword [rax]                        ; 0E2E _ 8B. 10
        mov     eax, dword [rbp-14H]                    ; 0E30 _ 8B. 45, EC
        add     eax, 349                                ; 0E33 _ 05, 0000015D
        cmp     edx, eax                                ; 0E38 _ 39. C2
        jnz     ?_090                                   ; 0E3A _ 75, 18
        mov     rax, qword [rbp-8H]                     ; 0E3C _ 48: 8B. 45, F8
        mov     rax, qword [rax+8H]                     ; 0E40 _ 48: 8B. 40, 08
        cmp     rax, -1                                 ; 0E44 _ 48: 83. F8, FF
        jnz     ?_090                                   ; 0E48 _ 75, 0A
        mov     rax, qword [rbp-10H]                    ; 0E4A _ 48: 8B. 45, F0
        mov     byte [rax+18H], 1                       ; 0E4E _ C6. 40, 18, 01
        jmp     ?_093                                   ; 0E52 _ EB, 44

?_090:  mov     rax, qword [rbp-10H]                    ; 0E54 _ 48: 8B. 45, F0
        mov     eax, dword [rax+10H]                    ; 0E58 _ 8B. 40, 10
        cmp     eax, -1                                 ; 0E5B _ 83. F8, FF
        jnz     ?_091                                   ; 0E5E _ 75, 30
        mov     rax, qword [rbp-8H]                     ; 0E60 _ 48: 8B. 45, F8
        mov     eax, dword [rax]                        ; 0E64 _ 8B. 00
        cmp     eax, 348                                ; 0E66 _ 3D, 0000015C
        jle     ?_091                                   ; 0E6B _ 7E, 23
        mov     rax, qword [rbp-8H]                     ; 0E6D _ 48: 8B. 45, F8
        mov     rax, qword [rax+8H]                     ; 0E71 _ 48: 8B. 40, 08
        cmp     rax, 1                                  ; 0E75 _ 48: 83. F8, 01
        jnz     ?_091                                   ; 0E79 _ 75, 15
        mov     rax, qword [rbp-8H]                     ; 0E7B _ 48: 8B. 45, F8
        mov     eax, dword [rax]                        ; 0E7F _ 8B. 00
        lea     edx, [rax-15DH]                         ; 0E81 _ 8D. 90, FFFFFEA3
        mov     rax, qword [rbp-10H]                    ; 0E87 _ 48: 8B. 45, F0
        mov     dword [rax+10H], edx                    ; 0E8B _ 89. 50, 10
        jmp     ?_093                                   ; 0E8E _ EB, 08

?_091:  mov     eax, 4294967295                         ; 0E90 _ B8, FFFFFFFF
        jmp     ?_095                                   ; 0E95 _ EB, 19

?_092:  nop                                             ; 0E97 _ 90
?_093:  add     qword [rbp-8H], 16                      ; 0E98 _ 48: 83. 45, F8, 10
?_094:  mov     rax, qword [rbp-8H]                     ; 0E9D _ 48: 8B. 45, F8
        mov     eax, dword [rax]                        ; 0EA1 _ 8B. 00
        test    eax, eax                                ; 0EA3 _ 85. C0
        jne     ?_085                                   ; 0EA5 _ 0F 85, FFFFFEC9
        mov     eax, 0                                  ; 0EAB _ B8, 00000000
?_095:  pop     rbp                                     ; 0EB0 _ 5D
        ret                                             ; 0EB1 _ C3

parse_eops:; Local function
        push    rbp                                     ; 0EB2 _ 55
        mov     rbp, rsp                                ; 0EB3 _ 48: 89. E5
        sub     rsp, 192                                ; 0EB6 _ 48: 81. EC, 000000C0
        mov     qword [rbp-0B8H], rdi                   ; 0EBD _ 48: 89. BD, FFFFFF48
        mov     byte [rbp-0B9H], sil                    ; 0EC4 _ 40: 88. B5, FFFFFF47
        mov     dword [rbp-0C0H], edx                   ; 0ECB _ 89. 95, FFFFFF40
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        mov     rax, qword [fs:abs 28H]                 ; 0ED1 _ 64 48: 8B. 04 25, 00000028
        mov     qword [rbp-8H], rax                     ; 0EDA _ 48: 89. 45, F8
        xor     eax, eax                                ; 0EDE _ 31. C0
        mov     qword [rbp-90H], 0                      ; 0EE0 _ 48: C7. 85, FFFFFF70, 00000000
        mov     qword [rbp-88H], 0                      ; 0EEB _ 48: C7. 85, FFFFFF78, 00000000
        mov     rax, qword [rbp-0B8H]                   ; 0EF6 _ 48: 8B. 85, FFFFFF48
        mov     qword [rbp-80H], rax                    ; 0EFD _ 48: 89. 45, 80
        mov     eax, dword [rel ?_354]                  ; 0F01 _ 8B. 05, 00000000(rel)
        mov     dword [rbp-0A0H], eax                   ; 0F07 _ 89. 85, FFFFFF60
        mov     dword [rbp-9CH], 0                      ; 0F0D _ C7. 85, FFFFFF64, 00000000
        mov     byte [rbp-0A8H], 0                      ; 0F17 _ C6. 85, FFFFFF58, 00
        mov     rax, qword [rbp-80H]                    ; 0F1E _ 48: 8B. 45, 80
        mov     qword [rax], 0                          ; 0F22 _ 48: C7. 00, 00000000
        mov     eax, dword [rel ?_354]                  ; 0F29 _ 8B. 05, 00000000(rel)
        mov     dword [rbp-0A0H], eax                   ; 0F2F _ 89. 85, FFFFFF60
        jmp     ?_136                                   ; 0F35 _ E9, 000008DB

?_096:  mov     byte [rbp-0A6H], 41                     ; 0F3A _ C6. 85, FFFFFF5A, 29
        cmp     dword [rbp-0A0H], 41                    ; 0F41 _ 83. BD, FFFFFF60, 29
        je      ?_137                                   ; 0F48 _ 0F 84, 000008D6
        cmp     qword [rbp-90H], 0                      ; 0F4E _ 48: 83. BD, FFFFFF70, 00
        jnz     ?_097                                   ; 0F56 _ 75, 37
        mov     edi, 48                                 ; 0F58 _ BF, 00000030
        call    nasm_zalloc                             ; 0F5D _ E8, 00000000(PLT r)
        mov     qword [rbp-90H], rax                    ; 0F62 _ 48: 89. 85, FFFFFF70
        mov     rax, qword [rbp-90H]                    ; 0F69 _ 48: 8B. 85, FFFFFF70
        mov     qword [rax+20H], 1                      ; 0F70 _ 48: C7. 40, 20, 00000001
        mov     rax, qword [rbp-90H]                    ; 0F78 _ 48: 8B. 85, FFFFFF70
        mov     edx, dword [rbp-0C0H]                   ; 0F7F _ 8B. 95, FFFFFF40
        mov     dword [rax+2CH], edx                    ; 0F85 _ 89. 50, 2C
        mov     byte [rbp-0A8H], 0                      ; 0F88 _ C6. 85, FFFFFF58, 00
?_097:  mov     dword [rbp-0A4H], 1                     ; 0F8F _ C7. 85, FFFFFF5C, 00000001
        cmp     dword [rbp-0A0H], 63                    ; 0F99 _ 83. BD, FFFFFF60, 3F
        jnz     ?_098                                   ; 0FA0 _ 75, 1A
        mov     rax, qword [rbp-90H]                    ; 0FA2 _ 48: 8B. 85, FFFFFF70
        mov     dword [rax+28H], 6                      ; 0FA9 _ C7. 40, 28, 00000006
        mov     byte [rbp-0A7H], 1                      ; 0FB0 _ C6. 85, FFFFFF59, 01
        jmp     ?_129                                   ; 0FB7 _ E9, 000006DF

?_098:  cmp     byte [rbp-0A8H], 0                      ; 0FBC _ 80. BD, FFFFFF58, 00
        je      ?_104                                   ; 0FC3 _ 0F 84, 00000143
        cmp     dword [rbp-0A0H], 40                    ; 0FC9 _ 83. BD, FFFFFF60, 28
        jne     ?_104                                   ; 0FD0 _ 0F 85, 00000136
        lea     rax, [rel tokval]                       ; 0FD6 _ 48: 8D. 05, 00000000(rel)
        mov     rsi, rax                                ; 0FDD _ 48: 89. C6
        mov     edi, 0                                  ; 0FE0 _ BF, 00000000
        call    stdscan                                 ; 0FE5 _ E8, 00000000(PLT r)
        mov     rax, qword [rbp-90H]                    ; 0FEA _ 48: 8B. 85, FFFFFF70
        mov     edx, dword [rax+2CH]                    ; 0FF1 _ 8B. 50, 2C
        mov     rax, qword [rbp-90H]                    ; 0FF4 _ 48: 8B. 85, FFFFFF70
        lea     rcx, [rax+8H]                           ; 0FFB _ 48: 8D. 48, 08
        movzx   eax, byte [rbp-0B9H]                    ; 0FFF _ 0F B6. 85, FFFFFF47
        mov     esi, eax                                ; 1006 _ 89. C6
        mov     rdi, rcx                                ; 1008 _ 48: 89. CF
        call    parse_eops                              ; 100B _ E8, FFFFFEA2
        test    eax, eax                                ; 1010 _ 85. C0
        js      ?_139                                   ; 1012 _ 0F 88, 00000815
        mov     rax, qword [rbp-90H]                    ; 1018 _ 48: 8B. 85, FFFFFF70
        mov     rax, qword [rax+8H]                     ; 101F _ 48: 8B. 40, 08
        mov     qword [rbp-78H], rax                    ; 1023 _ 48: 89. 45, 88
        cmp     qword [rbp-78H], 0                      ; 1027 _ 48: 83. 7D, 88, 00
        jnz     ?_099                                   ; 102C _ 75, 10
        mov     rax, qword [rbp-90H]                    ; 102E _ 48: 8B. 85, FFFFFF70
        mov     dword [rax+28H], 0                      ; 1035 _ C7. 40, 28, 00000000
        jmp     ?_102                                   ; 103C _ EB, 71

?_099:  mov     rax, qword [rbp-78H]                    ; 103E _ 48: 8B. 45, 88
        mov     rax, qword [rax]                        ; 1042 _ 48: 8B. 00
        test    rax, rax                                ; 1045 _ 48: 85. C0
        jnz     ?_101                                   ; 1048 _ 75, 57
        mov     rax, qword [rbp-78H]                    ; 104A _ 48: 8B. 45, 88
        mov     eax, dword [rax+2CH]                    ; 104E _ 8B. 40, 2C
        test    eax, eax                                ; 1051 _ 85. C0
        jnz     ?_100                                   ; 1053 _ 75, 11
        mov     rax, qword [rbp-90H]                    ; 1055 _ 48: 8B. 85, FFFFFF70
        mov     edx, dword [rax+2CH]                    ; 105C _ 8B. 50, 2C
        mov     rax, qword [rbp-78H]                    ; 105F _ 48: 8B. 45, 88
        mov     dword [rax+2CH], edx                    ; 1063 _ 89. 50, 2C
?_100:  mov     rax, qword [rbp-78H]                    ; 1066 _ 48: 8B. 45, 88
        mov     rdx, qword [rax+20H]                    ; 106A _ 48: 8B. 50, 20
        mov     rax, qword [rbp-90H]                    ; 106E _ 48: 8B. 85, FFFFFF70
        mov     rax, qword [rax+20H]                    ; 1075 _ 48: 8B. 40, 20
        imul    rdx, rax                                ; 1079 _ 48: 0F AF. D0
        mov     rax, qword [rbp-78H]                    ; 107D _ 48: 8B. 45, 88
        mov     qword [rax+20H], rdx                    ; 1081 _ 48: 89. 50, 20
        mov     rax, qword [rbp-90H]                    ; 1085 _ 48: 8B. 85, FFFFFF70
        mov     rdi, rax                                ; 108C _ 48: 89. C7
        call    nasm_free                               ; 108F _ E8, 00000000(PLT r)
        mov     rax, qword [rbp-78H]                    ; 1094 _ 48: 8B. 45, 88
        mov     qword [rbp-90H], rax                    ; 1098 _ 48: 89. 85, FFFFFF70
        jmp     ?_102                                   ; 109F _ EB, 0E

?_101:  mov     rax, qword [rbp-90H]                    ; 10A1 _ 48: 8B. 85, FFFFFF70
        mov     dword [rax+28H], 1                      ; 10A8 _ C7. 40, 28, 00000001
?_102:  mov     eax, dword [rel ?_354]                  ; 10AF _ 8B. 05, 00000000(rel)
        cmp     eax, 41                                 ; 10B5 _ 83. F8, 29
        jz      ?_103                                   ; 10B8 _ 74, 3F
        lea     rax, [rel tokval]                       ; 10BA _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 10C1 _ 48: 89. C7
        call    tokstr                                  ; 10C4 _ E8, FFFFF118
        mov     qword [rbp-70H], rax                    ; 10C9 _ 48: 89. 45, 90
        mov     rax, qword [rbp-70H]                    ; 10CD _ 48: 8B. 45, 90
        lea     rdx, [rel ?_374]                        ; 10D1 _ 48: 8D. 15, 00000000(rel)
        mov     rsi, rax                                ; 10D8 _ 48: 89. C6
        mov     rdi, rdx                                ; 10DB _ 48: 89. D7
        mov     eax, 0                                  ; 10DE _ B8, 00000000
        call    nasm_nonfatal                           ; 10E3 _ E8, 00000000(PLT r)
        mov     rax, qword [rbp-70H]                    ; 10E8 _ 48: 8B. 45, 90
        mov     rdi, rax                                ; 10EC _ 48: 89. C7
        call    nasm_free                               ; 10EF _ E8, 00000000(PLT r)
        jmp     ?_141                                   ; 10F4 _ E9, 00000738

?_103:  mov     byte [rbp-0A6H], 0                      ; 10F9 _ C6. 85, FFFFFF5A, 00
        mov     byte [rbp-0A7H], 1                      ; 1100 _ C6. 85, FFFFFF59, 01
        jmp     ?_129                                   ; 1107 _ E9, 0000058F

?_104:  cmp     dword [rbp-0A0H], 37                    ; 110C _ 83. BD, FFFFFF60, 25
        jnz     ?_105                                   ; 1113 _ 75, 0C
        mov     byte [rbp-0A8H], 1                      ; 1115 _ C6. 85, FFFFFF58, 01
        jmp     ?_135                                   ; 111C _ E9, 000006DA

?_105:  cmp     dword [rbp-0A0H], 288                   ; 1121 _ 81. BD, FFFFFF60, 00000120
        jnz     ?_106                                   ; 112B _ 75, 1F
        mov     rax, qword [rel ?_350]                  ; 112D _ 48: 8B. 05, 00000000(rel)
        mov     edx, eax                                ; 1134 _ 89. C2
        mov     rax, qword [rbp-90H]                    ; 1136 _ 48: 8B. 85, FFFFFF70
        mov     dword [rax+2CH], edx                    ; 113D _ 89. 50, 2C
        mov     byte [rbp-0A8H], 1                      ; 1140 _ C6. 85, FFFFFF58, 01
        jmp     ?_135                                   ; 1147 _ E9, 000006AF

?_106:  cmp     dword [rbp-0A0H], 271                   ; 114C _ 81. BD, FFFFFF60, 0000010F
        jnz     ?_107                                   ; 1156 _ 75, 4A
        call    end_expression_next                     ; 1158 _ E8, 000029DD
        test    eax, eax                                ; 115D _ 85. C0
        jz      ?_107                                   ; 115F _ 74, 41
        mov     rax, qword [rbp-90H]                    ; 1161 _ 48: 8B. 85, FFFFFF70
        mov     dword [rax+28H], 2                      ; 1168 _ C7. 40, 28, 00000002
        mov     rdx, qword [rel ?_351]                  ; 116F _ 48: 8B. 15, 00000000(rel)
        mov     rax, qword [rbp-90H]                    ; 1176 _ 48: 8B. 85, FFFFFF70
        mov     qword [rax+8H], rdx                     ; 117D _ 48: 89. 50, 08
        mov     rax, qword [rel ?_350]                  ; 1181 _ 48: 8B. 05, 00000000(rel)
        mov     rdx, rax                                ; 1188 _ 48: 89. C2
        mov     rax, qword [rbp-90H]                    ; 118B _ 48: 8B. 85, FFFFFF70
        mov     qword [rax+10H], rdx                    ; 1192 _ 48: 89. 50, 10
        mov     byte [rbp-0A7H], 1                      ; 1196 _ C6. 85, FFFFFF59, 01
        jmp     ?_129                                   ; 119D _ E9, 000004F9

?_107:  cmp     dword [rbp-0A0H], 282                   ; 11A2 _ 81. BD, FFFFFF60, 0000011A
        jne     ?_112                                   ; 11AC _ 0F 85, 000001BA
        mov     byte [rbp-0A5H], 0                      ; 11B2 _ C6. 85, FFFFFF5B, 00
        mov     rax, qword [rel ?_351]                  ; 11B9 _ 48: 8B. 05, 00000000(rel)
        mov     qword [rbp-58H], rax                    ; 11C0 _ 48: 89. 45, A8
        mov     rax, qword [rel tokval]                 ; 11C4 _ 48: 8B. 05, 00000000(rel)
        mov     dword [rbp-94H], eax                    ; 11CB _ 89. 85, FFFFFF6C
        lea     rax, [rel tokval]                       ; 11D1 _ 48: 8D. 05, 00000000(rel)
        mov     rsi, rax                                ; 11D8 _ 48: 89. C6
        mov     edi, 0                                  ; 11DB _ BF, 00000000
        call    stdscan                                 ; 11E0 _ E8, 00000000(PLT r)
        mov     dword [rbp-0A0H], eax                   ; 11E5 _ 89. 85, FFFFFF60
        cmp     dword [rbp-0A0H], 40                    ; 11EB _ 83. BD, FFFFFF60, 28
        jnz     ?_108                                   ; 11F2 _ 75, 28
        mov     byte [rbp-0A5H], 1                      ; 11F4 _ C6. 85, FFFFFF5B, 01
        mov     byte [rbp-0A6H], 0                      ; 11FB _ C6. 85, FFFFFF5A, 00
        lea     rax, [rel tokval]                       ; 1202 _ 48: 8D. 05, 00000000(rel)
        mov     rsi, rax                                ; 1209 _ 48: 89. C6
        mov     edi, 0                                  ; 120C _ BF, 00000000
        call    stdscan                                 ; 1211 _ E8, 00000000(PLT r)
        mov     dword [rbp-0A0H], eax                   ; 1216 _ 89. 85, FFFFFF60
?_108:  cmp     dword [rbp-0A0H], 271                   ; 121C _ 81. BD, FFFFFF60, 0000010F
        jz      ?_109                                   ; 1226 _ 74, 51
        lea     rax, [rel tokval]                       ; 1228 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 122F _ 48: 89. C7
        call    tokstr                                  ; 1232 _ E8, FFFFEFAA
        mov     qword [rbp-50H], rax                    ; 1237 _ 48: 89. 45, B0
        mov     rdx, qword [rbp-50H]                    ; 123B _ 48: 8B. 55, B0
        mov     rax, qword [rbp-58H]                    ; 123F _ 48: 8B. 45, A8
        lea     rcx, [rel ?_375]                        ; 1243 _ 48: 8D. 0D, 00000000(rel)
        mov     rsi, rax                                ; 124A _ 48: 89. C6
        mov     rdi, rcx                                ; 124D _ 48: 89. CF
        mov     eax, 0                                  ; 1250 _ B8, 00000000
        call    nasm_nonfatal                           ; 1255 _ E8, 00000000(PLT r)
        mov     rax, qword [rbp-50H]                    ; 125A _ 48: 8B. 45, B0
        mov     rdi, rax                                ; 125E _ 48: 89. C7
        call    nasm_free                               ; 1261 _ E8, 00000000(PLT r)
        mov     rax, qword [rbp-90H]                    ; 1266 _ 48: 8B. 85, FFFFFF70
        mov     dword [rax+28H], 0                      ; 126D _ C7. 40, 28, 00000000
        jmp     ?_110                                   ; 1274 _ E9, 00000085

?_109:  mov     rax, qword [rbp-90H]                    ; 1279 _ 48: 8B. 85, FFFFFF70
        mov     dword [rax+28H], 4                      ; 1280 _ C7. 40, 28, 00000004
        mov     rax, qword [rbp-90H]                    ; 1287 _ 48: 8B. 85, FFFFFF70
        lea     rsi, [rax+8H]                           ; 128E _ 48: 8D. 70, 08
        mov     rax, qword [rel ?_350]                  ; 1292 _ 48: 8B. 05, 00000000(rel)
        mov     rdi, rax                                ; 1299 _ 48: 89. C7
        mov     rax, qword [rel ?_351]                  ; 129C _ 48: 8B. 05, 00000000(rel)
        mov     edx, dword [rbp-94H]                    ; 12A3 _ 8B. 95, FFFFFF6C
        mov     ecx, edx                                ; 12A9 _ 89. D1
        mov     rdx, rsi                                ; 12AB _ 48: 89. F2
        mov     rsi, rdi                                ; 12AE _ 48: 89. FE
        mov     rdi, rax                                ; 12B1 _ 48: 89. C7
        call    string_transform                        ; 12B4 _ E8, 00000000(PLT r)
        mov     rdx, qword [rbp-90H]                    ; 12B9 _ 48: 8B. 95, FFFFFF70
        mov     qword [rdx+10H], rax                    ; 12C0 _ 48: 89. 42, 10
        mov     rax, qword [rbp-90H]                    ; 12C4 _ 48: 8B. 85, FFFFFF70
        mov     rax, qword [rax+10H]                    ; 12CB _ 48: 8B. 40, 10
        cmp     rax, -1                                 ; 12CF _ 48: 83. F8, FF
        jnz     ?_110                                   ; 12D3 _ 75, 29
        mov     rax, qword [rbp-58H]                    ; 12D5 _ 48: 8B. 45, A8
        lea     rdx, [rel ?_376]                        ; 12D9 _ 48: 8D. 15, 00000000(rel)
        mov     rsi, rax                                ; 12E0 _ 48: 89. C6
        mov     rdi, rdx                                ; 12E3 _ 48: 89. D7
        mov     eax, 0                                  ; 12E6 _ B8, 00000000
        call    nasm_nonfatal                           ; 12EB _ E8, 00000000(PLT r)
        mov     rax, qword [rbp-90H]                    ; 12F0 _ 48: 8B. 85, FFFFFF70
        mov     dword [rax+28H], 0                      ; 12F7 _ C7. 40, 28, 00000000
?_110:  cmp     byte [rbp-0A5H], 0                      ; 12FE _ 80. BD, FFFFFF5B, 00
        jz      ?_111                                   ; 1305 _ 74, 50
        cmp     dword [rbp-0A0H], 0                     ; 1307 _ 83. BD, FFFFFF60, 00
        jz      ?_111                                   ; 130E _ 74, 47
        cmp     dword [rbp-0A0H], 41                    ; 1310 _ 83. BD, FFFFFF60, 29
        jz      ?_111                                   ; 1317 _ 74, 3E
        lea     rax, [rel tokval]                       ; 1319 _ 48: 8D. 05, 00000000(rel)
        mov     rsi, rax                                ; 1320 _ 48: 89. C6
        mov     edi, 0                                  ; 1323 _ BF, 00000000
        call    stdscan                                 ; 1328 _ E8, 00000000(PLT r)
        mov     dword [rbp-0A0H], eax                   ; 132D _ 89. 85, FFFFFF60
        cmp     dword [rbp-0A0H], 41                    ; 1333 _ 83. BD, FFFFFF60, 29
        jz      ?_111                                   ; 133A _ 74, 1B
        mov     rax, qword [rbp-58H]                    ; 133C _ 48: 8B. 45, A8
        lea     rdx, [rel ?_377]                        ; 1340 _ 48: 8D. 15, 00000000(rel)
        mov     rsi, rax                                ; 1347 _ 48: 89. C6
        mov     rdi, rdx                                ; 134A _ 48: 89. D7
        mov     eax, 0                                  ; 134D _ B8, 00000000
        call    nasm_nonfatal                           ; 1352 _ E8, 00000000(PLT r)
?_111:  cmp     dword [rbp-0A0H], 44                    ; 1357 _ 83. BD, FFFFFF60, 2C
        setne   al                                      ; 135E _ 0F 95. C0
        mov     byte [rbp-0A7H], al                     ; 1361 _ 88. 85, FFFFFF59
        jmp     ?_129                                   ; 1367 _ E9, 0000032F

?_112:  cmp     dword [rbp-0A0H], 45                    ; 136C _ 83. BD, FFFFFF60, 2D
        jz      ?_113                                   ; 1373 _ 74, 0D
        cmp     dword [rbp-0A0H], 43                    ; 1375 _ 83. BD, FFFFFF60, 2B
        jne     ?_117                                   ; 137C _ 0F 85, 00000095
?_113:  call    stdscan_get                             ; 1382 _ E8, 00000000(PLT r)
        mov     qword [rbp-68H], rax                    ; 1387 _ 48: 89. 45, 98
        cmp     dword [rbp-0A0H], 45                    ; 138B _ 83. BD, FFFFFF60, 2D
        jnz     ?_114                                   ; 1392 _ 75, 0C
        mov     dword [rbp-0A4H], -1                    ; 1394 _ C7. 85, FFFFFF5C, FFFFFFFF
        jmp     ?_115                                   ; 139E _ EB, 0A

?_114:  mov     dword [rbp-0A4H], 1                     ; 13A0 _ C7. 85, FFFFFF5C, 00000001
?_115:  lea     rax, [rbp-40H]                          ; 13AA _ 48: 8D. 45, C0
        mov     rsi, rax                                ; 13AE _ 48: 89. C6
        mov     edi, 0                                  ; 13B1 _ BF, 00000000
        call    stdscan                                 ; 13B6 _ E8, 00000000(PLT r)
        cmp     eax, 274                                ; 13BB _ 3D, 00000112
        jz      ?_116                                   ; 13C0 _ 74, 11
        mov     rax, qword [rbp-68H]                    ; 13C2 _ 48: 8B. 45, 98
        mov     rdi, rax                                ; 13C6 _ 48: 89. C7
        call    stdscan_set                             ; 13C9 _ E8, 00000000(PLT r)
        jmp     ?_124                                   ; 13CE _ E9, 000001AE

?_116:  mov     rax, qword [rbp-40H]                    ; 13D3 _ 48: 8B. 45, C0
        mov     rdx, qword [rbp-38H]                    ; 13D7 _ 48: 8B. 55, C8
        mov     qword [rel tokval], rax                 ; 13DB _ 48: 89. 05, 00000000(rel)
        mov     qword [rel ?_350], rdx                  ; 13E2 _ 48: 89. 15, 00000000(rel)
        mov     rax, qword [rbp-30H]                    ; 13E9 _ 48: 8B. 45, D0
        mov     rdx, qword [rbp-28H]                    ; 13ED _ 48: 8B. 55, D8
        mov     qword [rel ?_351], rax                  ; 13F1 _ 48: 89. 05, 00000000(rel)
        mov     qword [rel ?_352], rdx                  ; 13F8 _ 48: 89. 15, 00000000(rel)
        mov     rax, qword [rbp-20H]                    ; 13FF _ 48: 8B. 45, E0
        mov     rdx, qword [rbp-18H]                    ; 1403 _ 48: 8B. 55, E8
        mov     qword [rel ?_353], rax                  ; 1407 _ 48: 89. 05, 00000000(rel)
        mov     qword [rel ?_355], rdx                  ; 140E _ 48: 89. 15, 00000000(rel)
        jmp     ?_118                                   ; 1415 _ EB, 11

?_117:  cmp     dword [rbp-0A0H], 274                   ; 1417 _ 81. BD, FFFFFF60, 00000112
        jne     ?_123                                   ; 1421 _ 0F 85, 00000159
        nop                                             ; 1427 _ 90
?_118:  mov     rax, qword [rbp-90H]                    ; 1428 _ 48: 8B. 85, FFFFFF70
        mov     dword [rax+28H], 3                      ; 142F _ C7. 40, 28, 00000003
        mov     rax, qword [rbp-90H]                    ; 1436 _ 48: 8B. 85, FFFFFF70
        mov     eax, dword [rax+2CH]                    ; 143D _ 8B. 40, 2C
        mov     edi, eax                                ; 1440 _ 89. C7
        call    float_deffmt                            ; 1442 _ E8, 00000000(PLT r)
        mov     dword [rbp-98H], eax                    ; 1447 _ 89. 85, FFFFFF68
        cmp     dword [rbp-98H], 9                      ; 144D _ 83. BD, FFFFFF68, 09
        jnz     ?_119                                   ; 1454 _ 75, 3B
        mov     rax, qword [rbp-90H]                    ; 1456 _ 48: 8B. 85, FFFFFF70
        mov     eax, dword [rax+2CH]                    ; 145D _ 8B. 40, 2C
        lea     edx, [rax*8]                            ; 1460 _ 8D. 14 C5, 00000000
        lea     rax, [rel ?_378]                        ; 1467 _ 48: 8D. 05, 00000000(rel)
        mov     esi, edx                                ; 146E _ 89. D6
        mov     rdi, rax                                ; 1470 _ 48: 89. C7
        mov     eax, 0                                  ; 1473 _ B8, 00000000
        call    nasm_nonfatal                           ; 1478 _ E8, 00000000(PLT r)
        mov     rax, qword [rbp-90H]                    ; 147D _ 48: 8B. 85, FFFFFF70
        mov     qword [rax+10H], 0                      ; 1484 _ 48: C7. 40, 10, 00000000
        jmp     ?_121                                   ; 148C _ E9, 000000C5

?_119:  mov     rax, qword [rbp-90H]                    ; 1491 _ 48: 8B. 85, FFFFFF70
        mov     eax, dword [rax+2CH]                    ; 1498 _ 8B. 40, 2C
        test    eax, eax                                ; 149B _ 85. C0
        jg      ?_120                                   ; 149D _ 7F, 28
        lea     rax, [rel ?_379]                        ; 149F _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 14A6 _ 48: 89. C7
        mov     eax, 0                                  ; 14A9 _ B8, 00000000
        call    nasm_nonfatal                           ; 14AE _ E8, 00000000(PLT r)
        mov     rax, qword [rbp-90H]                    ; 14B3 _ 48: 8B. 85, FFFFFF70
        mov     qword [rax+10H], 0                      ; 14BA _ 48: C7. 40, 10, 00000000
        jmp     ?_121                                   ; 14C2 _ E9, 0000008F

?_120:  mov     rax, qword [rbp-90H]                    ; 14C7 _ 48: 8B. 85, FFFFFF70
        mov     eax, dword [rax+2CH]                    ; 14CE _ 8B. 40, 2C
        movsxd  rdx, eax                                ; 14D1 _ 48: 63. D0
        mov     rax, qword [rbp-90H]                    ; 14D4 _ 48: 8B. 85, FFFFFF70
        mov     qword [rax+10H], rdx                    ; 14DB _ 48: 89. 50, 10
        mov     rax, qword [rbp-90H]                    ; 14DF _ 48: 8B. 85, FFFFFF70
        mov     rax, qword [rax+10H]                    ; 14E6 _ 48: 8B. 40, 10
        lea     rdx, [rax+30H]                          ; 14EA _ 48: 8D. 50, 30
        mov     rax, qword [rbp-90H]                    ; 14EE _ 48: 8B. 85, FFFFFF70
        mov     rsi, rdx                                ; 14F5 _ 48: 89. D6
        mov     rdi, rax                                ; 14F8 _ 48: 89. C7
        call    nasm_realloc                            ; 14FB _ E8, 00000000(PLT r)
        mov     qword [rbp-90H], rax                    ; 1500 _ 48: 89. 85, FFFFFF70
        mov     rax, qword [rbp-90H]                    ; 1507 _ 48: 8B. 85, FFFFFF70
        lea     rdx, [rax+30H]                          ; 150E _ 48: 8D. 50, 30
        mov     rax, qword [rbp-90H]                    ; 1512 _ 48: 8B. 85, FFFFFF70
        mov     qword [rax+8H], rdx                     ; 1519 _ 48: 89. 50, 08
        mov     rax, qword [rbp-90H]                    ; 151D _ 48: 8B. 85, FFFFFF70
        mov     rdx, qword [rax+8H]                     ; 1524 _ 48: 8B. 50, 08
        mov     rax, qword [rel ?_351]                  ; 1528 _ 48: 8B. 05, 00000000(rel)
        mov     ecx, dword [rbp-98H]                    ; 152F _ 8B. 8D, FFFFFF68
        mov     esi, dword [rbp-0A4H]                   ; 1535 _ 8B. B5, FFFFFF5C
        mov     rdi, rax                                ; 153B _ 48: 89. C7
        call    float_const                             ; 153E _ E8, 00000000(PLT r)
        test    eax, eax                                ; 1543 _ 85. C0
        jnz     ?_121                                   ; 1545 _ 75, 0F
        mov     rax, qword [rbp-90H]                    ; 1547 _ 48: 8B. 85, FFFFFF70
        mov     qword [rax+10H], 0                      ; 154E _ 48: C7. 40, 10, 00000000
?_121:  mov     rax, qword [rbp-90H]                    ; 1556 _ 48: 8B. 85, FFFFFF70
        mov     rax, qword [rax+10H]                    ; 155D _ 48: 8B. 40, 10
        test    rax, rax                                ; 1561 _ 48: 85. C0
        jnz     ?_122                                   ; 1564 _ 75, 0E
        mov     rax, qword [rbp-90H]                    ; 1566 _ 48: 8B. 85, FFFFFF70
        mov     dword [rax+28H], 0                      ; 156D _ C7. 40, 28, 00000000
?_122:  mov     byte [rbp-0A7H], 1                      ; 1574 _ C6. 85, FFFFFF59, 01
        jmp     ?_129                                   ; 157B _ E9, 0000011B

?_123:  nop                                             ; 1580 _ 90
?_124:  movzx   edx, byte [rbp-0B9H]                    ; 1581 _ 0F B6. 95, FFFFFF47
        lea     rax, [rel tokval]                       ; 1588 _ 48: 8D. 05, 00000000(rel)
; Note: Unusual relocation type for this operand
        mov     rcx, qword [rel stdscan+$+??]           ; 158F _ 48: 8B. 0D, 00000000
        mov     rdi, rcx                                ; 1596 _ 48: 89. CF
        mov     r9d, 0                                  ; 1599 _ 41: B9, 00000000
        mov     r8d, edx                                ; 159F _ 41: 89. D0
        mov     ecx, 0                                  ; 15A2 _ B9, 00000000
        mov     rdx, rax                                ; 15A7 _ 48: 89. C2
        mov     esi, 0                                  ; 15AA _ BE, 00000000
        call    evaluate                                ; 15AF _ E8, 00000000(PLT r)
        mov     qword [rbp-60H], rax                    ; 15B4 _ 48: 89. 45, A0
        mov     eax, dword [rel ?_354]                  ; 15B8 _ 8B. 05, 00000000(rel)
        mov     dword [rbp-0A0H], eax                   ; 15BE _ 89. 85, FFFFFF60
        cmp     qword [rbp-60H], 0                      ; 15C4 _ 48: 83. 7D, A0, 00
        je      ?_140                                   ; 15C9 _ 0F 84, 00000261
        mov     eax, dword [rel ?_355]                  ; 15CF _ 8B. 05, 00000000(rel)
        and     eax, 10H                                ; 15D5 _ 83. E0, 10
        test    eax, eax                                ; 15D8 _ 85. C0
        je      ?_127                                   ; 15DA _ 0F 84, 00000080
        mov     rax, qword [rbp-60H]                    ; 15E0 _ 48: 8B. 45, A0
        mov     rdi, rax                                ; 15E4 _ 48: 89. C7
        call    is_simple                               ; 15E7 _ E8, 00000000(PLT r)
        xor     eax, 01H                                ; 15EC _ 83. F0, 01
        test    al, al                                  ; 15EF _ 84. C0
        jz      ?_125                                   ; 15F1 _ 74, 19
        lea     rax, [rel ?_380]                        ; 15F3 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 15FA _ 48: 89. C7
        mov     eax, 0                                  ; 15FD _ B8, 00000000
        call    nasm_nonfatal                           ; 1602 _ E8, 00000000(PLT r)
        jmp     ?_141                                   ; 1607 _ E9, 00000225

?_125:  mov     rax, qword [rbp-60H]                    ; 160C _ 48: 8B. 45, A0
        mov     rax, qword [rax+8H]                     ; 1610 _ 48: 8B. 40, 08
        test    rax, rax                                ; 1614 _ 48: 85. C0
        jns     ?_126                                   ; 1617 _ 79, 19
        lea     rax, [rel ?_381]                        ; 1619 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 1620 _ 48: 89. C7
        mov     eax, 0                                  ; 1623 _ B8, 00000000
        call    nasm_nonfatal                           ; 1628 _ E8, 00000000(PLT r)
        jmp     ?_141                                   ; 162D _ E9, 000001FF

?_126:  mov     rax, qword [rbp-90H]                    ; 1632 _ 48: 8B. 85, FFFFFF70
        mov     rax, qword [rax+20H]                    ; 1639 _ 48: 8B. 40, 20
        mov     rdx, qword [rbp-60H]                    ; 163D _ 48: 8B. 55, A0
        mov     rdx, qword [rdx+8H]                     ; 1641 _ 48: 8B. 52, 08
        imul    rdx, rax                                ; 1645 _ 48: 0F AF. D0
        mov     rax, qword [rbp-90H]                    ; 1649 _ 48: 8B. 85, FFFFFF70
        mov     qword [rax+20H], rdx                    ; 1650 _ 48: 89. 50, 20
        mov     byte [rbp-0A8H], 1                      ; 1654 _ C6. 85, FFFFFF58, 01
        jmp     ?_135                                   ; 165B _ E9, 0000019B

?_127:  mov     edx, dword [rel location+8H]            ; 1660 _ 8B. 15, 00000000(rel)
        mov     rcx, qword [rbp-90H]                    ; 1666 _ 48: 8B. 8D, FFFFFF70
        mov     rax, qword [rbp-60H]                    ; 166D _ 48: 8B. 45, A0
        mov     rsi, rcx                                ; 1671 _ 48: 89. CE
        mov     rdi, rax                                ; 1674 _ 48: 89. C7
        call    value_to_extop                          ; 1677 _ E8, FFFFF6AC
        test    eax, eax                                ; 167C _ 85. C0
        jz      ?_128                                   ; 167E _ 74, 14
        lea     rax, [rel ?_382]                        ; 1680 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 1687 _ 48: 89. C7
        mov     eax, 0                                  ; 168A _ B8, 00000000
        call    nasm_nonfatal                           ; 168F _ E8, 00000000(PLT r)
?_128:  mov     byte [rbp-0A7H], 0                      ; 1694 _ C6. 85, FFFFFF59, 00
?_129:  mov     rax, qword [rbp-90H]                    ; 169B _ 48: 8B. 85, FFFFFF70
        mov     rax, qword [rax+20H]                    ; 16A2 _ 48: 8B. 40, 20
        test    rax, rax                                ; 16A6 _ 48: 85. C0
        jz      ?_130                                   ; 16A9 _ 74, 0E
        mov     rax, qword [rbp-90H]                    ; 16AB _ 48: 8B. 85, FFFFFF70
        mov     eax, dword [rax+28H]                    ; 16B2 _ 8B. 40, 28
        test    eax, eax                                ; 16B5 _ 85. C0
        jnz     ?_131                                   ; 16B7 _ 75, 14
?_130:  mov     rax, qword [rbp-90H]                    ; 16B9 _ 48: 8B. 85, FFFFFF70
        mov     rdi, rax                                ; 16C0 _ 48: 89. C7
        call    nasm_free                               ; 16C3 _ E8, 00000000(PLT r)
        jmp     ?_133                                   ; 16C8 _ E9, 0000009C

?_131:  mov     rax, qword [rbp-90H]                    ; 16CD _ 48: 8B. 85, FFFFFF70
        mov     eax, dword [rax+28H]                    ; 16D4 _ 8B. 40, 28
        cmp     eax, 6                                  ; 16D7 _ 83. F8, 06
        jnz     ?_132                                   ; 16DA _ 75, 66
        cmp     qword [rbp-88H], 0                      ; 16DC _ 48: 83. BD, FFFFFF78, 00
        jz      ?_132                                   ; 16E4 _ 74, 5C
        mov     rax, qword [rbp-88H]                    ; 16E6 _ 48: 8B. 85, FFFFFF78
        mov     eax, dword [rax+28H]                    ; 16ED _ 8B. 40, 28
        cmp     eax, 6                                  ; 16F0 _ 83. F8, 06
        jnz     ?_132                                   ; 16F3 _ 75, 4D
        mov     rax, qword [rbp-88H]                    ; 16F5 _ 48: 8B. 85, FFFFFF78
        mov     edx, dword [rax+2CH]                    ; 16FC _ 8B. 50, 2C
        mov     rax, qword [rbp-90H]                    ; 16FF _ 48: 8B. 85, FFFFFF70
        mov     eax, dword [rax+2CH]                    ; 1706 _ 8B. 40, 2C
        cmp     edx, eax                                ; 1709 _ 39. C2
        jnz     ?_132                                   ; 170B _ 75, 35
        mov     rax, qword [rbp-88H]                    ; 170D _ 48: 8B. 85, FFFFFF78
        mov     rdx, qword [rax+20H]                    ; 1714 _ 48: 8B. 50, 20
        mov     rax, qword [rbp-90H]                    ; 1718 _ 48: 8B. 85, FFFFFF70
        mov     rax, qword [rax+20H]                    ; 171F _ 48: 8B. 40, 20
        add     rdx, rax                                ; 1723 _ 48: 01. C2
        mov     rax, qword [rbp-88H]                    ; 1726 _ 48: 8B. 85, FFFFFF78
        mov     qword [rax+20H], rdx                    ; 172D _ 48: 89. 50, 20
        mov     rax, qword [rbp-90H]                    ; 1731 _ 48: 8B. 85, FFFFFF70
        mov     rdi, rax                                ; 1738 _ 48: 89. C7
        call    nasm_free                               ; 173B _ E8, 00000000(PLT r)
        jmp     ?_133                                   ; 1740 _ EB, 27

?_132:  mov     rax, qword [rbp-90H]                    ; 1742 _ 48: 8B. 85, FFFFFF70
        mov     qword [rbp-88H], rax                    ; 1749 _ 48: 89. 85, FFFFFF78
        mov     rax, qword [rbp-80H]                    ; 1750 _ 48: 8B. 45, 80
        mov     rdx, qword [rbp-90H]                    ; 1754 _ 48: 8B. 95, FFFFFF70
        mov     qword [rax], rdx                        ; 175B _ 48: 89. 10
        mov     rax, qword [rbp-90H]                    ; 175E _ 48: 8B. 85, FFFFFF70
        mov     qword [rbp-80H], rax                    ; 1765 _ 48: 89. 45, 80
?_133:  add     dword [rbp-9CH], 1                      ; 1769 _ 83. 85, FFFFFF64, 01
        mov     qword [rbp-90H], 0                      ; 1770 _ 48: C7. 85, FFFFFF70, 00000000
        cmp     byte [rbp-0A7H], 0                      ; 177B _ 80. BD, FFFFFF59, 00
        jz      ?_134                                   ; 1782 _ 74, 1A
        lea     rax, [rel tokval]                       ; 1784 _ 48: 8D. 05, 00000000(rel)
        mov     rsi, rax                                ; 178B _ 48: 89. C6
        mov     edi, 0                                  ; 178E _ BF, 00000000
        call    stdscan                                 ; 1793 _ E8, 00000000(PLT r)
        mov     dword [rbp-0A0H], eax                   ; 1798 _ 89. 85, FFFFFF60
?_134:  cmp     dword [rbp-0A0H], 0                     ; 179E _ 83. BD, FFFFFF60, 00
        jz      ?_138                                   ; 17A5 _ 74, 7E
        movsx   eax, byte [rbp-0A6H]                    ; 17A7 _ 0F BE. 85, FFFFFF5A
        cmp     dword [rbp-0A0H], eax                   ; 17AE _ 39. 85, FFFFFF60
        jz      ?_138                                   ; 17B4 _ 74, 6F
        cmp     dword [rbp-0A0H], 44                    ; 17B6 _ 83. BD, FFFFFF60, 2C
        jz      ?_135                                   ; 17BD _ 74, 3C
        lea     rax, [rel tokval]                       ; 17BF _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 17C6 _ 48: 89. C7
        call    tokstr                                  ; 17C9 _ E8, FFFFEA13
        mov     qword [rbp-48H], rax                    ; 17CE _ 48: 89. 45, B8
        mov     rax, qword [rbp-48H]                    ; 17D2 _ 48: 8B. 45, B8
        lea     rdx, [rel ?_383]                        ; 17D6 _ 48: 8D. 15, 00000000(rel)
        mov     rsi, rax                                ; 17DD _ 48: 89. C6
        mov     rdi, rdx                                ; 17E0 _ 48: 89. D7
        mov     eax, 0                                  ; 17E3 _ B8, 00000000
        call    nasm_nonfatal                           ; 17E8 _ E8, 00000000(PLT r)
        mov     rax, qword [rbp-48H]                    ; 17ED _ 48: 8B. 45, B8
        mov     rdi, rax                                ; 17F1 _ 48: 89. C7
        call    nasm_free                               ; 17F4 _ E8, 00000000(PLT r)
        jmp     ?_141                                   ; 17F9 _ EB, 36

?_135:  lea     rax, [rel tokval]                       ; 17FB _ 48: 8D. 05, 00000000(rel)
        mov     rsi, rax                                ; 1802 _ 48: 89. C6
        mov     edi, 0                                  ; 1805 _ BF, 00000000
        call    stdscan                                 ; 180A _ E8, 00000000(PLT r)
        mov     dword [rbp-0A0H], eax                   ; 180F _ 89. 85, FFFFFF60
?_136:  cmp     dword [rbp-0A0H], 0                     ; 1815 _ 83. BD, FFFFFF60, 00
        jne     ?_096                                   ; 181C _ 0F 85, FFFFF718
        jmp     ?_138                                   ; 1822 _ EB, 01

?_137:  nop                                             ; 1824 _ 90
?_138:  mov     eax, dword [rbp-9CH]                    ; 1825 _ 8B. 85, FFFFFF64
        jmp     ?_143                                   ; 182B _ EB, 22

?_139:  nop                                             ; 182D _ 90
        jmp     ?_141                                   ; 182E _ EB, 01

?_140:  nop                                             ; 1830 _ 90
?_141:  cmp     qword [rbp-90H], 0                      ; 1831 _ 48: 83. BD, FFFFFF70, 00
        jz      ?_142                                   ; 1839 _ 74, 0F
        mov     rax, qword [rbp-90H]                    ; 183B _ 48: 8B. 85, FFFFFF70
        mov     rdi, rax                                ; 1842 _ 48: 89. C7
        call    nasm_free                               ; 1845 _ E8, 00000000(PLT r)
?_142:  mov     eax, 4294967295                         ; 184A _ B8, FFFFFFFF
?_143:  mov     rdx, qword [rbp-8H]                     ; 184F _ 48: 8B. 55, F8
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        sub     rdx, qword [fs:abs 28H]                 ; 1853 _ 64 48: 2B. 14 25, 00000028
        jz      ?_144                                   ; 185C _ 74, 05
        call    __stack_chk_fail                        ; 185E _ E8, 00000000(PLT r)
?_144:  leave                                           ; 1863 _ C9
        ret                                             ; 1864 _ C3

add_prefix:; Local function
        push    rbp                                     ; 1865 _ 55
        mov     rbp, rsp                                ; 1866 _ 48: 89. E5
        sub     rsp, 32                                 ; 1869 _ 48: 83. EC, 20
        mov     qword [rbp-18H], rdi                    ; 186D _ 48: 89. 7D, E8
        mov     eax, dword [rel ?_354]                  ; 1871 _ 8B. 05, 00000000(rel)
        cmp     eax, 292                                ; 1877 _ 3D, 00000124
        jz      ?_148                                   ; 187C _ 74, 63
        cmp     eax, 292                                ; 187E _ 3D, 00000124
        jg      ?_149                                   ; 1883 _ 0F 8F, 0000008D
        cmp     eax, 289                                ; 1889 _ 3D, 00000121
        jz      ?_145                                   ; 188E _ 74, 09
        cmp     eax, 290                                ; 1890 _ 3D, 00000122
        jz      ?_147                                   ; 1895 _ 74, 3E
        jmp     ?_149                                   ; 1897 _ EB, 7D

?_145:  mov     rax, qword [rel tokval]                 ; 1899 _ 48: 8B. 05, 00000000(rel)
        cmp     rax, 389                                ; 18A0 _ 48: 3D, 00000185
        jnz     ?_146                                   ; 18A6 _ 75, 23
        mov     rax, qword [rbp-18H]                    ; 18A8 _ 48: 8B. 45, E8
        mov     eax, dword [rax+94H]                    ; 18AC _ 8B. 80, 00000094
        or      eax, 04H                                ; 18B2 _ 83. C8, 04
        mov     edx, eax                                ; 18B5 _ 89. C2
        mov     rax, qword [rbp-18H]                    ; 18B7 _ 48: 8B. 45, E8
        mov     dword [rax+94H], edx                    ; 18BB _ 89. 90, 00000094
        mov     eax, 1                                  ; 18C1 _ B8, 00000001
        jmp     ?_154                                   ; 18C6 _ E9, 000000EC

?_146:  mov     eax, 0                                  ; 18CB _ B8, 00000000
        jmp     ?_154                                   ; 18D0 _ E9, 000000E2

?_147:  mov     rax, qword [rel ?_350]                  ; 18D5 _ 48: 8B. 05, 00000000(rel)
        mov     dword [rbp-8H], eax                     ; 18DC _ 89. 45, F8
        jmp     ?_151                                   ; 18DF _ EB, 40

?_148:  mov     dword [rbp-8H], 1                       ; 18E1 _ C7. 45, F8, 00000001
        mov     rax, qword [rel tokval]                 ; 18E8 _ 48: 8B. 05, 00000000(rel)
        mov     edx, eax                                ; 18EF _ 89. C2
        mov     rax, qword 210000201H                   ; 18F1 _ 48: B8, 0000000210000201
        mov     esi, edx                                ; 18FB _ 89. D6
        mov     rdi, rax                                ; 18FD _ 48: 89. C7
        call    is_reg_class                            ; 1900 _ E8, FFFFE741
        xor     eax, 01H                                ; 1905 _ 83. F0, 01
        test    al, al                                  ; 1908 _ 84. C0
        jz      ?_150                                   ; 190A _ 74, 14
        mov     eax, 0                                  ; 190C _ B8, 00000000
        jmp     ?_154                                   ; 1911 _ E9, 000000A1

?_149:  mov     eax, 0                                  ; 1916 _ B8, 00000000
        jmp     ?_154                                   ; 191B _ E9, 00000097

?_150:  nop                                             ; 1920 _ 90
?_151:  mov     rax, qword [rbp-18H]                    ; 1921 _ 48: 8B. 45, E8
        mov     edx, dword [rbp-8H]                     ; 1925 _ 8B. 55, F8
        add     rdx, 4                                  ; 1928 _ 48: 83. C2, 04
        mov     eax, dword [rax+rdx*4+8H]               ; 192C _ 8B. 44 90, 08
        test    eax, eax                                ; 1930 _ 85. C0
        jz      ?_153                                   ; 1932 _ 74, 66
        mov     rax, qword [rbp-18H]                    ; 1934 _ 48: 8B. 45, E8
        mov     edx, dword [rbp-8H]                     ; 1938 _ 8B. 55, F8
        add     rdx, 4                                  ; 193B _ 48: 83. C2, 04
        mov     eax, dword [rax+rdx*4+8H]               ; 193F _ 8B. 44 90, 08
        movsxd  rdx, eax                                ; 1943 _ 48: 63. D0
        mov     rax, qword [rel tokval]                 ; 1946 _ 48: 8B. 05, 00000000(rel)
        cmp     rdx, rax                                ; 194D _ 48: 39. C2
        jnz     ?_152                                   ; 1950 _ 75, 34
        mov     dword [rbp-4H], 4456448                 ; 1952 _ C7. 45, FC, 00440000
        mov     eax, dword [rbp-4H]                     ; 1959 _ 8B. 45, FC
        mov     edi, eax                                ; 195C _ 89. C7
        call    warn_active                             ; 195E _ E8, FFFFE733
        movzx   eax, al                                 ; 1963 _ 0F B6. C0
        test    rax, rax                                ; 1966 _ 48: 85. C0
        jz      ?_153                                   ; 1969 _ 74, 2F
        lea     rdx, [rel ?_384]                        ; 196B _ 48: 8D. 15, 00000000(rel)
        mov     eax, dword [rbp-4H]                     ; 1972 _ 8B. 45, FC
        mov     rsi, rdx                                ; 1975 _ 48: 89. D6
        mov     edi, eax                                ; 1978 _ 89. C7
        mov     eax, 0                                  ; 197A _ B8, 00000000
        call    nasm_warn_                              ; 197F _ E8, 00000000(PLT r)
        jmp     ?_153                                   ; 1984 _ EB, 14

?_152:  lea     rax, [rel ?_385]                        ; 1986 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 198D _ 48: 89. C7
        mov     eax, 0                                  ; 1990 _ B8, 00000000
        call    nasm_nonfatal                           ; 1995 _ E8, 00000000(PLT r)
?_153:  mov     rax, qword [rel tokval]                 ; 199A _ 48: 8B. 05, 00000000(rel)
        mov     ecx, eax                                ; 19A1 _ 89. C1
        mov     rax, qword [rbp-18H]                    ; 19A3 _ 48: 8B. 45, E8
        mov     edx, dword [rbp-8H]                     ; 19A7 _ 8B. 55, F8
        add     rdx, 4                                  ; 19AA _ 48: 83. C2, 04
        mov     dword [rax+rdx*4+8H], ecx               ; 19AE _ 89. 4C 90, 08
        mov     eax, 1                                  ; 19B2 _ B8, 00000001
?_154:  leave                                           ; 19B7 _ C9
        ret                                             ; 19B8 _ C3

set_imm_flags:; Local function
        push    rbp                                     ; 19B9 _ 55
        mov     rbp, rsp                                ; 19BA _ 48: 89. E5
        mov     qword [rbp-18H], rdi                    ; 19BD _ 48: 89. 7D, E8
        mov     dword [rbp-1CH], esi                    ; 19C1 _ 89. 75, E4
        mov     rax, qword [rbp-18H]                    ; 19C4 _ 48: 8B. 45, E8
        mov     rax, qword [rax]                        ; 19C8 _ 48: 8B. 00
        and     eax, 40H                                ; 19CB _ 83. E0, 40
        test    rax, rax                                ; 19CE _ 48: 85. C0
        jnz     ?_155                                   ; 19D1 _ 75, 0A
        mov     eax, dword [rbp-1CH]                    ; 19D3 _ 8B. 45, E4
        and     eax, 08H                                ; 19D6 _ 83. E0, 08
        test    eax, eax                                ; 19D9 _ 85. C0
        jz      ?_156                                   ; 19DB _ 74, 07
?_155:  mov     eax, 1                                  ; 19DD _ B8, 00000001
        jmp     ?_157                                   ; 19E2 _ EB, 05

?_156:  mov     eax, 0                                  ; 19E4 _ B8, 00000000
?_157:  mov     byte [rbp-9H], al                       ; 19E9 _ 88. 45, F7
        and     byte [rbp-9H], 01H                      ; 19EC _ 80. 65, F7, 01
        mov     rax, qword [rbp-18H]                    ; 19F0 _ 48: 8B. 45, E8
        mov     rax, qword [rax+28H]                    ; 19F4 _ 48: 8B. 40, 28
        mov     qword [rbp-8H], rax                     ; 19F8 _ 48: 89. 45, F8
        mov     rax, qword [rbp-18H]                    ; 19FC _ 48: 8B. 45, E8
        mov     rax, qword [rax]                        ; 1A00 _ 48: 8B. 00
        and     eax, 02H                                ; 1A03 _ 83. E0, 02
        test    rax, rax                                ; 1A06 _ 48: 85. C0
        jnz     ?_158                                   ; 1A09 _ 75, 0C
        mov     rax, qword [rbp-18H]                    ; 1A0B _ 48: 8B. 45, E8
        mov     rax, qword [rax]                        ; 1A0F _ 48: 8B. 00
        jmp     ?_172                                   ; 1A12 _ E9, 000001DC

?_158:  mov     rax, qword [rbp-18H]                    ; 1A17 _ 48: 8B. 45, E8
        mov     eax, dword [rax+38H]                    ; 1A1B _ 8B. 40, 38
        and     eax, 04H                                ; 1A1E _ 83. E0, 04
        test    eax, eax                                ; 1A21 _ 85. C0
        je      ?_162                                   ; 1A23 _ 0F 84, 00000080
        movzx   eax, byte [rbp-9H]                      ; 1A29 _ 0F B6. 45, F7
        xor     eax, 01H                                ; 1A2D _ 83. F0, 01
        test    al, al                                  ; 1A30 _ 84. C0
        jnz     ?_159                                   ; 1A32 _ 75, 19
        mov     rax, qword [rbp-18H]                    ; 1A34 _ 48: 8B. 45, E8
        mov     rax, qword [rax]                        ; 1A38 _ 48: 8B. 00
        mov     rdx, qword 0FFFF00000000H               ; 1A3B _ 48: BA, 0000FFFF00000000
        and     rax, rdx                                ; 1A45 _ 48: 21. D0
        test    rax, rax                                ; 1A48 _ 48: 85. C0
        jnz     ?_160                                   ; 1A4B _ 75, 17
?_159:  mov     rax, qword [rbp-18H]                    ; 1A4D _ 48: 8B. 45, E8
        mov     rax, qword [rax]                        ; 1A51 _ 48: 8B. 00
        or      rax, 1080002H                           ; 1A54 _ 48: 0D, 01080002
        mov     rdx, rax                                ; 1A5A _ 48: 89. C2
        mov     rax, qword [rbp-18H]                    ; 1A5D _ 48: 8B. 45, E8
        mov     qword [rax], rdx                        ; 1A61 _ 48: 89. 10
?_160:  movzx   eax, byte [rbp-9H]                      ; 1A64 _ 0F B6. 45, F7
        xor     eax, 01H                                ; 1A68 _ 83. F0, 01
        test    al, al                                  ; 1A6B _ 84. C0
        jz      ?_161                                   ; 1A6D _ 74, 17
        mov     rax, qword [rbp-18H]                    ; 1A6F _ 48: 8B. 45, E8
        mov     rax, qword [rax]                        ; 1A73 _ 48: 8B. 00
        or      rax, 0F00002H                           ; 1A76 _ 48: 0D, 00F00002
        mov     rdx, rax                                ; 1A7C _ 48: 89. C2
        mov     rax, qword [rbp-18H]                    ; 1A7F _ 48: 8B. 45, E8
        mov     qword [rax], rdx                        ; 1A83 _ 48: 89. 10
?_161:  mov     rax, qword [rbp-18H]                    ; 1A86 _ 48: 8B. 45, E8
        mov     rax, qword [rax]                        ; 1A8A _ 48: 8B. 00
        or      rax, 2000002H                           ; 1A8D _ 48: 0D, 02000002
        mov     rdx, rax                                ; 1A93 _ 48: 89. C2
        mov     rax, qword [rbp-18H]                    ; 1A96 _ 48: 8B. 45, E8
        mov     qword [rax], rdx                        ; 1A9A _ 48: 89. 10
        mov     rax, qword [rbp-18H]                    ; 1A9D _ 48: 8B. 45, E8
        mov     rax, qword [rax]                        ; 1AA1 _ 48: 8B. 00
        jmp     ?_172                                   ; 1AA4 _ E9, 0000014A

?_162:  mov     rax, qword [rbp-18H]                    ; 1AA9 _ 48: 8B. 45, E8
        mov     eax, dword [rax+38H]                    ; 1AAD _ 8B. 40, 38
        and     eax, 10H                                ; 1AB0 _ 83. E0, 10
        test    eax, eax                                ; 1AB3 _ 85. C0
        jnz     ?_163                                   ; 1AB5 _ 75, 0C
        mov     rax, qword [rbp-18H]                    ; 1AB7 _ 48: 8B. 45, E8
        mov     rax, qword [rax]                        ; 1ABB _ 48: 8B. 00
        jmp     ?_172                                   ; 1ABE _ E9, 00000130

?_163:  mov     rax, qword [rbp-18H]                    ; 1AC3 _ 48: 8B. 45, E8
        mov     rax, qword [rax]                        ; 1AC7 _ 48: 8B. 00
        or      rax, 2000002H                           ; 1ACA _ 48: 0D, 02000002
        mov     rdx, rax                                ; 1AD0 _ 48: 89. C2
        mov     rax, qword [rbp-18H]                    ; 1AD3 _ 48: 8B. 45, E8
        mov     qword [rax], rdx                        ; 1AD7 _ 48: 89. 10
        movzx   eax, byte [rbp-9H]                      ; 1ADA _ 0F B6. 45, F7
        xor     eax, 01H                                ; 1ADE _ 83. F0, 01
        test    al, al                                  ; 1AE1 _ 84. C0
        jnz     ?_164                                   ; 1AE3 _ 75, 19
        mov     rax, qword [rbp-18H]                    ; 1AE5 _ 48: 8B. 45, E8
        mov     rax, qword [rax]                        ; 1AE9 _ 48: 8B. 00
        mov     rdx, qword 0FFFF00000000H               ; 1AEC _ 48: BA, 0000FFFF00000000
        and     rax, rdx                                ; 1AF6 _ 48: 21. D0
        test    rax, rax                                ; 1AF9 _ 48: 85. C0
        jnz     ?_166                                   ; 1AFC _ 75, 43
?_164:  cmp     qword [rbp-8H], 1                       ; 1AFE _ 48: 83. 7D, F8, 01
        jnz     ?_165                                   ; 1B03 _ 75, 17
        mov     rax, qword [rbp-18H]                    ; 1B05 _ 48: 8B. 45, E8
        mov     rax, qword [rax]                        ; 1B09 _ 48: 8B. 00
        or      rax, 80002H                             ; 1B0C _ 48: 0D, 00080002
        mov     rdx, rax                                ; 1B12 _ 48: 89. C2
        mov     rax, qword [rbp-18H]                    ; 1B15 _ 48: 8B. 45, E8
        mov     qword [rax], rdx                        ; 1B19 _ 48: 89. 10
?_165:  cmp     qword [rbp-8H], -16                     ; 1B1C _ 48: 83. 7D, F8, F0
        jl      ?_166                                   ; 1B21 _ 7C, 1E
        cmp     qword [rbp-8H], 15                      ; 1B23 _ 48: 83. 7D, F8, 0F
        jg      ?_166                                   ; 1B28 _ 7F, 17
        mov     rax, qword [rbp-18H]                    ; 1B2A _ 48: 8B. 45, E8
        mov     rax, qword [rax]                        ; 1B2E _ 48: 8B. 00
        or      rax, 1000002H                           ; 1B31 _ 48: 0D, 01000002
        mov     rdx, rax                                ; 1B37 _ 48: 89. C2
        mov     rax, qword [rbp-18H]                    ; 1B3A _ 48: 8B. 45, E8
        mov     qword [rax], rdx                        ; 1B3E _ 48: 89. 10
?_166:  cmp     byte [rbp-9H], 0                        ; 1B41 _ 80. 7D, F7, 00
        jz      ?_167                                   ; 1B45 _ 74, 0C
        mov     rax, qword [rbp-18H]                    ; 1B47 _ 48: 8B. 45, E8
        mov     rax, qword [rax]                        ; 1B4B _ 48: 8B. 00
        jmp     ?_172                                   ; 1B4E _ E9, 000000A0

?_167:  mov     rax, qword [rbp-8H]                     ; 1B53 _ 48: 8B. 45, F8
        mov     edx, eax                                ; 1B57 _ 89. C2
        mov     rax, qword [rbp-8H]                     ; 1B59 _ 48: 8B. 45, F8
        movsx   eax, al                                 ; 1B5D _ 0F BE. C0
        cmp     edx, eax                                ; 1B60 _ 39. C2
        jnz     ?_168                                   ; 1B62 _ 75, 17
        mov     rax, qword [rbp-18H]                    ; 1B64 _ 48: 8B. 45, E8
        mov     rax, qword [rax]                        ; 1B68 _ 48: 8B. 00
        or      rax, 200002H                            ; 1B6B _ 48: 0D, 00200002
        mov     rdx, rax                                ; 1B71 _ 48: 89. C2
        mov     rax, qword [rbp-18H]                    ; 1B74 _ 48: 8B. 45, E8
        mov     qword [rax], rdx                        ; 1B78 _ 48: 89. 10
?_168:  mov     rax, qword [rbp-8H]                     ; 1B7B _ 48: 8B. 45, F8
        mov     edx, eax                                ; 1B7F _ 89. C2
        mov     rax, qword [rbp-8H]                     ; 1B81 _ 48: 8B. 45, F8
        cbw                                             ; 1B85 _ 66: 98
        cmp     dx, ax                                  ; 1B87 _ 66: 39. C2
        jnz     ?_169                                   ; 1B8A _ 75, 17
        mov     rax, qword [rbp-18H]                    ; 1B8C _ 48: 8B. 45, E8
        mov     rax, qword [rax]                        ; 1B90 _ 48: 8B. 00
        or      rax, 100002H                            ; 1B93 _ 48: 0D, 00100002
        mov     rdx, rax                                ; 1B99 _ 48: 89. C2
        mov     rax, qword [rbp-18H]                    ; 1B9C _ 48: 8B. 45, E8
        mov     qword [rax], rdx                        ; 1BA0 _ 48: 89. 10
?_169:  mov     rax, qword [rbp-8H]                     ; 1BA3 _ 48: 8B. 45, F8
        mov     edx, eax                                ; 1BA7 _ 89. C2
        mov     rax, qword [rbp-8H]                     ; 1BA9 _ 48: 8B. 45, F8
        cmp     rdx, rax                                ; 1BAD _ 48: 39. C2
        jnz     ?_170                                   ; 1BB0 _ 75, 17
        mov     rax, qword [rbp-18H]                    ; 1BB2 _ 48: 8B. 45, E8
        mov     rax, qword [rax]                        ; 1BB6 _ 48: 8B. 00
        or      rax, 800002H                            ; 1BB9 _ 48: 0D, 00800002
        mov     rdx, rax                                ; 1BBF _ 48: 89. C2
        mov     rax, qword [rbp-18H]                    ; 1BC2 _ 48: 8B. 45, E8
        mov     qword [rax], rdx                        ; 1BC6 _ 48: 89. 10
?_170:  mov     rax, qword [rbp-8H]                     ; 1BC9 _ 48: 8B. 45, F8
        cdqe                                            ; 1BCD _ 48: 98
        cmp     qword [rbp-8H], rax                     ; 1BCF _ 48: 39. 45, F8
        jnz     ?_171                                   ; 1BD3 _ 75, 17
        mov     rax, qword [rbp-18H]                    ; 1BD5 _ 48: 8B. 45, E8
        mov     rax, qword [rax]                        ; 1BD9 _ 48: 8B. 00
        or      rax, 400002H                            ; 1BDC _ 48: 0D, 00400002
        mov     rdx, rax                                ; 1BE2 _ 48: 89. C2
        mov     rax, qword [rbp-18H]                    ; 1BE5 _ 48: 8B. 45, E8
        mov     qword [rax], rdx                        ; 1BE9 _ 48: 89. 10
?_171:  mov     rax, qword [rbp-18H]                    ; 1BEC _ 48: 8B. 45, E8
        mov     rax, qword [rax]                        ; 1BF0 _ 48: 8B. 00
?_172:  pop     rbp                                     ; 1BF3 _ 5D
        ret                                             ; 1BF4 _ C3

parse_line:; Function begin
        push    rbp                                     ; 1BF5 _ 55
        mov     rbp, rsp                                ; 1BF6 _ 48: 89. E5
        sub     rsp, 256                                ; 1BF9 _ 48: 81. EC, 00000100
        mov     qword [rbp-0E8H], rdi                   ; 1C00 _ 48: 89. BD, FFFFFF18
        mov     qword [rbp-0F0H], rsi                   ; 1C07 _ 48: 89. B5, FFFFFF10
        mov     dword [rbp-0F4H], edx                   ; 1C0E _ 89. 95, FFFFFF0C
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        mov     rax, qword [fs:abs 28H]                 ; 1C14 _ 64 48: 8B. 04 25, 00000028
        mov     qword [rbp-8H], rax                     ; 1C1D _ 48: 89. 45, F8
        xor     eax, eax                                ; 1C21 _ 31. C0
        mov     byte [rbp-0DBH], 0                      ; 1C23 _ C6. 85, FFFFFF25, 00
?_173:  mov     byte [rbp-0DAH], 1                      ; 1C2A _ C6. 85, FFFFFF26, 01
        mov     byte [rbp-0D9H], 0                      ; 1C31 _ C6. 85, FFFFFF27, 00
        mov     rax, qword [rbp-0E8H]                   ; 1C38 _ 48: 8B. 85, FFFFFF18
        mov     rdi, rax                                ; 1C3F _ 48: 89. C7
        call    stdscan_reset                           ; 1C42 _ E8, 00000000(PLT r)
        lea     rax, [rel tokval]                       ; 1C47 _ 48: 8D. 05, 00000000(rel)
        mov     rsi, rax                                ; 1C4E _ 48: 89. C6
        mov     edi, 0                                  ; 1C51 _ BF, 00000000
        call    stdscan                                 ; 1C56 _ E8, 00000000(PLT r)
        mov     dword [rbp-0C8H], eax                   ; 1C5B _ 89. 85, FFFFFF38
        mov     rax, qword [rbp-0F0H]                   ; 1C61 _ 48: 8B. 85, FFFFFF10
        mov     edx, 560                                ; 1C68 _ BA, 00000230
        mov     esi, 0                                  ; 1C6D _ BE, 00000000
        mov     rdi, rax                                ; 1C72 _ 48: 89. C7
        call    memset                                  ; 1C75 _ E8, 00000000(PLT r)
        mov     rax, qword [rbp-0F0H]                   ; 1C7A _ 48: 8B. 85, FFFFFF10
        mov     dword [rax+74H], 1                      ; 1C81 _ C7. 40, 74, 00000001
        mov     rax, qword [rbp-0F0H]                   ; 1C88 _ 48: 8B. 85, FFFFFF10
        mov     dword [rax], -1                         ; 1C8F _ C7. 00, FFFFFFFF
        mov     rax, qword [rbp-0F0H]                   ; 1C95 _ 48: 8B. 85, FFFFFF10
        mov     dword [rax+74H], 1                      ; 1C9C _ C7. 40, 74, 00000001
        mov     rcx, qword [rbp-0F0H]                   ; 1CA3 _ 48: 8B. 8D, FFFFFF10
        mov     rax, qword [rel location]               ; 1CAA _ 48: 8B. 05, 00000000(rel)
        mov     rdx, qword [rel location+8H]            ; 1CB1 _ 48: 8B. 15, 00000000(rel)
        mov     qword [rcx+8H], rax                     ; 1CB8 _ 48: 89. 41, 08
        mov     qword [rcx+10H], rdx                    ; 1CBC _ 48: 89. 51, 10
        mov     eax, dword [rbp-0F4H]                   ; 1CC0 _ 8B. 85, FFFFFF0C
        mov     edx, eax                                ; 1CC6 _ 89. C2
        mov     rax, qword [rbp-0F0H]                   ; 1CC8 _ 48: 8B. 85, FFFFFF10
        mov     byte [rax+7AH], dl                      ; 1CCF _ 88. 50, 7A
        mov     edx, dword [rel optimizing]             ; 1CD2 _ 8B. 15, 00000000(rel)
        mov     rax, qword [rbp-0F0H]                   ; 1CD8 _ 48: 8B. 85, FFFFFF10
        mov     dword [rax+94H], edx                    ; 1CDF _ 89. 90, 00000094
        cmp     dword [rbp-0C8H], 0                     ; 1CE5 _ 83. BD, FFFFFF38, 00
        je      ?_333                                   ; 1CEC _ 0F 84, 00001E11
        cmp     dword [rbp-0C8H], 273                   ; 1CF2 _ 81. BD, FFFFFF38, 00000111
        jz      ?_174                                   ; 1CFC _ 74, 1D
        cmp     byte [rbp-0DBH], 0                      ; 1CFE _ 80. BD, FFFFFF25, 00
        je      ?_180                                   ; 1D05 _ 0F 84, 00000152
        cmp     dword [rbp-0C8H], 293                   ; 1D0B _ 81. BD, FFFFFF38, 00000125
        jne     ?_180                                   ; 1D15 _ 0F 85, 00000142
?_174:  mov     rax, qword [rel tokval]                 ; 1D1B _ 48: 8B. 05, 00000000(rel)
        mov     rdx, qword [rel ?_350]                  ; 1D22 _ 48: 8B. 15, 00000000(rel)
        mov     qword [rbp-50H], rax                    ; 1D29 _ 48: 89. 45, B0
        mov     qword [rbp-48H], rdx                    ; 1D2D _ 48: 89. 55, B8
        mov     rax, qword [rel ?_351]                  ; 1D31 _ 48: 8B. 05, 00000000(rel)
        mov     rdx, qword [rel ?_352]                  ; 1D38 _ 48: 8B. 15, 00000000(rel)
        mov     qword [rbp-40H], rax                    ; 1D3F _ 48: 89. 45, C0
        mov     qword [rbp-38H], rdx                    ; 1D43 _ 48: 89. 55, C8
        mov     rax, qword [rel ?_353]                  ; 1D47 _ 48: 8B. 05, 00000000(rel)
        mov     rdx, qword [rel ?_355]                  ; 1D4E _ 48: 8B. 15, 00000000(rel)
        mov     qword [rbp-30H], rax                    ; 1D55 _ 48: 89. 45, D0
        mov     qword [rbp-28H], rdx                    ; 1D59 _ 48: 89. 55, D8
        mov     byte [rbp-0DAH], 0                      ; 1D5D _ C6. 85, FFFFFF26, 00
        mov     rdx, qword [rel ?_351]                  ; 1D64 _ 48: 8B. 15, 00000000(rel)
        mov     rax, qword [rbp-0F0H]                   ; 1D6B _ 48: 8B. 85, FFFFFF10
        mov     qword [rax+60H], rdx                    ; 1D72 _ 48: 89. 50, 60
        lea     rax, [rel tokval]                       ; 1D76 _ 48: 8D. 05, 00000000(rel)
        mov     rsi, rax                                ; 1D7D _ 48: 89. C6
        mov     edi, 0                                  ; 1D80 _ BF, 00000000
        call    stdscan                                 ; 1D85 _ E8, 00000000(PLT r)
        mov     dword [rbp-0C8H], eax                   ; 1D8A _ 89. 85, FFFFFF38
        cmp     dword [rbp-0C8H], 58                    ; 1D90 _ 83. BD, FFFFFF38, 3A
        setne   al                                      ; 1D97 _ 0F 95. C0
        mov     byte [rbp-0D9H], al                     ; 1D9A _ 88. 85, FFFFFF27
        cmp     dword [rbp-0C8H], 58                    ; 1DA0 _ 83. BD, FFFFFF38, 3A
        jnz     ?_175                                   ; 1DA7 _ 75, 1C
        lea     rax, [rel tokval]                       ; 1DA9 _ 48: 8D. 05, 00000000(rel)
        mov     rsi, rax                                ; 1DB0 _ 48: 89. C6
        mov     edi, 0                                  ; 1DB3 _ BF, 00000000
        call    stdscan                                 ; 1DB8 _ E8, 00000000(PLT r)
        mov     dword [rbp-0C8H], eax                   ; 1DBD _ 89. 85, FFFFFF38
        jmp     ?_176                                   ; 1DC3 _ EB, 48

?_175:  cmp     dword [rbp-0C8H], 0                     ; 1DC5 _ 83. BD, FFFFFF38, 00
        jnz     ?_176                                   ; 1DCC _ 75, 3F
        mov     dword [rbp-0B4H], 720896                ; 1DCE _ C7. 85, FFFFFF4C, 000B0000
        mov     eax, dword [rbp-0B4H]                   ; 1DD8 _ 8B. 85, FFFFFF4C
        mov     edi, eax                                ; 1DDE _ 89. C7
        call    warn_active                             ; 1DE0 _ E8, FFFFE2B1
        movzx   eax, al                                 ; 1DE5 _ 0F B6. C0
        test    rax, rax                                ; 1DE8 _ 48: 85. C0
        jz      ?_176                                   ; 1DEB _ 74, 20
        mov     rcx, qword [rbp-38H]                    ; 1DED _ 48: 8B. 4D, C8
        mov     edx, dword [rbp-30H]                    ; 1DF1 _ 8B. 55, D0
        lea     rsi, [rel ?_386]                        ; 1DF4 _ 48: 8D. 35, 00000000(rel)
        mov     eax, dword [rbp-0B4H]                   ; 1DFB _ 8B. 85, FFFFFF4C
        mov     edi, eax                                ; 1E01 _ 89. C7
        mov     eax, 0                                  ; 1E03 _ B8, 00000000
        call    nasm_warn_                              ; 1E08 _ E8, 00000000(PLT r)
?_176:  cmp     dword [rbp-0C8H], 293                   ; 1E0D _ 81. BD, FFFFFF38, 00000125
        jnz     ?_177                                   ; 1E17 _ 75, 0D
        mov     rax, qword [rel tokval]                 ; 1E19 _ 48: 8B. 05, 00000000(rel)
        cmp     rax, 17                                 ; 1E20 _ 48: 83. F8, 11
        jz      ?_180                                   ; 1E24 _ 74, 37
?_177:  mov     rdx, qword [rel location]               ; 1E26 _ 48: 8B. 15, 00000000(rel)
        movzx   eax, byte [rel in_absolute]             ; 1E2D _ 0F B6. 05, 00000000(rel)
        test    al, al                                  ; 1E34 _ 84. C0
        jz      ?_178                                   ; 1E36 _ 74, 08
        mov     eax, dword [rel absolute+8H]            ; 1E38 _ 8B. 05, 00000000(rel)
        jmp     ?_179                                   ; 1E3E _ EB, 06

?_178:  mov     eax, dword [rel location+8H]            ; 1E40 _ 8B. 05, 00000000(rel)
?_179:  mov     rcx, qword [rbp-0F0H]                   ; 1E46 _ 48: 8B. 8D, FFFFFF10
        mov     rdi, qword [rcx+60H]                    ; 1E4D _ 48: 8B. 79, 60
        mov     ecx, 1                                  ; 1E51 _ B9, 00000001
        mov     esi, eax                                ; 1E56 _ 89. C6
        call    define_label                            ; 1E58 _ E8, 00000000(PLT r)
?_180:  mov     byte [rbp-0D7H], 0                      ; 1E5D _ C6. 85, FFFFFF29, 00
        jmp     ?_185                                   ; 1E64 _ E9, 00000104

?_181:  cmp     dword [rbp-0C8H], 280                   ; 1E69 _ 81. BD, FFFFFF38, 00000118
        jne     ?_183                                   ; 1E73 _ 0F 85, 000000B6
        lea     rax, [rel tokval]                       ; 1E79 _ 48: 8D. 05, 00000000(rel)
        mov     rsi, rax                                ; 1E80 _ 48: 89. C6
        mov     edi, 0                                  ; 1E83 _ BF, 00000000
        call    stdscan                                 ; 1E88 _ E8, 00000000(PLT r)
        mov     dword [rbp-0C8H], eax                   ; 1E8D _ 89. 85, FFFFFF38
        call    pass_stable                             ; 1E93 _ E8, FFFFE23D
        movzx   edx, al                                 ; 1E98 _ 0F B6. D0
        lea     rax, [rel tokval]                       ; 1E9B _ 48: 8D. 05, 00000000(rel)
; Note: Unusual relocation type for this operand
        mov     rcx, qword [rel stdscan+$+??]           ; 1EA2 _ 48: 8B. 0D, 00000000
        mov     rdi, rcx                                ; 1EA9 _ 48: 89. CF
        mov     r9d, 0                                  ; 1EAC _ 41: B9, 00000000
        mov     r8d, edx                                ; 1EB2 _ 41: 89. D0
        mov     ecx, 0                                  ; 1EB5 _ B9, 00000000
        mov     rdx, rax                                ; 1EBA _ 48: 89. C2
        mov     esi, 0                                  ; 1EBD _ BE, 00000000
        call    evaluate                                ; 1EC2 _ E8, 00000000(PLT r)
        mov     qword [rbp-80H], rax                    ; 1EC7 _ 48: 89. 45, 80
        mov     eax, dword [rel ?_354]                  ; 1ECB _ 8B. 05, 00000000(rel)
        mov     dword [rbp-0C8H], eax                   ; 1ED1 _ 89. 85, FFFFFF38
        cmp     qword [rbp-80H], 0                      ; 1ED7 _ 48: 83. 7D, 80, 00
        je      ?_334                                   ; 1EDC _ 0F 84, 00001C24
        mov     rax, qword [rbp-80H]                    ; 1EE2 _ 48: 8B. 45, 80
        mov     rdi, rax                                ; 1EE6 _ 48: 89. C7
        call    is_simple                               ; 1EE9 _ E8, 00000000(PLT r)
        xor     eax, 01H                                ; 1EEE _ 83. F0, 01
        test    al, al                                  ; 1EF1 _ 84. C0
        jz      ?_182                                   ; 1EF3 _ 74, 24
        lea     rax, [rel ?_387]                        ; 1EF5 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 1EFC _ 48: 89. C7
        mov     eax, 0                                  ; 1EFF _ B8, 00000000
        call    nasm_nonfatal                           ; 1F04 _ E8, 00000000(PLT r)
        mov     rax, qword [rbp-0F0H]                   ; 1F09 _ 48: 8B. 85, FFFFFF10
        mov     dword [rax+74H], 1                      ; 1F10 _ C7. 40, 74, 00000001
        jmp     ?_184                                   ; 1F17 _ EB, 4D

?_182:  mov     rax, qword [rbp-80H]                    ; 1F19 _ 48: 8B. 45, 80
        mov     rax, qword [rax+8H]                     ; 1F1D _ 48: 8B. 40, 08
        mov     edx, eax                                ; 1F21 _ 89. C2
        mov     rax, qword [rbp-0F0H]                   ; 1F23 _ 48: 8B. 85, FFFFFF10
        mov     dword [rax+74H], edx                    ; 1F2A _ 89. 50, 74
        jmp     ?_184                                   ; 1F2D _ EB, 37

?_183:  mov     rax, qword [rbp-0F0H]                   ; 1F2F _ 48: 8B. 85, FFFFFF10
        mov     rdi, rax                                ; 1F36 _ 48: 89. C7
        call    add_prefix                              ; 1F39 _ E8, FFFFF927
        xor     eax, 01H                                ; 1F3E _ 83. F0, 01
        test    al, al                                  ; 1F41 _ 84. C0
        jnz     ?_186                                   ; 1F43 _ 75, 37
        mov     byte [rbp-0D7H], 1                      ; 1F45 _ C6. 85, FFFFFF29, 01
        lea     rax, [rel tokval]                       ; 1F4C _ 48: 8D. 05, 00000000(rel)
        mov     rsi, rax                                ; 1F53 _ 48: 89. C6
        mov     edi, 0                                  ; 1F56 _ BF, 00000000
        call    stdscan                                 ; 1F5B _ E8, 00000000(PLT r)
        mov     dword [rbp-0C8H], eax                   ; 1F60 _ 89. 85, FFFFFF38
?_184:  mov     byte [rbp-0DAH], 0                      ; 1F66 _ C6. 85, FFFFFF26, 00
?_185:  cmp     dword [rbp-0C8H], 0                     ; 1F6D _ 83. BD, FFFFFF38, 00
        jne     ?_181                                   ; 1F74 _ 0F 85, FFFFFEEF
        jmp     ?_187                                   ; 1F7A _ EB, 01

?_186:  nop                                             ; 1F7C _ 90
?_187:  cmp     dword [rbp-0C8H], 293                   ; 1F7D _ 81. BD, FFFFFF38, 00000125
        je      ?_195                                   ; 1F87 _ 0F 84, 00000165
        cmp     dword [rbp-0C8H], 0                     ; 1F8D _ 83. BD, FFFFFF38, 00
        jne     ?_188                                   ; 1F94 _ 0F 85, 000000AF
        cmp     byte [rbp-0D7H], 0                      ; 1F9A _ 80. BD, FFFFFF29, 00
        je      ?_194                                   ; 1FA1 _ 0F 84, 0000013F
        mov     rax, qword [rbp-0F0H]                   ; 1FA7 _ 48: 8B. 85, FFFFFF10
        mov     dword [rax], 8                          ; 1FAE _ C7. 00, 00000008
        mov     rax, qword [rbp-0F0H]                   ; 1FB4 _ 48: 8B. 85, FFFFFF10
        mov     byte [rax+7DH], 1                       ; 1FBB _ C6. 40, 7D, 01
        mov     rax, qword [rbp-0F0H]                   ; 1FBF _ 48: 8B. 85, FFFFFF10
        mov     qword [rax+0C0H], 262146                ; 1FC6 _ 48: C7. 80, 000000C0, 00040002
        mov     rax, qword [rbp-0F0H]                   ; 1FD1 _ 48: 8B. 85, FFFFFF10
        mov     dword [rax+0F8H], 16                    ; 1FD8 _ C7. 80, 000000F8, 00000010
        mov     rax, qword [rbp-0F0H]                   ; 1FE2 _ 48: 8B. 85, FFFFFF10
        mov     qword [rax+0E8H], 0                     ; 1FE9 _ 48: C7. 80, 000000E8, 00000000
        mov     rax, qword [rbp-0F0H]                   ; 1FF4 _ 48: 8B. 85, FFFFFF10
        mov     dword [rax+0F0H], -1                    ; 1FFB _ C7. 80, 000000F0, FFFFFFFF
        mov     rax, qword [rbp-0F0H]                   ; 2005 _ 48: 8B. 85, FFFFFF10
        mov     edx, dword [rax+0F0H]                   ; 200C _ 8B. 90, 000000F0
        mov     rax, qword [rbp-0F0H]                   ; 2012 _ 48: 8B. 85, FFFFFF10
        mov     dword [rax+0E4H], edx                   ; 2019 _ 89. 90, 000000E4
        mov     rax, qword [rbp-0F0H]                   ; 201F _ 48: 8B. 85, FFFFFF10
        mov     eax, dword [rax+94H]                    ; 2026 _ 8B. 80, 00000094
        mov     rdx, qword [rbp-0F0H]                   ; 202C _ 48: 8B. 95, FFFFFF10
        add     rdx, 192                                ; 2033 _ 48: 81. C2, 000000C0
        mov     esi, eax                                ; 203A _ 89. C6
        mov     rdi, rdx                                ; 203C _ 48: 89. D7
        call    set_imm_flags                           ; 203F _ E8, FFFFF975
        jmp     ?_194                                   ; 2044 _ E9, 0000009D

?_188:  movzx   eax, byte [rbp-0DAH]                    ; 2049 _ 0F B6. 85, FFFFFF26
        xor     eax, 01H                                ; 2050 _ 83. F0, 01
        test    al, al                                  ; 2053 _ 84. C0
        jz      ?_193                                   ; 2055 _ 74, 5C
        mov     rsi, qword [rel ?_352]                  ; 2057 _ 48: 8B. 35, 00000000(rel)
        mov     ecx, dword [rel ?_353]                  ; 205E _ 8B. 0D, 00000000(rel)
        cmp     byte [rbp-0D9H], 0                      ; 2064 _ 80. BD, FFFFFF27, 00
        jz      ?_189                                   ; 206B _ 74, 09
        lea     rdx, [rel ?_388]                        ; 206D _ 48: 8D. 15, 00000000(rel)
        jmp     ?_190                                   ; 2074 _ EB, 07

?_189:  lea     rdx, [rel ?_389]                        ; 2076 _ 48: 8D. 15, 00000000(rel)
?_190:  cmp     byte [rbp-0D9H], 0                      ; 207D _ 80. BD, FFFFFF27, 00
        jz      ?_191                                   ; 2084 _ 74, 0D
        mov     rax, qword [rbp-0F0H]                   ; 2086 _ 48: 8B. 85, FFFFFF10
        mov     rax, qword [rax+60H]                    ; 208D _ 48: 8B. 40, 60
        jmp     ?_192                                   ; 2091 _ EB, 07

?_191:  lea     rax, [rel ?_389]                        ; 2093 _ 48: 8D. 05, 00000000(rel)
?_192:  lea     rdi, [rel ?_390]                        ; 209A _ 48: 8D. 3D, 00000000(rel)
        mov     r8, rsi                                 ; 20A1 _ 49: 89. F0
        mov     rsi, rax                                ; 20A4 _ 48: 89. C6
        mov     eax, 0                                  ; 20A7 _ B8, 00000000
        call    nasm_nonfatal                           ; 20AC _ E8, 00000000(PLT r)
        jmp     ?_194                                   ; 20B1 _ EB, 33

?_193:  mov     rax, qword [rbp-0F0H]                   ; 20B3 _ 48: 8B. 85, FFFFFF10
        mov     rax, qword [rax+60H]                    ; 20BA _ 48: 8B. 40, 60
        test    rax, rax                                ; 20BE _ 48: 85. C0
        jnz     ?_194                                   ; 20C1 _ 75, 23
        mov     rdx, qword [rel ?_352]                  ; 20C3 _ 48: 8B. 15, 00000000(rel)
        mov     eax, dword [rel ?_353]                  ; 20CA _ 8B. 05, 00000000(rel)
        lea     rcx, [rel ?_391]                        ; 20D0 _ 48: 8D. 0D, 00000000(rel)
        mov     esi, eax                                ; 20D7 _ 89. C6
        mov     rdi, rcx                                ; 20D9 _ 48: 89. CF
        mov     eax, 0                                  ; 20DC _ B8, 00000000
        call    nasm_nonfatal                           ; 20E1 _ E8, 00000000(PLT r)
?_194:  mov     rax, qword [rbp-0F0H]                   ; 20E6 _ 48: 8B. 85, FFFFFF10
        jmp     ?_339                                   ; 20ED _ E9, 00001A32

?_195:  mov     rax, qword [rel tokval]                 ; 20F2 _ 48: 8B. 05, 00000000(rel)
        mov     edx, eax                                ; 20F9 _ 89. C2
        mov     rax, qword [rbp-0F0H]                   ; 20FB _ 48: 8B. 85, FFFFFF10
        mov     dword [rax], edx                        ; 2102 _ 89. 10
        call    pass_final                              ; 2104 _ E8, FFFFDFDD
        test    al, al                                  ; 2109 _ 84. C0
        jnz     ?_196                                   ; 210B _ 75, 0E
        mov     rax, qword [rbp-0F0H]                   ; 210D _ 48: 8B. 85, FFFFFF10
        mov     eax, dword [rax]                        ; 2114 _ 8B. 00
        cmp     eax, 16                                 ; 2116 _ 83. F8, 10
        jnz     ?_197                                   ; 2119 _ 75, 07
?_196:  mov     eax, 1                                  ; 211B _ B8, 00000001
        jmp     ?_198                                   ; 2120 _ EB, 05

?_197:  mov     eax, 0                                  ; 2122 _ B8, 00000000
?_198:  mov     byte [rbp-0D1H], al                     ; 2127 _ 88. 85, FFFFFF2F
        and     byte [rbp-0D1H], 01H                    ; 212D _ 80. A5, FFFFFF2F, 01
        mov     rax, qword [rbp-0F0H]                   ; 2134 _ 48: 8B. 85, FFFFFF10
        mov     eax, dword [rax]                        ; 213B _ 8B. 00
        mov     edi, eax                                ; 213D _ 89. C7
        call    opcode_is_db                            ; 213F _ E8, FFFFDFC0
        test    al, al                                  ; 2144 _ 84. C0
        jnz     ?_199                                   ; 2146 _ 75, 12
        mov     rax, qword [rbp-0F0H]                   ; 2148 _ 48: 8B. 85, FFFFFF10
        mov     eax, dword [rax]                        ; 214F _ 8B. 00
        cmp     eax, 16                                 ; 2151 _ 83. F8, 10
        jne     ?_209                                   ; 2154 _ 0F 85, 00000233
?_199:  lea     rax, [rel tokval]                       ; 215A _ 48: 8D. 05, 00000000(rel)
        mov     rsi, rax                                ; 2161 _ 48: 89. C6
        mov     edi, 0                                  ; 2164 _ BF, 00000000
        call    stdscan                                 ; 2169 _ E8, 00000000(PLT r)
        mov     dword [rbp-0C8H], eax                   ; 216E _ 89. 85, FFFFFF38
        cmp     byte [rbp-0DAH], 0                      ; 2174 _ 80. BD, FFFFFF26, 00
        jz      ?_200                                   ; 217B _ 74, 15
        cmp     dword [rbp-0C8H], 58                    ; 217D _ 83. BD, FFFFFF38, 3A
        jnz     ?_200                                   ; 2184 _ 75, 0C
        mov     byte [rbp-0DBH], 1                      ; 2186 _ C6. 85, FFFFFF25, 01
        jmp     ?_173                                   ; 218D _ E9, FFFFFA98

?_200:  mov     byte [rbp-0DAH], 0                      ; 2192 _ C6. 85, FFFFFF26, 00
        mov     rax, qword [rbp-0F0H]                   ; 2199 _ 48: 8B. 85, FFFFFF10
        mov     eax, dword [rax]                        ; 21A0 _ 8B. 00
        mov     edi, eax                                ; 21A2 _ 89. C7
        call    db_bytes                                ; 21A4 _ E8, FFFFDF7F
        mov     edx, eax                                ; 21A9 _ 89. C2
        mov     rax, qword [rbp-0F0H]                   ; 21AB _ 48: 8B. 85, FFFFFF10
        lea     rcx, [rax+68H]                          ; 21B2 _ 48: 8D. 48, 68
        movzx   eax, byte [rbp-0D1H]                    ; 21B6 _ 0F B6. 85, FFFFFF2F
        mov     esi, eax                                ; 21BD _ 89. C6
        mov     rdi, rcx                                ; 21BF _ 48: 89. CF
        call    parse_eops                              ; 21C2 _ E8, FFFFECEB
        mov     dword [rbp-0A8H], eax                   ; 21C7 _ 89. 85, FFFFFF58
        cmp     dword [rbp-0A8H], 0                     ; 21CD _ 83. BD, FFFFFF58, 00
        js      ?_335                                   ; 21D4 _ 0F 88, 0000192F
        mov     rax, qword [rbp-0F0H]                   ; 21DA _ 48: 8B. 85, FFFFFF10
        mov     eax, dword [rax]                        ; 21E1 _ 8B. 00
        cmp     eax, 16                                 ; 21E3 _ 83. F8, 10
        jne     ?_207                                   ; 21E6 _ 0F 85, 0000013F
        mov     rax, qword [rbp-0F0H]                   ; 21EC _ 48: 8B. 85, FFFFFF10
        mov     rax, qword [rax+68H]                    ; 21F3 _ 48: 8B. 40, 68
        test    rax, rax                                ; 21F7 _ 48: 85. C0
        jz      ?_201                                   ; 21FA _ 74, 13
        mov     rax, qword [rbp-0F0H]                   ; 21FC _ 48: 8B. 85, FFFFFF10
        mov     rax, qword [rax+68H]                    ; 2203 _ 48: 8B. 40, 68
        mov     eax, dword [rax+28H]                    ; 2207 _ 8B. 40, 28
        cmp     eax, 2                                  ; 220A _ 83. F8, 02
        jz      ?_202                                   ; 220D _ 74, 19
?_201:  lea     rax, [rel ?_392]                        ; 220F _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 2216 _ 48: 89. C7
        mov     eax, 0                                  ; 2219 _ B8, 00000000
        call    nasm_nonfatal                           ; 221E _ E8, 00000000(PLT r)
        jmp     ?_206                                   ; 2223 _ E9, 000000FE

?_202:  mov     rax, qword [rbp-0F0H]                   ; 2228 _ 48: 8B. 85, FFFFFF10
        mov     rax, qword [rax+68H]                    ; 222F _ 48: 8B. 40, 68
        mov     rax, qword [rax]                        ; 2233 _ 48: 8B. 00
        test    rax, rax                                ; 2236 _ 48: 85. C0
        jz      ?_203                                   ; 2239 _ 74, 2F
        mov     rax, qword [rbp-0F0H]                   ; 223B _ 48: 8B. 85, FFFFFF10
        mov     rax, qword [rax+68H]                    ; 2242 _ 48: 8B. 40, 68
        mov     rax, qword [rax]                        ; 2246 _ 48: 8B. 00
        mov     eax, dword [rax+28H]                    ; 2249 _ 8B. 40, 28
        cmp     eax, 5                                  ; 224C _ 83. F8, 05
        jz      ?_203                                   ; 224F _ 74, 19
        lea     rax, [rel ?_393]                        ; 2251 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 2258 _ 48: 89. C7
        mov     eax, 0                                  ; 225B _ B8, 00000000
        call    nasm_nonfatal                           ; 2260 _ E8, 00000000(PLT r)
        jmp     ?_206                                   ; 2265 _ E9, 000000BC

?_203:  mov     rax, qword [rbp-0F0H]                   ; 226A _ 48: 8B. 85, FFFFFF10
        mov     rax, qword [rax+68H]                    ; 2271 _ 48: 8B. 40, 68
        mov     rax, qword [rax]                        ; 2275 _ 48: 8B. 00
        test    rax, rax                                ; 2278 _ 48: 85. C0
        jz      ?_204                                   ; 227B _ 74, 45
        mov     rax, qword [rbp-0F0H]                   ; 227D _ 48: 8B. 85, FFFFFF10
        mov     rax, qword [rax+68H]                    ; 2284 _ 48: 8B. 40, 68
        mov     rax, qword [rax]                        ; 2288 _ 48: 8B. 00
        mov     rax, qword [rax]                        ; 228B _ 48: 8B. 00
        test    rax, rax                                ; 228E _ 48: 85. C0
        jz      ?_204                                   ; 2291 _ 74, 2F
        mov     rax, qword [rbp-0F0H]                   ; 2293 _ 48: 8B. 85, FFFFFF10
        mov     rax, qword [rax+68H]                    ; 229A _ 48: 8B. 40, 68
        mov     rax, qword [rax]                        ; 229E _ 48: 8B. 00
        mov     rax, qword [rax]                        ; 22A1 _ 48: 8B. 00
        mov     eax, dword [rax+28H]                    ; 22A4 _ 8B. 40, 28
        cmp     eax, 5                                  ; 22A7 _ 83. F8, 05
        jz      ?_204                                   ; 22AA _ 74, 16
        lea     rax, [rel ?_394]                        ; 22AC _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 22B3 _ 48: 89. C7
        mov     eax, 0                                  ; 22B6 _ B8, 00000000
        call    nasm_nonfatal                           ; 22BB _ E8, 00000000(PLT r)
        jmp     ?_206                                   ; 22C0 _ EB, 64

?_204:  mov     rax, qword [rbp-0F0H]                   ; 22C2 _ 48: 8B. 85, FFFFFF10
        mov     rax, qword [rax+68H]                    ; 22C9 _ 48: 8B. 40, 68
        mov     rax, qword [rax]                        ; 22CD _ 48: 8B. 00
        test    rax, rax                                ; 22D0 _ 48: 85. C0
        jz      ?_205                                   ; 22D3 _ 74, 45
        mov     rax, qword [rbp-0F0H]                   ; 22D5 _ 48: 8B. 85, FFFFFF10
        mov     rax, qword [rax+68H]                    ; 22DC _ 48: 8B. 40, 68
        mov     rax, qword [rax]                        ; 22E0 _ 48: 8B. 00
        mov     rax, qword [rax]                        ; 22E3 _ 48: 8B. 00
        test    rax, rax                                ; 22E6 _ 48: 85. C0
        jz      ?_205                                   ; 22E9 _ 74, 2F
        mov     rax, qword [rbp-0F0H]                   ; 22EB _ 48: 8B. 85, FFFFFF10
        mov     rax, qword [rax+68H]                    ; 22F2 _ 48: 8B. 40, 68
        mov     rax, qword [rax]                        ; 22F6 _ 48: 8B. 00
        mov     rax, qword [rax]                        ; 22F9 _ 48: 8B. 00
        mov     rax, qword [rax]                        ; 22FC _ 48: 8B. 00
        test    rax, rax                                ; 22FF _ 48: 85. C0
        jz      ?_205                                   ; 2302 _ 74, 16
        lea     rax, [rel ?_395]                        ; 2304 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 230B _ 48: 89. C7
        mov     eax, 0                                  ; 230E _ B8, 00000000
        call    nasm_nonfatal                           ; 2313 _ E8, 00000000(PLT r)
        jmp     ?_206                                   ; 2318 _ EB, 0C

?_205:  mov     rax, qword [rbp-0F0H]                   ; 231A _ 48: 8B. 85, FFFFFF10
        jmp     ?_339                                   ; 2321 _ E9, 000017FE

?_206:  jmp     ?_338                                   ; 2326 _ E9, 000017E5

?_207:  mov     eax, dword [rbp-0A8H]                   ; 232B _ 8B. 85, FFFFFF58
        mov     edx, eax                                ; 2331 _ 89. C2
        mov     rax, qword [rbp-0F0H]                   ; 2333 _ 48: 8B. 85, FFFFFF10
        mov     byte [rax+7DH], dl                      ; 233A _ 88. 50, 7D
        cmp     dword [rbp-0A8H], 0                     ; 233D _ 83. BD, FFFFFF58, 00
        jnz     ?_208                                   ; 2344 _ 75, 3B
        mov     dword [rbp-0A4H], 65536                 ; 2346 _ C7. 85, FFFFFF5C, 00010000
        mov     eax, dword [rbp-0A4H]                   ; 2350 _ 8B. 85, FFFFFF5C
        mov     edi, eax                                ; 2356 _ 89. C7
        call    warn_active                             ; 2358 _ E8, FFFFDD39
        movzx   eax, al                                 ; 235D _ 0F B6. C0
        test    rax, rax                                ; 2360 _ 48: 85. C0
        jz      ?_208                                   ; 2363 _ 74, 1C
        lea     rdx, [rel ?_396]                        ; 2365 _ 48: 8D. 15, 00000000(rel)
        mov     eax, dword [rbp-0A4H]                   ; 236C _ 8B. 85, FFFFFF5C
        mov     rsi, rdx                                ; 2372 _ 48: 89. D6
        mov     edi, eax                                ; 2375 _ 89. C7
        mov     eax, 0                                  ; 2377 _ B8, 00000000
        call    nasm_warn_                              ; 237C _ E8, 00000000(PLT r)
?_208:  mov     rax, qword [rbp-0F0H]                   ; 2381 _ 48: 8B. 85, FFFFFF10
        jmp     ?_339                                   ; 2388 _ E9, 00001797

?_209:  mov     rax, qword [rbp-0F0H]                   ; 238D _ 48: 8B. 85, FFFFFF10
        mov     eax, dword [rax]                        ; 2394 _ 8B. 00
        cmp     eax, 116                                ; 2396 _ 83. F8, 74
        jz      ?_210                                   ; 2399 _ 74, 10
        mov     rax, qword [rbp-0F0H]                   ; 239B _ 48: 8B. 85, FFFFFF10
        mov     eax, dword [rax]                        ; 23A2 _ 8B. 00
        cmp     eax, 171                                ; 23A4 _ 3D, 000000AB
        jnz     ?_211                                   ; 23A9 _ 75, 07
?_210:  mov     eax, 1                                  ; 23AB _ B8, 00000001
        jmp     ?_212                                   ; 23B0 _ EB, 05

?_211:  mov     eax, 0                                  ; 23B2 _ B8, 00000000
?_212:  mov     byte [rbp-0D0H], al                     ; 23B7 _ 88. 85, FFFFFF30
        and     byte [rbp-0D0H], 01H                    ; 23BD _ 80. A5, FFFFFF30, 01
        mov     dword [rbp-0CCH], 0                     ; 23C4 _ C7. 85, FFFFFF34, 00000000
        jmp     ?_214                                   ; 23CE _ EB, 3F

?_213:  mov     ecx, dword [rbp-0CCH]                   ; 23D0 _ 8B. 8D, FFFFFF34
        mov     eax, dword [rbp-0CCH]                   ; 23D6 _ 8B. 85, FFFFFF34
        movsxd  rdx, eax                                ; 23DC _ 48: 63. D0
        mov     rax, rdx                                ; 23DF _ 48: 89. D0
        shl     rax, 3                                  ; 23E2 _ 48: C1. E0, 03
        add     rax, rdx                                ; 23E6 _ 48: 01. D0
        shl     rax, 3                                  ; 23E9 _ 48: C1. E0, 03
        lea     rdx, [rax+0C0H]                         ; 23ED _ 48: 8D. 90, 000000C0
        mov     rax, qword [rbp-0F0H]                   ; 23F4 _ 48: 8B. 85, FFFFFF10
        add     rax, rdx                                ; 23FB _ 48: 01. D0
        mov     esi, ecx                                ; 23FE _ 89. CE
        mov     rdi, rax                                ; 2400 _ 48: 89. C7
        call    init_operand                            ; 2403 _ E8, FFFFE32C
        add     dword [rbp-0CCH], 1                     ; 2408 _ 83. 85, FFFFFF34, 01
?_214:  cmp     dword [rbp-0CCH], 4                     ; 240F _ 83. BD, FFFFFF34, 04
        jle     ?_213                                   ; 2416 _ 7E, B8
        mov     dword [rbp-0CCH], 0                     ; 2418 _ C7. 85, FFFFFF34, 00000000
        jmp     ?_330                                   ; 2422 _ E9, 000016B1

?_215:  mov     eax, dword [rbp-0CCH]                   ; 2427 _ 8B. 85, FFFFFF34
        movsxd  rdx, eax                                ; 242D _ 48: 63. D0
        mov     rax, rdx                                ; 2430 _ 48: 89. D0
        shl     rax, 3                                  ; 2433 _ 48: C1. E0, 03
        add     rax, rdx                                ; 2437 _ 48: 01. D0
        shl     rax, 3                                  ; 243A _ 48: C1. E0, 03
        lea     rdx, [rax+0C0H]                         ; 243E _ 48: 8D. 90, 000000C0
        mov     rax, qword [rbp-0F0H]                   ; 2445 _ 48: 8B. 85, FFFFFF10
        add     rax, rdx                                ; 244C _ 48: 01. D0
        mov     qword [rbp-0A0H], rax                   ; 244F _ 48: 89. 85, FFFFFF60
        mov     byte [rbp-0D6H], 0                      ; 2456 _ C6. 85, FFFFFF2A, 00
        mov     dword [rbp-0C4H], 0                     ; 245D _ C7. 85, FFFFFF3C, 00000000
        mov     dword [rbp-0C0H], 0                     ; 2467 _ C7. 85, FFFFFF40, 00000000
; Note: Length-changing prefix causes delay on old Intel processors
        mov     word [rbp-0CEH], 0                      ; 2471 _ 66: C7. 85, FFFFFF32, 0000
        lea     rax, [rel tokval]                       ; 247A _ 48: 8D. 05, 00000000(rel)
        mov     rsi, rax                                ; 2481 _ 48: 89. C6
        mov     edi, 0                                  ; 2484 _ BF, 00000000
        call    stdscan                                 ; 2489 _ E8, 00000000(PLT r)
        mov     dword [rbp-0C8H], eax                   ; 248E _ 89. 85, FFFFFF38
        cmp     byte [rbp-0DAH], 0                      ; 2494 _ 80. BD, FFFFFF26, 00
        jz      ?_216                                   ; 249B _ 74, 15
        cmp     dword [rbp-0C8H], 58                    ; 249D _ 83. BD, FFFFFF38, 3A
        jnz     ?_216                                   ; 24A4 _ 75, 0C
        mov     byte [rbp-0DBH], 1                      ; 24A6 _ C6. 85, FFFFFF25, 01
        jmp     ?_173                                   ; 24AD _ E9, FFFFF778

?_216:  mov     byte [rbp-0DAH], 0                      ; 24B2 _ C6. 85, FFFFFF26, 00
        cmp     dword [rbp-0CCH], 0                     ; 24B9 _ 83. BD, FFFFFF34, 00
        jnz     ?_219                                   ; 24C0 _ 75, 3C
        jmp     ?_218                                   ; 24C2 _ EB, 1A

?_217:  lea     rax, [rel tokval]                       ; 24C4 _ 48: 8D. 05, 00000000(rel)
        mov     rsi, rax                                ; 24CB _ 48: 89. C6
        mov     edi, 0                                  ; 24CE _ BF, 00000000
        call    stdscan                                 ; 24D3 _ E8, 00000000(PLT r)
        mov     dword [rbp-0C8H], eax                   ; 24D8 _ 89. 85, FFFFFF38
?_218:  mov     eax, dword [rel ?_355]                  ; 24DE _ 8B. 05, 00000000(rel)
        and     eax, 01H                                ; 24E4 _ 83. E0, 01
        test    eax, eax                                ; 24E7 _ 85. C0
        jz      ?_219                                   ; 24E9 _ 74, 13
        mov     rax, qword [rbp-0F0H]                   ; 24EB _ 48: 8B. 85, FFFFFF10
        mov     rdi, rax                                ; 24F2 _ 48: 89. C7
        call    add_prefix                              ; 24F5 _ E8, FFFFF36B
        test    al, al                                  ; 24FA _ 84. C0
        jnz     ?_217                                   ; 24FC _ 75, C6
?_219:  cmp     dword [rbp-0C8H], 0                     ; 24FE _ 83. BD, FFFFFF38, 00
        je      ?_331                                   ; 2505 _ 0F 84, 000015DC
        mov     rax, qword [rbp-0A0H]                   ; 250B _ 48: 8B. 85, FFFFFF60
        mov     qword [rax], 0                          ; 2512 _ 48: C7. 00, 00000000
        cmp     dword [rbp-0C8H], 291                   ; 2519 _ 81. BD, FFFFFF38, 00000123
        jne     ?_245                                   ; 2523 _ 0F 85, 00000514
        mov     rax, qword [rbp-0A0H]                   ; 2529 _ 48: 8B. 85, FFFFFF60
        mov     qword [rax], 2                          ; 2530 _ 48: C7. 00, 00000002
        mov     rax, qword [rbp-0A0H]                   ; 2537 _ 48: 8B. 85, FFFFFF60
        mov     dword [rax+38H], 16                     ; 253E _ C7. 40, 38, 00000010
        mov     rdx, qword [rel tokval]                 ; 2545 _ 48: 8B. 15, 00000000(rel)
        mov     rax, qword [rbp-0A0H]                   ; 254C _ 48: 8B. 85, FFFFFF60
        mov     qword [rax+28H], rdx                    ; 2553 _ 48: 89. 50, 28
        mov     rax, qword [rbp-0A0H]                   ; 2557 _ 48: 8B. 85, FFFFFF60
        mov     dword [rax+24H], -1                     ; 255E _ C7. 40, 24, FFFFFFFF
        mov     rax, qword [rbp-0A0H]                   ; 2565 _ 48: 8B. 85, FFFFFF60
        mov     dword [rax+30H], -1                     ; 256C _ C7. 40, 30, FFFFFFFF
        mov     rax, qword [rel ?_350]                  ; 2573 _ 48: 8B. 05, 00000000(rel)
        mov     edx, eax                                ; 257A _ 89. C2
        mov     rax, qword [rbp-0A0H]                   ; 257C _ 48: 8B. 85, FFFFFF60
        mov     dword [rax+3CH], edx                    ; 2583 _ 89. 50, 3C
        mov     rax, qword [rbp-0F0H]                   ; 2586 _ 48: 8B. 85, FFFFFF10
        mov     edx, dword [rax+94H]                    ; 258D _ 8B. 90, 00000094
        mov     rax, qword [rbp-0A0H]                   ; 2593 _ 48: 8B. 85, FFFFFF60
        mov     esi, edx                                ; 259A _ 89. D6
        mov     rdi, rax                                ; 259C _ 48: 89. C7
        call    set_imm_flags                           ; 259F _ E8, FFFFF415
        lea     rax, [rel tokval]                       ; 25A4 _ 48: 8D. 05, 00000000(rel)
        mov     rsi, rax                                ; 25AB _ 48: 89. C6
        mov     edi, 0                                  ; 25AE _ BF, 00000000
        call    stdscan                                 ; 25B3 _ E8, 00000000(PLT r)
        mov     dword [rbp-0C8H], eax                   ; 25B8 _ 89. 85, FFFFFF38
        cmp     dword [rbp-0C8H], 44                    ; 25BE _ 83. BD, FFFFFF38, 2C
        je      ?_328                                   ; 25C5 _ 0F 84, 00001505
        lea     rax, [rel tokval]                       ; 25CB _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 25D2 _ 48: 89. C7
        call    stdscan_pushback                        ; 25D5 _ E8, 00000000(PLT r)
        jmp     ?_328                                   ; 25DA _ E9, 000014F1

?_220:  mov     rax, qword [rel tokval]                 ; 25DF _ 48: 8B. 05, 00000000(rel)
        cmp     rax, 390                                ; 25E6 _ 48: 3D, 00000186
        je      ?_237                                   ; 25EC _ 0F 84, 00000310
        cmp     rax, 390                                ; 25F2 _ 48: 3D, 00000186
        jg      ?_243                                   ; 25F8 _ 0F 8F, 00000411
        cmp     rax, 389                                ; 25FE _ 48: 3D, 00000185
        je      ?_238                                   ; 2604 _ 0F 84, 00000318
        cmp     rax, 389                                ; 260A _ 48: 3D, 00000185
        jg      ?_243                                   ; 2610 _ 0F 8F, 000003F9
        cmp     rax, 388                                ; 2616 _ 48: 3D, 00000184
        je      ?_241                                   ; 261C _ 0F 84, 00000388
        cmp     rax, 388                                ; 2622 _ 48: 3D, 00000184
        jg      ?_243                                   ; 2628 _ 0F 8F, 000003E1
        cmp     rax, 385                                ; 262E _ 48: 3D, 00000181
        je      ?_240                                   ; 2634 _ 0F 84, 0000032E
        cmp     rax, 385                                ; 263A _ 48: 3D, 00000181
        jg      ?_243                                   ; 2640 _ 0F 8F, 000003C9
        cmp     rax, 384                                ; 2646 _ 48: 3D, 00000180
        je      ?_239                                   ; 264C _ 0F 84, 000002F0
        cmp     rax, 384                                ; 2652 _ 48: 3D, 00000180
        jg      ?_243                                   ; 2658 _ 0F 8F, 000003B1
        cmp     rax, 383                                ; 265E _ 48: 3D, 0000017F
        je      ?_242                                   ; 2664 _ 0F 84, 00000382
        cmp     rax, 383                                ; 266A _ 48: 3D, 0000017F
        jg      ?_243                                   ; 2670 _ 0F 8F, 00000399
        cmp     rax, 382                                ; 2676 _ 48: 3D, 0000017E
        je      ?_235                                   ; 267C _ 0F 84, 00000247
        cmp     rax, 382                                ; 2682 _ 48: 3D, 0000017E
        jg      ?_243                                   ; 2688 _ 0F 8F, 00000381
        cmp     rax, 381                                ; 268E _ 48: 3D, 0000017D
        je      ?_233                                   ; 2694 _ 0F 84, 000001F6
        cmp     rax, 381                                ; 269A _ 48: 3D, 0000017D
        jg      ?_243                                   ; 26A0 _ 0F 8F, 00000369
        cmp     rax, 380                                ; 26A6 _ 48: 3D, 0000017C
        je      ?_231                                   ; 26AC _ 0F 84, 000001A5
        cmp     rax, 380                                ; 26B2 _ 48: 3D, 0000017C
        jg      ?_243                                   ; 26B8 _ 0F 8F, 00000351
        cmp     rax, 379                                ; 26BE _ 48: 3D, 0000017B
        je      ?_229                                   ; 26C4 _ 0F 84, 00000154
        cmp     rax, 379                                ; 26CA _ 48: 3D, 0000017B
        jg      ?_243                                   ; 26D0 _ 0F 8F, 00000339
        cmp     rax, 378                                ; 26D6 _ 48: 3D, 0000017A
        je      ?_227                                   ; 26DC _ 0F 84, 00000103
        cmp     rax, 378                                ; 26E2 _ 48: 3D, 0000017A
        jg      ?_243                                   ; 26E8 _ 0F 8F, 00000321
        cmp     rax, 377                                ; 26EE _ 48: 3D, 00000179
        jg      ?_243                                   ; 26F4 _ 0F 8F, 00000315
        cmp     rax, 376                                ; 26FA _ 48: 3D, 00000178
        jge     ?_225                                   ; 2700 _ 0F 8D, 000000A6
        cmp     rax, 374                                ; 2706 _ 48: 3D, 00000176
        jz      ?_221                                   ; 270C _ 74, 0D
        cmp     rax, 375                                ; 270E _ 48: 3D, 00000177
        jz      ?_223                                   ; 2714 _ 74, 5D
        jmp     ?_243                                   ; 2716 _ E9, 000002F4

?_221:  cmp     dword [rbp-0C0H], 0                     ; 271B _ 83. BD, FFFFFF40, 00
        jnz     ?_222                                   ; 2722 _ 75, 40
        mov     rax, qword [rbp-0F0H]                   ; 2724 _ 48: 8B. 85, FFFFFF10
        mov     eax, dword [rax+94H]                    ; 272B _ 8B. 80, 00000094
        or      eax, 03H                                ; 2731 _ 83. C8, 03
        mov     edx, eax                                ; 2734 _ 89. C2
        mov     rax, qword [rbp-0F0H]                   ; 2736 _ 48: 8B. 85, FFFFFF10
        mov     dword [rax+94H], edx                    ; 273D _ 89. 90, 00000094
        mov     rax, qword [rbp-0A0H]                   ; 2743 _ 48: 8B. 85, FFFFFF60
        mov     rax, qword [rax]                        ; 274A _ 48: 8B. 00
        mov     rdx, qword 100000000H                   ; 274D _ 48: BA, 0000000100000000
        or      rdx, rax                                ; 2757 _ 48: 09. C2
        mov     rax, qword [rbp-0A0H]                   ; 275A _ 48: 8B. 85, FFFFFF60
        mov     qword [rax], rdx                        ; 2761 _ 48: 89. 10
?_222:  mov     dword [rbp-0C0H], 1                     ; 2764 _ C7. 85, FFFFFF40, 00000001
        jmp     ?_244                                   ; 276E _ E9, 000002B0

?_223:  cmp     dword [rbp-0C0H], 0                     ; 2773 _ 83. BD, FFFFFF40, 00
        jnz     ?_224                                   ; 277A _ 75, 21
        mov     rax, qword [rbp-0A0H]                   ; 277C _ 48: 8B. 85, FFFFFF60
        mov     rax, qword [rax]                        ; 2783 _ 48: 8B. 00
        mov     rdx, qword 200000000H                   ; 2786 _ 48: BA, 0000000200000000
        or      rdx, rax                                ; 2790 _ 48: 09. C2
        mov     rax, qword [rbp-0A0H]                   ; 2793 _ 48: 8B. 85, FFFFFF60
        mov     qword [rax], rdx                        ; 279A _ 48: 89. 10
?_224:  mov     dword [rbp-0C0H], 1                     ; 279D _ C7. 85, FFFFFF40, 00000001
        jmp     ?_244                                   ; 27A7 _ E9, 00000277

?_225:  cmp     dword [rbp-0C0H], 0                     ; 27AC _ 83. BD, FFFFFF40, 00
        jnz     ?_226                                   ; 27B3 _ 75, 21
        mov     rax, qword [rbp-0A0H]                   ; 27B5 _ 48: 8B. 85, FFFFFF60
        mov     rax, qword [rax]                        ; 27BC _ 48: 8B. 00
        mov     rdx, qword 400000000H                   ; 27BF _ 48: BA, 0000000400000000
        or      rdx, rax                                ; 27C9 _ 48: 09. C2
        mov     rax, qword [rbp-0A0H]                   ; 27CC _ 48: 8B. 85, FFFFFF60
        mov     qword [rax], rdx                        ; 27D3 _ 48: 89. 10
?_226:  mov     dword [rbp-0C0H], 1                     ; 27D6 _ C7. 85, FFFFFF40, 00000001
        jmp     ?_244                                   ; 27E0 _ E9, 0000023E

?_227:  cmp     dword [rbp-0C0H], 0                     ; 27E5 _ 83. BD, FFFFFF40, 00
        jnz     ?_228                                   ; 27EC _ 75, 21
        mov     rax, qword [rbp-0A0H]                   ; 27EE _ 48: 8B. 85, FFFFFF60
        mov     rax, qword [rax]                        ; 27F5 _ 48: 8B. 00
        mov     rdx, qword 800000000H                   ; 27F8 _ 48: BA, 0000000800000000
        or      rdx, rax                                ; 2802 _ 48: 09. C2
        mov     rax, qword [rbp-0A0H]                   ; 2805 _ 48: 8B. 85, FFFFFF60
        mov     qword [rax], rdx                        ; 280C _ 48: 89. 10
?_228:  mov     dword [rbp-0C0H], 1                     ; 280F _ C7. 85, FFFFFF40, 00000001
        jmp     ?_244                                   ; 2819 _ E9, 00000205

?_229:  cmp     dword [rbp-0C0H], 0                     ; 281E _ 83. BD, FFFFFF40, 00
        jnz     ?_230                                   ; 2825 _ 75, 21
        mov     rax, qword [rbp-0A0H]                   ; 2827 _ 48: 8B. 85, FFFFFF60
        mov     rax, qword [rax]                        ; 282E _ 48: 8B. 00
        mov     rdx, qword 1000000000H                  ; 2831 _ 48: BA, 0000001000000000
        or      rdx, rax                                ; 283B _ 48: 09. C2
        mov     rax, qword [rbp-0A0H]                   ; 283E _ 48: 8B. 85, FFFFFF60
        mov     qword [rax], rdx                        ; 2845 _ 48: 89. 10
?_230:  mov     dword [rbp-0C0H], 1                     ; 2848 _ C7. 85, FFFFFF40, 00000001
        jmp     ?_244                                   ; 2852 _ E9, 000001CC

?_231:  cmp     dword [rbp-0C0H], 0                     ; 2857 _ 83. BD, FFFFFF40, 00
        jnz     ?_232                                   ; 285E _ 75, 21
        mov     rax, qword [rbp-0A0H]                   ; 2860 _ 48: 8B. 85, FFFFFF60
        mov     rax, qword [rax]                        ; 2867 _ 48: 8B. 00
        mov     rdx, qword 2000000000H                  ; 286A _ 48: BA, 0000002000000000
        or      rdx, rax                                ; 2874 _ 48: 09. C2
        mov     rax, qword [rbp-0A0H]                   ; 2877 _ 48: 8B. 85, FFFFFF60
        mov     qword [rax], rdx                        ; 287E _ 48: 89. 10
?_232:  mov     dword [rbp-0C0H], 1                     ; 2881 _ C7. 85, FFFFFF40, 00000001
        jmp     ?_244                                   ; 288B _ E9, 00000193

?_233:  cmp     dword [rbp-0C0H], 0                     ; 2890 _ 83. BD, FFFFFF40, 00
        jnz     ?_234                                   ; 2897 _ 75, 21
        mov     rax, qword [rbp-0A0H]                   ; 2899 _ 48: 8B. 85, FFFFFF60
        mov     rax, qword [rax]                        ; 28A0 _ 48: 8B. 00
        mov     rdx, qword 4000000000H                  ; 28A3 _ 48: BA, 0000004000000000
        or      rdx, rax                                ; 28AD _ 48: 09. C2
        mov     rax, qword [rbp-0A0H]                   ; 28B0 _ 48: 8B. 85, FFFFFF60
        mov     qword [rax], rdx                        ; 28B7 _ 48: 89. 10
?_234:  mov     dword [rbp-0C0H], 1                     ; 28BA _ C7. 85, FFFFFF40, 00000001
        jmp     ?_244                                   ; 28C4 _ E9, 0000015A

?_235:  cmp     dword [rbp-0C0H], 0                     ; 28C9 _ 83. BD, FFFFFF40, 00
        jnz     ?_236                                   ; 28D0 _ 75, 21
        mov     rax, qword [rbp-0A0H]                   ; 28D2 _ 48: 8B. 85, FFFFFF60
        mov     rax, qword [rax]                        ; 28D9 _ 48: 8B. 00
        mov     rdx, qword 8000000000H                  ; 28DC _ 48: BA, 0000008000000000
        or      rdx, rax                                ; 28E6 _ 48: 09. C2
        mov     rax, qword [rbp-0A0H]                   ; 28E9 _ 48: 8B. 85, FFFFFF60
        mov     qword [rax], rdx                        ; 28F0 _ 48: 89. 10
?_236:  mov     dword [rbp-0C0H], 1                     ; 28F3 _ C7. 85, FFFFFF40, 00000001
        jmp     ?_244                                   ; 28FD _ E9, 00000121

?_237:  mov     rax, qword [rbp-0A0H]                   ; 2902 _ 48: 8B. 85, FFFFFF60
        mov     rax, qword [rax]                        ; 2909 _ 48: 8B. 00
        or      rax, 10H                                ; 290C _ 48: 83. C8, 10
        mov     rdx, rax                                ; 2910 _ 48: 89. C2
        mov     rax, qword [rbp-0A0H]                   ; 2913 _ 48: 8B. 85, FFFFFF60
        mov     qword [rax], rdx                        ; 291A _ 48: 89. 10
        jmp     ?_244                                   ; 291D _ E9, 00000101

?_238:  mov     rax, qword [rbp-0A0H]                   ; 2922 _ 48: 8B. 85, FFFFFF60
        mov     rax, qword [rax]                        ; 2929 _ 48: 8B. 00
        or      rax, 40H                                ; 292C _ 48: 83. C8, 40
        mov     rdx, rax                                ; 2930 _ 48: 89. C2
        mov     rax, qword [rbp-0A0H]                   ; 2933 _ 48: 8B. 85, FFFFFF60
        mov     qword [rax], rdx                        ; 293A _ 48: 89. 10
        jmp     ?_244                                   ; 293D _ E9, 000000E1

?_239:  mov     rax, qword [rbp-0A0H]                   ; 2942 _ 48: 8B. 85, FFFFFF60
        mov     rax, qword [rax]                        ; 2949 _ 48: 8B. 00
        mov     rdx, qword 10000000000H                 ; 294C _ 48: BA, 0000010000000000
        or      rdx, rax                                ; 2956 _ 48: 09. C2
        mov     rax, qword [rbp-0A0H]                   ; 2959 _ 48: 8B. 85, FFFFFF60
        mov     qword [rax], rdx                        ; 2960 _ 48: 89. 10
        jmp     ?_244                                   ; 2963 _ E9, 000000BB

?_240:  mov     rax, qword [rbp-0F0H]                   ; 2968 _ 48: 8B. 85, FFFFFF10
        mov     eax, dword [rax+94H]                    ; 296F _ 8B. 80, 00000094
        or      eax, 03H                                ; 2975 _ 83. C8, 03
        mov     edx, eax                                ; 2978 _ 89. C2
        mov     rax, qword [rbp-0F0H]                   ; 297A _ 48: 8B. 85, FFFFFF10
        mov     dword [rax+94H], edx                    ; 2981 _ 89. 90, 00000094
        mov     rax, qword [rbp-0A0H]                   ; 2987 _ 48: 8B. 85, FFFFFF60
        mov     rax, qword [rax]                        ; 298E _ 48: 8B. 00
        mov     rdx, qword 20000000000H                 ; 2991 _ 48: BA, 0000020000000000
        or      rdx, rax                                ; 299B _ 48: 09. C2
        mov     rax, qword [rbp-0A0H]                   ; 299E _ 48: 8B. 85, FFFFFF60
        mov     qword [rax], rdx                        ; 29A5 _ 48: 89. 10
        jmp     ?_244                                   ; 29A8 _ EB, 79

?_241:  mov     rax, qword [rbp-0F0H]                   ; 29AA _ 48: 8B. 85, FFFFFF10
        mov     eax, dword [rax+94H]                    ; 29B1 _ 8B. 80, 00000094
        or      eax, 03H                                ; 29B7 _ 83. C8, 03
        mov     edx, eax                                ; 29BA _ 89. C2
        mov     rax, qword [rbp-0F0H]                   ; 29BC _ 48: 8B. 85, FFFFFF10
        mov     dword [rax+94H], edx                    ; 29C3 _ 89. 90, 00000094
        mov     rax, qword [rbp-0A0H]                   ; 29C9 _ 48: 8B. 85, FFFFFF60
        mov     rax, qword [rax]                        ; 29D0 _ 48: 8B. 00
        mov     rdx, qword 40000000000H                 ; 29D3 _ 48: BA, 0000040000000000
        or      rdx, rax                                ; 29DD _ 48: 09. C2
        mov     rax, qword [rbp-0A0H]                   ; 29E0 _ 48: 8B. 85, FFFFFF60
        mov     qword [rax], rdx                        ; 29E7 _ 48: 89. 10
        jmp     ?_244                                   ; 29EA _ EB, 37

?_242:  mov     rax, qword [rbp-0A0H]                   ; 29EC _ 48: 8B. 85, FFFFFF60
        mov     rax, qword [rax]                        ; 29F3 _ 48: 8B. 00
        mov     rdx, qword 80000000000H                 ; 29F6 _ 48: BA, 0000080000000000
        or      rdx, rax                                ; 2A00 _ 48: 09. C2
        mov     rax, qword [rbp-0A0H]                   ; 2A03 _ 48: 8B. 85, FFFFFF60
        mov     qword [rax], rdx                        ; 2A0A _ 48: 89. 10
        jmp     ?_244                                   ; 2A0D _ EB, 14

?_243:  lea     rax, [rel ?_359]                        ; 2A0F _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 2A16 _ 48: 89. C7
        mov     eax, 0                                  ; 2A19 _ B8, 00000000
        call    nasm_nonfatal                           ; 2A1E _ E8, 00000000(PLT r)
?_244:  lea     rax, [rel tokval]                       ; 2A23 _ 48: 8D. 05, 00000000(rel)
        mov     rsi, rax                                ; 2A2A _ 48: 89. C6
        mov     edi, 0                                  ; 2A2D _ BF, 00000000
        call    stdscan                                 ; 2A32 _ E8, 00000000(PLT r)
        mov     dword [rbp-0C8H], eax                   ; 2A37 _ 89. 85, FFFFFF38
?_245:  cmp     dword [rbp-0C8H], 289                   ; 2A3D _ 81. BD, FFFFFF38, 00000121
        je      ?_220                                   ; 2A47 _ 0F 84, FFFFFB92
        cmp     dword [rbp-0C8H], 288                   ; 2A4D _ 81. BD, FFFFFF38, 00000120
        je      ?_220                                   ; 2A57 _ 0F 84, FFFFFB82
        cmp     dword [rbp-0C8H], 91                    ; 2A5D _ 83. BD, FFFFFF38, 5B
        jz      ?_246                                   ; 2A64 _ 74, 15
        cmp     dword [rbp-0C8H], 285                   ; 2A66 _ 81. BD, FFFFFF38, 0000011D
        jz      ?_246                                   ; 2A70 _ 74, 09
        cmp     dword [rbp-0C8H], 38                    ; 2A72 _ 83. BD, FFFFFF38, 26
        jnz     ?_247                                   ; 2A79 _ 75, 36
?_246:  mov     byte [rbp-0D6H], 1                      ; 2A7B _ C6. 85, FFFFFF2A, 01
        cmp     dword [rbp-0C8H], 91                    ; 2A82 _ 83. BD, FFFFFF38, 5B
        sete    al                                      ; 2A89 _ 0F 94. C0
        movzx   eax, al                                 ; 2A8C _ 0F B6. C0
        add     dword [rbp-0C4H], eax                   ; 2A8F _ 01. 85, FFFFFF3C
        lea     rax, [rel tokval]                       ; 2A95 _ 48: 8D. 05, 00000000(rel)
        mov     rsi, rax                                ; 2A9C _ 48: 89. C6
        mov     edi, 0                                  ; 2A9F _ BF, 00000000
        call    stdscan                                 ; 2AA4 _ E8, 00000000(PLT r)
        mov     dword [rbp-0C8H], eax                   ; 2AA9 _ 89. 85, FFFFFF38
        jmp     ?_248                                   ; 2AAF _ EB, 01

?_247:  nop                                             ; 2AB1 _ 90
?_248:  cmp     byte [rbp-0D6H], 0                      ; 2AB2 _ 80. BD, FFFFFF2A, 00
        je      ?_258                                   ; 2AB9 _ 0F 84, 00000160
        mov     byte [rbp-0D4H], 0                      ; 2ABF _ C6. 85, FFFFFF2C, 00
        mov     byte [rbp-0D3H], 0                      ; 2AC6 _ C6. 85, FFFFFF2D, 00
        jmp     ?_257                                   ; 2ACD _ E9, 0000013B

?_249:  cmp     dword [rbp-0C8H], 290                   ; 2AD2 _ 81. BD, FFFFFF38, 00000122
        jg      ?_255                                   ; 2ADC _ 0F 8F, 000000EE
        cmp     dword [rbp-0C8H], 288                   ; 2AE2 _ 81. BD, FFFFFF38, 00000120
        jge     ?_250                                   ; 2AEC _ 7D, 37
        cmp     dword [rbp-0C8H], 286                   ; 2AEE _ 81. BD, FFFFFF38, 0000011E
        je      ?_253                                   ; 2AF8 _ 0F 84, 0000008B
        cmp     dword [rbp-0C8H], 286                   ; 2AFE _ 81. BD, FFFFFF38, 0000011E
        jg      ?_255                                   ; 2B08 _ 0F 8F, 000000C2
        cmp     dword [rbp-0C8H], 44                    ; 2B0E _ 83. BD, FFFFFF38, 2C
        jz      ?_252                                   ; 2B15 _ 74, 38
        cmp     dword [rbp-0C8H], 91                    ; 2B17 _ 83. BD, FFFFFF38, 5B
        jz      ?_251                                   ; 2B1E _ 74, 23
        jmp     ?_255                                   ; 2B20 _ E9, 000000AB

?_250:  mov     rdx, qword [rbp-0A0H]                   ; 2B25 _ 48: 8B. 95, FFFFFF60
        mov     rax, qword [rbp-0F0H]                   ; 2B2C _ 48: 8B. 85, FFFFFF10
        mov     rsi, rdx                                ; 2B33 _ 48: 89. D6
        mov     rdi, rax                                ; 2B36 _ 48: 89. C7
        call    process_size_override                   ; 2B39 _ E8, FFFFD70E
        jmp     ?_256                                   ; 2B3E _ E9, 000000A2

?_251:  add     dword [rbp-0C4H], 1                     ; 2B43 _ 83. 85, FFFFFF3C, 01
        jmp     ?_256                                   ; 2B4A _ E9, 00000096

?_252:  lea     rax, [rel tokval]                       ; 2B4F _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 2B56 _ 48: 89. C7
        call    stdscan_pushback                        ; 2B59 _ E8, 00000000(PLT r)
        mov     dword [rel ?_354], 269                  ; 2B5E _ C7. 05, 00000000(rel), 0000010D
        mov     qword [rel tokval], 0                   ; 2B68 _ 48: C7. 05, 00000000(rel), 00000000
        mov     byte [rbp-0D3H], 1                      ; 2B73 _ C6. 85, FFFFFF2D, 01
        movzx   eax, byte [rbp-0D3H]                    ; 2B7A _ 0F B6. 85, FFFFFF2D
        mov     byte [rbp-0D4H], al                     ; 2B81 _ 88. 85, FFFFFF2C
        jmp     ?_256                                   ; 2B87 _ EB, 5C

?_253:  lea     rax, [rel tokval]                       ; 2B89 _ 48: 8D. 05, 00000000(rel)
        mov     rsi, rax                                ; 2B90 _ 48: 89. C6
        mov     edi, 0                                  ; 2B93 _ BF, 00000000
        call    stdscan                                 ; 2B98 _ E8, 00000000(PLT r)
        mov     dword [rbp-0C8H], eax                   ; 2B9D _ 89. 85, FFFFFF38
        cmp     dword [rbp-0C8H], 58                    ; 2BA3 _ 83. BD, FFFFFF38, 3A
        jz      ?_254                                   ; 2BAA _ 74, 1B
        lea     rax, [rel ?_397]                        ; 2BAC _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 2BB3 _ 48: 89. C7
        mov     eax, 0                                  ; 2BB6 _ B8, 00000000
        call    nasm_nonfatal                           ; 2BBB _ E8, 00000000(PLT r)
        mov     byte [rbp-0D3H], 1                      ; 2BC0 _ C6. 85, FFFFFF2D, 01
?_254:  mov     byte [rbp-0D4H], 1                      ; 2BC7 _ C6. 85, FFFFFF2C, 01
        jmp     ?_256                                   ; 2BCE _ EB, 15

?_255:  mov     byte [rbp-0D3H], 1                      ; 2BD0 _ C6. 85, FFFFFF2D, 01
        movzx   eax, byte [rbp-0D3H]                    ; 2BD7 _ 0F B6. 85, FFFFFF2D
        mov     byte [rbp-0D4H], al                     ; 2BDE _ 88. 85, FFFFFF2C
        nop                                             ; 2BE4 _ 90
?_256:  movzx   eax, byte [rbp-0D3H]                    ; 2BE5 _ 0F B6. 85, FFFFFF2D
        xor     eax, 01H                                ; 2BEC _ 83. F0, 01
        test    al, al                                  ; 2BEF _ 84. C0
        jz      ?_257                                   ; 2BF1 _ 74, 1A
        lea     rax, [rel tokval]                       ; 2BF3 _ 48: 8D. 05, 00000000(rel)
        mov     rsi, rax                                ; 2BFA _ 48: 89. C6
        mov     edi, 0                                  ; 2BFD _ BF, 00000000
        call    stdscan                                 ; 2C02 _ E8, 00000000(PLT r)
        mov     dword [rbp-0C8H], eax                   ; 2C07 _ 89. 85, FFFFFF38
?_257:  movzx   eax, byte [rbp-0D4H]                    ; 2C0D _ 0F B6. 85, FFFFFF2C
        xor     eax, 01H                                ; 2C14 _ 83. F0, 01
        test    al, al                                  ; 2C17 _ 84. C0
        jne     ?_249                                   ; 2C19 _ 0F 85, FFFFFEB3
?_258:  mov     rax, qword [rbp-0A0H]                   ; 2C1F _ 48: 8B. 85, FFFFFF60
        lea     rdx, [rax+38H]                          ; 2C26 _ 48: 8D. 50, 38
        lea     rsi, [rbp-60H]                          ; 2C2A _ 48: 8D. 75, A0
        movzx   ecx, byte [rbp-0D1H]                    ; 2C2E _ 0F B6. 8D, FFFFFF2F
        lea     rax, [rel tokval]                       ; 2C35 _ 48: 8D. 05, 00000000(rel)
; Note: Unusual relocation type for this operand
        mov     rdi, qword [rel stdscan+$+??]           ; 2C3C _ 48: 8B. 3D, 00000000
        mov     r9, rsi                                 ; 2C43 _ 49: 89. F1
        mov     r8d, ecx                                ; 2C46 _ 41: 89. C8
        mov     rcx, rdx                                ; 2C49 _ 48: 89. D1
        mov     rdx, rax                                ; 2C4C _ 48: 89. C2
        mov     esi, 0                                  ; 2C4F _ BE, 00000000
        call    evaluate                                ; 2C54 _ E8, 00000000(PLT r)
        mov     qword [rbp-98H], rax                    ; 2C59 _ 48: 89. 85, FFFFFF68
        mov     eax, dword [rel ?_354]                  ; 2C60 _ 8B. 05, 00000000(rel)
        mov     dword [rbp-0C8H], eax                   ; 2C66 _ 89. 85, FFFFFF38
        cmp     qword [rbp-98H], 0                      ; 2C6C _ 48: 83. BD, FFFFFF68, 00
        je      ?_336                                   ; 2C74 _ 0F 84, 00000E92
        cmp     dword [rbp-0C8H], 91                    ; 2C7A _ 83. BD, FFFFFF38, 5B
        jnz     ?_259                                   ; 2C81 _ 75, 2E
        cmp     dword [rbp-0C4H], 0                     ; 2C83 _ 83. BD, FFFFFF3C, 00
        jnz     ?_259                                   ; 2C8A _ 75, 25
        mov     byte [rbp-0D6H], 1                      ; 2C8C _ C6. 85, FFFFFF2A, 01
        mov     rdx, qword [rbp-98H]                    ; 2C93 _ 48: 8B. 95, FFFFFF68
        mov     rax, qword [rbp-0A0H]                   ; 2C9A _ 48: 8B. 85, FFFFFF60
        mov     rsi, rdx                                ; 2CA1 _ 48: 89. D6
        mov     rdi, rax                                ; 2CA4 _ 48: 89. C7
        call    parse_mref                              ; 2CA7 _ E8, FFFFDAE8
        jmp     ?_248                                   ; 2CAC _ E9, FFFFFE01

?_259:  cmp     dword [rbp-0C8H], 58                    ; 2CB1 _ 83. BD, FFFFFF38, 3A
        jne     ?_270                                   ; 2CB8 _ 0F 85, 000001BB
        mov     rax, qword [rbp-98H]                    ; 2CBE _ 48: 8B. 85, FFFFFF68
        mov     eax, dword [rax]                        ; 2CC5 _ 8B. 00
        mov     edi, eax                                ; 2CC7 _ 89. C7
        call    is_register                             ; 2CC9 _ E8, FFFFD351
        test    al, al                                  ; 2CCE _ 84. C0
        jz      ?_260                                   ; 2CD0 _ 74, 29
        mov     rax, qword [rbp-98H]                    ; 2CD2 _ 48: 8B. 85, FFFFFF68
        mov     rax, qword [rax+8H]                     ; 2CD9 _ 48: 8B. 40, 08
        cmp     rax, 1                                  ; 2CDD _ 48: 83. F8, 01
        jnz     ?_260                                   ; 2CE1 _ 75, 18
        mov     rax, qword [rbp-98H]                    ; 2CE3 _ 48: 8B. 85, FFFFFF68
        add     rax, 16                                 ; 2CEA _ 48: 83. C0, 10
        mov     eax, dword [rax]                        ; 2CEE _ 8B. 00
        test    eax, eax                                ; 2CF0 _ 85. C0
        jnz     ?_260                                   ; 2CF2 _ 75, 07
        mov     eax, 1                                  ; 2CF4 _ B8, 00000001
        jmp     ?_261                                   ; 2CF9 _ EB, 05

?_260:  mov     eax, 0                                  ; 2CFB _ B8, 00000000
?_261:  mov     byte [rbp-0CFH], al                     ; 2D00 _ 88. 85, FFFFFF31
        and     byte [rbp-0CFH], 01H                    ; 2D06 _ 80. A5, FFFFFF31, 01
        movzx   eax, byte [rbp-0D6H]                    ; 2D0D _ 0F B6. 85, FFFFFF2A
        xor     eax, 01H                                ; 2D14 _ 83. F0, 01
        test    al, al                                  ; 2D17 _ 84. C0
        jz      ?_262                                   ; 2D19 _ 74, 31
        cmp     byte [rbp-0CFH], 0                      ; 2D1B _ 80. BD, FFFFFF31, 00
        jz      ?_262                                   ; 2D22 _ 74, 28
        mov     rax, qword [rbp-98H]                    ; 2D24 _ 48: 8B. 85, FFFFFF68
        mov     eax, dword [rax]                        ; 2D2B _ 8B. 00
        mov     rdx, qword 210000201H                   ; 2D2D _ 48: BA, 0000000210000201
        mov     esi, eax                                ; 2D37 _ 89. C6
        mov     rdi, rdx                                ; 2D39 _ 48: 89. D7
        call    is_reg_class                            ; 2D3C _ E8, FFFFD305
        xor     eax, 01H                                ; 2D41 _ 83. F0, 01
        test    al, al                                  ; 2D44 _ 84. C0
        jne     ?_270                                   ; 2D46 _ 0F 85, 0000012D
?_262:  cmp     byte [rbp-0D6H], 0                      ; 2D4C _ 80. BD, FFFFFF2A, 00
        jnz     ?_263                                   ; 2D53 _ 75, 32
        cmp     byte [rbp-0CFH], 0                      ; 2D55 _ 80. BD, FFFFFF31, 00
        je      ?_270                                   ; 2D5C _ 0F 84, 00000117
        mov     rax, qword [rbp-98H]                    ; 2D62 _ 48: 8B. 85, FFFFFF68
        mov     eax, dword [rax]                        ; 2D69 _ 8B. 00
        mov     rdx, qword 210000201H                   ; 2D6B _ 48: BA, 0000000210000201
        mov     esi, eax                                ; 2D75 _ 89. C6
        mov     rdi, rdx                                ; 2D77 _ 48: 89. D7
        call    is_reg_class                            ; 2D7A _ E8, FFFFD2C7
        test    al, al                                  ; 2D7F _ 84. C0
        je      ?_270                                   ; 2D81 _ 0F 84, 000000F2
?_263:  mov     byte [rbp-0D6H], 1                      ; 2D87 _ C6. 85, FFFFFF2A, 01
        movzx   eax, byte [rbp-0CFH]                    ; 2D8E _ 0F B6. 85, FFFFFF31
        xor     eax, 01H                                ; 2D95 _ 83. F0, 01
        test    al, al                                  ; 2D98 _ 84. C0
        jnz     ?_264                                   ; 2D9A _ 75, 24
        mov     rax, qword [rbp-98H]                    ; 2D9C _ 48: 8B. 85, FFFFFF68
        mov     eax, dword [rax]                        ; 2DA3 _ 8B. 00
        mov     rdx, qword 210000201H                   ; 2DA5 _ 48: BA, 0000000210000201
        mov     esi, eax                                ; 2DAF _ 89. C6
        mov     rdi, rdx                                ; 2DB1 _ 48: 89. D7
        call    is_reg_class                            ; 2DB4 _ E8, FFFFD28D
        xor     eax, 01H                                ; 2DB9 _ 83. F0, 01
        test    al, al                                  ; 2DBC _ 84. C0
        jz      ?_265                                   ; 2DBE _ 74, 19
?_264:  lea     rax, [rel ?_398]                        ; 2DC0 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 2DC7 _ 48: 89. C7
        mov     eax, 0                                  ; 2DCA _ B8, 00000000
        call    nasm_nonfatal                           ; 2DCF _ E8, 00000000(PLT r)
        jmp     ?_269                                   ; 2DD4 _ E9, 00000081

?_265:  mov     rax, qword [rbp-0F0H]                   ; 2DD9 _ 48: 8B. 85, FFFFFF10
        mov     eax, dword [rax+1CH]                    ; 2DE0 _ 8B. 40, 1C
        test    eax, eax                                ; 2DE3 _ 85. C0
        jz      ?_266                                   ; 2DE5 _ 74, 16
        lea     rax, [rel ?_399]                        ; 2DE7 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 2DEE _ 48: 89. C7
        mov     eax, 0                                  ; 2DF1 _ B8, 00000000
        call    nasm_nonfatal                           ; 2DF6 _ E8, 00000000(PLT r)
        jmp     ?_269                                   ; 2DFB _ EB, 5D

?_266:  mov     rax, qword [rbp-98H]                    ; 2DFD _ 48: 8B. 85, FFFFFF68
        mov     edx, dword [rax]                        ; 2E04 _ 8B. 10
        mov     rax, qword [rbp-0F0H]                   ; 2E06 _ 48: 8B. 85, FFFFFF10
        mov     dword [rax+1CH], edx                    ; 2E0D _ 89. 50, 1C
        mov     rax, qword [rbp-98H]                    ; 2E10 _ 48: 8B. 85, FFFFFF68
        mov     eax, dword [rax]                        ; 2E17 _ 8B. 00
        cmp     eax, 96                                 ; 2E19 _ 83. F8, 60
        jz      ?_267                                   ; 2E1C _ 74, 07
        cmp     eax, 97                                 ; 2E1E _ 83. F8, 61
        jz      ?_268                                   ; 2E21 _ 74, 1D
        jmp     ?_269                                   ; 2E23 _ EB, 35

?_267:  mov     rax, qword [rbp-0A0H]                   ; 2E25 _ 48: 8B. 85, FFFFFF60
        mov     eax, dword [rax+34H]                    ; 2E2C _ 8B. 40, 34
        or      ah, 01H                                 ; 2E2F _ 80. CC, 01
        mov     edx, eax                                ; 2E32 _ 89. C2
        mov     rax, qword [rbp-0A0H]                   ; 2E34 _ 48: 8B. 85, FFFFFF60
        mov     dword [rax+34H], edx                    ; 2E3B _ 89. 50, 34
        jmp     ?_269                                   ; 2E3E _ EB, 1A

?_268:  mov     rax, qword [rbp-0A0H]                   ; 2E40 _ 48: 8B. 85, FFFFFF60
        mov     eax, dword [rax+34H]                    ; 2E47 _ 8B. 40, 34
        or      ah, 02H                                 ; 2E4A _ 80. CC, 02
        mov     edx, eax                                ; 2E4D _ 89. C2
        mov     rax, qword [rbp-0A0H]                   ; 2E4F _ 48: 8B. 85, FFFFFF60
        mov     dword [rax+34H], edx                    ; 2E56 _ 89. 50, 34
        nop                                             ; 2E59 _ 90
?_269:  lea     rax, [rel tokval]                       ; 2E5A _ 48: 8D. 05, 00000000(rel)
        mov     rsi, rax                                ; 2E61 _ 48: 89. C6
        mov     edi, 0                                  ; 2E64 _ BF, 00000000
        call    stdscan                                 ; 2E69 _ E8, 00000000(PLT r)
        mov     dword [rbp-0C8H], eax                   ; 2E6E _ 89. 85, FFFFFF38
        jmp     ?_248                                   ; 2E74 _ E9, FFFFFC39

?_270:  mov     byte [rbp-0D5H], 0                      ; 2E79 _ C6. 85, FFFFFF2B, 00
        cmp     byte [rbp-0D6H], 0                      ; 2E80 _ 80. BD, FFFFFF2A, 00
        je      ?_281                                   ; 2E87 _ 0F 84, 00000203
        cmp     dword [rbp-0C4H], 0                     ; 2E8D _ 83. BD, FFFFFF3C, 00
        je      ?_281                                   ; 2E94 _ 0F 84, 000001F6
        cmp     dword [rbp-0C8H], 44                    ; 2E9A _ 83. BD, FFFFFF38, 2C
        jne     ?_281                                   ; 2EA1 _ 0F 85, 000001E9
        mov     rdx, qword [rbp-98H]                    ; 2EA7 _ 48: 8B. 95, FFFFFF68
        mov     rax, qword [rbp-0A0H]                   ; 2EAE _ 48: 8B. 85, FFFFFF60
        mov     rsi, rdx                                ; 2EB5 _ 48: 89. D6
        mov     rdi, rax                                ; 2EB8 _ 48: 89. C7
        call    parse_mref                              ; 2EBB _ E8, FFFFD8D4
        test    eax, eax                                ; 2EC0 _ 85. C0
        jne     ?_277                                   ; 2EC2 _ 0F 85, 000001B6
        lea     rax, [rel tokval]                       ; 2EC8 _ 48: 8D. 05, 00000000(rel)
        mov     rsi, rax                                ; 2ECF _ 48: 89. C6
        mov     edi, 0                                  ; 2ED2 _ BF, 00000000
        call    stdscan                                 ; 2ED7 _ E8, 00000000(PLT r)
        mov     dword [rbp-0C8H], eax                   ; 2EDC _ 89. 85, FFFFFF38
        mov     rax, qword [rbp-0A0H]                   ; 2EE2 _ 48: 8B. 85, FFFFFF60
        lea     rdx, [rax+38H]                          ; 2EE9 _ 48: 8D. 50, 38
        lea     rsi, [rbp-60H]                          ; 2EED _ 48: 8D. 75, A0
        movzx   ecx, byte [rbp-0D1H]                    ; 2EF1 _ 0F B6. 8D, FFFFFF2F
        lea     rax, [rel tokval]                       ; 2EF8 _ 48: 8D. 05, 00000000(rel)
; Note: Unusual relocation type for this operand
        mov     rdi, qword [rel stdscan+$+??]           ; 2EFF _ 48: 8B. 3D, 00000000
        mov     r9, rsi                                 ; 2F06 _ 49: 89. F1
        mov     r8d, ecx                                ; 2F09 _ 41: 89. C8
        mov     rcx, rdx                                ; 2F0C _ 48: 89. D1
        mov     rdx, rax                                ; 2F0F _ 48: 89. C2
        mov     esi, 0                                  ; 2F12 _ BE, 00000000
        call    evaluate                                ; 2F17 _ E8, 00000000(PLT r)
        mov     qword [rbp-98H], rax                    ; 2F1C _ 48: 89. 85, FFFFFF68
        mov     eax, dword [rel ?_354]                  ; 2F23 _ 8B. 05, 00000000(rel)
        mov     dword [rbp-0C8H], eax                   ; 2F29 _ 89. 85, FFFFFF38
        cmp     qword [rbp-98H], 0                      ; 2F2F _ 48: 83. BD, FFFFFF68, 00
        je      ?_278                                   ; 2F37 _ 0F 84, 00000147
        lea     rax, [rbp-50H]                          ; 2F3D _ 48: 8D. 45, B0
        mov     esi, 0                                  ; 2F41 _ BE, 00000000
        mov     rdi, rax                                ; 2F46 _ 48: 89. C7
        call    init_operand                            ; 2F49 _ E8, FFFFD7E6
        mov     rdx, qword [rbp-98H]                    ; 2F4E _ 48: 8B. 95, FFFFFF68
        lea     rax, [rbp-50H]                          ; 2F55 _ 48: 8D. 45, B0
        mov     rsi, rdx                                ; 2F59 _ 48: 89. D6
        mov     rdi, rax                                ; 2F5C _ 48: 89. C7
        call    parse_mref                              ; 2F5F _ E8, FFFFD830
        test    eax, eax                                ; 2F64 _ 85. C0
        jne     ?_279                                   ; 2F66 _ 0F 85, 0000011E
        mov     eax, dword [rbp-40H]                    ; 2F6C _ 8B. 45, C0
        cmp     eax, -1                                 ; 2F6F _ 83. F8, FF
        jz      ?_271                                   ; 2F72 _ 74, 1C
        mov     eax, dword [rbp-3CH]                    ; 2F74 _ 8B. 45, C4
        cmp     eax, -1                                 ; 2F77 _ 83. F8, FF
        jnz     ?_271                                   ; 2F7A _ 75, 14
        mov     eax, dword [rbp-40H]                    ; 2F7C _ 8B. 45, C0
        mov     dword [rbp-3CH], eax                    ; 2F7F _ 89. 45, C4
        mov     dword [rbp-38H], 1                      ; 2F82 _ C7. 45, C8, 00000001
        mov     dword [rbp-40H], -1                     ; 2F89 _ C7. 45, C0, FFFFFFFF
?_271:  mov     rax, qword [rbp-0A0H]                   ; 2F90 _ 48: 8B. 85, FFFFFF60
        mov     eax, dword [rax+14H]                    ; 2F97 _ 8B. 40, 14
        cmp     eax, -1                                 ; 2F9A _ 83. F8, FF
        jnz     ?_272                                   ; 2F9D _ 75, 21
        mov     eax, dword [rbp-40H]                    ; 2F9F _ 8B. 45, C0
        cmp     eax, -1                                 ; 2FA2 _ 83. F8, FF
        jnz     ?_272                                   ; 2FA5 _ 75, 19
        mov     rax, qword [rbp-28H]                    ; 2FA7 _ 48: 8B. 45, D8
        test    rax, rax                                ; 2FAB _ 48: 85. C0
        jnz     ?_272                                   ; 2FAE _ 75, 10
        mov     eax, dword [rbp-2CH]                    ; 2FB0 _ 8B. 45, D4
        cmp     eax, -1                                 ; 2FB3 _ 83. F8, FF
        jnz     ?_272                                   ; 2FB6 _ 75, 08
        mov     eax, dword [rbp-20H]                    ; 2FB8 _ 8B. 45, E0
        cmp     eax, -1                                 ; 2FBB _ 83. F8, FF
        jz      ?_273                                   ; 2FBE _ 74, 19
?_272:  lea     rax, [rel ?_400]                        ; 2FC0 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 2FC7 _ 48: 89. C7
        mov     eax, 0                                  ; 2FCA _ B8, 00000000
        call    nasm_nonfatal                           ; 2FCF _ E8, 00000000(PLT r)
        jmp     ?_280                                   ; 2FD4 _ E9, 000000B2

?_273:  mov     edx, dword [rbp-3CH]                    ; 2FD9 _ 8B. 55, C4
        mov     rax, qword [rbp-0A0H]                   ; 2FDC _ 48: 8B. 85, FFFFFF60
        mov     dword [rax+14H], edx                    ; 2FE3 _ 89. 50, 14
        mov     edx, dword [rbp-38H]                    ; 2FE6 _ 8B. 55, C8
        mov     rax, qword [rbp-0A0H]                   ; 2FE9 _ 48: 8B. 85, FFFFFF60
        mov     dword [rax+18H], edx                    ; 2FF0 _ 89. 50, 18
        mov     rax, qword [rbp-0A0H]                   ; 2FF3 _ 48: 8B. 85, FFFFFF60
        mov     eax, dword [rax+10H]                    ; 2FFA _ 8B. 40, 10
        cmp     eax, -1                                 ; 2FFD _ 83. F8, FF
        jz      ?_274                                   ; 3000 _ 74, 24
        mov     rax, qword [rbp-0A0H]                   ; 3002 _ 48: 8B. 85, FFFFFF60
        mov     edx, dword [rax+10H]                    ; 3009 _ 8B. 50, 10
        mov     rax, qword [rbp-0A0H]                   ; 300C _ 48: 8B. 85, FFFFFF60
        mov     dword [rax+1CH], edx                    ; 3013 _ 89. 50, 1C
        mov     rax, qword [rbp-0A0H]                   ; 3016 _ 48: 8B. 85, FFFFFF60
        mov     dword [rax+20H], 1                      ; 301D _ C7. 40, 20, 00000001
        jmp     ?_276                                   ; 3024 _ EB, 4F

?_274:  mov     rax, qword [rbp-0A0H]                   ; 3026 _ 48: 8B. 85, FFFFFF60
        mov     eax, dword [rax+14H]                    ; 302D _ 8B. 40, 14
        cmp     eax, -1                                 ; 3030 _ 83. F8, FF
        jz      ?_275                                   ; 3033 _ 74, 24
        mov     rax, qword [rbp-0A0H]                   ; 3035 _ 48: 8B. 85, FFFFFF60
        mov     edx, dword [rax+14H]                    ; 303C _ 8B. 50, 14
        mov     rax, qword [rbp-0A0H]                   ; 303F _ 48: 8B. 85, FFFFFF60
        mov     dword [rax+1CH], edx                    ; 3046 _ 89. 50, 1C
        mov     rax, qword [rbp-0A0H]                   ; 3049 _ 48: 8B. 85, FFFFFF60
        mov     dword [rax+20H], 2                      ; 3050 _ C7. 40, 20, 00000002
        jmp     ?_276                                   ; 3057 _ EB, 1C

?_275:  mov     rax, qword [rbp-0A0H]                   ; 3059 _ 48: 8B. 85, FFFFFF60
        mov     dword [rax+1CH], -1                     ; 3060 _ C7. 40, 1C, FFFFFFFF
        mov     rax, qword [rbp-0A0H]                   ; 3067 _ 48: 8B. 85, FFFFFF60
        mov     dword [rax+20H], 0                      ; 306E _ C7. 40, 20, 00000000
?_276:  mov     byte [rbp-0D5H], 1                      ; 3075 _ C6. 85, FFFFFF2B, 01
        jmp     ?_281                                   ; 307C _ EB, 12

?_277:  nop                                             ; 307E _ 90
        jmp     ?_338                                   ; 307F _ E9, 00000A8C

?_278:  nop                                             ; 3084 _ 90
        jmp     ?_338                                   ; 3085 _ E9, 00000A86

?_279:  nop                                             ; 308A _ 90
?_280:  jmp     ?_338                                   ; 308B _ E9, 00000A80

?_281:  mov     byte [rbp-0D8H], 0                      ; 3090 _ C6. 85, FFFFFF28, 00
        cmp     byte [rbp-0D6H], 0                      ; 3097 _ 80. BD, FFFFFF2A, 00
        je      ?_288                                   ; 309E _ 0F 84, 00000139
        cmp     dword [rbp-0C4H], 1                     ; 30A4 _ 83. BD, FFFFFF3C, 01
        jnz     ?_283                                   ; 30AB _ 75, 49
        cmp     dword [rbp-0C8H], 93                    ; 30AD _ 83. BD, FFFFFF38, 5D
        jnz     ?_282                                   ; 30B4 _ 75, 23
        sub     dword [rbp-0C4H], 1                     ; 30B6 _ 83. AD, FFFFFF3C, 01
        lea     rax, [rel tokval]                       ; 30BD _ 48: 8D. 05, 00000000(rel)
        mov     rsi, rax                                ; 30C4 _ 48: 89. C6
        mov     edi, 0                                  ; 30C7 _ BF, 00000000
        call    stdscan                                 ; 30CC _ E8, 00000000(PLT r)
        mov     dword [rbp-0C8H], eax                   ; 30D1 _ 89. 85, FFFFFF38
        jmp     ?_285                                   ; 30D7 _ EB, 70

?_282:  lea     rax, [rel ?_401]                        ; 30D9 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 30E0 _ 48: 89. C7
        mov     eax, 0                                  ; 30E3 _ B8, 00000000
        call    nasm_nonfatal                           ; 30E8 _ E8, 00000000(PLT r)
        mov     byte [rbp-0D8H], 1                      ; 30ED _ C6. 85, FFFFFF28, 01
        jmp     ?_285                                   ; 30F4 _ EB, 53

?_283:  cmp     dword [rbp-0C4H], 0                     ; 30F6 _ 83. BD, FFFFFF3C, 00
        jz      ?_285                                   ; 30FD _ 74, 4A
        cmp     dword [rbp-0C4H], 0                     ; 30FF _ 83. BD, FFFFFF3C, 00
        jle     ?_284                                   ; 3106 _ 7E, 1D
        lea     rax, [rel ?_402]                        ; 3108 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 310F _ 48: 89. C7
        mov     eax, 0                                  ; 3112 _ B8, 00000000
        call    nasm_nonfatal                           ; 3117 _ E8, 00000000(PLT r)
        mov     byte [rbp-0D8H], 1                      ; 311C _ C6. 85, FFFFFF28, 01
        jmp     ?_285                                   ; 3123 _ EB, 24

?_284:  cmp     dword [rbp-0C4H], 0                     ; 3125 _ 83. BD, FFFFFF3C, 00
        jns     ?_285                                   ; 312C _ 79, 1B
        lea     rax, [rel ?_403]                        ; 312E _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 3135 _ 48: 89. C7
        mov     eax, 0                                  ; 3138 _ B8, 00000000
        call    nasm_nonfatal                           ; 313D _ E8, 00000000(PLT r)
        mov     byte [rbp-0D8H], 1                      ; 3142 _ C6. 85, FFFFFF28, 01
?_285:  cmp     dword [rbp-0C8H], 284                   ; 3149 _ 81. BD, FFFFFF38, 0000011C
        jz      ?_286                                   ; 3153 _ 74, 0C
        cmp     dword [rbp-0C8H], 287                   ; 3155 _ 81. BD, FFFFFF38, 0000011F
        jnz     ?_287                                   ; 315F _ 75, 21
?_286:  lea     rax, [rbp-0CEH]                         ; 3161 _ 48: 8D. 85, FFFFFF32
        mov     rdi, rax                                ; 3168 _ 48: 89. C7
        call    parse_decorators                        ; 316B _ E8, FFFFD425
        mov     byte [rbp-0D8H], al                     ; 3170 _ 88. 85, FFFFFF28
        mov     eax, dword [rel ?_354]                  ; 3176 _ 8B. 05, 00000000(rel)
        mov     dword [rbp-0C8H], eax                   ; 317C _ 89. 85, FFFFFF38
?_287:  movzx   eax, byte [rbp-0D8H]                    ; 3182 _ 0F B6. 85, FFFFFF28
        xor     eax, 01H                                ; 3189 _ 83. F0, 01
        test    al, al                                  ; 318C _ 84. C0
        je      ?_292                                   ; 318E _ 0F 84, 000000EC
        cmp     dword [rbp-0C8H], 0                     ; 3194 _ 83. BD, FFFFFF38, 00
        je      ?_292                                   ; 319B _ 0F 84, 000000DF
        cmp     dword [rbp-0C8H], 44                    ; 31A1 _ 83. BD, FFFFFF38, 2C
        je      ?_292                                   ; 31A8 _ 0F 84, 000000D2
        mov     rdx, qword [rel ?_352]                  ; 31AE _ 48: 8B. 15, 00000000(rel)
        mov     eax, dword [rel ?_353]                  ; 31B5 _ 8B. 05, 00000000(rel)
        lea     rcx, [rel ?_404]                        ; 31BB _ 48: 8D. 0D, 00000000(rel)
        mov     esi, eax                                ; 31C2 _ 89. C6
        mov     rdi, rcx                                ; 31C4 _ 48: 89. CF
        mov     eax, 0                                  ; 31C7 _ B8, 00000000
        call    nasm_nonfatal                           ; 31CC _ E8, 00000000(PLT r)
        mov     byte [rbp-0D8H], 1                      ; 31D1 _ C6. 85, FFFFFF28, 01
        jmp     ?_292                                   ; 31D8 _ E9, 000000A3

?_288:  cmp     dword [rbp-0C8H], 0                     ; 31DD _ 83. BD, FFFFFF38, 00
        jz      ?_289                                   ; 31E4 _ 74, 47
        cmp     dword [rbp-0C8H], 44                    ; 31E6 _ 83. BD, FFFFFF38, 2C
        jz      ?_289                                   ; 31ED _ 74, 3E
        cmp     dword [rbp-0C8H], 58                    ; 31EF _ 83. BD, FFFFFF38, 3A
        jz      ?_289                                   ; 31F6 _ 74, 35
        cmp     dword [rbp-0C8H], 284                   ; 31F8 _ 81. BD, FFFFFF38, 0000011C
        jz      ?_289                                   ; 3202 _ 74, 29
        cmp     dword [rbp-0C8H], 287                   ; 3204 _ 81. BD, FFFFFF38, 0000011F
        jz      ?_289                                   ; 320E _ 74, 1D
        lea     rax, [rel ?_405]                        ; 3210 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 3217 _ 48: 89. C7
        mov     eax, 0                                  ; 321A _ B8, 00000000
        call    nasm_nonfatal                           ; 321F _ E8, 00000000(PLT r)
        mov     byte [rbp-0D8H], 1                      ; 3224 _ C6. 85, FFFFFF28, 01
        jmp     ?_292                                   ; 322B _ EB, 53

?_289:  cmp     dword [rbp-0C8H], 58                    ; 322D _ 83. BD, FFFFFF38, 3A
        jnz     ?_290                                   ; 3234 _ 75, 1D
        mov     rax, qword [rbp-0A0H]                   ; 3236 _ 48: 8B. 85, FFFFFF60
        mov     rax, qword [rax]                        ; 323D _ 48: 8B. 00
        or      rax, 20H                                ; 3240 _ 48: 83. C8, 20
        mov     rdx, rax                                ; 3244 _ 48: 89. C2
        mov     rax, qword [rbp-0A0H]                   ; 3247 _ 48: 8B. 85, FFFFFF60
        mov     qword [rax], rdx                        ; 324E _ 48: 89. 10
        jmp     ?_292                                   ; 3251 _ EB, 2D

?_290:  cmp     dword [rbp-0C8H], 284                   ; 3253 _ 81. BD, FFFFFF38, 0000011C
        jz      ?_291                                   ; 325D _ 74, 0C
        cmp     dword [rbp-0C8H], 287                   ; 325F _ 81. BD, FFFFFF38, 0000011F
        jnz     ?_292                                   ; 3269 _ 75, 15
?_291:  lea     rax, [rbp-0CEH]                         ; 326B _ 48: 8D. 85, FFFFFF32
        mov     rdi, rax                                ; 3272 _ 48: 89. C7
        call    parse_decorators                        ; 3275 _ E8, FFFFD31B
        mov     byte [rbp-0D8H], al                     ; 327A _ 88. 85, FFFFFF28
?_292:  cmp     byte [rbp-0D8H], 0                      ; 3280 _ 80. BD, FFFFFF28, 00
        jz      ?_294                                   ; 3287 _ 74, 2C
?_293:  lea     rax, [rel tokval]                       ; 3289 _ 48: 8D. 05, 00000000(rel)
        mov     rsi, rax                                ; 3290 _ 48: 89. C6
        mov     edi, 0                                  ; 3293 _ BF, 00000000
        call    stdscan                                 ; 3298 _ E8, 00000000(PLT r)
        mov     dword [rbp-0C8H], eax                   ; 329D _ 89. 85, FFFFFF38
        cmp     dword [rbp-0C8H], 0                     ; 32A3 _ 83. BD, FFFFFF38, 00
        jz      ?_294                                   ; 32AA _ 74, 09
        cmp     dword [rbp-0C8H], 44                    ; 32AC _ 83. BD, FFFFFF38, 2C
        jnz     ?_293                                   ; 32B3 _ 75, D4
?_294:  mov     rax, qword [rbp-0A0H]                   ; 32B5 _ 48: 8B. 85, FFFFFF60
        movzx   edx, word [rax+40H]                     ; 32BC _ 0F B7. 50, 40
        movzx   eax, word [rbp-0CEH]                    ; 32C0 _ 0F B7. 85, FFFFFF32
        or      edx, eax                                ; 32C7 _ 09. C2
        mov     rax, qword [rbp-0A0H]                   ; 32C9 _ 48: 8B. 85, FFFFFF60
        mov     word [rax+40H], dx                      ; 32D0 _ 66: 89. 50, 40
        cmp     byte [rbp-0D6H], 0                      ; 32D4 _ 80. BD, FFFFFF2A, 00
        jz      ?_296                                   ; 32DB _ 74, 62
        movzx   eax, byte [rbp-0D5H]                    ; 32DD _ 0F B6. 85, FFFFFF2B
        xor     eax, 01H                                ; 32E4 _ 83. F0, 01
        test    al, al                                  ; 32E7 _ 84. C0
        jz      ?_295                                   ; 32E9 _ 74, 40
        mov     rdx, qword [rbp-98H]                    ; 32EB _ 48: 8B. 95, FFFFFF68
        mov     rax, qword [rbp-0A0H]                   ; 32F2 _ 48: 8B. 85, FFFFFF60
        mov     rsi, rdx                                ; 32F9 _ 48: 89. D6
        mov     rdi, rax                                ; 32FC _ 48: 89. C7
        call    parse_mref                              ; 32FF _ E8, FFFFD490
        test    eax, eax                                ; 3304 _ 85. C0
        jne     ?_337                                   ; 3306 _ 0F 85, 00000803
        mov     rax, qword [rbp-60H]                    ; 330C _ 48: 8B. 45, A0
        mov     edx, eax                                ; 3310 _ 89. C2
        mov     rax, qword [rbp-0A0H]                   ; 3312 _ 48: 8B. 85, FFFFFF60
        mov     dword [rax+1CH], edx                    ; 3319 _ 89. 50, 1C
        mov     eax, dword [rbp-58H]                    ; 331C _ 8B. 45, A8
        mov     edx, eax                                ; 331F _ 89. C2
        mov     rax, qword [rbp-0A0H]                   ; 3321 _ 48: 8B. 85, FFFFFF60
        mov     dword [rax+20H], edx                    ; 3328 _ 89. 50, 20
?_295:  mov     rax, qword [rbp-0A0H]                   ; 332B _ 48: 8B. 85, FFFFFF60
        mov     rdi, rax                                ; 3332 _ 48: 89. C7
        call    mref_set_optype                         ; 3335 _ E8, FFFFD715
        jmp     ?_326                                   ; 333A _ E9, 00000707

?_296:  mov     rax, qword [rbp-0A0H]                   ; 333F _ 48: 8B. 85, FFFFFF60
        mov     rax, qword [rax]                        ; 3346 _ 48: 8B. 00
        mov     rdx, qword 10000000000H                 ; 3349 _ 48: BA, 0000010000000000
        and     rax, rdx                                ; 3353 _ 48: 21. D0
        test    rax, rax                                ; 3356 _ 48: 85. C0
        jz      ?_297                                   ; 3359 _ 74, 2E
        movzx   eax, byte [rbp-0D0H]                    ; 335B _ 0F B6. 85, FFFFFF30
        xor     eax, 01H                                ; 3362 _ 83. F0, 01
        test    al, al                                  ; 3365 _ 84. C0
        jz      ?_297                                   ; 3367 _ 74, 20
        lea     rax, [rel ?_406]                        ; 3369 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 3370 _ 48: 89. C7
        mov     eax, 0                                  ; 3373 _ B8, 00000000
        call    nasm_nonfatal                           ; 3378 _ E8, 00000000(PLT r)
        mov     byte [rbp-0D8H], 1                      ; 337D _ C6. 85, FFFFFF28, 01
        jmp     ?_326                                   ; 3384 _ E9, 000006BD

?_297:  mov     rax, qword [rbp-98H]                    ; 3389 _ 48: 8B. 85, FFFFFF68
        mov     rdi, rax                                ; 3390 _ 48: 89. C7
        call    expr_class                              ; 3393 _ E8, 00000000(PLT r)
        mov     dword [rbp-0B0H], eax                   ; 3398 _ 89. 85, FFFFFF50
        cmp     dword [rbp-0B0H], 63                    ; 339E _ 83. BD, FFFFFF50, 3F
        ja      ?_307                                   ; 33A5 _ 0F 87, 000002BC
        mov     byte [rbp-0D2H], 0                      ; 33AB _ C6. 85, FFFFFF2E, 00
        mov     rax, qword [rbp-98H]                    ; 33B2 _ 48: 8B. 85, FFFFFF68
        mov     rdi, rax                                ; 33B9 _ 48: 89. C7
        call    reloc_value                             ; 33BC _ E8, 00000000(PLT r)
        mov     rdx, qword [rbp-0A0H]                   ; 33C1 _ 48: 8B. 95, FFFFFF60
        mov     qword [rdx+28H], rax                    ; 33C8 _ 48: 89. 42, 28
        mov     rax, qword [rbp-98H]                    ; 33CC _ 48: 8B. 85, FFFFFF68
        mov     rdi, rax                                ; 33D3 _ 48: 89. C7
        call    reloc_seg                               ; 33D6 _ E8, 00000000(PLT r)
        mov     rdx, qword [rbp-0A0H]                   ; 33DB _ 48: 8B. 95, FFFFFF60
        mov     dword [rdx+24H], eax                    ; 33E2 _ 89. 42, 24
        mov     rax, qword [rbp-98H]                    ; 33E5 _ 48: 8B. 85, FFFFFF68
        mov     rdi, rax                                ; 33EC _ 48: 89. C7
        call    reloc_wrt                               ; 33EF _ E8, 00000000(PLT r)
        mov     rdx, qword [rbp-0A0H]                   ; 33F4 _ 48: 8B. 95, FFFFFF60
        mov     dword [rdx+30H], eax                    ; 33FB _ 89. 42, 30
        mov     eax, dword [rbp-0B0H]                   ; 33FE _ 8B. 85, FFFFFF50
        and     eax, 04H                                ; 3404 _ 83. E0, 04
        test    eax, eax                                ; 3407 _ 85. C0
        jz      ?_298                                   ; 3409 _ 74, 19
        mov     rax, qword [rbp-0A0H]                   ; 340B _ 48: 8B. 85, FFFFFF60
        mov     eax, dword [rax+38H]                    ; 3412 _ 8B. 40, 38
        or      eax, 08H                                ; 3415 _ 83. C8, 08
        mov     edx, eax                                ; 3418 _ 89. C2
        mov     rax, qword [rbp-0A0H]                   ; 341A _ 48: 8B. 85, FFFFFF60
        mov     dword [rax+38H], edx                    ; 3421 _ 89. 50, 38
?_298:  cmp     dword [rbp-0B0H], 3                     ; 3424 _ 83. BD, FFFFFF50, 03
        ja      ?_299                                   ; 342B _ 77, 19
        mov     rax, qword [rbp-0A0H]                   ; 342D _ 48: 8B. 85, FFFFFF60
        mov     eax, dword [rax+38H]                    ; 3434 _ 8B. 40, 38
        or      eax, 10H                                ; 3437 _ 83. C8, 10
        mov     edx, eax                                ; 343A _ 89. C2
        mov     rax, qword [rbp-0A0H]                   ; 343C _ 48: 8B. 85, FFFFFF60
        mov     dword [rax+38H], edx                    ; 3443 _ 89. 50, 38
?_299:  mov     eax, dword [rbp-0B0H]                   ; 3446 _ 8B. 85, FFFFFF50
        and     eax, 20H                                ; 344C _ 83. E0, 20
        test    eax, eax                                ; 344F _ 85. C0
        jz      ?_300                                   ; 3451 _ 74, 19
        mov     rax, qword [rbp-0A0H]                   ; 3453 _ 48: 8B. 85, FFFFFF60
        mov     eax, dword [rax+38H]                    ; 345A _ 8B. 40, 38
        or      eax, 04H                                ; 345D _ 83. C8, 04
        mov     edx, eax                                ; 3460 _ 89. C2
        mov     rax, qword [rbp-0A0H]                   ; 3462 _ 48: 8B. 85, FFFFFF60
        mov     dword [rax+38H], edx                    ; 3469 _ 89. 50, 38
?_300:  mov     rax, qword [rbp-0A0H]                   ; 346C _ 48: 8B. 85, FFFFFF60
        mov     rax, qword [rax]                        ; 3473 _ 48: 8B. 00
        or      rax, 40002H                             ; 3476 _ 48: 0D, 00040002
        mov     rdx, rax                                ; 347C _ 48: 89. C2
        mov     rax, qword [rbp-0A0H]                   ; 347F _ 48: 8B. 85, FFFFFF60
        mov     qword [rax], rdx                        ; 3486 _ 48: 89. 10
        mov     rax, qword [rbp-0F0H]                   ; 3489 _ 48: 8B. 85, FFFFFF10
        mov     edx, dword [rax+94H]                    ; 3490 _ 8B. 90, 00000094
        mov     rax, qword [rbp-0A0H]                   ; 3496 _ 48: 8B. 85, FFFFFF60
        mov     esi, edx                                ; 349D _ 89. D6
        mov     rdi, rax                                ; 349F _ 48: 89. C7
        call    set_imm_flags                           ; 34A2 _ E8, FFFFE512
        mov     dword [rbp-0BCH], 0                     ; 34A7 _ C7. 85, FFFFFF44, 00000000
        jmp     ?_302                                   ; 34B1 _ EB, 5B

?_301:  movzx   ecx, byte [rbp-0D2H]                    ; 34B3 _ 0F B6. 8D, FFFFFF2E
        mov     rsi, qword [rbp-0F0H]                   ; 34BA _ 48: 8B. B5, FFFFFF10
        mov     eax, dword [rbp-0BCH]                   ; 34C1 _ 8B. 85, FFFFFF44
        movsxd  rdx, eax                                ; 34C7 _ 48: 63. D0
        mov     rax, rdx                                ; 34CA _ 48: 89. D0
        shl     rax, 3                                  ; 34CD _ 48: C1. E0, 03
        add     rax, rdx                                ; 34D1 _ 48: 01. D0
        shl     rax, 3                                  ; 34D4 _ 48: C1. E0, 03
        add     rax, rsi                                ; 34D8 _ 48: 01. F0
        add     rax, 200                                ; 34DB _ 48: 05, 000000C8
        mov     rax, qword [rax]                        ; 34E1 _ 48: 8B. 00
        mov     rdx, qword 0FFFF00000000H               ; 34E4 _ 48: BA, 0000FFFF00000000
        and     rax, rdx                                ; 34EE _ 48: 21. D0
        test    rax, rax                                ; 34F1 _ 48: 85. C0
        setne   al                                      ; 34F4 _ 0F 95. C0
        movzx   eax, al                                 ; 34F7 _ 0F B6. C0
        or      eax, ecx                                ; 34FA _ 09. C8
        test    eax, eax                                ; 34FC _ 85. C0
        setne   al                                      ; 34FE _ 0F 95. C0
        mov     byte [rbp-0D2H], al                     ; 3501 _ 88. 85, FFFFFF2E
        add     dword [rbp-0BCH], 1                     ; 3507 _ 83. 85, FFFFFF44, 01
?_302:  mov     eax, dword [rbp-0BCH]                   ; 350E _ 8B. 85, FFFFFF44
        cmp     eax, dword [rbp-0CCH]                   ; 3514 _ 3B. 85, FFFFFF34
        jle     ?_301                                   ; 351A _ 7E, 97
        movzx   eax, byte [rbp-0D2H]                    ; 351C _ 0F B6. 85, FFFFFF2E
        xor     eax, 01H                                ; 3523 _ 83. F0, 01
        test    al, al                                  ; 3526 _ 84. C0
        jz      ?_306                                   ; 3528 _ 74, 79
        mov     rax, qword [rbp-0A0H]                   ; 352A _ 48: 8B. 85, FFFFFF60
        mov     eax, dword [rax+38H]                    ; 3531 _ 8B. 40, 38
        and     eax, 01H                                ; 3534 _ 83. E0, 01
        test    eax, eax                                ; 3537 _ 85. C0
        jz      ?_306                                   ; 3539 _ 74, 68
        mov     dword [rbp-0B8H], 0                     ; 353B _ C7. 85, FFFFFF48, 00000000
        jmp     ?_305                                   ; 3545 _ EB, 4E

?_303:  mov     rcx, qword [rbp-0F0H]                   ; 3547 _ 48: 8B. 8D, FFFFFF10
        mov     eax, dword [rbp-0B8H]                   ; 354E _ 8B. 85, FFFFFF48
        movsxd  rdx, eax                                ; 3554 _ 48: 63. D0
        mov     rax, rdx                                ; 3557 _ 48: 89. D0
        shl     rax, 3                                  ; 355A _ 48: C1. E0, 03
        add     rax, rdx                                ; 355E _ 48: 01. D0
        shl     rax, 3                                  ; 3561 _ 48: C1. E0, 03
        add     rax, rcx                                ; 3565 _ 48: 01. C8
        add     rax, 192                                ; 3568 _ 48: 05, 000000C0
        mov     rax, qword [rax]                        ; 356E _ 48: 8B. 00
        and     eax, 0FH                                ; 3571 _ 83. E0, 0F
        cmp     rax, 12                                 ; 3574 _ 48: 83. F8, 0C
        jnz     ?_304                                   ; 3578 _ 75, 14
        lea     rax, [rel ?_407]                        ; 357A _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 3581 _ 48: 89. C7
        mov     eax, 0                                  ; 3584 _ B8, 00000000
        call    nasm_fatal                              ; 3589 _ E8, 00000000(PLT r)
?_304:  add     dword [rbp-0B8H], 1                     ; 358E _ 83. 85, FFFFFF48, 01
?_305:  mov     eax, dword [rbp-0B8H]                   ; 3595 _ 8B. 85, FFFFFF48
        cmp     eax, dword [rbp-0CCH]                   ; 359B _ 3B. 85, FFFFFF34
        jle     ?_303                                   ; 35A1 _ 7E, A4
?_306:  cmp     dword [rbp-0CCH], 0                     ; 35A3 _ 83. BD, FFFFFF34, 00
        jle     ?_326                                   ; 35AA _ 0F 8E, 00000496
        mov     rax, qword [rbp-0A0H]                   ; 35B0 _ 48: 8B. 85, FFFFFF60
        sub     rax, 72                                 ; 35B7 _ 48: 83. E8, 48
        mov     rax, qword [rax]                        ; 35BB _ 48: 8B. 00
        mov     esi, 262178                             ; 35BE _ BE, 00040022
        mov     rdi, rax                                ; 35C3 _ 48: 89. C7
        call    is_class                                ; 35C6 _ E8, FFFFCA35
        movzx   eax, al                                 ; 35CB _ 0F B6. C0
        test    rax, rax                                ; 35CE _ 48: 85. C0
        je      ?_326                                   ; 35D1 _ 0F 84, 0000046F
        mov     rax, qword [rbp-0A0H]                   ; 35D7 _ 48: 8B. 85, FFFFFF60
        mov     rax, qword [rax]                        ; 35DE _ 48: 8B. 00
        mov     rdx, qword 0FFFF00000000H               ; 35E1 _ 48: BA, 0000FFFF00000000
        and     rax, rdx                                ; 35EB _ 48: 21. D0
        mov     qword [rbp-70H], rax                    ; 35EE _ 48: 89. 45, 90
        mov     rax, qword [rbp-0A0H]                   ; 35F2 _ 48: 8B. 85, FFFFFF60
        sub     rax, 72                                 ; 35F9 _ 48: 83. E8, 48
        mov     rax, qword [rax]                        ; 35FD _ 48: 8B. 00
        mov     rdx, qword 0FFFF00000000H               ; 3600 _ 48: BA, 0000FFFF00000000
        and     rax, rdx                                ; 360A _ 48: 21. D0
        mov     qword [rbp-68H], rax                    ; 360D _ 48: 89. 45, 98
        cmp     qword [rbp-68H], 0                      ; 3611 _ 48: 83. 7D, 98, 00
        je      ?_326                                   ; 3616 _ 0F 84, 0000042A
        cmp     qword [rbp-70H], 0                      ; 361C _ 48: 83. 7D, 90, 00
        jne     ?_326                                   ; 3621 _ 0F 85, 0000041F
        mov     rax, qword [rbp-0A0H]                   ; 3627 _ 48: 8B. 85, FFFFFF60
        mov     rax, qword [rax]                        ; 362E _ 48: 8B. 00
        xor     rax, qword [rbp-68H]                    ; 3631 _ 48: 33. 45, 98
        mov     rdx, rax                                ; 3635 _ 48: 89. C2
        mov     rax, qword [rbp-0A0H]                   ; 3638 _ 48: 8B. 85, FFFFFF60
        mov     qword [rax], rdx                        ; 363F _ 48: 89. 10
        mov     rax, qword [rbp-0A0H]                   ; 3642 _ 48: 8B. 85, FFFFFF60
        sub     rax, 72                                 ; 3649 _ 48: 83. E8, 48
        mov     rax, qword [rax]                        ; 364D _ 48: 8B. 00
        mov     rdx, qword [rbp-0A0H]                   ; 3650 _ 48: 8B. 95, FFFFFF60
        sub     rdx, 72                                 ; 3657 _ 48: 83. EA, 48
        xor     rax, qword [rbp-68H]                    ; 365B _ 48: 33. 45, 98
        mov     qword [rdx], rax                        ; 365F _ 48: 89. 02
        jmp     ?_326                                   ; 3662 _ E9, 000003DF

?_307:  mov     rax, qword [rbp-98H]                    ; 3667 _ 48: 8B. 85, FFFFFF68
        mov     eax, dword [rax]                        ; 366E _ 8B. 00
        cmp     eax, 348                                ; 3670 _ 3D, 0000015C
        jne     ?_311                                   ; 3675 _ 0F 85, 00000095
        sub     dword [rbp-0CCH], 1                     ; 367B _ 83. AD, FFFFFF34, 01
        sub     qword [rbp-0A0H], 72                    ; 3682 _ 48: 83. AD, FFFFFF60, 48
        mov     rax, qword [rbp-98H]                    ; 368A _ 48: 8B. 85, FFFFFF68
        mov     rax, qword [rax+8H]                     ; 3691 _ 48: 8B. 40, 08
        sub     rax, 396                                ; 3695 _ 48: 2D, 0000018C
        cmp     rax, 4                                  ; 369B _ 48: 83. F8, 04
        ja      ?_310                                   ; 369F _ 77, 56
        mov     rax, qword [rbp-0A0H]                   ; 36A1 _ 48: 8B. 85, FFFFFF60
        movzx   edx, word [rax+40H]                     ; 36A8 _ 0F B7. 50, 40
        mov     rax, qword [rbp-98H]                    ; 36AC _ 48: 8B. 85, FFFFFF68
        mov     rax, qword [rax+8H]                     ; 36B3 _ 48: 8B. 40, 08
        cmp     rax, 400                                ; 36B7 _ 48: 3D, 00000190
        jnz     ?_308                                   ; 36BD _ 75, 07
        mov     eax, 128                                ; 36BF _ B8, 00000080
        jmp     ?_309                                   ; 36C4 _ EB, 05

?_308:  mov     eax, 64                                 ; 36C6 _ B8, 00000040
?_309:  or      edx, eax                                ; 36CB _ 09. C2
        mov     rax, qword [rbp-0A0H]                   ; 36CD _ 48: 8B. 85, FFFFFF60
        mov     word [rax+40H], dx                      ; 36D4 _ 66: 89. 50, 40
        mov     rax, qword [rbp-98H]                    ; 36D8 _ 48: 8B. 85, FFFFFF68
        mov     rax, qword [rax+8H]                     ; 36DF _ 48: 8B. 40, 08
        mov     edx, eax                                ; 36E3 _ 89. C2
        mov     rax, qword [rbp-0F0H]                   ; 36E5 _ 48: 8B. 85, FFFFFF10
        mov     dword [rax+90H], edx                    ; 36EC _ 89. 90, 00000090
        jmp     ?_326                                   ; 36F2 _ E9, 0000034F

?_310:  lea     rax, [rel ?_408]                        ; 36F7 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 36FE _ 48: 89. C7
        mov     eax, 0                                  ; 3701 _ B8, 00000000
        call    nasm_nonfatal                           ; 3706 _ E8, 00000000(PLT r)
        jmp     ?_326                                   ; 370B _ E9, 00000336

?_311:  mov     qword [rbp-88H], 0                      ; 3710 _ 48: C7. 85, FFFFFF78, 00000000
        mov     rax, qword [rbp-98H]                    ; 371B _ 48: 8B. 85, FFFFFF68
        mov     eax, dword [rax]                        ; 3722 _ 8B. 00
        cmp     eax, 345                                ; 3724 _ 3D, 00000159
        jg      ?_312                                   ; 3729 _ 7F, 11
        mov     rax, qword [rbp-98H]                    ; 372B _ 48: 8B. 85, FFFFFF68
        mov     rax, qword [rax+8H]                     ; 3732 _ 48: 8B. 40, 08
        cmp     rax, 1                                  ; 3736 _ 48: 83. F8, 01
        jz      ?_313                                   ; 373A _ 74, 19
?_312:  lea     rax, [rel ?_409]                        ; 373C _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 3743 _ 48: 89. C7
        mov     eax, 0                                  ; 3746 _ B8, 00000000
        call    nasm_nonfatal                           ; 374B _ E8, 00000000(PLT r)
        jmp     ?_338                                   ; 3750 _ E9, 000003BB

?_313:  mov     dword [rbp-0C8H], 1                     ; 3755 _ C7. 85, FFFFFF38, 00000001
        jmp     ?_318                                   ; 375F _ E9, 00000099

?_314:  mov     eax, dword [rbp-0C8H]                   ; 3764 _ 8B. 85, FFFFFF38
        cdqe                                            ; 376A _ 48: 98
        shl     rax, 4                                  ; 376C _ 48: C1. E0, 04
        mov     rdx, rax                                ; 3770 _ 48: 89. C2
        mov     rax, qword [rbp-98H]                    ; 3773 _ 48: 8B. 85, FFFFFF68
        add     rax, rdx                                ; 377A _ 48: 01. D0
        mov     rax, qword [rax+8H]                     ; 377D _ 48: 8B. 40, 08
        test    rax, rax                                ; 3781 _ 48: 85. C0
        jz      ?_316                                   ; 3784 _ 74, 6F
        mov     eax, dword [rbp-0C8H]                   ; 3786 _ 8B. 85, FFFFFF38
        cdqe                                            ; 378C _ 48: 98
        shl     rax, 4                                  ; 378E _ 48: C1. E0, 04
        mov     rdx, rax                                ; 3792 _ 48: 89. C2
        mov     rax, qword [rbp-98H]                    ; 3795 _ 48: 8B. 85, FFFFFF68
        add     rax, rdx                                ; 379C _ 48: 01. D0
        mov     eax, dword [rax]                        ; 379F _ 8B. 00
        cmp     eax, 346                                ; 37A1 _ 3D, 0000015A
        jnz     ?_315                                   ; 37A6 _ 75, 34
        cmp     qword [rbp-88H], 0                      ; 37A8 _ 48: 83. BD, FFFFFF78, 00
        jnz     ?_315                                   ; 37B0 _ 75, 2A
        mov     eax, dword [rbp-0C8H]                   ; 37B2 _ 8B. 85, FFFFFF38
        cdqe                                            ; 37B8 _ 48: 98
        shl     rax, 4                                  ; 37BA _ 48: C1. E0, 04
        mov     rdx, rax                                ; 37BE _ 48: 89. C2
        mov     rax, qword [rbp-98H]                    ; 37C1 _ 48: 8B. 85, FFFFFF68
        add     rax, rdx                                ; 37C8 _ 48: 01. D0
        mov     rax, qword [rax+8H]                     ; 37CB _ 48: 8B. 40, 08
        add     rax, 1                                  ; 37CF _ 48: 83. C0, 01
        mov     qword [rbp-88H], rax                    ; 37D3 _ 48: 89. 85, FFFFFF78
        jmp     ?_317                                   ; 37DA _ EB, 1A

?_315:  lea     rax, [rel ?_409]                        ; 37DC _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 37E3 _ 48: 89. C7
        mov     eax, 0                                  ; 37E6 _ B8, 00000000
        call    nasm_nonfatal                           ; 37EB _ E8, 00000000(PLT r)
        jmp     ?_338                                   ; 37F0 _ E9, 0000031B

?_316:  nop                                             ; 37F5 _ 90
?_317:  add     dword [rbp-0C8H], 1                     ; 37F6 _ 83. 85, FFFFFF38, 01
?_318:  mov     eax, dword [rbp-0C8H]                   ; 37FD _ 8B. 85, FFFFFF38
        cdqe                                            ; 3803 _ 48: 98
        shl     rax, 4                                  ; 3805 _ 48: C1. E0, 04
        mov     rdx, rax                                ; 3809 _ 48: 89. C2
        mov     rax, qword [rbp-98H]                    ; 380C _ 48: 8B. 85, FFFFFF68
        add     rax, rdx                                ; 3813 _ 48: 01. D0
        mov     eax, dword [rax]                        ; 3816 _ 8B. 00
        test    eax, eax                                ; 3818 _ 85. C0
        jne     ?_314                                   ; 381A _ 0F 85, FFFFFF44
        mov     rax, qword [rbp-88H]                    ; 3820 _ 48: 8B. 85, FFFFFF78
        sub     rax, 1                                  ; 3827 _ 48: 83. E8, 01
        and     rax, qword [rbp-88H]                    ; 382B _ 48: 23. 85, FFFFFF78
        test    rax, rax                                ; 3832 _ 48: 85. C0
        jnz     ?_319                                   ; 3835 _ 75, 0A
        cmp     qword [rbp-88H], 31                     ; 3837 _ 48: 83. BD, FFFFFF78, 1F
        jbe     ?_320                                   ; 383F _ 76, 24
?_319:  lea     rax, [rel ?_410]                        ; 3841 _ 48: 8D. 05, 00000000(rel)
        mov     rsi, rax                                ; 3848 _ 48: 89. C6
        mov     edi, 256                                ; 384B _ BF, 00000100
        mov     eax, 0                                  ; 3850 _ B8, 00000000
        call    nasm_nonfatalf                          ; 3855 _ E8, 00000000(PLT r)
        mov     qword [rbp-88H], 0                      ; 385A _ 48: C7. 85, FFFFFF78, 00000000
?_320:  mov     rax, qword [rbp-0A0H]                   ; 3865 _ 48: 8B. 85, FFFFFF60
        mov     rax, qword [rax]                        ; 386C _ 48: 8B. 00
        and     rax, 0FFFFFFFFFFFFFFCFH                 ; 386F _ 48: 83. E0, CF
        test    rax, rax                                ; 3873 _ 48: 85. C0
        jz      ?_321                                   ; 3876 _ 74, 20
        mov     rax, qword [rbp-0A0H]                   ; 3878 _ 48: 8B. 85, FFFFFF60
        mov     rax, qword [rax]                        ; 387F _ 48: 8B. 00
        mov     rdx, qword 0FDFF00000000H               ; 3882 _ 48: BA, 0000FDFF00000000
        and     rax, rdx                                ; 388C _ 48: 21. D0
        mov     qword [rbp-90H], rax                    ; 388F _ 48: 89. 85, FFFFFF70
        jmp     ?_322                                   ; 3896 _ EB, 0B

?_321:  mov     qword [rbp-90H], 0                      ; 3898 _ 48: C7. 85, FFFFFF70, 00000000
?_322:  mov     rax, qword [rbp-98H]                    ; 38A3 _ 48: 8B. 85, FFFFFF68
        mov     eax, dword [rax]                        ; 38AA _ 8B. 00
        test    eax, eax                                ; 38AC _ 85. C0
        jle     ?_323                                   ; 38AE _ 7E, 10
        mov     rax, qword [rbp-98H]                    ; 38B0 _ 48: 8B. 85, FFFFFF68
        mov     eax, dword [rax]                        ; 38B7 _ 8B. 00
        cmp     eax, 344                                ; 38B9 _ 3D, 00000158
        jle     ?_324                                   ; 38BE _ 7E, 19
?_323:  lea     rax, [rel ?_409]                        ; 38C0 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 38C7 _ 48: 89. C7
        mov     eax, 0                                  ; 38CA _ B8, 00000000
        call    nasm_nonfatal                           ; 38CF _ E8, 00000000(PLT r)
        jmp     ?_338                                   ; 38D4 _ E9, 00000237

?_324:  mov     rax, qword [rbp-0A0H]                   ; 38D9 _ 48: 8B. 85, FFFFFF60
        mov     rax, qword [rax]                        ; 38E0 _ 48: 8B. 00
        and     eax, 30H                                ; 38E3 _ 83. E0, 30
        mov     rdx, rax                                ; 38E6 _ 48: 89. C2
        mov     rax, qword [rbp-0A0H]                   ; 38E9 _ 48: 8B. 85, FFFFFF60
        mov     qword [rax], rdx                        ; 38F0 _ 48: 89. 10
        mov     rax, qword [rbp-0A0H]                   ; 38F3 _ 48: 8B. 85, FFFFFF60
        mov     rax, qword [rax]                        ; 38FA _ 48: 8B. 00
        or      rax, 01H                                ; 38FD _ 48: 83. C8, 01
        mov     rdx, rax                                ; 3901 _ 48: 89. C2
        mov     rax, qword [rbp-0A0H]                   ; 3904 _ 48: 8B. 85, FFFFFF60
        mov     qword [rax], rdx                        ; 390B _ 48: 89. 10
        mov     rax, qword [rbp-0A0H]                   ; 390E _ 48: 8B. 85, FFFFFF60
        mov     rdx, qword [rax]                        ; 3915 _ 48: 8B. 10
        mov     rax, qword [rbp-98H]                    ; 3918 _ 48: 8B. 85, FFFFFF68
        mov     eax, dword [rax]                        ; 391F _ 8B. 00
        cdqe                                            ; 3921 _ 48: 98
        lea     rcx, [rax*8]                            ; 3923 _ 48: 8D. 0C C5, 00000000
        lea     rax, [rel nasm_reg_flags]               ; 392B _ 48: 8D. 05, 00000000(rel)
        mov     rax, qword [rcx+rax]                    ; 3932 _ 48: 8B. 04 01
        or      rdx, rax                                ; 3936 _ 48: 09. C2
        mov     rax, qword [rbp-0A0H]                   ; 3939 _ 48: 8B. 85, FFFFFF60
        mov     qword [rax], rdx                        ; 3940 _ 48: 89. 10
        mov     rax, qword [rbp-0A0H]                   ; 3943 _ 48: 8B. 85, FFFFFF60
        mov     rax, qword [rax]                        ; 394A _ 48: 8B. 00
        mov     rdx, qword [rbp-88H]                    ; 394D _ 48: 8B. 95, FFFFFF78
        shr     rdx, 1                                  ; 3954 _ 48: D1. EA
        shl     rdx, 48                                 ; 3957 _ 48: C1. E2, 30
        or      rdx, rax                                ; 395B _ 48: 09. C2
        mov     rax, qword [rbp-0A0H]                   ; 395E _ 48: 8B. 85, FFFFFF60
        mov     qword [rax], rdx                        ; 3965 _ 48: 89. 10
        mov     rax, qword [rbp-0A0H]                   ; 3968 _ 48: 8B. 85, FFFFFF60
        movzx   edx, word [rax+40H]                     ; 396F _ 0F B7. 50, 40
        movzx   eax, word [rbp-0CEH]                    ; 3973 _ 0F B7. 85, FFFFFF32
        or      edx, eax                                ; 397A _ 09. C2
        mov     rax, qword [rbp-0A0H]                   ; 397C _ 48: 8B. 85, FFFFFF60
        mov     word [rax+40H], dx                      ; 3983 _ 66: 89. 50, 40
        mov     rax, qword [rbp-98H]                    ; 3987 _ 48: 8B. 85, FFFFFF68
        mov     edx, dword [rax]                        ; 398E _ 8B. 10
        mov     rax, qword [rbp-0A0H]                   ; 3990 _ 48: 8B. 85, FFFFFF60
        mov     dword [rax+10H], edx                    ; 3997 _ 89. 50, 10
        cmp     qword [rbp-90H], 0                      ; 399A _ 48: 83. BD, FFFFFF70, 00
        je      ?_326                                   ; 39A2 _ 0F 84, 0000009E
        mov     rax, qword [rbp-98H]                    ; 39A8 _ 48: 8B. 85, FFFFFF68
        mov     eax, dword [rax]                        ; 39AF _ 8B. 00
        cdqe                                            ; 39B1 _ 48: 98
        lea     rdx, [rax*8]                            ; 39B3 _ 48: 8D. 14 C5, 00000000
        lea     rax, [rel nasm_reg_flags]               ; 39BB _ 48: 8D. 05, 00000000(rel)
        mov     rax, qword [rdx+rax]                    ; 39C2 _ 48: 8B. 04 02
        mov     rdx, qword 0FDFF00000000H               ; 39C6 _ 48: BA, 0000FDFF00000000
        and     rax, rdx                                ; 39D0 _ 48: 21. D0
        mov     qword [rbp-78H], rax                    ; 39D3 _ 48: 89. 45, 88
        cmp     qword [rbp-78H], 0                      ; 39D7 _ 48: 83. 7D, 88, 00
        jnz     ?_325                                   ; 39DC _ 75, 20
        mov     rax, qword [rbp-0A0H]                   ; 39DE _ 48: 8B. 85, FFFFFF60
        mov     rax, qword [rax]                        ; 39E5 _ 48: 8B. 00
        or      rax, qword [rbp-90H]                    ; 39E8 _ 48: 0B. 85, FFFFFF70
        mov     rdx, rax                                ; 39EF _ 48: 89. C2
        mov     rax, qword [rbp-0A0H]                   ; 39F2 _ 48: 8B. 85, FFFFFF60
        mov     qword [rax], rdx                        ; 39F9 _ 48: 89. 10
        jmp     ?_326                                   ; 39FC _ EB, 48

?_325:  mov     rax, qword [rbp-78H]                    ; 39FE _ 48: 8B. 45, 88
        cmp     rax, qword [rbp-90H]                    ; 3A02 _ 48: 3B. 85, FFFFFF70
        jz      ?_326                                   ; 3A09 _ 74, 3B
        mov     dword [rbp-0ACH], 3473408               ; 3A0B _ C7. 85, FFFFFF54, 00350000
        mov     eax, dword [rbp-0ACH]                   ; 3A15 _ 8B. 85, FFFFFF54
        mov     edi, eax                                ; 3A1B _ 89. C7
        call    warn_active                             ; 3A1D _ E8, FFFFC674
        movzx   eax, al                                 ; 3A22 _ 0F B6. C0
        test    rax, rax                                ; 3A25 _ 48: 85. C0
        jz      ?_326                                   ; 3A28 _ 74, 1C
        lea     rdx, [rel ?_411]                        ; 3A2A _ 48: 8D. 15, 00000000(rel)
        mov     eax, dword [rbp-0ACH]                   ; 3A31 _ 8B. 85, FFFFFF54
        mov     rsi, rdx                                ; 3A37 _ 48: 89. D6
        mov     edi, eax                                ; 3A3A _ 89. C7
        mov     eax, 0                                  ; 3A3C _ B8, 00000000
        call    nasm_warn_                              ; 3A41 _ E8, 00000000(PLT r)
?_326:  mov     rax, qword [rbp-0A0H]                   ; 3A46 _ 48: 8B. 85, FFFFFF60
        movzx   eax, word [rax+40H]                     ; 3A4D _ 0F B7. 40, 40
        movzx   eax, ax                                 ; 3A51 _ 0F B7. C0
        and     eax, 0E0H                               ; 3A54 _ 25, 000000E0
        test    rax, rax                                ; 3A59 _ 48: 85. C0
        jz      ?_327                                   ; 3A5C _ 74, 43
        mov     rax, qword [rbp-0F0H]                   ; 3A5E _ 48: 8B. 85, FFFFFF10
        mov     rdx, qword [rbp-0A0H]                   ; 3A65 _ 48: 8B. 95, FFFFFF60
        mov     qword [rax+0B8H], rdx                   ; 3A6C _ 48: 89. 90, 000000B8
        mov     rax, qword [rbp-0A0H]                   ; 3A73 _ 48: 8B. 85, FFFFFF60
        mov     byte [rax+42H], 1                       ; 3A7A _ C6. 40, 42, 01
        mov     rax, qword [rbp-0A0H]                   ; 3A7E _ 48: 8B. 85, FFFFFF60
        movzx   eax, word [rax+40H]                     ; 3A85 _ 0F B7. 40, 40
        movzx   eax, ax                                 ; 3A89 _ 0F B7. C0
        and     eax, 0F00H                              ; 3A8C _ 25, 00000F00
        mov     rdx, rax                                ; 3A91 _ 48: 89. C2
        mov     rax, qword [rbp-0A0H]                   ; 3A94 _ 48: 8B. 85, FFFFFF60
        mov     qword [rax+8H], rdx                     ; 3A9B _ 48: 89. 50, 08
        jmp     ?_329                                   ; 3A9F _ EB, 30

?_327:  mov     rax, qword [rbp-0A0H]                   ; 3AA1 _ 48: 8B. 85, FFFFFF60
        mov     byte [rax+42H], 0                       ; 3AA8 _ C6. 40, 42, 00
        mov     rax, qword [rbp-0A0H]                   ; 3AAC _ 48: 8B. 85, FFFFFF60
        mov     rax, qword [rax]                        ; 3AB3 _ 48: 8B. 00
        mov     rdx, qword 0FFFF00000000H               ; 3AB6 _ 48: BA, 0000FFFF00000000
        and     rdx, rax                                ; 3AC0 _ 48: 21. C2
        mov     rax, qword [rbp-0A0H]                   ; 3AC3 _ 48: 8B. 85, FFFFFF60
        mov     qword [rax+8H], rdx                     ; 3ACA _ 48: 89. 50, 08
        jmp     ?_329                                   ; 3ACE _ EB, 01

?_328:  nop                                             ; 3AD0 _ 90
?_329:  add     dword [rbp-0CCH], 1                     ; 3AD1 _ 83. 85, FFFFFF34, 01
?_330:  cmp     dword [rbp-0CCH], 4                     ; 3AD8 _ 83. BD, FFFFFF34, 04
        jle     ?_215                                   ; 3ADF _ 0F 8E, FFFFE942
        jmp     ?_332                                   ; 3AE5 _ EB, 01

?_331:  nop                                             ; 3AE7 _ 90
?_332:  mov     eax, dword [rbp-0CCH]                   ; 3AE8 _ 8B. 85, FFFFFF34
        mov     edx, eax                                ; 3AEE _ 89. C2
        mov     rax, qword [rbp-0F0H]                   ; 3AF0 _ 48: 8B. 85, FFFFFF10
        mov     byte [rax+7DH], dl                      ; 3AF7 _ 88. 50, 7D
        mov     rax, qword [rbp-0F0H]                   ; 3AFA _ 48: 8B. 85, FFFFFF10
        jmp     ?_339                                   ; 3B01 _ EB, 21

?_333:  nop                                             ; 3B03 _ 90
        jmp     ?_338                                   ; 3B04 _ EB, 0A

?_334:  nop                                             ; 3B06 _ 90
        jmp     ?_338                                   ; 3B07 _ EB, 07

?_335:  nop                                             ; 3B09 _ 90
        jmp     ?_338                                   ; 3B0A _ EB, 04

?_336:  nop                                             ; 3B0C _ 90
        jmp     ?_338                                   ; 3B0D _ EB, 01

?_337:  nop                                             ; 3B0F _ 90
?_338:  mov     rax, qword [rbp-0F0H]                   ; 3B10 _ 48: 8B. 85, FFFFFF10
        mov     dword [rax], -1                         ; 3B17 _ C7. 00, FFFFFFFF
        mov     rax, qword [rbp-0F0H]                   ; 3B1D _ 48: 8B. 85, FFFFFF10
?_339:  mov     rdx, qword [rbp-8H]                     ; 3B24 _ 48: 8B. 55, F8
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        sub     rdx, qword [fs:abs 28H]                 ; 3B28 _ 64 48: 2B. 14 25, 00000028
        jz      ?_340                                   ; 3B31 _ 74, 05
        call    __stack_chk_fail                        ; 3B33 _ E8, 00000000(PLT r)
?_340:  leave                                           ; 3B38 _ C9
        ret                                             ; 3B39 _ C3
; parse_line End of function

end_expression_next:; Local function
        push    rbp                                     ; 3B3A _ 55
        mov     rbp, rsp                                ; 3B3B _ 48: 89. E5
        sub     rsp, 80                                 ; 3B3E _ 48: 83. EC, 50
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        mov     rax, qword [fs:abs 28H]                 ; 3B42 _ 64 48: 8B. 04 25, 00000028
        mov     qword [rbp-8H], rax                     ; 3B4B _ 48: 89. 45, F8
        xor     eax, eax                                ; 3B4F _ 31. C0
        call    stdscan_get                             ; 3B51 _ E8, 00000000(PLT r)
        mov     qword [rbp-48H], rax                    ; 3B56 _ 48: 89. 45, B8
        lea     rax, [rbp-40H]                          ; 3B5A _ 48: 8D. 45, C0
        mov     rsi, rax                                ; 3B5E _ 48: 89. C6
        mov     edi, 0                                  ; 3B61 _ BF, 00000000
        call    stdscan                                 ; 3B66 _ E8, 00000000(PLT r)
        mov     dword [rbp-4CH], eax                    ; 3B6B _ 89. 45, B4
        mov     rax, qword [rbp-48H]                    ; 3B6E _ 48: 8B. 45, B8
        mov     rdi, rax                                ; 3B72 _ 48: 89. C7
        call    stdscan_set                             ; 3B75 _ E8, 00000000(PLT r)
        cmp     dword [rbp-4CH], 44                     ; 3B7A _ 83. 7D, B4, 2C
        jz      ?_341                                   ; 3B7E _ 74, 12
        cmp     dword [rbp-4CH], 59                     ; 3B80 _ 83. 7D, B4, 3B
        jz      ?_341                                   ; 3B84 _ 74, 0C
        cmp     dword [rbp-4CH], 41                     ; 3B86 _ 83. 7D, B4, 29
        jz      ?_341                                   ; 3B8A _ 74, 06
        cmp     dword [rbp-4CH], 0                      ; 3B8C _ 83. 7D, B4, 00
        jnz     ?_342                                   ; 3B90 _ 75, 07
?_341:  mov     eax, 1                                  ; 3B92 _ B8, 00000001
        jmp     ?_343                                   ; 3B97 _ EB, 05

?_342:  mov     eax, 0                                  ; 3B99 _ B8, 00000000
?_343:  mov     rdx, qword [rbp-8H]                     ; 3B9E _ 48: 8B. 55, F8
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        sub     rdx, qword [fs:abs 28H]                 ; 3BA2 _ 64 48: 2B. 14 25, 00000028
        jz      ?_344                                   ; 3BAB _ 74, 05
        call    __stack_chk_fail                        ; 3BAD _ E8, 00000000(PLT r)
?_344:  leave                                           ; 3BB2 _ C9
        ret                                             ; 3BB3 _ C3

free_eops:; Local function
        push    rbp                                     ; 3BB4 _ 55
        mov     rbp, rsp                                ; 3BB5 _ 48: 89. E5
        sub     rsp, 32                                 ; 3BB8 _ 48: 83. EC, 20
        mov     qword [rbp-18H], rdi                    ; 3BBC _ 48: 89. 7D, E8
        jmp     ?_349                                   ; 3BC0 _ EB, 55

?_345:  mov     rax, qword [rbp-18H]                    ; 3BC2 _ 48: 8B. 45, E8
        mov     rax, qword [rax]                        ; 3BC6 _ 48: 8B. 00
        mov     qword [rbp-8H], rax                     ; 3BC9 _ 48: 89. 45, F8
        mov     rax, qword [rbp-18H]                    ; 3BCD _ 48: 8B. 45, E8
        mov     eax, dword [rax+28H]                    ; 3BD1 _ 8B. 40, 28
        cmp     eax, 1                                  ; 3BD4 _ 83. F8, 01
        jz      ?_346                                   ; 3BD7 _ 74, 07
        cmp     eax, 4                                  ; 3BD9 _ 83. F8, 04
        jz      ?_347                                   ; 3BDC _ 74, 14
        jmp     ?_348                                   ; 3BDE _ EB, 23

?_346:  mov     rax, qword [rbp-18H]                    ; 3BE0 _ 48: 8B. 45, E8
        mov     rax, qword [rax+8H]                     ; 3BE4 _ 48: 8B. 40, 08
        mov     rdi, rax                                ; 3BE8 _ 48: 89. C7
        call    free_eops                               ; 3BEB _ E8, FFFFFFC4
        jmp     ?_348                                   ; 3BF0 _ EB, 11

?_347:  mov     rax, qword [rbp-18H]                    ; 3BF2 _ 48: 8B. 45, E8
        mov     rax, qword [rax+8H]                     ; 3BF6 _ 48: 8B. 40, 08
        mov     rdi, rax                                ; 3BFA _ 48: 89. C7
        call    nasm_free                               ; 3BFD _ E8, 00000000(PLT r)
        nop                                             ; 3C02 _ 90
?_348:  mov     rax, qword [rbp-18H]                    ; 3C03 _ 48: 8B. 45, E8
        mov     rdi, rax                                ; 3C07 _ 48: 89. C7
        call    nasm_free                               ; 3C0A _ E8, 00000000(PLT r)
        mov     rax, qword [rbp-8H]                     ; 3C0F _ 48: 8B. 45, F8
        mov     qword [rbp-18H], rax                    ; 3C13 _ 48: 89. 45, E8
?_349:  cmp     qword [rbp-18H], 0                      ; 3C17 _ 48: 83. 7D, E8, 00
        jnz     ?_345                                   ; 3C1C _ 75, A4
        nop                                             ; 3C1E _ 90
        nop                                             ; 3C1F _ 90
        leave                                           ; 3C20 _ C9
        ret                                             ; 3C21 _ C3

cleanup_insn:; Function begin
        push    rbp                                     ; 3C22 _ 55
        mov     rbp, rsp                                ; 3C23 _ 48: 89. E5
        sub     rsp, 16                                 ; 3C26 _ 48: 83. EC, 10
        mov     qword [rbp-8H], rdi                     ; 3C2A _ 48: 89. 7D, F8
        mov     rax, qword [rbp-8H]                     ; 3C2E _ 48: 8B. 45, F8
        mov     rax, qword [rax+68H]                    ; 3C32 _ 48: 8B. 40, 68
        mov     rdi, rax                                ; 3C36 _ 48: 89. C7
        call    free_eops                               ; 3C39 _ E8, FFFFFF76
        nop                                             ; 3C3E _ 90
        leave                                           ; 3C3F _ C9
        ret                                             ; 3C40 _ C3
; cleanup_insn End of function


SECTION .data   align=1 noexec                          ; section number 2, data


SECTION .bss    align=32 noexec                         ; section number 3, bss

tokval:                                                 ; byte
        resq    1                                       ; 0000

?_350:  resq    1                                       ; 0008

?_351:  resq    1                                       ; 0010

?_352:  resq    1                                       ; 0018

?_353:                                                  ; qword
        resb    4                                       ; 0020

?_354:  resd    1                                       ; 0024

?_355:  resq    1                                       ; 0028

pass_last_seen.0:                                       ; qword
        resq    1                                       ; 0030


SECTION .rodata align=16 noexec                         ; section number 4, const

?_356:                                                  ; byte
        db 65H, 6EH, 64H, 20H, 6FH, 66H, 20H, 6CH       ; 0000 _ end of l
        db 69H, 6EH, 65H, 00H                           ; 0008 _ ine.

?_357:                                                  ; byte
        db 60H, 25H, 2EH, 2AH, 73H, 27H, 00H            ; 000C _ `%.*s'.

?_358:                                                  ; byte
        db 69H, 6EH, 76H, 61H, 6CH, 69H, 64H, 20H       ; 0013 _ invalid 
        db 74H, 6FH, 6BH, 65H, 6EH, 00H, 00H, 00H       ; 001B _ token...
        db 00H, 00H, 00H, 00H, 00H                      ; 0023 _ .....

?_359:                                                  ; byte
        db 69H, 6EH, 76H, 61H, 6CH, 69H, 64H, 20H       ; 0028 _ invalid 
        db 6FH, 70H, 65H, 72H, 61H, 6EH, 64H, 20H       ; 0030 _ operand 
        db 73H, 69H, 7AH, 65H, 20H, 73H, 70H, 65H       ; 0038 _ size spe
        db 63H, 69H, 66H, 69H, 63H, 61H, 74H, 69H       ; 0040 _ cificati
        db 6FH, 6EH, 00H, 00H, 00H, 00H, 00H, 00H       ; 0048 _ on......

?_360:                                                  ; byte
        db 63H, 6FH, 6EH, 66H, 6CH, 69H, 63H, 74H       ; 0050 _ conflict
        db 69H, 6EH, 67H, 20H, 61H, 64H, 64H, 72H       ; 0058 _ ing addr
        db 65H, 73H, 73H, 20H, 73H, 69H, 7AH, 65H       ; 0060 _ ess size
        db 20H, 73H, 70H, 65H, 63H, 69H, 66H, 69H       ; 0068 _  specifi
        db 63H, 61H, 74H, 69H, 6FH, 6EH, 73H, 00H       ; 0070 _ cations.

?_361:                                                  ; byte
        db 69H, 6EH, 76H, 61H, 6CH, 69H, 64H, 20H       ; 0078 _ invalid 
        db 73H, 69H, 7AH, 65H, 20H, 73H, 70H, 65H       ; 0080 _ size spe
        db 63H, 69H, 66H, 69H, 63H, 61H, 74H, 69H       ; 0088 _ cificati
        db 6FH, 6EH, 20H, 69H, 6EH, 20H, 65H, 66H       ; 0090 _ on in ef
        db 66H, 65H, 63H, 74H, 69H, 76H, 65H, 20H       ; 0098 _ fective 
        db 61H, 64H, 64H, 72H, 65H, 73H, 73H, 00H       ; 00A0 _ address.

?_362:                                                  ; byte
        db 6FH, 70H, 6DH, 61H, 73H, 6BH, 20H, 6BH       ; 00A8 _ opmask k
        db 25H, 6CH, 75H, 20H, 69H, 73H, 20H, 61H       ; 00B0 _ %lu is a
        db 6CH, 72H, 65H, 61H, 64H, 79H, 20H, 73H       ; 00B8 _ lready s
        db 65H, 74H, 00H, 00H, 00H, 00H, 00H, 00H       ; 00C0 _ et......

?_363:                                                  ; byte
        db 7BH, 25H, 73H, 7DH, 20H, 69H, 73H, 20H       ; 00C8 _ {%s} is 
        db 6EH, 6FH, 74H, 20H, 61H, 6EH, 20H, 65H       ; 00D0 _ not an e
        db 78H, 70H, 65H, 63H, 74H, 65H, 64H, 20H       ; 00D8 _ xpected 
        db 64H, 65H, 63H, 6FH, 72H, 61H, 74H, 6FH       ; 00E0 _ decorato
        db 72H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 00E8 _ r.......

?_364:                                                  ; byte
        db 6FH, 6EH, 6CH, 79H, 20H, 61H, 20H, 73H       ; 00F0 _ only a s
        db 65H, 72H, 69H, 65H, 73H, 20H, 6FH, 66H       ; 00F8 _ eries of
        db 20H, 76H, 61H, 6CH, 69H, 64H, 20H, 64H       ; 0100 _  valid d
        db 65H, 63H, 6FH, 72H, 61H, 74H, 6FH, 72H       ; 0108 _ ecorator
        db 73H, 20H, 65H, 78H, 70H, 65H, 63H, 74H       ; 0110 _ s expect
        db 65H, 64H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0118 _ ed......

?_365:                                                  ; byte
        db 69H, 6EH, 76H, 61H, 6CH, 69H, 64H, 20H       ; 0120 _ invalid 
        db 65H, 66H, 66H, 65H, 63H, 74H, 69H, 76H       ; 0128 _ effectiv
        db 65H, 20H, 61H, 64H, 64H, 72H, 65H, 73H       ; 0130 _ e addres
        db 73H, 3AH, 20H, 74H, 77H, 6FH, 20H, 69H       ; 0138 _ s: two i
        db 6EH, 64H, 65H, 78H, 20H, 72H, 65H, 67H       ; 0140 _ ndex reg
        db 69H, 73H, 74H, 65H, 72H, 73H, 00H, 00H       ; 0148 _ isters..

?_366:                                                  ; byte
        db 69H, 6EH, 76H, 61H, 6CH, 69H, 64H, 20H       ; 0150 _ invalid 
        db 65H, 66H, 66H, 65H, 63H, 74H, 69H, 76H       ; 0158 _ effectiv
        db 65H, 20H, 61H, 64H, 64H, 72H, 65H, 73H       ; 0160 _ e addres
        db 73H, 3AH, 20H, 69H, 6DH, 70H, 6FH, 73H       ; 0168 _ s: impos
        db 73H, 69H, 62H, 6CH, 65H, 20H, 72H, 65H       ; 0170 _ sible re
        db 67H, 69H, 73H, 74H, 65H, 72H, 00H, 00H       ; 0178 _ gister..

?_367:                                                  ; byte
        db 69H, 6EH, 76H, 61H, 6CH, 69H, 64H, 20H       ; 0180 _ invalid 
        db 65H, 66H, 66H, 65H, 63H, 74H, 69H, 76H       ; 0188 _ effectiv
        db 65H, 20H, 61H, 64H, 64H, 72H, 65H, 73H       ; 0190 _ e addres
        db 73H, 3AH, 20H, 74H, 6FH, 6FH, 20H, 6DH       ; 0198 _ s: too m
        db 61H, 6EH, 79H, 20H, 72H, 65H, 67H, 69H       ; 01A0 _ any regi
        db 73H, 74H, 65H, 72H, 73H, 00H, 00H, 00H       ; 01A8 _ sters...

?_368:                                                  ; byte
        db 69H, 6EH, 76H, 61H, 6CH, 69H, 64H, 20H       ; 01B0 _ invalid 
        db 65H, 66H, 66H, 65H, 63H, 74H, 69H, 76H       ; 01B8 _ effectiv
        db 65H, 20H, 61H, 64H, 64H, 72H, 65H, 73H       ; 01C0 _ e addres
        db 73H, 3AH, 20H, 6DH, 75H, 6CH, 74H, 69H       ; 01C8 _ s: multi
        db 70H, 6CH, 65H, 20H, 62H, 61H, 73H, 65H       ; 01D0 _ ple base
        db 20H, 73H, 65H, 67H, 6DH, 65H, 6EH, 74H       ; 01D8 _  segment
        db 73H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 01E0 _ s.......

?_369:                                                  ; byte
        db 69H, 6EH, 76H, 61H, 6CH, 69H, 64H, 20H       ; 01E8 _ invalid 
        db 65H, 66H, 66H, 65H, 63H, 74H, 69H, 76H       ; 01F0 _ effectiv
        db 65H, 20H, 61H, 64H, 64H, 72H, 65H, 73H       ; 01F8 _ e addres
        db 73H, 3AH, 20H, 69H, 6DH, 70H, 6FH, 73H       ; 0200 _ s: impos
        db 73H, 69H, 62H, 6CH, 65H, 20H, 73H, 65H       ; 0208 _ sible se
        db 67H, 6DH, 65H, 6EH, 74H, 20H, 62H, 61H       ; 0210 _ gment ba
        db 73H, 65H, 20H, 6DH, 75H, 6CH, 74H, 69H       ; 0218 _ se multi
        db 70H, 6CH, 69H, 65H, 72H, 00H, 00H, 00H       ; 0220 _ plier...

?_370:                                                  ; byte
        db 69H, 6EH, 76H, 61H, 6CH, 69H, 64H, 20H       ; 0228 _ invalid 
        db 65H, 66H, 66H, 65H, 63H, 74H, 69H, 76H       ; 0230 _ effectiv
        db 65H, 20H, 61H, 64H, 64H, 72H, 65H, 73H       ; 0238 _ e addres
        db 73H, 3AH, 20H, 62H, 61H, 64H, 20H, 73H       ; 0240 _ s: bad s
        db 75H, 62H, 65H, 78H, 70H, 72H, 65H, 73H       ; 0248 _ ubexpres
        db 73H, 69H, 6FH, 6EH, 20H, 74H, 79H, 70H       ; 0250 _ sion typ
        db 65H, 00H                                     ; 0258 _ e.

?_371:                                                  ; byte
        db 2EH, 2FH, 61H, 73H, 6DH, 2FH, 70H, 61H       ; 025A _ ./asm/pa
        db 72H, 73H, 65H, 72H, 2EH, 63H, 00H            ; 0262 _ rser.c.

?_372:                                                  ; byte
        db 69H, 20H, 3DH, 3DH, 20H, 2DH, 31H, 20H       ; 0269 _ i == -1 
        db 7CH, 7CH, 20H, 73H, 20H, 3EH, 20H, 30H       ; 0271 _ || s > 0
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H            ; 0279 _ .......

?_373:                                                  ; byte
        db 69H, 6DH, 70H, 6CH, 69H, 63H, 69H, 74H       ; 0280 _ implicit
        db 20H, 44H, 45H, 46H, 41H, 55H, 4CH, 54H       ; 0288 _  DEFAULT
        db 20H, 41H, 42H, 53H, 20H, 69H, 73H, 20H       ; 0290 _  ABS is 
        db 64H, 65H, 70H, 72H, 65H, 63H, 61H, 74H       ; 0298 _ deprecat
        db 65H, 64H, 00H, 00H, 00H, 00H, 00H, 00H       ; 02A0 _ ed......

?_374:                                                  ; byte
        db 65H, 78H, 70H, 65H, 63H, 74H, 65H, 64H       ; 02A8 _ expected
        db 20H, 60H, 29H, 27H, 20H, 61H, 66H, 74H       ; 02B0 _  `)' aft
        db 65H, 72H, 20H, 73H, 75H, 62H, 65H, 78H       ; 02B8 _ er subex
        db 70H, 72H, 65H, 73H, 73H, 69H, 6FH, 6EH       ; 02C0 _ pression
        db 2CH, 20H, 67H, 6FH, 74H, 20H, 25H, 73H       ; 02C8 _ , got %s
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 02D0 _ ........

?_375:                                                  ; byte
        db 25H, 73H, 20H, 6DH, 75H, 73H, 74H, 20H       ; 02D8 _ %s must 
        db 62H, 65H, 20H, 66H, 6FH, 6CH, 6CH, 6FH       ; 02E0 _ be follo
        db 77H, 65H, 64H, 20H, 62H, 79H, 20H, 61H       ; 02E8 _ wed by a
        db 20H, 73H, 74H, 72H, 69H, 6EH, 67H, 20H       ; 02F0 _  string 
        db 63H, 6FH, 6EH, 73H, 74H, 61H, 6EH, 74H       ; 02F8 _ constant
        db 2CH, 20H, 67H, 6FH, 74H, 20H, 25H, 73H       ; 0300 _ , got %s
        db 00H                                          ; 0308 _ .

?_376:                                                  ; byte
        db 69H, 6EH, 76H, 61H, 6CH, 69H, 64H, 20H       ; 0309 _ invalid 
        db 69H, 6EH, 70H, 75H, 74H, 20H, 73H, 74H       ; 0311 _ input st
        db 72H, 69H, 6EH, 67H, 20H, 74H, 6FH, 20H       ; 0319 _ ring to 
        db 25H, 73H, 00H                                ; 0321 _ %s.

?_377:                                                  ; byte
        db 75H, 6EH, 74H, 65H, 72H, 6DH, 69H, 6EH       ; 0324 _ untermin
        db 61H, 74H, 65H, 64H, 20H, 25H, 73H, 20H       ; 032C _ ated %s 
        db 66H, 75H, 6EH, 63H, 74H, 69H, 6FH, 6EH       ; 0334 _ function
        db 00H, 00H, 00H, 00H                           ; 033C _ ....

?_378:                                                  ; byte
        db 6EH, 6FH, 20H, 25H, 64H, 2DH, 62H, 69H       ; 0340 _ no %d-bi
        db 74H, 20H, 66H, 6CH, 6FH, 61H, 74H, 69H       ; 0348 _ t floati
        db 6EH, 67H, 2DH, 70H, 6FH, 69H, 6EH, 74H       ; 0350 _ ng-point
        db 20H, 66H, 6FH, 72H, 6DH, 61H, 74H, 20H       ; 0358 _  format 
        db 73H, 75H, 70H, 70H, 6FH, 72H, 74H, 65H       ; 0360 _ supporte
        db 64H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0368 _ d.......

?_379:                                                  ; byte
        db 66H, 6CH, 6FH, 61H, 74H, 69H, 6EH, 67H       ; 0370 _ floating
        db 2DH, 70H, 6FH, 69H, 6EH, 74H, 20H, 63H       ; 0378 _ -point c
        db 6FH, 6EH, 73H, 74H, 61H, 6EH, 74H, 20H       ; 0380 _ onstant 
        db 65H, 6EH, 63H, 6FH, 75H, 6EH, 74H, 65H       ; 0388 _ encounte
        db 72H, 65H, 64H, 20H, 69H, 6EH, 20H, 75H       ; 0390 _ red in u
        db 6EH, 6BH, 6EH, 6FH, 77H, 6EH, 20H, 69H       ; 0398 _ nknown i
        db 6EH, 73H, 74H, 72H, 75H, 63H, 74H, 69H       ; 03A0 _ nstructi
        db 6FH, 6EH, 00H, 00H, 00H, 00H, 00H, 00H       ; 03A8 _ on......

?_380:                                                  ; byte
        db 6EH, 6FH, 6EH, 2DH, 63H, 6FH, 6EH, 73H       ; 03B0 _ non-cons
        db 74H, 61H, 6EH, 74H, 20H, 61H, 72H, 67H       ; 03B8 _ tant arg
        db 75H, 6DH, 65H, 6EH, 74H, 20H, 73H, 75H       ; 03C0 _ ument su
        db 70H, 70H, 6CH, 69H, 65H, 64H, 20H, 74H       ; 03C8 _ pplied t
        db 6FH, 20H, 44H, 55H, 50H, 00H, 00H, 00H       ; 03D0 _ o DUP...

?_381:                                                  ; byte
        db 6EH, 65H, 67H, 61H, 74H, 69H, 76H, 65H       ; 03D8 _ negative
        db 20H, 61H, 72H, 67H, 75H, 6DH, 65H, 6EH       ; 03E0 _  argumen
        db 74H, 20H, 73H, 75H, 70H, 70H, 6CH, 69H       ; 03E8 _ t suppli
        db 65H, 64H, 20H, 74H, 6FH, 20H, 44H, 55H       ; 03F0 _ ed to DU
        db 50H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 03F8 _ P.......

?_382:                                                  ; byte
        db 65H, 78H, 70H, 72H, 65H, 73H, 73H, 69H       ; 0400 _ expressi
        db 6FH, 6EH, 20H, 69H, 73H, 20H, 6EH, 6FH       ; 0408 _ on is no
        db 74H, 20H, 73H, 69H, 6DH, 70H, 6CH, 65H       ; 0410 _ t simple
        db 20H, 6FH, 72H, 20H, 72H, 65H, 6CH, 6FH       ; 0418 _  or relo
        db 63H, 61H, 74H, 61H, 62H, 6CH, 65H, 00H       ; 0420 _ catable.

?_383:                                                  ; byte
        db 63H, 6FH, 6DH, 6DH, 61H, 20H, 65H, 78H       ; 0428 _ comma ex
        db 70H, 65H, 63H, 74H, 65H, 64H, 20H, 61H       ; 0430 _ pected a
        db 66H, 74H, 65H, 72H, 20H, 6FH, 70H, 65H       ; 0438 _ fter ope
        db 72H, 61H, 6EH, 64H, 2CH, 20H, 67H, 6FH       ; 0440 _ rand, go
        db 74H, 20H, 25H, 73H, 00H, 00H, 00H, 00H       ; 0448 _ t %s....

?_384:                                                  ; byte
        db 69H, 6EH, 73H, 74H, 72H, 75H, 63H, 74H       ; 0450 _ instruct
        db 69H, 6FH, 6EH, 20H, 68H, 61H, 73H, 20H       ; 0458 _ ion has 
        db 72H, 65H, 64H, 75H, 6EH, 64H, 61H, 6EH       ; 0460 _ redundan
        db 74H, 20H, 70H, 72H, 65H, 66H, 69H, 78H       ; 0468 _ t prefix
        db 65H, 73H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0470 _ es......

?_385:                                                  ; byte
        db 69H, 6EH, 73H, 74H, 72H, 75H, 63H, 74H       ; 0478 _ instruct
        db 69H, 6FH, 6EH, 20H, 68H, 61H, 73H, 20H       ; 0480 _ ion has 
        db 63H, 6FH, 6EH, 66H, 6CH, 69H, 63H, 74H       ; 0488 _ conflict
        db 69H, 6EH, 67H, 20H, 70H, 72H, 65H, 66H       ; 0490 _ ing pref
        db 69H, 78H, 65H, 73H, 00H, 00H, 00H, 00H       ; 0498 _ ixes....

?_386:                                                  ; byte
        db 6CH, 61H, 62H, 65H, 6CH, 20H, 60H, 25H       ; 04A0 _ label `%
        db 2AH, 73H, 27H, 20H, 61H, 6CH, 6FH, 6EH       ; 04A8 _ *s' alon
        db 65H, 20H, 6FH, 6EH, 20H, 61H, 20H, 6CH       ; 04B0 _ e on a l
        db 69H, 6EH, 65H, 20H, 77H, 69H, 74H, 68H       ; 04B8 _ ine with
        db 6FH, 75H, 74H, 20H, 61H, 20H, 63H, 6FH       ; 04C0 _ out a co
        db 6CH, 6FH, 6EH, 20H, 6DH, 69H, 67H, 68H       ; 04C8 _ lon migh
        db 74H, 20H, 62H, 65H, 20H, 69H, 6EH, 20H       ; 04D0 _ t be in 
        db 65H, 72H, 72H, 6FH, 72H, 00H, 00H, 00H       ; 04D8 _ error...

?_387:                                                  ; byte
        db 6EH, 6FH, 6EH, 2DH, 63H, 6FH, 6EH, 73H       ; 04E0 _ non-cons
        db 74H, 61H, 6EH, 74H, 20H, 61H, 72H, 67H       ; 04E8 _ tant arg
        db 75H, 6DH, 65H, 6EH, 74H, 20H, 73H, 75H       ; 04F0 _ ument su
        db 70H, 70H, 6CH, 69H, 65H, 64H, 20H, 74H       ; 04F8 _ pplied t
        db 6FH, 20H, 54H, 49H, 4DH, 45H, 53H, 00H       ; 0500 _ o TIMES.

?_388:                                                  ; byte
        db 20H, 00H                                     ; 0508 _  .

?_389:                                                  ; byte
        db 00H, 00H, 00H, 00H, 00H, 00H                 ; 050A _ ......

?_390:                                                  ; byte
        db 69H, 6EH, 73H, 74H, 72H, 75H, 63H, 74H       ; 0510 _ instruct
        db 69H, 6FH, 6EH, 20H, 65H, 78H, 70H, 65H       ; 0518 _ ion expe
        db 63H, 74H, 65H, 64H, 2CH, 20H, 66H, 6FH       ; 0520 _ cted, fo
        db 75H, 6EH, 64H, 20H, 60H, 25H, 73H, 25H       ; 0528 _ und `%s%
        db 73H, 25H, 2EH, 2AH, 73H, 27H, 00H, 00H       ; 0530 _ s%.*s'..

?_391:                                                  ; byte
        db 6CH, 61H, 62H, 65H, 6CH, 2CH, 20H, 69H       ; 0538 _ label, i
        db 6EH, 73H, 74H, 72H, 75H, 63H, 74H, 69H       ; 0540 _ nstructi
        db 6FH, 6EH, 20H, 6FH, 72H, 20H, 70H, 72H       ; 0548 _ on or pr
        db 65H, 66H, 69H, 78H, 20H, 65H, 78H, 70H       ; 0550 _ efix exp
        db 65H, 63H, 74H, 65H, 64H, 20H, 61H, 74H       ; 0558 _ ected at
        db 20H, 73H, 74H, 61H, 72H, 74H, 20H, 6FH       ; 0560 _  start o
        db 66H, 20H, 6CH, 69H, 6EH, 65H, 2CH, 20H       ; 0568 _ f line, 
        db 66H, 6FH, 75H, 6EH, 64H, 20H, 60H, 25H       ; 0570 _ found `%
        db 2EH, 2AH, 73H, 27H, 00H                      ; 0578 _ .*s'.

?_392:                                                  ; byte
        db 60H, 69H, 6EH, 63H, 62H, 69H, 6EH, 27H       ; 057D _ `incbin'
        db 20H, 65H, 78H, 70H, 65H, 63H, 74H, 73H       ; 0585 _  expects
        db 20H, 61H, 20H, 66H, 69H, 6CH, 65H, 20H       ; 058D _  a file 
        db 6EH, 61H, 6DH, 65H, 00H, 00H, 00H, 00H       ; 0595 _ name....
        db 00H, 00H, 00H                                ; 059D _ ...

?_393:                                                  ; byte
        db 60H, 69H, 6EH, 63H, 62H, 69H, 6EH, 27H       ; 05A0 _ `incbin'
        db 3AH, 20H, 73H, 65H, 63H, 6FH, 6EH, 64H       ; 05A8 _ : second
        db 20H, 70H, 61H, 72H, 61H, 6DH, 65H, 74H       ; 05B0 _  paramet
        db 65H, 72H, 20H, 69H, 73H, 20H, 6EH, 6FH       ; 05B8 _ er is no
        db 6EH, 2DH, 6EH, 75H, 6DH, 65H, 72H, 69H       ; 05C0 _ n-numeri
        db 63H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 05C8 _ c.......

?_394:                                                  ; byte
        db 60H, 69H, 6EH, 63H, 62H, 69H, 6EH, 27H       ; 05D0 _ `incbin'
        db 3AH, 20H, 74H, 68H, 69H, 72H, 64H, 20H       ; 05D8 _ : third 
        db 70H, 61H, 72H, 61H, 6DH, 65H, 74H, 65H       ; 05E0 _ paramete
        db 72H, 20H, 69H, 73H, 20H, 6EH, 6FH, 6EH       ; 05E8 _ r is non
        db 2DH, 6EH, 75H, 6DH, 65H, 72H, 69H, 63H       ; 05F0 _ -numeric
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 05F8 _ ........

?_395:                                                  ; byte
        db 60H, 69H, 6EH, 63H, 62H, 69H, 6EH, 27H       ; 0600 _ `incbin'
        db 3AH, 20H, 6DH, 6FH, 72H, 65H, 20H, 74H       ; 0608 _ : more t
        db 68H, 61H, 6EH, 20H, 74H, 68H, 72H, 65H       ; 0610 _ han thre
        db 65H, 20H, 70H, 61H, 72H, 61H, 6DH, 65H       ; 0618 _ e parame
        db 74H, 65H, 72H, 73H, 00H, 00H, 00H, 00H       ; 0620 _ ters....

?_396:                                                  ; byte
        db 6EH, 6FH, 20H, 6FH, 70H, 65H, 72H, 61H       ; 0628 _ no opera
        db 6EH, 64H, 20H, 66H, 6FH, 72H, 20H, 64H       ; 0630 _ nd for d
        db 61H, 74H, 61H, 20H, 64H, 65H, 63H, 6CH       ; 0638 _ ata decl
        db 61H, 72H, 61H, 74H, 69H, 6FH, 6EH, 00H       ; 0640 _ aration.

?_397:                                                  ; byte
        db 75H, 6EH, 6BH, 6EH, 6FH, 77H, 6EH, 20H       ; 0648 _ unknown 
        db 75H, 73H, 65H, 20H, 6FH, 66H, 20H, 46H       ; 0650 _ use of F
        db 4CH, 41H, 54H, 20H, 69H, 6EH, 20H, 4DH       ; 0658 _ LAT in M
        db 41H, 53H, 4DH, 20H, 65H, 6DH, 75H, 6CH       ; 0660 _ ASM emul
        db 61H, 74H, 69H, 6FH, 6EH, 00H                 ; 0668 _ ation.

?_398:                                                  ; byte
        db 69H, 6EH, 76H, 61H, 6CH, 69H, 64H, 20H       ; 066E _ invalid 
        db 73H, 65H, 67H, 6DH, 65H, 6EH, 74H, 20H       ; 0676 _ segment 
        db 6FH, 76H, 65H, 72H, 72H, 69H, 64H, 65H       ; 067E _ override
        db 00H, 00H                                     ; 0686 _ ..

?_399:                                                  ; byte
        db 69H, 6EH, 73H, 74H, 72H, 75H, 63H, 74H       ; 0688 _ instruct
        db 69H, 6FH, 6EH, 20H, 68H, 61H, 73H, 20H       ; 0690 _ ion has 
        db 63H, 6FH, 6EH, 66H, 6CH, 69H, 63H, 74H       ; 0698 _ conflict
        db 69H, 6EH, 67H, 20H, 73H, 65H, 67H, 6DH       ; 06A0 _ ing segm
        db 65H, 6EH, 74H, 20H, 6FH, 76H, 65H, 72H       ; 06A8 _ ent over
        db 72H, 69H, 64H, 65H, 73H, 00H                 ; 06B0 _ rides.

?_400:                                                  ; byte
        db 69H, 6EH, 76H, 61H, 6CH, 69H, 64H, 20H       ; 06B6 _ invalid 
        db 6DH, 69H, 62H, 20H, 65H, 78H, 70H, 72H       ; 06BE _ mib expr
        db 65H, 73H, 73H, 69H, 6FH, 6EH, 00H, 00H       ; 06C6 _ ession..
        db 00H, 00H                                     ; 06CE _ ..

?_401:                                                  ; byte
        db 65H, 78H, 70H, 65H, 63H, 74H, 69H, 6EH       ; 06D0 _ expectin
        db 67H, 20H, 5DH, 20H, 61H, 74H, 20H, 65H       ; 06D8 _ g ] at e
        db 6EH, 64H, 20H, 6FH, 66H, 20H, 6DH, 65H       ; 06E0 _ nd of me
        db 6DH, 6FH, 72H, 79H, 20H, 6FH, 70H, 65H       ; 06E8 _ mory ope
        db 72H, 61H, 6EH, 64H, 00H, 00H, 00H, 00H       ; 06F0 _ rand....

?_402:                                                  ; byte
        db 65H, 78H, 63H, 65H, 73H, 73H, 20H, 62H       ; 06F8 _ excess b
        db 72H, 61H, 63H, 6BH, 65H, 74H, 73H, 20H       ; 0700 _ rackets 
        db 69H, 6EH, 20H, 6DH, 65H, 6DH, 6FH, 72H       ; 0708 _ in memor
        db 79H, 20H, 6FH, 70H, 65H, 72H, 61H, 6EH       ; 0710 _ y operan
        db 64H, 00H                                     ; 0718 _ d.

?_403:                                                  ; byte
        db 75H, 6EH, 6DH, 61H, 74H, 63H, 68H, 65H       ; 071A _ unmatche
        db 64H, 20H, 5DH, 20H, 69H, 6EH, 20H, 6DH       ; 0722 _ d ] in m
        db 65H, 6DH, 6FH, 72H, 79H, 20H, 6FH, 70H       ; 072A _ emory op
        db 65H, 72H, 61H, 6EH, 64H, 00H                 ; 0732 _ erand.

?_404:                                                  ; byte
        db 63H, 6FH, 6DH, 6DH, 61H, 2CH, 20H, 64H       ; 0738 _ comma, d
        db 65H, 63H, 6FH, 72H, 61H, 74H, 6FH, 72H       ; 0740 _ ecorator
        db 20H, 6FH, 72H, 20H, 65H, 6EH, 64H, 20H       ; 0748 _  or end 
        db 6FH, 66H, 20H, 6CH, 69H, 6EH, 65H, 20H       ; 0750 _ of line 
        db 65H, 78H, 70H, 65H, 63H, 74H, 65H, 64H       ; 0758 _ expected
        db 2CH, 20H, 67H, 6FH, 74H, 20H, 60H, 25H       ; 0760 _ , got `%
        db 2AH, 73H, 27H, 00H, 00H, 00H, 00H, 00H       ; 0768 _ *s'.....

?_405:                                                  ; byte
        db 63H, 6FH, 6DH, 6DH, 61H, 2CH, 20H, 63H       ; 0770 _ comma, c
        db 6FH, 6CH, 6FH, 6EH, 2CH, 20H, 64H, 65H       ; 0778 _ olon, de
        db 63H, 6FH, 72H, 61H, 74H, 6FH, 72H, 20H       ; 0780 _ corator 
        db 6FH, 72H, 20H, 65H, 6EH, 64H, 20H, 6FH       ; 0788 _ or end o
        db 66H, 20H, 6CH, 69H, 6EH, 65H, 20H, 65H       ; 0790 _ f line e
        db 78H, 70H, 65H, 63H, 74H, 65H, 64H, 20H       ; 0798 _ xpected 
        db 61H, 66H, 74H, 65H, 72H, 20H, 6FH, 70H       ; 07A0 _ after op
        db 65H, 72H, 61H, 6EH, 64H, 00H, 00H, 00H       ; 07A8 _ erand...

?_406:                                                  ; byte
        db 69H, 6EH, 76H, 61H, 6CH, 69H, 64H, 20H       ; 07B0 _ invalid 
        db 75H, 73H, 65H, 20H, 6FH, 66H, 20H, 46H       ; 07B8 _ use of F
        db 41H, 52H, 20H, 6FH, 70H, 65H, 72H, 61H       ; 07C0 _ AR opera
        db 6EH, 64H, 20H, 73H, 70H, 65H, 63H, 69H       ; 07C8 _ nd speci
        db 66H, 69H, 65H, 72H, 00H, 00H, 00H, 00H       ; 07D0 _ fier....

?_407:                                                  ; byte
        db 73H, 69H, 7AH, 65H, 20H, 77H, 61H, 73H       ; 07D8 _ size was
        db 6EH, 27H, 74H, 20H, 73H, 70H, 65H, 63H       ; 07E0 _ n't spec
        db 69H, 66H, 69H, 65H, 64H, 2CH, 20H, 73H       ; 07E8 _ ified, s
        db 6FH, 6DH, 65H, 20H, 64H, 61H, 74H, 61H       ; 07F0 _ ome data
        db 20H, 6DH, 61H, 79H, 20H, 62H, 65H, 20H       ; 07F8 _  may be 
        db 6FH, 6DH, 69H, 74H, 74H, 65H, 64H, 00H       ; 0800 _ omitted.

?_408:                                                  ; byte
        db 69H, 6EH, 76H, 61H, 6CH, 69H, 64H, 20H       ; 0808 _ invalid 
        db 64H, 65H, 63H, 6FH, 72H, 61H, 74H, 6FH       ; 0810 _ decorato
        db 72H, 00H                                     ; 0818 _ r.

?_409:                                                  ; byte
        db 69H, 6EH, 76H, 61H, 6CH, 69H, 64H, 20H       ; 081A _ invalid 
        db 6FH, 70H, 65H, 72H, 61H, 6EH, 64H, 20H       ; 0822 _ operand 
        db 74H, 79H, 70H, 65H, 00H                      ; 082A _ type.

?_410:                                                  ; byte
        db 69H, 6EH, 76H, 61H, 6CH, 69H, 64H, 20H       ; 082F _ invalid 
        db 72H, 65H, 67H, 69H, 73H, 74H, 65H, 72H       ; 0837 _ register
        db 20H, 73H, 65H, 74H, 20H, 73H, 69H, 7AH       ; 083F _  set siz
        db 65H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0847 _ e.......
        db 00H                                          ; 084F _ .

?_411:                                                  ; byte
        db 69H, 6EH, 76H, 61H, 6CH, 69H, 64H, 20H       ; 0850 _ invalid 
        db 72H, 65H, 67H, 69H, 73H, 74H, 65H, 72H       ; 0858 _ register
        db 20H, 73H, 69H, 7AH, 65H, 20H, 73H, 70H       ; 0860 _  size sp
        db 65H, 63H, 69H, 66H, 69H, 63H, 61H, 74H       ; 0868 _ ecificat
        db 69H, 6FH, 6EH, 20H, 69H, 67H, 6EH, 6FH       ; 0870 _ ion igno
        db 72H, 65H, 64H, 00H, 00H, 00H, 00H, 00H       ; 0878 _ red.....

__func__.1:                                             ; oword
        db 6DH, 72H, 65H, 66H, 5FH, 73H, 65H, 74H       ; 0880 _ mref_set
        db 5FH, 6FH, 70H, 74H, 79H, 70H, 65H, 00H       ; 0888 _ _optype.


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
        dd is_class-$-20H                               ; 0020 _ 00000000 (rel)
        dd 0000001FH, 100E4100H                         ; 0024 _ 31 269369600 
        dd 0D430286H, 070C5A06H                         ; 002C _ 222495366 118249990 
        dd 00000008H, 0000001CH                         ; 0034 _ 8 28 
        dd 0000003CH                                    ; 003C _ 60 
        dd is_class-$-21H                               ; 0040 _ 00000000 (rel)
        dd 00000027H, 100E4100H                         ; 0044 _ 39 269369600 
        dd 0D430286H, 070C6206H                         ; 004C _ 222495366 118252038 
        dd 00000008H, 0000001CH                         ; 0054 _ 8 28 
        dd 0000005CH                                    ; 005C _ 92 
        dd is_class-$-1AH                               ; 0060 _ 00000000 (rel)
        dd 00000050H, 100E4100H                         ; 0064 _ 80 269369600 
        dd 0D430286H, 0C4B0206H                         ; 006C _ 222495366 206242310 
        dd 00000807H, 0000001CH                         ; 0074 _ 2055 28 
        dd 0000007CH                                    ; 007C _ 124 
        dd is_class-$+16H                               ; 0080 _ 00000000 (rel)
        dd 00000033H, 100E4100H                         ; 0084 _ 51 269369600 
        dd 0D430286H, 070C6E06H                         ; 008C _ 222495366 118255110 
        dd 00000008H, 0000001CH                         ; 0094 _ 8 28 
        dd 0000009CH                                    ; 009C _ 156 
        dd is_class-$+29H                               ; 00A0 _ 00000000 (rel)
        dd 0000000CH, 100E4100H                         ; 00A4 _ 12 269369600 
        dd 0D430286H, 070C4706H                         ; 00AC _ 222495366 118245126 
        dd 00000008H, 0000001CH                         ; 00B4 _ 8 28 
        dd 000000BCH                                    ; 00BC _ 188 
        dd is_class-$+15H                               ; 00C0 _ 00000000 (rel)
        dd 00000011H, 100E4100H                         ; 00C4 _ 17 269369600 
        dd 0D430286H, 070C4C06H                         ; 00CC _ 222495366 118246406 
        dd 00000008H, 0000001CH                         ; 00D4 _ 8 28 
        dd 000000DCH                                    ; 00DC _ 220 
        dd is_class-$+6H                                ; 00E0 _ 00000000 (rel)
        dd 00000011H, 100E4100H                         ; 00E4 _ 17 269369600 
        dd 0D430286H, 070C4C06H                         ; 00EC _ 222495366 118246406 
        dd 00000008H, 0000001CH                         ; 00F4 _ 8 28 
        dd 000000FCH                                    ; 00FC _ 252 
        dd is_class-$-9H                                ; 0100 _ 00000000 (rel)
        dd 0000000DH, 100E4100H                         ; 0104 _ 13 269369600 
        dd 0D430286H, 070C4806H                         ; 010C _ 222495366 118245382 
        dd 00000008H, 0000001CH                         ; 0114 _ 8 28 
        dd 0000011CH                                    ; 011C _ 284 
        dd is_class-$-1CH                               ; 0120 _ 00000000 (rel)
        dd 00000024H, 100E4100H                         ; 0124 _ 36 269369600 
        dd 0D430286H, 070C5F06H                         ; 012C _ 222495366 118251270 
        dd 00000008H, 0000001CH                         ; 0134 _ 8 28 
        dd 0000013CH                                    ; 013C _ 316 
        dd is_class-$-18H                               ; 0140 _ 00000000 (rel)
        dd 000000B9H, 100E4100H                         ; 0144 _ 185 269369600 
        dd 0D430286H, 0CB40206H                         ; 014C _ 222495366 213123590 
        dd 00000807H, 0000001CH                         ; 0154 _ 2055 28 
        dd 0000015CH                                    ; 015C _ 348 
        dd is_class-$+81H                               ; 0160 _ 00000000 (rel)
        dd 0000006BH, 100E4100H                         ; 0164 _ 107 269369600 
        dd 0D430286H, 0C660206H                         ; 016C _ 222495366 208011782 
        dd 00000807H, 0000001CH                         ; 0174 _ 2055 28 
        dd 0000017CH                                    ; 017C _ 380 
        dd is_class-$+0CCH                              ; 0180 _ 00000000 (rel)
        dd 00000349H, 100E4100H                         ; 0184 _ 841 269369600 
        dd 0D430286H, 03440306H                         ; 018C _ 222495366 54788870 
        dd 0008070CH, 0000001CH                         ; 0194 _ 526092 28 
        dd 0000019CH                                    ; 019C _ 412 
        dd is_class-$+3F5H                              ; 01A0 _ 00000000 (rel)
        dd 0000019FH, 100E4100H                         ; 01A4 _ 415 269369600 
        dd 0D430286H, 019A0306H                         ; 01AC _ 222495366 26870534 
        dd 0008070CH, 0000001CH                         ; 01B4 _ 526092 28 
        dd 000001BCH                                    ; 01BC _ 444 
        dd is_class-$+574H                              ; 01C0 _ 00000000 (rel)
        dd 00000060H, 100E4100H                         ; 01C4 _ 96 269369600 
        dd 0D430286H, 0C5B0206H                         ; 01CC _ 222495366 207290886 
        dd 00000807H, 0000001CH                         ; 01D4 _ 2055 28 
        dd 000001DCH                                    ; 01DC _ 476 
        dd is_class-$+5B4H                              ; 01E0 _ 00000000 (rel)
        dd 000002BBH, 100E4100H                         ; 01E4 _ 699 269369600 
        dd 0D430286H, 02B60306H                         ; 01EC _ 222495366 45482758 
        dd 0008070CH, 0000001CH                         ; 01F4 _ 526092 28 
        dd 000001FCH                                    ; 01FC _ 508 
        dd is_class-$+84FH                              ; 0200 _ 00000000 (rel)
        dd 000002D9H, 100E4100H                         ; 0204 _ 729 269369600 
        dd 0D430286H, 02D40306H                         ; 020C _ 222495366 47448838 
        dd 0008070CH, 0000001CH                         ; 0214 _ 526092 28 
        dd 0000021CH                                    ; 021C _ 540 
        dd is_class-$+0B08H                             ; 0220 _ 00000000 (rel)
        dd 0000018AH, 100E4100H                         ; 0224 _ 394 269369600 
        dd 0D430286H, 01850306H                         ; 022C _ 222495366 25494278 
        dd 0008070CH, 0000001CH                         ; 0234 _ 526092 28 
        dd 0000023CH                                    ; 023C _ 572 
        dd is_class-$+0C72H                             ; 0240 _ 00000000 (rel)
        dd 000009B3H, 100E4100H                         ; 0244 _ 2483 269369600 
        dd 0D430286H, 09AE0306H                         ; 024C _ 222495366 162398982 
        dd 0008070CH, 0000001CH                         ; 0254 _ 526092 28 
        dd 0000025CH                                    ; 025C _ 604 
        dd is_class-$+1605H                             ; 0260 _ 00000000 (rel)
        dd 00000154H, 100E4100H                         ; 0264 _ 340 269369600 
        dd 0D430286H, 014F0306H                         ; 026C _ 222495366 21955334 
        dd 0008070CH, 0000001CH                         ; 0274 _ 526092 28 
        dd 0000027CH                                    ; 027C _ 636 
        dd is_class-$+1739H                             ; 0280 _ 00000000 (rel)
        dd 0000023CH, 100E4100H                         ; 0284 _ 572 269369600 
        dd 0D430286H, 02370306H                         ; 028C _ 222495366 37159686 
        dd 0008070CH, 0000001CH                         ; 0294 _ 526092 28 
        dd 0000029CH                                    ; 029C _ 668 
        dd is_class-$+1955H                             ; 02A0 _ 00000000 (rel)
        dd 00001F45H, 100E4100H                         ; 02A4 _ 8005 269369600 
        dd 0D430286H, 1F400306H                         ; 02AC _ 222495366 524288774 
        dd 0008070CH, 0000001CH                         ; 02B4 _ 526092 28 
        dd 000002BCH                                    ; 02BC _ 700 
        dd is_class-$+387AH                             ; 02C0 _ 00000000 (rel)
        dd 0000007AH, 100E4100H                         ; 02C4 _ 122 269369600 
        dd 0D430286H, 0C750206H                         ; 02CC _ 222495366 208994822 
        dd 00000807H, 0000001CH                         ; 02D4 _ 2055 28 
        dd 000002DCH                                    ; 02DC _ 732 
        dd is_class-$+38D4H                             ; 02E0 _ 00000000 (rel)
        dd 0000006EH, 100E4100H                         ; 02E4 _ 110 269369600 
        dd 0D430286H, 0C690206H                         ; 02EC _ 222495366 208208390 
        dd 00000807H, 0000001CH                         ; 02F4 _ 2055 28 
        dd 000002FCH                                    ; 02FC _ 764 
        dd is_class-$+3922H                             ; 0300 _ 00000000 (rel)
        dd 0000001FH, 100E4100H                         ; 0304 _ 31 269369600 
        dd 0D430286H, 070C5A06H                         ; 030C _ 222495366 118249990 
        dd 00000008H                                    ; 0314 _ 8 


