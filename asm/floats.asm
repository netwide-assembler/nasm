; Disassembly of file: /tmp/tmp.SmWaKnPcGO.o
; Wed Sep 23 14:43:28 2026
; Type: ELF64
; Syntax: NASM
; Instruction set: Pentium Pro, x64

default rel

global float_const: function
global float_deffmt: function
global float_option: function
global fp_formats

extern strcasecmp                                       ; near
extern strlen                                           ; near
extern nasm_assert_failed                               ; near
extern memcpy                                           ; near
extern nasm_nonfatalf                                   ; near
extern nasm_warn_                                       ; near
extern nasm_nonfatal                                    ; near
extern __stack_chk_fail                                 ; near
extern memset                                           ; near
extern warning_state                                    ; byte
extern erropt                                           ; dword


SECTION .text   align=1 exec                            ; section number 1, code

nasm_hexval:; Local function
        push    rbp                                     ; 0000 _ 55
        mov     rbp, rsp                                ; 0001 _ 48: 89. E5
        mov     byte [rbp-11H], dil                     ; 0004 _ 40: 88. 7D, EF
        movzx   eax, byte [rbp-11H]                     ; 0008 _ 0F B6. 45, EF
        movzx   eax, al                                 ; 000C _ 0F B6. C0
        mov     dword [rbp-4H], eax                     ; 000F _ 89. 45, FC
        cmp     dword [rbp-4H], 47                      ; 0012 _ 83. 7D, FC, 2F
        jbe     ?_001                                   ; 0016 _ 76, 0E
        cmp     dword [rbp-4H], 57                      ; 0018 _ 83. 7D, FC, 39
        ja      ?_001                                   ; 001C _ 77, 08
        mov     eax, dword [rbp-4H]                     ; 001E _ 8B. 45, FC
        sub     eax, 48                                 ; 0021 _ 83. E8, 30
        jmp     ?_002                                   ; 0024 _ EB, 09

?_001:  mov     eax, dword [rbp-4H]                     ; 0026 _ 8B. 45, FC
        or      eax, 20H                                ; 0029 _ 83. C8, 20
        sub     eax, 87                                 ; 002C _ 83. E8, 57
?_002:  pop     rbp                                     ; 002F _ 5D
        ret                                             ; 0030 _ C3

warn_active:; Local function
        push    rbp                                     ; 0031 _ 55
        mov     rbp, rsp                                ; 0032 _ 48: 89. E5
        mov     dword [rbp-4H], edi                     ; 0035 _ 89. 7D, FC
        mov     eax, dword [rel erropt+0CH]             ; 0038 _ 8B. 05, 00000000(rel)
        and     eax, dword [rbp-4H]                     ; 003E _ 23. 45, FC
        test    eax, eax                                ; 0041 _ 85. C0
        jz      ?_003                                   ; 0043 _ 74, 07
        mov     eax, 0                                  ; 0045 _ B8, 00000000
        jmp     ?_004                                   ; 004A _ EB, 16

?_003:  mov     eax, dword [rbp-4H]                     ; 004C _ 8B. 45, FC
        shr     eax, 16                                 ; 004F _ C1. E8, 10
        mov     edx, eax                                ; 0052 _ 89. C2
        lea     rax, [rel warning_state]                ; 0054 _ 48: 8D. 05, 00000000(rel)
        movzx   eax, byte [rdx+rax]                     ; 005B _ 0F B6. 04 02
        and     eax, 01H                                ; 005F _ 83. E0, 01
?_004:  pop     rbp                                     ; 0062 _ 5D
        ret                                             ; 0063 _ C3

float_multiply:; Local function
        push    rbp                                     ; 0064 _ 55
        mov     rbp, rsp                                ; 0065 _ 48: 89. E5
        sub     rsp, 144                                ; 0068 _ 48: 81. EC, 00000090
        mov     qword [rbp-88H], rdi                    ; 006F _ 48: 89. BD, FFFFFF78
        mov     qword [rbp-90H], rsi                    ; 0076 _ 48: 89. B5, FFFFFF70
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        mov     rax, qword [fs:abs 28H]                 ; 007D _ 64 48: 8B. 04 25, 00000028
        mov     qword [rbp-8H], rax                     ; 0086 _ 48: 89. 45, F8
        xor     eax, eax                                ; 008A _ 31. C0
        lea     rax, [rbp-70H]                          ; 008C _ 48: 8D. 45, 90
        mov     edx, 96                                 ; 0090 _ BA, 00000060
        mov     esi, 0                                  ; 0095 _ BE, 00000000
        mov     rdi, rax                                ; 009A _ 48: 89. C7
        call    memset                                  ; 009D _ E8, 00000000(PLT r)
        mov     dword [rbp-80H], 0                      ; 00A2 _ C7. 45, 80, 00000000
        jmp     ?_008                                   ; 00A9 _ E9, 000000B9

?_005:  mov     dword [rbp-7CH], 0                      ; 00AE _ C7. 45, 84, 00000000
        jmp     ?_007                                   ; 00B5 _ E9, 0000009F

?_006:  mov     eax, dword [rbp-80H]                    ; 00BA _ 8B. 45, 80
        cdqe                                            ; 00BD _ 48: 98
        lea     rdx, [rax*4]                            ; 00BF _ 48: 8D. 14 85, 00000000
        mov     rax, qword [rbp-88H]                    ; 00C7 _ 48: 8B. 85, FFFFFF78
        add     rax, rdx                                ; 00CE _ 48: 01. D0
        mov     eax, dword [rax]                        ; 00D1 _ 8B. 00
        mov     ecx, eax                                ; 00D3 _ 89. C1
        mov     eax, dword [rbp-7CH]                    ; 00D5 _ 8B. 45, 84
        cdqe                                            ; 00D8 _ 48: 98
        lea     rdx, [rax*4]                            ; 00DA _ 48: 8D. 14 85, 00000000
        mov     rax, qword [rbp-90H]                    ; 00E2 _ 48: 8B. 85, FFFFFF70
        add     rax, rdx                                ; 00E9 _ 48: 01. D0
        mov     eax, dword [rax]                        ; 00EC _ 8B. 00
        mov     eax, eax                                ; 00EE _ 89. C0
        imul    rax, rcx                                ; 00F0 _ 48: 0F AF. C1
        mov     qword [rbp-78H], rax                    ; 00F4 _ 48: 89. 45, 88
        mov     edx, dword [rbp-80H]                    ; 00F8 _ 8B. 55, 80
        mov     eax, dword [rbp-7CH]                    ; 00FB _ 8B. 45, 84
        add     eax, edx                                ; 00FE _ 01. D0
        cdqe                                            ; 0100 _ 48: 98
        mov     rax, qword [rbp+rax*8-70H]              ; 0102 _ 48: 8B. 44 C5, 90
        mov     rdx, qword [rbp-78H]                    ; 0107 _ 48: 8B. 55, 88
        mov     rsi, rdx                                ; 010B _ 48: 89. D6
        shr     rsi, 32                                 ; 010E _ 48: C1. EE, 20
        mov     ecx, dword [rbp-80H]                    ; 0112 _ 8B. 4D, 80
        mov     edx, dword [rbp-7CH]                    ; 0115 _ 8B. 55, 84
        add     ecx, edx                                ; 0118 _ 01. D1
        lea     rdx, [rax+rsi]                          ; 011A _ 48: 8D. 14 30
        movsxd  rax, ecx                                ; 011E _ 48: 63. C1
        mov     qword [rbp+rax*8-70H], rdx              ; 0121 _ 48: 89. 54 C5, 90
        mov     edx, dword [rbp-80H]                    ; 0126 _ 8B. 55, 80
        mov     eax, dword [rbp-7CH]                    ; 0129 _ 8B. 45, 84
        add     eax, edx                                ; 012C _ 01. D0
        add     eax, 1                                  ; 012E _ 83. C0, 01
        cdqe                                            ; 0131 _ 48: 98
        mov     rax, qword [rbp+rax*8-70H]              ; 0133 _ 48: 8B. 44 C5, 90
        mov     rdx, qword [rbp-78H]                    ; 0138 _ 48: 8B. 55, 88
        mov     esi, edx                                ; 013C _ 89. D6
        mov     ecx, dword [rbp-80H]                    ; 013E _ 8B. 4D, 80
        mov     edx, dword [rbp-7CH]                    ; 0141 _ 8B. 55, 84
        add     edx, ecx                                ; 0144 _ 01. CA
        lea     ecx, [rdx+1H]                           ; 0146 _ 8D. 4A, 01
        lea     rdx, [rax+rsi]                          ; 0149 _ 48: 8D. 14 30
        movsxd  rax, ecx                                ; 014D _ 48: 63. C1
        mov     qword [rbp+rax*8-70H], rdx              ; 0150 _ 48: 89. 54 C5, 90
        add     dword [rbp-7CH], 1                      ; 0155 _ 83. 45, 84, 01
?_007:  cmp     dword [rbp-7CH], 5                      ; 0159 _ 83. 7D, 84, 05
        jle     ?_006                                   ; 015D _ 0F 8E, FFFFFF57
        add     dword [rbp-80H], 1                      ; 0163 _ 83. 45, 80, 01
?_008:  cmp     dword [rbp-80H], 5                      ; 0167 _ 83. 7D, 80, 05
        jle     ?_005                                   ; 016B _ 0F 8E, FFFFFF3D
        mov     dword [rbp-80H], 12                     ; 0171 _ C7. 45, 80, 0000000C
        jmp     ?_010                                   ; 0178 _ EB, 44

?_009:  mov     eax, dword [rbp-80H]                    ; 017A _ 8B. 45, 80
        sub     eax, 1                                  ; 017D _ 83. E8, 01
        cdqe                                            ; 0180 _ 48: 98
        mov     rdx, qword [rbp+rax*8-70H]              ; 0182 _ 48: 8B. 54 C5, 90
        mov     eax, dword [rbp-80H]                    ; 0187 _ 8B. 45, 80
        cdqe                                            ; 018A _ 48: 98
        mov     rax, qword [rbp+rax*8-70H]              ; 018C _ 48: 8B. 44 C5, 90
        shr     rax, 32                                 ; 0191 _ 48: C1. E8, 20
        mov     rcx, rax                                ; 0195 _ 48: 89. C1
        mov     eax, dword [rbp-80H]                    ; 0198 _ 8B. 45, 80
        sub     eax, 1                                  ; 019B _ 83. E8, 01
        add     rdx, rcx                                ; 019E _ 48: 01. CA
        cdqe                                            ; 01A1 _ 48: 98
        mov     qword [rbp+rax*8-70H], rdx              ; 01A3 _ 48: 89. 54 C5, 90
        mov     eax, dword [rbp-80H]                    ; 01A8 _ 8B. 45, 80
        cdqe                                            ; 01AB _ 48: 98
        mov     rax, qword [rbp+rax*8-70H]              ; 01AD _ 48: 8B. 44 C5, 90
        mov     edx, eax                                ; 01B2 _ 89. C2
        mov     eax, dword [rbp-80H]                    ; 01B4 _ 8B. 45, 80
        cdqe                                            ; 01B7 _ 48: 98
        mov     qword [rbp+rax*8-70H], rdx              ; 01B9 _ 48: 89. 54 C5, 90
?_010:  sub     dword [rbp-80H], 1                      ; 01BE _ 83. 6D, 80, 01
        cmp     dword [rbp-80H], 0                      ; 01C2 _ 83. 7D, 80, 00
        jnz     ?_009                                   ; 01C6 _ 75, B2
        mov     rax, qword [rbp-70H]                    ; 01C8 _ 48: 8B. 45, 90
        and     eax, 80000000H                          ; 01CC _ 25, 80000000
        test    rax, rax                                ; 01D1 _ 48: 85. C0
        jz      ?_013                                   ; 01D4 _ 74, 3F
        mov     dword [rbp-80H], 0                      ; 01D6 _ C7. 45, 80, 00000000
        jmp     ?_012                                   ; 01DD _ EB, 29

?_011:  mov     eax, dword [rbp-80H]                    ; 01DF _ 8B. 45, 80
        cdqe                                            ; 01E2 _ 48: 98
        mov     rcx, qword [rbp+rax*8-70H]              ; 01E4 _ 48: 8B. 4C C5, 90
        mov     eax, dword [rbp-80H]                    ; 01E9 _ 8B. 45, 80
        cdqe                                            ; 01EC _ 48: 98
        lea     rdx, [rax*4]                            ; 01EE _ 48: 8D. 14 85, 00000000
        mov     rax, qword [rbp-88H]                    ; 01F6 _ 48: 8B. 85, FFFFFF78
        add     rax, rdx                                ; 01FD _ 48: 01. D0
        mov     edx, ecx                                ; 0200 _ 89. CA
        mov     dword [rax], edx                        ; 0202 _ 89. 10
        add     dword [rbp-80H], 1                      ; 0204 _ 83. 45, 80, 01
?_012:  cmp     dword [rbp-80H], 5                      ; 0208 _ 83. 7D, 80, 05
        jle     ?_011                                   ; 020C _ 7E, D1
        mov     eax, 0                                  ; 020E _ B8, 00000000
        jmp     ?_016                                   ; 0213 _ EB, 5C

?_013:  mov     dword [rbp-80H], 0                      ; 0215 _ C7. 45, 80, 00000000
        jmp     ?_015                                   ; 021C _ EB, 48

?_014:  mov     eax, dword [rbp-80H]                    ; 021E _ 8B. 45, 80
        cdqe                                            ; 0221 _ 48: 98
        mov     rax, qword [rbp+rax*8-70H]              ; 0223 _ 48: 8B. 44 C5, 90
        lea     ecx, [rax+rax]                          ; 0228 _ 8D. 0C 00
        mov     eax, dword [rbp-80H]                    ; 022B _ 8B. 45, 80
        add     eax, 1                                  ; 022E _ 83. C0, 01
        cdqe                                            ; 0231 _ 48: 98
        mov     rax, qword [rbp+rax*8-70H]              ; 0233 _ 48: 8B. 44 C5, 90
        and     eax, 80000000H                          ; 0238 _ 25, 80000000
        shr     rax, 31                                 ; 023D _ 48: C1. E8, 1F
        and     eax, 01H                                ; 0241 _ 83. E0, 01
        movzx   edx, al                                 ; 0244 _ 0F B6. D0
        mov     eax, dword [rbp-80H]                    ; 0247 _ 8B. 45, 80
        cdqe                                            ; 024A _ 48: 98
        lea     rsi, [rax*4]                            ; 024C _ 48: 8D. 34 85, 00000000
        mov     rax, qword [rbp-88H]                    ; 0254 _ 48: 8B. 85, FFFFFF78
        add     rax, rsi                                ; 025B _ 48: 01. F0
        add     edx, ecx                                ; 025E _ 01. CA
        mov     dword [rax], edx                        ; 0260 _ 89. 10
        add     dword [rbp-80H], 1                      ; 0262 _ 83. 45, 80, 01
?_015:  cmp     dword [rbp-80H], 5                      ; 0266 _ 83. 7D, 80, 05
        jle     ?_014                                   ; 026A _ 7E, B2
        mov     eax, 4294967295                         ; 026C _ B8, FFFFFFFF
?_016:  mov     rdx, qword [rbp-8H]                     ; 0271 _ 48: 8B. 55, F8
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        sub     rdx, qword [fs:abs 28H]                 ; 0275 _ 64 48: 2B. 14 25, 00000028
        jz      ?_017                                   ; 027E _ 74, 05
        call    __stack_chk_fail                        ; 0280 _ E8, 00000000(PLT r)
?_017:  leave                                           ; 0285 _ C9
        ret                                             ; 0286 _ C3

read_exponent:; Local function
        push    rbp                                     ; 0287 _ 55
        mov     rbp, rsp                                ; 0288 _ 48: 89. E5
        sub     rsp, 32                                 ; 028B _ 48: 83. EC, 20
        mov     qword [rbp-18H], rdi                    ; 028F _ 48: 89. 7D, E8
        mov     dword [rbp-1CH], esi                    ; 0293 _ 89. 75, E4
        mov     dword [rbp-4H], 0                       ; 0296 _ C7. 45, FC, 00000000
        mov     byte [rbp-5H], 0                        ; 029D _ C6. 45, FB, 00
        mov     rax, qword [rbp-18H]                    ; 02A1 _ 48: 8B. 45, E8
        movzx   eax, byte [rax]                         ; 02A5 _ 0F B6. 00
        cmp     al, 43                                  ; 02A8 _ 3C, 2B
        jnz     ?_018                                   ; 02AA _ 75, 0A
        add     qword [rbp-18H], 1                      ; 02AC _ 48: 83. 45, E8, 01
        jmp     ?_022                                   ; 02B1 _ E9, 000000A1

?_018:  mov     rax, qword [rbp-18H]                    ; 02B6 _ 48: 8B. 45, E8
        movzx   eax, byte [rax]                         ; 02BA _ 0F B6. 00
        cmp     al, 45                                  ; 02BD _ 3C, 2D
        jne     ?_022                                   ; 02BF _ 0F 85, 00000092
        mov     byte [rbp-5H], 1                        ; 02C5 _ C6. 45, FB, 01
        add     qword [rbp-18H], 1                      ; 02C9 _ 48: 83. 45, E8, 01
        jmp     ?_022                                   ; 02CE _ E9, 00000084

?_019:  mov     rax, qword [rbp-18H]                    ; 02D3 _ 48: 8B. 45, E8
        movzx   eax, byte [rax]                         ; 02D7 _ 0F B6. 00
        cmp     al, 47                                  ; 02DA _ 3C, 2F
        jle     ?_020                                   ; 02DC _ 7E, 3B
        mov     rax, qword [rbp-18H]                    ; 02DE _ 48: 8B. 45, E8
        movzx   eax, byte [rax]                         ; 02E2 _ 0F B6. 00
        cmp     al, 57                                  ; 02E5 _ 3C, 39
        jg      ?_020                                   ; 02E7 _ 7F, 30
        mov     edx, dword [rbp-4H]                     ; 02E9 _ 8B. 55, FC
        mov     eax, edx                                ; 02EC _ 89. D0
        shl     eax, 2                                  ; 02EE _ C1. E0, 02
        add     eax, edx                                ; 02F1 _ 01. D0
        add     eax, eax                                ; 02F3 _ 01. C0
        mov     edx, eax                                ; 02F5 _ 89. C2
        mov     rax, qword [rbp-18H]                    ; 02F7 _ 48: 8B. 45, E8
        movzx   eax, byte [rax]                         ; 02FB _ 0F B6. 00
        movsx   eax, al                                 ; 02FE _ 0F BE. C0
        sub     eax, 48                                 ; 0301 _ 83. E8, 30
        add     eax, edx                                ; 0304 _ 01. D0
        mov     dword [rbp-4H], eax                     ; 0306 _ 89. 45, FC
        mov     eax, dword [rbp-4H]                     ; 0309 _ 8B. 45, FC
        cmp     eax, dword [rbp-1CH]                    ; 030C _ 3B. 45, E4
        jle     ?_021                                   ; 030F _ 7E, 41
        mov     eax, dword [rbp-1CH]                    ; 0311 _ 8B. 45, E4
        mov     dword [rbp-4H], eax                     ; 0314 _ 89. 45, FC
        jmp     ?_021                                   ; 0317 _ EB, 39

?_020:  mov     rax, qword [rbp-18H]                    ; 0319 _ 48: 8B. 45, E8
        movzx   eax, byte [rax]                         ; 031D _ 0F B6. 00
        cmp     al, 95                                  ; 0320 _ 3C, 5F
        jz      ?_021                                   ; 0322 _ 74, 2E
        mov     rax, qword [rbp-18H]                    ; 0324 _ 48: 8B. 45, E8
        movzx   eax, byte [rax]                         ; 0328 _ 0F B6. 00
        movsx   eax, al                                 ; 032B _ 0F BE. C0
        lea     rsi, [rel ?_204]                        ; 032E _ 48: 8D. 35, 00000000(rel)
        lea     rcx, [rel ?_205]                        ; 0335 _ 48: 8D. 0D, 00000000(rel)
        mov     edx, eax                                ; 033C _ 89. C2
        mov     rdi, rcx                                ; 033E _ 48: 89. CF
        mov     eax, 0                                  ; 0341 _ B8, 00000000
        call    nasm_nonfatal                           ; 0346 _ E8, 00000000(PLT r)
        mov     eax, 2147483647                         ; 034B _ B8, 7FFFFFFF
        jmp     ?_024                                   ; 0350 _ EB, 24

?_021:  add     qword [rbp-18H], 1                      ; 0352 _ 48: 83. 45, E8, 01
?_022:  mov     rax, qword [rbp-18H]                    ; 0357 _ 48: 8B. 45, E8
        movzx   eax, byte [rax]                         ; 035B _ 0F B6. 00
        test    al, al                                  ; 035E _ 84. C0
        jne     ?_019                                   ; 0360 _ 0F 85, FFFFFF6D
        cmp     byte [rbp-5H], 0                        ; 0366 _ 80. 7D, FB, 00
        jz      ?_023                                   ; 036A _ 74, 07
        mov     eax, dword [rbp-4H]                     ; 036C _ 8B. 45, FC
        neg     eax                                     ; 036F _ F7. D8
        jmp     ?_024                                   ; 0371 _ EB, 03

?_023:  mov     eax, dword [rbp-4H]                     ; 0373 _ 8B. 45, FC
?_024:  leave                                           ; 0376 _ C9
        ret                                             ; 0377 _ C3

ieee_flconvert:; Local function
        push    rbp                                     ; 0378 _ 55
        mov     rbp, rsp                                ; 0379 _ 48: 89. E5
        push    rbx                                     ; 037C _ 53
        sub     rsp, 216                                ; 037D _ 48: 81. EC, 000000D8
        mov     qword [rbp-0C8H], rdi                   ; 0384 _ 48: 89. BD, FFFFFF38
        mov     qword [rbp-0D0H], rsi                   ; 038B _ 48: 89. B5, FFFFFF30
        mov     qword [rbp-0D8H], rdx                   ; 0392 _ 48: 89. 95, FFFFFF28
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        mov     rax, qword [fs:abs 28H]                 ; 0399 _ 64 48: 8B. 04 25, 00000028
        mov     qword [rbp-18H], rax                    ; 03A2 _ 48: 89. 45, E8
        xor     eax, eax                                ; 03A6 _ 31. C0
        mov     byte [rbp-0B1H], 0                      ; 03A8 _ C6. 85, FFFFFF4F, 00
        lea     rax, [rbp-50H]                          ; 03AF _ 48: 8D. 45, B0
        mov     qword [rbp-90H], rax                    ; 03B3 _ 48: 89. 85, FFFFFF70
        mov     dword [rbp-0ACH], 0                     ; 03BA _ C7. 85, FFFFFF54, 00000000
        mov     byte [rbp-0B2H], 0                      ; 03C4 _ C6. 85, FFFFFF4E, 00
        movzx   eax, byte [rbp-0B2H]                    ; 03CB _ 0F B6. 85, FFFFFF4E
        mov     byte [rbp-0B3H], al                     ; 03D2 _ 88. 85, FFFFFF4D
        jmp     ?_036                                   ; 03D8 _ E9, 00000197

?_025:  mov     rax, qword [rbp-0C8H]                   ; 03DD _ 48: 8B. 85, FFFFFF38
        movzx   eax, byte [rax]                         ; 03E4 _ 0F B6. 00
        cmp     al, 46                                  ; 03E7 _ 3C, 2E
        jnz     ?_027                                   ; 03E9 _ 75, 38
        movzx   eax, byte [rbp-0B2H]                    ; 03EB _ 0F B6. 85, FFFFFF4E
        xor     eax, 01H                                ; 03F2 _ 83. F0, 01
        test    al, al                                  ; 03F5 _ 84. C0
        jz      ?_026                                   ; 03F7 _ 74, 0C
        mov     byte [rbp-0B2H], 1                      ; 03F9 _ C6. 85, FFFFFF4E, 01
        jmp     ?_035                                   ; 0400 _ E9, 00000167

?_026:  lea     rax, [rel ?_206]                        ; 0405 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 040C _ 48: 89. C7
        mov     eax, 0                                  ; 040F _ B8, 00000000
        call    nasm_nonfatal                           ; 0414 _ E8, 00000000(PLT r)
        mov     eax, 0                                  ; 0419 _ B8, 00000000
        jmp     ?_067                                   ; 041E _ E9, 000004B0

?_027:  mov     rax, qword [rbp-0C8H]                   ; 0423 _ 48: 8B. 85, FFFFFF38
        movzx   eax, byte [rax]                         ; 042A _ 0F B6. 00
        cmp     al, 47                                  ; 042D _ 3C, 2F
        jle     ?_033                                   ; 042F _ 0F 8E, 000000F2
        mov     rax, qword [rbp-0C8H]                   ; 0435 _ 48: 8B. 85, FFFFFF38
        movzx   eax, byte [rax]                         ; 043C _ 0F B6. 00
        cmp     al, 57                                  ; 043F _ 3C, 39
        jg      ?_033                                   ; 0441 _ 0F 8F, 000000E0
        mov     rax, qword [rbp-0C8H]                   ; 0447 _ 48: 8B. 85, FFFFFF38
        movzx   eax, byte [rax]                         ; 044E _ 0F B6. 00
        cmp     al, 48                                  ; 0451 _ 3C, 30
        jnz     ?_028                                   ; 0453 _ 75, 27
        movzx   eax, byte [rbp-0B3H]                    ; 0455 _ 0F B6. 85, FFFFFF4D
        xor     eax, 01H                                ; 045C _ 83. F0, 01
        test    al, al                                  ; 045F _ 84. C0
        jz      ?_028                                   ; 0461 _ 74, 19
        cmp     byte [rbp-0B2H], 0                      ; 0463 _ 80. BD, FFFFFF4E, 00
        je      ?_032                                   ; 046A _ 0F 84, 000000B5
        sub     dword [rbp-0ACH], 1                     ; 0470 _ 83. AD, FFFFFF54, 01
        jmp     ?_032                                   ; 0477 _ E9, 000000A9

?_028:  mov     byte [rbp-0B3H], 1                      ; 047C _ C6. 85, FFFFFF4D, 01
        lea     rax, [rbp-50H]                          ; 0483 _ 48: 8D. 45, B0
        add     rax, 52                                 ; 0487 _ 48: 83. C0, 34
        cmp     qword [rbp-90H], rax                    ; 048B _ 48: 39. 85, FFFFFF70
        jnc     ?_029                                   ; 0492 _ 73, 25
        mov     rax, qword [rbp-0C8H]                   ; 0494 _ 48: 8B. 85, FFFFFF38
        movzx   eax, byte [rax]                         ; 049B _ 0F B6. 00
        lea     ecx, [rax-30H]                          ; 049E _ 8D. 48, D0
        mov     rax, qword [rbp-90H]                    ; 04A1 _ 48: 8B. 85, FFFFFF70
        lea     rdx, [rax+1H]                           ; 04A8 _ 48: 8D. 50, 01
        mov     qword [rbp-90H], rdx                    ; 04AC _ 48: 89. 95, FFFFFF70
        mov     edx, ecx                                ; 04B3 _ 89. CA
        mov     byte [rax], dl                          ; 04B5 _ 88. 10
        jmp     ?_031                                   ; 04B7 _ EB, 55

?_029:  movzx   eax, byte [rbp-0B1H]                    ; 04B9 _ 0F B6. 85, FFFFFF4F
        xor     eax, 01H                                ; 04C0 _ 83. F0, 01
        test    al, al                                  ; 04C3 _ 84. C0
        jz      ?_031                                   ; 04C5 _ 74, 47
        mov     dword [rbp-98H], 459008                 ; 04C7 _ C7. 85, FFFFFF68, 00070100
        mov     eax, dword [rbp-98H]                    ; 04D1 _ 8B. 85, FFFFFF68
        mov     edi, eax                                ; 04D7 _ 89. C7
        call    warn_active                             ; 04D9 _ E8, FFFFFB53
        movzx   eax, al                                 ; 04DE _ 0F B6. C0
        test    rax, rax                                ; 04E1 _ 48: 85. C0
        jz      ?_030                                   ; 04E4 _ 74, 21
        lea     rcx, [rel ?_207]                        ; 04E6 _ 48: 8D. 0D, 00000000(rel)
        mov     eax, dword [rbp-98H]                    ; 04ED _ 8B. 85, FFFFFF68
        mov     edx, 52                                 ; 04F3 _ BA, 00000034
        mov     rsi, rcx                                ; 04F8 _ 48: 89. CE
        mov     edi, eax                                ; 04FB _ 89. C7
        mov     eax, 0                                  ; 04FD _ B8, 00000000
        call    nasm_warn_                              ; 0502 _ E8, 00000000(PLT r)
?_030:  mov     byte [rbp-0B1H], 1                      ; 0507 _ C6. 85, FFFFFF4F, 01
?_031:  movzx   eax, byte [rbp-0B2H]                    ; 050E _ 0F B6. 85, FFFFFF4E
        xor     eax, 01H                                ; 0515 _ 83. F0, 01
        test    al, al                                  ; 0518 _ 84. C0
        jz      ?_034                                   ; 051A _ 74, 4F
        add     dword [rbp-0ACH], 1                     ; 051C _ 83. 85, FFFFFF54, 01
        jmp     ?_034                                   ; 0523 _ EB, 46

?_032:  jmp     ?_034                                   ; 0525 _ EB, 44

?_033:  mov     rax, qword [rbp-0C8H]                   ; 0527 _ 48: 8B. 85, FFFFFF38
        movzx   eax, byte [rax]                         ; 052E _ 0F B6. 00
        cmp     al, 95                                  ; 0531 _ 3C, 5F
        jz      ?_035                                   ; 0533 _ 74, 37
        mov     rax, qword [rbp-0C8H]                   ; 0535 _ 48: 8B. 85, FFFFFF38
        movzx   eax, byte [rax]                         ; 053C _ 0F B6. 00
        movsx   eax, al                                 ; 053F _ 0F BE. C0
        lea     rdx, [rel ?_208]                        ; 0542 _ 48: 8D. 15, 00000000(rel)
        lea     rsi, [rel ?_205]                        ; 0549 _ 48: 8D. 35, 00000000(rel)
        mov     ecx, eax                                ; 0550 _ 89. C1
        mov     edi, 256                                ; 0552 _ BF, 00000100
        mov     eax, 0                                  ; 0557 _ B8, 00000000
        call    nasm_nonfatalf                          ; 055C _ E8, 00000000(PLT r)
        mov     eax, 0                                  ; 0561 _ B8, 00000000
        jmp     ?_067                                   ; 0566 _ E9, 00000368

?_034:  nop                                             ; 056B _ 90
?_035:  add     qword [rbp-0C8H], 1                     ; 056C _ 48: 83. 85, FFFFFF38, 01
?_036:  mov     rax, qword [rbp-0C8H]                   ; 0574 _ 48: 8B. 85, FFFFFF38
        movzx   eax, byte [rax]                         ; 057B _ 0F B6. 00
        test    al, al                                  ; 057E _ 84. C0
        jz      ?_037                                   ; 0580 _ 74, 20
        mov     rax, qword [rbp-0C8H]                   ; 0582 _ 48: 8B. 85, FFFFFF38
        movzx   eax, byte [rax]                         ; 0589 _ 0F B6. 00
        cmp     al, 69                                  ; 058C _ 3C, 45
        jz      ?_037                                   ; 058E _ 74, 12
        mov     rax, qword [rbp-0C8H]                   ; 0590 _ 48: 8B. 85, FFFFFF38
        movzx   eax, byte [rax]                         ; 0597 _ 0F B6. 00
        cmp     al, 101                                 ; 059A _ 3C, 65
        jne     ?_025                                   ; 059C _ 0F 85, FFFFFE3B
?_037:  mov     rax, qword [rbp-0C8H]                   ; 05A2 _ 48: 8B. 85, FFFFFF38
        movzx   eax, byte [rax]                         ; 05A9 _ 0F B6. 00
        test    al, al                                  ; 05AC _ 84. C0
        jz      ?_039                                   ; 05AE _ 74, 44
        add     qword [rbp-0C8H], 1                     ; 05B0 _ 48: 83. 85, FFFFFF38, 01
        mov     rax, qword [rbp-0C8H]                   ; 05B8 _ 48: 8B. 85, FFFFFF38
        mov     esi, 5000                               ; 05BF _ BE, 00001388
        mov     rdi, rax                                ; 05C4 _ 48: 89. C7
        call    read_exponent                           ; 05C7 _ E8, FFFFFCBB
        mov     dword [rbp-94H], eax                    ; 05CC _ 89. 85, FFFFFF6C
        cmp     dword [rbp-94H], 2147483647             ; 05D2 _ 81. BD, FFFFFF6C, 7FFFFFFF
        jnz     ?_038                                   ; 05DC _ 75, 0A
        mov     eax, 0                                  ; 05DE _ B8, 00000000
        jmp     ?_067                                   ; 05E3 _ E9, 000002EB

?_038:  mov     eax, dword [rbp-94H]                    ; 05E8 _ 8B. 85, FFFFFF6C
        add     dword [rbp-0ACH], eax                   ; 05EE _ 01. 85, FFFFFF54
?_039:  lea     rax, [rbp-50H]                          ; 05F4 _ 48: 8D. 45, B0
        mov     qword [rbp-88H], rax                    ; 05F8 _ 48: 89. 85, FFFFFF78
        jmp     ?_041                                   ; 05FF _ EB, 08

?_040:  add     qword [rbp-88H], 1                      ; 0601 _ 48: 83. 85, FFFFFF78, 01
?_041:  mov     rax, qword [rbp-88H]                    ; 0609 _ 48: 8B. 85, FFFFFF78
        cmp     rax, qword [rbp-90H]                    ; 0610 _ 48: 3B. 85, FFFFFF70
        jc      ?_040                                   ; 0617 _ 72, E8
        mov     dword [rbp-0B0H], -2147483648           ; 0619 _ C7. 85, FFFFFF50, 80000000
        mov     rax, qword [rbp-0D0H]                   ; 0623 _ 48: 8B. 85, FFFFFF30
        mov     qword [rbp-78H], rax                    ; 062A _ 48: 89. 45, 88
        jmp     ?_043                                   ; 062E _ EB, 0F

?_042:  mov     rax, qword [rbp-78H]                    ; 0630 _ 48: 8B. 45, 88
        mov     dword [rax], 0                          ; 0634 _ C7. 00, 00000000
        add     qword [rbp-78H], 4                      ; 063A _ 48: 83. 45, 88, 04
?_043:  mov     rax, qword [rbp-0D0H]                   ; 063F _ 48: 8B. 85, FFFFFF30
        add     rax, 24                                 ; 0646 _ 48: 83. C0, 18
        cmp     qword [rbp-78H], rax                    ; 064A _ 48: 39. 45, 88
        jc      ?_042                                   ; 064E _ 72, E0
        mov     rax, qword [rbp-0D0H]                   ; 0650 _ 48: 8B. 85, FFFFFF30
        mov     qword [rbp-78H], rax                    ; 0657 _ 48: 89. 45, 88
        lea     rax, [rbp-50H]                          ; 065B _ 48: 8D. 45, B0
        mov     qword [rbp-88H], rax                    ; 065F _ 48: 89. 85, FFFFFF78
        mov     byte [rbp-0B3H], 0                      ; 0666 _ C6. 85, FFFFFF4D, 00
        mov     dword [rbp-0A8H], 0                     ; 066D _ C7. 85, FFFFFF58, 00000000
        jmp     ?_055                                   ; 0677 _ E9, 00000112

?_044:  mov     dword [rbp-0A0H], 0                     ; 067C _ C7. 85, FFFFFF60, 00000000
        jmp     ?_046                                   ; 0686 _ EB, 08

?_045:  sub     qword [rbp-90H], 1                      ; 0688 _ 48: 83. AD, FFFFFF70, 01
?_046:  mov     rax, qword [rbp-90H]                    ; 0690 _ 48: 8B. 85, FFFFFF70
        cmp     qword [rbp-88H], rax                    ; 0697 _ 48: 39. 85, FFFFFF78
        jnc     ?_047                                   ; 069E _ 73, 12
        mov     rax, qword [rbp-90H]                    ; 06A0 _ 48: 8B. 85, FFFFFF70
        sub     rax, 1                                  ; 06A7 _ 48: 83. E8, 01
        movzx   eax, byte [rax]                         ; 06AB _ 0F B6. 00
        test    al, al                                  ; 06AE _ 84. C0
        jz      ?_045                                   ; 06B0 _ 74, D6
?_047:  mov     rax, qword [rbp-90H]                    ; 06B2 _ 48: 8B. 85, FFFFFF70
        cmp     qword [rbp-88H], rax                    ; 06B9 _ 48: 39. 85, FFFFFF78
        jnc     ?_056                                   ; 06C0 _ 0F 83, 000000DF
        mov     rax, qword [rbp-90H]                    ; 06C6 _ 48: 8B. 85, FFFFFF70
        mov     qword [rbp-80H], rax                    ; 06CD _ 48: 89. 45, 80
        jmp     ?_051                                   ; 06D1 _ EB, 50

?_048:  mov     rax, qword [rbp-80H]                    ; 06D3 _ 48: 8B. 45, 80
        movzx   eax, byte [rax]                         ; 06D7 _ 0F B6. 00
        movsx   eax, al                                 ; 06DA _ 0F BE. C0
        add     eax, eax                                ; 06DD _ 01. C0
        mov     edx, eax                                ; 06DF _ 89. C2
        mov     eax, dword [rbp-0A0H]                   ; 06E1 _ 8B. 85, FFFFFF60
        add     eax, edx                                ; 06E7 _ 01. D0
        mov     dword [rbp-9CH], eax                    ; 06E9 _ 89. 85, FFFFFF64
        cmp     dword [rbp-9CH], 9                      ; 06EF _ 83. BD, FFFFFF64, 09
        jle     ?_049                                   ; 06F6 _ 7E, 13
        mov     dword [rbp-0A0H], 1                     ; 06F8 _ C7. 85, FFFFFF60, 00000001
        sub     dword [rbp-9CH], 10                     ; 0702 _ 83. AD, FFFFFF64, 0A
        jmp     ?_050                                   ; 0709 _ EB, 0A

?_049:  mov     dword [rbp-0A0H], 0                     ; 070B _ C7. 85, FFFFFF60, 00000000
?_050:  mov     eax, dword [rbp-9CH]                    ; 0715 _ 8B. 85, FFFFFF64
        mov     edx, eax                                ; 071B _ 89. C2
        mov     rax, qword [rbp-80H]                    ; 071D _ 48: 8B. 45, 80
        mov     byte [rax], dl                          ; 0721 _ 88. 10
?_051:  mov     rax, qword [rbp-80H]                    ; 0723 _ 48: 8B. 45, 80
        lea     rdx, [rax-1H]                           ; 0727 _ 48: 8D. 50, FF
        mov     qword [rbp-80H], rdx                    ; 072B _ 48: 89. 55, 80
        cmp     qword [rbp-88H], rax                    ; 072F _ 48: 39. 85, FFFFFF78
        jc      ?_048                                   ; 0736 _ 72, 9B
        cmp     dword [rbp-0A0H], 0                     ; 0738 _ 83. BD, FFFFFF60, 00
        jz      ?_052                                   ; 073F _ 74, 1B
        mov     rax, qword [rbp-78H]                    ; 0741 _ 48: 8B. 45, 88
        mov     eax, dword [rax]                        ; 0745 _ 8B. 00
        or      eax, dword [rbp-0B0H]                   ; 0747 _ 0B. 85, FFFFFF50
        mov     edx, eax                                ; 074D _ 89. C2
        mov     rax, qword [rbp-78H]                    ; 074F _ 48: 8B. 45, 88
        mov     dword [rax], edx                        ; 0753 _ 89. 10
        mov     byte [rbp-0B3H], 1                      ; 0755 _ C6. 85, FFFFFF4D, 01
?_052:  cmp     byte [rbp-0B3H], 0                      ; 075C _ 80. BD, FFFFFF4D, 00
        jz      ?_054                                   ; 0763 _ 74, 22
        cmp     dword [rbp-0B0H], 1                     ; 0765 _ 83. BD, FFFFFF50, 01
        jnz     ?_053                                   ; 076C _ 75, 11
        mov     dword [rbp-0B0H], -2147483648           ; 076E _ C7. 85, FFFFFF50, 80000000
        add     qword [rbp-78H], 4                      ; 0778 _ 48: 83. 45, 88, 04
        jmp     ?_055                                   ; 077D _ EB, 0F

?_053:  shr     dword [rbp-0B0H], 1                     ; 077F _ D1. AD, FFFFFF50
        jmp     ?_055                                   ; 0785 _ EB, 07

?_054:  sub     dword [rbp-0A8H], 1                     ; 0787 _ 83. AD, FFFFFF58, 01
?_055:  mov     rax, qword [rbp-0D0H]                   ; 078E _ 48: 8B. 85, FFFFFF30
        add     rax, 24                                 ; 0795 _ 48: 83. C0, 18
        cmp     qword [rbp-78H], rax                    ; 0799 _ 48: 39. 45, 88
        jc      ?_044                                   ; 079D _ 0F 82, FFFFFED9
        jmp     ?_057                                   ; 07A3 _ EB, 01

?_056:  nop                                             ; 07A5 _ 90
?_057:  mov     eax, dword [rbp-0ACH]                   ; 07A6 _ 8B. 85, FFFFFF54
        add     dword [rbp-0A8H], eax                   ; 07AC _ 01. 85, FFFFFF58
        cmp     dword [rbp-0ACH], 0                     ; 07B2 _ 83. BD, FFFFFF54, 00
        jns     ?_060                                   ; 07B9 _ 79, 43
        lea     rax, [rbp-70H]                          ; 07BB _ 48: 8D. 45, 90
        mov     qword [rbp-78H], rax                    ; 07BF _ 48: 89. 45, 88
        jmp     ?_059                                   ; 07C3 _ EB, 0F

?_058:  mov     rax, qword [rbp-78H]                    ; 07C5 _ 48: 8B. 45, 88
        mov     dword [rax], -858993460                 ; 07C9 _ C7. 00, CCCCCCCC
        add     qword [rbp-78H], 4                      ; 07CF _ 48: 83. 45, 88, 04
?_059:  lea     rax, [rbp-70H]                          ; 07D4 _ 48: 8D. 45, 90
        add     rax, 20                                 ; 07D8 _ 48: 83. C0, 14
        cmp     qword [rbp-78H], rax                    ; 07DC _ 48: 39. 45, 88
        jc      ?_058                                   ; 07E0 _ 72, E3
        mov     dword [rbp-5CH], -858993459             ; 07E2 _ C7. 45, A4, CCCCCCCD
        mov     dword [rbp-0A4H], -2                    ; 07E9 _ C7. 85, FFFFFF5C, FFFFFFFE
        neg     dword [rbp-0ACH]                        ; 07F3 _ F7. 9D, FFFFFF54
        jmp     ?_066                                   ; 07F9 _ E9, 000000B8

?_060:  cmp     dword [rbp-0ACH], 0                     ; 07FE _ 83. BD, FFFFFF54, 00
        jle     ?_063                                   ; 0805 _ 7E, 3E
        mov     dword [rbp-70H], -1610612736            ; 0807 _ C7. 45, 90, A0000000
        lea     rax, [rbp-70H]                          ; 080E _ 48: 8D. 45, 90
        add     rax, 4                                  ; 0812 _ 48: 83. C0, 04
        mov     qword [rbp-78H], rax                    ; 0816 _ 48: 89. 45, 88
        jmp     ?_062                                   ; 081A _ EB, 0F

?_061:  mov     rax, qword [rbp-78H]                    ; 081C _ 48: 8B. 45, 88
        mov     dword [rax], 0                          ; 0820 _ C7. 00, 00000000
        add     qword [rbp-78H], 4                      ; 0826 _ 48: 83. 45, 88, 04
?_062:  lea     rax, [rbp-70H]                          ; 082B _ 48: 8D. 45, 90
        add     rax, 24                                 ; 082F _ 48: 83. C0, 18
        cmp     qword [rbp-78H], rax                    ; 0833 _ 48: 39. 45, 88
        jc      ?_061                                   ; 0837 _ 72, E3
        mov     dword [rbp-0A4H], 3                     ; 0839 _ C7. 85, FFFFFF5C, 00000003
        jmp     ?_066                                   ; 0843 _ EB, 71

?_063:  mov     dword [rbp-0A4H], 0                     ; 0845 _ C7. 85, FFFFFF5C, 00000000
        jmp     ?_066                                   ; 084F _ EB, 65

?_064:  mov     eax, dword [rbp-0ACH]                   ; 0851 _ 8B. 85, FFFFFF54
        and     eax, 01H                                ; 0857 _ 83. E0, 01
        test    eax, eax                                ; 085A _ 85. C0
        jz      ?_065                                   ; 085C _ 74, 24
        lea     rdx, [rbp-70H]                          ; 085E _ 48: 8D. 55, 90
        mov     rax, qword [rbp-0D0H]                   ; 0862 _ 48: 8B. 85, FFFFFF30
        mov     rsi, rdx                                ; 0869 _ 48: 89. D6
        mov     rdi, rax                                ; 086C _ 48: 89. C7
        call    float_multiply                          ; 086F _ E8, FFFFF7F0
        mov     edx, dword [rbp-0A4H]                   ; 0874 _ 8B. 95, FFFFFF5C
        add     eax, edx                                ; 087A _ 01. D0
        add     dword [rbp-0A8H], eax                   ; 087C _ 01. 85, FFFFFF58
?_065:  mov     eax, dword [rbp-0A4H]                   ; 0882 _ 8B. 85, FFFFFF5C
        lea     ebx, [rax+rax]                          ; 0888 _ 8D. 1C 00
        lea     rdx, [rbp-70H]                          ; 088B _ 48: 8D. 55, 90
        lea     rax, [rbp-70H]                          ; 088F _ 48: 8D. 45, 90
        mov     rsi, rdx                                ; 0893 _ 48: 89. D6
        mov     rdi, rax                                ; 0896 _ 48: 89. C7
        call    float_multiply                          ; 0899 _ E8, FFFFF7C6
        add     eax, ebx                                ; 089E _ 01. D8
        mov     dword [rbp-0A4H], eax                   ; 08A0 _ 89. 85, FFFFFF5C
        sar     dword [rbp-0ACH], 1                     ; 08A6 _ D1. BD, FFFFFF54
        and     dword [rbp-0ACH], 7FFFFFFFH             ; 08AC _ 81. A5, FFFFFF54, 7FFFFFFF
?_066:  cmp     dword [rbp-0ACH], 0                     ; 08B6 _ 83. BD, FFFFFF54, 00
        jnz     ?_064                                   ; 08BD _ 75, 92
        mov     rax, qword [rbp-0D8H]                   ; 08BF _ 48: 8B. 85, FFFFFF28
        mov     edx, dword [rbp-0A8H]                   ; 08C6 _ 8B. 95, FFFFFF58
        mov     dword [rax], edx                        ; 08CC _ 89. 10
        mov     eax, 1                                  ; 08CE _ B8, 00000001
?_067:  mov     rdx, qword [rbp-18H]                    ; 08D3 _ 48: 8B. 55, E8
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        sub     rdx, qword [fs:abs 28H]                 ; 08D7 _ 64 48: 2B. 14 25, 00000028
        jz      ?_068                                   ; 08E0 _ 74, 05
        call    __stack_chk_fail                        ; 08E2 _ E8, 00000000(PLT r)
?_068:  mov     rbx, qword [rbp-8H]                     ; 08E7 _ 48: 8B. 5D, F8
        leave                                           ; 08EB _ C9
        ret                                             ; 08EC _ C3

set_bit:; Local function
        push    rbp                                     ; 08ED _ 55
        mov     rbp, rsp                                ; 08EE _ 48: 89. E5
        mov     qword [rbp-8H], rdi                     ; 08F1 _ 48: 89. 7D, F8
        mov     qword [rbp-10H], rsi                    ; 08F5 _ 48: 89. 75, F0
        mov     rax, qword [rbp-10H]                    ; 08F9 _ 48: 8B. 45, F0
        shr     rax, 5                                  ; 08FD _ 48: C1. E8, 05
        lea     rcx, [rax*4]                            ; 0901 _ 48: 8D. 0C 85, 00000000
        mov     rdx, qword [rbp-8H]                     ; 0909 _ 48: 8B. 55, F8
        add     rdx, rcx                                ; 090D _ 48: 01. CA
        mov     edx, dword [rdx]                        ; 0910 _ 8B. 12
        mov     rcx, qword [rbp-10H]                    ; 0912 _ 48: 8B. 4D, F0
        not     ecx                                     ; 0916 _ F7. D1
        and     ecx, 1FH                                ; 0918 _ 83. E1, 1F
        mov     esi, 1                                  ; 091B _ BE, 00000001
        shl     esi, cl                                 ; 0920 _ D3. E6
        mov     ecx, esi                                ; 0922 _ 89. F1
        lea     rsi, [rax*4]                            ; 0924 _ 48: 8D. 34 85, 00000000
        mov     rax, qword [rbp-8H]                     ; 092C _ 48: 8B. 45, F8
        add     rax, rsi                                ; 0930 _ 48: 01. F0
        or      edx, ecx                                ; 0933 _ 09. CA
        mov     dword [rax], edx                        ; 0935 _ 89. 10
        nop                                             ; 0937 _ 90
        pop     rbp                                     ; 0938 _ 5D
        ret                                             ; 0939 _ C3

test_bit:; Local function
        push    rbp                                     ; 093A _ 55
        mov     rbp, rsp                                ; 093B _ 48: 89. E5
        mov     qword [rbp-8H], rdi                     ; 093E _ 48: 89. 7D, F8
        mov     qword [rbp-10H], rsi                    ; 0942 _ 48: 89. 75, F0
        mov     rax, qword [rbp-10H]                    ; 0946 _ 48: 8B. 45, F0
        shr     rax, 5                                  ; 094A _ 48: C1. E8, 05
        lea     rdx, [rax*4]                            ; 094E _ 48: 8D. 14 85, 00000000
        mov     rax, qword [rbp-8H]                     ; 0956 _ 48: 8B. 45, F8
        add     rax, rdx                                ; 095A _ 48: 01. D0
        mov     edx, dword [rax]                        ; 095D _ 8B. 10
        mov     rax, qword [rbp-10H]                    ; 095F _ 48: 8B. 45, F0
        not     eax                                     ; 0963 _ F7. D0
        and     eax, 1FH                                ; 0965 _ 83. E0, 1F
        mov     ecx, eax                                ; 0968 _ 89. C1
        shr     edx, cl                                 ; 096A _ D3. EA
        mov     eax, edx                                ; 096C _ 89. D0
        and     eax, 01H                                ; 096E _ 83. E0, 01
        pop     rbp                                     ; 0971 _ 5D
        ret                                             ; 0972 _ C3

is_zero:; Local function
        push    rbp                                     ; 0973 _ 55
        mov     rbp, rsp                                ; 0974 _ 48: 89. E5
        mov     qword [rbp-18H], rdi                    ; 0977 _ 48: 89. 7D, E8
        mov     dword [rbp-4H], 0                       ; 097B _ C7. 45, FC, 00000000
        jmp     ?_071                                   ; 0982 _ EB, 25

?_069:  mov     eax, dword [rbp-4H]                     ; 0984 _ 8B. 45, FC
        cdqe                                            ; 0987 _ 48: 98
        lea     rdx, [rax*4]                            ; 0989 _ 48: 8D. 14 85, 00000000
        mov     rax, qword [rbp-18H]                    ; 0991 _ 48: 8B. 45, E8
        add     rax, rdx                                ; 0995 _ 48: 01. D0
        mov     eax, dword [rax]                        ; 0998 _ 8B. 00
        test    eax, eax                                ; 099A _ 85. C0
        jz      ?_070                                   ; 099C _ 74, 07
        mov     eax, 0                                  ; 099E _ B8, 00000000
        jmp     ?_072                                   ; 09A3 _ EB, 0F

?_070:  add     dword [rbp-4H], 1                       ; 09A5 _ 83. 45, FC, 01
?_071:  cmp     dword [rbp-4H], 5                       ; 09A9 _ 83. 7D, FC, 05
        jle     ?_069                                   ; 09AD _ 7E, D5
        mov     eax, 1                                  ; 09AF _ B8, 00000001
?_072:  pop     rbp                                     ; 09B4 _ 5D
        ret                                             ; 09B5 _ C3

ieee_round:; Local function
        push    rbp                                     ; 09B6 _ 55
        mov     rbp, rsp                                ; 09B7 _ 48: 89. E5
        sub     rsp, 48                                 ; 09BA _ 48: 83. EC, 30
        mov     byte [rbp-21H], dil                     ; 09BE _ 40: 88. 7D, DF
        mov     qword [rbp-30H], rsi                    ; 09C2 _ 48: 89. 75, D0
        mov     dword [rbp-28H], edx                    ; 09C6 _ 89. 55, D8
        mov     dword [rbp-14H], 0                      ; 09C9 _ C7. 45, EC, 00000000
        mov     eax, dword [rbp-28H]                    ; 09D0 _ 8B. 45, D8
        lea     edx, [rax+1FH]                          ; 09D3 _ 8D. 50, 1F
        test    eax, eax                                ; 09D6 _ 85. C0
        cmovs   eax, edx                                ; 09D8 _ 0F 48. C2
        sar     eax, 5                                  ; 09DB _ C1. F8, 05
        mov     dword [rbp-0CH], eax                    ; 09DE _ 89. 45, F4
        mov     edx, dword [rbp-28H]                    ; 09E1 _ 8B. 55, D8
        mov     eax, edx                                ; 09E4 _ 89. D0
        sar     eax, 31                                 ; 09E6 _ C1. F8, 1F
        shr     eax, 27                                 ; 09E9 _ C1. E8, 1B
        add     edx, eax                                ; 09EC _ 01. C2
        and     edx, 1FH                                ; 09EE _ 83. E2, 1F
        sub     edx, eax                                ; 09F1 _ 29. C2
        mov     dword [rbp-8H], edx                     ; 09F3 _ 89. 55, F8
        mov     eax, dword [rbp-8H]                     ; 09F6 _ 8B. 45, F8
        mov     edx, 2147483648                         ; 09F9 _ BA, 80000000
        mov     ecx, eax                                ; 09FE _ 89. C1
        shr     edx, cl                                 ; 0A00 _ D3. EA
        mov     eax, edx                                ; 0A02 _ 89. D0
        mov     dword [rbp-4H], eax                     ; 0A04 _ 89. 45, FC
        mov     eax, dword [rel rc]                     ; 0A07 _ 8B. 05, 00000000(rel)
        test    eax, eax                                ; 0A0D _ 85. C0
        jne     ?_092                                   ; 0A0F _ 0F 85, 00000351
        mov     eax, dword [rbp-0CH]                    ; 0A15 _ 8B. 45, F4
        cdqe                                            ; 0A18 _ 48: 98
        lea     rdx, [rax*4]                            ; 0A1A _ 48: 8D. 14 85, 00000000
        mov     rax, qword [rbp-30H]                    ; 0A22 _ 48: 8B. 45, D0
        add     rax, rdx                                ; 0A26 _ 48: 01. D0
        mov     eax, dword [rax]                        ; 0A29 _ 8B. 00
        and     eax, dword [rbp-4H]                     ; 0A2B _ 23. 45, FC
        test    eax, eax                                ; 0A2E _ 85. C0
        je      ?_089                                   ; 0A30 _ 0F 84, 000002C2
        mov     eax, dword [rbp-0CH]                    ; 0A36 _ 8B. 45, F4
        cdqe                                            ; 0A39 _ 48: 98
        lea     rdx, [rax*4]                            ; 0A3B _ 48: 8D. 14 85, 00000000
        mov     rax, qword [rbp-30H]                    ; 0A43 _ 48: 8B. 45, D0
        add     rax, rdx                                ; 0A47 _ 48: 01. D0
        mov     edx, dword [rax]                        ; 0A4A _ 8B. 10
        mov     eax, dword [rbp-4H]                     ; 0A4C _ 8B. 45, FC
        not     eax                                     ; 0A4F _ F7. D0
        mov     ecx, eax                                ; 0A51 _ 89. C1
        mov     eax, dword [rbp-0CH]                    ; 0A53 _ 8B. 45, F4
        cdqe                                            ; 0A56 _ 48: 98
        lea     rsi, [rax*4]                            ; 0A58 _ 48: 8D. 34 85, 00000000
        mov     rax, qword [rbp-30H]                    ; 0A60 _ 48: 8B. 45, D0
        add     rax, rsi                                ; 0A64 _ 48: 01. F0
        and     edx, ecx                                ; 0A67 _ 21. CA
        mov     dword [rax], edx                        ; 0A69 _ 89. 10
        mov     eax, dword [rbp-0CH]                    ; 0A6B _ 8B. 45, F4
        cdqe                                            ; 0A6E _ 48: 98
        lea     rdx, [rax*4]                            ; 0A70 _ 48: 8D. 14 85, 00000000
        mov     rax, qword [rbp-30H]                    ; 0A78 _ 48: 8B. 45, D0
        add     rax, rdx                                ; 0A7C _ 48: 01. D0
        mov     eax, dword [rax]                        ; 0A7F _ 8B. 00
        mov     edx, dword [rbp-4H]                     ; 0A81 _ 8B. 55, FC
        add     edx, edx                                ; 0A84 _ 01. D2
        sub     edx, 1                                  ; 0A86 _ 83. EA, 01
        and     eax, edx                                ; 0A89 _ 21. D0
        mov     dword [rbp-14H], eax                    ; 0A8B _ 89. 45, EC
        mov     eax, dword [rbp-0CH]                    ; 0A8E _ 8B. 45, F4
        add     eax, 1                                  ; 0A91 _ 83. C0, 01
        mov     dword [rbp-10H], eax                    ; 0A94 _ 89. 45, F0
        jmp     ?_074                                   ; 0A97 _ EB, 1D

?_073:  mov     eax, dword [rbp-10H]                    ; 0A99 _ 8B. 45, F0
        cdqe                                            ; 0A9C _ 48: 98
        lea     rdx, [rax*4]                            ; 0A9E _ 48: 8D. 14 85, 00000000
        mov     rax, qword [rbp-30H]                    ; 0AA6 _ 48: 8B. 45, D0
        add     rax, rdx                                ; 0AAA _ 48: 01. D0
        mov     eax, dword [rax]                        ; 0AAD _ 8B. 00
        or      dword [rbp-14H], eax                    ; 0AAF _ 09. 45, EC
        add     dword [rbp-10H], 1                      ; 0AB2 _ 83. 45, F0, 01
?_074:  cmp     dword [rbp-10H], 5                      ; 0AB6 _ 83. 7D, F0, 05
        jle     ?_073                                   ; 0ABA _ 7E, DD
        mov     eax, dword [rbp-0CH]                    ; 0ABC _ 8B. 45, F4
        cdqe                                            ; 0ABF _ 48: 98
        lea     rdx, [rax*4]                            ; 0AC1 _ 48: 8D. 14 85, 00000000
        mov     rax, qword [rbp-30H]                    ; 0AC9 _ 48: 8B. 45, D0
        add     rax, rdx                                ; 0ACD _ 48: 01. D0
        mov     eax, dword [rax]                        ; 0AD0 _ 8B. 00
        mov     edx, dword [rbp-0CH]                    ; 0AD2 _ 8B. 55, F4
        movsxd  rdx, edx                                ; 0AD5 _ 48: 63. D2
        lea     rcx, [rdx*4]                            ; 0AD8 _ 48: 8D. 0C 95, 00000000
        mov     rdx, qword [rbp-30H]                    ; 0AE0 _ 48: 8B. 55, D0
        add     rdx, rcx                                ; 0AE4 _ 48: 01. CA
        or      eax, dword [rbp-4H]                     ; 0AE7 _ 0B. 45, FC
        mov     dword [rdx], eax                        ; 0AEA _ 89. 02
        cmp     dword [rbp-14H], 0                      ; 0AEC _ 83. 7D, EC, 00
        je      ?_080                                   ; 0AF0 _ 0F 84, 000000BA
        mov     eax, dword [rbp-0CH]                    ; 0AF6 _ 8B. 45, F4
        cdqe                                            ; 0AF9 _ 48: 98
        lea     rdx, [rax*4]                            ; 0AFB _ 48: 8D. 14 85, 00000000
        mov     rax, qword [rbp-30H]                    ; 0B03 _ 48: 8B. 45, D0
        add     rax, rdx                                ; 0B07 _ 48: 01. D0
        mov     eax, dword [rax]                        ; 0B0A _ 8B. 00
        mov     edx, dword [rbp-4H]                     ; 0B0C _ 8B. 55, FC
        neg     edx                                     ; 0B0F _ F7. DA
        and     eax, edx                                ; 0B11 _ 21. D0
        mov     ecx, eax                                ; 0B13 _ 89. C1
        mov     eax, dword [rbp-0CH]                    ; 0B15 _ 8B. 45, F4
        cdqe                                            ; 0B18 _ 48: 98
        lea     rdx, [rax*4]                            ; 0B1A _ 48: 8D. 14 85, 00000000
        mov     rax, qword [rbp-30H]                    ; 0B22 _ 48: 8B. 45, D0
        add     rax, rdx                                ; 0B26 _ 48: 01. D0
        mov     edx, dword [rbp-4H]                     ; 0B29 _ 8B. 55, FC
        add     edx, ecx                                ; 0B2C _ 01. CA
        mov     dword [rax], edx                        ; 0B2E _ 89. 10
        mov     eax, dword [rbp-0CH]                    ; 0B30 _ 8B. 45, F4
        add     eax, 1                                  ; 0B33 _ 83. C0, 01
        mov     dword [rbp-10H], eax                    ; 0B36 _ 89. 45, F0
        jmp     ?_076                                   ; 0B39 _ EB, 1E

?_075:  mov     eax, dword [rbp-10H]                    ; 0B3B _ 8B. 45, F0
        cdqe                                            ; 0B3E _ 48: 98
        lea     rdx, [rax*4]                            ; 0B40 _ 48: 8D. 14 85, 00000000
        mov     rax, qword [rbp-30H]                    ; 0B48 _ 48: 8B. 45, D0
        add     rax, rdx                                ; 0B4C _ 48: 01. D0
        mov     dword [rax], 0                          ; 0B4F _ C7. 00, 00000000
        add     dword [rbp-10H], 1                      ; 0B55 _ 83. 45, F0, 01
?_076:  cmp     dword [rbp-10H], 5                      ; 0B59 _ 83. 7D, F0, 05
        jle     ?_075                                   ; 0B5D _ 7E, DC
        jmp     ?_078                                   ; 0B5F _ EB, 1F

?_077:  sub     dword [rbp-0CH], 1                      ; 0B61 _ 83. 6D, F4, 01
        mov     eax, dword [rbp-0CH]                    ; 0B65 _ 8B. 45, F4
        cdqe                                            ; 0B68 _ 48: 98
        lea     rdx, [rax*4]                            ; 0B6A _ 48: 8D. 14 85, 00000000
        mov     rax, qword [rbp-30H]                    ; 0B72 _ 48: 8B. 45, D0
        add     rax, rdx                                ; 0B76 _ 48: 01. D0
        mov     edx, dword [rax]                        ; 0B79 _ 8B. 10
        add     edx, 1                                  ; 0B7B _ 83. C2, 01
        mov     dword [rax], edx                        ; 0B7E _ 89. 10
?_078:  cmp     dword [rbp-0CH], 0                      ; 0B80 _ 83. 7D, F4, 00
        jle     ?_079                                   ; 0B84 _ 7E, 1A
        mov     eax, dword [rbp-0CH]                    ; 0B86 _ 8B. 45, F4
        cdqe                                            ; 0B89 _ 48: 98
        lea     rdx, [rax*4]                            ; 0B8B _ 48: 8D. 14 85, 00000000
        mov     rax, qword [rbp-30H]                    ; 0B93 _ 48: 8B. 45, D0
        add     rax, rdx                                ; 0B97 _ 48: 01. D0
        mov     eax, dword [rax]                        ; 0B9A _ 8B. 00
        test    eax, eax                                ; 0B9C _ 85. C0
        jz      ?_077                                   ; 0B9E _ 74, C1
?_079:  mov     rax, qword [rbp-30H]                    ; 0BA0 _ 48: 8B. 45, D0
        mov     eax, dword [rax]                        ; 0BA4 _ 8B. 00
        test    eax, eax                                ; 0BA6 _ 85. C0
        sete    al                                      ; 0BA8 _ 0F 94. C0
        jmp     ?_109                                   ; 0BAB _ E9, 000003C6

?_080:  mov     eax, dword [rbp-28H]                    ; 0BB0 _ 8B. 45, D8
        sub     eax, 1                                  ; 0BB3 _ 83. E8, 01
        movsxd  rdx, eax                                ; 0BB6 _ 48: 63. D0
        mov     rax, qword [rbp-30H]                    ; 0BB9 _ 48: 8B. 45, D0
        mov     rsi, rdx                                ; 0BBD _ 48: 89. D6
        mov     rdi, rax                                ; 0BC0 _ 48: 89. C7
        call    test_bit                                ; 0BC3 _ E8, FFFFFD72
        test    eax, eax                                ; 0BC8 _ 85. C0
        je      ?_086                                   ; 0BCA _ 0F 84, 000000BA
        mov     eax, dword [rbp-0CH]                    ; 0BD0 _ 8B. 45, F4
        cdqe                                            ; 0BD3 _ 48: 98
        lea     rdx, [rax*4]                            ; 0BD5 _ 48: 8D. 14 85, 00000000
        mov     rax, qword [rbp-30H]                    ; 0BDD _ 48: 8B. 45, D0
        add     rax, rdx                                ; 0BE1 _ 48: 01. D0
        mov     eax, dword [rax]                        ; 0BE4 _ 8B. 00
        mov     edx, dword [rbp-4H]                     ; 0BE6 _ 8B. 55, FC
        neg     edx                                     ; 0BE9 _ F7. DA
        and     eax, edx                                ; 0BEB _ 21. D0
        mov     ecx, eax                                ; 0BED _ 89. C1
        mov     eax, dword [rbp-0CH]                    ; 0BEF _ 8B. 45, F4
        cdqe                                            ; 0BF2 _ 48: 98
        lea     rdx, [rax*4]                            ; 0BF4 _ 48: 8D. 14 85, 00000000
        mov     rax, qword [rbp-30H]                    ; 0BFC _ 48: 8B. 45, D0
        add     rax, rdx                                ; 0C00 _ 48: 01. D0
        mov     edx, dword [rbp-4H]                     ; 0C03 _ 8B. 55, FC
        add     edx, ecx                                ; 0C06 _ 01. CA
        mov     dword [rax], edx                        ; 0C08 _ 89. 10
        mov     eax, dword [rbp-0CH]                    ; 0C0A _ 8B. 45, F4
        add     eax, 1                                  ; 0C0D _ 83. C0, 01
        mov     dword [rbp-10H], eax                    ; 0C10 _ 89. 45, F0
        jmp     ?_082                                   ; 0C13 _ EB, 1E

?_081:  mov     eax, dword [rbp-10H]                    ; 0C15 _ 8B. 45, F0
        cdqe                                            ; 0C18 _ 48: 98
        lea     rdx, [rax*4]                            ; 0C1A _ 48: 8D. 14 85, 00000000
        mov     rax, qword [rbp-30H]                    ; 0C22 _ 48: 8B. 45, D0
        add     rax, rdx                                ; 0C26 _ 48: 01. D0
        mov     dword [rax], 0                          ; 0C29 _ C7. 00, 00000000
        add     dword [rbp-10H], 1                      ; 0C2F _ 83. 45, F0, 01
?_082:  cmp     dword [rbp-10H], 5                      ; 0C33 _ 83. 7D, F0, 05
        jle     ?_081                                   ; 0C37 _ 7E, DC
        jmp     ?_084                                   ; 0C39 _ EB, 1F

?_083:  sub     dword [rbp-0CH], 1                      ; 0C3B _ 83. 6D, F4, 01
        mov     eax, dword [rbp-0CH]                    ; 0C3F _ 8B. 45, F4
        cdqe                                            ; 0C42 _ 48: 98
        lea     rdx, [rax*4]                            ; 0C44 _ 48: 8D. 14 85, 00000000
        mov     rax, qword [rbp-30H]                    ; 0C4C _ 48: 8B. 45, D0
        add     rax, rdx                                ; 0C50 _ 48: 01. D0
        mov     edx, dword [rax]                        ; 0C53 _ 8B. 10
        add     edx, 1                                  ; 0C55 _ 83. C2, 01
        mov     dword [rax], edx                        ; 0C58 _ 89. 10
?_084:  cmp     dword [rbp-0CH], 0                      ; 0C5A _ 83. 7D, F4, 00
        jle     ?_085                                   ; 0C5E _ 7E, 1A
        mov     eax, dword [rbp-0CH]                    ; 0C60 _ 8B. 45, F4
        cdqe                                            ; 0C63 _ 48: 98
        lea     rdx, [rax*4]                            ; 0C65 _ 48: 8D. 14 85, 00000000
        mov     rax, qword [rbp-30H]                    ; 0C6D _ 48: 8B. 45, D0
        add     rax, rdx                                ; 0C71 _ 48: 01. D0
        mov     eax, dword [rax]                        ; 0C74 _ 8B. 00
        test    eax, eax                                ; 0C76 _ 85. C0
        jz      ?_083                                   ; 0C78 _ 74, C1
?_085:  mov     rax, qword [rbp-30H]                    ; 0C7A _ 48: 8B. 45, D0
        mov     eax, dword [rax]                        ; 0C7E _ 8B. 00
        test    eax, eax                                ; 0C80 _ 85. C0
        sete    al                                      ; 0C82 _ 0F 94. C0
        jmp     ?_109                                   ; 0C85 _ E9, 000002EC

?_086:  mov     eax, dword [rbp-0CH]                    ; 0C8A _ 8B. 45, F4
        cdqe                                            ; 0C8D _ 48: 98
        lea     rdx, [rax*4]                            ; 0C8F _ 48: 8D. 14 85, 00000000
        mov     rax, qword [rbp-30H]                    ; 0C97 _ 48: 8B. 45, D0
        add     rax, rdx                                ; 0C9B _ 48: 01. D0
        mov     edx, dword [rax]                        ; 0C9E _ 8B. 10
        mov     eax, dword [rbp-4H]                     ; 0CA0 _ 8B. 45, FC
        neg     eax                                     ; 0CA3 _ F7. D8
        mov     ecx, eax                                ; 0CA5 _ 89. C1
        mov     eax, dword [rbp-0CH]                    ; 0CA7 _ 8B. 45, F4
        cdqe                                            ; 0CAA _ 48: 98
        lea     rsi, [rax*4]                            ; 0CAC _ 48: 8D. 34 85, 00000000
        mov     rax, qword [rbp-30H]                    ; 0CB4 _ 48: 8B. 45, D0
        add     rax, rsi                                ; 0CB8 _ 48: 01. F0
        and     edx, ecx                                ; 0CBB _ 21. CA
        mov     dword [rax], edx                        ; 0CBD _ 89. 10
        mov     eax, dword [rbp-0CH]                    ; 0CBF _ 8B. 45, F4
        add     eax, 1                                  ; 0CC2 _ 83. C0, 01
        mov     dword [rbp-10H], eax                    ; 0CC5 _ 89. 45, F0
        jmp     ?_088                                   ; 0CC8 _ EB, 1E

?_087:  mov     eax, dword [rbp-10H]                    ; 0CCA _ 8B. 45, F0
        cdqe                                            ; 0CCD _ 48: 98
        lea     rdx, [rax*4]                            ; 0CCF _ 48: 8D. 14 85, 00000000
        mov     rax, qword [rbp-30H]                    ; 0CD7 _ 48: 8B. 45, D0
        add     rax, rdx                                ; 0CDB _ 48: 01. D0
        mov     dword [rax], 0                          ; 0CDE _ C7. 00, 00000000
        add     dword [rbp-10H], 1                      ; 0CE4 _ 83. 45, F0, 01
?_088:  cmp     dword [rbp-10H], 5                      ; 0CE8 _ 83. 7D, F0, 05
        jle     ?_087                                   ; 0CEC _ 7E, DC
        mov     eax, 0                                  ; 0CEE _ B8, 00000000
        jmp     ?_109                                   ; 0CF3 _ E9, 0000027E

?_089:  mov     eax, dword [rbp-0CH]                    ; 0CF8 _ 8B. 45, F4
        cdqe                                            ; 0CFB _ 48: 98
        lea     rdx, [rax*4]                            ; 0CFD _ 48: 8D. 14 85, 00000000
        mov     rax, qword [rbp-30H]                    ; 0D05 _ 48: 8B. 45, D0
        add     rax, rdx                                ; 0D09 _ 48: 01. D0
        mov     edx, dword [rax]                        ; 0D0C _ 8B. 10
        mov     eax, dword [rbp-4H]                     ; 0D0E _ 8B. 45, FC
        neg     eax                                     ; 0D11 _ F7. D8
        mov     ecx, eax                                ; 0D13 _ 89. C1
        mov     eax, dword [rbp-0CH]                    ; 0D15 _ 8B. 45, F4
        cdqe                                            ; 0D18 _ 48: 98
        lea     rsi, [rax*4]                            ; 0D1A _ 48: 8D. 34 85, 00000000
        mov     rax, qword [rbp-30H]                    ; 0D22 _ 48: 8B. 45, D0
        add     rax, rsi                                ; 0D26 _ 48: 01. F0
        and     edx, ecx                                ; 0D29 _ 21. CA
        mov     dword [rax], edx                        ; 0D2B _ 89. 10
        mov     eax, dword [rbp-0CH]                    ; 0D2D _ 8B. 45, F4
        add     eax, 1                                  ; 0D30 _ 83. C0, 01
        mov     dword [rbp-10H], eax                    ; 0D33 _ 89. 45, F0
        jmp     ?_091                                   ; 0D36 _ EB, 1E

?_090:  mov     eax, dword [rbp-10H]                    ; 0D38 _ 8B. 45, F0
        cdqe                                            ; 0D3B _ 48: 98
        lea     rdx, [rax*4]                            ; 0D3D _ 48: 8D. 14 85, 00000000
        mov     rax, qword [rbp-30H]                    ; 0D45 _ 48: 8B. 45, D0
        add     rax, rdx                                ; 0D49 _ 48: 01. D0
        mov     dword [rax], 0                          ; 0D4C _ C7. 00, 00000000
        add     dword [rbp-10H], 1                      ; 0D52 _ 83. 45, F0, 01
?_091:  cmp     dword [rbp-10H], 5                      ; 0D56 _ 83. 7D, F0, 05
        jle     ?_090                                   ; 0D5A _ 7E, DC
        mov     eax, 0                                  ; 0D5C _ B8, 00000000
        jmp     ?_109                                   ; 0D61 _ E9, 00000210

?_092:  mov     eax, dword [rel rc]                     ; 0D66 _ 8B. 05, 00000000(rel)
        cmp     eax, 1                                  ; 0D6C _ 83. F8, 01
        jz      ?_095                                   ; 0D6F _ 74, 1C
        cmp     byte [rbp-21H], 0                       ; 0D71 _ 80. 7D, DF, 00
        jz      ?_093                                   ; 0D75 _ 74, 07
        mov     edx, 3                                  ; 0D77 _ BA, 00000003
        jmp     ?_094                                   ; 0D7C _ EB, 05

?_093:  mov     edx, 2                                  ; 0D7E _ BA, 00000002
?_094:  mov     eax, dword [rel rc]                     ; 0D83 _ 8B. 05, 00000000(rel)
        cmp     edx, eax                                ; 0D89 _ 39. C2
        jnz     ?_098                                   ; 0D8B _ 75, 6E
?_095:  mov     eax, dword [rbp-0CH]                    ; 0D8D _ 8B. 45, F4
        cdqe                                            ; 0D90 _ 48: 98
        lea     rdx, [rax*4]                            ; 0D92 _ 48: 8D. 14 85, 00000000
        mov     rax, qword [rbp-30H]                    ; 0D9A _ 48: 8B. 45, D0
        add     rax, rdx                                ; 0D9E _ 48: 01. D0
        mov     edx, dword [rax]                        ; 0DA1 _ 8B. 10
        mov     eax, dword [rbp-4H]                     ; 0DA3 _ 8B. 45, FC
        neg     eax                                     ; 0DA6 _ F7. D8
        mov     ecx, eax                                ; 0DA8 _ 89. C1
        mov     eax, dword [rbp-0CH]                    ; 0DAA _ 8B. 45, F4
        cdqe                                            ; 0DAD _ 48: 98
        lea     rsi, [rax*4]                            ; 0DAF _ 48: 8D. 34 85, 00000000
        mov     rax, qword [rbp-30H]                    ; 0DB7 _ 48: 8B. 45, D0
        add     rax, rsi                                ; 0DBB _ 48: 01. F0
        and     edx, ecx                                ; 0DBE _ 21. CA
        mov     dword [rax], edx                        ; 0DC0 _ 89. 10
        mov     eax, dword [rbp-0CH]                    ; 0DC2 _ 8B. 45, F4
        add     eax, 1                                  ; 0DC5 _ 83. C0, 01
        mov     dword [rbp-10H], eax                    ; 0DC8 _ 89. 45, F0
        jmp     ?_097                                   ; 0DCB _ EB, 1E

?_096:  mov     eax, dword [rbp-10H]                    ; 0DCD _ 8B. 45, F0
        cdqe                                            ; 0DD0 _ 48: 98
        lea     rdx, [rax*4]                            ; 0DD2 _ 48: 8D. 14 85, 00000000
        mov     rax, qword [rbp-30H]                    ; 0DDA _ 48: 8B. 45, D0
        add     rax, rdx                                ; 0DDE _ 48: 01. D0
        mov     dword [rax], 0                          ; 0DE1 _ C7. 00, 00000000
        add     dword [rbp-10H], 1                      ; 0DE7 _ 83. 45, F0, 01
?_097:  cmp     dword [rbp-10H], 5                      ; 0DEB _ 83. 7D, F0, 05
        jle     ?_096                                   ; 0DEF _ 7E, DC
        mov     eax, 0                                  ; 0DF1 _ B8, 00000000
        jmp     ?_109                                   ; 0DF6 _ E9, 0000017B

?_098:  mov     eax, dword [rbp-0CH]                    ; 0DFB _ 8B. 45, F4
        cdqe                                            ; 0DFE _ 48: 98
        lea     rdx, [rax*4]                            ; 0E00 _ 48: 8D. 14 85, 00000000
        mov     rax, qword [rbp-30H]                    ; 0E08 _ 48: 8B. 45, D0
        add     rax, rdx                                ; 0E0C _ 48: 01. D0
        mov     eax, dword [rax]                        ; 0E0F _ 8B. 00
        mov     edx, dword [rbp-4H]                     ; 0E11 _ 8B. 55, FC
        add     edx, edx                                ; 0E14 _ 01. D2
        sub     edx, 1                                  ; 0E16 _ 83. EA, 01
        and     eax, edx                                ; 0E19 _ 21. D0
        mov     dword [rbp-14H], eax                    ; 0E1B _ 89. 45, EC
        mov     eax, dword [rbp-0CH]                    ; 0E1E _ 8B. 45, F4
        add     eax, 1                                  ; 0E21 _ 83. C0, 01
        mov     dword [rbp-10H], eax                    ; 0E24 _ 89. 45, F0
        jmp     ?_100                                   ; 0E27 _ EB, 1D

?_099:  mov     eax, dword [rbp-10H]                    ; 0E29 _ 8B. 45, F0
        cdqe                                            ; 0E2C _ 48: 98
        lea     rdx, [rax*4]                            ; 0E2E _ 48: 8D. 14 85, 00000000
        mov     rax, qword [rbp-30H]                    ; 0E36 _ 48: 8B. 45, D0
        add     rax, rdx                                ; 0E3A _ 48: 01. D0
        mov     eax, dword [rax]                        ; 0E3D _ 8B. 00
        or      dword [rbp-14H], eax                    ; 0E3F _ 09. 45, EC
        add     dword [rbp-10H], 1                      ; 0E42 _ 83. 45, F0, 01
?_100:  cmp     dword [rbp-10H], 5                      ; 0E46 _ 83. 7D, F0, 05
        jle     ?_099                                   ; 0E4A _ 7E, DD
        cmp     dword [rbp-14H], 0                      ; 0E4C _ 83. 7D, EC, 00
        je      ?_106                                   ; 0E50 _ 0F 84, 000000B7
        mov     eax, dword [rbp-0CH]                    ; 0E56 _ 8B. 45, F4
        cdqe                                            ; 0E59 _ 48: 98
        lea     rdx, [rax*4]                            ; 0E5B _ 48: 8D. 14 85, 00000000
        mov     rax, qword [rbp-30H]                    ; 0E63 _ 48: 8B. 45, D0
        add     rax, rdx                                ; 0E67 _ 48: 01. D0
        mov     eax, dword [rax]                        ; 0E6A _ 8B. 00
        mov     edx, dword [rbp-4H]                     ; 0E6C _ 8B. 55, FC
        neg     edx                                     ; 0E6F _ F7. DA
        and     eax, edx                                ; 0E71 _ 21. D0
        mov     ecx, eax                                ; 0E73 _ 89. C1
        mov     eax, dword [rbp-0CH]                    ; 0E75 _ 8B. 45, F4
        cdqe                                            ; 0E78 _ 48: 98
        lea     rdx, [rax*4]                            ; 0E7A _ 48: 8D. 14 85, 00000000
        mov     rax, qword [rbp-30H]                    ; 0E82 _ 48: 8B. 45, D0
        add     rax, rdx                                ; 0E86 _ 48: 01. D0
        mov     edx, dword [rbp-4H]                     ; 0E89 _ 8B. 55, FC
        add     edx, ecx                                ; 0E8C _ 01. CA
        mov     dword [rax], edx                        ; 0E8E _ 89. 10
        mov     eax, dword [rbp-0CH]                    ; 0E90 _ 8B. 45, F4
        add     eax, 1                                  ; 0E93 _ 83. C0, 01
        mov     dword [rbp-10H], eax                    ; 0E96 _ 89. 45, F0
        jmp     ?_102                                   ; 0E99 _ EB, 1E

?_101:  mov     eax, dword [rbp-10H]                    ; 0E9B _ 8B. 45, F0
        cdqe                                            ; 0E9E _ 48: 98
        lea     rdx, [rax*4]                            ; 0EA0 _ 48: 8D. 14 85, 00000000
        mov     rax, qword [rbp-30H]                    ; 0EA8 _ 48: 8B. 45, D0
        add     rax, rdx                                ; 0EAC _ 48: 01. D0
        mov     dword [rax], 0                          ; 0EAF _ C7. 00, 00000000
        add     dword [rbp-10H], 1                      ; 0EB5 _ 83. 45, F0, 01
?_102:  cmp     dword [rbp-10H], 5                      ; 0EB9 _ 83. 7D, F0, 05
        jle     ?_101                                   ; 0EBD _ 7E, DC
        jmp     ?_104                                   ; 0EBF _ EB, 1F

?_103:  sub     dword [rbp-0CH], 1                      ; 0EC1 _ 83. 6D, F4, 01
        mov     eax, dword [rbp-0CH]                    ; 0EC5 _ 8B. 45, F4
        cdqe                                            ; 0EC8 _ 48: 98
        lea     rdx, [rax*4]                            ; 0ECA _ 48: 8D. 14 85, 00000000
        mov     rax, qword [rbp-30H]                    ; 0ED2 _ 48: 8B. 45, D0
        add     rax, rdx                                ; 0ED6 _ 48: 01. D0
        mov     edx, dword [rax]                        ; 0ED9 _ 8B. 10
        add     edx, 1                                  ; 0EDB _ 83. C2, 01
        mov     dword [rax], edx                        ; 0EDE _ 89. 10
?_104:  cmp     dword [rbp-0CH], 0                      ; 0EE0 _ 83. 7D, F4, 00
        jle     ?_105                                   ; 0EE4 _ 7E, 1A
        mov     eax, dword [rbp-0CH]                    ; 0EE6 _ 8B. 45, F4
        cdqe                                            ; 0EE9 _ 48: 98
        lea     rdx, [rax*4]                            ; 0EEB _ 48: 8D. 14 85, 00000000
        mov     rax, qword [rbp-30H]                    ; 0EF3 _ 48: 8B. 45, D0
        add     rax, rdx                                ; 0EF7 _ 48: 01. D0
        mov     eax, dword [rax]                        ; 0EFA _ 8B. 00
        test    eax, eax                                ; 0EFC _ 85. C0
        jz      ?_103                                   ; 0EFE _ 74, C1
?_105:  mov     rax, qword [rbp-30H]                    ; 0F00 _ 48: 8B. 45, D0
        mov     eax, dword [rax]                        ; 0F04 _ 8B. 00
        test    eax, eax                                ; 0F06 _ 85. C0
        sete    al                                      ; 0F08 _ 0F 94. C0
        jmp     ?_109                                   ; 0F0B _ EB, 69

?_106:  mov     eax, dword [rbp-0CH]                    ; 0F0D _ 8B. 45, F4
        cdqe                                            ; 0F10 _ 48: 98
        lea     rdx, [rax*4]                            ; 0F12 _ 48: 8D. 14 85, 00000000
        mov     rax, qword [rbp-30H]                    ; 0F1A _ 48: 8B. 45, D0
        add     rax, rdx                                ; 0F1E _ 48: 01. D0
        mov     edx, dword [rax]                        ; 0F21 _ 8B. 10
        mov     eax, dword [rbp-4H]                     ; 0F23 _ 8B. 45, FC
        neg     eax                                     ; 0F26 _ F7. D8
        mov     ecx, eax                                ; 0F28 _ 89. C1
        mov     eax, dword [rbp-0CH]                    ; 0F2A _ 8B. 45, F4
        cdqe                                            ; 0F2D _ 48: 98
        lea     rsi, [rax*4]                            ; 0F2F _ 48: 8D. 34 85, 00000000
        mov     rax, qword [rbp-30H]                    ; 0F37 _ 48: 8B. 45, D0
        add     rax, rsi                                ; 0F3B _ 48: 01. F0
        and     edx, ecx                                ; 0F3E _ 21. CA
        mov     dword [rax], edx                        ; 0F40 _ 89. 10
        mov     eax, dword [rbp-0CH]                    ; 0F42 _ 8B. 45, F4
        add     eax, 1                                  ; 0F45 _ 83. C0, 01
        mov     dword [rbp-10H], eax                    ; 0F48 _ 89. 45, F0
        jmp     ?_108                                   ; 0F4B _ EB, 1E

?_107:  mov     eax, dword [rbp-10H]                    ; 0F4D _ 8B. 45, F0
        cdqe                                            ; 0F50 _ 48: 98
        lea     rdx, [rax*4]                            ; 0F52 _ 48: 8D. 14 85, 00000000
        mov     rax, qword [rbp-30H]                    ; 0F5A _ 48: 8B. 45, D0
        add     rax, rdx                                ; 0F5E _ 48: 01. D0
        mov     dword [rax], 0                          ; 0F61 _ C7. 00, 00000000
        add     dword [rbp-10H], 1                      ; 0F67 _ 83. 45, F0, 01
?_108:  cmp     dword [rbp-10H], 5                      ; 0F6B _ 83. 7D, F0, 05
        jle     ?_107                                   ; 0F6F _ 7E, DC
        mov     eax, 0                                  ; 0F71 _ B8, 00000000
?_109:  leave                                           ; 0F76 _ C9
        ret                                             ; 0F77 _ C3

ieee_flconvert_bin:; Local function
        push    rbp                                     ; 0F78 _ 55
        mov     rbp, rsp                                ; 0F79 _ 48: 89. E5
        add     rsp, -128                               ; 0F7C _ 48: 83. C4, 80
        mov     qword [rbp-68H], rdi                    ; 0F80 _ 48: 89. 7D, 98
        mov     dword [rbp-6CH], esi                    ; 0F84 _ 89. 75, 94
        mov     qword [rbp-78H], rdx                    ; 0F87 _ 48: 89. 55, 88
        mov     qword [rbp-80H], rcx                    ; 0F8B _ 48: 89. 4D, 80
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        mov     rax, qword [fs:abs 28H]                 ; 0F8F _ 64 48: 8B. 04 25, 00000028
        mov     qword [rbp-8H], rax                     ; 0F98 _ 48: 89. 45, F8
        xor     eax, eax                                ; 0F9C _ 31. C0
        mov     eax, dword [rbp-6CH]                    ; 0F9E _ 8B. 45, 94
        mov     edx, 1                                  ; 0FA1 _ BA, 00000001
        mov     ecx, eax                                ; 0FA6 _ 89. C1
        shl     edx, cl                                 ; 0FA8 _ D3. E2
        mov     eax, edx                                ; 0FAA _ 89. D0
        mov     dword [rbp-48H], eax                    ; 0FAC _ 89. 45, B8
        mov     dword [rbp-4CH], 0                      ; 0FAF _ C7. 45, B4, 00000000
        mov     byte [rbp-52H], 0                       ; 0FB6 _ C6. 45, AE, 00
        movzx   eax, byte [rbp-52H]                     ; 0FBA _ 0F B6. 45, AE
        mov     byte [rbp-53H], al                      ; 0FBE _ 88. 45, AD
        mov     dword [rbp-50H], 0                      ; 0FC1 _ C7. 45, B0, 00000000
        mov     qword [rbp-38H], 0                      ; 0FC8 _ 48: C7. 45, C8, 00000000
        lea     rax, [rbp-30H]                          ; 0FD0 _ 48: 8D. 45, D0
        mov     edx, 28                                 ; 0FD4 _ BA, 0000001C
        mov     esi, 0                                  ; 0FD9 _ BE, 00000000
        mov     rdi, rax                                ; 0FDE _ 48: 89. C7
        call    memset                                  ; 0FE1 _ E8, 00000000(PLT r)
        jmp     ?_121                                   ; 0FE6 _ E9, 00000191

?_110:  cmp     byte [rbp-51H], 46                      ; 0FEB _ 80. 7D, AF, 2E
        jnz     ?_112                                   ; 0FEF _ 75, 32
        movzx   eax, byte [rbp-53H]                     ; 0FF1 _ 0F B6. 45, AD
        xor     eax, 01H                                ; 0FF5 _ 83. F0, 01
        test    al, al                                  ; 0FF8 _ 84. C0
        jz      ?_111                                   ; 0FFA _ 74, 09
        mov     byte [rbp-53H], 1                       ; 0FFC _ C6. 45, AD, 01
        jmp     ?_121                                   ; 1000 _ E9, 00000177

?_111:  lea     rax, [rel ?_206]                        ; 1005 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 100C _ 48: 89. C7
        mov     eax, 0                                  ; 100F _ B8, 00000000
        call    nasm_nonfatal                           ; 1014 _ E8, 00000000(PLT r)
        mov     eax, 0                                  ; 1019 _ B8, 00000000
        jmp     ?_125                                   ; 101E _ E9, 000001C8

?_112:  movzx   eax, byte [rbp-51H]                     ; 1023 _ 0F B6. 45, AF
        movsx   eax, al                                 ; 1027 _ 0F BE. C0
        mov     edi, eax                                ; 102A _ 89. C7
        call    nasm_hexval                             ; 102C _ E8, FFFFEFCF
        mov     dword [rbp-44H], eax                    ; 1031 _ 89. 45, BC
        mov     eax, dword [rbp-48H]                    ; 1034 _ 8B. 45, B8
        cmp     dword [rbp-44H], eax                    ; 1037 _ 39. 45, BC
        jnc     ?_117                                   ; 103A _ 0F 83, 000000DA
        movzx   eax, byte [rbp-52H]                     ; 1040 _ 0F B6. 45, AE
        xor     eax, 01H                                ; 1044 _ 83. F0, 01
        test    al, al                                  ; 1047 _ 84. C0
        jz      ?_113                                   ; 1049 _ 74, 41
        cmp     dword [rbp-44H], 0                      ; 104B _ 83. 7D, BC, 00
        jz      ?_113                                   ; 104F _ 74, 3B
        mov     eax, dword [rbp-44H]                    ; 1051 _ 8B. 45, BC
        lea     rdx, [rax*4]                            ; 1054 _ 48: 8D. 14 85, 00000000
        lea     rax, [rel log2tbl.1]                    ; 105C _ 48: 8D. 05, 00000000(rel)
        mov     eax, dword [rdx+rax]                    ; 1063 _ 8B. 04 02
        mov     dword [rbp-3CH], eax                    ; 1066 _ 89. 45, C4
        mov     byte [rbp-52H], 1                       ; 1069 _ C6. 45, AE, 01
        lea     rax, [rbp-30H]                          ; 106D _ 48: 8D. 45, D0
        mov     qword [rbp-38H], rax                    ; 1071 _ 48: 89. 45, C8
        mov     eax, 31                                 ; 1075 _ B8, 0000001F
        sub     eax, dword [rbp-3CH]                    ; 107A _ 2B. 45, C4
        mov     dword [rbp-50H], eax                    ; 107D _ 89. 45, B0
        mov     eax, dword [rbp-3CH]                    ; 1080 _ 8B. 45, C4
        add     eax, 1                                  ; 1083 _ 83. C0, 01
        sub     eax, dword [rbp-6CH]                    ; 1086 _ 2B. 45, 94
        add     dword [rbp-4CH], eax                    ; 1089 _ 01. 45, B4
?_113:  cmp     byte [rbp-52H], 0                       ; 108C _ 80. 7D, AE, 00
        jz      ?_116                                   ; 1090 _ 74, 7A
        cmp     dword [rbp-50H], 0                      ; 1092 _ 83. 7D, B0, 00
        jns     ?_115                                   ; 1096 _ 79, 41
        mov     rax, qword [rbp-38H]                    ; 1098 _ 48: 8B. 45, C8
        mov     eax, dword [rax]                        ; 109C _ 8B. 00
        mov     esi, dword [rbp-44H]                    ; 109E _ 8B. 75, BC
        mov     edx, dword [rbp-50H]                    ; 10A1 _ 8B. 55, B0
        neg     edx                                     ; 10A4 _ F7. DA
        mov     ecx, edx                                ; 10A6 _ 89. D1
        shr     rsi, cl                                 ; 10A8 _ 48: D3. EE
        mov     rdx, rsi                                ; 10AB _ 48: 89. F2
        or      edx, eax                                ; 10AE _ 09. C2
        mov     rax, qword [rbp-38H]                    ; 10B0 _ 48: 8B. 45, C8
        mov     dword [rax], edx                        ; 10B4 _ 89. 10
        add     qword [rbp-38H], 4                      ; 10B6 _ 48: 83. 45, C8, 04
        lea     rax, [rbp-30H]                          ; 10BB _ 48: 8D. 45, D0
        add     rax, 24                                 ; 10BF _ 48: 83. C0, 18
        cmp     rax, qword [rbp-38H]                    ; 10C3 _ 48: 3B. 45, C8
        jnc     ?_114                                   ; 10C7 _ 73, 0C
        lea     rax, [rbp-30H]                          ; 10C9 _ 48: 8D. 45, D0
        add     rax, 24                                 ; 10CD _ 48: 83. C0, 18
        mov     qword [rbp-38H], rax                    ; 10D1 _ 48: 89. 45, C8
?_114:  add     dword [rbp-50H], 32                     ; 10D5 _ 83. 45, B0, 20
?_115:  mov     rax, qword [rbp-38H]                    ; 10D9 _ 48: 8B. 45, C8
        mov     edx, dword [rax]                        ; 10DD _ 8B. 10
        mov     eax, dword [rbp-50H]                    ; 10DF _ 8B. 45, B0
        mov     esi, dword [rbp-44H]                    ; 10E2 _ 8B. 75, BC
        mov     ecx, eax                                ; 10E5 _ 89. C1
        shl     esi, cl                                 ; 10E7 _ D3. E6
        mov     eax, esi                                ; 10E9 _ 89. F0
        or      edx, eax                                ; 10EB _ 09. C2
        mov     rax, qword [rbp-38H]                    ; 10ED _ 48: 8B. 45, C8
        mov     dword [rax], edx                        ; 10F1 _ 89. 10
        mov     eax, dword [rbp-6CH]                    ; 10F3 _ 8B. 45, 94
        sub     dword [rbp-50H], eax                    ; 10F6 _ 29. 45, B0
        movzx   eax, byte [rbp-53H]                     ; 10F9 _ 0F B6. 45, AD
        xor     eax, 01H                                ; 10FD _ 83. F0, 01
        test    al, al                                  ; 1100 _ 84. C0
        jz      ?_121                                   ; 1102 _ 74, 78
        mov     eax, dword [rbp-6CH]                    ; 1104 _ 8B. 45, 94
        add     dword [rbp-4CH], eax                    ; 1107 _ 01. 45, B4
        jmp     ?_121                                   ; 110A _ EB, 70

?_116:  cmp     byte [rbp-53H], 0                       ; 110C _ 80. 7D, AD, 00
        jz      ?_121                                   ; 1110 _ 74, 6A
        mov     eax, dword [rbp-6CH]                    ; 1112 _ 8B. 45, 94
        sub     dword [rbp-4CH], eax                    ; 1115 _ 29. 45, B4
        jmp     ?_121                                   ; 1118 _ EB, 62

?_117:  cmp     byte [rbp-51H], 112                     ; 111A _ 80. 7D, AF, 70
        jz      ?_118                                   ; 111E _ 74, 06
        cmp     byte [rbp-51H], 80                      ; 1120 _ 80. 7D, AF, 50
        jnz     ?_120                                   ; 1124 _ 75, 2F
?_118:  mov     rax, qword [rbp-68H]                    ; 1126 _ 48: 8B. 45, 98
        mov     esi, 20000                              ; 112A _ BE, 00004E20
        mov     rdi, rax                                ; 112F _ 48: 89. C7
        call    read_exponent                           ; 1132 _ E8, FFFFF150
        mov     dword [rbp-40H], eax                    ; 1137 _ 89. 45, C0
        cmp     dword [rbp-40H], 2147483647             ; 113A _ 81. 7D, C0, 7FFFFFFF
        jnz     ?_119                                   ; 1141 _ 75, 0A
        mov     eax, 0                                  ; 1143 _ B8, 00000000
        jmp     ?_125                                   ; 1148 _ E9, 0000009E

?_119:  mov     eax, dword [rbp-40H]                    ; 114D _ 8B. 45, C0
        add     dword [rbp-4CH], eax                    ; 1150 _ 01. 45, B4
        jmp     ?_122                                   ; 1153 _ EB, 43

?_120:  cmp     byte [rbp-51H], 95                      ; 1155 _ 80. 7D, AF, 5F
        jz      ?_121                                   ; 1159 _ 74, 21
        movzx   eax, byte [rbp-51H]                     ; 115B _ 0F B6. 45, AF
        lea     rdx, [rel ?_209]                        ; 115F _ 48: 8D. 15, 00000000(rel)
        mov     esi, eax                                ; 1166 _ 89. C6
        mov     rdi, rdx                                ; 1168 _ 48: 89. D7
        mov     eax, 0                                  ; 116B _ B8, 00000000
        call    nasm_nonfatal                           ; 1170 _ E8, 00000000(PLT r)
        mov     eax, 0                                  ; 1175 _ B8, 00000000
        jmp     ?_125                                   ; 117A _ EB, 6F

?_121:  mov     rax, qword [rbp-68H]                    ; 117C _ 48: 8B. 45, 98
        lea     rdx, [rax+1H]                           ; 1180 _ 48: 8D. 50, 01
        mov     qword [rbp-68H], rdx                    ; 1184 _ 48: 89. 55, 98
        movzx   eax, byte [rax]                         ; 1188 _ 0F B6. 00
        mov     byte [rbp-51H], al                      ; 118B _ 88. 45, AF
        cmp     byte [rbp-51H], 0                       ; 118E _ 80. 7D, AF, 00
        jne     ?_110                                   ; 1192 _ 0F 85, FFFFFE53
?_122:  movzx   eax, byte [rbp-52H]                     ; 1198 _ 0F B6. 45, AE
        xor     eax, 01H                                ; 119C _ 83. F0, 01
        test    al, al                                  ; 119F _ 84. C0
        jz      ?_123                                   ; 11A1 _ 74, 22
        mov     rax, qword [rbp-78H]                    ; 11A3 _ 48: 8B. 45, 88
        mov     edx, 24                                 ; 11A7 _ BA, 00000018
        mov     esi, 0                                  ; 11AC _ BE, 00000000
        mov     rdi, rax                                ; 11B1 _ 48: 89. C7
        call    memset                                  ; 11B4 _ E8, 00000000(PLT r)
        mov     rax, qword [rbp-80H]                    ; 11B9 _ 48: 8B. 45, 80
        mov     dword [rax], 0                          ; 11BD _ C7. 00, 00000000
        jmp     ?_124                                   ; 11C3 _ EB, 21

?_123:  lea     rcx, [rbp-30H]                          ; 11C5 _ 48: 8D. 4D, D0
        mov     rax, qword [rbp-78H]                    ; 11C9 _ 48: 8B. 45, 88
        mov     edx, 24                                 ; 11CD _ BA, 00000018
        mov     rsi, rcx                                ; 11D2 _ 48: 89. CE
        mov     rdi, rax                                ; 11D5 _ 48: 89. C7
        call    memcpy                                  ; 11D8 _ E8, 00000000(PLT r)
        mov     rax, qword [rbp-80H]                    ; 11DD _ 48: 8B. 45, 80
        mov     edx, dword [rbp-4CH]                    ; 11E1 _ 8B. 55, B4
        mov     dword [rax], edx                        ; 11E4 _ 89. 10
?_124:  mov     eax, 1                                  ; 11E6 _ B8, 00000001
?_125:  mov     rdx, qword [rbp-8H]                     ; 11EB _ 48: 8B. 55, F8
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        sub     rdx, qword [fs:abs 28H]                 ; 11EF _ 64 48: 2B. 14 25, 00000028
        jz      ?_126                                   ; 11F8 _ 74, 05
        call    __stack_chk_fail                        ; 11FA _ E8, 00000000(PLT r)
?_126:  leave                                           ; 11FF _ C9
        ret                                             ; 1200 _ C3

ieee_shr:; Local function
        push    rbp                                     ; 1201 _ 55
        mov     rbp, rsp                                ; 1202 _ 48: 89. E5
        mov     qword [rbp-28H], rdi                    ; 1205 _ 48: 89. 7D, D8
        mov     dword [rbp-2CH], esi                    ; 1209 _ 89. 75, D4
        mov     dword [rbp-14H], 0                      ; 120C _ C7. 45, EC, 00000000
        mov     edx, dword [rbp-2CH]                    ; 1213 _ 8B. 55, D4
        mov     eax, edx                                ; 1216 _ 89. D0
        sar     eax, 31                                 ; 1218 _ C1. F8, 1F
        shr     eax, 27                                 ; 121B _ C1. E8, 1B
        add     edx, eax                                ; 121E _ 01. C2
        and     edx, 1FH                                ; 1220 _ 83. E2, 1F
        sub     edx, eax                                ; 1223 _ 29. C2
        mov     dword [rbp-10H], edx                    ; 1225 _ 89. 55, F0
        mov     eax, 32                                 ; 1228 _ B8, 00000020
        sub     eax, dword [rbp-10H]                    ; 122D _ 2B. 45, F0
        mov     dword [rbp-0CH], eax                    ; 1230 _ 89. 45, F4
        mov     eax, dword [rbp-2CH]                    ; 1233 _ 8B. 45, D4
        lea     edx, [rax+1FH]                          ; 1236 _ 8D. 50, 1F
        test    eax, eax                                ; 1239 _ 85. C0
        cmovs   eax, edx                                ; 123B _ 0F 48. C2
        sar     eax, 5                                  ; 123E _ C1. F8, 05
        mov     dword [rbp-8H], eax                     ; 1241 _ 89. 45, F8
        cmp     dword [rbp-10H], 0                      ; 1244 _ 83. 7D, F0, 00
        jnz     ?_129                                   ; 1248 _ 75, 54
        cmp     dword [rbp-8H], 0                       ; 124A _ 83. 7D, F8, 00
        je      ?_135                                   ; 124E _ 0F 84, 0000012A
        mov     dword [rbp-14H], 5                      ; 1254 _ C7. 45, EC, 00000005
        jmp     ?_128                                   ; 125B _ EB, 34

?_127:  mov     eax, dword [rbp-14H]                    ; 125D _ 8B. 45, EC
        sub     eax, dword [rbp-8H]                     ; 1260 _ 2B. 45, F8
        cdqe                                            ; 1263 _ 48: 98
        lea     rdx, [rax*4]                            ; 1265 _ 48: 8D. 14 85, 00000000
        mov     rax, qword [rbp-28H]                    ; 126D _ 48: 8B. 45, D8
        add     rax, rdx                                ; 1271 _ 48: 01. D0
        mov     edx, dword [rbp-14H]                    ; 1274 _ 8B. 55, EC
        movsxd  rdx, edx                                ; 1277 _ 48: 63. D2
        lea     rcx, [rdx*4]                            ; 127A _ 48: 8D. 0C 95, 00000000
        mov     rdx, qword [rbp-28H]                    ; 1282 _ 48: 8B. 55, D8
        add     rdx, rcx                                ; 1286 _ 48: 01. CA
        mov     eax, dword [rax]                        ; 1289 _ 8B. 00
        mov     dword [rdx], eax                        ; 128B _ 89. 02
        sub     dword [rbp-14H], 1                      ; 128D _ 83. 6D, EC, 01
?_128:  mov     eax, dword [rbp-14H]                    ; 1291 _ 8B. 45, EC
        cmp     eax, dword [rbp-8H]                     ; 1294 _ 3B. 45, F8
        jge     ?_127                                   ; 1297 _ 7D, C4
        jmp     ?_133                                   ; 1299 _ E9, 000000BE

?_129:  cmp     dword [rbp-8H], 5                       ; 129E _ 83. 7D, F8, 05
        jle     ?_130                                   ; 12A2 _ 7E, 0C
        mov     dword [rbp-14H], 5                      ; 12A4 _ C7. 45, EC, 00000005
        jmp     ?_135                                   ; 12AB _ E9, 000000CE

?_130:  mov     eax, 5                                  ; 12B0 _ B8, 00000005
        sub     eax, dword [rbp-8H]                     ; 12B5 _ 2B. 45, F8
        cdqe                                            ; 12B8 _ 48: 98
        lea     rdx, [rax*4]                            ; 12BA _ 48: 8D. 14 85, 00000000
        mov     rax, qword [rbp-28H]                    ; 12C2 _ 48: 8B. 45, D8
        add     rax, rdx                                ; 12C6 _ 48: 01. D0
        mov     edx, dword [rax]                        ; 12C9 _ 8B. 10
        mov     eax, dword [rbp-10H]                    ; 12CB _ 8B. 45, F0
        mov     ecx, eax                                ; 12CE _ 89. C1
        shr     edx, cl                                 ; 12D0 _ D3. EA
        mov     eax, edx                                ; 12D2 _ 89. D0
        mov     dword [rbp-18H], eax                    ; 12D4 _ 89. 45, E8
        mov     dword [rbp-14H], 5                      ; 12D7 _ C7. 45, EC, 00000005
        jmp     ?_132                                   ; 12DE _ EB, 55

?_131:  mov     eax, dword [rbp-14H]                    ; 12E0 _ 8B. 45, EC
        sub     eax, dword [rbp-8H]                     ; 12E3 _ 2B. 45, F8
        cdqe                                            ; 12E6 _ 48: 98
        shl     rax, 2                                  ; 12E8 _ 48: C1. E0, 02
        lea     rdx, [rax-4H]                           ; 12EC _ 48: 8D. 50, FC
        mov     rax, qword [rbp-28H]                    ; 12F0 _ 48: 8B. 45, D8
        add     rax, rdx                                ; 12F4 _ 48: 01. D0
        mov     eax, dword [rax]                        ; 12F7 _ 8B. 00
        mov     dword [rbp-4H], eax                     ; 12F9 _ 89. 45, FC
        mov     eax, dword [rbp-0CH]                    ; 12FC _ 8B. 45, F4
        mov     edx, dword [rbp-4H]                     ; 12FF _ 8B. 55, FC
        mov     ecx, eax                                ; 1302 _ 89. C1
        shl     edx, cl                                 ; 1304 _ D3. E2
        mov     eax, edx                                ; 1306 _ 89. D0
        mov     edx, dword [rbp-14H]                    ; 1308 _ 8B. 55, EC
        movsxd  rdx, edx                                ; 130B _ 48: 63. D2
        lea     rcx, [rdx*4]                            ; 130E _ 48: 8D. 0C 95, 00000000
        mov     rdx, qword [rbp-28H]                    ; 1316 _ 48: 8B. 55, D8
        add     rdx, rcx                                ; 131A _ 48: 01. CA
        or      eax, dword [rbp-18H]                    ; 131D _ 0B. 45, E8
        mov     dword [rdx], eax                        ; 1320 _ 89. 02
        mov     eax, dword [rbp-10H]                    ; 1322 _ 8B. 45, F0
        mov     edx, dword [rbp-4H]                     ; 1325 _ 8B. 55, FC
        mov     ecx, eax                                ; 1328 _ 89. C1
        shr     edx, cl                                 ; 132A _ D3. EA
        mov     eax, edx                                ; 132C _ 89. D0
        mov     dword [rbp-18H], eax                    ; 132E _ 89. 45, E8
        sub     dword [rbp-14H], 1                      ; 1331 _ 83. 6D, EC, 01
?_132:  mov     eax, dword [rbp-14H]                    ; 1335 _ 8B. 45, EC
        cmp     eax, dword [rbp-8H]                     ; 1338 _ 3B. 45, F8
        jg      ?_131                                   ; 133B _ 7F, A3
        mov     eax, dword [rbp-14H]                    ; 133D _ 8B. 45, EC
        lea     edx, [rax-1H]                           ; 1340 _ 8D. 50, FF
        mov     dword [rbp-14H], edx                    ; 1343 _ 89. 55, EC
        cdqe                                            ; 1346 _ 48: 98
        lea     rdx, [rax*4]                            ; 1348 _ 48: 8D. 14 85, 00000000
        mov     rax, qword [rbp-28H]                    ; 1350 _ 48: 8B. 45, D8
        add     rdx, rax                                ; 1354 _ 48: 01. C2
        mov     eax, dword [rbp-18H]                    ; 1357 _ 8B. 45, E8
        mov     dword [rdx], eax                        ; 135A _ 89. 02
?_133:  jmp     ?_135                                   ; 135C _ EB, 20

?_134:  mov     eax, dword [rbp-14H]                    ; 135E _ 8B. 45, EC
        lea     edx, [rax-1H]                           ; 1361 _ 8D. 50, FF
        mov     dword [rbp-14H], edx                    ; 1364 _ 89. 55, EC
        cdqe                                            ; 1367 _ 48: 98
        lea     rdx, [rax*4]                            ; 1369 _ 48: 8D. 14 85, 00000000
        mov     rax, qword [rbp-28H]                    ; 1371 _ 48: 8B. 45, D8
        add     rax, rdx                                ; 1375 _ 48: 01. D0
        mov     dword [rax], 0                          ; 1378 _ C7. 00, 00000000
?_135:  cmp     dword [rbp-14H], 0                      ; 137E _ 83. 7D, EC, 00
        jns     ?_134                                   ; 1382 _ 79, DA
        nop                                             ; 1384 _ 90
        nop                                             ; 1385 _ 90
        pop     rbp                                     ; 1386 _ 5D
        ret                                             ; 1387 _ C3

to_packed_bcd:; Local function
        push    rbp                                     ; 1388 _ 55
        mov     rbp, rsp                                ; 1389 _ 48: 89. E5
        sub     rsp, 64                                 ; 138C _ 48: 83. EC, 40
        mov     qword [rbp-18H], rdi                    ; 1390 _ 48: 89. 7D, E8
        mov     qword [rbp-20H], rsi                    ; 1394 _ 48: 89. 75, E0
        mov     dword [rbp-24H], edx                    ; 1398 _ 89. 55, DC
        mov     qword [rbp-30H], rcx                    ; 139B _ 48: 89. 4D, D0
        mov     qword [rbp-38H], r8                     ; 139F _ 4C: 89. 45, C8
        mov     dword [rbp-0CH], 0                      ; 13A3 _ C7. 45, F4, 00000000
        mov     dword [rbp-8H], -1                      ; 13AA _ C7. 45, F8, FFFFFFFF
        mov     rax, qword [rbp-38H]                    ; 13B1 _ 48: 8B. 45, C8
        mov     eax, dword [rax]                        ; 13B5 _ 8B. 00
        cmp     eax, 10                                 ; 13B7 _ 83. F8, 0A
        je      ?_141                                   ; 13BA _ 0F 84, 000000E6
        lea     rax, [rel ?_210]                        ; 13C0 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 13C7 _ 48: 89. C7
        mov     eax, 0                                  ; 13CA _ B8, 00000000
        call    nasm_nonfatal                           ; 13CF _ E8, 00000000(PLT r)
        mov     eax, 0                                  ; 13D4 _ B8, 00000000
        jmp     ?_145                                   ; 13D9 _ E9, 00000128

?_136:  mov     rax, qword [rbp-20H]                    ; 13DE _ 48: 8B. 45, E0
        lea     rdx, [rax-1H]                           ; 13E2 _ 48: 8D. 50, FF
        mov     qword [rbp-20H], rdx                    ; 13E6 _ 48: 89. 55, E0
        movzx   eax, byte [rax]                         ; 13EA _ 0F B6. 00
        mov     byte [rbp-0DH], al                      ; 13ED _ 88. 45, F3
        cmp     byte [rbp-0DH], 47                      ; 13F0 _ 80. 7D, F3, 2F
        jle     ?_140                                   ; 13F4 _ 0F 8E, 00000085
        cmp     byte [rbp-0DH], 57                      ; 13FA _ 80. 7D, F3, 39
        jg      ?_140                                   ; 13FE _ 7F, 7F
        cmp     dword [rbp-8H], 0                       ; 1400 _ 83. 7D, F8, 00
        jns     ?_138                                   ; 1404 _ 79, 44
        cmp     dword [rbp-0CH], 9                      ; 1406 _ 83. 7D, F4, 09
        jnz     ?_137                                   ; 140A _ 75, 32
        mov     dword [rbp-4H], 4456704                 ; 140C _ C7. 45, FC, 00440100
        mov     eax, dword [rbp-4H]                     ; 1413 _ 8B. 45, FC
        mov     edi, eax                                ; 1416 _ 89. C7
        call    warn_active                             ; 1418 _ E8, FFFFEC14
        movzx   eax, al                                 ; 141D _ 0F B6. C0
        test    rax, rax                                ; 1420 _ 48: 85. C0
        jz      ?_137                                   ; 1423 _ 74, 19
        lea     rdx, [rel ?_211]                        ; 1425 _ 48: 8D. 15, 00000000(rel)
        mov     eax, dword [rbp-4H]                     ; 142C _ 8B. 45, FC
        mov     rsi, rdx                                ; 142F _ 48: 89. D6
        mov     edi, eax                                ; 1432 _ 89. C7
        mov     eax, 0                                  ; 1434 _ B8, 00000000
        call    nasm_warn_                              ; 1439 _ E8, 00000000(PLT r)
?_137:  movsx   eax, byte [rbp-0DH]                     ; 143E _ 0F BE. 45, F3
        sub     eax, 48                                 ; 1442 _ 83. E8, 30
        mov     dword [rbp-8H], eax                     ; 1445 _ 89. 45, F8
        jmp     ?_141                                   ; 1448 _ EB, 5C

?_138:  cmp     dword [rbp-0CH], 8                      ; 144A _ 83. 7D, F4, 08
        jg      ?_139                                   ; 144E _ 7F, 22
        movzx   eax, byte [rbp-0DH]                     ; 1450 _ 0F B6. 45, F3
        sub     eax, 48                                 ; 1454 _ 83. E8, 30
        shl     eax, 4                                  ; 1457 _ C1. E0, 04
        mov     ecx, eax                                ; 145A _ 89. C1
        mov     eax, dword [rbp-8H]                     ; 145C _ 8B. 45, F8
        mov     esi, eax                                ; 145F _ 89. C6
        mov     rax, qword [rbp-30H]                    ; 1461 _ 48: 8B. 45, D0
        lea     rdx, [rax+1H]                           ; 1465 _ 48: 8D. 50, 01
        mov     qword [rbp-30H], rdx                    ; 1469 _ 48: 89. 55, D0
        lea     edx, [rcx+rsi]                          ; 146D _ 8D. 14 31
        mov     byte [rax], dl                          ; 1470 _ 88. 10
?_139:  add     dword [rbp-0CH], 1                      ; 1472 _ 83. 45, F4, 01
        mov     dword [rbp-8H], -1                      ; 1476 _ C7. 45, F8, FFFFFFFF
        jmp     ?_141                                   ; 147D _ EB, 27

?_140:  cmp     byte [rbp-0DH], 95                      ; 147F _ 80. 7D, F3, 5F
        jz      ?_141                                   ; 1483 _ 74, 21
        movsx   eax, byte [rbp-0DH]                     ; 1485 _ 0F BE. 45, F3
        lea     rdx, [rel ?_212]                        ; 1489 _ 48: 8D. 15, 00000000(rel)
        mov     esi, eax                                ; 1490 _ 89. C6
        mov     rdi, rdx                                ; 1492 _ 48: 89. D7
        mov     eax, 0                                  ; 1495 _ B8, 00000000
        call    nasm_nonfatal                           ; 149A _ E8, 00000000(PLT r)
        mov     eax, 0                                  ; 149F _ B8, 00000000
        jmp     ?_145                                   ; 14A4 _ EB, 60

?_141:  mov     rax, qword [rbp-20H]                    ; 14A6 _ 48: 8B. 45, E0
        cmp     rax, qword [rbp-18H]                    ; 14AA _ 48: 3B. 45, E8
        jnc     ?_136                                   ; 14AE _ 0F 83, FFFFFF2A
        cmp     dword [rbp-8H], 0                       ; 14B4 _ 83. 7D, F8, 00
        js      ?_144                                   ; 14B8 _ 78, 30
        cmp     dword [rbp-0CH], 8                      ; 14BA _ 83. 7D, F4, 08
        jg      ?_142                                   ; 14BE _ 7F, 11
        mov     rax, qword [rbp-30H]                    ; 14C0 _ 48: 8B. 45, D0
        lea     rdx, [rax+1H]                           ; 14C4 _ 48: 8D. 50, 01
        mov     qword [rbp-30H], rdx                    ; 14C8 _ 48: 89. 55, D0
        mov     edx, dword [rbp-8H]                     ; 14CC _ 8B. 55, F8
        mov     byte [rax], dl                          ; 14CF _ 88. 10
?_142:  add     dword [rbp-0CH], 1                      ; 14D1 _ 83. 45, F4, 01
        jmp     ?_144                                   ; 14D5 _ EB, 13

?_143:  mov     rax, qword [rbp-30H]                    ; 14D7 _ 48: 8B. 45, D0
        lea     rdx, [rax+1H]                           ; 14DB _ 48: 8D. 50, 01
        mov     qword [rbp-30H], rdx                    ; 14DF _ 48: 89. 55, D0
        mov     byte [rax], 0                           ; 14E3 _ C6. 00, 00
        add     dword [rbp-0CH], 1                      ; 14E6 _ 83. 45, F4, 01
?_144:  cmp     dword [rbp-0CH], 8                      ; 14EA _ 83. 7D, F4, 08
        jle     ?_143                                   ; 14EE _ 7E, E7
        mov     eax, dword [rbp-24H]                    ; 14F0 _ 8B. 45, DC
        sar     eax, 24                                 ; 14F3 _ C1. F8, 18
        and     eax, 0FFFFFF80H                         ; 14F6 _ 83. E0, 80
        mov     edx, eax                                ; 14F9 _ 89. C2
        mov     rax, qword [rbp-30H]                    ; 14FB _ 48: 8B. 45, D0
        mov     byte [rax], dl                          ; 14FF _ 88. 10
        mov     eax, 1                                  ; 1501 _ B8, 00000001
?_145:  leave                                           ; 1506 _ C9
        ret                                             ; 1507 _ C3

float_const:; Function begin
        push    rbp                                     ; 1508 _ 55
        mov     rbp, rsp                                ; 1509 _ 48: 89. E5
        sub     rsp, 144                                ; 150C _ 48: 81. EC, 00000090
        mov     qword [rbp-78H], rdi                    ; 1513 _ 48: 89. 7D, 88
        mov     dword [rbp-7CH], esi                    ; 1517 _ 89. 75, 84
        mov     qword [rbp-88H], rdx                    ; 151A _ 48: 89. 95, FFFFFF78
        mov     dword [rbp-80H], ecx                    ; 1521 _ 89. 4D, 80
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        mov     rax, qword [fs:abs 28H]                 ; 1524 _ 64 48: 8B. 04 25, 00000028
        mov     qword [rbp-8H], rax                     ; 152D _ 48: 89. 45, F8
        xor     eax, eax                                ; 1531 _ 31. C0
        mov     edx, dword [rbp-80H]                    ; 1533 _ 8B. 55, 80
        mov     rax, rdx                                ; 1536 _ 48: 89. D0
        shl     rax, 2                                  ; 1539 _ 48: C1. E0, 02
        add     rax, rdx                                ; 153D _ 48: 01. D0
        shl     rax, 2                                  ; 1540 _ 48: C1. E0, 02
        lea     rdx, [rel fp_formats]                   ; 1544 _ 48: 8D. 15, 00000000(rel)
        add     rax, rdx                                ; 154B _ 48: 01. D0
        mov     qword [rbp-30H], rax                    ; 154E _ 48: 89. 45, D0
        mov     dword [rbp-60H], 0                      ; 1552 _ C7. 45, A0, 00000000
        mov     rax, qword [rbp-30H]                    ; 1559 _ 48: 8B. 45, D0
        mov     eax, dword [rax+0CH]                    ; 155D _ 8B. 40, 0C
        sub     eax, 1                                  ; 1560 _ 83. E8, 01
        mov     edx, 1                                  ; 1563 _ BA, 00000001
        mov     ecx, eax                                ; 1568 _ 89. C1
        shl     edx, cl                                 ; 156A _ D3. E2
        mov     eax, edx                                ; 156C _ 89. D0
        mov     dword [rbp-54H], eax                    ; 156E _ 89. 45, AC
        mov     rax, qword [rbp-30H]                    ; 1571 _ 48: 8B. 45, D0
        mov     edx, dword [rax+0CH]                    ; 1575 _ 8B. 50, 0C
        mov     rax, qword [rbp-30H]                    ; 1578 _ 48: 8B. 45, D0
        mov     eax, dword [rax+8H]                     ; 157C _ 8B. 40, 08
        add     eax, edx                                ; 157F _ 01. D0
        and     eax, 1FH                                ; 1581 _ 83. E0, 1F
        mov     edx, 2147483648                         ; 1584 _ BA, 80000000
        mov     ecx, eax                                ; 1589 _ 89. C1
        shr     edx, cl                                 ; 158B _ D3. EA
        mov     eax, edx                                ; 158D _ 89. D0
        mov     dword [rbp-50H], eax                    ; 158F _ 89. 45, B0
        mov     rax, qword [rbp-30H]                    ; 1592 _ 48: 8B. 45, D0
        mov     edx, dword [rax+0CH]                    ; 1596 _ 8B. 50, 0C
        mov     rax, qword [rbp-30H]                    ; 1599 _ 48: 8B. 45, D0
        mov     eax, dword [rax+8H]                     ; 159D _ 8B. 40, 08
        add     eax, edx                                ; 15A0 _ 01. D0
        lea     edx, [rax+1FH]                          ; 15A2 _ 8D. 50, 1F
        test    eax, eax                                ; 15A5 _ 85. C0
        cmovs   eax, edx                                ; 15A7 _ 0F 48. C2
        sar     eax, 5                                  ; 15AA _ C1. F8, 05
        mov     dword [rbp-4CH], eax                    ; 15AD _ 89. 45, B4
        mov     eax, dword [rbp-7CH]                    ; 15B0 _ 8B. 45, 84
        shr     eax, 31                                 ; 15B3 _ C1. E8, 1F
        mov     byte [rbp-61H], al                      ; 15B6 _ 88. 45, 9F
        mov     rax, qword [rbp-30H]                    ; 15B9 _ 48: 8B. 45, D0
        mov     eax, dword [rax]                        ; 15BD _ 8B. 00
        shl     eax, 3                                  ; 15BF _ C1. E0, 03
        mov     dword [rbp-48H], eax                    ; 15C2 _ 89. 45, B8
        mov     rax, qword [rbp-78H]                    ; 15C5 _ 48: 8B. 45, 88
        movzx   eax, byte [rax]                         ; 15C9 _ 0F B6. 00
        test    al, al                                  ; 15CC _ 84. C0
        sete    al                                      ; 15CE _ 0F 94. C0
        movzx   eax, al                                 ; 15D1 _ 0F B6. C0
        test    rax, rax                                ; 15D4 _ 48: 85. C0
        jz      ?_146                                   ; 15D7 _ 74, 22
        lea     rdx, [rel ?_213]                        ; 15D9 _ 48: 8D. 15, 00000000(rel)
        lea     rsi, [rel __func__.0]                   ; 15E0 _ 48: 8D. 35, 00000000(rel)
        lea     rax, [rel ?_214]                        ; 15E7 _ 48: 8D. 05, 00000000(rel)
        mov     ecx, 697                                ; 15EE _ B9, 000002B9
        mov     rdi, rax                                ; 15F3 _ 48: 89. C7
        call    nasm_assert_failed                      ; 15F6 _ E8, 00000000(PLT r)
?_146:  mov     rax, qword [rbp-78H]                    ; 15FB _ 48: 8B. 45, 88
        mov     rdi, rax                                ; 15FF _ 48: 89. C7
        call    strlen                                  ; 1602 _ E8, 00000000(PLT r)
        mov     rdx, rax                                ; 1607 _ 48: 89. C2
        mov     rax, qword [rbp-78H]                    ; 160A _ 48: 8B. 45, 88
        add     rax, rdx                                ; 160E _ 48: 01. D0
        mov     qword [rbp-28H], rax                    ; 1611 _ 48: 89. 45, D8
        mov     rax, qword [rbp-28H]                    ; 1615 _ 48: 8B. 45, D8
        sub     rax, 1                                  ; 1619 _ 48: 83. E8, 01
        movzx   eax, byte [rax]                         ; 161D _ 0F B6. 00
        cmp     al, 80                                  ; 1620 _ 3C, 50
        jz      ?_147                                   ; 1622 _ 74, 0F
        mov     rax, qword [rbp-28H]                    ; 1624 _ 48: 8B. 45, D8
        sub     rax, 1                                  ; 1628 _ 48: 83. E8, 01
        movzx   eax, byte [rax]                         ; 162C _ 0F B6. 00
        cmp     al, 112                                 ; 162F _ 3C, 70
        jnz     ?_148                                   ; 1631 _ 75, 2A
?_147:  mov     rax, qword [rbp-28H]                    ; 1633 _ 48: 8B. 45, D8
        lea     rsi, [rax-2H]                           ; 1637 _ 48: 8D. 70, FE
        mov     rdi, qword [rbp-30H]                    ; 163B _ 48: 8B. 7D, D0
        mov     rcx, qword [rbp-88H]                    ; 163F _ 48: 8B. 8D, FFFFFF78
        mov     edx, dword [rbp-7CH]                    ; 1646 _ 8B. 55, 84
        mov     rax, qword [rbp-78H]                    ; 1649 _ 48: 8B. 45, 88
        mov     r8, rdi                                 ; 164D _ 49: 89. F8
        mov     rdi, rax                                ; 1650 _ 48: 89. C7
        call    to_packed_bcd                           ; 1653 _ E8, FFFFFD30
        jmp     ?_190                                   ; 1658 _ E9, 0000079E

?_148:  mov     rax, qword [rbp-78H]                    ; 165D _ 48: 8B. 45, 88
        movzx   eax, byte [rax]                         ; 1661 _ 0F B6. 00
        cmp     al, 95                                  ; 1664 _ 3C, 5F
        jne     ?_153                                   ; 1666 _ 0F 85, 0000009F
        mov     rax, qword [rbp-78H]                    ; 166C _ 48: 8B. 45, 88
        add     rax, 3                                  ; 1670 _ 48: 83. C0, 03
        movzx   eax, byte [rax]                         ; 1674 _ 0F B6. 00
        movsx   eax, al                                 ; 1677 _ 0F BE. C0
        cmp     eax, 115                                ; 167A _ 83. F8, 73
        jz      ?_150                                   ; 167D _ 74, 4D
        cmp     eax, 115                                ; 167F _ 83. F8, 73
        jg      ?_152                                   ; 1682 _ 7F, 60
        cmp     eax, 113                                ; 1684 _ 83. F8, 71
        jz      ?_149                                   ; 1687 _ 74, 37
        cmp     eax, 113                                ; 1689 _ 83. F8, 71
        jg      ?_152                                   ; 168C _ 7F, 56
        cmp     eax, 110                                ; 168E _ 83. F8, 6E
        jz      ?_149                                   ; 1691 _ 74, 2D
        cmp     eax, 110                                ; 1693 _ 83. F8, 6E
        jg      ?_152                                   ; 1696 _ 7F, 4C
        cmp     eax, 105                                ; 1698 _ 83. F8, 69
        jz      ?_151                                   ; 169B _ 74, 3B
        cmp     eax, 105                                ; 169D _ 83. F8, 69
        jg      ?_152                                   ; 16A0 _ 7F, 42
        cmp     eax, 83                                 ; 16A2 _ 83. F8, 53
        jz      ?_150                                   ; 16A5 _ 74, 25
        cmp     eax, 83                                 ; 16A7 _ 83. F8, 53
        jg      ?_152                                   ; 16AA _ 7F, 38
        cmp     eax, 81                                 ; 16AC _ 83. F8, 51
        jz      ?_149                                   ; 16AF _ 74, 0F
        cmp     eax, 81                                 ; 16B1 _ 83. F8, 51
        jg      ?_152                                   ; 16B4 _ 7F, 2E
        cmp     eax, 73                                 ; 16B6 _ 83. F8, 49
        jz      ?_151                                   ; 16B9 _ 74, 1D
        cmp     eax, 78                                 ; 16BB _ 83. F8, 4E
        jnz     ?_152                                   ; 16BE _ 75, 24
?_149:  mov     dword [rbp-58H], 4                      ; 16C0 _ C7. 45, A8, 00000004
        jmp     ?_168                                   ; 16C7 _ E9, 00000347

?_150:  mov     dword [rbp-58H], 5                      ; 16CC _ C7. 45, A8, 00000005
        jmp     ?_168                                   ; 16D3 _ E9, 0000033B

?_151:  mov     dword [rbp-58H], 3                      ; 16D8 _ C7. 45, A8, 00000003
        jmp     ?_168                                   ; 16DF _ E9, 0000032F

?_152:  mov     rax, qword [rbp-78H]                    ; 16E4 _ 48: 8B. 45, 88
        lea     rdx, [rel ?_215]                        ; 16E8 _ 48: 8D. 15, 00000000(rel)
        mov     rsi, rax                                ; 16EF _ 48: 89. C6
        mov     rdi, rdx                                ; 16F2 _ 48: 89. D7
        mov     eax, 0                                  ; 16F5 _ B8, 00000000
        call    nasm_nonfatal                           ; 16FA _ E8, 00000000(PLT r)
        mov     dword [rbp-58H], 4                      ; 16FF _ C7. 45, A8, 00000004
        jmp     ?_168                                   ; 1706 _ E9, 00000308

?_153:  mov     rax, qword [rbp-78H]                    ; 170B _ 48: 8B. 45, 88
        movzx   eax, byte [rax]                         ; 170F _ 0F B6. 00
        cmp     al, 48                                  ; 1712 _ 3C, 30
        jne     ?_160                                   ; 1714 _ 0F 85, 00000214
        mov     rax, qword [rbp-78H]                    ; 171A _ 48: 8B. 45, 88
        add     rax, 1                                  ; 171E _ 48: 83. C0, 01
        movzx   eax, byte [rax]                         ; 1722 _ 0F B6. 00
        movsx   eax, al                                 ; 1725 _ 0F BE. C0
        cmp     eax, 121                                ; 1728 _ 83. F8, 79
        je      ?_156                                   ; 172B _ 0F 84, 00000166
        cmp     eax, 121                                ; 1731 _ 83. F8, 79
        jg      ?_159                                   ; 1734 _ 0F 8F, 000001D8
        cmp     eax, 120                                ; 173A _ 83. F8, 78
        je      ?_154                                   ; 173D _ 0F 84, 00000104
        cmp     eax, 120                                ; 1743 _ 83. F8, 78
        jg      ?_159                                   ; 1746 _ 0F 8F, 000001C6
        cmp     eax, 116                                ; 174C _ 83. F8, 74
        je      ?_157                                   ; 174F _ 0F 84, 0000016A
        cmp     eax, 116                                ; 1755 _ 83. F8, 74
        jg      ?_159                                   ; 1758 _ 0F 8F, 000001B4
        cmp     eax, 113                                ; 175E _ 83. F8, 71
        je      ?_155                                   ; 1761 _ 0F 84, 00000108
        cmp     eax, 113                                ; 1767 _ 83. F8, 71
        jg      ?_159                                   ; 176A _ 0F 8F, 000001A2
        cmp     eax, 112                                ; 1770 _ 83. F8, 70
        je      ?_158                                   ; 1773 _ 0F 84, 00000169
        cmp     eax, 112                                ; 1779 _ 83. F8, 70
        jg      ?_159                                   ; 177C _ 0F 8F, 00000190
        cmp     eax, 111                                ; 1782 _ 83. F8, 6F
        je      ?_155                                   ; 1785 _ 0F 84, 000000E4
        cmp     eax, 111                                ; 178B _ 83. F8, 6F
        jg      ?_159                                   ; 178E _ 0F 8F, 0000017E
        cmp     eax, 104                                ; 1794 _ 83. F8, 68
        je      ?_154                                   ; 1797 _ 0F 84, 000000AA
        cmp     eax, 104                                ; 179D _ 83. F8, 68
        jg      ?_159                                   ; 17A0 _ 0F 8F, 0000016C
        cmp     eax, 100                                ; 17A6 _ 83. F8, 64
        je      ?_157                                   ; 17A9 _ 0F 84, 00000110
        cmp     eax, 100                                ; 17AF _ 83. F8, 64
        jg      ?_159                                   ; 17B2 _ 0F 8F, 0000015A
        cmp     eax, 98                                 ; 17B8 _ 83. F8, 62
        je      ?_156                                   ; 17BB _ 0F 84, 000000D6
        cmp     eax, 98                                 ; 17C1 _ 83. F8, 62
        jg      ?_159                                   ; 17C4 _ 0F 8F, 00000148
        cmp     eax, 89                                 ; 17CA _ 83. F8, 59
        je      ?_156                                   ; 17CD _ 0F 84, 000000C4
        cmp     eax, 89                                 ; 17D3 _ 83. F8, 59
        jg      ?_159                                   ; 17D6 _ 0F 8F, 00000136
        cmp     eax, 88                                 ; 17DC _ 83. F8, 58
        jz      ?_154                                   ; 17DF _ 74, 66
        cmp     eax, 88                                 ; 17E1 _ 83. F8, 58
        jg      ?_159                                   ; 17E4 _ 0F 8F, 00000128
        cmp     eax, 84                                 ; 17EA _ 83. F8, 54
        je      ?_157                                   ; 17ED _ 0F 84, 000000CC
        cmp     eax, 84                                 ; 17F3 _ 83. F8, 54
        jg      ?_159                                   ; 17F6 _ 0F 8F, 00000116
        cmp     eax, 81                                 ; 17FC _ 83. F8, 51
        jz      ?_155                                   ; 17FF _ 74, 6E
        cmp     eax, 81                                 ; 1801 _ 83. F8, 51
        jg      ?_159                                   ; 1804 _ 0F 8F, 00000108
        cmp     eax, 80                                 ; 180A _ 83. F8, 50
        je      ?_158                                   ; 180D _ 0F 84, 000000CF
        cmp     eax, 80                                 ; 1813 _ 83. F8, 50
        jg      ?_159                                   ; 1816 _ 0F 8F, 000000F6
        cmp     eax, 79                                 ; 181C _ 83. F8, 4F
        jz      ?_155                                   ; 181F _ 74, 4E
        cmp     eax, 79                                 ; 1821 _ 83. F8, 4F
        jg      ?_159                                   ; 1824 _ 0F 8F, 000000E8
        cmp     eax, 72                                 ; 182A _ 83. F8, 48
        jz      ?_154                                   ; 182D _ 74, 18
        cmp     eax, 72                                 ; 182F _ 83. F8, 48
        jg      ?_159                                   ; 1832 _ 0F 8F, 000000DA
        cmp     eax, 66                                 ; 1838 _ 83. F8, 42
        jz      ?_156                                   ; 183B _ 74, 5A
        cmp     eax, 68                                 ; 183D _ 83. F8, 44
        jz      ?_157                                   ; 1840 _ 74, 7D
        jmp     ?_159                                   ; 1842 _ E9, 000000CB

?_154:  mov     rax, qword [rbp-78H]                    ; 1847 _ 48: 8B. 45, 88
        lea     rdi, [rax+2H]                           ; 184B _ 48: 8D. 78, 02
        lea     rdx, [rbp-60H]                          ; 184F _ 48: 8D. 55, A0
        lea     rax, [rbp-20H]                          ; 1853 _ 48: 8D. 45, E0
        mov     rcx, rdx                                ; 1857 _ 48: 89. D1
        mov     rdx, rax                                ; 185A _ 48: 89. C2
        mov     esi, 4                                  ; 185D _ BE, 00000004
        call    ieee_flconvert_bin                      ; 1862 _ E8, FFFFF711
        mov     byte [rbp-62H], al                      ; 1867 _ 88. 45, 9E
        jmp     ?_162                                   ; 186A _ E9, 00000109

?_155:  mov     rax, qword [rbp-78H]                    ; 186F _ 48: 8B. 45, 88
        lea     rdi, [rax+2H]                           ; 1873 _ 48: 8D. 78, 02
        lea     rdx, [rbp-60H]                          ; 1877 _ 48: 8D. 55, A0
        lea     rax, [rbp-20H]                          ; 187B _ 48: 8D. 45, E0
        mov     rcx, rdx                                ; 187F _ 48: 89. D1
        mov     rdx, rax                                ; 1882 _ 48: 89. C2
        mov     esi, 3                                  ; 1885 _ BE, 00000003
        call    ieee_flconvert_bin                      ; 188A _ E8, FFFFF6E9
        mov     byte [rbp-62H], al                      ; 188F _ 88. 45, 9E
        jmp     ?_162                                   ; 1892 _ E9, 000000E1

?_156:  mov     rax, qword [rbp-78H]                    ; 1897 _ 48: 8B. 45, 88
        lea     rdi, [rax+2H]                           ; 189B _ 48: 8D. 78, 02
        lea     rdx, [rbp-60H]                          ; 189F _ 48: 8D. 55, A0
        lea     rax, [rbp-20H]                          ; 18A3 _ 48: 8D. 45, E0
        mov     rcx, rdx                                ; 18A7 _ 48: 89. D1
        mov     rdx, rax                                ; 18AA _ 48: 89. C2
        mov     esi, 1                                  ; 18AD _ BE, 00000001
        call    ieee_flconvert_bin                      ; 18B2 _ E8, FFFFF6C1
        mov     byte [rbp-62H], al                      ; 18B7 _ 88. 45, 9E
        jmp     ?_162                                   ; 18BA _ E9, 000000B9

?_157:  mov     rax, qword [rbp-78H]                    ; 18BF _ 48: 8B. 45, 88
        lea     rcx, [rax+2H]                           ; 18C3 _ 48: 8D. 48, 02
        lea     rdx, [rbp-60H]                          ; 18C7 _ 48: 8D. 55, A0
        lea     rax, [rbp-20H]                          ; 18CB _ 48: 8D. 45, E0
        mov     rsi, rax                                ; 18CF _ 48: 89. C6
        mov     rdi, rcx                                ; 18D2 _ 48: 89. CF
        call    ieee_flconvert                          ; 18D5 _ E8, FFFFEA9E
        mov     byte [rbp-62H], al                      ; 18DA _ 88. 45, 9E
        jmp     ?_162                                   ; 18DD _ E9, 00000096

?_158:  mov     rax, qword [rbp-28H]                    ; 18E2 _ 48: 8B. 45, D8
        lea     rsi, [rax-1H]                           ; 18E6 _ 48: 8D. 70, FF
        mov     rax, qword [rbp-78H]                    ; 18EA _ 48: 8B. 45, 88
        lea     rdi, [rax+2H]                           ; 18EE _ 48: 8D. 78, 02
        mov     rcx, qword [rbp-30H]                    ; 18F2 _ 48: 8B. 4D, D0
        mov     rdx, qword [rbp-88H]                    ; 18F6 _ 48: 8B. 95, FFFFFF78
        mov     eax, dword [rbp-7CH]                    ; 18FD _ 8B. 45, 84
        mov     r8, rcx                                 ; 1900 _ 49: 89. C8
        mov     rcx, rdx                                ; 1903 _ 48: 89. D1
        mov     edx, eax                                ; 1906 _ 89. C2
        call    to_packed_bcd                           ; 1908 _ E8, FFFFFA7B
        jmp     ?_190                                   ; 190D _ E9, 000004E9

?_159:  lea     rdx, [rbp-60H]                          ; 1912 _ 48: 8D. 55, A0
        lea     rcx, [rbp-20H]                          ; 1916 _ 48: 8D. 4D, E0
        mov     rax, qword [rbp-78H]                    ; 191A _ 48: 8B. 45, 88
        mov     rsi, rcx                                ; 191E _ 48: 89. CE
        mov     rdi, rax                                ; 1921 _ 48: 89. C7
        call    ieee_flconvert                          ; 1924 _ E8, FFFFEA4F
        mov     byte [rbp-62H], al                      ; 1929 _ 88. 45, 9E
        jmp     ?_162                                   ; 192C _ EB, 4A

?_160:  mov     rax, qword [rbp-78H]                    ; 192E _ 48: 8B. 45, 88
        movzx   eax, byte [rax]                         ; 1932 _ 0F B6. 00
        cmp     al, 36                                  ; 1935 _ 3C, 24
        jnz     ?_161                                   ; 1937 _ 75, 25
        mov     rax, qword [rbp-78H]                    ; 1939 _ 48: 8B. 45, 88
        lea     rdi, [rax+1H]                           ; 193D _ 48: 8D. 78, 01
        lea     rdx, [rbp-60H]                          ; 1941 _ 48: 8D. 55, A0
        lea     rax, [rbp-20H]                          ; 1945 _ 48: 8D. 45, E0
        mov     rcx, rdx                                ; 1949 _ 48: 89. D1
        mov     rdx, rax                                ; 194C _ 48: 89. C2
        mov     esi, 4                                  ; 194F _ BE, 00000004
        call    ieee_flconvert_bin                      ; 1954 _ E8, FFFFF61F
        mov     byte [rbp-62H], al                      ; 1959 _ 88. 45, 9E
        jmp     ?_162                                   ; 195C _ EB, 1A

?_161:  lea     rdx, [rbp-60H]                          ; 195E _ 48: 8D. 55, A0
        lea     rcx, [rbp-20H]                          ; 1962 _ 48: 8D. 4D, E0
        mov     rax, qword [rbp-78H]                    ; 1966 _ 48: 8B. 45, 88
        mov     rsi, rcx                                ; 196A _ 48: 89. CE
        mov     rdi, rax                                ; 196D _ 48: 89. C7
        call    ieee_flconvert                          ; 1970 _ E8, FFFFEA03
        mov     byte [rbp-62H], al                      ; 1975 _ 88. 45, 9E
?_162:  movzx   eax, byte [rbp-62H]                     ; 1978 _ 0F B6. 45, 9E
        xor     eax, 01H                                ; 197C _ 83. F0, 01
        test    al, al                                  ; 197F _ 84. C0
        jz      ?_163                                   ; 1981 _ 74, 0C
        mov     dword [rbp-58H], 4                      ; 1983 _ C7. 45, A8, 00000004
        jmp     ?_168                                   ; 198A _ E9, 00000084

?_163:  mov     eax, dword [rbp-20H]                    ; 198F _ 8B. 45, E0
        test    eax, eax                                ; 1992 _ 85. C0
        jns     ?_167                                   ; 1994 _ 79, 76
        mov     eax, dword [rbp-60H]                    ; 1996 _ 8B. 45, A0
        sub     eax, 1                                  ; 1999 _ 83. E8, 01
        mov     dword [rbp-60H], eax                    ; 199C _ 89. 45, A0
        mov     eax, 2                                  ; 199F _ B8, 00000002
        sub     eax, dword [rbp-54H]                    ; 19A4 _ 2B. 45, AC
        mov     edx, eax                                ; 19A7 _ 89. C2
        mov     eax, dword [rbp-60H]                    ; 19A9 _ 8B. 45, A0
        cmp     edx, eax                                ; 19AC _ 39. C2
        jg      ?_164                                   ; 19AE _ 7F, 11
        mov     eax, dword [rbp-60H]                    ; 19B0 _ 8B. 45, A0
        cmp     dword [rbp-54H], eax                    ; 19B3 _ 39. 45, AC
        jl      ?_164                                   ; 19B6 _ 7C, 09
        mov     dword [rbp-58H], 2                      ; 19B8 _ C7. 45, A8, 00000002
        jmp     ?_168                                   ; 19BF _ EB, 52

?_164:  mov     eax, dword [rbp-60H]                    ; 19C1 _ 8B. 45, A0
        test    eax, eax                                ; 19C4 _ 85. C0
        jle     ?_166                                   ; 19C6 _ 7E, 3B
        mov     dword [rbp-44H], 393472                 ; 19C8 _ C7. 45, BC, 00060100
        mov     eax, dword [rbp-44H]                    ; 19CF _ 8B. 45, BC
        mov     edi, eax                                ; 19D2 _ 89. C7
        call    warn_active                             ; 19D4 _ E8, FFFFE658
        movzx   eax, al                                 ; 19D9 _ 0F B6. C0
        test    rax, rax                                ; 19DC _ 48: 85. C0
        jz      ?_165                                   ; 19DF _ 74, 19
        lea     rdx, [rel ?_216]                        ; 19E1 _ 48: 8D. 15, 00000000(rel)
        mov     eax, dword [rbp-44H]                    ; 19E8 _ 8B. 45, BC
        mov     rsi, rdx                                ; 19EB _ 48: 89. D6
        mov     edi, eax                                ; 19EE _ 89. C7
        mov     eax, 0                                  ; 19F0 _ B8, 00000000
        call    nasm_warn_                              ; 19F5 _ E8, 00000000(PLT r)
?_165:  mov     dword [rbp-58H], 3                      ; 19FA _ C7. 45, A8, 00000003
        jmp     ?_168                                   ; 1A01 _ EB, 10

?_166:  mov     dword [rbp-58H], 1                      ; 1A03 _ C7. 45, A8, 00000001
        jmp     ?_168                                   ; 1A0A _ EB, 07

?_167:  mov     dword [rbp-58H], 0                      ; 1A0C _ C7. 45, A8, 00000000
?_168:  cmp     dword [rbp-58H], 5                      ; 1A13 _ 83. 7D, A8, 05
        ja      ?_185                                   ; 1A17 _ 0F 87, 0000035B
        cmp     dword [rbp-58H], 3                      ; 1A1D _ 83. 7D, A8, 03
        jnc     ?_180                                   ; 1A21 _ 0F 83, 00000289
        cmp     dword [rbp-58H], 2                      ; 1A27 _ 83. 7D, A8, 02
        je      ?_176                                   ; 1A2B _ 0F 84, 0000016B
        cmp     dword [rbp-58H], 2                      ; 1A31 _ 83. 7D, A8, 02
        ja      ?_185                                   ; 1A35 _ 0F 87, 0000033D
        cmp     dword [rbp-58H], 0                      ; 1A3B _ 83. 7D, A8, 00
        jz      ?_170                                   ; 1A3F _ 74, 0C
        cmp     dword [rbp-58H], 1                      ; 1A41 _ 83. 7D, A8, 01
        jz      ?_171                                   ; 1A45 _ 74, 21
        jmp     ?_185                                   ; 1A47 _ E9, 0000032C

?_169:  nop                                             ; 1A4C _ 90
?_170:  lea     rax, [rbp-20H]                          ; 1A4D _ 48: 8D. 45, E0
        mov     edx, 24                                 ; 1A51 _ BA, 00000018
        mov     esi, 0                                  ; 1A56 _ BE, 00000000
        mov     rdi, rax                                ; 1A5B _ 48: 89. C7
        call    memset                                  ; 1A5E _ E8, 00000000(PLT r)
        jmp     ?_185                                   ; 1A63 _ E9, 00000310

?_171:  mov     rax, qword [rbp-30H]                    ; 1A68 _ 48: 8B. 45, D0
        mov     edx, dword [rax+0CH]                    ; 1A6C _ 8B. 50, 0C
        mov     ecx, dword [rbp-60H]                    ; 1A6F _ 8B. 4D, A0
        mov     eax, dword [rbp-54H]                    ; 1A72 _ 8B. 45, AC
        add     eax, ecx                                ; 1A75 _ 01. C8
        sub     eax, 2                                  ; 1A77 _ 83. E8, 02
        sub     edx, eax                                ; 1A7A _ 29. C2
        mov     rax, qword [rbp-30H]                    ; 1A7C _ 48: 8B. 45, D0
        mov     eax, dword [rax+8H]                     ; 1A80 _ 8B. 40, 08
        add     eax, edx                                ; 1A83 _ 01. D0
        mov     dword [rbp-3CH], eax                    ; 1A85 _ 89. 45, C4
        mov     edx, dword [rbp-3CH]                    ; 1A88 _ 8B. 55, C4
        lea     rax, [rbp-20H]                          ; 1A8B _ 48: 8D. 45, E0
        mov     esi, edx                                ; 1A8F _ 89. D6
        mov     rdi, rax                                ; 1A91 _ 48: 89. C7
        call    ieee_shr                                ; 1A94 _ E8, FFFFF768
        mov     edx, dword [rbp-48H]                    ; 1A99 _ 8B. 55, B8
        lea     rcx, [rbp-20H]                          ; 1A9C _ 48: 8D. 4D, E0
        movzx   eax, byte [rbp-61H]                     ; 1AA0 _ 0F B6. 45, 9F
        mov     rsi, rcx                                ; 1AA4 _ 48: 89. CE
        mov     edi, eax                                ; 1AA7 _ 89. C7
        call    ieee_round                              ; 1AA9 _ E8, FFFFEF08
        mov     eax, dword [rbp-4CH]                    ; 1AAE _ 8B. 45, B4
        cdqe                                            ; 1AB1 _ 48: 98
        mov     eax, dword [rbp+rax*4-20H]              ; 1AB3 _ 8B. 44 85, E0
        and     eax, dword [rbp-50H]                    ; 1AB7 _ 23. 45, B0
        test    eax, eax                                ; 1ABA _ 85. C0
        jz      ?_173                                   ; 1ABC _ 74, 4D
        mov     dword [rbp-60H], 1                      ; 1ABE _ C7. 45, A0, 00000001
        mov     rax, qword [rbp-30H]                    ; 1AC5 _ 48: 8B. 45, D0
        mov     eax, dword [rax+8H]                     ; 1AC9 _ 8B. 40, 08
        test    eax, eax                                ; 1ACC _ 85. C0
        jnz     ?_172                                   ; 1ACE _ 75, 19
        mov     eax, dword [rbp-4CH]                    ; 1AD0 _ 8B. 45, B4
        cdqe                                            ; 1AD3 _ 48: 98
        mov     eax, dword [rbp+rax*4-20H]              ; 1AD5 _ 8B. 44 85, E0
        mov     edx, dword [rbp-50H]                    ; 1AD9 _ 8B. 55, B0
        not     edx                                     ; 1ADC _ F7. D2
        and     edx, eax                                ; 1ADE _ 21. C2
        mov     eax, dword [rbp-4CH]                    ; 1AE0 _ 8B. 45, B4
        cdqe                                            ; 1AE3 _ 48: 98
        mov     dword [rbp+rax*4-20H], edx              ; 1AE5 _ 89. 54 85, E0
?_172:  mov     edx, dword [rbp-20H]                    ; 1AE9 _ 8B. 55, E0
        mov     esi, dword [rbp-60H]                    ; 1AEC _ 8B. 75, A0
        mov     rax, qword [rbp-30H]                    ; 1AEF _ 48: 8B. 45, D0
        mov     eax, dword [rax+0CH]                    ; 1AF3 _ 8B. 40, 0C
        mov     ecx, 31                                 ; 1AF6 _ B9, 0000001F
        sub     ecx, eax                                ; 1AFB _ 29. C1
        mov     eax, esi                                ; 1AFD _ 89. F0
        shl     eax, cl                                 ; 1AFF _ D3. E0
        or      eax, edx                                ; 1B01 _ 09. D0
        mov     dword [rbp-20H], eax                    ; 1B03 _ 89. 45, E0
        jmp     ?_183                                   ; 1B06 _ E9, 00000269

?_173:  movzx   eax, byte [rel daz]                     ; 1B0B _ 0F B6. 05, 00000000(rel)
        test    al, al                                  ; 1B12 _ 84. C0
        jnz     ?_174                                   ; 1B14 _ 75, 10
        lea     rax, [rbp-20H]                          ; 1B16 _ 48: 8D. 45, E0
        mov     rdi, rax                                ; 1B1A _ 48: 89. C7
        call    is_zero                                 ; 1B1D _ E8, FFFFEE51
        test    al, al                                  ; 1B22 _ 84. C0
        jz      ?_175                                   ; 1B24 _ 74, 3B
?_174:  mov     dword [rbp-34H], 524544                 ; 1B26 _ C7. 45, CC, 00080100
        mov     eax, dword [rbp-34H]                    ; 1B2D _ 8B. 45, CC
        mov     edi, eax                                ; 1B30 _ 89. C7
        call    warn_active                             ; 1B32 _ E8, FFFFE4FA
        movzx   eax, al                                 ; 1B37 _ 0F B6. C0
        test    rax, rax                                ; 1B3A _ 48: 85. C0
        je      ?_169                                   ; 1B3D _ 0F 84, FFFFFF09
        lea     rdx, [rel ?_217]                        ; 1B43 _ 48: 8D. 15, 00000000(rel)
        mov     eax, dword [rbp-34H]                    ; 1B4A _ 8B. 45, CC
        mov     rsi, rdx                                ; 1B4D _ 48: 89. D6
        mov     edi, eax                                ; 1B50 _ 89. C7
        mov     eax, 0                                  ; 1B52 _ B8, 00000000
        call    nasm_warn_                              ; 1B57 _ E8, 00000000(PLT r)
        jmp     ?_169                                   ; 1B5C _ E9, FFFFFEEB

?_175:  mov     dword [rbp-38H], 327936                 ; 1B61 _ C7. 45, C8, 00050100
        mov     eax, dword [rbp-38H]                    ; 1B68 _ 8B. 45, C8
        mov     edi, eax                                ; 1B6B _ 89. C7
        call    warn_active                             ; 1B6D _ E8, FFFFE4BF
        movzx   eax, al                                 ; 1B72 _ 0F B6. C0
        test    rax, rax                                ; 1B75 _ 48: 85. C0
        je      ?_183                                   ; 1B78 _ 0F 84, 000001F6
        lea     rdx, [rel ?_218]                        ; 1B7E _ 48: 8D. 15, 00000000(rel)
        mov     eax, dword [rbp-38H]                    ; 1B85 _ 8B. 45, C8
        mov     rsi, rdx                                ; 1B88 _ 48: 89. D6
        mov     edi, eax                                ; 1B8B _ 89. C7
        mov     eax, 0                                  ; 1B8D _ B8, 00000000
        call    nasm_warn_                              ; 1B92 _ E8, 00000000(PLT r)
        jmp     ?_183                                   ; 1B97 _ E9, 000001D8

?_176:  mov     eax, dword [rbp-54H]                    ; 1B9C _ 8B. 45, AC
        lea     edx, [rax-1H]                           ; 1B9F _ 8D. 50, FF
        mov     eax, dword [rbp-60H]                    ; 1BA2 _ 8B. 45, A0
        add     eax, edx                                ; 1BA5 _ 01. D0
        mov     dword [rbp-60H], eax                    ; 1BA7 _ 89. 45, A0
        mov     rax, qword [rbp-30H]                    ; 1BAA _ 48: 8B. 45, D0
        mov     edx, dword [rax+0CH]                    ; 1BAE _ 8B. 50, 0C
        mov     rax, qword [rbp-30H]                    ; 1BB1 _ 48: 8B. 45, D0
        mov     eax, dword [rax+8H]                     ; 1BB5 _ 8B. 40, 08
        add     edx, eax                                ; 1BB8 _ 01. C2
        lea     rax, [rbp-20H]                          ; 1BBA _ 48: 8D. 45, E0
        mov     esi, edx                                ; 1BBE _ 89. D6
        mov     rdi, rax                                ; 1BC0 _ 48: 89. C7
        call    ieee_shr                                ; 1BC3 _ E8, FFFFF639
        mov     edx, dword [rbp-48H]                    ; 1BC8 _ 8B. 55, B8
        lea     rcx, [rbp-20H]                          ; 1BCB _ 48: 8D. 4D, E0
        movzx   eax, byte [rbp-61H]                     ; 1BCF _ 0F B6. 45, 9F
        mov     rsi, rcx                                ; 1BD3 _ 48: 89. CE
        mov     edi, eax                                ; 1BD6 _ 89. C7
        call    ieee_round                              ; 1BD8 _ E8, FFFFEDD9
        mov     rax, qword [rbp-30H]                    ; 1BDD _ 48: 8B. 45, D0
        mov     edx, dword [rax+0CH]                    ; 1BE1 _ 8B. 50, 0C
        mov     rax, qword [rbp-30H]                    ; 1BE4 _ 48: 8B. 45, D0
        mov     eax, dword [rax+8H]                     ; 1BE8 _ 8B. 40, 08
        add     eax, edx                                ; 1BEB _ 01. D0
        sub     eax, 1                                  ; 1BED _ 83. E8, 01
        movsxd  rdx, eax                                ; 1BF0 _ 48: 63. D0
        lea     rax, [rbp-20H]                          ; 1BF3 _ 48: 8D. 45, E0
        mov     rsi, rdx                                ; 1BF7 _ 48: 89. D6
        mov     rdi, rax                                ; 1BFA _ 48: 89. C7
        call    test_bit                                ; 1BFD _ E8, FFFFED38
        test    eax, eax                                ; 1C02 _ 85. C0
        jz      ?_178                                   ; 1C04 _ 74, 64
        lea     rax, [rbp-20H]                          ; 1C06 _ 48: 8D. 45, E0
        mov     esi, 1                                  ; 1C0A _ BE, 00000001
        mov     rdi, rax                                ; 1C0F _ 48: 89. C7
        call    ieee_shr                                ; 1C12 _ E8, FFFFF5EA
        mov     eax, dword [rbp-60H]                    ; 1C17 _ 8B. 45, A0
        add     eax, 1                                  ; 1C1A _ 83. C0, 01
        mov     dword [rbp-60H], eax                    ; 1C1D _ 89. 45, A0
        mov     eax, dword [rbp-54H]                    ; 1C20 _ 8B. 45, AC
        add     eax, eax                                ; 1C23 _ 01. C0
        lea     edx, [rax-1H]                           ; 1C25 _ 8D. 50, FF
        mov     eax, dword [rbp-60H]                    ; 1C28 _ 8B. 45, A0
        cmp     edx, eax                                ; 1C2B _ 39. C2
        jg      ?_178                                   ; 1C2D _ 7F, 3B
        mov     dword [rbp-40H], 393472                 ; 1C2F _ C7. 45, C0, 00060100
        mov     eax, dword [rbp-40H]                    ; 1C36 _ 8B. 45, C0
        mov     edi, eax                                ; 1C39 _ 89. C7
        call    warn_active                             ; 1C3B _ E8, FFFFE3F1
        movzx   eax, al                                 ; 1C40 _ 0F B6. C0
        test    rax, rax                                ; 1C43 _ 48: 85. C0
        jz      ?_177                                   ; 1C46 _ 74, 19
        lea     rdx, [rel ?_216]                        ; 1C48 _ 48: 8D. 15, 00000000(rel)
        mov     eax, dword [rbp-40H]                    ; 1C4F _ 8B. 45, C0
        mov     rsi, rdx                                ; 1C52 _ 48: 89. D6
        mov     edi, eax                                ; 1C55 _ 89. C7
        mov     eax, 0                                  ; 1C57 _ B8, 00000000
        call    nasm_warn_                              ; 1C5C _ E8, 00000000(PLT r)
?_177:  mov     dword [rbp-58H], 3                      ; 1C61 _ C7. 45, A8, 00000003
        jmp     ?_180                                   ; 1C68 _ EB, 46

?_178:  mov     rax, qword [rbp-30H]                    ; 1C6A _ 48: 8B. 45, D0
        mov     eax, dword [rax+8H]                     ; 1C6E _ 8B. 40, 08
        test    eax, eax                                ; 1C71 _ 85. C0
        jnz     ?_179                                   ; 1C73 _ 75, 19
        mov     eax, dword [rbp-4CH]                    ; 1C75 _ 8B. 45, B4
        cdqe                                            ; 1C78 _ 48: 98
        mov     eax, dword [rbp+rax*4-20H]              ; 1C7A _ 8B. 44 85, E0
        mov     edx, dword [rbp-50H]                    ; 1C7E _ 8B. 55, B0
        not     edx                                     ; 1C81 _ F7. D2
        and     edx, eax                                ; 1C83 _ 21. C2
        mov     eax, dword [rbp-4CH]                    ; 1C85 _ 8B. 45, B4
        cdqe                                            ; 1C88 _ 48: 98
        mov     dword [rbp+rax*4-20H], edx              ; 1C8A _ 89. 54 85, E0
?_179:  mov     edx, dword [rbp-20H]                    ; 1C8E _ 8B. 55, E0
        mov     esi, dword [rbp-60H]                    ; 1C91 _ 8B. 75, A0
        mov     rax, qword [rbp-30H]                    ; 1C94 _ 48: 8B. 45, D0
        mov     eax, dword [rax+0CH]                    ; 1C98 _ 8B. 40, 0C
        mov     ecx, 31                                 ; 1C9B _ B9, 0000001F
        sub     ecx, eax                                ; 1CA0 _ 29. C1
        mov     eax, esi                                ; 1CA2 _ 89. F0
        shl     eax, cl                                 ; 1CA4 _ D3. E0
        or      eax, edx                                ; 1CA6 _ 09. D0
        mov     dword [rbp-20H], eax                    ; 1CA8 _ 89. 45, E0
        jmp     ?_185                                   ; 1CAB _ E9, 000000C8

?_180:  lea     rax, [rbp-20H]                          ; 1CB0 _ 48: 8D. 45, E0
        mov     edx, 24                                 ; 1CB4 _ BA, 00000018
        mov     esi, 0                                  ; 1CB9 _ BE, 00000000
        mov     rdi, rax                                ; 1CBE _ 48: 89. C7
        call    memset                                  ; 1CC1 _ E8, 00000000(PLT r)
        mov     rax, qword [rbp-30H]                    ; 1CC6 _ 48: 8B. 45, D0
        mov     eax, dword [rax+0CH]                    ; 1CCA _ 8B. 40, 0C
        mov     edx, 1                                  ; 1CCD _ BA, 00000001
        mov     ecx, eax                                ; 1CD2 _ 89. C1
        shl     edx, cl                                 ; 1CD4 _ D3. E2
        mov     eax, edx                                ; 1CD6 _ 89. D0
        lea     esi, [rax-1H]                           ; 1CD8 _ 8D. 70, FF
        mov     rax, qword [rbp-30H]                    ; 1CDB _ 48: 8B. 45, D0
        mov     eax, dword [rax+0CH]                    ; 1CDF _ 8B. 40, 0C
        mov     edx, 31                                 ; 1CE2 _ BA, 0000001F
        sub     edx, eax                                ; 1CE7 _ 29. C2
        mov     eax, esi                                ; 1CE9 _ 89. F0
        mov     ecx, edx                                ; 1CEB _ 89. D1
        shl     eax, cl                                 ; 1CED _ D3. E0
        mov     dword [rbp-20H], eax                    ; 1CEF _ 89. 45, E0
        mov     rax, qword [rbp-30H]                    ; 1CF2 _ 48: 8B. 45, D0
        mov     eax, dword [rax+8H]                     ; 1CF6 _ 8B. 40, 08
        test    eax, eax                                ; 1CF9 _ 85. C0
        jz      ?_181                                   ; 1CFB _ 74, 17
        mov     eax, dword [rbp-4CH]                    ; 1CFD _ 8B. 45, B4
        cdqe                                            ; 1D00 _ 48: 98
        mov     eax, dword [rbp+rax*4-20H]              ; 1D02 _ 8B. 44 85, E0
        or      eax, dword [rbp-50H]                    ; 1D06 _ 0B. 45, B0
        mov     edx, eax                                ; 1D09 _ 89. C2
        mov     eax, dword [rbp-4CH]                    ; 1D0B _ 8B. 45, B4
        cdqe                                            ; 1D0E _ 48: 98
        mov     dword [rbp+rax*4-20H], edx              ; 1D10 _ 89. 54 85, E0
?_181:  cmp     dword [rbp-58H], 4                      ; 1D14 _ 83. 7D, A8, 04
        jnz     ?_182                                   ; 1D18 _ 75, 27
        mov     rax, qword [rbp-30H]                    ; 1D1A _ 48: 8B. 45, D0
        mov     edx, dword [rax+0CH]                    ; 1D1E _ 8B. 50, 0C
        mov     rax, qword [rbp-30H]                    ; 1D21 _ 48: 8B. 45, D0
        mov     eax, dword [rax+8H]                     ; 1D25 _ 8B. 40, 08
        add     eax, edx                                ; 1D28 _ 01. D0
        add     eax, 1                                  ; 1D2A _ 83. C0, 01
        movsxd  rdx, eax                                ; 1D2D _ 48: 63. D0
        lea     rax, [rbp-20H]                          ; 1D30 _ 48: 8D. 45, E0
        mov     rsi, rdx                                ; 1D34 _ 48: 89. D6
        mov     rdi, rax                                ; 1D37 _ 48: 89. C7
        call    set_bit                                 ; 1D3A _ E8, FFFFEBAE
        jmp     ?_184                                   ; 1D3F _ EB, 36

?_182:  cmp     dword [rbp-58H], 5                      ; 1D41 _ 83. 7D, A8, 05
        jnz     ?_184                                   ; 1D45 _ 75, 30
        mov     rax, qword [rbp-30H]                    ; 1D47 _ 48: 8B. 45, D0
        mov     edx, dword [rax+0CH]                    ; 1D4B _ 8B. 50, 0C
        mov     rax, qword [rbp-30H]                    ; 1D4E _ 48: 8B. 45, D0
        mov     eax, dword [rax+8H]                     ; 1D52 _ 8B. 40, 08
        add     edx, eax                                ; 1D55 _ 01. C2
        mov     rax, qword [rbp-30H]                    ; 1D57 _ 48: 8B. 45, D0
        mov     eax, dword [rax+4H]                     ; 1D5B _ 8B. 40, 04
        add     eax, edx                                ; 1D5E _ 01. D0
        movsxd  rdx, eax                                ; 1D60 _ 48: 63. D0
        lea     rax, [rbp-20H]                          ; 1D63 _ 48: 8D. 45, E0
        mov     rsi, rdx                                ; 1D67 _ 48: 89. D6
        mov     rdi, rax                                ; 1D6A _ 48: 89. C7
        call    set_bit                                 ; 1D6D _ E8, FFFFEB7B
        jmp     ?_184                                   ; 1D72 _ EB, 03

?_183:  nop                                             ; 1D74 _ 90
        jmp     ?_185                                   ; 1D75 _ EB, 01

?_184:  nop                                             ; 1D77 _ 90
?_185:  mov     eax, dword [rbp-20H]                    ; 1D78 _ 8B. 45, E0
        cmp     byte [rbp-61H], 0                       ; 1D7B _ 80. 7D, 9F, 00
        jz      ?_186                                   ; 1D7F _ 74, 07
        mov     edx, 2147483648                         ; 1D81 _ BA, 80000000
        jmp     ?_187                                   ; 1D86 _ EB, 05

?_186:  mov     edx, 0                                  ; 1D88 _ BA, 00000000
?_187:  or      eax, edx                                ; 1D8D _ 09. D0
        mov     dword [rbp-20H], eax                    ; 1D8F _ 89. 45, E0
        mov     rax, qword [rbp-30H]                    ; 1D92 _ 48: 8B. 45, D0
        mov     eax, dword [rax]                        ; 1D96 _ 8B. 00
        sub     eax, 1                                  ; 1D98 _ 83. E8, 01
        mov     dword [rbp-5CH], eax                    ; 1D9B _ 89. 45, A4
        jmp     ?_189                                   ; 1D9E _ EB, 50

?_188:  mov     eax, dword [rbp-5CH]                    ; 1DA0 _ 8B. 45, A4
        lea     edx, [rax+3H]                           ; 1DA3 _ 8D. 50, 03
        test    eax, eax                                ; 1DA6 _ 85. C0
        cmovs   eax, edx                                ; 1DA8 _ 0F 48. C2
        sar     eax, 2                                  ; 1DAB _ C1. F8, 02
        cdqe                                            ; 1DAE _ 48: 98
        mov     esi, dword [rbp+rax*4-20H]              ; 1DB0 _ 8B. 74 85, E0
        mov     edx, dword [rbp-5CH]                    ; 1DB4 _ 8B. 55, A4
        mov     eax, edx                                ; 1DB7 _ 89. D0
        sar     eax, 31                                 ; 1DB9 _ C1. F8, 1F
        shr     eax, 30                                 ; 1DBC _ C1. E8, 1E
        add     edx, eax                                ; 1DBF _ 01. C2
        and     edx, 03H                                ; 1DC1 _ 83. E2, 03
        sub     edx, eax                                ; 1DC4 _ 29. C2
        mov     eax, 3                                  ; 1DC6 _ B8, 00000003
        sub     eax, edx                                ; 1DCB _ 29. D0
        shl     eax, 3                                  ; 1DCD _ C1. E0, 03
        mov     ecx, eax                                ; 1DD0 _ 89. C1
        shr     esi, cl                                 ; 1DD2 _ D3. EE
        mov     ecx, esi                                ; 1DD4 _ 89. F1
        mov     rax, qword [rbp-88H]                    ; 1DD6 _ 48: 8B. 85, FFFFFF78
        lea     rdx, [rax+1H]                           ; 1DDD _ 48: 8D. 50, 01
        mov     qword [rbp-88H], rdx                    ; 1DE1 _ 48: 89. 95, FFFFFF78
        mov     edx, ecx                                ; 1DE8 _ 89. CA
        mov     byte [rax], dl                          ; 1DEA _ 88. 10
        sub     dword [rbp-5CH], 1                      ; 1DEC _ 83. 6D, A4, 01
?_189:  cmp     dword [rbp-5CH], 0                      ; 1DF0 _ 83. 7D, A4, 00
        jns     ?_188                                   ; 1DF4 _ 79, AA
        mov     eax, 1                                  ; 1DF6 _ B8, 00000001
?_190:  mov     rdx, qword [rbp-8H]                     ; 1DFB _ 48: 8B. 55, F8
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        sub     rdx, qword [fs:abs 28H]                 ; 1DFF _ 64 48: 2B. 14 25, 00000028
        jz      ?_191                                   ; 1E08 _ 74, 05
        call    __stack_chk_fail                        ; 1E0A _ E8, 00000000(PLT r)
?_191:  leave                                           ; 1E0F _ C9
        ret                                             ; 1E10 _ C3
; float_const End of function

float_deffmt:; Function begin
        push    rbp                                     ; 1E11 _ 55
        mov     rbp, rsp                                ; 1E12 _ 48: 89. E5
        mov     dword [rbp-14H], edi                    ; 1E15 _ 89. 7D, EC
        mov     dword [rbp-4H], 0                       ; 1E18 _ C7. 45, FC, 00000000
        jmp     ?_193                                   ; 1E1F _ EB, 27

?_192:  mov     edx, dword [rbp-4H]                     ; 1E21 _ 8B. 55, FC
        mov     rax, rdx                                ; 1E24 _ 48: 89. D0
        shl     rax, 2                                  ; 1E27 _ 48: C1. E0, 02
        add     rax, rdx                                ; 1E2B _ 48: 01. D0
        shl     rax, 2                                  ; 1E2E _ 48: C1. E0, 02
        mov     rdx, rax                                ; 1E32 _ 48: 89. C2
        lea     rax, [rel fp_formats]                   ; 1E35 _ 48: 8D. 05, 00000000(rel)
        mov     eax, dword [rdx+rax]                    ; 1E3C _ 8B. 04 02
        cmp     dword [rbp-14H], eax                    ; 1E3F _ 39. 45, EC
        jz      ?_194                                   ; 1E42 _ 74, 0C
        add     dword [rbp-4H], 1                       ; 1E44 _ 83. 45, FC, 01
?_193:  cmp     dword [rbp-4H], 8                       ; 1E48 _ 83. 7D, FC, 08
        jbe     ?_192                                   ; 1E4C _ 76, D3
        jmp     ?_195                                   ; 1E4E _ EB, 01

?_194:  nop                                             ; 1E50 _ 90
?_195:  mov     eax, dword [rbp-4H]                     ; 1E51 _ 8B. 45, FC
        pop     rbp                                     ; 1E54 _ 5D
        ret                                             ; 1E55 _ C3
; float_deffmt End of function

float_option:; Function begin
        push    rbp                                     ; 1E56 _ 55
        mov     rbp, rsp                                ; 1E57 _ 48: 89. E5
        sub     rsp, 16                                 ; 1E5A _ 48: 83. EC, 10
        mov     qword [rbp-8H], rdi                     ; 1E5E _ 48: 89. 7D, F8
        lea     rdx, [rel ?_219]                        ; 1E62 _ 48: 8D. 15, 00000000(rel)
        mov     rax, qword [rbp-8H]                     ; 1E69 _ 48: 8B. 45, F8
        mov     rsi, rdx                                ; 1E6D _ 48: 89. D6
        mov     rdi, rax                                ; 1E70 _ 48: 89. C7
        call    strcasecmp                              ; 1E73 _ E8, 00000000(PLT r)
        test    eax, eax                                ; 1E78 _ 85. C0
        jnz     ?_196                                   ; 1E7A _ 75, 11
        mov     byte [rel daz], 1                       ; 1E7C _ C6. 05, 00000000(rel), 01
        mov     eax, 0                                  ; 1E83 _ B8, 00000000
        jmp     ?_203                                   ; 1E88 _ E9, 00000114

?_196:  lea     rdx, [rel ?_220]                        ; 1E8D _ 48: 8D. 15, 00000000(rel)
        mov     rax, qword [rbp-8H]                     ; 1E94 _ 48: 8B. 45, F8
        mov     rsi, rdx                                ; 1E98 _ 48: 89. D6
        mov     rdi, rax                                ; 1E9B _ 48: 89. C7
        call    strcasecmp                              ; 1E9E _ E8, 00000000(PLT r)
        test    eax, eax                                ; 1EA3 _ 85. C0
        jnz     ?_197                                   ; 1EA5 _ 75, 11
        mov     byte [rel daz], 0                       ; 1EA7 _ C6. 05, 00000000(rel), 00
        mov     eax, 0                                  ; 1EAE _ B8, 00000000
        jmp     ?_203                                   ; 1EB3 _ E9, 000000E9

?_197:  lea     rdx, [rel ?_221]                        ; 1EB8 _ 48: 8D. 15, 00000000(rel)
        mov     rax, qword [rbp-8H]                     ; 1EBF _ 48: 8B. 45, F8
        mov     rsi, rdx                                ; 1EC3 _ 48: 89. D6
        mov     rdi, rax                                ; 1EC6 _ 48: 89. C7
        call    strcasecmp                              ; 1EC9 _ E8, 00000000(PLT r)
        test    eax, eax                                ; 1ECE _ 85. C0
        jnz     ?_198                                   ; 1ED0 _ 75, 14
        mov     dword [rel rc], 0                       ; 1ED2 _ C7. 05, 00000000(rel), 00000000
        mov     eax, 0                                  ; 1EDC _ B8, 00000000
        jmp     ?_203                                   ; 1EE1 _ E9, 000000BB

?_198:  lea     rdx, [rel ?_222]                        ; 1EE6 _ 48: 8D. 15, 00000000(rel)
        mov     rax, qword [rbp-8H]                     ; 1EED _ 48: 8B. 45, F8
        mov     rsi, rdx                                ; 1EF1 _ 48: 89. D6
        mov     rdi, rax                                ; 1EF4 _ 48: 89. C7
        call    strcasecmp                              ; 1EF7 _ E8, 00000000(PLT r)
        test    eax, eax                                ; 1EFC _ 85. C0
        jnz     ?_199                                   ; 1EFE _ 75, 14
        mov     dword [rel rc], 2                       ; 1F00 _ C7. 05, 00000000(rel), 00000002
        mov     eax, 0                                  ; 1F0A _ B8, 00000000
        jmp     ?_203                                   ; 1F0F _ E9, 0000008D

?_199:  lea     rdx, [rel ?_223]                        ; 1F14 _ 48: 8D. 15, 00000000(rel)
        mov     rax, qword [rbp-8H]                     ; 1F1B _ 48: 8B. 45, F8
        mov     rsi, rdx                                ; 1F1F _ 48: 89. D6
        mov     rdi, rax                                ; 1F22 _ 48: 89. C7
        call    strcasecmp                              ; 1F25 _ E8, 00000000(PLT r)
        test    eax, eax                                ; 1F2A _ 85. C0
        jnz     ?_200                                   ; 1F2C _ 75, 11
        mov     dword [rel rc], 3                       ; 1F2E _ C7. 05, 00000000(rel), 00000003
        mov     eax, 0                                  ; 1F38 _ B8, 00000000
        jmp     ?_203                                   ; 1F3D _ EB, 62

?_200:  lea     rdx, [rel ?_224]                        ; 1F3F _ 48: 8D. 15, 00000000(rel)
        mov     rax, qword [rbp-8H]                     ; 1F46 _ 48: 8B. 45, F8
        mov     rsi, rdx                                ; 1F4A _ 48: 89. D6
        mov     rdi, rax                                ; 1F4D _ 48: 89. C7
        call    strcasecmp                              ; 1F50 _ E8, 00000000(PLT r)
        test    eax, eax                                ; 1F55 _ 85. C0
        jnz     ?_201                                   ; 1F57 _ 75, 11
        mov     dword [rel rc], 1                       ; 1F59 _ C7. 05, 00000000(rel), 00000001
        mov     eax, 0                                  ; 1F63 _ B8, 00000000
        jmp     ?_203                                   ; 1F68 _ EB, 37

?_201:  lea     rdx, [rel ?_225]                        ; 1F6A _ 48: 8D. 15, 00000000(rel)
        mov     rax, qword [rbp-8H]                     ; 1F71 _ 48: 8B. 45, F8
        mov     rsi, rdx                                ; 1F75 _ 48: 89. D6
        mov     rdi, rax                                ; 1F78 _ 48: 89. C7
        call    strcasecmp                              ; 1F7B _ E8, 00000000(PLT r)
        test    eax, eax                                ; 1F80 _ 85. C0
        jnz     ?_202                                   ; 1F82 _ 75, 18
        mov     dword [rel rc], 0                       ; 1F84 _ C7. 05, 00000000(rel), 00000000
        mov     byte [rel daz], 0                       ; 1F8E _ C6. 05, 00000000(rel), 00
        mov     eax, 0                                  ; 1F95 _ B8, 00000000
        jmp     ?_203                                   ; 1F9A _ EB, 05

?_202:  mov     eax, 4294967295                         ; 1F9C _ B8, FFFFFFFF
?_203:  leave                                           ; 1FA1 _ C9
        ret                                             ; 1FA2 _ C3
; float_option End of function


SECTION .data   align=1 noexec                          ; section number 2, data


SECTION .bss    align=4 noexec                          ; section number 3, bss

daz:                                                    ; byte
        resb    4                                       ; 0000

rc:     resd    1                                       ; 0004


SECTION .rodata align=32 noexec                         ; section number 4, const

?_204:                                                  ; byte
        db 65H, 78H, 70H, 6FH, 6EH, 65H, 6EH, 74H       ; 0000 _ exponent
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0008 _ ........

?_205:                                                  ; byte
        db 69H, 6EH, 76H, 61H, 6CH, 69H, 64H, 20H       ; 0010 _ invalid 
        db 63H, 68H, 61H, 72H, 61H, 63H, 74H, 65H       ; 0018 _ characte
        db 72H, 20H, 69H, 6EH, 20H, 66H, 6CH, 6FH       ; 0020 _ r in flo
        db 61H, 74H, 69H, 6EH, 67H, 2DH, 70H, 6FH       ; 0028 _ ating-po
        db 69H, 6EH, 74H, 20H, 63H, 6FH, 6EH, 73H       ; 0030 _ int cons
        db 74H, 61H, 6EH, 74H, 20H, 25H, 73H, 3AH       ; 0038 _ tant %s:
        db 20H, 27H, 25H, 63H, 27H, 00H, 00H, 00H       ; 0040 _  '%c'...

?_206:                                                  ; byte
        db 74H, 6FH, 6FH, 20H, 6DH, 61H, 6EH, 79H       ; 0048 _ too many
        db 20H, 70H, 65H, 72H, 69H, 6FH, 64H, 73H       ; 0050 _  periods
        db 20H, 69H, 6EH, 20H, 66H, 6CH, 6FH, 61H       ; 0058 _  in floa
        db 74H, 69H, 6EH, 67H, 2DH, 70H, 6FH, 69H       ; 0060 _ ting-poi
        db 6EH, 74H, 20H, 63H, 6FH, 6EH, 73H, 74H       ; 0068 _ nt const
        db 61H, 6EH, 74H, 00H, 00H, 00H, 00H, 00H       ; 0070 _ ant.....

?_207:                                                  ; byte
        db 66H, 6CH, 6FH, 61H, 74H, 69H, 6EH, 67H       ; 0078 _ floating
        db 2DH, 70H, 6FH, 69H, 6EH, 74H, 20H, 63H       ; 0080 _ -point c
        db 6FH, 6EH, 73H, 74H, 61H, 6EH, 74H, 20H       ; 0088 _ onstant 
        db 73H, 69H, 67H, 6EH, 69H, 66H, 69H, 63H       ; 0090 _ signific
        db 61H, 6EH, 64H, 20H, 63H, 6FH, 6EH, 74H       ; 0098 _ and cont
        db 61H, 69H, 6EH, 73H, 20H, 6DH, 6FH, 72H       ; 00A0 _ ains mor
        db 65H, 20H, 74H, 68H, 61H, 6EH, 20H, 25H       ; 00A8 _ e than %
        db 69H, 20H, 64H, 69H, 67H, 69H, 74H, 73H       ; 00B0 _ i digits
        db 00H                                          ; 00B8 _ .

?_208:                                                  ; byte
        db 73H, 69H, 67H, 6EH, 69H, 66H, 69H, 63H       ; 00B9 _ signific
        db 61H, 6EH, 64H, 00H, 00H, 00H, 00H            ; 00C1 _ and....

?_209:                                                  ; byte
        db 66H, 6CH, 6FH, 61H, 74H, 69H, 6EH, 67H       ; 00C8 _ floating
        db 2DH, 70H, 6FH, 69H, 6EH, 74H, 20H, 63H       ; 00D0 _ -point c
        db 6FH, 6EH, 73H, 74H, 61H, 6EH, 74H, 3AH       ; 00D8 _ onstant:
        db 20H, 60H, 25H, 63H, 27H, 20H, 69H, 73H       ; 00E0 _  `%c' is
        db 20H, 69H, 6EH, 76H, 61H, 6CH, 69H, 64H       ; 00E8 _  invalid
        db 20H, 63H, 68H, 61H, 72H, 61H, 63H, 74H       ; 00F0 _  charact
        db 65H, 72H, 00H, 00H, 00H, 00H, 00H, 00H       ; 00F8 _ er......

fp_formats:                                             ; byte
        db 01H, 00H, 00H, 00H, 03H, 00H, 00H, 00H       ; 0100 _ ........
        db 00H, 00H, 00H, 00H, 04H, 00H, 00H, 00H       ; 0108 _ ........
        db 00H, 00H, 00H, 00H, 02H, 00H, 00H, 00H       ; 0110 _ ........
        db 0AH, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0118 _ ........
        db 05H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0120 _ ........
        db 02H, 00H, 00H, 00H, 07H, 00H, 00H, 00H       ; 0128 _ ........
        db 00H, 00H, 00H, 00H, 08H, 00H, 00H, 00H       ; 0130 _ ........
        db 00H, 00H, 00H, 00H, 04H, 00H, 00H, 00H       ; 0138 _ ........
        db 17H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0140 _ ........
        db 08H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0148 _ ........
        db 08H, 00H, 00H, 00H, 34H, 00H, 00H, 00H       ; 0150 _ ....4...
        db 00H, 00H, 00H, 00H, 0BH, 00H, 00H, 00H       ; 0158 _ ........
        db 00H, 00H, 00H, 00H, 0AH, 00H, 00H, 00H       ; 0160 _ ........
        db 3FH, 00H, 00H, 00H, 01H, 00H, 00H, 00H       ; 0168 _ ?.......
        db 0FH, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0170 _ ........
        db 0AH, 00H, 00H, 00H, 3FH, 00H, 00H, 00H       ; 0178 _ ....?...
        db 01H, 00H, 00H, 00H, 0FH, 00H, 00H, 00H       ; 0180 _ ........
        db 08H, 00H, 00H, 00H, 10H, 00H, 00H, 00H       ; 0188 _ ........
        db 70H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0190 _ p.......
        db 0FH, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0198 _ ........
        db 10H, 00H, 00H, 00H, 70H, 00H, 00H, 00H       ; 01A0 _ ....p...
        db 00H, 00H, 00H, 00H, 0FH, 00H, 00H, 00H       ; 01A8 _ ........
        db 08H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 01B0 _ ........

?_210:                                                  ; byte
        db 70H, 61H, 63H, 6BH, 65H, 64H, 20H, 42H       ; 01B8 _ packed B
        db 43H, 44H, 20H, 72H, 65H, 71H, 75H, 69H       ; 01C0 _ CD requi
        db 72H, 65H, 73H, 20H, 61H, 6EH, 20H, 38H       ; 01C8 _ res an 8
        db 30H, 2DH, 62H, 69H, 74H, 20H, 66H, 6FH       ; 01D0 _ 0-bit fo
        db 72H, 6DH, 61H, 74H, 00H, 00H, 00H, 00H       ; 01D8 _ rmat....

?_211:                                                  ; byte
        db 70H, 61H, 63H, 6BH, 65H, 64H, 20H, 42H       ; 01E0 _ packed B
        db 43H, 44H, 20H, 74H, 72H, 75H, 6EH, 63H       ; 01E8 _ CD trunc
        db 61H, 74H, 65H, 64H, 20H, 74H, 6FH, 20H       ; 01F0 _ ated to 
        db 31H, 38H, 20H, 64H, 69H, 67H, 69H, 74H       ; 01F8 _ 18 digit
        db 73H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0200 _ s.......

?_212:                                                  ; byte
        db 69H, 6EH, 76H, 61H, 6CH, 69H, 64H, 20H       ; 0208 _ invalid 
        db 63H, 68H, 61H, 72H, 61H, 63H, 74H, 65H       ; 0210 _ characte
        db 72H, 20H, 60H, 25H, 63H, 27H, 20H, 69H       ; 0218 _ r `%c' i
        db 6EH, 20H, 70H, 61H, 63H, 6BH, 65H, 64H       ; 0220 _ n packed
        db 20H, 42H, 43H, 44H, 20H, 63H, 6FH, 6EH       ; 0228 _  BCD con
        db 73H, 74H, 61H, 6EH, 74H, 00H                 ; 0230 _ stant.

?_213:                                                  ; byte
        db 2EH, 2FH, 61H, 73H, 6DH, 2FH, 66H, 6CH       ; 0236 _ ./asm/fl
        db 6FH, 61H, 74H, 73H, 2EH, 63H, 00H            ; 023E _ oats.c.

?_214:                                                  ; byte
        db 73H, 74H, 72H, 5BH, 30H, 5DH, 00H, 00H       ; 0245 _ str[0]..
        db 00H, 00H, 00H                                ; 024D _ ...

?_215:                                                  ; byte
        db 69H, 6EH, 74H, 65H, 72H, 6EH, 61H, 6CH       ; 0250 _ internal
        db 20H, 65H, 72H, 72H, 6FH, 72H, 3AH, 20H       ; 0258 _  error: 
        db 75H, 6EH, 6BH, 6EH, 6FH, 77H, 6EH, 20H       ; 0260 _ unknown 
        db 46H, 50H, 20H, 63H, 6FH, 6EH, 73H, 74H       ; 0268 _ FP const
        db 61H, 6EH, 74H, 20H, 74H, 6FH, 6BH, 65H       ; 0270 _ ant toke
        db 6EH, 20H, 60H, 25H, 73H, 27H, 00H, 00H       ; 0278 _ n `%s'..

?_216:                                                  ; byte
        db 6FH, 76H, 65H, 72H, 66H, 6CH, 6FH, 77H       ; 0280 _ overflow
        db 20H, 69H, 6EH, 20H, 66H, 6CH, 6FH, 61H       ; 0288 _  in floa
        db 74H, 69H, 6EH, 67H, 2DH, 70H, 6FH, 69H       ; 0290 _ ting-poi
        db 6EH, 74H, 20H, 63H, 6FH, 6EH, 73H, 74H       ; 0298 _ nt const
        db 61H, 6EH, 74H, 00H, 00H, 00H, 00H, 00H       ; 02A0 _ ant.....

?_217:                                                  ; byte
        db 75H, 6EH, 64H, 65H, 72H, 66H, 6CH, 6FH       ; 02A8 _ underflo
        db 77H, 20H, 69H, 6EH, 20H, 66H, 6CH, 6FH       ; 02B0 _ w in flo
        db 61H, 74H, 69H, 6EH, 67H, 2DH, 70H, 6FH       ; 02B8 _ ating-po
        db 69H, 6EH, 74H, 20H, 63H, 6FH, 6EH, 73H       ; 02C0 _ int cons
        db 74H, 61H, 6EH, 74H, 00H, 00H, 00H, 00H       ; 02C8 _ tant....

?_218:                                                  ; byte
        db 64H, 65H, 6EH, 6FH, 72H, 6DH, 61H, 6CH       ; 02D0 _ denormal
        db 20H, 66H, 6CH, 6FH, 61H, 74H, 69H, 6EH       ; 02D8 _  floatin
        db 67H, 2DH, 70H, 6FH, 69H, 6EH, 74H, 20H       ; 02E0 _ g-point 
        db 63H, 6FH, 6EH, 73H, 74H, 61H, 6EH, 74H       ; 02E8 _ constant
        db 00H                                          ; 02F0 _ .

?_219:                                                  ; byte
        db 64H, 61H, 7AH, 00H                           ; 02F1 _ daz.

?_220:                                                  ; byte
        db 6EH, 6FH, 64H, 61H, 7AH, 00H                 ; 02F5 _ nodaz.

?_221:                                                  ; byte
        db 6EH, 65H, 61H, 72H, 00H                      ; 02FB _ near.

?_222:                                                  ; byte
        db 64H, 6FH, 77H, 6EH, 00H                      ; 0300 _ down.

?_223:                                                  ; byte
        db 75H, 70H, 00H                                ; 0305 _ up.

?_224:                                                  ; byte
        db 7AH, 65H, 72H, 6FH, 00H                      ; 0308 _ zero.

?_225:                                                  ; byte
        db 64H, 65H, 66H, 61H, 75H, 6CH, 74H, 00H       ; 030D _ default.
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0315 _ ........
        db 00H, 00H, 00H                                ; 031D _ ...

log2tbl.1:                                              ; zword
        db 0FFH, 0FFH, 0FFH, 0FFH, 00H, 00H, 00H, 00H   ; 0320 _ ........
        db 01H, 00H, 00H, 00H, 01H, 00H, 00H, 00H       ; 0328 _ ........
        db 02H, 00H, 00H, 00H, 02H, 00H, 00H, 00H       ; 0330 _ ........
        db 02H, 00H, 00H, 00H, 02H, 00H, 00H, 00H       ; 0338 _ ........
        db 03H, 00H, 00H, 00H, 03H, 00H, 00H, 00H       ; 0340 _ ........
        db 03H, 00H, 00H, 00H, 03H, 00H, 00H, 00H       ; 0348 _ ........
        db 03H, 00H, 00H, 00H, 03H, 00H, 00H, 00H       ; 0350 _ ........
        db 03H, 00H, 00H, 00H, 03H, 00H, 00H, 00H       ; 0358 _ ........

__func__.0:                                             ; byte
        db 66H, 6CH, 6FH, 61H, 74H, 5FH, 63H, 6FH       ; 0360 _ float_co
        db 6EH, 73H, 74H, 00H                           ; 0368 _ nst.


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
        dd nasm_hexval-$-20H                            ; 0020 _ 00000000 (rel)
        dd 00000031H, 100E4100H                         ; 0024 _ 49 269369600 
        dd 0D430286H, 070C6C06H                         ; 002C _ 222495366 118254598 
        dd 00000008H, 0000001CH                         ; 0034 _ 8 28 
        dd 0000003CH                                    ; 003C _ 60 
        dd nasm_hexval-$-0FH                            ; 0040 _ 00000000 (rel)
        dd 00000033H, 100E4100H                         ; 0044 _ 51 269369600 
        dd 0D430286H, 070C6E06H                         ; 004C _ 222495366 118255110 
        dd 00000008H, 0000001CH                         ; 0054 _ 8 28 
        dd 0000005CH                                    ; 005C _ 92 
        dd nasm_hexval-$+4H                             ; 0060 _ 00000000 (rel)
        dd 00000223H, 100E4100H                         ; 0064 _ 547 269369600 
        dd 0D430286H, 021E0306H                         ; 006C _ 222495366 35521286 
        dd 0008070CH, 0000001CH                         ; 0074 _ 526092 28 
        dd 0000007CH                                    ; 007C _ 124 
        dd nasm_hexval-$+207H                           ; 0080 _ 00000000 (rel)
        dd 000000F1H, 100E4100H                         ; 0084 _ 241 269369600 
        dd 0D430286H, 0CEC0206H                         ; 008C _ 222495366 216793606 
        dd 00000807H, 00000020H                         ; 0094 _ 2055 32 
        dd 0000009CH                                    ; 009C _ 156 
        dd nasm_hexval-$+2D8H                           ; 00A0 _ 00000000 (rel)
        dd 00000575H, 100E4100H                         ; 00A4 _ 1397 269369600 
        dd 0D430286H, 03834806H                         ; 00AC _ 222495366 58935302 
        dd 0C056803H, 00000807H                         ; 00B4 _ 201680899 2055 
        dd 0000001CH, 000000C0H                         ; 00BC _ 28 192 
        dd nasm_hexval-$+829H                           ; 00C4 _ 00000000 (rel)
        dd 0000004DH, 100E4100H                         ; 00C8 _ 77 269369600 
        dd 0D430286H, 0C480206H                         ; 00D0 _ 222495366 206045702 
        dd 00000807H, 0000001CH                         ; 00D8 _ 2055 28 
        dd 000000E0H                                    ; 00E0 _ 224 
        dd nasm_hexval-$+856H                           ; 00E4 _ 00000000 (rel)
        dd 00000039H, 100E4100H                         ; 00E8 _ 57 269369600 
        dd 0D430286H, 070C7406H                         ; 00F0 _ 222495366 118256646 
        dd 00000008H, 0000001CH                         ; 00F8 _ 8 28 
        dd 00000100H                                    ; 0100 _ 256 
        dd nasm_hexval-$+86FH                           ; 0104 _ 00000000 (rel)
        dd 00000043H, 100E4100H                         ; 0108 _ 67 269369600 
        dd 0D430286H, 070C7E06H                         ; 0110 _ 222495366 118259206 
        dd 00000008H, 0000001CH                         ; 0118 _ 8 28 
        dd 00000120H                                    ; 0120 _ 288 
        dd nasm_hexval-$+892H                           ; 0124 _ 00000000 (rel)
        dd 000005C2H, 100E4100H                         ; 0128 _ 1474 269369600 
        dd 0D430286H, 05BD0306H                         ; 0130 _ 222495366 96273158 
        dd 0008070CH, 0000001CH                         ; 0138 _ 526092 28 
        dd 00000140H                                    ; 0140 _ 320 
        dd nasm_hexval-$+0E34H                          ; 0144 _ 00000000 (rel)
        dd 00000289H, 100E4100H                         ; 0148 _ 649 269369600 
        dd 0D430286H, 02840306H                         ; 0150 _ 222495366 42205958 
        dd 0008070CH, 0000001CH                         ; 0158 _ 526092 28 
        dd 00000160H                                    ; 0160 _ 352 
        dd nasm_hexval-$+109DH                          ; 0164 _ 00000000 (rel)
        dd 00000187H, 100E4100H                         ; 0168 _ 391 269369600 
        dd 0D430286H, 01820306H                         ; 0170 _ 222495366 25297670 
        dd 0008070CH, 0000001CH                         ; 0178 _ 526092 28 
        dd 00000180H                                    ; 0180 _ 384 
        dd nasm_hexval-$+1204H                          ; 0184 _ 00000000 (rel)
        dd 00000180H, 100E4100H                         ; 0188 _ 384 269369600 
        dd 0D430286H, 017B0306H                         ; 0190 _ 222495366 24838918 
        dd 0008070CH, 0000001CH                         ; 0198 _ 526092 28 
        dd 000001A0H                                    ; 01A0 _ 416 
        dd nasm_hexval-$+1364H                          ; 01A4 _ 00000000 (rel)
        dd 00000909H, 100E4100H                         ; 01A8 _ 2313 269369600 
        dd 0D430286H, 09040306H                         ; 01B0 _ 222495366 151257862 
        dd 0008070CH, 0000001CH                         ; 01B8 _ 526092 28 
        dd 000001C0H                                    ; 01C0 _ 448 
        dd nasm_hexval-$+1C4DH                          ; 01C4 _ 00000000 (rel)
        dd 00000045H, 100E4100H                         ; 01C8 _ 69 269369600 
        dd 0D430286H, 0C400206H                         ; 01D0 _ 222495366 205521414 
        dd 00000807H, 00000020H                         ; 01D8 _ 2055 32 
        dd 000001E0H                                    ; 01E0 _ 480 
        dd nasm_hexval-$+1C72H                          ; 01E4 _ 00000000 (rel)
        dd 0000014DH, 100E4100H                         ; 01E8 _ 333 269369600 
        dd 0D430286H, 01480306H                         ; 01F0 _ 222495366 21496582 
        dd 0008070CH, 00000000H                         ; 01F8 _ 526092 0 


