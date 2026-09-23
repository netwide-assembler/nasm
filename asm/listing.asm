; Disassembly of file: /tmp/tmp.ZuibRnOjoK.o
; Wed Sep 23 14:43:21 2026
; Type: ELF64
; Syntax: NASM
; Instruction set: SSE, x64

default rel

global list_update_options: function
global list_pragma: function
global list_options
global active_list_options
global cmdline_list_options
global user_nolist
global lfmt

extern strlist_vprintf                                  ; near
extern strlist_alloc                                    ; near
extern memcpy                                           ; near
extern strlcpy                                          ; near
extern nasm_panic_from_macro                            ; near
extern memset                                           ; near
extern zero_buffer                                      ; byte
extern snprintf                                         ; near
extern __stack_chk_fail                                 ; near
extern nasm_assert_failed                               ; near
extern strcat                                           ; near
extern strlen                                           ; near
extern nasm_nonfatal                                    ; near
extern nasm_open_write                                  ; near
extern fclose                                           ; near
extern strlist_free                                     ; near
extern putc                                             ; near
extern fwrite                                           ; near
extern fprintf                                          ; near


SECTION .text   align=1 exec                            ; section number 1, code

strlist_head:; Local function
        push    rbp                                     ; 0000 _ 55
        mov     rbp, rsp                                ; 0001 _ 48: 89. E5
        mov     qword [rbp-8H], rdi                     ; 0004 _ 48: 89. 7D, F8
        cmp     qword [rbp-8H], 0                       ; 0008 _ 48: 83. 7D, F8, 00
        jz      ?_001                                   ; 000D _ 74, 0A
        mov     rax, qword [rbp-8H]                     ; 000F _ 48: 8B. 45, F8
        mov     rax, qword [rax+20H]                    ; 0013 _ 48: 8B. 40, 20
        jmp     ?_002                                   ; 0017 _ EB, 05

?_001:  mov     eax, 0                                  ; 0019 _ B8, 00000000
?_002:  pop     rbp                                     ; 001E _ 5D
        ret                                             ; 001F _ C3

strlist_tail:; Local function
        push    rbp                                     ; 0020 _ 55
        mov     rbp, rsp                                ; 0021 _ 48: 89. E5
        mov     qword [rbp-8H], rdi                     ; 0024 _ 48: 89. 7D, F8
        cmp     qword [rbp-8H], 0                       ; 0028 _ 48: 83. 7D, F8, 00
        jz      ?_003                                   ; 002D _ 74, 0D
        mov     rax, qword [rbp-8H]                     ; 002F _ 48: 8B. 45, F8
        mov     rax, qword [rax+20H]                    ; 0033 _ 48: 8B. 40, 20
        test    rax, rax                                ; 0037 _ 48: 85. C0
        jnz     ?_004                                   ; 003A _ 75, 07
?_003:  mov     eax, 0                                  ; 003C _ B8, 00000000
        jmp     ?_005                                   ; 0041 _ EB, 08

?_004:  mov     rax, qword [rbp-8H]                     ; 0043 _ 48: 8B. 45, F8
        mov     rax, qword [rax+28H]                    ; 0047 _ 48: 8B. 40, 28
?_005:  pop     rbp                                     ; 004B _ 5D
        ret                                             ; 004C _ C3

list_option_mask:; Local function
        push    rbp                                     ; 004D _ 55
        mov     rbp, rsp                                ; 004E _ 48: 89. E5
        mov     byte [rbp-1H], dil                      ; 0051 _ 40: 88. 7D, FF
        cmp     byte [rbp-1H], 96                       ; 0055 _ 80. 7D, FF, 60
        jbe     ?_007                                   ; 0059 _ 76, 13
        cmp     byte [rbp-1H], 122                      ; 005B _ 80. 7D, FF, 7A
        jbe     ?_006                                   ; 005F _ 76, 07
        mov     eax, 0                                  ; 0061 _ B8, 00000000
        jmp     ?_013                                   ; 0066 _ EB, 50

?_006:  sub     byte [rbp-1H], 95                       ; 0068 _ 80. 6D, FF, 5F
        jmp     ?_012                                   ; 006C _ EB, 39

?_007:  cmp     byte [rbp-1H], 64                       ; 006E _ 80. 7D, FF, 40
        jbe     ?_009                                   ; 0072 _ 76, 13
        cmp     byte [rbp-1H], 90                       ; 0074 _ 80. 7D, FF, 5A
        jbe     ?_008                                   ; 0078 _ 76, 07
        mov     eax, 0                                  ; 007A _ B8, 00000000
        jmp     ?_013                                   ; 007F _ EB, 37

?_008:  sub     byte [rbp-1H], 37                       ; 0081 _ 80. 6D, FF, 25
        jmp     ?_012                                   ; 0085 _ EB, 20

?_009:  cmp     byte [rbp-1H], 47                       ; 0087 _ 80. 7D, FF, 2F
        jbe     ?_011                                   ; 008B _ 76, 13
        cmp     byte [rbp-1H], 57                       ; 008D _ 80. 7D, FF, 39
        jbe     ?_010                                   ; 0091 _ 76, 07
        mov     eax, 0                                  ; 0093 _ B8, 00000000
        jmp     ?_013                                   ; 0098 _ EB, 1E

?_010:  add     byte [rbp-1H], 6                        ; 009A _ 80. 45, FF, 06
        jmp     ?_012                                   ; 009E _ EB, 07

?_011:  mov     eax, 0                                  ; 00A0 _ B8, 00000000
        jmp     ?_013                                   ; 00A5 _ EB, 11

?_012:  movzx   eax, byte [rbp-1H]                      ; 00A7 _ 0F B6. 45, FF
        mov     edx, 1                                  ; 00AB _ BA, 00000001
        mov     ecx, eax                                ; 00B0 _ 89. C1
        shl     rdx, cl                                 ; 00B2 _ 48: D3. E2
        mov     rax, rdx                                ; 00B5 _ 48: 89. D0
?_013:  pop     rbp                                     ; 00B8 _ 5D
        ret                                             ; 00B9 _ C3

list_option:; Local function
        push    rbp                                     ; 00BA _ 55
        mov     rbp, rsp                                ; 00BB _ 48: 89. E5
        sub     rsp, 8                                  ; 00BE _ 48: 83. EC, 08
        mov     byte [rbp-1H], dil                      ; 00C2 _ 40: 88. 7D, FF
        movzx   eax, byte [rbp-1H]                      ; 00C6 _ 0F B6. 45, FF
        mov     edi, eax                                ; 00CA _ 89. C7
        call    list_option_mask                        ; 00CC _ E8, FFFFFF7C
        mov     rdx, qword [rel active_list_options]    ; 00D1 _ 48: 8B. 15, 00000000(rel)
        and     rax, rdx                                ; 00D8 _ 48: 21. D0
        test    rax, rax                                ; 00DB _ 48: 85. C0
        setne   al                                      ; 00DE _ 0F 95. C0
        movzx   eax, al                                 ; 00E1 _ 0F B6. C0
        test    rax, rax                                ; 00E4 _ 48: 85. C0
        setne   al                                      ; 00E7 _ 0F 95. C0
        leave                                           ; 00EA _ C9
        ret                                             ; 00EB _ C3

err_fill_char:; Local function
        push    rbp                                     ; 00EC _ 55
        mov     rbp, rsp                                ; 00ED _ 48: 89. E5
        mov     dword [rbp-4H], edi                     ; 00F0 _ 89. 7D, FC
        and     dword [rbp-4H], 0FH                     ; 00F3 _ 83. 65, FC, 0F
        cmp     dword [rbp-4H], 0                       ; 00F7 _ 83. 7D, FC, 00
        jnz     ?_014                                   ; 00FB _ 75, 07
        mov     eax, 32                                 ; 00FD _ B8, 00000020
        jmp     ?_017                                   ; 0102 _ EB, 1F

?_014:  cmp     dword [rbp-4H], 5                       ; 0104 _ 83. 7D, FC, 05
        ja      ?_015                                   ; 0108 _ 77, 07
        mov     eax, 45                                 ; 010A _ B8, 0000002D
        jmp     ?_017                                   ; 010F _ EB, 12

?_015:  cmp     dword [rbp-4H], 13                      ; 0111 _ 83. 7D, FC, 0D
        ja      ?_016                                   ; 0115 _ 77, 07
        mov     eax, 42                                 ; 0117 _ B8, 0000002A
        jmp     ?_017                                   ; 011C _ EB, 05

?_016:  mov     eax, 88                                 ; 011E _ B8, 00000058
?_017:  pop     rbp                                     ; 0123 _ 5D
        ret                                             ; 0124 _ C3

list_emit:; Local function
        push    rbp                                     ; 0125 _ 55
        mov     rbp, rsp                                ; 0126 _ 48: 89. E5
        sub     rsp, 16                                 ; 0129 _ 48: 83. EC, 10
        movzx   eax, byte [rel listlinep]               ; 012D _ 0F B6. 05, 00000000(rel)
        test    al, al                                  ; 0134 _ 84. C0
        jnz     ?_018                                   ; 0136 _ 75, 0F
        movzx   eax, byte [rel listdata]                ; 0138 _ 0F B6. 05, 00000000(rel)
        test    al, al                                  ; 013F _ 84. C0
        je      ?_026                                   ; 0141 _ 0F 84, 00000152
?_018:  mov     edx, dword [rel listlineno]             ; 0147 _ 8B. 15, 00000000(rel)
        mov     rax, qword [rel listfp]                 ; 014D _ 48: 8B. 05, 00000000(rel)
        lea     rcx, [rel ?_109]                        ; 0154 _ 48: 8D. 0D, 00000000(rel)
        mov     rsi, rcx                                ; 015B _ 48: 89. CE
        mov     rdi, rax                                ; 015E _ 48: 89. C7
        mov     eax, 0                                  ; 0161 _ B8, 00000000
        call    fprintf                                 ; 0166 _ E8, 00000000(PLT r)
        movzx   eax, byte [rel listdata]                ; 016B _ 0F B6. 05, 00000000(rel)
        test    al, al                                  ; 0172 _ 84. C0
        jz      ?_019                                   ; 0174 _ 74, 32
        mov     edx, dword [rel listoffset]             ; 0176 _ 8B. 15, 00000000(rel)
        mov     rax, qword [rel listfp]                 ; 017C _ 48: 8B. 05, 00000000(rel)
        lea     rcx, [rel listdata]                     ; 0183 _ 48: 8D. 0D, 00000000(rel)
        lea     rsi, [rel ?_110]                        ; 018A _ 48: 8D. 35, 00000000(rel)
        mov     r8, rcx                                 ; 0191 _ 49: 89. C8
        mov     ecx, 19                                 ; 0194 _ B9, 00000013
        mov     rdi, rax                                ; 0199 _ 48: 89. C7
        mov     eax, 0                                  ; 019C _ B8, 00000000
        call    fprintf                                 ; 01A1 _ E8, 00000000(PLT r)
        jmp     ?_020                                   ; 01A6 _ EB, 2A

?_019:  mov     rax, qword [rel listfp]                 ; 01A8 _ 48: 8B. 05, 00000000(rel)
        lea     rdx, [rel ?_111]                        ; 01AF _ 48: 8D. 15, 00000000(rel)
        lea     rsi, [rel ?_112]                        ; 01B6 _ 48: 8D. 35, 00000000(rel)
        mov     rcx, rdx                                ; 01BD _ 48: 89. D1
        mov     edx, 28                                 ; 01C0 _ BA, 0000001C
        mov     rdi, rax                                ; 01C5 _ 48: 89. C7
        mov     eax, 0                                  ; 01C8 _ B8, 00000000
        call    fprintf                                 ; 01CD _ E8, 00000000(PLT r)
?_020:  mov     eax, dword [rel listlevel_e]            ; 01D2 _ 8B. 05, 00000000(rel)
        test    eax, eax                                ; 01D8 _ 85. C0
        jz      ?_023                                   ; 01DA _ 74, 40
        mov     edx, dword [rel listlevel_e]            ; 01DC _ 8B. 15, 00000000(rel)
        mov     eax, dword [rel listlevel]              ; 01E2 _ 8B. 05, 00000000(rel)
        cmp     eax, 9                                  ; 01E8 _ 83. F8, 09
        jg      ?_021                                   ; 01EB _ 7F, 09
        lea     rax, [rel ?_113]                        ; 01ED _ 48: 8D. 05, 00000000(rel)
        jmp     ?_022                                   ; 01F4 _ EB, 07

?_021:  lea     rax, [rel ?_111]                        ; 01F6 _ 48: 8D. 05, 00000000(rel)
?_022:  mov     rdi, qword [rel listfp]                 ; 01FD _ 48: 8B. 3D, 00000000(rel)
        lea     rsi, [rel ?_114]                        ; 0204 _ 48: 8D. 35, 00000000(rel)
        mov     ecx, edx                                ; 020B _ 89. D1
        mov     rdx, rax                                ; 020D _ 48: 89. C2
        mov     eax, 0                                  ; 0210 _ B8, 00000000
        call    fprintf                                 ; 0215 _ E8, 00000000(PLT r)
        jmp     ?_024                                   ; 021A _ EB, 2B

?_023:  movzx   eax, byte [rel listlinep]               ; 021C _ 0F B6. 05, 00000000(rel)
        test    al, al                                  ; 0223 _ 84. C0
        jz      ?_024                                   ; 0225 _ 74, 20
        mov     rax, qword [rel listfp]                 ; 0227 _ 48: 8B. 05, 00000000(rel)
        lea     rdi, [rel ?_115]                        ; 022E _ 48: 8D. 3D, 00000000(rel)
        mov     rcx, rax                                ; 0235 _ 48: 89. C1
        mov     edx, 4                                  ; 0238 _ BA, 00000004
        mov     esi, 1                                  ; 023D _ BE, 00000001
        call    fwrite                                  ; 0242 _ E8, 00000000(PLT r)
?_024:  movzx   eax, byte [rel listlinep]               ; 0247 _ 0F B6. 05, 00000000(rel)
        test    al, al                                  ; 024E _ 84. C0
        jz      ?_025                                   ; 0250 _ 74, 25
        mov     rax, qword [rel listfp]                 ; 0252 _ 48: 8B. 05, 00000000(rel)
        lea     rdx, [rel listline]                     ; 0259 _ 48: 8D. 15, 00000000(rel)
        lea     rcx, [rel ?_116]                        ; 0260 _ 48: 8D. 0D, 00000000(rel)
        mov     rsi, rcx                                ; 0267 _ 48: 89. CE
        mov     rdi, rax                                ; 026A _ 48: 89. C7
        mov     eax, 0                                  ; 026D _ B8, 00000000
        call    fprintf                                 ; 0272 _ E8, 00000000(PLT r)
?_025:  mov     rax, qword [rel listfp]                 ; 0277 _ 48: 8B. 05, 00000000(rel)
        mov     rsi, rax                                ; 027E _ 48: 89. C6
        mov     edi, 10                                 ; 0281 _ BF, 0000000A
        call    putc                                    ; 0286 _ E8, 00000000(PLT r)
        mov     byte [rel listlinep], 0                 ; 028B _ C6. 05, 00000000(rel), 00
        mov     byte [rel listdata], 0                  ; 0292 _ C6. 05, 00000000(rel), 00
?_026:  mov     rax, qword [rel list_errors]            ; 0299 _ 48: 8B. 05, 00000000(rel)
        test    rax, rax                                ; 02A0 _ 48: 85. C0
        je      ?_035                                   ; 02A3 _ 0F 84, 0000012B
        mov     rax, qword [rel list_errors]            ; 02A9 _ 48: 8B. 05, 00000000(rel)
        mov     rdi, rax                                ; 02B0 _ 48: 89. C7
        call    strlist_head                            ; 02B3 _ E8, FFFFFD48
        mov     qword [rbp-8H], rax                     ; 02B8 _ 48: 89. 45, F8
        jmp     ?_034                                   ; 02BC _ E9, 000000F9

?_027:  mov     edx, dword [rel listlineno]             ; 02C1 _ 8B. 15, 00000000(rel)
        mov     rax, qword [rel listfp]                 ; 02C7 _ 48: 8B. 05, 00000000(rel)
        lea     rcx, [rel ?_117]                        ; 02CE _ 48: 8D. 0D, 00000000(rel)
        mov     rsi, rcx                                ; 02D5 _ 48: 89. CE
        mov     rdi, rax                                ; 02D8 _ 48: 89. C7
        mov     eax, 0                                  ; 02DB _ B8, 00000000
        call    fprintf                                 ; 02E0 _ E8, 00000000(PLT r)
        mov     rax, qword [rbp-8H]                     ; 02E5 _ 48: 8B. 45, F8
        mov     rax, qword [rax+18H]                    ; 02E9 _ 48: 8B. 40, 18
        mov     edi, eax                                ; 02ED _ 89. C7
        call    err_fill_char                           ; 02EF _ E8, FFFFFDF8
        mov     byte [rbp-0DH], al                      ; 02F4 _ 88. 45, F3
        mov     dword [rbp-0CH], 0                      ; 02F7 _ C7. 45, F4, 00000000
        jmp     ?_029                                   ; 02FE _ EB, 19

?_028:  mov     rdx, qword [rel listfp]                 ; 0300 _ 48: 8B. 15, 00000000(rel)
        movsx   eax, byte [rbp-0DH]                     ; 0307 _ 0F BE. 45, F3
        mov     rsi, rdx                                ; 030B _ 48: 89. D6
        mov     edi, eax                                ; 030E _ 89. C7
        call    putc                                    ; 0310 _ E8, 00000000(PLT r)
        add     dword [rbp-0CH], 1                      ; 0315 _ 83. 45, F4, 01
?_029:  cmp     dword [rbp-0CH], 17                     ; 0319 _ 83. 7D, F4, 11
        jle     ?_028                                   ; 031D _ 7E, E1
        mov     eax, dword [rel listlevel_e]            ; 031F _ 8B. 05, 00000000(rel)
        test    eax, eax                                ; 0325 _ 85. C0
        jz      ?_032                                   ; 0327 _ 74, 40
        mov     edx, dword [rel listlevel_e]            ; 0329 _ 8B. 15, 00000000(rel)
        mov     eax, dword [rel listlevel]              ; 032F _ 8B. 05, 00000000(rel)
        cmp     eax, 9                                  ; 0335 _ 83. F8, 09
        jg      ?_030                                   ; 0338 _ 7F, 09
        lea     rax, [rel ?_113]                        ; 033A _ 48: 8D. 05, 00000000(rel)
        jmp     ?_031                                   ; 0341 _ EB, 07

?_030:  lea     rax, [rel ?_111]                        ; 0343 _ 48: 8D. 05, 00000000(rel)
?_031:  mov     rdi, qword [rel listfp]                 ; 034A _ 48: 8B. 3D, 00000000(rel)
        lea     rsi, [rel ?_118]                        ; 0351 _ 48: 8D. 35, 00000000(rel)
        mov     ecx, edx                                ; 0358 _ 89. D1
        mov     rdx, rax                                ; 035A _ 48: 89. C2
        mov     eax, 0                                  ; 035D _ B8, 00000000
        call    fprintf                                 ; 0362 _ E8, 00000000(PLT r)
        jmp     ?_033                                   ; 0367 _ EB, 20

?_032:  mov     rax, qword [rel listfp]                 ; 0369 _ 48: 8B. 05, 00000000(rel)
        lea     rdi, [rel ?_119]                        ; 0370 _ 48: 8D. 3D, 00000000(rel)
        mov     rcx, rax                                ; 0377 _ 48: 89. C1
        mov     edx, 5                                  ; 037A _ BA, 00000005
        mov     esi, 1                                  ; 037F _ BE, 00000001
        call    fwrite                                  ; 0384 _ E8, 00000000(PLT r)
?_033:  mov     rax, qword [rbp-8H]                     ; 0389 _ 48: 8B. 45, F8
        lea     rdx, [rax+20H]                          ; 038D _ 48: 8D. 50, 20
        mov     rax, qword [rel listfp]                 ; 0391 _ 48: 8B. 05, 00000000(rel)
        lea     rcx, [rel ?_120]                        ; 0398 _ 48: 8D. 0D, 00000000(rel)
        mov     rsi, rcx                                ; 039F _ 48: 89. CE
        mov     rdi, rax                                ; 03A2 _ 48: 89. C7
        mov     eax, 0                                  ; 03A5 _ B8, 00000000
        call    fprintf                                 ; 03AA _ E8, 00000000(PLT r)
        mov     rax, qword [rbp-8H]                     ; 03AF _ 48: 8B. 45, F8
        mov     rax, qword [rax]                        ; 03B3 _ 48: 8B. 00
        mov     qword [rbp-8H], rax                     ; 03B6 _ 48: 89. 45, F8
?_034:  cmp     qword [rbp-8H], 0                       ; 03BA _ 48: 83. 7D, F8, 00
        jne     ?_027                                   ; 03BF _ 0F 85, FFFFFEFC
        lea     rax, [rel list_errors]                  ; 03C5 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 03CC _ 48: 89. C7
        call    strlist_free                            ; 03CF _ E8, 00000000(PLT r)
?_035:  nop                                             ; 03D4 _ 90
        leave                                           ; 03D5 _ C9
        ret                                             ; 03D6 _ C3

list_cleanup:; Local function
        push    rbp                                     ; 03D7 _ 55
        mov     rbp, rsp                                ; 03D8 _ 48: 89. E5
        mov     rax, qword [rel listfp]                 ; 03DB _ 48: 8B. 05, 00000000(rel)
        test    rax, rax                                ; 03E2 _ 48: 85. C0
        jz      ?_036                                   ; 03E5 _ 74, 2C
        call    list_emit                               ; 03E7 _ E8, FFFFFD39
        mov     rax, qword [rel listfp]                 ; 03EC _ 48: 8B. 05, 00000000(rel)
        mov     rdi, rax                                ; 03F3 _ 48: 89. C7
        call    fclose                                  ; 03F6 _ E8, 00000000(PLT r)
        mov     qword [rel listfp], 0                   ; 03FB _ 48: C7. 05, 00000000(rel), 00000000
        mov     qword [rel active_list_options], 0      ; 0406 _ 48: C7. 05, 00000000(rel), 00000000
        jmp     ?_037                                   ; 0411 _ EB, 01

?_036:  nop                                             ; 0413 _ 90
?_037:  pop     rbp                                     ; 0414 _ 5D
        ret                                             ; 0415 _ C3

list_init:; Local function
        push    rbp                                     ; 0416 _ 55
        mov     rbp, rsp                                ; 0417 _ 48: 89. E5
        sub     rsp, 32                                 ; 041A _ 48: 83. EC, 20
        mov     qword [rbp-18H], rdi                    ; 041E _ 48: 89. 7D, E8
        mov     dword [rbp-4H], 1                       ; 0422 _ C7. 45, FC, 00000001
        mov     rax, qword [rel listfp]                 ; 0429 _ 48: 8B. 05, 00000000(rel)
        test    rax, rax                                ; 0430 _ 48: 85. C0
        jz      ?_038                                   ; 0433 _ 74, 05
        call    list_cleanup                            ; 0435 _ E8, FFFFFF9D
?_038:  cmp     qword [rbp-18H], 0                      ; 043A _ 48: 83. 7D, E8, 00
        jz      ?_039                                   ; 043F _ 74, 0B
        mov     rax, qword [rbp-18H]                    ; 0441 _ 48: 8B. 45, E8
        movzx   eax, byte [rax]                         ; 0445 _ 0F B6. 00
        test    al, al                                  ; 0448 _ 84. C0
        jnz     ?_040                                   ; 044A _ 75, 10
?_039:  mov     qword [rel listfp], 0                   ; 044C _ 48: C7. 05, 00000000(rel), 00000000
        jmp     ?_043                                   ; 0457 _ E9, 0000009C

?_040:  mov     edi, 119                                ; 045C _ BF, 00000077
        call    list_option                             ; 0461 _ E8, FFFFFC54
        test    al, al                                  ; 0466 _ 84. C0
        jz      ?_041                                   ; 0468 _ 74, 04
        or      dword [rbp-4H], 20H                     ; 046A _ 83. 4D, FC, 20
?_041:  mov     edx, dword [rbp-4H]                     ; 046E _ 8B. 55, FC
        mov     rax, qword [rbp-18H]                    ; 0471 _ 48: 8B. 45, E8
        mov     esi, edx                                ; 0475 _ 89. D6
        mov     rdi, rax                                ; 0477 _ 48: 89. C7
        call    nasm_open_write                         ; 047A _ E8, 00000000(PLT r)
        mov     qword [rel listfp], rax                 ; 047F _ 48: 89. 05, 00000000(rel)
        mov     rax, qword [rel listfp]                 ; 0486 _ 48: 8B. 05, 00000000(rel)
        test    rax, rax                                ; 048D _ 48: 85. C0
        jnz     ?_042                                   ; 0490 _ 75, 1D
        mov     rax, qword [rbp-18H]                    ; 0492 _ 48: 8B. 45, E8
        lea     rdx, [rel ?_121]                        ; 0496 _ 48: 8D. 15, 00000000(rel)
        mov     rsi, rax                                ; 049D _ 48: 89. C6
        mov     rdi, rdx                                ; 04A0 _ 48: 89. D7
        mov     eax, 0                                  ; 04A3 _ B8, 00000000
        call    nasm_nonfatal                           ; 04A8 _ E8, 00000000(PLT r)
        jmp     ?_043                                   ; 04AD _ EB, 49

?_042:  mov     rax, qword [rel list_options]           ; 04AF _ 48: 8B. 05, 00000000(rel)
        or      rax, 01H                                ; 04B6 _ 48: 83. C8, 01
        mov     qword [rel active_list_options], rax    ; 04BA _ 48: 89. 05, 00000000(rel)
        mov     byte [rel listline], 0                  ; 04C1 _ C6. 05, 00000000(rel), 00
        mov     dword [rel listlineno], 0               ; 04C8 _ C7. 05, 00000000(rel), 00000000
        mov     qword [rel list_errors], 0              ; 04D2 _ 48: C7. 05, 00000000(rel), 00000000
        mov     dword [rel listlevel], 0                ; 04DD _ C7. 05, 00000000(rel), 00000000
        mov     dword [rel suppress], 0                 ; 04E7 _ C7. 05, 00000000(rel), 00000000
        mov     byte [rel user_nolist], 0               ; 04F1 _ C6. 05, 00000000(rel), 00
?_043:  leave                                           ; 04F8 _ C9
        ret                                             ; 04F9 _ C3

list_out:; Local function
        push    rbp                                     ; 04FA _ 55
        mov     rbp, rsp                                ; 04FB _ 48: 89. E5
        push    rbx                                     ; 04FE _ 53
        sub     rsp, 24                                 ; 04FF _ 48: 83. EC, 18
        mov     qword [rbp-18H], rdi                    ; 0503 _ 48: 89. 7D, E8
        mov     qword [rbp-20H], rsi                    ; 0507 _ 48: 89. 75, E0
        lea     rax, [rel listdata]                     ; 050B _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 0512 _ 48: 89. C7
        call    strlen                                  ; 0515 _ E8, 00000000(PLT r)
        mov     rbx, rax                                ; 051A _ 48: 89. C3
        mov     rax, qword [rbp-20H]                    ; 051D _ 48: 8B. 45, E0
        mov     rdi, rax                                ; 0521 _ 48: 89. C7
        call    strlen                                  ; 0524 _ E8, 00000000(PLT r)
        add     rax, rbx                                ; 0529 _ 48: 01. D8
        cmp     rax, 18                                 ; 052C _ 48: 83. F8, 12
        jbe     ?_044                                   ; 0530 _ 76, 26
        lea     rax, [rel listdata]                     ; 0532 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 0539 _ 48: 89. C7
        call    strlen                                  ; 053C _ E8, 00000000(PLT r)
        mov     rdx, rax                                ; 0541 _ 48: 89. C2
        lea     rax, [rel listdata]                     ; 0544 _ 48: 8D. 05, 00000000(rel)
        add     rax, rdx                                ; 054B _ 48: 01. D0
; Note: Length-changing prefix causes delay on old Intel processors
        mov     word [rax], 45                          ; 054E _ 66: C7. 00, 002D
        call    list_emit                               ; 0553 _ E8, FFFFFBCD
?_044:  movzx   eax, byte [rel listdata]                ; 0558 _ 0F B6. 05, 00000000(rel)
        test    al, al                                  ; 055F _ 84. C0
        jnz     ?_045                                   ; 0561 _ 75, 0A
        mov     rax, qword [rbp-18H]                    ; 0563 _ 48: 8B. 45, E8
        mov     dword [rel listoffset], eax             ; 0567 _ 89. 05, 00000000(rel)
?_045:  mov     rax, qword [rbp-20H]                    ; 056D _ 48: 8B. 45, E0
        lea     rdx, [rel listdata]                     ; 0571 _ 48: 8D. 15, 00000000(rel)
        mov     rsi, rax                                ; 0578 _ 48: 89. C6
        mov     rdi, rdx                                ; 057B _ 48: 89. D7
        call    strcat                                  ; 057E _ E8, 00000000(PLT r)
        nop                                             ; 0583 _ 90
        mov     rbx, qword [rbp-8H]                     ; 0584 _ 48: 8B. 5D, F8
        leave                                           ; 0588 _ C9
        ret                                             ; 0589 _ C3

list_address:; Local function
        push    rbp                                     ; 058A _ 55
        mov     rbp, rsp                                ; 058B _ 48: 89. E5
        sub     rsp, 80                                 ; 058E _ 48: 83. EC, 50
        mov     qword [rbp-38H], rdi                    ; 0592 _ 48: 89. 7D, C8
        mov     qword [rbp-40H], rsi                    ; 0596 _ 48: 89. 75, C0
        mov     qword [rbp-48H], rdx                    ; 059A _ 48: 89. 55, B8
        mov     dword [rbp-4CH], ecx                    ; 059E _ 89. 4D, B4
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        mov     rax, qword [fs:abs 28H]                 ; 05A1 _ 64 48: 8B. 04 25, 00000028
        mov     qword [rbp-8H], rax                     ; 05AA _ 48: 89. 45, F8
        xor     eax, eax                                ; 05AE _ 31. C0
        lea     rax, [rbp-20H]                          ; 05B0 _ 48: 8D. 45, E0
        mov     qword [rbp-28H], rax                    ; 05B4 _ 48: 89. 45, D8
        cmp     dword [rbp-4CH], 8                      ; 05B8 _ 83. 7D, B4, 08
        setg    al                                      ; 05BC _ 0F 9F. C0
        movzx   eax, al                                 ; 05BF _ 0F B6. C0
        test    rax, rax                                ; 05C2 _ 48: 85. C0
        jz      ?_046                                   ; 05C5 _ 74, 22
        lea     rdx, [rel ?_122]                        ; 05C7 _ 48: 8D. 15, 00000000(rel)
        lea     rsi, [rel __func__.1]                   ; 05CE _ 48: 8D. 35, 00000000(rel)
        lea     rax, [rel ?_123]                        ; 05D5 _ 48: 8D. 05, 00000000(rel)
        mov     ecx, 181                                ; 05DC _ B9, 000000B5
        mov     rdi, rax                                ; 05E1 _ 48: 89. C7
        call    nasm_assert_failed                      ; 05E4 _ E8, 00000000(PLT r)
?_046:  mov     rax, qword [rbp-28H]                    ; 05E9 _ 48: 8B. 45, D8
        lea     rdx, [rax+1H]                           ; 05ED _ 48: 8D. 50, 01
        mov     qword [rbp-28H], rdx                    ; 05F1 _ 48: 89. 55, D8
        mov     rdx, qword [rbp-40H]                    ; 05F5 _ 48: 8B. 55, C0
        movzx   edx, byte [rdx]                         ; 05F9 _ 0F B6. 12
        mov     byte [rax], dl                          ; 05FC _ 88. 10
        jmp     ?_048                                   ; 05FE _ EB, 48

?_047:  mov     rax, qword [rbp-48H]                    ; 0600 _ 48: 8B. 45, B8
        sar     rax, 4                                  ; 0604 _ 48: C1. F8, 04
        and     eax, 0FH                                ; 0608 _ 83. E0, 0F
        mov     rdx, rax                                ; 060B _ 48: 89. C2
        lea     rax, [rel xdigit]                       ; 060E _ 48: 8D. 05, 00000000(rel)
        movzx   edx, byte [rdx+rax]                     ; 0615 _ 0F B6. 14 02
        mov     rax, qword [rbp-28H]                    ; 0619 _ 48: 8B. 45, D8
        mov     byte [rax], dl                          ; 061D _ 88. 10
        mov     rax, qword [rbp-48H]                    ; 061F _ 48: 8B. 45, B8
        and     eax, 0FH                                ; 0623 _ 83. E0, 0F
        mov     rcx, rax                                ; 0626 _ 48: 89. C1
        mov     rax, qword [rbp-28H]                    ; 0629 _ 48: 8B. 45, D8
        lea     rdx, [rax+1H]                           ; 062D _ 48: 8D. 50, 01
        lea     rax, [rel xdigit]                       ; 0631 _ 48: 8D. 05, 00000000(rel)
        movzx   eax, byte [rcx+rax]                     ; 0638 _ 0F B6. 04 01
        mov     byte [rdx], al                          ; 063C _ 88. 02
        sar     qword [rbp-48H], 8                      ; 063E _ 48: C1. 7D, B8, 08
        add     qword [rbp-28H], 2                      ; 0643 _ 48: 83. 45, D8, 02
?_048:  mov     eax, dword [rbp-4CH]                    ; 0648 _ 8B. 45, B4
        lea     edx, [rax-1H]                           ; 064B _ 8D. 50, FF
        mov     dword [rbp-4CH], edx                    ; 064E _ 89. 55, B4
        test    eax, eax                                ; 0651 _ 85. C0
        jnz     ?_047                                   ; 0653 _ 75, AB
        mov     rax, qword [rbp-40H]                    ; 0655 _ 48: 8B. 45, C0
        lea     rcx, [rax+1H]                           ; 0659 _ 48: 8D. 48, 01
        mov     rax, qword [rbp-28H]                    ; 065D _ 48: 8B. 45, D8
        lea     rdx, [rax+1H]                           ; 0661 _ 48: 8D. 50, 01
        mov     qword [rbp-28H], rdx                    ; 0665 _ 48: 89. 55, D8
        movzx   edx, byte [rcx]                         ; 0669 _ 0F B6. 11
        mov     byte [rax], dl                          ; 066C _ 88. 10
        mov     rax, qword [rbp-28H]                    ; 066E _ 48: 8B. 45, D8
        mov     byte [rax], 0                           ; 0672 _ C6. 00, 00
        lea     rdx, [rbp-20H]                          ; 0675 _ 48: 8D. 55, E0
        mov     rax, qword [rbp-38H]                    ; 0679 _ 48: 8B. 45, C8
        mov     rsi, rdx                                ; 067D _ 48: 89. D6
        mov     rdi, rax                                ; 0680 _ 48: 89. C7
        call    list_out                                ; 0683 _ E8, FFFFFE72
        nop                                             ; 0688 _ 90
        mov     rax, qword [rbp-8H]                     ; 0689 _ 48: 8B. 45, F8
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        sub     rax, qword [fs:abs 28H]                 ; 068D _ 64 48: 2B. 04 25, 00000028
        jz      ?_049                                   ; 0696 _ 74, 05
        call    __stack_chk_fail                        ; 0698 _ E8, 00000000(PLT r)
?_049:  leave                                           ; 069D _ C9
        ret                                             ; 069E _ C3

list_size:; Local function
        push    rbp                                     ; 069F _ 55
        mov     rbp, rsp                                ; 06A0 _ 48: 89. E5
        add     rsp, -128                               ; 06A3 _ 48: 83. C4, 80
        mov     qword [rbp-68H], rdi                    ; 06A7 _ 48: 89. 7D, 98
        mov     qword [rbp-70H], rsi                    ; 06AB _ 48: 89. 75, 90
        mov     qword [rbp-78H], rdx                    ; 06AF _ 48: 89. 55, 88
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        mov     rax, qword [fs:abs 28H]                 ; 06B3 _ 64 48: 8B. 04 25, 00000028
        mov     qword [rbp-8H], rax                     ; 06BC _ 48: 89. 45, F8
        xor     eax, eax                                ; 06C0 _ 31. C0
        mov     edi, 100                                ; 06C2 _ BF, 00000064
        call    list_option                             ; 06C7 _ E8, FFFFF9EE
        test    al, al                                  ; 06CC _ 84. C0
        jz      ?_050                                   ; 06CE _ 74, 0D
        lea     rax, [rel ?_124]                        ; 06D0 _ 48: 8D. 05, 00000000(rel)
        mov     qword [rbp-58H], rax                    ; 06D7 _ 48: 89. 45, A8
        jmp     ?_051                                   ; 06DB _ EB, 0B

?_050:  lea     rax, [rel ?_125]                        ; 06DD _ 48: 8D. 05, 00000000(rel)
        mov     qword [rbp-58H], rax                    ; 06E4 _ 48: 89. 45, A8
?_051:  mov     rsi, qword [rbp-78H]                    ; 06E8 _ 48: 8B. 75, 88
        mov     rcx, qword [rbp-70H]                    ; 06EC _ 48: 8B. 4D, 90
        mov     rdx, qword [rbp-58H]                    ; 06F0 _ 48: 8B. 55, A8
        lea     rax, [rbp-50H]                          ; 06F4 _ 48: 8D. 45, B0
        mov     r8, rsi                                 ; 06F8 _ 49: 89. F0
        mov     esi, 64                                 ; 06FB _ BE, 00000040
        mov     rdi, rax                                ; 0700 _ 48: 89. C7
        mov     eax, 0                                  ; 0703 _ B8, 00000000
        call    snprintf                                ; 0708 _ E8, 00000000(PLT r)
        lea     rdx, [rbp-50H]                          ; 070D _ 48: 8D. 55, B0
        mov     rax, qword [rbp-68H]                    ; 0711 _ 48: 8B. 45, 98
        mov     rsi, rdx                                ; 0715 _ 48: 89. D6
        mov     rdi, rax                                ; 0718 _ 48: 89. C7
        call    list_out                                ; 071B _ E8, FFFFFDDA
        nop                                             ; 0720 _ 90
        mov     rax, qword [rbp-8H]                     ; 0721 _ 48: 8B. 45, F8
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        sub     rax, qword [fs:abs 28H]                 ; 0725 _ 64 48: 2B. 04 25, 00000028
        jz      ?_052                                   ; 072E _ 74, 05
        call    __stack_chk_fail                        ; 0730 _ E8, 00000000(PLT r)
?_052:  leave                                           ; 0735 _ C9
        ret                                             ; 0736 _ C3

list_output:; Local function
        push    rbp                                     ; 0737 _ 55
        mov     rbp, rsp                                ; 0738 _ 48: 89. E5
        sub     rsp, 80                                 ; 073B _ 48: 83. EC, 50
        mov     qword [rbp-48H], rdi                    ; 073F _ 48: 89. 7D, B8
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        mov     rax, qword [fs:abs 28H]                 ; 0743 _ 64 48: 8B. 04 25, 00000028
        mov     qword [rbp-8H], rax                     ; 074C _ 48: 89. 45, F8
        xor     eax, eax                                ; 0750 _ 31. C0
        mov     rax, qword [rbp-48H]                    ; 0752 _ 48: 8B. 45, B8
        mov     rax, qword [rax+28H]                    ; 0756 _ 48: 8B. 40, 28
        mov     qword [rbp-38H], rax                    ; 075A _ 48: 89. 45, C8
        mov     rax, qword [rbp-48H]                    ; 075E _ 48: 8B. 45, B8
        mov     rax, qword [rax]                        ; 0762 _ 48: 8B. 00
        mov     qword [rbp-30H], rax                    ; 0765 _ 48: 89. 45, D0
        mov     rax, qword [rbp-48H]                    ; 0769 _ 48: 8B. 45, B8
        mov     rax, qword [rax+38H]                    ; 076D _ 48: 8B. 40, 38
        mov     qword [rbp-28H], rax                    ; 0771 _ 48: 89. 45, D8
        mov     rax, qword [rel listfp]                 ; 0775 _ 48: 8B. 05, 00000000(rel)
        test    rax, rax                                ; 077C _ 48: 85. C0
        je      ?_066                                   ; 077F _ 0F 84, 000002A0
        mov     eax, dword [rel suppress]               ; 0785 _ 8B. 05, 00000000(rel)
        test    eax, eax                                ; 078B _ 85. C0
        jne     ?_066                                   ; 078D _ 0F 85, 00000292
        movzx   eax, byte [rel user_nolist]             ; 0793 _ 0F B6. 05, 00000000(rel)
        test    al, al                                  ; 079A _ 84. C0
        jne     ?_066                                   ; 079C _ 0F 85, 00000283
        mov     rax, qword [rbp-48H]                    ; 07A2 _ 48: 8B. 45, B8
        mov     eax, dword [rax+10H]                    ; 07A6 _ 8B. 40, 10
        cmp     eax, 5                                  ; 07A9 _ 83. F8, 05
        je      ?_061                                   ; 07AC _ 0F 84, 00000171
        cmp     eax, 5                                  ; 07B2 _ 83. F8, 05
        ja      ?_065                                   ; 07B5 _ 0F 87, 0000024C
        cmp     eax, 4                                  ; 07BB _ 83. F8, 04
        je      ?_062                                   ; 07BE _ 0F 84, 000001C0
        cmp     eax, 4                                  ; 07C4 _ 83. F8, 04
        ja      ?_065                                   ; 07C7 _ 0F 87, 0000023A
        cmp     eax, 3                                  ; 07CD _ 83. F8, 03
        je      ?_060                                   ; 07D0 _ 0F 84, 00000124
        cmp     eax, 3                                  ; 07D6 _ 83. F8, 03
        ja      ?_065                                   ; 07D9 _ 0F 87, 00000228
        cmp     eax, 2                                  ; 07DF _ 83. F8, 02
        jz      ?_053                                   ; 07E2 _ 74, 1B
        cmp     eax, 2                                  ; 07E4 _ 83. F8, 02
        ja      ?_065                                   ; 07E7 _ 0F 87, 0000021A
        test    eax, eax                                ; 07ED _ 85. C0
        jz      ?_055                                   ; 07EF _ 74, 3F
        cmp     eax, 1                                  ; 07F1 _ 83. F8, 01
        je      ?_063                                   ; 07F4 _ 0F 84, 000001B0
        jmp     ?_065                                   ; 07FA _ E9, 00000208

?_053:  cmp     qword [rbp-38H], 16                     ; 07FF _ 48: 83. 7D, C8, 10
        jbe     ?_054                                   ; 0804 _ 76, 1F
        mov     rax, qword [rbp-30H]                    ; 0806 _ 48: 8B. 45, D0
        mov     rdx, qword [rbp-38H]                    ; 080A _ 48: 8B. 55, C8
        lea     rcx, [rel ?_126]                        ; 080E _ 48: 8D. 0D, 00000000(rel)
        mov     rsi, rcx                                ; 0815 _ 48: 89. CE
        mov     rdi, rax                                ; 0818 _ 48: 89. C7
        call    list_size                               ; 081B _ E8, FFFFFE7F
        jmp     ?_068                                   ; 0820 _ E9, 00000204

?_054:  lea     rax, [rel zero_buffer]                  ; 0825 _ 48: 8D. 05, 00000000(rel)
        mov     qword [rbp-28H], rax                    ; 082C _ 48: 89. 45, D8
?_055:  cmp     qword [rbp-38H], 0                      ; 0830 _ 48: 83. 7D, C8, 00
        jnz     ?_056                                   ; 0835 _ 75, 21
        movzx   eax, byte [rel listdata]                ; 0837 _ 0F B6. 05, 00000000(rel)
        test    al, al                                  ; 083E _ 84. C0
        jne     ?_067                                   ; 0840 _ 0F 85, 000001E2
        mov     rax, qword [rbp-48H]                    ; 0846 _ 48: 8B. 45, B8
        mov     rax, qword [rax]                        ; 084A _ 48: 8B. 00
        mov     dword [rel listoffset], eax             ; 084D _ 89. 05, 00000000(rel)
        jmp     ?_067                                   ; 0853 _ E9, 000001D0

?_056:  cmp     qword [rbp-28H], 0                      ; 0858 _ 48: 83. 7D, D8, 00
        jz      ?_059                                   ; 085D _ 74, 7C
        jmp     ?_058                                   ; 085F _ EB, 64

?_057:  mov     rax, qword [rbp-28H]                    ; 0861 _ 48: 8B. 45, D8
        movzx   eax, byte [rax]                         ; 0865 _ 0F B6. 00
        shr     al, 4                                   ; 0868 _ C0. E8, 04
        movzx   eax, al                                 ; 086B _ 0F B6. C0
        and     eax, 0FH                                ; 086E _ 83. E0, 0F
        cdqe                                            ; 0871 _ 48: 98
        lea     rdx, [rel xdigit]                       ; 0873 _ 48: 8D. 15, 00000000(rel)
        movzx   eax, byte [rax+rdx]                     ; 087A _ 0F B6. 04 10
        mov     byte [rbp-20H], al                      ; 087E _ 88. 45, E0
        mov     rax, qword [rbp-28H]                    ; 0881 _ 48: 8B. 45, D8
        movzx   eax, byte [rax]                         ; 0885 _ 0F B6. 00
        movzx   eax, al                                 ; 0888 _ 0F B6. C0
        and     eax, 0FH                                ; 088B _ 83. E0, 0F
        cdqe                                            ; 088E _ 48: 98
        lea     rdx, [rel xdigit]                       ; 0890 _ 48: 8D. 15, 00000000(rel)
        movzx   eax, byte [rax+rdx]                     ; 0897 _ 0F B6. 04 10
        mov     byte [rbp-1FH], al                      ; 089B _ 88. 45, E1
        mov     byte [rbp-1EH], 0                       ; 089E _ C6. 45, E2, 00
        mov     rax, qword [rbp-30H]                    ; 08A2 _ 48: 8B. 45, D0
        lea     rdx, [rax+1H]                           ; 08A6 _ 48: 8D. 50, 01
        mov     qword [rbp-30H], rdx                    ; 08AA _ 48: 89. 55, D0
        mov     rdx, rax                                ; 08AE _ 48: 89. C2
        lea     rax, [rbp-20H]                          ; 08B1 _ 48: 8D. 45, E0
        mov     rsi, rax                                ; 08B5 _ 48: 89. C6
        mov     rdi, rdx                                ; 08B8 _ 48: 89. D7
        call    list_out                                ; 08BB _ E8, FFFFFC3A
        add     qword [rbp-28H], 1                      ; 08C0 _ 48: 83. 45, D8, 01
?_058:  mov     rax, qword [rbp-38H]                    ; 08C5 _ 48: 8B. 45, C8
        lea     rdx, [rax-1H]                           ; 08C9 _ 48: 8D. 50, FF
        mov     qword [rbp-38H], rdx                    ; 08CD _ 48: 89. 55, C8
        test    rax, rax                                ; 08D1 _ 48: 85. C0
        jnz     ?_057                                   ; 08D4 _ 75, 8B
        jmp     ?_067                                   ; 08D6 _ E9, 0000014D

?_059:  mov     rax, qword [rbp-30H]                    ; 08DB _ 48: 8B. 45, D0
        mov     rdx, qword [rbp-38H]                    ; 08DF _ 48: 8B. 55, C8
        lea     rcx, [rel ?_127]                        ; 08E3 _ 48: 8D. 0D, 00000000(rel)
        mov     rsi, rcx                                ; 08EA _ 48: 89. CE
        mov     rdi, rax                                ; 08ED _ 48: 89. C7
        call    list_size                               ; 08F0 _ E8, FFFFFDAA
        jmp     ?_067                                   ; 08F5 _ E9, 0000012E

?_060:  mov     rax, qword [rbp-38H]                    ; 08FA _ 48: 8B. 45, C8
        mov     ecx, eax                                ; 08FE _ 89. C1
        mov     rax, qword [rbp-48H]                    ; 0900 _ 48: 8B. 45, B8
        mov     rax, qword [rax+40H]                    ; 0904 _ 48: 8B. 40, 40
        mov     rdx, rax                                ; 0908 _ 48: 89. C2
        mov     rax, qword [rbp-30H]                    ; 090B _ 48: 8B. 45, D0
        lea     rsi, [rel ?_128]                        ; 090F _ 48: 8D. 35, 00000000(rel)
        mov     rdi, rax                                ; 0916 _ 48: 89. C7
        call    list_address                            ; 0919 _ E8, FFFFFC6C
        jmp     ?_068                                   ; 091E _ E9, 00000106

?_061:  mov     byte [rbp-20H], 91                      ; 0923 _ C6. 45, E0, 5B
        mov     rax, qword [rbp-38H]                    ; 0927 _ 48: 8B. 45, C8
        lea     rdx, [rax+rax]                          ; 092B _ 48: 8D. 14 00
        lea     rax, [rbp-20H]                          ; 092F _ 48: 8D. 45, E0
        add     rax, 1                                  ; 0933 _ 48: 83. C0, 01
        mov     esi, 115                                ; 0937 _ BE, 00000073
        mov     rdi, rax                                ; 093C _ 48: 89. C7
        call    memset                                  ; 093F _ E8, 00000000(PLT r)
        mov     rax, qword [rbp-38H]                    ; 0944 _ 48: 8B. 45, C8
        add     rax, rax                                ; 0948 _ 48: 01. C0
        add     rax, 1                                  ; 094B _ 48: 83. C0, 01
        mov     byte [rbp+rax-20H], 93                  ; 094F _ C6. 44 05, E0, 5D
        mov     rax, qword [rbp-38H]                    ; 0954 _ 48: 8B. 45, C8
        add     rax, rax                                ; 0958 _ 48: 01. C0
        add     rax, 2                                  ; 095B _ 48: 83. C0, 02
        mov     byte [rbp+rax-20H], 0                   ; 095F _ C6. 44 05, E0, 00
        mov     rax, qword [rbp-30H]                    ; 0964 _ 48: 8B. 45, D0
        lea     rdx, [rbp-20H]                          ; 0968 _ 48: 8D. 55, E0
        mov     rsi, rdx                                ; 096C _ 48: 89. D6
        mov     rdi, rax                                ; 096F _ 48: 89. C7
        call    list_out                                ; 0972 _ E8, FFFFFB83
        mov     rax, qword [rbp-38H]                    ; 0977 _ 48: 8B. 45, C8
        add     qword [rbp-30H], rax                    ; 097B _ 48: 01. 45, D0
        jmp     ?_068                                   ; 097F _ E9, 000000A5

?_062:  mov     rax, qword [rbp-38H]                    ; 0984 _ 48: 8B. 45, C8
        mov     ecx, eax                                ; 0988 _ 89. C1
        mov     rax, qword [rbp-48H]                    ; 098A _ 48: 8B. 45, B8
        mov     rax, qword [rax+40H]                    ; 098E _ 48: 8B. 40, 40
        mov     rdx, rax                                ; 0992 _ 48: 89. C2
        mov     rax, qword [rbp-30H]                    ; 0995 _ 48: 8B. 45, D0
        lea     rsi, [rel ?_129]                        ; 0999 _ 48: 8D. 35, 00000000(rel)
        mov     rdi, rax                                ; 09A0 _ 48: 89. C7
        call    list_address                            ; 09A3 _ E8, FFFFFBE2
        jmp     ?_068                                   ; 09A8 _ EB, 7F

?_063:  cmp     qword [rbp-38H], 8                      ; 09AA _ 48: 83. 7D, C8, 08
        jbe     ?_064                                   ; 09AF _ 76, 1C
        mov     rax, qword [rbp-30H]                    ; 09B1 _ 48: 8B. 45, D0
        mov     rdx, qword [rbp-38H]                    ; 09B5 _ 48: 8B. 55, C8
        lea     rcx, [rel ?_130]                        ; 09B9 _ 48: 8D. 0D, 00000000(rel)
        mov     rsi, rcx                                ; 09C0 _ 48: 89. CE
        mov     rdi, rax                                ; 09C3 _ 48: 89. C7
        call    list_size                               ; 09C6 _ E8, FFFFFCD4
        jmp     ?_068                                   ; 09CB _ EB, 5C

?_064:  mov     rax, qword [rbp-38H]                    ; 09CD _ 48: 8B. 45, C8
        lea     rdx, [rax+rax]                          ; 09D1 _ 48: 8D. 14 00
        lea     rax, [rbp-20H]                          ; 09D5 _ 48: 8D. 45, E0
        mov     esi, 63                                 ; 09D9 _ BE, 0000003F
        mov     rdi, rax                                ; 09DE _ 48: 89. C7
        call    memset                                  ; 09E1 _ E8, 00000000(PLT r)
        mov     rax, qword [rbp-38H]                    ; 09E6 _ 48: 8B. 45, C8
        add     rax, rax                                ; 09EA _ 48: 01. C0
        mov     byte [rbp+rax-20H], 0                   ; 09ED _ C6. 44 05, E0, 00
        mov     rax, qword [rbp-30H]                    ; 09F2 _ 48: 8B. 45, D0
        lea     rdx, [rbp-20H]                          ; 09F6 _ 48: 8D. 55, E0
        mov     rsi, rdx                                ; 09FA _ 48: 89. D6
        mov     rdi, rax                                ; 09FD _ 48: 89. C7
        call    list_out                                ; 0A00 _ E8, FFFFFAF5
        jmp     ?_068                                   ; 0A05 _ EB, 22

?_065:  lea     rcx, [rel ?_122]                        ; 0A07 _ 48: 8D. 0D, 00000000(rel)
        lea     rax, [rel __func__.0]                   ; 0A0E _ 48: 8D. 05, 00000000(rel)
        mov     edx, 272                                ; 0A15 _ BA, 00000110
        mov     rsi, rcx                                ; 0A1A _ 48: 89. CE
        mov     rdi, rax                                ; 0A1D _ 48: 89. C7
        call    nasm_panic_from_macro                   ; 0A20 _ E8, 00000000(PLT r)
?_066:  nop                                             ; 0A25 _ 90
        jmp     ?_068                                   ; 0A26 _ EB, 01

?_067:  nop                                             ; 0A28 _ 90
?_068:  mov     rax, qword [rbp-8H]                     ; 0A29 _ 48: 8B. 45, F8
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        sub     rax, qword [fs:abs 28H]                 ; 0A2D _ 64 48: 2B. 04 25, 00000028
        jz      ?_069                                   ; 0A36 _ 74, 05
        call    __stack_chk_fail                        ; 0A38 _ E8, 00000000(PLT r)
?_069:  leave                                           ; 0A3D _ C9
        ret                                             ; 0A3E _ C3

list_line:; Local function
        push    rbp                                     ; 0A3F _ 55
        mov     rbp, rsp                                ; 0A40 _ 48: 89. E5
        sub     rsp, 16                                 ; 0A43 _ 48: 83. EC, 10
        mov     dword [rbp-4H], edi                     ; 0A47 _ 89. 7D, FC
        mov     dword [rbp-8H], esi                     ; 0A4A _ 89. 75, F8
        mov     qword [rbp-10H], rdx                    ; 0A4D _ 48: 89. 55, F0
        mov     rax, qword [rel listfp]                 ; 0A51 _ 48: 8B. 05, 00000000(rel)
        test    rax, rax                                ; 0A58 _ 48: 85. C0
        jz      ?_071                                   ; 0A5B _ 74, 6D
        movzx   eax, byte [rel user_nolist]             ; 0A5D _ 0F B6. 05, 00000000(rel)
        test    al, al                                  ; 0A64 _ 84. C0
        jnz     ?_072                                   ; 0A66 _ 75, 65
        call    list_emit                               ; 0A68 _ E8, FFFFF6B8
        cmp     dword [rbp-8H], 0                       ; 0A6D _ 83. 7D, F8, 00
        js      ?_070                                   ; 0A71 _ 78, 09
        mov     eax, dword [rbp-8H]                     ; 0A73 _ 8B. 45, F8
        mov     dword [rel listlineno], eax             ; 0A76 _ 89. 05, 00000000(rel)
?_070:  mov     byte [rel listlinep], 1                 ; 0A7C _ C6. 05, 00000000(rel), 01
        mov     rax, qword [rbp-10H]                    ; 0A83 _ 48: 8B. 45, F0
        lea     rcx, [rel listline]                     ; 0A87 _ 48: 8D. 0D, 00000000(rel)
        mov     edx, 1021                               ; 0A8E _ BA, 000003FD
        mov     rsi, rax                                ; 0A93 _ 48: 89. C6
        mov     rdi, rcx                                ; 0A96 _ 48: 89. CF
        call    strlcpy                                 ; 0A99 _ E8, 00000000(PLT r)
        lea     rax, [rel ?_108]                        ; 0A9E _ 48: 8D. 05, 00000000(rel)
        lea     rcx, [rel ?_131]                        ; 0AA5 _ 48: 8D. 0D, 00000000(rel)
        mov     edx, 4                                  ; 0AAC _ BA, 00000004
        mov     rsi, rcx                                ; 0AB1 _ 48: 89. CE
        mov     rdi, rax                                ; 0AB4 _ 48: 89. C7
        call    memcpy                                  ; 0AB7 _ E8, 00000000(PLT r)
        mov     eax, dword [rel listlevel]              ; 0ABC _ 8B. 05, 00000000(rel)
        mov     dword [rel listlevel_e], eax            ; 0AC2 _ 89. 05, 00000000(rel)
        jmp     ?_073                                   ; 0AC8 _ EB, 04

?_071:  nop                                             ; 0ACA _ 90
        jmp     ?_073                                   ; 0ACB _ EB, 01

?_072:  nop                                             ; 0ACD _ 90
?_073:  leave                                           ; 0ACE _ C9
        ret                                             ; 0ACF _ C3

list_uplevel:; Local function
        push    rbp                                     ; 0AD0 _ 55
        mov     rbp, rsp                                ; 0AD1 _ 48: 89. E5
        sub     rsp, 16                                 ; 0AD4 _ 48: 83. EC, 10
        mov     dword [rbp-4H], edi                     ; 0AD8 _ 89. 7D, FC
        mov     qword [rbp-10H], rsi                    ; 0ADB _ 48: 89. 75, F0
        mov     rax, qword [rel listfp]                 ; 0ADF _ 48: 8B. 05, 00000000(rel)
        test    rax, rax                                ; 0AE6 _ 48: 85. C0
        je      ?_077                                   ; 0AE9 _ 0F 84, 000000CA
        cmp     dword [rbp-4H], 5                       ; 0AEF _ 83. 7D, FC, 05
        jz      ?_074                                   ; 0AF3 _ 74, 62
        cmp     dword [rbp-4H], 5                       ; 0AF5 _ 83. 7D, FC, 05
        ja      ?_076                                   ; 0AF9 _ 0F 87, 000000A9
        cmp     dword [rbp-4H], 3                       ; 0AFF _ 83. 7D, FC, 03
        je      ?_075                                   ; 0B03 _ 0F 84, 0000008E
        cmp     dword [rbp-4H], 4                       ; 0B09 _ 83. 7D, FC, 04
        jne     ?_076                                   ; 0B0D _ 0F 85, 00000095
        mov     edi, 99                                 ; 0B13 _ BF, 00000063
        call    list_option                             ; 0B18 _ E8, FFFFF59D
        xor     eax, 01H                                ; 0B1D _ 83. F0, 01
        test    al, al                                  ; 0B20 _ 84. C0
        je      ?_078                                   ; 0B22 _ 0F 84, 00000094
        mov     eax, dword [rel suppress]               ; 0B28 _ 8B. 05, 00000000(rel)
        or      eax, 01H                                ; 0B2E _ 83. C8, 01
        mov     dword [rel suppress], eax               ; 0B31 _ 89. 05, 00000000(rel)
        mov     rdx, qword [rbp-10H]                    ; 0B37 _ 48: 8B. 55, F0
        mov     eax, dword [rel listoffset]             ; 0B3B _ 8B. 05, 00000000(rel)
        cdqe                                            ; 0B41 _ 48: 98
        lea     rcx, [rel ?_132]                        ; 0B43 _ 48: 8D. 0D, 00000000(rel)
        mov     rsi, rcx                                ; 0B4A _ 48: 89. CE
        mov     rdi, rax                                ; 0B4D _ 48: 89. C7
        call    list_size                               ; 0B50 _ E8, FFFFFB4A
        jmp     ?_078                                   ; 0B55 _ EB, 65

?_074:  mov     edi, 116                                ; 0B57 _ BF, 00000074
        call    list_option                             ; 0B5C _ E8, FFFFF559
        xor     eax, 01H                                ; 0B61 _ 83. F0, 01
        test    al, al                                  ; 0B64 _ 84. C0
        jz      ?_079                                   ; 0B66 _ 74, 57
        mov     eax, dword [rel suppress]               ; 0B68 _ 8B. 05, 00000000(rel)
        or      eax, 02H                                ; 0B6E _ 83. C8, 02
        mov     dword [rel suppress], eax               ; 0B71 _ 89. 05, 00000000(rel)
        mov     rdx, qword [rbp-10H]                    ; 0B77 _ 48: 8B. 55, F0
        mov     eax, dword [rel listoffset]             ; 0B7B _ 8B. 05, 00000000(rel)
        cdqe                                            ; 0B81 _ 48: 98
        lea     rcx, [rel ?_133]                        ; 0B83 _ 48: 8D. 0D, 00000000(rel)
        mov     rsi, rcx                                ; 0B8A _ 48: 89. CE
        mov     rdi, rax                                ; 0B8D _ 48: 89. C7
        call    list_size                               ; 0B90 _ E8, FFFFFB0A
        jmp     ?_079                                   ; 0B95 _ EB, 28

?_075:  mov     eax, dword [rel listlevel]              ; 0B97 _ 8B. 05, 00000000(rel)
        add     eax, 1                                  ; 0B9D _ 83. C0, 01
        mov     dword [rel listlevel], eax              ; 0BA0 _ 89. 05, 00000000(rel)
        jmp     ?_080                                   ; 0BA6 _ EB, 18

?_076:  mov     eax, dword [rel listlevel]              ; 0BA8 _ 8B. 05, 00000000(rel)
        add     eax, 1                                  ; 0BAE _ 83. C0, 01
        mov     dword [rel listlevel], eax              ; 0BB1 _ 89. 05, 00000000(rel)
        jmp     ?_080                                   ; 0BB7 _ EB, 07

?_077:  nop                                             ; 0BB9 _ 90
        jmp     ?_080                                   ; 0BBA _ EB, 04

?_078:  nop                                             ; 0BBC _ 90
        jmp     ?_080                                   ; 0BBD _ EB, 01

?_079:  nop                                             ; 0BBF _ 90
?_080:  leave                                           ; 0BC0 _ C9
        ret                                             ; 0BC1 _ C3

list_downlevel:; Local function
        push    rbp                                     ; 0BC2 _ 55
        mov     rbp, rsp                                ; 0BC3 _ 48: 89. E5
        mov     dword [rbp-4H], edi                     ; 0BC6 _ 89. 7D, FC
        mov     rax, qword [rel listfp]                 ; 0BC9 _ 48: 8B. 05, 00000000(rel)
        test    rax, rax                                ; 0BD0 _ 48: 85. C0
        jz      ?_084                                   ; 0BD3 _ 74, 41
        cmp     dword [rbp-4H], 4                       ; 0BD5 _ 83. 7D, FC, 04
        jz      ?_081                                   ; 0BD9 _ 74, 08
        cmp     dword [rbp-4H], 5                       ; 0BDB _ 83. 7D, FC, 05
        jz      ?_082                                   ; 0BDF _ 74, 13
        jmp     ?_083                                   ; 0BE1 _ EB, 22

?_081:  mov     eax, dword [rel suppress]               ; 0BE3 _ 8B. 05, 00000000(rel)
        and     eax, 0FFFFFFFEH                         ; 0BE9 _ 83. E0, FE
        mov     dword [rel suppress], eax               ; 0BEC _ 89. 05, 00000000(rel)
        jmp     ?_085                                   ; 0BF2 _ EB, 23

?_082:  mov     eax, dword [rel suppress]               ; 0BF4 _ 8B. 05, 00000000(rel)
        and     eax, 0FFFFFFFDH                         ; 0BFA _ 83. E0, FD
        mov     dword [rel suppress], eax               ; 0BFD _ 89. 05, 00000000(rel)
        jmp     ?_085                                   ; 0C03 _ EB, 12

?_083:  mov     eax, dword [rel listlevel]              ; 0C05 _ 8B. 05, 00000000(rel)
        sub     eax, 1                                  ; 0C0B _ 83. E8, 01
        mov     dword [rel listlevel], eax              ; 0C0E _ 89. 05, 00000000(rel)
        jmp     ?_085                                   ; 0C14 _ EB, 01

?_084:  nop                                             ; 0C16 _ 90
?_085:  pop     rbp                                     ; 0C17 _ 5D
        ret                                             ; 0C18 _ C3

list_error:; Local function
        push    rbp                                     ; 0C19 _ 55
        mov     rbp, rsp                                ; 0C1A _ 48: 89. E5
        sub     rsp, 224                                ; 0C1D _ 48: 81. EC, 000000E0
        mov     dword [rbp-0D4H], edi                   ; 0C24 _ 89. BD, FFFFFF2C
        mov     qword [rbp-0E0H], rsi                   ; 0C2A _ 48: 89. B5, FFFFFF20
        mov     qword [rbp-0A0H], rdx                   ; 0C31 _ 48: 89. 95, FFFFFF60
        mov     qword [rbp-98H], rcx                    ; 0C38 _ 48: 89. 8D, FFFFFF68
        mov     qword [rbp-90H], r8                     ; 0C3F _ 4C: 89. 85, FFFFFF70
        mov     qword [rbp-88H], r9                     ; 0C46 _ 4C: 89. 8D, FFFFFF78
        test    al, al                                  ; 0C4D _ 84. C0
        jz      ?_086                                   ; 0C4F _ 74, 20
        movaps  oword [rbp-80H], xmm0                   ; 0C51 _ 0F 29. 45, 80
        movaps  oword [rbp-70H], xmm1                   ; 0C55 _ 0F 29. 4D, 90
        movaps  oword [rbp-60H], xmm2                   ; 0C59 _ 0F 29. 55, A0
        movaps  oword [rbp-50H], xmm3                   ; 0C5D _ 0F 29. 5D, B0
        movaps  oword [rbp-40H], xmm4                   ; 0C61 _ 0F 29. 65, C0
        movaps  oword [rbp-30H], xmm5                   ; 0C65 _ 0F 29. 6D, D0
        movaps  oword [rbp-20H], xmm6                   ; 0C69 _ 0F 29. 75, E0
        movaps  oword [rbp-10H], xmm7                   ; 0C6D _ 0F 29. 7D, F0
?_086:
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        mov     rax, qword [fs:abs 28H]                 ; 0C71 _ 64 48: 8B. 04 25, 00000028
        mov     qword [rbp-0B8H], rax                   ; 0C7A _ 48: 89. 85, FFFFFF48
        xor     eax, eax                                ; 0C81 _ 31. C0
        mov     rax, qword [rel listfp]                 ; 0C83 _ 48: 8B. 05, 00000000(rel)
        test    rax, rax                                ; 0C8A _ 48: 85. C0
        je      ?_088                                   ; 0C8D _ 0F 84, 00000098
        mov     rax, qword [rel list_errors]            ; 0C93 _ 48: 8B. 05, 00000000(rel)
        test    rax, rax                                ; 0C9A _ 48: 85. C0
        jnz     ?_087                                   ; 0C9D _ 75, 11
        mov     edi, 0                                  ; 0C9F _ BF, 00000000
        call    strlist_alloc                           ; 0CA4 _ E8, 00000000(PLT r)
        mov     qword [rel list_errors], rax            ; 0CA9 _ 48: 89. 05, 00000000(rel)
?_087:  mov     dword [rbp-0D0H], 16                    ; 0CB0 _ C7. 85, FFFFFF30, 00000010
        mov     dword [rbp-0CCH], 48                    ; 0CBA _ C7. 85, FFFFFF34, 00000030
        lea     rax, [rbp+10H]                          ; 0CC4 _ 48: 8D. 45, 10
        mov     qword [rbp-0C8H], rax                   ; 0CC8 _ 48: 89. 85, FFFFFF38
        lea     rax, [rbp-0B0H]                         ; 0CCF _ 48: 8D. 85, FFFFFF50
        mov     qword [rbp-0C0H], rax                   ; 0CD6 _ 48: 89. 85, FFFFFF40
        mov     rax, qword [rel list_errors]            ; 0CDD _ 48: 8B. 05, 00000000(rel)
        lea     rdx, [rbp-0D0H]                         ; 0CE4 _ 48: 8D. 95, FFFFFF30
        mov     rcx, qword [rbp-0E0H]                   ; 0CEB _ 48: 8B. 8D, FFFFFF20
        mov     rsi, rcx                                ; 0CF2 _ 48: 89. CE
        mov     rdi, rax                                ; 0CF5 _ 48: 89. C7
        call    strlist_vprintf                         ; 0CF8 _ E8, 00000000(PLT r)
        mov     rax, qword [rel list_errors]            ; 0CFD _ 48: 8B. 05, 00000000(rel)
        mov     rdi, rax                                ; 0D04 _ 48: 89. C7
        call    strlist_tail                            ; 0D07 _ E8, FFFFF314
        mov     edx, dword [rbp-0D4H]                   ; 0D0C _ 8B. 95, FFFFFF2C
        mov     qword [rax+18H], rdx                    ; 0D12 _ 48: 89. 50, 18
        mov     eax, dword [rbp-0D4H]                   ; 0D16 _ 8B. 85, FFFFFF2C
        and     eax, 0FH                                ; 0D1C _ 83. E0, 0F
        cmp     eax, 11                                 ; 0D1F _ 83. F8, 0B
        jbe     ?_089                                   ; 0D22 _ 76, 08
        call    list_emit                               ; 0D24 _ E8, FFFFF3FC
        jmp     ?_089                                   ; 0D29 _ EB, 01

?_088:  nop                                             ; 0D2B _ 90
?_089:  mov     rax, qword [rbp-0B8H]                   ; 0D2C _ 48: 8B. 85, FFFFFF48
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        sub     rax, qword [fs:abs 28H]                 ; 0D33 _ 64 48: 2B. 04 25, 00000028
        jz      ?_090                                   ; 0D3C _ 74, 05
        call    __stack_chk_fail                        ; 0D3E _ E8, 00000000(PLT r)
?_090:  leave                                           ; 0D43 _ C9
        ret                                             ; 0D44 _ C3

list_set_offset:; Local function
        push    rbp                                     ; 0D45 _ 55
        mov     rbp, rsp                                ; 0D46 _ 48: 89. E5
        mov     qword [rbp-8H], rdi                     ; 0D49 _ 48: 89. 7D, F8
        mov     rax, qword [rbp-8H]                     ; 0D4D _ 48: 8B. 45, F8
        mov     dword [rel listoffset], eax             ; 0D51 _ 89. 05, 00000000(rel)
        nop                                             ; 0D57 _ 90
        pop     rbp                                     ; 0D58 _ 5D
        ret                                             ; 0D59 _ C3

list_update_options:; Function begin
        push    rbp                                     ; 0D5A _ 55
        mov     rbp, rsp                                ; 0D5B _ 48: 89. E5
        sub     rsp, 64                                 ; 0D5E _ 48: 83. EC, 40
        mov     qword [rbp-38H], rdi                    ; 0D62 _ 48: 89. 7D, C8
        mov     byte [rbp-39H], sil                     ; 0D66 _ 40: 88. 75, C7
        mov     qword [rbp-20H], -4                     ; 0D6A _ 48: C7. 45, E0, FFFFFFFC
        cmp     byte [rbp-39H], 0                       ; 0D72 _ 80. 7D, C7, 00
        jz      ?_091                                   ; 0D76 _ 74, 0A
        mov     qword [rbp-18H], 0                      ; 0D78 _ 48: C7. 45, E8, 00000000
        jmp     ?_092                                   ; 0D80 _ EB, 08

?_091:  mov     rax, qword [rbp-20H]                    ; 0D82 _ 48: 8B. 45, E0
        mov     qword [rbp-18H], rax                    ; 0D86 _ 48: 89. 45, E8
?_092:  cmp     byte [rbp-39H], 0                       ; 0D8A _ 80. 7D, C7, 00
        jz      ?_093                                   ; 0D8E _ 74, 07
        mov     eax, 0                                  ; 0D90 _ B8, 00000000
        jmp     ?_094                                   ; 0D95 _ EB, 05

?_093:  mov     eax, 2                                  ; 0D97 _ B8, 00000002
?_094:  lea     rdx, [rax*8]                            ; 0D9C _ 48: 8D. 14 C5, 00000000
        lea     rax, [rel list_plus_options]            ; 0DA4 _ 48: 8D. 05, 00000000(rel)
        add     rax, rdx                                ; 0DAB _ 48: 01. D0
        mov     qword [rbp-10H], rax                    ; 0DAE _ 48: 89. 45, F0
        jmp     ?_104                                   ; 0DB2 _ E9, 000000F3

?_095:  mov     qword [rbp-8H], 0                       ; 0DB7 _ 48: C7. 45, F8, 00000000
        movzx   eax, byte [rbp-21H]                     ; 0DBF _ 0F B6. 45, DF
        cmp     eax, 45                                 ; 0DC3 _ 83. F8, 2D
        jz      ?_098                                   ; 0DC6 _ 74, 4D
        cmp     eax, 45                                 ; 0DC8 _ 83. F8, 2D
        jg      ?_101                                   ; 0DCB _ 7F, 74
        cmp     eax, 43                                 ; 0DCD _ 83. F8, 2B
        jz      ?_096                                   ; 0DD0 _ 74, 11
        cmp     eax, 43                                 ; 0DD2 _ 83. F8, 2B
        jg      ?_101                                   ; 0DD5 _ 7F, 6A
        cmp     eax, 33                                 ; 0DD7 _ 83. F8, 21
        jz      ?_100                                   ; 0DDA _ 74, 5B
        cmp     eax, 42                                 ; 0DDC _ 83. F8, 2A
        jz      ?_099                                   ; 0DDF _ 74, 3E
        jmp     ?_101                                   ; 0DE1 _ EB, 5E

?_096:  mov     rax, qword [rbp-10H]                    ; 0DE3 _ 48: 8B. 45, F0
        mov     rax, qword [rax]                        ; 0DE7 _ 48: 8B. 00
        test    rax, rax                                ; 0DEA _ 48: 85. C0
        jz      ?_097                                   ; 0DED _ 74, 1C
        mov     rax, qword [rbp-10H]                    ; 0DEF _ 48: 8B. 45, F0
        lea     rdx, [rax+8H]                           ; 0DF3 _ 48: 8D. 50, 08
        mov     qword [rbp-10H], rdx                    ; 0DF7 _ 48: 89. 55, F0
        mov     rax, qword [rax]                        ; 0DFB _ 48: 8B. 00
        mov     esi, 1                                  ; 0DFE _ BE, 00000001
        mov     rdi, rax                                ; 0E03 _ 48: 89. C7
        call    list_update_options                     ; 0E06 _ E8, 00000000(PLT r)
?_097:  mov     qword [rbp-20H], -4                     ; 0E0B _ 48: C7. 45, E0, FFFFFFFC
        jmp     ?_103                                   ; 0E13 _ EB, 3E

?_098:  mov     qword [rbp-20H], 0                      ; 0E15 _ 48: C7. 45, E0, 00000000
        jmp     ?_103                                   ; 0E1D _ EB, 34

?_099:  movzx   eax, byte [rbp-39H]                     ; 0E1F _ 0F B6. 45, C7
        xor     eax, 01H                                ; 0E23 _ 83. F0, 01
        test    al, al                                  ; 0E26 _ 84. C0
        jz      ?_102                                   ; 0E28 _ 74, 28
        mov     rax, qword [rel cmdline_list_options]   ; 0E2A _ 48: 8B. 05, 00000000(rel)
        mov     qword [rbp-20H], rax                    ; 0E31 _ 48: 89. 45, E0
        jmp     ?_102                                   ; 0E35 _ EB, 1B

?_100:  mov     qword [rbp-8H], -4                      ; 0E37 _ 48: C7. 45, F8, FFFFFFFC
        jmp     ?_103                                   ; 0E3F _ EB, 12

?_101:  movzx   eax, byte [rbp-21H]                     ; 0E41 _ 0F B6. 45, DF
        mov     edi, eax                                ; 0E45 _ 89. C7
        call    list_option_mask                        ; 0E47 _ E8, FFFFF201
        mov     qword [rbp-8H], rax                     ; 0E4C _ 48: 89. 45, F8
        jmp     ?_103                                   ; 0E50 _ EB, 01

?_102:  nop                                             ; 0E52 _ 90
?_103:  cmp     qword [rbp-8H], 0                       ; 0E53 _ 48: 83. 7D, F8, 00
        jz      ?_104                                   ; 0E58 _ 74, 50
        mov     rax, qword [rbp-8H]                     ; 0E5A _ 48: 8B. 45, F8
        not     rax                                     ; 0E5E _ 48: F7. D0
        mov     rdx, rax                                ; 0E61 _ 48: 89. C2
        mov     rax, qword [rel list_options]           ; 0E64 _ 48: 8B. 05, 00000000(rel)
        and     rdx, rax                                ; 0E6B _ 48: 21. C2
        mov     rax, qword [rbp-20H]                    ; 0E6E _ 48: 8B. 45, E0
        and     rax, qword [rbp-8H]                     ; 0E72 _ 48: 23. 45, F8
        or      rax, rdx                                ; 0E76 _ 48: 09. D0
        mov     qword [rel list_options], rax           ; 0E79 _ 48: 89. 05, 00000000(rel)
        mov     rax, qword [rbp-8H]                     ; 0E80 _ 48: 8B. 45, F8
        not     rax                                     ; 0E84 _ 48: F7. D0
        mov     rdx, rax                                ; 0E87 _ 48: 89. C2
        mov     rax, qword [rel active_list_options]    ; 0E8A _ 48: 8B. 05, 00000000(rel)
        and     rdx, rax                                ; 0E91 _ 48: 21. C2
        mov     rax, qword [rbp-20H]                    ; 0E94 _ 48: 8B. 45, E0
        and     rax, qword [rbp-18H]                    ; 0E98 _ 48: 23. 45, E8
        and     rax, qword [rbp-8H]                     ; 0E9C _ 48: 23. 45, F8
        or      rax, rdx                                ; 0EA0 _ 48: 09. D0
        mov     qword [rel active_list_options], rax    ; 0EA3 _ 48: 89. 05, 00000000(rel)
?_104:  mov     rax, qword [rbp-38H]                    ; 0EAA _ 48: 8B. 45, C8
        lea     rdx, [rax+1H]                           ; 0EAE _ 48: 8D. 50, 01
        mov     qword [rbp-38H], rdx                    ; 0EB2 _ 48: 89. 55, C8
        movzx   eax, byte [rax]                         ; 0EB6 _ 0F B6. 00
        mov     byte [rbp-21H], al                      ; 0EB9 _ 88. 45, DF
        cmp     byte [rbp-21H], 0                       ; 0EBC _ 80. 7D, DF, 00
        jne     ?_095                                   ; 0EC0 _ 0F 85, FFFFFEF1
        cmp     byte [rbp-39H], 0                       ; 0EC6 _ 80. 7D, C7, 00
        jz      ?_105                                   ; 0ECA _ 74, 0E
        mov     rax, qword [rel list_options]           ; 0ECC _ 48: 8B. 05, 00000000(rel)
        mov     qword [rel cmdline_list_options], rax   ; 0ED3 _ 48: 89. 05, 00000000(rel)
?_105:  nop                                             ; 0EDA _ 90
        leave                                           ; 0EDB _ C9
        ret                                             ; 0EDC _ C3
; list_update_options End of function

list_pragma:; Function begin
        push    rbp                                     ; 0EDD _ 55
        mov     rbp, rsp                                ; 0EDE _ 48: 89. E5
        sub     rsp, 16                                 ; 0EE1 _ 48: 83. EC, 10
        mov     qword [rbp-8H], rdi                     ; 0EE5 _ 48: 89. 7D, F8
        mov     rax, qword [rbp-8H]                     ; 0EE9 _ 48: 8B. 45, F8
        mov     eax, dword [rax+20H]                    ; 0EED _ 8B. 40, 20
        cmp     eax, 62                                 ; 0EF0 _ 83. F8, 3E
        jnz     ?_106                                   ; 0EF3 _ 75, 1C
        mov     rax, qword [rbp-8H]                     ; 0EF5 _ 48: 8B. 45, F8
        mov     rax, qword [rax+18H]                    ; 0EF9 _ 48: 8B. 40, 18
        mov     esi, 0                                  ; 0EFD _ BE, 00000000
        mov     rdi, rax                                ; 0F02 _ 48: 89. C7
        call    list_update_options                     ; 0F05 _ E8, 00000000(PLT r)
        mov     eax, 1                                  ; 0F0A _ B8, 00000001
        jmp     ?_107                                   ; 0F0F _ EB, 05

?_106:  mov     eax, 0                                  ; 0F11 _ B8, 00000000
?_107:  leave                                           ; 0F16 _ C9
        ret                                             ; 0F17 _ C3
; list_pragma End of function


SECTION .data   align=1 noexec                          ; section number 2, data


SECTION .bss    align=32 noexec                         ; section number 3, bss

list_options:                                           ; qword
        resq    1                                       ; 0000

active_list_options:                                    ; qword
        resq    1                                       ; 0008

cmdline_list_options:                                   ; qword
        resq    1                                       ; 0010

user_nolist:                                            ; byte
        resb    8                                       ; 0018

listline:                                               ; byte
        resb    1020                                    ; 0020

?_108:                                                  ; byte
        resb    4                                       ; 041C

listlinep:                                              ; byte
        resb    8                                       ; 0420

list_errors:                                            ; qword
        resq    3                                       ; 0428

listdata:                                               ; byte
        resb    80                                      ; 0440

listoffset:                                             ; dword
        resd    1                                       ; 0490

listlineno:                                             ; dword
        resd    1                                       ; 0494

suppress: resd  1                                       ; 0498

listlevel:                                              ; dword
        resd    1                                       ; 049C

listlevel_e:                                            ; dword
        resd    2                                       ; 04A0

listfp: resq    1                                       ; 04A8


SECTION .rodata align=16 noexec                         ; section number 4, const

        db 62H, 64H, 65H, 66H, 46H, 6DH, 70H, 73H       ; 0000 _ bdefFmps
        db 00H, 63H, 74H, 00H, 00H, 00H, 00H, 00H       ; 0008 _ .ct.....

xdigit:                                                 ; byte
        db 30H, 31H, 32H, 33H, 34H, 35H, 36H, 37H       ; 0010 _ 01234567
        db 38H, 39H, 41H, 42H, 43H, 44H, 45H, 46H       ; 0018 _ 89ABCDEF
        db 00H                                          ; 0020 _ .

?_109:                                                  ; byte
        db 25H, 36H, 64H, 20H, 00H                      ; 0021 _ %6d .

?_110:                                                  ; byte
        db 25H, 30H, 38H, 58H, 20H, 25H, 2DH, 2AH       ; 0026 _ %08X %-*
        db 73H, 00H                                     ; 002E _ s.

?_111:                                                  ; byte
        db 00H                                          ; 0030 _ .

?_112:                                                  ; byte
        db 25H, 2AH, 73H, 00H                           ; 0031 _ %*s.

?_113:                                                  ; byte
        db 20H, 00H                                     ; 0035 _  .

?_114:                                                  ; byte
        db 25H, 73H, 3CH, 25H, 64H, 3EH, 00H            ; 0037 _ %s<%d>.

?_115:                                                  ; byte
        db 20H, 20H, 20H, 20H, 00H                      ; 003E _     .

?_116:                                                  ; byte
        db 20H, 25H, 73H, 00H                           ; 0043 _  %s.

?_117:                                                  ; byte
        db 25H, 36H, 64H, 20H, 20H, 20H, 20H, 20H       ; 0047 _ %6d     
        db 20H, 20H, 20H, 20H, 20H, 00H                 ; 004F _      .

?_118:                                                  ; byte
        db 20H, 25H, 73H, 3CH, 25H, 64H, 3EH, 00H       ; 0055 _  %s<%d>.

?_119:                                                  ; byte
        db 20H, 20H, 20H, 20H, 20H, 00H                 ; 005D _      .

?_120:                                                  ; byte
        db 20H, 20H, 25H, 73H, 0AH, 00H, 00H, 00H       ; 0063 _   %s....
        db 00H, 00H, 00H, 00H, 00H                      ; 006B _ .....

?_121:                                                  ; byte
        db 75H, 6EH, 61H, 62H, 6CH, 65H, 20H, 74H       ; 0070 _ unable t
        db 6FH, 20H, 6FH, 70H, 65H, 6EH, 20H, 6CH       ; 0078 _ o open l
        db 69H, 73H, 74H, 69H, 6EH, 67H, 20H, 66H       ; 0080 _ isting f
        db 69H, 6CH, 65H, 20H, 60H, 25H, 73H, 27H       ; 0088 _ ile `%s'
        db 00H                                          ; 0090 _ .

?_122:                                                  ; byte
        db 2EH, 2FH, 61H, 73H, 6DH, 2FH, 6CH, 69H       ; 0091 _ ./asm/li
        db 73H, 74H, 69H, 6EH, 67H, 2EH, 63H, 00H       ; 0099 _ sting.c.

?_123:                                                  ; byte
        db 73H, 69H, 7AH, 65H, 20H, 3CH, 3DH, 20H       ; 00A1 _ size <= 
        db 38H, 00H                                     ; 00A9 _ 8.

?_124:                                                  ; byte
        db 3CH, 25H, 73H, 20H, 25H, 6CH, 75H, 3EH       ; 00AB _ <%s %lu>
        db 00H                                          ; 00B3 _ .

?_125:                                                  ; byte
        db 3CH, 25H, 73H, 20H, 25H, 6CH, 58H, 68H       ; 00B4 _ <%s %lXh
        db 3EH, 00H                                     ; 00BC _ >.

?_126:                                                  ; byte
        db 7AH, 65H, 72H, 6FH, 00H                      ; 00BE _ zero.

?_127:                                                  ; byte
        db 6CH, 65H, 6EH, 00H                           ; 00C3 _ len.

?_128:                                                  ; byte
        db 5BH, 5DH, 00H                                ; 00C7 _ [].

?_129:                                                  ; byte
        db 28H, 29H, 00H                                ; 00CA _ ().

?_130:                                                  ; byte
        db 72H, 65H, 73H, 00H                           ; 00CD _ res.

?_131:                                                  ; byte
        db 2EH, 2EH, 2EH, 00H                           ; 00D1 _ ....

?_132:                                                  ; byte
        db 62H, 69H, 6EH, 00H                           ; 00D5 _ bin.

?_133:                                                  ; byte
        db 72H, 65H, 70H, 00H, 00H, 00H, 00H            ; 00D9 _ rep....

__func__.1:                                             ; byte
        db 6CH, 69H, 73H, 74H, 5FH, 61H, 64H, 64H       ; 00E0 _ list_add
        db 72H, 65H, 73H, 73H, 00H, 00H, 00H, 00H       ; 00E8 _ ress....

__func__.0:                                             ; byte
        db 6CH, 69H, 73H, 74H, 5FH, 6FH, 75H, 74H       ; 00F0 _ list_out
        db 70H, 75H, 74H, 00H                           ; 00F8 _ put.


SECTION .data.rel.ro.local align=32 noexec              ; section number 5, data

list_plus_options:                                      ; byte
        dq Unnamed_4_0                                  ; 0000 _ 0000000000000000 (d)
        dq Unnamed_4_0+9H                               ; 0008 _ 0000000000000000 (d)
        dq 0000000000000000H                            ; 0010 _ 0000000000000000 
        dq 0000000000000000H                            ; 0018 _ 0000000000000000 

nasm_list:                                              ; zword
        dq list_init                                    ; 0020 _ 0000000000000000 (d)
        dq list_cleanup                                 ; 0028 _ 0000000000000000 (d)
        dq list_output                                  ; 0030 _ 0000000000000000 (d)
        dq list_line                                    ; 0038 _ 0000000000000000 (d)
        dq list_uplevel                                 ; 0040 _ 0000000000000000 (d)
        dq list_downlevel                               ; 0048 _ 0000000000000000 (d)
        dq list_error                                   ; 0050 _ 0000000000000000 (d)
        dq list_set_offset                              ; 0058 _ 0000000000000000 (d)


SECTION .data.rel.local align=8 noexec                  ; section number 6, data

lfmt:   dq nasm_list                                    ; 0000 _ 0000000000000000 (d)


SECTION .note.gnu.property align=8 noexec               ; section number 7, const

        db 04H, 00H, 00H, 00H, 20H, 00H, 00H, 00H       ; 0000 _ .... ...
        db 05H, 00H, 00H, 00H, 47H, 4EH, 55H, 00H       ; 0008 _ ....GNU.
        db 02H, 00H, 01H, 0C0H, 04H, 00H, 00H, 00H      ; 0010 _ ........
        db 01H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0018 _ ........
        db 01H, 00H, 01H, 0C0H, 04H, 00H, 00H, 00H      ; 0020 _ ........
        db 09H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0028 _ ........


SECTION .eh_frame align=8 noexec                        ; section number 8, const

        db 14H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0000 _ ........
        db 01H, 7AH, 52H, 00H, 01H, 78H, 10H, 01H       ; 0008 _ .zR..x..
        db 1BH, 0CH, 07H, 08H, 90H, 01H, 00H, 00H       ; 0010 _ ........
        db 1CH, 00H, 00H, 00H, 1CH, 00H, 00H, 00H       ; 0018 _ ........
        dd strlist_head-$-20H                           ; 0020 _ 00000000 (rel)
        dd 00000020H, 100E4100H                         ; 0024 _ 32 269369600 
        dd 0D430286H, 070C5B06H                         ; 002C _ 222495366 118250246 
        dd 00000008H, 0000001CH                         ; 0034 _ 8 28 
        dd 0000003CH                                    ; 003C _ 60 
        dd strlist_head-$-20H                           ; 0040 _ 00000000 (rel)
        dd 0000002DH, 100E4100H                         ; 0044 _ 45 269369600 
        dd 0D430286H, 070C6806H                         ; 004C _ 222495366 118253574 
        dd 00000008H, 0000001CH                         ; 0054 _ 8 28 
        dd 0000005CH                                    ; 005C _ 92 
        dd strlist_head-$-13H                           ; 0060 _ 00000000 (rel)
        dd 0000006DH, 100E4100H                         ; 0064 _ 109 269369600 
        dd 0D430286H, 0C680206H                         ; 006C _ 222495366 208142854 
        dd 00000807H, 0000001CH                         ; 0074 _ 2055 28 
        dd 0000007CH                                    ; 007C _ 124 
        dd strlist_head-$+3AH                           ; 0080 _ 00000000 (rel)
        dd 00000032H, 100E4100H                         ; 0084 _ 50 269369600 
        dd 0D430286H, 070C6D06H                         ; 008C _ 222495366 118254854 
        dd 00000008H, 0000001CH                         ; 0094 _ 8 28 
        dd 0000009CH                                    ; 009C _ 156 
        dd strlist_head-$+4CH                           ; 00A0 _ 00000000 (rel)
        dd 00000039H, 100E4100H                         ; 00A4 _ 57 269369600 
        dd 0D430286H, 070C7406H                         ; 00AC _ 222495366 118256646 
        dd 00000008H, 0000001CH                         ; 00B4 _ 8 28 
        dd 000000BCH                                    ; 00BC _ 188 
        dd strlist_head-$+65H                           ; 00C0 _ 00000000 (rel)
        dd 000002B2H, 100E4100H                         ; 00C4 _ 690 269369600 
        dd 0D430286H, 02AD0306H                         ; 00CC _ 222495366 44892934 
        dd 0008070CH, 0000001CH                         ; 00D4 _ 526092 28 
        dd 000000DCH                                    ; 00DC _ 220 
        dd strlist_head-$+2F7H                          ; 00E0 _ 00000000 (rel)
        dd 0000003FH, 100E4100H                         ; 00E4 _ 63 269369600 
        dd 0D430286H, 070C7A06H                         ; 00EC _ 222495366 118258182 
        dd 00000008H, 0000001CH                         ; 00F4 _ 8 28 
        dd 000000FCH                                    ; 00FC _ 252 
        dd strlist_head-$+316H                          ; 0100 _ 00000000 (rel)
        dd 000000E4H, 100E4100H                         ; 0104 _ 228 269369600 
        dd 0D430286H, 0CDF0206H                         ; 010C _ 222495366 215941638 
        dd 00000807H, 00000020H                         ; 0114 _ 2055 32 
        dd 0000011CH                                    ; 011C _ 284 
        dd strlist_head-$+3DAH                          ; 0120 _ 00000000 (rel)
        dd 00000090H, 100E4100H                         ; 0124 _ 144 269369600 
        dd 0D430286H, 03834506H                         ; 012C _ 222495366 58934534 
        dd 070C8602H, 00000008H                         ; 0134 _ 118261250 8 
        dd 0000001CH, 00000140H                         ; 013C _ 28 320 
        dd strlist_head-$+446H                          ; 0144 _ 00000000 (rel)
        dd 00000115H, 100E4100H                         ; 0148 _ 277 269369600 
        dd 0D430286H, 01100306H                         ; 0150 _ 222495366 17826566 
        dd 0008070CH, 0000001CH                         ; 0158 _ 526092 28 
        dd 00000160H                                    ; 0160 _ 352 
        dd strlist_head-$+53BH                          ; 0164 _ 00000000 (rel)
        dd 00000098H, 100E4100H                         ; 0168 _ 152 269369600 
        dd 0D430286H, 0C930206H                         ; 0170 _ 222495366 210960902 
        dd 00000807H, 0000001CH                         ; 0178 _ 2055 28 
        dd 00000180H                                    ; 0180 _ 384 
        dd strlist_head-$+5B3H                          ; 0184 _ 00000000 (rel)
        dd 00000308H, 100E4100H                         ; 0188 _ 776 269369600 
        dd 0D430286H, 03030306H                         ; 0190 _ 222495366 50529030 
        dd 0008070CH, 0000001CH                         ; 0198 _ 526092 28 
        dd 000001A0H                                    ; 01A0 _ 416 
        dd strlist_head-$+89BH                          ; 01A4 _ 00000000 (rel)
        dd 00000091H, 100E4100H                         ; 01A8 _ 145 269369600 
        dd 0D430286H, 0C8C0206H                         ; 01B0 _ 222495366 210502150 
        dd 00000807H, 0000001CH                         ; 01B8 _ 2055 28 
        dd 000001C0H                                    ; 01C0 _ 448 
        dd strlist_head-$+90CH                          ; 01C4 _ 00000000 (rel)
        dd 000000F2H, 100E4100H                         ; 01C8 _ 242 269369600 
        dd 0D430286H, 0CED0206H                         ; 01D0 _ 222495366 216859142 
        dd 00000807H, 0000001CH                         ; 01D8 _ 2055 28 
        dd 000001E0H                                    ; 01E0 _ 480 
        dd strlist_head-$+9DEH                          ; 01E4 _ 00000000 (rel)
        dd 00000057H, 100E4100H                         ; 01E8 _ 87 269369600 
        dd 0D430286H, 0C520206H                         ; 01F0 _ 222495366 206701062 
        dd 00000807H, 0000001CH                         ; 01F8 _ 2055 28 
        dd 00000200H                                    ; 0200 _ 512 
        dd strlist_head-$+0A15H                         ; 0204 _ 00000000 (rel)
        dd 0000012CH, 100E4100H                         ; 0208 _ 300 269369600 
        dd 0D430286H, 01270306H                         ; 0210 _ 222495366 19333894 
        dd 0008070CH, 0000001CH                         ; 0218 _ 526092 28 
        dd 00000220H                                    ; 0220 _ 544 
        dd strlist_head-$+0B21H                         ; 0224 _ 00000000 (rel)
        dd 00000015H, 100E4100H                         ; 0228 _ 21 269369600 
        dd 0D430286H, 070C5006H                         ; 0230 _ 222495366 118247430 
        dd 00000008H, 0000001CH                         ; 0238 _ 8 28 
        dd 00000240H                                    ; 0240 _ 576 
        dd strlist_head-$+0B16H                         ; 0244 _ 00000000 (rel)
        dd 00000183H, 100E4100H                         ; 0248 _ 387 269369600 
        dd 0D430286H, 017E0306H                         ; 0250 _ 222495366 25035526 
        dd 0008070CH, 00000020H                         ; 0258 _ 526092 32 
        dd 00000260H                                    ; 0260 _ 608 
        dd strlist_head-$+0C79H                         ; 0264 _ 00000000 (rel)
        dd 0000003BH, 100E4100H                         ; 0268 _ 59 269369600 
        dd 0D430286H, 070C7606H                         ; 0270 _ 222495366 118257158 
        dd 00000008H, 00000000H                         ; 0278 _ 8 0 


