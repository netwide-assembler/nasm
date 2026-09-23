; Disassembly of file: /tmp/tmp.8lIWhvWSXA.o
; Wed Sep 23 14:43:21 2026
; Type: ELF64
; Syntax: NASM
; Instruction set: 80386, x64

default rel

global string_transform: function

extern nasm_malloc                                      ; near


SECTION .text   align=1 exec                            ; section number 1, code

utf8_to_16le:; Local function
        push    rbp                                     ; 0000 _ 55
        mov     rbp, rsp                                ; 0001 _ 48: 89. E5
        mov     qword [rbp-48H], rdi                    ; 0004 _ 48: 89. 7D, B8
        mov     qword [rbp-50H], rsi                    ; 0008 _ 48: 89. 75, B0
        mov     qword [rbp-58H], rdx                    ; 000C _ 48: 89. 55, A8
        mov     qword [rbp-28H], 0                      ; 0010 _ 48: C7. 45, D8, 00000000
        mov     dword [rbp-34H], 0                      ; 0018 _ C7. 45, CC, 00000000
        mov     dword [rbp-30H], 0                      ; 001F _ C7. 45, D0, 00000000
        mov     dword [rbp-2CH], 0                      ; 0026 _ C7. 45, D4, 00000000
        jmp     ?_018                                   ; 002D _ E9, 00000225

?_001:  mov     rax, qword [rbp-48H]                    ; 0032 _ 48: 8B. 45, B8
        lea     rdx, [rax+1H]                           ; 0036 _ 48: 8D. 50, 01
        mov     qword [rbp-48H], rdx                    ; 003A _ 48: 89. 55, B8
        movzx   eax, byte [rax]                         ; 003E _ 0F B6. 00
        mov     byte [rbp-35H], al                      ; 0041 _ 88. 45, CB
        cmp     dword [rbp-34H], 0                      ; 0044 _ 83. 7D, CC, 00
        je      ?_009                                   ; 0048 _ 0F 84, 00000121
        movzx   eax, byte [rbp-35H]                     ; 004E _ 0F B6. 45, CB
        and     eax, 0C0H                               ; 0052 _ 25, 000000C0
        cmp     eax, 128                                ; 0057 _ 3D, 00000080
        jz      ?_002                                   ; 005C _ 74, 13
        mov     dword [rbp-34H], 0                      ; 005E _ C7. 45, CC, 00000000
        mov     rax, -1                                 ; 0065 _ 48: C7. C0, FFFFFFFF
        jmp     ?_020                                   ; 006C _ E9, 00000211

?_002:  mov     eax, dword [rbp-30H]                    ; 0071 _ 8B. 45, D0
        shl     eax, 6                                  ; 0074 _ C1. E0, 06
        mov     edx, eax                                ; 0077 _ 89. C2
        movzx   eax, byte [rbp-35H]                     ; 0079 _ 0F B6. 45, CB
        and     eax, 3FH                                ; 007D _ 83. E0, 3F
        or      eax, edx                                ; 0080 _ 09. D0
        mov     dword [rbp-30H], eax                    ; 0082 _ 89. 45, D0
        sub     dword [rbp-34H], 1                      ; 0085 _ 83. 6D, CC, 01
        cmp     dword [rbp-34H], 0                      ; 0089 _ 83. 7D, CC, 00
        jne     ?_018                                   ; 008D _ 0F 85, 000001C4
        mov     eax, dword [rbp-30H]                    ; 0093 _ 8B. 45, D0
        cmp     eax, dword [rbp-2CH]                    ; 0096 _ 3B. 45, D4
        jc      ?_003                                   ; 0099 _ 72, 1B
        cmp     dword [rbp-30H], 1114111                ; 009B _ 81. 7D, D0, 0010FFFF
        ja      ?_003                                   ; 00A2 _ 77, 12
        cmp     dword [rbp-30H], 55295                  ; 00A4 _ 81. 7D, D0, 0000D7FF
        jbe     ?_004                                   ; 00AB _ 76, 15
        cmp     dword [rbp-30H], 57343                  ; 00AD _ 81. 7D, D0, 0000DFFF
        ja      ?_004                                   ; 00B4 _ 77, 0C
?_003:  mov     rax, -1                                 ; 00B6 _ 48: C7. C0, FFFFFFFF
        jmp     ?_020                                   ; 00BD _ E9, 000001C0

?_004:  cmp     dword [rbp-30H], 65535                  ; 00C2 _ 81. 7D, D0, 0000FFFF
        jbe     ?_007                                   ; 00C9 _ 76, 73
        sub     dword [rbp-30H], 65536                  ; 00CB _ 81. 6D, D0, 00010000
        cmp     qword [rbp-58H], 0                      ; 00D2 _ 48: 83. 7D, A8, 00
        jz      ?_005                                   ; 00D7 _ 74, 27
        mov     rax, qword [rbp-58H]                    ; 00D9 _ 48: 8B. 45, A8
        mov     qword [rbp-10H], rax                    ; 00DD _ 48: 89. 45, F0
        mov     eax, dword [rbp-30H]                    ; 00E1 _ 8B. 45, D0
        shr     eax, 10                                 ; 00E4 _ C1. E8, 0A
; Note: Length-changing prefix causes delay on old Intel processors
        or      ax, 0D800H                              ; 00E7 _ 66: 0D, D800
        mov     edx, eax                                ; 00EB _ 89. C2
        mov     rax, qword [rbp-10H]                    ; 00ED _ 48: 8B. 45, F0
        mov     word [rax], dx                          ; 00F1 _ 66: 89. 10
        mov     rax, qword [rbp-10H]                    ; 00F4 _ 48: 8B. 45, F0
        add     rax, 2                                  ; 00F8 _ 48: 83. C0, 02
        mov     qword [rbp-58H], rax                    ; 00FC _ 48: 89. 45, A8
?_005:  add     qword [rbp-28H], 1                      ; 0100 _ 48: 83. 45, D8, 01
        cmp     qword [rbp-58H], 0                      ; 0105 _ 48: 83. 7D, A8, 00
        jz      ?_006                                   ; 010A _ 74, 28
        mov     rax, qword [rbp-58H]                    ; 010C _ 48: 8B. 45, A8
        mov     qword [rbp-8H], rax                     ; 0110 _ 48: 89. 45, F8
        mov     eax, dword [rbp-30H]                    ; 0114 _ 8B. 45, D0
; Note: Length-changing prefix causes delay on old Intel processors
        and     ax, 3FFH                                ; 0117 _ 66: 25, 03FF
; Note: Length-changing prefix causes delay on old Intel processors
        or      ax, 0DC00H                              ; 011B _ 66: 0D, DC00
        mov     edx, eax                                ; 011F _ 89. C2
        mov     rax, qword [rbp-8H]                     ; 0121 _ 48: 8B. 45, F8
        mov     word [rax], dx                          ; 0125 _ 66: 89. 10
        mov     rax, qword [rbp-8H]                     ; 0128 _ 48: 8B. 45, F8
        add     rax, 2                                  ; 012C _ 48: 83. C0, 02
        mov     qword [rbp-58H], rax                    ; 0130 _ 48: 89. 45, A8
?_006:  add     qword [rbp-28H], 1                      ; 0134 _ 48: 83. 45, D8, 01
        jmp     ?_018                                   ; 0139 _ E9, 00000119

?_007:  cmp     qword [rbp-58H], 0                      ; 013E _ 48: 83. 7D, A8, 00
        jz      ?_008                                   ; 0143 _ 74, 20
        mov     rax, qword [rbp-58H]                    ; 0145 _ 48: 8B. 45, A8
        mov     qword [rbp-18H], rax                    ; 0149 _ 48: 89. 45, E8
        mov     eax, dword [rbp-30H]                    ; 014D _ 8B. 45, D0
        mov     edx, eax                                ; 0150 _ 89. C2
        mov     rax, qword [rbp-18H]                    ; 0152 _ 48: 8B. 45, E8
        mov     word [rax], dx                          ; 0156 _ 66: 89. 10
        mov     rax, qword [rbp-18H]                    ; 0159 _ 48: 8B. 45, E8
        add     rax, 2                                  ; 015D _ 48: 83. C0, 02
        mov     qword [rbp-58H], rax                    ; 0161 _ 48: 89. 45, A8
?_008:  add     qword [rbp-28H], 1                      ; 0165 _ 48: 83. 45, D8, 01
        jmp     ?_018                                   ; 016A _ E9, 000000E8

?_009:  movzx   eax, byte [rbp-35H]                     ; 016F _ 0F B6. 45, CB
        test    al, al                                  ; 0173 _ 84. C0
        js      ?_011                                   ; 0175 _ 78, 30
        cmp     qword [rbp-58H], 0                      ; 0177 _ 48: 83. 7D, A8, 00
        jz      ?_010                                   ; 017C _ 74, 1F
        mov     rax, qword [rbp-58H]                    ; 017E _ 48: 8B. 45, A8
        mov     qword [rbp-20H], rax                    ; 0182 _ 48: 89. 45, E0
        movzx   edx, byte [rbp-35H]                     ; 0186 _ 0F B6. 55, CB
        mov     rax, qword [rbp-20H]                    ; 018A _ 48: 8B. 45, E0
        mov     word [rax], dx                          ; 018E _ 66: 89. 10
        mov     rax, qword [rbp-20H]                    ; 0191 _ 48: 8B. 45, E0
        add     rax, 2                                  ; 0195 _ 48: 83. C0, 02
        mov     qword [rbp-58H], rax                    ; 0199 _ 48: 89. 45, A8
?_010:  add     qword [rbp-28H], 1                      ; 019D _ 48: 83. 45, D8, 01
        jmp     ?_018                                   ; 01A2 _ E9, 000000B0

?_011:  cmp     byte [rbp-35H], 191                     ; 01A7 _ 80. 7D, CB, BF
        jbe     ?_012                                   ; 01AB _ 76, 06
        cmp     byte [rbp-35H], 253                     ; 01AD _ 80. 7D, CB, FD
        jbe     ?_013                                   ; 01B1 _ 76, 0C
?_012:  mov     rax, -1                                 ; 01B3 _ 48: C7. C0, FFFFFFFF
        jmp     ?_020                                   ; 01BA _ E9, 000000C3

?_013:  cmp     byte [rbp-35H], 223                     ; 01BF _ 80. 7D, CB, DF
        ja      ?_014                                   ; 01C3 _ 77, 1A
        movzx   eax, byte [rbp-35H]                     ; 01C5 _ 0F B6. 45, CB
        and     eax, 1FH                                ; 01C9 _ 83. E0, 1F
        mov     dword [rbp-30H], eax                    ; 01CC _ 89. 45, D0
        mov     dword [rbp-34H], 1                      ; 01CF _ C7. 45, CC, 00000001
        mov     dword [rbp-2CH], 128                    ; 01D6 _ C7. 45, D4, 00000080
        jmp     ?_018                                   ; 01DD _ EB, 78

?_014:  cmp     byte [rbp-35H], 239                     ; 01DF _ 80. 7D, CB, EF
        ja      ?_015                                   ; 01E3 _ 77, 1A
        movzx   eax, byte [rbp-35H]                     ; 01E5 _ 0F B6. 45, CB
        and     eax, 0FH                                ; 01E9 _ 83. E0, 0F
        mov     dword [rbp-30H], eax                    ; 01EC _ 89. 45, D0
        mov     dword [rbp-34H], 2                      ; 01EF _ C7. 45, CC, 00000002
        mov     dword [rbp-2CH], 2048                   ; 01F6 _ C7. 45, D4, 00000800
        jmp     ?_018                                   ; 01FD _ EB, 58

?_015:  cmp     byte [rbp-35H], 247                     ; 01FF _ 80. 7D, CB, F7
        ja      ?_016                                   ; 0203 _ 77, 1A
        movzx   eax, byte [rbp-35H]                     ; 0205 _ 0F B6. 45, CB
        and     eax, 07H                                ; 0209 _ 83. E0, 07
        mov     dword [rbp-30H], eax                    ; 020C _ 89. 45, D0
        mov     dword [rbp-34H], 3                      ; 020F _ C7. 45, CC, 00000003
        mov     dword [rbp-2CH], 65536                  ; 0216 _ C7. 45, D4, 00010000
        jmp     ?_018                                   ; 021D _ EB, 38

?_016:  cmp     byte [rbp-35H], 251                     ; 021F _ 80. 7D, CB, FB
        ja      ?_017                                   ; 0223 _ 77, 1A
        movzx   eax, byte [rbp-35H]                     ; 0225 _ 0F B6. 45, CB
        and     eax, 03H                                ; 0229 _ 83. E0, 03
        mov     dword [rbp-30H], eax                    ; 022C _ 89. 45, D0
        mov     dword [rbp-34H], 4                      ; 022F _ C7. 45, CC, 00000004
        mov     dword [rbp-2CH], 2097152                ; 0236 _ C7. 45, D4, 00200000
        jmp     ?_018                                   ; 023D _ EB, 18

?_017:  movzx   eax, byte [rbp-35H]                     ; 023F _ 0F B6. 45, CB
        and     eax, 01H                                ; 0243 _ 83. E0, 01
        mov     dword [rbp-30H], eax                    ; 0246 _ 89. 45, D0
        mov     dword [rbp-34H], 5                      ; 0249 _ C7. 45, CC, 00000005
        mov     dword [rbp-2CH], 67108864               ; 0250 _ C7. 45, D4, 04000000
?_018:  mov     rax, qword [rbp-50H]                    ; 0257 _ 48: 8B. 45, B0
        lea     rdx, [rax-1H]                           ; 025B _ 48: 8D. 50, FF
        mov     qword [rbp-50H], rdx                    ; 025F _ 48: 89. 55, B0
        test    rax, rax                                ; 0263 _ 48: 85. C0
        jne     ?_001                                   ; 0266 _ 0F 85, FFFFFDC6
        cmp     dword [rbp-34H], 0                      ; 026C _ 83. 7D, CC, 00
        jnz     ?_019                                   ; 0270 _ 75, 09
        mov     rax, qword [rbp-28H]                    ; 0272 _ 48: 8B. 45, D8
        add     rax, rax                                ; 0276 _ 48: 01. C0
        jmp     ?_020                                   ; 0279 _ EB, 07

?_019:  mov     rax, -1                                 ; 027B _ 48: C7. C0, FFFFFFFF
?_020:  pop     rbp                                     ; 0282 _ 5D
        ret                                             ; 0283 _ C3

utf8_to_16be:; Local function
        push    rbp                                     ; 0284 _ 55
        mov     rbp, rsp                                ; 0285 _ 48: 89. E5
        mov     qword [rbp-68H], rdi                    ; 0288 _ 48: 89. 7D, 98
        mov     qword [rbp-70H], rsi                    ; 028C _ 48: 89. 75, 90
        mov     qword [rbp-78H], rdx                    ; 0290 _ 48: 89. 55, 88
        mov     qword [rbp-48H], 0                      ; 0294 _ 48: C7. 45, B8, 00000000
        mov     dword [rbp-54H], 0                      ; 029C _ C7. 45, AC, 00000000
        mov     dword [rbp-50H], 0                      ; 02A3 _ C7. 45, B0, 00000000
        mov     dword [rbp-4CH], 0                      ; 02AA _ C7. 45, B4, 00000000
        jmp     ?_038                                   ; 02B1 _ E9, 000002D7

?_021:  mov     rax, qword [rbp-68H]                    ; 02B6 _ 48: 8B. 45, 98
        lea     rdx, [rax+1H]                           ; 02BA _ 48: 8D. 50, 01
        mov     qword [rbp-68H], rdx                    ; 02BE _ 48: 89. 55, 98
        movzx   eax, byte [rax]                         ; 02C2 _ 0F B6. 00
        mov     byte [rbp-5DH], al                      ; 02C5 _ 88. 45, A3
        cmp     dword [rbp-54H], 0                      ; 02C8 _ 83. 7D, AC, 00
        je      ?_029                                   ; 02CC _ 0F 84, 000001A6
        movzx   eax, byte [rbp-5DH]                     ; 02D2 _ 0F B6. 45, A3
        and     eax, 0C0H                               ; 02D6 _ 25, 000000C0
        cmp     eax, 128                                ; 02DB _ 3D, 00000080
        jz      ?_022                                   ; 02E0 _ 74, 13
        mov     dword [rbp-54H], 0                      ; 02E2 _ C7. 45, AC, 00000000
        mov     rax, -1                                 ; 02E9 _ 48: C7. C0, FFFFFFFF
        jmp     ?_040                                   ; 02F0 _ E9, 000002C3

?_022:  mov     eax, dword [rbp-50H]                    ; 02F5 _ 8B. 45, B0
        shl     eax, 6                                  ; 02F8 _ C1. E0, 06
        mov     edx, eax                                ; 02FB _ 89. C2
        movzx   eax, byte [rbp-5DH]                     ; 02FD _ 0F B6. 45, A3
        and     eax, 3FH                                ; 0301 _ 83. E0, 3F
        or      eax, edx                                ; 0304 _ 09. D0
        mov     dword [rbp-50H], eax                    ; 0306 _ 89. 45, B0
        sub     dword [rbp-54H], 1                      ; 0309 _ 83. 6D, AC, 01
        cmp     dword [rbp-54H], 0                      ; 030D _ 83. 7D, AC, 00
        jne     ?_038                                   ; 0311 _ 0F 85, 00000276
        mov     eax, dword [rbp-50H]                    ; 0317 _ 8B. 45, B0
        cmp     eax, dword [rbp-4CH]                    ; 031A _ 3B. 45, B4
        jc      ?_023                                   ; 031D _ 72, 1B
        cmp     dword [rbp-50H], 1114111                ; 031F _ 81. 7D, B0, 0010FFFF
        ja      ?_023                                   ; 0326 _ 77, 12
        cmp     dword [rbp-50H], 55295                  ; 0328 _ 81. 7D, B0, 0000D7FF
        jbe     ?_024                                   ; 032F _ 76, 15
        cmp     dword [rbp-50H], 57343                  ; 0331 _ 81. 7D, B0, 0000DFFF
        ja      ?_024                                   ; 0338 _ 77, 0C
?_023:  mov     rax, -1                                 ; 033A _ 48: C7. C0, FFFFFFFF
        jmp     ?_040                                   ; 0341 _ E9, 00000272

?_024:  cmp     dword [rbp-50H], 65535                  ; 0346 _ 81. 7D, B0, 0000FFFF
        jbe     ?_027                                   ; 034D _ 0F 86, 000000C9
        sub     dword [rbp-50H], 65536                  ; 0353 _ 81. 6D, B0, 00010000
        mov     eax, dword [rbp-50H]                    ; 035A _ 8B. 45, B0
; Note: Length-changing prefix causes delay on old Intel processors
        and     ax, 3FFH                                ; 035D _ 66: 25, 03FF
; Note: Length-changing prefix causes delay on old Intel processors
        or      ax, 0DC00H                              ; 0361 _ 66: 0D, DC00
        mov     word [rbp-58H], ax                      ; 0365 _ 66: 89. 45, A8
        cmp     qword [rbp-78H], 0                      ; 0369 _ 48: 83. 7D, 88, 00
        jz      ?_025                                   ; 036E _ 74, 44
        mov     rax, qword [rbp-78H]                    ; 0370 _ 48: 8B. 45, 88
        mov     qword [rbp-20H], rax                    ; 0374 _ 48: 89. 45, E0
        movzx   eax, word [rbp-58H]                     ; 0378 _ 0F B7. 45, A8
        shr     ax, 8                                   ; 037C _ 66: C1. E8, 08
        mov     edx, eax                                ; 0380 _ 89. C2
        mov     rax, qword [rbp-20H]                    ; 0382 _ 48: 8B. 45, E0
        mov     byte [rax], dl                          ; 0386 _ 88. 10
        mov     rax, qword [rbp-20H]                    ; 0388 _ 48: 8B. 45, E0
        add     rax, 1                                  ; 038C _ 48: 83. C0, 01
        mov     qword [rbp-78H], rax                    ; 0390 _ 48: 89. 45, 88
        mov     rax, qword [rbp-78H]                    ; 0394 _ 48: 8B. 45, 88
        mov     qword [rbp-18H], rax                    ; 0398 _ 48: 89. 45, E8
        movzx   eax, word [rbp-58H]                     ; 039C _ 0F B7. 45, A8
        mov     edx, eax                                ; 03A0 _ 89. C2
        mov     rax, qword [rbp-18H]                    ; 03A2 _ 48: 8B. 45, E8
        mov     byte [rax], dl                          ; 03A6 _ 88. 10
        mov     rax, qword [rbp-18H]                    ; 03A8 _ 48: 8B. 45, E8
        add     rax, 1                                  ; 03AC _ 48: 83. C0, 01
        mov     qword [rbp-78H], rax                    ; 03B0 _ 48: 89. 45, 88
?_025:  add     qword [rbp-48H], 1                      ; 03B4 _ 48: 83. 45, B8, 01
        mov     eax, dword [rbp-50H]                    ; 03B9 _ 8B. 45, B0
        shr     eax, 10                                 ; 03BC _ C1. E8, 0A
; Note: Length-changing prefix causes delay on old Intel processors
        or      ax, 0D800H                              ; 03BF _ 66: 0D, D800
        mov     word [rbp-56H], ax                      ; 03C3 _ 66: 89. 45, AA
        cmp     qword [rbp-78H], 0                      ; 03C7 _ 48: 83. 7D, 88, 00
        jz      ?_026                                   ; 03CC _ 74, 44
        mov     rax, qword [rbp-78H]                    ; 03CE _ 48: 8B. 45, 88
        mov     qword [rbp-10H], rax                    ; 03D2 _ 48: 89. 45, F0
        movzx   eax, word [rbp-56H]                     ; 03D6 _ 0F B7. 45, AA
        shr     ax, 8                                   ; 03DA _ 66: C1. E8, 08
        mov     edx, eax                                ; 03DE _ 89. C2
        mov     rax, qword [rbp-10H]                    ; 03E0 _ 48: 8B. 45, F0
        mov     byte [rax], dl                          ; 03E4 _ 88. 10
        mov     rax, qword [rbp-10H]                    ; 03E6 _ 48: 8B. 45, F0
        add     rax, 1                                  ; 03EA _ 48: 83. C0, 01
        mov     qword [rbp-78H], rax                    ; 03EE _ 48: 89. 45, 88
        mov     rax, qword [rbp-78H]                    ; 03F2 _ 48: 8B. 45, 88
        mov     qword [rbp-8H], rax                     ; 03F6 _ 48: 89. 45, F8
        movzx   eax, word [rbp-56H]                     ; 03FA _ 0F B7. 45, AA
        mov     edx, eax                                ; 03FE _ 89. C2
        mov     rax, qword [rbp-8H]                     ; 0400 _ 48: 8B. 45, F8
        mov     byte [rax], dl                          ; 0404 _ 88. 10
        mov     rax, qword [rbp-8H]                     ; 0406 _ 48: 8B. 45, F8
        add     rax, 1                                  ; 040A _ 48: 83. C0, 01
        mov     qword [rbp-78H], rax                    ; 040E _ 48: 89. 45, 88
?_026:  add     qword [rbp-48H], 1                      ; 0412 _ 48: 83. 45, B8, 01
        jmp     ?_038                                   ; 0417 _ E9, 00000171

?_027:  mov     eax, dword [rbp-50H]                    ; 041C _ 8B. 45, B0
        mov     word [rbp-5AH], ax                      ; 041F _ 66: 89. 45, A6
        cmp     qword [rbp-78H], 0                      ; 0423 _ 48: 83. 7D, 88, 00
        jz      ?_028                                   ; 0428 _ 74, 44
        mov     rax, qword [rbp-78H]                    ; 042A _ 48: 8B. 45, 88
        mov     qword [rbp-30H], rax                    ; 042E _ 48: 89. 45, D0
        movzx   eax, word [rbp-5AH]                     ; 0432 _ 0F B7. 45, A6
        shr     ax, 8                                   ; 0436 _ 66: C1. E8, 08
        mov     edx, eax                                ; 043A _ 89. C2
        mov     rax, qword [rbp-30H]                    ; 043C _ 48: 8B. 45, D0
        mov     byte [rax], dl                          ; 0440 _ 88. 10
        mov     rax, qword [rbp-30H]                    ; 0442 _ 48: 8B. 45, D0
        add     rax, 1                                  ; 0446 _ 48: 83. C0, 01
        mov     qword [rbp-78H], rax                    ; 044A _ 48: 89. 45, 88
        mov     rax, qword [rbp-78H]                    ; 044E _ 48: 8B. 45, 88
        mov     qword [rbp-28H], rax                    ; 0452 _ 48: 89. 45, D8
        movzx   eax, word [rbp-5AH]                     ; 0456 _ 0F B7. 45, A6
        mov     edx, eax                                ; 045A _ 89. C2
        mov     rax, qword [rbp-28H]                    ; 045C _ 48: 8B. 45, D8
        mov     byte [rax], dl                          ; 0460 _ 88. 10
        mov     rax, qword [rbp-28H]                    ; 0462 _ 48: 8B. 45, D8
        add     rax, 1                                  ; 0466 _ 48: 83. C0, 01
        mov     qword [rbp-78H], rax                    ; 046A _ 48: 89. 45, 88
?_028:  add     qword [rbp-48H], 1                      ; 046E _ 48: 83. 45, B8, 01
        jmp     ?_038                                   ; 0473 _ E9, 00000115

?_029:  movzx   eax, byte [rbp-5DH]                     ; 0478 _ 0F B6. 45, A3
        test    al, al                                  ; 047C _ 84. C0
        js      ?_031                                   ; 047E _ 78, 5D
        movzx   eax, byte [rbp-5DH]                     ; 0480 _ 0F B6. 45, A3
        mov     word [rbp-5CH], ax                      ; 0484 _ 66: 89. 45, A4
        cmp     qword [rbp-78H], 0                      ; 0488 _ 48: 83. 7D, 88, 00
        jz      ?_030                                   ; 048D _ 74, 44
        mov     rax, qword [rbp-78H]                    ; 048F _ 48: 8B. 45, 88
        mov     qword [rbp-40H], rax                    ; 0493 _ 48: 89. 45, C0
        movzx   eax, word [rbp-5CH]                     ; 0497 _ 0F B7. 45, A4
        shr     ax, 8                                   ; 049B _ 66: C1. E8, 08
        mov     edx, eax                                ; 049F _ 89. C2
        mov     rax, qword [rbp-40H]                    ; 04A1 _ 48: 8B. 45, C0
        mov     byte [rax], dl                          ; 04A5 _ 88. 10
        mov     rax, qword [rbp-40H]                    ; 04A7 _ 48: 8B. 45, C0
        add     rax, 1                                  ; 04AB _ 48: 83. C0, 01
        mov     qword [rbp-78H], rax                    ; 04AF _ 48: 89. 45, 88
        mov     rax, qword [rbp-78H]                    ; 04B3 _ 48: 8B. 45, 88
        mov     qword [rbp-38H], rax                    ; 04B7 _ 48: 89. 45, C8
        movzx   eax, word [rbp-5CH]                     ; 04BB _ 0F B7. 45, A4
        mov     edx, eax                                ; 04BF _ 89. C2
        mov     rax, qword [rbp-38H]                    ; 04C1 _ 48: 8B. 45, C8
        mov     byte [rax], dl                          ; 04C5 _ 88. 10
        mov     rax, qword [rbp-38H]                    ; 04C7 _ 48: 8B. 45, C8
        add     rax, 1                                  ; 04CB _ 48: 83. C0, 01
        mov     qword [rbp-78H], rax                    ; 04CF _ 48: 89. 45, 88
?_030:  add     qword [rbp-48H], 1                      ; 04D3 _ 48: 83. 45, B8, 01
        jmp     ?_038                                   ; 04D8 _ E9, 000000B0

?_031:  cmp     byte [rbp-5DH], 191                     ; 04DD _ 80. 7D, A3, BF
        jbe     ?_032                                   ; 04E1 _ 76, 06
        cmp     byte [rbp-5DH], 253                     ; 04E3 _ 80. 7D, A3, FD
        jbe     ?_033                                   ; 04E7 _ 76, 0C
?_032:  mov     rax, -1                                 ; 04E9 _ 48: C7. C0, FFFFFFFF
        jmp     ?_040                                   ; 04F0 _ E9, 000000C3

?_033:  cmp     byte [rbp-5DH], 223                     ; 04F5 _ 80. 7D, A3, DF
        ja      ?_034                                   ; 04F9 _ 77, 1A
        movzx   eax, byte [rbp-5DH]                     ; 04FB _ 0F B6. 45, A3
        and     eax, 1FH                                ; 04FF _ 83. E0, 1F
        mov     dword [rbp-50H], eax                    ; 0502 _ 89. 45, B0
        mov     dword [rbp-54H], 1                      ; 0505 _ C7. 45, AC, 00000001
        mov     dword [rbp-4CH], 128                    ; 050C _ C7. 45, B4, 00000080
        jmp     ?_038                                   ; 0513 _ EB, 78

?_034:  cmp     byte [rbp-5DH], 239                     ; 0515 _ 80. 7D, A3, EF
        ja      ?_035                                   ; 0519 _ 77, 1A
        movzx   eax, byte [rbp-5DH]                     ; 051B _ 0F B6. 45, A3
        and     eax, 0FH                                ; 051F _ 83. E0, 0F
        mov     dword [rbp-50H], eax                    ; 0522 _ 89. 45, B0
        mov     dword [rbp-54H], 2                      ; 0525 _ C7. 45, AC, 00000002
        mov     dword [rbp-4CH], 2048                   ; 052C _ C7. 45, B4, 00000800
        jmp     ?_038                                   ; 0533 _ EB, 58

?_035:  cmp     byte [rbp-5DH], 247                     ; 0535 _ 80. 7D, A3, F7
        ja      ?_036                                   ; 0539 _ 77, 1A
        movzx   eax, byte [rbp-5DH]                     ; 053B _ 0F B6. 45, A3
        and     eax, 07H                                ; 053F _ 83. E0, 07
        mov     dword [rbp-50H], eax                    ; 0542 _ 89. 45, B0
        mov     dword [rbp-54H], 3                      ; 0545 _ C7. 45, AC, 00000003
        mov     dword [rbp-4CH], 65536                  ; 054C _ C7. 45, B4, 00010000
        jmp     ?_038                                   ; 0553 _ EB, 38

?_036:  cmp     byte [rbp-5DH], 251                     ; 0555 _ 80. 7D, A3, FB
        ja      ?_037                                   ; 0559 _ 77, 1A
        movzx   eax, byte [rbp-5DH]                     ; 055B _ 0F B6. 45, A3
        and     eax, 03H                                ; 055F _ 83. E0, 03
        mov     dword [rbp-50H], eax                    ; 0562 _ 89. 45, B0
        mov     dword [rbp-54H], 4                      ; 0565 _ C7. 45, AC, 00000004
        mov     dword [rbp-4CH], 2097152                ; 056C _ C7. 45, B4, 00200000
        jmp     ?_038                                   ; 0573 _ EB, 18

?_037:  movzx   eax, byte [rbp-5DH]                     ; 0575 _ 0F B6. 45, A3
        and     eax, 01H                                ; 0579 _ 83. E0, 01
        mov     dword [rbp-50H], eax                    ; 057C _ 89. 45, B0
        mov     dword [rbp-54H], 5                      ; 057F _ C7. 45, AC, 00000005
        mov     dword [rbp-4CH], 67108864               ; 0586 _ C7. 45, B4, 04000000
?_038:  mov     rax, qword [rbp-70H]                    ; 058D _ 48: 8B. 45, 90
        lea     rdx, [rax-1H]                           ; 0591 _ 48: 8D. 50, FF
        mov     qword [rbp-70H], rdx                    ; 0595 _ 48: 89. 55, 90
        test    rax, rax                                ; 0599 _ 48: 85. C0
        jne     ?_021                                   ; 059C _ 0F 85, FFFFFD14
        cmp     dword [rbp-54H], 0                      ; 05A2 _ 83. 7D, AC, 00
        jnz     ?_039                                   ; 05A6 _ 75, 09
        mov     rax, qword [rbp-48H]                    ; 05A8 _ 48: 8B. 45, B8
        add     rax, rax                                ; 05AC _ 48: 01. C0
        jmp     ?_040                                   ; 05AF _ EB, 07

?_039:  mov     rax, -1                                 ; 05B1 _ 48: C7. C0, FFFFFFFF
?_040:  pop     rbp                                     ; 05B8 _ 5D
        ret                                             ; 05B9 _ C3

utf8_to_32le:; Local function
        push    rbp                                     ; 05BA _ 55
        mov     rbp, rsp                                ; 05BB _ 48: 89. E5
        mov     qword [rbp-38H], rdi                    ; 05BE _ 48: 89. 7D, C8
        mov     qword [rbp-40H], rsi                    ; 05C2 _ 48: 89. 75, C0
        mov     qword [rbp-48H], rdx                    ; 05C6 _ 48: 89. 55, B8
        mov     qword [rbp-18H], 0                      ; 05CA _ 48: C7. 45, E8, 00000000
        mov     dword [rbp-24H], 0                      ; 05D2 _ C7. 45, DC, 00000000
        mov     dword [rbp-20H], 0                      ; 05D9 _ C7. 45, E0, 00000000
        mov     dword [rbp-1CH], 0                      ; 05E0 _ C7. 45, E4, 00000000
        jmp     ?_055                                   ; 05E7 _ E9, 00000195

?_041:  mov     rax, qword [rbp-38H]                    ; 05EC _ 48: 8B. 45, C8
        lea     rdx, [rax+1H]                           ; 05F0 _ 48: 8D. 50, 01
        mov     qword [rbp-38H], rdx                    ; 05F4 _ 48: 89. 55, C8
        movzx   eax, byte [rax]                         ; 05F8 _ 0F B6. 00
        mov     byte [rbp-25H], al                      ; 05FB _ 88. 45, DB
        cmp     dword [rbp-24H], 0                      ; 05FE _ 83. 7D, DC, 00
        je      ?_046                                   ; 0602 _ 0F 84, 00000092
        movzx   eax, byte [rbp-25H]                     ; 0608 _ 0F B6. 45, DB
        and     eax, 0C0H                               ; 060C _ 25, 000000C0
        cmp     eax, 128                                ; 0611 _ 3D, 00000080
        jz      ?_042                                   ; 0616 _ 74, 0C
        mov     rax, -1                                 ; 0618 _ 48: C7. C0, FFFFFFFF
        jmp     ?_057                                   ; 061F _ E9, 00000189

?_042:  mov     eax, dword [rbp-20H]                    ; 0624 _ 8B. 45, E0
        shl     eax, 6                                  ; 0627 _ C1. E0, 06
        mov     edx, eax                                ; 062A _ 89. C2
        movzx   eax, byte [rbp-25H]                     ; 062C _ 0F B6. 45, DB
        and     eax, 3FH                                ; 0630 _ 83. E0, 3F
        or      eax, edx                                ; 0633 _ 09. D0
        mov     dword [rbp-20H], eax                    ; 0635 _ 89. 45, E0
        sub     dword [rbp-24H], 1                      ; 0638 _ 83. 6D, DC, 01
        cmp     dword [rbp-24H], 0                      ; 063C _ 83. 7D, DC, 00
        jne     ?_055                                   ; 0640 _ 0F 85, 0000013B
        mov     eax, dword [rbp-20H]                    ; 0646 _ 8B. 45, E0
        cmp     eax, dword [rbp-1CH]                    ; 0649 _ 3B. 45, E4
        jc      ?_043                                   ; 064C _ 72, 12
        cmp     dword [rbp-20H], 55295                  ; 064E _ 81. 7D, E0, 0000D7FF
        jbe     ?_044                                   ; 0655 _ 76, 15
        cmp     dword [rbp-20H], 57343                  ; 0657 _ 81. 7D, E0, 0000DFFF
        ja      ?_044                                   ; 065E _ 77, 0C
?_043:  mov     rax, -1                                 ; 0660 _ 48: C7. C0, FFFFFFFF
        jmp     ?_057                                   ; 0667 _ E9, 00000141

?_044:  cmp     qword [rbp-48H], 0                      ; 066C _ 48: 83. 7D, B8, 00
        jz      ?_045                                   ; 0671 _ 74, 1D
        mov     rax, qword [rbp-48H]                    ; 0673 _ 48: 8B. 45, B8
        mov     qword [rbp-8H], rax                     ; 0677 _ 48: 89. 45, F8
        mov     rax, qword [rbp-8H]                     ; 067B _ 48: 8B. 45, F8
        mov     edx, dword [rbp-20H]                    ; 067F _ 8B. 55, E0
        mov     dword [rax], edx                        ; 0682 _ 89. 10
        mov     rax, qword [rbp-8H]                     ; 0684 _ 48: 8B. 45, F8
        add     rax, 4                                  ; 0688 _ 48: 83. C0, 04
        mov     qword [rbp-48H], rax                    ; 068C _ 48: 89. 45, B8
?_045:  add     qword [rbp-18H], 1                      ; 0690 _ 48: 83. 45, E8, 01
        jmp     ?_055                                   ; 0695 _ E9, 000000E7

?_046:  movzx   eax, byte [rbp-25H]                     ; 069A _ 0F B6. 45, DB
        test    al, al                                  ; 069E _ 84. C0
        js      ?_048                                   ; 06A0 _ 78, 2F
        cmp     qword [rbp-48H], 0                      ; 06A2 _ 48: 83. 7D, B8, 00
        jz      ?_047                                   ; 06A7 _ 74, 1E
        mov     rax, qword [rbp-48H]                    ; 06A9 _ 48: 8B. 45, B8
        mov     qword [rbp-10H], rax                    ; 06AD _ 48: 89. 45, F0
        movzx   edx, byte [rbp-25H]                     ; 06B1 _ 0F B6. 55, DB
        mov     rax, qword [rbp-10H]                    ; 06B5 _ 48: 8B. 45, F0
        mov     dword [rax], edx                        ; 06B9 _ 89. 10
        mov     rax, qword [rbp-10H]                    ; 06BB _ 48: 8B. 45, F0
        add     rax, 4                                  ; 06BF _ 48: 83. C0, 04
        mov     qword [rbp-48H], rax                    ; 06C3 _ 48: 89. 45, B8
?_047:  add     qword [rbp-18H], 1                      ; 06C7 _ 48: 83. 45, E8, 01
        jmp     ?_055                                   ; 06CC _ E9, 000000B0

?_048:  cmp     byte [rbp-25H], 191                     ; 06D1 _ 80. 7D, DB, BF
        jbe     ?_049                                   ; 06D5 _ 76, 06
        cmp     byte [rbp-25H], 253                     ; 06D7 _ 80. 7D, DB, FD
        jbe     ?_050                                   ; 06DB _ 76, 0C
?_049:  mov     rax, -1                                 ; 06DD _ 48: C7. C0, FFFFFFFF
        jmp     ?_057                                   ; 06E4 _ E9, 000000C4

?_050:  cmp     byte [rbp-25H], 223                     ; 06E9 _ 80. 7D, DB, DF
        ja      ?_051                                   ; 06ED _ 77, 1A
        movzx   eax, byte [rbp-25H]                     ; 06EF _ 0F B6. 45, DB
        and     eax, 1FH                                ; 06F3 _ 83. E0, 1F
        mov     dword [rbp-20H], eax                    ; 06F6 _ 89. 45, E0
        mov     dword [rbp-24H], 1                      ; 06F9 _ C7. 45, DC, 00000001
        mov     dword [rbp-1CH], 128                    ; 0700 _ C7. 45, E4, 00000080
        jmp     ?_055                                   ; 0707 _ EB, 78

?_051:  cmp     byte [rbp-25H], 239                     ; 0709 _ 80. 7D, DB, EF
        ja      ?_052                                   ; 070D _ 77, 1A
        movzx   eax, byte [rbp-25H]                     ; 070F _ 0F B6. 45, DB
        and     eax, 0FH                                ; 0713 _ 83. E0, 0F
        mov     dword [rbp-20H], eax                    ; 0716 _ 89. 45, E0
        mov     dword [rbp-24H], 2                      ; 0719 _ C7. 45, DC, 00000002
        mov     dword [rbp-1CH], 2048                   ; 0720 _ C7. 45, E4, 00000800
        jmp     ?_055                                   ; 0727 _ EB, 58

?_052:  cmp     byte [rbp-25H], 247                     ; 0729 _ 80. 7D, DB, F7
        ja      ?_053                                   ; 072D _ 77, 1A
        movzx   eax, byte [rbp-25H]                     ; 072F _ 0F B6. 45, DB
        and     eax, 07H                                ; 0733 _ 83. E0, 07
        mov     dword [rbp-20H], eax                    ; 0736 _ 89. 45, E0
        mov     dword [rbp-24H], 3                      ; 0739 _ C7. 45, DC, 00000003
        mov     dword [rbp-1CH], 65536                  ; 0740 _ C7. 45, E4, 00010000
        jmp     ?_055                                   ; 0747 _ EB, 38

?_053:  cmp     byte [rbp-25H], 251                     ; 0749 _ 80. 7D, DB, FB
        ja      ?_054                                   ; 074D _ 77, 1A
        movzx   eax, byte [rbp-25H]                     ; 074F _ 0F B6. 45, DB
        and     eax, 03H                                ; 0753 _ 83. E0, 03
        mov     dword [rbp-20H], eax                    ; 0756 _ 89. 45, E0
        mov     dword [rbp-24H], 4                      ; 0759 _ C7. 45, DC, 00000004
        mov     dword [rbp-1CH], 2097152                ; 0760 _ C7. 45, E4, 00200000
        jmp     ?_055                                   ; 0767 _ EB, 18

?_054:  movzx   eax, byte [rbp-25H]                     ; 0769 _ 0F B6. 45, DB
        and     eax, 01H                                ; 076D _ 83. E0, 01
        mov     dword [rbp-20H], eax                    ; 0770 _ 89. 45, E0
        mov     dword [rbp-24H], 5                      ; 0773 _ C7. 45, DC, 00000005
        mov     dword [rbp-1CH], 67108864               ; 077A _ C7. 45, E4, 04000000
?_055:  mov     rax, qword [rbp-40H]                    ; 0781 _ 48: 8B. 45, C0
        lea     rdx, [rax-1H]                           ; 0785 _ 48: 8D. 50, FF
        mov     qword [rbp-40H], rdx                    ; 0789 _ 48: 89. 55, C0
        test    rax, rax                                ; 078D _ 48: 85. C0
        jne     ?_041                                   ; 0790 _ 0F 85, FFFFFE56
        cmp     dword [rbp-24H], 0                      ; 0796 _ 83. 7D, DC, 00
        jnz     ?_056                                   ; 079A _ 75, 0A
        mov     rax, qword [rbp-18H]                    ; 079C _ 48: 8B. 45, E8
        shl     rax, 2                                  ; 07A0 _ 48: C1. E0, 02
        jmp     ?_057                                   ; 07A4 _ EB, 07

?_056:  mov     rax, -1                                 ; 07A6 _ 48: C7. C0, FFFFFFFF
?_057:  pop     rbp                                     ; 07AD _ 5D
        ret                                             ; 07AE _ C3

utf8_to_32be:; Local function
        push    rbp                                     ; 07AF _ 55
        mov     rbp, rsp                                ; 07B0 _ 48: 89. E5
        mov     qword [rbp-68H], rdi                    ; 07B3 _ 48: 89. 7D, 98
        mov     qword [rbp-70H], rsi                    ; 07B7 _ 48: 89. 75, 90
        mov     qword [rbp-78H], rdx                    ; 07BB _ 48: 89. 55, 88
        mov     qword [rbp-48H], 0                      ; 07BF _ 48: C7. 45, B8, 00000000
        mov     dword [rbp-5CH], 0                      ; 07C7 _ C7. 45, A4, 00000000
        mov     dword [rbp-58H], 0                      ; 07CE _ C7. 45, A8, 00000000
        mov     dword [rbp-54H], 0                      ; 07D5 _ C7. 45, AC, 00000000
        jmp     ?_072                                   ; 07DC _ E9, 0000027D

?_058:  mov     rax, qword [rbp-68H]                    ; 07E1 _ 48: 8B. 45, 98
        lea     rdx, [rax+1H]                           ; 07E5 _ 48: 8D. 50, 01
        mov     qword [rbp-68H], rdx                    ; 07E9 _ 48: 89. 55, 98
        movzx   eax, byte [rax]                         ; 07ED _ 0F B6. 00
        mov     byte [rbp-5DH], al                      ; 07F0 _ 88. 45, A3
        cmp     dword [rbp-5CH], 0                      ; 07F3 _ 83. 7D, A4, 00
        je      ?_063                                   ; 07F7 _ 0F 84, 00000104
        movzx   eax, byte [rbp-5DH]                     ; 07FD _ 0F B6. 45, A3
        and     eax, 0C0H                               ; 0801 _ 25, 000000C0
        cmp     eax, 128                                ; 0806 _ 3D, 00000080
        jz      ?_059                                   ; 080B _ 74, 0C
        mov     rax, -1                                 ; 080D _ 48: C7. C0, FFFFFFFF
        jmp     ?_074                                   ; 0814 _ E9, 00000271

?_059:  mov     eax, dword [rbp-58H]                    ; 0819 _ 8B. 45, A8
        shl     eax, 6                                  ; 081C _ C1. E0, 06
        mov     edx, eax                                ; 081F _ 89. C2
        movzx   eax, byte [rbp-5DH]                     ; 0821 _ 0F B6. 45, A3
        and     eax, 3FH                                ; 0825 _ 83. E0, 3F
        or      eax, edx                                ; 0828 _ 09. D0
        mov     dword [rbp-58H], eax                    ; 082A _ 89. 45, A8
        sub     dword [rbp-5CH], 1                      ; 082D _ 83. 6D, A4, 01
        cmp     dword [rbp-5CH], 0                      ; 0831 _ 83. 7D, A4, 00
        jne     ?_072                                   ; 0835 _ 0F 85, 00000223
        mov     eax, dword [rbp-58H]                    ; 083B _ 8B. 45, A8
        cmp     eax, dword [rbp-54H]                    ; 083E _ 3B. 45, AC
        jc      ?_060                                   ; 0841 _ 72, 12
        cmp     dword [rbp-58H], 55295                  ; 0843 _ 81. 7D, A8, 0000D7FF
        jbe     ?_061                                   ; 084A _ 76, 15
        cmp     dword [rbp-58H], 57343                  ; 084C _ 81. 7D, A8, 0000DFFF
        ja      ?_061                                   ; 0853 _ 77, 0C
?_060:  mov     rax, -1                                 ; 0855 _ 48: C7. C0, FFFFFFFF
        jmp     ?_074                                   ; 085C _ E9, 00000229

?_061:  mov     eax, dword [rbp-58H]                    ; 0861 _ 8B. 45, A8
        mov     dword [rbp-4CH], eax                    ; 0864 _ 89. 45, B4
        cmp     qword [rbp-78H], 0                      ; 0867 _ 48: 83. 7D, 88, 00
        je      ?_062                                   ; 086C _ 0F 84, 00000085
        mov     rax, qword [rbp-78H]                    ; 0872 _ 48: 8B. 45, 88
        mov     qword [rbp-20H], rax                    ; 0876 _ 48: 89. 45, E0
        mov     eax, dword [rbp-4CH]                    ; 087A _ 8B. 45, B4
        shr     eax, 24                                 ; 087D _ C1. E8, 18
        mov     edx, eax                                ; 0880 _ 89. C2
        mov     rax, qword [rbp-20H]                    ; 0882 _ 48: 8B. 45, E0
        mov     byte [rax], dl                          ; 0886 _ 88. 10
        mov     rax, qword [rbp-20H]                    ; 0888 _ 48: 8B. 45, E0
        add     rax, 1                                  ; 088C _ 48: 83. C0, 01
        mov     qword [rbp-78H], rax                    ; 0890 _ 48: 89. 45, 88
        mov     rax, qword [rbp-78H]                    ; 0894 _ 48: 8B. 45, 88
        mov     qword [rbp-18H], rax                    ; 0898 _ 48: 89. 45, E8
        mov     eax, dword [rbp-4CH]                    ; 089C _ 8B. 45, B4
        shr     eax, 16                                 ; 089F _ C1. E8, 10
        mov     edx, eax                                ; 08A2 _ 89. C2
        mov     rax, qword [rbp-18H]                    ; 08A4 _ 48: 8B. 45, E8
        mov     byte [rax], dl                          ; 08A8 _ 88. 10
        mov     rax, qword [rbp-18H]                    ; 08AA _ 48: 8B. 45, E8
        add     rax, 1                                  ; 08AE _ 48: 83. C0, 01
        mov     qword [rbp-78H], rax                    ; 08B2 _ 48: 89. 45, 88
        mov     rax, qword [rbp-78H]                    ; 08B6 _ 48: 8B. 45, 88
        mov     qword [rbp-10H], rax                    ; 08BA _ 48: 89. 45, F0
        mov     eax, dword [rbp-4CH]                    ; 08BE _ 8B. 45, B4
        shr     eax, 8                                  ; 08C1 _ C1. E8, 08
        mov     edx, eax                                ; 08C4 _ 89. C2
        mov     rax, qword [rbp-10H]                    ; 08C6 _ 48: 8B. 45, F0
        mov     byte [rax], dl                          ; 08CA _ 88. 10
        mov     rax, qword [rbp-10H]                    ; 08CC _ 48: 8B. 45, F0
        add     rax, 1                                  ; 08D0 _ 48: 83. C0, 01
        mov     qword [rbp-78H], rax                    ; 08D4 _ 48: 89. 45, 88
        mov     rax, qword [rbp-78H]                    ; 08D8 _ 48: 8B. 45, 88
        mov     qword [rbp-8H], rax                     ; 08DC _ 48: 89. 45, F8
        mov     eax, dword [rbp-4CH]                    ; 08E0 _ 8B. 45, B4
        mov     edx, eax                                ; 08E3 _ 89. C2
        mov     rax, qword [rbp-8H]                     ; 08E5 _ 48: 8B. 45, F8
        mov     byte [rax], dl                          ; 08E9 _ 88. 10
        mov     rax, qword [rbp-8H]                     ; 08EB _ 48: 8B. 45, F8
        add     rax, 1                                  ; 08EF _ 48: 83. C0, 01
        mov     qword [rbp-78H], rax                    ; 08F3 _ 48: 89. 45, 88
?_062:  add     qword [rbp-48H], 1                      ; 08F7 _ 48: 83. 45, B8, 01
        jmp     ?_072                                   ; 08FC _ E9, 0000015D

?_063:  movzx   eax, byte [rbp-5DH]                     ; 0901 _ 0F B6. 45, A3
        test    al, al                                  ; 0905 _ 84. C0
        js      ?_065                                   ; 0907 _ 0F 88, 000000A1
        movzx   eax, byte [rbp-5DH]                     ; 090D _ 0F B6. 45, A3
        mov     dword [rbp-50H], eax                    ; 0911 _ 89. 45, B0
        cmp     qword [rbp-78H], 0                      ; 0914 _ 48: 83. 7D, 88, 00
        je      ?_064                                   ; 0919 _ 0F 84, 00000085
        mov     rax, qword [rbp-78H]                    ; 091F _ 48: 8B. 45, 88
        mov     qword [rbp-40H], rax                    ; 0923 _ 48: 89. 45, C0
        mov     eax, dword [rbp-50H]                    ; 0927 _ 8B. 45, B0
        shr     eax, 24                                 ; 092A _ C1. E8, 18
        mov     edx, eax                                ; 092D _ 89. C2
        mov     rax, qword [rbp-40H]                    ; 092F _ 48: 8B. 45, C0
        mov     byte [rax], dl                          ; 0933 _ 88. 10
        mov     rax, qword [rbp-40H]                    ; 0935 _ 48: 8B. 45, C0
        add     rax, 1                                  ; 0939 _ 48: 83. C0, 01
        mov     qword [rbp-78H], rax                    ; 093D _ 48: 89. 45, 88
        mov     rax, qword [rbp-78H]                    ; 0941 _ 48: 8B. 45, 88
        mov     qword [rbp-38H], rax                    ; 0945 _ 48: 89. 45, C8
        mov     eax, dword [rbp-50H]                    ; 0949 _ 8B. 45, B0
        shr     eax, 16                                 ; 094C _ C1. E8, 10
        mov     edx, eax                                ; 094F _ 89. C2
        mov     rax, qword [rbp-38H]                    ; 0951 _ 48: 8B. 45, C8
        mov     byte [rax], dl                          ; 0955 _ 88. 10
        mov     rax, qword [rbp-38H]                    ; 0957 _ 48: 8B. 45, C8
        add     rax, 1                                  ; 095B _ 48: 83. C0, 01
        mov     qword [rbp-78H], rax                    ; 095F _ 48: 89. 45, 88
        mov     rax, qword [rbp-78H]                    ; 0963 _ 48: 8B. 45, 88
        mov     qword [rbp-30H], rax                    ; 0967 _ 48: 89. 45, D0
        mov     eax, dword [rbp-50H]                    ; 096B _ 8B. 45, B0
        shr     eax, 8                                  ; 096E _ C1. E8, 08
        mov     edx, eax                                ; 0971 _ 89. C2
        mov     rax, qword [rbp-30H]                    ; 0973 _ 48: 8B. 45, D0
        mov     byte [rax], dl                          ; 0977 _ 88. 10
        mov     rax, qword [rbp-30H]                    ; 0979 _ 48: 8B. 45, D0
        add     rax, 1                                  ; 097D _ 48: 83. C0, 01
        mov     qword [rbp-78H], rax                    ; 0981 _ 48: 89. 45, 88
        mov     rax, qword [rbp-78H]                    ; 0985 _ 48: 8B. 45, 88
        mov     qword [rbp-28H], rax                    ; 0989 _ 48: 89. 45, D8
        mov     eax, dword [rbp-50H]                    ; 098D _ 8B. 45, B0
        mov     edx, eax                                ; 0990 _ 89. C2
        mov     rax, qword [rbp-28H]                    ; 0992 _ 48: 8B. 45, D8
        mov     byte [rax], dl                          ; 0996 _ 88. 10
        mov     rax, qword [rbp-28H]                    ; 0998 _ 48: 8B. 45, D8
        add     rax, 1                                  ; 099C _ 48: 83. C0, 01
        mov     qword [rbp-78H], rax                    ; 09A0 _ 48: 89. 45, 88
?_064:  add     qword [rbp-48H], 1                      ; 09A4 _ 48: 83. 45, B8, 01
        jmp     ?_072                                   ; 09A9 _ E9, 000000B0

?_065:  cmp     byte [rbp-5DH], 191                     ; 09AE _ 80. 7D, A3, BF
        jbe     ?_066                                   ; 09B2 _ 76, 06
        cmp     byte [rbp-5DH], 253                     ; 09B4 _ 80. 7D, A3, FD
        jbe     ?_067                                   ; 09B8 _ 76, 0C
?_066:  mov     rax, -1                                 ; 09BA _ 48: C7. C0, FFFFFFFF
        jmp     ?_074                                   ; 09C1 _ E9, 000000C4

?_067:  cmp     byte [rbp-5DH], 223                     ; 09C6 _ 80. 7D, A3, DF
        ja      ?_068                                   ; 09CA _ 77, 1A
        movzx   eax, byte [rbp-5DH]                     ; 09CC _ 0F B6. 45, A3
        and     eax, 1FH                                ; 09D0 _ 83. E0, 1F
        mov     dword [rbp-58H], eax                    ; 09D3 _ 89. 45, A8
        mov     dword [rbp-5CH], 1                      ; 09D6 _ C7. 45, A4, 00000001
        mov     dword [rbp-54H], 128                    ; 09DD _ C7. 45, AC, 00000080
        jmp     ?_072                                   ; 09E4 _ EB, 78

?_068:  cmp     byte [rbp-5DH], 239                     ; 09E6 _ 80. 7D, A3, EF
        ja      ?_069                                   ; 09EA _ 77, 1A
        movzx   eax, byte [rbp-5DH]                     ; 09EC _ 0F B6. 45, A3
        and     eax, 0FH                                ; 09F0 _ 83. E0, 0F
        mov     dword [rbp-58H], eax                    ; 09F3 _ 89. 45, A8
        mov     dword [rbp-5CH], 2                      ; 09F6 _ C7. 45, A4, 00000002
        mov     dword [rbp-54H], 2048                   ; 09FD _ C7. 45, AC, 00000800
        jmp     ?_072                                   ; 0A04 _ EB, 58

?_069:  cmp     byte [rbp-5DH], 247                     ; 0A06 _ 80. 7D, A3, F7
        ja      ?_070                                   ; 0A0A _ 77, 1A
        movzx   eax, byte [rbp-5DH]                     ; 0A0C _ 0F B6. 45, A3
        and     eax, 07H                                ; 0A10 _ 83. E0, 07
        mov     dword [rbp-58H], eax                    ; 0A13 _ 89. 45, A8
        mov     dword [rbp-5CH], 3                      ; 0A16 _ C7. 45, A4, 00000003
        mov     dword [rbp-54H], 65536                  ; 0A1D _ C7. 45, AC, 00010000
        jmp     ?_072                                   ; 0A24 _ EB, 38

?_070:  cmp     byte [rbp-5DH], 251                     ; 0A26 _ 80. 7D, A3, FB
        ja      ?_071                                   ; 0A2A _ 77, 1A
        movzx   eax, byte [rbp-5DH]                     ; 0A2C _ 0F B6. 45, A3
        and     eax, 03H                                ; 0A30 _ 83. E0, 03
        mov     dword [rbp-58H], eax                    ; 0A33 _ 89. 45, A8
        mov     dword [rbp-5CH], 4                      ; 0A36 _ C7. 45, A4, 00000004
        mov     dword [rbp-54H], 2097152                ; 0A3D _ C7. 45, AC, 00200000
        jmp     ?_072                                   ; 0A44 _ EB, 18

?_071:  movzx   eax, byte [rbp-5DH]                     ; 0A46 _ 0F B6. 45, A3
        and     eax, 01H                                ; 0A4A _ 83. E0, 01
        mov     dword [rbp-58H], eax                    ; 0A4D _ 89. 45, A8
        mov     dword [rbp-5CH], 5                      ; 0A50 _ C7. 45, A4, 00000005
        mov     dword [rbp-54H], 67108864               ; 0A57 _ C7. 45, AC, 04000000
?_072:  mov     rax, qword [rbp-70H]                    ; 0A5E _ 48: 8B. 45, 90
        lea     rdx, [rax-1H]                           ; 0A62 _ 48: 8D. 50, FF
        mov     qword [rbp-70H], rdx                    ; 0A66 _ 48: 89. 55, 90
        test    rax, rax                                ; 0A6A _ 48: 85. C0
        jne     ?_058                                   ; 0A6D _ 0F 85, FFFFFD6E
        cmp     dword [rbp-5CH], 0                      ; 0A73 _ 83. 7D, A4, 00
        jnz     ?_073                                   ; 0A77 _ 75, 0A
        mov     rax, qword [rbp-48H]                    ; 0A79 _ 48: 8B. 45, B8
        shl     rax, 2                                  ; 0A7D _ 48: C1. E0, 02
        jmp     ?_074                                   ; 0A81 _ EB, 07

?_073:  mov     rax, -1                                 ; 0A83 _ 48: C7. C0, FFFFFFFF
?_074:  pop     rbp                                     ; 0A8A _ 5D
        ret                                             ; 0A8B _ C3

string_transform:; Function begin
        push    rbp                                     ; 0A8C _ 55
        mov     rbp, rsp                                ; 0A8D _ 48: 89. E5
        sub     rsp, 64                                 ; 0A90 _ 48: 83. EC, 40
        mov     qword [rbp-28H], rdi                    ; 0A94 _ 48: 89. 7D, D8
        mov     qword [rbp-30H], rsi                    ; 0A98 _ 48: 89. 75, D0
        mov     qword [rbp-38H], rdx                    ; 0A9C _ 48: 89. 55, C8
        mov     dword [rbp-3CH], ecx                    ; 0AA0 _ 89. 4D, C4
        mov     eax, dword [rbp-3CH]                    ; 0AA3 _ 8B. 45, C4
        lea     rdx, [rax*8]                            ; 0AA6 _ 48: 8D. 14 C5, 00000000
        lea     rax, [rel str_transforms.0]             ; 0AAE _ 48: 8D. 05, 00000000(rel)
        mov     rax, qword [rdx+rax]                    ; 0AB5 _ 48: 8B. 04 02
        mov     qword [rbp-20H], rax                    ; 0AB9 _ 48: 89. 45, E0
        mov     rax, qword [rbp-28H]                    ; 0ABD _ 48: 8B. 45, D8
        mov     qword [rbp-18H], rax                    ; 0AC1 _ 48: 89. 45, E8
        mov     rcx, qword [rbp-30H]                    ; 0AC5 _ 48: 8B. 4D, D0
        mov     rax, qword [rbp-18H]                    ; 0AC9 _ 48: 8B. 45, E8
        mov     r8, qword [rbp-20H]                     ; 0ACD _ 4C: 8B. 45, E0
        mov     edx, 0                                  ; 0AD1 _ BA, 00000000
        mov     rsi, rcx                                ; 0AD6 _ 48: 89. CE
        mov     rdi, rax                                ; 0AD9 _ 48: 89. C7
        call    r8                                      ; 0ADC _ 41: FF. D0
        mov     qword [rbp-10H], rax                    ; 0ADF _ 48: 89. 45, F0
        cmp     qword [rbp-10H], -1                     ; 0AE3 _ 48: 83. 7D, F0, FF
        jnz     ?_075                                   ; 0AE8 _ 75, 09
        mov     rax, -1                                 ; 0AEA _ 48: C7. C0, FFFFFFFF
        jmp     ?_076                                   ; 0AF1 _ EB, 46

?_075:  mov     rax, qword [rbp-10H]                    ; 0AF3 _ 48: 8B. 45, F0
        add     rax, 1                                  ; 0AF7 _ 48: 83. C0, 01
        mov     rdi, rax                                ; 0AFB _ 48: 89. C7
        call    nasm_malloc                             ; 0AFE _ E8, 00000000(PLT r)
        mov     qword [rbp-8H], rax                     ; 0B03 _ 48: 89. 45, F8
        mov     rax, qword [rbp-38H]                    ; 0B07 _ 48: 8B. 45, C8
        mov     rdx, qword [rbp-8H]                     ; 0B0B _ 48: 8B. 55, F8
        mov     qword [rax], rdx                        ; 0B0F _ 48: 89. 10
        mov     rdx, qword [rbp-8H]                     ; 0B12 _ 48: 8B. 55, F8
        mov     rax, qword [rbp-10H]                    ; 0B16 _ 48: 8B. 45, F0
        add     rax, rdx                                ; 0B1A _ 48: 01. D0
        mov     byte [rax], 0                           ; 0B1D _ C6. 00, 00
        mov     rdx, qword [rbp-8H]                     ; 0B20 _ 48: 8B. 55, F8
        mov     rcx, qword [rbp-30H]                    ; 0B24 _ 48: 8B. 4D, D0
        mov     rax, qword [rbp-18H]                    ; 0B28 _ 48: 8B. 45, E8
        mov     r8, qword [rbp-20H]                     ; 0B2C _ 4C: 8B. 45, E0
        mov     rsi, rcx                                ; 0B30 _ 48: 89. CE
        mov     rdi, rax                                ; 0B33 _ 48: 89. C7
        call    r8                                      ; 0B36 _ 41: FF. D0
?_076:  leave                                           ; 0B39 _ C9
        ret                                             ; 0B3A _ C3
; string_transform End of function


SECTION .data   align=1 noexec                          ; section number 2, data


SECTION .bss    align=1 noexec                          ; section number 3, bss


SECTION .data.rel.ro.local align=32 noexec              ; section number 4, data

str_transforms.0:                                       ; byte
        dq utf8_to_16le                                 ; 0000 _ 0000000000000000 (d)
        dq utf8_to_16le                                 ; 0008 _ 0000000000000000 (d)
        dq utf8_to_16be                                 ; 0010 _ 0000000000000000 (d)
        dq utf8_to_32le                                 ; 0018 _ 0000000000000000 (d)
        dq utf8_to_32le                                 ; 0020 _ 0000000000000000 (d)
        dq utf8_to_32be                                 ; 0028 _ 0000000000000000 (d)


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
        dd utf8_to_16le-$-20H                           ; 0020 _ 00000000 (rel)
        dd 00000284H, 100E4100H                         ; 0024 _ 644 269369600 
        dd 0D430286H, 027F0306H                         ; 002C _ 222495366 41878278 
        dd 0008070CH, 0000001CH                         ; 0034 _ 526092 28 
        dd 0000003CH                                    ; 003C _ 60 
        dd utf8_to_16le-$+244H                          ; 0040 _ 00000000 (rel)
        dd 00000336H, 100E4100H                         ; 0044 _ 822 269369600 
        dd 0D430286H, 03310306H                         ; 004C _ 222495366 53543686 
        dd 0008070CH, 0000001CH                         ; 0054 _ 526092 28 
        dd 0000005CH                                    ; 005C _ 92 
        dd utf8_to_16le-$+55AH                          ; 0060 _ 00000000 (rel)
        dd 000001F5H, 100E4100H                         ; 0064 _ 501 269369600 
        dd 0D430286H, 01F00306H                         ; 006C _ 222495366 32506630 
        dd 0008070CH, 0000001CH                         ; 0074 _ 526092 28 
        dd 0000007CH                                    ; 007C _ 124 
        dd utf8_to_16le-$+72FH                          ; 0080 _ 00000000 (rel)
        dd 000002DDH, 100E4100H                         ; 0084 _ 733 269369600 
        dd 0D430286H, 02D80306H                         ; 008C _ 222495366 47710982 
        dd 0008070CH, 0000001CH                         ; 0094 _ 526092 28 
        dd 0000009CH                                    ; 009C _ 156 
        dd utf8_to_16le-$+9ECH                          ; 00A0 _ 00000000 (rel)
        dd 000000AFH, 100E4100H                         ; 00A4 _ 175 269369600 
        dd 0D430286H, 0CAA0206H                         ; 00AC _ 222495366 212468230 
        dd 00000807H                                    ; 00B4 _ 2055 


