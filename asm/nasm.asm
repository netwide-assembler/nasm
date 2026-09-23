; Disassembly of file: /tmp/tmp.QGyl5HoJgA.o
; Wed Sep 23 14:43:24 2026
; Type: ELF64
; Syntax: NASM
; Instruction set: Pentium Pro, x64

default rel

global nasm_set_limit: function
global nasm_get_limit: function
global nasm_limit_name: function
global switch_segment: function
global increment_offset: function
global main: function
global print_final_report: function
global close_output: function
global _progname
global tasm_compatible_mode
global _pass_type
global _passn
global official_compile_time
global ofmt_alias
global dfmt
global errflags_never
global ofile
global optimizing
global cpu
global cmd_cpu
global location
global in_absolute
global absolute
global depend_list
global nasm_limit
global _pass_types
global ofmt

extern warning_name                                     ; qword
extern warning_help                                     ; qword
extern dfmt_list                                        ; near
extern ofmt_list                                        ; near
extern strncasecmp                                      ; near
extern stdin                                            ; qword
extern cleanup_insn                                     ; near
extern process_insn                                     ; near
extern parse_line                                       ; near
extern process_directives                               ; near
extern globl                                            ; dword
extern saa_rewind                                       ; near
extern lfmt                                             ; qword
extern global_offset_changed                            ; qword
extern nasm_remove                                      ; near
extern nasm_fatal                                       ; near
extern nasm_info_                                       ; near
extern saa_wstruct                                      ; near
extern saa_rstruct                                      ; near
extern check_overwrite_files                            ; near
extern getenv                                           ; near
extern warning_default                                  ; qword
extern perror                                           ; near
extern nasm_open_read                                   ; near
extern strncpy                                          ; near
extern strcspn                                          ; near
extern nasm_realloc                                     ; near
extern fgets                                            ; near
extern nasm_panic_from_macro                            ; near
extern reproducible                                     ; byte
extern pp_pre_command                                   ; near
extern set_label_mangle                                 ; near
extern nasm_memicmp                                     ; near
extern set_warning_status                               ; near
extern set_error_format                                 ; near
extern list_update_options                              ; near
extern strlist_add                                      ; near
extern pp_pre_undefine                                  ; near
extern pp_pre_include                                   ; near
extern __isoc23_strtoul                                 ; near
extern ofmt_find                                        ; near
extern copy_filename                                    ; near
extern strchr                                           ; near
extern exit                                             ; near
extern printf                                           ; near
extern nasm_version                                     ; byte
extern nasm_date                                        ; byte
extern nasm_compile_options                             ; byte
extern strlcpy                                          ; near
extern nasm_malloc                                      ; near
extern strncmp                                          ; near
extern nasm_skip_spaces                                 ; near
extern cleanup_filenames                                ; near
extern src_free                                         ; near
extern stdscan_cleanup                                  ; near
extern eval_cleanup                                     ; near
extern saa_free                                         ; near
extern raa_free                                         ; near
extern pp_cleanup_session                               ; near
extern nasm_nonfatalf                                   ; near
extern ferror                                           ; near
extern fflush                                           ; near
extern cleanup_labels                                   ; near
extern fputc                                            ; near
extern error_pass_end                                   ; near
extern pp_cleanup_pass                                  ; near
extern pp_getline                                       ; near
extern pp_reset                                         ; near
extern error_pass_start                                 ; near
extern error_init                                       ; near
extern nasm_fatalf                                      ; near
extern dfmt_find                                        ; near
extern saa_init                                         ; near
extern init_labels                                      ; near
extern src_init                                         ; near
extern nasm_ctype_init                                  ; near
extern reset_global_defaults                            ; near
extern strlist_alloc                                    ; near
extern set_cpu                                          ; near
extern stderr                                           ; qword
extern nasm_strcat                                      ; near
extern set_filename                                     ; near
extern nasm_warn_                                       ; near
extern nasm_strdupto                                    ; near
extern filename_set_extension                           ; near
extern gmtime                                           ; near
extern localtime                                        ; near
extern time                                             ; near
extern nasm_quote                                       ; near
extern nasm_strdup                                      ; near
extern fclose                                           ; near
extern strlist_free                                     ; near
extern fwrite                                           ; near
extern fputs                                            ; near
extern strlen                                           ; near
extern fprintf                                          ; near
extern stdout                                           ; qword
extern nasm_nonfatal                                    ; near
extern nasm_open_write                                  ; near
extern pp_include_path                                  ; near
extern pp_init                                          ; near
extern null_debug_form                                  ; byte
extern pp_pre_define                                    ; near
extern strftime                                         ; near
extern raa_write                                        ; near
extern raa_read                                         ; near
extern __stack_chk_fail                                 ; near
extern readnum                                          ; near
extern strcmp                                           ; near
extern nasm_error                                       ; near
extern strcasecmp                                       ; near
extern nasm_get_stack_size_limit                        ; near
extern snprintf                                         ; near
extern of_bin                                           ; byte
extern _filenames                                       ; byte
extern nasm_assert_failed                               ; near
extern active_list_options                              ; qword
extern list_options                                     ; qword
extern warning_state                                    ; qword
extern erropt                                           ; qword
extern _src_bottom                                      ; qword
extern nasm_ctype_tab                                   ; byte
extern nasm_free                                        ; near
extern memset                                           ; near


SECTION .text   align=1 exec                            ; section number 1, code

mempset:; Local function
        push    rbp                                     ; 0000 _ 55
        mov     rbp, rsp                                ; 0001 _ 48: 89. E5
        sub     rsp, 32                                 ; 0004 _ 48: 83. EC, 20
        mov     qword [rbp-8H], rdi                     ; 0008 _ 48: 89. 7D, F8
        mov     dword [rbp-0CH], esi                    ; 000C _ 89. 75, F4
        mov     qword [rbp-18H], rdx                    ; 000F _ 48: 89. 55, E8
        mov     rdx, qword [rbp-18H]                    ; 0013 _ 48: 8B. 55, E8
        mov     ecx, dword [rbp-0CH]                    ; 0017 _ 8B. 4D, F4
        mov     rax, qword [rbp-8H]                     ; 001A _ 48: 8B. 45, F8
        mov     esi, ecx                                ; 001E _ 89. CE
        mov     rdi, rax                                ; 0020 _ 48: 89. C7
        call    memset                                  ; 0023 _ E8, 00000000(PLT r)
        mov     rdx, qword [rbp-18H]                    ; 0028 _ 48: 8B. 55, E8
        add     rax, rdx                                ; 002C _ 48: 01. D0
        leave                                           ; 002F _ C9
        ret                                             ; 0030 _ C3

nasm_strto:; Local function
        push    rbp                                     ; 0031 _ 55
        mov     rbp, rsp                                ; 0032 _ 48: 89. E5
        sub     rsp, 32                                 ; 0035 _ 48: 83. EC, 20
        mov     qword [rbp-18H], rdi                    ; 0039 _ 48: 89. 7D, E8
        mov     qword [rbp-20H], rsi                    ; 003D _ 48: 89. 75, E0
        mov     rax, qword [rbp-18H]                    ; 0041 _ 48: 8B. 45, E8
        mov     rax, qword [rax]                        ; 0045 _ 48: 8B. 00
        mov     qword [rbp-8H], rax                     ; 0048 _ 48: 89. 45, F8
        cmp     qword [rbp-20H], 0                      ; 004C _ 48: 83. 7D, E0, 00
        jnz     ?_001                                   ; 0051 _ 75, 06
        mov     rax, qword [rbp-8H]                     ; 0053 _ 48: 8B. 45, F8
        jmp     ?_003                                   ; 0057 _ EB, 25

?_001:  cmp     qword [rbp-8H], 0                       ; 0059 _ 48: 83. 7D, F8, 00
        jz      ?_002                                   ; 005E _ 74, 0C
        mov     rax, qword [rbp-8H]                     ; 0060 _ 48: 8B. 45, F8
        mov     rdi, rax                                ; 0064 _ 48: 89. C7
        call    nasm_free                               ; 0067 _ E8, 00000000(PLT r)
?_002:  mov     rax, qword [rbp-18H]                    ; 006C _ 48: 8B. 45, E8
        mov     rdx, qword [rbp-20H]                    ; 0070 _ 48: 8B. 55, E0
        mov     qword [rax], rdx                        ; 0074 _ 48: 89. 10
        mov     rax, qword [rbp-18H]                    ; 0077 _ 48: 8B. 45, E8
        mov     rax, qword [rax]                        ; 007B _ 48: 8B. 00
?_003:  leave                                           ; 007E _ C9
        ret                                             ; 007F _ C3

nasm_ctype:; Local function
        push    rbp                                     ; 0080 _ 55
        mov     rbp, rsp                                ; 0081 _ 48: 89. E5
        mov     byte [rbp-1H], dil                      ; 0084 _ 40: 88. 7D, FF
        mov     dword [rbp-8H], esi                     ; 0088 _ 89. 75, F8
        movzx   eax, byte [rbp-1H]                      ; 008B _ 0F B6. 45, FF
        cdqe                                            ; 008F _ 48: 98
        lea     rdx, [rax+rax]                          ; 0091 _ 48: 8D. 14 00
        lea     rax, [rel nasm_ctype_tab]               ; 0095 _ 48: 8D. 05, 00000000(rel)
        movzx   eax, word [rdx+rax]                     ; 009C _ 0F B7. 04 02
        movzx   eax, ax                                 ; 00A0 _ 0F B7. C0
        and     eax, dword [rbp-8H]                     ; 00A3 _ 23. 45, F8
        test    eax, eax                                ; 00A6 _ 85. C0
        setne   al                                      ; 00A8 _ 0F 95. C0
        pop     rbp                                     ; 00AB _ 5D
        ret                                             ; 00AC _ C3

nasm_isspace:; Local function
        push    rbp                                     ; 00AD _ 55
        mov     rbp, rsp                                ; 00AE _ 48: 89. E5
        sub     rsp, 8                                  ; 00B1 _ 48: 83. EC, 08
        mov     byte [rbp-1H], dil                      ; 00B5 _ 40: 88. 7D, FF
        movzx   eax, byte [rbp-1H]                      ; 00B9 _ 0F B6. 45, FF
        movzx   eax, al                                 ; 00BD _ 0F B6. C0
        mov     esi, 2                                  ; 00C0 _ BE, 00000002
        mov     edi, eax                                ; 00C5 _ 89. C7
        call    nasm_ctype                              ; 00C7 _ E8, FFFFFFB4
        leave                                           ; 00CC _ C9
        ret                                             ; 00CD _ C3

nasm_isquote:; Local function
        push    rbp                                     ; 00CE _ 55
        mov     rbp, rsp                                ; 00CF _ 48: 89. E5
        sub     rsp, 8                                  ; 00D2 _ 48: 83. EC, 08
        mov     byte [rbp-1H], dil                      ; 00D6 _ 40: 88. 7D, FF
        movzx   eax, byte [rbp-1H]                      ; 00DA _ 0F B6. 45, FF
        movzx   eax, al                                 ; 00DE _ 0F B6. C0
        mov     esi, 4096                               ; 00E1 _ BE, 00001000
        mov     edi, eax                                ; 00E6 _ 89. C7
        call    nasm_ctype                              ; 00E8 _ E8, FFFFFF93
        leave                                           ; 00ED _ C9
        ret                                             ; 00EE _ C3

nasm_ctype_tasm_mode:; Local function
        push    rbp                                     ; 00EF _ 55
        mov     rbp, rsp                                ; 00F0 _ 48: 89. E5
        nop                                             ; 00F3 _ 90
        pop     rbp                                     ; 00F4 _ 5D
        ret                                             ; 00F5 _ C3

strlist_head:; Local function
        push    rbp                                     ; 00F6 _ 55
        mov     rbp, rsp                                ; 00F7 _ 48: 89. E5
        mov     qword [rbp-8H], rdi                     ; 00FA _ 48: 89. 7D, F8
        cmp     qword [rbp-8H], 0                       ; 00FE _ 48: 83. 7D, F8, 00
        jz      ?_004                                   ; 0103 _ 74, 0A
        mov     rax, qword [rbp-8H]                     ; 0105 _ 48: 8B. 45, F8
        mov     rax, qword [rax+20H]                    ; 0109 _ 48: 8B. 40, 20
        jmp     ?_005                                   ; 010D _ EB, 05

?_004:  mov     eax, 0                                  ; 010F _ B8, 00000000
?_005:  pop     rbp                                     ; 0114 _ 5D
        ret                                             ; 0115 _ C3

src_where:; Local function
        push    rbp                                     ; 0116 _ 55
        mov     rbp, rsp                                ; 0117 _ 48: 89. E5
        mov     rax, qword [rel _src_bottom]            ; 011A _ 48: 8B. 05, 00000000(rel)
        mov     rdx, qword [rax+8H]                     ; 0121 _ 48: 8B. 50, 08
        mov     rax, qword [rax]                        ; 0125 _ 48: 8B. 00
        pop     rbp                                     ; 0128 _ 5D
        ret                                             ; 0129 _ C3

warn_active:; Local function
        push    rbp                                     ; 012A _ 55
        mov     rbp, rsp                                ; 012B _ 48: 89. E5
        mov     dword [rbp-4H], edi                     ; 012E _ 89. 7D, FC
        mov     eax, dword [rel erropt+0CH]             ; 0131 _ 8B. 05, 00000000(rel)
        and     eax, dword [rbp-4H]                     ; 0137 _ 23. 45, FC
        test    eax, eax                                ; 013A _ 85. C0
        jz      ?_006                                   ; 013C _ 74, 07
        mov     eax, 0                                  ; 013E _ B8, 00000000
        jmp     ?_007                                   ; 0143 _ EB, 16

?_006:  mov     eax, dword [rbp-4H]                     ; 0145 _ 8B. 45, FC
        shr     eax, 16                                 ; 0148 _ C1. E8, 10
        mov     edx, eax                                ; 014B _ 89. C2
        lea     rax, [rel warning_state]                ; 014D _ 48: 8D. 05, 00000000(rel)
        movzx   eax, byte [rdx+rax]                     ; 0154 _ 0F B6. 04 02
        and     eax, 01H                                ; 0158 _ 83. E0, 01
?_007:  pop     rbp                                     ; 015B _ 5D
        ret                                             ; 015C _ C3

info_level:; Local function
        push    rbp                                     ; 015D _ 55
        mov     rbp, rsp                                ; 015E _ 48: 89. E5
        mov     dword [rbp-4H], edi                     ; 0161 _ 89. 7D, FC
        mov     eax, dword [rel erropt+14H]             ; 0164 _ 8B. 05, 00000000(rel)
        cmp     eax, dword [rbp-4H]                     ; 016A _ 3B. 45, FC
        setae   al                                      ; 016D _ 0F 93. C0
        movzx   eax, al                                 ; 0170 _ 0F B6. C0
        test    rax, rax                                ; 0173 _ 48: 85. C0
        setne   al                                      ; 0176 _ 0F 95. C0
        pop     rbp                                     ; 0179 _ 5D
        ret                                             ; 017A _ C3

pass_type:; Local function
        push    rbp                                     ; 017B _ 55
        mov     rbp, rsp                                ; 017C _ 48: 89. E5
        mov     eax, dword [rel _pass_type]             ; 017F _ 8B. 05, 00000000(rel)
        pop     rbp                                     ; 0185 _ 5D
        ret                                             ; 0186 _ C3

not_started:; Local function
        push    rbp                                     ; 0187 _ 55
        mov     rbp, rsp                                ; 0188 _ 48: 89. E5
        call    pass_type                               ; 018B _ E8, FFFFFFEB
        test    eax, eax                                ; 0190 _ 85. C0
        sete    al                                      ; 0192 _ 0F 94. C0
        pop     rbp                                     ; 0195 _ 5D
        ret                                             ; 0196 _ C3

pass_first:; Local function
        push    rbp                                     ; 0197 _ 55
        mov     rbp, rsp                                ; 0198 _ 48: 89. E5
        call    pass_type                               ; 019B _ E8, FFFFFFDB
        cmp     eax, 2                                  ; 01A0 _ 83. F8, 02
        setbe   al                                      ; 01A3 _ 0F 96. C0
        pop     rbp                                     ; 01A6 _ 5D
        ret                                             ; 01A7 _ C3

pass_final:; Local function
        push    rbp                                     ; 01A8 _ 55
        mov     rbp, rsp                                ; 01A9 _ 48: 89. E5
        call    pass_type                               ; 01AC _ E8, FFFFFFCA
        cmp     eax, 4                                  ; 01B1 _ 83. F8, 04
        seta    al                                      ; 01B4 _ 0F 97. C0
        pop     rbp                                     ; 01B7 _ 5D
        ret                                             ; 01B8 _ C3

pass_count:; Local function
        push    rbp                                     ; 01B9 _ 55
        mov     rbp, rsp                                ; 01BA _ 48: 89. E5
        mov     rax, qword [rel _passn]                 ; 01BD _ 48: 8B. 05, 00000000(rel)
        pop     rbp                                     ; 01C4 _ 5D
        ret                                             ; 01C5 _ C3

_iflag_cpu_level:; Local function
        push    rbp                                     ; 01C6 _ 55
        mov     rbp, rsp                                ; 01C7 _ 48: 89. E5
        mov     qword [rbp-8H], rdi                     ; 01CA _ 48: 89. 7D, F8
        mov     rax, qword [rbp-8H]                     ; 01CE _ 48: 8B. 45, F8
        mov     eax, dword [rax+18H]                    ; 01D2 _ 8B. 40, 18
        and     eax, 3FFFFH                             ; 01D5 _ 25, 0003FFFF
        pop     rbp                                     ; 01DA _ 5D
        ret                                             ; 01DB _ C3

iflag_cpu_level_ok:; Local function
        push    rbp                                     ; 01DC _ 55
        mov     rbp, rsp                                ; 01DD _ 48: 89. E5
        sub     rsp, 16                                 ; 01E0 _ 48: 83. EC, 10
        mov     qword [rbp-8H], rdi                     ; 01E4 _ 48: 89. 7D, F8
        mov     dword [rbp-0CH], esi                    ; 01E8 _ 89. 75, F4
        mov     rax, qword [rbp-8H]                     ; 01EB _ 48: 8B. 45, F8
        mov     rdi, rax                                ; 01EF _ 48: 89. C7
        call    _iflag_cpu_level                        ; 01F2 _ E8, FFFFFFCF
        mov     edx, dword [rbp-0CH]                    ; 01F7 _ 8B. 55, F4
        and     edx, 1FH                                ; 01FA _ 83. E2, 1F
        mov     ecx, edx                                ; 01FD _ 89. D1
        shr     eax, cl                                 ; 01FF _ D3. E8
        test    eax, eax                                ; 0201 _ 85. C0
        setne   al                                      ; 0203 _ 0F 95. C0
        leave                                           ; 0206 _ C9
        ret                                             ; 0207 _ C3

list_option_mask:; Local function
        push    rbp                                     ; 0208 _ 55
        mov     rbp, rsp                                ; 0209 _ 48: 89. E5
        mov     byte [rbp-1H], dil                      ; 020C _ 40: 88. 7D, FF
        cmp     byte [rbp-1H], 96                       ; 0210 _ 80. 7D, FF, 60
        jbe     ?_009                                   ; 0214 _ 76, 13
        cmp     byte [rbp-1H], 122                      ; 0216 _ 80. 7D, FF, 7A
        jbe     ?_008                                   ; 021A _ 76, 07
        mov     eax, 0                                  ; 021C _ B8, 00000000
        jmp     ?_015                                   ; 0221 _ EB, 50

?_008:  sub     byte [rbp-1H], 95                       ; 0223 _ 80. 6D, FF, 5F
        jmp     ?_014                                   ; 0227 _ EB, 39

?_009:  cmp     byte [rbp-1H], 64                       ; 0229 _ 80. 7D, FF, 40
        jbe     ?_011                                   ; 022D _ 76, 13
        cmp     byte [rbp-1H], 90                       ; 022F _ 80. 7D, FF, 5A
        jbe     ?_010                                   ; 0233 _ 76, 07
        mov     eax, 0                                  ; 0235 _ B8, 00000000
        jmp     ?_015                                   ; 023A _ EB, 37

?_010:  sub     byte [rbp-1H], 37                       ; 023C _ 80. 6D, FF, 25
        jmp     ?_014                                   ; 0240 _ EB, 20

?_011:  cmp     byte [rbp-1H], 47                       ; 0242 _ 80. 7D, FF, 2F
        jbe     ?_013                                   ; 0246 _ 76, 13
        cmp     byte [rbp-1H], 57                       ; 0248 _ 80. 7D, FF, 39
        jbe     ?_012                                   ; 024C _ 76, 07
        mov     eax, 0                                  ; 024E _ B8, 00000000
        jmp     ?_015                                   ; 0253 _ EB, 1E

?_012:  add     byte [rbp-1H], 6                        ; 0255 _ 80. 45, FF, 06
        jmp     ?_014                                   ; 0259 _ EB, 07

?_013:  mov     eax, 0                                  ; 025B _ B8, 00000000
        jmp     ?_015                                   ; 0260 _ EB, 11

?_014:  movzx   eax, byte [rbp-1H]                      ; 0262 _ 0F B6. 45, FF
        mov     edx, 1                                  ; 0266 _ BA, 00000001
        mov     ecx, eax                                ; 026B _ 89. C1
        shl     rdx, cl                                 ; 026D _ 48: D3. E2
        mov     rax, rdx                                ; 0270 _ 48: 89. D0
?_015:  pop     rbp                                     ; 0273 _ 5D
        ret                                             ; 0274 _ C3

list_on_this_pass:; Local function
        push    rbp                                     ; 0275 _ 55
        mov     rbp, rsp                                ; 0276 _ 48: 89. E5
        call    pass_final                              ; 0279 _ E8, FFFFFF2A
        test    al, al                                  ; 027E _ 84. C0
        jnz     ?_016                                   ; 0280 _ 75, 22
        mov     edi, 112                                ; 0282 _ BF, 00000070
        call    list_option_mask                        ; 0287 _ E8, FFFFFF7C
        mov     rdx, qword [rel list_options]           ; 028C _ 48: 8B. 15, 00000000(rel)
        and     rax, rdx                                ; 0293 _ 48: 21. D0
        test    rax, rax                                ; 0296 _ 48: 85. C0
        setne   al                                      ; 0299 _ 0F 95. C0
        movzx   eax, al                                 ; 029C _ 0F B6. C0
        test    rax, rax                                ; 029F _ 48: 85. C0
        jz      ?_017                                   ; 02A2 _ 74, 07
?_016:  mov     eax, 1                                  ; 02A4 _ B8, 00000001
        jmp     ?_018                                   ; 02A9 _ EB, 05

?_017:  mov     eax, 0                                  ; 02AB _ B8, 00000000
?_018:  and     eax, 01H                                ; 02B0 _ 83. E0, 01
        pop     rbp                                     ; 02B3 _ 5D
        ret                                             ; 02B4 _ C3

list_active:; Local function
        push    rbp                                     ; 02B5 _ 55
        mov     rbp, rsp                                ; 02B6 _ 48: 89. E5
        mov     rax, qword [rel active_list_options]    ; 02B9 _ 48: 8B. 05, 00000000(rel)
        and     eax, 01H                                ; 02C0 _ 83. E0, 01
        pop     rbp                                     ; 02C3 _ 5D
        ret                                             ; 02C4 _ C3

get_filename:; Local function
        push    rbp                                     ; 02C5 _ 55
        mov     rbp, rsp                                ; 02C6 _ 48: 89. E5
        sub     rsp, 16                                 ; 02C9 _ 48: 83. EC, 10
        mov     dword [rbp-4H], edi                     ; 02CD _ 89. 7D, FC
        cmp     dword [rbp-4H], 8                       ; 02D0 _ 83. 7D, FC, 08
        seta    al                                      ; 02D4 _ 0F 97. C0
        movzx   eax, al                                 ; 02D7 _ 0F B6. C0
        test    rax, rax                                ; 02DA _ 48: 85. C0
        jz      ?_019                                   ; 02DD _ 74, 22
        lea     rdx, [rel ?_507]                        ; 02DF _ 48: 8D. 15, 00000000(rel)
        lea     rsi, [rel __func__.4]                   ; 02E6 _ 48: 8D. 35, 00000000(rel)
        lea     rax, [rel ?_508]                        ; 02ED _ 48: 8D. 05, 00000000(rel)
        mov     ecx, 49                                 ; 02F4 _ B9, 00000031
        mov     rdi, rax                                ; 02F9 _ 48: 89. C7
        call    nasm_assert_failed                      ; 02FC _ E8, 00000000(PLT r)
?_019:  mov     eax, dword [rbp-4H]                     ; 0301 _ 8B. 45, FC
        lea     rdx, [rax*8]                            ; 0304 _ 48: 8D. 14 C5, 00000000
        lea     rax, [rel _filenames]                   ; 030C _ 48: 8D. 05, 00000000(rel)
        mov     rax, qword [rdx+rax]                    ; 0313 _ 48: 8B. 04 02
        leave                                           ; 0317 _ C9
        ret                                             ; 0318 _ C3

terminate_after_phase:; Local function
        push    rbp                                     ; 0319 _ 55
        mov     rbp, rsp                                ; 031A _ 48: 89. E5
        mov     eax, dword [rel erropt+8H]              ; 031D _ 8B. 05, 00000000(rel)
        cmp     eax, 7                                  ; 0323 _ 83. F8, 07
        seta    al                                      ; 0326 _ 0F 97. C0
        pop     rbp                                     ; 0329 _ 5D
        ret                                             ; 032A _ C3

limit_default:; Local function
        push    rbp                                     ; 032B _ 55
        mov     rbp, rsp                                ; 032C _ 48: 89. E5
        mov     dword [rbp-24H], edi                    ; 032F _ 89. 7D, DC
        cmp     dword [rbp-24H], 8                      ; 0332 _ 83. 7D, DC, 08
        jbe     ?_020                                   ; 0336 _ 76, 07
        mov     eax, 0                                  ; 0338 _ B8, 00000000
        jmp     ?_025                                   ; 033D _ EB, 70

?_020:  mov     eax, dword [rbp-24H]                    ; 033F _ 8B. 45, DC
        shl     rax, 5                                  ; 0342 _ 48: C1. E0, 05
        mov     rdx, rax                                ; 0346 _ 48: 89. C2
        lea     rax, [rel limit_info]                   ; 0349 _ 48: 8D. 05, 00000000(rel)
        add     rax, rdx                                ; 0350 _ 48: 01. D0
        mov     qword [rbp-10H], rax                    ; 0353 _ 48: 89. 45, F0
        mov     rax, qword [rbp-10H]                    ; 0357 _ 48: 8B. 45, F0
        mov     rax, qword [rax+18H]                    ; 035B _ 48: 8B. 40, 18
        mov     qword [rbp-18H], rax                    ; 035F _ 48: 89. 45, E8
        cmp     qword [rbp-18H], 0                      ; 0363 _ 48: 83. 7D, E8, 00
        jz      ?_021                                   ; 0368 _ 74, 10
        mov     rax, qword 3FFFFFFFFFFFFFFFH            ; 036A _ 48: B8, 3FFFFFFFFFFFFFFF
        cmp     qword [rbp-18H], rax                    ; 0374 _ 48: 39. 45, E8
        jle     ?_022                                   ; 0378 _ 7E, 0E
?_021:  mov     rax, qword 3FFFFFFFFFFFFFFFH            ; 037A _ 48: B8, 3FFFFFFFFFFFFFFF
        mov     qword [rbp-18H], rax                    ; 0384 _ 48: 89. 45, E8
?_022:  mov     rax, qword [rbp-10H]                    ; 0388 _ 48: 8B. 45, F0
        mov     rax, qword [rax+10H]                    ; 038C _ 48: 8B. 40, 10
        mov     qword [rbp-8H], rax                     ; 0390 _ 48: 89. 45, F8
        cmp     qword [rbp-8H], 0                       ; 0394 _ 48: 83. 7D, F8, 00
        jz      ?_023                                   ; 0399 _ 74, 0A
        mov     rax, qword [rbp-8H]                     ; 039B _ 48: 8B. 45, F8
        cmp     rax, qword [rbp-18H]                    ; 039F _ 48: 3B. 45, E8
        jle     ?_024                                   ; 03A3 _ 7E, 06
?_023:  mov     rax, qword [rbp-18H]                    ; 03A5 _ 48: 8B. 45, E8
        jmp     ?_025                                   ; 03A9 _ EB, 04

?_024:  mov     rax, qword [rbp-8H]                     ; 03AB _ 48: 8B. 45, F8
?_025:  pop     rbp                                     ; 03AF _ 5D
        ret                                             ; 03B0 _ C3

limit_max:; Local function
        push    rbp                                     ; 03B1 _ 55
        mov     rbp, rsp                                ; 03B2 _ 48: 89. E5
        mov     dword [rbp-14H], edi                    ; 03B5 _ 89. 7D, EC
        cmp     dword [rbp-14H], 8                      ; 03B8 _ 83. 7D, EC, 08
        jbe     ?_026                                   ; 03BC _ 76, 07
        mov     eax, 0                                  ; 03BE _ B8, 00000000
        jmp     ?_029                                   ; 03C3 _ EB, 4D

?_026:  mov     eax, dword [rbp-14H]                    ; 03C5 _ 8B. 45, EC
        shl     rax, 5                                  ; 03C8 _ 48: C1. E0, 05
        mov     rdx, rax                                ; 03CC _ 48: 89. C2
        lea     rax, [rel limit_info]                   ; 03CF _ 48: 8D. 05, 00000000(rel)
        add     rax, rdx                                ; 03D6 _ 48: 01. D0
        mov     qword [rbp-8H], rax                     ; 03D9 _ 48: 89. 45, F8
        mov     rax, qword [rbp-8H]                     ; 03DD _ 48: 8B. 45, F8
        mov     rax, qword [rax+18H]                    ; 03E1 _ 48: 8B. 40, 18
        mov     qword [rbp-10H], rax                    ; 03E5 _ 48: 89. 45, F0
        cmp     qword [rbp-10H], 0                      ; 03E9 _ 48: 83. 7D, F0, 00
        jz      ?_027                                   ; 03EE _ 74, 10
        mov     rax, qword 3FFFFFFFFFFFFFFFH            ; 03F0 _ 48: B8, 3FFFFFFFFFFFFFFF
        cmp     qword [rbp-10H], rax                    ; 03FA _ 48: 39. 45, F0
        jle     ?_028                                   ; 03FE _ 7E, 0E
?_027:  mov     rax, qword 3FFFFFFFFFFFFFFFH            ; 0400 _ 48: B8, 3FFFFFFFFFFFFFFF
        mov     qword [rbp-10H], rax                    ; 040A _ 48: 89. 45, F0
?_028:  mov     rax, qword [rbp-10H]                    ; 040E _ 48: 8B. 45, F0
?_029:  pop     rbp                                     ; 0412 _ 5D
        ret                                             ; 0413 _ C3

limit_str:; Local function
        push    rbp                                     ; 0414 _ 55
        mov     rbp, rsp                                ; 0415 _ 48: 89. E5
        sub     rsp, 16                                 ; 0418 _ 48: 83. EC, 10
        mov     qword [rbp-8H], rdi                     ; 041C _ 48: 89. 7D, F8
        mov     rax, qword 3FFFFFFFFFFFFFFEH            ; 0420 _ 48: B8, 3FFFFFFFFFFFFFFE
        cmp     qword [rbp-8H], rax                     ; 042A _ 48: 39. 45, F8
        jg      ?_030                                   ; 042E _ 7F, 2D
        mov     rax, qword [rbp-8H]                     ; 0430 _ 48: 8B. 45, F8
        lea     rdx, [rel ?_510]                        ; 0434 _ 48: 8D. 15, 00000000(rel)
        lea     rdi, [rel buf.5]                        ; 043B _ 48: 8D. 3D, 00000000(rel)
        mov     rcx, rax                                ; 0442 _ 48: 89. C1
        mov     esi, 27                                 ; 0445 _ BE, 0000001B
        mov     eax, 0                                  ; 044A _ B8, 00000000
        call    snprintf                                ; 044F _ E8, 00000000(PLT r)
        lea     rax, [rel buf.5]                        ; 0454 _ 48: 8D. 05, 00000000(rel)
        jmp     ?_031                                   ; 045B _ EB, 07

?_030:  lea     rax, [rel ?_511]                        ; 045D _ 48: 8D. 05, 00000000(rel)
?_031:  leave                                           ; 0464 _ C9
        ret                                             ; 0465 _ C3

set_default_limits:; Local function
        push    rbp                                     ; 0466 _ 55
        mov     rbp, rsp                                ; 0467 _ 48: 89. E5
        sub     rsp, 32                                 ; 046A _ 48: 83. EC, 20
        mov     dword [rbp-14H], 0                      ; 046E _ C7. 45, EC, 00000000
        jmp     ?_033                                   ; 0475 _ EB, 27

?_032:  mov     eax, dword [rbp-14H]                    ; 0477 _ 8B. 45, EC
        mov     edi, eax                                ; 047A _ 89. C7
        call    limit_default                           ; 047C _ E8, FFFFFEAA
        mov     edx, dword [rbp-14H]                    ; 0481 _ 8B. 55, EC
        movsxd  rdx, edx                                ; 0484 _ 48: 63. D2
        lea     rcx, [rdx*8]                            ; 0487 _ 48: 8D. 0C D5, 00000000
        lea     rdx, [rel nasm_limit]                   ; 048F _ 48: 8D. 15, 00000000(rel)
        mov     qword [rcx+rdx], rax                    ; 0496 _ 48: 89. 04 11
        add     dword [rbp-14H], 1                      ; 049A _ 83. 45, EC, 01
?_033:  cmp     dword [rbp-14H], 8                      ; 049E _ 83. 7D, EC, 08
        jle     ?_032                                   ; 04A2 _ 7E, D3
        call    nasm_get_stack_size_limit               ; 04A4 _ E8, 00000000(PLT r)
        mov     qword [rbp-10H], rax                    ; 04A9 _ 48: 89. 45, F0
        mov     rax, qword [rbp-10H]                    ; 04AD _ 48: 8B. 45, F0
        shr     rax, 10                                 ; 04B1 _ 48: C1. E8, 0A
        mov     qword [rbp-8H], rax                     ; 04B5 _ 48: 89. 45, F8
        mov     rax, qword [rel nasm_limit+30H]         ; 04B9 _ 48: 8B. 05, 00000000(rel)
        cmp     qword [rbp-8H], rax                     ; 04C0 _ 48: 39. 45, F8
        jge     ?_034                                   ; 04C4 _ 7D, 0B
        mov     rax, qword [rbp-8H]                     ; 04C6 _ 48: 8B. 45, F8
        mov     qword [rel nasm_limit+30H], rax         ; 04CA _ 48: 89. 05, 00000000(rel)
?_034:  nop                                             ; 04D1 _ 90
        leave                                           ; 04D2 _ C9
        ret                                             ; 04D3 _ C3

nasm_set_limit:; Function begin
        push    rbp                                     ; 04D4 _ 55
        mov     rbp, rsp                                ; 04D5 _ 48: 89. E5
        sub     rsp, 80                                 ; 04D8 _ 48: 83. EC, 50
        mov     qword [rbp-48H], rdi                    ; 04DC _ 48: 89. 7D, B8
        mov     qword [rbp-50H], rsi                    ; 04E0 _ 48: 89. 75, B0
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        mov     rax, qword [fs:abs 28H]                 ; 04E4 _ 64 48: 8B. 04 25, 00000028
        mov     qword [rbp-8H], rax                     ; 04ED _ 48: 89. 45, F8
        xor     eax, eax                                ; 04F1 _ 31. C0
        cmp     qword [rbp-48H], 0                      ; 04F3 _ 48: 83. 7D, B8, 00
        jnz     ?_035                                   ; 04F8 _ 75, 0B
        lea     rax, [rel ?_512]                        ; 04FA _ 48: 8D. 05, 00000000(rel)
        mov     qword [rbp-48H], rax                    ; 0501 _ 48: 89. 45, B8
?_035:  cmp     qword [rbp-50H], 0                      ; 0505 _ 48: 83. 7D, B0, 00
        jnz     ?_036                                   ; 050A _ 75, 0B
        lea     rax, [rel ?_512]                        ; 050C _ 48: 8D. 05, 00000000(rel)
        mov     qword [rbp-50H], rax                    ; 0513 _ 48: 89. 45, B0
?_036:  mov     dword [rbp-30H], 0                      ; 0517 _ C7. 45, D0, 00000000
        jmp     ?_038                                   ; 051E _ EB, 2E

?_037:  mov     eax, dword [rbp-30H]                    ; 0520 _ 8B. 45, D0
        cdqe                                            ; 0523 _ 48: 98
        shl     rax, 5                                  ; 0525 _ 48: C1. E0, 05
        mov     rdx, rax                                ; 0529 _ 48: 89. C2
        lea     rax, [rel limit_info]                   ; 052C _ 48: 8D. 05, 00000000(rel)
        mov     rdx, qword [rdx+rax]                    ; 0533 _ 48: 8B. 14 02
        mov     rax, qword [rbp-48H]                    ; 0537 _ 48: 8B. 45, B8
        mov     rsi, rdx                                ; 053B _ 48: 89. D6
        mov     rdi, rax                                ; 053E _ 48: 89. C7
        call    strcasecmp                              ; 0541 _ E8, 00000000(PLT r)
        test    eax, eax                                ; 0546 _ 85. C0
        jz      ?_039                                   ; 0548 _ 74, 0C
        add     dword [rbp-30H], 1                      ; 054A _ 83. 45, D0, 01
?_038:  cmp     dword [rbp-30H], 8                      ; 054E _ 83. 7D, D0, 08
        jle     ?_037                                   ; 0552 _ 7E, CC
        jmp     ?_040                                   ; 0554 _ EB, 01

?_039:  nop                                             ; 0556 _ 90
?_040:  cmp     dword [rbp-30H], 8                      ; 0557 _ 83. 7D, D0, 08
        jle     ?_043                                   ; 055B _ 7E, 40
        call    not_started                             ; 055D _ E8, FFFFFC25
        test    al, al                                  ; 0562 _ 84. C0
        jz      ?_041                                   ; 0564 _ 74, 09
        mov     dword [rbp-2CH], 4456582                ; 0566 _ C7. 45, D4, 00440086
        jmp     ?_042                                   ; 056D _ EB, 07

?_041:  mov     dword [rbp-2CH], 2752518                ; 056F _ C7. 45, D4, 002A0006
?_042:  mov     eax, dword [rbp-2CH]                    ; 0576 _ 8B. 45, D4
        mov     rdx, qword [rbp-48H]                    ; 0579 _ 48: 8B. 55, B8
        lea     rcx, [rel ?_513]                        ; 057D _ 48: 8D. 0D, 00000000(rel)
        mov     rsi, rcx                                ; 0584 _ 48: 89. CE
        mov     edi, eax                                ; 0587 _ 89. C7
        mov     eax, 0                                  ; 0589 _ B8, 00000000
        call    nasm_error                              ; 058E _ E8, 00000000(PLT r)
        mov     eax, 2                                  ; 0593 _ B8, 00000002
        jmp     ?_056                                   ; 0598 _ E9, 000001FF

?_043:  mov     eax, dword [rbp-30H]                    ; 059D _ 8B. 45, D0
        mov     edi, eax                                ; 05A0 _ 89. C7
        call    limit_max                               ; 05A2 _ E8, FFFFFE0A
        mov     qword [rbp-18H], rax                    ; 05A7 _ 48: 89. 45, E8
        mov     eax, dword [rbp-30H]                    ; 05AB _ 8B. 45, D0
        mov     edi, eax                                ; 05AE _ 89. C7
        call    limit_default                           ; 05B0 _ E8, FFFFFD76
        mov     qword [rbp-10H], rax                    ; 05B5 _ 48: 89. 45, F0
        mov     eax, dword [rbp-30H]                    ; 05B9 _ 8B. 45, D0
        cdqe                                            ; 05BC _ 48: 98
        lea     rdx, [rax*8]                            ; 05BE _ 48: 8D. 14 C5, 00000000
        lea     rax, [rel nasm_limit_from_cmdline]      ; 05C6 _ 48: 8D. 05, 00000000(rel)
        mov     rax, qword [rdx+rax]                    ; 05CD _ 48: 8B. 04 02
        mov     qword [rbp-20H], rax                    ; 05D1 _ 48: 89. 45, E0
        cmp     qword [rbp-20H], 0                      ; 05D5 _ 48: 83. 7D, E0, 00
        jnz     ?_044                                   ; 05DA _ 75, 08
        mov     rax, qword [rbp-10H]                    ; 05DC _ 48: 8B. 45, F0
        mov     qword [rbp-20H], rax                    ; 05E0 _ 48: 89. 45, E0
?_044:  lea     rdx, [rel ?_514]                        ; 05E4 _ 48: 8D. 15, 00000000(rel)
        mov     rax, qword [rbp-50H]                    ; 05EB _ 48: 8B. 45, B0
        mov     rsi, rdx                                ; 05EF _ 48: 89. D6
        mov     rdi, rax                                ; 05F2 _ 48: 89. C7
        call    strcmp                                  ; 05F5 _ E8, 00000000(PLT r)
        test    eax, eax                                ; 05FA _ 85. C0
        jz      ?_045                                   ; 05FC _ 74, 34
        lea     rdx, [rel ?_515]                        ; 05FE _ 48: 8D. 15, 00000000(rel)
        mov     rax, qword [rbp-50H]                    ; 0605 _ 48: 8B. 45, B0
        mov     rsi, rdx                                ; 0609 _ 48: 89. D6
        mov     rdi, rax                                ; 060C _ 48: 89. C7
        call    strcasecmp                              ; 060F _ E8, 00000000(PLT r)
        test    eax, eax                                ; 0614 _ 85. C0
        jz      ?_045                                   ; 0616 _ 74, 1A
        lea     rdx, [rel ?_509]                        ; 0618 _ 48: 8D. 15, 00000000(rel)
        mov     rax, qword [rbp-50H]                    ; 061F _ 48: 8B. 45, B0
        mov     rsi, rdx                                ; 0623 _ 48: 89. D6
        mov     rdi, rax                                ; 0626 _ 48: 89. C7
        call    strcasecmp                              ; 0629 _ E8, 00000000(PLT r)
        test    eax, eax                                ; 062E _ 85. C0
        jnz     ?_046                                   ; 0630 _ 75, 0D
?_045:  mov     rax, qword [rbp-20H]                    ; 0632 _ 48: 8B. 45, E0
        mov     qword [rbp-28H], rax                    ; 0636 _ 48: 89. 45, D8
        jmp     ?_055                                   ; 063A _ E9, 0000013C

?_046:  lea     rdx, [rel ?_516]                        ; 063F _ 48: 8D. 15, 00000000(rel)
        mov     rax, qword [rbp-50H]                    ; 0646 _ 48: 8B. 45, B0
        mov     rsi, rdx                                ; 064A _ 48: 89. D6
        mov     rdi, rax                                ; 064D _ 48: 89. C7
        call    strcasecmp                              ; 0650 _ E8, 00000000(PLT r)
        test    eax, eax                                ; 0655 _ 85. C0
        jnz     ?_047                                   ; 0657 _ 75, 0D
        mov     rax, qword [rbp-10H]                    ; 0659 _ 48: 8B. 45, F0
        mov     qword [rbp-28H], rax                    ; 065D _ 48: 89. 45, D8
        jmp     ?_055                                   ; 0661 _ E9, 00000115

?_047:  lea     rdx, [rel ?_511]                        ; 0666 _ 48: 8D. 15, 00000000(rel)
        mov     rax, qword [rbp-50H]                    ; 066D _ 48: 8B. 45, B0
        mov     rsi, rdx                                ; 0671 _ 48: 89. D6
        mov     rdi, rax                                ; 0674 _ 48: 89. C7
        call    strcasecmp                              ; 0677 _ E8, 00000000(PLT r)
        test    eax, eax                                ; 067C _ 85. C0
        jz      ?_048                                   ; 067E _ 74, 34
        lea     rdx, [rel ?_517]                        ; 0680 _ 48: 8D. 15, 00000000(rel)
        mov     rax, qword [rbp-50H]                    ; 0687 _ 48: 8B. 45, B0
        mov     rsi, rdx                                ; 068B _ 48: 89. D6
        mov     rdi, rax                                ; 068E _ 48: 89. C7
        call    strcasecmp                              ; 0691 _ E8, 00000000(PLT r)
        test    eax, eax                                ; 0696 _ 85. C0
        jz      ?_048                                   ; 0698 _ 74, 1A
        lea     rdx, [rel ?_518]                        ; 069A _ 48: 8D. 15, 00000000(rel)
        mov     rax, qword [rbp-50H]                    ; 06A1 _ 48: 8B. 45, B0
        mov     rsi, rdx                                ; 06A5 _ 48: 89. D6
        mov     rdi, rax                                ; 06A8 _ 48: 89. C7
        call    strcasecmp                              ; 06AB _ E8, 00000000(PLT r)
        test    eax, eax                                ; 06B0 _ 85. C0
        jnz     ?_049                                   ; 06B2 _ 75, 0D
?_048:  mov     rax, qword [rbp-18H]                    ; 06B4 _ 48: 8B. 45, E8
        mov     qword [rbp-28H], rax                    ; 06B8 _ 48: 89. 45, D8
        jmp     ?_055                                   ; 06BC _ E9, 000000BA

?_049:  call    not_started                             ; 06C1 _ E8, FFFFFAC1
        test    al, al                                  ; 06C6 _ 84. C0
        jz      ?_050                                   ; 06C8 _ 74, 09
        mov     dword [rbp-2CH], 4456582                ; 06CA _ C7. 45, D4, 00440086
        jmp     ?_051                                   ; 06D1 _ EB, 07

?_050:  mov     dword [rbp-2CH], 2555910                ; 06D3 _ C7. 45, D4, 00270006
?_051:  lea     rdx, [rbp-31H]                          ; 06DA _ 48: 8D. 55, CF
        mov     rax, qword [rbp-50H]                    ; 06DE _ 48: 8B. 45, B0
        mov     rsi, rdx                                ; 06E2 _ 48: 89. D6
        mov     rdi, rax                                ; 06E5 _ 48: 89. C7
        call    readnum                                 ; 06E8 _ E8, 00000000(PLT r)
        mov     qword [rbp-28H], rax                    ; 06ED _ 48: 89. 45, D8
        movzx   eax, byte [rbp-31H]                     ; 06F1 _ 0F B6. 45, CF
        test    al, al                                  ; 06F5 _ 84. C0
        jnz     ?_052                                   ; 06F7 _ 75, 07
        cmp     qword [rbp-28H], 0                      ; 06F9 _ 48: 83. 7D, D8, 00
        jns     ?_053                                   ; 06FE _ 79, 25
?_052:  mov     eax, dword [rbp-2CH]                    ; 0700 _ 8B. 45, D4
        mov     rcx, qword [rbp-50H]                    ; 0703 _ 48: 8B. 4D, B0
        mov     rdx, qword [rbp-48H]                    ; 0707 _ 48: 8B. 55, B8
        lea     rsi, [rel ?_519]                        ; 070B _ 48: 8D. 35, 00000000(rel)
        mov     edi, eax                                ; 0712 _ 89. C7
        mov     eax, 0                                  ; 0714 _ B8, 00000000
        call    nasm_error                              ; 0719 _ E8, 00000000(PLT r)
        mov     eax, 2                                  ; 071E _ B8, 00000002
        jmp     ?_056                                   ; 0723 _ EB, 77

?_053:  cmp     qword [rbp-28H], 0                      ; 0725 _ 48: 83. 7D, D8, 00
        jnz     ?_054                                   ; 072A _ 75, 08
        mov     rax, qword [rbp-20H]                    ; 072C _ 48: 8B. 45, E0
        mov     qword [rbp-28H], rax                    ; 0730 _ 48: 89. 45, D8
?_054:  mov     rax, qword [rbp-28H]                    ; 0734 _ 48: 8B. 45, D8
        cmp     rax, qword [rbp-18H]                    ; 0738 _ 48: 3B. 45, E8
        jle     ?_055                                   ; 073C _ 7E, 3D
        mov     rax, qword [rbp-18H]                    ; 073E _ 48: 8B. 45, E8
        mov     qword [rbp-28H], rax                    ; 0742 _ 48: 89. 45, D8
        mov     rax, qword 3FFFFFFFFFFFFFFEH            ; 0746 _ 48: B8, 3FFFFFFFFFFFFFFE
        cmp     qword [rbp-18H], rax                    ; 0750 _ 48: 39. 45, E8
        jg      ?_055                                   ; 0754 _ 7F, 25
        mov     eax, dword [rbp-2CH]                    ; 0756 _ 8B. 45, D4
        mov     rdi, qword [rbp-18H]                    ; 0759 _ 48: 8B. 7D, E8
        mov     rcx, qword [rbp-50H]                    ; 075D _ 48: 8B. 4D, B0
        mov     rdx, qword [rbp-48H]                    ; 0761 _ 48: 8B. 55, B8
        lea     rsi, [rel ?_520]                        ; 0765 _ 48: 8D. 35, 00000000(rel)
        mov     r8, rdi                                 ; 076C _ 49: 89. F8
        mov     edi, eax                                ; 076F _ 89. C7
        mov     eax, 0                                  ; 0771 _ B8, 00000000
        call    nasm_error                              ; 0776 _ E8, 00000000(PLT r)
?_055:  mov     eax, dword [rbp-30H]                    ; 077B _ 8B. 45, D0
        cdqe                                            ; 077E _ 48: 98
        lea     rcx, [rax*8]                            ; 0780 _ 48: 8D. 0C C5, 00000000
        lea     rdx, [rel nasm_limit]                   ; 0788 _ 48: 8D. 15, 00000000(rel)
        mov     rax, qword [rbp-28H]                    ; 078F _ 48: 8B. 45, D8
        mov     qword [rcx+rdx], rax                    ; 0793 _ 48: 89. 04 11
        mov     eax, 1                                  ; 0797 _ B8, 00000001
?_056:  mov     rdx, qword [rbp-8H]                     ; 079C _ 48: 8B. 55, F8
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        sub     rdx, qword [fs:abs 28H]                 ; 07A0 _ 64 48: 2B. 14 25, 00000028
        jz      ?_057                                   ; 07A9 _ 74, 05
        call    __stack_chk_fail                        ; 07AB _ E8, 00000000(PLT r)
?_057:  leave                                           ; 07B0 _ C9
        ret                                             ; 07B1 _ C3
; nasm_set_limit End of function

nasm_get_limit:; Function begin
        push    rbp                                     ; 07B2 _ 55
        mov     rbp, rsp                                ; 07B3 _ 48: 89. E5
        sub     rsp, 32                                 ; 07B6 _ 48: 83. EC, 20
        mov     qword [rbp-18H], rdi                    ; 07BA _ 48: 89. 7D, E8
        mov     dword [rbp-1CH], esi                    ; 07BE _ 89. 75, E4
        mov     dword [rbp-4H], 0                       ; 07C1 _ C7. 45, FC, 00000000
        jmp     ?_065                                   ; 07C8 _ E9, 000000A7

?_058:  mov     eax, dword [rbp-4H]                     ; 07CD _ 8B. 45, FC
        cdqe                                            ; 07D0 _ 48: 98
        shl     rax, 5                                  ; 07D2 _ 48: C1. E0, 05
        mov     rdx, rax                                ; 07D6 _ 48: 89. C2
        lea     rax, [rel limit_info]                   ; 07D9 _ 48: 8D. 05, 00000000(rel)
        mov     rdx, qword [rdx+rax]                    ; 07E0 _ 48: 8B. 14 02
        mov     rax, qword [rbp-18H]                    ; 07E4 _ 48: 8B. 45, E8
        mov     rsi, rdx                                ; 07E8 _ 48: 89. D6
        mov     rdi, rax                                ; 07EB _ 48: 89. C7
        call    strcasecmp                              ; 07EE _ E8, 00000000(PLT r)
        test    eax, eax                                ; 07F3 _ 85. C0
        jnz     ?_064                                   ; 07F5 _ 75, 79
        cmp     dword [rbp-1CH], 3                      ; 07F7 _ 83. 7D, E4, 03
        jz      ?_062                                   ; 07FB _ 74, 60
        cmp     dword [rbp-1CH], 3                      ; 07FD _ 83. 7D, E4, 03
        ja      ?_063                                   ; 0801 _ 77, 66
        cmp     dword [rbp-1CH], 2                      ; 0803 _ 83. 7D, E4, 02
        jz      ?_061                                   ; 0807 _ 74, 48
        cmp     dword [rbp-1CH], 2                      ; 0809 _ 83. 7D, E4, 02
        ja      ?_063                                   ; 080D _ 77, 5A
        cmp     dword [rbp-1CH], 0                      ; 080F _ 83. 7D, E4, 00
        jz      ?_059                                   ; 0813 _ 74, 08
        cmp     dword [rbp-1CH], 1                      ; 0815 _ 83. 7D, E4, 01
        jz      ?_060                                   ; 0819 _ 74, 1C
        jmp     ?_063                                   ; 081B _ EB, 4C

?_059:  mov     eax, dword [rbp-4H]                     ; 081D _ 8B. 45, FC
        cdqe                                            ; 0820 _ 48: 98
        lea     rdx, [rax*8]                            ; 0822 _ 48: 8D. 14 C5, 00000000
        lea     rax, [rel nasm_limit]                   ; 082A _ 48: 8D. 05, 00000000(rel)
        mov     rax, qword [rdx+rax]                    ; 0831 _ 48: 8B. 04 02
        jmp     ?_066                                   ; 0835 _ EB, 4C

?_060:  mov     eax, dword [rbp-4H]                     ; 0837 _ 8B. 45, FC
        cdqe                                            ; 083A _ 48: 98
        lea     rdx, [rax*8]                            ; 083C _ 48: 8D. 14 C5, 00000000
        lea     rax, [rel nasm_limit_from_cmdline]      ; 0844 _ 48: 8D. 05, 00000000(rel)
        mov     rax, qword [rdx+rax]                    ; 084B _ 48: 8B. 04 02
        jmp     ?_066                                   ; 084F _ EB, 32

?_061:  mov     eax, dword [rbp-4H]                     ; 0851 _ 8B. 45, FC
        mov     edi, eax                                ; 0854 _ 89. C7
        call    limit_default                           ; 0856 _ E8, FFFFFAD0
        jmp     ?_066                                   ; 085B _ EB, 26

?_062:  mov     eax, dword [rbp-4H]                     ; 085D _ 8B. 45, FC
        mov     edi, eax                                ; 0860 _ 89. C7
        call    limit_max                               ; 0862 _ E8, FFFFFB4A
        jmp     ?_066                                   ; 0867 _ EB, 1A

?_063:  mov     eax, 0                                  ; 0869 _ B8, 00000000
        jmp     ?_066                                   ; 086E _ EB, 13

?_064:  add     dword [rbp-4H], 1                       ; 0870 _ 83. 45, FC, 01
?_065:  cmp     dword [rbp-4H], 8                       ; 0874 _ 83. 7D, FC, 08
        jle     ?_058                                   ; 0878 _ 0F 8E, FFFFFF4F
        mov     eax, 0                                  ; 087E _ B8, 00000000
?_066:  leave                                           ; 0883 _ C9
        ret                                             ; 0884 _ C3
; nasm_get_limit End of function

nasm_limit_name:; Function begin
        push    rbp                                     ; 0885 _ 55
        mov     rbp, rsp                                ; 0886 _ 48: 89. E5
        mov     dword [rbp-4H], edi                     ; 0889 _ 89. 7D, FC
        cmp     dword [rbp-4H], 8                       ; 088C _ 83. 7D, FC, 08
        jbe     ?_067                                   ; 0890 _ 76, 07
        mov     eax, 0                                  ; 0892 _ B8, 00000000
        jmp     ?_068                                   ; 0897 _ EB, 15

?_067:  mov     eax, dword [rbp-4H]                     ; 0899 _ 8B. 45, FC
        shl     rax, 5                                  ; 089C _ 48: C1. E0, 05
        mov     rdx, rax                                ; 08A0 _ 48: 89. C2
        lea     rax, [rel limit_info]                   ; 08A3 _ 48: 8D. 05, 00000000(rel)
        mov     rax, qword [rdx+rax]                    ; 08AA _ 48: 8B. 04 02
?_068:  pop     rbp                                     ; 08AE _ 5D
        ret                                             ; 08AF _ C3
; nasm_limit_name End of function

reset_limits_before_pass:; Local function
        push    rbp                                     ; 08B0 _ 55
        mov     rbp, rsp                                ; 08B1 _ 48: 89. E5
        mov     rax, qword [rel nasm_limit_from_cmdline]; 08B4 _ 48: 8B. 05, 00000000(rel)
        mov     rdx, qword [rel ?_499]                  ; 08BB _ 48: 8B. 15, 00000000(rel)
        mov     qword [rel nasm_limit], rax             ; 08C2 _ 48: 89. 05, 00000000(rel)
        mov     qword [rel nasm_limit+8H], rdx          ; 08C9 _ 48: 89. 15, 00000000(rel)
        mov     rax, qword [rel ?_500]                  ; 08D0 _ 48: 8B. 05, 00000000(rel)
        mov     rdx, qword [rel ?_501]                  ; 08D7 _ 48: 8B. 15, 00000000(rel)
        mov     qword [rel nasm_limit+10H], rax         ; 08DE _ 48: 89. 05, 00000000(rel)
        mov     qword [rel nasm_limit+18H], rdx         ; 08E5 _ 48: 89. 15, 00000000(rel)
        mov     rax, qword [rel ?_502]                  ; 08EC _ 48: 8B. 05, 00000000(rel)
        mov     rdx, qword [rel ?_503]                  ; 08F3 _ 48: 8B. 15, 00000000(rel)
        mov     qword [rel nasm_limit+20H], rax         ; 08FA _ 48: 89. 05, 00000000(rel)
        mov     qword [rel nasm_limit+28H], rdx         ; 0901 _ 48: 89. 15, 00000000(rel)
        mov     rax, qword [rel ?_504]                  ; 0908 _ 48: 8B. 05, 00000000(rel)
        mov     rdx, qword [rel ?_505]                  ; 090F _ 48: 8B. 15, 00000000(rel)
        mov     qword [rel nasm_limit+30H], rax         ; 0916 _ 48: 89. 05, 00000000(rel)
        mov     qword [rel nasm_limit+38H], rdx         ; 091D _ 48: 89. 15, 00000000(rel)
        mov     rax, qword [rel ?_506]                  ; 0924 _ 48: 8B. 05, 00000000(rel)
        mov     qword [rel nasm_limit+40H], rax         ; 092B _ 48: 89. 05, 00000000(rel)
        nop                                             ; 0932 _ 90
        pop     rbp                                     ; 0933 _ 5D
        ret                                             ; 0934 _ C3

switch_segment:; Function begin
        push    rbp                                     ; 0935 _ 55
        mov     rbp, rsp                                ; 0936 _ 48: 89. E5
        sub     rsp, 16                                 ; 0939 _ 48: 83. EC, 10
        mov     dword [rbp-4H], edi                     ; 093D _ 89. 7D, FC
        mov     eax, dword [rbp-4H]                     ; 0940 _ 8B. 45, FC
        mov     dword [rel location+8H], eax            ; 0943 _ 89. 05, 00000000(rel)
        cmp     dword [rbp-4H], -1                      ; 0949 _ 83. 7D, FC, FF
        jnz     ?_069                                   ; 094D _ 75, 17
        mov     rax, qword [rel absolute]               ; 094F _ 48: 8B. 05, 00000000(rel)
        mov     qword [rel location], rax               ; 0956 _ 48: 89. 05, 00000000(rel)
        mov     byte [rel in_absolute], 1               ; 095D _ C6. 05, 00000000(rel), 01
        jmp     ?_070                                   ; 0964 _ EB, 26

?_069:  mov     eax, dword [rbp-4H]                     ; 0966 _ 8B. 45, FC
        movsxd  rdx, eax                                ; 0969 _ 48: 63. D0
        mov     rax, qword [rel offsets]                ; 096C _ 48: 8B. 05, 00000000(rel)
        mov     rsi, rdx                                ; 0973 _ 48: 89. D6
        mov     rdi, rax                                ; 0976 _ 48: 89. C7
        call    raa_read                                ; 0979 _ E8, 00000000(PLT r)
        mov     qword [rel location], rax               ; 097E _ 48: 89. 05, 00000000(rel)
        mov     byte [rel in_absolute], 0               ; 0985 _ C6. 05, 00000000(rel), 00
?_070:  mov     rax, qword [rel location]               ; 098C _ 48: 8B. 05, 00000000(rel)
        leave                                           ; 0993 _ C9
        ret                                             ; 0994 _ C3
; switch_segment End of function

set_curr_offs:; Local function
        push    rbp                                     ; 0995 _ 55
        mov     rbp, rsp                                ; 0996 _ 48: 89. E5
        sub     rsp, 16                                 ; 0999 _ 48: 83. EC, 10
        mov     qword [rbp-8H], rdi                     ; 099D _ 48: 89. 7D, F8
        mov     rax, qword [rbp-8H]                     ; 09A1 _ 48: 8B. 45, F8
        mov     qword [rel location], rax               ; 09A5 _ 48: 89. 05, 00000000(rel)
        movzx   eax, byte [rel in_absolute]             ; 09AC _ 0F B6. 05, 00000000(rel)
        test    al, al                                  ; 09B3 _ 84. C0
        jz      ?_071                                   ; 09B5 _ 74, 0D
        mov     rax, qword [rbp-8H]                     ; 09B7 _ 48: 8B. 45, F8
        mov     qword [rel absolute], rax               ; 09BB _ 48: 89. 05, 00000000(rel)
        jmp     ?_072                                   ; 09C2 _ EB, 26

?_071:  mov     eax, dword [rel location+8H]            ; 09C4 _ 8B. 05, 00000000(rel)
        movsxd  rcx, eax                                ; 09CA _ 48: 63. C8
        mov     rax, qword [rel offsets]                ; 09CD _ 48: 8B. 05, 00000000(rel)
        mov     rdx, qword [rbp-8H]                     ; 09D4 _ 48: 8B. 55, F8
        mov     rsi, rcx                                ; 09D8 _ 48: 89. CE
        mov     rdi, rax                                ; 09DB _ 48: 89. C7
        call    raa_write                               ; 09DE _ E8, 00000000(PLT r)
        mov     qword [rel offsets], rax                ; 09E3 _ 48: 89. 05, 00000000(rel)
?_072:  mov     rax, qword [rbp-8H]                     ; 09EA _ 48: 8B. 45, F8
        leave                                           ; 09EE _ C9
        ret                                             ; 09EF _ C3

increment_offset:; Function begin
        push    rbp                                     ; 09F0 _ 55
        mov     rbp, rsp                                ; 09F1 _ 48: 89. E5
        sub     rsp, 32                                 ; 09F4 _ 48: 83. EC, 20
        mov     qword [rbp-18H], rdi                    ; 09F8 _ 48: 89. 7D, E8
        mov     rdx, qword [rel location]               ; 09FC _ 48: 8B. 15, 00000000(rel)
        mov     rax, qword [rbp-18H]                    ; 0A03 _ 48: 8B. 45, E8
        add     rax, rdx                                ; 0A07 _ 48: 01. D0
        mov     qword [rbp-8H], rax                     ; 0A0A _ 48: 89. 45, F8
        cmp     qword [rbp-18H], 0                      ; 0A0E _ 48: 83. 7D, E8, 00
        sete    al                                      ; 0A13 _ 0F 94. C0
        movzx   eax, al                                 ; 0A16 _ 0F B6. C0
        test    rax, rax                                ; 0A19 _ 48: 85. C0
        jz      ?_073                                   ; 0A1C _ 74, 06
        mov     rax, qword [rbp-8H]                     ; 0A1E _ 48: 8B. 45, F8
        jmp     ?_074                                   ; 0A22 _ EB, 0C

?_073:  mov     rax, qword [rbp-8H]                     ; 0A24 _ 48: 8B. 45, F8
        mov     rdi, rax                                ; 0A28 _ 48: 89. C7
        call    set_curr_offs                           ; 0A2B _ E8, FFFFFF65
?_074:  leave                                           ; 0A30 _ C9
        ret                                             ; 0A31 _ C3
; increment_offset End of function

define_macros:; Local function
        push    rbp                                     ; 0A32 _ 55
        mov     rbp, rsp                                ; 0A33 _ 48: 89. E5
        sub     rsp, 160                                ; 0A36 _ 48: 81. EC, 000000A0
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        mov     rax, qword [fs:abs 28H]                 ; 0A3D _ 64 48: 8B. 04 25, 00000028
        mov     qword [rbp-8H], rax                     ; 0A46 _ 48: 89. 45, F8
        xor     eax, eax                                ; 0A4A _ 31. C0
        lea     rax, [rel official_compile_time]        ; 0A4C _ 48: 8D. 05, 00000000(rel)
        mov     qword [rbp-98H], rax                    ; 0A53 _ 48: 89. 85, FFFFFF68
        mov     rax, qword [rbp-98H]                    ; 0A5A _ 48: 8B. 85, FFFFFF68
        movzx   eax, byte [rax+8H]                      ; 0A61 _ 0F B6. 40, 08
        test    al, al                                  ; 0A65 _ 84. C0
        je      ?_075                                   ; 0A67 _ 0F 84, 000000D4
        mov     rax, qword [rbp-98H]                    ; 0A6D _ 48: 8B. 85, FFFFFF68
        lea     rcx, [rax+18H]                          ; 0A74 _ 48: 8D. 48, 18
        lea     rdx, [rel ?_521]                        ; 0A78 _ 48: 8D. 15, 00000000(rel)
        lea     rax, [rbp-90H]                          ; 0A7F _ 48: 8D. 85, FFFFFF70
        mov     esi, 128                                ; 0A86 _ BE, 00000080
        mov     rdi, rax                                ; 0A8B _ 48: 89. C7
        call    strftime                                ; 0A8E _ E8, 00000000(PLT r)
        lea     rax, [rbp-90H]                          ; 0A93 _ 48: 8D. 85, FFFFFF70
        mov     rdi, rax                                ; 0A9A _ 48: 89. C7
        call    pp_pre_define                           ; 0A9D _ E8, 00000000(PLT r)
        mov     rax, qword [rbp-98H]                    ; 0AA2 _ 48: 8B. 85, FFFFFF68
        lea     rcx, [rax+18H]                          ; 0AA9 _ 48: 8D. 48, 18
        lea     rdx, [rel ?_522]                        ; 0AAD _ 48: 8D. 15, 00000000(rel)
        lea     rax, [rbp-90H]                          ; 0AB4 _ 48: 8D. 85, FFFFFF70
        mov     esi, 128                                ; 0ABB _ BE, 00000080
        mov     rdi, rax                                ; 0AC0 _ 48: 89. C7
        call    strftime                                ; 0AC3 _ E8, 00000000(PLT r)
        lea     rax, [rbp-90H]                          ; 0AC8 _ 48: 8D. 85, FFFFFF70
        mov     rdi, rax                                ; 0ACF _ 48: 89. C7
        call    pp_pre_define                           ; 0AD2 _ E8, 00000000(PLT r)
        mov     rax, qword [rbp-98H]                    ; 0AD7 _ 48: 8B. 85, FFFFFF68
        lea     rcx, [rax+18H]                          ; 0ADE _ 48: 8D. 48, 18
        lea     rdx, [rel ?_523]                        ; 0AE2 _ 48: 8D. 15, 00000000(rel)
        lea     rax, [rbp-90H]                          ; 0AE9 _ 48: 8D. 85, FFFFFF70
        mov     esi, 128                                ; 0AF0 _ BE, 00000080
        mov     rdi, rax                                ; 0AF5 _ 48: 89. C7
        call    strftime                                ; 0AF8 _ E8, 00000000(PLT r)
        lea     rax, [rbp-90H]                          ; 0AFD _ 48: 8D. 85, FFFFFF70
        mov     rdi, rax                                ; 0B04 _ 48: 89. C7
        call    pp_pre_define                           ; 0B07 _ E8, 00000000(PLT r)
        mov     rax, qword [rbp-98H]                    ; 0B0C _ 48: 8B. 85, FFFFFF68
        lea     rcx, [rax+18H]                          ; 0B13 _ 48: 8D. 48, 18
        lea     rdx, [rel ?_524]                        ; 0B17 _ 48: 8D. 15, 00000000(rel)
        lea     rax, [rbp-90H]                          ; 0B1E _ 48: 8D. 85, FFFFFF70
        mov     esi, 128                                ; 0B25 _ BE, 00000080
        mov     rdi, rax                                ; 0B2A _ 48: 89. C7
        call    strftime                                ; 0B2D _ E8, 00000000(PLT r)
        lea     rax, [rbp-90H]                          ; 0B32 _ 48: 8D. 85, FFFFFF70
        mov     rdi, rax                                ; 0B39 _ 48: 89. C7
        call    pp_pre_define                           ; 0B3C _ E8, 00000000(PLT r)
?_075:  mov     rax, qword [rbp-98H]                    ; 0B41 _ 48: 8B. 85, FFFFFF68
        movzx   eax, byte [rax+9H]                      ; 0B48 _ 0F B6. 40, 09
        test    al, al                                  ; 0B4C _ 84. C0
        je      ?_076                                   ; 0B4E _ 0F 84, 000000D4
        mov     rax, qword [rbp-98H]                    ; 0B54 _ 48: 8B. 85, FFFFFF68
        lea     rcx, [rax+50H]                          ; 0B5B _ 48: 8D. 48, 50
        lea     rdx, [rel ?_525]                        ; 0B5F _ 48: 8D. 15, 00000000(rel)
        lea     rax, [rbp-90H]                          ; 0B66 _ 48: 8D. 85, FFFFFF70
        mov     esi, 128                                ; 0B6D _ BE, 00000080
        mov     rdi, rax                                ; 0B72 _ 48: 89. C7
        call    strftime                                ; 0B75 _ E8, 00000000(PLT r)
        lea     rax, [rbp-90H]                          ; 0B7A _ 48: 8D. 85, FFFFFF70
        mov     rdi, rax                                ; 0B81 _ 48: 89. C7
        call    pp_pre_define                           ; 0B84 _ E8, 00000000(PLT r)
        mov     rax, qword [rbp-98H]                    ; 0B89 _ 48: 8B. 85, FFFFFF68
        lea     rcx, [rax+50H]                          ; 0B90 _ 48: 8D. 48, 50
        lea     rdx, [rel ?_526]                        ; 0B94 _ 48: 8D. 15, 00000000(rel)
        lea     rax, [rbp-90H]                          ; 0B9B _ 48: 8D. 85, FFFFFF70
        mov     esi, 128                                ; 0BA2 _ BE, 00000080
        mov     rdi, rax                                ; 0BA7 _ 48: 89. C7
        call    strftime                                ; 0BAA _ E8, 00000000(PLT r)
        lea     rax, [rbp-90H]                          ; 0BAF _ 48: 8D. 85, FFFFFF70
        mov     rdi, rax                                ; 0BB6 _ 48: 89. C7
        call    pp_pre_define                           ; 0BB9 _ E8, 00000000(PLT r)
        mov     rax, qword [rbp-98H]                    ; 0BBE _ 48: 8B. 85, FFFFFF68
        lea     rcx, [rax+50H]                          ; 0BC5 _ 48: 8D. 48, 50
        lea     rdx, [rel ?_527]                        ; 0BC9 _ 48: 8D. 15, 00000000(rel)
        lea     rax, [rbp-90H]                          ; 0BD0 _ 48: 8D. 85, FFFFFF70
        mov     esi, 128                                ; 0BD7 _ BE, 00000080
        mov     rdi, rax                                ; 0BDC _ 48: 89. C7
        call    strftime                                ; 0BDF _ E8, 00000000(PLT r)
        lea     rax, [rbp-90H]                          ; 0BE4 _ 48: 8D. 85, FFFFFF70
        mov     rdi, rax                                ; 0BEB _ 48: 89. C7
        call    pp_pre_define                           ; 0BEE _ E8, 00000000(PLT r)
        mov     rax, qword [rbp-98H]                    ; 0BF3 _ 48: 8B. 85, FFFFFF68
        lea     rcx, [rax+50H]                          ; 0BFA _ 48: 8D. 48, 50
        lea     rdx, [rel ?_528]                        ; 0BFE _ 48: 8D. 15, 00000000(rel)
        lea     rax, [rbp-90H]                          ; 0C05 _ 48: 8D. 85, FFFFFF70
        mov     esi, 128                                ; 0C0C _ BE, 00000080
        mov     rdi, rax                                ; 0C11 _ 48: 89. C7
        call    strftime                                ; 0C14 _ E8, 00000000(PLT r)
        lea     rax, [rbp-90H]                          ; 0C19 _ 48: 8D. 85, FFFFFF70
        mov     rdi, rax                                ; 0C20 _ 48: 89. C7
        call    pp_pre_define                           ; 0C23 _ E8, 00000000(PLT r)
?_076:  mov     rax, qword [rbp-98H]                    ; 0C28 _ 48: 8B. 85, FFFFFF68
        movzx   eax, byte [rax+0AH]                     ; 0C2F _ 0F B6. 40, 0A
        test    al, al                                  ; 0C33 _ 84. C0
        jz      ?_077                                   ; 0C35 _ 74, 40
        mov     rax, qword [rbp-98H]                    ; 0C37 _ 48: 8B. 85, FFFFFF68
        mov     rdx, qword [rax+10H]                    ; 0C3E _ 48: 8B. 50, 10
        lea     rsi, [rel ?_529]                        ; 0C42 _ 48: 8D. 35, 00000000(rel)
        lea     rax, [rbp-90H]                          ; 0C49 _ 48: 8D. 85, FFFFFF70
        mov     rcx, rdx                                ; 0C50 _ 48: 89. D1
        mov     rdx, rsi                                ; 0C53 _ 48: 89. F2
        mov     esi, 128                                ; 0C56 _ BE, 00000080
        mov     rdi, rax                                ; 0C5B _ 48: 89. C7
        mov     eax, 0                                  ; 0C5E _ B8, 00000000
        call    snprintf                                ; 0C63 _ E8, 00000000(PLT r)
        lea     rax, [rbp-90H]                          ; 0C68 _ 48: 8D. 85, FFFFFF70
        mov     rdi, rax                                ; 0C6F _ 48: 89. C7
        call    pp_pre_define                           ; 0C72 _ E8, 00000000(PLT r)
?_077:  mov     rax, qword [rel ofmt_alias]             ; 0C77 _ 48: 8B. 05, 00000000(rel)
        test    rax, rax                                ; 0C7E _ 48: 85. C0
        jz      ?_078                                   ; 0C81 _ 74, 0C
        mov     rax, qword [rel ofmt_alias]             ; 0C83 _ 48: 8B. 05, 00000000(rel)
        mov     rax, qword [rax]                        ; 0C8A _ 48: 8B. 00
        jmp     ?_079                                   ; 0C8D _ EB, 0B

?_078:  mov     rax, qword [rel ofmt]                   ; 0C8F _ 48: 8B. 05, 00000000(rel)
        mov     rax, qword [rax+8H]                     ; 0C96 _ 48: 8B. 40, 08
?_079:  lea     rdx, [rel ?_530]                        ; 0C9A _ 48: 8D. 15, 00000000(rel)
        lea     rdi, [rbp-90H]                          ; 0CA1 _ 48: 8D. BD, FFFFFF70
        mov     rcx, rax                                ; 0CA8 _ 48: 89. C1
        mov     esi, 128                                ; 0CAB _ BE, 00000080
        mov     eax, 0                                  ; 0CB0 _ B8, 00000000
        call    snprintf                                ; 0CB5 _ E8, 00000000(PLT r)
        lea     rax, [rbp-90H]                          ; 0CBA _ 48: 8D. 85, FFFFFF70
        mov     rdi, rax                                ; 0CC1 _ 48: 89. C7
        call    pp_pre_define                           ; 0CC4 _ E8, 00000000(PLT r)
        mov     rdx, qword [rel dfmt]                   ; 0CC9 _ 48: 8B. 15, 00000000(rel)
        lea     rax, [rel null_debug_form]              ; 0CD0 _ 48: 8D. 05, 00000000(rel)
        cmp     rdx, rax                                ; 0CD7 _ 48: 39. C2
        jz      ?_080                                   ; 0CDA _ 74, 40
        mov     rax, qword [rel dfmt]                   ; 0CDC _ 48: 8B. 05, 00000000(rel)
        mov     rdx, qword [rax+8H]                     ; 0CE3 _ 48: 8B. 50, 08
        lea     rsi, [rel ?_531]                        ; 0CE7 _ 48: 8D. 35, 00000000(rel)
        lea     rax, [rbp-90H]                          ; 0CEE _ 48: 8D. 85, FFFFFF70
        mov     rcx, rdx                                ; 0CF5 _ 48: 89. D1
        mov     rdx, rsi                                ; 0CF8 _ 48: 89. F2
        mov     esi, 128                                ; 0CFB _ BE, 00000080
        mov     rdi, rax                                ; 0D00 _ 48: 89. C7
        mov     eax, 0                                  ; 0D03 _ B8, 00000000
        call    snprintf                                ; 0D08 _ E8, 00000000(PLT r)
        lea     rax, [rbp-90H]                          ; 0D0D _ 48: 8D. 85, FFFFFF70
        mov     rdi, rax                                ; 0D14 _ 48: 89. C7
        call    pp_pre_define                           ; 0D17 _ E8, 00000000(PLT r)
?_080:  nop                                             ; 0D1C _ 90
        mov     rax, qword [rbp-8H]                     ; 0D1D _ 48: 8B. 45, F8
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        sub     rax, qword [fs:abs 28H]                 ; 0D21 _ 64 48: 2B. 04 25, 00000028
        jz      ?_081                                   ; 0D2A _ 74, 05
        call    __stack_chk_fail                        ; 0D2C _ E8, 00000000(PLT r)
?_081:  leave                                           ; 0D31 _ C9
        ret                                             ; 0D32 _ C3

preproc_init:; Local function
        push    rbp                                     ; 0D33 _ 55
        mov     rbp, rsp                                ; 0D34 _ 48: 89. E5
        sub     rsp, 16                                 ; 0D37 _ 48: 83. EC, 10
        mov     qword [rbp-8H], rdi                     ; 0D3B _ 48: 89. 7D, F8
        mov     eax, dword [rel ppopt]                  ; 0D3F _ 8B. 05, 00000000(rel)
        mov     edi, eax                                ; 0D45 _ 89. C7
        call    pp_init                                 ; 0D47 _ E8, 00000000(PLT r)
        call    define_macros                           ; 0D4C _ E8, FFFFFCE1
        mov     rax, qword [rbp-8H]                     ; 0D51 _ 48: 8B. 45, F8
        mov     rdi, rax                                ; 0D55 _ 48: 89. C7
        call    pp_include_path                         ; 0D58 _ E8, 00000000(PLT r)
        nop                                             ; 0D5D _ 90
        leave                                           ; 0D5E _ C9
        ret                                             ; 0D5F _ C3

emit_dependencies:; Local function
        push    rbp                                     ; 0D60 _ 55
        mov     rbp, rsp                                ; 0D61 _ 48: 89. E5
        sub     rsp, 96                                 ; 0D64 _ 48: 83. EC, 60
        mov     qword [rbp-58H], rdi                    ; 0D68 _ 48: 89. 7D, A8
        mov     rdx, qword [rel quote_for_make]         ; 0D6C _ 48: 8B. 15, 00000000(rel)
        lea     rax, [rel quote_for_wmake]              ; 0D73 _ 48: 8D. 05, 0000140D(rel)
        cmp     rdx, rax                                ; 0D7A _ 48: 39. C2
        sete    al                                      ; 0D7D _ 0F 94. C0
        mov     byte [rbp-41H], al                      ; 0D80 _ 88. 45, BF
        mov     edi, 4                                  ; 0D83 _ BF, 00000004
        call    get_filename                            ; 0D88 _ E8, FFFFF538
        mov     qword [rbp-18H], rax                    ; 0D8D _ 48: 89. 45, E8
        mov     rax, qword [rbp-58H]                    ; 0D91 _ 48: 8B. 45, A8
        test    rax, rax                                ; 0D95 _ 48: 85. C0
        je      ?_094                                   ; 0D98 _ 0F 84, 00000239
        cmp     byte [rbp-41H], 0                       ; 0D9E _ 80. 7D, BF, 00
        jz      ?_082                                   ; 0DA2 _ 74, 0D
        lea     rax, [rel ?_532]                        ; 0DA4 _ 48: 8D. 05, 00000000(rel)
        mov     qword [rbp-30H], rax                    ; 0DAB _ 48: 89. 45, D0
        jmp     ?_083                                   ; 0DAF _ EB, 0B

?_082:  lea     rax, [rel ?_533]                        ; 0DB1 _ 48: 8D. 05, 00000000(rel)
        mov     qword [rbp-30H], rax                    ; 0DB8 _ 48: 89. 45, D0
?_083:  cmp     byte [rbp-41H], 0                       ; 0DBC _ 80. 7D, BF, 00
        jz      ?_084                                   ; 0DC0 _ 74, 0D
        lea     rax, [rel ?_534]                        ; 0DC2 _ 48: 8D. 05, 00000000(rel)
        mov     qword [rbp-28H], rax                    ; 0DC9 _ 48: 89. 45, D8
        jmp     ?_085                                   ; 0DCD _ EB, 0B

?_084:  lea     rax, [rel ?_512]                        ; 0DCF _ 48: 8D. 05, 00000000(rel)
        mov     qword [rbp-28H], rax                    ; 0DD6 _ 48: 89. 45, D8
?_085:  cmp     qword [rbp-18H], 0                      ; 0DDA _ 48: 83. 7D, E8, 00
        jz      ?_086                                   ; 0DDF _ 74, 56
        lea     rdx, [rel ?_535]                        ; 0DE1 _ 48: 8D. 15, 00000000(rel)
        mov     rax, qword [rbp-18H]                    ; 0DE8 _ 48: 8B. 45, E8
        mov     rsi, rdx                                ; 0DEC _ 48: 89. D6
        mov     rdi, rax                                ; 0DEF _ 48: 89. C7
        call    strcmp                                  ; 0DF2 _ E8, 00000000(PLT r)
        test    eax, eax                                ; 0DF7 _ 85. C0
        jz      ?_086                                   ; 0DF9 _ 74, 3C
        mov     rax, qword [rbp-18H]                    ; 0DFB _ 48: 8B. 45, E8
        mov     esi, 1                                  ; 0DFF _ BE, 00000001
        mov     rdi, rax                                ; 0E04 _ 48: 89. C7
        call    nasm_open_write                         ; 0E07 _ E8, 00000000(PLT r)
        mov     qword [rbp-38H], rax                    ; 0E0C _ 48: 89. 45, C8
        cmp     qword [rbp-38H], 0                      ; 0E10 _ 48: 83. 7D, C8, 00
        jnz     ?_087                                   ; 0E15 _ 75, 2B
        mov     rax, qword [rbp-18H]                    ; 0E17 _ 48: 8B. 45, E8
        lea     rdx, [rel ?_536]                        ; 0E1B _ 48: 8D. 15, 00000000(rel)
        mov     rsi, rax                                ; 0E22 _ 48: 89. C6
        mov     rdi, rdx                                ; 0E25 _ 48: 89. D7
        mov     eax, 0                                  ; 0E28 _ B8, 00000000
        call    nasm_nonfatal                           ; 0E2D _ E8, 00000000(PLT r)
        jmp     ?_095                                   ; 0E32 _ E9, 000001A1

?_086:  mov     rax, qword [rel stdout]                 ; 0E37 _ 48: 8B. 05, 00000000(rel)
        mov     qword [rbp-38H], rax                    ; 0E3E _ 48: 89. 45, C8
?_087:  mov     edi, 8                                  ; 0E42 _ BF, 00000008
        call    get_filename                            ; 0E47 _ E8, FFFFF479
        mov     rdx, rax                                ; 0E4C _ 48: 89. C2
        lea     rcx, [rel ?_537]                        ; 0E4F _ 48: 8D. 0D, 00000000(rel)
        mov     rax, qword [rbp-38H]                    ; 0E56 _ 48: 8B. 45, C8
        mov     rsi, rcx                                ; 0E5A _ 48: 89. CE
        mov     rdi, rax                                ; 0E5D _ 48: 89. C7
        mov     eax, 0                                  ; 0E60 _ B8, 00000000
        call    fprintf                                 ; 0E65 _ E8, 00000000(PLT r)
        mov     dword [rbp-40H], eax                    ; 0E6A _ 89. 45, C0
        mov     rax, qword [rbp-58H]                    ; 0E6D _ 48: 8B. 45, A8
        mov     rdi, rax                                ; 0E71 _ 48: 89. C7
        call    strlist_head                            ; 0E74 _ E8, FFFFF27D
        mov     qword [rbp-20H], rax                    ; 0E79 _ 48: 89. 45, E0
        jmp     ?_090                                   ; 0E7D _ E9, 00000093

?_088:  mov     rax, qword [rel quote_for_make]         ; 0E82 _ 48: 8B. 05, 00000000(rel)
        mov     rdx, qword [rbp-20H]                    ; 0E89 _ 48: 8B. 55, E0
        add     rdx, 32                                 ; 0E8D _ 48: 83. C2, 20
        mov     rdi, rdx                                ; 0E91 _ 48: 89. D7
        call    rax                                     ; 0E94 _ FF. D0
        mov     qword [rbp-8H], rax                     ; 0E96 _ 48: 89. 45, F8
        mov     rax, qword [rbp-8H]                     ; 0E9A _ 48: 8B. 45, F8
        mov     rdi, rax                                ; 0E9E _ 48: 89. C7
        call    strlen                                  ; 0EA1 _ E8, 00000000(PLT r)
        mov     dword [rbp-3CH], eax                    ; 0EA6 _ 89. 45, C4
        mov     edx, dword [rbp-40H]                    ; 0EA9 _ 8B. 55, C0
        mov     eax, dword [rbp-3CH]                    ; 0EAC _ 8B. 45, C4
        add     eax, edx                                ; 0EAF _ 01. D0
        cmp     eax, 62                                 ; 0EB1 _ 83. F8, 3E
        jle     ?_089                                   ; 0EB4 _ 7E, 20
        cmp     dword [rbp-40H], 1                      ; 0EB6 _ 83. 7D, C0, 01
        jle     ?_089                                   ; 0EBA _ 7E, 1A
        mov     rdx, qword [rbp-38H]                    ; 0EBC _ 48: 8B. 55, C8
        mov     rax, qword [rbp-30H]                    ; 0EC0 _ 48: 8B. 45, D0
        mov     rsi, rdx                                ; 0EC4 _ 48: 89. D6
        mov     rdi, rax                                ; 0EC7 _ 48: 89. C7
        call    fputs                                   ; 0ECA _ E8, 00000000(PLT r)
        mov     dword [rbp-40H], 1                      ; 0ECF _ C7. 45, C0, 00000001
?_089:  mov     rdx, qword [rbp-8H]                     ; 0ED6 _ 48: 8B. 55, F8
        lea     rcx, [rel ?_538]                        ; 0EDA _ 48: 8D. 0D, 00000000(rel)
        mov     rax, qword [rbp-38H]                    ; 0EE1 _ 48: 8B. 45, C8
        mov     rsi, rcx                                ; 0EE5 _ 48: 89. CE
        mov     rdi, rax                                ; 0EE8 _ 48: 89. C7
        mov     eax, 0                                  ; 0EEB _ B8, 00000000
        call    fprintf                                 ; 0EF0 _ E8, 00000000(PLT r)
        mov     eax, dword [rbp-3CH]                    ; 0EF5 _ 8B. 45, C4
        add     eax, 1                                  ; 0EF8 _ 83. C0, 01
        add     dword [rbp-40H], eax                    ; 0EFB _ 01. 45, C0
        mov     rax, qword [rbp-8H]                     ; 0EFE _ 48: 8B. 45, F8
        mov     rdi, rax                                ; 0F02 _ 48: 89. C7
        call    nasm_free                               ; 0F05 _ E8, 00000000(PLT r)
        mov     rax, qword [rbp-20H]                    ; 0F0A _ 48: 8B. 45, E0
        mov     rax, qword [rax]                        ; 0F0E _ 48: 8B. 00
        mov     qword [rbp-20H], rax                    ; 0F11 _ 48: 89. 45, E0
?_090:  cmp     qword [rbp-20H], 0                      ; 0F15 _ 48: 83. 7D, E0, 00
        jne     ?_088                                   ; 0F1A _ 0F 85, FFFFFF62
        mov     rax, qword [rbp-38H]                    ; 0F20 _ 48: 8B. 45, C8
        lea     rdi, [rel ?_539]                        ; 0F24 _ 48: 8D. 3D, 00000000(rel)
        mov     rcx, rax                                ; 0F2B _ 48: 89. C1
        mov     edx, 2                                  ; 0F2E _ BA, 00000002
        mov     esi, 1                                  ; 0F33 _ BE, 00000001
        call    fwrite                                  ; 0F38 _ E8, 00000000(PLT r)
        mov     rax, qword [rbp-58H]                    ; 0F3D _ 48: 8B. 45, A8
        mov     rdi, rax                                ; 0F41 _ 48: 89. C7
        call    strlist_head                            ; 0F44 _ E8, FFFFF1AD
        mov     qword [rbp-20H], rax                    ; 0F49 _ 48: 89. 45, E0
        jmp     ?_093                                   ; 0F4D _ EB, 5A

?_091:  movzx   eax, byte [rel depend_emit_phony]       ; 0F4F _ 0F B6. 05, 00000000(rel)
        test    al, al                                  ; 0F56 _ 84. C0
        jz      ?_092                                   ; 0F58 _ 74, 44
        mov     rax, qword [rel quote_for_make]         ; 0F5A _ 48: 8B. 05, 00000000(rel)
        mov     rdx, qword [rbp-20H]                    ; 0F61 _ 48: 8B. 55, E0
        add     rdx, 32                                 ; 0F65 _ 48: 83. C2, 20
        mov     rdi, rdx                                ; 0F69 _ 48: 89. D7
        call    rax                                     ; 0F6C _ FF. D0
        mov     qword [rbp-10H], rax                    ; 0F6E _ 48: 89. 45, F0
        mov     rcx, qword [rbp-28H]                    ; 0F72 _ 48: 8B. 4D, D8
        mov     rdx, qword [rbp-10H]                    ; 0F76 _ 48: 8B. 55, F0
        lea     rsi, [rel ?_540]                        ; 0F7A _ 48: 8D. 35, 00000000(rel)
        mov     rax, qword [rbp-38H]                    ; 0F81 _ 48: 8B. 45, C8
        mov     rdi, rax                                ; 0F85 _ 48: 89. C7
        mov     eax, 0                                  ; 0F88 _ B8, 00000000
        call    fprintf                                 ; 0F8D _ E8, 00000000(PLT r)
        mov     rax, qword [rbp-10H]                    ; 0F92 _ 48: 8B. 45, F0
        mov     rdi, rax                                ; 0F96 _ 48: 89. C7
        call    nasm_free                               ; 0F99 _ E8, 00000000(PLT r)
?_092:  mov     rax, qword [rbp-20H]                    ; 0F9E _ 48: 8B. 45, E0
        mov     rax, qword [rax]                        ; 0FA2 _ 48: 8B. 00
        mov     qword [rbp-20H], rax                    ; 0FA5 _ 48: 89. 45, E0
?_093:  cmp     qword [rbp-20H], 0                      ; 0FA9 _ 48: 83. 7D, E0, 00
        jnz     ?_091                                   ; 0FAE _ 75, 9F
        lea     rax, [rbp-58H]                          ; 0FB0 _ 48: 8D. 45, A8
        mov     rdi, rax                                ; 0FB4 _ 48: 89. C7
        call    strlist_free                            ; 0FB7 _ E8, 00000000(PLT r)
        mov     rax, qword [rel stdout]                 ; 0FBC _ 48: 8B. 05, 00000000(rel)
        cmp     qword [rbp-38H], rax                    ; 0FC3 _ 48: 39. 45, C8
        jz      ?_095                                   ; 0FC7 _ 74, 0F
        mov     rax, qword [rbp-38H]                    ; 0FC9 _ 48: 8B. 45, C8
        mov     rdi, rax                                ; 0FCD _ 48: 89. C7
        call    fclose                                  ; 0FD0 _ E8, 00000000(PLT r)
        jmp     ?_095                                   ; 0FD5 _ EB, 01

?_094:  nop                                             ; 0FD7 _ 90
?_095:  leave                                           ; 0FD8 _ C9
        ret                                             ; 0FD9 _ C3

make_posix_time:; Local function
        push    rbp                                     ; 0FDA _ 55
        mov     rbp, rsp                                ; 0FDB _ 48: 89. E5
        mov     qword [rbp-18H], rdi                    ; 0FDE _ 48: 89. 7D, E8
        mov     rax, qword [rbp-18H]                    ; 0FE2 _ 48: 8B. 45, E8
        mov     eax, dword [rax+14H]                    ; 0FE6 _ 8B. 40, 14
        cdqe                                            ; 0FE9 _ 48: 98
        mov     qword [rbp-10H], rax                    ; 0FEB _ 48: 89. 45, F0
        mov     rax, qword [rbp-10H]                    ; 0FEF _ 48: 8B. 45, F0
        sub     rax, 70                                 ; 0FF3 _ 48: 83. E8, 46
        imul    rdx, rax, 365                           ; 0FF7 _ 48: 69. D0, 0000016D
        mov     rax, qword [rbp-10H]                    ; 0FFE _ 48: 8B. 45, F0
        sub     rax, 69                                 ; 1002 _ 48: 83. E8, 45
        lea     rcx, [rax+3H]                           ; 1006 _ 48: 8D. 48, 03
        test    rax, rax                                ; 100A _ 48: 85. C0
        cmovs   rax, rcx                                ; 100D _ 48: 0F 48. C1
        sar     rax, 2                                  ; 1011 _ 48: C1. F8, 02
        lea     rsi, [rdx+rax]                          ; 1015 _ 48: 8D. 34 02
        mov     rax, qword [rbp-10H]                    ; 1019 _ 48: 8B. 45, F0
        lea     rcx, [rax-1H]                           ; 101D _ 48: 8D. 48, FF
        mov     rdx, qword 0A3D70A3D70A3D70BH           ; 1021 _ 48: BA, A3D70A3D70A3D70B
        mov     rax, rcx                                ; 102B _ 48: 89. C8
        imul    rdx                                     ; 102E _ 48: F7. EA
        lea     rax, [rdx+rcx]                          ; 1031 _ 48: 8D. 04 0A
        sar     rax, 6                                  ; 1035 _ 48: C1. F8, 06
        sar     rcx, 63                                 ; 1039 _ 48: C1. F9, 3F
        mov     rdx, rcx                                ; 103D _ 48: 89. CA
        sub     rdx, rax                                ; 1040 _ 48: 29. C2
        add     rsi, rdx                                ; 1043 _ 48: 01. D6
        mov     rax, qword [rbp-10H]                    ; 1046 _ 48: 8B. 45, F0
        lea     rcx, [rax+12BH]                         ; 104A _ 48: 8D. 88, 0000012B
        mov     rdx, qword 0A3D70A3D70A3D70BH           ; 1051 _ 48: BA, A3D70A3D70A3D70B
        mov     rax, rcx                                ; 105B _ 48: 89. C8
        imul    rdx                                     ; 105E _ 48: F7. EA
        lea     rax, [rdx+rcx]                          ; 1061 _ 48: 8D. 04 0A
        sar     rax, 8                                  ; 1065 _ 48: C1. F8, 08
        mov     rdx, rax                                ; 1069 _ 48: 89. C2
        mov     rax, rcx                                ; 106C _ 48: 89. C8
        sar     rax, 63                                 ; 106F _ 48: C1. F8, 3F
        sub     rdx, rax                                ; 1073 _ 48: 29. C2
        lea     rax, [rsi+rdx]                          ; 1076 _ 48: 8D. 04 16
        mov     qword [rbp-8H], rax                     ; 107A _ 48: 89. 45, F8
        mov     rax, qword [rbp-18H]                    ; 107E _ 48: 8B. 45, E8
        mov     eax, dword [rax+1CH]                    ; 1082 _ 8B. 40, 1C
        cdqe                                            ; 1085 _ 48: 98
        add     qword [rbp-8H], rax                     ; 1087 _ 48: 01. 45, F8
        mov     rdx, qword [rbp-8H]                     ; 108B _ 48: 8B. 55, F8
        mov     rax, rdx                                ; 108F _ 48: 89. D0
        add     rax, rax                                ; 1092 _ 48: 01. C0
        add     rax, rdx                                ; 1095 _ 48: 01. D0
        shl     rax, 3                                  ; 1098 _ 48: C1. E0, 03
        mov     qword [rbp-8H], rax                     ; 109C _ 48: 89. 45, F8
        mov     rax, qword [rbp-18H]                    ; 10A0 _ 48: 8B. 45, E8
        mov     eax, dword [rax+8H]                     ; 10A4 _ 8B. 40, 08
        cdqe                                            ; 10A7 _ 48: 98
        add     qword [rbp-8H], rax                     ; 10A9 _ 48: 01. 45, F8
        mov     rax, qword [rbp-8H]                     ; 10AD _ 48: 8B. 45, F8
        imul    rax, rax, 60                            ; 10B1 _ 48: 6B. C0, 3C
        mov     qword [rbp-8H], rax                     ; 10B5 _ 48: 89. 45, F8
        mov     rax, qword [rbp-18H]                    ; 10B9 _ 48: 8B. 45, E8
        mov     eax, dword [rax+4H]                     ; 10BD _ 8B. 40, 04
        cdqe                                            ; 10C0 _ 48: 98
        add     qword [rbp-8H], rax                     ; 10C2 _ 48: 01. 45, F8
        mov     rax, qword [rbp-8H]                     ; 10C6 _ 48: 8B. 45, F8
        imul    rax, rax, 60                            ; 10CA _ 48: 6B. C0, 3C
        mov     qword [rbp-8H], rax                     ; 10CE _ 48: 89. 45, F8
        mov     rax, qword [rbp-18H]                    ; 10D2 _ 48: 8B. 45, E8
        mov     eax, dword [rax]                        ; 10D6 _ 8B. 00
        cdqe                                            ; 10D8 _ 48: 98
        add     qword [rbp-8H], rax                     ; 10DA _ 48: 01. 45, F8
        mov     rax, qword [rbp-8H]                     ; 10DE _ 48: 8B. 45, F8
        pop     rbp                                     ; 10E2 _ 5D
        ret                                             ; 10E3 _ C3

nasm_quote_filename:; Local function
        push    rbp                                     ; 10E4 _ 55
        mov     rbp, rsp                                ; 10E5 _ 48: 89. E5
        sub     rsp, 48                                 ; 10E8 _ 48: 83. EC, 30
        mov     qword [rbp-28H], rdi                    ; 10EC _ 48: 89. 7D, D8
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        mov     rax, qword [fs:abs 28H]                 ; 10F0 _ 64 48: 8B. 04 25, 00000028
        mov     qword [rbp-8H], rax                     ; 10F9 _ 48: 89. 45, F8
        xor     eax, eax                                ; 10FD _ 31. C0
        mov     rax, qword [rbp-28H]                    ; 10FF _ 48: 8B. 45, D8
        mov     qword [rbp-10H], rax                    ; 1103 _ 48: 89. 45, F0
        cmp     qword [rbp-10H], 0                      ; 1107 _ 48: 83. 7D, F0, 00
        jz      ?_096                                   ; 110C _ 74, 0B
        mov     rax, qword [rbp-10H]                    ; 110E _ 48: 8B. 45, F0
        movzx   eax, byte [rax]                         ; 1112 _ 0F B6. 00
        test    al, al                                  ; 1115 _ 84. C0
        jnz     ?_097                                   ; 1117 _ 75, 14
?_096:  lea     rax, [rel ?_541]                        ; 1119 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 1120 _ 48: 89. C7
        call    nasm_strdup                             ; 1123 _ E8, 00000000(PLT r)
        jmp     ?_106                                   ; 1128 _ E9, 000000BB

?_097:  mov     rax, qword [rbp-10H]                    ; 112D _ 48: 8B. 45, F0
        movzx   eax, byte [rax]                         ; 1131 _ 0F B6. 00
        cmp     al, 32                                  ; 1134 _ 3C, 20
        jbe     ?_102                                   ; 1136 _ 0F 86, 00000082
        mov     rax, qword [rbp-10H]                    ; 113C _ 48: 8B. 45, F0
        movzx   eax, byte [rax]                         ; 1140 _ 0F B6. 00
        movsx   eax, al                                 ; 1143 _ 0F BE. C0
        mov     edi, eax                                ; 1146 _ 89. C7
        call    nasm_isquote                            ; 1148 _ E8, FFFFEF81
        test    al, al                                  ; 114D _ 84. C0
        jnz     ?_102                                   ; 114F _ 75, 6D
        mov     byte [rbp-19H], 32                      ; 1151 _ C6. 45, E7, 20
        jmp     ?_101                                   ; 1155 _ EB, 26

?_098:  mov     rax, qword [rbp-10H]                    ; 1157 _ 48: 8B. 45, F0
        movzx   eax, byte [rax]                         ; 115B _ 0F B6. 00
        cmp     al, byte [rbp-19H]                      ; 115E _ 3A. 45, E7
        jc      ?_103                                   ; 1161 _ 72, 5E
        mov     rax, qword [rbp-10H]                    ; 1163 _ 48: 8B. 45, F0
        movzx   eax, byte [rax]                         ; 1167 _ 0F B6. 00
        cmp     al, 32                                  ; 116A _ 3C, 20
        jnz     ?_099                                   ; 116C _ 75, 06
        mov     byte [rbp-19H], 33                      ; 116E _ C6. 45, E7, 21
        jmp     ?_100                                   ; 1172 _ EB, 04

?_099:  mov     byte [rbp-19H], 32                      ; 1174 _ C6. 45, E7, 20
?_100:  add     qword [rbp-10H], 1                      ; 1178 _ 48: 83. 45, F0, 01
?_101:  mov     rax, qword [rbp-10H]                    ; 117D _ 48: 8B. 45, F0
        movzx   eax, byte [rax]                         ; 1181 _ 0F B6. 00
        test    al, al                                  ; 1184 _ 84. C0
        jnz     ?_098                                   ; 1186 _ 75, CF
        mov     rax, qword [rbp-10H]                    ; 1188 _ 48: 8B. 45, F0
        sub     rax, 1                                  ; 118C _ 48: 83. E8, 01
        movzx   eax, byte [rax]                         ; 1190 _ 0F B6. 00
        cmp     al, 32                                  ; 1193 _ 3C, 20
        jbe     ?_104                                   ; 1195 _ 76, 2D
        mov     rax, qword [rbp-10H]                    ; 1197 _ 48: 8B. 45, F0
        sub     rax, 1                                  ; 119B _ 48: 83. E8, 01
        movzx   eax, byte [rax]                         ; 119F _ 0F B6. 00
        movsx   eax, al                                 ; 11A2 _ 0F BE. C0
        mov     edi, eax                                ; 11A5 _ 89. C7
        call    nasm_isquote                            ; 11A7 _ E8, FFFFEF22
        test    al, al                                  ; 11AC _ 84. C0
        jnz     ?_104                                   ; 11AE _ 75, 14
        mov     rax, qword [rbp-28H]                    ; 11B0 _ 48: 8B. 45, D8
        mov     rdi, rax                                ; 11B4 _ 48: 89. C7
        call    nasm_strdup                             ; 11B7 _ E8, 00000000(PLT r)
        jmp     ?_106                                   ; 11BC _ EB, 2A

?_102:  nop                                             ; 11BE _ 90
        jmp     ?_105                                   ; 11BF _ EB, 04

?_103:  nop                                             ; 11C1 _ 90
        jmp     ?_105                                   ; 11C2 _ EB, 01

?_104:  nop                                             ; 11C4 _ 90
?_105:  mov     rax, qword [rbp-28H]                    ; 11C5 _ 48: 8B. 45, D8
        mov     rdi, rax                                ; 11C9 _ 48: 89. C7
        call    strlen                                  ; 11CC _ E8, 00000000(PLT r)
        mov     qword [rbp-18H], rax                    ; 11D1 _ 48: 89. 45, E8
        lea     rdx, [rbp-18H]                          ; 11D5 _ 48: 8D. 55, E8
        mov     rax, qword [rbp-28H]                    ; 11D9 _ 48: 8B. 45, D8
        mov     rsi, rdx                                ; 11DD _ 48: 89. D6
        mov     rdi, rax                                ; 11E0 _ 48: 89. C7
        call    nasm_quote                              ; 11E3 _ E8, 00000000(PLT r)
?_106:  mov     rdx, qword [rbp-8H]                     ; 11E8 _ 48: 8B. 55, F8
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        sub     rdx, qword [fs:abs 28H]                 ; 11EC _ 64 48: 2B. 14 25, 00000028
        jz      ?_107                                   ; 11F5 _ 74, 05
        call    __stack_chk_fail                        ; 11F7 _ E8, 00000000(PLT r)
?_107:  leave                                           ; 11FC _ C9
        ret                                             ; 11FD _ C3

timestamp:; Local function
        push    rbp                                     ; 11FE _ 55
        mov     rbp, rsp                                ; 11FF _ 48: 89. E5
        push    rbx                                     ; 1202 _ 53
        sub     rsp, 40                                 ; 1203 _ 48: 83. EC, 28
        lea     rax, [rel official_compile_time]        ; 1207 _ 48: 8D. 05, 00000000(rel)
        mov     qword [rbp-20H], rax                    ; 120E _ 48: 89. 45, E0
        mov     rax, qword [rbp-20H]                    ; 1212 _ 48: 8B. 45, E0
        mov     rdi, rax                                ; 1216 _ 48: 89. C7
        call    time                                    ; 1219 _ E8, 00000000(PLT r)
        mov     qword [rbp-28H], 0                      ; 121E _ 48: C7. 45, D8, 00000000
        mov     rax, qword [rbp-20H]                    ; 1226 _ 48: 8B. 45, E0
        mov     rdi, rax                                ; 122A _ 48: 89. C7
        call    localtime                               ; 122D _ E8, 00000000(PLT r)
        mov     qword [rbp-18H], rax                    ; 1232 _ 48: 89. 45, E8
        cmp     qword [rbp-18H], 0                      ; 1236 _ 48: 83. 7D, E8, 00
        jz      ?_108                                   ; 123B _ 74, 53
        mov     rax, qword [rbp-20H]                    ; 123D _ 48: 8B. 45, E0
        mov     rdx, qword [rbp-18H]                    ; 1241 _ 48: 8B. 55, E8
        mov     rcx, qword [rdx]                        ; 1245 _ 48: 8B. 0A
        mov     rbx, qword [rdx+8H]                     ; 1248 _ 48: 8B. 5A, 08
        mov     qword [rax+18H], rcx                    ; 124C _ 48: 89. 48, 18
        mov     qword [rax+20H], rbx                    ; 1250 _ 48: 89. 58, 20
        mov     rcx, qword [rdx+10H]                    ; 1254 _ 48: 8B. 4A, 10
        mov     rbx, qword [rdx+18H]                    ; 1258 _ 48: 8B. 5A, 18
        mov     qword [rax+28H], rcx                    ; 125C _ 48: 89. 48, 28
        mov     qword [rax+30H], rbx                    ; 1260 _ 48: 89. 58, 30
        mov     rcx, qword [rdx+20H]                    ; 1264 _ 48: 8B. 4A, 20
        mov     rbx, qword [rdx+28H]                    ; 1268 _ 48: 8B. 5A, 28
        mov     qword [rax+38H], rcx                    ; 126C _ 48: 89. 48, 38
        mov     qword [rax+40H], rbx                    ; 1270 _ 48: 89. 58, 40
        mov     rdx, qword [rdx+30H]                    ; 1274 _ 48: 8B. 52, 30
        mov     qword [rax+48H], rdx                    ; 1278 _ 48: 89. 50, 48
        mov     rax, qword [rbp-20H]                    ; 127C _ 48: 8B. 45, E0
        add     rax, 24                                 ; 1280 _ 48: 83. C0, 18
        mov     qword [rbp-28H], rax                    ; 1284 _ 48: 89. 45, D8
        mov     rax, qword [rbp-20H]                    ; 1288 _ 48: 8B. 45, E0
        mov     byte [rax+8H], 1                        ; 128C _ C6. 40, 08, 01
?_108:  mov     rax, qword [rbp-20H]                    ; 1290 _ 48: 8B. 45, E0
        mov     rdi, rax                                ; 1294 _ 48: 89. C7
        call    gmtime                                  ; 1297 _ E8, 00000000(PLT r)
        mov     qword [rbp-18H], rax                    ; 129C _ 48: 89. 45, E8
        cmp     qword [rbp-18H], 0                      ; 12A0 _ 48: 83. 7D, E8, 00
        je      ?_109                                   ; 12A5 _ 0F 84, 000000AE
        mov     rax, qword [rbp-20H]                    ; 12AB _ 48: 8B. 45, E0
        mov     rdx, qword [rbp-18H]                    ; 12AF _ 48: 8B. 55, E8
        mov     rcx, qword [rdx]                        ; 12B3 _ 48: 8B. 0A
        mov     rbx, qword [rdx+8H]                     ; 12B6 _ 48: 8B. 5A, 08
        mov     qword [rax+50H], rcx                    ; 12BA _ 48: 89. 48, 50
        mov     qword [rax+58H], rbx                    ; 12BE _ 48: 89. 58, 58
        mov     rcx, qword [rdx+10H]                    ; 12C2 _ 48: 8B. 4A, 10
        mov     rbx, qword [rdx+18H]                    ; 12C6 _ 48: 8B. 5A, 18
        mov     qword [rax+60H], rcx                    ; 12CA _ 48: 89. 48, 60
        mov     qword [rax+68H], rbx                    ; 12CE _ 48: 89. 58, 68
        mov     rcx, qword [rdx+20H]                    ; 12D2 _ 48: 8B. 4A, 20
        mov     rbx, qword [rdx+28H]                    ; 12D6 _ 48: 8B. 5A, 28
        mov     qword [rax+70H], rcx                    ; 12DA _ 48: 89. 48, 70
        mov     qword [rax+78H], rbx                    ; 12DE _ 48: 89. 58, 78
        mov     rdx, qword [rdx+30H]                    ; 12E2 _ 48: 8B. 52, 30
        mov     qword [rax+80H], rdx                    ; 12E6 _ 48: 89. 90, 00000080
        mov     rax, qword [rbp-20H]                    ; 12ED _ 48: 8B. 45, E0
        add     rax, 80                                 ; 12F1 _ 48: 83. C0, 50
        mov     qword [rbp-28H], rax                    ; 12F5 _ 48: 89. 45, D8
        mov     rax, qword [rbp-20H]                    ; 12F9 _ 48: 8B. 45, E0
        mov     byte [rax+9H], 1                        ; 12FD _ C6. 40, 09, 01
        mov     rax, qword [rbp-20H]                    ; 1301 _ 48: 8B. 45, E0
        movzx   eax, byte [rax+8H]                      ; 1305 _ 0F B6. 40, 08
        xor     eax, 01H                                ; 1309 _ 83. F0, 01
        test    al, al                                  ; 130C _ 84. C0
        je      ?_110                                   ; 130E _ 0F 84, 00000088
        mov     rax, qword [rbp-20H]                    ; 1314 _ 48: 8B. 45, E0
        mov     rdx, qword [rbp-20H]                    ; 1318 _ 48: 8B. 55, E0
        mov     rcx, qword [rdx+50H]                    ; 131C _ 48: 8B. 4A, 50
        mov     rbx, qword [rdx+58H]                    ; 1320 _ 48: 8B. 5A, 58
        mov     qword [rax+18H], rcx                    ; 1324 _ 48: 89. 48, 18
        mov     qword [rax+20H], rbx                    ; 1328 _ 48: 89. 58, 20
        mov     rcx, qword [rdx+60H]                    ; 132C _ 48: 8B. 4A, 60
        mov     rbx, qword [rdx+68H]                    ; 1330 _ 48: 8B. 5A, 68
        mov     qword [rax+28H], rcx                    ; 1334 _ 48: 89. 48, 28
        mov     qword [rax+30H], rbx                    ; 1338 _ 48: 89. 58, 30
        mov     rcx, qword [rdx+70H]                    ; 133C _ 48: 8B. 4A, 70
        mov     rbx, qword [rdx+78H]                    ; 1340 _ 48: 8B. 5A, 78
        mov     qword [rax+38H], rcx                    ; 1344 _ 48: 89. 48, 38
        mov     qword [rax+40H], rbx                    ; 1348 _ 48: 89. 58, 40
        mov     rdx, qword [rdx+80H]                    ; 134C _ 48: 8B. 92, 00000080
        mov     qword [rax+48H], rdx                    ; 1353 _ 48: 89. 50, 48
        jmp     ?_110                                   ; 1357 _ EB, 43

?_109:  mov     rax, qword [rbp-20H]                    ; 1359 _ 48: 8B. 45, E0
        mov     rdx, qword [rbp-20H]                    ; 135D _ 48: 8B. 55, E0
        mov     rcx, qword [rdx+18H]                    ; 1361 _ 48: 8B. 4A, 18
        mov     rbx, qword [rdx+20H]                    ; 1365 _ 48: 8B. 5A, 20
        mov     qword [rax+50H], rcx                    ; 1369 _ 48: 89. 48, 50
        mov     qword [rax+58H], rbx                    ; 136D _ 48: 89. 58, 58
        mov     rcx, qword [rdx+28H]                    ; 1371 _ 48: 8B. 4A, 28
        mov     rbx, qword [rdx+30H]                    ; 1375 _ 48: 8B. 5A, 30
        mov     qword [rax+60H], rcx                    ; 1379 _ 48: 89. 48, 60
        mov     qword [rax+68H], rbx                    ; 137D _ 48: 89. 58, 68
        mov     rcx, qword [rdx+38H]                    ; 1381 _ 48: 8B. 4A, 38
        mov     rbx, qword [rdx+40H]                    ; 1385 _ 48: 8B. 5A, 40
        mov     qword [rax+70H], rcx                    ; 1389 _ 48: 89. 48, 70
        mov     qword [rax+78H], rbx                    ; 138D _ 48: 89. 58, 78
        mov     rdx, qword [rdx+48H]                    ; 1391 _ 48: 8B. 52, 48
        mov     qword [rax+80H], rdx                    ; 1395 _ 48: 89. 90, 00000080
?_110:  cmp     qword [rbp-28H], 0                      ; 139C _ 48: 83. 7D, D8, 00
        jz      ?_111                                   ; 13A1 _ 74, 1C
        mov     rax, qword [rbp-28H]                    ; 13A3 _ 48: 8B. 45, D8
        mov     rdi, rax                                ; 13A7 _ 48: 89. C7
        call    make_posix_time                         ; 13AA _ E8, FFFFFC2B
        mov     rdx, qword [rbp-20H]                    ; 13AF _ 48: 8B. 55, E0
        mov     qword [rdx+10H], rax                    ; 13B3 _ 48: 89. 42, 10
        mov     rax, qword [rbp-20H]                    ; 13B7 _ 48: 8B. 45, E0
        mov     byte [rax+0AH], 1                       ; 13BB _ C6. 40, 0A, 01
?_111:  nop                                             ; 13BF _ 90
        mov     rbx, qword [rbp-8H]                     ; 13C0 _ 48: 8B. 5D, F8
        leave                                           ; 13C4 _ C9
        ret                                             ; 13C5 _ C3

fix_outfile_name:; Local function
        push    rbp                                     ; 13C6 _ 55
        mov     rbp, rsp                                ; 13C7 _ 48: 89. E5
        sub     rsp, 48                                 ; 13CA _ 48: 83. EC, 30
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        mov     rax, qword [fs:abs 28H]                 ; 13CE _ 64 48: 8B. 04 25, 00000028
        mov     qword [rbp-8H], rax                     ; 13D7 _ 48: 89. 45, F8
        xor     eax, eax                                ; 13DB _ 31. C0
        mov     edi, 1                                  ; 13DD _ BF, 00000001
        call    get_filename                            ; 13E2 _ E8, FFFFEEDE
        mov     qword [rbp-18H], rax                    ; 13E7 _ 48: 89. 45, E8
        cmp     qword [rbp-18H], 0                      ; 13EB _ 48: 83. 7D, E8, 00
        jz      ?_112                                   ; 13F0 _ 74, 09
        mov     rax, qword [rbp-18H]                    ; 13F2 _ 48: 8B. 45, E8
        jmp     ?_115                                   ; 13F6 _ E9, 000000B7

?_112:  mov     eax, dword [rel operating_mode]         ; 13FB _ 8B. 05, 00000000(rel)
        and     eax, 02H                                ; 1401 _ 83. E0, 02
        test    eax, eax                                ; 1404 _ 85. C0
        jz      ?_113                                   ; 1406 _ 74, 0A
        mov     eax, 0                                  ; 1408 _ B8, 00000000
        jmp     ?_115                                   ; 140D _ E9, 000000A0

?_113:  mov     edi, 0                                  ; 1412 _ BF, 00000000
        call    get_filename                            ; 1417 _ E8, FFFFEEA9
        mov     qword [rbp-10H], rax                    ; 141C _ 48: 89. 45, F0
        mov     rax, qword [rel ofmt]                   ; 1420 _ 48: 8B. 05, 00000000(rel)
        mov     rdx, qword [rax+10H]                    ; 1427 _ 48: 8B. 50, 10
        mov     rax, qword [rbp-10H]                    ; 142B _ 48: 8B. 45, F0
        mov     rsi, rdx                                ; 142F _ 48: 89. D6
        mov     rdi, rax                                ; 1432 _ 48: 89. C7
        call    filename_set_extension                  ; 1435 _ E8, 00000000(PLT r)
        mov     qword [rbp-20H], rax                    ; 143A _ 48: 89. 45, E0
        mov     rax, qword [rbp-20H]                    ; 143E _ 48: 8B. 45, E0
        mov     rdx, qword [rbp-10H]                    ; 1442 _ 48: 8B. 55, F0
        mov     rsi, rdx                                ; 1446 _ 48: 89. D6
        mov     rdi, rax                                ; 1449 _ 48: 89. C7
        call    strcmp                                  ; 144C _ E8, 00000000(PLT r)
        test    eax, eax                                ; 1451 _ 85. C0
        jnz     ?_114                                   ; 1453 _ 75, 4C
        lea     rdx, [rel ?_542]                        ; 1455 _ 48: 8D. 15, 00000000(rel)
        lea     rax, [rbp-20H]                          ; 145C _ 48: 8D. 45, E0
        mov     rsi, rdx                                ; 1460 _ 48: 89. D6
        mov     rdi, rax                                ; 1463 _ 48: 89. C7
        call    nasm_strdupto                           ; 1466 _ E8, 00000000(PLT r)
        mov     dword [rbp-24H], 4456448                ; 146B _ C7. 45, DC, 00440000
        mov     eax, dword [rbp-24H]                    ; 1472 _ 8B. 45, DC
        mov     edi, eax                                ; 1475 _ 89. C7
        call    warn_active                             ; 1477 _ E8, FFFFECAE
        movzx   eax, al                                 ; 147C _ 0F B6. C0
        test    rax, rax                                ; 147F _ 48: 85. C0
        jz      ?_114                                   ; 1482 _ 74, 1D
        mov     rdx, qword [rbp-20H]                    ; 1484 _ 48: 8B. 55, E0
        lea     rcx, [rel ?_543]                        ; 1488 _ 48: 8D. 0D, 00000000(rel)
        mov     eax, dword [rbp-24H]                    ; 148F _ 8B. 45, DC
        mov     rsi, rcx                                ; 1492 _ 48: 89. CE
        mov     edi, eax                                ; 1495 _ 89. C7
        mov     eax, 0                                  ; 1497 _ B8, 00000000
        call    nasm_warn_                              ; 149C _ E8, 00000000(PLT r)
?_114:  mov     rax, qword [rbp-20H]                    ; 14A1 _ 48: 8B. 45, E0
        mov     rsi, rax                                ; 14A5 _ 48: 89. C6
        mov     edi, 1                                  ; 14A8 _ BF, 00000001
        call    set_filename                            ; 14AD _ E8, 00000000(PLT r)
?_115:  mov     rdx, qword [rbp-8H]                     ; 14B2 _ 48: 8B. 55, F8
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        sub     rdx, qword [fs:abs 28H]                 ; 14B6 _ 64 48: 2B. 14 25, 00000028
        jz      ?_116                                   ; 14BF _ 74, 05
        call    __stack_chk_fail                        ; 14C1 _ E8, 00000000(PLT r)
?_116:  leave                                           ; 14C6 _ C9
        ret                                             ; 14C7 _ C3

fix_dependfile_name:; Local function
        push    rbp                                     ; 14C8 _ 55
        mov     rbp, rsp                                ; 14C9 _ 48: 89. E5
        sub     rsp, 32                                 ; 14CC _ 48: 83. EC, 20
        mov     edi, 4                                  ; 14D0 _ BF, 00000004
        call    get_filename                            ; 14D5 _ E8, FFFFEDEB
        mov     qword [rbp-18H], rax                    ; 14DA _ 48: 89. 45, E8
        cmp     qword [rbp-18H], 0                      ; 14DE _ 48: 83. 7D, E8, 00
        jz      ?_117                                   ; 14E3 _ 74, 09
        mov     rax, qword [rbp-18H]                    ; 14E5 _ 48: 8B. 45, E8
        jmp     ?_122                                   ; 14E9 _ E9, 0000009D

?_117:  mov     eax, dword [rel operating_mode]         ; 14EE _ 8B. 05, 00000000(rel)
        and     eax, 0FFFFFFFBH                         ; 14F4 _ 83. E0, FB
        test    eax, eax                                ; 14F7 _ 85. C0
        jnz     ?_118                                   ; 14F9 _ 75, 0A
        mov     eax, 0                                  ; 14FB _ B8, 00000000
        jmp     ?_122                                   ; 1500 _ E9, 00000086

?_118:  mov     edi, 1                                  ; 1505 _ BF, 00000001
        call    get_filename                            ; 150A _ E8, FFFFEDB6
        mov     qword [rbp-10H], rax                    ; 150F _ 48: 89. 45, F0
        cmp     qword [rbp-10H], 0                      ; 1513 _ 48: 83. 7D, F0, 00
        jz      ?_119                                   ; 1518 _ 74, 1C
        lea     rdx, [rel ?_544]                        ; 151A _ 48: 8D. 15, 00000000(rel)
        mov     rax, qword [rbp-10H]                    ; 1521 _ 48: 8B. 45, F0
        mov     rsi, rdx                                ; 1525 _ 48: 89. D6
        mov     rdi, rax                                ; 1528 _ 48: 89. C7
        call    nasm_strcat                             ; 152B _ E8, 00000000(PLT r)
        mov     qword [rbp-20H], rax                    ; 1530 _ 48: 89. 45, E0
        jmp     ?_121                                   ; 1534 _ EB, 44

?_119:  mov     edi, 0                                  ; 1536 _ BF, 00000000
        call    get_filename                            ; 153B _ E8, FFFFED85
        mov     qword [rbp-8H], rax                     ; 1540 _ 48: 89. 45, F8
        cmp     qword [rbp-8H], 0                       ; 1544 _ 48: 83. 7D, F8, 00
        jz      ?_120                                   ; 1549 _ 74, 1C
        lea     rdx, [rel ?_544]                        ; 154B _ 48: 8D. 15, 00000000(rel)
        mov     rax, qword [rbp-8H]                     ; 1552 _ 48: 8B. 45, F8
        mov     rsi, rdx                                ; 1556 _ 48: 89. D6
        mov     rdi, rax                                ; 1559 _ 48: 89. C7
        call    filename_set_extension                  ; 155C _ E8, 00000000(PLT r)
        mov     qword [rbp-20H], rax                    ; 1561 _ 48: 89. 45, E0
        jmp     ?_121                                   ; 1565 _ EB, 13

?_120:  lea     rax, [rel ?_545]                        ; 1567 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 156E _ 48: 89. C7
        call    nasm_strdup                             ; 1571 _ E8, 00000000(PLT r)
        mov     qword [rbp-20H], rax                    ; 1576 _ 48: 89. 45, E0
?_121:  mov     rax, qword [rbp-20H]                    ; 157A _ 48: 8B. 45, E0
        mov     rsi, rax                                ; 157E _ 48: 89. C6
        mov     edi, 4                                  ; 1581 _ BF, 00000004
        call    set_filename                            ; 1586 _ E8, 00000000(PLT r)
?_122:  leave                                           ; 158B _ C9
        ret                                             ; 158C _ C3

main:   ; Function begin
        push    rbp                                     ; 158D _ 55
        mov     rbp, rsp                                ; 158E _ 48: 89. E5
        push    r12                                     ; 1591 _ 41: 54
        push    rbx                                     ; 1593 _ 53
        sub     rsp, 112                                ; 1594 _ 48: 83. EC, 70
        mov     dword [rbp-74H], edi                    ; 1598 _ 89. 7D, 8C
        mov     qword [rbp-80H], rsi                    ; 159B _ 48: 89. 75, 80
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        mov     rax, qword [fs:abs 28H]                 ; 159F _ 64 48: 8B. 04 25, 00000028
        mov     qword [rbp-18H], rax                    ; 15A8 _ 48: 89. 45, E8
        xor     eax, eax                                ; 15AC _ 31. C0
        mov     rax, qword [rel stderr]                 ; 15AE _ 48: 8B. 05, 00000000(rel)
        mov     qword [rel erropt], rax                 ; 15B5 _ 48: 89. 05, 00000000(rel)
        mov     rax, qword [rbp-80H]                    ; 15BC _ 48: 8B. 45, 80
        mov     rax, qword [rax]                        ; 15C0 _ 48: 8B. 00
        mov     qword [rel _progname], rax              ; 15C3 _ 48: 89. 05, 00000000(rel)
        mov     rax, qword [rel _progname]              ; 15CA _ 48: 8B. 05, 00000000(rel)
        test    rax, rax                                ; 15D1 _ 48: 85. C0
        jz      ?_123                                   ; 15D4 _ 74, 0E
        mov     rax, qword [rel _progname]              ; 15D6 _ 48: 8B. 05, 00000000(rel)
        movzx   eax, byte [rax]                         ; 15DD _ 0F B6. 00
        test    al, al                                  ; 15E0 _ 84. C0
        jnz     ?_124                                   ; 15E2 _ 75, 0E
?_123:  lea     rax, [rel ?_546]                        ; 15E4 _ 48: 8D. 05, 00000000(rel)
        mov     qword [rel _progname], rax              ; 15EB _ 48: 89. 05, 00000000(rel)
?_124:  call    timestamp                               ; 15F2 _ E8, FFFFFC07
        mov     edi, 0                                  ; 15F7 _ BF, 00000000
        call    set_cpu                                 ; 15FC _ E8, 00000000(PLT r)
        mov     rax, qword [rel cpu]                    ; 1601 _ 48: 8B. 05, 00000000(rel)
        mov     rdx, qword [rel cpu+8H]                 ; 1608 _ 48: 8B. 15, 00000000(rel)
        mov     qword [rel cmd_cpu], rax                ; 160F _ 48: 89. 05, 00000000(rel)
        mov     qword [rel cmd_cpu+8H], rdx             ; 1616 _ 48: 89. 15, 00000000(rel)
; Note: Memory operand is misaligned. Performance penalty
        mov     rax, qword [rel cpu+0CH]                ; 161D _ 48: 8B. 05, 00000000(rel)
; Note: Memory operand is misaligned. Performance penalty
        mov     rdx, qword [rel cpu+14H]                ; 1624 _ 48: 8B. 15, 00000000(rel)
; Note: Memory operand is misaligned. Performance penalty
        mov     qword [rel cmd_cpu+0CH], rax            ; 162B _ 48: 89. 05, 00000000(rel)
; Note: Memory operand is misaligned. Performance penalty
        mov     qword [rel cmd_cpu+14H], rdx            ; 1632 _ 48: 89. 15, 00000000(rel)
        call    set_default_limits                      ; 1639 _ E8, FFFFEE28
        mov     edi, 1                                  ; 163E _ BF, 00000001
        call    strlist_alloc                           ; 1643 _ E8, 00000000(PLT r)
        mov     qword [rel include_path], rax           ; 1648 _ 48: 89. 05, 00000000(rel)
        mov     edi, 0                                  ; 164F _ BF, 00000000
        call    reset_global_defaults                   ; 1654 _ E8, 00000000(PLT r)
        mov     dword [rel _pass_type], 0               ; 1659 _ C7. 05, 00000000(rel), 00000000
        mov     qword [rel _passn], 0                   ; 1663 _ 48: C7. 05, 00000000(rel), 00000000
        call    nasm_ctype_init                         ; 166E _ E8, 00000000(PLT r)
        call    src_init                                ; 1673 _ E8, 00000000(PLT r)
        call    init_labels                             ; 1678 _ E8, 00000000(PLT r)
        mov     qword [rel offsets], 0                  ; 167D _ 48: C7. 05, 00000000(rel), 00000000
        mov     edi, 8                                  ; 1688 _ BF, 00000008
        call    saa_init                                ; 168D _ E8, 00000000(PLT r)
        mov     qword [rel forwrefs], rax               ; 1692 _ 48: 89. 05, 00000000(rel)
        mov     dword [rel operating_mode], 1           ; 1699 _ C7. 05, 00000000(rel), 00000001
        mov     rcx, qword [rbp-80H]                    ; 16A3 _ 48: 8B. 4D, 80
        mov     eax, dword [rbp-74H]                    ; 16A7 _ 8B. 45, 8C
        mov     edx, 1                                  ; 16AA _ BA, 00000001
        mov     rsi, rcx                                ; 16AF _ 48: 89. CE
        mov     edi, eax                                ; 16B2 _ 89. C7
        call    parse_cmdline                           ; 16B4 _ E8, 00002172
        call    terminate_after_phase                   ; 16B9 _ E8, FFFFEC5B
        test    al, al                                  ; 16BE _ 84. C0
        jz      ?_125                                   ; 16C0 _ 74, 0A
        mov     eax, 1                                  ; 16C2 _ B8, 00000001
        jmp     ?_153                                   ; 16C7 _ E9, 00000676

?_125:  movzx   eax, byte [rel using_debug_info]        ; 16CC _ 0F B6. 05, 00000000(rel)
        xor     eax, 01H                                ; 16D3 _ 83. F0, 01
        test    al, al                                  ; 16D6 _ 84. C0
        jz      ?_126                                   ; 16D8 _ 74, 10
        lea     rax, [rel null_debug_form]              ; 16DA _ 48: 8D. 05, 00000000(rel)
        mov     qword [rel dfmt], rax                   ; 16E1 _ 48: 89. 05, 00000000(rel)
        jmp     ?_128                                   ; 16E8 _ EB, 7A

?_126:  mov     rax, qword [rel debug_format]           ; 16EA _ 48: 8B. 05, 00000000(rel)
        test    rax, rax                                ; 16F1 _ 48: 85. C0
        jnz     ?_127                                   ; 16F4 _ 75, 14
        mov     rax, qword [rel ofmt]                   ; 16F6 _ 48: 8B. 05, 00000000(rel)
        mov     rax, qword [rax+28H]                    ; 16FD _ 48: 8B. 40, 28
        mov     qword [rel dfmt], rax                   ; 1701 _ 48: 89. 05, 00000000(rel)
        jmp     ?_128                                   ; 1708 _ EB, 5A

?_127:  mov     rdx, qword [rel debug_format]           ; 170A _ 48: 8B. 15, 00000000(rel)
        mov     rax, qword [rel ofmt]                   ; 1711 _ 48: 8B. 05, 00000000(rel)
        mov     rsi, rdx                                ; 1718 _ 48: 89. D6
        mov     rdi, rax                                ; 171B _ 48: 89. C7
        call    dfmt_find                               ; 171E _ E8, 00000000(PLT r)
        mov     qword [rel dfmt], rax                   ; 1723 _ 48: 89. 05, 00000000(rel)
        mov     rax, qword [rel dfmt]                   ; 172A _ 48: 8B. 05, 00000000(rel)
        test    rax, rax                                ; 1731 _ 48: 85. C0
        jnz     ?_128                                   ; 1734 _ 75, 2E
        mov     rax, qword [rel ofmt]                   ; 1736 _ 48: 8B. 05, 00000000(rel)
        mov     rdx, qword [rax+8H]                     ; 173D _ 48: 8B. 50, 08
        mov     rax, qword [rel debug_format]           ; 1741 _ 48: 8B. 05, 00000000(rel)
        lea     rsi, [rel ?_547]                        ; 1748 _ 48: 8D. 35, 00000000(rel)
        mov     rcx, rdx                                ; 174F _ 48: 89. D1
        mov     rdx, rax                                ; 1752 _ 48: 89. C2
        mov     edi, 128                                ; 1755 _ BF, 00000080
        mov     eax, 0                                  ; 175A _ B8, 00000000
        call    nasm_fatalf                             ; 175F _ E8, 00000000(PLT r)
?_128:  movzx   eax, byte [rel tasm_compatible_mode]    ; 1764 _ 0F B6. 05, 00000000(rel)
        test    al, al                                  ; 176B _ 84. C0
        jz      ?_129                                   ; 176D _ 74, 14
        mov     eax, dword [rel ppopt]                  ; 176F _ 8B. 05, 00000000(rel)
        or      eax, 04H                                ; 1775 _ 83. C8, 04
        mov     dword [rel ppopt], eax                  ; 1778 _ 89. 05, 00000000(rel)
        call    nasm_ctype_tasm_mode                    ; 177E _ E8, FFFFE96C
?_129:  mov     rax, qword [rel include_path]           ; 1783 _ 48: 8B. 05, 00000000(rel)
        mov     rdi, rax                                ; 178A _ 48: 89. C7
        call    preproc_init                            ; 178D _ E8, FFFFF5A1
        mov     rcx, qword [rbp-80H]                    ; 1792 _ 48: 8B. 4D, 80
        mov     eax, dword [rbp-74H]                    ; 1796 _ 8B. 45, 8C
        mov     edx, 2                                  ; 1799 _ BA, 00000002
        mov     rsi, rcx                                ; 179E _ 48: 89. CE
        mov     edi, eax                                ; 17A1 _ 89. C7
        call    parse_cmdline                           ; 17A3 _ E8, 00002083
        call    terminate_after_phase                   ; 17A8 _ E8, FFFFEB6C
        test    al, al                                  ; 17AD _ 84. C0
        jz      ?_130                                   ; 17AF _ 74, 0A
        mov     eax, 1                                  ; 17B1 _ B8, 00000001
        jmp     ?_153                                   ; 17B6 _ E9, 00000587

?_130:  call    error_init                              ; 17BB _ E8, 00000000(PLT r)
        mov     rax, qword [rel nasm_limit]             ; 17C0 _ 48: 8B. 05, 00000000(rel)
        mov     rdx, qword [rel nasm_limit+8H]          ; 17C7 _ 48: 8B. 15, 00000000(rel)
        mov     qword [rel nasm_limit_from_cmdline], rax; 17CE _ 48: 89. 05, 00000000(rel)
        mov     qword [rel ?_499], rdx                  ; 17D5 _ 48: 89. 15, 00000000(rel)
        mov     rax, qword [rel nasm_limit+10H]         ; 17DC _ 48: 8B. 05, 00000000(rel)
        mov     rdx, qword [rel nasm_limit+18H]         ; 17E3 _ 48: 8B. 15, 00000000(rel)
        mov     qword [rel ?_500], rax                  ; 17EA _ 48: 89. 05, 00000000(rel)
        mov     qword [rel ?_501], rdx                  ; 17F1 _ 48: 89. 15, 00000000(rel)
        mov     rax, qword [rel nasm_limit+20H]         ; 17F8 _ 48: 8B. 05, 00000000(rel)
        mov     rdx, qword [rel nasm_limit+28H]         ; 17FF _ 48: 8B. 15, 00000000(rel)
        mov     qword [rel ?_502], rax                  ; 1806 _ 48: 89. 05, 00000000(rel)
        mov     qword [rel ?_503], rdx                  ; 180D _ 48: 89. 15, 00000000(rel)
        mov     rax, qword [rel nasm_limit+30H]         ; 1814 _ 48: 8B. 05, 00000000(rel)
        mov     rdx, qword [rel nasm_limit+38H]         ; 181B _ 48: 8B. 15, 00000000(rel)
        mov     qword [rel ?_504], rax                  ; 1822 _ 48: 89. 05, 00000000(rel)
        mov     qword [rel ?_505], rdx                  ; 1829 _ 48: 89. 15, 00000000(rel)
        mov     rax, qword [rel nasm_limit+40H]         ; 1830 _ 48: 8B. 05, 00000000(rel)
        mov     qword [rel ?_506], rax                  ; 1837 _ 48: 89. 05, 00000000(rel)
        call    fix_dependfile_name                     ; 183E _ E8, FFFFFC85
        call    fix_outfile_name                        ; 1843 _ E8, FFFFFB7E
        mov     eax, dword [rel operating_mode]         ; 1848 _ 8B. 05, 00000000(rel)
        and     eax, 04H                                ; 184E _ 83. E0, 04
        test    eax, eax                                ; 1851 _ 85. C0
        jz      ?_131                                   ; 1853 _ 74, 45
        mov     edi, 1                                  ; 1855 _ BF, 00000001
        call    strlist_alloc                           ; 185A _ E8, 00000000(PLT r)
        mov     qword [rel depend_list], rax            ; 185F _ 48: 89. 05, 00000000(rel)
        mov     edi, 8                                  ; 1866 _ BF, 00000008
        call    get_filename                            ; 186B _ E8, FFFFEA55
        test    rax, rax                                ; 1870 _ 48: 85. C0
        jnz     ?_132                                   ; 1873 _ 75, 30
        mov     rbx, qword [rel quote_for_make]         ; 1875 _ 48: 8B. 1D, 00000000(rel)
        mov     edi, 1                                  ; 187C _ BF, 00000001
        call    get_filename                            ; 1881 _ E8, FFFFEA3F
        mov     rdi, rax                                ; 1886 _ 48: 89. C7
        call    rbx                                     ; 1889 _ FF. D3
        mov     rsi, rax                                ; 188B _ 48: 89. C6
        mov     edi, 8                                  ; 188E _ BF, 00000008
        call    set_filename                            ; 1893 _ E8, 00000000(PLT r)
        jmp     ?_132                                   ; 1898 _ EB, 0B

?_131:  mov     qword [rel depend_list], 0              ; 189A _ 48: C7. 05, 00000000(rel), 00000000
?_132:  mov     eax, dword [rel cmd_sb]                 ; 18A5 _ 8B. 05, 00000000(rel)
        mov     edi, eax                                ; 18AB _ 89. C7
        call    reset_global_defaults                   ; 18AD _ E8, 00000000(PLT r)
        mov     eax, dword [rel operating_mode]         ; 18B2 _ 8B. 05, 00000000(rel)
        and     eax, 03H                                ; 18B8 _ 83. E0, 03
        test    eax, eax                                ; 18BB _ 85. C0
        jne     ?_136                                   ; 18BD _ 0F 85, 00000088
        mov     edi, 1                                  ; 18C3 _ BF, 00000001
        call    error_pass_start                        ; 18C8 _ E8, 00000000(PLT r)
        movzx   eax, byte [rel depend_missing_ok]       ; 18CD _ 0F B6. 05, 00000000(rel)
        test    al, al                                  ; 18D4 _ 84. C0
        jz      ?_133                                   ; 18D6 _ 74, 0A
        mov     edi, 0                                  ; 18D8 _ BF, 00000000
        call    pp_include_path                         ; 18DD _ E8, 00000000(PLT r)
?_133:  mov     rbx, qword [rel depend_list]            ; 18E2 _ 48: 8B. 1D, 00000000(rel)
        mov     edi, 7                                  ; 18E9 _ BF, 00000007
        call    get_filename                            ; 18EE _ E8, FFFFE9D2
        mov     r12, rax                                ; 18F3 _ 49: 89. C4
        mov     edi, 0                                  ; 18F6 _ BF, 00000000
        call    get_filename                            ; 18FB _ E8, FFFFE9C5
        mov     rcx, rbx                                ; 1900 _ 48: 89. D9
        mov     edx, 1                                  ; 1903 _ BA, 00000001
        mov     rsi, r12                                ; 1908 _ 4C: 89. E6
        mov     rdi, rax                                ; 190B _ 48: 89. C7
        call    pp_reset                                ; 190E _ E8, 00000000(PLT r)
        mov     qword [rel ofile], 0                    ; 1913 _ 48: C7. 05, 00000000(rel), 00000000
        jmp     ?_135                                   ; 191E _ EB, 0C

?_134:  mov     rax, qword [rbp-40H]                    ; 1920 _ 48: 8B. 45, C0
        mov     rdi, rax                                ; 1924 _ 48: 89. C7
        call    nasm_free                               ; 1927 _ E8, 00000000(PLT r)
?_135:  call    pp_getline                              ; 192C _ E8, 00000000(PLT r)
        mov     qword [rbp-40H], rax                    ; 1931 _ 48: 89. 45, C0
        cmp     qword [rbp-40H], 0                      ; 1935 _ 48: 83. 7D, C0, 00
        jnz     ?_134                                   ; 193A _ 75, E4
        call    pp_cleanup_pass                         ; 193C _ E8, 00000000(PLT r)
        call    error_pass_end                          ; 1941 _ E8, 00000000(PLT r)
        jmp     ?_148                                   ; 1946 _ E9, 0000025B

?_136:  mov     eax, dword [rel operating_mode]         ; 194B _ 8B. 05, 00000000(rel)
        and     eax, 02H                                ; 1951 _ 83. E0, 02
        test    eax, eax                                ; 1954 _ 85. C0
        je      ?_148                                   ; 1956 _ 0F 84, 0000024A
        mov     qword [rbp-58H], 0                      ; 195C _ 48: C7. 45, A8, 00000000
        mov     rax, qword [rbp-58H]                    ; 1964 _ 48: 8B. 45, A8
        mov     rdi, rax                                ; 1968 _ 48: 89. C7
        call    nasm_quote_filename                     ; 196B _ E8, FFFFF774
        mov     qword [rbp-60H], rax                    ; 1970 _ 48: 89. 45, A0
        mov     dword [rbp-68H], 0                      ; 1974 _ C7. 45, 98, 00000000
        mov     dword [rbp-64H], 0                      ; 197B _ C7. 45, 9C, 00000000
        mov     edi, 1                                  ; 1982 _ BF, 00000001
        call    get_filename                            ; 1987 _ E8, FFFFE939
        mov     qword [rbp-50H], rax                    ; 198C _ 48: 89. 45, B0
        cmp     qword [rbp-50H], 0                      ; 1990 _ 48: 83. 7D, B0, 00
        jz      ?_137                                   ; 1995 _ 74, 44
        mov     rax, qword [rbp-50H]                    ; 1997 _ 48: 8B. 45, B0
        mov     esi, 1                                  ; 199B _ BE, 00000001
        mov     rdi, rax                                ; 19A0 _ 48: 89. C7
        call    nasm_open_write                         ; 19A3 _ E8, 00000000(PLT r)
        mov     qword [rel ofile], rax                  ; 19A8 _ 48: 89. 05, 00000000(rel)
        mov     rax, qword [rel ofile]                  ; 19AF _ 48: 8B. 05, 00000000(rel)
        test    rax, rax                                ; 19B6 _ 48: 85. C0
        jnz     ?_138                                   ; 19B9 _ 75, 2E
        mov     rax, qword [rbp-50H]                    ; 19BB _ 48: 8B. 45, B0
        lea     rcx, [rel ?_548]                        ; 19BF _ 48: 8D. 0D, 00000000(rel)
        mov     rdx, rax                                ; 19C6 _ 48: 89. C2
        mov     rsi, rcx                                ; 19C9 _ 48: 89. CE
        mov     edi, 8192                               ; 19CC _ BF, 00002000
        mov     eax, 0                                  ; 19D1 _ B8, 00000000
        call    nasm_fatalf                             ; 19D6 _ E8, 00000000(PLT r)
?_137:  mov     rax, qword [rel stdout]                 ; 19DB _ 48: 8B. 05, 00000000(rel)
        mov     qword [rel ofile], rax                  ; 19E2 _ 48: 89. 05, 00000000(rel)
?_138:  mov     byte [rel location+0CH], 0              ; 19E9 _ C6. 05, 00000000(rel), 00
        mov     dword [rel _pass_type], 1               ; 19F0 _ C7. 05, 00000000(rel), 00000001
        mov     rbx, qword [rel depend_list]            ; 19FA _ 48: 8B. 1D, 00000000(rel)
        mov     edi, 7                                  ; 1A01 _ BF, 00000007
        call    get_filename                            ; 1A06 _ E8, FFFFE8BA
        mov     r12, rax                                ; 1A0B _ 49: 89. C4
        mov     edi, 0                                  ; 1A0E _ BF, 00000000
        call    get_filename                            ; 1A13 _ E8, FFFFE8AD
        mov     rcx, rbx                                ; 1A18 _ 48: 89. D9
        mov     edx, 2                                  ; 1A1B _ BA, 00000002
        mov     rsi, r12                                ; 1A20 _ 4C: 89. E6
        mov     rdi, rax                                ; 1A23 _ 48: 89. C7
        call    pp_reset                                ; 1A26 _ E8, 00000000(PLT r)
        mov     edi, 1                                  ; 1A2B _ BF, 00000001
        call    error_pass_start                        ; 1A30 _ E8, 00000000(PLT r)
        jmp     ?_147                                   ; 1A35 _ E9, 00000133

?_139:  call    src_where                               ; 1A3A _ E8, FFFFE6D7
        mov     qword [rbp-30H], rax                    ; 1A3F _ 48: 89. 45, D0
        mov     qword [rbp-28H], rdx                    ; 1A43 _ 48: 89. 55, D8
        mov     rax, qword [rbp-30H]                    ; 1A47 _ 48: 8B. 45, D0
        cmp     qword [rbp-58H], rax                    ; 1A4B _ 48: 39. 45, A8
        jz      ?_140                                   ; 1A4F _ 74, 3D
        mov     rax, qword [rbp-30H]                    ; 1A51 _ 48: 8B. 45, D0
        mov     qword [rbp-58H], rax                    ; 1A55 _ 48: 89. 45, A8
        mov     dword [rbp-68H], -1                     ; 1A59 _ C7. 45, 98, FFFFFFFF
        cmp     qword [rbp-58H], 0                      ; 1A60 _ 48: 83. 7D, A8, 00
        setne   al                                      ; 1A65 _ 0F 95. C0
        movzx   eax, al                                 ; 1A68 _ 0F B6. C0
        mov     dword [rbp-64H], eax                    ; 1A6B _ 89. 45, 9C
        mov     rax, qword [rbp-58H]                    ; 1A6E _ 48: 8B. 45, A8
        mov     rdi, rax                                ; 1A72 _ 48: 89. C7
        call    nasm_quote_filename                     ; 1A75 _ E8, FFFFF66A
        mov     rdx, rax                                ; 1A7A _ 48: 89. C2
        lea     rax, [rbp-60H]                          ; 1A7D _ 48: 8D. 45, A0
        mov     rsi, rdx                                ; 1A81 _ 48: 89. D6
        mov     rdi, rax                                ; 1A84 _ 48: 89. C7
        call    nasm_strto                              ; 1A87 _ E8, FFFFE5A5
        jmp     ?_143                                   ; 1A8C _ EB, 5D

?_140:  cmp     dword [rbp-64H], 0                      ; 1A8E _ 83. 7D, 9C, 00
        jz      ?_142                                   ; 1A92 _ 74, 43
        mov     edx, dword [rbp-68H]                    ; 1A94 _ 8B. 55, 98
        mov     eax, dword [rbp-64H]                    ; 1A97 _ 8B. 45, 9C
        add     edx, eax                                ; 1A9A _ 01. C2
        mov     eax, dword [rbp-28H]                    ; 1A9C _ 8B. 45, D8
        cmp     edx, eax                                ; 1A9F _ 39. C2
        jnz     ?_141                                   ; 1AA1 _ 75, 1C
        mov     rax, qword [rel ofile]                  ; 1AA3 _ 48: 8B. 05, 00000000(rel)
        mov     rsi, rax                                ; 1AAA _ 48: 89. C6
        mov     edi, 10                                 ; 1AAD _ BF, 0000000A
        call    fputc                                   ; 1AB2 _ E8, 00000000(PLT r)
        mov     eax, dword [rbp-64H]                    ; 1AB7 _ 8B. 45, 9C
        add     dword [rbp-68H], eax                    ; 1ABA _ 01. 45, 98
        jmp     ?_143                                   ; 1ABD _ EB, 2C

?_141:  mov     eax, dword [rbp-68H]                    ; 1ABF _ 8B. 45, 98
        sub     eax, dword [rbp-64H]                    ; 1AC2 _ 2B. 45, 9C
        mov     edx, eax                                ; 1AC5 _ 89. C2
        mov     eax, dword [rbp-28H]                    ; 1AC7 _ 8B. 45, D8
        cmp     edx, eax                                ; 1ACA _ 39. C2
        jnz     ?_143                                   ; 1ACC _ 75, 1D
        mov     dword [rbp-64H], 0                      ; 1ACE _ C7. 45, 9C, 00000000
        jmp     ?_143                                   ; 1AD5 _ EB, 14

?_142:  mov     eax, dword [rbp-68H]                    ; 1AD7 _ 8B. 45, 98
        lea     edx, [rax+1H]                           ; 1ADA _ 8D. 50, 01
        mov     eax, dword [rbp-28H]                    ; 1ADD _ 8B. 45, D8
        cmp     edx, eax                                ; 1AE0 _ 39. C2
        jnz     ?_143                                   ; 1AE2 _ 75, 07
        mov     dword [rbp-64H], 1                      ; 1AE4 _ C7. 45, 9C, 00000001
?_143:  mov     rax, qword [rbp-48H]                    ; 1AEB _ 48: 8B. 45, B8
        movzx   eax, byte [rax]                         ; 1AEF _ 0F B6. 00
        test    al, al                                  ; 1AF2 _ 84. C0
        jnz     ?_144                                   ; 1AF4 _ 75, 06
        cmp     dword [rbp-68H], -1                     ; 1AF6 _ 83. 7D, 98, FF
        jz      ?_146                                   ; 1AFA _ 74, 65
?_144:  mov     eax, dword [rbp-28H]                    ; 1AFC _ 8B. 45, D8
        cmp     dword [rbp-68H], eax                    ; 1AFF _ 39. 45, 98
        jz      ?_145                                   ; 1B02 _ 74, 28
        mov     rdi, qword [rbp-60H]                    ; 1B04 _ 48: 8B. 7D, A0
        mov     edx, dword [rbp-28H]                    ; 1B08 _ 8B. 55, D8
        mov     rax, qword [rel ofile]                  ; 1B0B _ 48: 8B. 05, 00000000(rel)
        mov     ecx, dword [rbp-64H]                    ; 1B12 _ 8B. 4D, 9C
        lea     rsi, [rel ?_549]                        ; 1B15 _ 48: 8D. 35, 00000000(rel)
        mov     r8, rdi                                 ; 1B1C _ 49: 89. F8
        mov     rdi, rax                                ; 1B1F _ 48: 89. C7
        mov     eax, 0                                  ; 1B22 _ B8, 00000000
        call    fprintf                                 ; 1B27 _ E8, 00000000(PLT r)
?_145:  mov     edx, dword [rbp-28H]                    ; 1B2C _ 8B. 55, D8
        mov     eax, dword [rbp-64H]                    ; 1B2F _ 8B. 45, 9C
        add     eax, edx                                ; 1B32 _ 01. D0
        mov     dword [rbp-68H], eax                    ; 1B34 _ 89. 45, 98
        mov     rdx, qword [rel ofile]                  ; 1B37 _ 48: 8B. 15, 00000000(rel)
        mov     rax, qword [rbp-48H]                    ; 1B3E _ 48: 8B. 45, B8
        mov     rsi, rdx                                ; 1B42 _ 48: 89. D6
        mov     rdi, rax                                ; 1B45 _ 48: 89. C7
        call    fputs                                   ; 1B48 _ E8, 00000000(PLT r)
        mov     rax, qword [rel ofile]                  ; 1B4D _ 48: 8B. 05, 00000000(rel)
        mov     rsi, rax                                ; 1B54 _ 48: 89. C6
        mov     edi, 10                                 ; 1B57 _ BF, 0000000A
        call    fputc                                   ; 1B5C _ E8, 00000000(PLT r)
?_146:  mov     rax, qword [rbp-48H]                    ; 1B61 _ 48: 8B. 45, B8
        mov     rdi, rax                                ; 1B65 _ 48: 89. C7
        call    nasm_free                               ; 1B68 _ E8, 00000000(PLT r)
?_147:  call    pp_getline                              ; 1B6D _ E8, 00000000(PLT r)
        mov     qword [rbp-48H], rax                    ; 1B72 _ 48: 89. 45, B8
        cmp     qword [rbp-48H], 0                      ; 1B76 _ 48: 83. 7D, B8, 00
        jne     ?_139                                   ; 1B7B _ 0F 85, FFFFFEB9
        mov     rax, qword [rbp-60H]                    ; 1B81 _ 48: 8B. 45, A0
        mov     rdi, rax                                ; 1B85 _ 48: 89. C7
        call    nasm_free                               ; 1B88 _ E8, 00000000(PLT r)
        call    pp_cleanup_pass                         ; 1B8D _ E8, 00000000(PLT r)
        call    error_pass_end                          ; 1B92 _ E8, 00000000(PLT r)
        call    terminate_after_phase                   ; 1B97 _ E8, FFFFE77D
        movzx   eax, al                                 ; 1B9C _ 0F B6. C0
        mov     edi, eax                                ; 1B9F _ 89. C7
        call    close_output                            ; 1BA1 _ E8, 00000000(PLT r)
?_148:  mov     eax, dword [rel operating_mode]         ; 1BA6 _ 8B. 05, 00000000(rel)
        and     eax, 01H                                ; 1BAC _ 83. E0, 01
        test    eax, eax                                ; 1BAF _ 85. C0
        je      ?_151                                   ; 1BB1 _ 0F 84, 00000116
        mov     edi, 1                                  ; 1BB7 _ BF, 00000001
        call    get_filename                            ; 1BBC _ E8, FFFFE704
        mov     qword [rbp-38H], rax                    ; 1BC1 _ 48: 89. 45, C8
        mov     rax, qword [rel ofmt]                   ; 1BC5 _ 48: 8B. 05, 00000000(rel)
        mov     eax, dword [rax+18H]                    ; 1BCC _ 8B. 40, 18
        and     eax, 01H                                ; 1BCF _ 83. E0, 01
        mov     edx, eax                                ; 1BD2 _ 89. C2
        mov     rax, qword [rbp-38H]                    ; 1BD4 _ 48: 8B. 45, C8
        mov     esi, edx                                ; 1BD8 _ 89. D6
        mov     rdi, rax                                ; 1BDA _ 48: 89. C7
        call    nasm_open_write                         ; 1BDD _ E8, 00000000(PLT r)
        mov     qword [rel ofile], rax                  ; 1BE2 _ 48: 89. 05, 00000000(rel)
        mov     rax, qword [rel ofile]                  ; 1BE9 _ 48: 8B. 05, 00000000(rel)
        test    rax, rax                                ; 1BF0 _ 48: 85. C0
        jnz     ?_149                                   ; 1BF3 _ 75, 20
        mov     rax, qword [rbp-38H]                    ; 1BF5 _ 48: 8B. 45, C8
        lea     rcx, [rel ?_548]                        ; 1BF9 _ 48: 8D. 0D, 00000000(rel)
        mov     rdx, rax                                ; 1C00 _ 48: 89. C2
        mov     rsi, rcx                                ; 1C03 _ 48: 89. CE
        mov     edi, 8192                               ; 1C06 _ BF, 00002000
        mov     eax, 0                                  ; 1C0B _ B8, 00000000
        call    nasm_fatalf                             ; 1C10 _ E8, 00000000(PLT r)
?_149:  mov     rax, qword [rel ofmt]                   ; 1C15 _ 48: 8B. 05, 00000000(rel)
        mov     rax, qword [rax+38H]                    ; 1C1C _ 48: 8B. 40, 38
        call    rax                                     ; 1C20 _ FF. D0
        mov     rax, qword [rel dfmt]                   ; 1C22 _ 48: 8B. 05, 00000000(rel)
        mov     rax, qword [rax+10H]                    ; 1C29 _ 48: 8B. 40, 10
        call    rax                                     ; 1C2D _ FF. D0
        mov     rbx, qword [rel depend_list]            ; 1C2F _ 48: 8B. 1D, 00000000(rel)
        mov     edi, 7                                  ; 1C36 _ BF, 00000007
        call    get_filename                            ; 1C3B _ E8, FFFFE685
        mov     r12, rax                                ; 1C40 _ 49: 89. C4
        mov     edi, 0                                  ; 1C43 _ BF, 00000000
        call    get_filename                            ; 1C48 _ E8, FFFFE678
        mov     rdx, rbx                                ; 1C4D _ 48: 89. DA
        mov     rsi, r12                                ; 1C50 _ 4C: 89. E6
        mov     rdi, rax                                ; 1C53 _ 48: 89. C7
        call    assemble_file                           ; 1C56 _ E8, 00001FB7
        call    terminate_after_phase                   ; 1C5B _ E8, FFFFE6B9
        xor     eax, 01H                                ; 1C60 _ 83. F0, 01
        test    al, al                                  ; 1C63 _ 84. C0
        jz      ?_150                                   ; 1C65 _ 74, 57
        mov     rax, qword [rel ofmt]                   ; 1C67 _ 48: 8B. 05, 00000000(rel)
        mov     rax, qword [rax+80H]                    ; 1C6E _ 48: 8B. 80, 00000080
        call    rax                                     ; 1C75 _ FF. D0
        call    cleanup_labels                          ; 1C77 _ E8, 00000000(PLT r)
        mov     rax, qword [rel ofile]                  ; 1C7C _ 48: 8B. 05, 00000000(rel)
        mov     rdi, rax                                ; 1C83 _ 48: 89. C7
        call    fflush                                  ; 1C86 _ E8, 00000000(PLT r)
        mov     rax, qword [rel ofile]                  ; 1C8B _ 48: 8B. 05, 00000000(rel)
        mov     rdi, rax                                ; 1C92 _ 48: 89. C7
        call    ferror                                  ; 1C95 _ E8, 00000000(PLT r)
        test    eax, eax                                ; 1C9A _ 85. C0
        jz      ?_150                                   ; 1C9C _ 74, 20
        mov     rax, qword [rbp-38H]                    ; 1C9E _ 48: 8B. 45, C8
        lea     rcx, [rel ?_550]                        ; 1CA2 _ 48: 8D. 0D, 00000000(rel)
        mov     rdx, rax                                ; 1CA9 _ 48: 89. C2
        mov     rsi, rcx                                ; 1CAC _ 48: 89. CE
        mov     edi, 8192                               ; 1CAF _ BF, 00002000
        mov     eax, 0                                  ; 1CB4 _ B8, 00000000
        call    nasm_nonfatalf                          ; 1CB9 _ E8, 00000000(PLT r)
?_150:  call    terminate_after_phase                   ; 1CBE _ E8, FFFFE656
        movzx   eax, al                                 ; 1CC3 _ 0F B6. C0
        mov     edi, eax                                ; 1CC6 _ 89. C7
        call    close_output                            ; 1CC8 _ E8, 00000000(PLT r)
?_151:  call    pp_cleanup_session                      ; 1CCD _ E8, 00000000(PLT r)
        mov     rax, qword [rel depend_list]            ; 1CD2 _ 48: 8B. 05, 00000000(rel)
        test    rax, rax                                ; 1CD9 _ 48: 85. C0
        jz      ?_152                                   ; 1CDC _ 74, 1B
        call    terminate_after_phase                   ; 1CDE _ E8, FFFFE636
        xor     eax, 01H                                ; 1CE3 _ 83. F0, 01
        test    al, al                                  ; 1CE6 _ 84. C0
        jz      ?_152                                   ; 1CE8 _ 74, 0F
        mov     rax, qword [rel depend_list]            ; 1CEA _ 48: 8B. 05, 00000000(rel)
        mov     rdi, rax                                ; 1CF1 _ 48: 89. C7
        call    emit_dependencies                       ; 1CF4 _ E8, FFFFF067
?_152:  mov     rax, qword [rel offsets]                ; 1CF9 _ 48: 8B. 05, 00000000(rel)
        mov     rdi, rax                                ; 1D00 _ 48: 89. C7
        call    raa_free                                ; 1D03 _ E8, 00000000(PLT r)
        mov     rax, qword [rel forwrefs]               ; 1D08 _ 48: 8B. 05, 00000000(rel)
        mov     rdi, rax                                ; 1D0F _ 48: 89. C7
        call    saa_free                                ; 1D12 _ E8, 00000000(PLT r)
        call    eval_cleanup                            ; 1D17 _ E8, 00000000(PLT r)
        call    stdscan_cleanup                         ; 1D1C _ E8, 00000000(PLT r)
        call    src_free                                ; 1D21 _ E8, 00000000(PLT r)
        lea     rax, [rel include_path]                 ; 1D26 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 1D2D _ 48: 89. C7
        call    strlist_free                            ; 1D30 _ E8, 00000000(PLT r)
        call    cleanup_filenames                       ; 1D35 _ E8, 00000000(PLT r)
        call    terminate_after_phase                   ; 1D3A _ E8, FFFFE5DA
        movzx   eax, al                                 ; 1D3F _ 0F B6. C0
?_153:  mov     rdx, qword [rbp-18H]                    ; 1D42 _ 48: 8B. 55, E8
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        sub     rdx, qword [fs:abs 28H]                 ; 1D46 _ 64 48: 2B. 14 25, 00000028
        jz      ?_154                                   ; 1D4F _ 74, 05
        call    __stack_chk_fail                        ; 1D51 _ E8, 00000000(PLT r)
?_154:  add     rsp, 112                                ; 1D56 _ 48: 83. C4, 70
        pop     rbx                                     ; 1D5A _ 5B
        pop     r12                                     ; 1D5B _ 41: 5C
        pop     rbp                                     ; 1D5D _ 5D
        ret                                             ; 1D5E _ C3
; main End of function

get_opt_param:; Local function
        push    rbp                                     ; 1D5F _ 55
        mov     rbp, rsp                                ; 1D60 _ 48: 89. E5
        sub     rsp, 32                                 ; 1D63 _ 48: 83. EC, 20
        mov     qword [rbp-8H], rdi                     ; 1D67 _ 48: 89. 7D, F8
        mov     qword [rbp-10H], rsi                    ; 1D6B _ 48: 89. 75, F0
        mov     qword [rbp-18H], rdx                    ; 1D6F _ 48: 89. 55, E8
        mov     rax, qword [rbp-18H]                    ; 1D73 _ 48: 8B. 45, E8
        mov     byte [rax], 0                           ; 1D77 _ C6. 00, 00
        mov     rax, qword [rbp-8H]                     ; 1D7A _ 48: 8B. 45, F8
        add     rax, 2                                  ; 1D7E _ 48: 83. C0, 02
        movzx   eax, byte [rax]                         ; 1D82 _ 0F B6. 00
        test    al, al                                  ; 1D85 _ 84. C0
        jz      ?_155                                   ; 1D87 _ 74, 12
        mov     rax, qword [rbp-8H]                     ; 1D89 _ 48: 8B. 45, F8
        add     rax, 2                                  ; 1D8D _ 48: 83. C0, 02
        mov     rdi, rax                                ; 1D91 _ 48: 89. C7
        call    nasm_skip_spaces                        ; 1D94 _ E8, 00000000(PLT r)
        jmp     ?_157                                   ; 1D99 _ EB, 24

?_155:  cmp     qword [rbp-10H], 0                      ; 1D9B _ 48: 83. 7D, F0, 00
        jz      ?_156                                   ; 1DA0 _ 74, 18
        mov     rax, qword [rbp-10H]                    ; 1DA2 _ 48: 8B. 45, F0
        movzx   eax, byte [rax]                         ; 1DA6 _ 0F B6. 00
        test    al, al                                  ; 1DA9 _ 84. C0
        jz      ?_156                                   ; 1DAB _ 74, 0D
        mov     rax, qword [rbp-18H]                    ; 1DAD _ 48: 8B. 45, E8
        mov     byte [rax], 1                           ; 1DB1 _ C6. 00, 01
        mov     rax, qword [rbp-10H]                    ; 1DB4 _ 48: 8B. 45, F0
        jmp     ?_157                                   ; 1DB8 _ EB, 05

?_156:  mov     eax, 0                                  ; 1DBA _ B8, 00000000
?_157:  leave                                           ; 1DBF _ C9
        ret                                             ; 1DC0 _ C3

get_param:; Local function
        push    rbp                                     ; 1DC1 _ 55
        mov     rbp, rsp                                ; 1DC2 _ 48: 89. E5
        sub     rsp, 48                                 ; 1DC5 _ 48: 83. EC, 30
        mov     qword [rbp-18H], rdi                    ; 1DC9 _ 48: 89. 7D, E8
        mov     qword [rbp-20H], rsi                    ; 1DCD _ 48: 89. 75, E0
        mov     qword [rbp-28H], rdx                    ; 1DD1 _ 48: 89. 55, D8
        mov     rdx, qword [rbp-28H]                    ; 1DD5 _ 48: 8B. 55, D8
        mov     rcx, qword [rbp-20H]                    ; 1DD9 _ 48: 8B. 4D, E0
        mov     rax, qword [rbp-18H]                    ; 1DDD _ 48: 8B. 45, E8
        mov     rsi, rcx                                ; 1DE1 _ 48: 89. CE
        mov     rdi, rax                                ; 1DE4 _ 48: 89. C7
        call    get_opt_param                           ; 1DE7 _ E8, FFFFFF73
        mov     qword [rbp-8H], rax                     ; 1DEC _ 48: 89. 45, F8
        cmp     qword [rbp-8H], 0                       ; 1DF0 _ 48: 83. 7D, F8, 00
        jnz     ?_158                                   ; 1DF5 _ 75, 29
        mov     rax, qword [rbp-18H]                    ; 1DF7 _ 48: 8B. 45, E8
        add     rax, 1                                  ; 1DFB _ 48: 83. C0, 01
        movzx   eax, byte [rax]                         ; 1DFF _ 0F B6. 00
        movsx   eax, al                                 ; 1E02 _ 0F BE. C0
        lea     rcx, [rel ?_551]                        ; 1E05 _ 48: 8D. 0D, 00000000(rel)
        mov     edx, eax                                ; 1E0C _ 89. C2
        mov     rsi, rcx                                ; 1E0E _ 48: 89. CE
        mov     edi, 128                                ; 1E11 _ BF, 00000080
        mov     eax, 0                                  ; 1E16 _ B8, 00000000
        call    nasm_nonfatalf                          ; 1E1B _ E8, 00000000(PLT r)
?_158:  mov     rax, qword [rbp-8H]                     ; 1E20 _ 48: 8B. 45, F8
        leave                                           ; 1E24 _ C9
        ret                                             ; 1E25 _ C3

debug_prefix_remap:; Local function
        push    rbp                                     ; 1E26 _ 55
        mov     rbp, rsp                                ; 1E27 _ 48: 89. E5
        sub     rsp, 64                                 ; 1E2A _ 48: 83. EC, 40
        mov     qword [rbp-38H], rdi                    ; 1E2E _ 48: 89. 7D, C8
        mov     rax, qword [rel debug_prefixes]         ; 1E32 _ 48: 8B. 05, 00000000(rel)
        mov     qword [rbp-30H], rax                    ; 1E39 _ 48: 89. 45, D0
        jmp     ?_161                                   ; 1E3D _ E9, 000000D8

?_159:  mov     rax, qword [rbp-30H]                    ; 1E42 _ 48: 8B. 45, D0
        mov     rax, qword [rax+8H]                     ; 1E46 _ 48: 8B. 40, 08
        mov     rdi, rax                                ; 1E4A _ 48: 89. C7
        call    strlen                                  ; 1E4D _ E8, 00000000(PLT r)
        mov     qword [rbp-28H], rax                    ; 1E52 _ 48: 89. 45, D8
        mov     rax, qword [rbp-30H]                    ; 1E56 _ 48: 8B. 45, D0
        mov     rcx, qword [rax+8H]                     ; 1E5A _ 48: 8B. 48, 08
        mov     rdx, qword [rbp-28H]                    ; 1E5E _ 48: 8B. 55, D8
        mov     rax, qword [rbp-38H]                    ; 1E62 _ 48: 8B. 45, C8
        mov     rsi, rcx                                ; 1E66 _ 48: 89. CE
        mov     rdi, rax                                ; 1E69 _ 48: 89. C7
        call    strncmp                                 ; 1E6C _ E8, 00000000(PLT r)
        test    eax, eax                                ; 1E71 _ 85. C0
        jne     ?_160                                   ; 1E73 _ 0F 85, 00000096
        mov     rax, qword [rbp-30H]                    ; 1E79 _ 48: 8B. 45, D0
        mov     rax, qword [rax+10H]                    ; 1E7D _ 48: 8B. 40, 10
        mov     rdi, rax                                ; 1E81 _ 48: 89. C7
        call    strlen                                  ; 1E84 _ E8, 00000000(PLT r)
        mov     qword [rbp-20H], rax                    ; 1E89 _ 48: 89. 45, E0
        mov     rax, qword [rbp-38H]                    ; 1E8D _ 48: 8B. 45, C8
        mov     rdi, rax                                ; 1E91 _ 48: 89. C7
        call    strlen                                  ; 1E94 _ E8, 00000000(PLT r)
        sub     rax, qword [rbp-28H]                    ; 1E99 _ 48: 2B. 45, D8
        mov     qword [rbp-18H], rax                    ; 1E9D _ 48: 89. 45, E8
        mov     rdx, qword [rbp-20H]                    ; 1EA1 _ 48: 8B. 55, E0
        mov     rax, qword [rbp-18H]                    ; 1EA5 _ 48: 8B. 45, E8
        add     rax, rdx                                ; 1EA9 _ 48: 01. D0
        add     rax, 1                                  ; 1EAC _ 48: 83. C0, 01
        mov     qword [rbp-10H], rax                    ; 1EB0 _ 48: 89. 45, F0
        mov     rax, qword [rbp-10H]                    ; 1EB4 _ 48: 8B. 45, F0
        mov     rdi, rax                                ; 1EB8 _ 48: 89. C7
        call    nasm_malloc                             ; 1EBB _ E8, 00000000(PLT r)
        mov     qword [rbp-8H], rax                     ; 1EC0 _ 48: 89. 45, F8
        mov     rax, qword [rbp-30H]                    ; 1EC4 _ 48: 8B. 45, D0
        mov     rcx, qword [rax+10H]                    ; 1EC8 _ 48: 8B. 48, 10
        mov     rdx, qword [rbp-10H]                    ; 1ECC _ 48: 8B. 55, F0
        mov     rax, qword [rbp-8H]                     ; 1ED0 _ 48: 8B. 45, F8
        mov     rsi, rcx                                ; 1ED4 _ 48: 89. CE
        mov     rdi, rax                                ; 1ED7 _ 48: 89. C7
        call    strlcpy                                 ; 1EDA _ E8, 00000000(PLT r)
        mov     rax, qword [rbp-10H]                    ; 1EDF _ 48: 8B. 45, F0
        sub     rax, qword [rbp-20H]                    ; 1EE3 _ 48: 2B. 45, E0
        mov     rcx, qword [rbp-38H]                    ; 1EE7 _ 48: 8B. 4D, C8
        mov     rdx, qword [rbp-28H]                    ; 1EEB _ 48: 8B. 55, D8
        lea     rsi, [rcx+rdx]                          ; 1EEF _ 48: 8D. 34 11
        mov     rcx, qword [rbp-8H]                     ; 1EF3 _ 48: 8B. 4D, F8
        mov     rdx, qword [rbp-20H]                    ; 1EF7 _ 48: 8B. 55, E0
        add     rcx, rdx                                ; 1EFB _ 48: 01. D1
        mov     rdx, rax                                ; 1EFE _ 48: 89. C2
        mov     rdi, rcx                                ; 1F01 _ 48: 89. CF
        call    strlcpy                                 ; 1F04 _ E8, 00000000(PLT r)
        mov     rax, qword [rbp-8H]                     ; 1F09 _ 48: 8B. 45, F8
        jmp     ?_162                                   ; 1F0D _ EB, 22

?_160:  mov     rax, qword [rbp-30H]                    ; 1F0F _ 48: 8B. 45, D0
        mov     rax, qword [rax]                        ; 1F13 _ 48: 8B. 00
        mov     qword [rbp-30H], rax                    ; 1F16 _ 48: 89. 45, D0
?_161:  cmp     qword [rbp-30H], 0                      ; 1F1A _ 48: 83. 7D, D0, 00
        jne     ?_159                                   ; 1F1F _ 0F 85, FFFFFF1D
        mov     rax, qword [rbp-38H]                    ; 1F25 _ 48: 8B. 45, C8
        mov     rdi, rax                                ; 1F29 _ 48: 89. C7
        call    nasm_strdup                             ; 1F2C _ E8, 00000000(PLT r)
?_162:  leave                                           ; 1F31 _ C9
        ret                                             ; 1F32 _ C3

quote_for_pmake:; Local function
        push    rbp                                     ; 1F33 _ 55
        mov     rbp, rsp                                ; 1F34 _ 48: 89. E5
        sub     rsp, 64                                 ; 1F37 _ 48: 83. EC, 40
        mov     qword [rbp-38H], rdi                    ; 1F3B _ 48: 89. 7D, C8
        mov     qword [rbp-18H], 1                      ; 1F3F _ 48: C7. 45, E8, 00000001
        mov     qword [rbp-10H], 0                      ; 1F47 _ 48: C7. 45, F0, 00000000
        cmp     qword [rbp-38H], 0                      ; 1F4F _ 48: 83. 7D, C8, 00
        jnz     ?_163                                   ; 1F54 _ 75, 0A
        mov     eax, 0                                  ; 1F56 _ B8, 00000000
        jmp     ?_179                                   ; 1F5B _ E9, 00000225

?_163:  mov     rax, qword [rbp-38H]                    ; 1F60 _ 48: 8B. 45, C8
        mov     qword [rbp-28H], rax                    ; 1F64 _ 48: 89. 45, D8
        jmp     ?_170                                   ; 1F68 _ EB, 73

?_164:  mov     rax, qword [rbp-28H]                    ; 1F6A _ 48: 8B. 45, D8
        movzx   eax, byte [rax]                         ; 1F6E _ 0F B6. 00
        movsx   eax, al                                 ; 1F71 _ 0F BE. C0
        cmp     eax, 92                                 ; 1F74 _ 83. F8, 5C
        jz      ?_167                                   ; 1F77 _ 74, 45
        cmp     eax, 92                                 ; 1F79 _ 83. F8, 5C
        jg      ?_168                                   ; 1F7C _ 7F, 4C
        cmp     eax, 36                                 ; 1F7E _ 83. F8, 24
        jg      ?_168                                   ; 1F81 _ 7F, 47
        cmp     eax, 35                                 ; 1F83 _ 83. F8, 23
        jge     ?_166                                   ; 1F86 _ 7D, 27
        cmp     eax, 9                                  ; 1F88 _ 83. F8, 09
        jz      ?_165                                   ; 1F8B _ 74, 05
        cmp     eax, 32                                 ; 1F8D _ 83. F8, 20
        jnz     ?_168                                   ; 1F90 _ 75, 38
?_165:  mov     rdx, qword [rbp-10H]                    ; 1F92 _ 48: 8B. 55, F0
        mov     rax, qword [rbp-18H]                    ; 1F96 _ 48: 8B. 45, E8
        add     rax, rdx                                ; 1F9A _ 48: 01. D0
        add     rax, 2                                  ; 1F9D _ 48: 83. C0, 02
        mov     qword [rbp-18H], rax                    ; 1FA1 _ 48: 89. 45, E8
        mov     qword [rbp-10H], 0                      ; 1FA5 _ 48: C7. 45, F0, 00000000
        jmp     ?_169                                   ; 1FAD _ EB, 29

?_166:  mov     qword [rbp-10H], 0                      ; 1FAF _ 48: C7. 45, F0, 00000000
        add     qword [rbp-18H], 2                      ; 1FB7 _ 48: 83. 45, E8, 02
        jmp     ?_169                                   ; 1FBC _ EB, 1A

?_167:  add     qword [rbp-10H], 1                      ; 1FBE _ 48: 83. 45, F0, 01
        add     qword [rbp-18H], 1                      ; 1FC3 _ 48: 83. 45, E8, 01
        jmp     ?_169                                   ; 1FC8 _ EB, 0E

?_168:  mov     qword [rbp-10H], 0                      ; 1FCA _ 48: C7. 45, F0, 00000000
        add     qword [rbp-18H], 1                      ; 1FD2 _ 48: 83. 45, E8, 01
        nop                                             ; 1FD7 _ 90
?_169:  add     qword [rbp-28H], 1                      ; 1FD8 _ 48: 83. 45, D8, 01
?_170:  mov     rax, qword [rbp-28H]                    ; 1FDD _ 48: 8B. 45, D8
        movzx   eax, byte [rax]                         ; 1FE1 _ 0F B6. 00
        test    al, al                                  ; 1FE4 _ 84. C0
        jnz     ?_164                                   ; 1FE6 _ 75, 82
        mov     rax, qword [rbp-10H]                    ; 1FE8 _ 48: 8B. 45, F0
        add     qword [rbp-18H], rax                    ; 1FEC _ 48: 01. 45, E8
        mov     rax, qword [rbp-18H]                    ; 1FF0 _ 48: 8B. 45, E8
        mov     rdi, rax                                ; 1FF4 _ 48: 89. C7
        call    nasm_malloc                             ; 1FF7 _ E8, 00000000(PLT r)
        mov     qword [rbp-20H], rax                    ; 1FFC _ 48: 89. 45, E0
        mov     rax, qword [rbp-20H]                    ; 2000 _ 48: 8B. 45, E0
        mov     qword [rbp-8H], rax                     ; 2004 _ 48: 89. 45, F8
        mov     qword [rbp-10H], 0                      ; 2008 _ 48: C7. 45, F0, 00000000
        mov     rax, qword [rbp-38H]                    ; 2010 _ 48: 8B. 45, C8
        mov     qword [rbp-28H], rax                    ; 2014 _ 48: 89. 45, D8
        jmp     ?_178                                   ; 2018 _ E9, 00000135

?_171:  mov     rax, qword [rbp-28H]                    ; 201D _ 48: 8B. 45, D8
        movzx   eax, byte [rax]                         ; 2021 _ 0F B6. 00
        movsx   eax, al                                 ; 2024 _ 0F BE. C0
        cmp     eax, 92                                 ; 2027 _ 83. F8, 5C
        je      ?_175                                   ; 202A _ 0F 84, 000000E3
        cmp     eax, 92                                 ; 2030 _ 83. F8, 5C
        jg      ?_176                                   ; 2033 _ 0F 8F, 000000F6
        cmp     eax, 36                                 ; 2039 _ 83. F8, 24
        jz      ?_173                                   ; 203C _ 74, 73
        cmp     eax, 36                                 ; 203E _ 83. F8, 24
        jg      ?_176                                   ; 2041 _ 0F 8F, 000000E8
        cmp     eax, 35                                 ; 2047 _ 83. F8, 23
        je      ?_174                                   ; 204A _ 0F 84, 00000095
        cmp     eax, 35                                 ; 2050 _ 83. F8, 23
        jg      ?_176                                   ; 2053 _ 0F 8F, 000000D6
        cmp     eax, 9                                  ; 2059 _ 83. F8, 09
        jz      ?_172                                   ; 205C _ 74, 09
        cmp     eax, 32                                 ; 205E _ 83. F8, 20
        jne     ?_176                                   ; 2061 _ 0F 85, 000000C8
?_172:  mov     rdx, qword [rbp-10H]                    ; 2067 _ 48: 8B. 55, F0
        mov     rax, qword [rbp-20H]                    ; 206B _ 48: 8B. 45, E0
        mov     esi, 92                                 ; 206F _ BE, 0000005C
        mov     rdi, rax                                ; 2074 _ 48: 89. C7
        call    mempset                                 ; 2077 _ E8, FFFFDF84
        mov     qword [rbp-20H], rax                    ; 207C _ 48: 89. 45, E0
        mov     rax, qword [rbp-20H]                    ; 2080 _ 48: 8B. 45, E0
        lea     rdx, [rax+1H]                           ; 2084 _ 48: 8D. 50, 01
        mov     qword [rbp-20H], rdx                    ; 2088 _ 48: 89. 55, E0
        mov     byte [rax], 92                          ; 208C _ C6. 00, 5C
        mov     rax, qword [rbp-20H]                    ; 208F _ 48: 8B. 45, E0
        lea     rdx, [rax+1H]                           ; 2093 _ 48: 8D. 50, 01
        mov     qword [rbp-20H], rdx                    ; 2097 _ 48: 89. 55, E0
        mov     rdx, qword [rbp-28H]                    ; 209B _ 48: 8B. 55, D8
        movzx   edx, byte [rdx]                         ; 209F _ 0F B6. 12
        mov     byte [rax], dl                          ; 20A2 _ 88. 10
        mov     qword [rbp-10H], 0                      ; 20A4 _ 48: C7. 45, F0, 00000000
        jmp     ?_177                                   ; 20AC _ E9, 0000009C

?_173:  mov     rax, qword [rbp-20H]                    ; 20B1 _ 48: 8B. 45, E0
        lea     rdx, [rax+1H]                           ; 20B5 _ 48: 8D. 50, 01
        mov     qword [rbp-20H], rdx                    ; 20B9 _ 48: 89. 55, E0
        mov     rdx, qword [rbp-28H]                    ; 20BD _ 48: 8B. 55, D8
        movzx   edx, byte [rdx]                         ; 20C1 _ 0F B6. 12
        mov     byte [rax], dl                          ; 20C4 _ 88. 10
        mov     rax, qword [rbp-20H]                    ; 20C6 _ 48: 8B. 45, E0
        lea     rdx, [rax+1H]                           ; 20CA _ 48: 8D. 50, 01
        mov     qword [rbp-20H], rdx                    ; 20CE _ 48: 89. 55, E0
        mov     rdx, qword [rbp-28H]                    ; 20D2 _ 48: 8B. 55, D8
        movzx   edx, byte [rdx]                         ; 20D6 _ 0F B6. 12
        mov     byte [rax], dl                          ; 20D9 _ 88. 10
        mov     qword [rbp-10H], 0                      ; 20DB _ 48: C7. 45, F0, 00000000
        jmp     ?_177                                   ; 20E3 _ EB, 68

?_174:  mov     rax, qword [rbp-20H]                    ; 20E5 _ 48: 8B. 45, E0
        lea     rdx, [rax+1H]                           ; 20E9 _ 48: 8D. 50, 01
        mov     qword [rbp-20H], rdx                    ; 20ED _ 48: 89. 55, E0
        mov     byte [rax], 92                          ; 20F1 _ C6. 00, 5C
        mov     rax, qword [rbp-20H]                    ; 20F4 _ 48: 8B. 45, E0
        lea     rdx, [rax+1H]                           ; 20F8 _ 48: 8D. 50, 01
        mov     qword [rbp-20H], rdx                    ; 20FC _ 48: 89. 55, E0
        mov     rdx, qword [rbp-28H]                    ; 2100 _ 48: 8B. 55, D8
        movzx   edx, byte [rdx]                         ; 2104 _ 0F B6. 12
        mov     byte [rax], dl                          ; 2107 _ 88. 10
        mov     qword [rbp-10H], 0                      ; 2109 _ 48: C7. 45, F0, 00000000
        jmp     ?_177                                   ; 2111 _ EB, 3A

?_175:  mov     rax, qword [rbp-20H]                    ; 2113 _ 48: 8B. 45, E0
        lea     rdx, [rax+1H]                           ; 2117 _ 48: 8D. 50, 01
        mov     qword [rbp-20H], rdx                    ; 211B _ 48: 89. 55, E0
        mov     rdx, qword [rbp-28H]                    ; 211F _ 48: 8B. 55, D8
        movzx   edx, byte [rdx]                         ; 2123 _ 0F B6. 12
        mov     byte [rax], dl                          ; 2126 _ 88. 10
        add     qword [rbp-10H], 1                      ; 2128 _ 48: 83. 45, F0, 01
        jmp     ?_177                                   ; 212D _ EB, 1E

?_176:  mov     rax, qword [rbp-20H]                    ; 212F _ 48: 8B. 45, E0
        lea     rdx, [rax+1H]                           ; 2133 _ 48: 8D. 50, 01
        mov     qword [rbp-20H], rdx                    ; 2137 _ 48: 89. 55, E0
        mov     rdx, qword [rbp-28H]                    ; 213B _ 48: 8B. 55, D8
        movzx   edx, byte [rdx]                         ; 213F _ 0F B6. 12
        mov     byte [rax], dl                          ; 2142 _ 88. 10
        mov     qword [rbp-10H], 0                      ; 2144 _ 48: C7. 45, F0, 00000000
        nop                                             ; 214C _ 90
?_177:  add     qword [rbp-28H], 1                      ; 214D _ 48: 83. 45, D8, 01
?_178:  mov     rax, qword [rbp-28H]                    ; 2152 _ 48: 8B. 45, D8
        movzx   eax, byte [rax]                         ; 2156 _ 0F B6. 00
        test    al, al                                  ; 2159 _ 84. C0
        jne     ?_171                                   ; 215B _ 0F 85, FFFFFEBC
        mov     rdx, qword [rbp-10H]                    ; 2161 _ 48: 8B. 55, F0
        mov     rax, qword [rbp-20H]                    ; 2165 _ 48: 8B. 45, E0
        mov     esi, 92                                 ; 2169 _ BE, 0000005C
        mov     rdi, rax                                ; 216E _ 48: 89. C7
        call    mempset                                 ; 2171 _ E8, FFFFDE8A
        mov     qword [rbp-20H], rax                    ; 2176 _ 48: 89. 45, E0
        mov     rax, qword [rbp-20H]                    ; 217A _ 48: 8B. 45, E0
        mov     byte [rax], 0                           ; 217E _ C6. 00, 00
        mov     rax, qword [rbp-8H]                     ; 2181 _ 48: 8B. 45, F8
?_179:  leave                                           ; 2185 _ C9
        ret                                             ; 2186 _ C3

quote_for_wmake:; Local function
        push    rbp                                     ; 2187 _ 55
        mov     rbp, rsp                                ; 2188 _ 48: 89. E5
        sub     rsp, 64                                 ; 218B _ 48: 83. EC, 40
        mov     qword [rbp-38H], rdi                    ; 218F _ 48: 89. 7D, C8
        mov     byte [rbp-21H], 0                       ; 2193 _ C6. 45, DF, 00
        mov     qword [rbp-10H], 1                      ; 2197 _ 48: C7. 45, F0, 00000001
        cmp     qword [rbp-38H], 0                      ; 219F _ 48: 83. 7D, C8, 00
        jnz     ?_180                                   ; 21A4 _ 75, 0A
        mov     eax, 0                                  ; 21A6 _ B8, 00000000
        jmp     ?_196                                   ; 21AB _ E9, 0000016C

?_180:  mov     rax, qword [rbp-38H]                    ; 21B0 _ 48: 8B. 45, C8
        mov     qword [rbp-20H], rax                    ; 21B4 _ 48: 89. 45, E0
        jmp     ?_187                                   ; 21B8 _ EB, 5A

?_181:  mov     rax, qword [rbp-20H]                    ; 21BA _ 48: 8B. 45, E0
        movzx   eax, byte [rax]                         ; 21BE _ 0F B6. 00
        movsx   eax, al                                 ; 21C1 _ 0F BE. C0
        cmp     eax, 38                                 ; 21C4 _ 83. F8, 26
        jz      ?_182                                   ; 21C7 _ 74, 23
        cmp     eax, 38                                 ; 21C9 _ 83. F8, 26
        jg      ?_185                                   ; 21CC _ 7F, 3B
        cmp     eax, 36                                 ; 21CE _ 83. F8, 24
        jg      ?_185                                   ; 21D1 _ 7F, 36
        cmp     eax, 35                                 ; 21D3 _ 83. F8, 23
        jge     ?_184                                   ; 21D6 _ 7D, 2A
        cmp     eax, 34                                 ; 21D8 _ 83. F8, 22
        jz      ?_183                                   ; 21DB _ 74, 1A
        cmp     eax, 34                                 ; 21DD _ 83. F8, 22
        jg      ?_185                                   ; 21E0 _ 7F, 27
        cmp     eax, 9                                  ; 21E2 _ 83. F8, 09
        jz      ?_182                                   ; 21E5 _ 74, 05
        cmp     eax, 32                                 ; 21E7 _ 83. F8, 20
        jnz     ?_185                                   ; 21EA _ 75, 1D
?_182:  mov     byte [rbp-21H], 1                       ; 21EC _ C6. 45, DF, 01
        add     qword [rbp-10H], 1                      ; 21F0 _ 48: 83. 45, F0, 01
        jmp     ?_186                                   ; 21F5 _ EB, 18

?_183:  mov     byte [rbp-21H], 1                       ; 21F7 _ C6. 45, DF, 01
        add     qword [rbp-10H], 2                      ; 21FB _ 48: 83. 45, F0, 02
        jmp     ?_186                                   ; 2200 _ EB, 0D

?_184:  add     qword [rbp-10H], 2                      ; 2202 _ 48: 83. 45, F0, 02
        jmp     ?_186                                   ; 2207 _ EB, 06

?_185:  add     qword [rbp-10H], 1                      ; 2209 _ 48: 83. 45, F0, 01
        nop                                             ; 220E _ 90
?_186:  add     qword [rbp-20H], 1                      ; 220F _ 48: 83. 45, E0, 01
?_187:  mov     rax, qword [rbp-20H]                    ; 2214 _ 48: 8B. 45, E0
        movzx   eax, byte [rax]                         ; 2218 _ 0F B6. 00
        test    al, al                                  ; 221B _ 84. C0
        jnz     ?_181                                   ; 221D _ 75, 9B
        cmp     byte [rbp-21H], 0                       ; 221F _ 80. 7D, DF, 00
        jz      ?_188                                   ; 2223 _ 74, 05
        add     qword [rbp-10H], 2                      ; 2225 _ 48: 83. 45, F0, 02
?_188:  mov     rax, qword [rbp-10H]                    ; 222A _ 48: 8B. 45, F0
        mov     rdi, rax                                ; 222E _ 48: 89. C7
        call    nasm_malloc                             ; 2231 _ E8, 00000000(PLT r)
        mov     qword [rbp-18H], rax                    ; 2236 _ 48: 89. 45, E8
        mov     rax, qword [rbp-18H]                    ; 223A _ 48: 8B. 45, E8
        mov     qword [rbp-8H], rax                     ; 223E _ 48: 89. 45, F8
        cmp     byte [rbp-21H], 0                       ; 2242 _ 80. 7D, DF, 00
        jz      ?_189                                   ; 2246 _ 74, 0F
        mov     rax, qword [rbp-18H]                    ; 2248 _ 48: 8B. 45, E8
        lea     rdx, [rax+1H]                           ; 224C _ 48: 8D. 50, 01
        mov     qword [rbp-18H], rdx                    ; 2250 _ 48: 89. 55, E8
        mov     byte [rax], 34                          ; 2254 _ C6. 00, 22
?_189:  mov     rax, qword [rbp-38H]                    ; 2257 _ 48: 8B. 45, C8
        mov     qword [rbp-20H], rax                    ; 225B _ 48: 89. 45, E0
        jmp     ?_194                                   ; 225F _ E9, 00000089

?_190:  mov     rax, qword [rbp-20H]                    ; 2264 _ 48: 8B. 45, E0
        movzx   eax, byte [rax]                         ; 2268 _ 0F B6. 00
        movsx   eax, al                                 ; 226B _ 0F BE. C0
        cmp     eax, 34                                 ; 226E _ 83. F8, 22
        jz      ?_191                                   ; 2271 _ 74, 33
        cmp     eax, 34                                 ; 2273 _ 83. F8, 22
        jl      ?_192                                   ; 2276 _ 7C, 5A
        sub     eax, 35                                 ; 2278 _ 83. E8, 23
        cmp     eax, 1                                  ; 227B _ 83. F8, 01
        ja      ?_192                                   ; 227E _ 77, 52
        mov     rax, qword [rbp-18H]                    ; 2280 _ 48: 8B. 45, E8
        lea     rdx, [rax+1H]                           ; 2284 _ 48: 8D. 50, 01
        mov     qword [rbp-18H], rdx                    ; 2288 _ 48: 89. 55, E8
        mov     byte [rax], 36                          ; 228C _ C6. 00, 24
        mov     rax, qword [rbp-18H]                    ; 228F _ 48: 8B. 45, E8
        lea     rdx, [rax+1H]                           ; 2293 _ 48: 8D. 50, 01
        mov     qword [rbp-18H], rdx                    ; 2297 _ 48: 89. 55, E8
        mov     rdx, qword [rbp-20H]                    ; 229B _ 48: 8B. 55, E0
        movzx   edx, byte [rdx]                         ; 229F _ 0F B6. 12
        mov     byte [rax], dl                          ; 22A2 _ 88. 10
        jmp     ?_193                                   ; 22A4 _ EB, 42

?_191:  mov     rax, qword [rbp-18H]                    ; 22A6 _ 48: 8B. 45, E8
        lea     rdx, [rax+1H]                           ; 22AA _ 48: 8D. 50, 01
        mov     qword [rbp-18H], rdx                    ; 22AE _ 48: 89. 55, E8
        mov     rdx, qword [rbp-20H]                    ; 22B2 _ 48: 8B. 55, E0
        movzx   edx, byte [rdx]                         ; 22B6 _ 0F B6. 12
        mov     byte [rax], dl                          ; 22B9 _ 88. 10
        mov     rax, qword [rbp-18H]                    ; 22BB _ 48: 8B. 45, E8
        lea     rdx, [rax+1H]                           ; 22BF _ 48: 8D. 50, 01
        mov     qword [rbp-18H], rdx                    ; 22C3 _ 48: 89. 55, E8
        mov     rdx, qword [rbp-20H]                    ; 22C7 _ 48: 8B. 55, E0
        movzx   edx, byte [rdx]                         ; 22CB _ 0F B6. 12
        mov     byte [rax], dl                          ; 22CE _ 88. 10
        jmp     ?_193                                   ; 22D0 _ EB, 16

?_192:  mov     rax, qword [rbp-18H]                    ; 22D2 _ 48: 8B. 45, E8
        lea     rdx, [rax+1H]                           ; 22D6 _ 48: 8D. 50, 01
        mov     qword [rbp-18H], rdx                    ; 22DA _ 48: 89. 55, E8
        mov     rdx, qword [rbp-20H]                    ; 22DE _ 48: 8B. 55, E0
        movzx   edx, byte [rdx]                         ; 22E2 _ 0F B6. 12
        mov     byte [rax], dl                          ; 22E5 _ 88. 10
        nop                                             ; 22E7 _ 90
?_193:  add     qword [rbp-20H], 1                      ; 22E8 _ 48: 83. 45, E0, 01
?_194:  mov     rax, qword [rbp-20H]                    ; 22ED _ 48: 8B. 45, E0
        movzx   eax, byte [rax]                         ; 22F1 _ 0F B6. 00
        test    al, al                                  ; 22F4 _ 84. C0
        jne     ?_190                                   ; 22F6 _ 0F 85, FFFFFF68
        cmp     byte [rbp-21H], 0                       ; 22FC _ 80. 7D, DF, 00
        jz      ?_195                                   ; 2300 _ 74, 0F
        mov     rax, qword [rbp-18H]                    ; 2302 _ 48: 8B. 45, E8
        lea     rdx, [rax+1H]                           ; 2306 _ 48: 8D. 50, 01
        mov     qword [rbp-18H], rdx                    ; 230A _ 48: 89. 55, E8
        mov     byte [rax], 34                          ; 230E _ C6. 00, 22
?_195:  mov     rax, qword [rbp-18H]                    ; 2311 _ 48: 8B. 45, E8
        mov     byte [rax], 0                           ; 2315 _ C6. 00, 00
        mov     rax, qword [rbp-8H]                     ; 2318 _ 48: 8B. 45, F8
?_196:  leave                                           ; 231C _ C9
        ret                                             ; 231D _ C3

show_version:; Local function
        push    rbp                                     ; 231E _ 55
        mov     rbp, rsp                                ; 231F _ 48: 89. E5
        lea     rcx, [rel nasm_compile_options]         ; 2322 _ 48: 8D. 0D, 00000000(rel)
        lea     rdx, [rel nasm_date]                    ; 2329 _ 48: 8D. 15, 00000000(rel)
        lea     rsi, [rel nasm_version]                 ; 2330 _ 48: 8D. 35, 00000000(rel)
        lea     rax, [rel ?_553]                        ; 2337 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 233E _ 48: 89. C7
        mov     eax, 0                                  ; 2341 _ B8, 00000000
        call    printf                                  ; 2346 _ E8, 00000000(PLT r)
        mov     edi, 0                                  ; 234B _ BF, 00000000
        call    exit                                    ; 2350 _ E8, 00000000(PLT r)
process_arg:
        push    rbp                                     ; 2355 _ 55
        mov     rbp, rsp                                ; 2356 _ 48: 89. E5
        add     rsp, -128                               ; 2359 _ 48: 83. C4, 80
        mov     qword [rbp-68H], rdi                    ; 235D _ 48: 89. 7D, 98
        mov     qword [rbp-70H], rsi                    ; 2361 _ 48: 89. 75, 90
        mov     dword [rbp-74H], edx                    ; 2365 _ 89. 55, 8C
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        mov     rax, qword [fs:abs 28H]                 ; 2368 _ 64 48: 8B. 04 25, 00000028
        mov     qword [rbp-8H], rax                     ; 2371 _ 48: 89. 45, F8
        xor     eax, eax                                ; 2375 _ 31. C0
        mov     byte [rbp-51H], 0                       ; 2377 _ C6. 45, AF, 00
        cmp     qword [rbp-68H], 0                      ; 237B _ 48: 83. 7D, 98, 00
        jz      ?_197                                   ; 2380 _ 74, 0B
        mov     rax, qword [rbp-68H]                    ; 2382 _ 48: 8B. 45, 98
        movzx   eax, byte [rax]                         ; 2386 _ 0F B6. 00
        test    al, al                                  ; 2389 _ 84. C0
        jnz     ?_198                                   ; 238B _ 75, 0A
?_197:  mov     eax, 0                                  ; 238D _ B8, 00000000
        jmp     ?_323                                   ; 2392 _ E9, 00000FAC

?_198:  mov     rax, qword [rbp-68H]                    ; 2397 _ 48: 8B. 45, 98
        movzx   eax, byte [rax]                         ; 239B _ 0F B6. 00
        cmp     al, 45                                  ; 239E _ 3C, 2D
        jne     ?_321                                   ; 23A0 _ 0F 85, 00000F82
        movzx   eax, byte [rel stopoptions]             ; 23A6 _ 0F B6. 05, 00000000(rel)
        xor     eax, 01H                                ; 23AD _ 83. F0, 01
        test    al, al                                  ; 23B0 _ 84. C0
        je      ?_321                                   ; 23B2 _ 0F 84, 00000F70
        mov     rax, qword [rbp-68H]                    ; 23B8 _ 48: 8B. 45, 98
        add     rax, 1                                  ; 23BC _ 48: 83. C0, 01
        movzx   eax, byte [rax]                         ; 23C0 _ 0F B6. 00
        movsx   eax, al                                 ; 23C3 _ 0F BE. C0
        lea     rdx, [rel ?_554]                        ; 23C6 _ 48: 8D. 15, 00000000(rel)
        mov     esi, eax                                ; 23CD _ 89. C6
        mov     rdi, rdx                                ; 23CF _ 48: 89. D7
        call    strchr                                  ; 23D2 _ E8, 00000000(PLT r)
        test    rax, rax                                ; 23D7 _ 48: 85. C0
        jz      ?_199                                   ; 23DA _ 74, 2D
        lea     rdx, [rbp-51H]                          ; 23DC _ 48: 8D. 55, AF
        mov     rcx, qword [rbp-70H]                    ; 23E0 _ 48: 8B. 4D, 90
        mov     rax, qword [rbp-68H]                    ; 23E4 _ 48: 8B. 45, 98
        mov     rsi, rcx                                ; 23E8 _ 48: 89. CE
        mov     rdi, rax                                ; 23EB _ 48: 89. C7
        call    get_param                               ; 23EE _ E8, FFFFF9CE
        mov     qword [rbp-48H], rax                    ; 23F3 _ 48: 89. 45, B8
        mov     rax, qword [rbp-48H]                    ; 23F7 _ 48: 8B. 45, B8
        test    rax, rax                                ; 23FB _ 48: 85. C0
        jnz     ?_199                                   ; 23FE _ 75, 09
        movzx   eax, byte [rbp-51H]                     ; 2400 _ 0F B6. 45, AF
        jmp     ?_323                                   ; 2404 _ E9, 00000F3A

?_199:  mov     rax, qword [rbp-68H]                    ; 2409 _ 48: 8B. 45, 98
        add     rax, 1                                  ; 240D _ 48: 83. C0, 01
        movzx   eax, byte [rax]                         ; 2411 _ 0F B6. 00
        movsx   eax, al                                 ; 2414 _ 0F BE. C0
        cmp     eax, 121                                ; 2417 _ 83. F8, 79
        je      ?_227                                   ; 241A _ 0F 84, 00000603
        cmp     eax, 121                                ; 2420 _ 83. F8, 79
        jg      ?_299                                   ; 2423 _ 0F 8F, 00000E98
        cmp     eax, 119                                ; 2429 _ 83. F8, 77
        je      ?_232                                   ; 242C _ 0F 84, 0000066B
        cmp     eax, 119                                ; 2432 _ 83. F8, 77
        jg      ?_299                                   ; 2435 _ 0F 8F, 00000E86
        cmp     eax, 118                                ; 243B _ 83. F8, 76
        je      ?_229                                   ; 243E _ 0F 84, 00000618
        cmp     eax, 118                                ; 2444 _ 83. F8, 76
        jg      ?_299                                   ; 2447 _ 0F 8F, 00000E74
        cmp     eax, 117                                ; 244D _ 83. F8, 75
        je      ?_216                                   ; 2450 _ 0F 84, 000003E6
        cmp     eax, 117                                ; 2456 _ 83. F8, 75
        jg      ?_299                                   ; 2459 _ 0F 8F, 00000E62
        cmp     eax, 116                                ; 245F _ 83. F8, 74
        je      ?_228                                   ; 2462 _ 0F 84, 000005DE
        cmp     eax, 116                                ; 2468 _ 83. F8, 74
        jg      ?_299                                   ; 246B _ 0F 8F, 00000E50
        cmp     eax, 115                                ; 2471 _ 83. F8, 73
        je      ?_201                                   ; 2474 _ 0F 84, 000001D0
        cmp     eax, 115                                ; 247A _ 83. F8, 73
        jg      ?_299                                   ; 247D _ 0F 8F, 00000E3E
        cmp     eax, 112                                ; 2483 _ 83. F8, 70
        je      ?_214                                   ; 2486 _ 0F 84, 0000037A
        cmp     eax, 112                                ; 248C _ 83. F8, 70
        jg      ?_299                                   ; 248F _ 0F 8F, 00000E2C
        cmp     eax, 111                                ; 2495 _ 83. F8, 6F
        je      ?_202                                   ; 2498 _ 0F 84, 000001C9
        cmp     eax, 111                                ; 249E _ 83. F8, 6F
        jg      ?_299                                   ; 24A1 _ 0F 8F, 00000E1A
        cmp     eax, 108                                ; 24A7 _ 83. F8, 6C
        je      ?_218                                   ; 24AA _ 0F 84, 000003CC
        cmp     eax, 108                                ; 24B0 _ 83. F8, 6C
        jg      ?_299                                   ; 24B3 _ 0F 8F, 00000E08
        cmp     eax, 105                                ; 24B9 _ 83. F8, 69
        je      ?_217                                   ; 24BC _ 0F 84, 00000395
        cmp     eax, 105                                ; 24C2 _ 83. F8, 69
        jg      ?_299                                   ; 24C5 _ 0F 8F, 00000DF6
        cmp     eax, 104                                ; 24CB _ 83. F8, 68
        je      ?_226                                   ; 24CE _ 0F 84, 00000519
        cmp     eax, 104                                ; 24D4 _ 83. F8, 68
        jg      ?_299                                   ; 24D7 _ 0F 8F, 00000DE4
        cmp     eax, 103                                ; 24DD _ 83. F8, 67
        je      ?_224                                   ; 24E0 _ 0F 84, 0000048A
        cmp     eax, 103                                ; 24E6 _ 83. F8, 67
        jg      ?_299                                   ; 24E9 _ 0F 8F, 00000DD2
        cmp     eax, 102                                ; 24EF _ 83. F8, 66
        je      ?_203                                   ; 24F2 _ 0F 84, 0000018F
        cmp     eax, 102                                ; 24F8 _ 83. F8, 66
        jg      ?_299                                   ; 24FB _ 0F 8F, 00000DC0
        cmp     eax, 101                                ; 2501 _ 83. F8, 65
        je      ?_230                                   ; 2504 _ 0F 84, 0000055C
        cmp     eax, 101                                ; 250A _ 83. F8, 65
        jg      ?_299                                   ; 250D _ 0F 8F, 00000DAE
        cmp     eax, 100                                ; 2513 _ 83. F8, 64
        je      ?_215                                   ; 2516 _ 0F 84, 00000305
        cmp     eax, 100                                ; 251C _ 83. F8, 64
        jg      ?_299                                   ; 251F _ 0F 8F, 00000D9C
        cmp     eax, 97                                 ; 2525 _ 83. F8, 61
        je      ?_231                                   ; 2528 _ 0F 84, 00000551
        cmp     eax, 97                                 ; 252E _ 83. F8, 61
        jg      ?_299                                   ; 2531 _ 0F 8F, 00000D8A
        cmp     eax, 90                                 ; 2537 _ 83. F8, 5A
        je      ?_220                                   ; 253A _ 0F 84, 0000037C
        cmp     eax, 90                                 ; 2540 _ 83. F8, 5A
        jg      ?_299                                   ; 2543 _ 0F 8F, 00000D78
        cmp     eax, 88                                 ; 2549 _ 83. F8, 58
        je      ?_223                                   ; 254C _ 0F 84, 000003E0
        cmp     eax, 88                                 ; 2552 _ 83. F8, 58
        jg      ?_299                                   ; 2555 _ 0F 8F, 00000D66
        cmp     eax, 87                                 ; 255B _ 83. F8, 57
        je      ?_232                                   ; 255E _ 0F 84, 00000539
        cmp     eax, 87                                 ; 2564 _ 83. F8, 57
        jg      ?_299                                   ; 2567 _ 0F 8F, 00000D54
        cmp     eax, 85                                 ; 256D _ 83. F8, 55
        je      ?_216                                   ; 2570 _ 0F 84, 000002C6
        cmp     eax, 85                                 ; 2576 _ 83. F8, 55
        jg      ?_299                                   ; 2579 _ 0F 8F, 00000D42
        cmp     eax, 80                                 ; 257F _ 83. F8, 50
        je      ?_214                                   ; 2582 _ 0F 84, 0000027E
        cmp     eax, 80                                 ; 2588 _ 83. F8, 50
        jg      ?_299                                   ; 258B _ 0F 8F, 00000D30
        cmp     eax, 79                                 ; 2591 _ 83. F8, 4F
        je      ?_204                                   ; 2594 _ 0F 84, 00000144
        cmp     eax, 79                                 ; 259A _ 83. F8, 4F
        jg      ?_299                                   ; 259D _ 0F 8F, 00000D1E
        cmp     eax, 77                                 ; 25A3 _ 83. F8, 4D
        je      ?_233                                   ; 25A6 _ 0F 84, 0000050C
        cmp     eax, 77                                 ; 25AC _ 83. F8, 4D
        jg      ?_299                                   ; 25AF _ 0F 8F, 00000D0C
        cmp     eax, 76                                 ; 25B5 _ 83. F8, 4C
        je      ?_219                                   ; 25B8 _ 0F 84, 000002DE
        cmp     eax, 76                                 ; 25BE _ 83. F8, 4C
        jg      ?_299                                   ; 25C1 _ 0F 8F, 00000CFA
        cmp     eax, 73                                 ; 25C7 _ 83. F8, 49
        je      ?_217                                   ; 25CA _ 0F 84, 00000287
        cmp     eax, 73                                 ; 25D0 _ 83. F8, 49
        jg      ?_299                                   ; 25D3 _ 0F 8F, 00000CE8
        cmp     eax, 70                                 ; 25D9 _ 83. F8, 46
        je      ?_221                                   ; 25DC _ 0F 84, 000002FA
        cmp     eax, 70                                 ; 25E2 _ 83. F8, 46
        jg      ?_299                                   ; 25E5 _ 0F 8F, 00000CD6
        cmp     eax, 69                                 ; 25EB _ 83. F8, 45
        je      ?_230                                   ; 25EE _ 0F 84, 00000472
        cmp     eax, 69                                 ; 25F4 _ 83. F8, 45
        jg      ?_299                                   ; 25F7 _ 0F 8F, 00000CC4
        cmp     eax, 68                                 ; 25FD _ 83. F8, 44
        je      ?_215                                   ; 2600 _ 0F 84, 0000021B
        cmp     eax, 68                                 ; 2606 _ 83. F8, 44
        jg      ?_299                                   ; 2609 _ 0F 8F, 00000CB2
        cmp     eax, 64                                 ; 260F _ 83. F8, 40
        jz      ?_200                                   ; 2612 _ 74, 20
        cmp     eax, 64                                 ; 2614 _ 83. F8, 40
        jg      ?_299                                   ; 2617 _ 0F 8F, 00000CA4
        cmp     eax, 45                                 ; 261D _ 83. F8, 2D
        je      ?_251                                   ; 2620 _ 0F 84, 000006D1
        cmp     eax, 63                                 ; 2626 _ 83. F8, 3F
        je      ?_226                                   ; 2629 _ 0F 84, 000003BE
        jmp     ?_299                                   ; 262F _ E9, 00000C8D

?_200:  mov     rax, qword [rbp-48H]                    ; 2634 _ 48: 8B. 45, B8
        mov     edx, dword [rbp-74H]                    ; 2638 _ 8B. 55, 8C
        mov     esi, edx                                ; 263B _ 89. D6
        mov     rdi, rax                                ; 263D _ 48: 89. C7
        call    open_and_process_respfile               ; 2640 _ E8, 000010EB
        jmp     ?_320                                   ; 2645 _ E9, 00000CDC

?_201:  cmp     dword [rbp-74H], 1                      ; 264A _ 83. 7D, 8C, 01
        jne     ?_300                                   ; 264E _ 0F 85, 00000C98
        mov     rax, qword [rel stdout]                 ; 2654 _ 48: 8B. 05, 00000000(rel)
        mov     qword [rel erropt], rax                 ; 265B _ 48: 89. 05, 00000000(rel)
        jmp     ?_300                                   ; 2662 _ E9, 00000C85

?_202:  cmp     dword [rbp-74H], 2                      ; 2667 _ 83. 7D, 8C, 02
        jne     ?_301                                   ; 266B _ 0F 85, 00000C7E
        mov     rax, qword [rbp-48H]                    ; 2671 _ 48: 8B. 45, B8
        mov     rsi, rax                                ; 2675 _ 48: 89. C6
        mov     edi, 1                                  ; 2678 _ BF, 00000001
        call    copy_filename                           ; 267D _ E8, 00000000(PLT r)
        jmp     ?_301                                   ; 2682 _ E9, 00000C68

?_203:  cmp     dword [rbp-74H], 1                      ; 2687 _ 83. 7D, 8C, 01
        jne     ?_302                                   ; 268B _ 0F 85, 00000C61
        mov     rax, qword [rbp-48H]                    ; 2691 _ 48: 8B. 45, B8
        lea     rdx, [rel ofmt_alias]                   ; 2695 _ 48: 8D. 15, 00000000(rel)
        mov     rsi, rdx                                ; 269C _ 48: 89. D6
        mov     rdi, rax                                ; 269F _ 48: 89. C7
        call    ofmt_find                               ; 26A2 _ E8, 00000000(PLT r)
        mov     qword [rel ofmt], rax                   ; 26A7 _ 48: 89. 05, 00000000(rel)
        mov     rax, qword [rel ofmt]                   ; 26AE _ 48: 8B. 05, 00000000(rel)
        test    rax, rax                                ; 26B5 _ 48: 85. C0
        jne     ?_302                                   ; 26B8 _ 0F 85, 00000C34
        mov     rax, qword [rbp-48H]                    ; 26BE _ 48: 8B. 45, B8
        lea     rcx, [rel ?_555]                        ; 26C2 _ 48: 8D. 0D, 00000000(rel)
        mov     rdx, rax                                ; 26C9 _ 48: 89. C2
        mov     rsi, rcx                                ; 26CC _ 48: 89. CE
        mov     edi, 128                                ; 26CF _ BF, 00000080
        mov     eax, 0                                  ; 26D4 _ B8, 00000000
        call    nasm_fatalf                             ; 26D9 _ E8, 00000000(PLT r)
?_204:  cmp     dword [rbp-74H], 1                      ; 26DE _ 83. 7D, 8C, 01
        jne     ?_303                                   ; 26E2 _ 0F 85, 00000C0D
        mov     rax, qword [rbp-48H]                    ; 26E8 _ 48: 8B. 45, B8
        movzx   eax, byte [rax]                         ; 26EC _ 0F B6. 00
        test    al, al                                  ; 26EF _ 84. C0
        jne     ?_213                                   ; 26F1 _ 0F 85, 000000FB
        mov     dword [rel optimizing], 0               ; 26F7 _ C7. 05, 00000000(rel), 00000000
        jmp     ?_303                                   ; 2701 _ E9, 00000BEF

?_205:  mov     rax, qword [rbp-48H]                    ; 2706 _ 48: 8B. 45, B8
        movzx   eax, byte [rax]                         ; 270A _ 0F B6. 00
        movsx   eax, al                                 ; 270D _ 0F BE. C0
        cmp     eax, 120                                ; 2710 _ 83. F8, 78
        je      ?_211                                   ; 2713 _ 0F 84, 0000009C
        cmp     eax, 120                                ; 2719 _ 83. F8, 78
        jg      ?_212                                   ; 271C _ 0F 8F, 000000AB
        cmp     eax, 118                                ; 2722 _ 83. F8, 76
        jz      ?_210                                   ; 2725 _ 74, 71
        cmp     eax, 118                                ; 2727 _ 83. F8, 76
        jg      ?_212                                   ; 272A _ 0F 8F, 0000009D
        cmp     eax, 43                                 ; 2730 _ 83. F8, 2B
        jz      ?_210                                   ; 2733 _ 74, 63
        cmp     eax, 43                                 ; 2735 _ 83. F8, 2B
        jl      ?_212                                   ; 2738 _ 0F 8C, 0000008F
        sub     eax, 48                                 ; 273E _ 83. E8, 30
        cmp     eax, 9                                  ; 2741 _ 83. F8, 09
        ja      ?_212                                   ; 2744 _ 0F 87, 00000083
        mov     rax, qword [rbp-48H]                    ; 274A _ 48: 8B. 45, B8
        lea     rcx, [rbp-48H]                          ; 274E _ 48: 8D. 4D, B8
        mov     edx, 10                                 ; 2752 _ BA, 0000000A
        mov     rsi, rcx                                ; 2757 _ 48: 89. CE
        mov     rdi, rax                                ; 275A _ 48: 89. C7
        call    __isoc23_strtoul                        ; 275D _ E8, 00000000(PLT r)
        mov     dword [rbp-4CH], eax                    ; 2762 _ 89. 45, B4
        cmp     dword [rbp-4CH], 0                      ; 2765 _ 83. 7D, B4, 00
        jz      ?_206                                   ; 2769 _ 74, 08
        cmp     dword [rbp-4CH], 1                      ; 276B _ 83. 7D, B4, 01
        jz      ?_207                                   ; 276F _ 74, 0E
        jmp     ?_208                                   ; 2771 _ EB, 18

?_206:  mov     dword [rel optimizing], 46              ; 2773 _ C7. 05, 00000000(rel), 0000002E
        jmp     ?_209                                   ; 277D _ EB, 17

?_207:  mov     dword [rel optimizing], 55              ; 277F _ C7. 05, 00000000(rel), 00000037
        jmp     ?_209                                   ; 2789 _ EB, 0B

?_208:  mov     dword [rel optimizing], 0               ; 278B _ C7. 05, 00000000(rel), 00000000
        nop                                             ; 2795 _ 90
?_209:  jmp     ?_213                                   ; 2796 _ EB, 5A

?_210:  mov     rax, qword [rbp-48H]                    ; 2798 _ 48: 8B. 45, B8
        add     rax, 1                                  ; 279C _ 48: 83. C0, 01
        mov     qword [rbp-48H], rax                    ; 27A0 _ 48: 89. 45, B8
        mov     eax, dword [rel erropt+14H]             ; 27A4 _ 8B. 05, 00000000(rel)
        add     eax, 1                                  ; 27AA _ 83. C0, 01
        mov     dword [rel erropt+14H], eax             ; 27AD _ 89. 05, 00000000(rel)
        jmp     ?_213                                   ; 27B3 _ EB, 3D

?_211:  mov     rax, qword [rbp-48H]                    ; 27B5 _ 48: 8B. 45, B8
        add     rax, 1                                  ; 27B9 _ 48: 83. C0, 01
        mov     qword [rbp-48H], rax                    ; 27BD _ 48: 89. 45, B8
        mov     dword [rel optimizing], 0               ; 27C1 _ C7. 05, 00000000(rel), 00000000
        jmp     ?_213                                   ; 27CB _ EB, 25

?_212:  mov     rax, qword [rbp-48H]                    ; 27CD _ 48: 8B. 45, B8
        movzx   eax, byte [rax]                         ; 27D1 _ 0F B6. 00
        movsx   eax, al                                 ; 27D4 _ 0F BE. C0
        lea     rcx, [rel ?_556]                        ; 27D7 _ 48: 8D. 0D, 00000000(rel)
        mov     edx, eax                                ; 27DE _ 89. C2
        mov     rsi, rcx                                ; 27E0 _ 48: 89. CE
        mov     edi, 128                                ; 27E3 _ BF, 00000080
        mov     eax, 0                                  ; 27E8 _ B8, 00000000
        call    nasm_fatalf                             ; 27ED _ E8, 00000000(PLT r)
?_213:  mov     rax, qword [rbp-48H]                    ; 27F2 _ 48: 8B. 45, B8
        movzx   eax, byte [rax]                         ; 27F6 _ 0F B6. 00
        test    al, al                                  ; 27F9 _ 84. C0
        jne     ?_205                                   ; 27FB _ 0F 85, FFFFFF05
        jmp     ?_303                                   ; 2801 _ E9, 00000AEF

?_214:  cmp     dword [rbp-74H], 2                      ; 2806 _ 83. 7D, 8C, 02
        jne     ?_304                                   ; 280A _ 0F 85, 00000AE8
        mov     rax, qword [rbp-48H]                    ; 2810 _ 48: 8B. 45, B8
        mov     rdi, rax                                ; 2814 _ 48: 89. C7
        call    pp_pre_include                          ; 2817 _ E8, 00000000(PLT r)
        jmp     ?_304                                   ; 281C _ E9, 00000AD7

?_215:  cmp     dword [rbp-74H], 2                      ; 2821 _ 83. 7D, 8C, 02
        jne     ?_305                                   ; 2825 _ 0F 85, 00000AD0
        mov     rax, qword [rbp-48H]                    ; 282B _ 48: 8B. 45, B8
        mov     rdi, rax                                ; 282F _ 48: 89. C7
        call    pp_pre_define                           ; 2832 _ E8, 00000000(PLT r)
        jmp     ?_305                                   ; 2837 _ E9, 00000ABF

?_216:  cmp     dword [rbp-74H], 2                      ; 283C _ 83. 7D, 8C, 02
        jne     ?_306                                   ; 2840 _ 0F 85, 00000AB8
        mov     rax, qword [rbp-48H]                    ; 2846 _ 48: 8B. 45, B8
        mov     rdi, rax                                ; 284A _ 48: 89. C7
        call    pp_pre_undefine                         ; 284D _ E8, 00000000(PLT r)
        jmp     ?_306                                   ; 2852 _ E9, 00000AA7

?_217:  cmp     dword [rbp-74H], 1                      ; 2857 _ 83. 7D, 8C, 01
        jne     ?_307                                   ; 285B _ 0F 85, 00000AA0
        mov     rdx, qword [rbp-48H]                    ; 2861 _ 48: 8B. 55, B8
        mov     rax, qword [rel include_path]           ; 2865 _ 48: 8B. 05, 00000000(rel)
        mov     rsi, rdx                                ; 286C _ 48: 89. D6
        mov     rdi, rax                                ; 286F _ 48: 89. C7
        call    strlist_add                             ; 2872 _ E8, 00000000(PLT r)
        jmp     ?_307                                   ; 2877 _ E9, 00000A85

?_218:  cmp     dword [rbp-74H], 2                      ; 287C _ 83. 7D, 8C, 02
        jne     ?_308                                   ; 2880 _ 0F 85, 00000A7E
        mov     rax, qword [rbp-48H]                    ; 2886 _ 48: 8B. 45, B8
        mov     rsi, rax                                ; 288A _ 48: 89. C6
        mov     edi, 3                                  ; 288D _ BF, 00000003
        call    copy_filename                           ; 2892 _ E8, 00000000(PLT r)
        jmp     ?_308                                   ; 2897 _ E9, 00000A68

?_219:  cmp     dword [rbp-74H], 2                      ; 289C _ 83. 7D, 8C, 02
        jne     ?_309                                   ; 28A0 _ 0F 85, 00000A61
        mov     rax, qword [rbp-48H]                    ; 28A6 _ 48: 8B. 45, B8
        mov     esi, 1                                  ; 28AA _ BE, 00000001
        mov     rdi, rax                                ; 28AF _ 48: 89. C7
        call    list_update_options                     ; 28B2 _ E8, 00000000(PLT r)
        jmp     ?_309                                   ; 28B7 _ E9, 00000A4B

?_220:  cmp     dword [rbp-74H], 1                      ; 28BC _ 83. 7D, 8C, 01
        jne     ?_310                                   ; 28C0 _ 0F 85, 00000A44
        mov     rax, qword [rbp-48H]                    ; 28C6 _ 48: 8B. 45, B8
        mov     rsi, rax                                ; 28CA _ 48: 89. C6
        mov     edi, 2                                  ; 28CD _ BF, 00000002
        call    copy_filename                           ; 28D2 _ E8, 00000000(PLT r)
        jmp     ?_310                                   ; 28D7 _ E9, 00000A2E

?_221:  cmp     dword [rbp-74H], 1                      ; 28DC _ 83. 7D, 8C, 01
        jne     ?_311                                   ; 28E0 _ 0F 85, 00000A27
        mov     byte [rel using_debug_info], 1          ; 28E6 _ C6. 05, 00000000(rel), 01
        movzx   eax, byte [rel debug_format_owned]      ; 28ED _ 0F B6. 05, 00000000(rel)
        test    al, al                                  ; 28F4 _ 84. C0
        jz      ?_222                                   ; 28F6 _ 74, 1B
        mov     rax, qword [rel debug_format]           ; 28F8 _ 48: 8B. 05, 00000000(rel)
        test    rax, rax                                ; 28FF _ 48: 85. C0
        jz      ?_222                                   ; 2902 _ 74, 0F
        mov     rax, qword [rel debug_format]           ; 2904 _ 48: 8B. 05, 00000000(rel)
        mov     rdi, rax                                ; 290B _ 48: 89. C7
        call    nasm_free                               ; 290E _ E8, 00000000(PLT r)
?_222:  mov     rax, qword [rbp-48H]                    ; 2913 _ 48: 8B. 45, B8
        mov     rdi, rax                                ; 2917 _ 48: 89. C7
        call    nasm_strdup                             ; 291A _ E8, 00000000(PLT r)
        mov     qword [rel debug_format], rax           ; 291F _ 48: 89. 05, 00000000(rel)
        mov     byte [rel debug_format_owned], 1        ; 2926 _ C6. 05, 00000000(rel), 01
        jmp     ?_311                                   ; 292D _ E9, 000009DB

?_223:  cmp     dword [rbp-74H], 1                      ; 2932 _ 83. 7D, 8C, 01
        jne     ?_312                                   ; 2936 _ 0F 85, 000009D4
        mov     rax, qword [rbp-48H]                    ; 293C _ 48: 8B. 45, B8
        mov     rdi, rax                                ; 2940 _ 48: 89. C7
        call    set_error_format                        ; 2943 _ E8, 00000000(PLT r)
        test    eax, eax                                ; 2948 _ 85. C0
        je      ?_312                                   ; 294A _ 0F 84, 000009C0
        mov     rax, qword [rbp-48H]                    ; 2950 _ 48: 8B. 45, B8
        lea     rcx, [rel ?_557]                        ; 2954 _ 48: 8D. 0D, 00000000(rel)
        mov     rdx, rax                                ; 295B _ 48: 89. C2
        mov     rsi, rcx                                ; 295E _ 48: 89. CE
        mov     edi, 128                                ; 2961 _ BF, 00000080
        mov     eax, 0                                  ; 2966 _ B8, 00000000
        call    nasm_fatalf                             ; 296B _ E8, 00000000(PLT r)
?_224:  cmp     dword [rbp-74H], 1                      ; 2970 _ 83. 7D, 8C, 01
        jne     ?_313                                   ; 2974 _ 0F 85, 00000999
        mov     byte [rel using_debug_info], 1          ; 297A _ C6. 05, 00000000(rel), 01
        mov     rax, qword [rbp-68H]                    ; 2981 _ 48: 8B. 45, 98
        add     rax, 2                                  ; 2985 _ 48: 83. C0, 02
        movzx   eax, byte [rax]                         ; 2989 _ 0F B6. 00
        test    al, al                                  ; 298C _ 84. C0
        je      ?_313                                   ; 298E _ 0F 84, 0000097F
        mov     rax, qword [rbp-68H]                    ; 2994 _ 48: 8B. 45, 98
        add     rax, 2                                  ; 2998 _ 48: 83. C0, 02
        mov     rdi, rax                                ; 299C _ 48: 89. C7
        call    nasm_skip_spaces                        ; 299F _ E8, 00000000(PLT r)
        mov     qword [rbp-30H], rax                    ; 29A4 _ 48: 89. 45, D0
        movzx   eax, byte [rel debug_format_owned]      ; 29A8 _ 0F B6. 05, 00000000(rel)
        test    al, al                                  ; 29AF _ 84. C0
        jz      ?_225                                   ; 29B1 _ 74, 1B
        mov     rax, qword [rel debug_format]           ; 29B3 _ 48: 8B. 05, 00000000(rel)
        test    rax, rax                                ; 29BA _ 48: 85. C0
        jz      ?_225                                   ; 29BD _ 74, 0F
        mov     rax, qword [rel debug_format]           ; 29BF _ 48: 8B. 05, 00000000(rel)
        mov     rdi, rax                                ; 29C6 _ 48: 89. C7
        call    nasm_free                               ; 29C9 _ E8, 00000000(PLT r)
?_225:  mov     rax, qword [rbp-30H]                    ; 29CE _ 48: 8B. 45, D0
        mov     rdi, rax                                ; 29D2 _ 48: 89. C7
        call    nasm_strdup                             ; 29D5 _ E8, 00000000(PLT r)
        mov     qword [rel debug_format], rax           ; 29DA _ 48: 89. 05, 00000000(rel)
        mov     byte [rel debug_format_owned], 1        ; 29E1 _ C6. 05, 00000000(rel), 01
        jmp     ?_313                                   ; 29E8 _ E9, 00000926

?_226:  lea     rdx, [rbp-51H]                          ; 29ED _ 48: 8D. 55, AF
        mov     rcx, qword [rbp-70H]                    ; 29F1 _ 48: 8B. 4D, 90
        mov     rax, qword [rbp-68H]                    ; 29F5 _ 48: 8B. 45, 98
        mov     rsi, rcx                                ; 29F9 _ 48: 89. CE
        mov     rdi, rax                                ; 29FC _ 48: 89. C7
        call    get_opt_param                           ; 29FF _ E8, FFFFF35B
        mov     rdx, rax                                ; 2A04 _ 48: 89. C2
        mov     rax, qword [rel stdout]                 ; 2A07 _ 48: 8B. 05, 00000000(rel)
        mov     rsi, rdx                                ; 2A0E _ 48: 89. D6
        mov     rdi, rax                                ; 2A11 _ 48: 89. C7
        call    help                                    ; 2A14 _ E8, 000018BA
        mov     edi, 0                                  ; 2A19 _ BF, 00000000
        call    exit                                    ; 2A1E _ E8, 00000000(PLT r)
?_227:  mov     rax, qword [rel stdout]                 ; 2A23 _ 48: 8B. 05, 00000000(rel)
        lea     rdx, [rel ?_558]                        ; 2A2A _ 48: 8D. 15, 00000000(rel)
        mov     rsi, rdx                                ; 2A31 _ 48: 89. D6
        mov     rdi, rax                                ; 2A34 _ 48: 89. C7
        call    help                                    ; 2A37 _ E8, 00001897
        mov     edi, 0                                  ; 2A3C _ BF, 00000000
        call    exit                                    ; 2A41 _ E8, 00000000(PLT r)
?_228:  cmp     dword [rbp-74H], 1                      ; 2A46 _ 83. 7D, 8C, 01
        jne     ?_314                                   ; 2A4A _ 0F 85, 000008C6
        mov     byte [rel tasm_compatible_mode], 1      ; 2A50 _ C6. 05, 00000000(rel), 01
        jmp     ?_314                                   ; 2A57 _ E9, 000008BA

?_229:  call    show_version                            ; 2A5C _ E8, FFFFF8BD
        jmp     ?_320                                   ; 2A61 _ E9, 000008C0

?_230:  cmp     dword [rbp-74H], 1                      ; 2A66 _ 83. 7D, 8C, 01
        jne     ?_315                                   ; 2A6A _ 0F 85, 000008A9
        mov     dword [rel operating_mode], 2           ; 2A70 _ C7. 05, 00000000(rel), 00000002
        jmp     ?_315                                   ; 2A7A _ E9, 0000089A

?_231:  cmp     dword [rbp-74H], 1                      ; 2A7F _ 83. 7D, 8C, 01
        jne     ?_316                                   ; 2A83 _ 0F 85, 00000893
        mov     eax, dword [rel ppopt]                  ; 2A89 _ 8B. 05, 00000000(rel)
        or      eax, 01H                                ; 2A8F _ 83. C8, 01
        mov     dword [rel ppopt], eax                  ; 2A92 _ 89. 05, 00000000(rel)
        jmp     ?_316                                   ; 2A98 _ E9, 0000087F

?_232:  cmp     dword [rbp-74H], 2                      ; 2A9D _ 83. 7D, 8C, 02
        jne     ?_317                                   ; 2AA1 _ 0F 85, 00000878
        mov     rax, qword [rbp-48H]                    ; 2AA7 _ 48: 8B. 45, B8
        mov     rdi, rax                                ; 2AAB _ 48: 89. C7
        call    set_warning_status                      ; 2AAE _ E8, 00000000(PLT r)
        jmp     ?_317                                   ; 2AB3 _ E9, 00000867

?_233:  cmp     dword [rbp-74H], 1                      ; 2AB8 _ 83. 7D, 8C, 01
        jnz     ?_236                                   ; 2ABC _ 75, 63
        mov     rax, qword [rbp-68H]                    ; 2ABE _ 48: 8B. 45, 98
        add     rax, 2                                  ; 2AC2 _ 48: 83. C0, 02
        movzx   eax, byte [rax]                         ; 2AC6 _ 0F B6. 00
        movsx   eax, al                                 ; 2AC9 _ 0F BE. C0
        cmp     eax, 87                                 ; 2ACC _ 83. F8, 57
        jz      ?_234                                   ; 2ACF _ 74, 34
        cmp     eax, 87                                 ; 2AD1 _ 83. F8, 57
        jg      ?_246                                   ; 2AD4 _ 0F 8F, 000001C6
        cmp     eax, 84                                 ; 2ADA _ 83. F8, 54
        jz      ?_235                                   ; 2ADD _ 74, 39
        cmp     eax, 84                                 ; 2ADF _ 83. F8, 54
        jg      ?_246                                   ; 2AE2 _ 0F 8F, 000001B8
        cmp     eax, 81                                 ; 2AE8 _ 83. F8, 51
        jz      ?_235                                   ; 2AEB _ 74, 2B
        cmp     eax, 81                                 ; 2AED _ 83. F8, 51
        jg      ?_246                                   ; 2AF0 _ 0F 8F, 000001AA
        cmp     eax, 68                                 ; 2AF6 _ 83. F8, 44
        jz      ?_235                                   ; 2AF9 _ 74, 1D
        cmp     eax, 70                                 ; 2AFB _ 83. F8, 46
        jz      ?_235                                   ; 2AFE _ 74, 18
        jmp     ?_246                                   ; 2B00 _ E9, 0000019B

?_234:  lea     rax, [rel quote_for_wmake]              ; 2B05 _ 48: 8D. 05, FFFFF67B(rel)
        mov     qword [rel quote_for_make], rax         ; 2B0C _ 48: 89. 05, 00000000(rel)
        jmp     ?_249                                   ; 2B13 _ E9, 0000018F

?_235:  mov     byte [rbp-51H], 1                       ; 2B18 _ C6. 45, AF, 01
        jmp     ?_249                                   ; 2B1C _ E9, 00000186

?_236:  mov     rax, qword [rbp-68H]                    ; 2B21 _ 48: 8B. 45, 98
        add     rax, 2                                  ; 2B25 _ 48: 83. C0, 02
        movzx   eax, byte [rax]                         ; 2B29 _ 0F B6. 00
        movsx   eax, al                                 ; 2B2C _ 0F BE. C0
        cmp     eax, 87                                 ; 2B2F _ 83. F8, 57
        je      ?_247                                   ; 2B32 _ 0F 84, 0000016B
        cmp     eax, 87                                 ; 2B38 _ 83. F8, 57
        jg      ?_245                                   ; 2B3B _ 0F 8F, 00000134
        cmp     eax, 84                                 ; 2B41 _ 83. F8, 54
        je      ?_243                                   ; 2B44 _ 0F 84, 000000F1
        cmp     eax, 84                                 ; 2B4A _ 83. F8, 54
        jg      ?_245                                   ; 2B4D _ 0F 8F, 00000122
        cmp     eax, 81                                 ; 2B53 _ 83. F8, 51
        je      ?_244                                   ; 2B56 _ 0F 84, 000000F6
        cmp     eax, 81                                 ; 2B5C _ 83. F8, 51
        jg      ?_245                                   ; 2B5F _ 0F 8F, 00000110
        cmp     eax, 80                                 ; 2B65 _ 83. F8, 50
        jz      ?_239                                   ; 2B68 _ 74, 5C
        cmp     eax, 80                                 ; 2B6A _ 83. F8, 50
        jg      ?_245                                   ; 2B6D _ 0F 8F, 00000102
        cmp     eax, 71                                 ; 2B73 _ 83. F8, 47
        jz      ?_238                                   ; 2B76 _ 74, 38
        cmp     eax, 71                                 ; 2B78 _ 83. F8, 47
        jg      ?_245                                   ; 2B7B _ 0F 8F, 000000F4
        cmp     eax, 70                                 ; 2B81 _ 83. F8, 46
        je      ?_242                                   ; 2B84 _ 0F 84, 0000009A
        cmp     eax, 70                                 ; 2B8A _ 83. F8, 46
        jg      ?_245                                   ; 2B8D _ 0F 8F, 000000E2
        test    eax, eax                                ; 2B93 _ 85. C0
        jz      ?_237                                   ; 2B95 _ 74, 0A
        cmp     eax, 68                                 ; 2B97 _ 83. F8, 44
        jz      ?_240                                   ; 2B9A _ 74, 36
        jmp     ?_245                                   ; 2B9C _ E9, 000000D4

?_237:  mov     dword [rel operating_mode], 4           ; 2BA1 _ C7. 05, 00000000(rel), 00000004
        jmp     ?_249                                   ; 2BAB _ E9, 000000F7

?_238:  mov     dword [rel operating_mode], 4           ; 2BB0 _ C7. 05, 00000000(rel), 00000004
        mov     byte [rel depend_missing_ok], 1         ; 2BBA _ C6. 05, 00000000(rel), 01
        jmp     ?_249                                   ; 2BC1 _ E9, 000000E1

?_239:  mov     byte [rel depend_emit_phony], 1         ; 2BC6 _ C6. 05, 00000000(rel), 01
        jmp     ?_249                                   ; 2BCD _ E9, 000000D5

?_240:  mov     eax, dword [rel operating_mode]         ; 2BD2 _ 8B. 05, 00000000(rel)
        or      eax, 04H                                ; 2BD8 _ 83. C8, 04
        mov     dword [rel operating_mode], eax         ; 2BDB _ 89. 05, 00000000(rel)
        cmp     qword [rbp-70H], 0                      ; 2BE1 _ 48: 83. 7D, 90, 00
        je      ?_248                                   ; 2BE6 _ 0F 84, 000000BA
        mov     rax, qword [rbp-70H]                    ; 2BEC _ 48: 8B. 45, 90
        movzx   eax, byte [rax]                         ; 2BF0 _ 0F B6. 00
        cmp     al, 45                                  ; 2BF3 _ 3C, 2D
        jnz     ?_241                                   ; 2BF5 _ 75, 13
        mov     rax, qword [rbp-70H]                    ; 2BF7 _ 48: 8B. 45, 90
        add     rax, 1                                  ; 2BFB _ 48: 83. C0, 01
        movzx   eax, byte [rax]                         ; 2BFF _ 0F B6. 00
        test    al, al                                  ; 2C02 _ 84. C0
        jne     ?_248                                   ; 2C04 _ 0F 85, 0000009C
?_241:  mov     rax, qword [rbp-70H]                    ; 2C0A _ 48: 8B. 45, 90
        mov     rsi, rax                                ; 2C0E _ 48: 89. C6
        mov     edi, 4                                  ; 2C11 _ BF, 00000004
        call    copy_filename                           ; 2C16 _ E8, 00000000(PLT r)
        mov     byte [rbp-51H], 1                       ; 2C1B _ C6. 45, AF, 01
        jmp     ?_248                                   ; 2C1F _ E9, 00000082

?_242:  mov     rax, qword [rbp-70H]                    ; 2C24 _ 48: 8B. 45, 90
        mov     rsi, rax                                ; 2C28 _ 48: 89. C6
        mov     edi, 4                                  ; 2C2B _ BF, 00000004
        call    copy_filename                           ; 2C30 _ E8, 00000000(PLT r)
        mov     byte [rbp-51H], 1                       ; 2C35 _ C6. 45, AF, 01
        jmp     ?_249                                   ; 2C39 _ EB, 6C

?_243:  mov     rax, qword [rbp-70H]                    ; 2C3B _ 48: 8B. 45, 90
        mov     rsi, rax                                ; 2C3F _ 48: 89. C6
        mov     edi, 8                                  ; 2C42 _ BF, 00000008
        call    copy_filename                           ; 2C47 _ E8, 00000000(PLT r)
        mov     byte [rbp-51H], 1                       ; 2C4C _ C6. 45, AF, 01
        jmp     ?_249                                   ; 2C50 _ EB, 55

?_244:  mov     rdx, qword [rel quote_for_make]         ; 2C52 _ 48: 8B. 15, 00000000(rel)
        mov     rax, qword [rbp-70H]                    ; 2C59 _ 48: 8B. 45, 90
        mov     rdi, rax                                ; 2C5D _ 48: 89. C7
        call    rdx                                     ; 2C60 _ FF. D2
        mov     rsi, rax                                ; 2C62 _ 48: 89. C6
        mov     edi, 8                                  ; 2C65 _ BF, 00000008
        call    set_filename                            ; 2C6A _ E8, 00000000(PLT r)
        mov     byte [rbp-51H], 1                       ; 2C6F _ C6. 45, AF, 01
        jmp     ?_249                                   ; 2C73 _ EB, 32

?_245:  mov     rax, qword [rbp-68H]                    ; 2C75 _ 48: 8B. 45, 98
        add     rax, 2                                  ; 2C79 _ 48: 83. C0, 02
        movzx   eax, byte [rax]                         ; 2C7D _ 0F B6. 00
        movsx   eax, al                                 ; 2C80 _ 0F BE. C0
        lea     rcx, [rel ?_559]                        ; 2C83 _ 48: 8D. 0D, 00000000(rel)
        mov     edx, eax                                ; 2C8A _ 89. C2
        mov     rsi, rcx                                ; 2C8C _ 48: 89. CE
        mov     edi, 128                                ; 2C8F _ BF, 00000080
        mov     eax, 0                                  ; 2C94 _ B8, 00000000
        call    nasm_nonfatalf                          ; 2C99 _ E8, 00000000(PLT r)
        jmp     ?_249                                   ; 2C9E _ EB, 07

?_246:  nop                                             ; 2CA0 _ 90
        jmp     ?_249                                   ; 2CA1 _ EB, 04

?_247:  nop                                             ; 2CA3 _ 90
        jmp     ?_249                                   ; 2CA4 _ EB, 01

?_248:  nop                                             ; 2CA6 _ 90
?_249:  movzx   eax, byte [rbp-51H]                     ; 2CA7 _ 0F B6. 45, AF
        test    al, al                                  ; 2CAB _ 84. C0
        je      ?_318                                   ; 2CAD _ 0F 84, 0000066F
        cmp     qword [rbp-70H], 0                      ; 2CB3 _ 48: 83. 7D, 90, 00
        jz      ?_250                                   ; 2CB8 _ 74, 0F
        mov     rax, qword [rbp-70H]                    ; 2CBA _ 48: 8B. 45, 90
        movzx   eax, byte [rax]                         ; 2CBE _ 0F B6. 00
        test    al, al                                  ; 2CC1 _ 84. C0
        jne     ?_318                                   ; 2CC3 _ 0F 85, 00000659
?_250:  mov     rax, qword [rbp-68H]                    ; 2CC9 _ 48: 8B. 45, 98
        add     rax, 2                                  ; 2CCD _ 48: 83. C0, 02
        movzx   eax, byte [rax]                         ; 2CD1 _ 0F B6. 00
        movsx   eax, al                                 ; 2CD4 _ 0F BE. C0
        lea     rcx, [rel ?_560]                        ; 2CD7 _ 48: 8D. 0D, 00000000(rel)
        mov     edx, eax                                ; 2CDE _ 89. C2
        mov     rsi, rcx                                ; 2CE0 _ 48: 89. CE
        mov     edi, 128                                ; 2CE3 _ BF, 00000080
        mov     eax, 0                                  ; 2CE8 _ B8, 00000000
        call    nasm_nonfatalf                          ; 2CED _ E8, 00000000(PLT r)
        jmp     ?_320                                   ; 2CF2 _ E9, 0000062F

?_251:  add     qword [rbp-68H], 2                      ; 2CF7 _ 48: 83. 45, 98, 02
        mov     rax, qword [rbp-68H]                    ; 2CFC _ 48: 8B. 45, 98
        movzx   eax, byte [rax]                         ; 2D00 _ 0F B6. 00
        test    al, al                                  ; 2D03 _ 84. C0
        jnz     ?_252                                   ; 2D05 _ 75, 0C
        mov     byte [rel stopoptions], 1               ; 2D07 _ C6. 05, 00000000(rel), 01
        jmp     ?_320                                   ; 2D0E _ E9, 00000613

?_252:  mov     qword [rbp-38H], 0                      ; 2D13 _ 48: C7. 45, C8, 00000000
        mov     rax, qword [rbp-68H]                    ; 2D1B _ 48: 8B. 45, 98
        mov     rdi, rax                                ; 2D1F _ 48: 89. C7
        call    strlen                                  ; 2D22 _ E8, 00000000(PLT r)
        mov     qword [rbp-28H], rax                    ; 2D27 _ 48: 89. 45, D8
        lea     rax, [rel textopts]                     ; 2D2B _ 48: 8D. 05, 00000000(rel)
        mov     qword [rbp-40H], rax                    ; 2D32 _ 48: 89. 45, C0
        jmp     ?_257                                   ; 2D36 _ E9, 00000083

?_253:  mov     rax, qword [rbp-40H]                    ; 2D3B _ 48: 8B. 45, C0
        mov     rax, qword [rax]                        ; 2D3F _ 48: 8B. 00
        mov     rdi, rax                                ; 2D42 _ 48: 89. C7
        call    strlen                                  ; 2D45 _ E8, 00000000(PLT r)
        mov     qword [rbp-38H], rax                    ; 2D4A _ 48: 89. 45, C8
        mov     rax, qword [rbp-38H]                    ; 2D4E _ 48: 8B. 45, C8
        cmp     qword [rbp-28H], rax                    ; 2D52 _ 48: 39. 45, D8
        jc      ?_254                                   ; 2D56 _ 72, 5D
        mov     rax, qword [rbp-40H]                    ; 2D58 _ 48: 8B. 45, C0
        mov     rcx, qword [rax]                        ; 2D5C _ 48: 8B. 08
        mov     rdx, qword [rbp-38H]                    ; 2D5F _ 48: 8B. 55, C8
        mov     rax, qword [rbp-68H]                    ; 2D63 _ 48: 8B. 45, 98
        mov     rsi, rcx                                ; 2D67 _ 48: 89. CE
        mov     rdi, rax                                ; 2D6A _ 48: 89. C7
        call    nasm_memicmp                            ; 2D6D _ E8, 00000000(PLT r)
        test    eax, eax                                ; 2D72 _ 85. C0
        jnz     ?_255                                   ; 2D74 _ 75, 42
        mov     rax, qword [rbp-40H]                    ; 2D76 _ 48: 8B. 45, C0
        mov     rax, qword [rax]                        ; 2D7A _ 48: 8B. 00
        mov     rdx, qword [rbp-38H]                    ; 2D7D _ 48: 8B. 55, C8
        sub     rdx, 1                                  ; 2D81 _ 48: 83. EA, 01
        add     rax, rdx                                ; 2D85 _ 48: 01. D0
        movzx   eax, byte [rax]                         ; 2D88 _ 0F B6. 00
        cmp     al, 45                                  ; 2D8B _ 3C, 2D
        jz      ?_258                                   ; 2D8D _ 74, 41
        mov     rdx, qword [rbp-68H]                    ; 2D8F _ 48: 8B. 55, 98
        mov     rax, qword [rbp-38H]                    ; 2D93 _ 48: 8B. 45, C8
        add     rax, rdx                                ; 2D97 _ 48: 01. D0
        movzx   eax, byte [rax]                         ; 2D9A _ 0F B6. 00
        test    al, al                                  ; 2D9D _ 84. C0
        jz      ?_259                                   ; 2D9F _ 74, 30
        mov     rdx, qword [rbp-68H]                    ; 2DA1 _ 48: 8B. 55, 98
        mov     rax, qword [rbp-38H]                    ; 2DA5 _ 48: 8B. 45, C8
        add     rax, rdx                                ; 2DA9 _ 48: 01. D0
        movzx   eax, byte [rax]                         ; 2DAC _ 0F B6. 00
        cmp     al, 61                                  ; 2DAF _ 3C, 3D
        jz      ?_259                                   ; 2DB1 _ 74, 1E
        jmp     ?_256                                   ; 2DB3 _ EB, 04

?_254:  nop                                             ; 2DB5 _ 90
        jmp     ?_256                                   ; 2DB6 _ EB, 01

?_255:  nop                                             ; 2DB8 _ 90
?_256:  add     qword [rbp-40H], 24                     ; 2DB9 _ 48: 83. 45, C0, 18
?_257:  mov     rax, qword [rbp-40H]                    ; 2DBE _ 48: 8B. 45, C0
        mov     rax, qword [rax]                        ; 2DC2 _ 48: 8B. 00
        test    rax, rax                                ; 2DC5 _ 48: 85. C0
        jne     ?_253                                   ; 2DC8 _ 0F 85, FFFFFF6D
        jmp     ?_259                                   ; 2DCE _ EB, 01

?_258:  nop                                             ; 2DD0 _ 90
?_259:  mov     rax, qword [rbp-40H]                    ; 2DD1 _ 48: 8B. 45, C0
        mov     rax, qword [rax]                        ; 2DD5 _ 48: 8B. 00
        test    rax, rax                                ; 2DD8 _ 48: 85. C0
        jnz     ?_260                                   ; 2DDB _ 75, 20
        mov     rax, qword [rbp-68H]                    ; 2DDD _ 48: 8B. 45, 98
        lea     rcx, [rel ?_561]                        ; 2DE1 _ 48: 8D. 0D, 00000000(rel)
        mov     rdx, rax                                ; 2DE8 _ 48: 89. C2
        mov     rsi, rcx                                ; 2DEB _ 48: 89. CE
        mov     edi, 128                                ; 2DEE _ BF, 00000080
        mov     eax, 0                                  ; 2DF3 _ B8, 00000000
        call    nasm_nonfatalf                          ; 2DF8 _ E8, 00000000(PLT r)
?_260:  mov     rax, qword [rbp-40H]                    ; 2DFD _ 48: 8B. 45, C0
        mov     eax, dword [rax+8H]                     ; 2E01 _ 8B. 40, 08
        mov     dword [rbp-50H], eax                    ; 2E04 _ 89. 45, B0
        mov     rdx, qword [rbp-68H]                    ; 2E07 _ 48: 8B. 55, 98
        mov     rax, qword [rbp-38H]                    ; 2E0B _ 48: 8B. 45, C8
        add     rax, rdx                                ; 2E0F _ 48: 01. D0
        mov     esi, 61                                 ; 2E12 _ BE, 0000003D
        mov     rdi, rax                                ; 2E17 _ 48: 89. C7
        call    strchr                                  ; 2E1A _ E8, 00000000(PLT r)
        mov     qword [rbp-48H], rax                    ; 2E1F _ 48: 89. 45, B8
        mov     rax, qword [rbp-48H]                    ; 2E23 _ 48: 8B. 45, B8
        mov     qword [rbp-20H], rax                    ; 2E27 _ 48: 89. 45, E0
        mov     rax, qword [rbp-48H]                    ; 2E2B _ 48: 8B. 45, B8
        test    rax, rax                                ; 2E2F _ 48: 85. C0
        jz      ?_261                                   ; 2E32 _ 74, 0F
        mov     rax, qword [rbp-48H]                    ; 2E34 _ 48: 8B. 45, B8
        lea     rdx, [rax+1H]                           ; 2E38 _ 48: 8D. 50, 01
        mov     qword [rbp-48H], rdx                    ; 2E3C _ 48: 89. 55, B8
        mov     byte [rax], 0                           ; 2E40 _ C6. 00, 00
?_261:  mov     rax, qword [rbp-40H]                    ; 2E43 _ 48: 8B. 45, C0
        mov     eax, dword [rax+0CH]                    ; 2E47 _ 8B. 40, 0C
        cmp     eax, 2                                  ; 2E4A _ 83. F8, 02
        je      ?_264                                   ; 2E4D _ 0F 84, 0000008F
        cmp     eax, 2                                  ; 2E53 _ 83. F8, 02
        ja      ?_267                                   ; 2E56 _ 0F 87, 0000008D
        test    eax, eax                                ; 2E5C _ 85. C0
        jz      ?_263                                   ; 2E5E _ 74, 50
        cmp     eax, 1                                  ; 2E60 _ 83. F8, 01
        jne     ?_267                                   ; 2E63 _ 0F 85, 00000080
        mov     rax, qword [rbp-48H]                    ; 2E69 _ 48: 8B. 45, B8
        test    rax, rax                                ; 2E6D _ 48: 85. C0
        jnz     ?_262                                   ; 2E70 _ 75, 0C
        mov     rax, qword [rbp-70H]                    ; 2E72 _ 48: 8B. 45, 90
        mov     qword [rbp-48H], rax                    ; 2E76 _ 48: 89. 45, B8
        mov     byte [rbp-51H], 1                       ; 2E7A _ C6. 45, AF, 01
?_262:  mov     rax, qword [rbp-48H]                    ; 2E7E _ 48: 8B. 45, B8
        test    rax, rax                                ; 2E82 _ 48: 85. C0
        jnz     ?_265                                   ; 2E85 _ 75, 5E
        mov     rax, qword [rbp-68H]                    ; 2E87 _ 48: 8B. 45, 98
        lea     rcx, [rel ?_562]                        ; 2E8B _ 48: 8D. 0D, 00000000(rel)
        mov     rdx, rax                                ; 2E92 _ 48: 89. C2
        mov     rsi, rcx                                ; 2E95 _ 48: 89. CE
        mov     edi, 128                                ; 2E98 _ BF, 00000080
        mov     eax, 0                                  ; 2E9D _ B8, 00000000
        call    nasm_nonfatalf                          ; 2EA2 _ E8, 00000000(PLT r)
        mov     dword [rbp-50H], 0                      ; 2EA7 _ C7. 45, B0, 00000000
        jmp     ?_265                                   ; 2EAE _ EB, 35

?_263:  mov     rax, qword [rbp-48H]                    ; 2EB0 _ 48: 8B. 45, B8
        test    rax, rax                                ; 2EB4 _ 48: 85. C0
        jz      ?_266                                   ; 2EB7 _ 74, 2F
        mov     rax, qword [rbp-68H]                    ; 2EB9 _ 48: 8B. 45, 98
        lea     rcx, [rel ?_563]                        ; 2EBD _ 48: 8D. 0D, 00000000(rel)
        mov     rdx, rax                                ; 2EC4 _ 48: 89. C2
        mov     rsi, rcx                                ; 2EC7 _ 48: 89. CE
        mov     edi, 128                                ; 2ECA _ BF, 00000080
        mov     eax, 0                                  ; 2ECF _ B8, 00000000
        call    nasm_nonfatalf                          ; 2ED4 _ E8, 00000000(PLT r)
        mov     dword [rbp-50H], 0                      ; 2ED9 _ C7. 45, B0, 00000000
        jmp     ?_266                                   ; 2EE0 _ EB, 06

?_264:  nop                                             ; 2EE2 _ 90
        jmp     ?_267                                   ; 2EE3 _ EB, 04

?_265:  nop                                             ; 2EE5 _ 90
        jmp     ?_267                                   ; 2EE6 _ EB, 01

?_266:  nop                                             ; 2EE8 _ 90
?_267:  cmp     dword [rbp-50H], 15                     ; 2EE9 _ 83. 7D, B0, 0F
        je      ?_284                                   ; 2EED _ 0F 84, 000002AC
        cmp     dword [rbp-50H], 15                     ; 2EF3 _ 83. 7D, B0, 0F
        ja      ?_288                                   ; 2EF7 _ 0F 87, 0000037D
        cmp     dword [rbp-50H], 14                     ; 2EFD _ 83. 7D, B0, 0E
        je      ?_272                                   ; 2F01 _ 0F 84, 00000180
        cmp     dword [rbp-50H], 14                     ; 2F07 _ 83. 7D, B0, 0E
        ja      ?_288                                   ; 2F0B _ 0F 87, 00000369
        cmp     dword [rbp-50H], 13                     ; 2F11 _ 83. 7D, B0, 0D
        je      ?_283                                   ; 2F15 _ 0F 84, 00000278
        cmp     dword [rbp-50H], 13                     ; 2F1B _ 83. 7D, B0, 0D
        ja      ?_288                                   ; 2F1F _ 0F 87, 00000355
        cmp     dword [rbp-50H], 12                     ; 2F25 _ 83. 7D, B0, 0C
        je      ?_280                                   ; 2F29 _ 0F 84, 00000225
        cmp     dword [rbp-50H], 12                     ; 2F2F _ 83. 7D, B0, 0C
        ja      ?_288                                   ; 2F33 _ 0F 87, 00000341
        cmp     dword [rbp-50H], 11                     ; 2F39 _ 83. 7D, B0, 0B
        je      ?_277                                   ; 2F3D _ 0F 84, 000001D2
        cmp     dword [rbp-50H], 11                     ; 2F43 _ 83. 7D, B0, 0B
        ja      ?_288                                   ; 2F47 _ 0F 87, 0000032D
        cmp     dword [rbp-50H], 10                     ; 2F4D _ 83. 7D, B0, 0A
        je      ?_276                                   ; 2F51 _ 0F 84, 000001AA
        cmp     dword [rbp-50H], 10                     ; 2F57 _ 83. 7D, B0, 0A
        ja      ?_288                                   ; 2F5B _ 0F 87, 00000319
        cmp     dword [rbp-50H], 9                      ; 2F61 _ 83. 7D, B0, 09
        je      ?_275                                   ; 2F65 _ 0F 84, 0000018A
        cmp     dword [rbp-50H], 9                      ; 2F6B _ 83. 7D, B0, 09
        ja      ?_288                                   ; 2F6F _ 0F 87, 00000305
        cmp     dword [rbp-50H], 8                      ; 2F75 _ 83. 7D, B0, 08
        je      ?_274                                   ; 2F79 _ 0F 84, 0000014D
        cmp     dword [rbp-50H], 8                      ; 2F7F _ 83. 7D, B0, 08
        ja      ?_288                                   ; 2F83 _ 0F 87, 000002F1
        cmp     dword [rbp-50H], 7                      ; 2F89 _ 83. 7D, B0, 07
        je      ?_273                                   ; 2F8D _ 0F 84, 00000119
        cmp     dword [rbp-50H], 7                      ; 2F93 _ 83. 7D, B0, 07
        ja      ?_288                                   ; 2F97 _ 0F 87, 000002DD
        cmp     dword [rbp-50H], 6                      ; 2F9D _ 83. 7D, B0, 06
        je      ?_271                                   ; 2FA1 _ 0F 84, 000000BB
        cmp     dword [rbp-50H], 6                      ; 2FA7 _ 83. 7D, B0, 06
        ja      ?_288                                   ; 2FAB _ 0F 87, 000002C9
        cmp     dword [rbp-50H], 5                      ; 2FB1 _ 83. 7D, B0, 05
        je      ?_270                                   ; 2FB5 _ 0F 84, 0000008C
        cmp     dword [rbp-50H], 5                      ; 2FBB _ 83. 7D, B0, 05
        ja      ?_288                                   ; 2FBF _ 0F 87, 000002B5
        cmp     dword [rbp-50H], 4                      ; 2FC5 _ 83. 7D, B0, 04
        jz      ?_269                                   ; 2FC9 _ 74, 58
        cmp     dword [rbp-50H], 4                      ; 2FCB _ 83. 7D, B0, 04
        ja      ?_288                                   ; 2FCF _ 0F 87, 000002A5
        cmp     dword [rbp-50H], 3                      ; 2FD5 _ 83. 7D, B0, 03
        jz      ?_268                                   ; 2FD9 _ 74, 3C
        cmp     dword [rbp-50H], 3                      ; 2FDB _ 83. 7D, B0, 03
        ja      ?_288                                   ; 2FDF _ 0F 87, 00000295
        cmp     dword [rbp-50H], 2                      ; 2FE5 _ 83. 7D, B0, 02
        je      ?_286                                   ; 2FE9 _ 0F 84, 0000025A
        cmp     dword [rbp-50H], 2                      ; 2FEF _ 83. 7D, B0, 02
        ja      ?_288                                   ; 2FF3 _ 0F 87, 00000281
        cmp     dword [rbp-50H], 0                      ; 2FF9 _ 83. 7D, B0, 00
        je      ?_289                                   ; 2FFD _ 0F 84, 00000295
        cmp     dword [rbp-50H], 1                      ; 3003 _ 83. 7D, B0, 01
        jne     ?_288                                   ; 3007 _ 0F 85, 0000026D
        call    show_version                            ; 300D _ E8, FFFFF30C
        jmp     ?_298                                   ; 3012 _ E9, 0000029A

?_268:  mov     byte [rel abort_on_panic], 1            ; 3017 _ C6. 05, 00000000(rel), 01
        jmp     ?_298                                   ; 301E _ E9, 0000028E

?_269:  cmp     dword [rbp-74H], 2                      ; 3023 _ 83. 7D, 8C, 02
        jne     ?_290                                   ; 3027 _ 0F 85, 0000026E
        mov     rax, qword [rbp-48H]                    ; 302D _ 48: 8B. 45, B8
        mov     rdx, qword [rbp-40H]                    ; 3031 _ 48: 8B. 55, C0
        mov     edx, dword [rdx+10H]                    ; 3035 _ 8B. 52, 10
        mov     rsi, rax                                ; 3038 _ 48: 89. C6
        mov     edi, edx                                ; 303B _ 89. D7
        call    set_label_mangle                        ; 303D _ E8, 00000000(PLT r)
        jmp     ?_290                                   ; 3042 _ E9, 00000254

?_270:  cmp     dword [rbp-74H], 2                      ; 3047 _ 83. 7D, 8C, 02
        jne     ?_291                                   ; 304B _ 0F 85, 0000024D
        mov     rax, qword [rbp-70H]                    ; 3051 _ 48: 8B. 45, 90
        mov     rdi, rax                                ; 3055 _ 48: 89. C7
        call    pp_pre_include                          ; 3058 _ E8, 00000000(PLT r)
        jmp     ?_291                                   ; 305D _ E9, 0000023C

?_271:  cmp     dword [rbp-74H], 2                      ; 3062 _ 83. 7D, 8C, 02
        jne     ?_292                                   ; 3066 _ 0F 85, 00000235
        mov     rax, qword [rbp-48H]                    ; 306C _ 48: 8B. 45, B8
        lea     rdx, [rel ?_564]                        ; 3070 _ 48: 8D. 15, 00000000(rel)
        mov     rsi, rax                                ; 3077 _ 48: 89. C6
        mov     rdi, rdx                                ; 307A _ 48: 89. D7
        call    pp_pre_command                          ; 307D _ E8, 00000000(PLT r)
        jmp     ?_292                                   ; 3082 _ E9, 0000021A

?_272:  cmp     dword [rbp-74H], 2                      ; 3087 _ 83. 7D, 8C, 02
        jne     ?_293                                   ; 308B _ 0F 85, 00000213
        mov     rax, qword [rbp-48H]                    ; 3091 _ 48: 8B. 45, B8
        lea     rdx, [rel ?_565]                        ; 3095 _ 48: 8D. 15, 00000000(rel)
        mov     rsi, rax                                ; 309C _ 48: 89. C6
        mov     rdi, rdx                                ; 309F _ 48: 89. D7
        call    pp_pre_command                          ; 30A2 _ E8, 00000000(PLT r)
        jmp     ?_293                                   ; 30A7 _ E9, 000001F8

?_273:  cmp     dword [rbp-74H], 2                      ; 30AC _ 83. 7D, 8C, 02
        jne     ?_294                                   ; 30B0 _ 0F 85, 000001F1
        mov     rax, qword [rbp-48H]                    ; 30B6 _ 48: 8B. 45, B8
        mov     rsi, rax                                ; 30BA _ 48: 89. C6
        mov     edi, 0                                  ; 30BD _ BF, 00000000
        call    pp_pre_command                          ; 30C2 _ E8, 00000000(PLT r)
        jmp     ?_294                                   ; 30C7 _ E9, 000001DB

?_274:  cmp     dword [rbp-74H], 1                      ; 30CC _ 83. 7D, 8C, 01
        jne     ?_295                                   ; 30D0 _ 0F 85, 000001D4
        mov     rax, qword [rbp-48H]                    ; 30D6 _ 48: 8B. 45, B8
        mov     rcx, qword [rbp-68H]                    ; 30DA _ 48: 8B. 4D, 98
        mov     rdx, qword [rbp-38H]                    ; 30DE _ 48: 8B. 55, C8
        add     rdx, rcx                                ; 30E2 _ 48: 01. CA
        mov     rsi, rax                                ; 30E5 _ 48: 89. C6
        mov     rdi, rdx                                ; 30E8 _ 48: 89. D7
        call    nasm_set_limit                          ; 30EB _ E8, 00000000(PLT r)
        jmp     ?_295                                   ; 30F0 _ E9, 000001B5

?_275:  mov     byte [rel keep_all], 1                  ; 30F5 _ C6. 05, 00000000(rel), 01
        jmp     ?_298                                   ; 30FC _ E9, 000001B0

?_276:  mov     eax, dword [rel ppopt]                  ; 3101 _ 8B. 05, 00000000(rel)
        or      eax, 02H                                ; 3107 _ 83. C8, 02
        mov     dword [rel ppopt], eax                  ; 310A _ 89. 05, 00000000(rel)
        jmp     ?_298                                   ; 3110 _ E9, 0000019C

?_277:  cmp     dword [rbp-74H], 1                      ; 3115 _ 83. 7D, 8C, 01
        jne     ?_296                                   ; 3119 _ 0F 85, 0000018E
        mov     rax, qword [rbp-48H]                    ; 311F _ 48: 8B. 45, B8
        test    rax, rax                                ; 3123 _ 48: 85. C0
        jz      ?_278                                   ; 3126 _ 74, 18
        mov     rax, qword [rbp-48H]                    ; 3128 _ 48: 8B. 45, B8
        mov     edx, 10                                 ; 312C _ BA, 0000000A
        mov     esi, 0                                  ; 3131 _ BE, 00000000
        mov     rdi, rax                                ; 3136 _ 48: 89. C7
        call    __isoc23_strtoul                        ; 3139 _ E8, 00000000(PLT r)
        jmp     ?_279                                   ; 313E _ EB, 09

?_278:  mov     eax, dword [rel erropt+10H]             ; 3140 _ 8B. 05, 00000000(rel)
        add     eax, 1                                  ; 3146 _ 83. C0, 01
?_279:  mov     dword [rel erropt+10H], eax             ; 3149 _ 89. 05, 00000000(rel)
        jmp     ?_296                                   ; 314F _ E9, 00000159

?_280:  cmp     dword [rbp-74H], 1                      ; 3154 _ 83. 7D, 8C, 01
        jne     ?_297                                   ; 3158 _ 0F 85, 00000152
        mov     rax, qword [rbp-48H]                    ; 315E _ 48: 8B. 45, B8
        test    rax, rax                                ; 3162 _ 48: 85. C0
        jz      ?_281                                   ; 3165 _ 74, 18
        mov     rax, qword [rbp-48H]                    ; 3167 _ 48: 8B. 45, B8
        mov     edx, 10                                 ; 316B _ BA, 0000000A
        mov     esi, 0                                  ; 3170 _ BE, 00000000
        mov     rdi, rax                                ; 3175 _ 48: 89. C7
        call    __isoc23_strtoul                        ; 3178 _ E8, 00000000(PLT r)
        jmp     ?_282                                   ; 317D _ EB, 09

?_281:  mov     eax, dword [rel erropt+14H]             ; 317F _ 8B. 05, 00000000(rel)
        add     eax, 1                                  ; 3185 _ 83. C0, 01
?_282:  mov     dword [rel erropt+14H], eax             ; 3188 _ 89. 05, 00000000(rel)
        jmp     ?_297                                   ; 318E _ E9, 0000011D

?_283:  mov     byte [rel reproducible], 1              ; 3193 _ C6. 05, 00000000(rel), 01
        jmp     ?_298                                   ; 319A _ E9, 00000112

?_284:  mov     rax, qword [rbp-48H]                    ; 319F _ 48: 8B. 45, B8
        mov     esi, 61                                 ; 31A3 _ BE, 0000003D
        mov     rdi, rax                                ; 31A8 _ 48: 89. C7
        call    strchr                                  ; 31AB _ E8, 00000000(PLT r)
        mov     qword [rbp-18H], rax                    ; 31B0 _ 48: 89. 45, E8
        cmp     qword [rbp-18H], 0                      ; 31B4 _ 48: 83. 7D, E8, 00
        jnz     ?_285                                   ; 31B9 _ 75, 25
        mov     rax, qword [rbp-68H]                    ; 31BB _ 48: 8B. 45, 98
        lea     rcx, [rel ?_566]                        ; 31BF _ 48: 8D. 0D, 00000000(rel)
        mov     rdx, rax                                ; 31C6 _ 48: 89. C2
        mov     rsi, rcx                                ; 31C9 _ 48: 89. CE
        mov     edi, 168                                ; 31CC _ BF, 000000A8
        mov     eax, 0                                  ; 31D1 _ B8, 00000000
        call    nasm_error                              ; 31D6 _ E8, 00000000(PLT r)
        jmp     ?_298                                   ; 31DB _ E9, 000000D1

?_285:  mov     rax, qword [rbp-18H]                    ; 31E0 _ 48: 8B. 45, E8
        mov     byte [rax], 0                           ; 31E4 _ C6. 00, 00
        mov     edi, 24                                 ; 31E7 _ BF, 00000018
        call    nasm_malloc                             ; 31EC _ E8, 00000000(PLT r)
        mov     qword [rbp-10H], rax                    ; 31F1 _ 48: 89. 45, F0
        mov     rdx, qword [rel debug_prefixes]         ; 31F5 _ 48: 8B. 15, 00000000(rel)
        mov     rax, qword [rbp-10H]                    ; 31FC _ 48: 8B. 45, F0
        mov     qword [rax], rdx                        ; 3200 _ 48: 89. 10
        mov     rax, qword [rbp-48H]                    ; 3203 _ 48: 8B. 45, B8
        mov     rdi, rax                                ; 3207 _ 48: 89. C7
        call    nasm_strdup                             ; 320A _ E8, 00000000(PLT r)
        mov     rdx, rax                                ; 320F _ 48: 89. C2
        mov     rax, qword [rbp-10H]                    ; 3212 _ 48: 8B. 45, F0
        mov     qword [rax+8H], rdx                     ; 3216 _ 48: 89. 50, 08
        mov     rax, qword [rbp-18H]                    ; 321A _ 48: 8B. 45, E8
        add     rax, 1                                  ; 321E _ 48: 83. C0, 01
        mov     rdi, rax                                ; 3222 _ 48: 89. C7
        call    nasm_strdup                             ; 3225 _ E8, 00000000(PLT r)
        mov     rdx, rax                                ; 322A _ 48: 89. C2
        mov     rax, qword [rbp-10H]                    ; 322D _ 48: 8B. 45, F0
        mov     qword [rax+10H], rdx                    ; 3231 _ 48: 89. 50, 10
        mov     rax, qword [rbp-10H]                    ; 3235 _ 48: 8B. 45, F0
        mov     qword [rel debug_prefixes], rax         ; 3239 _ 48: 89. 05, 00000000(rel)
        mov     rax, qword [rbp-18H]                    ; 3240 _ 48: 8B. 45, E8
        mov     byte [rax], 61                          ; 3244 _ C6. 00, 3D
        jmp     ?_298                                   ; 3247 _ EB, 68

?_286:  mov     rax, qword [rbp-48H]                    ; 3249 _ 48: 8B. 45, B8
        test    rax, rax                                ; 324D _ 48: 85. C0
        jnz     ?_287                                   ; 3250 _ 75, 08
        mov     rax, qword [rbp-70H]                    ; 3252 _ 48: 8B. 45, 90
        mov     qword [rbp-48H], rax                    ; 3256 _ 48: 89. 45, B8
?_287:  mov     rdx, qword [rbp-48H]                    ; 325A _ 48: 8B. 55, B8
        mov     rax, qword [rel stdout]                 ; 325E _ 48: 8B. 05, 00000000(rel)
        mov     rsi, rdx                                ; 3265 _ 48: 89. D6
        mov     rdi, rax                                ; 3268 _ 48: 89. C7
        call    help                                    ; 326B _ E8, 00001063
        mov     edi, 0                                  ; 3270 _ BF, 00000000
        call    exit                                    ; 3275 _ E8, 00000000(PLT r)
?_288:  lea     rcx, [rel ?_567]                        ; 327A _ 48: 8D. 0D, 00000000(rel)
        lea     rax, [rel __func__.3]                   ; 3281 _ 48: 8D. 05, 00000000(rel)
        mov     edx, 1522                               ; 3288 _ BA, 000005F2
        mov     rsi, rcx                                ; 328D _ 48: 89. CE
        mov     rdi, rax                                ; 3290 _ 48: 89. C7
        call    nasm_panic_from_macro                   ; 3293 _ E8, 00000000(PLT r)
?_289:  nop                                             ; 3298 _ 90
        jmp     ?_298                                   ; 3299 _ EB, 16

?_290:  nop                                             ; 329B _ 90
        jmp     ?_298                                   ; 329C _ EB, 13

?_291:  nop                                             ; 329E _ 90
        jmp     ?_298                                   ; 329F _ EB, 10

?_292:  nop                                             ; 32A1 _ 90
        jmp     ?_298                                   ; 32A2 _ EB, 0D

?_293:  nop                                             ; 32A4 _ 90
        jmp     ?_298                                   ; 32A5 _ EB, 0A

?_294:  nop                                             ; 32A7 _ 90
        jmp     ?_298                                   ; 32A8 _ EB, 07

?_295:  nop                                             ; 32AA _ 90
        jmp     ?_298                                   ; 32AB _ EB, 04

?_296:  nop                                             ; 32AD _ 90
        jmp     ?_298                                   ; 32AE _ EB, 01

?_297:  nop                                             ; 32B0 _ 90
?_298:  cmp     qword [rbp-20H], 0                      ; 32B1 _ 48: 83. 7D, E0, 00
        jz      ?_319                                   ; 32B6 _ 74, 6D
        mov     rax, qword [rbp-20H]                    ; 32B8 _ 48: 8B. 45, E0
        mov     byte [rax], 61                          ; 32BC _ C6. 00, 3D
        jmp     ?_319                                   ; 32BF _ EB, 64

?_299:  mov     rax, qword [rbp-68H]                    ; 32C1 _ 48: 8B. 45, 98
        add     rax, 1                                  ; 32C5 _ 48: 83. C0, 01
        movzx   eax, byte [rax]                         ; 32C9 _ 0F B6. 00
        movsx   eax, al                                 ; 32CC _ 0F BE. C0
        lea     rcx, [rel ?_568]                        ; 32CF _ 48: 8D. 0D, 00000000(rel)
        mov     edx, eax                                ; 32D6 _ 89. C2
        mov     rsi, rcx                                ; 32D8 _ 48: 89. CE
        mov     edi, 128                                ; 32DB _ BF, 00000080
        mov     eax, 0                                  ; 32E0 _ B8, 00000000
        call    nasm_nonfatalf                          ; 32E5 _ E8, 00000000(PLT r)
        jmp     ?_320                                   ; 32EA _ EB, 3A

?_300:  nop                                             ; 32EC _ 90
        jmp     ?_322                                   ; 32ED _ EB, 50

?_301:  nop                                             ; 32EF _ 90
        jmp     ?_322                                   ; 32F0 _ EB, 4D

?_302:  nop                                             ; 32F2 _ 90
        jmp     ?_322                                   ; 32F3 _ EB, 4A

?_303:  nop                                             ; 32F5 _ 90
        jmp     ?_322                                   ; 32F6 _ EB, 47

?_304:  nop                                             ; 32F8 _ 90
        jmp     ?_322                                   ; 32F9 _ EB, 44

?_305:  nop                                             ; 32FB _ 90
        jmp     ?_322                                   ; 32FC _ EB, 41

?_306:  nop                                             ; 32FE _ 90
        jmp     ?_322                                   ; 32FF _ EB, 3E

?_307:  nop                                             ; 3301 _ 90
        jmp     ?_322                                   ; 3302 _ EB, 3B

?_308:  nop                                             ; 3304 _ 90
        jmp     ?_322                                   ; 3305 _ EB, 38

?_309:  nop                                             ; 3307 _ 90
        jmp     ?_322                                   ; 3308 _ EB, 35

?_310:  nop                                             ; 330A _ 90
        jmp     ?_322                                   ; 330B _ EB, 32

?_311:  nop                                             ; 330D _ 90
        jmp     ?_322                                   ; 330E _ EB, 2F

?_312:  nop                                             ; 3310 _ 90
        jmp     ?_322                                   ; 3311 _ EB, 2C

?_313:  nop                                             ; 3313 _ 90
        jmp     ?_322                                   ; 3314 _ EB, 29

?_314:  nop                                             ; 3316 _ 90
        jmp     ?_322                                   ; 3317 _ EB, 26

?_315:  nop                                             ; 3319 _ 90
        jmp     ?_322                                   ; 331A _ EB, 23

?_316:  nop                                             ; 331C _ 90
        jmp     ?_322                                   ; 331D _ EB, 20

?_317:  nop                                             ; 331F _ 90
        jmp     ?_322                                   ; 3320 _ EB, 1D

?_318:  nop                                             ; 3322 _ 90
        jmp     ?_322                                   ; 3323 _ EB, 1A

?_319:  nop                                             ; 3325 _ 90
?_320:  jmp     ?_322                                   ; 3326 _ EB, 17

?_321:  cmp     dword [rbp-74H], 2                      ; 3328 _ 83. 7D, 8C, 02
        jnz     ?_322                                   ; 332C _ 75, 11
        mov     rax, qword [rbp-68H]                    ; 332E _ 48: 8B. 45, 98
        mov     rsi, rax                                ; 3332 _ 48: 89. C6
        mov     edi, 0                                  ; 3335 _ BF, 00000000
        call    copy_filename                           ; 333A _ E8, 00000000(PLT r)
?_322:  movzx   eax, byte [rbp-51H]                     ; 333F _ 0F B6. 45, AF
?_323:  mov     rdx, qword [rbp-8H]                     ; 3343 _ 48: 8B. 55, F8
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        sub     rdx, qword [fs:abs 28H]                 ; 3347 _ 64 48: 2B. 14 25, 00000028
        jz      ?_324                                   ; 3350 _ 74, 05
        call    __stack_chk_fail                        ; 3352 _ E8, 00000000(PLT r)
?_324:  leave                                           ; 3357 _ C9
        ret                                             ; 3358 _ C3

process_respfile:; Local function
        push    rbp                                     ; 3359 _ 55
        mov     rbp, rsp                                ; 335A _ 48: 89. E5
        push    rbx                                     ; 335D _ 53
        sub     rsp, 72                                 ; 335E _ 48: 83. EC, 48
        mov     qword [rbp-48H], rdi                    ; 3362 _ 48: 89. 7D, B8
        mov     dword [rbp-4CH], esi                    ; 3366 _ 89. 75, B4
        mov     dword [rbp-38H], 128                    ; 3369 _ C7. 45, C8, 00000080
        mov     eax, dword [rbp-38H]                    ; 3370 _ 8B. 45, C8
        mov     dword [rbp-3CH], eax                    ; 3373 _ 89. 45, C4
        mov     edi, 128                                ; 3376 _ BF, 00000080
        call    nasm_malloc                             ; 337B _ E8, 00000000(PLT r)
        mov     qword [rbp-30H], rax                    ; 3380 _ 48: 89. 45, D0
        mov     edi, 128                                ; 3384 _ BF, 00000080
        call    nasm_malloc                             ; 3389 _ E8, 00000000(PLT r)
        mov     qword [rbp-20H], rax                    ; 338E _ 48: 89. 45, E0
        mov     rax, qword [rbp-20H]                    ; 3392 _ 48: 8B. 45, E0
        mov     byte [rax], 0                           ; 3396 _ C6. 00, 00
?_325:  mov     rax, qword [rbp-30H]                    ; 3399 _ 48: 8B. 45, D0
        mov     qword [rbp-28H], rax                    ; 339D _ 48: 89. 45, D8
?_326:  mov     edx, dword [rbp-3CH]                    ; 33A1 _ 8B. 55, C4
        mov     rax, qword [rbp-28H]                    ; 33A4 _ 48: 8B. 45, D8
        sub     rax, qword [rbp-30H]                    ; 33A8 _ 48: 2B. 45, D0
        mov     ecx, eax                                ; 33AC _ 89. C1
        mov     eax, edx                                ; 33AE _ 89. D0
        sub     eax, ecx                                ; 33B0 _ 29. C8
        mov     ecx, eax                                ; 33B2 _ 89. C1
        mov     rdx, qword [rbp-48H]                    ; 33B4 _ 48: 8B. 55, B8
        mov     rax, qword [rbp-28H]                    ; 33B8 _ 48: 8B. 45, D8
        mov     esi, ecx                                ; 33BC _ 89. CE
        mov     rdi, rax                                ; 33BE _ 48: 89. C7
        call    fgets                                   ; 33C1 _ E8, 00000000(PLT r)
        mov     qword [rbp-18H], rax                    ; 33C6 _ 48: 89. 45, E8
        cmp     qword [rbp-18H], 0                      ; 33CA _ 48: 83. 7D, E8, 00
        jz      ?_328                                   ; 33CF _ 74, 7F
        mov     rax, qword [rbp-28H]                    ; 33D1 _ 48: 8B. 45, D8
        mov     rdi, rax                                ; 33D5 _ 48: 89. C7
        call    strlen                                  ; 33D8 _ E8, 00000000(PLT r)
        add     qword [rbp-28H], rax                    ; 33DD _ 48: 01. 45, D8
        mov     rax, qword [rbp-28H]                    ; 33E1 _ 48: 8B. 45, D8
        cmp     qword [rbp-30H], rax                    ; 33E5 _ 48: 39. 45, D0
        jnc     ?_327                                   ; 33E9 _ 73, 0F
        mov     rax, qword [rbp-28H]                    ; 33EB _ 48: 8B. 45, D8
        sub     rax, 1                                  ; 33EF _ 48: 83. E8, 01
        movzx   eax, byte [rax]                         ; 33F3 _ 0F B6. 00
        cmp     al, 10                                  ; 33F6 _ 3C, 0A
        jz      ?_329                                   ; 33F8 _ 74, 59
?_327:  mov     rax, qword [rbp-28H]                    ; 33FA _ 48: 8B. 45, D8
        sub     rax, qword [rbp-30H]                    ; 33FE _ 48: 2B. 45, D0
        mov     rdx, rax                                ; 3402 _ 48: 89. C2
        mov     eax, dword [rbp-3CH]                    ; 3405 _ 8B. 45, C4
        sub     eax, 10                                 ; 3408 _ 83. E8, 0A
        cdqe                                            ; 340B _ 48: 98
        cmp     rdx, rax                                ; 340D _ 48: 39. C2
        jle     ?_326                                   ; 3410 _ 7E, 8F
        mov     rax, qword [rbp-28H]                    ; 3412 _ 48: 8B. 45, D8
        sub     rax, qword [rbp-30H]                    ; 3416 _ 48: 2B. 45, D0
        mov     dword [rbp-34H], eax                    ; 341A _ 89. 45, CC
        sub     dword [rbp-3CH], -128                   ; 341D _ 83. 6D, C4, 80
        mov     eax, dword [rbp-3CH]                    ; 3421 _ 8B. 45, C4
        movsxd  rdx, eax                                ; 3424 _ 48: 63. D0
        mov     rax, qword [rbp-30H]                    ; 3427 _ 48: 8B. 45, D0
        mov     rsi, rdx                                ; 342B _ 48: 89. D6
        mov     rdi, rax                                ; 342E _ 48: 89. C7
        call    nasm_realloc                            ; 3431 _ E8, 00000000(PLT r)
        mov     qword [rbp-30H], rax                    ; 3436 _ 48: 89. 45, D0
        mov     eax, dword [rbp-34H]                    ; 343A _ 8B. 45, CC
        movsxd  rdx, eax                                ; 343D _ 48: 63. D0
        mov     rax, qword [rbp-30H]                    ; 3440 _ 48: 8B. 45, D0
        add     rax, rdx                                ; 3444 _ 48: 01. D0
        mov     qword [rbp-28H], rax                    ; 3447 _ 48: 89. 45, D8
        jmp     ?_326                                   ; 344B _ E9, FFFFFF51

?_328:  nop                                             ; 3450 _ 90
        jmp     ?_330                                   ; 3451 _ EB, 01

?_329:  nop                                             ; 3453 _ 90
?_330:  cmp     qword [rbp-18H], 0                      ; 3454 _ 48: 83. 7D, E8, 00
        jnz     ?_332                                   ; 3459 _ 75, 46
        mov     rax, qword [rbp-28H]                    ; 345B _ 48: 8B. 45, D8
        cmp     rax, qword [rbp-30H]                    ; 345F _ 48: 3B. 45, D0
        jnz     ?_332                                   ; 3463 _ 75, 3C
        mov     rax, qword [rbp-20H]                    ; 3465 _ 48: 8B. 45, E0
        movzx   eax, byte [rax]                         ; 3469 _ 0F B6. 00
        test    al, al                                  ; 346C _ 84. C0
        jz      ?_331                                   ; 346E _ 74, 14
        mov     edx, dword [rbp-4CH]                    ; 3470 _ 8B. 55, B4
        mov     rax, qword [rbp-20H]                    ; 3473 _ 48: 8B. 45, E0
        mov     esi, 0                                  ; 3477 _ BE, 00000000
        mov     rdi, rax                                ; 347C _ 48: 89. C7
        call    process_arg                             ; 347F _ E8, FFFFEED1
?_331:  mov     rax, qword [rbp-30H]                    ; 3484 _ 48: 8B. 45, D0
        mov     rdi, rax                                ; 3488 _ 48: 89. C7
        call    nasm_free                               ; 348B _ E8, 00000000(PLT r)
        mov     rax, qword [rbp-20H]                    ; 3490 _ 48: 8B. 45, E0
        mov     rdi, rax                                ; 3494 _ 48: 89. C7
        call    nasm_free                               ; 3497 _ E8, 00000000(PLT r)
        jmp     ?_338                                   ; 349C _ E9, 000000DB

?_332:  lea     rdx, [rel ?_569]                        ; 34A1 _ 48: 8D. 15, 00000000(rel)
        mov     rax, qword [rbp-30H]                    ; 34A8 _ 48: 8B. 45, D0
        mov     rsi, rdx                                ; 34AC _ 48: 89. D6
        mov     rdi, rax                                ; 34AF _ 48: 89. C7
        call    strcspn                                 ; 34B2 _ E8, 00000000(PLT r)
        mov     rdx, qword [rbp-30H]                    ; 34B7 _ 48: 8B. 55, D0
        add     rax, rdx                                ; 34BB _ 48: 01. D0
        mov     qword [rbp-28H], rax                    ; 34BE _ 48: 89. 45, D8
        mov     rax, qword [rbp-28H]                    ; 34C2 _ 48: 8B. 45, D8
        mov     byte [rax], 0                           ; 34C6 _ C6. 00, 00
        jmp     ?_334                                   ; 34C9 _ EB, 0C

?_333:  sub     qword [rbp-28H], 1                      ; 34CB _ 48: 83. 6D, D8, 01
        mov     rax, qword [rbp-28H]                    ; 34D0 _ 48: 8B. 45, D8
        mov     byte [rax], 0                           ; 34D4 _ C6. 00, 00
?_334:  mov     rax, qword [rbp-28H]                    ; 34D7 _ 48: 8B. 45, D8
        cmp     qword [rbp-30H], rax                    ; 34DB _ 48: 39. 45, D0
        jnc     ?_335                                   ; 34DF _ 73, 19
        mov     rax, qword [rbp-28H]                    ; 34E1 _ 48: 8B. 45, D8
        sub     rax, 1                                  ; 34E5 _ 48: 83. E8, 01
        movzx   eax, byte [rax]                         ; 34E9 _ 0F B6. 00
        movsx   eax, al                                 ; 34EC _ 0F BE. C0
        mov     edi, eax                                ; 34EF _ 89. C7
        call    nasm_isspace                            ; 34F1 _ E8, FFFFCBB7
        test    al, al                                  ; 34F6 _ 84. C0
        jnz     ?_333                                   ; 34F8 _ 75, D1
?_335:  mov     rax, qword [rbp-30H]                    ; 34FA _ 48: 8B. 45, D0
        mov     rdi, rax                                ; 34FE _ 48: 89. C7
        call    nasm_skip_spaces                        ; 3501 _ E8, 00000000(PLT r)
        mov     qword [rbp-28H], rax                    ; 3506 _ 48: 89. 45, D8
        mov     edx, dword [rbp-4CH]                    ; 350A _ 8B. 55, B4
        mov     rcx, qword [rbp-28H]                    ; 350D _ 48: 8B. 4D, D8
        mov     rax, qword [rbp-20H]                    ; 3511 _ 48: 8B. 45, E0
        mov     rsi, rcx                                ; 3515 _ 48: 89. CE
        mov     rdi, rax                                ; 3518 _ 48: 89. C7
        call    process_arg                             ; 351B _ E8, FFFFEE35
        test    al, al                                  ; 3520 _ 84. C0
        jz      ?_336                                   ; 3522 _ 74, 07
        mov     rax, qword [rbp-28H]                    ; 3524 _ 48: 8B. 45, D8
        mov     byte [rax], 0                           ; 3528 _ C6. 00, 00
?_336:  mov     eax, dword [rbp-38H]                    ; 352B _ 8B. 45, C8
        lea     ebx, [rax-9H]                           ; 352E _ 8D. 58, F7
        mov     rax, qword [rbp-28H]                    ; 3531 _ 48: 8B. 45, D8
        mov     rdi, rax                                ; 3535 _ 48: 89. C7
        call    strlen                                  ; 3538 _ E8, 00000000(PLT r)
        cmp     ebx, eax                                ; 353D _ 39. C3
        jg      ?_337                                   ; 353F _ 7F, 1D
        sub     dword [rbp-38H], -128                   ; 3541 _ 83. 6D, C8, 80
        mov     eax, dword [rbp-38H]                    ; 3545 _ 8B. 45, C8
        movsxd  rdx, eax                                ; 3548 _ 48: 63. D0
        mov     rax, qword [rbp-20H]                    ; 354B _ 48: 8B. 45, E0
        mov     rsi, rdx                                ; 354F _ 48: 89. D6
        mov     rdi, rax                                ; 3552 _ 48: 89. C7
        call    nasm_realloc                            ; 3555 _ E8, 00000000(PLT r)
        mov     qword [rbp-20H], rax                    ; 355A _ 48: 89. 45, E0
?_337:  mov     eax, dword [rbp-38H]                    ; 355E _ 8B. 45, C8
        movsxd  rdx, eax                                ; 3561 _ 48: 63. D0
        mov     rcx, qword [rbp-28H]                    ; 3564 _ 48: 8B. 4D, D8
        mov     rax, qword [rbp-20H]                    ; 3568 _ 48: 8B. 45, E0
        mov     rsi, rcx                                ; 356C _ 48: 89. CE
        mov     rdi, rax                                ; 356F _ 48: 89. C7
        call    strncpy                                 ; 3572 _ E8, 00000000(PLT r)
        jmp     ?_325                                   ; 3577 _ E9, FFFFFE1D

?_338:  ; Local function
        nop                                             ; 357C _ 90
        mov     rbx, qword [rbp-8H]                     ; 357D _ 48: 8B. 5D, F8
        leave                                           ; 3581 _ C9
        ret                                             ; 3582 _ C3

process_args:; Local function
        push    rbp                                     ; 3583 _ 55
        mov     rbp, rsp                                ; 3584 _ 48: 89. E5
        sub     rsp, 64                                 ; 3587 _ 48: 83. EC, 40
        mov     qword [rbp-38H], rdi                    ; 358B _ 48: 89. 7D, C8
        mov     dword [rbp-3CH], esi                    ; 358F _ 89. 75, C4
        mov     byte [rbp-21H], 32                      ; 3592 _ C6. 45, DF, 20
        mov     rax, qword [rbp-38H]                    ; 3596 _ 48: 8B. 45, C8
        mov     qword [rbp-20H], rax                    ; 359A _ 48: 89. 45, E0
        mov     rax, qword [rbp-20H]                    ; 359E _ 48: 8B. 45, E0
        movzx   eax, byte [rax]                         ; 35A2 _ 0F B6. 00
        test    al, al                                  ; 35A5 _ 84. C0
        jz      ?_339                                   ; 35A7 _ 74, 1D
        mov     rax, qword [rbp-20H]                    ; 35A9 _ 48: 8B. 45, E0
        movzx   eax, byte [rax]                         ; 35AD _ 0F B6. 00
        cmp     al, 45                                  ; 35B0 _ 3C, 2D
        jz      ?_339                                   ; 35B2 _ 74, 12
        mov     rax, qword [rbp-20H]                    ; 35B4 _ 48: 8B. 45, E0
        lea     rdx, [rax+1H]                           ; 35B8 _ 48: 8D. 50, 01
        mov     qword [rbp-20H], rdx                    ; 35BC _ 48: 89. 55, E0
        movzx   eax, byte [rax]                         ; 35C0 _ 0F B6. 00
        mov     byte [rbp-21H], al                      ; 35C3 _ 88. 45, DF
?_339:  mov     qword [rbp-18H], 0                      ; 35C6 _ 48: C7. 45, E8, 00000000
        jmp     ?_345                                   ; 35CE _ EB, 75

?_340:  mov     rax, qword [rbp-20H]                    ; 35D0 _ 48: 8B. 45, E0
        mov     qword [rbp-10H], rax                    ; 35D4 _ 48: 89. 45, F0
        jmp     ?_342                                   ; 35D8 _ EB, 05

?_341:  add     qword [rbp-20H], 1                      ; 35DA _ 48: 83. 45, E0, 01
?_342:  mov     rax, qword [rbp-20H]                    ; 35DF _ 48: 8B. 45, E0
        movzx   eax, byte [rax]                         ; 35E3 _ 0F B6. 00
        test    al, al                                  ; 35E6 _ 84. C0
        jz      ?_344                                   ; 35E8 _ 74, 1D
        mov     rax, qword [rbp-20H]                    ; 35EA _ 48: 8B. 45, E0
        movzx   eax, byte [rax]                         ; 35EE _ 0F B6. 00
        cmp     byte [rbp-21H], al                      ; 35F1 _ 38. 45, DF
        jnz     ?_341                                   ; 35F4 _ 75, E4
        jmp     ?_344                                   ; 35F6 _ EB, 0F

?_343:  mov     rax, qword [rbp-20H]                    ; 35F8 _ 48: 8B. 45, E0
        lea     rdx, [rax+1H]                           ; 35FC _ 48: 8D. 50, 01
        mov     qword [rbp-20H], rdx                    ; 3600 _ 48: 89. 55, E0
        mov     byte [rax], 0                           ; 3604 _ C6. 00, 00
?_344:  mov     rax, qword [rbp-20H]                    ; 3607 _ 48: 8B. 45, E0
        movzx   eax, byte [rax]                         ; 360B _ 0F B6. 00
        cmp     byte [rbp-21H], al                      ; 360E _ 38. 45, DF
        jz      ?_343                                   ; 3611 _ 74, E5
        mov     rax, qword [rbp-18H]                    ; 3613 _ 48: 8B. 45, E8
        mov     qword [rbp-8H], rax                     ; 3617 _ 48: 89. 45, F8
        mov     rax, qword [rbp-10H]                    ; 361B _ 48: 8B. 45, F0
        mov     qword [rbp-18H], rax                    ; 361F _ 48: 89. 45, E8
        mov     edx, dword [rbp-3CH]                    ; 3623 _ 8B. 55, C4
        mov     rcx, qword [rbp-18H]                    ; 3626 _ 48: 8B. 4D, E8
        mov     rax, qword [rbp-8H]                     ; 362A _ 48: 8B. 45, F8
        mov     rsi, rcx                                ; 362E _ 48: 89. CE
        mov     rdi, rax                                ; 3631 _ 48: 89. C7
        call    process_arg                             ; 3634 _ E8, FFFFED1C
        test    al, al                                  ; 3639 _ 84. C0
        jz      ?_345                                   ; 363B _ 74, 08
        mov     qword [rbp-18H], 0                      ; 363D _ 48: C7. 45, E8, 00000000
?_345:  mov     rax, qword [rbp-20H]                    ; 3645 _ 48: 8B. 45, E0
        movzx   eax, byte [rax]                         ; 3649 _ 0F B6. 00
        test    al, al                                  ; 364C _ 84. C0
        jnz     ?_340                                   ; 364E _ 75, 80
        cmp     qword [rbp-18H], 0                      ; 3650 _ 48: 83. 7D, E8, 00
        jz      ?_346                                   ; 3655 _ 74, 14
        mov     edx, dword [rbp-3CH]                    ; 3657 _ 8B. 55, C4
        mov     rax, qword [rbp-18H]                    ; 365A _ 48: 8B. 45, E8
        mov     esi, 0                                  ; 365E _ BE, 00000000
        mov     rdi, rax                                ; 3663 _ 48: 89. C7
        call    process_arg                             ; 3666 _ E8, FFFFECEA
?_346:  nop                                             ; 366B _ 90
        leave                                           ; 366C _ C9
        ret                                             ; 366D _ C3

process_response_file:; Local function
        push    rbp                                     ; 366E _ 55
        mov     rbp, rsp                                ; 366F _ 48: 89. E5
        sub     rsp, 2096                               ; 3672 _ 48: 81. EC, 00000830
        mov     qword [rbp-828H], rdi                   ; 3679 _ 48: 89. BD, FFFFF7D8
        mov     dword [rbp-82CH], esi                   ; 3680 _ 89. B5, FFFFF7D4
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        mov     rax, qword [fs:abs 28H]                 ; 3686 _ 64 48: 8B. 04 25, 00000028
        mov     qword [rbp-8H], rax                     ; 368F _ 48: 89. 45, F8
        xor     eax, eax                                ; 3693 _ 31. C0
        mov     rax, qword [rbp-828H]                   ; 3695 _ 48: 8B. 85, FFFFF7D8
        mov     esi, 1                                  ; 369C _ BE, 00000001
        mov     rdi, rax                                ; 36A1 _ 48: 89. C7
        call    nasm_open_read                          ; 36A4 _ E8, 00000000(PLT r)
        mov     qword [rbp-818H], rax                   ; 36A9 _ 48: 89. 85, FFFFF7E8
        cmp     qword [rbp-818H], 0                     ; 36B0 _ 48: 83. BD, FFFFF7E8, 00
        jnz     ?_348                                   ; 36B8 _ 75, 30
        mov     rax, qword [rbp-828H]                   ; 36BA _ 48: 8B. 85, FFFFF7D8
        mov     rdi, rax                                ; 36C1 _ 48: 89. C7
        call    perror                                  ; 36C4 _ E8, 00000000(PLT r)
        mov     edi, 4294967295                         ; 36C9 _ BF, FFFFFFFF
        call    exit                                    ; 36CE _ E8, 00000000(PLT r)
?_347:  mov     edx, dword [rbp-82CH]                   ; 36D3 _ 8B. 95, FFFFF7D4
        lea     rax, [rbp-810H]                         ; 36D9 _ 48: 8D. 85, FFFFF7F0
        mov     esi, edx                                ; 36E0 _ 89. D6
        mov     rdi, rax                                ; 36E2 _ 48: 89. C7
        call    process_args                            ; 36E5 _ E8, FFFFFE99
?_348:  mov     rdx, qword [rbp-818H]                   ; 36EA _ 48: 8B. 95, FFFFF7E8
        lea     rax, [rbp-810H]                         ; 36F1 _ 48: 8D. 85, FFFFF7F0
        mov     esi, 2048                               ; 36F8 _ BE, 00000800
        mov     rdi, rax                                ; 36FD _ 48: 89. C7
        call    fgets                                   ; 3700 _ E8, 00000000(PLT r)
        test    rax, rax                                ; 3705 _ 48: 85. C0
        jnz     ?_347                                   ; 3708 _ 75, C9
        mov     rax, qword [rbp-818H]                   ; 370A _ 48: 8B. 85, FFFFF7E8
        mov     rdi, rax                                ; 3711 _ 48: 89. C7
        call    fclose                                  ; 3714 _ E8, 00000000(PLT r)
        nop                                             ; 3719 _ 90
        mov     rax, qword [rbp-8H]                     ; 371A _ 48: 8B. 45, F8
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        sub     rax, qword [fs:abs 28H]                 ; 371E _ 64 48: 2B. 04 25, 00000028
        jz      ?_349                                   ; 3727 _ 74, 05
        call    __stack_chk_fail                        ; 3729 _ E8, 00000000(PLT r)
?_349:  leave                                           ; 372E _ C9
        ret                                             ; 372F _ C3

open_and_process_respfile:; Local function
        push    rbp                                     ; 3730 _ 55
        mov     rbp, rsp                                ; 3731 _ 48: 89. E5
        sub     rsp, 32                                 ; 3734 _ 48: 83. EC, 20
        mov     qword [rbp-18H], rdi                    ; 3738 _ 48: 89. 7D, E8
        mov     dword [rbp-1CH], esi                    ; 373C _ 89. 75, E4
        mov     rax, qword [rbp-18H]                    ; 373F _ 48: 8B. 45, E8
        mov     esi, 1                                  ; 3743 _ BE, 00000001
        mov     rdi, rax                                ; 3748 _ 48: 89. C7
        call    nasm_open_read                          ; 374B _ E8, 00000000(PLT r)
        mov     qword [rbp-8H], rax                     ; 3750 _ 48: 89. 45, F8
        cmp     qword [rbp-8H], 0                       ; 3754 _ 48: 83. 7D, F8, 00
        jz      ?_350                                   ; 3759 _ 74, 1F
        mov     edx, dword [rbp-1CH]                    ; 375B _ 8B. 55, E4
        mov     rax, qword [rbp-8H]                     ; 375E _ 48: 8B. 45, F8
        mov     esi, edx                                ; 3762 _ 89. D6
        mov     rdi, rax                                ; 3764 _ 48: 89. C7
        call    process_respfile                        ; 3767 _ E8, FFFFFBED
        mov     rax, qword [rbp-8H]                     ; 376C _ 48: 8B. 45, F8
        mov     rdi, rax                                ; 3770 _ 48: 89. C7
        call    fclose                                  ; 3773 _ E8, 00000000(PLT r)
        jmp     ?_351                                   ; 3778 _ EB, 20

?_350:  mov     rax, qword [rbp-18H]                    ; 377A _ 48: 8B. 45, E8
        lea     rcx, [rel ?_570]                        ; 377E _ 48: 8D. 0D, 00000000(rel)
        mov     rdx, rax                                ; 3785 _ 48: 89. C2
        mov     rsi, rcx                                ; 3788 _ 48: 89. CE
        mov     edi, 8192                               ; 378B _ BF, 00002000
        mov     eax, 0                                  ; 3790 _ B8, 00000000
        call    nasm_fatalf                             ; 3795 _ E8, 00000000(PLT r)
?_351:  leave                                           ; 379A _ C9
        ret                                             ; 379B _ C3

open_errfile:; Local function
        push    rbp                                     ; 379C _ 55
        mov     rbp, rsp                                ; 379D _ 48: 89. E5
        sub     rsp, 16                                 ; 37A0 _ 48: 83. EC, 10
        mov     qword [rbp-8H], rdi                     ; 37A4 _ 48: 89. 7D, F8
        cmp     qword [rbp-8H], 0                       ; 37A8 _ 48: 83. 7D, F8, 00
        jz      ?_353                                   ; 37AD _ 74, 79
        mov     rax, qword [rbp-8H]                     ; 37AF _ 48: 8B. 45, F8
        movzx   eax, byte [rax]                         ; 37B3 _ 0F B6. 00
        test    al, al                                  ; 37B6 _ 84. C0
        jz      ?_353                                   ; 37B8 _ 74, 6E
        mov     rax, qword [rbp-8H]                     ; 37BA _ 48: 8B. 45, F8
        movzx   eax, byte [rax]                         ; 37BE _ 0F B6. 00
        cmp     al, 45                                  ; 37C1 _ 3C, 2D
        jnz     ?_352                                   ; 37C3 _ 75, 1F
        mov     rax, qword [rbp-8H]                     ; 37C5 _ 48: 8B. 45, F8
        add     rax, 1                                  ; 37C9 _ 48: 83. C0, 01
        movzx   eax, byte [rax]                         ; 37CD _ 0F B6. 00
        test    al, al                                  ; 37D0 _ 84. C0
        jnz     ?_352                                   ; 37D2 _ 75, 10
        mov     rax, qword [rel stdout]                 ; 37D4 _ 48: 8B. 05, 00000000(rel)
        mov     qword [rel erropt], rax                 ; 37DB _ 48: 89. 05, 00000000(rel)
        jmp     ?_354                                   ; 37E2 _ EB, 45

?_352:  mov     rax, qword [rbp-8H]                     ; 37E4 _ 48: 8B. 45, F8
        mov     esi, 1                                  ; 37E8 _ BE, 00000001
        mov     rdi, rax                                ; 37ED _ 48: 89. C7
        call    nasm_open_write                         ; 37F0 _ E8, 00000000(PLT r)
        mov     qword [rel erropt], rax                 ; 37F5 _ 48: 89. 05, 00000000(rel)
        mov     rax, qword [rel erropt]                 ; 37FC _ 48: 8B. 05, 00000000(rel)
        test    rax, rax                                ; 3803 _ 48: 85. C0
        jnz     ?_354                                   ; 3806 _ 75, 21
        mov     rax, qword [rbp-8H]                     ; 3808 _ 48: 8B. 45, F8
        lea     rcx, [rel ?_571]                        ; 380C _ 48: 8D. 0D, 00000000(rel)
        mov     rdx, rax                                ; 3813 _ 48: 89. C2
        mov     rsi, rcx                                ; 3816 _ 48: 89. CE
        mov     edi, 8192                               ; 3819 _ BF, 00002000
        mov     eax, 0                                  ; 381E _ B8, 00000000
        call    nasm_fatalf                             ; 3823 _ E8, 00000000(PLT r)
?_353:  nop                                             ; 3828 _ 90
?_354:  leave                                           ; 3829 _ C9
        ret                                             ; 382A _ C3

parse_cmdline:; Local function
        push    rbp                                     ; 382B _ 55
        mov     rbp, rsp                                ; 382C _ 48: 89. E5
        sub     rsp, 48                                 ; 382F _ 48: 83. EC, 30
        mov     dword [rbp-24H], edi                    ; 3833 _ 89. 7D, DC
        mov     qword [rbp-30H], rsi                    ; 3836 _ 48: 89. 75, D0
        mov     dword [rbp-28H], edx                    ; 383A _ 89. 55, D8
        mov     qword [rbp-10H], 0                      ; 383D _ 48: C7. 45, F0, 00000000
        mov     rax, qword [rel warning_default]        ; 3845 _ 48: 8B. 05, 00000000(rel)
        mov     rdx, qword [rel warning_default+8H]     ; 384C _ 48: 8B. 15, 00000000(rel)
        mov     qword [rel warning_state], rax          ; 3853 _ 48: 89. 05, 00000000(rel)
        mov     qword [rel warning_state+8H], rdx       ; 385A _ 48: 89. 15, 00000000(rel)
        mov     rax, qword [rel warning_default+10H]    ; 3861 _ 48: 8B. 05, 00000000(rel)
        mov     rdx, qword [rel warning_default+18H]    ; 3868 _ 48: 8B. 15, 00000000(rel)
        mov     qword [rel warning_state+10H], rax      ; 386F _ 48: 89. 05, 00000000(rel)
        mov     qword [rel warning_state+18H], rdx      ; 3876 _ 48: 89. 15, 00000000(rel)
        mov     rax, qword [rel warning_default+20H]    ; 387D _ 48: 8B. 05, 00000000(rel)
        mov     rdx, qword [rel warning_default+28H]    ; 3884 _ 48: 8B. 15, 00000000(rel)
        mov     qword [rel warning_state+20H], rax      ; 388B _ 48: 89. 05, 00000000(rel)
        mov     qword [rel warning_state+28H], rdx      ; 3892 _ 48: 89. 15, 00000000(rel)
        mov     rax, qword [rel warning_default+30H]    ; 3899 _ 48: 8B. 05, 00000000(rel)
        mov     rdx, qword [rel warning_default+38H]    ; 38A0 _ 48: 8B. 15, 00000000(rel)
        mov     qword [rel warning_state+30H], rax      ; 38A7 _ 48: 89. 05, 00000000(rel)
        mov     qword [rel warning_state+38H], rdx      ; 38AE _ 48: 89. 15, 00000000(rel)
; Note: Memory operand is misaligned. Performance penalty
        mov     rax, qword [rel warning_default+3DH]    ; 38B5 _ 48: 8B. 05, 00000000(rel)
; Note: Memory operand is misaligned. Performance penalty
        mov     qword [rel warning_state+3DH], rax      ; 38BC _ 48: 89. 05, 00000000(rel)
        lea     rax, [rel ?_572]                        ; 38C3 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 38CA _ 48: 89. C7
        call    getenv                                  ; 38CD _ E8, 00000000(PLT r)
        mov     qword [rbp-8H], rax                     ; 38D2 _ 48: 89. 45, F8
        cmp     qword [rbp-8H], 0                       ; 38D6 _ 48: 83. 7D, F8, 00
        je      ?_359                                   ; 38DB _ 0F 84, 000000A3
        mov     rax, qword [rbp-8H]                     ; 38E1 _ 48: 8B. 45, F8
        mov     rdi, rax                                ; 38E5 _ 48: 89. C7
        call    nasm_strdup                             ; 38E8 _ E8, 00000000(PLT r)
        mov     qword [rbp-10H], rax                    ; 38ED _ 48: 89. 45, F0
        mov     edx, dword [rbp-28H]                    ; 38F1 _ 8B. 55, D8
        mov     rax, qword [rbp-10H]                    ; 38F4 _ 48: 8B. 45, F0
        mov     esi, edx                                ; 38F8 _ 89. D6
        mov     rdi, rax                                ; 38FA _ 48: 89. C7
        call    process_args                            ; 38FD _ E8, FFFFFC81
        mov     rax, qword [rbp-10H]                    ; 3902 _ 48: 8B. 45, F0
        mov     rdi, rax                                ; 3906 _ 48: 89. C7
        call    nasm_free                               ; 3909 _ E8, 00000000(PLT r)
        jmp     ?_359                                   ; 390E _ EB, 74

?_355:  add     qword [rbp-30H], 8                      ; 3910 _ 48: 83. 45, D0, 08
        mov     rax, qword [rbp-30H]                    ; 3915 _ 48: 8B. 45, D0
        mov     rax, qword [rax]                        ; 3919 _ 48: 8B. 00
        movzx   eax, byte [rax]                         ; 391C _ 0F B6. 00
        cmp     al, 64                                  ; 391F _ 3C, 40
        jnz     ?_356                                   ; 3921 _ 75, 21
        mov     rax, qword [rbp-30H]                    ; 3923 _ 48: 8B. 45, D0
        mov     rax, qword [rax]                        ; 3927 _ 48: 8B. 00
        lea     rdx, [rax+1H]                           ; 392A _ 48: 8D. 50, 01
        mov     eax, dword [rbp-28H]                    ; 392E _ 8B. 45, D8
        mov     esi, eax                                ; 3931 _ 89. C6
        mov     rdi, rdx                                ; 3933 _ 48: 89. D7
        call    process_response_file                   ; 3936 _ E8, FFFFFD33
        sub     dword [rbp-24H], 1                      ; 393B _ 83. 6D, DC, 01
        add     qword [rbp-30H], 8                      ; 393F _ 48: 83. 45, D0, 08
?_356:  cmp     dword [rbp-24H], 1                      ; 3944 _ 83. 7D, DC, 01
        jle     ?_357                                   ; 3948 _ 7E, 0A
        mov     rax, qword [rbp-30H]                    ; 394A _ 48: 8B. 45, D0
        mov     rax, qword [rax+8H]                     ; 394E _ 48: 8B. 40, 08
        jmp     ?_358                                   ; 3952 _ EB, 05

?_357:  mov     eax, 0                                  ; 3954 _ B8, 00000000
?_358:  mov     rdx, qword [rbp-30H]                    ; 3959 _ 48: 8B. 55, D0
        mov     rcx, qword [rdx]                        ; 395D _ 48: 8B. 0A
        mov     edx, dword [rbp-28H]                    ; 3960 _ 8B. 55, D8
        mov     rsi, rax                                ; 3963 _ 48: 89. C6
        mov     rdi, rcx                                ; 3966 _ 48: 89. CF
        call    process_arg                             ; 3969 _ E8, FFFFE9E7
        mov     byte [rbp-11H], al                      ; 396E _ 88. 45, EF
        movzx   eax, byte [rbp-11H]                     ; 3971 _ 0F B6. 45, EF
        shl     rax, 3                                  ; 3975 _ 48: C1. E0, 03
        add     qword [rbp-30H], rax                    ; 3979 _ 48: 01. 45, D0
        movzx   eax, byte [rbp-11H]                     ; 397D _ 0F B6. 45, EF
        sub     dword [rbp-24H], eax                    ; 3981 _ 29. 45, DC
?_359:  sub     dword [rbp-24H], 1                      ; 3984 _ 83. 6D, DC, 01
        cmp     dword [rbp-24H], 0                      ; 3988 _ 83. 7D, DC, 00
        jnz     ?_355                                   ; 398C _ 75, 82
        cmp     dword [rbp-28H], 2                      ; 398E _ 83. 7D, D8, 02
        jnz     ?_361                                   ; 3992 _ 75, 60
        mov     edi, 0                                  ; 3994 _ BF, 00000000
        call    get_filename                            ; 3999 _ E8, FFFFC927
        test    rax, rax                                ; 399E _ 48: 85. C0
        jnz     ?_360                                   ; 39A1 _ 75, 19
        lea     rax, [rel ?_573]                        ; 39A3 _ 48: 8D. 05, 00000000(rel)
        mov     rsi, rax                                ; 39AA _ 48: 89. C6
        mov     edi, 128                                ; 39AD _ BF, 00000080
        mov     eax, 0                                  ; 39B2 _ B8, 00000000
        call    nasm_fatalf                             ; 39B7 _ E8, 00000000(PLT r)
?_360:  mov     edi, 0                                  ; 39BC _ BF, 00000000
        call    get_filename                            ; 39C1 _ E8, FFFFC8FF
        mov     rdi, rax                                ; 39C6 _ 48: 89. C7
        call    debug_prefix_remap                      ; 39C9 _ E8, FFFFE458
        mov     rsi, rax                                ; 39CE _ 48: 89. C6
        mov     edi, 7                                  ; 39D1 _ BF, 00000007
        call    set_filename                            ; 39D6 _ E8, 00000000(PLT r)
        call    check_overwrite_files                   ; 39DB _ E8, 00000000(PLT r)
        mov     edi, 2                                  ; 39E0 _ BF, 00000002
        call    get_filename                            ; 39E5 _ E8, FFFFC8DB
        mov     rdi, rax                                ; 39EA _ 48: 89. C7
        call    open_errfile                            ; 39ED _ E8, FFFFFDAA
        jmp     ?_362                                   ; 39F2 _ EB, 01

?_361:  nop                                             ; 39F4 _ 90
?_362:  leave                                           ; 39F5 _ C9
        ret                                             ; 39F6 _ C3

forward_refs:; Local function
        push    rbp                                     ; 39F7 _ 55
        mov     rbp, rsp                                ; 39F8 _ 48: 89. E5
        sub     rsp, 32                                 ; 39FB _ 48: 83. EC, 20
        mov     qword [rbp-18H], rdi                    ; 39FF _ 48: 89. 7D, E8
        mov     rax, qword [rbp-18H]                    ; 3A03 _ 48: 8B. 45, E8
        mov     eax, dword [rax+94H]                    ; 3A07 _ 8B. 80, 00000094
        and     eax, 10H                                ; 3A0D _ 83. E0, 10
        test    eax, eax                                ; 3A10 _ 85. C0
        jne     ?_368                                   ; 3A12 _ 0F 85, 00000144
        mov     rax, qword [rel forwref]                ; 3A18 _ 48: 8B. 05, 00000000(rel)
        test    rax, rax                                ; 3A1F _ 48: 85. C0
        je      ?_369                                   ; 3A22 _ 0F 84, 00000137
        mov     rax, qword [rel forwref]                ; 3A28 _ 48: 8B. 05, 00000000(rel)
        mov     eax, dword [rax]                        ; 3A2F _ 8B. 00
        movsxd  rdx, eax                                ; 3A31 _ 48: 63. D0
        mov     rax, qword [rel globallineno]           ; 3A34 _ 48: 8B. 05, 00000000(rel)
        cmp     rdx, rax                                ; 3A3B _ 48: 39. C2
        jne     ?_370                                   ; 3A3E _ 0F 85, 0000011E
?_363:  mov     rax, qword [rel forwref]                ; 3A44 _ 48: 8B. 05, 00000000(rel)
        mov     eax, dword [rax+4H]                     ; 3A4B _ 8B. 40, 04
        mov     rcx, qword [rbp-18H]                    ; 3A4E _ 48: 8B. 4D, E8
        movsxd  rdx, eax                                ; 3A52 _ 48: 63. D0
        mov     rax, rdx                                ; 3A55 _ 48: 89. D0
        shl     rax, 3                                  ; 3A58 _ 48: C1. E0, 03
        add     rax, rdx                                ; 3A5C _ 48: 01. D0
        shl     rax, 3                                  ; 3A5F _ 48: C1. E0, 03
        add     rax, rcx                                ; 3A63 _ 48: 01. C8
        add     rax, 248                                ; 3A66 _ 48: 05, 000000F8
        mov     edx, dword [rax]                        ; 3A6C _ 8B. 10
        mov     rax, qword [rel forwref]                ; 3A6E _ 48: 8B. 05, 00000000(rel)
        mov     eax, dword [rax+4H]                     ; 3A75 _ 8B. 40, 04
        mov     ecx, edx                                ; 3A78 _ 89. D1
        or      ecx, 01H                                ; 3A7A _ 83. C9, 01
        mov     rsi, qword [rbp-18H]                    ; 3A7D _ 48: 8B. 75, E8
        movsxd  rdx, eax                                ; 3A81 _ 48: 63. D0
        mov     rax, rdx                                ; 3A84 _ 48: 89. D0
        shl     rax, 3                                  ; 3A87 _ 48: C1. E0, 03
        add     rax, rdx                                ; 3A8B _ 48: 01. D0
        shl     rax, 3                                  ; 3A8E _ 48: C1. E0, 03
        add     rax, rsi                                ; 3A92 _ 48: 01. F0
        add     rax, 248                                ; 3A95 _ 48: 05, 000000F8
        mov     dword [rax], ecx                        ; 3A9B _ 89. 08
        mov     rax, qword [rel forwrefs]               ; 3A9D _ 48: 8B. 05, 00000000(rel)
        mov     rdi, rax                                ; 3AA4 _ 48: 89. C7
        call    saa_rstruct                             ; 3AA7 _ E8, 00000000(PLT r)
        mov     qword [rel forwref], rax                ; 3AAC _ 48: 89. 05, 00000000(rel)
        mov     rax, qword [rel forwref]                ; 3AB3 _ 48: 8B. 05, 00000000(rel)
        test    rax, rax                                ; 3ABA _ 48: 85. C0
        jz      ?_364                                   ; 3ABD _ 74, 1C
        mov     rax, qword [rel forwref]                ; 3ABF _ 48: 8B. 05, 00000000(rel)
        mov     eax, dword [rax]                        ; 3AC6 _ 8B. 00
        movsxd  rdx, eax                                ; 3AC8 _ 48: 63. D0
        mov     rax, qword [rel globallineno]           ; 3ACB _ 48: 8B. 05, 00000000(rel)
        cmp     rdx, rax                                ; 3AD2 _ 48: 39. C2
        je      ?_363                                   ; 3AD5 _ 0F 84, FFFFFF69
?_364:  call    pass_first                              ; 3ADB _ E8, FFFFC6B7
        xor     eax, 01H                                ; 3AE0 _ 83. F0, 01
        test    al, al                                  ; 3AE3 _ 84. C0
        jnz     ?_371                                   ; 3AE5 _ 75, 7E
        mov     dword [rbp-0CH], 0                      ; 3AE7 _ C7. 45, F4, 00000000
        jmp     ?_367                                   ; 3AEE _ EB, 5A

?_365:  mov     rcx, qword [rbp-18H]                    ; 3AF0 _ 48: 8B. 4D, E8
        mov     eax, dword [rbp-0CH]                    ; 3AF4 _ 8B. 45, F4
        movsxd  rdx, eax                                ; 3AF7 _ 48: 63. D0
        mov     rax, rdx                                ; 3AFA _ 48: 89. D0
        shl     rax, 3                                  ; 3AFD _ 48: C1. E0, 03
        add     rax, rdx                                ; 3B01 _ 48: 01. D0
        shl     rax, 3                                  ; 3B04 _ 48: C1. E0, 03
        add     rax, rcx                                ; 3B08 _ 48: 01. C8
        add     rax, 248                                ; 3B0B _ 48: 05, 000000F8
        mov     eax, dword [rax]                        ; 3B11 _ 8B. 00
        and     eax, 01H                                ; 3B13 _ 83. E0, 01
        test    eax, eax                                ; 3B16 _ 85. C0
        jz      ?_366                                   ; 3B18 _ 74, 2C
        mov     rax, qword [rel forwrefs]               ; 3B1A _ 48: 8B. 05, 00000000(rel)
        mov     rdi, rax                                ; 3B21 _ 48: 89. C7
        call    saa_wstruct                             ; 3B24 _ E8, 00000000(PLT r)
        mov     qword [rbp-8H], rax                     ; 3B29 _ 48: 89. 45, F8
        mov     rax, qword [rel globallineno]           ; 3B2D _ 48: 8B. 05, 00000000(rel)
        mov     edx, eax                                ; 3B34 _ 89. C2
        mov     rax, qword [rbp-8H]                     ; 3B36 _ 48: 8B. 45, F8
        mov     dword [rax], edx                        ; 3B3A _ 89. 10
        mov     rax, qword [rbp-8H]                     ; 3B3C _ 48: 8B. 45, F8
        mov     edx, dword [rbp-0CH]                    ; 3B40 _ 8B. 55, F4
        mov     dword [rax+4H], edx                     ; 3B43 _ 89. 50, 04
?_366:  add     dword [rbp-0CH], 1                      ; 3B46 _ 83. 45, F4, 01
?_367:  mov     rax, qword [rbp-18H]                    ; 3B4A _ 48: 8B. 45, E8
        movzx   eax, byte [rax+7DH]                     ; 3B4E _ 0F B6. 40, 7D
        movzx   eax, al                                 ; 3B52 _ 0F B6. C0
        cmp     dword [rbp-0CH], eax                    ; 3B55 _ 39. 45, F4
        jl      ?_365                                   ; 3B58 _ 7C, 96
        jmp     ?_372                                   ; 3B5A _ EB, 0A

?_368:  nop                                             ; 3B5C _ 90
        jmp     ?_372                                   ; 3B5D _ EB, 07

?_369:  nop                                             ; 3B5F _ 90
        jmp     ?_372                                   ; 3B60 _ EB, 04

?_370:  nop                                             ; 3B62 _ 90
        jmp     ?_372                                   ; 3B63 _ EB, 01

?_371:  nop                                             ; 3B65 _ 90
?_372:  leave                                           ; 3B66 _ C9
        ret                                             ; 3B67 _ C3

print_final_report:; Function begin
        push    rbp                                     ; 3B68 _ 55
        mov     rbp, rsp                                ; 3B69 _ 48: 89. E5
        sub     rsp, 32                                 ; 3B6C _ 48: 83. EC, 20
        mov     byte [rbp-11H], dil                     ; 3B70 _ 40: 88. 7D, EF
        mov     eax, dword [rel erropt+14H]             ; 3B74 _ 8B. 05, 00000000(rel)
        test    eax, eax                                ; 3B7A _ 85. C0
        setne   al                                      ; 3B7C _ 0F 95. C0
        movzx   eax, al                                 ; 3B7F _ 0F B6. C0
        test    rax, rax                                ; 3B82 _ 48: 85. C0
        je      ?_377                                   ; 3B85 _ 0F 84, 00000084
        call    pass_type                               ; 3B8B _ E8, FFFFC5EB
        mov     dword [rbp-8H], eax                     ; 3B90 _ 89. 45, F8
        cmp     dword [rbp-8H], 1                       ; 3B93 _ 83. 7D, F8, 01
        jbe     ?_377                                   ; 3B97 _ 76, 76
        cmp     dword [rbp-8H], 3                       ; 3B99 _ 83. 7D, F8, 03
        jbe     ?_373                                   ; 3B9D _ 76, 0B
        mov     eax, dword [rbp-8H]                     ; 3B9F _ 8B. 45, F8
        sub     eax, 3                                  ; 3BA2 _ 83. E8, 03
        mov     dword [rbp-0CH], eax                    ; 3BA5 _ 89. 45, F4
        jmp     ?_374                                   ; 3BA8 _ EB, 07

?_373:  mov     dword [rbp-0CH], 0                      ; 3BAA _ C7. 45, F4, 00000000
?_374:  mov     dword [rbp-4H], 1                       ; 3BB1 _ C7. 45, FC, 00000001
        mov     eax, dword [rbp-4H]                     ; 3BB8 _ 8B. 45, FC
        mov     edi, eax                                ; 3BBB _ 89. C7
        call    info_level                              ; 3BBD _ E8, FFFFC59B
        movzx   eax, al                                 ; 3BC2 _ 0F B6. C0
        test    rax, rax                                ; 3BC5 _ 48: 85. C0
        jz      ?_377                                   ; 3BC8 _ 74, 45
        call    pass_count                              ; 3BCA _ E8, FFFFC5EA
        lea     rdx, [rax-1H]                           ; 3BCF _ 48: 8D. 50, FF
        mov     eax, dword [rbp-0CH]                    ; 3BD3 _ 8B. 45, F4
        sub     rdx, rax                                ; 3BD6 _ 48: 29. C2
        cmp     byte [rbp-11H], 0                       ; 3BD9 _ 80. 7D, EF, 00
        jz      ?_375                                   ; 3BDD _ 74, 09
        lea     rax, [rel ?_574]                        ; 3BDF _ 48: 8D. 05, 00000000(rel)
        jmp     ?_376                                   ; 3BE6 _ EB, 07

?_375:  lea     rax, [rel ?_575]                        ; 3BE8 _ 48: 8D. 05, 00000000(rel)
?_376:  mov     ecx, dword [rbp-0CH]                    ; 3BEF _ 8B. 4D, F4
        lea     rsi, [rel ?_576]                        ; 3BF2 _ 48: 8D. 35, 00000000(rel)
        mov     edi, dword [rbp-4H]                     ; 3BF9 _ 8B. 7D, FC
        mov     r8d, ecx                                ; 3BFC _ 41: 89. C8
        mov     rcx, rdx                                ; 3BFF _ 48: 89. D1
        mov     rdx, rax                                ; 3C02 _ 48: 89. C2
        mov     eax, 0                                  ; 3C05 _ B8, 00000000
        call    nasm_info_                              ; 3C0A _ E8, 00000000(PLT r)
?_377:  nop                                             ; 3C0F _ 90
        leave                                           ; 3C10 _ C9
        ret                                             ; 3C11 _ C3
; print_final_report End of function

assemble_file:; Local function
        push    rbp                                     ; 3C12 _ 55
        mov     rbp, rsp                                ; 3C13 _ 48: 89. E5
        push    rbx                                     ; 3C16 _ 53
        sub     rsp, 648                                ; 3C17 _ 48: 81. EC, 00000288
        mov     qword [rbp-278H], rdi                   ; 3C1E _ 48: 89. BD, FFFFFD88
        mov     qword [rbp-280H], rsi                   ; 3C25 _ 48: 89. B5, FFFFFD80
        mov     qword [rbp-288H], rdx                   ; 3C2C _ 48: 89. 95, FFFFFD78
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        mov     rax, qword [fs:abs 28H]                 ; 3C33 _ 64 48: 8B. 04 25, 00000028
        mov     qword [rbp-18H], rax                    ; 3C3C _ 48: 89. 45, E8
        xor     eax, eax                                ; 3C40 _ 31. C0
        call    reset_limits_before_pass                ; 3C42 _ E8, FFFFCC69
        mov     eax, dword [rel cmd_sb]                 ; 3C47 _ 8B. 05, 00000000(rel)
        cmp     eax, 64                                 ; 3C4D _ 83. F8, 40
        jz      ?_378                                   ; 3C50 _ 74, 42
        cmp     eax, 64                                 ; 3C52 _ 83. F8, 40
        jg      ?_379                                   ; 3C55 _ 7F, 6C
        cmp     eax, 16                                 ; 3C57 _ 83. F8, 10
        je      ?_380                                   ; 3C5A _ 0F 84, 00000081
        cmp     eax, 32                                 ; 3C60 _ 83. F8, 20
        jnz     ?_379                                   ; 3C63 _ 75, 5E
        lea     rax, [rel cmd_cpu]                      ; 3C65 _ 48: 8D. 05, 00000000(rel)
        mov     esi, 195                                ; 3C6C _ BE, 000000C3
        mov     rdi, rax                                ; 3C71 _ 48: 89. C7
        call    iflag_cpu_level_ok                      ; 3C74 _ E8, FFFFC563
        xor     eax, 01H                                ; 3C79 _ 83. F0, 01
        test    al, al                                  ; 3C7C _ 84. C0
        jz      ?_381                                   ; 3C7E _ 74, 64
        lea     rax, [rel ?_577]                        ; 3C80 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 3C87 _ 48: 89. C7
        mov     eax, 0                                  ; 3C8A _ B8, 00000000
        call    nasm_fatal                              ; 3C8F _ E8, 00000000(PLT r)
?_378:  lea     rax, [rel cmd_cpu]                      ; 3C94 _ 48: 8D. 05, 00000000(rel)
        mov     esi, 203                                ; 3C9B _ BE, 000000CB
        mov     rdi, rax                                ; 3CA0 _ 48: 89. C7
        call    iflag_cpu_level_ok                      ; 3CA3 _ E8, FFFFC534
        xor     eax, 01H                                ; 3CA8 _ 83. F0, 01
        test    al, al                                  ; 3CAB _ 84. C0
        jz      ?_382                                   ; 3CAD _ 74, 38
        lea     rax, [rel ?_578]                        ; 3CAF _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 3CB6 _ 48: 89. C7
        mov     eax, 0                                  ; 3CB9 _ B8, 00000000
        call    nasm_fatal                              ; 3CBE _ E8, 00000000(PLT r)
?_379:  lea     rcx, [rel ?_567]                        ; 3CC3 _ 48: 8D. 0D, 00000000(rel)
        lea     rax, [rel __func__.2]                   ; 3CCA _ 48: 8D. 05, 00000000(rel)
        mov     edx, 1807                               ; 3CD1 _ BA, 0000070F
        mov     rsi, rcx                                ; 3CD6 _ 48: 89. CE
        mov     rdi, rax                                ; 3CD9 _ 48: 89. C7
        call    nasm_panic_from_macro                   ; 3CDC _ E8, 00000000(PLT r)
?_380:  nop                                             ; 3CE1 _ 90
        jmp     ?_383                                   ; 3CE2 _ EB, 04

?_381:  nop                                             ; 3CE4 _ 90
        jmp     ?_383                                   ; 3CE5 _ EB, 01

?_382:  nop                                             ; 3CE7 _ 90
?_383:  mov     rax, qword 7FFFFFFFFFFFFFFFH            ; 3CE8 _ 48: B8, 7FFFFFFFFFFFFFFF
        mov     qword [rbp-268H], rax                   ; 3CF2 _ 48: 89. 85, FFFFFD98
        movzx   eax, byte [rel keep_all]                ; 3CF9 _ 0F B6. 05, 00000000(rel)
        xor     eax, 01H                                ; 3D00 _ 83. F0, 01
        test    al, al                                  ; 3D03 _ 84. C0
        je      ?_410                                   ; 3D05 _ 0F 84, 00000451
        mov     edi, 3                                  ; 3D0B _ BF, 00000003
        call    get_filename                            ; 3D10 _ E8, FFFFC5B0
        mov     rdi, rax                                ; 3D15 _ 48: 89. C7
        call    nasm_remove                             ; 3D18 _ E8, 00000000(PLT r)
        jmp     ?_410                                   ; 3D1D _ E9, 0000043A

?_384:  mov     rax, qword [rel _passn]                 ; 3D22 _ 48: 8B. 05, 00000000(rel)
        add     rax, 1                                  ; 3D29 _ 48: 83. C0, 01
        mov     qword [rel _passn], rax                 ; 3D2D _ 48: 89. 05, 00000000(rel)
        call    pass_type                               ; 3D34 _ E8, FFFFC442
        test    eax, eax                                ; 3D39 _ 85. C0
        jz      ?_385                                   ; 3D3B _ 74, 07
        cmp     eax, 3                                  ; 3D3D _ 83. F8, 03
        jz      ?_386                                   ; 3D40 _ 74, 0E
        jmp     ?_387                                   ; 3D42 _ EB, 18

?_385:  mov     dword [rel _pass_type], 2               ; 3D44 _ C7. 05, 00000000(rel), 00000002
        jmp     ?_389                                   ; 3D4E _ EB, 1E

?_386:  mov     rax, qword [rel global_offset_changed]  ; 3D50 _ 48: 8B. 05, 00000000(rel)
        test    rax, rax                                ; 3D57 _ 48: 85. C0
        jnz     ?_388                                   ; 3D5A _ 75, 11
?_387:  mov     eax, dword [rel _pass_type]             ; 3D5C _ 8B. 05, 00000000(rel)
        add     eax, 1                                  ; 3D62 _ 83. C0, 01
        mov     dword [rel _pass_type], eax             ; 3D65 _ 89. 05, 00000000(rel)
        jmp     ?_389                                   ; 3D6B _ EB, 01

?_388:  nop                                             ; 3D6D _ 90
?_389:  call    pass_final                              ; 3D6E _ E8, FFFFC435
        movzx   eax, al                                 ; 3D73 _ 0F B6. C0
        mov     edi, eax                                ; 3D76 _ 89. C7
        call    error_pass_start                        ; 3D78 _ E8, 00000000(PLT r)
        mov     qword [rel global_offset_changed], 0    ; 3D7D _ 48: C7. 05, 00000000(rel), 00000000
        mov     dword [rel erropt+0CH], 0               ; 3D88 _ C7. 05, 00000000(rel), 00000000
        call    pass_final                              ; 3D92 _ E8, FFFFC411
        xor     eax, 01H                                ; 3D97 _ 83. F0, 01
        test    al, al                                  ; 3D9A _ 84. C0
        jz      ?_390                                   ; 3D9C _ 74, 0F
        mov     eax, dword [rel erropt+0CH]             ; 3D9E _ 8B. 05, 00000000(rel)
        or      ah, 01H                                 ; 3DA4 _ 80. CC, 01
        mov     dword [rel erropt+0CH], eax             ; 3DA7 _ 89. 05, 00000000(rel)
?_390:  mov     eax, dword [rel cmd_sb]                 ; 3DAD _ 8B. 05, 00000000(rel)
        mov     edi, eax                                ; 3DB3 _ 89. C7
        call    reset_global_defaults                   ; 3DB5 _ E8, 00000000(PLT r)
        mov     rax, qword [rel cmd_cpu]                ; 3DBA _ 48: 8B. 05, 00000000(rel)
        mov     rdx, qword [rel cmd_cpu+8H]             ; 3DC1 _ 48: 8B. 15, 00000000(rel)
        mov     qword [rel cpu], rax                    ; 3DC8 _ 48: 89. 05, 00000000(rel)
        mov     qword [rel cpu+8H], rdx                 ; 3DCF _ 48: 89. 15, 00000000(rel)
; Note: Memory operand is misaligned. Performance penalty
        mov     rax, qword [rel cmd_cpu+0CH]            ; 3DD6 _ 48: 8B. 05, 00000000(rel)
; Note: Memory operand is misaligned. Performance penalty
        mov     rdx, qword [rel cmd_cpu+14H]            ; 3DDD _ 48: 8B. 15, 00000000(rel)
; Note: Memory operand is misaligned. Performance penalty
        mov     qword [rel cpu+0CH], rax                ; 3DE4 _ 48: 89. 05, 00000000(rel)
; Note: Memory operand is misaligned. Performance penalty
        mov     qword [rel cpu+14H], rdx                ; 3DEB _ 48: 89. 15, 00000000(rel)
        mov     edi, 3                                  ; 3DF2 _ BF, 00000003
        call    get_filename                            ; 3DF7 _ E8, FFFFC4C9
        mov     qword [rbp-260H], rax                   ; 3DFC _ 48: 89. 85, FFFFFDA0
        cmp     qword [rbp-260H], 0                     ; 3E03 _ 48: 83. BD, FFFFFDA0, 00
        jz      ?_392                                   ; 3E0B _ 74, 54
        call    list_on_this_pass                       ; 3E0D _ E8, FFFFC463
        test    al, al                                  ; 3E12 _ 84. C0
        jz      ?_391                                   ; 3E14 _ 74, 18
        mov     rax, qword [rel lfmt]                   ; 3E16 _ 48: 8B. 05, 00000000(rel)
        mov     rdx, qword [rax]                        ; 3E1D _ 48: 8B. 10
        mov     rax, qword [rbp-260H]                   ; 3E20 _ 48: 8B. 85, FFFFFDA0
        mov     rdi, rax                                ; 3E27 _ 48: 89. C7
        call    rdx                                     ; 3E2A _ FF. D2
        jmp     ?_392                                   ; 3E2C _ EB, 33

?_391:  call    list_active                             ; 3E2E _ E8, FFFFC482
        test    al, al                                  ; 3E33 _ 84. C0
        jz      ?_392                                   ; 3E35 _ 74, 2A
        mov     rax, qword [rel lfmt]                   ; 3E37 _ 48: 8B. 05, 00000000(rel)
        mov     rax, qword [rax+8H]                     ; 3E3E _ 48: 8B. 40, 08
        call    rax                                     ; 3E42 _ FF. D0
        movzx   eax, byte [rel keep_all]                ; 3E44 _ 0F B6. 05, 00000000(rel)
        xor     eax, 01H                                ; 3E4B _ 83. F0, 01
        test    al, al                                  ; 3E4E _ 84. C0
        jz      ?_392                                   ; 3E50 _ 74, 0F
        mov     rax, qword [rbp-260H]                   ; 3E52 _ 48: 8B. 85, FFFFFDA0
        mov     rdi, rax                                ; 3E59 _ 48: 89. C7
        call    nasm_remove                             ; 3E5C _ E8, 00000000(PLT r)
?_392:  mov     byte [rel in_absolute], 0               ; 3E61 _ C6. 05, 00000000(rel), 00
        call    pass_first                              ; 3E68 _ E8, FFFFC32A
        xor     eax, 01H                                ; 3E6D _ 83. F0, 01
        test    al, al                                  ; 3E70 _ 84. C0
        jz      ?_393                                   ; 3E72 _ 74, 3F
        mov     rax, qword [rel forwrefs]               ; 3E74 _ 48: 8B. 05, 00000000(rel)
        mov     rdi, rax                                ; 3E7B _ 48: 89. C7
        call    saa_rewind                              ; 3E7E _ E8, 00000000(PLT r)
        mov     rax, qword [rel forwrefs]               ; 3E83 _ 48: 8B. 05, 00000000(rel)
        mov     rdi, rax                                ; 3E8A _ 48: 89. C7
        call    saa_rstruct                             ; 3E8D _ E8, 00000000(PLT r)
        mov     qword [rel forwref], rax                ; 3E92 _ 48: 89. 05, 00000000(rel)
        mov     rax, qword [rel offsets]                ; 3E99 _ 48: 8B. 05, 00000000(rel)
        mov     rdi, rax                                ; 3EA0 _ 48: 89. C7
        call    raa_free                                ; 3EA3 _ E8, 00000000(PLT r)
        mov     qword [rel offsets], 0                  ; 3EA8 _ 48: C7. 05, 00000000(rel), 00000000
?_393:  mov     dword [rel location+8H], -1             ; 3EB3 _ C7. 05, 00000000(rel), FFFFFFFF
        mov     qword [rel location], 0                 ; 3EBD _ 48: C7. 05, 00000000(rel), 00000000
        call    pass_first                              ; 3EC8 _ E8, FFFFC2CA
        test    al, al                                  ; 3ECD _ 84. C0
        jz      ?_394                                   ; 3ECF _ 74, 07
        mov     byte [rel location+0CH], 1              ; 3ED1 _ C6. 05, 00000000(rel), 01
?_394:  mov     rax, qword [rel ofmt]                   ; 3ED8 _ 48: 8B. 05, 00000000(rel)
        mov     rax, qword [rax+40H]                    ; 3EDF _ 48: 8B. 40, 40
        call    rax                                     ; 3EE3 _ FF. D0
        mov     rax, qword [rel ofmt]                   ; 3EE5 _ 48: 8B. 05, 00000000(rel)
        mov     rax, qword [rax+58H]                    ; 3EEC _ 48: 8B. 40, 58
        lea     rdx, [rel globl]                        ; 3EF0 _ 48: 8D. 15, 00000000(rel)
        mov     rsi, rdx                                ; 3EF7 _ 48: 89. D6
        mov     edi, 0                                  ; 3EFA _ BF, 00000000
        call    rax                                     ; 3EFF _ FF. D0
        mov     edi, eax                                ; 3F01 _ 89. C7
        call    switch_segment                          ; 3F03 _ E8, 00000000(PLT r)
        mov     rdx, qword [rbp-288H]                   ; 3F08 _ 48: 8B. 95, FFFFFD78
        mov     rsi, qword [rbp-280H]                   ; 3F0F _ 48: 8B. B5, FFFFFD80
        mov     rax, qword [rbp-278H]                   ; 3F16 _ 48: 8B. 85, FFFFFD88
        mov     rcx, rdx                                ; 3F1D _ 48: 89. D1
        mov     edx, 0                                  ; 3F20 _ BA, 00000000
        mov     rdi, rax                                ; 3F25 _ 48: 89. C7
        call    pp_reset                                ; 3F28 _ E8, 00000000(PLT r)
        mov     qword [rel globallineno], 0             ; 3F2D _ 48: C7. 05, 00000000(rel), 00000000
        jmp     ?_399                                   ; 3F38 _ E9, 000000B4

?_395:  mov     rax, qword [rel globallineno]           ; 3F3D _ 48: 8B. 05, 00000000(rel)
        add     rax, 1                                  ; 3F44 _ 48: 83. C0, 01
        mov     qword [rel globallineno], rax           ; 3F48 _ 48: 89. 05, 00000000(rel)
        mov     rdx, qword [rel globallineno]           ; 3F4F _ 48: 8B. 15, 00000000(rel)
        mov     rax, qword [rel nasm_limit+38H]         ; 3F56 _ 48: 8B. 05, 00000000(rel)
        cmp     rdx, rax                                ; 3F5D _ 48: 39. C2
        jle     ?_396                                   ; 3F60 _ 7E, 1E
        mov     rax, qword [rel nasm_limit+38H]         ; 3F62 _ 48: 8B. 05, 00000000(rel)
        lea     rdx, [rel ?_579]                        ; 3F69 _ 48: 8D. 15, 00000000(rel)
        mov     rsi, rax                                ; 3F70 _ 48: 89. C6
        mov     rdi, rdx                                ; 3F73 _ 48: 89. D7
        mov     eax, 0                                  ; 3F76 _ B8, 00000000
        call    nasm_fatal                              ; 3F7B _ E8, 00000000(PLT r)
?_396:  mov     rax, qword [rbp-258H]                   ; 3F80 _ 48: 8B. 85, FFFFFDA8
        mov     rdi, rax                                ; 3F87 _ 48: 89. C7
        call    process_directives                      ; 3F8A _ E8, 00000000(PLT r)
        test    al, al                                  ; 3F8F _ 84. C0
        jnz     ?_397                                   ; 3F91 _ 75, 4E
        mov     edx, dword [rel globl]                  ; 3F93 _ 8B. 15, 00000000(rel)
        lea     rcx, [rbp-250H]                         ; 3F99 _ 48: 8D. 8D, FFFFFDB0
        mov     rax, qword [rbp-258H]                   ; 3FA0 _ 48: 8B. 85, FFFFFDA8
        mov     rsi, rcx                                ; 3FA7 _ 48: 89. CE
        mov     rdi, rax                                ; 3FAA _ 48: 89. C7
        call    parse_line                              ; 3FAD _ E8, 00000000(PLT r)
        lea     rax, [rbp-250H]                         ; 3FB2 _ 48: 8D. 85, FFFFFDB0
        mov     rdi, rax                                ; 3FB9 _ 48: 89. C7
        call    forward_refs                            ; 3FBC _ E8, FFFFFA36
        lea     rax, [rbp-250H]                         ; 3FC1 _ 48: 8D. 85, FFFFFDB0
        mov     rdi, rax                                ; 3FC8 _ 48: 89. C7
        call    process_insn                            ; 3FCB _ E8, 00000000(PLT r)
        lea     rax, [rbp-250H]                         ; 3FD0 _ 48: 8D. 85, FFFFFDB0
        mov     rdi, rax                                ; 3FD7 _ 48: 89. C7
        call    cleanup_insn                            ; 3FDA _ E8, 00000000(PLT r)
        jmp     ?_398                                   ; 3FDF _ EB, 01

?_397:  nop                                             ; 3FE1 _ 90
?_398:  mov     rax, qword [rbp-258H]                   ; 3FE2 _ 48: 8B. 85, FFFFFDA8
        mov     rdi, rax                                ; 3FE9 _ 48: 89. C7
        call    nasm_free                               ; 3FEC _ E8, 00000000(PLT r)
?_399:  call    pp_getline                              ; 3FF1 _ E8, 00000000(PLT r)
        mov     qword [rbp-258H], rax                   ; 3FF6 _ 48: 89. 85, FFFFFDA8
        cmp     qword [rbp-258H], 0                     ; 3FFD _ 48: 83. BD, FFFFFDA8, 00
        jne     ?_395                                   ; 4005 _ 0F 85, FFFFFF32
        call    pp_cleanup_pass                         ; 400B _ E8, 00000000(PLT r)
        mov     rax, qword [rel global_offset_changed]  ; 4010 _ 48: 8B. 05, 00000000(rel)
        test    rax, rax                                ; 4017 _ 48: 85. C0
        je      ?_409                                   ; 401A _ 0F 84, 00000137
        call    pass_type                               ; 4020 _ E8, FFFFC156
        cmp     eax, 5                                  ; 4025 _ 83. F8, 05
        je      ?_405                                   ; 4028 _ 0F 84, 00000107
        cmp     eax, 5                                  ; 402E _ 83. F8, 05
        ja      ?_406                                   ; 4031 _ 0F 87, 00000119
        cmp     eax, 3                                  ; 4037 _ 83. F8, 03
        jz      ?_400                                   ; 403A _ 74, 0E
        cmp     eax, 4                                  ; 403C _ 83. F8, 04
        je      ?_404                                   ; 403F _ 0F 84, 000000B3
        jmp     ?_406                                   ; 4045 _ E9, 00000106

?_400:  mov     rax, qword [rel global_offset_changed]  ; 404A _ 48: 8B. 05, 00000000(rel)
        cmp     rax, qword [rbp-268H]                   ; 4051 _ 48: 3B. 85, FFFFFD98
        jnc     ?_401                                   ; 4058 _ 73, 1B
        mov     rax, qword [rel global_offset_changed]  ; 405A _ 48: 8B. 05, 00000000(rel)
        mov     qword [rbp-268H], rax                   ; 4061 _ 48: 89. 85, FFFFFD98
        mov     qword [rel stall_count.1], 0            ; 4068 _ 48: C7. 05, 00000000(rel), 00000000
        jmp     ?_402                                   ; 4073 _ EB, 12

?_401:  mov     rax, qword [rel stall_count.1]          ; 4075 _ 48: 8B. 05, 00000000(rel)
        add     rax, 1                                  ; 407C _ 48: 83. C0, 01
        mov     qword [rel stall_count.1], rax          ; 4080 _ 48: 89. 05, 00000000(rel)
?_402:  mov     rdx, qword [rel nasm_limit+8H]          ; 4087 _ 48: 8B. 15, 00000000(rel)
        mov     rax, qword [rel stall_count.1]          ; 408E _ 48: 8B. 05, 00000000(rel)
        cmp     rdx, rax                                ; 4095 _ 48: 39. C2
        jl      ?_403                                   ; 4098 _ 7C, 18
        call    pass_count                              ; 409A _ E8, FFFFC11A
        mov     rdx, rax                                ; 409F _ 48: 89. C2
        mov     rax, qword [rel nasm_limit]             ; 40A2 _ 48: 8B. 05, 00000000(rel)
        cmp     rdx, rax                                ; 40A9 _ 48: 39. C2
        jl      ?_407                                   ; 40AC _ 0F 8C, 000000A1
?_403:  mov     rbx, qword [rel stall_count.1]          ; 40B2 _ 48: 8B. 1D, 00000000(rel)
        call    pass_count                              ; 40B9 _ E8, FFFFC0FB
        mov     rdx, rax                                ; 40BE _ 48: 89. C2
        lea     rax, [rel ?_580]                        ; 40C1 _ 48: 8D. 05, 00000000(rel)
        mov     rcx, rbx                                ; 40C8 _ 48: 89. D9
        mov     rsi, rax                                ; 40CB _ 48: 89. C6
        mov     edi, 16                                 ; 40CE _ BF, 00000010
        mov     eax, 0                                  ; 40D3 _ B8, 00000000
        call    nasm_nonfatalf                          ; 40D8 _ E8, 00000000(PLT r)
        lea     rax, [rel ?_581]                        ; 40DD _ 48: 8D. 05, 00000000(rel)
        mov     rsi, rax                                ; 40E4 _ 48: 89. C6
        mov     edi, 16                                 ; 40E7 _ BF, 00000010
        mov     eax, 0                                  ; 40EC _ B8, 00000000
        call    nasm_nonfatalf                          ; 40F1 _ E8, 00000000(PLT r)
        jmp     ?_407                                   ; 40F6 _ EB, 5B

?_404:  mov     dword [rbp-26CH], 1245200               ; 40F8 _ C7. 85, FFFFFD94, 00130010
        mov     eax, dword [rbp-26CH]                   ; 4102 _ 8B. 85, FFFFFD94
        mov     edi, eax                                ; 4108 _ 89. C7
        call    warn_active                             ; 410A _ E8, FFFFC01B
        movzx   eax, al                                 ; 410F _ 0F B6. C0
        test    rax, rax                                ; 4112 _ 48: 85. C0
        jz      ?_408                                   ; 4115 _ 74, 3F
        lea     rdx, [rel ?_582]                        ; 4117 _ 48: 8D. 15, 00000000(rel)
        mov     eax, dword [rbp-26CH]                   ; 411E _ 8B. 85, FFFFFD94
        mov     rsi, rdx                                ; 4124 _ 48: 89. D6
        mov     edi, eax                                ; 4127 _ 89. C7
        mov     eax, 0                                  ; 4129 _ B8, 00000000
        call    nasm_warn_                              ; 412E _ E8, 00000000(PLT r)
        jmp     ?_408                                   ; 4133 _ EB, 21

?_405:  lea     rax, [rel ?_583]                        ; 4135 _ 48: 8D. 05, 00000000(rel)
        mov     rsi, rax                                ; 413C _ 48: 89. C6
        mov     edi, 16                                 ; 413F _ BF, 00000010
        mov     eax, 0                                  ; 4144 _ B8, 00000000
        call    nasm_nonfatalf                          ; 4149 _ E8, 00000000(PLT r)
        jmp     ?_409                                   ; 414E _ EB, 07

?_406:  nop                                             ; 4150 _ 90
        jmp     ?_409                                   ; 4151 _ EB, 04

?_407:  nop                                             ; 4153 _ 90
        jmp     ?_409                                   ; 4154 _ EB, 01

?_408:  nop                                             ; 4156 _ 90
?_409:  call    error_pass_end                          ; 4157 _ E8, 00000000(PLT r)
?_410:  call    terminate_after_phase                   ; 415C _ E8, FFFFC1B8
        xor     eax, 01H                                ; 4161 _ 83. F0, 01
        test    al, al                                  ; 4164 _ 84. C0
        jz      ?_411                                   ; 4166 _ 74, 10
        call    pass_final                              ; 4168 _ E8, FFFFC03B
        xor     eax, 01H                                ; 416D _ 83. F0, 01
        test    al, al                                  ; 4170 _ 84. C0
        jne     ?_384                                   ; 4172 _ 0F 85, FFFFFBAA
?_411:  call    terminate_after_phase                   ; 4178 _ E8, FFFFC19C
        movzx   eax, al                                 ; 417D _ 0F B6. C0
        mov     edi, eax                                ; 4180 _ 89. C7
        call    print_final_report                      ; 4182 _ E8, 00000000(PLT r)
        mov     rax, qword [rel lfmt]                   ; 4187 _ 48: 8B. 05, 00000000(rel)
        mov     rax, qword [rax+8H]                     ; 418E _ 48: 8B. 40, 08
        call    rax                                     ; 4192 _ FF. D0
        nop                                             ; 4194 _ 90
        mov     rax, qword [rbp-18H]                    ; 4195 _ 48: 8B. 45, E8
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        sub     rax, qword [fs:abs 28H]                 ; 4199 _ 64 48: 2B. 04 25, 00000028
        jz      ?_412                                   ; 41A2 _ 74, 05
        call    __stack_chk_fail                        ; 41A4 _ E8, 00000000(PLT r)
?_412:  mov     rbx, qword [rbp-8H]                     ; 41A9 _ 48: 8B. 5D, F8
        leave                                           ; 41AD _ C9
        ret                                             ; 41AE _ C3

close_output:; Function begin
        push    rbp                                     ; 41AF _ 55
        mov     rbp, rsp                                ; 41B0 _ 48: 89. E5
        sub     rsp, 16                                 ; 41B3 _ 48: 83. EC, 10
        mov     byte [rbp-1H], dil                      ; 41B7 _ 40: 88. 7D, FF
        mov     rax, qword [rel ofile]                  ; 41BB _ 48: 8B. 05, 00000000(rel)
        test    rax, rax                                ; 41C2 _ 48: 85. C0
        je      ?_416                                   ; 41C5 _ 0F 84, 0000008B
        mov     rdx, qword [rel ofile]                  ; 41CB _ 48: 8B. 15, 00000000(rel)
        mov     rax, qword [rel stdout]                 ; 41D2 _ 48: 8B. 05, 00000000(rel)
        cmp     rdx, rax                                ; 41D9 _ 48: 39. C2
        jz      ?_413                                   ; 41DC _ 74, 13
        mov     rdx, qword [rel ofile]                  ; 41DE _ 48: 8B. 15, 00000000(rel)
        mov     rax, qword [rel stdin]                  ; 41E5 _ 48: 8B. 05, 00000000(rel)
        cmp     rdx, rax                                ; 41EC _ 48: 39. C2
        jnz     ?_414                                   ; 41EF _ 75, 11
?_413:  mov     rax, qword [rel ofile]                  ; 41F1 _ 48: 8B. 05, 00000000(rel)
        mov     rdi, rax                                ; 41F8 _ 48: 89. C7
        call    fflush                                  ; 41FB _ E8, 00000000(PLT r)
        jmp     ?_415                                   ; 4200 _ EB, 47

?_414:  mov     rax, qword [rel ofile]                  ; 4202 _ 48: 8B. 05, 00000000(rel)
        mov     rdi, rax                                ; 4209 _ 48: 89. C7
        call    fclose                                  ; 420C _ E8, 00000000(PLT r)
        cmp     byte [rbp-1H], 0                        ; 4211 _ 80. 7D, FF, 00
        jz      ?_415                                   ; 4215 _ 74, 32
        movzx   eax, byte [rel keep_all]                ; 4217 _ 0F B6. 05, 00000000(rel)
        xor     eax, 01H                                ; 421E _ 83. F0, 01
        test    al, al                                  ; 4221 _ 84. C0
        jz      ?_415                                   ; 4223 _ 74, 24
        mov     edi, 1                                  ; 4225 _ BF, 00000001
        call    get_filename                            ; 422A _ E8, FFFFC096
        mov     rdi, rax                                ; 422F _ 48: 89. C7
        call    nasm_remove                             ; 4232 _ E8, 00000000(PLT r)
        mov     edi, 5                                  ; 4237 _ BF, 00000005
        call    get_filename                            ; 423C _ E8, FFFFC084
        mov     rdi, rax                                ; 4241 _ 48: 89. C7
        call    nasm_remove                             ; 4244 _ E8, 00000000(PLT r)
?_415:  mov     qword [rel ofile], 0                    ; 4249 _ 48: C7. 05, 00000000(rel), 00000000
        jmp     ?_417                                   ; 4254 _ EB, 01

?_416:  nop                                             ; 4256 _ 90
?_417:  leave                                           ; 4257 _ C9
        ret                                             ; 4258 _ C3
; close_output End of function

help_is:; Local function
        push    rbp                                     ; 4259 _ 55
        mov     rbp, rsp                                ; 425A _ 48: 89. E5
        mov     dword [rbp-4H], edi                     ; 425D _ 89. 7D, FC
        mov     dword [rbp-8H], esi                     ; 4260 _ 89. 75, F8
        cmp     dword [rbp-4H], 0                       ; 4263 _ 83. 7D, FC, 00
        jz      ?_418                                   ; 4267 _ 74, 08
        mov     eax, dword [rbp-4H]                     ; 4269 _ 8B. 45, FC
        cmp     eax, dword [rbp-8H]                     ; 426C _ 3B. 45, F8
        jnz     ?_419                                   ; 426F _ 75, 07
?_418:  mov     eax, 1                                  ; 4271 _ B8, 00000001
        jmp     ?_420                                   ; 4276 _ EB, 05

?_419:  mov     eax, 0                                  ; 4278 _ B8, 00000000
?_420:  and     eax, 01H                                ; 427D _ 83. E0, 01
        pop     rbp                                     ; 4280 _ 5D
        ret                                             ; 4281 _ C3

help_opt:; Local function
        push    rbp                                     ; 4282 _ 55
        mov     rbp, rsp                                ; 4283 _ 48: 89. E5
        sub     rsp, 8                                  ; 4286 _ 48: 83. EC, 08
        mov     dword [rbp-4H], edi                     ; 428A _ 89. 7D, FC
        mov     eax, dword [rbp-4H]                     ; 428D _ 8B. 45, FC
        mov     esi, 1                                  ; 4290 _ BE, 00000001
        mov     edi, eax                                ; 4295 _ 89. C7
        call    help_is                                 ; 4297 _ E8, FFFFFFBD
        leave                                           ; 429C _ C9
        ret                                             ; 429D _ C3

help_optor:; Local function
        push    rbp                                     ; 429E _ 55
        mov     rbp, rsp                                ; 429F _ 48: 89. E5
        sub     rsp, 8                                  ; 42A2 _ 48: 83. EC, 08
        mov     dword [rbp-4H], edi                     ; 42A6 _ 89. 7D, FC
        mov     dword [rbp-8H], esi                     ; 42A9 _ 89. 75, F8
        mov     eax, dword [rbp-4H]                     ; 42AC _ 8B. 45, FC
        mov     edi, eax                                ; 42AF _ 89. C7
        call    help_opt                                ; 42B1 _ E8, FFFFFFCC
        test    al, al                                  ; 42B6 _ 84. C0
        jnz     ?_421                                   ; 42B8 _ 75, 08
        mov     eax, dword [rbp-4H]                     ; 42BA _ 8B. 45, FC
        cmp     eax, dword [rbp-8H]                     ; 42BD _ 3B. 45, F8
        jnz     ?_422                                   ; 42C0 _ 75, 07
?_421:  mov     eax, 1                                  ; 42C2 _ B8, 00000001
        jmp     ?_423                                   ; 42C7 _ EB, 05

?_422:  mov     eax, 0                                  ; 42C9 _ B8, 00000000
?_423:  and     eax, 01H                                ; 42CE _ 83. E0, 01
        leave                                           ; 42D1 _ C9
        ret                                             ; 42D2 _ C3

help:   ; Local function
        push    rbp                                     ; 42D3 _ 55
        mov     rbp, rsp                                ; 42D4 _ 48: 89. E5
        push    r12                                     ; 42D7 _ 41: 54
        push    rbx                                     ; 42D9 _ 53
        sub     rsp, 64                                 ; 42DA _ 48: 83. EC, 40
        mov     qword [rbp-48H], rdi                    ; 42DE _ 48: 89. 7D, B8
        mov     qword [rbp-50H], rsi                    ; 42E2 _ 48: 89. 75, B0
        mov     dword [rbp-3CH], 2                      ; 42E6 _ C7. 45, C4, 00000002
        cmp     qword [rbp-50H], 0                      ; 42ED _ 48: 83. 7D, B0, 00
        je      ?_424                                   ; 42F2 _ 0F 84, 00000091
        mov     rax, qword [rbp-50H]                    ; 42F8 _ 48: 8B. 45, B0
        movzx   eax, byte [rax]                         ; 42FC _ 0F B6. 00
        test    al, al                                  ; 42FF _ 84. C0
        je      ?_424                                   ; 4301 _ 0F 84, 00000082
        lea     rdx, [rel ?_535]                        ; 4307 _ 48: 8D. 15, 00000000(rel)
        mov     rax, qword [rbp-50H]                    ; 430E _ 48: 8B. 45, B0
        mov     rsi, rdx                                ; 4312 _ 48: 89. D6
        mov     rdi, rax                                ; 4315 _ 48: 89. C7
        call    strcmp                                  ; 4318 _ E8, 00000000(PLT r)
        test    eax, eax                                ; 431D _ 85. C0
        jz      ?_424                                   ; 431F _ 74, 68
        lea     rdx, [rel ?_584]                        ; 4321 _ 48: 8D. 15, 00000000(rel)
        mov     rax, qword [rbp-50H]                    ; 4328 _ 48: 8B. 45, B0
        mov     rsi, rdx                                ; 432C _ 48: 89. D6
        mov     rdi, rax                                ; 432F _ 48: 89. C7
        call    strcmp                                  ; 4332 _ E8, 00000000(PLT r)
        test    eax, eax                                ; 4337 _ 85. C0
        jz      ?_424                                   ; 4339 _ 74, 4E
        lea     rdx, [rel ?_585]                        ; 433B _ 48: 8D. 15, 00000000(rel)
        mov     rax, qword [rbp-50H]                    ; 4342 _ 48: 8B. 45, B0
        mov     rsi, rdx                                ; 4346 _ 48: 89. D6
        mov     rdi, rax                                ; 4349 _ 48: 89. C7
        call    strcasecmp                              ; 434C _ E8, 00000000(PLT r)
        test    eax, eax                                ; 4351 _ 85. C0
        jz      ?_424                                   ; 4353 _ 74, 34
        lea     rdx, [rel ?_586]                        ; 4355 _ 48: 8D. 15, 00000000(rel)
        mov     rax, qword [rbp-50H]                    ; 435C _ 48: 8B. 45, B0
        mov     rsi, rdx                                ; 4360 _ 48: 89. D6
        mov     rdi, rax                                ; 4363 _ 48: 89. C7
        call    strcasecmp                              ; 4366 _ E8, 00000000(PLT r)
        test    eax, eax                                ; 436B _ 85. C0
        jz      ?_424                                   ; 436D _ 74, 1A
        lea     rdx, [rel ?_587]                        ; 436F _ 48: 8D. 15, 00000000(rel)
        mov     rax, qword [rbp-50H]                    ; 4376 _ 48: 8B. 45, B0
        mov     rsi, rdx                                ; 437A _ 48: 89. D6
        mov     rdi, rax                                ; 437D _ 48: 89. C7
        call    strcasecmp                              ; 4380 _ E8, 00000000(PLT r)
        test    eax, eax                                ; 4385 _ 85. C0
        jnz     ?_425                                   ; 4387 _ 75, 0C
?_424:  mov     dword [rbp-3CH], 1                      ; 4389 _ C7. 45, C4, 00000001
        jmp     ?_441                                   ; 4390 _ E9, 0000022C

?_425:  lea     rdx, [rel ?_588]                        ; 4395 _ 48: 8D. 15, 00000000(rel)
        mov     rax, qword [rbp-50H]                    ; 439C _ 48: 8B. 45, B0
        mov     rsi, rdx                                ; 43A0 _ 48: 89. D6
        mov     rdi, rax                                ; 43A3 _ 48: 89. C7
        call    strcasecmp                              ; 43A6 _ E8, 00000000(PLT r)
        test    eax, eax                                ; 43AB _ 85. C0
        jnz     ?_426                                   ; 43AD _ 75, 0C
        mov     dword [rbp-3CH], 0                      ; 43AF _ C7. 45, C4, 00000000
        jmp     ?_441                                   ; 43B6 _ E9, 00000206

?_426:  lea     rcx, [rel ?_589]                        ; 43BB _ 48: 8D. 0D, 00000000(rel)
        mov     rax, qword [rbp-50H]                    ; 43C2 _ 48: 8B. 45, B0
        mov     edx, 7                                  ; 43C6 _ BA, 00000007
        mov     rsi, rcx                                ; 43CB _ 48: 89. CE
        mov     rdi, rax                                ; 43CE _ 48: 89. C7
        call    strncasecmp                             ; 43D1 _ E8, 00000000(PLT r)
        test    eax, eax                                ; 43D6 _ 85. C0
        jz      ?_427                                   ; 43D8 _ 74, 1F
        lea     rcx, [rel ?_590]                        ; 43DA _ 48: 8D. 0D, 00000000(rel)
        mov     rax, qword [rbp-50H]                    ; 43E1 _ 48: 8B. 45, B0
        mov     edx, 5                                  ; 43E5 _ BA, 00000005
        mov     rsi, rcx                                ; 43EA _ 48: 89. CE
        mov     rdi, rax                                ; 43ED _ 48: 89. C7
        call    strncasecmp                             ; 43F0 _ E8, 00000000(PLT r)
        test    eax, eax                                ; 43F5 _ 85. C0
        jnz     ?_428                                   ; 43F7 _ 75, 0C
?_427:  mov     dword [rbp-3CH], 3                      ; 43F9 _ C7. 45, C4, 00000003
        jmp     ?_441                                   ; 4400 _ E9, 000001BC

?_428:  lea     rdx, [rel ?_591]                        ; 4405 _ 48: 8D. 15, 00000000(rel)
        mov     rax, qword [rbp-50H]                    ; 440C _ 48: 8B. 45, B0
        mov     rsi, rdx                                ; 4410 _ 48: 89. D6
        mov     rdi, rax                                ; 4413 _ 48: 89. C7
        call    strcasecmp                              ; 4416 _ E8, 00000000(PLT r)
        test    eax, eax                                ; 441B _ 85. C0
        jz      ?_429                                   ; 441D _ 74, 68
        lea     rdx, [rel ?_552]                        ; 441F _ 48: 8D. 15, 00000000(rel)
        mov     rax, qword [rbp-50H]                    ; 4426 _ 48: 8B. 45, B0
        mov     rsi, rdx                                ; 442A _ 48: 89. D6
        mov     rdi, rax                                ; 442D _ 48: 89. C7
        call    strcasecmp                              ; 4430 _ E8, 00000000(PLT r)
        test    eax, eax                                ; 4435 _ 85. C0
        jz      ?_429                                   ; 4437 _ 74, 4E
        lea     rdx, [rel ?_592]                        ; 4439 _ 48: 8D. 15, 00000000(rel)
        mov     rax, qword [rbp-50H]                    ; 4440 _ 48: 8B. 45, B0
        mov     rsi, rdx                                ; 4444 _ 48: 89. D6
        mov     rdi, rax                                ; 4447 _ 48: 89. C7
        call    strcasecmp                              ; 444A _ E8, 00000000(PLT r)
        test    eax, eax                                ; 444F _ 85. C0
        jz      ?_429                                   ; 4451 _ 74, 34
        lea     rdx, [rel ?_593]                        ; 4453 _ 48: 8D. 15, 00000000(rel)
        mov     rax, qword [rbp-50H]                    ; 445A _ 48: 8B. 45, B0
        mov     rsi, rdx                                ; 445E _ 48: 89. D6
        mov     rdi, rax                                ; 4461 _ 48: 89. C7
        call    strcasecmp                              ; 4464 _ E8, 00000000(PLT r)
        test    eax, eax                                ; 4469 _ 85. C0
        jz      ?_429                                   ; 446B _ 74, 1A
        lea     rdx, [rel ?_594]                        ; 446D _ 48: 8D. 15, 00000000(rel)
        mov     rax, qword [rbp-50H]                    ; 4474 _ 48: 8B. 45, B0
        mov     rsi, rdx                                ; 4478 _ 48: 89. D6
        mov     rdi, rax                                ; 447B _ 48: 89. C7
        call    strcasecmp                              ; 447E _ E8, 00000000(PLT r)
        test    eax, eax                                ; 4483 _ 85. C0
        jnz     ?_430                                   ; 4485 _ 75, 0C
?_429:  mov     dword [rbp-3CH], 104                    ; 4487 _ C7. 45, C4, 00000068
        jmp     ?_441                                   ; 448E _ E9, 0000012E

?_430:  mov     rax, qword [rbp-50H]                    ; 4493 _ 48: 8B. 45, B0
        movzx   eax, byte [rax]                         ; 4497 _ 0F B6. 00
        cmp     al, 45                                  ; 449A _ 3C, 2D
        jnz     ?_431                                   ; 449C _ 75, 1E
        mov     rax, qword [rbp-50H]                    ; 449E _ 48: 8B. 45, B0
        add     rax, 1                                  ; 44A2 _ 48: 83. C0, 01
        movzx   eax, byte [rax]                         ; 44A6 _ 0F B6. 00
        test    al, al                                  ; 44A9 _ 84. C0
        jz      ?_431                                   ; 44AB _ 74, 0F
        mov     rax, qword [rbp-50H]                    ; 44AD _ 48: 8B. 45, B0
        add     rax, 2                                  ; 44B1 _ 48: 83. C0, 02
        movzx   eax, byte [rax]                         ; 44B5 _ 0F B6. 00
        test    al, al                                  ; 44B8 _ 84. C0
        jz      ?_432                                   ; 44BA _ 74, 22
?_431:  mov     rax, qword [rbp-50H]                    ; 44BC _ 48: 8B. 45, B0
        movzx   eax, byte [rax]                         ; 44C0 _ 0F B6. 00
        test    al, al                                  ; 44C3 _ 84. C0
        je      ?_441                                   ; 44C5 _ 0F 84, 000000F6
        mov     rax, qword [rbp-50H]                    ; 44CB _ 48: 8B. 45, B0
        add     rax, 1                                  ; 44CF _ 48: 83. C0, 01
        movzx   eax, byte [rax]                         ; 44D3 _ 0F B6. 00
        test    al, al                                  ; 44D6 _ 84. C0
        jne     ?_441                                   ; 44D8 _ 0F 85, 000000E3
?_432:  mov     rax, qword [rbp-50H]                    ; 44DE _ 48: 8B. 45, B0
        movzx   eax, byte [rax]                         ; 44E2 _ 0F B6. 00
        cmp     al, 45                                  ; 44E5 _ 3C, 2D
        jnz     ?_433                                   ; 44E7 _ 75, 13
        mov     rax, qword [rbp-50H]                    ; 44E9 _ 48: 8B. 45, B0
        add     rax, 1                                  ; 44ED _ 48: 83. C0, 01
        movzx   eax, byte [rax]                         ; 44F1 _ 0F B6. 00
        movsx   eax, al                                 ; 44F4 _ 0F BE. C0
        mov     dword [rbp-3CH], eax                    ; 44F7 _ 89. 45, C4
        jmp     ?_434                                   ; 44FA _ EB, 0D

?_433:  mov     rax, qword [rbp-50H]                    ; 44FC _ 48: 8B. 45, B0
        movzx   eax, byte [rax]                         ; 4500 _ 0F B6. 00
        movsx   eax, al                                 ; 4503 _ 0F BE. C0
        mov     dword [rbp-3CH], eax                    ; 4506 _ 89. 45, C4
?_434:  cmp     dword [rbp-3CH], 119                    ; 4509 _ 83. 7D, C4, 77
        je      ?_440                                   ; 450D _ 0F 84, 000000AD
        cmp     dword [rbp-3CH], 119                    ; 4513 _ 83. 7D, C4, 77
        jg      ?_439                                   ; 4517 _ 0F 8F, 0000009A
        cmp     dword [rbp-3CH], 104                    ; 451D _ 83. 7D, C4, 68
        je      ?_440                                   ; 4521 _ 0F 84, 00000099
        cmp     dword [rbp-3CH], 104                    ; 4527 _ 83. 7D, C4, 68
        jg      ?_439                                   ; 452B _ 0F 8F, 00000086
        cmp     dword [rbp-3CH], 103                    ; 4531 _ 83. 7D, C4, 67
        jz      ?_435                                   ; 4535 _ 74, 5C
        cmp     dword [rbp-3CH], 103                    ; 4537 _ 83. 7D, C4, 67
        jg      ?_439                                   ; 453B _ 7F, 7A
        cmp     dword [rbp-3CH], 102                    ; 453D _ 83. 7D, C4, 66
        jz      ?_440                                   ; 4541 _ 74, 7D
        cmp     dword [rbp-3CH], 102                    ; 4543 _ 83. 7D, C4, 66
        jg      ?_439                                   ; 4547 _ 7F, 6E
        cmp     dword [rbp-3CH], 88                     ; 4549 _ 83. 7D, C4, 58
        jz      ?_440                                   ; 454D _ 74, 71
        cmp     dword [rbp-3CH], 88                     ; 454F _ 83. 7D, C4, 58
        jg      ?_439                                   ; 4553 _ 7F, 62
        cmp     dword [rbp-3CH], 87                     ; 4555 _ 83. 7D, C4, 57
        jz      ?_436                                   ; 4559 _ 74, 41
        cmp     dword [rbp-3CH], 87                     ; 455B _ 83. 7D, C4, 57
        jg      ?_439                                   ; 455F _ 7F, 56
        cmp     dword [rbp-3CH], 79                     ; 4561 _ 83. 7D, C4, 4F
        jz      ?_440                                   ; 4565 _ 74, 59
        cmp     dword [rbp-3CH], 79                     ; 4567 _ 83. 7D, C4, 4F
        jg      ?_439                                   ; 456B _ 7F, 4A
        cmp     dword [rbp-3CH], 77                     ; 456D _ 83. 7D, C4, 4D
        jg      ?_439                                   ; 4571 _ 7F, 44
        cmp     dword [rbp-3CH], 76                     ; 4573 _ 83. 7D, C4, 4C
        jge     ?_440                                   ; 4577 _ 7D, 47
        cmp     dword [rbp-3CH], 70                     ; 4579 _ 83. 7D, C4, 46
        jz      ?_440                                   ; 457D _ 74, 41
        cmp     dword [rbp-3CH], 70                     ; 457F _ 83. 7D, C4, 46
        jg      ?_439                                   ; 4583 _ 7F, 32
        cmp     dword [rbp-3CH], 42                     ; 4585 _ 83. 7D, C4, 2A
        jz      ?_438                                   ; 4589 _ 74, 23
        cmp     dword [rbp-3CH], 63                     ; 458B _ 83. 7D, C4, 3F
        jz      ?_437                                   ; 458F _ 74, 14
        jmp     ?_439                                   ; 4591 _ EB, 24

?_435:  mov     dword [rbp-3CH], 70                     ; 4593 _ C7. 45, C4, 00000046
        jmp     ?_441                                   ; 459A _ EB, 25

?_436:  mov     dword [rbp-3CH], 119                    ; 459C _ C7. 45, C4, 00000077
        jmp     ?_441                                   ; 45A3 _ EB, 1C

?_437:  mov     dword [rbp-3CH], 104                    ; 45A5 _ C7. 45, C4, 00000068
        jmp     ?_441                                   ; 45AC _ EB, 13

?_438:  mov     dword [rbp-3CH], 0                      ; 45AE _ C7. 45, C4, 00000000
        jmp     ?_441                                   ; 45B5 _ EB, 0A

?_439:  mov     dword [rbp-3CH], 2                      ; 45B7 _ C7. 45, C4, 00000002
        jmp     ?_441                                   ; 45BE _ EB, 01

?_440:  nop                                             ; 45C0 _ 90
?_441:  cmp     dword [rbp-3CH], 2                      ; 45C1 _ 83. 7D, C4, 02
        jnz     ?_442                                   ; 45C5 _ 75, 24
        mov     rdx, qword [rbp-50H]                    ; 45C7 _ 48: 8B. 55, B0
        lea     rcx, [rel ?_595]                        ; 45CB _ 48: 8D. 0D, 00000000(rel)
        mov     rax, qword [rbp-48H]                    ; 45D2 _ 48: 8B. 45, B8
        mov     rsi, rcx                                ; 45D6 _ 48: 89. CE
        mov     rdi, rax                                ; 45D9 _ 48: 89. C7
        mov     eax, 0                                  ; 45DC _ B8, 00000000
        call    fprintf                                 ; 45E1 _ E8, 00000000(PLT r)
        jmp     ?_498                                   ; 45E6 _ E9, 00000853

?_442:  mov     eax, dword [rbp-3CH]                    ; 45EB _ 8B. 45, C4
        mov     edi, eax                                ; 45EE _ 89. C7
        call    help_opt                                ; 45F0 _ E8, FFFFFC8D
        test    al, al                                  ; 45F5 _ 84. C0
        jz      ?_443                                   ; 45F7 _ 74, 22
        mov     rdx, qword [rel _progname]              ; 45F9 _ 48: 8B. 15, 00000000(rel)
        lea     rcx, [rel ?_596]                        ; 4600 _ 48: 8D. 0D, 00000000(rel)
        mov     rax, qword [rbp-48H]                    ; 4607 _ 48: 8B. 45, B8
        mov     rsi, rcx                                ; 460B _ 48: 89. CE
        mov     rdi, rax                                ; 460E _ 48: 89. C7
        mov     eax, 0                                  ; 4611 _ B8, 00000000
        call    fprintf                                 ; 4616 _ E8, 00000000(PLT r)
?_443:  mov     eax, dword [rbp-3CH]                    ; 461B _ 8B. 45, C4
        mov     esi, 104                                ; 461E _ BE, 00000068
        mov     edi, eax                                ; 4623 _ 89. C7
        call    help_optor                              ; 4625 _ E8, FFFFFC74
        test    al, al                                  ; 462A _ 84. C0
        jz      ?_445                                   ; 462C _ 74, 5D
        mov     rax, qword [rbp-48H]                    ; 462E _ 48: 8B. 45, B8
        lea     rdi, [rel ?_597]                        ; 4632 _ 48: 8D. 3D, 00000000(rel)
        mov     rcx, rax                                ; 4639 _ 48: 89. C1
        mov     edx, 68                                 ; 463C _ BA, 00000044
        mov     esi, 1                                  ; 4641 _ BE, 00000001
        call    fwrite                                  ; 4646 _ E8, 00000000(PLT r)
        cmp     dword [rbp-3CH], 1                      ; 464B _ 83. 7D, C4, 01
        jnz     ?_444                                   ; 464F _ 75, 1D
        mov     rax, qword [rbp-48H]                    ; 4651 _ 48: 8B. 45, B8
        lea     rdi, [rel ?_598]                        ; 4655 _ 48: 8D. 3D, 00000000(rel)
        mov     rcx, rax                                ; 465C _ 48: 89. C1
        mov     edx, 58                                 ; 465F _ BA, 0000003A
        mov     esi, 1                                  ; 4664 _ BE, 00000001
        call    fwrite                                  ; 4669 _ E8, 00000000(PLT r)
?_444:  mov     rax, qword [rbp-48H]                    ; 466E _ 48: 8B. 45, B8
        lea     rdi, [rel ?_599]                        ; 4672 _ 48: 8D. 3D, 00000000(rel)
        mov     rcx, rax                                ; 4679 _ 48: 89. C1
        mov     edx, 115                                ; 467C _ BA, 00000073
        mov     esi, 1                                  ; 4681 _ BE, 00000001
        call    fwrite                                  ; 4686 _ E8, 00000000(PLT r)
?_445:  mov     eax, dword [rbp-3CH]                    ; 468B _ 8B. 45, C4
        mov     esi, 104                                ; 468E _ BE, 00000068
        mov     edi, eax                                ; 4693 _ 89. C7
        call    help_is                                 ; 4695 _ E8, FFFFFBBF
        test    al, al                                  ; 469A _ 84. C0
        jz      ?_446                                   ; 469C _ 74, 1D
        mov     rax, qword [rbp-48H]                    ; 469E _ 48: 8B. 45, B8
        lea     rdi, [rel ?_600]                        ; 46A2 _ 48: 8D. 3D, 00000000(rel)
        mov     rcx, rax                                ; 46A9 _ 48: 89. C1
        mov     edx, 461                                ; 46AC _ BA, 000001CD
        mov     esi, 1                                  ; 46B1 _ BE, 00000001
        call    fwrite                                  ; 46B6 _ E8, 00000000(PLT r)
?_446:  mov     eax, dword [rbp-3CH]                    ; 46BB _ 8B. 45, C4
        mov     edi, eax                                ; 46BE _ 89. C7
        call    help_opt                                ; 46C0 _ E8, FFFFFBBD
        test    al, al                                  ; 46C5 _ 84. C0
        jz      ?_447                                   ; 46C7 _ 74, 1D
        mov     rax, qword [rbp-48H]                    ; 46C9 _ 48: 8B. 45, B8
        lea     rdi, [rel ?_601]                        ; 46CD _ 48: 8D. 3D, 00000000(rel)
        mov     rcx, rax                                ; 46D4 _ 48: 89. C1
        mov     edx, 120                                ; 46D7 _ BA, 00000078
        mov     esi, 1                                  ; 46DC _ BE, 00000001
        call    fwrite                                  ; 46E1 _ E8, 00000000(PLT r)
?_447:  mov     eax, dword [rbp-3CH]                    ; 46E6 _ 8B. 45, C4
        mov     esi, 88                                 ; 46E9 _ BE, 00000058
        mov     edi, eax                                ; 46EE _ 89. C7
        call    help_optor                              ; 46F0 _ E8, FFFFFBA9
        test    al, al                                  ; 46F5 _ 84. C0
        jz      ?_450                                   ; 46F7 _ 74, 31
        cmp     dword [rbp-3CH], 1                      ; 46F9 _ 83. 7D, C4, 01
        jnz     ?_448                                   ; 46FD _ 75, 09
        lea     rax, [rel ?_602]                        ; 46FF _ 48: 8D. 05, 00000000(rel)
        jmp     ?_449                                   ; 4706 _ EB, 07

?_448:  lea     rax, [rel ?_512]                        ; 4708 _ 48: 8D. 05, 00000000(rel)
?_449:  lea     rsi, [rel ?_603]                        ; 470F _ 48: 8D. 35, 00000000(rel)
        mov     rcx, qword [rbp-48H]                    ; 4716 _ 48: 8B. 4D, B8
        mov     rdx, rax                                ; 471A _ 48: 89. C2
        mov     rdi, rcx                                ; 471D _ 48: 89. CF
        mov     eax, 0                                  ; 4720 _ B8, 00000000
        call    fprintf                                 ; 4725 _ E8, 00000000(PLT r)
?_450:  mov     eax, dword [rbp-3CH]                    ; 472A _ 8B. 45, C4
        mov     esi, 88                                 ; 472D _ BE, 00000058
        mov     edi, eax                                ; 4732 _ 89. C7
        call    help_is                                 ; 4734 _ E8, FFFFFB20
        test    al, al                                  ; 4739 _ 84. C0
        jz      ?_451                                   ; 473B _ 74, 1D
        mov     rax, qword [rbp-48H]                    ; 473D _ 48: 8B. 45, B8
        lea     rdi, [rel ?_604]                        ; 4741 _ 48: 8D. 3D, 00000000(rel)
        mov     rcx, rax                                ; 4748 _ 48: 89. C1
        mov     edx, 217                                ; 474B _ BA, 000000D9
        mov     esi, 1                                  ; 4750 _ BE, 00000001
        call    fwrite                                  ; 4755 _ E8, 00000000(PLT r)
?_451:  mov     eax, dword [rbp-3CH]                    ; 475A _ 8B. 45, C4
        mov     edi, eax                                ; 475D _ 89. C7
        call    help_opt                                ; 475F _ E8, FFFFFB1E
        test    al, al                                  ; 4764 _ 84. C0
        jz      ?_452                                   ; 4766 _ 74, 1D
        mov     rax, qword [rbp-48H]                    ; 4768 _ 48: 8B. 45, B8
        lea     rdi, [rel ?_605]                        ; 476C _ 48: 8D. 3D, 00000000(rel)
        mov     rcx, rax                                ; 4773 _ 48: 89. C1
        mov     edx, 211                                ; 4776 _ BA, 000000D3
        mov     esi, 1                                  ; 477B _ BE, 00000001
        call    fwrite                                  ; 4780 _ E8, 00000000(PLT r)
?_452:  mov     eax, dword [rbp-3CH]                    ; 4785 _ 8B. 45, C4
        mov     esi, 77                                 ; 4788 _ BE, 0000004D
        mov     edi, eax                                ; 478D _ 89. C7
        call    help_optor                              ; 478F _ E8, FFFFFB0A
        test    al, al                                  ; 4794 _ 84. C0
        jz      ?_455                                   ; 4796 _ 74, 31
        cmp     dword [rbp-3CH], 1                      ; 4798 _ 83. 7D, C4, 01
        jnz     ?_453                                   ; 479C _ 75, 09
        lea     rax, [rel ?_606]                        ; 479E _ 48: 8D. 05, 00000000(rel)
        jmp     ?_454                                   ; 47A5 _ EB, 07

?_453:  lea     rax, [rel ?_607]                        ; 47A7 _ 48: 8D. 05, 00000000(rel)
?_454:  lea     rsi, [rel ?_608]                        ; 47AE _ 48: 8D. 35, 00000000(rel)
        mov     rcx, qword [rbp-48H]                    ; 47B5 _ 48: 8B. 4D, B8
        mov     rdx, rax                                ; 47B9 _ 48: 89. C2
        mov     rdi, rcx                                ; 47BC _ 48: 89. CF
        mov     eax, 0                                  ; 47BF _ B8, 00000000
        call    fprintf                                 ; 47C4 _ E8, 00000000(PLT r)
?_455:  mov     eax, dword [rbp-3CH]                    ; 47C9 _ 8B. 45, C4
        mov     esi, 77                                 ; 47CC _ BE, 0000004D
        mov     edi, eax                                ; 47D1 _ 89. C7
        call    help_is                                 ; 47D3 _ E8, FFFFFA81
        test    al, al                                  ; 47D8 _ 84. C0
        jz      ?_456                                   ; 47DA _ 74, 1D
        mov     rax, qword [rbp-48H]                    ; 47DC _ 48: 8B. 45, B8
        lea     rdi, [rel ?_609]                        ; 47E0 _ 48: 8D. 3D, 00000000(rel)
        mov     rcx, rax                                ; 47E7 _ 48: 89. C1
        mov     edx, 407                                ; 47EA _ BA, 00000197
        mov     esi, 1                                  ; 47EF _ BE, 00000001
        call    fwrite                                  ; 47F4 _ E8, 00000000(PLT r)
?_456:  mov     eax, dword [rbp-3CH]                    ; 47F9 _ 8B. 45, C4
        mov     esi, 102                                ; 47FC _ BE, 00000066
        mov     edi, eax                                ; 4801 _ 89. C7
        call    help_optor                              ; 4803 _ E8, FFFFFA96
        test    al, al                                  ; 4808 _ 84. C0
        jz      ?_459                                   ; 480A _ 74, 31
        cmp     dword [rbp-3CH], 1                      ; 480C _ 83. 7D, C4, 01
        jnz     ?_457                                   ; 4810 _ 75, 09
        lea     rax, [rel ?_610]                        ; 4812 _ 48: 8D. 05, 00000000(rel)
        jmp     ?_458                                   ; 4819 _ EB, 07

?_457:  lea     rax, [rel ?_512]                        ; 481B _ 48: 8D. 05, 00000000(rel)
?_458:  lea     rsi, [rel ?_611]                        ; 4822 _ 48: 8D. 35, 00000000(rel)
        mov     rcx, qword [rbp-48H]                    ; 4829 _ 48: 8B. 4D, B8
        mov     rdx, rax                                ; 482D _ 48: 89. C2
        mov     rdi, rcx                                ; 4830 _ 48: 89. CF
        mov     eax, 0                                  ; 4833 _ B8, 00000000
        call    fprintf                                 ; 4838 _ E8, 00000000(PLT r)
?_459:  mov     eax, dword [rbp-3CH]                    ; 483D _ 8B. 45, C4
        mov     esi, 102                                ; 4840 _ BE, 00000066
        mov     edi, eax                                ; 4845 _ 89. C7
        call    help_is                                 ; 4847 _ E8, FFFFFA0D
        test    al, al                                  ; 484C _ 84. C0
        jz      ?_460                                   ; 484E _ 74, 16
        mov     rax, qword [rel ofmt]                   ; 4850 _ 48: 8B. 05, 00000000(rel)
        mov     rdx, qword [rbp-48H]                    ; 4857 _ 48: 8B. 55, B8
        mov     rsi, rdx                                ; 485B _ 48: 89. D6
        mov     rdi, rax                                ; 485E _ 48: 89. C7
        call    ofmt_list                               ; 4861 _ E8, 00000000(PLT r)
?_460:  mov     eax, dword [rbp-3CH]                    ; 4866 _ 8B. 45, C4
        mov     esi, 70                                 ; 4869 _ BE, 00000046
        mov     edi, eax                                ; 486E _ 89. C7
        call    help_optor                              ; 4870 _ E8, FFFFFA29
        test    al, al                                  ; 4875 _ 84. C0
        jz      ?_463                                   ; 4877 _ 74, 31
        cmp     dword [rbp-3CH], 1                      ; 4879 _ 83. 7D, C4, 01
        jnz     ?_461                                   ; 487D _ 75, 09
        lea     rax, [rel ?_612]                        ; 487F _ 48: 8D. 05, 00000000(rel)
        jmp     ?_462                                   ; 4886 _ EB, 07

?_461:  lea     rax, [rel ?_512]                        ; 4888 _ 48: 8D. 05, 00000000(rel)
?_462:  lea     rsi, [rel ?_613]                        ; 488F _ 48: 8D. 35, 00000000(rel)
        mov     rcx, qword [rbp-48H]                    ; 4896 _ 48: 8B. 4D, B8
        mov     rdx, rax                                ; 489A _ 48: 89. C2
        mov     rdi, rcx                                ; 489D _ 48: 89. CF
        mov     eax, 0                                  ; 48A0 _ B8, 00000000
        call    fprintf                                 ; 48A5 _ E8, 00000000(PLT r)
?_463:  mov     eax, dword [rbp-3CH]                    ; 48AA _ 8B. 45, C4
        mov     esi, 70                                 ; 48AD _ BE, 00000046
        mov     edi, eax                                ; 48B2 _ 89. C7
        call    help_is                                 ; 48B4 _ E8, FFFFF9A0
        test    al, al                                  ; 48B9 _ 84. C0
        jz      ?_464                                   ; 48BB _ 74, 0C
        mov     rax, qword [rbp-48H]                    ; 48BD _ 48: 8B. 45, B8
        mov     rdi, rax                                ; 48C1 _ 48: 89. C7
        call    dfmt_list                               ; 48C4 _ E8, 00000000(PLT r)
?_464:  mov     eax, dword [rbp-3CH]                    ; 48C9 _ 8B. 45, C4
        mov     esi, 76                                 ; 48CC _ BE, 0000004C
        mov     edi, eax                                ; 48D1 _ 89. C7
        call    help_optor                              ; 48D3 _ E8, FFFFF9C6
        test    al, al                                  ; 48D8 _ 84. C0
        jz      ?_467                                   ; 48DA _ 74, 31
        cmp     dword [rbp-3CH], 1                      ; 48DC _ 83. 7D, C4, 01
        jnz     ?_465                                   ; 48E0 _ 75, 09
        lea     rax, [rel ?_614]                        ; 48E2 _ 48: 8D. 05, 00000000(rel)
        jmp     ?_466                                   ; 48E9 _ EB, 07

?_465:  lea     rax, [rel ?_512]                        ; 48EB _ 48: 8D. 05, 00000000(rel)
?_466:  lea     rsi, [rel ?_615]                        ; 48F2 _ 48: 8D. 35, 00000000(rel)
        mov     rcx, qword [rbp-48H]                    ; 48F9 _ 48: 8B. 4D, B8
        mov     rdx, rax                                ; 48FD _ 48: 89. C2
        mov     rdi, rcx                                ; 4900 _ 48: 89. CF
        mov     eax, 0                                  ; 4903 _ B8, 00000000
        call    fprintf                                 ; 4908 _ E8, 00000000(PLT r)
?_467:  mov     eax, dword [rbp-3CH]                    ; 490D _ 8B. 45, C4
        mov     esi, 76                                 ; 4910 _ BE, 0000004C
        mov     edi, eax                                ; 4915 _ 89. C7
        call    help_is                                 ; 4917 _ E8, FFFFF93D
        test    al, al                                  ; 491C _ 84. C0
        jz      ?_468                                   ; 491E _ 74, 1D
        mov     rax, qword [rbp-48H]                    ; 4920 _ 48: 8B. 45, B8
        lea     rdi, [rel ?_616]                        ; 4924 _ 48: 8D. 3D, 00000000(rel)
        mov     rcx, rax                                ; 492B _ 48: 89. C1
        mov     edx, 1008                               ; 492E _ BA, 000003F0
        mov     esi, 1                                  ; 4933 _ BE, 00000001
        call    fwrite                                  ; 4938 _ E8, 00000000(PLT r)
?_468:  mov     eax, dword [rbp-3CH]                    ; 493D _ 8B. 45, C4
        mov     esi, 79                                 ; 4940 _ BE, 0000004F
        mov     edi, eax                                ; 4945 _ 89. C7
        call    help_optor                              ; 4947 _ E8, FFFFF952
        test    al, al                                  ; 494C _ 84. C0
        jz      ?_471                                   ; 494E _ 74, 31
        cmp     dword [rbp-3CH], 1                      ; 4950 _ 83. 7D, C4, 01
        jnz     ?_469                                   ; 4954 _ 75, 09
        lea     rax, [rel ?_617]                        ; 4956 _ 48: 8D. 05, 00000000(rel)
        jmp     ?_470                                   ; 495D _ EB, 07

?_469:  lea     rax, [rel ?_512]                        ; 495F _ 48: 8D. 05, 00000000(rel)
?_470:  lea     rsi, [rel ?_618]                        ; 4966 _ 48: 8D. 35, 00000000(rel)
        mov     rcx, qword [rbp-48H]                    ; 496D _ 48: 8B. 4D, B8
        mov     rdx, rax                                ; 4971 _ 48: 89. C2
        mov     rdi, rcx                                ; 4974 _ 48: 89. CF
        mov     eax, 0                                  ; 4977 _ B8, 00000000
        call    fprintf                                 ; 497C _ E8, 00000000(PLT r)
?_471:  mov     eax, dword [rbp-3CH]                    ; 4981 _ 8B. 45, C4
        mov     esi, 79                                 ; 4984 _ BE, 0000004F
        mov     edi, eax                                ; 4989 _ 89. C7
        call    help_is                                 ; 498B _ E8, FFFFF8C9
        test    al, al                                  ; 4990 _ 84. C0
        jz      ?_472                                   ; 4992 _ 74, 1D
        mov     rax, qword [rbp-48H]                    ; 4994 _ 48: 8B. 45, B8
        lea     rdi, [rel ?_619]                        ; 4998 _ 48: 8D. 3D, 00000000(rel)
        mov     rcx, rax                                ; 499F _ 48: 89. C1
        mov     edx, 200                                ; 49A2 _ BA, 000000C8
        mov     esi, 1                                  ; 49A7 _ BE, 00000001
        call    fwrite                                  ; 49AC _ E8, 00000000(PLT r)
?_472:  mov     eax, dword [rbp-3CH]                    ; 49B1 _ 8B. 45, C4
        mov     edi, eax                                ; 49B4 _ 89. C7
        call    help_opt                                ; 49B6 _ E8, FFFFF8C7
        test    al, al                                  ; 49BB _ 84. C0
        jz      ?_473                                   ; 49BD _ 74, 1D
        mov     rax, qword [rbp-48H]                    ; 49BF _ 48: 8B. 45, B8
        lea     rdi, [rel ?_620]                        ; 49C3 _ 48: 8D. 3D, 00000000(rel)
        mov     rcx, rax                                ; 49CA _ 48: 89. C1
        mov     edx, 380                                ; 49CD _ BA, 0000017C
        mov     esi, 1                                  ; 49D2 _ BE, 00000001
        call    fwrite                                  ; 49D7 _ E8, 00000000(PLT r)
?_473:  mov     eax, dword [rbp-3CH]                    ; 49DC _ 8B. 45, C4
        mov     esi, 119                                ; 49DF _ BE, 00000077
        mov     edi, eax                                ; 49E4 _ 89. C7
        call    help_optor                              ; 49E6 _ E8, FFFFF8B3
        test    al, al                                  ; 49EB _ 84. C0
        jz      ?_476                                   ; 49ED _ 74, 31
        cmp     dword [rbp-3CH], 1                      ; 49EF _ 83. 7D, C4, 01
        jnz     ?_474                                   ; 49F3 _ 75, 09
        lea     rax, [rel ?_621]                        ; 49F5 _ 48: 8D. 05, 00000000(rel)
        jmp     ?_475                                   ; 49FC _ EB, 07

?_474:  lea     rax, [rel ?_512]                        ; 49FE _ 48: 8D. 05, 00000000(rel)
?_475:  lea     rsi, [rel ?_622]                        ; 4A05 _ 48: 8D. 35, 00000000(rel)
        mov     rcx, qword [rbp-48H]                    ; 4A0C _ 48: 8B. 4D, B8
        mov     rdx, rax                                ; 4A10 _ 48: 89. C2
        mov     rdi, rcx                                ; 4A13 _ 48: 89. CF
        mov     eax, 0                                  ; 4A16 _ B8, 00000000
        call    fprintf                                 ; 4A1B _ E8, 00000000(PLT r)
?_476:  mov     eax, dword [rbp-3CH]                    ; 4A20 _ 8B. 45, C4
        mov     esi, 119                                ; 4A23 _ BE, 00000077
        mov     edi, eax                                ; 4A28 _ 89. C7
        call    help_is                                 ; 4A2A _ E8, FFFFF82A
        test    al, al                                  ; 4A2F _ 84. C0
        je      ?_491                                   ; 4A31 _ 0F 84, 000002B3
        mov     rax, qword [rbp-48H]                    ; 4A37 _ 48: 8B. 45, B8
        lea     rdi, [rel ?_623]                        ; 4A3B _ 48: 8D. 3D, 00000000(rel)
        mov     rcx, rax                                ; 4A42 _ 48: 89. C1
        mov     edx, 28                                 ; 4A45 _ BA, 0000001C
        mov     esi, 1                                  ; 4A4A _ BE, 00000001
        call    fwrite                                  ; 4A4F _ E8, 00000000(PLT r)
        mov     rcx, qword [rel warning_help+228H]      ; 4A54 _ 48: 8B. 0D, 00000000(rel)
        mov     rdx, qword [rel warning_name+228H]      ; 4A5B _ 48: 8B. 15, 00000000(rel)
        lea     rsi, [rel ?_624]                        ; 4A62 _ 48: 8D. 35, 00000000(rel)
        mov     rax, qword [rbp-48H]                    ; 4A69 _ 48: 8B. 45, B8
        mov     rdi, rax                                ; 4A6D _ 48: 89. C7
        mov     eax, 0                                  ; 4A70 _ B8, 00000000
        call    fprintf                                 ; 4A75 _ E8, 00000000(PLT r)
        mov     dword [rbp-40H], 1                      ; 4A7A _ C7. 45, C0, 00000001
        jmp     ?_490                                   ; 4A81 _ E9, 0000025A

?_477:  mov     eax, dword [rbp-40H]                    ; 4A86 _ 8B. 45, C0
        cdqe                                            ; 4A89 _ 48: 98
        lea     rdx, [rax*8]                            ; 4A8B _ 48: 8D. 14 C5, 00000000
        lea     rax, [rel warning_name]                 ; 4A93 _ 48: 8D. 05, 00000000(rel)
        mov     rax, qword [rdx+rax]                    ; 4A9A _ 48: 8B. 04 02
        mov     qword [rbp-28H], rax                    ; 4A9E _ 48: 89. 45, D8
        mov     eax, dword [rbp-40H]                    ; 4AA2 _ 8B. 45, C0
        sub     eax, 1                                  ; 4AA5 _ 83. E8, 01
        cdqe                                            ; 4AA8 _ 48: 98
        lea     rdx, [rax*8]                            ; 4AAA _ 48: 8D. 14 C5, 00000000
        lea     rax, [rel warning_name]                 ; 4AB2 _ 48: 8D. 05, 00000000(rel)
        mov     rax, qword [rdx+rax]                    ; 4AB9 _ 48: 8B. 04 02
        mov     qword [rbp-20H], rax                    ; 4ABD _ 48: 89. 45, E0
        mov     eax, dword [rbp-40H]                    ; 4AC1 _ 8B. 45, C0
        add     eax, 1                                  ; 4AC4 _ 83. C0, 01
        cdqe                                            ; 4AC7 _ 48: 98
        lea     rdx, [rax*8]                            ; 4AC9 _ 48: 8D. 14 C5, 00000000
        lea     rax, [rel warning_name]                 ; 4AD1 _ 48: 8D. 05, 00000000(rel)
        mov     rax, qword [rdx+rax]                    ; 4AD8 _ 48: 8B. 04 02
        mov     qword [rbp-18H], rax                    ; 4ADC _ 48: 89. 45, E8
        cmp     qword [rbp-20H], 0                      ; 4AE0 _ 48: 83. 7D, E0, 00
        je      ?_484                                   ; 4AE5 _ 0F 84, 00000114
        mov     rax, qword [rbp-20H]                    ; 4AEB _ 48: 8B. 45, E0
        mov     rdi, rax                                ; 4AEF _ 48: 89. C7
        call    strlen                                  ; 4AF2 _ E8, 00000000(PLT r)
        mov     dword [rbp-38H], eax                    ; 4AF7 _ 89. 45, C8
        mov     rax, qword [rbp-28H]                    ; 4AFA _ 48: 8B. 45, D8
        mov     qword [rbp-30H], rax                    ; 4AFE _ 48: 89. 45, D0
        jmp     ?_482                                   ; 4B02 _ E9, 000000D1

?_478:  mov     rax, qword [rbp-30H]                    ; 4B07 _ 48: 8B. 45, D0
        sub     rax, qword [rbp-28H]                    ; 4B0B _ 48: 2B. 45, D8
        mov     dword [rbp-34H], eax                    ; 4B0F _ 89. 45, CC
        mov     eax, dword [rbp-34H]                    ; 4B12 _ 8B. 45, CC
        add     eax, 1                                  ; 4B15 _ 83. C0, 01
        movsxd  rdx, eax                                ; 4B18 _ 48: 63. D0
        mov     rcx, qword [rbp-28H]                    ; 4B1B _ 48: 8B. 4D, D8
        mov     rax, qword [rbp-18H]                    ; 4B1F _ 48: 8B. 45, E8
        mov     rsi, rcx                                ; 4B23 _ 48: 89. CE
        mov     rdi, rax                                ; 4B26 _ 48: 89. C7
        call    strncmp                                 ; 4B29 _ E8, 00000000(PLT r)
        test    eax, eax                                ; 4B2E _ 85. C0
        jne     ?_483                                   ; 4B30 _ 0F 85, 000000C8
        mov     eax, dword [rbp-34H]                    ; 4B36 _ 8B. 45, CC
        cmp     eax, dword [rbp-38H]                    ; 4B39 _ 3B. 45, C8
        jge     ?_479                                   ; 4B3C _ 7D, 45
        mov     eax, dword [rbp-34H]                    ; 4B3E _ 8B. 45, CC
        movsxd  rdx, eax                                ; 4B41 _ 48: 63. D0
        mov     rcx, qword [rbp-28H]                    ; 4B44 _ 48: 8B. 4D, D8
        mov     rax, qword [rbp-20H]                    ; 4B48 _ 48: 8B. 45, E0
        mov     rsi, rcx                                ; 4B4C _ 48: 89. CE
        mov     rdi, rax                                ; 4B4F _ 48: 89. C7
        call    strncmp                                 ; 4B52 _ E8, 00000000(PLT r)
        test    eax, eax                                ; 4B57 _ 85. C0
        jnz     ?_479                                   ; 4B59 _ 75, 28
        mov     eax, dword [rbp-34H]                    ; 4B5B _ 8B. 45, CC
        movsxd  rdx, eax                                ; 4B5E _ 48: 63. D0
        mov     rax, qword [rbp-20H]                    ; 4B61 _ 48: 8B. 45, E0
        add     rax, rdx                                ; 4B65 _ 48: 01. D0
        movzx   eax, byte [rax]                         ; 4B68 _ 0F B6. 00
        cmp     al, 45                                  ; 4B6B _ 3C, 2D
        jz      ?_482                                   ; 4B6D _ 74, 69
        mov     eax, dword [rbp-34H]                    ; 4B6F _ 8B. 45, CC
        movsxd  rdx, eax                                ; 4B72 _ 48: 63. D0
        mov     rax, qword [rbp-20H]                    ; 4B75 _ 48: 8B. 45, E0
        add     rax, rdx                                ; 4B79 _ 48: 01. D0
        movzx   eax, byte [rax]                         ; 4B7C _ 0F B6. 00
        test    al, al                                  ; 4B7F _ 84. C0
        jz      ?_482                                   ; 4B81 _ 74, 55
?_479:  mov     eax, dword [rbp-34H]                    ; 4B83 _ 8B. 45, CC
        lea     r8d, [rax+1H]                           ; 4B86 _ 44: 8D. 40, 01
        cmp     dword [rbp-34H], 19                     ; 4B8A _ 83. 7D, CC, 13
        setg    al                                      ; 4B8E _ 0F 9F. C0
        movzx   eax, al                                 ; 4B91 _ 0F B6. C0
        and     eax, 01H                                ; 4B94 _ 83. E0, 01
        test    al, al                                  ; 4B97 _ 84. C0
        jz      ?_480                                   ; 4B99 _ 74, 09
        lea     rax, [rel nl_indent.0]                  ; 4B9B _ 48: 8D. 05, 00000000(rel)
        jmp     ?_481                                   ; 4BA2 _ EB, 07

?_480:  lea     rax, [rel ?_625]                        ; 4BA4 _ 48: 8D. 05, 00000000(rel)
?_481:  mov     rcx, qword [rbp-28H]                    ; 4BAB _ 48: 8B. 4D, D8
        mov     edx, dword [rbp-34H]                    ; 4BAF _ 8B. 55, CC
        lea     rsi, [rel ?_626]                        ; 4BB2 _ 48: 8D. 35, 00000000(rel)
        mov     rdi, qword [rbp-48H]                    ; 4BB9 _ 48: 8B. 7D, B8
        sub     rsp, 8                                  ; 4BBD _ 48: 83. EC, 08
        push    qword [rbp-28H]                         ; 4BC1 _ FF. 75, D8
        mov     r9d, r8d                                ; 4BC4 _ 45: 89. C1
        mov     r8, rax                                 ; 4BC7 _ 49: 89. C0
        mov     eax, 0                                  ; 4BCA _ B8, 00000000
        call    fprintf                                 ; 4BCF _ E8, 00000000(PLT r)
        add     rsp, 16                                 ; 4BD4 _ 48: 83. C4, 10
?_482:  mov     rax, qword [rbp-30H]                    ; 4BD8 _ 48: 8B. 45, D0
        add     rax, 1                                  ; 4BDC _ 48: 83. C0, 01
        mov     esi, 45                                 ; 4BE0 _ BE, 0000002D
        mov     rdi, rax                                ; 4BE5 _ 48: 89. C7
        call    strchr                                  ; 4BE8 _ E8, 00000000(PLT r)
        mov     qword [rbp-30H], rax                    ; 4BED _ 48: 89. 45, D0
        cmp     qword [rbp-30H], 0                      ; 4BF1 _ 48: 83. 7D, D0, 00
        jne     ?_478                                   ; 4BF6 _ 0F 85, FFFFFF0B
        jmp     ?_484                                   ; 4BFC _ EB, 01

?_483:  nop                                             ; 4BFE _ 90
?_484:  mov     eax, dword [rbp-40H]                    ; 4BFF _ 8B. 45, C0
        cdqe                                            ; 4C02 _ 48: 98
        lea     rdx, [rel warning_default]              ; 4C04 _ 48: 8D. 15, 00000000(rel)
        movzx   eax, byte [rax+rdx]                     ; 4C0B _ 0F B6. 04 10
        movzx   eax, al                                 ; 4C0F _ 0F B6. C0
        and     eax, 02H                                ; 4C12 _ 83. E0, 02
        test    eax, eax                                ; 4C15 _ 85. C0
        jnz     ?_486                                   ; 4C17 _ 75, 2C
        mov     eax, dword [rbp-40H]                    ; 4C19 _ 8B. 45, C0
        cdqe                                            ; 4C1C _ 48: 98
        lea     rdx, [rel warning_default]              ; 4C1E _ 48: 8D. 15, 00000000(rel)
        movzx   eax, byte [rax+rdx]                     ; 4C25 _ 0F B6. 04 10
        movzx   eax, al                                 ; 4C29 _ 0F B6. C0
        and     eax, 01H                                ; 4C2C _ 83. E0, 01
        test    eax, eax                                ; 4C2F _ 85. C0
        jz      ?_485                                   ; 4C31 _ 74, 09
        lea     rbx, [rel ?_627]                        ; 4C33 _ 48: 8D. 1D, 00000000(rel)
        jmp     ?_487                                   ; 4C3A _ EB, 10

?_485:  lea     rbx, [rel ?_628]                        ; 4C3C _ 48: 8D. 1D, 00000000(rel)
        jmp     ?_487                                   ; 4C43 _ EB, 07

?_486:  lea     rbx, [rel ?_629]                        ; 4C45 _ 48: 8D. 1D, 00000000(rel)
?_487:  mov     eax, dword [rbp-40H]                    ; 4C4C _ 8B. 45, C0
        cdqe                                            ; 4C4F _ 48: 98
        lea     rdx, [rax*8]                            ; 4C51 _ 48: 8D. 14 C5, 00000000
        lea     rax, [rel warning_help]                 ; 4C59 _ 48: 8D. 05, 00000000(rel)
        mov     r12, qword [rdx+rax]                    ; 4C60 _ 4C: 8B. 24 02
        mov     eax, dword [rbp-40H]                    ; 4C64 _ 8B. 45, C0
        cdqe                                            ; 4C67 _ 48: 98
        lea     rdx, [rax*8]                            ; 4C69 _ 48: 8D. 14 C5, 00000000
        lea     rax, [rel warning_name]                 ; 4C71 _ 48: 8D. 05, 00000000(rel)
        mov     rax, qword [rdx+rax]                    ; 4C78 _ 48: 8B. 04 02
        mov     rdi, rax                                ; 4C7C _ 48: 89. C7
        call    strlen                                  ; 4C7F _ E8, 00000000(PLT r)
        cmp     rax, 19                                 ; 4C84 _ 48: 83. F8, 13
        seta    al                                      ; 4C88 _ 0F 97. C0
        movzx   eax, al                                 ; 4C8B _ 0F B6. C0
        and     eax, 01H                                ; 4C8E _ 83. E0, 01
        test    al, al                                  ; 4C91 _ 84. C0
        jz      ?_488                                   ; 4C93 _ 74, 09
        lea     rax, [rel nl_indent.0]                  ; 4C95 _ 48: 8D. 05, 00000000(rel)
        jmp     ?_489                                   ; 4C9C _ EB, 07

?_488:  lea     rax, [rel ?_625]                        ; 4C9E _ 48: 8D. 05, 00000000(rel)
?_489:  mov     edx, dword [rbp-40H]                    ; 4CA5 _ 8B. 55, C0
        movsxd  rdx, edx                                ; 4CA8 _ 48: 63. D2
        lea     rcx, [rdx*8]                            ; 4CAB _ 48: 8D. 0C D5, 00000000
        lea     rdx, [rel warning_name]                 ; 4CB3 _ 48: 8D. 15, 00000000(rel)
        mov     rdx, qword [rcx+rdx]                    ; 4CBA _ 48: 8B. 14 11
        lea     rsi, [rel ?_630]                        ; 4CBE _ 48: 8D. 35, 00000000(rel)
        mov     rdi, qword [rbp-48H]                    ; 4CC5 _ 48: 8B. 7D, B8
        mov     r9, rbx                                 ; 4CC9 _ 49: 89. D9
        mov     r8, r12                                 ; 4CCC _ 4D: 89. E0
        mov     rcx, rax                                ; 4CCF _ 48: 89. C1
        mov     eax, 0                                  ; 4CD2 _ B8, 00000000
        call    fprintf                                 ; 4CD7 _ E8, 00000000(PLT r)
        add     dword [rbp-40H], 1                      ; 4CDC _ 83. 45, C0, 01
?_490:  cmp     dword [rbp-40H], 68                     ; 4CE0 _ 83. 7D, C0, 44
        jle     ?_477                                   ; 4CE4 _ 0F 8E, FFFFFD9C
?_491:  mov     eax, dword [rbp-3CH]                    ; 4CEA _ 8B. 45, C4
        mov     edi, eax                                ; 4CED _ 89. C7
        call    help_opt                                ; 4CEF _ E8, FFFFF58E
        test    al, al                                  ; 4CF4 _ 84. C0
        jz      ?_492                                   ; 4CF6 _ 74, 1D
        mov     rax, qword [rbp-48H]                    ; 4CF8 _ 48: 8B. 45, B8
        lea     rdi, [rel ?_631]                        ; 4CFC _ 48: 8D. 3D, 00000000(rel)
        mov     rcx, rax                                ; 4D03 _ 48: 89. C1
        mov     edx, 816                                ; 4D06 _ BA, 00000330
        mov     esi, 1                                  ; 4D0B _ BE, 00000001
        call    fwrite                                  ; 4D10 _ E8, 00000000(PLT r)
?_492:  mov     eax, dword [rbp-3CH]                    ; 4D15 _ 8B. 45, C4
        mov     esi, 3                                  ; 4D18 _ BE, 00000003
        mov     edi, eax                                ; 4D1D _ 89. C7
        call    help_is                                 ; 4D1F _ E8, FFFFF535
        test    al, al                                  ; 4D24 _ 84. C0
        je      ?_495                                   ; 4D26 _ 0F 84, 000000CE
        mov     rax, qword [rbp-48H]                    ; 4D2C _ 48: 8B. 45, B8
        lea     rdi, [rel ?_632]                        ; 4D30 _ 48: 8D. 3D, 00000000(rel)
        mov     rcx, rax                                ; 4D37 _ 48: 89. C1
        mov     edx, 40                                 ; 4D3A _ BA, 00000028
        mov     esi, 1                                  ; 4D3F _ BE, 00000001
        call    fwrite                                  ; 4D44 _ E8, 00000000(PLT r)
        mov     dword [rbp-40H], 0                      ; 4D49 _ C7. 45, C0, 00000000
        jmp     ?_494                                   ; 4D50 _ E9, 00000099

?_493:  mov     eax, dword [rbp-40H]                    ; 4D55 _ 8B. 45, C0
        mov     edi, eax                                ; 4D58 _ 89. C7
        call    limit_default                           ; 4D5A _ E8, FFFFB5CC
        mov     rdi, rax                                ; 4D5F _ 48: 89. C7
        call    limit_str                               ; 4D62 _ E8, FFFFB6AD
        mov     rdi, rax                                ; 4D67 _ 48: 89. C7
        mov     eax, dword [rbp-40H]                    ; 4D6A _ 8B. 45, C0
        cdqe                                            ; 4D6D _ 48: 98
        shl     rax, 5                                  ; 4D6F _ 48: C1. E0, 05
        mov     rdx, rax                                ; 4D73 _ 48: 89. C2
        lea     rax, [rel ?_637]                        ; 4D76 _ 48: 8D. 05, 00000000(rel)
        mov     rcx, qword [rdx+rax]                    ; 4D7D _ 48: 8B. 0C 02
        mov     eax, dword [rbp-40H]                    ; 4D81 _ 8B. 45, C0
        cdqe                                            ; 4D84 _ 48: 98
        shl     rax, 5                                  ; 4D86 _ 48: C1. E0, 05
        mov     rdx, rax                                ; 4D8A _ 48: 89. C2
        lea     rax, [rel limit_info]                   ; 4D8D _ 48: 8D. 05, 00000000(rel)
        mov     rdx, qword [rdx+rax]                    ; 4D94 _ 48: 8B. 14 02
        lea     r8, [rel ?_512]                         ; 4D98 _ 4C: 8D. 05, 00000000(rel)
        lea     rsi, [rel ?_633]                        ; 4D9F _ 48: 8D. 35, 00000000(rel)
        mov     rax, qword [rbp-48H]                    ; 4DA6 _ 48: 8B. 45, B8
        mov     r9, rdi                                 ; 4DAA _ 49: 89. F9
        mov     rdi, rax                                ; 4DAD _ 48: 89. C7
        mov     eax, 0                                  ; 4DB0 _ B8, 00000000
        call    fprintf                                 ; 4DB5 _ E8, 00000000(PLT r)
        mov     eax, dword [rbp-40H]                    ; 4DBA _ 8B. 45, C0
        mov     edi, eax                                ; 4DBD _ 89. C7
        call    limit_max                               ; 4DBF _ E8, FFFFB5ED
        mov     rdi, rax                                ; 4DC4 _ 48: 89. C7
        call    limit_str                               ; 4DC7 _ E8, FFFFB648
        mov     rdx, rax                                ; 4DCC _ 48: 89. C2
        lea     rcx, [rel ?_634]                        ; 4DCF _ 48: 8D. 0D, 00000000(rel)
        mov     rax, qword [rbp-48H]                    ; 4DD6 _ 48: 8B. 45, B8
        mov     rsi, rcx                                ; 4DDA _ 48: 89. CE
        mov     rdi, rax                                ; 4DDD _ 48: 89. C7
        mov     eax, 0                                  ; 4DE0 _ B8, 00000000
        call    fprintf                                 ; 4DE5 _ E8, 00000000(PLT r)
        add     dword [rbp-40H], 1                      ; 4DEA _ 83. 45, C0, 01
?_494:  cmp     dword [rbp-40H], 8                      ; 4DEE _ 83. 7D, C0, 08
        jle     ?_493                                   ; 4DF2 _ 0F 8E, FFFFFF5D
        jmp     ?_498                                   ; 4DF8 _ EB, 44

?_495:  mov     eax, dword [rbp-3CH]                    ; 4DFA _ 8B. 45, C4
        mov     esi, 3                                  ; 4DFD _ BE, 00000003
        mov     edi, eax                                ; 4E02 _ 89. C7
        call    help_optor                              ; 4E04 _ E8, FFFFF495
        test    al, al                                  ; 4E09 _ 84. C0
        jz      ?_498                                   ; 4E0B _ 74, 31
        cmp     dword [rbp-3CH], 1                      ; 4E0D _ 83. 7D, C4, 01
        jnz     ?_496                                   ; 4E11 _ 75, 09
        lea     rax, [rel ?_635]                        ; 4E13 _ 48: 8D. 05, 00000000(rel)
        jmp     ?_497                                   ; 4E1A _ EB, 07

?_496:  lea     rax, [rel ?_512]                        ; 4E1C _ 48: 8D. 05, 00000000(rel)
?_497:  lea     rsi, [rel ?_636]                        ; 4E23 _ 48: 8D. 35, 00000000(rel)
        mov     rcx, qword [rbp-48H]                    ; 4E2A _ 48: 8B. 4D, B8
        mov     rdx, rax                                ; 4E2E _ 48: 89. C2
        mov     rdi, rcx                                ; 4E31 _ 48: 89. CF
        mov     eax, 0                                  ; 4E34 _ B8, 00000000
        call    fprintf                                 ; 4E39 _ E8, 00000000(PLT r)
?_498:  lea     rsp, [rbp-10H]                          ; 4E3E _ 48: 8D. 65, F0
        pop     rbx                                     ; 4E42 _ 5B
        pop     r12                                     ; 4E43 _ 41: 5C
        pop     rbp                                     ; 4E45 _ 5D
        ret                                             ; 4E46 _ C3


SECTION .data   align=4 noexec                          ; section number 2, data

cmd_sb:                                                 ; dword
        dd 00000010H                                    ; 0000 _ 16 


SECTION .bss    align=32 noexec                         ; section number 3, bss

_progname:                                              ; qword
        resq    1                                       ; 0000

tasm_compatible_mode:                                   ; byte
        resb    4                                       ; 0008

_pass_type:                                             ; dword
        resd    1                                       ; 000C

_passn: resq    2                                       ; 0010

official_compile_time:                                  ; byte
        resb    136                                     ; 0020

ofmt_alias:                                             ; qword
        resq    1                                       ; 00A8

dfmt:   resq    1                                       ; 00B0

errflags_never:                                         ; dword
        resd    2                                       ; 00B8

ofile:  resq    1                                       ; 00C0

optimizing:                                             ; dword
        resd    2                                       ; 00C8

cpu:                                                    ; byte
        resq    4                                       ; 00D0

cmd_cpu:                                                ; byte
        resq    4                                       ; 00F0

location:                                               ; oword
        resq    2                                       ; 0110

in_absolute:                                            ; byte
        resb    16                                      ; 0120

absolute:                                               ; oword
        resq    2                                       ; 0130

depend_list:                                            ; qword
        resq    4                                       ; 0140

nasm_limit:                                             ; byte
        resq    9                                       ; 0160

using_debug_info:                                       ; byte
        resb    8                                       ; 01A8

debug_format:                                           ; qword
        resq    1                                       ; 01B0

debug_format_owned:                                     ; byte
        resb    1                                       ; 01B8

abort_on_panic:                                         ; byte
        resb    1                                       ; 01B9

keep_all: resb  6                                       ; 01BA

globallineno:                                           ; qword
        resq    1                                       ; 01C0

debug_prefixes:                                         ; qword
        resq    1                                       ; 01C8

offsets: resq   1                                       ; 01D0

forwrefs: resq  1                                       ; 01D8

forwref: resq   1                                       ; 01E0

include_path:                                           ; qword
        resq    1                                       ; 01E8

ppopt:  resd    1                                       ; 01F0

operating_mode:                                         ; dword
        resd    1                                       ; 01F4

depend_emit_phony:                                      ; byte
        resb    1                                       ; 01F8

depend_missing_ok:                                      ; byte
        resb    7                                       ; 01F9

nasm_limit_from_cmdline:                                ; byte
        resq    1                                       ; 0200

?_499:  resq    1                                       ; 0208

?_500:  resq    1                                       ; 0210

?_501:  resq    1                                       ; 0218

?_502:  resq    1                                       ; 0220

?_503:  resq    1                                       ; 0228

?_504:  resq    1                                       ; 0230

?_505:  resq    1                                       ; 0238

?_506:  resq    1                                       ; 0240

stopoptions:                                            ; byte
        resb    8                                       ; 0248

buf.5:                                                  ; byte
        resb    32                                      ; 0250

stall_count.1:                                          ; qword
        resq    1                                       ; 0270


SECTION .rodata align=16 noexec                         ; section number 4, const

?_507:                                                  ; byte
        db 69H, 6EH, 63H, 6CH, 75H, 64H, 65H, 2FH       ; 0000 _ include/
        db 66H, 69H, 6CH, 65H, 73H, 2EH, 68H, 00H       ; 0008 _ files.h.

?_508:                                                  ; byte
        db 28H, 73H, 69H, 7AH, 65H, 5FH, 74H, 29H       ; 0010 _ (size_t)
        db 66H, 6EH, 20H, 3CH, 20H, 41H, 52H, 52H       ; 0018 _ fn < ARR
        db 41H, 59H, 5FH, 53H, 49H, 5AH, 45H, 28H       ; 0020 _ AY_SIZE(
        db 5FH, 66H, 69H, 6CH, 65H, 6EH, 61H, 6DH       ; 0028 _ _filenam
        db 65H, 73H, 29H, 00H                           ; 0030 _ es).

?_509:                                                  ; byte
        db 69H, 6EH, 69H, 74H, 00H, 70H, 72H, 65H       ; 0034 _ init.pre
        db 70H, 72H, 6FH, 63H, 2DH, 6FH, 6EH, 6CH       ; 003C _ proc-onl
        db 79H, 00H, 66H, 69H, 72H, 73H, 74H, 00H       ; 0044 _ y.first.
        db 6FH, 70H, 74H, 69H, 6DH, 69H, 7AH, 65H       ; 004C _ optimize
        db 00H, 73H, 74H, 61H, 62H, 69H, 6CH, 69H       ; 0054 _ .stabili
        db 7AH, 65H, 00H, 66H, 69H, 6EH, 61H, 6CH       ; 005C _ ze.final
        db 00H, 70H, 61H, 73H, 73H, 65H, 73H, 00H       ; 0064 _ .passes.
        db 74H, 6FH, 74H, 61H, 6CH, 20H, 6EH, 75H       ; 006C _ total nu
        db 6DH, 62H, 65H, 72H, 20H, 6FH, 66H, 20H       ; 0074 _ mber of 
        db 70H, 61H, 73H, 73H, 65H, 73H, 00H, 73H       ; 007C _ passes.s
        db 74H, 61H, 6CH, 6CH, 65H, 64H, 2DH, 70H       ; 0084 _ talled-p
        db 61H, 73H, 73H, 65H, 73H, 00H, 00H, 00H       ; 008C _ asses...
        db 00H, 00H, 00H, 00H, 6EH, 75H, 6DH, 62H       ; 0094 _ ....numb
        db 65H, 72H, 20H, 6FH, 66H, 20H, 70H, 61H       ; 009C _ er of pa
        db 73H, 73H, 65H, 73H, 20H, 77H, 69H, 74H       ; 00A4 _ sses wit
        db 68H, 6FH, 75H, 74H, 20H, 66H, 6FH, 72H       ; 00AC _ hout for
        db 77H, 61H, 72H, 64H, 20H, 70H, 72H, 6FH       ; 00B4 _ ward pro
        db 67H, 72H, 65H, 73H, 73H, 00H, 6DH, 61H       ; 00BC _ gress.ma
        db 63H, 72H, 6FH, 2DH, 6CH, 65H, 76H, 65H       ; 00C4 _ cro-leve
        db 6CH, 73H, 00H, 6CH, 65H, 76H, 65H, 6CH       ; 00CC _ ls.level
        db 73H, 20H, 6FH, 66H, 20H, 6DH, 61H, 63H       ; 00D4 _ s of mac
        db 72H, 6FH, 20H, 65H, 78H, 70H, 61H, 6EH       ; 00DC _ ro expan
        db 73H, 69H, 6FH, 6EH, 00H, 6DH, 61H, 63H       ; 00E4 _ sion.mac
        db 72H, 6FH, 2DH, 74H, 6FH, 6BH, 65H, 6EH       ; 00EC _ ro-token
        db 73H, 00H, 00H, 00H, 74H, 6FH, 6BH, 65H       ; 00F4 _ s...toke
        db 6EH, 73H, 20H, 70H, 72H, 6FH, 63H, 65H       ; 00FC _ ns proce
        db 73H, 73H, 65H, 64H, 20H, 64H, 75H, 72H       ; 0104 _ ssed dur
        db 69H, 6EH, 67H, 20H, 73H, 69H, 6EH, 67H       ; 010C _ ing sing
        db 6CH, 65H, 2DH, 6CH, 69H, 6EH, 65H, 20H       ; 0114 _ le-line 
        db 6DH, 61H, 63H, 72H, 6FH, 20H, 65H, 78H       ; 011C _ macro ex
        db 70H, 61H, 6EH, 73H, 69H, 6FH, 6EH, 00H       ; 0124 _ pansion.
        db 6DH, 6DH, 61H, 63H, 72H, 6FH, 73H, 00H       ; 012C _ mmacros.
        db 00H, 00H, 00H, 00H, 6DH, 75H, 6CH, 74H       ; 0134 _ ....mult
        db 69H, 2DH, 6CH, 69H, 6EH, 65H, 20H, 6DH       ; 013C _ i-line m
        db 61H, 63H, 72H, 6FH, 73H, 20H, 62H, 65H       ; 0144 _ acros be
        db 66H, 6FH, 72H, 65H, 20H, 66H, 69H, 6EH       ; 014C _ fore fin
        db 61H, 6CH, 20H, 72H, 65H, 74H, 75H, 72H       ; 0154 _ al retur
        db 6EH, 00H, 72H, 65H, 70H, 00H, 25H, 72H       ; 015C _ n.rep.%r
        db 65H, 70H, 20H, 63H, 6FH, 75H, 6EH, 74H       ; 0164 _ ep count
        db 00H, 65H, 76H, 61H, 6CH, 00H, 65H, 78H       ; 016C _ .eval.ex
        db 70H, 72H, 65H, 73H, 73H, 69H, 6FH, 6EH       ; 0174 _ pression
        db 20H, 65H, 76H, 61H, 6CH, 75H, 61H, 74H       ; 017C _  evaluat
        db 69H, 6FH, 6EH, 20H, 64H, 65H, 73H, 63H       ; 0184 _ ion desc
        db 65H, 6EH, 74H, 00H, 6CH, 69H, 6EH, 65H       ; 018C _ ent.line
        db 73H, 00H, 74H, 6FH, 74H, 61H, 6CH, 20H       ; 0194 _ s.total 
        db 73H, 6FH, 75H, 72H, 63H, 65H, 20H, 6CH       ; 019C _ source l
        db 69H, 6EH, 65H, 73H, 20H, 70H, 72H, 6FH       ; 01A4 _ ines pro
        db 63H, 65H, 73H, 73H, 65H, 64H, 00H, 70H       ; 01AC _ cessed.p
        db 61H, 72H, 61H, 6DH, 73H, 00H, 00H, 00H       ; 01B4 _ arams...
        db 00H, 00H, 00H, 00H, 6DH, 75H, 6CH, 74H       ; 01BC _ ....mult
        db 69H, 2DH, 6CH, 69H, 6EH, 65H, 20H, 6DH       ; 01C4 _ i-line m
        db 61H, 63H, 72H, 6FH, 20H, 70H, 61H, 72H       ; 01CC _ acro par
        db 61H, 6DH, 65H, 74H, 65H, 72H, 20H, 63H       ; 01D4 _ ameter c
        db 6FH, 75H, 6EH, 74H, 00H                      ; 01DC _ ount.

?_510:                                                  ; byte
        db 25H, 6CH, 64H, 00H                           ; 01E1 _ %ld.

?_511:                                                  ; byte
        db 75H, 6EH, 6CH, 69H, 6DH, 69H, 74H, 65H       ; 01E5 _ unlimite
        db 64H, 00H                                     ; 01ED _ d.

?_512:                                                  ; byte
        db 00H                                          ; 01EF _ .

?_513:                                                  ; byte
        db 75H, 6EH, 6BH, 6EH, 6FH, 77H, 6EH, 20H       ; 01F0 _ unknown 
        db 6CH, 69H, 6DH, 69H, 74H, 3AH, 20H, 60H       ; 01F8 _ limit: `
        db 25H, 73H, 27H, 00H                           ; 0200 _ %s'.

?_514:                                                  ; byte
        db 2AH, 00H                                     ; 0204 _ *.

?_515:                                                  ; byte
        db 72H, 65H, 73H, 65H, 74H, 00H                 ; 0206 _ reset.

?_516:                                                  ; byte
        db 64H, 65H, 66H, 61H, 75H, 6CH, 74H, 00H       ; 020C _ default.

?_517:                                                  ; byte
        db 6DH, 61H, 78H, 69H, 6DH, 75H, 6DH, 00H       ; 0214 _ maximum.

?_518:                                                  ; byte
        db 6DH, 61H, 78H, 00H                           ; 021C _ max.

?_519:                                                  ; byte
        db 69H, 6EH, 76H, 61H, 6CH, 69H, 64H, 20H       ; 0220 _ invalid 
        db 6CH, 69H, 6DH, 69H, 74H, 20H, 76H, 61H       ; 0228 _ limit va
        db 6CH, 75H, 65H, 3AH, 20H, 60H, 25H, 73H       ; 0230 _ lue: `%s
        db 20H, 25H, 73H, 27H, 00H, 00H, 00H, 00H       ; 0238 _  %s'....

?_520:                                                  ; byte
        db 65H, 78H, 63H, 65H, 73H, 73H, 69H, 76H       ; 0240 _ excessiv
        db 65H, 20H, 6CH, 69H, 6DH, 69H, 74H, 20H       ; 0248 _ e limit 
        db 76H, 61H, 6CH, 75H, 65H, 20H, 60H, 25H       ; 0250 _ value `%
        db 73H, 20H, 25H, 73H, 27H, 20H, 63H, 61H       ; 0258 _ s %s' ca
        db 70H, 70H, 65H, 64H, 20H, 74H, 6FH, 20H       ; 0260 _ pped to 
        db 25H, 6CH, 64H, 00H                           ; 0268 _ %ld.

?_521:                                                  ; byte
        db 5FH, 5FH, 3FH, 44H, 41H, 54H, 45H, 3FH       ; 026C _ __?DATE?
        db 5FH, 5FH, 3DH, 22H, 25H, 59H, 2DH, 25H       ; 0274 _ __="%Y-%
        db 6DH, 2DH, 25H, 64H, 22H, 00H                 ; 027C _ m-%d".

?_522:                                                  ; byte
        db 5FH, 5FH, 3FH, 44H, 41H, 54H, 45H, 5FH       ; 0282 _ __?DATE_
        db 4EH, 55H, 4DH, 3FH, 5FH, 5FH, 3DH, 25H       ; 028A _ NUM?__=%
        db 59H, 25H, 6DH, 25H, 64H, 00H                 ; 0292 _ Y%m%d.

?_523:                                                  ; byte
        db 5FH, 5FH, 3FH, 54H, 49H, 4DH, 45H, 3FH       ; 0298 _ __?TIME?
        db 5FH, 5FH, 3DH, 22H, 25H, 48H, 3AH, 25H       ; 02A0 _ __="%H:%
        db 4DH, 3AH, 25H, 53H, 22H, 00H                 ; 02A8 _ M:%S".

?_524:                                                  ; byte
        db 5FH, 5FH, 3FH, 54H, 49H, 4DH, 45H, 5FH       ; 02AE _ __?TIME_
        db 4EH, 55H, 4DH, 3FH, 5FH, 5FH, 3DH, 25H       ; 02B6 _ NUM?__=%
        db 48H, 25H, 4DH, 25H, 53H, 00H                 ; 02BE _ H%M%S.

?_525:                                                  ; byte
        db 5FH, 5FH, 3FH, 55H, 54H, 43H, 5FH, 44H       ; 02C4 _ __?UTC_D
        db 41H, 54H, 45H, 3FH, 5FH, 5FH, 3DH, 22H       ; 02CC _ ATE?__="
        db 25H, 59H, 2DH, 25H, 6DH, 2DH, 25H, 64H       ; 02D4 _ %Y-%m-%d
        db 22H, 00H                                     ; 02DC _ ".

?_526:                                                  ; byte
        db 5FH, 5FH, 3FH, 55H, 54H, 43H, 5FH, 44H       ; 02DE _ __?UTC_D
        db 41H, 54H, 45H, 5FH, 4EH, 55H, 4DH, 3FH       ; 02E6 _ ATE_NUM?
        db 5FH, 5FH, 3DH, 25H, 59H, 25H, 6DH, 25H       ; 02EE _ __=%Y%m%
        db 64H, 00H                                     ; 02F6 _ d.

?_527:                                                  ; byte
        db 5FH, 5FH, 3FH, 55H, 54H, 43H, 5FH, 54H       ; 02F8 _ __?UTC_T
        db 49H, 4DH, 45H, 3FH, 5FH, 5FH, 3DH, 22H       ; 0300 _ IME?__="
        db 25H, 48H, 3AH, 25H, 4DH, 3AH, 25H, 53H       ; 0308 _ %H:%M:%S
        db 22H, 00H                                     ; 0310 _ ".

?_528:                                                  ; byte
        db 5FH, 5FH, 3FH, 55H, 54H, 43H, 5FH, 54H       ; 0312 _ __?UTC_T
        db 49H, 4DH, 45H, 5FH, 4EH, 55H, 4DH, 3FH       ; 031A _ IME_NUM?
        db 5FH, 5FH, 3DH, 25H, 48H, 25H, 4DH, 25H       ; 0322 _ __=%H%M%
        db 53H, 00H                                     ; 032A _ S.

?_529:                                                  ; byte
        db 5FH, 5FH, 3FH, 50H, 4FH, 53H, 49H, 58H       ; 032C _ __?POSIX
        db 5FH, 54H, 49H, 4DH, 45H, 3FH, 5FH, 5FH       ; 0334 _ _TIME?__
        db 3DH, 25H, 6CH, 64H, 00H                      ; 033C _ =%ld.

?_530:                                                  ; byte
        db 5FH, 5FH, 3FH, 4FH, 55H, 54H, 50H, 55H       ; 0341 _ __?OUTPU
        db 54H, 5FH, 46H, 4FH, 52H, 4DH, 41H, 54H       ; 0349 _ T_FORMAT
        db 3FH, 5FH, 5FH, 3DH, 25H, 73H, 00H            ; 0351 _ ?__=%s.

?_531:                                                  ; byte
        db 5FH, 5FH, 3FH, 44H, 45H, 42H, 55H, 47H       ; 0358 _ __?DEBUG
        db 5FH, 46H, 4FH, 52H, 4DH, 41H, 54H, 3FH       ; 0360 _ _FORMAT?
        db 5FH, 5FH, 3DH, 25H, 73H, 00H                 ; 0368 _ __=%s.

?_532:                                                  ; byte
        db 20H, 26H, 0AH, 20H, 00H                      ; 036E _  &. .

?_533:                                                  ; byte
        db 20H, 5CH, 0AH, 20H, 00H                      ; 0373 _  \. .

?_534:                                                  ; byte
        db 09H, 25H, 6EH, 75H, 6CH, 6CH, 0AH, 00H       ; 0378 _ .%null..

?_535:                                                  ; byte
        db 2DH, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0380 _ -.......

?_536:                                                  ; byte
        db 75H, 6EH, 61H, 62H, 6CH, 65H, 20H, 74H       ; 0388 _ unable t
        db 6FH, 20H, 77H, 72H, 69H, 74H, 65H, 20H       ; 0390 _ o write 
        db 64H, 65H, 70H, 65H, 6EH, 64H, 65H, 6EH       ; 0398 _ dependen
        db 63H, 79H, 20H, 66H, 69H, 6CH, 65H, 20H       ; 03A0 _ cy file 
        db 60H, 25H, 73H, 27H, 00H                      ; 03A8 _ `%s'.

?_537:                                                  ; byte
        db 25H, 73H, 20H, 3AH, 00H                      ; 03AD _ %s :.

?_538:                                                  ; byte
        db 20H, 25H, 73H, 00H                           ; 03B2 _  %s.

?_539:                                                  ; byte
        db 0AH, 0AH, 00H                                ; 03B6 _ ...

?_540:                                                  ; byte
        db 25H, 73H, 20H, 3AH, 0AH, 25H, 73H, 0AH       ; 03B9 _ %s :.%s.
        db 00H                                          ; 03C1 _ .

?_541:                                                  ; byte
        db 22H, 22H, 00H                                ; 03C2 _ "".

?_542:                                                  ; byte
        db 6EH, 61H, 73H, 6DH, 2EH, 6FH, 75H, 74H       ; 03C5 _ nasm.out
        db 00H, 00H, 00H                                ; 03CD _ ...

?_543:                                                  ; byte
        db 64H, 65H, 66H, 61H, 75H, 6CH, 74H, 20H       ; 03D0 _ default 
        db 6FH, 75H, 74H, 70H, 75H, 74H, 20H, 66H       ; 03D8 _ output f
        db 69H, 6CH, 65H, 20H, 73H, 61H, 6DH, 65H       ; 03E0 _ ile same
        db 20H, 61H, 73H, 20H, 69H, 6EH, 70H, 75H       ; 03E8 _  as inpu
        db 74H, 2CH, 20H, 75H, 73H, 69H, 6EH, 67H       ; 03F0 _ t, using
        db 20H, 60H, 25H, 73H, 27H, 20H, 66H, 6FH       ; 03F8 _  `%s' fo
        db 72H, 20H, 6FH, 75H, 74H, 70H, 75H, 74H       ; 0400 _ r output
        db 0AH, 00H                                     ; 0408 _ ..

?_544:                                                  ; byte
        db 2EH, 64H, 00H                                ; 040A _ .d.

?_545:                                                  ; byte
        db 6EH, 61H, 73H, 6DH, 2EH, 64H, 00H            ; 040D _ nasm.d.

?_546:                                                  ; byte
        db 6EH, 61H, 73H, 6DH, 00H, 00H, 00H, 00H       ; 0414 _ nasm....
        db 00H, 00H, 00H, 00H                           ; 041C _ ....

?_547:                                                  ; byte
        db 75H, 6EH, 72H, 65H, 63H, 6FH, 67H, 6EH       ; 0420 _ unrecogn
        db 69H, 7AH, 65H, 64H, 20H, 64H, 65H, 62H       ; 0428 _ ized deb
        db 75H, 67H, 20H, 66H, 6FH, 72H, 6DH, 61H       ; 0430 _ ug forma
        db 74H, 20H, 60H, 25H, 73H, 27H, 20H, 66H       ; 0438 _ t `%s' f
        db 6FH, 72H, 20H, 6FH, 75H, 74H, 70H, 75H       ; 0440 _ or outpu
        db 74H, 20H, 66H, 6FH, 72H, 6DH, 61H, 74H       ; 0448 _ t format
        db 20H, 60H, 25H, 73H, 27H, 00H, 00H, 00H       ; 0450 _  `%s'...

?_548:                                                  ; byte
        db 75H, 6EH, 61H, 62H, 6CH, 65H, 20H, 74H       ; 0458 _ unable t
        db 6FH, 20H, 6FH, 70H, 65H, 6EH, 20H, 6FH       ; 0460 _ o open o
        db 75H, 74H, 70H, 75H, 74H, 20H, 66H, 69H       ; 0468 _ utput fi
        db 6CH, 65H, 20H, 60H, 25H, 73H, 27H, 00H       ; 0470 _ le `%s'.

?_549:                                                  ; byte
        db 25H, 25H, 6CH, 69H, 6EH, 65H, 20H, 25H       ; 0478 _ %%line %
        db 64H, 25H, 2BH, 64H, 20H, 25H, 73H, 0AH       ; 0480 _ d%+d %s.
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0488 _ ........

?_550:                                                  ; byte
        db 77H, 72H, 69H, 74H, 65H, 20H, 65H, 72H       ; 0490 _ write er
        db 72H, 6FH, 72H, 20H, 6FH, 6EH, 20H, 6FH       ; 0498 _ ror on o
        db 75H, 74H, 70H, 75H, 74H, 20H, 66H, 69H       ; 04A0 _ utput fi
        db 6CH, 65H, 20H, 60H, 25H, 73H, 27H, 00H       ; 04A8 _ le `%s'.

?_551:                                                  ; byte
        db 6FH, 70H, 74H, 69H, 6FH, 6EH, 20H, 60H       ; 04B0 _ option `
        db 2DH, 25H, 63H, 27H, 20H, 72H, 65H, 71H       ; 04B8 _ -%c' req
        db 75H, 69H, 72H, 65H, 73H, 20H, 61H, 6EH       ; 04C0 _ uires an
        db 20H, 61H, 72H, 67H, 75H, 6DH, 65H, 6EH       ; 04C8 _  argumen
        db 74H, 00H, 76H, 00H, 76H, 65H, 72H, 73H       ; 04D0 _ t.v.vers
        db 69H, 6FH, 6EH, 00H                           ; 04D8 _ ion.

?_552:                                                  ; byte
        db 68H, 65H, 6CH, 70H, 00H, 61H, 62H, 6FH       ; 04DC _ help.abo
        db 72H, 74H, 2DH, 6FH, 6EH, 2DH, 70H, 61H       ; 04E4 _ rt-on-pa
        db 6EH, 69H, 63H, 00H, 70H, 72H, 65H, 66H       ; 04EC _ nic.pref
        db 69H, 78H, 00H, 70H, 6FH, 73H, 74H, 66H       ; 04F4 _ ix.postf
        db 69H, 78H, 00H, 73H, 75H, 66H, 66H, 69H       ; 04FC _ ix.suffi
        db 78H, 00H, 67H, 70H, 72H, 65H, 66H, 69H       ; 0504 _ x.gprefi
        db 78H, 00H, 67H, 70H, 6FH, 73H, 74H, 66H       ; 050C _ x.gpostf
        db 69H, 78H, 00H, 67H, 73H, 75H, 66H, 66H       ; 0514 _ ix.gsuff
        db 69H, 78H, 00H, 6CH, 70H, 72H, 65H, 66H       ; 051C _ ix.lpref
        db 69H, 78H, 00H, 6CH, 70H, 6FH, 73H, 74H       ; 0524 _ ix.lpost
        db 66H, 69H, 78H, 00H, 6CH, 73H, 75H, 66H       ; 052C _ fix.lsuf
        db 66H, 69H, 78H, 00H, 69H, 6EH, 63H, 6CH       ; 0534 _ fix.incl
        db 75H, 64H, 65H, 00H, 70H, 72H, 61H, 67H       ; 053C _ ude.prag
        db 6DH, 61H, 00H, 62H, 65H, 66H, 6FH, 72H       ; 0544 _ ma.befor
        db 65H, 00H, 6CH, 69H, 6DH, 69H, 74H, 2DH       ; 054C _ e.limit-
        db 00H, 6BH, 65H, 65H, 70H, 2DH, 61H, 6CH       ; 0554 _ .keep-al
        db 6CH, 00H, 6EH, 6FH, 2DH, 6CH, 69H, 6EH       ; 055C _ l.no-lin
        db 65H, 00H, 69H, 6EH, 66H, 6FH, 00H, 76H       ; 0564 _ e.info.v
        db 65H, 72H, 62H, 6FH, 73H, 65H, 00H, 64H       ; 056C _ erbose.d
        db 65H, 62H, 75H, 67H, 00H, 72H, 65H, 70H       ; 0574 _ ebug.rep
        db 72H, 6FH, 64H, 75H, 63H, 69H, 62H, 6CH       ; 057C _ roducibl
        db 65H, 00H, 62H, 69H, 74H, 73H, 00H, 64H       ; 0584 _ e.bits.d
        db 65H, 62H, 75H, 67H, 2DH, 70H, 72H, 65H       ; 058C _ ebug-pre
        db 66H, 69H, 78H, 2DH, 6DH, 61H, 70H, 00H       ; 0594 _ fix-map.
        db 00H, 00H, 00H, 00H                           ; 059C _ ....

?_553:                                                  ; byte
        db 4EH, 41H, 53H, 4DH, 20H, 76H, 65H, 72H       ; 05A0 _ NASM ver
        db 73H, 69H, 6FH, 6EH, 20H, 25H, 73H, 20H       ; 05A8 _ sion %s 
        db 63H, 6FH, 6DH, 70H, 69H, 6CH, 65H, 64H       ; 05B0 _ compiled
        db 20H, 6FH, 6EH, 20H, 25H, 73H, 25H, 73H       ; 05B8 _  on %s%s
        db 0AH, 00H                                     ; 05C0 _ ..

?_554:                                                  ; byte
        db 6FH, 4FH, 66H, 70H, 50H, 64H, 44H, 69H       ; 05C2 _ oOfpPdDi
        db 49H, 6CH, 4CH, 46H, 58H, 75H, 55H, 5AH       ; 05CA _ IlLFXuUZ
        db 77H, 57H, 40H, 00H, 00H, 00H                 ; 05D2 _ wW@...

?_555:                                                  ; byte
        db 75H, 6EH, 72H, 65H, 63H, 6FH, 67H, 6EH       ; 05D8 _ unrecogn
        db 69H, 73H, 65H, 64H, 20H, 6FH, 75H, 74H       ; 05E0 _ ised out
        db 70H, 75H, 74H, 20H, 66H, 6FH, 72H, 6DH       ; 05E8 _ put form
        db 61H, 74H, 20H, 60H, 25H, 73H, 27H, 20H       ; 05F0 _ at `%s' 
        db 2DH, 20H, 75H, 73H, 65H, 20H, 2DH, 68H       ; 05F8 _ - use -h
        db 66H, 20H, 66H, 6FH, 72H, 20H, 61H, 20H       ; 0600 _ f for a 
        db 6CH, 69H, 73H, 74H, 00H, 00H, 00H, 00H       ; 0608 _ list....

?_556:                                                  ; byte
        db 75H, 6EH, 6BH, 6EH, 6FH, 77H, 6EH, 20H       ; 0610 _ unknown 
        db 6FH, 70H, 74H, 69H, 6DH, 69H, 7AH, 61H       ; 0618 _ optimiza
        db 74H, 69H, 6FH, 6EH, 20H, 6FH, 70H, 74H       ; 0620 _ tion opt
        db 69H, 6FH, 6EH, 20H, 2DH, 4FH, 25H, 63H       ; 0628 _ ion -O%c
        db 0AH, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0630 _ ........

?_557:                                                  ; byte
        db 75H, 6EH, 72H, 65H, 63H, 6FH, 67H, 6EH       ; 0638 _ unrecogn
        db 69H, 7AH, 65H, 64H, 20H, 65H, 72H, 72H       ; 0640 _ ized err
        db 6FH, 72H, 20H, 72H, 65H, 70H, 6FH, 72H       ; 0648 _ or repor
        db 74H, 69H, 6EH, 67H, 20H, 66H, 6FH, 72H       ; 0650 _ ting for
        db 6DH, 61H, 74H, 20H, 60H, 25H, 73H, 27H       ; 0658 _ mat `%s'
        db 00H                                          ; 0660 _ .

?_558:                                                  ; byte
        db 2DH, 46H, 00H, 00H, 00H, 00H, 00H            ; 0661 _ -F.....

?_559:                                                  ; byte
        db 75H, 6EH, 6BH, 6EH, 6FH, 77H, 6EH, 20H       ; 0668 _ unknown 
        db 64H, 65H, 70H, 65H, 6EH, 64H, 65H, 6EH       ; 0670 _ dependen
        db 63H, 79H, 20H, 6FH, 70H, 74H, 69H, 6FH       ; 0678 _ cy optio
        db 6EH, 20H, 60H, 2DH, 4DH, 25H, 63H, 27H       ; 0680 _ n `-M%c'
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0688 _ ........

?_560:                                                  ; byte
        db 6FH, 70H, 74H, 69H, 6FH, 6EH, 20H, 60H       ; 0690 _ option `
        db 2DH, 4DH, 25H, 63H, 27H, 20H, 72H, 65H       ; 0698 _ -M%c' re
        db 71H, 75H, 69H, 72H, 65H, 73H, 20H, 61H       ; 06A0 _ quires a
        db 20H, 70H, 61H, 72H, 61H, 6DH, 65H, 74H       ; 06A8 _  paramet
        db 65H, 72H, 00H                                ; 06B0 _ er.

?_561:                                                  ; byte
        db 75H, 6EH, 72H, 65H, 63H, 6FH, 67H, 6EH       ; 06B3 _ unrecogn
        db 69H, 7AH, 65H, 64H, 20H, 6FH, 70H, 74H       ; 06BB _ ized opt
        db 69H, 6FH, 6EH, 20H, 60H, 2DH, 2DH, 25H       ; 06C3 _ ion `--%
        db 73H, 27H, 00H, 00H, 00H                      ; 06CB _ s'...

?_562:                                                  ; byte
        db 6FH, 70H, 74H, 69H, 6FH, 6EH, 20H, 60H       ; 06D0 _ option `
        db 2DH, 2DH, 25H, 73H, 27H, 20H, 72H, 65H       ; 06D8 _ --%s' re
        db 71H, 75H, 69H, 72H, 65H, 73H, 20H, 61H       ; 06E0 _ quires a
        db 6EH, 20H, 61H, 72H, 67H, 75H, 6DH, 65H       ; 06E8 _ n argume
        db 6EH, 74H, 00H, 00H, 00H, 00H, 00H, 00H       ; 06F0 _ nt......

?_563:                                                  ; byte
        db 6FH, 70H, 74H, 69H, 6FH, 6EH, 20H, 60H       ; 06F8 _ option `
        db 2DH, 2DH, 25H, 73H, 27H, 20H, 64H, 6FH       ; 0700 _ --%s' do
        db 65H, 73H, 20H, 6EH, 6FH, 74H, 20H, 74H       ; 0708 _ es not t
        db 61H, 6BH, 65H, 20H, 61H, 6EH, 20H, 61H       ; 0710 _ ake an a
        db 72H, 67H, 75H, 6DH, 65H, 6EH, 74H, 00H       ; 0718 _ rgument.

?_564:                                                  ; byte
        db 25H, 70H, 72H, 61H, 67H, 6DH, 61H, 00H       ; 0720 _ %pragma.

?_565:                                                  ; byte
        db 42H, 49H, 54H, 53H, 00H, 00H, 00H, 00H       ; 0728 _ BITS....

?_566:                                                  ; byte
        db 6FH, 70H, 74H, 69H, 6FH, 6EH, 20H, 60H       ; 0730 _ option `
        db 2DH, 2DH, 25H, 73H, 27H, 20H, 6DH, 75H       ; 0738 _ --%s' mu
        db 73H, 74H, 20H, 62H, 65H, 20H, 6FH, 66H       ; 0740 _ st be of
        db 20H, 74H, 68H, 65H, 20H, 66H, 6FH, 72H       ; 0748 _  the for
        db 6DH, 20H, 60H, 42H, 41H, 53H, 45H, 3DH       ; 0750 _ m `BASE=
        db 44H, 45H, 53H, 54H, 27H, 00H                 ; 0758 _ DEST'.

?_567:                                                  ; byte
        db 2EH, 2FH, 61H, 73H, 6DH, 2FH, 6EH, 61H       ; 075E _ ./asm/na
        db 73H, 6DH, 2EH, 63H, 00H                      ; 0766 _ sm.c.

?_568:                                                  ; byte
        db 75H, 6EH, 72H, 65H, 63H, 6FH, 67H, 6EH       ; 076B _ unrecogn
        db 69H, 73H, 65H, 64H, 20H, 6FH, 70H, 74H       ; 0773 _ ised opt
        db 69H, 6FH, 6EH, 20H, 60H, 2DH, 25H, 63H       ; 077B _ ion `-%c
        db 27H, 00H                                     ; 0783 _ '.

?_569:                                                  ; byte
        db 0DH, 0AH, 1AH, 00H, 00H, 00H, 00H, 00H       ; 0785 _ ........
        db 00H, 00H, 00H                                ; 078D _ ...

?_570:                                                  ; byte
        db 75H, 6EH, 61H, 62H, 6CH, 65H, 20H, 74H       ; 0790 _ unable t
        db 6FH, 20H, 6FH, 70H, 65H, 6EH, 20H, 72H       ; 0798 _ o open r
        db 65H, 73H, 70H, 6FH, 6EH, 73H, 65H, 20H       ; 07A0 _ esponse 
        db 66H, 69H, 6CH, 65H, 20H, 60H, 25H, 73H       ; 07A8 _ file `%s
        db 27H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 07B0 _ '.......

?_571:                                                  ; byte
        db 63H, 61H, 6EH, 6EH, 6FH, 74H, 20H, 6FH       ; 07B8 _ cannot o
        db 70H, 65H, 6EH, 20H, 66H, 69H, 6CH, 65H       ; 07C0 _ pen file
        db 20H, 60H, 25H, 73H, 27H, 20H, 66H, 6FH       ; 07C8 _  `%s' fo
        db 72H, 20H, 65H, 72H, 72H, 6FH, 72H, 20H       ; 07D0 _ r error 
        db 6DH, 65H, 73H, 73H, 61H, 67H, 65H, 73H       ; 07D8 _ messages
        db 00H                                          ; 07E0 _ .

?_572:                                                  ; byte
        db 4EH, 41H, 53H, 4DH, 45H, 4EH, 56H, 00H       ; 07E1 _ NASMENV.

?_573:                                                  ; byte
        db 6EH, 6FH, 20H, 69H, 6EH, 70H, 75H, 74H       ; 07E9 _ no input
        db 20H, 66H, 69H, 6CH, 65H, 20H, 73H, 70H       ; 07F1 _  file sp
        db 65H, 63H, 69H, 66H, 69H, 65H, 64H, 00H       ; 07F9 _ ecified.

?_574:                                                  ; byte
        db 66H, 61H, 69H, 6CH, 65H, 64H, 00H            ; 0801 _ failed.

?_575:                                                  ; byte
        db 63H, 6FH, 6DH, 70H, 6CH, 65H, 74H, 65H       ; 0808 _ complete
        db 64H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0810 _ d.......

?_576:                                                  ; byte
        db 61H, 73H, 73H, 65H, 6DH, 62H, 6CH, 79H       ; 0818 _ assembly
        db 20H, 25H, 73H, 20H, 61H, 66H, 74H, 65H       ; 0820 _  %s afte
        db 72H, 20H, 31H, 2BH, 25H, 6CH, 64H, 2BH       ; 0828 _ r 1+%ld+
        db 25H, 75H, 20H, 70H, 61H, 73H, 73H, 65H       ; 0830 _ %u passe
        db 73H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0838 _ s.......

?_577:                                                  ; byte
        db 63H, 6FH, 6DH, 6DH, 61H, 6EH, 64H, 20H       ; 0840 _ command 
        db 6CH, 69H, 6EH, 65H, 3AH, 20H, 33H, 32H       ; 0848 _ line: 32
        db 2DH, 62H, 69H, 74H, 20H, 73H, 65H, 67H       ; 0850 _ -bit seg
        db 6DH, 65H, 6EH, 74H, 20H, 73H, 69H, 7AH       ; 0858 _ ment siz
        db 65H, 20H, 72H, 65H, 71H, 75H, 69H, 72H       ; 0860 _ e requir
        db 65H, 73H, 20H, 61H, 20H, 68H, 69H, 67H       ; 0868 _ es a hig
        db 68H, 65H, 72H, 20H, 63H, 70H, 75H, 00H       ; 0870 _ her cpu.

?_578:                                                  ; byte
        db 63H, 6FH, 6DH, 6DH, 61H, 6EH, 64H, 20H       ; 0878 _ command 
        db 6CH, 69H, 6EH, 65H, 3AH, 20H, 36H, 34H       ; 0880 _ line: 64
        db 2DH, 62H, 69H, 74H, 20H, 73H, 65H, 67H       ; 0888 _ -bit seg
        db 6DH, 65H, 6EH, 74H, 20H, 73H, 69H, 7AH       ; 0890 _ ment siz
        db 65H, 20H, 72H, 65H, 71H, 75H, 69H, 72H       ; 0898 _ e requir
        db 65H, 73H, 20H, 61H, 20H, 68H, 69H, 67H       ; 08A0 _ es a hig
        db 68H, 65H, 72H, 20H, 63H, 70H, 75H, 00H       ; 08A8 _ her cpu.

?_579:                                                  ; byte
        db 6FH, 76H, 65H, 72H, 61H, 6CH, 6CH, 20H       ; 08B0 _ overall 
        db 6CH, 69H, 6EH, 65H, 20H, 63H, 6FH, 75H       ; 08B8 _ line cou
        db 6EH, 74H, 20H, 65H, 78H, 63H, 65H, 65H       ; 08C0 _ nt excee
        db 64H, 73H, 20H, 74H, 68H, 65H, 20H, 6DH       ; 08C8 _ ds the m
        db 61H, 78H, 69H, 6DH, 75H, 6DH, 20H, 25H       ; 08D0 _ aximum %
        db 6CH, 64H, 0AH, 00H, 00H, 00H, 00H, 00H       ; 08D8 _ ld......

?_580:                                                  ; byte
        db 75H, 6EH, 61H, 62H, 6CH, 65H, 20H, 74H       ; 08E0 _ unable t
        db 6FH, 20H, 66H, 69H, 6EH, 64H, 20H, 76H       ; 08E8 _ o find v
        db 61H, 6CH, 69H, 64H, 20H, 76H, 61H, 6CH       ; 08F0 _ alid val
        db 75H, 65H, 73H, 20H, 66H, 6FH, 72H, 20H       ; 08F8 _ ues for 
        db 61H, 6CH, 6CH, 20H, 6CH, 61H, 62H, 65H       ; 0900 _ all labe
        db 6CH, 73H, 20H, 61H, 66H, 74H, 65H, 72H       ; 0908 _ ls after
        db 20H, 25H, 6CH, 64H, 20H, 70H, 61H, 73H       ; 0910 _  %ld pas
        db 73H, 65H, 73H, 3BH, 20H, 73H, 74H, 61H       ; 0918 _ ses; sta
        db 6CH, 6CH, 65H, 64H, 20H, 66H, 6FH, 72H       ; 0920 _ lled for
        db 20H, 25H, 6CH, 64H, 2CH, 20H, 67H, 69H       ; 0928 _  %ld, gi
        db 76H, 69H, 6EH, 67H, 20H, 75H, 70H, 2EH       ; 0930 _ ving up.
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0938 _ ........

?_581:                                                  ; byte
        db 50H, 6FH, 73H, 73H, 69H, 62H, 6CH, 65H       ; 0940 _ Possible
        db 20H, 63H, 61H, 75H, 73H, 65H, 73H, 3AH       ; 0948 _  causes:
        db 20H, 72H, 65H, 63H, 75H, 72H, 73H, 69H       ; 0950 _  recursi
        db 76H, 65H, 20H, 45H, 51H, 55H, 73H, 2CH       ; 0958 _ ve EQUs,
        db 20H, 6DH, 61H, 63H, 72H, 6FH, 20H, 61H       ; 0960 _  macro a
        db 62H, 75H, 73H, 65H, 2EH, 00H, 00H, 00H       ; 0968 _ buse....

?_582:                                                  ; byte
        db 70H, 68H, 61H, 73H, 65H, 20H, 65H, 72H       ; 0970 _ phase er
        db 72H, 6FH, 72H, 20H, 64H, 75H, 72H, 69H       ; 0978 _ ror duri
        db 6EH, 67H, 20H, 73H, 74H, 61H, 62H, 69H       ; 0980 _ ng stabi
        db 6CH, 69H, 7AH, 61H, 74H, 69H, 6FH, 6EH       ; 0988 _ lization
        db 20H, 70H, 61H, 73H, 73H, 2CH, 20H, 68H       ; 0990 _  pass, h
        db 6FH, 70H, 69H, 6EH, 67H, 20H, 66H, 6FH       ; 0998 _ oping fo
        db 72H, 20H, 74H, 68H, 65H, 20H, 62H, 65H       ; 09A0 _ r the be
        db 73H, 74H, 00H, 00H, 00H, 00H, 00H, 00H       ; 09A8 _ st......

?_583:                                                  ; byte
        db 70H, 68H, 61H, 73H, 65H, 20H, 65H, 72H       ; 09B0 _ phase er
        db 72H, 6FH, 72H, 20H, 64H, 75H, 72H, 69H       ; 09B8 _ ror duri
        db 6EH, 67H, 20H, 63H, 6FH, 64H, 65H, 20H       ; 09C0 _ ng code 
        db 67H, 65H, 6EH, 65H, 72H, 61H, 74H, 69H       ; 09C8 _ generati
        db 6FH, 6EH, 20H, 70H, 61H, 73H, 73H, 00H       ; 09D0 _ on pass.

?_584:                                                  ; byte
        db 2DH, 2DH, 00H                                ; 09D8 _ --.

?_585:                                                  ; byte
        db 6FH, 70H, 74H, 00H                           ; 09DB _ opt.

?_586:                                                  ; byte
        db 72H, 75H, 6EH, 00H                           ; 09DF _ run.

?_587:                                                  ; byte
        db 63H, 6DH, 64H, 00H                           ; 09E3 _ cmd.

?_588:                                                  ; byte
        db 61H, 6CH, 6CH, 00H                           ; 09E7 _ all.

?_589:                                                  ; byte
        db 2DH, 2DH, 6CH, 69H, 6DH, 69H, 74H, 00H       ; 09EB _ --limit.

?_590:                                                  ; byte
        db 6CH, 69H, 6DH, 69H, 74H, 00H                 ; 09F3 _ limit.

?_591:                                                  ; byte
        db 2DH, 2DH, 68H, 65H, 6CH, 70H, 00H            ; 09F9 _ --help.

?_592:                                                  ; byte
        db 6CH, 69H, 73H, 74H, 00H                      ; 0A00 _ list.

?_593:                                                  ; byte
        db 74H, 6FH, 70H, 69H, 63H, 73H, 00H            ; 0A05 _ topics.

?_594:                                                  ; byte
        db 69H, 6EH, 64H, 65H, 78H, 00H, 00H, 00H       ; 0A0C _ index...
        db 00H, 00H, 00H, 00H                           ; 0A14 _ ....

?_595:                                                  ; byte
        db 53H, 6FH, 72H, 72H, 79H, 2CH, 20H, 6EH       ; 0A18 _ Sorry, n
        db 6FH, 20H, 68H, 65H, 6CH, 70H, 20H, 61H       ; 0A20 _ o help a
        db 76H, 61H, 69H, 6CH, 61H, 62H, 6CH, 65H       ; 0A28 _ vailable
        db 20H, 66H, 6FH, 72H, 20H, 60H, 25H, 73H       ; 0A30 _  for `%s
        db 27H, 0AH, 00H, 00H, 00H, 00H, 00H, 00H       ; 0A38 _ '.......

?_596:                                                  ; byte
        db 55H, 73H, 61H, 67H, 65H, 3AH, 20H, 25H       ; 0A40 _ Usage: %
        db 73H, 20H, 5BH, 2DH, 40H, 20H, 72H, 65H       ; 0A48 _ s [-@ re
        db 73H, 70H, 6FH, 6EH, 73H, 65H, 5FH, 66H       ; 0A50 _ sponse_f
        db 69H, 6CH, 65H, 5DH, 20H, 5BH, 6FH, 70H       ; 0A58 _ ile] [op
        db 74H, 69H, 6FH, 6EH, 73H, 2EH, 2EH, 2EH       ; 0A60 _ tions...
        db 5DH, 20H, 5BH, 2DH, 2DH, 5DH, 20H, 66H       ; 0A68 _ ] [--] f
        db 69H, 6CH, 65H, 6EH, 61H, 6DH, 65H, 0AH       ; 0A70 _ ilename.
        db 20H, 20H, 4FH, 70H, 74H, 69H, 6FH, 6EH       ; 0A78 _   Option
        db 73H, 3AH, 0AH, 20H, 20H, 20H, 20H, 2DH       ; 0A80 _ s:.    -
        db 76H, 20H, 28H, 6FH, 72H, 20H, 2DH, 2DH       ; 0A88 _ v (or --
        db 76H, 29H, 20H, 20H, 20H, 20H, 70H, 72H       ; 0A90 _ v)    pr
        db 69H, 6EH, 74H, 20H, 74H, 68H, 65H, 20H       ; 0A98 _ int the 
        db 4EH, 41H, 53H, 4DH, 20H, 76H, 65H, 72H       ; 0AA0 _ NASM ver
        db 73H, 69H, 6FH, 6EH, 20H, 6EH, 75H, 6DH       ; 0AA8 _ sion num
        db 62H, 65H, 72H, 20H, 61H, 6EH, 64H, 20H       ; 0AB0 _ ber and 
        db 65H, 78H, 69H, 74H, 0AH, 20H, 20H, 20H       ; 0AB8 _ exit.   
        db 20H, 2DH, 40H, 20H, 66H, 69H, 6CH, 65H       ; 0AC0 _  -@ file
        db 20H, 20H, 20H, 20H, 20H, 20H, 20H, 20H       ; 0AC8 _         
        db 72H, 65H, 73H, 70H, 6FH, 6EH, 73H, 65H       ; 0AD0 _ response
        db 20H, 66H, 69H, 6CH, 65H, 3BH, 20H, 6FH       ; 0AD8 _  file; o
        db 6EH, 65H, 20H, 63H, 6FH, 6DH, 6DH, 61H       ; 0AE0 _ ne comma
        db 6EH, 64H, 20H, 6CH, 69H, 6EH, 65H, 20H       ; 0AE8 _ nd line 
        db 6FH, 70H, 74H, 69H, 6FH, 6EH, 20H, 70H       ; 0AF0 _ option p
        db 65H, 72H, 20H, 6CH, 69H, 6EH, 65H, 0AH       ; 0AF8 _ er line.
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0B00 _ ........

?_597:                                                  ; byte
        db 20H, 20H, 20H, 20H, 2DH, 68H, 20H, 20H       ; 0B08 _     -h  
        db 20H, 20H, 20H, 20H, 20H, 20H, 20H, 20H       ; 0B10 _         
        db 20H, 20H, 20H, 6CH, 69H, 73H, 74H, 20H       ; 0B18 _    list 
        db 63H, 6FH, 6DH, 6DH, 61H, 6EH, 64H, 20H       ; 0B20 _ command 
        db 6CH, 69H, 6EH, 65H, 20H, 6FH, 70H, 74H       ; 0B28 _ line opt
        db 69H, 6FH, 6EH, 73H, 20H, 61H, 6EH, 64H       ; 0B30 _ ions and
        db 20H, 65H, 78H, 69H, 74H, 20H, 28H, 61H       ; 0B38 _  exit (a
        db 6CH, 73H, 6FH, 20H, 2DH, 2DH, 68H, 65H       ; 0B40 _ lso --he
        db 6CH, 70H, 29H, 0AH, 00H, 00H, 00H, 00H       ; 0B48 _ lp).....

?_598:                                                  ; byte
        db 20H, 20H, 20H, 20H, 2DH, 68H, 20H, 2DH       ; 0B50 _     -h -
        db 6FH, 70H, 74H, 20H, 20H, 20H, 20H, 20H       ; 0B58 _ opt     
        db 20H, 20H, 20H, 73H, 68H, 6FH, 77H, 20H       ; 0B60 _    show 
        db 61H, 64H, 64H, 69H, 74H, 69H, 6FH, 6EH       ; 0B68 _ addition
        db 61H, 6CH, 20H, 68H, 65H, 6CH, 70H, 20H       ; 0B70 _ al help 
        db 66H, 6FH, 72H, 20H, 6FH, 70H, 74H, 69H       ; 0B78 _ for opti
        db 6FH, 6EH, 20H, 22H, 2DH, 6FH, 70H, 74H       ; 0B80 _ on "-opt
        db 22H, 0AH, 00H, 00H, 00H, 00H, 00H, 00H       ; 0B88 _ ".......

?_599:                                                  ; byte
        db 20H, 20H, 20H, 20H, 2DH, 68H, 20H, 61H       ; 0B90 _     -h a
        db 6CH, 6CH, 20H, 20H, 20H, 20H, 20H, 20H       ; 0B98 _ ll      
        db 20H, 20H, 20H, 73H, 68H, 6FH, 77H, 20H       ; 0BA0 _    show 
        db 61H, 6CH, 6CH, 20H, 61H, 76H, 61H, 69H       ; 0BA8 _ all avai
        db 6CH, 61H, 62H, 6CH, 65H, 20H, 63H, 6FH       ; 0BB0 _ lable co
        db 6DH, 6DH, 61H, 6EH, 64H, 20H, 6CH, 69H       ; 0BB8 _ mmand li
        db 6EH, 65H, 20H, 68H, 65H, 6CH, 70H, 0AH       ; 0BC0 _ ne help.
        db 20H, 20H, 20H, 20H, 2DH, 68H, 20H, 74H       ; 0BC8 _     -h t
        db 6FH, 70H, 69H, 63H, 73H, 20H, 20H, 20H       ; 0BD0 _ opics   
        db 20H, 20H, 20H, 73H, 68H, 6FH, 77H, 20H       ; 0BD8 _    show 
        db 6CH, 69H, 73H, 74H, 20H, 6FH, 66H, 20H       ; 0BE0 _ list of 
        db 68H, 65H, 6CH, 70H, 20H, 74H, 6FH, 70H       ; 0BE8 _ help top
        db 69H, 63H, 73H, 20H, 28H, 61H, 6CH, 73H       ; 0BF0 _ ics (als
        db 6FH, 20H, 2DH, 68H, 20H, 6CH, 69H, 73H       ; 0BF8 _ o -h lis
        db 74H, 29H, 0AH, 00H, 00H, 00H, 00H, 00H       ; 0C00 _ t)......

?_600:                                                  ; byte
        db 20H, 20H, 20H, 20H, 2DH, 68H, 20H, 2DH       ; 0C08 _     -h -
        db 58H, 20H, 20H, 20H, 20H, 20H, 20H, 20H       ; 0C10 _ X       
        db 20H, 20H, 20H, 73H, 68H, 6FH, 77H, 20H       ; 0C18 _    show 
        db 6CH, 69H, 73H, 74H, 20H, 6FH, 66H, 20H       ; 0C20 _ list of 
        db 65H, 72H, 72H, 6FH, 72H, 20H, 6DH, 65H       ; 0C28 _ error me
        db 73H, 73H, 61H, 67H, 65H, 20H, 66H, 6FH       ; 0C30 _ ssage fo
        db 72H, 6DH, 61H, 74H, 73H, 0AH, 20H, 20H       ; 0C38 _ rmats.  
        db 20H, 20H, 2DH, 68H, 20H, 2DH, 4DH, 20H       ; 0C40 _   -h -M 
        db 20H, 20H, 20H, 20H, 20H, 20H, 20H, 20H       ; 0C48 _         
        db 20H, 73H, 68H, 6FH, 77H, 20H, 6CH, 69H       ; 0C50 _  show li
        db 73H, 74H, 20H, 6FH, 66H, 20H, 64H, 65H       ; 0C58 _ st of de
        db 70H, 65H, 6EH, 64H, 65H, 6EH, 63H, 79H       ; 0C60 _ pendency
        db 20H, 67H, 65H, 6EH, 65H, 72H, 61H, 74H       ; 0C68 _  generat
        db 69H, 6FH, 6EH, 20H, 6FH, 70H, 74H, 69H       ; 0C70 _ ion opti
        db 6FH, 6EH, 73H, 0AH, 20H, 20H, 20H, 20H       ; 0C78 _ ons.    
        db 2DH, 68H, 20H, 2DH, 66H, 20H, 20H, 20H       ; 0C80 _ -h -f   
        db 20H, 20H, 20H, 20H, 20H, 20H, 20H, 73H       ; 0C88 _        s
        db 68H, 6FH, 77H, 20H, 6CH, 69H, 73H, 74H       ; 0C90 _ how list
        db 20H, 6FH, 66H, 20H, 6FH, 62H, 6AH, 65H       ; 0C98 _  of obje
        db 63H, 74H, 20H, 63H, 6FH, 64H, 65H, 20H       ; 0CA0 _ ct code 
        db 6FH, 75H, 74H, 70H, 75H, 74H, 20H, 66H       ; 0CA8 _ output f
        db 6FH, 72H, 6DH, 61H, 74H, 73H, 0AH, 20H       ; 0CB0 _ ormats. 
        db 20H, 20H, 20H, 2DH, 68H, 20H, 2DH, 46H       ; 0CB8 _    -h -F
        db 20H, 20H, 20H, 20H, 20H, 20H, 20H, 20H       ; 0CC0 _         
        db 20H, 20H, 73H, 68H, 6FH, 77H, 20H, 6CH       ; 0CC8 _   show l
        db 69H, 73H, 74H, 20H, 6FH, 66H, 20H, 64H       ; 0CD0 _ ist of d
        db 65H, 62H, 75H, 67H, 20H, 69H, 6EH, 66H       ; 0CD8 _ ebug inf
        db 6FH, 72H, 6DH, 61H, 74H, 69H, 6FH, 6EH       ; 0CE0 _ ormation
        db 20H, 66H, 6FH, 72H, 6DH, 61H, 74H, 73H       ; 0CE8 _  formats
        db 0AH, 20H, 20H, 20H, 20H, 2DH, 68H, 20H       ; 0CF0 _ .    -h 
        db 2DH, 4CH, 20H, 20H, 20H, 20H, 20H, 20H       ; 0CF8 _ -L      
        db 20H, 20H, 20H, 20H, 73H, 68H, 6FH, 77H       ; 0D00 _     show
        db 20H, 6CH, 69H, 73H, 74H, 20H, 6FH, 66H       ; 0D08 _  list of
        db 20H, 6CH, 69H, 73H, 74H, 20H, 66H, 69H       ; 0D10 _  list fi
        db 6CH, 65H, 20H, 6FH, 70H, 74H, 69H, 6FH       ; 0D18 _ le optio
        db 6EH, 20H, 66H, 6CH, 61H, 67H, 73H, 0AH       ; 0D20 _ n flags.
        db 20H, 20H, 20H, 20H, 2DH, 68H, 20H, 2DH       ; 0D28 _     -h -
        db 4FH, 20H, 20H, 20H, 20H, 20H, 20H, 20H       ; 0D30 _ O       
        db 20H, 20H, 20H, 73H, 68H, 6FH, 77H, 20H       ; 0D38 _    show 
        db 6CH, 69H, 73H, 74H, 20H, 6FH, 66H, 20H       ; 0D40 _ list of 
        db 6FH, 70H, 74H, 69H, 6DH, 69H, 7AH, 61H       ; 0D48 _ optimiza
        db 74H, 69H, 6FH, 6EH, 20H, 66H, 6CH, 61H       ; 0D50 _ tion fla
        db 67H, 73H, 0AH, 20H, 20H, 20H, 20H, 2DH       ; 0D58 _ gs.    -
        db 68H, 20H, 2DH, 77H, 20H, 20H, 20H, 20H       ; 0D60 _ h -w    
        db 20H, 20H, 20H, 20H, 20H, 20H, 73H, 68H       ; 0D68 _       sh
        db 6FH, 77H, 20H, 6CH, 69H, 73H, 74H, 20H       ; 0D70 _ ow list 
        db 6FH, 66H, 20H, 77H, 61H, 72H, 6EH, 69H       ; 0D78 _ of warni
        db 6EH, 67H, 20H, 63H, 6CH, 61H, 73H, 73H       ; 0D80 _ ng class
        db 65H, 73H, 20H, 61H, 6EH, 64H, 20H, 64H       ; 0D88 _ es and d
        db 65H, 66H, 61H, 75H, 6CH, 74H, 73H, 0AH       ; 0D90 _ efaults.
        db 20H, 20H, 20H, 20H, 2DH, 68H, 20H, 2DH       ; 0D98 _     -h -
        db 2DH, 6CH, 69H, 6DH, 69H, 74H, 20H, 20H       ; 0DA0 _ -limit  
        db 20H, 20H, 20H, 73H, 68H, 6FH, 77H, 20H       ; 0DA8 _    show 
        db 6CH, 69H, 73H, 74H, 20H, 6FH, 66H, 20H       ; 0DB0 _ list of 
        db 72H, 65H, 73H, 6FH, 75H, 72H, 63H, 65H       ; 0DB8 _ resource
        db 20H, 6CH, 69H, 6DH, 69H, 74H, 73H, 20H       ; 0DC0 _  limits 
        db 61H, 6EH, 64H, 20H, 64H, 65H, 66H, 61H       ; 0DC8 _ and defa
        db 75H, 6CH, 74H, 73H, 0AH, 00H, 00H, 00H       ; 0DD0 _ ults....

?_601:                                                  ; byte
        db 20H, 20H, 20H, 20H, 2DH, 6FH, 20H, 6FH       ; 0DD8 _     -o o
        db 75H, 74H, 66H, 69H, 6CH, 65H, 20H, 20H       ; 0DE0 _ utfile  
        db 20H, 20H, 20H, 77H, 72H, 69H, 74H, 65H       ; 0DE8 _    write
        db 20H, 6FH, 75H, 74H, 70H, 75H, 74H, 20H       ; 0DF0 _  output 
        db 74H, 6FH, 20H, 6FH, 75H, 74H, 66H, 69H       ; 0DF8 _ to outfi
        db 6CH, 65H, 0AH, 20H, 20H, 20H, 20H, 2DH       ; 0E00 _ le.    -
        db 2DH, 6BH, 65H, 65H, 70H, 2DH, 61H, 6CH       ; 0E08 _ -keep-al
        db 6CH, 20H, 20H, 20H, 20H, 20H, 6FH, 75H       ; 0E10 _ l     ou
        db 74H, 70H, 75H, 74H, 20H, 66H, 69H, 6CH       ; 0E18 _ tput fil
        db 65H, 73H, 20H, 77H, 69H, 6CH, 6CH, 20H       ; 0E20 _ es will 
        db 6EH, 6FH, 74H, 20H, 62H, 65H, 20H, 72H       ; 0E28 _ not be r
        db 65H, 6DH, 6FH, 76H, 65H, 64H, 20H, 65H       ; 0E30 _ emoved e
        db 76H, 65H, 6EH, 20H, 69H, 66H, 20H, 61H       ; 0E38 _ ven if a
        db 6EH, 20H, 65H, 72H, 72H, 6FH, 72H, 20H       ; 0E40 _ n error 
        db 68H, 61H, 70H, 70H, 65H, 6EH, 73H, 0AH       ; 0E48 _ happens.
        db 00H                                          ; 0E50 _ .

?_602:                                                  ; byte
        db 20H, 28H, 73H, 65H, 65H, 20H, 2DH, 68H       ; 0E51 _  (see -h
        db 20H, 2DH, 58H, 29H, 00H, 00H, 00H            ; 0E59 _  -X)...

?_603:                                                  ; byte
        db 20H, 20H, 20H, 20H, 2DH, 58H, 66H, 6FH       ; 0E60 _     -Xfo
        db 72H, 6DH, 61H, 74H, 20H, 20H, 20H, 20H       ; 0E68 _ rmat    
        db 20H, 20H, 20H, 73H, 70H, 65H, 63H, 69H       ; 0E70 _    speci
        db 66H, 79H, 20H, 65H, 72H, 72H, 6FH, 72H       ; 0E78 _ fy error
        db 20H, 72H, 65H, 70H, 6FH, 72H, 74H, 69H       ; 0E80 _  reporti
        db 6EH, 67H, 20H, 66H, 6FH, 72H, 6DH, 61H       ; 0E88 _ ng forma
        db 74H, 25H, 73H, 0AH, 00H, 00H, 00H, 00H       ; 0E90 _ t%s.....

?_604:                                                  ; byte
        db 20H, 20H, 20H, 20H, 2DH, 58H, 67H, 6EH       ; 0E98 _     -Xgn
        db 75H, 20H, 20H, 20H, 20H, 20H, 20H, 20H       ; 0EA0 _ u       
        db 20H, 20H, 20H, 72H, 65H, 70H, 6FH, 72H       ; 0EA8 _    repor
        db 74H, 20H, 65H, 72H, 72H, 6FH, 72H, 73H       ; 0EB0 _ t errors
        db 20H, 69H, 6EH, 20H, 47H, 4EH, 55H, 20H       ; 0EB8 _  in GNU 
        db 66H, 6FH, 72H, 6DH, 61H, 74H, 20H, 28H       ; 0EC0 _ format (
        db 64H, 65H, 66H, 61H, 75H, 6CH, 74H, 29H       ; 0EC8 _ default)
        db 0AH, 20H, 20H, 20H, 20H, 2DH, 58H, 67H       ; 0ED0 _ .    -Xg
        db 63H, 63H, 20H, 20H, 20H, 20H, 20H, 20H       ; 0ED8 _ cc      
        db 20H, 20H, 20H, 20H, 61H, 6CH, 69H, 61H       ; 0EE0 _     alia
        db 73H, 20H, 66H, 6FH, 72H, 20H, 2DH, 58H       ; 0EE8 _ s for -X
        db 67H, 6EH, 75H, 0AH, 20H, 20H, 20H, 20H       ; 0EF0 _ gnu.    
        db 2DH, 58H, 76H, 63H, 20H, 20H, 20H, 20H       ; 0EF8 _ -Xvc    
        db 20H, 20H, 20H, 20H, 20H, 20H, 20H, 72H       ; 0F00 _        r
        db 65H, 70H, 6FH, 72H, 74H, 20H, 65H, 72H       ; 0F08 _ eport er
        db 72H, 6FH, 72H, 73H, 20H, 69H, 6EH, 20H       ; 0F10 _ rors in 
        db 56H, 69H, 73H, 75H, 61H, 6CH, 20H, 53H       ; 0F18 _ Visual S
        db 74H, 75H, 64H, 69H, 6FH, 20H, 66H, 6FH       ; 0F20 _ tudio fo
        db 72H, 6DH, 61H, 74H, 0AH, 20H, 20H, 20H       ; 0F28 _ rmat.   
        db 20H, 2DH, 58H, 6DH, 73H, 76H, 63H, 20H       ; 0F30 _  -Xmsvc 
        db 20H, 20H, 20H, 20H, 20H, 20H, 20H, 20H       ; 0F38 _         
        db 61H, 6CH, 69H, 61H, 73H, 20H, 66H, 6FH       ; 0F40 _ alias fo
        db 72H, 20H, 2DH, 58H, 76H, 63H, 0AH, 20H       ; 0F48 _ r -Xvc. 
        db 20H, 20H, 20H, 2DH, 58H, 6DH, 73H, 20H       ; 0F50 _    -Xms 
        db 20H, 20H, 20H, 20H, 20H, 20H, 20H, 20H       ; 0F58 _         
        db 20H, 20H, 61H, 6CH, 69H, 61H, 73H, 20H       ; 0F60 _   alias 
        db 66H, 6FH, 72H, 20H, 2DH, 58H, 76H, 63H       ; 0F68 _ for -Xvc
        db 0AH, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0F70 _ ........

?_605:                                                  ; byte
        db 20H, 20H, 20H, 20H, 2DH, 73H, 20H, 20H       ; 0F78 _     -s  
        db 20H, 20H, 20H, 20H, 20H, 20H, 20H, 20H       ; 0F80 _         
        db 20H, 20H, 20H, 72H, 65H, 64H, 69H, 72H       ; 0F88 _    redir
        db 65H, 63H, 74H, 20H, 6DH, 65H, 73H, 73H       ; 0F90 _ ect mess
        db 61H, 67H, 65H, 73H, 20H, 74H, 6FH, 20H       ; 0F98 _ ages to 
        db 73H, 74H, 64H, 6FH, 75H, 74H, 0AH, 20H       ; 0FA0 _ stdout. 
        db 20H, 20H, 20H, 2DH, 5AH, 66H, 69H, 6CH       ; 0FA8 _    -Zfil
        db 65H, 20H, 20H, 20H, 20H, 20H, 20H, 20H       ; 0FB0 _ e       
        db 20H, 20H, 72H, 65H, 64H, 69H, 72H, 65H       ; 0FB8 _   redire
        db 63H, 74H, 20H, 6DH, 65H, 73H, 73H, 61H       ; 0FC0 _ ct messa
        db 67H, 65H, 73H, 20H, 74H, 6FH, 20H, 66H       ; 0FC8 _ ges to f
        db 69H, 6CH, 65H, 0AH, 20H, 20H, 20H, 20H       ; 0FD0 _ ile.    
        db 2DH, 2DH, 69H, 6EH, 66H, 6FH, 5BH, 3DH       ; 0FD8 _ --info[=
        db 6CH, 76H, 6CH, 5DH, 20H, 20H, 20H, 64H       ; 0FE0 _ lvl]   d
        db 69H, 73H, 70H, 6CH, 61H, 79H, 20H, 6FH       ; 0FE8 _ isplay o
        db 70H, 74H, 69H, 6FH, 6EH, 61H, 6CH, 20H       ; 0FF0 _ ptional 
        db 69H, 6EH, 66H, 6FH, 72H, 6DH, 61H, 74H       ; 0FF8 _ informat
        db 69H, 6FH, 6EH, 61H, 6CH, 20H, 6DH, 65H       ; 1000 _ ional me
        db 73H, 73H, 61H, 67H, 65H, 73H, 0AH, 20H       ; 1008 _ ssages. 
        db 20H, 20H, 20H, 2DH, 2DH, 64H, 65H, 62H       ; 1010 _    --deb
        db 75H, 67H, 5BH, 3DH, 6CH, 76H, 6CH, 5DH       ; 1018 _ ug[=lvl]
        db 20H, 20H, 64H, 69H, 73H, 70H, 6CH, 61H       ; 1020 _   displa
        db 79H, 20H, 4EH, 41H, 53H, 4DH, 20H, 69H       ; 1028 _ y NASM i
        db 6EH, 74H, 65H, 72H, 6EH, 61H, 6CH, 20H       ; 1030 _ nternal 
        db 64H, 65H, 62H, 75H, 67H, 67H, 69H, 6EH       ; 1038 _ debuggin
        db 67H, 20H, 6DH, 65H, 73H, 73H, 61H, 67H       ; 1040 _ g messag
        db 65H, 73H, 0AH, 00H                           ; 1048 _ es..

?_606:                                                  ; byte
        db 20H, 28H, 73H, 65H, 65H, 20H, 2DH, 68H       ; 104C _  (see -h
        db 20H, 2DH, 4DH, 29H, 00H, 00H, 00H, 00H       ; 1054 _  -M)....
        db 00H, 00H, 00H, 00H                           ; 105C _ ....

?_607:                                                  ; byte
        db 20H, 28H, 6DH, 75H, 6CH, 74H, 69H, 70H       ; 1060 _  (multip
        db 6CH, 65H, 20H, 6FH, 70H, 74H, 69H, 6FH       ; 1068 _ le optio
        db 6EH, 73H, 20H, 70H, 65H, 72H, 6DH, 69H       ; 1070 _ ns permi
        db 74H, 74H, 65H, 64H, 29H, 3AH, 00H, 00H       ; 1078 _ tted):..

?_608:                                                  ; byte
        db 20H, 20H, 20H, 20H, 2DH, 4DH, 2EH, 2EH       ; 1080 _     -M..
        db 2EH, 20H, 20H, 20H, 20H, 20H, 20H, 20H       ; 1088 _ .       
        db 20H, 20H, 20H, 67H, 65H, 6EH, 65H, 72H       ; 1090 _    gener
        db 61H, 74H, 65H, 20H, 4DH, 61H, 6BH, 65H       ; 1098 _ ate Make
        db 66H, 69H, 6CH, 65H, 20H, 64H, 65H, 70H       ; 10A0 _ file dep
        db 65H, 6EH, 64H, 65H, 6EH, 63H, 69H, 65H       ; 10A8 _ endencie
        db 73H, 25H, 73H, 0AH, 00H, 00H, 00H, 00H       ; 10B0 _ s%s.....

?_609:                                                  ; byte
        db 20H, 20H, 20H, 20H, 2DH, 4DH, 20H, 20H       ; 10B8 _     -M  
        db 20H, 20H, 20H, 20H, 20H, 20H, 20H, 20H       ; 10C0 _         
        db 20H, 20H, 20H, 67H, 65H, 6EH, 65H, 72H       ; 10C8 _    gener
        db 61H, 74H, 65H, 20H, 4DH, 61H, 6BH, 65H       ; 10D0 _ ate Make
        db 66H, 69H, 6CH, 65H, 20H, 64H, 65H, 70H       ; 10D8 _ file dep
        db 65H, 6EH, 64H, 65H, 6EH, 63H, 69H, 65H       ; 10E0 _ endencie
        db 73H, 20H, 6FH, 6EH, 20H, 73H, 74H, 64H       ; 10E8 _ s on std
        db 6FH, 75H, 74H, 0AH, 20H, 20H, 20H, 20H       ; 10F0 _ out.    
        db 2DH, 4DH, 47H, 20H, 20H, 20H, 20H, 20H       ; 10F8 _ -MG     
        db 20H, 20H, 20H, 20H, 20H, 20H, 20H, 64H       ; 1100 _        d
        db 3AH, 6FH, 2CH, 20H, 6DH, 69H, 73H, 73H       ; 1108 _ :o, miss
        db 69H, 6EH, 67H, 20H, 66H, 69H, 6CH, 65H       ; 1110 _ ing file
        db 73H, 20H, 61H, 73H, 73H, 75H, 6DH, 65H       ; 1118 _ s assume
        db 64H, 20H, 67H, 65H, 6EH, 65H, 72H, 61H       ; 1120 _ d genera
        db 74H, 65H, 64H, 0AH, 20H, 20H, 20H, 20H       ; 1128 _ ted.    
        db 2DH, 4DH, 46H, 20H, 66H, 69H, 6CH, 65H       ; 1130 _ -MF file
        db 20H, 20H, 20H, 20H, 20H, 20H, 20H, 73H       ; 1138 _        s
        db 65H, 74H, 20H, 4DH, 61H, 6BH, 65H, 66H       ; 1140 _ et Makef
        db 69H, 6CH, 65H, 20H, 64H, 65H, 70H, 65H       ; 1148 _ ile depe
        db 6EH, 64H, 65H, 6EH, 63H, 79H, 20H, 66H       ; 1150 _ ndency f
        db 69H, 6CH, 65H, 0AH, 20H, 20H, 20H, 20H       ; 1158 _ ile.    
        db 2DH, 4DH, 44H, 20H, 66H, 69H, 6CH, 65H       ; 1160 _ -MD file
        db 20H, 20H, 20H, 20H, 20H, 20H, 20H, 61H       ; 1168 _        a
        db 73H, 73H, 65H, 6DH, 62H, 6CH, 65H, 20H       ; 1170 _ ssemble 
        db 61H, 6EH, 64H, 20H, 67H, 65H, 6EH, 65H       ; 1178 _ and gene
        db 72H, 61H, 74H, 65H, 20H, 64H, 65H, 70H       ; 1180 _ rate dep
        db 65H, 6EH, 64H, 65H, 6EH, 63H, 69H, 65H       ; 1188 _ endencie
        db 73H, 0AH, 20H, 20H, 20H, 20H, 2DH, 4DH       ; 1190 _ s.    -M
        db 54H, 20H, 66H, 69H, 6CH, 65H, 20H, 20H       ; 1198 _ T file  
        db 20H, 20H, 20H, 20H, 20H, 64H, 65H, 70H       ; 11A0 _      dep
        db 65H, 6EH, 64H, 65H, 6EH, 63H, 79H, 20H       ; 11A8 _ endency 
        db 74H, 61H, 72H, 67H, 65H, 74H, 20H, 6EH       ; 11B0 _ target n
        db 61H, 6DH, 65H, 0AH, 20H, 20H, 20H, 20H       ; 11B8 _ ame.    
        db 2DH, 4DH, 51H, 20H, 66H, 69H, 6CH, 65H       ; 11C0 _ -MQ file
        db 20H, 20H, 20H, 20H, 20H, 20H, 20H, 64H       ; 11C8 _        d
        db 65H, 70H, 65H, 6EH, 64H, 65H, 6EH, 63H       ; 11D0 _ ependenc
        db 79H, 20H, 74H, 61H, 72H, 67H, 65H, 74H       ; 11D8 _ y target
        db 20H, 6EH, 61H, 6DH, 65H, 20H, 28H, 71H       ; 11E0 _  name (q
        db 75H, 6FH, 74H, 65H, 64H, 29H, 0AH, 20H       ; 11E8 _ uoted). 
        db 20H, 20H, 20H, 2DH, 4DH, 50H, 20H, 20H       ; 11F0 _    -MP  
        db 20H, 20H, 20H, 20H, 20H, 20H, 20H, 20H       ; 11F8 _         
        db 20H, 20H, 65H, 6DH, 69H, 74H, 20H, 70H       ; 1200 _   emit p
        db 68H, 6FH, 6EH, 79H, 20H, 74H, 61H, 72H       ; 1208 _ hony tar
        db 67H, 65H, 74H, 73H, 0AH, 20H, 20H, 20H       ; 1210 _ gets.   
        db 20H, 2DH, 4DH, 57H, 20H, 20H, 20H, 20H       ; 1218 _  -MW    
        db 20H, 20H, 20H, 20H, 20H, 20H, 20H, 20H       ; 1220 _         
        db 67H, 65H, 6EH, 65H, 72H, 61H, 74H, 65H       ; 1228 _ generate
        db 20H, 6FH, 75H, 74H, 70H, 75H, 74H, 20H       ; 1230 _  output 
        db 69H, 6EH, 20H, 57H, 61H, 74H, 63H, 6FH       ; 1238 _ in Watco
        db 6DH, 20H, 77H, 6DH, 61H, 6BH, 65H, 20H       ; 1240 _ m wmake 
        db 73H, 79H, 6EH, 74H, 61H, 78H, 0AH, 00H       ; 1248 _ syntax..

?_610:                                                  ; byte
        db 20H, 28H, 73H, 65H, 65H, 20H, 2DH, 68H       ; 1250 _  (see -h
        db 20H, 2DH, 66H, 29H, 00H, 00H, 00H, 00H       ; 1258 _  -f)....

?_611:                                                  ; byte
        db 20H, 20H, 20H, 20H, 2DH, 66H, 20H, 66H       ; 1260 _     -f f
        db 6FH, 72H, 6DH, 61H, 74H, 20H, 20H, 20H       ; 1268 _ ormat   
        db 20H, 20H, 20H, 73H, 65H, 6CH, 65H, 63H       ; 1270 _    selec
        db 74H, 20H, 6FH, 75H, 74H, 70H, 75H, 74H       ; 1278 _ t output
        db 20H, 66H, 69H, 6CH, 65H, 20H, 66H, 6FH       ; 1280 _  file fo
        db 72H, 6DH, 61H, 74H, 25H, 73H, 0AH, 00H       ; 1288 _ rmat%s..

?_612:                                                  ; byte
        db 20H, 28H, 73H, 65H, 65H, 20H, 2DH, 68H       ; 1290 _  (see -h
        db 20H, 2DH, 46H, 29H, 00H, 00H, 00H, 00H       ; 1298 _  -F)....

?_613:                                                  ; byte
        db 20H, 20H, 20H, 20H, 2DH, 67H, 20H, 20H       ; 12A0 _     -g  
        db 20H, 20H, 20H, 20H, 20H, 20H, 20H, 20H       ; 12A8 _         
        db 20H, 20H, 20H, 67H, 65H, 6EH, 65H, 72H       ; 12B0 _    gener
        db 61H, 74H, 65H, 20H, 64H, 65H, 62H, 75H       ; 12B8 _ ate debu
        db 67H, 67H, 69H, 6EH, 67H, 20H, 69H, 6EH       ; 12C0 _ gging in
        db 66H, 6FH, 72H, 6DH, 61H, 74H, 69H, 6FH       ; 12C8 _ formatio
        db 6EH, 0AH, 20H, 20H, 20H, 20H, 2DH, 46H       ; 12D0 _ n.    -F
        db 20H, 66H, 6FH, 72H, 6DH, 61H, 74H, 20H       ; 12D8 _  format 
        db 20H, 20H, 20H, 20H, 20H, 73H, 65H, 6CH       ; 12E0 _      sel
        db 65H, 63H, 74H, 20H, 61H, 20H, 64H, 65H       ; 12E8 _ ect a de
        db 62H, 75H, 67H, 67H, 69H, 6EH, 67H, 20H       ; 12F0 _ bugging 
        db 66H, 6FH, 72H, 6DH, 61H, 74H, 25H, 73H       ; 12F8 _ format%s
        db 0AH, 20H, 20H, 20H, 20H, 2DH, 67H, 66H       ; 1300 _ .    -gf
        db 6FH, 72H, 6DH, 61H, 74H, 20H, 20H, 20H       ; 1308 _ ormat   
        db 20H, 20H, 20H, 20H, 73H, 61H, 6DH, 65H       ; 1310 _     same
        db 20H, 61H, 73H, 20H, 2DH, 67H, 20H, 2DH       ; 1318 _  as -g -
        db 46H, 20H, 66H, 6FH, 72H, 6DH, 61H, 74H       ; 1320 _ F format
        db 0AH, 00H                                     ; 1328 _ ..

?_614:                                                  ; byte
        db 20H, 28H, 73H, 65H, 65H, 20H, 2DH, 68H       ; 132A _  (see -h
        db 20H, 2DH, 4CH, 29H, 00H, 00H                 ; 1332 _  -L)..

?_615:                                                  ; byte
        db 20H, 20H, 20H, 20H, 2DH, 6CH, 20H, 6CH       ; 1338 _     -l l
        db 69H, 73H, 74H, 66H, 69H, 6CH, 65H, 20H       ; 1340 _ istfile 
        db 20H, 20H, 20H, 77H, 72H, 69H, 74H, 65H       ; 1348 _    write
        db 20H, 6CH, 69H, 73H, 74H, 69H, 6EH, 67H       ; 1350 _  listing
        db 20H, 74H, 6FH, 20H, 61H, 20H, 6CH, 69H       ; 1358 _  to a li
        db 73H, 74H, 20H, 66H, 69H, 6CH, 65H, 0AH       ; 1360 _ st file.
        db 20H, 20H, 20H, 20H, 2DH, 4CH, 66H, 6CH       ; 1368 _     -Lfl
        db 61H, 67H, 73H, 2EH, 2EH, 2EH, 20H, 20H       ; 1370 _ ags...  
        db 20H, 20H, 20H, 61H, 64H, 64H, 20H, 69H       ; 1378 _    add i
        db 6EH, 66H, 6FH, 72H, 6DH, 61H, 74H, 69H       ; 1380 _ nformati
        db 6FH, 6EH, 20H, 74H, 6FH, 20H, 74H, 68H       ; 1388 _ on to th
        db 65H, 20H, 6CH, 69H, 73H, 74H, 20H, 66H       ; 1390 _ e list f
        db 69H, 6CH, 65H, 25H, 73H, 0AH, 00H, 00H       ; 1398 _ ile%s...

?_616:                                                  ; byte
        db 20H, 20H, 20H, 20H, 20H, 20H, 20H, 20H       ; 13A0 _         
        db 20H, 20H, 20H, 20H, 20H, 20H, 20H, 20H       ; 13A8 _         
        db 2DH, 4CH, 20H, 66H, 6CH, 61H, 67H, 73H       ; 13B0 _ -L flags
        db 20H, 66H, 6FH, 72H, 20H, 67H, 65H, 6EH       ; 13B8 _  for gen
        db 65H, 72H, 61H, 6CH, 20H, 75H, 73H, 61H       ; 13C0 _ eral usa
        db 67H, 65H, 3AH, 0AH, 20H, 20H, 20H, 20H       ; 13C8 _ ge:.    
        db 20H, 20H, 20H, 2DH, 4CH, 62H, 20H, 20H       ; 13D0 _    -Lb  
        db 20H, 20H, 20H, 20H, 20H, 20H, 20H, 73H       ; 13D8 _        s
        db 68H, 6FH, 77H, 20H, 62H, 75H, 69H, 6CH       ; 13E0 _ how buil
        db 74H, 69H, 6EH, 20H, 6DH, 61H, 63H, 72H       ; 13E8 _ tin macr
        db 6FH, 20H, 70H, 61H, 63H, 6BH, 61H, 67H       ; 13F0 _ o packag
        db 65H, 73H, 20H, 28H, 73H, 74H, 61H, 6EH       ; 13F8 _ es (stan
        db 64H, 61H, 72H, 64H, 20H, 61H, 6EH, 64H       ; 1400 _ dard and
        db 20H, 25H, 75H, 73H, 65H, 29H, 0AH, 20H       ; 1408 _  %use). 
        db 20H, 20H, 20H, 20H, 20H, 20H, 2DH, 4CH       ; 1410 _       -L
        db 63H, 20H, 20H, 20H, 20H, 20H, 20H, 20H       ; 1418 _ c       
        db 20H, 20H, 6CH, 69H, 73H, 74H, 20H, 74H       ; 1420 _   list t
        db 68H, 65H, 20H, 64H, 61H, 74H, 61H, 20H       ; 1428 _ he data 
        db 63H, 6FH, 6EH, 74H, 65H, 6EH, 74H, 73H       ; 1430 _ contents
        db 20H, 6FH, 66H, 20H, 49H, 4EH, 43H, 42H       ; 1438 _  of INCB
        db 49H, 4EH, 20H, 66H, 69H, 6CH, 65H, 73H       ; 1440 _ IN files
        db 0AH, 20H, 20H, 20H, 20H, 20H, 20H, 20H       ; 1448 _ .       
        db 2DH, 4CH, 64H, 20H, 20H, 20H, 20H, 20H       ; 1450 _ -Ld     
        db 20H, 20H, 20H, 20H, 73H, 68H, 6FH, 77H       ; 1458 _     show
        db 20H, 62H, 79H, 74H, 65H, 20H, 61H, 6EH       ; 1460 _  byte an
        db 64H, 20H, 72H, 65H, 70H, 65H, 61H, 74H       ; 1468 _ d repeat
        db 20H, 63H, 6FH, 75H, 6EH, 74H, 73H, 20H       ; 1470 _  counts 
        db 69H, 6EH, 20H, 64H, 65H, 63H, 69H, 6DH       ; 1478 _ in decim
        db 61H, 6CH, 2CH, 20H, 6EH, 6FH, 74H, 20H       ; 1480 _ al, not 
        db 68H, 65H, 78H, 0AH, 20H, 20H, 20H, 20H       ; 1488 _ hex.    
        db 20H, 20H, 20H, 2DH, 4CH, 65H, 20H, 20H       ; 1490 _    -Le  
        db 20H, 20H, 20H, 20H, 20H, 20H, 20H, 73H       ; 1498 _        s
        db 68H, 6FH, 77H, 20H, 74H, 68H, 65H, 20H       ; 14A0 _ how the 
        db 70H, 72H, 65H, 70H, 72H, 6FH, 63H, 65H       ; 14A8 _ preproce
        db 73H, 73H, 65H, 64H, 20H, 6FH, 75H, 74H       ; 14B0 _ ssed out
        db 70H, 75H, 74H, 0AH, 20H, 20H, 20H, 20H       ; 14B8 _ put.    
        db 20H, 20H, 20H, 2DH, 4CH, 66H, 20H, 20H       ; 14C0 _    -Lf  
        db 20H, 20H, 20H, 20H, 20H, 20H, 20H, 69H       ; 14C8 _        i
        db 67H, 6EH, 6FH, 72H, 65H, 20H, 2EH, 6EH       ; 14D0 _ gnore .n
        db 6FH, 6CH, 69H, 73H, 74H, 20H, 28H, 66H       ; 14D8 _ olist (f
        db 6FH, 72H, 63H, 65H, 20H, 6FH, 75H, 74H       ; 14E0 _ orce out
        db 70H, 75H, 74H, 29H, 0AH, 20H, 20H, 20H       ; 14E8 _ put).   
        db 20H, 20H, 20H, 20H, 2DH, 4CH, 46H, 20H       ; 14F0 _     -LF 
        db 20H, 20H, 20H, 20H, 20H, 20H, 20H, 20H       ; 14F8 _         
        db 69H, 67H, 6EH, 6FH, 72H, 65H, 20H, 5BH       ; 1500 _ ignore [
        db 4CH, 49H, 53H, 54H, 20H, 2DH, 5DH, 20H       ; 1508 _ LIST -] 
        db 64H, 69H, 72H, 65H, 63H, 74H, 69H, 76H       ; 1510 _ directiv
        db 65H, 73H, 20H, 28H, 66H, 6FH, 72H, 63H       ; 1518 _ es (forc
        db 65H, 20H, 6FH, 75H, 74H, 70H, 75H, 74H       ; 1520 _ e output
        db 29H, 0AH, 20H, 20H, 20H, 20H, 20H, 20H       ; 1528 _ ).      
        db 20H, 2DH, 4CH, 6DH, 20H, 20H, 20H, 20H       ; 1530 _  -Lm    
        db 20H, 20H, 20H, 20H, 20H, 73H, 68H, 6FH       ; 1538 _      sho
        db 77H, 20H, 6DH, 75H, 6CH, 74H, 69H, 2DH       ; 1540 _ w multi-
        db 6CH, 69H, 6EH, 65H, 20H, 6DH, 61H, 63H       ; 1548 _ line mac
        db 72H, 6FH, 20H, 63H, 61H, 6CH, 6CH, 73H       ; 1550 _ ro calls
        db 20H, 77H, 69H, 74H, 68H, 20H, 65H, 78H       ; 1558 _  with ex
        db 70H, 61H, 6EH, 64H, 65H, 64H, 20H, 70H       ; 1560 _ panded p
        db 61H, 72H, 61H, 6DH, 65H, 74H, 65H, 72H       ; 1568 _ arameter
        db 73H, 0AH, 20H, 20H, 20H, 20H, 20H, 20H       ; 1570 _ s.      
        db 20H, 2DH, 4CH, 70H, 20H, 20H, 20H, 20H       ; 1578 _  -Lp    
        db 20H, 20H, 20H, 20H, 20H, 6FH, 75H, 74H       ; 1580 _      out
        db 70H, 75H, 74H, 20H, 61H, 20H, 6CH, 69H       ; 1588 _ put a li
        db 73H, 74H, 20H, 66H, 69H, 6CH, 65H, 20H       ; 1590 _ st file 
        db 65H, 76H, 65H, 72H, 79H, 20H, 70H, 61H       ; 1598 _ every pa
        db 73H, 73H, 2CH, 20H, 69H, 6EH, 20H, 63H       ; 15A0 _ ss, in c
        db 61H, 73H, 65H, 20H, 6FH, 66H, 20H, 65H       ; 15A8 _ ase of e
        db 72H, 72H, 6FH, 72H, 73H, 0AH, 20H, 20H       ; 15B0 _ rrors.  
        db 20H, 20H, 20H, 20H, 20H, 2DH, 4CH, 73H       ; 15B8 _      -Ls
        db 20H, 20H, 20H, 20H, 20H, 20H, 20H, 20H       ; 15C0 _         
        db 20H, 73H, 68H, 6FH, 77H, 20H, 61H, 6CH       ; 15C8 _  show al
        db 6CH, 20H, 73H, 69H, 6EH, 67H, 6CH, 65H       ; 15D0 _ l single
        db 2DH, 6CH, 69H, 6EH, 65H, 20H, 6DH, 61H       ; 15D8 _ -line ma
        db 63H, 72H, 6FH, 20H, 64H, 65H, 66H, 69H       ; 15E0 _ cro defi
        db 6EH, 69H, 74H, 69H, 6FH, 6EH, 73H, 0AH       ; 15E8 _ nitions.
        db 20H, 20H, 20H, 20H, 20H, 20H, 20H, 2DH       ; 15F0 _        -
        db 4CH, 74H, 20H, 20H, 20H, 20H, 20H, 20H       ; 15F8 _ Lt      
        db 20H, 20H, 20H, 6CH, 69H, 73H, 74H, 20H       ; 1600 _    list 
        db 74H, 68H, 65H, 20H, 66H, 75H, 6CH, 6CH       ; 1608 _ the full
        db 20H, 6FH, 75H, 74H, 70H, 75H, 74H, 20H       ; 1610 _  output 
        db 66H, 72H, 6FH, 6DH, 20H, 54H, 49H, 4DH       ; 1618 _ from TIM
        db 45H, 53H, 20H, 61H, 6EH, 64H, 20H, 41H       ; 1620 _ ES and A
        db 4CH, 49H, 47H, 4EH, 20H, 64H, 69H, 72H       ; 1628 _ LIGN dir
        db 65H, 63H, 74H, 69H, 76H, 65H, 73H, 0AH       ; 1630 _ ectives.
        db 20H, 20H, 20H, 20H, 20H, 20H, 20H, 2DH       ; 1638 _        -
        db 4CH, 2BH, 20H, 20H, 20H, 20H, 20H, 20H       ; 1640 _ L+      
        db 20H, 20H, 20H, 65H, 71H, 75H, 69H, 76H       ; 1648 _    equiv
        db 61H, 6CH, 65H, 6EH, 74H, 20H, 74H, 6FH       ; 1650 _ alent to
        db 20H, 2DH, 4CH, 62H, 64H, 65H, 66H, 46H       ; 1658 _  -LbdefF
        db 6DH, 70H, 73H, 0AH, 20H, 20H, 20H, 20H       ; 1660 _ mps.    
        db 20H, 20H, 20H, 2DH, 4CH, 2BH, 2BH, 20H       ; 1668 _    -L++ 
        db 20H, 20H, 20H, 20H, 20H, 20H, 20H, 65H       ; 1670 _        e
        db 71H, 75H, 69H, 76H, 61H, 6CH, 65H, 6EH       ; 1678 _ quivalen
        db 74H, 20H, 74H, 6FH, 20H, 2DH, 4CH, 2BH       ; 1680 _ t to -L+
        db 20H, 2DH, 4CH, 63H, 74H, 0AH, 20H, 20H       ; 1688 _  -Lct.  
        db 20H, 20H, 20H, 20H, 20H, 20H, 20H, 20H       ; 1690 _         
        db 20H, 20H, 20H, 20H, 20H, 20H, 2DH, 4CH       ; 1698 _       -L
        db 20H, 66H, 6CH, 61H, 67H, 73H, 20H, 69H       ; 16A0 _  flags i
        db 6EH, 74H, 65H, 6EH, 64H, 65H, 64H, 20H       ; 16A8 _ ntended 
        db 66H, 6FH, 72H, 20H, 64H, 65H, 62H, 75H       ; 16B0 _ for debu
        db 67H, 67H, 69H, 6EH, 67H, 20H, 4EH, 41H       ; 16B8 _ gging NA
        db 53H, 4DH, 3AH, 0AH, 20H, 20H, 20H, 20H       ; 16C0 _ SM:.    
        db 20H, 20H, 20H, 2DH, 4CH, 77H, 20H, 20H       ; 16C8 _    -Lw  
        db 20H, 20H, 20H, 20H, 20H, 20H, 20H, 66H       ; 16D0 _        f
        db 6CH, 75H, 73H, 68H, 20H, 74H, 68H, 65H       ; 16D8 _ lush the
        db 20H, 6FH, 75H, 74H, 70H, 75H, 74H, 20H       ; 16E0 _  output 
        db 61H, 66H, 74H, 65H, 72H, 20H, 65H, 76H       ; 16E8 _ after ev
        db 65H, 72H, 79H, 20H, 6CH, 69H, 6EH, 65H       ; 16F0 _ ery line
        db 20H, 28H, 76H, 65H, 72H, 79H, 20H, 73H       ; 16F8 _  (very s
        db 6CH, 6FH, 77H, 21H, 29H, 0AH, 20H, 20H       ; 1700 _ low!).  
        db 20H, 20H, 20H, 20H, 20H, 2DH, 4CH, 58H       ; 1708 _      -LX
        db 20H, 20H, 20H, 20H, 20H, 20H, 20H, 20H       ; 1710 _         
        db 20H, 6CH, 69H, 73H, 74H, 20H, 69H, 6EH       ; 1718 _  list in
        db 73H, 74H, 72H, 75H, 63H, 74H, 69H, 6FH       ; 1720 _ structio
        db 6EH, 20H, 70H, 61H, 74H, 74H, 65H, 72H       ; 1728 _ n patter
        db 6EH, 20H, 6CH, 69H, 6EH, 65H, 20H, 6EH       ; 1730 _ n line n
        db 75H, 6DH, 62H, 65H, 72H, 73H, 20H, 66H       ; 1738 _ umbers f
        db 72H, 6FH, 6DH, 20H, 69H, 6EH, 73H, 6EH       ; 1740 _ rom insn
        db 73H, 2EH, 78H, 64H, 61H, 0AH, 20H, 20H       ; 1748 _ s.xda.  
        db 20H, 20H, 20H, 20H, 20H, 2DH, 4CH, 21H       ; 1750 _      -L!
        db 20H, 20H, 20H, 20H, 20H, 20H, 20H, 20H       ; 1758 _         
        db 20H, 65H, 6EH, 61H, 62H, 6CH, 65H, 20H       ; 1760 _  enable 
        db 41H, 4CH, 4CH, 20H, 6CH, 69H, 73H, 74H       ; 1768 _ ALL list
        db 69H, 6EH, 67H, 20H, 6FH, 70H, 74H, 69H       ; 1770 _ ing opti
        db 6FH, 6EH, 73H, 20H, 69H, 6EH, 63H, 6CH       ; 1778 _ ons incl
        db 75H, 64H, 69H, 6EH, 67H, 20H, 64H, 65H       ; 1780 _ uding de
        db 62H, 75H, 67H, 67H, 69H, 6EH, 67H, 0AH       ; 1788 _ bugging.
        db 00H                                          ; 1790 _ .

?_617:                                                  ; byte
        db 20H, 28H, 73H, 65H, 65H, 20H, 2DH, 68H       ; 1791 _  (see -h
        db 20H, 2DH, 4FH, 29H, 00H, 00H, 00H            ; 1799 _  -O)...

?_618:                                                  ; byte
        db 20H, 20H, 20H, 20H, 2DH, 4FH, 66H, 6CH       ; 17A0 _     -Ofl
        db 61H, 67H, 73H, 2EH, 2EH, 2EH, 20H, 20H       ; 17A8 _ ags...  
        db 20H, 20H, 20H, 73H, 65H, 6CH, 65H, 63H       ; 17B0 _    selec
        db 74H, 20H, 6FH, 70H, 74H, 69H, 6DH, 69H       ; 17B8 _ t optimi
        db 7AH, 61H, 74H, 69H, 6FH, 6EH, 25H, 73H       ; 17C0 _ zation%s
        db 0AH, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 17C8 _ ........

?_619:                                                  ; byte
        db 20H, 20H, 20H, 20H, 20H, 20H, 20H, 2DH       ; 17D0 _        -
        db 4FH, 30H, 20H, 20H, 20H, 20H, 20H, 20H       ; 17D8 _ O0      
        db 20H, 6EH, 6FH, 20H, 6FH, 70H, 74H, 69H       ; 17E0 _  no opti
        db 6DH, 69H, 7AH, 61H, 74H, 69H, 6FH, 6EH       ; 17E8 _ mization
        db 0AH, 20H, 20H, 20H, 20H, 20H, 20H, 20H       ; 17F0 _ .       
        db 2DH, 4FH, 31H, 20H, 20H, 20H, 20H, 20H       ; 17F8 _ -O1     
        db 20H, 20H, 6DH, 69H, 6EH, 69H, 6DH, 61H       ; 1800 _   minima
        db 6CH, 20H, 6FH, 70H, 74H, 69H, 6DH, 69H       ; 1808 _ l optimi
        db 7AH, 61H, 74H, 69H, 6FH, 6EH, 0AH, 20H       ; 1810 _ zation. 
        db 20H, 20H, 20H, 20H, 20H, 20H, 2DH, 4FH       ; 1818 _       -O
        db 78H, 20H, 20H, 20H, 20H, 20H, 20H, 20H       ; 1820 _ x       
        db 6DH, 75H, 6CH, 74H, 69H, 70H, 61H, 73H       ; 1828 _ multipas
        db 73H, 20H, 6FH, 70H, 74H, 69H, 6DH, 69H       ; 1830 _ s optimi
        db 7AH, 61H, 74H, 69H, 6FH, 6EH, 20H, 28H       ; 1838 _ zation (
        db 64H, 65H, 66H, 61H, 75H, 6CH, 74H, 2CH       ; 1840 _ default,
        db 20H, 72H, 65H, 63H, 6FH, 6DH, 6DH, 65H       ; 1848 _  recomme
        db 6EH, 64H, 65H, 64H, 29H, 0AH, 20H, 20H       ; 1850 _ nded).  
        db 20H, 20H, 20H, 20H, 20H, 2DH, 4FH, 76H       ; 1858 _      -Ov
        db 20H, 20H, 20H, 20H, 20H, 20H, 20H, 64H       ; 1860 _        d
        db 69H, 73H, 70H, 6CH, 61H, 79H, 20H, 74H       ; 1868 _ isplay t
        db 68H, 65H, 20H, 6EH, 75H, 6DH, 62H, 65H       ; 1870 _ he numbe
        db 72H, 20H, 6FH, 66H, 20H, 70H, 61H, 73H       ; 1878 _ r of pas
        db 73H, 65H, 73H, 20H, 65H, 78H, 65H, 63H       ; 1880 _ ses exec
        db 75H, 74H, 65H, 64H, 20H, 61H, 74H, 20H       ; 1888 _ uted at 
        db 74H, 68H, 65H, 20H, 65H, 6EH, 64H, 0AH       ; 1890 _ the end.
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 1898 _ ........

?_620:                                                  ; byte
        db 20H, 20H, 20H, 20H, 2DH, 74H, 20H, 20H       ; 18A0 _     -t  
        db 20H, 20H, 20H, 20H, 20H, 20H, 20H, 20H       ; 18A8 _         
        db 20H, 20H, 20H, 61H, 73H, 73H, 65H, 6DH       ; 18B0 _    assem
        db 62H, 6CH, 65H, 20H, 69H, 6EH, 20H, 6CH       ; 18B8 _ ble in l
        db 69H, 6DH, 69H, 74H, 65H, 64H, 20H, 53H       ; 18C0 _ imited S
        db 63H, 69H, 54H, 65H, 63H, 68H, 20H, 54H       ; 18C8 _ ciTech T
        db 41H, 53H, 4DH, 20H, 63H, 6FH, 6DH, 70H       ; 18D0 _ ASM comp
        db 61H, 74H, 69H, 62H, 6CH, 65H, 20H, 6DH       ; 18D8 _ atible m
        db 6FH, 64H, 65H, 0AH, 20H, 20H, 20H, 20H       ; 18E0 _ ode.    
        db 2DH, 45H, 20H, 28H, 6FH, 72H, 20H, 2DH       ; 18E8 _ -E (or -
        db 65H, 29H, 20H, 20H, 20H, 20H, 20H, 70H       ; 18F0 _ e)     p
        db 72H, 65H, 70H, 72H, 6FH, 63H, 65H, 73H       ; 18F8 _ reproces
        db 73H, 20H, 6FH, 6EH, 6CH, 79H, 20H, 28H       ; 1900 _ s only (
        db 77H, 72H, 69H, 74H, 65H, 73H, 20H, 6FH       ; 1908 _ writes o
        db 75H, 74H, 70H, 75H, 74H, 20H, 74H, 6FH       ; 1910 _ utput to
        db 20H, 73H, 74H, 64H, 6FH, 75H, 74H, 20H       ; 1918 _  stdout 
        db 62H, 79H, 20H, 64H, 65H, 66H, 61H, 75H       ; 1920 _ by defau
        db 6CH, 74H, 29H, 0AH, 20H, 20H, 20H, 20H       ; 1928 _ lt).    
        db 2DH, 61H, 20H, 20H, 20H, 20H, 20H, 20H       ; 1930 _ -a      
        db 20H, 20H, 20H, 20H, 20H, 20H, 20H, 64H       ; 1938 _        d
        db 6FH, 6EH, 27H, 74H, 20H, 70H, 72H, 65H       ; 1940 _ on't pre
        db 70H, 72H, 6FH, 63H, 65H, 73H, 73H, 20H       ; 1948 _ process 
        db 28H, 61H, 73H, 73H, 65H, 6DH, 62H, 6CH       ; 1950 _ (assembl
        db 65H, 20H, 6FH, 6EH, 6CH, 79H, 29H, 0AH       ; 1958 _ e only).
        db 20H, 20H, 20H, 20H, 2DH, 49H, 70H, 61H       ; 1960 _     -Ipa
        db 74H, 68H, 20H, 20H, 20H, 20H, 20H, 20H       ; 1968 _ th      
        db 20H, 20H, 20H, 61H, 64H, 64H, 20H, 61H       ; 1970 _    add a
        db 20H, 70H, 61H, 74H, 68H, 6EH, 61H, 6DH       ; 1978 _  pathnam
        db 65H, 20H, 74H, 6FH, 20H, 74H, 68H, 65H       ; 1980 _ e to the
        db 20H, 69H, 6EH, 63H, 6CH, 75H, 64H, 65H       ; 1988 _  include
        db 20H, 66H, 69H, 6CH, 65H, 20H, 70H, 61H       ; 1990 _  file pa
        db 74H, 68H, 0AH, 20H, 20H, 20H, 20H, 2DH       ; 1998 _ th.    -
        db 50H, 66H, 69H, 6CH, 65H, 20H, 20H, 20H       ; 19A0 _ Pfile   
        db 20H, 20H, 20H, 20H, 20H, 20H, 70H, 72H       ; 19A8 _       pr
        db 65H, 2DH, 69H, 6EH, 63H, 6CH, 75H, 64H       ; 19B0 _ e-includ
        db 65H, 20H, 61H, 20H, 66H, 69H, 6CH, 65H       ; 19B8 _ e a file
        db 20H, 28H, 61H, 6CH, 73H, 6FH, 20H, 2DH       ; 19C0 _  (also -
        db 2DH, 69H, 6EH, 63H, 6CH, 75H, 64H, 65H       ; 19C8 _ -include
        db 29H, 0AH, 20H, 20H, 20H, 20H, 2DH, 44H       ; 19D0 _ ).    -D
        db 6DH, 61H, 63H, 72H, 6FH, 5BH, 3DH, 73H       ; 19D8 _ macro[=s
        db 74H, 72H, 5DH, 20H, 20H, 70H, 72H, 65H       ; 19E0 _ tr]  pre
        db 2DH, 64H, 65H, 66H, 69H, 6EH, 65H, 20H       ; 19E8 _ -define 
        db 61H, 20H, 6DH, 61H, 63H, 72H, 6FH, 0AH       ; 19F0 _ a macro.
        db 20H, 20H, 20H, 20H, 2DH, 55H, 6DH, 61H       ; 19F8 _     -Uma
        db 63H, 72H, 6FH, 20H, 20H, 20H, 20H, 20H       ; 1A00 _ cro     
        db 20H, 20H, 20H, 75H, 6EH, 64H, 65H, 66H       ; 1A08 _    undef
        db 69H, 6EH, 65H, 20H, 61H, 20H, 6DH, 61H       ; 1A10 _ ine a ma
        db 63H, 72H, 6FH, 0AH, 00H                      ; 1A18 _ cro..

?_621:                                                  ; byte
        db 20H, 28H, 73H, 65H, 65H, 20H, 2DH, 68H       ; 1A1D _  (see -h
        db 20H, 2DH, 77H, 29H, 00H, 00H, 00H, 00H       ; 1A25 _  -w)....
        db 00H, 00H, 00H                                ; 1A2D _ ...

?_622:                                                  ; byte
        db 20H, 20H, 20H, 20H, 2DH, 77H, 2BH, 78H       ; 1A30 _     -w+x
        db 20H, 20H, 20H, 20H, 20H, 20H, 20H, 20H       ; 1A38 _         
        db 20H, 20H, 20H, 65H, 6EH, 61H, 62H, 6CH       ; 1A40 _    enabl
        db 65H, 20H, 77H, 61H, 72H, 6EH, 69H, 6EH       ; 1A48 _ e warnin
        db 67H, 20H, 78H, 20H, 25H, 73H, 28H, 61H       ; 1A50 _ g x %s(a
        db 6CH, 73H, 6FH, 20H, 2DH, 57H, 78H, 29H       ; 1A58 _ lso -Wx)
        db 0AH, 20H, 20H, 20H, 20H, 2DH, 77H, 2DH       ; 1A60 _ .    -w-
        db 78H, 20H, 20H, 20H, 20H, 20H, 20H, 20H       ; 1A68 _ x       
        db 20H, 20H, 20H, 20H, 64H, 69H, 73H, 61H       ; 1A70 _     disa
        db 62H, 6CH, 65H, 20H, 77H, 61H, 72H, 6EH       ; 1A78 _ ble warn
        db 69H, 6EH, 67H, 20H, 78H, 20H, 28H, 61H       ; 1A80 _ ing x (a
        db 6CH, 73H, 6FH, 20H, 2DH, 57H, 6EH, 6FH       ; 1A88 _ lso -Wno
        db 2DH, 78H, 29H, 0AH, 20H, 20H, 20H, 20H       ; 1A90 _ -x).    
        db 2DH, 77H, 5BH, 2BH, 2DH, 5DH, 65H, 72H       ; 1A98 _ -w[+-]er
        db 72H, 6FH, 72H, 20H, 20H, 20H, 20H, 70H       ; 1AA0 _ ror    p
        db 72H, 6FH, 6DH, 6FH, 74H, 65H, 20H, 61H       ; 1AA8 _ romote a
        db 6CH, 6CH, 20H, 77H, 61H, 72H, 6EH, 69H       ; 1AB0 _ ll warni
        db 6EH, 67H, 73H, 20H, 74H, 6FH, 20H, 65H       ; 1AB8 _ ngs to e
        db 72H, 72H, 6FH, 72H, 73H, 20H, 28H, 61H       ; 1AC0 _ rrors (a
        db 6CH, 73H, 6FH, 20H, 2DH, 57H, 65H, 72H       ; 1AC8 _ lso -Wer
        db 72H, 6FH, 72H, 29H, 0AH, 20H, 20H, 20H       ; 1AD0 _ ror).   
        db 20H, 2DH, 77H, 5BH, 2BH, 2DH, 5DH, 65H       ; 1AD8 _  -w[+-]e
        db 72H, 72H, 6FH, 72H, 3DH, 78H, 20H, 20H       ; 1AE0 _ rror=x  
        db 70H, 72H, 6FH, 6DH, 6FH, 74H, 65H, 20H       ; 1AE8 _ promote 
        db 77H, 61H, 72H, 6EH, 69H, 6EH, 67H, 20H       ; 1AF0 _ warning 
        db 78H, 20H, 74H, 6FH, 20H, 65H, 72H, 72H       ; 1AF8 _ x to err
        db 6FH, 72H, 73H, 20H, 28H, 61H, 6CH, 73H       ; 1B00 _ ors (als
        db 6FH, 20H, 2DH, 57H, 65H, 72H, 72H, 6FH       ; 1B08 _ o -Werro
        db 72H, 3DH, 78H, 29H, 0AH, 00H                 ; 1B10 _ r=x)..

?_623:                                                  ; byte
        db 20H, 20H, 20H, 20H, 20H, 20H, 44H, 65H       ; 1B16 _       De
        db 66H, 61H, 75H, 6CH, 74H, 73H, 20H, 69H       ; 1B1E _ faults i
        db 6EH, 20H, 62H, 72H, 61H, 63H, 6BH, 65H       ; 1B26 _ n bracke
        db 74H, 73H, 3AH, 0AH, 00H                      ; 1B2E _ ts:..

?_624:                                                  ; byte
        db 20H, 20H, 20H, 20H, 20H, 20H, 20H, 25H       ; 1B33 _        %
        db 2DH, 32H, 30H, 73H, 20H, 25H, 73H, 0AH       ; 1B3B _ -20s %s.
        db 00H                                          ; 1B43 _ .

?_625:                                                  ; byte
        db 20H, 00H, 00H, 00H                           ; 1B44 _  ...

?_626:                                                  ; byte
        db 20H, 20H, 20H, 20H, 20H, 20H, 20H, 25H       ; 1B48 _        %
        db 2DH, 32H, 30H, 2EH, 2AH, 73H, 25H, 73H       ; 1B50 _ -20.*s%s
        db 61H, 6CH, 6CH, 20H, 77H, 61H, 72H, 6EH       ; 1B58 _ all warn
        db 69H, 6EH, 67H, 73H, 20H, 70H, 72H, 65H       ; 1B60 _ ings pre
        db 66H, 69H, 78H, 65H, 64H, 20H, 77H, 69H       ; 1B68 _ fixed wi
        db 74H, 68H, 20H, 22H, 25H, 2EH, 2AH, 73H       ; 1B70 _ th "%.*s
        db 22H, 0AH, 00H                                ; 1B78 _ "..

?_627:                                                  ; byte
        db 20H, 5BH, 6FH, 6EH, 5DH, 00H                 ; 1B7B _  [on].

?_628:                                                  ; byte
        db 20H, 5BH, 6FH, 66H, 66H, 5DH, 00H            ; 1B81 _  [off].

?_629:                                                  ; byte
        db 20H, 5BH, 65H, 72H, 72H, 6FH, 72H, 5DH       ; 1B88 _  [error]
        db 00H                                          ; 1B90 _ .

?_630:                                                  ; byte
        db 20H, 20H, 20H, 20H, 20H, 20H, 20H, 25H       ; 1B91 _        %
        db 2DH, 32H, 30H, 73H, 25H, 73H, 25H, 73H       ; 1B99 _ -20s%s%s
        db 25H, 73H, 0AH, 00H, 00H, 00H, 00H            ; 1BA1 _ %s.....

?_631:                                                  ; byte
        db 20H, 20H, 20H, 20H, 2DH, 2DH, 70H, 72H       ; 1BA8 _     --pr
        db 61H, 67H, 6DH, 61H, 20H, 73H, 74H, 72H       ; 1BB0 _ agma str
        db 20H, 20H, 20H, 70H, 72H, 65H, 2DH, 65H       ; 1BB8 _    pre-e
        db 78H, 65H, 63H, 75H, 74H, 65H, 73H, 20H       ; 1BC0 _ xecutes 
        db 61H, 20H, 73H, 70H, 65H, 63H, 69H, 66H       ; 1BC8 _ a specif
        db 69H, 63H, 20H, 25H, 70H, 72H, 61H, 67H       ; 1BD0 _ ic %prag
        db 6DH, 61H, 0AH, 20H, 20H, 20H, 20H, 2DH       ; 1BD8 _ ma.    -
        db 2DH, 62H, 65H, 66H, 6FH, 72H, 65H, 20H       ; 1BE0 _ -before 
        db 73H, 74H, 72H, 20H, 20H, 20H, 61H, 64H       ; 1BE8 _ str   ad
        db 64H, 20H, 6CH, 69H, 6EH, 65H, 20H, 28H       ; 1BF0 _ d line (
        db 75H, 73H, 75H, 61H, 6CH, 6CH, 79H, 20H       ; 1BF8 _ usually 
        db 61H, 20H, 70H, 72H, 65H, 70H, 72H, 6FH       ; 1C00 _ a prepro
        db 63H, 65H, 73H, 73H, 6FH, 72H, 20H, 73H       ; 1C08 _ cessor s
        db 74H, 61H, 74H, 65H, 6DH, 65H, 6EH, 74H       ; 1C10 _ tatement
        db 29H, 20H, 62H, 65H, 66H, 6FH, 72H, 65H       ; 1C18 _ ) before
        db 20H, 74H, 68H, 65H, 20H, 69H, 6EH, 70H       ; 1C20 _  the inp
        db 75H, 74H, 0AH, 20H, 20H, 20H, 20H, 2DH       ; 1C28 _ ut.    -
        db 2DH, 62H, 69H, 74H, 73H, 20H, 6EH, 6EH       ; 1C30 _ -bits nn
        db 20H, 20H, 20H, 20H, 20H, 20H, 73H, 65H       ; 1C38 _       se
        db 74H, 20H, 62H, 69H, 74H, 73H, 20H, 74H       ; 1C40 _ t bits t
        db 6FH, 20H, 6EH, 6EH, 20H, 28H, 65H, 71H       ; 1C48 _ o nn (eq
        db 75H, 69H, 76H, 61H, 6CH, 65H, 6EH, 74H       ; 1C50 _ uivalent
        db 20H, 74H, 6FH, 20H, 2DH, 2DH, 62H, 65H       ; 1C58 _  to --be
        db 66H, 6FH, 72H, 65H, 20H, 22H, 42H, 49H       ; 1C60 _ fore "BI
        db 54H, 53H, 20H, 6EH, 6EH, 22H, 29H, 0AH       ; 1C68 _ TS nn").
        db 20H, 20H, 20H, 20H, 2DH, 2DH, 6EH, 6FH       ; 1C70 _     --no
        db 2DH, 6CH, 69H, 6EH, 65H, 20H, 20H, 20H       ; 1C78 _ -line   
        db 20H, 20H, 20H, 69H, 67H, 6EH, 6FH, 72H       ; 1C80 _    ignor
        db 65H, 20H, 25H, 6CH, 69H, 6EH, 65H, 20H       ; 1C88 _ e %line 
        db 64H, 69H, 72H, 65H, 63H, 74H, 69H, 76H       ; 1C90 _ directiv
        db 65H, 73H, 20H, 69H, 6EH, 20H, 69H, 6EH       ; 1C98 _ es in in
        db 70H, 75H, 74H, 0AH, 20H, 20H, 20H, 20H       ; 1CA0 _ put.    
        db 2DH, 2DH, 67H, 70H, 72H, 65H, 66H, 69H       ; 1CA8 _ --gprefi
        db 78H, 20H, 73H, 74H, 72H, 20H, 20H, 70H       ; 1CB0 _ x str  p
        db 72H, 65H, 70H, 65H, 6EH, 64H, 20H, 74H       ; 1CB8 _ repend t
        db 68H, 65H, 20H, 67H, 69H, 76H, 65H, 6EH       ; 1CC0 _ he given
        db 20H, 73H, 74H, 72H, 69H, 6EH, 67H, 20H       ; 1CC8 _  string 
        db 74H, 6FH, 20H, 74H, 68H, 65H, 20H, 6EH       ; 1CD0 _ to the n
        db 61H, 6DH, 65H, 73H, 20H, 6FH, 66H, 20H       ; 1CD8 _ ames of 
        db 61H, 6CH, 6CH, 20H, 65H, 78H, 74H, 65H       ; 1CE0 _ all exte
        db 72H, 6EH, 2CH, 0AH, 20H, 20H, 20H, 20H       ; 1CE8 _ rn,.    
        db 20H, 20H, 20H, 20H, 20H, 20H, 20H, 20H       ; 1CF0 _         
        db 20H, 20H, 20H, 20H, 20H, 20H, 20H, 63H       ; 1CF8 _        c
        db 6FH, 6DH, 6DH, 6FH, 6EH, 20H, 61H, 6EH       ; 1D00 _ ommon an
        db 64H, 20H, 67H, 6CH, 6FH, 62H, 61H, 6CH       ; 1D08 _ d global
        db 20H, 73H, 79H, 6DH, 62H, 6FH, 6CH, 73H       ; 1D10 _  symbols
        db 20H, 28H, 61H, 6CH, 73H, 6FH, 20H, 2DH       ; 1D18 _  (also -
        db 2DH, 70H, 72H, 65H, 66H, 69H, 78H, 29H       ; 1D20 _ -prefix)
        db 0AH, 20H, 20H, 20H, 20H, 2DH, 2DH, 67H       ; 1D28 _ .    --g
        db 70H, 6FH, 73H, 74H, 66H, 69H, 78H, 20H       ; 1D30 _ postfix 
        db 73H, 74H, 72H, 20H, 61H, 70H, 70H, 65H       ; 1D38 _ str appe
        db 6EH, 64H, 20H, 74H, 68H, 65H, 20H, 67H       ; 1D40 _ nd the g
        db 69H, 76H, 65H, 6EH, 20H, 73H, 74H, 72H       ; 1D48 _ iven str
        db 69H, 6EH, 67H, 20H, 74H, 6FH, 20H, 74H       ; 1D50 _ ing to t
        db 68H, 65H, 20H, 6EH, 61H, 6DH, 65H, 73H       ; 1D58 _ he names
        db 20H, 6FH, 66H, 20H, 61H, 6CH, 6CH, 20H       ; 1D60 _  of all 
        db 65H, 78H, 74H, 65H, 72H, 6EH, 2CH, 0AH       ; 1D68 _ extern,.
        db 20H, 20H, 20H, 20H, 20H, 20H, 20H, 20H       ; 1D70 _         
        db 20H, 20H, 20H, 20H, 20H, 20H, 20H, 20H       ; 1D78 _         
        db 20H, 20H, 20H, 63H, 6FH, 6DH, 6DH, 6FH       ; 1D80 _    commo
        db 6EH, 20H, 61H, 6EH, 64H, 20H, 67H, 6CH       ; 1D88 _ n and gl
        db 6FH, 62H, 61H, 6CH, 20H, 73H, 79H, 6DH       ; 1D90 _ obal sym
        db 62H, 6FH, 6CH, 73H, 20H, 28H, 61H, 6CH       ; 1D98 _ bols (al
        db 73H, 6FH, 20H, 2DH, 2DH, 70H, 6FH, 73H       ; 1DA0 _ so --pos
        db 74H, 66H, 69H, 78H, 29H, 0AH, 20H, 20H       ; 1DA8 _ tfix).  
        db 20H, 20H, 2DH, 2DH, 6CH, 70H, 72H, 65H       ; 1DB0 _   --lpre
        db 66H, 69H, 78H, 20H, 73H, 74H, 72H, 20H       ; 1DB8 _ fix str 
        db 20H, 70H, 72H, 65H, 70H, 65H, 6EH, 64H       ; 1DC0 _  prepend
        db 20H, 74H, 68H, 65H, 20H, 67H, 69H, 76H       ; 1DC8 _  the giv
        db 65H, 6EH, 20H, 73H, 74H, 72H, 69H, 6EH       ; 1DD0 _ en strin
        db 67H, 20H, 74H, 6FH, 20H, 6CH, 6FH, 63H       ; 1DD8 _ g to loc
        db 61H, 6CH, 20H, 73H, 79H, 6DH, 62H, 6FH       ; 1DE0 _ al symbo
        db 6CH, 73H, 0AH, 20H, 20H, 20H, 20H, 2DH       ; 1DE8 _ ls.    -
        db 2DH, 6CH, 70H, 6FH, 73H, 74H, 66H, 69H       ; 1DF0 _ -lpostfi
        db 78H, 20H, 73H, 74H, 72H, 20H, 61H, 70H       ; 1DF8 _ x str ap
        db 70H, 65H, 6EH, 64H, 20H, 74H, 68H, 65H       ; 1E00 _ pend the
        db 20H, 67H, 69H, 76H, 65H, 6EH, 20H, 73H       ; 1E08 _  given s
        db 74H, 72H, 69H, 6EH, 67H, 20H, 74H, 6FH       ; 1E10 _ tring to
        db 20H, 6CH, 6FH, 63H, 61H, 6CH, 20H, 73H       ; 1E18 _  local s
        db 79H, 6DH, 62H, 6FH, 6CH, 73H, 0AH, 20H       ; 1E20 _ ymbols. 
        db 20H, 20H, 20H, 2DH, 2DH, 72H, 65H, 70H       ; 1E28 _    --rep
        db 72H, 6FH, 64H, 75H, 63H, 69H, 62H, 6CH       ; 1E30 _ roducibl
        db 65H, 20H, 61H, 74H, 74H, 65H, 6DH, 70H       ; 1E38 _ e attemp
        db 74H, 20H, 74H, 6FH, 20H, 70H, 72H, 6FH       ; 1E40 _ t to pro
        db 64H, 75H, 63H, 65H, 20H, 72H, 75H, 6EH       ; 1E48 _ duce run
        db 2DH, 74H, 6FH, 2DH, 72H, 75H, 6EH, 20H       ; 1E50 _ -to-run 
        db 69H, 64H, 65H, 6EH, 74H, 69H, 63H, 61H       ; 1E58 _ identica
        db 6CH, 20H, 6FH, 75H, 74H, 70H, 75H, 74H       ; 1E60 _ l output
        db 0AH, 20H, 20H, 20H, 20H, 2DH, 2DH, 64H       ; 1E68 _ .    --d
        db 65H, 62H, 75H, 67H, 2DH, 70H, 72H, 65H       ; 1E70 _ ebug-pre
        db 66H, 69H, 78H, 2DH, 6DH, 61H, 70H, 20H       ; 1E78 _ fix-map 
        db 62H, 61H, 73H, 65H, 3DH, 64H, 65H, 73H       ; 1E80 _ base=des
        db 74H, 0AH, 20H, 20H, 20H, 20H, 20H, 20H       ; 1E88 _ t.      
        db 20H, 20H, 20H, 20H, 20H, 20H, 20H, 20H       ; 1E90 _         
        db 20H, 20H, 20H, 20H, 20H, 72H, 65H, 6DH       ; 1E98 _      rem
        db 61H, 70H, 20H, 70H, 61H, 74H, 68H, 73H       ; 1EA0 _ ap paths
        db 20H, 73H, 74H, 61H, 72H, 74H, 69H, 6EH       ; 1EA8 _  startin
        db 67H, 20H, 77H, 69H, 74H, 68H, 20H, 27H       ; 1EB0 _ g with '
        db 62H, 61H, 73H, 65H, 27H, 20H, 74H, 6FH       ; 1EB8 _ base' to
        db 20H, 27H, 64H, 65H, 73H, 74H, 27H, 20H       ; 1EC0 _  'dest' 
        db 69H, 6EH, 20H, 6FH, 75H, 74H, 70H, 75H       ; 1EC8 _ in outpu
        db 74H, 20H, 66H, 69H, 6CH, 65H, 73H, 0AH       ; 1ED0 _ t files.
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 1ED8 _ ........

?_632:                                                  ; byte
        db 20H, 20H, 20H, 20H, 2DH, 2DH, 6CH, 69H       ; 1EE0 _     --li
        db 6DH, 69H, 74H, 2DH, 2AH, 20H, 76H, 61H       ; 1EE8 _ mit-* va
        db 6CH, 20H, 20H, 73H, 65H, 74H, 20H, 65H       ; 1EF0 _ l  set e
        db 78H, 65H, 63H, 75H, 74H, 69H, 6FH, 6EH       ; 1EF8 _ xecution
        db 20H, 6CH, 69H, 6DH, 69H, 74H, 3AH, 0AH       ; 1F00 _  limit:.
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 1F08 _ ........

?_633:                                                  ; byte
        db 20H, 20H, 20H, 20H, 20H, 20H, 20H, 25H       ; 1F10 _        %
        db 2DH, 32H, 30H, 73H, 20H, 25H, 73H, 0AH       ; 1F18 _ -20s %s.
        db 20H, 20H, 20H, 20H, 20H, 20H, 20H, 25H       ; 1F20 _        %
        db 2DH, 32H, 30H, 73H, 20H, 5BH, 64H, 65H       ; 1F28 _ -20s [de
        db 66H, 61H, 75H, 6CH, 74H, 20H, 25H, 73H       ; 1F30 _ fault %s
        db 00H                                          ; 1F38 _ .

?_634:                                                  ; byte
        db 2CH, 20H, 6DH, 61H, 78H, 20H, 25H, 73H       ; 1F39 _ , max %s
        db 5DH, 0AH, 00H                                ; 1F41 _ ]..

?_635:                                                  ; byte
        db 20H, 28H, 73H, 65H, 65H, 20H, 2DH, 68H       ; 1F44 _  (see -h
        db 20H, 2DH, 2DH, 6CH, 69H, 6DH, 69H, 74H       ; 1F4C _  --limit
        db 29H, 00H, 00H, 00H                           ; 1F54 _ )...

?_636:                                                  ; byte
        db 20H, 20H, 20H, 20H, 2DH, 2DH, 6CH, 69H       ; 1F58 _     --li
        db 6DH, 69H, 74H, 2DH, 2AH, 20H, 76H, 61H       ; 1F60 _ mit-* va
        db 6CH, 20H, 20H, 73H, 65H, 74H, 20H, 65H       ; 1F68 _ l  set e
        db 78H, 65H, 63H, 75H, 74H, 69H, 6FH, 6EH       ; 1F70 _ xecution
        db 20H, 6CH, 69H, 6DH, 69H, 74H, 25H, 73H       ; 1F78 _  limit%s
        db 0AH, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 1F80 _ ........

__func__.4:                                             ; byte
        db 67H, 65H, 74H, 5FH, 66H, 69H, 6CH, 65H       ; 1F88 _ get_file
        db 6EH, 61H, 6DH, 65H, 00H, 00H, 00H, 00H       ; 1F90 _ name....

__func__.3:                                             ; byte
        db 70H, 72H, 6FH, 63H, 65H, 73H, 73H, 5FH       ; 1F98 _ process_
        db 61H, 72H, 67H, 00H, 00H, 00H, 00H, 00H       ; 1FA0 _ arg.....

__func__.2:                                             ; byte
        db 61H, 73H, 73H, 65H, 6DH, 62H, 6CH, 65H       ; 1FA8 _ assemble
        db 5FH, 66H, 69H, 6CH, 65H, 00H, 00H, 00H       ; 1FB0 _ _file...
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 1FB8 _ ........

nl_indent.0:                                            ; byte
        db 0AH, 20H, 20H, 20H, 20H, 20H, 20H, 20H       ; 1FC0 _ .       
        db 20H, 20H, 20H, 20H, 20H, 20H, 20H, 20H       ; 1FC8 _         
        db 20H, 20H, 20H, 20H, 20H, 20H, 20H, 20H       ; 1FD0 _         
        db 20H, 20H, 20H, 20H, 20H, 00H                 ; 1FD8 _      .


SECTION .data.rel.ro.local align=32 noexec              ; section number 5, data

_pass_types:                                            ; byte
        dq ?_509                                        ; 0000 _ 0000000000000000 (d)
        dq ?_507+39H                                    ; 0008 _ 0000000000000000 (d)
        dq ?_507+46H                                    ; 0010 _ 0000000000000000 (d)
        dq ?_507+4CH                                    ; 0018 _ 0000000000000000 (d)
        dq ?_507+55H                                    ; 0020 _ 0000000000000000 (d)
        dq ?_507+5FH                                    ; 0028 _ 0000000000000000 (d)
        dq 0000000000000000H                            ; 0030 _ 0000000000000000 
        dq 0000000000000000H                            ; 0038 _ 0000000000000000 

limit_info:                                             ; byte
        dq ?_507+65H                                    ; 0040 _ 0000000000000000 (d)

?_637:                                                  ; byte
        dq ?_507+6CH                                    ; 0048 _ 0000000000000000 (d)
        dq 0000000000000000H                            ; 0050 _ 0000000000000000 
        dq 0000000000000000H                            ; 0058 _ 0000000000000000 
        dq ?_507+83H                                    ; 0060 _ 0000000000000000 (d)
        dq ?_507+98H                                    ; 0068 _ 0000000000000000 (d)
        dq 00000000000003E8H                            ; 0070 _ 00000000000003E8 
        dq 0000000000000000H                            ; 0078 _ 0000000000000000 
        dq ?_507+0C2H                                   ; 0080 _ 0000000000000000 (d)
        dq ?_507+0CFH                                   ; 0088 _ 0000000000000000 (d)
        dq 0000000000002710H                            ; 0090 _ 0000000000002710 
        dq 0000000000000000H                            ; 0098 _ 0000000000000000 
        dq ?_507+0E9H                                   ; 00A0 _ 0000000000000000 (d)
        dq ?_507+0F8H                                   ; 00A8 _ 0000000000000000 (d)
        dq 0000000000989680H                            ; 00B0 _ 0000000000989680 
        dq 0000000000000000H                            ; 00B8 _ 0000000000000000 
        dq ?_507+12CH                                   ; 00C0 _ 0000000000000000 (d)
        dq ?_507+138H                                   ; 00C8 _ 0000000000000000 (d)
        dq 00000000000186A0H                            ; 00D0 _ 00000000000186A0 
        dq 0000000000000000H                            ; 00D8 _ 0000000000000000 
        dq ?_507+15EH                                   ; 00E0 _ 0000000000000000 (d)
        dq ?_507+162H                                   ; 00E8 _ 0000000000000000 (d)
        dq 00000000000F4240H                            ; 00F0 _ 00000000000F4240 
        dq 0000000000000000H                            ; 00F8 _ 0000000000000000 
        dq ?_507+16DH                                   ; 0100 _ 0000000000000000 (d)
        dq ?_507+172H                                   ; 0108 _ 0000000000000000 (d)
        dq 0000000000002000H                            ; 0110 _ 0000000000002000 
        dq 0000000000000000H                            ; 0118 _ 0000000000000000 
        dq ?_507+190H                                   ; 0120 _ 0000000000000000 (d)
        dq ?_507+196H                                   ; 0128 _ 0000000000000000 (d)
        dq 0000000077359400H                            ; 0130 _ 0000000077359400 
        dq 0000000000000000H                            ; 0138 _ 0000000000000000 
        dq ?_507+1B3H                                   ; 0140 _ 0000000000000000 (d)
        dq ?_507+1C0H                                   ; 0148 _ 0000000000000000 (d)
        dq 0000000000003FFFH                            ; 0150 _ 0000000000003FFF 
        dq 000000003FFFFFFFH                            ; 0158 _ 000000003FFFFFFF 

textopts:                                               ; byte
        dq ?_507+4D2H                                   ; 0160 _ 0000000000000000 (d)
        dq 0000000000000001H                            ; 0168 _ 0000000000000001 
        dq 0000000000000000H                            ; 0170 _ 0000000000000000 
        dq ?_507+4D4H                                   ; 0178 _ 0000000000000000 (d)
        dq 0000000000000001H                            ; 0180 _ 0000000000000001 
        dq 0000000000000000H                            ; 0188 _ 0000000000000000 
        dq ?_552                                        ; 0190 _ 0000000000000000 (d)
        dq 0000000200000002H                            ; 0198 _ 0000000200000002 
        dq 0000000000000000H                            ; 01A0 _ 0000000000000000 
        dq ?_507+4E1H                                   ; 01A8 _ 0000000000000000 (d)
        dq 0000000000000003H                            ; 01B0 _ 0000000000000003 
        dq 0000000000000000H                            ; 01B8 _ 0000000000000000 
        dq ?_507+4F0H                                   ; 01C0 _ 0000000000000000 (d)
        dq 0000000100000004H                            ; 01C8 _ 0000000100000004 
        dq 0000000000000015H                            ; 01D0 _ 0000000000000015 
        dq ?_507+4F7H                                   ; 01D8 _ 0000000000000000 (d)
        dq 0000000100000004H                            ; 01E0 _ 0000000100000004 
        dq 0000000000000017H                            ; 01E8 _ 0000000000000017 
        dq ?_507+4FFH                                   ; 01F0 _ 0000000000000000 (d)
        dq 0000000100000004H                            ; 01F8 _ 0000000100000004 
        dq 0000000000000016H                            ; 0200 _ 0000000000000016 
        dq ?_507+506H                                   ; 0208 _ 0000000000000000 (d)
        dq 0000000100000004H                            ; 0210 _ 0000000100000004 
        dq 0000000000000018H                            ; 0218 _ 0000000000000018 
        dq ?_507+50EH                                   ; 0220 _ 0000000000000000 (d)
        dq 0000000100000004H                            ; 0228 _ 0000000100000004 
        dq 000000000000001AH                            ; 0230 _ 000000000000001A 
        dq ?_507+517H                                   ; 0238 _ 0000000000000000 (d)
        dq 0000000100000004H                            ; 0240 _ 0000000100000004 
        dq 0000000000000019H                            ; 0248 _ 0000000000000019 
        dq ?_507+51FH                                   ; 0250 _ 0000000000000000 (d)
        dq 0000000100000004H                            ; 0258 _ 0000000100000004 
        dq 000000000000001BH                            ; 0260 _ 000000000000001B 
        dq ?_507+527H                                   ; 0268 _ 0000000000000000 (d)
        dq 0000000100000004H                            ; 0270 _ 0000000100000004 
        dq 000000000000001DH                            ; 0278 _ 000000000000001D 
        dq ?_507+530H                                   ; 0280 _ 0000000000000000 (d)
        dq 0000000100000004H                            ; 0288 _ 0000000100000004 
        dq 000000000000001CH                            ; 0290 _ 000000000000001C 
        dq ?_507+538H                                   ; 0298 _ 0000000000000000 (d)
        dq 0000000100000005H                            ; 02A0 _ 0000000100000005 
        dq 0000000000000000H                            ; 02A8 _ 0000000000000000 
        dq ?_507+540H                                   ; 02B0 _ 0000000000000000 (d)
        dq 0000000100000006H                            ; 02B8 _ 0000000100000006 
        dq 0000000000000000H                            ; 02C0 _ 0000000000000000 
        dq ?_507+547H                                   ; 02C8 _ 0000000000000000 (d)
        dq 0000000100000007H                            ; 02D0 _ 0000000100000007 
        dq 0000000000000000H                            ; 02D8 _ 0000000000000000 
        dq ?_507+54EH                                   ; 02E0 _ 0000000000000000 (d)
        dq 0000000100000008H                            ; 02E8 _ 0000000100000008 
        dq 0000000000000000H                            ; 02F0 _ 0000000000000000 
        dq ?_507+555H                                   ; 02F8 _ 0000000000000000 (d)
        dq 0000000000000009H                            ; 0300 _ 0000000000000009 
        dq 0000000000000000H                            ; 0308 _ 0000000000000000 
        dq ?_507+55EH                                   ; 0310 _ 0000000000000000 (d)
        dq 000000000000000AH                            ; 0318 _ 000000000000000A 
        dq 0000000000000000H                            ; 0320 _ 0000000000000000 
        dq ?_507+566H                                   ; 0328 _ 0000000000000000 (d)
        dq 000000020000000CH                            ; 0330 _ 000000020000000C 
        dq 0000000000000000H                            ; 0338 _ 0000000000000000 
        dq ?_507+56BH                                   ; 0340 _ 0000000000000000 (d)
        dq 000000020000000CH                            ; 0348 _ 000000020000000C 
        dq 0000000000000000H                            ; 0350 _ 0000000000000000 
        dq ?_507+573H                                   ; 0358 _ 0000000000000000 (d)
        dq 000000020000000BH                            ; 0360 _ 000000020000000B 
        dq 0000000000000000H                            ; 0368 _ 0000000000000000 
        dq ?_507+579H                                   ; 0370 _ 0000000000000000 (d)
        dq 000000000000000DH                            ; 0378 _ 000000000000000D 
        dq 0000000000000000H                            ; 0380 _ 0000000000000000 
        dq ?_507+586H                                   ; 0388 _ 0000000000000000 (d)
        dq 000000010000000EH                            ; 0390 _ 000000010000000E 
        dq 0000000000000000H                            ; 0398 _ 0000000000000000 
        dq ?_507+58BH                                   ; 03A0 _ 0000000000000000 (d)
        dq 000000010000000FH                            ; 03A8 _ 000000010000000F 
        dq 0000000000000000H                            ; 03B0 _ 0000000000000000 
        dq 0000000000000000H                            ; 03B8 _ 0000000000000000 
        dq 0000000000000000H                            ; 03C0 _ 0000000000000000 
        dq 0000000000000000H                            ; 03C8 _ 0000000000000000 


SECTION .data.rel align=8 noexec                        ; section number 6, data

ofmt:   dq of_bin                                       ; 0000 _ 0000000000000000 (d)


SECTION .data.rel.local align=8 noexec                  ; section number 7, data

quote_for_make:                                         ; virtual table or function pointer
        dq quote_for_pmake                              ; 0000 _ 0000000000000000 (d)


SECTION .note.gnu.property align=8 noexec               ; section number 8, const

        db 04H, 00H, 00H, 00H, 20H, 00H, 00H, 00H       ; 0000 _ .... ...
        db 05H, 00H, 00H, 00H, 47H, 4EH, 55H, 00H       ; 0008 _ ....GNU.
        db 02H, 00H, 01H, 0C0H, 04H, 00H, 00H, 00H      ; 0010 _ ........
        db 01H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0018 _ ........
        db 01H, 00H, 01H, 0C0H, 04H, 00H, 00H, 00H      ; 0020 _ ........
        db 01H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0028 _ ........


SECTION .eh_frame align=8 noexec                        ; section number 9, const

        db 14H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0000 _ ........
        db 01H, 7AH, 52H, 00H, 01H, 78H, 10H, 01H       ; 0008 _ .zR..x..
        db 1BH, 0CH, 07H, 08H, 90H, 01H, 00H, 00H       ; 0010 _ ........
        db 1CH, 00H, 00H, 00H, 1CH, 00H, 00H, 00H       ; 0018 _ ........
        dd mempset-$-20H                                ; 0020 _ 00000000 (rel)
        dd 00000031H, 100E4100H                         ; 0024 _ 49 269369600 
        dd 0D430286H, 070C6C06H                         ; 002C _ 222495366 118254598 
        dd 00000008H, 0000001CH                         ; 0034 _ 8 28 
        dd 0000003CH                                    ; 003C _ 60 
        dd mempset-$-0FH                                ; 0040 _ 00000000 (rel)
        dd 0000004FH, 100E4100H                         ; 0044 _ 79 269369600 
        dd 0D430286H, 0C4A0206H                         ; 004C _ 222495366 206176774 
        dd 00000807H, 0000001CH                         ; 0054 _ 2055 28 
        dd 0000005CH                                    ; 005C _ 92 
        dd mempset-$+20H                                ; 0060 _ 00000000 (rel)
        dd 0000002DH, 100E4100H                         ; 0064 _ 45 269369600 
        dd 0D430286H, 070C6806H                         ; 006C _ 222495366 118253574 
        dd 00000008H, 0000001CH                         ; 0074 _ 8 28 
        dd 0000007CH                                    ; 007C _ 124 
        dd mempset-$+2DH                                ; 0080 _ 00000000 (rel)
        dd 00000021H, 100E4100H                         ; 0084 _ 33 269369600 
        dd 0D430286H, 070C5C06H                         ; 008C _ 222495366 118250502 
        dd 00000008H, 0000001CH                         ; 0094 _ 8 28 
        dd 0000009CH                                    ; 009C _ 156 
        dd mempset-$+2EH                                ; 00A0 _ 00000000 (rel)
        dd 00000021H, 100E4100H                         ; 00A4 _ 33 269369600 
        dd 0D430286H, 070C5C06H                         ; 00AC _ 222495366 118250502 
        dd 00000008H, 0000001CH                         ; 00B4 _ 8 28 
        dd 000000BCH                                    ; 00BC _ 188 
        dd mempset-$+2FH                                ; 00C0 _ 00000000 (rel)
        dd 00000007H, 100E4100H                         ; 00C4 _ 7 269369600 
        dd 0D430286H, 070C4206H                         ; 00CC _ 222495366 118243846 
        dd 00000008H, 0000001CH                         ; 00D4 _ 8 28 
        dd 000000DCH                                    ; 00DC _ 220 
        dd mempset-$+16H                                ; 00E0 _ 00000000 (rel)
        dd 00000020H, 100E4100H                         ; 00E4 _ 32 269369600 
        dd 0D430286H, 070C5B06H                         ; 00EC _ 222495366 118250246 
        dd 00000008H, 0000001CH                         ; 00F4 _ 8 28 
        dd 000000FCH                                    ; 00FC _ 252 
        dd mempset-$+16H                                ; 0100 _ 00000000 (rel)
        dd 00000014H, 100E4100H                         ; 0104 _ 20 269369600 
        dd 0D430286H, 070C4F06H                         ; 010C _ 222495366 118247174 
        dd 00000008H, 0000001CH                         ; 0114 _ 8 28 
        dd 0000011CH                                    ; 011C _ 284 
        dd mempset-$+0AH                                ; 0120 _ 00000000 (rel)
        dd 00000033H, 100E4100H                         ; 0124 _ 51 269369600 
        dd 0D430286H, 070C6E06H                         ; 012C _ 222495366 118255110 
        dd 00000008H, 0000001CH                         ; 0134 _ 8 28 
        dd 0000013CH                                    ; 013C _ 316 
        dd mempset-$+1DH                                ; 0140 _ 00000000 (rel)
        dd 0000001EH, 100E4100H                         ; 0144 _ 30 269369600 
        dd 0D430286H, 070C5906H                         ; 014C _ 222495366 118249734 
        dd 00000008H, 0000001CH                         ; 0154 _ 8 28 
        dd 0000015CH                                    ; 015C _ 348 
        dd mempset-$+1BH                                ; 0160 _ 00000000 (rel)
        dd 0000000CH, 100E4100H                         ; 0164 _ 12 269369600 
        dd 0D430286H, 070C4706H                         ; 016C _ 222495366 118245126 
        dd 00000008H, 0000001CH                         ; 0174 _ 8 28 
        dd 0000017CH                                    ; 017C _ 380 
        dd mempset-$+7H                                 ; 0180 _ 00000000 (rel)
        dd 00000010H, 100E4100H                         ; 0184 _ 16 269369600 
        dd 0D430286H, 070C4B06H                         ; 018C _ 222495366 118246150 
        dd 00000008H, 0000001CH                         ; 0194 _ 8 28 
        dd 0000019CH                                    ; 019C _ 412 
        dd mempset-$-9H                                 ; 01A0 _ 00000000 (rel)
        dd 00000011H, 100E4100H                         ; 01A4 _ 17 269369600 
        dd 0D430286H, 070C4C06H                         ; 01AC _ 222495366 118246406 
        dd 00000008H, 0000001CH                         ; 01B4 _ 8 28 
        dd 000001BCH                                    ; 01BC _ 444 
        dd mempset-$-18H                                ; 01C0 _ 00000000 (rel)
        dd 00000011H, 100E4100H                         ; 01C4 _ 17 269369600 
        dd 0D430286H, 070C4C06H                         ; 01CC _ 222495366 118246406 
        dd 00000008H, 0000001CH                         ; 01D4 _ 8 28 
        dd 000001DCH                                    ; 01DC _ 476 
        dd mempset-$-27H                                ; 01E0 _ 00000000 (rel)
        dd 0000000DH, 100E4100H                         ; 01E4 _ 13 269369600 
        dd 0D430286H, 070C4806H                         ; 01EC _ 222495366 118245382 
        dd 00000008H, 0000001CH                         ; 01F4 _ 8 28 
        dd 000001FCH                                    ; 01FC _ 508 
        dd mempset-$-3AH                                ; 0200 _ 00000000 (rel)
        dd 00000016H, 100E4100H                         ; 0204 _ 22 269369600 
        dd 0D430286H, 070C5106H                         ; 020C _ 222495366 118247686 
        dd 00000008H, 0000001CH                         ; 0214 _ 8 28 
        dd 0000021CH                                    ; 021C _ 540 
        dd mempset-$-44H                                ; 0220 _ 00000000 (rel)
        dd 0000002CH, 100E4100H                         ; 0224 _ 44 269369600 
        dd 0D430286H, 070C6706H                         ; 022C _ 222495366 118253318 
        dd 00000008H, 0000001CH                         ; 0234 _ 8 28 
        dd 0000023CH                                    ; 023C _ 572 
        dd mempset-$-38H                                ; 0240 _ 00000000 (rel)
        dd 0000006DH, 100E4100H                         ; 0244 _ 109 269369600 
        dd 0D430286H, 0C680206H                         ; 024C _ 222495366 208142854 
        dd 00000807H, 0000001CH                         ; 0254 _ 2055 28 
        dd 0000025CH                                    ; 025C _ 604 
        dd mempset-$+15H                                ; 0260 _ 00000000 (rel)
        dd 00000040H, 100E4100H                         ; 0264 _ 64 269369600 
        dd 0D430286H, 070C7B06H                         ; 026C _ 222495366 118258438 
        dd 00000008H, 0000001CH                         ; 0274 _ 8 28 
        dd 0000027CH                                    ; 027C _ 636 
        dd mempset-$+35H                                ; 0280 _ 00000000 (rel)
        dd 00000010H, 100E4100H                         ; 0284 _ 16 269369600 
        dd 0D430286H, 070C4B06H                         ; 028C _ 222495366 118246150 
        dd 00000008H, 0000001CH                         ; 0294 _ 8 28 
        dd 0000029CH                                    ; 029C _ 668 
        dd mempset-$+25H                                ; 02A0 _ 00000000 (rel)
        dd 00000054H, 100E4100H                         ; 02A4 _ 84 269369600 
        dd 0D430286H, 0C4F0206H                         ; 02AC _ 222495366 206504454 
        dd 00000807H, 0000001CH                         ; 02B4 _ 2055 28 
        dd 000002BCH                                    ; 02BC _ 700 
        dd ?_001-$+2C0H                                 ; 02C0 _ 00000000 (rel)
        dd 00000012H, 100E4100H                         ; 02C4 _ 18 269369600 
        dd 0D430286H, 070C4D06H                         ; 02CC _ 222495366 118246662 
        dd 00000008H, 0000001CH                         ; 02D4 _ 8 28 
        dd 000002DCH                                    ; 02DC _ 732 
        dd mempset-$+4BH                                ; 02E0 _ 00000000 (rel)
        dd 00000086H, 100E4100H                         ; 02E4 _ 134 269369600 
        dd 0D430286H, 0C810206H                         ; 02EC _ 222495366 209781254 
        dd 00000807H, 0000001CH                         ; 02F4 _ 2055 28 
        dd 000002FCH                                    ; 02FC _ 764 
        dd mempset-$+0B1H                               ; 0300 _ 00000000 (rel)
        dd 00000063H, 100E4100H                         ; 0304 _ 99 269369600 
        dd 0D430286H, 0C5E0206H                         ; 030C _ 222495366 207487494 
        dd 00000807H, 0000001CH                         ; 0314 _ 2055 28 
        dd 0000031CH                                    ; 031C _ 796 
        dd mempset-$+0F4H                               ; 0320 _ 00000000 (rel)
        dd 00000052H, 100E4100H                         ; 0324 _ 82 269369600 
        dd 0D430286H, 0C4D0206H                         ; 032C _ 222495366 206373382 
        dd 00000807H, 0000001CH                         ; 0334 _ 2055 28 
        dd 0000033CH                                    ; 033C _ 828 
        dd mempset-$+126H                               ; 0340 _ 00000000 (rel)
        dd 0000006EH, 100E4100H                         ; 0344 _ 110 269369600 
        dd 0D430286H, 0C690206H                         ; 034C _ 222495366 208208390 
        dd 00000807H, 0000001CH                         ; 0354 _ 2055 28 
        dd 0000035CH                                    ; 035C _ 860 
        dd mempset-$+174H                               ; 0360 _ 00000000 (rel)
        dd 000002DEH, 100E4100H                         ; 0364 _ 734 269369600 
        dd 0D430286H, 02D90306H                         ; 036C _ 222495366 47776518 
        dd 0008070CH, 0000001CH                         ; 0374 _ 526092 28 
        dd 0000037CH                                    ; 037C _ 892 
        dd mempset-$+432H                               ; 0380 _ 00000000 (rel)
        dd 000000D3H, 100E4100H                         ; 0384 _ 211 269369600 
        dd 0D430286H, 0CCE0206H                         ; 038C _ 222495366 214827526 
        dd 00000807H, 0000001CH                         ; 0394 _ 2055 28 
        dd 0000039CH                                    ; 039C _ 924 
        dd mempset-$+4E5H                               ; 03A0 _ 00000000 (rel)
        dd 0000002BH, 100E4100H                         ; 03A4 _ 43 269369600 
        dd 0D430286H, 070C6606H                         ; 03AC _ 222495366 118253062 
        dd 00000008H, 0000001CH                         ; 03B4 _ 8 28 
        dd 000003BCH                                    ; 03BC _ 956 
        dd mempset-$+4F0H                               ; 03C0 _ 00000000 (rel)
        dd 00000085H, 100E4100H                         ; 03C4 _ 133 269369600 
        dd 0D430286H, 0C800206H                         ; 03CC _ 222495366 209715718 
        dd 00000807H, 0000001CH                         ; 03D4 _ 2055 28 
        dd 000003DCH                                    ; 03DC _ 988 
        dd mempset-$+555H                               ; 03E0 _ 00000000 (rel)
        dd 00000060H, 100E4100H                         ; 03E4 _ 96 269369600 
        dd 0D430286H, 0C5B0206H                         ; 03EC _ 222495366 207290886 
        dd 00000807H, 0000001CH                         ; 03F4 _ 2055 28 
        dd 000003FCH                                    ; 03FC _ 1020 
        dd mempset-$+595H                               ; 0400 _ 00000000 (rel)
        dd 0000005BH, 100E4100H                         ; 0404 _ 91 269369600 
        dd 0D430286H, 0C560206H                         ; 040C _ 222495366 206963206 
        dd 00000807H, 0000001CH                         ; 0414 _ 2055 28 
        dd 0000041CH                                    ; 041C _ 1052 
        dd mempset-$+5D0H                               ; 0420 _ 00000000 (rel)
        dd 00000042H, 100E4100H                         ; 0424 _ 66 269369600 
        dd 0D430286H, 070C7D06H                         ; 042C _ 222495366 118258950 
        dd 00000008H, 0000001CH                         ; 0434 _ 8 28 
        dd 0000043CH                                    ; 043C _ 1084 
        dd mempset-$+5F2H                               ; 0440 _ 00000000 (rel)
        dd 00000301H, 100E4100H                         ; 0444 _ 769 269369600 
        dd 0D430286H, 02FC0306H                         ; 044C _ 222495366 50070278 
        dd 0008070CH, 0000001CH                         ; 0454 _ 526092 28 
        dd 0000045CH                                    ; 045C _ 1116 
        dd mempset-$+8D3H                               ; 0460 _ 00000000 (rel)
        dd 0000002DH, 100E4100H                         ; 0464 _ 45 269369600 
        dd 0D430286H, 070C6806H                         ; 046C _ 222495366 118253574 
        dd 00000008H, 0000001CH                         ; 0474 _ 8 28 
        dd 0000047CH                                    ; 047C _ 1148 
        dd mempset-$+8E0H                               ; 0480 _ 00000000 (rel)
        dd 0000027AH, 100E4100H                         ; 0484 _ 634 269369600 
        dd 0D430286H, 02750306H                         ; 048C _ 222495366 41222918 
        dd 0008070CH, 0000001CH                         ; 0494 _ 526092 28 
        dd 0000049CH                                    ; 049C _ 1180 
        dd mempset-$+0B3AH                              ; 04A0 _ 00000000 (rel)
        dd 0000010AH, 100E4100H                         ; 04A4 _ 266 269369600 
        dd 0D430286H, 01050306H                         ; 04AC _ 222495366 17105670 
        dd 0008070CH, 0000001CH                         ; 04B4 _ 526092 28 
        dd 000004BCH                                    ; 04BC _ 1212 
        dd mempset-$+0C24H                              ; 04C0 _ 00000000 (rel)
        dd 0000011AH, 100E4100H                         ; 04C4 _ 282 269369600 
        dd 0D430286H, 01150306H                         ; 04CC _ 222495366 18154246 
        dd 0008070CH, 00000020H                         ; 04D4 _ 526092 32 
        dd 000004DCH                                    ; 04DC _ 1244 
        dd mempset-$+0D1EH                              ; 04E0 _ 00000000 (rel)
        dd 000001C8H, 100E4100H                         ; 04E4 _ 456 269369600 
        dd 0D430286H, 03834506H                         ; 04EC _ 222495366 58934534 
        dd 0C01BE03H, 00000807H                         ; 04F4 _ 201440771 2055 
        dd 0000001CH, 00000500H                         ; 04FC _ 28 1280 
        dd mempset-$+0EC2H                              ; 0504 _ 00000000 (rel)
        dd 00000102H, 100E4100H                         ; 0508 _ 258 269369600 
        dd 0D430286H, 0CFD0206H                         ; 0510 _ 222495366 217907718 
        dd 00000807H, 0000001CH                         ; 0518 _ 2055 28 
        dd 00000520H                                    ; 0520 _ 1312 
        dd mempset-$+0FA4H                              ; 0524 _ 00000000 (rel)
        dd 000000C5H, 100E4100H                         ; 0528 _ 197 269369600 
        dd 0D430286H, 0CC00206H                         ; 0530 _ 222495366 213910022 
        dd 00000807H, 00000020H                         ; 0538 _ 2055 32 
        dd 00000540H                                    ; 0540 _ 1344 
        dd mempset-$+1049H                              ; 0544 _ 00000000 (rel)
        dd 000007D2H, 100E4100H                         ; 0548 _ 2002 269369600 
        dd 0D430286H, 038C4706H                         ; 0550 _ 222495366 59524870 
        dd 0C6030483H, 08070C07H                        ; 0558 _ -972880765 134679559 
        dd 0000001CH, 00000564H                         ; 0560 _ 28 1380 
        dd mempset-$+17F7H                              ; 0568 _ 00000000 (rel)
        dd 00000062H, 100E4100H                         ; 056C _ 98 269369600 
        dd 0D430286H, 0C5D0206H                         ; 0574 _ 222495366 207421958 
        dd 00000807H, 0000001CH                         ; 057C _ 2055 28 
        dd 00000584H                                    ; 0584 _ 1412 
        dd mempset-$+1839H                              ; 0588 _ 00000000 (rel)
        dd 00000065H, 100E4100H                         ; 058C _ 101 269369600 
        dd 0D430286H, 0C600206H                         ; 0594 _ 222495366 207618566 
        dd 00000807H, 0000001CH                         ; 059C _ 2055 28 
        dd 000005A4H                                    ; 05A4 _ 1444 
        dd mempset-$+187EH                              ; 05A8 _ 00000000 (rel)
        dd 0000010DH, 100E4100H                         ; 05AC _ 269 269369600 
        dd 0D430286H, 01080306H                         ; 05B4 _ 222495366 17302278 
        dd 0008070CH, 0000001CH                         ; 05BC _ 526092 28 
        dd 000005C4H                                    ; 05C4 _ 1476 
        dd mempset-$+196BH                              ; 05C8 _ 00000000 (rel)
        dd 00000254H, 100E4100H                         ; 05CC _ 596 269369600 
        dd 0D430286H, 024F0306H                         ; 05D4 _ 222495366 38732550 
        dd 0008070CH, 0000001CH                         ; 05DC _ 526092 28 
        dd 000005E4H                                    ; 05E4 _ 1508 
        dd mempset-$+1B9FH                              ; 05E8 _ 00000000 (rel)
        dd 00000197H, 100E4100H                         ; 05EC _ 407 269369600 
        dd 0D430286H, 01920306H                         ; 05F4 _ 222495366 26346246 
        dd 0008070CH, 00000018H                         ; 05FC _ 526092 24 
        dd 00000604H                                    ; 0604 _ 1540 
        dd mempset-$+1D16H                              ; 0608 _ 00000000 (rel)
        dd 00000037H, 100E4100H                         ; 060C _ 55 269369600 
        dd 0D430286H, 00000006H                         ; 0614 _ 222495366 6 
        dd 0000001CH, 00000620H                         ; 061C _ 28 1568 
        dd mempset-$+1D31H                              ; 0624 _ 00000000 (rel)
        dd 00001004H, 100E4100H                         ; 0628 _ 4100 269369600 
        dd 0D430286H, 0FFF0306H                         ; 0630 _ 222495366 268370694 
        dd 0008070CH, 00000020H                         ; 0638 _ 526092 32 
        dd 00000640H                                    ; 0640 _ 1600 
        dd mempset-$+2D15H                              ; 0644 _ 00000000 (rel)
        dd 0000022AH, 100E4100H                         ; 0648 _ 554 269369600 
        dd 0D430286H, 03834506H                         ; 0650 _ 222495366 58934534 
        dd 0C022003H, 00000807H                         ; 0658 _ 201465859 2055 
        dd 0000001CH, 00000664H                         ; 0660 _ 28 1636 
        dd mempset-$+2F1BH                              ; 0668 _ 00000000 (rel)
        dd 000000EBH, 100E4100H                         ; 066C _ 235 269369600 
        dd 0D430286H, 0CE60206H                         ; 0674 _ 222495366 216400390 
        dd 00000807H, 0000001CH                         ; 067C _ 2055 28 
        dd 00000684H                                    ; 0684 _ 1668 
        dd mempset-$+2FE6H                              ; 0688 _ 00000000 (rel)
        dd 000000C2H, 100E4100H                         ; 068C _ 194 269369600 
        dd 0D430286H, 0CBD0206H                         ; 0694 _ 222495366 213713414 
        dd 00000807H, 0000001CH                         ; 069C _ 2055 28 
        dd 000006A4H                                    ; 06A4 _ 1700 
        dd mempset-$+3088H                              ; 06A8 _ 00000000 (rel)
        dd 0000006CH, 100E4100H                         ; 06AC _ 108 269369600 
        dd 0D430286H, 0C670206H                         ; 06B4 _ 222495366 208077318 
        dd 00000807H, 0000001CH                         ; 06BC _ 2055 28 
        dd 000006C4H                                    ; 06C4 _ 1732 
        dd mempset-$+30D4H                              ; 06C8 _ 00000000 (rel)
        dd 0000008FH, 100E4100H                         ; 06CC _ 143 269369600 
        dd 0D430286H, 0C8A0206H                         ; 06D4 _ 222495366 210371078 
        dd 00000807H, 0000001CH                         ; 06DC _ 2055 28 
        dd 000006E4H                                    ; 06E4 _ 1764 
        dd mempset-$+3143H                              ; 06E8 _ 00000000 (rel)
        dd 000001CCH, 100E4100H                         ; 06EC _ 460 269369600 
        dd 0D430286H, 01C70306H                         ; 06F4 _ 222495366 29819654 
        dd 0008070CH, 0000001CH                         ; 06FC _ 526092 28 
        dd 00000704H                                    ; 0704 _ 1796 
        dd ?_301-$+708H                                 ; 0708 _ 00000000 (rel)
        dd 00000171H, 100E4100H                         ; 070C _ 369 269369600 
        dd 0D430286H, 016C0306H                         ; 0714 _ 222495366 23855878 
        dd 0008070CH, 0000001CH                         ; 071C _ 526092 28 
        dd 00000724H                                    ; 0724 _ 1828 
        dd mempset-$+3440H                              ; 0728 _ 00000000 (rel)
        dd 000000AAH, 100E4100H                         ; 072C _ 170 269369600 
        dd 0D430286H, 0CA50206H                         ; 0734 _ 222495366 212140550 
        dd 00000807H, 00000020H                         ; 073C _ 2055 32 
        dd 00000744H                                    ; 0744 _ 1860 
        dd mempset-$+34CAH                              ; 0748 _ 00000000 (rel)
        dd 0000059DH, 100E4100H                         ; 074C _ 1437 269369600 
        dd 0D430286H, 03834806H                         ; 0754 _ 222495366 58935302 
        dd 0C059003H, 00000807H                         ; 075C _ 201691139 2055 
        dd 0000001CH, 00000768H                         ; 0764 _ 28 1896 
        dd mempset-$+3A43H                              ; 076C _ 00000000 (rel)
        dd 000000AAH, 100E4100H                         ; 0770 _ 170 269369600 
        dd 0D430286H, 0CA50206H                         ; 0778 _ 222495366 212140550 
        dd 00000807H, 0000001CH                         ; 0780 _ 2055 28 
        dd 00000788H                                    ; 0788 _ 1928 
        dd mempset-$+3ACDH                              ; 078C _ 00000000 (rel)
        dd 00000029H, 100E4100H                         ; 0790 _ 41 269369600 
        dd 0D430286H, 070C6406H                         ; 0798 _ 222495366 118252550 
        dd 00000008H, 0000001CH                         ; 07A0 _ 8 28 
        dd 000007A8H                                    ; 07A8 _ 1960 
        dd mempset-$+3AD6H                              ; 07AC _ 00000000 (rel)
        dd 0000001CH, 100E4100H                         ; 07B0 _ 28 269369600 
        dd 0D430286H, 070C5706H                         ; 07B8 _ 222495366 118249222 
        dd 00000008H, 0000001CH                         ; 07C0 _ 8 28 
        dd 000007C8H                                    ; 07C8 _ 1992 
        dd mempset-$+3AD2H                              ; 07CC _ 00000000 (rel)
        dd 00000035H, 100E4100H                         ; 07D0 _ 53 269369600 
        dd 0D430286H, 070C7006H                         ; 07D8 _ 222495366 118255622 
        dd 00000008H, 00000020H                         ; 07E0 _ 8 32 
        dd 000007E8H                                    ; 07E8 _ 2024 
        dd mempset-$+3AE7H                              ; 07EC _ 00000000 (rel)
        dd 00000B74H, 100E4100H                         ; 07F0 _ 2932 269369600 
        dd 0D430286H, 038C4706H                         ; 07F8 _ 222495366 59524870 
        dd 68030483H, 08070C0BH                         ; 0800 _ 1745028227 134679563 


