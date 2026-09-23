; Disassembly of file: /tmp/tmp.jtE9Rm7aVR.o
; Wed Sep 23 14:43:28 2026
; Type: ELF64
; Syntax: NASM
; Instruction set: 80386, x64

default rel

global nasm_quote: function
global nasm_quote_cstr: function
global nasm_unquote_anystr: function
global nasm_unquote: function
global nasm_unquote_cstr: function
global nasm_skip_string: function

extern nasm_nonfatal                                    ; near
extern nasm_panic_from_macro                            ; near
extern __stack_chk_fail                                 ; near
extern strlen                                           ; near
extern nasm_assert_failed                               ; near
extern memcpy                                           ; near
extern nasm_malloc                                      ; near


SECTION .text   align=1 exec                            ; section number 1, code

numvalue_chk:; Local function
        push    rbp                                     ; 0000 _ 55
        mov     rbp, rsp                                ; 0001 _ 48: 89. E5
        mov     byte [rbp-11H], dil                     ; 0004 _ 40: 88. 7D, EF
        movzx   eax, byte [rbp-11H]                     ; 0008 _ 0F B6. 45, EF
        sub     eax, 48                                 ; 000C _ 83. E8, 30
        mov     dword [rbp-4H], eax                     ; 000F _ 89. 45, FC
        cmp     dword [rbp-4H], 9                       ; 0012 _ 83. 7D, FC, 09
        ja      ?_001                                   ; 0016 _ 77, 05
        mov     eax, dword [rbp-4H]                     ; 0018 _ 8B. 45, FC
        jmp     ?_003                                   ; 001B _ EB, 23

?_001:  movzx   eax, byte [rbp-11H]                     ; 001D _ 0F B6. 45, EF
        or      eax, 20H                                ; 0021 _ 83. C8, 20
        movzx   eax, al                                 ; 0024 _ 0F B6. C0
        sub     eax, 97                                 ; 0027 _ 83. E8, 61
        mov     dword [rbp-4H], eax                     ; 002A _ 89. 45, FC
        cmp     dword [rbp-4H], 25                      ; 002D _ 83. 7D, FC, 19
        ja      ?_002                                   ; 0031 _ 77, 08
        mov     eax, dword [rbp-4H]                     ; 0033 _ 8B. 45, FC
        add     eax, 10                                 ; 0036 _ 83. C0, 0A
        jmp     ?_003                                   ; 0039 _ EB, 05

?_002:  mov     eax, 4294967295                         ; 003B _ B8, FFFFFFFF
?_003:  pop     rbp                                     ; 0040 _ 5D
        ret                                             ; 0041 _ C3

nasm_quote:; Function begin
        push    rbp                                     ; 0042 _ 55
        mov     rbp, rsp                                ; 0043 _ 48: 89. E5
        sub     rsp, 80                                 ; 0046 _ 48: 83. EC, 50
        mov     qword [rbp-48H], rdi                    ; 004A _ 48: 89. 7D, B8
        mov     qword [rbp-50H], rsi                    ; 004E _ 48: 89. 75, B0
        mov     rax, qword [rbp-50H]                    ; 0052 _ 48: 8B. 45, B0
        mov     rax, qword [rax]                        ; 0056 _ 48: 8B. 00
        mov     qword [rbp-10H], rax                    ; 0059 _ 48: 89. 45, F0
        mov     byte [rbp-32H], 1                       ; 005D _ C6. 45, CE, 01
        movzx   eax, byte [rbp-32H]                     ; 0061 _ 0F B6. 45, CE
        mov     byte [rbp-33H], al                      ; 0065 _ 88. 45, CD
        mov     rdx, qword [rbp-48H]                    ; 0068 _ 48: 8B. 55, B8
        mov     rax, qword [rbp-10H]                    ; 006C _ 48: 8B. 45, F0
        add     rax, rdx                                ; 0070 _ 48: 01. D0
        mov     qword [rbp-8H], rax                     ; 0073 _ 48: 89. 45, F8
        mov     qword [rbp-18H], 0                      ; 0077 _ 48: C7. 45, E8, 00000000
        mov     rax, qword [rbp-48H]                    ; 007F _ 48: 8B. 45, B8
        mov     qword [rbp-30H], rax                    ; 0083 _ 48: 89. 45, D0
        jmp     ?_022                                   ; 0087 _ E9, 000000EE

?_004:  mov     rax, qword [rbp-30H]                    ; 008C _ 48: 8B. 45, D0
        movzx   eax, byte [rax]                         ; 0090 _ 0F B6. 00
        mov     byte [rbp-31H], al                      ; 0093 _ 88. 45, CF
        movsx   eax, byte [rbp-31H]                     ; 0096 _ 0F BE. 45, CF
        cmp     eax, 96                                 ; 009A _ 83. F8, 60
        jz      ?_006                                   ; 009D _ 74, 35
        cmp     eax, 96                                 ; 009F _ 83. F8, 60
        jg      ?_007                                   ; 00A2 _ 7F, 3A
        cmp     eax, 92                                 ; 00A4 _ 83. F8, 5C
        jz      ?_006                                   ; 00A7 _ 74, 2B
        cmp     eax, 92                                 ; 00A9 _ 83. F8, 5C
        jg      ?_007                                   ; 00AC _ 7F, 30
        cmp     eax, 34                                 ; 00AE _ 83. F8, 22
        jz      ?_005                                   ; 00B1 _ 74, 13
        cmp     eax, 39                                 ; 00B3 _ 83. F8, 27
        jnz     ?_007                                   ; 00B6 _ 75, 26
        mov     byte [rbp-33H], 0                       ; 00B8 _ C6. 45, CD, 00
        add     qword [rbp-18H], 1                      ; 00BC _ 48: 83. 45, E8, 01
        jmp     ?_021                                   ; 00C1 _ E9, 000000AF

?_005:  mov     byte [rbp-32H], 0                       ; 00C6 _ C6. 45, CE, 00
        add     qword [rbp-18H], 1                      ; 00CA _ 48: 83. 45, E8, 01
        jmp     ?_021                                   ; 00CF _ E9, 000000A1

?_006:  add     qword [rbp-18H], 2                      ; 00D4 _ 48: 83. 45, E8, 02
        jmp     ?_021                                   ; 00D9 _ E9, 00000097

?_007:  cmp     byte [rbp-31H], 31                      ; 00DE _ 80. 7D, CF, 1F
        jle     ?_008                                   ; 00E2 _ 7E, 0A
        cmp     byte [rbp-31H], 127                     ; 00E4 _ 80. 7D, CF, 7F
        jne     ?_019                                   ; 00E8 _ 0F 85, 00000081
?_008:  mov     byte [rbp-32H], 0                       ; 00EE _ C6. 45, CE, 00
        movzx   eax, byte [rbp-32H]                     ; 00F2 _ 0F B6. 45, CE
        mov     byte [rbp-33H], al                      ; 00F6 _ 88. 45, CD
        movsx   eax, byte [rbp-31H]                     ; 00F9 _ 0F BE. 45, CF
        cmp     eax, 13                                 ; 00FD _ 83. F8, 0D
        jg      ?_009                                   ; 0100 _ 7F, 07
        cmp     eax, 7                                  ; 0102 _ 83. F8, 07
        jge     ?_010                                   ; 0105 _ 7D, 07
        jmp     ?_011                                   ; 0107 _ EB, 0C

?_009:  cmp     eax, 27                                 ; 0109 _ 83. F8, 1B
        jnz     ?_011                                   ; 010C _ 75, 07
?_010:  add     qword [rbp-18H], 2                      ; 010E _ 48: 83. 45, E8, 02
        jmp     ?_018                                   ; 0113 _ EB, 57

?_011:  mov     rax, qword [rbp-30H]                    ; 0115 _ 48: 8B. 45, D0
        add     rax, 1                                  ; 0119 _ 48: 83. C0, 01
        cmp     rax, qword [rbp-8H]                     ; 011D _ 48: 3B. 45, F8
        jnc     ?_012                                   ; 0121 _ 73, 10
        mov     rax, qword [rbp-30H]                    ; 0123 _ 48: 8B. 45, D0
        add     rax, 1                                  ; 0127 _ 48: 83. C0, 01
        movzx   eax, byte [rax]                         ; 012B _ 0F B6. 00
        mov     byte [rbp-35H], al                      ; 012E _ 88. 45, CB
        jmp     ?_013                                   ; 0131 _ EB, 04

?_012:  mov     byte [rbp-35H], 0                       ; 0133 _ C6. 45, CB, 00
?_013:  cmp     byte [rbp-35H], 47                      ; 0137 _ 80. 7D, CB, 2F
        jle     ?_014                                   ; 013B _ 7E, 0C
        cmp     byte [rbp-35H], 55                      ; 013D _ 80. 7D, CB, 37
        jg      ?_014                                   ; 0141 _ 7F, 06
        mov     byte [rbp-34H], 255                     ; 0143 _ C6. 45, CC, FF
        jmp     ?_015                                   ; 0147 _ EB, 07

?_014:  movzx   eax, byte [rbp-31H]                     ; 0149 _ 0F B6. 45, CF
        mov     byte [rbp-34H], al                      ; 014D _ 88. 45, CC
?_015:  cmp     byte [rbp-34H], 63                      ; 0150 _ 80. 7D, CC, 3F
        jbe     ?_016                                   ; 0154 _ 76, 05
        add     qword [rbp-18H], 1                      ; 0156 _ 48: 83. 45, E8, 01
?_016:  cmp     byte [rbp-34H], 7                       ; 015B _ 80. 7D, CC, 07
        jbe     ?_017                                   ; 015F _ 76, 05
        add     qword [rbp-18H], 1                      ; 0161 _ 48: 83. 45, E8, 01
?_017:  add     qword [rbp-18H], 2                      ; 0166 _ 48: 83. 45, E8, 02
        nop                                             ; 016B _ 90
?_018:  nop                                             ; 016C _ 90
        jmp     ?_020                                   ; 016D _ EB, 05

?_019:  add     qword [rbp-18H], 1                      ; 016F _ 48: 83. 45, E8, 01
?_020:  nop                                             ; 0174 _ 90
?_021:  add     qword [rbp-30H], 1                      ; 0175 _ 48: 83. 45, D0, 01
?_022:  mov     rax, qword [rbp-30H]                    ; 017A _ 48: 8B. 45, D0
        cmp     rax, qword [rbp-8H]                     ; 017E _ 48: 3B. 45, F8
        jc      ?_004                                   ; 0182 _ 0F 82, FFFFFF04
        cmp     byte [rbp-33H], 0                       ; 0188 _ 80. 7D, CD, 00
        jnz     ?_023                                   ; 018C _ 75, 06
        cmp     byte [rbp-32H], 0                       ; 018E _ 80. 7D, CE, 00
        jz      ?_026                                   ; 0192 _ 74, 7E
?_023:  mov     rax, qword [rbp-10H]                    ; 0194 _ 48: 8B. 45, F0
        add     rax, 3                                  ; 0198 _ 48: 83. C0, 03
        mov     rdi, rax                                ; 019C _ 48: 89. C7
        call    nasm_malloc                             ; 019F _ E8, 00000000(PLT r)
        mov     qword [rbp-20H], rax                    ; 01A4 _ 48: 89. 45, E0
        cmp     byte [rbp-33H], 0                       ; 01A8 _ 80. 7D, CD, 00
        jz      ?_024                                   ; 01AC _ 74, 07
        mov     ecx, 39                                 ; 01AE _ B9, 00000027
        jmp     ?_025                                   ; 01B3 _ EB, 05

?_024:  mov     ecx, 34                                 ; 01B5 _ B9, 00000022
?_025:  mov     rax, qword [rbp-10H]                    ; 01BA _ 48: 8B. 45, F0
        lea     rdx, [rax+1H]                           ; 01BE _ 48: 8D. 50, 01
        mov     rax, qword [rbp-20H]                    ; 01C2 _ 48: 8B. 45, E0
        add     rax, rdx                                ; 01C6 _ 48: 01. D0
        mov     byte [rax], cl                          ; 01C9 _ 88. 08
        movzx   edx, byte [rax]                         ; 01CB _ 0F B6. 10
        mov     rax, qword [rbp-20H]                    ; 01CE _ 48: 8B. 45, E0
        mov     byte [rax], dl                          ; 01D2 _ 88. 10
        mov     rax, qword [rbp-10H]                    ; 01D4 _ 48: 8B. 45, F0
        lea     rdx, [rax+2H]                           ; 01D8 _ 48: 8D. 50, 02
        mov     rax, qword [rbp-20H]                    ; 01DC _ 48: 8B. 45, E0
        add     rax, rdx                                ; 01E0 _ 48: 01. D0
        mov     qword [rbp-28H], rax                    ; 01E3 _ 48: 89. 45, D8
        cmp     qword [rbp-10H], 0                      ; 01E7 _ 48: 83. 7D, F0, 00
        je      ?_048                                   ; 01EC _ 0F 84, 00000371
        mov     rax, qword [rbp-20H]                    ; 01F2 _ 48: 8B. 45, E0
        lea     rcx, [rax+1H]                           ; 01F6 _ 48: 8D. 48, 01
        mov     rdx, qword [rbp-10H]                    ; 01FA _ 48: 8B. 55, F0
        mov     rax, qword [rbp-48H]                    ; 01FE _ 48: 8B. 45, B8
        mov     rsi, rax                                ; 0202 _ 48: 89. C6
        mov     rdi, rcx                                ; 0205 _ 48: 89. CF
        call    memcpy                                  ; 0208 _ E8, 00000000(PLT r)
        jmp     ?_048                                   ; 020D _ E9, 00000351

?_026:  mov     rax, qword [rbp-18H]                    ; 0212 _ 48: 8B. 45, E8
        add     rax, 3                                  ; 0216 _ 48: 83. C0, 03
        mov     rdi, rax                                ; 021A _ 48: 89. C7
        call    nasm_malloc                             ; 021D _ E8, 00000000(PLT r)
        mov     qword [rbp-20H], rax                    ; 0222 _ 48: 89. 45, E0
        mov     rax, qword [rbp-20H]                    ; 0226 _ 48: 8B. 45, E0
        mov     qword [rbp-28H], rax                    ; 022A _ 48: 89. 45, D8
        mov     rax, qword [rbp-28H]                    ; 022E _ 48: 8B. 45, D8
        lea     rdx, [rax+1H]                           ; 0232 _ 48: 8D. 50, 01
        mov     qword [rbp-28H], rdx                    ; 0236 _ 48: 89. 55, D8
        mov     byte [rax], 96                          ; 023A _ C6. 00, 60
        mov     rax, qword [rbp-48H]                    ; 023D _ 48: 8B. 45, B8
        mov     qword [rbp-30H], rax                    ; 0241 _ 48: 89. 45, D0
        jmp     ?_047                                   ; 0245 _ E9, 000002BC

?_027:  mov     rax, qword [rbp-30H]                    ; 024A _ 48: 8B. 45, D0
        movzx   eax, byte [rax]                         ; 024E _ 0F B6. 00
        mov     byte [rbp-31H], al                      ; 0251 _ 88. 45, CF
        movsx   eax, byte [rbp-31H]                     ; 0254 _ 0F BE. 45, CF
        cmp     eax, 96                                 ; 0258 _ 83. F8, 60
        je      ?_028                                   ; 025B _ 0F 84, 00000096
        cmp     eax, 96                                 ; 0261 _ 83. F8, 60
        jg      ?_037                                   ; 0264 _ 0F 8F, 000001CB
        cmp     eax, 92                                 ; 026A _ 83. F8, 5C
        je      ?_028                                   ; 026D _ 0F 84, 00000084
        cmp     eax, 92                                 ; 0273 _ 83. F8, 5C
        jg      ?_037                                   ; 0276 _ 0F 8F, 000001B9
        cmp     eax, 27                                 ; 027C _ 83. F8, 1B
        je      ?_036                                   ; 027F _ 0F 84, 0000018D
        cmp     eax, 27                                 ; 0285 _ 83. F8, 1B
        jg      ?_037                                   ; 0288 _ 0F 8F, 000001A7
        cmp     eax, 13                                 ; 028E _ 83. F8, 0D
        je      ?_035                                   ; 0291 _ 0F 84, 00000158
        cmp     eax, 13                                 ; 0297 _ 83. F8, 0D
        jg      ?_037                                   ; 029A _ 0F 8F, 00000195
        cmp     eax, 12                                 ; 02A0 _ 83. F8, 0C
        je      ?_034                                   ; 02A3 _ 0F 84, 00000123
        cmp     eax, 12                                 ; 02A9 _ 83. F8, 0C
        jg      ?_037                                   ; 02AC _ 0F 8F, 00000183
        cmp     eax, 11                                 ; 02B2 _ 83. F8, 0B
        je      ?_033                                   ; 02B5 _ 0F 84, 000000EE
        cmp     eax, 11                                 ; 02BB _ 83. F8, 0B
        jg      ?_037                                   ; 02BE _ 0F 8F, 00000171
        cmp     eax, 10                                 ; 02C4 _ 83. F8, 0A
        je      ?_032                                   ; 02C7 _ 0F 84, 000000B9
        cmp     eax, 10                                 ; 02CD _ 83. F8, 0A
        jg      ?_037                                   ; 02D0 _ 0F 8F, 0000015F
        cmp     eax, 9                                  ; 02D6 _ 83. F8, 09
        je      ?_031                                   ; 02D9 _ 0F 84, 00000084
        cmp     eax, 9                                  ; 02DF _ 83. F8, 09
        jg      ?_037                                   ; 02E2 _ 0F 8F, 0000014D
        cmp     eax, 7                                  ; 02E8 _ 83. F8, 07
        jz      ?_029                                   ; 02EB _ 74, 30
        cmp     eax, 8                                  ; 02ED _ 83. F8, 08
        jz      ?_030                                   ; 02F0 _ 74, 4E
        jmp     ?_037                                   ; 02F2 _ E9, 0000013E

?_028:  mov     rax, qword [rbp-28H]                    ; 02F7 _ 48: 8B. 45, D8
        lea     rdx, [rax+1H]                           ; 02FB _ 48: 8D. 50, 01
        mov     qword [rbp-28H], rdx                    ; 02FF _ 48: 89. 55, D8
        mov     byte [rax], 92                          ; 0303 _ C6. 00, 5C
        mov     rax, qword [rbp-28H]                    ; 0306 _ 48: 8B. 45, D8
        lea     rdx, [rax+1H]                           ; 030A _ 48: 8D. 50, 01
        mov     qword [rbp-28H], rdx                    ; 030E _ 48: 89. 55, D8
        movzx   edx, byte [rbp-31H]                     ; 0312 _ 0F B6. 55, CF
        mov     byte [rax], dl                          ; 0316 _ 88. 10
        jmp     ?_046                                   ; 0318 _ E9, 000001E4

?_029:  mov     rax, qword [rbp-28H]                    ; 031D _ 48: 8B. 45, D8
        lea     rdx, [rax+1H]                           ; 0321 _ 48: 8D. 50, 01
        mov     qword [rbp-28H], rdx                    ; 0325 _ 48: 89. 55, D8
        mov     byte [rax], 92                          ; 0329 _ C6. 00, 5C
        mov     rax, qword [rbp-28H]                    ; 032C _ 48: 8B. 45, D8
        lea     rdx, [rax+1H]                           ; 0330 _ 48: 8D. 50, 01
        mov     qword [rbp-28H], rdx                    ; 0334 _ 48: 89. 55, D8
        mov     byte [rax], 97                          ; 0338 _ C6. 00, 61
        jmp     ?_046                                   ; 033B _ E9, 000001C1

?_030:  mov     rax, qword [rbp-28H]                    ; 0340 _ 48: 8B. 45, D8
        lea     rdx, [rax+1H]                           ; 0344 _ 48: 8D. 50, 01
        mov     qword [rbp-28H], rdx                    ; 0348 _ 48: 89. 55, D8
        mov     byte [rax], 92                          ; 034C _ C6. 00, 5C
        mov     rax, qword [rbp-28H]                    ; 034F _ 48: 8B. 45, D8
        lea     rdx, [rax+1H]                           ; 0353 _ 48: 8D. 50, 01
        mov     qword [rbp-28H], rdx                    ; 0357 _ 48: 89. 55, D8
        mov     byte [rax], 98                          ; 035B _ C6. 00, 62
        jmp     ?_046                                   ; 035E _ E9, 0000019E

?_031:  mov     rax, qword [rbp-28H]                    ; 0363 _ 48: 8B. 45, D8
        lea     rdx, [rax+1H]                           ; 0367 _ 48: 8D. 50, 01
        mov     qword [rbp-28H], rdx                    ; 036B _ 48: 89. 55, D8
        mov     byte [rax], 92                          ; 036F _ C6. 00, 5C
        mov     rax, qword [rbp-28H]                    ; 0372 _ 48: 8B. 45, D8
        lea     rdx, [rax+1H]                           ; 0376 _ 48: 8D. 50, 01
        mov     qword [rbp-28H], rdx                    ; 037A _ 48: 89. 55, D8
        mov     byte [rax], 116                         ; 037E _ C6. 00, 74
        jmp     ?_046                                   ; 0381 _ E9, 0000017B

?_032:  mov     rax, qword [rbp-28H]                    ; 0386 _ 48: 8B. 45, D8
        lea     rdx, [rax+1H]                           ; 038A _ 48: 8D. 50, 01
        mov     qword [rbp-28H], rdx                    ; 038E _ 48: 89. 55, D8
        mov     byte [rax], 92                          ; 0392 _ C6. 00, 5C
        mov     rax, qword [rbp-28H]                    ; 0395 _ 48: 8B. 45, D8
        lea     rdx, [rax+1H]                           ; 0399 _ 48: 8D. 50, 01
        mov     qword [rbp-28H], rdx                    ; 039D _ 48: 89. 55, D8
        mov     byte [rax], 110                         ; 03A1 _ C6. 00, 6E
        jmp     ?_046                                   ; 03A4 _ E9, 00000158

?_033:  mov     rax, qword [rbp-28H]                    ; 03A9 _ 48: 8B. 45, D8
        lea     rdx, [rax+1H]                           ; 03AD _ 48: 8D. 50, 01
        mov     qword [rbp-28H], rdx                    ; 03B1 _ 48: 89. 55, D8
        mov     byte [rax], 92                          ; 03B5 _ C6. 00, 5C
        mov     rax, qword [rbp-28H]                    ; 03B8 _ 48: 8B. 45, D8
        lea     rdx, [rax+1H]                           ; 03BC _ 48: 8D. 50, 01
        mov     qword [rbp-28H], rdx                    ; 03C0 _ 48: 89. 55, D8
        mov     byte [rax], 118                         ; 03C4 _ C6. 00, 76
        jmp     ?_046                                   ; 03C7 _ E9, 00000135

?_034:  mov     rax, qword [rbp-28H]                    ; 03CC _ 48: 8B. 45, D8
        lea     rdx, [rax+1H]                           ; 03D0 _ 48: 8D. 50, 01
        mov     qword [rbp-28H], rdx                    ; 03D4 _ 48: 89. 55, D8
        mov     byte [rax], 92                          ; 03D8 _ C6. 00, 5C
        mov     rax, qword [rbp-28H]                    ; 03DB _ 48: 8B. 45, D8
        lea     rdx, [rax+1H]                           ; 03DF _ 48: 8D. 50, 01
        mov     qword [rbp-28H], rdx                    ; 03E3 _ 48: 89. 55, D8
        mov     byte [rax], 102                         ; 03E7 _ C6. 00, 66
        jmp     ?_046                                   ; 03EA _ E9, 00000112

?_035:  mov     rax, qword [rbp-28H]                    ; 03EF _ 48: 8B. 45, D8
        lea     rdx, [rax+1H]                           ; 03F3 _ 48: 8D. 50, 01
        mov     qword [rbp-28H], rdx                    ; 03F7 _ 48: 89. 55, D8
        mov     byte [rax], 92                          ; 03FB _ C6. 00, 5C
        mov     rax, qword [rbp-28H]                    ; 03FE _ 48: 8B. 45, D8
        lea     rdx, [rax+1H]                           ; 0402 _ 48: 8D. 50, 01
        mov     qword [rbp-28H], rdx                    ; 0406 _ 48: 89. 55, D8
        mov     byte [rax], 114                         ; 040A _ C6. 00, 72
        jmp     ?_046                                   ; 040D _ E9, 000000EF

?_036:  mov     rax, qword [rbp-28H]                    ; 0412 _ 48: 8B. 45, D8
        lea     rdx, [rax+1H]                           ; 0416 _ 48: 8D. 50, 01
        mov     qword [rbp-28H], rdx                    ; 041A _ 48: 89. 55, D8
        mov     byte [rax], 92                          ; 041E _ C6. 00, 5C
        mov     rax, qword [rbp-28H]                    ; 0421 _ 48: 8B. 45, D8
        lea     rdx, [rax+1H]                           ; 0425 _ 48: 8D. 50, 01
        mov     qword [rbp-28H], rdx                    ; 0429 _ 48: 89. 55, D8
        mov     byte [rax], 101                         ; 042D _ C6. 00, 65
        jmp     ?_046                                   ; 0430 _ E9, 000000CC

?_037:  cmp     byte [rbp-31H], 31                      ; 0435 _ 80. 7D, CF, 1F
        jle     ?_038                                   ; 0439 _ 7E, 0A
        cmp     byte [rbp-31H], 127                     ; 043B _ 80. 7D, CF, 7F
        jne     ?_045                                   ; 043F _ 0F 85, 000000A9
?_038:  mov     rax, qword [rbp-30H]                    ; 0445 _ 48: 8B. 45, D0
        add     rax, 1                                  ; 0449 _ 48: 83. C0, 01
        cmp     rax, qword [rbp-8H]                     ; 044D _ 48: 3B. 45, F8
        jnc     ?_039                                   ; 0451 _ 73, 10
        mov     rax, qword [rbp-30H]                    ; 0453 _ 48: 8B. 45, D0
        add     rax, 1                                  ; 0457 _ 48: 83. C0, 01
        movzx   eax, byte [rax]                         ; 045B _ 0F B6. 00
        mov     byte [rbp-35H], al                      ; 045E _ 88. 45, CB
        jmp     ?_040                                   ; 0461 _ EB, 04

?_039:  mov     byte [rbp-35H], 0                       ; 0463 _ C6. 45, CB, 00
?_040:  cmp     byte [rbp-35H], 47                      ; 0467 _ 80. 7D, CB, 2F
        jle     ?_041                                   ; 046B _ 7E, 0C
        cmp     byte [rbp-35H], 55                      ; 046D _ 80. 7D, CB, 37
        jg      ?_041                                   ; 0471 _ 7F, 06
        mov     byte [rbp-34H], 255                     ; 0473 _ C6. 45, CC, FF
        jmp     ?_042                                   ; 0477 _ EB, 07

?_041:  movzx   eax, byte [rbp-31H]                     ; 0479 _ 0F B6. 45, CF
        mov     byte [rbp-34H], al                      ; 047D _ 88. 45, CC
?_042:  mov     rax, qword [rbp-28H]                    ; 0480 _ 48: 8B. 45, D8
        lea     rdx, [rax+1H]                           ; 0484 _ 48: 8D. 50, 01
        mov     qword [rbp-28H], rdx                    ; 0488 _ 48: 89. 55, D8
        mov     byte [rax], 92                          ; 048C _ C6. 00, 5C
        cmp     byte [rbp-34H], 63                      ; 048F _ 80. 7D, CC, 3F
        jbe     ?_043                                   ; 0493 _ 76, 1A
        movzx   eax, byte [rbp-31H]                     ; 0495 _ 0F B6. 45, CF
        shr     al, 6                                   ; 0499 _ C0. E8, 06
        lea     ecx, [rax+30H]                          ; 049C _ 8D. 48, 30
        mov     rax, qword [rbp-28H]                    ; 049F _ 48: 8B. 45, D8
        lea     rdx, [rax+1H]                           ; 04A3 _ 48: 8D. 50, 01
        mov     qword [rbp-28H], rdx                    ; 04A7 _ 48: 89. 55, D8
        mov     edx, ecx                                ; 04AB _ 89. CA
        mov     byte [rax], dl                          ; 04AD _ 88. 10
?_043:  cmp     byte [rbp-34H], 7                       ; 04AF _ 80. 7D, CC, 07
        jbe     ?_044                                   ; 04B3 _ 76, 1D
        movzx   eax, byte [rbp-31H]                     ; 04B5 _ 0F B6. 45, CF
        shr     al, 3                                   ; 04B9 _ C0. E8, 03
        and     eax, 07H                                ; 04BC _ 83. E0, 07
        lea     ecx, [rax+30H]                          ; 04BF _ 8D. 48, 30
        mov     rax, qword [rbp-28H]                    ; 04C2 _ 48: 8B. 45, D8
        lea     rdx, [rax+1H]                           ; 04C6 _ 48: 8D. 50, 01
        mov     qword [rbp-28H], rdx                    ; 04CA _ 48: 89. 55, D8
        mov     edx, ecx                                ; 04CE _ 89. CA
        mov     byte [rax], dl                          ; 04D0 _ 88. 10
?_044:  movzx   eax, byte [rbp-31H]                     ; 04D2 _ 0F B6. 45, CF
        and     eax, 07H                                ; 04D6 _ 83. E0, 07
        lea     ecx, [rax+30H]                          ; 04D9 _ 8D. 48, 30
        mov     rax, qword [rbp-28H]                    ; 04DC _ 48: 8B. 45, D8
        lea     rdx, [rax+1H]                           ; 04E0 _ 48: 8D. 50, 01
        mov     qword [rbp-28H], rdx                    ; 04E4 _ 48: 89. 55, D8
        mov     edx, ecx                                ; 04E8 _ 89. CA
        mov     byte [rax], dl                          ; 04EA _ 88. 10
        jmp     ?_046                                   ; 04EC _ EB, 13

?_045:  mov     rax, qword [rbp-28H]                    ; 04EE _ 48: 8B. 45, D8
        lea     rdx, [rax+1H]                           ; 04F2 _ 48: 8D. 50, 01
        mov     qword [rbp-28H], rdx                    ; 04F6 _ 48: 89. 55, D8
        movzx   edx, byte [rbp-31H]                     ; 04FA _ 0F B6. 55, CF
        mov     byte [rax], dl                          ; 04FE _ 88. 10
        nop                                             ; 0500 _ 90
?_046:  add     qword [rbp-30H], 1                      ; 0501 _ 48: 83. 45, D0, 01
?_047:  mov     rax, qword [rbp-30H]                    ; 0506 _ 48: 8B. 45, D0
        cmp     rax, qword [rbp-8H]                     ; 050A _ 48: 3B. 45, F8
        jc      ?_027                                   ; 050E _ 0F 82, FFFFFD36
        mov     rax, qword [rbp-28H]                    ; 0514 _ 48: 8B. 45, D8
        lea     rdx, [rax+1H]                           ; 0518 _ 48: 8D. 50, 01
        mov     qword [rbp-28H], rdx                    ; 051C _ 48: 89. 55, D8
        mov     byte [rax], 96                          ; 0520 _ C6. 00, 60
        mov     rax, qword [rbp-28H]                    ; 0523 _ 48: 8B. 45, D8
        sub     rax, qword [rbp-20H]                    ; 0527 _ 48: 2B. 45, E0
        mov     rdx, qword [rbp-18H]                    ; 052B _ 48: 8B. 55, E8
        add     rdx, 2                                  ; 052F _ 48: 83. C2, 02
        cmp     rax, rdx                                ; 0533 _ 48: 39. D0
        setne   al                                      ; 0536 _ 0F 95. C0
        movzx   eax, al                                 ; 0539 _ 0F B6. C0
        test    rax, rax                                ; 053C _ 48: 85. C0
        jz      ?_048                                   ; 053F _ 74, 22
        lea     rdx, [rel ?_132]                        ; 0541 _ 48: 8D. 15, 00000000(rel)
        lea     rsi, [rel __func__.2]                   ; 0548 _ 48: 8D. 35, 00000000(rel)
        lea     rax, [rel ?_133]                        ; 054F _ 48: 8D. 05, 00000000(rel)
        mov     ecx, 153                                ; 0556 _ B9, 00000099
        mov     rdi, rax                                ; 055B _ 48: 89. C7
        call    nasm_assert_failed                      ; 055E _ E8, 00000000(PLT r)
?_048:  mov     rax, qword [rbp-28H]                    ; 0563 _ 48: 8B. 45, D8
        mov     byte [rax], 0                           ; 0567 _ C6. 00, 00
        mov     rax, qword [rbp-28H]                    ; 056A _ 48: 8B. 45, D8
        sub     rax, qword [rbp-20H]                    ; 056E _ 48: 2B. 45, E0
        mov     rdx, rax                                ; 0572 _ 48: 89. C2
        mov     rax, qword [rbp-50H]                    ; 0575 _ 48: 8B. 45, B0
        mov     qword [rax], rdx                        ; 0579 _ 48: 89. 10
        mov     rax, qword [rbp-20H]                    ; 057C _ 48: 8B. 45, E0
        leave                                           ; 0580 _ C9
        ret                                             ; 0581 _ C3
; nasm_quote End of function

emit_utf8:; Local function
        push    rbp                                     ; 0582 _ 55
        mov     rbp, rsp                                ; 0583 _ 48: 89. E5
        mov     qword [rbp-28H], rdi                    ; 0586 _ 48: 89. 7D, D8
        mov     dword [rbp-2CH], esi                    ; 058A _ 89. 75, D4
        cmp     dword [rbp-2CH], 127                    ; 058D _ 83. 7D, D4, 7F
        ja      ?_049                                   ; 0591 _ 77, 16
        mov     rax, qword [rbp-28H]                    ; 0593 _ 48: 8B. 45, D8
        lea     rdx, [rax+1H]                           ; 0597 _ 48: 8D. 50, 01
        mov     qword [rbp-28H], rdx                    ; 059B _ 48: 89. 55, D8
        mov     edx, dword [rbp-2CH]                    ; 059F _ 8B. 55, D4
        mov     byte [rax], dl                          ; 05A2 _ 88. 10
        jmp     ?_058                                   ; 05A4 _ E9, 0000013F

?_049:  mov     eax, dword [rbp-2CH]                    ; 05A9 _ 8B. 45, D4
        shr     eax, 6                                  ; 05AC _ C1. E8, 06
        mov     dword [rbp-14H], eax                    ; 05AF _ 89. 45, EC
        cmp     dword [rbp-14H], 31                     ; 05B2 _ 83. 7D, EC, 1F
        ja      ?_050                                   ; 05B6 _ 77, 1B
        mov     eax, dword [rbp-14H]                    ; 05B8 _ 8B. 45, EC
        mov     ecx, eax                                ; 05BB _ 89. C1
        mov     rax, qword [rbp-28H]                    ; 05BD _ 48: 8B. 45, D8
        lea     rdx, [rax+1H]                           ; 05C1 _ 48: 8D. 50, 01
        mov     qword [rbp-28H], rdx                    ; 05C5 _ 48: 89. 55, D8
        lea     edx, [rcx-40H]                          ; 05C9 _ 8D. 51, C0
        mov     byte [rax], dl                          ; 05CC _ 88. 10
        jmp     ?_057                                   ; 05CE _ E9, 000000FC

?_050:  mov     eax, dword [rbp-14H]                    ; 05D3 _ 8B. 45, EC
        shr     eax, 6                                  ; 05D6 _ C1. E8, 06
        mov     dword [rbp-10H], eax                    ; 05D9 _ 89. 45, F0
        cmp     dword [rbp-10H], 15                     ; 05DC _ 83. 7D, F0, 0F
        ja      ?_051                                   ; 05E0 _ 77, 1B
        mov     eax, dword [rbp-10H]                    ; 05E2 _ 8B. 45, F0
        mov     ecx, eax                                ; 05E5 _ 89. C1
        mov     rax, qword [rbp-28H]                    ; 05E7 _ 48: 8B. 45, D8
        lea     rdx, [rax+1H]                           ; 05EB _ 48: 8D. 50, 01
        mov     qword [rbp-28H], rdx                    ; 05EF _ 48: 89. 55, D8
        lea     edx, [rcx-20H]                          ; 05F3 _ 8D. 51, E0
        mov     byte [rax], dl                          ; 05F6 _ 88. 10
        jmp     ?_056                                   ; 05F8 _ E9, 000000B9

?_051:  mov     eax, dword [rbp-10H]                    ; 05FD _ 8B. 45, F0
        shr     eax, 6                                  ; 0600 _ C1. E8, 06
        mov     dword [rbp-0CH], eax                    ; 0603 _ 89. 45, F4
        cmp     dword [rbp-0CH], 7                      ; 0606 _ 83. 7D, F4, 07
        ja      ?_052                                   ; 060A _ 77, 18
        mov     eax, dword [rbp-0CH]                    ; 060C _ 8B. 45, F4
        mov     ecx, eax                                ; 060F _ 89. C1
        mov     rax, qword [rbp-28H]                    ; 0611 _ 48: 8B. 45, D8
        lea     rdx, [rax+1H]                           ; 0615 _ 48: 8D. 50, 01
        mov     qword [rbp-28H], rdx                    ; 0619 _ 48: 89. 55, D8
        lea     edx, [rcx-10H]                          ; 061D _ 8D. 51, F0
        mov     byte [rax], dl                          ; 0620 _ 88. 10
        jmp     ?_055                                   ; 0622 _ EB, 79

?_052:  mov     eax, dword [rbp-0CH]                    ; 0624 _ 8B. 45, F4
        shr     eax, 6                                  ; 0627 _ C1. E8, 06
        mov     dword [rbp-8H], eax                     ; 062A _ 89. 45, F8
        cmp     dword [rbp-8H], 3                       ; 062D _ 83. 7D, F8, 03
        ja      ?_053                                   ; 0631 _ 77, 18
        mov     eax, dword [rbp-8H]                     ; 0633 _ 8B. 45, F8
        mov     ecx, eax                                ; 0636 _ 89. C1
        mov     rax, qword [rbp-28H]                    ; 0638 _ 48: 8B. 45, D8
        lea     rdx, [rax+1H]                           ; 063C _ 48: 8D. 50, 01
        mov     qword [rbp-28H], rdx                    ; 0640 _ 48: 89. 55, D8
        lea     edx, [rcx-8H]                           ; 0644 _ 8D. 51, F8
        mov     byte [rax], dl                          ; 0647 _ 88. 10
        jmp     ?_054                                   ; 0649 _ EB, 39

?_053:  mov     eax, dword [rbp-8H]                     ; 064B _ 8B. 45, F8
        shr     eax, 6                                  ; 064E _ C1. E8, 06
        mov     dword [rbp-4H], eax                     ; 0651 _ 89. 45, FC
        mov     eax, dword [rbp-4H]                     ; 0654 _ 8B. 45, FC
        mov     ecx, eax                                ; 0657 _ 89. C1
        mov     rax, qword [rbp-28H]                    ; 0659 _ 48: 8B. 45, D8
        lea     rdx, [rax+1H]                           ; 065D _ 48: 8D. 50, 01
        mov     qword [rbp-28H], rdx                    ; 0661 _ 48: 89. 55, D8
        lea     edx, [rcx-4H]                           ; 0665 _ 8D. 51, FC
        mov     byte [rax], dl                          ; 0668 _ 88. 10
        nop                                             ; 066A _ 90
        mov     eax, dword [rbp-8H]                     ; 066B _ 8B. 45, F8
        and     eax, 3FH                                ; 066E _ 83. E0, 3F
        mov     ecx, eax                                ; 0671 _ 89. C1
        mov     rax, qword [rbp-28H]                    ; 0673 _ 48: 8B. 45, D8
        lea     rdx, [rax+1H]                           ; 0677 _ 48: 8D. 50, 01
        mov     qword [rbp-28H], rdx                    ; 067B _ 48: 89. 55, D8
        lea     edx, [rcx-80H]                          ; 067F _ 8D. 51, 80
        mov     byte [rax], dl                          ; 0682 _ 88. 10
?_054:  mov     eax, dword [rbp-0CH]                    ; 0684 _ 8B. 45, F4
        and     eax, 3FH                                ; 0687 _ 83. E0, 3F
        mov     ecx, eax                                ; 068A _ 89. C1
        mov     rax, qword [rbp-28H]                    ; 068C _ 48: 8B. 45, D8
        lea     rdx, [rax+1H]                           ; 0690 _ 48: 8D. 50, 01
        mov     qword [rbp-28H], rdx                    ; 0694 _ 48: 89. 55, D8
        lea     edx, [rcx-80H]                          ; 0698 _ 8D. 51, 80
        mov     byte [rax], dl                          ; 069B _ 88. 10
?_055:  mov     eax, dword [rbp-10H]                    ; 069D _ 8B. 45, F0
        and     eax, 3FH                                ; 06A0 _ 83. E0, 3F
        mov     ecx, eax                                ; 06A3 _ 89. C1
        mov     rax, qword [rbp-28H]                    ; 06A5 _ 48: 8B. 45, D8
        lea     rdx, [rax+1H]                           ; 06A9 _ 48: 8D. 50, 01
        mov     qword [rbp-28H], rdx                    ; 06AD _ 48: 89. 55, D8
        lea     edx, [rcx-80H]                          ; 06B1 _ 8D. 51, 80
        mov     byte [rax], dl                          ; 06B4 _ 88. 10
?_056:  mov     eax, dword [rbp-14H]                    ; 06B6 _ 8B. 45, EC
        and     eax, 3FH                                ; 06B9 _ 83. E0, 3F
        mov     ecx, eax                                ; 06BC _ 89. C1
        mov     rax, qword [rbp-28H]                    ; 06BE _ 48: 8B. 45, D8
        lea     rdx, [rax+1H]                           ; 06C2 _ 48: 8D. 50, 01
        mov     qword [rbp-28H], rdx                    ; 06C6 _ 48: 89. 55, D8
        lea     edx, [rcx-80H]                          ; 06CA _ 8D. 51, 80
        mov     byte [rax], dl                          ; 06CD _ 88. 10
?_057:  mov     eax, dword [rbp-2CH]                    ; 06CF _ 8B. 45, D4
        and     eax, 3FH                                ; 06D2 _ 83. E0, 3F
        mov     ecx, eax                                ; 06D5 _ 89. C1
        mov     rax, qword [rbp-28H]                    ; 06D7 _ 48: 8B. 45, D8
        lea     rdx, [rax+1H]                           ; 06DB _ 48: 8D. 50, 01
        mov     qword [rbp-28H], rdx                    ; 06DF _ 48: 89. 55, D8
        lea     edx, [rcx-80H]                          ; 06E3 _ 8D. 51, 80
        mov     byte [rax], dl                          ; 06E6 _ 88. 10
?_058:  mov     rax, qword [rbp-28H]                    ; 06E8 _ 48: 8B. 45, D8
        pop     rbp                                     ; 06EC _ 5D
        ret                                             ; 06ED _ C3

ctlbit: ; Local function
        push    rbp                                     ; 06EE _ 55
        mov     rbp, rsp                                ; 06EF _ 48: 89. E5
        mov     dword [rbp-4H], edi                     ; 06F2 _ 89. 7D, FC
        cmp     dword [rbp-4H], 31                      ; 06F5 _ 83. 7D, FC, 1F
        setbe   al                                      ; 06F9 _ 0F 96. C0
        movzx   eax, al                                 ; 06FC _ 0F B6. C0
        test    rax, rax                                ; 06FF _ 48: 85. C0
        jz      ?_059                                   ; 0702 _ 74, 10
        mov     eax, dword [rbp-4H]                     ; 0704 _ 8B. 45, FC
        mov     edx, 1                                  ; 0707 _ BA, 00000001
        mov     ecx, eax                                ; 070C _ 89. C1
        shl     edx, cl                                 ; 070E _ D3. E2
        mov     eax, edx                                ; 0710 _ 89. D0
        jmp     ?_060                                   ; 0712 _ EB, 05

?_059:  mov     eax, 0                                  ; 0714 _ B8, 00000000
?_060:  pop     rbp                                     ; 0719 _ 5D
        ret                                             ; 071A _ C3

nasm_quote_cstr:; Function begin
        push    rbp                                     ; 071B _ 55
        mov     rbp, rsp                                ; 071C _ 48: 89. E5
        sub     rsp, 48                                 ; 071F _ 48: 83. EC, 30
        mov     qword [rbp-28H], rdi                    ; 0723 _ 48: 89. 7D, D8
        mov     qword [rbp-30H], rsi                    ; 0727 _ 48: 89. 75, D0
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        mov     rax, qword [fs:abs 28H]                 ; 072B _ 64 48: 8B. 04 25, 00000028
        mov     qword [rbp-8H], rax                     ; 0734 _ 48: 89. 45, F8
        xor     eax, eax                                ; 0738 _ 31. C0
        mov     rax, qword [rbp-28H]                    ; 073A _ 48: 8B. 45, D8
        mov     rdi, rax                                ; 073E _ 48: 89. C7
        call    strlen                                  ; 0741 _ E8, 00000000(PLT r)
        mov     qword [rbp-18H], rax                    ; 0746 _ 48: 89. 45, E8
        lea     rdx, [rbp-18H]                          ; 074A _ 48: 8D. 55, E8
        mov     rax, qword [rbp-28H]                    ; 074E _ 48: 8B. 45, D8
        mov     rsi, rdx                                ; 0752 _ 48: 89. D6
        mov     rdi, rax                                ; 0755 _ 48: 89. C7
        call    nasm_quote                              ; 0758 _ E8, 00000000(PLT r)
        mov     qword [rbp-10H], rax                    ; 075D _ 48: 89. 45, F0
        cmp     qword [rbp-30H], 0                      ; 0761 _ 48: 83. 7D, D0, 00
        jz      ?_061                                   ; 0766 _ 74, 0B
        mov     rdx, qword [rbp-18H]                    ; 0768 _ 48: 8B. 55, E8
        mov     rax, qword [rbp-30H]                    ; 076C _ 48: 8B. 45, D0
        mov     qword [rax], rdx                        ; 0770 _ 48: 89. 10
?_061:  mov     rax, qword [rbp-10H]                    ; 0773 _ 48: 8B. 45, F0
        mov     rdx, qword [rbp-8H]                     ; 0777 _ 48: 8B. 55, F8
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        sub     rdx, qword [fs:abs 28H]                 ; 077B _ 64 48: 2B. 14 25, 00000028
        jz      ?_062                                   ; 0784 _ 74, 05
        call    __stack_chk_fail                        ; 0786 _ E8, 00000000(PLT r)
?_062:  leave                                           ; 078B _ C9
        ret                                             ; 078C _ C3
; nasm_quote_cstr End of function

nasm_unquote_anystr:; Function begin
        push    rbp                                     ; 078D _ 55
        mov     rbp, rsp                                ; 078E _ 48: 89. E5
        sub     rsp, 96                                 ; 0791 _ 48: 83. EC, 60
        mov     qword [rbp-48H], rdi                    ; 0795 _ 48: 89. 7D, B8
        mov     qword [rbp-50H], rsi                    ; 0799 _ 48: 89. 75, B0
        mov     dword [rbp-54H], edx                    ; 079D _ 89. 55, AC
        mov     byte [rbp-55H], cl                      ; 07A0 _ 88. 4D, AB
        mov     rax, qword [rbp-48H]                    ; 07A3 _ 48: 8B. 45, B8
        movzx   eax, byte [rax]                         ; 07A7 _ 0F B6. 00
        mov     byte [rbp-3FH], al                      ; 07AA _ 88. 45, C1
        mov     rax, qword [rbp-48H]                    ; 07AD _ 48: 8B. 45, B8
        mov     qword [rbp-20H], rax                    ; 07B1 _ 48: 89. 45, E0
        mov     rax, qword [rbp-48H]                    ; 07B5 _ 48: 8B. 45, B8
        mov     qword [rbp-18H], rax                    ; 07B9 _ 48: 89. 45, E8
        mov     dword [rbp-38H], 0                      ; 07BD _ C7. 45, C8, 00000000
        movzx   eax, byte [rbp-55H]                     ; 07C4 _ 0F B6. 45, AB
        cmp     byte [rbp-3FH], al                      ; 07C8 _ 38. 45, C1
        jne     ?_105                                   ; 07CB _ 0F 85, 0000050E
        mov     dword [rbp-34H], 0                      ; 07D1 _ C7. 45, CC, 00000000
        mov     dword [rbp-30H], 0                      ; 07D8 _ C7. 45, D0, 00000000
        mov     qword [rbp-10H], 0                      ; 07DF _ 48: C7. 45, F0, 00000000
        mov     dword [rbp-2CH], 0                      ; 07E7 _ C7. 45, D4, 00000000
        mov     qword [rbp-8H], 0                       ; 07EE _ 48: C7. 45, F8, 00000000
        add     qword [rbp-20H], 1                      ; 07F6 _ 48: 83. 45, E0, 01
        jmp     ?_104                                   ; 07FB _ E9, 000004D0

?_063:  mov     rax, qword [rbp-20H]                    ; 0800 _ 48: 8B. 45, E0
        lea     rdx, [rax+1H]                           ; 0804 _ 48: 8D. 50, 01
        mov     qword [rbp-20H], rdx                    ; 0808 _ 48: 89. 55, E0
        movzx   eax, byte [rax]                         ; 080C _ 0F B6. 00
        mov     byte [rbp-40H], al                      ; 080F _ 88. 45, C0
        cmp     dword [rbp-34H], 4                      ; 0812 _ 83. 7D, CC, 04
        je      ?_096                                   ; 0816 _ 0F 84, 00000431
        cmp     dword [rbp-34H], 4                      ; 081C _ 83. 7D, CC, 04
        ja      ?_103                                   ; 0820 _ 0F 87, 0000048C
        cmp     dword [rbp-34H], 3                      ; 0826 _ 83. 7D, CC, 03
        ja      ?_103                                   ; 082A _ 0F 87, 00000482
        cmp     dword [rbp-34H], 2                      ; 0830 _ 83. 7D, CC, 02
        jnc     ?_090                                   ; 0834 _ 0F 83, 00000327
        cmp     dword [rbp-34H], 0                      ; 083A _ 83. 7D, CC, 00
        jz      ?_064                                   ; 083E _ 74, 0B
        cmp     dword [rbp-34H], 1                      ; 0840 _ 83. 7D, CC, 01
        jz      ?_069                                   ; 0844 _ 74, 69
        jmp     ?_103                                   ; 0846 _ E9, 00000467

?_064:  cmp     byte [rbp-40H], 92                      ; 084B _ 80. 7D, C0, 5C
        jnz     ?_065                                   ; 084F _ 75, 0C
        mov     dword [rbp-34H], 1                      ; 0851 _ C7. 45, CC, 00000001
        jmp     ?_104                                   ; 0858 _ E9, 00000473

?_065:  cmp     byte [rbp-40H], 0                       ; 085D _ 80. 7D, C0, 00
        jz      ?_066                                   ; 0861 _ 74, 09
        movzx   eax, byte [rbp-40H]                     ; 0863 _ 0F B6. 45, C0
        cmp     al, byte [rbp-3FH]                      ; 0867 _ 3A. 45, C1
        jnz     ?_067                                   ; 086A _ 75, 09
?_066:  mov     dword [rbp-34H], 5                      ; 086C _ C7. 45, CC, 00000005
        jmp     ?_068                                   ; 0873 _ EB, 35

?_067:  movzx   eax, byte [rbp-40H]                     ; 0875 _ 0F B6. 45, C0
        mov     byte [rbp-39H], al                      ; 0879 _ 88. 45, C7
        movzx   eax, byte [rbp-39H]                     ; 087C _ 0F B6. 45, C7
        mov     edi, eax                                ; 0880 _ 89. C7
        call    ctlbit                                  ; 0882 _ E8, FFFFFE67
        or      dword [rbp-38H], eax                    ; 0887 _ 09. 45, C8
        mov     eax, dword [rbp-38H]                    ; 088A _ 8B. 45, C8
        and     eax, dword [rbp-54H]                    ; 088D _ 23. 45, AC
        test    eax, eax                                ; 0890 _ 85. C0
        jne     ?_104                                   ; 0892 _ 0F 85, 00000438
        mov     rax, qword [rbp-18H]                    ; 0898 _ 48: 8B. 45, E8
        lea     rdx, [rax+1H]                           ; 089C _ 48: 8D. 50, 01
        mov     qword [rbp-18H], rdx                    ; 08A0 _ 48: 89. 55, E8
        movzx   edx, byte [rbp-39H]                     ; 08A4 _ 0F B6. 55, C7
        mov     byte [rax], dl                          ; 08A8 _ 88. 10
?_068:  jmp     ?_104                                   ; 08AA _ E9, 00000421

?_069:  mov     dword [rbp-34H], 0                      ; 08AF _ C7. 45, CC, 00000000
        mov     rax, qword [rbp-20H]                    ; 08B6 _ 48: 8B. 45, E0
        sub     rax, 1                                  ; 08BA _ 48: 83. E8, 01
        mov     qword [rbp-8H], rax                     ; 08BE _ 48: 89. 45, F8
        mov     qword [rbp-10H], 0                      ; 08C2 _ 48: C7. 45, F0, 00000000
        movzx   eax, byte [rbp-40H]                     ; 08CA _ 0F B6. 45, C0
        cmp     eax, 120                                ; 08CE _ 83. F8, 78
        je      ?_081                                   ; 08D1 _ 0F 84, 000001C0
        cmp     eax, 120                                ; 08D7 _ 83. F8, 78
        jg      ?_087                                   ; 08DA _ 0F 8F, 00000232
        cmp     eax, 118                                ; 08E0 _ 83. F8, 76
        je      ?_080                                   ; 08E3 _ 0F 84, 000001A1
        cmp     eax, 118                                ; 08E9 _ 83. F8, 76
        jg      ?_087                                   ; 08EC _ 0F 8F, 00000220
        cmp     eax, 117                                ; 08F2 _ 83. F8, 75
        je      ?_078                                   ; 08F5 _ 0F 84, 00000161
        cmp     eax, 117                                ; 08FB _ 83. F8, 75
        jg      ?_087                                   ; 08FE _ 0F 8F, 0000020E
        cmp     eax, 116                                ; 0904 _ 83. F8, 74
        je      ?_076                                   ; 0907 _ 0F 84, 00000136
        cmp     eax, 116                                ; 090D _ 83. F8, 74
        jg      ?_087                                   ; 0910 _ 0F 8F, 000001FC
        cmp     eax, 114                                ; 0916 _ 83. F8, 72
        je      ?_075                                   ; 0919 _ 0F 84, 00000117
        cmp     eax, 114                                ; 091F _ 83. F8, 72
        jg      ?_087                                   ; 0922 _ 0F 8F, 000001EA
        cmp     eax, 111                                ; 0928 _ 83. F8, 6F
        je      ?_084                                   ; 092B _ 0F 84, 000001A4
        cmp     eax, 111                                ; 0931 _ 83. F8, 6F
        jg      ?_087                                   ; 0934 _ 0F 8F, 000001D8
        cmp     eax, 110                                ; 093A _ 83. F8, 6E
        je      ?_074                                   ; 093D _ 0F 84, 000000E6
        cmp     eax, 110                                ; 0943 _ 83. F8, 6E
        jg      ?_087                                   ; 0946 _ 0F 8F, 000001C6
        cmp     eax, 102                                ; 094C _ 83. F8, 66
        je      ?_073                                   ; 094F _ 0F 84, 000000C7
        cmp     eax, 102                                ; 0955 _ 83. F8, 66
        jg      ?_087                                   ; 0958 _ 0F 8F, 000001B4
        cmp     eax, 101                                ; 095E _ 83. F8, 65
        je      ?_072                                   ; 0961 _ 0F 84, 000000A8
        cmp     eax, 101                                ; 0967 _ 83. F8, 65
        jg      ?_087                                   ; 096A _ 0F 8F, 000001A2
        cmp     eax, 100                                ; 0970 _ 83. F8, 64
        je      ?_082                                   ; 0973 _ 0F 84, 00000135
        cmp     eax, 100                                ; 0979 _ 83. F8, 64
        jg      ?_087                                   ; 097C _ 0F 8F, 00000190
        cmp     eax, 98                                 ; 0982 _ 83. F8, 62
        jz      ?_071                                   ; 0985 _ 74, 7B
        cmp     eax, 98                                 ; 0987 _ 83. F8, 62
        jg      ?_087                                   ; 098A _ 0F 8F, 00000182
        cmp     eax, 97                                 ; 0990 _ 83. F8, 61
        jz      ?_070                                   ; 0993 _ 74, 60
        cmp     eax, 97                                 ; 0995 _ 83. F8, 61
        jg      ?_087                                   ; 0998 _ 0F 8F, 00000174
        cmp     eax, 94                                 ; 099E _ 83. F8, 5E
        je      ?_077                                   ; 09A1 _ 0F 84, 000000A9
        cmp     eax, 94                                 ; 09A7 _ 83. F8, 5E
        jg      ?_087                                   ; 09AA _ 0F 8F, 00000162
        cmp     eax, 88                                 ; 09B0 _ 83. F8, 58
        je      ?_081                                   ; 09B3 _ 0F 84, 000000DE
        cmp     eax, 88                                 ; 09B9 _ 83. F8, 58
        jg      ?_087                                   ; 09BC _ 0F 8F, 00000150
        cmp     eax, 85                                 ; 09C2 _ 83. F8, 55
        je      ?_079                                   ; 09C5 _ 0F 84, 000000A8
        cmp     eax, 85                                 ; 09CB _ 83. F8, 55
        jg      ?_087                                   ; 09CE _ 0F 8F, 0000013E
        test    eax, eax                                ; 09D4 _ 85. C0
        je      ?_086                                   ; 09D6 _ 0F 84, 00000127
        test    eax, eax                                ; 09DC _ 85. C0
        js      ?_087                                   ; 09DE _ 0F 88, 0000012E
        sub     eax, 48                                 ; 09E4 _ 83. E8, 30
        cmp     eax, 7                                  ; 09E7 _ 83. F8, 07
        ja      ?_087                                   ; 09EA _ 0F 87, 00000122
        jmp     ?_083                                   ; 09F0 _ E9, 000000D0

?_070:  mov     qword [rbp-10H], 7                      ; 09F5 _ 48: C7. 45, F0, 00000007
        jmp     ?_089                                   ; 09FD _ E9, 0000011B

?_071:  mov     qword [rbp-10H], 8                      ; 0A02 _ 48: C7. 45, F0, 00000008
        jmp     ?_089                                   ; 0A0A _ E9, 0000010E

?_072:  mov     qword [rbp-10H], 27                     ; 0A0F _ 48: C7. 45, F0, 0000001B
        jmp     ?_089                                   ; 0A17 _ E9, 00000101

?_073:  mov     qword [rbp-10H], 12                     ; 0A1C _ 48: C7. 45, F0, 0000000C
        jmp     ?_089                                   ; 0A24 _ E9, 000000F4

?_074:  mov     qword [rbp-10H], 10                     ; 0A29 _ 48: C7. 45, F0, 0000000A
        jmp     ?_089                                   ; 0A31 _ E9, 000000E7

?_075:  mov     qword [rbp-10H], 13                     ; 0A36 _ 48: C7. 45, F0, 0000000D
        jmp     ?_089                                   ; 0A3E _ E9, 000000DA

?_076:  mov     qword [rbp-10H], 9                      ; 0A43 _ 48: C7. 45, F0, 00000009
        jmp     ?_089                                   ; 0A4B _ E9, 000000CD

?_077:  mov     dword [rbp-34H], 4                      ; 0A50 _ C7. 45, CC, 00000004
        jmp     ?_089                                   ; 0A57 _ E9, 000000C1

?_078:  mov     dword [rbp-34H], 3                      ; 0A5C _ C7. 45, CC, 00000003
        mov     dword [rbp-30H], 16                     ; 0A63 _ C7. 45, D0, 00000010
        mov     dword [rbp-2CH], 4                      ; 0A6A _ C7. 45, D4, 00000004
        jmp     ?_085                                   ; 0A71 _ EB, 77

?_079:  mov     dword [rbp-34H], 3                      ; 0A73 _ C7. 45, CC, 00000003
        mov     dword [rbp-30H], 16                     ; 0A7A _ C7. 45, D0, 00000010
        mov     dword [rbp-2CH], 8                      ; 0A81 _ C7. 45, D4, 00000008
        jmp     ?_085                                   ; 0A88 _ EB, 60

?_080:  mov     qword [rbp-10H], 11                     ; 0A8A _ 48: C7. 45, F0, 0000000B
        jmp     ?_089                                   ; 0A92 _ E9, 00000086

?_081:  mov     dword [rbp-34H], 2                      ; 0A97 _ C7. 45, CC, 00000002
        mov     dword [rbp-30H], 16                     ; 0A9E _ C7. 45, D0, 00000010
        mov     dword [rbp-2CH], 2                      ; 0AA5 _ C7. 45, D4, 00000002
        jmp     ?_085                                   ; 0AAC _ EB, 3C

?_082:  mov     dword [rbp-34H], 2                      ; 0AAE _ C7. 45, CC, 00000002
        mov     dword [rbp-30H], 10                     ; 0AB5 _ C7. 45, D0, 0000000A
        mov     dword [rbp-2CH], 3                      ; 0ABC _ C7. 45, D4, 00000003
        jmp     ?_085                                   ; 0AC3 _ EB, 25

?_083:  mov     rax, qword [rbp-8H]                     ; 0AC5 _ 48: 8B. 45, F8
        lea     rdx, [rax-1H]                           ; 0AC9 _ 48: 8D. 50, FF
        mov     qword [rbp-8H], rdx                     ; 0ACD _ 48: 89. 55, F8
        mov     qword [rbp-20H], rax                    ; 0AD1 _ 48: 89. 45, E0
?_084:  mov     dword [rbp-34H], 2                      ; 0AD5 _ C7. 45, CC, 00000002
        mov     dword [rbp-2CH], 3                      ; 0ADC _ C7. 45, D4, 00000003
        mov     dword [rbp-30H], 8                      ; 0AE3 _ C7. 45, D0, 00000008
?_085:  mov     rax, qword [rbp-20H]                    ; 0AEA _ 48: 8B. 45, E0
        movzx   eax, byte [rax]                         ; 0AEE _ 0F B6. 00
        cmp     al, 123                                 ; 0AF1 _ 3C, 7B
        jnz     ?_088                                   ; 0AF3 _ 75, 27
        add     qword [rbp-20H], 1                      ; 0AF5 _ 48: 83. 45, E0, 01
        mov     dword [rbp-2CH], -1                     ; 0AFA _ C7. 45, D4, FFFFFFFF
        jmp     ?_088                                   ; 0B01 _ EB, 19

?_086:  mov     qword [rbp-10H], 92                     ; 0B03 _ 48: C7. 45, F0, 0000005C
        sub     qword [rbp-20H], 1                      ; 0B0B _ 48: 83. 6D, E0, 01
        jmp     ?_089                                   ; 0B10 _ EB, 0B

?_087:  movzx   eax, byte [rbp-40H]                     ; 0B12 _ 0F B6. 45, C0
        mov     qword [rbp-10H], rax                    ; 0B16 _ 48: 89. 45, F0
        jmp     ?_089                                   ; 0B1A _ EB, 01

?_088:  nop                                             ; 0B1C _ 90
?_089:  cmp     dword [rbp-34H], 0                      ; 0B1D _ 83. 7D, CC, 00
        jne     ?_104                                   ; 0B21 _ 0F 85, 000001A9
        mov     rax, qword [rbp-10H]                    ; 0B27 _ 48: 8B. 45, F0
        mov     byte [rbp-3AH], al                      ; 0B2B _ 88. 45, C6
        movzx   eax, byte [rbp-3AH]                     ; 0B2E _ 0F B6. 45, C6
        mov     edi, eax                                ; 0B32 _ 89. C7
        call    ctlbit                                  ; 0B34 _ E8, FFFFFBB5
        or      dword [rbp-38H], eax                    ; 0B39 _ 09. 45, C8
        mov     eax, dword [rbp-38H]                    ; 0B3C _ 8B. 45, C8
        and     eax, dword [rbp-54H]                    ; 0B3F _ 23. 45, AC
        test    eax, eax                                ; 0B42 _ 85. C0
        jne     ?_104                                   ; 0B44 _ 0F 85, 00000186
        mov     rax, qword [rbp-18H]                    ; 0B4A _ 48: 8B. 45, E8
        lea     rdx, [rax+1H]                           ; 0B4E _ 48: 8D. 50, 01
        mov     qword [rbp-18H], rdx                    ; 0B52 _ 48: 89. 55, E8
        movzx   edx, byte [rbp-3AH]                     ; 0B56 _ 0F B6. 55, C6
        mov     byte [rax], dl                          ; 0B5A _ 88. 10
        jmp     ?_104                                   ; 0B5C _ E9, 0000016F

?_090:  movzx   eax, byte [rbp-40H]                     ; 0B61 _ 0F B6. 45, C0
        mov     edi, eax                                ; 0B65 _ 89. C7
        call    numvalue_chk                            ; 0B67 _ E8, FFFFF494
        mov     dword [rbp-28H], eax                    ; 0B6C _ 89. 45, D8
        mov     eax, dword [rbp-28H]                    ; 0B6F _ 8B. 45, D8
        cmp     eax, dword [rbp-30H]                    ; 0B72 _ 3B. 45, D0
        jnc     ?_091                                   ; 0B75 _ 73, 24
        mov     eax, dword [rbp-30H]                    ; 0B77 _ 8B. 45, D0
        imul    rax, qword [rbp-10H]                    ; 0B7A _ 48: 0F AF. 45, F0
        mov     rdx, rax                                ; 0B7F _ 48: 89. C2
        mov     eax, dword [rbp-28H]                    ; 0B82 _ 8B. 45, D8
        add     rax, rdx                                ; 0B85 _ 48: 01. D0
        mov     qword [rbp-10H], rax                    ; 0B88 _ 48: 89. 45, F0
        sub     dword [rbp-2CH], 1                      ; 0B8C _ 83. 6D, D4, 01
        cmp     dword [rbp-2CH], 0                      ; 0B90 _ 83. 7D, D4, 00
        jz      ?_093                                   ; 0B94 _ 74, 3F
        jmp     ?_104                                   ; 0B96 _ E9, 00000135

?_091:  cmp     dword [rbp-2CH], 0                      ; 0B9B _ 83. 7D, D4, 00
        jns     ?_092                                   ; 0B9F _ 79, 14
        cmp     byte [rbp-40H], 125                     ; 0BA1 _ 80. 7D, C0, 7D
        setne   al                                      ; 0BA5 _ 0F 95. C0
        movzx   eax, al                                 ; 0BA8 _ 0F B6. C0
        test    rax, rax                                ; 0BAB _ 48: 85. C0
        jz      ?_093                                   ; 0BAE _ 74, 25
        jmp     ?_102                                   ; 0BB0 _ E9, 000000EC

?_092:  sub     qword [rbp-20H], 1                      ; 0BB5 _ 48: 83. 6D, E0, 01
        mov     rax, qword [rbp-8H]                     ; 0BBA _ 48: 8B. 45, F8
        add     rax, 1                                  ; 0BBE _ 48: 83. C0, 01
        cmp     qword [rbp-20H], rax                    ; 0BC2 _ 48: 39. 45, E0
        sete    al                                      ; 0BC6 _ 0F 94. C0
        movzx   eax, al                                 ; 0BC9 _ 0F B6. C0
        test    rax, rax                                ; 0BCC _ 48: 85. C0
        jne     ?_100                                   ; 0BCF _ 0F 85, 000000C8
?_093:  cmp     dword [rbp-34H], 3                      ; 0BD5 _ 83. 7D, CC, 03
        jnz     ?_094                                   ; 0BD9 _ 75, 35
        mov     rax, qword [rbp-10H]                    ; 0BDB _ 48: 8B. 45, F0
        mov     dword [rbp-24H], eax                    ; 0BDF _ 89. 45, DC
        mov     eax, dword [rbp-24H]                    ; 0BE2 _ 8B. 45, DC
        mov     edi, eax                                ; 0BE5 _ 89. C7
        call    ctlbit                                  ; 0BE7 _ E8, FFFFFB02
        or      dword [rbp-38H], eax                    ; 0BEC _ 09. 45, C8
        mov     eax, dword [rbp-38H]                    ; 0BEF _ 8B. 45, C8
        and     eax, dword [rbp-54H]                    ; 0BF2 _ 23. 45, AC
        test    eax, eax                                ; 0BF5 _ 85. C0
        jnz     ?_095                                   ; 0BF7 _ 75, 48
        mov     edx, dword [rbp-24H]                    ; 0BF9 _ 8B. 55, DC
        mov     rax, qword [rbp-18H]                    ; 0BFC _ 48: 8B. 45, E8
        mov     esi, edx                                ; 0C00 _ 89. D6
        mov     rdi, rax                                ; 0C02 _ 48: 89. C7
        call    emit_utf8                               ; 0C05 _ E8, FFFFF978
        mov     qword [rbp-18H], rax                    ; 0C0A _ 48: 89. 45, E8
        jmp     ?_095                                   ; 0C0E _ EB, 31

?_094:  mov     rax, qword [rbp-10H]                    ; 0C10 _ 48: 8B. 45, F0
        mov     byte [rbp-3BH], al                      ; 0C14 _ 88. 45, C5
        movzx   eax, byte [rbp-3BH]                     ; 0C17 _ 0F B6. 45, C5
        mov     edi, eax                                ; 0C1B _ 89. C7
        call    ctlbit                                  ; 0C1D _ E8, FFFFFACC
        or      dword [rbp-38H], eax                    ; 0C22 _ 09. 45, C8
        mov     eax, dword [rbp-38H]                    ; 0C25 _ 8B. 45, C8
        and     eax, dword [rbp-54H]                    ; 0C28 _ 23. 45, AC
        test    eax, eax                                ; 0C2B _ 85. C0
        jnz     ?_095                                   ; 0C2D _ 75, 12
        mov     rax, qword [rbp-18H]                    ; 0C2F _ 48: 8B. 45, E8
        lea     rdx, [rax+1H]                           ; 0C33 _ 48: 8D. 50, 01
        mov     qword [rbp-18H], rdx                    ; 0C37 _ 48: 89. 55, E8
        movzx   edx, byte [rbp-3BH]                     ; 0C3B _ 0F B6. 55, C5
        mov     byte [rax], dl                          ; 0C3F _ 88. 10
?_095:  mov     dword [rbp-34H], 0                      ; 0C41 _ C7. 45, CC, 00000000
        jmp     ?_104                                   ; 0C48 _ E9, 00000083

?_096:  cmp     byte [rbp-40H], 0                       ; 0C4D _ 80. 7D, C0, 00
        jz      ?_101                                   ; 0C51 _ 74, 4D
        cmp     byte [rbp-40H], 63                      ; 0C53 _ 80. 7D, C0, 3F
        jnz     ?_097                                   ; 0C57 _ 75, 06
        mov     byte [rbp-40H], 127                     ; 0C59 _ C6. 45, C0, 7F
        jmp     ?_098                                   ; 0C5D _ EB, 04

?_097:  and     byte [rbp-40H], 9FH                     ; 0C5F _ 80. 65, C0, 9F
?_098:  movzx   eax, byte [rbp-40H]                     ; 0C63 _ 0F B6. 45, C0
        mov     byte [rbp-3CH], al                      ; 0C67 _ 88. 45, C4
        movzx   eax, byte [rbp-3CH]                     ; 0C6A _ 0F B6. 45, C4
        mov     edi, eax                                ; 0C6E _ 89. C7
        call    ctlbit                                  ; 0C70 _ E8, FFFFFA79
        or      dword [rbp-38H], eax                    ; 0C75 _ 09. 45, C8
        mov     eax, dword [rbp-38H]                    ; 0C78 _ 8B. 45, C8
        and     eax, dword [rbp-54H]                    ; 0C7B _ 23. 45, AC
        test    eax, eax                                ; 0C7E _ 85. C0
        jnz     ?_099                                   ; 0C80 _ 75, 12
        mov     rax, qword [rbp-18H]                    ; 0C82 _ 48: 8B. 45, E8
        lea     rdx, [rax+1H]                           ; 0C86 _ 48: 8D. 50, 01
        mov     qword [rbp-18H], rdx                    ; 0C8A _ 48: 89. 55, E8
        movzx   edx, byte [rbp-3CH]                     ; 0C8E _ 0F B6. 55, C4
        mov     byte [rax], dl                          ; 0C92 _ 88. 10
?_099:  mov     dword [rbp-34H], 0                      ; 0C94 _ C7. 45, CC, 00000000
        jmp     ?_104                                   ; 0C9B _ EB, 33

?_100:  nop                                             ; 0C9D _ 90
        jmp     ?_102                                   ; 0C9E _ EB, 01

?_101:  nop                                             ; 0CA0 _ 90
?_102:  mov     rax, qword [rbp-8H]                     ; 0CA1 _ 48: 8B. 45, F8
        mov     qword [rbp-20H], rax                    ; 0CA5 _ 48: 89. 45, E0
        mov     dword [rbp-34H], 0                      ; 0CA9 _ C7. 45, CC, 00000000
        jmp     ?_104                                   ; 0CB0 _ EB, 1E

?_103:  lea     rcx, [rel ?_132]                        ; 0CB2 _ 48: 8D. 0D, 00000000(rel)
        lea     rax, [rel __func__.1]                   ; 0CB9 _ 48: 8D. 05, 00000000(rel)
        mov     edx, 445                                ; 0CC0 _ BA, 000001BD
        mov     rsi, rcx                                ; 0CC5 _ 48: 89. CE
        mov     rdi, rax                                ; 0CC8 _ 48: 89. C7
        call    nasm_panic_from_macro                   ; 0CCB _ E8, 00000000(PLT r)
?_104:  cmp     dword [rbp-34H], 5                      ; 0CD0 _ 83. 7D, CC, 05
        jne     ?_063                                   ; 0CD4 _ 0F 85, FFFFFB26
        jmp     ?_112                                   ; 0CDA _ E9, 000000B7

?_105:  cmp     byte [rbp-3FH], 39                      ; 0CDF _ 80. 7D, C1, 27
        jz      ?_106                                   ; 0CE3 _ 74, 0A
        cmp     byte [rbp-3FH], 34                      ; 0CE5 _ 80. 7D, C1, 22
        jne     ?_110                                   ; 0CE9 _ 0F 85, 0000008C
?_106:  add     qword [rbp-20H], 1                      ; 0CEF _ 48: 83. 45, E0, 01
        jmp     ?_108                                   ; 0CF4 _ EB, 31

?_107:  movzx   eax, byte [rbp-40H]                     ; 0CF6 _ 0F B6. 45, C0
        mov     byte [rbp-3DH], al                      ; 0CFA _ 88. 45, C3
        movzx   eax, byte [rbp-3DH]                     ; 0CFD _ 0F B6. 45, C3
        mov     edi, eax                                ; 0D01 _ 89. C7
        call    ctlbit                                  ; 0D03 _ E8, FFFFF9E6
        or      dword [rbp-38H], eax                    ; 0D08 _ 09. 45, C8
        mov     eax, dword [rbp-38H]                    ; 0D0B _ 8B. 45, C8
        and     eax, dword [rbp-54H]                    ; 0D0E _ 23. 45, AC
        test    eax, eax                                ; 0D11 _ 85. C0
        jnz     ?_108                                   ; 0D13 _ 75, 12
        mov     rax, qword [rbp-18H]                    ; 0D15 _ 48: 8B. 45, E8
        lea     rdx, [rax+1H]                           ; 0D19 _ 48: 8D. 50, 01
        mov     qword [rbp-18H], rdx                    ; 0D1D _ 48: 89. 55, E8
        movzx   edx, byte [rbp-3DH]                     ; 0D21 _ 0F B6. 55, C3
        mov     byte [rax], dl                          ; 0D25 _ 88. 10
?_108:  mov     rax, qword [rbp-20H]                    ; 0D27 _ 48: 8B. 45, E0
        lea     rdx, [rax+1H]                           ; 0D2B _ 48: 8D. 50, 01
        mov     qword [rbp-20H], rdx                    ; 0D2F _ 48: 89. 55, E0
        movzx   eax, byte [rax]                         ; 0D33 _ 0F B6. 00
        mov     byte [rbp-40H], al                      ; 0D36 _ 88. 45, C0
        cmp     byte [rbp-40H], 0                       ; 0D39 _ 80. 7D, C0, 00
        jz      ?_111                                   ; 0D3D _ 74, 56
        movzx   eax, byte [rbp-40H]                     ; 0D3F _ 0F B6. 45, C0
        cmp     al, byte [rbp-3FH]                      ; 0D43 _ 3A. 45, C1
        jnz     ?_107                                   ; 0D46 _ 75, AE
        jmp     ?_111                                   ; 0D48 _ EB, 4B

?_109:  movzx   eax, byte [rbp-40H]                     ; 0D4A _ 0F B6. 45, C0
        mov     byte [rbp-3EH], al                      ; 0D4E _ 88. 45, C2
        movzx   eax, byte [rbp-3EH]                     ; 0D51 _ 0F B6. 45, C2
        mov     edi, eax                                ; 0D55 _ 89. C7
        call    ctlbit                                  ; 0D57 _ E8, FFFFF992
        or      dword [rbp-38H], eax                    ; 0D5C _ 09. 45, C8
        mov     eax, dword [rbp-38H]                    ; 0D5F _ 8B. 45, C8
        and     eax, dword [rbp-54H]                    ; 0D62 _ 23. 45, AC
        test    eax, eax                                ; 0D65 _ 85. C0
        jnz     ?_110                                   ; 0D67 _ 75, 12
        mov     rax, qword [rbp-18H]                    ; 0D69 _ 48: 8B. 45, E8
        lea     rdx, [rax+1H]                           ; 0D6D _ 48: 8D. 50, 01
        mov     qword [rbp-18H], rdx                    ; 0D71 _ 48: 89. 55, E8
        movzx   edx, byte [rbp-3EH]                     ; 0D75 _ 0F B6. 55, C2
        mov     byte [rax], dl                          ; 0D79 _ 88. 10
?_110:  mov     rax, qword [rbp-20H]                    ; 0D7B _ 48: 8B. 45, E0
        lea     rdx, [rax+1H]                           ; 0D7F _ 48: 8D. 50, 01
        mov     qword [rbp-20H], rdx                    ; 0D83 _ 48: 89. 55, E0
        movzx   eax, byte [rax]                         ; 0D87 _ 0F B6. 00
        mov     byte [rbp-40H], al                      ; 0D8A _ 88. 45, C0
        cmp     byte [rbp-40H], 0                       ; 0D8D _ 80. 7D, C0, 00
        jnz     ?_109                                   ; 0D91 _ 75, B7
        jmp     ?_112                                   ; 0D93 _ EB, 01

?_111:  nop                                             ; 0D95 _ 90
?_112:  mov     rax, qword [rbp-18H]                    ; 0D96 _ 48: 8B. 45, E8
        mov     byte [rax], 0                           ; 0D9A _ C6. 00, 00
        mov     eax, dword [rbp-38H]                    ; 0D9D _ 8B. 45, C8
        and     eax, dword [rbp-54H]                    ; 0DA0 _ 23. 45, AC
        test    eax, eax                                ; 0DA3 _ 85. C0
        jz      ?_113                                   ; 0DA5 _ 74, 14
        lea     rax, [rel ?_134]                        ; 0DA7 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 0DAE _ 48: 89. C7
        mov     eax, 0                                  ; 0DB1 _ B8, 00000000
        call    nasm_nonfatal                           ; 0DB6 _ E8, 00000000(PLT r)
?_113:  cmp     qword [rbp-50H], 0                      ; 0DBB _ 48: 83. 7D, B0, 00
        jz      ?_114                                   ; 0DC0 _ 74, 0F
        mov     rax, qword [rbp-20H]                    ; 0DC2 _ 48: 8B. 45, E0
        lea     rdx, [rax-1H]                           ; 0DC6 _ 48: 8D. 50, FF
        mov     rax, qword [rbp-50H]                    ; 0DCA _ 48: 8B. 45, B0
        mov     qword [rax], rdx                        ; 0DCE _ 48: 89. 10
?_114:  mov     rax, qword [rbp-18H]                    ; 0DD1 _ 48: 8B. 45, E8
        sub     rax, qword [rbp-48H]                    ; 0DD5 _ 48: 2B. 45, B8
        leave                                           ; 0DD9 _ C9
        ret                                             ; 0DDA _ C3
; nasm_unquote_anystr End of function

nasm_unquote:; Function begin
        push    rbp                                     ; 0DDB _ 55
        mov     rbp, rsp                                ; 0DDC _ 48: 89. E5
        sub     rsp, 16                                 ; 0DDF _ 48: 83. EC, 10
        mov     qword [rbp-8H], rdi                     ; 0DE3 _ 48: 89. 7D, F8
        mov     qword [rbp-10H], rsi                    ; 0DE7 _ 48: 89. 75, F0
        mov     rsi, qword [rbp-10H]                    ; 0DEB _ 48: 8B. 75, F0
        mov     rax, qword [rbp-8H]                     ; 0DEF _ 48: 8B. 45, F8
        mov     ecx, 96                                 ; 0DF3 _ B9, 00000060
        mov     edx, 0                                  ; 0DF8 _ BA, 00000000
        mov     rdi, rax                                ; 0DFD _ 48: 89. C7
        call    nasm_unquote_anystr                     ; 0E00 _ E8, 00000000(PLT r)
        leave                                           ; 0E05 _ C9
        ret                                             ; 0E06 _ C3
; nasm_unquote End of function

nasm_unquote_cstr:; Function begin
        push    rbp                                     ; 0E07 _ 55
        mov     rbp, rsp                                ; 0E08 _ 48: 89. E5
        sub     rsp, 16                                 ; 0E0B _ 48: 83. EC, 10
        mov     qword [rbp-8H], rdi                     ; 0E0F _ 48: 89. 7D, F8
        mov     qword [rbp-10H], rsi                    ; 0E13 _ 48: 89. 75, F0
        mov     rsi, qword [rbp-10H]                    ; 0E17 _ 48: 8B. 75, F0
        mov     rax, qword [rbp-8H]                     ; 0E1B _ 48: 8B. 45, F8
        mov     ecx, 96                                 ; 0E1F _ B9, 00000060
        mov     edx, 4160748671                         ; 0E24 _ BA, F7FFFC7F
        mov     rdi, rax                                ; 0E29 _ 48: 89. C7
        call    nasm_unquote_anystr                     ; 0E2C _ E8, 00000000(PLT r)
        leave                                           ; 0E31 _ C9
        ret                                             ; 0E32 _ C3
; nasm_unquote_cstr End of function

nasm_skip_string:; Function begin
        push    rbp                                     ; 0E33 _ 55
        mov     rbp, rsp                                ; 0E34 _ 48: 89. E5
        sub     rsp, 32                                 ; 0E37 _ 48: 83. EC, 20
        mov     qword [rbp-18H], rdi                    ; 0E3B _ 48: 89. 7D, E8
        mov     rax, qword [rbp-18H]                    ; 0E3F _ 48: 8B. 45, E8
        movzx   eax, byte [rax]                         ; 0E43 _ 0F B6. 00
        mov     byte [rbp-0DH], al                      ; 0E46 _ 88. 45, F3
        mov     rax, qword [rbp-18H]                    ; 0E49 _ 48: 8B. 45, E8
        add     rax, 1                                  ; 0E4D _ 48: 83. C0, 01
        mov     qword [rbp-8H], rax                     ; 0E51 _ 48: 89. 45, F8
        movsx   eax, byte [rbp-0DH]                     ; 0E55 _ 0F BE. 45, F3
        cmp     eax, 96                                 ; 0E59 _ 83. F8, 60
        jz      ?_117                                   ; 0E5C _ 74, 42
        cmp     eax, 96                                 ; 0E5E _ 83. F8, 60
        jg      ?_128                                   ; 0E61 _ 0F 8F, 000000EB
        cmp     eax, 34                                 ; 0E67 _ 83. F8, 22
        jz      ?_115                                   ; 0E6A _ 74, 09
        cmp     eax, 39                                 ; 0E6C _ 83. F8, 27
        jne     ?_128                                   ; 0E6F _ 0F 85, 000000DD
?_115:  nop                                             ; 0E75 _ 90
?_116:  mov     rax, qword [rbp-8H]                     ; 0E76 _ 48: 8B. 45, F8
        lea     rdx, [rax+1H]                           ; 0E7A _ 48: 8D. 50, 01
        mov     qword [rbp-8H], rdx                     ; 0E7E _ 48: 89. 55, F8
        movzx   eax, byte [rax]                         ; 0E82 _ 0F B6. 00
        mov     byte [rbp-0EH], al                      ; 0E85 _ 88. 45, F2
        cmp     byte [rbp-0EH], 0                       ; 0E88 _ 80. 7D, F2, 00
        je      ?_129                                   ; 0E8C _ 0F 84, 000000C7
        movzx   eax, byte [rbp-0EH]                     ; 0E92 _ 0F B6. 45, F2
        cmp     al, byte [rbp-0DH]                      ; 0E96 _ 3A. 45, F3
        jnz     ?_116                                   ; 0E99 _ 75, DB
        jmp     ?_129                                   ; 0E9B _ E9, 000000B9

?_117:  mov     dword [rbp-0CH], 0                      ; 0EA0 _ C7. 45, F4, 00000000
        jmp     ?_127                                   ; 0EA7 _ E9, 0000009A

?_118:  mov     rax, qword [rbp-8H]                     ; 0EAC _ 48: 8B. 45, F8
        lea     rdx, [rax+1H]                           ; 0EB0 _ 48: 8D. 50, 01
        mov     qword [rbp-8H], rdx                     ; 0EB4 _ 48: 89. 55, F8
        movzx   eax, byte [rax]                         ; 0EB8 _ 0F B6. 00
        mov     byte [rbp-0EH], al                      ; 0EBB _ 88. 45, F2
        cmp     dword [rbp-0CH], 0                      ; 0EBE _ 83. 7D, F4, 00
        jz      ?_119                                   ; 0EC2 _ 74, 08
        cmp     dword [rbp-0CH], 1                      ; 0EC4 _ 83. 7D, F4, 01
        jz      ?_123                                   ; 0EC8 _ 74, 2E
        jmp     ?_126                                   ; 0ECA _ EB, 5C

?_119:  movsx   eax, byte [rbp-0EH]                     ; 0ECC _ 0F BE. 45, F2
        cmp     eax, 96                                 ; 0ED0 _ 83. F8, 60
        jz      ?_120                                   ; 0ED3 _ 74, 17
        cmp     eax, 96                                 ; 0ED5 _ 83. F8, 60
        jg      ?_121                                   ; 0ED8 _ 7F, 1B
        test    eax, eax                                ; 0EDA _ 85. C0
        jz      ?_120                                   ; 0EDC _ 74, 0E
        cmp     eax, 92                                 ; 0EDE _ 83. F8, 5C
        jnz     ?_121                                   ; 0EE1 _ 75, 12
        mov     dword [rbp-0CH], 1                      ; 0EE3 _ C7. 45, F4, 00000001
        jmp     ?_122                                   ; 0EEA _ EB, 0A

?_120:  mov     dword [rbp-0CH], 5                      ; 0EEC _ C7. 45, F4, 00000005
        jmp     ?_122                                   ; 0EF3 _ EB, 01

?_121:  nop                                             ; 0EF5 _ 90
?_122:  jmp     ?_127                                   ; 0EF6 _ EB, 4E

?_123:  cmp     byte [rbp-0EH], 94                      ; 0EF8 _ 80. 7D, F2, 5E
        jnz     ?_124                                   ; 0EFC _ 75, 12
        mov     rax, qword [rbp-8H]                     ; 0EFE _ 48: 8B. 45, F8
        lea     rdx, [rax+1H]                           ; 0F02 _ 48: 8D. 50, 01
        mov     qword [rbp-8H], rdx                     ; 0F06 _ 48: 89. 55, F8
        movzx   eax, byte [rax]                         ; 0F0A _ 0F B6. 00
        mov     byte [rbp-0EH], al                      ; 0F0D _ 88. 45, F2
?_124:  cmp     byte [rbp-0EH], 0                       ; 0F10 _ 80. 7D, F2, 00
        jz      ?_125                                   ; 0F14 _ 74, 09
        mov     dword [rbp-0CH], 0                      ; 0F16 _ C7. 45, F4, 00000000
        jmp     ?_127                                   ; 0F1D _ EB, 27

?_125:  mov     dword [rbp-0CH], 5                      ; 0F1F _ C7. 45, F4, 00000005
        jmp     ?_127                                   ; 0F26 _ EB, 1E

?_126:  lea     rcx, [rel ?_132]                        ; 0F28 _ 48: 8D. 0D, 00000000(rel)
        lea     rax, [rel __func__.0]                   ; 0F2F _ 48: 8D. 05, 00000000(rel)
        mov     edx, 560                                ; 0F36 _ BA, 00000230
        mov     rsi, rcx                                ; 0F3B _ 48: 89. CE
        mov     rdi, rax                                ; 0F3E _ 48: 89. C7
        call    nasm_panic_from_macro                   ; 0F41 _ E8, 00000000(PLT r)
?_127:  cmp     dword [rbp-0CH], 5                      ; 0F46 _ 83. 7D, F4, 05
        jne     ?_118                                   ; 0F4A _ 0F 85, FFFFFF5C
        jmp     ?_130                                   ; 0F50 _ EB, 08

?_128:  mov     eax, 0                                  ; 0F52 _ B8, 00000000
        jmp     ?_131                                   ; 0F57 _ EB, 09

?_129:  nop                                             ; 0F59 _ 90
?_130:  mov     rax, qword [rbp-8H]                     ; 0F5A _ 48: 8B. 45, F8
        sub     rax, 1                                  ; 0F5E _ 48: 83. E8, 01
?_131:  leave                                           ; 0F62 _ C9
        ret                                             ; 0F63 _ C3
; nasm_skip_string End of function


SECTION .data   align=1 noexec                          ; section number 2, data


SECTION .bss    align=1 noexec                          ; section number 3, bss


SECTION .rodata align=16 noexec                         ; section number 4, const

?_132:                                                  ; byte
        db 2EH, 2FH, 61H, 73H, 6DH, 2FH, 71H, 75H       ; 0000 _ ./asm/qu
        db 6FH, 74H, 65H, 2EH, 63H, 00H                 ; 0008 _ ote.c.

?_133:                                                  ; byte
        db 28H, 73H, 69H, 7AH, 65H, 5FH, 74H, 29H       ; 000E _ (size_t)
        db 28H, 71H, 2DH, 6EH, 73H, 74H, 72H, 29H       ; 0016 _ (q-nstr)
        db 20H, 3DH, 3DH, 20H, 71H, 6CH, 65H, 6EH       ; 001E _  == qlen
        db 2BH, 32H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0026 _ +2......
        db 00H, 00H                                     ; 002E _ ..

?_134:                                                  ; byte
        db 63H, 6FH, 6EH, 74H, 72H, 6FH, 6CH, 20H       ; 0030 _ control 
        db 63H, 68H, 61H, 72H, 61H, 63H, 74H, 65H       ; 0038 _ characte
        db 72H, 20H, 69H, 6EH, 20H, 73H, 74H, 72H       ; 0040 _ r in str
        db 69H, 6EH, 67H, 20H, 6EH, 6FH, 74H, 20H       ; 0048 _ ing not 
        db 61H, 6CH, 6CH, 6FH, 77H, 65H, 64H, 20H       ; 0050 _ allowed 
        db 68H, 65H, 72H, 65H, 00H, 00H, 00H, 00H       ; 0058 _ here....

__func__.2:                                             ; byte
        db 6EH, 61H, 73H, 6DH, 5FH, 71H, 75H, 6FH       ; 0060 _ nasm_quo
        db 74H, 65H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0068 _ te......

__func__.1:                                             ; byte
        db 6EH, 61H, 73H, 6DH, 5FH, 75H, 6EH, 71H       ; 0070 _ nasm_unq
        db 75H, 6FH, 74H, 65H, 5FH, 61H, 6EH, 79H       ; 0078 _ uote_any
        db 73H, 74H, 72H, 00H, 00H, 00H, 00H, 00H       ; 0080 _ str.....
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0088 _ ........

__func__.0:                                             ; byte
        db 6EH, 61H, 73H, 6DH, 5FH, 73H, 6BH, 69H       ; 0090 _ nasm_ski
        db 70H, 5FH, 73H, 74H, 72H, 69H, 6EH, 67H       ; 0098 _ p_string
        db 00H                                          ; 00A0 _ .


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
        dd numvalue_chk-$-20H                           ; 0020 _ 00000000 (rel)
        dd 00000042H, 100E4100H                         ; 0024 _ 66 269369600 
        dd 0D430286H, 070C7D06H                         ; 002C _ 222495366 118258950 
        dd 00000008H, 0000001CH                         ; 0034 _ 8 28 
        dd 0000003CH                                    ; 003C _ 60 
        dd numvalue_chk-$+2H                            ; 0040 _ 00000000 (rel)
        dd 00000540H, 100E4100H                         ; 0044 _ 1344 269369600 
        dd 0D430286H, 053B0306H                         ; 004C _ 222495366 87753478 
        dd 0008070CH, 0000001CH                         ; 0054 _ 526092 28 
        dd 0000005CH                                    ; 005C _ 92 
        dd numvalue_chk-$+522H                          ; 0060 _ 00000000 (rel)
        dd 0000016CH, 100E4100H                         ; 0064 _ 364 269369600 
        dd 0D430286H, 01670306H                         ; 006C _ 222495366 23528198 
        dd 0008070CH, 0000001CH                         ; 0074 _ 526092 28 
        dd 0000007CH                                    ; 007C _ 124 
        dd numvalue_chk-$+66EH                          ; 0080 _ 00000000 (rel)
        dd 0000002DH, 100E4100H                         ; 0084 _ 45 269369600 
        dd 0D430286H, 070C6806H                         ; 008C _ 222495366 118253574 
        dd 00000008H, 0000001CH                         ; 0094 _ 8 28 
        dd 0000009CH                                    ; 009C _ 156 
        dd numvalue_chk-$+67BH                          ; 00A0 _ 00000000 (rel)
        dd 00000072H, 100E4100H                         ; 00A4 _ 114 269369600 
        dd 0D430286H, 0C6D0206H                         ; 00AC _ 222495366 208470534 
        dd 00000807H, 0000001CH                         ; 00B4 _ 2055 28 
        dd 000000BCH                                    ; 00BC _ 188 
        dd numvalue_chk-$+6CDH                          ; 00C0 _ 00000000 (rel)
        dd 0000064EH, 100E4100H                         ; 00C4 _ 1614 269369600 
        dd 0D430286H, 06490306H                         ; 00CC _ 222495366 105448198 
        dd 0008070CH, 0000001CH                         ; 00D4 _ 526092 28 
        dd 000000DCH                                    ; 00DC _ 220 
        dd numvalue_chk-$+0CFBH                         ; 00E0 _ 00000000 (rel)
        dd 0000002CH, 100E4100H                         ; 00E4 _ 44 269369600 
        dd 0D430286H, 070C6706H                         ; 00EC _ 222495366 118253318 
        dd 00000008H, 0000001CH                         ; 00F4 _ 8 28 
        dd 000000FCH                                    ; 00FC _ 252 
        dd numvalue_chk-$+0D07H                         ; 0100 _ 00000000 (rel)
        dd 0000002CH, 100E4100H                         ; 0104 _ 44 269369600 
        dd 0D430286H, 070C6706H                         ; 010C _ 222495366 118253318 
        dd 00000008H, 0000001CH                         ; 0114 _ 8 28 
        dd 0000011CH                                    ; 011C _ 284 
        dd numvalue_chk-$+0D13H                         ; 0120 _ 00000000 (rel)
        dd 00000131H, 100E4100H                         ; 0124 _ 305 269369600 
        dd 0D430286H, 012C0306H                         ; 012C _ 222495366 19661574 
        dd 0008070CH                                    ; 0134 _ 526092 


