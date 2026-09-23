; Disassembly of file: /tmp/tmp.Is0hdxjQt3.o
; Wed Sep 23 14:43:27 2026
; Type: ELF64
; Syntax: NASM
; Instruction set: 80386, x64

default rel

global push_warnings: function
global pop_warnings: function
global error_init: function
global error_pass_start: function
global error_pass_end: function
global set_warning_status: function
global error_pfx: function
global nasm_verror_critical: function
global nasm_error_hold_push: function
global nasm_error_hold_pop: function
global nasm_verror: function
global set_error_format: function
global warn_dollar_hex: function

extern _progname                                        ; qword
extern __stack_chk_fail                                 ; near
extern strlist_write                                    ; near
extern strlist_printf                                   ; near
extern strerror                                         ; near
extern snprintf                                         ; near
extern warning_name                                     ; byte
extern pp_error_list_macros                             ; near
extern nasm_vasprintf                                   ; near
extern __errno_location                                 ; near
extern nasm_zalloc                                      ; near
extern fputc                                            ; near
extern vfprintf                                         ; near
extern fprintf                                          ; near
extern fputs                                            ; near
extern abort                                            ; near
extern exit                                             ; near
extern close_output                                     ; near
extern fflush                                           ; near
extern lfmt                                             ; qword
extern print_final_report                               ; near
extern pp_suppress_error                                ; near
extern warning_default                                  ; byte
extern warning_alias                                    ; byte
extern strlen                                           ; near
extern strcasecmp                                       ; near
extern strncasecmp                                      ; near
extern nasm_skip_spaces                                 ; near
extern strlist_free                                     ; near
extern strlist_alloc                                    ; near
extern nasm_free                                        ; near
extern nasm_warn_                                       ; near
extern nasm_malloc                                      ; near
extern _pass_type                                       ; dword
extern _src_error                                       ; qword
extern _filenames                                       ; byte
extern nasm_assert_failed                               ; near
extern warning_state                                    ; qword
extern erropt                                           ; qword


SECTION .text   align=1 exec                            ; section number 1, code

warn_active:; Local function
        push    rbp                                     ; 0000 _ 55
        mov     rbp, rsp                                ; 0001 _ 48: 89. E5
        mov     dword [rbp-4H], edi                     ; 0004 _ 89. 7D, FC
        mov     eax, dword [rel erropt+0CH]             ; 0007 _ 8B. 05, 00000000(rel)
        and     eax, dword [rbp-4H]                     ; 000D _ 23. 45, FC
        test    eax, eax                                ; 0010 _ 85. C0
        jz      ?_001                                   ; 0012 _ 74, 07
        mov     eax, 0                                  ; 0014 _ B8, 00000000
        jmp     ?_002                                   ; 0019 _ EB, 16

?_001:  mov     eax, dword [rbp-4H]                     ; 001B _ 8B. 45, FC
        shr     eax, 16                                 ; 001E _ C1. E8, 10
        mov     edx, eax                                ; 0021 _ 89. C2
        lea     rax, [rel warning_state]                ; 0023 _ 48: 8D. 05, 00000000(rel)
        movzx   eax, byte [rdx+rax]                     ; 002A _ 0F B6. 04 02
        and     eax, 01H                                ; 002E _ 83. E0, 01
?_002:  pop     rbp                                     ; 0031 _ 5D
        ret                                             ; 0032 _ C3

debug_level:; Local function
        push    rbp                                     ; 0033 _ 55
        mov     rbp, rsp                                ; 0034 _ 48: 89. E5
        mov     dword [rbp-4H], edi                     ; 0037 _ 89. 7D, FC
        mov     eax, dword [rel erropt+10H]             ; 003A _ 8B. 05, 00000000(rel)
        cmp     eax, dword [rbp-4H]                     ; 0040 _ 3B. 45, FC
        setae   al                                      ; 0043 _ 0F 93. C0
        movzx   eax, al                                 ; 0046 _ 0F B6. C0
        test    rax, rax                                ; 0049 _ 48: 85. C0
        setne   al                                      ; 004C _ 0F 95. C0
        pop     rbp                                     ; 004F _ 5D
        ret                                             ; 0050 _ C3

info_level:; Local function
        push    rbp                                     ; 0051 _ 55
        mov     rbp, rsp                                ; 0052 _ 48: 89. E5
        mov     dword [rbp-4H], edi                     ; 0055 _ 89. 7D, FC
        mov     eax, dword [rel erropt+14H]             ; 0058 _ 8B. 05, 00000000(rel)
        cmp     eax, dword [rbp-4H]                     ; 005E _ 3B. 45, FC
        setae   al                                      ; 0061 _ 0F 93. C0
        movzx   eax, al                                 ; 0064 _ 0F B6. C0
        test    rax, rax                                ; 0067 _ 48: 85. C0
        setne   al                                      ; 006A _ 0F 95. C0
        pop     rbp                                     ; 006D _ 5D
        ret                                             ; 006E _ C3

get_filename:; Local function
        push    rbp                                     ; 006F _ 55
        mov     rbp, rsp                                ; 0070 _ 48: 89. E5
        sub     rsp, 16                                 ; 0073 _ 48: 83. EC, 10
        mov     dword [rbp-4H], edi                     ; 0077 _ 89. 7D, FC
        cmp     dword [rbp-4H], 8                       ; 007A _ 83. 7D, FC, 08
        seta    al                                      ; 007E _ 0F 97. C0
        movzx   eax, al                                 ; 0081 _ 0F B6. C0
        test    rax, rax                                ; 0084 _ 48: 85. C0
        jz      ?_003                                   ; 0087 _ 74, 22
        lea     rdx, [rel ?_143]                        ; 0089 _ 48: 8D. 15, 00000000(rel)
        lea     rsi, [rel __func__.2]                   ; 0090 _ 48: 8D. 35, 00000000(rel)
        lea     rax, [rel ?_144]                        ; 0097 _ 48: 8D. 05, 00000000(rel)
        mov     ecx, 49                                 ; 009E _ B9, 00000031
        mov     rdi, rax                                ; 00A3 _ 48: 89. C7
        call    nasm_assert_failed                      ; 00A6 _ E8, 00000000(PLT r)
?_003:  mov     eax, dword [rbp-4H]                     ; 00AB _ 8B. 45, FC
        lea     rdx, [rax*8]                            ; 00AE _ 48: 8D. 14 C5, 00000000
        lea     rax, [rel _filenames]                   ; 00B6 _ 48: 8D. 05, 00000000(rel)
        mov     rax, qword [rdx+rax]                    ; 00BD _ 48: 8B. 04 02
        leave                                           ; 00C1 _ C9
        ret                                             ; 00C2 _ C3

src_where_error:; Local function
        push    rbp                                     ; 00C3 _ 55
        mov     rbp, rsp                                ; 00C4 _ 48: 89. E5
        mov     rax, qword [rel _src_error]             ; 00C7 _ 48: 8B. 05, 00000000(rel)
        mov     rdx, qword [rax+8H]                     ; 00CE _ 48: 8B. 50, 08
        mov     rax, qword [rax]                        ; 00D2 _ 48: 8B. 00
        pop     rbp                                     ; 00D5 _ 5D
        ret                                             ; 00D6 _ C3

pass_type:; Local function
        push    rbp                                     ; 00D7 _ 55
        mov     rbp, rsp                                ; 00D8 _ 48: 89. E5
        mov     eax, dword [rel _pass_type]             ; 00DB _ 8B. 05, 00000000(rel)
        pop     rbp                                     ; 00E1 _ 5D
        ret                                             ; 00E2 _ C3

pass_final_or_preproc:; Local function
        push    rbp                                     ; 00E3 _ 55
        mov     rbp, rsp                                ; 00E4 _ 48: 89. E5
        call    pass_type                               ; 00E7 _ E8, FFFFFFEB
        cmp     eax, 4                                  ; 00EC _ 83. F8, 04
        ja      ?_004                                   ; 00EF _ 77, 0A
        call    pass_type                               ; 00F1 _ E8, FFFFFFE1
        cmp     eax, 1                                  ; 00F6 _ 83. F8, 01
        jnz     ?_005                                   ; 00F9 _ 75, 07
?_004:  mov     eax, 1                                  ; 00FB _ B8, 00000001
        jmp     ?_006                                   ; 0100 _ EB, 05

?_005:  mov     eax, 0                                  ; 0102 _ B8, 00000000
?_006:  and     eax, 01H                                ; 0107 _ 83. E0, 01
        pop     rbp                                     ; 010A _ 5D
        ret                                             ; 010B _ C3

push_warnings:; Function begin
        push    rbp                                     ; 010C _ 55
        mov     rbp, rsp                                ; 010D _ 48: 89. E5
        push    rbx                                     ; 0110 _ 53
        sub     rsp, 24                                 ; 0111 _ 48: 83. EC, 18
        mov     edi, 80                                 ; 0115 _ BF, 00000050
        call    nasm_malloc                             ; 011A _ E8, 00000000(PLT r)
        mov     qword [rbp-18H], rax                    ; 011F _ 48: 89. 45, E8
        mov     rax, qword [rbp-18H]                    ; 0123 _ 48: 8B. 45, E8
        add     rax, 8                                  ; 0127 _ 48: 83. C0, 08
        mov     rcx, qword [rel warning_state]          ; 012B _ 48: 8B. 0D, 00000000(rel)
        mov     rbx, qword [rel warning_state+8H]       ; 0132 _ 48: 8B. 1D, 00000000(rel)
        mov     qword [rax], rcx                        ; 0139 _ 48: 89. 08
        mov     qword [rax+8H], rbx                     ; 013C _ 48: 89. 58, 08
        mov     rcx, qword [rel warning_state+10H]      ; 0140 _ 48: 8B. 0D, 00000000(rel)
        mov     rbx, qword [rel warning_state+18H]      ; 0147 _ 48: 8B. 1D, 00000000(rel)
        mov     qword [rax+10H], rcx                    ; 014E _ 48: 89. 48, 10
        mov     qword [rax+18H], rbx                    ; 0152 _ 48: 89. 58, 18
        mov     rcx, qword [rel warning_state+20H]      ; 0156 _ 48: 8B. 0D, 00000000(rel)
        mov     rbx, qword [rel warning_state+28H]      ; 015D _ 48: 8B. 1D, 00000000(rel)
        mov     qword [rax+20H], rcx                    ; 0164 _ 48: 89. 48, 20
        mov     qword [rax+28H], rbx                    ; 0168 _ 48: 89. 58, 28
        mov     rcx, qword [rel warning_state+30H]      ; 016C _ 48: 8B. 0D, 00000000(rel)
        mov     rbx, qword [rel warning_state+38H]      ; 0173 _ 48: 8B. 1D, 00000000(rel)
        mov     qword [rax+30H], rcx                    ; 017A _ 48: 89. 48, 30
        mov     qword [rax+38H], rbx                    ; 017E _ 48: 89. 58, 38
; Note: Memory operand is misaligned. Performance penalty
        mov     rdx, qword [rel warning_state+3DH]      ; 0182 _ 48: 8B. 15, 00000000(rel)
        mov     qword [rax+3DH], rdx                    ; 0189 _ 48: 89. 50, 3D
        mov     rdx, qword [rel warning_stack]          ; 018D _ 48: 8B. 15, 00000000(rel)
        mov     rax, qword [rbp-18H]                    ; 0194 _ 48: 8B. 45, E8
        mov     qword [rax], rdx                        ; 0198 _ 48: 89. 10
        mov     rax, qword [rbp-18H]                    ; 019B _ 48: 8B. 45, E8
        mov     qword [rel warning_stack], rax          ; 019F _ 48: 89. 05, 00000000(rel)
        nop                                             ; 01A6 _ 90
        mov     rbx, qword [rbp-8H]                     ; 01A7 _ 48: 8B. 5D, F8
        leave                                           ; 01AB _ C9
        ret                                             ; 01AC _ C3
; push_warnings End of function

pop_warnings:; Function begin
        push    rbp                                     ; 01AD _ 55
        mov     rbp, rsp                                ; 01AE _ 48: 89. E5
        push    rbx                                     ; 01B1 _ 53
        sub     rsp, 24                                 ; 01B2 _ 48: 83. EC, 18
        mov     rax, qword [rel warning_stack]          ; 01B6 _ 48: 8B. 05, 00000000(rel)
        mov     qword [rbp-18H], rax                    ; 01BD _ 48: 89. 45, E8
        mov     rax, qword [rbp-18H]                    ; 01C1 _ 48: 8B. 45, E8
        add     rax, 8                                  ; 01C5 _ 48: 83. C0, 08
        mov     rcx, qword [rax]                        ; 01C9 _ 48: 8B. 08
        mov     rbx, qword [rax+8H]                     ; 01CC _ 48: 8B. 58, 08
        mov     qword [rel warning_state], rcx          ; 01D0 _ 48: 89. 0D, 00000000(rel)
        mov     qword [rel warning_state+8H], rbx       ; 01D7 _ 48: 89. 1D, 00000000(rel)
        mov     rcx, qword [rax+10H]                    ; 01DE _ 48: 8B. 48, 10
        mov     rbx, qword [rax+18H]                    ; 01E2 _ 48: 8B. 58, 18
        mov     qword [rel warning_state+10H], rcx      ; 01E6 _ 48: 89. 0D, 00000000(rel)
        mov     qword [rel warning_state+18H], rbx      ; 01ED _ 48: 89. 1D, 00000000(rel)
        mov     rcx, qword [rax+20H]                    ; 01F4 _ 48: 8B. 48, 20
        mov     rbx, qword [rax+28H]                    ; 01F8 _ 48: 8B. 58, 28
        mov     qword [rel warning_state+20H], rcx      ; 01FC _ 48: 89. 0D, 00000000(rel)
        mov     qword [rel warning_state+28H], rbx      ; 0203 _ 48: 89. 1D, 00000000(rel)
        mov     rcx, qword [rax+30H]                    ; 020A _ 48: 8B. 48, 30
        mov     rbx, qword [rax+38H]                    ; 020E _ 48: 8B. 58, 38
        mov     qword [rel warning_state+30H], rcx      ; 0212 _ 48: 89. 0D, 00000000(rel)
        mov     qword [rel warning_state+38H], rbx      ; 0219 _ 48: 89. 1D, 00000000(rel)
        mov     rax, qword [rax+3DH]                    ; 0220 _ 48: 8B. 40, 3D
; Note: Memory operand is misaligned. Performance penalty
        mov     qword [rel warning_state+3DH], rax      ; 0224 _ 48: 89. 05, 00000000(rel)
        mov     rax, qword [rbp-18H]                    ; 022B _ 48: 8B. 45, E8
        mov     rax, qword [rax]                        ; 022F _ 48: 8B. 00
        test    rax, rax                                ; 0232 _ 48: 85. C0
        jnz     ?_007                                   ; 0235 _ 75, 34
        mov     dword [rbp-1CH], 4259840                ; 0237 _ C7. 45, E4, 00410000
        mov     eax, dword [rbp-1CH]                    ; 023E _ 8B. 45, E4
        mov     edi, eax                                ; 0241 _ 89. C7
        call    warn_active                             ; 0243 _ E8, FFFFFDB8
        movzx   eax, al                                 ; 0248 _ 0F B6. C0
        test    rax, rax                                ; 024B _ 48: 85. C0
        jz      ?_008                                   ; 024E _ 74, 35
        lea     rdx, [rel ?_147]                        ; 0250 _ 48: 8D. 15, 00000000(rel)
        mov     eax, dword [rbp-1CH]                    ; 0257 _ 8B. 45, E4
        mov     rsi, rdx                                ; 025A _ 48: 89. D6
        mov     edi, eax                                ; 025D _ 89. C7
        mov     eax, 0                                  ; 025F _ B8, 00000000
        call    nasm_warn_                              ; 0264 _ E8, 00000000(PLT r)
        jmp     ?_008                                   ; 0269 _ EB, 1A

?_007:  mov     rax, qword [rbp-18H]                    ; 026B _ 48: 8B. 45, E8
        mov     rax, qword [rax]                        ; 026F _ 48: 8B. 00
        mov     qword [rel warning_stack], rax          ; 0272 _ 48: 89. 05, 00000000(rel)
        mov     rax, qword [rbp-18H]                    ; 0279 _ 48: 8B. 45, E8
        mov     rdi, rax                                ; 027D _ 48: 89. C7
        call    nasm_free                               ; 0280 _ E8, 00000000(PLT r)
?_008:  nop                                             ; 0285 _ 90
        mov     rbx, qword [rbp-8H]                     ; 0286 _ 48: 8B. 5D, F8
        leave                                           ; 028A _ C9
        ret                                             ; 028B _ C3
; pop_warnings End of function

init_warnings:; Local function
        push    rbp                                     ; 028C _ 55
        mov     rbp, rsp                                ; 028D _ 48: 89. E5
        call    push_warnings                           ; 0290 _ E8, 00000000(PLT r)
        mov     rax, qword [rel warning_stack]          ; 0295 _ 48: 8B. 05, 00000000(rel)
        mov     qword [rel warning_state_init], rax     ; 029C _ 48: 89. 05, 00000000(rel)
        nop                                             ; 02A3 _ 90
        pop     rbp                                     ; 02A4 _ 5D
        ret                                             ; 02A5 _ C3

error_init:; Function begin
        push    rbp                                     ; 02A6 _ 55
        mov     rbp, rsp                                ; 02A7 _ 48: 89. E5
        mov     dword [rel erropt+8H], 0                ; 02AA _ C7. 05, 00000000(rel), 00000000
        call    init_warnings                           ; 02B4 _ E8, FFFFFFD3
        nop                                             ; 02B9 _ 90
        pop     rbp                                     ; 02BA _ 5D
        ret                                             ; 02BB _ C3
; error_init End of function

error_pass_start:; Function begin
        push    rbp                                     ; 02BC _ 55
        mov     rbp, rsp                                ; 02BD _ 48: 89. E5
        sub     rsp, 16                                 ; 02C0 _ 48: 83. EC, 10
        mov     byte [rbp-1H], dil                      ; 02C4 _ 40: 88. 7D, FF
        mov     rax, qword [rel warn_list]              ; 02C8 _ 48: 8B. 05, 00000000(rel)
        test    rax, rax                                ; 02CF _ 48: 85. C0
        setne   al                                      ; 02D2 _ 0F 95. C0
        movzx   eax, al                                 ; 02D5 _ 0F B6. C0
        test    rax, rax                                ; 02D8 _ 48: 85. C0
        jz      ?_009                                   ; 02DB _ 74, 22
        lea     rdx, [rel ?_148]                        ; 02DD _ 48: 8D. 15, 00000000(rel)
        lea     rsi, [rel __func__.3]                   ; 02E4 _ 48: 8D. 35, 00000000(rel)
        lea     rax, [rel ?_149]                        ; 02EB _ 48: 8D. 05, 00000000(rel)
        mov     ecx, 87                                 ; 02F2 _ B9, 00000057
        mov     rdi, rax                                ; 02F7 _ 48: 89. C7
        call    nasm_assert_failed                      ; 02FA _ E8, 00000000(PLT r)
?_009:  mov     dword [rel erropt+8H], 0                ; 02FF _ C7. 05, 00000000(rel), 00000000
        movzx   eax, byte [rbp-1H]                      ; 0309 _ 0F B6. 45, FF
        xor     eax, 01H                                ; 030D _ 83. F0, 01
        test    al, al                                  ; 0310 _ 84. C0
        jz      ?_010                                   ; 0312 _ 74, 11
        mov     edi, 0                                  ; 0314 _ BF, 00000000
        call    strlist_alloc                           ; 0319 _ E8, 00000000(PLT r)
        mov     qword [rel warn_list], rax              ; 031E _ 48: 89. 05, 00000000(rel)
?_010:  nop                                             ; 0325 _ 90
        leave                                           ; 0326 _ C9
        ret                                             ; 0327 _ C3
; error_pass_start End of function

reset_warnings:; Local function
        push    rbp                                     ; 0328 _ 55
        mov     rbp, rsp                                ; 0329 _ 48: 89. E5
        push    rbx                                     ; 032C _ 53
        sub     rsp, 24                                 ; 032D _ 48: 83. EC, 18
        mov     rax, qword [rel warning_stack]          ; 0331 _ 48: 8B. 05, 00000000(rel)
        mov     qword [rbp-20H], rax                    ; 0338 _ 48: 89. 45, E0
        jmp     ?_012                                   ; 033C _ EB, 1F

?_011:  mov     rax, qword [rbp-20H]                    ; 033E _ 48: 8B. 45, E0
        mov     qword [rbp-18H], rax                    ; 0342 _ 48: 89. 45, E8
        mov     rax, qword [rbp-20H]                    ; 0346 _ 48: 8B. 45, E0
        mov     rax, qword [rax]                        ; 034A _ 48: 8B. 00
        mov     qword [rbp-20H], rax                    ; 034D _ 48: 89. 45, E0
        mov     rax, qword [rbp-18H]                    ; 0351 _ 48: 8B. 45, E8
        mov     rdi, rax                                ; 0355 _ 48: 89. C7
        call    nasm_free                               ; 0358 _ E8, 00000000(PLT r)
?_012:  mov     rax, qword [rbp-20H]                    ; 035D _ 48: 8B. 45, E0
        mov     rax, qword [rax]                        ; 0361 _ 48: 8B. 00
        test    rax, rax                                ; 0364 _ 48: 85. C0
        jnz     ?_011                                   ; 0367 _ 75, D5
        mov     rax, qword [rbp-20H]                    ; 0369 _ 48: 8B. 45, E0
        mov     qword [rel warning_stack], rax          ; 036D _ 48: 89. 05, 00000000(rel)
        mov     rax, qword [rbp-20H]                    ; 0374 _ 48: 8B. 45, E0
        add     rax, 8                                  ; 0378 _ 48: 83. C0, 08
        mov     rcx, qword [rax]                        ; 037C _ 48: 8B. 08
        mov     rbx, qword [rax+8H]                     ; 037F _ 48: 8B. 58, 08
        mov     qword [rel warning_state], rcx          ; 0383 _ 48: 89. 0D, 00000000(rel)
        mov     qword [rel warning_state+8H], rbx       ; 038A _ 48: 89. 1D, 00000000(rel)
        mov     rcx, qword [rax+10H]                    ; 0391 _ 48: 8B. 48, 10
        mov     rbx, qword [rax+18H]                    ; 0395 _ 48: 8B. 58, 18
        mov     qword [rel warning_state+10H], rcx      ; 0399 _ 48: 89. 0D, 00000000(rel)
        mov     qword [rel warning_state+18H], rbx      ; 03A0 _ 48: 89. 1D, 00000000(rel)
        mov     rcx, qword [rax+20H]                    ; 03A7 _ 48: 8B. 48, 20
        mov     rbx, qword [rax+28H]                    ; 03AB _ 48: 8B. 58, 28
        mov     qword [rel warning_state+20H], rcx      ; 03AF _ 48: 89. 0D, 00000000(rel)
        mov     qword [rel warning_state+28H], rbx      ; 03B6 _ 48: 89. 1D, 00000000(rel)
        mov     rcx, qword [rax+30H]                    ; 03BD _ 48: 8B. 48, 30
        mov     rbx, qword [rax+38H]                    ; 03C1 _ 48: 8B. 58, 38
        mov     qword [rel warning_state+30H], rcx      ; 03C5 _ 48: 89. 0D, 00000000(rel)
        mov     qword [rel warning_state+38H], rbx      ; 03CC _ 48: 89. 1D, 00000000(rel)
        mov     rax, qword [rax+3DH]                    ; 03D3 _ 48: 8B. 40, 3D
; Note: Memory operand is misaligned. Performance penalty
        mov     qword [rel warning_state+3DH], rax      ; 03D7 _ 48: 89. 05, 00000000(rel)
        nop                                             ; 03DE _ 90
        mov     rbx, qword [rbp-8H]                     ; 03DF _ 48: 8B. 5D, F8
        leave                                           ; 03E3 _ C9
        ret                                             ; 03E4 _ C3

error_pass_end:; Function begin
        push    rbp                                     ; 03E5 _ 55
        mov     rbp, rsp                                ; 03E6 _ 48: 89. E5
        lea     rax, [rel warn_list]                    ; 03E9 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 03F0 _ 48: 89. C7
        call    strlist_free                            ; 03F3 _ E8, 00000000(PLT r)
        call    reset_warnings                          ; 03F8 _ E8, FFFFFF2B
        nop                                             ; 03FD _ 90
        pop     rbp                                     ; 03FE _ 5D
        ret                                             ; 03FF _ C3
; error_pass_end End of function

set_warning_status:; Function begin
        push    rbp                                     ; 0400 _ 55
        mov     rbp, rsp                                ; 0401 _ 48: 89. E5
        sub     rsp, 48                                 ; 0404 _ 48: 83. EC, 30
        mov     qword [rbp-28H], rdi                    ; 0408 _ 48: 89. 7D, D8
        mov     byte [rbp-20H], 0                       ; 040C _ C6. 45, E0, 00
        mov     rax, qword [rbp-28H]                    ; 0410 _ 48: 8B. 45, D8
        mov     rdi, rax                                ; 0414 _ 48: 89. C7
        call    nasm_skip_spaces                        ; 0417 _ E8, 00000000(PLT r)
        mov     qword [rbp-28H], rax                    ; 041C _ 48: 89. 45, D8
        mov     rax, qword [rbp-28H]                    ; 0420 _ 48: 8B. 45, D8
        movzx   eax, byte [rax]                         ; 0424 _ 0F B6. 00
        movsx   eax, al                                 ; 0427 _ 0F BE. C0
        cmp     eax, 110                                ; 042A _ 83. F8, 6E
        jz      ?_016                                   ; 042D _ 74, 5E
        cmp     eax, 110                                ; 042F _ 83. F8, 6E
        jg      ?_018                                   ; 0432 _ 0F 8F, 000000AD
        cmp     eax, 78                                 ; 0438 _ 83. F8, 4E
        jz      ?_016                                   ; 043B _ 74, 50
        cmp     eax, 78                                 ; 043D _ 83. F8, 4E
        jg      ?_018                                   ; 0440 _ 0F 8F, 0000009F
        cmp     eax, 45                                 ; 0446 _ 83. F8, 2D
        jz      ?_013                                   ; 0449 _ 74, 18
        cmp     eax, 45                                 ; 044B _ 83. F8, 2D
        jg      ?_018                                   ; 044E _ 0F 8F, 00000091
        cmp     eax, 42                                 ; 0454 _ 83. F8, 2A
        jz      ?_015                                   ; 0457 _ 74, 26
        cmp     eax, 43                                 ; 0459 _ 83. F8, 2B
        jz      ?_014                                   ; 045C _ 74, 13
        jmp     ?_018                                   ; 045E _ E9, 00000082

?_013:  mov     dword [rbp-1CH], 0                      ; 0463 _ C7. 45, E4, 00000000
        add     qword [rbp-28H], 1                      ; 046A _ 48: 83. 45, D8, 01
        jmp     ?_019                                   ; 046F _ EB, 7C

?_014:  mov     dword [rbp-1CH], 1                      ; 0471 _ C7. 45, E4, 00000001
        add     qword [rbp-28H], 1                      ; 0478 _ 48: 83. 45, D8, 01
        jmp     ?_019                                   ; 047D _ EB, 6E

?_015:  mov     dword [rbp-1CH], 2                      ; 047F _ C7. 45, E4, 00000002
        add     qword [rbp-28H], 1                      ; 0486 _ 48: 83. 45, D8, 01
        jmp     ?_019                                   ; 048B _ EB, 60

?_016:  lea     rcx, [rel ?_150]                        ; 048D _ 48: 8D. 0D, 00000000(rel)
        mov     rax, qword [rbp-28H]                    ; 0494 _ 48: 8B. 45, D8
        mov     edx, 3                                  ; 0498 _ BA, 00000003
        mov     rsi, rcx                                ; 049D _ 48: 89. CE
        mov     rdi, rax                                ; 04A0 _ 48: 89. C7
        call    strncasecmp                             ; 04A3 _ E8, 00000000(PLT r)
        test    eax, eax                                ; 04A8 _ 85. C0
        jnz     ?_017                                   ; 04AA _ 75, 0E
        mov     dword [rbp-1CH], 0                      ; 04AC _ C7. 45, E4, 00000000
        add     qword [rbp-28H], 3                      ; 04B3 _ 48: 83. 45, D8, 03
        jmp     ?_019                                   ; 04B8 _ EB, 33

?_017:  lea     rdx, [rel ?_151]                        ; 04BA _ 48: 8D. 15, 00000000(rel)
        mov     rax, qword [rbp-28H]                    ; 04C1 _ 48: 8B. 45, D8
        mov     rsi, rdx                                ; 04C5 _ 48: 89. D6
        mov     rdi, rax                                ; 04C8 _ 48: 89. C7
        call    strcasecmp                              ; 04CB _ E8, 00000000(PLT r)
        test    eax, eax                                ; 04D0 _ 85. C0
        jnz     ?_018                                   ; 04D2 _ 75, 11
        mov     dword [rbp-1CH], 0                      ; 04D4 _ C7. 45, E4, 00000000
        mov     qword [rbp-28H], 0                      ; 04DB _ 48: C7. 45, D8, 00000000
        jmp     ?_019                                   ; 04E3 _ EB, 08

?_018:  mov     dword [rbp-1CH], 1                      ; 04E5 _ C7. 45, E4, 00000001
        nop                                             ; 04EC _ 90
?_019:  mov     byte [rbp-1FH], 1                       ; 04ED _ C6. 45, E1, 01
        cmp     qword [rbp-28H], 0                      ; 04F1 _ 48: 83. 7D, D8, 00
        jz      ?_022                                   ; 04F6 _ 74, 50
        lea     rcx, [rel ?_152]                        ; 04F8 _ 48: 8D. 0D, 00000000(rel)
        mov     rax, qword [rbp-28H]                    ; 04FF _ 48: 8B. 45, D8
        mov     edx, 5                                  ; 0503 _ BA, 00000005
        mov     rsi, rcx                                ; 0508 _ 48: 89. CE
        mov     rdi, rax                                ; 050B _ 48: 89. C7
        call    strncasecmp                             ; 050E _ E8, 00000000(PLT r)
        test    eax, eax                                ; 0513 _ 85. C0
        jnz     ?_022                                   ; 0515 _ 75, 31
        mov     rax, qword [rbp-28H]                    ; 0517 _ 48: 8B. 45, D8
        add     rax, 5                                  ; 051B _ 48: 83. C0, 05
        movzx   eax, byte [rax]                         ; 051F _ 0F B6. 00
        movsx   eax, al                                 ; 0522 _ 0F BE. C0
        test    eax, eax                                ; 0525 _ 85. C0
        jz      ?_020                                   ; 0527 _ 74, 10
        cmp     eax, 61                                 ; 0529 _ 83. F8, 3D
        jnz     ?_021                                   ; 052C _ 75, 19
        mov     byte [rbp-1FH], 2                       ; 052E _ C6. 45, E1, 02
        add     qword [rbp-28H], 6                      ; 0532 _ 48: 83. 45, D8, 06
        jmp     ?_022                                   ; 0537 _ EB, 0F

?_020:  mov     byte [rbp-1FH], 2                       ; 0539 _ C6. 45, E1, 02
        mov     qword [rbp-28H], 0                      ; 053D _ 48: C7. 45, D8, 00000000
        jmp     ?_022                                   ; 0545 _ EB, 01

?_021:  nop                                             ; 0547 _ 90
?_022:  cmp     qword [rbp-28H], 0                      ; 0548 _ 48: 83. 7D, D8, 00
        jz      ?_023                                   ; 054D _ 74, 22
        lea     rdx, [rel ?_153]                        ; 054F _ 48: 8D. 15, 00000000(rel)
        mov     rax, qword [rbp-28H]                    ; 0556 _ 48: 8B. 45, D8
        mov     rsi, rdx                                ; 055A _ 48: 89. D6
        mov     rdi, rax                                ; 055D _ 48: 89. C7
        call    strcasecmp                              ; 0560 _ E8, 00000000(PLT r)
        test    eax, eax                                ; 0565 _ 85. C0
        jnz     ?_023                                   ; 0567 _ 75, 08
        mov     qword [rbp-28H], 0                      ; 0569 _ 48: C7. 45, D8, 00000000
?_023:  cmp     qword [rbp-28H], 0                      ; 0571 _ 48: 83. 7D, D8, 00
        jz      ?_024                                   ; 0576 _ 74, 12
        mov     rax, qword [rbp-28H]                    ; 0578 _ 48: 8B. 45, D8
        mov     rdi, rax                                ; 057C _ 48: 89. C7
        call    strlen                                  ; 057F _ E8, 00000000(PLT r)
        mov     qword [rbp-8H], rax                     ; 0584 _ 48: 89. 45, F8
        jmp     ?_025                                   ; 0588 _ EB, 08

?_024:  mov     qword [rbp-8H], 0                       ; 058A _ 48: C7. 45, F8, 00000000
?_025:  lea     rax, [rel warning_alias+10H]            ; 0592 _ 48: 8D. 05, 00000000(rel)
        mov     qword [rbp-10H], rax                    ; 0599 _ 48: 89. 45, F0
        jmp     ?_036                                   ; 059D _ E9, 00000156

?_026:  mov     rax, qword [rbp-10H]                    ; 05A2 _ 48: 8B. 45, F0
        mov     eax, dword [rax+8H]                     ; 05A6 _ 8B. 40, 08
        mov     dword [rbp-14H], eax                    ; 05A9 _ 89. 45, EC
        cmp     qword [rbp-28H], 0                      ; 05AC _ 48: 83. 7D, D8, 00
        jz      ?_027                                   ; 05B1 _ 74, 46
        mov     rax, qword [rbp-10H]                    ; 05B3 _ 48: 8B. 45, F0
        mov     rcx, qword [rax]                        ; 05B7 _ 48: 8B. 08
        mov     rdx, qword [rbp-8H]                     ; 05BA _ 48: 8B. 55, F8
        mov     rax, qword [rbp-28H]                    ; 05BE _ 48: 8B. 45, D8
        mov     rsi, rcx                                ; 05C2 _ 48: 89. CE
        mov     rdi, rax                                ; 05C5 _ 48: 89. C7
        call    strncasecmp                             ; 05C8 _ E8, 00000000(PLT r)
        test    eax, eax                                ; 05CD _ 85. C0
        jne     ?_033                                   ; 05CF _ 0F 85, 0000011A
        mov     rax, qword [rbp-10H]                    ; 05D5 _ 48: 8B. 45, F0
        mov     rdx, qword [rax]                        ; 05D9 _ 48: 8B. 10
        mov     rax, qword [rbp-8H]                     ; 05DC _ 48: 8B. 45, F8
        add     rax, rdx                                ; 05E0 _ 48: 01. D0
        movzx   eax, byte [rax]                         ; 05E3 _ 0F B6. 00
        mov     byte [rbp-1DH], al                      ; 05E6 _ 88. 45, E3
        cmp     byte [rbp-1DH], 0                       ; 05E9 _ 80. 7D, E3, 00
        jz      ?_027                                   ; 05ED _ 74, 0A
        cmp     byte [rbp-1DH], 45                      ; 05EF _ 80. 7D, E3, 2D
        jne     ?_034                                   ; 05F3 _ 0F 85, 000000F9
?_027:  mov     byte [rbp-20H], 1                       ; 05F9 _ C6. 45, E0, 01
        cmp     dword [rbp-1CH], 2                      ; 05FD _ 83. 7D, E4, 02
        jz      ?_030                                   ; 0601 _ 74, 6C
        cmp     dword [rbp-1CH], 2                      ; 0603 _ 83. 7D, E4, 02
        ja      ?_035                                   ; 0607 _ 0F 87, 000000E6
        cmp     dword [rbp-1CH], 0                      ; 060D _ 83. 7D, E4, 00
        jz      ?_028                                   ; 0611 _ 74, 0B
        cmp     dword [rbp-1CH], 1                      ; 0613 _ 83. 7D, E4, 01
        jz      ?_029                                   ; 0617 _ 74, 31
        jmp     ?_035                                   ; 0619 _ E9, 000000D5

?_028:  mov     eax, dword [rbp-14H]                    ; 061E _ 8B. 45, EC
        lea     rdx, [rel warning_state]                ; 0621 _ 48: 8D. 15, 00000000(rel)
        movzx   eax, byte [rax+rdx]                     ; 0628 _ 0F B6. 04 10
        mov     edx, eax                                ; 062C _ 89. C2
        movzx   eax, byte [rbp-1FH]                     ; 062E _ 0F B6. 45, E1
        not     eax                                     ; 0632 _ F7. D0
        and     eax, edx                                ; 0634 _ 21. D0
        mov     ecx, eax                                ; 0636 _ 89. C1
        mov     eax, dword [rbp-14H]                    ; 0638 _ 8B. 45, EC
        lea     rdx, [rel warning_state]                ; 063B _ 48: 8D. 15, 00000000(rel)
        mov     byte [rax+rdx], cl                      ; 0642 _ 88. 0C 10
        jmp     ?_035                                   ; 0645 _ E9, 000000A9

?_029:  mov     eax, dword [rbp-14H]                    ; 064A _ 8B. 45, EC
        lea     rdx, [rel warning_state]                ; 064D _ 48: 8D. 15, 00000000(rel)
        movzx   eax, byte [rax+rdx]                     ; 0654 _ 0F B6. 04 10
        or      al, byte [rbp-1FH]                      ; 0658 _ 0A. 45, E1
        mov     edx, eax                                ; 065B _ 89. C2
        mov     eax, dword [rbp-14H]                    ; 065D _ 8B. 45, EC
        lea     rcx, [rel warning_state]                ; 0660 _ 48: 8D. 0D, 00000000(rel)
        mov     byte [rax+rcx], dl                      ; 0667 _ 88. 14 08
        jmp     ?_035                                   ; 066A _ E9, 00000084

?_030:  mov     rax, qword [rel warning_state_init]     ; 066F _ 48: 8B. 05, 00000000(rel)
        test    rax, rax                                ; 0676 _ 48: 85. C0
        jz      ?_031                                   ; 0679 _ 74, 14
        mov     rdx, qword [rel warning_state_init]     ; 067B _ 48: 8B. 15, 00000000(rel)
        mov     eax, dword [rbp-14H]                    ; 0682 _ 8B. 45, EC
        movzx   eax, byte [rdx+rax+8H]                  ; 0685 _ 0F B6. 44 02, 08
        mov     byte [rbp-1EH], al                      ; 068A _ 88. 45, E2
        jmp     ?_032                                   ; 068D _ EB, 11

?_031:  mov     eax, dword [rbp-14H]                    ; 068F _ 8B. 45, EC
        lea     rdx, [rel warning_default]              ; 0692 _ 48: 8D. 15, 00000000(rel)
        movzx   eax, byte [rax+rdx]                     ; 0699 _ 0F B6. 04 10
        mov     byte [rbp-1EH], al                      ; 069D _ 88. 45, E2
?_032:  mov     eax, dword [rbp-14H]                    ; 06A0 _ 8B. 45, EC
        lea     rdx, [rel warning_state]                ; 06A3 _ 48: 8D. 15, 00000000(rel)
        movzx   eax, byte [rax+rdx]                     ; 06AA _ 0F B6. 04 10
        mov     edx, eax                                ; 06AE _ 89. C2
        movzx   eax, byte [rbp-1FH]                     ; 06B0 _ 0F B6. 45, E1
        not     eax                                     ; 06B4 _ F7. D0
        and     eax, edx                                ; 06B6 _ 21. D0
        mov     ecx, eax                                ; 06B8 _ 89. C1
        mov     eax, dword [rbp-14H]                    ; 06BA _ 8B. 45, EC
        lea     rdx, [rel warning_state]                ; 06BD _ 48: 8D. 15, 00000000(rel)
        mov     byte [rax+rdx], cl                      ; 06C4 _ 88. 0C 10
        mov     eax, dword [rbp-14H]                    ; 06C7 _ 8B. 45, EC
        lea     rdx, [rel warning_state]                ; 06CA _ 48: 8D. 15, 00000000(rel)
        movzx   edx, byte [rax+rdx]                     ; 06D1 _ 0F B6. 14 10
        movzx   eax, byte [rbp-1EH]                     ; 06D5 _ 0F B6. 45, E2
        and     al, byte [rbp-1FH]                      ; 06D9 _ 22. 45, E1
        mov     ecx, edx                                ; 06DC _ 89. D1
        or      ecx, eax                                ; 06DE _ 09. C1
        mov     eax, dword [rbp-14H]                    ; 06E0 _ 8B. 45, EC
        lea     rdx, [rel warning_state]                ; 06E3 _ 48: 8D. 15, 00000000(rel)
        mov     byte [rax+rdx], cl                      ; 06EA _ 88. 0C 10
        jmp     ?_035                                   ; 06ED _ EB, 04

?_033:  nop                                             ; 06EF _ 90
        jmp     ?_035                                   ; 06F0 _ EB, 01

?_034:  nop                                             ; 06F2 _ 90
?_035:  add     qword [rbp-10H], 16                     ; 06F3 _ 48: 83. 45, F0, 10
?_036:  lea     rax, [rel warning_alias+550H]           ; 06F8 _ 48: 8D. 05, 00000000(rel)
        cmp     qword [rbp-10H], rax                    ; 06FF _ 48: 39. 45, F0
        jc      ?_026                                   ; 0703 _ 0F 82, FFFFFE99
        movzx   eax, byte [rbp-20H]                     ; 0709 _ 0F B6. 45, E0
        xor     eax, 01H                                ; 070D _ 83. F0, 01
        test    al, al                                  ; 0710 _ 84. C0
        jz      ?_037                                   ; 0712 _ 74, 3D
        cmp     qword [rbp-28H], 0                      ; 0714 _ 48: 83. 7D, D8, 00
        jz      ?_037                                   ; 0719 _ 74, 36
        mov     dword [rbp-18H], 4128768                ; 071B _ C7. 45, E8, 003F0000
        mov     eax, dword [rbp-18H]                    ; 0722 _ 8B. 45, E8
        mov     edi, eax                                ; 0725 _ 89. C7
        call    warn_active                             ; 0727 _ E8, FFFFF8D4
        movzx   eax, al                                 ; 072C _ 0F B6. C0
        test    rax, rax                                ; 072F _ 48: 85. C0
        jz      ?_037                                   ; 0732 _ 74, 1D
        mov     rdx, qword [rbp-28H]                    ; 0734 _ 48: 8B. 55, D8
        lea     rcx, [rel ?_154]                        ; 0738 _ 48: 8D. 0D, 00000000(rel)
        mov     eax, dword [rbp-18H]                    ; 073F _ 8B. 45, E8
        mov     rsi, rcx                                ; 0742 _ 48: 89. CE
        mov     edi, eax                                ; 0745 _ 89. C7
        mov     eax, 0                                  ; 0747 _ B8, 00000000
        call    nasm_warn_                              ; 074C _ E8, 00000000(PLT r)
?_037:  movzx   eax, byte [rbp-20H]                     ; 0751 _ 0F B6. 45, E0
        leave                                           ; 0755 _ C9
        ret                                             ; 0756 _ C3
; set_warning_status End of function

error_pfx:; Function begin
        push    rbp                                     ; 0757 _ 55
        mov     rbp, rsp                                ; 0758 _ 48: 89. E5
        mov     dword [rbp-4H], edi                     ; 075B _ 89. 7D, FC
        mov     eax, dword [rbp-4H]                     ; 075E _ 8B. 45, FC
        and     eax, 0FH                                ; 0761 _ 83. E0, 0F
        cmp     eax, 15                                 ; 0764 _ 83. F8, 0F
        je      ?_046                                   ; 0767 _ 0F 84, 000000A4
        cmp     eax, 15                                 ; 076D _ 83. F8, 0F
        ja      ?_047                                   ; 0770 _ 0F 87, 000000A4
        cmp     eax, 14                                 ; 0776 _ 83. F8, 0E
        je      ?_045                                   ; 0779 _ 0F 84, 00000089
        cmp     eax, 14                                 ; 077F _ 83. F8, 0E
        ja      ?_047                                   ; 0782 _ 0F 87, 00000092
        cmp     eax, 12                                 ; 0788 _ 83. F8, 0C
        jz      ?_044                                   ; 078B _ 74, 72
        cmp     eax, 12                                 ; 078D _ 83. F8, 0C
        ja      ?_047                                   ; 0790 _ 0F 87, 00000084
        cmp     eax, 8                                  ; 0796 _ 83. F8, 08
        jz      ?_043                                   ; 0799 _ 74, 5B
        cmp     eax, 8                                  ; 079B _ 83. F8, 08
        ja      ?_047                                   ; 079E _ 77, 7A
        cmp     eax, 6                                  ; 07A0 _ 83. F8, 06
        jz      ?_042                                   ; 07A3 _ 74, 48
        cmp     eax, 6                                  ; 07A5 _ 83. F8, 06
        ja      ?_047                                   ; 07A8 _ 77, 70
        cmp     eax, 5                                  ; 07AA _ 83. F8, 05
        jz      ?_041                                   ; 07AD _ 74, 35
        cmp     eax, 5                                  ; 07AF _ 83. F8, 05
        ja      ?_047                                   ; 07B2 _ 77, 66
        cmp     eax, 4                                  ; 07B4 _ 83. F8, 04
        jz      ?_040                                   ; 07B7 _ 74, 22
        cmp     eax, 4                                  ; 07B9 _ 83. F8, 04
        ja      ?_047                                   ; 07BC _ 77, 5C
        test    eax, eax                                ; 07BE _ 85. C0
        jz      ?_038                                   ; 07C0 _ 74, 07
        cmp     eax, 1                                  ; 07C2 _ 83. F8, 01
        jz      ?_039                                   ; 07C5 _ 74, 0B
        jmp     ?_047                                   ; 07C7 _ EB, 51

?_038:  lea     rax, [rel ?_155]                        ; 07C9 _ 48: 8D. 05, 00000000(rel)
        jmp     ?_048                                   ; 07D0 _ EB, 4F

?_039:  lea     rax, [rel ?_156]                        ; 07D2 _ 48: 8D. 05, 00000000(rel)
        jmp     ?_048                                   ; 07D9 _ EB, 46

?_040:  lea     rax, [rel ?_157]                        ; 07DB _ 48: 8D. 05, 00000000(rel)
        jmp     ?_048                                   ; 07E2 _ EB, 3D

?_041:  lea     rax, [rel ?_158]                        ; 07E4 _ 48: 8D. 05, 00000000(rel)
        jmp     ?_048                                   ; 07EB _ EB, 34

?_042:  lea     rax, [rel ?_159]                        ; 07ED _ 48: 8D. 05, 00000000(rel)
        jmp     ?_048                                   ; 07F4 _ EB, 2B

?_043:  lea     rax, [rel ?_160]                        ; 07F6 _ 48: 8D. 05, 00000000(rel)
        jmp     ?_048                                   ; 07FD _ EB, 22

?_044:  lea     rax, [rel ?_161]                        ; 07FF _ 48: 8D. 05, 00000000(rel)
        jmp     ?_048                                   ; 0806 _ EB, 19

?_045:  lea     rax, [rel ?_162]                        ; 0808 _ 48: 8D. 05, 00000000(rel)
        jmp     ?_048                                   ; 080F _ EB, 10

?_046:  lea     rax, [rel ?_163]                        ; 0811 _ 48: 8D. 05, 00000000(rel)
        jmp     ?_048                                   ; 0818 _ EB, 07

?_047:  lea     rax, [rel ?_164]                        ; 081A _ 48: 8D. 05, 00000000(rel)
?_048:  pop     rbp                                     ; 0821 _ 5D
        ret                                             ; 0822 _ C3
; error_pfx End of function

skip_this_pass:; Local function
        push    rbp                                     ; 0823 _ 55
        mov     rbp, rsp                                ; 0824 _ 48: 89. E5
        sub     rsp, 24                                 ; 0827 _ 48: 83. EC, 18
        mov     dword [rbp-14H], edi                    ; 082B _ 89. 7D, EC
        mov     eax, dword [rbp-14H]                    ; 082E _ 8B. 45, EC
        and     eax, 0FH                                ; 0831 _ 83. E0, 0F
        mov     dword [rbp-4H], eax                     ; 0834 _ 89. 45, FC
        cmp     dword [rbp-4H], 11                      ; 0837 _ 83. 7D, FC, 0B
        jbe     ?_049                                   ; 083B _ 76, 07
        mov     eax, 0                                  ; 083D _ B8, 00000000
        jmp     ?_053                                   ; 0842 _ EB, 34

?_049:  cmp     dword [rbp-4H], 1                       ; 0844 _ 83. 7D, FC, 01
        ja      ?_050                                   ; 0848 _ 77, 07
        mov     eax, 1                                  ; 084A _ B8, 00000001
        jmp     ?_053                                   ; 084F _ EB, 27

?_050:  mov     eax, dword [rbp-14H]                    ; 0851 _ 8B. 45, EC
        and     eax, 100H                               ; 0854 _ 25, 00000100
        test    eax, eax                                ; 0859 _ 85. C0
        jz      ?_051                                   ; 085B _ 74, 13
        call    pass_final_or_preproc                   ; 085D _ E8, FFFFF881
        xor     eax, 01H                                ; 0862 _ 83. F0, 01
        test    al, al                                  ; 0865 _ 84. C0
        jz      ?_051                                   ; 0867 _ 74, 07
        mov     eax, 1                                  ; 0869 _ B8, 00000001
        jmp     ?_052                                   ; 086E _ EB, 05

?_051:  mov     eax, 0                                  ; 0870 _ B8, 00000000
?_052:  and     eax, 01H                                ; 0875 _ 83. E0, 01
?_053:  leave                                           ; 0878 _ C9
        ret                                             ; 0879 _ C3

is_suppressed:; Local function
        push    rbp                                     ; 087A _ 55
        mov     rbp, rsp                                ; 087B _ 48: 89. E5
        sub     rsp, 32                                 ; 087E _ 48: 83. EC, 20
        mov     dword [rbp-14H], edi                    ; 0882 _ 89. 7D, EC
        mov     eax, dword [rbp-14H]                    ; 0885 _ 8B. 45, EC
        and     eax, 0FH                                ; 0888 _ 83. E0, 0F
        mov     dword [rbp-8H], eax                     ; 088B _ 89. 45, F8
        mov     eax, dword [rbp-14H]                    ; 088E _ 8B. 45, EC
        shr     eax, 16                                 ; 0891 _ C1. E8, 10
        mov     dword [rbp-4H], eax                     ; 0894 _ 89. 45, FC
        cmp     dword [rbp-8H], 11                      ; 0897 _ 83. 7D, F8, 0B
        jbe     ?_054                                   ; 089B _ 76, 0A
        mov     eax, 0                                  ; 089D _ B8, 00000000
        jmp     ?_065                                   ; 08A2 _ E9, 000000A7

?_054:  mov     eax, dword [rel erropt+0CH]             ; 08A7 _ 8B. 05, 00000000(rel)
        and     eax, dword [rbp-14H]                    ; 08AD _ 23. 45, EC
        test    eax, eax                                ; 08B0 _ 85. C0
        jz      ?_055                                   ; 08B2 _ 74, 0A
        mov     eax, 1                                  ; 08B4 _ B8, 00000001
        jmp     ?_065                                   ; 08B9 _ E9, 00000090

?_055:  cmp     dword [rbp-8H], 6                       ; 08BE _ 83. 7D, F8, 06
        jz      ?_056                                   ; 08C2 _ 74, 14
        cmp     dword [rbp-8H], 6                       ; 08C4 _ 83. 7D, F8, 06
        ja      ?_059                                   ; 08C8 _ 77, 5D
        cmp     dword [rbp-8H], 4                       ; 08CA _ 83. 7D, F8, 04
        jz      ?_058                                   ; 08CE _ 74, 3F
        cmp     dword [rbp-8H], 5                       ; 08D0 _ 83. 7D, F8, 05
        jz      ?_057                                   ; 08D4 _ 74, 21
        jmp     ?_059                                   ; 08D6 _ EB, 4F

?_056:  mov     eax, dword [rbp-4H]                     ; 08D8 _ 8B. 45, FC
        lea     rdx, [rel warning_state]                ; 08DB _ 48: 8D. 15, 00000000(rel)
        movzx   eax, byte [rax+rdx]                     ; 08E2 _ 0F B6. 04 10
        movzx   eax, al                                 ; 08E6 _ 0F B6. C0
        and     eax, 01H                                ; 08E9 _ 83. E0, 01
        test    eax, eax                                ; 08EC _ 85. C0
        jnz     ?_060                                   ; 08EE _ 75, 3A
        mov     eax, 1                                  ; 08F0 _ B8, 00000001
        jmp     ?_065                                   ; 08F5 _ EB, 57

?_057:  mov     eax, dword [rbp-4H]                     ; 08F7 _ 8B. 45, FC
        mov     edi, eax                                ; 08FA _ 89. C7
        call    info_level                              ; 08FC _ E8, FFFFF750
        xor     eax, 01H                                ; 0901 _ 83. F0, 01
        test    al, al                                  ; 0904 _ 84. C0
        jz      ?_061                                   ; 0906 _ 74, 25
        mov     eax, 1                                  ; 0908 _ B8, 00000001
        jmp     ?_065                                   ; 090D _ EB, 3F

?_058:  mov     eax, dword [rbp-4H]                     ; 090F _ 8B. 45, FC
        mov     edi, eax                                ; 0912 _ 89. C7
        call    debug_level                             ; 0914 _ E8, FFFFF71A
        xor     eax, 01H                                ; 0919 _ 83. F0, 01
        test    al, al                                  ; 091C _ 84. C0
        jz      ?_062                                   ; 091E _ 74, 10
        mov     eax, 1                                  ; 0920 _ B8, 00000001
        jmp     ?_065                                   ; 0925 _ EB, 27

?_059:  nop                                             ; 0927 _ 90
        jmp     ?_063                                   ; 0928 _ EB, 07

?_060:  nop                                             ; 092A _ 90
        jmp     ?_063                                   ; 092B _ EB, 04

?_061:  nop                                             ; 092D _ 90
        jmp     ?_063                                   ; 092E _ EB, 01

?_062:  nop                                             ; 0930 _ 90
?_063:  mov     eax, dword [rbp-14H]                    ; 0931 _ 8B. 45, EC
        and     eax, 800H                               ; 0934 _ 25, 00000800
        test    eax, eax                                ; 0939 _ 85. C0
        jnz     ?_064                                   ; 093B _ 75, 0C
        mov     eax, dword [rbp-14H]                    ; 093D _ 8B. 45, EC
        mov     edi, eax                                ; 0940 _ 89. C7
        call    pp_suppress_error                       ; 0942 _ E8, 00000000(PLT r)
        jmp     ?_065                                   ; 0947 _ EB, 05

?_064:  mov     eax, 0                                  ; 0949 _ B8, 00000000
?_065:  leave                                           ; 094E _ C9
        ret                                             ; 094F _ C3

true_error_type:; Local function
        push    rbp                                     ; 0950 _ 55
        mov     rbp, rsp                                ; 0951 _ 48: 89. E5
        mov     dword [rbp-14H], edi                    ; 0954 _ 89. 7D, EC
        mov     byte [rbp-6H], 3                        ; 0957 _ C6. 45, FA, 03
        mov     eax, dword [rbp-14H]                    ; 095B _ 8B. 45, EC
        and     eax, 0FH                                ; 095E _ 83. E0, 0F
        mov     dword [rbp-4H], eax                     ; 0961 _ 89. 45, FC
        cmp     dword [rbp-4H], 6                       ; 0964 _ 83. 7D, FC, 06
        jnz     ?_066                                   ; 0968 _ 75, 29
        mov     eax, dword [rbp-14H]                    ; 096A _ 8B. 45, EC
        shr     eax, 16                                 ; 096D _ C1. E8, 10
        mov     edx, eax                                ; 0970 _ 89. C2
        lea     rax, [rel warning_state]                ; 0972 _ 48: 8D. 05, 00000000(rel)
        movzx   eax, byte [rdx+rax]                     ; 0979 _ 0F B6. 04 02
        mov     byte [rbp-5H], al                       ; 097D _ 88. 45, FB
        movzx   eax, byte [rbp-5H]                      ; 0980 _ 0F B6. 45, FB
        and     al, byte [rbp-6H]                       ; 0984 _ 22. 45, FA
        cmp     byte [rbp-6H], al                       ; 0987 _ 38. 45, FA
        jnz     ?_066                                   ; 098A _ 75, 07
        mov     dword [rbp-4H], 8                       ; 098C _ C7. 45, FC, 00000008
?_066:  mov     eax, dword [rbp-4H]                     ; 0993 _ 8B. 45, FC
        pop     rbp                                     ; 0996 _ 5D
        ret                                             ; 0997 _ C3

die_hard:; Local function
        push    rbp                                     ; 0998 _ 55
        mov     rbp, rsp                                ; 0999 _ 48: 89. E5
        sub     rsp, 16                                 ; 099C _ 48: 83. EC, 10
        mov     dword [rbp-4H], edi                     ; 09A0 _ 89. 7D, FC
        mov     dword [rbp-8H], esi                     ; 09A3 _ 89. 75, F8
        cmp     dword [rbp-4H], 14                      ; 09A6 _ 83. 7D, FC, 0E
        jbe     ?_067                                   ; 09AA _ 76, 0E
        movzx   eax, byte [rel erropt+18H]              ; 09AC _ 0F B6. 05, 00000000(rel)
        xor     eax, 01H                                ; 09B3 _ 83. F0, 01
        test    al, al                                  ; 09B6 _ 84. C0
        jz      ?_070                                   ; 09B8 _ 74, 4F
?_067:  cmp     dword [rbp-4H], 13                      ; 09BA _ 83. 7D, FC, 0D
        ja      ?_068                                   ; 09BE _ 77, 17
        mov     edi, 1                                  ; 09C0 _ BF, 00000001
        call    print_final_report                      ; 09C5 _ E8, 00000000(PLT r)
        mov     rax, qword [rel lfmt]                   ; 09CA _ 48: 8B. 05, 00000000(rel)
        mov     rax, qword [rax+8H]                     ; 09D1 _ 48: 8B. 40, 08
        call    rax                                     ; 09D5 _ FF. D0
?_068:  mov     edi, 0                                  ; 09D7 _ BF, 00000000
        call    fflush                                  ; 09DC _ E8, 00000000(PLT r)
        mov     edi, 1                                  ; 09E1 _ BF, 00000001
        call    close_output                            ; 09E6 _ E8, 00000000(PLT r)
        mov     eax, dword [rbp-8H]                     ; 09EB _ 8B. 45, F8
        and     eax, 80H                                ; 09EE _ 25, 00000080
        test    eax, eax                                ; 09F3 _ 85. C0
        jz      ?_069                                   ; 09F5 _ 74, 05
        call    usage                                   ; 09F7 _ E8, 00000BFF
?_069:  mov     eax, dword [rbp-4H]                     ; 09FC _ 8B. 45, FC
        sub     eax, 11                                 ; 09FF _ 83. E8, 0B
        mov     edi, eax                                ; 0A02 _ 89. C7
        call    exit                                    ; 0A04 _ E8, 00000000(PLT r)
?_070:  call    abort                                   ; 0A09 _ E8, 00000000(PLT r)
error_where:
        push    rbp                                     ; 0A0E _ 55
        mov     rbp, rsp                                ; 0A0F _ 48: 89. E5
        sub     rsp, 48                                 ; 0A12 _ 48: 83. EC, 30
        mov     dword [rbp-24H], edi                    ; 0A16 _ 89. 7D, DC
        mov     eax, dword [rbp-24H]                    ; 0A19 _ 8B. 45, DC
        and     eax, 20H                                ; 0A1C _ 83. E0, 20
        test    eax, eax                                ; 0A1F _ 85. C0
        jz      ?_071                                   ; 0A21 _ 74, 11
        mov     qword [rbp-10H], 0                      ; 0A23 _ 48: C7. 45, F0, 00000000
        mov     dword [rbp-8H], 0                       ; 0A2B _ C7. 45, F8, 00000000
        jmp     ?_076                                   ; 0A32 _ EB, 5A

?_071:  call    src_where_error                         ; 0A34 _ E8, FFFFF68A
        mov     qword [rbp-10H], rax                    ; 0A39 _ 48: 89. 45, F0
        mov     qword [rbp-8H], rdx                     ; 0A3D _ 48: 89. 55, F8
        mov     rax, qword [rbp-10H]                    ; 0A41 _ 48: 8B. 45, F0
        test    rax, rax                                ; 0A45 _ 48: 85. C0
        jnz     ?_076                                   ; 0A48 _ 75, 44
        mov     dword [rbp-1CH], 0                      ; 0A4A _ C7. 45, E4, 00000000
        jmp     ?_074                                   ; 0A51 _ EB, 2E

?_072:  mov     eax, dword [rbp-1CH]                    ; 0A53 _ 8B. 45, E4
        mov     edi, eax                                ; 0A56 _ 89. C7
        call    get_filename                            ; 0A58 _ E8, FFFFF612
        mov     qword [rbp-18H], rax                    ; 0A5D _ 48: 89. 45, E8
        cmp     qword [rbp-18H], 0                      ; 0A61 _ 48: 83. 7D, E8, 00
        jz      ?_073                                   ; 0A66 _ 74, 15
        mov     rax, qword [rbp-18H]                    ; 0A68 _ 48: 8B. 45, E8
        movzx   eax, byte [rax]                         ; 0A6C _ 0F B6. 00
        test    al, al                                  ; 0A6F _ 84. C0
        jz      ?_073                                   ; 0A71 _ 74, 0A
        mov     rax, qword [rbp-18H]                    ; 0A73 _ 48: 8B. 45, E8
        mov     qword [rbp-10H], rax                    ; 0A77 _ 48: 89. 45, F0
        jmp     ?_075                                   ; 0A7B _ EB, 0A

?_073:  add     dword [rbp-1CH], 1                      ; 0A7D _ 83. 45, E4, 01
?_074:  cmp     dword [rbp-1CH], 1                      ; 0A81 _ 83. 7D, E4, 01
        jbe     ?_072                                   ; 0A85 _ 76, CC
?_075:  mov     dword [rbp-8H], 0                       ; 0A87 _ C7. 45, F8, 00000000
?_076:  mov     rax, qword [rbp-10H]                    ; 0A8E _ 48: 8B. 45, F0
        mov     rdx, qword [rbp-8H]                     ; 0A92 _ 48: 8B. 55, F8
        leave                                           ; 0A96 _ C9
        ret                                             ; 0A97 _ C3

nasm_verror_critical:; Function begin
        push    rbp                                     ; 0A98 _ 55
        mov     rbp, rsp                                ; 0A99 _ 48: 89. E5
        push    rbx                                     ; 0A9C _ 53
        sub     rsp, 72                                 ; 0A9D _ 48: 83. EC, 48
        mov     dword [rbp-34H], edi                    ; 0AA1 _ 89. 7D, CC
        mov     qword [rbp-40H], rsi                    ; 0AA4 _ 48: 89. 75, C0
        mov     qword [rbp-48H], rdx                    ; 0AA8 _ 48: 89. 55, B8
        mov     eax, dword [rbp-34H]                    ; 0AAC _ 8B. 45, CC
        and     eax, 0FH                                ; 0AAF _ 83. E0, 0F
        mov     dword [rbp-24H], eax                    ; 0AB2 _ 89. 45, DC
        nop                                             ; 0AB5 _ 90
        movzx   eax, byte [rel been_here.1]             ; 0AB6 _ 0F B6. 05, 00000000(rel)
        movzx   eax, al                                 ; 0ABD _ 0F B6. C0
        test    rax, rax                                ; 0AC0 _ 48: 85. C0
        jz      ?_077                                   ; 0AC3 _ 74, 05
        call    abort                                   ; 0AC5 _ E8, 00000000(PLT r)
?_077:  mov     byte [rel been_here.1], 1               ; 0ACA _ C6. 05, 00000000(rel), 01
        mov     eax, dword [rbp-24H]                    ; 0AD1 _ 8B. 45, DC
        mov     dword [rel erropt+8H], eax              ; 0AD4 _ 89. 05, 00000000(rel)
        mov     eax, dword [rbp-34H]                    ; 0ADA _ 8B. 45, CC
        mov     edi, eax                                ; 0ADD _ 89. C7
        call    error_where                             ; 0ADF _ E8, FFFFFF2A
        mov     qword [rbp-20H], rax                    ; 0AE4 _ 48: 89. 45, E0
        mov     qword [rbp-18H], rdx                    ; 0AE8 _ 48: 89. 55, E8
        mov     rax, qword [rbp-20H]                    ; 0AEC _ 48: 8B. 45, E0
        test    rax, rax                                ; 0AF0 _ 48: 85. C0
        jnz     ?_078                                   ; 0AF3 _ 75, 0B
        lea     rax, [rel no_file_name]                 ; 0AF5 _ 48: 8D. 05, 00000000(rel)
        mov     qword [rbp-20H], rax                    ; 0AFC _ 48: 89. 45, E0
?_078:  mov     rbx, qword [rel erropt]                 ; 0B00 _ 48: 8B. 1D, 00000000(rel)
        mov     eax, dword [rbp-34H]                    ; 0B07 _ 8B. 45, CC
        mov     edi, eax                                ; 0B0A _ 89. C7
        call    error_pfx                               ; 0B0C _ E8, 00000000(PLT r)
        mov     rsi, rbx                                ; 0B11 _ 48: 89. DE
        mov     rdi, rax                                ; 0B14 _ 48: 89. C7
        call    fputs                                   ; 0B17 _ E8, 00000000(PLT r)
        mov     rdx, qword [rel erropt]                 ; 0B1C _ 48: 8B. 15, 00000000(rel)
        mov     rax, qword [rbp-20H]                    ; 0B23 _ 48: 8B. 45, E0
        mov     rsi, rdx                                ; 0B27 _ 48: 89. D6
        mov     rdi, rax                                ; 0B2A _ 48: 89. C7
        call    fputs                                   ; 0B2D _ E8, 00000000(PLT r)
        mov     eax, dword [rbp-18H]                    ; 0B32 _ 8B. 45, E8
        test    eax, eax                                ; 0B35 _ 85. C0
        jz      ?_079                                   ; 0B37 _ 74, 36
        mov     rax, qword [rel errfmt]                 ; 0B39 _ 48: 8B. 05, 00000000(rel)
        mov     rdi, qword [rax+8H]                     ; 0B40 _ 48: 8B. 78, 08
        mov     ecx, dword [rbp-18H]                    ; 0B44 _ 8B. 4D, E8
        mov     rax, qword [rel errfmt]                 ; 0B47 _ 48: 8B. 05, 00000000(rel)
        mov     rdx, qword [rax]                        ; 0B4E _ 48: 8B. 10
        mov     rax, qword [rel erropt]                 ; 0B51 _ 48: 8B. 05, 00000000(rel)
        lea     rsi, [rel ?_165]                        ; 0B58 _ 48: 8D. 35, 00000000(rel)
        mov     r8, rdi                                 ; 0B5F _ 49: 89. F8
        mov     rdi, rax                                ; 0B62 _ 48: 89. C7
        mov     eax, 0                                  ; 0B65 _ B8, 00000000
        call    fprintf                                 ; 0B6A _ E8, 00000000(PLT r)
?_079:  mov     rdx, qword [rel erropt]                 ; 0B6F _ 48: 8B. 15, 00000000(rel)
        mov     rax, qword [rel errfmt]                 ; 0B76 _ 48: 8B. 05, 00000000(rel)
        mov     rax, qword [rax+10H]                    ; 0B7D _ 48: 8B. 40, 10
        mov     rsi, rdx                                ; 0B81 _ 48: 89. D6
        mov     rdi, rax                                ; 0B84 _ 48: 89. C7
        call    fputs                                   ; 0B87 _ E8, 00000000(PLT r)
        mov     rax, qword [rel erropt]                 ; 0B8C _ 48: 8B. 05, 00000000(rel)
        mov     rdx, qword [rbp-48H]                    ; 0B93 _ 48: 8B. 55, B8
        mov     rcx, qword [rbp-40H]                    ; 0B97 _ 48: 8B. 4D, C0
        mov     rsi, rcx                                ; 0B9B _ 48: 89. CE
        mov     rdi, rax                                ; 0B9E _ 48: 89. C7
        call    vfprintf                                ; 0BA1 _ E8, 00000000(PLT r)
        mov     rax, qword [rel erropt]                 ; 0BA6 _ 48: 8B. 05, 00000000(rel)
        mov     rsi, rax                                ; 0BAD _ 48: 89. C6
        mov     edi, 10                                 ; 0BB0 _ BF, 0000000A
        call    fputc                                   ; 0BB5 _ E8, 00000000(PLT r)
        mov     edx, dword [rbp-34H]                    ; 0BBA _ 8B. 55, CC
        mov     eax, dword [rbp-24H]                    ; 0BBD _ 8B. 45, DC
        mov     esi, edx                                ; 0BC0 _ 89. D6
        mov     edi, eax                                ; 0BC2 _ 89. C7
        call    die_hard                                ; 0BC4 _ E8, FFFFFDCF
nasm_free_error:
        push    rbp                                     ; 0BC9 _ 55
        mov     rbp, rsp                                ; 0BCA _ 48: 89. E5
        sub     rsp, 16                                 ; 0BCD _ 48: 83. EC, 10
        mov     qword [rbp-8H], rdi                     ; 0BD1 _ 48: 89. 7D, F8
        mov     rax, qword [rbp-8H]                     ; 0BD5 _ 48: 8B. 45, F8
        mov     rax, qword [rax+8H]                     ; 0BD9 _ 48: 8B. 40, 08
        mov     rdi, rax                                ; 0BDD _ 48: 89. C7
        call    nasm_free                               ; 0BE0 _ E8, 00000000(PLT r)
        mov     rax, qword [rbp-8H]                     ; 0BE5 _ 48: 8B. 45, F8
        mov     rdi, rax                                ; 0BE9 _ 48: 89. C7
        call    nasm_free                               ; 0BEC _ E8, 00000000(PLT r)
        nop                                             ; 0BF1 _ 90
        leave                                           ; 0BF2 _ C9
        ret                                             ; 0BF3 _ C3
; nasm_verror_critical End of function

nasm_error_hold_push:; Function begin
        push    rbp                                     ; 0BF4 _ 55
        mov     rbp, rsp                                ; 0BF5 _ 48: 89. E5
        sub     rsp, 16                                 ; 0BF8 _ 48: 83. EC, 10
        mov     edi, 24                                 ; 0BFC _ BF, 00000018
        call    nasm_zalloc                             ; 0C01 _ E8, 00000000(PLT r)
        mov     qword [rbp-8H], rax                     ; 0C06 _ 48: 89. 45, F8
        mov     rdx, qword [rel errhold_stack]          ; 0C0A _ 48: 8B. 15, 00000000(rel)
        mov     rax, qword [rbp-8H]                     ; 0C11 _ 48: 8B. 45, F8
        mov     qword [rax], rdx                        ; 0C15 _ 48: 89. 10
        mov     rax, qword [rbp-8H]                     ; 0C18 _ 48: 8B. 45, F8
        lea     rdx, [rax+8H]                           ; 0C1C _ 48: 8D. 50, 08
        mov     rax, qword [rbp-8H]                     ; 0C20 _ 48: 8B. 45, F8
        mov     qword [rax+10H], rdx                    ; 0C24 _ 48: 89. 50, 10
        mov     rax, qword [rbp-8H]                     ; 0C28 _ 48: 8B. 45, F8
        mov     qword [rel errhold_stack], rax          ; 0C2C _ 48: 89. 05, 00000000(rel)
        mov     rax, qword [rbp-8H]                     ; 0C33 _ 48: 8B. 45, F8
        leave                                           ; 0C37 _ C9
        ret                                             ; 0C38 _ C3
; nasm_error_hold_push End of function

nasm_error_hold_pop:; Function begin
        push    rbp                                     ; 0C39 _ 55
        mov     rbp, rsp                                ; 0C3A _ 48: 89. E5
        sub     rsp, 48                                 ; 0C3D _ 48: 83. EC, 30
        mov     qword [rbp-28H], rdi                    ; 0C41 _ 48: 89. 7D, D8
        mov     byte [rbp-29H], sil                     ; 0C45 _ 40: 88. 75, D7
        mov     dword [rbp-14H], 0                      ; 0C49 _ C7. 45, EC, 00000000
        cmp     qword [rbp-28H], 0                      ; 0C50 _ 48: 83. 7D, D8, 00
        jnz     ?_080                                   ; 0C55 _ 75, 08
        mov     eax, dword [rbp-14H]                    ; 0C57 _ 8B. 45, EC
        jmp     ?_095                                   ; 0C5A _ E9, 0000019A

?_080:  mov     rax, qword [rel errhold_stack]          ; 0C5F _ 48: 8B. 05, 00000000(rel)
        cmp     qword [rbp-28H], rax                    ; 0C66 _ 48: 39. 45, D8
        setne   al                                      ; 0C6A _ 0F 95. C0
        movzx   eax, al                                 ; 0C6D _ 0F B6. C0
        test    rax, rax                                ; 0C70 _ 48: 85. C0
        jz      ?_081                                   ; 0C73 _ 74, 22
        lea     rdx, [rel ?_148]                        ; 0C75 _ 48: 8D. 15, 00000000(rel)
        lea     rsi, [rel __func__.0]                   ; 0C7C _ 48: 8D. 35, 00000000(rel)
        lea     rax, [rel ?_166]                        ; 0C83 _ 48: 8D. 05, 00000000(rel)
        mov     ecx, 526                                ; 0C8A _ B9, 0000020E
        mov     rdi, rax                                ; 0C8F _ 48: 89. C7
        call    nasm_assert_failed                      ; 0C92 _ E8, 00000000(PLT r)
?_081:  mov     rax, qword [rbp-28H]                    ; 0C97 _ 48: 8B. 45, D8
        mov     rax, qword [rax+8H]                     ; 0C9B _ 48: 8B. 40, 08
        test    rax, rax                                ; 0C9F _ 48: 85. C0
        je      ?_094                                   ; 0CA2 _ 0F 84, 00000134
        cmp     byte [rbp-29H], 0                       ; 0CA8 _ 80. 7D, D7, 00
        je      ?_088                                   ; 0CAC _ 0F 84, 000000B3
        mov     rax, qword [rbp-28H]                    ; 0CB2 _ 48: 8B. 45, D8
        mov     rax, qword [rax]                        ; 0CB6 _ 48: 8B. 00
        test    rax, rax                                ; 0CB9 _ 48: 85. C0
        jz      ?_082                                   ; 0CBC _ 74, 2E
        mov     rax, qword [rbp-28H]                    ; 0CBE _ 48: 8B. 45, D8
        mov     rax, qword [rax]                        ; 0CC2 _ 48: 8B. 00
        mov     rax, qword [rax+10H]                    ; 0CC5 _ 48: 8B. 40, 10
        mov     rdx, qword [rbp-28H]                    ; 0CC9 _ 48: 8B. 55, D8
        mov     rdx, qword [rdx+8H]                     ; 0CCD _ 48: 8B. 52, 08
        mov     qword [rax], rdx                        ; 0CD1 _ 48: 89. 10
        mov     rax, qword [rbp-28H]                    ; 0CD4 _ 48: 8B. 45, D8
        mov     rax, qword [rax]                        ; 0CD8 _ 48: 8B. 00
        mov     rdx, qword [rbp-28H]                    ; 0CDB _ 48: 8B. 55, D8
        mov     rdx, qword [rdx+10H]                    ; 0CDF _ 48: 8B. 52, 10
        mov     qword [rax+10H], rdx                    ; 0CE3 _ 48: 89. 50, 10
        jmp     ?_094                                   ; 0CE7 _ E9, 000000F0

?_082:  mov     rax, qword [rbp-28H]                    ; 0CEC _ 48: 8B. 45, D8
        mov     rax, qword [rax+8H]                     ; 0CF0 _ 48: 8B. 40, 08
        mov     qword [rbp-10H], rax                    ; 0CF4 _ 48: 89. 45, F0
        cmp     qword [rbp-10H], 0                      ; 0CF8 _ 48: 83. 7D, F0, 00
        jz      ?_083                                   ; 0CFD _ 74, 0D
        mov     rax, qword [rbp-10H]                    ; 0CFF _ 48: 8B. 45, F0
        mov     rax, qword [rax]                        ; 0D03 _ 48: 8B. 00
        mov     qword [rbp-8H], rax                     ; 0D06 _ 48: 89. 45, F8
        jmp     ?_087                                   ; 0D0A _ EB, 50

?_083:  mov     qword [rbp-8H], 0                       ; 0D0C _ 48: C7. 45, F8, 00000000
        jmp     ?_087                                   ; 0D14 _ EB, 46

?_084:  mov     rax, qword [rbp-10H]                    ; 0D16 _ 48: 8B. 45, F0
        mov     eax, dword [rax+24H]                    ; 0D1A _ 8B. 40, 24
        cmp     dword [rbp-14H], eax                    ; 0D1D _ 39. 45, EC
        jnc     ?_085                                   ; 0D20 _ 73, 0A
        mov     rax, qword [rbp-10H]                    ; 0D22 _ 48: 8B. 45, F0
        mov     eax, dword [rax+24H]                    ; 0D26 _ 8B. 40, 24
        mov     dword [rbp-14H], eax                    ; 0D29 _ 89. 45, EC
?_085:  mov     rax, qword [rbp-10H]                    ; 0D2C _ 48: 8B. 45, F0
        mov     rdi, rax                                ; 0D30 _ 48: 89. C7
        call    nasm_issue_error                        ; 0D33 _ E8, 000001EC
        mov     rax, qword [rbp-8H]                     ; 0D38 _ 48: 8B. 45, F8
        mov     qword [rbp-10H], rax                    ; 0D3C _ 48: 89. 45, F0
        cmp     qword [rbp-8H], 0                       ; 0D40 _ 48: 83. 7D, F8, 00
        jz      ?_086                                   ; 0D45 _ 74, 0D
        mov     rax, qword [rbp-8H]                     ; 0D47 _ 48: 8B. 45, F8
        mov     rax, qword [rax]                        ; 0D4B _ 48: 8B. 00
        mov     qword [rbp-8H], rax                     ; 0D4E _ 48: 89. 45, F8
        jmp     ?_087                                   ; 0D52 _ EB, 08

?_086:  mov     qword [rbp-8H], 0                       ; 0D54 _ 48: C7. 45, F8, 00000000
?_087:  cmp     qword [rbp-10H], 0                      ; 0D5C _ 48: 83. 7D, F0, 00
        jnz     ?_084                                   ; 0D61 _ 75, B3
        jmp     ?_094                                   ; 0D63 _ EB, 77

?_088:  mov     rax, qword [rbp-28H]                    ; 0D65 _ 48: 8B. 45, D8
        mov     rax, qword [rax+8H]                     ; 0D69 _ 48: 8B. 40, 08
        mov     qword [rbp-10H], rax                    ; 0D6D _ 48: 89. 45, F0
        cmp     qword [rbp-10H], 0                      ; 0D71 _ 48: 83. 7D, F0, 00
        jz      ?_089                                   ; 0D76 _ 74, 0D
        mov     rax, qword [rbp-10H]                    ; 0D78 _ 48: 8B. 45, F0
        mov     rax, qword [rax]                        ; 0D7C _ 48: 8B. 00
        mov     qword [rbp-8H], rax                     ; 0D7F _ 48: 89. 45, F8
        jmp     ?_093                                   ; 0D83 _ EB, 50

?_089:  mov     qword [rbp-8H], 0                       ; 0D85 _ 48: C7. 45, F8, 00000000
        jmp     ?_093                                   ; 0D8D _ EB, 46

?_090:  mov     rax, qword [rbp-10H]                    ; 0D8F _ 48: 8B. 45, F0
        mov     eax, dword [rax+24H]                    ; 0D93 _ 8B. 40, 24
        cmp     dword [rbp-14H], eax                    ; 0D96 _ 39. 45, EC
        jnc     ?_091                                   ; 0D99 _ 73, 0A
        mov     rax, qword [rbp-10H]                    ; 0D9B _ 48: 8B. 45, F0
        mov     eax, dword [rax+24H]                    ; 0D9F _ 8B. 40, 24
        mov     dword [rbp-14H], eax                    ; 0DA2 _ 89. 45, EC
?_091:  mov     rax, qword [rbp-10H]                    ; 0DA5 _ 48: 8B. 45, F0
        mov     rdi, rax                                ; 0DA9 _ 48: 89. C7
        call    nasm_free_error                         ; 0DAC _ E8, FFFFFE18
        mov     rax, qword [rbp-8H]                     ; 0DB1 _ 48: 8B. 45, F8
        mov     qword [rbp-10H], rax                    ; 0DB5 _ 48: 89. 45, F0
        cmp     qword [rbp-8H], 0                       ; 0DB9 _ 48: 83. 7D, F8, 00
        jz      ?_092                                   ; 0DBE _ 74, 0D
        mov     rax, qword [rbp-8H]                     ; 0DC0 _ 48: 8B. 45, F8
        mov     rax, qword [rax]                        ; 0DC4 _ 48: 8B. 00
        mov     qword [rbp-8H], rax                     ; 0DC7 _ 48: 89. 45, F8
        jmp     ?_093                                   ; 0DCB _ EB, 08

?_092:  mov     qword [rbp-8H], 0                       ; 0DCD _ 48: C7. 45, F8, 00000000
?_093:  cmp     qword [rbp-10H], 0                      ; 0DD5 _ 48: 83. 7D, F0, 00
        jnz     ?_090                                   ; 0DDA _ 75, B3
?_094:  mov     rax, qword [rbp-28H]                    ; 0DDC _ 48: 8B. 45, D8
        mov     rax, qword [rax]                        ; 0DE0 _ 48: 8B. 00
        mov     qword [rel errhold_stack], rax          ; 0DE3 _ 48: 89. 05, 00000000(rel)
        mov     rax, qword [rbp-28H]                    ; 0DEA _ 48: 8B. 45, D8
        mov     rdi, rax                                ; 0DEE _ 48: 89. C7
        call    nasm_free                               ; 0DF1 _ E8, 00000000(PLT r)
        mov     eax, dword [rbp-14H]                    ; 0DF6 _ 8B. 45, EC
?_095:  leave                                           ; 0DF9 _ C9
        ret                                             ; 0DFA _ C3
; nasm_error_hold_pop End of function

nasm_verror:; Function begin
        push    rbp                                     ; 0DFB _ 55
        mov     rbp, rsp                                ; 0DFC _ 48: 89. E5
        push    rbx                                     ; 0DFF _ 53
        sub     rsp, 56                                 ; 0E00 _ 48: 83. EC, 38
        mov     dword [rbp-24H], edi                    ; 0E04 _ 89. 7D, DC
        mov     qword [rbp-30H], rsi                    ; 0E07 _ 48: 89. 75, D0
        mov     qword [rbp-38H], rdx                    ; 0E0B _ 48: 89. 55, C8
        call    __errno_location                        ; 0E0F _ E8, 00000000(PLT r)
        mov     eax, dword [rax]                        ; 0E14 _ 8B. 00
        mov     dword [rbp-20H], eax                    ; 0E16 _ 89. 45, E0
        mov     eax, dword [rbp-24H]                    ; 0E19 _ 8B. 45, DC
        mov     edi, eax                                ; 0E1C _ 89. C7
        call    true_error_type                         ; 0E1E _ E8, FFFFFB2D
        mov     dword [rbp-1CH], eax                    ; 0E23 _ 89. 45, E4
        cmp     dword [rbp-1CH], 13                     ; 0E26 _ 83. 7D, E4, 0D
        jbe     ?_096                                   ; 0E2A _ 76, 15
        mov     rdx, qword [rbp-38H]                    ; 0E2C _ 48: 8B. 55, C8
        mov     rcx, qword [rbp-30H]                    ; 0E30 _ 48: 8B. 4D, D0
        mov     eax, dword [rbp-24H]                    ; 0E34 _ 8B. 45, DC
        mov     rsi, rcx                                ; 0E37 _ 48: 89. CE
        mov     edi, eax                                ; 0E3A _ 89. C7
        call    nasm_verror_critical                    ; 0E3C _ E8, 00000000(PLT r)
?_096:  mov     eax, dword [rbp-24H]                    ; 0E41 _ 8B. 45, DC
        mov     edi, eax                                ; 0E44 _ 89. C7
        call    is_suppressed                           ; 0E46 _ E8, FFFFFA2F
        test    al, al                                  ; 0E4B _ 84. C0
        jne     ?_099                                   ; 0E4D _ 0F 85, 000000C7
        mov     edi, 48                                 ; 0E53 _ BF, 00000030
        call    nasm_zalloc                             ; 0E58 _ E8, 00000000(PLT r)
        mov     qword [rbp-18H], rax                    ; 0E5D _ 48: 89. 45, E8
        mov     rax, qword [rbp-18H]                    ; 0E61 _ 48: 8B. 45, E8
        mov     edx, dword [rbp-20H]                    ; 0E65 _ 8B. 55, E0
        mov     dword [rax+28H], edx                    ; 0E68 _ 89. 50, 28
        mov     rax, qword [rbp-18H]                    ; 0E6B _ 48: 8B. 45, E8
        mov     edx, dword [rbp-24H]                    ; 0E6F _ 8B. 55, DC
        mov     dword [rax+20H], edx                    ; 0E72 _ 89. 50, 20
        mov     rax, qword [rbp-18H]                    ; 0E75 _ 48: 8B. 45, E8
        mov     edx, dword [rbp-1CH]                    ; 0E79 _ 8B. 55, E4
        mov     dword [rax+24H], edx                    ; 0E7C _ 89. 50, 24
        mov     rdx, qword [rbp-38H]                    ; 0E7F _ 48: 8B. 55, C8
        mov     rax, qword [rbp-30H]                    ; 0E83 _ 48: 8B. 45, D0
        mov     rsi, rdx                                ; 0E87 _ 48: 89. D6
        mov     rdi, rax                                ; 0E8A _ 48: 89. C7
        call    nasm_vasprintf                          ; 0E8D _ E8, 00000000(PLT r)
        mov     rdx, rax                                ; 0E92 _ 48: 89. C2
        mov     rax, qword [rbp-18H]                    ; 0E95 _ 48: 8B. 45, E8
        mov     qword [rax+8H], rdx                     ; 0E99 _ 48: 89. 50, 08
        mov     rbx, qword [rbp-18H]                    ; 0E9D _ 48: 8B. 5D, E8
        mov     eax, dword [rbp-24H]                    ; 0EA1 _ 8B. 45, DC
        mov     edi, eax                                ; 0EA4 _ 89. C7
        call    error_where                             ; 0EA6 _ E8, FFFFFB63
        mov     qword [rbx+10H], rax                    ; 0EAB _ 48: 89. 43, 10
        mov     qword [rbx+18H], rdx                    ; 0EAF _ 48: 89. 53, 18
        mov     rax, qword [rel errhold_stack]          ; 0EB3 _ 48: 8B. 05, 00000000(rel)
        test    rax, rax                                ; 0EBA _ 48: 85. C0
        jz      ?_097                                   ; 0EBD _ 74, 29
        cmp     dword [rbp-1CH], 8                      ; 0EBF _ 83. 7D, E4, 08
        ja      ?_097                                   ; 0EC3 _ 77, 23
        mov     rax, qword [rel errhold_stack]          ; 0EC5 _ 48: 8B. 05, 00000000(rel)
        mov     rax, qword [rax+10H]                    ; 0ECC _ 48: 8B. 40, 10
        mov     rdx, qword [rbp-18H]                    ; 0ED0 _ 48: 8B. 55, E8
        mov     qword [rax], rdx                        ; 0ED4 _ 48: 89. 10
        mov     rax, qword [rel errhold_stack]          ; 0ED7 _ 48: 8B. 05, 00000000(rel)
        mov     rdx, qword [rbp-18H]                    ; 0EDE _ 48: 8B. 55, E8
        mov     qword [rax+10H], rdx                    ; 0EE2 _ 48: 89. 50, 10
        jmp     ?_098                                   ; 0EE6 _ EB, 0C

?_097:  mov     rax, qword [rbp-18H]                    ; 0EE8 _ 48: 8B. 45, E8
        mov     rdi, rax                                ; 0EEC _ 48: 89. C7
        call    nasm_issue_error                        ; 0EEF _ E8, 00000030
?_098:  mov     eax, dword [rbp-24H]                    ; 0EF4 _ 8B. 45, DC
        mov     edi, eax                                ; 0EF7 _ 89. C7
        call    skip_this_pass                          ; 0EF9 _ E8, FFFFF925
        test    al, al                                  ; 0EFE _ 84. C0
        jnz     ?_100                                   ; 0F00 _ 75, 1B
        mov     eax, dword [rbp-24H]                    ; 0F02 _ 8B. 45, DC
        and     eax, 840H                               ; 0F05 _ 25, 00000840
        test    eax, eax                                ; 0F0A _ 85. C0
        jnz     ?_101                                   ; 0F0C _ 75, 10
        mov     eax, dword [rbp-24H]                    ; 0F0E _ 8B. 45, DC
        mov     edi, eax                                ; 0F11 _ 89. C7
        call    pp_error_list_macros                    ; 0F13 _ E8, 00000000(PLT r)
        jmp     ?_101                                   ; 0F18 _ EB, 04

?_099:  nop                                             ; 0F1A _ 90
        jmp     ?_101                                   ; 0F1B _ EB, 01

?_100:  nop                                             ; 0F1D _ 90
?_101:  mov     rbx, qword [rbp-8H]                     ; 0F1E _ 48: 8B. 5D, F8
        leave                                           ; 0F22 _ C9
        ret                                             ; 0F23 _ C3
; nasm_verror End of function

nasm_issue_error:; Local function
        push    rbp                                     ; 0F24 _ 55
        mov     rbp, rsp                                ; 0F25 _ 48: 89. E5
        sub     rsp, 240                                ; 0F28 _ 48: 81. EC, 000000F0
        mov     qword [rbp-0E8H], rdi                   ; 0F2F _ 48: 89. BD, FFFFFF18
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        mov     rax, qword [fs:abs 28H]                 ; 0F36 _ 64 48: 8B. 04 25, 00000028
        mov     qword [rbp-8H], rax                     ; 0F3F _ 48: 89. 45, F8
        xor     eax, eax                                ; 0F43 _ 31. C0
        mov     rax, qword [rbp-0E8H]                   ; 0F45 _ 48: 8B. 85, FFFFFF18
        mov     eax, dword [rax+20H]                    ; 0F4C _ 8B. 40, 20
        mov     dword [rbp-0D4H], eax                   ; 0F4F _ 89. 85, FFFFFF2C
        mov     rax, qword [rbp-0E8H]                   ; 0F55 _ 48: 8B. 85, FFFFFF18
        mov     eax, dword [rax+24H]                    ; 0F5C _ 8B. 40, 24
        mov     dword [rbp-0D0H], eax                   ; 0F5F _ 89. 85, FFFFFF30
        mov     rax, qword [rbp-0E8H]                   ; 0F65 _ 48: 8B. 85, FFFFFF18
        mov     rdx, qword [rax+18H]                    ; 0F6C _ 48: 8B. 50, 18
        mov     rax, qword [rax+10H]                    ; 0F70 _ 48: 8B. 40, 10
        mov     qword [rbp-0A0H], rax                   ; 0F74 _ 48: 89. 85, FFFFFF60
        mov     qword [rbp-98H], rdx                    ; 0F7B _ 48: 89. 95, FFFFFF68
        lea     rax, [rel ?_146]                        ; 0F82 _ 48: 8D. 05, 00000000(rel)
        mov     qword [rbp-0C0H], rax                   ; 0F89 _ 48: 89. 85, FFFFFF40
        lea     rax, [rel ?_146]                        ; 0F90 _ 48: 8D. 05, 00000000(rel)
        mov     qword [rbp-0B8H], rax                   ; 0F97 _ 48: 89. 85, FFFFFF48
        cmp     dword [rbp-0D0H], 7                     ; 0F9E _ 83. BD, FFFFFF30, 07
        jbe     ?_102                                   ; 0FA5 _ 76, 0F
        mov     eax, dword [rbp-0D4H]                   ; 0FA7 _ 8B. 85, FFFFFF2C
        and     eax, 1000H                              ; 0FAD _ 25, 00001000
        test    eax, eax                                ; 0FB2 _ 85. C0
        jz      ?_103                                   ; 0FB4 _ 74, 07
?_102:  mov     eax, 1                                  ; 0FB6 _ B8, 00000001
        jmp     ?_104                                   ; 0FBB _ EB, 05

?_103:  mov     eax, 0                                  ; 0FBD _ B8, 00000000
?_104:  mov     byte [rbp-0D5H], al                     ; 0FC2 _ 88. 85, FFFFFF2B
        and     byte [rbp-0D5H], 01H                    ; 0FC8 _ 80. A5, FFFFFF2B, 01
        mov     eax, dword [rbp-0D4H]                   ; 0FCF _ 8B. 85, FFFFFF2C
        and     eax, 200H                               ; 0FD5 _ 25, 00000200
        test    eax, eax                                ; 0FDA _ 85. C0
        jz      ?_105                                   ; 0FDC _ 74, 10
        lea     rax, [rel ?_146]                        ; 0FDE _ 48: 8D. 05, 00000000(rel)
        mov     qword [rbp-0C8H], rax                   ; 0FE5 _ 48: 89. 85, FFFFFF38
        jmp     ?_106                                   ; 0FEC _ EB, 14

?_105:  mov     eax, dword [rbp-0D0H]                   ; 0FEE _ 8B. 85, FFFFFF30
        mov     edi, eax                                ; 0FF4 _ 89. C7
        call    error_pfx                               ; 0FF6 _ E8, 00000000(PLT r)
        mov     qword [rbp-0C8H], rax                   ; 0FFB _ 48: 89. 85, FFFFFF38
?_106:  mov     byte [rbp-90H], 0                       ; 1002 _ C6. 85, FFFFFF70, 00
        mov     eax, dword [rbp-0D4H]                   ; 1009 _ 8B. 85, FFFFFF2C
        and     eax, 840H                               ; 100F _ 25, 00000840
        test    eax, eax                                ; 1014 _ 85. C0
        jne     ?_114                                   ; 1016 _ 0F 85, 00000120
        mov     eax, dword [rbp-0D4H]                   ; 101C _ 8B. 85, FFFFFF2C
        and     eax, 0FH                                ; 1022 _ 83. E0, 0F
        cmp     eax, 6                                  ; 1025 _ 83. F8, 06
        jz      ?_107                                   ; 1028 _ 74, 1C
        cmp     eax, 6                                  ; 102A _ 83. F8, 06
        ja      ?_112                                   ; 102D _ 0F 87, 000000D3
        cmp     eax, 4                                  ; 1033 _ 83. F8, 04
        jz      ?_110                                   ; 1036 _ 74, 74
        cmp     eax, 5                                  ; 1038 _ 83. F8, 05
        je      ?_111                                   ; 103B _ 0F 84, 00000098
        jmp     ?_112                                   ; 1041 _ E9, 000000C0

?_107:  mov     eax, dword [rbp-0D4H]                   ; 1046 _ 8B. 85, FFFFFF2C
        shr     eax, 16                                 ; 104C _ C1. E8, 10
        mov     dword [rbp-0CCH], eax                   ; 104F _ 89. 85, FFFFFF34
        mov     eax, dword [rbp-0CCH]                   ; 1055 _ 8B. 85, FFFFFF34
        lea     rdx, [rax*8]                            ; 105B _ 48: 8D. 14 C5, 00000000
        lea     rax, [rel warning_name]                 ; 1063 _ 48: 8D. 05, 00000000(rel)
        mov     rcx, qword [rdx+rax]                    ; 106A _ 48: 8B. 0C 02
        cmp     dword [rbp-0D0H], 7                     ; 106E _ 83. BD, FFFFFF30, 07
        jbe     ?_108                                   ; 1075 _ 76, 09
        lea     rax, [rel ?_167]                        ; 1077 _ 48: 8D. 05, 00000000(rel)
        jmp     ?_109                                   ; 107E _ EB, 07

?_108:  lea     rax, [rel ?_146]                        ; 1080 _ 48: 8D. 05, 00000000(rel)
?_109:  lea     rdx, [rel ?_168]                        ; 1087 _ 48: 8D. 15, 00000000(rel)
        lea     rdi, [rbp-90H]                          ; 108E _ 48: 8D. BD, FFFFFF70
        mov     r8, rcx                                 ; 1095 _ 49: 89. C8
        mov     rcx, rax                                ; 1098 _ 48: 89. C1
        mov     esi, 64                                 ; 109B _ BE, 00000040
        mov     eax, 0                                  ; 10A0 _ B8, 00000000
        call    snprintf                                ; 10A5 _ E8, 00000000(PLT r)
        jmp     ?_113                                   ; 10AA _ EB, 5B

?_110:  mov     edx, dword [rel erropt+10H]             ; 10AC _ 8B. 15, 00000000(rel)
        lea     rsi, [rel ?_169]                        ; 10B2 _ 48: 8D. 35, 00000000(rel)
        lea     rax, [rbp-90H]                          ; 10B9 _ 48: 8D. 85, FFFFFF70
        mov     ecx, edx                                ; 10C0 _ 89. D1
        mov     rdx, rsi                                ; 10C2 _ 48: 89. F2
        mov     esi, 64                                 ; 10C5 _ BE, 00000040
        mov     rdi, rax                                ; 10CA _ 48: 89. C7
        mov     eax, 0                                  ; 10CD _ B8, 00000000
        call    snprintf                                ; 10D2 _ E8, 00000000(PLT r)
        jmp     ?_113                                   ; 10D7 _ EB, 2E

?_111:  mov     edx, dword [rel erropt+14H]             ; 10D9 _ 8B. 15, 00000000(rel)
        lea     rsi, [rel ?_170]                        ; 10DF _ 48: 8D. 35, 00000000(rel)
        lea     rax, [rbp-90H]                          ; 10E6 _ 48: 8D. 85, FFFFFF70
        mov     ecx, edx                                ; 10ED _ 89. D1
        mov     rdx, rsi                                ; 10EF _ 48: 89. F2
        mov     esi, 64                                 ; 10F2 _ BE, 00000040
        mov     rdi, rax                                ; 10F7 _ 48: 89. C7
        mov     eax, 0                                  ; 10FA _ B8, 00000000
        call    snprintf                                ; 10FF _ E8, 00000000(PLT r)
        jmp     ?_113                                   ; 1104 _ EB, 01

?_112:  nop                                             ; 1106 _ 90
?_113:  mov     eax, dword [rbp-0D4H]                   ; 1107 _ 8B. 85, FFFFFF2C
        and     eax, 2000H                              ; 110D _ 25, 00002000
        test    eax, eax                                ; 1112 _ 85. C0
        jz      ?_114                                   ; 1114 _ 74, 26
        lea     rax, [rel ?_145]                        ; 1116 _ 48: 8D. 05, 00000000(rel)
        mov     qword [rbp-0C0H], rax                   ; 111D _ 48: 89. 85, FFFFFF40
        mov     rax, qword [rbp-0E8H]                   ; 1124 _ 48: 8B. 85, FFFFFF18
        mov     eax, dword [rax+28H]                    ; 112B _ 8B. 40, 28
        mov     edi, eax                                ; 112E _ 89. C7
        call    strerror                                ; 1130 _ E8, 00000000(PLT r)
        mov     qword [rbp-0B8H], rax                   ; 1135 _ 48: 89. 85, FFFFFF48
?_114:  mov     byte [rbp-50H], 0                       ; 113C _ C6. 45, B0, 00
        mov     eax, dword [rbp-98H]                    ; 1140 _ 8B. 85, FFFFFF68
        test    eax, eax                                ; 1146 _ 85. C0
        jz      ?_115                                   ; 1148 _ 74, 44
        mov     rax, qword [rel errfmt]                 ; 114A _ 48: 8B. 05, 00000000(rel)
        mov     rdi, qword [rax+8H]                     ; 1151 _ 48: 8B. 78, 08
        mov     ecx, dword [rbp-98H]                    ; 1155 _ 8B. 8D, FFFFFF68
        mov     rax, qword [rel errfmt]                 ; 115B _ 48: 8B. 05, 00000000(rel)
        mov     rdx, qword [rax]                        ; 1162 _ 48: 8B. 10
        lea     rsi, [rel ?_165]                        ; 1165 _ 48: 8D. 35, 00000000(rel)
        lea     rax, [rbp-50H]                          ; 116C _ 48: 8D. 45, B0
        mov     r9, rdi                                 ; 1170 _ 49: 89. F9
        mov     r8d, ecx                                ; 1173 _ 41: 89. C8
        mov     rcx, rdx                                ; 1176 _ 48: 89. D1
        mov     rdx, rsi                                ; 1179 _ 48: 89. F2
        mov     esi, 64                                 ; 117C _ BE, 00000040
        mov     rdi, rax                                ; 1181 _ 48: 89. C7
        mov     eax, 0                                  ; 1184 _ B8, 00000000
        call    snprintf                                ; 1189 _ E8, 00000000(PLT r)
?_115:  mov     eax, dword [rbp-0D4H]                   ; 118E _ 8B. 85, FFFFFF2C
        mov     edi, eax                                ; 1194 _ 89. C7
        call    skip_this_pass                          ; 1196 _ E8, FFFFF688
        xor     eax, 01H                                ; 119B _ 83. F0, 01
        test    al, al                                  ; 119E _ 84. C0
        je      ?_123                                   ; 11A0 _ 0F 84, 0000019F
        mov     rax, qword [rbp-0A0H]                   ; 11A6 _ 48: 8B. 85, FFFFFF60
        test    rax, rax                                ; 11AD _ 48: 85. C0
        jz      ?_116                                   ; 11B0 _ 74, 10
        mov     rax, qword [rbp-0A0H]                   ; 11B2 _ 48: 8B. 85, FFFFFF60
        mov     qword [rbp-0B0H], rax                   ; 11B9 _ 48: 89. 85, FFFFFF50
        jmp     ?_117                                   ; 11C0 _ EB, 0E

?_116:  lea     rax, [rel no_file_name]                 ; 11C2 _ 48: 8D. 05, 00000000(rel)
        mov     qword [rbp-0B0H], rax                   ; 11C9 _ 48: 89. 85, FFFFFF50
?_117:  lea     rax, [rel ?_146]                        ; 11D0 _ 48: 8D. 05, 00000000(rel)
        mov     qword [rbp-0A8H], rax                   ; 11D7 _ 48: 89. 85, FFFFFF58
        mov     eax, dword [rbp-0D4H]                   ; 11DE _ 8B. 85, FFFFFF2C
        and     eax, 40H                                ; 11E4 _ 83. E0, 40
        test    eax, eax                                ; 11E7 _ 85. C0
        jz      ?_119                                   ; 11E9 _ 74, 2A
        mov     rax, qword [rbp-0A0H]                   ; 11EB _ 48: 8B. 85, FFFFFF60
        test    rax, rax                                ; 11F2 _ 48: 85. C0
        jz      ?_118                                   ; 11F5 _ 74, 10
        lea     rax, [rel ?_171]                        ; 11F7 _ 48: 8D. 05, 00000000(rel)
        mov     qword [rbp-0A8H], rax                   ; 11FE _ 48: 89. 85, FFFFFF58
        jmp     ?_119                                   ; 1205 _ EB, 0E

?_118:  lea     rax, [rel ?_172]                        ; 1207 _ 48: 8D. 05, 00000000(rel)
        mov     qword [rbp-0A8H], rax                   ; 120E _ 48: 89. 85, FFFFFF58
?_119:  mov     rax, qword [rel warn_list]              ; 1215 _ 48: 8B. 05, 00000000(rel)
        test    rax, rax                                ; 121C _ 48: 85. C0
        jnz     ?_120                                   ; 121F _ 75, 07
        mov     byte [rbp-0D5H], 0                      ; 1221 _ C6. 85, FFFFFF2B, 00
?_120:  cmp     byte [rbp-0D5H], 0                      ; 1228 _ 80. BD, FFFFFF2B, 00
        jz      ?_121                                   ; 122F _ 74, 6F
        mov     rax, qword [rbp-0E8H]                   ; 1231 _ 48: 8B. 85, FFFFFF18
        mov     rdi, qword [rax+8H]                     ; 1238 _ 48: 8B. 78, 08
        mov     rax, qword [rel errfmt]                 ; 123C _ 48: 8B. 05, 00000000(rel)
        mov     r10, qword [rax+10H]                    ; 1243 _ 4C: 8B. 50, 10
        mov     rax, qword [rel warn_list]              ; 1247 _ 48: 8B. 05, 00000000(rel)
        mov     r9, qword [rbp-0C8H]                    ; 124E _ 4C: 8B. 8D, FFFFFF38
        lea     rcx, [rbp-50H]                          ; 1255 _ 48: 8D. 4D, B0
        mov     rdx, qword [rbp-0B0H]                   ; 1259 _ 48: 8B. 95, FFFFFF50
        lea     rsi, [rel ?_173]                        ; 1260 _ 48: 8D. 35, 00000000(rel)
        sub     rsp, 8                                  ; 1267 _ 48: 83. EC, 08
        lea     r8, [rbp-90H]                           ; 126B _ 4C: 8D. 85, FFFFFF70
        push    r8                                      ; 1272 _ 41: 50
        push    qword [rbp-0A8H]                        ; 1274 _ FF. B5, FFFFFF58
        push    qword [rbp-0B8H]                        ; 127A _ FF. B5, FFFFFF48
        push    qword [rbp-0C0H]                        ; 1280 _ FF. B5, FFFFFF40
        push    rdi                                     ; 1286 _ 57
        mov     r8, r10                                 ; 1287 _ 4D: 89. D0
        mov     rdi, rax                                ; 128A _ 48: 89. C7
        mov     eax, 0                                  ; 128D _ B8, 00000000
        call    strlist_printf                          ; 1292 _ E8, 00000000(PLT r)
        add     rsp, 48                                 ; 1297 _ 48: 83. C4, 30
        jmp     ?_123                                   ; 129B _ E9, 000000A5

?_121:  mov     rax, qword [rel warn_list]              ; 12A0 _ 48: 8B. 05, 00000000(rel)
        test    rax, rax                                ; 12A7 _ 48: 85. C0
        jz      ?_122                                   ; 12AA _ 74, 2F
        mov     rdx, qword [rel erropt]                 ; 12AC _ 48: 8B. 15, 00000000(rel)
        mov     rax, qword [rel warn_list]              ; 12B3 _ 48: 8B. 05, 00000000(rel)
        lea     rcx, [rel ?_174]                        ; 12BA _ 48: 8D. 0D, 00000000(rel)
        mov     rsi, rcx                                ; 12C1 _ 48: 89. CE
        mov     rdi, rax                                ; 12C4 _ 48: 89. C7
        call    strlist_write                           ; 12C7 _ E8, 00000000(PLT r)
        lea     rax, [rel warn_list]                    ; 12CC _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 12D3 _ 48: 89. C7
        call    strlist_free                            ; 12D6 _ E8, 00000000(PLT r)
?_122:  mov     rax, qword [rbp-0E8H]                   ; 12DB _ 48: 8B. 85, FFFFFF18
        mov     rdi, qword [rax+8H]                     ; 12E2 _ 48: 8B. 78, 08
        mov     rax, qword [rel errfmt]                 ; 12E6 _ 48: 8B. 05, 00000000(rel)
        mov     r10, qword [rax+10H]                    ; 12ED _ 4C: 8B. 50, 10
        mov     rax, qword [rel erropt]                 ; 12F1 _ 48: 8B. 05, 00000000(rel)
        mov     r9, qword [rbp-0C8H]                    ; 12F8 _ 4C: 8B. 8D, FFFFFF38
        lea     rcx, [rbp-50H]                          ; 12FF _ 48: 8D. 4D, B0
        mov     rdx, qword [rbp-0B0H]                   ; 1303 _ 48: 8B. 95, FFFFFF50
        lea     rsi, [rel ?_175]                        ; 130A _ 48: 8D. 35, 00000000(rel)
        sub     rsp, 8                                  ; 1311 _ 48: 83. EC, 08
        lea     r8, [rbp-90H]                           ; 1315 _ 4C: 8D. 85, FFFFFF70
        push    r8                                      ; 131C _ 41: 50
        push    qword [rbp-0A8H]                        ; 131E _ FF. B5, FFFFFF58
        push    qword [rbp-0B8H]                        ; 1324 _ FF. B5, FFFFFF48
        push    qword [rbp-0C0H]                        ; 132A _ FF. B5, FFFFFF40
        push    rdi                                     ; 1330 _ 57
        mov     r8, r10                                 ; 1331 _ 4D: 89. D0
        mov     rdi, rax                                ; 1334 _ 48: 89. C7
        mov     eax, 0                                  ; 1337 _ B8, 00000000
        call    fprintf                                 ; 133C _ E8, 00000000(PLT r)
        add     rsp, 48                                 ; 1341 _ 48: 83. C4, 30
?_123:  mov     eax, dword [rbp-0D4H]                   ; 1345 _ 8B. 85, FFFFFF2C
        and     eax, 800H                               ; 134B _ 25, 00000800
        test    eax, eax                                ; 1350 _ 85. C0
        jne     ?_130                                   ; 1352 _ 0F 85, 000001B7
        mov     eax, dword [rbp-0D4H]                   ; 1358 _ 8B. 85, FFFFFF2C
        and     eax, 40H                                ; 135E _ 83. E0, 40
        test    eax, eax                                ; 1361 _ 85. C0
        je      ?_126                                   ; 1363 _ 0F 84, 000000F7
        mov     eax, dword [rbp-98H]                    ; 1369 _ 8B. 85, FFFFFF68
        test    eax, eax                                ; 136F _ 85. C0
        jz      ?_124                                   ; 1371 _ 74, 57
        mov     rax, qword [rel lfmt]                   ; 1373 _ 48: 8B. 05, 00000000(rel)
        mov     r10, qword [rax+30H]                    ; 137A _ 4C: 8B. 50, 30
        mov     r9d, dword [rbp-98H]                    ; 137E _ 44: 8B. 8D, FFFFFF68
        mov     r8, qword [rbp-0A0H]                    ; 1385 _ 4C: 8B. 85, FFFFFF60
        mov     rax, qword [rbp-0E8H]                   ; 138C _ 48: 8B. 85, FFFFFF18
        mov     rcx, qword [rax+8H]                     ; 1393 _ 48: 8B. 48, 08
        mov     rdx, qword [rbp-0C8H]                   ; 1397 _ 48: 8B. 95, FFFFFF38
        lea     rsi, [rel ?_176]                        ; 139E _ 48: 8D. 35, 00000000(rel)
        mov     eax, dword [rbp-0D4H]                   ; 13A5 _ 8B. 85, FFFFFF2C
        sub     rsp, 8                                  ; 13AB _ 48: 83. EC, 08
        lea     rdi, [rbp-90H]                          ; 13AF _ 48: 8D. BD, FFFFFF70
        push    rdi                                     ; 13B6 _ 57
        mov     edi, eax                                ; 13B7 _ 89. C7
        mov     eax, 0                                  ; 13B9 _ B8, 00000000
        call    r10                                     ; 13BE _ 41: FF. D2
        add     rsp, 16                                 ; 13C1 _ 48: 83. C4, 10
        jmp     ?_127                                   ; 13C5 _ E9, 000000D4

?_124:  mov     rax, qword [rbp-0A0H]                   ; 13CA _ 48: 8B. 85, FFFFFF60
        test    rax, rax                                ; 13D1 _ 48: 85. C0
        jz      ?_125                                   ; 13D4 _ 74, 4A
        mov     rax, qword [rel lfmt]                   ; 13D6 _ 48: 8B. 05, 00000000(rel)
        mov     r10, qword [rax+30H]                    ; 13DD _ 4C: 8B. 50, 30
        mov     rdi, qword [rbp-0A0H]                   ; 13E1 _ 48: 8B. BD, FFFFFF60
        mov     rax, qword [rbp-0E8H]                   ; 13E8 _ 48: 8B. 85, FFFFFF18
        mov     rcx, qword [rax+8H]                     ; 13EF _ 48: 8B. 48, 08
        lea     r8, [rbp-90H]                           ; 13F3 _ 4C: 8D. 85, FFFFFF70
        mov     rdx, qword [rbp-0C8H]                   ; 13FA _ 48: 8B. 95, FFFFFF38
        lea     rsi, [rel ?_177]                        ; 1401 _ 48: 8D. 35, 00000000(rel)
        mov     eax, dword [rbp-0D4H]                   ; 1408 _ 8B. 85, FFFFFF2C
        mov     r9, r8                                  ; 140E _ 4D: 89. C1
        mov     r8, rdi                                 ; 1411 _ 49: 89. F8
        mov     edi, eax                                ; 1414 _ 89. C7
        mov     eax, 0                                  ; 1416 _ B8, 00000000
        call    r10                                     ; 141B _ 41: FF. D2
        jmp     ?_127                                   ; 141E _ EB, 7E

?_125:  mov     rax, qword [rel lfmt]                   ; 1420 _ 48: 8B. 05, 00000000(rel)
        mov     r9, qword [rax+30H]                     ; 1427 _ 4C: 8B. 48, 30
        mov     rax, qword [rbp-0E8H]                   ; 142B _ 48: 8B. 85, FFFFFF18
        mov     rcx, qword [rax+8H]                     ; 1432 _ 48: 8B. 48, 08
        lea     rdi, [rbp-90H]                          ; 1436 _ 48: 8D. BD, FFFFFF70
        mov     rdx, qword [rbp-0C8H]                   ; 143D _ 48: 8B. 95, FFFFFF38
        lea     rsi, [rel ?_178]                        ; 1444 _ 48: 8D. 35, 00000000(rel)
        mov     eax, dword [rbp-0D4H]                   ; 144B _ 8B. 85, FFFFFF2C
        mov     r8, rdi                                 ; 1451 _ 49: 89. F8
        mov     edi, eax                                ; 1454 _ 89. C7
        mov     eax, 0                                  ; 1456 _ B8, 00000000
        call    r9                                      ; 145B _ 41: FF. D1
        jmp     ?_127                                   ; 145E _ EB, 3E

?_126:  mov     rax, qword [rel lfmt]                   ; 1460 _ 48: 8B. 05, 00000000(rel)
        mov     r9, qword [rax+30H]                     ; 1467 _ 4C: 8B. 48, 30
        mov     rax, qword [rbp-0E8H]                   ; 146B _ 48: 8B. 85, FFFFFF18
        mov     rcx, qword [rax+8H]                     ; 1472 _ 48: 8B. 48, 08
        lea     rdi, [rbp-90H]                          ; 1476 _ 48: 8D. BD, FFFFFF70
        mov     rdx, qword [rbp-0C8H]                   ; 147D _ 48: 8B. 95, FFFFFF38
        lea     rsi, [rel ?_179]                        ; 1484 _ 48: 8D. 35, 00000000(rel)
        mov     eax, dword [rbp-0D4H]                   ; 148B _ 8B. 85, FFFFFF2C
        mov     r8, rdi                                 ; 1491 _ 49: 89. F8
        mov     edi, eax                                ; 1494 _ 89. C7
        mov     eax, 0                                  ; 1496 _ B8, 00000000
        call    r9                                      ; 149B _ 41: FF. D1
?_127:  mov     eax, dword [rbp-0D4H]                   ; 149E _ 8B. 85, FFFFFF2C
        mov     edi, eax                                ; 14A4 _ 89. C7
        call    skip_this_pass                          ; 14A6 _ E8, FFFFF378
        test    al, al                                  ; 14AB _ 84. C0
        jnz     ?_131                                   ; 14AD _ 75, 63
        cmp     dword [rbp-0D0H], 11                    ; 14AF _ 83. BD, FFFFFF30, 0B
        jbe     ?_128                                   ; 14B6 _ 76, 15
        mov     edx, dword [rbp-0D4H]                   ; 14B8 _ 8B. 95, FFFFFF2C
        mov     eax, dword [rbp-0D0H]                   ; 14BE _ 8B. 85, FFFFFF30
        mov     esi, edx                                ; 14C4 _ 89. D6
        mov     edi, eax                                ; 14C6 _ 89. C7
        call    die_hard                                ; 14C8 _ E8, FFFFF4CB
?_128:  movzx   eax, byte [rbp-0D5H]                    ; 14CD _ 0F B6. 85, FFFFFF2B
        xor     eax, 01H                                ; 14D4 _ 83. F0, 01
        test    al, al                                  ; 14D7 _ 84. C0
        jz      ?_132                                   ; 14D9 _ 74, 3A
        mov     eax, dword [rel erropt+8H]              ; 14DB _ 8B. 05, 00000000(rel)
        cmp     eax, dword [rbp-0D0H]                   ; 14E1 _ 3B. 85, FFFFFF30
        jnc     ?_129                                   ; 14E7 _ 73, 0C
        mov     eax, dword [rbp-0D0H]                   ; 14E9 _ 8B. 85, FFFFFF30
        mov     dword [rel erropt+8H], eax              ; 14EF _ 89. 05, 00000000(rel)
?_129:  cmp     dword [rbp-0D0H], 7                     ; 14F5 _ 83. BD, FFFFFF30, 07
        jbe     ?_133                                   ; 14FC _ 76, 1A
        mov     eax, dword [rel erropt+0CH]             ; 14FE _ 8B. 05, 00000000(rel)
        or      eax, 10H                                ; 1504 _ 83. C8, 10
        mov     dword [rel erropt+0CH], eax             ; 1507 _ 89. 05, 00000000(rel)
        jmp     ?_134                                   ; 150D _ EB, 0A

?_130:  nop                                             ; 150F _ 90
        jmp     ?_134                                   ; 1510 _ EB, 07

?_131:  nop                                             ; 1512 _ 90
        jmp     ?_134                                   ; 1513 _ EB, 04

?_132:  nop                                             ; 1515 _ 90
        jmp     ?_134                                   ; 1516 _ EB, 01

?_133:  nop                                             ; 1518 _ 90
?_134:  mov     rax, qword [rbp-0E8H]                   ; 1519 _ 48: 8B. 85, FFFFFF18
        mov     rdi, rax                                ; 1520 _ 48: 89. C7
        call    nasm_free_error                         ; 1523 _ E8, FFFFF6A1
        nop                                             ; 1528 _ 90
        mov     rax, qword [rbp-8H]                     ; 1529 _ 48: 8B. 45, F8
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        sub     rax, qword [fs:abs 28H]                 ; 152D _ 64 48: 2B. 04 25, 00000028
        jz      ?_135                                   ; 1536 _ 74, 05
        call    __stack_chk_fail                        ; 1538 _ E8, 00000000(PLT r)
?_135:  leave                                           ; 153D _ C9
        ret                                             ; 153E _ C3

set_error_format:; Function begin
        push    rbp                                     ; 153F _ 55
        mov     rbp, rsp                                ; 1540 _ 48: 89. E5
        sub     rsp, 16                                 ; 1543 _ 48: 83. EC, 10
        mov     qword [rbp-8H], rdi                     ; 1547 _ 48: 89. 7D, F8
        mov     rax, qword [rbp-8H]                     ; 154B _ 48: 8B. 45, F8
        lea     rdx, [rel ?_180]                        ; 154F _ 48: 8D. 15, 00000000(rel)
        mov     rsi, rax                                ; 1556 _ 48: 89. C6
        mov     rdi, rdx                                ; 1559 _ 48: 89. D7
        call    strcasecmp                              ; 155C _ E8, 00000000(PLT r)
        test    eax, eax                                ; 1561 _ 85. C0
        jz      ?_136                                   ; 1563 _ 74, 34
        mov     rax, qword [rbp-8H]                     ; 1565 _ 48: 8B. 45, F8
        lea     rdx, [rel ?_181]                        ; 1569 _ 48: 8D. 15, 00000000(rel)
        mov     rsi, rax                                ; 1570 _ 48: 89. C6
        mov     rdi, rdx                                ; 1573 _ 48: 89. D7
        call    strcasecmp                              ; 1576 _ E8, 00000000(PLT r)
        test    eax, eax                                ; 157B _ 85. C0
        jz      ?_136                                   ; 157D _ 74, 1A
        mov     rax, qword [rbp-8H]                     ; 157F _ 48: 8B. 45, F8
        lea     rdx, [rel ?_182]                        ; 1583 _ 48: 8D. 15, 00000000(rel)
        mov     rsi, rax                                ; 158A _ 48: 89. C6
        mov     rdi, rdx                                ; 158D _ 48: 89. D7
        call    strcasecmp                              ; 1590 _ E8, 00000000(PLT r)
        test    eax, eax                                ; 1595 _ 85. C0
        jnz     ?_137                                   ; 1597 _ 75, 10
?_136:  lea     rax, [rel ?_187]                        ; 1599 _ 48: 8D. 05, 00000000(rel)
        mov     qword [rel errfmt], rax                 ; 15A0 _ 48: 89. 05, 00000000(rel)
        jmp     ?_140                                   ; 15A7 _ EB, 4B

?_137:  mov     rax, qword [rbp-8H]                     ; 15A9 _ 48: 8B. 45, F8
        lea     rdx, [rel ?_183]                        ; 15AD _ 48: 8D. 15, 00000000(rel)
        mov     rsi, rax                                ; 15B4 _ 48: 89. C6
        mov     rdi, rdx                                ; 15B7 _ 48: 89. D7
        call    strcasecmp                              ; 15BA _ E8, 00000000(PLT r)
        test    eax, eax                                ; 15BF _ 85. C0
        jz      ?_138                                   ; 15C1 _ 74, 1A
        mov     rax, qword [rbp-8H]                     ; 15C3 _ 48: 8B. 45, F8
        lea     rdx, [rel ?_184]                        ; 15C7 _ 48: 8D. 15, 00000000(rel)
        mov     rsi, rax                                ; 15CE _ 48: 89. C6
        mov     rdi, rdx                                ; 15D1 _ 48: 89. D7
        call    strcasecmp                              ; 15D4 _ E8, 00000000(PLT r)
        test    eax, eax                                ; 15D9 _ 85. C0
        jnz     ?_139                                   ; 15DB _ 75, 10
?_138:  lea     rax, [rel errfmts]                      ; 15DD _ 48: 8D. 05, 00000000(rel)
        mov     qword [rel errfmt], rax                 ; 15E4 _ 48: 89. 05, 00000000(rel)
        jmp     ?_140                                   ; 15EB _ EB, 07

?_139:  mov     eax, 4294967295                         ; 15ED _ B8, FFFFFFFF
        jmp     ?_141                                   ; 15F2 _ EB, 05

?_140:  mov     eax, 0                                  ; 15F4 _ B8, 00000000
?_141:  leave                                           ; 15F9 _ C9
        ret                                             ; 15FA _ C3
; set_error_format End of function

usage:  ; Local function
        push    rbp                                     ; 15FB _ 55
        mov     rbp, rsp                                ; 15FC _ 48: 89. E5
        mov     rcx, qword [rel _progname]              ; 15FF _ 48: 8B. 0D, 00000000(rel)
        mov     rdx, qword [rel _progname]              ; 1606 _ 48: 8B. 15, 00000000(rel)
        mov     rax, qword [rel erropt]                 ; 160D _ 48: 8B. 05, 00000000(rel)
        lea     rsi, [rel ?_185]                        ; 1614 _ 48: 8D. 35, 00000000(rel)
        mov     rdi, rax                                ; 161B _ 48: 89. C7
        mov     eax, 0                                  ; 161E _ B8, 00000000
        call    fprintf                                 ; 1623 _ E8, 00000000(PLT r)
        nop                                             ; 1628 _ 90
        pop     rbp                                     ; 1629 _ 5D
        ret                                             ; 162A _ C3

warn_dollar_hex:; Function begin
        push    rbp                                     ; 162B _ 55
        mov     rbp, rsp                                ; 162C _ 48: 89. E5
        sub     rsp, 16                                 ; 162F _ 48: 83. EC, 10
        mov     dword [rbp-4H], 917504                  ; 1633 _ C7. 45, FC, 000E0000
        mov     eax, dword [rbp-4H]                     ; 163A _ 8B. 45, FC
        mov     edi, eax                                ; 163D _ 89. C7
        call    warn_active                             ; 163F _ E8, FFFFE9BC
        movzx   eax, al                                 ; 1644 _ 0F B6. C0
        test    rax, rax                                ; 1647 _ 48: 85. C0
        jz      ?_142                                   ; 164A _ 74, 19
        lea     rdx, [rel ?_186]                        ; 164C _ 48: 8D. 15, 00000000(rel)
        mov     eax, dword [rbp-4H]                     ; 1653 _ 8B. 45, FC
        mov     rsi, rdx                                ; 1656 _ 48: 89. D6
        mov     edi, eax                                ; 1659 _ 89. C7
        mov     eax, 0                                  ; 165B _ B8, 00000000
        call    nasm_warn_                              ; 1660 _ E8, 00000000(PLT r)
?_142:  nop                                             ; 1665 _ 90
        leave                                           ; 1666 _ C9
        ret                                             ; 1667 _ C3
; warn_dollar_hex End of function


SECTION .data   align=1 noexec                          ; section number 2, data


SECTION .bss    align=8 noexec                          ; section number 3, bss

warning_stack:                                          ; qword
        resq    1                                       ; 0000

warning_state_init:                                     ; qword
        resq    1                                       ; 0008

warn_list:                                              ; qword
        resq    1                                       ; 0010

errhold_stack:                                          ; qword
        resq    1                                       ; 0018

been_here.1:                                            ; byte
        resb    1                                       ; 0020


SECTION .rodata align=16 noexec                         ; section number 4, const

?_143:                                                  ; byte
        db 69H, 6EH, 63H, 6CH, 75H, 64H, 65H, 2FH       ; 0000 _ include/
        db 66H, 69H, 6CH, 65H, 73H, 2EH, 68H, 00H       ; 0008 _ files.h.

?_144:                                                  ; byte
        db 28H, 73H, 69H, 7AH, 65H, 5FH, 74H, 29H       ; 0010 _ (size_t)
        db 66H, 6EH, 20H, 3CH, 20H, 41H, 52H, 52H       ; 0018 _ fn < ARR
        db 41H, 59H, 5FH, 53H, 49H, 5AH, 45H, 28H       ; 0020 _ AY_SIZE(
        db 5FH, 66H, 69H, 6CH, 65H, 6EH, 61H, 6DH       ; 0028 _ _filenam
        db 65H, 73H, 29H, 00H                           ; 0030 _ es).

?_145:                                                  ; byte
        db 3AH, 00H                                     ; 0034 _ :.

?_146:                                                  ; byte
        db 00H, 3AH, 20H, 00H, 28H, 00H, 29H, 00H       ; 0036 _ .: .(.).
        db 20H, 3AH, 20H, 00H                           ; 003E _  : .

?_147:                                                  ; byte
        db 77H, 61H, 72H, 6EH, 69H, 6EH, 67H, 20H       ; 0042 _ warning 
        db 73H, 74H, 61H, 63H, 6BH, 20H, 65H, 6DH       ; 004A _ stack em
        db 70H, 74H, 79H, 00H                           ; 0052 _ pty.

?_148:                                                  ; byte
        db 2EH, 2FH, 61H, 73H, 6DH, 2FH, 65H, 72H       ; 0056 _ ./asm/er
        db 72H, 6FH, 72H, 2EH, 63H, 00H                 ; 005E _ ror.c.

?_149:                                                  ; byte
        db 21H, 77H, 61H, 72H, 6EH, 5FH, 6CH, 69H       ; 0064 _ !warn_li
        db 73H, 74H, 00H                                ; 006C _ st.

?_150:                                                  ; byte
        db 6EH, 6FH, 2DH, 00H                           ; 006F _ no-.

?_151:                                                  ; byte
        db 6EH, 6FH, 6EH, 65H, 00H                      ; 0073 _ none.

?_152:                                                  ; byte
        db 65H, 72H, 72H, 6FH, 72H, 00H                 ; 0078 _ error.

?_153:                                                  ; byte
        db 61H, 6CH, 6CH, 00H                           ; 007E _ all.

?_154:                                                  ; byte
        db 75H, 6EH, 6BH, 6EH, 6FH, 77H, 6EH, 20H       ; 0082 _ unknown 
        db 77H, 61H, 72H, 6EH, 69H, 6EH, 67H, 20H       ; 008A _ warning 
        db 6EH, 61H, 6DH, 65H, 3AH, 20H, 25H, 73H       ; 0092 _ name: %s
        db 00H                                          ; 009A _ .

?_155:                                                  ; byte
        db 3BH, 3BH, 3BH, 20H, 00H                      ; 009B _ ;;; .

?_156:                                                  ; byte
        db 6EH, 6FH, 74H, 65H, 3AH, 20H, 00H            ; 00A0 _ note: .

?_157:                                                  ; byte
        db 64H, 65H, 62H, 75H, 67H, 3AH, 20H, 00H       ; 00A7 _ debug: .

?_158:                                                  ; byte
        db 69H, 6EH, 66H, 6FH, 3AH, 20H, 00H            ; 00AF _ info: .

?_159:                                                  ; byte
        db 77H, 61H, 72H, 6EH, 69H, 6EH, 67H, 3AH       ; 00B6 _ warning:
        db 20H, 00H                                     ; 00BE _  .

?_160:                                                  ; byte
        db 65H, 72H, 72H, 6FH, 72H, 3AH, 20H, 00H       ; 00C0 _ error: .

?_161:                                                  ; byte
        db 66H, 61H, 74H, 61H, 6CH, 3AH, 20H, 00H       ; 00C8 _ fatal: .

?_162:                                                  ; byte
        db 63H, 72H, 69H, 74H, 69H, 63H, 61H, 6CH       ; 00D0 _ critical
        db 3AH, 20H, 00H                                ; 00D8 _ : .

?_163:                                                  ; byte
        db 70H, 61H, 6EH, 69H, 63H, 3AH, 20H, 00H       ; 00DB _ panic: .

?_164:                                                  ; byte
        db 69H, 6EH, 74H, 65H, 72H, 6EH, 61H, 6CH       ; 00E3 _ internal
        db 20H, 65H, 72H, 72H, 6FH, 72H, 3AH, 20H       ; 00EB _  error: 
        db 00H                                          ; 00F3 _ .

no_file_name:                                           ; byte
        db 6EH, 61H, 73H, 6DH, 00H                      ; 00F4 _ nasm.

?_165:                                                  ; byte
        db 25H, 73H, 25H, 64H, 25H, 73H, 00H            ; 00F9 _ %s%d%s.

?_166:                                                  ; byte
        db 65H, 68H, 20H, 3DH, 3DH, 20H, 65H, 72H       ; 0100 _ eh == er
        db 72H, 68H, 6FH, 6CH, 64H, 5FH, 73H, 74H       ; 0108 _ rhold_st
        db 61H, 63H, 6BH, 00H                           ; 0110 _ ack.

?_167:                                                  ; byte
        db 65H, 72H, 72H, 6FH, 72H, 3DH, 00H            ; 0114 _ error=.

?_168:                                                  ; byte
        db 20H, 5BH, 2DH, 77H, 2BH, 25H, 73H, 25H       ; 011B _  [-w+%s%
        db 73H, 5DH, 00H                                ; 0123 _ s].

?_169:                                                  ; byte
        db 20H, 5BH, 2DH, 2DH, 64H, 65H, 62H, 75H       ; 0126 _  [--debu
        db 67H, 3DH, 25H, 75H, 5DH, 00H                 ; 012E _ g=%u].

?_170:                                                  ; byte
        db 20H, 5BH, 2DH, 2DH, 69H, 6EH, 66H, 6FH       ; 0134 _  [--info
        db 3DH, 25H, 75H, 5DH, 00H                      ; 013C _ =%u].

?_171:                                                  ; byte
        db 20H, 68H, 65H, 72H, 65H, 00H                 ; 0141 _  here.

?_172:                                                  ; byte
        db 20H, 69H, 6EH, 20H, 61H, 6EH, 20H, 75H       ; 0147 _  in an u
        db 6EH, 6BH, 6EH, 6FH, 77H, 6EH, 20H, 6CH       ; 014F _ nknown l
        db 6FH, 63H, 61H, 74H, 69H, 6FH, 6EH, 00H       ; 0157 _ ocation.

?_173:                                                  ; byte
        db 25H, 73H, 25H, 73H, 25H, 73H, 25H, 73H       ; 015F _ %s%s%s%s
        db 25H, 73H, 25H, 73H, 25H, 73H, 25H, 73H       ; 0167 _ %s%s%s%s
        db 25H, 73H, 00H                                ; 016F _ %s.

?_174:                                                  ; byte
        db 0AH, 00H                                     ; 0172 _ ..

?_175:                                                  ; byte
        db 25H, 73H, 25H, 73H, 25H, 73H, 25H, 73H       ; 0174 _ %s%s%s%s
        db 25H, 73H, 25H, 73H, 25H, 73H, 25H, 73H       ; 017C _ %s%s%s%s
        db 25H, 73H, 0AH, 00H                           ; 0184 _ %s..

?_176:                                                  ; byte
        db 25H, 73H, 25H, 73H, 20H, 61H, 74H, 20H       ; 0188 _ %s%s at 
        db 25H, 73H, 3AH, 25H, 64H, 25H, 73H, 00H       ; 0190 _ %s:%d%s.

?_177:                                                  ; byte
        db 25H, 73H, 25H, 73H, 20H, 69H, 6EH, 20H       ; 0198 _ %s%s in 
        db 66H, 69H, 6CH, 65H, 20H, 25H, 73H, 25H       ; 01A0 _ file %s%
        db 73H, 00H                                     ; 01A8 _ s.

?_178:                                                  ; byte
        db 25H, 73H, 25H, 73H, 20H, 69H, 6EH, 20H       ; 01AA _ %s%s in 
        db 61H, 6EH, 20H, 75H, 6EH, 6BH, 6EH, 6FH       ; 01B2 _ an unkno
        db 77H, 6EH, 20H, 6CH, 6FH, 63H, 61H, 74H       ; 01BA _ wn locat
        db 69H, 6FH, 6EH, 25H, 73H, 00H                 ; 01C2 _ ion%s.

?_179:                                                  ; byte
        db 25H, 73H, 25H, 73H, 25H, 73H, 00H            ; 01C8 _ %s%s%s.

?_180:                                                  ; byte
        db 76H, 63H, 00H                                ; 01CF _ vc.

?_181:                                                  ; byte
        db 6DH, 73H, 76H, 63H, 00H                      ; 01D2 _ msvc.

?_182:                                                  ; byte
        db 6DH, 73H, 00H                                ; 01D7 _ ms.

?_183:                                                  ; byte
        db 67H, 6EH, 75H, 00H                           ; 01DA _ gnu.

?_184:                                                  ; byte
        db 67H, 63H, 63H, 00H, 00H, 00H, 00H, 00H       ; 01DE _ gcc.....
        db 00H, 00H                                     ; 01E6 _ ..

?_185:                                                  ; byte
        db 55H, 73H, 61H, 67H, 65H, 3AH, 20H, 25H       ; 01E8 _ Usage: %
        db 73H, 20H, 5BH, 2DH, 40H, 20H, 72H, 65H       ; 01F0 _ s [-@ re
        db 73H, 70H, 6FH, 6EH, 73H, 65H, 5FH, 66H       ; 01F8 _ sponse_f
        db 69H, 6CH, 65H, 5DH, 20H, 5BH, 6FH, 70H       ; 0200 _ ile] [op
        db 74H, 69H, 6FH, 6EH, 73H, 2EH, 2EH, 2EH       ; 0208 _ tions...
        db 5DH, 20H, 5BH, 2DH, 2DH, 5DH, 20H, 66H       ; 0210 _ ] [--] f
        db 69H, 6CH, 65H, 6EH, 61H, 6DH, 65H, 0AH       ; 0218 _ ilename.
        db 20H, 20H, 20H, 46H, 6FH, 72H, 20H, 61H       ; 0220 _    For a
        db 64H, 64H, 69H, 74H, 69H, 6FH, 6EH, 61H       ; 0228 _ dditiona
        db 6CH, 20H, 68H, 65H, 6CH, 70H, 3AH, 0AH       ; 0230 _ l help:.
        db 20H, 20H, 20H, 20H, 20H, 20H, 20H, 25H       ; 0238 _        %
        db 73H, 20H, 2DH, 68H, 20H, 5BH, 72H, 75H       ; 0240 _ s -h [ru
        db 6EH, 7CH, 74H, 6FH, 70H, 69H, 63H, 73H       ; 0248 _ n|topics
        db 7CH, 61H, 6CH, 6CH, 7CH, 2DH, 6FH, 70H       ; 0250 _ |all|-op
        db 74H, 69H, 6FH, 6EH, 5DH, 0AH, 00H, 00H       ; 0258 _ tion]...

?_186:                                                  ; byte
        db 24H, 20H, 70H, 72H, 65H, 66H, 69H, 78H       ; 0260 _ $ prefix
        db 20H, 66H, 6FH, 72H, 20H, 68H, 65H, 78H       ; 0268 _  for hex
        db 61H, 64H, 65H, 63H, 69H, 6DH, 61H, 6CH       ; 0270 _ adecimal
        db 20H, 69H, 73H, 20H, 64H, 65H, 70H, 72H       ; 0278 _  is depr
        db 65H, 63H, 61H, 74H, 65H, 64H, 00H, 00H       ; 0280 _ ecated..
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0288 _ ........

__func__.3:                                             ; byte
        db 65H, 72H, 72H, 6FH, 72H, 5FH, 70H, 61H       ; 0290 _ error_pa
        db 73H, 73H, 5FH, 73H, 74H, 61H, 72H, 74H       ; 0298 _ ss_start
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 02A0 _ ........

__func__.2:                                             ; byte
        db 67H, 65H, 74H, 5FH, 66H, 69H, 6CH, 65H       ; 02A8 _ get_file
        db 6EH, 61H, 6DH, 65H, 00H, 00H, 00H, 00H       ; 02B0 _ name....
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 02B8 _ ........

__func__.0:                                             ; byte
        db 6EH, 61H, 73H, 6DH, 5FH, 65H, 72H, 72H       ; 02C0 _ nasm_err
        db 6FH, 72H, 5FH, 68H, 6FH, 6CH, 64H, 5FH       ; 02C8 _ or_hold_
        db 70H, 6FH, 70H, 00H                           ; 02D0 _ pop.


SECTION .data.rel.ro.local align=32 noexec              ; section number 5, data

errfmts:                                                ; byte
        dq ?_145                                        ; 0000 _ 0000000000000000 (d)
        dq ?_146                                        ; 0008 _ 0000000000000000 (d)
        dq ?_143+37H                                    ; 0010 _ 0000000000000000 (d)

?_187:                                                  ; byte
        dq ?_143+3AH                                    ; 0018 _ 0000000000000000 (d)
        dq ?_143+3CH                                    ; 0020 _ 0000000000000000 (d)
        dq ?_143+3EH                                    ; 0028 _ 0000000000000000 (d)


SECTION .data.rel.local align=8 noexec                  ; section number 6, data

errfmt:                                                 ; qword
        dq errfmts                                      ; 0000 _ 0000000000000000 (d)


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
        dd warn_active-$-20H                            ; 0020 _ 00000000 (rel)
        dd 00000033H, 100E4100H                         ; 0024 _ 51 269369600 
        dd 0D430286H, 070C6E06H                         ; 002C _ 222495366 118255110 
        dd 00000008H, 0000001CH                         ; 0034 _ 8 28 
        dd 0000003CH                                    ; 003C _ 60 
        dd warn_active-$-0DH                            ; 0040 _ 00000000 (rel)
        dd 0000001EH, 100E4100H                         ; 0044 _ 30 269369600 
        dd 0D430286H, 070C5906H                         ; 004C _ 222495366 118249734 
        dd 00000008H, 0000001CH                         ; 0054 _ 8 28 
        dd 0000005CH                                    ; 005C _ 92 
        dd warn_active-$-0FH                            ; 0060 _ 00000000 (rel)
        dd 0000001EH, 100E4100H                         ; 0064 _ 30 269369600 
        dd 0D430286H, 070C5906H                         ; 006C _ 222495366 118249734 
        dd 00000008H, 0000001CH                         ; 0074 _ 8 28 
        dd 0000007CH                                    ; 007C _ 124 
        dd warn_active-$-11H                            ; 0080 _ 00000000 (rel)
        dd 00000054H, 100E4100H                         ; 0084 _ 84 269369600 
        dd 0D430286H, 0C4F0206H                         ; 008C _ 222495366 206504454 
        dd 00000807H, 0000001CH                         ; 0094 _ 2055 28 
        dd 0000009CH                                    ; 009C _ 156 
        dd warn_active-$+23H                            ; 00A0 _ 00000000 (rel)
        dd 00000014H, 100E4100H                         ; 00A4 _ 20 269369600 
        dd 0D430286H, 070C4F06H                         ; 00AC _ 222495366 118247174 
        dd 00000008H, 0000001CH                         ; 00B4 _ 8 28 
        dd 000000BCH                                    ; 00BC _ 188 
        dd warn_active-$+17H                            ; 00C0 _ 00000000 (rel)
        dd 0000000CH, 100E4100H                         ; 00C4 _ 12 269369600 
        dd 0D430286H, 070C4706H                         ; 00CC _ 222495366 118245126 
        dd 00000008H, 0000001CH                         ; 00D4 _ 8 28 
        dd 000000DCH                                    ; 00DC _ 220 
        dd warn_active-$+3H                             ; 00E0 _ 00000000 (rel)
        dd 00000029H, 100E4100H                         ; 00E4 _ 41 269369600 
        dd 0D430286H, 070C6406H                         ; 00EC _ 222495366 118252550 
        dd 00000008H, 00000020H                         ; 00F4 _ 8 32 
        dd 000000FCH                                    ; 00FC _ 252 
        dd warn_active-$+0CH                            ; 0100 _ 00000000 (rel)
        dd 000000A1H, 100E4100H                         ; 0104 _ 161 269369600 
        dd 0D430286H, 03834506H                         ; 010C _ 222495366 58934534 
        dd 070C9702H, 00000008H                         ; 0114 _ 118265602 8 
        dd 00000020H, 00000120H                         ; 011C _ 32 288 
        dd warn_active-$+89H                            ; 0124 _ 00000000 (rel)
        dd 000000DFH, 100E4100H                         ; 0128 _ 223 269369600 
        dd 0D430286H, 03834506H                         ; 0130 _ 222495366 58934534 
        dd 070CD502H, 00000008H                         ; 0138 _ 118281474 8 
        dd 0000001CH, 00000144H                         ; 0140 _ 28 324 
        dd warn_active-$+144H                           ; 0148 _ 00000000 (rel)
        dd 0000001AH, 100E4100H                         ; 014C _ 26 269369600 
        dd 0D430286H, 070C5506H                         ; 0154 _ 222495366 118248710 
        dd 00000008H, 0000001CH                         ; 015C _ 8 28 
        dd 00000164H                                    ; 0164 _ 356 
        dd warn_active-$+13EH                           ; 0168 _ 00000000 (rel)
        dd 00000016H, 100E4100H                         ; 016C _ 22 269369600 
        dd 0D430286H, 070C5106H                         ; 0174 _ 222495366 118247686 
        dd 00000008H, 0000001CH                         ; 017C _ 8 28 
        dd 00000184H                                    ; 0184 _ 388 
        dd warn_active-$+134H                           ; 0188 _ 00000000 (rel)
        dd 0000006CH, 100E4100H                         ; 018C _ 108 269369600 
        dd 0D430286H, 0C670206H                         ; 0194 _ 222495366 208077318 
        dd 00000807H, 00000020H                         ; 019C _ 2055 32 
        dd 000001A4H                                    ; 01A4 _ 420 
        dd warn_active-$+180H                           ; 01A8 _ 00000000 (rel)
        dd 000000BDH, 100E4100H                         ; 01AC _ 189 269369600 
        dd 0D430286H, 03834506H                         ; 01B4 _ 222495366 58934534 
        dd 070CB302H, 00000008H                         ; 01BC _ 118272770 8 
        dd 0000001CH, 000001C8H                         ; 01C4 _ 28 456 
        dd warn_active-$+219H                           ; 01CC _ 00000000 (rel)
        dd 0000001BH, 100E4100H                         ; 01D0 _ 27 269369600 
        dd 0D430286H, 070C5606H                         ; 01D8 _ 222495366 118248966 
        dd 00000008H, 0000001CH                         ; 01E0 _ 8 28 
        dd 000001E8H                                    ; 01E8 _ 488 
        dd warn_active-$+214H                           ; 01EC _ 00000000 (rel)
        dd 00000357H, 100E4100H                         ; 01F0 _ 855 269369600 
        dd 0D430286H, 03520306H                         ; 01F8 _ 222495366 55706374 
        dd 0008070CH, 0000001CH                         ; 0200 _ 526092 28 
        dd 00000208H                                    ; 0208 _ 520 
        dd warn_active-$+54BH                           ; 020C _ 00000000 (rel)
        dd 000000CCH, 100E4100H                         ; 0210 _ 204 269369600 
        dd 0D430286H, 0CC70206H                         ; 0218 _ 222495366 214368774 
        dd 00000807H, 0000001CH                         ; 0220 _ 2055 28 
        dd 00000228H                                    ; 0228 _ 552 
        dd warn_active-$+5F7H                           ; 022C _ 00000000 (rel)
        dd 00000057H, 100E4100H                         ; 0230 _ 87 269369600 
        dd 0D430286H, 0C520206H                         ; 0238 _ 222495366 206701062 
        dd 00000807H, 0000001CH                         ; 0240 _ 2055 28 
        dd 00000248H                                    ; 0248 _ 584 
        dd warn_active-$+62EH                           ; 024C _ 00000000 (rel)
        dd 000000D6H, 100E4100H                         ; 0250 _ 214 269369600 
        dd 0D430286H, 0CD10206H                         ; 0258 _ 222495366 215024134 
        dd 00000807H, 0000001CH                         ; 0260 _ 2055 28 
        dd 00000268H                                    ; 0268 _ 616 
        dd warn_active-$+6E4H                           ; 026C _ 00000000 (rel)
        dd 00000048H, 100E4100H                         ; 0270 _ 72 269369600 
        dd 0D430286H, 0C430206H                         ; 0278 _ 222495366 205718022 
        dd 00000807H, 00000018H                         ; 0280 _ 2055 24 
        dd 00000288H                                    ; 0288 _ 648 
        dd warn_active-$+70CH                           ; 028C _ 00000000 (rel)
        dd 00000076H, 100E4100H                         ; 0290 _ 118 269369600 
        dd 0D430286H, 00000006H                         ; 0298 _ 222495366 6 
        dd 0000001CH, 000002A4H                         ; 02A0 _ 28 676 
        dd warn_active-$+766H                           ; 02A8 _ 00000000 (rel)
        dd 0000008AH, 100E4100H                         ; 02AC _ 138 269369600 
        dd 0D430286H, 0C850206H                         ; 02B4 _ 222495366 210043398 
        dd 00000807H, 00000018H                         ; 02BC _ 2055 24 
        dd 000002C4H                                    ; 02C4 _ 708 
        dd warn_active-$+7D0H                           ; 02C8 _ 00000000 (rel)
        dd 00000131H, 100E4100H                         ; 02CC _ 305 269369600 
        dd 0D430286H, 03834506H                         ; 02D4 _ 222495366 58934534 
        dd 0000001CH, 000002E0H                         ; 02DC _ 28 736 
        dd warn_active-$+8E5H                           ; 02E4 _ 00000000 (rel)
        dd 0000002BH, 100E4100H                         ; 02E8 _ 43 269369600 
        dd 0D430286H, 070C6606H                         ; 02F0 _ 222495366 118253062 
        dd 00000008H, 0000001CH                         ; 02F8 _ 8 28 
        dd 00000300H                                    ; 0300 _ 768 
        dd warn_active-$+8F0H                           ; 0304 _ 00000000 (rel)
        dd 00000045H, 100E4100H                         ; 0308 _ 69 269369600 
        dd 0D430286H, 0C400206H                         ; 0310 _ 222495366 205521414 
        dd 00000807H, 0000001CH                         ; 0318 _ 2055 28 
        dd 00000320H                                    ; 0320 _ 800 
        dd warn_active-$+915H                           ; 0324 _ 00000000 (rel)
        dd 000001C2H, 100E4100H                         ; 0328 _ 450 269369600 
        dd 0D430286H, 01BD0306H                         ; 0330 _ 222495366 29164294 
        dd 0008070CH, 00000020H                         ; 0338 _ 526092 32 
        dd 00000340H                                    ; 0340 _ 832 
        dd warn_active-$+0AB7H                          ; 0344 _ 00000000 (rel)
        dd 00000129H, 100E4100H                         ; 0348 _ 297 269369600 
        dd 0D430286H, 03834506H                         ; 0350 _ 222495366 58934534 
        dd 0C011F03H, 00000807H                         ; 0358 _ 201400067 2055 
        dd 0000001CH, 00000364H                         ; 0360 _ 28 868 
        dd warn_active-$+0BBCH                          ; 0368 _ 00000000 (rel)
        dd 0000061BH, 100E4100H                         ; 036C _ 1563 269369600 
        dd 0D430286H, 06160306H                         ; 0374 _ 222495366 102105862 
        dd 0008070CH, 0000001CH                         ; 037C _ 526092 28 
        dd 00000384H                                    ; 0384 _ 900 
        dd warn_active-$+11B7H                          ; 0388 _ 00000000 (rel)
        dd 000000BCH, 100E4100H                         ; 038C _ 188 269369600 
        dd 0D430286H, 0CB70206H                         ; 0394 _ 222495366 213320198 
        dd 00000807H, 0000001CH                         ; 039C _ 2055 28 
        dd 000003A4H                                    ; 03A4 _ 932 
        dd warn_active-$+1253H                          ; 03A8 _ 00000000 (rel)
        dd 00000030H, 100E4100H                         ; 03AC _ 48 269369600 
        dd 0D430286H, 070C6B06H                         ; 03B4 _ 222495366 118254342 
        dd 00000008H, 0000001CH                         ; 03BC _ 8 28 
        dd 000003C4H                                    ; 03C4 _ 964 
        dd warn_active-$+1263H                          ; 03C8 _ 00000000 (rel)
        dd 0000003DH, 100E4100H                         ; 03CC _ 61 269369600 
        dd 0D430286H, 070C7806H                         ; 03D4 _ 222495366 118257670 
        dd 00000008H                                    ; 03DC _ 8 


