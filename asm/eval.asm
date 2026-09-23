; Disassembly of file: /tmp/tmp.6ucyF0CD31.o
; Wed Sep 23 14:43:27 2026
; Type: ELF64
; Syntax: NASM
; Instruction set: 80386, x64

default rel

global eval_cleanup: function
global evaluate: function

extern local_scope                                      ; near
extern lookup_label                                     ; near
extern absolute                                         ; qword
extern in_absolute                                      ; byte
extern location                                         ; qword
extern nasm_limit                                       ; qword
extern nasm_panic                                       ; near
extern ilog2_64                                         ; near
extern nasm_error                                       ; near
extern nasm_warn_                                       ; near
extern readstrnum                                       ; near
extern string_transform                                 ; near
extern __stack_chk_fail                                 ; near
extern float_const                                      ; near
extern fp_formats                                       ; byte
extern is_just_unknown                                  ; near
extern reloc_value                                      ; near
extern is_simple                                        ; near
extern ofmt                                             ; qword
extern reloc_seg                                        ; near
extern nasm_nonfatal                                    ; near
extern is_reloc                                         ; near
extern is_unknown                                       ; near
extern is_really_simple                                 ; near
extern nasm_realloc                                     ; near
extern nasm_free                                        ; near
extern _pass_type                                       ; dword
extern warning_state                                    ; byte
extern erropt                                           ; dword


SECTION .text   align=1 exec                            ; section number 1, code

is_extern:; Local function
        push    rbp                                     ; 0000 _ 55
        mov     rbp, rsp                                ; 0001 _ 48: 89. E5
        mov     dword [rbp-4H], edi                     ; 0004 _ 89. 7D, FC
        cmp     dword [rbp-4H], 3                       ; 0007 _ 83. 7D, FC, 03
        jz      ?_001                                   ; 000B _ 74, 06
        cmp     dword [rbp-4H], 4                       ; 000D _ 83. 7D, FC, 04
        jnz     ?_002                                   ; 0011 _ 75, 07
?_001:  mov     eax, 1                                  ; 0013 _ B8, 00000001
        jmp     ?_003                                   ; 0018 _ EB, 05

?_002:  mov     eax, 0                                  ; 001A _ B8, 00000000
?_003:  and     eax, 01H                                ; 001F _ 83. E0, 01
        pop     rbp                                     ; 0022 _ 5D
        ret                                             ; 0023 _ C3

warn_active:; Local function
        push    rbp                                     ; 0024 _ 55
        mov     rbp, rsp                                ; 0025 _ 48: 89. E5
        mov     dword [rbp-4H], edi                     ; 0028 _ 89. 7D, FC
        mov     eax, dword [rel erropt+0CH]             ; 002B _ 8B. 05, 00000000(rel)
        and     eax, dword [rbp-4H]                     ; 0031 _ 23. 45, FC
        test    eax, eax                                ; 0034 _ 85. C0
        jz      ?_004                                   ; 0036 _ 74, 07
        mov     eax, 0                                  ; 0038 _ B8, 00000000
        jmp     ?_005                                   ; 003D _ EB, 16

?_004:  mov     eax, dword [rbp-4H]                     ; 003F _ 8B. 45, FC
        shr     eax, 16                                 ; 0042 _ C1. E8, 10
        mov     edx, eax                                ; 0045 _ 89. C2
        lea     rax, [rel warning_state]                ; 0047 _ 48: 8D. 05, 00000000(rel)
        movzx   eax, byte [rdx+rax]                     ; 004E _ 0F B6. 04 02
        and     eax, 01H                                ; 0052 _ 83. E0, 01
?_005:  pop     rbp                                     ; 0055 _ 5D
        ret                                             ; 0056 _ C3

pass_type:; Local function
        push    rbp                                     ; 0057 _ 55
        mov     rbp, rsp                                ; 0058 _ 48: 89. E5
        mov     eax, dword [rel _pass_type]             ; 005B _ 8B. 05, 00000000(rel)
        pop     rbp                                     ; 0061 _ 5D
        ret                                             ; 0062 _ C3

pass_first:; Local function
        push    rbp                                     ; 0063 _ 55
        mov     rbp, rsp                                ; 0064 _ 48: 89. E5
        call    pass_type                               ; 0067 _ E8, FFFFFFEB
        cmp     eax, 2                                  ; 006C _ 83. F8, 02
        setbe   al                                      ; 006F _ 0F 96. C0
        pop     rbp                                     ; 0072 _ 5D
        ret                                             ; 0073 _ C3

eval_cleanup:; Function begin
        push    rbp                                     ; 0074 _ 55
        mov     rbp, rsp                                ; 0075 _ 48: 89. E5
        jmp     ?_007                                   ; 0078 _ EB, 31

?_006:  mov     rax, qword [rel tempexprs]              ; 007A _ 48: 8B. 05, 00000000(rel)
        mov     edx, dword [rel ntempexprs]             ; 0081 _ 8B. 15, 00000000(rel)
        sub     edx, 1                                  ; 0087 _ 83. EA, 01
        mov     dword [rel ntempexprs], edx             ; 008A _ 89. 15, 00000000(rel)
        mov     edx, dword [rel ntempexprs]             ; 0090 _ 8B. 15, 00000000(rel)
        movsxd  rdx, edx                                ; 0096 _ 48: 63. D2
        shl     rdx, 3                                  ; 0099 _ 48: C1. E2, 03
        add     rax, rdx                                ; 009D _ 48: 01. D0
        mov     rax, qword [rax]                        ; 00A0 _ 48: 8B. 00
        mov     rdi, rax                                ; 00A3 _ 48: 89. C7
        call    nasm_free                               ; 00A6 _ E8, 00000000(PLT r)
?_007:  mov     eax, dword [rel ntempexprs]             ; 00AB _ 8B. 05, 00000000(rel)
        test    eax, eax                                ; 00B1 _ 85. C0
        jnz     ?_006                                   ; 00B3 _ 75, C5
        mov     rax, qword [rel tempexprs]              ; 00B5 _ 48: 8B. 05, 00000000(rel)
        mov     rdi, rax                                ; 00BC _ 48: 89. C7
        call    nasm_free                               ; 00BF _ E8, 00000000(PLT r)
        nop                                             ; 00C4 _ 90
        pop     rbp                                     ; 00C5 _ 5D
        ret                                             ; 00C6 _ C3
; eval_cleanup End of function

begintemp:; Local function
        push    rbp                                     ; 00C7 _ 55
        mov     rbp, rsp                                ; 00C8 _ 48: 89. E5
        mov     qword [rel tempexpr], 0                 ; 00CB _ 48: C7. 05, 00000000(rel), 00000000
        mov     dword [rel ntempexpr], 0                ; 00D6 _ C7. 05, 00000000(rel), 00000000
        mov     eax, dword [rel ntempexpr]              ; 00E0 _ 8B. 05, 00000000(rel)
        mov     dword [rel tempexpr_size], eax          ; 00E6 _ 89. 05, 00000000(rel)
        nop                                             ; 00EC _ 90
        pop     rbp                                     ; 00ED _ 5D
        ret                                             ; 00EE _ C3

addtotemp:; Local function
        push    rbp                                     ; 00EF _ 55
        mov     rbp, rsp                                ; 00F0 _ 48: 89. E5
        sub     rsp, 16                                 ; 00F3 _ 48: 83. EC, 10
        mov     dword [rbp-4H], edi                     ; 00F7 _ 89. 7D, FC
        mov     qword [rbp-10H], rsi                    ; 00FA _ 48: 89. 75, F0
        jmp     ?_009                                   ; 00FE _ EB, 37

?_008:  mov     eax, dword [rel tempexpr_size]          ; 0100 _ 8B. 05, 00000000(rel)
        add     eax, 8                                  ; 0106 _ 83. C0, 08
        mov     dword [rel tempexpr_size], eax          ; 0109 _ 89. 05, 00000000(rel)
        mov     eax, dword [rel tempexpr_size]          ; 010F _ 8B. 05, 00000000(rel)
        cdqe                                            ; 0115 _ 48: 98
        shl     rax, 4                                  ; 0117 _ 48: C1. E0, 04
        mov     rdx, rax                                ; 011B _ 48: 89. C2
        mov     rax, qword [rel tempexpr]               ; 011E _ 48: 8B. 05, 00000000(rel)
        mov     rsi, rdx                                ; 0125 _ 48: 89. D6
        mov     rdi, rax                                ; 0128 _ 48: 89. C7
        call    nasm_realloc                            ; 012B _ E8, 00000000(PLT r)
        mov     qword [rel tempexpr], rax               ; 0130 _ 48: 89. 05, 00000000(rel)
?_009:  mov     edx, dword [rel ntempexpr]              ; 0137 _ 8B. 15, 00000000(rel)
        mov     eax, dword [rel tempexpr_size]          ; 013D _ 8B. 05, 00000000(rel)
        cmp     edx, eax                                ; 0143 _ 39. C2
        jge     ?_008                                   ; 0145 _ 7D, B9
        mov     rax, qword [rel tempexpr]               ; 0147 _ 48: 8B. 05, 00000000(rel)
        mov     edx, dword [rel ntempexpr]              ; 014E _ 8B. 15, 00000000(rel)
        movsxd  rdx, edx                                ; 0154 _ 48: 63. D2
        shl     rdx, 4                                  ; 0157 _ 48: C1. E2, 04
        add     rdx, rax                                ; 015B _ 48: 01. C2
        mov     eax, dword [rbp-4H]                     ; 015E _ 8B. 45, FC
        mov     dword [rdx], eax                        ; 0161 _ 89. 02
        mov     rcx, qword [rel tempexpr]               ; 0163 _ 48: 8B. 0D, 00000000(rel)
        mov     eax, dword [rel ntempexpr]              ; 016A _ 8B. 05, 00000000(rel)
        lea     edx, [rax+1H]                           ; 0170 _ 8D. 50, 01
        mov     dword [rel ntempexpr], edx              ; 0173 _ 89. 15, 00000000(rel)
        cdqe                                            ; 0179 _ 48: 98
        shl     rax, 4                                  ; 017B _ 48: C1. E0, 04
        lea     rdx, [rcx+rax]                          ; 017F _ 48: 8D. 14 01
        mov     rax, qword [rbp-10H]                    ; 0183 _ 48: 8B. 45, F0
        mov     qword [rdx+8H], rax                     ; 0187 _ 48: 89. 42, 08
        nop                                             ; 018B _ 90
        leave                                           ; 018C _ C9
        ret                                             ; 018D _ C3

finishtemp:; Local function
        push    rbp                                     ; 018E _ 55
        mov     rbp, rsp                                ; 018F _ 48: 89. E5
        mov     esi, 0                                  ; 0192 _ BE, 00000000
        mov     edi, 0                                  ; 0197 _ BF, 00000000
        call    addtotemp                               ; 019C _ E8, FFFFFF4E
        jmp     ?_011                                   ; 01A1 _ EB, 38

?_010:  mov     eax, dword [rel tempexprs_size]         ; 01A3 _ 8B. 05, 00000000(rel)
        sub     eax, -128                               ; 01A9 _ 83. E8, 80
        mov     dword [rel tempexprs_size], eax         ; 01AC _ 89. 05, 00000000(rel)
        mov     eax, dword [rel tempexprs_size]         ; 01B2 _ 8B. 05, 00000000(rel)
        cdqe                                            ; 01B8 _ 48: 98
        lea     rdx, [rax*8]                            ; 01BA _ 48: 8D. 14 C5, 00000000
        mov     rax, qword [rel tempexprs]              ; 01C2 _ 48: 8B. 05, 00000000(rel)
        mov     rsi, rdx                                ; 01C9 _ 48: 89. D6
        mov     rdi, rax                                ; 01CC _ 48: 89. C7
        call    nasm_realloc                            ; 01CF _ E8, 00000000(PLT r)
        mov     qword [rel tempexprs], rax              ; 01D4 _ 48: 89. 05, 00000000(rel)
?_011:  mov     edx, dword [rel ntempexprs]             ; 01DB _ 8B. 15, 00000000(rel)
        mov     eax, dword [rel tempexprs_size]         ; 01E1 _ 8B. 05, 00000000(rel)
        cmp     edx, eax                                ; 01E7 _ 39. C2
        jge     ?_010                                   ; 01E9 _ 7D, B8
        mov     rcx, qword [rel tempexprs]              ; 01EB _ 48: 8B. 0D, 00000000(rel)
        mov     eax, dword [rel ntempexprs]             ; 01F2 _ 8B. 05, 00000000(rel)
        lea     edx, [rax+1H]                           ; 01F8 _ 8D. 50, 01
        mov     dword [rel ntempexprs], edx             ; 01FB _ 89. 15, 00000000(rel)
        cdqe                                            ; 0201 _ 48: 98
        shl     rax, 3                                  ; 0203 _ 48: C1. E0, 03
        add     rax, rcx                                ; 0207 _ 48: 01. C8
        mov     rdx, qword [rel tempexpr]               ; 020A _ 48: 8B. 15, 00000000(rel)
        mov     qword [rax], rdx                        ; 0211 _ 48: 89. 10
        mov     rax, qword [rax]                        ; 0214 _ 48: 8B. 00
        pop     rbp                                     ; 0217 _ 5D
        ret                                             ; 0218 _ C3

add_vectors:; Local function
        push    rbp                                     ; 0219 _ 55
        mov     rbp, rsp                                ; 021A _ 48: 89. E5
        sub     rsp, 32                                 ; 021D _ 48: 83. EC, 20
        mov     qword [rbp-18H], rdi                    ; 0221 _ 48: 89. 7D, E8
        mov     qword [rbp-20H], rsi                    ; 0225 _ 48: 89. 75, E0
        mov     rax, qword [rbp-18H]                    ; 0229 _ 48: 8B. 45, E8
        mov     rdi, rax                                ; 022D _ 48: 89. C7
        call    is_really_simple                        ; 0230 _ E8, 00000000(PLT r)
        test    al, al                                  ; 0235 _ 84. C0
        jnz     ?_012                                   ; 0237 _ 75, 10
        mov     rax, qword [rbp-20H]                    ; 0239 _ 48: 8B. 45, E0
        mov     rdi, rax                                ; 023D _ 48: 89. C7
        call    is_really_simple                        ; 0240 _ E8, 00000000(PLT r)
        test    al, al                                  ; 0245 _ 84. C0
        jz      ?_013                                   ; 0247 _ 74, 07
?_012:  mov     eax, 1                                  ; 0249 _ B8, 00000001
        jmp     ?_014                                   ; 024E _ EB, 05

?_013:  mov     eax, 0                                  ; 0250 _ B8, 00000000
?_014:  mov     dword [rbp-0CH], eax                    ; 0255 _ 89. 45, F4
        call    begintemp                               ; 0258 _ E8, FFFFFE6A
        jmp     ?_020                                   ; 025D _ E9, 000000EB

?_015:  mov     rax, qword [rbp-18H]                    ; 0262 _ 48: 8B. 45, E8
        mov     edx, dword [rax]                        ; 0266 _ 8B. 10
        mov     rax, qword [rbp-20H]                    ; 0268 _ 48: 8B. 45, E0
        mov     eax, dword [rax]                        ; 026C _ 8B. 00
        cmp     edx, eax                                ; 026E _ 39. C2
        jle     ?_016                                   ; 0270 _ 7E, 2E
        mov     rax, qword [rbp-20H]                    ; 0272 _ 48: 8B. 45, E0
        mov     rdx, qword [rax+8H]                     ; 0276 _ 48: 8B. 50, 08
        mov     rax, qword [rbp-20H]                    ; 027A _ 48: 8B. 45, E0
        mov     eax, dword [rax]                        ; 027E _ 8B. 00
        mov     rsi, rdx                                ; 0280 _ 48: 89. D6
        mov     edi, eax                                ; 0283 _ 89. C7
        call    addtotemp                               ; 0285 _ E8, FFFFFE65
        mov     rax, qword [rbp-20H]                    ; 028A _ 48: 8B. 45, E0
        lea     rdx, [rax+10H]                          ; 028E _ 48: 8D. 50, 10
        mov     qword [rbp-20H], rdx                    ; 0292 _ 48: 89. 55, E0
        mov     eax, dword [rax]                        ; 0296 _ 8B. 00
        mov     dword [rbp-10H], eax                    ; 0298 _ 89. 45, F0
        jmp     ?_019                                   ; 029B _ E9, 0000009A

?_016:  mov     rax, qword [rbp-18H]                    ; 02A0 _ 48: 8B. 45, E8
        mov     edx, dword [rax]                        ; 02A4 _ 8B. 10
        mov     rax, qword [rbp-20H]                    ; 02A6 _ 48: 8B. 45, E0
        mov     eax, dword [rax]                        ; 02AA _ 8B. 00
        cmp     edx, eax                                ; 02AC _ 39. C2
        jge     ?_017                                   ; 02AE _ 7D, 2B
        mov     rax, qword [rbp-18H]                    ; 02B0 _ 48: 8B. 45, E8
        mov     rdx, qword [rax+8H]                     ; 02B4 _ 48: 8B. 50, 08
        mov     rax, qword [rbp-18H]                    ; 02B8 _ 48: 8B. 45, E8
        mov     eax, dword [rax]                        ; 02BC _ 8B. 00
        mov     rsi, rdx                                ; 02BE _ 48: 89. D6
        mov     edi, eax                                ; 02C1 _ 89. C7
        call    addtotemp                               ; 02C3 _ E8, FFFFFE27
        mov     rax, qword [rbp-18H]                    ; 02C8 _ 48: 8B. 45, E8
        lea     rdx, [rax+10H]                          ; 02CC _ 48: 8D. 50, 10
        mov     qword [rbp-18H], rdx                    ; 02D0 _ 48: 89. 55, E8
        mov     eax, dword [rax]                        ; 02D4 _ 8B. 00
        mov     dword [rbp-10H], eax                    ; 02D6 _ 89. 45, F0
        jmp     ?_019                                   ; 02D9 _ EB, 5F

?_017:  mov     rax, qword [rbp-18H]                    ; 02DB _ 48: 8B. 45, E8
        mov     rdx, qword [rax+8H]                     ; 02DF _ 48: 8B. 50, 08
        mov     rax, qword [rbp-20H]                    ; 02E3 _ 48: 8B. 45, E0
        mov     rax, qword [rax+8H]                     ; 02E7 _ 48: 8B. 40, 08
        add     rax, rdx                                ; 02EB _ 48: 01. D0
        mov     qword [rbp-8H], rax                     ; 02EE _ 48: 89. 45, F8
        cmp     qword [rbp-8H], 0                       ; 02F2 _ 48: 83. 7D, F8, 00
        jz      ?_018                                   ; 02F7 _ 74, 2E
        mov     rax, qword [rbp-18H]                    ; 02F9 _ 48: 8B. 45, E8
        mov     eax, dword [rax]                        ; 02FD _ 8B. 00
        mov     rdx, qword [rbp-8H]                     ; 02FF _ 48: 8B. 55, F8
        mov     rsi, rdx                                ; 0303 _ 48: 89. D6
        mov     edi, eax                                ; 0306 _ 89. C7
        call    addtotemp                               ; 0308 _ E8, FFFFFDE2
        mov     rax, qword [rel hint]                   ; 030D _ 48: 8B. 05, 00000000(rel)
        test    rax, rax                                ; 0314 _ 48: 85. C0
        jz      ?_018                                   ; 0317 _ 74, 0E
        mov     rax, qword [rel hint]                   ; 0319 _ 48: 8B. 05, 00000000(rel)
        mov     dword [rax+8H], 3                       ; 0320 _ C7. 40, 08, 00000003
?_018:  mov     rax, qword [rbp-18H]                    ; 0327 _ 48: 8B. 45, E8
        mov     eax, dword [rax]                        ; 032B _ 8B. 00
        mov     dword [rbp-10H], eax                    ; 032D _ 89. 45, F0
        add     qword [rbp-18H], 16                     ; 0330 _ 48: 83. 45, E8, 10
        add     qword [rbp-20H], 16                     ; 0335 _ 48: 83. 45, E0, 10
?_019:  cmp     dword [rbp-10H], 345                    ; 033A _ 81. 7D, F0, 00000159
        jnz     ?_020                                   ; 0341 _ 75, 0A
        call    finishtemp                              ; 0343 _ E8, FFFFFE46
        jmp     ?_026                                   ; 0348 _ E9, 000000AF

?_020:  mov     rax, qword [rbp-18H]                    ; 034D _ 48: 8B. 45, E8
        mov     eax, dword [rax]                        ; 0351 _ 8B. 00
        test    eax, eax                                ; 0353 _ 85. C0
        jz      ?_022                                   ; 0355 _ 74, 47
        mov     rax, qword [rbp-20H]                    ; 0357 _ 48: 8B. 45, E0
        mov     eax, dword [rax]                        ; 035B _ 8B. 00
        test    eax, eax                                ; 035D _ 85. C0
        jz      ?_022                                   ; 035F _ 74, 3D
        mov     rax, qword [rbp-18H]                    ; 0361 _ 48: 8B. 45, E8
        mov     eax, dword [rax]                        ; 0365 _ 8B. 00
        cmp     eax, 1073742172                         ; 0367 _ 3D, 4000015C
        jg      ?_022                                   ; 036C _ 7F, 30
        mov     rax, qword [rbp-20H]                    ; 036E _ 48: 8B. 45, E0
        mov     eax, dword [rax]                        ; 0372 _ 8B. 00
        cmp     eax, 1073742172                         ; 0374 _ 3D, 4000015C
        jle     ?_015                                   ; 0379 _ 0F 8E, FFFFFEE3
        jmp     ?_022                                   ; 037F _ EB, 1D

?_021:  mov     rax, qword [rbp-18H]                    ; 0381 _ 48: 8B. 45, E8
        mov     rdx, qword [rax+8H]                     ; 0385 _ 48: 8B. 50, 08
        mov     rax, qword [rbp-18H]                    ; 0389 _ 48: 8B. 45, E8
        mov     eax, dword [rax]                        ; 038D _ 8B. 00
        mov     rsi, rdx                                ; 038F _ 48: 89. D6
        mov     edi, eax                                ; 0392 _ 89. C7
        call    addtotemp                               ; 0394 _ E8, FFFFFD56
        add     qword [rbp-18H], 16                     ; 0399 _ 48: 83. 45, E8, 10
?_022:  mov     rax, qword [rbp-18H]                    ; 039E _ 48: 8B. 45, E8
        mov     eax, dword [rax]                        ; 03A2 _ 8B. 00
        test    eax, eax                                ; 03A4 _ 85. C0
        jz      ?_024                                   ; 03A6 _ 74, 32
        cmp     dword [rbp-0CH], 0                      ; 03A8 _ 83. 7D, F4, 00
        jnz     ?_021                                   ; 03AC _ 75, D3
        mov     rax, qword [rbp-18H]                    ; 03AE _ 48: 8B. 45, E8
        mov     eax, dword [rax]                        ; 03B2 _ 8B. 00
        cmp     eax, 1073742172                         ; 03B4 _ 3D, 4000015C
        jle     ?_021                                   ; 03B9 _ 7E, C6
        jmp     ?_024                                   ; 03BB _ EB, 1D

?_023:  mov     rax, qword [rbp-20H]                    ; 03BD _ 48: 8B. 45, E0
        mov     rdx, qword [rax+8H]                     ; 03C1 _ 48: 8B. 50, 08
        mov     rax, qword [rbp-20H]                    ; 03C5 _ 48: 8B. 45, E0
        mov     eax, dword [rax]                        ; 03C9 _ 8B. 00
        mov     rsi, rdx                                ; 03CB _ 48: 89. D6
        mov     edi, eax                                ; 03CE _ 89. C7
        call    addtotemp                               ; 03D0 _ E8, FFFFFD1A
        add     qword [rbp-20H], 16                     ; 03D5 _ 48: 83. 45, E0, 10
?_024:  mov     rax, qword [rbp-20H]                    ; 03DA _ 48: 8B. 45, E0
        mov     eax, dword [rax]                        ; 03DE _ 8B. 00
        test    eax, eax                                ; 03E0 _ 85. C0
        jz      ?_025                                   ; 03E2 _ 74, 13
        cmp     dword [rbp-0CH], 0                      ; 03E4 _ 83. 7D, F4, 00
        jnz     ?_023                                   ; 03E8 _ 75, D3
        mov     rax, qword [rbp-20H]                    ; 03EA _ 48: 8B. 45, E0
        mov     eax, dword [rax]                        ; 03EE _ 8B. 00
        cmp     eax, 1073742172                         ; 03F0 _ 3D, 4000015C
        jle     ?_023                                   ; 03F5 _ 7E, C6
?_025:  call    finishtemp                              ; 03F7 _ E8, FFFFFD92
?_026:  leave                                           ; 03FC _ C9
        ret                                             ; 03FD _ C3

scalar_mult:; Local function
        push    rbp                                     ; 03FE _ 55
        mov     rbp, rsp                                ; 03FF _ 48: 89. E5
        mov     qword [rbp-18H], rdi                    ; 0402 _ 48: 89. 7D, E8
        mov     qword [rbp-20H], rsi                    ; 0406 _ 48: 89. 75, E0
        mov     dword [rbp-24H], edx                    ; 040A _ 89. 55, DC
        mov     rax, qword [rbp-18H]                    ; 040D _ 48: 8B. 45, E8
        mov     qword [rbp-8H], rax                     ; 0411 _ 48: 89. 45, F8
        jmp     ?_029                                   ; 0415 _ EB, 64

?_027:  mov     rax, qword [rbp-8H]                     ; 0417 _ 48: 8B. 45, F8
        mov     rax, qword [rax+8H]                     ; 041B _ 48: 8B. 40, 08
        imul    rax, qword [rbp-20H]                    ; 041F _ 48: 0F AF. 45, E0
        mov     rdx, rax                                ; 0424 _ 48: 89. C2
        mov     rax, qword [rbp-8H]                     ; 0427 _ 48: 8B. 45, F8
        mov     qword [rax+8H], rdx                     ; 042B _ 48: 89. 50, 08
        mov     rax, qword [rel hint]                   ; 042F _ 48: 8B. 05, 00000000(rel)
        test    rax, rax                                ; 0436 _ 48: 85. C0
        jz      ?_028                                   ; 0439 _ 74, 3B
        mov     rax, qword [rel hint]                   ; 043B _ 48: 8B. 05, 00000000(rel)
        mov     eax, dword [rax+8H]                     ; 0442 _ 8B. 40, 08
        cmp     eax, 1                                  ; 0445 _ 83. F8, 01
        jnz     ?_028                                   ; 0448 _ 75, 2C
        mov     rax, qword [rbp-8H]                     ; 044A _ 48: 8B. 45, F8
        mov     eax, dword [rax]                        ; 044E _ 8B. 00
        movsxd  rdx, eax                                ; 0450 _ 48: 63. D0
        mov     rax, qword [rel hint]                   ; 0453 _ 48: 8B. 05, 00000000(rel)
        mov     rax, qword [rax]                        ; 045A _ 48: 8B. 00
        cmp     rdx, rax                                ; 045D _ 48: 39. C2
        jnz     ?_028                                   ; 0460 _ 75, 14
        cmp     dword [rbp-24H], 0                      ; 0462 _ 83. 7D, DC, 00
        jz      ?_028                                   ; 0466 _ 74, 0E
        mov     rax, qword [rel hint]                   ; 0468 _ 48: 8B. 05, 00000000(rel)
        mov     dword [rax+8H], 2                       ; 046F _ C7. 40, 08, 00000002
?_028:  add     qword [rbp-8H], 16                      ; 0476 _ 48: 83. 45, F8, 10
?_029:  mov     rax, qword [rbp-8H]                     ; 047B _ 48: 8B. 45, F8
        mov     eax, dword [rax]                        ; 047F _ 8B. 00
        test    eax, eax                                ; 0481 _ 85. C0
        jz      ?_030                                   ; 0483 _ 74, 0D
        mov     rax, qword [rbp-8H]                     ; 0485 _ 48: 8B. 45, F8
        mov     eax, dword [rax]                        ; 0489 _ 8B. 00
        cmp     eax, 1073742172                         ; 048B _ 3D, 4000015C
        jle     ?_027                                   ; 0490 _ 7E, 85
?_030:  mov     rax, qword [rbp-8H]                     ; 0492 _ 48: 8B. 45, F8
        mov     dword [rax], 0                          ; 0496 _ C7. 00, 00000000
        mov     rax, qword [rbp-18H]                    ; 049C _ 48: 8B. 45, E8
        pop     rbp                                     ; 04A0 _ 5D
        ret                                             ; 04A1 _ C3

scalarvect:; Local function
        push    rbp                                     ; 04A2 _ 55
        mov     rbp, rsp                                ; 04A3 _ 48: 89. E5
        sub     rsp, 16                                 ; 04A6 _ 48: 83. EC, 10
        mov     qword [rbp-8H], rdi                     ; 04AA _ 48: 89. 7D, F8
        call    begintemp                               ; 04AE _ E8, FFFFFC14
        mov     rax, qword [rbp-8H]                     ; 04B3 _ 48: 8B. 45, F8
        mov     rsi, rax                                ; 04B7 _ 48: 89. C6
        mov     edi, 346                                ; 04BA _ BF, 0000015A
        call    addtotemp                               ; 04BF _ E8, FFFFFC2B
        call    finishtemp                              ; 04C4 _ E8, FFFFFCC5
        leave                                           ; 04C9 _ C9
        ret                                             ; 04CA _ C3

unknown_expr:; Local function
        push    rbp                                     ; 04CB _ 55
        mov     rbp, rsp                                ; 04CC _ 48: 89. E5
        call    begintemp                               ; 04CF _ E8, FFFFFBF3
        mov     esi, 1                                  ; 04D4 _ BE, 00000001
        mov     edi, 345                                ; 04D9 _ BF, 00000159
        call    addtotemp                               ; 04DE _ E8, FFFFFC0C
        call    finishtemp                              ; 04E3 _ E8, FFFFFCA6
        pop     rbp                                     ; 04E8 _ 5D
        ret                                             ; 04E9 _ C3

segment_part:; Local function
        push    rbp                                     ; 04EA _ 55
        mov     rbp, rsp                                ; 04EB _ 48: 89. E5
        sub     rsp, 32                                 ; 04EE _ 48: 83. EC, 20
        mov     qword [rbp-18H], rdi                    ; 04F2 _ 48: 89. 7D, E8
        mov     rax, qword [rbp-18H]                    ; 04F6 _ 48: 8B. 45, E8
        mov     rdi, rax                                ; 04FA _ 48: 89. C7
        call    is_unknown                              ; 04FD _ E8, 00000000(PLT r)
        test    al, al                                  ; 0502 _ 84. C0
        jz      ?_031                                   ; 0504 _ 74, 0A
        call    unknown_expr                            ; 0506 _ E8, FFFFFFC0
        jmp     ?_038                                   ; 050B _ E9, 000000EF

?_031:  mov     rax, qword [rbp-18H]                    ; 0510 _ 48: 8B. 45, E8
        mov     rdi, rax                                ; 0514 _ 48: 89. C7
        call    is_reloc                                ; 0517 _ E8, 00000000(PLT r)
        xor     eax, 01H                                ; 051C _ 83. F0, 01
        test    al, al                                  ; 051F _ 84. C0
        jz      ?_032                                   ; 0521 _ 74, 1E
        lea     rax, [rel ?_284]                        ; 0523 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 052A _ 48: 89. C7
        mov     eax, 0                                  ; 052D _ B8, 00000000
        call    nasm_nonfatal                           ; 0532 _ E8, 00000000(PLT r)
        mov     eax, 0                                  ; 0537 _ B8, 00000000
        jmp     ?_038                                   ; 053C _ E9, 000000BE

?_032:  mov     rax, qword [rbp-18H]                    ; 0541 _ 48: 8B. 45, E8
        mov     rdi, rax                                ; 0545 _ 48: 89. C7
        call    reloc_seg                               ; 0548 _ E8, 00000000(PLT r)
        mov     dword [rbp-8H], eax                     ; 054D _ 89. 45, F8
        cmp     dword [rbp-8H], -1                      ; 0550 _ 83. 7D, F8, FF
        jnz     ?_033                                   ; 0554 _ 75, 1E
        lea     rax, [rel ?_284]                        ; 0556 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 055D _ 48: 89. C7
        mov     eax, 0                                  ; 0560 _ B8, 00000000
        call    nasm_nonfatal                           ; 0565 _ E8, 00000000(PLT r)
        mov     eax, 0                                  ; 056A _ B8, 00000000
        jmp     ?_038                                   ; 056F _ E9, 0000008B

?_033:  mov     eax, dword [rbp-8H]                     ; 0574 _ 8B. 45, F8
        cdqe                                            ; 0577 _ 48: 98
        and     eax, 40000000H                          ; 0579 _ 25, 40000000
        test    rax, rax                                ; 057E _ 48: 85. C0
        jz      ?_034                                   ; 0581 _ 74, 14
        mov     eax, dword [rbp-8H]                     ; 0583 _ 8B. 45, F8
        and     eax, 0BFFFFFFFH                         ; 0586 _ 25, BFFFFFFF
        cdqe                                            ; 058B _ 48: 98
        mov     rdi, rax                                ; 058D _ 48: 89. C7
        call    scalarvect                              ; 0590 _ E8, FFFFFF0D
        jmp     ?_038                                   ; 0595 _ EB, 68

?_034:  mov     eax, dword [rbp-8H]                     ; 0597 _ 8B. 45, F8
        and     eax, 01H                                ; 059A _ 83. E0, 01
        test    eax, eax                                ; 059D _ 85. C0
        jz      ?_035                                   ; 059F _ 74, 1B
        lea     rax, [rel ?_285]                        ; 05A1 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 05A8 _ 48: 89. C7
        mov     eax, 0                                  ; 05AB _ B8, 00000000
        call    nasm_nonfatal                           ; 05B0 _ E8, 00000000(PLT r)
        mov     eax, 0                                  ; 05B5 _ B8, 00000000
        jmp     ?_038                                   ; 05BA _ EB, 43

?_035:  mov     rax, qword [rel ofmt]                   ; 05BC _ 48: 8B. 05, 00000000(rel)
        mov     rax, qword [rax+70H]                    ; 05C3 _ 48: 8B. 40, 70
        mov     edx, dword [rbp-8H]                     ; 05C7 _ 8B. 55, F8
        add     edx, 1                                  ; 05CA _ 83. C2, 01
        mov     edi, edx                                ; 05CD _ 89. D7
        call    rax                                     ; 05CF _ FF. D0
        mov     dword [rbp-4H], eax                     ; 05D1 _ 89. 45, FC
        call    begintemp                               ; 05D4 _ E8, FFFFFAEE
        cmp     dword [rbp-4H], -1                      ; 05D9 _ 83. 7D, FC, FF
        jz      ?_036                                   ; 05DD _ 74, 0A
        mov     eax, dword [rbp-4H]                     ; 05DF _ 8B. 45, FC
        add     eax, 349                                ; 05E2 _ 05, 0000015D
        jmp     ?_037                                   ; 05E7 _ EB, 05

?_036:  mov     eax, 345                                ; 05E9 _ B8, 00000159
?_037:  mov     esi, 1                                  ; 05EE _ BE, 00000001
        mov     edi, eax                                ; 05F3 _ 89. C7
        call    addtotemp                               ; 05F5 _ E8, FFFFFAF5
        call    finishtemp                              ; 05FA _ E8, FFFFFB8F
?_038:  leave                                           ; 05FF _ C9
        ret                                             ; 0600 _ C3

scan:   ; Local function
        push    rbp                                     ; 0601 _ 55
        mov     rbp, rsp                                ; 0602 _ 48: 89. E5
        mov     rcx, qword [rel scanfunc]               ; 0605 _ 48: 8B. 0D, 00000000(rel)
        mov     rdx, qword [rel tokval]                 ; 060C _ 48: 8B. 15, 00000000(rel)
        mov     rax, qword [rel scpriv]                 ; 0613 _ 48: 8B. 05, 00000000(rel)
        mov     rsi, rdx                                ; 061A _ 48: 89. D6
        mov     rdi, rax                                ; 061D _ 48: 89. C7
        call    rcx                                     ; 0620 _ FF. D1
        mov     dword [rel tt], eax                     ; 0622 _ 89. 05, 00000000(rel)
        mov     eax, dword [rel tt]                     ; 0628 _ 8B. 05, 00000000(rel)
        pop     rbp                                     ; 062E _ 5D
        ret                                             ; 062F _ C3

bexpr:  ; Local function
        push    rbp                                     ; 0630 _ 55
        mov     rbp, rsp                                ; 0631 _ 48: 89. E5
        call    cexpr                                   ; 0634 _ E8, 00000002
        pop     rbp                                     ; 0639 _ 5D
        ret                                             ; 063A _ C3

cexpr:  ; Local function
        push    rbp                                     ; 063B _ 55
        mov     rbp, rsp                                ; 063C _ 48: 89. E5
        sub     rsp, 32                                 ; 063F _ 48: 83. EC, 20
        call    rexp0                                   ; 0643 _ E8, 000000F2
        mov     qword [rbp-18H], rax                    ; 0648 _ 48: 89. 45, E8
        cmp     qword [rbp-18H], 0                      ; 064C _ 48: 83. 7D, E8, 00
        jnz     ?_039                                   ; 0651 _ 75, 0A
        mov     eax, 0                                  ; 0653 _ B8, 00000000
        jmp     ?_047                                   ; 0658 _ E9, 000000DB

?_039:  mov     eax, dword [rel tt]                     ; 065D _ 8B. 05, 00000000(rel)
        cmp     eax, 63                                 ; 0663 _ 83. F8, 3F
        jne     ?_046                                   ; 0666 _ 0F 85, 000000C8
        call    scan                                    ; 066C _ E8, FFFFFF90
        call    bexpr                                   ; 0671 _ E8, FFFFFFBA
        mov     qword [rbp-10H], rax                    ; 0676 _ 48: 89. 45, F0
        cmp     qword [rbp-10H], 0                      ; 067A _ 48: 83. 7D, F0, 00
        jnz     ?_040                                   ; 067F _ 75, 0A
        mov     eax, 0                                  ; 0681 _ B8, 00000000
        jmp     ?_047                                   ; 0686 _ E9, 000000AD

?_040:  mov     eax, dword [rel tt]                     ; 068B _ 8B. 05, 00000000(rel)
        cmp     eax, 58                                 ; 0691 _ 83. F8, 3A
        jz      ?_041                                   ; 0694 _ 74, 1E
        lea     rax, [rel ?_286]                        ; 0696 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 069D _ 48: 89. C7
        mov     eax, 0                                  ; 06A0 _ B8, 00000000
        call    nasm_nonfatal                           ; 06A5 _ E8, 00000000(PLT r)
        mov     eax, 0                                  ; 06AA _ B8, 00000000
        jmp     ?_047                                   ; 06AF _ E9, 00000084

?_041:  call    scan                                    ; 06B4 _ E8, FFFFFF48
        call    cexpr                                   ; 06B9 _ E8, FFFFFF7D
        mov     qword [rbp-8H], rax                     ; 06BE _ 48: 89. 45, F8
        cmp     qword [rbp-8H], 0                       ; 06C2 _ 48: 83. 7D, F8, 00
        jnz     ?_042                                   ; 06C7 _ 75, 07
        mov     eax, 0                                  ; 06C9 _ B8, 00000000
        jmp     ?_047                                   ; 06CE _ EB, 68

?_042:  mov     rax, qword [rbp-18H]                    ; 06D0 _ 48: 8B. 45, E8
        mov     rdi, rax                                ; 06D4 _ 48: 89. C7
        call    is_simple                               ; 06D7 _ E8, 00000000(PLT r)
        test    al, al                                  ; 06DC _ 84. C0
        jz      ?_044                                   ; 06DE _ 74, 25
        mov     rax, qword [rbp-18H]                    ; 06E0 _ 48: 8B. 45, E8
        mov     rdi, rax                                ; 06E4 _ 48: 89. C7
        call    reloc_value                             ; 06E7 _ E8, 00000000(PLT r)
        test    rax, rax                                ; 06EC _ 48: 85. C0
        jz      ?_043                                   ; 06EF _ 74, 0A
        mov     rax, qword [rbp-10H]                    ; 06F1 _ 48: 8B. 45, F0
        mov     qword [rbp-18H], rax                    ; 06F5 _ 48: 89. 45, E8
        jmp     ?_046                                   ; 06F9 _ EB, 39

?_043:  mov     rax, qword [rbp-8H]                     ; 06FB _ 48: 8B. 45, F8
        mov     qword [rbp-18H], rax                    ; 06FF _ 48: 89. 45, E8
        jmp     ?_046                                   ; 0703 _ EB, 2F

?_044:  mov     rax, qword [rbp-18H]                    ; 0705 _ 48: 8B. 45, E8
        mov     rdi, rax                                ; 0709 _ 48: 89. C7
        call    is_just_unknown                         ; 070C _ E8, 00000000(PLT r)
        test    al, al                                  ; 0711 _ 84. C0
        jz      ?_045                                   ; 0713 _ 74, 0B
        call    unknown_expr                            ; 0715 _ E8, FFFFFDB1
        mov     qword [rbp-18H], rax                    ; 071A _ 48: 89. 45, E8
        jmp     ?_046                                   ; 071E _ EB, 14

?_045:  lea     rax, [rel ?_287]                        ; 0720 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 0727 _ 48: 89. C7
        mov     eax, 0                                  ; 072A _ B8, 00000000
        call    nasm_nonfatal                           ; 072F _ E8, 00000000(PLT r)
?_046:  mov     rax, qword [rbp-18H]                    ; 0734 _ 48: 8B. 45, E8
?_047:  leave                                           ; 0738 _ C9
        ret                                             ; 0739 _ C3

rexp0:  ; Local function
        push    rbp                                     ; 073A _ 55
        mov     rbp, rsp                                ; 073B _ 48: 89. E5
        sub     rsp, 16                                 ; 073E _ 48: 83. EC, 10
        call    rexp1                                   ; 0742 _ E8, 00000116
        mov     qword [rbp-10H], rax                    ; 0747 _ 48: 89. 45, F0
        cmp     qword [rbp-10H], 0                      ; 074B _ 48: 83. 7D, F0, 00
        jne     ?_058                                   ; 0750 _ 0F 85, 000000F0
        mov     eax, 0                                  ; 0756 _ B8, 00000000
        jmp     ?_059                                   ; 075B _ E9, 000000FB

?_048:  call    scan                                    ; 0760 _ E8, FFFFFE9C
        call    rexp1                                   ; 0765 _ E8, 000000F3
        mov     qword [rbp-8H], rax                     ; 076A _ 48: 89. 45, F8
        cmp     qword [rbp-8H], 0                       ; 076E _ 48: 83. 7D, F8, 00
        jnz     ?_049                                   ; 0773 _ 75, 0A
        mov     eax, 0                                  ; 0775 _ B8, 00000000
        jmp     ?_059                                   ; 077A _ E9, 000000DC

?_049:  mov     rax, qword [rbp-10H]                    ; 077F _ 48: 8B. 45, F0
        mov     rdi, rax                                ; 0783 _ 48: 89. C7
        call    is_simple                               ; 0786 _ E8, 00000000(PLT r)
        xor     eax, 01H                                ; 078B _ 83. F0, 01
        test    al, al                                  ; 078E _ 84. C0
        jz      ?_050                                   ; 0790 _ 74, 13
        mov     rax, qword [rbp-10H]                    ; 0792 _ 48: 8B. 45, F0
        mov     rdi, rax                                ; 0796 _ 48: 89. C7
        call    is_just_unknown                         ; 0799 _ E8, 00000000(PLT r)
        xor     eax, 01H                                ; 079E _ 83. F0, 01
        test    al, al                                  ; 07A1 _ 84. C0
        jnz     ?_051                                   ; 07A3 _ 75, 26
?_050:  mov     rax, qword [rbp-8H]                     ; 07A5 _ 48: 8B. 45, F8
        mov     rdi, rax                                ; 07A9 _ 48: 89. C7
        call    is_simple                               ; 07AC _ E8, 00000000(PLT r)
        xor     eax, 01H                                ; 07B1 _ 83. F0, 01
        test    al, al                                  ; 07B4 _ 84. C0
        jz      ?_052                                   ; 07B6 _ 74, 27
        mov     rax, qword [rbp-8H]                     ; 07B8 _ 48: 8B. 45, F8
        mov     rdi, rax                                ; 07BC _ 48: 89. C7
        call    is_just_unknown                         ; 07BF _ E8, 00000000(PLT r)
        xor     eax, 01H                                ; 07C4 _ 83. F0, 01
        test    al, al                                  ; 07C7 _ 84. C0
        jz      ?_052                                   ; 07C9 _ 74, 14
?_051:  lea     rax, [rel ?_288]                        ; 07CB _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 07D2 _ 48: 89. C7
        mov     eax, 0                                  ; 07D5 _ B8, 00000000
        call    nasm_nonfatal                           ; 07DA _ E8, 00000000(PLT r)
?_052:  mov     rax, qword [rbp-10H]                    ; 07DF _ 48: 8B. 45, F0
        mov     rdi, rax                                ; 07E3 _ 48: 89. C7
        call    is_just_unknown                         ; 07E6 _ E8, 00000000(PLT r)
        test    al, al                                  ; 07EB _ 84. C0
        jnz     ?_053                                   ; 07ED _ 75, 10
        mov     rax, qword [rbp-8H]                     ; 07EF _ 48: 8B. 45, F8
        mov     rdi, rax                                ; 07F3 _ 48: 89. C7
        call    is_just_unknown                         ; 07F6 _ E8, 00000000(PLT r)
        test    al, al                                  ; 07FB _ 84. C0
        jz      ?_054                                   ; 07FD _ 74, 0B
?_053:  call    unknown_expr                            ; 07FF _ E8, FFFFFCC7
        mov     qword [rbp-10H], rax                    ; 0804 _ 48: 89. 45, F0
        jmp     ?_058                                   ; 0808 _ EB, 3C

?_054:  mov     rax, qword [rbp-10H]                    ; 080A _ 48: 8B. 45, F0
        mov     rdi, rax                                ; 080E _ 48: 89. C7
        call    reloc_value                             ; 0811 _ E8, 00000000(PLT r)
        test    rax, rax                                ; 0816 _ 48: 85. C0
        jnz     ?_055                                   ; 0819 _ 75, 11
        mov     rax, qword [rbp-8H]                     ; 081B _ 48: 8B. 45, F8
        mov     rdi, rax                                ; 081F _ 48: 89. C7
        call    reloc_value                             ; 0822 _ E8, 00000000(PLT r)
        test    rax, rax                                ; 0827 _ 48: 85. C0
        jz      ?_056                                   ; 082A _ 74, 07
?_055:  mov     eax, 1                                  ; 082C _ B8, 00000001
        jmp     ?_057                                   ; 0831 _ EB, 05

?_056:  mov     eax, 0                                  ; 0833 _ B8, 00000000
?_057:  cdqe                                            ; 0838 _ 48: 98
        mov     rdi, rax                                ; 083A _ 48: 89. C7
        call    scalarvect                              ; 083D _ E8, FFFFFC60
        mov     qword [rbp-10H], rax                    ; 0842 _ 48: 89. 45, F0
?_058:  mov     eax, dword [rel tt]                     ; 0846 _ 8B. 05, 00000000(rel)
        cmp     eax, 266                                ; 084C _ 3D, 0000010A
        je      ?_048                                   ; 0851 _ 0F 84, FFFFFF09
        mov     rax, qword [rbp-10H]                    ; 0857 _ 48: 8B. 45, F0
?_059:  leave                                           ; 085B _ C9
        ret                                             ; 085C _ C3

rexp1:  ; Local function
        push    rbp                                     ; 085D _ 55
        mov     rbp, rsp                                ; 085E _ 48: 89. E5
        push    rbx                                     ; 0861 _ 53
        sub     rsp, 24                                 ; 0862 _ 48: 83. EC, 18
        call    rexp2                                   ; 0866 _ E8, 00000118
        mov     qword [rbp-20H], rax                    ; 086B _ 48: 89. 45, E0
        cmp     qword [rbp-20H], 0                      ; 086F _ 48: 83. 7D, E0, 00
        jne     ?_067                                   ; 0874 _ 0F 85, 000000EE
        mov     eax, 0                                  ; 087A _ B8, 00000000
        jmp     ?_068                                   ; 087F _ E9, 000000F9

?_060:  call    scan                                    ; 0884 _ E8, FFFFFD78
        call    rexp2                                   ; 0889 _ E8, 000000F5
        mov     qword [rbp-18H], rax                    ; 088E _ 48: 89. 45, E8
        cmp     qword [rbp-18H], 0                      ; 0892 _ 48: 83. 7D, E8, 00
        jnz     ?_061                                   ; 0897 _ 75, 0A
        mov     eax, 0                                  ; 0899 _ B8, 00000000
        jmp     ?_068                                   ; 089E _ E9, 000000DA

?_061:  mov     rax, qword [rbp-20H]                    ; 08A3 _ 48: 8B. 45, E0
        mov     rdi, rax                                ; 08A7 _ 48: 89. C7
        call    is_simple                               ; 08AA _ E8, 00000000(PLT r)
        xor     eax, 01H                                ; 08AF _ 83. F0, 01
        test    al, al                                  ; 08B2 _ 84. C0
        jz      ?_062                                   ; 08B4 _ 74, 13
        mov     rax, qword [rbp-20H]                    ; 08B6 _ 48: 8B. 45, E0
        mov     rdi, rax                                ; 08BA _ 48: 89. C7
        call    is_just_unknown                         ; 08BD _ E8, 00000000(PLT r)
        xor     eax, 01H                                ; 08C2 _ 83. F0, 01
        test    al, al                                  ; 08C5 _ 84. C0
        jnz     ?_063                                   ; 08C7 _ 75, 26
?_062:  mov     rax, qword [rbp-18H]                    ; 08C9 _ 48: 8B. 45, E8
        mov     rdi, rax                                ; 08CD _ 48: 89. C7
        call    is_simple                               ; 08D0 _ E8, 00000000(PLT r)
        xor     eax, 01H                                ; 08D5 _ 83. F0, 01
        test    al, al                                  ; 08D8 _ 84. C0
        jz      ?_064                                   ; 08DA _ 74, 27
        mov     rax, qword [rbp-18H]                    ; 08DC _ 48: 8B. 45, E8
        mov     rdi, rax                                ; 08E0 _ 48: 89. C7
        call    is_just_unknown                         ; 08E3 _ E8, 00000000(PLT r)
        xor     eax, 01H                                ; 08E8 _ 83. F0, 01
        test    al, al                                  ; 08EB _ 84. C0
        jz      ?_064                                   ; 08ED _ 74, 14
?_063:  lea     rax, [rel ?_289]                        ; 08EF _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 08F6 _ 48: 89. C7
        mov     eax, 0                                  ; 08F9 _ B8, 00000000
        call    nasm_nonfatal                           ; 08FE _ E8, 00000000(PLT r)
?_064:  mov     rax, qword [rbp-20H]                    ; 0903 _ 48: 8B. 45, E0
        mov     rdi, rax                                ; 0907 _ 48: 89. C7
        call    is_just_unknown                         ; 090A _ E8, 00000000(PLT r)
        test    al, al                                  ; 090F _ 84. C0
        jnz     ?_065                                   ; 0911 _ 75, 10
        mov     rax, qword [rbp-18H]                    ; 0913 _ 48: 8B. 45, E8
        mov     rdi, rax                                ; 0917 _ 48: 89. C7
        call    is_just_unknown                         ; 091A _ E8, 00000000(PLT r)
        test    al, al                                  ; 091F _ 84. C0
        jz      ?_066                                   ; 0921 _ 74, 0B
?_065:  call    unknown_expr                            ; 0923 _ E8, FFFFFBA3
        mov     qword [rbp-20H], rax                    ; 0928 _ 48: 89. 45, E0
        jmp     ?_067                                   ; 092C _ EB, 3A

?_066:  mov     rax, qword [rbp-20H]                    ; 092E _ 48: 8B. 45, E0
        mov     rdi, rax                                ; 0932 _ 48: 89. C7
        call    reloc_value                             ; 0935 _ E8, 00000000(PLT r)
        test    rax, rax                                ; 093A _ 48: 85. C0
        sete    al                                      ; 093D _ 0F 94. C0
        movzx   ebx, al                                 ; 0940 _ 0F B6. D8
        mov     rax, qword [rbp-18H]                    ; 0943 _ 48: 8B. 45, E8
        mov     rdi, rax                                ; 0947 _ 48: 89. C7
        call    reloc_value                             ; 094A _ E8, 00000000(PLT r)
        test    rax, rax                                ; 094F _ 48: 85. C0
        sete    al                                      ; 0952 _ 0F 94. C0
        movzx   eax, al                                 ; 0955 _ 0F B6. C0
        xor     eax, ebx                                ; 0958 _ 31. D8
        cdqe                                            ; 095A _ 48: 98
        mov     rdi, rax                                ; 095C _ 48: 89. C7
        call    scalarvect                              ; 095F _ E8, FFFFFB3E
        mov     qword [rbp-20H], rax                    ; 0964 _ 48: 89. 45, E0
?_067:  mov     eax, dword [rel tt]                     ; 0968 _ 8B. 05, 00000000(rel)
        cmp     eax, 267                                ; 096E _ 3D, 0000010B
        je      ?_060                                   ; 0973 _ 0F 84, FFFFFF0B
        mov     rax, qword [rbp-20H]                    ; 0979 _ 48: 8B. 45, E0
?_068:  mov     rbx, qword [rbp-8H]                     ; 097D _ 48: 8B. 5D, F8
        leave                                           ; 0981 _ C9
        ret                                             ; 0982 _ C3

rexp2:  ; Local function
        push    rbp                                     ; 0983 _ 55
        mov     rbp, rsp                                ; 0984 _ 48: 89. E5
        sub     rsp, 16                                 ; 0987 _ 48: 83. EC, 10
        call    rexp3                                   ; 098B _ E8, 00000116
        mov     qword [rbp-10H], rax                    ; 0990 _ 48: 89. 45, F0
        cmp     qword [rbp-10H], 0                      ; 0994 _ 48: 83. 7D, F0, 00
        jne     ?_078                                   ; 0999 _ 0F 85, 000000F0
        mov     eax, 0                                  ; 099F _ B8, 00000000
        jmp     ?_079                                   ; 09A4 _ E9, 000000FB

?_069:  call    scan                                    ; 09A9 _ E8, FFFFFC53
        call    rexp3                                   ; 09AE _ E8, 000000F3
        mov     qword [rbp-8H], rax                     ; 09B3 _ 48: 89. 45, F8
        cmp     qword [rbp-8H], 0                       ; 09B7 _ 48: 83. 7D, F8, 00
        jnz     ?_070                                   ; 09BC _ 75, 0A
        mov     eax, 0                                  ; 09BE _ B8, 00000000
        jmp     ?_079                                   ; 09C3 _ E9, 000000DC

?_070:  mov     rax, qword [rbp-10H]                    ; 09C8 _ 48: 8B. 45, F0
        mov     rdi, rax                                ; 09CC _ 48: 89. C7
        call    is_simple                               ; 09CF _ E8, 00000000(PLT r)
        xor     eax, 01H                                ; 09D4 _ 83. F0, 01
        test    al, al                                  ; 09D7 _ 84. C0
        jz      ?_071                                   ; 09D9 _ 74, 13
        mov     rax, qword [rbp-10H]                    ; 09DB _ 48: 8B. 45, F0
        mov     rdi, rax                                ; 09DF _ 48: 89. C7
        call    is_just_unknown                         ; 09E2 _ E8, 00000000(PLT r)
        xor     eax, 01H                                ; 09E7 _ 83. F0, 01
        test    al, al                                  ; 09EA _ 84. C0
        jnz     ?_072                                   ; 09EC _ 75, 26
?_071:  mov     rax, qword [rbp-8H]                     ; 09EE _ 48: 8B. 45, F8
        mov     rdi, rax                                ; 09F2 _ 48: 89. C7
        call    is_simple                               ; 09F5 _ E8, 00000000(PLT r)
        xor     eax, 01H                                ; 09FA _ 83. F0, 01
        test    al, al                                  ; 09FD _ 84. C0
        jz      ?_073                                   ; 09FF _ 74, 27
        mov     rax, qword [rbp-8H]                     ; 0A01 _ 48: 8B. 45, F8
        mov     rdi, rax                                ; 0A05 _ 48: 89. C7
        call    is_just_unknown                         ; 0A08 _ E8, 00000000(PLT r)
        xor     eax, 01H                                ; 0A0D _ 83. F0, 01
        test    al, al                                  ; 0A10 _ 84. C0
        jz      ?_073                                   ; 0A12 _ 74, 14
?_072:  lea     rax, [rel ?_290]                        ; 0A14 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 0A1B _ 48: 89. C7
        mov     eax, 0                                  ; 0A1E _ B8, 00000000
        call    nasm_nonfatal                           ; 0A23 _ E8, 00000000(PLT r)
?_073:  mov     rax, qword [rbp-10H]                    ; 0A28 _ 48: 8B. 45, F0
        mov     rdi, rax                                ; 0A2C _ 48: 89. C7
        call    is_just_unknown                         ; 0A2F _ E8, 00000000(PLT r)
        test    al, al                                  ; 0A34 _ 84. C0
        jnz     ?_074                                   ; 0A36 _ 75, 10
        mov     rax, qword [rbp-8H]                     ; 0A38 _ 48: 8B. 45, F8
        mov     rdi, rax                                ; 0A3C _ 48: 89. C7
        call    is_just_unknown                         ; 0A3F _ E8, 00000000(PLT r)
        test    al, al                                  ; 0A44 _ 84. C0
        jz      ?_075                                   ; 0A46 _ 74, 0B
?_074:  call    unknown_expr                            ; 0A48 _ E8, FFFFFA7E
        mov     qword [rbp-10H], rax                    ; 0A4D _ 48: 89. 45, F0
        jmp     ?_078                                   ; 0A51 _ EB, 3C

?_075:  mov     rax, qword [rbp-10H]                    ; 0A53 _ 48: 8B. 45, F0
        mov     rdi, rax                                ; 0A57 _ 48: 89. C7
        call    reloc_value                             ; 0A5A _ E8, 00000000(PLT r)
        test    rax, rax                                ; 0A5F _ 48: 85. C0
        jz      ?_076                                   ; 0A62 _ 74, 18
        mov     rax, qword [rbp-8H]                     ; 0A64 _ 48: 8B. 45, F8
        mov     rdi, rax                                ; 0A68 _ 48: 89. C7
        call    reloc_value                             ; 0A6B _ E8, 00000000(PLT r)
        test    rax, rax                                ; 0A70 _ 48: 85. C0
        jz      ?_076                                   ; 0A73 _ 74, 07
        mov     eax, 1                                  ; 0A75 _ B8, 00000001
        jmp     ?_077                                   ; 0A7A _ EB, 05

?_076:  mov     eax, 0                                  ; 0A7C _ B8, 00000000
?_077:  cdqe                                            ; 0A81 _ 48: 98
        mov     rdi, rax                                ; 0A83 _ 48: 89. C7
        call    scalarvect                              ; 0A86 _ E8, FFFFFA17
        mov     qword [rbp-10H], rax                    ; 0A8B _ 48: 89. 45, F0
?_078:  mov     eax, dword [rel tt]                     ; 0A8F _ 8B. 05, 00000000(rel)
        cmp     eax, 265                                ; 0A95 _ 3D, 00000109
        je      ?_069                                   ; 0A9A _ 0F 84, FFFFFF09
        mov     rax, qword [rbp-10H]                    ; 0AA0 _ 48: 8B. 45, F0
?_079:  leave                                           ; 0AA4 _ C9
        ret                                             ; 0AA5 _ C3

rexp3:  ; Local function
        push    rbp                                     ; 0AA6 _ 55
        mov     rbp, rsp                                ; 0AA7 _ 48: 89. E5
        sub     rsp, 48                                 ; 0AAA _ 48: 83. EC, 30
        call    expr0                                   ; 0AAE _ E8, 000002E9
        mov     qword [rbp-20H], rax                    ; 0AB3 _ 48: 89. 45, E0
        cmp     qword [rbp-20H], 0                      ; 0AB7 _ 48: 83. 7D, E0, 00
        jne     ?_111                                   ; 0ABC _ 0F 85, 00000263
        mov     eax, 0                                  ; 0AC2 _ B8, 00000000
        jmp     ?_112                                   ; 0AC7 _ E9, 000002CE

?_080:  mov     eax, dword [rel tt]                     ; 0ACC _ 8B. 05, 00000000(rel)
        mov     dword [rbp-24H], eax                    ; 0AD2 _ 89. 45, DC
        call    scan                                    ; 0AD5 _ E8, FFFFFB27
        call    expr0                                   ; 0ADA _ E8, 000002BD
        mov     qword [rbp-10H], rax                    ; 0ADF _ 48: 89. 45, F0
        cmp     qword [rbp-10H], 0                      ; 0AE3 _ 48: 83. 7D, F0, 00
        jnz     ?_081                                   ; 0AE8 _ 75, 0A
        mov     eax, 0                                  ; 0AEA _ B8, 00000000
        jmp     ?_112                                   ; 0AEF _ E9, 000002A6

?_081:  mov     rax, qword [rbp-10H]                    ; 0AF4 _ 48: 8B. 45, F0
        mov     edx, 0                                  ; 0AF8 _ BA, 00000000
        mov     rsi, -1                                 ; 0AFD _ 48: C7. C6, FFFFFFFF
        mov     rdi, rax                                ; 0B04 _ 48: 89. C7
        call    scalar_mult                             ; 0B07 _ E8, FFFFF8F2
        mov     rdx, rax                                ; 0B0C _ 48: 89. C2
        mov     rax, qword [rbp-20H]                    ; 0B0F _ 48: 8B. 45, E0
        mov     rsi, rdx                                ; 0B13 _ 48: 89. D6
        mov     rdi, rax                                ; 0B16 _ 48: 89. C7
        call    add_vectors                             ; 0B19 _ E8, FFFFF6FB
        mov     qword [rbp-20H], rax                    ; 0B1E _ 48: 89. 45, E0
        cmp     dword [rbp-24H], 61                     ; 0B22 _ 83. 7D, DC, 3D
        jz      ?_082                                   ; 0B26 _ 74, 09
        cmp     dword [rbp-24H], 263                    ; 0B28 _ 81. 7D, DC, 00000107
        jnz     ?_086                                   ; 0B2F _ 75, 6A
?_082:  mov     rax, qword [rbp-20H]                    ; 0B31 _ 48: 8B. 45, E0
        mov     rdi, rax                                ; 0B35 _ 48: 89. C7
        call    is_unknown                              ; 0B38 _ E8, 00000000(PLT r)
        test    al, al                                  ; 0B3D _ 84. C0
        jz      ?_083                                   ; 0B3F _ 74, 0D
        mov     qword [rbp-18H], -1                     ; 0B41 _ 48: C7. 45, E8, FFFFFFFF
        jmp     ?_109                                   ; 0B49 _ E9, 000001B5

?_083:  mov     rax, qword [rbp-20H]                    ; 0B4E _ 48: 8B. 45, E0
        mov     rdi, rax                                ; 0B52 _ 48: 89. C7
        call    is_really_simple                        ; 0B55 _ E8, 00000000(PLT r)
        xor     eax, 01H                                ; 0B5A _ 83. F0, 01
        test    al, al                                  ; 0B5D _ 84. C0
        jnz     ?_084                                   ; 0B5F _ 75, 11
        mov     rax, qword [rbp-20H]                    ; 0B61 _ 48: 8B. 45, E0
        mov     rdi, rax                                ; 0B65 _ 48: 89. C7
        call    reloc_value                             ; 0B68 _ E8, 00000000(PLT r)
        test    rax, rax                                ; 0B6D _ 48: 85. C0
        jz      ?_085                                   ; 0B70 _ 74, 16
?_084:  cmp     dword [rbp-24H], 263                    ; 0B72 _ 81. 7D, DC, 00000107
        sete    al                                      ; 0B79 _ 0F 94. C0
        movzx   eax, al                                 ; 0B7C _ 0F B6. C0
        mov     qword [rbp-18H], rax                    ; 0B7F _ 48: 89. 45, E8
        jmp     ?_109                                   ; 0B83 _ E9, 0000017B

?_085:  cmp     dword [rbp-24H], 61                     ; 0B88 _ 83. 7D, DC, 3D
        sete    al                                      ; 0B8C _ 0F 94. C0
        movzx   eax, al                                 ; 0B8F _ 0F B6. C0
        mov     qword [rbp-18H], rax                    ; 0B92 _ 48: 89. 45, E8
        jmp     ?_109                                   ; 0B96 _ E9, 00000168

?_086:  mov     rax, qword [rbp-20H]                    ; 0B9B _ 48: 8B. 45, E0
        mov     rdi, rax                                ; 0B9F _ 48: 89. C7
        call    is_unknown                              ; 0BA2 _ E8, 00000000(PLT r)
        test    al, al                                  ; 0BA7 _ 84. C0
        jz      ?_087                                   ; 0BA9 _ 74, 0D
        mov     qword [rbp-18H], -1                     ; 0BAB _ 48: C7. 45, E8, FFFFFFFF
        jmp     ?_108                                   ; 0BB3 _ E9, 0000014A

?_087:  mov     rax, qword [rbp-20H]                    ; 0BB8 _ 48: 8B. 45, E0
        mov     rdi, rax                                ; 0BBC _ 48: 89. C7
        call    is_really_simple                        ; 0BBF _ E8, 00000000(PLT r)
        xor     eax, 01H                                ; 0BC4 _ 83. F0, 01
        test    al, al                                  ; 0BC7 _ 84. C0
        jz      ?_094                                   ; 0BC9 _ 74, 7F
        cmp     dword [rbp-24H], 262                    ; 0BCB _ 81. 7D, DC, 00000106
        jz      ?_092                                   ; 0BD2 _ 74, 4B
        cmp     dword [rbp-24H], 60                     ; 0BD4 _ 83. 7D, DC, 3C
        jz      ?_091                                   ; 0BD8 _ 74, 3C
        cmp     dword [rbp-24H], 261                    ; 0BDA _ 81. 7D, DC, 00000105
        jz      ?_090                                   ; 0BE1 _ 74, 2A
        cmp     dword [rbp-24H], 62                     ; 0BE3 _ 83. 7D, DC, 3E
        jz      ?_089                                   ; 0BE7 _ 74, 1B
        cmp     dword [rbp-24H], 264                    ; 0BE9 _ 81. 7D, DC, 00000108
        jnz     ?_088                                   ; 0BF0 _ 75, 09
        lea     rax, [rel ?_291]                        ; 0BF2 _ 48: 8D. 05, 00000000(rel)
        jmp     ?_093                                   ; 0BF9 _ EB, 2B

?_088:  lea     rax, [rel ?_292]                        ; 0BFB _ 48: 8D. 05, 00000000(rel)
        jmp     ?_093                                   ; 0C02 _ EB, 22

?_089:  lea     rax, [rel ?_293]                        ; 0C04 _ 48: 8D. 05, 00000000(rel)
        jmp     ?_093                                   ; 0C0B _ EB, 19

?_090:  lea     rax, [rel ?_294]                        ; 0C0D _ 48: 8D. 05, 00000000(rel)
        jmp     ?_093                                   ; 0C14 _ EB, 10

?_091:  lea     rax, [rel ?_295]                        ; 0C16 _ 48: 8D. 05, 00000000(rel)
        jmp     ?_093                                   ; 0C1D _ EB, 07

?_092:  lea     rax, [rel ?_296]                        ; 0C1F _ 48: 8D. 05, 00000000(rel)
?_093:  lea     rdx, [rel ?_297]                        ; 0C26 _ 48: 8D. 15, 00000000(rel)
        mov     rsi, rax                                ; 0C2D _ 48: 89. C6
        mov     rdi, rdx                                ; 0C30 _ 48: 89. D7
        mov     eax, 0                                  ; 0C33 _ B8, 00000000
        call    nasm_nonfatal                           ; 0C38 _ E8, 00000000(PLT r)
        mov     qword [rbp-18H], 0                      ; 0C3D _ 48: C7. 45, E8, 00000000
        jmp     ?_108                                   ; 0C45 _ E9, 000000B8

?_094:  mov     rax, qword [rbp-20H]                    ; 0C4A _ 48: 8B. 45, E0
        mov     rdi, rax                                ; 0C4E _ 48: 89. C7
        call    reloc_value                             ; 0C51 _ E8, 00000000(PLT r)
        mov     qword [rbp-8H], rax                     ; 0C56 _ 48: 89. 45, F8
        cmp     dword [rbp-24H], 264                    ; 0C5A _ 81. 7D, DC, 00000108
        jnz     ?_096                                   ; 0C61 _ 75, 27
        cmp     qword [rbp-8H], 0                       ; 0C63 _ 48: 83. 7D, F8, 00
        js      ?_095                                   ; 0C68 _ 78, 16
        cmp     qword [rbp-8H], 0                       ; 0C6A _ 48: 83. 7D, F8, 00
        setg    al                                      ; 0C6F _ 0F 9F. C0
        movzx   eax, al                                 ; 0C72 _ 0F B6. C0
        cdqe                                            ; 0C75 _ 48: 98
        mov     qword [rbp-18H], rax                    ; 0C77 _ 48: 89. 45, E8
        jmp     ?_108                                   ; 0C7B _ E9, 00000082

?_095:  mov     qword [rbp-18H], -1                     ; 0C80 _ 48: C7. 45, E8, FFFFFFFF
        jmp     ?_108                                   ; 0C88 _ EB, 78

?_096:  cmp     qword [rbp-8H], 0                       ; 0C8A _ 48: 83. 7D, F8, 00
        jnz     ?_100                                   ; 0C8F _ 75, 26
        cmp     dword [rbp-24H], 262                    ; 0C91 _ 81. 7D, DC, 00000106
        jz      ?_097                                   ; 0C98 _ 74, 09
        cmp     dword [rbp-24H], 261                    ; 0C9A _ 81. 7D, DC, 00000105
        jnz     ?_098                                   ; 0CA1 _ 75, 07
?_097:  mov     eax, 1                                  ; 0CA3 _ B8, 00000001
        jmp     ?_099                                   ; 0CA8 _ EB, 05

?_098:  mov     eax, 0                                  ; 0CAA _ B8, 00000000
?_099:  cdqe                                            ; 0CAF _ 48: 98
        mov     qword [rbp-18H], rax                    ; 0CB1 _ 48: 89. 45, E8
        jmp     ?_108                                   ; 0CB5 _ EB, 4B

?_100:  cmp     qword [rbp-8H], 0                       ; 0CB7 _ 48: 83. 7D, F8, 00
        jle     ?_104                                   ; 0CBC _ 7E, 23
        cmp     dword [rbp-24H], 261                    ; 0CBE _ 81. 7D, DC, 00000105
        jz      ?_101                                   ; 0CC5 _ 74, 06
        cmp     dword [rbp-24H], 62                     ; 0CC7 _ 83. 7D, DC, 3E
        jnz     ?_102                                   ; 0CCB _ 75, 07
?_101:  mov     eax, 1                                  ; 0CCD _ B8, 00000001
        jmp     ?_103                                   ; 0CD2 _ EB, 05

?_102:  mov     eax, 0                                  ; 0CD4 _ B8, 00000000
?_103:  cdqe                                            ; 0CD9 _ 48: 98
        mov     qword [rbp-18H], rax                    ; 0CDB _ 48: 89. 45, E8
        jmp     ?_108                                   ; 0CDF _ EB, 21

?_104:  cmp     dword [rbp-24H], 262                    ; 0CE1 _ 81. 7D, DC, 00000106
        jz      ?_105                                   ; 0CE8 _ 74, 06
        cmp     dword [rbp-24H], 60                     ; 0CEA _ 83. 7D, DC, 3C
        jnz     ?_106                                   ; 0CEE _ 75, 07
?_105:  mov     eax, 1                                  ; 0CF0 _ B8, 00000001
        jmp     ?_107                                   ; 0CF5 _ EB, 05

?_106:  mov     eax, 0                                  ; 0CF7 _ B8, 00000000
?_107:  cdqe                                            ; 0CFC _ 48: 98
        mov     qword [rbp-18H], rax                    ; 0CFE _ 48: 89. 45, E8
?_108:  nop                                             ; 0D02 _ 90
?_109:  cmp     qword [rbp-18H], -1                     ; 0D03 _ 48: 83. 7D, E8, FF
        jnz     ?_110                                   ; 0D08 _ 75, 0B
        call    unknown_expr                            ; 0D0A _ E8, FFFFF7BC
        mov     qword [rbp-20H], rax                    ; 0D0F _ 48: 89. 45, E0
        jmp     ?_111                                   ; 0D13 _ EB, 10

?_110:  mov     rax, qword [rbp-18H]                    ; 0D15 _ 48: 8B. 45, E8
        mov     rdi, rax                                ; 0D19 _ 48: 89. C7
        call    scalarvect                              ; 0D1C _ E8, FFFFF781
        mov     qword [rbp-20H], rax                    ; 0D21 _ 48: 89. 45, E0
?_111:  mov     eax, dword [rel tt]                     ; 0D25 _ 8B. 05, 00000000(rel)
        cmp     eax, 61                                 ; 0D2B _ 83. F8, 3D
        je      ?_080                                   ; 0D2E _ 0F 84, FFFFFD98
        mov     eax, dword [rel tt]                     ; 0D34 _ 8B. 05, 00000000(rel)
        cmp     eax, 60                                 ; 0D3A _ 83. F8, 3C
        je      ?_080                                   ; 0D3D _ 0F 84, FFFFFD89
        mov     eax, dword [rel tt]                     ; 0D43 _ 8B. 05, 00000000(rel)
        cmp     eax, 62                                 ; 0D49 _ 83. F8, 3E
        je      ?_080                                   ; 0D4C _ 0F 84, FFFFFD7A
        mov     eax, dword [rel tt]                     ; 0D52 _ 8B. 05, 00000000(rel)
        cmp     eax, 263                                ; 0D58 _ 3D, 00000107
        je      ?_080                                   ; 0D5D _ 0F 84, FFFFFD69
        mov     eax, dword [rel tt]                     ; 0D63 _ 8B. 05, 00000000(rel)
        cmp     eax, 262                                ; 0D69 _ 3D, 00000106
        je      ?_080                                   ; 0D6E _ 0F 84, FFFFFD58
        mov     eax, dword [rel tt]                     ; 0D74 _ 8B. 05, 00000000(rel)
        cmp     eax, 261                                ; 0D7A _ 3D, 00000105
        je      ?_080                                   ; 0D7F _ 0F 84, FFFFFD47
        mov     eax, dword [rel tt]                     ; 0D85 _ 8B. 05, 00000000(rel)
        cmp     eax, 264                                ; 0D8B _ 3D, 00000108
        je      ?_080                                   ; 0D90 _ 0F 84, FFFFFD36
        mov     rax, qword [rbp-20H]                    ; 0D96 _ 48: 8B. 45, E0
?_112:  leave                                           ; 0D9A _ C9
        ret                                             ; 0D9B _ C3

expr0:  ; Local function
        push    rbp                                     ; 0D9C _ 55
        mov     rbp, rsp                                ; 0D9D _ 48: 89. E5
        push    rbx                                     ; 0DA0 _ 53
        sub     rsp, 24                                 ; 0DA1 _ 48: 83. EC, 18
        call    expr1                                   ; 0DA5 _ E8, 00000106
        mov     qword [rbp-20H], rax                    ; 0DAA _ 48: 89. 45, E0
        cmp     qword [rbp-20H], 0                      ; 0DAE _ 48: 83. 7D, E0, 00
        jne     ?_120                                   ; 0DB3 _ 0F 85, 000000DE
        mov     eax, 0                                  ; 0DB9 _ B8, 00000000
        jmp     ?_121                                   ; 0DBE _ E9, 000000E7

?_113:  call    scan                                    ; 0DC3 _ E8, FFFFF839
        call    expr1                                   ; 0DC8 _ E8, 000000E3
        mov     qword [rbp-18H], rax                    ; 0DCD _ 48: 89. 45, E8
        cmp     qword [rbp-18H], 0                      ; 0DD1 _ 48: 83. 7D, E8, 00
        jnz     ?_114                                   ; 0DD6 _ 75, 0A
        mov     eax, 0                                  ; 0DD8 _ B8, 00000000
        jmp     ?_121                                   ; 0DDD _ E9, 000000C8

?_114:  mov     rax, qword [rbp-20H]                    ; 0DE2 _ 48: 8B. 45, E0
        mov     rdi, rax                                ; 0DE6 _ 48: 89. C7
        call    is_simple                               ; 0DE9 _ E8, 00000000(PLT r)
        xor     eax, 01H                                ; 0DEE _ 83. F0, 01
        test    al, al                                  ; 0DF1 _ 84. C0
        jz      ?_115                                   ; 0DF3 _ 74, 13
        mov     rax, qword [rbp-20H]                    ; 0DF5 _ 48: 8B. 45, E0
        mov     rdi, rax                                ; 0DF9 _ 48: 89. C7
        call    is_just_unknown                         ; 0DFC _ E8, 00000000(PLT r)
        xor     eax, 01H                                ; 0E01 _ 83. F0, 01
        test    al, al                                  ; 0E04 _ 84. C0
        jnz     ?_116                                   ; 0E06 _ 75, 26
?_115:  mov     rax, qword [rbp-18H]                    ; 0E08 _ 48: 8B. 45, E8
        mov     rdi, rax                                ; 0E0C _ 48: 89. C7
        call    is_simple                               ; 0E0F _ E8, 00000000(PLT r)
        xor     eax, 01H                                ; 0E14 _ 83. F0, 01
        test    al, al                                  ; 0E17 _ 84. C0
        jz      ?_117                                   ; 0E19 _ 74, 27
        mov     rax, qword [rbp-18H]                    ; 0E1B _ 48: 8B. 45, E8
        mov     rdi, rax                                ; 0E1F _ 48: 89. C7
        call    is_just_unknown                         ; 0E22 _ E8, 00000000(PLT r)
        xor     eax, 01H                                ; 0E27 _ 83. F0, 01
        test    al, al                                  ; 0E2A _ 84. C0
        jz      ?_117                                   ; 0E2C _ 74, 14
?_116:  lea     rax, [rel ?_288]                        ; 0E2E _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 0E35 _ 48: 89. C7
        mov     eax, 0                                  ; 0E38 _ B8, 00000000
        call    nasm_nonfatal                           ; 0E3D _ E8, 00000000(PLT r)
?_117:  mov     rax, qword [rbp-20H]                    ; 0E42 _ 48: 8B. 45, E0
        mov     rdi, rax                                ; 0E46 _ 48: 89. C7
        call    is_just_unknown                         ; 0E49 _ E8, 00000000(PLT r)
        test    al, al                                  ; 0E4E _ 84. C0
        jnz     ?_118                                   ; 0E50 _ 75, 10
        mov     rax, qword [rbp-18H]                    ; 0E52 _ 48: 8B. 45, E8
        mov     rdi, rax                                ; 0E56 _ 48: 89. C7
        call    is_just_unknown                         ; 0E59 _ E8, 00000000(PLT r)
        test    al, al                                  ; 0E5E _ 84. C0
        jz      ?_119                                   ; 0E60 _ 74, 0B
?_118:  call    unknown_expr                            ; 0E62 _ E8, FFFFF664
        mov     qword [rbp-20H], rax                    ; 0E67 _ 48: 89. 45, E0
        jmp     ?_120                                   ; 0E6B _ EB, 2A

?_119:  mov     rax, qword [rbp-20H]                    ; 0E6D _ 48: 8B. 45, E0
        mov     rdi, rax                                ; 0E71 _ 48: 89. C7
        call    reloc_value                             ; 0E74 _ E8, 00000000(PLT r)
        mov     rbx, rax                                ; 0E79 _ 48: 89. C3
        mov     rax, qword [rbp-18H]                    ; 0E7C _ 48: 8B. 45, E8
        mov     rdi, rax                                ; 0E80 _ 48: 89. C7
        call    reloc_value                             ; 0E83 _ E8, 00000000(PLT r)
        or      rax, rbx                                ; 0E88 _ 48: 09. D8
        mov     rdi, rax                                ; 0E8B _ 48: 89. C7
        call    scalarvect                              ; 0E8E _ E8, FFFFF60F
        mov     qword [rbp-20H], rax                    ; 0E93 _ 48: 89. 45, E0
?_120:  mov     eax, dword [rel tt]                     ; 0E97 _ 8B. 05, 00000000(rel)
        cmp     eax, 124                                ; 0E9D _ 83. F8, 7C
        je      ?_113                                   ; 0EA0 _ 0F 84, FFFFFF1D
        mov     rax, qword [rbp-20H]                    ; 0EA6 _ 48: 8B. 45, E0
?_121:  mov     rbx, qword [rbp-8H]                     ; 0EAA _ 48: 8B. 5D, F8
        leave                                           ; 0EAE _ C9
        ret                                             ; 0EAF _ C3

expr1:  ; Local function
        push    rbp                                     ; 0EB0 _ 55
        mov     rbp, rsp                                ; 0EB1 _ 48: 89. E5
        push    rbx                                     ; 0EB4 _ 53
        sub     rsp, 24                                 ; 0EB5 _ 48: 83. EC, 18
        call    expr2                                   ; 0EB9 _ E8, 00000106
        mov     qword [rbp-20H], rax                    ; 0EBE _ 48: 89. 45, E0
        cmp     qword [rbp-20H], 0                      ; 0EC2 _ 48: 83. 7D, E0, 00
        jne     ?_129                                   ; 0EC7 _ 0F 85, 000000DE
        mov     eax, 0                                  ; 0ECD _ B8, 00000000
        jmp     ?_130                                   ; 0ED2 _ E9, 000000E7

?_122:  call    scan                                    ; 0ED7 _ E8, FFFFF725
        call    expr2                                   ; 0EDC _ E8, 000000E3
        mov     qword [rbp-18H], rax                    ; 0EE1 _ 48: 89. 45, E8
        cmp     qword [rbp-18H], 0                      ; 0EE5 _ 48: 83. 7D, E8, 00
        jnz     ?_123                                   ; 0EEA _ 75, 0A
        mov     eax, 0                                  ; 0EEC _ B8, 00000000
        jmp     ?_130                                   ; 0EF1 _ E9, 000000C8

?_123:  mov     rax, qword [rbp-20H]                    ; 0EF6 _ 48: 8B. 45, E0
        mov     rdi, rax                                ; 0EFA _ 48: 89. C7
        call    is_simple                               ; 0EFD _ E8, 00000000(PLT r)
        xor     eax, 01H                                ; 0F02 _ 83. F0, 01
        test    al, al                                  ; 0F05 _ 84. C0
        jz      ?_124                                   ; 0F07 _ 74, 13
        mov     rax, qword [rbp-20H]                    ; 0F09 _ 48: 8B. 45, E0
        mov     rdi, rax                                ; 0F0D _ 48: 89. C7
        call    is_just_unknown                         ; 0F10 _ E8, 00000000(PLT r)
        xor     eax, 01H                                ; 0F15 _ 83. F0, 01
        test    al, al                                  ; 0F18 _ 84. C0
        jnz     ?_125                                   ; 0F1A _ 75, 26
?_124:  mov     rax, qword [rbp-18H]                    ; 0F1C _ 48: 8B. 45, E8
        mov     rdi, rax                                ; 0F20 _ 48: 89. C7
        call    is_simple                               ; 0F23 _ E8, 00000000(PLT r)
        xor     eax, 01H                                ; 0F28 _ 83. F0, 01
        test    al, al                                  ; 0F2B _ 84. C0
        jz      ?_126                                   ; 0F2D _ 74, 27
        mov     rax, qword [rbp-18H]                    ; 0F2F _ 48: 8B. 45, E8
        mov     rdi, rax                                ; 0F33 _ 48: 89. C7
        call    is_just_unknown                         ; 0F36 _ E8, 00000000(PLT r)
        xor     eax, 01H                                ; 0F3B _ 83. F0, 01
        test    al, al                                  ; 0F3E _ 84. C0
        jz      ?_126                                   ; 0F40 _ 74, 14
?_125:  lea     rax, [rel ?_289]                        ; 0F42 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 0F49 _ 48: 89. C7
        mov     eax, 0                                  ; 0F4C _ B8, 00000000
        call    nasm_nonfatal                           ; 0F51 _ E8, 00000000(PLT r)
?_126:  mov     rax, qword [rbp-20H]                    ; 0F56 _ 48: 8B. 45, E0
        mov     rdi, rax                                ; 0F5A _ 48: 89. C7
        call    is_just_unknown                         ; 0F5D _ E8, 00000000(PLT r)
        test    al, al                                  ; 0F62 _ 84. C0
        jnz     ?_127                                   ; 0F64 _ 75, 10
        mov     rax, qword [rbp-18H]                    ; 0F66 _ 48: 8B. 45, E8
        mov     rdi, rax                                ; 0F6A _ 48: 89. C7
        call    is_just_unknown                         ; 0F6D _ E8, 00000000(PLT r)
        test    al, al                                  ; 0F72 _ 84. C0
        jz      ?_128                                   ; 0F74 _ 74, 0B
?_127:  call    unknown_expr                            ; 0F76 _ E8, FFFFF550
        mov     qword [rbp-20H], rax                    ; 0F7B _ 48: 89. 45, E0
        jmp     ?_129                                   ; 0F7F _ EB, 2A

?_128:  mov     rax, qword [rbp-20H]                    ; 0F81 _ 48: 8B. 45, E0
        mov     rdi, rax                                ; 0F85 _ 48: 89. C7
        call    reloc_value                             ; 0F88 _ E8, 00000000(PLT r)
        mov     rbx, rax                                ; 0F8D _ 48: 89. C3
        mov     rax, qword [rbp-18H]                    ; 0F90 _ 48: 8B. 45, E8
        mov     rdi, rax                                ; 0F94 _ 48: 89. C7
        call    reloc_value                             ; 0F97 _ E8, 00000000(PLT r)
        xor     rax, rbx                                ; 0F9C _ 48: 31. D8
        mov     rdi, rax                                ; 0F9F _ 48: 89. C7
        call    scalarvect                              ; 0FA2 _ E8, FFFFF4FB
        mov     qword [rbp-20H], rax                    ; 0FA7 _ 48: 89. 45, E0
?_129:  mov     eax, dword [rel tt]                     ; 0FAB _ 8B. 05, 00000000(rel)
        cmp     eax, 94                                 ; 0FB1 _ 83. F8, 5E
        je      ?_122                                   ; 0FB4 _ 0F 84, FFFFFF1D
        mov     rax, qword [rbp-20H]                    ; 0FBA _ 48: 8B. 45, E0
?_130:  mov     rbx, qword [rbp-8H]                     ; 0FBE _ 48: 8B. 5D, F8
        leave                                           ; 0FC2 _ C9
        ret                                             ; 0FC3 _ C3

expr2:  ; Local function
        push    rbp                                     ; 0FC4 _ 55
        mov     rbp, rsp                                ; 0FC5 _ 48: 89. E5
        push    rbx                                     ; 0FC8 _ 53
        sub     rsp, 24                                 ; 0FC9 _ 48: 83. EC, 18
        call    expr3                                   ; 0FCD _ E8, 00000106
        mov     qword [rbp-20H], rax                    ; 0FD2 _ 48: 89. 45, E0
        cmp     qword [rbp-20H], 0                      ; 0FD6 _ 48: 83. 7D, E0, 00
        jne     ?_138                                   ; 0FDB _ 0F 85, 000000DE
        mov     eax, 0                                  ; 0FE1 _ B8, 00000000
        jmp     ?_139                                   ; 0FE6 _ E9, 000000E7

?_131:  call    scan                                    ; 0FEB _ E8, FFFFF611
        call    expr3                                   ; 0FF0 _ E8, 000000E3
        mov     qword [rbp-18H], rax                    ; 0FF5 _ 48: 89. 45, E8
        cmp     qword [rbp-18H], 0                      ; 0FF9 _ 48: 83. 7D, E8, 00
        jnz     ?_132                                   ; 0FFE _ 75, 0A
        mov     eax, 0                                  ; 1000 _ B8, 00000000
        jmp     ?_139                                   ; 1005 _ E9, 000000C8

?_132:  mov     rax, qword [rbp-20H]                    ; 100A _ 48: 8B. 45, E0
        mov     rdi, rax                                ; 100E _ 48: 89. C7
        call    is_simple                               ; 1011 _ E8, 00000000(PLT r)
        xor     eax, 01H                                ; 1016 _ 83. F0, 01
        test    al, al                                  ; 1019 _ 84. C0
        jz      ?_133                                   ; 101B _ 74, 13
        mov     rax, qword [rbp-20H]                    ; 101D _ 48: 8B. 45, E0
        mov     rdi, rax                                ; 1021 _ 48: 89. C7
        call    is_just_unknown                         ; 1024 _ E8, 00000000(PLT r)
        xor     eax, 01H                                ; 1029 _ 83. F0, 01
        test    al, al                                  ; 102C _ 84. C0
        jnz     ?_134                                   ; 102E _ 75, 26
?_133:  mov     rax, qword [rbp-18H]                    ; 1030 _ 48: 8B. 45, E8
        mov     rdi, rax                                ; 1034 _ 48: 89. C7
        call    is_simple                               ; 1037 _ E8, 00000000(PLT r)
        xor     eax, 01H                                ; 103C _ 83. F0, 01
        test    al, al                                  ; 103F _ 84. C0
        jz      ?_135                                   ; 1041 _ 74, 27
        mov     rax, qword [rbp-18H]                    ; 1043 _ 48: 8B. 45, E8
        mov     rdi, rax                                ; 1047 _ 48: 89. C7
        call    is_just_unknown                         ; 104A _ E8, 00000000(PLT r)
        xor     eax, 01H                                ; 104F _ 83. F0, 01
        test    al, al                                  ; 1052 _ 84. C0
        jz      ?_135                                   ; 1054 _ 74, 14
?_134:  lea     rax, [rel ?_290]                        ; 1056 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 105D _ 48: 89. C7
        mov     eax, 0                                  ; 1060 _ B8, 00000000
        call    nasm_nonfatal                           ; 1065 _ E8, 00000000(PLT r)
?_135:  mov     rax, qword [rbp-20H]                    ; 106A _ 48: 8B. 45, E0
        mov     rdi, rax                                ; 106E _ 48: 89. C7
        call    is_just_unknown                         ; 1071 _ E8, 00000000(PLT r)
        test    al, al                                  ; 1076 _ 84. C0
        jnz     ?_136                                   ; 1078 _ 75, 10
        mov     rax, qword [rbp-18H]                    ; 107A _ 48: 8B. 45, E8
        mov     rdi, rax                                ; 107E _ 48: 89. C7
        call    is_just_unknown                         ; 1081 _ E8, 00000000(PLT r)
        test    al, al                                  ; 1086 _ 84. C0
        jz      ?_137                                   ; 1088 _ 74, 0B
?_136:  call    unknown_expr                            ; 108A _ E8, FFFFF43C
        mov     qword [rbp-20H], rax                    ; 108F _ 48: 89. 45, E0
        jmp     ?_138                                   ; 1093 _ EB, 2A

?_137:  mov     rax, qword [rbp-20H]                    ; 1095 _ 48: 8B. 45, E0
        mov     rdi, rax                                ; 1099 _ 48: 89. C7
        call    reloc_value                             ; 109C _ E8, 00000000(PLT r)
        mov     rbx, rax                                ; 10A1 _ 48: 89. C3
        mov     rax, qword [rbp-18H]                    ; 10A4 _ 48: 8B. 45, E8
        mov     rdi, rax                                ; 10A8 _ 48: 89. C7
        call    reloc_value                             ; 10AB _ E8, 00000000(PLT r)
        and     rax, rbx                                ; 10B0 _ 48: 21. D8
        mov     rdi, rax                                ; 10B3 _ 48: 89. C7
        call    scalarvect                              ; 10B6 _ E8, FFFFF3E7
        mov     qword [rbp-20H], rax                    ; 10BB _ 48: 89. 45, E0
?_138:  mov     eax, dword [rel tt]                     ; 10BF _ 8B. 05, 00000000(rel)
        cmp     eax, 38                                 ; 10C5 _ 83. F8, 26
        je      ?_131                                   ; 10C8 _ 0F 84, FFFFFF1D
        mov     rax, qword [rbp-20H]                    ; 10CE _ 48: 8B. 45, E0
?_139:  mov     rbx, qword [rbp-8H]                     ; 10D2 _ 48: 8B. 5D, F8
        leave                                           ; 10D6 _ C9
        ret                                             ; 10D7 _ C3

expr3:  ; Local function
        push    rbp                                     ; 10D8 _ 55
        mov     rbp, rsp                                ; 10D9 _ 48: 89. E5
        push    rbx                                     ; 10DC _ 53
        sub     rsp, 40                                 ; 10DD _ 48: 83. EC, 28
        call    expr4                                   ; 10E1 _ E8, 000001D4
        mov     qword [rbp-20H], rax                    ; 10E6 _ 48: 89. 45, E0
        cmp     qword [rbp-20H], 0                      ; 10EA _ 48: 83. 7D, E0, 00
        jne     ?_150                                   ; 10EF _ 0F 85, 00000188
        mov     eax, 0                                  ; 10F5 _ B8, 00000000
        jmp     ?_151                                   ; 10FA _ E9, 000001B5

?_140:  mov     eax, dword [rel tt]                     ; 10FF _ 8B. 05, 00000000(rel)
        mov     dword [rbp-24H], eax                    ; 1105 _ 89. 45, DC
        call    scan                                    ; 1108 _ E8, FFFFF4F4
        call    expr4                                   ; 110D _ E8, 000001A8
        mov     qword [rbp-18H], rax                    ; 1112 _ 48: 89. 45, E8
        cmp     qword [rbp-18H], 0                      ; 1116 _ 48: 83. 7D, E8, 00
        jnz     ?_141                                   ; 111B _ 75, 0A
        mov     eax, 0                                  ; 111D _ B8, 00000000
        jmp     ?_151                                   ; 1122 _ E9, 0000018D

?_141:  mov     rax, qword [rbp-20H]                    ; 1127 _ 48: 8B. 45, E0
        mov     rdi, rax                                ; 112B _ 48: 89. C7
        call    is_simple                               ; 112E _ E8, 00000000(PLT r)
        xor     eax, 01H                                ; 1133 _ 83. F0, 01
        test    al, al                                  ; 1136 _ 84. C0
        jz      ?_142                                   ; 1138 _ 74, 13
        mov     rax, qword [rbp-20H]                    ; 113A _ 48: 8B. 45, E0
        mov     rdi, rax                                ; 113E _ 48: 89. C7
        call    is_just_unknown                         ; 1141 _ E8, 00000000(PLT r)
        xor     eax, 01H                                ; 1146 _ 83. F0, 01
        test    al, al                                  ; 1149 _ 84. C0
        jnz     ?_143                                   ; 114B _ 75, 26
?_142:  mov     rax, qword [rbp-18H]                    ; 114D _ 48: 8B. 45, E8
        mov     rdi, rax                                ; 1151 _ 48: 89. C7
        call    is_simple                               ; 1154 _ E8, 00000000(PLT r)
        xor     eax, 01H                                ; 1159 _ 83. F0, 01
        test    al, al                                  ; 115C _ 84. C0
        jz      ?_144                                   ; 115E _ 74, 2C
        mov     rax, qword [rbp-18H]                    ; 1160 _ 48: 8B. 45, E8
        mov     rdi, rax                                ; 1164 _ 48: 89. C7
        call    is_just_unknown                         ; 1167 _ E8, 00000000(PLT r)
        xor     eax, 01H                                ; 116C _ 83. F0, 01
        test    al, al                                  ; 116F _ 84. C0
        jz      ?_144                                   ; 1171 _ 74, 19
?_143:  lea     rax, [rel ?_298]                        ; 1173 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 117A _ 48: 89. C7
        mov     eax, 0                                  ; 117D _ B8, 00000000
        call    nasm_nonfatal                           ; 1182 _ E8, 00000000(PLT r)
        jmp     ?_150                                   ; 1187 _ E9, 000000F1

?_144:  mov     rax, qword [rbp-20H]                    ; 118C _ 48: 8B. 45, E0
        mov     rdi, rax                                ; 1190 _ 48: 89. C7
        call    is_just_unknown                         ; 1193 _ E8, 00000000(PLT r)
        test    al, al                                  ; 1198 _ 84. C0
        jnz     ?_145                                   ; 119A _ 75, 10
        mov     rax, qword [rbp-18H]                    ; 119C _ 48: 8B. 45, E8
        mov     rdi, rax                                ; 11A0 _ 48: 89. C7
        call    is_just_unknown                         ; 11A3 _ E8, 00000000(PLT r)
        test    al, al                                  ; 11A8 _ 84. C0
        jz      ?_146                                   ; 11AA _ 74, 0E
?_145:  call    unknown_expr                            ; 11AC _ E8, FFFFF31A
        mov     qword [rbp-20H], rax                    ; 11B1 _ 48: 89. 45, E0
        jmp     ?_150                                   ; 11B5 _ E9, 000000C3

?_146:  cmp     dword [rbp-24H], 258                    ; 11BA _ 81. 7D, DC, 00000102
        je      ?_149                                   ; 11C1 _ 0F 84, 00000086
        cmp     dword [rbp-24H], 258                    ; 11C7 _ 81. 7D, DC, 00000102
        jg      ?_150                                   ; 11CE _ 0F 8F, 000000A9
        cmp     dword [rbp-24H], 256                    ; 11D4 _ 81. 7D, DC, 00000100
        jz      ?_147                                   ; 11DB _ 74, 0E
        cmp     dword [rbp-24H], 257                    ; 11DD _ 81. 7D, DC, 00000101
        jz      ?_148                                   ; 11E4 _ 74, 36
        jmp     ?_150                                   ; 11E6 _ E9, 00000092

?_147:  mov     rax, qword [rbp-20H]                    ; 11EB _ 48: 8B. 45, E0
        mov     rdi, rax                                ; 11EF _ 48: 89. C7
        call    reloc_value                             ; 11F2 _ E8, 00000000(PLT r)
        mov     rbx, rax                                ; 11F7 _ 48: 89. C3
        mov     rax, qword [rbp-18H]                    ; 11FA _ 48: 8B. 45, E8
        mov     rdi, rax                                ; 11FE _ 48: 89. C7
        call    reloc_value                             ; 1201 _ E8, 00000000(PLT r)
        mov     ecx, eax                                ; 1206 _ 89. C1
        shl     rbx, cl                                 ; 1208 _ 48: D3. E3
        mov     rax, rbx                                ; 120B _ 48: 89. D8
        mov     rdi, rax                                ; 120E _ 48: 89. C7
        call    scalarvect                              ; 1211 _ E8, FFFFF28C
        mov     qword [rbp-20H], rax                    ; 1216 _ 48: 89. 45, E0
        jmp     ?_150                                   ; 121A _ EB, 61

?_148:  mov     rax, qword [rbp-20H]                    ; 121C _ 48: 8B. 45, E0
        mov     rdi, rax                                ; 1220 _ 48: 89. C7
        call    reloc_value                             ; 1223 _ E8, 00000000(PLT r)
        mov     rbx, rax                                ; 1228 _ 48: 89. C3
        mov     rax, qword [rbp-18H]                    ; 122B _ 48: 8B. 45, E8
        mov     rdi, rax                                ; 122F _ 48: 89. C7
        call    reloc_value                             ; 1232 _ E8, 00000000(PLT r)
        mov     ecx, eax                                ; 1237 _ 89. C1
        shr     rbx, cl                                 ; 1239 _ 48: D3. EB
        mov     rax, rbx                                ; 123C _ 48: 89. D8
        mov     rdi, rax                                ; 123F _ 48: 89. C7
        call    scalarvect                              ; 1242 _ E8, FFFFF25B
        mov     qword [rbp-20H], rax                    ; 1247 _ 48: 89. 45, E0
        jmp     ?_150                                   ; 124B _ EB, 30

?_149:  mov     rax, qword [rbp-20H]                    ; 124D _ 48: 8B. 45, E0
        mov     rdi, rax                                ; 1251 _ 48: 89. C7
        call    reloc_value                             ; 1254 _ E8, 00000000(PLT r)
        mov     rbx, rax                                ; 1259 _ 48: 89. C3
        mov     rax, qword [rbp-18H]                    ; 125C _ 48: 8B. 45, E8
        mov     rdi, rax                                ; 1260 _ 48: 89. C7
        call    reloc_value                             ; 1263 _ E8, 00000000(PLT r)
        mov     ecx, eax                                ; 1268 _ 89. C1
        sar     rbx, cl                                 ; 126A _ 48: D3. FB
        mov     rax, rbx                                ; 126D _ 48: 89. D8
        mov     rdi, rax                                ; 1270 _ 48: 89. C7
        call    scalarvect                              ; 1273 _ E8, FFFFF22A
        mov     qword [rbp-20H], rax                    ; 1278 _ 48: 89. 45, E0
        nop                                             ; 127C _ 90
?_150:  mov     eax, dword [rel tt]                     ; 127D _ 8B. 05, 00000000(rel)
        cmp     eax, 256                                ; 1283 _ 3D, 00000100
        je      ?_140                                   ; 1288 _ 0F 84, FFFFFE71
        mov     eax, dword [rel tt]                     ; 128E _ 8B. 05, 00000000(rel)
        cmp     eax, 257                                ; 1294 _ 3D, 00000101
        je      ?_140                                   ; 1299 _ 0F 84, FFFFFE60
        mov     eax, dword [rel tt]                     ; 129F _ 8B. 05, 00000000(rel)
        cmp     eax, 258                                ; 12A5 _ 3D, 00000102
        je      ?_140                                   ; 12AA _ 0F 84, FFFFFE4F
        mov     rax, qword [rbp-20H]                    ; 12B0 _ 48: 8B. 45, E0
?_151:  mov     rbx, qword [rbp-8H]                     ; 12B4 _ 48: 8B. 5D, F8
        leave                                           ; 12B8 _ C9
        ret                                             ; 12B9 _ C3

expr4:  ; Local function
        push    rbp                                     ; 12BA _ 55
        mov     rbp, rsp                                ; 12BB _ 48: 89. E5
        sub     rsp, 32                                 ; 12BE _ 48: 83. EC, 20
        call    expr5                                   ; 12C2 _ E8, 000000B8
        mov     qword [rbp-10H], rax                    ; 12C7 _ 48: 89. 45, F0
        cmp     qword [rbp-10H], 0                      ; 12CB _ 48: 83. 7D, F0, 00
        jne     ?_156                                   ; 12D0 _ 0F 85, 00000085
        mov     eax, 0                                  ; 12D6 _ B8, 00000000
        jmp     ?_157                                   ; 12DB _ E9, 0000009D

?_152:  mov     eax, dword [rel tt]                     ; 12E0 _ 8B. 05, 00000000(rel)
        mov     dword [rbp-14H], eax                    ; 12E6 _ 89. 45, EC
        call    scan                                    ; 12E9 _ E8, FFFFF313
        call    expr5                                   ; 12EE _ E8, 0000008C
        mov     qword [rbp-8H], rax                     ; 12F3 _ 48: 89. 45, F8
        cmp     qword [rbp-8H], 0                       ; 12F7 _ 48: 83. 7D, F8, 00
        jnz     ?_153                                   ; 12FC _ 75, 07
        mov     eax, 0                                  ; 12FE _ B8, 00000000
        jmp     ?_157                                   ; 1303 _ EB, 78

?_153:  cmp     dword [rbp-14H], 43                     ; 1305 _ 83. 7D, EC, 2B
        jz      ?_154                                   ; 1309 _ 74, 08
        cmp     dword [rbp-14H], 45                     ; 130B _ 83. 7D, EC, 2D
        jz      ?_155                                   ; 130F _ 74, 1B
        jmp     ?_156                                   ; 1311 _ EB, 48

?_154:  mov     rdx, qword [rbp-8H]                     ; 1313 _ 48: 8B. 55, F8
        mov     rax, qword [rbp-10H]                    ; 1317 _ 48: 8B. 45, F0
        mov     rsi, rdx                                ; 131B _ 48: 89. D6
        mov     rdi, rax                                ; 131E _ 48: 89. C7
        call    add_vectors                             ; 1321 _ E8, FFFFEEF3
        mov     qword [rbp-10H], rax                    ; 1326 _ 48: 89. 45, F0
        jmp     ?_156                                   ; 132A _ EB, 2F

?_155:  mov     rax, qword [rbp-8H]                     ; 132C _ 48: 8B. 45, F8
        mov     edx, 0                                  ; 1330 _ BA, 00000000
        mov     rsi, -1                                 ; 1335 _ 48: C7. C6, FFFFFFFF
        mov     rdi, rax                                ; 133C _ 48: 89. C7
        call    scalar_mult                             ; 133F _ E8, FFFFF0BA
        mov     rdx, rax                                ; 1344 _ 48: 89. C2
        mov     rax, qword [rbp-10H]                    ; 1347 _ 48: 8B. 45, F0
        mov     rsi, rdx                                ; 134B _ 48: 89. D6
        mov     rdi, rax                                ; 134E _ 48: 89. C7
        call    add_vectors                             ; 1351 _ E8, FFFFEEC3
        mov     qword [rbp-10H], rax                    ; 1356 _ 48: 89. 45, F0
        nop                                             ; 135A _ 90
?_156:  mov     eax, dword [rel tt]                     ; 135B _ 8B. 05, 00000000(rel)
        cmp     eax, 43                                 ; 1361 _ 83. F8, 2B
        je      ?_152                                   ; 1364 _ 0F 84, FFFFFF76
        mov     eax, dword [rel tt]                     ; 136A _ 8B. 05, 00000000(rel)
        cmp     eax, 45                                 ; 1370 _ 83. F8, 2D
        je      ?_152                                   ; 1373 _ 0F 84, FFFFFF67
        mov     rax, qword [rbp-10H]                    ; 1379 _ 48: 8B. 45, F0
?_157:  leave                                           ; 137D _ C9
        ret                                             ; 137E _ C3

expr5:  ; Local function
        push    rbp                                     ; 137F _ 55
        mov     rbp, rsp                                ; 1380 _ 48: 89. E5
        push    rbx                                     ; 1383 _ 53
        sub     rsp, 40                                 ; 1384 _ 48: 83. EC, 28
        call    expr6                                   ; 1388 _ E8, 00000849
        mov     qword [rbp-20H], rax                    ; 138D _ 48: 89. 45, E0
        cmp     qword [rbp-20H], 0                      ; 1391 _ 48: 83. 7D, E0, 00
        jne     ?_184                                   ; 1396 _ 0F 85, 0000039C
        mov     eax, 0                                  ; 139C _ B8, 00000000
        jmp     ?_185                                   ; 13A1 _ E9, 000003E5

?_158:  mov     eax, dword [rel tt]                     ; 13A6 _ 8B. 05, 00000000(rel)
        mov     dword [rbp-24H], eax                    ; 13AC _ 89. 45, DC
        call    scan                                    ; 13AF _ E8, FFFFF24D
        call    expr6                                   ; 13B4 _ E8, 0000081D
        mov     qword [rbp-18H], rax                    ; 13B9 _ 48: 89. 45, E8
        cmp     qword [rbp-18H], 0                      ; 13BD _ 48: 83. 7D, E8, 00
        jnz     ?_159                                   ; 13C2 _ 75, 0A
        mov     eax, 0                                  ; 13C4 _ B8, 00000000
        jmp     ?_185                                   ; 13C9 _ E9, 000003BD

?_159:  cmp     dword [rbp-24H], 42                     ; 13CE _ 83. 7D, DC, 2A
        jz      ?_162                                   ; 13D2 _ 74, 6A
        mov     rax, qword [rbp-20H]                    ; 13D4 _ 48: 8B. 45, E0
        mov     rdi, rax                                ; 13D8 _ 48: 89. C7
        call    is_simple                               ; 13DB _ E8, 00000000(PLT r)
        xor     eax, 01H                                ; 13E0 _ 83. F0, 01
        test    al, al                                  ; 13E3 _ 84. C0
        jz      ?_160                                   ; 13E5 _ 74, 13
        mov     rax, qword [rbp-20H]                    ; 13E7 _ 48: 8B. 45, E0
        mov     rdi, rax                                ; 13EB _ 48: 89. C7
        call    is_just_unknown                         ; 13EE _ E8, 00000000(PLT r)
        xor     eax, 01H                                ; 13F3 _ 83. F0, 01
        test    al, al                                  ; 13F6 _ 84. C0
        jnz     ?_161                                   ; 13F8 _ 75, 26
?_160:  mov     rax, qword [rbp-18H]                    ; 13FA _ 48: 8B. 45, E8
        mov     rdi, rax                                ; 13FE _ 48: 89. C7
        call    is_simple                               ; 1401 _ E8, 00000000(PLT r)
        xor     eax, 01H                                ; 1406 _ 83. F0, 01
        test    al, al                                  ; 1409 _ 84. C0
        jz      ?_162                                   ; 140B _ 74, 31
        mov     rax, qword [rbp-18H]                    ; 140D _ 48: 8B. 45, E8
        mov     rdi, rax                                ; 1411 _ 48: 89. C7
        call    is_just_unknown                         ; 1414 _ E8, 00000000(PLT r)
        xor     eax, 01H                                ; 1419 _ 83. F0, 01
        test    al, al                                  ; 141C _ 84. C0
        jz      ?_162                                   ; 141E _ 74, 1E
?_161:  lea     rax, [rel ?_299]                        ; 1420 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 1427 _ 48: 89. C7
        mov     eax, 0                                  ; 142A _ B8, 00000000
        call    nasm_nonfatal                           ; 142F _ E8, 00000000(PLT r)
        mov     eax, 0                                  ; 1434 _ B8, 00000000
        jmp     ?_185                                   ; 1439 _ E9, 0000034D

?_162:  cmp     dword [rbp-24H], 42                     ; 143E _ 83. 7D, DC, 2A
        jz      ?_163                                   ; 1442 _ 74, 42
        mov     rax, qword [rbp-18H]                    ; 1444 _ 48: 8B. 45, E8
        mov     rdi, rax                                ; 1448 _ 48: 89. C7
        call    is_just_unknown                         ; 144B _ E8, 00000000(PLT r)
        xor     eax, 01H                                ; 1450 _ 83. F0, 01
        test    al, al                                  ; 1453 _ 84. C0
        jz      ?_163                                   ; 1455 _ 74, 2F
        mov     rax, qword [rbp-18H]                    ; 1457 _ 48: 8B. 45, E8
        mov     rdi, rax                                ; 145B _ 48: 89. C7
        call    reloc_value                             ; 145E _ E8, 00000000(PLT r)
        test    rax, rax                                ; 1463 _ 48: 85. C0
        jnz     ?_163                                   ; 1466 _ 75, 1E
        lea     rax, [rel ?_300]                        ; 1468 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 146F _ 48: 89. C7
        mov     eax, 0                                  ; 1472 _ B8, 00000000
        call    nasm_nonfatal                           ; 1477 _ E8, 00000000(PLT r)
        mov     eax, 0                                  ; 147C _ B8, 00000000
        jmp     ?_185                                   ; 1481 _ E9, 00000305

?_163:  cmp     dword [rbp-24H], 260                    ; 1486 _ 81. 7D, DC, 00000104
        je      ?_180                                   ; 148D _ 0F 84, 00000241
        cmp     dword [rbp-24H], 260                    ; 1493 _ 81. 7D, DC, 00000104
        jg      ?_184                                   ; 149A _ 0F 8F, 00000298
        cmp     dword [rbp-24H], 259                    ; 14A0 _ 81. 7D, DC, 00000103
        je      ?_176                                   ; 14A7 _ 0F 84, 000001C8
        cmp     dword [rbp-24H], 259                    ; 14AD _ 81. 7D, DC, 00000103
        jg      ?_184                                   ; 14B4 _ 0F 8F, 0000027E
        cmp     dword [rbp-24H], 47                     ; 14BA _ 83. 7D, DC, 2F
        je      ?_168                                   ; 14BE _ 0F 84, 000000E4
        cmp     dword [rbp-24H], 47                     ; 14C4 _ 83. 7D, DC, 2F
        jg      ?_184                                   ; 14C8 _ 0F 8F, 0000026A
        cmp     dword [rbp-24H], 37                     ; 14CE _ 83. 7D, DC, 25
        je      ?_172                                   ; 14D2 _ 0F 84, 00000135
        cmp     dword [rbp-24H], 42                     ; 14D8 _ 83. 7D, DC, 2A
        jne     ?_184                                   ; 14DC _ 0F 85, 00000256
        mov     rax, qword [rbp-20H]                    ; 14E2 _ 48: 8B. 45, E0
        mov     rdi, rax                                ; 14E6 _ 48: 89. C7
        call    is_simple                               ; 14E9 _ E8, 00000000(PLT r)
        test    al, al                                  ; 14EE _ 84. C0
        jz      ?_164                                   ; 14F0 _ 74, 2C
        mov     rax, qword [rbp-20H]                    ; 14F2 _ 48: 8B. 45, E0
        mov     rdi, rax                                ; 14F6 _ 48: 89. C7
        call    reloc_value                             ; 14F9 _ E8, 00000000(PLT r)
        mov     rcx, rax                                ; 14FE _ 48: 89. C1
        mov     rax, qword [rbp-18H]                    ; 1501 _ 48: 8B. 45, E8
        mov     edx, 1                                  ; 1505 _ BA, 00000001
        mov     rsi, rcx                                ; 150A _ 48: 89. CE
        mov     rdi, rax                                ; 150D _ 48: 89. C7
        call    scalar_mult                             ; 1510 _ E8, FFFFEEE9
        mov     qword [rbp-20H], rax                    ; 1515 _ 48: 89. 45, E0
        jmp     ?_184                                   ; 1519 _ E9, 0000021A

?_164:  mov     rax, qword [rbp-18H]                    ; 151E _ 48: 8B. 45, E8
        mov     rdi, rax                                ; 1522 _ 48: 89. C7
        call    is_simple                               ; 1525 _ E8, 00000000(PLT r)
        test    al, al                                  ; 152A _ 84. C0
        jz      ?_165                                   ; 152C _ 74, 2C
        mov     rax, qword [rbp-18H]                    ; 152E _ 48: 8B. 45, E8
        mov     rdi, rax                                ; 1532 _ 48: 89. C7
        call    reloc_value                             ; 1535 _ E8, 00000000(PLT r)
        mov     rcx, rax                                ; 153A _ 48: 89. C1
        mov     rax, qword [rbp-20H]                    ; 153D _ 48: 8B. 45, E0
        mov     edx, 1                                  ; 1541 _ BA, 00000001
        mov     rsi, rcx                                ; 1546 _ 48: 89. CE
        mov     rdi, rax                                ; 1549 _ 48: 89. C7
        call    scalar_mult                             ; 154C _ E8, FFFFEEAD
        mov     qword [rbp-20H], rax                    ; 1551 _ 48: 89. 45, E0
        jmp     ?_184                                   ; 1555 _ E9, 000001DE

?_165:  mov     rax, qword [rbp-20H]                    ; 155A _ 48: 8B. 45, E0
        mov     rdi, rax                                ; 155E _ 48: 89. C7
        call    is_just_unknown                         ; 1561 _ E8, 00000000(PLT r)
        test    al, al                                  ; 1566 _ 84. C0
        jz      ?_166                                   ; 1568 _ 74, 1B
        mov     rax, qword [rbp-18H]                    ; 156A _ 48: 8B. 45, E8
        mov     rdi, rax                                ; 156E _ 48: 89. C7
        call    is_just_unknown                         ; 1571 _ E8, 00000000(PLT r)
        test    al, al                                  ; 1576 _ 84. C0
        jz      ?_166                                   ; 1578 _ 74, 0B
        call    unknown_expr                            ; 157A _ E8, FFFFEF4C
        mov     qword [rbp-20H], rax                    ; 157F _ 48: 89. 45, E0
        jmp     ?_167                                   ; 1583 _ EB, 1E

?_166:  lea     rax, [rel ?_301]                        ; 1585 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 158C _ 48: 89. C7
        mov     eax, 0                                  ; 158F _ B8, 00000000
        call    nasm_nonfatal                           ; 1594 _ E8, 00000000(PLT r)
        mov     eax, 0                                  ; 1599 _ B8, 00000000
        jmp     ?_185                                   ; 159E _ E9, 000001E8

?_167:  jmp     ?_184                                   ; 15A3 _ E9, 00000190

?_168:  mov     rax, qword [rbp-20H]                    ; 15A8 _ 48: 8B. 45, E0
        mov     rdi, rax                                ; 15AC _ 48: 89. C7
        call    is_just_unknown                         ; 15AF _ E8, 00000000(PLT r)
        test    al, al                                  ; 15B4 _ 84. C0
        jnz     ?_169                                   ; 15B6 _ 75, 10
        mov     rax, qword [rbp-18H]                    ; 15B8 _ 48: 8B. 45, E8
        mov     rdi, rax                                ; 15BC _ 48: 89. C7
        call    is_just_unknown                         ; 15BF _ E8, 00000000(PLT r)
        test    al, al                                  ; 15C4 _ 84. C0
        jz      ?_170                                   ; 15C6 _ 74, 0B
?_169:  call    unknown_expr                            ; 15C8 _ E8, FFFFEEFE
        mov     qword [rbp-20H], rax                    ; 15CD _ 48: 89. 45, E0
        jmp     ?_171                                   ; 15D1 _ EB, 35

?_170:  mov     rax, qword [rbp-20H]                    ; 15D3 _ 48: 8B. 45, E0
        mov     rdi, rax                                ; 15D7 _ 48: 89. C7
        call    reloc_value                             ; 15DA _ E8, 00000000(PLT r)
        mov     rbx, rax                                ; 15DF _ 48: 89. C3
        mov     rax, qword [rbp-18H]                    ; 15E2 _ 48: 8B. 45, E8
        mov     rdi, rax                                ; 15E6 _ 48: 89. C7
        call    reloc_value                             ; 15E9 _ E8, 00000000(PLT r)
        mov     rsi, rax                                ; 15EE _ 48: 89. C6
        mov     rax, rbx                                ; 15F1 _ 48: 89. D8
        mov     edx, 0                                  ; 15F4 _ BA, 00000000
        div     rsi                                     ; 15F9 _ 48: F7. F6
        mov     rdi, rax                                ; 15FC _ 48: 89. C7
        call    scalarvect                              ; 15FF _ E8, FFFFEE9E
        mov     qword [rbp-20H], rax                    ; 1604 _ 48: 89. 45, E0
?_171:  jmp     ?_184                                   ; 1608 _ E9, 0000012B

?_172:  mov     rax, qword [rbp-20H]                    ; 160D _ 48: 8B. 45, E0
        mov     rdi, rax                                ; 1611 _ 48: 89. C7
        call    is_just_unknown                         ; 1614 _ E8, 00000000(PLT r)
        test    al, al                                  ; 1619 _ 84. C0
        jnz     ?_173                                   ; 161B _ 75, 10
        mov     rax, qword [rbp-18H]                    ; 161D _ 48: 8B. 45, E8
        mov     rdi, rax                                ; 1621 _ 48: 89. C7
        call    is_just_unknown                         ; 1624 _ E8, 00000000(PLT r)
        test    al, al                                  ; 1629 _ 84. C0
        jz      ?_174                                   ; 162B _ 74, 0B
?_173:  call    unknown_expr                            ; 162D _ E8, FFFFEE99
        mov     qword [rbp-20H], rax                    ; 1632 _ 48: 89. 45, E0
        jmp     ?_175                                   ; 1636 _ EB, 38

?_174:  mov     rax, qword [rbp-20H]                    ; 1638 _ 48: 8B. 45, E0
        mov     rdi, rax                                ; 163C _ 48: 89. C7
        call    reloc_value                             ; 163F _ E8, 00000000(PLT r)
        mov     rbx, rax                                ; 1644 _ 48: 89. C3
        mov     rax, qword [rbp-18H]                    ; 1647 _ 48: 8B. 45, E8
        mov     rdi, rax                                ; 164B _ 48: 89. C7
        call    reloc_value                             ; 164E _ E8, 00000000(PLT r)
        mov     rcx, rax                                ; 1653 _ 48: 89. C1
        mov     rax, rbx                                ; 1656 _ 48: 89. D8
        mov     edx, 0                                  ; 1659 _ BA, 00000000
        div     rcx                                     ; 165E _ 48: F7. F1
        mov     rax, rdx                                ; 1661 _ 48: 89. D0
        mov     rdi, rax                                ; 1664 _ 48: 89. C7
        call    scalarvect                              ; 1667 _ E8, FFFFEE36
        mov     qword [rbp-20H], rax                    ; 166C _ 48: 89. 45, E0
?_175:  jmp     ?_184                                   ; 1670 _ E9, 000000C3

?_176:  mov     rax, qword [rbp-20H]                    ; 1675 _ 48: 8B. 45, E0
        mov     rdi, rax                                ; 1679 _ 48: 89. C7
        call    is_just_unknown                         ; 167C _ E8, 00000000(PLT r)
        test    al, al                                  ; 1681 _ 84. C0
        jnz     ?_177                                   ; 1683 _ 75, 10
        mov     rax, qword [rbp-18H]                    ; 1685 _ 48: 8B. 45, E8
        mov     rdi, rax                                ; 1689 _ 48: 89. C7
        call    is_just_unknown                         ; 168C _ E8, 00000000(PLT r)
        test    al, al                                  ; 1691 _ 84. C0
        jz      ?_178                                   ; 1693 _ 74, 0B
?_177:  call    unknown_expr                            ; 1695 _ E8, FFFFEE31
        mov     qword [rbp-20H], rax                    ; 169A _ 48: 89. 45, E0
        jmp     ?_179                                   ; 169E _ EB, 32

?_178:  mov     rax, qword [rbp-20H]                    ; 16A0 _ 48: 8B. 45, E0
        mov     rdi, rax                                ; 16A4 _ 48: 89. C7
        call    reloc_value                             ; 16A7 _ E8, 00000000(PLT r)
        mov     rbx, rax                                ; 16AC _ 48: 89. C3
        mov     rax, qword [rbp-18H]                    ; 16AF _ 48: 8B. 45, E8
        mov     rdi, rax                                ; 16B3 _ 48: 89. C7
        call    reloc_value                             ; 16B6 _ E8, 00000000(PLT r)
        mov     rsi, rax                                ; 16BB _ 48: 89. C6
        mov     rax, rbx                                ; 16BE _ 48: 89. D8
        cqo                                             ; 16C1 _ 48: 99
        idiv    rsi                                     ; 16C3 _ 48: F7. FE
        mov     rdi, rax                                ; 16C6 _ 48: 89. C7
        call    scalarvect                              ; 16C9 _ E8, FFFFEDD4
        mov     qword [rbp-20H], rax                    ; 16CE _ 48: 89. 45, E0
?_179:  jmp     ?_184                                   ; 16D2 _ EB, 64

?_180:  mov     rax, qword [rbp-20H]                    ; 16D4 _ 48: 8B. 45, E0
        mov     rdi, rax                                ; 16D8 _ 48: 89. C7
        call    is_just_unknown                         ; 16DB _ E8, 00000000(PLT r)
        test    al, al                                  ; 16E0 _ 84. C0
        jnz     ?_181                                   ; 16E2 _ 75, 10
        mov     rax, qword [rbp-18H]                    ; 16E4 _ 48: 8B. 45, E8
        mov     rdi, rax                                ; 16E8 _ 48: 89. C7
        call    is_just_unknown                         ; 16EB _ E8, 00000000(PLT r)
        test    al, al                                  ; 16F0 _ 84. C0
        jz      ?_182                                   ; 16F2 _ 74, 0B
?_181:  call    unknown_expr                            ; 16F4 _ E8, FFFFEDD2
        mov     qword [rbp-20H], rax                    ; 16F9 _ 48: 89. 45, E0
        jmp     ?_183                                   ; 16FD _ EB, 38

?_182:  mov     rax, qword [rbp-20H]                    ; 16FF _ 48: 8B. 45, E0
        mov     rdi, rax                                ; 1703 _ 48: 89. C7
        call    reloc_value                             ; 1706 _ E8, 00000000(PLT r)
        mov     rbx, rax                                ; 170B _ 48: 89. C3
        mov     rax, qword [rbp-18H]                    ; 170E _ 48: 8B. 45, E8
        mov     rdi, rax                                ; 1712 _ 48: 89. C7
        call    reloc_value                             ; 1715 _ E8, 00000000(PLT r)
        mov     rsi, rax                                ; 171A _ 48: 89. C6
        mov     rax, rbx                                ; 171D _ 48: 89. D8
        cqo                                             ; 1720 _ 48: 99
        idiv    rsi                                     ; 1722 _ 48: F7. FE
        mov     rcx, rdx                                ; 1725 _ 48: 89. D1
        mov     rax, rcx                                ; 1728 _ 48: 89. C8
        mov     rdi, rax                                ; 172B _ 48: 89. C7
        call    scalarvect                              ; 172E _ E8, FFFFED6F
        mov     qword [rbp-20H], rax                    ; 1733 _ 48: 89. 45, E0
?_183:  nop                                             ; 1737 _ 90
?_184:  mov     eax, dword [rel tt]                     ; 1738 _ 8B. 05, 00000000(rel)
        cmp     eax, 42                                 ; 173E _ 83. F8, 2A
        je      ?_158                                   ; 1741 _ 0F 84, FFFFFC5F
        mov     eax, dword [rel tt]                     ; 1747 _ 8B. 05, 00000000(rel)
        cmp     eax, 47                                 ; 174D _ 83. F8, 2F
        je      ?_158                                   ; 1750 _ 0F 84, FFFFFC50
        mov     eax, dword [rel tt]                     ; 1756 _ 8B. 05, 00000000(rel)
        cmp     eax, 37                                 ; 175C _ 83. F8, 25
        je      ?_158                                   ; 175F _ 0F 84, FFFFFC41
        mov     eax, dword [rel tt]                     ; 1765 _ 8B. 05, 00000000(rel)
        cmp     eax, 259                                ; 176B _ 3D, 00000103
        je      ?_158                                   ; 1770 _ 0F 84, FFFFFC30
        mov     eax, dword [rel tt]                     ; 1776 _ 8B. 05, 00000000(rel)
        cmp     eax, 260                                ; 177C _ 3D, 00000104
        je      ?_158                                   ; 1781 _ 0F 84, FFFFFC1F
        mov     rax, qword [rbp-20H]                    ; 1787 _ 48: 8B. 45, E0
?_185:  mov     rbx, qword [rbp-8H]                     ; 178B _ 48: 8B. 5D, F8
        leave                                           ; 178F _ C9
        ret                                             ; 1790 _ C3

eval_floatize:; Local function
        push    rbp                                     ; 1791 _ 55
        mov     rbp, rsp                                ; 1792 _ 48: 89. E5
        sub     rsp, 96                                 ; 1795 _ 48: 83. EC, 60
        mov     dword [rbp-54H], edi                    ; 1799 _ 89. 7D, AC
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        mov     rax, qword [fs:abs 28H]                 ; 179C _ 64 48: 8B. 04 25, 00000028
        mov     qword [rbp-8H], rax                     ; 17A5 _ 48: 89. 45, F8
        xor     eax, eax                                ; 17A9 _ 31. C0
        mov     dword [rbp-48H], 1                      ; 17AB _ C7. 45, B8, 00000001
        mov     edx, dword [rbp-54H]                    ; 17B2 _ 8B. 55, AC
        mov     rax, rdx                                ; 17B5 _ 48: 89. D0
        shl     rax, 2                                  ; 17B8 _ 48: C1. E0, 02
        add     rax, rdx                                ; 17BC _ 48: 01. D0
        shl     rax, 2                                  ; 17BF _ 48: C1. E0, 02
        lea     rdx, [rel fp_formats]                   ; 17C3 _ 48: 8D. 15, 00000000(rel)
        add     rax, rdx                                ; 17CA _ 48: 01. D0
        mov     qword [rbp-28H], rax                    ; 17CD _ 48: 89. 45, D8
        call    scan                                    ; 17D1 _ E8, FFFFEE2B
        mov     eax, dword [rel tt]                     ; 17D6 _ 8B. 05, 00000000(rel)
        cmp     eax, 40                                 ; 17DC _ 83. F8, 28
        jz      ?_186                                   ; 17DF _ 74, 1E
        lea     rax, [rel ?_302]                        ; 17E1 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 17E8 _ 48: 89. C7
        mov     eax, 0                                  ; 17EB _ B8, 00000000
        call    nasm_nonfatal                           ; 17F0 _ E8, 00000000(PLT r)
        mov     eax, 0                                  ; 17F5 _ B8, 00000000
        jmp     ?_197                                   ; 17FA _ E9, 0000015C

?_186:  call    scan                                    ; 17FF _ E8, FFFFEDFD
        mov     eax, dword [rel tt]                     ; 1804 _ 8B. 05, 00000000(rel)
        cmp     eax, 45                                 ; 180A _ 83. F8, 2D
        jz      ?_187                                   ; 180D _ 74, 0B
        mov     eax, dword [rel tt]                     ; 180F _ 8B. 05, 00000000(rel)
        cmp     eax, 43                                 ; 1815 _ 83. F8, 2B
        jnz     ?_190                                   ; 1818 _ 75, 20
?_187:  mov     eax, dword [rel tt]                     ; 181A _ 8B. 05, 00000000(rel)
        cmp     eax, 45                                 ; 1820 _ 83. F8, 2D
        jnz     ?_188                                   ; 1823 _ 75, 09
        mov     dword [rbp-48H], -1                     ; 1825 _ C7. 45, B8, FFFFFFFF
        jmp     ?_189                                   ; 182C _ EB, 07

?_188:  mov     dword [rbp-48H], 1                      ; 182E _ C7. 45, B8, 00000001
?_189:  call    scan                                    ; 1835 _ E8, FFFFEDC7
?_190:  mov     eax, dword [rel tt]                     ; 183A _ 8B. 05, 00000000(rel)
        cmp     eax, 274                                ; 1840 _ 3D, 00000112
        jz      ?_191                                   ; 1845 _ 74, 1E
        lea     rax, [rel ?_303]                        ; 1847 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 184E _ 48: 89. C7
        mov     eax, 0                                  ; 1851 _ B8, 00000000
        call    nasm_nonfatal                           ; 1856 _ E8, 00000000(PLT r)
        mov     eax, 0                                  ; 185B _ B8, 00000000
        jmp     ?_197                                   ; 1860 _ E9, 000000F6

?_191:  mov     rax, qword [rel tokval]                 ; 1865 _ 48: 8B. 05, 00000000(rel)
        mov     rax, qword [rax+10H]                    ; 186C _ 48: 8B. 40, 10
        mov     ecx, dword [rbp-54H]                    ; 1870 _ 8B. 4D, AC
        lea     rdx, [rbp-20H]                          ; 1873 _ 48: 8D. 55, E0
        mov     esi, dword [rbp-48H]                    ; 1877 _ 8B. 75, B8
        mov     rdi, rax                                ; 187A _ 48: 89. C7
        call    float_const                             ; 187D _ E8, 00000000(PLT r)
        test    eax, eax                                ; 1882 _ 85. C0
        jnz     ?_192                                   ; 1884 _ 75, 0A
        mov     eax, 0                                  ; 1886 _ B8, 00000000
        jmp     ?_197                                   ; 188B _ E9, 000000CB

?_192:  call    scan                                    ; 1890 _ E8, FFFFED6C
        mov     eax, dword [rel tt]                     ; 1895 _ 8B. 05, 00000000(rel)
        cmp     eax, 41                                 ; 189B _ 83. F8, 29
        jz      ?_193                                   ; 189E _ 74, 1E
        lea     rax, [rel ?_304]                        ; 18A0 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 18A7 _ 48: 89. C7
        mov     eax, 0                                  ; 18AA _ B8, 00000000
        call    nasm_nonfatal                           ; 18AF _ E8, 00000000(PLT r)
        mov     eax, 0                                  ; 18B4 _ B8, 00000000
        jmp     ?_197                                   ; 18B9 _ E9, 0000009D

?_193:  mov     rax, qword [rbp-28H]                    ; 18BE _ 48: 8B. 45, D8
        mov     edx, dword [rax]                        ; 18C2 _ 8B. 10
        mov     rax, qword [rbp-28H]                    ; 18C4 _ 48: 8B. 45, D8
        mov     eax, dword [rax+10H]                    ; 18C8 _ 8B. 40, 10
        sub     edx, eax                                ; 18CB _ 29. C2
        movsxd  rax, edx                                ; 18CD _ 48: 63. C2
        mov     qword [rbp-30H], rax                    ; 18D0 _ 48: 89. 45, D0
        cmp     qword [rbp-30H], 8                      ; 18D4 _ 48: 83. 7D, D0, 08
        jbe     ?_194                                   ; 18D9 _ 76, 08
        mov     qword [rbp-30H], 8                      ; 18DB _ 48: C7. 45, D0, 00000008
?_194:  mov     rax, qword [rbp-28H]                    ; 18E3 _ 48: 8B. 45, D8
        mov     eax, dword [rax+10H]                    ; 18E7 _ 8B. 40, 10
        movsxd  rdx, eax                                ; 18EA _ 48: 63. D0
        mov     rax, qword [rbp-30H]                    ; 18ED _ 48: 8B. 45, D0
        add     rdx, rax                                ; 18F1 _ 48: 01. C2
        lea     rax, [rbp-20H]                          ; 18F4 _ 48: 8D. 45, E0
        add     rax, rdx                                ; 18F8 _ 48: 01. D0
        mov     qword [rbp-40H], rax                    ; 18FB _ 48: 89. 45, C0
        mov     qword [rbp-38H], 0                      ; 18FF _ 48: C7. 45, C8, 00000000
        mov     rax, qword [rbp-30H]                    ; 1907 _ 48: 8B. 45, D0
        mov     dword [rbp-44H], eax                    ; 190B _ 89. 45, BC
        jmp     ?_196                                   ; 190E _ EB, 25

?_195:  sub     qword [rbp-40H], 1                      ; 1910 _ 48: 83. 6D, C0, 01
        mov     rax, qword [rbp-38H]                    ; 1915 _ 48: 8B. 45, C8
        shl     rax, 8                                  ; 1919 _ 48: C1. E0, 08
        mov     rdx, rax                                ; 191D _ 48: 89. C2
        mov     rax, qword [rbp-40H]                    ; 1920 _ 48: 8B. 45, C0
        movzx   eax, byte [rax]                         ; 1924 _ 0F B6. 00
        movzx   eax, al                                 ; 1927 _ 0F B6. C0
        add     rax, rdx                                ; 192A _ 48: 01. D0
        mov     qword [rbp-38H], rax                    ; 192D _ 48: 89. 45, C8
        sub     dword [rbp-44H], 1                      ; 1931 _ 83. 6D, BC, 01
?_196:  cmp     dword [rbp-44H], 0                      ; 1935 _ 83. 7D, BC, 00
        jnz     ?_195                                   ; 1939 _ 75, D5
        call    begintemp                               ; 193B _ E8, FFFFE787
        mov     rax, qword [rbp-38H]                    ; 1940 _ 48: 8B. 45, C8
        mov     rsi, rax                                ; 1944 _ 48: 89. C6
        mov     edi, 346                                ; 1947 _ BF, 0000015A
        call    addtotemp                               ; 194C _ E8, FFFFE79E
        call    scan                                    ; 1951 _ E8, FFFFECAB
        call    finishtemp                              ; 1956 _ E8, FFFFE833
?_197:  mov     rdx, qword [rbp-8H]                     ; 195B _ 48: 8B. 55, F8
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        sub     rdx, qword [fs:abs 28H]                 ; 195F _ 64 48: 2B. 14 25, 00000028
        jz      ?_198                                   ; 1968 _ 74, 05
        call    __stack_chk_fail                        ; 196A _ E8, 00000000(PLT r)
?_198:  leave                                           ; 196F _ C9
        ret                                             ; 1970 _ C3

eval_strfunc:; Local function
        push    rbp                                     ; 1971 _ 55
        mov     rbp, rsp                                ; 1972 _ 48: 89. E5
        sub     rsp, 64                                 ; 1975 _ 48: 83. EC, 40
        mov     dword [rbp-34H], edi                    ; 1979 _ 89. 7D, CC
        mov     qword [rbp-40H], rsi                    ; 197C _ 48: 89. 75, C0
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        mov     rax, qword [fs:abs 28H]                 ; 1980 _ 64 48: 8B. 04 25, 00000028
        mov     qword [rbp-8H], rax                     ; 1989 _ 48: 89. 45, F8
        xor     eax, eax                                ; 198D _ 31. C0
        mov     byte [rbp-25H], 0                       ; 198F _ C6. 45, DB, 00
        call    scan                                    ; 1993 _ E8, FFFFEC69
        mov     eax, dword [rel tt]                     ; 1998 _ 8B. 05, 00000000(rel)
        cmp     eax, 40                                 ; 199E _ 83. F8, 28
        jnz     ?_199                                   ; 19A1 _ 75, 09
        mov     byte [rbp-25H], 1                       ; 19A3 _ C6. 45, DB, 01
        call    scan                                    ; 19A7 _ E8, FFFFEC55
?_199:  mov     eax, dword [rel tt]                     ; 19AC _ 8B. 05, 00000000(rel)
        cmp     eax, 271                                ; 19B2 _ 3D, 0000010F
        jz      ?_200                                   ; 19B7 _ 74, 25
        mov     rax, qword [rbp-40H]                    ; 19B9 _ 48: 8B. 45, C0
        lea     rdx, [rel ?_305]                        ; 19BD _ 48: 8D. 15, 00000000(rel)
        mov     rsi, rax                                ; 19C4 _ 48: 89. C6
        mov     rdi, rdx                                ; 19C7 _ 48: 89. D7
        mov     eax, 0                                  ; 19CA _ B8, 00000000
        call    nasm_nonfatal                           ; 19CF _ E8, 00000000(PLT r)
        mov     eax, 0                                  ; 19D4 _ B8, 00000000
        jmp     ?_204                                   ; 19D9 _ E9, 0000010B

?_200:  mov     rax, qword [rel tokval]                 ; 19DE _ 48: 8B. 05, 00000000(rel)
        mov     rax, qword [rax+8H]                     ; 19E5 _ 48: 8B. 40, 08
        mov     rsi, rax                                ; 19E9 _ 48: 89. C6
        mov     rax, qword [rel tokval]                 ; 19EC _ 48: 8B. 05, 00000000(rel)
        mov     rax, qword [rax+10H]                    ; 19F3 _ 48: 8B. 40, 10
        mov     ecx, dword [rbp-34H]                    ; 19F7 _ 8B. 4D, CC
        lea     rdx, [rbp-20H]                          ; 19FA _ 48: 8D. 55, E0
        mov     rdi, rax                                ; 19FE _ 48: 89. C7
        call    string_transform                        ; 1A01 _ E8, 00000000(PLT r)
        mov     qword [rbp-18H], rax                    ; 1A06 _ 48: 89. 45, E8
        cmp     qword [rbp-18H], -1                     ; 1A0A _ 48: 83. 7D, E8, FF
        jnz     ?_201                                   ; 1A0F _ 75, 25
        mov     rax, qword [rbp-40H]                    ; 1A11 _ 48: 8B. 45, C0
        lea     rdx, [rel ?_306]                        ; 1A15 _ 48: 8D. 15, 00000000(rel)
        mov     rsi, rax                                ; 1A1C _ 48: 89. C6
        mov     rdi, rdx                                ; 1A1F _ 48: 89. D7
        mov     eax, 0                                  ; 1A22 _ B8, 00000000
        call    nasm_nonfatal                           ; 1A27 _ E8, 00000000(PLT r)
        mov     eax, 0                                  ; 1A2C _ B8, 00000000
        jmp     ?_204                                   ; 1A31 _ E9, 000000B3

?_201:  mov     rax, qword [rbp-18H]                    ; 1A36 _ 48: 8B. 45, E8
        mov     ecx, eax                                ; 1A3A _ 89. C1
        mov     rax, qword [rbp-20H]                    ; 1A3C _ 48: 8B. 45, E0
        lea     rdx, [rbp-26H]                          ; 1A40 _ 48: 8D. 55, DA
        mov     esi, ecx                                ; 1A44 _ 89. CE
        mov     rdi, rax                                ; 1A46 _ 48: 89. C7
        call    readstrnum                              ; 1A49 _ E8, 00000000(PLT r)
        mov     qword [rbp-10H], rax                    ; 1A4E _ 48: 89. 45, F0
        mov     rax, qword [rbp-20H]                    ; 1A52 _ 48: 8B. 45, E0
        mov     rdi, rax                                ; 1A56 _ 48: 89. C7
        call    nasm_free                               ; 1A59 _ E8, 00000000(PLT r)
        cmp     byte [rbp-25H], 0                       ; 1A5E _ 80. 7D, DB, 00
        jz      ?_202                                   ; 1A62 _ 74, 2B
        call    scan                                    ; 1A64 _ E8, FFFFEB98
        mov     eax, dword [rel tt]                     ; 1A69 _ 8B. 05, 00000000(rel)
        cmp     eax, 41                                 ; 1A6F _ 83. F8, 29
        jz      ?_202                                   ; 1A72 _ 74, 1B
        lea     rax, [rel ?_304]                        ; 1A74 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 1A7B _ 48: 89. C7
        mov     eax, 0                                  ; 1A7E _ B8, 00000000
        call    nasm_nonfatal                           ; 1A83 _ E8, 00000000(PLT r)
        mov     eax, 0                                  ; 1A88 _ B8, 00000000
        jmp     ?_204                                   ; 1A8D _ EB, 5A

?_202:  movzx   eax, byte [rbp-26H]                     ; 1A8F _ 0F B6. 45, DA
        test    al, al                                  ; 1A93 _ 84. C0
        jz      ?_203                                   ; 1A95 _ 74, 32
        mov     dword [rbp-24H], 4456448                ; 1A97 _ C7. 45, DC, 00440000
        mov     eax, dword [rbp-24H]                    ; 1A9E _ 8B. 45, DC
        mov     edi, eax                                ; 1AA1 _ 89. C7
        call    warn_active                             ; 1AA3 _ E8, FFFFE57C
        movzx   eax, al                                 ; 1AA8 _ 0F B6. C0
        test    rax, rax                                ; 1AAB _ 48: 85. C0
        jz      ?_203                                   ; 1AAE _ 74, 19
        lea     rdx, [rel ?_307]                        ; 1AB0 _ 48: 8D. 15, 00000000(rel)
        mov     eax, dword [rbp-24H]                    ; 1AB7 _ 8B. 45, DC
        mov     rsi, rdx                                ; 1ABA _ 48: 89. D6
        mov     edi, eax                                ; 1ABD _ 89. C7
        mov     eax, 0                                  ; 1ABF _ B8, 00000000
        call    nasm_warn_                              ; 1AC4 _ E8, 00000000(PLT r)
?_203:  call    begintemp                               ; 1AC9 _ E8, FFFFE5F9
        mov     rax, qword [rbp-10H]                    ; 1ACE _ 48: 8B. 45, F0
        mov     rsi, rax                                ; 1AD2 _ 48: 89. C6
        mov     edi, 346                                ; 1AD5 _ BF, 0000015A
        call    addtotemp                               ; 1ADA _ E8, FFFFE610
        call    scan                                    ; 1ADF _ E8, FFFFEB1D
        call    finishtemp                              ; 1AE4 _ E8, FFFFE6A5
?_204:  mov     rdx, qword [rbp-8H]                     ; 1AE9 _ 48: 8B. 55, F8
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        sub     rdx, qword [fs:abs 28H]                 ; 1AED _ 64 48: 2B. 14 25, 00000028
        jz      ?_205                                   ; 1AF6 _ 74, 05
        call    __stack_chk_fail                        ; 1AF8 _ E8, 00000000(PLT r)
?_205:  leave                                           ; 1AFD _ C9
        ret                                             ; 1AFE _ C3

eval_ifunc:; Local function
        push    rbp                                     ; 1AFF _ 55
        mov     rbp, rsp                                ; 1B00 _ 48: 89. E5
        sub     rsp, 32                                 ; 1B03 _ 48: 83. EC, 20
        mov     qword [rbp-18H], rdi                    ; 1B07 _ 48: 89. 7D, E8
        mov     dword [rbp-1CH], esi                    ; 1B0B _ 89. 75, E4
        mov     rax, qword [rbp-18H]                    ; 1B0E _ 48: 8B. 45, E8
        mov     qword [rbp-8H], rax                     ; 1B12 _ 48: 89. 45, F8
        cmp     dword [rbp-1CH], 3                      ; 1B16 _ 83. 7D, E4, 03
        jz      ?_211                                   ; 1B1A _ 74, 6F
        cmp     dword [rbp-1CH], 3                      ; 1B1C _ 83. 7D, E4, 03
        ja      ?_213                                   ; 1B20 _ 0F 87, 00000091
        cmp     dword [rbp-1CH], 1                      ; 1B26 _ 83. 7D, E4, 01
        jbe     ?_206                                   ; 1B2A _ 76, 0B
        cmp     dword [rbp-1CH], 2                      ; 1B2C _ 83. 7D, E4, 02
        jz      ?_210                                   ; 1B30 _ 74, 45
        jmp     ?_213                                   ; 1B32 _ E9, 00000080

?_206:  cmp     qword [rbp-8H], 0                       ; 1B37 _ 48: 83. 7D, F8, 00
        jz      ?_207                                   ; 1B3C _ 74, 11
        mov     rax, qword [rbp-8H]                     ; 1B3E _ 48: 8B. 45, F8
        sub     rax, 1                                  ; 1B42 _ 48: 83. E8, 01
        and     rax, qword [rbp-8H]                     ; 1B46 _ 48: 23. 45, F8
        test    rax, rax                                ; 1B4A _ 48: 85. C0
        jz      ?_210                                   ; 1B4D _ 74, 28
?_207:  cmp     dword [rbp-1CH], 0                      ; 1B4F _ 83. 7D, E4, 00
        jnz     ?_208                                   ; 1B53 _ 75, 07
        mov     edx, 8                                  ; 1B55 _ BA, 00000008
        jmp     ?_209                                   ; 1B5A _ EB, 05

?_208:  mov     edx, 4456454                            ; 1B5C _ BA, 00440006
?_209:  lea     rax, [rel ?_308]                        ; 1B61 _ 48: 8D. 05, 00000000(rel)
        mov     rsi, rax                                ; 1B68 _ 48: 89. C6
        mov     edi, edx                                ; 1B6B _ 89. D7
        mov     eax, 0                                  ; 1B6D _ B8, 00000000
        call    nasm_error                              ; 1B72 _ E8, 00000000(PLT r)
?_210:  mov     rax, qword [rbp-8H]                     ; 1B77 _ 48: 8B. 45, F8
        mov     rdi, rax                                ; 1B7B _ 48: 89. C7
        call    ilog2_64                                ; 1B7E _ E8, 00000000(PLT r)
        mov     eax, eax                                ; 1B83 _ 89. C0
        mov     qword [rbp-10H], rax                    ; 1B85 _ 48: 89. 45, F0
        jmp     ?_214                                   ; 1B89 _ EB, 45

?_211:  cmp     qword [rbp-8H], 1                       ; 1B8B _ 48: 83. 7D, F8, 01
        jbe     ?_212                                   ; 1B90 _ 76, 1B
        mov     rax, qword [rbp-8H]                     ; 1B92 _ 48: 8B. 45, F8
        sub     rax, 1                                  ; 1B96 _ 48: 83. E8, 01
        mov     rdi, rax                                ; 1B9A _ 48: 89. C7
        call    ilog2_64                                ; 1B9D _ E8, 00000000(PLT r)
        add     eax, 1                                  ; 1BA2 _ 83. C0, 01
        mov     eax, eax                                ; 1BA5 _ 89. C0
        mov     qword [rbp-10H], rax                    ; 1BA7 _ 48: 89. 45, F0
        jmp     ?_214                                   ; 1BAB _ EB, 23

?_212:  mov     qword [rbp-10H], 0                      ; 1BAD _ 48: C7. 45, F0, 00000000
        jmp     ?_214                                   ; 1BB5 _ EB, 19

?_213:  mov     eax, dword [rbp-1CH]                    ; 1BB7 _ 8B. 45, E4
        lea     rdx, [rel ?_309]                        ; 1BBA _ 48: 8D. 15, 00000000(rel)
        mov     esi, eax                                ; 1BC1 _ 89. C6
        mov     rdi, rdx                                ; 1BC3 _ 48: 89. D7
        mov     eax, 0                                  ; 1BC6 _ B8, 00000000
        call    nasm_panic                              ; 1BCB _ E8, 00000000(PLT r)
?_214:  mov     rax, qword [rbp-10H]                    ; 1BD0 _ 48: 8B. 45, F0
        leave                                           ; 1BD4 _ C9
        ret                                             ; 1BD5 _ C3

expr6:  ; Local function
        push    rbp                                     ; 1BD6 _ 55
        mov     rbp, rsp                                ; 1BD7 _ 48: 89. E5
        sub     rsp, 64                                 ; 1BDA _ 48: 83. EC, 40
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        mov     rax, qword [fs:abs 28H]                 ; 1BDE _ 64 48: 8B. 04 25, 00000028
        mov     qword [rbp-8H], rax                     ; 1BE7 _ 48: 89. 45, F8
        xor     eax, eax                                ; 1BEB _ 31. C0
        mov     rax, qword [rel deadman]                ; 1BED _ 48: 8B. 05, 00000000(rel)
        add     rax, 1                                  ; 1BF4 _ 48: 83. C0, 01
        mov     qword [rel deadman], rax                ; 1BF8 _ 48: 89. 05, 00000000(rel)
        mov     rdx, qword [rel deadman]                ; 1BFF _ 48: 8B. 15, 00000000(rel)
        mov     rax, qword [rel nasm_limit+30H]         ; 1C06 _ 48: 8B. 05, 00000000(rel)
        cmp     rdx, rax                                ; 1C0D _ 48: 39. C2
        jle     ?_215                                   ; 1C10 _ 7E, 1E
        lea     rax, [rel ?_310]                        ; 1C12 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 1C19 _ 48: 89. C7
        mov     eax, 0                                  ; 1C1C _ B8, 00000000
        call    nasm_nonfatal                           ; 1C21 _ E8, 00000000(PLT r)
        mov     eax, 0                                  ; 1C26 _ B8, 00000000
        jmp     ?_269                                   ; 1C2B _ E9, 0000082B

?_215:  mov     eax, dword [rel tt]                     ; 1C30 _ 8B. 05, 00000000(rel)
        cmp     eax, 293                                ; 1C36 _ 3D, 00000125
        jg      ?_268                                   ; 1C3B _ 0F 8F, 00000801
        cmp     eax, 291                                ; 1C41 _ 3D, 00000123
        jge     ?_240                                   ; 1C46 _ 0F 8D, 0000041A
        cmp     eax, 284                                ; 1C4C _ 3D, 0000011C
        je      ?_240                                   ; 1C51 _ 0F 84, 0000040F
        cmp     eax, 284                                ; 1C57 _ 3D, 0000011C
        jg      ?_268                                   ; 1C5C _ 0F 8F, 000007E0
        cmp     eax, 283                                ; 1C62 _ 3D, 0000011B
        je      ?_227                                   ; 1C67 _ 0F 84, 00000247
        cmp     eax, 283                                ; 1C6D _ 3D, 0000011B
        jg      ?_268                                   ; 1C72 _ 0F 8F, 000007CA
        cmp     eax, 282                                ; 1C78 _ 3D, 0000011A
        je      ?_236                                   ; 1C7D _ 0F 84, 00000369
        cmp     eax, 282                                ; 1C83 _ 3D, 0000011A
        jg      ?_268                                   ; 1C88 _ 0F 8F, 000007B4
        cmp     eax, 281                                ; 1C8E _ 3D, 00000119
        je      ?_235                                   ; 1C93 _ 0F 84, 0000033D
        cmp     eax, 281                                ; 1C99 _ 3D, 00000119
        jg      ?_268                                   ; 1C9E _ 0F 8F, 0000079E
        cmp     eax, 278                                ; 1CA4 _ 3D, 00000116
        je      ?_231                                   ; 1CA9 _ 0F 84, 000002A5
        cmp     eax, 278                                ; 1CAF _ 3D, 00000116
        jg      ?_268                                   ; 1CB4 _ 0F 8F, 00000788
        cmp     eax, 276                                ; 1CBA _ 3D, 00000114
        jg      ?_268                                   ; 1CBF _ 0F 8F, 0000077D
        cmp     eax, 275                                ; 1CC5 _ 3D, 00000113
        jge     ?_240                                   ; 1CCA _ 0F 8D, 00000396
        cmp     eax, 273                                ; 1CD0 _ 3D, 00000111
        je      ?_240                                   ; 1CD5 _ 0F 84, 0000038B
        cmp     eax, 273                                ; 1CDB _ 3D, 00000111
        jg      ?_268                                   ; 1CE0 _ 0F 8F, 0000075C
        cmp     eax, 271                                ; 1CE6 _ 3D, 0000010F
        je      ?_240                                   ; 1CEB _ 0F 84, 00000375
        cmp     eax, 271                                ; 1CF1 _ 3D, 0000010F
        jg      ?_268                                   ; 1CF6 _ 0F 8F, 00000746
        cmp     eax, 269                                ; 1CFC _ 3D, 0000010D
        je      ?_240                                   ; 1D01 _ 0F 84, 0000035F
        cmp     eax, 269                                ; 1D07 _ 3D, 0000010D
        jg      ?_268                                   ; 1D0C _ 0F 8F, 00000730
        cmp     eax, 126                                ; 1D12 _ 83. F8, 7E
        je      ?_219                                   ; 1D15 _ 0F 84, 00000087
        cmp     eax, 126                                ; 1D1B _ 83. F8, 7E
        jg      ?_268                                   ; 1D1E _ 0F 8F, 0000071E
        cmp     eax, 45                                 ; 1D24 _ 83. F8, 2D
        jz      ?_216                                   ; 1D27 _ 74, 2E
        cmp     eax, 45                                 ; 1D29 _ 83. F8, 2D
        jg      ?_268                                   ; 1D2C _ 0F 8F, 00000710
        cmp     eax, 43                                 ; 1D32 _ 83. F8, 2B
        jz      ?_218                                   ; 1D35 _ 74, 5C
        cmp     eax, 43                                 ; 1D37 _ 83. F8, 2B
        jg      ?_268                                   ; 1D3A _ 0F 8F, 00000702
        cmp     eax, 33                                 ; 1D40 _ 83. F8, 21
        je      ?_223                                   ; 1D43 _ 0F 84, 000000DF
        cmp     eax, 40                                 ; 1D49 _ 83. F8, 28
        je      ?_237                                   ; 1D4C _ 0F 84, 000002BE
        jmp     ?_268                                   ; 1D52 _ E9, 000006EB

?_216:  call    scan                                    ; 1D57 _ E8, FFFFE8A5
        call    expr6                                   ; 1D5C _ E8, FFFFFE75
        mov     qword [rbp-20H], rax                    ; 1D61 _ 48: 89. 45, E0
        cmp     qword [rbp-20H], 0                      ; 1D65 _ 48: 83. 7D, E0, 00
        jnz     ?_217                                   ; 1D6A _ 75, 0A
        mov     eax, 0                                  ; 1D6C _ B8, 00000000
        jmp     ?_269                                   ; 1D71 _ E9, 000006E5

?_217:  mov     rax, qword [rbp-20H]                    ; 1D76 _ 48: 8B. 45, E0
        mov     edx, 0                                  ; 1D7A _ BA, 00000000
        mov     rsi, -1                                 ; 1D7F _ 48: C7. C6, FFFFFFFF
        mov     rdi, rax                                ; 1D86 _ 48: 89. C7
        call    scalar_mult                             ; 1D89 _ E8, FFFFE670
        jmp     ?_269                                   ; 1D8E _ E9, 000006C8

?_218:  call    scan                                    ; 1D93 _ E8, FFFFE869
        call    expr6                                   ; 1D98 _ E8, FFFFFE39
        jmp     ?_269                                   ; 1D9D _ E9, 000006B9

?_219:  call    scan                                    ; 1DA2 _ E8, FFFFE85A
        call    expr6                                   ; 1DA7 _ E8, FFFFFE2A
        mov     qword [rbp-20H], rax                    ; 1DAC _ 48: 89. 45, E0
        cmp     qword [rbp-20H], 0                      ; 1DB0 _ 48: 83. 7D, E0, 00
        jnz     ?_220                                   ; 1DB5 _ 75, 0A
        mov     eax, 0                                  ; 1DB7 _ B8, 00000000
        jmp     ?_269                                   ; 1DBC _ E9, 0000069A

?_220:  mov     rax, qword [rbp-20H]                    ; 1DC1 _ 48: 8B. 45, E0
        mov     rdi, rax                                ; 1DC5 _ 48: 89. C7
        call    is_just_unknown                         ; 1DC8 _ E8, 00000000(PLT r)
        test    al, al                                  ; 1DCD _ 84. C0
        jz      ?_221                                   ; 1DCF _ 74, 0A
        call    unknown_expr                            ; 1DD1 _ E8, FFFFE6F5
        jmp     ?_269                                   ; 1DD6 _ E9, 00000680

?_221:  mov     rax, qword [rbp-20H]                    ; 1DDB _ 48: 8B. 45, E0
        mov     rdi, rax                                ; 1DDF _ 48: 89. C7
        call    is_simple                               ; 1DE2 _ E8, 00000000(PLT r)
        xor     eax, 01H                                ; 1DE7 _ 83. F0, 01
        test    al, al                                  ; 1DEA _ 84. C0
        jz      ?_222                                   ; 1DEC _ 74, 1E
        lea     rax, [rel ?_311]                        ; 1DEE _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 1DF5 _ 48: 89. C7
        mov     eax, 0                                  ; 1DF8 _ B8, 00000000
        call    nasm_nonfatal                           ; 1DFD _ E8, 00000000(PLT r)
        mov     eax, 0                                  ; 1E02 _ B8, 00000000
        jmp     ?_269                                   ; 1E07 _ E9, 0000064F

?_222:  mov     rax, qword [rbp-20H]                    ; 1E0C _ 48: 8B. 45, E0
        mov     rdi, rax                                ; 1E10 _ 48: 89. C7
        call    reloc_value                             ; 1E13 _ E8, 00000000(PLT r)
        not     rax                                     ; 1E18 _ 48: F7. D0
        mov     rdi, rax                                ; 1E1B _ 48: 89. C7
        call    scalarvect                              ; 1E1E _ E8, FFFFE67F
        jmp     ?_269                                   ; 1E23 _ E9, 00000633

?_223:  call    scan                                    ; 1E28 _ E8, FFFFE7D4
        call    expr6                                   ; 1E2D _ E8, FFFFFDA4
        mov     qword [rbp-20H], rax                    ; 1E32 _ 48: 89. 45, E0
        cmp     qword [rbp-20H], 0                      ; 1E36 _ 48: 83. 7D, E0, 00
        jnz     ?_224                                   ; 1E3B _ 75, 0A
        mov     eax, 0                                  ; 1E3D _ B8, 00000000
        jmp     ?_269                                   ; 1E42 _ E9, 00000614

?_224:  mov     rax, qword [rbp-20H]                    ; 1E47 _ 48: 8B. 45, E0
        mov     rdi, rax                                ; 1E4B _ 48: 89. C7
        call    is_just_unknown                         ; 1E4E _ E8, 00000000(PLT r)
        test    al, al                                  ; 1E53 _ 84. C0
        jz      ?_225                                   ; 1E55 _ 74, 0A
        call    unknown_expr                            ; 1E57 _ E8, FFFFE66F
        jmp     ?_269                                   ; 1E5C _ E9, 000005FA

?_225:  mov     rax, qword [rbp-20H]                    ; 1E61 _ 48: 8B. 45, E0
        mov     rdi, rax                                ; 1E65 _ 48: 89. C7
        call    is_simple                               ; 1E68 _ E8, 00000000(PLT r)
        xor     eax, 01H                                ; 1E6D _ 83. F0, 01
        test    al, al                                  ; 1E70 _ 84. C0
        jz      ?_226                                   ; 1E72 _ 74, 1E
        lea     rax, [rel ?_312]                        ; 1E74 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 1E7B _ 48: 89. C7
        mov     eax, 0                                  ; 1E7E _ B8, 00000000
        call    nasm_nonfatal                           ; 1E83 _ E8, 00000000(PLT r)
        mov     eax, 0                                  ; 1E88 _ B8, 00000000
        jmp     ?_269                                   ; 1E8D _ E9, 000005C9

?_226:  mov     rax, qword [rbp-20H]                    ; 1E92 _ 48: 8B. 45, E0
        mov     rdi, rax                                ; 1E96 _ 48: 89. C7
        call    reloc_value                             ; 1E99 _ E8, 00000000(PLT r)
        test    rax, rax                                ; 1E9E _ 48: 85. C0
        sete    al                                      ; 1EA1 _ 0F 94. C0
        movzx   eax, al                                 ; 1EA4 _ 0F B6. C0
        mov     rdi, rax                                ; 1EA7 _ 48: 89. C7
        call    scalarvect                              ; 1EAA _ E8, FFFFE5F3
        jmp     ?_269                                   ; 1EAF _ E9, 000005A7

?_227:  mov     rax, qword [rel tokval]                 ; 1EB4 _ 48: 8B. 05, 00000000(rel)
        mov     rax, qword [rax]                        ; 1EBB _ 48: 8B. 00
        mov     dword [rbp-34H], eax                    ; 1EBE _ 89. 45, CC
        call    scan                                    ; 1EC1 _ E8, FFFFE73B
        call    expr6                                   ; 1EC6 _ E8, FFFFFD0B
        mov     qword [rbp-20H], rax                    ; 1ECB _ 48: 89. 45, E0
        cmp     qword [rbp-20H], 0                      ; 1ECF _ 48: 83. 7D, E0, 00
        jnz     ?_228                                   ; 1ED4 _ 75, 0A
        mov     eax, 0                                  ; 1ED6 _ B8, 00000000
        jmp     ?_269                                   ; 1EDB _ E9, 0000057B

?_228:  mov     rax, qword [rbp-20H]                    ; 1EE0 _ 48: 8B. 45, E0
        mov     rdi, rax                                ; 1EE4 _ 48: 89. C7
        call    is_just_unknown                         ; 1EE7 _ E8, 00000000(PLT r)
        test    al, al                                  ; 1EEC _ 84. C0
        jz      ?_229                                   ; 1EEE _ 74, 0A
        call    unknown_expr                            ; 1EF0 _ E8, FFFFE5D6
        jmp     ?_269                                   ; 1EF5 _ E9, 00000561

?_229:  mov     rax, qword [rbp-20H]                    ; 1EFA _ 48: 8B. 45, E0
        mov     rdi, rax                                ; 1EFE _ 48: 89. C7
        call    is_simple                               ; 1F01 _ E8, 00000000(PLT r)
        xor     eax, 01H                                ; 1F06 _ 83. F0, 01
        test    al, al                                  ; 1F09 _ 84. C0
        jz      ?_230                                   ; 1F0B _ 74, 1E
        lea     rax, [rel ?_313]                        ; 1F0D _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 1F14 _ 48: 89. C7
        mov     eax, 0                                  ; 1F17 _ B8, 00000000
        call    nasm_nonfatal                           ; 1F1C _ E8, 00000000(PLT r)
        mov     eax, 0                                  ; 1F21 _ B8, 00000000
        jmp     ?_269                                   ; 1F26 _ E9, 00000530

?_230:  mov     rax, qword [rbp-20H]                    ; 1F2B _ 48: 8B. 45, E0
        mov     rdi, rax                                ; 1F2F _ 48: 89. C7
        call    reloc_value                             ; 1F32 _ E8, 00000000(PLT r)
        mov     rdx, rax                                ; 1F37 _ 48: 89. C2
        mov     eax, dword [rbp-34H]                    ; 1F3A _ 8B. 45, CC
        mov     esi, eax                                ; 1F3D _ 89. C6
        mov     rdi, rdx                                ; 1F3F _ 48: 89. D7
        call    eval_ifunc                              ; 1F42 _ E8, FFFFFBB8
        mov     rdi, rax                                ; 1F47 _ 48: 89. C7
        call    scalarvect                              ; 1F4A _ E8, FFFFE553
        jmp     ?_269                                   ; 1F4F _ E9, 00000507

?_231:  call    scan                                    ; 1F54 _ E8, FFFFE6A8
        call    expr6                                   ; 1F59 _ E8, FFFFFC78
        mov     qword [rbp-20H], rax                    ; 1F5E _ 48: 89. 45, E0
        cmp     qword [rbp-20H], 0                      ; 1F62 _ 48: 83. 7D, E0, 00
        jnz     ?_232                                   ; 1F67 _ 75, 0A
        mov     eax, 0                                  ; 1F69 _ B8, 00000000
        jmp     ?_269                                   ; 1F6E _ E9, 000004E8

?_232:  mov     rax, qword [rbp-20H]                    ; 1F73 _ 48: 8B. 45, E0
        mov     rdi, rax                                ; 1F77 _ 48: 89. C7
        call    segment_part                            ; 1F7A _ E8, FFFFE56B
        mov     qword [rbp-20H], rax                    ; 1F7F _ 48: 89. 45, E0
        cmp     qword [rbp-20H], 0                      ; 1F83 _ 48: 83. 7D, E0, 00
        jnz     ?_233                                   ; 1F88 _ 75, 0A
        mov     eax, 0                                  ; 1F8A _ B8, 00000000
        jmp     ?_269                                   ; 1F8F _ E9, 000004C7

?_233:  mov     rax, qword [rbp-20H]                    ; 1F94 _ 48: 8B. 45, E0
        mov     rdi, rax                                ; 1F98 _ 48: 89. C7
        call    is_unknown                              ; 1F9B _ E8, 00000000(PLT r)
        test    al, al                                  ; 1FA0 _ 84. C0
        jz      ?_234                                   ; 1FA2 _ 74, 29
        movzx   eax, byte [rel critical]                ; 1FA4 _ 0F B6. 05, 00000000(rel)
        test    al, al                                  ; 1FAB _ 84. C0
        jz      ?_234                                   ; 1FAD _ 74, 1E
        lea     rax, [rel ?_314]                        ; 1FAF _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 1FB6 _ 48: 89. C7
        mov     eax, 0                                  ; 1FB9 _ B8, 00000000
        call    nasm_nonfatal                           ; 1FBE _ E8, 00000000(PLT r)
        mov     eax, 0                                  ; 1FC3 _ B8, 00000000
        jmp     ?_269                                   ; 1FC8 _ E9, 0000048E

?_234:  mov     rax, qword [rbp-20H]                    ; 1FCD _ 48: 8B. 45, E0
        jmp     ?_269                                   ; 1FD1 _ E9, 00000485

?_235:  mov     rax, qword [rel tokval]                 ; 1FD6 _ 48: 8B. 05, 00000000(rel)
        mov     rax, qword [rax]                        ; 1FDD _ 48: 8B. 00
        mov     edi, eax                                ; 1FE0 _ 89. C7
        call    eval_floatize                           ; 1FE2 _ E8, FFFFF7AA
        jmp     ?_269                                   ; 1FE7 _ E9, 0000046F

?_236:  mov     rax, qword [rel tokval]                 ; 1FEC _ 48: 8B. 05, 00000000(rel)
        mov     rax, qword [rax+10H]                    ; 1FF3 _ 48: 8B. 40, 10
        mov     rdx, qword [rel tokval]                 ; 1FF7 _ 48: 8B. 15, 00000000(rel)
        mov     rdx, qword [rdx]                        ; 1FFE _ 48: 8B. 12
        mov     rsi, rax                                ; 2001 _ 48: 89. C6
        mov     edi, edx                                ; 2004 _ 89. D7
        call    eval_strfunc                            ; 2006 _ E8, FFFFF966
        jmp     ?_269                                   ; 200B _ E9, 0000044B

?_237:  call    scan                                    ; 2010 _ E8, FFFFE5EC
        call    bexpr                                   ; 2015 _ E8, FFFFE616
        mov     qword [rbp-20H], rax                    ; 201A _ 48: 89. 45, E0
        cmp     qword [rbp-20H], 0                      ; 201E _ 48: 83. 7D, E0, 00
        jnz     ?_238                                   ; 2023 _ 75, 0A
        mov     eax, 0                                  ; 2025 _ B8, 00000000
        jmp     ?_269                                   ; 202A _ E9, 0000042C

?_238:  mov     eax, dword [rel tt]                     ; 202F _ 8B. 05, 00000000(rel)
        cmp     eax, 41                                 ; 2035 _ 83. F8, 29
        jz      ?_239                                   ; 2038 _ 74, 1E
        lea     rax, [rel ?_304]                        ; 203A _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 2041 _ 48: 89. C7
        mov     eax, 0                                  ; 2044 _ B8, 00000000
        call    nasm_nonfatal                           ; 2049 _ E8, 00000000(PLT r)
        mov     eax, 0                                  ; 204E _ B8, 00000000
        jmp     ?_269                                   ; 2053 _ E9, 00000403

?_239:  call    scan                                    ; 2058 _ E8, FFFFE5A4
        mov     rax, qword [rbp-20H]                    ; 205D _ 48: 8B. 45, E0
        jmp     ?_269                                   ; 2061 _ E9, 000003F5

?_240:  call    begintemp                               ; 2066 _ E8, FFFFE05C
        mov     eax, dword [rel tt]                     ; 206B _ 8B. 05, 00000000(rel)
        cmp     eax, 293                                ; 2071 _ 3D, 00000125
        je      ?_245                                   ; 2076 _ 0F 84, 0000017D
        cmp     eax, 293                                ; 207C _ 3D, 00000125
        jg      ?_267                                   ; 2081 _ 0F 8F, 000003AF
        cmp     eax, 292                                ; 2087 _ 3D, 00000124
        je      ?_244                                   ; 208C _ 0F 84, 00000108
        cmp     eax, 292                                ; 2092 _ 3D, 00000124
        jg      ?_267                                   ; 2097 _ 0F 8F, 00000399
        cmp     eax, 291                                ; 209D _ 3D, 00000123
        jz      ?_241                                   ; 20A2 _ 74, 60
        cmp     eax, 291                                ; 20A4 _ 3D, 00000123
        jg      ?_267                                   ; 20A9 _ 0F 8F, 00000387
        cmp     eax, 284                                ; 20AF _ 3D, 0000011C
        je      ?_264                                   ; 20B4 _ 0F 84, 0000035F
        cmp     eax, 284                                ; 20BA _ 3D, 0000011C
        jg      ?_267                                   ; 20BF _ 0F 8F, 00000371
        cmp     eax, 276                                ; 20C5 _ 3D, 00000114
        jg      ?_267                                   ; 20CA _ 0F 8F, 00000366
        cmp     eax, 275                                ; 20D0 _ 3D, 00000113
        jge     ?_245                                   ; 20D5 _ 0F 8D, 0000011E
        cmp     eax, 273                                ; 20DB _ 3D, 00000111
        je      ?_245                                   ; 20E0 _ 0F 84, 00000113
        cmp     eax, 273                                ; 20E6 _ 3D, 00000111
        jg      ?_267                                   ; 20EB _ 0F 8F, 00000345
        cmp     eax, 269                                ; 20F1 _ 3D, 0000010D
        jz      ?_241                                   ; 20F6 _ 74, 0C
        cmp     eax, 271                                ; 20F8 _ 3D, 0000010F
        jz      ?_242                                   ; 20FD _ 74, 21
        jmp     ?_267                                   ; 20FF _ E9, 00000332

?_241:  mov     rax, qword [rel tokval]                 ; 2104 _ 48: 8B. 05, 00000000(rel)
        mov     rax, qword [rax]                        ; 210B _ 48: 8B. 00
        mov     rsi, rax                                ; 210E _ 48: 89. C6
        mov     edi, 346                                ; 2111 _ BF, 0000015A
        call    addtotemp                               ; 2116 _ E8, FFFFDFD4
        jmp     ?_267                                   ; 211B _ E9, 00000316

?_242:  mov     rax, qword [rel tokval]                 ; 2120 _ 48: 8B. 05, 00000000(rel)
        mov     rax, qword [rax+8H]                     ; 2127 _ 48: 8B. 40, 08
        mov     ecx, eax                                ; 212B _ 89. C1
        mov     rax, qword [rel tokval]                 ; 212D _ 48: 8B. 05, 00000000(rel)
        mov     rax, qword [rax+10H]                    ; 2134 _ 48: 8B. 40, 10
        lea     rdx, [rbp-3DH]                          ; 2138 _ 48: 8D. 55, C3
        mov     esi, ecx                                ; 213C _ 89. CE
        mov     rdi, rax                                ; 213E _ 48: 89. C7
        call    readstrnum                              ; 2141 _ E8, 00000000(PLT r)
        mov     qword [rbp-10H], rax                    ; 2146 _ 48: 89. 45, F0
        movzx   eax, byte [rbp-3DH]                     ; 214A _ 0F B6. 45, C3
        test    al, al                                  ; 214E _ 84. C0
        jz      ?_243                                   ; 2150 _ 74, 32
        mov     dword [rbp-2CH], 4456448                ; 2152 _ C7. 45, D4, 00440000
        mov     eax, dword [rbp-2CH]                    ; 2159 _ 8B. 45, D4
        mov     edi, eax                                ; 215C _ 89. C7
        call    warn_active                             ; 215E _ E8, FFFFDEC1
        movzx   eax, al                                 ; 2163 _ 0F B6. C0
        test    rax, rax                                ; 2166 _ 48: 85. C0
        jz      ?_243                                   ; 2169 _ 74, 19
        lea     rdx, [rel ?_307]                        ; 216B _ 48: 8D. 15, 00000000(rel)
        mov     eax, dword [rbp-2CH]                    ; 2172 _ 8B. 45, D4
        mov     rsi, rdx                                ; 2175 _ 48: 89. D6
        mov     edi, eax                                ; 2178 _ 89. C7
        mov     eax, 0                                  ; 217A _ B8, 00000000
        call    nasm_warn_                              ; 217F _ E8, 00000000(PLT r)
?_243:  mov     rax, qword [rbp-10H]                    ; 2184 _ 48: 8B. 45, F0
        mov     rsi, rax                                ; 2188 _ 48: 89. C6
        mov     edi, 346                                ; 218B _ BF, 0000015A
        call    addtotemp                               ; 2190 _ E8, FFFFDF5A
        jmp     ?_267                                   ; 2195 _ E9, 0000029C

?_244:  mov     rax, qword [rel tokval]                 ; 219A _ 48: 8B. 05, 00000000(rel)
        mov     rax, qword [rax]                        ; 21A1 _ 48: 8B. 00
        mov     esi, 1                                  ; 21A4 _ BE, 00000001
        mov     edi, eax                                ; 21A9 _ 89. C7
        call    addtotemp                               ; 21AB _ E8, FFFFDF3F
        mov     rax, qword [rel hint]                   ; 21B0 _ 48: 8B. 05, 00000000(rel)
        test    rax, rax                                ; 21B7 _ 48: 85. C0
        je      ?_265                                   ; 21BA _ 0F 84, 00000272
        mov     rax, qword [rel hint]                   ; 21C0 _ 48: 8B. 05, 00000000(rel)
        mov     eax, dword [rax+8H]                     ; 21C7 _ 8B. 40, 08
        test    eax, eax                                ; 21CA _ 85. C0
        jne     ?_265                                   ; 21CC _ 0F 85, 00000260
        mov     rdx, qword [rel tokval]                 ; 21D2 _ 48: 8B. 15, 00000000(rel)
        mov     rax, qword [rel hint]                   ; 21D9 _ 48: 8B. 05, 00000000(rel)
        mov     rdx, qword [rdx]                        ; 21E0 _ 48: 8B. 12
        mov     qword [rax], rdx                        ; 21E3 _ 48: 89. 10
        mov     rax, qword [rel hint]                   ; 21E6 _ 48: 8B. 05, 00000000(rel)
        mov     dword [rax+8H], 1                       ; 21ED _ C7. 40, 08, 00000001
        jmp     ?_265                                   ; 21F4 _ E9, 00000239

?_245:  movzx   eax, byte [rel location+0CH]            ; 21F9 _ 0F B6. 05, 00000000(rel)
        xor     eax, 01H                                ; 2200 _ 83. F0, 01
        test    al, al                                  ; 2203 _ 84. C0
        jz      ?_249                                   ; 2205 _ 74, 5E
        mov     eax, dword [rel tt]                     ; 2207 _ 8B. 05, 00000000(rel)
        cmp     eax, 275                                ; 220D _ 3D, 00000113
        jz      ?_247                                   ; 2212 _ 74, 1F
        mov     eax, dword [rel tt]                     ; 2214 _ 8B. 05, 00000000(rel)
        cmp     eax, 276                                ; 221A _ 3D, 00000114
        jnz     ?_246                                   ; 221F _ 75, 09
        lea     rax, [rel ?_315]                        ; 2221 _ 48: 8D. 05, 00000000(rel)
        jmp     ?_248                                   ; 2228 _ EB, 10

?_246:  lea     rax, [rel ?_316]                        ; 222A _ 48: 8D. 05, 00000000(rel)
        jmp     ?_248                                   ; 2231 _ EB, 07

?_247:  lea     rax, [rel ?_317]                        ; 2233 _ 48: 8D. 05, 00000000(rel)
?_248:  lea     rdx, [rel ?_318]                        ; 223A _ 48: 8D. 15, 00000000(rel)
        mov     rsi, rax                                ; 2241 _ 48: 89. C6
        mov     rdi, rdx                                ; 2244 _ 48: 89. D7
        mov     eax, 0                                  ; 2247 _ B8, 00000000
        call    nasm_nonfatal                           ; 224C _ E8, 00000000(PLT r)
        mov     esi, 1                                  ; 2251 _ BE, 00000001
        mov     edi, 345                                ; 2256 _ BF, 00000159
        call    addtotemp                               ; 225B _ E8, FFFFDE8F
        jmp     ?_267                                   ; 2260 _ E9, 000001D1

?_249:  mov     dword [rbp-38H], 346                    ; 2265 _ C7. 45, C8, 0000015A
        mov     eax, dword [rel tt]                     ; 226C _ 8B. 05, 00000000(rel)
        cmp     eax, 276                                ; 2272 _ 3D, 00000114
        jnz     ?_252                                   ; 2277 _ 75, 29
        movzx   eax, byte [rel in_absolute]             ; 2279 _ 0F B6. 05, 00000000(rel)
        test    al, al                                  ; 2280 _ 84. C0
        jz      ?_250                                   ; 2282 _ 74, 08
        mov     eax, dword [rel absolute+8H]            ; 2284 _ 8B. 05, 00000000(rel)
        jmp     ?_251                                   ; 228A _ EB, 06

?_250:  mov     eax, dword [rel location+8H]            ; 228C _ 8B. 05, 00000000(rel)
?_251:  mov     dword [rbp-3CH], eax                    ; 2292 _ 89. 45, C4
        mov     qword [rbp-28H], 0                      ; 2295 _ 48: C7. 45, D8, 00000000
        jmp     ?_263                                   ; 229D _ E9, 00000148

?_252:  mov     eax, dword [rel tt]                     ; 22A2 _ 8B. 05, 00000000(rel)
        cmp     eax, 275                                ; 22A8 _ 3D, 00000113
        jnz     ?_257                                   ; 22AD _ 75, 40
        movzx   eax, byte [rel in_absolute]             ; 22AF _ 0F B6. 05, 00000000(rel)
        test    al, al                                  ; 22B6 _ 84. C0
        jz      ?_253                                   ; 22B8 _ 74, 08
        mov     eax, dword [rel absolute+8H]            ; 22BA _ 8B. 05, 00000000(rel)
        jmp     ?_254                                   ; 22C0 _ EB, 06

?_253:  mov     eax, dword [rel location+8H]            ; 22C2 _ 8B. 05, 00000000(rel)
?_254:  mov     dword [rbp-3CH], eax                    ; 22C8 _ 89. 45, C4
        movzx   eax, byte [rel in_absolute]             ; 22CB _ 0F B6. 05, 00000000(rel)
        test    al, al                                  ; 22D2 _ 84. C0
        jz      ?_255                                   ; 22D4 _ 74, 09
        mov     rax, qword [rel absolute]               ; 22D6 _ 48: 8B. 05, 00000000(rel)
        jmp     ?_256                                   ; 22DD _ EB, 07

?_255:  mov     rax, qword [rel location]               ; 22DF _ 48: 8B. 05, 00000000(rel)
?_256:  mov     qword [rbp-28H], rax                    ; 22E6 _ 48: 89. 45, D8
        jmp     ?_263                                   ; 22EA _ E9, 000000FB

?_257:  mov     rax, qword [rel tokval]                 ; 22EF _ 48: 8B. 05, 00000000(rel)
        mov     rax, qword [rax+10H]                    ; 22F6 _ 48: 8B. 40, 10
        lea     rdx, [rbp-28H]                          ; 22FA _ 48: 8D. 55, D8
        lea     rcx, [rbp-3CH]                          ; 22FE _ 48: 8D. 4D, C4
        mov     rsi, rcx                                ; 2302 _ 48: 89. CE
        mov     rdi, rax                                ; 2305 _ 48: 89. C7
        call    lookup_label                            ; 2308 _ E8, 00000000(PLT r)
        mov     dword [rbp-30H], eax                    ; 230D _ 89. 45, D0
        cmp     dword [rbp-30H], -1                     ; 2310 _ 83. 7D, D0, FF
        jne     ?_262                                   ; 2314 _ 0F 85, 000000A1
        mov     rax, qword [rel tokval]                 ; 231A _ 48: 8B. 05, 00000000(rel)
        mov     rax, qword [rax+10H]                    ; 2321 _ 48: 8B. 40, 10
        mov     rdi, rax                                ; 2325 _ 48: 89. C7
        call    local_scope                             ; 2328 _ E8, 00000000(PLT r)
        mov     qword [rbp-18H], rax                    ; 232D _ 48: 89. 45, E8
        movzx   eax, byte [rel critical]                ; 2331 _ 0F B6. 05, 00000000(rel)
        test    al, al                                  ; 2338 _ 84. C0
        jz      ?_260                                   ; 233A _ 74, 46
        call    pass_first                              ; 233C _ E8, FFFFDD22
        test    al, al                                  ; 2341 _ 84. C0
        jz      ?_258                                   ; 2343 _ 74, 09
        lea     rax, [rel ?_319]                        ; 2345 _ 48: 8D. 05, 00000000(rel)
        jmp     ?_259                                   ; 234C _ EB, 07

?_258:  lea     rax, [rel ?_320]                        ; 234E _ 48: 8D. 05, 00000000(rel)
?_259:  mov     rdx, qword [rel tokval]                 ; 2355 _ 48: 8B. 15, 00000000(rel)
        mov     rdx, qword [rdx+10H]                    ; 235C _ 48: 8B. 52, 10
        mov     rsi, qword [rbp-18H]                    ; 2360 _ 48: 8B. 75, E8
        lea     rdi, [rel ?_321]                        ; 2364 _ 48: 8D. 3D, 00000000(rel)
        mov     rcx, rax                                ; 236B _ 48: 89. C1
        mov     eax, 0                                  ; 236E _ B8, 00000000
        call    nasm_nonfatal                           ; 2373 _ E8, 00000000(PLT r)
        mov     eax, 0                                  ; 2378 _ B8, 00000000
        jmp     ?_269                                   ; 237D _ E9, 000000D9

?_260:  mov     rax, qword [rel opflags]                ; 2382 _ 48: 8B. 05, 00000000(rel)
        test    rax, rax                                ; 2389 _ 48: 85. C0
        jz      ?_261                                   ; 238C _ 74, 15
        mov     rax, qword [rel opflags]                ; 238E _ 48: 8B. 05, 00000000(rel)
        mov     edx, dword [rax]                        ; 2395 _ 8B. 10
        mov     rax, qword [rel opflags]                ; 2397 _ 48: 8B. 05, 00000000(rel)
        or      edx, 01H                                ; 239E _ 83. CA, 01
        mov     dword [rax], edx                        ; 23A1 _ 89. 10
?_261:  mov     dword [rbp-38H], 345                    ; 23A3 _ C7. 45, C8, 00000159
        mov     dword [rbp-3CH], -1                     ; 23AA _ C7. 45, C4, FFFFFFFF
        mov     qword [rbp-28H], 1                      ; 23B1 _ 48: C7. 45, D8, 00000001
        jmp     ?_263                                   ; 23B9 _ EB, 2F

?_262:  mov     eax, dword [rbp-30H]                    ; 23BB _ 8B. 45, D0
        mov     edi, eax                                ; 23BE _ 89. C7
        call    is_extern                               ; 23C0 _ E8, FFFFDC3B
        test    al, al                                  ; 23C5 _ 84. C0
        jz      ?_263                                   ; 23C7 _ 74, 21
        mov     rax, qword [rel opflags]                ; 23C9 _ 48: 8B. 05, 00000000(rel)
        test    rax, rax                                ; 23D0 _ 48: 85. C0
        jz      ?_263                                   ; 23D3 _ 74, 15
        mov     rax, qword [rel opflags]                ; 23D5 _ 48: 8B. 05, 00000000(rel)
        mov     edx, dword [rax]                        ; 23DC _ 8B. 10
        mov     rax, qword [rel opflags]                ; 23DE _ 48: 8B. 05, 00000000(rel)
        or      edx, 02H                                ; 23E5 _ 83. CA, 02
        mov     dword [rax], edx                        ; 23E8 _ 89. 10
?_263:  mov     rdx, qword [rbp-28H]                    ; 23EA _ 48: 8B. 55, D8
        mov     eax, dword [rbp-38H]                    ; 23EE _ 8B. 45, C8
        mov     rsi, rdx                                ; 23F1 _ 48: 89. D6
        mov     edi, eax                                ; 23F4 _ 89. C7
        call    addtotemp                               ; 23F6 _ E8, FFFFDCF4
        mov     eax, dword [rbp-3CH]                    ; 23FB _ 8B. 45, C4
        cmp     eax, -1                                 ; 23FE _ 83. F8, FF
        jz      ?_266                                   ; 2401 _ 74, 32
        mov     eax, dword [rbp-3CH]                    ; 2403 _ 8B. 45, C4
        add     eax, 349                                ; 2406 _ 05, 0000015D
        mov     esi, 1                                  ; 240B _ BE, 00000001
        mov     edi, eax                                ; 2410 _ 89. C7
        call    addtotemp                               ; 2412 _ E8, FFFFDCD8
        jmp     ?_266                                   ; 2417 _ EB, 1C

?_264:  mov     rax, qword [rel tokval]                 ; 2419 _ 48: 8B. 05, 00000000(rel)
        mov     rax, qword [rax]                        ; 2420 _ 48: 8B. 00
        mov     rsi, rax                                ; 2423 _ 48: 89. C6
        mov     edi, 348                                ; 2426 _ BF, 0000015C
        call    addtotemp                               ; 242B _ E8, FFFFDCBF
        jmp     ?_267                                   ; 2430 _ EB, 04

?_265:  nop                                             ; 2432 _ 90
        jmp     ?_267                                   ; 2433 _ EB, 01

?_266:  nop                                             ; 2435 _ 90
?_267:  call    scan                                    ; 2436 _ E8, FFFFE1C6
        call    finishtemp                              ; 243B _ E8, FFFFDD4E
        jmp     ?_269                                   ; 2440 _ EB, 19

?_268:  lea     rax, [rel ?_322]                        ; 2442 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 2449 _ 48: 89. C7
        mov     eax, 0                                  ; 244C _ B8, 00000000
        call    nasm_nonfatal                           ; 2451 _ E8, 00000000(PLT r)
        mov     eax, 0                                  ; 2456 _ B8, 00000000
?_269:  mov     rdx, qword [rbp-8H]                     ; 245B _ 48: 8B. 55, F8
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        sub     rdx, qword [fs:abs 28H]                 ; 245F _ 64 48: 2B. 14 25, 00000028
        jz      ?_270                                   ; 2468 _ 74, 05
        call    __stack_chk_fail                        ; 246A _ E8, 00000000(PLT r)
?_270:  leave                                           ; 246F _ C9
        ret                                             ; 2470 _ C3

evaluate:; Function begin
        push    rbp                                     ; 2471 _ 55
        mov     rbp, rsp                                ; 2472 _ 48: 89. E5
        sub     rsp, 80                                 ; 2475 _ 48: 83. EC, 50
        mov     qword [rbp-28H], rdi                    ; 2479 _ 48: 89. 7D, D8
        mov     qword [rbp-30H], rsi                    ; 247D _ 48: 89. 75, D0
        mov     qword [rbp-38H], rdx                    ; 2481 _ 48: 89. 55, C8
        mov     qword [rbp-40H], rcx                    ; 2485 _ 48: 89. 4D, C0
        mov     byte [rbp-41H], r8b                     ; 2489 _ 44: 88. 45, BF
        mov     qword [rbp-50H], r9                     ; 248D _ 4C: 89. 4D, B0
        mov     qword [rbp-18H], 0                      ; 2491 _ 48: C7. 45, E8, 00000000
        mov     qword [rel deadman], 0                  ; 2499 _ 48: C7. 05, 00000000(rel), 00000000
        mov     rax, qword [rbp-50H]                    ; 24A4 _ 48: 8B. 45, B0
        mov     qword [rel hint], rax                   ; 24A8 _ 48: 89. 05, 00000000(rel)
        mov     rax, qword [rel hint]                   ; 24AF _ 48: 8B. 05, 00000000(rel)
        test    rax, rax                                ; 24B6 _ 48: 85. C0
        jz      ?_271                                   ; 24B9 _ 74, 0E
        mov     rax, qword [rel hint]                   ; 24BB _ 48: 8B. 05, 00000000(rel)
        mov     dword [rax+8H], 0                       ; 24C2 _ C7. 40, 08, 00000000
?_271:  movzx   eax, byte [rbp-41H]                     ; 24C9 _ 0F B6. 45, BF
        mov     byte [rel critical], al                 ; 24CD _ 88. 05, 00000000(rel)
        mov     rax, qword [rbp-28H]                    ; 24D3 _ 48: 8B. 45, D8
        mov     qword [rel scanfunc], rax               ; 24D7 _ 48: 89. 05, 00000000(rel)
        mov     rax, qword [rbp-30H]                    ; 24DE _ 48: 8B. 45, D0
        mov     qword [rel scpriv], rax                 ; 24E2 _ 48: 89. 05, 00000000(rel)
        mov     rax, qword [rbp-38H]                    ; 24E9 _ 48: 8B. 45, C8
        mov     qword [rel tokval], rax                 ; 24ED _ 48: 89. 05, 00000000(rel)
        mov     rax, qword [rbp-40H]                    ; 24F4 _ 48: 8B. 45, C0
        mov     qword [rel opflags], rax                ; 24F8 _ 48: 89. 05, 00000000(rel)
        jmp     ?_273                                   ; 24FF _ EB, 31

?_272:  mov     rax, qword [rel tempexprs]              ; 2501 _ 48: 8B. 05, 00000000(rel)
        mov     edx, dword [rel ntempexprs]             ; 2508 _ 8B. 15, 00000000(rel)
        sub     edx, 1                                  ; 250E _ 83. EA, 01
        mov     dword [rel ntempexprs], edx             ; 2511 _ 89. 15, 00000000(rel)
        mov     edx, dword [rel ntempexprs]             ; 2517 _ 8B. 15, 00000000(rel)
        movsxd  rdx, edx                                ; 251D _ 48: 63. D2
        shl     rdx, 3                                  ; 2520 _ 48: C1. E2, 03
        add     rax, rdx                                ; 2524 _ 48: 01. D0
        mov     rax, qword [rax]                        ; 2527 _ 48: 8B. 00
        mov     rdi, rax                                ; 252A _ 48: 89. C7
        call    nasm_free                               ; 252D _ E8, 00000000(PLT r)
?_273:  mov     eax, dword [rel ntempexprs]             ; 2532 _ 8B. 05, 00000000(rel)
        test    eax, eax                                ; 2538 _ 85. C0
        jnz     ?_272                                   ; 253A _ 75, C5
        mov     rax, qword [rel tokval]                 ; 253C _ 48: 8B. 05, 00000000(rel)
        mov     eax, dword [rax+24H]                    ; 2543 _ 8B. 40, 24
        mov     dword [rel tt], eax                     ; 2546 _ 89. 05, 00000000(rel)
        mov     eax, dword [rel tt]                     ; 254C _ 8B. 05, 00000000(rel)
        cmp     eax, -1                                 ; 2552 _ 83. F8, FF
        jnz     ?_274                                   ; 2555 _ 75, 05
        call    scan                                    ; 2557 _ E8, FFFFE0A5
?_274:  call    bexpr                                   ; 255C _ E8, FFFFE0CF
        mov     qword [rbp-20H], rax                    ; 2561 _ 48: 89. 45, E0
        cmp     qword [rbp-20H], 0                      ; 2565 _ 48: 83. 7D, E0, 00
        jnz     ?_275                                   ; 256A _ 75, 0A
        mov     eax, 0                                  ; 256C _ B8, 00000000
        jmp     ?_283                                   ; 2571 _ E9, 0000014B

?_275:  mov     eax, dword [rel tt]                     ; 2576 _ 8B. 05, 00000000(rel)
        cmp     eax, 279                                ; 257C _ 3D, 00000117
        jnz     ?_276                                   ; 2581 _ 75, 1F
        call    scan                                    ; 2583 _ E8, FFFFE079
        call    expr6                                   ; 2588 _ E8, FFFFF649
        mov     qword [rbp-18H], rax                    ; 258D _ 48: 89. 45, E8
        cmp     qword [rbp-18H], 0                      ; 2591 _ 48: 83. 7D, E8, 00
        jnz     ?_276                                   ; 2596 _ 75, 0A
        mov     eax, 0                                  ; 2598 _ B8, 00000000
        jmp     ?_283                                   ; 259D _ E9, 0000011F

?_276:  mov     rax, qword [rbp-20H]                    ; 25A2 _ 48: 8B. 45, E0
        mov     edx, 0                                  ; 25A6 _ BA, 00000000
        mov     esi, 1                                  ; 25AB _ BE, 00000001
        mov     rdi, rax                                ; 25B0 _ 48: 89. C7
        call    scalar_mult                             ; 25B3 _ E8, FFFFDE46
        mov     qword [rbp-20H], rax                    ; 25B8 _ 48: 89. 45, E0
        cmp     qword [rbp-18H], 0                      ; 25BC _ 48: 83. 7D, E8, 00
        je      ?_282                                   ; 25C1 _ 0F 84, 000000F6
        mov     rax, qword [rbp-18H]                    ; 25C7 _ 48: 8B. 45, E8
        mov     rdi, rax                                ; 25CB _ 48: 89. C7
        call    is_just_unknown                         ; 25CE _ E8, 00000000(PLT r)
        test    al, al                                  ; 25D3 _ 84. C0
        jz      ?_277                                   ; 25D5 _ 74, 0E
        call    unknown_expr                            ; 25D7 _ E8, FFFFDEEF
        mov     qword [rbp-10H], rax                    ; 25DC _ 48: 89. 45, F0
        jmp     ?_281                                   ; 25E0 _ E9, 000000C1

?_277:  call    begintemp                               ; 25E5 _ E8, FFFFDADD
        mov     rax, qword [rbp-18H]                    ; 25EA _ 48: 8B. 45, E8
        mov     rdi, rax                                ; 25EE _ 48: 89. C7
        call    is_reloc                                ; 25F1 _ E8, 00000000(PLT r)
        xor     eax, 01H                                ; 25F6 _ 83. F0, 01
        test    al, al                                  ; 25F9 _ 84. C0
        jz      ?_278                                   ; 25FB _ 74, 1E
        lea     rax, [rel ?_323]                        ; 25FD _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 2604 _ 48: 89. C7
        mov     eax, 0                                  ; 2607 _ B8, 00000000
        call    nasm_nonfatal                           ; 260C _ E8, 00000000(PLT r)
        mov     eax, 0                                  ; 2611 _ B8, 00000000
        jmp     ?_283                                   ; 2616 _ E9, 000000A6

?_278:  mov     rax, qword [rbp-18H]                    ; 261B _ 48: 8B. 45, E8
        mov     rdi, rax                                ; 261F _ 48: 89. C7
        call    reloc_seg                               ; 2622 _ E8, 00000000(PLT r)
        cdqe                                            ; 2627 _ 48: 98
        mov     qword [rbp-8H], rax                     ; 2629 _ 48: 89. 45, F8
        cmp     qword [rbp-8H], -1                      ; 262D _ 48: 83. 7D, F8, FF
        jnz     ?_279                                   ; 2632 _ 75, 18
        mov     rax, qword [rbp-18H]                    ; 2634 _ 48: 8B. 45, E8
        mov     rdi, rax                                ; 2638 _ 48: 89. C7
        call    reloc_value                             ; 263B _ E8, 00000000(PLT r)
        or      rax, 40000000H                          ; 2640 _ 48: 0D, 40000000
        mov     qword [rbp-8H], rax                     ; 2646 _ 48: 89. 45, F8
        jmp     ?_280                                   ; 264A _ EB, 40

?_279:  mov     rax, qword [rbp-8H]                     ; 264C _ 48: 8B. 45, F8
        and     eax, 40000000H                          ; 2650 _ 25, 40000000
        test    rax, rax                                ; 2655 _ 48: 85. C0
        jnz     ?_280                                   ; 2658 _ 75, 32
        mov     rax, qword [rbp-8H]                     ; 265A _ 48: 8B. 45, F8
        and     eax, 01H                                ; 265E _ 83. E0, 01
        test    rax, rax                                ; 2661 _ 48: 85. C0
        jnz     ?_280                                   ; 2664 _ 75, 26
        movzx   eax, byte [rel critical]                ; 2666 _ 0F B6. 05, 00000000(rel)
        test    al, al                                  ; 266D _ 84. C0
        jz      ?_280                                   ; 266F _ 74, 1B
        lea     rax, [rel ?_323]                        ; 2671 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 2678 _ 48: 89. C7
        mov     eax, 0                                  ; 267B _ B8, 00000000
        call    nasm_nonfatal                           ; 2680 _ E8, 00000000(PLT r)
        mov     eax, 0                                  ; 2685 _ B8, 00000000
        jmp     ?_283                                   ; 268A _ EB, 35

?_280:  mov     rax, qword [rbp-8H]                     ; 268C _ 48: 8B. 45, F8
        mov     rsi, rax                                ; 2690 _ 48: 89. C6
        mov     edi, 347                                ; 2693 _ BF, 0000015B
        call    addtotemp                               ; 2698 _ E8, FFFFDA52
        call    finishtemp                              ; 269D _ E8, FFFFDAEC
        mov     qword [rbp-10H], rax                    ; 26A2 _ 48: 89. 45, F0
?_281:  mov     rdx, qword [rbp-10H]                    ; 26A6 _ 48: 8B. 55, F0
        mov     rax, qword [rbp-20H]                    ; 26AA _ 48: 8B. 45, E0
        mov     rsi, rdx                                ; 26AE _ 48: 89. D6
        mov     rdi, rax                                ; 26B1 _ 48: 89. C7
        call    add_vectors                             ; 26B4 _ E8, FFFFDB60
        mov     qword [rbp-20H], rax                    ; 26B9 _ 48: 89. 45, E0
?_282:  mov     rax, qword [rbp-20H]                    ; 26BD _ 48: 8B. 45, E0
?_283:  leave                                           ; 26C1 _ C9
        ret                                             ; 26C2 _ C3
; evaluate End of function


SECTION .data   align=1 noexec                          ; section number 2, data


SECTION .bss    align=8 noexec                          ; section number 3, bss

scanfunc:                                               ; virtual table or function pointer
        resq    1                                       ; 0000

scpriv: resq    1                                       ; 0008

tempexprs:                                              ; qword
        resq    1                                       ; 0010

ntempexprs:                                             ; dword
        resd    1                                       ; 0018

tempexprs_size:                                         ; dword
        resd    1                                       ; 001C

tempexpr: resq  1                                       ; 0020

ntempexpr:                                              ; dword
        resd    1                                       ; 0028

tempexpr_size:                                          ; dword
        resd    1                                       ; 002C

tokval: resq    1                                       ; 0030

tt:     resd    1                                       ; 0038

critical: resb  4                                       ; 003C

opflags: resq   1                                       ; 0040

hint:   resq    1                                       ; 0048

deadman: resq   1                                       ; 0050


SECTION .rodata align=8 noexec                          ; section number 4, const

?_284:                                                  ; byte
        db 63H, 61H, 6EH, 6EH, 6FH, 74H, 20H, 61H       ; 0000 _ cannot a
        db 70H, 70H, 6CH, 79H, 20H, 53H, 45H, 47H       ; 0008 _ pply SEG
        db 20H, 74H, 6FH, 20H, 61H, 20H, 6EH, 6FH       ; 0010 _  to a no
        db 6EH, 2DH, 72H, 65H, 6CH, 6FH, 63H, 61H       ; 0018 _ n-reloca
        db 74H, 61H, 62H, 6CH, 65H, 20H, 76H, 61H       ; 0020 _ table va
        db 6CH, 75H, 65H, 00H, 00H, 00H, 00H, 00H       ; 0028 _ lue.....

?_285:                                                  ; byte
        db 53H, 45H, 47H, 20H, 61H, 70H, 70H, 6CH       ; 0030 _ SEG appl
        db 69H, 65H, 64H, 20H, 74H, 6FH, 20H, 73H       ; 0038 _ ied to s
        db 6FH, 6DH, 65H, 74H, 68H, 69H, 6EH, 67H       ; 0040 _ omething
        db 20H, 77H, 68H, 69H, 63H, 68H, 20H, 69H       ; 0048 _  which i
        db 73H, 20H, 61H, 6CH, 72H, 65H, 61H, 64H       ; 0050 _ s alread
        db 79H, 20H, 61H, 20H, 73H, 65H, 67H, 6DH       ; 0058 _ y a segm
        db 65H, 6EH, 74H, 20H, 62H, 61H, 73H, 65H       ; 0060 _ ent base
        db 00H                                          ; 0068 _ .

?_286:                                                  ; byte
        db 60H, 3FH, 27H, 20H, 77H, 69H, 74H, 68H       ; 0069 _ `?' with
        db 6FH, 75H, 74H, 20H, 6DH, 61H, 74H, 63H       ; 0071 _ out matc
        db 68H, 69H, 6EH, 67H, 20H, 60H, 3AH, 27H       ; 0079 _ hing `:'
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H            ; 0081 _ .......

?_287:                                                  ; byte
        db 74H, 68H, 65H, 20H, 6CH, 65H, 66H, 74H       ; 0088 _ the left
        db 2DH, 68H, 61H, 6EH, 64H, 20H, 73H, 69H       ; 0090 _ -hand si
        db 64H, 65H, 20H, 6FH, 66H, 20H, 60H, 3FH       ; 0098 _ de of `?
        db 27H, 20H, 6DH, 75H, 73H, 74H, 20H, 62H       ; 00A0 _ ' must b
        db 65H, 20H, 61H, 20H, 73H, 63H, 61H, 6CH       ; 00A8 _ e a scal
        db 61H, 72H, 20H, 76H, 61H, 6CH, 75H, 65H       ; 00B0 _ ar value
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 00B8 _ ........

?_288:                                                  ; byte
        db 60H, 7CH, 27H, 20H, 6FH, 70H, 65H, 72H       ; 00C0 _ `|' oper
        db 61H, 74H, 6FH, 72H, 20H, 6DH, 61H, 79H       ; 00C8 _ ator may
        db 20H, 6FH, 6EH, 6CH, 79H, 20H, 62H, 65H       ; 00D0 _  only be
        db 20H, 61H, 70H, 70H, 6CH, 69H, 65H, 64H       ; 00D8 _  applied
        db 20H, 74H, 6FH, 20H, 73H, 63H, 61H, 6CH       ; 00E0 _  to scal
        db 61H, 72H, 20H, 76H, 61H, 6CH, 75H, 65H       ; 00E8 _ ar value
        db 73H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 00F0 _ s.......

?_289:                                                  ; byte
        db 60H, 5EH, 27H, 20H, 6FH, 70H, 65H, 72H       ; 00F8 _ `^' oper
        db 61H, 74H, 6FH, 72H, 20H, 6DH, 61H, 79H       ; 0100 _ ator may
        db 20H, 6FH, 6EH, 6CH, 79H, 20H, 62H, 65H       ; 0108 _  only be
        db 20H, 61H, 70H, 70H, 6CH, 69H, 65H, 64H       ; 0110 _  applied
        db 20H, 74H, 6FH, 20H, 73H, 63H, 61H, 6CH       ; 0118 _  to scal
        db 61H, 72H, 20H, 76H, 61H, 6CH, 75H, 65H       ; 0120 _ ar value
        db 73H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0128 _ s.......

?_290:                                                  ; byte
        db 60H, 26H, 27H, 20H, 6FH, 70H, 65H, 72H       ; 0130 _ `&' oper
        db 61H, 74H, 6FH, 72H, 20H, 6DH, 61H, 79H       ; 0138 _ ator may
        db 20H, 6FH, 6EH, 6CH, 79H, 20H, 62H, 65H       ; 0140 _  only be
        db 20H, 61H, 70H, 70H, 6CH, 69H, 65H, 64H       ; 0148 _  applied
        db 20H, 74H, 6FH, 20H, 73H, 63H, 61H, 6CH       ; 0150 _  to scal
        db 61H, 72H, 20H, 76H, 61H, 6CH, 75H, 65H       ; 0158 _ ar value
        db 73H, 00H                                     ; 0160 _ s.

?_291:                                                  ; byte
        db 3CH, 3DH, 3EH, 00H                           ; 0162 _ <=>.

?_292:                                                  ; byte
        db 3CH, 69H, 6EH, 74H, 65H, 72H, 6EH, 61H       ; 0166 _ <interna
        db 6CH, 20H, 65H, 72H, 72H, 6FH, 72H, 3EH       ; 016E _ l error>
        db 00H                                          ; 0176 _ .

?_293:                                                  ; byte
        db 3EH, 00H                                     ; 0177 _ >.

?_294:                                                  ; byte
        db 3EH, 3DH, 00H                                ; 0179 _ >=.

?_295:                                                  ; byte
        db 3CH, 00H                                     ; 017C _ <.

?_296:                                                  ; byte
        db 3CH, 3DH, 00H, 00H, 00H, 00H, 00H, 00H       ; 017E _ <=......
        db 00H, 00H                                     ; 0186 _ ..

?_297:                                                  ; byte
        db 60H, 25H, 73H, 27H, 3AH, 20H, 6FH, 70H       ; 0188 _ `%s': op
        db 65H, 72H, 61H, 6EH, 64H, 73H, 20H, 64H       ; 0190 _ erands d
        db 69H, 66H, 66H, 65H, 72H, 20H, 62H, 79H       ; 0198 _ iffer by
        db 20H, 61H, 20H, 6EH, 6FH, 6EH, 2DH, 73H       ; 01A0 _  a non-s
        db 63H, 61H, 6CH, 61H, 72H, 00H, 00H, 00H       ; 01A8 _ calar...

?_298:                                                  ; byte
        db 73H, 68H, 69H, 66H, 74H, 20H, 6FH, 70H       ; 01B0 _ shift op
        db 65H, 72H, 61H, 74H, 6FH, 72H, 20H, 6DH       ; 01B8 _ erator m
        db 61H, 79H, 20H, 6FH, 6EH, 6CH, 79H, 20H       ; 01C0 _ ay only 
        db 62H, 65H, 20H, 61H, 70H, 70H, 6CH, 69H       ; 01C8 _ be appli
        db 65H, 64H, 20H, 74H, 6FH, 20H, 73H, 63H       ; 01D0 _ ed to sc
        db 61H, 6CH, 61H, 72H, 20H, 76H, 61H, 6CH       ; 01D8 _ alar val
        db 75H, 65H, 73H, 00H, 00H, 00H, 00H, 00H       ; 01E0 _ ues.....

?_299:                                                  ; byte
        db 64H, 69H, 76H, 69H, 73H, 69H, 6FH, 6EH       ; 01E8 _ division
        db 20H, 6FH, 70H, 65H, 72H, 61H, 74H, 6FH       ; 01F0 _  operato
        db 72H, 20H, 6DH, 61H, 79H, 20H, 6FH, 6EH       ; 01F8 _ r may on
        db 6CH, 79H, 20H, 62H, 65H, 20H, 61H, 70H       ; 0200 _ ly be ap
        db 70H, 6CH, 69H, 65H, 64H, 20H, 74H, 6FH       ; 0208 _ plied to
        db 20H, 73H, 63H, 61H, 6CH, 61H, 72H, 20H       ; 0210 _  scalar 
        db 76H, 61H, 6CH, 75H, 65H, 73H, 00H            ; 0218 _ values.

?_300:                                                  ; byte
        db 64H, 69H, 76H, 69H, 73H, 69H, 6FH, 6EH       ; 021F _ division
        db 20H, 62H, 79H, 20H, 7AH, 65H, 72H, 6FH       ; 0227 _  by zero
        db 00H                                          ; 022F _ .

?_301:                                                  ; byte
        db 75H, 6EH, 61H, 62H, 6CH, 65H, 20H, 74H       ; 0230 _ unable t
        db 6FH, 20H, 6DH, 75H, 6CH, 74H, 69H, 70H       ; 0238 _ o multip
        db 6CH, 79H, 20H, 74H, 77H, 6FH, 20H, 6EH       ; 0240 _ ly two n
        db 6FH, 6EH, 2DH, 73H, 63H, 61H, 6CH, 61H       ; 0248 _ on-scala
        db 72H, 20H, 6FH, 62H, 6AH, 65H, 63H, 74H       ; 0250 _ r object
        db 73H, 00H                                     ; 0258 _ s.

?_302:                                                  ; byte
        db 65H, 78H, 70H, 65H, 63H, 74H, 69H, 6EH       ; 025A _ expectin
        db 67H, 20H, 60H, 28H, 27H, 00H                 ; 0262 _ g `('.

?_303:                                                  ; byte
        db 65H, 78H, 70H, 65H, 63H, 74H, 69H, 6EH       ; 0268 _ expectin
        db 67H, 20H, 66H, 6CH, 6FH, 61H, 74H, 69H       ; 0270 _ g floati
        db 6EH, 67H, 2DH, 70H, 6FH, 69H, 6EH, 74H       ; 0278 _ ng-point
        db 20H, 6EH, 75H, 6DH, 62H, 65H, 72H, 00H       ; 0280 _  number.

?_304:                                                  ; byte
        db 65H, 78H, 70H, 65H, 63H, 74H, 69H, 6EH       ; 0288 _ expectin
        db 67H, 20H, 60H, 29H, 27H, 00H, 00H, 00H       ; 0290 _ g `)'...

?_305:                                                  ; byte
        db 65H, 78H, 70H, 65H, 63H, 74H, 69H, 6EH       ; 0298 _ expectin
        db 67H, 20H, 73H, 74H, 72H, 69H, 6EH, 67H       ; 02A0 _ g string
        db 20H, 61H, 73H, 20H, 61H, 72H, 67H, 75H       ; 02A8 _  as argu
        db 6DH, 65H, 6EH, 74H, 20H, 74H, 6FH, 20H       ; 02B0 _ ment to 
        db 25H, 73H, 00H                                ; 02B8 _ %s.

?_306:                                                  ; byte
        db 69H, 6EH, 76H, 61H, 6CH, 69H, 64H, 20H       ; 02BB _ invalid 
        db 69H, 6EH, 70H, 75H, 74H, 20H, 73H, 74H       ; 02C3 _ input st
        db 72H, 69H, 6EH, 67H, 20H, 74H, 6FH, 20H       ; 02CB _ ring to 
        db 25H, 73H, 00H                                ; 02D3 _ %s.

?_307:                                                  ; byte
        db 63H, 68H, 61H, 72H, 61H, 63H, 74H, 65H       ; 02D6 _ characte
        db 72H, 20H, 63H, 6FH, 6EH, 73H, 74H, 61H       ; 02DE _ r consta
        db 6EH, 74H, 20H, 74H, 6FH, 6FH, 20H, 6CH       ; 02E6 _ nt too l
        db 6FH, 6EH, 67H, 00H, 00H, 00H, 00H, 00H       ; 02EE _ ong.....
        db 00H, 00H                                     ; 02F6 _ ..

?_308:                                                  ; byte
        db 69H, 6CH, 6FH, 67H, 32H, 20H, 61H, 72H       ; 02F8 _ ilog2 ar
        db 67H, 75H, 6DH, 65H, 6EH, 74H, 20H, 69H       ; 0300 _ gument i
        db 73H, 20H, 6EH, 6FH, 74H, 20H, 61H, 20H       ; 0308 _ s not a 
        db 70H, 6FH, 77H, 65H, 72H, 20H, 6FH, 66H       ; 0310 _ power of
        db 20H, 74H, 77H, 6FH, 00H                      ; 0318 _  two.

?_309:                                                  ; byte
        db 69H, 6EH, 76H, 61H, 6CH, 69H, 64H, 20H       ; 031D _ invalid 
        db 49H, 46H, 55H, 4EH, 43H, 20H, 74H, 6FH       ; 0325 _ IFUNC to
        db 6BH, 65H, 6EH, 20H, 25H, 64H, 00H            ; 032D _ ken %d.

?_310:                                                  ; byte
        db 65H, 78H, 70H, 72H, 65H, 73H, 73H, 69H       ; 0334 _ expressi
        db 6FH, 6EH, 20H, 74H, 6FH, 6FH, 20H, 6CH       ; 033C _ on too l
        db 6FH, 6EH, 67H, 00H                           ; 0344 _ ong.

?_311:                                                  ; byte
        db 60H, 7EH, 27H, 20H, 6FH, 70H, 65H, 72H       ; 0348 _ `~' oper
        db 61H, 74H, 6FH, 72H, 20H, 6DH, 61H, 79H       ; 0350 _ ator may
        db 20H, 6FH, 6EH, 6CH, 79H, 20H, 62H, 65H       ; 0358 _  only be
        db 20H, 61H, 70H, 70H, 6CH, 69H, 65H, 64H       ; 0360 _  applied
        db 20H, 74H, 6FH, 20H, 73H, 63H, 61H, 6CH       ; 0368 _  to scal
        db 61H, 72H, 20H, 76H, 61H, 6CH, 75H, 65H       ; 0370 _ ar value
        db 73H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0378 _ s.......

?_312:                                                  ; byte
        db 60H, 21H, 27H, 20H, 6FH, 70H, 65H, 72H       ; 0380 _ `!' oper
        db 61H, 74H, 6FH, 72H, 20H, 6DH, 61H, 79H       ; 0388 _ ator may
        db 20H, 6FH, 6EH, 6CH, 79H, 20H, 62H, 65H       ; 0390 _  only be
        db 20H, 61H, 70H, 70H, 6CH, 69H, 65H, 64H       ; 0398 _  applied
        db 20H, 74H, 6FH, 20H, 73H, 63H, 61H, 6CH       ; 03A0 _  to scal
        db 61H, 72H, 20H, 76H, 61H, 6CH, 75H, 65H       ; 03A8 _ ar value
        db 73H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 03B0 _ s.......

?_313:                                                  ; byte
        db 66H, 75H, 6EH, 63H, 74H, 69H, 6FH, 6EH       ; 03B8 _ function
        db 20H, 6DH, 61H, 79H, 20H, 6FH, 6EH, 6CH       ; 03C0 _  may onl
        db 79H, 20H, 62H, 65H, 20H, 61H, 70H, 70H       ; 03C8 _ y be app
        db 6CH, 69H, 65H, 64H, 20H, 74H, 6FH, 20H       ; 03D0 _ lied to 
        db 73H, 63H, 61H, 6CH, 61H, 72H, 20H, 76H       ; 03D8 _ scalar v
        db 61H, 6CH, 75H, 65H, 73H, 00H, 00H, 00H       ; 03E0 _ alues...

?_314:                                                  ; byte
        db 75H, 6EH, 61H, 62H, 6CH, 65H, 20H, 74H       ; 03E8 _ unable t
        db 6FH, 20H, 64H, 65H, 74H, 65H, 72H, 6DH       ; 03F0 _ o determ
        db 69H, 6EH, 65H, 20H, 73H, 65H, 67H, 6DH       ; 03F8 _ ine segm
        db 65H, 6EH, 74H, 20H, 62H, 61H, 73H, 65H       ; 0400 _ ent base
        db 00H                                          ; 0408 _ .

?_315:                                                  ; byte
        db 60H, 24H, 24H, 27H, 00H                      ; 0409 _ `$$'.

?_316:                                                  ; byte
        db 73H, 79H, 6DH, 62H, 6FH, 6CH, 20H, 72H       ; 040E _ symbol r
        db 65H, 66H, 65H, 72H, 65H, 6EH, 63H, 65H       ; 0416 _ eference
        db 73H, 00H                                     ; 041E _ s.

?_317:                                                  ; byte
        db 60H, 24H, 27H, 00H, 00H, 00H, 00H, 00H       ; 0420 _ `$'.....

?_318:                                                  ; byte
        db 25H, 73H, 20H, 6EH, 6FH, 74H, 20H, 73H       ; 0428 _ %s not s
        db 75H, 70H, 70H, 6FH, 72H, 74H, 65H, 64H       ; 0430 _ upported
        db 20H, 69H, 6EH, 20H, 70H, 72H, 65H, 70H       ; 0438 _  in prep
        db 72H, 6FH, 63H, 65H, 73H, 73H, 2DH, 6FH       ; 0440 _ rocess-o
        db 6EH, 6CH, 79H, 20H, 6DH, 6FH, 64H, 65H       ; 0448 _ nly mode
        db 00H                                          ; 0450 _ .

?_319:                                                  ; byte
        db 20H, 62H, 65H, 66H, 6FH, 72H, 65H, 20H       ; 0451 _  before 
        db 75H, 73H, 65H, 00H                           ; 0459 _ use.

?_320:                                                  ; byte
        db 00H                                          ; 045D _ .

?_321:                                                  ; byte
        db 73H, 79H, 6DH, 62H, 6FH, 6CH, 20H, 60H       ; 045E _ symbol `
        db 25H, 73H, 25H, 73H, 27H, 20H, 6EH, 6FH       ; 0466 _ %s%s' no
        db 74H, 20H, 64H, 65H, 66H, 69H, 6EH, 65H       ; 046E _ t define
        db 64H, 25H, 73H, 00H                           ; 0476 _ d%s.

?_322:                                                  ; byte
        db 65H, 78H, 70H, 72H, 65H, 73H, 73H, 69H       ; 047A _ expressi
        db 6FH, 6EH, 20H, 73H, 79H, 6EH, 74H, 61H       ; 0482 _ on synta
        db 78H, 20H, 65H, 72H, 72H, 6FH, 72H, 00H       ; 048A _ x error.
        db 00H, 00H, 00H, 00H, 00H, 00H                 ; 0492 _ ......

?_323:                                                  ; byte
        db 69H, 6EH, 76H, 61H, 6CH, 69H, 64H, 20H       ; 0498 _ invalid 
        db 72H, 69H, 67H, 68H, 74H, 2DH, 68H, 61H       ; 04A0 _ right-ha
        db 6EH, 64H, 20H, 6FH, 70H, 65H, 72H, 61H       ; 04A8 _ nd opera
        db 6EH, 64H, 20H, 74H, 6FH, 20H, 57H, 52H       ; 04B0 _ nd to WR
        db 54H, 00H                                     ; 04B8 _ T.


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
        dd is_extern-$-20H                              ; 0020 _ 00000000 (rel)
        dd 00000024H, 100E4100H                         ; 0024 _ 36 269369600 
        dd 0D430286H, 070C5F06H                         ; 002C _ 222495366 118251270 
        dd 00000008H, 0000001CH                         ; 0034 _ 8 28 
        dd 0000003CH                                    ; 003C _ 60 
        dd is_extern-$-1CH                              ; 0040 _ 00000000 (rel)
        dd 00000033H, 100E4100H                         ; 0044 _ 51 269369600 
        dd 0D430286H, 070C6E06H                         ; 004C _ 222495366 118255110 
        dd 00000008H, 0000001CH                         ; 0054 _ 8 28 
        dd 0000005CH                                    ; 005C _ 92 
        dd is_extern-$-9H                               ; 0060 _ 00000000 (rel)
        dd 0000000CH, 100E4100H                         ; 0064 _ 12 269369600 
        dd 0D430286H, 070C4706H                         ; 006C _ 222495366 118245126 
        dd 00000008H, 0000001CH                         ; 0074 _ 8 28 
        dd 0000007CH                                    ; 007C _ 124 
        dd is_extern-$-1DH                              ; 0080 _ 00000000 (rel)
        dd 00000011H, 100E4100H                         ; 0084 _ 17 269369600 
        dd 0D430286H, 070C4C06H                         ; 008C _ 222495366 118246406 
        dd 00000008H, 0000001CH                         ; 0094 _ 8 28 
        dd 0000009CH                                    ; 009C _ 156 
        dd is_extern-$-2CH                              ; 00A0 _ 00000000 (rel)
        dd 00000053H, 100E4100H                         ; 00A4 _ 83 269369600 
        dd 0D430286H, 0C4E0206H                         ; 00AC _ 222495366 206438918 
        dd 00000807H, 0000001CH                         ; 00B4 _ 2055 28 
        dd 000000BCH                                    ; 00BC _ 188 
        dd is_extern-$+7H                               ; 00C0 _ 00000000 (rel)
        dd 00000028H, 100E4100H                         ; 00C4 _ 40 269369600 
        dd 0D430286H, 070C6306H                         ; 00CC _ 222495366 118252294 
        dd 00000008H, 0000001CH                         ; 00D4 _ 8 28 
        dd 000000DCH                                    ; 00DC _ 220 
        dd is_extern-$+0FH                              ; 00E0 _ 00000000 (rel)
        dd 0000009FH, 100E4100H                         ; 00E4 _ 159 269369600 
        dd 0D430286H, 0C9A0206H                         ; 00EC _ 222495366 211419654 
        dd 00000807H, 0000001CH                         ; 00F4 _ 2055 28 
        dd 000000FCH                                    ; 00FC _ 252 
        dd is_extern-$+8EH                              ; 0100 _ 00000000 (rel)
        dd 0000008BH, 100E4100H                         ; 0104 _ 139 269369600 
        dd 0D430286H, 0C860206H                         ; 010C _ 222495366 210108934 
        dd 00000807H, 0000001CH                         ; 0114 _ 2055 28 
        dd 0000011CH                                    ; 011C _ 284 
        dd is_extern-$+0F9H                             ; 0120 _ 00000000 (rel)
        dd 000001E5H, 100E4100H                         ; 0124 _ 485 269369600 
        dd 0D430286H, 01E00306H                         ; 012C _ 222495366 31458054 
        dd 0008070CH, 0000001CH                         ; 0134 _ 526092 28 
        dd 0000013CH                                    ; 013C _ 316 
        dd is_extern-$+2BEH                             ; 0140 _ 00000000 (rel)
        dd 000000A4H, 100E4100H                         ; 0144 _ 164 269369600 
        dd 0D430286H, 0C9F0206H                         ; 014C _ 222495366 211747334 
        dd 00000807H, 0000001CH                         ; 0154 _ 2055 28 
        dd 0000015CH                                    ; 015C _ 348 
        dd is_extern-$+342H                             ; 0160 _ 00000000 (rel)
        dd 00000029H, 100E4100H                         ; 0164 _ 41 269369600 
        dd 0D430286H, 070C6406H                         ; 016C _ 222495366 118252550 
        dd 00000008H, 0000001CH                         ; 0174 _ 8 28 
        dd 0000017CH                                    ; 017C _ 380 
        dd is_extern-$+34BH                             ; 0180 _ 00000000 (rel)
        dd 0000001FH, 100E4100H                         ; 0184 _ 31 269369600 
        dd 0D430286H, 070C5A06H                         ; 018C _ 222495366 118249990 
        dd 00000008H, 0000001CH                         ; 0194 _ 8 28 
        dd 0000019CH                                    ; 019C _ 412 
        dd is_extern-$+34AH                             ; 01A0 _ 00000000 (rel)
        dd 00000117H, 100E4100H                         ; 01A4 _ 279 269369600 
        dd 0D430286H, 01120306H                         ; 01AC _ 222495366 17957638 
        dd 0008070CH, 0000001CH                         ; 01B4 _ 526092 28 
        dd 000001BCH                                    ; 01BC _ 444 
        dd is_extern-$+441H                             ; 01C0 _ 00000000 (rel)
        dd 0000002FH, 100E4100H                         ; 01C4 _ 47 269369600 
        dd 0D430286H, 070C6A06H                         ; 01CC _ 222495366 118254086 
        dd 00000008H, 0000001CH                         ; 01D4 _ 8 28 
        dd 000001DCH                                    ; 01DC _ 476 
        dd is_extern-$+450H                             ; 01E0 _ 00000000 (rel)
        dd 0000000BH, 100E4100H                         ; 01E4 _ 11 269369600 
        dd 0D430286H, 070C4606H                         ; 01EC _ 222495366 118244870 
        dd 00000008H, 0000001CH                         ; 01F4 _ 8 28 
        dd 000001FCH                                    ; 01FC _ 508 
        dd is_extern-$+43BH                             ; 0200 _ 00000000 (rel)
        dd 000000FFH, 100E4100H                         ; 0204 _ 255 269369600 
        dd 0D430286H, 0CFA0206H                         ; 020C _ 222495366 217711110 
        dd 00000807H, 0000001CH                         ; 0214 _ 2055 28 
        dd 0000021CH                                    ; 021C _ 540 
        dd is_extern-$+51AH                             ; 0220 _ 00000000 (rel)
        dd 00000123H, 100E4100H                         ; 0224 _ 291 269369600 
        dd 0D430286H, 011E0306H                         ; 022C _ 222495366 18744070 
        dd 0008070CH, 00000020H                         ; 0234 _ 526092 32 
        dd 0000023CH                                    ; 023C _ 572 
        dd is_extern-$+61DH                             ; 0240 _ 00000000 (rel)
        dd 00000126H, 100E4100H                         ; 0244 _ 294 269369600 
        dd 0D430286H, 03834506H                         ; 024C _ 222495366 58934534 
        dd 0C011C03H, 00000807H                         ; 0254 _ 201399299 2055 
        dd 0000001CH, 00000260H                         ; 025C _ 28 608 
        dd is_extern-$+71FH                             ; 0264 _ 00000000 (rel)
        dd 00000123H, 100E4100H                         ; 0268 _ 291 269369600 
        dd 0D430286H, 011E0306H                         ; 0270 _ 222495366 18744070 
        dd 0008070CH, 0000001CH                         ; 0278 _ 526092 28 
        dd 00000280H                                    ; 0280 _ 640 
        dd is_extern-$+822H                             ; 0284 _ 00000000 (rel)
        dd 000002F6H, 100E4100H                         ; 0288 _ 758 269369600 
        dd 0D430286H, 02F10306H                         ; 0290 _ 222495366 49349382 
        dd 0008070CH, 00000020H                         ; 0298 _ 526092 32 
        dd 000002A0H                                    ; 02A0 _ 672 
        dd is_extern-$+0AF8H                            ; 02A4 _ 00000000 (rel)
        dd 00000114H, 100E4100H                         ; 02A8 _ 276 269369600 
        dd 0D430286H, 03834506H                         ; 02B0 _ 222495366 58934534 
        dd 0C010A03H, 00000807H                         ; 02B8 _ 201394691 2055 
        dd 00000020H, 000002C4H                         ; 02C0 _ 32 708 
        dd is_extern-$+0BE8H                            ; 02C8 _ 00000000 (rel)
        dd 00000114H, 100E4100H                         ; 02CC _ 276 269369600 
        dd 0D430286H, 03834506H                         ; 02D4 _ 222495366 58934534 
        dd 0C010A03H, 00000807H                         ; 02DC _ 201394691 2055 
        dd 00000020H, 000002E8H                         ; 02E4 _ 32 744 
        dd is_extern-$+0CD8H                            ; 02EC _ 00000000 (rel)
        dd 00000114H, 100E4100H                         ; 02F0 _ 276 269369600 
        dd 0D430286H, 03834506H                         ; 02F8 _ 222495366 58934534 
        dd 0C010A03H, 00000807H                         ; 0300 _ 201394691 2055 
        dd 00000020H, 0000030CH                         ; 0308 _ 32 780 
        dd is_extern-$+0DC8H                            ; 0310 _ 00000000 (rel)
        dd 000001E2H, 100E4100H                         ; 0314 _ 482 269369600 
        dd 0D430286H, 03834506H                         ; 031C _ 222495366 58934534 
        dd 0C01D803H, 00000807H                         ; 0324 _ 201447427 2055 
        dd 0000001CH, 00000330H                         ; 032C _ 28 816 
        dd is_extern-$+0F86H                            ; 0334 _ 00000000 (rel)
        dd 000000C5H, 100E4100H                         ; 0338 _ 197 269369600 
        dd 0D430286H, 0CC00206H                         ; 0340 _ 222495366 213910022 
        dd 00000807H, 00000020H                         ; 0348 _ 2055 32 
        dd 00000350H                                    ; 0350 _ 848 
        dd is_extern-$+102BH                            ; 0354 _ 00000000 (rel)
        dd 00000412H, 100E4100H                         ; 0358 _ 1042 269369600 
        dd 0D430286H, 03834506H                         ; 0360 _ 222495366 58934534 
        dd 0C040803H, 00000807H                         ; 0368 _ 201590787 2055 
        dd 0000001CH, 00000374H                         ; 0370 _ 28 884 
        dd is_extern-$+1419H                            ; 0378 _ 00000000 (rel)
        dd 000001E0H, 100E4100H                         ; 037C _ 480 269369600 
        dd 0D430286H, 01DB0306H                         ; 0384 _ 222495366 31130374 
        dd 0008070CH, 0000001CH                         ; 038C _ 526092 28 
        dd 00000394H                                    ; 0394 _ 916 
        dd is_extern-$+15D9H                            ; 0398 _ 00000000 (rel)
        dd 0000018EH, 100E4100H                         ; 039C _ 398 269369600 
        dd 0D430286H, 01890306H                         ; 03A4 _ 222495366 25756422 
        dd 0008070CH, 0000001CH                         ; 03AC _ 526092 28 
        dd 000003B4H                                    ; 03B4 _ 948 
        dd is_extern-$+1747H                            ; 03B8 _ 00000000 (rel)
        dd 000000D7H, 100E4100H                         ; 03BC _ 215 269369600 
        dd 0D430286H, 0CD20206H                         ; 03C4 _ 222495366 215089670 
        dd 00000807H, 0000001CH                         ; 03CC _ 2055 28 
        dd 000003D4H                                    ; 03D4 _ 980 
        dd is_extern-$+17FEH                            ; 03D8 _ 00000000 (rel)
        dd 0000089BH, 100E4100H                         ; 03DC _ 2203 269369600 
        dd 0D430286H, 08960306H                         ; 03E4 _ 222495366 144048902 
        dd 0008070CH, 0000001CH                         ; 03EC _ 526092 28 
        dd 000003F4H                                    ; 03F4 _ 1012 
        dd is_extern-$+2079H                            ; 03F8 _ 00000000 (rel)
        dd 00000252H, 100E4100H                         ; 03FC _ 594 269369600 
        dd 0D430286H, 024D0306H                         ; 0404 _ 222495366 38601478 
        dd 0008070CH                                    ; 040C _ 526092 


