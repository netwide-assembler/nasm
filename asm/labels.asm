; Disassembly of file: /tmp/tmp.n6LoRJ4kI1.o
; Wed Sep 23 14:43:26 2026
; Type: ELF64
; Syntax: NASM
; Instruction set: Pentium Pro, x64

default rel

global lookup_label: function
global set_label_mangle: function
global declare_label: function
global define_label: function
global backend_label: function
global init_labels: function
global cleanup_labels: function
global local_scope: function
global global_offset_changed

extern memcpy                                           ; near
extern strlen                                           ; near
extern hash_free                                        ; near
extern nasm_error                                       ; near
extern src_set                                          ; near
extern nasm_warn_                                       ; near
extern seg_alloc                                        ; near
extern nasm_nonfatal                                    ; near
extern strcasecmp                                       ; near
extern switch_segment                                   ; near
extern location                                         ; qword
extern __stack_chk_fail                                 ; near
extern hash_add                                         ; near
extern memset                                           ; near
extern nasm_malloc                                      ; near
extern nasm_free                                        ; near
extern hash_find                                        ; near
extern nasm_strcat                                      ; near
extern nasm_assert_failed                               ; near
extern dfmt                                             ; qword
extern ofmt                                             ; qword
extern tasm_compatible_mode                             ; byte
extern _passn                                           ; qword
extern _pass_type                                       ; dword
extern warning_state                                    ; byte
extern erropt                                           ; dword
extern _src_bottom                                      ; qword


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

src_get:; Local function
        push    rbp                                     ; 0024 _ 55
        mov     rbp, rsp                                ; 0025 _ 48: 89. E5
        mov     qword [rbp-18H], rdi                    ; 0028 _ 48: 89. 7D, E8
        mov     qword [rbp-20H], rsi                    ; 002C _ 48: 89. 75, E0
        mov     rax, qword [rbp-20H]                    ; 0030 _ 48: 8B. 45, E0
        mov     rax, qword [rax]                        ; 0034 _ 48: 8B. 00
        mov     qword [rbp-8H], rax                     ; 0037 _ 48: 89. 45, F8
        mov     rax, qword [rbp-18H]                    ; 003B _ 48: 8B. 45, E8
        mov     eax, dword [rax]                        ; 003F _ 8B. 00
        mov     dword [rbp-10H], eax                    ; 0041 _ 89. 45, F0
        mov     rax, qword [rel _src_bottom]            ; 0044 _ 48: 8B. 05, 00000000(rel)
        mov     eax, dword [rax+8H]                     ; 004B _ 8B. 40, 08
        mov     dword [rbp-0CH], eax                    ; 004E _ 89. 45, F4
        mov     rax, qword [rbp-18H]                    ; 0051 _ 48: 8B. 45, E8
        mov     edx, dword [rbp-0CH]                    ; 0055 _ 8B. 55, F4
        mov     dword [rax], edx                        ; 0058 _ 89. 10
        mov     rax, qword [rel _src_bottom]            ; 005A _ 48: 8B. 05, 00000000(rel)
        mov     rdx, qword [rax]                        ; 0061 _ 48: 8B. 10
        mov     rax, qword [rbp-20H]                    ; 0064 _ 48: 8B. 45, E0
        mov     qword [rax], rdx                        ; 0068 _ 48: 89. 10
        cmp     qword [rbp-8H], 0                       ; 006B _ 48: 83. 7D, F8, 00
        jz      ?_004                                   ; 0070 _ 74, 10
        mov     rax, qword [rel _src_bottom]            ; 0072 _ 48: 8B. 05, 00000000(rel)
        mov     rax, qword [rax]                        ; 0079 _ 48: 8B. 00
        cmp     qword [rbp-8H], rax                     ; 007C _ 48: 39. 45, F8
        jz      ?_005                                   ; 0080 _ 74, 07
?_004:  mov     eax, 4294967294                         ; 0082 _ B8, FFFFFFFE
        jmp     ?_006                                   ; 0087 _ EB, 06

?_005:  mov     eax, dword [rbp-0CH]                    ; 0089 _ 8B. 45, F4
        sub     eax, dword [rbp-10H]                    ; 008C _ 2B. 45, F0
?_006:  pop     rbp                                     ; 008F _ 5D
        ret                                             ; 0090 _ C3

warn_active:; Local function
        push    rbp                                     ; 0091 _ 55
        mov     rbp, rsp                                ; 0092 _ 48: 89. E5
        mov     dword [rbp-4H], edi                     ; 0095 _ 89. 7D, FC
        mov     eax, dword [rel erropt+0CH]             ; 0098 _ 8B. 05, 00000000(rel)
        and     eax, dword [rbp-4H]                     ; 009E _ 23. 45, FC
        test    eax, eax                                ; 00A1 _ 85. C0
        jz      ?_007                                   ; 00A3 _ 74, 07
        mov     eax, 0                                  ; 00A5 _ B8, 00000000
        jmp     ?_008                                   ; 00AA _ EB, 16

?_007:  mov     eax, dword [rbp-4H]                     ; 00AC _ 8B. 45, FC
        shr     eax, 16                                 ; 00AF _ C1. E8, 10
        mov     edx, eax                                ; 00B2 _ 89. C2
        lea     rax, [rel warning_state]                ; 00B4 _ 48: 8D. 05, 00000000(rel)
        movzx   eax, byte [rdx+rax]                     ; 00BB _ 0F B6. 04 02
        and     eax, 01H                                ; 00BF _ 83. E0, 01
?_008:  pop     rbp                                     ; 00C2 _ 5D
        ret                                             ; 00C3 _ C3

pass_type:; Local function
        push    rbp                                     ; 00C4 _ 55
        mov     rbp, rsp                                ; 00C5 _ 48: 89. E5
        mov     eax, dword [rel _pass_type]             ; 00C8 _ 8B. 05, 00000000(rel)
        pop     rbp                                     ; 00CE _ 5D
        ret                                             ; 00CF _ C3

pass_stable:; Local function
        push    rbp                                     ; 00D0 _ 55
        mov     rbp, rsp                                ; 00D1 _ 48: 89. E5
        call    pass_type                               ; 00D4 _ E8, FFFFFFEB
        cmp     eax, 3                                  ; 00D9 _ 83. F8, 03
        seta    al                                      ; 00DC _ 0F 97. C0
        pop     rbp                                     ; 00DF _ 5D
        ret                                             ; 00E0 _ C3

pass_final:; Local function
        push    rbp                                     ; 00E1 _ 55
        mov     rbp, rsp                                ; 00E2 _ 48: 89. E5
        call    pass_type                               ; 00E5 _ E8, FFFFFFDA
        cmp     eax, 4                                  ; 00EA _ 83. F8, 04
        seta    al                                      ; 00ED _ 0F 97. C0
        pop     rbp                                     ; 00F0 _ 5D
        ret                                             ; 00F1 _ C3

pass_count:; Local function
        push    rbp                                     ; 00F2 _ 55
        mov     rbp, rsp                                ; 00F3 _ 48: 89. E5
        mov     rax, qword [rel _passn]                 ; 00F6 _ 48: 8B. 05, 00000000(rel)
        pop     rbp                                     ; 00FD _ 5D
        ret                                             ; 00FE _ C3

islocal:; Local function
        push    rbp                                     ; 00FF _ 55
        mov     rbp, rsp                                ; 0100 _ 48: 89. E5
        mov     qword [rbp-8H], rdi                     ; 0103 _ 48: 89. 7D, F8
        movzx   eax, byte [rel tasm_compatible_mode]    ; 0107 _ 0F B6. 05, 00000000(rel)
        test    al, al                                  ; 010E _ 84. C0
        jz      ?_009                                   ; 0110 _ 74, 21
        mov     rax, qword [rbp-8H]                     ; 0112 _ 48: 8B. 45, F8
        movzx   eax, byte [rax]                         ; 0116 _ 0F B6. 00
        cmp     al, 64                                  ; 0119 _ 3C, 40
        jnz     ?_009                                   ; 011B _ 75, 16
        mov     rax, qword [rbp-8H]                     ; 011D _ 48: 8B. 45, F8
        add     rax, 1                                  ; 0121 _ 48: 83. C0, 01
        movzx   eax, byte [rax]                         ; 0125 _ 0F B6. 00
        cmp     al, 64                                  ; 0128 _ 3C, 40
        jnz     ?_009                                   ; 012A _ 75, 07
        mov     eax, 1                                  ; 012C _ B8, 00000001
        jmp     ?_012                                   ; 0131 _ EB, 29

?_009:  mov     rax, qword [rbp-8H]                     ; 0133 _ 48: 8B. 45, F8
        movzx   eax, byte [rax]                         ; 0137 _ 0F B6. 00
        cmp     al, 46                                  ; 013A _ 3C, 2E
        jnz     ?_010                                   ; 013C _ 75, 16
        mov     rax, qword [rbp-8H]                     ; 013E _ 48: 8B. 45, F8
        add     rax, 1                                  ; 0142 _ 48: 83. C0, 01
        movzx   eax, byte [rax]                         ; 0146 _ 0F B6. 00
        cmp     al, 46                                  ; 0149 _ 3C, 2E
        jz      ?_010                                   ; 014B _ 74, 07
        mov     eax, 1                                  ; 014D _ B8, 00000001
        jmp     ?_011                                   ; 0152 _ EB, 05

?_010:  mov     eax, 0                                  ; 0154 _ B8, 00000000
?_011:  and     eax, 01H                                ; 0159 _ 83. E0, 01
?_012:  pop     rbp                                     ; 015C _ 5D
        ret                                             ; 015D _ C3

ismagic:; Local function
        push    rbp                                     ; 015E _ 55
        mov     rbp, rsp                                ; 015F _ 48: 89. E5
        mov     qword [rbp-8H], rdi                     ; 0162 _ 48: 89. 7D, F8
        mov     rax, qword [rbp-8H]                     ; 0166 _ 48: 8B. 45, F8
        movzx   eax, byte [rax]                         ; 016A _ 0F B6. 00
        cmp     al, 46                                  ; 016D _ 3C, 2E
        jnz     ?_013                                   ; 016F _ 75, 25
        mov     rax, qword [rbp-8H]                     ; 0171 _ 48: 8B. 45, F8
        add     rax, 1                                  ; 0175 _ 48: 83. C0, 01
        movzx   eax, byte [rax]                         ; 0179 _ 0F B6. 00
        cmp     al, 46                                  ; 017C _ 3C, 2E
        jnz     ?_013                                   ; 017E _ 75, 16
        mov     rax, qword [rbp-8H]                     ; 0180 _ 48: 8B. 45, F8
        add     rax, 2                                  ; 0184 _ 48: 83. C0, 02
        movzx   eax, byte [rax]                         ; 0188 _ 0F B6. 00
        cmp     al, 64                                  ; 018B _ 3C, 40
        jz      ?_013                                   ; 018D _ 74, 07
        mov     eax, 1                                  ; 018F _ B8, 00000001
        jmp     ?_014                                   ; 0194 _ EB, 05

?_013:  mov     eax, 0                                  ; 0196 _ B8, 00000000
?_014:  and     eax, 01H                                ; 019B _ 83. E0, 01
        pop     rbp                                     ; 019E _ 5D
        ret                                             ; 019F _ C3

set_prevlabel:; Local function
        push    rbp                                     ; 01A0 _ 55
        mov     rbp, rsp                                ; 01A1 _ 48: 89. E5
        mov     qword [rbp-8H], rdi                     ; 01A4 _ 48: 89. 7D, F8
        movzx   eax, byte [rel tasm_compatible_mode]    ; 01A8 _ 0F B6. 05, 00000000(rel)
        test    al, al                                  ; 01AF _ 84. C0
        jz      ?_015                                   ; 01B1 _ 74, 21
        mov     rax, qword [rbp-8H]                     ; 01B3 _ 48: 8B. 45, F8
        movzx   eax, byte [rax]                         ; 01B7 _ 0F B6. 00
        cmp     al, 64                                  ; 01BA _ 3C, 40
        jnz     ?_015                                   ; 01BC _ 75, 16
        mov     rax, qword [rbp-8H]                     ; 01BE _ 48: 8B. 45, F8
        add     rax, 1                                  ; 01C2 _ 48: 83. C0, 01
        movzx   eax, byte [rax]                         ; 01C6 _ 0F B6. 00
        cmp     al, 64                                  ; 01C9 _ 3C, 40
        jnz     ?_015                                   ; 01CB _ 75, 07
        mov     eax, 0                                  ; 01CD _ B8, 00000000
        jmp     ?_016                                   ; 01D2 _ EB, 0C

?_015:  mov     rax, qword [rbp-8H]                     ; 01D4 _ 48: 8B. 45, F8
        movzx   eax, byte [rax]                         ; 01D8 _ 0F B6. 00
        cmp     al, 46                                  ; 01DB _ 3C, 2E
        setne   al                                      ; 01DD _ 0F 95. C0
?_016:  pop     rbp                                     ; 01E0 _ 5D
        ret                                             ; 01E1 _ C3

out_symdef:; Local function
        push    rbp                                     ; 01E2 _ 55
        mov     rbp, rsp                                ; 01E3 _ 48: 89. E5
        push    rbx                                     ; 01E6 _ 53
        sub     rsp, 40                                 ; 01E7 _ 48: 83. EC, 28
        mov     qword [rbp-28H], rdi                    ; 01EB _ 48: 89. 7D, D8
        call    pass_final                              ; 01EF _ E8, FFFFFEED
        test    al, al                                  ; 01F4 _ 84. C0
        jz      ?_020                                   ; 01F6 _ 74, 67
        mov     rax, qword [rbp-28H]                    ; 01F8 _ 48: 8B. 45, D8
        mov     eax, dword [rax+4CH]                    ; 01FC _ 8B. 40, 4C
        cmp     eax, 2                                  ; 01FF _ 83. F8, 02
        jz      ?_017                                   ; 0202 _ 74, 0D
        cmp     eax, 2                                  ; 0204 _ 83. F8, 02
        jl      ?_018                                   ; 0207 _ 7C, 4A
        sub     eax, 4                                  ; 0209 _ 83. E8, 04
        cmp     eax, 1                                  ; 020C _ 83. F8, 01
        ja      ?_018                                   ; 020F _ 77, 42
?_017:  mov     rax, qword [rbp-28H]                    ; 0211 _ 48: 8B. 45, D8
        mov     rax, qword [rax+38H]                    ; 0215 _ 48: 8B. 40, 38
        test    rax, rax                                ; 0219 _ 48: 85. C0
        jz      ?_019                                   ; 021C _ 74, 3B
        mov     rax, qword [rel ofmt]                   ; 021E _ 48: 8B. 05, 00000000(rel)
        mov     r9, qword [rax+50H]                     ; 0225 _ 4C: 8B. 48, 50
        mov     rax, qword [rbp-28H]                    ; 0229 _ 48: 8B. 45, D8
        mov     rdx, qword [rax+38H]                    ; 022D _ 48: 8B. 50, 38
        mov     rax, qword [rbp-28H]                    ; 0231 _ 48: 8B. 45, D8
        mov     rax, qword [rax+30H]                    ; 0235 _ 48: 8B. 40, 30
        mov     r8, rdx                                 ; 0239 _ 49: 89. D0
        mov     ecx, 3                                  ; 023C _ B9, 00000003
        mov     edx, 0                                  ; 0241 _ BA, 00000000
        mov     esi, 0                                  ; 0246 _ BE, 00000000
        mov     rdi, rax                                ; 024B _ 48: 89. C7
        call    r9                                      ; 024E _ 41: FF. D1
        jmp     ?_019                                   ; 0251 _ EB, 06

?_018:  nop                                             ; 0253 _ 90
        jmp     ?_029                                   ; 0254 _ E9, 00000137

?_019:  nop                                             ; 0259 _ 90
        jmp     ?_029                                   ; 025A _ E9, 00000131

?_020:  call    pass_type                               ; 025F _ E8, FFFFFE60
        cmp     eax, 4                                  ; 0264 _ 83. F8, 04
        jz      ?_021                                   ; 0267 _ 74, 10
        mov     rax, qword [rbp-28H]                    ; 0269 _ 48: 8B. 45, D8
        mov     eax, dword [rax+4CH]                    ; 026D _ 8B. 40, 4C
        cmp     eax, 7                                  ; 0270 _ 83. F8, 07
        jne     ?_026                                   ; 0273 _ 0F 85, 00000110
?_021:  mov     rax, qword [rbp-28H]                    ; 0279 _ 48: 8B. 45, D8
        mov     eax, dword [rax+4CH]                    ; 027D _ 8B. 40, 4C
        cmp     eax, 5                                  ; 0280 _ 83. F8, 05
        jz      ?_023                                   ; 0283 _ 74, 4F
        cmp     eax, 5                                  ; 0285 _ 83. F8, 05
        jg      ?_024                                   ; 0288 _ 7F, 5F
        cmp     eax, 4                                  ; 028A _ 83. F8, 04
        jz      ?_022                                   ; 028D _ 74, 30
        cmp     eax, 4                                  ; 028F _ 83. F8, 04
        jg      ?_024                                   ; 0292 _ 7F, 55
        cmp     eax, 2                                  ; 0294 _ 83. F8, 02
        jz      ?_022                                   ; 0297 _ 74, 26
        cmp     eax, 3                                  ; 0299 _ 83. F8, 03
        jnz     ?_024                                   ; 029C _ 75, 4B
        mov     rax, qword [rbp-28H]                    ; 029E _ 48: 8B. 45, D8
        mov     rbx, qword [rax+20H]                    ; 02A2 _ 48: 8B. 58, 20
        call    pass_count                              ; 02A6 _ E8, FFFFFE47
        cmp     rbx, rax                                ; 02AB _ 48: 39. C3
        jl      ?_027                                   ; 02AE _ 0F 8C, 000000D8
        mov     rax, qword [rbp-28H]                    ; 02B4 _ 48: 8B. 45, D8
        mov     dword [rax+4CH], 4                      ; 02B8 _ C7. 40, 4C, 00000004
?_022:  mov     dword [rbp-1CH], 1                      ; 02BF _ C7. 45, E4, 00000001
        mov     rax, qword [rbp-28H]                    ; 02C6 _ 48: 8B. 45, D8
        mov     rax, qword [rax+8H]                     ; 02CA _ 48: 8B. 40, 08
        mov     qword [rbp-18H], rax                    ; 02CE _ 48: 89. 45, E8
        jmp     ?_025                                   ; 02D2 _ EB, 29

?_023:  mov     dword [rbp-1CH], 2                      ; 02D4 _ C7. 45, E4, 00000002
        mov     rax, qword [rbp-28H]                    ; 02DB _ 48: 8B. 45, D8
        mov     rax, qword [rax+10H]                    ; 02DF _ 48: 8B. 40, 10
        mov     qword [rbp-18H], rax                    ; 02E3 _ 48: 89. 45, E8
        jmp     ?_025                                   ; 02E7 _ EB, 14

?_024:  mov     dword [rbp-1CH], 0                      ; 02E9 _ C7. 45, E4, 00000000
        mov     rax, qword [rbp-28H]                    ; 02F0 _ 48: 8B. 45, D8
        mov     rax, qword [rax+8H]                     ; 02F4 _ 48: 8B. 40, 08
        mov     qword [rbp-18H], rax                    ; 02F8 _ 48: 89. 45, E8
        nop                                             ; 02FC _ 90
?_025:  mov     rax, qword [rbp-28H]                    ; 02FD _ 48: 8B. 45, D8
        mov     rdi, rax                                ; 0301 _ 48: 89. C7
        call    mangle_label_name                       ; 0304 _ E8, 00000429
        mov     rax, qword [rel ofmt]                   ; 0309 _ 48: 8B. 05, 00000000(rel)
        mov     r9, qword [rax+50H]                     ; 0310 _ 4C: 8B. 48, 50
        mov     rax, qword [rbp-28H]                    ; 0314 _ 48: 8B. 45, D8
        mov     rdi, qword [rax+38H]                    ; 0318 _ 48: 8B. 78, 38
        mov     rax, qword [rbp-28H]                    ; 031C _ 48: 8B. 45, D8
        mov     esi, dword [rax]                        ; 0320 _ 8B. 30
        mov     rax, qword [rbp-28H]                    ; 0322 _ 48: 8B. 45, D8
        mov     rax, qword [rax+30H]                    ; 0326 _ 48: 8B. 40, 30
        mov     ecx, dword [rbp-1CH]                    ; 032A _ 8B. 4D, E4
        mov     rdx, qword [rbp-18H]                    ; 032D _ 48: 8B. 55, E8
        mov     r8, rdi                                 ; 0331 _ 49: 89. F8
        mov     rdi, rax                                ; 0334 _ 48: 89. C7
        call    r9                                      ; 0337 _ 41: FF. D1
        mov     rax, qword [rbp-28H]                    ; 033A _ 48: 8B. 45, D8
        mov     eax, dword [rax+4CH]                    ; 033E _ 8B. 40, 4C
        cmp     eax, 6                                  ; 0341 _ 83. F8, 06
        jz      ?_028                                   ; 0344 _ 74, 49
        mov     rax, qword [rbp-28H]                    ; 0346 _ 48: 8B. 45, D8
        mov     eax, dword [rax+4CH]                    ; 034A _ 8B. 40, 4C
        cmp     eax, 7                                  ; 034D _ 83. F8, 07
        jz      ?_028                                   ; 0350 _ 74, 3D
        mov     rax, qword [rel dfmt]                   ; 0352 _ 48: 8B. 05, 00000000(rel)
        mov     r9, qword [rax+20H]                     ; 0359 _ 4C: 8B. 48, 20
        mov     rax, qword [rbp-28H]                    ; 035D _ 48: 8B. 45, D8
        mov     rdi, qword [rax+38H]                    ; 0361 _ 48: 8B. 78, 38
        mov     rax, qword [rbp-28H]                    ; 0365 _ 48: 8B. 45, D8
        mov     rdx, qword [rax+8H]                     ; 0369 _ 48: 8B. 50, 08
        mov     rax, qword [rbp-28H]                    ; 036D _ 48: 8B. 45, D8
        mov     esi, dword [rax]                        ; 0371 _ 8B. 30
        mov     rax, qword [rbp-28H]                    ; 0373 _ 48: 8B. 45, D8
        mov     rax, qword [rax+30H]                    ; 0377 _ 48: 8B. 40, 30
        mov     ecx, dword [rbp-1CH]                    ; 037B _ 8B. 4D, E4
        mov     r8, rdi                                 ; 037E _ 49: 89. F8
        mov     rdi, rax                                ; 0381 _ 48: 89. C7
        call    r9                                      ; 0384 _ 41: FF. D1
        jmp     ?_029                                   ; 0387 _ EB, 07

?_026:  nop                                             ; 0389 _ 90
        jmp     ?_029                                   ; 038A _ EB, 04

?_027:  nop                                             ; 038C _ 90
        jmp     ?_029                                   ; 038D _ EB, 01

?_028:  nop                                             ; 038F _ 90
?_029:  mov     rbx, qword [rbp-8H]                     ; 0390 _ 48: 8B. 5D, F8
        leave                                           ; 0394 _ C9
        ret                                             ; 0395 _ C3

find_label:; Local function
        push    rbp                                     ; 0396 _ 55
        mov     rbp, rsp                                ; 0397 _ 48: 89. E5
        push    rbx                                     ; 039A _ 53
        sub     rsp, 136                                ; 039B _ 48: 81. EC, 00000088
        mov     qword [rbp-78H], rdi                    ; 03A2 _ 48: 89. 7D, 88
        mov     byte [rbp-79H], sil                     ; 03A6 _ 40: 88. 75, 87
        mov     qword [rbp-88H], rdx                    ; 03AA _ 48: 89. 95, FFFFFF78
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        mov     rax, qword [fs:abs 28H]                 ; 03B1 _ 64 48: 8B. 04 25, 00000028
        mov     qword [rbp-18H], rax                    ; 03BA _ 48: 89. 45, E8
        xor     eax, eax                                ; 03BE _ 31. C0
        mov     qword [rbp-60H], 0                      ; 03C0 _ 48: C7. 45, A0, 00000000
        cmp     qword [rbp-78H], 0                      ; 03C8 _ 48: 83. 7D, 88, 00
        sete    al                                      ; 03CD _ 0F 94. C0
        movzx   eax, al                                 ; 03D0 _ 0F B6. C0
        test    rax, rax                                ; 03D3 _ 48: 85. C0
        jz      ?_030                                   ; 03D6 _ 74, 22
        lea     rdx, [rel ?_128]                        ; 03D8 _ 48: 8D. 15, 00000000(rel)
        lea     rsi, [rel __func__.1]                   ; 03DF _ 48: 8D. 35, 00000000(rel)
        lea     rax, [rel ?_129]                        ; 03E6 _ 48: 8D. 05, 00000000(rel)
        mov     ecx, 202                                ; 03ED _ B9, 000000CA
        mov     rdi, rax                                ; 03F2 _ 48: 89. C7
        call    nasm_assert_failed                      ; 03F5 _ E8, 00000000(PLT r)
?_030:  mov     rax, qword [rbp-78H]                    ; 03FA _ 48: 8B. 45, 88
        mov     rdi, rax                                ; 03FE _ 48: 89. C7
        call    islocal                                 ; 0401 _ E8, FFFFFCF9
        test    al, al                                  ; 0406 _ 84. C0
        jz      ?_031                                   ; 0408 _ 74, 22
        mov     rax, qword [rel prevlabel]              ; 040A _ 48: 8B. 05, 00000000(rel)
        mov     rdx, qword [rbp-78H]                    ; 0411 _ 48: 8B. 55, 88
        mov     rsi, rdx                                ; 0415 _ 48: 89. D6
        mov     rdi, rax                                ; 0418 _ 48: 89. C7
        call    nasm_strcat                             ; 041B _ E8, 00000000(PLT r)
        mov     qword [rbp-60H], rax                    ; 0420 _ 48: 89. 45, A0
        mov     rax, qword [rbp-60H]                    ; 0424 _ 48: 8B. 45, A0
        mov     qword [rbp-78H], rax                    ; 0428 _ 48: 89. 45, 88
?_031:  lea     rdx, [rbp-50H]                          ; 042C _ 48: 8D. 55, B0
        mov     rax, qword [rbp-78H]                    ; 0430 _ 48: 8B. 45, 88
        lea     rcx, [rel ltab]                         ; 0434 _ 48: 8D. 0D, 00000000(rel)
        mov     rsi, rax                                ; 043B _ 48: 89. C6
        mov     rdi, rcx                                ; 043E _ 48: 89. CF
        call    hash_find                               ; 0441 _ E8, 00000000(PLT r)
        mov     qword [rbp-58H], rax                    ; 0446 _ 48: 89. 45, A8
        cmp     qword [rbp-58H], 0                      ; 044A _ 48: 83. 7D, A8, 00
        jz      ?_032                                   ; 044F _ 74, 0D
        mov     rax, qword [rbp-58H]                    ; 0451 _ 48: 8B. 45, A8
        mov     rax, qword [rax]                        ; 0455 _ 48: 8B. 00
        mov     qword [rbp-68H], rax                    ; 0458 _ 48: 89. 45, 98
        jmp     ?_033                                   ; 045C _ EB, 08

?_032:  mov     qword [rbp-68H], 0                      ; 045E _ 48: C7. 45, 98, 00000000
?_033:  cmp     qword [rbp-68H], 0                      ; 0466 _ 48: 83. 7D, 98, 00
        jnz     ?_034                                   ; 046B _ 75, 0B
        movzx   eax, byte [rbp-79H]                     ; 046D _ 0F B6. 45, 87
        xor     eax, 01H                                ; 0471 _ 83. F0, 01
        test    al, al                                  ; 0474 _ 84. C0
        jz      ?_037                                   ; 0476 _ 74, 30
?_034:  cmp     qword [rbp-88H], 0                      ; 0478 _ 48: 83. BD, FFFFFF78, 00
        jz      ?_035                                   ; 0480 _ 74, 0A
        mov     rax, qword [rbp-88H]                    ; 0482 _ 48: 8B. 85, FFFFFF78
        mov     byte [rax], 0                           ; 0489 _ C6. 00, 00
?_035:  cmp     qword [rbp-60H], 0                      ; 048C _ 48: 83. 7D, A0, 00
        jz      ?_036                                   ; 0491 _ 74, 0C
        mov     rax, qword [rbp-60H]                    ; 0493 _ 48: 8B. 45, A0
        mov     rdi, rax                                ; 0497 _ 48: 89. C7
        call    nasm_free                               ; 049A _ E8, 00000000(PLT r)
?_036:  mov     rax, qword [rbp-68H]                    ; 049F _ 48: 8B. 45, 98
        jmp     ?_041                                   ; 04A3 _ E9, 000000DC

?_037:  mov     rax, qword [rel lfree]                  ; 04A8 _ 48: 8B. 05, 00000000(rel)
        mov     eax, dword [rax]                        ; 04AF _ 8B. 00
        cmp     eax, -2                                 ; 04B1 _ 83. F8, FE
        jnz     ?_038                                   ; 04B4 _ 75, 36
        mov     rbx, qword [rel lfree]                  ; 04B6 _ 48: 8B. 1D, 00000000(rel)
        mov     edi, 11264                              ; 04BD _ BF, 00002C00
        call    nasm_malloc                             ; 04C2 _ E8, 00000000(PLT r)
        mov     qword [rbx+10H], rax                    ; 04C7 _ 48: 89. 43, 10
        mov     rax, qword [rel lfree]                  ; 04CB _ 48: 8B. 05, 00000000(rel)
        mov     rax, qword [rax+10H]                    ; 04D2 _ 48: 8B. 40, 10
        mov     qword [rel lfree], rax                  ; 04D6 _ 48: 89. 05, 00000000(rel)
        mov     rax, qword [rel lfree]                  ; 04DD _ 48: 8B. 05, 00000000(rel)
        mov     rdi, rax                                ; 04E4 _ 48: 89. C7
        call    init_block                              ; 04E7 _ E8, 00000C9B
?_038:  cmp     qword [rbp-88H], 0                      ; 04EC _ 48: 83. BD, FFFFFF78, 00
        jz      ?_039                                   ; 04F4 _ 74, 0A
        mov     rax, qword [rbp-88H]                    ; 04F6 _ 48: 8B. 85, FFFFFF78
        mov     byte [rax], 1                           ; 04FD _ C6. 00, 01
?_039:  mov     rax, qword [rel lfree]                  ; 0500 _ 48: 8B. 05, 00000000(rel)
        mov     edx, 88                                 ; 0507 _ BA, 00000058
        mov     esi, 0                                  ; 050C _ BE, 00000000
        mov     rdi, rax                                ; 0511 _ 48: 89. C7
        call    memset                                  ; 0514 _ E8, 00000000(PLT r)
        mov     rbx, qword [rel lfree]                  ; 0519 _ 48: 8B. 1D, 00000000(rel)
        mov     rax, qword [rbp-78H]                    ; 0520 _ 48: 8B. 45, 88
        mov     rdi, rax                                ; 0524 _ 48: 89. C7
        call    perm_copy                               ; 0527 _ E8, 00000D89
        mov     qword [rbx+28H], rax                    ; 052C _ 48: 89. 43, 28
        mov     rax, qword [rel lfree]                  ; 0530 _ 48: 8B. 05, 00000000(rel)
        mov     dword [rax+4H], -1                      ; 0537 _ C7. 40, 04, FFFFFFFF
        cmp     qword [rbp-60H], 0                      ; 053E _ 48: 83. 7D, A0, 00
        jz      ?_040                                   ; 0543 _ 74, 0C
        mov     rax, qword [rbp-60H]                    ; 0545 _ 48: 8B. 45, A0
        mov     rdi, rax                                ; 0549 _ 48: 89. C7
        call    nasm_free                               ; 054C _ E8, 00000000(PLT r)
?_040:  mov     rdx, qword [rel lfree]                  ; 0551 _ 48: 8B. 15, 00000000(rel)
        mov     rax, qword [rel lfree]                  ; 0558 _ 48: 8B. 05, 00000000(rel)
        mov     rcx, qword [rax+28H]                    ; 055F _ 48: 8B. 48, 28
        lea     rax, [rbp-50H]                          ; 0563 _ 48: 8D. 45, B0
        mov     rsi, rcx                                ; 0567 _ 48: 89. CE
        mov     rdi, rax                                ; 056A _ 48: 89. C7
        call    hash_add                                ; 056D _ E8, 00000000(PLT r)
        mov     rax, qword [rel lfree]                  ; 0572 _ 48: 8B. 05, 00000000(rel)
        lea     rdx, [rax+58H]                          ; 0579 _ 48: 8D. 50, 58
        mov     qword [rel lfree], rdx                  ; 057D _ 48: 89. 15, 00000000(rel)
?_041:  mov     rdx, qword [rbp-18H]                    ; 0584 _ 48: 8B. 55, E8
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        sub     rdx, qword [fs:abs 28H]                 ; 0588 _ 64 48: 2B. 14 25, 00000028
        jz      ?_042                                   ; 0591 _ 74, 05
        call    __stack_chk_fail                        ; 0593 _ E8, 00000000(PLT r)
?_042:  mov     rbx, qword [rbp-8H]                     ; 0598 _ 48: 8B. 5D, F8
        leave                                           ; 059C _ C9
        ret                                             ; 059D _ C3

lookup_label:; Function begin
        push    rbp                                     ; 059E _ 55
        mov     rbp, rsp                                ; 059F _ 48: 89. E5
        sub     rsp, 48                                 ; 05A2 _ 48: 83. EC, 30
        mov     qword [rbp-18H], rdi                    ; 05A6 _ 48: 89. 7D, E8
        mov     qword [rbp-20H], rsi                    ; 05AA _ 48: 89. 75, E0
        mov     qword [rbp-28H], rdx                    ; 05AE _ 48: 89. 55, D8
        movzx   eax, byte [rel initialized]             ; 05B2 _ 0F B6. 05, 00000000(rel)
        xor     eax, 01H                                ; 05B9 _ 83. F0, 01
        test    al, al                                  ; 05BC _ 84. C0
        jz      ?_043                                   ; 05BE _ 74, 07
        mov     eax, 4294967295                         ; 05C0 _ B8, FFFFFFFF
        jmp     ?_045                                   ; 05C5 _ EB, 70

?_043:  mov     rax, qword [rbp-18H]                    ; 05C7 _ 48: 8B. 45, E8
        mov     edx, 0                                  ; 05CB _ BA, 00000000
        mov     esi, 0                                  ; 05D0 _ BE, 00000000
        mov     rdi, rax                                ; 05D5 _ 48: 89. C7
        call    find_label                              ; 05D8 _ E8, FFFFFDB9
        mov     qword [rbp-10H], rax                    ; 05DD _ 48: 89. 45, F0
        cmp     qword [rbp-10H], 0                      ; 05E1 _ 48: 83. 7D, F0, 00
        jz      ?_044                                   ; 05E6 _ 74, 4A
        mov     rax, qword [rbp-10H]                    ; 05E8 _ 48: 8B. 45, F0
        mov     rax, qword [rax+18H]                    ; 05EC _ 48: 8B. 40, 18
        test    rax, rax                                ; 05F0 _ 48: 85. C0
        jz      ?_044                                   ; 05F3 _ 74, 3D
        call    pass_count                              ; 05F5 _ E8, FFFFFAF8
        add     rax, 1                                  ; 05FA _ 48: 83. C0, 01
        mov     qword [rbp-8H], rax                     ; 05FE _ 48: 89. 45, F8
        mov     rax, qword [rbp-10H]                    ; 0602 _ 48: 8B. 45, F0
        mov     rdx, qword [rbp-8H]                     ; 0606 _ 48: 8B. 55, F8
        mov     qword [rax+20H], rdx                    ; 060A _ 48: 89. 50, 20
        mov     rax, qword [rbp-10H]                    ; 060E _ 48: 8B. 45, F0
        mov     edx, dword [rax]                        ; 0612 _ 8B. 10
        mov     rax, qword [rbp-20H]                    ; 0614 _ 48: 8B. 45, E0
        mov     dword [rax], edx                        ; 0618 _ 89. 10
        mov     rax, qword [rbp-10H]                    ; 061A _ 48: 8B. 45, F0
        mov     rdx, qword [rax+8H]                     ; 061E _ 48: 8B. 50, 08
        mov     rax, qword [rbp-28H]                    ; 0622 _ 48: 8B. 45, D8
        mov     qword [rax], rdx                        ; 0626 _ 48: 89. 10
        mov     rax, qword [rbp-10H]                    ; 0629 _ 48: 8B. 45, F0
        mov     eax, dword [rax+4CH]                    ; 062D _ 8B. 40, 4C
        jmp     ?_045                                   ; 0630 _ EB, 05

?_044:  mov     eax, 4294967295                         ; 0632 _ B8, FFFFFFFF
?_045:  leave                                           ; 0637 _ C9
        ret                                             ; 0638 _ C3
; lookup_label End of function

is_global:; Local function
        push    rbp                                     ; 0639 _ 55
        mov     rbp, rsp                                ; 063A _ 48: 89. E5
        mov     dword [rbp-4H], edi                     ; 063D _ 89. 7D, FC
        cmp     dword [rbp-4H], 2                       ; 0640 _ 83. 7D, FC, 02
        jz      ?_046                                   ; 0644 _ 74, 06
        cmp     dword [rbp-4H], 5                       ; 0646 _ 83. 7D, FC, 05
        jnz     ?_047                                   ; 064A _ 75, 07
?_046:  mov     eax, 1                                  ; 064C _ B8, 00000001
        jmp     ?_048                                   ; 0651 _ EB, 05

?_047:  mov     eax, 0                                  ; 0653 _ B8, 00000000
?_048:  and     eax, 01H                                ; 0658 _ 83. E0, 01
        pop     rbp                                     ; 065B _ 5D
        ret                                             ; 065C _ C3

set_label_mangle:; Function begin
        push    rbp                                     ; 065D _ 55
        mov     rbp, rsp                                ; 065E _ 48: 89. E5
        sub     rsp, 32                                 ; 0661 _ 48: 83. EC, 20
        mov     dword [rbp-14H], edi                    ; 0665 _ 89. 7D, EC
        mov     qword [rbp-20H], rsi                    ; 0668 _ 48: 89. 75, E0
        cmp     dword [rbp-14H], 29                     ; 066C _ 83. 7D, EC, 1D
        ja      ?_054                                   ; 0670 _ 0F 87, 000000B6
        cmp     dword [rbp-14H], 28                     ; 0676 _ 83. 7D, EC, 1C
        jnc     ?_052                                   ; 067A _ 73, 64
        cmp     dword [rbp-14H], 27                     ; 067C _ 83. 7D, EC, 1B
        jz      ?_051                                   ; 0680 _ 74, 55
        cmp     dword [rbp-14H], 27                     ; 0682 _ 83. 7D, EC, 1B
        ja      ?_054                                   ; 0686 _ 0F 87, 000000A0
        cmp     dword [rbp-14H], 26                     ; 068C _ 83. 7D, EC, 1A
        ja      ?_054                                   ; 0690 _ 0F 87, 00000096
        cmp     dword [rbp-14H], 25                     ; 0696 _ 83. 7D, EC, 19
        jnc     ?_050                                   ; 069A _ 73, 32
        cmp     dword [rbp-14H], 24                     ; 069C _ 83. 7D, EC, 18
        jz      ?_049                                   ; 06A0 _ 74, 23
        cmp     dword [rbp-14H], 24                     ; 06A2 _ 83. 7D, EC, 18
        ja      ?_054                                   ; 06A6 _ 0F 87, 00000080
        cmp     dword [rbp-14H], 21                     ; 06AC _ 83. 7D, EC, 15
        jz      ?_049                                   ; 06B0 _ 74, 13
        cmp     dword [rbp-14H], 21                     ; 06B2 _ 83. 7D, EC, 15
        jc      ?_054                                   ; 06B6 _ 72, 74
        mov     eax, dword [rbp-14H]                    ; 06B8 _ 8B. 45, EC
        sub     eax, 22                                 ; 06BB _ 83. E8, 16
        cmp     eax, 1                                  ; 06BE _ 83. F8, 01
        ja      ?_054                                   ; 06C1 _ 77, 69
        jmp     ?_050                                   ; 06C3 _ EB, 09

?_049:  mov     dword [rbp-4H], 2                       ; 06C5 _ C7. 45, FC, 00000002
        jmp     ?_053                                   ; 06CC _ EB, 1A

?_050:  mov     dword [rbp-4H], 3                       ; 06CE _ C7. 45, FC, 00000003
        jmp     ?_053                                   ; 06D5 _ EB, 11

?_051:  mov     dword [rbp-4H], 0                       ; 06D7 _ C7. 45, FC, 00000000
        jmp     ?_053                                   ; 06DE _ EB, 08

?_052:  mov     dword [rbp-4H], 1                       ; 06E0 _ C7. 45, FC, 00000001
        nop                                             ; 06E7 _ 90
?_053:  mov     eax, dword [rbp-4H]                     ; 06E8 _ 8B. 45, FC
        lea     rdx, [rel mangle_string_set]            ; 06EB _ 48: 8D. 15, 00000000(rel)
        movzx   eax, byte [rax+rdx]                     ; 06F2 _ 0F B6. 04 10
        test    al, al                                  ; 06F6 _ 84. C0
        jnz     ?_055                                   ; 06F8 _ 75, 35
        mov     rax, qword [rbp-20H]                    ; 06FA _ 48: 8B. 45, E0
        mov     rdi, rax                                ; 06FE _ 48: 89. C7
        call    perm_copy                               ; 0701 _ E8, 00000BAF
        mov     edx, dword [rbp-4H]                     ; 0706 _ 8B. 55, FC
        lea     rcx, [rdx*8]                            ; 0709 _ 48: 8D. 0C D5, 00000000
        lea     rdx, [rel mangle_strings]               ; 0711 _ 48: 8D. 15, 00000000(rel)
        mov     qword [rcx+rdx], rax                    ; 0718 _ 48: 89. 04 11
        mov     eax, dword [rbp-4H]                     ; 071C _ 8B. 45, FC
        lea     rdx, [rel mangle_string_set]            ; 071F _ 48: 8D. 15, 00000000(rel)
        mov     byte [rax+rdx], 1                       ; 0726 _ C6. 04 10, 01
        jmp     ?_056                                   ; 072A _ EB, 04

?_054:  nop                                             ; 072C _ 90
        jmp     ?_056                                   ; 072D _ EB, 01

?_055:  nop                                             ; 072F _ 90
?_056:  leave                                           ; 0730 _ C9
        ret                                             ; 0731 _ C3
; set_label_mangle End of function

mangle_label_name:; Local function
        push    rbp                                     ; 0732 _ 55
        mov     rbp, rsp                                ; 0733 _ 48: 89. E5
        sub     rsp, 32                                 ; 0736 _ 48: 83. EC, 20
        mov     qword [rbp-18H], rdi                    ; 073A _ 48: 89. 7D, E8
        mov     rax, qword [rbp-18H]                    ; 073E _ 48: 8B. 45, E8
        mov     rax, qword [rax+30H]                    ; 0742 _ 48: 8B. 40, 30
        test    rax, rax                                ; 0746 _ 48: 85. C0
        setne   al                                      ; 0749 _ 0F 95. C0
        movzx   eax, al                                 ; 074C _ 0F B6. C0
        test    rax, rax                                ; 074F _ 48: 85. C0
        jz      ?_057                                   ; 0752 _ 74, 28
        mov     rax, qword [rbp-18H]                    ; 0754 _ 48: 8B. 45, E8
        mov     edx, dword [rax+50H]                    ; 0758 _ 8B. 50, 50
        mov     rax, qword [rbp-18H]                    ; 075B _ 48: 8B. 45, E8
        mov     eax, dword [rax+4CH]                    ; 075F _ 8B. 40, 4C
        cmp     edx, eax                                ; 0762 _ 39. C2
        sete    al                                      ; 0764 _ 0F 94. C0
        movzx   eax, al                                 ; 0767 _ 0F B6. C0
        test    rax, rax                                ; 076A _ 48: 85. C0
        jz      ?_057                                   ; 076D _ 74, 0D
        mov     rax, qword [rbp-18H]                    ; 076F _ 48: 8B. 45, E8
        mov     rax, qword [rax+30H]                    ; 0773 _ 48: 8B. 40, 30
        jmp     ?_065                                   ; 0777 _ E9, 000000C1

?_057:  mov     rax, qword [rbp-18H]                    ; 077C _ 48: 8B. 45, E8
        mov     eax, dword [rax+4CH]                    ; 0780 _ 8B. 40, 4C
        cmp     eax, 4                                  ; 0783 _ 83. F8, 04
        jg      ?_058                                   ; 0786 _ 7F, 06
        test    eax, eax                                ; 0788 _ 85. C0
        jg      ?_059                                   ; 078A _ 7F, 0C
        jmp     ?_061                                   ; 078C _ EB, 37

?_058:  sub     eax, 6                                  ; 078E _ 83. E8, 06
        cmp     eax, 1                                  ; 0791 _ 83. F8, 01
        ja      ?_061                                   ; 0794 _ 77, 2F
        jmp     ?_060                                   ; 0796 _ EB, 18

?_059:  mov     rax, qword [rel ?_142]                  ; 0798 _ 48: 8B. 05, 00000000(rel)
        mov     qword [rbp-10H], rax                    ; 079F _ 48: 89. 45, F0
        mov     rax, qword [rel ?_143]                  ; 07A3 _ 48: 8B. 05, 00000000(rel)
        mov     qword [rbp-8H], rax                     ; 07AA _ 48: 89. 45, F8
        jmp     ?_062                                   ; 07AE _ EB, 2C

?_060:  lea     rax, [rel ?_130]                        ; 07B0 _ 48: 8D. 05, 00000000(rel)
        mov     qword [rbp-8H], rax                     ; 07B7 _ 48: 89. 45, F8
        mov     rax, qword [rbp-8H]                     ; 07BB _ 48: 8B. 45, F8
        mov     qword [rbp-10H], rax                    ; 07BF _ 48: 89. 45, F0
        jmp     ?_062                                   ; 07C3 _ EB, 17

?_061:  mov     rax, qword [rel mangle_strings]         ; 07C5 _ 48: 8B. 05, 00000000(rel)
        mov     qword [rbp-10H], rax                    ; 07CC _ 48: 89. 45, F0
        mov     rax, qword [rel ?_141]                  ; 07D0 _ 48: 8B. 05, 00000000(rel)
        mov     qword [rbp-8H], rax                     ; 07D7 _ 48: 89. 45, F8
        nop                                             ; 07DB _ 90
?_062:  mov     rax, qword [rbp-18H]                    ; 07DC _ 48: 8B. 45, E8
        mov     edx, dword [rax+4CH]                    ; 07E0 _ 8B. 50, 4C
        mov     rax, qword [rbp-18H]                    ; 07E3 _ 48: 8B. 45, E8
        mov     dword [rax+50H], edx                    ; 07E7 _ 89. 50, 50
        mov     rax, qword [rbp-10H]                    ; 07EA _ 48: 8B. 45, F0
        movzx   eax, byte [rax]                         ; 07EE _ 0F B6. 00
        test    al, al                                  ; 07F1 _ 84. C0
        jnz     ?_063                                   ; 07F3 _ 75, 1D
        mov     rax, qword [rbp-8H]                     ; 07F5 _ 48: 8B. 45, F8
        movzx   eax, byte [rax]                         ; 07F9 _ 0F B6. 00
        test    al, al                                  ; 07FC _ 84. C0
        jnz     ?_063                                   ; 07FE _ 75, 12
        mov     rax, qword [rbp-18H]                    ; 0800 _ 48: 8B. 45, E8
        mov     rdx, qword [rax+28H]                    ; 0804 _ 48: 8B. 50, 28
        mov     rax, qword [rbp-18H]                    ; 0808 _ 48: 8B. 45, E8
        mov     qword [rax+30H], rdx                    ; 080C _ 48: 89. 50, 30
        jmp     ?_064                                   ; 0810 _ EB, 23

?_063:  mov     rax, qword [rbp-18H]                    ; 0812 _ 48: 8B. 45, E8
        mov     rcx, qword [rax+28H]                    ; 0816 _ 48: 8B. 48, 28
        mov     rdx, qword [rbp-8H]                     ; 081A _ 48: 8B. 55, F8
        mov     rax, qword [rbp-10H]                    ; 081E _ 48: 8B. 45, F0
        mov     rsi, rcx                                ; 0822 _ 48: 89. CE
        mov     rdi, rax                                ; 0825 _ 48: 89. C7
        call    perm_copy3                              ; 0828 _ E8, 00000AE3
        mov     rdx, qword [rbp-18H]                    ; 082D _ 48: 8B. 55, E8
        mov     qword [rdx+30H], rax                    ; 0831 _ 48: 89. 42, 30
?_064:  mov     rax, qword [rbp-18H]                    ; 0835 _ 48: 8B. 45, E8
        mov     rax, qword [rax+30H]                    ; 0839 _ 48: 8B. 40, 30
?_065:  leave                                           ; 083D _ C9
        ret                                             ; 083E _ C3

handle_herelabel:; Local function
        push    rbp                                     ; 083F _ 55
        mov     rbp, rsp                                ; 0840 _ 48: 89. E5
        sub     rsp, 64                                 ; 0843 _ 48: 83. EC, 40
        mov     qword [rbp-28H], rdi                    ; 0847 _ 48: 89. 7D, D8
        mov     qword [rbp-30H], rsi                    ; 084B _ 48: 89. 75, D0
        mov     qword [rbp-38H], rdx                    ; 084F _ 48: 89. 55, C8
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        mov     rax, qword [fs:abs 28H]                 ; 0853 _ 64 48: 8B. 04 25, 00000028
        mov     qword [rbp-8H], rax                     ; 085C _ 48: 89. 45, F8
        xor     eax, eax                                ; 0860 _ 31. C0
        mov     rax, qword [rel ofmt]                   ; 0862 _ 48: 8B. 05, 00000000(rel)
        mov     rax, qword [rax+60H]                    ; 0869 _ 48: 8B. 40, 60
        test    rax, rax                                ; 086D _ 48: 85. C0
        sete    al                                      ; 0870 _ 0F 94. C0
        movzx   eax, al                                 ; 0873 _ 0F B6. C0
        test    rax, rax                                ; 0876 _ 48: 85. C0
        jne     ?_068                                   ; 0879 _ 0F 85, 00000107
        mov     eax, dword [rel location+8H]            ; 087F _ 8B. 05, 00000000(rel)
        cmp     eax, -1                                 ; 0885 _ 83. F8, FF
        sete    al                                      ; 0888 _ 0F 94. C0
        movzx   eax, al                                 ; 088B _ 0F B6. C0
        test    rax, rax                                ; 088E _ 48: 85. C0
        jne     ?_069                                   ; 0891 _ 0F 85, 000000F2
        mov     rax, qword [rbp-30H]                    ; 0897 _ 48: 8B. 45, D0
        mov     eax, dword [rax]                        ; 089B _ 8B. 00
        mov     dword [rbp-10H], eax                    ; 089D _ 89. 45, F0
        mov     eax, dword [rel location+8H]            ; 08A0 _ 8B. 05, 00000000(rel)
        cmp     dword [rbp-10H], eax                    ; 08A6 _ 39. 45, F0
        jne     ?_071                                   ; 08A9 _ 0F 85, 000000DE
        mov     rax, qword [rbp-38H]                    ; 08AF _ 48: 8B. 45, C8
        mov     rdx, qword [rax]                        ; 08B3 _ 48: 8B. 10
        mov     rax, qword [rel location]               ; 08B6 _ 48: 8B. 05, 00000000(rel)
        cmp     rdx, rax                                ; 08BD _ 48: 39. C2
        jne     ?_071                                   ; 08C0 _ 0F 85, 000000C7
        mov     byte [rbp-11H], 0                       ; 08C6 _ C6. 45, EF, 00
        mov     rax, qword [rbp-28H]                    ; 08CA _ 48: 8B. 45, D8
        mov     rax, qword [rax+30H]                    ; 08CE _ 48: 8B. 40, 30
        test    rax, rax                                ; 08D2 _ 48: 85. C0
        sete    al                                      ; 08D5 _ 0F 94. C0
        movzx   eax, al                                 ; 08D8 _ 0F B6. C0
        test    rax, rax                                ; 08DB _ 48: 85. C0
        jz      ?_066                                   ; 08DE _ 74, 22
        lea     rdx, [rel ?_128]                        ; 08E0 _ 48: 8D. 15, 00000000(rel)
        lea     rsi, [rel __func__.0]                   ; 08E7 _ 48: 8D. 35, 00000000(rel)
        lea     rax, [rel ?_131]                        ; 08EE _ 48: 8D. 05, 00000000(rel)
        mov     ecx, 372                                ; 08F5 _ B9, 00000174
        mov     rdi, rax                                ; 08FA _ 48: 89. C7
        call    nasm_assert_failed                      ; 08FD _ E8, 00000000(PLT r)
?_066:  mov     rax, qword [rel ofmt]                   ; 0902 _ 48: 8B. 05, 00000000(rel)
        mov     r9, qword [rax+60H]                     ; 0909 _ 4C: 8B. 48, 60
        mov     rax, qword [rbp-28H]                    ; 090D _ 48: 8B. 45, D8
        lea     rcx, [rax+4H]                           ; 0911 _ 48: 8D. 48, 04
        mov     rax, qword [rbp-28H]                    ; 0915 _ 48: 8B. 45, D8
        mov     esi, dword [rax+4CH]                    ; 0919 _ 8B. 70, 4C
        mov     rax, qword [rbp-28H]                    ; 091C _ 48: 8B. 45, D8
        mov     rax, qword [rax+30H]                    ; 0920 _ 48: 8B. 40, 30
        lea     rdi, [rbp-11H]                          ; 0924 _ 48: 8D. 7D, EF
        mov     edx, dword [rbp-10H]                    ; 0928 _ 8B. 55, F0
        mov     r8, rdi                                 ; 092B _ 49: 89. F8
        mov     rdi, rax                                ; 092E _ 48: 89. C7
        call    r9                                      ; 0931 _ 41: FF. D1
        mov     dword [rbp-0CH], eax                    ; 0934 _ 89. 45, F4
        mov     eax, dword [rbp-0CH]                    ; 0937 _ 8B. 45, F4
        cmp     eax, dword [rbp-10H]                    ; 093A _ 3B. 45, F0
        sete    al                                      ; 093D _ 0F 94. C0
        movzx   eax, al                                 ; 0940 _ 0F B6. C0
        test    rax, rax                                ; 0943 _ 48: 85. C0
        jnz     ?_070                                   ; 0946 _ 75, 44
        mov     rax, qword [rbp-30H]                    ; 0948 _ 48: 8B. 45, D0
        mov     edx, dword [rbp-0CH]                    ; 094C _ 8B. 55, F4
        mov     dword [rax], edx                        ; 094F _ 89. 10
        movzx   eax, byte [rbp-11H]                     ; 0951 _ 0F B6. 45, EF
        test    al, al                                  ; 0955 _ 84. C0
        jz      ?_067                                   ; 0957 _ 74, 1A
        mov     eax, dword [rbp-0CH]                    ; 0959 _ 8B. 45, F4
        mov     edi, eax                                ; 095C _ 89. C7
        call    switch_segment                          ; 095E _ E8, 00000000(PLT r)
        mov     rax, qword [rbp-38H]                    ; 0963 _ 48: 8B. 45, C8
        mov     rax, qword [rax]                        ; 0967 _ 48: 8B. 00
        mov     qword [rel location], rax               ; 096A _ 48: 89. 05, 00000000(rel)
        jmp     ?_071                                   ; 0971 _ EB, 1A

?_067:  mov     eax, dword [rbp-0CH]                    ; 0973 _ 8B. 45, F4
        mov     edi, eax                                ; 0976 _ 89. C7
        call    switch_segment                          ; 0978 _ E8, 00000000(PLT r)
        mov     rdx, qword [rbp-38H]                    ; 097D _ 48: 8B. 55, C8
        mov     qword [rdx], rax                        ; 0981 _ 48: 89. 02
        jmp     ?_071                                   ; 0984 _ EB, 07

?_068:  nop                                             ; 0986 _ 90
        jmp     ?_071                                   ; 0987 _ EB, 04

?_069:  nop                                             ; 0989 _ 90
        jmp     ?_071                                   ; 098A _ EB, 01

?_070:  nop                                             ; 098C _ 90
?_071:  mov     rax, qword [rbp-8H]                     ; 098D _ 48: 8B. 45, F8
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        sub     rax, qword [fs:abs 28H]                 ; 0991 _ 64 48: 2B. 04 25, 00000028
        jz      ?_072                                   ; 099A _ 74, 05
        call    __stack_chk_fail                        ; 099C _ E8, 00000000(PLT r)
?_072:  leave                                           ; 09A1 _ C9
        ret                                             ; 09A2 _ C3

declare_label_lptr:; Local function
        push    rbp                                     ; 09A3 _ 55
        mov     rbp, rsp                                ; 09A4 _ 48: 89. E5
        sub     rsp, 48                                 ; 09A7 _ 48: 83. EC, 30
        mov     qword [rbp-18H], rdi                    ; 09AB _ 48: 89. 7D, E8
        mov     dword [rbp-1CH], esi                    ; 09AF _ 89. 75, E4
        mov     qword [rbp-28H], rdx                    ; 09B2 _ 48: 89. 55, D8
        mov     rax, qword [rbp-18H]                    ; 09B6 _ 48: 8B. 45, E8
        mov     eax, dword [rax+4CH]                    ; 09BA _ 8B. 40, 4C
        mov     dword [rbp-4H], eax                     ; 09BD _ 89. 45, FC
        cmp     qword [rbp-28H], 0                      ; 09C0 _ 48: 83. 7D, D8, 00
        jz      ?_073                                   ; 09C5 _ 74, 13
        mov     rax, qword [rbp-28H]                    ; 09C7 _ 48: 8B. 45, D8
        movzx   eax, byte [rax]                         ; 09CB _ 0F B6. 00
        test    al, al                                  ; 09CE _ 84. C0
        jnz     ?_073                                   ; 09D0 _ 75, 08
        mov     qword [rbp-28H], 0                      ; 09D2 _ 48: C7. 45, D8, 00000000
?_073:  call    pass_stable                             ; 09DA _ E8, FFFFF6F1
        xor     eax, 01H                                ; 09DF _ 83. F0, 01
        test    al, al                                  ; 09E2 _ 84. C0
        jz      ?_076                                   ; 09E4 _ 74, 3A
        cmp     dword [rbp-4H], 0                       ; 09E6 _ 83. 7D, FC, 00
        jnz     ?_076                                   ; 09EA _ 75, 34
        mov     eax, dword [rbp-1CH]                    ; 09EC _ 8B. 45, E4
        mov     edi, eax                                ; 09EF _ 89. C7
        call    is_extern                               ; 09F1 _ E8, FFFFF60A
        test    al, al                                  ; 09F6 _ 84. C0
        jz      ?_074                                   ; 09F8 _ 74, 16
        mov     rax, qword [rbp-18H]                    ; 09FA _ 48: 8B. 45, E8
        mov     rax, qword [rax+18H]                    ; 09FE _ 48: 8B. 40, 18
        test    rax, rax                                ; 0A02 _ 48: 85. C0
        jz      ?_074                                   ; 0A05 _ 74, 09
        mov     dword [rbp-4H], 2                       ; 0A07 _ C7. 45, FC, 00000002
        jmp     ?_075                                   ; 0A0E _ EB, 06

?_074:  mov     eax, dword [rbp-1CH]                    ; 0A10 _ 8B. 45, E4
        mov     dword [rbp-4H], eax                     ; 0A13 _ 89. 45, FC
?_075:  mov     rax, qword [rbp-18H]                    ; 0A16 _ 48: 8B. 45, E8
        mov     edx, dword [rbp-4H]                     ; 0A1A _ 8B. 55, FC
        mov     dword [rax+4CH], edx                    ; 0A1D _ 89. 50, 4C
?_076:  mov     eax, dword [rbp-4H]                     ; 0A20 _ 8B. 45, FC
        cmp     eax, dword [rbp-1CH]                    ; 0A23 _ 3B. 45, E4
        jz      ?_077                                   ; 0A26 _ 74, 14
        cmp     dword [rbp-4H], 3                       ; 0A28 _ 83. 7D, FC, 03
        jne     ?_080                                   ; 0A2C _ 0F 85, 0000008B
        cmp     dword [rbp-1CH], 4                      ; 0A32 _ 83. 7D, E4, 04
        jne     ?_080                                   ; 0A36 _ 0F 85, 00000081
?_077:  mov     rax, qword [rbp-18H]                    ; 0A3C _ 48: 8B. 45, E8
        mov     edx, dword [rbp-1CH]                    ; 0A40 _ 8B. 55, E4
        mov     dword [rax+4CH], edx                    ; 0A43 _ 89. 50, 4C
        cmp     qword [rbp-28H], 0                      ; 0A46 _ 48: 83. 7D, D8, 00
        jz      ?_079                                   ; 0A4B _ 74, 66
        mov     rax, qword [rbp-18H]                    ; 0A4D _ 48: 8B. 45, E8
        mov     rax, qword [rax+38H]                    ; 0A51 _ 48: 8B. 40, 38
        test    rax, rax                                ; 0A55 _ 48: 85. C0
        jnz     ?_078                                   ; 0A58 _ 75, 16
        mov     rax, qword [rbp-28H]                    ; 0A5A _ 48: 8B. 45, D8
        mov     rdi, rax                                ; 0A5E _ 48: 89. C7
        call    perm_copy                               ; 0A61 _ E8, 0000084F
        mov     rdx, qword [rbp-18H]                    ; 0A66 _ 48: 8B. 55, E8
        mov     qword [rdx+38H], rax                    ; 0A6A _ 48: 89. 42, 38
        jmp     ?_079                                   ; 0A6E _ EB, 43

?_078:  mov     rax, qword [rbp-18H]                    ; 0A70 _ 48: 8B. 45, E8
        mov     rax, qword [rax+38H]                    ; 0A74 _ 48: 8B. 40, 38
        mov     rdx, qword [rbp-28H]                    ; 0A78 _ 48: 8B. 55, D8
        mov     rsi, rdx                                ; 0A7C _ 48: 89. D6
        mov     rdi, rax                                ; 0A7F _ 48: 89. C7
        call    strcasecmp                              ; 0A82 _ E8, 00000000(PLT r)
        test    eax, eax                                ; 0A87 _ 85. C0
        jz      ?_079                                   ; 0A89 _ 74, 28
        mov     rax, qword [rbp-18H]                    ; 0A8B _ 48: 8B. 45, E8
        mov     rdx, qword [rax+38H]                    ; 0A8F _ 48: 8B. 50, 38
        mov     rax, qword [rbp-18H]                    ; 0A93 _ 48: 8B. 45, E8
        mov     rax, qword [rax+28H]                    ; 0A97 _ 48: 8B. 40, 28
        mov     rcx, qword [rbp-28H]                    ; 0A9B _ 48: 8B. 4D, D8
        lea     rdi, [rel ?_132]                        ; 0A9F _ 48: 8D. 3D, 00000000(rel)
        mov     rsi, rax                                ; 0AA6 _ 48: 89. C6
        mov     eax, 0                                  ; 0AA9 _ B8, 00000000
        call    nasm_nonfatal                           ; 0AAE _ E8, 00000000(PLT r)
?_079:  mov     eax, 1                                  ; 0AB3 _ B8, 00000001
        jmp     ?_086                                   ; 0AB8 _ E9, 000000FE

?_080:  mov     eax, dword [rbp-4H]                     ; 0ABD _ 8B. 45, FC
        mov     edi, eax                                ; 0AC0 _ 89. C7
        call    is_extern                               ; 0AC2 _ E8, FFFFF539
        test    al, al                                  ; 0AC7 _ 84. C0
        jz      ?_082                                   ; 0AC9 _ 74, 49
        mov     eax, dword [rbp-1CH]                    ; 0ACB _ 8B. 45, E4
        mov     edi, eax                                ; 0ACE _ 89. C7
        call    is_global                               ; 0AD0 _ E8, FFFFFB64
        test    al, al                                  ; 0AD5 _ 84. C0
        jz      ?_082                                   ; 0AD7 _ 74, 3B
        mov     rax, qword [rbp-18H]                    ; 0AD9 _ 48: 8B. 45, E8
        mov     edx, dword [rbp-1CH]                    ; 0ADD _ 8B. 55, E4
        mov     dword [rax+4CH], edx                    ; 0AE0 _ 89. 50, 4C
        mov     rax, qword [rbp-18H]                    ; 0AE3 _ 48: 8B. 45, E8
        mov     qword [rax+18H], 0                      ; 0AE7 _ 48: C7. 40, 18, 00000000
        cmp     qword [rbp-28H], 0                      ; 0AEF _ 48: 83. 7D, D8, 00
        jz      ?_081                                   ; 0AF4 _ 74, 14
        mov     rax, qword [rbp-28H]                    ; 0AF6 _ 48: 8B. 45, D8
        mov     rdi, rax                                ; 0AFA _ 48: 89. C7
        call    perm_copy                               ; 0AFD _ E8, 000007B3
        mov     rdx, qword [rbp-18H]                    ; 0B02 _ 48: 8B. 55, E8
        mov     qword [rdx+38H], rax                    ; 0B06 _ 48: 89. 42, 38
?_081:  mov     eax, 1                                  ; 0B0A _ B8, 00000001
        jmp     ?_086                                   ; 0B0F _ E9, 000000A7

?_082:  mov     eax, dword [rbp-1CH]                    ; 0B14 _ 8B. 45, E4
        mov     edi, eax                                ; 0B17 _ 89. C7
        call    is_extern                               ; 0B19 _ E8, FFFFF4E2
        test    al, al                                  ; 0B1E _ 84. C0
        jz      ?_085                                   ; 0B20 _ 74, 44
        mov     eax, dword [rbp-4H]                     ; 0B22 _ 8B. 45, FC
        mov     edi, eax                                ; 0B25 _ 89. C7
        call    is_global                               ; 0B27 _ E8, FFFFFB0D
        test    al, al                                  ; 0B2C _ 84. C0
        jnz     ?_083                                   ; 0B2E _ 75, 0E
        mov     eax, dword [rbp-4H]                     ; 0B30 _ 8B. 45, FC
        mov     edi, eax                                ; 0B33 _ 89. C7
        call    is_extern                               ; 0B35 _ E8, FFFFF4C6
        test    al, al                                  ; 0B3A _ 84. C0
        jz      ?_085                                   ; 0B3C _ 74, 28
?_083:  mov     rax, qword [rbp-18H]                    ; 0B3E _ 48: 8B. 45, E8
        mov     rax, qword [rax+38H]                    ; 0B42 _ 48: 8B. 40, 38
        test    rax, rax                                ; 0B46 _ 48: 85. C0
        jnz     ?_084                                   ; 0B49 _ 75, 14
        mov     rax, qword [rbp-28H]                    ; 0B4B _ 48: 8B. 45, D8
        mov     rdi, rax                                ; 0B4F _ 48: 89. C7
        call    perm_copy                               ; 0B52 _ E8, 0000075E
        mov     rdx, qword [rbp-18H]                    ; 0B57 _ 48: 8B. 55, E8
        mov     qword [rdx+38H], rax                    ; 0B5B _ 48: 89. 42, 38
?_084:  mov     eax, 0                                  ; 0B5F _ B8, 00000000
        jmp     ?_086                                   ; 0B64 _ EB, 55

?_085:  mov     eax, dword [rbp-1CH]                    ; 0B66 _ 8B. 45, E4
        cdqe                                            ; 0B69 _ 48: 98
        lea     rdx, [rax*8]                            ; 0B6B _ 48: 8D. 14 C5, 00000000
        lea     rax, [rel types]                        ; 0B73 _ 48: 8D. 05, 00000000(rel)
        mov     rcx, qword [rdx+rax]                    ; 0B7A _ 48: 8B. 0C 02
        mov     rax, qword [rbp-18H]                    ; 0B7E _ 48: 8B. 45, E8
        mov     eax, dword [rax+4CH]                    ; 0B82 _ 8B. 40, 4C
        cdqe                                            ; 0B85 _ 48: 98
        lea     rdx, [rax*8]                            ; 0B87 _ 48: 8D. 14 C5, 00000000
        lea     rax, [rel types]                        ; 0B8F _ 48: 8D. 05, 00000000(rel)
        mov     rdx, qword [rdx+rax]                    ; 0B96 _ 48: 8B. 14 02
        mov     rax, qword [rbp-18H]                    ; 0B9A _ 48: 8B. 45, E8
        mov     rax, qword [rax+28H]                    ; 0B9E _ 48: 8B. 40, 28
        lea     rdi, [rel ?_133]                        ; 0BA2 _ 48: 8D. 3D, 00000000(rel)
        mov     rsi, rax                                ; 0BA9 _ 48: 89. C6
        mov     eax, 0                                  ; 0BAC _ B8, 00000000
        call    nasm_nonfatal                           ; 0BB1 _ E8, 00000000(PLT r)
        mov     eax, 0                                  ; 0BB6 _ B8, 00000000
?_086:  leave                                           ; 0BBB _ C9
        ret                                             ; 0BBC _ C3

declare_label:; Function begin
        push    rbp                                     ; 0BBD _ 55
        mov     rbp, rsp                                ; 0BBE _ 48: 89. E5
        sub     rsp, 48                                 ; 0BC1 _ 48: 83. EC, 30
        mov     qword [rbp-18H], rdi                    ; 0BC5 _ 48: 89. 7D, E8
        mov     dword [rbp-1CH], esi                    ; 0BC9 _ 89. 75, E4
        mov     qword [rbp-28H], rdx                    ; 0BCC _ 48: 89. 55, D8
        mov     rax, qword [rbp-18H]                    ; 0BD0 _ 48: 8B. 45, E8
        mov     edx, 0                                  ; 0BD4 _ BA, 00000000
        mov     esi, 1                                  ; 0BD9 _ BE, 00000001
        mov     rdi, rax                                ; 0BDE _ 48: 89. C7
        call    find_label                              ; 0BE1 _ E8, FFFFF7B0
        mov     qword [rbp-8H], rax                     ; 0BE6 _ 48: 89. 45, F8
        mov     rdx, qword [rbp-28H]                    ; 0BEA _ 48: 8B. 55, D8
        mov     ecx, dword [rbp-1CH]                    ; 0BEE _ 8B. 4D, E4
        mov     rax, qword [rbp-8H]                     ; 0BF1 _ 48: 8B. 45, F8
        mov     esi, ecx                                ; 0BF5 _ 89. CE
        mov     rdi, rax                                ; 0BF7 _ 48: 89. C7
        call    declare_label_lptr                      ; 0BFA _ E8, FFFFFDA4
        leave                                           ; 0BFF _ C9
        ret                                             ; 0C00 _ C3
; declare_label End of function

define_label:; Function begin
        push    rbp                                     ; 0C01 _ 55
        mov     rbp, rsp                                ; 0C02 _ 48: 89. E5
        sub     rsp, 112                                ; 0C05 _ 48: 83. EC, 70
        mov     qword [rbp-58H], rdi                    ; 0C09 _ 48: 89. 7D, A8
        mov     dword [rbp-5CH], esi                    ; 0C0D _ 89. 75, A4
        mov     qword [rbp-68H], rdx                    ; 0C10 _ 48: 89. 55, 98
        mov     byte [rbp-5DH], cl                      ; 0C14 _ 88. 4D, A3
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        mov     rax, qword [fs:abs 28H]                 ; 0C17 _ 64 48: 8B. 04 25, 00000028
        mov     qword [rbp-8H], rax                     ; 0C20 _ 48: 89. 45, F8
        xor     eax, eax                                ; 0C24 _ 31. C0
        call    pass_count                              ; 0C26 _ E8, FFFFF4C7
        add     rax, 1                                  ; 0C2B _ 48: 83. C0, 01
        mov     qword [rbp-18H], rax                    ; 0C2F _ 48: 89. 45, E8
        lea     rdx, [rbp-47H]                          ; 0C33 _ 48: 8D. 55, B9
        mov     rax, qword [rbp-58H]                    ; 0C37 _ 48: 8B. 45, A8
        mov     esi, 1                                  ; 0C3B _ BE, 00000001
        mov     rdi, rax                                ; 0C40 _ 48: 89. C7
        call    find_label                              ; 0C43 _ E8, FFFFF74E
        mov     qword [rbp-10H], rax                    ; 0C48 _ 48: 89. 45, F0
        mov     rax, qword [rbp-10H]                    ; 0C4C _ 48: 8B. 45, F0
        mov     rax, qword [rax+18H]                    ; 0C50 _ 48: 8B. 40, 18
        mov     qword [rbp-20H], rax                    ; 0C54 _ 48: 89. 45, E0
        mov     eax, dword [rbp-5CH]                    ; 0C58 _ 8B. 45, A4
        test    eax, eax                                ; 0C5B _ 85. C0
        jz      ?_087                                   ; 0C5D _ 74, 27
        mov     rax, qword [rbp-10H]                    ; 0C5F _ 48: 8B. 45, F0
        mov     eax, dword [rax+4CH]                    ; 0C63 _ 8B. 40, 4C
        mov     edi, eax                                ; 0C66 _ 89. C7
        call    is_extern                               ; 0C68 _ E8, FFFFF393
        test    al, al                                  ; 0C6D _ 84. C0
        jz      ?_090                                   ; 0C6F _ 74, 2F
        mov     rax, qword [rbp-10H]                    ; 0C71 _ 48: 8B. 45, F0
        mov     dword [rax+4CH], 2                      ; 0C75 _ C7. 40, 4C, 00000002
        mov     qword [rbp-20H], 0                      ; 0C7C _ 48: C7. 45, E0, 00000000
        jmp     ?_090                                   ; 0C84 _ EB, 1A

?_087:  mov     rax, qword [rbp-10H]                    ; 0C86 _ 48: 8B. 45, F0
        mov     eax, dword [rax]                        ; 0C8A _ 8B. 00
        test    eax, eax                                ; 0C8C _ 85. C0
        jz      ?_088                                   ; 0C8E _ 74, 08
        mov     rax, qword [rbp-10H]                    ; 0C90 _ 48: 8B. 45, F0
        mov     eax, dword [rax]                        ; 0C94 _ 8B. 00
        jmp     ?_089                                   ; 0C96 _ EB, 05

?_088:  call    seg_alloc                               ; 0C98 _ E8, 00000000(PLT r)
?_089:  mov     dword [rbp-5CH], eax                    ; 0C9D _ 89. 45, A4
?_090:  cmp     qword [rbp-20H], 0                      ; 0CA0 _ 48: 83. 7D, E0, 00
        jnz     ?_091                                   ; 0CA5 _ 75, 0C
        mov     rax, qword [rbp-10H]                    ; 0CA7 _ 48: 8B. 45, F0
        mov     eax, dword [rax+4CH]                    ; 0CAB _ 8B. 40, 4C
        cmp     eax, 7                                  ; 0CAE _ 83. F8, 07
        jnz     ?_092                                   ; 0CB1 _ 75, 23
?_091:  mov     rax, qword [rbp-10H]                    ; 0CB3 _ 48: 8B. 45, F0
        mov     rdi, rax                                ; 0CB7 _ 48: 89. C7
        call    mangle_label_name                       ; 0CBA _ E8, FFFFFA73
        lea     rdx, [rbp-68H]                          ; 0CBF _ 48: 8D. 55, 98
        lea     rcx, [rbp-5CH]                          ; 0CC3 _ 48: 8D. 4D, A4
        mov     rax, qword [rbp-10H]                    ; 0CC7 _ 48: 8B. 45, F0
        mov     rsi, rcx                                ; 0CCB _ 48: 89. CE
        mov     rdi, rax                                ; 0CCE _ 48: 89. C7
        call    handle_herelabel                        ; 0CD1 _ E8, FFFFFB69
?_092:  mov     rax, qword [rbp-58H]                    ; 0CD6 _ 48: 8B. 45, A8
        mov     rdi, rax                                ; 0CDA _ 48: 89. C7
        call    ismagic                                 ; 0CDD _ E8, FFFFF47C
        test    al, al                                  ; 0CE2 _ 84. C0
        jz      ?_093                                   ; 0CE4 _ 74, 16
        mov     rax, qword [rbp-10H]                    ; 0CE6 _ 48: 8B. 45, F0
        mov     eax, dword [rax+4CH]                    ; 0CEA _ 8B. 40, 4C
        test    eax, eax                                ; 0CED _ 85. C0
        jnz     ?_093                                   ; 0CEF _ 75, 0B
        mov     rax, qword [rbp-10H]                    ; 0CF1 _ 48: 8B. 45, F0
        mov     dword [rax+4CH], 6                      ; 0CF5 _ C7. 40, 4C, 00000006
?_093:  mov     rax, qword [rbp-58H]                    ; 0CFC _ 48: 8B. 45, A8
        mov     rdi, rax                                ; 0D00 _ 48: 89. C7
        call    set_prevlabel                           ; 0D03 _ E8, FFFFF498
        test    al, al                                  ; 0D08 _ 84. C0
        jz      ?_094                                   ; 0D0A _ 74, 15
        cmp     byte [rbp-5DH], 0                       ; 0D0C _ 80. 7D, A3, 00
        jz      ?_094                                   ; 0D10 _ 74, 0F
        mov     rax, qword [rbp-10H]                    ; 0D12 _ 48: 8B. 45, F0
        mov     rax, qword [rax+28H]                    ; 0D16 _ 48: 8B. 40, 28
        mov     qword [rel prevlabel], rax              ; 0D1A _ 48: 89. 05, 00000000(rel)
?_094:  mov     rax, qword [rbp-10H]                    ; 0D21 _ 48: 8B. 45, F0
        mov     eax, dword [rax+4CH]                    ; 0D25 _ 8B. 40, 4C
        cmp     eax, 5                                  ; 0D28 _ 83. F8, 05
        jnz     ?_095                                   ; 0D2B _ 75, 12
        mov     rax, qword [rbp-68H]                    ; 0D2D _ 48: 8B. 45, 98
        mov     qword [rbp-28H], rax                    ; 0D31 _ 48: 89. 45, D8
        mov     qword [rbp-68H], 0                      ; 0D35 _ 48: C7. 45, 98, 00000000
        jmp     ?_096                                   ; 0D3D _ EB, 08

?_095:  mov     qword [rbp-28H], 0                      ; 0D3F _ 48: C7. 45, D8, 00000000
?_096:  movzx   eax, byte [rbp-47H]                     ; 0D47 _ 0F B6. 45, B9
        test    al, al                                  ; 0D4B _ 84. C0
        jnz     ?_097                                   ; 0D4D _ 75, 22
        cmp     qword [rbp-20H], 0                      ; 0D4F _ 48: 83. 7D, E0, 00
        jz      ?_097                                   ; 0D54 _ 74, 1B
        mov     rax, qword [rbp-10H]                    ; 0D56 _ 48: 8B. 45, F0
        mov     edx, dword [rax]                        ; 0D5A _ 8B. 10
        mov     eax, dword [rbp-5CH]                    ; 0D5C _ 8B. 45, A4
        cmp     edx, eax                                ; 0D5F _ 39. C2
        jnz     ?_097                                   ; 0D61 _ 75, 0E
        mov     rax, qword [rbp-10H]                    ; 0D63 _ 48: 8B. 45, F0
        mov     rax, qword [rax+10H]                    ; 0D67 _ 48: 8B. 40, 10
        cmp     qword [rbp-28H], rax                    ; 0D6B _ 48: 39. 45, D8
        jz      ?_098                                   ; 0D6F _ 74, 07
?_097:  mov     eax, 1                                  ; 0D71 _ B8, 00000001
        jmp     ?_099                                   ; 0D76 _ EB, 05

?_098:  mov     eax, 0                                  ; 0D78 _ B8, 00000000
?_099:  mov     byte [rbp-46H], al                      ; 0D7D _ 88. 45, BA
        and     byte [rbp-46H], 01H                     ; 0D80 _ 80. 65, BA, 01
        cmp     byte [rbp-46H], 0                       ; 0D84 _ 80. 7D, BA, 00
        jnz     ?_100                                   ; 0D88 _ 75, 11
        mov     rax, qword [rbp-10H]                    ; 0D8A _ 48: 8B. 45, F0
        mov     rdx, qword [rax+8H]                     ; 0D8E _ 48: 8B. 50, 08
        mov     rax, qword [rbp-68H]                    ; 0D92 _ 48: 8B. 45, 98
        cmp     rdx, rax                                ; 0D96 _ 48: 39. C2
        jz      ?_101                                   ; 0D99 _ 74, 07
?_100:  mov     eax, 1                                  ; 0D9B _ B8, 00000001
        jmp     ?_102                                   ; 0DA0 _ EB, 05

?_101:  mov     eax, 0                                  ; 0DA2 _ B8, 00000000
?_102:  mov     byte [rbp-45H], al                      ; 0DA7 _ 88. 45, BB
        and     byte [rbp-45H], 01H                     ; 0DAA _ 80. 65, BB, 01
        movzx   edx, byte [rbp-45H]                     ; 0DAE _ 0F B6. 55, BB
        mov     rax, qword [rel global_offset_changed]  ; 0DB2 _ 48: 8B. 05, 00000000(rel)
        add     rax, rdx                                ; 0DB9 _ 48: 01. D0
        mov     qword [rel global_offset_changed], rax  ; 0DBC _ 48: 89. 05, 00000000(rel)
        mov     rax, qword [rbp-20H]                    ; 0DC3 _ 48: 8B. 45, E0
        cmp     rax, qword [rbp-18H]                    ; 0DC7 _ 48: 3B. 45, E8
        jne     ?_106                                   ; 0DCB _ 0F 85, 000000E1
        mov     dword [rbp-44H], 0                      ; 0DD1 _ C7. 45, BC, 00000000
        mov     qword [rbp-30H], 0                      ; 0DD8 _ 48: C7. 45, D0, 00000000
        cmp     byte [rbp-45H], 0                       ; 0DE0 _ 80. 7D, BB, 00
        jz      ?_103                                   ; 0DE4 _ 74, 28
        mov     rax, qword [rbp-10H]                    ; 0DE6 _ 48: 8B. 45, F0
        mov     rax, qword [rax+28H]                    ; 0DEA _ 48: 8B. 40, 28
        lea     rdx, [rel ?_134]                        ; 0DEE _ 48: 8D. 15, 00000000(rel)
        mov     rsi, rax                                ; 0DF5 _ 48: 89. C6
        mov     rdi, rdx                                ; 0DF8 _ 48: 89. D7
        mov     eax, 0                                  ; 0DFB _ B8, 00000000
        call    nasm_nonfatal                           ; 0E00 _ E8, 00000000(PLT r)
        mov     dword [rbp-40H], 584                    ; 0E05 _ C7. 45, C0, 00000248
        jmp     ?_105                                   ; 0E0C _ EB, 41

?_103:  mov     dword [rbp-34H], 786432                 ; 0E0E _ C7. 45, CC, 000C0000
        mov     eax, dword [rbp-34H]                    ; 0E15 _ 8B. 45, CC
        mov     edi, eax                                ; 0E18 _ 89. C7
        call    warn_active                             ; 0E1A _ E8, FFFFF272
        movzx   eax, al                                 ; 0E1F _ 0F B6. C0
        test    rax, rax                                ; 0E22 _ 48: 85. C0
        jz      ?_104                                   ; 0E25 _ 74, 21
        mov     rax, qword [rbp-10H]                    ; 0E27 _ 48: 8B. 45, F0
        mov     rdx, qword [rax+28H]                    ; 0E2B _ 48: 8B. 50, 28
        lea     rcx, [rel ?_135]                        ; 0E2F _ 48: 8D. 0D, 00000000(rel)
        mov     eax, dword [rbp-34H]                    ; 0E36 _ 8B. 45, CC
        mov     rsi, rcx                                ; 0E39 _ 48: 89. CE
        mov     edi, eax                                ; 0E3C _ 89. C7
        mov     eax, 0                                  ; 0E3E _ B8, 00000000
        call    nasm_warn_                              ; 0E43 _ E8, 00000000(PLT r)
?_104:  mov     dword [rbp-40H], 787014                 ; 0E48 _ C7. 45, C0, 000C0246
?_105:  lea     rdx, [rbp-30H]                          ; 0E4F _ 48: 8D. 55, D0
        lea     rax, [rbp-44H]                          ; 0E53 _ 48: 8D. 45, BC
        mov     rsi, rdx                                ; 0E57 _ 48: 89. D6
        mov     rdi, rax                                ; 0E5A _ 48: 89. C7
        call    src_get                                 ; 0E5D _ E8, FFFFF1C2
        mov     rax, qword [rbp-10H]                    ; 0E62 _ 48: 8B. 45, F0
        mov     rdx, qword [rax+40H]                    ; 0E66 _ 48: 8B. 50, 40
        mov     rax, qword [rbp-10H]                    ; 0E6A _ 48: 8B. 45, F0
        mov     eax, dword [rax+48H]                    ; 0E6E _ 8B. 40, 48
        mov     rsi, rdx                                ; 0E71 _ 48: 89. D6
        mov     edi, eax                                ; 0E74 _ 89. C7
        call    src_set                                 ; 0E76 _ E8, 00000000(PLT r)
        mov     rax, qword [rbp-10H]                    ; 0E7B _ 48: 8B. 45, F0
        mov     rdx, qword [rax+28H]                    ; 0E7F _ 48: 8B. 50, 28
        mov     eax, dword [rbp-40H]                    ; 0E83 _ 8B. 45, C0
        lea     rcx, [rel ?_136]                        ; 0E86 _ 48: 8D. 0D, 00000000(rel)
        mov     rsi, rcx                                ; 0E8D _ 48: 89. CE
        mov     edi, eax                                ; 0E90 _ 89. C7
        mov     eax, 0                                  ; 0E92 _ B8, 00000000
        call    nasm_error                              ; 0E97 _ E8, 00000000(PLT r)
        mov     rdx, qword [rbp-30H]                    ; 0E9C _ 48: 8B. 55, D0
        mov     eax, dword [rbp-44H]                    ; 0EA0 _ 8B. 45, BC
        mov     rsi, rdx                                ; 0EA3 _ 48: 89. D6
        mov     edi, eax                                ; 0EA6 _ 89. C7
        call    src_set                                 ; 0EA8 _ E8, 00000000(PLT r)
        jmp     ?_110                                   ; 0EAD _ E9, 000000CA

?_106:  cmp     byte [rbp-45H], 0                       ; 0EB2 _ 80. 7D, BB, 00
        je      ?_110                                   ; 0EB6 _ 0F 84, 000000C0
        call    pass_final                              ; 0EBC _ E8, FFFFF220
        test    al, al                                  ; 0EC1 _ 84. C0
        je      ?_110                                   ; 0EC3 _ 0F 84, 000000B3
        mov     rax, qword [rbp-10H]                    ; 0EC9 _ 48: 8B. 45, F0
        mov     eax, dword [rax+4CH]                    ; 0ECD _ 8B. 40, 4C
        cmp     eax, 6                                  ; 0ED0 _ 83. F8, 06
        je      ?_110                                   ; 0ED3 _ 0F 84, 000000A3
        movzx   eax, byte [rbp-46H]                     ; 0ED9 _ 0F B6. 45, BA
        xor     eax, 01H                                ; 0EDD _ 83. F0, 01
        test    al, al                                  ; 0EE0 _ 84. C0
        jz      ?_107                                   ; 0EE2 _ 74, 48
        mov     dword [rbp-38H], 851968                 ; 0EE4 _ C7. 45, C8, 000D0000
        mov     eax, dword [rbp-38H]                    ; 0EEB _ 8B. 45, C8
        mov     edi, eax                                ; 0EEE _ 89. C7
        call    warn_active                             ; 0EF0 _ E8, FFFFF19C
        movzx   eax, al                                 ; 0EF5 _ 0F B6. C0
        test    rax, rax                                ; 0EF8 _ 48: 85. C0
        jz      ?_110                                   ; 0EFB _ 74, 7F
        mov     rdi, qword [rbp-68H]                    ; 0EFD _ 48: 8B. 7D, 98
        mov     rax, qword [rbp-10H]                    ; 0F01 _ 48: 8B. 45, F0
        mov     rcx, qword [rax+8H]                     ; 0F05 _ 48: 8B. 48, 08
        mov     rax, qword [rbp-10H]                    ; 0F09 _ 48: 8B. 45, F0
        mov     rdx, qword [rax+28H]                    ; 0F0D _ 48: 8B. 50, 28
        lea     rsi, [rel ?_137]                        ; 0F11 _ 48: 8D. 35, 00000000(rel)
        mov     eax, dword [rbp-38H]                    ; 0F18 _ 8B. 45, C8
        mov     r8, rdi                                 ; 0F1B _ 49: 89. F8
        mov     edi, eax                                ; 0F1E _ 89. C7
        mov     eax, 0                                  ; 0F20 _ B8, 00000000
        call    nasm_warn_                              ; 0F25 _ E8, 00000000(PLT r)
        jmp     ?_110                                   ; 0F2A _ EB, 50

?_107:  mov     dword [rbp-3CH], 851984                 ; 0F2C _ C7. 45, C4, 000D0010
        mov     eax, dword [rbp-3CH]                    ; 0F33 _ 8B. 45, C4
        mov     edi, eax                                ; 0F36 _ 89. C7
        call    warn_active                             ; 0F38 _ E8, FFFFF154
        movzx   eax, al                                 ; 0F3D _ 0F B6. C0
        test    rax, rax                                ; 0F40 _ 48: 85. C0
        jz      ?_110                                   ; 0F43 _ 74, 37
        movzx   eax, byte [rbp-47H]                     ; 0F45 _ 0F B6. 45, B9
        test    al, al                                  ; 0F49 _ 84. C0
        jz      ?_108                                   ; 0F4B _ 74, 09
        lea     rax, [rel ?_138]                        ; 0F4D _ 48: 8D. 05, 00000000(rel)
        jmp     ?_109                                   ; 0F54 _ EB, 07

?_108:  lea     rax, [rel ?_139]                        ; 0F56 _ 48: 8D. 05, 00000000(rel)
?_109:  mov     rdx, qword [rbp-10H]                    ; 0F5D _ 48: 8B. 55, F0
        mov     rdx, qword [rdx+28H]                    ; 0F61 _ 48: 8B. 52, 28
        lea     rsi, [rel ?_140]                        ; 0F65 _ 48: 8D. 35, 00000000(rel)
        mov     edi, dword [rbp-3CH]                    ; 0F6C _ 8B. 7D, C4
        mov     rcx, rax                                ; 0F6F _ 48: 89. C1
        mov     eax, 0                                  ; 0F72 _ B8, 00000000
        call    nasm_warn_                              ; 0F77 _ E8, 00000000(PLT r)
?_110:  mov     edx, dword [rbp-5CH]                    ; 0F7C _ 8B. 55, A4
        mov     rax, qword [rbp-10H]                    ; 0F7F _ 48: 8B. 45, F0
        mov     dword [rax], edx                        ; 0F83 _ 89. 10
        mov     rdx, qword [rbp-68H]                    ; 0F85 _ 48: 8B. 55, 98
        mov     rax, qword [rbp-10H]                    ; 0F89 _ 48: 8B. 45, F0
        mov     qword [rax+8H], rdx                     ; 0F8D _ 48: 89. 50, 08
        mov     rax, qword [rbp-10H]                    ; 0F91 _ 48: 8B. 45, F0
        mov     rdx, qword [rbp-28H]                    ; 0F95 _ 48: 8B. 55, D8
        mov     qword [rax+10H], rdx                    ; 0F99 _ 48: 89. 50, 10
        mov     rax, qword [rbp-10H]                    ; 0F9D _ 48: 8B. 45, F0
        mov     rdx, qword [rbp-18H]                    ; 0FA1 _ 48: 8B. 55, E8
        mov     qword [rax+18H], rdx                    ; 0FA5 _ 48: 89. 50, 18
        cmp     byte [rbp-45H], 0                       ; 0FA9 _ 80. 7D, BB, 00
        jnz     ?_111                                   ; 0FAD _ 75, 0A
        mov     rax, qword [rbp-20H]                    ; 0FAF _ 48: 8B. 45, E0
        cmp     rax, qword [rbp-18H]                    ; 0FB3 _ 48: 3B. 45, E8
        jz      ?_112                                   ; 0FB7 _ 74, 1B
?_111:  mov     rax, qword [rbp-10H]                    ; 0FB9 _ 48: 8B. 45, F0
        lea     rdx, [rax+40H]                          ; 0FBD _ 48: 8D. 50, 40
        mov     rax, qword [rbp-10H]                    ; 0FC1 _ 48: 8B. 45, F0
        add     rax, 72                                 ; 0FC5 _ 48: 83. C0, 48
        mov     rsi, rdx                                ; 0FC9 _ 48: 89. D6
        mov     rdi, rax                                ; 0FCC _ 48: 89. C7
        call    src_get                                 ; 0FCF _ E8, FFFFF050
?_112:  mov     rax, qword [rbp-20H]                    ; 0FD4 _ 48: 8B. 45, E0
        cmp     rax, qword [rbp-18H]                    ; 0FD8 _ 48: 3B. 45, E8
        jz      ?_113                                   ; 0FDC _ 74, 0C
        mov     rax, qword [rbp-10H]                    ; 0FDE _ 48: 8B. 45, F0
        mov     rdi, rax                                ; 0FE2 _ 48: 89. C7
        call    out_symdef                              ; 0FE5 _ E8, FFFFF1F8
?_113:  nop                                             ; 0FEA _ 90
        mov     rax, qword [rbp-8H]                     ; 0FEB _ 48: 8B. 45, F8
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        sub     rax, qword [fs:abs 28H]                 ; 0FEF _ 64 48: 2B. 04 25, 00000028
        jz      ?_114                                   ; 0FF8 _ 74, 05
        call    __stack_chk_fail                        ; 0FFA _ E8, 00000000(PLT r)
?_114:  leave                                           ; 0FFF _ C9
        ret                                             ; 1000 _ C3
; define_label End of function

backend_label:; Function begin
        push    rbp                                     ; 1001 _ 55
        mov     rbp, rsp                                ; 1002 _ 48: 89. E5
        sub     rsp, 32                                 ; 1005 _ 48: 83. EC, 20
        mov     qword [rbp-8H], rdi                     ; 1009 _ 48: 89. 7D, F8
        mov     dword [rbp-0CH], esi                    ; 100D _ 89. 75, F4
        mov     qword [rbp-18H], rdx                    ; 1010 _ 48: 89. 55, E8
        mov     rax, qword [rbp-8H]                     ; 1014 _ 48: 8B. 45, F8
        mov     edx, 0                                  ; 1018 _ BA, 00000000
        mov     esi, 7                                  ; 101D _ BE, 00000007
        mov     rdi, rax                                ; 1022 _ 48: 89. C7
        call    declare_label                           ; 1025 _ E8, 00000000(PLT r)
        xor     eax, 01H                                ; 102A _ 83. F0, 01
        test    al, al                                  ; 102D _ 84. C0
        jnz     ?_115                                   ; 102F _ 75, 1A
        mov     rdx, qword [rbp-18H]                    ; 1031 _ 48: 8B. 55, E8
        mov     esi, dword [rbp-0CH]                    ; 1035 _ 8B. 75, F4
        mov     rax, qword [rbp-8H]                     ; 1038 _ 48: 8B. 45, F8
        mov     ecx, 0                                  ; 103C _ B9, 00000000
        mov     rdi, rax                                ; 1041 _ 48: 89. C7
        call    define_label                            ; 1044 _ E8, 00000000(PLT r)
        jmp     ?_116                                   ; 1049 _ EB, 01

?_115:  nop                                             ; 104B _ 90
?_116:  leave                                           ; 104C _ C9
        ret                                             ; 104D _ C3
; backend_label End of function

init_labels:; Function begin
        push    rbp                                     ; 104E _ 55
        mov     rbp, rsp                                ; 104F _ 48: 89. E5
        mov     edi, 11264                              ; 1052 _ BF, 00002C00
        call    nasm_malloc                             ; 1057 _ E8, 00000000(PLT r)
        mov     qword [rel lfree], rax                  ; 105C _ 48: 89. 05, 00000000(rel)
        mov     rax, qword [rel lfree]                  ; 1063 _ 48: 8B. 05, 00000000(rel)
        mov     qword [rel ldata], rax                  ; 106A _ 48: 89. 05, 00000000(rel)
        mov     rax, qword [rel lfree]                  ; 1071 _ 48: 8B. 05, 00000000(rel)
        mov     rdi, rax                                ; 1078 _ 48: 89. C7
        call    init_block                              ; 107B _ E8, 00000107
        mov     edi, 16400                              ; 1080 _ BF, 00004010
        call    nasm_malloc                             ; 1085 _ E8, 00000000(PLT r)
        mov     qword [rel perm_tail], rax              ; 108A _ 48: 89. 05, 00000000(rel)
        mov     rax, qword [rel perm_tail]              ; 1091 _ 48: 8B. 05, 00000000(rel)
        mov     qword [rel perm_head], rax              ; 1098 _ 48: 89. 05, 00000000(rel)
        mov     rax, qword [rel perm_head]              ; 109F _ 48: 8B. 05, 00000000(rel)
        mov     qword [rax], 0                          ; 10A6 _ 48: C7. 00, 00000000
        mov     rax, qword [rel perm_head]              ; 10AD _ 48: 8B. 05, 00000000(rel)
        mov     dword [rax+8H], 16384                   ; 10B4 _ C7. 40, 08, 00004000
        mov     rax, qword [rel perm_head]              ; 10BB _ 48: 8B. 05, 00000000(rel)
        mov     dword [rax+0CH], 0                      ; 10C2 _ C7. 40, 0C, 00000000
        lea     rax, [rel ?_130]                        ; 10C9 _ 48: 8D. 05, 00000000(rel)
        mov     qword [rel prevlabel], rax              ; 10D0 _ 48: 89. 05, 00000000(rel)
        mov     byte [rel initialized], 1               ; 10D7 _ C6. 05, 00000000(rel), 01
        mov     eax, 0                                  ; 10DE _ B8, 00000000
        pop     rbp                                     ; 10E3 _ 5D
        ret                                             ; 10E4 _ C3
; init_labels End of function

cleanup_labels:; Function begin
        push    rbp                                     ; 10E5 _ 55
        mov     rbp, rsp                                ; 10E6 _ 48: 89. E5
        sub     rsp, 16                                 ; 10E9 _ 48: 83. EC, 10
        mov     byte [rel initialized], 0               ; 10ED _ C6. 05, 00000000(rel), 00
        lea     rax, [rel ltab]                         ; 10F4 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 10FB _ 48: 89. C7
        call    hash_free                               ; 10FE _ E8, 00000000(PLT r)
        mov     rax, qword [rel ldata]                  ; 1103 _ 48: 8B. 05, 00000000(rel)
        mov     qword [rbp-8H], rax                     ; 110A _ 48: 89. 45, F8
        mov     rax, qword [rbp-8H]                     ; 110E _ 48: 8B. 45, F8
        mov     qword [rbp-10H], rax                    ; 1112 _ 48: 89. 45, F0
        jmp     ?_118                                   ; 1116 _ EB, 28

?_117:  add     qword [rbp-10H], 11176                  ; 1118 _ 48: 81. 45, F0, 00002BA8
        mov     rax, qword [rbp-10H]                    ; 1120 _ 48: 8B. 45, F0
        mov     rax, qword [rax+10H]                    ; 1124 _ 48: 8B. 40, 10
        mov     qword [rbp-10H], rax                    ; 1128 _ 48: 89. 45, F0
        mov     rax, qword [rbp-8H]                     ; 112C _ 48: 8B. 45, F8
        mov     rdi, rax                                ; 1130 _ 48: 89. C7
        call    nasm_free                               ; 1133 _ E8, 00000000(PLT r)
        mov     rax, qword [rbp-10H]                    ; 1138 _ 48: 8B. 45, F0
        mov     qword [rbp-8H], rax                     ; 113C _ 48: 89. 45, F8
?_118:  cmp     qword [rbp-10H], 0                      ; 1140 _ 48: 83. 7D, F0, 00
        jnz     ?_117                                   ; 1145 _ 75, D1
        jmp     ?_120                                   ; 1147 _ EB, 2E

?_119:  mov     rax, qword [rel perm_head]              ; 1149 _ 48: 8B. 05, 00000000(rel)
        mov     qword [rel perm_tail], rax              ; 1150 _ 48: 89. 05, 00000000(rel)
        mov     rax, qword [rel perm_head]              ; 1157 _ 48: 8B. 05, 00000000(rel)
        mov     rax, qword [rax]                        ; 115E _ 48: 8B. 00
        mov     qword [rel perm_head], rax              ; 1161 _ 48: 89. 05, 00000000(rel)
        mov     rax, qword [rel perm_tail]              ; 1168 _ 48: 8B. 05, 00000000(rel)
        mov     rdi, rax                                ; 116F _ 48: 89. C7
        call    nasm_free                               ; 1172 _ E8, 00000000(PLT r)
?_120:  mov     rax, qword [rel perm_head]              ; 1177 _ 48: 8B. 05, 00000000(rel)
        test    rax, rax                                ; 117E _ 48: 85. C0
        jnz     ?_119                                   ; 1181 _ 75, C6
        nop                                             ; 1183 _ 90
        nop                                             ; 1184 _ 90
        leave                                           ; 1185 _ C9
        ret                                             ; 1186 _ C3
; cleanup_labels End of function

init_block:; Local function
        push    rbp                                     ; 1187 _ 55
        mov     rbp, rsp                                ; 1188 _ 48: 89. E5
        mov     qword [rbp-18H], rdi                    ; 118B _ 48: 89. 7D, E8
        mov     dword [rbp-4H], 0                       ; 118F _ C7. 45, FC, 00000000
        jmp     ?_122                                   ; 1196 _ EB, 1A

?_121:  mov     eax, dword [rbp-4H]                     ; 1198 _ 8B. 45, FC
        cdqe                                            ; 119B _ 48: 98
        imul    rdx, rax, 88                            ; 119D _ 48: 6B. D0, 58
        mov     rax, qword [rbp-18H]                    ; 11A1 _ 48: 8B. 45, E8
        add     rax, rdx                                ; 11A5 _ 48: 01. D0
        mov     dword [rax], -3                         ; 11A8 _ C7. 00, FFFFFFFD
        add     dword [rbp-4H], 1                       ; 11AE _ 83. 45, FC, 01
?_122:  cmp     dword [rbp-4H], 126                     ; 11B2 _ 83. 7D, FC, 7E
        jle     ?_121                                   ; 11B6 _ 7E, E0
        mov     rax, qword [rbp-18H]                    ; 11B8 _ 48: 8B. 45, E8
        add     rax, 11176                              ; 11BC _ 48: 05, 00002BA8
        mov     dword [rax], -2                         ; 11C2 _ C7. 00, FFFFFFFE
        mov     rax, qword [rbp-18H]                    ; 11C8 _ 48: 8B. 45, E8
        add     rax, 11176                              ; 11CC _ 48: 05, 00002BA8
        mov     qword [rax+10H], 0                      ; 11D2 _ 48: C7. 40, 10, 00000000
        nop                                             ; 11DA _ 90
        pop     rbp                                     ; 11DB _ 5D
        ret                                             ; 11DC _ C3

perm_alloc:; Local function
        push    rbp                                     ; 11DD _ 55
        mov     rbp, rsp                                ; 11DE _ 48: 89. E5
        push    rbx                                     ; 11E1 _ 53
        sub     rsp, 40                                 ; 11E2 _ 48: 83. EC, 28
        mov     qword [rbp-28H], rdi                    ; 11E6 _ 48: 89. 7D, D8
        mov     rax, qword [rel perm_tail]              ; 11EA _ 48: 8B. 05, 00000000(rel)
        mov     edx, dword [rax+8H]                     ; 11F1 _ 8B. 50, 08
        mov     rax, qword [rel perm_tail]              ; 11F4 _ 48: 8B. 05, 00000000(rel)
        mov     eax, dword [rax+0CH]                    ; 11FB _ 8B. 40, 0C
        sub     edx, eax                                ; 11FE _ 29. C2
        mov     eax, edx                                ; 1200 _ 89. D0
        cmp     rax, qword [rbp-28H]                    ; 1202 _ 48: 3B. 45, D8
        jnc     ?_123                                   ; 1206 _ 73, 69
        mov     rax, qword [rbp-28H]                    ; 1208 _ 48: 8B. 45, D8
        mov     edx, 16384                              ; 120C _ BA, 00004000
        cmp     rax, rdx                                ; 1211 _ 48: 39. D0
        cmovc   rax, rdx                                ; 1214 _ 48: 0F 42. C2
        mov     qword [rbp-20H], rax                    ; 1218 _ 48: 89. 45, E0
        mov     rax, qword [rbp-20H]                    ; 121C _ 48: 8B. 45, E0
        add     rax, 16                                 ; 1220 _ 48: 83. C0, 10
        mov     rbx, qword [rel perm_tail]              ; 1224 _ 48: 8B. 1D, 00000000(rel)
        mov     rdi, rax                                ; 122B _ 48: 89. C7
        call    nasm_malloc                             ; 122E _ E8, 00000000(PLT r)
        mov     qword [rbx], rax                        ; 1233 _ 48: 89. 03
        mov     rax, qword [rel perm_tail]              ; 1236 _ 48: 8B. 05, 00000000(rel)
        mov     rax, qword [rax]                        ; 123D _ 48: 8B. 00
        mov     qword [rel perm_tail], rax              ; 1240 _ 48: 89. 05, 00000000(rel)
        mov     rax, qword [rel perm_tail]              ; 1247 _ 48: 8B. 05, 00000000(rel)
        mov     qword [rax], 0                          ; 124E _ 48: C7. 00, 00000000
        mov     rax, qword [rel perm_tail]              ; 1255 _ 48: 8B. 05, 00000000(rel)
        mov     rdx, qword [rbp-20H]                    ; 125C _ 48: 8B. 55, E0
        mov     dword [rax+8H], edx                     ; 1260 _ 89. 50, 08
        mov     rax, qword [rel perm_tail]              ; 1263 _ 48: 8B. 05, 00000000(rel)
        mov     dword [rax+0CH], 0                      ; 126A _ C7. 40, 0C, 00000000
?_123:  mov     rax, qword [rel perm_tail]              ; 1271 _ 48: 8B. 05, 00000000(rel)
        lea     rdx, [rax+10H]                          ; 1278 _ 48: 8D. 50, 10
        mov     rax, qword [rel perm_tail]              ; 127C _ 48: 8B. 05, 00000000(rel)
        mov     eax, dword [rax+0CH]                    ; 1283 _ 8B. 40, 0C
        mov     eax, eax                                ; 1286 _ 89. C0
        add     rax, rdx                                ; 1288 _ 48: 01. D0
        mov     qword [rbp-18H], rax                    ; 128B _ 48: 89. 45, E8
        mov     rax, qword [rel perm_tail]              ; 128F _ 48: 8B. 05, 00000000(rel)
        mov     edx, dword [rax+0CH]                    ; 1296 _ 8B. 50, 0C
        mov     rax, qword [rbp-28H]                    ; 1299 _ 48: 8B. 45, D8
        mov     ecx, eax                                ; 129D _ 89. C1
        mov     rax, qword [rel perm_tail]              ; 129F _ 48: 8B. 05, 00000000(rel)
        add     edx, ecx                                ; 12A6 _ 01. CA
        mov     dword [rax+0CH], edx                    ; 12A8 _ 89. 50, 0C
        mov     rax, qword [rbp-18H]                    ; 12AB _ 48: 8B. 45, E8
        mov     rbx, qword [rbp-8H]                     ; 12AF _ 48: 8B. 5D, F8
        leave                                           ; 12B3 _ C9
        ret                                             ; 12B4 _ C3

perm_copy:; Local function
        push    rbp                                     ; 12B5 _ 55
        mov     rbp, rsp                                ; 12B6 _ 48: 89. E5
        sub     rsp, 32                                 ; 12B9 _ 48: 83. EC, 20
        mov     qword [rbp-18H], rdi                    ; 12BD _ 48: 89. 7D, E8
        cmp     qword [rbp-18H], 0                      ; 12C1 _ 48: 83. 7D, E8, 00
        jnz     ?_124                                   ; 12C6 _ 75, 07
        mov     eax, 0                                  ; 12C8 _ B8, 00000000
        jmp     ?_125                                   ; 12CD _ EB, 3F

?_124:  mov     rax, qword [rbp-18H]                    ; 12CF _ 48: 8B. 45, E8
        mov     rdi, rax                                ; 12D3 _ 48: 89. C7
        call    strlen                                  ; 12D6 _ E8, 00000000(PLT r)
        add     rax, 1                                  ; 12DB _ 48: 83. C0, 01
        mov     qword [rbp-10H], rax                    ; 12DF _ 48: 89. 45, F0
        mov     rax, qword [rbp-10H]                    ; 12E3 _ 48: 8B. 45, F0
        mov     rdi, rax                                ; 12E7 _ 48: 89. C7
        call    perm_alloc                              ; 12EA _ E8, FFFFFEEE
        mov     qword [rbp-8H], rax                     ; 12EF _ 48: 89. 45, F8
        mov     rdx, qword [rbp-10H]                    ; 12F3 _ 48: 8B. 55, F0
        mov     rcx, qword [rbp-18H]                    ; 12F7 _ 48: 8B. 4D, E8
        mov     rax, qword [rbp-8H]                     ; 12FB _ 48: 8B. 45, F8
        mov     rsi, rcx                                ; 12FF _ 48: 89. CE
        mov     rdi, rax                                ; 1302 _ 48: 89. C7
        call    memcpy                                  ; 1305 _ E8, 00000000(PLT r)
        mov     rax, qword [rbp-8H]                     ; 130A _ 48: 8B. 45, F8
?_125:  leave                                           ; 130E _ C9
        ret                                             ; 130F _ C3

perm_copy3:; Local function
        push    rbp                                     ; 1310 _ 55
        mov     rbp, rsp                                ; 1311 _ 48: 89. E5
        sub     rsp, 64                                 ; 1314 _ 48: 83. EC, 40
        mov     qword [rbp-28H], rdi                    ; 1318 _ 48: 89. 7D, D8
        mov     qword [rbp-30H], rsi                    ; 131C _ 48: 89. 75, D0
        mov     qword [rbp-38H], rdx                    ; 1320 _ 48: 89. 55, C8
        mov     rax, qword [rbp-28H]                    ; 1324 _ 48: 8B. 45, D8
        mov     rdi, rax                                ; 1328 _ 48: 89. C7
        call    strlen                                  ; 132B _ E8, 00000000(PLT r)
        mov     qword [rbp-20H], rax                    ; 1330 _ 48: 89. 45, E0
        mov     rax, qword [rbp-30H]                    ; 1334 _ 48: 8B. 45, D0
        mov     rdi, rax                                ; 1338 _ 48: 89. C7
        call    strlen                                  ; 133B _ E8, 00000000(PLT r)
        mov     qword [rbp-18H], rax                    ; 1340 _ 48: 89. 45, E8
        mov     rax, qword [rbp-38H]                    ; 1344 _ 48: 8B. 45, C8
        mov     rdi, rax                                ; 1348 _ 48: 89. C7
        call    strlen                                  ; 134B _ E8, 00000000(PLT r)
        add     rax, 1                                  ; 1350 _ 48: 83. C0, 01
        mov     qword [rbp-10H], rax                    ; 1354 _ 48: 89. 45, F0
        mov     rdx, qword [rbp-20H]                    ; 1358 _ 48: 8B. 55, E0
        mov     rax, qword [rbp-18H]                    ; 135C _ 48: 8B. 45, E8
        add     rdx, rax                                ; 1360 _ 48: 01. C2
        mov     rax, qword [rbp-10H]                    ; 1363 _ 48: 8B. 45, F0
        add     rax, rdx                                ; 1367 _ 48: 01. D0
        mov     rdi, rax                                ; 136A _ 48: 89. C7
        call    perm_alloc                              ; 136D _ E8, FFFFFE6B
        mov     qword [rbp-8H], rax                     ; 1372 _ 48: 89. 45, F8
        mov     rdx, qword [rbp-20H]                    ; 1376 _ 48: 8B. 55, E0
        mov     rcx, qword [rbp-28H]                    ; 137A _ 48: 8B. 4D, D8
        mov     rax, qword [rbp-8H]                     ; 137E _ 48: 8B. 45, F8
        mov     rsi, rcx                                ; 1382 _ 48: 89. CE
        mov     rdi, rax                                ; 1385 _ 48: 89. C7
        call    memcpy                                  ; 1388 _ E8, 00000000(PLT r)
        mov     rdx, qword [rbp-8H]                     ; 138D _ 48: 8B. 55, F8
        mov     rax, qword [rbp-20H]                    ; 1391 _ 48: 8B. 45, E0
        lea     rcx, [rdx+rax]                          ; 1395 _ 48: 8D. 0C 02
        mov     rdx, qword [rbp-18H]                    ; 1399 _ 48: 8B. 55, E8
        mov     rax, qword [rbp-30H]                    ; 139D _ 48: 8B. 45, D0
        mov     rsi, rax                                ; 13A1 _ 48: 89. C6
        mov     rdi, rcx                                ; 13A4 _ 48: 89. CF
        call    memcpy                                  ; 13A7 _ E8, 00000000(PLT r)
        mov     rdx, qword [rbp-20H]                    ; 13AC _ 48: 8B. 55, E0
        mov     rax, qword [rbp-18H]                    ; 13B0 _ 48: 8B. 45, E8
        add     rdx, rax                                ; 13B4 _ 48: 01. C2
        mov     rax, qword [rbp-8H]                     ; 13B7 _ 48: 8B. 45, F8
        lea     rcx, [rdx+rax]                          ; 13BB _ 48: 8D. 0C 02
        mov     rdx, qword [rbp-10H]                    ; 13BF _ 48: 8B. 55, F0
        mov     rax, qword [rbp-38H]                    ; 13C3 _ 48: 8B. 45, C8
        mov     rsi, rax                                ; 13C7 _ 48: 89. C6
        mov     rdi, rcx                                ; 13CA _ 48: 89. CF
        call    memcpy                                  ; 13CD _ E8, 00000000(PLT r)
        mov     rax, qword [rbp-8H]                     ; 13D2 _ 48: 8B. 45, F8
        leave                                           ; 13D6 _ C9
        ret                                             ; 13D7 _ C3

local_scope:; Function begin
        push    rbp                                     ; 13D8 _ 55
        mov     rbp, rsp                                ; 13D9 _ 48: 89. E5
        sub     rsp, 8                                  ; 13DC _ 48: 83. EC, 08
        mov     qword [rbp-8H], rdi                     ; 13E0 _ 48: 89. 7D, F8
        mov     rax, qword [rbp-8H]                     ; 13E4 _ 48: 8B. 45, F8
        mov     rdi, rax                                ; 13E8 _ 48: 89. C7
        call    islocal                                 ; 13EB _ E8, FFFFED0F
        movzx   eax, al                                 ; 13F0 _ 0F B6. C0
        and     eax, 01H                                ; 13F3 _ 83. E0, 01
        test    al, al                                  ; 13F6 _ 84. C0
        jz      ?_126                                   ; 13F8 _ 74, 09
        mov     rax, qword [rel prevlabel]              ; 13FA _ 48: 8B. 05, 00000000(rel)
        jmp     ?_127                                   ; 1401 _ EB, 07

?_126:  lea     rax, [rel ?_130]                        ; 1403 _ 48: 8D. 05, 00000000(rel)
?_127:  leave                                           ; 140A _ C9
        ret                                             ; 140B _ C3
; local_scope End of function


SECTION .data   align=1 noexec                          ; section number 2, data


SECTION .bss    align=32 noexec                         ; section number 3, bss

global_offset_changed:                                  ; qword
        resq    4                                       ; 0000

ltab:                                                   ; yword
        resb    32                                      ; 0020

ldata:  resq    1                                       ; 0040

lfree:  resq    1                                       ; 0048

perm_head:                                              ; qword
        resq    1                                       ; 0050

perm_tail:                                              ; qword
        resq    1                                       ; 0058

prevlabel:                                              ; qword
        resq    1                                       ; 0060

initialized:                                            ; byte
        resb    1                                       ; 0068

mangle_string_set:                                      ; dword
        resd    1                                       ; 0069


SECTION .rodata align=16 noexec                         ; section number 4, const

        db 6CH, 6FH, 63H, 61H, 6CH, 00H, 73H, 74H       ; 0000 _ local.st
        db 61H, 74H, 69H, 63H, 00H, 67H, 6CH, 6FH       ; 0008 _ atic.glo
        db 62H, 61H, 6CH, 00H, 65H, 78H, 74H, 65H       ; 0010 _ bal.exte
        db 72H, 6EH, 00H, 72H, 65H, 71H, 75H, 69H       ; 0018 _ rn.requi
        db 72H, 65H, 64H, 00H, 63H, 6FH, 6DH, 6DH       ; 0020 _ red.comm
        db 6FH, 6EH, 00H, 73H, 70H, 65H, 63H, 69H       ; 0028 _ on.speci
        db 61H, 6CH, 00H, 6FH, 75H, 74H, 70H, 75H       ; 0030 _ al.outpu
        db 74H, 20H, 66H, 6FH, 72H, 6DH, 61H, 74H       ; 0038 _ t format
        db 20H, 73H, 70H, 65H, 63H, 69H, 61H, 6CH       ; 0040 _  special
        db 00H                                          ; 0048 _ .

?_128:                                                  ; byte
        db 2EH, 2FH, 61H, 73H, 6DH, 2FH, 6CH, 61H       ; 0049 _ ./asm/la
        db 62H, 65H, 6CH, 73H, 2EH, 63H, 00H            ; 0051 _ bels.c.

?_129:                                                  ; byte
        db 6CH, 61H, 62H, 65H, 6CH, 20H, 21H, 3DH       ; 0058 _ label !=
        db 20H, 4EH, 55H, 4CH, 4CH, 00H                 ; 0060 _  NULL.

?_130:                                                  ; byte
        db 00H                                          ; 0066 _ .

?_131:                                                  ; byte
        db 6CH, 70H, 74H, 72H, 2DH, 3EH, 64H, 65H       ; 0067 _ lptr->de
        db 66H, 6EH, 2EH, 6DH, 61H, 6EH, 67H, 6CH       ; 006F _ fn.mangl
        db 65H, 64H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0077 _ ed......
        db 00H                                          ; 007F _ .

?_132:                                                  ; byte
        db 73H, 79H, 6DH, 62H, 6FH, 6CH, 20H, 60H       ; 0080 _ symbol `
        db 25H, 73H, 27H, 20H, 68H, 61H, 73H, 20H       ; 0088 _ %s' has 
        db 69H, 6EH, 63H, 6FH, 6EH, 73H, 69H, 73H       ; 0090 _ inconsis
        db 74H, 65H, 6EH, 74H, 20H, 61H, 74H, 74H       ; 0098 _ tent att
        db 72H, 69H, 62H, 75H, 74H, 65H, 73H, 20H       ; 00A0 _ ributes 
        db 60H, 25H, 73H, 27H, 20H, 61H, 6EH, 64H       ; 00A8 _ `%s' and
        db 20H, 60H, 25H, 73H, 27H, 00H, 00H, 00H       ; 00B0 _  `%s'...

?_133:                                                  ; byte
        db 73H, 79H, 6DH, 62H, 6FH, 6CH, 20H, 60H       ; 00B8 _ symbol `
        db 25H, 73H, 27H, 20H, 64H, 65H, 63H, 6CH       ; 00C0 _ %s' decl
        db 61H, 72H, 65H, 64H, 20H, 62H, 6FH, 74H       ; 00C8 _ ared bot
        db 68H, 20H, 61H, 73H, 20H, 25H, 73H, 20H       ; 00D0 _ h as %s 
        db 61H, 6EH, 64H, 20H, 25H, 73H, 00H, 00H       ; 00D8 _ and %s..

?_134:                                                  ; byte
        db 6CH, 61H, 62H, 65H, 6CH, 20H, 60H, 25H       ; 00E0 _ label `%
        db 73H, 27H, 20H, 69H, 6EH, 63H, 6FH, 6EH       ; 00E8 _ s' incon
        db 73H, 69H, 73H, 74H, 65H, 6EH, 74H, 6CH       ; 00F0 _ sistentl
        db 79H, 20H, 72H, 65H, 64H, 65H, 66H, 69H       ; 00F8 _ y redefi
        db 6EH, 65H, 64H, 00H, 00H, 00H, 00H, 00H       ; 0100 _ ned.....

?_135:                                                  ; byte
        db 69H, 6EH, 66H, 6FH, 3AH, 20H, 6CH, 61H       ; 0108 _ info: la
        db 62H, 65H, 6CH, 20H, 60H, 25H, 73H, 27H       ; 0110 _ bel `%s'
        db 20H, 72H, 65H, 64H, 65H, 66H, 69H, 6EH       ; 0118 _  redefin
        db 65H, 64H, 20H, 74H, 6FH, 20H, 61H, 6EH       ; 0120 _ ed to an
        db 20H, 69H, 64H, 65H, 6EH, 74H, 69H, 63H       ; 0128 _  identic
        db 61H, 6CH, 20H, 76H, 61H, 6CH, 75H, 65H       ; 0130 _ al value
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0138 _ ........

?_136:                                                  ; byte
        db 69H, 6EH, 66H, 6FH, 3AH, 20H, 6CH, 61H       ; 0140 _ info: la
        db 62H, 65H, 6CH, 20H, 60H, 25H, 73H, 27H       ; 0148 _ bel `%s'
        db 20H, 6FH, 72H, 69H, 67H, 69H, 6EH, 61H       ; 0150 _  origina
        db 6CH, 6CH, 79H, 20H, 64H, 65H, 66H, 69H       ; 0158 _ lly defi
        db 6EH, 65H, 64H, 00H, 00H, 00H, 00H, 00H       ; 0160 _ ned.....

?_137:                                                  ; byte
        db 6CH, 61H, 62H, 65H, 6CH, 20H, 60H, 25H       ; 0168 _ label `%
        db 73H, 27H, 20H, 63H, 68H, 61H, 6EH, 67H       ; 0170 _ s' chang
        db 65H, 64H, 20H, 64H, 75H, 72H, 69H, 6EH       ; 0178 _ ed durin
        db 67H, 20H, 63H, 6FH, 64H, 65H, 20H, 67H       ; 0180 _ g code g
        db 65H, 6EH, 65H, 72H, 61H, 74H, 69H, 6FH       ; 0188 _ eneratio
        db 6EH, 20H, 28H, 6FH, 66H, 66H, 73H, 65H       ; 0190 _ n (offse
        db 74H, 20H, 30H, 78H, 25H, 6CH, 78H, 20H       ; 0198 _ t 0x%lx 
        db 2DH, 3EH, 20H, 30H, 78H, 25H, 6CH, 78H       ; 01A0 _ -> 0x%lx
        db 29H, 00H                                     ; 01A8 _ ).

?_138:                                                  ; byte
        db 64H, 65H, 66H, 69H, 6EH, 65H, 64H, 00H       ; 01AA _ defined.

?_139:                                                  ; byte
        db 63H, 68H, 61H, 6EH, 67H, 65H, 64H, 00H       ; 01B2 _ changed.
        db 00H, 00H, 00H, 00H, 00H, 00H                 ; 01BA _ ......

?_140:                                                  ; byte
        db 6CH, 61H, 62H, 65H, 6CH, 20H, 60H, 25H       ; 01C0 _ label `%
        db 73H, 27H, 20H, 25H, 73H, 20H, 64H, 75H       ; 01C8 _ s' %s du
        db 72H, 69H, 6EH, 67H, 20H, 63H, 6FH, 64H       ; 01D0 _ ring cod
        db 65H, 20H, 67H, 65H, 6EH, 65H, 72H, 61H       ; 01D8 _ e genera
        db 74H, 69H, 6FH, 6EH, 00H, 00H, 00H, 00H       ; 01E0 _ tion....

__func__.1:                                             ; byte
        db 66H, 69H, 6EH, 64H, 5FH, 6CH, 61H, 62H       ; 01E8 _ find_lab
        db 65H, 6CH, 00H, 00H, 00H, 00H, 00H, 00H       ; 01F0 _ el......
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 01F8 _ ........

__func__.0:                                             ; byte
        db 68H, 61H, 6EH, 64H, 6CH, 65H, 5FH, 68H       ; 0200 _ handle_h
        db 65H, 72H, 65H, 6CH, 61H, 62H, 65H, 6CH       ; 0208 _ erelabel
        db 00H                                          ; 0210 _ .


SECTION .data.rel.ro.local align=32 noexec              ; section number 5, data

types:                                                  ; zword
        dq Unnamed_4_0                                  ; 0000 _ 0000000000000000 (d)
        dq Unnamed_4_0+6H                               ; 0008 _ 0000000000000000 (d)
        dq Unnamed_4_0+0DH                              ; 0010 _ 0000000000000000 (d)
        dq Unnamed_4_0+14H                              ; 0018 _ 0000000000000000 (d)
        dq Unnamed_4_0+1BH                              ; 0020 _ 0000000000000000 (d)
        dq Unnamed_4_0+24H                              ; 0028 _ 0000000000000000 (d)
        dq Unnamed_4_0+2BH                              ; 0030 _ 0000000000000000 (d)
        dq Unnamed_4_0+33H                              ; 0038 _ 0000000000000000 (d)


SECTION .data.rel.local align=32 noexec                 ; section number 6, data

mangle_strings:                                         ; yword
        dq ?_130                                        ; 0000 _ 0000000000000000 (d)

?_141:  dq ?_130                                        ; 0008 _ 0000000000000000 (d)

?_142:  dq ?_130                                        ; 0010 _ 0000000000000000 (d)

?_143:  dq ?_130                                        ; 0018 _ 0000000000000000 (d)


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
        dd is_extern-$-20H                              ; 0020 _ 00000000 (rel)
        dd 00000024H, 100E4100H                         ; 0024 _ 36 269369600 
        dd 0D430286H, 070C5F06H                         ; 002C _ 222495366 118251270 
        dd 00000008H, 0000001CH                         ; 0034 _ 8 28 
        dd 0000003CH                                    ; 003C _ 60 
        dd is_extern-$-1CH                              ; 0040 _ 00000000 (rel)
        dd 0000006DH, 100E4100H                         ; 0044 _ 109 269369600 
        dd 0D430286H, 0C680206H                         ; 004C _ 222495366 208142854 
        dd 00000807H, 0000001CH                         ; 0054 _ 2055 28 
        dd 0000005CH                                    ; 005C _ 92 
        dd is_extern-$+31H                              ; 0060 _ 00000000 (rel)
        dd 00000033H, 100E4100H                         ; 0064 _ 51 269369600 
        dd 0D430286H, 070C6E06H                         ; 006C _ 222495366 118255110 
        dd 00000008H, 0000001CH                         ; 0074 _ 8 28 
        dd 0000007CH                                    ; 007C _ 124 
        dd is_extern-$+44H                              ; 0080 _ 00000000 (rel)
        dd 0000000CH, 100E4100H                         ; 0084 _ 12 269369600 
        dd 0D430286H, 070C4706H                         ; 008C _ 222495366 118245126 
        dd 00000008H, 0000001CH                         ; 0094 _ 8 28 
        dd 0000009CH                                    ; 009C _ 156 
        dd is_extern-$+30H                              ; 00A0 _ 00000000 (rel)
        dd 00000011H, 100E4100H                         ; 00A4 _ 17 269369600 
        dd 0D430286H, 070C4C06H                         ; 00AC _ 222495366 118246406 
        dd 00000008H, 0000001CH                         ; 00B4 _ 8 28 
        dd 000000BCH                                    ; 00BC _ 188 
        dd is_extern-$+21H                              ; 00C0 _ 00000000 (rel)
        dd 00000011H, 100E4100H                         ; 00C4 _ 17 269369600 
        dd 0D430286H, 070C4C06H                         ; 00CC _ 222495366 118246406 
        dd 00000008H, 0000001CH                         ; 00D4 _ 8 28 
        dd 000000DCH                                    ; 00DC _ 220 
        dd is_extern-$+12H                              ; 00E0 _ 00000000 (rel)
        dd 0000000DH, 100E4100H                         ; 00E4 _ 13 269369600 
        dd 0D430286H, 070C4806H                         ; 00EC _ 222495366 118245382 
        dd 00000008H, 0000001CH                         ; 00F4 _ 8 28 
        dd 000000FCH                                    ; 00FC _ 252 
        dd is_extern-$-1H                               ; 0100 _ 00000000 (rel)
        dd 0000005FH, 100E4100H                         ; 0104 _ 95 269369600 
        dd 0D430286H, 0C5A0206H                         ; 010C _ 222495366 207225350 
        dd 00000807H, 0000001CH                         ; 0114 _ 2055 28 
        dd 0000011CH                                    ; 011C _ 284 
        dd is_extern-$+3EH                              ; 0120 _ 00000000 (rel)
        dd 00000042H, 100E4100H                         ; 0124 _ 66 269369600 
        dd 0D430286H, 070C7D06H                         ; 012C _ 222495366 118258950 
        dd 00000008H, 0000001CH                         ; 0134 _ 8 28 
        dd 0000013CH                                    ; 013C _ 316 
        dd is_extern-$+60H                              ; 0140 _ 00000000 (rel)
        dd 00000042H, 100E4100H                         ; 0144 _ 66 269369600 
        dd 0D430286H, 070C7D06H                         ; 014C _ 222495366 118258950 
        dd 00000008H, 00000020H                         ; 0154 _ 8 32 
        dd 0000015CH                                    ; 015C _ 348 
        dd ?_004-$+160H                                 ; 0160 _ 00000000 (rel)
        dd 000001B4H, 100E4100H                         ; 0164 _ 436 269369600 
        dd 0D430286H, 03834506H                         ; 016C _ 222495366 58934534 
        dd 0C01AA03H, 00000807H                         ; 0174 _ 201435651 2055 
        dd 00000020H, 00000180H                         ; 017C _ 32 384 
        dd is_extern-$+212H                             ; 0184 _ 00000000 (rel)
        dd 00000208H, 100E4100H                         ; 0188 _ 520 269369600 
        dd 0D430286H, 03834806H                         ; 0190 _ 222495366 58935302 
        dd 0C01FB03H, 00000807H                         ; 0198 _ 201456387 2055 
        dd 0000001CH, 000001A4H                         ; 01A0 _ 28 420 
        dd is_extern-$+3F6H                             ; 01A8 _ 00000000 (rel)
        dd 0000009BH, 100E4100H                         ; 01AC _ 155 269369600 
        dd 0D430286H, 0C960206H                         ; 01B4 _ 222495366 211157510 
        dd 00000807H, 0000001CH                         ; 01BC _ 2055 28 
        dd 000001C4H                                    ; 01C4 _ 452 
        dd is_extern-$+471H                             ; 01C8 _ 00000000 (rel)
        dd 00000024H, 100E4100H                         ; 01CC _ 36 269369600 
        dd 0D430286H, 070C5F06H                         ; 01D4 _ 222495366 118251270 
        dd 00000008H, 0000001CH                         ; 01DC _ 8 28 
        dd 000001E4H                                    ; 01E4 _ 484 
        dd is_extern-$+475H                             ; 01E8 _ 00000000 (rel)
        dd 000000D5H, 100E4100H                         ; 01EC _ 213 269369600 
        dd 0D430286H, 0CD00206H                         ; 01F4 _ 222495366 214958598 
        dd 00000807H, 0000001CH                         ; 01FC _ 2055 28 
        dd 00000204H                                    ; 0204 _ 516 
        dd is_extern-$+52AH                             ; 0208 _ 00000000 (rel)
        dd 0000010DH, 100E4100H                         ; 020C _ 269 269369600 
        dd 0D430286H, 01080306H                         ; 0214 _ 222495366 17302278 
        dd 0008070CH, 0000001CH                         ; 021C _ 526092 28 
        dd 00000224H                                    ; 0224 _ 548 
        dd is_extern-$+617H                             ; 0228 _ 00000000 (rel)
        dd 00000164H, 100E4100H                         ; 022C _ 356 269369600 
        dd 0D430286H, 015F0306H                         ; 0234 _ 222495366 23003910 
        dd 0008070CH, 0000001CH                         ; 023C _ 526092 28 
        dd 00000244H                                    ; 0244 _ 580 
        dd is_extern-$+75BH                             ; 0248 _ 00000000 (rel)
        dd 0000021AH, 100E4100H                         ; 024C _ 538 269369600 
        dd 0D430286H, 02150306H                         ; 0254 _ 222495366 34931462 
        dd 0008070CH, 0000001CH                         ; 025C _ 526092 28 
        dd 00000264H                                    ; 0264 _ 612 
        dd is_extern-$+955H                             ; 0268 _ 00000000 (rel)
        dd 00000044H, 100E4100H                         ; 026C _ 68 269369600 
        dd 0D430286H, 070C7F06H                         ; 0274 _ 222495366 118259462 
        dd 00000008H, 0000001CH                         ; 027C _ 8 28 
        dd 00000284H                                    ; 0284 _ 644 
        dd is_extern-$+979H                             ; 0288 _ 00000000 (rel)
        dd 00000400H, 100E4100H                         ; 028C _ 1024 269369600 
        dd 0D430286H, 03FB0306H                         ; 0294 _ 222495366 66781958 
        dd 0008070CH, 0000001CH                         ; 029C _ 526092 28 
        dd 000002A4H                                    ; 02A4 _ 676 
        dd is_extern-$+0D59H                            ; 02A8 _ 00000000 (rel)
        dd 0000004DH, 100E4100H                         ; 02AC _ 77 269369600 
        dd 0D430286H, 0C480206H                         ; 02B4 _ 222495366 206045702 
        dd 00000807H, 0000001CH                         ; 02BC _ 2055 28 
        dd 000002C4H                                    ; 02C4 _ 708 
        dd is_extern-$+0D86H                            ; 02C8 _ 00000000 (rel)
        dd 00000097H, 100E4100H                         ; 02CC _ 151 269369600 
        dd 0D430286H, 0C920206H                         ; 02D4 _ 222495366 210895366 
        dd 00000807H, 0000001CH                         ; 02DC _ 2055 28 
        dd 000002E4H                                    ; 02E4 _ 740 
        dd is_extern-$+0DFDH                            ; 02E8 _ 00000000 (rel)
        dd 000000A2H, 100E4100H                         ; 02EC _ 162 269369600 
        dd 0D430286H, 0C9D0206H                         ; 02F4 _ 222495366 211616262 
        dd 00000807H, 0000001CH                         ; 02FC _ 2055 28 
        dd 00000304H                                    ; 0304 _ 772 
        dd is_extern-$+0E7FH                            ; 0308 _ 00000000 (rel)
        dd 00000056H, 100E4100H                         ; 030C _ 86 269369600 
        dd 0D430286H, 0C510206H                         ; 0314 _ 222495366 206635526 
        dd 00000807H, 00000020H                         ; 031C _ 2055 32 
        dd 00000324H                                    ; 0324 _ 804 
        dd is_extern-$+0EB5H                            ; 0328 _ 00000000 (rel)
        dd 000000D8H, 100E4100H                         ; 032C _ 216 269369600 
        dd 0D430286H, 03834506H                         ; 0334 _ 222495366 58934534 
        dd 070CCE02H, 00000008H                         ; 033C _ 118279682 8 
        dd 0000001CH, 00000348H                         ; 0344 _ 28 840 
        dd is_extern-$+0F69H                            ; 034C _ 00000000 (rel)
        dd 0000005BH, 100E4100H                         ; 0350 _ 91 269369600 
        dd 0D430286H, 0C560206H                         ; 0358 _ 222495366 206963206 
        dd 00000807H, 0000001CH                         ; 0360 _ 2055 28 
        dd 00000368H                                    ; 0368 _ 872 
        dd is_extern-$+0FA4H                            ; 036C _ 00000000 (rel)
        dd 000000C8H, 100E4100H                         ; 0370 _ 200 269369600 
        dd 0D430286H, 0CC30206H                         ; 0378 _ 222495366 214106630 
        dd 00000807H, 00000020H                         ; 0380 _ 2055 32 
        dd 00000388H                                    ; 0388 _ 904 
        dd ?_116-$+38CH                                 ; 038C _ 00000000 (rel)
        dd 00000034H, 100E4100H                         ; 0390 _ 52 269369600 
        dd 0D430286H, 070C6F06H                         ; 0398 _ 222495366 118255366 
        dd 00000008H, 00000000H                         ; 03A0 _ 8 0 


