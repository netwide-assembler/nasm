; Disassembly of file: /tmp/tmp.zbdmWXcmAP.o
; Wed Sep 23 14:43:22 2026
; Type: ELF64
; Syntax: NASM
; Instruction set: 80386, x64

default rel

global set_cpu: function
global directive_valid: function
global process_directives: function

extern __stack_chk_fail                                 ; near
extern set_label_mangle                                 ; near
extern process_pragma                                   ; near
extern get_boolean_option                               ; near
extern float_option                                     ; near
extern user_nolist                                      ; byte
extern set_warning_status                               ; near
extern pop_warnings                                     ; near
extern push_warnings                                    ; near
extern strcasecmp                                       ; near
extern dfmt                                             ; qword
extern in_absolute                                      ; byte
extern reloc_value                                      ; near
extern absolute                                         ; qword
extern reloc_seg                                        ; near
extern is_reloc                                         ; near
extern define_label                                     ; near
extern declare_label                                    ; near
extern readnum                                          ; near
extern strchr                                           ; near
extern location                                         ; qword
extern ilog2_64                                         ; near
extern evaluate                                         ; near
extern stdscan                                          ; near
extern _GLOBAL_OFFSET_TABLE_                            ; byte
extern stdscan_reset                                    ; near
extern switch_segment                                   ; near
extern globl                                            ; dword
extern nasm_panic_from_macro                            ; near
extern ofmt                                             ; qword
extern nasm_skip_word                                   ; near
extern nasm_zap_spaces_rev                              ; near
extern nasm_warn_                                       ; near
extern nasm_skip_string                                 ; near
extern nasm_skip_spaces                                 ; near
extern atoi                                             ; near
extern nasm_nonfatal                                    ; near
extern strncasecmp                                      ; near
extern nasm_memicmp                                     ; near
extern cmd_cpu                                          ; qword
extern strcspn                                          ; near
extern cpu                                              ; qword
extern active_list_options                              ; qword
extern memset                                           ; near
extern _pass_type                                       ; dword
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

nasm_isnumstart:; Local function
        push    rbp                                     ; 0090 _ 55
        mov     rbp, rsp                                ; 0091 _ 48: 89. E5
        sub     rsp, 8                                  ; 0094 _ 48: 83. EC, 08
        mov     byte [rbp-1H], dil                      ; 0098 _ 40: 88. 7D, FF
        movzx   eax, byte [rbp-1H]                      ; 009C _ 0F B6. 45, FF
        movzx   eax, al                                 ; 00A0 _ 0F B6. C0
        mov     esi, 1056                               ; 00A3 _ BE, 00000420
        mov     edi, eax                                ; 00A8 _ 89. C7
        call    nasm_ctype                              ; 00AA _ E8, FFFFFF51
        leave                                           ; 00AF _ C9
        ret                                             ; 00B0 _ C3

nasm_isnumchar:; Local function
        push    rbp                                     ; 00B1 _ 55
        mov     rbp, rsp                                ; 00B2 _ 48: 89. E5
        sub     rsp, 8                                  ; 00B5 _ 48: 83. EC, 08
        mov     byte [rbp-1H], dil                      ; 00B9 _ 40: 88. 7D, FF
        movzx   eax, byte [rbp-1H]                      ; 00BD _ 0F B6. 45, FF
        movzx   eax, al                                 ; 00C1 _ 0F B6. C0
        mov     esi, 2104                               ; 00C4 _ BE, 00000838
        mov     edi, eax                                ; 00C9 _ 89. C7
        call    nasm_ctype                              ; 00CB _ E8, FFFFFF30
        leave                                           ; 00D0 _ C9
        ret                                             ; 00D1 _ C3

directive_find:; Local function
        push    rbp                                     ; 00D2 _ 55
        mov     rbp, rsp                                ; 00D3 _ 48: 89. E5
        sub     rsp, 16                                 ; 00D6 _ 48: 83. EC, 10
        mov     qword [rbp-8H], rdi                     ; 00DA _ 48: 89. 7D, F8
        mov     rax, qword [rbp-8H]                     ; 00DE _ 48: 8B. 45, F8
        lea     rdx, [rel directive_hash]               ; 00E2 _ 48: 8D. 15, 00000000(rel)
        mov     rsi, rax                                ; 00E9 _ 48: 89. C6
        mov     rdi, rdx                                ; 00EC _ 48: 89. D7
        call    perfhash_find                           ; 00EF _ E8, 00000000(PLT r)
        leave                                           ; 00F4 _ C9
        ret                                             ; 00F5 _ C3

warn_active:; Local function
        push    rbp                                     ; 00F6 _ 55
        mov     rbp, rsp                                ; 00F7 _ 48: 89. E5
        mov     dword [rbp-4H], edi                     ; 00FA _ 89. 7D, FC
        mov     eax, dword [rel erropt+0CH]             ; 00FD _ 8B. 05, 00000000(rel)
        and     eax, dword [rbp-4H]                     ; 0103 _ 23. 45, FC
        test    eax, eax                                ; 0106 _ 85. C0
        jz      ?_001                                   ; 0108 _ 74, 07
        mov     eax, 0                                  ; 010A _ B8, 00000000
        jmp     ?_002                                   ; 010F _ EB, 16

?_001:  mov     eax, dword [rbp-4H]                     ; 0111 _ 8B. 45, FC
        shr     eax, 16                                 ; 0114 _ C1. E8, 10
        mov     edx, eax                                ; 0117 _ 89. C2
        lea     rax, [rel warning_state]                ; 0119 _ 48: 8D. 05, 00000000(rel)
        movzx   eax, byte [rdx+rax]                     ; 0120 _ 0F B6. 04 02
        and     eax, 01H                                ; 0124 _ 83. E0, 01
?_002:  pop     rbp                                     ; 0127 _ 5D
        ret                                             ; 0128 _ C3

pass_type:; Local function
        push    rbp                                     ; 0129 _ 55
        mov     rbp, rsp                                ; 012A _ 48: 89. E5
        mov     eax, dword [rel _pass_type]             ; 012D _ 8B. 05, 00000000(rel)
        pop     rbp                                     ; 0133 _ 5D
        ret                                             ; 0134 _ C3

pass_first:; Local function
        push    rbp                                     ; 0135 _ 55
        mov     rbp, rsp                                ; 0136 _ 48: 89. E5
        call    pass_type                               ; 0139 _ E8, FFFFFFEB
        cmp     eax, 2                                  ; 013E _ 83. F8, 02
        setbe   al                                      ; 0141 _ 0F 96. C0
        pop     rbp                                     ; 0144 _ 5D
        ret                                             ; 0145 _ C3

pass_final:; Local function
        push    rbp                                     ; 0146 _ 55
        mov     rbp, rsp                                ; 0147 _ 48: 89. E5
        call    pass_type                               ; 014A _ E8, FFFFFFDA
        cmp     eax, 4                                  ; 014F _ 83. F8, 04
        seta    al                                      ; 0152 _ 0F 97. C0
        pop     rbp                                     ; 0155 _ 5D
        ret                                             ; 0156 _ C3

iflag_test:; Local function
        push    rbp                                     ; 0157 _ 55
        mov     rbp, rsp                                ; 0158 _ 48: 89. E5
        mov     qword [rbp-8H], rdi                     ; 015B _ 48: 89. 7D, F8
        mov     dword [rbp-0CH], esi                    ; 015F _ 89. 75, F4
        mov     eax, dword [rbp-0CH]                    ; 0162 _ 8B. 45, F4
        shr     eax, 5                                  ; 0165 _ C1. E8, 05
        mov     edx, eax                                ; 0168 _ 89. C2
        mov     rax, qword [rbp-8H]                     ; 016A _ 48: 8B. 45, F8
        mov     edx, edx                                ; 016E _ 89. D2
        mov     eax, dword [rax+rdx*4]                  ; 0170 _ 8B. 04 90
        mov     edx, dword [rbp-0CH]                    ; 0173 _ 8B. 55, F4
        and     edx, 1FH                                ; 0176 _ 83. E2, 1F
        mov     esi, 1                                  ; 0179 _ BE, 00000001
        mov     ecx, edx                                ; 017E _ 89. D1
        shl     esi, cl                                 ; 0180 _ D3. E6
        mov     edx, esi                                ; 0182 _ 89. F2
        and     eax, edx                                ; 0184 _ 21. D0
        test    eax, eax                                ; 0186 _ 85. C0
        setne   al                                      ; 0188 _ 0F 95. C0
        pop     rbp                                     ; 018B _ 5D
        ret                                             ; 018C _ C3

iflag_set:; Local function
        push    rbp                                     ; 018D _ 55
        mov     rbp, rsp                                ; 018E _ 48: 89. E5
        mov     qword [rbp-8H], rdi                     ; 0191 _ 48: 89. 7D, F8
        mov     dword [rbp-0CH], esi                    ; 0195 _ 89. 75, F4
        mov     eax, dword [rbp-0CH]                    ; 0198 _ 8B. 45, F4
        shr     eax, 5                                  ; 019B _ C1. E8, 05
        mov     edx, eax                                ; 019E _ 89. C2
        mov     rax, qword [rbp-8H]                     ; 01A0 _ 48: 8B. 45, F8
        mov     edx, edx                                ; 01A4 _ 89. D2
        mov     eax, dword [rax+rdx*4]                  ; 01A6 _ 8B. 04 90
        mov     edx, dword [rbp-0CH]                    ; 01A9 _ 8B. 55, F4
        and     edx, 1FH                                ; 01AC _ 83. E2, 1F
        mov     esi, 1                                  ; 01AF _ BE, 00000001
        mov     ecx, edx                                ; 01B4 _ 89. D1
        shl     esi, cl                                 ; 01B6 _ D3. E6
        mov     ecx, esi                                ; 01B8 _ 89. F1
        mov     edx, dword [rbp-0CH]                    ; 01BA _ 8B. 55, F4
        mov     esi, edx                                ; 01BD _ 89. D6
        shr     esi, 5                                  ; 01BF _ C1. EE, 05
        or      eax, ecx                                ; 01C2 _ 09. C8
        mov     edx, eax                                ; 01C4 _ 89. C2
        mov     rax, qword [rbp-8H]                     ; 01C6 _ 48: 8B. 45, F8
        mov     ecx, esi                                ; 01CA _ 89. F1
        mov     dword [rax+rcx*4], edx                  ; 01CC _ 89. 14 88
        nop                                             ; 01CF _ 90
        pop     rbp                                     ; 01D0 _ 5D
        ret                                             ; 01D1 _ C3

iflag_clear:; Local function
        push    rbp                                     ; 01D2 _ 55
        mov     rbp, rsp                                ; 01D3 _ 48: 89. E5
        mov     qword [rbp-8H], rdi                     ; 01D6 _ 48: 89. 7D, F8
        mov     dword [rbp-0CH], esi                    ; 01DA _ 89. 75, F4
        mov     eax, dword [rbp-0CH]                    ; 01DD _ 8B. 45, F4
        shr     eax, 5                                  ; 01E0 _ C1. E8, 05
        mov     edx, eax                                ; 01E3 _ 89. C2
        mov     rax, qword [rbp-8H]                     ; 01E5 _ 48: 8B. 45, F8
        mov     edx, edx                                ; 01E9 _ 89. D2
        mov     eax, dword [rax+rdx*4]                  ; 01EB _ 8B. 04 90
        mov     edx, dword [rbp-0CH]                    ; 01EE _ 8B. 55, F4
        and     edx, 1FH                                ; 01F1 _ 83. E2, 1F
        mov     esi, 1                                  ; 01F4 _ BE, 00000001
        mov     ecx, edx                                ; 01F9 _ 89. D1
        shl     esi, cl                                 ; 01FB _ D3. E6
        mov     edx, esi                                ; 01FD _ 89. F2
        mov     ecx, edx                                ; 01FF _ 89. D1
        not     ecx                                     ; 0201 _ F7. D1
        mov     edx, dword [rbp-0CH]                    ; 0203 _ 8B. 55, F4
        mov     esi, edx                                ; 0206 _ 89. D6
        shr     esi, 5                                  ; 0208 _ C1. EE, 05
        and     eax, ecx                                ; 020B _ 21. C8
        mov     edx, eax                                ; 020D _ 89. C2
        mov     rax, qword [rbp-8H]                     ; 020F _ 48: 8B. 45, F8
        mov     ecx, esi                                ; 0213 _ 89. F1
        mov     dword [rax+rcx*4], edx                  ; 0215 _ 89. 14 88
        nop                                             ; 0218 _ 90
        pop     rbp                                     ; 0219 _ 5D
        ret                                             ; 021A _ C3

_iflag_cpu_level:; Local function
        push    rbp                                     ; 021B _ 55
        mov     rbp, rsp                                ; 021C _ 48: 89. E5
        mov     qword [rbp-8H], rdi                     ; 021F _ 48: 89. 7D, F8
        mov     rax, qword [rbp-8H]                     ; 0223 _ 48: 8B. 45, F8
        mov     eax, dword [rax+18H]                    ; 0227 _ 8B. 40, 18
        and     eax, 3FFFFH                             ; 022A _ 25, 0003FFFF
        pop     rbp                                     ; 022F _ 5D
        ret                                             ; 0230 _ C3

iflag_cpu_level_ok:; Local function
        push    rbp                                     ; 0231 _ 55
        mov     rbp, rsp                                ; 0232 _ 48: 89. E5
        sub     rsp, 16                                 ; 0235 _ 48: 83. EC, 10
        mov     qword [rbp-8H], rdi                     ; 0239 _ 48: 89. 7D, F8
        mov     dword [rbp-0CH], esi                    ; 023D _ 89. 75, F4
        mov     rax, qword [rbp-8H]                     ; 0240 _ 48: 8B. 45, F8
        mov     rdi, rax                                ; 0244 _ 48: 89. C7
        call    _iflag_cpu_level                        ; 0247 _ E8, FFFFFFCF
        mov     edx, dword [rbp-0CH]                    ; 024C _ 8B. 55, F4
        and     edx, 1FH                                ; 024F _ 83. E2, 1F
        mov     ecx, edx                                ; 0252 _ 89. D1
        shr     eax, cl                                 ; 0254 _ D3. E8
        test    eax, eax                                ; 0256 _ 85. C0
        setne   al                                      ; 0258 _ 0F 95. C0
        leave                                           ; 025B _ C9
        ret                                             ; 025C _ C3

iflag_set_all_features:; Local function
        push    rbp                                     ; 025D _ 55
        mov     rbp, rsp                                ; 025E _ 48: 89. E5
        sub     rsp, 32                                 ; 0261 _ 48: 83. EC, 20
        mov     qword [rbp-18H], rdi                    ; 0265 _ 48: 89. 7D, E8
        mov     rax, qword [rbp-18H]                    ; 0269 _ 48: 8B. 45, E8
        add     rax, 8                                  ; 026D _ 48: 83. C0, 08
        mov     qword [rbp-8H], rax                     ; 0271 _ 48: 89. 45, F8
        mov     rax, qword [rbp-8H]                     ; 0275 _ 48: 8B. 45, F8
        mov     edx, 16                                 ; 0279 _ BA, 00000010
        mov     esi, 4294967295                         ; 027E _ BE, FFFFFFFF
        mov     rdi, rax                                ; 0283 _ 48: 89. C7
        call    memset                                  ; 0286 _ E8, 00000000(PLT r)
        nop                                             ; 028B _ 90
        leave                                           ; 028C _ C9
        ret                                             ; 028D _ C3

list_option_mask:; Local function
        push    rbp                                     ; 028E _ 55
        mov     rbp, rsp                                ; 028F _ 48: 89. E5
        mov     byte [rbp-1H], dil                      ; 0292 _ 40: 88. 7D, FF
        cmp     byte [rbp-1H], 96                       ; 0296 _ 80. 7D, FF, 60
        jbe     ?_004                                   ; 029A _ 76, 13
        cmp     byte [rbp-1H], 122                      ; 029C _ 80. 7D, FF, 7A
        jbe     ?_003                                   ; 02A0 _ 76, 07
        mov     eax, 0                                  ; 02A2 _ B8, 00000000
        jmp     ?_010                                   ; 02A7 _ EB, 50

?_003:  sub     byte [rbp-1H], 95                       ; 02A9 _ 80. 6D, FF, 5F
        jmp     ?_009                                   ; 02AD _ EB, 39

?_004:  cmp     byte [rbp-1H], 64                       ; 02AF _ 80. 7D, FF, 40
        jbe     ?_006                                   ; 02B3 _ 76, 13
        cmp     byte [rbp-1H], 90                       ; 02B5 _ 80. 7D, FF, 5A
        jbe     ?_005                                   ; 02B9 _ 76, 07
        mov     eax, 0                                  ; 02BB _ B8, 00000000
        jmp     ?_010                                   ; 02C0 _ EB, 37

?_005:  sub     byte [rbp-1H], 37                       ; 02C2 _ 80. 6D, FF, 25
        jmp     ?_009                                   ; 02C6 _ EB, 20

?_006:  cmp     byte [rbp-1H], 47                       ; 02C8 _ 80. 7D, FF, 2F
        jbe     ?_008                                   ; 02CC _ 76, 13
        cmp     byte [rbp-1H], 57                       ; 02CE _ 80. 7D, FF, 39
        jbe     ?_007                                   ; 02D2 _ 76, 07
        mov     eax, 0                                  ; 02D4 _ B8, 00000000
        jmp     ?_010                                   ; 02D9 _ EB, 1E

?_007:  add     byte [rbp-1H], 6                        ; 02DB _ 80. 45, FF, 06
        jmp     ?_009                                   ; 02DF _ EB, 07

?_008:  mov     eax, 0                                  ; 02E1 _ B8, 00000000
        jmp     ?_010                                   ; 02E6 _ EB, 11

?_009:  movzx   eax, byte [rbp-1H]                      ; 02E8 _ 0F B6. 45, FF
        mov     edx, 1                                  ; 02EC _ BA, 00000001
        mov     ecx, eax                                ; 02F1 _ 89. C1
        shl     rdx, cl                                 ; 02F3 _ 48: D3. E2
        mov     rax, rdx                                ; 02F6 _ 48: 89. D0
?_010:  pop     rbp                                     ; 02F9 _ 5D
        ret                                             ; 02FA _ C3

list_option:; Local function
        push    rbp                                     ; 02FB _ 55
        mov     rbp, rsp                                ; 02FC _ 48: 89. E5
        sub     rsp, 8                                  ; 02FF _ 48: 83. EC, 08
        mov     byte [rbp-1H], dil                      ; 0303 _ 40: 88. 7D, FF
        movzx   eax, byte [rbp-1H]                      ; 0307 _ 0F B6. 45, FF
        mov     edi, eax                                ; 030B _ 89. C7
        call    list_option_mask                        ; 030D _ E8, FFFFFF7C
        mov     rdx, qword [rel active_list_options]    ; 0312 _ 48: 8B. 15, 00000000(rel)
        and     rax, rdx                                ; 0319 _ 48: 21. D0
        test    rax, rax                                ; 031C _ 48: 85. C0
        setne   al                                      ; 031F _ 0F 95. C0
        movzx   eax, al                                 ; 0322 _ 0F B6. C0
        test    rax, rax                                ; 0325 _ 48: 85. C0
        setne   al                                      ; 0328 _ 0F 95. C0
        leave                                           ; 032B _ C9
        ret                                             ; 032C _ C3

iflag_set_cpu:; Local function
        push    rbp                                     ; 032D _ 55
        mov     rbp, rsp                                ; 032E _ 48: 89. E5
        sub     rsp, 16                                 ; 0331 _ 48: 83. EC, 10
        mov     qword [rbp-8H], rdi                     ; 0335 _ 48: 89. 7D, F8
        mov     dword [rbp-0CH], esi                    ; 0339 _ 89. 75, F4
        mov     rax, qword [rbp-8H]                     ; 033C _ 48: 8B. 45, F8
        mov     dword [rax], 0                          ; 0340 _ C7. 00, 00000000
        mov     rax, qword [rbp-8H]                     ; 0346 _ 48: 8B. 45, F8
        mov     rdi, rax                                ; 034A _ 48: 89. C7
        call    iflag_set_all_features                  ; 034D _ E8, FFFFFF0B
        cmp     dword [rbp-0CH], 208                    ; 0352 _ 81. 7D, F4, 000000D0
        jbe     ?_011                                   ; 0359 _ 76, 11
        mov     rax, qword [rbp-8H]                     ; 035B _ 48: 8B. 45, F8
        mov     esi, 28                                 ; 035F _ BE, 0000001C
        mov     rdi, rax                                ; 0364 _ 48: 89. C7
        call    iflag_set                               ; 0367 _ E8, FFFFFE21
?_011:  mov     rax, qword [rbp-8H]                     ; 036C _ 48: 8B. 45, F8
        mov     eax, dword [rax+18H]                    ; 0370 _ 8B. 40, 18
        and     eax, 0FFFC0000H                         ; 0373 _ 25, FFFC0000
        mov     edx, eax                                ; 0378 _ 89. C2
        mov     rax, qword [rbp-8H]                     ; 037A _ 48: 8B. 45, F8
        mov     dword [rax+18H], edx                    ; 037E _ 89. 50, 18
        mov     edx, dword [rbp-0CH]                    ; 0381 _ 8B. 55, F4
        mov     rax, qword [rbp-8H]                     ; 0384 _ 48: 8B. 45, F8
        mov     esi, edx                                ; 0388 _ 89. D6
        mov     rdi, rax                                ; 038A _ 48: 89. C7
        call    iflag_set                               ; 038D _ E8, FFFFFDFB
        nop                                             ; 0392 _ 90
        leave                                           ; 0393 _ C9
        ret                                             ; 0394 _ C3

set_cpu:; Function begin
        push    rbp                                     ; 0395 _ 55
        mov     rbp, rsp                                ; 0396 _ 48: 89. E5
        sub     rsp, 48                                 ; 0399 _ 48: 83. EC, 30
        mov     qword [rbp-28H], rdi                    ; 039D _ 48: 89. 7D, D8
        cmp     qword [rbp-28H], 0                      ; 03A1 _ 48: 83. 7D, D8, 00
        jnz     ?_012                                   ; 03A6 _ 75, 1C
        mov     eax, dword [rel ?_171]                  ; 03A8 _ 8B. 05, 00000000(rel)
        lea     rdx, [rel cpu]                          ; 03AE _ 48: 8D. 15, 00000000(rel)
        mov     esi, eax                                ; 03B5 _ 89. C6
        mov     rdi, rdx                                ; 03B7 _ 48: 89. D7
        call    iflag_set_cpu                           ; 03BA _ E8, FFFFFF6E
        jmp     ?_030                                   ; 03BF _ E9, 00000249

?_012:  mov     rax, qword [rbp-28H]                    ; 03C4 _ 48: 8B. 45, D8
        mov     qword [rbp-10H], rax                    ; 03C8 _ 48: 89. 45, F0
        mov     byte [rbp-16H], 43                      ; 03CC _ C6. 45, EA, 2B
        jmp     ?_028                                   ; 03D0 _ E9, 00000226

?_013:  lea     rdx, [rel ?_145]                        ; 03D5 _ 48: 8D. 15, 00000000(rel)
        mov     rax, qword [rbp-10H]                    ; 03DC _ 48: 8B. 45, F0
        mov     rsi, rdx                                ; 03E0 _ 48: 89. D6
        mov     rdi, rax                                ; 03E3 _ 48: 89. C7
        call    strcspn                                 ; 03E6 _ E8, 00000000(PLT r)
        mov     dword [rbp-14H], eax                    ; 03EB _ 89. 45, EC
        jmp     ?_015                                   ; 03EE _ EB, 5A

?_014:  mov     rax, qword [rbp-10H]                    ; 03F0 _ 48: 8B. 45, F0
        lea     rdx, [rax+1H]                           ; 03F4 _ 48: 8D. 50, 01
        mov     qword [rbp-10H], rdx                    ; 03F8 _ 48: 89. 55, F0
        movzx   eax, byte [rax]                         ; 03FC _ 0F B6. 00
        mov     byte [rbp-16H], al                      ; 03FF _ 88. 45, EA
        sub     dword [rbp-14H], 1                      ; 0402 _ 83. 6D, EC, 01
        cmp     dword [rbp-14H], 0                      ; 0406 _ 83. 7D, EC, 00
        jnz     ?_015                                   ; 040A _ 75, 3E
        cmp     byte [rbp-16H], 42                      ; 040C _ 80. 7D, EA, 2A
        jnz     ?_015                                   ; 0410 _ 75, 38
        mov     rax, qword [rel cmd_cpu]                ; 0412 _ 48: 8B. 05, 00000000(rel)
        mov     rdx, qword [rel cmd_cpu+8H]             ; 0419 _ 48: 8B. 15, 00000000(rel)
        mov     qword [rel cpu], rax                    ; 0420 _ 48: 89. 05, 00000000(rel)
        mov     qword [rel cpu+8H], rdx                 ; 0427 _ 48: 89. 15, 00000000(rel)
; Note: Memory operand is misaligned. Performance penalty
        mov     rax, qword [rel cmd_cpu+0CH]            ; 042E _ 48: 8B. 05, 00000000(rel)
; Note: Memory operand is misaligned. Performance penalty
        mov     rdx, qword [rel cmd_cpu+14H]            ; 0435 _ 48: 8B. 15, 00000000(rel)
; Note: Memory operand is misaligned. Performance penalty
        mov     qword [rel cpu+0CH], rax                ; 043C _ 48: 89. 05, 00000000(rel)
; Note: Memory operand is misaligned. Performance penalty
        mov     qword [rel cpu+14H], rdx                ; 0443 _ 48: 89. 15, 00000000(rel)
?_015:  cmp     dword [rbp-14H], 0                      ; 044A _ 83. 7D, EC, 00
        jz      ?_016                                   ; 044E _ 74, 25
        mov     rax, qword [rbp-10H]                    ; 0450 _ 48: 8B. 45, F0
        movzx   eax, byte [rax]                         ; 0454 _ 0F B6. 00
        cmp     al, 43                                  ; 0457 _ 3C, 2B
        jz      ?_014                                   ; 0459 _ 74, 95
        mov     rax, qword [rbp-10H]                    ; 045B _ 48: 8B. 45, F0
        movzx   eax, byte [rax]                         ; 045F _ 0F B6. 00
        cmp     al, 45                                  ; 0462 _ 3C, 2D
        jz      ?_014                                   ; 0464 _ 74, 8A
        mov     rax, qword [rbp-10H]                    ; 0466 _ 48: 8B. 45, F0
        movzx   eax, byte [rax]                         ; 046A _ 0F B6. 00
        cmp     al, 42                                  ; 046D _ 3C, 2A
        je      ?_014                                   ; 046F _ 0F 84, FFFFFF7B
?_016:  cmp     dword [rbp-14H], 0                      ; 0475 _ 83. 7D, EC, 00
        je      ?_027                                   ; 0479 _ 0F 84, 00000163
        mov     byte [rbp-15H], 0                       ; 047F _ C6. 45, EB, 00
        cmp     dword [rbp-14H], 2                      ; 0483 _ 83. 7D, EC, 02
        jle     ?_017                                   ; 0487 _ 7E, 2C
        lea     rcx, [rel ?_146]                        ; 0489 _ 48: 8D. 0D, 00000000(rel)
        mov     rax, qword [rbp-10H]                    ; 0490 _ 48: 8B. 45, F0
        mov     edx, 2                                  ; 0494 _ BA, 00000002
        mov     rsi, rcx                                ; 0499 _ 48: 89. CE
        mov     rdi, rax                                ; 049C _ 48: 89. C7
        call    nasm_memicmp                            ; 049F _ E8, 00000000(PLT r)
        test    eax, eax                                ; 04A4 _ 85. C0
        jnz     ?_017                                   ; 04A6 _ 75, 0D
        mov     byte [rbp-15H], 1                       ; 04A8 _ C6. 45, EB, 01
        add     qword [rbp-10H], 2                      ; 04AC _ 48: 83. 45, F0, 02
        sub     dword [rbp-14H], 2                      ; 04B1 _ 83. 6D, EC, 02
?_017:  lea     rax, [rel cpunames.1]                   ; 04B5 _ 48: 8D. 05, 00000000(rel)
        mov     qword [rbp-8H], rax                     ; 04BC _ 48: 89. 45, F8
        jmp     ?_019                                   ; 04C0 _ EB, 25

?_018:  mov     eax, dword [rbp-14H]                    ; 04C2 _ 8B. 45, EC
        movsxd  rdx, eax                                ; 04C5 _ 48: 63. D0
        mov     rax, qword [rbp-8H]                     ; 04C8 _ 48: 8B. 45, F8
        mov     rcx, qword [rax]                        ; 04CC _ 48: 8B. 08
        mov     rax, qword [rbp-10H]                    ; 04CF _ 48: 8B. 45, F0
        mov     rsi, rcx                                ; 04D3 _ 48: 89. CE
        mov     rdi, rax                                ; 04D6 _ 48: 89. C7
        call    strncasecmp                             ; 04D9 _ E8, 00000000(PLT r)
        test    eax, eax                                ; 04DE _ 85. C0
        jz      ?_020                                   ; 04E0 _ 74, 13
        add     qword [rbp-8H], 16                      ; 04E2 _ 48: 83. 45, F8, 10
?_019:  mov     rax, qword [rbp-8H]                     ; 04E7 _ 48: 8B. 45, F8
        mov     rax, qword [rax]                        ; 04EB _ 48: 8B. 00
        test    rax, rax                                ; 04EE _ 48: 85. C0
        jnz     ?_018                                   ; 04F1 _ 75, CF
        jmp     ?_021                                   ; 04F3 _ EB, 01

?_020:  nop                                             ; 04F5 _ 90
?_021:  mov     rax, qword [rbp-8H]                     ; 04F6 _ 48: 8B. 45, F8
        mov     rax, qword [rax]                        ; 04FA _ 48: 8B. 00
        test    rax, rax                                ; 04FD _ 48: 85. C0
        jnz     ?_022                                   ; 0500 _ 75, 22
        mov     rdx, qword [rbp-10H]                    ; 0502 _ 48: 8B. 55, F0
        mov     eax, dword [rbp-14H]                    ; 0506 _ 8B. 45, EC
        lea     rcx, [rel ?_147]                        ; 0509 _ 48: 8D. 0D, 00000000(rel)
        mov     esi, eax                                ; 0510 _ 89. C6
        mov     rdi, rcx                                ; 0512 _ 48: 89. CF
        mov     eax, 0                                  ; 0515 _ B8, 00000000
        call    nasm_nonfatal                           ; 051A _ E8, 00000000(PLT r)
        jmp     ?_030                                   ; 051F _ E9, 000000E9

?_022:  mov     rax, qword [rbp-8H]                     ; 0524 _ 48: 8B. 45, F8
        mov     eax, dword [rax+8H]                     ; 0528 _ 8B. 40, 08
        cmp     eax, 191                                ; 052B _ 3D, 000000BF
        jbe     ?_023                                   ; 0530 _ 76, 2B
        mov     rax, qword [rbp-8H]                     ; 0532 _ 48: 8B. 45, F8
        mov     eax, dword [rax+8H]                     ; 0536 _ 8B. 40, 08
        cmp     eax, 209                                ; 0539 _ 3D, 000000D1
        ja      ?_023                                   ; 053E _ 77, 1D
        mov     rax, qword [rbp-8H]                     ; 0540 _ 48: 8B. 45, F8
        mov     eax, dword [rax+8H]                     ; 0544 _ 8B. 40, 08
        lea     rdx, [rel cpu]                          ; 0547 _ 48: 8D. 15, 00000000(rel)
        mov     esi, eax                                ; 054E _ 89. C6
        mov     rdi, rdx                                ; 0550 _ 48: 89. D7
        call    iflag_set_cpu                           ; 0553 _ E8, FFFFFDD5
        jmp     ?_027                                   ; 0558 _ E9, 00000085

?_023:  movsx   eax, byte [rbp-16H]                     ; 055D _ 0F BE. 45, EA
        cmp     eax, 42                                 ; 0561 _ 83. F8, 2A
        jz      ?_024                                   ; 0564 _ 74, 1D
        cmp     eax, 45                                 ; 0566 _ 83. F8, 2D
        jnz     ?_025                                   ; 0569 _ 75, 40
        movzx   eax, byte [rbp-15H]                     ; 056B _ 0F B6. 45, EB
        test    eax, eax                                ; 056F _ 85. C0
        setne   al                                      ; 0571 _ 0F 95. C0
        xor     eax, 01H                                ; 0574 _ 83. F0, 01
        movzx   eax, al                                 ; 0577 _ 0F B6. C0
        mov     byte [rbp-15H], al                      ; 057A _ 88. 45, EB
        and     byte [rbp-15H], 01H                     ; 057D _ 80. 65, EB, 01
        jmp     ?_026                                   ; 0581 _ EB, 29

?_024:  mov     rax, qword [rbp-8H]                     ; 0583 _ 48: 8B. 45, F8
        mov     eax, dword [rax+8H]                     ; 0587 _ 8B. 40, 08
        lea     rdx, [rel cmd_cpu]                      ; 058A _ 48: 8D. 15, 00000000(rel)
        mov     esi, eax                                ; 0591 _ 89. C6
        mov     rdi, rdx                                ; 0593 _ 48: 89. D7
        call    iflag_test                              ; 0596 _ E8, FFFFFBBC
        xor     al, byte [rbp-15H]                      ; 059B _ 32. 45, EB
        movzx   eax, al                                 ; 059E _ 0F B6. C0
        test    eax, eax                                ; 05A1 _ 85. C0
        setne   al                                      ; 05A3 _ 0F 95. C0
        mov     byte [rbp-15H], al                      ; 05A6 _ 88. 45, EB
        jmp     ?_026                                   ; 05A9 _ EB, 01

?_025:  nop                                             ; 05AB _ 90
?_026:  mov     rax, qword [rbp-8H]                     ; 05AC _ 48: 8B. 45, F8
        mov     eax, dword [rax+8H]                     ; 05B0 _ 8B. 40, 08
        lea     rdx, [rel cpu]                          ; 05B3 _ 48: 8D. 15, 00000000(rel)
        mov     esi, eax                                ; 05BA _ 89. C6
        mov     rdi, rdx                                ; 05BC _ 48: 89. D7
        call    iflag_set                               ; 05BF _ E8, FFFFFBC9
        cmp     byte [rbp-15H], 0                       ; 05C4 _ 80. 7D, EB, 00
        jz      ?_027                                   ; 05C8 _ 74, 18
        mov     rax, qword [rbp-8H]                     ; 05CA _ 48: 8B. 45, F8
        mov     eax, dword [rax+8H]                     ; 05CE _ 8B. 40, 08
        lea     rdx, [rel cpu]                          ; 05D1 _ 48: 8D. 15, 00000000(rel)
        mov     esi, eax                                ; 05D8 _ 89. C6
        mov     rdi, rdx                                ; 05DA _ 48: 89. D7
        call    iflag_clear                             ; 05DD _ E8, FFFFFBF0
?_027:  mov     eax, dword [rbp-14H]                    ; 05E2 _ 8B. 45, EC
        cdqe                                            ; 05E5 _ 48: 98
        add     qword [rbp-10H], rax                    ; 05E7 _ 48: 01. 45, F0
        mov     rax, qword [rbp-10H]                    ; 05EB _ 48: 8B. 45, F0
        movzx   eax, byte [rax]                         ; 05EF _ 0F B6. 00
        test    al, al                                  ; 05F2 _ 84. C0
        jz      ?_029                                   ; 05F4 _ 74, 16
        add     qword [rbp-10H], 1                      ; 05F6 _ 48: 83. 45, F0, 01
?_028:  mov     rax, qword [rbp-10H]                    ; 05FB _ 48: 8B. 45, F0
        movzx   eax, byte [rax]                         ; 05FF _ 0F B6. 00
        test    al, al                                  ; 0602 _ 84. C0
        jne     ?_013                                   ; 0604 _ 0F 85, FFFFFDCB
        jmp     ?_030                                   ; 060A _ EB, 01

?_029:  nop                                             ; 060C _ 90
?_030:  leave                                           ; 060D _ C9
        ret                                             ; 060E _ C3
; set_cpu End of function

get_bits:; Local function
        push    rbp                                     ; 060F _ 55
        mov     rbp, rsp                                ; 0610 _ 48: 89. E5
        sub     rsp, 32                                 ; 0613 _ 48: 83. EC, 20
        mov     qword [rbp-18H], rdi                    ; 0617 _ 48: 89. 7D, E8
        mov     rax, qword [rbp-18H]                    ; 061B _ 48: 8B. 45, E8
        mov     rdi, rax                                ; 061F _ 48: 89. C7
        call    atoi                                    ; 0622 _ E8, 00000000(PLT r)
        mov     dword [rbp-4H], eax                     ; 0627 _ 89. 45, FC
        cmp     dword [rbp-4H], 64                      ; 062A _ 83. 7D, FC, 40
        jz      ?_031                                   ; 062E _ 74, 52
        cmp     dword [rbp-4H], 64                      ; 0630 _ 83. 7D, FC, 40
        jg      ?_032                                   ; 0634 _ 0F 8F, 00000080
        cmp     dword [rbp-4H], 16                      ; 063A _ 83. 7D, FC, 10
        je      ?_033                                   ; 063E _ 0F 84, 0000009A
        cmp     dword [rbp-4H], 32                      ; 0644 _ 83. 7D, FC, 20
        jnz     ?_032                                   ; 0648 _ 75, 70
        lea     rax, [rel cpu]                          ; 064A _ 48: 8D. 05, 00000000(rel)
        mov     esi, 195                                ; 0651 _ BE, 000000C3
        mov     rdi, rax                                ; 0656 _ 48: 89. C7
        call    iflag_cpu_level_ok                      ; 0659 _ E8, FFFFFBD3
        xor     eax, 01H                                ; 065E _ 83. F0, 01
        test    al, al                                  ; 0661 _ 84. C0
        jz      ?_034                                   ; 0663 _ 74, 7C
        lea     rax, [rel ?_148]                        ; 0665 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 066C _ 48: 89. C7
        mov     eax, 0                                  ; 066F _ B8, 00000000
        call    nasm_nonfatal                           ; 0674 _ E8, 00000000(PLT r)
        mov     dword [rbp-4H], 16                      ; 0679 _ C7. 45, FC, 00000010
        jmp     ?_034                                   ; 0680 _ EB, 5F

?_031:  lea     rax, [rel cpu]                          ; 0682 _ 48: 8D. 05, 00000000(rel)
        mov     esi, 203                                ; 0689 _ BE, 000000CB
        mov     rdi, rax                                ; 068E _ 48: 89. C7
        call    iflag_cpu_level_ok                      ; 0691 _ E8, FFFFFB9B
        xor     eax, 01H                                ; 0696 _ 83. F0, 01
        test    al, al                                  ; 0699 _ 84. C0
        jz      ?_035                                   ; 069B _ 74, 47
        lea     rax, [rel ?_149]                        ; 069D _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 06A4 _ 48: 89. C7
        mov     eax, 0                                  ; 06A7 _ B8, 00000000
        call    nasm_nonfatal                           ; 06AC _ E8, 00000000(PLT r)
        mov     dword [rbp-4H], 16                      ; 06B1 _ C7. 45, FC, 00000010
        jmp     ?_035                                   ; 06B8 _ EB, 2A

?_032:  mov     rax, qword [rbp-18H]                    ; 06BA _ 48: 8B. 45, E8
        lea     rdx, [rel ?_150]                        ; 06BE _ 48: 8D. 15, 00000000(rel)
        mov     rsi, rax                                ; 06C5 _ 48: 89. C6
        mov     rdi, rdx                                ; 06C8 _ 48: 89. D7
        mov     eax, 0                                  ; 06CB _ B8, 00000000
        call    nasm_nonfatal                           ; 06D0 _ E8, 00000000(PLT r)
        mov     dword [rbp-4H], 16                      ; 06D5 _ C7. 45, FC, 00000010
        jmp     ?_036                                   ; 06DC _ EB, 07

?_033:  nop                                             ; 06DE _ 90
        jmp     ?_036                                   ; 06DF _ EB, 04

?_034:  nop                                             ; 06E1 _ 90
        jmp     ?_036                                   ; 06E2 _ EB, 01

?_035:  nop                                             ; 06E4 _ 90
?_036:  mov     eax, dword [rbp-4H]                     ; 06E5 _ 8B. 45, FC
        leave                                           ; 06E8 _ C9
        ret                                             ; 06E9 _ C3

parse_directive_line:; Local function
        push    rbp                                     ; 06EA _ 55
        mov     rbp, rsp                                ; 06EB _ 48: 89. E5
        sub     rsp, 64                                 ; 06EE _ 48: 83. EC, 40
        mov     qword [rbp-38H], rdi                    ; 06F2 _ 48: 89. 7D, C8
        mov     qword [rbp-40H], rsi                    ; 06F6 _ 48: 89. 75, C0
        mov     rax, qword [rbp-38H]                    ; 06FA _ 48: 8B. 45, C8
        mov     rax, qword [rax]                        ; 06FE _ 48: 8B. 00
        mov     rdi, rax                                ; 0701 _ 48: 89. C7
        call    nasm_skip_spaces                        ; 0704 _ E8, 00000000(PLT r)
        mov     qword [rbp-18H], rax                    ; 0709 _ 48: 89. 45, E8
        mov     rax, qword [rbp-18H]                    ; 070D _ 48: 8B. 45, E8
        movzx   eax, byte [rax]                         ; 0711 _ 0F B6. 00
        cmp     al, 91                                  ; 0714 _ 3C, 5B
        jz      ?_037                                   ; 0716 _ 74, 0A
        mov     eax, 0                                  ; 0718 _ B8, 00000000
        jmp     ?_045                                   ; 071D _ E9, 0000016C

?_037:  mov     rax, qword [rbp-18H]                    ; 0722 _ 48: 8B. 45, E8
        mov     qword [rbp-20H], rax                    ; 0726 _ 48: 89. 45, E0
        jmp     ?_042                                   ; 072A _ EB, 6A

?_038:  movsx   eax, byte [rbp-25H]                     ; 072C _ 0F BE. 45, DB
        cmp     eax, 96                                 ; 0730 _ 83. F8, 60
        jz      ?_040                                   ; 0733 _ 74, 2E
        cmp     eax, 96                                 ; 0735 _ 83. F8, 60
        jg      ?_041                                   ; 0738 _ 7F, 56
        cmp     eax, 59                                 ; 073A _ 83. F8, 3B
        jz      ?_039                                   ; 073D _ 74, 1A
        cmp     eax, 59                                 ; 073F _ 83. F8, 3B
        jg      ?_041                                   ; 0742 _ 7F, 4C
        cmp     eax, 39                                 ; 0744 _ 83. F8, 27
        jz      ?_040                                   ; 0747 _ 74, 1A
        cmp     eax, 39                                 ; 0749 _ 83. F8, 27
        jg      ?_041                                   ; 074C _ 7F, 42
        test    eax, eax                                ; 074E _ 85. C0
        jz      ?_039                                   ; 0750 _ 74, 07
        cmp     eax, 34                                 ; 0752 _ 83. F8, 22
        jz      ?_040                                   ; 0755 _ 74, 0C
        jmp     ?_041                                   ; 0757 _ EB, 37

?_039:  mov     eax, 2                                  ; 0759 _ B8, 00000002
        jmp     ?_045                                   ; 075E _ E9, 0000012B

?_040:  mov     rax, qword [rbp-20H]                    ; 0763 _ 48: 8B. 45, E0
        mov     rdi, rax                                ; 0767 _ 48: 89. C7
        call    nasm_skip_string                        ; 076A _ E8, 00000000(PLT r)
        mov     qword [rbp-20H], rax                    ; 076F _ 48: 89. 45, E0
        mov     rax, qword [rbp-20H]                    ; 0773 _ 48: 8B. 45, E0
        lea     rdx, [rax+1H]                           ; 0777 _ 48: 8D. 50, 01
        mov     qword [rbp-20H], rdx                    ; 077B _ 48: 89. 55, E0
        movzx   eax, byte [rax]                         ; 077F _ 0F B6. 00
        test    al, al                                  ; 0782 _ 84. C0
        jnz     ?_042                                   ; 0784 _ 75, 10
        mov     eax, 2                                  ; 0786 _ B8, 00000002
        jmp     ?_045                                   ; 078B _ E9, 000000FE

?_041:  add     qword [rbp-20H], 1                      ; 0790 _ 48: 83. 45, E0, 01
        nop                                             ; 0795 _ 90
?_042:  mov     rax, qword [rbp-20H]                    ; 0796 _ 48: 8B. 45, E0
        movzx   eax, byte [rax]                         ; 079A _ 0F B6. 00
        mov     byte [rbp-25H], al                      ; 079D _ 88. 45, DB
        cmp     byte [rbp-25H], 93                      ; 07A0 _ 80. 7D, DB, 5D
        jnz     ?_038                                   ; 07A4 _ 75, 86
        mov     rax, qword [rbp-20H]                    ; 07A6 _ 48: 8B. 45, E0
        add     rax, 1                                  ; 07AA _ 48: 83. C0, 01
        mov     rdi, rax                                ; 07AE _ 48: 89. C7
        call    nasm_skip_spaces                        ; 07B1 _ E8, 00000000(PLT r)
        mov     qword [rbp-10H], rax                    ; 07B6 _ 48: 89. 45, F0
        mov     rax, qword [rbp-10H]                    ; 07BA _ 48: 8B. 45, F0
        movzx   eax, byte [rax]                         ; 07BE _ 0F B6. 00
        test    al, al                                  ; 07C1 _ 84. C0
        jz      ?_043                                   ; 07C3 _ 74, 3D
        mov     rax, qword [rbp-10H]                    ; 07C5 _ 48: 8B. 45, F0
        movzx   eax, byte [rax]                         ; 07C9 _ 0F B6. 00
        cmp     al, 59                                  ; 07CC _ 3C, 3B
        jz      ?_043                                   ; 07CE _ 74, 32
        mov     dword [rbp-24H], 131072                 ; 07D0 _ C7. 45, DC, 00020000
        mov     eax, dword [rbp-24H]                    ; 07D7 _ 8B. 45, DC
        mov     edi, eax                                ; 07DA _ 89. C7
        call    warn_active                             ; 07DC _ E8, FFFFF915
        movzx   eax, al                                 ; 07E1 _ 0F B6. C0
        test    rax, rax                                ; 07E4 _ 48: 85. C0
        jz      ?_043                                   ; 07E7 _ 74, 19
        lea     rdx, [rel ?_151]                        ; 07E9 _ 48: 8D. 15, 00000000(rel)
        mov     eax, dword [rbp-24H]                    ; 07F0 _ 8B. 45, DC
        mov     rsi, rdx                                ; 07F3 _ 48: 89. D6
        mov     edi, eax                                ; 07F6 _ 89. C7
        mov     eax, 0                                  ; 07F8 _ B8, 00000000
        call    nasm_warn_                              ; 07FD _ E8, 00000000(PLT r)
?_043:  mov     rax, qword [rbp-20H]                    ; 0802 _ 48: 8B. 45, E0
        mov     byte [rax], 0                           ; 0806 _ C6. 00, 00
        sub     qword [rbp-20H], 1                      ; 0809 _ 48: 83. 6D, E0, 01
        mov     rax, qword [rbp-20H]                    ; 080E _ 48: 8B. 45, E0
        mov     rdi, rax                                ; 0812 _ 48: 89. C7
        call    nasm_zap_spaces_rev                     ; 0815 _ E8, 00000000(PLT r)
        add     qword [rbp-18H], 1                      ; 081A _ 48: 83. 45, E8, 01
        mov     rax, qword [rbp-18H]                    ; 081F _ 48: 8B. 45, E8
        mov     rdi, rax                                ; 0823 _ 48: 89. C7
        call    nasm_skip_spaces                        ; 0826 _ E8, 00000000(PLT r)
        mov     qword [rbp-8H], rax                     ; 082B _ 48: 89. 45, F8
        mov     rax, qword [rbp-8H]                     ; 082F _ 48: 8B. 45, F8
        mov     rdi, rax                                ; 0833 _ 48: 89. C7
        call    nasm_skip_word                          ; 0836 _ E8, 00000000(PLT r)
        mov     qword [rbp-20H], rax                    ; 083B _ 48: 89. 45, E0
        cmp     qword [rbp-20H], 0                      ; 083F _ 48: 83. 7D, E0, 00
        jnz     ?_044                                   ; 0844 _ 75, 07
        mov     eax, 2                                  ; 0846 _ B8, 00000002
        jmp     ?_045                                   ; 084B _ EB, 41

?_044:  mov     rax, qword [rbp-20H]                    ; 084D _ 48: 8B. 45, E0
        mov     byte [rax], 0                           ; 0851 _ C6. 00, 00
        mov     rax, qword [rbp-38H]                    ; 0854 _ 48: 8B. 45, C8
        mov     rdx, qword [rbp-8H]                     ; 0858 _ 48: 8B. 55, F8
        mov     qword [rax], rdx                        ; 085C _ 48: 89. 10
        add     qword [rbp-20H], 1                      ; 085F _ 48: 83. 45, E0, 01
        mov     rax, qword [rbp-20H]                    ; 0864 _ 48: 8B. 45, E0
        mov     rdi, rax                                ; 0868 _ 48: 89. C7
        call    nasm_skip_spaces                        ; 086B _ E8, 00000000(PLT r)
        mov     qword [rbp-8H], rax                     ; 0870 _ 48: 89. 45, F8
        mov     rax, qword [rbp-40H]                    ; 0874 _ 48: 8B. 45, C0
        mov     rdx, qword [rbp-8H]                     ; 0878 _ 48: 8B. 55, F8
        mov     qword [rax], rdx                        ; 087C _ 48: 89. 10
        mov     rax, qword [rbp-38H]                    ; 087F _ 48: 8B. 45, C8
        mov     rax, qword [rax]                        ; 0883 _ 48: 8B. 00
        mov     rdi, rax                                ; 0886 _ 48: 89. C7
        call    directive_find                          ; 0889 _ E8, FFFFF844
?_045:  leave                                           ; 088E _ C9
        ret                                             ; 088F _ C3

directive_valid:; Function begin
        push    rbp                                     ; 0890 _ 55
        mov     rbp, rsp                                ; 0891 _ 48: 89. E5
        sub     rsp, 32                                 ; 0894 _ 48: 83. EC, 20
        mov     qword [rbp-18H], rdi                    ; 0898 _ 48: 89. 7D, E8
        mov     rax, qword [rbp-18H]                    ; 089C _ 48: 8B. 45, E8
        mov     rdi, rax                                ; 08A0 _ 48: 89. C7
        call    directive_find                          ; 08A3 _ E8, FFFFF82A
        mov     dword [rbp-4H], eax                     ; 08A8 _ 89. 45, FC
        cmp     dword [rbp-4H], 2                       ; 08AB _ 83. 7D, FC, 02
        ja      ?_046                                   ; 08AF _ 77, 07
        mov     eax, 0                                  ; 08B1 _ B8, 00000000
        jmp     ?_049                                   ; 08B6 _ EB, 37

?_046:  cmp     dword [rbp-4H], 48                      ; 08B8 _ 83. 7D, FC, 30
        ja      ?_047                                   ; 08BC _ 77, 07
        mov     eax, 1                                  ; 08BE _ B8, 00000001
        jmp     ?_049                                   ; 08C3 _ EB, 2A

?_047:  cmp     dword [rbp-4H], 59                      ; 08C5 _ 83. 7D, FC, 3B
        ja      ?_048                                   ; 08C9 _ 77, 1F
        mov     rax, qword [rel ofmt]                   ; 08CB _ 48: 8B. 05, 00000000(rel)
        mov     rdx, qword [rax+78H]                    ; 08D2 _ 48: 8B. 50, 78
        mov     eax, dword [rbp-4H]                     ; 08D6 _ 8B. 45, FC
        mov     esi, 0                                  ; 08D9 _ BE, 00000000
        mov     edi, eax                                ; 08DE _ 89. C7
        call    rdx                                     ; 08E0 _ FF. D2
        cmp     eax, 1                                  ; 08E2 _ 83. F8, 01
        sete    al                                      ; 08E5 _ 0F 94. C0
        jmp     ?_049                                   ; 08E8 _ EB, 05

?_048:  mov     eax, 0                                  ; 08EA _ B8, 00000000
?_049:  leave                                           ; 08EF _ C9
        ret                                             ; 08F0 _ C3
; directive_valid End of function

process_directives:; Function begin
        push    rbp                                     ; 08F1 _ 55
        mov     rbp, rsp                                ; 08F2 _ 48: 89. E5
        sub     rsp, 320                                ; 08F5 _ 48: 81. EC, 00000140
        mov     qword [rbp-138H], rdi                   ; 08FC _ 48: 89. BD, FFFFFEC8
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        mov     rax, qword [fs:abs 28H]                 ; 0903 _ 64 48: 8B. 04 25, 00000028
        mov     qword [rbp-8H], rax                     ; 090C _ 48: 89. 45, F8
        xor     eax, eax                                ; 0910 _ 31. C0
        mov     byte [rbp-129H], 0                      ; 0912 _ C6. 85, FFFFFED7, 00
        lea     rdx, [rbp-110H]                         ; 0919 _ 48: 8D. 95, FFFFFEF0
        lea     rax, [rbp-138H]                         ; 0920 _ 48: 8D. 85, FFFFFEC8
        mov     rsi, rdx                                ; 0927 _ 48: 89. D6
        mov     rdi, rax                                ; 092A _ 48: 89. C7
        call    parse_directive_line                    ; 092D _ E8, FFFFFDB8
        mov     dword [rbp-11CH], eax                   ; 0932 _ 89. 85, FFFFFEE4
        cmp     dword [rbp-11CH], 29                    ; 0938 _ 83. BD, FFFFFEE4, 1D
        ja      ?_052                                   ; 093F _ 0F 87, 00000208
        cmp     dword [rbp-11CH], 21                    ; 0945 _ 83. BD, FFFFFEE4, 15
        jnc     ?_134                                   ; 094C _ 0F 83, 00000E86
        cmp     dword [rbp-11CH], 20                    ; 0952 _ 83. BD, FFFFFEE4, 14
        je      ?_107                                   ; 0959 _ 0F 84, 00000B18
        cmp     dword [rbp-11CH], 20                    ; 095F _ 83. BD, FFFFFEE4, 14
        ja      ?_052                                   ; 0966 _ 0F 87, 000001E1
        cmp     dword [rbp-11CH], 19                    ; 096C _ 83. BD, FFFFFEE4, 13
        je      ?_068                                   ; 0973 _ 0F 84, 00000483
        cmp     dword [rbp-11CH], 19                    ; 0979 _ 83. BD, FFFFFEE4, 13
        ja      ?_052                                   ; 0980 _ 0F 87, 000001C7
        cmp     dword [rbp-11CH], 18                    ; 0986 _ 83. BD, FFFFFEE4, 12
        ja      ?_052                                   ; 098D _ 0F 87, 000001BA
        cmp     dword [rbp-11CH], 17                    ; 0993 _ 83. BD, FFFFFEE4, 11
        jnc     ?_060                                   ; 099A _ 0F 83, 00000276
        cmp     dword [rbp-11CH], 16                    ; 09A0 _ 83. BD, FFFFFEE4, 10
        je      ?_062                                   ; 09A7 _ 0F 84, 000002E6
        cmp     dword [rbp-11CH], 16                    ; 09AD _ 83. BD, FFFFFEE4, 10
        ja      ?_052                                   ; 09B4 _ 0F 87, 00000193
        cmp     dword [rbp-11CH], 15                    ; 09BA _ 83. BD, FFFFFEE4, 0F
        je      ?_070                                   ; 09C1 _ 0F 84, 0000044D
        cmp     dword [rbp-11CH], 15                    ; 09C7 _ 83. BD, FFFFFEE4, 0F
        ja      ?_052                                   ; 09CE _ 0F 87, 00000179
        cmp     dword [rbp-11CH], 14                    ; 09D4 _ 83. BD, FFFFFEE4, 0E
        je      ?_133                                   ; 09DB _ 0F 84, 00000DE6
        cmp     dword [rbp-11CH], 14                    ; 09E1 _ 83. BD, FFFFFEE4, 0E
        ja      ?_052                                   ; 09E8 _ 0F 87, 0000015F
        cmp     dword [rbp-11CH], 13                    ; 09EE _ 83. BD, FFFFFEE4, 0D
        je      ?_111                                   ; 09F5 _ 0F 84, 00000B1D
        cmp     dword [rbp-11CH], 13                    ; 09FB _ 83. BD, FFFFFEE4, 0D
        ja      ?_052                                   ; 0A02 _ 0F 87, 00000145
        cmp     dword [rbp-11CH], 12                    ; 0A08 _ 83. BD, FFFFFEE4, 0C
        je      ?_067                                   ; 0A0F _ 0F 84, 000003DB
        cmp     dword [rbp-11CH], 12                    ; 0A15 _ 83. BD, FFFFFEE4, 0C
        ja      ?_052                                   ; 0A1C _ 0F 87, 0000012B
        cmp     dword [rbp-11CH], 11                    ; 0A22 _ 83. BD, FFFFFEE4, 0B
        je      ?_131                                   ; 0A29 _ 0F 84, 00000D4A
        cmp     dword [rbp-11CH], 11                    ; 0A2F _ 83. BD, FFFFFEE4, 0B
        ja      ?_052                                   ; 0A36 _ 0F 87, 00000111
        cmp     dword [rbp-11CH], 10                    ; 0A3C _ 83. BD, FFFFFEE4, 0A
        je      ?_069                                   ; 0A43 _ 0F 84, 000003BF
        cmp     dword [rbp-11CH], 10                    ; 0A49 _ 83. BD, FFFFFEE4, 0A
        ja      ?_052                                   ; 0A50 _ 0F 87, 000000F7
        cmp     dword [rbp-11CH], 9                     ; 0A56 _ 83. BD, FFFFFEE4, 09
        je      ?_132                                   ; 0A5D _ 0F 84, 00000D49
        cmp     dword [rbp-11CH], 9                     ; 0A63 _ 83. BD, FFFFFEE4, 09
        ja      ?_052                                   ; 0A6A _ 0F 87, 000000DD
        cmp     dword [rbp-11CH], 8                     ; 0A70 _ 83. BD, FFFFFEE4, 08
        je      ?_114                                   ; 0A77 _ 0F 84, 00000B0B
        cmp     dword [rbp-11CH], 8                     ; 0A7D _ 83. BD, FFFFFEE4, 08
        ja      ?_052                                   ; 0A84 _ 0F 87, 000000C3
        cmp     dword [rbp-11CH], 7                     ; 0A8A _ 83. BD, FFFFFEE4, 07
        je      ?_096                                   ; 0A91 _ 0F 84, 000007C7
        cmp     dword [rbp-11CH], 7                     ; 0A97 _ 83. BD, FFFFFEE4, 07
        ja      ?_052                                   ; 0A9E _ 0F 87, 000000A9
        cmp     dword [rbp-11CH], 6                     ; 0AA4 _ 83. BD, FFFFFEE4, 06
        je      ?_110                                   ; 0AAB _ 0F 84, 00000A53
        cmp     dword [rbp-11CH], 6                     ; 0AB1 _ 83. BD, FFFFFEE4, 06
        ja      ?_052                                   ; 0AB8 _ 0F 87, 0000008F
        cmp     dword [rbp-11CH], 5                     ; 0ABE _ 83. BD, FFFFFEE4, 05
        je      ?_071                                   ; 0AC5 _ 0F 84, 00000355
        cmp     dword [rbp-11CH], 5                     ; 0ACB _ 83. BD, FFFFFEE4, 05
        ja      ?_052                                   ; 0AD2 _ 77, 79
        cmp     dword [rbp-11CH], 4                     ; 0AD4 _ 83. BD, FFFFFEE4, 04
        je      ?_066                                   ; 0ADB _ 0F 84, 000002F5
        cmp     dword [rbp-11CH], 4                     ; 0AE1 _ 83. BD, FFFFFEE4, 04
        ja      ?_052                                   ; 0AE8 _ 77, 63
        cmp     dword [rbp-11CH], 3                     ; 0AEA _ 83. BD, FFFFFEE4, 03
        je      ?_091                                   ; 0AF1 _ 0F 84, 00000667
        cmp     dword [rbp-11CH], 3                     ; 0AF7 _ 83. BD, FFFFFEE4, 03
        ja      ?_052                                   ; 0AFE _ 77, 4D
        cmp     dword [rbp-11CH], 2                     ; 0B00 _ 83. BD, FFFFFEE4, 02
        jz      ?_051                                   ; 0B07 _ 74, 2B
        cmp     dword [rbp-11CH], 2                     ; 0B09 _ 83. BD, FFFFFEE4, 02
        ja      ?_052                                   ; 0B10 _ 77, 3B
        cmp     dword [rbp-11CH], 0                     ; 0B12 _ 83. BD, FFFFFEE4, 00
        jz      ?_050                                   ; 0B19 _ 74, 0F
        cmp     dword [rbp-11CH], 1                     ; 0B1B _ 83. BD, FFFFFEE4, 01
        je      ?_059                                   ; 0B22 _ 0F 84, 000000CB
        jmp     ?_052                                   ; 0B28 _ EB, 23

?_050:  mov     eax, 0                                  ; 0B2A _ B8, 00000000
        jmp     ?_143                                   ; 0B2F _ E9, 00000CF9

?_051:  lea     rax, [rel ?_152]                        ; 0B34 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 0B3B _ 48: 89. C7
        mov     eax, 0                                  ; 0B3E _ B8, 00000000
        call    nasm_nonfatal                           ; 0B43 _ E8, 00000000(PLT r)
        jmp     ?_141                                   ; 0B48 _ E9, 00000CB4

?_052:  cmp     dword [rbp-11CH], 49                    ; 0B4D _ 83. BD, FFFFFEE4, 31
        jbe     ?_056                                   ; 0B54 _ 76, 6D
        cmp     dword [rbp-11CH], 59                    ; 0B56 _ 83. BD, FFFFFEE4, 3B
        ja      ?_056                                   ; 0B5D _ 77, 64
        mov     rax, qword [rel ofmt]                   ; 0B5F _ 48: 8B. 05, 00000000(rel)
        mov     rcx, qword [rax+78H]                    ; 0B66 _ 48: 8B. 48, 78
        mov     rdx, qword [rbp-110H]                   ; 0B6A _ 48: 8B. 95, FFFFFEF0
        mov     eax, dword [rbp-11CH]                   ; 0B71 _ 8B. 85, FFFFFEE4
        mov     rsi, rdx                                ; 0B77 _ 48: 89. D6
        mov     edi, eax                                ; 0B7A _ 89. C7
        call    rcx                                     ; 0B7C _ FF. D1
        cmp     eax, 3                                  ; 0B7E _ 83. F8, 03
        jz      ?_053                                   ; 0B81 _ 74, 13
        cmp     eax, 3                                  ; 0B83 _ 83. F8, 03
        ja      ?_054                                   ; 0B86 _ 77, 17
        test    eax, eax                                ; 0B88 _ 85. C0
        jz      ?_057                                   ; 0B8A _ 74, 63
        sub     eax, 1                                  ; 0B8C _ 83. E8, 01
        cmp     eax, 1                                  ; 0B8F _ 83. F8, 01
        ja      ?_054                                   ; 0B92 _ 77, 0B
        jmp     ?_055                                   ; 0B94 _ EB, 27

?_053:  mov     byte [rbp-129H], 1                      ; 0B96 _ C6. 85, FFFFFED7, 01
        jmp     ?_055                                   ; 0B9D _ EB, 1E

?_054:  lea     rcx, [rel ?_153]                        ; 0B9F _ 48: 8D. 0D, 00000000(rel)
        lea     rax, [rel __func__.0]                   ; 0BA6 _ 48: 8D. 05, 00000000(rel)
        mov     edx, 304                                ; 0BAD _ BA, 00000130
        mov     rsi, rcx                                ; 0BB2 _ 48: 89. CE
        mov     rdi, rax                                ; 0BB5 _ 48: 89. C7
        call    nasm_panic_from_macro                   ; 0BB8 _ E8, 00000000(PLT r)
?_055:  nop                                             ; 0BBD _ 90
        jmp     ?_141                                   ; 0BBE _ E9, 00000C3E

?_056:  cmp     dword [rbp-11CH], 29                    ; 0BC3 _ 83. BD, FFFFFEE4, 1D
        ja      ?_058                                   ; 0BCA _ 77, 26
        mov     rax, qword [rbp-138H]                   ; 0BCC _ 48: 8B. 85, FFFFFEC8
        lea     rdx, [rel ?_154]                        ; 0BD3 _ 48: 8D. 15, 00000000(rel)
        mov     rsi, rax                                ; 0BDA _ 48: 89. C6
        mov     rdi, rdx                                ; 0BDD _ 48: 89. D7
        mov     eax, 0                                  ; 0BE0 _ B8, 00000000
        call    nasm_nonfatal                           ; 0BE5 _ E8, 00000000(PLT r)
        jmp     ?_141                                   ; 0BEA _ E9, 00000C12

?_057:  nop                                             ; 0BEF _ 90
        jmp     ?_059                                   ; 0BF0 _ EB, 01

?_058:  nop                                             ; 0BF2 _ 90
?_059:  mov     rax, qword [rbp-138H]                   ; 0BF3 _ 48: 8B. 85, FFFFFEC8
        lea     rdx, [rel ?_155]                        ; 0BFA _ 48: 8D. 15, 00000000(rel)
        mov     rsi, rax                                ; 0C01 _ 48: 89. C6
        mov     rdi, rdx                                ; 0C04 _ 48: 89. D7
        mov     eax, 0                                  ; 0C07 _ B8, 00000000
        call    nasm_nonfatal                           ; 0C0C _ E8, 00000000(PLT r)
        jmp     ?_141                                   ; 0C11 _ E9, 00000BEB

?_060:  mov     eax, dword [rel globl]                  ; 0C16 _ 8B. 05, 00000000(rel)
        mov     dword [rbp-0C0H], eax                   ; 0C1C _ 89. 85, FFFFFF40
        mov     rax, qword [rel ofmt]                   ; 0C22 _ 48: 8B. 05, 00000000(rel)
        mov     rcx, qword [rax+58H]                    ; 0C29 _ 48: 8B. 48, 58
        mov     rax, qword [rbp-110H]                   ; 0C2D _ 48: 8B. 85, FFFFFEF0
        lea     rdx, [rbp-0C0H]                         ; 0C34 _ 48: 8D. 95, FFFFFF40
        mov     rsi, rdx                                ; 0C3B _ 48: 89. D6
        mov     rdi, rax                                ; 0C3E _ 48: 89. C7
        call    rcx                                     ; 0C41 _ FF. D1
        mov     dword [rbp-118H], eax                   ; 0C43 _ 89. 85, FFFFFEE8
        cmp     dword [rbp-118H], -1                    ; 0C49 _ 83. BD, FFFFFEE8, FF
        jnz     ?_061                                   ; 0C50 _ 75, 23
        mov     rax, qword [rbp-110H]                   ; 0C52 _ 48: 8B. 85, FFFFFEF0
        lea     rdx, [rel ?_156]                        ; 0C59 _ 48: 8D. 15, 00000000(rel)
        mov     rsi, rax                                ; 0C60 _ 48: 89. C6
        mov     rdi, rdx                                ; 0C63 _ 48: 89. D7
        mov     eax, 0                                  ; 0C66 _ B8, 00000000
        call    nasm_nonfatal                           ; 0C6B _ E8, 00000000(PLT r)
        jmp     ?_141                                   ; 0C70 _ E9, 00000B8C

?_061:  mov     eax, dword [rbp-0C0H]                   ; 0C75 _ 8B. 85, FFFFFF40
        mov     dword [rel globl], eax                  ; 0C7B _ 89. 05, 00000000(rel)
        mov     eax, dword [rbp-118H]                   ; 0C81 _ 8B. 85, FFFFFEE8
        mov     edi, eax                                ; 0C87 _ 89. C7
        call    switch_segment                          ; 0C89 _ E8, 00000000(PLT r)
        jmp     ?_141                                   ; 0C8E _ E9, 00000B6E

?_062:  mov     rax, qword [rbp-110H]                   ; 0C93 _ 48: 8B. 85, FFFFFEF0
        movzx   eax, byte [rax]                         ; 0C9A _ 0F B6. 00
        test    al, al                                  ; 0C9D _ 84. C0
        je      ?_135                                   ; 0C9F _ 0F 84, 00000B4C
        mov     rax, qword [rbp-110H]                   ; 0CA5 _ 48: 8B. 85, FFFFFEF0
        mov     rdi, rax                                ; 0CAC _ 48: 89. C7
        call    stdscan_reset                           ; 0CAF _ E8, 00000000(PLT r)
        mov     dword [rbp-9CH], -1                     ; 0CB4 _ C7. 85, FFFFFF64, FFFFFFFF
        lea     rax, [rbp-0C0H]                         ; 0CBE _ 48: 8D. 85, FFFFFF40
; Note: Unusual relocation type for this operand
        mov     rdx, qword [rel stdscan+$+??]           ; 0CC5 _ 48: 8B. 15, 00000000
        mov     rdi, rdx                                ; 0CCC _ 48: 89. D7
        mov     r9d, 0                                  ; 0CCF _ 41: B9, 00000000
        mov     r8d, 1                                  ; 0CD5 _ 41: B8, 00000001
        mov     ecx, 0                                  ; 0CDB _ B9, 00000000
        mov     rdx, rax                                ; 0CE0 _ 48: 89. C2
        mov     esi, 0                                  ; 0CE3 _ BE, 00000000
        call    evaluate                                ; 0CE8 _ E8, 00000000(PLT r)
        mov     qword [rbp-0E0H], rax                   ; 0CED _ 48: 89. 85, FFFFFF20
        cmp     qword [rbp-0E0H], 0                     ; 0CF4 _ 48: 83. BD, FFFFFF20, 00
        je      ?_135                                   ; 0CFC _ 0F 84, 00000AEF
        mov     rax, qword [rbp-0E0H]                   ; 0D02 _ 48: 8B. 85, FFFFFF20
        mov     rax, qword [rax+8H]                     ; 0D09 _ 48: 8B. 40, 08
        mov     qword [rbp-0D8H], rax                   ; 0D0D _ 48: 89. 85, FFFFFF28
        mov     rax, qword [rbp-0E0H]                   ; 0D14 _ 48: 8B. 85, FFFFFF20
        mov     rax, qword [rax+8H]                     ; 0D1B _ 48: 8B. 40, 08
        test    rax, rax                                ; 0D1F _ 48: 85. C0
        jz      ?_063                                   ; 0D22 _ 74, 22
        mov     rax, qword [rbp-0E0H]                   ; 0D24 _ 48: 8B. 85, FFFFFF20
        mov     rdx, qword [rax+8H]                     ; 0D2B _ 48: 8B. 50, 08
        mov     rax, qword [rbp-0E0H]                   ; 0D2F _ 48: 8B. 85, FFFFFF20
        mov     rax, qword [rax+8H]                     ; 0D36 _ 48: 8B. 40, 08
        sub     rax, 1                                  ; 0D3A _ 48: 83. E8, 01
        and     rax, rdx                                ; 0D3E _ 48: 21. D0
        test    rax, rax                                ; 0D41 _ 48: 85. C0
        jz      ?_064                                   ; 0D44 _ 74, 20
?_063:  mov     rax, qword [rbp-110H]                   ; 0D46 _ 48: 8B. 85, FFFFFEF0
        lea     rdx, [rel ?_157]                        ; 0D4D _ 48: 8D. 15, 00000000(rel)
        mov     rsi, rax                                ; 0D54 _ 48: 89. C6
        mov     rdi, rdx                                ; 0D57 _ 48: 89. D7
        mov     eax, 0                                  ; 0D5A _ B8, 00000000
        call    nasm_nonfatal                           ; 0D5F _ E8, 00000000(PLT r)
        jmp     ?_065                                   ; 0D64 _ EB, 3C

?_064:  cmp     qword [rbp-0D8H], 2147483647            ; 0D66 _ 48: 81. BD, FFFFFF28, 7FFFFFFF
        jbe     ?_065                                   ; 0D71 _ 76, 2F
        mov     rax, qword [rbp-0D8H]                   ; 0D73 _ 48: 8B. 85, FFFFFF28
        mov     rdi, rax                                ; 0D7A _ 48: 89. C7
        call    ilog2_64                                ; 0D7D _ E8, 00000000(PLT r)
        mov     edx, eax                                ; 0D82 _ 89. C2
        mov     rax, qword [rbp-110H]                   ; 0D84 _ 48: 8B. 85, FFFFFEF0
        lea     rcx, [rel ?_158]                        ; 0D8B _ 48: 8D. 0D, 00000000(rel)
        mov     rsi, rax                                ; 0D92 _ 48: 89. C6
        mov     rdi, rcx                                ; 0D95 _ 48: 89. CF
        mov     eax, 0                                  ; 0D98 _ B8, 00000000
        call    nasm_nonfatal                           ; 0D9D _ E8, 00000000(PLT r)
?_065:  mov     eax, dword [rel location+8H]            ; 0DA2 _ 8B. 05, 00000000(rel)
        cmp     eax, -1                                 ; 0DA8 _ 83. F8, FF
        je      ?_135                                   ; 0DAB _ 0F 84, 00000A40
        mov     rax, qword [rel ofmt]                   ; 0DB1 _ 48: 8B. 05, 00000000(rel)
        mov     rdx, qword [rax+68H]                    ; 0DB8 _ 48: 8B. 50, 68
        mov     rax, qword [rbp-0D8H]                   ; 0DBC _ 48: 8B. 85, FFFFFF28
        mov     ecx, eax                                ; 0DC3 _ 89. C1
        mov     eax, dword [rel location+8H]            ; 0DC5 _ 8B. 05, 00000000(rel)
        mov     esi, ecx                                ; 0DCB _ 89. CE
        mov     edi, eax                                ; 0DCD _ 89. C7
        call    rdx                                     ; 0DCF _ FF. D2
        jmp     ?_135                                   ; 0DD1 _ E9, 00000A1B

?_066:  mov     rax, qword [rbp-110H]                   ; 0DD6 _ 48: 8B. 85, FFFFFEF0
        mov     rdi, rax                                ; 0DDD _ 48: 89. C7
        call    get_bits                                ; 0DE0 _ E8, FFFFF82A
        mov     dword [rel globl], eax                  ; 0DE5 _ 89. 05, 00000000(rel)
        jmp     ?_141                                   ; 0DEB _ E9, 00000A11

?_067:  mov     dword [rbp-124H], 2                     ; 0DF0 _ C7. 85, FFFFFEDC, 00000002
        jmp     ?_072                                   ; 0DFA _ EB, 2F

?_068:  mov     dword [rbp-124H], 1                     ; 0DFC _ C7. 85, FFFFFEDC, 00000001
        jmp     ?_072                                   ; 0E06 _ EB, 23

?_069:  mov     dword [rbp-124H], 3                     ; 0E08 _ C7. 85, FFFFFEDC, 00000003
        jmp     ?_072                                   ; 0E12 _ EB, 17

?_070:  mov     dword [rbp-124H], 4                     ; 0E14 _ C7. 85, FFFFFEDC, 00000004
        jmp     ?_072                                   ; 0E1E _ EB, 0B

?_071:  mov     dword [rbp-124H], 5                     ; 0E20 _ C7. 85, FFFFFEDC, 00000005
        nop                                             ; 0E2A _ 90
?_072:  mov     qword [rbp-0F0H], 0                     ; 0E2B _ 48: C7. 85, FFFFFF10, 00000000
        mov     rax, qword [rbp-110H]                   ; 0E36 _ 48: 8B. 85, FFFFFEF0
        mov     qword [rbp-0D0H], rax                   ; 0E3D _ 48: 89. 85, FFFFFF30
        mov     rax, qword [rbp-110H]                   ; 0E44 _ 48: 8B. 85, FFFFFEF0
        movzx   eax, byte [rax]                         ; 0E4B _ 0F B6. 00
        cmp     al, 36                                  ; 0E4E _ 3C, 24
        jnz     ?_073                                   ; 0E50 _ 75, 67
        mov     rax, qword [rbp-110H]                   ; 0E52 _ 48: 8B. 85, FFFFFEF0
        add     rax, 1                                  ; 0E59 _ 48: 83. C0, 01
        mov     qword [rbp-110H], rax                   ; 0E5D _ 48: 89. 85, FFFFFEF0
        mov     rax, qword [rbp-110H]                   ; 0E64 _ 48: 8B. 85, FFFFFEF0
        movzx   eax, byte [rax]                         ; 0E6B _ 0F B6. 00
        movsx   eax, al                                 ; 0E6E _ 0F BE. C0
        mov     edi, eax                                ; 0E71 _ 89. C7
        call    nasm_isidchar                           ; 0E73 _ E8, FFFFF1F7
        mov     byte [rbp-128H], al                     ; 0E78 _ 88. 85, FFFFFED8
        movzx   eax, byte [rel globl+0DH]               ; 0E7E _ 0F B6. 05, 00000000(rel)
        test    al, al                                  ; 0E85 _ 84. C0
        jz      ?_074                                   ; 0E87 _ 74, 4A
        mov     rax, qword [rbp-110H]                   ; 0E89 _ 48: 8B. 85, FFFFFEF0
        movzx   eax, byte [rax]                         ; 0E90 _ 0F B6. 00
        movsx   eax, al                                 ; 0E93 _ 0F BE. C0
        mov     edi, eax                                ; 0E96 _ 89. C7
        call    nasm_isnumstart                         ; 0E98 _ E8, FFFFF1F3
        xor     eax, 01H                                ; 0E9D _ 83. F0, 01
        movzx   edx, al                                 ; 0EA0 _ 0F B6. D0
        movzx   eax, byte [rbp-128H]                    ; 0EA3 _ 0F B6. 85, FFFFFED8
        and     eax, edx                                ; 0EAA _ 21. D0
        test    eax, eax                                ; 0EAC _ 85. C0
        setne   al                                      ; 0EAE _ 0F 95. C0
        mov     byte [rbp-128H], al                     ; 0EB1 _ 88. 85, FFFFFED8
        jmp     ?_074                                   ; 0EB7 _ EB, 1A

?_073:  mov     rax, qword [rbp-110H]                   ; 0EB9 _ 48: 8B. 85, FFFFFEF0
        movzx   eax, byte [rax]                         ; 0EC0 _ 0F B6. 00
        movsx   eax, al                                 ; 0EC3 _ 0F BE. C0
        mov     edi, eax                                ; 0EC6 _ 89. C7
        call    nasm_isidstart                          ; 0EC8 _ E8, FFFFF181
        mov     byte [rbp-128H], al                     ; 0ECD _ 88. 85, FFFFFED8
?_074:  mov     rax, qword [rbp-110H]                   ; 0ED3 _ 48: 8B. 85, FFFFFEF0
        mov     qword [rbp-100H], rax                   ; 0EDA _ 48: 89. 85, FFFFFF00
        cmp     byte [rbp-128H], 0                      ; 0EE1 _ 80. BD, FFFFFED8, 00
        jz      ?_078                                   ; 0EE8 _ 74, 6B
        add     qword [rbp-100H], 1                     ; 0EEA _ 48: 83. 85, FFFFFF00, 01
        jmp     ?_077                                   ; 0EF2 _ EB, 2A

?_075:  mov     rax, qword [rbp-100H]                   ; 0EF4 _ 48: 8B. 85, FFFFFF00
        movzx   eax, byte [rax]                         ; 0EFB _ 0F B6. 00
        movsx   eax, al                                 ; 0EFE _ 0F BE. C0
        mov     edi, eax                                ; 0F01 _ 89. C7
        call    nasm_isidchar                           ; 0F03 _ E8, FFFFF167
        xor     eax, 01H                                ; 0F08 _ 83. F0, 01
        test    al, al                                  ; 0F0B _ 84. C0
        jz      ?_076                                   ; 0F0D _ 74, 07
        mov     byte [rbp-128H], 0                      ; 0F0F _ C6. 85, FFFFFED8, 00
?_076:  add     qword [rbp-100H], 1                     ; 0F16 _ 48: 83. 85, FFFFFF00, 01
?_077:  mov     rax, qword [rbp-100H]                   ; 0F1E _ 48: 8B. 85, FFFFFF00
        movzx   eax, byte [rax]                         ; 0F25 _ 0F B6. 00
        test    al, al                                  ; 0F28 _ 84. C0
        jz      ?_078                                   ; 0F2A _ 74, 29
        mov     rax, qword [rbp-100H]                   ; 0F2C _ 48: 8B. 85, FFFFFF00
        movzx   eax, byte [rax]                         ; 0F33 _ 0F B6. 00
        cmp     al, 58                                  ; 0F36 _ 3C, 3A
        jz      ?_078                                   ; 0F38 _ 74, 1B
        mov     rax, qword [rbp-100H]                   ; 0F3A _ 48: 8B. 85, FFFFFF00
        movzx   eax, byte [rax]                         ; 0F41 _ 0F B6. 00
        movsx   eax, al                                 ; 0F44 _ 0F BE. C0
        mov     edi, eax                                ; 0F47 _ 89. C7
        call    nasm_isspace                            ; 0F49 _ E8, FFFFF0DF
        xor     eax, 01H                                ; 0F4E _ 83. F0, 01
        test    al, al                                  ; 0F51 _ 84. C0
        jnz     ?_075                                   ; 0F53 _ 75, 9F
?_078:  movzx   eax, byte [rbp-128H]                    ; 0F55 _ 0F B6. 85, FFFFFED8
        xor     eax, 01H                                ; 0F5C _ 83. F0, 01
        test    al, al                                  ; 0F5F _ 84. C0
        jz      ?_079                                   ; 0F61 _ 74, 2A
        mov     rax, qword [rbp-138H]                   ; 0F63 _ 48: 8B. 85, FFFFFEC8
        mov     rdx, qword [rbp-0D0H]                   ; 0F6A _ 48: 8B. 95, FFFFFF30
        lea     rcx, [rel ?_159]                        ; 0F71 _ 48: 8D. 0D, 00000000(rel)
        mov     rsi, rax                                ; 0F78 _ 48: 89. C6
        mov     rdi, rcx                                ; 0F7B _ 48: 89. CF
        mov     eax, 0                                  ; 0F7E _ B8, 00000000
        call    nasm_nonfatal                           ; 0F83 _ E8, 00000000(PLT r)
        jmp     ?_141                                   ; 0F88 _ E9, 00000874

?_079:  mov     rax, qword [rbp-100H]                   ; 0F8D _ 48: 8B. 85, FFFFFF00
        movzx   eax, byte [rax]                         ; 0F94 _ 0F B6. 00
        movsx   eax, al                                 ; 0F97 _ 0F BE. C0
        mov     edi, eax                                ; 0F9A _ 89. C7
        call    nasm_isspace                            ; 0F9C _ E8, FFFFF08C
        test    al, al                                  ; 0FA1 _ 84. C0
        jz      ?_080                                   ; 0FA3 _ 74, 56
        mov     rax, qword [rbp-100H]                   ; 0FA5 _ 48: 8B. 85, FFFFFF00
        lea     rdx, [rax+1H]                           ; 0FAC _ 48: 8D. 50, 01
        mov     qword [rbp-100H], rdx                   ; 0FB0 _ 48: 89. 95, FFFFFF00
        mov     byte [rax], 0                           ; 0FB7 _ C6. 00, 00
        mov     rax, qword [rbp-100H]                   ; 0FBA _ 48: 8B. 85, FFFFFF00
        mov     rdi, rax                                ; 0FC1 _ 48: 89. C7
        call    nasm_skip_spaces                        ; 0FC4 _ E8, 00000000(PLT r)
        mov     qword [rbp-100H], rax                   ; 0FC9 _ 48: 89. 85, FFFFFF00
        mov     rax, qword [rbp-100H]                   ; 0FD0 _ 48: 8B. 85, FFFFFF00
        mov     qword [rbp-0E8H], rax                   ; 0FD7 _ 48: 89. 85, FFFFFF18
        mov     rax, qword [rbp-100H]                   ; 0FDE _ 48: 8B. 85, FFFFFF00
        mov     esi, 58                                 ; 0FE5 _ BE, 0000003A
        mov     rdi, rax                                ; 0FEA _ 48: 89. C7
        call    strchr                                  ; 0FED _ E8, 00000000(PLT r)
        mov     qword [rbp-100H], rax                   ; 0FF2 _ 48: 89. 85, FFFFFF00
        jmp     ?_081                                   ; 0FF9 _ EB, 0B

?_080:  mov     qword [rbp-0E8H], 0                     ; 0FFB _ 48: C7. 85, FFFFFF18, 00000000
?_081:  cmp     qword [rbp-100H], 0                     ; 1006 _ 48: 83. BD, FFFFFF00, 00
        jz      ?_082                                   ; 100E _ 74, 33
        mov     rax, qword [rbp-100H]                   ; 1010 _ 48: 8B. 85, FFFFFF00
        movzx   eax, byte [rax]                         ; 1017 _ 0F B6. 00
        cmp     al, 58                                  ; 101A _ 3C, 3A
        jnz     ?_082                                   ; 101C _ 75, 25
        mov     rax, qword [rbp-100H]                   ; 101E _ 48: 8B. 85, FFFFFF00
        lea     rdx, [rax+1H]                           ; 1025 _ 48: 8D. 50, 01
        mov     qword [rbp-100H], rdx                   ; 1029 _ 48: 89. 95, FFFFFF00
        mov     byte [rax], 0                           ; 1030 _ C6. 00, 00
        mov     rax, qword [rbp-100H]                   ; 1033 _ 48: 8B. 85, FFFFFF00
        mov     qword [rbp-0F8H], rax                   ; 103A _ 48: 89. 85, FFFFFF08
        jmp     ?_083                                   ; 1041 _ EB, 0B

?_082:  mov     qword [rbp-0F8H], 0                     ; 1043 _ 48: C7. 85, FFFFFF08, 00000000
?_083:  cmp     dword [rbp-124H], 5                     ; 104E _ 83. BD, FFFFFEDC, 05
        jnz     ?_088                                   ; 1055 _ 75, 72
        cmp     qword [rbp-0E8H], 0                     ; 1057 _ 48: 83. BD, FFFFFF18, 00
        jz      ?_084                                   ; 105F _ 74, 20
        lea     rdx, [rbp-0C0H]                         ; 1061 _ 48: 8D. 95, FFFFFF40
        mov     rax, qword [rbp-0E8H]                   ; 1068 _ 48: 8B. 85, FFFFFF18
        mov     rsi, rdx                                ; 106F _ 48: 89. D6
        mov     rdi, rax                                ; 1072 _ 48: 89. C7
        call    readnum                                 ; 1075 _ E8, 00000000(PLT r)
        mov     qword [rbp-0F0H], rax                   ; 107A _ 48: 89. 85, FFFFFF10
?_084:  cmp     qword [rbp-0E8H], 0                     ; 1081 _ 48: 83. BD, FFFFFF18, 00
        jz      ?_085                                   ; 1089 _ 74, 0B
        movzx   eax, byte [rbp-0C0H]                    ; 108B _ 0F B6. 85, FFFFFF40
        test    al, al                                  ; 1092 _ 84. C0
        jz      ?_089                                   ; 1094 _ 74, 5B
?_085:  cmp     qword [rbp-0E8H], 0                     ; 1096 _ 48: 83. BD, FFFFFF18, 00
        jz      ?_086                                   ; 109E _ 74, 09
        lea     rax, [rel ?_160]                        ; 10A0 _ 48: 8D. 05, 00000000(rel)
        jmp     ?_087                                   ; 10A7 _ EB, 07

?_086:  lea     rax, [rel ?_146]                        ; 10A9 _ 48: 8D. 05, 00000000(rel)
?_087:  lea     rdx, [rel ?_161]                        ; 10B0 _ 48: 8D. 15, 00000000(rel)
        mov     rsi, rax                                ; 10B7 _ 48: 89. C6
        mov     rdi, rdx                                ; 10BA _ 48: 89. D7
        mov     eax, 0                                  ; 10BD _ B8, 00000000
        call    nasm_nonfatal                           ; 10C2 _ E8, 00000000(PLT r)
        jmp     ?_089                                   ; 10C7 _ EB, 28

?_088:  cmp     qword [rbp-0E8H], 0                     ; 10C9 _ 48: 83. BD, FFFFFF18, 00
        jz      ?_089                                   ; 10D1 _ 74, 1E
        mov     rax, qword [rbp-138H]                   ; 10D3 _ 48: 8B. 85, FFFFFEC8
        lea     rdx, [rel ?_162]                        ; 10DA _ 48: 8D. 15, 00000000(rel)
        mov     rsi, rax                                ; 10E1 _ 48: 89. C6
        mov     rdi, rdx                                ; 10E4 _ 48: 89. D7
        mov     eax, 0                                  ; 10E7 _ B8, 00000000
        call    nasm_nonfatal                           ; 10EC _ E8, 00000000(PLT r)
?_089:  mov     rax, qword [rbp-110H]                   ; 10F1 _ 48: 8B. 85, FFFFFEF0
        mov     rdx, qword [rbp-0F8H]                   ; 10F8 _ 48: 8B. 95, FFFFFF08
        mov     ecx, dword [rbp-124H]                   ; 10FF _ 8B. 8D, FFFFFEDC
        mov     esi, ecx                                ; 1105 _ 89. CE
        mov     rdi, rax                                ; 1107 _ 48: 89. C7
        call    declare_label                           ; 110A _ E8, 00000000(PLT r)
        xor     eax, 01H                                ; 110F _ 83. F0, 01
        test    al, al                                  ; 1112 _ 84. C0
        jne     ?_136                                   ; 1114 _ 0F 85, 000006DA
        cmp     dword [rbp-124H], 5                     ; 111A _ 83. BD, FFFFFEDC, 05
        jz      ?_090                                   ; 1121 _ 74, 16
        cmp     dword [rbp-124H], 3                     ; 1123 _ 83. BD, FFFFFEDC, 03
        jz      ?_090                                   ; 112A _ 74, 0D
        cmp     dword [rbp-124H], 4                     ; 112C _ 83. BD, FFFFFEDC, 04
        jne     ?_137                                   ; 1133 _ 0F 85, 000006BE
?_090:  mov     rax, qword [rbp-110H]                   ; 1139 _ 48: 8B. 85, FFFFFEF0
        mov     rdx, qword [rbp-0F0H]                   ; 1140 _ 48: 8B. 95, FFFFFF10
        mov     ecx, 0                                  ; 1147 _ B9, 00000000
        mov     esi, 0                                  ; 114C _ BE, 00000000
        mov     rdi, rax                                ; 1151 _ 48: 89. C7
        call    define_label                            ; 1154 _ E8, 00000000(PLT r)
        jmp     ?_137                                   ; 1159 _ E9, 00000699

?_091:  mov     rax, qword [rbp-110H]                   ; 115E _ 48: 8B. 85, FFFFFEF0
        mov     rdi, rax                                ; 1165 _ 48: 89. C7
        call    stdscan_reset                           ; 1168 _ E8, 00000000(PLT r)
        mov     dword [rbp-9CH], -1                     ; 116D _ C7. 85, FFFFFF64, FFFFFFFF
        lea     rax, [rbp-0C0H]                         ; 1177 _ 48: 8D. 85, FFFFFF40
; Note: Unusual relocation type for this operand
        mov     rdx, qword [rel stdscan+$+??]           ; 117E _ 48: 8B. 15, 00000000
        mov     rdi, rdx                                ; 1185 _ 48: 89. D7
        mov     r9d, 0                                  ; 1188 _ 41: B9, 00000000
        mov     r8d, 1                                  ; 118E _ 41: B8, 00000001
        mov     ecx, 0                                  ; 1194 _ B9, 00000000
        mov     rdx, rax                                ; 1199 _ 48: 89. C2
        mov     esi, 0                                  ; 119C _ BE, 00000000
        call    evaluate                                ; 11A1 _ E8, 00000000(PLT r)
        mov     qword [rbp-0C8H], rax                   ; 11A6 _ 48: 89. 85, FFFFFF38
        cmp     qword [rbp-0C8H], 0                     ; 11AD _ 48: 83. BD, FFFFFF38, 00
        jz      ?_093                                   ; 11B5 _ 74, 59
        mov     rax, qword [rbp-0C8H]                   ; 11B7 _ 48: 8B. 85, FFFFFF38
        mov     rdi, rax                                ; 11BE _ 48: 89. C7
        call    is_reloc                                ; 11C1 _ E8, 00000000(PLT r)
        xor     eax, 01H                                ; 11C6 _ 83. F0, 01
        test    al, al                                  ; 11C9 _ 84. C0
        jz      ?_092                                   ; 11CB _ 74, 16
        lea     rax, [rel ?_163]                        ; 11CD _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 11D4 _ 48: 89. C7
        mov     eax, 0                                  ; 11D7 _ B8, 00000000
        call    nasm_nonfatal                           ; 11DC _ E8, 00000000(PLT r)
        jmp     ?_095                                   ; 11E1 _ EB, 57

?_092:  mov     rax, qword [rbp-0C8H]                   ; 11E3 _ 48: 8B. 85, FFFFFF38
        mov     rdi, rax                                ; 11EA _ 48: 89. C7
        call    reloc_seg                               ; 11ED _ E8, 00000000(PLT r)
        mov     dword [rel absolute+8H], eax            ; 11F2 _ 89. 05, 00000000(rel)
        mov     rax, qword [rbp-0C8H]                   ; 11F8 _ 48: 8B. 85, FFFFFF38
        mov     rdi, rax                                ; 11FF _ 48: 89. C7
        call    reloc_value                             ; 1202 _ E8, 00000000(PLT r)
        mov     qword [rel absolute], rax               ; 1207 _ 48: 89. 05, 00000000(rel)
        jmp     ?_095                                   ; 120E _ EB, 2A

?_093:  call    pass_first                              ; 1210 _ E8, FFFFEF20
        test    al, al                                  ; 1215 _ 84. C0
        jz      ?_094                                   ; 1217 _ 74, 0D
        mov     qword [rel absolute], 256               ; 1219 _ 48: C7. 05, 00000000(rel), 00000100
        jmp     ?_095                                   ; 1224 _ EB, 14

?_094:  lea     rax, [rel ?_164]                        ; 1226 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 122D _ 48: 89. C7
        mov     eax, 0                                  ; 1230 _ B8, 00000000
        call    nasm_nonfatal                           ; 1235 _ E8, 00000000(PLT r)
?_095:  mov     byte [rel in_absolute], 1               ; 123A _ C6. 05, 00000000(rel), 01
        mov     dword [rel location+8H], -1             ; 1241 _ C7. 05, 00000000(rel), FFFFFFFF
        mov     rax, qword [rel absolute]               ; 124B _ 48: 8B. 05, 00000000(rel)
        mov     qword [rel location], rax               ; 1252 _ 48: 89. 05, 00000000(rel)
        jmp     ?_141                                   ; 1259 _ E9, 000005A3

?_096:  mov     rax, qword [rbp-110H]                   ; 125E _ 48: 8B. 85, FFFFFEF0
        mov     qword [rbp-108H], rax                   ; 1265 _ 48: 89. 85, FFFFFEF8
        lea     rax, [rbp-90H]                          ; 126C _ 48: 8D. 85, FFFFFF70
        mov     qword [rbp-100H], rax                   ; 1273 _ 48: 89. 85, FFFFFF00
        mov     byte [rbp-126H], 0                      ; 127A _ C6. 85, FFFFFEDA, 00
        movzx   eax, byte [rbp-126H]                    ; 1281 _ 0F B6. 85, FFFFFEDA
        mov     byte [rbp-127H], al                     ; 1288 _ 88. 85, FFFFFED9
        mov     rax, qword [rbp-108H]                   ; 128E _ 48: 8B. 85, FFFFFEF8
        movzx   eax, byte [rax]                         ; 1295 _ 0F B6. 00
        cmp     al, 36                                  ; 1298 _ 3C, 24
        jnz     ?_097                                   ; 129A _ 75, 6C
        add     qword [rbp-108H], 1                     ; 129C _ 48: 83. 85, FFFFFEF8, 01
        mov     rax, qword [rbp-108H]                   ; 12A4 _ 48: 8B. 85, FFFFFEF8
        movzx   eax, byte [rax]                         ; 12AB _ 0F B6. 00
        movsx   eax, al                                 ; 12AE _ 0F BE. C0
        mov     edi, eax                                ; 12B1 _ 89. C7
        call    nasm_isidchar                           ; 12B3 _ E8, FFFFEDB7
        movzx   eax, al                                 ; 12B8 _ 0F B6. C0
        test    eax, eax                                ; 12BB _ 85. C0
        setne   al                                      ; 12BD _ 0F 95. C0
        xor     eax, 01H                                ; 12C0 _ 83. F0, 01
        movzx   eax, al                                 ; 12C3 _ 0F B6. C0
        mov     byte [rbp-127H], al                     ; 12C6 _ 88. 85, FFFFFED9
        and     byte [rbp-127H], 01H                    ; 12CC _ 80. A5, FFFFFED9, 01
        movzx   eax, byte [rel globl+0DH]               ; 12D3 _ 0F B6. 05, 00000000(rel)
        test    al, al                                  ; 12DA _ 84. C0
        jz      ?_098                                   ; 12DC _ 74, 59
        mov     rax, qword [rbp-108H]                   ; 12DE _ 48: 8B. 85, FFFFFEF8
        movzx   eax, byte [rax]                         ; 12E5 _ 0F B6. 00
        movsx   eax, al                                 ; 12E8 _ 0F BE. C0
        mov     edi, eax                                ; 12EB _ 89. C7
        call    nasm_isnumchar                          ; 12ED _ E8, FFFFEDBF
        or      al, byte [rbp-127H]                     ; 12F2 _ 0A. 85, FFFFFED9
        movzx   eax, al                                 ; 12F8 _ 0F B6. C0
        test    eax, eax                                ; 12FB _ 85. C0
        setne   al                                      ; 12FD _ 0F 95. C0
        mov     byte [rbp-127H], al                     ; 1300 _ 88. 85, FFFFFED9
        jmp     ?_098                                   ; 1306 _ EB, 2F

?_097:  mov     rax, qword [rbp-108H]                   ; 1308 _ 48: 8B. 85, FFFFFEF8
        movzx   eax, byte [rax]                         ; 130F _ 0F B6. 00
        movsx   eax, al                                 ; 1312 _ 0F BE. C0
        mov     edi, eax                                ; 1315 _ 89. C7
        call    nasm_isidstart                          ; 1317 _ E8, FFFFED32
        movzx   eax, al                                 ; 131C _ 0F B6. C0
        test    eax, eax                                ; 131F _ 85. C0
        setne   al                                      ; 1321 _ 0F 95. C0
        xor     eax, 01H                                ; 1324 _ 83. F0, 01
        movzx   eax, al                                 ; 1327 _ 0F B6. C0
        mov     byte [rbp-127H], al                     ; 132A _ 88. 85, FFFFFED9
        and     byte [rbp-127H], 01H                    ; 1330 _ 80. A5, FFFFFED9, 01
?_098:  movzx   eax, byte [rbp-127H]                    ; 1337 _ 0F B6. 85, FFFFFED9
        xor     eax, 01H                                ; 133E _ 83. F0, 01
        test    al, al                                  ; 1341 _ 84. C0
        je      ?_104                                   ; 1343 _ 0F 84, 000000A1
        jmp     ?_102                                   ; 1349 _ EB, 68

?_099:  lea     rax, [rbp-90H]                          ; 134B _ 48: 8D. 85, FFFFFF70
        add     rax, 127                                ; 1352 _ 48: 83. C0, 7F
        cmp     qword [rbp-100H], rax                   ; 1356 _ 48: 39. 85, FFFFFF00
        jc      ?_100                                   ; 135D _ 72, 09
        mov     byte [rbp-126H], 1                      ; 135F _ C6. 85, FFFFFEDA, 01
        jmp     ?_103                                   ; 1366 _ EB, 78

?_100:  mov     rax, qword [rbp-108H]                   ; 1368 _ 48: 8B. 85, FFFFFEF8
        movzx   eax, byte [rax]                         ; 136F _ 0F B6. 00
        movsx   eax, al                                 ; 1372 _ 0F BE. C0
        mov     edi, eax                                ; 1375 _ 89. C7
        call    nasm_isidchar                           ; 1377 _ E8, FFFFECF3
        xor     eax, 01H                                ; 137C _ 83. F0, 01
        test    al, al                                  ; 137F _ 84. C0
        jz      ?_101                                   ; 1381 _ 74, 07
        mov     byte [rbp-127H], 1                      ; 1383 _ C6. 85, FFFFFED9, 01
?_101:  mov     rdx, qword [rbp-108H]                   ; 138A _ 48: 8B. 95, FFFFFEF8
        lea     rax, [rdx+1H]                           ; 1391 _ 48: 8D. 42, 01
        mov     qword [rbp-108H], rax                   ; 1395 _ 48: 89. 85, FFFFFEF8
        mov     rax, qword [rbp-100H]                   ; 139C _ 48: 8B. 85, FFFFFF00
        lea     rcx, [rax+1H]                           ; 13A3 _ 48: 8D. 48, 01
        mov     qword [rbp-100H], rcx                   ; 13A7 _ 48: 89. 8D, FFFFFF00
        movzx   edx, byte [rdx]                         ; 13AE _ 0F B6. 12
        mov     byte [rax], dl                          ; 13B1 _ 88. 10
?_102:  mov     rax, qword [rbp-108H]                   ; 13B3 _ 48: 8B. 85, FFFFFEF8
        movzx   eax, byte [rax]                         ; 13BA _ 0F B6. 00
        test    al, al                                  ; 13BD _ 84. C0
        jz      ?_103                                   ; 13BF _ 74, 1F
        mov     rax, qword [rbp-108H]                   ; 13C1 _ 48: 8B. 85, FFFFFEF8
        movzx   eax, byte [rax]                         ; 13C8 _ 0F B6. 00
        movsx   eax, al                                 ; 13CB _ 0F BE. C0
        mov     edi, eax                                ; 13CE _ 89. C7
        call    nasm_isspace                            ; 13D0 _ E8, FFFFEC58
        xor     eax, 01H                                ; 13D5 _ 83. F0, 01
        test    al, al                                  ; 13D8 _ 84. C0
        jne     ?_099                                   ; 13DA _ 0F 85, FFFFFF6B
?_103:  mov     rax, qword [rbp-100H]                   ; 13E0 _ 48: 8B. 85, FFFFFF00
        mov     byte [rax], 0                           ; 13E7 _ C6. 00, 00
?_104:  cmp     byte [rbp-127H], 0                      ; 13EA _ 80. BD, FFFFFED9, 00
        jz      ?_105                                   ; 13F1 _ 74, 19
        lea     rax, [rel ?_165]                        ; 13F3 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 13FA _ 48: 89. C7
        mov     eax, 0                                  ; 13FD _ B8, 00000000
        call    nasm_nonfatal                           ; 1402 _ E8, 00000000(PLT r)
        jmp     ?_141                                   ; 1407 _ E9, 000003F5

?_105:  cmp     byte [rbp-126H], 0                      ; 140C _ 80. BD, FFFFFEDA, 00
        jz      ?_106                                   ; 1413 _ 74, 19
        lea     rax, [rel ?_166]                        ; 1415 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 141C _ 48: 89. C7
        mov     eax, 0                                  ; 141F _ B8, 00000000
        call    nasm_nonfatal                           ; 1424 _ E8, 00000000(PLT r)
        jmp     ?_141                                   ; 1429 _ E9, 000003D3

?_106:  mov     rax, qword [rbp-108H]                   ; 142E _ 48: 8B. 85, FFFFFEF8
        mov     rdi, rax                                ; 1435 _ 48: 89. C7
        call    nasm_skip_spaces                        ; 1438 _ E8, 00000000(PLT r)
        mov     qword [rbp-108H], rax                   ; 143D _ 48: 89. 85, FFFFFEF8
        call    pass_final                              ; 1444 _ E8, FFFFECFD
        test    al, al                                  ; 1449 _ 84. C0
        je      ?_138                                   ; 144B _ 0F 84, 000003A9
        mov     rax, qword [rel dfmt]                   ; 1451 _ 48: 8B. 05, 00000000(rel)
        mov     rcx, qword [rax+40H]                    ; 1458 _ 48: 8B. 48, 40
        mov     rdx, qword [rbp-108H]                   ; 145C _ 48: 8B. 95, FFFFFEF8
        lea     rax, [rbp-90H]                          ; 1463 _ 48: 8D. 85, FFFFFF70
        mov     rsi, rdx                                ; 146A _ 48: 89. D6
        mov     rdi, rax                                ; 146D _ 48: 89. C7
        call    rcx                                     ; 1470 _ FF. D1
        jmp     ?_138                                   ; 1472 _ E9, 00000383

?_107:  mov     rax, qword [rbp-110H]                   ; 1477 _ 48: 8B. 85, FFFFFEF0
        mov     rdi, rax                                ; 147E _ 48: 89. C7
        call    nasm_skip_spaces                        ; 1481 _ E8, 00000000(PLT r)
        mov     qword [rbp-110H], rax                   ; 1486 _ 48: 89. 85, FFFFFEF0
        mov     rax, qword [rbp-110H]                   ; 148D _ 48: 8B. 85, FFFFFEF0
        movzx   eax, byte [rax]                         ; 1494 _ 0F B6. 00
        or      eax, 20H                                ; 1497 _ 83. C8, 20
        cmp     al, 112                                 ; 149A _ 3C, 70
        jnz     ?_109                                   ; 149C _ 75, 52
        mov     rax, qword [rbp-110H]                   ; 149E _ 48: 8B. 85, FFFFFEF0
        lea     rdx, [rel ?_167]                        ; 14A5 _ 48: 8D. 15, 00000000(rel)
        mov     rsi, rdx                                ; 14AC _ 48: 89. D6
        mov     rdi, rax                                ; 14AF _ 48: 89. C7
        call    strcasecmp                              ; 14B2 _ E8, 00000000(PLT r)
        test    eax, eax                                ; 14B7 _ 85. C0
        jnz     ?_108                                   ; 14B9 _ 75, 0A
        call    push_warnings                           ; 14BB _ E8, 00000000(PLT r)
        jmp     ?_139                                   ; 14C0 _ E9, 00000338

?_108:  mov     rax, qword [rbp-110H]                   ; 14C5 _ 48: 8B. 85, FFFFFEF0
        lea     rdx, [rel ?_168]                        ; 14CC _ 48: 8D. 15, 00000000(rel)
        mov     rsi, rdx                                ; 14D3 _ 48: 89. D6
        mov     rdi, rax                                ; 14D6 _ 48: 89. C7
        call    strcasecmp                              ; 14D9 _ E8, 00000000(PLT r)
        test    eax, eax                                ; 14DE _ 85. C0
        jne     ?_139                                   ; 14E0 _ 0F 85, 00000317
        call    pop_warnings                            ; 14E6 _ E8, 00000000(PLT r)
        jmp     ?_139                                   ; 14EB _ E9, 0000030D

?_109:  mov     rax, qword [rbp-110H]                   ; 14F0 _ 48: 8B. 85, FFFFFEF0
        mov     rdi, rax                                ; 14F7 _ 48: 89. C7
        call    set_warning_status                      ; 14FA _ E8, 00000000(PLT r)
        jmp     ?_139                                   ; 14FF _ E9, 000002F9

?_110:  mov     rax, qword [rbp-110H]                   ; 1504 _ 48: 8B. 85, FFFFFEF0
        mov     rdi, rax                                ; 150B _ 48: 89. C7
        call    set_cpu                                 ; 150E _ E8, 00000000(PLT r)
        jmp     ?_141                                   ; 1513 _ E9, 000002E9

?_111:  mov     rax, qword [rbp-110H]                   ; 1518 _ 48: 8B. 85, FFFFFEF0
        mov     rdi, rax                                ; 151F _ 48: 89. C7
        call    nasm_skip_spaces                        ; 1522 _ E8, 00000000(PLT r)
        mov     qword [rbp-110H], rax                   ; 1527 _ 48: 89. 85, FFFFFEF0
        mov     rax, qword [rbp-110H]                   ; 152E _ 48: 8B. 85, FFFFFEF0
        movzx   eax, byte [rax]                         ; 1535 _ 0F B6. 00
        cmp     al, 43                                  ; 1538 _ 3C, 2B
        jnz     ?_112                                   ; 153A _ 75, 0C
        mov     byte [rel user_nolist], 0               ; 153C _ C6. 05, 00000000(rel), 00
        jmp     ?_141                                   ; 1543 _ E9, 000002B9

?_112:  mov     rax, qword [rbp-110H]                   ; 1548 _ 48: 8B. 85, FFFFFEF0
        movzx   eax, byte [rax]                         ; 154F _ 0F B6. 00
        cmp     al, 45                                  ; 1552 _ 3C, 2D
        jnz     ?_113                                   ; 1554 _ 75, 26
        mov     edi, 70                                 ; 1556 _ BF, 00000046
        call    list_option                             ; 155B _ E8, FFFFED9B
        movzx   eax, al                                 ; 1560 _ 0F B6. C0
        test    eax, eax                                ; 1563 _ 85. C0
        setne   al                                      ; 1565 _ 0F 95. C0
        xor     eax, 01H                                ; 1568 _ 83. F0, 01
        movzx   eax, al                                 ; 156B _ 0F B6. C0
        and     eax, 01H                                ; 156E _ 83. E0, 01
        mov     byte [rel user_nolist], al              ; 1571 _ 88. 05, 00000000(rel)
        jmp     ?_141                                   ; 1577 _ E9, 00000285

?_113:  mov     byte [rbp-129H], 1                      ; 157C _ C6. 85, FFFFFED7, 01
        jmp     ?_141                                   ; 1583 _ E9, 00000279

?_114:  mov     dword [rbp-120H], 128                   ; 1588 _ C7. 85, FFFFFEE0, 00000080
        mov     byte [rbp-125H], 0                      ; 1592 _ C6. 85, FFFFFEDB, 00
        mov     rax, qword [rbp-110H]                   ; 1599 _ 48: 8B. 85, FFFFFEF0
        mov     rdi, rax                                ; 15A0 _ 48: 89. C7
        call    stdscan_reset                           ; 15A3 _ E8, 00000000(PLT r)
        mov     dword [rbp-9CH], -1                     ; 15A8 _ C7. 85, FFFFFF64, FFFFFFFF
        jmp     ?_129                                   ; 15B2 _ E9, 000001A5

?_115:  lea     rax, [rbp-0C0H]                         ; 15B7 _ 48: 8D. 85, FFFFFF40
        mov     rsi, rax                                ; 15BE _ 48: 89. C6
        mov     edi, 0                                  ; 15C1 _ BF, 00000000
        call    stdscan                                 ; 15C6 _ E8, 00000000(PLT r)
        mov     dword [rbp-114H], eax                   ; 15CB _ 89. 85, FFFFFEEC
        cmp     dword [rbp-114H], 0                     ; 15D1 _ 83. BD, FFFFFEEC, 00
        jle     ?_130                                   ; 15D8 _ 0F 8E, 00000195
        mov     eax, dword [rbp-9CH]                    ; 15DE _ 8B. 85, FFFFFF64
        cmp     eax, 292                                ; 15E4 _ 3D, 00000124
        jz      ?_116                                   ; 15E9 _ 74, 34
        cmp     eax, 292                                ; 15EB _ 3D, 00000124
        jg      ?_126                                   ; 15F0 _ 0F 8F, 0000014B
        cmp     eax, 290                                ; 15F6 _ 3D, 00000122
        jg      ?_126                                   ; 15FB _ 0F 8F, 00000140
        cmp     eax, 289                                ; 1601 _ 3D, 00000121
        jge     ?_116                                   ; 1606 _ 7D, 17
        cmp     eax, 44                                 ; 1608 _ 83. F8, 2C
        je      ?_127                                   ; 160B _ 0F 84, 00000139
        cmp     eax, 58                                 ; 1611 _ 83. F8, 3A
        je      ?_125                                   ; 1614 _ 0F 84, 00000115
        jmp     ?_126                                   ; 161A _ E9, 00000122

?_116:  mov     rax, qword [rbp-0C0H]                   ; 161F _ 48: 8B. 85, FFFFFF40
        cmp     rax, 387                                ; 1626 _ 48: 3D, 00000183
        je      ?_119                                   ; 162C _ 0F 84, 00000091
        cmp     rax, 387                                ; 1632 _ 48: 3D, 00000183
        jg      ?_123                                   ; 1638 _ 0F 8F, 000000E7
        cmp     rax, 383                                ; 163E _ 48: 3D, 0000017F
        je      ?_120                                   ; 1644 _ 0F 84, 0000009F
        cmp     rax, 383                                ; 164A _ 48: 3D, 0000017F
        jg      ?_123                                   ; 1650 _ 0F 8F, 000000CF
        cmp     rax, 363                                ; 1656 _ 48: 3D, 0000016B
        je      ?_122                                   ; 165C _ 0F 84, 000000BA
        cmp     rax, 363                                ; 1662 _ 48: 3D, 0000016B
        jg      ?_123                                   ; 1668 _ 0F 8F, 000000B7
        cmp     rax, 362                                ; 166E _ 48: 3D, 0000016A
        je      ?_121                                   ; 1674 _ 0F 84, 00000099
        cmp     rax, 362                                ; 167A _ 48: 3D, 0000016A
        jg      ?_123                                   ; 1680 _ 0F 8F, 0000009F
        cmp     rax, 96                                 ; 1686 _ 48: 83. F8, 60
        jz      ?_117                                   ; 168A _ 74, 0B
        cmp     rax, 97                                 ; 168C _ 48: 83. F8, 61
        jz      ?_118                                   ; 1690 _ 74, 1B
        jmp     ?_123                                   ; 1692 _ E9, 0000008E

?_117:  mov     dword [rbp-120H], 256                   ; 1697 _ C7. 85, FFFFFEE0, 00000100
        mov     byte [rbp-125H], 1                      ; 16A1 _ C6. 85, FFFFFEDB, 01
        jmp     ?_129                                   ; 16A8 _ E9, 000000AF

?_118:  mov     dword [rbp-120H], 512                   ; 16AD _ C7. 85, FFFFFEE0, 00000200
        mov     byte [rbp-125H], 1                      ; 16B7 _ C6. 85, FFFFFEDB, 01
        jmp     ?_129                                   ; 16BE _ E9, 00000099

?_119:  mov     eax, dword [rel globl+4H]               ; 16C3 _ 8B. 05, 00000000(rel)
        or      eax, dword [rbp-120H]                   ; 16C9 _ 0B. 85, FFFFFEE0
        mov     dword [rel globl+4H], eax               ; 16CF _ 89. 05, 00000000(rel)
        mov     eax, dword [rel globl+8H]               ; 16D5 _ 8B. 05, 00000000(rel)
        or      eax, dword [rbp-120H]                   ; 16DB _ 0B. 85, FFFFFEE0
        mov     dword [rel globl+8H], eax               ; 16E1 _ 89. 05, 00000000(rel)
        jmp     ?_124                                   ; 16E7 _ EB, 44

?_120:  mov     eax, dword [rel globl+4H]               ; 16E9 _ 8B. 05, 00000000(rel)
        mov     edx, dword [rbp-120H]                   ; 16EF _ 8B. 95, FFFFFEE0
        not     edx                                     ; 16F5 _ F7. D2
        and     eax, edx                                ; 16F7 _ 21. D0
        mov     dword [rel globl+4H], eax               ; 16F9 _ 89. 05, 00000000(rel)
        mov     eax, dword [rel globl+8H]               ; 16FF _ 8B. 05, 00000000(rel)
        or      eax, dword [rbp-120H]                   ; 1705 _ 0B. 85, FFFFFEE0
        mov     dword [rel globl+8H], eax               ; 170B _ 89. 05, 00000000(rel)
        jmp     ?_124                                   ; 1711 _ EB, 1A

?_121:  mov     byte [rel globl+0CH], 1                 ; 1713 _ C6. 05, 00000000(rel), 01
        jmp     ?_124                                   ; 171A _ EB, 11

?_122:  mov     byte [rel globl+0CH], 0                 ; 171C _ C6. 05, 00000000(rel), 00
        jmp     ?_124                                   ; 1723 _ EB, 08

?_123:  mov     byte [rbp-129H], 1                      ; 1725 _ C6. 85, FFFFFED7, 01
        nop                                             ; 172C _ 90
?_124:  jmp     ?_128                                   ; 172D _ EB, 1C

?_125:  cmp     byte [rbp-125H], 0                      ; 172F _ 80. BD, FFFFFEDB, 00
        jz      ?_126                                   ; 1736 _ 74, 09
        mov     byte [rbp-125H], 0                      ; 1738 _ C6. 85, FFFFFEDB, 00
        jmp     ?_129                                   ; 173F _ EB, 1B

?_126:  mov     byte [rbp-129H], 1                      ; 1741 _ C6. 85, FFFFFED7, 01
        jmp     ?_128                                   ; 1748 _ EB, 01

?_127:  nop                                             ; 174A _ 90
?_128:  mov     byte [rbp-125H], 0                      ; 174B _ C6. 85, FFFFFEDB, 00
        mov     dword [rbp-120H], 128                   ; 1752 _ C7. 85, FFFFFEE0, 00000080
?_129:  movzx   eax, byte [rbp-129H]                    ; 175C _ 0F B6. 85, FFFFFED7
        xor     eax, 01H                                ; 1763 _ 83. F0, 01
        test    al, al                                  ; 1766 _ 84. C0
        jne     ?_115                                   ; 1768 _ 0F 85, FFFFFE49
        jmp     ?_141                                   ; 176E _ E9, 0000008E

?_130:  nop                                             ; 1773 _ 90
        jmp     ?_141                                   ; 1774 _ E9, 00000088

?_131:  mov     rax, qword [rbp-110H]                   ; 1779 _ 48: 8B. 85, FFFFFEF0
        mov     rdi, rax                                ; 1780 _ 48: 89. C7
        call    float_option                            ; 1783 _ E8, 00000000(PLT r)
        test    eax, eax                                ; 1788 _ 85. C0
        jz      ?_140                                   ; 178A _ 74, 74
        mov     rax, qword [rbp-110H]                   ; 178C _ 48: 8B. 85, FFFFFEF0
        lea     rdx, [rel ?_169]                        ; 1793 _ 48: 8D. 15, 00000000(rel)
        mov     rsi, rax                                ; 179A _ 48: 89. C6
        mov     rdi, rdx                                ; 179D _ 48: 89. D7
        mov     eax, 0                                  ; 17A0 _ B8, 00000000
        call    nasm_nonfatal                           ; 17A5 _ E8, 00000000(PLT r)
        jmp     ?_140                                   ; 17AA _ EB, 54

?_132:  mov     rax, qword [rbp-110H]                   ; 17AC _ 48: 8B. 85, FFFFFEF0
        lea     rdx, [rel globl+0DH]                    ; 17B3 _ 48: 8D. 15, 00000000(rel)
        mov     rsi, rdx                                ; 17BA _ 48: 89. D6
        mov     rdi, rax                                ; 17BD _ 48: 89. C7
        call    get_boolean_option                      ; 17C0 _ E8, 00000000(PLT r)
        jmp     ?_141                                   ; 17C5 _ EB, 3A

?_133:  mov     rax, qword [rbp-110H]                   ; 17C7 _ 48: 8B. 85, FFFFFEF0
        mov     rdi, rax                                ; 17CE _ 48: 89. C7
        call    process_pragma                          ; 17D1 _ E8, 00000000(PLT r)
        jmp     ?_141                                   ; 17D6 _ EB, 29

?_134:  mov     rdx, qword [rbp-110H]                   ; 17D8 _ 48: 8B. 95, FFFFFEF0
        mov     eax, dword [rbp-11CH]                   ; 17DF _ 8B. 85, FFFFFEE4
        mov     rsi, rdx                                ; 17E5 _ 48: 89. D6
        mov     edi, eax                                ; 17E8 _ 89. C7
        call    set_label_mangle                        ; 17EA _ E8, 00000000(PLT r)
        jmp     ?_141                                   ; 17EF _ EB, 10

?_135:  nop                                             ; 17F1 _ 90
        jmp     ?_141                                   ; 17F2 _ EB, 0D

?_136:  nop                                             ; 17F4 _ 90
        jmp     ?_141                                   ; 17F5 _ EB, 0A

?_137:  nop                                             ; 17F7 _ 90
        jmp     ?_141                                   ; 17F8 _ EB, 07

?_138:  nop                                             ; 17FA _ 90
        jmp     ?_141                                   ; 17FB _ EB, 04

?_139:  nop                                             ; 17FD _ 90
        jmp     ?_141                                   ; 17FE _ EB, 01

?_140:  nop                                             ; 1800 _ 90
?_141:  cmp     byte [rbp-129H], 0                      ; 1801 _ 80. BD, FFFFFED7, 00
        jz      ?_142                                   ; 1808 _ 74, 1E
        mov     rax, qword [rbp-138H]                   ; 180A _ 48: 8B. 85, FFFFFEC8
        lea     rdx, [rel ?_170]                        ; 1811 _ 48: 8D. 15, 00000000(rel)
        mov     rsi, rax                                ; 1818 _ 48: 89. C6
        mov     rdi, rdx                                ; 181B _ 48: 89. D7
        mov     eax, 0                                  ; 181E _ B8, 00000000
        call    nasm_nonfatal                           ; 1823 _ E8, 00000000(PLT r)
?_142:  mov     eax, 1                                  ; 1828 _ B8, 00000001
?_143:  mov     rdx, qword [rbp-8H]                     ; 182D _ 48: 8B. 55, F8
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        sub     rdx, qword [fs:abs 28H]                 ; 1831 _ 64 48: 2B. 14 25, 00000028
        jz      ?_144                                   ; 183A _ 74, 05
        call    __stack_chk_fail                        ; 183C _ E8, 00000000(PLT r)
?_144:  leave                                           ; 1841 _ C9
        ret                                             ; 1842 _ C3
; process_directives End of function


SECTION .data   align=1 noexec                          ; section number 2, data


SECTION .bss    align=1 noexec                          ; section number 3, bss


SECTION .rodata align=16 noexec                         ; section number 4, const

?_145:                                                  ; byte
        db 20H, 2CH, 00H                                ; 0000 _  ,.

?_146:                                                  ; byte
        db 6EH, 6FH, 00H, 00H, 00H                      ; 0003 _ no...

?_147:                                                  ; byte
        db 75H, 6EH, 6BH, 6EH, 6FH, 77H, 6EH, 20H       ; 0008 _ unknown 
        db 43H, 50H, 55H, 20H, 74H, 79H, 70H, 65H       ; 0010 _ CPU type
        db 20H, 6FH, 72H, 20H, 66H, 6CH, 61H, 67H       ; 0018 _  or flag
        db 20H, 27H, 25H, 2EH, 2AH, 73H, 27H, 00H       ; 0020 _  '%.*s'.

?_148:                                                  ; byte
        db 63H, 61H, 6EH, 6EH, 6FH, 74H, 20H, 73H       ; 0028 _ cannot s
        db 70H, 65H, 63H, 69H, 66H, 79H, 20H, 33H       ; 0030 _ pecify 3
        db 32H, 2DH, 62H, 69H, 74H, 20H, 73H, 65H       ; 0038 _ 2-bit se
        db 67H, 6DH, 65H, 6EH, 74H, 20H, 6FH, 6EH       ; 0040 _ gment on
        db 20H, 70H, 72H, 6FH, 63H, 65H, 73H, 73H       ; 0048 _  process
        db 6FH, 72H, 20H, 62H, 65H, 6CH, 6FH, 77H       ; 0050 _ or below
        db 20H, 61H, 20H, 33H, 38H, 36H, 00H, 00H       ; 0058 _  a 386..

?_149:                                                  ; byte
        db 63H, 61H, 6EH, 6EH, 6FH, 74H, 20H, 73H       ; 0060 _ cannot s
        db 70H, 65H, 63H, 69H, 66H, 79H, 20H, 36H       ; 0068 _ pecify 6
        db 34H, 2DH, 62H, 69H, 74H, 20H, 73H, 65H       ; 0070 _ 4-bit se
        db 67H, 6DH, 65H, 6EH, 74H, 20H, 6FH, 6EH       ; 0078 _ gment on
        db 20H, 70H, 72H, 6FH, 63H, 65H, 73H, 73H       ; 0080 _  process
        db 6FH, 72H, 20H, 62H, 65H, 6CH, 6FH, 77H       ; 0088 _ or below
        db 20H, 61H, 6EH, 20H, 78H, 38H, 36H, 2DH       ; 0090 _  an x86-
        db 36H, 34H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0098 _ 64......

?_150:                                                  ; byte
        db 60H, 25H, 73H, 27H, 20H, 69H, 73H, 20H       ; 00A0 _ `%s' is 
        db 6EH, 6FH, 74H, 20H, 61H, 20H, 76H, 61H       ; 00A8 _ not a va
        db 6CH, 69H, 64H, 20H, 73H, 65H, 67H, 6DH       ; 00B0 _ lid segm
        db 65H, 6EH, 74H, 20H, 73H, 69H, 7AH, 65H       ; 00B8 _ ent size
        db 3BH, 20H, 6DH, 75H, 73H, 74H, 20H, 62H       ; 00C0 _ ; must b
        db 65H, 20H, 31H, 36H, 2CH, 20H, 33H, 32H       ; 00C8 _ e 16, 32
        db 20H, 6FH, 72H, 20H, 36H, 34H, 00H, 00H       ; 00D0 _  or 64..

?_151:                                                  ; byte
        db 67H, 61H, 72H, 62H, 61H, 67H, 65H, 20H       ; 00D8 _ garbage 
        db 66H, 6FH, 75H, 6EH, 64H, 20H, 6FH, 6EH       ; 00E0 _ found on
        db 20H, 6CH, 69H, 6EH, 65H, 20H, 61H, 66H       ; 00E8 _  line af
        db 74H, 65H, 72H, 20H, 64H, 69H, 72H, 65H       ; 00F0 _ ter dire
        db 63H, 74H, 69H, 76H, 65H, 00H                 ; 00F8 _ ctive.

?_152:                                                  ; byte
        db 69H, 6EH, 76H, 61H, 6CH, 69H, 64H, 20H       ; 00FE _ invalid 
        db 64H, 69H, 72H, 65H, 63H, 74H, 69H, 76H       ; 0106 _ directiv
        db 65H, 20H, 6CH, 69H, 6EH, 65H, 00H            ; 010E _ e line.

?_153:                                                  ; byte
        db 2EH, 2FH, 61H, 73H, 6DH, 2FH, 64H, 69H       ; 0115 _ ./asm/di
        db 72H, 65H, 63H, 74H, 69H, 76H, 2EH, 63H       ; 011D _ rectiv.c
        db 00H, 00H, 00H                                ; 0125 _ ...

?_154:                                                  ; byte
        db 69H, 6EH, 74H, 65H, 72H, 6EH, 61H, 6CH       ; 0128 _ internal
        db 20H, 65H, 72H, 72H, 6FH, 72H, 3AH, 20H       ; 0130 _  error: 
        db 75H, 6EH, 69H, 6DH, 70H, 6CH, 65H, 6DH       ; 0138 _ unimplem
        db 65H, 6EH, 74H, 65H, 64H, 20H, 64H, 69H       ; 0140 _ ented di
        db 72H, 65H, 63H, 74H, 69H, 76H, 65H, 20H       ; 0148 _ rective 
        db 5BH, 25H, 73H, 5DH, 00H                      ; 0150 _ [%s].

?_155:                                                  ; byte
        db 75H, 6EH, 72H, 65H, 63H, 6FH, 67H, 6EH       ; 0155 _ unrecogn
        db 69H, 7AH, 65H, 64H, 20H, 64H, 69H, 72H       ; 015D _ ized dir
        db 65H, 63H, 74H, 69H, 76H, 65H, 20H, 5BH       ; 0165 _ ective [
        db 25H, 73H, 5DH, 00H, 00H, 00H, 00H, 00H       ; 016D _ %s].....
        db 00H, 00H, 00H                                ; 0175 _ ...

?_156:                                                  ; byte
        db 73H, 65H, 67H, 6DH, 65H, 6EH, 74H, 20H       ; 0178 _ segment 
        db 6EH, 61H, 6DH, 65H, 20H, 60H, 25H, 73H       ; 0180 _ name `%s
        db 27H, 20H, 6EH, 6FH, 74H, 20H, 72H, 65H       ; 0188 _ ' not re
        db 63H, 6FH, 67H, 6EH, 69H, 7AH, 65H, 64H       ; 0190 _ cognized
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0198 _ ........

?_157:                                                  ; byte
        db 73H, 65H, 67H, 6DH, 65H, 6EH, 74H, 20H       ; 01A0 _ segment 
        db 61H, 6CH, 69H, 67H, 6EH, 6DH, 65H, 6EH       ; 01A8 _ alignmen
        db 74H, 20H, 60H, 25H, 73H, 27H, 20H, 69H       ; 01B0 _ t `%s' i
        db 73H, 20H, 6EH, 6FH, 74H, 20H, 70H, 6FH       ; 01B8 _ s not po
        db 77H, 65H, 72H, 20H, 6FH, 66H, 20H, 74H       ; 01C0 _ wer of t
        db 77H, 6FH, 00H, 00H, 00H, 00H, 00H, 00H       ; 01C8 _ wo......

?_158:                                                  ; byte
        db 61H, 62H, 73H, 75H, 72H, 64H, 6CH, 79H       ; 01D0 _ absurdly
        db 20H, 6CH, 61H, 72H, 67H, 65H, 20H, 73H       ; 01D8 _  large s
        db 65H, 67H, 6DH, 65H, 6EH, 74H, 20H, 61H       ; 01E0 _ egment a
        db 6CH, 69H, 67H, 6EH, 6DH, 65H, 6EH, 74H       ; 01E8 _ lignment
        db 20H, 60H, 25H, 73H, 27H, 20H, 28H, 32H       ; 01F0 _  `%s' (2
        db 5EH, 25H, 64H, 29H, 00H, 00H, 00H, 00H       ; 01F8 _ ^%d)....

?_159:                                                  ; byte
        db 69H, 64H, 65H, 6EH, 74H, 69H, 66H, 69H       ; 0200 _ identifi
        db 65H, 72H, 20H, 65H, 78H, 70H, 65H, 63H       ; 0208 _ er expec
        db 74H, 65H, 64H, 20H, 61H, 66H, 74H, 65H       ; 0210 _ ted afte
        db 72H, 20H, 25H, 73H, 2CH, 20H, 67H, 6FH       ; 0218 _ r %s, go
        db 74H, 20H, 60H, 25H, 73H, 27H, 00H            ; 0220 _ t `%s'.

?_160:                                                  ; byte
        db 69H, 6EH, 76H, 61H, 6CH, 69H, 64H, 00H       ; 0227 _ invalid.
        db 00H                                          ; 022F _ .

?_161:                                                  ; byte
        db 25H, 73H, 20H, 73H, 69H, 7AH, 65H, 20H       ; 0230 _ %s size 
        db 73H, 70H, 65H, 63H, 69H, 66H, 69H, 65H       ; 0238 _ specifie
        db 64H, 20H, 69H, 6EH, 20H, 63H, 6FH, 6DH       ; 0240 _ d in com
        db 6DH, 6FH, 6EH, 20H, 64H, 65H, 63H, 6CH       ; 0248 _ mon decl
        db 61H, 72H, 61H, 74H, 69H, 6FH, 6EH, 00H       ; 0250 _ aration.

?_162:                                                  ; byte
        db 69H, 6EH, 76H, 61H, 6CH, 69H, 64H, 20H       ; 0258 _ invalid 
        db 73H, 79H, 6EH, 74H, 61H, 78H, 20H, 69H       ; 0260 _ syntax i
        db 6EH, 20H, 25H, 73H, 20H, 64H, 65H, 63H       ; 0268 _ n %s dec
        db 6CH, 61H, 72H, 61H, 74H, 69H, 6FH, 6EH       ; 0270 _ laration
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0278 _ ........

?_163:                                                  ; byte
        db 63H, 61H, 6EH, 6EH, 6FH, 74H, 20H, 75H       ; 0280 _ cannot u
        db 73H, 65H, 20H, 6EH, 6FH, 6EH, 2DH, 72H       ; 0288 _ se non-r
        db 65H, 6CH, 6FH, 63H, 61H, 74H, 61H, 62H       ; 0290 _ elocatab
        db 6CH, 65H, 20H, 65H, 78H, 70H, 72H, 65H       ; 0298 _ le expre
        db 73H, 73H, 69H, 6FH, 6EH, 20H, 61H, 73H       ; 02A0 _ ssion as
        db 20H, 41H, 42H, 53H, 4FH, 4CH, 55H, 54H       ; 02A8 _  ABSOLUT
        db 45H, 20H, 61H, 64H, 64H, 72H, 65H, 73H       ; 02B0 _ E addres
        db 73H, 00H                                     ; 02B8 _ s.

?_164:                                                  ; byte
        db 69H, 6EH, 76H, 61H, 6CH, 69H, 64H, 20H       ; 02BA _ invalid 
        db 41H, 42H, 53H, 4FH, 4CH, 55H, 54H, 45H       ; 02C2 _ ABSOLUTE
        db 20H, 61H, 64H, 64H, 72H, 65H, 73H, 73H       ; 02CA _  address
        db 00H, 00H, 00H, 00H, 00H, 00H                 ; 02D2 _ ......

?_165:                                                  ; byte
        db 69H, 64H, 65H, 6EH, 74H, 69H, 66H, 69H       ; 02D8 _ identifi
        db 65H, 72H, 20H, 65H, 78H, 70H, 65H, 63H       ; 02E0 _ er expec
        db 74H, 65H, 64H, 20H, 61H, 66H, 74H, 65H       ; 02E8 _ ted afte
        db 72H, 20H, 44H, 45H, 42H, 55H, 47H, 00H       ; 02F0 _ r DEBUG.

?_166:                                                  ; byte
        db 44H, 45H, 42H, 55H, 47H, 20H, 69H, 64H       ; 02F8 _ DEBUG id
        db 65H, 6EH, 74H, 69H, 66H, 69H, 65H, 72H       ; 0300 _ entifier
        db 20H, 74H, 6FH, 6FH, 20H, 6CH, 6FH, 6EH       ; 0308 _  too lon
        db 67H, 00H                                     ; 0310 _ g.

?_167:                                                  ; byte
        db 70H, 75H, 73H, 68H, 00H                      ; 0312 _ push.

?_168:                                                  ; byte
        db 70H, 6FH, 70H, 00H                           ; 0317 _ pop.

?_169:                                                  ; byte
        db 75H, 6EH, 6BH, 6EH, 6FH, 77H, 6EH, 20H       ; 031B _ unknown 
        db 27H, 66H, 6CH, 6FH, 61H, 74H, 27H, 20H       ; 0323 _ 'float' 
        db 64H, 69H, 72H, 65H, 63H, 74H, 69H, 76H       ; 032B _ directiv
        db 65H, 3AH, 20H, 25H, 73H, 00H, 00H, 00H       ; 0333 _ e: %s...
        db 00H, 00H, 00H, 00H, 00H                      ; 033B _ .....

?_170:                                                  ; byte
        db 69H, 6EH, 76H, 61H, 6CH, 69H, 64H, 20H       ; 0340 _ invalid 
        db 70H, 61H, 72H, 61H, 6DH, 65H, 74H, 65H       ; 0348 _ paramete
        db 72H, 20H, 74H, 6FH, 20H, 5BH, 25H, 73H       ; 0350 _ r to [%s
        db 5DH, 20H, 64H, 69H, 72H, 65H, 63H, 74H       ; 0358 _ ] direct
        db 69H, 76H, 65H, 00H, 64H, 65H, 66H, 61H       ; 0360 _ ive.defa
        db 75H, 6CH, 74H, 00H, 38H, 30H, 38H, 36H       ; 0368 _ ult.8086
        db 00H, 31H, 38H, 36H, 00H, 32H, 38H, 36H       ; 0370 _ .186.286
        db 00H, 33H, 38H, 36H, 00H, 34H, 38H, 36H       ; 0378 _ .386.486
        db 00H, 35H, 38H, 36H, 00H, 70H, 65H, 6EH       ; 0380 _ .586.pen
        db 74H, 69H, 75H, 6DH, 00H, 70H, 65H, 6EH       ; 0388 _ tium.pen
        db 74H, 69H, 75H, 6DH, 6DH, 6DH, 78H, 00H       ; 0390 _ tiummmx.
        db 36H, 38H, 36H, 00H, 70H, 36H, 00H, 70H       ; 0398 _ 686.p6.p
        db 70H, 72H, 6FH, 00H, 70H, 65H, 6EH, 74H       ; 03A0 _ pro.pent
        db 69H, 75H, 6DH, 70H, 72H, 6FH, 00H, 70H       ; 03A8 _ iumpro.p
        db 32H, 00H, 70H, 65H, 6EH, 74H, 69H, 75H       ; 03B0 _ 2.pentiu
        db 6DH, 69H, 69H, 00H, 70H, 33H, 00H, 6BH       ; 03B8 _ mii.p3.k
        db 61H, 74H, 6DH, 61H, 69H, 00H, 70H, 34H       ; 03C0 _ atmai.p4
        db 00H, 77H, 69H, 6CH, 6CH, 61H, 6DH, 65H       ; 03C8 _ .willame
        db 74H, 74H, 65H, 00H, 70H, 72H, 65H, 73H       ; 03D0 _ tte.pres
        db 63H, 6FH, 74H, 74H, 00H, 78H, 36H, 34H       ; 03D8 _ cott.x64
        db 00H, 78H, 38H, 36H, 2DH, 36H, 34H, 00H       ; 03E0 _ .x86-64.
        db 69H, 61H, 36H, 34H, 00H, 69H, 61H, 2DH       ; 03E8 _ ia64.ia-
        db 36H, 34H, 00H, 69H, 74H, 61H, 6EH, 69H       ; 03F0 _ 64.itani
        db 75H, 6DH, 00H, 69H, 74H, 61H, 6EH, 69H       ; 03F8 _ um.itani
        db 63H, 00H, 6DH, 65H, 72H, 63H, 65H, 64H       ; 0400 _ c.merced
        db 00H, 6EH, 65H, 68H, 61H, 6CH, 65H, 6DH       ; 0408 _ .nehalem
        db 00H, 77H, 65H, 73H, 74H, 6DH, 65H, 72H       ; 0410 _ .westmer
        db 65H, 00H, 73H, 61H, 6EH, 64H, 79H, 62H       ; 0418 _ e.sandyb
        db 72H, 69H, 64H, 67H, 65H, 00H, 69H, 76H       ; 0420 _ ridge.iv
        db 79H, 62H, 72H, 69H, 64H, 67H, 65H, 00H       ; 0428 _ ybridge.
        db 61H, 6EH, 79H, 00H, 61H, 6CH, 6CH, 00H       ; 0430 _ any.all.
        db 6CH, 61H, 74H, 65H, 76H, 65H, 78H, 00H       ; 0438 _ latevex.
        db 61H, 70H, 78H, 00H, 65H, 76H, 65H, 78H       ; 0440 _ apx.evex
        db 00H, 76H, 65H, 78H, 00H, 00H, 00H, 00H       ; 0448 _ .vex....

__func__.0:                                             ; byte
        db 70H, 72H, 6FH, 63H, 65H, 73H, 73H, 5FH       ; 0450 _ process_
        db 64H, 69H, 72H, 65H, 63H, 74H, 69H, 76H       ; 0458 _ directiv
        db 65H, 73H, 00H                                ; 0460 _ es.


SECTION .data.rel.ro.local align=32 noexec              ; section number 5, data

cpunames.1:                                             ; byte
        dq ?_145+364H                                   ; 0000 _ 0000000000000000 (d)

?_171:  dd 000000D0H, 00000000H                         ; 0008 _ 208 0 
        dq ?_145+36CH                                   ; 0010 _ 0000000000000000 (d)
        dq 00000000000000C0H                            ; 0018 _ 00000000000000C0 
        dq ?_145+371H                                   ; 0020 _ 0000000000000000 (d)
        dq 00000000000000C1H                            ; 0028 _ 00000000000000C1 
        dq ?_145+375H                                   ; 0030 _ 0000000000000000 (d)
        dq 00000000000000C2H                            ; 0038 _ 00000000000000C2 
        dq ?_145+379H                                   ; 0040 _ 0000000000000000 (d)
        dq 00000000000000C3H                            ; 0048 _ 00000000000000C3 
        dq ?_145+37DH                                   ; 0050 _ 0000000000000000 (d)
        dq 00000000000000C4H                            ; 0058 _ 00000000000000C4 
        dq ?_145+381H                                   ; 0060 _ 0000000000000000 (d)
        dq 00000000000000C5H                            ; 0068 _ 00000000000000C5 
        dq ?_145+385H                                   ; 0070 _ 0000000000000000 (d)
        dq 00000000000000C5H                            ; 0078 _ 00000000000000C5 
        dq ?_145+38DH                                   ; 0080 _ 0000000000000000 (d)
        dq 00000000000000C5H                            ; 0088 _ 00000000000000C5 
        dq ?_145+398H                                   ; 0090 _ 0000000000000000 (d)
        dq 00000000000000C6H                            ; 0098 _ 00000000000000C6 
        dq ?_145+39CH                                   ; 00A0 _ 0000000000000000 (d)
        dq 00000000000000C6H                            ; 00A8 _ 00000000000000C6 
        dq ?_145+39FH                                   ; 00B0 _ 0000000000000000 (d)
        dq 00000000000000C6H                            ; 00B8 _ 00000000000000C6 
        dq ?_145+3A4H                                   ; 00C0 _ 0000000000000000 (d)
        dq 00000000000000C6H                            ; 00C8 _ 00000000000000C6 
        dq ?_145+3AFH                                   ; 00D0 _ 0000000000000000 (d)
        dq 00000000000000C6H                            ; 00D8 _ 00000000000000C6 
        dq ?_145+3B2H                                   ; 00E0 _ 0000000000000000 (d)
        dq 00000000000000C6H                            ; 00E8 _ 00000000000000C6 
        dq ?_145+3BCH                                   ; 00F0 _ 0000000000000000 (d)
        dq 00000000000000C7H                            ; 00F8 _ 00000000000000C7 
        dq ?_145+3BFH                                   ; 0100 _ 0000000000000000 (d)
        dq 00000000000000C7H                            ; 0108 _ 00000000000000C7 
        dq ?_145+3C6H                                   ; 0110 _ 0000000000000000 (d)
        dq 00000000000000C8H                            ; 0118 _ 00000000000000C8 
        dq ?_145+3C9H                                   ; 0120 _ 0000000000000000 (d)
        dq 00000000000000C8H                            ; 0128 _ 00000000000000C8 
        dq ?_145+3D4H                                   ; 0130 _ 0000000000000000 (d)
        dq 00000000000000C9H                            ; 0138 _ 00000000000000C9 
        dq ?_145+3DDH                                   ; 0140 _ 0000000000000000 (d)
        dq 00000000000000CBH                            ; 0148 _ 00000000000000CB 
        dq ?_145+3E1H                                   ; 0150 _ 0000000000000000 (d)
        dq 00000000000000CBH                            ; 0158 _ 00000000000000CB 
        dq ?_145+3E8H                                   ; 0160 _ 0000000000000000 (d)
        dq 00000000000000CAH                            ; 0168 _ 00000000000000CA 
        dq ?_145+3EDH                                   ; 0170 _ 0000000000000000 (d)
        dq 00000000000000CAH                            ; 0178 _ 00000000000000CA 
        dq ?_145+3F3H                                   ; 0180 _ 0000000000000000 (d)
        dq 00000000000000CAH                            ; 0188 _ 00000000000000CA 
        dq ?_145+3FBH                                   ; 0190 _ 0000000000000000 (d)
        dq 00000000000000CAH                            ; 0198 _ 00000000000000CA 
        dq ?_145+402H                                   ; 01A0 _ 0000000000000000 (d)
        dq 00000000000000CAH                            ; 01A8 _ 00000000000000CA 
        dq ?_145+409H                                   ; 01B0 _ 0000000000000000 (d)
        dq 00000000000000CCH                            ; 01B8 _ 00000000000000CC 
        dq ?_145+411H                                   ; 01C0 _ 0000000000000000 (d)
        dq 00000000000000CDH                            ; 01C8 _ 00000000000000CD 
        dq ?_145+41AH                                   ; 01D0 _ 0000000000000000 (d)
        dq 00000000000000CEH                            ; 01D8 _ 00000000000000CE 
        dq ?_145+426H                                   ; 01E0 _ 0000000000000000 (d)
        dq 00000000000000CFH                            ; 01E8 _ 00000000000000CF 
        dq ?_145+430H                                   ; 01F0 _ 0000000000000000 (d)
        dq 00000000000000D1H                            ; 01F8 _ 00000000000000D1 
        dq ?_145+434H                                   ; 0200 _ 0000000000000000 (d)
        dq 00000000000000D1H                            ; 0208 _ 00000000000000D1 
        dq ?_145+438H                                   ; 0210 _ 0000000000000000 (d)
        dq 000000000000001CH                            ; 0218 _ 000000000000001C 
        dq ?_145+440H                                   ; 0220 _ 0000000000000000 (d)
        dq 0000000000000092H                            ; 0228 _ 0000000000000092 
        dq ?_145+444H                                   ; 0230 _ 0000000000000000 (d)
        dq 0000000000000041H                            ; 0238 _ 0000000000000041 
        dq ?_145+449H                                   ; 0240 _ 0000000000000000 (d)
        dq 0000000000000040H                            ; 0248 _ 0000000000000040 
        dq 0000000000000000H                            ; 0250 _ 0000000000000000 
        dq 0000000000000000H                            ; 0258 _ 0000000000000000 


SECTION .note.gnu.property align=8 noexec               ; section number 6, const

        db 04H, 00H, 00H, 00H, 20H, 00H, 00H, 00H       ; 0000 _ .... ...
        db 05H, 00H, 00H, 00H, 47H, 4EH, 55H, 00H       ; 0008 _ ....GNU.
        db 02H, 00H, 01H, 0C0H, 04H, 00H, 00H, 00H      ; 0010 _ ........
        db 01H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0018 _ ........
        db 01H, 00H, 01H, 0C0H, 04H, 00H, 00H, 00H      ; 0020 _ ........
        db 01H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0028 _ ........


SECTION .eh_frame align=8 noexec                        ; section number 7, const

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
        dd 00000024H, 100E4100H                         ; 00E4 _ 36 269369600 
        dd 0D430286H, 070C5F06H                         ; 00EC _ 222495366 118251270 
        dd 00000008H, 0000001CH                         ; 00F4 _ 8 28 
        dd 000000FCH                                    ; 00FC _ 252 
        dd nasm_ctype-$-0AH                             ; 0100 _ 00000000 (rel)
        dd 00000033H, 100E4100H                         ; 0104 _ 51 269369600 
        dd 0D430286H, 070C6E06H                         ; 010C _ 222495366 118255110 
        dd 00000008H, 0000001CH                         ; 0114 _ 8 28 
        dd 0000011CH                                    ; 011C _ 284 
        dd nasm_ctype-$+9H                              ; 0120 _ 00000000 (rel)
        dd 0000000CH, 100E4100H                         ; 0124 _ 12 269369600 
        dd 0D430286H, 070C4706H                         ; 012C _ 222495366 118245126 
        dd 00000008H, 0000001CH                         ; 0134 _ 8 28 
        dd 0000013CH                                    ; 013C _ 316 
        dd nasm_ctype-$-0BH                             ; 0140 _ 00000000 (rel)
        dd 00000011H, 100E4100H                         ; 0144 _ 17 269369600 
        dd 0D430286H, 070C4C06H                         ; 014C _ 222495366 118246406 
        dd 00000008H, 0000001CH                         ; 0154 _ 8 28 
        dd 0000015CH                                    ; 015C _ 348 
        dd nasm_ctype-$-1AH                             ; 0160 _ 00000000 (rel)
        dd 00000011H, 100E4100H                         ; 0164 _ 17 269369600 
        dd 0D430286H, 070C4C06H                         ; 016C _ 222495366 118246406 
        dd 00000008H, 0000001CH                         ; 0174 _ 8 28 
        dd 0000017CH                                    ; 017C _ 380 
        dd nasm_ctype-$-29H                             ; 0180 _ 00000000 (rel)
        dd 00000036H, 100E4100H                         ; 0184 _ 54 269369600 
        dd 0D430286H, 070C7106H                         ; 018C _ 222495366 118255878 
        dd 00000008H, 0000001CH                         ; 0194 _ 8 28 
        dd 0000019CH                                    ; 019C _ 412 
        dd nasm_ctype-$-13H                             ; 01A0 _ 00000000 (rel)
        dd 00000045H, 100E4100H                         ; 01A4 _ 69 269369600 
        dd 0D430286H, 0C400206H                         ; 01AC _ 222495366 205521414 
        dd 00000807H, 0000001CH                         ; 01B4 _ 2055 28 
        dd 000001BCH                                    ; 01BC _ 444 
        dd nasm_ctype-$+12H                             ; 01C0 _ 00000000 (rel)
        dd 00000049H, 100E4100H                         ; 01C4 _ 73 269369600 
        dd 0D430286H, 0C440206H                         ; 01CC _ 222495366 205783558 
        dd 00000807H, 0000001CH                         ; 01D4 _ 2055 28 
        dd 000001DCH                                    ; 01DC _ 476 
        dd nasm_ctype-$+3BH                             ; 01E0 _ 00000000 (rel)
        dd 00000016H, 100E4100H                         ; 01E4 _ 22 269369600 
        dd 0D430286H, 070C5106H                         ; 01EC _ 222495366 118247686 
        dd 00000008H, 0000001CH                         ; 01F4 _ 8 28 
        dd 000001FCH                                    ; 01FC _ 508 
        dd nasm_ctype-$+31H                             ; 0200 _ 00000000 (rel)
        dd 0000002CH, 100E4100H                         ; 0204 _ 44 269369600 
        dd 0D430286H, 070C6706H                         ; 020C _ 222495366 118253318 
        dd 00000008H, 0000001CH                         ; 0214 _ 8 28 
        dd 0000021CH                                    ; 021C _ 540 
        dd nasm_ctype-$+3DH                             ; 0220 _ 00000000 (rel)
        dd 00000031H, 100E4100H                         ; 0224 _ 49 269369600 
        dd 0D430286H, 070C6C06H                         ; 022C _ 222495366 118254598 
        dd 00000008H, 0000001CH                         ; 0234 _ 8 28 
        dd 0000023CH                                    ; 023C _ 572 
        dd nasm_isidstart-$+240H                        ; 0240 _ 00000000 (rel)
        dd 0000006DH, 100E4100H                         ; 0244 _ 109 269369600 
        dd 0D430286H, 0C680206H                         ; 024C _ 222495366 208142854 
        dd 00000807H, 0000001CH                         ; 0254 _ 2055 28 
        dd 0000025CH                                    ; 025C _ 604 
        dd nasm_ctype-$+9BH                             ; 0260 _ 00000000 (rel)
        dd 00000032H, 100E4100H                         ; 0264 _ 50 269369600 
        dd 0D430286H, 070C6D06H                         ; 026C _ 222495366 118254854 
        dd 00000008H, 0000001CH                         ; 0274 _ 8 28 
        dd 0000027CH                                    ; 027C _ 636 
        dd nasm_ctype-$+0ADH                            ; 0280 _ 00000000 (rel)
        dd 00000068H, 100E4100H                         ; 0284 _ 104 269369600 
        dd 0D430286H, 0C630206H                         ; 028C _ 222495366 207815174 
        dd 00000807H, 0000001CH                         ; 0294 _ 2055 28 
        dd 0000029CH                                    ; 029C _ 668 
        dd nasm_ctype-$+0F5H                            ; 02A0 _ 00000000 (rel)
        dd 0000027AH, 100E4100H                         ; 02A4 _ 634 269369600 
        dd 0D430286H, 02750306H                         ; 02AC _ 222495366 41222918 
        dd 0008070CH, 0000001CH                         ; 02B4 _ 526092 28 
        dd 000002BCH                                    ; 02BC _ 700 
        dd nasm_ctype-$+34FH                            ; 02C0 _ 00000000 (rel)
        dd 000000DBH, 100E4100H                         ; 02C4 _ 219 269369600 
        dd 0D430286H, 0CD60206H                         ; 02CC _ 222495366 215351814 
        dd 00000807H, 0000001CH                         ; 02D4 _ 2055 28 
        dd 000002DCH                                    ; 02DC _ 732 
        dd nasm_ctype-$+40AH                            ; 02E0 _ 00000000 (rel)
        dd 000001A6H, 100E4100H                         ; 02E4 _ 422 269369600 
        dd 0D430286H, 01A10306H                         ; 02EC _ 222495366 27329286 
        dd 0008070CH, 0000001CH                         ; 02F4 _ 526092 28 
        dd 000002FCH                                    ; 02FC _ 764 
        dd nasm_ctype-$+590H                            ; 0300 _ 00000000 (rel)
        dd 00000061H, 100E4100H                         ; 0304 _ 97 269369600 
        dd 0D430286H, 0C5C0206H                         ; 030C _ 222495366 207356422 
        dd 00000807H, 0000001CH                         ; 0314 _ 2055 28 
        dd 0000031CH                                    ; 031C _ 796 
        dd nasm_ctype-$+5D1H                            ; 0320 _ 00000000 (rel)
        dd 00000F52H, 100E4100H                         ; 0324 _ 3922 269369600 
        dd 0D430286H, 0F4D0306H                         ; 032C _ 222495366 256705286 
        dd 0008070CH                                    ; 0334 _ 526092 


