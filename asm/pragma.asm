; Disassembly of file: /tmp/tmp.mYGPrAyOOW.o
; Wed Sep 23 14:43:28 2026
; Type: ELF64
; Syntax: NASM
; Instruction set: 80386, x64

default rel

global process_pragma: function

extern nasm_set_limit                                   ; near
extern dfmt                                             ; qword
extern set_label_mangle                                 ; near
extern ofmt                                             ; qword
extern strlen                                           ; near
extern nasm_zap_spaces_fwd                              ; near
extern nasm_get_word                                    ; near
extern memset                                           ; near
extern __stack_chk_fail                                 ; near
extern nasm_panic_from_macro                            ; near
extern nasm_error                                       ; near
extern nasm_warn_                                       ; near
extern strcasecmp                                       ; near
extern list_pragma                                      ; byte
extern warning_state                                    ; byte
extern erropt                                           ; dword
extern perfhash_find                                    ; near
extern directive_hash                                   ; byte
extern nasm_ctype_tab                                   ; byte


SECTION .text   align=1 exec                            ; section number 1, code

nasm_ctype:; Local function
        push    rbp                                     ; 0000 _ 55
        mov     rbp, rsp                                ; 0001 _ 48: 89. E5
        mov     byte [rbp-1H], dil                      ; 0004 _ 40: 88. 7D, FF
        mov     dword [rbp-8H], esi                     ; 0008 _ 89. 75, F8
        movzx   eax, byte [rbp-1H]                      ; 000B _ 0F B6. 45, FF
        cdqe                                            ; 000F _ 48: 98
        lea     rdx, [rax+rax]                          ; 0011 _ 48: 8D. 14 00
        lea     rax, [rel nasm_ctype_tab]               ; 0015 _ 48: 8D. 05, 00000000(rel)
        movzx   eax, word [rdx+rax]                     ; 001C _ 0F B7. 04 02
        movzx   eax, ax                                 ; 0020 _ 0F B7. C0
        and     eax, dword [rbp-8H]                     ; 0023 _ 23. 45, F8
        test    eax, eax                                ; 0026 _ 85. C0
        setne   al                                      ; 0028 _ 0F 95. C0
        pop     rbp                                     ; 002B _ 5D
        ret                                             ; 002C _ C3

nasm_isspace:; Local function
        push    rbp                                     ; 002D _ 55
        mov     rbp, rsp                                ; 002E _ 48: 89. E5
        sub     rsp, 8                                  ; 0031 _ 48: 83. EC, 08
        mov     byte [rbp-1H], dil                      ; 0035 _ 40: 88. 7D, FF
        movzx   eax, byte [rbp-1H]                      ; 0039 _ 0F B6. 45, FF
        movzx   eax, al                                 ; 003D _ 0F B6. C0
        mov     esi, 2                                  ; 0040 _ BE, 00000002
        mov     edi, eax                                ; 0045 _ 89. C7
        call    nasm_ctype                              ; 0047 _ E8, FFFFFFB4
        leave                                           ; 004C _ C9
        ret                                             ; 004D _ C3

directive_find:; Local function
        push    rbp                                     ; 004E _ 55
        mov     rbp, rsp                                ; 004F _ 48: 89. E5
        sub     rsp, 16                                 ; 0052 _ 48: 83. EC, 10
        mov     qword [rbp-8H], rdi                     ; 0056 _ 48: 89. 7D, F8
        mov     rax, qword [rbp-8H]                     ; 005A _ 48: 8B. 45, F8
        lea     rdx, [rel directive_hash]               ; 005E _ 48: 8D. 15, 00000000(rel)
        mov     rsi, rax                                ; 0065 _ 48: 89. C6
        mov     rdi, rdx                                ; 0068 _ 48: 89. D7
        call    perfhash_find                           ; 006B _ E8, 00000000(PLT r)
        leave                                           ; 0070 _ C9
        ret                                             ; 0071 _ C3

warn_active:; Local function
        push    rbp                                     ; 0072 _ 55
        mov     rbp, rsp                                ; 0073 _ 48: 89. E5
        mov     dword [rbp-4H], edi                     ; 0076 _ 89. 7D, FC
        mov     eax, dword [rel erropt+0CH]             ; 0079 _ 8B. 05, 00000000(rel)
        and     eax, dword [rbp-4H]                     ; 007F _ 23. 45, FC
        test    eax, eax                                ; 0082 _ 85. C0
        jz      ?_001                                   ; 0084 _ 74, 07
        mov     eax, 0                                  ; 0086 _ B8, 00000000
        jmp     ?_002                                   ; 008B _ EB, 16

?_001:  mov     eax, dword [rbp-4H]                     ; 008D _ 8B. 45, FC
        shr     eax, 16                                 ; 0090 _ C1. E8, 10
        mov     edx, eax                                ; 0093 _ 89. C2
        lea     rax, [rel warning_state]                ; 0095 _ 48: 8D. 05, 00000000(rel)
        movzx   eax, byte [rdx+rax]                     ; 009C _ 0F B6. 04 02
        and     eax, 01H                                ; 00A0 _ 83. E0, 01
?_002:  pop     rbp                                     ; 00A3 _ 5D
        ret                                             ; 00A4 _ C3

call_pragma:; Local function
        push    rbp                                     ; 00A5 _ 55
        mov     rbp, rsp                                ; 00A6 _ 48: 89. E5
        sub     rsp, 16                                 ; 00A9 _ 48: 83. EC, 10
        mov     qword [rbp-8H], rdi                     ; 00AD _ 48: 89. 7D, F8
        mov     qword [rbp-10H], rsi                    ; 00B1 _ 48: 89. 75, F0
        cmp     qword [rbp-8H], 0                       ; 00B5 _ 48: 83. 7D, F8, 00
        jz      ?_003                                   ; 00BA _ 74, 0D
        mov     rax, qword [rbp-8H]                     ; 00BC _ 48: 8B. 45, F8
        mov     rax, qword [rax+8H]                     ; 00C0 _ 48: 8B. 40, 08
        test    rax, rax                                ; 00C4 _ 48: 85. C0
        jnz     ?_004                                   ; 00C7 _ 75, 07
?_003:  mov     eax, 0                                  ; 00C9 _ B8, 00000000
        jmp     ?_005                                   ; 00CE _ EB, 1C

?_004:  mov     rax, qword [rbp-10H]                    ; 00D0 _ 48: 8B. 45, F0
        mov     rdx, qword [rbp-8H]                     ; 00D4 _ 48: 8B. 55, F8
        mov     qword [rax], rdx                        ; 00D8 _ 48: 89. 10
        mov     rax, qword [rbp-8H]                     ; 00DB _ 48: 8B. 45, F8
        mov     rdx, qword [rax+8H]                     ; 00DF _ 48: 8B. 50, 08
        mov     rax, qword [rbp-10H]                    ; 00E3 _ 48: 8B. 45, F0
        mov     rdi, rax                                ; 00E7 _ 48: 89. C7
        call    rdx                                     ; 00EA _ FF. D2
?_005:  leave                                           ; 00EC _ C9
        ret                                             ; 00ED _ C3

search_pragma_list:; Local function
        push    rbp                                     ; 00EE _ 55
        mov     rbp, rsp                                ; 00EF _ 48: 89. E5
        push    rbx                                     ; 00F2 _ 53
        sub     rsp, 120                                ; 00F3 _ 48: 83. EC, 78
        mov     qword [rbp-68H], rdi                    ; 00F7 _ 48: 89. 7D, 98
        mov     qword [rbp-70H], rsi                    ; 00FB _ 48: 89. 75, 90
        mov     qword [rbp-78H], rdx                    ; 00FF _ 48: 89. 55, 88
        mov     qword [rbp-80H], rcx                    ; 0103 _ 48: 89. 4D, 80
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        mov     rax, qword [fs:abs 28H]                 ; 0107 _ 64 48: 8B. 04 25, 00000028
        mov     qword [rbp-18H], rax                    ; 0110 _ 48: 89. 45, E8
        xor     eax, eax                                ; 0114 _ 31. C0
        mov     qword [rbp-50H], 0                      ; 0116 _ 48: C7. 45, B0, 00000000
        mov     rax, qword [rbp-80H]                    ; 011E _ 48: 8B. 45, 80
        mov     rcx, qword [rax]                        ; 0122 _ 48: 8B. 08
        mov     rbx, qword [rax+8H]                     ; 0125 _ 48: 8B. 58, 08
        mov     qword [rbp-40H], rcx                    ; 0129 _ 48: 89. 4D, C0
        mov     qword [rbp-38H], rbx                    ; 012D _ 48: 89. 5D, C8
        mov     rcx, qword [rax+10H]                    ; 0131 _ 48: 8B. 48, 10
        mov     rbx, qword [rax+18H]                    ; 0135 _ 48: 8B. 58, 18
        mov     qword [rbp-30H], rcx                    ; 0139 _ 48: 89. 4D, D0
        mov     qword [rbp-28H], rbx                    ; 013D _ 48: 89. 5D, D8
        mov     rax, qword [rax+20H]                    ; 0141 _ 48: 8B. 40, 20
        mov     qword [rbp-20H], rax                    ; 0145 _ 48: 89. 45, E0
        mov     rax, qword [rbp-38H]                    ; 0149 _ 48: 8B. 45, C8
        mov     qword [rbp-48H], rax                    ; 014D _ 48: 89. 45, B8
        cmp     qword [rbp-78H], 0                      ; 0151 _ 48: 83. 7D, 88, 00
        jz      ?_006                                   ; 0156 _ 74, 2D
        mov     rax, qword [rbp-78H]                    ; 0158 _ 48: 8B. 45, 88
        mov     rax, qword [rax]                        ; 015C _ 48: 8B. 00
        test    rax, rax                                ; 015F _ 48: 85. C0
        jz      ?_006                                   ; 0162 _ 74, 21
        mov     rax, qword [rbp-78H]                    ; 0164 _ 48: 8B. 45, 88
        mov     rdx, qword [rax]                        ; 0168 _ 48: 8B. 10
        mov     rax, qword [rbp-48H]                    ; 016B _ 48: 8B. 45, B8
        mov     rsi, rdx                                ; 016F _ 48: 89. D6
        mov     rdi, rax                                ; 0172 _ 48: 89. C7
        call    strcasecmp                              ; 0175 _ E8, 00000000(PLT r)
        test    eax, eax                                ; 017A _ 85. C0
        jnz     ?_006                                   ; 017C _ 75, 07
        mov     eax, 1                                  ; 017E _ B8, 00000001
        jmp     ?_007                                   ; 0183 _ EB, 05

?_006:  mov     eax, 0                                  ; 0185 _ B8, 00000000
?_007:  mov     byte [rbp-5DH], al                      ; 018A _ 88. 45, A3
        and     byte [rbp-5DH], 01H                     ; 018D _ 80. 65, A3, 01
        movzx   eax, byte [rbp-5DH]                     ; 0191 _ 0F B6. 45, A3
        mov     byte [rbp-5EH], al                      ; 0195 _ 88. 45, A2
        cmp     qword [rbp-70H], 0                      ; 0198 _ 48: 83. 7D, 90, 00
        jz      ?_009                                   ; 019D _ 74, 2B
        cmp     byte [rbp-5DH], 0                       ; 019F _ 80. 7D, A3, 00
        jz      ?_008                                   ; 01A3 _ 74, 0A
        mov     rax, qword [rbp-70H]                    ; 01A5 _ 48: 8B. 45, 90
        mov     qword [rbp-48H], rax                    ; 01A9 _ 48: 89. 45, B8
        jmp     ?_009                                   ; 01AD _ EB, 1B

?_008:  mov     rdx, qword [rbp-70H]                    ; 01AF _ 48: 8B. 55, 90
        mov     rax, qword [rbp-48H]                    ; 01B3 _ 48: 8B. 45, B8
        mov     rsi, rdx                                ; 01B7 _ 48: 89. D6
        mov     rdi, rax                                ; 01BA _ 48: 89. C7
        call    strcasecmp                              ; 01BD _ E8, 00000000(PLT r)
        test    eax, eax                                ; 01C2 _ 85. C0
        sete    al                                      ; 01C4 _ 0F 94. C0
        mov     byte [rbp-5EH], al                      ; 01C7 _ 88. 45, A2
?_009:  cmp     qword [rbp-48H], 0                      ; 01CA _ 48: 83. 7D, B8, 00
        jz      ?_013                                   ; 01CF _ 74, 7E
        cmp     qword [rbp-68H], 0                      ; 01D1 _ 48: 83. 7D, 98, 00
        jz      ?_013                                   ; 01D6 _ 74, 77
        mov     rax, qword [rbp-68H]                    ; 01D8 _ 48: 8B. 45, 98
        mov     qword [rbp-50H], rax                    ; 01DC _ 48: 89. 45, B0
        jmp     ?_012                                   ; 01E0 _ EB, 3F

?_010:  mov     rax, qword [rbp-50H]                    ; 01E2 _ 48: 8B. 45, B0
        mov     rdx, qword [rax]                        ; 01E6 _ 48: 8B. 10
        mov     rax, qword [rbp-48H]                    ; 01E9 _ 48: 8B. 45, B8
        mov     rsi, rdx                                ; 01ED _ 48: 89. D6
        mov     rdi, rax                                ; 01F0 _ 48: 89. C7
        call    strcasecmp                              ; 01F3 _ E8, 00000000(PLT r)
        test    eax, eax                                ; 01F8 _ 85. C0
        jnz     ?_011                                   ; 01FA _ 75, 20
        mov     byte [rbp-5EH], 1                       ; 01FC _ C6. 45, A2, 01
        lea     rdx, [rbp-40H]                          ; 0200 _ 48: 8D. 55, C0
        mov     rax, qword [rbp-50H]                    ; 0204 _ 48: 8B. 45, B0
        mov     rsi, rdx                                ; 0208 _ 48: 89. D6
        mov     rdi, rax                                ; 020B _ 48: 89. C7
        call    call_pragma                             ; 020E _ E8, FFFFFE92
        mov     dword [rbp-5CH], eax                    ; 0213 _ 89. 45, A4
        cmp     dword [rbp-5CH], 0                      ; 0216 _ 83. 7D, A4, 00
        jnz     ?_015                                   ; 021A _ 75, 5B
?_011:  add     qword [rbp-50H], 16                     ; 021C _ 48: 83. 45, B0, 10
?_012:  mov     rax, qword [rbp-50H]                    ; 0221 _ 48: 8B. 45, B0
        mov     rax, qword [rax]                        ; 0225 _ 48: 8B. 00
        test    rax, rax                                ; 0228 _ 48: 85. C0
        jnz     ?_010                                   ; 022B _ 75, B5
        cmp     byte [rbp-5EH], 0                       ; 022D _ 80. 7D, A2, 00
        jz      ?_013                                   ; 0231 _ 74, 1C
        lea     rdx, [rbp-40H]                          ; 0233 _ 48: 8D. 55, C0
        mov     rax, qword [rbp-50H]                    ; 0237 _ 48: 8B. 45, B0
        mov     rsi, rdx                                ; 023B _ 48: 89. D6
        mov     rdi, rax                                ; 023E _ 48: 89. C7
        call    call_pragma                             ; 0241 _ E8, FFFFFE5F
        mov     dword [rbp-5CH], eax                    ; 0246 _ 89. 45, A4
        cmp     dword [rbp-5CH], 0                      ; 0249 _ 83. 7D, A4, 00
        jnz     ?_016                                   ; 024D _ 75, 2B
?_013:  cmp     byte [rbp-5EH], 0                       ; 024F _ 80. 7D, A2, 00
        jz      ?_014                                   ; 0253 _ 74, 18
        lea     rdx, [rbp-40H]                          ; 0255 _ 48: 8D. 55, C0
        mov     rax, qword [rbp-78H]                    ; 0259 _ 48: 8B. 45, 88
        mov     rsi, rdx                                ; 025D _ 48: 89. D6
        mov     rdi, rax                                ; 0260 _ 48: 89. C7
        call    call_pragma                             ; 0263 _ E8, FFFFFE3D
        mov     dword [rbp-5CH], eax                    ; 0268 _ 89. 45, A4
        jmp     ?_017                                   ; 026B _ EB, 0E

?_014:  mov     eax, 0                                  ; 026D _ B8, 00000000
        jmp     ?_026                                   ; 0272 _ E9, 000000FE

?_015:  nop                                             ; 0277 _ 90
        jmp     ?_017                                   ; 0278 _ EB, 01

?_016:  nop                                             ; 027A _ 90
?_017:  cmp     dword [rbp-5CH], 3                      ; 027B _ 83. 7D, A4, 03
        je      ?_023                                   ; 027F _ 0F 84, 000000A9
        cmp     dword [rbp-5CH], 3                      ; 0285 _ 83. 7D, A4, 03
        ja      ?_024                                   ; 0289 _ 0F 87, 000000C5
        cmp     dword [rbp-5CH], 0                      ; 028F _ 83. 7D, A4, 00
        jz      ?_018                                   ; 0293 _ 74, 14
        mov     eax, dword [rbp-5CH]                    ; 0295 _ 8B. 45, A4
        sub     eax, 1                                  ; 0298 _ 83. E8, 01
        cmp     eax, 1                                  ; 029B _ 83. F8, 01
        ja      ?_024                                   ; 029E _ 0F 87, 000000B0
        jmp     ?_025                                   ; 02A4 _ E9, 000000C9

?_018:  mov     eax, dword [rbp-20H]                    ; 02A9 _ 8B. 45, E0
        test    eax, eax                                ; 02AC _ 85. C0
        jnz     ?_019                                   ; 02AE _ 75, 38
        mov     dword [rbp-58H], 2556160                ; 02B0 _ C7. 45, A8, 00270100
        mov     eax, dword [rbp-58H]                    ; 02B7 _ 8B. 45, A8
        mov     edi, eax                                ; 02BA _ 89. C7
        call    warn_active                             ; 02BC _ E8, FFFFFDB1
        movzx   eax, al                                 ; 02C1 _ 0F B6. C0
        test    rax, rax                                ; 02C4 _ 48: 85. C0
        jz      ?_020                                   ; 02C7 _ 74, 58
        mov     rdx, qword [rbp-38H]                    ; 02C9 _ 48: 8B. 55, C8
        lea     rcx, [rel ?_043]                        ; 02CD _ 48: 8D. 0D, 00000000(rel)
        mov     eax, dword [rbp-58H]                    ; 02D4 _ 8B. 45, A8
        mov     rsi, rcx                                ; 02D7 _ 48: 89. CE
        mov     edi, eax                                ; 02DA _ 89. C7
        mov     eax, 0                                  ; 02DC _ B8, 00000000
        call    nasm_warn_                              ; 02E1 _ E8, 00000000(PLT r)
        jmp     ?_020                                   ; 02E6 _ EB, 39

?_019:  mov     dword [rbp-54H], 2752768                ; 02E8 _ C7. 45, AC, 002A0100
        mov     eax, dword [rbp-54H]                    ; 02EF _ 8B. 45, AC
        mov     edi, eax                                ; 02F2 _ 89. C7
        call    warn_active                             ; 02F4 _ E8, FFFFFD79
        movzx   eax, al                                 ; 02F9 _ 0F B6. C0
        test    rax, rax                                ; 02FC _ 48: 85. C0
        jz      ?_021                                   ; 02FF _ 74, 23
        mov     rcx, qword [rbp-30H]                    ; 0301 _ 48: 8B. 4D, D0
        mov     rdx, qword [rbp-38H]                    ; 0305 _ 48: 8B. 55, C8
        lea     rsi, [rel ?_044]                        ; 0309 _ 48: 8D. 35, 00000000(rel)
        mov     eax, dword [rbp-54H]                    ; 0310 _ 8B. 45, AC
        mov     edi, eax                                ; 0313 _ 89. C7
        mov     eax, 0                                  ; 0315 _ B8, 00000000
        call    nasm_warn_                              ; 031A _ E8, 00000000(PLT r)
        jmp     ?_021                                   ; 031F _ EB, 03

?_020:  nop                                             ; 0321 _ 90
        jmp     ?_022                                   ; 0322 _ EB, 01

?_021:  nop                                             ; 0324 _ 90
?_022:  mov     dword [rbp-5CH], 2                      ; 0325 _ C7. 45, A4, 00000002
        jmp     ?_025                                   ; 032C _ EB, 44

?_023:  mov     rdx, qword [rbp-30H]                    ; 032E _ 48: 8B. 55, D0
        mov     rax, qword [rbp-38H]                    ; 0332 _ 48: 8B. 45, C8
        lea     rsi, [rel ?_045]                        ; 0336 _ 48: 8D. 35, 00000000(rel)
        mov     rcx, rdx                                ; 033D _ 48: 89. D1
        mov     rdx, rax                                ; 0340 _ 48: 89. C2
        mov     edi, 8                                  ; 0343 _ BF, 00000008
        mov     eax, 0                                  ; 0348 _ B8, 00000000
        call    nasm_error                              ; 034D _ E8, 00000000(PLT r)
        jmp     ?_025                                   ; 0352 _ EB, 1E

?_024:  lea     rcx, [rel ?_046]                        ; 0354 _ 48: 8D. 0D, 00000000(rel)
        lea     rax, [rel __func__.2]                   ; 035B _ 48: 8D. 05, 00000000(rel)
        mov     edx, 191                                ; 0362 _ BA, 000000BF
        mov     rsi, rcx                                ; 0367 _ 48: 89. CE
        mov     rdi, rax                                ; 036A _ 48: 89. C7
        call    nasm_panic_from_macro                   ; 036D _ E8, 00000000(PLT r)
?_025:  mov     eax, dword [rbp-5CH]                    ; 0372 _ 8B. 45, A4
?_026:  mov     rdx, qword [rbp-18H]                    ; 0375 _ 48: 8B. 55, E8
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        sub     rdx, qword [fs:abs 28H]                 ; 0379 _ 64 48: 2B. 14 25, 00000028
        jz      ?_027                                   ; 0382 _ 74, 05
        call    __stack_chk_fail                        ; 0384 _ E8, 00000000(PLT r)
?_027:  mov     rbx, qword [rbp-8H]                     ; 0389 _ 48: 8B. 5D, F8
        leave                                           ; 038D _ C9
        ret                                             ; 038E _ C3

process_pragma:; Function begin
        push    rbp                                     ; 038F _ 55
        mov     rbp, rsp                                ; 0390 _ 48: 89. E5
        push    rbx                                     ; 0393 _ 53
        sub     rsp, 104                                ; 0394 _ 48: 83. EC, 68
        mov     qword [rbp-68H], rdi                    ; 0398 _ 48: 89. 7D, 98
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        mov     rax, qword [fs:abs 28H]                 ; 039C _ 64 48: 8B. 04 25, 00000028
        mov     qword [rbp-18H], rax                    ; 03A5 _ 48: 89. 45, E8
        xor     eax, eax                                ; 03A9 _ 31. C0
        lea     rax, [rbp-40H]                          ; 03AB _ 48: 8D. 45, C0
        mov     edx, 40                                 ; 03AF _ BA, 00000028
        mov     esi, 0                                  ; 03B4 _ BE, 00000000
        mov     rdi, rax                                ; 03B9 _ 48: 89. C7
        call    memset                                  ; 03BC _ E8, 00000000(PLT r)
        lea     rdx, [rbp-50H]                          ; 03C1 _ 48: 8D. 55, B0
        mov     rax, qword [rbp-68H]                    ; 03C5 _ 48: 8B. 45, 98
        mov     rsi, rdx                                ; 03C9 _ 48: 89. D6
        mov     rdi, rax                                ; 03CC _ 48: 89. C7
        call    nasm_get_word                           ; 03CF _ E8, 00000000(PLT r)
        mov     qword [rbp-38H], rax                    ; 03D4 _ 48: 89. 45, C8
        mov     rax, qword [rbp-38H]                    ; 03D8 _ 48: 8B. 45, C8
        test    rax, rax                                ; 03DC _ 48: 85. C0
        jnz     ?_028                                   ; 03DF _ 75, 3B
        mov     dword [rbp-54H], 2621696                ; 03E1 _ C7. 45, AC, 00280100
        mov     eax, dword [rbp-54H]                    ; 03E8 _ 8B. 45, AC
        mov     edi, eax                                ; 03EB _ 89. C7
        call    warn_active                             ; 03ED _ E8, FFFFFC80
        movzx   eax, al                                 ; 03F2 _ 0F B6. C0
        test    rax, rax                                ; 03F5 _ 48: 85. C0
        je      ?_036                                   ; 03F8 _ 0F 84, 0000011F
        lea     rdx, [rel ?_047]                        ; 03FE _ 48: 8D. 15, 00000000(rel)
        mov     eax, dword [rbp-54H]                    ; 0405 _ 8B. 45, AC
        mov     rsi, rdx                                ; 0408 _ 48: 89. D6
        mov     edi, eax                                ; 040B _ 89. C7
        mov     eax, 0                                  ; 040D _ B8, 00000000
        call    nasm_warn_                              ; 0412 _ E8, 00000000(PLT r)
        jmp     ?_036                                   ; 0417 _ E9, 00000101

?_028:  mov     rax, qword [rbp-50H]                    ; 041C _ 48: 8B. 45, B0
        lea     rdx, [rbp-50H]                          ; 0420 _ 48: 8D. 55, B0
        mov     rsi, rdx                                ; 0424 _ 48: 89. D6
        mov     rdi, rax                                ; 0427 _ 48: 89. C7
        call    nasm_get_word                           ; 042A _ E8, 00000000(PLT r)
        mov     qword [rbp-30H], rax                    ; 042F _ 48: 89. 45, D0
        mov     rax, qword [rbp-30H]                    ; 0433 _ 48: 8B. 45, D0
        test    rax, rax                                ; 0437 _ 48: 85. C0
        jnz     ?_029                                   ; 043A _ 75, 09
        mov     dword [rbp-20H], 0                      ; 043C _ C7. 45, E0, 00000000
        jmp     ?_030                                   ; 0443 _ EB, 0F

?_029:  mov     rax, qword [rbp-30H]                    ; 0445 _ 48: 8B. 45, D0
        mov     rdi, rax                                ; 0449 _ 48: 89. C7
        call    directive_find                          ; 044C _ E8, FFFFFBFD
        mov     dword [rbp-20H], eax                    ; 0451 _ 89. 45, E0
?_030:  mov     rax, qword [rbp-50H]                    ; 0454 _ 48: 8B. 45, B0
        mov     rdi, rax                                ; 0458 _ 48: 89. C7
        call    nasm_zap_spaces_fwd                     ; 045B _ E8, 00000000(PLT r)
        mov     qword [rbp-50H], rax                    ; 0460 _ 48: 89. 45, B0
        mov     rax, qword [rbp-50H]                    ; 0464 _ 48: 8B. 45, B0
        mov     qword [rbp-28H], rax                    ; 0468 _ 48: 89. 45, D8
        mov     rbx, qword [rbp-50H]                    ; 046C _ 48: 8B. 5D, B0
        mov     rax, qword [rbp-50H]                    ; 0470 _ 48: 8B. 45, B0
        mov     rdi, rax                                ; 0474 _ 48: 89. C7
        call    strlen                                  ; 0477 _ E8, 00000000(PLT r)
        add     rax, rbx                                ; 047C _ 48: 01. D8
        mov     qword [rbp-50H], rax                    ; 047F _ 48: 89. 45, B0
        jmp     ?_032                                   ; 0483 _ EB, 13

?_031:  mov     rax, qword [rbp-50H]                    ; 0485 _ 48: 8B. 45, B0
        sub     rax, 1                                  ; 0489 _ 48: 83. E8, 01
        mov     qword [rbp-50H], rax                    ; 048D _ 48: 89. 45, B0
        mov     rax, qword [rbp-50H]                    ; 0491 _ 48: 8B. 45, B0
        mov     byte [rax], 0                           ; 0495 _ C6. 00, 00
?_032:  mov     rdx, qword [rbp-28H]                    ; 0498 _ 48: 8B. 55, D8
        mov     rax, qword [rbp-50H]                    ; 049C _ 48: 8B. 45, B0
        cmp     rdx, rax                                ; 04A0 _ 48: 39. C2
        jnc     ?_033                                   ; 04A3 _ 73, 19
        mov     rax, qword [rbp-50H]                    ; 04A5 _ 48: 8B. 45, B0
        sub     rax, 1                                  ; 04A9 _ 48: 83. E8, 01
        movzx   eax, byte [rax]                         ; 04AD _ 0F B6. 00
        movsx   eax, al                                 ; 04B0 _ 0F BE. C0
        mov     edi, eax                                ; 04B3 _ 89. C7
        call    nasm_isspace                            ; 04B5 _ E8, FFFFFB73
        test    al, al                                  ; 04BA _ 84. C0
        jnz     ?_031                                   ; 04BC _ 75, C7
?_033:  lea     rax, [rel global_pragmas]               ; 04BE _ 48: 8D. 05, 00000000(rel)
        mov     qword [rbp-48H], rax                    ; 04C5 _ 48: 89. 45, B8
        jmp     ?_035                                   ; 04C9 _ EB, 26

?_034:  lea     rdx, [rbp-40H]                          ; 04CB _ 48: 8D. 55, C0
        mov     rax, qword [rbp-48H]                    ; 04CF _ 48: 8B. 45, B8
        mov     rcx, rdx                                ; 04D3 _ 48: 89. D1
        mov     rdx, rax                                ; 04D6 _ 48: 89. C2
        mov     esi, 0                                  ; 04D9 _ BE, 00000000
        mov     edi, 0                                  ; 04DE _ BF, 00000000
        call    search_pragma_list                      ; 04E3 _ E8, FFFFFC06
        test    eax, eax                                ; 04E8 _ 85. C0
        jnz     ?_037                                   ; 04EA _ 75, 34
        add     qword [rbp-48H], 16                     ; 04EC _ 48: 83. 45, B8, 10
?_035:  mov     rax, qword [rbp-48H]                    ; 04F1 _ 48: 8B. 45, B8
        mov     rax, qword [rax]                        ; 04F5 _ 48: 8B. 00
        test    rax, rax                                ; 04F8 _ 48: 85. C0
        jnz     ?_034                                   ; 04FB _ 75, CE
        lea     rax, [rbp-40H]                          ; 04FD _ 48: 8D. 45, C0
        mov     rdi, rax                                ; 0501 _ 48: 89. C7
        call    output_pragma                           ; 0504 _ E8, 00000044
        test    eax, eax                                ; 0509 _ 85. C0
        jnz     ?_038                                   ; 050B _ 75, 16
        lea     rax, [rbp-40H]                          ; 050D _ 48: 8D. 45, C0
        mov     rdi, rax                                ; 0511 _ 48: 89. C7
        call    debug_pragma                            ; 0514 _ E8, 000000B6
        test    eax, eax                                ; 0519 _ 85. C0
        jmp     ?_039                                   ; 051B _ EB, 07

?_036:  nop                                             ; 051D _ 90
        jmp     ?_039                                   ; 051E _ EB, 04

?_037:  nop                                             ; 0520 _ 90
        jmp     ?_039                                   ; 0521 _ EB, 01

?_038:  nop                                             ; 0523 _ 90
?_039:  mov     rax, qword [rbp-18H]                    ; 0524 _ 48: 8B. 45, E8
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        sub     rax, qword [fs:abs 28H]                 ; 0528 _ 64 48: 2B. 04 25, 00000028
        jz      ?_040                                   ; 0531 _ 74, 05
        call    __stack_chk_fail                        ; 0533 _ E8, 00000000(PLT r)
?_040:  mov     rbx, qword [rbp-8H]                     ; 0538 _ 48: 8B. 5D, F8
        leave                                           ; 053C _ C9
        ret                                             ; 053D _ C3
; process_pragma End of function

ignore_pragma:; Local function
        push    rbp                                     ; 053E _ 55
        mov     rbp, rsp                                ; 053F _ 48: 89. E5
        mov     qword [rbp-8H], rdi                     ; 0542 _ 48: 89. 7D, F8
        mov     eax, 1                                  ; 0546 _ B8, 00000001
        pop     rbp                                     ; 054B _ 5D
        ret                                             ; 054C _ C3

output_pragma:; Local function
        push    rbp                                     ; 054D _ 55
        mov     rbp, rsp                                ; 054E _ 48: 89. E5
        sub     rsp, 16                                 ; 0551 _ 48: 83. EC, 10
        mov     qword [rbp-8H], rdi                     ; 0555 _ 48: 89. 7D, F8
        mov     rax, qword [rel ofmt]                   ; 0559 _ 48: 8B. 05, 00000000(rel)
        mov     rsi, qword [rax+8H]                     ; 0560 _ 48: 8B. 70, 08
        mov     rax, qword [rel ofmt]                   ; 0564 _ 48: 8B. 05, 00000000(rel)
        mov     rax, qword [rax+88H]                    ; 056B _ 48: 8B. 80, 00000088
        mov     rdx, qword [rbp-8H]                     ; 0572 _ 48: 8B. 55, F8
        lea     rdi, [rel output_pragma_def.1]          ; 0576 _ 48: 8D. 3D, 00000000(rel)
        mov     rcx, rdx                                ; 057D _ 48: 89. D1
        mov     rdx, rdi                                ; 0580 _ 48: 89. FA
        mov     rdi, rax                                ; 0583 _ 48: 89. C7
        call    search_pragma_list                      ; 0586 _ E8, FFFFFB63
        leave                                           ; 058B _ C9
        ret                                             ; 058C _ C3

output_pragma_common:; Local function
        push    rbp                                     ; 058D _ 55
        mov     rbp, rsp                                ; 058E _ 48: 89. E5
        sub     rsp, 16                                 ; 0591 _ 48: 83. EC, 10
        mov     qword [rbp-8H], rdi                     ; 0595 _ 48: 89. 7D, F8
        mov     rax, qword [rbp-8H]                     ; 0599 _ 48: 8B. 45, F8
        mov     eax, dword [rax+20H]                    ; 059D _ 8B. 40, 20
        sub     eax, 21                                 ; 05A0 _ 83. E8, 15
        cmp     eax, 8                                  ; 05A3 _ 83. F8, 08
        ja      ?_041                                   ; 05A6 _ 77, 20
        mov     rax, qword [rbp-8H]                     ; 05A8 _ 48: 8B. 45, F8
        mov     rdx, qword [rax+18H]                    ; 05AC _ 48: 8B. 50, 18
        mov     rax, qword [rbp-8H]                     ; 05B0 _ 48: 8B. 45, F8
        mov     eax, dword [rax+20H]                    ; 05B4 _ 8B. 40, 20
        mov     rsi, rdx                                ; 05B7 _ 48: 89. D6
        mov     edi, eax                                ; 05BA _ 89. C7
        call    set_label_mangle                        ; 05BC _ E8, 00000000(PLT r)
        mov     eax, 1                                  ; 05C1 _ B8, 00000001
        jmp     ?_042                                   ; 05C6 _ EB, 05

?_041:  mov     eax, 0                                  ; 05C8 _ B8, 00000000
?_042:  leave                                           ; 05CD _ C9
        ret                                             ; 05CE _ C3

debug_pragma:; Local function
        push    rbp                                     ; 05CF _ 55
        mov     rbp, rsp                                ; 05D0 _ 48: 89. E5
        sub     rsp, 16                                 ; 05D3 _ 48: 83. EC, 10
        mov     qword [rbp-8H], rdi                     ; 05D7 _ 48: 89. 7D, F8
        mov     rax, qword [rel dfmt]                   ; 05DB _ 48: 8B. 05, 00000000(rel)
        mov     rsi, qword [rax+8H]                     ; 05E2 _ 48: 8B. 70, 08
        mov     rax, qword [rel dfmt]                   ; 05E6 _ 48: 8B. 05, 00000000(rel)
        mov     rax, qword [rax+60H]                    ; 05ED _ 48: 8B. 40, 60
        mov     rdx, qword [rbp-8H]                     ; 05F1 _ 48: 8B. 55, F8
        lea     rdi, [rel debug_pragma_def.0]           ; 05F5 _ 48: 8D. 3D, 00000000(rel)
        mov     rcx, rdx                                ; 05FC _ 48: 89. D1
        mov     rdx, rdi                                ; 05FF _ 48: 89. FA
        mov     rdi, rax                                ; 0602 _ 48: 89. C7
        call    search_pragma_list                      ; 0605 _ E8, FFFFFAE4
        leave                                           ; 060A _ C9
        ret                                             ; 060B _ C3

limit_pragma:; Local function
        push    rbp                                     ; 060C _ 55
        mov     rbp, rsp                                ; 060D _ 48: 89. E5
        sub     rsp, 16                                 ; 0610 _ 48: 83. EC, 10
        mov     qword [rbp-8H], rdi                     ; 0614 _ 48: 89. 7D, F8
        mov     rax, qword [rbp-8H]                     ; 0618 _ 48: 8B. 45, F8
        mov     rdx, qword [rax+18H]                    ; 061C _ 48: 8B. 50, 18
        mov     rax, qword [rbp-8H]                     ; 0620 _ 48: 8B. 45, F8
        mov     rax, qword [rax+10H]                    ; 0624 _ 48: 8B. 40, 10
        mov     rsi, rdx                                ; 0628 _ 48: 89. D6
        mov     rdi, rax                                ; 062B _ 48: 89. C7
        call    nasm_set_limit                          ; 062E _ E8, 00000000(PLT r)
        leave                                           ; 0633 _ C9
        ret                                             ; 0634 _ C3


SECTION .data   align=1 noexec                          ; section number 2, data


SECTION .bss    align=1 noexec                          ; section number 3, bss


SECTION .rodata align=16 noexec                         ; section number 4, const

        db 61H, 73H, 6DH, 00H, 6CH, 69H, 6DH, 69H       ; 0000 _ asm.limi
        db 74H, 00H, 6CH, 69H, 73H, 74H, 00H, 66H       ; 0008 _ t.list.f
        db 69H, 6CH, 65H, 00H, 69H, 6EH, 70H, 75H       ; 0010 _ ile.inpu
        db 74H, 00H, 6FH, 75H, 74H, 70H, 75H, 74H       ; 0018 _ t.output
        db 00H, 64H, 65H, 62H, 75H, 67H, 00H, 69H       ; 0020 _ .debug.i
        db 67H, 6EH, 6FH, 72H, 65H, 00H, 70H, 72H       ; 0028 _ gnore.pr
        db 65H, 70H, 72H, 6FH, 63H, 00H                 ; 0030 _ eproc.

?_043:                                                  ; byte
        db 65H, 6DH, 70H, 74H, 79H, 20H, 25H, 25H       ; 0036 _ empty %%
        db 70H, 72H, 61H, 67H, 6DH, 61H, 20H, 25H       ; 003E _ pragma %
        db 73H, 00H                                     ; 0046 _ s.

?_044:                                                  ; byte
        db 75H, 6EH, 6BH, 6EH, 6FH, 77H, 6EH, 20H       ; 0048 _ unknown 
        db 25H, 25H, 70H, 72H, 61H, 67H, 6DH, 61H       ; 0050 _ %%pragma
        db 20H, 25H, 73H, 20H, 25H, 73H, 00H, 00H       ; 0058 _  %s %s..

?_045:                                                  ; byte
        db 62H, 61H, 64H, 20H, 61H, 72H, 67H, 75H       ; 0060 _ bad argu
        db 6DH, 65H, 6EH, 74H, 20H, 74H, 6FH, 20H       ; 0068 _ ment to 
        db 25H, 25H, 70H, 72H, 61H, 67H, 6DH, 61H       ; 0070 _ %%pragma
        db 20H, 25H, 73H, 20H, 25H, 73H, 00H            ; 0078 _  %s %s.

?_046:                                                  ; byte
        db 2EH, 2FH, 61H, 73H, 6DH, 2FH, 70H, 72H       ; 007F _ ./asm/pr
        db 61H, 67H, 6DH, 61H, 2EH, 63H, 00H, 00H       ; 0087 _ agma.c..
        db 00H                                          ; 008F _ .

?_047:                                                  ; byte
        db 65H, 6DH, 70H, 74H, 79H, 20H, 25H, 25H       ; 0090 _ empty %%
        db 70H, 72H, 61H, 67H, 6DH, 61H, 20H, 64H       ; 0098 _ pragma d
        db 69H, 72H, 65H, 63H, 74H, 69H, 76H, 65H       ; 00A0 _ irective
        db 2CH, 20H, 69H, 67H, 6EH, 6FH, 72H, 65H       ; 00A8 _ , ignore
        db 64H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 00B0 _ d.......
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 00B8 _ ........

__func__.2:                                             ; byte
        db 73H, 65H, 61H, 72H, 63H, 68H, 5FH, 70H       ; 00C0 _ search_p
        db 72H, 61H, 67H, 6DH, 61H, 5FH, 6CH, 69H       ; 00C8 _ ragma_li
        db 73H, 74H, 00H                                ; 00D0 _ st.


SECTION .data.rel align=32 noexec                       ; section number 5, data

global_pragmas:                                         ; byte
        dq Unnamed_4_0                                  ; 0000 _ 0000000000000000 (d)
        dq 0000000000000000H                            ; 0008 _ 0000000000000000 
        dq Unnamed_4_0+4H                               ; 0010 _ 0000000000000000 (d)
        dq limit_pragma                                 ; 0018 _ 0000000000000000 (d)
        dq Unnamed_4_0+0AH                              ; 0020 _ 0000000000000000 (d)
        dq list_pragma                                  ; 0028 _ 0000000000000000 (d)
        dq Unnamed_4_0+0FH                              ; 0030 _ 0000000000000000 (d)
        dq 0000000000000000H                            ; 0038 _ 0000000000000000 
        dq Unnamed_4_0+14H                              ; 0040 _ 0000000000000000 (d)
        dq 0000000000000000H                            ; 0048 _ 0000000000000000 
        dq Unnamed_4_0+1AH                              ; 0050 _ 0000000000000000 (d)
        dq output_pragma                                ; 0058 _ 0000000000000000 (d)
        dq Unnamed_4_0+21H                              ; 0060 _ 0000000000000000 (d)
        dq debug_pragma                                 ; 0068 _ 0000000000000000 (d)
        dq Unnamed_4_0+27H                              ; 0070 _ 0000000000000000 (d)
        dq ignore_pragma                                ; 0078 _ 0000000000000000 (d)
        dq Unnamed_4_0+2EH                              ; 0080 _ 0000000000000000 (d)
        dq 0000000000000000H                            ; 0088 _ 0000000000000000 
        dq 0000000000000000H                            ; 0090 _ 0000000000000000 
        dq 0000000000000000H                            ; 0098 _ 0000000000000000 


SECTION .data.rel.ro.local align=16 noexec              ; section number 6, data

output_pragma_def.1:                                    ; oword
        dq Unnamed_4_0+1AH                              ; 0000 _ 0000000000000000 (d)
        dq output_pragma_common                         ; 0008 _ 0000000000000000 (d)

debug_pragma_def.0:                                     ; oword
        dq Unnamed_4_0+21H                              ; 0010 _ 0000000000000000 (d)
        dq 0000000000000000H                            ; 0018 _ 0000000000000000 


SECTION .note.gnu.property align=8 noexec               ; section number 7, const

        db 04H, 00H, 00H, 00H, 20H, 00H, 00H, 00H       ; 0000 _ .... ...
        db 05H, 00H, 00H, 00H, 47H, 4EH, 55H, 00H       ; 0008 _ ....GNU.
        db 02H, 00H, 01H, 0C0H, 04H, 00H, 00H, 00H      ; 0010 _ ........
        db 01H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0018 _ ........
        db 01H, 00H, 01H, 0C0H, 04H, 00H, 00H, 00H      ; 0020 _ ........
        db 01H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0028 _ ........


SECTION .eh_frame align=8 noexec                        ; section number 8, const

        db 14H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0000 _ ........
        db 01H, 7AH, 52H, 00H, 01H, 78H, 10H, 01H       ; 0008 _ .zR..x..
        db 1BH, 0CH, 07H, 08H, 90H, 01H, 00H, 00H       ; 0010 _ ........
        db 1CH, 00H, 00H, 00H, 1CH, 00H, 00H, 00H       ; 0018 _ ........
        dd nasm_ctype-$-20H                             ; 0020 _ 00000000 (rel)
        dd 0000002DH, 100E4100H                         ; 0024 _ 45 269369600 
        dd 0D430286H, 070C6806H                         ; 002C _ 222495366 118253574 
        dd 00000008H, 0000001CH                         ; 0034 _ 8 28 
        dd 0000003CH                                    ; 003C _ 60 
        dd nasm_ctype-$-13H                             ; 0040 _ 00000000 (rel)
        dd 00000021H, 100E4100H                         ; 0044 _ 33 269369600 
        dd 0D430286H, 070C5C06H                         ; 004C _ 222495366 118250502 
        dd 00000008H, 0000001CH                         ; 0054 _ 8 28 
        dd 0000005CH                                    ; 005C _ 92 
        dd nasm_ctype-$-12H                             ; 0060 _ 00000000 (rel)
        dd 00000024H, 100E4100H                         ; 0064 _ 36 269369600 
        dd 0D430286H, 070C5F06H                         ; 006C _ 222495366 118251270 
        dd 00000008H, 0000001CH                         ; 0074 _ 8 28 
        dd 0000007CH                                    ; 007C _ 124 
        dd nasm_ctype-$-0EH                             ; 0080 _ 00000000 (rel)
        dd 00000033H, 100E4100H                         ; 0084 _ 51 269369600 
        dd 0D430286H, 070C6E06H                         ; 008C _ 222495366 118255110 
        dd 00000008H, 0000001CH                         ; 0094 _ 8 28 
        dd 0000009CH                                    ; 009C _ 156 
        dd nasm_ctype-$+5H                              ; 00A0 _ 00000000 (rel)
        dd 00000049H, 100E4100H                         ; 00A4 _ 73 269369600 
        dd 0D430286H, 0C440206H                         ; 00AC _ 222495366 205783558 
        dd 00000807H, 00000020H                         ; 00B4 _ 2055 32 
        dd 000000BCH                                    ; 00BC _ 188 
        dd nasm_ctype-$+2EH                             ; 00C0 _ 00000000 (rel)
        dd 000002A1H, 100E4100H                         ; 00C4 _ 673 269369600 
        dd 0D430286H, 03834506H                         ; 00CC _ 222495366 58934534 
        dd 0C029703H, 00000807H                         ; 00D4 _ 201496323 2055 
        dd 00000020H, 000000E0H                         ; 00DC _ 32 224 
        dd nasm_ctype-$+2ABH                            ; 00E4 _ 00000000 (rel)
        dd 000001AFH, 100E4100H                         ; 00E8 _ 431 269369600 
        dd 0D430286H, 03834506H                         ; 00F0 _ 222495366 58934534 
        dd 0C01A503H, 00000807H                         ; 00F8 _ 201434371 2055 
        dd 0000001CH, 00000104H                         ; 0100 _ 28 260 
        dd nasm_ctype-$+436H                            ; 0108 _ 00000000 (rel)
        dd 0000000FH, 100E4100H                         ; 010C _ 15 269369600 
        dd 0D430286H, 070C4A06H                         ; 0114 _ 222495366 118245894 
        dd 00000008H, 0000001CH                         ; 011C _ 8 28 
        dd 00000124H                                    ; 0124 _ 292 
        dd nasm_ctype-$+425H                            ; 0128 _ 00000000 (rel)
        dd 00000040H, 100E4100H                         ; 012C _ 64 269369600 
        dd 0D430286H, 070C7B06H                         ; 0134 _ 222495366 118258438 
        dd 00000008H, 0000001CH                         ; 013C _ 8 28 
        dd 00000144H                                    ; 0144 _ 324 
        dd ?_029-$+148H                                 ; 0148 _ 00000000 (rel)
        dd 00000042H, 100E4100H                         ; 014C _ 66 269369600 
        dd 0D430286H, 070C7D06H                         ; 0154 _ 222495366 118258950 
        dd 00000008H, 0000001CH                         ; 015C _ 8 28 
        dd 00000164H                                    ; 0164 _ 356 
        dd nasm_ctype-$+467H                            ; 0168 _ 00000000 (rel)
        dd 0000003DH, 100E4100H                         ; 016C _ 61 269369600 
        dd 0D430286H, 070C7806H                         ; 0174 _ 222495366 118257670 
        dd 00000008H, 0000001CH                         ; 017C _ 8 28 
        dd 00000184H                                    ; 0184 _ 388 
        dd nasm_ctype-$+484H                            ; 0188 _ 00000000 (rel)
        dd 00000029H, 100E4100H                         ; 018C _ 41 269369600 
        dd 0D430286H, 070C6406H                         ; 0194 _ 222495366 118252550 
        dd 00000008H                                    ; 019C _ 8 


