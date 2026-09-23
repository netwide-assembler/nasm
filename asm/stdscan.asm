; Disassembly of file: /tmp/tmp.Whpo2gFYuW.o
; Wed Sep 23 14:43:27 2026
; Type: ELF64
; Syntax: NASM
; Instruction set: 80386, x64

default rel

global stdscan_set: function
global stdscan_get: function
global stdscan_tell: function
global stdscan_reset: function
global stdscan_cleanup: function
global stdscan_pushback: function
global stdscan: function

extern __stack_chk_fail                                 ; near
extern nasm_unquote                                     ; near
extern readnum                                          ; near
extern warn_dollar_hex                                  ; near
extern globl                                            ; byte
extern nasm_warn_                                       ; near
extern memset                                           ; near
extern nasm_token_hash                                  ; near
extern nasm_nonfatal                                    ; near
extern strchr                                           ; near
extern nasm_skip_spaces                                 ; near
extern nasm_zalloc                                      ; near
extern memcpy                                           ; near
extern nasm_realloc                                     ; near
extern nasm_malloc                                      ; near
extern nasm_free                                        ; near
extern warning_state                                    ; byte
extern erropt                                           ; dword
extern nasm_reg_flags                                   ; byte
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

nasm_isdigit:; Local function
        push    rbp                                     ; 002D _ 55
        mov     rbp, rsp                                ; 002E _ 48: 89. E5
        sub     rsp, 8                                  ; 0031 _ 48: 83. EC, 08
        mov     byte [rbp-1H], dil                      ; 0035 _ 40: 88. 7D, FF
        movzx   eax, byte [rbp-1H]                      ; 0039 _ 0F B6. 45, FF
        movzx   eax, al                                 ; 003D _ 0F B6. C0
        mov     esi, 32                                 ; 0040 _ BE, 00000020
        mov     edi, eax                                ; 0045 _ 89. C7
        call    nasm_ctype                              ; 0047 _ E8, FFFFFFB4
        leave                                           ; 004C _ C9
        ret                                             ; 004D _ C3

nasm_isidstart:; Local function
        push    rbp                                     ; 004E _ 55
        mov     rbp, rsp                                ; 004F _ 48: 89. E5
        sub     rsp, 8                                  ; 0052 _ 48: 83. EC, 08
        mov     byte [rbp-1H], dil                      ; 0056 _ 40: 88. 7D, FF
        movzx   eax, byte [rbp-1H]                      ; 005A _ 0F B6. 45, FF
        movzx   eax, al                                 ; 005E _ 0F B6. C0
        mov     esi, 256                                ; 0061 _ BE, 00000100
        mov     edi, eax                                ; 0066 _ 89. C7
        call    nasm_ctype                              ; 0068 _ E8, FFFFFF93
        leave                                           ; 006D _ C9
        ret                                             ; 006E _ C3

nasm_isidchar:; Local function
        push    rbp                                     ; 006F _ 55
        mov     rbp, rsp                                ; 0070 _ 48: 89. E5
        sub     rsp, 8                                  ; 0073 _ 48: 83. EC, 08
        mov     byte [rbp-1H], dil                      ; 0077 _ 40: 88. 7D, FF
        movzx   eax, byte [rbp-1H]                      ; 007B _ 0F B6. 45, FF
        movzx   eax, al                                 ; 007F _ 0F B6. C0
        mov     esi, 128                                ; 0082 _ BE, 00000080
        mov     edi, eax                                ; 0087 _ 89. C7
        call    nasm_ctype                              ; 0089 _ E8, FFFFFF72
        leave                                           ; 008E _ C9
        ret                                             ; 008F _ C3

nasm_isbrcchar:; Local function
        push    rbp                                     ; 0090 _ 55
        mov     rbp, rsp                                ; 0091 _ 48: 89. E5
        sub     rsp, 8                                  ; 0094 _ 48: 83. EC, 08
        mov     byte [rbp-1H], dil                      ; 0098 _ 40: 88. 7D, FF
        movzx   eax, byte [rbp-1H]                      ; 009C _ 0F B6. 45, FF
        movzx   eax, al                                 ; 00A0 _ 0F B6. C0
        mov     esi, 640                                ; 00A3 _ BE, 00000280
        mov     edi, eax                                ; 00A8 _ 89. C7
        call    nasm_ctype                              ; 00AA _ E8, FFFFFF51
        leave                                           ; 00AF _ C9
        ret                                             ; 00B0 _ C3

nasm_isnumstart:; Local function
        push    rbp                                     ; 00B1 _ 55
        mov     rbp, rsp                                ; 00B2 _ 48: 89. E5
        sub     rsp, 8                                  ; 00B5 _ 48: 83. EC, 08
        mov     byte [rbp-1H], dil                      ; 00B9 _ 40: 88. 7D, FF
        movzx   eax, byte [rbp-1H]                      ; 00BD _ 0F B6. 45, FF
        movzx   eax, al                                 ; 00C1 _ 0F B6. C0
        mov     esi, 1056                               ; 00C4 _ BE, 00000420
        mov     edi, eax                                ; 00C9 _ 89. C7
        call    nasm_ctype                              ; 00CB _ E8, FFFFFF30
        leave                                           ; 00D0 _ C9
        ret                                             ; 00D1 _ C3

nasm_isnumchar:; Local function
        push    rbp                                     ; 00D2 _ 55
        mov     rbp, rsp                                ; 00D3 _ 48: 89. E5
        sub     rsp, 8                                  ; 00D6 _ 48: 83. EC, 08
        mov     byte [rbp-1H], dil                      ; 00DA _ 40: 88. 7D, FF
        movzx   eax, byte [rbp-1H]                      ; 00DE _ 0F B6. 45, FF
        movzx   eax, al                                 ; 00E2 _ 0F B6. C0
        mov     esi, 2104                               ; 00E5 _ BE, 00000838
        mov     edi, eax                                ; 00EA _ 89. C7
        call    nasm_ctype                              ; 00EC _ E8, FFFFFF0F
        leave                                           ; 00F1 _ C9
        ret                                             ; 00F2 _ C3

is_class:; Local function
        push    rbp                                     ; 00F3 _ 55
        mov     rbp, rsp                                ; 00F4 _ 48: 89. E5
        mov     qword [rbp-8H], rdi                     ; 00F7 _ 48: 89. 7D, F8
        mov     qword [rbp-10H], rsi                    ; 00FB _ 48: 89. 75, F0
        mov     rax, qword [rbp-10H]                    ; 00FF _ 48: 8B. 45, F0
        not     rax                                     ; 0103 _ 48: F7. D0
        and     rax, qword [rbp-8H]                     ; 0106 _ 48: 23. 45, F8
        test    rax, rax                                ; 010A _ 48: 85. C0
        sete    al                                      ; 010D _ 0F 94. C0
        pop     rbp                                     ; 0110 _ 5D
        ret                                             ; 0111 _ C3

is_register:; Local function
        push    rbp                                     ; 0112 _ 55
        mov     rbp, rsp                                ; 0113 _ 48: 89. E5
        mov     dword [rbp-4H], edi                     ; 0116 _ 89. 7D, FC
        cmp     dword [rbp-4H], 0                       ; 0119 _ 83. 7D, FC, 00
        jle     ?_001                                   ; 011D _ 7E, 10
        cmp     dword [rbp-4H], 344                     ; 011F _ 81. 7D, FC, 00000158
        jg      ?_001                                   ; 0126 _ 7F, 07
        mov     eax, 1                                  ; 0128 _ B8, 00000001
        jmp     ?_002                                   ; 012D _ EB, 05

?_001:  mov     eax, 0                                  ; 012F _ B8, 00000000
?_002:  and     eax, 01H                                ; 0134 _ 83. E0, 01
        pop     rbp                                     ; 0137 _ 5D
        ret                                             ; 0138 _ C3

is_reg_class:; Local function
        push    rbp                                     ; 0139 _ 55
        mov     rbp, rsp                                ; 013A _ 48: 89. E5
        sub     rsp, 16                                 ; 013D _ 48: 83. EC, 10
        mov     qword [rbp-8H], rdi                     ; 0141 _ 48: 89. 7D, F8
        mov     dword [rbp-0CH], esi                    ; 0145 _ 89. 75, F4
        mov     eax, dword [rbp-0CH]                    ; 0148 _ 8B. 45, F4
        mov     edi, eax                                ; 014B _ 89. C7
        call    is_register                             ; 014D _ E8, FFFFFFC0
        xor     eax, 01H                                ; 0152 _ 83. F0, 01
        test    al, al                                  ; 0155 _ 84. C0
        jz      ?_003                                   ; 0157 _ 74, 07
        mov     eax, 0                                  ; 0159 _ B8, 00000000
        jmp     ?_004                                   ; 015E _ EB, 27

?_003:  mov     eax, dword [rbp-0CH]                    ; 0160 _ 8B. 45, F4
        cdqe                                            ; 0163 _ 48: 98
        lea     rdx, [rax*8]                            ; 0165 _ 48: 8D. 14 C5, 00000000
        lea     rax, [rel nasm_reg_flags]               ; 016D _ 48: 8D. 05, 00000000(rel)
        mov     rdx, qword [rdx+rax]                    ; 0174 _ 48: 8B. 14 02
        mov     rax, qword [rbp-8H]                     ; 0178 _ 48: 8B. 45, F8
        mov     rsi, rdx                                ; 017C _ 48: 89. D6
        mov     rdi, rax                                ; 017F _ 48: 89. C7
        call    is_class                                ; 0182 _ E8, FFFFFF6C
?_004:  leave                                           ; 0187 _ C9
        ret                                             ; 0188 _ C3

warn_active:; Local function
        push    rbp                                     ; 0189 _ 55
        mov     rbp, rsp                                ; 018A _ 48: 89. E5
        mov     dword [rbp-4H], edi                     ; 018D _ 89. 7D, FC
        mov     eax, dword [rel erropt+0CH]             ; 0190 _ 8B. 05, 00000000(rel)
        and     eax, dword [rbp-4H]                     ; 0196 _ 23. 45, FC
        test    eax, eax                                ; 0199 _ 85. C0
        jz      ?_005                                   ; 019B _ 74, 07
        mov     eax, 0                                  ; 019D _ B8, 00000000
        jmp     ?_006                                   ; 01A2 _ EB, 16

?_005:  mov     eax, dword [rbp-4H]                     ; 01A4 _ 8B. 45, FC
        shr     eax, 16                                 ; 01A7 _ C1. E8, 10
        mov     edx, eax                                ; 01AA _ 89. C2
        lea     rax, [rel warning_state]                ; 01AC _ 48: 8D. 05, 00000000(rel)
        movzx   eax, byte [rdx+rax]                     ; 01B3 _ 0F B6. 04 02
        and     eax, 01H                                ; 01B7 _ 83. E0, 01
?_006:  pop     rbp                                     ; 01BA _ 5D
        ret                                             ; 01BB _ C3

stdscan_set:; Function begin
        push    rbp                                     ; 01BC _ 55
        mov     rbp, rsp                                ; 01BD _ 48: 89. E5
        mov     qword [rbp-8H], rdi                     ; 01C0 _ 48: 89. 7D, F8
        mov     rcx, qword [rbp-8H]                     ; 01C4 _ 48: 8B. 4D, F8
        mov     rax, qword [rcx]                        ; 01C8 _ 48: 8B. 01
        mov     rdx, qword [rcx+8H]                     ; 01CB _ 48: 8B. 51, 08
        mov     qword [rel scan], rax                   ; 01CF _ 48: 89. 05, 00000000(rel)
        mov     qword [rel ?_083], rdx                  ; 01D6 _ 48: 89. 15, 00000000(rel)
        mov     rax, qword [rcx+10H]                    ; 01DD _ 48: 8B. 41, 10
        mov     qword [rel ?_084], rax                  ; 01E1 _ 48: 89. 05, 00000000(rel)
        nop                                             ; 01E8 _ 90
        pop     rbp                                     ; 01E9 _ 5D
        ret                                             ; 01EA _ C3
; stdscan_set End of function

stdscan_get:; Function begin
        push    rbp                                     ; 01EB _ 55
        mov     rbp, rsp                                ; 01EC _ 48: 89. E5
        sub     rsp, 16                                 ; 01EF _ 48: 83. EC, 10
        mov     edi, 24                                 ; 01F3 _ BF, 00000018
        call    stdscan_alloc                           ; 01F8 _ E8, 0000010E
        mov     qword [rbp-8H], rax                     ; 01FD _ 48: 89. 45, F8
        mov     rcx, qword [rbp-8H]                     ; 0201 _ 48: 8B. 4D, F8
        mov     rax, qword [rel scan]                   ; 0205 _ 48: 8B. 05, 00000000(rel)
        mov     rdx, qword [rel ?_083]                  ; 020C _ 48: 8B. 15, 00000000(rel)
        mov     qword [rcx], rax                        ; 0213 _ 48: 89. 01
        mov     qword [rcx+8H], rdx                     ; 0216 _ 48: 89. 51, 08
        mov     rax, qword [rel ?_084]                  ; 021A _ 48: 8B. 05, 00000000(rel)
        mov     qword [rcx+10H], rax                    ; 0221 _ 48: 89. 41, 10
        mov     rax, qword [rbp-8H]                     ; 0225 _ 48: 8B. 45, F8
        leave                                           ; 0229 _ C9
        ret                                             ; 022A _ C3
; stdscan_get End of function

stdscan_tell:; Function begin
        push    rbp                                     ; 022B _ 55
        mov     rbp, rsp                                ; 022C _ 48: 89. E5
        mov     rax, qword [rel scan]                   ; 022F _ 48: 8B. 05, 00000000(rel)
        pop     rbp                                     ; 0236 _ 5D
        ret                                             ; 0237 _ C3
; stdscan_tell End of function

stdscan_pop:; Local function
        push    rbp                                     ; 0238 _ 55
        mov     rbp, rsp                                ; 0239 _ 48: 89. E5
        mov     rax, qword [rel stdscan_tempstorage]    ; 023C _ 48: 8B. 05, 00000000(rel)
        mov     edx, dword [rel stdscan_templen]        ; 0243 _ 8B. 15, 00000000(rel)
        sub     edx, 1                                  ; 0249 _ 83. EA, 01
        mov     dword [rel stdscan_templen], edx        ; 024C _ 89. 15, 00000000(rel)
        mov     edx, dword [rel stdscan_templen]        ; 0252 _ 8B. 15, 00000000(rel)
        movsxd  rdx, edx                                ; 0258 _ 48: 63. D2
        shl     rdx, 3                                  ; 025B _ 48: C1. E2, 03
        add     rax, rdx                                ; 025F _ 48: 01. D0
        mov     rax, qword [rax]                        ; 0262 _ 48: 8B. 00
        mov     rdi, rax                                ; 0265 _ 48: 89. C7
        call    nasm_free                               ; 0268 _ E8, 00000000(PLT r)
        nop                                             ; 026D _ 90
        pop     rbp                                     ; 026E _ 5D
        ret                                             ; 026F _ C3

stdscan_pushback_pop:; Local function
        push    rbp                                     ; 0270 _ 55
        mov     rbp, rsp                                ; 0271 _ 48: 89. E5
        sub     rsp, 16                                 ; 0274 _ 48: 83. EC, 10
        mov     rax, qword [rel ?_083]                  ; 0278 _ 48: 8B. 05, 00000000(rel)
        mov     rax, qword [rax]                        ; 027F _ 48: 8B. 00
        mov     qword [rbp-8H], rax                     ; 0282 _ 48: 89. 45, F8
        mov     rax, qword [rel ?_083]                  ; 0286 _ 48: 8B. 05, 00000000(rel)
        mov     rdi, rax                                ; 028D _ 48: 89. C7
        call    nasm_free                               ; 0290 _ E8, 00000000(PLT r)
        mov     rax, qword [rbp-8H]                     ; 0295 _ 48: 8B. 45, F8
        mov     qword [rel ?_083], rax                  ; 0299 _ 48: 89. 05, 00000000(rel)
        nop                                             ; 02A0 _ 90
        leave                                           ; 02A1 _ C9
        ret                                             ; 02A2 _ C3

stdscan_reset:; Function begin
        push    rbp                                     ; 02A3 _ 55
        mov     rbp, rsp                                ; 02A4 _ 48: 89. E5
        sub     rsp, 16                                 ; 02A7 _ 48: 83. EC, 10
        mov     qword [rbp-8H], rdi                     ; 02AB _ 48: 89. 7D, F8
        jmp     ?_008                                   ; 02AF _ EB, 05

?_007:  call    stdscan_pop                             ; 02B1 _ E8, FFFFFF82
?_008:  mov     eax, dword [rel stdscan_templen]        ; 02B6 _ 8B. 05, 00000000(rel)
        test    eax, eax                                ; 02BC _ 85. C0
        jg      ?_007                                   ; 02BE _ 7F, F1
        jmp     ?_010                                   ; 02C0 _ EB, 05

?_009:  call    stdscan_pushback_pop                    ; 02C2 _ E8, FFFFFFA9
?_010:  mov     rax, qword [rel ?_083]                  ; 02C7 _ 48: 8B. 05, 00000000(rel)
        test    rax, rax                                ; 02CE _ 48: 85. C0
        jnz     ?_009                                   ; 02D1 _ 75, EF
        mov     rax, qword [rbp-8H]                     ; 02D3 _ 48: 8B. 45, F8
        mov     qword [rel scan], rax                   ; 02D7 _ 48: 89. 05, 00000000(rel)
        mov     dword [rel ?_084], 0                    ; 02DE _ C7. 05, 00000000(rel), 00000000
        nop                                             ; 02E8 _ 90
        leave                                           ; 02E9 _ C9
        ret                                             ; 02EA _ C3
; stdscan_reset End of function

stdscan_cleanup:; Function begin
        push    rbp                                     ; 02EB _ 55
        mov     rbp, rsp                                ; 02EC _ 48: 89. E5
        mov     edi, 0                                  ; 02EF _ BF, 00000000
        call    stdscan_reset                           ; 02F4 _ E8, 00000000(PLT r)
        mov     rax, qword [rel stdscan_tempstorage]    ; 02F9 _ 48: 8B. 05, 00000000(rel)
        mov     rdi, rax                                ; 0300 _ 48: 89. C7
        call    nasm_free                               ; 0303 _ E8, 00000000(PLT r)
        nop                                             ; 0308 _ 90
        pop     rbp                                     ; 0309 _ 5D
        ret                                             ; 030A _ C3
; stdscan_cleanup End of function

stdscan_alloc:; Local function
        push    rbp                                     ; 030B _ 55
        mov     rbp, rsp                                ; 030C _ 48: 89. E5
        sub     rsp, 32                                 ; 030F _ 48: 83. EC, 20
        mov     qword [rbp-18H], rdi                    ; 0313 _ 48: 89. 7D, E8
        mov     rax, qword [rbp-18H]                    ; 0317 _ 48: 8B. 45, E8
        mov     rdi, rax                                ; 031B _ 48: 89. C7
        call    nasm_malloc                             ; 031E _ E8, 00000000(PLT r)
        mov     qword [rbp-8H], rax                     ; 0323 _ 48: 89. 45, F8
        mov     edx, dword [rel stdscan_templen]        ; 0327 _ 8B. 15, 00000000(rel)
        mov     eax, dword [rel stdscan_tempsize]       ; 032D _ 8B. 05, 00000000(rel)
        cmp     edx, eax                                ; 0333 _ 39. C2
        jl      ?_011                                   ; 0335 _ 7C, 3A
        mov     eax, dword [rel stdscan_tempsize]       ; 0337 _ 8B. 05, 00000000(rel)
        add     eax, 256                                ; 033D _ 05, 00000100
        mov     dword [rel stdscan_tempsize], eax       ; 0342 _ 89. 05, 00000000(rel)
        mov     eax, dword [rel stdscan_tempsize]       ; 0348 _ 8B. 05, 00000000(rel)
        cdqe                                            ; 034E _ 48: 98
        lea     rdx, [rax*8]                            ; 0350 _ 48: 8D. 14 C5, 00000000
        mov     rax, qword [rel stdscan_tempstorage]    ; 0358 _ 48: 8B. 05, 00000000(rel)
        mov     rsi, rdx                                ; 035F _ 48: 89. D6
        mov     rdi, rax                                ; 0362 _ 48: 89. C7
        call    nasm_realloc                            ; 0365 _ E8, 00000000(PLT r)
        mov     qword [rel stdscan_tempstorage], rax    ; 036A _ 48: 89. 05, 00000000(rel)
?_011:  mov     rcx, qword [rel stdscan_tempstorage]    ; 0371 _ 48: 8B. 0D, 00000000(rel)
        mov     eax, dword [rel stdscan_templen]        ; 0378 _ 8B. 05, 00000000(rel)
        lea     edx, [rax+1H]                           ; 037E _ 8D. 50, 01
        mov     dword [rel stdscan_templen], edx        ; 0381 _ 89. 15, 00000000(rel)
        cdqe                                            ; 0387 _ 48: 98
        shl     rax, 3                                  ; 0389 _ 48: C1. E0, 03
        lea     rdx, [rcx+rax]                          ; 038D _ 48: 8D. 14 01
        mov     rax, qword [rbp-8H]                     ; 0391 _ 48: 8B. 45, F8
        mov     qword [rdx], rax                        ; 0395 _ 48: 89. 02
        mov     rax, qword [rbp-8H]                     ; 0398 _ 48: 8B. 45, F8
        leave                                           ; 039C _ C9
        ret                                             ; 039D _ C3

stdscan_copy:; Local function
        push    rbp                                     ; 039E _ 55
        mov     rbp, rsp                                ; 039F _ 48: 89. E5
        sub     rsp, 32                                 ; 03A2 _ 48: 83. EC, 20
        mov     qword [rbp-18H], rdi                    ; 03A6 _ 48: 89. 7D, E8
        mov     dword [rbp-1CH], esi                    ; 03AA _ 89. 75, E4
        mov     eax, dword [rbp-1CH]                    ; 03AD _ 8B. 45, E4
        add     eax, 1                                  ; 03B0 _ 83. C0, 01
        cdqe                                            ; 03B3 _ 48: 98
        mov     rdi, rax                                ; 03B5 _ 48: 89. C7
        call    stdscan_alloc                           ; 03B8 _ E8, FFFFFF4E
        mov     qword [rbp-8H], rax                     ; 03BD _ 48: 89. 45, F8
        mov     eax, dword [rbp-1CH]                    ; 03C1 _ 8B. 45, E4
        movsxd  rdx, eax                                ; 03C4 _ 48: 63. D0
        mov     rcx, qword [rbp-18H]                    ; 03C7 _ 48: 8B. 4D, E8
        mov     rax, qword [rbp-8H]                     ; 03CB _ 48: 8B. 45, F8
        mov     rsi, rcx                                ; 03CF _ 48: 89. CE
        mov     rdi, rax                                ; 03D2 _ 48: 89. C7
        call    memcpy                                  ; 03D5 _ E8, 00000000(PLT r)
        mov     eax, dword [rbp-1CH]                    ; 03DA _ 8B. 45, E4
        movsxd  rdx, eax                                ; 03DD _ 48: 63. D0
        mov     rax, qword [rbp-8H]                     ; 03E0 _ 48: 8B. 45, F8
        add     rax, rdx                                ; 03E4 _ 48: 01. D0
        mov     byte [rax], 0                           ; 03E7 _ C6. 00, 00
        mov     rax, qword [rbp-8H]                     ; 03EA _ 48: 8B. 45, F8
        leave                                           ; 03EE _ C9
        ret                                             ; 03EF _ C3

stdscan_pushback:; Function begin
        push    rbp                                     ; 03F0 _ 55
        mov     rbp, rsp                                ; 03F1 _ 48: 89. E5
        push    rbx                                     ; 03F4 _ 53
        sub     rsp, 40                                 ; 03F5 _ 48: 83. EC, 28
        mov     qword [rbp-28H], rdi                    ; 03F9 _ 48: 89. 7D, D8
        mov     edi, 56                                 ; 03FD _ BF, 00000038
        call    nasm_zalloc                             ; 0402 _ E8, 00000000(PLT r)
        mov     qword [rbp-18H], rax                    ; 0407 _ 48: 89. 45, E8
        mov     rax, qword [rbp-18H]                    ; 040B _ 48: 8B. 45, E8
        mov     rdx, qword [rbp-28H]                    ; 040F _ 48: 8B. 55, D8
        mov     rcx, qword [rdx]                        ; 0413 _ 48: 8B. 0A
        mov     rbx, qword [rdx+8H]                     ; 0416 _ 48: 8B. 5A, 08
        mov     qword [rax+8H], rcx                     ; 041A _ 48: 89. 48, 08
        mov     qword [rax+10H], rbx                    ; 041E _ 48: 89. 58, 10
        mov     rcx, qword [rdx+10H]                    ; 0422 _ 48: 8B. 4A, 10
        mov     rbx, qword [rdx+18H]                    ; 0426 _ 48: 8B. 5A, 18
        mov     qword [rax+18H], rcx                    ; 042A _ 48: 89. 48, 18
        mov     qword [rax+20H], rbx                    ; 042E _ 48: 89. 58, 20
        mov     rcx, qword [rdx+20H]                    ; 0432 _ 48: 8B. 4A, 20
        mov     rbx, qword [rdx+28H]                    ; 0436 _ 48: 8B. 5A, 28
        mov     qword [rax+28H], rcx                    ; 043A _ 48: 89. 48, 28
        mov     qword [rax+30H], rbx                    ; 043E _ 48: 89. 58, 30
        mov     rdx, qword [rel ?_083]                  ; 0442 _ 48: 8B. 15, 00000000(rel)
        mov     rax, qword [rbp-18H]                    ; 0449 _ 48: 8B. 45, E8
        mov     qword [rax], rdx                        ; 044D _ 48: 89. 10
        mov     rax, qword [rbp-18H]                    ; 0450 _ 48: 8B. 45, E8
        mov     qword [rel ?_083], rax                  ; 0454 _ 48: 89. 05, 00000000(rel)
        nop                                             ; 045B _ 90
        mov     rbx, qword [rbp-8H]                     ; 045C _ 48: 8B. 5D, F8
        leave                                           ; 0460 _ C9
        ret                                             ; 0461 _ C3
; stdscan_pushback End of function

stdscan_parse_braces:; Local function
        push    rbp                                     ; 0462 _ 55
        mov     rbp, rsp                                ; 0463 _ 48: 89. E5
        sub     rsp, 112                                ; 0466 _ 48: 83. EC, 70
        mov     qword [rbp-68H], rdi                    ; 046A _ 48: 89. 7D, 98
        mov     qword [rbp-58H], 0                      ; 046E _ 48: C7. 45, A8, 00000000
        mov     qword [rbp-30H], 0                      ; 0476 _ 48: C7. 45, D0, 00000000
        mov     rax, qword [rel scan]                   ; 047E _ 48: 8B. 05, 00000000(rel)
        mov     qword [rbp-28H], rax                    ; 0485 _ 48: 89. 45, D8
        mov     rax, qword [rel scan]                   ; 0489 _ 48: 8B. 05, 00000000(rel)
        add     rax, 1                                  ; 0490 _ 48: 83. C0, 01
        mov     qword [rel scan], rax                   ; 0494 _ 48: 89. 05, 00000000(rel)
        mov     rax, qword [rel scan]                   ; 049B _ 48: 8B. 05, 00000000(rel)
        mov     rdi, rax                                ; 04A2 _ 48: 89. C7
        call    nasm_skip_spaces                        ; 04A5 _ E8, 00000000(PLT r)
        mov     qword [rel scan], rax                   ; 04AA _ 48: 89. 05, 00000000(rel)
        mov     rax, qword [rel scan]                   ; 04B1 _ 48: 8B. 05, 00000000(rel)
        mov     qword [rbp-50H], rax                    ; 04B8 _ 48: 89. 45, B0
        mov     rax, qword [rbp-50H]                    ; 04BC _ 48: 8B. 45, B0
        mov     qword [rbp-20H], rax                    ; 04C0 _ 48: 89. 45, E0
        jmp     ?_013                                   ; 04C4 _ EB, 12

?_012:  mov     rax, qword [rel scan]                   ; 04C6 _ 48: 8B. 05, 00000000(rel)
        add     rax, 1                                  ; 04CD _ 48: 83. C0, 01
        mov     qword [rel scan], rax                   ; 04D1 _ 48: 89. 05, 00000000(rel)
?_013:  mov     rax, qword [rel scan]                   ; 04D8 _ 48: 8B. 05, 00000000(rel)
        movzx   eax, byte [rax]                         ; 04DF _ 0F B6. 00
        movsx   eax, al                                 ; 04E2 _ 0F BE. C0
        mov     edi, eax                                ; 04E5 _ 89. C7
        call    nasm_isbrcchar                          ; 04E7 _ E8, FFFFFBA4
        test    al, al                                  ; 04EC _ 84. C0
        jnz     ?_012                                   ; 04EE _ 75, D6
        mov     rax, qword [rel scan]                   ; 04F0 _ 48: 8B. 05, 00000000(rel)
        mov     qword [rbp-48H], rax                    ; 04F7 _ 48: 89. 45, B8
        mov     rax, qword [rel scan]                   ; 04FB _ 48: 8B. 05, 00000000(rel)
        mov     rdi, rax                                ; 0502 _ 48: 89. C7
        call    nasm_skip_spaces                        ; 0505 _ E8, 00000000(PLT r)
        mov     qword [rel scan], rax                   ; 050A _ 48: 89. 05, 00000000(rel)
        mov     rax, qword [rbp-50H]                    ; 0511 _ 48: 8B. 45, B0
        cmp     rax, qword [rbp-48H]                    ; 0515 _ 48: 3B. 45, B8
        jz      ?_014                                   ; 0519 _ 74, 3F
        mov     rax, qword [rel scan]                   ; 051B _ 48: 8B. 05, 00000000(rel)
        movzx   eax, byte [rax]                         ; 0522 _ 0F B6. 00
        cmp     al, 61                                  ; 0525 _ 3C, 3D
        jnz     ?_014                                   ; 0527 _ 75, 31
        mov     rax, qword [rbp-48H]                    ; 0529 _ 48: 8B. 45, B8
        sub     rax, qword [rbp-20H]                    ; 052D _ 48: 2B. 45, E0
        mov     qword [rbp-58H], rax                    ; 0531 _ 48: 89. 45, A8
        mov     rax, qword [rel scan]                   ; 0535 _ 48: 8B. 05, 00000000(rel)
        add     rax, 1                                  ; 053C _ 48: 83. C0, 01
        mov     qword [rel scan], rax                   ; 0540 _ 48: 89. 05, 00000000(rel)
        mov     rax, qword [rel scan]                   ; 0547 _ 48: 8B. 05, 00000000(rel)
        mov     qword [rbp-48H], rax                    ; 054E _ 48: 89. 45, B8
        mov     rax, qword [rbp-48H]                    ; 0552 _ 48: 8B. 45, B8
        mov     qword [rbp-50H], rax                    ; 0556 _ 48: 89. 45, B0
?_014:  mov     rax, qword [rel scan]                   ; 055A _ 48: 8B. 05, 00000000(rel)
        mov     esi, 125                                ; 0561 _ BE, 0000007D
        mov     rdi, rax                                ; 0566 _ 48: 89. C7
        call    strchr                                  ; 0569 _ E8, 00000000(PLT r)
        mov     qword [rbp-18H], rax                    ; 056E _ 48: 89. 45, E8
        cmp     qword [rbp-18H], 0                      ; 0572 _ 48: 83. 7D, E8, 00
        jnz     ?_015                                   ; 0577 _ 75, 29
        lea     rax, [rel ?_085]                        ; 0579 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 0580 _ 48: 89. C7
        mov     eax, 0                                  ; 0583 _ B8, 00000000
        call    nasm_nonfatal                           ; 0588 _ E8, 00000000(PLT r)
        mov     rax, qword [rbp-68H]                    ; 058D _ 48: 8B. 45, 98
        mov     dword [rax+24H], -1                     ; 0591 _ C7. 40, 24, FFFFFFFF
        mov     eax, 4294967295                         ; 0598 _ B8, FFFFFFFF
        jmp     ?_029                                   ; 059D _ E9, 000002C1

?_015:  add     qword [rbp-18H], 1                      ; 05A2 _ 48: 83. 45, E8, 01
        mov     rax, qword [rbp-18H]                    ; 05A7 _ 48: 8B. 45, E8
        sub     rax, qword [rbp-28H]                    ; 05AB _ 48: 2B. 45, D8
        mov     qword [rbp-10H], rax                    ; 05AF _ 48: 89. 45, F0
        mov     rax, qword [rbp-10H]                    ; 05B3 _ 48: 8B. 45, F0
        add     rax, 1                                  ; 05B7 _ 48: 83. C0, 01
        mov     rdi, rax                                ; 05BB _ 48: 89. C7
        call    stdscan_alloc                           ; 05BE _ E8, FFFFFD48
        mov     rdx, qword [rbp-68H]                    ; 05C3 _ 48: 8B. 55, 98
        mov     qword [rdx+10H], rax                    ; 05C7 _ 48: 89. 42, 10
        mov     rax, qword [rbp-68H]                    ; 05CB _ 48: 8B. 45, 98
        mov     rax, qword [rax+10H]                    ; 05CF _ 48: 8B. 40, 10
        mov     qword [rbp-8H], rax                     ; 05D3 _ 48: 89. 45, F8
        cmp     qword [rbp-58H], 0                      ; 05D7 _ 48: 83. 7D, A8, 00
        jz      ?_016                                   ; 05DC _ 74, 2D
        mov     rdx, qword [rbp-58H]                    ; 05DE _ 48: 8B. 55, A8
        mov     rcx, qword [rbp-20H]                    ; 05E2 _ 48: 8B. 4D, E0
        mov     rax, qword [rbp-8H]                     ; 05E6 _ 48: 8B. 45, F8
        mov     rsi, rcx                                ; 05EA _ 48: 89. CE
        mov     rdi, rax                                ; 05ED _ 48: 89. C7
        call    memcpy                                  ; 05F0 _ E8, 00000000(PLT r)
        mov     rax, qword [rbp-58H]                    ; 05F5 _ 48: 8B. 45, A8
        lea     rdx, [rax+1H]                           ; 05F9 _ 48: 8D. 50, 01
        mov     qword [rbp-58H], rdx                    ; 05FD _ 48: 89. 55, A8
        mov     rdx, qword [rbp-8H]                     ; 0601 _ 48: 8B. 55, F8
        add     rax, rdx                                ; 0605 _ 48: 01. D0
        mov     byte [rax], 61                          ; 0608 _ C6. 00, 3D
?_016:  mov     qword [rbp-38H], 0                      ; 060B _ 48: C7. 45, C8, 00000000
        mov     rax, qword [rbp-38H]                    ; 0613 _ 48: 8B. 45, C8
        mov     qword [rbp-40H], rax                    ; 0617 _ 48: 89. 45, C0
        mov     byte [rbp-5AH], 1                       ; 061B _ C6. 45, A6, 01
?_017:  mov     rax, qword [rbp-48H]                    ; 061F _ 48: 8B. 45, B8
        sub     rax, qword [rbp-50H]                    ; 0623 _ 48: 2B. 45, B0
        mov     qword [rbp-30H], rax                    ; 0627 _ 48: 89. 45, D0
        mov     rdx, qword [rbp-8H]                     ; 062B _ 48: 8B. 55, F8
        mov     rax, qword [rbp-58H]                    ; 062F _ 48: 8B. 45, A8
        lea     rcx, [rdx+rax]                          ; 0633 _ 48: 8D. 0C 02
        mov     rdx, qword [rbp-30H]                    ; 0637 _ 48: 8B. 55, D0
        mov     rax, qword [rbp-50H]                    ; 063B _ 48: 8B. 45, B0
        mov     rsi, rax                                ; 063F _ 48: 89. C6
        mov     rdi, rcx                                ; 0642 _ 48: 89. CF
        call    memcpy                                  ; 0645 _ E8, 00000000(PLT r)
        mov     rdx, qword [rbp-58H]                    ; 064A _ 48: 8B. 55, A8
        mov     rax, qword [rbp-30H]                    ; 064E _ 48: 8B. 45, D0
        add     rdx, rax                                ; 0652 _ 48: 01. C2
        mov     rax, qword [rbp-8H]                     ; 0655 _ 48: 8B. 45, F8
        add     rax, rdx                                ; 0659 _ 48: 01. D0
        mov     byte [rax], 0                           ; 065C _ C6. 00, 00
        mov     rdx, qword [rbp-68H]                    ; 065F _ 48: 8B. 55, 98
        mov     rax, qword [rbp-8H]                     ; 0663 _ 48: 8B. 45, F8
        mov     rsi, rdx                                ; 0667 _ 48: 89. D6
        mov     rdi, rax                                ; 066A _ 48: 89. C7
        call    nasm_token_hash                         ; 066D _ E8, 00000000(PLT r)
        mov     rax, qword [rbp-68H]                    ; 0672 _ 48: 8B. 45, 98
        mov     eax, dword [rax+28H]                    ; 0676 _ 8B. 40, 28
        and     eax, 03H                                ; 0679 _ 83. E0, 03
        test    eax, eax                                ; 067C _ 85. C0
        jnz     ?_018                                   ; 067E _ 75, 2B
        mov     rax, qword [rbp-8H]                     ; 0680 _ 48: 8B. 45, F8
        lea     rdx, [rel ?_086]                        ; 0684 _ 48: 8D. 15, 00000000(rel)
        mov     rsi, rax                                ; 068B _ 48: 89. C6
        mov     rdi, rdx                                ; 068E _ 48: 89. D7
        mov     eax, 0                                  ; 0691 _ B8, 00000000
        call    nasm_nonfatal                           ; 0696 _ E8, 00000000(PLT r)
        mov     rax, qword [rbp-68H]                    ; 069B _ 48: 8B. 45, 98
        mov     dword [rax+24H], -1                     ; 069F _ C7. 40, 24, FFFFFFFF
        jmp     ?_028                                   ; 06A6 _ E9, 00000166

?_018:  mov     rax, qword [rbp-68H]                    ; 06AB _ 48: 8B. 45, 98
        mov     eax, dword [rax+24H]                    ; 06AF _ 8B. 40, 24
        cmp     eax, 292                                ; 06B2 _ 3D, 00000124
        jnz     ?_019                                   ; 06B7 _ 75, 22
        mov     rax, qword [rbp-68H]                    ; 06B9 _ 48: 8B. 45, 98
        mov     rax, qword [rax]                        ; 06BD _ 48: 8B. 00
        mov     esi, eax                                ; 06C0 _ 89. C6
        mov     edi, 32773                              ; 06C2 _ BF, 00008005
        call    is_reg_class                            ; 06C7 _ E8, FFFFFA6D
        test    al, al                                  ; 06CC _ 84. C0
        jz      ?_019                                   ; 06CE _ 74, 0B
        mov     rax, qword [rbp-68H]                    ; 06D0 _ 48: 8B. 45, 98
        mov     dword [rax+24H], 287                    ; 06D4 _ C7. 40, 24, 0000011F
?_019:  mov     rax, qword [rbp-68H]                    ; 06DB _ 48: 8B. 45, 98
        mov     eax, dword [rax+28H]                    ; 06DF _ 8B. 40, 28
        and     eax, 20H                                ; 06E2 _ 83. E0, 20
        test    eax, eax                                ; 06E5 _ 85. C0
        jz      ?_020                                   ; 06E7 _ 74, 19
        mov     rax, qword [rbp-68H]                    ; 06E9 _ 48: 8B. 45, 98
        mov     rax, qword [rax]                        ; 06ED _ 48: 8B. 00
        or      qword [rbp-40H], rax                    ; 06F0 _ 48: 09. 45, C0
        mov     rax, qword [rbp-68H]                    ; 06F4 _ 48: 8B. 45, 98
        mov     rax, qword [rax+8H]                     ; 06F8 _ 48: 8B. 40, 08
        or      qword [rbp-38H], rax                    ; 06FC _ 48: 09. 45, C8
        jmp     ?_021                                   ; 0700 _ EB, 17

?_020:  mov     rax, qword [rbp-68H]                    ; 0702 _ 48: 8B. 45, 98
        mov     rax, qword [rax]                        ; 0706 _ 48: 8B. 00
        mov     qword [rbp-40H], rax                    ; 0709 _ 48: 89. 45, C0
        mov     rax, qword [rbp-68H]                    ; 070D _ 48: 8B. 45, 98
        mov     rax, qword [rax+8H]                     ; 0711 _ 48: 8B. 40, 08
        mov     qword [rbp-38H], rax                    ; 0715 _ 48: 89. 45, C8
?_021:  mov     rax, qword [rel scan]                   ; 0719 _ 48: 8B. 05, 00000000(rel)
        mov     rdi, rax                                ; 0720 _ 48: 89. C7
        call    nasm_skip_spaces                        ; 0723 _ E8, 00000000(PLT r)
        mov     qword [rel scan], rax                   ; 0728 _ 48: 89. 05, 00000000(rel)
        mov     rax, qword [rel scan]                   ; 072F _ 48: 8B. 05, 00000000(rel)
        movzx   eax, byte [rax]                         ; 0736 _ 0F B6. 00
        mov     byte [rbp-59H], al                      ; 0739 _ 88. 45, A7
        cmp     byte [rbp-59H], 125                     ; 073C _ 80. 7D, A7, 7D
        je      ?_027                                   ; 0740 _ 0F 84, 000000CA
        cmp     qword [rbp-58H], 0                      ; 0746 _ 48: 83. 7D, A8, 00
        jz      ?_022                                   ; 074B _ 74, 23
        cmp     byte [rbp-59H], 44                      ; 074D _ 80. 7D, A7, 2C
        jz      ?_023                                   ; 0751 _ 74, 44
        movzx   eax, byte [rbp-5AH]                     ; 0753 _ 0F B6. 45, A6
        xor     eax, 01H                                ; 0757 _ 83. F0, 01
        test    al, al                                  ; 075A _ 84. C0
        jnz     ?_022                                   ; 075C _ 75, 12
        movsx   eax, byte [rbp-59H]                     ; 075E _ 0F BE. 45, A7
        mov     edi, eax                                ; 0762 _ 89. C7
        call    nasm_isbrcchar                          ; 0764 _ E8, FFFFF927
        xor     eax, 01H                                ; 0769 _ 83. F0, 01
        test    al, al                                  ; 076C _ 84. C0
        jz      ?_023                                   ; 076E _ 74, 27
?_022:  movsx   eax, byte [rbp-59H]                     ; 0770 _ 0F BE. 45, A7
        lea     rdx, [rel ?_087]                        ; 0774 _ 48: 8D. 15, 00000000(rel)
        mov     esi, eax                                ; 077B _ 89. C6
        mov     rdi, rdx                                ; 077D _ 48: 89. D7
        mov     eax, 0                                  ; 0780 _ B8, 00000000
        call    nasm_nonfatal                           ; 0785 _ E8, 00000000(PLT r)
        mov     rax, qword [rbp-68H]                    ; 078A _ 48: 8B. 45, 98
        mov     dword [rax+24H], -1                     ; 078E _ C7. 40, 24, FFFFFFFF
        jmp     ?_028                                   ; 0795 _ EB, 7A

?_023:  cmp     byte [rbp-59H], 44                      ; 0797 _ 80. 7D, A7, 2C
        jnz     ?_024                                   ; 079B _ 75, 28
        mov     rax, qword [rel scan]                   ; 079D _ 48: 8B. 05, 00000000(rel)
        add     rax, 1                                  ; 07A4 _ 48: 83. C0, 01
        mov     qword [rel scan], rax                   ; 07A8 _ 48: 89. 05, 00000000(rel)
        mov     rax, qword [rel scan]                   ; 07AF _ 48: 8B. 05, 00000000(rel)
        mov     rdi, rax                                ; 07B6 _ 48: 89. C7
        call    nasm_skip_spaces                        ; 07B9 _ E8, 00000000(PLT r)
        mov     qword [rel scan], rax                   ; 07BE _ 48: 89. 05, 00000000(rel)
?_024:  mov     rax, qword [rel scan]                   ; 07C5 _ 48: 8B. 05, 00000000(rel)
        mov     qword [rbp-50H], rax                    ; 07CC _ 48: 89. 45, B0
        jmp     ?_026                                   ; 07D0 _ EB, 12

?_025:  mov     rax, qword [rel scan]                   ; 07D2 _ 48: 8B. 05, 00000000(rel)
        add     rax, 1                                  ; 07D9 _ 48: 83. C0, 01
        mov     qword [rel scan], rax                   ; 07DD _ 48: 89. 05, 00000000(rel)
?_026:  mov     rax, qword [rel scan]                   ; 07E4 _ 48: 8B. 05, 00000000(rel)
        movzx   eax, byte [rax]                         ; 07EB _ 0F B6. 00
        movsx   eax, al                                 ; 07EE _ 0F BE. C0
        mov     edi, eax                                ; 07F1 _ 89. C7
        call    nasm_isbrcchar                          ; 07F3 _ E8, FFFFF898
        test    al, al                                  ; 07F8 _ 84. C0
        jnz     ?_025                                   ; 07FA _ 75, D6
        mov     rax, qword [rel scan]                   ; 07FC _ 48: 8B. 05, 00000000(rel)
        mov     qword [rbp-48H], rax                    ; 0803 _ 48: 89. 45, B8
        mov     byte [rbp-5AH], 0                       ; 0807 _ C6. 45, A6, 00
        jmp     ?_017                                   ; 080B _ E9, FFFFFE0F

?_027:  nop                                             ; 0810 _ 90
?_028:  mov     rax, qword [rbp-68H]                    ; 0811 _ 48: 8B. 45, 98
        mov     rax, qword [rax+10H]                    ; 0815 _ 48: 8B. 40, 10
        mov     rdx, qword [rbp-10H]                    ; 0819 _ 48: 8B. 55, F0
        mov     rcx, qword [rbp-28H]                    ; 081D _ 48: 8B. 4D, D8
        mov     rsi, rcx                                ; 0821 _ 48: 89. CE
        mov     rdi, rax                                ; 0824 _ 48: 89. C7
        call    memcpy                                  ; 0827 _ E8, 00000000(PLT r)
        mov     rdx, qword [rbp-8H]                     ; 082C _ 48: 8B. 55, F8
        mov     rax, qword [rbp-10H]                    ; 0830 _ 48: 8B. 45, F0
        add     rax, rdx                                ; 0834 _ 48: 01. D0
        mov     byte [rax], 0                           ; 0837 _ C6. 00, 00
        mov     rax, qword [rbp-18H]                    ; 083A _ 48: 8B. 45, E8
        mov     qword [rel scan], rax                   ; 083E _ 48: 89. 05, 00000000(rel)
        mov     rax, qword [rbp-68H]                    ; 0845 _ 48: 8B. 45, 98
        mov     rdx, qword [rbp-40H]                    ; 0849 _ 48: 8B. 55, C0
        mov     qword [rax], rdx                        ; 084D _ 48: 89. 10
        mov     rax, qword [rbp-68H]                    ; 0850 _ 48: 8B. 45, 98
        mov     rdx, qword [rbp-38H]                    ; 0854 _ 48: 8B. 55, C8
        mov     qword [rax+8H], rdx                     ; 0858 _ 48: 89. 50, 08
        mov     rax, qword [rbp-68H]                    ; 085C _ 48: 8B. 45, 98
        mov     eax, dword [rax+24H]                    ; 0860 _ 8B. 40, 24
?_029:  leave                                           ; 0863 _ C9
        ret                                             ; 0864 _ C3

stdscan:; Function begin
        push    rbp                                     ; 0865 _ 55
        mov     rbp, rsp                                ; 0866 _ 48: 89. E5
        push    rbx                                     ; 0869 _ 53
        sub     rsp, 40                                 ; 086A _ 48: 83. EC, 28
        mov     qword [rbp-28H], rdi                    ; 086E _ 48: 89. 7D, D8
        mov     qword [rbp-30H], rsi                    ; 0872 _ 48: 89. 75, D0
        mov     rax, qword [rel ?_083]                  ; 0876 _ 48: 8B. 05, 00000000(rel)
        test    rax, rax                                ; 087D _ 48: 85. C0
        setne   al                                      ; 0880 _ 0F 95. C0
        movzx   eax, al                                 ; 0883 _ 0F B6. C0
        test    rax, rax                                ; 0886 _ 48: 85. C0
        jz      ?_030                                   ; 0889 _ 74, 4B
        mov     rdx, qword [rel ?_083]                  ; 088B _ 48: 8B. 15, 00000000(rel)
        mov     rax, qword [rbp-30H]                    ; 0892 _ 48: 8B. 45, D0
        mov     rcx, qword [rdx+8H]                     ; 0896 _ 48: 8B. 4A, 08
        mov     rbx, qword [rdx+10H]                    ; 089A _ 48: 8B. 5A, 10
        mov     qword [rax], rcx                        ; 089E _ 48: 89. 08
        mov     qword [rax+8H], rbx                     ; 08A1 _ 48: 89. 58, 08
        mov     rcx, qword [rdx+18H]                    ; 08A5 _ 48: 8B. 4A, 18
        mov     rbx, qword [rdx+20H]                    ; 08A9 _ 48: 8B. 5A, 20
        mov     qword [rax+10H], rcx                    ; 08AD _ 48: 89. 48, 10
        mov     qword [rax+18H], rbx                    ; 08B1 _ 48: 89. 58, 18
        mov     rcx, qword [rdx+28H]                    ; 08B5 _ 48: 8B. 4A, 28
        mov     rbx, qword [rdx+30H]                    ; 08B9 _ 48: 8B. 5A, 30
        mov     qword [rax+20H], rcx                    ; 08BD _ 48: 89. 48, 20
        mov     qword [rax+28H], rbx                    ; 08C1 _ 48: 89. 58, 28
        call    stdscan_pushback_pop                    ; 08C5 _ E8, FFFFF9A6
        mov     rax, qword [rbp-30H]                    ; 08CA _ 48: 8B. 45, D0
        mov     eax, dword [rax+24H]                    ; 08CE _ 8B. 40, 24
        jmp     ?_032                                   ; 08D1 _ E9, 00000086

?_030:  mov     rax, qword [rbp-30H]                    ; 08D6 _ 48: 8B. 45, D0
        mov     edx, 48                                 ; 08DA _ BA, 00000030
        mov     esi, 0                                  ; 08DF _ BE, 00000000
        mov     rdi, rax                                ; 08E4 _ 48: 89. C7
        call    memset                                  ; 08E7 _ E8, 00000000(PLT r)
        mov     rax, qword [rel scan]                   ; 08EC _ 48: 8B. 05, 00000000(rel)
        mov     rdi, rax                                ; 08F3 _ 48: 89. C7
        call    nasm_skip_spaces                        ; 08F6 _ E8, 00000000(PLT r)
        mov     qword [rel scan], rax                   ; 08FB _ 48: 89. 05, 00000000(rel)
        mov     rdx, qword [rel scan]                   ; 0902 _ 48: 8B. 15, 00000000(rel)
        mov     rax, qword [rbp-30H]                    ; 0909 _ 48: 8B. 45, D0
        mov     qword [rax+18H], rdx                    ; 090D _ 48: 89. 50, 18
        mov     rax, qword [rel scan]                   ; 0911 _ 48: 8B. 05, 00000000(rel)
        movzx   eax, byte [rax]                         ; 0918 _ 0F B6. 00
        test    al, al                                  ; 091B _ 84. C0
        jnz     ?_031                                   ; 091D _ 75, 12
        mov     rax, qword [rbp-30H]                    ; 091F _ 48: 8B. 45, D0
        mov     dword [rax+24H], 0                      ; 0923 _ C7. 40, 24, 00000000
        mov     eax, 0                                  ; 092A _ B8, 00000000
        jmp     ?_032                                   ; 092F _ EB, 2B

?_031:  mov     rax, qword [rbp-30H]                    ; 0931 _ 48: 8B. 45, D0
        mov     rdi, rax                                ; 0935 _ 48: 89. C7
        call    stdscan_token                           ; 0938 _ E8, 000000C9
        mov     dword [rbp-14H], eax                    ; 093D _ 89. 45, EC
        mov     rdx, qword [rel scan]                   ; 0940 _ 48: 8B. 15, 00000000(rel)
        mov     rax, qword [rbp-30H]                    ; 0947 _ 48: 8B. 45, D0
        mov     rax, qword [rax+18H]                    ; 094B _ 48: 8B. 40, 18
        sub     rdx, rax                                ; 094F _ 48: 29. C2
        mov     rax, qword [rbp-30H]                    ; 0952 _ 48: 8B. 45, D0
        mov     dword [rax+20H], edx                    ; 0956 _ 89. 50, 20
        mov     eax, dword [rbp-14H]                    ; 0959 _ 8B. 45, EC
?_032:  mov     rbx, qword [rbp-8H]                     ; 095C _ 48: 8B. 5D, F8
        leave                                           ; 0960 _ C9
        ret                                             ; 0961 _ C3
; stdscan End of function

stdscan_symbol:; Local function
        push    rbp                                     ; 0962 _ 55
        mov     rbp, rsp                                ; 0963 _ 48: 89. E5
        sub     rsp, 48                                 ; 0966 _ 48: 83. EC, 30
        mov     qword [rbp-28H], rdi                    ; 096A _ 48: 89. 7D, D8
        mov     rax, qword [rel scan]                   ; 096E _ 48: 8B. 05, 00000000(rel)
        mov     qword [rbp-18H], rax                    ; 0975 _ 48: 89. 45, E8
        mov     rax, qword [rbp-18H]                    ; 0979 _ 48: 8B. 45, E8
        mov     qword [rbp-8H], rax                     ; 097D _ 48: 89. 45, F8
        add     qword [rbp-18H], 1                      ; 0981 _ 48: 83. 45, E8, 01
        jmp     ?_034                                   ; 0986 _ EB, 05

?_033:  add     qword [rbp-18H], 1                      ; 0988 _ 48: 83. 45, E8, 01
?_034:  mov     rax, qword [rbp-18H]                    ; 098D _ 48: 8B. 45, E8
        movzx   eax, byte [rax]                         ; 0991 _ 0F B6. 00
        movsx   eax, al                                 ; 0994 _ 0F BE. C0
        mov     edi, eax                                ; 0997 _ 89. C7
        call    nasm_isidchar                           ; 0999 _ E8, FFFFF6D1
        test    al, al                                  ; 099E _ 84. C0
        jnz     ?_033                                   ; 09A0 _ 75, E6
        mov     rax, qword [rbp-18H]                    ; 09A2 _ 48: 8B. 45, E8
        mov     qword [rel scan], rax                   ; 09A6 _ 48: 89. 05, 00000000(rel)
        mov     rax, qword [rbp-18H]                    ; 09AD _ 48: 8B. 45, E8
        sub     rax, qword [rbp-8H]                     ; 09B1 _ 48: 2B. 45, F8
        mov     qword [rbp-10H], rax                    ; 09B5 _ 48: 89. 45, F0
        cmp     qword [rbp-10H], 4095                   ; 09B9 _ 48: 81. 7D, F0, 00000FFF
        jbe     ?_035                                   ; 09C1 _ 76, 08
        mov     qword [rbp-10H], 4095                   ; 09C3 _ 48: C7. 45, F0, 00000FFF
?_035:  mov     rax, qword [rbp-10H]                    ; 09CB _ 48: 8B. 45, F0
        mov     edx, eax                                ; 09CF _ 89. C2
        mov     rax, qword [rbp-28H]                    ; 09D1 _ 48: 8B. 45, D8
        mov     dword [rax+20H], edx                    ; 09D5 _ 89. 50, 20
        mov     rax, qword [rbp-10H]                    ; 09D8 _ 48: 8B. 45, F0
        mov     edx, eax                                ; 09DC _ 89. C2
        mov     rax, qword [rbp-8H]                     ; 09DE _ 48: 8B. 45, F8
        mov     esi, edx                                ; 09E2 _ 89. D6
        mov     rdi, rax                                ; 09E4 _ 48: 89. C7
        call    stdscan_copy                            ; 09E7 _ E8, FFFFF9B2
        mov     rdx, qword [rbp-28H]                    ; 09EC _ 48: 8B. 55, D8
        mov     qword [rdx+10H], rax                    ; 09F0 _ 48: 89. 42, 10
        mov     rax, qword [rbp-28H]                    ; 09F4 _ 48: 8B. 45, D8
        mov     dword [rax+24H], 273                    ; 09F8 _ C7. 40, 24, 00000111
        mov     eax, 273                                ; 09FF _ B8, 00000111
        leave                                           ; 0A04 _ C9
        ret                                             ; 0A05 _ C3

stdscan_token:; Local function
        push    rbp                                     ; 0A06 _ 55
        mov     rbp, rsp                                ; 0A07 _ 48: 89. E5
        sub     rsp, 48                                 ; 0A0A _ 48: 83. EC, 30
        mov     qword [rbp-28H], rdi                    ; 0A0E _ 48: 89. 7D, D8
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        mov     rax, qword [fs:abs 28H]                 ; 0A12 _ 64 48: 8B. 04 25, 00000028
        mov     qword [rbp-8H], rax                     ; 0A1B _ 48: 89. 45, F8
        xor     eax, eax                                ; 0A1F _ 31. C0
        mov     rax, qword [rel scan]                   ; 0A21 _ 48: 8B. 05, 00000000(rel)
        movzx   eax, byte [rax]                         ; 0A28 _ 0F B6. 00
        movsx   eax, al                                 ; 0A2B _ 0F BE. C0
        mov     edi, eax                                ; 0A2E _ 89. C7
        call    nasm_isidstart                          ; 0A30 _ E8, FFFFF619
        test    al, al                                  ; 0A35 _ 84. C0
        je      ?_038                                   ; 0A37 _ 0F 84, 000000BD
        mov     rax, qword [rbp-28H]                    ; 0A3D _ 48: 8B. 45, D8
        mov     rdi, rax                                ; 0A41 _ 48: 89. C7
        call    stdscan_symbol                          ; 0A44 _ E8, FFFFFF19
        mov     rax, qword [rbp-28H]                    ; 0A49 _ 48: 8B. 45, D8
        mov     eax, dword [rax+20H]                    ; 0A4D _ 8B. 40, 20
        cmp     eax, 17                                 ; 0A50 _ 83. F8, 11
        jg      ?_037                                   ; 0A53 _ 0F 8F, 0000008C
        mov     rax, qword [rbp-28H]                    ; 0A59 _ 48: 8B. 45, D8
        mov     rax, qword [rax+10H]                    ; 0A5D _ 48: 8B. 40, 10
        mov     rdx, qword [rbp-28H]                    ; 0A61 _ 48: 8B. 55, D8
        mov     rsi, rdx                                ; 0A65 _ 48: 89. D6
        mov     rdi, rax                                ; 0A68 _ 48: 89. C7
        call    nasm_token_hash                         ; 0A6B _ E8, 00000000(PLT r)
        mov     dword [rbp-18H], eax                    ; 0A70 _ 89. 45, E8
        mov     rax, qword [rbp-28H]                    ; 0A73 _ 48: 8B. 45, D8
        mov     eax, dword [rax+28H]                    ; 0A77 _ 8B. 40, 28
        and     eax, 08H                                ; 0A7A _ 83. E0, 08
        shr     eax, 3                                  ; 0A7D _ C1. E8, 03
        and     eax, 01H                                ; 0A80 _ 83. E0, 01
        movzx   eax, al                                 ; 0A83 _ 0F B6. C0
        test    rax, rax                                ; 0A86 _ 48: 85. C0
        jz      ?_036                                   ; 0A89 _ 74, 3A
        mov     dword [rbp-14H], 3407872                ; 0A8B _ C7. 45, EC, 00340000
        mov     eax, dword [rbp-14H]                    ; 0A92 _ 8B. 45, EC
        mov     edi, eax                                ; 0A95 _ 89. C7
        call    warn_active                             ; 0A97 _ E8, FFFFF6ED
        movzx   eax, al                                 ; 0A9C _ 0F B6. C0
        test    rax, rax                                ; 0A9F _ 48: 85. C0
        jz      ?_036                                   ; 0AA2 _ 74, 21
        mov     rax, qword [rbp-28H]                    ; 0AA4 _ 48: 8B. 45, D8
        mov     rdx, qword [rax+10H]                    ; 0AA8 _ 48: 8B. 50, 10
        lea     rcx, [rel ?_088]                        ; 0AAC _ 48: 8D. 0D, 00000000(rel)
        mov     eax, dword [rbp-14H]                    ; 0AB3 _ 8B. 45, EC
        mov     rsi, rcx                                ; 0AB6 _ 48: 89. CE
        mov     edi, eax                                ; 0AB9 _ 89. C7
        mov     eax, 0                                  ; 0ABB _ B8, 00000000
        call    nasm_warn_                              ; 0AC0 _ E8, 00000000(PLT r)
?_036:  mov     rax, qword [rbp-28H]                    ; 0AC5 _ 48: 8B. 45, D8
        mov     eax, dword [rax+28H]                    ; 0AC9 _ 8B. 40, 28
        and     eax, 01H                                ; 0ACC _ 83. E0, 01
        and     eax, 01H                                ; 0ACF _ 83. E0, 01
        xor     eax, 01H                                ; 0AD2 _ 83. F0, 01
        movzx   eax, al                                 ; 0AD5 _ 0F B6. C0
        test    rax, rax                                ; 0AD8 _ 48: 85. C0
        jz      ?_037                                   ; 0ADB _ 74, 08
        mov     eax, dword [rbp-18H]                    ; 0ADD _ 8B. 45, E8
        jmp     ?_081                                   ; 0AE0 _ E9, 00000834

?_037:  mov     rax, qword [rbp-28H]                    ; 0AE5 _ 48: 8B. 45, D8
        mov     dword [rax+24H], 273                    ; 0AE9 _ C7. 40, 24, 00000111
        mov     eax, 273                                ; 0AF0 _ B8, 00000111
        jmp     ?_081                                   ; 0AF5 _ E9, 0000081F

?_038:  mov     rax, qword [rel scan]                   ; 0AFA _ 48: 8B. 05, 00000000(rel)
        movzx   eax, byte [rax]                         ; 0B01 _ 0F B6. 00
        cmp     al, 36                                  ; 0B04 _ 3C, 24
        jne     ?_042                                   ; 0B06 _ 0F 85, 000000D5
        movzx   eax, byte [rel globl+0DH]               ; 0B0C _ 0F B6. 05, 00000000(rel)
        xor     eax, 01H                                ; 0B13 _ 83. F0, 01
        test    al, al                                  ; 0B16 _ 84. C0
        jnz     ?_039                                   ; 0B18 _ 75, 23
        mov     rax, qword [rel scan]                   ; 0B1A _ 48: 8B. 05, 00000000(rel)
        add     rax, 1                                  ; 0B21 _ 48: 83. C0, 01
        movzx   eax, byte [rax]                         ; 0B25 _ 0F B6. 00
        movsx   eax, al                                 ; 0B28 _ 0F BE. C0
        mov     edi, eax                                ; 0B2B _ 89. C7
        call    nasm_isdigit                            ; 0B2D _ E8, FFFFF4FB
        xor     eax, 01H                                ; 0B32 _ 83. F0, 01
        test    al, al                                  ; 0B35 _ 84. C0
        je      ?_042                                   ; 0B37 _ 0F 84, 000000A4
?_039:  mov     rax, qword [rel scan]                   ; 0B3D _ 48: 8B. 05, 00000000(rel)
        add     rax, 1                                  ; 0B44 _ 48: 83. C0, 01
        mov     qword [rel scan], rax                   ; 0B48 _ 48: 89. 05, 00000000(rel)
        mov     rax, qword [rel scan]                   ; 0B4F _ 48: 8B. 05, 00000000(rel)
        movzx   eax, byte [rax]                         ; 0B56 _ 0F B6. 00
        cmp     al, 36                                  ; 0B59 _ 3C, 24
        jnz     ?_040                                   ; 0B5B _ 75, 46
        mov     rax, qword [rel scan]                   ; 0B5D _ 48: 8B. 05, 00000000(rel)
        add     rax, 1                                  ; 0B64 _ 48: 83. C0, 01
        movzx   eax, byte [rax]                         ; 0B68 _ 0F B6. 00
        movsx   eax, al                                 ; 0B6B _ 0F BE. C0
        mov     edi, eax                                ; 0B6E _ 89. C7
        call    nasm_isidchar                           ; 0B70 _ E8, FFFFF4FA
        xor     eax, 01H                                ; 0B75 _ 83. F0, 01
        test    al, al                                  ; 0B78 _ 84. C0
        jz      ?_040                                   ; 0B7A _ 74, 27
        mov     rax, qword [rel scan]                   ; 0B7C _ 48: 8B. 05, 00000000(rel)
        add     rax, 1                                  ; 0B83 _ 48: 83. C0, 01
        mov     qword [rel scan], rax                   ; 0B87 _ 48: 89. 05, 00000000(rel)
        mov     rax, qword [rbp-28H]                    ; 0B8E _ 48: 8B. 45, D8
        mov     dword [rax+24H], 276                    ; 0B92 _ C7. 40, 24, 00000114
        mov     eax, 276                                ; 0B99 _ B8, 00000114
        jmp     ?_081                                   ; 0B9E _ E9, 00000776

?_040:  mov     rax, qword [rel scan]                   ; 0BA3 _ 48: 8B. 05, 00000000(rel)
        movzx   eax, byte [rax]                         ; 0BAA _ 0F B6. 00
        movsx   eax, al                                 ; 0BAD _ 0F BE. C0
        mov     edi, eax                                ; 0BB0 _ 89. C7
        call    nasm_isidchar                           ; 0BB2 _ E8, FFFFF4B8
        test    al, al                                  ; 0BB7 _ 84. C0
        jz      ?_041                                   ; 0BB9 _ 74, 11
        mov     rax, qword [rbp-28H]                    ; 0BBB _ 48: 8B. 45, D8
        mov     rdi, rax                                ; 0BBF _ 48: 89. C7
        call    stdscan_symbol                          ; 0BC2 _ E8, FFFFFD9B
        jmp     ?_081                                   ; 0BC7 _ E9, 0000074D

?_041:  mov     rax, qword [rbp-28H]                    ; 0BCC _ 48: 8B. 45, D8
        mov     dword [rax+24H], 275                    ; 0BD0 _ C7. 40, 24, 00000113
        mov     eax, 275                                ; 0BD7 _ B8, 00000113
        jmp     ?_081                                   ; 0BDC _ E9, 00000738

?_042:  mov     rax, qword [rel scan]                   ; 0BE1 _ 48: 8B. 05, 00000000(rel)
        movzx   eax, byte [rax]                         ; 0BE8 _ 0F B6. 00
        movsx   eax, al                                 ; 0BEB _ 0F BE. C0
        mov     edi, eax                                ; 0BEE _ 89. C7
        call    nasm_isnumstart                         ; 0BF0 _ E8, FFFFF4BC
        test    al, al                                  ; 0BF5 _ 84. C0
        je      ?_059                                   ; 0BF7 _ 0F 84, 0000021C
        mov     byte [rbp-1DH], 0                       ; 0BFD _ C6. 45, E3, 00
        mov     byte [rbp-1CH], 0                       ; 0C01 _ C6. 45, E4, 00
        mov     byte [rbp-1BH], 0                       ; 0C05 _ C6. 45, E5, 00
        mov     rax, qword [rel scan]                   ; 0C09 _ 48: 8B. 05, 00000000(rel)
        mov     qword [rbp-10H], rax                    ; 0C10 _ 48: 89. 45, F0
        mov     rax, qword [rel scan]                   ; 0C14 _ 48: 8B. 05, 00000000(rel)
        movzx   eax, byte [rax]                         ; 0C1B _ 0F B6. 00
        cmp     al, 36                                  ; 0C1E _ 3C, 24
        jnz     ?_043                                   ; 0C20 _ 75, 1B
        mov     rax, qword [rel scan]                   ; 0C22 _ 48: 8B. 05, 00000000(rel)
        add     rax, 1                                  ; 0C29 _ 48: 83. C0, 01
        mov     qword [rel scan], rax                   ; 0C2D _ 48: 89. 05, 00000000(rel)
        mov     byte [rbp-1DH], 1                       ; 0C34 _ C6. 45, E3, 01
        call    warn_dollar_hex                         ; 0C38 _ E8, 00000000(PLT r)
?_043:  mov     rax, qword [rel scan]                   ; 0C3D _ 48: 8B. 05, 00000000(rel)
        lea     rdx, [rax+1H]                           ; 0C44 _ 48: 8D. 50, 01
        mov     qword [rel scan], rdx                   ; 0C48 _ 48: 89. 15, 00000000(rel)
        movzx   eax, byte [rax]                         ; 0C4F _ 0F B6. 00
        mov     byte [rbp-19H], al                      ; 0C52 _ 88. 45, E7
        movzx   eax, byte [rbp-1DH]                     ; 0C55 _ 0F B6. 45, E3
        xor     eax, 01H                                ; 0C59 _ 83. F0, 01
        test    al, al                                  ; 0C5C _ 84. C0
        jz      ?_046                                   ; 0C5E _ 74, 4B
        cmp     byte [rbp-19H], 101                     ; 0C60 _ 80. 7D, E7, 65
        jz      ?_044                                   ; 0C64 _ 74, 06
        cmp     byte [rbp-19H], 69                      ; 0C66 _ 80. 7D, E7, 45
        jnz     ?_046                                   ; 0C6A _ 75, 3F
?_044:  mov     byte [rbp-1BH], 1                       ; 0C6C _ C6. 45, E5, 01
        mov     rax, qword [rel scan]                   ; 0C70 _ 48: 8B. 05, 00000000(rel)
        movzx   eax, byte [rax]                         ; 0C77 _ 0F B6. 00
        cmp     al, 43                                  ; 0C7A _ 3C, 2B
        jz      ?_045                                   ; 0C7C _ 74, 12
        mov     rax, qword [rel scan]                   ; 0C7E _ 48: 8B. 05, 00000000(rel)
        movzx   eax, byte [rax]                         ; 0C85 _ 0F B6. 00
        cmp     al, 45                                  ; 0C88 _ 3C, 2D
        jne     ?_052                                   ; 0C8A _ 0F 85, 0000009B
?_045:  mov     byte [rbp-1CH], 1                       ; 0C90 _ C6. 45, E4, 01
        mov     rax, qword [rel scan]                   ; 0C94 _ 48: 8B. 05, 00000000(rel)
        add     rax, 1                                  ; 0C9B _ 48: 83. C0, 01
        mov     qword [rel scan], rax                   ; 0C9F _ 48: 89. 05, 00000000(rel)
        jmp     ?_052                                   ; 0CA6 _ E9, 00000080

?_046:  cmp     byte [rbp-19H], 72                      ; 0CAB _ 80. 7D, E7, 48
        jz      ?_047                                   ; 0CAF _ 74, 12
        cmp     byte [rbp-19H], 104                     ; 0CB1 _ 80. 7D, E7, 68
        jz      ?_047                                   ; 0CB5 _ 74, 0C
        cmp     byte [rbp-19H], 88                      ; 0CB7 _ 80. 7D, E7, 58
        jz      ?_047                                   ; 0CBB _ 74, 06
        cmp     byte [rbp-19H], 120                     ; 0CBD _ 80. 7D, E7, 78
        jnz     ?_048                                   ; 0CC1 _ 75, 06
?_047:  mov     byte [rbp-1DH], 1                       ; 0CC3 _ C6. 45, E3, 01
        jmp     ?_054                                   ; 0CC7 _ EB, 69

?_048:  cmp     byte [rbp-19H], 80                      ; 0CC9 _ 80. 7D, E7, 50
        jz      ?_049                                   ; 0CCD _ 74, 06
        cmp     byte [rbp-19H], 112                     ; 0CCF _ 80. 7D, E7, 70
        jnz     ?_051                                   ; 0CD3 _ 75, 34
?_049:  mov     byte [rbp-1CH], 1                       ; 0CD5 _ C6. 45, E4, 01
        mov     rax, qword [rel scan]                   ; 0CD9 _ 48: 8B. 05, 00000000(rel)
        movzx   eax, byte [rax]                         ; 0CE0 _ 0F B6. 00
        cmp     al, 43                                  ; 0CE3 _ 3C, 2B
        jz      ?_050                                   ; 0CE5 _ 74, 0E
        mov     rax, qword [rel scan]                   ; 0CE7 _ 48: 8B. 05, 00000000(rel)
        movzx   eax, byte [rax]                         ; 0CEE _ 0F B6. 00
        cmp     al, 45                                  ; 0CF1 _ 3C, 2D
        jnz     ?_053                                   ; 0CF3 _ 75, 3C
?_050:  mov     rax, qword [rel scan]                   ; 0CF5 _ 48: 8B. 05, 00000000(rel)
        add     rax, 1                                  ; 0CFC _ 48: 83. C0, 01
        mov     qword [rel scan], rax                   ; 0D00 _ 48: 89. 05, 00000000(rel)
        jmp     ?_053                                   ; 0D07 _ EB, 28

?_051:  movsx   eax, byte [rbp-19H]                     ; 0D09 _ 0F BE. 45, E7
        mov     edi, eax                                ; 0D0D _ 89. C7
        call    nasm_isnumchar                          ; 0D0F _ E8, FFFFF3BE
        test    al, al                                  ; 0D14 _ 84. C0
        jne     ?_043                                   ; 0D16 _ 0F 85, FFFFFF21
        cmp     byte [rbp-19H], 46                      ; 0D1C _ 80. 7D, E7, 2E
        jnz     ?_055                                   ; 0D20 _ 75, 15
        mov     byte [rbp-1CH], 1                       ; 0D22 _ C6. 45, E4, 01
        jmp     ?_043                                   ; 0D26 _ E9, FFFFFF12

?_052:  nop                                             ; 0D2B _ 90
        jmp     ?_043                                   ; 0D2C _ E9, FFFFFF0C

?_053:  nop                                             ; 0D31 _ 90
?_054:  jmp     ?_043                                   ; 0D32 _ E9, FFFFFF06

?_055:  nop                                             ; 0D37 _ 90
        mov     rax, qword [rel scan]                   ; 0D38 _ 48: 8B. 05, 00000000(rel)
        sub     rax, 1                                  ; 0D3F _ 48: 83. E8, 01
        mov     qword [rel scan], rax                   ; 0D43 _ 48: 89. 05, 00000000(rel)
        cmp     byte [rbp-1BH], 0                       ; 0D4A _ 80. 7D, E5, 00
        jz      ?_056                                   ; 0D4E _ 74, 0F
        movzx   eax, byte [rbp-1DH]                     ; 0D50 _ 0F B6. 45, E3
        xor     eax, 01H                                ; 0D54 _ 83. F0, 01
        test    al, al                                  ; 0D57 _ 84. C0
        jz      ?_056                                   ; 0D59 _ 74, 04
        mov     byte [rbp-1CH], 1                       ; 0D5B _ C6. 45, E4, 01
?_056:  cmp     byte [rbp-1CH], 0                       ; 0D5F _ 80. 7D, E4, 00
        jz      ?_057                                   ; 0D63 _ 74, 38
        mov     rax, qword [rel scan]                   ; 0D65 _ 48: 8B. 05, 00000000(rel)
        sub     rax, qword [rbp-10H]                    ; 0D6C _ 48: 2B. 45, F0
        mov     edx, eax                                ; 0D70 _ 89. C2
        mov     rax, qword [rbp-10H]                    ; 0D72 _ 48: 8B. 45, F0
        mov     esi, edx                                ; 0D76 _ 89. D6
        mov     rdi, rax                                ; 0D78 _ 48: 89. C7
        call    stdscan_copy                            ; 0D7B _ E8, FFFFF61E
        mov     rdx, qword [rbp-28H]                    ; 0D80 _ 48: 8B. 55, D8
        mov     qword [rdx+10H], rax                    ; 0D84 _ 48: 89. 42, 10
        mov     rax, qword [rbp-28H]                    ; 0D88 _ 48: 8B. 45, D8
        mov     dword [rax+24H], 274                    ; 0D8C _ C7. 40, 24, 00000112
        mov     eax, 274                                ; 0D93 _ B8, 00000112
        jmp     ?_081                                   ; 0D98 _ E9, 0000057C

?_057:  mov     rax, qword [rel scan]                   ; 0D9D _ 48: 8B. 05, 00000000(rel)
        sub     rax, qword [rbp-10H]                    ; 0DA4 _ 48: 2B. 45, F0
        mov     edx, eax                                ; 0DA8 _ 89. C2
        mov     rax, qword [rbp-10H]                    ; 0DAA _ 48: 8B. 45, F0
        mov     esi, edx                                ; 0DAE _ 89. D6
        mov     rdi, rax                                ; 0DB0 _ 48: 89. C7
        call    stdscan_copy                            ; 0DB3 _ E8, FFFFF5E6
        mov     qword [rbp-10H], rax                    ; 0DB8 _ 48: 89. 45, F0
        lea     rdx, [rbp-1EH]                          ; 0DBC _ 48: 8D. 55, E2
        mov     rax, qword [rbp-10H]                    ; 0DC0 _ 48: 8B. 45, F0
        mov     rsi, rdx                                ; 0DC4 _ 48: 89. D6
        mov     rdi, rax                                ; 0DC7 _ 48: 89. C7
        call    readnum                                 ; 0DCA _ E8, 00000000(PLT r)
        mov     rdx, qword [rbp-28H]                    ; 0DCF _ 48: 8B. 55, D8
        mov     qword [rdx], rax                        ; 0DD3 _ 48: 89. 02
        call    stdscan_pop                             ; 0DD6 _ E8, FFFFF45D
        movzx   eax, byte [rbp-1EH]                     ; 0DDB _ 0F B6. 45, E2
        test    al, al                                  ; 0DDF _ 84. C0
        jz      ?_058                                   ; 0DE1 _ 74, 15
        mov     rax, qword [rbp-28H]                    ; 0DE3 _ 48: 8B. 45, D8
        mov     dword [rax+24H], 270                    ; 0DE7 _ C7. 40, 24, 0000010E
        mov     eax, 270                                ; 0DEE _ B8, 0000010E
        jmp     ?_081                                   ; 0DF3 _ E9, 00000521

?_058:  mov     rax, qword [rbp-28H]                    ; 0DF8 _ 48: 8B. 45, D8
        mov     qword [rax+10H], 0                      ; 0DFC _ 48: C7. 40, 10, 00000000
        mov     rax, qword [rbp-28H]                    ; 0E04 _ 48: 8B. 45, D8
        mov     dword [rax+24H], 269                    ; 0E08 _ C7. 40, 24, 0000010D
        mov     eax, 269                                ; 0E0F _ B8, 0000010D
        jmp     ?_081                                   ; 0E14 _ E9, 00000500

?_059:  mov     rax, qword [rel scan]                   ; 0E19 _ 48: 8B. 05, 00000000(rel)
        movzx   eax, byte [rax]                         ; 0E20 _ 0F B6. 00
        cmp     al, 39                                  ; 0E23 _ 3C, 27
        jz      ?_060                                   ; 0E25 _ 74, 20
        mov     rax, qword [rel scan]                   ; 0E27 _ 48: 8B. 05, 00000000(rel)
        movzx   eax, byte [rax]                         ; 0E2E _ 0F B6. 00
        cmp     al, 34                                  ; 0E31 _ 3C, 22
        jz      ?_060                                   ; 0E33 _ 74, 12
        mov     rax, qword [rel scan]                   ; 0E35 _ 48: 8B. 05, 00000000(rel)
        movzx   eax, byte [rax]                         ; 0E3C _ 0F B6. 00
        cmp     al, 96                                  ; 0E3F _ 3C, 60
        jne     ?_062                                   ; 0E41 _ 0F 85, 0000008C
?_060:  mov     rax, qword [rel scan]                   ; 0E47 _ 48: 8B. 05, 00000000(rel)
        movzx   eax, byte [rax]                         ; 0E4E _ 0F B6. 00
        mov     byte [rbp-1AH], al                      ; 0E51 _ 88. 45, E6
        mov     rdx, qword [rel scan]                   ; 0E54 _ 48: 8B. 15, 00000000(rel)
        mov     rax, qword [rbp-28H]                    ; 0E5B _ 48: 8B. 45, D8
        mov     qword [rax+10H], rdx                    ; 0E5F _ 48: 89. 50, 10
        mov     rax, qword [rbp-28H]                    ; 0E63 _ 48: 8B. 45, D8
        mov     rax, qword [rax+10H]                    ; 0E67 _ 48: 8B. 40, 10
        lea     rdx, [rel scan]                         ; 0E6B _ 48: 8D. 15, 00000000(rel)
        mov     rsi, rdx                                ; 0E72 _ 48: 89. D6
        mov     rdi, rax                                ; 0E75 _ 48: 89. C7
        call    nasm_unquote                            ; 0E78 _ E8, 00000000(PLT r)
        mov     rdx, rax                                ; 0E7D _ 48: 89. C2
        mov     rax, qword [rbp-28H]                    ; 0E80 _ 48: 8B. 45, D8
        mov     qword [rax+8H], rdx                     ; 0E84 _ 48: 89. 50, 08
        mov     rax, qword [rel scan]                   ; 0E88 _ 48: 8B. 05, 00000000(rel)
        movzx   eax, byte [rax]                         ; 0E8F _ 0F B6. 00
        cmp     byte [rbp-1AH], al                      ; 0E92 _ 38. 45, E6
        jz      ?_061                                   ; 0E95 _ 74, 15
        mov     rax, qword [rbp-28H]                    ; 0E97 _ 48: 8B. 45, D8
        mov     dword [rax+24H], 272                    ; 0E9B _ C7. 40, 24, 00000110
        mov     eax, 272                                ; 0EA2 _ B8, 00000110
        jmp     ?_081                                   ; 0EA7 _ E9, 0000046D

?_061:  mov     rax, qword [rel scan]                   ; 0EAC _ 48: 8B. 05, 00000000(rel)
        add     rax, 1                                  ; 0EB3 _ 48: 83. C0, 01
        mov     qword [rel scan], rax                   ; 0EB7 _ 48: 89. 05, 00000000(rel)
        mov     rax, qword [rbp-28H]                    ; 0EBE _ 48: 8B. 45, D8
        mov     dword [rax+24H], 271                    ; 0EC2 _ C7. 40, 24, 0000010F
        mov     eax, 271                                ; 0EC9 _ B8, 0000010F
        jmp     ?_081                                   ; 0ECE _ E9, 00000446

?_062:  mov     rax, qword [rel scan]                   ; 0ED3 _ 48: 8B. 05, 00000000(rel)
        movzx   eax, byte [rax]                         ; 0EDA _ 0F B6. 00
        cmp     al, 123                                 ; 0EDD _ 3C, 7B
        jnz     ?_063                                   ; 0EDF _ 75, 11
        mov     rax, qword [rbp-28H]                    ; 0EE1 _ 48: 8B. 45, D8
        mov     rdi, rax                                ; 0EE5 _ 48: 89. C7
        call    stdscan_parse_braces                    ; 0EE8 _ E8, FFFFF575
        jmp     ?_081                                   ; 0EED _ E9, 00000427

?_063:  mov     rax, qword [rel scan]                   ; 0EF2 _ 48: 8B. 05, 00000000(rel)
        movzx   eax, byte [rax]                         ; 0EF9 _ 0F B6. 00
        cmp     al, 59                                  ; 0EFC _ 3C, 3B
        jnz     ?_064                                   ; 0EFE _ 75, 15
        mov     rax, qword [rbp-28H]                    ; 0F00 _ 48: 8B. 45, D8
        mov     dword [rax+24H], 0                      ; 0F04 _ C7. 40, 24, 00000000
        mov     eax, 0                                  ; 0F0B _ B8, 00000000
        jmp     ?_081                                   ; 0F10 _ E9, 00000404

?_064:  mov     rax, qword [rel scan]                   ; 0F15 _ 48: 8B. 05, 00000000(rel)
        movzx   eax, byte [rax]                         ; 0F1C _ 0F B6. 00
        cmp     al, 62                                  ; 0F1F _ 3C, 3E
        jnz     ?_066                                   ; 0F21 _ 75, 72
        mov     rax, qword [rel scan]                   ; 0F23 _ 48: 8B. 05, 00000000(rel)
        add     rax, 1                                  ; 0F2A _ 48: 83. C0, 01
        movzx   eax, byte [rax]                         ; 0F2E _ 0F B6. 00
        cmp     al, 62                                  ; 0F31 _ 3C, 3E
        jnz     ?_066                                   ; 0F33 _ 75, 60
        mov     rax, qword [rel scan]                   ; 0F35 _ 48: 8B. 05, 00000000(rel)
        add     rax, 2                                  ; 0F3C _ 48: 83. C0, 02
        movzx   eax, byte [rax]                         ; 0F40 _ 0F B6. 00
        cmp     al, 62                                  ; 0F43 _ 3C, 3E
        jnz     ?_065                                   ; 0F45 _ 75, 27
        mov     rax, qword [rel scan]                   ; 0F47 _ 48: 8B. 05, 00000000(rel)
        add     rax, 3                                  ; 0F4E _ 48: 83. C0, 03
        mov     qword [rel scan], rax                   ; 0F52 _ 48: 89. 05, 00000000(rel)
        mov     rax, qword [rbp-28H]                    ; 0F59 _ 48: 8B. 45, D8
        mov     dword [rax+24H], 258                    ; 0F5D _ C7. 40, 24, 00000102
        mov     eax, 258                                ; 0F64 _ B8, 00000102
        jmp     ?_081                                   ; 0F69 _ E9, 000003AB

?_065:  mov     rax, qword [rel scan]                   ; 0F6E _ 48: 8B. 05, 00000000(rel)
        add     rax, 2                                  ; 0F75 _ 48: 83. C0, 02
        mov     qword [rel scan], rax                   ; 0F79 _ 48: 89. 05, 00000000(rel)
        mov     rax, qword [rbp-28H]                    ; 0F80 _ 48: 8B. 45, D8
        mov     dword [rax+24H], 257                    ; 0F84 _ C7. 40, 24, 00000101
        mov     eax, 257                                ; 0F8B _ B8, 00000101
        jmp     ?_081                                   ; 0F90 _ E9, 00000384

?_066:  mov     rax, qword [rel scan]                   ; 0F95 _ 48: 8B. 05, 00000000(rel)
        movzx   eax, byte [rax]                         ; 0F9C _ 0F B6. 00
        cmp     al, 60                                  ; 0F9F _ 3C, 3C
        jnz     ?_069                                   ; 0FA1 _ 75, 57
        mov     rax, qword [rel scan]                   ; 0FA3 _ 48: 8B. 05, 00000000(rel)
        add     rax, 1                                  ; 0FAA _ 48: 83. C0, 01
        movzx   eax, byte [rax]                         ; 0FAE _ 0F B6. 00
        cmp     al, 60                                  ; 0FB1 _ 3C, 3C
        jnz     ?_069                                   ; 0FB3 _ 75, 45
        mov     rax, qword [rel scan]                   ; 0FB5 _ 48: 8B. 05, 00000000(rel)
        mov     rdx, qword [rel scan]                   ; 0FBC _ 48: 8B. 15, 00000000(rel)
        add     rdx, 2                                  ; 0FC3 _ 48: 83. C2, 02
        movzx   edx, byte [rdx]                         ; 0FC7 _ 0F B6. 12
        cmp     dl, 60                                  ; 0FCA _ 80. FA, 3C
        jnz     ?_067                                   ; 0FCD _ 75, 07
        mov     edx, 3                                  ; 0FCF _ BA, 00000003
        jmp     ?_068                                   ; 0FD4 _ EB, 05

?_067:  mov     edx, 2                                  ; 0FD6 _ BA, 00000002
?_068:  add     rax, rdx                                ; 0FDB _ 48: 01. D0
        mov     qword [rel scan], rax                   ; 0FDE _ 48: 89. 05, 00000000(rel)
        mov     rax, qword [rbp-28H]                    ; 0FE5 _ 48: 8B. 45, D8
        mov     dword [rax+24H], 256                    ; 0FE9 _ C7. 40, 24, 00000100
        mov     eax, 256                                ; 0FF0 _ B8, 00000100
        jmp     ?_081                                   ; 0FF5 _ E9, 0000031F

?_069:  mov     rax, qword [rel scan]                   ; 0FFA _ 48: 8B. 05, 00000000(rel)
        movzx   eax, byte [rax]                         ; 1001 _ 0F B6. 00
        cmp     al, 47                                  ; 1004 _ 3C, 2F
        jnz     ?_070                                   ; 1006 _ 75, 39
        mov     rax, qword [rel scan]                   ; 1008 _ 48: 8B. 05, 00000000(rel)
        add     rax, 1                                  ; 100F _ 48: 83. C0, 01
        movzx   eax, byte [rax]                         ; 1013 _ 0F B6. 00
        cmp     al, 47                                  ; 1016 _ 3C, 2F
        jnz     ?_070                                   ; 1018 _ 75, 27
        mov     rax, qword [rel scan]                   ; 101A _ 48: 8B. 05, 00000000(rel)
        add     rax, 2                                  ; 1021 _ 48: 83. C0, 02
        mov     qword [rel scan], rax                   ; 1025 _ 48: 89. 05, 00000000(rel)
        mov     rax, qword [rbp-28H]                    ; 102C _ 48: 8B. 45, D8
        mov     dword [rax+24H], 259                    ; 1030 _ C7. 40, 24, 00000103
        mov     eax, 259                                ; 1037 _ B8, 00000103
        jmp     ?_081                                   ; 103C _ E9, 000002D8

?_070:  mov     rax, qword [rel scan]                   ; 1041 _ 48: 8B. 05, 00000000(rel)
        movzx   eax, byte [rax]                         ; 1048 _ 0F B6. 00
        cmp     al, 37                                  ; 104B _ 3C, 25
        jnz     ?_071                                   ; 104D _ 75, 39
        mov     rax, qword [rel scan]                   ; 104F _ 48: 8B. 05, 00000000(rel)
        add     rax, 1                                  ; 1056 _ 48: 83. C0, 01
        movzx   eax, byte [rax]                         ; 105A _ 0F B6. 00
        cmp     al, 37                                  ; 105D _ 3C, 25
        jnz     ?_071                                   ; 105F _ 75, 27
        mov     rax, qword [rel scan]                   ; 1061 _ 48: 8B. 05, 00000000(rel)
        add     rax, 2                                  ; 1068 _ 48: 83. C0, 02
        mov     qword [rel scan], rax                   ; 106C _ 48: 89. 05, 00000000(rel)
        mov     rax, qword [rbp-28H]                    ; 1073 _ 48: 8B. 45, D8
        mov     dword [rax+24H], 260                    ; 1077 _ C7. 40, 24, 00000104
        mov     eax, 260                                ; 107E _ B8, 00000104
        jmp     ?_081                                   ; 1083 _ E9, 00000291

?_071:  mov     rax, qword [rel scan]                   ; 1088 _ 48: 8B. 05, 00000000(rel)
        movzx   eax, byte [rax]                         ; 108F _ 0F B6. 00
        cmp     al, 61                                  ; 1092 _ 3C, 3D
        jnz     ?_072                                   ; 1094 _ 75, 39
        mov     rax, qword [rel scan]                   ; 1096 _ 48: 8B. 05, 00000000(rel)
        add     rax, 1                                  ; 109D _ 48: 83. C0, 01
        movzx   eax, byte [rax]                         ; 10A1 _ 0F B6. 00
        cmp     al, 61                                  ; 10A4 _ 3C, 3D
        jnz     ?_072                                   ; 10A6 _ 75, 27
        mov     rax, qword [rel scan]                   ; 10A8 _ 48: 8B. 05, 00000000(rel)
        add     rax, 2                                  ; 10AF _ 48: 83. C0, 02
        mov     qword [rel scan], rax                   ; 10B3 _ 48: 89. 05, 00000000(rel)
        mov     rax, qword [rbp-28H]                    ; 10BA _ 48: 8B. 45, D8
        mov     dword [rax+24H], 61                     ; 10BE _ C7. 40, 24, 0000003D
        mov     eax, 61                                 ; 10C5 _ B8, 0000003D
        jmp     ?_081                                   ; 10CA _ E9, 0000024A

?_072:  mov     rax, qword [rel scan]                   ; 10CF _ 48: 8B. 05, 00000000(rel)
        movzx   eax, byte [rax]                         ; 10D6 _ 0F B6. 00
        cmp     al, 60                                  ; 10D9 _ 3C, 3C
        jnz     ?_073                                   ; 10DB _ 75, 39
        mov     rax, qword [rel scan]                   ; 10DD _ 48: 8B. 05, 00000000(rel)
        add     rax, 1                                  ; 10E4 _ 48: 83. C0, 01
        movzx   eax, byte [rax]                         ; 10E8 _ 0F B6. 00
        cmp     al, 62                                  ; 10EB _ 3C, 3E
        jnz     ?_073                                   ; 10ED _ 75, 27
        mov     rax, qword [rel scan]                   ; 10EF _ 48: 8B. 05, 00000000(rel)
        add     rax, 2                                  ; 10F6 _ 48: 83. C0, 02
        mov     qword [rel scan], rax                   ; 10FA _ 48: 89. 05, 00000000(rel)
        mov     rax, qword [rbp-28H]                    ; 1101 _ 48: 8B. 45, D8
        mov     dword [rax+24H], 263                    ; 1105 _ C7. 40, 24, 00000107
        mov     eax, 263                                ; 110C _ B8, 00000107
        jmp     ?_081                                   ; 1111 _ E9, 00000203

?_073:  mov     rax, qword [rel scan]                   ; 1116 _ 48: 8B. 05, 00000000(rel)
        movzx   eax, byte [rax]                         ; 111D _ 0F B6. 00
        cmp     al, 33                                  ; 1120 _ 3C, 21
        jnz     ?_074                                   ; 1122 _ 75, 39
        mov     rax, qword [rel scan]                   ; 1124 _ 48: 8B. 05, 00000000(rel)
        add     rax, 1                                  ; 112B _ 48: 83. C0, 01
        movzx   eax, byte [rax]                         ; 112F _ 0F B6. 00
        cmp     al, 61                                  ; 1132 _ 3C, 3D
        jnz     ?_074                                   ; 1134 _ 75, 27
        mov     rax, qword [rel scan]                   ; 1136 _ 48: 8B. 05, 00000000(rel)
        add     rax, 2                                  ; 113D _ 48: 83. C0, 02
        mov     qword [rel scan], rax                   ; 1141 _ 48: 89. 05, 00000000(rel)
        mov     rax, qword [rbp-28H]                    ; 1148 _ 48: 8B. 45, D8
        mov     dword [rax+24H], 263                    ; 114C _ C7. 40, 24, 00000107
        mov     eax, 263                                ; 1153 _ B8, 00000107
        jmp     ?_081                                   ; 1158 _ E9, 000001BC

?_074:  mov     rax, qword [rel scan]                   ; 115D _ 48: 8B. 05, 00000000(rel)
        movzx   eax, byte [rax]                         ; 1164 _ 0F B6. 00
        cmp     al, 60                                  ; 1167 _ 3C, 3C
        jnz     ?_076                                   ; 1169 _ 75, 72
        mov     rax, qword [rel scan]                   ; 116B _ 48: 8B. 05, 00000000(rel)
        add     rax, 1                                  ; 1172 _ 48: 83. C0, 01
        movzx   eax, byte [rax]                         ; 1176 _ 0F B6. 00
        cmp     al, 61                                  ; 1179 _ 3C, 3D
        jnz     ?_076                                   ; 117B _ 75, 60
        mov     rax, qword [rel scan]                   ; 117D _ 48: 8B. 05, 00000000(rel)
        add     rax, 2                                  ; 1184 _ 48: 83. C0, 02
        movzx   eax, byte [rax]                         ; 1188 _ 0F B6. 00
        cmp     al, 62                                  ; 118B _ 3C, 3E
        jnz     ?_075                                   ; 118D _ 75, 27
        mov     rax, qword [rel scan]                   ; 118F _ 48: 8B. 05, 00000000(rel)
        add     rax, 3                                  ; 1196 _ 48: 83. C0, 03
        mov     qword [rel scan], rax                   ; 119A _ 48: 89. 05, 00000000(rel)
        mov     rax, qword [rbp-28H]                    ; 11A1 _ 48: 8B. 45, D8
        mov     dword [rax+24H], 264                    ; 11A5 _ C7. 40, 24, 00000108
        mov     eax, 264                                ; 11AC _ B8, 00000108
        jmp     ?_081                                   ; 11B1 _ E9, 00000163

?_075:  mov     rax, qword [rel scan]                   ; 11B6 _ 48: 8B. 05, 00000000(rel)
        add     rax, 2                                  ; 11BD _ 48: 83. C0, 02
        mov     qword [rel scan], rax                   ; 11C1 _ 48: 89. 05, 00000000(rel)
        mov     rax, qword [rbp-28H]                    ; 11C8 _ 48: 8B. 45, D8
        mov     dword [rax+24H], 262                    ; 11CC _ C7. 40, 24, 00000106
        mov     eax, 262                                ; 11D3 _ B8, 00000106
        jmp     ?_081                                   ; 11D8 _ E9, 0000013C

?_076:  mov     rax, qword [rel scan]                   ; 11DD _ 48: 8B. 05, 00000000(rel)
        movzx   eax, byte [rax]                         ; 11E4 _ 0F B6. 00
        cmp     al, 62                                  ; 11E7 _ 3C, 3E
        jnz     ?_077                                   ; 11E9 _ 75, 39
        mov     rax, qword [rel scan]                   ; 11EB _ 48: 8B. 05, 00000000(rel)
        add     rax, 1                                  ; 11F2 _ 48: 83. C0, 01
        movzx   eax, byte [rax]                         ; 11F6 _ 0F B6. 00
        cmp     al, 61                                  ; 11F9 _ 3C, 3D
        jnz     ?_077                                   ; 11FB _ 75, 27
        mov     rax, qword [rel scan]                   ; 11FD _ 48: 8B. 05, 00000000(rel)
        add     rax, 2                                  ; 1204 _ 48: 83. C0, 02
        mov     qword [rel scan], rax                   ; 1208 _ 48: 89. 05, 00000000(rel)
        mov     rax, qword [rbp-28H]                    ; 120F _ 48: 8B. 45, D8
        mov     dword [rax+24H], 261                    ; 1213 _ C7. 40, 24, 00000105
        mov     eax, 261                                ; 121A _ B8, 00000105
        jmp     ?_081                                   ; 121F _ E9, 000000F5

?_077:  mov     rax, qword [rel scan]                   ; 1224 _ 48: 8B. 05, 00000000(rel)
        movzx   eax, byte [rax]                         ; 122B _ 0F B6. 00
        cmp     al, 38                                  ; 122E _ 3C, 26
        jnz     ?_078                                   ; 1230 _ 75, 39
        mov     rax, qword [rel scan]                   ; 1232 _ 48: 8B. 05, 00000000(rel)
        add     rax, 1                                  ; 1239 _ 48: 83. C0, 01
        movzx   eax, byte [rax]                         ; 123D _ 0F B6. 00
        cmp     al, 38                                  ; 1240 _ 3C, 26
        jnz     ?_078                                   ; 1242 _ 75, 27
        mov     rax, qword [rel scan]                   ; 1244 _ 48: 8B. 05, 00000000(rel)
        add     rax, 2                                  ; 124B _ 48: 83. C0, 02
        mov     qword [rel scan], rax                   ; 124F _ 48: 89. 05, 00000000(rel)
        mov     rax, qword [rbp-28H]                    ; 1256 _ 48: 8B. 45, D8
        mov     dword [rax+24H], 265                    ; 125A _ C7. 40, 24, 00000109
        mov     eax, 265                                ; 1261 _ B8, 00000109
        jmp     ?_081                                   ; 1266 _ E9, 000000AE

?_078:  mov     rax, qword [rel scan]                   ; 126B _ 48: 8B. 05, 00000000(rel)
        movzx   eax, byte [rax]                         ; 1272 _ 0F B6. 00
        cmp     al, 94                                  ; 1275 _ 3C, 5E
        jnz     ?_079                                   ; 1277 _ 75, 36
        mov     rax, qword [rel scan]                   ; 1279 _ 48: 8B. 05, 00000000(rel)
        add     rax, 1                                  ; 1280 _ 48: 83. C0, 01
        movzx   eax, byte [rax]                         ; 1284 _ 0F B6. 00
        cmp     al, 94                                  ; 1287 _ 3C, 5E
        jnz     ?_079                                   ; 1289 _ 75, 24
        mov     rax, qword [rel scan]                   ; 128B _ 48: 8B. 05, 00000000(rel)
        add     rax, 2                                  ; 1292 _ 48: 83. C0, 02
        mov     qword [rel scan], rax                   ; 1296 _ 48: 89. 05, 00000000(rel)
        mov     rax, qword [rbp-28H]                    ; 129D _ 48: 8B. 45, D8
        mov     dword [rax+24H], 267                    ; 12A1 _ C7. 40, 24, 0000010B
        mov     eax, 267                                ; 12A8 _ B8, 0000010B
        jmp     ?_081                                   ; 12AD _ EB, 6A

?_079:  mov     rax, qword [rel scan]                   ; 12AF _ 48: 8B. 05, 00000000(rel)
        movzx   eax, byte [rax]                         ; 12B6 _ 0F B6. 00
        cmp     al, 124                                 ; 12B9 _ 3C, 7C
        jnz     ?_080                                   ; 12BB _ 75, 36
        mov     rax, qword [rel scan]                   ; 12BD _ 48: 8B. 05, 00000000(rel)
        add     rax, 1                                  ; 12C4 _ 48: 83. C0, 01
        movzx   eax, byte [rax]                         ; 12C8 _ 0F B6. 00
        cmp     al, 124                                 ; 12CB _ 3C, 7C
        jnz     ?_080                                   ; 12CD _ 75, 24
        mov     rax, qword [rel scan]                   ; 12CF _ 48: 8B. 05, 00000000(rel)
        add     rax, 2                                  ; 12D6 _ 48: 83. C0, 02
        mov     qword [rel scan], rax                   ; 12DA _ 48: 89. 05, 00000000(rel)
        mov     rax, qword [rbp-28H]                    ; 12E1 _ 48: 8B. 45, D8
        mov     dword [rax+24H], 266                    ; 12E5 _ C7. 40, 24, 0000010A
        mov     eax, 266                                ; 12EC _ B8, 0000010A
        jmp     ?_081                                   ; 12F1 _ EB, 26

?_080:  mov     rax, qword [rel scan]                   ; 12F3 _ 48: 8B. 05, 00000000(rel)
        lea     rdx, [rax+1H]                           ; 12FA _ 48: 8D. 50, 01
        mov     qword [rel scan], rdx                   ; 12FE _ 48: 89. 15, 00000000(rel)
        movzx   eax, byte [rax]                         ; 1305 _ 0F B6. 00
        movzx   edx, al                                 ; 1308 _ 0F B6. D0
        mov     rax, qword [rbp-28H]                    ; 130B _ 48: 8B. 45, D8
        mov     dword [rax+24H], edx                    ; 130F _ 89. 50, 24
        mov     rax, qword [rbp-28H]                    ; 1312 _ 48: 8B. 45, D8
        mov     eax, dword [rax+24H]                    ; 1316 _ 8B. 40, 24
?_081:  mov     rdx, qword [rbp-8H]                     ; 1319 _ 48: 8B. 55, F8
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        sub     rdx, qword [fs:abs 28H]                 ; 131D _ 64 48: 2B. 14 25, 00000028
        jz      ?_082                                   ; 1326 _ 74, 05
        call    __stack_chk_fail                        ; 1328 _ E8, 00000000(PLT r)
?_082:  leave                                           ; 132D _ C9
        ret                                             ; 132E _ C3


SECTION .data   align=1 noexec                          ; section number 2, data


SECTION .bss    align=16 noexec                         ; section number 3, bss

scan:                                                   ; byte
        resq    1                                       ; 0000

?_083:  resq    1                                       ; 0008

?_084:  resq    1                                       ; 0010

stdscan_tempstorage:                                    ; qword
        resq    1                                       ; 0018

stdscan_tempsize:                                       ; dword
        resd    1                                       ; 0020

stdscan_templen:                                        ; dword
        resd    1                                       ; 0024


SECTION .rodata align=8 noexec                          ; section number 4, const

?_085:                                                  ; byte
        db 75H, 6EH, 74H, 65H, 72H, 6DH, 69H, 6EH       ; 0000 _ untermin
        db 61H, 74H, 65H, 64H, 20H, 62H, 72H, 61H       ; 0008 _ ated bra
        db 63H, 65H, 73H, 20H, 61H, 74H, 20H, 65H       ; 0010 _ ces at e
        db 6EH, 64H, 20H, 6FH, 66H, 20H, 6CH, 69H       ; 0018 _ nd of li
        db 6EH, 65H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0020 _ ne......

?_086:                                                  ; byte
        db 60H, 7BH, 25H, 73H, 7DH, 27H, 20H, 69H       ; 0028 _ `{%s}' i
        db 73H, 20H, 6EH, 6FH, 74H, 20H, 61H, 20H       ; 0030 _ s not a 
        db 76H, 61H, 6CH, 69H, 64H, 20H, 62H, 72H       ; 0038 _ valid br
        db 61H, 63H, 65H, 20H, 74H, 6FH, 6BH, 65H       ; 0040 _ ace toke
        db 6EH, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0048 _ n.......

?_087:                                                  ; byte
        db 69H, 6EH, 76H, 61H, 6CH, 69H, 64H, 20H       ; 0050 _ invalid 
        db 63H, 68H, 61H, 72H, 61H, 63H, 74H, 65H       ; 0058 _ characte
        db 72H, 20H, 60H, 25H, 63H, 27H, 20H, 69H       ; 0060 _ r `%c' i
        db 6EH, 20H, 62H, 72H, 61H, 63H, 65H, 20H       ; 0068 _ n brace 
        db 73H, 65H, 71H, 75H, 65H, 6EH, 63H, 65H       ; 0070 _ sequence
        db 00H                                          ; 0078 _ .

?_088:                                                  ; byte
        db 60H, 25H, 73H, 27H, 20H, 69H, 73H, 20H       ; 0079 _ `%s' is 
        db 6EH, 6FH, 74H, 20H, 61H, 20H, 4EH, 41H       ; 0081 _ not a NA
        db 53H, 4DH, 20H, 6BH, 65H, 79H, 77H, 6FH       ; 0089 _ SM keywo
        db 72H, 64H, 00H                                ; 0091 _ rd.


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
        dd 00000021H, 100E4100H                         ; 0064 _ 33 269369600 
        dd 0D430286H, 070C5C06H                         ; 006C _ 222495366 118250502 
        dd 00000008H, 0000001CH                         ; 0074 _ 8 28 
        dd 0000007CH                                    ; 007C _ 124 
        dd nasm_ctype-$-11H                             ; 0080 _ 00000000 (rel)
        dd 00000021H, 100E4100H                         ; 0084 _ 33 269369600 
        dd 0D430286H, 070C5C06H                         ; 008C _ 222495366 118250502 
        dd 00000008H, 0000001CH                         ; 0094 _ 8 28 
        dd 0000009CH                                    ; 009C _ 156 
        dd nasm_ctype-$-10H                             ; 00A0 _ 00000000 (rel)
        dd 00000021H, 100E4100H                         ; 00A4 _ 33 269369600 
        dd 0D430286H, 070C5C06H                         ; 00AC _ 222495366 118250502 
        dd 00000008H, 0000001CH                         ; 00B4 _ 8 28 
        dd 000000BCH                                    ; 00BC _ 188 
        dd nasm_ctype-$-0FH                             ; 00C0 _ 00000000 (rel)
        dd 00000021H, 100E4100H                         ; 00C4 _ 33 269369600 
        dd 0D430286H, 070C5C06H                         ; 00CC _ 222495366 118250502 
        dd 00000008H, 0000001CH                         ; 00D4 _ 8 28 
        dd 000000DCH                                    ; 00DC _ 220 
        dd nasm_ctype-$-0EH                             ; 00E0 _ 00000000 (rel)
        dd 00000021H, 100E4100H                         ; 00E4 _ 33 269369600 
        dd 0D430286H, 070C5C06H                         ; 00EC _ 222495366 118250502 
        dd 00000008H, 0000001CH                         ; 00F4 _ 8 28 
        dd 000000FCH                                    ; 00FC _ 252 
        dd nasm_ctype-$-0DH                             ; 0100 _ 00000000 (rel)
        dd 0000001FH, 100E4100H                         ; 0104 _ 31 269369600 
        dd 0D430286H, 070C5A06H                         ; 010C _ 222495366 118249990 
        dd 00000008H, 0000001CH                         ; 0114 _ 8 28 
        dd 0000011CH                                    ; 011C _ 284 
        dd nasm_ctype-$-0EH                             ; 0120 _ 00000000 (rel)
        dd 00000027H, 100E4100H                         ; 0124 _ 39 269369600 
        dd 0D430286H, 070C6206H                         ; 012C _ 222495366 118252038 
        dd 00000008H, 0000001CH                         ; 0134 _ 8 28 
        dd 0000013CH                                    ; 013C _ 316 
        dd nasm_ctype-$-7H                              ; 0140 _ 00000000 (rel)
        dd 00000050H, 100E4100H                         ; 0144 _ 80 269369600 
        dd 0D430286H, 0C4B0206H                         ; 014C _ 222495366 206242310 
        dd 00000807H, 0000001CH                         ; 0154 _ 2055 28 
        dd 0000015CH                                    ; 015C _ 348 
        dd nasm_ctype-$+29H                             ; 0160 _ 00000000 (rel)
        dd 00000033H, 100E4100H                         ; 0164 _ 51 269369600 
        dd 0D430286H, 070C6E06H                         ; 016C _ 222495366 118255110 
        dd 00000008H, 0000001CH                         ; 0174 _ 8 28 
        dd 0000017CH                                    ; 017C _ 380 
        dd nasm_ctype-$+3CH                             ; 0180 _ 00000000 (rel)
        dd 0000002FH, 100E4100H                         ; 0184 _ 47 269369600 
        dd 0D430286H, 070C6A06H                         ; 018C _ 222495366 118254086 
        dd 00000008H, 0000001CH                         ; 0194 _ 8 28 
        dd 0000019CH                                    ; 019C _ 412 
        dd nasm_ctype-$+4BH                             ; 01A0 _ 00000000 (rel)
        dd 00000040H, 100E4100H                         ; 01A4 _ 64 269369600 
        dd 0D430286H, 070C7B06H                         ; 01AC _ 222495366 118258438 
        dd 00000008H, 0000001CH                         ; 01B4 _ 8 28 
        dd 000001BCH                                    ; 01BC _ 444 
        dd nasm_ctype-$+6BH                             ; 01C0 _ 00000000 (rel)
        dd 0000000DH, 100E4100H                         ; 01C4 _ 13 269369600 
        dd 0D430286H, 070C4806H                         ; 01CC _ 222495366 118245382 
        dd 00000008H, 0000001CH                         ; 01D4 _ 8 28 
        dd 000001DCH                                    ; 01DC _ 476 
        dd nasm_ctype-$+58H                             ; 01E0 _ 00000000 (rel)
        dd 00000038H, 100E4100H                         ; 01E4 _ 56 269369600 
        dd 0D430286H, 070C7306H                         ; 01EC _ 222495366 118256390 
        dd 00000008H, 0000001CH                         ; 01F4 _ 8 28 
        dd 000001FCH                                    ; 01FC _ 508 
        dd nasm_ctype-$+70H                             ; 0200 _ 00000000 (rel)
        dd 00000033H, 100E4100H                         ; 0204 _ 51 269369600 
        dd 0D430286H, 070C6E06H                         ; 020C _ 222495366 118255110 
        dd 00000008H, 0000001CH                         ; 0214 _ 8 28 
        dd 0000021CH                                    ; 021C _ 540 
        dd nasm_ctype-$+83H                             ; 0220 _ 00000000 (rel)
        dd 00000048H, 100E4100H                         ; 0224 _ 72 269369600 
        dd 0D430286H, 0C430206H                         ; 022C _ 222495366 205718022 
        dd 00000807H, 0000001CH                         ; 0234 _ 2055 28 
        dd 0000023CH                                    ; 023C _ 572 
        dd nasm_ctype-$+0ABH                            ; 0240 _ 00000000 (rel)
        dd 00000020H, 100E4100H                         ; 0244 _ 32 269369600 
        dd 0D430286H, 070C5B06H                         ; 024C _ 222495366 118250246 
        dd 00000008H, 0000001CH                         ; 0254 _ 8 28 
        dd 0000025CH                                    ; 025C _ 604 
        dd nasm_ctype-$+0ABH                            ; 0260 _ 00000000 (rel)
        dd 00000093H, 100E4100H                         ; 0264 _ 147 269369600 
        dd 0D430286H, 0C8E0206H                         ; 026C _ 222495366 210633222 
        dd 00000807H, 0000001CH                         ; 0274 _ 2055 28 
        dd 0000027CH                                    ; 027C _ 636 
        dd nasm_ctype-$+11EH                            ; 0280 _ 00000000 (rel)
        dd 00000052H, 100E4100H                         ; 0284 _ 82 269369600 
        dd 0D430286H, 0C4D0206H                         ; 028C _ 222495366 206373382 
        dd 00000807H, 00000020H                         ; 0294 _ 2055 32 
        dd 0000029CH                                    ; 029C _ 668 
        dd nasm_ctype-$+150H                            ; 02A0 _ 00000000 (rel)
        dd 00000072H, 100E4100H                         ; 02A4 _ 114 269369600 
        dd 0D430286H, 03834506H                         ; 02AC _ 222495366 58934534 
        dd 070C6802H, 00000008H                         ; 02B4 _ 118253570 8 
        dd 0000001CH, 000002C0H                         ; 02BC _ 28 704 
        dd nasm_ctype-$+19EH                            ; 02C4 _ 00000000 (rel)
        dd 00000403H, 100E4100H                         ; 02C8 _ 1027 269369600 
        dd 0D430286H, 03FE0306H                         ; 02D0 _ 222495366 66978566 
        dd 0008070CH, 00000020H                         ; 02D8 _ 526092 32 
        dd 000002E0H                                    ; 02E0 _ 736 
        dd nasm_ctype-$+581H                            ; 02E4 _ 00000000 (rel)
        dd 000000FDH, 100E4100H                         ; 02E8 _ 253 269369600 
        dd 0D430286H, 03834506H                         ; 02F0 _ 222495366 58934534 
        dd 070CF302H, 00000008H                         ; 02F8 _ 118289154 8 
        dd 0000001CH, 00000304H                         ; 0300 _ 28 772 
        dd nasm_ctype-$+65AH                            ; 0308 _ 00000000 (rel)
        dd 000000A4H, 100E4100H                         ; 030C _ 164 269369600 
        dd 0D430286H, 0C9F0206H                         ; 0314 _ 222495366 211747334 
        dd 00000807H, 0000001CH                         ; 031C _ 2055 28 
        dd 00000324H                                    ; 0324 _ 804 
        dd nasm_ctype-$+6DEH                            ; 0328 _ 00000000 (rel)
        dd 00000929H, 100E4100H                         ; 032C _ 2345 269369600 
        dd 0D430286H, 09240306H                         ; 0334 _ 222495366 153355014 
        dd 0008070CH                                    ; 033C _ 526092 


