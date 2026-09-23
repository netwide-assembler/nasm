; Disassembly of file: /tmp/tmp.9qWOo6okP5.o
; Wed Sep 23 14:43:20 2026
; Type: ELF64
; Syntax: NASM
; Instruction set: SSE, x64

default rel

global nasm_error: function
global nasm_listmsgf: function
global nasm_listmsg: function
global nasm_notef: function
global nasm_note: function
global nasm_nonfatalf: function
global nasm_nonfatal: function
global nasm_fatalf: function
global nasm_fatal: function
global nasm_criticalf: function
global nasm_critical: function
global nasm_panicf: function
global nasm_panic: function
global nasm_warn_: function
global nasm_info_: function
global nasm_debug_: function
global nasm_holderr: function
global nasm_panic_from_macro: function
global nasm_assert_failed: function
global erropt

extern __stack_chk_fail                                 ; near
extern nasm_verror                                      ; near
extern nasm_verror_critical                             ; near


SECTION .text   align=1 exec                            ; section number 1, code

debug_level:; Local function
        push    rbp                                     ; 0000 _ 55
        mov     rbp, rsp                                ; 0001 _ 48: 89. E5
        mov     dword [rbp-4H], edi                     ; 0004 _ 89. 7D, FC
        mov     eax, dword [rel erropt+10H]             ; 0007 _ 8B. 05, 00000000(rel)
        cmp     eax, dword [rbp-4H]                     ; 000D _ 3B. 45, FC
        setae   al                                      ; 0010 _ 0F 93. C0
        movzx   eax, al                                 ; 0013 _ 0F B6. C0
        test    rax, rax                                ; 0016 _ 48: 85. C0
        setne   al                                      ; 0019 _ 0F 95. C0
        pop     rbp                                     ; 001C _ 5D
        ret                                             ; 001D _ C3

info_level:; Local function
        push    rbp                                     ; 001E _ 55
        mov     rbp, rsp                                ; 001F _ 48: 89. E5
        mov     dword [rbp-4H], edi                     ; 0022 _ 89. 7D, FC
        mov     eax, dword [rel erropt+14H]             ; 0025 _ 8B. 05, 00000000(rel)
        cmp     eax, dword [rbp-4H]                     ; 002B _ 3B. 45, FC
        setae   al                                      ; 002E _ 0F 93. C0
        movzx   eax, al                                 ; 0031 _ 0F B6. C0
        test    rax, rax                                ; 0034 _ 48: 85. C0
        setne   al                                      ; 0037 _ 0F 95. C0
        pop     rbp                                     ; 003A _ 5D
        ret                                             ; 003B _ C3

nasm_error:; Function begin
        push    rbp                                     ; 003C _ 55
        mov     rbp, rsp                                ; 003D _ 48: 89. E5
        sub     rsp, 240                                ; 0040 _ 48: 81. EC, 000000F0
        mov     dword [rbp-0E4H], edi                   ; 0047 _ 89. BD, FFFFFF1C
        mov     qword [rbp-0F0H], rsi                   ; 004D _ 48: 89. B5, FFFFFF10
        mov     qword [rbp-0A0H], rdx                   ; 0054 _ 48: 89. 95, FFFFFF60
        mov     qword [rbp-98H], rcx                    ; 005B _ 48: 89. 8D, FFFFFF68
        mov     qword [rbp-90H], r8                     ; 0062 _ 4C: 89. 85, FFFFFF70
        mov     qword [rbp-88H], r9                     ; 0069 _ 4C: 89. 8D, FFFFFF78
        test    al, al                                  ; 0070 _ 84. C0
        jz      ?_001                                   ; 0072 _ 74, 20
        movaps  oword [rbp-80H], xmm0                   ; 0074 _ 0F 29. 45, 80
        movaps  oword [rbp-70H], xmm1                   ; 0078 _ 0F 29. 4D, 90
        movaps  oword [rbp-60H], xmm2                   ; 007C _ 0F 29. 55, A0
        movaps  oword [rbp-50H], xmm3                   ; 0080 _ 0F 29. 5D, B0
        movaps  oword [rbp-40H], xmm4                   ; 0084 _ 0F 29. 65, C0
        movaps  oword [rbp-30H], xmm5                   ; 0088 _ 0F 29. 6D, D0
        movaps  oword [rbp-20H], xmm6                   ; 008C _ 0F 29. 75, E0
        movaps  oword [rbp-10H], xmm7                   ; 0090 _ 0F 29. 7D, F0
?_001:
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        mov     rax, qword [fs:abs 28H]                 ; 0094 _ 64 48: 8B. 04 25, 00000028
        mov     qword [rbp-0B8H], rax                   ; 009D _ 48: 89. 85, FFFFFF48
        xor     eax, eax                                ; 00A4 _ 31. C0
        mov     eax, dword [rbp-0E4H]                   ; 00A6 _ 8B. 85, FFFFFF1C
        and     eax, 0FH                                ; 00AC _ 83. E0, 0F
        mov     dword [rbp-0D8H], eax                   ; 00AF _ 89. 85, FFFFFF28
        mov     eax, dword [rbp-0D8H]                   ; 00B5 _ 8B. 85, FFFFFF28
        or      eax, dword [rbp-0E4H]                   ; 00BB _ 0B. 85, FFFFFF1C
        mov     dword [rbp-0D4H], eax                   ; 00C1 _ 89. 85, FFFFFF2C
        mov     dword [rbp-0D0H], 16                    ; 00C7 _ C7. 85, FFFFFF30, 00000010
        mov     dword [rbp-0CCH], 48                    ; 00D1 _ C7. 85, FFFFFF34, 00000030
        lea     rax, [rbp+10H]                          ; 00DB _ 48: 8D. 45, 10
        mov     qword [rbp-0C8H], rax                   ; 00DF _ 48: 89. 85, FFFFFF38
        lea     rax, [rbp-0B0H]                         ; 00E6 _ 48: 8D. 85, FFFFFF50
        mov     qword [rbp-0C0H], rax                   ; 00ED _ 48: 89. 85, FFFFFF40
        cmp     dword [rbp-0D8H], 13                    ; 00F4 _ 83. BD, FFFFFF28, 0D
        jbe     ?_002                                   ; 00FB _ 76, 1E
        lea     rdx, [rbp-0D0H]                         ; 00FD _ 48: 8D. 95, FFFFFF30
        mov     rcx, qword [rbp-0F0H]                   ; 0104 _ 48: 8B. 8D, FFFFFF10
        mov     eax, dword [rbp-0D4H]                   ; 010B _ 8B. 85, FFFFFF2C
        mov     rsi, rcx                                ; 0111 _ 48: 89. CE
        mov     edi, eax                                ; 0114 _ 89. C7
        call    nasm_verror_critical                    ; 0116 _ E8, 00000000(PLT r)
?_002:  lea     rdx, [rbp-0D0H]                         ; 011B _ 48: 8D. 95, FFFFFF30
        mov     rcx, qword [rbp-0F0H]                   ; 0122 _ 48: 8B. 8D, FFFFFF10
        mov     eax, dword [rbp-0D4H]                   ; 0129 _ 8B. 85, FFFFFF2C
        mov     rsi, rcx                                ; 012F _ 48: 89. CE
        mov     edi, eax                                ; 0132 _ 89. C7
        call    nasm_verror                             ; 0134 _ E8, 00000000(PLT r)
        cmp     dword [rbp-0D8H], 11                    ; 0139 _ 83. BD, FFFFFF28, 0B
        nop                                             ; 0140 _ 90
        mov     rax, qword [rbp-0B8H]                   ; 0141 _ 48: 8B. 85, FFFFFF48
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        sub     rax, qword [fs:abs 28H]                 ; 0148 _ 64 48: 2B. 04 25, 00000028
        jz      ?_003                                   ; 0151 _ 74, 05
        call    __stack_chk_fail                        ; 0153 _ E8, 00000000(PLT r)
?_003:  leave                                           ; 0158 _ C9
        ret                                             ; 0159 _ C3
; nasm_error End of function

nasm_listmsgf:; Function begin
        push    rbp                                     ; 015A _ 55
        mov     rbp, rsp                                ; 015B _ 48: 89. E5
        sub     rsp, 240                                ; 015E _ 48: 81. EC, 000000F0
        mov     dword [rbp-0E4H], edi                   ; 0165 _ 89. BD, FFFFFF1C
        mov     qword [rbp-0F0H], rsi                   ; 016B _ 48: 89. B5, FFFFFF10
        mov     qword [rbp-0A0H], rdx                   ; 0172 _ 48: 89. 95, FFFFFF60
        mov     qword [rbp-98H], rcx                    ; 0179 _ 48: 89. 8D, FFFFFF68
        mov     qword [rbp-90H], r8                     ; 0180 _ 4C: 89. 85, FFFFFF70
        mov     qword [rbp-88H], r9                     ; 0187 _ 4C: 89. 8D, FFFFFF78
        test    al, al                                  ; 018E _ 84. C0
        jz      ?_004                                   ; 0190 _ 74, 20
        movaps  oword [rbp-80H], xmm0                   ; 0192 _ 0F 29. 45, 80
        movaps  oword [rbp-70H], xmm1                   ; 0196 _ 0F 29. 4D, 90
        movaps  oword [rbp-60H], xmm2                   ; 019A _ 0F 29. 55, A0
        movaps  oword [rbp-50H], xmm3                   ; 019E _ 0F 29. 5D, B0
        movaps  oword [rbp-40H], xmm4                   ; 01A2 _ 0F 29. 65, C0
        movaps  oword [rbp-30H], xmm5                   ; 01A6 _ 0F 29. 6D, D0
        movaps  oword [rbp-20H], xmm6                   ; 01AA _ 0F 29. 75, E0
        movaps  oword [rbp-10H], xmm7                   ; 01AE _ 0F 29. 7D, F0
?_004:
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        mov     rax, qword [fs:abs 28H]                 ; 01B2 _ 64 48: 8B. 04 25, 00000028
        mov     qword [rbp-0B8H], rax                   ; 01BB _ 48: 89. 85, FFFFFF48
        xor     eax, eax                                ; 01C2 _ 31. C0
        mov     dword [rbp-0D8H], 0                     ; 01C4 _ C7. 85, FFFFFF28, 00000000
        mov     eax, dword [rbp-0D8H]                   ; 01CE _ 8B. 85, FFFFFF28
        or      eax, dword [rbp-0E4H]                   ; 01D4 _ 0B. 85, FFFFFF1C
        mov     dword [rbp-0D4H], eax                   ; 01DA _ 89. 85, FFFFFF2C
        mov     dword [rbp-0D0H], 16                    ; 01E0 _ C7. 85, FFFFFF30, 00000010
        mov     dword [rbp-0CCH], 48                    ; 01EA _ C7. 85, FFFFFF34, 00000030
        lea     rax, [rbp+10H]                          ; 01F4 _ 48: 8D. 45, 10
        mov     qword [rbp-0C8H], rax                   ; 01F8 _ 48: 89. 85, FFFFFF38
        lea     rax, [rbp-0B0H]                         ; 01FF _ 48: 8D. 85, FFFFFF50
        mov     qword [rbp-0C0H], rax                   ; 0206 _ 48: 89. 85, FFFFFF40
        cmp     dword [rbp-0D8H], 13                    ; 020D _ 83. BD, FFFFFF28, 0D
        jbe     ?_005                                   ; 0214 _ 76, 1E
        lea     rdx, [rbp-0D0H]                         ; 0216 _ 48: 8D. 95, FFFFFF30
        mov     rcx, qword [rbp-0F0H]                   ; 021D _ 48: 8B. 8D, FFFFFF10
        mov     eax, dword [rbp-0D4H]                   ; 0224 _ 8B. 85, FFFFFF2C
        mov     rsi, rcx                                ; 022A _ 48: 89. CE
        mov     edi, eax                                ; 022D _ 89. C7
        call    nasm_verror_critical                    ; 022F _ E8, 00000000(PLT r)
?_005:  lea     rdx, [rbp-0D0H]                         ; 0234 _ 48: 8D. 95, FFFFFF30
        mov     rcx, qword [rbp-0F0H]                   ; 023B _ 48: 8B. 8D, FFFFFF10
        mov     eax, dword [rbp-0D4H]                   ; 0242 _ 8B. 85, FFFFFF2C
        mov     rsi, rcx                                ; 0248 _ 48: 89. CE
        mov     edi, eax                                ; 024B _ 89. C7
        call    nasm_verror                             ; 024D _ E8, 00000000(PLT r)
        cmp     dword [rbp-0D8H], 11                    ; 0252 _ 83. BD, FFFFFF28, 0B
        nop                                             ; 0259 _ 90
        mov     rax, qword [rbp-0B8H]                   ; 025A _ 48: 8B. 85, FFFFFF48
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        sub     rax, qword [fs:abs 28H]                 ; 0261 _ 64 48: 2B. 04 25, 00000028
        jz      ?_006                                   ; 026A _ 74, 05
        call    __stack_chk_fail                        ; 026C _ E8, 00000000(PLT r)
?_006:  leave                                           ; 0271 _ C9
        ret                                             ; 0272 _ C3
; nasm_listmsgf End of function

nasm_listmsg:; Function begin
        push    rbp                                     ; 0273 _ 55
        mov     rbp, rsp                                ; 0274 _ 48: 89. E5
        sub     rsp, 240                                ; 0277 _ 48: 81. EC, 000000F0
        mov     qword [rbp-0E8H], rdi                   ; 027E _ 48: 89. BD, FFFFFF18
        mov     qword [rbp-0A8H], rsi                   ; 0285 _ 48: 89. B5, FFFFFF58
        mov     qword [rbp-0A0H], rdx                   ; 028C _ 48: 89. 95, FFFFFF60
        mov     qword [rbp-98H], rcx                    ; 0293 _ 48: 89. 8D, FFFFFF68
        mov     qword [rbp-90H], r8                     ; 029A _ 4C: 89. 85, FFFFFF70
        mov     qword [rbp-88H], r9                     ; 02A1 _ 4C: 89. 8D, FFFFFF78
        test    al, al                                  ; 02A8 _ 84. C0
        jz      ?_007                                   ; 02AA _ 74, 20
        movaps  oword [rbp-80H], xmm0                   ; 02AC _ 0F 29. 45, 80
        movaps  oword [rbp-70H], xmm1                   ; 02B0 _ 0F 29. 4D, 90
        movaps  oword [rbp-60H], xmm2                   ; 02B4 _ 0F 29. 55, A0
        movaps  oword [rbp-50H], xmm3                   ; 02B8 _ 0F 29. 5D, B0
        movaps  oword [rbp-40H], xmm4                   ; 02BC _ 0F 29. 65, C0
        movaps  oword [rbp-30H], xmm5                   ; 02C0 _ 0F 29. 6D, D0
        movaps  oword [rbp-20H], xmm6                   ; 02C4 _ 0F 29. 75, E0
        movaps  oword [rbp-10H], xmm7                   ; 02C8 _ 0F 29. 7D, F0
?_007:
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        mov     rax, qword [fs:abs 28H]                 ; 02CC _ 64 48: 8B. 04 25, 00000028
        mov     qword [rbp-0B8H], rax                   ; 02D5 _ 48: 89. 85, FFFFFF48
        xor     eax, eax                                ; 02DC _ 31. C0
        mov     dword [rbp-0D8H], 0                     ; 02DE _ C7. 85, FFFFFF28, 00000000
        mov     eax, dword [rbp-0D8H]                   ; 02E8 _ 8B. 85, FFFFFF28
        mov     dword [rbp-0D4H], eax                   ; 02EE _ 89. 85, FFFFFF2C
        mov     dword [rbp-0D0H], 8                     ; 02F4 _ C7. 85, FFFFFF30, 00000008
        mov     dword [rbp-0CCH], 48                    ; 02FE _ C7. 85, FFFFFF34, 00000030
        lea     rax, [rbp+10H]                          ; 0308 _ 48: 8D. 45, 10
        mov     qword [rbp-0C8H], rax                   ; 030C _ 48: 89. 85, FFFFFF38
        lea     rax, [rbp-0B0H]                         ; 0313 _ 48: 8D. 85, FFFFFF50
        mov     qword [rbp-0C0H], rax                   ; 031A _ 48: 89. 85, FFFFFF40
        cmp     dword [rbp-0D8H], 13                    ; 0321 _ 83. BD, FFFFFF28, 0D
        jbe     ?_008                                   ; 0328 _ 76, 1E
        lea     rdx, [rbp-0D0H]                         ; 032A _ 48: 8D. 95, FFFFFF30
        mov     rcx, qword [rbp-0E8H]                   ; 0331 _ 48: 8B. 8D, FFFFFF18
        mov     eax, dword [rbp-0D4H]                   ; 0338 _ 8B. 85, FFFFFF2C
        mov     rsi, rcx                                ; 033E _ 48: 89. CE
        mov     edi, eax                                ; 0341 _ 89. C7
        call    nasm_verror_critical                    ; 0343 _ E8, 00000000(PLT r)
?_008:  lea     rdx, [rbp-0D0H]                         ; 0348 _ 48: 8D. 95, FFFFFF30
        mov     rcx, qword [rbp-0E8H]                   ; 034F _ 48: 8B. 8D, FFFFFF18
        mov     eax, dword [rbp-0D4H]                   ; 0356 _ 8B. 85, FFFFFF2C
        mov     rsi, rcx                                ; 035C _ 48: 89. CE
        mov     edi, eax                                ; 035F _ 89. C7
        call    nasm_verror                             ; 0361 _ E8, 00000000(PLT r)
        cmp     dword [rbp-0D8H], 11                    ; 0366 _ 83. BD, FFFFFF28, 0B
        nop                                             ; 036D _ 90
        mov     rax, qword [rbp-0B8H]                   ; 036E _ 48: 8B. 85, FFFFFF48
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        sub     rax, qword [fs:abs 28H]                 ; 0375 _ 64 48: 2B. 04 25, 00000028
        jz      ?_009                                   ; 037E _ 74, 05
        call    __stack_chk_fail                        ; 0380 _ E8, 00000000(PLT r)
?_009:  leave                                           ; 0385 _ C9
        ret                                             ; 0386 _ C3
; nasm_listmsg End of function

nasm_notef:; Function begin
        push    rbp                                     ; 0387 _ 55
        mov     rbp, rsp                                ; 0388 _ 48: 89. E5
        sub     rsp, 240                                ; 038B _ 48: 81. EC, 000000F0
        mov     dword [rbp-0E4H], edi                   ; 0392 _ 89. BD, FFFFFF1C
        mov     qword [rbp-0F0H], rsi                   ; 0398 _ 48: 89. B5, FFFFFF10
        mov     qword [rbp-0A0H], rdx                   ; 039F _ 48: 89. 95, FFFFFF60
        mov     qword [rbp-98H], rcx                    ; 03A6 _ 48: 89. 8D, FFFFFF68
        mov     qword [rbp-90H], r8                     ; 03AD _ 4C: 89. 85, FFFFFF70
        mov     qword [rbp-88H], r9                     ; 03B4 _ 4C: 89. 8D, FFFFFF78
        test    al, al                                  ; 03BB _ 84. C0
        jz      ?_010                                   ; 03BD _ 74, 20
        movaps  oword [rbp-80H], xmm0                   ; 03BF _ 0F 29. 45, 80
        movaps  oword [rbp-70H], xmm1                   ; 03C3 _ 0F 29. 4D, 90
        movaps  oword [rbp-60H], xmm2                   ; 03C7 _ 0F 29. 55, A0
        movaps  oword [rbp-50H], xmm3                   ; 03CB _ 0F 29. 5D, B0
        movaps  oword [rbp-40H], xmm4                   ; 03CF _ 0F 29. 65, C0
        movaps  oword [rbp-30H], xmm5                   ; 03D3 _ 0F 29. 6D, D0
        movaps  oword [rbp-20H], xmm6                   ; 03D7 _ 0F 29. 75, E0
        movaps  oword [rbp-10H], xmm7                   ; 03DB _ 0F 29. 7D, F0
?_010:
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        mov     rax, qword [fs:abs 28H]                 ; 03DF _ 64 48: 8B. 04 25, 00000028
        mov     qword [rbp-0B8H], rax                   ; 03E8 _ 48: 89. 85, FFFFFF48
        xor     eax, eax                                ; 03EF _ 31. C0
        mov     dword [rbp-0D8H], 1                     ; 03F1 _ C7. 85, FFFFFF28, 00000001
        mov     eax, dword [rbp-0D8H]                   ; 03FB _ 8B. 85, FFFFFF28
        or      eax, dword [rbp-0E4H]                   ; 0401 _ 0B. 85, FFFFFF1C
        mov     dword [rbp-0D4H], eax                   ; 0407 _ 89. 85, FFFFFF2C
        mov     dword [rbp-0D0H], 16                    ; 040D _ C7. 85, FFFFFF30, 00000010
        mov     dword [rbp-0CCH], 48                    ; 0417 _ C7. 85, FFFFFF34, 00000030
        lea     rax, [rbp+10H]                          ; 0421 _ 48: 8D. 45, 10
        mov     qword [rbp-0C8H], rax                   ; 0425 _ 48: 89. 85, FFFFFF38
        lea     rax, [rbp-0B0H]                         ; 042C _ 48: 8D. 85, FFFFFF50
        mov     qword [rbp-0C0H], rax                   ; 0433 _ 48: 89. 85, FFFFFF40
        cmp     dword [rbp-0D8H], 13                    ; 043A _ 83. BD, FFFFFF28, 0D
        jbe     ?_011                                   ; 0441 _ 76, 1E
        lea     rdx, [rbp-0D0H]                         ; 0443 _ 48: 8D. 95, FFFFFF30
        mov     rcx, qword [rbp-0F0H]                   ; 044A _ 48: 8B. 8D, FFFFFF10
        mov     eax, dword [rbp-0D4H]                   ; 0451 _ 8B. 85, FFFFFF2C
        mov     rsi, rcx                                ; 0457 _ 48: 89. CE
        mov     edi, eax                                ; 045A _ 89. C7
        call    nasm_verror_critical                    ; 045C _ E8, 00000000(PLT r)
?_011:  lea     rdx, [rbp-0D0H]                         ; 0461 _ 48: 8D. 95, FFFFFF30
        mov     rcx, qword [rbp-0F0H]                   ; 0468 _ 48: 8B. 8D, FFFFFF10
        mov     eax, dword [rbp-0D4H]                   ; 046F _ 8B. 85, FFFFFF2C
        mov     rsi, rcx                                ; 0475 _ 48: 89. CE
        mov     edi, eax                                ; 0478 _ 89. C7
        call    nasm_verror                             ; 047A _ E8, 00000000(PLT r)
        cmp     dword [rbp-0D8H], 11                    ; 047F _ 83. BD, FFFFFF28, 0B
        nop                                             ; 0486 _ 90
        mov     rax, qword [rbp-0B8H]                   ; 0487 _ 48: 8B. 85, FFFFFF48
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        sub     rax, qword [fs:abs 28H]                 ; 048E _ 64 48: 2B. 04 25, 00000028
        jz      ?_012                                   ; 0497 _ 74, 05
        call    __stack_chk_fail                        ; 0499 _ E8, 00000000(PLT r)
?_012:  leave                                           ; 049E _ C9
        ret                                             ; 049F _ C3
; nasm_notef End of function

nasm_note:; Function begin
        push    rbp                                     ; 04A0 _ 55
        mov     rbp, rsp                                ; 04A1 _ 48: 89. E5
        sub     rsp, 240                                ; 04A4 _ 48: 81. EC, 000000F0
        mov     qword [rbp-0E8H], rdi                   ; 04AB _ 48: 89. BD, FFFFFF18
        mov     qword [rbp-0A8H], rsi                   ; 04B2 _ 48: 89. B5, FFFFFF58
        mov     qword [rbp-0A0H], rdx                   ; 04B9 _ 48: 89. 95, FFFFFF60
        mov     qword [rbp-98H], rcx                    ; 04C0 _ 48: 89. 8D, FFFFFF68
        mov     qword [rbp-90H], r8                     ; 04C7 _ 4C: 89. 85, FFFFFF70
        mov     qword [rbp-88H], r9                     ; 04CE _ 4C: 89. 8D, FFFFFF78
        test    al, al                                  ; 04D5 _ 84. C0
        jz      ?_013                                   ; 04D7 _ 74, 20
        movaps  oword [rbp-80H], xmm0                   ; 04D9 _ 0F 29. 45, 80
        movaps  oword [rbp-70H], xmm1                   ; 04DD _ 0F 29. 4D, 90
        movaps  oword [rbp-60H], xmm2                   ; 04E1 _ 0F 29. 55, A0
        movaps  oword [rbp-50H], xmm3                   ; 04E5 _ 0F 29. 5D, B0
        movaps  oword [rbp-40H], xmm4                   ; 04E9 _ 0F 29. 65, C0
        movaps  oword [rbp-30H], xmm5                   ; 04ED _ 0F 29. 6D, D0
        movaps  oword [rbp-20H], xmm6                   ; 04F1 _ 0F 29. 75, E0
        movaps  oword [rbp-10H], xmm7                   ; 04F5 _ 0F 29. 7D, F0
?_013:
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        mov     rax, qword [fs:abs 28H]                 ; 04F9 _ 64 48: 8B. 04 25, 00000028
        mov     qword [rbp-0B8H], rax                   ; 0502 _ 48: 89. 85, FFFFFF48
        xor     eax, eax                                ; 0509 _ 31. C0
        mov     dword [rbp-0D8H], 1                     ; 050B _ C7. 85, FFFFFF28, 00000001
        mov     eax, dword [rbp-0D8H]                   ; 0515 _ 8B. 85, FFFFFF28
        mov     dword [rbp-0D4H], eax                   ; 051B _ 89. 85, FFFFFF2C
        mov     dword [rbp-0D0H], 8                     ; 0521 _ C7. 85, FFFFFF30, 00000008
        mov     dword [rbp-0CCH], 48                    ; 052B _ C7. 85, FFFFFF34, 00000030
        lea     rax, [rbp+10H]                          ; 0535 _ 48: 8D. 45, 10
        mov     qword [rbp-0C8H], rax                   ; 0539 _ 48: 89. 85, FFFFFF38
        lea     rax, [rbp-0B0H]                         ; 0540 _ 48: 8D. 85, FFFFFF50
        mov     qword [rbp-0C0H], rax                   ; 0547 _ 48: 89. 85, FFFFFF40
        cmp     dword [rbp-0D8H], 13                    ; 054E _ 83. BD, FFFFFF28, 0D
        jbe     ?_014                                   ; 0555 _ 76, 1E
        lea     rdx, [rbp-0D0H]                         ; 0557 _ 48: 8D. 95, FFFFFF30
        mov     rcx, qword [rbp-0E8H]                   ; 055E _ 48: 8B. 8D, FFFFFF18
        mov     eax, dword [rbp-0D4H]                   ; 0565 _ 8B. 85, FFFFFF2C
        mov     rsi, rcx                                ; 056B _ 48: 89. CE
        mov     edi, eax                                ; 056E _ 89. C7
        call    nasm_verror_critical                    ; 0570 _ E8, 00000000(PLT r)
?_014:  lea     rdx, [rbp-0D0H]                         ; 0575 _ 48: 8D. 95, FFFFFF30
        mov     rcx, qword [rbp-0E8H]                   ; 057C _ 48: 8B. 8D, FFFFFF18
        mov     eax, dword [rbp-0D4H]                   ; 0583 _ 8B. 85, FFFFFF2C
        mov     rsi, rcx                                ; 0589 _ 48: 89. CE
        mov     edi, eax                                ; 058C _ 89. C7
        call    nasm_verror                             ; 058E _ E8, 00000000(PLT r)
        cmp     dword [rbp-0D8H], 11                    ; 0593 _ 83. BD, FFFFFF28, 0B
        nop                                             ; 059A _ 90
        mov     rax, qword [rbp-0B8H]                   ; 059B _ 48: 8B. 85, FFFFFF48
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        sub     rax, qword [fs:abs 28H]                 ; 05A2 _ 64 48: 2B. 04 25, 00000028
        jz      ?_015                                   ; 05AB _ 74, 05
        call    __stack_chk_fail                        ; 05AD _ E8, 00000000(PLT r)
?_015:  leave                                           ; 05B2 _ C9
        ret                                             ; 05B3 _ C3
; nasm_note End of function

nasm_nonfatalf:; Function begin
        push    rbp                                     ; 05B4 _ 55
        mov     rbp, rsp                                ; 05B5 _ 48: 89. E5
        sub     rsp, 240                                ; 05B8 _ 48: 81. EC, 000000F0
        mov     dword [rbp-0E4H], edi                   ; 05BF _ 89. BD, FFFFFF1C
        mov     qword [rbp-0F0H], rsi                   ; 05C5 _ 48: 89. B5, FFFFFF10
        mov     qword [rbp-0A0H], rdx                   ; 05CC _ 48: 89. 95, FFFFFF60
        mov     qword [rbp-98H], rcx                    ; 05D3 _ 48: 89. 8D, FFFFFF68
        mov     qword [rbp-90H], r8                     ; 05DA _ 4C: 89. 85, FFFFFF70
        mov     qword [rbp-88H], r9                     ; 05E1 _ 4C: 89. 8D, FFFFFF78
        test    al, al                                  ; 05E8 _ 84. C0
        jz      ?_016                                   ; 05EA _ 74, 20
        movaps  oword [rbp-80H], xmm0                   ; 05EC _ 0F 29. 45, 80
        movaps  oword [rbp-70H], xmm1                   ; 05F0 _ 0F 29. 4D, 90
        movaps  oword [rbp-60H], xmm2                   ; 05F4 _ 0F 29. 55, A0
        movaps  oword [rbp-50H], xmm3                   ; 05F8 _ 0F 29. 5D, B0
        movaps  oword [rbp-40H], xmm4                   ; 05FC _ 0F 29. 65, C0
        movaps  oword [rbp-30H], xmm5                   ; 0600 _ 0F 29. 6D, D0
        movaps  oword [rbp-20H], xmm6                   ; 0604 _ 0F 29. 75, E0
        movaps  oword [rbp-10H], xmm7                   ; 0608 _ 0F 29. 7D, F0
?_016:
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        mov     rax, qword [fs:abs 28H]                 ; 060C _ 64 48: 8B. 04 25, 00000028
        mov     qword [rbp-0B8H], rax                   ; 0615 _ 48: 89. 85, FFFFFF48
        xor     eax, eax                                ; 061C _ 31. C0
        mov     dword [rbp-0D8H], 8                     ; 061E _ C7. 85, FFFFFF28, 00000008
        mov     eax, dword [rbp-0D8H]                   ; 0628 _ 8B. 85, FFFFFF28
        or      eax, dword [rbp-0E4H]                   ; 062E _ 0B. 85, FFFFFF1C
        mov     dword [rbp-0D4H], eax                   ; 0634 _ 89. 85, FFFFFF2C
        mov     dword [rbp-0D0H], 16                    ; 063A _ C7. 85, FFFFFF30, 00000010
        mov     dword [rbp-0CCH], 48                    ; 0644 _ C7. 85, FFFFFF34, 00000030
        lea     rax, [rbp+10H]                          ; 064E _ 48: 8D. 45, 10
        mov     qword [rbp-0C8H], rax                   ; 0652 _ 48: 89. 85, FFFFFF38
        lea     rax, [rbp-0B0H]                         ; 0659 _ 48: 8D. 85, FFFFFF50
        mov     qword [rbp-0C0H], rax                   ; 0660 _ 48: 89. 85, FFFFFF40
        cmp     dword [rbp-0D8H], 13                    ; 0667 _ 83. BD, FFFFFF28, 0D
        jbe     ?_017                                   ; 066E _ 76, 1E
        lea     rdx, [rbp-0D0H]                         ; 0670 _ 48: 8D. 95, FFFFFF30
        mov     rcx, qword [rbp-0F0H]                   ; 0677 _ 48: 8B. 8D, FFFFFF10
        mov     eax, dword [rbp-0D4H]                   ; 067E _ 8B. 85, FFFFFF2C
        mov     rsi, rcx                                ; 0684 _ 48: 89. CE
        mov     edi, eax                                ; 0687 _ 89. C7
        call    nasm_verror_critical                    ; 0689 _ E8, 00000000(PLT r)
?_017:  lea     rdx, [rbp-0D0H]                         ; 068E _ 48: 8D. 95, FFFFFF30
        mov     rcx, qword [rbp-0F0H]                   ; 0695 _ 48: 8B. 8D, FFFFFF10
        mov     eax, dword [rbp-0D4H]                   ; 069C _ 8B. 85, FFFFFF2C
        mov     rsi, rcx                                ; 06A2 _ 48: 89. CE
        mov     edi, eax                                ; 06A5 _ 89. C7
        call    nasm_verror                             ; 06A7 _ E8, 00000000(PLT r)
        cmp     dword [rbp-0D8H], 11                    ; 06AC _ 83. BD, FFFFFF28, 0B
        nop                                             ; 06B3 _ 90
        mov     rax, qword [rbp-0B8H]                   ; 06B4 _ 48: 8B. 85, FFFFFF48
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        sub     rax, qword [fs:abs 28H]                 ; 06BB _ 64 48: 2B. 04 25, 00000028
        jz      ?_018                                   ; 06C4 _ 74, 05
        call    __stack_chk_fail                        ; 06C6 _ E8, 00000000(PLT r)
?_018:  leave                                           ; 06CB _ C9
        ret                                             ; 06CC _ C3
; nasm_nonfatalf End of function

nasm_nonfatal:; Function begin
        push    rbp                                     ; 06CD _ 55
        mov     rbp, rsp                                ; 06CE _ 48: 89. E5
        sub     rsp, 240                                ; 06D1 _ 48: 81. EC, 000000F0
        mov     qword [rbp-0E8H], rdi                   ; 06D8 _ 48: 89. BD, FFFFFF18
        mov     qword [rbp-0A8H], rsi                   ; 06DF _ 48: 89. B5, FFFFFF58
        mov     qword [rbp-0A0H], rdx                   ; 06E6 _ 48: 89. 95, FFFFFF60
        mov     qword [rbp-98H], rcx                    ; 06ED _ 48: 89. 8D, FFFFFF68
        mov     qword [rbp-90H], r8                     ; 06F4 _ 4C: 89. 85, FFFFFF70
        mov     qword [rbp-88H], r9                     ; 06FB _ 4C: 89. 8D, FFFFFF78
        test    al, al                                  ; 0702 _ 84. C0
        jz      ?_019                                   ; 0704 _ 74, 20
        movaps  oword [rbp-80H], xmm0                   ; 0706 _ 0F 29. 45, 80
        movaps  oword [rbp-70H], xmm1                   ; 070A _ 0F 29. 4D, 90
        movaps  oword [rbp-60H], xmm2                   ; 070E _ 0F 29. 55, A0
        movaps  oword [rbp-50H], xmm3                   ; 0712 _ 0F 29. 5D, B0
        movaps  oword [rbp-40H], xmm4                   ; 0716 _ 0F 29. 65, C0
        movaps  oword [rbp-30H], xmm5                   ; 071A _ 0F 29. 6D, D0
        movaps  oword [rbp-20H], xmm6                   ; 071E _ 0F 29. 75, E0
        movaps  oword [rbp-10H], xmm7                   ; 0722 _ 0F 29. 7D, F0
?_019:
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        mov     rax, qword [fs:abs 28H]                 ; 0726 _ 64 48: 8B. 04 25, 00000028
        mov     qword [rbp-0B8H], rax                   ; 072F _ 48: 89. 85, FFFFFF48
        xor     eax, eax                                ; 0736 _ 31. C0
        mov     dword [rbp-0D8H], 8                     ; 0738 _ C7. 85, FFFFFF28, 00000008
        mov     eax, dword [rbp-0D8H]                   ; 0742 _ 8B. 85, FFFFFF28
        mov     dword [rbp-0D4H], eax                   ; 0748 _ 89. 85, FFFFFF2C
        mov     dword [rbp-0D0H], 8                     ; 074E _ C7. 85, FFFFFF30, 00000008
        mov     dword [rbp-0CCH], 48                    ; 0758 _ C7. 85, FFFFFF34, 00000030
        lea     rax, [rbp+10H]                          ; 0762 _ 48: 8D. 45, 10
        mov     qword [rbp-0C8H], rax                   ; 0766 _ 48: 89. 85, FFFFFF38
        lea     rax, [rbp-0B0H]                         ; 076D _ 48: 8D. 85, FFFFFF50
        mov     qword [rbp-0C0H], rax                   ; 0774 _ 48: 89. 85, FFFFFF40
        cmp     dword [rbp-0D8H], 13                    ; 077B _ 83. BD, FFFFFF28, 0D
        jbe     ?_020                                   ; 0782 _ 76, 1E
        lea     rdx, [rbp-0D0H]                         ; 0784 _ 48: 8D. 95, FFFFFF30
        mov     rcx, qword [rbp-0E8H]                   ; 078B _ 48: 8B. 8D, FFFFFF18
        mov     eax, dword [rbp-0D4H]                   ; 0792 _ 8B. 85, FFFFFF2C
        mov     rsi, rcx                                ; 0798 _ 48: 89. CE
        mov     edi, eax                                ; 079B _ 89. C7
        call    nasm_verror_critical                    ; 079D _ E8, 00000000(PLT r)
?_020:  lea     rdx, [rbp-0D0H]                         ; 07A2 _ 48: 8D. 95, FFFFFF30
        mov     rcx, qword [rbp-0E8H]                   ; 07A9 _ 48: 8B. 8D, FFFFFF18
        mov     eax, dword [rbp-0D4H]                   ; 07B0 _ 8B. 85, FFFFFF2C
        mov     rsi, rcx                                ; 07B6 _ 48: 89. CE
        mov     edi, eax                                ; 07B9 _ 89. C7
        call    nasm_verror                             ; 07BB _ E8, 00000000(PLT r)
        cmp     dword [rbp-0D8H], 11                    ; 07C0 _ 83. BD, FFFFFF28, 0B
        nop                                             ; 07C7 _ 90
        mov     rax, qword [rbp-0B8H]                   ; 07C8 _ 48: 8B. 85, FFFFFF48
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        sub     rax, qword [fs:abs 28H]                 ; 07CF _ 64 48: 2B. 04 25, 00000028
        jz      ?_021                                   ; 07D8 _ 74, 05
        call    __stack_chk_fail                        ; 07DA _ E8, 00000000(PLT r)
?_021:  leave                                           ; 07DF _ C9
        ret                                             ; 07E0 _ C3
; nasm_nonfatal End of function

nasm_fatalf:; Function begin
        push    rbp                                     ; 07E1 _ 55
        mov     rbp, rsp                                ; 07E2 _ 48: 89. E5
        sub     rsp, 240                                ; 07E5 _ 48: 81. EC, 000000F0
        mov     dword [rbp-0E4H], edi                   ; 07EC _ 89. BD, FFFFFF1C
        mov     qword [rbp-0F0H], rsi                   ; 07F2 _ 48: 89. B5, FFFFFF10
        mov     qword [rbp-0A0H], rdx                   ; 07F9 _ 48: 89. 95, FFFFFF60
        mov     qword [rbp-98H], rcx                    ; 0800 _ 48: 89. 8D, FFFFFF68
        mov     qword [rbp-90H], r8                     ; 0807 _ 4C: 89. 85, FFFFFF70
        mov     qword [rbp-88H], r9                     ; 080E _ 4C: 89. 8D, FFFFFF78
        test    al, al                                  ; 0815 _ 84. C0
        jz      ?_022                                   ; 0817 _ 74, 20
        movaps  oword [rbp-80H], xmm0                   ; 0819 _ 0F 29. 45, 80
        movaps  oword [rbp-70H], xmm1                   ; 081D _ 0F 29. 4D, 90
        movaps  oword [rbp-60H], xmm2                   ; 0821 _ 0F 29. 55, A0
        movaps  oword [rbp-50H], xmm3                   ; 0825 _ 0F 29. 5D, B0
        movaps  oword [rbp-40H], xmm4                   ; 0829 _ 0F 29. 65, C0
        movaps  oword [rbp-30H], xmm5                   ; 082D _ 0F 29. 6D, D0
        movaps  oword [rbp-20H], xmm6                   ; 0831 _ 0F 29. 75, E0
        movaps  oword [rbp-10H], xmm7                   ; 0835 _ 0F 29. 7D, F0
?_022:
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        mov     rax, qword [fs:abs 28H]                 ; 0839 _ 64 48: 8B. 04 25, 00000028
        mov     qword [rbp-0B8H], rax                   ; 0842 _ 48: 89. 85, FFFFFF48
        xor     eax, eax                                ; 0849 _ 31. C0
        mov     dword [rbp-0D8H], 12                    ; 084B _ C7. 85, FFFFFF28, 0000000C
        mov     eax, dword [rbp-0D8H]                   ; 0855 _ 8B. 85, FFFFFF28
        or      eax, dword [rbp-0E4H]                   ; 085B _ 0B. 85, FFFFFF1C
        mov     dword [rbp-0D4H], eax                   ; 0861 _ 89. 85, FFFFFF2C
        mov     dword [rbp-0D0H], 16                    ; 0867 _ C7. 85, FFFFFF30, 00000010
        mov     dword [rbp-0CCH], 48                    ; 0871 _ C7. 85, FFFFFF34, 00000030
        lea     rax, [rbp+10H]                          ; 087B _ 48: 8D. 45, 10
        mov     qword [rbp-0C8H], rax                   ; 087F _ 48: 89. 85, FFFFFF38
        lea     rax, [rbp-0B0H]                         ; 0886 _ 48: 8D. 85, FFFFFF50
        mov     qword [rbp-0C0H], rax                   ; 088D _ 48: 89. 85, FFFFFF40
        cmp     dword [rbp-0D8H], 13                    ; 0894 _ 83. BD, FFFFFF28, 0D
        jbe     ?_023                                   ; 089B _ 76, 1E
        lea     rdx, [rbp-0D0H]                         ; 089D _ 48: 8D. 95, FFFFFF30
        mov     rcx, qword [rbp-0F0H]                   ; 08A4 _ 48: 8B. 8D, FFFFFF10
        mov     eax, dword [rbp-0D4H]                   ; 08AB _ 8B. 85, FFFFFF2C
        mov     rsi, rcx                                ; 08B1 _ 48: 89. CE
        mov     edi, eax                                ; 08B4 _ 89. C7
        call    nasm_verror_critical                    ; 08B6 _ E8, 00000000(PLT r)
?_023:  lea     rdx, [rbp-0D0H]                         ; 08BB _ 48: 8D. 95, FFFFFF30
        mov     rcx, qword [rbp-0F0H]                   ; 08C2 _ 48: 8B. 8D, FFFFFF10
        mov     eax, dword [rbp-0D4H]                   ; 08C9 _ 8B. 85, FFFFFF2C
        mov     rsi, rcx                                ; 08CF _ 48: 89. CE
        mov     edi, eax                                ; 08D2 _ 89. C7
        call    nasm_verror                             ; 08D4 _ E8, 00000000(PLT r)
        cmp     dword [rbp-0D8H], 11                    ; 08D9 _ 83. BD, FFFFFF28, 0B
        ud2                                             ; 08E0 _ 0F 0B
; nasm_fatalf End of function

nasm_fatal:; Function begin
        push    rbp                                     ; 08E2 _ 55
        mov     rbp, rsp                                ; 08E3 _ 48: 89. E5
        sub     rsp, 240                                ; 08E6 _ 48: 81. EC, 000000F0
        mov     qword [rbp-0E8H], rdi                   ; 08ED _ 48: 89. BD, FFFFFF18
        mov     qword [rbp-0A8H], rsi                   ; 08F4 _ 48: 89. B5, FFFFFF58
        mov     qword [rbp-0A0H], rdx                   ; 08FB _ 48: 89. 95, FFFFFF60
        mov     qword [rbp-98H], rcx                    ; 0902 _ 48: 89. 8D, FFFFFF68
        mov     qword [rbp-90H], r8                     ; 0909 _ 4C: 89. 85, FFFFFF70
        mov     qword [rbp-88H], r9                     ; 0910 _ 4C: 89. 8D, FFFFFF78
        test    al, al                                  ; 0917 _ 84. C0
        jz      ?_024                                   ; 0919 _ 74, 20
        movaps  oword [rbp-80H], xmm0                   ; 091B _ 0F 29. 45, 80
        movaps  oword [rbp-70H], xmm1                   ; 091F _ 0F 29. 4D, 90
        movaps  oword [rbp-60H], xmm2                   ; 0923 _ 0F 29. 55, A0
        movaps  oword [rbp-50H], xmm3                   ; 0927 _ 0F 29. 5D, B0
        movaps  oword [rbp-40H], xmm4                   ; 092B _ 0F 29. 65, C0
        movaps  oword [rbp-30H], xmm5                   ; 092F _ 0F 29. 6D, D0
        movaps  oword [rbp-20H], xmm6                   ; 0933 _ 0F 29. 75, E0
        movaps  oword [rbp-10H], xmm7                   ; 0937 _ 0F 29. 7D, F0
?_024:
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        mov     rax, qword [fs:abs 28H]                 ; 093B _ 64 48: 8B. 04 25, 00000028
        mov     qword [rbp-0B8H], rax                   ; 0944 _ 48: 89. 85, FFFFFF48
        xor     eax, eax                                ; 094B _ 31. C0
        mov     dword [rbp-0D8H], 12                    ; 094D _ C7. 85, FFFFFF28, 0000000C
        mov     eax, dword [rbp-0D8H]                   ; 0957 _ 8B. 85, FFFFFF28
        mov     dword [rbp-0D4H], eax                   ; 095D _ 89. 85, FFFFFF2C
        mov     dword [rbp-0D0H], 8                     ; 0963 _ C7. 85, FFFFFF30, 00000008
        mov     dword [rbp-0CCH], 48                    ; 096D _ C7. 85, FFFFFF34, 00000030
        lea     rax, [rbp+10H]                          ; 0977 _ 48: 8D. 45, 10
        mov     qword [rbp-0C8H], rax                   ; 097B _ 48: 89. 85, FFFFFF38
        lea     rax, [rbp-0B0H]                         ; 0982 _ 48: 8D. 85, FFFFFF50
        mov     qword [rbp-0C0H], rax                   ; 0989 _ 48: 89. 85, FFFFFF40
        cmp     dword [rbp-0D8H], 13                    ; 0990 _ 83. BD, FFFFFF28, 0D
        jbe     ?_025                                   ; 0997 _ 76, 1E
        lea     rdx, [rbp-0D0H]                         ; 0999 _ 48: 8D. 95, FFFFFF30
        mov     rcx, qword [rbp-0E8H]                   ; 09A0 _ 48: 8B. 8D, FFFFFF18
        mov     eax, dword [rbp-0D4H]                   ; 09A7 _ 8B. 85, FFFFFF2C
        mov     rsi, rcx                                ; 09AD _ 48: 89. CE
        mov     edi, eax                                ; 09B0 _ 89. C7
        call    nasm_verror_critical                    ; 09B2 _ E8, 00000000(PLT r)
?_025:  lea     rdx, [rbp-0D0H]                         ; 09B7 _ 48: 8D. 95, FFFFFF30
        mov     rcx, qword [rbp-0E8H]                   ; 09BE _ 48: 8B. 8D, FFFFFF18
        mov     eax, dword [rbp-0D4H]                   ; 09C5 _ 8B. 85, FFFFFF2C
        mov     rsi, rcx                                ; 09CB _ 48: 89. CE
        mov     edi, eax                                ; 09CE _ 89. C7
        call    nasm_verror                             ; 09D0 _ E8, 00000000(PLT r)
        cmp     dword [rbp-0D8H], 11                    ; 09D5 _ 83. BD, FFFFFF28, 0B
        ud2                                             ; 09DC _ 0F 0B
; nasm_fatal End of function

nasm_criticalf:; Function begin
        push    rbp                                     ; 09DE _ 55
        mov     rbp, rsp                                ; 09DF _ 48: 89. E5
        sub     rsp, 240                                ; 09E2 _ 48: 81. EC, 000000F0
        mov     dword [rbp-0E4H], edi                   ; 09E9 _ 89. BD, FFFFFF1C
        mov     qword [rbp-0F0H], rsi                   ; 09EF _ 48: 89. B5, FFFFFF10
        mov     qword [rbp-0A0H], rdx                   ; 09F6 _ 48: 89. 95, FFFFFF60
        mov     qword [rbp-98H], rcx                    ; 09FD _ 48: 89. 8D, FFFFFF68
        mov     qword [rbp-90H], r8                     ; 0A04 _ 4C: 89. 85, FFFFFF70
        mov     qword [rbp-88H], r9                     ; 0A0B _ 4C: 89. 8D, FFFFFF78
        test    al, al                                  ; 0A12 _ 84. C0
        jz      ?_026                                   ; 0A14 _ 74, 20
        movaps  oword [rbp-80H], xmm0                   ; 0A16 _ 0F 29. 45, 80
        movaps  oword [rbp-70H], xmm1                   ; 0A1A _ 0F 29. 4D, 90
        movaps  oword [rbp-60H], xmm2                   ; 0A1E _ 0F 29. 55, A0
        movaps  oword [rbp-50H], xmm3                   ; 0A22 _ 0F 29. 5D, B0
        movaps  oword [rbp-40H], xmm4                   ; 0A26 _ 0F 29. 65, C0
        movaps  oword [rbp-30H], xmm5                   ; 0A2A _ 0F 29. 6D, D0
        movaps  oword [rbp-20H], xmm6                   ; 0A2E _ 0F 29. 75, E0
        movaps  oword [rbp-10H], xmm7                   ; 0A32 _ 0F 29. 7D, F0
?_026:
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        mov     rax, qword [fs:abs 28H]                 ; 0A36 _ 64 48: 8B. 04 25, 00000028
        mov     qword [rbp-0B8H], rax                   ; 0A3F _ 48: 89. 85, FFFFFF48
        xor     eax, eax                                ; 0A46 _ 31. C0
        mov     dword [rbp-0D8H], 14                    ; 0A48 _ C7. 85, FFFFFF28, 0000000E
        mov     eax, dword [rbp-0D8H]                   ; 0A52 _ 8B. 85, FFFFFF28
        or      eax, dword [rbp-0E4H]                   ; 0A58 _ 0B. 85, FFFFFF1C
        mov     dword [rbp-0D4H], eax                   ; 0A5E _ 89. 85, FFFFFF2C
        mov     dword [rbp-0D0H], 16                    ; 0A64 _ C7. 85, FFFFFF30, 00000010
        mov     dword [rbp-0CCH], 48                    ; 0A6E _ C7. 85, FFFFFF34, 00000030
        lea     rax, [rbp+10H]                          ; 0A78 _ 48: 8D. 45, 10
        mov     qword [rbp-0C8H], rax                   ; 0A7C _ 48: 89. 85, FFFFFF38
        lea     rax, [rbp-0B0H]                         ; 0A83 _ 48: 8D. 85, FFFFFF50
        mov     qword [rbp-0C0H], rax                   ; 0A8A _ 48: 89. 85, FFFFFF40
        cmp     dword [rbp-0D8H], 13                    ; 0A91 _ 83. BD, FFFFFF28, 0D
        jbe     ?_027                                   ; 0A98 _ 76, 1E
        lea     rdx, [rbp-0D0H]                         ; 0A9A _ 48: 8D. 95, FFFFFF30
        mov     rcx, qword [rbp-0F0H]                   ; 0AA1 _ 48: 8B. 8D, FFFFFF10
        mov     eax, dword [rbp-0D4H]                   ; 0AA8 _ 8B. 85, FFFFFF2C
        mov     rsi, rcx                                ; 0AAE _ 48: 89. CE
        mov     edi, eax                                ; 0AB1 _ 89. C7
        call    nasm_verror_critical                    ; 0AB3 _ E8, 00000000(PLT r)
?_027:  lea     rdx, [rbp-0D0H]                         ; 0AB8 _ 48: 8D. 95, FFFFFF30
        mov     rcx, qword [rbp-0F0H]                   ; 0ABF _ 48: 8B. 8D, FFFFFF10
        mov     eax, dword [rbp-0D4H]                   ; 0AC6 _ 8B. 85, FFFFFF2C
        mov     rsi, rcx                                ; 0ACC _ 48: 89. CE
        mov     edi, eax                                ; 0ACF _ 89. C7
        call    nasm_verror                             ; 0AD1 _ E8, 00000000(PLT r)
        cmp     dword [rbp-0D8H], 11                    ; 0AD6 _ 83. BD, FFFFFF28, 0B
        ud2                                             ; 0ADD _ 0F 0B
; nasm_criticalf End of function

nasm_critical:; Function begin
        push    rbp                                     ; 0ADF _ 55
        mov     rbp, rsp                                ; 0AE0 _ 48: 89. E5
        sub     rsp, 240                                ; 0AE3 _ 48: 81. EC, 000000F0
        mov     qword [rbp-0E8H], rdi                   ; 0AEA _ 48: 89. BD, FFFFFF18
        mov     qword [rbp-0A8H], rsi                   ; 0AF1 _ 48: 89. B5, FFFFFF58
        mov     qword [rbp-0A0H], rdx                   ; 0AF8 _ 48: 89. 95, FFFFFF60
        mov     qword [rbp-98H], rcx                    ; 0AFF _ 48: 89. 8D, FFFFFF68
        mov     qword [rbp-90H], r8                     ; 0B06 _ 4C: 89. 85, FFFFFF70
        mov     qword [rbp-88H], r9                     ; 0B0D _ 4C: 89. 8D, FFFFFF78
        test    al, al                                  ; 0B14 _ 84. C0
        jz      ?_028                                   ; 0B16 _ 74, 20
        movaps  oword [rbp-80H], xmm0                   ; 0B18 _ 0F 29. 45, 80
        movaps  oword [rbp-70H], xmm1                   ; 0B1C _ 0F 29. 4D, 90
        movaps  oword [rbp-60H], xmm2                   ; 0B20 _ 0F 29. 55, A0
        movaps  oword [rbp-50H], xmm3                   ; 0B24 _ 0F 29. 5D, B0
        movaps  oword [rbp-40H], xmm4                   ; 0B28 _ 0F 29. 65, C0
        movaps  oword [rbp-30H], xmm5                   ; 0B2C _ 0F 29. 6D, D0
        movaps  oword [rbp-20H], xmm6                   ; 0B30 _ 0F 29. 75, E0
        movaps  oword [rbp-10H], xmm7                   ; 0B34 _ 0F 29. 7D, F0
?_028:
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        mov     rax, qword [fs:abs 28H]                 ; 0B38 _ 64 48: 8B. 04 25, 00000028
        mov     qword [rbp-0B8H], rax                   ; 0B41 _ 48: 89. 85, FFFFFF48
        xor     eax, eax                                ; 0B48 _ 31. C0
        mov     dword [rbp-0D8H], 14                    ; 0B4A _ C7. 85, FFFFFF28, 0000000E
        mov     eax, dword [rbp-0D8H]                   ; 0B54 _ 8B. 85, FFFFFF28
        mov     dword [rbp-0D4H], eax                   ; 0B5A _ 89. 85, FFFFFF2C
        mov     dword [rbp-0D0H], 8                     ; 0B60 _ C7. 85, FFFFFF30, 00000008
        mov     dword [rbp-0CCH], 48                    ; 0B6A _ C7. 85, FFFFFF34, 00000030
        lea     rax, [rbp+10H]                          ; 0B74 _ 48: 8D. 45, 10
        mov     qword [rbp-0C8H], rax                   ; 0B78 _ 48: 89. 85, FFFFFF38
        lea     rax, [rbp-0B0H]                         ; 0B7F _ 48: 8D. 85, FFFFFF50
        mov     qword [rbp-0C0H], rax                   ; 0B86 _ 48: 89. 85, FFFFFF40
        cmp     dword [rbp-0D8H], 13                    ; 0B8D _ 83. BD, FFFFFF28, 0D
        jbe     ?_029                                   ; 0B94 _ 76, 1E
        lea     rdx, [rbp-0D0H]                         ; 0B96 _ 48: 8D. 95, FFFFFF30
        mov     rcx, qword [rbp-0E8H]                   ; 0B9D _ 48: 8B. 8D, FFFFFF18
        mov     eax, dword [rbp-0D4H]                   ; 0BA4 _ 8B. 85, FFFFFF2C
        mov     rsi, rcx                                ; 0BAA _ 48: 89. CE
        mov     edi, eax                                ; 0BAD _ 89. C7
        call    nasm_verror_critical                    ; 0BAF _ E8, 00000000(PLT r)
?_029:  lea     rdx, [rbp-0D0H]                         ; 0BB4 _ 48: 8D. 95, FFFFFF30
        mov     rcx, qword [rbp-0E8H]                   ; 0BBB _ 48: 8B. 8D, FFFFFF18
        mov     eax, dword [rbp-0D4H]                   ; 0BC2 _ 8B. 85, FFFFFF2C
        mov     rsi, rcx                                ; 0BC8 _ 48: 89. CE
        mov     edi, eax                                ; 0BCB _ 89. C7
        call    nasm_verror                             ; 0BCD _ E8, 00000000(PLT r)
        cmp     dword [rbp-0D8H], 11                    ; 0BD2 _ 83. BD, FFFFFF28, 0B
        ud2                                             ; 0BD9 _ 0F 0B
; nasm_critical End of function

nasm_panicf:; Function begin
        push    rbp                                     ; 0BDB _ 55
        mov     rbp, rsp                                ; 0BDC _ 48: 89. E5
        sub     rsp, 240                                ; 0BDF _ 48: 81. EC, 000000F0
        mov     dword [rbp-0E4H], edi                   ; 0BE6 _ 89. BD, FFFFFF1C
        mov     qword [rbp-0F0H], rsi                   ; 0BEC _ 48: 89. B5, FFFFFF10
        mov     qword [rbp-0A0H], rdx                   ; 0BF3 _ 48: 89. 95, FFFFFF60
        mov     qword [rbp-98H], rcx                    ; 0BFA _ 48: 89. 8D, FFFFFF68
        mov     qword [rbp-90H], r8                     ; 0C01 _ 4C: 89. 85, FFFFFF70
        mov     qword [rbp-88H], r9                     ; 0C08 _ 4C: 89. 8D, FFFFFF78
        test    al, al                                  ; 0C0F _ 84. C0
        jz      ?_030                                   ; 0C11 _ 74, 20
        movaps  oword [rbp-80H], xmm0                   ; 0C13 _ 0F 29. 45, 80
        movaps  oword [rbp-70H], xmm1                   ; 0C17 _ 0F 29. 4D, 90
        movaps  oword [rbp-60H], xmm2                   ; 0C1B _ 0F 29. 55, A0
        movaps  oword [rbp-50H], xmm3                   ; 0C1F _ 0F 29. 5D, B0
        movaps  oword [rbp-40H], xmm4                   ; 0C23 _ 0F 29. 65, C0
        movaps  oword [rbp-30H], xmm5                   ; 0C27 _ 0F 29. 6D, D0
        movaps  oword [rbp-20H], xmm6                   ; 0C2B _ 0F 29. 75, E0
        movaps  oword [rbp-10H], xmm7                   ; 0C2F _ 0F 29. 7D, F0
?_030:
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        mov     rax, qword [fs:abs 28H]                 ; 0C33 _ 64 48: 8B. 04 25, 00000028
        mov     qword [rbp-0B8H], rax                   ; 0C3C _ 48: 89. 85, FFFFFF48
        xor     eax, eax                                ; 0C43 _ 31. C0
        mov     dword [rbp-0D8H], 15                    ; 0C45 _ C7. 85, FFFFFF28, 0000000F
        mov     eax, dword [rbp-0D8H]                   ; 0C4F _ 8B. 85, FFFFFF28
        or      eax, dword [rbp-0E4H]                   ; 0C55 _ 0B. 85, FFFFFF1C
        mov     dword [rbp-0D4H], eax                   ; 0C5B _ 89. 85, FFFFFF2C
        mov     dword [rbp-0D0H], 16                    ; 0C61 _ C7. 85, FFFFFF30, 00000010
        mov     dword [rbp-0CCH], 48                    ; 0C6B _ C7. 85, FFFFFF34, 00000030
        lea     rax, [rbp+10H]                          ; 0C75 _ 48: 8D. 45, 10
        mov     qword [rbp-0C8H], rax                   ; 0C79 _ 48: 89. 85, FFFFFF38
        lea     rax, [rbp-0B0H]                         ; 0C80 _ 48: 8D. 85, FFFFFF50
        mov     qword [rbp-0C0H], rax                   ; 0C87 _ 48: 89. 85, FFFFFF40
        cmp     dword [rbp-0D8H], 13                    ; 0C8E _ 83. BD, FFFFFF28, 0D
        jbe     ?_031                                   ; 0C95 _ 76, 1E
        lea     rdx, [rbp-0D0H]                         ; 0C97 _ 48: 8D. 95, FFFFFF30
        mov     rcx, qword [rbp-0F0H]                   ; 0C9E _ 48: 8B. 8D, FFFFFF10
        mov     eax, dword [rbp-0D4H]                   ; 0CA5 _ 8B. 85, FFFFFF2C
        mov     rsi, rcx                                ; 0CAB _ 48: 89. CE
        mov     edi, eax                                ; 0CAE _ 89. C7
        call    nasm_verror_critical                    ; 0CB0 _ E8, 00000000(PLT r)
?_031:  lea     rdx, [rbp-0D0H]                         ; 0CB5 _ 48: 8D. 95, FFFFFF30
        mov     rcx, qword [rbp-0F0H]                   ; 0CBC _ 48: 8B. 8D, FFFFFF10
        mov     eax, dword [rbp-0D4H]                   ; 0CC3 _ 8B. 85, FFFFFF2C
        mov     rsi, rcx                                ; 0CC9 _ 48: 89. CE
        mov     edi, eax                                ; 0CCC _ 89. C7
        call    nasm_verror                             ; 0CCE _ E8, 00000000(PLT r)
        cmp     dword [rbp-0D8H], 11                    ; 0CD3 _ 83. BD, FFFFFF28, 0B
        ud2                                             ; 0CDA _ 0F 0B
; nasm_panicf End of function

nasm_panic:; Function begin
        push    rbp                                     ; 0CDC _ 55
        mov     rbp, rsp                                ; 0CDD _ 48: 89. E5
        sub     rsp, 240                                ; 0CE0 _ 48: 81. EC, 000000F0
        mov     qword [rbp-0E8H], rdi                   ; 0CE7 _ 48: 89. BD, FFFFFF18
        mov     qword [rbp-0A8H], rsi                   ; 0CEE _ 48: 89. B5, FFFFFF58
        mov     qword [rbp-0A0H], rdx                   ; 0CF5 _ 48: 89. 95, FFFFFF60
        mov     qword [rbp-98H], rcx                    ; 0CFC _ 48: 89. 8D, FFFFFF68
        mov     qword [rbp-90H], r8                     ; 0D03 _ 4C: 89. 85, FFFFFF70
        mov     qword [rbp-88H], r9                     ; 0D0A _ 4C: 89. 8D, FFFFFF78
        test    al, al                                  ; 0D11 _ 84. C0
        jz      ?_032                                   ; 0D13 _ 74, 20
        movaps  oword [rbp-80H], xmm0                   ; 0D15 _ 0F 29. 45, 80
        movaps  oword [rbp-70H], xmm1                   ; 0D19 _ 0F 29. 4D, 90
        movaps  oword [rbp-60H], xmm2                   ; 0D1D _ 0F 29. 55, A0
        movaps  oword [rbp-50H], xmm3                   ; 0D21 _ 0F 29. 5D, B0
        movaps  oword [rbp-40H], xmm4                   ; 0D25 _ 0F 29. 65, C0
        movaps  oword [rbp-30H], xmm5                   ; 0D29 _ 0F 29. 6D, D0
        movaps  oword [rbp-20H], xmm6                   ; 0D2D _ 0F 29. 75, E0
        movaps  oword [rbp-10H], xmm7                   ; 0D31 _ 0F 29. 7D, F0
?_032:
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        mov     rax, qword [fs:abs 28H]                 ; 0D35 _ 64 48: 8B. 04 25, 00000028
        mov     qword [rbp-0B8H], rax                   ; 0D3E _ 48: 89. 85, FFFFFF48
        xor     eax, eax                                ; 0D45 _ 31. C0
        mov     dword [rbp-0D8H], 15                    ; 0D47 _ C7. 85, FFFFFF28, 0000000F
        mov     eax, dword [rbp-0D8H]                   ; 0D51 _ 8B. 85, FFFFFF28
        mov     dword [rbp-0D4H], eax                   ; 0D57 _ 89. 85, FFFFFF2C
        mov     dword [rbp-0D0H], 8                     ; 0D5D _ C7. 85, FFFFFF30, 00000008
        mov     dword [rbp-0CCH], 48                    ; 0D67 _ C7. 85, FFFFFF34, 00000030
        lea     rax, [rbp+10H]                          ; 0D71 _ 48: 8D. 45, 10
        mov     qword [rbp-0C8H], rax                   ; 0D75 _ 48: 89. 85, FFFFFF38
        lea     rax, [rbp-0B0H]                         ; 0D7C _ 48: 8D. 85, FFFFFF50
        mov     qword [rbp-0C0H], rax                   ; 0D83 _ 48: 89. 85, FFFFFF40
        cmp     dword [rbp-0D8H], 13                    ; 0D8A _ 83. BD, FFFFFF28, 0D
        jbe     ?_033                                   ; 0D91 _ 76, 1E
        lea     rdx, [rbp-0D0H]                         ; 0D93 _ 48: 8D. 95, FFFFFF30
        mov     rcx, qword [rbp-0E8H]                   ; 0D9A _ 48: 8B. 8D, FFFFFF18
        mov     eax, dword [rbp-0D4H]                   ; 0DA1 _ 8B. 85, FFFFFF2C
        mov     rsi, rcx                                ; 0DA7 _ 48: 89. CE
        mov     edi, eax                                ; 0DAA _ 89. C7
        call    nasm_verror_critical                    ; 0DAC _ E8, 00000000(PLT r)
?_033:  lea     rdx, [rbp-0D0H]                         ; 0DB1 _ 48: 8D. 95, FFFFFF30
        mov     rcx, qword [rbp-0E8H]                   ; 0DB8 _ 48: 8B. 8D, FFFFFF18
        mov     eax, dword [rbp-0D4H]                   ; 0DBF _ 8B. 85, FFFFFF2C
        mov     rsi, rcx                                ; 0DC5 _ 48: 89. CE
        mov     edi, eax                                ; 0DC8 _ 89. C7
        call    nasm_verror                             ; 0DCA _ E8, 00000000(PLT r)
        cmp     dword [rbp-0D8H], 11                    ; 0DCF _ 83. BD, FFFFFF28, 0B
        ud2                                             ; 0DD6 _ 0F 0B
; nasm_panic End of function

nasm_warn_:; Function begin
        push    rbp                                     ; 0DD8 _ 55
        mov     rbp, rsp                                ; 0DD9 _ 48: 89. E5
        sub     rsp, 240                                ; 0DDC _ 48: 81. EC, 000000F0
        mov     dword [rbp-0E4H], edi                   ; 0DE3 _ 89. BD, FFFFFF1C
        mov     qword [rbp-0F0H], rsi                   ; 0DE9 _ 48: 89. B5, FFFFFF10
        mov     qword [rbp-0A0H], rdx                   ; 0DF0 _ 48: 89. 95, FFFFFF60
        mov     qword [rbp-98H], rcx                    ; 0DF7 _ 48: 89. 8D, FFFFFF68
        mov     qword [rbp-90H], r8                     ; 0DFE _ 4C: 89. 85, FFFFFF70
        mov     qword [rbp-88H], r9                     ; 0E05 _ 4C: 89. 8D, FFFFFF78
        test    al, al                                  ; 0E0C _ 84. C0
        jz      ?_034                                   ; 0E0E _ 74, 20
        movaps  oword [rbp-80H], xmm0                   ; 0E10 _ 0F 29. 45, 80
        movaps  oword [rbp-70H], xmm1                   ; 0E14 _ 0F 29. 4D, 90
        movaps  oword [rbp-60H], xmm2                   ; 0E18 _ 0F 29. 55, A0
        movaps  oword [rbp-50H], xmm3                   ; 0E1C _ 0F 29. 5D, B0
        movaps  oword [rbp-40H], xmm4                   ; 0E20 _ 0F 29. 65, C0
        movaps  oword [rbp-30H], xmm5                   ; 0E24 _ 0F 29. 6D, D0
        movaps  oword [rbp-20H], xmm6                   ; 0E28 _ 0F 29. 75, E0
        movaps  oword [rbp-10H], xmm7                   ; 0E2C _ 0F 29. 7D, F0
?_034:
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        mov     rax, qword [fs:abs 28H]                 ; 0E30 _ 64 48: 8B. 04 25, 00000028
        mov     qword [rbp-0B8H], rax                   ; 0E39 _ 48: 89. 85, FFFFFF48
        xor     eax, eax                                ; 0E40 _ 31. C0
        mov     dword [rbp-0D8H], 6                     ; 0E42 _ C7. 85, FFFFFF28, 00000006
        mov     eax, dword [rbp-0D8H]                   ; 0E4C _ 8B. 85, FFFFFF28
        or      eax, dword [rbp-0E4H]                   ; 0E52 _ 0B. 85, FFFFFF1C
        mov     dword [rbp-0D4H], eax                   ; 0E58 _ 89. 85, FFFFFF2C
        mov     dword [rbp-0D0H], 16                    ; 0E5E _ C7. 85, FFFFFF30, 00000010
        mov     dword [rbp-0CCH], 48                    ; 0E68 _ C7. 85, FFFFFF34, 00000030
        lea     rax, [rbp+10H]                          ; 0E72 _ 48: 8D. 45, 10
        mov     qword [rbp-0C8H], rax                   ; 0E76 _ 48: 89. 85, FFFFFF38
        lea     rax, [rbp-0B0H]                         ; 0E7D _ 48: 8D. 85, FFFFFF50
        mov     qword [rbp-0C0H], rax                   ; 0E84 _ 48: 89. 85, FFFFFF40
        cmp     dword [rbp-0D8H], 13                    ; 0E8B _ 83. BD, FFFFFF28, 0D
        jbe     ?_035                                   ; 0E92 _ 76, 1E
        lea     rdx, [rbp-0D0H]                         ; 0E94 _ 48: 8D. 95, FFFFFF30
        mov     rcx, qword [rbp-0F0H]                   ; 0E9B _ 48: 8B. 8D, FFFFFF10
        mov     eax, dword [rbp-0D4H]                   ; 0EA2 _ 8B. 85, FFFFFF2C
        mov     rsi, rcx                                ; 0EA8 _ 48: 89. CE
        mov     edi, eax                                ; 0EAB _ 89. C7
        call    nasm_verror_critical                    ; 0EAD _ E8, 00000000(PLT r)
?_035:  lea     rdx, [rbp-0D0H]                         ; 0EB2 _ 48: 8D. 95, FFFFFF30
        mov     rcx, qword [rbp-0F0H]                   ; 0EB9 _ 48: 8B. 8D, FFFFFF10
        mov     eax, dword [rbp-0D4H]                   ; 0EC0 _ 8B. 85, FFFFFF2C
        mov     rsi, rcx                                ; 0EC6 _ 48: 89. CE
        mov     edi, eax                                ; 0EC9 _ 89. C7
        call    nasm_verror                             ; 0ECB _ E8, 00000000(PLT r)
        cmp     dword [rbp-0D8H], 11                    ; 0ED0 _ 83. BD, FFFFFF28, 0B
        nop                                             ; 0ED7 _ 90
        mov     rax, qword [rbp-0B8H]                   ; 0ED8 _ 48: 8B. 85, FFFFFF48
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        sub     rax, qword [fs:abs 28H]                 ; 0EDF _ 64 48: 2B. 04 25, 00000028
        jz      ?_036                                   ; 0EE8 _ 74, 05
        call    __stack_chk_fail                        ; 0EEA _ E8, 00000000(PLT r)
?_036:  leave                                           ; 0EEF _ C9
        ret                                             ; 0EF0 _ C3
; nasm_warn_ End of function

nasm_info_:; Function begin
        push    rbp                                     ; 0EF1 _ 55
        mov     rbp, rsp                                ; 0EF2 _ 48: 89. E5
        sub     rsp, 240                                ; 0EF5 _ 48: 81. EC, 000000F0
        mov     dword [rbp-0E4H], edi                   ; 0EFC _ 89. BD, FFFFFF1C
        mov     qword [rbp-0F0H], rsi                   ; 0F02 _ 48: 89. B5, FFFFFF10
        mov     qword [rbp-0A0H], rdx                   ; 0F09 _ 48: 89. 95, FFFFFF60
        mov     qword [rbp-98H], rcx                    ; 0F10 _ 48: 89. 8D, FFFFFF68
        mov     qword [rbp-90H], r8                     ; 0F17 _ 4C: 89. 85, FFFFFF70
        mov     qword [rbp-88H], r9                     ; 0F1E _ 4C: 89. 8D, FFFFFF78
        test    al, al                                  ; 0F25 _ 84. C0
        jz      ?_037                                   ; 0F27 _ 74, 20
        movaps  oword [rbp-80H], xmm0                   ; 0F29 _ 0F 29. 45, 80
        movaps  oword [rbp-70H], xmm1                   ; 0F2D _ 0F 29. 4D, 90
        movaps  oword [rbp-60H], xmm2                   ; 0F31 _ 0F 29. 55, A0
        movaps  oword [rbp-50H], xmm3                   ; 0F35 _ 0F 29. 5D, B0
        movaps  oword [rbp-40H], xmm4                   ; 0F39 _ 0F 29. 65, C0
        movaps  oword [rbp-30H], xmm5                   ; 0F3D _ 0F 29. 6D, D0
        movaps  oword [rbp-20H], xmm6                   ; 0F41 _ 0F 29. 75, E0
        movaps  oword [rbp-10H], xmm7                   ; 0F45 _ 0F 29. 7D, F0
?_037:
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        mov     rax, qword [fs:abs 28H]                 ; 0F49 _ 64 48: 8B. 04 25, 00000028
        mov     qword [rbp-0B8H], rax                   ; 0F52 _ 48: 89. 85, FFFFFF48
        xor     eax, eax                                ; 0F59 _ 31. C0
        mov     eax, dword [rbp-0E4H]                   ; 0F5B _ 8B. 85, FFFFFF1C
        mov     edi, eax                                ; 0F61 _ 89. C7
        call    info_level                              ; 0F63 _ E8, FFFFF0B6
        test    al, al                                  ; 0F68 _ 84. C0
        je      ?_039                                   ; 0F6A _ 0F 84, 00000098
        mov     dword [rbp-0D8H], 5                     ; 0F70 _ C7. 85, FFFFFF28, 00000005
        mov     eax, dword [rbp-0E4H]                   ; 0F7A _ 8B. 85, FFFFFF1C
        shl     eax, 16                                 ; 0F80 _ C1. E0, 10
        or      eax, dword [rbp-0D8H]                   ; 0F83 _ 0B. 85, FFFFFF28
        mov     dword [rbp-0D4H], eax                   ; 0F89 _ 89. 85, FFFFFF2C
        mov     dword [rbp-0D0H], 16                    ; 0F8F _ C7. 85, FFFFFF30, 00000010
        mov     dword [rbp-0CCH], 48                    ; 0F99 _ C7. 85, FFFFFF34, 00000030
        lea     rax, [rbp+10H]                          ; 0FA3 _ 48: 8D. 45, 10
        mov     qword [rbp-0C8H], rax                   ; 0FA7 _ 48: 89. 85, FFFFFF38
        lea     rax, [rbp-0B0H]                         ; 0FAE _ 48: 8D. 85, FFFFFF50
        mov     qword [rbp-0C0H], rax                   ; 0FB5 _ 48: 89. 85, FFFFFF40
        cmp     dword [rbp-0D8H], 13                    ; 0FBC _ 83. BD, FFFFFF28, 0D
        jbe     ?_038                                   ; 0FC3 _ 76, 1E
        lea     rdx, [rbp-0D0H]                         ; 0FC5 _ 48: 8D. 95, FFFFFF30
        mov     rcx, qword [rbp-0F0H]                   ; 0FCC _ 48: 8B. 8D, FFFFFF10
        mov     eax, dword [rbp-0D4H]                   ; 0FD3 _ 8B. 85, FFFFFF2C
        mov     rsi, rcx                                ; 0FD9 _ 48: 89. CE
        mov     edi, eax                                ; 0FDC _ 89. C7
        call    nasm_verror_critical                    ; 0FDE _ E8, 00000000(PLT r)
?_038:  lea     rdx, [rbp-0D0H]                         ; 0FE3 _ 48: 8D. 95, FFFFFF30
        mov     rcx, qword [rbp-0F0H]                   ; 0FEA _ 48: 8B. 8D, FFFFFF10
        mov     eax, dword [rbp-0D4H]                   ; 0FF1 _ 8B. 85, FFFFFF2C
        mov     rsi, rcx                                ; 0FF7 _ 48: 89. CE
        mov     edi, eax                                ; 0FFA _ 89. C7
        call    nasm_verror                             ; 0FFC _ E8, 00000000(PLT r)
        cmp     dword [rbp-0D8H], 11                    ; 1001 _ 83. BD, FFFFFF28, 0B
?_039:  nop                                             ; 1008 _ 90
        mov     rax, qword [rbp-0B8H]                   ; 1009 _ 48: 8B. 85, FFFFFF48
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        sub     rax, qword [fs:abs 28H]                 ; 1010 _ 64 48: 2B. 04 25, 00000028
        jz      ?_040                                   ; 1019 _ 74, 05
        call    __stack_chk_fail                        ; 101B _ E8, 00000000(PLT r)
?_040:  leave                                           ; 1020 _ C9
        ret                                             ; 1021 _ C3
; nasm_info_ End of function

nasm_debug_:; Function begin
        push    rbp                                     ; 1022 _ 55
        mov     rbp, rsp                                ; 1023 _ 48: 89. E5
        sub     rsp, 240                                ; 1026 _ 48: 81. EC, 000000F0
        mov     dword [rbp-0E4H], edi                   ; 102D _ 89. BD, FFFFFF1C
        mov     qword [rbp-0F0H], rsi                   ; 1033 _ 48: 89. B5, FFFFFF10
        mov     qword [rbp-0A0H], rdx                   ; 103A _ 48: 89. 95, FFFFFF60
        mov     qword [rbp-98H], rcx                    ; 1041 _ 48: 89. 8D, FFFFFF68
        mov     qword [rbp-90H], r8                     ; 1048 _ 4C: 89. 85, FFFFFF70
        mov     qword [rbp-88H], r9                     ; 104F _ 4C: 89. 8D, FFFFFF78
        test    al, al                                  ; 1056 _ 84. C0
        jz      ?_041                                   ; 1058 _ 74, 20
        movaps  oword [rbp-80H], xmm0                   ; 105A _ 0F 29. 45, 80
        movaps  oword [rbp-70H], xmm1                   ; 105E _ 0F 29. 4D, 90
        movaps  oword [rbp-60H], xmm2                   ; 1062 _ 0F 29. 55, A0
        movaps  oword [rbp-50H], xmm3                   ; 1066 _ 0F 29. 5D, B0
        movaps  oword [rbp-40H], xmm4                   ; 106A _ 0F 29. 65, C0
        movaps  oword [rbp-30H], xmm5                   ; 106E _ 0F 29. 6D, D0
        movaps  oword [rbp-20H], xmm6                   ; 1072 _ 0F 29. 75, E0
        movaps  oword [rbp-10H], xmm7                   ; 1076 _ 0F 29. 7D, F0
?_041:
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        mov     rax, qword [fs:abs 28H]                 ; 107A _ 64 48: 8B. 04 25, 00000028
        mov     qword [rbp-0B8H], rax                   ; 1083 _ 48: 89. 85, FFFFFF48
        xor     eax, eax                                ; 108A _ 31. C0
        mov     eax, dword [rbp-0E4H]                   ; 108C _ 8B. 85, FFFFFF1C
        mov     edi, eax                                ; 1092 _ 89. C7
        call    debug_level                             ; 1094 _ E8, FFFFEF67
        test    al, al                                  ; 1099 _ 84. C0
        je      ?_043                                   ; 109B _ 0F 84, 00000098
        mov     dword [rbp-0D8H], 4                     ; 10A1 _ C7. 85, FFFFFF28, 00000004
        mov     eax, dword [rbp-0E4H]                   ; 10AB _ 8B. 85, FFFFFF1C
        shl     eax, 16                                 ; 10B1 _ C1. E0, 10
        or      eax, dword [rbp-0D8H]                   ; 10B4 _ 0B. 85, FFFFFF28
        mov     dword [rbp-0D4H], eax                   ; 10BA _ 89. 85, FFFFFF2C
        mov     dword [rbp-0D0H], 16                    ; 10C0 _ C7. 85, FFFFFF30, 00000010
        mov     dword [rbp-0CCH], 48                    ; 10CA _ C7. 85, FFFFFF34, 00000030
        lea     rax, [rbp+10H]                          ; 10D4 _ 48: 8D. 45, 10
        mov     qword [rbp-0C8H], rax                   ; 10D8 _ 48: 89. 85, FFFFFF38
        lea     rax, [rbp-0B0H]                         ; 10DF _ 48: 8D. 85, FFFFFF50
        mov     qword [rbp-0C0H], rax                   ; 10E6 _ 48: 89. 85, FFFFFF40
        cmp     dword [rbp-0D8H], 13                    ; 10ED _ 83. BD, FFFFFF28, 0D
        jbe     ?_042                                   ; 10F4 _ 76, 1E
        lea     rdx, [rbp-0D0H]                         ; 10F6 _ 48: 8D. 95, FFFFFF30
        mov     rcx, qword [rbp-0F0H]                   ; 10FD _ 48: 8B. 8D, FFFFFF10
        mov     eax, dword [rbp-0D4H]                   ; 1104 _ 8B. 85, FFFFFF2C
        mov     rsi, rcx                                ; 110A _ 48: 89. CE
        mov     edi, eax                                ; 110D _ 89. C7
        call    nasm_verror_critical                    ; 110F _ E8, 00000000(PLT r)
?_042:  lea     rdx, [rbp-0D0H]                         ; 1114 _ 48: 8D. 95, FFFFFF30
        mov     rcx, qword [rbp-0F0H]                   ; 111B _ 48: 8B. 8D, FFFFFF10
        mov     eax, dword [rbp-0D4H]                   ; 1122 _ 8B. 85, FFFFFF2C
        mov     rsi, rcx                                ; 1128 _ 48: 89. CE
        mov     edi, eax                                ; 112B _ 89. C7
        call    nasm_verror                             ; 112D _ E8, 00000000(PLT r)
        cmp     dword [rbp-0D8H], 11                    ; 1132 _ 83. BD, FFFFFF28, 0B
?_043:  nop                                             ; 1139 _ 90
        mov     rax, qword [rbp-0B8H]                   ; 113A _ 48: 8B. 85, FFFFFF48
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        sub     rax, qword [fs:abs 28H]                 ; 1141 _ 64 48: 2B. 04 25, 00000028
        jz      ?_044                                   ; 114A _ 74, 05
        call    __stack_chk_fail                        ; 114C _ E8, 00000000(PLT r)
?_044:  leave                                           ; 1151 _ C9
        ret                                             ; 1152 _ C3
; nasm_debug_ End of function

nasm_holderr:; Function begin
        push    rbp                                     ; 1153 _ 55
        mov     rbp, rsp                                ; 1154 _ 48: 89. E5
        sub     rsp, 240                                ; 1157 _ 48: 81. EC, 000000F0
        mov     qword [rbp-0E8H], rdi                   ; 115E _ 48: 89. BD, FFFFFF18
        mov     qword [rbp-0A8H], rsi                   ; 1165 _ 48: 89. B5, FFFFFF58
        mov     qword [rbp-0A0H], rdx                   ; 116C _ 48: 89. 95, FFFFFF60
        mov     qword [rbp-98H], rcx                    ; 1173 _ 48: 89. 8D, FFFFFF68
        mov     qword [rbp-90H], r8                     ; 117A _ 4C: 89. 85, FFFFFF70
        mov     qword [rbp-88H], r9                     ; 1181 _ 4C: 89. 8D, FFFFFF78
        test    al, al                                  ; 1188 _ 84. C0
        jz      ?_045                                   ; 118A _ 74, 20
        movaps  oword [rbp-80H], xmm0                   ; 118C _ 0F 29. 45, 80
        movaps  oword [rbp-70H], xmm1                   ; 1190 _ 0F 29. 4D, 90
        movaps  oword [rbp-60H], xmm2                   ; 1194 _ 0F 29. 55, A0
        movaps  oword [rbp-50H], xmm3                   ; 1198 _ 0F 29. 5D, B0
        movaps  oword [rbp-40H], xmm4                   ; 119C _ 0F 29. 65, C0
        movaps  oword [rbp-30H], xmm5                   ; 11A0 _ 0F 29. 6D, D0
        movaps  oword [rbp-20H], xmm6                   ; 11A4 _ 0F 29. 75, E0
        movaps  oword [rbp-10H], xmm7                   ; 11A8 _ 0F 29. 7D, F0
?_045:
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        mov     rax, qword [fs:abs 28H]                 ; 11AC _ 64 48: 8B. 04 25, 00000028
        mov     qword [rbp-0B8H], rax                   ; 11B5 _ 48: 89. 85, FFFFFF48
        xor     eax, eax                                ; 11BC _ 31. C0
        mov     dword [rbp-0D8H], 8                     ; 11BE _ C7. 85, FFFFFF28, 00000008
        mov     eax, dword [rbp-0D8H]                   ; 11C8 _ 8B. 85, FFFFFF28
        or      eax, 1008H                              ; 11CE _ 0D, 00001008
        mov     dword [rbp-0D4H], eax                   ; 11D3 _ 89. 85, FFFFFF2C
        mov     dword [rbp-0D0H], 8                     ; 11D9 _ C7. 85, FFFFFF30, 00000008
        mov     dword [rbp-0CCH], 48                    ; 11E3 _ C7. 85, FFFFFF34, 00000030
        lea     rax, [rbp+10H]                          ; 11ED _ 48: 8D. 45, 10
        mov     qword [rbp-0C8H], rax                   ; 11F1 _ 48: 89. 85, FFFFFF38
        lea     rax, [rbp-0B0H]                         ; 11F8 _ 48: 8D. 85, FFFFFF50
        mov     qword [rbp-0C0H], rax                   ; 11FF _ 48: 89. 85, FFFFFF40
        cmp     dword [rbp-0D8H], 13                    ; 1206 _ 83. BD, FFFFFF28, 0D
        jbe     ?_046                                   ; 120D _ 76, 1E
        lea     rdx, [rbp-0D0H]                         ; 120F _ 48: 8D. 95, FFFFFF30
        mov     rcx, qword [rbp-0E8H]                   ; 1216 _ 48: 8B. 8D, FFFFFF18
        mov     eax, dword [rbp-0D4H]                   ; 121D _ 8B. 85, FFFFFF2C
        mov     rsi, rcx                                ; 1223 _ 48: 89. CE
        mov     edi, eax                                ; 1226 _ 89. C7
        call    nasm_verror_critical                    ; 1228 _ E8, 00000000(PLT r)
?_046:  lea     rdx, [rbp-0D0H]                         ; 122D _ 48: 8D. 95, FFFFFF30
        mov     rcx, qword [rbp-0E8H]                   ; 1234 _ 48: 8B. 8D, FFFFFF18
        mov     eax, dword [rbp-0D4H]                   ; 123B _ 8B. 85, FFFFFF2C
        mov     rsi, rcx                                ; 1241 _ 48: 89. CE
        mov     edi, eax                                ; 1244 _ 89. C7
        call    nasm_verror                             ; 1246 _ E8, 00000000(PLT r)
        cmp     dword [rbp-0D8H], 11                    ; 124B _ 83. BD, FFFFFF28, 0B
        nop                                             ; 1252 _ 90
        mov     rax, qword [rbp-0B8H]                   ; 1253 _ 48: 8B. 85, FFFFFF48
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        sub     rax, qword [fs:abs 28H]                 ; 125A _ 64 48: 2B. 04 25, 00000028
        jz      ?_047                                   ; 1263 _ 74, 05
        call    __stack_chk_fail                        ; 1265 _ E8, 00000000(PLT r)
?_047:  leave                                           ; 126A _ C9
        ret                                             ; 126B _ C3
; nasm_holderr End of function

nasm_panic_from_macro:; Function begin
        push    rbp                                     ; 126C _ 55
        mov     rbp, rsp                                ; 126D _ 48: 89. E5
        sub     rsp, 32                                 ; 1270 _ 48: 83. EC, 20
        mov     qword [rbp-8H], rdi                     ; 1274 _ 48: 89. 7D, F8
        mov     qword [rbp-10H], rsi                    ; 1278 _ 48: 89. 75, F0
        mov     dword [rbp-14H], edx                    ; 127C _ 89. 55, EC
        cmp     qword [rbp-8H], 0                       ; 127F _ 48: 83. 7D, F8, 00
        jnz     ?_048                                   ; 1284 _ 75, 0B
        lea     rax, [rel ?_050]                        ; 1286 _ 48: 8D. 05, 00000000(rel)
        mov     qword [rbp-8H], rax                     ; 128D _ 48: 89. 45, F8
?_048:  mov     ecx, dword [rbp-14H]                    ; 1291 _ 8B. 4D, EC
        mov     rdx, qword [rbp-10H]                    ; 1294 _ 48: 8B. 55, F0
        mov     rax, qword [rbp-8H]                     ; 1298 _ 48: 8B. 45, F8
        lea     rdi, [rel ?_051]                        ; 129C _ 48: 8D. 3D, 00000000(rel)
        mov     rsi, rax                                ; 12A3 _ 48: 89. C6
        mov     eax, 0                                  ; 12A6 _ B8, 00000000
        call    nasm_panic                              ; 12AB _ E8, 00000000(PLT r)

nasm_assert_failed:
        push    rbp                                     ; 12B0 _ 55
        mov     rbp, rsp                                ; 12B1 _ 48: 89. E5
        sub     rsp, 32                                 ; 12B4 _ 48: 83. EC, 20
        mov     qword [rbp-8H], rdi                     ; 12B8 _ 48: 89. 7D, F8
        mov     qword [rbp-10H], rsi                    ; 12BC _ 48: 89. 75, F0
        mov     qword [rbp-18H], rdx                    ; 12C0 _ 48: 89. 55, E8
        mov     dword [rbp-1CH], ecx                    ; 12C4 _ 89. 4D, E4
        cmp     qword [rbp-10H], 0                      ; 12C7 _ 48: 83. 7D, F0, 00
        jnz     ?_049                                   ; 12CC _ 75, 0B
        lea     rax, [rel ?_050]                        ; 12CE _ 48: 8D. 05, 00000000(rel)
        mov     qword [rbp-10H], rax                    ; 12D5 _ 48: 89. 45, F0
?_049:  mov     esi, dword [rbp-1CH]                    ; 12D9 _ 8B. 75, E4
        mov     rcx, qword [rbp-18H]                    ; 12DC _ 48: 8B. 4D, E8
        mov     rdx, qword [rbp-10H]                    ; 12E0 _ 48: 8B. 55, F0
        mov     rax, qword [rbp-8H]                     ; 12E4 _ 48: 8B. 45, F8
        lea     rdi, [rel ?_052]                        ; 12E8 _ 48: 8D. 3D, 00000000(rel)
        mov     r8d, esi                                ; 12EF _ 41: 89. F0
        mov     rsi, rax                                ; 12F2 _ 48: 89. C6
        mov     eax, 0                                  ; 12F5 _ B8, 00000000
; Note: Function does not end with ret or jmp
        call    nasm_panic                              ; 12FA _ E8, 00000000(PLT r)
; nasm_panic_from_macro End of function


SECTION .data   align=1 noexec                          ; section number 2, data


SECTION .bss    align=32 noexec                         ; section number 3, bss

erropt:                                                 ; yword
        resd    8                                       ; 0000


SECTION .rodata align=8 noexec                          ; section number 4, const

?_050:                                                  ; byte
        db 3CH, 75H, 6EH, 6BH, 6EH, 6FH, 77H, 6EH       ; 0000 _ <unknown
        db 3EH, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0008 _ >.......

?_051:                                                  ; byte
        db 69H, 6EH, 74H, 65H, 72H, 6EH, 61H, 6CH       ; 0010 _ internal
        db 20H, 65H, 72H, 72H, 6FH, 72H, 20H, 69H       ; 0018 _  error i
        db 6EH, 20H, 25H, 73H, 20H, 61H, 74H, 20H       ; 0020 _ n %s at 
        db 25H, 73H, 3AH, 25H, 64H, 0AH, 00H, 00H       ; 0028 _ %s:%d...

?_052:                                                  ; byte
        db 61H, 73H, 73H, 65H, 72H, 74H, 69H, 6FH       ; 0030 _ assertio
        db 6EH, 20H, 25H, 73H, 20H, 66H, 61H, 69H       ; 0038 _ n %s fai
        db 6CH, 65H, 64H, 20H, 69H, 6EH, 20H, 25H       ; 0040 _ led in %
        db 73H, 20H, 61H, 74H, 20H, 25H, 73H, 3AH       ; 0048 _ s at %s:
        db 25H, 64H, 00H                                ; 0050 _ %d.


SECTION .note.gnu.property align=8 noexec               ; section number 5, const

        db 04H, 00H, 00H, 00H, 20H, 00H, 00H, 00H       ; 0000 _ .... ...
        db 05H, 00H, 00H, 00H, 47H, 4EH, 55H, 00H       ; 0008 _ ....GNU.
        db 02H, 00H, 01H, 0C0H, 04H, 00H, 00H, 00H      ; 0010 _ ........
        db 01H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0018 _ ........
        db 01H, 00H, 01H, 0C0H, 04H, 00H, 00H, 00H      ; 0020 _ ........
        db 09H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0028 _ ........


SECTION .eh_frame align=8 noexec                        ; section number 6, const

        db 14H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0000 _ ........
        db 01H, 7AH, 52H, 00H, 01H, 78H, 10H, 01H       ; 0008 _ .zR..x..
        db 1BH, 0CH, 07H, 08H, 90H, 01H, 00H, 00H       ; 0010 _ ........
        db 1CH, 00H, 00H, 00H, 1CH, 00H, 00H, 00H       ; 0018 _ ........
        dd debug_level-$-20H                            ; 0020 _ 00000000 (rel)
        dd 0000001EH, 100E4100H                         ; 0024 _ 30 269369600 
        dd 0D430286H, 070C5906H                         ; 002C _ 222495366 118249734 
        dd 00000008H, 0000001CH                         ; 0034 _ 8 28 
        dd 0000003CH                                    ; 003C _ 60 
        dd debug_level-$-22H                            ; 0040 _ 00000000 (rel)
        dd 0000001EH, 100E4100H                         ; 0044 _ 30 269369600 
        dd 0D430286H, 070C5906H                         ; 004C _ 222495366 118249734 
        dd 00000008H, 0000001CH                         ; 0054 _ 8 28 
        dd 0000005CH                                    ; 005C _ 92 
        dd debug_level-$-24H                            ; 0060 _ 00000000 (rel)
        dd 0000011EH, 100E4100H                         ; 0064 _ 286 269369600 
        dd 0D430286H, 01190306H                         ; 006C _ 222495366 18416390 
        dd 0008070CH, 0000001CH                         ; 0074 _ 526092 28 
        dd 0000007CH                                    ; 007C _ 124 
        dd debug_level-$+0DAH                           ; 0080 _ 00000000 (rel)
        dd 00000119H, 100E4100H                         ; 0084 _ 281 269369600 
        dd 0D430286H, 01140306H                         ; 008C _ 222495366 18088710 
        dd 0008070CH, 0000001CH                         ; 0094 _ 526092 28 
        dd 0000009CH                                    ; 009C _ 156 
        dd debug_level-$+1D3H                           ; 00A0 _ 00000000 (rel)
        dd 00000114H, 100E4100H                         ; 00A4 _ 276 269369600 
        dd 0D430286H, 010F0306H                         ; 00AC _ 222495366 17761030 
        dd 0008070CH, 0000001CH                         ; 00B4 _ 526092 28 
        dd 000000BCH                                    ; 00BC _ 188 
        dd debug_level-$+2C7H                           ; 00C0 _ 00000000 (rel)
        dd 00000119H, 100E4100H                         ; 00C4 _ 281 269369600 
        dd 0D430286H, 01140306H                         ; 00CC _ 222495366 18088710 
        dd 0008070CH, 0000001CH                         ; 00D4 _ 526092 28 
        dd 000000DCH                                    ; 00DC _ 220 
        dd debug_level-$+3C0H                           ; 00E0 _ 00000000 (rel)
        dd 00000114H, 100E4100H                         ; 00E4 _ 276 269369600 
        dd 0D430286H, 010F0306H                         ; 00EC _ 222495366 17761030 
        dd 0008070CH, 0000001CH                         ; 00F4 _ 526092 28 
        dd 000000FCH                                    ; 00FC _ 252 
        dd debug_level-$+4B4H                           ; 0100 _ 00000000 (rel)
        dd 00000119H, 100E4100H                         ; 0104 _ 281 269369600 
        dd 0D430286H, 01140306H                         ; 010C _ 222495366 18088710 
        dd 0008070CH, 0000001CH                         ; 0114 _ 526092 28 
        dd 0000011CH                                    ; 011C _ 284 
        dd debug_level-$+5ADH                           ; 0120 _ 00000000 (rel)
        dd 00000114H, 100E4100H                         ; 0124 _ 276 269369600 
        dd 0D430286H, 010F0306H                         ; 012C _ 222495366 17761030 
        dd 0008070CH, 00000018H                         ; 0134 _ 526092 24 
        dd 0000013CH                                    ; 013C _ 316 
        dd debug_level-$+6A1H                           ; 0140 _ 00000000 (rel)
        dd 00000101H, 100E4100H                         ; 0144 _ 257 269369600 
        dd 0D430286H, 00000006H                         ; 014C _ 222495366 6 
        dd 00000018H, 00000158H                         ; 0154 _ 24 344 
        dd debug_level-$+786H                           ; 015C _ 00000000 (rel)
        dd 000000FCH, 100E4100H                         ; 0160 _ 252 269369600 
        dd 0D430286H, 00000006H                         ; 0168 _ 222495366 6 
        dd 00000018H, 00000174H                         ; 0170 _ 24 372 
        dd debug_level-$+866H                           ; 0178 _ 00000000 (rel)
        dd 00000101H, 100E4100H                         ; 017C _ 257 269369600 
        dd 0D430286H, 00000006H                         ; 0184 _ 222495366 6 
        dd 00000018H, 00000190H                         ; 018C _ 24 400 
        dd debug_level-$+94BH                           ; 0194 _ 00000000 (rel)
        dd 000000FCH, 100E4100H                         ; 0198 _ 252 269369600 
        dd 0D430286H, 00000006H                         ; 01A0 _ 222495366 6 
        dd 00000018H, 000001ACH                         ; 01A8 _ 24 428 
        dd debug_level-$+0A2BH                          ; 01B0 _ 00000000 (rel)
        dd 00000101H, 100E4100H                         ; 01B4 _ 257 269369600 
        dd 0D430286H, 00000006H                         ; 01BC _ 222495366 6 
        dd 00000018H, 000001C8H                         ; 01C4 _ 24 456 
        dd debug_level-$+0B10H                          ; 01CC _ 00000000 (rel)
        dd 000000FCH, 100E4100H                         ; 01D0 _ 252 269369600 
        dd 0D430286H, 00000006H                         ; 01D8 _ 222495366 6 
        dd 0000001CH, 000001E4H                         ; 01E0 _ 28 484 
        dd debug_level-$+0BF0H                          ; 01E8 _ 00000000 (rel)
        dd 00000119H, 100E4100H                         ; 01EC _ 281 269369600 
        dd 0D430286H, 01140306H                         ; 01F4 _ 222495366 18088710 
        dd 0008070CH, 0000001CH                         ; 01FC _ 526092 28 
        dd 00000204H                                    ; 0204 _ 516 
        dd debug_level-$+0CE9H                          ; 0208 _ 00000000 (rel)
        dd 00000131H, 100E4100H                         ; 020C _ 305 269369600 
        dd 0D430286H, 012C0306H                         ; 0214 _ 222495366 19661574 
        dd 0008070CH, 0000001CH                         ; 021C _ 526092 28 
        dd 00000224H                                    ; 0224 _ 548 
        dd debug_level-$+0DFAH                          ; 0228 _ 00000000 (rel)
        dd 00000131H, 100E4100H                         ; 022C _ 305 269369600 
        dd 0D430286H, 012C0306H                         ; 0234 _ 222495366 19661574 
        dd 0008070CH, 0000001CH                         ; 023C _ 526092 28 
        dd 00000244H                                    ; 0244 _ 580 
        dd debug_level-$+0F0BH                          ; 0248 _ 00000000 (rel)
        dd 00000119H, 100E4100H                         ; 024C _ 281 269369600 
        dd 0D430286H, 01140306H                         ; 0254 _ 222495366 18088710 
        dd 0008070CH, 00000018H                         ; 025C _ 526092 24 
        dd 00000264H                                    ; 0264 _ 612 
        dd debug_level-$+1004H                          ; 0268 _ 00000000 (rel)
        dd 00000044H, 100E4100H                         ; 026C _ 68 269369600 
        dd 0D430286H, 00000006H                         ; 0274 _ 222495366 6 
        dd 00000018H, 00000280H                         ; 027C _ 24 640 
        dd debug_level-$+102CH                          ; 0284 _ 00000000 (rel)
        dd 0000004FH, 100E4100H                         ; 0288 _ 79 269369600 
        dd 0D430286H, 00000006H                         ; 0290 _ 222495366 6 


