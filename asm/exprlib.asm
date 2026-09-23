; Disassembly of file: /tmp/tmp.h9zwDLG57M.o
; Wed Sep 23 14:43:22 2026
; Type: ELF64
; Syntax: NASM
; Instruction set: 80386, x64

default rel

global is_simple: function
global is_really_simple: function
global expr_class: function
global is_reloc: function
global is_unknown: function
global is_just_unknown: function
global reloc_value: function
global reloc_seg: function
global reloc_wrt: function
global is_self_relative: function

extern location                                         ; dword


SECTION .text   align=1 exec                            ; section number 1, code

is_simple:; Function begin
        push    rbp                                     ; 0000 _ 55
        mov     rbp, rsp                                ; 0001 _ 48: 89. E5
        mov     qword [rbp-8H], rdi                     ; 0004 _ 48: 89. 7D, F8
        jmp     ?_002                                   ; 0008 _ EB, 05

?_001:  add     qword [rbp-8H], 16                      ; 000A _ 48: 83. 45, F8, 10
?_002:  mov     rax, qword [rbp-8H]                     ; 000F _ 48: 8B. 45, F8
        mov     eax, dword [rax]                        ; 0013 _ 8B. 00
        test    eax, eax                                ; 0015 _ 85. C0
        jz      ?_003                                   ; 0017 _ 74, 0D
        mov     rax, qword [rbp-8H]                     ; 0019 _ 48: 8B. 45, F8
        mov     rax, qword [rax+8H]                     ; 001D _ 48: 8B. 40, 08
        test    rax, rax                                ; 0021 _ 48: 85. C0
        jz      ?_001                                   ; 0024 _ 74, E4
?_003:  mov     rax, qword [rbp-8H]                     ; 0026 _ 48: 8B. 45, F8
        mov     eax, dword [rax]                        ; 002A _ 8B. 00
        test    eax, eax                                ; 002C _ 85. C0
        jnz     ?_004                                   ; 002E _ 75, 07
        mov     eax, 1                                  ; 0030 _ B8, 00000001
        jmp     ?_008                                   ; 0035 _ EB, 53

?_004:  mov     rax, qword [rbp-8H]                     ; 0037 _ 48: 8B. 45, F8
        mov     eax, dword [rax]                        ; 003B _ 8B. 00
        cmp     eax, 346                                ; 003D _ 3D, 0000015A
        jz      ?_005                                   ; 0042 _ 74, 07
        mov     eax, 0                                  ; 0044 _ B8, 00000000
        jmp     ?_008                                   ; 0049 _ EB, 3F

?_005:  add     qword [rbp-8H], 16                      ; 004B _ 48: 83. 45, F8, 10
        mov     rax, qword [rbp-8H]                     ; 0050 _ 48: 8B. 45, F8
        mov     eax, dword [rax]                        ; 0054 _ 8B. 00
        test    eax, eax                                ; 0056 _ 85. C0
        jz      ?_006                                   ; 0058 _ 74, 0D
        mov     rax, qword [rbp-8H]                     ; 005A _ 48: 8B. 45, F8
        mov     rax, qword [rax+8H]                     ; 005E _ 48: 8B. 40, 08
        test    rax, rax                                ; 0062 _ 48: 85. C0
        jz      ?_005                                   ; 0065 _ 74, E4
?_006:  mov     rax, qword [rbp-8H]                     ; 0067 _ 48: 8B. 45, F8
        mov     eax, dword [rax]                        ; 006B _ 8B. 00
        test    eax, eax                                ; 006D _ 85. C0
        jz      ?_007                                   ; 006F _ 74, 14
        mov     rax, qword [rbp-8H]                     ; 0071 _ 48: 8B. 45, F8
        mov     eax, dword [rax]                        ; 0075 _ 8B. 00
        cmp     eax, 1073742172                         ; 0077 _ 3D, 4000015C
        jg      ?_007                                   ; 007C _ 7F, 07
        mov     eax, 0                                  ; 007E _ B8, 00000000
        jmp     ?_008                                   ; 0083 _ EB, 05

?_007:  mov     eax, 1                                  ; 0085 _ B8, 00000001
?_008:  pop     rbp                                     ; 008A _ 5D
        ret                                             ; 008B _ C3
; is_simple End of function

is_really_simple:; Function begin
        push    rbp                                     ; 008C _ 55
        mov     rbp, rsp                                ; 008D _ 48: 89. E5
        mov     qword [rbp-8H], rdi                     ; 0090 _ 48: 89. 7D, F8
        jmp     ?_010                                   ; 0094 _ EB, 05

?_009:  add     qword [rbp-8H], 16                      ; 0096 _ 48: 83. 45, F8, 10
?_010:  mov     rax, qword [rbp-8H]                     ; 009B _ 48: 8B. 45, F8
        mov     eax, dword [rax]                        ; 009F _ 8B. 00
        test    eax, eax                                ; 00A1 _ 85. C0
        jz      ?_011                                   ; 00A3 _ 74, 0D
        mov     rax, qword [rbp-8H]                     ; 00A5 _ 48: 8B. 45, F8
        mov     rax, qword [rax+8H]                     ; 00A9 _ 48: 8B. 40, 08
        test    rax, rax                                ; 00AD _ 48: 85. C0
        jz      ?_009                                   ; 00B0 _ 74, E4
?_011:  mov     rax, qword [rbp-8H]                     ; 00B2 _ 48: 8B. 45, F8
        mov     eax, dword [rax]                        ; 00B6 _ 8B. 00
        test    eax, eax                                ; 00B8 _ 85. C0
        jnz     ?_012                                   ; 00BA _ 75, 07
        mov     eax, 1                                  ; 00BC _ B8, 00000001
        jmp     ?_016                                   ; 00C1 _ EB, 46

?_012:  mov     rax, qword [rbp-8H]                     ; 00C3 _ 48: 8B. 45, F8
        mov     eax, dword [rax]                        ; 00C7 _ 8B. 00
        cmp     eax, 346                                ; 00C9 _ 3D, 0000015A
        jz      ?_013                                   ; 00CE _ 74, 07
        mov     eax, 0                                  ; 00D0 _ B8, 00000000
        jmp     ?_016                                   ; 00D5 _ EB, 32

?_013:  add     qword [rbp-8H], 16                      ; 00D7 _ 48: 83. 45, F8, 10
        mov     rax, qword [rbp-8H]                     ; 00DC _ 48: 8B. 45, F8
        mov     eax, dword [rax]                        ; 00E0 _ 8B. 00
        test    eax, eax                                ; 00E2 _ 85. C0
        jz      ?_014                                   ; 00E4 _ 74, 0D
        mov     rax, qword [rbp-8H]                     ; 00E6 _ 48: 8B. 45, F8
        mov     rax, qword [rax+8H]                     ; 00EA _ 48: 8B. 40, 08
        test    rax, rax                                ; 00EE _ 48: 85. C0
        jz      ?_013                                   ; 00F1 _ 74, E4
?_014:  mov     rax, qword [rbp-8H]                     ; 00F3 _ 48: 8B. 45, F8
        mov     eax, dword [rax]                        ; 00F7 _ 8B. 00
        test    eax, eax                                ; 00F9 _ 85. C0
        jz      ?_015                                   ; 00FB _ 74, 07
        mov     eax, 0                                  ; 00FD _ B8, 00000000
        jmp     ?_016                                   ; 0102 _ EB, 05

?_015:  mov     eax, 1                                  ; 0104 _ B8, 00000001
?_016:  pop     rbp                                     ; 0109 _ 5D
        ret                                             ; 010A _ C3
; is_really_simple End of function

expr_class:; Function begin
        push    rbp                                     ; 010B _ 55
        mov     rbp, rsp                                ; 010C _ 48: 89. E5
        mov     qword [rbp-18H], rdi                    ; 010F _ 48: 89. 7D, E8
        mov     dword [rbp-4H], 0                       ; 0113 _ C7. 45, FC, 00000000
        jmp     ?_033                                   ; 011A _ E9, 00000135

?_017:  mov     rax, qword [rbp-18H]                    ; 011F _ 48: 8B. 45, E8
        mov     rax, qword [rax+8H]                     ; 0123 _ 48: 8B. 40, 08
        test    rax, rax                                ; 0127 _ 48: 85. C0
        je      ?_032                                   ; 012A _ 0F 84, 0000011F
        mov     rax, qword [rbp-18H]                    ; 0130 _ 48: 8B. 45, E8
        mov     eax, dword [rax]                        ; 0134 _ 8B. 00
        cmp     eax, 344                                ; 0136 _ 3D, 00000158
        jg      ?_020                                   ; 013B _ 7F, 2D
        mov     eax, dword [rbp-4H]                     ; 013D _ 8B. 45, FC
        and     eax, 40H                                ; 0140 _ 83. E0, 40
        test    eax, eax                                ; 0143 _ 85. C0
        jnz     ?_018                                   ; 0145 _ 75, 0E
        mov     rax, qword [rbp-18H]                    ; 0147 _ 48: 8B. 45, E8
        mov     rax, qword [rax+8H]                     ; 014B _ 48: 8B. 40, 08
        cmp     rax, 1                                  ; 014F _ 48: 83. F8, 01
        jz      ?_019                                   ; 0153 _ 74, 0C
?_018:  or      dword [rbp-4H], 80H                     ; 0155 _ 81. 4D, FC, 00000080
        jmp     ?_032                                   ; 015C _ E9, 000000EE

?_019:  or      dword [rbp-4H], 40H                     ; 0161 _ 83. 4D, FC, 40
        jmp     ?_032                                   ; 0165 _ E9, 000000E5

?_020:  mov     rax, qword [rbp-18H]                    ; 016A _ 48: 8B. 45, E8
        mov     eax, dword [rax]                        ; 016E _ 8B. 00
        cmp     eax, 345                                ; 0170 _ 3D, 00000159
        jnz     ?_021                                   ; 0175 _ 75, 09
        or      dword [rbp-4H], 20H                     ; 0177 _ 83. 4D, FC, 20
        jmp     ?_032                                   ; 017B _ E9, 000000CF

?_021:  mov     rax, qword [rbp-18H]                    ; 0180 _ 48: 8B. 45, E8
        mov     eax, dword [rax]                        ; 0184 _ 8B. 00
        cmp     eax, 346                                ; 0186 _ 3D, 0000015A
        jnz     ?_022                                   ; 018B _ 75, 09
        or      dword [rbp-4H], 01H                     ; 018D _ 83. 4D, FC, 01
        jmp     ?_032                                   ; 0191 _ E9, 000000B9

?_022:  mov     rax, qword [rbp-18H]                    ; 0196 _ 48: 8B. 45, E8
        mov     eax, dword [rax]                        ; 019A _ 8B. 00
        cmp     eax, 347                                ; 019C _ 3D, 0000015B
        jnz     ?_023                                   ; 01A1 _ 75, 09
        or      dword [rbp-4H], 10H                     ; 01A3 _ 83. 4D, FC, 10
        jmp     ?_032                                   ; 01A7 _ E9, 000000A3

?_023:  mov     rax, qword [rbp-18H]                    ; 01AC _ 48: 8B. 45, E8
        mov     eax, dword [rax]                        ; 01B0 _ 8B. 00
        cmp     eax, 348                                ; 01B2 _ 3D, 0000015C
        jg      ?_024                                   ; 01B7 _ 7F, 0C
        or      dword [rbp-4H], 100H                    ; 01B9 _ 81. 4D, FC, 00000100
        jmp     ?_032                                   ; 01C0 _ E9, 0000008A

?_024:  mov     rax, qword [rbp-18H]                    ; 01C5 _ 48: 8B. 45, E8
        mov     eax, dword [rax]                        ; 01C9 _ 8B. 00
        cmp     eax, 1073742172                         ; 01CB _ 3D, 4000015C
        jle     ?_026                                   ; 01D0 _ 7E, 17
        mov     eax, dword [rbp-4H]                     ; 01D2 _ 8B. 45, FC
        and     eax, 0AH                                ; 01D5 _ 83. E0, 0A
        test    eax, eax                                ; 01D8 _ 85. C0
        jz      ?_025                                   ; 01DA _ 74, 07
        or      dword [rbp-4H], 100H                    ; 01DC _ 81. 4D, FC, 00000100
?_025:  or      dword [rbp-4H], 02H                     ; 01E3 _ 83. 4D, FC, 02
        jmp     ?_032                                   ; 01E7 _ EB, 66

?_026:  mov     rax, qword [rbp-18H]                    ; 01E9 _ 48: 8B. 45, E8
        mov     rax, qword [rax+8H]                     ; 01ED _ 48: 8B. 40, 08
        cmp     rax, 1                                  ; 01F1 _ 48: 83. F8, 01
        jnz     ?_028                                   ; 01F5 _ 75, 17
        mov     eax, dword [rbp-4H]                     ; 01F7 _ 8B. 45, FC
        and     eax, 0AH                                ; 01FA _ 83. E0, 0A
        test    eax, eax                                ; 01FD _ 85. C0
        jz      ?_027                                   ; 01FF _ 74, 07
        or      dword [rbp-4H], 100H                    ; 0201 _ 81. 4D, FC, 00000100
?_027:  or      dword [rbp-4H], 08H                     ; 0208 _ 83. 4D, FC, 08
        jmp     ?_032                                   ; 020C _ EB, 41

?_028:  mov     rax, qword [rbp-18H]                    ; 020E _ 48: 8B. 45, E8
        mov     rax, qword [rax+8H]                     ; 0212 _ 48: 8B. 40, 08
        cmp     rax, -1                                 ; 0216 _ 48: 83. F8, FF
        jnz     ?_031                                   ; 021A _ 75, 2C
        mov     rax, qword [rbp-18H]                    ; 021C _ 48: 8B. 45, E8
        mov     edx, dword [rax]                        ; 0220 _ 8B. 10
        mov     eax, dword [rel location+8H]            ; 0222 _ 8B. 05, 00000000(rel)
        add     eax, 349                                ; 0228 _ 05, 0000015D
        cmp     edx, eax                                ; 022D _ 39. C2
        jnz     ?_029                                   ; 022F _ 75, 0A
        mov     eax, dword [rbp-4H]                     ; 0231 _ 8B. 45, FC
        and     eax, 04H                                ; 0234 _ 83. E0, 04
        test    eax, eax                                ; 0237 _ 85. C0
        jz      ?_030                                   ; 0239 _ 74, 07
?_029:  or      dword [rbp-4H], 100H                    ; 023B _ 81. 4D, FC, 00000100
?_030:  or      dword [rbp-4H], 04H                     ; 0242 _ 83. 4D, FC, 04
        jmp     ?_032                                   ; 0246 _ EB, 07

?_031:  or      dword [rbp-4H], 100H                    ; 0248 _ 81. 4D, FC, 00000100
?_032:  add     qword [rbp-18H], 16                     ; 024F _ 48: 83. 45, E8, 10
?_033:  mov     rax, qword [rbp-18H]                    ; 0254 _ 48: 8B. 45, E8
        mov     eax, dword [rax]                        ; 0258 _ 8B. 00
        test    eax, eax                                ; 025A _ 85. C0
        jne     ?_017                                   ; 025C _ 0F 85, FFFFFEBD
        mov     eax, dword [rbp-4H]                     ; 0262 _ 8B. 45, FC
        pop     rbp                                     ; 0265 _ 5D
        ret                                             ; 0266 _ C3
; expr_class End of function

is_reloc:; Function begin
        push    rbp                                     ; 0267 _ 55
        mov     rbp, rsp                                ; 0268 _ 48: 89. E5
        sub     rsp, 8                                  ; 026B _ 48: 83. EC, 08
        mov     qword [rbp-8H], rdi                     ; 026F _ 48: 89. 7D, F8
        mov     rax, qword [rbp-8H]                     ; 0273 _ 48: 8B. 45, F8
        mov     rdi, rax                                ; 0277 _ 48: 89. C7
        call    expr_class                              ; 027A _ E8, 00000000(PLT r)
        cmp     eax, 31                                 ; 027F _ 83. F8, 1F
        setbe   al                                      ; 0282 _ 0F 96. C0
        leave                                           ; 0285 _ C9
        ret                                             ; 0286 _ C3
; is_reloc End of function

is_unknown:; Function begin
        push    rbp                                     ; 0287 _ 55
        mov     rbp, rsp                                ; 0288 _ 48: 89. E5
        sub     rsp, 8                                  ; 028B _ 48: 83. EC, 08
        mov     qword [rbp-8H], rdi                     ; 028F _ 48: 89. 7D, F8
        mov     rax, qword [rbp-8H]                     ; 0293 _ 48: 8B. 45, F8
        mov     rdi, rax                                ; 0297 _ 48: 89. C7
        call    expr_class                              ; 029A _ E8, 00000000(PLT r)
        and     eax, 20H                                ; 029F _ 83. E0, 20
        shr     eax, 5                                  ; 02A2 _ C1. E8, 05
        and     eax, 01H                                ; 02A5 _ 83. E0, 01
        leave                                           ; 02A8 _ C9
        ret                                             ; 02A9 _ C3
; is_unknown End of function

is_just_unknown:; Function begin
        push    rbp                                     ; 02AA _ 55
        mov     rbp, rsp                                ; 02AB _ 48: 89. E5
        sub     rsp, 8                                  ; 02AE _ 48: 83. EC, 08
        mov     qword [rbp-8H], rdi                     ; 02B2 _ 48: 89. 7D, F8
        mov     rax, qword [rbp-8H]                     ; 02B6 _ 48: 8B. 45, F8
        mov     rdi, rax                                ; 02BA _ 48: 89. C7
        call    expr_class                              ; 02BD _ E8, 00000000(PLT r)
        cmp     eax, 32                                 ; 02C2 _ 83. F8, 20
        sete    al                                      ; 02C5 _ 0F 94. C0
        leave                                           ; 02C8 _ C9
        ret                                             ; 02C9 _ C3
; is_just_unknown End of function

reloc_value:; Function begin
        push    rbp                                     ; 02CA _ 55
        mov     rbp, rsp                                ; 02CB _ 48: 89. E5
        mov     qword [rbp-8H], rdi                     ; 02CE _ 48: 89. 7D, F8
        jmp     ?_035                                   ; 02D2 _ EB, 05

?_034:  add     qword [rbp-8H], 16                      ; 02D4 _ 48: 83. 45, F8, 10
?_035:  mov     rax, qword [rbp-8H]                     ; 02D9 _ 48: 8B. 45, F8
        mov     eax, dword [rax]                        ; 02DD _ 8B. 00
        test    eax, eax                                ; 02DF _ 85. C0
        jz      ?_036                                   ; 02E1 _ 74, 0D
        mov     rax, qword [rbp-8H]                     ; 02E3 _ 48: 8B. 45, F8
        mov     rax, qword [rax+8H]                     ; 02E7 _ 48: 8B. 40, 08
        test    rax, rax                                ; 02EB _ 48: 85. C0
        jz      ?_034                                   ; 02EE _ 74, E4
?_036:  mov     rax, qword [rbp-8H]                     ; 02F0 _ 48: 8B. 45, F8
        mov     eax, dword [rax]                        ; 02F4 _ 8B. 00
        test    eax, eax                                ; 02F6 _ 85. C0
        jnz     ?_037                                   ; 02F8 _ 75, 07
        mov     eax, 0                                  ; 02FA _ B8, 00000000
        jmp     ?_039                                   ; 02FF _ EB, 1C

?_037:  mov     rax, qword [rbp-8H]                     ; 0301 _ 48: 8B. 45, F8
        mov     eax, dword [rax]                        ; 0305 _ 8B. 00
        cmp     eax, 346                                ; 0307 _ 3D, 0000015A
        jnz     ?_038                                   ; 030C _ 75, 0A
        mov     rax, qword [rbp-8H]                     ; 030E _ 48: 8B. 45, F8
        mov     rax, qword [rax+8H]                     ; 0312 _ 48: 8B. 40, 08
        jmp     ?_039                                   ; 0316 _ EB, 05

?_038:  mov     eax, 0                                  ; 0318 _ B8, 00000000
?_039:  pop     rbp                                     ; 031D _ 5D
        ret                                             ; 031E _ C3
; reloc_value End of function

reloc_seg:; Function begin
        push    rbp                                     ; 031F _ 55
        mov     rbp, rsp                                ; 0320 _ 48: 89. E5
        mov     qword [rbp-8H], rdi                     ; 0323 _ 48: 89. 7D, F8
        jmp     ?_042                                   ; 0327 _ EB, 2D

?_040:  mov     rax, qword [rbp-8H]                     ; 0329 _ 48: 8B. 45, F8
        mov     eax, dword [rax]                        ; 032D _ 8B. 00
        cmp     eax, 348                                ; 032F _ 3D, 0000015C
        jle     ?_041                                   ; 0334 _ 7E, 1B
        mov     rax, qword [rbp-8H]                     ; 0336 _ 48: 8B. 45, F8
        mov     rax, qword [rax+8H]                     ; 033A _ 48: 8B. 40, 08
        cmp     rax, 1                                  ; 033E _ 48: 83. F8, 01
        jnz     ?_041                                   ; 0342 _ 75, 0D
        mov     rax, qword [rbp-8H]                     ; 0344 _ 48: 8B. 45, F8
        mov     eax, dword [rax]                        ; 0348 _ 8B. 00
        sub     eax, 349                                ; 034A _ 2D, 0000015D
        jmp     ?_043                                   ; 034F _ EB, 14

?_041:  add     qword [rbp-8H], 16                      ; 0351 _ 48: 83. 45, F8, 10
?_042:  mov     rax, qword [rbp-8H]                     ; 0356 _ 48: 8B. 45, F8
        mov     eax, dword [rax]                        ; 035A _ 8B. 00
        test    eax, eax                                ; 035C _ 85. C0
        jnz     ?_040                                   ; 035E _ 75, C9
        mov     eax, 4294967295                         ; 0360 _ B8, FFFFFFFF
?_043:  pop     rbp                                     ; 0365 _ 5D
        ret                                             ; 0366 _ C3
; reloc_seg End of function

reloc_wrt:; Function begin
        push    rbp                                     ; 0367 _ 55
        mov     rbp, rsp                                ; 0368 _ 48: 89. E5
        mov     qword [rbp-8H], rdi                     ; 036B _ 48: 89. 7D, F8
        jmp     ?_045                                   ; 036F _ EB, 05

?_044:  add     qword [rbp-8H], 16                      ; 0371 _ 48: 83. 45, F8, 10
?_045:  mov     rax, qword [rbp-8H]                     ; 0376 _ 48: 8B. 45, F8
        mov     eax, dword [rax]                        ; 037A _ 8B. 00
        test    eax, eax                                ; 037C _ 85. C0
        jz      ?_046                                   ; 037E _ 74, 0D
        mov     rax, qword [rbp-8H]                     ; 0380 _ 48: 8B. 45, F8
        mov     eax, dword [rax]                        ; 0384 _ 8B. 00
        cmp     eax, 346                                ; 0386 _ 3D, 0000015A
        jle     ?_044                                   ; 038B _ 7E, E4
?_046:  mov     rax, qword [rbp-8H]                     ; 038D _ 48: 8B. 45, F8
        mov     eax, dword [rax]                        ; 0391 _ 8B. 00
        cmp     eax, 347                                ; 0393 _ 3D, 0000015B
        jnz     ?_047                                   ; 0398 _ 75, 0A
        mov     rax, qword [rbp-8H]                     ; 039A _ 48: 8B. 45, F8
        mov     rax, qword [rax+8H]                     ; 039E _ 48: 8B. 40, 08
        jmp     ?_048                                   ; 03A2 _ EB, 05

?_047:  mov     eax, 4294967295                         ; 03A4 _ B8, FFFFFFFF
?_048:  pop     rbp                                     ; 03A9 _ 5D
        ret                                             ; 03AA _ C3
; reloc_wrt End of function

is_self_relative:; Function begin
        push    rbp                                     ; 03AB _ 55
        mov     rbp, rsp                                ; 03AC _ 48: 89. E5
        sub     rsp, 8                                  ; 03AF _ 48: 83. EC, 08
        mov     qword [rbp-8H], rdi                     ; 03B3 _ 48: 89. 7D, F8
        mov     rax, qword [rbp-8H]                     ; 03B7 _ 48: 8B. 45, F8
        mov     rdi, rax                                ; 03BB _ 48: 89. C7
        call    expr_class                              ; 03BE _ E8, 00000000(PLT r)
        and     eax, 04H                                ; 03C3 _ 83. E0, 04
        shr     eax, 2                                  ; 03C6 _ C1. E8, 02
        and     eax, 01H                                ; 03C9 _ 83. E0, 01
        leave                                           ; 03CC _ C9
        ret                                             ; 03CD _ C3
; is_self_relative End of function


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
        dd is_simple-$-20H                              ; 0020 _ 00000000 (rel)
        dd 0000008CH, 100E4100H                         ; 0024 _ 140 269369600 
        dd 0D430286H, 0C870206H                         ; 002C _ 222495366 210174470 
        dd 00000807H, 0000001CH                         ; 0034 _ 2055 28 
        dd 0000003CH                                    ; 003C _ 60 
        dd is_simple-$+4CH                              ; 0040 _ 00000000 (rel)
        dd 0000007FH, 100E4100H                         ; 0044 _ 127 269369600 
        dd 0D430286H, 0C7A0206H                         ; 004C _ 222495366 209322502 
        dd 00000807H, 0000001CH                         ; 0054 _ 2055 28 
        dd 0000005CH                                    ; 005C _ 92 
        dd is_simple-$+0ABH                             ; 0060 _ 00000000 (rel)
        dd 0000015CH, 100E4100H                         ; 0064 _ 348 269369600 
        dd 0D430286H, 01570306H                         ; 006C _ 222495366 22479622 
        dd 0008070CH, 0000001CH                         ; 0074 _ 526092 28 
        dd 0000007CH                                    ; 007C _ 124 
        dd is_simple-$+1E7H                             ; 0080 _ 00000000 (rel)
        dd 00000020H, 100E4100H                         ; 0084 _ 32 269369600 
        dd 0D430286H, 070C5B06H                         ; 008C _ 222495366 118250246 
        dd 00000008H, 0000001CH                         ; 0094 _ 8 28 
        dd 0000009CH                                    ; 009C _ 156 
        dd is_simple-$+1E7H                             ; 00A0 _ 00000000 (rel)
        dd 00000023H, 100E4100H                         ; 00A4 _ 35 269369600 
        dd 0D430286H, 070C5E06H                         ; 00AC _ 222495366 118251014 
        dd 00000008H, 0000001CH                         ; 00B4 _ 8 28 
        dd 000000BCH                                    ; 00BC _ 188 
        dd is_simple-$+1EAH                             ; 00C0 _ 00000000 (rel)
        dd 00000020H, 100E4100H                         ; 00C4 _ 32 269369600 
        dd 0D430286H, 070C5B06H                         ; 00CC _ 222495366 118250246 
        dd 00000008H, 0000001CH                         ; 00D4 _ 8 28 
        dd 000000DCH                                    ; 00DC _ 220 
        dd is_simple-$+1EAH                             ; 00E0 _ 00000000 (rel)
        dd 00000055H, 100E4100H                         ; 00E4 _ 85 269369600 
        dd 0D430286H, 0C500206H                         ; 00EC _ 222495366 206569990 
        dd 00000807H, 0000001CH                         ; 00F4 _ 2055 28 
        dd 000000FCH                                    ; 00FC _ 252 
        dd is_simple-$+21FH                             ; 0100 _ 00000000 (rel)
        dd 00000048H, 100E4100H                         ; 0104 _ 72 269369600 
        dd 0D430286H, 0C430206H                         ; 010C _ 222495366 205718022 
        dd 00000807H, 0000001CH                         ; 0114 _ 2055 28 
        dd 0000011CH                                    ; 011C _ 284 
        dd is_simple-$+247H                             ; 0120 _ 00000000 (rel)
        dd 00000044H, 100E4100H                         ; 0124 _ 68 269369600 
        dd 0D430286H, 070C7F06H                         ; 012C _ 222495366 118259462 
        dd 00000008H, 0000001CH                         ; 0134 _ 8 28 
        dd 0000013CH                                    ; 013C _ 316 
        dd is_simple-$+26BH                             ; 0140 _ 00000000 (rel)
        dd 00000023H, 100E4100H                         ; 0144 _ 35 269369600 
        dd 0D430286H, 070C5E06H                         ; 014C _ 222495366 118251014 
        dd 00000008H                                    ; 0154 _ 8 


