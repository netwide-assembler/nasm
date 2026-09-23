; Disassembly of file: /tmp/tmp.2hOjG0TxDk.o
; Wed Sep 23 14:43:22 2026
; Type: ELF64
; Syntax: NASM
; Instruction set: Pentium Pro, x64

default rel

global process_insn: function

extern increment_offset                                 ; near
extern location                                         ; qword
extern snprintf                                         ; near
extern nasm_fatal                                       ; near
extern nasm_instructions                                ; byte
extern is_hint_nop                                      ; near
extern globl                                            ; dword
extern nasm_panic                                       ; near
extern nasm_regvals                                     ; byte
extern optimizing                                       ; dword
extern nasm_nonfatalf                                   ; near
extern nasm_error_hold_pop                              ; near
extern nasm_error_hold_push                             ; near
extern memcpy                                           ; near
extern nasm_file_size_by_path                           ; near
extern define_label                                     ; near
extern cpu                                              ; byte
extern fclose                                           ; near
extern nasm_unmap_file                                  ; near
extern feof                                             ; near
extern fread                                            ; near
extern ferror                                           ; near
extern fseeko                                           ; near
extern nasm_malloc                                      ; near
extern nasm_map_file                                    ; near
extern nasm_file_size                                   ; near
extern nasm_open_read                                   ; near
extern memset                                           ; near
extern nasm_free                                        ; near
extern nasm_asprintf                                    ; near
extern nasm_insn_names                                  ; byte
extern nasm_holderr                                     ; near
extern __stack_chk_fail                                 ; near
extern debug_current_macro                              ; qword
extern lfmt                                             ; qword
extern dfmt                                             ; qword
extern nasm_assert_failed                               ; near
extern ofmt                                             ; qword
extern zero_buffer                                      ; byte
extern nasm_panic_from_macro                            ; near
extern debug_macro_get_addr                             ; near
extern nasm_warn_                                       ; near
extern nasm_nonfatal                                    ; near
extern prefix_name                                      ; near
extern active_list_options                              ; qword
extern insns_flags                                      ; byte
extern _pass_type                                       ; dword
extern warning_state                                    ; byte
extern erropt                                           ; dword
extern _src_bottom                                      ; qword
extern nasm_reg_flags                                   ; byte


SECTION .text   align=1 exec                            ; section number 1, code

__uint32_identity:; Local function
        push    rbp                                     ; 0000 _ 55
        mov     rbp, rsp                                ; 0001 _ 48: 89. E5
        mov     dword [rbp-4H], edi                     ; 0004 _ 89. 7D, FC
        mov     eax, dword [rbp-4H]                     ; 0007 _ 8B. 45, FC
        pop     rbp                                     ; 000A _ 5D
        ret                                             ; 000B _ C3

__uint64_identity:; Local function
        push    rbp                                     ; 000C _ 55
        mov     rbp, rsp                                ; 000D _ 48: 89. E5
        mov     qword [rbp-8H], rdi                     ; 0010 _ 48: 89. 7D, F8
        mov     rax, qword [rbp-8H]                     ; 0014 _ 48: 8B. 45, F8
        pop     rbp                                     ; 0018 _ 5D
        ret                                             ; 0019 _ C3

sext:   ; Local function
        push    rbp                                     ; 001A _ 55
        mov     rbp, rsp                                ; 001B _ 48: 89. E5
        mov     qword [rbp-8H], rdi                     ; 001E _ 48: 89. 7D, F8
        mov     dword [rbp-0CH], esi                    ; 0022 _ 89. 75, F4
        cmp     dword [rbp-0CH], 63                     ; 0025 _ 83. 7D, F4, 3F
        jbe     ?_0001                                  ; 0029 _ 76, 06
        mov     rax, qword [rbp-8H]                     ; 002B _ 48: 8B. 45, F8
        jmp     ?_0004                                  ; 002F _ EB, 31

?_0001: cmp     dword [rbp-0CH], 0                      ; 0031 _ 83. 7D, F4, 00
        jz      ?_0002                                  ; 0035 _ 74, 0D
        mov     eax, 64                                 ; 0037 _ B8, 00000040
        sub     eax, dword [rbp-0CH]                    ; 003C _ 2B. 45, F4
        mov     dword [rbp-0CH], eax                    ; 003F _ 89. 45, F4
        jmp     ?_0003                                  ; 0042 _ EB, 07

?_0002: mov     dword [rbp-0CH], 63                     ; 0044 _ C7. 45, F4, 0000003F
?_0003: mov     eax, dword [rbp-0CH]                    ; 004B _ 8B. 45, F4
        mov     rdx, qword [rbp-8H]                     ; 004E _ 48: 8B. 55, F8
        mov     ecx, eax                                ; 0052 _ 89. C1
        shl     rdx, cl                                 ; 0054 _ 48: D3. E2
        mov     eax, dword [rbp-0CH]                    ; 0057 _ 8B. 45, F4
        mov     ecx, eax                                ; 005A _ 89. C1
        sar     rdx, cl                                 ; 005C _ 48: D3. FA
        mov     rax, rdx                                ; 005F _ 48: 89. D0
?_0004: pop     rbp                                     ; 0062 _ 5D
        ret                                             ; 0063 _ C3

zext:   ; Local function
        push    rbp                                     ; 0064 _ 55
        mov     rbp, rsp                                ; 0065 _ 48: 89. E5
        mov     qword [rbp-8H], rdi                     ; 0068 _ 48: 89. 7D, F8
        mov     dword [rbp-0CH], esi                    ; 006C _ 89. 75, F4
        cmp     dword [rbp-0CH], 63                     ; 006F _ 83. 7D, F4, 3F
        jbe     ?_0005                                  ; 0073 _ 76, 06
        mov     rax, qword [rbp-8H]                     ; 0075 _ 48: 8B. 45, F8
        jmp     ?_0007                                  ; 0079 _ EB, 2F

?_0005: cmp     dword [rbp-0CH], 0                      ; 007B _ 83. 7D, F4, 00
        jnz     ?_0006                                  ; 007F _ 75, 07
        mov     eax, 0                                  ; 0081 _ B8, 00000000
        jmp     ?_0007                                  ; 0086 _ EB, 22

?_0006: mov     eax, 64                                 ; 0088 _ B8, 00000040
        sub     eax, dword [rbp-0CH]                    ; 008D _ 2B. 45, F4
        mov     dword [rbp-0CH], eax                    ; 0090 _ 89. 45, F4
        mov     eax, dword [rbp-0CH]                    ; 0093 _ 8B. 45, F4
        mov     rdx, qword [rbp-8H]                     ; 0096 _ 48: 8B. 55, F8
        mov     ecx, eax                                ; 009A _ 89. C1
        shl     rdx, cl                                 ; 009C _ 48: D3. E2
        mov     eax, dword [rbp-0CH]                    ; 009F _ 8B. 45, F4
        mov     ecx, eax                                ; 00A2 _ 89. C1
        shr     rdx, cl                                 ; 00A4 _ 48: D3. EA
        mov     rax, rdx                                ; 00A7 _ 48: 89. D0
?_0007: pop     rbp                                     ; 00AA _ 5D
        ret                                             ; 00AB _ C3

overflow_signed:; Local function
        push    rbp                                     ; 00AC _ 55
        mov     rbp, rsp                                ; 00AD _ 48: 89. E5
        sub     rsp, 16                                 ; 00B0 _ 48: 83. EC, 10
        mov     qword [rbp-8H], rdi                     ; 00B4 _ 48: 89. 7D, F8
        mov     dword [rbp-0CH], esi                    ; 00B8 _ 89. 75, F4
        mov     eax, dword [rbp-0CH]                    ; 00BB _ 8B. 45, F4
        lea     edx, [rax*8]                            ; 00BE _ 8D. 14 C5, 00000000
        mov     rax, qword [rbp-8H]                     ; 00C5 _ 48: 8B. 45, F8
        mov     esi, edx                                ; 00C9 _ 89. D6
        mov     rdi, rax                                ; 00CB _ 48: 89. C7
        call    sext                                    ; 00CE _ E8, FFFFFF47
        cmp     qword [rbp-8H], rax                     ; 00D3 _ 48: 39. 45, F8
        setne   al                                      ; 00D7 _ 0F 95. C0
        leave                                           ; 00DA _ C9
        ret                                             ; 00DB _ C3

overflow_unsigned:; Local function
        push    rbp                                     ; 00DC _ 55
        mov     rbp, rsp                                ; 00DD _ 48: 89. E5
        sub     rsp, 16                                 ; 00E0 _ 48: 83. EC, 10
        mov     qword [rbp-8H], rdi                     ; 00E4 _ 48: 89. 7D, F8
        mov     dword [rbp-0CH], esi                    ; 00E8 _ 89. 75, F4
        mov     eax, dword [rbp-0CH]                    ; 00EB _ 8B. 45, F4
        lea     edx, [rax*8]                            ; 00EE _ 8D. 14 C5, 00000000
        mov     rax, qword [rbp-8H]                     ; 00F5 _ 48: 8B. 45, F8
        mov     esi, edx                                ; 00F9 _ 89. D6
        mov     rdi, rax                                ; 00FB _ 48: 89. C7
        call    zext                                    ; 00FE _ E8, FFFFFF61
        cmp     qword [rbp-8H], rax                     ; 0103 _ 48: 39. 45, F8
        setne   al                                      ; 0107 _ 0F 95. C0
        leave                                           ; 010A _ C9
        ret                                             ; 010B _ C3

overflow_general:; Local function
        push    rbp                                     ; 010C _ 55
        mov     rbp, rsp                                ; 010D _ 48: 89. E5
        sub     rsp, 16                                 ; 0110 _ 48: 83. EC, 10
        mov     qword [rbp-8H], rdi                     ; 0114 _ 48: 89. 7D, F8
        mov     dword [rbp-0CH], esi                    ; 0118 _ 89. 75, F4
        mov     rax, qword [rbp-8H]                     ; 011B _ 48: 8B. 45, F8
        mov     edx, dword [rbp-0CH]                    ; 011F _ 8B. 55, F4
        mov     esi, edx                                ; 0122 _ 89. D6
        mov     rdi, rax                                ; 0124 _ 48: 89. C7
        call    overflow_unsigned                       ; 0127 _ E8, FFFFFFB0
        test    al, al                                  ; 012C _ 84. C0
        jz      ?_0008                                  ; 012E _ 74, 22
        mov     rax, qword [rbp-8H]                     ; 0130 _ 48: 8B. 45, F8
        neg     rax                                     ; 0134 _ 48: F7. D8
        mov     rdx, rax                                ; 0137 _ 48: 89. C2
        mov     eax, dword [rbp-0CH]                    ; 013A _ 8B. 45, F4
        mov     esi, eax                                ; 013D _ 89. C6
        mov     rdi, rdx                                ; 013F _ 48: 89. D7
        call    overflow_unsigned                       ; 0142 _ E8, FFFFFF95
        test    al, al                                  ; 0147 _ 84. C0
        jz      ?_0008                                  ; 0149 _ 74, 07
        mov     eax, 1                                  ; 014B _ B8, 00000001
        jmp     ?_0009                                  ; 0150 _ EB, 05

?_0008: mov     eax, 0                                  ; 0152 _ B8, 00000000
?_0009: and     eax, 01H                                ; 0157 _ 83. E0, 01
        leave                                           ; 015A _ C9
        ret                                             ; 015B _ C3

is_class:; Local function
        push    rbp                                     ; 015C _ 55
        mov     rbp, rsp                                ; 015D _ 48: 89. E5
        mov     qword [rbp-8H], rdi                     ; 0160 _ 48: 89. 7D, F8
        mov     qword [rbp-10H], rsi                    ; 0164 _ 48: 89. 75, F0
        mov     rax, qword [rbp-10H]                    ; 0168 _ 48: 8B. 45, F0
        not     rax                                     ; 016C _ 48: F7. D0
        and     rax, qword [rbp-8H]                     ; 016F _ 48: 23. 45, F8
        test    rax, rax                                ; 0173 _ 48: 85. C0
        sete    al                                      ; 0176 _ 0F 94. C0
        pop     rbp                                     ; 0179 _ 5D
        ret                                             ; 017A _ C3

is_register:; Local function
        push    rbp                                     ; 017B _ 55
        mov     rbp, rsp                                ; 017C _ 48: 89. E5
        mov     dword [rbp-4H], edi                     ; 017F _ 89. 7D, FC
        cmp     dword [rbp-4H], 0                       ; 0182 _ 83. 7D, FC, 00
        jle     ?_0010                                  ; 0186 _ 7E, 10
        cmp     dword [rbp-4H], 344                     ; 0188 _ 81. 7D, FC, 00000158
        jg      ?_0010                                  ; 018F _ 7F, 07
        mov     eax, 1                                  ; 0191 _ B8, 00000001
        jmp     ?_0011                                  ; 0196 _ EB, 05

?_0010: mov     eax, 0                                  ; 0198 _ B8, 00000000
?_0011: and     eax, 01H                                ; 019D _ 83. E0, 01
        pop     rbp                                     ; 01A0 _ 5D
        ret                                             ; 01A1 _ C3

is_reg_class:; Local function
        push    rbp                                     ; 01A2 _ 55
        mov     rbp, rsp                                ; 01A3 _ 48: 89. E5
        sub     rsp, 16                                 ; 01A6 _ 48: 83. EC, 10
        mov     qword [rbp-8H], rdi                     ; 01AA _ 48: 89. 7D, F8
        mov     dword [rbp-0CH], esi                    ; 01AE _ 89. 75, F4
        mov     eax, dword [rbp-0CH]                    ; 01B1 _ 8B. 45, F4
        mov     edi, eax                                ; 01B4 _ 89. C7
        call    is_register                             ; 01B6 _ E8, FFFFFFC0
        xor     eax, 01H                                ; 01BB _ 83. F0, 01
        test    al, al                                  ; 01BE _ 84. C0
        jz      ?_0012                                  ; 01C0 _ 74, 07
        mov     eax, 0                                  ; 01C2 _ B8, 00000000
        jmp     ?_0013                                  ; 01C7 _ EB, 27

?_0012: mov     eax, dword [rbp-0CH]                    ; 01C9 _ 8B. 45, F4
        cdqe                                            ; 01CC _ 48: 98
        lea     rdx, [rax*8]                            ; 01CE _ 48: 8D. 14 C5, 00000000
        lea     rax, [rel nasm_reg_flags]               ; 01D6 _ 48: 8D. 05, 00000000(rel)
        mov     rdx, qword [rdx+rax]                    ; 01DD _ 48: 8B. 14 02
        mov     rax, qword [rbp-8H]                     ; 01E1 _ 48: 8B. 45, F8
        mov     rsi, rdx                                ; 01E5 _ 48: 89. D6
        mov     rdi, rax                                ; 01E8 _ 48: 89. C7
        call    is_class                                ; 01EB _ E8, FFFFFF6C
?_0013: leave                                           ; 01F0 _ C9
        ret                                             ; 01F1 _ C3

src_location_same:; Local function
        push    rbp                                     ; 01F2 _ 55
        mov     rbp, rsp                                ; 01F3 _ 48: 89. E5
        mov     rax, rdi                                ; 01F6 _ 48: 89. F8
        mov     r8, rsi                                 ; 01F9 _ 49: 89. F0
        mov     rsi, rax                                ; 01FC _ 48: 89. C6
        mov     edi, 0                                  ; 01FF _ BF, 00000000
        mov     rdi, r8                                 ; 0204 _ 4C: 89. C7
        mov     qword [rbp-10H], rsi                    ; 0207 _ 48: 89. 75, F0
        mov     qword [rbp-8H], rdi                     ; 020B _ 48: 89. 7D, F8
        mov     qword [rbp-20H], rdx                    ; 020F _ 48: 89. 55, E0
        mov     qword [rbp-18H], rcx                    ; 0213 _ 48: 89. 4D, E8
        mov     rdx, qword [rbp-10H]                    ; 0217 _ 48: 8B. 55, F0
        mov     rax, qword [rbp-20H]                    ; 021B _ 48: 8B. 45, E0
        cmp     rdx, rax                                ; 021F _ 48: 39. C2
        jnz     ?_0014                                  ; 0222 _ 75, 11
        mov     edx, dword [rbp-8H]                     ; 0224 _ 8B. 55, F8
        mov     eax, dword [rbp-18H]                    ; 0227 _ 8B. 45, E8
        cmp     edx, eax                                ; 022A _ 39. C2
        jnz     ?_0014                                  ; 022C _ 75, 07
        mov     eax, 1                                  ; 022E _ B8, 00000001
        jmp     ?_0015                                  ; 0233 _ EB, 05

?_0014: mov     eax, 0                                  ; 0235 _ B8, 00000000
?_0015: and     eax, 01H                                ; 023A _ 83. E0, 01
        pop     rbp                                     ; 023D _ 5D
        ret                                             ; 023E _ C3

src_where:; Local function
        push    rbp                                     ; 023F _ 55
        mov     rbp, rsp                                ; 0240 _ 48: 89. E5
        mov     rax, qword [rel _src_bottom]            ; 0243 _ 48: 8B. 05, 00000000(rel)
        mov     rdx, qword [rax+8H]                     ; 024A _ 48: 8B. 50, 08
        mov     rax, qword [rax]                        ; 024E _ 48: 8B. 00
        pop     rbp                                     ; 0251 _ 5D
        ret                                             ; 0252 _ C3

warn_active:; Local function
        push    rbp                                     ; 0253 _ 55
        mov     rbp, rsp                                ; 0254 _ 48: 89. E5
        mov     dword [rbp-4H], edi                     ; 0257 _ 89. 7D, FC
        mov     eax, dword [rel erropt+0CH]             ; 025A _ 8B. 05, 00000000(rel)
        and     eax, dword [rbp-4H]                     ; 0260 _ 23. 45, FC
        test    eax, eax                                ; 0263 _ 85. C0
        jz      ?_0016                                  ; 0265 _ 74, 07
        mov     eax, 0                                  ; 0267 _ B8, 00000000
        jmp     ?_0017                                  ; 026C _ EB, 16

?_0016: mov     eax, dword [rbp-4H]                     ; 026E _ 8B. 45, FC
        shr     eax, 16                                 ; 0271 _ C1. E8, 10
        mov     edx, eax                                ; 0274 _ 89. C2
        lea     rax, [rel warning_state]                ; 0276 _ 48: 8D. 05, 00000000(rel)
        movzx   eax, byte [rdx+rax]                     ; 027D _ 0F B6. 04 02
        and     eax, 01H                                ; 0281 _ 83. E0, 01
?_0017: pop     rbp                                     ; 0284 _ 5D
        ret                                             ; 0285 _ C3

brsize_to_size:; Local function
        push    rbp                                     ; 0286 _ 55
        mov     rbp, rsp                                ; 0287 _ 48: 89. E5
        mov     qword [rbp-8H], rdi                     ; 028A _ 48: 89. 7D, F8
        mov     rax, qword [rbp-8H]                     ; 028E _ 48: 8B. 45, F8
        shl     rax, 24                                 ; 0292 _ 48: C1. E0, 18
        mov     rdx, rax                                ; 0296 _ 48: 89. C2
        mov     rax, qword 0F00000000H                  ; 0299 _ 48: B8, 0000000F00000000
        and     rax, rdx                                ; 02A3 _ 48: 21. D0
        pop     rbp                                     ; 02A6 _ 5D
        ret                                             ; 02A7 _ C3

pass_type:; Local function
        push    rbp                                     ; 02A8 _ 55
        mov     rbp, rsp                                ; 02A9 _ 48: 89. E5
        mov     eax, dword [rel _pass_type]             ; 02AC _ 8B. 05, 00000000(rel)
        pop     rbp                                     ; 02B2 _ 5D
        ret                                             ; 02B3 _ C3

pass_first:; Local function
        push    rbp                                     ; 02B4 _ 55
        mov     rbp, rsp                                ; 02B5 _ 48: 89. E5
        call    pass_type                               ; 02B8 _ E8, FFFFFFEB
        cmp     eax, 2                                  ; 02BD _ 83. F8, 02
        setbe   al                                      ; 02C0 _ 0F 96. C0
        pop     rbp                                     ; 02C3 _ 5D
        ret                                             ; 02C4 _ C3

pass_final:; Local function
        push    rbp                                     ; 02C5 _ 55
        mov     rbp, rsp                                ; 02C6 _ 48: 89. E5
        call    pass_type                               ; 02C9 _ E8, FFFFFFDA
        cmp     eax, 4                                  ; 02CE _ 83. F8, 04
        seta    al                                      ; 02D1 _ 0F 97. C0
        pop     rbp                                     ; 02D4 _ 5D
        ret                                             ; 02D5 _ C3

ifcomp: ; Local function
        push    rbp                                     ; 02D6 _ 55
        mov     rbp, rsp                                ; 02D7 _ 48: 89. E5
        mov     dword [rbp-4H], edi                     ; 02DA _ 89. 7D, FC
        mov     dword [rbp-8H], esi                     ; 02DD _ 89. 75, F8
        mov     eax, dword [rbp-4H]                     ; 02E0 _ 8B. 45, FC
        cmp     dword [rbp-8H], eax                     ; 02E3 _ 39. 45, F8
        setb    al                                      ; 02E6 _ 0F 92. C0
        movzx   edx, al                                 ; 02E9 _ 0F B6. D0
        mov     eax, dword [rbp-4H]                     ; 02EC _ 8B. 45, FC
        cmp     eax, dword [rbp-8H]                     ; 02EF _ 3B. 45, F8
        setb    al                                      ; 02F2 _ 0F 92. C0
        movzx   eax, al                                 ; 02F5 _ 0F B6. C0
        sub     edx, eax                                ; 02F8 _ 29. C2
        mov     eax, edx                                ; 02FA _ 89. D0
        pop     rbp                                     ; 02FC _ 5D
        ret                                             ; 02FD _ C3

iflag_test:; Local function
        push    rbp                                     ; 02FE _ 55
        mov     rbp, rsp                                ; 02FF _ 48: 89. E5
        mov     qword [rbp-8H], rdi                     ; 0302 _ 48: 89. 7D, F8
        mov     dword [rbp-0CH], esi                    ; 0306 _ 89. 75, F4
        mov     eax, dword [rbp-0CH]                    ; 0309 _ 8B. 45, F4
        shr     eax, 5                                  ; 030C _ C1. E8, 05
        mov     edx, eax                                ; 030F _ 89. C2
        mov     rax, qword [rbp-8H]                     ; 0311 _ 48: 8B. 45, F8
        mov     edx, edx                                ; 0315 _ 89. D2
        mov     eax, dword [rax+rdx*4]                  ; 0317 _ 8B. 04 90
        mov     edx, dword [rbp-0CH]                    ; 031A _ 8B. 55, F4
        and     edx, 1FH                                ; 031D _ 83. E2, 1F
        mov     esi, 1                                  ; 0320 _ BE, 00000001
        mov     ecx, edx                                ; 0325 _ 89. D1
        shl     esi, cl                                 ; 0327 _ D3. E6
        mov     edx, esi                                ; 0329 _ 89. F2
        and     eax, edx                                ; 032B _ 21. D0
        test    eax, eax                                ; 032D _ 85. C0
        setne   al                                      ; 032F _ 0F 95. C0
        pop     rbp                                     ; 0332 _ 5D
        ret                                             ; 0333 _ C3

_iflag_cpu_level:; Local function
        push    rbp                                     ; 0334 _ 55
        mov     rbp, rsp                                ; 0335 _ 48: 89. E5
        mov     qword [rbp-8H], rdi                     ; 0338 _ 48: 89. 7D, F8
        mov     rax, qword [rbp-8H]                     ; 033C _ 48: 8B. 45, F8
        mov     eax, dword [rax+18H]                    ; 0340 _ 8B. 40, 18
        and     eax, 3FFFFH                             ; 0343 _ 25, 0003FFFF
        pop     rbp                                     ; 0348 _ 5D
        ret                                             ; 0349 _ C3

iflag_cmp_cpu_level:; Local function
        push    rbp                                     ; 034A _ 55
        mov     rbp, rsp                                ; 034B _ 48: 89. E5
        push    rbx                                     ; 034E _ 53
        sub     rsp, 16                                 ; 034F _ 48: 83. EC, 10
        mov     qword [rbp-10H], rdi                    ; 0353 _ 48: 89. 7D, F0
        mov     qword [rbp-18H], rsi                    ; 0357 _ 48: 89. 75, E8
        mov     rax, qword [rbp-18H]                    ; 035B _ 48: 8B. 45, E8
        mov     rdi, rax                                ; 035F _ 48: 89. C7
        call    _iflag_cpu_level                        ; 0362 _ E8, FFFFFFCD
        mov     ebx, eax                                ; 0367 _ 89. C3
        mov     rax, qword [rbp-10H]                    ; 0369 _ 48: 8B. 45, F0
        mov     rdi, rax                                ; 036D _ 48: 89. C7
        call    _iflag_cpu_level                        ; 0370 _ E8, FFFFFFBF
        mov     esi, ebx                                ; 0375 _ 89. DE
        mov     edi, eax                                ; 0377 _ 89. C7
        call    ifcomp                                  ; 0379 _ E8, FFFFFF58
        mov     rbx, qword [rbp-8H]                     ; 037E _ 48: 8B. 5D, F8
        leave                                           ; 0382 _ C9
        ret                                             ; 0383 _ C3

iflag_cpu_level_ok:; Local function
        push    rbp                                     ; 0384 _ 55
        mov     rbp, rsp                                ; 0385 _ 48: 89. E5
        sub     rsp, 16                                 ; 0388 _ 48: 83. EC, 10
        mov     qword [rbp-8H], rdi                     ; 038C _ 48: 89. 7D, F8
        mov     dword [rbp-0CH], esi                    ; 0390 _ 89. 75, F4
        mov     rax, qword [rbp-8H]                     ; 0393 _ 48: 8B. 45, F8
        mov     rdi, rax                                ; 0397 _ 48: 89. C7
        call    _iflag_cpu_level                        ; 039A _ E8, FFFFFF95
        mov     edx, dword [rbp-0CH]                    ; 039F _ 8B. 55, F4
        and     edx, 1FH                                ; 03A2 _ 83. E2, 1F
        mov     ecx, edx                                ; 03A5 _ 89. D1
        shr     eax, cl                                 ; 03A7 _ D3. E8
        test    eax, eax                                ; 03A9 _ 85. C0
        setne   al                                      ; 03AB _ 0F 95. C0
        leave                                           ; 03AE _ C9
        ret                                             ; 03AF _ C3

itemp_has:; Local function
        push    rbp                                     ; 03B0 _ 55
        mov     rbp, rsp                                ; 03B1 _ 48: 89. E5
        sub     rsp, 16                                 ; 03B4 _ 48: 83. EC, 10
        mov     qword [rbp-8H], rdi                     ; 03B8 _ 48: 89. 7D, F8
        mov     dword [rbp-0CH], esi                    ; 03BC _ 89. 75, F4
        mov     rax, qword [rbp-8H]                     ; 03BF _ 48: 8B. 45, F8
        mov     eax, dword [rax+48H]                    ; 03C3 _ 8B. 40, 48
        mov     eax, eax                                ; 03C6 _ 89. C0
        imul    rax, rax, 28                            ; 03C8 _ 48: 6B. C0, 1C
        lea     rdx, [rel insns_flags]                  ; 03CC _ 48: 8D. 15, 00000000(rel)
        add     rdx, rax                                ; 03D3 _ 48: 01. C2
        mov     eax, dword [rbp-0CH]                    ; 03D6 _ 8B. 45, F4
        mov     esi, eax                                ; 03D9 _ 89. C6
        mov     rdi, rdx                                ; 03DB _ 48: 89. D7
        call    iflag_test                              ; 03DE _ E8, FFFFFF1B
        leave                                           ; 03E3 _ C9
        ret                                             ; 03E4 _ C3

opcode_is_db:; Local function
        push    rbp                                     ; 03E5 _ 55
        mov     rbp, rsp                                ; 03E6 _ 48: 89. E5
        mov     dword [rbp-4H], edi                     ; 03E9 _ 89. 7D, FC
        cmp     dword [rbp-4H], 0                       ; 03EC _ 83. 7D, FC, 00
        js      ?_0018                                  ; 03F0 _ 78, 0D
        cmp     dword [rbp-4H], 7                       ; 03F2 _ 83. 7D, FC, 07
        jg      ?_0018                                  ; 03F6 _ 7F, 07
        mov     eax, 1                                  ; 03F8 _ B8, 00000001
        jmp     ?_0019                                  ; 03FD _ EB, 05

?_0018: mov     eax, 0                                  ; 03FF _ B8, 00000000
?_0019: and     eax, 01H                                ; 0404 _ 83. E0, 01
        pop     rbp                                     ; 0407 _ 5D
        ret                                             ; 0408 _ C3

opcode_is_resb:; Local function
        push    rbp                                     ; 0409 _ 55
        mov     rbp, rsp                                ; 040A _ 48: 89. E5
        mov     dword [rbp-4H], edi                     ; 040D _ 89. 7D, FC
        cmp     dword [rbp-4H], 7                       ; 0410 _ 83. 7D, FC, 07
        jle     ?_0020                                  ; 0414 _ 7E, 0D
        cmp     dword [rbp-4H], 15                      ; 0416 _ 83. 7D, FC, 0F
        jg      ?_0020                                  ; 041A _ 7F, 07
        mov     eax, 1                                  ; 041C _ B8, 00000001
        jmp     ?_0021                                  ; 0421 _ EB, 05

?_0020: mov     eax, 0                                  ; 0423 _ B8, 00000000
?_0021: and     eax, 01H                                ; 0428 _ 83. E0, 01
        pop     rbp                                     ; 042B _ 5D
        ret                                             ; 042C _ C3

resb_bytes:; Local function
        push    rbp                                     ; 042D _ 55
        mov     rbp, rsp                                ; 042E _ 48: 89. E5
        mov     dword [rbp-4H], edi                     ; 0431 _ 89. 7D, FC
        cmp     dword [rbp-4H], 15                      ; 0434 _ 83. 7D, FC, 0F
        je      ?_0028                                  ; 0438 _ 0F 84, 00000093
        cmp     dword [rbp-4H], 15                      ; 043E _ 83. 7D, FC, 0F
        jg      ?_0030                                  ; 0442 _ 0F 8F, 00000097
        cmp     dword [rbp-4H], 14                      ; 0448 _ 83. 7D, FC, 0E
        jz      ?_0027                                  ; 044C _ 74, 7C
        cmp     dword [rbp-4H], 14                      ; 044E _ 83. 7D, FC, 0E
        jg      ?_0030                                  ; 0452 _ 0F 8F, 00000087
        cmp     dword [rbp-4H], 13                      ; 0458 _ 83. 7D, FC, 0D
        jz      ?_0026                                  ; 045C _ 74, 65
        cmp     dword [rbp-4H], 13                      ; 045E _ 83. 7D, FC, 0D
        jg      ?_0030                                  ; 0462 _ 7F, 7B
        cmp     dword [rbp-4H], 12                      ; 0464 _ 83. 7D, FC, 0C
        jz      ?_0025                                  ; 0468 _ 74, 52
        cmp     dword [rbp-4H], 12                      ; 046A _ 83. 7D, FC, 0C
        jg      ?_0030                                  ; 046E _ 7F, 6F
        cmp     dword [rbp-4H], 11                      ; 0470 _ 83. 7D, FC, 0B
        jz      ?_0024                                  ; 0474 _ 74, 3F
        cmp     dword [rbp-4H], 11                      ; 0476 _ 83. 7D, FC, 0B
        jg      ?_0030                                  ; 047A _ 7F, 63
        cmp     dword [rbp-4H], 10                      ; 047C _ 83. 7D, FC, 0A
        jz      ?_0023                                  ; 0480 _ 74, 2C
        cmp     dword [rbp-4H], 10                      ; 0482 _ 83. 7D, FC, 0A
        jg      ?_0030                                  ; 0486 _ 7F, 57
        cmp     dword [rbp-4H], 9                       ; 0488 _ 83. 7D, FC, 09
        jz      ?_0022                                  ; 048C _ 74, 19
        cmp     dword [rbp-4H], 9                       ; 048E _ 83. 7D, FC, 09
        jg      ?_0030                                  ; 0492 _ 7F, 4B
        cmp     dword [rbp-4H], -1                      ; 0494 _ 83. 7D, FC, FF
        jz      ?_0029                                  ; 0498 _ 74, 3E
        cmp     dword [rbp-4H], 8                       ; 049A _ 83. 7D, FC, 08
        jnz     ?_0030                                  ; 049E _ 75, 3F
        mov     eax, 1                                  ; 04A0 _ B8, 00000001
        jmp     ?_0031                                  ; 04A5 _ EB, 3D

?_0022: mov     eax, 2                                  ; 04A7 _ B8, 00000002
        jmp     ?_0031                                  ; 04AC _ EB, 36

?_0023: mov     eax, 4                                  ; 04AE _ B8, 00000004
        jmp     ?_0031                                  ; 04B3 _ EB, 2F

?_0024: mov     eax, 8                                  ; 04B5 _ B8, 00000008
        jmp     ?_0031                                  ; 04BA _ EB, 28

?_0025: mov     eax, 10                                 ; 04BC _ B8, 0000000A
        jmp     ?_0031                                  ; 04C1 _ EB, 21

?_0026: mov     eax, 16                                 ; 04C3 _ B8, 00000010
        jmp     ?_0031                                  ; 04C8 _ EB, 1A

?_0027: mov     eax, 32                                 ; 04CA _ B8, 00000020
        jmp     ?_0031                                  ; 04CF _ EB, 13

?_0028: mov     eax, 64                                 ; 04D1 _ B8, 00000040
        jmp     ?_0031                                  ; 04D6 _ EB, 0C

?_0029: mov     eax, 4294967295                         ; 04D8 _ B8, FFFFFFFF
        jmp     ?_0031                                  ; 04DD _ EB, 05

?_0030: mov     eax, 0                                  ; 04DF _ B8, 00000000
?_0031: pop     rbp                                     ; 04E4 _ 5D
        ret                                             ; 04E5 _ C3

get_disp8_shift:; Local function
        push    rbp                                     ; 04E6 _ 55
        mov     rbp, rsp                                ; 04E7 _ 48: 89. E5
        mov     qword [rbp-18H], rdi                    ; 04EA _ 48: 89. 7D, E8
        mov     rax, qword [rbp-18H]                    ; 04EE _ 48: 8B. 45, E8
        mov     eax, dword [rax+8CH]                    ; 04F2 _ 8B. 80, 0000008C
        mov     dword [rbp-0CH], eax                    ; 04F8 _ 89. 45, F4
        cmp     dword [rbp-0CH], 0                      ; 04FB _ 83. 7D, F4, 00
        sete    al                                      ; 04FF _ 0F 94. C0
        movzx   eax, al                                 ; 0502 _ 0F B6. C0
        test    rax, rax                                ; 0505 _ 48: 85. C0
        jz      ?_0032                                  ; 0508 _ 74, 0A
        mov     eax, 0                                  ; 050A _ B8, 00000000
        jmp     ?_0053                                  ; 050F _ E9, 00000215

?_0032: mov     rax, qword [rbp-18H]                    ; 0514 _ 48: 8B. 45, E8
        mov     eax, dword [rax+88H]                    ; 0518 _ 8B. 80, 00000088
        and     eax, 10000000H                          ; 051E _ 25, 10000000
        shr     eax, 28                                 ; 0523 _ C1. E8, 1C
        and     eax, 01H                                ; 0526 _ 83. E0, 01
        mov     byte [rbp-0DH], al                      ; 0529 _ 88. 45, F3
        mov     rax, qword [rbp-18H]                    ; 052C _ 48: 8B. 45, E8
        mov     eax, dword [rax+88H]                    ; 0530 _ 8B. 80, 00000088
        and     eax, 800000H                            ; 0536 _ 25, 00800000
        shr     eax, 23                                 ; 053B _ C1. E8, 17
        and     eax, 01H                                ; 053E _ 83. E0, 01
        movzx   eax, al                                 ; 0541 _ 0F B6. C0
        mov     dword [rbp-8H], eax                     ; 0544 _ 89. 45, F8
        mov     rax, qword [rbp-18H]                    ; 0547 _ 48: 8B. 45, E8
        mov     eax, dword [rax+88H]                    ; 054B _ 8B. 80, 00000088
        shr     eax, 29                                 ; 0551 _ C1. E8, 1D
        and     eax, 03H                                ; 0554 _ 83. E0, 03
        mov     dword [rbp-4H], eax                     ; 0557 _ 89. 45, FC
        cmp     dword [rbp-0CH], 16                     ; 055A _ 83. 7D, F4, 10
        je      ?_0050                                  ; 055E _ 0F 84, 000001AB
        cmp     dword [rbp-0CH], 16                     ; 0564 _ 83. 7D, F4, 10
        ja      ?_0052                                  ; 0568 _ 0F 87, 000001B6
        cmp     dword [rbp-0CH], 15                     ; 056E _ 83. 7D, F4, 0F
        je      ?_0042                                  ; 0572 _ 0F 84, 00000158
        cmp     dword [rbp-0CH], 15                     ; 0578 _ 83. 7D, F4, 0F
        ja      ?_0052                                  ; 057C _ 0F 87, 000001A2
        cmp     dword [rbp-0CH], 14                     ; 0582 _ 83. 7D, F4, 0E
        je      ?_0049                                  ; 0586 _ 0F 84, 0000017B
        cmp     dword [rbp-0CH], 14                     ; 058C _ 83. 7D, F4, 0E
        ja      ?_0052                                  ; 0590 _ 0F 87, 0000018E
        cmp     dword [rbp-0CH], 13                     ; 0596 _ 83. 7D, F4, 0D
        je      ?_0048                                  ; 059A _ 0F 84, 0000015F
        cmp     dword [rbp-0CH], 13                     ; 05A0 _ 83. 7D, F4, 0D
        ja      ?_0052                                  ; 05A4 _ 0F 87, 0000017A
        cmp     dword [rbp-0CH], 12                     ; 05AA _ 83. 7D, F4, 0C
        je      ?_0047                                  ; 05AE _ 0F 84, 00000143
        cmp     dword [rbp-0CH], 12                     ; 05B4 _ 83. 7D, F4, 0C
        ja      ?_0052                                  ; 05B8 _ 0F 87, 00000166
        cmp     dword [rbp-0CH], 11                     ; 05BE _ 83. 7D, F4, 0B
        je      ?_0046                                  ; 05C2 _ 0F 84, 00000127
        cmp     dword [rbp-0CH], 11                     ; 05C8 _ 83. 7D, F4, 0B
        ja      ?_0052                                  ; 05CC _ 0F 87, 00000152
        cmp     dword [rbp-0CH], 10                     ; 05D2 _ 83. 7D, F4, 0A
        je      ?_0045                                  ; 05D6 _ 0F 84, 0000010B
        cmp     dword [rbp-0CH], 10                     ; 05DC _ 83. 7D, F4, 0A
        ja      ?_0052                                  ; 05E0 _ 0F 87, 0000013E
        cmp     dword [rbp-0CH], 9                      ; 05E6 _ 83. 7D, F4, 09
        je      ?_0044                                  ; 05EA _ 0F 84, 000000EF
        cmp     dword [rbp-0CH], 9                      ; 05F0 _ 83. 7D, F4, 09
        ja      ?_0052                                  ; 05F4 _ 0F 87, 0000012A
        cmp     dword [rbp-0CH], 8                      ; 05FA _ 83. 7D, F4, 08
        je      ?_0041                                  ; 05FE _ 0F 84, 000000C5
        cmp     dword [rbp-0CH], 8                      ; 0604 _ 83. 7D, F4, 08
        ja      ?_0052                                  ; 0608 _ 0F 87, 00000116
        cmp     dword [rbp-0CH], 7                      ; 060E _ 83. 7D, F4, 07
        je      ?_0040                                  ; 0612 _ 0F 84, 000000AA
        cmp     dword [rbp-0CH], 7                      ; 0618 _ 83. 7D, F4, 07
        ja      ?_0052                                  ; 061C _ 0F 87, 00000102
        cmp     dword [rbp-0CH], 6                      ; 0622 _ 83. 7D, F4, 06
        je      ?_0043                                  ; 0626 _ 0F 84, 000000AB
        cmp     dword [rbp-0CH], 6                      ; 062C _ 83. 7D, F4, 06
        ja      ?_0052                                  ; 0630 _ 0F 87, 000000EE
        cmp     dword [rbp-0CH], 5                      ; 0636 _ 83. 7D, F4, 05
        jz      ?_0039                                  ; 063A _ 74, 7F
        cmp     dword [rbp-0CH], 5                      ; 063C _ 83. 7D, F4, 05
        ja      ?_0052                                  ; 0640 _ 0F 87, 000000DE
        cmp     dword [rbp-0CH], 4                      ; 0646 _ 83. 7D, F4, 04
        jz      ?_0038                                  ; 064A _ 74, 68
        cmp     dword [rbp-0CH], 4                      ; 064C _ 83. 7D, F4, 04
        ja      ?_0052                                  ; 0650 _ 0F 87, 000000CE
        cmp     dword [rbp-0CH], 3                      ; 0656 _ 83. 7D, F4, 03
        jz      ?_0037                                  ; 065A _ 74, 50
        cmp     dword [rbp-0CH], 3                      ; 065C _ 83. 7D, F4, 03
        ja      ?_0052                                  ; 0660 _ 0F 87, 000000BE
        cmp     dword [rbp-0CH], 1                      ; 0666 _ 83. 7D, F4, 01
        jz      ?_0033                                  ; 066A _ 74, 0B
        cmp     dword [rbp-0CH], 2                      ; 066C _ 83. 7D, F4, 02
        jz      ?_0035                                  ; 0670 _ 74, 21
        jmp     ?_0052                                  ; 0672 _ E9, 000000AD

?_0033: cmp     byte [rbp-0DH], 0                       ; 0677 _ 80. 7D, F3, 00
        jz      ?_0034                                  ; 067B _ 74, 0B
        mov     eax, dword [rbp-8H]                     ; 067D _ 8B. 45, F8
        add     eax, 2                                  ; 0680 _ 83. C0, 02
        jmp     ?_0053                                  ; 0683 _ E9, 000000A1

?_0034: mov     eax, dword [rbp-4H]                     ; 0688 _ 8B. 45, FC
        add     eax, 4                                  ; 068B _ 83. C0, 04
        jmp     ?_0053                                  ; 068E _ E9, 00000096

?_0035: cmp     byte [rbp-0DH], 0                       ; 0693 _ 80. 7D, F3, 00
        jz      ?_0036                                  ; 0697 _ 74, 0B
        mov     eax, dword [rbp-8H]                     ; 0699 _ 8B. 45, F8
        add     eax, 2                                  ; 069C _ 83. C0, 02
        jmp     ?_0053                                  ; 069F _ E9, 00000085

?_0036: mov     eax, dword [rbp-4H]                     ; 06A4 _ 8B. 45, FC
        add     eax, 3                                  ; 06A7 _ 83. C0, 03
        jmp     ?_0053                                  ; 06AA _ EB, 7D

?_0037: mov     eax, dword [rbp-4H]                     ; 06AC _ 8B. 45, FC
        add     eax, 4                                  ; 06AF _ 83. C0, 04
        jmp     ?_0053                                  ; 06B2 _ EB, 75

?_0038: mov     eax, 0                                  ; 06B4 _ B8, 00000000
        jmp     ?_0053                                  ; 06B9 _ EB, 6E

?_0039: mov     eax, 1                                  ; 06BB _ B8, 00000001
        jmp     ?_0053                                  ; 06C0 _ EB, 67

?_0040: mov     eax, 2                                  ; 06C2 _ B8, 00000002
        jmp     ?_0053                                  ; 06C7 _ EB, 60

?_0041: mov     eax, 3                                  ; 06C9 _ B8, 00000003
        jmp     ?_0053                                  ; 06CE _ EB, 59

?_0042: mov     eax, 4                                  ; 06D0 _ B8, 00000004
        jmp     ?_0053                                  ; 06D5 _ EB, 52

?_0043: mov     eax, dword [rbp-8H]                     ; 06D7 _ 8B. 45, F8
        add     eax, 2                                  ; 06DA _ 83. C0, 02
        jmp     ?_0053                                  ; 06DD _ EB, 4A

?_0044: mov     eax, dword [rbp-8H]                     ; 06DF _ 8B. 45, F8
        add     eax, 3                                  ; 06E2 _ 83. C0, 03
        jmp     ?_0053                                  ; 06E5 _ EB, 42

?_0045: mov     eax, dword [rbp-8H]                     ; 06E7 _ 8B. 45, F8
        add     eax, 4                                  ; 06EA _ 83. C0, 04
        jmp     ?_0053                                  ; 06ED _ EB, 3A

?_0046: mov     eax, dword [rbp-8H]                     ; 06EF _ 8B. 45, F8
        add     eax, 5                                  ; 06F2 _ 83. C0, 05
        jmp     ?_0053                                  ; 06F5 _ EB, 32

?_0047: mov     eax, dword [rbp-4H]                     ; 06F7 _ 8B. 45, FC
        add     eax, 3                                  ; 06FA _ 83. C0, 03
        jmp     ?_0053                                  ; 06FD _ EB, 2A

?_0048: mov     eax, dword [rbp-4H]                     ; 06FF _ 8B. 45, FC
        add     eax, 2                                  ; 0702 _ 83. C0, 02
        jmp     ?_0053                                  ; 0705 _ EB, 22

?_0049: mov     eax, dword [rbp-4H]                     ; 0707 _ 8B. 45, FC
        add     eax, 1                                  ; 070A _ 83. C0, 01
        jmp     ?_0053                                  ; 070D _ EB, 1A

?_0050: cmp     dword [rbp-4H], 0                       ; 070F _ 83. 7D, FC, 00
        jnz     ?_0051                                  ; 0713 _ 75, 07
        mov     eax, 3                                  ; 0715 _ B8, 00000003
        jmp     ?_0053                                  ; 071A _ EB, 0D

?_0051: mov     eax, dword [rbp-4H]                     ; 071C _ 8B. 45, FC
        add     eax, 4                                  ; 071F _ 83. C0, 04
        jmp     ?_0053                                  ; 0722 _ EB, 05

?_0052: mov     eax, 0                                  ; 0724 _ B8, 00000000
?_0053: pop     rbp                                     ; 0729 _ 5D
        ret                                             ; 072A _ C3

list_option_mask:; Local function
        push    rbp                                     ; 072B _ 55
        mov     rbp, rsp                                ; 072C _ 48: 89. E5
        mov     byte [rbp-1H], dil                      ; 072F _ 40: 88. 7D, FF
        cmp     byte [rbp-1H], 96                       ; 0733 _ 80. 7D, FF, 60
        jbe     ?_0055                                  ; 0737 _ 76, 13
        cmp     byte [rbp-1H], 122                      ; 0739 _ 80. 7D, FF, 7A
        jbe     ?_0054                                  ; 073D _ 76, 07
        mov     eax, 0                                  ; 073F _ B8, 00000000
        jmp     ?_0061                                  ; 0744 _ EB, 50

?_0054: sub     byte [rbp-1H], 95                       ; 0746 _ 80. 6D, FF, 5F
        jmp     ?_0060                                  ; 074A _ EB, 39

?_0055: cmp     byte [rbp-1H], 64                       ; 074C _ 80. 7D, FF, 40
        jbe     ?_0057                                  ; 0750 _ 76, 13
        cmp     byte [rbp-1H], 90                       ; 0752 _ 80. 7D, FF, 5A
        jbe     ?_0056                                  ; 0756 _ 76, 07
        mov     eax, 0                                  ; 0758 _ B8, 00000000
        jmp     ?_0061                                  ; 075D _ EB, 37

?_0056: sub     byte [rbp-1H], 37                       ; 075F _ 80. 6D, FF, 25
        jmp     ?_0060                                  ; 0763 _ EB, 20

?_0057: cmp     byte [rbp-1H], 47                       ; 0765 _ 80. 7D, FF, 2F
        jbe     ?_0059                                  ; 0769 _ 76, 13
        cmp     byte [rbp-1H], 57                       ; 076B _ 80. 7D, FF, 39
        jbe     ?_0058                                  ; 076F _ 76, 07
        mov     eax, 0                                  ; 0771 _ B8, 00000000
        jmp     ?_0061                                  ; 0776 _ EB, 1E

?_0058: add     byte [rbp-1H], 6                        ; 0778 _ 80. 45, FF, 06
        jmp     ?_0060                                  ; 077C _ EB, 07

?_0059: mov     eax, 0                                  ; 077E _ B8, 00000000
        jmp     ?_0061                                  ; 0783 _ EB, 11

?_0060: movzx   eax, byte [rbp-1H]                      ; 0785 _ 0F B6. 45, FF
        mov     edx, 1                                  ; 0789 _ BA, 00000001
        mov     ecx, eax                                ; 078E _ 89. C1
        shl     rdx, cl                                 ; 0790 _ 48: D3. E2
        mov     rax, rdx                                ; 0793 _ 48: 89. D0
?_0061: pop     rbp                                     ; 0796 _ 5D
        ret                                             ; 0797 _ C3

list_option:; Local function
        push    rbp                                     ; 0798 _ 55
        mov     rbp, rsp                                ; 0799 _ 48: 89. E5
        sub     rsp, 8                                  ; 079C _ 48: 83. EC, 08
        mov     byte [rbp-1H], dil                      ; 07A0 _ 40: 88. 7D, FF
        movzx   eax, byte [rbp-1H]                      ; 07A4 _ 0F B6. 45, FF
        mov     edi, eax                                ; 07A8 _ 89. C7
        call    list_option_mask                        ; 07AA _ E8, FFFFFF7C
        mov     rdx, qword [rel active_list_options]    ; 07AF _ 48: 8B. 15, 00000000(rel)
        and     rax, rdx                                ; 07B6 _ 48: 21. D0
        test    rax, rax                                ; 07B9 _ 48: 85. C0
        setne   al                                      ; 07BC _ 0F 95. C0
        movzx   eax, al                                 ; 07BF _ 0F B6. C0
        test    rax, rax                                ; 07C2 _ 48: 85. C0
        setne   al                                      ; 07C5 _ 0F 95. C0
        leave                                           ; 07C8 _ C9
        ret                                             ; 07C9 _ C3

mode_to_op:; Local function
        push    rbp                                     ; 07CA _ 55
        mov     rbp, rsp                                ; 07CB _ 48: 89. E5
        mov     dword [rbp-4H], edi                     ; 07CE _ 89. 7D, FC
        mov     eax, dword [rbp-4H]                     ; 07D1 _ 8B. 45, FC
        shl     rax, 29                                 ; 07D4 _ 48: C1. E0, 1D
        pop     rbp                                     ; 07D8 _ 5D
        ret                                             ; 07D9 _ C3

rex_highvec:; Local function
        push    rbp                                     ; 07DA _ 55
        mov     rbp, rsp                                ; 07DB _ 48: 89. E5
        mov     dword [rbp-4H], edi                     ; 07DE _ 89. 7D, FC
        mov     eax, dword [rbp-4H]                     ; 07E1 _ 8B. 45, FC
        shr     eax, 4                                  ; 07E4 _ C1. E8, 04
        and     eax, dword [rbp-4H]                     ; 07E7 _ 23. 45, FC
        and     eax, 7000H                              ; 07EA _ 25, 00007000
        pop     rbp                                     ; 07EF _ 5D
        ret                                             ; 07F0 _ C3

get_operand:; Local function
        push    rbp                                     ; 07F1 _ 55
        mov     rbp, rsp                                ; 07F2 _ 48: 89. E5
        mov     qword [rbp-8H], rdi                     ; 07F5 _ 48: 89. 7D, F8
        mov     dword [rbp-0CH], esi                    ; 07F9 _ 89. 75, F4
        mov     rax, qword [rbp-8H]                     ; 07FC _ 48: 8B. 45, F8
        movzx   eax, byte [rax+7DH]                     ; 0800 _ 0F B6. 40, 7D
        movzx   eax, al                                 ; 0804 _ 0F B6. C0
        cmp     dword [rbp-0CH], eax                    ; 0807 _ 39. 45, F4
        jc      ?_0062                                  ; 080A _ 72, 07
        mov     eax, 0                                  ; 080C _ B8, 00000000
        jmp     ?_0063                                  ; 0811 _ EB, 1F

?_0062: mov     edx, dword [rbp-0CH]                    ; 0813 _ 8B. 55, F4
        mov     rax, rdx                                ; 0816 _ 48: 89. D0
        shl     rax, 3                                  ; 0819 _ 48: C1. E0, 03
        add     rax, rdx                                ; 081D _ 48: 01. D0
        shl     rax, 3                                  ; 0820 _ 48: C1. E0, 03
        lea     rdx, [rax+0C0H]                         ; 0824 _ 48: 8D. 90, 000000C0
        mov     rax, qword [rbp-8H]                     ; 082B _ 48: 8B. 45, F8
        add     rax, rdx                                ; 082F _ 48: 01. D0
?_0063: pop     rbp                                     ; 0832 _ 5D
        ret                                             ; 0833 _ C3

get_operand_const:; Local function
        push    rbp                                     ; 0834 _ 55
        mov     rbp, rsp                                ; 0835 _ 48: 89. E5
        mov     qword [rbp-8H], rdi                     ; 0838 _ 48: 89. 7D, F8
        mov     dword [rbp-0CH], esi                    ; 083C _ 89. 75, F4
        mov     rax, qword [rbp-8H]                     ; 083F _ 48: 8B. 45, F8
        movzx   eax, byte [rax+7DH]                     ; 0843 _ 0F B6. 40, 7D
        movzx   eax, al                                 ; 0847 _ 0F B6. C0
        cmp     dword [rbp-0CH], eax                    ; 084A _ 39. 45, F4
        jc      ?_0064                                  ; 084D _ 72, 07
        mov     eax, 0                                  ; 084F _ B8, 00000000
        jmp     ?_0065                                  ; 0854 _ EB, 1F

?_0064: mov     edx, dword [rbp-0CH]                    ; 0856 _ 8B. 55, F4
        mov     rax, rdx                                ; 0859 _ 48: 89. D0
        shl     rax, 3                                  ; 085C _ 48: C1. E0, 03
        add     rax, rdx                                ; 0860 _ 48: 01. D0
        shl     rax, 3                                  ; 0863 _ 48: C1. E0, 03
        lea     rdx, [rax+0C0H]                         ; 0867 _ 48: 8D. 90, 000000C0
        mov     rax, qword [rbp-8H]                     ; 086E _ 48: 8B. 45, F8
        add     rax, rdx                                ; 0872 _ 48: 01. D0
?_0065: pop     rbp                                     ; 0875 _ 5D
        ret                                             ; 0876 _ C3

absolute_op:; Local function
        push    rbp                                     ; 0877 _ 55
        mov     rbp, rsp                                ; 0878 _ 48: 89. E5
        mov     qword [rbp-8H], rdi                     ; 087B _ 48: 89. 7D, F8
        cmp     qword [rbp-8H], 0                       ; 087F _ 48: 83. 7D, F8, 00
        jz      ?_0066                                  ; 0884 _ 74, 2D
        mov     rax, qword [rbp-8H]                     ; 0886 _ 48: 8B. 45, F8
        mov     eax, dword [rax+24H]                    ; 088A _ 8B. 40, 24
        cmp     eax, -1                                 ; 088D _ 83. F8, FF
        jnz     ?_0066                                  ; 0890 _ 75, 21
        mov     rax, qword [rbp-8H]                     ; 0892 _ 48: 8B. 45, F8
        mov     eax, dword [rax+30H]                    ; 0896 _ 8B. 40, 30
        cmp     eax, -1                                 ; 0899 _ 83. F8, FF
        jnz     ?_0066                                  ; 089C _ 75, 15
        mov     rax, qword [rbp-8H]                     ; 089E _ 48: 8B. 45, F8
        mov     eax, dword [rax+38H]                    ; 08A2 _ 8B. 40, 38
        and     eax, 08H                                ; 08A5 _ 83. E0, 08
        test    eax, eax                                ; 08A8 _ 85. C0
        jnz     ?_0066                                  ; 08AA _ 75, 07
        mov     eax, 1                                  ; 08AC _ B8, 00000001
        jmp     ?_0067                                  ; 08B1 _ EB, 05

?_0066: mov     eax, 0                                  ; 08B3 _ B8, 00000000
?_0067: and     eax, 01H                                ; 08B8 _ 83. E0, 01
        pop     rbp                                     ; 08BB _ 5D
        ret                                             ; 08BC _ C3

has_prefix:; Local function
        push    rbp                                     ; 08BD _ 55
        mov     rbp, rsp                                ; 08BE _ 48: 89. E5
        mov     qword [rbp-8H], rdi                     ; 08C1 _ 48: 89. 7D, F8
        mov     dword [rbp-0CH], esi                    ; 08C5 _ 89. 75, F4
        mov     dword [rbp-10H], edx                    ; 08C8 _ 89. 55, F0
        mov     rax, qword [rbp-8H]                     ; 08CB _ 48: 8B. 45, F8
        mov     edx, dword [rbp-0CH]                    ; 08CF _ 8B. 55, F4
        add     rdx, 4                                  ; 08D2 _ 48: 83. C2, 04
        mov     eax, dword [rax+rdx*4+8H]               ; 08D6 _ 8B. 44 90, 08
        cmp     dword [rbp-10H], eax                    ; 08DA _ 39. 45, F0
        sete    al                                      ; 08DD _ 0F 94. C0
        movzx   eax, al                                 ; 08E0 _ 0F B6. C0
        pop     rbp                                     ; 08E3 _ 5D
        ret                                             ; 08E4 _ C3

assert_no_prefix:; Local function
        push    rbp                                     ; 08E5 _ 55
        mov     rbp, rsp                                ; 08E6 _ 48: 89. E5
        sub     rsp, 16                                 ; 08E9 _ 48: 83. EC, 10
        mov     qword [rbp-8H], rdi                     ; 08ED _ 48: 89. 7D, F8
        mov     dword [rbp-0CH], esi                    ; 08F1 _ 89. 75, F4
        mov     rax, qword [rbp-8H]                     ; 08F4 _ 48: 8B. 45, F8
        mov     edx, dword [rbp-0CH]                    ; 08F8 _ 8B. 55, F4
        add     rdx, 4                                  ; 08FB _ 48: 83. C2, 04
        mov     eax, dword [rax+rdx*4+8H]               ; 08FF _ 8B. 44 90, 08
        test    eax, eax                                ; 0903 _ 85. C0
        jz      ?_0068                                  ; 0905 _ 74, 37
        mov     rax, qword [rbp-8H]                     ; 0907 _ 48: 8B. 45, F8
        mov     edx, dword [rbp-0CH]                    ; 090B _ 8B. 55, F4
        add     rdx, 4                                  ; 090E _ 48: 83. C2, 04
        mov     eax, dword [rax+rdx*4+8H]               ; 0912 _ 8B. 44 90, 08
        mov     edi, eax                                ; 0916 _ 89. C7
        call    prefix_name                             ; 0918 _ E8, 00000000(PLT r)
        mov     rdx, rax                                ; 091D _ 48: 89. C2
        lea     rax, [rel ?_0999]                       ; 0920 _ 48: 8D. 05, 00000000(rel)
        mov     rsi, rdx                                ; 0927 _ 48: 89. D6
        mov     rdi, rax                                ; 092A _ 48: 89. C7
        mov     eax, 0                                  ; 092D _ B8, 00000000
        call    nasm_nonfatal                           ; 0932 _ E8, 00000000(PLT r)
        mov     eax, 4294967295                         ; 0937 _ B8, FFFFFFFF
        jmp     ?_0069                                  ; 093C _ EB, 05

?_0068: mov     eax, 0                                  ; 093E _ B8, 00000000
?_0069: leave                                           ; 0943 _ C9
        ret                                             ; 0944 _ C3

size_name:; Local function
        push    rbp                                     ; 0945 _ 55
        mov     rbp, rsp                                ; 0946 _ 48: 89. E5
        mov     dword [rbp-4H], edi                     ; 0949 _ 89. 7D, FC
        cmp     dword [rbp-4H], 64                      ; 094C _ 83. 7D, FC, 40
        je      ?_0077                                  ; 0950 _ 0F 84, 00000097
        cmp     dword [rbp-4H], 64                      ; 0956 _ 83. 7D, FC, 40
        jg      ?_0078                                  ; 095A _ 0F 8F, 00000096
        cmp     dword [rbp-4H], 32                      ; 0960 _ 83. 7D, FC, 20
        jz      ?_0076                                  ; 0964 _ 74, 7E
        cmp     dword [rbp-4H], 32                      ; 0966 _ 83. 7D, FC, 20
        jg      ?_0078                                  ; 096A _ 0F 8F, 00000086
        cmp     dword [rbp-4H], 16                      ; 0970 _ 83. 7D, FC, 10
        jz      ?_0075                                  ; 0974 _ 74, 65
        cmp     dword [rbp-4H], 16                      ; 0976 _ 83. 7D, FC, 10
        jg      ?_0078                                  ; 097A _ 7F, 7A
        cmp     dword [rbp-4H], 10                      ; 097C _ 83. 7D, FC, 0A
        jz      ?_0074                                  ; 0980 _ 74, 50
        cmp     dword [rbp-4H], 10                      ; 0982 _ 83. 7D, FC, 0A
        jg      ?_0078                                  ; 0986 _ 7F, 6E
        cmp     dword [rbp-4H], 8                       ; 0988 _ 83. 7D, FC, 08
        jz      ?_0073                                  ; 098C _ 74, 3B
        cmp     dword [rbp-4H], 8                       ; 098E _ 83. 7D, FC, 08
        jg      ?_0078                                  ; 0992 _ 7F, 62
        cmp     dword [rbp-4H], 4                       ; 0994 _ 83. 7D, FC, 04
        jz      ?_0072                                  ; 0998 _ 74, 26
        cmp     dword [rbp-4H], 4                       ; 099A _ 83. 7D, FC, 04
        jg      ?_0078                                  ; 099E _ 7F, 56
        cmp     dword [rbp-4H], 1                       ; 09A0 _ 83. 7D, FC, 01
        jz      ?_0070                                  ; 09A4 _ 74, 08
        cmp     dword [rbp-4H], 2                       ; 09A6 _ 83. 7D, FC, 02
        jz      ?_0071                                  ; 09AA _ 74, 0B
        jmp     ?_0078                                  ; 09AC _ EB, 48

?_0070: lea     rax, [rel ?_1000]                       ; 09AE _ 48: 8D. 05, 00000000(rel)
        jmp     ?_0079                                  ; 09B5 _ EB, 46

?_0071: lea     rax, [rel ?_1001]                       ; 09B7 _ 48: 8D. 05, 00000000(rel)
        jmp     ?_0079                                  ; 09BE _ EB, 3D

?_0072: lea     rax, [rel ?_1002]                       ; 09C0 _ 48: 8D. 05, 00000000(rel)
        jmp     ?_0079                                  ; 09C7 _ EB, 34

?_0073: lea     rax, [rel ?_1003]                       ; 09C9 _ 48: 8D. 05, 00000000(rel)
        jmp     ?_0079                                  ; 09D0 _ EB, 2B

?_0074: lea     rax, [rel ?_1004]                       ; 09D2 _ 48: 8D. 05, 00000000(rel)
        jmp     ?_0079                                  ; 09D9 _ EB, 22

?_0075: lea     rax, [rel ?_1005]                       ; 09DB _ 48: 8D. 05, 00000000(rel)
        jmp     ?_0079                                  ; 09E2 _ EB, 19

?_0076: lea     rax, [rel ?_1006]                       ; 09E4 _ 48: 8D. 05, 00000000(rel)
        jmp     ?_0079                                  ; 09EB _ EB, 10

?_0077: lea     rax, [rel ?_1007]                       ; 09ED _ 48: 8D. 05, 00000000(rel)
        jmp     ?_0079                                  ; 09F4 _ EB, 07

?_0078: lea     rax, [rel ?_1008]                       ; 09F6 _ 48: 8D. 05, 00000000(rel)
?_0079: pop     rbp                                     ; 09FD _ 5D
        ret                                             ; 09FE _ C3

warn_overflow:; Local function
        push    rbp                                     ; 09FF _ 55
        mov     rbp, rsp                                ; 0A00 _ 48: 89. E5
        sub     rsp, 64                                 ; 0A03 _ 48: 83. EC, 40
        mov     dword [rbp-24H], edi                    ; 0A07 _ 89. 7D, DC
        mov     qword [rbp-30H], rsi                    ; 0A0A _ 48: 89. 75, D0
        mov     qword [rbp-38H], rdx                    ; 0A0E _ 48: 89. 55, C8
        lea     rax, [rel ?_1009]                       ; 0A12 _ 48: 8D. 05, 00000000(rel)
        mov     qword [rbp-8H], rax                     ; 0A19 _ 48: 89. 45, F8
        mov     rax, qword [rbp-8H]                     ; 0A1D _ 48: 8B. 45, F8
        mov     qword [rbp-10H], rax                    ; 0A21 _ 48: 89. 45, F0
        cmp     qword [rbp-30H], 0                      ; 0A25 _ 48: 83. 7D, D0, 00
        jnz     ?_0080                                  ; 0A2A _ 75, 0D
        add     qword [rbp-10H], 1                      ; 0A2C _ 48: 83. 45, F0, 01
        mov     rax, qword [rbp-10H]                    ; 0A31 _ 48: 8B. 45, F0
        mov     qword [rbp-30H], rax                    ; 0A35 _ 48: 89. 45, D0
?_0080: cmp     qword [rbp-38H], 0                      ; 0A39 _ 48: 83. 7D, C8, 00
        jnz     ?_0081                                  ; 0A3E _ 75, 0D
        add     qword [rbp-8H], 1                       ; 0A40 _ 48: 83. 45, F8, 01
        mov     rax, qword [rbp-8H]                     ; 0A45 _ 48: 8B. 45, F8
        mov     qword [rbp-38H], rax                    ; 0A49 _ 48: 89. 45, C8
?_0081: mov     dword [rbp-14H], 983296                 ; 0A4D _ C7. 45, EC, 000F0100
        mov     eax, dword [rbp-14H]                    ; 0A54 _ 8B. 45, EC
        mov     edi, eax                                ; 0A57 _ 89. C7
        call    warn_active                             ; 0A59 _ E8, FFFFF7F5
        movzx   eax, al                                 ; 0A5E _ 0F B6. C0
        test    rax, rax                                ; 0A61 _ 48: 85. C0
        jz      ?_0082                                  ; 0A64 _ 74, 40
        mov     eax, dword [rbp-24H]                    ; 0A66 _ 8B. 45, DC
        mov     edi, eax                                ; 0A69 _ 89. C7
        call    size_name                               ; 0A6B _ E8, FFFFFED5
        mov     rdi, rax                                ; 0A70 _ 48: 89. C7
        mov     r8, qword [rbp-8H]                      ; 0A73 _ 4C: 8B. 45, F8
        mov     rcx, qword [rbp-10H]                    ; 0A77 _ 48: 8B. 4D, F0
        mov     rdx, qword [rbp-30H]                    ; 0A7B _ 48: 8B. 55, D0
        lea     rsi, [rel ?_1010]                       ; 0A7F _ 48: 8D. 35, 00000000(rel)
        mov     eax, dword [rbp-14H]                    ; 0A86 _ 8B. 45, EC
        sub     rsp, 8                                  ; 0A89 _ 48: 83. EC, 08
        push    qword [rbp-38H]                         ; 0A8D _ FF. 75, C8
        mov     r9, r8                                  ; 0A90 _ 4D: 89. C1
        mov     r8, rdi                                 ; 0A93 _ 49: 89. F8
        mov     edi, eax                                ; 0A96 _ 89. C7
        mov     eax, 0                                  ; 0A98 _ B8, 00000000
        call    nasm_warn_                              ; 0A9D _ E8, 00000000(PLT r)
        add     rsp, 16                                 ; 0AA2 _ 48: 83. C4, 10
?_0082: nop                                             ; 0AA6 _ 90
        leave                                           ; 0AA7 _ C9
        ret                                             ; 0AA8 _ C3

warn_overflow_const:; Local function
        push    rbp                                     ; 0AA9 _ 55
        mov     rbp, rsp                                ; 0AAA _ 48: 89. E5
        sub     rsp, 16                                 ; 0AAD _ 48: 83. EC, 10
        mov     qword [rbp-8H], rdi                     ; 0AB1 _ 48: 89. 7D, F8
        mov     dword [rbp-0CH], esi                    ; 0AB5 _ 89. 75, F4
        mov     edx, dword [rbp-0CH]                    ; 0AB8 _ 8B. 55, F4
        mov     rax, qword [rbp-8H]                     ; 0ABB _ 48: 8B. 45, F8
        mov     esi, edx                                ; 0ABF _ 89. D6
        mov     rdi, rax                                ; 0AC1 _ 48: 89. C7
        call    overflow_general                        ; 0AC4 _ E8, FFFFF643
        test    al, al                                  ; 0AC9 _ 84. C0
        jz      ?_0083                                  ; 0ACB _ 74, 14
        mov     eax, dword [rbp-0CH]                    ; 0ACD _ 8B. 45, F4
        mov     edx, 0                                  ; 0AD0 _ BA, 00000000
        mov     esi, 0                                  ; 0AD5 _ BE, 00000000
        mov     edi, eax                                ; 0ADA _ 89. C7
        call    warn_overflow                           ; 0ADC _ E8, FFFFFF1E
?_0083: nop                                             ; 0AE1 _ 90
        leave                                           ; 0AE2 _ C9
        ret                                             ; 0AE3 _ C3

warn_overflow_out:; Local function
        push    rbp                                     ; 0AE4 _ 55
        mov     rbp, rsp                                ; 0AE5 _ 48: 89. E5
        sub     rsp, 48                                 ; 0AE8 _ 48: 83. EC, 30
        mov     qword [rbp-18H], rdi                    ; 0AEC _ 48: 89. 7D, E8
        mov     dword [rbp-1CH], esi                    ; 0AF0 _ 89. 75, E4
        mov     dword [rbp-20H], edx                    ; 0AF3 _ 89. 55, E0
        mov     qword [rbp-28H], rcx                    ; 0AF6 _ 48: 89. 4D, D8
        mov     eax, dword [rbp-20H]                    ; 0AFA _ 8B. 45, E0
        and     eax, 04H                                ; 0AFD _ 83. E0, 04
        test    eax, eax                                ; 0B00 _ 85. C0
        jne     ?_0087                                  ; 0B02 _ 0F 85, 0000008F
        mov     eax, dword [rbp-20H]                    ; 0B08 _ 8B. 45, E0
        and     eax, 01H                                ; 0B0B _ 83. E0, 01
        test    eax, eax                                ; 0B0E _ 85. C0
        jz      ?_0084                                  ; 0B10 _ 74, 21
        lea     rax, [rel ?_1011]                       ; 0B12 _ 48: 8D. 05, 00000000(rel)
        mov     qword [rbp-8H], rax                     ; 0B19 _ 48: 89. 45, F8
        mov     edx, dword [rbp-1CH]                    ; 0B1D _ 8B. 55, E4
        mov     rax, qword [rbp-18H]                    ; 0B20 _ 48: 8B. 45, E8
        mov     esi, edx                                ; 0B24 _ 89. D6
        mov     rdi, rax                                ; 0B26 _ 48: 89. C7
        call    overflow_signed                         ; 0B29 _ E8, FFFFF57E
        mov     byte [rbp-9H], al                       ; 0B2E _ 88. 45, F7
        jmp     ?_0086                                  ; 0B31 _ EB, 47

?_0084: mov     eax, dword [rbp-20H]                    ; 0B33 _ 8B. 45, E0
        and     eax, 02H                                ; 0B36 _ 83. E0, 02
        test    eax, eax                                ; 0B39 _ 85. C0
        jz      ?_0085                                  ; 0B3B _ 74, 21
        lea     rax, [rel ?_1012]                       ; 0B3D _ 48: 8D. 05, 00000000(rel)
        mov     qword [rbp-8H], rax                     ; 0B44 _ 48: 89. 45, F8
        mov     edx, dword [rbp-1CH]                    ; 0B48 _ 8B. 55, E4
        mov     rax, qword [rbp-18H]                    ; 0B4B _ 48: 8B. 45, E8
        mov     esi, edx                                ; 0B4F _ 89. D6
        mov     rdi, rax                                ; 0B51 _ 48: 89. C7
        call    overflow_unsigned                       ; 0B54 _ E8, FFFFF583
        mov     byte [rbp-9H], al                       ; 0B59 _ 88. 45, F7
        jmp     ?_0086                                  ; 0B5C _ EB, 1C

?_0085: mov     qword [rbp-8H], 0                       ; 0B5E _ 48: C7. 45, F8, 00000000
        mov     edx, dword [rbp-1CH]                    ; 0B66 _ 8B. 55, E4
        mov     rax, qword [rbp-18H]                    ; 0B69 _ 48: 8B. 45, E8
        mov     esi, edx                                ; 0B6D _ 89. D6
        mov     rdi, rax                                ; 0B6F _ 48: 89. C7
        call    overflow_general                        ; 0B72 _ E8, FFFFF595
        mov     byte [rbp-9H], al                       ; 0B77 _ 88. 45, F7
?_0086: cmp     byte [rbp-9H], 0                        ; 0B7A _ 80. 7D, F7, 00
        jz      ?_0088                                  ; 0B7E _ 74, 18
        mov     rdx, qword [rbp-28H]                    ; 0B80 _ 48: 8B. 55, D8
        mov     rcx, qword [rbp-8H]                     ; 0B84 _ 48: 8B. 4D, F8
        mov     eax, dword [rbp-1CH]                    ; 0B88 _ 8B. 45, E4
        mov     rsi, rcx                                ; 0B8B _ 48: 89. CE
        mov     edi, eax                                ; 0B8E _ 89. C7
        call    warn_overflow                           ; 0B90 _ E8, FFFFFE6A
        jmp     ?_0088                                  ; 0B95 _ EB, 01

?_0087: nop                                             ; 0B97 _ 90
?_0088: leave                                           ; 0B98 _ C9
        ret                                             ; 0B99 _ C3

debug_macro_out:; Local function
        push    rbp                                     ; 0B9A _ 55
        mov     rbp, rsp                                ; 0B9B _ 48: 89. E5
        sub     rsp, 48                                 ; 0B9E _ 48: 83. EC, 30
        mov     qword [rbp-28H], rdi                    ; 0BA2 _ 48: 89. 7D, D8
        mov     rax, qword [rbp-28H]                    ; 0BA6 _ 48: 8B. 45, D8
        mov     rax, qword [rax]                        ; 0BAA _ 48: 8B. 00
        mov     qword [rbp-10H], rax                    ; 0BAD _ 48: 89. 45, F0
        mov     rax, qword [rbp-28H]                    ; 0BB1 _ 48: 8B. 45, D8
        mov     rdx, qword [rax+28H]                    ; 0BB5 _ 48: 8B. 50, 28
        mov     rax, qword [rbp-10H]                    ; 0BB9 _ 48: 8B. 45, F0
        add     rax, rdx                                ; 0BBD _ 48: 01. D0
        mov     qword [rbp-8H], rax                     ; 0BC0 _ 48: 89. 45, F8
        mov     rax, qword [rbp-28H]                    ; 0BC4 _ 48: 8B. 45, D8
        mov     eax, dword [rax+8H]                     ; 0BC8 _ 8B. 40, 08
        mov     edi, eax                                ; 0BCB _ 89. C7
        call    debug_macro_get_addr                    ; 0BCD _ E8, 00000000(PLT r)
        mov     qword [rbp-18H], rax                    ; 0BD2 _ 48: 89. 45, E8
        jmp     ?_0091                                  ; 0BD6 _ EB, 3C

?_0089: mov     rax, qword [rbp-18H]                    ; 0BD8 _ 48: 8B. 45, E8
        mov     rax, qword [rax+30H]                    ; 0BDC _ 48: 8B. 40, 30
        test    rax, rax                                ; 0BE0 _ 48: 85. C0
        jnz     ?_0090                                  ; 0BE3 _ 75, 0C
        mov     rax, qword [rbp-18H]                    ; 0BE5 _ 48: 8B. 45, E8
        mov     rdx, qword [rbp-10H]                    ; 0BE9 _ 48: 8B. 55, F0
        mov     qword [rax+28H], rdx                    ; 0BED _ 48: 89. 50, 28
?_0090: mov     rax, qword [rbp-18H]                    ; 0BF1 _ 48: 8B. 45, E8
        mov     rax, qword [rax+28H]                    ; 0BF5 _ 48: 8B. 40, 28
        mov     rdx, qword [rbp-8H]                     ; 0BF9 _ 48: 8B. 55, F8
        sub     rdx, rax                                ; 0BFD _ 48: 29. C2
        mov     rax, qword [rbp-18H]                    ; 0C00 _ 48: 8B. 45, E8
        mov     qword [rax+30H], rdx                    ; 0C04 _ 48: 89. 50, 30
        mov     rax, qword [rbp-18H]                    ; 0C08 _ 48: 8B. 45, E8
        mov     rax, qword [rax+20H]                    ; 0C0C _ 48: 8B. 40, 20
        mov     qword [rbp-18H], rax                    ; 0C10 _ 48: 89. 45, E8
?_0091: cmp     qword [rbp-18H], 0                      ; 0C14 _ 48: 83. 7D, E8, 00
        jnz     ?_0089                                  ; 0C19 _ 75, BD
        nop                                             ; 0C1B _ 90
        nop                                             ; 0C1C _ 90
        leave                                           ; 0C1D _ C9
        ret                                             ; 0C1E _ C3

nasm_ofmt_output:; Local function
        push    rbp                                     ; 0C1F _ 55
        mov     rbp, rsp                                ; 0C20 _ 48: 89. E5
        sub     rsp, 48                                 ; 0C23 _ 48: 83. EC, 30
        mov     qword [rbp-28H], rdi                    ; 0C27 _ 48: 89. 7D, D8
        mov     rax, qword [rbp-28H]                    ; 0C2B _ 48: 8B. 45, D8
        mov     rax, qword [rax+38H]                    ; 0C2F _ 48: 8B. 40, 38
        mov     qword [rbp-10H], rax                    ; 0C33 _ 48: 89. 45, F0
        mov     rax, qword [rbp-28H]                    ; 0C37 _ 48: 8B. 45, D8
        mov     eax, dword [rax+10H]                    ; 0C3B _ 8B. 40, 10
        mov     dword [rbp-1CH], eax                    ; 0C3E _ 89. 45, E4
        mov     rax, qword [rbp-28H]                    ; 0C41 _ 48: 8B. 45, D8
        mov     eax, dword [rax+48H]                    ; 0C45 _ 8B. 40, 48
        mov     dword [rbp-18H], eax                    ; 0C48 _ 89. 45, E8
        mov     rax, qword [rbp-28H]                    ; 0C4B _ 48: 8B. 45, D8
        mov     eax, dword [rax+4CH]                    ; 0C4F _ 8B. 40, 4C
        mov     dword [rbp-14H], eax                    ; 0C52 _ 89. 45, EC
        mov     rax, qword [rbp-28H]                    ; 0C55 _ 48: 8B. 45, D8
        mov     rax, qword [rax+28H]                    ; 0C59 _ 48: 8B. 40, 28
        mov     qword [rbp-8H], rax                     ; 0C5D _ 48: 89. 45, F8
        mov     rax, qword [rbp-28H]                    ; 0C61 _ 48: 8B. 45, D8
        mov     eax, dword [rax+10H]                    ; 0C65 _ 8B. 40, 10
        cmp     eax, 5                                  ; 0C68 _ 83. F8, 05
        je      ?_0099                                  ; 0C6B _ 0F 84, 000000D7
        cmp     eax, 5                                  ; 0C71 _ 83. F8, 05
        ja      ?_0104                                  ; 0C74 _ 0F 87, 00000151
        cmp     eax, 4                                  ; 0C7A _ 83. F8, 04
        jz      ?_0092                                  ; 0C7D _ 74, 32
        cmp     eax, 4                                  ; 0C7F _ 83. F8, 04
        ja      ?_0104                                  ; 0C82 _ 0F 87, 00000143
        cmp     eax, 3                                  ; 0C88 _ 83. F8, 03
        je      ?_0100                                  ; 0C8B _ 0F 84, 000000D1
        cmp     eax, 3                                  ; 0C91 _ 83. F8, 03
        ja      ?_0104                                  ; 0C94 _ 0F 87, 00000131
        cmp     eax, 1                                  ; 0C9A _ 83. F8, 01
        jbe     ?_0102                                  ; 0C9D _ 0F 86, 000000F8
        cmp     eax, 2                                  ; 0CA3 _ 83. F8, 02
        je      ?_0103                                  ; 0CA6 _ 0F 84, 000000FE
        jmp     ?_0104                                  ; 0CAC _ E9, 0000011A

?_0092: mov     rax, qword [rbp-28H]                    ; 0CB1 _ 48: 8B. 45, D8
        mov     rax, qword [rax+28H]                    ; 0CB5 _ 48: 8B. 40, 28
        cmp     rax, 8                                  ; 0CB9 _ 48: 83. F8, 08
        jz      ?_0096                                  ; 0CBD _ 74, 3B
        cmp     rax, 8                                  ; 0CBF _ 48: 83. F8, 08
        ja      ?_0097                                  ; 0CC3 _ 77, 3E
        cmp     rax, 4                                  ; 0CC5 _ 48: 83. F8, 04
        jz      ?_0095                                  ; 0CC9 _ 74, 26
        cmp     rax, 4                                  ; 0CCB _ 48: 83. F8, 04
        ja      ?_0097                                  ; 0CCF _ 77, 32
        cmp     rax, 1                                  ; 0CD1 _ 48: 83. F8, 01
        jz      ?_0093                                  ; 0CD5 _ 74, 08
        cmp     rax, 2                                  ; 0CD7 _ 48: 83. F8, 02
        jz      ?_0094                                  ; 0CDB _ 74, 0B
        jmp     ?_0097                                  ; 0CDD _ EB, 24

?_0093: mov     dword [rbp-1CH], 6                      ; 0CDF _ C7. 45, E4, 00000006
        jmp     ?_0098                                  ; 0CE6 _ EB, 39

?_0094: mov     dword [rbp-1CH], 7                      ; 0CE8 _ C7. 45, E4, 00000007
        jmp     ?_0098                                  ; 0CEF _ EB, 30

?_0095: mov     dword [rbp-1CH], 8                      ; 0CF1 _ C7. 45, E4, 00000008
        jmp     ?_0098                                  ; 0CF8 _ EB, 27

?_0096: mov     dword [rbp-1CH], 9                      ; 0CFA _ C7. 45, E4, 00000009
        jmp     ?_0098                                  ; 0D01 _ EB, 1E

?_0097: lea     rcx, [rel ?_1013]                       ; 0D03 _ 48: 8D. 0D, 00000000(rel)
        lea     rax, [rel __func__.11]                  ; 0D0A _ 48: 8D. 05, 00000000(rel)
        mov     edx, 295                                ; 0D11 _ BA, 00000127
        mov     rsi, rcx                                ; 0D16 _ 48: 89. CE
        mov     rdi, rax                                ; 0D19 _ 48: 89. C7
        call    nasm_panic_from_macro                   ; 0D1C _ E8, 00000000(PLT r)
?_0098: mov     rax, qword [rbp-28H]                    ; 0D21 _ 48: 8B. 45, D8
        add     rax, 64                                 ; 0D25 _ 48: 83. C0, 40
        mov     qword [rbp-10H], rax                    ; 0D29 _ 48: 89. 45, F0
        mov     rax, qword [rbp-28H]                    ; 0D2D _ 48: 8B. 45, D8
        mov     rdx, qword [rax+50H]                    ; 0D31 _ 48: 8B. 50, 50
        mov     rax, qword [rbp-28H]                    ; 0D35 _ 48: 8B. 45, D8
        mov     rax, qword [rax]                        ; 0D39 _ 48: 8B. 00
        sub     rdx, rax                                ; 0D3C _ 48: 29. C2
        mov     qword [rbp-8H], rdx                     ; 0D3F _ 48: 89. 55, F8
        jmp     ?_0105                                  ; 0D43 _ E9, 000000A1

?_0099: mov     dword [rbp-1CH], 3                      ; 0D48 _ C7. 45, E4, 00000003
        cmp     dword [rbp-18H], -1                     ; 0D4F _ 83. 7D, E8, FF
        jz      ?_0100                                  ; 0D53 _ 74, 0D
        cmp     dword [rbp-18H], 1073741823             ; 0D55 _ 81. 7D, E8, 3FFFFFFF
        jg      ?_0100                                  ; 0D5C _ 7F, 04
        or      dword [rbp-18H], 01H                    ; 0D5E _ 83. 4D, E8, 01
?_0100: mov     rax, qword [rbp-28H]                    ; 0D62 _ 48: 8B. 45, D8
        add     rax, 64                                 ; 0D66 _ 48: 83. C0, 40
        mov     qword [rbp-10H], rax                    ; 0D6A _ 48: 89. 45, F0
        mov     rax, qword [rbp-28H]                    ; 0D6E _ 48: 8B. 45, D8
        mov     eax, dword [rax+14H]                    ; 0D72 _ 8B. 40, 14
        and     eax, 01H                                ; 0D75 _ 83. E0, 01
        test    eax, eax                                ; 0D78 _ 85. C0
        jz      ?_0101                                  ; 0D7A _ 74, 11
        mov     rax, qword [rbp-28H]                    ; 0D7C _ 48: 8B. 45, D8
        mov     rax, qword [rax+28H]                    ; 0D80 _ 48: 8B. 40, 28
        neg     rax                                     ; 0D84 _ 48: F7. D8
        mov     qword [rbp-8H], rax                     ; 0D87 _ 48: 89. 45, F8
        jmp     ?_0105                                  ; 0D8B _ EB, 5C

?_0101: mov     rax, qword [rbp-28H]                    ; 0D8D _ 48: 8B. 45, D8
        mov     rax, qword [rax+28H]                    ; 0D91 _ 48: 8B. 40, 28
        mov     qword [rbp-8H], rax                     ; 0D95 _ 48: 89. 45, F8
        jmp     ?_0105                                  ; 0D99 _ EB, 4E

?_0102: mov     dword [rbp-14H], -1                     ; 0D9B _ C7. 45, EC, FFFFFFFF
        mov     eax, dword [rbp-14H]                    ; 0DA2 _ 8B. 45, EC
        mov     dword [rbp-18H], eax                    ; 0DA5 _ 89. 45, E8
        jmp     ?_0105                                  ; 0DA8 _ EB, 3F

?_0103: mov     dword [rbp-14H], -1                     ; 0DAA _ C7. 45, EC, FFFFFFFF
        mov     eax, dword [rbp-14H]                    ; 0DB1 _ 8B. 45, EC
        mov     dword [rbp-18H], eax                    ; 0DB4 _ 89. 45, E8
        mov     dword [rbp-1CH], 0                      ; 0DB7 _ C7. 45, E4, 00000000
        lea     rax, [rel zero_buffer]                  ; 0DBE _ 48: 8D. 05, 00000000(rel)
        mov     qword [rbp-10H], rax                    ; 0DC5 _ 48: 89. 45, F0
        jmp     ?_0105                                  ; 0DC9 _ EB, 1E

?_0104: lea     rcx, [rel ?_1013]                       ; 0DCB _ 48: 8D. 0D, 00000000(rel)
        lea     rax, [rel __func__.11]                  ; 0DD2 _ 48: 8D. 05, 00000000(rel)
        mov     edx, 326                                ; 0DD9 _ BA, 00000146
        mov     rsi, rcx                                ; 0DDE _ 48: 89. CE
        mov     rdi, rax                                ; 0DE1 _ 48: 89. C7
        call    nasm_panic_from_macro                   ; 0DE4 _ E8, 00000000(PLT r)
?_0105: mov     rax, qword [rbp-28H]                    ; 0DE9 _ 48: 8B. 45, D8
        mov     rdx, qword [rbp-10H]                    ; 0DED _ 48: 8B. 55, F0
        mov     qword [rax+70H], rdx                    ; 0DF1 _ 48: 89. 50, 70
        mov     rax, qword [rbp-28H]                    ; 0DF5 _ 48: 8B. 45, D8
        mov     edx, dword [rbp-1CH]                    ; 0DF9 _ 8B. 55, E4
        mov     dword [rax+78H], edx                    ; 0DFC _ 89. 50, 78
        mov     rax, qword [rbp-28H]                    ; 0DFF _ 48: 8B. 45, D8
        mov     rdx, qword [rbp-8H]                     ; 0E03 _ 48: 8B. 55, F8
        mov     qword [rax+80H], rdx                    ; 0E07 _ 48: 89. 90, 00000080
        mov     rax, qword [rbp-28H]                    ; 0E0E _ 48: 8B. 45, D8
        mov     edx, dword [rbp-18H]                    ; 0E12 _ 8B. 55, E8
        mov     dword [rax+88H], edx                    ; 0E15 _ 89. 90, 00000088
        mov     rax, qword [rbp-28H]                    ; 0E1B _ 48: 8B. 45, D8
        mov     edx, dword [rbp-14H]                    ; 0E1F _ 8B. 55, EC
        mov     dword [rax+8CH], edx                    ; 0E22 _ 89. 90, 0000008C
        mov     rax, qword [rel ofmt]                   ; 0E28 _ 48: 8B. 05, 00000000(rel)
        mov     rdx, qword [rax+48H]                    ; 0E2F _ 48: 8B. 50, 48
        mov     rax, qword [rbp-28H]                    ; 0E33 _ 48: 8B. 45, D8
        mov     rdi, rax                                ; 0E37 _ 48: 89. C7
        call    rdx                                     ; 0E3A _ FF. D2
        nop                                             ; 0E3C _ 90
        leave                                           ; 0E3D _ C9
        ret                                             ; 0E3E _ C3

out:    ; Local function
        push    rbp                                     ; 0E3F _ 55
        mov     rbp, rsp                                ; 0E40 _ 48: 89. E5
        push    rbx                                     ; 0E43 _ 53
        sub     rsp, 120                                ; 0E44 _ 48: 83. EC, 78
        mov     qword [rbp-78H], rdi                    ; 0E48 _ 48: 89. 7D, 88
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        mov     rax, qword [fs:abs 28H]                 ; 0E4C _ 64 48: 8B. 04 25, 00000028
        mov     qword [rbp-18H], rax                    ; 0E55 _ 48: 89. 45, E8
        xor     eax, eax                                ; 0E59 _ 31. C0
        mov     qword [rbp-48H], 0                      ; 0E5B _ 48: C7. 45, B8, 00000000
        mov     rax, qword [rbp-78H]                    ; 0E63 _ 48: 8B. 45, 88
        mov     rax, qword [rax+28H]                    ; 0E67 _ 48: 8B. 40, 28
        test    rax, rax                                ; 0E6B _ 48: 85. C0
        je      ?_0148                                  ; 0E6E _ 0F 84, 000006B5
        mov     rax, qword [rbp-78H]                    ; 0E74 _ 48: 8B. 45, 88
        mov     rax, qword [rax+28H]                    ; 0E78 _ 48: 8B. 40, 28
        mov     qword [rbp-28H], rax                    ; 0E7C _ 48: 89. 45, D8
        mov     rax, qword [rbp-78H]                    ; 0E80 _ 48: 8B. 45, 88
        mov     eax, dword [rax+10H]                    ; 0E84 _ 8B. 40, 10
        cmp     eax, 5                                  ; 0E87 _ 83. F8, 05
        je      ?_0129                                  ; 0E8A _ 0F 84, 000002D2
        cmp     eax, 5                                  ; 0E90 _ 83. F8, 05
        ja      ?_0131                                  ; 0E93 _ 0F 87, 00000318
        cmp     eax, 3                                  ; 0E99 _ 83. F8, 03
        jz      ?_0106                                  ; 0E9C _ 74, 0A
        cmp     eax, 4                                  ; 0E9E _ 83. F8, 04
        jz      ?_0107                                  ; 0EA1 _ 74, 1A
        jmp     ?_0131                                  ; 0EA3 _ E9, 00000309

?_0106: mov     rax, qword [rbp-78H]                    ; 0EA8 _ 48: 8B. 45, 88
        mov     rax, qword [rax+40H]                    ; 0EAC _ 48: 8B. 40, 40
        mov     qword [rbp-40H], rax                    ; 0EB0 _ 48: 89. 45, C0
        mov     dword [rbp-68H], -1                     ; 0EB4 _ C7. 45, 98, FFFFFFFF
        jmp     ?_0108                                  ; 0EBB _ EB, 28

?_0107: mov     rax, qword [rbp-78H]                    ; 0EBD _ 48: 8B. 45, 88
        mov     rdx, qword [rax+40H]                    ; 0EC1 _ 48: 8B. 50, 40
        mov     rax, qword [rbp-78H]                    ; 0EC5 _ 48: 8B. 45, 88
        mov     rax, qword [rax+50H]                    ; 0EC9 _ 48: 8B. 40, 50
        mov     rcx, rax                                ; 0ECD _ 48: 89. C1
        mov     rax, rdx                                ; 0ED0 _ 48: 89. D0
        sub     rax, rcx                                ; 0ED3 _ 48: 29. C8
        mov     qword [rbp-40H], rax                    ; 0ED6 _ 48: 89. 45, C0
        mov     rax, qword [rbp-78H]                    ; 0EDA _ 48: 8B. 45, 88
        mov     eax, dword [rax+8H]                     ; 0EDE _ 8B. 40, 08
        mov     dword [rbp-68H], eax                    ; 0EE1 _ 89. 45, 98
        nop                                             ; 0EE4 _ 90
?_0108: mov     rax, qword [rbp-78H]                    ; 0EE5 _ 48: 8B. 45, 88
        mov     rax, qword [rax+28H]                    ; 0EE9 _ 48: 8B. 40, 28
        cmp     rax, 8                                  ; 0EED _ 48: 83. F8, 08
        seta    al                                      ; 0EF1 _ 0F 97. C0
        movzx   eax, al                                 ; 0EF4 _ 0F B6. C0
        test    rax, rax                                ; 0EF7 _ 48: 85. C0
        jz      ?_0109                                  ; 0EFA _ 74, 22
        lea     rdx, [rel ?_1013]                       ; 0EFC _ 48: 8D. 15, 00000000(rel)
        lea     rsi, [rel __func__.10]                  ; 0F03 _ 48: 8D. 35, 00000000(rel)
        lea     rax, [rel ?_1014]                       ; 0F0A _ 48: 8D. 05, 00000000(rel)
        mov     ecx, 376                                ; 0F11 _ B9, 00000178
        mov     rdi, rax                                ; 0F16 _ 48: 89. C7
        call    nasm_assert_failed                      ; 0F19 _ E8, 00000000(PLT r)
?_0109: mov     rax, qword [rbp-78H]                    ; 0F1E _ 48: 8B. 45, 88
        mov     rax, qword [rax+28H]                    ; 0F22 _ 48: 8B. 40, 28
        mov     qword [rbp-58H], rax                    ; 0F26 _ 48: 89. 45, A8
        mov     rax, qword [rel ofmt]                   ; 0F2A _ 48: 8B. 05, 00000000(rel)
        mov     eax, dword [rax+1CH]                    ; 0F31 _ 8B. 40, 1C
        sar     eax, 3                                  ; 0F34 _ C1. F8, 03
        cdqe                                            ; 0F37 _ 48: 98
        mov     qword [rbp-50H], rax                    ; 0F39 _ 48: 89. 45, B0
        mov     rax, qword [rbp-78H]                    ; 0F3D _ 48: 8B. 45, 88
        mov     eax, dword [rax+48H]                    ; 0F41 _ 8B. 40, 48
        cmp     dword [rbp-68H], eax                    ; 0F44 _ 39. 45, 98
        jne     ?_0111                                  ; 0F47 _ 0F 85, 000000A7
        mov     rax, qword [rbp-78H]                    ; 0F4D _ 48: 8B. 45, 88
        mov     eax, dword [rax+4CH]                    ; 0F51 _ 8B. 40, 4C
        cmp     eax, -1                                 ; 0F54 _ 83. F8, FF
        jne     ?_0111                                  ; 0F57 _ 0F 85, 00000097
        mov     rax, qword [rel ofmt]                   ; 0F5D _ 48: 8B. 05, 00000000(rel)
        mov     eax, dword [rax+18H]                    ; 0F64 _ 8B. 40, 18
        and     eax, 02H                                ; 0F67 _ 83. E0, 02
        test    eax, eax                                ; 0F6A _ 85. C0
        jne     ?_0128                                  ; 0F6C _ 0F 85, 000001EE
        mov     rax, qword [rbp-78H]                    ; 0F72 _ 48: 8B. 45, 88
        mov     eax, dword [rax+20H]                    ; 0F76 _ 8B. 40, 20
        sar     eax, 3                                  ; 0F79 _ C1. F8, 03
        cdqe                                            ; 0F7C _ 48: 98
        cmp     qword [rbp-58H], rax                    ; 0F7E _ 48: 39. 45, A8
        jc      ?_0110                                  ; 0F82 _ 72, 13
        mov     rax, qword [rbp-78H]                    ; 0F84 _ 48: 8B. 45, 88
        mov     eax, dword [rax+14H]                    ; 0F88 _ 8B. 40, 14
        and     eax, 0FFFFFFFCH                         ; 0F8B _ 83. E0, FC
        mov     edx, eax                                ; 0F8E _ 89. C2
        mov     rax, qword [rbp-78H]                    ; 0F90 _ 48: 8B. 45, 88
        mov     dword [rax+14H], edx                    ; 0F94 _ 89. 50, 14
?_0110: mov     rax, qword [rbp-78H]                    ; 0F97 _ 48: 8B. 45, 88
        mov     rcx, qword [rax+68H]                    ; 0F9B _ 48: 8B. 48, 68
        mov     rax, qword [rbp-78H]                    ; 0F9F _ 48: 8B. 45, 88
        mov     edx, dword [rax+14H]                    ; 0FA3 _ 8B. 50, 14
        mov     rax, qword [rbp-58H]                    ; 0FA6 _ 48: 8B. 45, A8
        mov     esi, eax                                ; 0FAA _ 89. C6
        mov     rax, qword [rbp-40H]                    ; 0FAC _ 48: 8B. 45, C0
        mov     rdi, rax                                ; 0FB0 _ 48: 89. C7
        call    warn_overflow_out                       ; 0FB3 _ E8, FFFFFB2C
        mov     rax, qword [rbp-40H]                    ; 0FB8 _ 48: 8B. 45, C0
        mov     rdi, rax                                ; 0FBC _ 48: 89. C7
        call    __uint64_identity                       ; 0FBF _ E8, FFFFF048
        mov     qword [rbp-20H], rax                    ; 0FC4 _ 48: 89. 45, E0
        mov     rax, qword [rbp-78H]                    ; 0FC8 _ 48: 8B. 45, 88
        lea     rdx, [rbp-20H]                          ; 0FCC _ 48: 8D. 55, E0
        mov     qword [rax+38H], rdx                    ; 0FD0 _ 48: 89. 50, 38
        mov     rax, qword [rbp-78H]                    ; 0FD4 _ 48: 8B. 45, 88
        mov     dword [rax+10H], 0                      ; 0FD8 _ C7. 40, 10, 00000000
        mov     qword [rbp-50H], 0                      ; 0FDF _ 48: C7. 45, B0, 00000000
        mov     rax, qword [rbp-50H]                    ; 0FE7 _ 48: 8B. 45, B0
        mov     qword [rbp-58H], rax                    ; 0FEB _ 48: 89. 45, A8
        jmp     ?_0128                                  ; 0FEF _ E9, 0000016C

?_0111: mov     rax, qword [rbp-78H]                    ; 0FF4 _ 48: 8B. 45, 88
        mov     eax, dword [rax+10H]                    ; 0FF8 _ 8B. 40, 10
        cmp     eax, 3                                  ; 0FFB _ 83. F8, 03
        jz      ?_0112                                  ; 0FFE _ 74, 0E
        cmp     eax, 4                                  ; 1000 _ 83. F8, 04
        je      ?_0119                                  ; 1003 _ 0F 84, 00000083
        jmp     ?_0126                                  ; 1009 _ E9, 000000F9

?_0112: lea     rax, [rel ?_1015]                       ; 100E _ 48: 8D. 05, 00000000(rel)
        mov     qword [rbp-38H], rax                    ; 1015 _ 48: 89. 45, C8
        cmp     qword [rbp-58H], 8                      ; 1019 _ 48: 83. 7D, A8, 08
        jz      ?_0116                                  ; 101E _ 74, 40
        cmp     qword [rbp-58H], 8                      ; 1020 _ 48: 83. 7D, A8, 08
        ja      ?_0117                                  ; 1025 _ 77, 42
        cmp     qword [rbp-58H], 4                      ; 1027 _ 48: 83. 7D, A8, 04
        jz      ?_0115                                  ; 102C _ 74, 29
        cmp     qword [rbp-58H], 4                      ; 102E _ 48: 83. 7D, A8, 04
        ja      ?_0117                                  ; 1033 _ 77, 34
        cmp     qword [rbp-58H], 1                      ; 1035 _ 48: 83. 7D, A8, 01
        jz      ?_0113                                  ; 103A _ 74, 09
        cmp     qword [rbp-58H], 2                      ; 103C _ 48: 83. 7D, A8, 02
        jz      ?_0114                                  ; 1041 _ 74, 0B
        jmp     ?_0117                                  ; 1043 _ EB, 24

?_0113: mov     dword [rbp-64H], 3538944                ; 1045 _ C7. 45, 9C, 00360000
        jmp     ?_0118                                  ; 104C _ EB, 39

?_0114: mov     dword [rbp-64H], 3735552                ; 104E _ C7. 45, 9C, 00390000
        jmp     ?_0118                                  ; 1055 _ EB, 30

?_0115: mov     dword [rbp-64H], 3604480                ; 1057 _ C7. 45, 9C, 00370000
        jmp     ?_0118                                  ; 105E _ EB, 27

?_0116: mov     dword [rbp-64H], 3670016                ; 1060 _ C7. 45, 9C, 00380000
        jmp     ?_0118                                  ; 1067 _ EB, 1E

?_0117: lea     rcx, [rel ?_1013]                       ; 1069 _ 48: 8D. 0D, 00000000(rel)
        lea     rax, [rel __func__.10]                  ; 1070 _ 48: 8D. 05, 00000000(rel)
        mov     edx, 403                                ; 1077 _ BA, 00000193
        mov     rsi, rcx                                ; 107C _ 48: 89. CE
        mov     rdi, rax                                ; 107F _ 48: 89. C7
        call    nasm_panic_from_macro                   ; 1082 _ E8, 00000000(PLT r)
?_0118: jmp     ?_0127                                  ; 1087 _ E9, 00000082

?_0119: lea     rax, [rel ?_1016]                       ; 108C _ 48: 8D. 05, 00000000(rel)
        mov     qword [rbp-38H], rax                    ; 1093 _ 48: 89. 45, C8
        cmp     qword [rbp-58H], 8                      ; 1097 _ 48: 83. 7D, A8, 08
        jz      ?_0123                                  ; 109C _ 74, 40
        cmp     qword [rbp-58H], 8                      ; 109E _ 48: 83. 7D, A8, 08
        ja      ?_0124                                  ; 10A3 _ 77, 42
        cmp     qword [rbp-58H], 4                      ; 10A5 _ 48: 83. 7D, A8, 04
        jz      ?_0122                                  ; 10AA _ 74, 29
        cmp     qword [rbp-58H], 4                      ; 10AC _ 48: 83. 7D, A8, 04
        ja      ?_0124                                  ; 10B1 _ 77, 34
        cmp     qword [rbp-58H], 1                      ; 10B3 _ 48: 83. 7D, A8, 01
        jz      ?_0120                                  ; 10B8 _ 74, 09
        cmp     qword [rbp-58H], 2                      ; 10BA _ 48: 83. 7D, A8, 02
        jz      ?_0121                                  ; 10BF _ 74, 0B
        jmp     ?_0124                                  ; 10C1 _ EB, 24

?_0120: mov     dword [rbp-64H], 3801088                ; 10C3 _ C7. 45, 9C, 003A0000
        jmp     ?_0125                                  ; 10CA _ EB, 39

?_0121: mov     dword [rbp-64H], 3997696                ; 10CC _ C7. 45, 9C, 003D0000
        jmp     ?_0125                                  ; 10D3 _ EB, 30

?_0122: mov     dword [rbp-64H], 3866624                ; 10D5 _ C7. 45, 9C, 003B0000
        jmp     ?_0125                                  ; 10DC _ EB, 27

?_0123: mov     dword [rbp-64H], 3932160                ; 10DE _ C7. 45, 9C, 003C0000
        jmp     ?_0125                                  ; 10E5 _ EB, 1E

?_0124: lea     rcx, [rel ?_1013]                       ; 10E7 _ 48: 8D. 0D, 00000000(rel)
        lea     rax, [rel __func__.10]                  ; 10EE _ 48: 8D. 05, 00000000(rel)
        mov     edx, 413                                ; 10F5 _ BA, 0000019D
        mov     rsi, rcx                                ; 10FA _ 48: 89. CE
        mov     rdi, rax                                ; 10FD _ 48: 89. C7
        call    nasm_panic_from_macro                   ; 1100 _ E8, 00000000(PLT r)
?_0125: jmp     ?_0127                                  ; 1105 _ EB, 07

?_0126: mov     dword [rbp-64H], 0                      ; 1107 _ C7. 45, 9C, 00000000
?_0127: cmp     dword [rbp-64H], 0                      ; 110E _ 83. 7D, 9C, 00
        je      ?_0132                                  ; 1112 _ 0F 84, 000000AB
        mov     eax, dword [rbp-64H]                    ; 1118 _ 8B. 45, 9C
        mov     dword [rbp-60H], eax                    ; 111B _ 89. 45, A0
        mov     eax, dword [rbp-60H]                    ; 111E _ 8B. 45, A0
        mov     edi, eax                                ; 1121 _ 89. C7
        call    warn_active                             ; 1123 _ E8, FFFFF12B
        movzx   eax, al                                 ; 1128 _ 0F B6. C0
        test    rax, rax                                ; 112B _ 48: 85. C0
        je      ?_0132                                  ; 112E _ 0F 84, 0000008F
        mov     rax, qword [rbp-58H]                    ; 1134 _ 48: 8B. 45, A8
        lea     edi, [rax*8]                            ; 1138 _ 8D. 3C C5, 00000000
        mov     rdx, qword [rbp-38H]                    ; 113F _ 48: 8B. 55, C8
        lea     rsi, [rel ?_1017]                       ; 1143 _ 48: 8D. 35, 00000000(rel)
        mov     eax, dword [rbp-60H]                    ; 114A _ 8B. 45, A0
        mov     rcx, rdx                                ; 114D _ 48: 89. D1
        mov     edx, edi                                ; 1150 _ 89. FA
        mov     edi, eax                                ; 1152 _ 89. C7
        mov     eax, 0                                  ; 1154 _ B8, 00000000
        call    nasm_warn_                              ; 1159 _ E8, 00000000(PLT r)
        jmp     ?_0132                                  ; 115E _ EB, 63

?_0128: jmp     ?_0132                                  ; 1160 _ EB, 61

?_0129: mov     rax, qword [rbp-78H]                    ; 1162 _ 48: 8B. 45, 88
        mov     rax, qword [rax+28H]                    ; 1166 _ 48: 8B. 40, 28
        cmp     rax, 8                                  ; 116A _ 48: 83. F8, 08
        seta    al                                      ; 116E _ 0F 97. C0
        movzx   eax, al                                 ; 1171 _ 0F B6. C0
        test    rax, rax                                ; 1174 _ 48: 85. C0
        jz      ?_0130                                  ; 1177 _ 74, 22
        lea     rdx, [rel ?_1013]                       ; 1179 _ 48: 8D. 15, 00000000(rel)
        lea     rsi, [rel __func__.10]                  ; 1180 _ 48: 8D. 35, 00000000(rel)
        lea     rax, [rel ?_1014]                       ; 1187 _ 48: 8D. 05, 00000000(rel)
        mov     ecx, 428                                ; 118E _ B9, 000001AC
        mov     rdi, rax                                ; 1193 _ 48: 89. C7
        call    nasm_assert_failed                      ; 1196 _ E8, 00000000(PLT r)
?_0130: mov     rax, qword [rbp-78H]                    ; 119B _ 48: 8B. 45, 88
        mov     rax, qword [rax+28H]                    ; 119F _ 48: 8B. 40, 28
        mov     qword [rbp-58H], rax                    ; 11A3 _ 48: 89. 45, A8
        mov     qword [rbp-50H], 2                      ; 11A7 _ 48: C7. 45, B0, 00000002
        jmp     ?_0133                                  ; 11AF _ EB, 13

?_0131: mov     qword [rbp-50H], 0                      ; 11B1 _ 48: C7. 45, B0, 00000000
        mov     rax, qword [rbp-50H]                    ; 11B9 _ 48: 8B. 45, B0
        mov     qword [rbp-58H], rax                    ; 11BD _ 48: 89. 45, A8
        jmp     ?_0133                                  ; 11C1 _ EB, 01

?_0132: nop                                             ; 11C3 _ 90
?_0133: mov     rbx, qword [rbp-78H]                    ; 11C4 _ 48: 8B. 5D, 88
        call    src_where                               ; 11C8 _ E8, FFFFF072
        mov     qword [rbx+58H], rax                    ; 11CD _ 48: 89. 43, 58
        mov     qword [rbx+60H], rdx                    ; 11D1 _ 48: 89. 53, 60
        mov     rax, qword [rbp-78H]                    ; 11D5 _ 48: 8B. 45, 88
        mov     rax, qword [rax+58H]                    ; 11D9 _ 48: 8B. 40, 58
        test    rax, rax                                ; 11DD _ 48: 85. C0
        je      ?_0134                                  ; 11E0 _ 0F 84, 00000094
        mov     rax, qword [rel dbg.9]                  ; 11E6 _ 48: 8B. 05, 00000000(rel)
        mov     rdx, qword [rel ?_0997]                 ; 11ED _ 48: 8B. 15, 00000000(rel)
        mov     rcx, qword [rbp-78H]                    ; 11F4 _ 48: 8B. 4D, 88
        mov     rdi, qword [rcx+58H]                    ; 11F8 _ 48: 8B. 79, 58
        mov     rsi, qword [rcx+60H]                    ; 11FC _ 48: 8B. 71, 60
        mov     rcx, rdx                                ; 1200 _ 48: 89. D1
        mov     rdx, rax                                ; 1203 _ 48: 89. C2
        call    src_location_same                       ; 1206 _ E8, FFFFEFE7
        xor     eax, 01H                                ; 120B _ 83. F0, 01
        movzx   edx, al                                 ; 120E _ 0F B6. D0
        mov     rax, qword [rbp-78H]                    ; 1211 _ 48: 8B. 45, 88
        mov     ecx, dword [rax+8H]                     ; 1215 _ 8B. 48, 08
        mov     eax, dword [rel ?_0998]                 ; 1218 _ 8B. 05, 00000000(rel)
        cmp     ecx, eax                                ; 121E _ 39. C1
        setne   al                                      ; 1220 _ 0F 95. C0
        movzx   eax, al                                 ; 1223 _ 0F B6. C0
        or      eax, edx                                ; 1226 _ 09. D0
        test    eax, eax                                ; 1228 _ 85. C0
        jz      ?_0134                                  ; 122A _ 74, 4E
        mov     rax, qword [rbp-78H]                    ; 122C _ 48: 8B. 45, 88
        mov     rdx, qword [rax+60H]                    ; 1230 _ 48: 8B. 50, 60
        mov     rax, qword [rax+58H]                    ; 1234 _ 48: 8B. 40, 58
        mov     qword [rel dbg.9], rax                  ; 1238 _ 48: 89. 05, 00000000(rel)
        mov     qword [rel ?_0997], rdx                 ; 123F _ 48: 89. 15, 00000000(rel)
        mov     rax, qword [rbp-78H]                    ; 1246 _ 48: 8B. 45, 88
        mov     eax, dword [rax+8H]                     ; 124A _ 8B. 40, 08
        mov     dword [rel ?_0998], eax                 ; 124D _ 89. 05, 00000000(rel)
        mov     rax, qword [rel dfmt]                   ; 1253 _ 48: 8B. 05, 00000000(rel)
        mov     r8, qword [rax+18H]                     ; 125A _ 4C: 8B. 40, 18
        mov     rax, qword [rbp-78H]                    ; 125E _ 48: 8B. 45, 88
        mov     edx, dword [rax+8H]                     ; 1262 _ 8B. 50, 08
        mov     ecx, dword [rel ?_0997]                 ; 1265 _ 8B. 0D, 00000000(rel)
        mov     rax, qword [rel dbg.9]                  ; 126B _ 48: 8B. 05, 00000000(rel)
        mov     esi, ecx                                ; 1272 _ 89. CE
        mov     rdi, rax                                ; 1274 _ 48: 89. C7
        call    r8                                      ; 1277 _ 41: FF. D0
?_0134: mov     rax, qword [rbp-58H]                    ; 127A _ 48: 8B. 45, A8
        cmp     qword [rbp-50H], rax                    ; 127E _ 48: 39. 45, B0
        jnc     ?_0140                                  ; 1282 _ 0F 83, 000000C6
        mov     rax, qword [rbp-78H]                    ; 1288 _ 48: 8B. 45, 88
        mov     eax, dword [rax+10H]                    ; 128C _ 8B. 40, 10
        cmp     eax, 4                                  ; 128F _ 83. F8, 04
        jz      ?_0135                                  ; 1292 _ 74, 0E
        mov     rax, qword [rbp-78H]                    ; 1294 _ 48: 8B. 45, 88
        mov     eax, dword [rax+14H]                    ; 1298 _ 8B. 40, 14
        and     eax, 01H                                ; 129B _ 83. E0, 01
        test    eax, eax                                ; 129E _ 85. C0
        jz      ?_0136                                  ; 12A0 _ 74, 2F
?_0135: mov     rax, qword [rel ofmt]                   ; 12A2 _ 48: 8B. 05, 00000000(rel)
        mov     rax, qword [rax+8H]                     ; 12A9 _ 48: 8B. 40, 08
        mov     rdx, qword [rbp-58H]                    ; 12AD _ 48: 8B. 55, A8
        lea     esi, [rdx*8]                            ; 12B1 _ 8D. 34 D5, 00000000
        lea     rcx, [rel ?_1018]                       ; 12B8 _ 48: 8D. 0D, 00000000(rel)
        mov     rdx, rax                                ; 12BF _ 48: 89. C2
        mov     rdi, rcx                                ; 12C2 _ 48: 89. CF
        mov     eax, 0                                  ; 12C5 _ B8, 00000000
        call    nasm_nonfatal                           ; 12CA _ E8, 00000000(PLT r)
        jmp     ?_0139                                  ; 12CF _ EB, 61

?_0136: mov     dword [rbp-5CH], 4390912                ; 12D1 _ C7. 45, A4, 00430000
        mov     eax, dword [rbp-5CH]                    ; 12D8 _ 8B. 45, A4
        mov     edi, eax                                ; 12DB _ 89. C7
        call    warn_active                             ; 12DD _ E8, FFFFEF71
        movzx   eax, al                                 ; 12E2 _ 0F B6. C0
        test    rax, rax                                ; 12E5 _ 48: 85. C0
        jz      ?_0139                                  ; 12E8 _ 74, 48
        mov     rax, qword [rbp-50H]                    ; 12EA _ 48: 8B. 45, B0
        lea     ecx, [rax*8]                            ; 12EE _ 8D. 0C C5, 00000000
        mov     rax, qword [rbp-78H]                    ; 12F5 _ 48: 8B. 45, 88
        mov     eax, dword [rax+10H]                    ; 12F9 _ 8B. 40, 10
        cmp     eax, 5                                  ; 12FC _ 83. F8, 05
        jnz     ?_0137                                  ; 12FF _ 75, 09
        lea     rax, [rel ?_1019]                       ; 1301 _ 48: 8D. 05, 00000000(rel)
        jmp     ?_0138                                  ; 1308 _ EB, 07

?_0137: lea     rax, [rel ?_1012]                       ; 130A _ 48: 8D. 05, 00000000(rel)
?_0138: mov     rdx, qword [rbp-58H]                    ; 1311 _ 48: 8B. 55, A8
        shl     edx, 3                                  ; 1315 _ C1. E2, 03
        lea     rsi, [rel ?_1020]                       ; 1318 _ 48: 8D. 35, 00000000(rel)
        mov     edi, dword [rbp-5CH]                    ; 131F _ 8B. 7D, A4
        mov     r8d, ecx                                ; 1322 _ 41: 89. C8
        mov     rcx, rax                                ; 1325 _ 48: 89. C1
        mov     eax, 0                                  ; 1328 _ B8, 00000000
        call    nasm_warn_                              ; 132D _ E8, 00000000(PLT r)
?_0139: mov     rax, qword [rbp-78H]                    ; 1332 _ 48: 8B. 45, 88
        mov     rax, qword [rax+28H]                    ; 1336 _ 48: 8B. 40, 28
        sub     rax, qword [rbp-50H]                    ; 133A _ 48: 2B. 45, B0
        mov     qword [rbp-48H], rax                    ; 133E _ 48: 89. 45, B8
        mov     rax, qword [rbp-78H]                    ; 1342 _ 48: 8B. 45, 88
        mov     rdx, qword [rbp-50H]                    ; 1346 _ 48: 8B. 55, B0
        mov     qword [rax+28H], rdx                    ; 134A _ 48: 89. 50, 28
?_0140: mov     rax, qword [rel lfmt]                   ; 134E _ 48: 8B. 05, 00000000(rel)
        mov     rdx, qword [rax+10H]                    ; 1355 _ 48: 8B. 50, 10
        mov     rax, qword [rbp-78H]                    ; 1359 _ 48: 8B. 45, 88
        mov     rdi, rax                                ; 135D _ 48: 89. C7
        call    rdx                                     ; 1360 _ FF. D2
        mov     rax, qword [rbp-78H]                    ; 1362 _ 48: 8B. 45, 88
        mov     eax, dword [rax+8H]                     ; 1366 _ 8B. 40, 08
        cmp     eax, -1                                 ; 1369 _ 83. F8, FF
        setne   al                                      ; 136C _ 0F 95. C0
        movzx   eax, al                                 ; 136F _ 0F B6. C0
        test    rax, rax                                ; 1372 _ 48: 85. C0
        je      ?_0145                                  ; 1375 _ 0F 84, 000000C8
        mov     rax, qword [rel debug_current_macro]    ; 137B _ 48: 8B. 05, 00000000(rel)
        test    rax, rax                                ; 1382 _ 48: 85. C0
        jz      ?_0141                                  ; 1385 _ 74, 0C
        mov     rax, qword [rbp-78H]                    ; 1387 _ 48: 8B. 45, 88
        mov     rdi, rax                                ; 138B _ 48: 89. C7
        call    debug_macro_out                         ; 138E _ E8, FFFFF807
?_0141: mov     rax, qword [rbp-78H]                    ; 1393 _ 48: 8B. 45, 88
        mov     eax, dword [rax+10H]                    ; 1397 _ 8B. 40, 10
        cmp     eax, 2                                  ; 139A _ 83. F8, 02
        sete    al                                      ; 139D _ 0F 94. C0
        movzx   eax, al                                 ; 13A0 _ 0F B6. C0
        test    rax, rax                                ; 13A3 _ 48: 85. C0
        je      ?_0144                                  ; 13A6 _ 0F 84, 00000089
        mov     rax, qword [rel ofmt]                   ; 13AC _ 48: 8B. 05, 00000000(rel)
        mov     eax, dword [rax+18H]                    ; 13B3 _ 8B. 40, 18
        and     eax, 04H                                ; 13B6 _ 83. E0, 04
        test    eax, eax                                ; 13B9 _ 85. C0
        jnz     ?_0144                                  ; 13BB _ 75, 78
        mov     rax, qword [rbp-78H]                    ; 13BD _ 48: 8B. 45, 88
        mov     rax, qword [rax+28H]                    ; 13C1 _ 48: 8B. 40, 28
        mov     qword [rbp-30H], rax                    ; 13C5 _ 48: 89. 45, D0
        jmp     ?_0143                                  ; 13C9 _ EB, 54

?_0142: mov     rax, qword [rbp-78H]                    ; 13CB _ 48: 8B. 45, 88
        mov     dword [rax+10H], 2                      ; 13CF _ C7. 40, 10, 00000002
        mov     rax, qword [rbp-78H]                    ; 13D6 _ 48: 8B. 45, 88
        mov     qword [rax+28H], 65536                  ; 13DA _ 48: C7. 40, 28, 00010000
        mov     rax, qword [rbp-78H]                    ; 13E2 _ 48: 8B. 45, 88
        mov     rdi, rax                                ; 13E6 _ 48: 89. C7
        call    nasm_ofmt_output                        ; 13E9 _ E8, FFFFF831
        sub     qword [rbp-30H], 65536                  ; 13EE _ 48: 81. 6D, D0, 00010000
        mov     rax, qword [rbp-78H]                    ; 13F6 _ 48: 8B. 45, 88
        mov     rax, qword [rax]                        ; 13FA _ 48: 8B. 00
        lea     rdx, [rax+10000H]                       ; 13FD _ 48: 8D. 90, 00010000
        mov     rax, qword [rbp-78H]                    ; 1404 _ 48: 8B. 45, 88
        mov     qword [rax], rdx                        ; 1408 _ 48: 89. 10
        mov     rax, qword [rbp-78H]                    ; 140B _ 48: 8B. 45, 88
        mov     eax, dword [rax+1CH]                    ; 140F _ 8B. 40, 1C
        lea     edx, [rax+10000H]                       ; 1412 _ 8D. 90, 00010000
        mov     rax, qword [rbp-78H]                    ; 1418 _ 48: 8B. 45, 88
        mov     dword [rax+1CH], edx                    ; 141C _ 89. 50, 1C
?_0143: cmp     qword [rbp-30H], 65536                  ; 141F _ 48: 81. 7D, D0, 00010000
        ja      ?_0142                                  ; 1427 _ 77, A2
        mov     rax, qword [rbp-78H]                    ; 1429 _ 48: 8B. 45, 88
        mov     rdx, qword [rbp-30H]                    ; 142D _ 48: 8B. 55, D0
        mov     qword [rax+28H], rdx                    ; 1431 _ 48: 89. 50, 28
?_0144: mov     rax, qword [rbp-78H]                    ; 1435 _ 48: 8B. 45, 88
        mov     rdi, rax                                ; 1439 _ 48: 89. C7
        call    nasm_ofmt_output                        ; 143C _ E8, FFFFF7DE
        jmp     ?_0146                                  ; 1441 _ EB, 20

?_0145: mov     rax, qword [rbp-78H]                    ; 1443 _ 48: 8B. 45, 88
        mov     eax, dword [rax+10H]                    ; 1447 _ 8B. 40, 10
        cmp     eax, 1                                  ; 144A _ 83. F8, 01
        jz      ?_0146                                  ; 144D _ 74, 14
        lea     rax, [rel ?_1021]                       ; 144F _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 1456 _ 48: 89. C7
        mov     eax, 0                                  ; 1459 _ B8, 00000000
        call    nasm_nonfatal                           ; 145E _ E8, 00000000(PLT r)
?_0146: mov     rax, qword [rbp-78H]                    ; 1463 _ 48: 8B. 45, 88
        mov     rax, qword [rax]                        ; 1467 _ 48: 8B. 00
        mov     rdx, rax                                ; 146A _ 48: 89. C2
        mov     rax, qword [rbp-78H]                    ; 146D _ 48: 8B. 45, 88
        mov     rax, qword [rax+28H]                    ; 1471 _ 48: 8B. 40, 28
        add     rax, rdx                                ; 1475 _ 48: 01. D0
        mov     rdx, rax                                ; 1478 _ 48: 89. C2
        mov     rax, qword [rbp-78H]                    ; 147B _ 48: 8B. 45, 88
        mov     qword [rax], rdx                        ; 147F _ 48: 89. 10
        mov     rax, qword [rbp-78H]                    ; 1482 _ 48: 8B. 45, 88
        mov     eax, dword [rax+1CH]                    ; 1486 _ 8B. 40, 1C
        mov     edx, eax                                ; 1489 _ 89. C2
        mov     rax, qword [rbp-78H]                    ; 148B _ 48: 8B. 45, 88
        mov     rax, qword [rax+28H]                    ; 148F _ 48: 8B. 40, 28
        add     eax, edx                                ; 1493 _ 01. D0
        mov     edx, eax                                ; 1495 _ 89. C2
        mov     rax, qword [rbp-78H]                    ; 1497 _ 48: 8B. 45, 88
        mov     dword [rax+1CH], edx                    ; 149B _ 89. 50, 1C
        cmp     qword [rbp-48H], 0                      ; 149E _ 48: 83. 7D, B8, 00
        jz      ?_0147                                  ; 14A3 _ 74, 6A
        mov     rax, qword [rbp-78H]                    ; 14A5 _ 48: 8B. 45, 88
        mov     dword [rax+10H], 2                      ; 14A9 _ C7. 40, 10, 00000002
        mov     rax, qword [rbp-78H]                    ; 14B0 _ 48: 8B. 45, 88
        mov     rdx, qword [rbp-48H]                    ; 14B4 _ 48: 8B. 55, B8
        mov     qword [rax+28H], rdx                    ; 14B8 _ 48: 89. 50, 28
        mov     rax, qword [rel lfmt]                   ; 14BC _ 48: 8B. 05, 00000000(rel)
        mov     rdx, qword [rax+10H]                    ; 14C3 _ 48: 8B. 50, 10
        mov     rax, qword [rbp-78H]                    ; 14C7 _ 48: 8B. 45, 88
        mov     rdi, rax                                ; 14CB _ 48: 89. C7
        call    rdx                                     ; 14CE _ FF. D2
        mov     rax, qword [rbp-78H]                    ; 14D0 _ 48: 8B. 45, 88
        mov     rdi, rax                                ; 14D4 _ 48: 89. C7
        call    nasm_ofmt_output                        ; 14D7 _ E8, FFFFF743
        mov     rax, qword [rbp-78H]                    ; 14DC _ 48: 8B. 45, 88
        mov     rax, qword [rax]                        ; 14E0 _ 48: 8B. 00
        mov     rdx, rax                                ; 14E3 _ 48: 89. C2
        mov     rax, qword [rbp-48H]                    ; 14E6 _ 48: 8B. 45, B8
        add     rax, rdx                                ; 14EA _ 48: 01. D0
        mov     rdx, rax                                ; 14ED _ 48: 89. C2
        mov     rax, qword [rbp-78H]                    ; 14F0 _ 48: 8B. 45, 88
        mov     qword [rax], rdx                        ; 14F4 _ 48: 89. 10
        mov     rax, qword [rbp-78H]                    ; 14F7 _ 48: 8B. 45, 88
        mov     eax, dword [rax+1CH]                    ; 14FB _ 8B. 40, 1C
        mov     edx, eax                                ; 14FE _ 89. C2
        mov     rax, qword [rbp-48H]                    ; 1500 _ 48: 8B. 45, B8
        add     eax, edx                                ; 1504 _ 01. D0
        mov     edx, eax                                ; 1506 _ 89. C2
        mov     rax, qword [rbp-78H]                    ; 1508 _ 48: 8B. 45, 88
        mov     dword [rax+1CH], edx                    ; 150C _ 89. 50, 1C
?_0147: mov     rax, qword [rbp-78H]                    ; 150F _ 48: 8B. 45, 88
        mov     rdx, qword [rbp-28H]                    ; 1513 _ 48: 8B. 55, D8
        mov     qword [rax+28H], rdx                    ; 1517 _ 48: 89. 50, 28
        mov     rax, qword [rbp-78H]                    ; 151B _ 48: 8B. 45, 88
        mov     qword [rax+68H], 0                      ; 151F _ 48: C7. 40, 68, 00000000
        jmp     ?_0149                                  ; 1527 _ EB, 01

?_0148: nop                                             ; 1529 _ 90
?_0149: mov     rax, qword [rbp-18H]                    ; 152A _ 48: 8B. 45, E8
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        sub     rax, qword [fs:abs 28H]                 ; 152E _ 64 48: 2B. 04 25, 00000028
        jz      ?_0150                                  ; 1537 _ 74, 05
        call    __stack_chk_fail                        ; 1539 _ E8, 00000000(PLT r)
?_0150: mov     rbx, qword [rbp-8H]                     ; 153E _ 48: 8B. 5D, F8
        leave                                           ; 1542 _ C9
        ret                                             ; 1543 _ C3

out_rawdata:; Local function
        push    rbp                                     ; 1544 _ 55
        mov     rbp, rsp                                ; 1545 _ 48: 89. E5
        sub     rsp, 32                                 ; 1548 _ 48: 83. EC, 20
        mov     qword [rbp-8H], rdi                     ; 154C _ 48: 89. 7D, F8
        mov     qword [rbp-10H], rsi                    ; 1550 _ 48: 89. 75, F0
        mov     qword [rbp-18H], rdx                    ; 1554 _ 48: 89. 55, E8
        cmp     qword [rbp-18H], 0                      ; 1558 _ 48: 83. 7D, E8, 00
        jz      ?_0151                                  ; 155D _ 74, 31
        mov     rax, qword [rbp-8H]                     ; 155F _ 48: 8B. 45, F8
        mov     dword [rax+10H], 0                      ; 1563 _ C7. 40, 10, 00000000
        mov     rax, qword [rbp-8H]                     ; 156A _ 48: 8B. 45, F8
        mov     rdx, qword [rbp-10H]                    ; 156E _ 48: 8B. 55, F0
        mov     qword [rax+38H], rdx                    ; 1572 _ 48: 89. 50, 38
        mov     rax, qword [rbp-8H]                     ; 1576 _ 48: 8B. 45, F8
        mov     rdx, qword [rbp-18H]                    ; 157A _ 48: 8B. 55, E8
        mov     qword [rax+28H], rdx                    ; 157E _ 48: 89. 50, 28
        mov     rax, qword [rbp-8H]                     ; 1582 _ 48: 8B. 45, F8
        mov     rdi, rax                                ; 1586 _ 48: 89. C7
        call    out                                     ; 1589 _ E8, FFFFF8B1
        jmp     ?_0152                                  ; 158E _ EB, 01

?_0151: nop                                             ; 1590 _ 90
?_0152: leave                                           ; 1591 _ C9
        ret                                             ; 1592 _ C3

out_rawbyte:; Local function
        push    rbp                                     ; 1593 _ 55
        mov     rbp, rsp                                ; 1594 _ 48: 89. E5
        sub     rsp, 16                                 ; 1597 _ 48: 83. EC, 10
        mov     qword [rbp-8H], rdi                     ; 159B _ 48: 89. 7D, F8
        mov     byte [rbp-9H], sil                      ; 159F _ 40: 88. 75, F7
        mov     rax, qword [rbp-8H]                     ; 15A3 _ 48: 8B. 45, F8
        mov     dword [rax+10H], 0                      ; 15A7 _ C7. 40, 10, 00000000
        mov     rax, qword [rbp-8H]                     ; 15AE _ 48: 8B. 45, F8
        lea     rdx, [rbp-9H]                           ; 15B2 _ 48: 8D. 55, F7
        mov     qword [rax+38H], rdx                    ; 15B6 _ 48: 89. 50, 38
        mov     rax, qword [rbp-8H]                     ; 15BA _ 48: 8B. 45, F8
        mov     qword [rax+28H], 1                      ; 15BE _ 48: C7. 40, 28, 00000001
        mov     rax, qword [rbp-8H]                     ; 15C6 _ 48: 8B. 45, F8
        mov     rdi, rax                                ; 15CA _ 48: 89. C7
        call    out                                     ; 15CD _ E8, FFFFF86D
        nop                                             ; 15D2 _ 90
        leave                                           ; 15D3 _ C9
        ret                                             ; 15D4 _ C3

out_rawdword:; Local function
        push    rbp                                     ; 15D5 _ 55
        mov     rbp, rsp                                ; 15D6 _ 48: 89. E5
        sub     rsp, 32                                 ; 15D9 _ 48: 83. EC, 20
        mov     qword [rbp-18H], rdi                    ; 15DD _ 48: 89. 7D, E8
        mov     dword [rbp-1CH], esi                    ; 15E1 _ 89. 75, E4
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        mov     rax, qword [fs:abs 28H]                 ; 15E4 _ 64 48: 8B. 04 25, 00000028
        mov     qword [rbp-8H], rax                     ; 15ED _ 48: 89. 45, F8
        xor     eax, eax                                ; 15F1 _ 31. C0
        mov     eax, dword [rbp-1CH]                    ; 15F3 _ 8B. 45, E4
        mov     edi, eax                                ; 15F6 _ 89. C7
        call    __uint32_identity                       ; 15F8 _ E8, FFFFEA03
        mov     dword [rbp-0CH], eax                    ; 15FD _ 89. 45, F4
        mov     rax, qword [rbp-18H]                    ; 1600 _ 48: 8B. 45, E8
        mov     dword [rax+10H], 0                      ; 1604 _ C7. 40, 10, 00000000
        mov     rax, qword [rbp-18H]                    ; 160B _ 48: 8B. 45, E8
        lea     rdx, [rbp-0CH]                          ; 160F _ 48: 8D. 55, F4
        mov     qword [rax+38H], rdx                    ; 1613 _ 48: 89. 50, 38
        mov     rax, qword [rbp-18H]                    ; 1617 _ 48: 8B. 45, E8
        mov     qword [rax+28H], 4                      ; 161B _ 48: C7. 40, 28, 00000004
        mov     rax, qword [rbp-18H]                    ; 1623 _ 48: 8B. 45, E8
        mov     rdi, rax                                ; 1627 _ 48: 89. C7
        call    out                                     ; 162A _ E8, FFFFF810
        nop                                             ; 162F _ 90
        mov     rax, qword [rbp-8H]                     ; 1630 _ 48: 8B. 45, F8
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        sub     rax, qword [fs:abs 28H]                 ; 1634 _ 64 48: 2B. 04 25, 00000028
        jz      ?_0153                                  ; 163D _ 74, 05
        call    __stack_chk_fail                        ; 163F _ E8, 00000000(PLT r)
?_0153: leave                                           ; 1644 _ C9
        ret                                             ; 1645 _ C3

out_reserve:; Local function
        push    rbp                                     ; 1646 _ 55
        mov     rbp, rsp                                ; 1647 _ 48: 89. E5
        sub     rsp, 16                                 ; 164A _ 48: 83. EC, 10
        mov     qword [rbp-8H], rdi                     ; 164E _ 48: 89. 7D, F8
        mov     qword [rbp-10H], rsi                    ; 1652 _ 48: 89. 75, F0
        mov     rax, qword [rbp-8H]                     ; 1656 _ 48: 8B. 45, F8
        mov     dword [rax+10H], 1                      ; 165A _ C7. 40, 10, 00000001
        mov     rax, qword [rbp-8H]                     ; 1661 _ 48: 8B. 45, F8
        mov     rdx, qword [rbp-10H]                    ; 1665 _ 48: 8B. 55, F0
        mov     qword [rax+28H], rdx                    ; 1669 _ 48: 89. 50, 28
        mov     rax, qword [rbp-8H]                     ; 166D _ 48: 8B. 45, F8
        mov     rdi, rax                                ; 1671 _ 48: 89. C7
        call    out                                     ; 1674 _ E8, FFFFF7C6
        nop                                             ; 1679 _ 90
        leave                                           ; 167A _ C9
        ret                                             ; 167B _ C3

out_farseg:; Local function
        push    rbp                                     ; 167C _ 55
        mov     rbp, rsp                                ; 167D _ 48: 89. E5
        sub     rsp, 16                                 ; 1680 _ 48: 83. EC, 10
        mov     qword [rbp-8H], rdi                     ; 1684 _ 48: 89. 7D, F8
        mov     qword [rbp-10H], rsi                    ; 1688 _ 48: 89. 75, F0
        mov     rax, qword [rbp-10H]                    ; 168C _ 48: 8B. 45, F0
        mov     eax, dword [rax+38H]                    ; 1690 _ 8B. 40, 38
        and     eax, 08H                                ; 1693 _ 83. E0, 08
        test    eax, eax                                ; 1696 _ 85. C0
        jz      ?_0154                                  ; 1698 _ 74, 14
        lea     rax, [rel ?_1022]                       ; 169A _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 16A1 _ 48: 89. C7
        mov     eax, 0                                  ; 16A4 _ B8, 00000000
        call    nasm_nonfatal                           ; 16A9 _ E8, 00000000(PLT r)
?_0154: mov     rax, qword [rbp-8H]                     ; 16AE _ 48: 8B. 45, F8
        mov     dword [rax+10H], 5                      ; 16B2 _ C7. 40, 10, 00000005
        mov     rax, qword [rbp-8H]                     ; 16B9 _ 48: 8B. 45, F8
        mov     dword [rax+14H], 2                      ; 16BD _ C7. 40, 14, 00000002
        mov     rax, qword [rbp-8H]                     ; 16C4 _ 48: 8B. 45, F8
        mov     qword [rax+28H], 2                      ; 16C8 _ 48: C7. 40, 28, 00000002
        mov     rax, qword [rbp-8H]                     ; 16D0 _ 48: 8B. 45, F8
        mov     qword [rax+40H], 0                      ; 16D4 _ 48: C7. 40, 40, 00000000
        mov     rax, qword [rel ofmt]                   ; 16DC _ 48: 8B. 05, 00000000(rel)
        mov     rax, qword [rax+70H]                    ; 16E3 _ 48: 8B. 40, 70
        mov     rdx, qword [rbp-10H]                    ; 16E7 _ 48: 8B. 55, F0
        mov     edx, dword [rdx+24H]                    ; 16EB _ 8B. 52, 24
        or      edx, 01H                                ; 16EE _ 83. CA, 01
        mov     edi, edx                                ; 16F1 _ 89. D7
        call    rax                                     ; 16F3 _ FF. D0
        mov     rdx, qword [rbp-8H]                     ; 16F5 _ 48: 8B. 55, F8
        mov     dword [rdx+48H], eax                    ; 16F9 _ 89. 42, 48
        mov     rax, qword [rbp-10H]                    ; 16FC _ 48: 8B. 45, F0
        mov     edx, dword [rax+30H]                    ; 1700 _ 8B. 50, 30
        mov     rax, qword [rbp-8H]                     ; 1703 _ 48: 8B. 45, F8
        mov     dword [rax+4CH], edx                    ; 1707 _ 89. 50, 4C
        mov     rax, qword [rbp-8H]                     ; 170A _ 48: 8B. 45, F8
        mov     rdi, rax                                ; 170E _ 48: 89. C7
        call    out                                     ; 1711 _ E8, FFFFF729
        nop                                             ; 1716 _ 90
        leave                                           ; 1717 _ C9
        ret                                             ; 1718 _ C3

out_imm:; Local function
        push    rbp                                     ; 1719 _ 55
        mov     rbp, rsp                                ; 171A _ 48: 89. E5
        sub     rsp, 32                                 ; 171D _ 48: 83. EC, 20
        mov     qword [rbp-8H], rdi                     ; 1721 _ 48: 89. 7D, F8
        mov     qword [rbp-10H], rsi                    ; 1725 _ 48: 89. 75, F0
        mov     dword [rbp-14H], edx                    ; 1729 _ 89. 55, EC
        mov     dword [rbp-18H], ecx                    ; 172C _ 89. 4D, E8
        mov     rax, qword [rbp-10H]                    ; 172F _ 48: 8B. 45, F0
        mov     eax, dword [rax+24H]                    ; 1733 _ 8B. 40, 24
        cmp     eax, -1                                 ; 1736 _ 83. F8, FF
        jz      ?_0156                                  ; 1739 _ 74, 35
        mov     rax, qword [rbp-10H]                    ; 173B _ 48: 8B. 45, F0
        mov     eax, dword [rax+24H]                    ; 173F _ 8B. 40, 24
        and     eax, 01H                                ; 1742 _ 83. E0, 01
        test    eax, eax                                ; 1745 _ 85. C0
        jz      ?_0156                                  ; 1747 _ 74, 27
        cmp     dword [rbp-14H], 1                      ; 1749 _ 83. 7D, EC, 01
        jg      ?_0155                                  ; 174D _ 7F, 14
        lea     rax, [rel ?_1023]                       ; 174F _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 1756 _ 48: 89. C7
        mov     eax, 0                                  ; 1759 _ B8, 00000000
        call    nasm_nonfatal                           ; 175E _ E8, 00000000(PLT r)
?_0155: mov     rax, qword [rbp-8H]                     ; 1763 _ 48: 8B. 45, F8
        mov     dword [rax+10H], 5                      ; 1767 _ C7. 40, 10, 00000005
        jmp     ?_0159                                  ; 176E _ EB, 21

?_0156: mov     rax, qword [rbp-10H]                    ; 1770 _ 48: 8B. 45, F0
        mov     eax, dword [rax+38H]                    ; 1774 _ 8B. 40, 38
        and     eax, 08H                                ; 1777 _ 83. E0, 08
        test    eax, eax                                ; 177A _ 85. C0
        jz      ?_0157                                  ; 177C _ 74, 07
        mov     edx, 4                                  ; 177E _ BA, 00000004
        jmp     ?_0158                                  ; 1783 _ EB, 05

?_0157: mov     edx, 3                                  ; 1785 _ BA, 00000003
?_0158: mov     rax, qword [rbp-8H]                     ; 178A _ 48: 8B. 45, F8
        mov     dword [rax+10H], edx                    ; 178E _ 89. 50, 10
?_0159: mov     rax, qword [rbp-8H]                     ; 1791 _ 48: 8B. 45, F8
        mov     edx, dword [rbp-18H]                    ; 1795 _ 8B. 55, E8
        mov     dword [rax+14H], edx                    ; 1798 _ 89. 50, 14
        mov     rax, qword [rbp-10H]                    ; 179B _ 48: 8B. 45, F0
        mov     rax, qword [rax+28H]                    ; 179F _ 48: 8B. 40, 28
        mov     rdx, rax                                ; 17A3 _ 48: 89. C2
        mov     rax, qword [rbp-8H]                     ; 17A6 _ 48: 8B. 45, F8
        mov     qword [rax+40H], rdx                    ; 17AA _ 48: 89. 50, 40
        mov     rax, qword [rbp-10H]                    ; 17AE _ 48: 8B. 45, F0
        mov     edx, dword [rax+24H]                    ; 17B2 _ 8B. 50, 24
        mov     rax, qword [rbp-8H]                     ; 17B5 _ 48: 8B. 45, F8
        mov     dword [rax+48H], edx                    ; 17B9 _ 89. 50, 48
        mov     rax, qword [rbp-10H]                    ; 17BC _ 48: 8B. 45, F0
        mov     edx, dword [rax+30H]                    ; 17C0 _ 8B. 50, 30
        mov     rax, qword [rbp-8H]                     ; 17C3 _ 48: 8B. 45, F8
        mov     dword [rax+4CH], edx                    ; 17C7 _ 89. 50, 4C
        mov     rax, qword [rbp-8H]                     ; 17CA _ 48: 8B. 45, F8
        mov     qword [rax+50H], 0                      ; 17CE _ 48: C7. 40, 50, 00000000
        mov     eax, dword [rbp-14H]                    ; 17D6 _ 8B. 45, EC
        movsxd  rdx, eax                                ; 17D9 _ 48: 63. D0
        mov     rax, qword [rbp-8H]                     ; 17DC _ 48: 8B. 45, F8
        mov     qword [rax+28H], rdx                    ; 17E0 _ 48: 89. 50, 28
        mov     rax, qword [rbp-8H]                     ; 17E4 _ 48: 8B. 45, F8
        mov     rdi, rax                                ; 17E8 _ 48: 89. C7
        call    out                                     ; 17EB _ E8, FFFFF64F
        nop                                             ; 17F0 _ 90
        leave                                           ; 17F1 _ C9
        ret                                             ; 17F2 _ C3

out_reladdr:; Local function
        push    rbp                                     ; 17F3 _ 55
        mov     rbp, rsp                                ; 17F4 _ 48: 89. E5
        sub     rsp, 32                                 ; 17F7 _ 48: 83. EC, 20
        mov     qword [rbp-8H], rdi                     ; 17FB _ 48: 89. 7D, F8
        mov     qword [rbp-10H], rsi                    ; 17FF _ 48: 89. 75, F0
        mov     dword [rbp-14H], edx                    ; 1803 _ 89. 55, EC
        mov     rax, qword [rbp-10H]                    ; 1806 _ 48: 8B. 45, F0
        mov     eax, dword [rax+38H]                    ; 180A _ 8B. 40, 38
        and     eax, 08H                                ; 180D _ 83. E0, 08
        test    eax, eax                                ; 1810 _ 85. C0
        jz      ?_0160                                  ; 1812 _ 74, 14
        lea     rax, [rel ?_1024]                       ; 1814 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 181B _ 48: 89. C7
        mov     eax, 0                                  ; 181E _ B8, 00000000
        call    nasm_nonfatal                           ; 1823 _ E8, 00000000(PLT r)
?_0160: mov     rax, qword [rbp-8H]                     ; 1828 _ 48: 8B. 45, F8
        mov     dword [rax+10H], 4                      ; 182C _ C7. 40, 10, 00000004
        mov     rax, qword [rbp-8H]                     ; 1833 _ 48: 8B. 45, F8
        mov     dword [rax+14H], 1                      ; 1837 _ C7. 40, 14, 00000001
        mov     eax, dword [rbp-14H]                    ; 183E _ 8B. 45, EC
        movsxd  rdx, eax                                ; 1841 _ 48: 63. D0
        mov     rax, qword [rbp-8H]                     ; 1844 _ 48: 8B. 45, F8
        mov     qword [rax+28H], rdx                    ; 1848 _ 48: 89. 50, 28
        mov     rax, qword [rbp-10H]                    ; 184C _ 48: 8B. 45, F0
        mov     rax, qword [rax+28H]                    ; 1850 _ 48: 8B. 40, 28
        mov     rdx, rax                                ; 1854 _ 48: 89. C2
        mov     rax, qword [rbp-8H]                     ; 1857 _ 48: 8B. 45, F8
        mov     qword [rax+40H], rdx                    ; 185B _ 48: 89. 50, 40
        mov     rax, qword [rbp-10H]                    ; 185F _ 48: 8B. 45, F0
        mov     edx, dword [rax+24H]                    ; 1863 _ 8B. 50, 24
        mov     rax, qword [rbp-8H]                     ; 1866 _ 48: 8B. 45, F8
        mov     dword [rax+48H], edx                    ; 186A _ 89. 50, 48
        mov     rax, qword [rbp-10H]                    ; 186D _ 48: 8B. 45, F0
        mov     edx, dword [rax+30H]                    ; 1871 _ 8B. 50, 30
        mov     rax, qword [rbp-8H]                     ; 1874 _ 48: 8B. 45, F8
        mov     dword [rax+4CH], edx                    ; 1878 _ 89. 50, 4C
        mov     rax, qword [rbp-8H]                     ; 187B _ 48: 8B. 45, F8
        mov     rdx, qword [rax]                        ; 187F _ 48: 8B. 10
        mov     rax, qword [rbp-8H]                     ; 1882 _ 48: 8B. 45, F8
        mov     ecx, dword [rax+18H]                    ; 1886 _ 8B. 48, 18
        mov     rax, qword [rbp-8H]                     ; 1889 _ 48: 8B. 45, F8
        mov     eax, dword [rax+1CH]                    ; 188D _ 8B. 40, 1C
        sub     ecx, eax                                ; 1890 _ 29. C1
        movsxd  rax, ecx                                ; 1892 _ 48: 63. C1
        add     rdx, rax                                ; 1895 _ 48: 01. C2
        mov     rax, qword [rbp-8H]                     ; 1898 _ 48: 8B. 45, F8
        mov     qword [rax+50H], rdx                    ; 189C _ 48: 89. 50, 50
        mov     rax, qword [rbp-8H]                     ; 18A0 _ 48: 8B. 45, F8
        mov     rdi, rax                                ; 18A4 _ 48: 89. C7
        call    out                                     ; 18A7 _ E8, FFFFF593
        nop                                             ; 18AC _ 90
        leave                                           ; 18AD _ C9
        ret                                             ; 18AE _ C3

no_match_error:; Local function
        push    rbp                                     ; 18AF _ 55
        mov     rbp, rsp                                ; 18B0 _ 48: 89. E5
        sub     rsp, 16                                 ; 18B3 _ 48: 83. EC, 10
        mov     dword [rbp-4H], edi                     ; 18B7 _ 89. 7D, FC
        mov     qword [rbp-10H], rsi                    ; 18BA _ 48: 89. 75, F0
        cmp     dword [rbp-4H], 20                      ; 18BE _ 83. 7D, FC, 14
        je      ?_0176                                  ; 18C2 _ 0F 84, 0000030A
        cmp     dword [rbp-4H], 20                      ; 18C8 _ 83. 7D, FC, 14
        ja      ?_0181                                  ; 18CC _ 0F 87, 0000036E
        cmp     dword [rbp-4H], 19                      ; 18D2 _ 83. 7D, FC, 13
        je      ?_0175                                  ; 18D6 _ 0F 84, 000002DD
        cmp     dword [rbp-4H], 19                      ; 18DC _ 83. 7D, FC, 13
        ja      ?_0181                                  ; 18E0 _ 0F 87, 0000035A
        cmp     dword [rbp-4H], 18                      ; 18E6 _ 83. 7D, FC, 12
        je      ?_0174                                  ; 18EA _ 0F 84, 000002B0
        cmp     dword [rbp-4H], 18                      ; 18F0 _ 83. 7D, FC, 12
        ja      ?_0181                                  ; 18F4 _ 0F 87, 00000346
        cmp     dword [rbp-4H], 17                      ; 18FA _ 83. 7D, FC, 11
        ja      ?_0181                                  ; 18FE _ 0F 87, 0000033C
        cmp     dword [rbp-4H], 16                      ; 1904 _ 83. 7D, FC, 10
        jnc     ?_0173                                  ; 1908 _ 0F 83, 00000265
        cmp     dword [rbp-4H], 15                      ; 190E _ 83. 7D, FC, 0F
        je      ?_0171                                  ; 1912 _ 0F 84, 0000020A
        cmp     dword [rbp-4H], 15                      ; 1918 _ 83. 7D, FC, 0F
        ja      ?_0181                                  ; 191C _ 0F 87, 0000031E
        cmp     dword [rbp-4H], 13                      ; 1922 _ 83. 7D, FC, 0D
        je      ?_0170                                  ; 1926 _ 0F 84, 000001D0
        cmp     dword [rbp-4H], 13                      ; 192C _ 83. 7D, FC, 0D
        ja      ?_0181                                  ; 1930 _ 0F 87, 0000030A
        cmp     dword [rbp-4H], 12                      ; 1936 _ 83. 7D, FC, 0C
        je      ?_0169                                  ; 193A _ 0F 84, 000001A3
        cmp     dword [rbp-4H], 12                      ; 1940 _ 83. 7D, FC, 0C
        ja      ?_0181                                  ; 1944 _ 0F 87, 000002F6
        cmp     dword [rbp-4H], 11                      ; 194A _ 83. 7D, FC, 0B
        je      ?_0180                                  ; 194E _ 0F 84, 000002D6
        cmp     dword [rbp-4H], 11                      ; 1954 _ 83. 7D, FC, 0B
        ja      ?_0181                                  ; 1958 _ 0F 87, 000002E2
        cmp     dword [rbp-4H], 10                      ; 195E _ 83. 7D, FC, 0A
        je      ?_0179                                  ; 1962 _ 0F 84, 000002AC
        cmp     dword [rbp-4H], 10                      ; 1968 _ 83. 7D, FC, 0A
        ja      ?_0181                                  ; 196C _ 0F 87, 000002CE
        cmp     dword [rbp-4H], 9                       ; 1972 _ 83. 7D, FC, 09
        je      ?_0178                                  ; 1976 _ 0F 84, 00000282
        cmp     dword [rbp-4H], 9                       ; 197C _ 83. 7D, FC, 09
        ja      ?_0181                                  ; 1980 _ 0F 87, 000002BA
        cmp     dword [rbp-4H], 8                       ; 1986 _ 83. 7D, FC, 08
        je      ?_0177                                  ; 198A _ 0F 84, 00000258
        cmp     dword [rbp-4H], 8                       ; 1990 _ 83. 7D, FC, 08
        ja      ?_0181                                  ; 1994 _ 0F 87, 000002A6
        cmp     dword [rbp-4H], 7                       ; 199A _ 83. 7D, FC, 07
        je      ?_0168                                  ; 199E _ 0F 84, 00000126
        cmp     dword [rbp-4H], 7                       ; 19A4 _ 83. 7D, FC, 07
        ja      ?_0181                                  ; 19A8 _ 0F 87, 00000292
        cmp     dword [rbp-4H], 6                       ; 19AE _ 83. 7D, FC, 06
        je      ?_0166                                  ; 19B2 _ 0F 84, 000000E0
        cmp     dword [rbp-4H], 6                       ; 19B8 _ 83. 7D, FC, 06
        ja      ?_0181                                  ; 19BC _ 0F 87, 0000027E
        cmp     dword [rbp-4H], 5                       ; 19C2 _ 83. 7D, FC, 05
        je      ?_0165                                  ; 19C6 _ 0F 84, 000000B3
        cmp     dword [rbp-4H], 5                       ; 19CC _ 83. 7D, FC, 05
        ja      ?_0181                                  ; 19D0 _ 0F 87, 0000026A
        cmp     dword [rbp-4H], 4                       ; 19D6 _ 83. 7D, FC, 04
        je      ?_0167                                  ; 19DA _ 0F 84, 000000D1
        cmp     dword [rbp-4H], 4                       ; 19E0 _ 83. 7D, FC, 04
        ja      ?_0181                                  ; 19E4 _ 0F 87, 00000256
        cmp     dword [rbp-4H], 3                       ; 19EA _ 83. 7D, FC, 03
        jz      ?_0164                                  ; 19EE _ 74, 76
        cmp     dword [rbp-4H], 3                       ; 19F0 _ 83. 7D, FC, 03
        ja      ?_0181                                  ; 19F4 _ 0F 87, 00000246
        cmp     dword [rbp-4H], 2                       ; 19FA _ 83. 7D, FC, 02
        jz      ?_0163                                  ; 19FE _ 74, 4D
        cmp     dword [rbp-4H], 2                       ; 1A00 _ 83. 7D, FC, 02
        ja      ?_0181                                  ; 1A04 _ 0F 87, 00000236
        cmp     dword [rbp-4H], 0                       ; 1A0A _ 83. 7D, FC, 00
        jz      ?_0161                                  ; 1A0E _ 74, 0B
        cmp     dword [rbp-4H], 1                       ; 1A10 _ 83. 7D, FC, 01
        jz      ?_0162                                  ; 1A14 _ 74, 1E
        jmp     ?_0181                                  ; 1A16 _ E9, 00000225

?_0161: lea     rax, [rel ?_1025]                       ; 1A1B _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 1A22 _ 48: 89. C7
        mov     eax, 0                                  ; 1A25 _ B8, 00000000
        call    nasm_holderr                            ; 1A2A _ E8, 00000000(PLT r)
        jmp     ?_0183                                  ; 1A2F _ E9, 00000227

?_0162: lea     rax, [rel ?_1026]                       ; 1A34 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 1A3B _ 48: 89. C7
        mov     eax, 0                                  ; 1A3E _ B8, 00000000
        call    nasm_holderr                            ; 1A43 _ E8, 00000000(PLT r)
        jmp     ?_0183                                  ; 1A48 _ E9, 0000020E

?_0163: lea     rax, [rel ?_1027]                       ; 1A4D _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 1A54 _ 48: 89. C7
        mov     eax, 0                                  ; 1A57 _ B8, 00000000
        call    nasm_holderr                            ; 1A5C _ E8, 00000000(PLT r)
        jmp     ?_0183                                  ; 1A61 _ E9, 000001F5

?_0164: lea     rax, [rel ?_1028]                       ; 1A66 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 1A6D _ 48: 89. C7
        mov     eax, 0                                  ; 1A70 _ B8, 00000000
        call    nasm_holderr                            ; 1A75 _ E8, 00000000(PLT r)
        jmp     ?_0183                                  ; 1A7A _ E9, 000001DC

?_0165: lea     rax, [rel ?_1029]                       ; 1A7F _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 1A86 _ 48: 89. C7
        mov     eax, 0                                  ; 1A89 _ B8, 00000000
        call    nasm_holderr                            ; 1A8E _ E8, 00000000(PLT r)
        jmp     ?_0183                                  ; 1A93 _ E9, 000001C3

?_0166: lea     rax, [rel ?_1030]                       ; 1A98 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 1A9F _ 48: 89. C7
        mov     eax, 0                                  ; 1AA2 _ B8, 00000000
        call    nasm_holderr                            ; 1AA7 _ E8, 00000000(PLT r)
        jmp     ?_0183                                  ; 1AAC _ E9, 000001AA

?_0167: lea     rax, [rel ?_1031]                       ; 1AB1 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 1AB8 _ 48: 89. C7
        mov     eax, 0                                  ; 1ABB _ B8, 00000000
        call    nasm_holderr                            ; 1AC0 _ E8, 00000000(PLT r)
        jmp     ?_0183                                  ; 1AC5 _ E9, 00000191

?_0168: lea     rax, [rel ?_1032]                       ; 1ACA _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 1AD1 _ 48: 89. C7
        mov     eax, 0                                  ; 1AD4 _ B8, 00000000
        call    nasm_holderr                            ; 1AD9 _ E8, 00000000(PLT r)
        jmp     ?_0183                                  ; 1ADE _ E9, 00000178

?_0169: lea     rax, [rel ?_1033]                       ; 1AE3 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 1AEA _ 48: 89. C7
        mov     eax, 0                                  ; 1AED _ B8, 00000000
        call    nasm_holderr                            ; 1AF2 _ E8, 00000000(PLT r)
        jmp     ?_0183                                  ; 1AF7 _ E9, 0000015F

?_0170: mov     rax, qword [rbp-10H]                    ; 1AFC _ 48: 8B. 45, F0
        movzx   eax, byte [rax+7AH]                     ; 1B00 _ 0F B6. 40, 7A
        movzx   eax, al                                 ; 1B04 _ 0F B6. C0
        lea     rdx, [rel ?_1034]                       ; 1B07 _ 48: 8D. 15, 00000000(rel)
        mov     esi, eax                                ; 1B0E _ 89. C6
        mov     rdi, rdx                                ; 1B10 _ 48: 89. D7
        mov     eax, 0                                  ; 1B13 _ B8, 00000000
        call    nasm_holderr                            ; 1B18 _ E8, 00000000(PLT r)
        jmp     ?_0183                                  ; 1B1D _ E9, 00000139

?_0171: mov     rax, qword [rbp-10H]                    ; 1B22 _ 48: 8B. 45, F0
        mov     eax, dword [rax+30H]                    ; 1B26 _ 8B. 40, 30
        test    eax, eax                                ; 1B29 _ 85. C0
        jnz     ?_0172                                  ; 1B2B _ 75, 19
        lea     rax, [rel ?_1035]                       ; 1B2D _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 1B34 _ 48: 89. C7
        mov     eax, 0                                  ; 1B37 _ B8, 00000000
        call    nasm_holderr                            ; 1B3C _ E8, 00000000(PLT r)
        jmp     ?_0183                                  ; 1B41 _ E9, 00000115

?_0172: mov     rax, qword [rbp-10H]                    ; 1B46 _ 48: 8B. 45, F0
        mov     eax, dword [rax+30H]                    ; 1B4A _ 8B. 40, 30
        mov     edi, eax                                ; 1B4D _ 89. C7
        call    prefix_name                             ; 1B4F _ E8, 00000000(PLT r)
        mov     rdx, rax                                ; 1B54 _ 48: 89. C2
        lea     rax, [rel ?_1036]                       ; 1B57 _ 48: 8D. 05, 00000000(rel)
        mov     rsi, rdx                                ; 1B5E _ 48: 89. D6
        mov     rdi, rax                                ; 1B61 _ 48: 89. C7
        mov     eax, 0                                  ; 1B64 _ B8, 00000000
        call    nasm_holderr                            ; 1B69 _ E8, 00000000(PLT r)
        jmp     ?_0183                                  ; 1B6E _ E9, 000000E8

?_0173: mov     rax, qword [rbp-10H]                    ; 1B73 _ 48: 8B. 45, F0
        mov     eax, dword [rax+2CH]                    ; 1B77 _ 8B. 40, 2C
        mov     edi, eax                                ; 1B7A _ 89. C7
        call    prefix_name                             ; 1B7C _ E8, 00000000(PLT r)
        mov     rdx, rax                                ; 1B81 _ 48: 89. C2
        lea     rax, [rel ?_1037]                       ; 1B84 _ 48: 8D. 05, 00000000(rel)
        mov     rsi, rdx                                ; 1B8B _ 48: 89. D6
        mov     rdi, rax                                ; 1B8E _ 48: 89. C7
        mov     eax, 0                                  ; 1B91 _ B8, 00000000
        call    nasm_holderr                            ; 1B96 _ E8, 00000000(PLT r)
        jmp     ?_0183                                  ; 1B9B _ E9, 000000BB

?_0174: lea     rax, [rel ?_1038]                       ; 1BA0 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 1BA7 _ 48: 89. C7
        mov     eax, 0                                  ; 1BAA _ B8, 00000000
        call    nasm_holderr                            ; 1BAF _ E8, 00000000(PLT r)
        jmp     ?_0183                                  ; 1BB4 _ E9, 000000A2

?_0175: lea     rax, [rel ?_1039]                       ; 1BB9 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 1BC0 _ 48: 89. C7
        mov     eax, 0                                  ; 1BC3 _ B8, 00000000
        call    nasm_holderr                            ; 1BC8 _ E8, 00000000(PLT r)
        jmp     ?_0183                                  ; 1BCD _ E9, 00000089

?_0176: lea     rax, [rel ?_1040]                       ; 1BD2 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 1BD9 _ 48: 89. C7
        mov     eax, 0                                  ; 1BDC _ B8, 00000000
        call    nasm_holderr                            ; 1BE1 _ E8, 00000000(PLT r)
        jmp     ?_0183                                  ; 1BE6 _ EB, 73

?_0177: lea     rax, [rel ?_1041]                       ; 1BE8 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 1BEF _ 48: 89. C7
        mov     eax, 0                                  ; 1BF2 _ B8, 00000000
        call    nasm_holderr                            ; 1BF7 _ E8, 00000000(PLT r)
        jmp     ?_0183                                  ; 1BFC _ EB, 5D

?_0178: lea     rax, [rel ?_1042]                       ; 1BFE _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 1C05 _ 48: 89. C7
        mov     eax, 0                                  ; 1C08 _ B8, 00000000
        call    nasm_holderr                            ; 1C0D _ E8, 00000000(PLT r)
        jmp     ?_0183                                  ; 1C12 _ EB, 47

?_0179: lea     rax, [rel ?_1043]                       ; 1C14 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 1C1B _ 48: 89. C7
        mov     eax, 0                                  ; 1C1E _ B8, 00000000
        call    nasm_holderr                            ; 1C23 _ E8, 00000000(PLT r)
        jmp     ?_0183                                  ; 1C28 _ EB, 31

?_0180: lea     rax, [rel ?_1044]                       ; 1C2A _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 1C31 _ 48: 89. C7
        mov     eax, 0                                  ; 1C34 _ B8, 00000000
        call    nasm_holderr                            ; 1C39 _ E8, 00000000(PLT r)
        jmp     ?_0183                                  ; 1C3E _ EB, 1B

?_0181: cmp     dword [rbp-4H], 29                      ; 1C40 _ 83. 7D, FC, 1D
        ja      ?_0182                                  ; 1C44 _ 77, 14
        lea     rax, [rel ?_1045]                       ; 1C46 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 1C4D _ 48: 89. C7
        mov     eax, 0                                  ; 1C50 _ B8, 00000000
        call    nasm_holderr                            ; 1C55 _ E8, 00000000(PLT r)
?_0182: nop                                             ; 1C5A _ 90
?_0183: nop                                             ; 1C5B _ 90
        leave                                           ; 1C5C _ C9
        ret                                             ; 1C5D _ C3

jmp_match:; Local function
        push    rbp                                     ; 1C5E _ 55
        mov     rbp, rsp                                ; 1C5F _ 48: 89. E5
        sub     rsp, 48                                 ; 1C62 _ 48: 83. EC, 30
        mov     qword [rbp-28H], rdi                    ; 1C66 _ 48: 89. 7D, D8
        mov     qword [rbp-30H], rsi                    ; 1C6A _ 48: 89. 75, D0
        mov     rax, qword [rbp-28H]                    ; 1C6E _ 48: 8B. 45, D8
        mov     esi, 0                                  ; 1C72 _ BE, 00000000
        mov     rdi, rax                                ; 1C77 _ 48: 89. C7
        call    get_operand_const                       ; 1C7A _ E8, FFFFEBB5
        mov     qword [rbp-18H], rax                    ; 1C7F _ 48: 89. 45, E8
        mov     rax, qword [rbp-18H]                    ; 1C83 _ 48: 8B. 45, E8
        mov     rax, qword [rax]                        ; 1C87 _ 48: 8B. 00
        and     eax, 40H                                ; 1C8A _ 83. E0, 40
        test    rax, rax                                ; 1C8D _ 48: 85. C0
        jz      ?_0184                                  ; 1C90 _ 74, 0A
        mov     eax, 0                                  ; 1C92 _ B8, 00000000
        jmp     ?_0198                                  ; 1C97 _ E9, 0000013B

?_0184: mov     rax, qword [rbp-28H]                    ; 1C9C _ 48: 8B. 45, D8
        mov     eax, dword [rax+94H]                    ; 1CA0 _ 8B. 80, 00000094
        and     eax, 03H                                ; 1CA6 _ 83. E0, 03
        test    eax, eax                                ; 1CA9 _ 85. C0
        setne   al                                      ; 1CAB _ 0F 95. C0
        movzx   eax, al                                 ; 1CAE _ 0F B6. C0
        test    rax, rax                                ; 1CB1 _ 48: 85. C0
        jz      ?_0190                                  ; 1CB4 _ 74, 66
        mov     rax, qword [rbp-30H]                    ; 1CB6 _ 48: 8B. 45, D0
        mov     rax, qword [rax+40H]                    ; 1CBA _ 48: 8B. 40, 40
        movzx   eax, byte [rax]                         ; 1CBE _ 0F B6. 00
        mov     byte [rbp-19H], al                      ; 1CC1 _ 88. 45, E7
        movzx   eax, byte [rbp-19H]                     ; 1CC4 _ 0F B6. 45, E7
        cmp     eax, 248                                ; 1CC8 _ 3D, 000000F8
        jz      ?_0185                                  ; 1CCD _ 74, 09
        cmp     eax, 249                                ; 1CCF _ 3D, 000000F9
        jz      ?_0186                                  ; 1CD4 _ 74, 1D
        jmp     ?_0187                                  ; 1CD6 _ EB, 36

?_0185: mov     rax, qword [rbp-28H]                    ; 1CD8 _ 48: 8B. 45, D8
        mov     eax, dword [rax+94H]                    ; 1CDC _ 8B. 80, 00000094
        and     eax, 01H                                ; 1CE2 _ 83. E0, 01
        test    eax, eax                                ; 1CE5 _ 85. C0
        jz      ?_0188                                  ; 1CE7 _ 74, 2F
        mov     eax, 0                                  ; 1CE9 _ B8, 00000000
        jmp     ?_0198                                  ; 1CEE _ E9, 000000E4

?_0186: mov     rax, qword [rbp-28H]                    ; 1CF3 _ 48: 8B. 45, D8
        mov     eax, dword [rax+94H]                    ; 1CF7 _ 8B. 80, 00000094
        and     eax, 02H                                ; 1CFD _ 83. E0, 02
        test    eax, eax                                ; 1D00 _ 85. C0
        jz      ?_0189                                  ; 1D02 _ 74, 17
        mov     eax, 0                                  ; 1D04 _ B8, 00000000
        jmp     ?_0198                                  ; 1D09 _ E9, 000000C9

?_0187: mov     eax, 0                                  ; 1D0E _ B8, 00000000
        jmp     ?_0198                                  ; 1D13 _ E9, 000000BF

?_0188: nop                                             ; 1D18 _ 90
        jmp     ?_0190                                  ; 1D19 _ EB, 01

?_0189: nop                                             ; 1D1B _ 90
?_0190: mov     rax, qword [rbp-18H]                    ; 1D1C _ 48: 8B. 45, E8
        mov     eax, dword [rax+38H]                    ; 1D20 _ 8B. 40, 38
        and     eax, 04H                                ; 1D23 _ 83. E0, 04
        test    eax, eax                                ; 1D26 _ 85. C0
        jz      ?_0191                                  ; 1D28 _ 74, 0A
        mov     eax, 30                                 ; 1D2A _ B8, 0000001E
        jmp     ?_0198                                  ; 1D2F _ E9, 000000A3

?_0191: mov     rax, qword [rbp-18H]                    ; 1D34 _ 48: 8B. 45, E8
        mov     edx, dword [rax+24H]                    ; 1D38 _ 8B. 50, 24
        mov     rax, qword [rbp-28H]                    ; 1D3B _ 48: 8B. 45, D8
        mov     eax, dword [rax+10H]                    ; 1D3F _ 8B. 40, 10
        cmp     edx, eax                                ; 1D42 _ 39. C2
        jz      ?_0192                                  ; 1D44 _ 74, 0A
        mov     eax, 0                                  ; 1D46 _ B8, 00000000
        jmp     ?_0198                                  ; 1D4B _ E9, 00000087

?_0192: mov     rax, qword [rbp-18H]                    ; 1D50 _ 48: 8B. 45, E8
        mov     rdx, qword [rax+28H]                    ; 1D54 _ 48: 8B. 50, 28
        mov     rax, qword [rbp-28H]                    ; 1D58 _ 48: 8B. 45, D8
        mov     rax, qword [rax+8H]                     ; 1D5C _ 48: 8B. 40, 08
        sub     rdx, rax                                ; 1D60 _ 48: 29. C2
        mov     qword [rbp-10H], rdx                    ; 1D63 _ 48: 89. 55, F0
        cmp     qword [rbp-10H], -126                   ; 1D67 _ 48: 83. 7D, F0, 82
        jl      ?_0193                                  ; 1D6C _ 7C, 0A
        cmp     qword [rbp-10H], 142                    ; 1D6E _ 48: 81. 7D, F0, 0000008E
        jle     ?_0194                                  ; 1D76 _ 7E, 07
?_0193: mov     eax, 0                                  ; 1D78 _ B8, 00000000
        jmp     ?_0198                                  ; 1D7D _ EB, 58

?_0194: cmp     qword [rbp-10H], -113                   ; 1D7F _ 48: 83. 7D, F0, 8F
        jl      ?_0195                                  ; 1D84 _ 7C, 0A
        cmp     qword [rbp-10H], 129                    ; 1D86 _ 48: 81. 7D, F0, 00000081
        jle     ?_0197                                  ; 1D8E _ 7E, 42
?_0195: mov     rdx, qword [rbp-30H]                    ; 1D90 _ 48: 8B. 55, D0
        mov     rax, qword [rbp-28H]                    ; 1D94 _ 48: 8B. 45, D8
        mov     rsi, rdx                                ; 1D98 _ 48: 89. D6
        mov     rdi, rax                                ; 1D9B _ 48: 89. C7
        call    calcsize_speculative                    ; 1D9E _ E8, 00001759
        mov     qword [rbp-8H], rax                     ; 1DA3 _ 48: 89. 45, F8
        cmp     qword [rbp-8H], 0                       ; 1DA7 _ 48: 83. 7D, F8, 00
        jns     ?_0196                                  ; 1DAC _ 79, 07
        mov     eax, 0                                  ; 1DAE _ B8, 00000000
        jmp     ?_0198                                  ; 1DB3 _ EB, 22

?_0196: mov     rax, qword [rbp-8H]                     ; 1DB5 _ 48: 8B. 45, F8
        sub     qword [rbp-10H], rax                    ; 1DB9 _ 48: 29. 45, F0
        mov     rax, qword [rbp-10H]                    ; 1DBD _ 48: 8B. 45, F0
        movsx   rax, al                                 ; 1DC1 _ 48: 0F BE. C0
        cmp     qword [rbp-10H], rax                    ; 1DC5 _ 48: 39. 45, F0
        jz      ?_0197                                  ; 1DC9 _ 74, 07
        mov     eax, 0                                  ; 1DCB _ B8, 00000000
        jmp     ?_0198                                  ; 1DD0 _ EB, 05

?_0197: mov     eax, 30                                 ; 1DD2 _ B8, 0000001E
?_0198: leave                                           ; 1DD7 _ C9
        ret                                             ; 1DD8 _ C3

merge_resb:; Local function
        push    rbp                                     ; 1DD9 _ 55
        mov     rbp, rsp                                ; 1DDA _ 48: 89. E5
        sub     rsp, 32                                 ; 1DDD _ 48: 83. EC, 20
        mov     qword [rbp-18H], rdi                    ; 1DE1 _ 48: 89. 7D, E8
        mov     qword [rbp-20H], rsi                    ; 1DE5 _ 48: 89. 75, E0
        mov     rax, qword [rbp-18H]                    ; 1DE9 _ 48: 8B. 45, E8
        mov     eax, dword [rax]                        ; 1DED _ 8B. 00
        mov     edi, eax                                ; 1DEF _ 89. C7
        call    resb_bytes                              ; 1DF1 _ E8, FFFFE637
        mov     dword [rbp-4H], eax                     ; 1DF6 _ 89. 45, FC
        cmp     dword [rbp-4H], 0                       ; 1DF9 _ 83. 7D, FC, 00
        sete    al                                      ; 1DFD _ 0F 94. C0
        movzx   eax, al                                 ; 1E00 _ 0F B6. C0
        test    rax, rax                                ; 1E03 _ 48: 85. C0
        jz      ?_0199                                  ; 1E06 _ 74, 06
        mov     rax, qword [rbp-20H]                    ; 1E08 _ 48: 8B. 45, E0
        jmp     ?_0201                                  ; 1E0C _ EB, 68

?_0199: mov     eax, dword [rbp-4H]                     ; 1E0E _ 8B. 45, FC
        movsxd  rdx, eax                                ; 1E11 _ 48: 63. D0
        mov     rax, qword [rbp-18H]                    ; 1E14 _ 48: 8B. 45, E8
        mov     rax, qword [rax+0E8H]                   ; 1E18 _ 48: 8B. 80, 000000E8
        imul    rax, rdx                                ; 1E1F _ 48: 0F AF. C2
        cmp     qword [rbp-20H], rax                    ; 1E23 _ 48: 39. 45, E0
        jz      ?_0200                                  ; 1E27 _ 74, 06
        mov     rax, qword [rbp-20H]                    ; 1E29 _ 48: 8B. 45, E0
        jmp     ?_0201                                  ; 1E2D _ EB, 47

?_0200: mov     rax, qword [rbp-18H]                    ; 1E2F _ 48: 8B. 45, E8
        mov     rdx, qword [rax+0E8H]                   ; 1E33 _ 48: 8B. 90, 000000E8
        mov     rax, qword [rbp-18H]                    ; 1E3A _ 48: 8B. 45, E8
        mov     eax, dword [rax+74H]                    ; 1E3E _ 8B. 40, 74
        cdqe                                            ; 1E41 _ 48: 98
        imul    rdx, rax                                ; 1E43 _ 48: 0F AF. D0
        mov     rax, qword [rbp-18H]                    ; 1E47 _ 48: 8B. 45, E8
        mov     qword [rax+0E8H], rdx                   ; 1E4B _ 48: 89. 90, 000000E8
        mov     rax, qword [rbp-18H]                    ; 1E52 _ 48: 8B. 45, E8
        mov     eax, dword [rax+74H]                    ; 1E56 _ 8B. 40, 74
        cdqe                                            ; 1E59 _ 48: 98
        mov     rdx, qword [rbp-20H]                    ; 1E5B _ 48: 8B. 55, E0
        imul    rax, rdx                                ; 1E5F _ 48: 0F AF. C2
        mov     qword [rbp-20H], rax                    ; 1E63 _ 48: 89. 45, E0
        mov     rax, qword [rbp-18H]                    ; 1E67 _ 48: 8B. 45, E8
        mov     dword [rax+74H], 1                      ; 1E6B _ C7. 40, 74, 00000001
        mov     rax, qword [rbp-20H]                    ; 1E72 _ 48: 8B. 45, E0
?_0201: leave                                           ; 1E76 _ C9
        ret                                             ; 1E77 _ C3

pad_bytes:; Local function
        push    rbp                                     ; 1E78 _ 55
        mov     rbp, rsp                                ; 1E79 _ 48: 89. E5
        mov     qword [rbp-18H], rdi                    ; 1E7C _ 48: 89. 7D, E8
        mov     qword [rbp-20H], rsi                    ; 1E80 _ 48: 89. 75, E0
        mov     rax, qword [rbp-18H]                    ; 1E84 _ 48: 8B. 45, E8
        mov     edx, 0                                  ; 1E88 _ BA, 00000000
        div     qword [rbp-20H]                         ; 1E8D _ 48: F7. 75, E0
        mov     qword [rbp-8H], rdx                     ; 1E91 _ 48: 89. 55, F8
        cmp     qword [rbp-8H], 0                       ; 1E95 _ 48: 83. 7D, F8, 00
        jz      ?_0202                                  ; 1E9A _ 74, 0A
        mov     rax, qword [rbp-20H]                    ; 1E9C _ 48: 8B. 45, E0
        sub     rax, qword [rbp-8H]                     ; 1EA0 _ 48: 2B. 45, F8
        jmp     ?_0203                                  ; 1EA4 _ EB, 05

?_0202: mov     eax, 0                                  ; 1EA6 _ B8, 00000000
?_0203: pop     rbp                                     ; 1EAB _ 5D
        ret                                             ; 1EAC _ C3

out_eops:; Local function
        push    rbp                                     ; 1EAD _ 55
        mov     rbp, rsp                                ; 1EAE _ 48: 89. E5
        sub     rsp, 48                                 ; 1EB1 _ 48: 83. EC, 30
        mov     qword [rbp-28H], rdi                    ; 1EB5 _ 48: 89. 7D, D8
        mov     qword [rbp-30H], rsi                    ; 1EB9 _ 48: 89. 75, D0
        jmp     ?_0220                                  ; 1EBD _ E9, 00000295

?_0204: mov     rax, qword [rbp-30H]                    ; 1EC2 _ 48: 8B. 45, D0
        mov     rax, qword [rax+20H]                    ; 1EC6 _ 48: 8B. 40, 20
        mov     qword [rbp-18H], rax                    ; 1ECA _ 48: 89. 45, E8
        mov     rax, qword [rbp-30H]                    ; 1ECE _ 48: 8B. 45, D0
        mov     eax, dword [rax+28H]                    ; 1ED2 _ 8B. 40, 28
        cmp     eax, 6                                  ; 1ED5 _ 83. F8, 06
        je      ?_0217                                  ; 1ED8 _ 0F 84, 0000022E
        cmp     eax, 6                                  ; 1EDE _ 83. F8, 06
        ja      ?_0219                                  ; 1EE1 _ 0F 87, 00000265
        cmp     eax, 5                                  ; 1EE7 _ 83. F8, 05
        jz      ?_0207                                  ; 1EEA _ 74, 5B
        cmp     eax, 5                                  ; 1EEC _ 83. F8, 05
        ja      ?_0219                                  ; 1EEF _ 0F 87, 00000257
        cmp     eax, 4                                  ; 1EF5 _ 83. F8, 04
        ja      ?_0219                                  ; 1EF8 _ 0F 87, 0000024E
        cmp     eax, 2                                  ; 1EFE _ 83. F8, 02
        jnc     ?_0214                                  ; 1F01 _ 0F 83, 00000164
        test    eax, eax                                ; 1F07 _ 85. C0
        je      ?_0218                                  ; 1F09 _ 0F 84, 0000023C
        cmp     eax, 1                                  ; 1F0F _ 83. F8, 01
        jne     ?_0219                                  ; 1F12 _ 0F 85, 00000234
        jmp     ?_0206                                  ; 1F18 _ EB, 17

?_0205: mov     rax, qword [rbp-30H]                    ; 1F1A _ 48: 8B. 45, D0
        mov     rdx, qword [rax+8H]                     ; 1F1E _ 48: 8B. 50, 08
        mov     rax, qword [rbp-28H]                    ; 1F22 _ 48: 8B. 45, D8
        mov     rsi, rdx                                ; 1F26 _ 48: 89. D6
        mov     rdi, rax                                ; 1F29 _ 48: 89. C7
        call    out_eops                                ; 1F2C _ E8, FFFFFF7C
?_0206: mov     rax, qword [rbp-18H]                    ; 1F31 _ 48: 8B. 45, E8
        lea     rdx, [rax-1H]                           ; 1F35 _ 48: 8D. 50, FF
        mov     qword [rbp-18H], rdx                    ; 1F39 _ 48: 89. 55, E8
        test    rax, rax                                ; 1F3D _ 48: 85. C0
        jnz     ?_0205                                  ; 1F40 _ 75, D8
        jmp     ?_0219                                  ; 1F42 _ E9, 00000205

?_0207: mov     rax, qword [rbp-30H]                    ; 1F47 _ 48: 8B. 45, D0
        mov     eax, dword [rax+2CH]                    ; 1F4B _ 8B. 40, 2C
        cmp     eax, 8                                  ; 1F4E _ 83. F8, 08
        jle     ?_0213                                  ; 1F51 _ 0F 8E, 000000FA
        mov     rax, qword [rbp-30H]                    ; 1F57 _ 48: 8B. 45, D0
        mov     eax, dword [rax+2CH]                    ; 1F5B _ 8B. 40, 2C
        lea     edx, [rax*8]                            ; 1F5E _ 8D. 14 C5, 00000000
        lea     rax, [rel ?_1046]                       ; 1F65 _ 48: 8D. 05, 00000000(rel)
        mov     esi, edx                                ; 1F6C _ 89. D6
        mov     rdi, rax                                ; 1F6E _ 48: 89. C7
        mov     eax, 0                                  ; 1F71 _ B8, 00000000
        call    nasm_nonfatal                           ; 1F76 _ E8, 00000000(PLT r)
        jmp     ?_0219                                  ; 1F7B _ E9, 000001CC

?_0208: mov     rax, qword [rbp-28H]                    ; 1F80 _ 48: 8B. 45, D8
        mov     dword [rax+1CH], 0                      ; 1F84 _ C7. 40, 1C, 00000000
        mov     rax, qword [rbp-30H]                    ; 1F8B _ 48: 8B. 45, D0
        mov     eax, dword [rax+2CH]                    ; 1F8F _ 8B. 40, 2C
        movsxd  rdx, eax                                ; 1F92 _ 48: 63. D0
        mov     rax, qword [rbp-28H]                    ; 1F95 _ 48: 8B. 45, D8
        mov     qword [rax+28H], rdx                    ; 1F99 _ 48: 89. 50, 28
        mov     rax, qword [rbp-28H]                    ; 1F9D _ 48: 8B. 45, D8
        mov     rax, qword [rax+28H]                    ; 1FA1 _ 48: 8B. 40, 28
        mov     edx, eax                                ; 1FA5 _ 89. C2
        mov     rax, qword [rbp-28H]                    ; 1FA7 _ 48: 8B. 45, D8
        mov     dword [rax+18H], edx                    ; 1FAB _ 89. 50, 18
        mov     rax, qword [rbp-30H]                    ; 1FAE _ 48: 8B. 45, D0
        mov     edx, dword [rax+10H]                    ; 1FB2 _ 8B. 50, 10
        mov     rax, qword [rbp-28H]                    ; 1FB5 _ 48: 8B. 45, D8
        mov     dword [rax+48H], edx                    ; 1FB9 _ 89. 50, 48
        mov     rax, qword [rbp-30H]                    ; 1FBC _ 48: 8B. 45, D0
        mov     rax, qword [rax+8H]                     ; 1FC0 _ 48: 8B. 40, 08
        mov     rdx, rax                                ; 1FC4 _ 48: 89. C2
        mov     rax, qword [rbp-28H]                    ; 1FC7 _ 48: 8B. 45, D8
        mov     qword [rax+40H], rdx                    ; 1FCB _ 48: 89. 50, 40
        mov     rax, qword [rbp-30H]                    ; 1FCF _ 48: 8B. 45, D0
        mov     edx, dword [rax+14H]                    ; 1FD3 _ 8B. 50, 14
        mov     rax, qword [rbp-28H]                    ; 1FD6 _ 48: 8B. 45, D8
        mov     dword [rax+4CH], edx                    ; 1FDA _ 89. 50, 4C
        mov     rax, qword [rbp-28H]                    ; 1FDD _ 48: 8B. 45, D8
        mov     qword [rax+50H], 0                      ; 1FE1 _ 48: C7. 40, 50, 00000000
        mov     rax, qword [rbp-30H]                    ; 1FE9 _ 48: 8B. 45, D0
        mov     eax, dword [rax+10H]                    ; 1FED _ 8B. 40, 10
        cmp     eax, -1                                 ; 1FF0 _ 83. F8, FF
        jz      ?_0209                                  ; 1FF3 _ 74, 26
        mov     rax, qword [rbp-30H]                    ; 1FF5 _ 48: 8B. 45, D0
        mov     eax, dword [rax+10H]                    ; 1FF9 _ 8B. 40, 10
        and     eax, 01H                                ; 1FFC _ 83. E0, 01
        test    eax, eax                                ; 1FFF _ 85. C0
        jz      ?_0209                                  ; 2001 _ 74, 18
        mov     rax, qword [rbp-28H]                    ; 2003 _ 48: 8B. 45, D8
        mov     dword [rax+10H], 5                      ; 2007 _ C7. 40, 10, 00000005
        mov     rax, qword [rbp-28H]                    ; 200E _ 48: 8B. 45, D8
        mov     dword [rax+14H], 2                      ; 2012 _ C7. 40, 14, 00000002
        jmp     ?_0212                                  ; 2019 _ EB, 2A

?_0209: mov     rax, qword [rbp-30H]                    ; 201B _ 48: 8B. 45, D0
        movzx   eax, byte [rax+18H]                     ; 201F _ 0F B6. 40, 18
        test    al, al                                  ; 2023 _ 84. C0
        jz      ?_0210                                  ; 2025 _ 74, 07
        mov     edx, 4                                  ; 2027 _ BA, 00000004
        jmp     ?_0211                                  ; 202C _ EB, 05

?_0210: mov     edx, 3                                  ; 202E _ BA, 00000003
?_0211: mov     rax, qword [rbp-28H]                    ; 2033 _ 48: 8B. 45, D8
        mov     dword [rax+10H], edx                    ; 2037 _ 89. 50, 10
        mov     rax, qword [rbp-28H]                    ; 203A _ 48: 8B. 45, D8
        mov     dword [rax+14H], 0                      ; 203E _ C7. 40, 14, 00000000
?_0212: mov     rax, qword [rbp-28H]                    ; 2045 _ 48: 8B. 45, D8
        mov     rdi, rax                                ; 2049 _ 48: 89. C7
        call    out                                     ; 204C _ E8, FFFFEDEE
?_0213: mov     rax, qword [rbp-18H]                    ; 2051 _ 48: 8B. 45, E8
        lea     rdx, [rax-1H]                           ; 2055 _ 48: 8D. 50, FF
        mov     qword [rbp-18H], rdx                    ; 2059 _ 48: 89. 55, E8
        test    rax, rax                                ; 205D _ 48: 85. C0
        jne     ?_0208                                  ; 2060 _ 0F 85, FFFFFF1A
        jmp     ?_0219                                  ; 2066 _ E9, 000000E1

?_0214: mov     rax, qword [rbp-30H]                    ; 206B _ 48: 8B. 45, D0
        mov     eax, dword [rax+2CH]                    ; 206F _ 8B. 40, 2C
        movsxd  rdx, eax                                ; 2072 _ 48: 63. D0
        mov     rax, qword [rbp-30H]                    ; 2075 _ 48: 8B. 45, D0
        mov     rax, qword [rax+10H]                    ; 2079 _ 48: 8B. 40, 10
        mov     rsi, rdx                                ; 207D _ 48: 89. D6
        mov     rdi, rax                                ; 2080 _ 48: 89. C7
        call    pad_bytes                               ; 2083 _ E8, FFFFFDF0
        mov     qword [rbp-10H], rax                    ; 2088 _ 48: 89. 45, F0
        mov     rax, qword [rbp-30H]                    ; 208C _ 48: 8B. 45, D0
        mov     rdx, qword [rax+10H]                    ; 2090 _ 48: 8B. 50, 10
        mov     rax, qword [rbp-10H]                    ; 2094 _ 48: 8B. 45, F0
        add     rax, rdx                                ; 2098 _ 48: 01. D0
        mov     qword [rbp-8H], rax                     ; 209B _ 48: 89. 45, F8
        jmp     ?_0216                                  ; 209F _ EB, 58

?_0215: mov     rax, qword [rbp-28H]                    ; 20A1 _ 48: 8B. 45, D8
        mov     dword [rax+1CH], 0                      ; 20A5 _ C7. 40, 1C, 00000000
        mov     rax, qword [rbp-8H]                     ; 20AC _ 48: 8B. 45, F8
        mov     edx, eax                                ; 20B0 _ 89. C2
        mov     rax, qword [rbp-28H]                    ; 20B2 _ 48: 8B. 45, D8
        mov     dword [rax+18H], edx                    ; 20B6 _ 89. 50, 18
        mov     rax, qword [rbp-30H]                    ; 20B9 _ 48: 8B. 45, D0
        mov     rdx, qword [rax+10H]                    ; 20BD _ 48: 8B. 50, 10
        mov     rax, qword [rbp-30H]                    ; 20C1 _ 48: 8B. 45, D0
        mov     rcx, qword [rax+8H]                     ; 20C5 _ 48: 8B. 48, 08
        mov     rax, qword [rbp-28H]                    ; 20C9 _ 48: 8B. 45, D8
        mov     rsi, rcx                                ; 20CD _ 48: 89. CE
        mov     rdi, rax                                ; 20D0 _ 48: 89. C7
        call    out_rawdata                             ; 20D3 _ E8, FFFFF46C
        cmp     qword [rbp-10H], 0                      ; 20D8 _ 48: 83. 7D, F0, 00
        jz      ?_0216                                  ; 20DD _ 74, 1A
        mov     rdx, qword [rbp-10H]                    ; 20DF _ 48: 8B. 55, F0
        lea     rcx, [rel zero_buffer]                  ; 20E3 _ 48: 8D. 0D, 00000000(rel)
        mov     rax, qword [rbp-28H]                    ; 20EA _ 48: 8B. 45, D8
        mov     rsi, rcx                                ; 20EE _ 48: 89. CE
        mov     rdi, rax                                ; 20F1 _ 48: 89. C7
        call    out_rawdata                             ; 20F4 _ E8, FFFFF44B
?_0216: mov     rax, qword [rbp-18H]                    ; 20F9 _ 48: 8B. 45, E8
        lea     rdx, [rax-1H]                           ; 20FD _ 48: 8D. 50, FF
        mov     qword [rbp-18H], rdx                    ; 2101 _ 48: 89. 55, E8
        test    rax, rax                                ; 2105 _ 48: 85. C0
        jnz     ?_0215                                  ; 2108 _ 75, 97
        jmp     ?_0219                                  ; 210A _ EB, 40

?_0217: mov     rax, qword [rbp-28H]                    ; 210C _ 48: 8B. 45, D8
        mov     dword [rax+1CH], 0                      ; 2110 _ C7. 40, 1C, 00000000
        mov     rax, qword [rbp-30H]                    ; 2117 _ 48: 8B. 45, D0
        mov     eax, dword [rax+2CH]                    ; 211B _ 8B. 40, 2C
        mov     edx, eax                                ; 211E _ 89. C2
        mov     rax, qword [rbp-18H]                    ; 2120 _ 48: 8B. 45, E8
        imul    eax, edx                                ; 2124 _ 0F AF. C2
        mov     edx, eax                                ; 2127 _ 89. C2
        mov     rax, qword [rbp-28H]                    ; 2129 _ 48: 8B. 45, D8
        mov     dword [rax+18H], edx                    ; 212D _ 89. 50, 18
        mov     rax, qword [rbp-28H]                    ; 2130 _ 48: 8B. 45, D8
        mov     eax, dword [rax+18H]                    ; 2134 _ 8B. 40, 18
        movsxd  rdx, eax                                ; 2137 _ 48: 63. D0
        mov     rax, qword [rbp-28H]                    ; 213A _ 48: 8B. 45, D8
        mov     rsi, rdx                                ; 213E _ 48: 89. D6
        mov     rdi, rax                                ; 2141 _ 48: 89. C7
        call    out_reserve                             ; 2144 _ E8, FFFFF4FD
        jmp     ?_0219                                  ; 2149 _ EB, 01

?_0218: nop                                             ; 214B _ 90
?_0219: mov     rax, qword [rbp-30H]                    ; 214C _ 48: 8B. 45, D0
        mov     rax, qword [rax]                        ; 2150 _ 48: 8B. 00
        mov     qword [rbp-30H], rax                    ; 2153 _ 48: 89. 45, D0
?_0220: cmp     qword [rbp-30H], 0                      ; 2157 _ 48: 83. 7D, D0, 00
        jne     ?_0204                                  ; 215C _ 0F 85, FFFFFD60
        nop                                             ; 2162 _ 90
        nop                                             ; 2163 _ 90
        leave                                           ; 2164 _ C9
        ret                                             ; 2165 _ C3

list_add_template_info:; Local function
        push    rbp                                     ; 2166 _ 55
        mov     rbp, rsp                                ; 2167 _ 48: 89. E5
        sub     rsp, 32                                 ; 216A _ 48: 83. EC, 20
        mov     qword [rbp-18H], rdi                    ; 216E _ 48: 89. 7D, E8
        mov     rax, qword [rbp-18H]                    ; 2172 _ 48: 8B. 45, E8
        mov     rax, qword [rax+0B0H]                   ; 2176 _ 48: 8B. 80, 000000B0
        mov     ecx, dword [rax+4CH]                    ; 217D _ 8B. 48, 4C
        mov     rax, qword [rbp-18H]                    ; 2180 _ 48: 8B. 45, E8
        mov     edx, dword [rax+228H]                   ; 2184 _ 8B. 90, 00000228
        mov     rax, qword [rbp-18H]                    ; 218A _ 48: 8B. 45, E8
        mov     eax, dword [rax]                        ; 218E _ 8B. 00
        cdqe                                            ; 2190 _ 48: 98
        lea     rsi, [rax*8]                            ; 2192 _ 48: 8D. 34 C5, 00000000
        lea     rax, [rel nasm_insn_names]              ; 219A _ 48: 8D. 05, 00000000(rel)
        mov     rax, qword [rsi+rax]                    ; 21A1 _ 48: 8B. 04 06
        lea     rdi, [rel ?_1047]                       ; 21A5 _ 48: 8D. 3D, 00000000(rel)
        mov     rsi, rax                                ; 21AC _ 48: 89. C6
        mov     eax, 0                                  ; 21AF _ B8, 00000000
        call    nasm_asprintf                           ; 21B4 _ E8, 00000000(PLT r)
        mov     qword [rbp-8H], rax                     ; 21B9 _ 48: 89. 45, F8
        mov     rax, qword [rel lfmt]                   ; 21BD _ 48: 8B. 05, 00000000(rel)
        mov     rcx, qword [rax+18H]                    ; 21C4 _ 48: 8B. 48, 18
        mov     rax, qword [rbp-8H]                     ; 21C8 _ 48: 8B. 45, F8
        mov     rdx, rax                                ; 21CC _ 48: 89. C2
        mov     esi, 4294967295                         ; 21CF _ BE, FFFFFFFF
        mov     edi, 2                                  ; 21D4 _ BF, 00000002
        call    rcx                                     ; 21D9 _ FF. D1
        mov     rax, qword [rbp-8H]                     ; 21DB _ 48: 8B. 45, F8
        mov     rdi, rax                                ; 21DF _ 48: 89. C7
        call    nasm_free                               ; 21E2 _ E8, 00000000(PLT r)
        nop                                             ; 21E7 _ 90
        leave                                           ; 21E8 _ C9
        ret                                             ; 21E9 _ C3

assemble:; Local function
        push    rbp                                     ; 21EA _ 55
        mov     rbp, rsp                                ; 21EB _ 48: 89. E5
        sub     rsp, 304                                ; 21EE _ 48: 81. EC, 00000130
        mov     qword [rbp-128H], rdi                   ; 21F5 _ 48: 89. BD, FFFFFED8
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        mov     rax, qword [fs:abs 28H]                 ; 21FC _ 64 48: 8B. 04 25, 00000028
        mov     qword [rbp-8H], rax                     ; 2205 _ 48: 89. 45, F8
        xor     eax, eax                                ; 2209 _ 31. C0
        mov     rax, qword [rbp-128H]                   ; 220B _ 48: 8B. 85, FFFFFED8
        mov     rax, qword [rax+8H]                     ; 2212 _ 48: 8B. 40, 08
        mov     qword [rbp-0C0H], rax                   ; 2216 _ 48: 89. 85, FFFFFF40
        mov     rax, qword [rbp-128H]                   ; 221D _ 48: 8B. 85, FFFFFED8
        mov     eax, dword [rax]                        ; 2224 _ 8B. 00
        cmp     eax, -1                                 ; 2226 _ 83. F8, FF
        jnz     ?_0221                                  ; 2229 _ 75, 0A
        mov     eax, 0                                  ; 222B _ B8, 00000000
        jmp     ?_0262                                  ; 2230 _ E9, 000008B9

?_0221: lea     rax, [rbp-0A0H]                         ; 2235 _ 48: 8D. 85, FFFFFF60
        mov     edx, 144                                ; 223C _ BA, 00000090
        mov     esi, 0                                  ; 2241 _ BE, 00000000
        mov     rdi, rax                                ; 2246 _ 48: 89. C7
        call    memset                                  ; 2249 _ E8, 00000000(PLT r)
        mov     rax, qword [rbp-128H]                   ; 224E _ 48: 8B. 85, FFFFFED8
        mov     rdx, qword [rax+10H]                    ; 2255 _ 48: 8B. 50, 10
        mov     rax, qword [rax+8H]                     ; 2259 _ 48: 8B. 40, 08
        mov     qword [rbp-0A0H], rax                   ; 225D _ 48: 89. 85, FFFFFF60
        mov     qword [rbp-98H], rdx                    ; 2264 _ 48: 89. 95, FFFFFF68
        mov     rax, qword [rbp-128H]                   ; 226B _ 48: 8B. 85, FFFFFED8
        movzx   eax, byte [rax+7AH]                     ; 2272 _ 0F B6. 40, 7A
        movzx   eax, al                                 ; 2276 _ 0F B6. C0
        mov     dword [rbp-80H], eax                    ; 2279 _ 89. 45, 80
        mov     rax, qword [rbp-128H]                   ; 227C _ 48: 8B. 85, FFFFFED8
        mov     eax, dword [rax]                        ; 2283 _ 8B. 00
        mov     edi, eax                                ; 2285 _ 89. C7
        call    opcode_is_db                            ; 2287 _ E8, FFFFE159
        test    al, al                                  ; 228C _ 84. C0
        jz      ?_0222                                  ; 228E _ 74, 22
        mov     rax, qword [rbp-128H]                   ; 2290 _ 48: 8B. 85, FFFFFED8
        mov     rdx, qword [rax+68H]                    ; 2297 _ 48: 8B. 50, 68
        lea     rax, [rbp-0A0H]                         ; 229B _ 48: 8D. 85, FFFFFF60
        mov     rsi, rdx                                ; 22A2 _ 48: 89. D6
        mov     rdi, rax                                ; 22A5 _ 48: 89. C7
        call    out_eops                                ; 22A8 _ E8, FFFFFC00
        jmp     ?_0261                                  ; 22AD _ E9, 0000082E

?_0222: mov     rax, qword [rbp-128H]                   ; 22B2 _ 48: 8B. 85, FFFFFED8
        mov     eax, dword [rax]                        ; 22B9 _ 8B. 00
        cmp     eax, 16                                 ; 22BB _ 83. F8, 10
        jne     ?_0249                                  ; 22BE _ 0F 85, 0000053B
        mov     rax, qword [rbp-128H]                   ; 22C4 _ 48: 8B. 85, FFFFFED8
        mov     rax, qword [rax+68H]                    ; 22CB _ 48: 8B. 40, 68
        mov     rax, qword [rax+8H]                     ; 22CF _ 48: 8B. 40, 08
        mov     qword [rbp-0B0H], rax                   ; 22D3 _ 48: 89. 85, FFFFFF50
        mov     rax, qword [rbp-128H]                   ; 22DA _ 48: 8B. 85, FFFFFED8
        mov     eax, dword [rax+74H]                    ; 22E1 _ 8B. 40, 74
        cdqe                                            ; 22E4 _ 48: 98
        mov     qword [rbp-110H], rax                   ; 22E6 _ 48: 89. 85, FFFFFEF0
        mov     qword [rbp-108H], 0                     ; 22ED _ 48: C7. 85, FFFFFEF8, 00000000
        mov     qword [rbp-0F8H], 0                     ; 22F8 _ 48: C7. 85, FFFFFF08, 00000000
        mov     qword [rbp-0F0H], 0                     ; 2303 _ 48: C7. 85, FFFFFF10, 00000000
        mov     qword [rbp-0E8H], 0                     ; 230E _ 48: C7. 85, FFFFFF18, 00000000
        mov     qword [rbp-0E0H], 0                     ; 2319 _ 48: C7. 85, FFFFFF20, 00000000
        cmp     qword [rbp-110H], 0                     ; 2324 _ 48: 83. BD, FFFFFEF0, 00
        je      ?_0247                                  ; 232C _ 0F 84, 000004B9
        mov     rax, qword [rbp-0B0H]                   ; 2332 _ 48: 8B. 85, FFFFFF50
        mov     esi, 4                                  ; 2339 _ BE, 00000004
        mov     rdi, rax                                ; 233E _ 48: 89. C7
        call    nasm_open_read                          ; 2341 _ E8, 00000000(PLT r)
        mov     qword [rbp-0A8H], rax                   ; 2346 _ 48: 89. 85, FFFFFF58
        cmp     qword [rbp-0A8H], 0                     ; 234D _ 48: 83. BD, FFFFFF58, 00
        jnz     ?_0223                                  ; 2355 _ 75, 23
        mov     rax, qword [rbp-0B0H]                   ; 2357 _ 48: 8B. 85, FFFFFF50
        lea     rdx, [rel ?_1048]                       ; 235E _ 48: 8D. 15, 00000000(rel)
        mov     rsi, rax                                ; 2365 _ 48: 89. C6
        mov     rdi, rdx                                ; 2368 _ 48: 89. D7
        mov     eax, 0                                  ; 236B _ B8, 00000000
        call    nasm_nonfatal                           ; 2370 _ E8, 00000000(PLT r)
        jmp     ?_0248                                  ; 2375 _ E9, 00000472

?_0223: mov     rax, qword [rbp-0A8H]                   ; 237A _ 48: 8B. 85, FFFFFF58
        mov     rdi, rax                                ; 2381 _ 48: 89. C7
        call    nasm_file_size                          ; 2384 _ E8, 00000000(PLT r)
        mov     qword [rbp-100H], rax                   ; 2389 _ 48: 89. 85, FFFFFF00
        cmp     qword [rbp-100H], -1                    ; 2390 _ 48: 83. BD, FFFFFF00, FF
        jnz     ?_0224                                  ; 2398 _ 75, 23
        mov     rax, qword [rbp-0B0H]                   ; 239A _ 48: 8B. 85, FFFFFF50
        lea     rdx, [rel ?_1049]                       ; 23A1 _ 48: 8D. 15, 00000000(rel)
        mov     rsi, rax                                ; 23A8 _ 48: 89. C6
        mov     rdi, rdx                                ; 23AB _ 48: 89. D7
        mov     eax, 0                                  ; 23AE _ B8, 00000000
        call    nasm_nonfatal                           ; 23B3 _ E8, 00000000(PLT r)
        jmp     ?_0244                                  ; 23B8 _ E9, 000003E1

?_0224: mov     rax, qword [rbp-128H]                   ; 23BD _ 48: 8B. 85, FFFFFED8
        mov     rax, qword [rax+68H]                    ; 23C4 _ 48: 8B. 40, 68
        mov     rax, qword [rax]                        ; 23C8 _ 48: 8B. 00
        test    rax, rax                                ; 23CB _ 48: 85. C0
        je      ?_0226                                  ; 23CE _ 0F 84, 00000094
        mov     rax, qword [rbp-128H]                   ; 23D4 _ 48: 8B. 85, FFFFFED8
        mov     rax, qword [rax+68H]                    ; 23DB _ 48: 8B. 40, 68
        mov     rax, qword [rax]                        ; 23DF _ 48: 8B. 00
        mov     rax, qword [rax+8H]                     ; 23E2 _ 48: 8B. 40, 08
        mov     qword [rbp-108H], rax                   ; 23E6 _ 48: 89. 85, FFFFFEF8
        mov     rax, qword [rbp-108H]                   ; 23ED _ 48: 8B. 85, FFFFFEF8
        cmp     rax, qword [rbp-100H]                   ; 23F4 _ 48: 3B. 85, FFFFFF00
        jl      ?_0225                                  ; 23FB _ 7C, 0D
        mov     qword [rbp-100H], 0                     ; 23FD _ 48: C7. 85, FFFFFF00, 00000000
        jmp     ?_0226                                  ; 2408 _ EB, 5E

?_0225: mov     rax, qword [rbp-108H]                   ; 240A _ 48: 8B. 85, FFFFFEF8
        sub     qword [rbp-100H], rax                   ; 2411 _ 48: 29. 85, FFFFFF00
        mov     rax, qword [rbp-128H]                   ; 2418 _ 48: 8B. 85, FFFFFED8
        mov     rax, qword [rax+68H]                    ; 241F _ 48: 8B. 40, 68
        mov     rax, qword [rax]                        ; 2423 _ 48: 8B. 00
        mov     rax, qword [rax]                        ; 2426 _ 48: 8B. 00
        test    rax, rax                                ; 2429 _ 48: 85. C0
        jz      ?_0226                                  ; 242C _ 74, 3A
        mov     rax, qword [rbp-128H]                   ; 242E _ 48: 8B. 85, FFFFFED8
        mov     rax, qword [rax+68H]                    ; 2435 _ 48: 8B. 40, 68
        mov     rax, qword [rax]                        ; 2439 _ 48: 8B. 00
        mov     rax, qword [rax]                        ; 243C _ 48: 8B. 00
        mov     rax, qword [rax+8H]                     ; 243F _ 48: 8B. 40, 08
        cmp     qword [rbp-100H], rax                   ; 2443 _ 48: 39. 85, FFFFFF00
        jle     ?_0226                                  ; 244A _ 7E, 1C
        mov     rax, qword [rbp-128H]                   ; 244C _ 48: 8B. 85, FFFFFED8
        mov     rax, qword [rax+68H]                    ; 2453 _ 48: 8B. 40, 68
        mov     rax, qword [rax]                        ; 2457 _ 48: 8B. 00
        mov     rax, qword [rax]                        ; 245A _ 48: 8B. 00
        mov     rax, qword [rax+8H]                     ; 245D _ 48: 8B. 40, 08
        mov     qword [rbp-100H], rax                   ; 2461 _ 48: 89. 85, FFFFFF00
?_0226: mov     rax, qword [rel lfmt]                   ; 2468 _ 48: 8B. 05, 00000000(rel)
        mov     rax, qword [rax+38H]                    ; 246F _ 48: 8B. 40, 38
        mov     rdx, qword [rbp-0A0H]                   ; 2473 _ 48: 8B. 95, FFFFFF60
        mov     rdi, rdx                                ; 247A _ 48: 89. D7
        call    rax                                     ; 247D _ FF. D0
        cmp     qword [rbp-100H], 0                     ; 247F _ 48: 83. BD, FFFFFF00, 00
        je      ?_0240                                  ; 2487 _ 0F 84, 000002D9
        mov     rdx, qword [rbp-100H]                   ; 248D _ 48: 8B. 95, FFFFFF00
        mov     rcx, qword [rbp-108H]                   ; 2494 _ 48: 8B. 8D, FFFFFEF8
        mov     rax, qword [rbp-0A8H]                   ; 249B _ 48: 8B. 85, FFFFFF58
        mov     rsi, rcx                                ; 24A2 _ 48: 89. CE
        mov     rdi, rax                                ; 24A5 _ 48: 89. C7
        call    nasm_map_file                           ; 24A8 _ E8, 00000000(PLT r)
        mov     qword [rbp-0F8H], rax                   ; 24AD _ 48: 89. 85, FFFFFF08
        cmp     qword [rbp-0F8H], 0                     ; 24B4 _ 48: 83. BD, FFFFFF08, 00
        jnz     ?_0229                                  ; 24BC _ 75, 3E
        cmp     qword [rbp-100H], 1048575               ; 24BE _ 48: 81. BD, FFFFFF00, 000FFFFF
        jg      ?_0227                                  ; 24C9 _ 7F, 10
        mov     rax, qword [rbp-100H]                   ; 24CB _ 48: 8B. 85, FFFFFF00
        mov     qword [rbp-0E8H], rax                   ; 24D2 _ 48: 89. 85, FFFFFF18
        jmp     ?_0228                                  ; 24D9 _ EB, 0B

?_0227: mov     qword [rbp-0E8H], 1048576               ; 24DB _ 48: C7. 85, FFFFFF18, 00100000
?_0228: mov     rax, qword [rbp-0E8H]                   ; 24E6 _ 48: 8B. 85, FFFFFF18
        mov     rdi, rax                                ; 24ED _ 48: 89. C7
        call    nasm_malloc                             ; 24F0 _ E8, 00000000(PLT r)
        mov     qword [rbp-0F0H], rax                   ; 24F5 _ 48: 89. 85, FFFFFF10
?_0229: mov     byte [rbp-11EH], 0                      ; 24FC _ C6. 85, FFFFFEE2, 00
        jmp     ?_0239                                  ; 2503 _ E9, 00000226

?_0230: mov     dword [rbp-84H], 0                      ; 2508 _ C7. 85, FFFFFF7C, 00000000
        mov     dword [rbp-88H], 0                      ; 2512 _ C7. 85, FFFFFF78, 00000000
        mov     rax, qword [rel lfmt]                   ; 251C _ 48: 8B. 05, 00000000(rel)
        mov     rdx, qword [rax+20H]                    ; 2523 _ 48: 8B. 50, 20
        mov     rax, qword [rbp-100H]                   ; 2527 _ 48: 8B. 85, FFFFFF00
        mov     rsi, rax                                ; 252E _ 48: 89. C6
        mov     edi, 4                                  ; 2531 _ BF, 00000004
        call    rdx                                     ; 2536 _ FF. D2
        cmp     qword [rbp-0F8H], 0                     ; 2538 _ 48: 83. BD, FFFFFF08, 00
        jz      ?_0231                                  ; 2540 _ 74, 25
        mov     rdx, qword [rbp-100H]                   ; 2542 _ 48: 8B. 95, FFFFFF00
        mov     rcx, qword [rbp-0F8H]                   ; 2549 _ 48: 8B. 8D, FFFFFF08
        lea     rax, [rbp-0A0H]                         ; 2550 _ 48: 8D. 85, FFFFFF60
        mov     rsi, rcx                                ; 2557 _ 48: 89. CE
        mov     rdi, rax                                ; 255A _ 48: 89. C7
        call    out_rawdata                             ; 255D _ E8, FFFFEFE2
        jmp     ?_0238                                  ; 2562 _ E9, 00000175

?_0231: mov     rax, qword [rbp-100H]                   ; 2567 _ 48: 8B. 85, FFFFFF00
        cmp     qword [rbp-0E0H], rax                   ; 256E _ 48: 39. 85, FFFFFF20
        jnz     ?_0232                                  ; 2575 _ 75, 25
        mov     rdx, qword [rbp-100H]                   ; 2577 _ 48: 8B. 95, FFFFFF00
        mov     rcx, qword [rbp-0F0H]                   ; 257E _ 48: 8B. 8D, FFFFFF10
        lea     rax, [rbp-0A0H]                         ; 2585 _ 48: 8D. 85, FFFFFF60
        mov     rsi, rcx                                ; 258C _ 48: 89. CE
        mov     rdi, rax                                ; 258F _ 48: 89. C7
        call    out_rawdata                             ; 2592 _ E8, FFFFEFAD
        jmp     ?_0238                                  ; 2597 _ E9, 00000140

?_0232: mov     rax, qword [rbp-100H]                   ; 259C _ 48: 8B. 85, FFFFFF00
        mov     qword [rbp-0D8H], rax                   ; 25A3 _ 48: 89. 85, FFFFFF28
        mov     rcx, qword [rbp-108H]                   ; 25AA _ 48: 8B. 8D, FFFFFEF8
        mov     rax, qword [rbp-0A8H]                   ; 25B1 _ 48: 8B. 85, FFFFFF58
        mov     edx, 0                                  ; 25B8 _ BA, 00000000
        mov     rsi, rcx                                ; 25BD _ 48: 89. CE
        mov     rdi, rax                                ; 25C0 _ 48: 89. C7
        call    fseeko                                  ; 25C3 _ E8, 00000000(PLT r)
        test    eax, eax                                ; 25C8 _ 85. C0
        js      ?_0233                                  ; 25CA _ 78, 17
        mov     rax, qword [rbp-0A8H]                   ; 25CC _ 48: 8B. 85, FFFFFF58
        mov     rdi, rax                                ; 25D3 _ 48: 89. C7
        call    ferror                                  ; 25D6 _ E8, 00000000(PLT r)
        test    eax, eax                                ; 25DB _ 85. C0
        je      ?_0237                                  ; 25DD _ 0F 84, 000000EB
?_0233: mov     rax, qword [rbp-0B0H]                   ; 25E3 _ 48: 8B. 85, FFFFFF50
        lea     rdx, [rel ?_1050]                       ; 25EA _ 48: 8D. 15, 00000000(rel)
        mov     rsi, rax                                ; 25F1 _ 48: 89. C6
        mov     rdi, rdx                                ; 25F4 _ 48: 89. D7
        mov     eax, 0                                  ; 25F7 _ B8, 00000000
        call    nasm_nonfatal                           ; 25FC _ E8, 00000000(PLT r)
        mov     qword [rbp-110H], 0                     ; 2601 _ 48: C7. 85, FFFFFEF0, 00000000
        jmp     ?_0238                                  ; 260C _ E9, 000000CB

?_0234: mov     rdx, qword [rbp-0E8H]                   ; 2611 _ 48: 8B. 95, FFFFFF18
        mov     rax, qword [rbp-0D8H]                   ; 2618 _ 48: 8B. 85, FFFFFF28
        cmp     rdx, rax                                ; 261F _ 48: 39. C2
        cmovle  rax, rdx                                ; 2622 _ 48: 0F 4E. C2
        mov     rsi, rax                                ; 2626 _ 48: 89. C6
        mov     rdx, qword [rbp-0A8H]                   ; 2629 _ 48: 8B. 95, FFFFFF58
        mov     rax, qword [rbp-0F0H]                   ; 2630 _ 48: 8B. 85, FFFFFF10
        mov     rcx, rdx                                ; 2637 _ 48: 89. D1
        mov     rdx, rsi                                ; 263A _ 48: 89. F2
        mov     esi, 1                                  ; 263D _ BE, 00000001
        mov     rdi, rax                                ; 2642 _ 48: 89. C7
        call    fread                                   ; 2645 _ E8, 00000000(PLT r)
        mov     qword [rbp-0E0H], rax                   ; 264A _ 48: 89. 85, FFFFFF20
        cmp     qword [rbp-0E0H], 0                     ; 2651 _ 48: 83. BD, FFFFFF20, 00
        jz      ?_0235                                  ; 2659 _ 74, 13
        mov     rax, qword [rbp-0A8H]                   ; 265B _ 48: 8B. 85, FFFFFF58
        mov     rdi, rax                                ; 2662 _ 48: 89. C7
        call    feof                                    ; 2665 _ E8, 00000000(PLT r)
        test    eax, eax                                ; 266A _ 85. C0
        jz      ?_0236                                  ; 266C _ 74, 2B
?_0235: mov     rax, qword [rbp-0B0H]                   ; 266E _ 48: 8B. 85, FFFFFF50
        lea     rdx, [rel ?_1051]                       ; 2675 _ 48: 8D. 15, 00000000(rel)
        mov     rsi, rax                                ; 267C _ 48: 89. C6
        mov     rdi, rdx                                ; 267F _ 48: 89. D7
        mov     eax, 0                                  ; 2682 _ B8, 00000000
        call    nasm_nonfatal                           ; 2687 _ E8, 00000000(PLT r)
        mov     qword [rbp-110H], 0                     ; 268C _ 48: C7. 85, FFFFFEF0, 00000000
        jmp     ?_0238                                  ; 2697 _ EB, 43

?_0236: mov     rdx, qword [rbp-0E0H]                   ; 2699 _ 48: 8B. 95, FFFFFF20
        mov     rcx, qword [rbp-0F0H]                   ; 26A0 _ 48: 8B. 8D, FFFFFF10
        lea     rax, [rbp-0A0H]                         ; 26A7 _ 48: 8D. 85, FFFFFF60
        mov     rsi, rcx                                ; 26AE _ 48: 89. CE
        mov     rdi, rax                                ; 26B1 _ 48: 89. C7
        call    out_rawdata                             ; 26B4 _ E8, FFFFEE8B
        mov     rax, qword [rbp-0D8H]                   ; 26B9 _ 48: 8B. 85, FFFFFF28
        sub     rax, qword [rbp-0E0H]                   ; 26C0 _ 48: 2B. 85, FFFFFF20
        mov     qword [rbp-0D8H], rax                   ; 26C7 _ 48: 89. 85, FFFFFF28
?_0237: cmp     qword [rbp-0D8H], 0                     ; 26CE _ 48: 83. BD, FFFFFF28, 00
        jg      ?_0234                                  ; 26D6 _ 0F 8F, FFFFFF35
?_0238: mov     rax, qword [rel lfmt]                   ; 26DC _ 48: 8B. 05, 00000000(rel)
        mov     rax, qword [rax+28H]                    ; 26E3 _ 48: 8B. 40, 28
        mov     edi, 4                                  ; 26E7 _ BF, 00000004
        call    rax                                     ; 26EC _ FF. D0
        cmp     qword [rbp-110H], 0                     ; 26EE _ 48: 83. BD, FFFFFEF0, 00
        jz      ?_0239                                  ; 26F6 _ 74, 36
        movzx   eax, byte [rbp-11EH]                    ; 26F8 _ 0F B6. 85, FFFFFEE2
        xor     eax, 01H                                ; 26FF _ 83. F0, 01
        test    al, al                                  ; 2702 _ 84. C0
        jz      ?_0239                                  ; 2704 _ 74, 28
        mov     rax, qword [rel lfmt]                   ; 2706 _ 48: 8B. 05, 00000000(rel)
        mov     rdx, qword [rax+20H]                    ; 270D _ 48: 8B. 50, 20
        mov     rax, qword [rbp-128H]                   ; 2711 _ 48: 8B. 85, FFFFFED8
        mov     eax, dword [rax+74H]                    ; 2718 _ 8B. 40, 74
        cdqe                                            ; 271B _ 48: 98
        mov     rsi, rax                                ; 271D _ 48: 89. C6
        mov     edi, 5                                  ; 2720 _ BF, 00000005
        call    rdx                                     ; 2725 _ FF. D2
        mov     byte [rbp-11EH], 1                      ; 2727 _ C6. 85, FFFFFEE2, 01
?_0239: mov     rax, qword [rbp-110H]                   ; 272E _ 48: 8B. 85, FFFFFEF0
        lea     rdx, [rax-1H]                           ; 2735 _ 48: 8D. 50, FF
        mov     qword [rbp-110H], rdx                   ; 2739 _ 48: 89. 95, FFFFFEF0
        test    rax, rax                                ; 2740 _ 48: 85. C0
        jne     ?_0230                                  ; 2743 _ 0F 85, FFFFFDBF
        cmp     byte [rbp-11EH], 0                      ; 2749 _ 80. BD, FFFFFEE2, 00
        jz      ?_0241                                  ; 2750 _ 74, 17
        mov     rax, qword [rel lfmt]                   ; 2752 _ 48: 8B. 05, 00000000(rel)
        mov     rax, qword [rax+28H]                    ; 2759 _ 48: 8B. 40, 28
        mov     edi, 5                                  ; 275D _ BF, 00000005
        call    rax                                     ; 2762 _ FF. D0
        jmp     ?_0242                                  ; 2764 _ EB, 04

?_0240: nop                                             ; 2766 _ 90
        jmp     ?_0242                                  ; 2767 _ EB, 01

?_0241: nop                                             ; 2769 _ 90
?_0242: mov     rax, qword [rbp-0A8H]                   ; 276A _ 48: 8B. 85, FFFFFF58
        mov     rdi, rax                                ; 2771 _ 48: 89. C7
        call    ferror                                  ; 2774 _ E8, 00000000(PLT r)
        test    eax, eax                                ; 2779 _ 85. C0
        jz      ?_0243                                  ; 277B _ 74, 20
        mov     rax, qword [rbp-0B0H]                   ; 277D _ 48: 8B. 85, FFFFFF50
        lea     rdx, [rel ?_1052]                       ; 2784 _ 48: 8D. 15, 00000000(rel)
        mov     rsi, rax                                ; 278B _ 48: 89. C6
        mov     rdi, rdx                                ; 278E _ 48: 89. D7
        mov     eax, 0                                  ; 2791 _ B8, 00000000
        call    nasm_nonfatal                           ; 2796 _ E8, 00000000(PLT r)
        jmp     ?_0244                                  ; 279B _ EB, 01

?_0243: nop                                             ; 279D _ 90
?_0244: cmp     qword [rbp-0F0H], 0                     ; 279E _ 48: 83. BD, FFFFFF10, 00
        jz      ?_0245                                  ; 27A6 _ 74, 0F
        mov     rax, qword [rbp-0F0H]                   ; 27A8 _ 48: 8B. 85, FFFFFF10
        mov     rdi, rax                                ; 27AF _ 48: 89. C7
        call    nasm_free                               ; 27B2 _ E8, 00000000(PLT r)
?_0245: cmp     qword [rbp-0F8H], 0                     ; 27B7 _ 48: 83. BD, FFFFFF08, 00
        jz      ?_0246                                  ; 27BF _ 74, 19
        mov     rdx, qword [rbp-100H]                   ; 27C1 _ 48: 8B. 95, FFFFFF00
        mov     rax, qword [rbp-0F8H]                   ; 27C8 _ 48: 8B. 85, FFFFFF08
        mov     rsi, rdx                                ; 27CF _ 48: 89. D6
        mov     rdi, rax                                ; 27D2 _ 48: 89. C7
        call    nasm_unmap_file                         ; 27D5 _ E8, 00000000(PLT r)
?_0246: mov     rax, qword [rbp-0A8H]                   ; 27DA _ 48: 8B. 85, FFFFFF58
        mov     rdi, rax                                ; 27E1 _ 48: 89. C7
        call    fclose                                  ; 27E4 _ E8, 00000000(PLT r)
        jmp     ?_0248                                  ; 27E9 _ EB, 01

?_0247: nop                                             ; 27EB _ 90
?_0248: mov     rax, qword [rbp-128H]                   ; 27EC _ 48: 8B. 85, FFFFFED8
        mov     dword [rax+74H], 1                      ; 27F3 _ C7. 40, 74, 00000001
        jmp     ?_0261                                  ; 27FA _ E9, 000002E1

?_0249: mov     rax, qword [rbp-128H]                   ; 27FF _ 48: 8B. 85, FFFFFED8
        mov     rdi, rax                                ; 2806 _ 48: 89. C7
        call    insn_early_setup                        ; 2809 _ E8, 00007F2E
        mov     rax, qword [rbp-128H]                   ; 280E _ 48: 8B. 85, FFFFFED8
        mov     rdi, rax                                ; 2815 _ 48: 89. C7
        call    find_match                              ; 2818 _ E8, 000050AC
        mov     dword [rbp-118H], eax                   ; 281D _ 89. 85, FFFFFEE8
        cmp     dword [rbp-118H], 29                    ; 2823 _ 83. BD, FFFFFEE8, 1D
        jbe     ?_0260                                  ; 282A _ 0F 86, 0000028B
        mov     rax, qword [rbp-128H]                   ; 2830 _ 48: 8B. 85, FFFFFED8
        mov     rax, qword [rax+0B0H]                   ; 2837 _ 48: 8B. 80, 000000B0
        mov     qword [rbp-0B8H], rax                   ; 283E _ 48: 89. 85, FFFFFF48
        mov     edi, 88                                 ; 2845 _ BF, 00000058
        call    list_option                             ; 284A _ E8, FFFFDF49
        test    al, al                                  ; 284F _ 84. C0
        jz      ?_0250                                  ; 2851 _ 74, 0F
        mov     rax, qword [rbp-128H]                   ; 2853 _ 48: 8B. 85, FFFFFED8
        mov     rdi, rax                                ; 285A _ 48: 89. C7
        call    list_add_template_info                  ; 285D _ E8, FFFFF904
?_0250: mov     rax, qword [rbp-0B8H]                   ; 2862 _ 48: 8B. 85, FFFFFF48
        mov     esi, 179                                ; 2869 _ BE, 000000B3
        mov     rdi, rax                                ; 286E _ 48: 89. C7
        call    itemp_has                               ; 2871 _ E8, FFFFDB3A
        movzx   eax, al                                 ; 2876 _ 0F B6. C0
        test    rax, rax                                ; 2879 _ 48: 85. C0
        je      ?_0257                                  ; 287C _ 0F 84, 00000144
        mov     rax, qword [rbp-0B8H]                   ; 2882 _ 48: 8B. 85, FFFFFF48
        mov     esi, 180                                ; 2889 _ BE, 000000B4
        mov     rdi, rax                                ; 288E _ 48: 89. C7
        call    itemp_has                               ; 2891 _ E8, FFFFDB1A
        mov     byte [rbp-11DH], al                     ; 2896 _ 88. 85, FFFFFEE3
        cmp     byte [rbp-11DH], 0                      ; 289C _ 80. BD, FFFFFEE3, 00
        jz      ?_0251                                  ; 28A3 _ 74, 10
        lea     rax, [rel ?_1053]                       ; 28A5 _ 48: 8D. 05, 00000000(rel)
        mov     qword [rbp-0D0H], rax                   ; 28AC _ 48: 89. 85, FFFFFF30
        jmp     ?_0252                                  ; 28B3 _ EB, 0E

?_0251: lea     rax, [rel ?_1054]                       ; 28B5 _ 48: 8D. 05, 00000000(rel)
        mov     qword [rbp-0D0H], rax                   ; 28BC _ 48: 89. 85, FFFFFF30
?_0252: movzx   eax, byte [rbp-11DH]                    ; 28C3 _ 0F B6. 85, FFFFFEE3
        xor     eax, 01H                                ; 28CA _ 83. F0, 01
        test    al, al                                  ; 28CD _ 84. C0
        jz      ?_0253                                  ; 28CF _ 74, 4A
        mov     rax, qword [rbp-0B8H]                   ; 28D1 _ 48: 8B. 85, FFFFFF48
        mov     eax, dword [rax+48H]                    ; 28D8 _ 8B. 40, 48
        mov     eax, eax                                ; 28DB _ 89. C0
        imul    rax, rax, 28                            ; 28DD _ 48: 6B. C0, 1C
        lea     rdx, [rel insns_flags]                  ; 28E1 _ 48: 8D. 15, 00000000(rel)
        add     rax, rdx                                ; 28E8 _ 48: 01. D0
        lea     rdx, [rel cpu]                          ; 28EB _ 48: 8D. 15, 00000000(rel)
        mov     rsi, rdx                                ; 28F2 _ 48: 89. D6
        mov     rdi, rax                                ; 28F5 _ 48: 89. C7
        call    iflag_cmp_cpu_level                     ; 28F8 _ E8, FFFFDA4D
        test    eax, eax                                ; 28FD _ 85. C0
        jnz     ?_0253                                  ; 28FF _ 75, 1A
        mov     dword [rbp-11CH], 1179648               ; 2901 _ C7. 85, FFFFFEE4, 00120000
        lea     rax, [rel ?_1055]                       ; 290B _ 48: 8D. 05, 00000000(rel)
        mov     qword [rbp-0C8H], rax                   ; 2912 _ 48: 89. 85, FFFFFF38
        jmp     ?_0256                                  ; 2919 _ EB, 63

?_0253: mov     rax, qword [rbp-0B8H]                   ; 291B _ 48: 8B. 85, FFFFFF48
        mov     esi, 181                                ; 2922 _ BE, 000000B5
        mov     rdi, rax                                ; 2927 _ 48: 89. C7
        call    itemp_has                               ; 292A _ E8, FFFFDA81
        test    al, al                                  ; 292F _ 84. C0
        jz      ?_0254                                  ; 2931 _ 74, 1A
        mov     dword [rbp-11CH], 1048576               ; 2933 _ C7. 85, FFFFFEE4, 00100000
        lea     rax, [rel ?_1056]                       ; 293D _ 48: 8D. 05, 00000000(rel)
        mov     qword [rbp-0C8H], rax                   ; 2944 _ 48: 89. 85, FFFFFF38
        jmp     ?_0256                                  ; 294B _ EB, 31

?_0254: mov     dword [rbp-11CH], 1114112               ; 294D _ C7. 85, FFFFFEE4, 00110000
        cmp     byte [rbp-11DH], 0                      ; 2957 _ 80. BD, FFFFFEE3, 00
        jz      ?_0255                                  ; 295E _ 74, 10
        lea     rax, [rel ?_1057]                       ; 2960 _ 48: 8D. 05, 00000000(rel)
        mov     qword [rbp-0C8H], rax                   ; 2967 _ 48: 89. 85, FFFFFF38
        jmp     ?_0256                                  ; 296E _ EB, 0E

?_0255: lea     rax, [rel ?_1058]                       ; 2970 _ 48: 8D. 05, 00000000(rel)
        mov     qword [rbp-0C8H], rax                   ; 2977 _ 48: 89. 85, FFFFFF38
?_0256: mov     eax, dword [rbp-11CH]                   ; 297E _ 8B. 85, FFFFFEE4
        mov     dword [rbp-114H], eax                   ; 2984 _ 89. 85, FFFFFEEC
        mov     eax, dword [rbp-114H]                   ; 298A _ 8B. 85, FFFFFEEC
        mov     edi, eax                                ; 2990 _ 89. C7
        call    warn_active                             ; 2992 _ E8, FFFFD8BC
        movzx   eax, al                                 ; 2997 _ 0F B6. C0
        test    rax, rax                                ; 299A _ 48: 85. C0
        jz      ?_0257                                  ; 299D _ 74, 27
        mov     rcx, qword [rbp-0C8H]                   ; 299F _ 48: 8B. 8D, FFFFFF38
        mov     rdx, qword [rbp-0D0H]                   ; 29A6 _ 48: 8B. 95, FFFFFF30
        lea     rsi, [rel ?_1059]                       ; 29AD _ 48: 8D. 35, 00000000(rel)
        mov     eax, dword [rbp-114H]                   ; 29B4 _ 8B. 85, FFFFFEEC
        mov     edi, eax                                ; 29BA _ 89. C7
        mov     eax, 0                                  ; 29BC _ B8, 00000000
        call    nasm_warn_                              ; 29C1 _ E8, 00000000(PLT r)
?_0257: mov     rax, qword [rbp-128H]                   ; 29C6 _ 48: 8B. 85, FFFFFED8
        mov     rdi, rax                                ; 29CD _ 48: 89. C7
        call    calcsize                                ; 29D0 _ E8, 00000BE6
        mov     dword [rbp-88H], eax                    ; 29D5 _ 89. 85, FFFFFF78
        mov     eax, dword [rbp-88H]                    ; 29DB _ 8B. 85, FFFFFF78
        test    eax, eax                                ; 29E1 _ 85. C0
        jg      ?_0258                                  ; 29E3 _ 7F, 0A
        mov     eax, 0                                  ; 29E5 _ B8, 00000000
        jmp     ?_0262                                  ; 29EA _ E9, 000000FF

?_0258: mov     eax, dword [rbp-88H]                    ; 29EF _ 8B. 85, FFFFFF78
        movsxd  rdx, eax                                ; 29F5 _ 48: 63. D0
        mov     rax, qword [rbp-128H]                   ; 29F8 _ 48: 8B. 85, FFFFFED8
        mov     rsi, rdx                                ; 29FF _ 48: 89. D6
        mov     rdi, rax                                ; 2A02 _ 48: 89. C7
        call    merge_resb                              ; 2A05 _ E8, FFFFF3CF
        mov     dword [rbp-88H], eax                    ; 2A0A _ 89. 85, FFFFFF78
        mov     dword [rbp-84H], 0                      ; 2A10 _ C7. 85, FFFFFF7C, 00000000
        mov     rdx, qword [rbp-128H]                   ; 2A1A _ 48: 8B. 95, FFFFFED8
        lea     rax, [rbp-0A0H]                         ; 2A21 _ 48: 8D. 85, FFFFFF60
        mov     rsi, rdx                                ; 2A28 _ 48: 89. D6
        mov     rdi, rax                                ; 2A2B _ 48: 89. C7
        call    gencode                                 ; 2A2E _ E8, 00003505
        mov     edx, dword [rbp-84H]                    ; 2A33 _ 8B. 95, FFFFFF7C
        mov     eax, dword [rbp-88H]                    ; 2A39 _ 8B. 85, FFFFFF78
        cmp     edx, eax                                ; 2A3F _ 39. C2
        setne   al                                      ; 2A41 _ 0F 95. C0
        movzx   eax, al                                 ; 2A44 _ 0F B6. C0
        test    rax, rax                                ; 2A47 _ 48: 85. C0
        jz      ?_0259                                  ; 2A4A _ 74, 26
        mov     eax, dword [rbp-88H]                    ; 2A4C _ 8B. 85, FFFFFF78
        mov     edx, eax                                ; 2A52 _ 89. C2
        mov     eax, dword [rbp-84H]                    ; 2A54 _ 8B. 85, FFFFFF7C
        mov     ecx, eax                                ; 2A5A _ 89. C1
        lea     rax, [rel ?_1060]                       ; 2A5C _ 48: 8D. 05, 00000000(rel)
        mov     esi, ecx                                ; 2A63 _ 89. CE
        mov     rdi, rax                                ; 2A65 _ 48: 89. C7
        mov     eax, 0                                  ; 2A68 _ B8, 00000000
        call    nasm_nonfatal                           ; 2A6D _ E8, 00000000(PLT r)
?_0259: mov     rax, qword [rbp-0A0H]                   ; 2A72 _ 48: 8B. 85, FFFFFF60
        sub     rax, qword [rbp-0C0H]                   ; 2A79 _ 48: 2B. 85, FFFFFF40
        mov     rdx, rax                                ; 2A80 _ 48: 89. C2
        mov     eax, dword [rbp-88H]                    ; 2A83 _ 8B. 85, FFFFFF78
        cdqe                                            ; 2A89 _ 48: 98
        cmp     rdx, rax                                ; 2A8B _ 48: 39. C2
        setne   al                                      ; 2A8E _ 0F 95. C0
        movzx   eax, al                                 ; 2A91 _ 0F B6. C0
        test    rax, rax                                ; 2A94 _ 48: 85. C0
        jz      ?_0261                                  ; 2A97 _ 74, 47
        lea     rdx, [rel ?_1013]                       ; 2A99 _ 48: 8D. 15, 00000000(rel)
        lea     rsi, [rel __func__.8]                   ; 2AA0 _ 48: 8D. 35, 00000000(rel)
        lea     rax, [rel ?_1061]                       ; 2AA7 _ 48: 8D. 05, 00000000(rel)
        mov     ecx, 1088                               ; 2AAE _ B9, 00000440
        mov     rdi, rax                                ; 2AB3 _ 48: 89. C7
        call    nasm_assert_failed                      ; 2AB6 _ E8, 00000000(PLT r)
?_0260: mov     rdx, qword [rbp-128H]                   ; 2ABB _ 48: 8B. 95, FFFFFED8
        mov     eax, dword [rbp-118H]                   ; 2AC2 _ 8B. 85, FFFFFEE8
        mov     rsi, rdx                                ; 2AC8 _ 48: 89. D6
        mov     edi, eax                                ; 2ACB _ 89. C7
        call    no_match_error                          ; 2ACD _ E8, FFFFEDDD
        mov     rax, qword [rbp-128H]                   ; 2AD2 _ 48: 8B. 85, FFFFFED8
        mov     dword [rax+74H], 1                      ; 2AD9 _ C7. 40, 74, 00000001
?_0261: mov     rax, qword [rbp-0A0H]                   ; 2AE0 _ 48: 8B. 85, FFFFFF60
        sub     rax, qword [rbp-0C0H]                   ; 2AE7 _ 48: 2B. 85, FFFFFF40
?_0262: mov     rdx, qword [rbp-8H]                     ; 2AEE _ 48: 8B. 55, F8
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        sub     rdx, qword [fs:abs 28H]                 ; 2AF2 _ 64 48: 2B. 14 25, 00000028
        jz      ?_0263                                  ; 2AFB _ 74, 05
        call    __stack_chk_fail                        ; 2AFD _ E8, 00000000(PLT r)
?_0263: leave                                           ; 2B02 _ C9
        ret                                             ; 2B03 _ C3

eops_typeinfo:; Local function
        push    rbp                                     ; 2B04 _ 55
        mov     rbp, rsp                                ; 2B05 _ 48: 89. E5
        sub     rsp, 32                                 ; 2B08 _ 48: 83. EC, 20
        mov     qword [rbp-18H], rdi                    ; 2B0C _ 48: 89. 7D, E8
        mov     dword [rbp-4H], 0                       ; 2B10 _ C7. 45, FC, 00000000
        jmp     ?_0287                                  ; 2B17 _ E9, 0000012E

?_0264: mov     rax, qword [rbp-18H]                    ; 2B1C _ 48: 8B. 45, E8
        mov     eax, dword [rax+28H]                    ; 2B20 _ 8B. 40, 28
        cmp     eax, 3                                  ; 2B23 _ 83. F8, 03
        jz      ?_0265                                  ; 2B26 _ 74, 32
        cmp     eax, 3                                  ; 2B28 _ 83. F8, 03
        ja      ?_0275                                  ; 2B2B _ 0F 87, 0000009B
        test    eax, eax                                ; 2B31 _ 85. C0
        je      ?_0285                                  ; 2B33 _ 0F 84, 00000105
        cmp     eax, 1                                  ; 2B39 _ 83. F8, 01
        jne     ?_0275                                  ; 2B3C _ 0F 85, 0000008A
        mov     rax, qword [rbp-18H]                    ; 2B42 _ 48: 8B. 45, E8
        mov     rax, qword [rax+8H]                     ; 2B46 _ 48: 8B. 40, 08
        mov     rdi, rax                                ; 2B4A _ 48: 89. C7
        call    eops_typeinfo                           ; 2B4D _ E8, FFFFFFB2
        or      dword [rbp-4H], eax                     ; 2B52 _ 09. 45, FC
        jmp     ?_0286                                  ; 2B55 _ E9, 000000E5

?_0265: mov     rax, qword [rbp-18H]                    ; 2B5A _ 48: 8B. 45, E8
        mov     eax, dword [rax+2CH]                    ; 2B5E _ 8B. 40, 2C
        cmp     eax, 32                                 ; 2B61 _ 83. F8, 20
        jz      ?_0272                                  ; 2B64 _ 74, 5D
        cmp     eax, 32                                 ; 2B66 _ 83. F8, 20
        jg      ?_0273                                  ; 2B69 _ 7F, 5E
        cmp     eax, 16                                 ; 2B6B _ 83. F8, 10
        jz      ?_0271                                  ; 2B6E _ 74, 4D
        cmp     eax, 16                                 ; 2B70 _ 83. F8, 10
        jg      ?_0273                                  ; 2B73 _ 7F, 54
        cmp     eax, 10                                 ; 2B75 _ 83. F8, 0A
        jz      ?_0270                                  ; 2B78 _ 74, 3D
        cmp     eax, 10                                 ; 2B7A _ 83. F8, 0A
        jg      ?_0273                                  ; 2B7D _ 7F, 4A
        cmp     eax, 8                                  ; 2B7F _ 83. F8, 08
        jz      ?_0269                                  ; 2B82 _ 74, 2D
        cmp     eax, 8                                  ; 2B84 _ 83. F8, 08
        jg      ?_0273                                  ; 2B87 _ 7F, 40
        cmp     eax, 4                                  ; 2B89 _ 83. F8, 04
        jz      ?_0268                                  ; 2B8C _ 74, 1D
        cmp     eax, 4                                  ; 2B8E _ 83. F8, 04
        jg      ?_0273                                  ; 2B91 _ 7F, 36
        cmp     eax, 1                                  ; 2B93 _ 83. F8, 01
        jz      ?_0266                                  ; 2B96 _ 74, 07
        cmp     eax, 2                                  ; 2B98 _ 83. F8, 02
        jz      ?_0267                                  ; 2B9B _ 74, 08
        jmp     ?_0273                                  ; 2B9D _ EB, 2A

?_0266: or      dword [rbp-4H], 10H                     ; 2B9F _ 83. 4D, FC, 10
        jmp     ?_0274                                  ; 2BA3 _ EB, 25

?_0267: or      dword [rbp-4H], 18H                     ; 2BA5 _ 83. 4D, FC, 18
        jmp     ?_0274                                  ; 2BA9 _ EB, 1F

?_0268: or      dword [rbp-4H], 28H                     ; 2BAB _ 83. 4D, FC, 28
        jmp     ?_0274                                  ; 2BAF _ EB, 19

?_0269: or      dword [rbp-4H], 30H                     ; 2BB1 _ 83. 4D, FC, 30
        jmp     ?_0274                                  ; 2BB5 _ EB, 13

?_0270: or      dword [rbp-4H], 38H                     ; 2BB7 _ 83. 4D, FC, 38
        jmp     ?_0274                                  ; 2BBB _ EB, 0D

?_0271: or      dword [rbp-4H], 48H                     ; 2BBD _ 83. 4D, FC, 48
        jmp     ?_0274                                  ; 2BC1 _ EB, 07

?_0272: or      dword [rbp-4H], 50H                     ; 2BC3 _ 83. 4D, FC, 50
        jmp     ?_0274                                  ; 2BC7 _ EB, 01

?_0273: nop                                             ; 2BC9 _ 90
?_0274: jmp     ?_0286                                  ; 2BCA _ EB, 73

?_0275: mov     rax, qword [rbp-18H]                    ; 2BCC _ 48: 8B. 45, E8
        mov     eax, dword [rax+2CH]                    ; 2BD0 _ 8B. 40, 2C
        cmp     eax, 32                                 ; 2BD3 _ 83. F8, 20
        jz      ?_0282                                  ; 2BD6 _ 74, 5D
        cmp     eax, 32                                 ; 2BD8 _ 83. F8, 20
        jg      ?_0283                                  ; 2BDB _ 7F, 5E
        cmp     eax, 16                                 ; 2BDD _ 83. F8, 10
        jz      ?_0281                                  ; 2BE0 _ 74, 4D
        cmp     eax, 16                                 ; 2BE2 _ 83. F8, 10
        jg      ?_0283                                  ; 2BE5 _ 7F, 54
        cmp     eax, 10                                 ; 2BE7 _ 83. F8, 0A
        jz      ?_0280                                  ; 2BEA _ 74, 3D
        cmp     eax, 10                                 ; 2BEC _ 83. F8, 0A
        jg      ?_0283                                  ; 2BEF _ 7F, 4A
        cmp     eax, 8                                  ; 2BF1 _ 83. F8, 08
        jz      ?_0279                                  ; 2BF4 _ 74, 2D
        cmp     eax, 8                                  ; 2BF6 _ 83. F8, 08
        jg      ?_0283                                  ; 2BF9 _ 7F, 40
        cmp     eax, 4                                  ; 2BFB _ 83. F8, 04
        jz      ?_0278                                  ; 2BFE _ 74, 1D
        cmp     eax, 4                                  ; 2C00 _ 83. F8, 04
        jg      ?_0283                                  ; 2C03 _ 7F, 36
        cmp     eax, 1                                  ; 2C05 _ 83. F8, 01
        jz      ?_0276                                  ; 2C08 _ 74, 07
        cmp     eax, 2                                  ; 2C0A _ 83. F8, 02
        jz      ?_0277                                  ; 2C0D _ 74, 08
        jmp     ?_0283                                  ; 2C0F _ EB, 2A

?_0276: or      dword [rbp-4H], 10H                     ; 2C11 _ 83. 4D, FC, 10
        jmp     ?_0284                                  ; 2C15 _ EB, 25

?_0277: or      dword [rbp-4H], 18H                     ; 2C17 _ 83. 4D, FC, 18
        jmp     ?_0284                                  ; 2C1B _ EB, 1F

?_0278: or      dword [rbp-4H], 20H                     ; 2C1D _ 83. 4D, FC, 20
        jmp     ?_0284                                  ; 2C21 _ EB, 19

?_0279: or      dword [rbp-4H], 30H                     ; 2C23 _ 83. 4D, FC, 30
        jmp     ?_0284                                  ; 2C27 _ EB, 13

?_0280: or      dword [rbp-4H], 38H                     ; 2C29 _ 83. 4D, FC, 38
        jmp     ?_0284                                  ; 2C2D _ EB, 0D

?_0281: or      dword [rbp-4H], 48H                     ; 2C2F _ 83. 4D, FC, 48
        jmp     ?_0284                                  ; 2C33 _ EB, 07

?_0282: or      dword [rbp-4H], 50H                     ; 2C35 _ 83. 4D, FC, 50
        jmp     ?_0284                                  ; 2C39 _ EB, 01

?_0283: nop                                             ; 2C3B _ 90
?_0284: jmp     ?_0286                                  ; 2C3C _ EB, 01

?_0285: nop                                             ; 2C3E _ 90
?_0286: mov     rax, qword [rbp-18H]                    ; 2C3F _ 48: 8B. 45, E8
        mov     rax, qword [rax]                        ; 2C43 _ 48: 8B. 00
        mov     qword [rbp-18H], rax                    ; 2C46 _ 48: 89. 45, E8
?_0287: cmp     qword [rbp-18H], 0                      ; 2C4A _ 48: 83. 7D, E8, 00
        jne     ?_0264                                  ; 2C4F _ 0F 85, FFFFFEC7
        mov     eax, dword [rbp-4H]                     ; 2C55 _ 8B. 45, FC
        leave                                           ; 2C58 _ C9
        ret                                             ; 2C59 _ C3

debug_set_db_type:; Local function
        push    rbp                                     ; 2C5A _ 55
        mov     rbp, rsp                                ; 2C5B _ 48: 89. E5
        sub     rsp, 32                                 ; 2C5E _ 48: 83. EC, 20
        mov     qword [rbp-18H], rdi                    ; 2C62 _ 48: 89. 7D, E8
        mov     rax, qword [rbp-18H]                    ; 2C66 _ 48: 8B. 45, E8
        movzx   eax, byte [rax+7DH]                     ; 2C6A _ 0F B6. 40, 7D
        movzx   eax, al                                 ; 2C6E _ 0F B6. C0
        shl     eax, 8                                  ; 2C71 _ C1. E0, 08
        mov     dword [rbp-4H], eax                     ; 2C74 _ 89. 45, FC
        mov     rax, qword [rbp-18H]                    ; 2C77 _ 48: 8B. 45, E8
        mov     rax, qword [rax+68H]                    ; 2C7B _ 48: 8B. 40, 68
        mov     rdi, rax                                ; 2C7F _ 48: 89. C7
        call    eops_typeinfo                           ; 2C82 _ E8, FFFFFE7D
        or      dword [rbp-4H], eax                     ; 2C87 _ 09. 45, FC
        mov     rax, qword [rel dfmt]                   ; 2C8A _ 48: 8B. 05, 00000000(rel)
        mov     rdx, qword [rax+48H]                    ; 2C91 _ 48: 8B. 50, 48
        mov     eax, dword [rbp-4H]                     ; 2C95 _ 8B. 45, FC
        mov     edi, eax                                ; 2C98 _ 89. C7
        call    rdx                                     ; 2C9A _ FF. D2
        nop                                             ; 2C9C _ 90
        leave                                           ; 2C9D _ C9
        ret                                             ; 2C9E _ C3

debug_set_type:; Local function
        push    rbp                                     ; 2C9F _ 55
        mov     rbp, rsp                                ; 2CA0 _ 48: 89. E5
        sub     rsp, 32                                 ; 2CA3 _ 48: 83. EC, 20
        mov     qword [rbp-18H], rdi                    ; 2CA7 _ 48: 89. 7D, E8
        mov     rax, qword [rbp-18H]                    ; 2CAB _ 48: 8B. 45, E8
        mov     eax, dword [rax]                        ; 2CAF _ 8B. 00
        mov     edi, eax                                ; 2CB1 _ 89. C7
        call    opcode_is_resb                          ; 2CB3 _ E8, FFFFD751
        test    al, al                                  ; 2CB8 _ 84. C0
        je      ?_0297                                  ; 2CBA _ 0F 84, 000000AD
        mov     rax, qword [rbp-18H]                    ; 2CC0 _ 48: 8B. 45, E8
        mov     rax, qword [rax+0E8H]                   ; 2CC4 _ 48: 8B. 80, 000000E8
        shl     eax, 8                                  ; 2CCB _ C1. E0, 08
        mov     dword [rbp-4H], eax                     ; 2CCE _ 89. 45, FC
        mov     rax, qword [rbp-18H]                    ; 2CD1 _ 48: 8B. 45, E8
        mov     eax, dword [rax]                        ; 2CD5 _ 8B. 00
        cmp     eax, 15                                 ; 2CD7 _ 83. F8, 0F
        jz      ?_0295                                  ; 2CDA _ 74, 6D
        cmp     eax, 15                                 ; 2CDC _ 83. F8, 0F
        jg      ?_0296                                  ; 2CDF _ 7F, 6E
        cmp     eax, 14                                 ; 2CE1 _ 83. F8, 0E
        jz      ?_0294                                  ; 2CE4 _ 74, 5D
        cmp     eax, 14                                 ; 2CE6 _ 83. F8, 0E
        jg      ?_0296                                  ; 2CE9 _ 7F, 64
        cmp     eax, 13                                 ; 2CEB _ 83. F8, 0D
        jz      ?_0293                                  ; 2CEE _ 74, 4D
        cmp     eax, 13                                 ; 2CF0 _ 83. F8, 0D
        jg      ?_0296                                  ; 2CF3 _ 7F, 5A
        cmp     eax, 12                                 ; 2CF5 _ 83. F8, 0C
        jz      ?_0292                                  ; 2CF8 _ 74, 3D
        cmp     eax, 12                                 ; 2CFA _ 83. F8, 0C
        jg      ?_0296                                  ; 2CFD _ 7F, 50
        cmp     eax, 11                                 ; 2CFF _ 83. F8, 0B
        jz      ?_0291                                  ; 2D02 _ 74, 2D
        cmp     eax, 11                                 ; 2D04 _ 83. F8, 0B
        jg      ?_0296                                  ; 2D07 _ 7F, 46
        cmp     eax, 10                                 ; 2D09 _ 83. F8, 0A
        jz      ?_0290                                  ; 2D0C _ 74, 1D
        cmp     eax, 10                                 ; 2D0E _ 83. F8, 0A
        jg      ?_0296                                  ; 2D11 _ 7F, 3C
        cmp     eax, 8                                  ; 2D13 _ 83. F8, 08
        jz      ?_0288                                  ; 2D16 _ 74, 07
        cmp     eax, 9                                  ; 2D18 _ 83. F8, 09
        jz      ?_0289                                  ; 2D1B _ 74, 08
        jmp     ?_0296                                  ; 2D1D _ EB, 30

?_0288: or      dword [rbp-4H], 10H                     ; 2D1F _ 83. 4D, FC, 10
        jmp     ?_0298                                  ; 2D23 _ EB, 4F

?_0289: or      dword [rbp-4H], 18H                     ; 2D25 _ 83. 4D, FC, 18
        jmp     ?_0298                                  ; 2D29 _ EB, 49

?_0290: or      dword [rbp-4H], 20H                     ; 2D2B _ 83. 4D, FC, 20
        jmp     ?_0298                                  ; 2D2F _ EB, 43

?_0291: or      dword [rbp-4H], 30H                     ; 2D31 _ 83. 4D, FC, 30
        jmp     ?_0298                                  ; 2D35 _ EB, 3D

?_0292: or      dword [rbp-4H], 38H                     ; 2D37 _ 83. 4D, FC, 38
        jmp     ?_0298                                  ; 2D3B _ EB, 37

?_0293: or      dword [rbp-4H], 40H                     ; 2D3D _ 83. 4D, FC, 40
        jmp     ?_0298                                  ; 2D41 _ EB, 31

?_0294: or      dword [rbp-4H], 48H                     ; 2D43 _ 83. 4D, FC, 48
        jmp     ?_0298                                  ; 2D47 _ EB, 2B

?_0295: or      dword [rbp-4H], 50H                     ; 2D49 _ 83. 4D, FC, 50
        jmp     ?_0298                                  ; 2D4D _ EB, 25

?_0296: lea     rcx, [rel ?_1013]                       ; 2D4F _ 48: 8D. 0D, 00000000(rel)
        lea     rax, [rel __func__.7]                   ; 2D56 _ 48: 8D. 05, 00000000(rel)
        mov     edx, 1184                               ; 2D5D _ BA, 000004A0
        mov     rsi, rcx                                ; 2D62 _ 48: 89. CE
        mov     rdi, rax                                ; 2D65 _ 48: 89. C7
        call    nasm_panic_from_macro                   ; 2D68 _ E8, 00000000(PLT r)
?_0297: mov     dword [rbp-4H], 8                       ; 2D6D _ C7. 45, FC, 00000008
?_0298: mov     rax, qword [rel dfmt]                   ; 2D74 _ 48: 8B. 05, 00000000(rel)
        mov     rdx, qword [rax+48H]                    ; 2D7B _ 48: 8B. 50, 48
        mov     eax, dword [rbp-4H]                     ; 2D7F _ 8B. 45, FC
        mov     edi, eax                                ; 2D82 _ 89. C7
        call    rdx                                     ; 2D84 _ FF. D2
        nop                                             ; 2D86 _ 90
        leave                                           ; 2D87 _ C9
        ret                                             ; 2D88 _ C3

define_equ:; Local function
        push    rbp                                     ; 2D89 _ 55
        mov     rbp, rsp                                ; 2D8A _ 48: 89. E5
        sub     rsp, 16                                 ; 2D8D _ 48: 83. EC, 10
        mov     qword [rbp-8H], rdi                     ; 2D91 _ 48: 89. 7D, F8
        mov     rax, qword [rbp-8H]                     ; 2D95 _ 48: 8B. 45, F8
        mov     rax, qword [rax+60H]                    ; 2D99 _ 48: 8B. 40, 60
        test    rax, rax                                ; 2D9D _ 48: 85. C0
        jnz     ?_0299                                  ; 2DA0 _ 75, 19
        lea     rax, [rel ?_1062]                       ; 2DA2 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 2DA9 _ 48: 89. C7
        mov     eax, 0                                  ; 2DAC _ B8, 00000000
        call    nasm_nonfatal                           ; 2DB1 _ E8, 00000000(PLT r)
        jmp     ?_0302                                  ; 2DB6 _ E9, 00000134

?_0299: mov     rax, qword [rbp-8H]                     ; 2DBB _ 48: 8B. 45, F8
        movzx   eax, byte [rax+7DH]                     ; 2DBF _ 0F B6. 40, 7D
        cmp     al, 1                                   ; 2DC3 _ 3C, 01
        jnz     ?_0300                                  ; 2DC5 _ 75, 51
        mov     rax, qword [rbp-8H]                     ; 2DC7 _ 48: 8B. 45, F8
        mov     rax, qword [rax+0C0H]                   ; 2DCB _ 48: 8B. 80, 000000C0
        and     eax, 02H                                ; 2DD2 _ 83. E0, 02
        test    rax, rax                                ; 2DD5 _ 48: 85. C0
        jz      ?_0300                                  ; 2DD8 _ 74, 3E
        mov     rax, qword [rbp-8H]                     ; 2DDA _ 48: 8B. 45, F8
        mov     eax, dword [rax+0F0H]                   ; 2DDE _ 8B. 80, 000000F0
        cmp     eax, -1                                 ; 2DE4 _ 83. F8, FF
        jnz     ?_0300                                  ; 2DE7 _ 75, 2F
        mov     rax, qword [rbp-8H]                     ; 2DE9 _ 48: 8B. 45, F8
        mov     rdx, qword [rax+0E8H]                   ; 2DED _ 48: 8B. 90, 000000E8
        mov     rax, qword [rbp-8H]                     ; 2DF4 _ 48: 8B. 45, F8
        mov     esi, dword [rax+0E4H]                   ; 2DF8 _ 8B. B0, 000000E4
        mov     rax, qword [rbp-8H]                     ; 2DFE _ 48: 8B. 45, F8
        mov     rax, qword [rax+60H]                    ; 2E02 _ 48: 8B. 40, 60
        mov     ecx, 0                                  ; 2E06 _ B9, 00000000
        mov     rdi, rax                                ; 2E0B _ 48: 89. C7
        call    define_label                            ; 2E0E _ E8, 00000000(PLT r)
        jmp     ?_0302                                  ; 2E13 _ E9, 000000D7

?_0300: mov     rax, qword [rbp-8H]                     ; 2E18 _ 48: 8B. 45, F8
        movzx   eax, byte [rax+7DH]                     ; 2E1C _ 0F B6. 40, 7D
        cmp     al, 2                                   ; 2E20 _ 3C, 02
        jne     ?_0301                                  ; 2E22 _ 0F 85, 000000B1
        mov     rax, qword [rbp-8H]                     ; 2E28 _ 48: 8B. 45, F8
        mov     rax, qword [rax+0C0H]                   ; 2E2C _ 48: 8B. 80, 000000C0
        and     eax, 02H                                ; 2E33 _ 83. E0, 02
        test    rax, rax                                ; 2E36 _ 48: 85. C0
        je      ?_0301                                  ; 2E39 _ 0F 84, 0000009A
        mov     rax, qword [rbp-8H]                     ; 2E3F _ 48: 8B. 45, F8
        mov     rax, qword [rax+0C0H]                   ; 2E43 _ 48: 8B. 80, 000000C0
        and     eax, 20H                                ; 2E4A _ 83. E0, 20
        test    rax, rax                                ; 2E4D _ 48: 85. C0
        je      ?_0301                                  ; 2E50 _ 0F 84, 00000083
        mov     rax, qword [rbp-8H]                     ; 2E56 _ 48: 8B. 45, F8
        mov     eax, dword [rax+0E4H]                   ; 2E5A _ 8B. 80, 000000E4
        cmp     eax, -1                                 ; 2E60 _ 83. F8, FF
        jnz     ?_0301                                  ; 2E63 _ 75, 74
        mov     rax, qword [rbp-8H]                     ; 2E65 _ 48: 8B. 45, F8
        mov     eax, dword [rax+0F0H]                   ; 2E69 _ 8B. 80, 000000F0
        cmp     eax, -1                                 ; 2E6F _ 83. F8, FF
        jnz     ?_0301                                  ; 2E72 _ 75, 65
        mov     rax, qword [rbp-8H]                     ; 2E74 _ 48: 8B. 45, F8
        mov     rax, qword [rax+108H]                   ; 2E78 _ 48: 8B. 80, 00000108
        and     eax, 02H                                ; 2E7F _ 83. E0, 02
        test    rax, rax                                ; 2E82 _ 48: 85. C0
        jz      ?_0301                                  ; 2E85 _ 74, 52
        mov     rax, qword [rbp-8H]                     ; 2E87 _ 48: 8B. 45, F8
        mov     eax, dword [rax+12CH]                   ; 2E8B _ 8B. 80, 0000012C
        cmp     eax, -1                                 ; 2E91 _ 83. F8, FF
        jnz     ?_0301                                  ; 2E94 _ 75, 43
        mov     rax, qword [rbp-8H]                     ; 2E96 _ 48: 8B. 45, F8
        mov     eax, dword [rax+138H]                   ; 2E9A _ 8B. 80, 00000138
        cmp     eax, -1                                 ; 2EA0 _ 83. F8, FF
        jnz     ?_0301                                  ; 2EA3 _ 75, 34
        mov     rax, qword [rbp-8H]                     ; 2EA5 _ 48: 8B. 45, F8
        mov     rdx, qword [rax+130H]                   ; 2EA9 _ 48: 8B. 90, 00000130
        mov     rax, qword [rbp-8H]                     ; 2EB0 _ 48: 8B. 45, F8
        mov     rax, qword [rax+0E8H]                   ; 2EB4 _ 48: 8B. 80, 000000E8
        or      eax, 40000000H                          ; 2EBB _ 0D, 40000000
        mov     esi, eax                                ; 2EC0 _ 89. C6
        mov     rax, qword [rbp-8H]                     ; 2EC2 _ 48: 8B. 45, F8
        mov     rax, qword [rax+60H]                    ; 2EC6 _ 48: 8B. 40, 60
        mov     ecx, 0                                  ; 2ECA _ B9, 00000000
        mov     rdi, rax                                ; 2ECF _ 48: 89. C7
        call    define_label                            ; 2ED2 _ E8, 00000000(PLT r)
        jmp     ?_0302                                  ; 2ED7 _ EB, 16

?_0301: lea     rax, [rel ?_1063]                       ; 2ED9 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 2EE0 _ 48: 89. C7
        mov     eax, 0                                  ; 2EE3 _ B8, 00000000
        call    nasm_nonfatal                           ; 2EE8 _ E8, 00000000(PLT r)
        jmp     ?_0302                                  ; 2EED _ EB, 00

?_0302: ; Local function
        nop                                             ; 2EEF _ 90
        leave                                           ; 2EF0 _ C9
        ret                                             ; 2EF1 _ C3

len_extops:; Local function
        push    rbp                                     ; 2EF2 _ 55
        mov     rbp, rsp                                ; 2EF3 _ 48: 89. E5
        push    rbx                                     ; 2EF6 _ 53
        sub     rsp, 40                                 ; 2EF7 _ 48: 83. EC, 28
        mov     qword [rbp-28H], rdi                    ; 2EFB _ 48: 89. 7D, D8
        mov     qword [rbp-20H], 0                      ; 2EFF _ 48: C7. 45, E0, 00000000
        jmp     ?_0309                                  ; 2F07 _ E9, 0000012B

?_0303: mov     rax, qword [rbp-28H]                    ; 2F0C _ 48: 8B. 45, D8
        mov     eax, dword [rax+28H]                    ; 2F10 _ 8B. 40, 28
        cmp     eax, 6                                  ; 2F13 _ 83. F8, 06
        je      ?_0306                                  ; 2F16 _ 0F 84, 000000ED
        cmp     eax, 6                                  ; 2F1C _ 83. F8, 06
        ja      ?_0308                                  ; 2F1F _ 0F 87, 00000107
        cmp     eax, 5                                  ; 2F25 _ 83. F8, 05
        je      ?_0305                                  ; 2F28 _ 0F 84, 000000A0
        cmp     eax, 5                                  ; 2F2E _ 83. F8, 05
        ja      ?_0308                                  ; 2F31 _ 0F 87, 000000F5
        cmp     eax, 4                                  ; 2F37 _ 83. F8, 04
        ja      ?_0308                                  ; 2F3A _ 0F 87, 000000EC
        cmp     eax, 2                                  ; 2F40 _ 83. F8, 02
        jnc     ?_0304                                  ; 2F43 _ 73, 40
        test    eax, eax                                ; 2F45 _ 85. C0
        je      ?_0307                                  ; 2F47 _ 0F 84, 000000DE
        cmp     eax, 1                                  ; 2F4D _ 83. F8, 01
        jne     ?_0308                                  ; 2F50 _ 0F 85, 000000D6
        mov     rax, qword [rbp-28H]                    ; 2F56 _ 48: 8B. 45, D8
        mov     rbx, qword [rax+20H]                    ; 2F5A _ 48: 8B. 58, 20
        mov     rax, qword [rbp-28H]                    ; 2F5E _ 48: 8B. 45, D8
        mov     rax, qword [rax+8H]                     ; 2F62 _ 48: 8B. 40, 08
        mov     rdi, rax                                ; 2F66 _ 48: 89. C7
        call    len_extops                              ; 2F69 _ E8, FFFFFF84
        imul    rbx, rax                                ; 2F6E _ 48: 0F AF. D8
        mov     rdx, rbx                                ; 2F72 _ 48: 89. DA
        mov     rax, qword [rbp-20H]                    ; 2F75 _ 48: 8B. 45, E0
        add     rax, rdx                                ; 2F79 _ 48: 01. D0
        mov     qword [rbp-20H], rax                    ; 2F7C _ 48: 89. 45, E0
        jmp     ?_0308                                  ; 2F80 _ E9, 000000A7

?_0304: mov     rax, qword [rbp-28H]                    ; 2F85 _ 48: 8B. 45, D8
        mov     eax, dword [rax+2CH]                    ; 2F89 _ 8B. 40, 2C
        movsxd  rdx, eax                                ; 2F8C _ 48: 63. D0
        mov     rax, qword [rbp-28H]                    ; 2F8F _ 48: 8B. 45, D8
        mov     rax, qword [rax+10H]                    ; 2F93 _ 48: 8B. 40, 10
        mov     rsi, rdx                                ; 2F97 _ 48: 89. D6
        mov     rdi, rax                                ; 2F9A _ 48: 89. C7
        call    pad_bytes                               ; 2F9D _ E8, FFFFEED6
        mov     qword [rbp-18H], rax                    ; 2FA2 _ 48: 89. 45, E8
        mov     rax, qword [rbp-28H]                    ; 2FA6 _ 48: 8B. 45, D8
        mov     rax, qword [rax+20H]                    ; 2FAA _ 48: 8B. 40, 20
        mov     rdx, qword [rbp-28H]                    ; 2FAE _ 48: 8B. 55, D8
        mov     rcx, qword [rdx+10H]                    ; 2FB2 _ 48: 8B. 4A, 10
        mov     rdx, qword [rbp-18H]                    ; 2FB6 _ 48: 8B. 55, E8
        add     rdx, rcx                                ; 2FBA _ 48: 01. CA
        imul    rdx, rax                                ; 2FBD _ 48: 0F AF. D0
        mov     rax, qword [rbp-20H]                    ; 2FC1 _ 48: 8B. 45, E0
        add     rax, rdx                                ; 2FC5 _ 48: 01. D0
        mov     qword [rbp-20H], rax                    ; 2FC8 _ 48: 89. 45, E0
        jmp     ?_0308                                  ; 2FCC _ EB, 5E

?_0305: mov     rax, qword [rbp-28H]                    ; 2FCE _ 48: 8B. 45, D8
        mov     edx, dword [rax+2CH]                    ; 2FD2 _ 8B. 50, 2C
        mov     rax, qword [rbp-28H]                    ; 2FD5 _ 48: 8B. 45, D8
        mov     rax, qword [rax+8H]                     ; 2FD9 _ 48: 8B. 40, 08
        mov     esi, edx                                ; 2FDD _ 89. D6
        mov     rdi, rax                                ; 2FDF _ 48: 89. C7
        call    warn_overflow_const                     ; 2FE2 _ E8, FFFFDAC2
        mov     rax, qword [rbp-28H]                    ; 2FE7 _ 48: 8B. 45, D8
        mov     rdx, qword [rax+20H]                    ; 2FEB _ 48: 8B. 50, 20
        mov     rax, qword [rbp-28H]                    ; 2FEF _ 48: 8B. 45, D8
        mov     eax, dword [rax+2CH]                    ; 2FF3 _ 8B. 40, 2C
        cdqe                                            ; 2FF6 _ 48: 98
        imul    rdx, rax                                ; 2FF8 _ 48: 0F AF. D0
        mov     rax, qword [rbp-20H]                    ; 2FFC _ 48: 8B. 45, E0
        add     rax, rdx                                ; 3000 _ 48: 01. D0
        mov     qword [rbp-20H], rax                    ; 3003 _ 48: 89. 45, E0
        jmp     ?_0308                                  ; 3007 _ EB, 23

?_0306: mov     rax, qword [rbp-28H]                    ; 3009 _ 48: 8B. 45, D8
        mov     rdx, qword [rax+20H]                    ; 300D _ 48: 8B. 50, 20
        mov     rax, qword [rbp-28H]                    ; 3011 _ 48: 8B. 45, D8
        mov     eax, dword [rax+2CH]                    ; 3015 _ 8B. 40, 2C
        cdqe                                            ; 3018 _ 48: 98
        imul    rdx, rax                                ; 301A _ 48: 0F AF. D0
        mov     rax, qword [rbp-20H]                    ; 301E _ 48: 8B. 45, E0
        add     rax, rdx                                ; 3022 _ 48: 01. D0
        mov     qword [rbp-20H], rax                    ; 3025 _ 48: 89. 45, E0
        jmp     ?_0308                                  ; 3029 _ EB, 01

?_0307: nop                                             ; 302B _ 90
?_0308: mov     rax, qword [rbp-28H]                    ; 302C _ 48: 8B. 45, D8
        mov     rax, qword [rax]                        ; 3030 _ 48: 8B. 00
        mov     qword [rbp-28H], rax                    ; 3033 _ 48: 89. 45, D8
?_0309: cmp     qword [rbp-28H], 0                      ; 3037 _ 48: 83. 7D, D8, 00
        jne     ?_0303                                  ; 303C _ 0F 85, FFFFFECA
        mov     rax, qword [rbp-20H]                    ; 3042 _ 48: 8B. 45, E0
        mov     rbx, qword [rbp-8H]                     ; 3046 _ 48: 8B. 5D, F8
        leave                                           ; 304A _ C9
        ret                                             ; 304B _ C3

insn_size:; Local function
        push    rbp                                     ; 304C _ 55
        mov     rbp, rsp                                ; 304D _ 48: 89. E5
        sub     rsp, 64                                 ; 3050 _ 48: 83. EC, 40
        mov     qword [rbp-38H], rdi                    ; 3054 _ 48: 89. 7D, C8
        mov     qword [rbp-18H], 0                      ; 3058 _ 48: C7. 45, E8, 00000000
        mov     rax, qword [rbp-38H]                    ; 3060 _ 48: 8B. 45, C8
        mov     eax, dword [rax]                        ; 3064 _ 8B. 00
        cmp     eax, -1                                 ; 3066 _ 83. F8, FF
        jnz     ?_0310                                  ; 3069 _ 75, 0A
        mov     eax, 0                                  ; 306B _ B8, 00000000
        jmp     ?_0318                                  ; 3070 _ E9, 000001B8

?_0310: mov     rax, qword [rbp-38H]                    ; 3075 _ 48: 8B. 45, C8
        mov     eax, dword [rax]                        ; 3079 _ 8B. 00
        cmp     eax, 17                                 ; 307B _ 83. F8, 11
        jnz     ?_0311                                  ; 307E _ 75, 16
        mov     rax, qword [rbp-38H]                    ; 3080 _ 48: 8B. 45, C8
        mov     rdi, rax                                ; 3084 _ 48: 89. C7
        call    define_equ                              ; 3087 _ E8, FFFFFCFD
        mov     eax, 0                                  ; 308C _ B8, 00000000
        jmp     ?_0318                                  ; 3091 _ E9, 00000197

?_0311: mov     rax, qword [rbp-38H]                    ; 3096 _ 48: 8B. 45, C8
        mov     eax, dword [rax]                        ; 309A _ 8B. 00
        mov     edi, eax                                ; 309C _ 89. C7
        call    opcode_is_db                            ; 309E _ E8, FFFFD342
        test    al, al                                  ; 30A3 _ 84. C0
        jz      ?_0312                                  ; 30A5 _ 74, 29
        mov     rax, qword [rbp-38H]                    ; 30A7 _ 48: 8B. 45, C8
        mov     rax, qword [rax+68H]                    ; 30AB _ 48: 8B. 40, 68
        mov     rdi, rax                                ; 30AF _ 48: 89. C7
        call    len_extops                              ; 30B2 _ E8, FFFFFE3B
        mov     qword [rbp-18H], rax                    ; 30B7 _ 48: 89. 45, E8
        mov     rax, qword [rbp-38H]                    ; 30BB _ 48: 8B. 45, C8
        mov     rdi, rax                                ; 30BF _ 48: 89. C7
        call    debug_set_db_type                       ; 30C2 _ E8, FFFFFB93
        mov     rax, qword [rbp-18H]                    ; 30C7 _ 48: 8B. 45, E8
        jmp     ?_0318                                  ; 30CB _ E9, 0000015D

?_0312: mov     rax, qword [rbp-38H]                    ; 30D0 _ 48: 8B. 45, C8
        mov     eax, dword [rax]                        ; 30D4 _ 8B. 00
        cmp     eax, 16                                 ; 30D6 _ 83. F8, 10
        jne     ?_0316                                  ; 30D9 _ 0F 85, 000000DC
        mov     rax, qword [rbp-38H]                    ; 30DF _ 48: 8B. 45, C8
        mov     rax, qword [rax+68H]                    ; 30E3 _ 48: 8B. 40, 68
        mov     qword [rbp-10H], rax                    ; 30E7 _ 48: 89. 45, F0
        mov     rax, qword [rbp-10H]                    ; 30EB _ 48: 8B. 45, F0
        mov     rax, qword [rax+8H]                     ; 30EF _ 48: 8B. 40, 08
        mov     qword [rbp-8H], rax                     ; 30F3 _ 48: 89. 45, F8
        mov     rax, qword [rbp-8H]                     ; 30F7 _ 48: 8B. 45, F8
        mov     rdi, rax                                ; 30FB _ 48: 89. C7
        call    nasm_file_size_by_path                  ; 30FE _ E8, 00000000(PLT r)
        mov     qword [rbp-20H], rax                    ; 3103 _ 48: 89. 45, E0
        cmp     qword [rbp-20H], -1                     ; 3107 _ 48: 83. 7D, E0, FF
        jnz     ?_0313                                  ; 310C _ 75, 25
        mov     rax, qword [rbp-8H]                     ; 310E _ 48: 8B. 45, F8
        lea     rdx, [rel ?_1049]                       ; 3112 _ 48: 8D. 15, 00000000(rel)
        mov     rsi, rax                                ; 3119 _ 48: 89. C6
        mov     rdi, rdx                                ; 311C _ 48: 89. D7
        mov     eax, 0                                  ; 311F _ B8, 00000000
        call    nasm_nonfatal                           ; 3124 _ E8, 00000000(PLT r)
        mov     eax, 0                                  ; 3129 _ B8, 00000000
        jmp     ?_0318                                  ; 312E _ E9, 000000FA

?_0313: mov     rax, qword [rbp-10H]                    ; 3133 _ 48: 8B. 45, F0
        mov     rax, qword [rax]                        ; 3137 _ 48: 8B. 00
        mov     qword [rbp-10H], rax                    ; 313A _ 48: 89. 45, F0
        cmp     qword [rbp-10H], 0                      ; 313E _ 48: 83. 7D, F0, 00
        jz      ?_0315                                  ; 3143 _ 74, 50
        mov     rax, qword [rbp-10H]                    ; 3145 _ 48: 8B. 45, F0
        mov     rax, qword [rax+8H]                     ; 3149 _ 48: 8B. 40, 08
        cmp     qword [rbp-20H], rax                    ; 314D _ 48: 39. 45, E0
        jg      ?_0314                                  ; 3151 _ 7F, 0A
        mov     qword [rbp-20H], 0                      ; 3153 _ 48: C7. 45, E0, 00000000
        jmp     ?_0315                                  ; 315B _ EB, 38

?_0314: mov     rax, qword [rbp-10H]                    ; 315D _ 48: 8B. 45, F0
        mov     rax, qword [rax+8H]                     ; 3161 _ 48: 8B. 40, 08
        sub     qword [rbp-20H], rax                    ; 3165 _ 48: 29. 45, E0
        mov     rax, qword [rbp-10H]                    ; 3169 _ 48: 8B. 45, F0
        mov     rax, qword [rax]                        ; 316D _ 48: 8B. 00
        mov     qword [rbp-10H], rax                    ; 3170 _ 48: 89. 45, F0
        cmp     qword [rbp-10H], 0                      ; 3174 _ 48: 83. 7D, F0, 00
        jz      ?_0315                                  ; 3179 _ 74, 1A
        mov     rax, qword [rbp-10H]                    ; 317B _ 48: 8B. 45, F0
        mov     rax, qword [rax+8H]                     ; 317F _ 48: 8B. 40, 08
        cmp     qword [rbp-20H], rax                    ; 3183 _ 48: 39. 45, E0
        jle     ?_0315                                  ; 3187 _ 7E, 0C
        mov     rax, qword [rbp-10H]                    ; 3189 _ 48: 8B. 45, F0
        mov     rax, qword [rax+8H]                     ; 318D _ 48: 8B. 40, 08
        mov     qword [rbp-20H], rax                    ; 3191 _ 48: 89. 45, E0
?_0315: mov     rax, qword [rbp-38H]                    ; 3195 _ 48: 8B. 45, C8
        mov     eax, dword [rax+74H]                    ; 3199 _ 8B. 40, 74
        cdqe                                            ; 319C _ 48: 98
        mov     rdx, qword [rbp-20H]                    ; 319E _ 48: 8B. 55, E0
        imul    rax, rdx                                ; 31A2 _ 48: 0F AF. C2
        mov     qword [rbp-20H], rax                    ; 31A6 _ 48: 89. 45, E0
        mov     rax, qword [rbp-38H]                    ; 31AA _ 48: 8B. 45, C8
        mov     dword [rax+74H], 1                      ; 31AE _ C7. 40, 74, 00000001
        mov     rax, qword [rbp-20H]                    ; 31B5 _ 48: 8B. 45, E0
        jmp     ?_0318                                  ; 31B9 _ EB, 72

?_0316: mov     rax, qword [rbp-38H]                    ; 31BB _ 48: 8B. 45, C8
        mov     rdi, rax                                ; 31BF _ 48: 89. C7
        call    insn_early_setup                        ; 31C2 _ E8, 00007575
        mov     rax, qword [rbp-38H]                    ; 31C7 _ 48: 8B. 45, C8
        mov     rdi, rax                                ; 31CB _ 48: 89. C7
        call    find_match                              ; 31CE _ E8, 000046F6
        mov     dword [rbp-24H], eax                    ; 31D3 _ 89. 45, DC
        cmp     dword [rbp-24H], 29                     ; 31D6 _ 83. 7D, DC, 1D
        ja      ?_0317                                  ; 31DA _ 77, 1A
        mov     rdx, qword [rbp-38H]                    ; 31DC _ 48: 8B. 55, C8
        mov     eax, dword [rbp-24H]                    ; 31E0 _ 8B. 45, DC
        mov     rsi, rdx                                ; 31E3 _ 48: 89. D6
        mov     edi, eax                                ; 31E6 _ 89. C7
        call    no_match_error                          ; 31E8 _ E8, FFFFE6C2
        mov     rax, -1                                 ; 31ED _ 48: C7. C0, FFFFFFFF
        jmp     ?_0318                                  ; 31F4 _ EB, 37

?_0317: mov     rax, qword [rbp-38H]                    ; 31F6 _ 48: 8B. 45, C8
        mov     rdi, rax                                ; 31FA _ 48: 89. C7
        call    calcsize                                ; 31FD _ E8, 000003B9
        mov     qword [rbp-18H], rax                    ; 3202 _ 48: 89. 45, E8
        mov     rax, qword [rbp-38H]                    ; 3206 _ 48: 8B. 45, C8
        mov     rdi, rax                                ; 320A _ 48: 89. C7
        call    debug_set_type                          ; 320D _ E8, FFFFFA8D
        mov     rdx, qword [rbp-18H]                    ; 3212 _ 48: 8B. 55, E8
        mov     rax, qword [rbp-38H]                    ; 3216 _ 48: 8B. 45, C8
        mov     rsi, rdx                                ; 321A _ 48: 89. D6
        mov     rdi, rax                                ; 321D _ 48: 89. C7
        call    merge_resb                              ; 3220 _ E8, FFFFEBB4
        mov     qword [rbp-18H], rax                    ; 3225 _ 48: 89. 45, E8
        mov     rax, qword [rbp-18H]                    ; 3229 _ 48: 8B. 45, E8
?_0318: leave                                           ; 322D _ C9
        ret                                             ; 322E _ C3

bad_hle_warn:; Local function
        push    rbp                                     ; 322F _ 55
        mov     rbp, rsp                                ; 3230 _ 48: 89. E5
        sub     rsp, 48                                 ; 3233 _ 48: 83. EC, 30
        mov     qword [rbp-28H], rdi                    ; 3237 _ 48: 89. 7D, D8
        mov     byte [rbp-29H], sil                     ; 323B _ 40: 88. 75, D7
        mov     rax, qword [rbp-28H]                    ; 323F _ 48: 8B. 45, D8
        mov     eax, dword [rax+2CH]                    ; 3243 _ 8B. 40, 2C
        mov     dword [rbp-10H], eax                    ; 3246 _ 89. 45, F0
        mov     eax, dword [rbp-10H]                    ; 3249 _ 8B. 45, F0
        sub     eax, 360                                ; 324C _ 2D, 00000168
        mov     dword [rbp-0CH], eax                    ; 3251 _ 89. 45, F4
        cmp     dword [rbp-0CH], 1                      ; 3254 _ 83. 7D, F4, 01
        ja      ?_0321                                  ; 3258 _ 0F 87, 00000103
        movzx   eax, byte [rbp-29H]                     ; 325E _ 0F B6. 45, D7
        cdqe                                            ; 3262 _ 48: 98
        mov     edx, dword [rbp-0CH]                    ; 3264 _ 8B. 55, F4
        shl     rdx, 2                                  ; 3267 _ 48: C1. E2, 02
        add     rax, rdx                                ; 326B _ 48: 01. D0
        lea     rdx, [rax*4]                            ; 326E _ 48: 8D. 14 85, 00000000
        lea     rax, [rel warn.6]                       ; 3276 _ 48: 8D. 05, 00000000(rel)
        mov     eax, dword [rdx+rax]                    ; 327D _ 8B. 04 02
        mov     dword [rbp-14H], eax                    ; 3280 _ 89. 45, EC
        mov     rax, qword [rbp-28H]                    ; 3283 _ 48: 8B. 45, D8
        mov     rax, qword [rax+0C0H]                   ; 3287 _ 48: 8B. 80, 000000C0
        mov     rsi, rax                                ; 328E _ 48: 89. C6
        mov     edi, 12                                 ; 3291 _ BF, 0000000C
        call    is_class                                ; 3296 _ E8, FFFFCEC1
        xor     eax, 01H                                ; 329B _ 83. F0, 01
        test    al, al                                  ; 329E _ 84. C0
        jz      ?_0319                                  ; 32A0 _ 74, 07
        mov     dword [rbp-14H], 2                      ; 32A2 _ C7. 45, EC, 00000002
?_0319: cmp     dword [rbp-14H], 2                      ; 32A9 _ 83. 7D, EC, 02
        jz      ?_0320                                  ; 32AD _ 74, 71
        cmp     dword [rbp-14H], 2                      ; 32AF _ 83. 7D, EC, 02
        ja      ?_0325                                  ; 32B3 _ 0F 87, 000000B2
        cmp     dword [rbp-14H], 0                      ; 32B9 _ 83. 7D, EC, 00
        je      ?_0322                                  ; 32BD _ 0F 84, 000000A1
        cmp     dword [rbp-14H], 1                      ; 32C3 _ 83. 7D, EC, 01
        jne     ?_0325                                  ; 32C7 _ 0F 85, 0000009E
        mov     rax, qword [rbp-28H]                    ; 32CD _ 48: 8B. 45, D8
        mov     eax, dword [rax+24H]                    ; 32D1 _ 8B. 40, 24
        cmp     eax, 349                                ; 32D4 _ 3D, 0000015D
        je      ?_0323                                  ; 32D9 _ 0F 84, 00000088
        mov     dword [rbp-4H], 3014656                 ; 32DF _ C7. 45, FC, 002E0000
        mov     eax, dword [rbp-4H]                     ; 32E6 _ 8B. 45, FC
        mov     edi, eax                                ; 32E9 _ 89. C7
        call    warn_active                             ; 32EB _ E8, FFFFCF63
        movzx   eax, al                                 ; 32F0 _ 0F B6. C0
        test    rax, rax                                ; 32F3 _ 48: 85. C0
        jz      ?_0323                                  ; 32F6 _ 74, 6F
        mov     eax, dword [rbp-10H]                    ; 32F8 _ 8B. 45, F0
        mov     edi, eax                                ; 32FB _ 89. C7
        call    prefix_name                             ; 32FD _ E8, 00000000(PLT r)
        mov     rdx, rax                                ; 3302 _ 48: 89. C2
        lea     rcx, [rel ?_1064]                       ; 3305 _ 48: 8D. 0D, 00000000(rel)
        mov     eax, dword [rbp-4H]                     ; 330C _ 8B. 45, FC
        mov     rsi, rcx                                ; 330F _ 48: 89. CE
        mov     edi, eax                                ; 3312 _ 89. C7
        mov     eax, 0                                  ; 3314 _ B8, 00000000
        call    nasm_warn_                              ; 3319 _ E8, 00000000(PLT r)
        jmp     ?_0323                                  ; 331E _ EB, 47

?_0320: mov     dword [rbp-8H], 3014656                 ; 3320 _ C7. 45, F8, 002E0000
        mov     eax, dword [rbp-8H]                     ; 3327 _ 8B. 45, F8
        mov     edi, eax                                ; 332A _ 89. C7
        call    warn_active                             ; 332C _ E8, FFFFCF22
        movzx   eax, al                                 ; 3331 _ 0F B6. C0
        test    rax, rax                                ; 3334 _ 48: 85. C0
        jz      ?_0324                                  ; 3337 _ 74, 31
        mov     eax, dword [rbp-10H]                    ; 3339 _ 8B. 45, F0
        mov     edi, eax                                ; 333C _ 89. C7
        call    prefix_name                             ; 333E _ E8, 00000000(PLT r)
        mov     rdx, rax                                ; 3343 _ 48: 89. C2
        lea     rcx, [rel ?_1065]                       ; 3346 _ 48: 8D. 0D, 00000000(rel)
        mov     eax, dword [rbp-8H]                     ; 334D _ 8B. 45, F8
        mov     rsi, rcx                                ; 3350 _ 48: 89. CE
        mov     edi, eax                                ; 3353 _ 89. C7
        mov     eax, 0                                  ; 3355 _ B8, 00000000
        call    nasm_warn_                              ; 335A _ E8, 00000000(PLT r)
        jmp     ?_0324                                  ; 335F _ EB, 09

?_0321: nop                                             ; 3361 _ 90
        jmp     ?_0325                                  ; 3362 _ EB, 07

?_0322: nop                                             ; 3364 _ 90
        jmp     ?_0325                                  ; 3365 _ EB, 04

?_0323: nop                                             ; 3367 _ 90
        jmp     ?_0325                                  ; 3368 _ EB, 01

?_0324: nop                                             ; 336A _ 90
?_0325: leave                                           ; 336B _ C9
        ret                                             ; 336C _ C3

ea_evex_flags:; Local function
        push    rbp                                     ; 336D _ 55
        mov     rbp, rsp                                ; 336E _ 48: 89. E5
        sub     rsp, 48                                 ; 3371 _ 48: 83. EC, 30
        mov     qword [rbp-28H], rdi                    ; 3375 _ 48: 89. 7D, D8
        mov     qword [rbp-30H], rsi                    ; 3379 _ 48: 89. 75, D0
        mov     rax, qword [rbp-28H]                    ; 337D _ 48: 8B. 45, D8
        mov     rax, qword [rax+0B8H]                   ; 3381 _ 48: 8B. 80, 000000B8
        mov     qword [rbp-8H], rax                     ; 3388 _ 48: 89. 45, F8
        cmp     qword [rbp-8H], 0                       ; 338C _ 48: 83. 7D, F8, 00
        jz      ?_0326                                  ; 3391 _ 74, 0E
        mov     rax, qword [rbp-8H]                     ; 3393 _ 48: 8B. 45, F8
        movzx   eax, word [rax+40H]                     ; 3397 _ 0F B7. 40, 40
        mov     word [rbp-16H], ax                      ; 339B _ 66: 89. 45, EA
        jmp     ?_0327                                  ; 339F _ EB, 06

?_0326:
; Note: Length-changing prefix causes delay on old Intel processors
        mov     word [rbp-16H], 0                       ; 33A1 _ 66: C7. 45, EA, 0000
?_0327: movzx   eax, word [rbp-16H]                     ; 33A7 _ 0F B7. 45, EA
        and     eax, 0C0H                               ; 33AB _ 25, 000000C0
        test    rax, rax                                ; 33B0 _ 48: 85. C0
        je      ?_0331                                  ; 33B3 _ 0F 84, 0000010E
        mov     rax, qword [rbp-28H]                    ; 33B9 _ 48: 8B. 45, D8
        mov     rax, qword [rax+0B0H]                   ; 33BD _ 48: 8B. 80, 000000B0
        mov     esi, 38                                 ; 33C4 _ BE, 00000026
        mov     rdi, rax                                ; 33C9 _ 48: 89. C7
        call    itemp_has                               ; 33CC _ E8, FFFFCFDF
        xor     eax, 01H                                ; 33D1 _ 83. F0, 01
        test    al, al                                  ; 33D4 _ 84. C0
        jz      ?_0330                                  ; 33D6 _ 74, 77
        mov     rax, qword [rbp-28H]                    ; 33D8 _ 48: 8B. 45, D8
        mov     eax, dword [rax+88H]                    ; 33DC _ 8B. 80, 00000088
        shr     eax, 29                                 ; 33E2 _ C1. E8, 1D
        and     eax, 03H                                ; 33E5 _ 83. E0, 03
        mov     dword [rbp-14H], eax                    ; 33E8 _ 89. 45, EC
        cmp     dword [rbp-14H], 2                      ; 33EB _ 83. 7D, EC, 02
        setne   al                                      ; 33EF _ 0F 95. C0
        movzx   eax, al                                 ; 33F2 _ 0F B6. C0
        test    rax, rax                                ; 33F5 _ 48: 85. C0
        jz      ?_0330                                  ; 33F8 _ 74, 55
        movzx   eax, word [rbp-16H]                     ; 33FA _ 0F B7. 45, EA
        and     eax, 40H                                ; 33FE _ 83. E0, 40
        test    rax, rax                                ; 3401 _ 48: 85. C0
        jz      ?_0328                                  ; 3404 _ 74, 0D
        lea     rax, [rel ?_1066]                       ; 3406 _ 48: 8D. 05, 00000000(rel)
        mov     qword [rbp-10H], rax                    ; 340D _ 48: 89. 45, F0
        jmp     ?_0329                                  ; 3411 _ EB, 0B

?_0328: lea     rax, [rel ?_1067]                       ; 3413 _ 48: 8D. 05, 00000000(rel)
        mov     qword [rbp-10H], rax                    ; 341A _ 48: 89. 45, F0
?_0329: mov     eax, dword [rbp-14H]                    ; 341E _ 8B. 45, EC
        mov     edx, 128                                ; 3421 _ BA, 00000080
        mov     ecx, eax                                ; 3426 _ 89. C1
        shl     edx, cl                                 ; 3428 _ D3. E2
        mov     rax, qword [rbp-10H]                    ; 342A _ 48: 8B. 45, F0
        lea     rcx, [rel ?_1068]                       ; 342E _ 48: 8D. 0D, 00000000(rel)
        mov     rsi, rax                                ; 3435 _ 48: 89. C6
        mov     rdi, rcx                                ; 3438 _ 48: 89. CF
        mov     eax, 0                                  ; 343B _ B8, 00000000
        call    nasm_nonfatal                           ; 3440 _ E8, 00000000(PLT r)
        mov     eax, 4294967295                         ; 3445 _ B8, FFFFFFFF
        jmp     ?_0333                                  ; 344A _ E9, 000000AB

?_0330: mov     rax, qword [rbp-28H]                    ; 344F _ 48: 8B. 45, D8
        mov     eax, dword [rax+88H]                    ; 3453 _ 8B. 80, 00000088
        and     eax, 9FFFFFFFH                          ; 3459 _ 25, 9FFFFFFF
        mov     edx, eax                                ; 345E _ 89. C2
        mov     rax, qword [rbp-28H]                    ; 3460 _ 48: 8B. 45, D8
        mov     dword [rax+88H], edx                    ; 3464 _ 89. 90, 00000088
        mov     rax, qword [rbp-28H]                    ; 346A _ 48: 8B. 45, D8
        mov     eax, dword [rax+88H]                    ; 346E _ 8B. 80, 00000088
        xor     eax, 10000000H                          ; 3474 _ 35, 10000000
        mov     edx, eax                                ; 3479 _ 89. C2
        mov     rax, qword [rbp-28H]                    ; 347B _ 48: 8B. 45, D8
        mov     dword [rax+88H], edx                    ; 347F _ 89. 90, 00000088
        mov     rax, qword [rbp-8H]                     ; 3485 _ 48: 8B. 45, F8
        movzx   eax, word [rax+40H]                     ; 3489 _ 0F B7. 40, 40
        movzx   eax, ax                                 ; 348D _ 0F B7. C0
        and     eax, 40H                                ; 3490 _ 83. E0, 40
        test    rax, rax                                ; 3493 _ 48: 85. C0
        jz      ?_0332                                  ; 3496 _ 74, 5D
        mov     rax, qword [rbp-28H]                    ; 3498 _ 48: 8B. 45, D8
        mov     edx, dword [rax+88H]                    ; 349C _ 8B. 90, 00000088
        mov     rax, qword [rbp-28H]                    ; 34A2 _ 48: 8B. 45, D8
        mov     eax, dword [rax+90H]                    ; 34A6 _ 8B. 80, 00000090
        sub     eax, 396                                ; 34AC _ 2D, 0000018C
        shl     eax, 29                                 ; 34B1 _ C1. E0, 1D
        and     eax, 60000000H                          ; 34B4 _ 25, 60000000
        xor     edx, eax                                ; 34B9 _ 31. C2
        mov     rax, qword [rbp-28H]                    ; 34BB _ 48: 8B. 45, D8
        mov     dword [rax+88H], edx                    ; 34BF _ 89. 90, 00000088
        jmp     ?_0332                                  ; 34C5 _ EB, 2E

?_0331: mov     rax, qword [rbp-30H]                    ; 34C7 _ 48: 8B. 45, D0
        movzx   eax, word [rax+40H]                     ; 34CB _ 0F B7. 40, 40
        movzx   eax, ax                                 ; 34CF _ 0F B7. C0
        and     eax, 20H                                ; 34D2 _ 83. E0, 20
        test    rax, rax                                ; 34D5 _ 48: 85. C0
        jz      ?_0332                                  ; 34D8 _ 74, 1B
        mov     rax, qword [rbp-28H]                    ; 34DA _ 48: 8B. 45, D8
        mov     eax, dword [rax+88H]                    ; 34DE _ 8B. 80, 00000088
        xor     eax, 10000000H                          ; 34E4 _ 35, 10000000
        mov     edx, eax                                ; 34E9 _ 89. C2
        mov     rax, qword [rbp-28H]                    ; 34EB _ 48: 8B. 45, D8
        mov     dword [rax+88H], edx                    ; 34EF _ 89. 90, 00000088
?_0332: mov     eax, 0                                  ; 34F5 _ B8, 00000000
?_0333: leave                                           ; 34FA _ C9
        ret                                             ; 34FB _ C3

calcsize_speculative:; Local function
        push    rbp                                     ; 34FC _ 55
        mov     rbp, rsp                                ; 34FD _ 48: 89. E5
        sub     rsp, 608                                ; 3500 _ 48: 81. EC, 00000260
        mov     qword [rbp-258H], rdi                   ; 3507 _ 48: 89. BD, FFFFFDA8
        mov     qword [rbp-260H], rsi                   ; 350E _ 48: 89. B5, FFFFFDA0
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        mov     rax, qword [fs:abs 28H]                 ; 3515 _ 64 48: 8B. 04 25, 00000028
        mov     qword [rbp-8H], rax                     ; 351E _ 48: 89. 45, F8
        xor     eax, eax                                ; 3522 _ 31. C0
        mov     rdx, qword [rbp-258H]                   ; 3524 _ 48: 8B. 95, FFFFFDA8
        lea     rax, [rbp-240H]                         ; 352B _ 48: 8D. 85, FFFFFDC0
        mov     rcx, rdx                                ; 3532 _ 48: 89. D1
        mov     edx, 560                                ; 3535 _ BA, 00000230
        mov     rsi, rcx                                ; 353A _ 48: 89. CE
        mov     rdi, rax                                ; 353D _ 48: 89. C7
        call    memcpy                                  ; 3540 _ E8, 00000000(PLT r)
        mov     byte [rbp-1C7H], 1                      ; 3545 _ C6. 85, FFFFFE39, 01
        mov     rax, qword [rbp-260H]                   ; 354C _ 48: 8B. 85, FFFFFDA0
        mov     qword [rbp-190H], rax                   ; 3553 _ 48: 89. 85, FFFFFE70
        call    nasm_error_hold_push                    ; 355A _ E8, 00000000(PLT r)
        mov     qword [rbp-250H], rax                   ; 355F _ 48: 89. 85, FFFFFDB0
        lea     rax, [rbp-240H]                         ; 3566 _ 48: 8D. 85, FFFFFDC0
        mov     rdi, rax                                ; 356D _ 48: 89. C7
        call    calcsize                                ; 3570 _ E8, 00000046
        mov     qword [rbp-248H], rax                   ; 3575 _ 48: 89. 85, FFFFFDB8
        mov     rax, qword [rbp-250H]                   ; 357C _ 48: 8B. 85, FFFFFDB0
        mov     esi, 0                                  ; 3583 _ BE, 00000000
        mov     rdi, rax                                ; 3588 _ 48: 89. C7
        call    nasm_error_hold_pop                     ; 358B _ E8, 00000000(PLT r)
        cmp     eax, 7                                  ; 3590 _ 83. F8, 07
        jbe     ?_0334                                  ; 3593 _ 76, 09
        mov     rax, -1                                 ; 3595 _ 48: C7. C0, FFFFFFFF
        jmp     ?_0335                                  ; 359C _ EB, 07

?_0334: mov     rax, qword [rbp-248H]                   ; 359E _ 48: 8B. 85, FFFFFDB8
?_0335: mov     rdx, qword [rbp-8H]                     ; 35A5 _ 48: 8B. 55, F8
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        sub     rdx, qword [fs:abs 28H]                 ; 35A9 _ 64 48: 2B. 14 25, 00000028
        jz      ?_0336                                  ; 35B2 _ 74, 05
        call    __stack_chk_fail                        ; 35B4 _ E8, 00000000(PLT r)
?_0336: leave                                           ; 35B9 _ C9
        ret                                             ; 35BA _ C3

calcsize:; Local function
        push    rbp                                     ; 35BB _ 55
        mov     rbp, rsp                                ; 35BC _ 48: 89. E5
        push    rbx                                     ; 35BF _ 53
        sub     rsp, 232                                ; 35C0 _ 48: 81. EC, 000000E8
        mov     qword [rbp-0E8H], rdi                   ; 35C7 _ 48: 89. BD, FFFFFF18
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        mov     rax, qword [fs:abs 28H]                 ; 35CE _ 64 48: 8B. 04 25, 00000028
        mov     qword [rbp-18H], rax                    ; 35D7 _ 48: 89. 45, E8
        xor     eax, eax                                ; 35DB _ 31. C0
        mov     rax, qword [rbp-0E8H]                   ; 35DD _ 48: 8B. 85, FFFFFF18
        mov     rax, qword [rax+0B0H]                   ; 35E4 _ 48: 8B. 80, 000000B0
        mov     qword [rbp-58H], rax                    ; 35EB _ 48: 89. 45, A8
        mov     rax, qword [rbp-0E8H]                   ; 35EF _ 48: 8B. 85, FFFFFF18
        movzx   eax, byte [rax+7AH]                     ; 35F6 _ 0F B6. 40, 7A
        movzx   eax, al                                 ; 35FA _ 0F B6. C0
        mov     dword [rbp-0BCH], eax                   ; 35FD _ 89. 85, FFFFFF44
        mov     rax, qword [rbp-58H]                    ; 3603 _ 48: 8B. 45, A8
        mov     rax, qword [rax+40H]                    ; 3607 _ 48: 8B. 40, 40
        mov     qword [rbp-70H], rax                    ; 360B _ 48: 89. 45, 90
        mov     qword [rbp-68H], 0                      ; 360F _ 48: C7. 45, 98, 00000000
        mov     byte [rbp-0D4H], 0                      ; 3617 _ C6. 85, FFFFFF2C, 00
        mov     byte [rbp-0D3H], 0                      ; 361E _ C6. 85, FFFFFF2D, 00
        mov     byte [rbp-0D2H], 1                      ; 3625 _ C6. 85, FFFFFF2E, 01
        mov     dword [rbp-0CCH], -1                    ; 362C _ C7. 85, FFFFFF34, FFFFFFFF
        mov     dword [rbp-0C8H], 0                     ; 3636 _ C7. 85, FFFFFF38, 00000000
        mov     rax, qword [rbp-0E8H]                   ; 3640 _ 48: 8B. 85, FFFFFF18
        mov     dword [rax+84H], 0                      ; 3647 _ C7. 80, 00000084, 00000000
        mov     rax, qword [rbp-0E8H]                   ; 3651 _ 48: 8B. 85, FFFFFF18
        mov     dword [rax+88H], 0                      ; 3658 _ C7. 80, 00000088, 00000000
        mov     rax, qword [rbp-0E8H]                   ; 3662 _ 48: 8B. 85, FFFFFF18
        mov     byte [rax+7EH], 0                       ; 3669 _ C6. 40, 7E, 00
        mov     rax, qword [rbp-0E8H]                   ; 366D _ 48: 8B. 85, FFFFFF18
        mov     byte [rax+80H], 0                       ; 3674 _ C6. 80, 00000080, 00
        mov     dword [rbp-0D0H], 1                     ; 367B _ C7. 85, FFFFFF30, 00000001
        cmp     dword [rbp-0BCH], 16                    ; 3685 _ 83. BD, FFFFFF44, 10
        jz      ?_0337                                  ; 368C _ 74, 07
        mov     edx, 32                                 ; 368E _ BA, 00000020
        jmp     ?_0338                                  ; 3693 _ EB, 05

?_0337: mov     edx, 16                                 ; 3695 _ BA, 00000010
?_0338: mov     rax, qword [rbp-0E8H]                   ; 369A _ 48: 8B. 85, FFFFFF18
        mov     byte [rax+7BH], dl                      ; 36A1 _ 88. 50, 7B
        lea     rax, [rbp-40H]                          ; 36A4 _ 48: 8D. 45, C0
        mov     edx, 36                                 ; 36A8 _ BA, 00000024
        mov     esi, 0                                  ; 36AD _ BE, 00000000
        mov     rdi, rax                                ; 36B2 _ 48: 89. C7
        call    memset                                  ; 36B5 _ E8, 00000000(PLT r)
        jmp     ?_0463                                  ; 36BA _ E9, 000016B7

?_0339: mov     rax, qword [rbp-70H]                    ; 36BF _ 48: 8B. 45, 90
        lea     rdx, [rax+1H]                           ; 36C3 _ 48: 8D. 50, 01
        mov     qword [rbp-70H], rdx                    ; 36C7 _ 48: 89. 55, 90
        movzx   eax, byte [rax]                         ; 36CB _ 0F B6. 00
        mov     byte [rbp-0D1H], al                     ; 36CE _ 88. 85, FFFFFF2F
        movzx   eax, byte [rbp-0D1H]                    ; 36D4 _ 0F B6. 85, FFFFFF2F
        and     eax, 03H                                ; 36DB _ 83. E0, 03
        mov     edx, eax                                ; 36DE _ 89. C2
        movzx   eax, byte [rbp-0D4H]                    ; 36E0 _ 0F B6. 85, FFFFFF2C
        shl     eax, 2                                  ; 36E7 _ C1. E0, 02
        and     eax, 04H                                ; 36EA _ 83. E0, 04
        or      eax, edx                                ; 36ED _ 09. D0
        mov     dword [rbp-0ACH], eax                   ; 36EF _ 89. 85, FFFFFF54
        mov     edx, dword [rbp-0ACH]                   ; 36F5 _ 8B. 95, FFFFFF54
        mov     rax, qword [rbp-0E8H]                   ; 36FB _ 48: 8B. 85, FFFFFF18
        mov     esi, edx                                ; 3702 _ 89. D6
        mov     rdi, rax                                ; 3704 _ 48: 89. C7
        call    get_operand                             ; 3707 _ E8, FFFFD0E5
        mov     qword [rbp-50H], rax                    ; 370C _ 48: 89. 45, B0
        movzx   eax, byte [rbp-0D1H]                    ; 3710 _ 0F B6. 85, FFFFFF2F
        shr     al, 3                                   ; 3717 _ C0. E8, 03
        movzx   eax, al                                 ; 371A _ 0F B6. C0
        and     eax, 03H                                ; 371D _ 83. E0, 03
        mov     edx, eax                                ; 3720 _ 89. C2
        movzx   eax, byte [rbp-0D4H]                    ; 3722 _ 0F B6. 85, FFFFFF2C
        add     eax, eax                                ; 3729 _ 01. C0
        and     eax, 04H                                ; 372B _ 83. E0, 04
        or      eax, edx                                ; 372E _ 09. D0
        mov     dword [rbp-0A8H], eax                   ; 3730 _ 89. 85, FFFFFF58
        mov     qword [rbp-48H], 0                      ; 3736 _ 48: C7. 45, B8, 00000000
        mov     byte [rbp-0D4H], 0                      ; 373E _ C6. 85, FFFFFF2C, 00
        movzx   eax, byte [rbp-0D1H]                    ; 3745 _ 0F B6. 85, FFFFFF2F
        cmp     eax, 254                                ; 374C _ 3D, 000000FE
        je      ?_0454                                  ; 3751 _ 0F 84, 0000141B
        cmp     eax, 254                                ; 3757 _ 3D, 000000FE
        jg      ?_0462                                  ; 375C _ 0F 8F, 000015F0
        cmp     eax, 253                                ; 3762 _ 3D, 000000FD
        je      ?_0453                                  ; 3767 _ 0F 84, 000013F6
        cmp     eax, 253                                ; 376D _ 3D, 000000FD
        jg      ?_0462                                  ; 3772 _ 0F 8F, 000015DA
        cmp     eax, 252                                ; 3778 _ 3D, 000000FC
        je      ?_0452                                  ; 377D _ 0F 84, 000013D1
        cmp     eax, 252                                ; 3783 _ 3D, 000000FC
        jg      ?_0462                                  ; 3788 _ 0F 8F, 000015C4
        cmp     eax, 251                                ; 378E _ 3D, 000000FB
        je      ?_0451                                  ; 3793 _ 0F 84, 000013B1
        cmp     eax, 251                                ; 3799 _ 3D, 000000FB
        jg      ?_0462                                  ; 379E _ 0F 8F, 000015AE
        cmp     eax, 249                                ; 37A4 _ 3D, 000000F9
        je      ?_0450                                  ; 37A9 _ 0F 84, 0000131E
        cmp     eax, 249                                ; 37AF _ 3D, 000000F9
        jg      ?_0462                                  ; 37B4 _ 0F 8F, 00001598
        cmp     eax, 248                                ; 37BA _ 3D, 000000F8
        je      ?_0463                                  ; 37BF _ 0F 84, 000015B1
        cmp     eax, 248                                ; 37C5 _ 3D, 000000F8
        jg      ?_0462                                  ; 37CA _ 0F 8F, 00001582
        cmp     eax, 247                                ; 37D0 _ 3D, 000000F7
        je      ?_0449                                  ; 37D5 _ 0F 84, 000012DF
        cmp     eax, 247                                ; 37DB _ 3D, 000000F7
        jg      ?_0462                                  ; 37E0 _ 0F 8F, 0000156C
        cmp     eax, 246                                ; 37E6 _ 3D, 000000F6
        je      ?_0446                                  ; 37EB _ 0F 84, 00001290
        cmp     eax, 246                                ; 37F1 _ 3D, 000000F6
        jg      ?_0462                                  ; 37F6 _ 0F 8F, 00001556
        cmp     eax, 245                                ; 37FC _ 3D, 000000F5
        je      ?_0448                                  ; 3801 _ 0F 84, 000012A0
        cmp     eax, 245                                ; 3807 _ 3D, 000000F5
        jg      ?_0462                                  ; 380C _ 0F 8F, 00001540
        cmp     eax, 244                                ; 3812 _ 3D, 000000F4
        je      ?_0447                                  ; 3817 _ 0F 84, 00001277
        cmp     eax, 244                                ; 381D _ 3D, 000000F4
        jg      ?_0462                                  ; 3822 _ 0F 8F, 0000152A
        cmp     eax, 241                                ; 3828 _ 3D, 000000F1
        je      ?_0445                                  ; 382D _ 0F 84, 00001240
        cmp     eax, 241                                ; 3833 _ 3D, 000000F1
        jg      ?_0462                                  ; 3838 _ 0F 8F, 00001514
        cmp     eax, 240                                ; 383E _ 3D, 000000F0
        je      ?_0444                                  ; 3843 _ 0F 84, 00001209
        cmp     eax, 240                                ; 3849 _ 3D, 000000F0
        jg      ?_0462                                  ; 384E _ 0F 8F, 000014FE
        cmp     eax, 239                                ; 3854 _ 3D, 000000EF
        jg      ?_0462                                  ; 3859 _ 0F 8F, 000014F3
        cmp     eax, 237                                ; 385F _ 3D, 000000ED
        jge     ?_0443                                  ; 3864 _ 0F 8D, 000011CA
        cmp     eax, 233                                ; 386A _ 3D, 000000E9
        je      ?_0442                                  ; 386F _ 0F 84, 00001199
        cmp     eax, 233                                ; 3875 _ 3D, 000000E9
        jg      ?_0462                                  ; 387A _ 0F 8F, 000014D2
        cmp     eax, 232                                ; 3880 _ 3D, 000000E8
        je      ?_0441                                  ; 3885 _ 0F 84, 0000115D
        cmp     eax, 232                                ; 388B _ 3D, 000000E8
        jg      ?_0462                                  ; 3890 _ 0F 8F, 000014BC
        cmp     eax, 231                                ; 3896 _ 3D, 000000E7
        je      ?_0440                                  ; 389B _ 0F 84, 00001123
        cmp     eax, 231                                ; 38A1 _ 3D, 000000E7
        jg      ?_0462                                  ; 38A6 _ 0F 8F, 000014A6
        cmp     eax, 230                                ; 38AC _ 3D, 000000E6
        je      ?_0439                                  ; 38B1 _ 0F 84, 000010E9
        cmp     eax, 230                                ; 38B7 _ 3D, 000000E6
        jg      ?_0462                                  ; 38BC _ 0F 8F, 00001490
        cmp     eax, 229                                ; 38C2 _ 3D, 000000E5
        je      ?_0438                                  ; 38C7 _ 0F 84, 000010AF
        cmp     eax, 229                                ; 38CD _ 3D, 000000E5
        jg      ?_0462                                  ; 38D2 _ 0F 8F, 0000147A
        cmp     eax, 228                                ; 38D8 _ 3D, 000000E4
        je      ?_0437                                  ; 38DD _ 0F 84, 00001075
        cmp     eax, 228                                ; 38E3 _ 3D, 000000E4
        jg      ?_0462                                  ; 38E8 _ 0F 8F, 00001464
        cmp     eax, 226                                ; 38EE _ 3D, 000000E2
        je      ?_0435                                  ; 38F3 _ 0F 84, 00001011
        cmp     eax, 226                                ; 38F9 _ 3D, 000000E2
        jg      ?_0462                                  ; 38FE _ 0F 8F, 0000144E
        cmp     eax, 225                                ; 3904 _ 3D, 000000E1
        je      ?_0434                                  ; 3909 _ 0F 84, 00000FD6
        cmp     eax, 225                                ; 390F _ 3D, 000000E1
        jg      ?_0462                                  ; 3914 _ 0F 8F, 00001438
        cmp     eax, 224                                ; 391A _ 3D, 000000E0
        je      ?_0431                                  ; 391F _ 0F 84, 00000EFF
        cmp     eax, 224                                ; 3925 _ 3D, 000000E0
        jg      ?_0462                                  ; 392A _ 0F 8F, 00001422
        cmp     eax, 223                                ; 3930 _ 3D, 000000DF
        je      ?_0430                                  ; 3935 _ 0F 84, 00000EC9
        cmp     eax, 223                                ; 393B _ 3D, 000000DF
        jg      ?_0462                                  ; 3940 _ 0F 8F, 0000140C
        cmp     eax, 222                                ; 3946 _ 3D, 000000DE
        je      ?_0429                                  ; 394B _ 0F 84, 00000E93
        cmp     eax, 222                                ; 3951 _ 3D, 000000DE
        jg      ?_0462                                  ; 3956 _ 0F 8F, 000013F6
        cmp     eax, 221                                ; 395C _ 3D, 000000DD
        je      ?_0463                                  ; 3961 _ 0F 84, 0000140F
        cmp     eax, 221                                ; 3967 _ 3D, 000000DD
        jg      ?_0462                                  ; 396C _ 0F 8F, 000013E0
        cmp     eax, 220                                ; 3972 _ 3D, 000000DC
        je      ?_0428                                  ; 3977 _ 0F 84, 00000E43
        cmp     eax, 220                                ; 397D _ 3D, 000000DC
        jg      ?_0462                                  ; 3982 _ 0F 8F, 000013CA
        cmp     eax, 219                                ; 3988 _ 3D, 000000DB
        je      ?_0427                                  ; 398D _ 0F 84, 00000E1A
        cmp     eax, 219                                ; 3993 _ 3D, 000000DB
        jg      ?_0462                                  ; 3998 _ 0F 8F, 000013B4
        cmp     eax, 218                                ; 399E _ 3D, 000000DA
        je      ?_0426                                  ; 39A3 _ 0F 84, 00000DF1
        cmp     eax, 218                                ; 39A9 _ 3D, 000000DA
        jg      ?_0462                                  ; 39AE _ 0F 8F, 0000139E
        cmp     eax, 217                                ; 39B4 _ 3D, 000000D9
        je      ?_0425                                  ; 39B9 _ 0F 84, 00000DC8
        cmp     eax, 217                                ; 39BF _ 3D, 000000D9
        jg      ?_0462                                  ; 39C4 _ 0F 8F, 00001388
        cmp     eax, 216                                ; 39CA _ 3D, 000000D8
        je      ?_0420                                  ; 39CF _ 0F 84, 00000CDD
        cmp     eax, 216                                ; 39D5 _ 3D, 000000D8
        jg      ?_0462                                  ; 39DA _ 0F 8F, 00001372
        cmp     eax, 215                                ; 39E0 _ 3D, 000000D7
        je      ?_0410                                  ; 39E5 _ 0F 84, 00000B3B
        cmp     eax, 215                                ; 39EB _ 3D, 000000D7
        jg      ?_0462                                  ; 39F0 _ 0F 8F, 0000135C
        cmp     eax, 214                                ; 39F6 _ 3D, 000000D6
        je      ?_0463                                  ; 39FB _ 0F 84, 00001375
        cmp     eax, 214                                ; 3A01 _ 3D, 000000D6
        jg      ?_0462                                  ; 3A06 _ 0F 8F, 00001346
        cmp     eax, 213                                ; 3A0C _ 3D, 000000D5
        je      ?_0419                                  ; 3A11 _ 0F 84, 00000C77
        cmp     eax, 213                                ; 3A17 _ 3D, 000000D5
        jg      ?_0462                                  ; 3A1C _ 0F 8F, 00001330
        cmp     eax, 212                                ; 3A22 _ 3D, 000000D4
        je      ?_0415                                  ; 3A27 _ 0F 84, 00000B70
        cmp     eax, 212                                ; 3A2D _ 3D, 000000D4
        jg      ?_0462                                  ; 3A32 _ 0F 8F, 0000131A
        cmp     eax, 211                                ; 3A38 _ 3D, 000000D3
        je      ?_0411                                  ; 3A3D _ 0F 84, 00000B32
        cmp     eax, 211                                ; 3A43 _ 3D, 000000D3
        jg      ?_0462                                  ; 3A48 _ 0F 8F, 00001304
        cmp     eax, 210                                ; 3A4E _ 3D, 000000D2
        je      ?_0463                                  ; 3A53 _ 0F 84, 0000131D
        cmp     eax, 210                                ; 3A59 _ 3D, 000000D2
        jg      ?_0462                                  ; 3A5E _ 0F 8F, 000012EE
        cmp     eax, 209                                ; 3A64 _ 3D, 000000D1
        je      ?_0404                                  ; 3A69 _ 0F 84, 000009BC
        cmp     eax, 209                                ; 3A6F _ 3D, 000000D1
        jg      ?_0462                                  ; 3A74 _ 0F 8F, 000012D8
        cmp     eax, 208                                ; 3A7A _ 3D, 000000D0
        je      ?_0396                                  ; 3A7F _ 0F 84, 000008DF
        cmp     eax, 208                                ; 3A85 _ 3D, 000000D0
        jg      ?_0462                                  ; 3A8A _ 0F 8F, 000012C2
        cmp     eax, 207                                ; 3A90 _ 3D, 000000CF
        jg      ?_0462                                  ; 3A95 _ 0F 8F, 000012B7
        cmp     eax, 204                                ; 3A9B _ 3D, 000000CC
        jge     ?_0463                                  ; 3AA0 _ 0F 8D, 000012D0
        cmp     eax, 203                                ; 3AA6 _ 3D, 000000CB
        je      ?_0389                                  ; 3AAB _ 0F 84, 00000851
        cmp     eax, 203                                ; 3AB1 _ 3D, 000000CB
        jg      ?_0462                                  ; 3AB6 _ 0F 8F, 00001296
        cmp     eax, 202                                ; 3ABC _ 3D, 000000CA
        je      ?_0463                                  ; 3AC1 _ 0F 84, 000012AF
        cmp     eax, 202                                ; 3AC7 _ 3D, 000000CA
        jg      ?_0462                                  ; 3ACC _ 0F 8F, 00001280
        cmp     eax, 201                                ; 3AD2 _ 3D, 000000C9
        je      ?_0386                                  ; 3AD7 _ 0F 84, 000007C5
        cmp     eax, 201                                ; 3ADD _ 3D, 000000C9
        jg      ?_0462                                  ; 3AE2 _ 0F 8F, 0000126A
        cmp     eax, 200                                ; 3AE8 _ 3D, 000000C8
        je      ?_0382                                  ; 3AED _ 0F 84, 0000073A
        cmp     eax, 200                                ; 3AF3 _ 3D, 000000C8
        jg      ?_0462                                  ; 3AF8 _ 0F 8F, 00001254
        cmp     eax, 199                                ; 3AFE _ 3D, 000000C7
        jg      ?_0462                                  ; 3B03 _ 0F 8F, 00001249
        cmp     eax, 196                                ; 3B09 _ 3D, 000000C4
        jge     ?_0381                                  ; 3B0E _ 0F 8D, 0000070A
        cmp     eax, 195                                ; 3B14 _ 3D, 000000C3
        jg      ?_0462                                  ; 3B19 _ 0F 8F, 00001233
        cmp     eax, 192                                ; 3B1F _ 3D, 000000C0
        jge     ?_0380                                  ; 3B24 _ 0F 8D, 000006EA
        cmp     eax, 191                                ; 3B2A _ 3D, 000000BF
        jg      ?_0462                                  ; 3B2F _ 0F 8F, 0000121D
        cmp     eax, 188                                ; 3B35 _ 3D, 000000BC
        jge     ?_0379                                  ; 3B3A _ 0F 8D, 000006CA
        cmp     eax, 187                                ; 3B40 _ 3D, 000000BB
        jg      ?_0462                                  ; 3B45 _ 0F 8F, 00001207
        cmp     eax, 185                                ; 3B4B _ 3D, 000000B9
        jge     ?_0378                                  ; 3B50 _ 0F 8D, 0000069F
        cmp     eax, 184                                ; 3B56 _ 3D, 000000B8
        je      ?_0376                                  ; 3B5B _ 0F 84, 0000062C
        cmp     eax, 184                                ; 3B61 _ 3D, 000000B8
        jg      ?_0462                                  ; 3B66 _ 0F 8F, 000011E6
        cmp     eax, 183                                ; 3B6C _ 3D, 000000B7
        jg      ?_0462                                  ; 3B71 _ 0F 8F, 000011DB
        cmp     eax, 180                                ; 3B77 _ 3D, 000000B4
        jge     ?_0373                                  ; 3B7C _ 0F 8D, 000005B9
        cmp     eax, 179                                ; 3B82 _ 3D, 000000B3
        jg      ?_0462                                  ; 3B87 _ 0F 8F, 000011C5
        cmp     eax, 176                                ; 3B8D _ 3D, 000000B0
        jge     ?_0374                                  ; 3B92 _ 0F 8D, 000005AD
        cmp     eax, 175                                ; 3B98 _ 3D, 000000AF
        jg      ?_0462                                  ; 3B9D _ 0F 8F, 000011AF
        cmp     eax, 172                                ; 3BA3 _ 3D, 000000AC
        jge     ?_0373                                  ; 3BA8 _ 0F 8D, 0000058D
        cmp     eax, 168                                ; 3BAE _ 3D, 000000A8
        je      ?_0371                                  ; 3BB3 _ 0F 84, 0000045D
        cmp     eax, 168                                ; 3BB9 _ 3D, 000000A8
        jg      ?_0462                                  ; 3BBE _ 0F 8F, 0000118E
        cmp     eax, 163                                ; 3BC4 _ 3D, 000000A3
        jg      ?_0462                                  ; 3BC9 _ 0F 8F, 00001183
        cmp     eax, 160                                ; 3BCF _ 3D, 000000A0
        jge     ?_0369                                  ; 3BD4 _ 0F 8D, 000003F4
        cmp     eax, 159                                ; 3BDA _ 3D, 0000009F
        jg      ?_0462                                  ; 3BDF _ 0F 8F, 0000116D
        cmp     eax, 128                                ; 3BE5 _ 3D, 00000080
        jge     ?_0455                                  ; 3BEA _ 0F 8D, 00000F91
        cmp     eax, 127                                ; 3BF0 _ 83. F8, 7F
        jg      ?_0462                                  ; 3BF3 _ 0F 8F, 00001159
        cmp     eax, 124                                ; 3BF9 _ 83. F8, 7C
        jge     ?_0368                                  ; 3BFC _ 0F 8D, 000003C2
        cmp     eax, 123                                ; 3C02 _ 83. F8, 7B
        jg      ?_0462                                  ; 3C05 _ 0F 8F, 00001147
        cmp     eax, 122                                ; 3C0B _ 83. F8, 7A
        jge     ?_0367                                  ; 3C0E _ 0F 8D, 000003A1
        cmp     eax, 121                                ; 3C14 _ 83. F8, 79
        je      ?_0366                                  ; 3C17 _ 0F 84, 0000030E
        cmp     eax, 121                                ; 3C1D _ 83. F8, 79
        jg      ?_0462                                  ; 3C20 _ 0F 8F, 0000112C
        cmp     eax, 91                                 ; 3C26 _ 83. F8, 5B
        jg      ?_0462                                  ; 3C29 _ 0F 8F, 00001123
        cmp     eax, 88                                 ; 3C2F _ 83. F8, 58
        jge     ?_0455                                  ; 3C32 _ 0F 8D, 00000F49
        cmp     eax, 83                                 ; 3C38 _ 83. F8, 53
        jg      ?_0462                                  ; 3C3B _ 0F 8F, 00001111
        cmp     eax, 80                                 ; 3C41 _ 83. F8, 50
        jge     ?_0455                                  ; 3C44 _ 0F 8D, 00000F37
        cmp     eax, 75                                 ; 3C4A _ 83. F8, 4B
        jg      ?_0462                                  ; 3C4D _ 0F 8F, 000010FF
        cmp     eax, 72                                 ; 3C53 _ 83. F8, 48
        jge     ?_0455                                  ; 3C56 _ 0F 8D, 00000F25
        cmp     eax, 67                                 ; 3C5C _ 83. F8, 43
        jg      ?_0462                                  ; 3C5F _ 0F 8F, 000010ED
        cmp     eax, 64                                 ; 3C65 _ 83. F8, 40
        jge     ?_0455                                  ; 3C68 _ 0F 8D, 00000F13
        cmp     eax, 63                                 ; 3C6E _ 83. F8, 3F
        jg      ?_0462                                  ; 3C71 _ 0F 8F, 000010DB
        cmp     eax, 60                                 ; 3C77 _ 83. F8, 3C
        jge     ?_0365                                  ; 3C7A _ 0F 8D, 000002A1
        cmp     eax, 59                                 ; 3C80 _ 83. F8, 3B
        jg      ?_0462                                  ; 3C83 _ 0F 8F, 000010C9
        cmp     eax, 56                                 ; 3C89 _ 83. F8, 38
        jge     ?_0364                                  ; 3C8C _ 0F 8D, 00000285
        cmp     eax, 55                                 ; 3C92 _ 83. F8, 37
        jg      ?_0462                                  ; 3C95 _ 0F 8F, 000010B7
        cmp     eax, 52                                 ; 3C9B _ 83. F8, 34
        jge     ?_0358                                  ; 3C9E _ 0F 8D, 00000208
        cmp     eax, 51                                 ; 3CA4 _ 83. F8, 33
        jg      ?_0462                                  ; 3CA7 _ 0F 8F, 000010A5
        cmp     eax, 48                                 ; 3CAD _ 83. F8, 30
        jge     ?_0357                                  ; 3CB0 _ 0F 8D, 000001EC
        cmp     eax, 47                                 ; 3CB6 _ 83. F8, 2F
        jg      ?_0462                                  ; 3CB9 _ 0F 8F, 00001093
        cmp     eax, 44                                 ; 3CBF _ 83. F8, 2C
        jge     ?_0356                                  ; 3CC2 _ 0F 8D, 000001D0
        cmp     eax, 43                                 ; 3CC8 _ 83. F8, 2B
        jg      ?_0462                                  ; 3CCB _ 0F 8F, 00001081
        cmp     eax, 40                                 ; 3CD1 _ 83. F8, 28
        jge     ?_0355                                  ; 3CD4 _ 0F 8D, 000001B4
        cmp     eax, 39                                 ; 3CDA _ 83. F8, 27
        jg      ?_0462                                  ; 3CDD _ 0F 8F, 0000106F
        cmp     eax, 36                                 ; 3CE3 _ 83. F8, 24
        jge     ?_0354                                  ; 3CE6 _ 0F 8D, 00000188
        cmp     eax, 35                                 ; 3CEC _ 83. F8, 23
        jg      ?_0462                                  ; 3CEF _ 0F 8F, 0000105D
        cmp     eax, 32                                 ; 3CF5 _ 83. F8, 20
        jge     ?_0353                                  ; 3CF8 _ 0F 8D, 0000016C
        cmp     eax, 31                                 ; 3CFE _ 83. F8, 1F
        jg      ?_0462                                  ; 3D01 _ 0F 8F, 0000104B
        cmp     eax, 28                                 ; 3D07 _ 83. F8, 1C
        jge     ?_0347                                  ; 3D0A _ 0F 8D, 000000EF
        cmp     eax, 27                                 ; 3D10 _ 83. F8, 1B
        jg      ?_0462                                  ; 3D13 _ 0F 8F, 00001039
        cmp     eax, 24                                 ; 3D19 _ 83. F8, 18
        jge     ?_0346                                  ; 3D1C _ 0F 8D, 000000D3
        cmp     eax, 23                                 ; 3D22 _ 83. F8, 17
        jg      ?_0462                                  ; 3D25 _ 0F 8F, 00001027
        cmp     eax, 16                                 ; 3D2B _ 83. F8, 10
        jge     ?_0345                                  ; 3D2E _ 0F 8D, 000000B7
        cmp     eax, 15                                 ; 3D34 _ 83. F8, 0F
        jg      ?_0462                                  ; 3D37 _ 0F 8F, 00001015
        cmp     eax, 12                                 ; 3D3D _ 83. F8, 0C
        jge     ?_0344                                  ; 3D40 _ 0F 8D, 00000093
        cmp     eax, 11                                 ; 3D46 _ 83. F8, 0B
        jg      ?_0462                                  ; 3D49 _ 0F 8F, 00001003
        cmp     eax, 8                                  ; 3D4F _ 83. F8, 08
        jge     ?_0343                                  ; 3D52 _ 7D, 49
        cmp     eax, 4                                  ; 3D54 _ 83. F8, 04
        jg      ?_0340                                  ; 3D57 _ 7F, 09
        test    eax, eax                                ; 3D59 _ 85. C0
        jg      ?_0341                                  ; 3D5B _ 7F, 13
        jmp     ?_0462                                  ; 3D5D _ E9, 00000FF0

?_0340: sub     eax, 5                                  ; 3D62 _ 83. E8, 05
        cmp     eax, 2                                  ; 3D65 _ 83. F8, 02
        ja      ?_0462                                  ; 3D68 _ 0F 87, 00000FE4
        jmp     ?_0342                                  ; 3D6E _ EB, 1B

?_0341: movzx   eax, byte [rbp-0D1H]                    ; 3D70 _ 0F B6. 85, FFFFFF2F
        add     qword [rbp-70H], rax                    ; 3D77 _ 48: 01. 45, 90
        movzx   eax, byte [rbp-0D1H]                    ; 3D7B _ 0F B6. 85, FFFFFF2F
        add     qword [rbp-68H], rax                    ; 3D82 _ 48: 01. 45, 98
        jmp     ?_0463                                  ; 3D86 _ E9, 00000FEB

?_0342: movzx   eax, byte [rbp-0D1H]                    ; 3D8B _ 0F B6. 85, FFFFFF2F
        mov     byte [rbp-0D4H], al                     ; 3D92 _ 88. 85, FFFFFF2C
        jmp     ?_0463                                  ; 3D98 _ E9, 00000FD9

?_0343: mov     rax, qword [rbp-50H]                    ; 3D9D _ 48: 8B. 45, B0
        mov     esi, 69825                              ; 3DA1 _ BE, 000110C1
        mov     rdi, rax                                ; 3DA6 _ 48: 89. C7
        call    op_rexflags                             ; 3DA9 _ E8, 00003953
        mov     rdx, qword [rbp-0E8H]                   ; 3DAE _ 48: 8B. 95, FFFFFF18
        mov     edx, dword [rdx+84H]                    ; 3DB5 _ 8B. 92, 00000084
        or      edx, eax                                ; 3DBB _ 09. C2
        mov     rax, qword [rbp-0E8H]                   ; 3DBD _ 48: 8B. 85, FFFFFF18
        mov     dword [rax+84H], edx                    ; 3DC4 _ 89. 90, 00000084
        add     qword [rbp-70H], 1                      ; 3DCA _ 48: 83. 45, 90, 01
        add     qword [rbp-68H], 1                      ; 3DCF _ 48: 83. 45, 98, 01
        jmp     ?_0463                                  ; 3DD4 _ E9, 00000F9D

?_0344: mov     rax, qword [rbp-50H]                    ; 3DD9 _ 48: 8B. 45, B0
        mov     eax, dword [rax+10H]                    ; 3DDD _ 8B. 40, 10
        mov     dword [rbp-0CCH], eax                   ; 3DE0 _ 89. 85, FFFFFF34
        jmp     ?_0463                                  ; 3DE6 _ E9, 00000F8B

?_0345: add     qword [rbp-68H], 1                      ; 3DEB _ 48: 83. 45, 98, 01
        jmp     ?_0463                                  ; 3DF0 _ E9, 00000F81

?_0346: add     qword [rbp-68H], 2                      ; 3DF5 _ 48: 83. 45, 98, 02
        jmp     ?_0463                                  ; 3DFA _ E9, 00000F77

?_0347: mov     rax, qword [rbp-50H]                    ; 3DFF _ 48: 8B. 45, B0
        mov     rax, qword [rax]                        ; 3E03 _ 48: 8B. 00
        mov     rdx, qword 0E00000000H                  ; 3E06 _ 48: BA, 0000000E00000000
        and     rax, rdx                                ; 3E10 _ 48: 21. D0
        test    rax, rax                                ; 3E13 _ 48: 85. C0
        jz      ?_0350                                  ; 3E16 _ 74, 2E
        mov     rax, qword [rbp-50H]                    ; 3E18 _ 48: 8B. 45, B0
        mov     rax, qword [rax]                        ; 3E1C _ 48: 8B. 00
        mov     rdx, qword 200000000H                   ; 3E1F _ 48: BA, 0000000200000000
        and     rax, rdx                                ; 3E29 _ 48: 21. D0
        test    rax, rax                                ; 3E2C _ 48: 85. C0
        jz      ?_0348                                  ; 3E2F _ 74, 07
        mov     eax, 2                                  ; 3E31 _ B8, 00000002
        jmp     ?_0349                                  ; 3E36 _ EB, 05

?_0348: mov     eax, 4                                  ; 3E38 _ B8, 00000004
?_0349: add     qword [rbp-68H], rax                    ; 3E3D _ 48: 01. 45, 98
        jmp     ?_0463                                  ; 3E41 _ E9, 00000F30

?_0350: mov     rax, qword [rbp-0E8H]                   ; 3E46 _ 48: 8B. 85, FFFFFF18
        movzx   eax, byte [rax+7BH]                     ; 3E4D _ 0F B6. 40, 7B
        cmp     al, 16                                  ; 3E51 _ 3C, 10
        jnz     ?_0351                                  ; 3E53 _ 75, 07
        mov     eax, 2                                  ; 3E55 _ B8, 00000002
        jmp     ?_0352                                  ; 3E5A _ EB, 05

?_0351: mov     eax, 4                                  ; 3E5C _ B8, 00000004
?_0352: add     qword [rbp-68H], rax                    ; 3E61 _ 48: 01. 45, 98
        jmp     ?_0463                                  ; 3E65 _ E9, 00000F0C

?_0353: add     qword [rbp-68H], 4                      ; 3E6A _ 48: 83. 45, 98, 04
        jmp     ?_0463                                  ; 3E6F _ E9, 00000F02

?_0354: mov     rax, qword [rbp-0E8H]                   ; 3E74 _ 48: 8B. 85, FFFFFF18
        movzx   eax, byte [rax+7CH]                     ; 3E7B _ 0F B6. 40, 7C
        shr     al, 3                                   ; 3E7F _ C0. E8, 03
        movzx   eax, al                                 ; 3E82 _ 0F B6. C0
        add     qword [rbp-68H], rax                    ; 3E85 _ 48: 01. 45, 98
        jmp     ?_0463                                  ; 3E89 _ E9, 00000EE8

?_0355: add     qword [rbp-68H], 1                      ; 3E8E _ 48: 83. 45, 98, 01
        jmp     ?_0463                                  ; 3E93 _ E9, 00000EDE

?_0356: add     qword [rbp-68H], 8                      ; 3E98 _ 48: 83. 45, 98, 08
        jmp     ?_0463                                  ; 3E9D _ E9, 00000ED4

?_0357: add     qword [rbp-68H], 2                      ; 3EA2 _ 48: 83. 45, 98, 02
        jmp     ?_0463                                  ; 3EA7 _ E9, 00000ECA

?_0358: mov     rax, qword [rbp-50H]                    ; 3EAC _ 48: 8B. 45, B0
        mov     rax, qword [rax]                        ; 3EB0 _ 48: 8B. 00
        mov     rdx, qword 0E00000000H                  ; 3EB3 _ 48: BA, 0000000E00000000
        and     rax, rdx                                ; 3EBD _ 48: 21. D0
        test    rax, rax                                ; 3EC0 _ 48: 85. C0
        jz      ?_0361                                  ; 3EC3 _ 74, 2E
        mov     rax, qword [rbp-50H]                    ; 3EC5 _ 48: 8B. 45, B0
        mov     rax, qword [rax]                        ; 3EC9 _ 48: 8B. 00
        mov     rdx, qword 200000000H                   ; 3ECC _ 48: BA, 0000000200000000
        and     rax, rdx                                ; 3ED6 _ 48: 21. D0
        test    rax, rax                                ; 3ED9 _ 48: 85. C0
        jz      ?_0359                                  ; 3EDC _ 74, 07
        mov     eax, 2                                  ; 3EDE _ B8, 00000002
        jmp     ?_0360                                  ; 3EE3 _ EB, 05

?_0359: mov     eax, 4                                  ; 3EE5 _ B8, 00000004
?_0360: add     qword [rbp-68H], rax                    ; 3EEA _ 48: 01. 45, 98
        jmp     ?_0463                                  ; 3EEE _ E9, 00000E83

?_0361: mov     rax, qword [rbp-0E8H]                   ; 3EF3 _ 48: 8B. 85, FFFFFF18
        movzx   eax, byte [rax+7BH]                     ; 3EFA _ 0F B6. 40, 7B
        cmp     al, 16                                  ; 3EFE _ 3C, 10
        jnz     ?_0362                                  ; 3F00 _ 75, 07
        mov     eax, 2                                  ; 3F02 _ B8, 00000002
        jmp     ?_0363                                  ; 3F07 _ EB, 05

?_0362: mov     eax, 4                                  ; 3F09 _ B8, 00000004
?_0363: add     qword [rbp-68H], rax                    ; 3F0E _ 48: 01. 45, 98
        jmp     ?_0463                                  ; 3F12 _ E9, 00000E5F

?_0364: add     qword [rbp-68H], 4                      ; 3F17 _ 48: 83. 45, 98, 04
        jmp     ?_0463                                  ; 3F1C _ E9, 00000E55

?_0365: add     qword [rbp-68H], 2                      ; 3F21 _ 48: 83. 45, 98, 02
        jmp     ?_0463                                  ; 3F26 _ E9, 00000E4B

?_0366: mov     rax, qword [rbp-70H]                    ; 3F2B _ 48: 8B. 45, 90
        lea     rdx, [rax+1H]                           ; 3F2F _ 48: 8D. 50, 01
        mov     qword [rbp-70H], rdx                    ; 3F33 _ 48: 89. 55, 90
        movzx   eax, byte [rax]                         ; 3F37 _ 0F B6. 00
        mov     byte [rbp-0D1H], al                     ; 3F3A _ 88. 85, FFFFFF2F
        mov     eax, dword [rbp-0A8H]                   ; 3F40 _ 8B. 85, FFFFFF58
        and     eax, 0FFFFFFFCH                         ; 3F46 _ 83. E0, FC
        mov     edx, eax                                ; 3F49 _ 89. C2
        movzx   eax, byte [rbp-0D1H]                    ; 3F4B _ 0F B6. 85, FFFFFF2F
        shr     al, 3                                   ; 3F52 _ C0. E8, 03
        movzx   eax, al                                 ; 3F55 _ 0F B6. C0
        and     eax, 03H                                ; 3F58 _ 83. E0, 03
        or      eax, edx                                ; 3F5B _ 09. D0
        mov     dword [rbp-0A8H], eax                   ; 3F5D _ 89. 85, FFFFFF58
        mov     edx, dword [rbp-0A8H]                   ; 3F63 _ 8B. 95, FFFFFF58
        mov     rax, qword [rbp-0E8H]                   ; 3F69 _ 48: 8B. 85, FFFFFF18
        mov     esi, edx                                ; 3F70 _ 89. D6
        mov     rdi, rax                                ; 3F72 _ 48: 89. C7
        call    get_operand                             ; 3F75 _ E8, FFFFC877
        mov     qword [rbp-48H], rax                    ; 3F7A _ 48: 89. 45, B8
        mov     rax, qword [rbp-48H]                    ; 3F7E _ 48: 8B. 45, B8
        mov     esi, 278724                             ; 3F82 _ BE, 000440C4
        mov     rdi, rax                                ; 3F87 _ 48: 89. C7
        call    op_rexflags                             ; 3F8A _ E8, 00003772
        mov     rdx, qword [rbp-0E8H]                   ; 3F8F _ 48: 8B. 95, FFFFFF18
        mov     edx, dword [rdx+84H]                    ; 3F96 _ 8B. 92, 00000084
        or      edx, eax                                ; 3F9C _ 09. C2
        mov     rax, qword [rbp-0E8H]                   ; 3F9E _ 48: 8B. 85, FFFFFF18
        mov     dword [rax+84H], edx                    ; 3FA5 _ 89. 90, 00000084
        add     qword [rbp-68H], 1                      ; 3FAB _ 48: 83. 45, 98, 01
        jmp     ?_0463                                  ; 3FB0 _ E9, 00000DC1

?_0367: add     qword [rbp-70H], 1                      ; 3FB5 _ 48: 83. 45, 90, 01
        add     qword [rbp-68H], 1                      ; 3FBA _ 48: 83. 45, 98, 01
        jmp     ?_0463                                  ; 3FBF _ E9, 00000DB2

?_0368: add     qword [rbp-68H], 1                      ; 3FC4 _ 48: 83. 45, 98, 01
        jmp     ?_0463                                  ; 3FC9 _ E9, 00000DA8

?_0369: mov     rax, qword [rbp-50H]                    ; 3FCE _ 48: 8B. 45, B0
        mov     rax, qword [rax]                        ; 3FD2 _ 48: 8B. 00
        mov     esi, 2                                  ; 3FD5 _ BE, 00000002
        mov     rdi, rax                                ; 3FDA _ 48: 89. C7
        call    is_class                                ; 3FDD _ E8, FFFFC17A
        test    al, al                                  ; 3FE2 _ 84. C0
        jz      ?_0370                                  ; 3FE4 _ 74, 16
        mov     rax, qword [rbp-50H]                    ; 3FE6 _ 48: 8B. 45, B0
        mov     rax, qword [rax+28H]                    ; 3FEA _ 48: 8B. 40, 28
        mov     edx, eax                                ; 3FEE _ 89. C2
        mov     rax, qword [rbp-0E8H]                   ; 3FF0 _ 48: 8B. 85, FFFFFF18
        mov     byte [rax+7FH], dl                      ; 3FF7 _ 88. 50, 7F
        jmp     ?_0372                                  ; 3FFA _ EB, 26

?_0370: mov     rax, qword [rbp-50H]                    ; 3FFC _ 48: 8B. 45, B0
        mov     rdi, rax                                ; 4000 _ 48: 89. C7
        call    regval                                  ; 4003 _ E8, 0000368E
        mov     edx, eax                                ; 4008 _ 89. C2
        mov     rax, qword [rbp-0E8H]                   ; 400A _ 48: 8B. 85, FFFFFF18
        mov     byte [rax+7EH], dl                      ; 4011 _ 88. 50, 7E
        jmp     ?_0372                                  ; 4014 _ EB, 0C

?_0371: mov     rax, qword [rbp-0E8H]                   ; 4016 _ 48: 8B. 85, FFFFFF18
        mov     byte [rax+7EH], 0                       ; 401D _ C6. 40, 7E, 00
        nop                                             ; 4021 _ 90
?_0372: mov     rax, qword [rbp-0E8H]                   ; 4022 _ 48: 8B. 85, FFFFFF18
        mov     eax, dword [rax+84H]                    ; 4029 _ 8B. 80, 00000084
        or      ah, 04H                                 ; 402F _ 80. CC, 04
        mov     edx, eax                                ; 4032 _ 89. C2
        mov     rax, qword [rbp-0E8H]                   ; 4034 _ 48: 8B. 85, FFFFFF18
        mov     dword [rax+84H], edx                    ; 403B _ 89. 90, 00000084
        mov     rax, qword [rbp-0E8H]                   ; 4041 _ 48: 8B. 85, FFFFFF18
        mov     dword [rax+88H], 98                     ; 4048 _ C7. 80, 00000088, 00000062
        mov     rax, qword [rbp-70H]                    ; 4052 _ 48: 8B. 45, 90
        lea     rdx, [rax+1H]                           ; 4056 _ 48: 8D. 50, 01
        mov     qword [rbp-70H], rdx                    ; 405A _ 48: 89. 55, 90
        movzx   eax, byte [rax]                         ; 405E _ 0F B6. 00
        movzx   eax, al                                 ; 4061 _ 0F B6. C0
        shl     eax, 8                                  ; 4064 _ C1. E0, 08
        mov     edx, eax                                ; 4067 _ 89. C2
        mov     rax, qword [rbp-0E8H]                   ; 4069 _ 48: 8B. 85, FFFFFF18
        mov     eax, dword [rax+88H]                    ; 4070 _ 8B. 80, 00000088
        add     edx, eax                                ; 4076 _ 01. C2
        mov     rax, qword [rbp-0E8H]                   ; 4078 _ 48: 8B. 85, FFFFFF18
        mov     dword [rax+88H], edx                    ; 407F _ 89. 90, 00000088
        mov     rax, qword [rbp-70H]                    ; 4085 _ 48: 8B. 45, 90
        lea     rdx, [rax+1H]                           ; 4089 _ 48: 8D. 50, 01
        mov     qword [rbp-70H], rdx                    ; 408D _ 48: 89. 55, 90
        movzx   eax, byte [rax]                         ; 4091 _ 0F B6. 00
        movzx   eax, al                                 ; 4094 _ 0F B6. C0
        shl     eax, 16                                 ; 4097 _ C1. E0, 10
        mov     edx, eax                                ; 409A _ 89. C2
        mov     rax, qword [rbp-0E8H]                   ; 409C _ 48: 8B. 85, FFFFFF18
        mov     eax, dword [rax+88H]                    ; 40A3 _ 8B. 80, 00000088
        add     edx, eax                                ; 40A9 _ 01. C2
        mov     rax, qword [rbp-0E8H]                   ; 40AB _ 48: 8B. 85, FFFFFF18
        mov     dword [rax+88H], edx                    ; 40B2 _ 89. 90, 00000088
        mov     rax, qword [rbp-70H]                    ; 40B8 _ 48: 8B. 45, 90
        lea     rdx, [rax+1H]                           ; 40BC _ 48: 8D. 50, 01
        mov     qword [rbp-70H], rdx                    ; 40C0 _ 48: 89. 55, 90
        movzx   eax, byte [rax]                         ; 40C4 _ 0F B6. 00
        movzx   eax, al                                 ; 40C7 _ 0F B6. C0
        shl     eax, 24                                 ; 40CA _ C1. E0, 18
        mov     edx, eax                                ; 40CD _ 89. C2
        mov     rax, qword [rbp-0E8H]                   ; 40CF _ 48: 8B. 85, FFFFFF18
        mov     eax, dword [rax+88H]                    ; 40D6 _ 8B. 80, 00000088
        add     edx, eax                                ; 40DC _ 01. C2
        mov     rax, qword [rbp-0E8H]                   ; 40DE _ 48: 8B. 85, FFFFFF18
        mov     dword [rax+88H], edx                    ; 40E5 _ 89. 90, 00000088
        mov     rax, qword [rbp-70H]                    ; 40EB _ 48: 8B. 45, 90
        lea     rdx, [rax+1H]                           ; 40EF _ 48: 8D. 50, 01
        mov     qword [rbp-70H], rdx                    ; 40F3 _ 48: 89. 55, 90
        movzx   eax, byte [rax]                         ; 40F7 _ 0F B6. 00
        movzx   eax, al                                 ; 40FA _ 0F B6. C0
        sub     eax, 192                                ; 40FD _ 2D, 000000C0
        mov     edx, eax                                ; 4102 _ 89. C2
        mov     rax, qword [rbp-0E8H]                   ; 4104 _ 48: 8B. 85, FFFFFF18
        mov     dword [rax+8CH], edx                    ; 410B _ 89. 90, 0000008C
        mov     rax, qword [rbp-0E8H]                   ; 4111 _ 48: 8B. 85, FFFFFF18
        mov     eax, dword [rax+88H]                    ; 4118 _ 8B. 80, 00000088
        shr     eax, 8                                  ; 411E _ C1. E8, 08
        and     eax, 07H                                ; 4121 _ 83. E0, 07
        or      eax, 0FFFFFF80H                         ; 4124 _ 83. C8, 80
        mov     edx, eax                                ; 4127 _ 89. C2
        mov     rax, qword [rbp-0E8H]                   ; 4129 _ 48: 8B. 85, FFFFFF18
        mov     byte [rax+80H], dl                      ; 4130 _ 88. 90, 00000080
        jmp     ?_0463                                  ; 4136 _ E9, 00000C3B

?_0373: add     qword [rbp-68H], 4                      ; 413B _ 48: 83. 45, 98, 04
        jmp     ?_0463                                  ; 4140 _ E9, 00000C31

?_0374: mov     rax, qword [rbp-50H]                    ; 4145 _ 48: 8B. 45, B0
        mov     rax, qword [rax]                        ; 4149 _ 48: 8B. 00
        mov     esi, 2                                  ; 414C _ BE, 00000002
        mov     rdi, rax                                ; 4151 _ 48: 89. C7
        call    is_class                                ; 4154 _ E8, FFFFC003
        test    al, al                                  ; 4159 _ 84. C0
        jz      ?_0375                                  ; 415B _ 74, 16
        mov     rax, qword [rbp-50H]                    ; 415D _ 48: 8B. 45, B0
        mov     rax, qword [rax+28H]                    ; 4161 _ 48: 8B. 40, 28
        mov     edx, eax                                ; 4165 _ 89. C2
        mov     rax, qword [rbp-0E8H]                   ; 4167 _ 48: 8B. 85, FFFFFF18
        mov     byte [rax+7FH], dl                      ; 416E _ 88. 50, 7F
        jmp     ?_0377                                  ; 4171 _ EB, 26

?_0375: mov     rax, qword [rbp-50H]                    ; 4173 _ 48: 8B. 45, B0
        mov     rdi, rax                                ; 4177 _ 48: 89. C7
        call    regval                                  ; 417A _ E8, 00003517
        mov     edx, eax                                ; 417F _ 89. C2
        mov     rax, qword [rbp-0E8H]                   ; 4181 _ 48: 8B. 85, FFFFFF18
        mov     byte [rax+7EH], dl                      ; 4188 _ 88. 50, 7E
        jmp     ?_0377                                  ; 418B _ EB, 0C

?_0376: mov     rax, qword [rbp-0E8H]                   ; 418D _ 48: 8B. 85, FFFFFF18
        mov     byte [rax+7EH], 0                       ; 4194 _ C6. 40, 7E, 00
        nop                                             ; 4198 _ 90
?_0377: mov     rax, qword [rbp-0E8H]                   ; 4199 _ 48: 8B. 85, FFFFFF18
        mov     eax, dword [rax+84H]                    ; 41A0 _ 8B. 80, 00000084
        or      ah, 01H                                 ; 41A6 _ 80. CC, 01
        mov     edx, eax                                ; 41A9 _ 89. C2
        mov     rax, qword [rbp-0E8H]                   ; 41AB _ 48: 8B. 85, FFFFFF18
        mov     dword [rax+84H], edx                    ; 41B2 _ 89. 90, 00000084
        mov     rax, qword [rbp-70H]                    ; 41B8 _ 48: 8B. 45, 90
        lea     rdx, [rax+1H]                           ; 41BC _ 48: 8D. 50, 01
        mov     qword [rbp-70H], rdx                    ; 41C0 _ 48: 89. 55, 90
        movzx   edx, byte [rax]                         ; 41C4 _ 0F B6. 10
        mov     rax, qword [rbp-0E8H]                   ; 41C7 _ 48: 8B. 85, FFFFFF18
        mov     byte [rax+80H], dl                      ; 41CE _ 88. 90, 00000080
        mov     rax, qword [rbp-70H]                    ; 41D4 _ 48: 8B. 45, 90
        lea     rdx, [rax+1H]                           ; 41D8 _ 48: 8D. 50, 01
        mov     qword [rbp-70H], rdx                    ; 41DC _ 48: 89. 55, 90
        movzx   edx, byte [rax]                         ; 41E0 _ 0F B6. 10
        mov     rax, qword [rbp-0E8H]                   ; 41E3 _ 48: 8B. 85, FFFFFF18
        mov     byte [rax+81H], dl                      ; 41EA _ 88. 90, 00000081
        jmp     ?_0463                                  ; 41F0 _ E9, 00000B81

?_0378: movzx   eax, byte [rbp-0D1H]                    ; 41F5 _ 0F B6. 85, FFFFFF2F
        and     eax, 03H                                ; 41FC _ 83. E0, 03
        mov     byte [rbp-0D3H], al                     ; 41FF _ 88. 85, FFFFFF2D
        jmp     ?_0463                                  ; 4205 _ E9, 00000B6C

?_0379: add     qword [rbp-68H], 1                      ; 420A _ 48: 83. 45, 98, 01
        jmp     ?_0463                                  ; 420F _ E9, 00000B62

?_0380: add     qword [rbp-68H], 1                      ; 4214 _ 48: 83. 45, 98, 01
        jmp     ?_0463                                  ; 4219 _ E9, 00000B58

?_0381: add     qword [rbp-68H], 1                      ; 421E _ 48: 83. 45, 98, 01
        add     qword [rbp-70H], 2                      ; 4223 _ 48: 83. 45, 90, 02
        jmp     ?_0463                                  ; 4228 _ E9, 00000B49

?_0382: mov     rax, qword [rbp-0E8H]                   ; 422D _ 48: 8B. 85, FFFFFF18
        mov     eax, dword [rax+20H]                    ; 4234 _ 8B. 40, 20
        mov     dword [rbp-7CH], eax                    ; 4237 _ 89. 45, 84
        mov     rax, qword [rbp-0E8H]                   ; 423A _ 48: 8B. 85, FFFFFF18
        mov     byte [rax+7CH], 16                      ; 4241 _ C6. 40, 7C, 10
        cmp     dword [rbp-0BCH], 64                    ; 4245 _ 83. BD, FFFFFF44, 40
        jnz     ?_0383                                  ; 424C _ 75, 0C
        mov     rax, -1                                 ; 424E _ 48: C7. C0, FFFFFFFF
        jmp     ?_0516                                  ; 4255 _ E9, 00001442

?_0383: cmp     dword [rbp-7CH], 0                      ; 425A _ 83. 7D, 84, 00
        jz      ?_0385                                  ; 425E _ 74, 2F
        cmp     dword [rbp-7CH], 345                    ; 4260 _ 81. 7D, 84, 00000159
        je      ?_0463                                  ; 4267 _ 0F 84, 00000B09
        cmp     dword [rbp-0BCH], 32                    ; 426D _ 83. BD, FFFFFF44, 20
        jnz     ?_0384                                  ; 4274 _ 75, 0D
        cmp     dword [rbp-7CH], 348                    ; 4276 _ 81. 7D, 84, 0000015C
        je      ?_0463                                  ; 427D _ 0F 84, 00000AF3
?_0384: mov     rax, -1                                 ; 4283 _ 48: C7. C0, FFFFFFFF
        jmp     ?_0516                                  ; 428A _ E9, 0000140D

?_0385: mov     rax, qword [rbp-0E8H]                   ; 428F _ 48: 8B. 85, FFFFFF18
        mov     dword [rax+20H], 345                    ; 4296 _ C7. 40, 20, 00000159
        jmp     ?_0463                                  ; 429D _ E9, 00000AD4

?_0386: mov     rax, qword [rbp-0E8H]                   ; 42A2 _ 48: 8B. 85, FFFFFF18
        mov     eax, dword [rax+20H]                    ; 42A9 _ 8B. 40, 20
        mov     dword [rbp-80H], eax                    ; 42AC _ 89. 45, 80
        mov     rax, qword [rbp-0E8H]                   ; 42AF _ 48: 8B. 85, FFFFFF18
        mov     byte [rax+7CH], 32                      ; 42B6 _ C6. 40, 7C, 20
        cmp     dword [rbp-80H], 0                      ; 42BA _ 83. 7D, 80, 00
        jz      ?_0388                                  ; 42BE _ 74, 2F
        cmp     dword [rbp-80H], 346                    ; 42C0 _ 81. 7D, 80, 0000015A
        je      ?_0463                                  ; 42C7 _ 0F 84, 00000AA9
        cmp     dword [rbp-0BCH], 32                    ; 42CD _ 83. BD, FFFFFF44, 20
        jz      ?_0387                                  ; 42D4 _ 74, 0D
        cmp     dword [rbp-80H], 348                    ; 42D6 _ 81. 7D, 80, 0000015C
        je      ?_0463                                  ; 42DD _ 0F 84, 00000A93
?_0387: mov     rax, -1                                 ; 42E3 _ 48: C7. C0, FFFFFFFF
        jmp     ?_0516                                  ; 42EA _ E9, 000013AD

?_0388: mov     rax, qword [rbp-0E8H]                   ; 42EF _ 48: 8B. 85, FFFFFF18
        mov     dword [rax+20H], 346                    ; 42F6 _ C7. 40, 20, 0000015A
        jmp     ?_0463                                  ; 42FD _ E9, 00000A74

?_0389: mov     rax, qword [rbp-0E8H]                   ; 4302 _ 48: 8B. 85, FFFFFF18
        mov     eax, dword [rax+20H]                    ; 4309 _ 8B. 40, 20
        mov     dword [rbp-84H], eax                    ; 430C _ 89. 85, FFFFFF7C
        mov     rax, qword [rbp-0E8H]                   ; 4312 _ 48: 8B. 85, FFFFFF18
        mov     byte [rax+7CH], 64                      ; 4319 _ C6. 40, 7C, 40
        cmp     dword [rbp-0BCH], 64                    ; 431D _ 83. BD, FFFFFF44, 40
        jnz     ?_0390                                  ; 4324 _ 75, 15
        cmp     dword [rbp-84H], 0                      ; 4326 _ 83. BD, FFFFFF7C, 00
        jz      ?_0391                                  ; 432D _ 74, 18
        cmp     dword [rbp-84H], 347                    ; 432F _ 81. BD, FFFFFF7C, 0000015B
        jz      ?_0391                                  ; 4339 _ 74, 0C
?_0390: mov     rax, -1                                 ; 433B _ 48: C7. C0, FFFFFFFF
        jmp     ?_0516                                  ; 4342 _ E9, 00001355

?_0391: mov     rax, qword [rbp-0E8H]                   ; 4347 _ 48: 8B. 85, FFFFFF18
        mov     dword [rax+20H], 347                    ; 434E _ C7. 40, 20, 0000015B
        jmp     ?_0463                                  ; 4355 _ E9, 00000A1C

?_0392: nop                                             ; 435A _ 90
        jmp     ?_0396                                  ; 435B _ EB, 07

?_0393: nop                                             ; 435D _ 90
        jmp     ?_0396                                  ; 435E _ EB, 04

?_0394: nop                                             ; 4360 _ 90
        jmp     ?_0396                                  ; 4361 _ EB, 01

?_0395: nop                                             ; 4363 _ 90
?_0396: mov     rax, qword [rbp-0E8H]                   ; 4364 _ 48: 8B. 85, FFFFFF18
        mov     eax, dword [rax+28H]                    ; 436B _ 8B. 40, 28
        mov     dword [rbp-8CH], eax                    ; 436E _ 89. 85, FFFFFF74
        mov     rax, qword [rbp-0E8H]                   ; 4374 _ 48: 8B. 85, FFFFFF18
        mov     byte [rax+7BH], 16                      ; 437B _ C6. 40, 7B, 10
        cmp     dword [rbp-0BCH], 16                    ; 437F _ 83. BD, FFFFFF44, 10
        jz      ?_0397                                  ; 4386 _ 74, 10
        cmp     dword [rbp-8CH], 353                    ; 4388 _ 81. BD, FFFFFF74, 00000161
        je      ?_0400                                  ; 4392 _ 0F 84, 00000087
?_0397: cmp     dword [rbp-8CH], 0                      ; 4398 _ 83. BD, FFFFFF74, 00
        jz      ?_0398                                  ; 439F _ 74, 59
        cmp     dword [rbp-8CH], 350                    ; 43A1 _ 81. BD, FFFFFF74, 0000015E
        jz      ?_0398                                  ; 43AB _ 74, 4D
        mov     dword [rbp-88H], 3276800                ; 43AD _ C7. 85, FFFFFF78, 00320000
        mov     eax, dword [rbp-88H]                    ; 43B7 _ 8B. 85, FFFFFF78
        mov     edi, eax                                ; 43BD _ 89. C7
        call    warn_active                             ; 43BF _ E8, FFFFBE8F
        movzx   eax, al                                 ; 43C4 _ 0F B6. C0
        test    rax, rax                                ; 43C7 _ 48: 85. C0
        jz      ?_0399                                  ; 43CA _ 74, 52
        mov     eax, dword [rbp-8CH]                    ; 43CC _ 8B. 85, FFFFFF74
        mov     edi, eax                                ; 43D2 _ 89. C7
        call    prefix_name                             ; 43D4 _ E8, 00000000(PLT r)
        mov     rdx, rax                                ; 43D9 _ 48: 89. C2
        lea     rcx, [rel ?_1069]                       ; 43DC _ 48: 8D. 0D, 00000000(rel)
        mov     eax, dword [rbp-88H]                    ; 43E3 _ 8B. 85, FFFFFF78
        mov     rsi, rcx                                ; 43E9 _ 48: 89. CE
        mov     edi, eax                                ; 43EC _ 89. C7
        mov     eax, 0                                  ; 43EE _ B8, 00000000
        call    nasm_warn_                              ; 43F3 _ E8, 00000000(PLT r)
        jmp     ?_0399                                  ; 43F8 _ EB, 24

?_0398: mov     eax, dword [rbp-0C8H]                   ; 43FA _ 8B. 85, FFFFFF38
        and     eax, 10H                                ; 4400 _ 83. E0, 10
        test    eax, eax                                ; 4403 _ 85. C0
        jne     ?_0463                                  ; 4405 _ 0F 85, 0000096B
        mov     rax, qword [rbp-0E8H]                   ; 440B _ 48: 8B. 85, FFFFFF18
        mov     dword [rax+28H], 350                    ; 4412 _ C7. 40, 28, 0000015E
        jmp     ?_0463                                  ; 4419 _ E9, 00000958

?_0399: nop                                             ; 441E _ 90
?_0400: jmp     ?_0463                                  ; 441F _ E9, 00000952

?_0401: nop                                             ; 4424 _ 90
        jmp     ?_0404                                  ; 4425 _ EB, 04

?_0402: nop                                             ; 4427 _ 90
        jmp     ?_0404                                  ; 4428 _ EB, 01

?_0403: nop                                             ; 442A _ 90
?_0404: mov     rax, qword [rbp-0E8H]                   ; 442B _ 48: 8B. 85, FFFFFF18
        mov     eax, dword [rax+28H]                    ; 4432 _ 8B. 40, 28
        mov     dword [rbp-94H], eax                    ; 4435 _ 89. 85, FFFFFF6C
        mov     rax, qword [rbp-0E8H]                   ; 443B _ 48: 8B. 85, FFFFFF18
        mov     byte [rax+7BH], 32                      ; 4442 _ C6. 40, 7B, 20
        mov     rax, qword [rbp-0E8H]                   ; 4446 _ 48: 8B. 85, FFFFFF18
        mov     eax, dword [rax+84H]                    ; 444D _ 8B. 80, 00000084
        and     eax, 8000H                              ; 4453 _ 25, 00008000
        test    eax, eax                                ; 4458 _ 85. C0
        jz      ?_0405                                  ; 445A _ 74, 25
        lea     rax, [rel ?_1070]                       ; 445C _ 48: 8D. 05, 00000000(rel)
        mov     rsi, rax                                ; 4463 _ 48: 89. C6
        mov     edi, 256                                ; 4466 _ BF, 00000100
        mov     eax, 0                                  ; 446B _ B8, 00000000
        call    nasm_nonfatalf                          ; 4470 _ E8, 00000000(PLT r)
        mov     rax, -1                                 ; 4475 _ 48: C7. C0, FFFFFFFF
        jmp     ?_0516                                  ; 447C _ E9, 0000121B

?_0405: cmp     dword [rbp-0BCH], 16                    ; 4481 _ 83. BD, FFFFFF44, 10
        jnz     ?_0406                                  ; 4488 _ 75, 10
        cmp     dword [rbp-94H], 353                    ; 448A _ 81. BD, FFFFFF6C, 00000161
        je      ?_0409                                  ; 4494 _ 0F 84, 00000087
?_0406: cmp     dword [rbp-94H], 0                      ; 449A _ 83. BD, FFFFFF6C, 00
        jz      ?_0407                                  ; 44A1 _ 74, 59
        cmp     dword [rbp-94H], 351                    ; 44A3 _ 81. BD, FFFFFF6C, 0000015F
        jz      ?_0407                                  ; 44AD _ 74, 4D
        mov     dword [rbp-90H], 3276800                ; 44AF _ C7. 85, FFFFFF70, 00320000
        mov     eax, dword [rbp-90H]                    ; 44B9 _ 8B. 85, FFFFFF70
        mov     edi, eax                                ; 44BF _ 89. C7
        call    warn_active                             ; 44C1 _ E8, FFFFBD8D
        movzx   eax, al                                 ; 44C6 _ 0F B6. C0
        test    rax, rax                                ; 44C9 _ 48: 85. C0
        jz      ?_0408                                  ; 44CC _ 74, 52
        mov     eax, dword [rbp-94H]                    ; 44CE _ 8B. 85, FFFFFF6C
        mov     edi, eax                                ; 44D4 _ 89. C7
        call    prefix_name                             ; 44D6 _ E8, 00000000(PLT r)
        mov     rdx, rax                                ; 44DB _ 48: 89. C2
        lea     rcx, [rel ?_1071]                       ; 44DE _ 48: 8D. 0D, 00000000(rel)
        mov     eax, dword [rbp-90H]                    ; 44E5 _ 8B. 85, FFFFFF70
        mov     rsi, rcx                                ; 44EB _ 48: 89. CE
        mov     edi, eax                                ; 44EE _ 89. C7
        mov     eax, 0                                  ; 44F0 _ B8, 00000000
        call    nasm_warn_                              ; 44F5 _ E8, 00000000(PLT r)
        jmp     ?_0408                                  ; 44FA _ EB, 24

?_0407: mov     eax, dword [rbp-0C8H]                   ; 44FC _ 8B. 85, FFFFFF38
        and     eax, 20H                                ; 4502 _ 83. E0, 20
        test    eax, eax                                ; 4505 _ 85. C0
        jne     ?_0463                                  ; 4507 _ 0F 85, 00000869
        mov     rax, qword [rbp-0E8H]                   ; 450D _ 48: 8B. 85, FFFFFF18
        mov     dword [rax+28H], 351                    ; 4514 _ C7. 40, 28, 0000015F
        jmp     ?_0463                                  ; 451B _ E9, 00000856

?_0408: nop                                             ; 4520 _ 90
?_0409: jmp     ?_0463                                  ; 4521 _ E9, 00000850

?_0410: cmp     dword [rbp-0BCH], 64                    ; 4526 _ 83. BD, FFFFFF44, 40
        jne     ?_0463                                  ; 452D _ 0F 85, 00000843
        mov     rax, qword [rbp-0E8H]                   ; 4533 _ 48: 8B. 85, FFFFFF18
        mov     eax, dword [rax+84H]                    ; 453A _ 8B. 80, 00000084
        or      ah, 80H                                 ; 4540 _ 80. CC, 80
        mov     edx, eax                                ; 4543 _ 89. C2
        mov     rax, qword [rbp-0E8H]                   ; 4545 _ 48: 8B. 85, FFFFFF18
        mov     dword [rax+84H], edx                    ; 454C _ 89. 90, 00000084
        mov     rax, qword [rbp-0E8H]                   ; 4552 _ 48: 8B. 85, FFFFFF18
        movzx   eax, byte [rax+7BH]                     ; 4559 _ 0F B6. 40, 7B
        cmp     al, 32                                  ; 455D _ 3C, 20
        jne     ?_0463                                  ; 455F _ 0F 85, 00000811
        mov     rax, qword [rbp-0E8H]                   ; 4565 _ 48: 8B. 85, FFFFFF18
        mov     byte [rax+7BH], 64                      ; 456C _ C6. 40, 7B, 40
        jmp     ?_0463                                  ; 4570 _ E9, 00000801

?_0411: mov     rax, qword [rbp-0E8H]                   ; 4575 _ 48: 8B. 85, FFFFFF18
        mov     eax, dword [rax+84H]                    ; 457C _ 8B. 80, 00000084
        or      ah, 80H                                 ; 4582 _ 80. CC, 80
        mov     edx, eax                                ; 4585 _ 89. C2
        mov     rax, qword [rbp-0E8H]                   ; 4587 _ 48: 8B. 85, FFFFFF18
        mov     dword [rax+84H], edx                    ; 458E _ 89. 90, 00000084
        jmp     ?_0415                                  ; 4594 _ EB, 07

?_0412: nop                                             ; 4596 _ 90
        jmp     ?_0415                                  ; 4597 _ EB, 04

?_0413: nop                                             ; 4599 _ 90
        jmp     ?_0415                                  ; 459A _ EB, 01

?_0414: nop                                             ; 459C _ 90
?_0415: mov     rax, qword [rbp-0E8H]                   ; 459D _ 48: 8B. 85, FFFFFF18
        mov     eax, dword [rax+28H]                    ; 45A4 _ 8B. 40, 28
        mov     dword [rbp-9CH], eax                    ; 45A7 _ 89. 85, FFFFFF64
        mov     rax, qword [rbp-0E8H]                   ; 45AD _ 48: 8B. 85, FFFFFF18
        mov     byte [rax+7BH], 64                      ; 45B4 _ C6. 40, 7B, 40
        cmp     dword [rbp-9CH], 353                    ; 45B8 _ 81. BD, FFFFFF64, 00000161
        jnz     ?_0416                                  ; 45C2 _ 75, 3E
        mov     rax, qword [rbp-0E8H]                   ; 45C4 _ 48: 8B. 85, FFFFFF18
        mov     eax, dword [rax+84H]                    ; 45CB _ 8B. 80, 00000084
        and     eax, 8000H                              ; 45D1 _ 25, 00008000
        test    eax, eax                                ; 45D6 _ 85. C0
        jne     ?_0463                                  ; 45D8 _ 0F 85, 00000798
        mov     rax, qword [rbp-0E8H]                   ; 45DE _ 48: 8B. 85, FFFFFF18
        mov     eax, dword [rax+84H]                    ; 45E5 _ 8B. 80, 00000084
        or      eax, 08H                                ; 45EB _ 83. C8, 08
        mov     edx, eax                                ; 45EE _ 89. C2
        mov     rax, qword [rbp-0E8H]                   ; 45F0 _ 48: 8B. 85, FFFFFF18
        mov     dword [rax+84H], edx                    ; 45F7 _ 89. 90, 00000084
        jmp     ?_0463                                  ; 45FD _ E9, 00000774

?_0416: cmp     dword [rbp-9CH], 0                      ; 4602 _ 83. BD, FFFFFF64, 00
        jz      ?_0417                                  ; 4609 _ 74, 59
        cmp     dword [rbp-9CH], 352                    ; 460B _ 81. BD, FFFFFF64, 00000160
        jz      ?_0417                                  ; 4615 _ 74, 4D
        mov     dword [rbp-98H], 3276800                ; 4617 _ C7. 85, FFFFFF68, 00320000
        mov     eax, dword [rbp-98H]                    ; 4621 _ 8B. 85, FFFFFF68
        mov     edi, eax                                ; 4627 _ 89. C7
        call    warn_active                             ; 4629 _ E8, FFFFBC25
        movzx   eax, al                                 ; 462E _ 0F B6. C0
        test    rax, rax                                ; 4631 _ 48: 85. C0
        jz      ?_0418                                  ; 4634 _ 74, 52
        mov     eax, dword [rbp-9CH]                    ; 4636 _ 8B. 85, FFFFFF64
        mov     edi, eax                                ; 463C _ 89. C7
        call    prefix_name                             ; 463E _ E8, 00000000(PLT r)
        mov     rdx, rax                                ; 4643 _ 48: 89. C2
        lea     rcx, [rel ?_1072]                       ; 4646 _ 48: 8D. 0D, 00000000(rel)
        mov     eax, dword [rbp-98H]                    ; 464D _ 8B. 85, FFFFFF68
        mov     rsi, rcx                                ; 4653 _ 48: 89. CE
        mov     edi, eax                                ; 4656 _ 89. C7
        mov     eax, 0                                  ; 4658 _ B8, 00000000
        call    nasm_warn_                              ; 465D _ E8, 00000000(PLT r)
        jmp     ?_0418                                  ; 4662 _ EB, 24

?_0417: mov     eax, dword [rbp-0C8H]                   ; 4664 _ 8B. 85, FFFFFF38
        and     eax, 40H                                ; 466A _ 83. E0, 40
        test    eax, eax                                ; 466D _ 85. C0
        jne     ?_0463                                  ; 466F _ 0F 85, 00000701
        mov     rax, qword [rbp-0E8H]                   ; 4675 _ 48: 8B. 85, FFFFFF18
        mov     dword [rax+28H], 352                    ; 467C _ C7. 40, 28, 00000160
        jmp     ?_0463                                  ; 4683 _ E9, 000006EE

?_0418: nop                                             ; 4688 _ 90
        jmp     ?_0463                                  ; 4689 _ E9, 000006E8

?_0419: mov     rax, qword [rbp-0E8H]                   ; 468E _ 48: 8B. 85, FFFFFF18
        mov     eax, dword [rax+84H]                    ; 4695 _ 8B. 80, 00000084
        or      ah, 02H                                 ; 469B _ 80. CC, 02
        mov     edx, eax                                ; 469E _ 89. C2
        mov     rax, qword [rbp-0E8H]                   ; 46A0 _ 48: 8B. 85, FFFFFF18
        mov     dword [rax+84H], edx                    ; 46A7 _ 89. 90, 00000084
        jmp     ?_0463                                  ; 46AD _ E9, 000006C4

?_0420: mov     rax, qword [rbp-0E8H]                   ; 46B2 _ 48: 8B. 85, FFFFFF18
        mov     eax, dword [rax+28H]                    ; 46B9 _ 8B. 40, 28
        cmp     eax, 353                                ; 46BC _ 3D, 00000161
        je      ?_0423                                  ; 46C1 _ 0F 84, 00000090
        cmp     eax, 353                                ; 46C7 _ 3D, 00000161
        jg      ?_0424                                  ; 46CC _ 0F 8F, 00000097
        cmp     eax, 352                                ; 46D2 _ 3D, 00000160
        je      ?_0412                                  ; 46D7 _ 0F 84, FFFFFEB9
        cmp     eax, 352                                ; 46DD _ 3D, 00000160
        jg      ?_0424                                  ; 46E2 _ 0F 8F, 00000081
        cmp     eax, 351                                ; 46E8 _ 3D, 0000015F
        je      ?_0401                                  ; 46ED _ 0F 84, FFFFFD31
        cmp     eax, 351                                ; 46F3 _ 3D, 0000015F
        jg      ?_0424                                  ; 46F8 _ 7F, 6F
        test    eax, eax                                ; 46FA _ 85. C0
        jz      ?_0421                                  ; 46FC _ 74, 0D
        cmp     eax, 350                                ; 46FE _ 3D, 0000015E
        je      ?_0392                                  ; 4703 _ 0F 84, FFFFFC51
        jmp     ?_0424                                  ; 4709 _ EB, 5E

?_0421: mov     rax, qword [rbp-0E8H]                   ; 470B _ 48: 8B. 85, FFFFFF18
        movzx   eax, byte [rax+7BH]                     ; 4712 _ 0F B6. 40, 7B
        movzx   eax, al                                 ; 4716 _ 0F B6. C0
        cmp     eax, 64                                 ; 4719 _ 83. F8, 40
        je      ?_0413                                  ; 471C _ 0F 84, FFFFFE77
        cmp     eax, 64                                 ; 4722 _ 83. F8, 40
        jg      ?_0422                                  ; 4725 _ 7F, 12
        cmp     eax, 16                                 ; 4727 _ 83. F8, 10
        je      ?_0393                                  ; 472A _ 0F 84, FFFFFC2D
        cmp     eax, 32                                 ; 4730 _ 83. F8, 20
        je      ?_0402                                  ; 4733 _ 0F 84, FFFFFCEE
?_0422: lea     rcx, [rel ?_1013]                       ; 4739 _ 48: 8D. 0D, 00000000(rel)
        lea     rax, [rel __func__.5]                   ; 4740 _ 48: 8D. 05, 00000000(rel)
        mov     edx, 1757                               ; 4747 _ BA, 000006DD
        mov     rsi, rcx                                ; 474C _ 48: 89. CE
        mov     rdi, rax                                ; 474F _ 48: 89. C7
        call    nasm_panic_from_macro                   ; 4752 _ E8, 00000000(PLT r)
?_0423: cmp     dword [rbp-0BCH], 16                    ; 4757 _ 83. BD, FFFFFF44, 10
        jne     ?_0394                                  ; 475E _ 0F 85, FFFFFBFC
        jmp     ?_0404                                  ; 4764 _ E9, FFFFFCC2

?_0424: lea     rcx, [rel ?_1013]                       ; 4769 _ 48: 8D. 0D, 00000000(rel)
        lea     rax, [rel __func__.5]                   ; 4770 _ 48: 8D. 05, 00000000(rel)
        mov     edx, 1772                               ; 4777 _ BA, 000006EC
        mov     rsi, rcx                                ; 477C _ 48: 89. CE
        mov     rdi, rax                                ; 477F _ 48: 89. C7
        call    nasm_panic_from_macro                   ; 4782 _ E8, 00000000(PLT r)
?_0425: mov     rax, qword [rbp-0E8H]                   ; 4787 _ 48: 8B. 85, FFFFFF18
        mov     dword [rax+50H], -1                     ; 478E _ C7. 40, 50, FFFFFFFF
        jmp     ?_0463                                  ; 4795 _ E9, 000005DC

?_0426: mov     rax, qword [rbp-0E8H]                   ; 479A _ 48: 8B. 85, FFFFFF18
        mov     dword [rax+50H], 242                    ; 47A1 _ C7. 40, 50, 000000F2
        jmp     ?_0463                                  ; 47A8 _ E9, 000005C9

?_0427: mov     rax, qword [rbp-0E8H]                   ; 47AD _ 48: 8B. 85, FFFFFF18
        mov     dword [rax+50H], 243                    ; 47B4 _ C7. 40, 50, 000000F3
        jmp     ?_0463                                  ; 47BB _ E9, 000005B6

?_0428: mov     rax, qword [rbp-0E8H]                   ; 47C0 _ 48: 8B. 85, FFFFFF18
        mov     eax, dword [rax+84H]                    ; 47C7 _ 8B. 80, 00000084
        or      eax, 20H                                ; 47CD _ 83. C8, 20
        mov     edx, eax                                ; 47D0 _ 89. C2
        mov     rax, qword [rbp-0E8H]                   ; 47D2 _ 48: 8B. 85, FFFFFF18
        mov     dword [rax+84H], edx                    ; 47D9 _ 89. 90, 00000084
        jmp     ?_0463                                  ; 47DF _ E9, 00000592

?_0429: mov     eax, dword [rel optimizing]             ; 47E4 _ 8B. 05, 00000000(rel)
        and     eax, 20H                                ; 47EA _ 83. E0, 20
        test    eax, eax                                ; 47ED _ 85. C0
        jne     ?_0463                                  ; 47EF _ 0F 85, 00000581
        mov     dword [rbp-0C8H], 112                   ; 47F5 _ C7. 85, FFFFFF38, 00000070
        jmp     ?_0463                                  ; 47FF _ E9, 00000572

?_0430: mov     eax, dword [rel optimizing]             ; 4804 _ 8B. 05, 00000000(rel)
        and     eax, 20H                                ; 480A _ 83. E0, 20
        test    eax, eax                                ; 480D _ 85. C0
        jne     ?_0463                                  ; 480F _ 0F 85, 00000561
        mov     dword [rbp-0C8H], 64                    ; 4815 _ C7. 85, FFFFFF38, 00000040
        jmp     ?_0463                                  ; 481F _ E9, 00000552

?_0431: mov     rax, qword [rbp-50H]                    ; 4824 _ 48: 8B. 45, B0
        mov     rdi, rax                                ; 4828 _ 48: 89. C7
        call    absolute_op                             ; 482B _ E8, FFFFC047
        xor     eax, 01H                                ; 4830 _ 83. F0, 01
        test    al, al                                  ; 4833 _ 84. C0
        jz      ?_0432                                  ; 4835 _ 74, 20
        lea     rax, [rel ?_1073]                       ; 4837 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 483E _ 48: 89. C7
        mov     eax, 0                                  ; 4841 _ B8, 00000000
        call    nasm_nonfatal                           ; 4846 _ E8, 00000000(PLT r)
        mov     rax, -1                                 ; 484B _ 48: C7. C0, FFFFFFFF
        jmp     ?_0516                                  ; 4852 _ E9, 00000E45

?_0432: mov     rax, qword [rbp-50H]                    ; 4857 _ 48: 8B. 45, B0
        mov     eax, dword [rax+38H]                    ; 485B _ 8B. 40, 38
        and     eax, 01H                                ; 485E _ 83. E0, 01
        test    eax, eax                                ; 4861 _ 85. C0
        jz      ?_0433                                  ; 4863 _ 74, 59
        mov     dword [rbp-0A0H], 589824                ; 4865 _ C7. 85, FFFFFF60, 00090000
        mov     eax, dword [rbp-0A0H]                   ; 486F _ 8B. 85, FFFFFF60
        mov     edi, eax                                ; 4875 _ 89. C7
        call    warn_active                             ; 4877 _ E8, FFFFB9D7
        movzx   eax, al                                 ; 487C _ 0F B6. C0
        test    rax, rax                                ; 487F _ 48: 85. C0
        jz      ?_0433                                  ; 4882 _ 74, 3A
        mov     rax, qword [rbp-0E8H]                   ; 4884 _ 48: 8B. 85, FFFFFF18
        mov     eax, dword [rax]                        ; 488B _ 8B. 00
        cdqe                                            ; 488D _ 48: 98
        lea     rdx, [rax*8]                            ; 488F _ 48: 8D. 14 C5, 00000000
        lea     rax, [rel nasm_insn_names]              ; 4897 _ 48: 8D. 05, 00000000(rel)
        mov     rdx, qword [rdx+rax]                    ; 489E _ 48: 8B. 14 02
        lea     rcx, [rel ?_1074]                       ; 48A2 _ 48: 8D. 0D, 00000000(rel)
        mov     eax, dword [rbp-0A0H]                   ; 48A9 _ 8B. 85, FFFFFF60
        mov     rsi, rcx                                ; 48AF _ 48: 89. CE
        mov     edi, eax                                ; 48B2 _ 89. C7
        mov     eax, 0                                  ; 48B4 _ B8, 00000000
        call    nasm_warn_                              ; 48B9 _ E8, 00000000(PLT r)
?_0433: mov     rax, qword [rbp-50H]                    ; 48BE _ 48: 8B. 45, B0
        mov     rbx, qword [rax+28H]                    ; 48C2 _ 48: 8B. 58, 28
        mov     rax, qword [rbp-0E8H]                   ; 48C6 _ 48: 8B. 85, FFFFFF18
        mov     eax, dword [rax]                        ; 48CD _ 8B. 00
        mov     edi, eax                                ; 48CF _ 89. C7
        call    resb_bytes                              ; 48D1 _ E8, FFFFBB57
        cdqe                                            ; 48D6 _ 48: 98
        imul    rax, rbx                                ; 48D8 _ 48: 0F AF. C3
        add     qword [rbp-68H], rax                    ; 48DC _ 48: 01. 45, 98
        jmp     ?_0463                                  ; 48E0 _ E9, 00000491

?_0434: mov     rax, qword [rbp-0E8H]                   ; 48E5 _ 48: 8B. 85, FFFFFF18
        mov     eax, dword [rax+18H]                    ; 48EC _ 8B. 40, 18
        test    eax, eax                                ; 48EF _ 85. C0
        jne     ?_0463                                  ; 48F1 _ 0F 85, 0000047F
        mov     rax, qword [rbp-0E8H]                   ; 48F7 _ 48: 8B. 85, FFFFFF18
        mov     dword [rax+18H], 359                    ; 48FE _ C7. 40, 18, 00000167
        jmp     ?_0463                                  ; 4905 _ E9, 0000046C

?_0435: cmp     dword [rbp-0BCH], 64                    ; 490A _ 83. BD, FFFFFF44, 40
        je      ?_0414                                  ; 4911 _ 0F 84, FFFFFC85
        cmp     dword [rbp-0BCH], 64                    ; 4917 _ 83. BD, FFFFFF44, 40
        jg      ?_0436                                  ; 491E _ 7F, 1A
        cmp     dword [rbp-0BCH], 16                    ; 4920 _ 83. BD, FFFFFF44, 10
        je      ?_0395                                  ; 4927 _ 0F 84, FFFFFA36
        cmp     dword [rbp-0BCH], 32                    ; 492D _ 83. BD, FFFFFF44, 20
        je      ?_0403                                  ; 4934 _ 0F 84, FFFFFAF0
?_0436: lea     rcx, [rel ?_1013]                       ; 493A _ 48: 8D. 0D, 00000000(rel)
        lea     rax, [rel __func__.5]                   ; 4941 _ 48: 8D. 05, 00000000(rel)
        mov     edx, 1831                               ; 4948 _ BA, 00000727
        mov     rsi, rcx                                ; 494D _ 48: 89. CE
        mov     rdi, rax                                ; 4950 _ 48: 89. C7
        call    nasm_panic_from_macro                   ; 4953 _ E8, 00000000(PLT r)
?_0437: mov     rax, qword [rbp-0E8H]                   ; 4958 _ 48: 8B. 85, FFFFFF18
        mov     eax, dword [rax+84H]                    ; 495F _ 8B. 80, 00000084
        or      eax, 41H                                ; 4965 _ 83. C8, 41
        mov     edx, eax                                ; 4968 _ 89. C2
        mov     rax, qword [rbp-0E8H]                   ; 496A _ 48: 8B. 85, FFFFFF18
        mov     dword [rax+84H], edx                    ; 4971 _ 89. 90, 00000084
        jmp     ?_0463                                  ; 4977 _ E9, 000003FA

?_0438: mov     rax, qword [rbp-0E8H]                   ; 497C _ 48: 8B. 85, FFFFFF18
        mov     eax, dword [rax+84H]                    ; 4983 _ 8B. 80, 00000084
        or      eax, 42H                                ; 4989 _ 83. C8, 42
        mov     edx, eax                                ; 498C _ 89. C2
        mov     rax, qword [rbp-0E8H]                   ; 498E _ 48: 8B. 85, FFFFFF18
        mov     dword [rax+84H], edx                    ; 4995 _ 89. 90, 00000084
        jmp     ?_0463                                  ; 499B _ E9, 000003D6

?_0439: mov     rax, qword [rbp-0E8H]                   ; 49A0 _ 48: 8B. 85, FFFFFF18
        mov     eax, dword [rax+84H]                    ; 49A7 _ 8B. 80, 00000084
        or      eax, 44H                                ; 49AD _ 83. C8, 44
        mov     edx, eax                                ; 49B0 _ 89. C2
        mov     rax, qword [rbp-0E8H]                   ; 49B2 _ 48: 8B. 85, FFFFFF18
        mov     dword [rax+84H], edx                    ; 49B9 _ 89. 90, 00000084
        jmp     ?_0463                                  ; 49BF _ E9, 000003B2

?_0440: mov     rax, qword [rbp-0E8H]                   ; 49C4 _ 48: 8B. 85, FFFFFF18
        mov     eax, dword [rax+84H]                    ; 49CB _ 8B. 80, 00000084
        or      eax, 48H                                ; 49D1 _ 83. C8, 48
        mov     edx, eax                                ; 49D4 _ 89. C2
        mov     rax, qword [rbp-0E8H]                   ; 49D6 _ 48: 8B. 85, FFFFFF18
        mov     dword [rax+84H], edx                    ; 49DD _ 89. 90, 00000084
        jmp     ?_0463                                  ; 49E3 _ E9, 0000038E

?_0441: mov     rax, qword [rbp-0E8H]                   ; 49E8 _ 48: 8B. 85, FFFFFF18
        mov     eax, dword [rax+84H]                    ; 49EF _ 8B. 80, 00000084
        or      eax, 840H                               ; 49F5 _ 0D, 00000840
        mov     edx, eax                                ; 49FA _ 89. C2
        mov     rax, qword [rbp-0E8H]                   ; 49FC _ 48: 8B. 85, FFFFFF18
        mov     dword [rax+84H], edx                    ; 4A03 _ 89. 90, 00000084
        jmp     ?_0463                                  ; 4A09 _ E9, 00000368

?_0442: mov     rax, qword [rbp-0E8H]                   ; 4A0E _ 48: 8B. 85, FFFFFF18
        mov     eax, dword [rax+84H]                    ; 4A15 _ 8B. 80, 00000084
        or      eax, 848H                               ; 4A1B _ 0D, 00000848
        mov     edx, eax                                ; 4A20 _ 89. C2
        mov     rax, qword [rbp-0E8H]                   ; 4A22 _ 48: 8B. 85, FFFFFF18
        mov     dword [rax+84H], edx                    ; 4A29 _ 89. 90, 00000084
        jmp     ?_0463                                  ; 4A2F _ E9, 00000342

?_0443: movzx   eax, byte [rbp-0D1H]                    ; 4A34 _ 0F B6. 85, FFFFFF2F
        and     eax, 03H                                ; 4A3B _ 83. E0, 03
        mov     edx, eax                                ; 4A3E _ 89. C2
        mov     rax, qword [rbp-0E8H]                   ; 4A40 _ 48: 8B. 85, FFFFFF18
        mov     byte [rax+80H], dl                      ; 4A47 _ 88. 90, 00000080
        jmp     ?_0463                                  ; 4A4D _ E9, 00000324

?_0444: mov     rax, qword [rbp-0E8H]                   ; 4A52 _ 48: 8B. 85, FFFFFF18
        mov     dword [rax+50H], -1                     ; 4A59 _ C7. 40, 50, FFFFFFFF
        mov     rax, qword [rbp-0E8H]                   ; 4A60 _ 48: 8B. 85, FFFFFF18
        mov     dword [rax+4CH], -1                     ; 4A67 _ C7. 40, 4C, FFFFFFFF
        jmp     ?_0463                                  ; 4A6E _ E9, 00000303

?_0445: mov     rax, qword [rbp-0E8H]                   ; 4A73 _ 48: 8B. 85, FFFFFF18
        mov     dword [rax+50H], -1                     ; 4A7A _ C7. 40, 50, FFFFFFFF
?_0446: mov     rax, qword [rbp-0E8H]                   ; 4A81 _ 48: 8B. 85, FFFFFF18
        mov     dword [rax+4CH], 102                    ; 4A88 _ C7. 40, 4C, 00000066
        jmp     ?_0463                                  ; 4A8F _ E9, 000002E2

?_0447: mov     rax, qword [rbp-0E8H]                   ; 4A94 _ 48: 8B. 85, FFFFFF18
        mov     dword [rax+4CH], -1                     ; 4A9B _ C7. 40, 4C, FFFFFFFF
        jmp     ?_0463                                  ; 4AA2 _ E9, 000002CF

?_0448: mov     rax, qword [rbp-0E8H]                   ; 4AA7 _ 48: 8B. 85, FFFFFF18
        mov     dword [rax+44H], -1                     ; 4AAE _ C7. 40, 44, FFFFFFFF
        jmp     ?_0463                                  ; 4AB5 _ E9, 000002BC

?_0449: mov     rax, qword [rbp-0E8H]                   ; 4ABA _ 48: 8B. 85, FFFFFF18
        mov     dword [rax+44H], 103                    ; 4AC1 _ C7. 40, 44, 00000067
        jmp     ?_0463                                  ; 4AC8 _ E9, 000002A9

?_0450: mov     rax, qword [rbp-0E8H]                   ; 4ACD _ 48: 8B. 85, FFFFFF18
        mov     eax, dword [rax+2CH]                    ; 4AD4 _ 8B. 40, 2C
        cmp     eax, 362                                ; 4AD7 _ 3D, 0000016A
        jne     ?_0463                                  ; 4ADC _ 0F 85, 00000294
        mov     rax, qword [rbp-0E8H]                   ; 4AE2 _ 48: 8B. 85, FFFFFF18
        mov     dword [rax+2CH], 0                      ; 4AE9 _ C7. 40, 2C, 00000000
        mov     rax, qword [rbp-0E8H]                   ; 4AF0 _ 48: 8B. 85, FFFFFF18
        movzx   eax, byte [rax+79H]                     ; 4AF7 _ 0F B6. 40, 79
        xor     eax, 01H                                ; 4AFB _ 83. F0, 01
        test    al, al                                  ; 4AFE _ 84. C0
        je      ?_0463                                  ; 4B00 _ 0F 84, 00000270
        mov     dword [rbp-0A4H], 2883584               ; 4B06 _ C7. 85, FFFFFF5C, 002C0000
        mov     eax, dword [rbp-0A4H]                   ; 4B10 _ 8B. 85, FFFFFF5C
        mov     edi, eax                                ; 4B16 _ 89. C7
        call    warn_active                             ; 4B18 _ E8, FFFFB736
        movzx   eax, al                                 ; 4B1D _ 0F B6. C0
        test    rax, rax                                ; 4B20 _ 48: 85. C0
        je      ?_0463                                  ; 4B23 _ 0F 84, 0000024D
        lea     rdx, [rel ?_1075]                       ; 4B29 _ 48: 8D. 15, 00000000(rel)
        mov     eax, dword [rbp-0A4H]                   ; 4B30 _ 8B. 85, FFFFFF5C
        mov     rsi, rdx                                ; 4B36 _ 48: 89. D6
        mov     edi, eax                                ; 4B39 _ 89. C7
        mov     eax, 0                                  ; 4B3B _ B8, 00000000
        call    nasm_warn_                              ; 4B40 _ E8, 00000000(PLT r)
        jmp     ?_0463                                  ; 4B45 _ E9, 0000022C

?_0451: add     qword [rbp-68H], 1                      ; 4B4A _ 48: 83. 45, 98, 01
        jmp     ?_0463                                  ; 4B4F _ E9, 00000222

?_0452: mov     dword [rbp-0D0H], 2                     ; 4B54 _ C7. 85, FFFFFF30, 00000002
        jmp     ?_0463                                  ; 4B5E _ E9, 00000213

?_0453: mov     dword [rbp-0D0H], 3                     ; 4B63 _ C7. 85, FFFFFF30, 00000003
        jmp     ?_0463                                  ; 4B6D _ E9, 00000204

?_0454: mov     dword [rbp-0D0H], 4                     ; 4B72 _ C7. 85, FFFFFF30, 00000004
        jmp     ?_0463                                  ; 4B7C _ E9, 000001F5

?_0455: mov     edx, dword [rbp-0A8H]                   ; 4B81 _ 8B. 95, FFFFFF58
        mov     rax, qword [rbp-0E8H]                   ; 4B87 _ 48: 8B. 85, FFFFFF18
        mov     esi, edx                                ; 4B8E _ 89. D6
        mov     rdi, rax                                ; 4B90 _ 48: 89. C7
        call    get_operand                             ; 4B93 _ E8, FFFFBC59
        mov     qword [rbp-48H], rax                    ; 4B98 _ 48: 89. 45, B8
        mov     rax, qword [rbp-0E8H]                   ; 4B9C _ 48: 8B. 85, FFFFFF18
        mov     dword [rax+9CH], 0                      ; 4BA3 _ C7. 80, 0000009C, 00000000
        movzx   eax, byte [rbp-0D1H]                    ; 4BAD _ 0F B6. 85, FFFFFF2F
        test    al, al                                  ; 4BB4 _ 84. C0
        js      ?_0456                                  ; 4BB6 _ 78, 33
        mov     rax, qword [rbp-50H]                    ; 4BB8 _ 48: 8B. 45, B0
        mov     rdi, rax                                ; 4BBC _ 48: 89. C7
        call    regflag                                 ; 4BBF _ E8, 00002A7F
        mov     qword [rbp-60H], rax                    ; 4BC4 _ 48: 89. 45, A0
        mov     rax, qword [rbp-50H]                    ; 4BC8 _ 48: 8B. 45, B0
        mov     eax, dword [rax+10H]                    ; 4BCC _ 8B. 40, 10
        cdqe                                            ; 4BCF _ 48: 98
        lea     rdx, [rax*4]                            ; 4BD1 _ 48: 8D. 14 85, 00000000
        lea     rax, [rel nasm_regvals]                 ; 4BD9 _ 48: 8D. 05, 00000000(rel)
        mov     eax, dword [rdx+rax]                    ; 4BE0 _ 8B. 04 02
        mov     dword [rbp-0C4H], eax                   ; 4BE3 _ 89. 85, FFFFFF3C
        jmp     ?_0457                                  ; 4BE9 _ EB, 20

?_0456: mov     qword [rbp-60H], 0                      ; 4BEB _ 48: C7. 45, A0, 00000000
        movzx   eax, byte [rbp-0D1H]                    ; 4BF3 _ 0F B6. 85, FFFFFF2F
        and     eax, 07H                                ; 4BFA _ 83. E0, 07
        mov     dword [rbp-0C4H], eax                   ; 4BFD _ 89. 85, FFFFFF3C
        mov     qword [rbp-50H], 0                      ; 4C03 _ 48: C7. 45, B0, 00000000
?_0457: mov     rax, qword [rbp-58H]                    ; 4C0B _ 48: 8B. 45, A8
        mov     esi, 47                                 ; 4C0F _ BE, 0000002F
        mov     rdi, rax                                ; 4C14 _ 48: 89. C7
        call    itemp_has                               ; 4C17 _ E8, FFFFB794
        test    al, al                                  ; 4C1C _ 84. C0
        jz      ?_0458                                  ; 4C1E _ 74, 4C
        mov     rax, qword [rbp-48H]                    ; 4C20 _ 48: 8B. 45, B8
        mov     eax, dword [rax+34H]                    ; 4C24 _ 8B. 40, 34
        or      eax, 20H                                ; 4C27 _ 83. C8, 20
        mov     edx, eax                                ; 4C2A _ 89. C2
        mov     rax, qword [rbp-48H]                    ; 4C2C _ 48: 8B. 45, B8
        mov     dword [rax+34H], edx                    ; 4C30 _ 89. 50, 34
        cmp     dword [rbp-0CCH], -1                    ; 4C33 _ 83. BD, FFFFFF34, FF
        jz      ?_0458                                  ; 4C3A _ 74, 30
        mov     rax, qword [rbp-48H]                    ; 4C3C _ 48: 8B. 45, B8
        mov     edx, dword [rbp-0CCH]                   ; 4C40 _ 8B. 95, FFFFFF34
        mov     dword [rax+14H], edx                    ; 4C46 _ 89. 50, 14
        mov     rax, qword [rbp-48H]                    ; 4C49 _ 48: 8B. 45, B8
        mov     dword [rax+18H], 1                      ; 4C4D _ C7. 40, 18, 00000001
        mov     rax, qword [rbp-48H]                    ; 4C54 _ 48: 8B. 45, B8
        mov     edx, dword [rbp-0CCH]                   ; 4C58 _ 8B. 95, FFFFFF34
        mov     dword [rax+1CH], edx                    ; 4C5E _ 89. 50, 1C
        mov     rax, qword [rbp-48H]                    ; 4C61 _ 48: 8B. 45, B8
        mov     dword [rax+20H], 2                      ; 4C65 _ C7. 40, 20, 00000002
?_0458: mov     rax, qword [rbp-58H]                    ; 4C6C _ 48: 8B. 45, A8
        mov     esi, 41                                 ; 4C70 _ BE, 00000029
        mov     rdi, rax                                ; 4C75 _ 48: 89. C7
        call    itemp_has                               ; 4C78 _ E8, FFFFB733
        test    al, al                                  ; 4C7D _ 84. C0
        jz      ?_0459                                  ; 4C7F _ 74, 13
        mov     rax, qword [rbp-48H]                    ; 4C81 _ 48: 8B. 45, B8
        mov     eax, dword [rax+34H]                    ; 4C85 _ 8B. 40, 34
        or      eax, 40H                                ; 4C88 _ 83. C8, 40
        mov     edx, eax                                ; 4C8B _ 89. C2
        mov     rax, qword [rbp-48H]                    ; 4C8D _ 48: 8B. 45, B8
        mov     dword [rax+34H], edx                    ; 4C91 _ 89. 50, 34
?_0459: mov     rdx, qword [rbp-48H]                    ; 4C94 _ 48: 8B. 55, B8
        mov     rax, qword [rbp-0E8H]                   ; 4C98 _ 48: 8B. 85, FFFFFF18
        mov     rsi, rdx                                ; 4C9F _ 48: 89. D6
        mov     rdi, rax                                ; 4CA2 _ 48: 89. C7
        call    ea_evex_flags                           ; 4CA5 _ E8, FFFFE6C3
        test    eax, eax                                ; 4CAA _ 85. C0
        jz      ?_0460                                  ; 4CAC _ 74, 0C
        mov     rax, -1                                 ; 4CAE _ 48: C7. C0, FFFFFFFF
        jmp     ?_0516                                  ; 4CB5 _ E9, 000009E2

?_0460: lea     r8, [rbp-78H]                           ; 4CBA _ 4C: 8D. 45, 88
        mov     edi, dword [rbp-0D0H]                   ; 4CBE _ 8B. BD, FFFFFF30
        mov     rcx, qword [rbp-0E8H]                   ; 4CC4 _ 48: 8B. 8D, FFFFFF18
        mov     rdx, qword [rbp-60H]                    ; 4CCB _ 48: 8B. 55, A0
        mov     esi, dword [rbp-0C4H]                   ; 4CCF _ 8B. B5, FFFFFF3C
        mov     rax, qword [rbp-48H]                    ; 4CD5 _ 48: 8B. 45, B8
        mov     r9, r8                                  ; 4CD9 _ 4D: 89. C1
        mov     r8d, edi                                ; 4CDC _ 41: 89. F8
        mov     rdi, rax                                ; 4CDF _ 48: 89. C7
        call    process_ea                              ; 4CE2 _ E8, 0000412B
        test    eax, eax                                ; 4CE7 _ 85. C0
        jz      ?_0461                                  ; 4CE9 _ 74, 27
        mov     rax, qword [rbp-78H]                    ; 4CEB _ 48: 8B. 45, 88
        lea     rdx, [rel ?_1076]                       ; 4CEF _ 48: 8D. 15, 00000000(rel)
        mov     rsi, rax                                ; 4CF6 _ 48: 89. C6
        mov     rdi, rdx                                ; 4CF9 _ 48: 89. D7
        mov     eax, 0                                  ; 4CFC _ B8, 00000000
        call    nasm_nonfatal                           ; 4D01 _ E8, 00000000(PLT r)
        mov     rax, -1                                 ; 4D06 _ 48: C7. C0, FFFFFFFF
        jmp     ?_0516                                  ; 4D0D _ E9, 0000098A

?_0461: mov     rax, qword [rbp-0E8H]                   ; 4D12 _ 48: 8B. 85, FFFFFF18
        mov     edx, dword [rax+84H]                    ; 4D19 _ 8B. 90, 00000084
        mov     rax, qword [rbp-0E8H]                   ; 4D1F _ 48: 8B. 85, FFFFFF18
        mov     eax, dword [rax+9CH]                    ; 4D26 _ 8B. 80, 0000009C
        or      edx, eax                                ; 4D2C _ 09. C2
        mov     rax, qword [rbp-0E8H]                   ; 4D2E _ 48: 8B. 85, FFFFFF18
        mov     dword [rax+84H], edx                    ; 4D35 _ 89. 90, 00000084
        mov     rax, qword [rbp-0E8H]                   ; 4D3B _ 48: 8B. 85, FFFFFF18
        movzx   eax, byte [rax+0A2H]                    ; 4D42 _ 0F B6. 80, 000000A2
        movzx   eax, al                                 ; 4D49 _ 0F B6. C0
        add     qword [rbp-68H], rax                    ; 4D4C _ 48: 01. 45, 98
        jmp     ?_0463                                  ; 4D50 _ EB, 24

?_0462: movzx   edx, byte [rbp-0D1H]                    ; 4D52 _ 0F B6. 95, FFFFFF2F
        movzx   eax, byte [rbp-0D1H]                    ; 4D59 _ 0F B6. 85, FFFFFF2F
        lea     rcx, [rel ?_1077]                       ; 4D60 _ 48: 8D. 0D, 00000000(rel)
        mov     esi, eax                                ; 4D67 _ 89. C6
        mov     rdi, rcx                                ; 4D69 _ 48: 89. CF
        mov     eax, 0                                  ; 4D6C _ B8, 00000000
        call    nasm_panic                              ; 4D71 _ E8, 00000000(PLT r)
?_0463: mov     rax, qword [rbp-70H]                    ; 4D76 _ 48: 8B. 45, 90
        movzx   eax, byte [rax]                         ; 4D7A _ 0F B6. 00
        test    al, al                                  ; 4D7D _ 84. C0
        jne     ?_0339                                  ; 4D7F _ 0F 85, FFFFE93A
        mov     rax, qword [rbp-0E8H]                   ; 4D85 _ 48: 8B. 85, FFFFFF18
        mov     eax, dword [rax+84H]                    ; 4D8C _ 8B. 80, 00000084
        and     eax, 200H                               ; 4D92 _ 25, 00000200
        test    eax, eax                                ; 4D97 _ 85. C0
        jz      ?_0465                                  ; 4D99 _ 74, 55
        mov     rax, qword [rbp-0E8H]                   ; 4D9B _ 48: 8B. 85, FFFFFF18
        mov     eax, dword [rax+84H]                    ; 4DA2 _ 8B. 80, 00000084
        and     eax, 80H                                ; 4DA8 _ 25, 00000080
        test    eax, eax                                ; 4DAD _ 85. C0
        jz      ?_0464                                  ; 4DAF _ 74, 20
        lea     rax, [rel ?_1078]                       ; 4DB1 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 4DB8 _ 48: 89. C7
        mov     eax, 0                                  ; 4DBB _ B8, 00000000
        call    nasm_nonfatal                           ; 4DC0 _ E8, 00000000(PLT r)
        mov     rax, -1                                 ; 4DC5 _ 48: C7. C0, FFFFFFFF
        jmp     ?_0516                                  ; 4DCC _ E9, 000008CB

?_0464: mov     rax, qword [rbp-0E8H]                   ; 4DD1 _ 48: 8B. 85, FFFFFF18
        mov     eax, dword [rax+84H]                    ; 4DD8 _ 8B. 80, 00000084
        and     eax, 0FFFFFFBFH                         ; 4DDE _ 83. E0, BF
        mov     edx, eax                                ; 4DE1 _ 89. C2
        mov     rax, qword [rbp-0E8H]                   ; 4DE3 _ 48: 8B. 85, FFFFFF18
        mov     dword [rax+84H], edx                    ; 4DEA _ 89. 90, 00000084
?_0465: mov     rax, qword [rbp-0E8H]                   ; 4DF0 _ 48: 8B. 85, FFFFFF18
        mov     eax, dword [rax+28H]                    ; 4DF7 _ 8B. 40, 28
        cmp     eax, 352                                ; 4DFA _ 3D, 00000160
        jnz     ?_0468                                  ; 4DFF _ 75, 3E
        mov     rax, qword [rbp-0E8H]                   ; 4E01 _ 48: 8B. 85, FFFFFF18
        mov     edx, dword [rax+84H]                    ; 4E08 _ 8B. 90, 00000084
        mov     rax, qword [rbp-0E8H]                   ; 4E0E _ 48: 8B. 85, FFFFFF18
        mov     eax, dword [rax+84H]                    ; 4E15 _ 8B. 80, 00000084
        and     eax, 8000H                              ; 4E1B _ 25, 00008000
        test    eax, eax                                ; 4E20 _ 85. C0
        jnz     ?_0466                                  ; 4E22 _ 75, 07
        mov     eax, 8                                  ; 4E24 _ B8, 00000008
        jmp     ?_0467                                  ; 4E29 _ EB, 05

?_0466: mov     eax, 0                                  ; 4E2B _ B8, 00000000
?_0467: or      edx, eax                                ; 4E30 _ 09. C2
        mov     rax, qword [rbp-0E8H]                   ; 4E32 _ 48: 8B. 85, FFFFFF18
        mov     dword [rax+84H], edx                    ; 4E39 _ 89. 90, 00000084
?_0468: mov     rax, qword [rbp-0E8H]                   ; 4E3F _ 48: 8B. 85, FFFFFF18
        mov     eax, dword [rax+30H]                    ; 4E46 _ 8B. 40, 30
        cmp     eax, 369                                ; 4E49 _ 3D, 00000171
        jg      ?_0478                                  ; 4E4E _ 0F 8F, 00000181
        cmp     eax, 367                                ; 4E54 _ 3D, 0000016F
        jge     ?_0470                                  ; 4E59 _ 7D, 4F
        cmp     eax, 366                                ; 4E5B _ 3D, 0000016E
        jz      ?_0469                                  ; 4E60 _ 74, 22
        cmp     eax, 366                                ; 4E62 _ 3D, 0000016E
        jg      ?_0478                                  ; 4E67 _ 0F 8F, 00000168
        cmp     eax, 364                                ; 4E6D _ 3D, 0000016C
        jz      ?_0471                                  ; 4E72 _ 74, 5C
        cmp     eax, 365                                ; 4E74 _ 3D, 0000016D
        je      ?_0474                                  ; 4E79 _ 0F 84, 000000C8
        jmp     ?_0478                                  ; 4E7F _ E9, 00000151

?_0469: mov     rax, qword [rbp-0E8H]                   ; 4E84 _ 48: 8B. 85, FFFFFF18
        mov     eax, dword [rax+84H]                    ; 4E8B _ 8B. 80, 00000084
        and     eax, 400H                               ; 4E91 _ 25, 00000400
        test    eax, eax                                ; 4E96 _ 85. C0
        jne     ?_0479                                  ; 4E98 _ 0F 85, 0000013A
        mov     rax, -1                                 ; 4E9E _ 48: C7. C0, FFFFFFFF
        jmp     ?_0516                                  ; 4EA5 _ E9, 000007F2

?_0470: mov     rax, qword [rbp-0E8H]                   ; 4EAA _ 48: 8B. 85, FFFFFF18
        mov     eax, dword [rax+84H]                    ; 4EB1 _ 8B. 80, 00000084
        and     eax, 100H                               ; 4EB7 _ 25, 00000100
        test    eax, eax                                ; 4EBC _ 85. C0
        jne     ?_0480                                  ; 4EBE _ 0F 85, 00000117
        mov     rax, -1                                 ; 4EC4 _ 48: C7. C0, FFFFFFFF
        jmp     ?_0516                                  ; 4ECB _ E9, 000007CC

?_0471: cmp     dword [rbp-0BCH], 64                    ; 4ED0 _ 83. BD, FFFFFF44, 40
        jz      ?_0472                                  ; 4ED7 _ 74, 28
        mov     eax, dword [rbp-0BCH]                   ; 4ED9 _ 8B. 85, FFFFFF44
        lea     rdx, [rel ?_1079]                       ; 4EDF _ 48: 8D. 15, 00000000(rel)
        mov     esi, eax                                ; 4EE6 _ 89. C6
        mov     rdi, rdx                                ; 4EE8 _ 48: 89. D7
        mov     eax, 0                                  ; 4EEB _ B8, 00000000
        call    nasm_nonfatal                           ; 4EF0 _ E8, 00000000(PLT r)
        mov     rax, -1                                 ; 4EF5 _ 48: C7. C0, FFFFFFFF
        jmp     ?_0516                                  ; 4EFC _ E9, 0000079B

?_0472: mov     rax, qword [rbp-0E8H]                   ; 4F01 _ 48: 8B. 85, FFFFFF18
        mov     eax, dword [rax+84H]                    ; 4F08 _ 8B. 80, 00000084
        and     eax, 0D00H                              ; 4F0E _ 25, 00000D00
        test    eax, eax                                ; 4F13 _ 85. C0
        jz      ?_0473                                  ; 4F15 _ 74, 0C
        mov     rax, -1                                 ; 4F17 _ 48: C7. C0, FFFFFFFF
        jmp     ?_0516                                  ; 4F1E _ E9, 00000779

?_0473: mov     rax, qword [rbp-0E8H]                   ; 4F23 _ 48: 8B. 85, FFFFFF18
        mov     eax, dword [rax+84H]                    ; 4F2A _ 8B. 80, 00000084
        or      eax, 40H                                ; 4F30 _ 83. C8, 40
        mov     edx, eax                                ; 4F33 _ 89. C2
        mov     rax, qword [rbp-0E8H]                   ; 4F35 _ 48: 8B. 85, FFFFFF18
        mov     dword [rax+84H], edx                    ; 4F3C _ 89. 90, 00000084
        jmp     ?_0481                                  ; 4F42 _ E9, 00000095

?_0474: cmp     dword [rbp-0BCH], 64                    ; 4F47 _ 83. BD, FFFFFF44, 40
        jz      ?_0475                                  ; 4F4E _ 74, 28
        mov     eax, dword [rbp-0BCH]                   ; 4F50 _ 8B. 85, FFFFFF44
        lea     rdx, [rel ?_1080]                       ; 4F56 _ 48: 8D. 15, 00000000(rel)
        mov     esi, eax                                ; 4F5D _ 89. C6
        mov     rdi, rdx                                ; 4F5F _ 48: 89. D7
        mov     eax, 0                                  ; 4F62 _ B8, 00000000
        call    nasm_nonfatal                           ; 4F67 _ E8, 00000000(PLT r)
        mov     rax, -1                                 ; 4F6C _ 48: C7. C0, FFFFFFFF
        jmp     ?_0516                                  ; 4F73 _ E9, 00000724

?_0475: mov     rax, qword [rbp-0E8H]                   ; 4F78 _ 48: 8B. 85, FFFFFF18
        mov     eax, dword [rax+84H]                    ; 4F7F _ 8B. 80, 00000084
        and     eax, 500H                               ; 4F85 _ 25, 00000500
        test    eax, eax                                ; 4F8A _ 85. C0
        jnz     ?_0476                                  ; 4F8C _ 75, 18
        mov     rax, qword [rbp-0E8H]                   ; 4F8E _ 48: 8B. 85, FFFFFF18
        mov     eax, dword [rax+84H]                    ; 4F95 _ 8B. 80, 00000084
        mov     edi, eax                                ; 4F9B _ 89. C7
        call    rex_highvec                             ; 4F9D _ E8, FFFFB838
        test    eax, eax                                ; 4FA2 _ 85. C0
        jz      ?_0477                                  ; 4FA4 _ 74, 0C
?_0476: mov     rax, -1                                 ; 4FA6 _ 48: C7. C0, FFFFFFFF
        jmp     ?_0516                                  ; 4FAD _ E9, 000006EA

?_0477: mov     rax, qword [rbp-0E8H]                   ; 4FB2 _ 48: 8B. 85, FFFFFF18
        mov     eax, dword [rax+84H]                    ; 4FB9 _ 8B. 80, 00000084
        or      eax, 840H                               ; 4FBF _ 0D, 00000840
        mov     edx, eax                                ; 4FC4 _ 89. C2
        mov     rax, qword [rbp-0E8H]                   ; 4FC6 _ 48: 8B. 85, FFFFFF18
        mov     dword [rax+84H], edx                    ; 4FCD _ 89. 90, 00000084
        jmp     ?_0481                                  ; 4FD3 _ EB, 07

?_0478: nop                                             ; 4FD5 _ 90
        jmp     ?_0481                                  ; 4FD6 _ EB, 04

?_0479: nop                                             ; 4FD8 _ 90
        jmp     ?_0481                                  ; 4FD9 _ EB, 01

?_0480: nop                                             ; 4FDB _ 90
?_0481: mov     rax, qword [rbp-0E8H]                   ; 4FDC _ 48: 8B. 85, FFFFFF18
        mov     eax, dword [rax+84H]                    ; 4FE3 _ 8B. 80, 00000084
        and     eax, 500H                               ; 4FE9 _ 25, 00000500
        test    eax, eax                                ; 4FEE _ 85. C0
        je      ?_0493                                  ; 4FF0 _ 0F 84, 000001BA
        mov     dword [rbp-0C0H], 28679                 ; 4FF6 _ C7. 85, FFFFFF40, 00007007
        mov     rax, qword [rbp-0E8H]                   ; 5000 _ 48: 8B. 85, FFFFFF18
        mov     eax, dword [rax+84H]                    ; 5007 _ 8B. 80, 00000084
        and     eax, 80H                                ; 500D _ 25, 00000080
        test    eax, eax                                ; 5012 _ 85. C0
        jz      ?_0482                                  ; 5014 _ 74, 20
        lea     rax, [rel ?_1081]                       ; 5016 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 501D _ 48: 89. C7
        mov     eax, 0                                  ; 5020 _ B8, 00000000
        call    nasm_nonfatal                           ; 5025 _ E8, 00000000(PLT r)
        mov     rax, -1                                 ; 502A _ 48: C7. C0, FFFFFFFF
        jmp     ?_0516                                  ; 5031 _ E9, 00000666

?_0482: mov     rax, qword [rbp-58H]                    ; 5036 _ 48: 8B. 45, A8
        mov     esi, 40                                 ; 503A _ BE, 00000028
        mov     rdi, rax                                ; 503F _ 48: 89. C7
        call    itemp_has                               ; 5042 _ E8, FFFFB369
        test    al, al                                  ; 5047 _ 84. C0
        jz      ?_0483                                  ; 5049 _ 74, 09
        or      dword [rbp-0C0H], 08H                   ; 504B _ 83. 8D, FFFFFF40, 08
        jmp     ?_0484                                  ; 5052 _ EB, 38

?_0483: mov     rax, qword [rbp-0E8H]                   ; 5054 _ 48: 8B. 85, FFFFFF18
        mov     eax, dword [rax+84H]                    ; 505B _ 8B. 80, 00000084
        and     eax, 0FFFFFFF7H                         ; 5061 _ 83. E0, F7
        mov     edx, eax                                ; 5064 _ 89. C2
        mov     rax, qword [rbp-0E8H]                   ; 5066 _ 48: 8B. 85, FFFFFF18
        movzx   eax, byte [rax+81H]                     ; 506D _ 0F B6. 80, 00000081
        shr     al, 4                                   ; 5074 _ C0. E8, 04
        movzx   eax, al                                 ; 5077 _ 0F B6. C0
        and     eax, 08H                                ; 507A _ 83. E0, 08
        or      edx, eax                                ; 507D _ 09. C2
        mov     rax, qword [rbp-0E8H]                   ; 507F _ 48: 8B. 85, FFFFFF18
        mov     dword [rax+84H], edx                    ; 5086 _ 89. 90, 00000084
?_0484: cmp     dword [rbp-0BCH], 64                    ; 508C _ 83. BD, FFFFFF44, 40
        jz      ?_0486                                  ; 5093 _ 74, 46
        mov     rax, qword [rbp-0E8H]                   ; 5095 _ 48: 8B. 85, FFFFFF18
        mov     eax, dword [rax+84H]                    ; 509C _ 8B. 80, 00000084
        and     eax, dword [rbp-0C0H]                   ; 50A2 _ 23. 85, FFFFFF40
        test    eax, eax                                ; 50A8 _ 85. C0
        jnz     ?_0485                                  ; 50AA _ 75, 0F
        mov     rax, qword [rbp-0E8H]                   ; 50AC _ 48: 8B. 85, FFFFFF18
        movzx   eax, byte [rax+7EH]                     ; 50B3 _ 0F B6. 40, 7E
        cmp     al, 7                                   ; 50B7 _ 3C, 07
        jbe     ?_0486                                  ; 50B9 _ 76, 20
?_0485: lea     rax, [rel ?_1082]                       ; 50BB _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 50C2 _ 48: 89. C7
        mov     eax, 0                                  ; 50C5 _ B8, 00000000
        call    nasm_nonfatal                           ; 50CA _ E8, 00000000(PLT r)
        mov     rax, -1                                 ; 50CF _ 48: C7. C0, FFFFFFFF
        jmp     ?_0516                                  ; 50D6 _ E9, 000005C1

?_0486: mov     rax, qword [rbp-0E8H]                   ; 50DB _ 48: 8B. 85, FFFFFF18
        mov     eax, dword [rax+84H]                    ; 50E2 _ 8B. 80, 00000084
        and     eax, 400H                               ; 50E8 _ 25, 00000400
        test    eax, eax                                ; 50ED _ 85. C0
        jz      ?_0487                                  ; 50EF _ 74, 0A
        add     qword [rbp-68H], 4                      ; 50F1 _ 48: 83. 45, 98, 04
        jmp     ?_0505                                  ; 50F6 _ E9, 0000032B

?_0487: mov     rax, qword [rbp-0E8H]                   ; 50FB _ 48: 8B. 85, FFFFFF18
        movzx   eax, byte [rax+7EH]                     ; 5102 _ 0F B6. 40, 7E
        cmp     al, 15                                  ; 5106 _ 3C, 0F
        ja      ?_0488                                  ; 5108 _ 77, 16
        mov     rax, qword [rbp-0E8H]                   ; 510A _ 48: 8B. 85, FFFFFF18
        mov     eax, dword [rax+84H]                    ; 5111 _ 8B. 80, 00000084
        and     eax, 7000H                              ; 5117 _ 25, 00007000
        test    eax, eax                                ; 511C _ 85. C0
        jz      ?_0489                                  ; 511E _ 74, 20
?_0488: lea     rax, [rel ?_1083]                       ; 5120 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 5127 _ 48: 89. C7
        mov     eax, 0                                  ; 512A _ B8, 00000000
        call    nasm_nonfatal                           ; 512F _ E8, 00000000(PLT r)
        mov     rax, -1                                 ; 5134 _ 48: C7. C0, FFFFFFFF
        jmp     ?_0516                                  ; 513B _ E9, 0000055C

?_0489: mov     rax, qword [rbp-0E8H]                   ; 5140 _ 48: 8B. 85, FFFFFF18
        movzx   eax, byte [rax+80H]                     ; 5147 _ 0F B6. 80, 00000080
        cmp     al, 1                                   ; 514E _ 3C, 01
        jnz     ?_0490                                  ; 5150 _ 75, 25
        mov     rax, qword [rbp-0E8H]                   ; 5152 _ 48: 8B. 85, FFFFFF18
        mov     eax, dword [rax+84H]                    ; 5159 _ 8B. 80, 00000084
        and     eax, 0BH                                ; 515F _ 83. E0, 0B
        test    eax, eax                                ; 5162 _ 85. C0
        jnz     ?_0490                                  ; 5164 _ 75, 11
        mov     rax, qword [rbp-0E8H]                   ; 5166 _ 48: 8B. 85, FFFFFF18
        mov     eax, dword [rax+30H]                    ; 516D _ 8B. 40, 30
        cmp     eax, 368                                ; 5170 _ 3D, 00000170
        jnz     ?_0492                                  ; 5175 _ 75, 2F
?_0490: mov     rax, qword [rbp-0E8H]                   ; 5177 _ 48: 8B. 85, FFFFFF18
        mov     eax, dword [rax+30H]                    ; 517E _ 8B. 40, 30
        cmp     eax, 369                                ; 5181 _ 3D, 00000171
        jnz     ?_0491                                  ; 5186 _ 75, 14
        lea     rax, [rel ?_1084]                       ; 5188 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 518F _ 48: 89. C7
        mov     eax, 0                                  ; 5192 _ B8, 00000000
        call    nasm_nonfatal                           ; 5197 _ E8, 00000000(PLT r)
?_0491: add     qword [rbp-68H], 3                      ; 519C _ 48: 83. 45, 98, 03
        jmp     ?_0505                                  ; 51A1 _ E9, 00000280

?_0492: add     qword [rbp-68H], 2                      ; 51A6 _ 48: 83. 45, 98, 02
        jmp     ?_0505                                  ; 51AB _ E9, 00000276

?_0493: mov     rax, qword [rbp-0E8H]                   ; 51B0 _ 48: 8B. 85, FFFFFF18
        mov     eax, dword [rax+84H]                    ; 51B7 _ 8B. 80, 00000084
        and     eax, 7800H                              ; 51BD _ 25, 00007800
        test    eax, eax                                ; 51C2 _ 85. C0
        je      ?_0499                                  ; 51C4 _ 0F 84, 0000011A
        cmp     dword [rbp-0BCH], 64                    ; 51CA _ 83. BD, FFFFFF44, 40
        jz      ?_0494                                  ; 51D1 _ 74, 28
        mov     eax, dword [rbp-0BCH]                   ; 51D3 _ 8B. 85, FFFFFF44
        lea     rdx, [rel ?_1085]                       ; 51D9 _ 48: 8D. 15, 00000000(rel)
        mov     esi, eax                                ; 51E0 _ 89. C6
        mov     rdi, rdx                                ; 51E2 _ 48: 89. D7
        mov     eax, 0                                  ; 51E5 _ B8, 00000000
        call    nasm_nonfatal                           ; 51EA _ E8, 00000000(PLT r)
        mov     rax, -1                                 ; 51EF _ 48: C7. C0, FFFFFFFF
        jmp     ?_0516                                  ; 51F6 _ E9, 000004A1

?_0494: lea     rax, [rel cpu]                          ; 51FB _ 48: 8D. 05, 00000000(rel)
        mov     esi, 146                                ; 5202 _ BE, 00000092
        mov     rdi, rax                                ; 5207 _ 48: 89. C7
        call    iflag_test                              ; 520A _ E8, FFFFB0EF
        xor     eax, 01H                                ; 520F _ 83. F0, 01
        test    al, al                                  ; 5212 _ 84. C0
        jz      ?_0495                                  ; 5214 _ 74, 20
        lea     rax, [rel ?_1086]                       ; 5216 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 521D _ 48: 89. C7
        mov     eax, 0                                  ; 5220 _ B8, 00000000
        call    nasm_nonfatal                           ; 5225 _ E8, 00000000(PLT r)
        mov     rax, -1                                 ; 522A _ 48: C7. C0, FFFFFFFF
        jmp     ?_0516                                  ; 5231 _ E9, 00000466

?_0495: mov     rax, qword [rbp-58H]                    ; 5236 _ 48: 8B. 45, A8
        mov     esi, 30                                 ; 523A _ BE, 0000001E
        mov     rdi, rax                                ; 523F _ 48: 89. C7
        call    itemp_has                               ; 5242 _ E8, FFFFB169
        test    al, al                                  ; 5247 _ 84. C0
        jnz     ?_0496                                  ; 5249 _ 75, 18
        mov     rax, qword [rbp-0E8H]                   ; 524B _ 48: 8B. 85, FFFFFF18
        mov     eax, dword [rax+84H]                    ; 5252 _ 8B. 80, 00000084
        mov     edi, eax                                ; 5258 _ 89. C7
        call    rex_highvec                             ; 525A _ E8, FFFFB57B
        test    eax, eax                                ; 525F _ 85. C0
        jz      ?_0497                                  ; 5261 _ 74, 20
?_0496: lea     rax, [rel ?_1087]                       ; 5263 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 526A _ 48: 89. C7
        mov     eax, 0                                  ; 526D _ B8, 00000000
        call    nasm_nonfatal                           ; 5272 _ E8, 00000000(PLT r)
        mov     rax, -1                                 ; 5277 _ 48: C7. C0, FFFFFFFF
        jmp     ?_0516                                  ; 527E _ E9, 00000419

?_0497: mov     rax, qword [rbp-0E8H]                   ; 5283 _ 48: 8B. 85, FFFFFF18
        mov     eax, dword [rax+84H]                    ; 528A _ 8B. 80, 00000084
        and     eax, 80H                                ; 5290 _ 25, 00000080
        test    eax, eax                                ; 5295 _ 85. C0
        jz      ?_0498                                  ; 5297 _ 74, 20
        lea     rax, [rel ?_1081]                       ; 5299 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 52A0 _ 48: 89. C7
        mov     eax, 0                                  ; 52A3 _ B8, 00000000
        call    nasm_nonfatal                           ; 52A8 _ E8, 00000000(PLT r)
        mov     rax, -1                                 ; 52AD _ 48: C7. C0, FFFFFFFF
        jmp     ?_0516                                  ; 52B4 _ E9, 000003E3

?_0498: mov     rax, qword [rbp-0E8H]                   ; 52B9 _ 48: 8B. 85, FFFFFF18
        mov     eax, dword [rax+84H]                    ; 52C0 _ 8B. 80, 00000084
        or      eax, 840H                               ; 52C6 _ 0D, 00000840
        mov     edx, eax                                ; 52CB _ 89. C2
        mov     rax, qword [rbp-0E8H]                   ; 52CD _ 48: 8B. 85, FFFFFF18
        mov     dword [rax+84H], edx                    ; 52D4 _ 89. 90, 00000084
        add     qword [rbp-68H], 2                      ; 52DA _ 48: 83. 45, 98, 02
        jmp     ?_0505                                  ; 52DF _ E9, 00000142

?_0499: mov     rax, qword [rbp-0E8H]                   ; 52E4 _ 48: 8B. 85, FFFFFF18
        mov     eax, dword [rax+84H]                    ; 52EB _ 8B. 80, 00000084
        and     eax, 4FH                                ; 52F1 _ 83. E0, 4F
        test    eax, eax                                ; 52F4 _ 85. C0
        je      ?_0505                                  ; 52F6 _ 0F 84, 0000012A
        mov     rax, qword [rbp-0E8H]                   ; 52FC _ 48: 8B. 85, FFFFFF18
        mov     eax, dword [rax+84H]                    ; 5303 _ 8B. 80, 00000084
        and     eax, 80H                                ; 5309 _ 25, 00000080
        test    eax, eax                                ; 530E _ 85. C0
        jz      ?_0500                                  ; 5310 _ 74, 20
        lea     rax, [rel ?_1081]                       ; 5312 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 5319 _ 48: 89. C7
        mov     eax, 0                                  ; 531C _ B8, 00000000
        call    nasm_nonfatal                           ; 5321 _ E8, 00000000(PLT r)
        mov     rax, -1                                 ; 5326 _ 48: C7. C0, FFFFFFFF
        jmp     ?_0516                                  ; 532D _ E9, 0000036A

?_0500: cmp     dword [rbp-0BCH], 64                    ; 5332 _ 83. BD, FFFFFF44, 40
        jnz     ?_0501                                  ; 5339 _ 75, 43
        mov     rax, qword [rbp-0E8H]                   ; 533B _ 48: 8B. 85, FFFFFF18
        mov     eax, dword [rax+84H]                    ; 5342 _ 8B. 80, 00000084
        and     eax, 0FFFFFFDFH                         ; 5348 _ 83. E0, DF
        mov     edx, eax                                ; 534B _ 89. C2
        mov     rax, qword [rbp-0E8H]                   ; 534D _ 48: 8B. 85, FFFFFF18
        mov     dword [rax+84H], edx                    ; 5354 _ 89. 90, 00000084
        mov     rax, qword [rbp-0E8H]                   ; 535A _ 48: 8B. 85, FFFFFF18
        mov     eax, dword [rax+84H]                    ; 5361 _ 8B. 80, 00000084
        or      eax, 40H                                ; 5367 _ 83. C8, 40
        mov     edx, eax                                ; 536A _ 89. C2
        mov     rax, qword [rbp-0E8H]                   ; 536C _ 48: 8B. 85, FFFFFF18
        mov     dword [rax+84H], edx                    ; 5373 _ 89. 90, 00000084
        jmp     ?_0504                                  ; 5379 _ E9, 000000A3

?_0501: mov     rax, qword [rbp-0E8H]                   ; 537E _ 48: 8B. 85, FFFFFF18
        mov     eax, dword [rax+84H]                    ; 5385 _ 8B. 80, 00000084
        and     eax, 702FH                              ; 538B _ 25, 0000702F
        cmp     eax, 36                                 ; 5390 _ 83. F8, 24
        jnz     ?_0503                                  ; 5393 _ 75, 64
        lea     rax, [rel cpu]                          ; 5395 _ 48: 8D. 05, 00000000(rel)
        mov     esi, 203                                ; 539C _ BE, 000000CB
        mov     rdi, rax                                ; 53A1 _ 48: 89. C7
        call    iflag_cpu_level_ok                      ; 53A4 _ E8, FFFFAFDB
        test    al, al                                  ; 53A9 _ 84. C0
        jz      ?_0503                                  ; 53AB _ 74, 4C
        mov     rax, qword [rbp-0E8H]                   ; 53AD _ 48: 8B. 85, FFFFFF18
        mov     esi, 3                                  ; 53B4 _ BE, 00000003
        mov     rdi, rax                                ; 53B9 _ 48: 89. C7
        call    assert_no_prefix                        ; 53BC _ E8, FFFFB524
        test    eax, eax                                ; 53C1 _ 85. C0
        jz      ?_0502                                  ; 53C3 _ 74, 0C
        mov     rax, -1                                 ; 53C5 _ 48: C7. C0, FFFFFFFF
        jmp     ?_0516                                  ; 53CC _ E9, 000002CB

?_0502: mov     byte [rbp-0D2H], 0                      ; 53D1 _ C6. 85, FFFFFF2E, 00
        mov     rax, qword [rbp-0E8H]                   ; 53D8 _ 48: 8B. 85, FFFFFF18
        mov     eax, dword [rax+84H]                    ; 53DF _ 8B. 80, 00000084
        and     eax, 0FFFFFFBFH                         ; 53E5 _ 83. E0, BF
        mov     edx, eax                                ; 53E8 _ 89. C2
        mov     rax, qword [rbp-0E8H]                   ; 53EA _ 48: 8B. 85, FFFFFF18
        mov     dword [rax+84H], edx                    ; 53F1 _ 89. 90, 00000084
        jmp     ?_0504                                  ; 53F7 _ EB, 28

?_0503: mov     eax, dword [rbp-0BCH]                   ; 53F9 _ 8B. 85, FFFFFF44
        lea     rdx, [rel ?_1085]                       ; 53FF _ 48: 8D. 15, 00000000(rel)
        mov     esi, eax                                ; 5406 _ 89. C6
        mov     rdi, rdx                                ; 5408 _ 48: 89. D7
        mov     eax, 0                                  ; 540B _ B8, 00000000
        call    nasm_nonfatal                           ; 5410 _ E8, 00000000(PLT r)
        mov     rax, -1                                 ; 5415 _ 48: C7. C0, FFFFFFFF
        jmp     ?_0516                                  ; 541C _ E9, 0000027B

?_0504: add     qword [rbp-68H], 1                      ; 5421 _ 48: 83. 45, 98, 01
?_0505: mov     rax, qword [rbp-0E8H]                   ; 5426 _ 48: 8B. 85, FFFFFF18
        mov     eax, dword [rax+84H]                    ; 542D _ 8B. 80, 00000084
        and     eax, 0D00H                              ; 5433 _ 25, 00000D00
        test    eax, eax                                ; 5438 _ 85. C0
        jnz     ?_0506                                  ; 543A _ 75, 34
        mov     rax, qword [rbp-0E8H]                   ; 543C _ 48: 8B. 85, FFFFFF18
        movzx   eax, byte [rax+80H]                     ; 5443 _ 0F B6. 80, 00000080
        test    al, al                                  ; 544A _ 84. C0
        setne   al                                      ; 544C _ 0F 95. C0
        movzx   edx, al                                 ; 544F _ 0F B6. D0
        mov     rax, qword [rbp-0E8H]                   ; 5452 _ 48: 8B. 85, FFFFFF18
        movzx   eax, byte [rax+80H]                     ; 5459 _ 0F B6. 80, 00000080
        cmp     al, 1                                   ; 5460 _ 3C, 01
        seta    al                                      ; 5462 _ 0F 97. C0
        movzx   eax, al                                 ; 5465 _ 0F B6. C0
        add     eax, edx                                ; 5468 _ 01. D0
        cdqe                                            ; 546A _ 48: 98
        add     qword [rbp-68H], rax                    ; 546C _ 48: 01. 45, 98
?_0506: cmp     byte [rbp-0D2H], 0                      ; 5470 _ 80. BD, FFFFFF2E, 00
        je      ?_0511                                  ; 5477 _ 0F 84, 0000011B
        mov     rax, qword [rbp-0E8H]                   ; 547D _ 48: 8B. 85, FFFFFF18
        mov     edx, 349                                ; 5484 _ BA, 0000015D
        mov     esi, 3                                  ; 5489 _ BE, 00000003
        mov     rdi, rax                                ; 548E _ 48: 89. C7
        call    has_prefix                              ; 5491 _ E8, FFFFB427
        test    eax, eax                                ; 5496 _ 85. C0
        je      ?_0511                                  ; 5498 _ 0F 84, 000000FA
        mov     rax, qword [rbp-58H]                    ; 549E _ 48: 8B. 45, A8
        mov     esi, 42                                 ; 54A2 _ BE, 0000002A
        mov     rdi, rax                                ; 54A7 _ 48: 89. C7
        call    itemp_has                               ; 54AA _ E8, FFFFAF01
        xor     eax, 01H                                ; 54AF _ 83. F0, 01
        test    al, al                                  ; 54B2 _ 84. C0
        jnz     ?_0507                                  ; 54B4 _ 75, 22
        mov     rax, qword [rbp-0E8H]                   ; 54B6 _ 48: 8B. 85, FFFFFF18
        mov     rax, qword [rax+0C0H]                   ; 54BD _ 48: 8B. 80, 000000C0
        mov     rsi, rax                                ; 54C4 _ 48: 89. C6
        mov     edi, 12                                 ; 54C7 _ BF, 0000000C
        call    is_class                                ; 54CC _ E8, FFFFAC8B
        xor     eax, 01H                                ; 54D1 _ 83. F0, 01
        test    al, al                                  ; 54D4 _ 84. C0
        jz      ?_0509                                  ; 54D6 _ 74, 77
?_0507: mov     rax, qword [rbp-58H]                    ; 54D8 _ 48: 8B. 45, A8
        mov     esi, 43                                 ; 54DC _ BE, 0000002B
        mov     rdi, rax                                ; 54E1 _ 48: 89. C7
        call    itemp_has                               ; 54E4 _ E8, FFFFAEC7
        xor     eax, 01H                                ; 54E9 _ 83. F0, 01
        test    al, al                                  ; 54EC _ 84. C0
        jnz     ?_0508                                  ; 54EE _ 75, 22
        mov     rax, qword [rbp-0E8H]                   ; 54F0 _ 48: 8B. 85, FFFFFF18
        mov     rax, qword [rax+108H]                   ; 54F7 _ 48: 8B. 80, 00000108
        mov     rsi, rax                                ; 54FE _ 48: 89. C6
        mov     edi, 12                                 ; 5501 _ BF, 0000000C
        call    is_class                                ; 5506 _ E8, FFFFAC51
        xor     eax, 01H                                ; 550B _ 83. F0, 01
        test    al, al                                  ; 550E _ 84. C0
        jz      ?_0509                                  ; 5510 _ 74, 3D
?_0508: mov     dword [rbp-0B8H], 3145728               ; 5512 _ C7. 85, FFFFFF48, 00300000
        mov     eax, dword [rbp-0B8H]                   ; 551C _ 8B. 85, FFFFFF48
        mov     edi, eax                                ; 5522 _ 89. C7
        call    warn_active                             ; 5524 _ E8, FFFFAD2A
        movzx   eax, al                                 ; 5529 _ 0F B6. C0
        test    rax, rax                                ; 552C _ 48: 85. C0
        jz      ?_0510                                  ; 552F _ 74, 66
        lea     rdx, [rel ?_1088]                       ; 5531 _ 48: 8D. 15, 00000000(rel)
        mov     eax, dword [rbp-0B8H]                   ; 5538 _ 8B. 85, FFFFFF48
        mov     rsi, rdx                                ; 553E _ 48: 89. D6
        mov     edi, eax                                ; 5541 _ 89. C7
        mov     eax, 0                                  ; 5543 _ B8, 00000000
        call    nasm_warn_                              ; 5548 _ E8, 00000000(PLT r)
        jmp     ?_0510                                  ; 554D _ EB, 48

?_0509: mov     rax, qword [rbp-58H]                    ; 554F _ 48: 8B. 45, A8
        mov     eax, dword [rax]                        ; 5553 _ 8B. 00
        cmp     eax, 113                                ; 5555 _ 83. F8, 71
        jnz     ?_0511                                  ; 5558 _ 75, 3E
        mov     dword [rbp-0B4H], 3211264               ; 555A _ C7. 85, FFFFFF4C, 00310000
        mov     eax, dword [rbp-0B4H]                   ; 5564 _ 8B. 85, FFFFFF4C
        mov     edi, eax                                ; 556A _ 89. C7
        call    warn_active                             ; 556C _ E8, FFFFACE2
        movzx   eax, al                                 ; 5571 _ 0F B6. C0
        test    rax, rax                                ; 5574 _ 48: 85. C0
        jz      ?_0511                                  ; 5577 _ 74, 1F
        lea     rdx, [rel ?_1089]                       ; 5579 _ 48: 8D. 15, 00000000(rel)
        mov     eax, dword [rbp-0B4H]                   ; 5580 _ 8B. 85, FFFFFF4C
        mov     rsi, rdx                                ; 5586 _ 48: 89. D6
        mov     edi, eax                                ; 5589 _ 89. C7
        mov     eax, 0                                  ; 558B _ B8, 00000000
        call    nasm_warn_                              ; 5590 _ E8, 00000000(PLT r)
        jmp     ?_0511                                  ; 5595 _ EB, 01

?_0510: nop                                             ; 5597 _ 90
?_0511: movzx   edx, byte [rbp-0D3H]                    ; 5598 _ 0F B6. 95, FFFFFF2D
        mov     rax, qword [rbp-0E8H]                   ; 559F _ 48: 8B. 85, FFFFFF18
        mov     esi, edx                                ; 55A6 _ 89. D6
        mov     rdi, rax                                ; 55A8 _ 48: 89. C7
        call    bad_hle_warn                            ; 55AB _ E8, FFFFDC7F
        movzx   eax, byte [rel globl+0CH]               ; 55B0 _ 0F B6. 05, 00000000(rel)
        test    al, al                                  ; 55B7 _ 84. C0
        jz      ?_0512                                  ; 55B9 _ 74, 40
        mov     rax, qword [rbp-58H]                    ; 55BB _ 48: 8B. 45, A8
        mov     esi, 48                                 ; 55BF _ BE, 00000030
        mov     rdi, rax                                ; 55C4 _ 48: 89. C7
        call    itemp_has                               ; 55C7 _ E8, FFFFADE4
        test    al, al                                  ; 55CC _ 84. C0
        jz      ?_0512                                  ; 55CE _ 74, 2B
        mov     rax, qword [rbp-0E8H]                   ; 55D0 _ 48: 8B. 85, FFFFFF18
        mov     edx, 363                                ; 55D7 _ BA, 0000016B
        mov     esi, 5                                  ; 55DC _ BE, 00000005
        mov     rdi, rax                                ; 55E1 _ 48: 89. C7
        call    has_prefix                              ; 55E4 _ E8, FFFFB2D4
        test    eax, eax                                ; 55E9 _ 85. C0
        jnz     ?_0512                                  ; 55EB _ 75, 0E
        mov     rax, qword [rbp-0E8H]                   ; 55ED _ 48: 8B. 85, FFFFFF18
        mov     dword [rax+2CH], 362                    ; 55F4 _ C7. 40, 2C, 0000016A
?_0512: mov     rax, qword [rbp-0E8H]                   ; 55FB _ 48: 8B. 85, FFFFFF18
        mov     eax, dword [rax+1CH]                    ; 5602 _ 8B. 40, 1C
        cmp     eax, 372                                ; 5605 _ 3D, 00000174
        jz      ?_0513                                  ; 560A _ 74, 11
        mov     rax, qword [rbp-0E8H]                   ; 560C _ 48: 8B. 85, FFFFFF18
        mov     eax, dword [rax+1CH]                    ; 5613 _ 8B. 40, 1C
        cmp     eax, 373                                ; 5616 _ 3D, 00000175
        jnz     ?_0515                                  ; 561B _ 75, 61
?_0513: mov     rax, qword [rbp-58H]                    ; 561D _ 48: 8B. 45, A8
        mov     esi, 26                                 ; 5621 _ BE, 0000001A
        mov     rdi, rax                                ; 5626 _ 48: 89. C7
        call    itemp_has                               ; 5629 _ E8, FFFFAD82
        xor     eax, 01H                                ; 562E _ 83. F0, 01
        test    al, al                                  ; 5631 _ 84. C0
        jz      ?_0515                                  ; 5633 _ 74, 49
        mov     dword [rbp-0B0H], 2949120               ; 5635 _ C7. 85, FFFFFF50, 002D0000
        mov     eax, dword [rbp-0B0H]                   ; 563F _ 8B. 85, FFFFFF50
        mov     edi, eax                                ; 5645 _ 89. C7
        call    warn_active                             ; 5647 _ E8, FFFFAC07
        movzx   eax, al                                 ; 564C _ 0F B6. C0
        test    rax, rax                                ; 564F _ 48: 85. C0
        jz      ?_0514                                  ; 5652 _ 74, 1C
        lea     rdx, [rel ?_1090]                       ; 5654 _ 48: 8D. 15, 00000000(rel)
        mov     eax, dword [rbp-0B0H]                   ; 565B _ 8B. 85, FFFFFF50
        mov     rsi, rdx                                ; 5661 _ 48: 89. D6
        mov     edi, eax                                ; 5664 _ 89. C7
        mov     eax, 0                                  ; 5666 _ B8, 00000000
        call    nasm_warn_                              ; 566B _ E8, 00000000(PLT r)
?_0514: mov     rax, qword [rbp-0E8H]                   ; 5670 _ 48: 8B. 85, FFFFFF18
        mov     dword [rax+1CH], 0                      ; 5677 _ C7. 40, 1C, 00000000
?_0515: mov     rax, qword [rbp-0E8H]                   ; 567E _ 48: 8B. 85, FFFFFF18
        mov     rsi, rax                                ; 5685 _ 48: 89. C6
        mov     edi, 0                                  ; 5688 _ BF, 00000000
        call    emit_prefixes                           ; 568D _ E8, 00000507
        cdqe                                            ; 5692 _ 48: 98
        add     qword [rbp-68H], rax                    ; 5694 _ 48: 01. 45, 98
        mov     rax, qword [rbp-68H]                    ; 5698 _ 48: 8B. 45, 98
?_0516: mov     rdx, qword [rbp-18H]                    ; 569C _ 48: 8B. 55, E8
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        sub     rdx, qword [fs:abs 28H]                 ; 56A0 _ 64 48: 2B. 14 25, 00000028
        jz      ?_0517                                  ; 56A9 _ 74, 05
        call    __stack_chk_fail                        ; 56AB _ E8, 00000000(PLT r)
?_0517: mov     rbx, qword [rbp-8H]                     ; 56B0 _ 48: 8B. 5D, F8
        leave                                           ; 56B4 _ C9
        ret                                             ; 56B5 _ C3

emit_rex:; Local function
        push    rbp                                     ; 56B6 _ 55
        mov     rbp, rsp                                ; 56B7 _ 48: 89. E5
        sub     rsp, 48                                 ; 56BA _ 48: 83. EC, 30
        mov     qword [rbp-28H], rdi                    ; 56BE _ 48: 89. 7D, D8
        mov     qword [rbp-30H], rsi                    ; 56C2 _ 48: 89. 75, D0
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        mov     rax, qword [fs:abs 28H]                 ; 56C6 _ 64 48: 8B. 04 25, 00000028
        mov     qword [rbp-8H], rax                     ; 56CF _ 48: 89. 45, F8
        xor     eax, eax                                ; 56D3 _ 31. C0
        mov     qword [rbp-18H], 0                      ; 56D5 _ 48: C7. 45, E8, 00000000
        mov     rax, qword [rbp-30H]                    ; 56DD _ 48: 8B. 45, D0
        movzx   eax, byte [rax+78H]                     ; 56E1 _ 0F B6. 40, 78
        test    al, al                                  ; 56E5 _ 84. C0
        jne     ?_0523                                  ; 56E7 _ 0F 85, 0000016E
        mov     rax, qword [rbp-30H]                    ; 56ED _ 48: 8B. 45, D0
        mov     byte [rax+78H], 1                       ; 56F1 _ C6. 40, 78, 01
        mov     rax, qword [rbp-30H]                    ; 56F5 _ 48: 8B. 45, D0
        mov     eax, dword [rax+84H]                    ; 56F9 _ 8B. 80, 00000084
        and     eax, 500H                               ; 56FF _ 25, 00000500
        test    eax, eax                                ; 5704 _ 85. C0
        jne     ?_0524                                  ; 5706 _ 0F 85, 00000152
        mov     rax, qword [rbp-30H]                    ; 570C _ 48: 8B. 45, D0
        mov     eax, dword [rax+84H]                    ; 5710 _ 8B. 80, 00000084
        and     eax, 800H                               ; 5716 _ 25, 00000800
        test    eax, eax                                ; 571B _ 85. C0
        jz      ?_0518                                  ; 571D _ 74, 53
        mov     byte [rbp-0CH], 213                     ; 571F _ C6. 45, F4, D5
        mov     rax, qword [rbp-30H]                    ; 5723 _ 48: 8B. 45, D0
        mov     eax, dword [rax+84H]                    ; 5727 _ 8B. 80, 00000084
        and     eax, 0FH                                ; 572D _ 83. E0, 0F
        mov     byte [rbp-0BH], al                      ; 5730 _ 88. 45, F5
        movzx   edx, byte [rbp-0BH]                     ; 5733 _ 0F B6. 55, F5
        mov     rax, qword [rbp-30H]                    ; 5737 _ 48: 8B. 45, D0
        mov     eax, dword [rax+84H]                    ; 573B _ 8B. 80, 00000084
        shr     eax, 8                                  ; 5741 _ C1. E8, 08
        and     eax, 70H                                ; 5744 _ 83. E0, 70
        or      eax, edx                                ; 5747 _ 09. D0
        mov     byte [rbp-0BH], al                      ; 5749 _ 88. 45, F5
        movzx   eax, byte [rbp-0BH]                     ; 574C _ 0F B6. 45, F5
        mov     edx, eax                                ; 5750 _ 89. C2
        mov     rax, qword [rbp-30H]                    ; 5752 _ 48: 8B. 45, D0
        movzx   eax, byte [rax+80H]                     ; 5756 _ 0F B6. 80, 00000080
        shl     eax, 7                                  ; 575D _ C1. E0, 07
        or      eax, edx                                ; 5760 _ 09. D0
        mov     byte [rbp-0BH], al                      ; 5762 _ 88. 45, F5
        mov     qword [rbp-18H], 2                      ; 5765 _ 48: C7. 45, E8, 00000002
        jmp     ?_0522                                  ; 576D _ E9, 000000D0

?_0518: mov     rax, qword [rbp-30H]                    ; 5772 _ 48: 8B. 45, D0
        mov     eax, dword [rax+84H]                    ; 5776 _ 8B. 80, 00000084
        and     eax, 6FH                                ; 577C _ 83. E0, 6F
        mov     byte [rbp-19H], al                      ; 577F _ 88. 45, E7
        cmp     byte [rbp-19H], 36                      ; 5782 _ 80. 7D, E7, 24
        jnz     ?_0519                                  ; 5786 _ 75, 13
        mov     rax, qword [rbp-18H]                    ; 5788 _ 48: 8B. 45, E8
        lea     rdx, [rax+1H]                           ; 578C _ 48: 8D. 50, 01
        mov     qword [rbp-18H], rdx                    ; 5790 _ 48: 89. 55, E8
        mov     byte [rbp+rax-0CH], 240                 ; 5794 _ C6. 44 05, F4, F0
        jmp     ?_0521                                  ; 5799 _ EB, 57

?_0519: movzx   eax, byte [rbp-19H]                     ; 579B _ 0F B6. 45, E7
        and     eax, 40H                                ; 579F _ 83. E0, 40
        test    eax, eax                                ; 57A2 _ 85. C0
        jz      ?_0520                                  ; 57A4 _ 74, 16
        mov     rax, qword [rbp-18H]                    ; 57A6 _ 48: 8B. 45, E8
        lea     rdx, [rax+1H]                           ; 57AA _ 48: 8D. 50, 01
        mov     qword [rbp-18H], rdx                    ; 57AE _ 48: 89. 55, E8
        movzx   edx, byte [rbp-19H]                     ; 57B2 _ 0F B6. 55, E7
        mov     byte [rbp+rax-0CH], dl                  ; 57B6 _ 88. 54 05, F4
        jmp     ?_0521                                  ; 57BA _ EB, 36

?_0520: movzx   eax, byte [rbp-19H]                     ; 57BC _ 0F B6. 45, E7
        and     eax, 0FFFFFFDFH                         ; 57C0 _ 83. E0, DF
        test    eax, eax                                ; 57C3 _ 85. C0
        setne   al                                      ; 57C5 _ 0F 95. C0
        movzx   eax, al                                 ; 57C8 _ 0F B6. C0
        test    rax, rax                                ; 57CB _ 48: 85. C0
        jz      ?_0521                                  ; 57CE _ 74, 22
        lea     rdx, [rel ?_1013]                       ; 57D0 _ 48: 8D. 15, 00000000(rel)
        lea     rsi, [rel __func__.3]                   ; 57D7 _ 48: 8D. 35, 00000000(rel)
        lea     rax, [rel ?_1091]                       ; 57DE _ 48: 8D. 05, 00000000(rel)
        mov     ecx, 2186                               ; 57E5 _ B9, 0000088A
        mov     rdi, rax                                ; 57EA _ 48: 89. C7
        call    nasm_assert_failed                      ; 57ED _ E8, 00000000(PLT r)
?_0521: mov     rax, qword [rbp-30H]                    ; 57F2 _ 48: 8B. 45, D0
        movzx   eax, byte [rax+80H]                     ; 57F6 _ 0F B6. 80, 00000080
        test    al, al                                  ; 57FD _ 84. C0
        jz      ?_0522                                  ; 57FF _ 74, 41
        mov     rax, qword [rbp-18H]                    ; 5801 _ 48: 8B. 45, E8
        lea     rdx, [rax+1H]                           ; 5805 _ 48: 8D. 50, 01
        mov     qword [rbp-18H], rdx                    ; 5809 _ 48: 89. 55, E8
        mov     byte [rbp+rax-0CH], 15                  ; 580D _ C6. 44 05, F4, 0F
        mov     rax, qword [rbp-30H]                    ; 5812 _ 48: 8B. 45, D0
        movzx   eax, byte [rax+80H]                     ; 5816 _ 0F B6. 80, 00000080
        cmp     al, 1                                   ; 581D _ 3C, 01
        jbe     ?_0522                                  ; 581F _ 76, 21
        mov     rax, qword [rbp-30H]                    ; 5821 _ 48: 8B. 45, D0
        movzx   eax, byte [rax+80H]                     ; 5825 _ 0F B6. 80, 00000080
        lea     ecx, [rax+rax]                          ; 582C _ 8D. 0C 00
        mov     rax, qword [rbp-18H]                    ; 582F _ 48: 8B. 45, E8
        lea     rdx, [rax+1H]                           ; 5833 _ 48: 8D. 50, 01
        mov     qword [rbp-18H], rdx                    ; 5837 _ 48: 89. 55, E8
        lea     edx, [rcx+34H]                          ; 583B _ 8D. 51, 34
        mov     byte [rbp+rax-0CH], dl                  ; 583E _ 88. 54 05, F4
?_0522: mov     rdx, qword [rbp-18H]                    ; 5842 _ 48: 8B. 55, E8
        lea     rcx, [rbp-0CH]                          ; 5846 _ 48: 8D. 4D, F4
        mov     rax, qword [rbp-28H]                    ; 584A _ 48: 8B. 45, D8
        mov     rsi, rcx                                ; 584E _ 48: 89. CE
        mov     rdi, rax                                ; 5851 _ 48: 89. C7
        call    out_rawdata                             ; 5854 _ E8, FFFFBCEB
        jmp     ?_0525                                  ; 5859 _ EB, 04

?_0523: nop                                             ; 585B _ 90
        jmp     ?_0525                                  ; 585C _ EB, 01

?_0524: nop                                             ; 585E _ 90
?_0525: mov     rax, qword [rbp-8H]                     ; 585F _ 48: 8B. 45, F8
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        sub     rax, qword [fs:abs 28H]                 ; 5863 _ 64 48: 2B. 04 25, 00000028
        jz      ?_0526                                  ; 586C _ 74, 05
        call    __stack_chk_fail                        ; 586E _ E8, 00000000(PLT r)
?_0526: leave                                           ; 5873 _ C9
        ret                                             ; 5874 _ C3

prefix_byte:; Local function
        push    rbp                                     ; 5875 _ 55
        mov     rbp, rsp                                ; 5876 _ 48: 89. E5
        mov     dword [rbp-4H], edi                     ; 5879 _ 89. 7D, FC
        mov     dword [rbp-8H], esi                     ; 587C _ 89. 75, F8
        mov     eax, dword [rbp-4H]                     ; 587F _ 8B. 45, FC
        cmp     eax, 373                                ; 5882 _ 3D, 00000175
        je      ?_0531                                  ; 5887 _ 0F 84, 00000239
        cmp     eax, 373                                ; 588D _ 3D, 00000175
        jg      ?_0552                                  ; 5892 _ 0F 8F, 000002FA
        cmp     eax, 372                                ; 5898 _ 3D, 00000174
        je      ?_0532                                  ; 589D _ 0F 84, 0000022D
        cmp     eax, 372                                ; 58A3 _ 3D, 00000174
        jg      ?_0552                                  ; 58A8 _ 0F 8F, 000002E4
        cmp     eax, 371                                ; 58AE _ 3D, 00000173
        jg      ?_0552                                  ; 58B3 _ 0F 8F, 000002D9
        cmp     eax, 370                                ; 58B9 _ 3D, 00000172
        jge     ?_0551                                  ; 58BE _ 0F 8D, 000002C7
        cmp     eax, 369                                ; 58C4 _ 3D, 00000171
        jg      ?_0552                                  ; 58C9 _ 0F 8F, 000002C3
        cmp     eax, 364                                ; 58CF _ 3D, 0000016C
        jge     ?_0550                                  ; 58D4 _ 0F 8D, 000002AA
        cmp     eax, 363                                ; 58DA _ 3D, 0000016B
        je      ?_0551                                  ; 58DF _ 0F 84, 000002A6
        cmp     eax, 363                                ; 58E5 _ 3D, 0000016B
        jg      ?_0552                                  ; 58EA _ 0F 8F, 000002A2
        cmp     eax, 362                                ; 58F0 _ 3D, 0000016A
        je      ?_0529                                  ; 58F5 _ 0F 84, 000001B7
        cmp     eax, 362                                ; 58FB _ 3D, 0000016A
        jg      ?_0552                                  ; 5900 _ 0F 8F, 0000028C
        cmp     eax, 361                                ; 5906 _ 3D, 00000169
        je      ?_0530                                  ; 590B _ 0F 84, 000001AB
        cmp     eax, 361                                ; 5911 _ 3D, 00000169
        jg      ?_0552                                  ; 5916 _ 0F 8F, 00000276
        cmp     eax, 360                                ; 591C _ 3D, 00000168
        je      ?_0529                                  ; 5921 _ 0F 84, 0000018B
        cmp     eax, 360                                ; 5927 _ 3D, 00000168
        jg      ?_0552                                  ; 592C _ 0F 8F, 00000260
        cmp     eax, 359                                ; 5932 _ 3D, 00000167
        je      ?_0527                                  ; 5937 _ 0F 84, 00000161
        cmp     eax, 359                                ; 593D _ 3D, 00000167
        jg      ?_0552                                  ; 5942 _ 0F 8F, 0000024A
        cmp     eax, 358                                ; 5948 _ 3D, 00000166
        je      ?_0530                                  ; 594D _ 0F 84, 00000169
        cmp     eax, 358                                ; 5953 _ 3D, 00000166
        jg      ?_0552                                  ; 5958 _ 0F 8F, 00000234
        cmp     eax, 357                                ; 595E _ 3D, 00000165
        jg      ?_0552                                  ; 5963 _ 0F 8F, 00000229
        cmp     eax, 356                                ; 5969 _ 3D, 00000164
        jge     ?_0529                                  ; 596E _ 0F 8D, 0000013E
        cmp     eax, 355                                ; 5974 _ 3D, 00000163
        jg      ?_0552                                  ; 5979 _ 0F 8F, 00000213
        cmp     eax, 354                                ; 597F _ 3D, 00000162
        jge     ?_0530                                  ; 5984 _ 0F 8D, 00000132
        cmp     eax, 353                                ; 598A _ 3D, 00000161
        je      ?_0549                                  ; 598F _ 0F 84, 000001E8
        cmp     eax, 353                                ; 5995 _ 3D, 00000161
        jg      ?_0552                                  ; 599A _ 0F 8F, 000001F2
        cmp     eax, 352                                ; 59A0 _ 3D, 00000160
        je      ?_0547                                  ; 59A5 _ 0F 84, 000001BE
        cmp     eax, 352                                ; 59AB _ 3D, 00000160
        jg      ?_0552                                  ; 59B0 _ 0F 8F, 000001DC
        cmp     eax, 351                                ; 59B6 _ 3D, 0000015F
        je      ?_0545                                  ; 59BB _ 0F 84, 00000194
        cmp     eax, 351                                ; 59C1 _ 3D, 0000015F
        jg      ?_0552                                  ; 59C6 _ 0F 8F, 000001C6
        cmp     eax, 350                                ; 59CC _ 3D, 0000015E
        je      ?_0543                                  ; 59D1 _ 0F 84, 0000016A
        cmp     eax, 350                                ; 59D7 _ 3D, 0000015E
        jg      ?_0552                                  ; 59DC _ 0F 8F, 000001B0
        cmp     eax, 349                                ; 59E2 _ 3D, 0000015D
        je      ?_0528                                  ; 59E7 _ 0F 84, 000000BB
        cmp     eax, 349                                ; 59ED _ 3D, 0000015D
        jg      ?_0552                                  ; 59F2 _ 0F 8F, 0000019A
        cmp     eax, 348                                ; 59F8 _ 3D, 0000015C
        je      ?_0542                                  ; 59FD _ 0F 84, 00000137
        cmp     eax, 348                                ; 5A03 _ 3D, 0000015C
        jg      ?_0552                                  ; 5A08 _ 0F 8F, 00000184
        cmp     eax, 346                                ; 5A0E _ 3D, 0000015A
        je      ?_0540                                  ; 5A13 _ 0F 84, 0000010D
        cmp     eax, 346                                ; 5A19 _ 3D, 0000015A
        jg      ?_0552                                  ; 5A1E _ 0F 8F, 0000016E
        cmp     eax, 345                                ; 5A24 _ 3D, 00000159
        je      ?_0537                                  ; 5A29 _ 0F 84, 000000D3
        cmp     eax, 345                                ; 5A2F _ 3D, 00000159
        jg      ?_0552                                  ; 5A34 _ 0F 8F, 00000158
        cmp     eax, 224                                ; 5A3A _ 3D, 000000E0
        je      ?_0536                                  ; 5A3F _ 0F 84, 000000B3
        cmp     eax, 224                                ; 5A45 _ 3D, 000000E0
        jg      ?_0552                                  ; 5A4A _ 0F 8F, 00000142
        cmp     eax, 97                                 ; 5A50 _ 83. F8, 61
        je      ?_0535                                  ; 5A53 _ 0F 84, 00000095
        cmp     eax, 97                                 ; 5A59 _ 83. F8, 61
        jg      ?_0552                                  ; 5A5C _ 0F 8F, 00000130
        cmp     eax, 96                                 ; 5A62 _ 83. F8, 60
        jz      ?_0534                                  ; 5A65 _ 74, 7D
        cmp     eax, 96                                 ; 5A67 _ 83. F8, 60
        jg      ?_0552                                  ; 5A6A _ 0F 8F, 00000122
        cmp     eax, 93                                 ; 5A70 _ 83. F8, 5D
        jz      ?_0533                                  ; 5A73 _ 74, 65
        cmp     eax, 93                                 ; 5A75 _ 83. F8, 5D
        jg      ?_0552                                  ; 5A78 _ 0F 8F, 00000114
        cmp     eax, 85                                 ; 5A7E _ 83. F8, 55
        jz      ?_0532                                  ; 5A81 _ 74, 4D
        cmp     eax, 85                                 ; 5A83 _ 83. F8, 55
        jg      ?_0552                                  ; 5A86 _ 0F 8F, 00000106
        test    eax, eax                                ; 5A8C _ 85. C0
        je      ?_0551                                  ; 5A8E _ 0F 84, 000000F7
        cmp     eax, 47                                 ; 5A94 _ 83. F8, 2F
        jz      ?_0531                                  ; 5A97 _ 74, 2D
        jmp     ?_0552                                  ; 5A99 _ E9, 000000F4

?_0527: mov     eax, 155                                ; 5A9E _ B8, 0000009B
        jmp     ?_0553                                  ; 5AA3 _ E9, 000000EF

?_0528: mov     eax, 240                                ; 5AA8 _ B8, 000000F0
        jmp     ?_0553                                  ; 5AAD _ E9, 000000E5

?_0529: mov     eax, 242                                ; 5AB2 _ B8, 000000F2
        jmp     ?_0553                                  ; 5AB7 _ E9, 000000DB

?_0530: mov     eax, 243                                ; 5ABC _ B8, 000000F3
        jmp     ?_0553                                  ; 5AC1 _ E9, 000000D1

?_0531: mov     eax, 46                                 ; 5AC6 _ B8, 0000002E
        jmp     ?_0553                                  ; 5ACB _ E9, 000000C7

?_0532: mov     eax, 62                                 ; 5AD0 _ B8, 0000003E
        jmp     ?_0553                                  ; 5AD5 _ E9, 000000BD

?_0533: mov     eax, 38                                 ; 5ADA _ B8, 00000026
        jmp     ?_0553                                  ; 5ADF _ E9, 000000B3

?_0534: mov     eax, 100                                ; 5AE4 _ B8, 00000064
        jmp     ?_0553                                  ; 5AE9 _ E9, 000000A9

?_0535: mov     eax, 101                                ; 5AEE _ B8, 00000065
        jmp     ?_0553                                  ; 5AF3 _ E9, 0000009F

?_0536: mov     eax, 54                                 ; 5AF8 _ B8, 00000036
        jmp     ?_0553                                  ; 5AFD _ E9, 00000095

?_0537: cmp     dword [rbp-8H], 64                      ; 5B02 _ 83. 7D, F8, 40
        jnz     ?_0538                                  ; 5B06 _ 75, 0A
        mov     eax, 4294967293                         ; 5B08 _ B8, FFFFFFFD
        jmp     ?_0553                                  ; 5B0D _ E9, 00000085

?_0538: cmp     dword [rbp-8H], 32                      ; 5B12 _ 83. 7D, F8, 20
        jnz     ?_0539                                  ; 5B16 _ 75, 07
        mov     eax, 103                                ; 5B18 _ B8, 00000067
        jmp     ?_0553                                  ; 5B1D _ EB, 78

?_0539: mov     eax, 4294967295                         ; 5B1F _ B8, FFFFFFFF
        jmp     ?_0553                                  ; 5B24 _ EB, 71

?_0540: cmp     dword [rbp-8H], 32                      ; 5B26 _ 83. 7D, F8, 20
        jz      ?_0541                                  ; 5B2A _ 74, 07
        mov     eax, 103                                ; 5B2C _ B8, 00000067
        jmp     ?_0553                                  ; 5B31 _ EB, 64

?_0541: mov     eax, 4294967295                         ; 5B33 _ B8, FFFFFFFF
        jmp     ?_0553                                  ; 5B38 _ EB, 5D

?_0542: mov     eax, 103                                ; 5B3A _ B8, 00000067
        jmp     ?_0553                                  ; 5B3F _ EB, 56

?_0543: cmp     dword [rbp-8H], 16                      ; 5B41 _ 83. 7D, F8, 10
        jz      ?_0544                                  ; 5B45 _ 74, 07
        mov     eax, 102                                ; 5B47 _ B8, 00000066
        jmp     ?_0553                                  ; 5B4C _ EB, 49

?_0544: mov     eax, 4294967295                         ; 5B4E _ B8, FFFFFFFF
        jmp     ?_0553                                  ; 5B53 _ EB, 42

?_0545: cmp     dword [rbp-8H], 16                      ; 5B55 _ 83. 7D, F8, 10
        jnz     ?_0546                                  ; 5B59 _ 75, 07
        mov     eax, 102                                ; 5B5B _ B8, 00000066
        jmp     ?_0553                                  ; 5B60 _ EB, 35

?_0546: mov     eax, 4294967295                         ; 5B62 _ B8, FFFFFFFF
        jmp     ?_0553                                  ; 5B67 _ EB, 2E

?_0547: cmp     dword [rbp-8H], 64                      ; 5B69 _ 83. 7D, F8, 40
        jnz     ?_0548                                  ; 5B6D _ 75, 07
        mov     eax, 4294967295                         ; 5B6F _ B8, FFFFFFFF
        jmp     ?_0553                                  ; 5B74 _ EB, 21

?_0548: mov     eax, 4294967293                         ; 5B76 _ B8, FFFFFFFD
        jmp     ?_0553                                  ; 5B7B _ EB, 1A

?_0549: mov     eax, 102                                ; 5B7D _ B8, 00000066
        jmp     ?_0553                                  ; 5B82 _ EB, 13

?_0550: mov     eax, 4294967294                         ; 5B84 _ B8, FFFFFFFE
        jmp     ?_0553                                  ; 5B89 _ EB, 0C

?_0551: mov     eax, 4294967295                         ; 5B8B _ B8, FFFFFFFF
        jmp     ?_0553                                  ; 5B90 _ EB, 05

?_0552: mov     eax, 4294967292                         ; 5B92 _ B8, FFFFFFFC
?_0553: pop     rbp                                     ; 5B97 _ 5D
        ret                                             ; 5B98 _ C3

emit_prefixes:; Local function
        push    rbp                                     ; 5B99 _ 55
        mov     rbp, rsp                                ; 5B9A _ 48: 89. E5
        sub     rsp, 80                                 ; 5B9D _ 48: 83. EC, 50
        mov     qword [rbp-48H], rdi                    ; 5BA1 _ 48: 89. 7D, B8
        mov     qword [rbp-50H], rsi                    ; 5BA5 _ 48: 89. 75, B0
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        mov     rax, qword [fs:abs 28H]                 ; 5BA9 _ 64 48: 8B. 04 25, 00000028
        mov     qword [rbp-8H], rax                     ; 5BB2 _ 48: 89. 45, F8
        xor     eax, eax                                ; 5BB6 _ 31. C0
        mov     rax, qword [rbp-50H]                    ; 5BB8 _ 48: 8B. 45, B0
        movzx   eax, byte [rax+7AH]                     ; 5BBC _ 0F B6. 40, 7A
        movzx   eax, al                                 ; 5BC0 _ 0F B6. C0
        mov     dword [rbp-28H], eax                    ; 5BC3 _ 89. 45, D8
        mov     dword [rbp-34H], 0                      ; 5BC6 _ C7. 45, CC, 00000000
        call    pass_final                              ; 5BCD _ E8, FFFFA6F3
        xor     eax, 01H                                ; 5BD2 _ 83. F0, 01
        test    al, al                                  ; 5BD5 _ 84. C0
        jnz     ?_0554                                  ; 5BD7 _ 75, 07
        cmp     qword [rbp-48H], 0                      ; 5BD9 _ 48: 83. 7D, B8, 00
        jz      ?_0555                                  ; 5BDE _ 74, 07
?_0554: mov     eax, 1                                  ; 5BE0 _ B8, 00000001
        jmp     ?_0556                                  ; 5BE5 _ EB, 05

?_0555: mov     eax, 0                                  ; 5BE7 _ B8, 00000000
?_0556: mov     byte [rbp-35H], al                      ; 5BEC _ 88. 45, CB
        and     byte [rbp-35H], 01H                     ; 5BEF _ 80. 65, CB, 01
        mov     dword [rbp-30H], 0                      ; 5BF3 _ C7. 45, D0, 00000000
        jmp     ?_0581                                  ; 5BFA _ E9, 000002F0

?_0557: mov     rax, qword [rbp-50H]                    ; 5BFF _ 48: 8B. 45, B0
        mov     edx, dword [rbp-30H]                    ; 5C03 _ 8B. 55, D0
        movsxd  rdx, edx                                ; 5C06 _ 48: 63. D2
        add     rdx, 4                                  ; 5C09 _ 48: 83. C2, 04
        mov     eax, dword [rax+rdx*4+8H]               ; 5C0D _ 8B. 44 90, 08
        mov     dword [rbp-24H], eax                    ; 5C11 _ 89. 45, DC
        mov     rax, qword [rbp-50H]                    ; 5C14 _ 48: 8B. 45, B0
        mov     edx, dword [rbp-30H]                    ; 5C18 _ 8B. 55, D0
        movsxd  rdx, edx                                ; 5C1B _ 48: 63. D2
        add     rdx, 12                                 ; 5C1E _ 48: 83. C2, 0C
        mov     eax, dword [rax+rdx*4+0CH]              ; 5C22 _ 8B. 44 90, 0C
        mov     dword [rbp-20H], eax                    ; 5C26 _ 89. 45, E0
        mov     edx, dword [rbp-28H]                    ; 5C29 _ 8B. 55, D8
        mov     eax, dword [rbp-24H]                    ; 5C2C _ 8B. 45, DC
        mov     esi, edx                                ; 5C2F _ 89. D6
        mov     edi, eax                                ; 5C31 _ 89. C7
        call    prefix_byte                             ; 5C33 _ E8, FFFFFC3D
        mov     dword [rbp-2CH], eax                    ; 5C38 _ 89. 45, D4
        cmp     dword [rbp-20H], 0                      ; 5C3B _ 83. 7D, E0, 00
        je      ?_0562                                  ; 5C3F _ 0F 84, 00000087
        mov     eax, dword [rbp-20H]                    ; 5C45 _ 8B. 45, E0
        cmp     eax, dword [rbp-2CH]                    ; 5C48 _ 3B. 45, D4
        jz      ?_0562                                  ; 5C4B _ 74, 7F
        cmp     dword [rbp-20H], 0                      ; 5C4D _ 83. 7D, E0, 00
        jg      ?_0558                                  ; 5C51 _ 7F, 06
        cmp     dword [rbp-2CH], 0                      ; 5C53 _ 83. 7D, D4, 00
        jle     ?_0562                                  ; 5C57 _ 7E, 73
?_0558: cmp     dword [rbp-24H], 352                    ; 5C59 _ 81. 7D, DC, 00000160
        ja      ?_0560                                  ; 5C60 _ 77, 24
        cmp     dword [rbp-24H], 350                    ; 5C62 _ 81. 7D, DC, 0000015E
        jnc     ?_0559                                  ; 5C69 _ 73, 13
        cmp     dword [rbp-24H], 0                      ; 5C6B _ 83. 7D, DC, 00
        jz      ?_0559                                  ; 5C6F _ 74, 0D
        mov     eax, dword [rbp-24H]                    ; 5C71 _ 8B. 45, DC
        sub     eax, 345                                ; 5C74 _ 2D, 00000159
        cmp     eax, 2                                  ; 5C79 _ 83. F8, 02
        ja      ?_0560                                  ; 5C7C _ 77, 08
?_0559: mov     eax, dword [rbp-20H]                    ; 5C7E _ 8B. 45, E0
        mov     dword [rbp-2CH], eax                    ; 5C81 _ 89. 45, D4
        jmp     ?_0562                                  ; 5C84 _ EB, 46

?_0560: cmp     byte [rbp-35H], 0                       ; 5C86 _ 80. 7D, CB, 00
        jz      ?_0561                                  ; 5C8A _ 74, 3F
        mov     dword [rbp-1CH], 3080192                ; 5C8C _ C7. 45, E4, 002F0000
        mov     eax, dword [rbp-1CH]                    ; 5C93 _ 8B. 45, E4
        mov     edi, eax                                ; 5C96 _ 89. C7
        call    warn_active                             ; 5C98 _ E8, FFFFA5B6
        movzx   eax, al                                 ; 5C9D _ 0F B6. C0
        test    rax, rax                                ; 5CA0 _ 48: 85. C0
        jz      ?_0561                                  ; 5CA3 _ 74, 26
        mov     eax, dword [rbp-24H]                    ; 5CA5 _ 8B. 45, DC
        mov     edi, eax                                ; 5CA8 _ 89. C7
        call    prefix_name                             ; 5CAA _ E8, 00000000(PLT r)
        mov     rdx, rax                                ; 5CAF _ 48: 89. C2
        lea     rcx, [rel ?_1092]                       ; 5CB2 _ 48: 8D. 0D, 00000000(rel)
        mov     eax, dword [rbp-1CH]                    ; 5CB9 _ 8B. 45, E4
        mov     rsi, rcx                                ; 5CBC _ 48: 89. CE
        mov     edi, eax                                ; 5CBF _ 89. C7
        mov     eax, 0                                  ; 5CC1 _ B8, 00000000
        call    nasm_warn_                              ; 5CC6 _ E8, 00000000(PLT r)
?_0561: nop                                             ; 5CCB _ 90
?_0562: mov     eax, dword [rbp-24H]                    ; 5CCC _ 8B. 45, DC
        cmp     eax, 352                                ; 5CCF _ 3D, 00000160
        je      ?_0567                                  ; 5CD4 _ 0F 84, 00000127
        cmp     eax, 352                                ; 5CDA _ 3D, 00000160
        jg      ?_0568                                  ; 5CDF _ 0F 8F, 0000013F
        cmp     eax, 347                                ; 5CE5 _ 3D, 0000015B
        je      ?_0566                                  ; 5CEA _ 0F 84, 000000EE
        cmp     eax, 347                                ; 5CF0 _ 3D, 0000015B
        jg      ?_0568                                  ; 5CF5 _ 0F 8F, 00000129
        cmp     eax, 345                                ; 5CFB _ 3D, 00000159
        je      ?_0565                                  ; 5D00 _ 0F 84, 000000B5
        cmp     eax, 345                                ; 5D06 _ 3D, 00000159
        jg      ?_0568                                  ; 5D0B _ 0F 8F, 00000113
        cmp     eax, 224                                ; 5D11 _ 3D, 000000E0
        jz      ?_0564                                  ; 5D16 _ 74, 47
        cmp     eax, 224                                ; 5D18 _ 3D, 000000E0
        jg      ?_0568                                  ; 5D1D _ 0F 8F, 00000101
        cmp     eax, 93                                 ; 5D23 _ 83. F8, 5D
        jz      ?_0564                                  ; 5D26 _ 74, 37
        cmp     eax, 93                                 ; 5D28 _ 83. F8, 5D
        jg      ?_0568                                  ; 5D2B _ 0F 8F, 000000F3
        cmp     eax, 47                                 ; 5D31 _ 83. F8, 2F
        jz      ?_0563                                  ; 5D34 _ 74, 09
        cmp     eax, 85                                 ; 5D36 _ 83. F8, 55
        jne     ?_0568                                  ; 5D39 _ 0F 85, 000000E5
?_0563: mov     rax, qword [rbp-50H]                    ; 5D3F _ 48: 8B. 45, B0
        mov     rax, qword [rax+0B0H]                   ; 5D43 _ 48: 8B. 80, 000000B0
        mov     esi, 26                                 ; 5D4A _ BE, 0000001A
        mov     rdi, rax                                ; 5D4F _ 48: 89. C7
        call    itemp_has                               ; 5D52 _ E8, FFFFA659
        test    al, al                                  ; 5D57 _ 84. C0
        jne     ?_0572                                  ; 5D59 _ 0F 85, 00000161
?_0564: cmp     byte [rbp-35H], 0                       ; 5D5F _ 80. 7D, CB, 00
        je      ?_0573                                  ; 5D63 _ 0F 84, 0000015A
        cmp     dword [rbp-28H], 64                     ; 5D69 _ 83. 7D, D8, 40
        jne     ?_0573                                  ; 5D6D _ 0F 85, 00000150
        mov     dword [rbp-18H], 3342336                ; 5D73 _ C7. 45, E8, 00330000
        mov     eax, dword [rbp-18H]                    ; 5D7A _ 8B. 45, E8
        mov     edi, eax                                ; 5D7D _ 89. C7
        call    warn_active                             ; 5D7F _ E8, FFFFA4CF
        movzx   eax, al                                 ; 5D84 _ 0F B6. C0
        test    rax, rax                                ; 5D87 _ 48: 85. C0
        je      ?_0573                                  ; 5D8A _ 0F 84, 00000133
        mov     eax, dword [rbp-24H]                    ; 5D90 _ 8B. 45, DC
        mov     edi, eax                                ; 5D93 _ 89. C7
        call    prefix_name                             ; 5D95 _ E8, 00000000(PLT r)
        mov     rdx, rax                                ; 5D9A _ 48: 89. C2
        lea     rcx, [rel ?_1093]                       ; 5D9D _ 48: 8D. 0D, 00000000(rel)
        mov     eax, dword [rbp-18H]                    ; 5DA4 _ 8B. 45, E8
        mov     rsi, rcx                                ; 5DA7 _ 48: 89. CE
        mov     edi, eax                                ; 5DAA _ 89. C7
        mov     eax, 0                                  ; 5DAC _ B8, 00000000
        call    nasm_warn_                              ; 5DB1 _ E8, 00000000(PLT r)
        jmp     ?_0573                                  ; 5DB6 _ E9, 00000108

?_0565: cmp     dword [rbp-28H], 64                     ; 5DBB _ 83. 7D, D8, 40
        jne     ?_0574                                  ; 5DBF _ 0F 85, 00000101
        lea     rax, [rel ?_1094]                       ; 5DC5 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 5DCC _ 48: 89. C7
        mov     eax, 0                                  ; 5DCF _ B8, 00000000
        call    nasm_nonfatal                           ; 5DD4 _ E8, 00000000(PLT r)
        jmp     ?_0574                                  ; 5DD9 _ E9, 000000E8

?_0566: cmp     dword [rbp-28H], 64                     ; 5DDE _ 83. 7D, D8, 40
        je      ?_0575                                  ; 5DE2 _ 0F 84, 000000E1
        lea     rax, [rel ?_1095]                       ; 5DE8 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 5DEF _ 48: 89. C7
        mov     eax, 0                                  ; 5DF2 _ B8, 00000000
        call    nasm_nonfatal                           ; 5DF7 _ E8, 00000000(PLT r)
        jmp     ?_0575                                  ; 5DFC _ E9, 000000C8

?_0567: cmp     dword [rbp-28H], 64                     ; 5E01 _ 83. 7D, D8, 40
        je      ?_0576                                  ; 5E05 _ 0F 84, 000000C1
        lea     rax, [rel ?_1096]                       ; 5E0B _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 5E12 _ 48: 89. C7
        mov     eax, 0                                  ; 5E15 _ B8, 00000000
        call    nasm_nonfatal                           ; 5E1A _ E8, 00000000(PLT r)
        jmp     ?_0576                                  ; 5E1F _ E9, 000000A8

?_0568: cmp     dword [rbp-2CH], 243                    ; 5E24 _ 81. 7D, D4, 000000F3
        jg      ?_0577                                  ; 5E2B _ 0F 8F, 0000009E
        cmp     dword [rbp-2CH], 242                    ; 5E31 _ 81. 7D, D4, 000000F2
        jge     ?_0569                                  ; 5E38 _ 7D, 1E
        cmp     dword [rbp-2CH], 102                    ; 5E3A _ 83. 7D, D4, 66
        jz      ?_0569                                  ; 5E3E _ 74, 18
        cmp     dword [rbp-2CH], 102                    ; 5E40 _ 83. 7D, D4, 66
        jg      ?_0577                                  ; 5E44 _ 0F 8F, 00000085
        cmp     dword [rbp-2CH], -4                     ; 5E4A _ 83. 7D, D4, FC
        jz      ?_0571                                  ; 5E4E _ 74, 4A
        cmp     dword [rbp-2CH], -3                     ; 5E50 _ 83. 7D, D4, FD
        jz      ?_0570                                  ; 5E54 _ 74, 1E
        jmp     ?_0577                                  ; 5E56 _ EB, 77

?_0569: mov     rax, qword [rbp-50H]                    ; 5E58 _ 48: 8B. 45, B0
        mov     eax, dword [rax+84H]                    ; 5E5C _ 8B. 80, 00000084
        and     eax, 500H                               ; 5E62 _ 25, 00000500
        test    eax, eax                                ; 5E67 _ 85. C0
        jz      ?_0578                                  ; 5E69 _ 74, 67
        mov     dword [rbp-2CH], -1                     ; 5E6B _ C7. 45, D4, FFFFFFFF
        jmp     ?_0578                                  ; 5E72 _ EB, 5E

?_0570: mov     eax, dword [rbp-24H]                    ; 5E74 _ 8B. 45, DC
        mov     edi, eax                                ; 5E77 _ 89. C7
        call    prefix_name                             ; 5E79 _ E8, 00000000(PLT r)
        mov     rdx, rax                                ; 5E7E _ 48: 89. C2
        lea     rax, [rel ?_1097]                       ; 5E81 _ 48: 8D. 05, 00000000(rel)
        mov     rsi, rdx                                ; 5E88 _ 48: 89. D6
        mov     rdi, rax                                ; 5E8B _ 48: 89. C7
        mov     eax, 0                                  ; 5E8E _ B8, 00000000
        call    nasm_nonfatal                           ; 5E93 _ E8, 00000000(PLT r)
        jmp     ?_0579                                  ; 5E98 _ EB, 39

?_0571: mov     eax, dword [rbp-24H]                    ; 5E9A _ 8B. 45, DC
        mov     edi, eax                                ; 5E9D _ 89. C7
        call    prefix_name                             ; 5E9F _ E8, 00000000(PLT r)
        mov     rdx, rax                                ; 5EA4 _ 48: 89. C2
        lea     rax, [rel ?_1098]                       ; 5EA7 _ 48: 8D. 05, 00000000(rel)
        mov     rsi, rdx                                ; 5EAE _ 48: 89. D6
        mov     rdi, rax                                ; 5EB1 _ 48: 89. C7
        mov     eax, 0                                  ; 5EB4 _ B8, 00000000
        call    nasm_nonfatal                           ; 5EB9 _ E8, 00000000(PLT r)
        jmp     ?_0579                                  ; 5EBE _ EB, 13

?_0572: nop                                             ; 5EC0 _ 90
        jmp     ?_0579                                  ; 5EC1 _ EB, 10

?_0573: nop                                             ; 5EC3 _ 90
        jmp     ?_0579                                  ; 5EC4 _ EB, 0D

?_0574: nop                                             ; 5EC6 _ 90
        jmp     ?_0579                                  ; 5EC7 _ EB, 0A

?_0575: nop                                             ; 5EC9 _ 90
        jmp     ?_0579                                  ; 5ECA _ EB, 07

?_0576: nop                                             ; 5ECC _ 90
        jmp     ?_0579                                  ; 5ECD _ EB, 04

?_0577: nop                                             ; 5ECF _ 90
        jmp     ?_0579                                  ; 5ED0 _ EB, 01

?_0578: nop                                             ; 5ED2 _ 90
?_0579: cmp     dword [rbp-2CH], 0                      ; 5ED3 _ 83. 7D, D4, 00
        js      ?_0580                                  ; 5ED7 _ 78, 12
        mov     eax, dword [rbp-34H]                    ; 5ED9 _ 8B. 45, CC
        lea     edx, [rax+1H]                           ; 5EDC _ 8D. 50, 01
        mov     dword [rbp-34H], edx                    ; 5EDF _ 89. 55, CC
        mov     edx, dword [rbp-2CH]                    ; 5EE2 _ 8B. 55, D4
        cdqe                                            ; 5EE5 _ 48: 98
        mov     byte [rbp+rax-11H], dl                  ; 5EE7 _ 88. 54 05, EF
?_0580: add     dword [rbp-30H], 1                      ; 5EEB _ 83. 45, D0, 01
?_0581: cmp     dword [rbp-30H], 8                      ; 5EEF _ 83. 7D, D0, 08
        jle     ?_0557                                  ; 5EF3 _ 0F 8E, FFFFFD06
        cmp     qword [rbp-48H], 0                      ; 5EF9 _ 48: 83. 7D, B8, 00
        jz      ?_0582                                  ; 5EFE _ 74, 1F
        cmp     dword [rbp-34H], 0                      ; 5F00 _ 83. 7D, CC, 00
        jz      ?_0582                                  ; 5F04 _ 74, 19
        mov     eax, dword [rbp-34H]                    ; 5F06 _ 8B. 45, CC
        movsxd  rdx, eax                                ; 5F09 _ 48: 63. D0
        lea     rcx, [rbp-11H]                          ; 5F0C _ 48: 8D. 4D, EF
        mov     rax, qword [rbp-48H]                    ; 5F10 _ 48: 8B. 45, B8
        mov     rsi, rcx                                ; 5F14 _ 48: 89. CE
        mov     rdi, rax                                ; 5F17 _ 48: 89. C7
        call    out_rawdata                             ; 5F1A _ E8, FFFFB625
?_0582: mov     eax, dword [rbp-34H]                    ; 5F1F _ 8B. 45, CC
        mov     rdx, qword [rbp-8H]                     ; 5F22 _ 48: 8B. 55, F8
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        sub     rdx, qword [fs:abs 28H]                 ; 5F26 _ 64 48: 2B. 14 25, 00000028
        jz      ?_0583                                  ; 5F2F _ 74, 05
        call    __stack_chk_fail                        ; 5F31 _ E8, 00000000(PLT r)
?_0583: leave                                           ; 5F36 _ C9
        ret                                             ; 5F37 _ C3

gencode:; Local function
        push    rbp                                     ; 5F38 _ 55
        mov     rbp, rsp                                ; 5F39 _ 48: 89. E5
        push    rbx                                     ; 5F3C _ 53
        sub     rsp, 168                                ; 5F3D _ 48: 81. EC, 000000A8
        mov     qword [rbp-0A8H], rdi                   ; 5F44 _ 48: 89. BD, FFFFFF58
        mov     qword [rbp-0B0H], rsi                   ; 5F4B _ 48: 89. B5, FFFFFF50
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        mov     rax, qword [fs:abs 28H]                 ; 5F52 _ 64 48: 8B. 04 25, 00000028
        mov     qword [rbp-18H], rax                    ; 5F5B _ 48: 89. 45, E8
        xor     eax, eax                                ; 5F5F _ 31. C0
        mov     rax, qword [rbp-0B0H]                   ; 5F61 _ 48: 8B. 85, FFFFFF50
        mov     rax, qword [rax+0B0H]                   ; 5F68 _ 48: 8B. 80, 000000B0
        mov     rax, qword [rax+40H]                    ; 5F6F _ 48: 8B. 40, 40
        mov     qword [rbp-58H], rax                    ; 5F73 _ 48: 89. 45, A8
        mov     byte [rbp-9DH], 0                       ; 5F77 _ C6. 85, FFFFFF63, 00
        mov     rax, qword [rbp-0B0H]                   ; 5F7E _ 48: 8B. 85, FFFFFF50
        movzx   eax, byte [rax+7AH]                     ; 5F85 _ 0F B6. 40, 7A
        movzx   eax, al                                 ; 5F89 _ 0F B6. C0
        mov     dword [rbp-94H], eax                    ; 5F8C _ 89. 85, FFFFFF6C
        mov     rax, qword [rbp-0B0H]                   ; 5F92 _ 48: 8B. 85, FFFFFF50
        mov     rdx, qword [rax+0B0H]                   ; 5F99 _ 48: 8B. 90, 000000B0
        mov     rax, qword [rbp-0A8H]                   ; 5FA0 _ 48: 8B. 85, FFFFFF58
        mov     qword [rax+30H], rdx                    ; 5FA7 _ 48: 89. 50, 30
        mov     rax, qword [rbp-0B0H]                   ; 5FAB _ 48: 8B. 85, FFFFFF50
        movzx   eax, byte [rax+7AH]                     ; 5FB2 _ 0F B6. 40, 7A
        movzx   edx, al                                 ; 5FB6 _ 0F B6. D0
        mov     rax, qword [rbp-0A8H]                   ; 5FB9 _ 48: 8B. 85, FFFFFF58
        mov     dword [rax+20H], edx                    ; 5FC0 _ 89. 50, 20
        mov     rax, qword [rbp-0B0H]                   ; 5FC3 _ 48: 8B. 85, FFFFFF50
        mov     byte [rax+78H], 0                       ; 5FCA _ C6. 40, 78, 00
        mov     rdx, qword [rbp-0B0H]                   ; 5FCE _ 48: 8B. 95, FFFFFF50
        mov     rax, qword [rbp-0A8H]                   ; 5FD5 _ 48: 8B. 85, FFFFFF58
        mov     rsi, rdx                                ; 5FDC _ 48: 89. D6
        mov     rdi, rax                                ; 5FDF _ 48: 89. C7
        call    emit_prefixes                           ; 5FE2 _ E8, FFFFFBB2
        jmp     ?_0672                                  ; 5FE7 _ E9, 0000162D

?_0584: mov     rax, qword [rbp-58H]                    ; 5FEC _ 48: 8B. 45, A8
        lea     rdx, [rax+1H]                           ; 5FF0 _ 48: 8D. 50, 01
        mov     qword [rbp-58H], rdx                    ; 5FF4 _ 48: 89. 55, A8
        movzx   eax, byte [rax]                         ; 5FF8 _ 0F B6. 00
        mov     byte [rbp-9EH], al                      ; 5FFB _ 88. 85, FFFFFF62
        movzx   eax, byte [rbp-9EH]                     ; 6001 _ 0F B6. 85, FFFFFF62
        and     eax, 03H                                ; 6008 _ 83. E0, 03
        mov     edx, eax                                ; 600B _ 89. C2
        movzx   eax, byte [rbp-9DH]                     ; 600D _ 0F B6. 85, FFFFFF63
        shl     eax, 2                                  ; 6014 _ C1. E0, 02
        and     eax, 04H                                ; 6017 _ 83. E0, 04
        or      eax, edx                                ; 601A _ 09. D0
        mov     dword [rbp-90H], eax                    ; 601C _ 89. 85, FFFFFF70
        mov     edx, dword [rbp-90H]                    ; 6022 _ 8B. 95, FFFFFF70
        mov     rax, qword [rbp-0B0H]                   ; 6028 _ 48: 8B. 85, FFFFFF50
        mov     esi, edx                                ; 602F _ 89. D6
        mov     rdi, rax                                ; 6031 _ 48: 89. C7
        call    get_operand                             ; 6034 _ E8, FFFFA7B8
        mov     qword [rbp-60H], rax                    ; 6039 _ 48: 89. 45, A0
        movzx   eax, byte [rbp-9EH]                     ; 603D _ 0F B6. 85, FFFFFF62
        shr     al, 3                                   ; 6044 _ C0. E8, 03
        movzx   eax, al                                 ; 6047 _ 0F B6. C0
        and     eax, 03H                                ; 604A _ 83. E0, 03
        mov     edx, eax                                ; 604D _ 89. C2
        movzx   eax, byte [rbp-9DH]                     ; 604F _ 0F B6. 85, FFFFFF63
        add     eax, eax                                ; 6056 _ 01. C0
        and     eax, 04H                                ; 6058 _ 83. E0, 04
        or      eax, edx                                ; 605B _ 09. D0
        mov     dword [rbp-8CH], eax                    ; 605D _ 89. 85, FFFFFF74
        mov     qword [rbp-48H], 0                      ; 6063 _ 48: C7. 45, B8, 00000000
        mov     byte [rbp-9DH], 0                       ; 606B _ C6. 85, FFFFFF63, 00
        movzx   eax, byte [rbp-9EH]                     ; 6072 _ 0F B6. 85, FFFFFF62
        cmp     eax, 254                                ; 6079 _ 3D, 000000FE
        jg      ?_0671                                  ; 607E _ 0F 8F, 00001571
        cmp     eax, 252                                ; 6084 _ 3D, 000000FC
        jge     ?_0672                                  ; 6089 _ 0F 8D, 0000158A
        cmp     eax, 251                                ; 608F _ 3D, 000000FB
        je      ?_0656                                  ; 6094 _ 0F 84, 000012D5
        cmp     eax, 251                                ; 609A _ 3D, 000000FB
        jg      ?_0671                                  ; 609F _ 0F 8F, 00001550
        cmp     eax, 250                                ; 60A5 _ 3D, 000000FA
        jg      ?_0671                                  ; 60AA _ 0F 8F, 00001545
        cmp     eax, 248                                ; 60B0 _ 3D, 000000F8
        jge     ?_0672                                  ; 60B5 _ 0F 8D, 0000155E
        cmp     eax, 247                                ; 60BB _ 3D, 000000F7
        jg      ?_0671                                  ; 60C0 _ 0F 8F, 0000152F
        cmp     eax, 246                                ; 60C6 _ 3D, 000000F6
        jge     ?_0672                                  ; 60CB _ 0F 8D, 00001548
        cmp     eax, 245                                ; 60D1 _ 3D, 000000F5
        jg      ?_0671                                  ; 60D6 _ 0F 8F, 00001519
        cmp     eax, 244                                ; 60DC _ 3D, 000000F4
        jge     ?_0672                                  ; 60E1 _ 0F 8D, 00001532
        cmp     eax, 241                                ; 60E7 _ 3D, 000000F1
        je      ?_0672                                  ; 60EC _ 0F 84, 00001527
        cmp     eax, 241                                ; 60F2 _ 3D, 000000F1
        jg      ?_0671                                  ; 60F7 _ 0F 8F, 000014F8
        cmp     eax, 240                                ; 60FD _ 3D, 000000F0
        je      ?_0672                                  ; 6102 _ 0F 84, 00001511
        cmp     eax, 240                                ; 6108 _ 3D, 000000F0
        jg      ?_0671                                  ; 610D _ 0F 8F, 000014E2
        cmp     eax, 239                                ; 6113 _ 3D, 000000EF
        jg      ?_0671                                  ; 6118 _ 0F 8F, 000014D7
        cmp     eax, 237                                ; 611E _ 3D, 000000ED
        jge     ?_0672                                  ; 6123 _ 0F 8D, 000014F0
        cmp     eax, 233                                ; 6129 _ 3D, 000000E9
        jg      ?_0671                                  ; 612E _ 0F 8F, 000014C1
        cmp     eax, 232                                ; 6134 _ 3D, 000000E8
        jge     ?_0672                                  ; 6139 _ 0F 8D, 000014DA
        cmp     eax, 231                                ; 613F _ 3D, 000000E7
        jg      ?_0671                                  ; 6144 _ 0F 8F, 000014AB
        cmp     eax, 228                                ; 614A _ 3D, 000000E4
        jge     ?_0672                                  ; 614F _ 0F 8D, 000014C4
        cmp     eax, 226                                ; 6155 _ 3D, 000000E2
        je      ?_0672                                  ; 615A _ 0F 84, 000014B9
        cmp     eax, 226                                ; 6160 _ 3D, 000000E2
        jg      ?_0671                                  ; 6165 _ 0F 8F, 0000148A
        cmp     eax, 225                                ; 616B _ 3D, 000000E1
        je      ?_0672                                  ; 6170 _ 0F 84, 000014A3
        cmp     eax, 225                                ; 6176 _ 3D, 000000E1
        jg      ?_0671                                  ; 617B _ 0F 8F, 00001474
        cmp     eax, 224                                ; 6181 _ 3D, 000000E0
        je      ?_0654                                  ; 6186 _ 0F 84, 00001185
        cmp     eax, 224                                ; 618C _ 3D, 000000E0
        jg      ?_0671                                  ; 6191 _ 0F 8F, 0000145E
        cmp     eax, 223                                ; 6197 _ 3D, 000000DF
        jg      ?_0671                                  ; 619C _ 0F 8F, 00001453
        cmp     eax, 222                                ; 61A2 _ 3D, 000000DE
        jge     ?_0672                                  ; 61A7 _ 0F 8D, 0000146C
        cmp     eax, 221                                ; 61AD _ 3D, 000000DD
        je      ?_0672                                  ; 61B2 _ 0F 84, 00001461
        cmp     eax, 221                                ; 61B8 _ 3D, 000000DD
        jg      ?_0671                                  ; 61BD _ 0F 8F, 00001432
        cmp     eax, 220                                ; 61C3 _ 3D, 000000DC
        je      ?_0672                                  ; 61C8 _ 0F 84, 0000144B
        cmp     eax, 220                                ; 61CE _ 3D, 000000DC
        jg      ?_0671                                  ; 61D3 _ 0F 8F, 0000141C
        cmp     eax, 219                                ; 61D9 _ 3D, 000000DB
        jg      ?_0671                                  ; 61DE _ 0F 8F, 00001411
        cmp     eax, 216                                ; 61E4 _ 3D, 000000D8
        jge     ?_0672                                  ; 61E9 _ 0F 8D, 0000142A
        cmp     eax, 215                                ; 61EF _ 3D, 000000D7
        je      ?_0672                                  ; 61F4 _ 0F 84, 0000141F
        cmp     eax, 215                                ; 61FA _ 3D, 000000D7
        jg      ?_0671                                  ; 61FF _ 0F 8F, 000013F0
        cmp     eax, 214                                ; 6205 _ 3D, 000000D6
        je      ?_0672                                  ; 620A _ 0F 84, 00001409
        cmp     eax, 214                                ; 6210 _ 3D, 000000D6
        jg      ?_0671                                  ; 6215 _ 0F 8F, 000013DA
        cmp     eax, 213                                ; 621B _ 3D, 000000D5
        je      ?_0672                                  ; 6220 _ 0F 84, 000013F3
        cmp     eax, 213                                ; 6226 _ 3D, 000000D5
        jg      ?_0671                                  ; 622B _ 0F 8F, 000013C4
        cmp     eax, 212                                ; 6231 _ 3D, 000000D4
        jg      ?_0671                                  ; 6236 _ 0F 8F, 000013B9
        cmp     eax, 208                                ; 623C _ 3D, 000000D0
        jge     ?_0672                                  ; 6241 _ 0F 8D, 000013D2
        cmp     eax, 207                                ; 6247 _ 3D, 000000CF
        jg      ?_0671                                  ; 624C _ 0F 8F, 000013A3
        cmp     eax, 204                                ; 6252 _ 3D, 000000CC
        jge     ?_0672                                  ; 6257 _ 0F 8D, 000013BC
        cmp     eax, 203                                ; 625D _ 3D, 000000CB
        je      ?_0672                                  ; 6262 _ 0F 84, 000013B1
        cmp     eax, 203                                ; 6268 _ 3D, 000000CB
        jg      ?_0671                                  ; 626D _ 0F 8F, 00001382
        cmp     eax, 202                                ; 6273 _ 3D, 000000CA
        je      ?_0672                                  ; 6278 _ 0F 84, 0000139B
        cmp     eax, 202                                ; 627E _ 3D, 000000CA
        jg      ?_0671                                  ; 6283 _ 0F 8F, 0000136C
        cmp     eax, 201                                ; 6289 _ 3D, 000000C9
        jg      ?_0671                                  ; 628E _ 0F 8F, 00001361
        cmp     eax, 200                                ; 6294 _ 3D, 000000C8
        jge     ?_0672                                  ; 6299 _ 0F 8D, 0000137A
        cmp     eax, 199                                ; 629F _ 3D, 000000C7
        jg      ?_0671                                  ; 62A4 _ 0F 8F, 0000134B
        cmp     eax, 196                                ; 62AA _ 3D, 000000C4
        jge     ?_0651                                  ; 62AF _ 0F 8D, 00000F67
        cmp     eax, 195                                ; 62B5 _ 3D, 000000C3
        jg      ?_0671                                  ; 62BA _ 0F 8F, 00001335
        cmp     eax, 192                                ; 62C0 _ 3D, 000000C0
        jge     ?_0648                                  ; 62C5 _ 0F 8D, 00000E93
        cmp     eax, 191                                ; 62CB _ 3D, 000000BF
        jg      ?_0671                                  ; 62D0 _ 0F 8F, 0000131F
        cmp     eax, 188                                ; 62D6 _ 3D, 000000BC
        jge     ?_0640                                  ; 62DB _ 0F 8D, 00000D48
        cmp     eax, 187                                ; 62E1 _ 3D, 000000BB
        jg      ?_0671                                  ; 62E6 _ 0F 8F, 00001309
        cmp     eax, 185                                ; 62EC _ 3D, 000000B9
        jge     ?_0672                                  ; 62F1 _ 0F 8D, 00001322
        cmp     eax, 184                                ; 62F7 _ 3D, 000000B8
        je      ?_0634                                  ; 62FC _ 0F 84, 00000BD6
        cmp     eax, 184                                ; 6302 _ 3D, 000000B8
        jg      ?_0671                                  ; 6307 _ 0F 8F, 000012E8
        cmp     eax, 183                                ; 630D _ 3D, 000000B7
        jg      ?_0671                                  ; 6312 _ 0F 8F, 000012DD
        cmp     eax, 180                                ; 6318 _ 3D, 000000B4
        jge     ?_0633                                  ; 631D _ 0F 8D, 00000B93
        cmp     eax, 179                                ; 6323 _ 3D, 000000B3
        jg      ?_0671                                  ; 6328 _ 0F 8F, 000012C7
        cmp     eax, 176                                ; 632E _ 3D, 000000B0
        jge     ?_0634                                  ; 6333 _ 0F 8D, 00000B9F
        cmp     eax, 175                                ; 6339 _ 3D, 000000AF
        jg      ?_0671                                  ; 633E _ 0F 8F, 000012B1
        cmp     eax, 172                                ; 6344 _ 3D, 000000AC
        jge     ?_0632                                  ; 6349 _ 0F 8D, 00000B45
        cmp     eax, 168                                ; 634F _ 3D, 000000A8
        je      ?_0620                                  ; 6354 _ 0F 84, 0000082E
        cmp     eax, 168                                ; 635A _ 3D, 000000A8
        jg      ?_0671                                  ; 635F _ 0F 8F, 00001290
        cmp     eax, 163                                ; 6365 _ 3D, 000000A3
        jg      ?_0671                                  ; 636A _ 0F 8F, 00001285
        cmp     eax, 160                                ; 6370 _ 3D, 000000A0
        jge     ?_0620                                  ; 6375 _ 0F 8D, 0000080D
        cmp     eax, 159                                ; 637B _ 3D, 0000009F
        jg      ?_0671                                  ; 6380 _ 0F 8F, 0000126F
        cmp     eax, 128                                ; 6386 _ 3D, 00000080
        jge     ?_0659                                  ; 638B _ 0F 8D, 0000100C
        cmp     eax, 127                                ; 6391 _ 83. F8, 7F
        jg      ?_0671                                  ; 6394 _ 0F 8F, 0000125B
        cmp     eax, 124                                ; 639A _ 83. F8, 7C
        jge     ?_0618                                  ; 639D _ 0F 8D, 0000078C
        cmp     eax, 123                                ; 63A3 _ 83. F8, 7B
        je      ?_0617                                  ; 63A6 _ 0F 84, 00000737
        cmp     eax, 123                                ; 63AC _ 83. F8, 7B
        jg      ?_0671                                  ; 63AF _ 0F 8F, 00001240
        cmp     eax, 122                                ; 63B5 _ 83. F8, 7A
        je      ?_0612                                  ; 63B8 _ 0F 84, 000005F6
        cmp     eax, 122                                ; 63BE _ 83. F8, 7A
        jg      ?_0671                                  ; 63C1 _ 0F 8F, 0000122E
        cmp     eax, 121                                ; 63C7 _ 83. F8, 79
        je      ?_0611                                  ; 63CA _ 0F 84, 00000528
        cmp     eax, 121                                ; 63D0 _ 83. F8, 79
        jg      ?_0671                                  ; 63D3 _ 0F 8F, 0000121C
        cmp     eax, 91                                 ; 63D9 _ 83. F8, 5B
        jg      ?_0671                                  ; 63DC _ 0F 8F, 00001213
        cmp     eax, 88                                 ; 63E2 _ 83. F8, 58
        jge     ?_0659                                  ; 63E5 _ 0F 8D, 00000FB2
        cmp     eax, 83                                 ; 63EB _ 83. F8, 53
        jg      ?_0671                                  ; 63EE _ 0F 8F, 00001201
        cmp     eax, 80                                 ; 63F4 _ 83. F8, 50
        jge     ?_0659                                  ; 63F7 _ 0F 8D, 00000FA0
        cmp     eax, 75                                 ; 63FD _ 83. F8, 4B
        jg      ?_0671                                  ; 6400 _ 0F 8F, 000011EF
        cmp     eax, 72                                 ; 6406 _ 83. F8, 48
        jge     ?_0659                                  ; 6409 _ 0F 8D, 00000F8E
        cmp     eax, 67                                 ; 640F _ 83. F8, 43
        jg      ?_0671                                  ; 6412 _ 0F 8F, 000011DD
        cmp     eax, 64                                 ; 6418 _ 83. F8, 40
        jge     ?_0659                                  ; 641B _ 0F 8D, 00000F7C
        cmp     eax, 63                                 ; 6421 _ 83. F8, 3F
        jg      ?_0671                                  ; 6424 _ 0F 8F, 000011CB
        cmp     eax, 60                                 ; 642A _ 83. F8, 3C
        jge     ?_0609                                  ; 642D _ 0F 8D, 0000048A
        cmp     eax, 59                                 ; 6433 _ 83. F8, 3B
        jg      ?_0671                                  ; 6436 _ 0F 8F, 000011B9
        cmp     eax, 56                                 ; 643C _ 83. F8, 38
        jge     ?_0608                                  ; 643F _ 0F 8D, 00000458
        cmp     eax, 55                                 ; 6445 _ 83. F8, 37
        jg      ?_0671                                  ; 6448 _ 0F 8F, 000011A7
        cmp     eax, 52                                 ; 644E _ 83. F8, 34
        jge     ?_0603                                  ; 6451 _ 0F 8D, 000003BE
        cmp     eax, 51                                 ; 6457 _ 83. F8, 33
        jg      ?_0671                                  ; 645A _ 0F 8F, 00001195
        cmp     eax, 48                                 ; 6460 _ 83. F8, 30
        jge     ?_0602                                  ; 6463 _ 0F 8D, 0000038C
        cmp     eax, 47                                 ; 6469 _ 83. F8, 2F
        jg      ?_0671                                  ; 646C _ 0F 8F, 00001183
        cmp     eax, 44                                 ; 6472 _ 83. F8, 2C
        jge     ?_0601                                  ; 6475 _ 0F 8D, 00000358
        cmp     eax, 43                                 ; 647B _ 83. F8, 2B
        jg      ?_0671                                  ; 647E _ 0F 8F, 00001171
        cmp     eax, 40                                 ; 6484 _ 83. F8, 28
        jge     ?_0599                                  ; 6487 _ 0F 8D, 0000029C
        cmp     eax, 39                                 ; 648D _ 83. F8, 27
        jg      ?_0671                                  ; 6490 _ 0F 8F, 0000115F
        cmp     eax, 36                                 ; 6496 _ 83. F8, 24
        jge     ?_0598                                  ; 6499 _ 0F 8D, 00000252
        cmp     eax, 35                                 ; 649F _ 83. F8, 23
        jg      ?_0671                                  ; 64A2 _ 0F 8F, 0000114D
        cmp     eax, 32                                 ; 64A8 _ 83. F8, 20
        jge     ?_0597                                  ; 64AB _ 0F 8D, 0000021E
        cmp     eax, 31                                 ; 64B1 _ 83. F8, 1F
        jg      ?_0671                                  ; 64B4 _ 0F 8F, 0000113B
        cmp     eax, 28                                 ; 64BA _ 83. F8, 1C
        jge     ?_0592                                  ; 64BD _ 0F 8D, 00000182
        cmp     eax, 27                                 ; 64C3 _ 83. F8, 1B
        jg      ?_0671                                  ; 64C6 _ 0F 8F, 00001129
        cmp     eax, 24                                 ; 64CC _ 83. F8, 18
        jge     ?_0591                                  ; 64CF _ 0F 8D, 0000014E
        cmp     eax, 23                                 ; 64D5 _ 83. F8, 17
        jg      ?_0671                                  ; 64D8 _ 0F 8F, 00001117
        cmp     eax, 20                                 ; 64DE _ 83. F8, 14
        jge     ?_0590                                  ; 64E1 _ 0F 8D, 0000011A
        cmp     eax, 19                                 ; 64E7 _ 83. F8, 13
        jg      ?_0671                                  ; 64EA _ 0F 8F, 00001105
        cmp     eax, 16                                 ; 64F0 _ 83. F8, 10
        jge     ?_0589                                  ; 64F3 _ 0F 8D, 000000E6
        cmp     eax, 15                                 ; 64F9 _ 83. F8, 0F
        jg      ?_0671                                  ; 64FC _ 0F 8F, 000010F3
        cmp     eax, 12                                 ; 6502 _ 83. F8, 0C
        jge     ?_0672                                  ; 6505 _ 0F 8D, 0000110E
        cmp     eax, 11                                 ; 650B _ 83. F8, 0B
        jg      ?_0671                                  ; 650E _ 0F 8F, 000010E1
        cmp     eax, 8                                  ; 6514 _ 83. F8, 08
        jge     ?_0588                                  ; 6517 _ 7D, 74
        cmp     eax, 4                                  ; 6519 _ 83. F8, 04
        jg      ?_0585                                  ; 651C _ 7F, 09
        test    eax, eax                                ; 651E _ 85. C0
        jg      ?_0586                                  ; 6520 _ 7F, 13
        jmp     ?_0671                                  ; 6522 _ E9, 000010CE

?_0585: sub     eax, 5                                  ; 6527 _ 83. E8, 05
        cmp     eax, 2                                  ; 652A _ 83. F8, 02
        ja      ?_0671                                  ; 652D _ 0F 87, 000010C2
        jmp     ?_0587                                  ; 6533 _ EB, 46

?_0586: mov     rdx, qword [rbp-0B0H]                   ; 6535 _ 48: 8B. 95, FFFFFF50
        mov     rax, qword [rbp-0A8H]                   ; 653C _ 48: 8B. 85, FFFFFF58
        mov     rsi, rdx                                ; 6543 _ 48: 89. D6
        mov     rdi, rax                                ; 6546 _ 48: 89. C7
        call    emit_rex                                ; 6549 _ E8, FFFFF168
        movzx   edx, byte [rbp-9EH]                     ; 654E _ 0F B6. 95, FFFFFF62
        mov     rcx, qword [rbp-58H]                    ; 6555 _ 48: 8B. 4D, A8
        mov     rax, qword [rbp-0A8H]                   ; 6559 _ 48: 8B. 85, FFFFFF58
        mov     rsi, rcx                                ; 6560 _ 48: 89. CE
        mov     rdi, rax                                ; 6563 _ 48: 89. C7
        call    out_rawdata                             ; 6566 _ E8, FFFFAFD9
        movzx   eax, byte [rbp-9EH]                     ; 656B _ 0F B6. 85, FFFFFF62
        add     qword [rbp-58H], rax                    ; 6572 _ 48: 01. 45, A8
        jmp     ?_0672                                  ; 6576 _ E9, 0000109E

?_0587: movzx   eax, byte [rbp-9EH]                     ; 657B _ 0F B6. 85, FFFFFF62
        mov     byte [rbp-9DH], al                      ; 6582 _ 88. 85, FFFFFF63
        jmp     ?_0672                                  ; 6588 _ E9, 0000108C

?_0588: mov     rdx, qword [rbp-0B0H]                   ; 658D _ 48: 8B. 95, FFFFFF50
        mov     rax, qword [rbp-0A8H]                   ; 6594 _ 48: 8B. 85, FFFFFF58
        mov     rsi, rdx                                ; 659B _ 48: 89. D6
        mov     rdi, rax                                ; 659E _ 48: 89. C7
        call    emit_rex                                ; 65A1 _ E8, FFFFF110
        mov     rax, qword [rbp-58H]                    ; 65A6 _ 48: 8B. 45, A8
        lea     rdx, [rax+1H]                           ; 65AA _ 48: 8D. 50, 01
        mov     qword [rbp-58H], rdx                    ; 65AE _ 48: 89. 55, A8
        movzx   ebx, byte [rax]                         ; 65B2 _ 0F B6. 18
        mov     rax, qword [rbp-60H]                    ; 65B5 _ 48: 8B. 45, A0
        mov     rdi, rax                                ; 65B9 _ 48: 89. C7
        call    regval                                  ; 65BC _ E8, 000010D5
        and     eax, 07H                                ; 65C1 _ 83. E0, 07
        add     eax, ebx                                ; 65C4 _ 01. D8
        movzx   edx, al                                 ; 65C6 _ 0F B6. D0
        mov     rax, qword [rbp-0A8H]                   ; 65C9 _ 48: 8B. 85, FFFFFF58
        mov     esi, edx                                ; 65D0 _ 89. D6
        mov     rdi, rax                                ; 65D2 _ 48: 89. C7
        call    out_rawbyte                             ; 65D5 _ E8, FFFFAFB9
        jmp     ?_0672                                  ; 65DA _ E9, 0000103A

?_0589: mov     rsi, qword [rbp-60H]                    ; 65DF _ 48: 8B. 75, A0
        mov     rax, qword [rbp-0A8H]                   ; 65E3 _ 48: 8B. 85, FFFFFF58
        mov     ecx, 0                                  ; 65EA _ B9, 00000000
        mov     edx, 1                                  ; 65EF _ BA, 00000001
        mov     rdi, rax                                ; 65F4 _ 48: 89. C7
        call    out_imm                                 ; 65F7 _ E8, FFFFB11D
        jmp     ?_0672                                  ; 65FC _ E9, 00001018

?_0590: mov     rsi, qword [rbp-60H]                    ; 6601 _ 48: 8B. 75, A0
        mov     rax, qword [rbp-0A8H]                   ; 6605 _ 48: 8B. 85, FFFFFF58
        mov     ecx, 2                                  ; 660C _ B9, 00000002
        mov     edx, 1                                  ; 6611 _ BA, 00000001
        mov     rdi, rax                                ; 6616 _ 48: 89. C7
        call    out_imm                                 ; 6619 _ E8, FFFFB0FB
        jmp     ?_0672                                  ; 661E _ E9, 00000FF6

?_0591: mov     rsi, qword [rbp-60H]                    ; 6623 _ 48: 8B. 75, A0
        mov     rax, qword [rbp-0A8H]                   ; 6627 _ 48: 8B. 85, FFFFFF58
        mov     ecx, 0                                  ; 662E _ B9, 00000000
        mov     edx, 2                                  ; 6633 _ BA, 00000002
        mov     rdi, rax                                ; 6638 _ 48: 89. C7
        call    out_imm                                 ; 663B _ E8, FFFFB0D9
        jmp     ?_0672                                  ; 6640 _ E9, 00000FD4

?_0592: mov     rax, qword [rbp-60H]                    ; 6645 _ 48: 8B. 45, A0
        mov     rax, qword [rax]                        ; 6649 _ 48: 8B. 00
        mov     rdx, qword 600000000H                   ; 664C _ 48: BA, 0000000600000000
        and     rax, rdx                                ; 6656 _ 48: 21. D0
        test    rax, rax                                ; 6659 _ 48: 85. C0
        jz      ?_0594                                  ; 665C _ 74, 2D
        mov     rax, qword [rbp-60H]                    ; 665E _ 48: 8B. 45, A0
        mov     rax, qword [rax]                        ; 6662 _ 48: 8B. 00
        mov     rdx, qword 200000000H                   ; 6665 _ 48: BA, 0000000200000000
        and     rax, rdx                                ; 666F _ 48: 21. D0
        test    rax, rax                                ; 6672 _ 48: 85. C0
        jz      ?_0593                                  ; 6675 _ 74, 0A
        mov     qword [rbp-68H], 2                      ; 6677 _ 48: C7. 45, 98, 00000002
        jmp     ?_0596                                  ; 667F _ EB, 2B

?_0593: mov     qword [rbp-68H], 4                      ; 6681 _ 48: C7. 45, 98, 00000004
        jmp     ?_0596                                  ; 6689 _ EB, 21

?_0594: mov     rax, qword [rbp-0B0H]                   ; 668B _ 48: 8B. 85, FFFFFF50
        movzx   eax, byte [rax+7BH]                     ; 6692 _ 0F B6. 40, 7B
        cmp     al, 16                                  ; 6696 _ 3C, 10
        jnz     ?_0595                                  ; 6698 _ 75, 0A
        mov     qword [rbp-68H], 2                      ; 669A _ 48: C7. 45, 98, 00000002
        jmp     ?_0596                                  ; 66A2 _ EB, 08

?_0595: mov     qword [rbp-68H], 4                      ; 66A4 _ 48: C7. 45, 98, 00000004
?_0596: mov     rax, qword [rbp-68H]                    ; 66AC _ 48: 8B. 45, 98
        mov     edx, eax                                ; 66B0 _ 89. C2
        mov     rsi, qword [rbp-60H]                    ; 66B2 _ 48: 8B. 75, A0
        mov     rax, qword [rbp-0A8H]                   ; 66B6 _ 48: 8B. 85, FFFFFF58
        mov     ecx, 0                                  ; 66BD _ B9, 00000000
        mov     rdi, rax                                ; 66C2 _ 48: 89. C7
        call    out_imm                                 ; 66C5 _ E8, FFFFB04F
        jmp     ?_0672                                  ; 66CA _ E9, 00000F4A

?_0597: mov     rsi, qword [rbp-60H]                    ; 66CF _ 48: 8B. 75, A0
        mov     rax, qword [rbp-0A8H]                   ; 66D3 _ 48: 8B. 85, FFFFFF58
        mov     ecx, 0                                  ; 66DA _ B9, 00000000
        mov     edx, 4                                  ; 66DF _ BA, 00000004
        mov     rdi, rax                                ; 66E4 _ 48: 89. C7
        call    out_imm                                 ; 66E7 _ E8, FFFFB02D
        jmp     ?_0672                                  ; 66EC _ E9, 00000F28

?_0598: mov     rax, qword [rbp-0B0H]                   ; 66F1 _ 48: 8B. 85, FFFFFF50
        movzx   eax, byte [rax+7CH]                     ; 66F8 _ 0F B6. 40, 7C
        shr     al, 3                                   ; 66FC _ C0. E8, 03
        movzx   eax, al                                 ; 66FF _ 0F B6. C0
        mov     qword [rbp-68H], rax                    ; 6702 _ 48: 89. 45, 98
        mov     rax, qword [rbp-68H]                    ; 6706 _ 48: 8B. 45, 98
        mov     edx, eax                                ; 670A _ 89. C2
        mov     rsi, qword [rbp-60H]                    ; 670C _ 48: 8B. 75, A0
        mov     rax, qword [rbp-0A8H]                   ; 6710 _ 48: 8B. 85, FFFFFF58
        mov     ecx, 0                                  ; 6717 _ B9, 00000000
        mov     rdi, rax                                ; 671C _ 48: 89. C7
        call    out_imm                                 ; 671F _ E8, FFFFAFF5
        jmp     ?_0672                                  ; 6724 _ E9, 00000EF0

?_0599: mov     rax, qword [rbp-60H]                    ; 6729 _ 48: 8B. 45, A0
        mov     edx, dword [rax+24H]                    ; 672D _ 8B. 50, 24
        mov     rax, qword [rbp-0A8H]                   ; 6730 _ 48: 8B. 85, FFFFFF58
        mov     eax, dword [rax+8H]                     ; 6737 _ 8B. 40, 08
        cmp     edx, eax                                ; 673A _ 39. C2
        jnz     ?_0600                                  ; 673C _ 75, 75
        mov     rax, qword [rbp-0B0H]                   ; 673E _ 48: 8B. 85, FFFFFF50
        movzx   eax, byte [rax+7BH]                     ; 6745 _ 0F B6. 40, 7B
        movzx   eax, al                                 ; 6749 _ 0F B6. C0
        mov     rdx, qword [rbp-60H]                    ; 674C _ 48: 8B. 55, A0
        mov     rcx, qword [rdx+28H]                    ; 6750 _ 48: 8B. 4A, 28
        mov     rdx, qword [rbp-0A8H]                   ; 6754 _ 48: 8B. 95, FFFFFF58
        mov     rdx, qword [rdx]                        ; 675B _ 48: 8B. 12
        sub     rcx, rdx                                ; 675E _ 48: 29. D1
        mov     rsi, rcx                                ; 6761 _ 48: 89. CE
        mov     rdx, qword [rbp-0A8H]                   ; 6764 _ 48: 8B. 95, FFFFFF58
        mov     ecx, dword [rdx+18H]                    ; 676B _ 8B. 4A, 18
        mov     rdx, qword [rbp-0A8H]                   ; 676E _ 48: 8B. 95, FFFFFF58
        mov     edx, dword [rdx+1CH]                    ; 6775 _ 8B. 52, 1C
        sub     ecx, edx                                ; 6778 _ 29. D1
        movsxd  rcx, ecx                                ; 677A _ 48: 63. C9
        sub     rsi, rcx                                ; 677D _ 48: 29. CE
        mov     rdx, rsi                                ; 6780 _ 48: 89. F2
        mov     esi, eax                                ; 6783 _ 89. C6
        mov     rdi, rdx                                ; 6785 _ 48: 89. D7
        call    sext                                    ; 6788 _ E8, FFFF988D
        mov     qword [rbp-28H], rax                    ; 678D _ 48: 89. 45, D8
        mov     rax, qword [rbp-28H]                    ; 6791 _ 48: 8B. 45, D8
        movsx   rax, al                                 ; 6795 _ 48: 0F BE. C0
        cmp     qword [rbp-28H], rax                    ; 6799 _ 48: 39. 45, D8
        jz      ?_0600                                  ; 679D _ 74, 14
        lea     rax, [rel ?_1099]                       ; 679F _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 67A6 _ 48: 89. C7
        mov     eax, 0                                  ; 67A9 _ B8, 00000000
        call    nasm_nonfatal                           ; 67AE _ E8, 00000000(PLT r)
?_0600: mov     rcx, qword [rbp-60H]                    ; 67B3 _ 48: 8B. 4D, A0
        mov     rax, qword [rbp-0A8H]                   ; 67B7 _ 48: 8B. 85, FFFFFF58
        mov     edx, 1                                  ; 67BE _ BA, 00000001
        mov     rsi, rcx                                ; 67C3 _ 48: 89. CE
        mov     rdi, rax                                ; 67C6 _ 48: 89. C7
        call    out_reladdr                             ; 67C9 _ E8, FFFFB025
        jmp     ?_0672                                  ; 67CE _ E9, 00000E46

?_0601: mov     rsi, qword [rbp-60H]                    ; 67D3 _ 48: 8B. 75, A0
        mov     rax, qword [rbp-0A8H]                   ; 67D7 _ 48: 8B. 85, FFFFFF58
        mov     ecx, 0                                  ; 67DE _ B9, 00000000
        mov     edx, 8                                  ; 67E3 _ BA, 00000008
        mov     rdi, rax                                ; 67E8 _ 48: 89. C7
        call    out_imm                                 ; 67EB _ E8, FFFFAF29
        jmp     ?_0672                                  ; 67F0 _ E9, 00000E24

?_0602: mov     rcx, qword [rbp-60H]                    ; 67F5 _ 48: 8B. 4D, A0
        mov     rax, qword [rbp-0A8H]                   ; 67F9 _ 48: 8B. 85, FFFFFF58
        mov     edx, 2                                  ; 6800 _ BA, 00000002
        mov     rsi, rcx                                ; 6805 _ 48: 89. CE
        mov     rdi, rax                                ; 6808 _ 48: 89. C7
        call    out_reladdr                             ; 680B _ E8, FFFFAFE3
        jmp     ?_0672                                  ; 6810 _ E9, 00000E04

?_0603: mov     rax, qword [rbp-60H]                    ; 6815 _ 48: 8B. 45, A0
        mov     rax, qword [rax]                        ; 6819 _ 48: 8B. 00
        mov     rdx, qword 0E00000000H                  ; 681C _ 48: BA, 0000000E00000000
        and     rax, rdx                                ; 6826 _ 48: 21. D0
        test    rax, rax                                ; 6829 _ 48: 85. C0
        jz      ?_0605                                  ; 682C _ 74, 2D
        mov     rax, qword [rbp-60H]                    ; 682E _ 48: 8B. 45, A0
        mov     rax, qword [rax]                        ; 6832 _ 48: 8B. 00
        mov     rdx, qword 200000000H                   ; 6835 _ 48: BA, 0000000200000000
        and     rax, rdx                                ; 683F _ 48: 21. D0
        test    rax, rax                                ; 6842 _ 48: 85. C0
        jz      ?_0604                                  ; 6845 _ 74, 0A
        mov     qword [rbp-68H], 2                      ; 6847 _ 48: C7. 45, 98, 00000002
        jmp     ?_0607                                  ; 684F _ EB, 2B

?_0604: mov     qword [rbp-68H], 4                      ; 6851 _ 48: C7. 45, 98, 00000004
        jmp     ?_0607                                  ; 6859 _ EB, 21

?_0605: mov     rax, qword [rbp-0B0H]                   ; 685B _ 48: 8B. 85, FFFFFF50
        movzx   eax, byte [rax+7BH]                     ; 6862 _ 0F B6. 40, 7B
        cmp     al, 16                                  ; 6866 _ 3C, 10
        jnz     ?_0606                                  ; 6868 _ 75, 0A
        mov     qword [rbp-68H], 2                      ; 686A _ 48: C7. 45, 98, 00000002
        jmp     ?_0607                                  ; 6872 _ EB, 08

?_0606: mov     qword [rbp-68H], 4                      ; 6874 _ 48: C7. 45, 98, 00000004
?_0607: mov     rax, qword [rbp-68H]                    ; 687C _ 48: 8B. 45, 98
        mov     edx, eax                                ; 6880 _ 89. C2
        mov     rcx, qword [rbp-60H]                    ; 6882 _ 48: 8B. 4D, A0
        mov     rax, qword [rbp-0A8H]                   ; 6886 _ 48: 8B. 85, FFFFFF58
        mov     rsi, rcx                                ; 688D _ 48: 89. CE
        mov     rdi, rax                                ; 6890 _ 48: 89. C7
        call    out_reladdr                             ; 6893 _ E8, FFFFAF5B
        jmp     ?_0672                                  ; 6898 _ E9, 00000D7C

?_0608: mov     rcx, qword [rbp-60H]                    ; 689D _ 48: 8B. 4D, A0
        mov     rax, qword [rbp-0A8H]                   ; 68A1 _ 48: 8B. 85, FFFFFF58
        mov     edx, 4                                  ; 68A8 _ BA, 00000004
        mov     rsi, rcx                                ; 68AD _ 48: 89. CE
        mov     rdi, rax                                ; 68B0 _ 48: 89. C7
        call    out_reladdr                             ; 68B3 _ E8, FFFFAF3B
        jmp     ?_0672                                  ; 68B8 _ E9, 00000D5C

?_0609: mov     rax, qword [rbp-60H]                    ; 68BD _ 48: 8B. 45, A0
        mov     eax, dword [rax+24H]                    ; 68C1 _ 8B. 40, 24
        cmp     eax, -1                                 ; 68C4 _ 83. F8, FF
        jnz     ?_0610                                  ; 68C7 _ 75, 14
        lea     rax, [rel ?_1100]                       ; 68C9 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 68D0 _ 48: 89. C7
        mov     eax, 0                                  ; 68D3 _ B8, 00000000
        call    nasm_nonfatal                           ; 68D8 _ E8, 00000000(PLT r)
?_0610: mov     rdx, qword [rbp-60H]                    ; 68DD _ 48: 8B. 55, A0
        mov     rax, qword [rbp-0A8H]                   ; 68E1 _ 48: 8B. 85, FFFFFF58
        mov     rsi, rdx                                ; 68E8 _ 48: 89. D6
        mov     rdi, rax                                ; 68EB _ 48: 89. C7
        call    out_farseg                              ; 68EE _ E8, FFFFAD89
        jmp     ?_0672                                  ; 68F3 _ E9, 00000D21

?_0611: mov     rax, qword [rbp-58H]                    ; 68F8 _ 48: 8B. 45, A8
        lea     rdx, [rax+1H]                           ; 68FC _ 48: 8D. 50, 01
        mov     qword [rbp-58H], rdx                    ; 6900 _ 48: 89. 55, A8
        movzx   eax, byte [rax]                         ; 6904 _ 0F B6. 00
        mov     byte [rbp-9EH], al                      ; 6907 _ 88. 85, FFFFFF62
        mov     eax, dword [rbp-8CH]                    ; 690D _ 8B. 85, FFFFFF74
        and     eax, 0FFFFFFFCH                         ; 6913 _ 83. E0, FC
        mov     edx, eax                                ; 6916 _ 89. C2
        movzx   eax, byte [rbp-9EH]                     ; 6918 _ 0F B6. 85, FFFFFF62
        shr     al, 3                                   ; 691F _ C0. E8, 03
        movzx   eax, al                                 ; 6922 _ 0F B6. C0
        and     eax, 03H                                ; 6925 _ 83. E0, 03
        or      eax, edx                                ; 6928 _ 09. D0
        mov     dword [rbp-8CH], eax                    ; 692A _ 89. 85, FFFFFF74
        mov     eax, dword [rbp-8CH]                    ; 6930 _ 8B. 85, FFFFFF74
        movsxd  rdx, eax                                ; 6936 _ 48: 63. D0
        mov     rax, rdx                                ; 6939 _ 48: 89. D0
        shl     rax, 3                                  ; 693C _ 48: C1. E0, 03
        add     rax, rdx                                ; 6940 _ 48: 01. D0
        shl     rax, 3                                  ; 6943 _ 48: C1. E0, 03
        lea     rdx, [rax+0C0H]                         ; 6947 _ 48: 8D. 90, 000000C0
        mov     rax, qword [rbp-0B0H]                   ; 694E _ 48: 8B. 85, FFFFFF50
        add     rax, rdx                                ; 6955 _ 48: 01. D0
        mov     qword [rbp-60H], rax                    ; 6958 _ 48: 89. 45, A0
        mov     rax, qword [rbp-60H]                    ; 695C _ 48: 8B. 45, A0
        mov     eax, dword [rax+10H]                    ; 6960 _ 8B. 40, 10
        cdqe                                            ; 6963 _ 48: 98
        lea     rdx, [rax*4]                            ; 6965 _ 48: 8D. 14 85, 00000000
        lea     rax, [rel nasm_regvals]                 ; 696D _ 48: 8D. 05, 00000000(rel)
        mov     eax, dword [rdx+rax]                    ; 6974 _ 8B. 04 02
        mov     dword [rbp-70H], eax                    ; 6977 _ 89. 45, 90
        movzx   eax, byte [rbp-9EH]                     ; 697A _ 0F B6. 85, FFFFFF62
        and     eax, 0FFFFFFC7H                         ; 6981 _ 83. E0, C7
        mov     edx, eax                                ; 6984 _ 89. C2
        mov     eax, dword [rbp-70H]                    ; 6986 _ 8B. 45, 90
        shl     eax, 3                                  ; 6989 _ C1. E0, 03
        and     eax, 38H                                ; 698C _ 83. E0, 38
        or      eax, edx                                ; 698F _ 09. D0
        mov     byte [rbp-9EH], al                      ; 6991 _ 88. 85, FFFFFF62
        movzx   edx, byte [rbp-9EH]                     ; 6997 _ 0F B6. 95, FFFFFF62
        mov     rax, qword [rbp-0A8H]                   ; 699E _ 48: 8B. 85, FFFFFF58
        mov     esi, edx                                ; 69A5 _ 89. D6
        mov     rdi, rax                                ; 69A7 _ 48: 89. C7
        call    out_rawbyte                             ; 69AA _ E8, FFFFABE4
        jmp     ?_0672                                  ; 69AF _ E9, 00000C65

?_0612: mov     rax, qword [rbp-0B0H]                   ; 69B4 _ 48: 8B. 85, FFFFFF50
        mov     eax, dword [rax+30H]                    ; 69BB _ 8B. 40, 30
        cmp     eax, 366                                ; 69BE _ 3D, 0000016E
        jnz     ?_0613                                  ; 69C3 _ 75, 0C
        mov     dword [rbp-98H], 7                      ; 69C5 _ C7. 85, FFFFFF68, 00000007
        jmp     ?_0614                                  ; 69CF _ EB, 0A

?_0613: mov     dword [rbp-98H], 15                     ; 69D1 _ C7. 85, FFFFFF68, 0000000F
?_0614: mov     rax, qword [rbp-58H]                    ; 69DB _ 48: 8B. 45, A8
        lea     rdx, [rax+1H]                           ; 69DF _ 48: 8D. 50, 01
        mov     qword [rbp-58H], rdx                    ; 69E3 _ 48: 89. 55, A8
        movzx   eax, byte [rax]                         ; 69E7 _ 0F B6. 00
        mov     byte [rbp-9EH], al                      ; 69EA _ 88. 85, FFFFFF62
        movzx   eax, byte [rbp-9EH]                     ; 69F0 _ 0F B6. 85, FFFFFF62
        shr     al, 3                                   ; 69F7 _ C0. E8, 03
        movzx   eax, al                                 ; 69FA _ 0F B6. C0
        and     eax, 07H                                ; 69FD _ 83. E0, 07
        mov     dword [rbp-90H], eax                    ; 6A00 _ 89. 85, FFFFFF70
        mov     edx, dword [rbp-90H]                    ; 6A06 _ 8B. 95, FFFFFF70
        mov     rax, qword [rbp-0B0H]                   ; 6A0C _ 48: 8B. 85, FFFFFF50
        mov     esi, edx                                ; 6A13 _ 89. D6
        mov     rdi, rax                                ; 6A15 _ 48: 89. C7
        call    get_operand                             ; 6A18 _ E8, FFFF9DD4
        mov     qword [rbp-60H], rax                    ; 6A1D _ 48: 89. 45, A0
        movzx   eax, byte [rbp-9EH]                     ; 6A21 _ 0F B6. 85, FFFFFF62
        and     eax, 07H                                ; 6A28 _ 83. E0, 07
        mov     dword [rbp-8CH], eax                    ; 6A2B _ 89. 85, FFFFFF74
        mov     edx, dword [rbp-8CH]                    ; 6A31 _ 8B. 95, FFFFFF74
        mov     rax, qword [rbp-0B0H]                   ; 6A37 _ 48: 8B. 85, FFFFFF50
        mov     esi, edx                                ; 6A3E _ 89. D6
        mov     rdi, rax                                ; 6A40 _ 48: 89. C7
        call    get_operand                             ; 6A43 _ E8, FFFF9DA9
        mov     qword [rbp-30H], rax                    ; 6A48 _ 48: 89. 45, D0
        mov     rax, qword [rbp-30H]                    ; 6A4C _ 48: 8B. 45, D0
        mov     rdi, rax                                ; 6A50 _ 48: 89. C7
        call    absolute_op                             ; 6A53 _ E8, FFFF9E1F
        xor     eax, 01H                                ; 6A58 _ 83. F0, 01
        test    al, al                                  ; 6A5B _ 84. C0
        jz      ?_0615                                  ; 6A5D _ 74, 1E
        mov     eax, dword [rbp-8CH]                    ; 6A5F _ 8B. 85, FFFFFF74
        lea     rdx, [rel ?_1101]                       ; 6A65 _ 48: 8D. 15, 00000000(rel)
        mov     esi, eax                                ; 6A6C _ 89. C6
        mov     rdi, rdx                                ; 6A6E _ 48: 89. D7
        mov     eax, 0                                  ; 6A71 _ B8, 00000000
        call    nasm_nonfatal                           ; 6A76 _ E8, 00000000(PLT r)
        jmp     ?_0616                                  ; 6A7B _ EB, 4C

?_0615: mov     rax, qword [rbp-30H]                    ; 6A7D _ 48: 8B. 45, D0
        mov     rdx, qword [rax+28H]                    ; 6A81 _ 48: 8B. 50, 28
        mov     eax, dword [rbp-98H]                    ; 6A85 _ 8B. 85, FFFFFF68
        not     eax                                     ; 6A8B _ F7. D0
        cdqe                                            ; 6A8D _ 48: 98
        and     rax, rdx                                ; 6A8F _ 48: 21. D0
        test    rax, rax                                ; 6A92 _ 48: 85. C0
        jz      ?_0616                                  ; 6A95 _ 74, 32
        mov     dword [rbp-74H], 983040                 ; 6A97 _ C7. 45, 8C, 000F0000
        mov     eax, dword [rbp-74H]                    ; 6A9E _ 8B. 45, 8C
        mov     edi, eax                                ; 6AA1 _ 89. C7
        call    warn_active                             ; 6AA3 _ E8, FFFF97AB
        movzx   eax, al                                 ; 6AA8 _ 0F B6. C0
        test    rax, rax                                ; 6AAB _ 48: 85. C0
        jz      ?_0616                                  ; 6AAE _ 74, 19
        lea     rdx, [rel ?_1102]                       ; 6AB0 _ 48: 8D. 15, 00000000(rel)
        mov     eax, dword [rbp-74H]                    ; 6AB7 _ 8B. 45, 8C
        mov     rsi, rdx                                ; 6ABA _ 48: 89. D6
        mov     edi, eax                                ; 6ABD _ 89. C7
        mov     eax, 0                                  ; 6ABF _ B8, 00000000
        call    nasm_warn_                              ; 6AC4 _ E8, 00000000(PLT r)
?_0616: mov     rax, qword [rbp-30H]                    ; 6AC9 _ 48: 8B. 45, D0
        mov     rax, qword [rax+28H]                    ; 6ACD _ 48: 8B. 40, 28
        mov     edx, eax                                ; 6AD1 _ 89. C2
        mov     eax, dword [rbp-98H]                    ; 6AD3 _ 8B. 85, FFFFFF68
        and     eax, edx                                ; 6AD9 _ 21. D0
        mov     byte [rbp-9EH], al                      ; 6ADB _ 88. 85, FFFFFF62
        jmp     ?_0619                                  ; 6AE1 _ EB, 53

?_0617: mov     rax, qword [rbp-58H]                    ; 6AE3 _ 48: 8B. 45, A8
        lea     rdx, [rax+1H]                           ; 6AE7 _ 48: 8D. 50, 01
        mov     qword [rbp-58H], rdx                    ; 6AEB _ 48: 89. 55, A8
        movzx   eax, byte [rax]                         ; 6AEF _ 0F B6. 00
        mov     byte [rbp-9EH], al                      ; 6AF2 _ 88. 85, FFFFFF62
        movzx   eax, byte [rbp-9EH]                     ; 6AF8 _ 0F B6. 85, FFFFFF62
        shr     al, 4                                   ; 6AFF _ C0. E8, 04
        movzx   eax, al                                 ; 6B02 _ 0F B6. C0
        mov     dword [rbp-90H], eax                    ; 6B05 _ 89. 85, FFFFFF70
        mov     edx, dword [rbp-90H]                    ; 6B0B _ 8B. 95, FFFFFF70
        mov     rax, qword [rbp-0B0H]                   ; 6B11 _ 48: 8B. 85, FFFFFF50
        mov     esi, edx                                ; 6B18 _ 89. D6
        mov     rdi, rax                                ; 6B1A _ 48: 89. C7
        call    get_operand                             ; 6B1D _ E8, FFFF9CCF
        mov     qword [rbp-60H], rax                    ; 6B22 _ 48: 89. 45, A0
        and     byte [rbp-9EH], 0FH                     ; 6B26 _ 80. A5, FFFFFF62, 0F
        jmp     ?_0619                                  ; 6B2D _ EB, 07

?_0618: mov     byte [rbp-9EH], 0                       ; 6B2F _ C6. 85, FFFFFF62, 00
?_0619: mov     rax, qword [rbp-60H]                    ; 6B36 _ 48: 8B. 45, A0
        mov     eax, dword [rax+10H]                    ; 6B3A _ 8B. 40, 10
        cdqe                                            ; 6B3D _ 48: 98
        lea     rdx, [rax*4]                            ; 6B3F _ 48: 8D. 14 85, 00000000
        lea     rax, [rel nasm_regvals]                 ; 6B47 _ 48: 8D. 05, 00000000(rel)
        mov     eax, dword [rdx+rax]                    ; 6B4E _ 8B. 04 02
        mov     dword [rbp-70H], eax                    ; 6B51 _ 89. 45, 90
        mov     eax, dword [rbp-70H]                    ; 6B54 _ 8B. 45, 90
        shl     eax, 4                                  ; 6B57 _ C1. E0, 04
        mov     edx, eax                                ; 6B5A _ 89. C2
        mov     eax, dword [rbp-70H]                    ; 6B5C _ 8B. 45, 90
        sar     eax, 1                                  ; 6B5F _ D1. F8
        and     eax, 08H                                ; 6B61 _ 83. E0, 08
        or      edx, eax                                ; 6B64 _ 09. C2
        movzx   eax, byte [rbp-9EH]                     ; 6B66 _ 0F B6. 85, FFFFFF62
        or      eax, edx                                ; 6B6D _ 09. D0
        movzx   edx, al                                 ; 6B6F _ 0F B6. D0
        mov     rax, qword [rbp-0A8H]                   ; 6B72 _ 48: 8B. 85, FFFFFF58
        mov     esi, edx                                ; 6B79 _ 89. D6
        mov     rdi, rax                                ; 6B7B _ 48: 89. C7
        call    out_rawbyte                             ; 6B7E _ E8, FFFFAA10
        jmp     ?_0672                                  ; 6B83 _ E9, 00000A91

?_0620: mov     rax, qword [rbp-0B0H]                   ; 6B88 _ 48: 8B. 85, FFFFFF50
        movzx   edx, byte [rax+7EH]                     ; 6B8F _ 0F B6. 50, 7E
        mov     rax, qword [rbp-0B0H]                   ; 6B93 _ 48: 8B. 85, FFFFFF50
        movzx   eax, byte [rax+7FH]                     ; 6B9A _ 0F B6. 40, 7F
        or      eax, edx                                ; 6B9E _ 09. D0
        mov     byte [rbp-99H], al                      ; 6BA0 _ 88. 85, FFFFFF67
        add     qword [rbp-58H], 4                      ; 6BA6 _ 48: 83. 45, A8, 04
        mov     rax, qword [rbp-0B0H]                   ; 6BAB _ 48: 8B. 85, FFFFFF50
        add     rax, 192                                ; 6BB2 _ 48: 05, 000000C0
        mov     esi, 2264924160                         ; 6BB8 _ BE, 87000000
        mov     rdi, rax                                ; 6BBD _ 48: 89. C7
        call    op_evexflags                            ; 6BC0 _ E8, 00000CDC
        mov     rdx, qword [rbp-0B0H]                   ; 6BC5 _ 48: 8B. 95, FFFFFF50
        mov     edx, dword [rdx+88H]                    ; 6BCC _ 8B. 92, 00000088
        xor     edx, eax                                ; 6BD2 _ 31. C2
        mov     rax, qword [rbp-0B0H]                   ; 6BD4 _ 48: 8B. 85, FFFFFF50
        mov     dword [rax+88H], edx                    ; 6BDB _ 89. 90, 00000088
        mov     rax, qword [rbp-0B0H]                   ; 6BE1 _ 48: 8B. 85, FFFFFF50
        mov     edx, dword [rax+88H]                    ; 6BE8 _ 8B. 90, 00000088
        mov     rax, qword [rbp-0B0H]                   ; 6BEE _ 48: 8B. 85, FFFFFF50
        mov     eax, dword [rax+84H]                    ; 6BF5 _ 8B. 80, 00000084
        shl     eax, 13                                 ; 6BFB _ C1. E0, 0D
        movzx   eax, ax                                 ; 6BFE _ 0F B7. C0
        xor     edx, eax                                ; 6C01 _ 31. C2
        mov     rax, qword [rbp-0B0H]                   ; 6C03 _ 48: 8B. 85, FFFFFF50
        mov     dword [rax+88H], edx                    ; 6C0A _ 89. 90, 00000088
        mov     rax, qword [rbp-0B0H]                   ; 6C10 _ 48: 8B. 85, FFFFFF50
        mov     eax, dword [rax+84H]                    ; 6C17 _ 8B. 80, 00000084
        and     eax, 1000H                              ; 6C1D _ 25, 00001000
        test    eax, eax                                ; 6C22 _ 85. C0
        jz      ?_0623                                  ; 6C24 _ 74, 3E
        mov     rax, qword [rbp-0B0H]                   ; 6C26 _ 48: 8B. 85, FFFFFF50
        mov     edx, dword [rax+88H]                    ; 6C2D _ 8B. 90, 00000088
        mov     rax, qword [rbp-0B0H]                   ; 6C33 _ 48: 8B. 85, FFFFFF50
        mov     eax, dword [rax+84H]                    ; 6C3A _ 8B. 80, 00000084
        and     eax, 10000H                             ; 6C40 _ 25, 00010000
        test    eax, eax                                ; 6C45 _ 85. C0
        jz      ?_0621                                  ; 6C47 _ 74, 07
        mov     eax, 16384                              ; 6C49 _ B8, 00004000
        jmp     ?_0622                                  ; 6C4E _ EB, 05

?_0621: mov     eax, 2048                               ; 6C50 _ B8, 00000800
?_0622: xor     edx, eax                                ; 6C55 _ 31. C2
        mov     rax, qword [rbp-0B0H]                   ; 6C57 _ 48: 8B. 85, FFFFFF50
        mov     dword [rax+88H], edx                    ; 6C5E _ 89. 90, 00000088
?_0623: mov     rax, qword [rbp-0B0H]                   ; 6C64 _ 48: 8B. 85, FFFFFF50
        mov     eax, dword [rax+84H]                    ; 6C6B _ 8B. 80, 00000084
        and     eax, 2000H                              ; 6C71 _ 25, 00002000
        test    eax, eax                                ; 6C76 _ 85. C0
        jz      ?_0626                                  ; 6C78 _ 74, 3E
        mov     rax, qword [rbp-0B0H]                   ; 6C7A _ 48: 8B. 85, FFFFFF50
        mov     edx, dword [rax+88H]                    ; 6C81 _ 8B. 90, 00000088
        mov     rax, qword [rbp-0B0H]                   ; 6C87 _ 48: 8B. 85, FFFFFF50
        mov     eax, dword [rax+84H]                    ; 6C8E _ 8B. 80, 00000084
        and     eax, 20000H                             ; 6C94 _ 25, 00020000
        test    eax, eax                                ; 6C99 _ 85. C0
        jz      ?_0624                                  ; 6C9B _ 74, 07
        mov     eax, 134217728                          ; 6C9D _ B8, 08000000
        jmp     ?_0625                                  ; 6CA2 _ EB, 05

?_0624: mov     eax, 262144                             ; 6CA4 _ B8, 00040000
?_0625: xor     edx, eax                                ; 6CA9 _ 31. C2
        mov     rax, qword [rbp-0B0H]                   ; 6CAB _ 48: 8B. 85, FFFFFF50
        mov     dword [rax+88H], edx                    ; 6CB2 _ 89. 90, 00000088
?_0626: mov     rax, qword [rbp-0B0H]                   ; 6CB8 _ 48: 8B. 85, FFFFFF50
        mov     eax, dword [rax+84H]                    ; 6CBF _ 8B. 80, 00000084
        and     eax, 4000H                              ; 6CC5 _ 25, 00004000
        test    eax, eax                                ; 6CCA _ 85. C0
        jz      ?_0627                                  ; 6CCC _ 74, 1F
        mov     rax, qword [rbp-0B0H]                   ; 6CCE _ 48: 8B. 85, FFFFFF50
        mov     eax, dword [rax+88H]                    ; 6CD5 _ 8B. 80, 00000088
        xor     ah, 10H                                 ; 6CDB _ 80. F4, 10
        mov     edx, eax                                ; 6CDE _ 89. C2
        mov     rax, qword [rbp-0B0H]                   ; 6CE0 _ 48: 8B. 85, FFFFFF50
        mov     dword [rax+88H], edx                    ; 6CE7 _ 89. 90, 00000088
?_0627: mov     rax, qword [rbp-0B0H]                   ; 6CED _ 48: 8B. 85, FFFFFF50
        mov     eax, dword [rax+84H]                    ; 6CF4 _ 8B. 80, 00000084
        and     eax, 08H                                ; 6CFA _ 83. E0, 08
        test    eax, eax                                ; 6CFD _ 85. C0
        jz      ?_0628                                  ; 6CFF _ 74, 21
        mov     rax, qword [rbp-0B0H]                   ; 6D01 _ 48: 8B. 85, FFFFFF50
        mov     eax, dword [rax+88H]                    ; 6D08 _ 8B. 80, 00000088
        or      eax, 800000H                            ; 6D0E _ 0D, 00800000
        mov     edx, eax                                ; 6D13 _ 89. C2
        mov     rax, qword [rbp-0B0H]                   ; 6D15 _ 48: 8B. 85, FFFFFF50
        mov     dword [rax+88H], edx                    ; 6D1C _ 89. 90, 00000088
?_0628: mov     rax, qword [rbp-0B0H]                   ; 6D22 _ 48: 8B. 85, FFFFFF50
        mov     eax, dword [rax+88H]                    ; 6D29 _ 8B. 80, 00000088
        movzx   edx, byte [rbp-99H]                     ; 6D2F _ 0F B6. 95, FFFFFF67
        shl     edx, 19                                 ; 6D36 _ C1. E2, 13
        and     edx, 780000H                            ; 6D39 _ 81. E2, 00780000
        xor     edx, eax                                ; 6D3F _ 31. C2
        mov     rax, qword [rbp-0B0H]                   ; 6D41 _ 48: 8B. 85, FFFFFF50
        mov     dword [rax+88H], edx                    ; 6D48 _ 89. 90, 00000088
        mov     rax, qword [rbp-0B0H]                   ; 6D4E _ 48: 8B. 85, FFFFFF50
        mov     eax, dword [rax+88H]                    ; 6D55 _ 8B. 80, 00000088
        movzx   edx, byte [rbp-99H]                     ; 6D5B _ 0F B6. 95, FFFFFF67
        shl     edx, 23                                 ; 6D62 _ C1. E2, 17
        and     edx, 8000000H                           ; 6D65 _ 81. E2, 08000000
        xor     edx, eax                                ; 6D6B _ 31. C2
        mov     rax, qword [rbp-0B0H]                   ; 6D6D _ 48: 8B. 85, FFFFFF50
        mov     dword [rax+88H], edx                    ; 6D74 _ 89. 90, 00000088
        mov     rax, qword [rbp-0B0H]                   ; 6D7A _ 48: 8B. 85, FFFFFF50
        mov     eax, dword [rax+34H]                    ; 6D81 _ 8B. 40, 34
        cmp     eax, 370                                ; 6D84 _ 3D, 00000172
        jne     ?_0630                                  ; 6D89 _ 0F 85, 00000091
        mov     rax, qword [rbp-0B0H]                   ; 6D8F _ 48: 8B. 85, FFFFFF50
        mov     rax, qword [rax+0B0H]                   ; 6D96 _ 48: 8B. 80, 000000B0
        mov     esi, 34                                 ; 6D9D _ BE, 00000022
        mov     rdi, rax                                ; 6DA2 _ 48: 89. C7
        call    itemp_has                               ; 6DA5 _ E8, FFFF9606
        test    al, al                                  ; 6DAA _ 84. C0
        jz      ?_0629                                  ; 6DAC _ 74, 21
        mov     rax, qword [rbp-0B0H]                   ; 6DAE _ 48: 8B. 85, FFFFFF50
        mov     eax, dword [rax+88H]                    ; 6DB5 _ 8B. 80, 00000088
        xor     eax, 4000000H                           ; 6DBB _ 35, 04000000
        mov     edx, eax                                ; 6DC0 _ 89. C2
        mov     rax, qword [rbp-0B0H]                   ; 6DC2 _ 48: 8B. 85, FFFFFF50
        mov     dword [rax+88H], edx                    ; 6DC9 _ 89. 90, 00000088
?_0629: mov     rax, qword [rbp-0B0H]                   ; 6DCF _ 48: 8B. 85, FFFFFF50
        mov     rax, qword [rax+0B0H]                   ; 6DD6 _ 48: 8B. 80, 000000B0
        mov     esi, 33                                 ; 6DDD _ BE, 00000021
        mov     rdi, rax                                ; 6DE2 _ 48: 89. C7
        call    itemp_has                               ; 6DE5 _ E8, FFFF95C6
        test    al, al                                  ; 6DEA _ 84. C0
        jz      ?_0630                                  ; 6DEC _ 74, 32
        mov     dword [rbp-78H], 4456448                ; 6DEE _ C7. 45, 88, 00440000
        mov     eax, dword [rbp-78H]                    ; 6DF5 _ 8B. 45, 88
        mov     edi, eax                                ; 6DF8 _ 89. C7
        call    warn_active                             ; 6DFA _ E8, FFFF9454
        movzx   eax, al                                 ; 6DFF _ 0F B6. C0
        test    rax, rax                                ; 6E02 _ 48: 85. C0
        jz      ?_0630                                  ; 6E05 _ 74, 19
        lea     rdx, [rel ?_1103]                       ; 6E07 _ 48: 8D. 15, 00000000(rel)
        mov     eax, dword [rbp-78H]                    ; 6E0E _ 8B. 45, 88
        mov     rsi, rdx                                ; 6E11 _ 48: 89. D6
        mov     edi, eax                                ; 6E14 _ 89. C7
        mov     eax, 0                                  ; 6E16 _ B8, 00000000
        call    nasm_warn_                              ; 6E1B _ E8, 00000000(PLT r)
?_0630: mov     rax, qword [rbp-0B0H]                   ; 6E20 _ 48: 8B. 85, FFFFFF50
        mov     eax, dword [rax+38H]                    ; 6E27 _ 8B. 40, 38
        cmp     eax, 371                                ; 6E2A _ 3D, 00000173
        jnz     ?_0631                                  ; 6E2F _ 75, 40
        mov     rax, qword [rbp-0B0H]                   ; 6E31 _ 48: 8B. 85, FFFFFF50
        mov     rax, qword [rax+0B0H]                   ; 6E38 _ 48: 8B. 80, 000000B0
        mov     esi, 37                                 ; 6E3F _ BE, 00000025
        mov     rdi, rax                                ; 6E44 _ 48: 89. C7
        call    itemp_has                               ; 6E47 _ E8, FFFF9564
        test    al, al                                  ; 6E4C _ 84. C0
        jz      ?_0631                                  ; 6E4E _ 74, 21
        mov     rax, qword [rbp-0B0H]                   ; 6E50 _ 48: 8B. 85, FFFFFF50
        mov     eax, dword [rax+88H]                    ; 6E57 _ 8B. 80, 00000088
        xor     eax, 10000000H                          ; 6E5D _ 35, 10000000
        mov     edx, eax                                ; 6E62 _ 89. C2
        mov     rax, qword [rbp-0B0H]                   ; 6E64 _ 48: 8B. 85, FFFFFF50
        mov     dword [rax+88H], edx                    ; 6E6B _ 89. 90, 00000088
?_0631: mov     rax, qword [rbp-0B0H]                   ; 6E71 _ 48: 8B. 85, FFFFFF50
        mov     edx, dword [rax+88H]                    ; 6E78 _ 8B. 90, 00000088
        mov     rax, qword [rbp-0A8H]                   ; 6E7E _ 48: 8B. 85, FFFFFF58
        mov     esi, edx                                ; 6E85 _ 89. D6
        mov     rdi, rax                                ; 6E87 _ 48: 89. C7
        call    out_rawdword                            ; 6E8A _ E8, FFFFA746
        jmp     ?_0672                                  ; 6E8F _ E9, 00000785

?_0632: mov     rsi, qword [rbp-60H]                    ; 6E94 _ 48: 8B. 75, A0
        mov     rax, qword [rbp-0A8H]                   ; 6E98 _ 48: 8B. 85, FFFFFF58
        mov     ecx, 1                                  ; 6E9F _ B9, 00000001
        mov     edx, 4                                  ; 6EA4 _ BA, 00000004
        mov     rdi, rax                                ; 6EA9 _ 48: 89. C7
        call    out_imm                                 ; 6EAC _ E8, FFFFA868
        jmp     ?_0672                                  ; 6EB1 _ E9, 00000763

?_0633: mov     rsi, qword [rbp-60H]                    ; 6EB6 _ 48: 8B. 75, A0
        mov     rax, qword [rbp-0A8H]                   ; 6EBA _ 48: 8B. 85, FFFFFF58
        mov     ecx, 2                                  ; 6EC1 _ B9, 00000002
        mov     edx, 4                                  ; 6EC6 _ BA, 00000004
        mov     rdi, rax                                ; 6ECB _ 48: 89. C7
        call    out_imm                                 ; 6ECE _ E8, FFFFA846
        jmp     ?_0672                                  ; 6ED3 _ E9, 00000741

?_0634: add     qword [rbp-58H], 2                      ; 6ED8 _ 48: 83. 45, A8, 02
        mov     rax, qword [rbp-0B0H]                   ; 6EDD _ 48: 8B. 85, FFFFFF50
        movzx   eax, byte [rax+80H]                     ; 6EE4 _ 0F B6. 80, 00000080
        cmp     al, 1                                   ; 6EEB _ 3C, 01
        jnz     ?_0635                                  ; 6EED _ 75, 29
        mov     rax, qword [rbp-0B0H]                   ; 6EEF _ 48: 8B. 85, FFFFFF50
        mov     eax, dword [rax+84H]                    ; 6EF6 _ 8B. 80, 00000084
        and     eax, 0BH                                ; 6EFC _ 83. E0, 0B
        test    eax, eax                                ; 6EFF _ 85. C0
        jnz     ?_0635                                  ; 6F01 _ 75, 15
        mov     rax, qword [rbp-0B0H]                   ; 6F03 _ 48: 8B. 85, FFFFFF50
        mov     eax, dword [rax+30H]                    ; 6F0A _ 8B. 40, 30
        cmp     eax, 368                                ; 6F0D _ 3D, 00000170
        jne     ?_0638                                  ; 6F12 _ 0F 85, 000000AB
?_0635: mov     rax, qword [rbp-0B0H]                   ; 6F18 _ 48: 8B. 85, FFFFFF50
        movzx   eax, byte [rax+80H]                     ; 6F1F _ 0F B6. 80, 00000080
        shr     al, 6                                   ; 6F26 _ C0. E8, 06
        test    al, al                                  ; 6F29 _ 84. C0
        jz      ?_0636                                  ; 6F2B _ 74, 07
        mov     eax, 4294967183                         ; 6F2D _ B8, FFFFFF8F
        jmp     ?_0637                                  ; 6F32 _ EB, 05

?_0636: mov     eax, 4294967236                         ; 6F34 _ B8, FFFFFFC4
?_0637: mov     byte [rbp-1CH], al                      ; 6F39 _ 88. 45, E4
        mov     rax, qword [rbp-0B0H]                   ; 6F3C _ 48: 8B. 85, FFFFFF50
        movzx   eax, byte [rax+80H]                     ; 6F43 _ 0F B6. 80, 00000080
        and     eax, 1FH                                ; 6F4A _ 83. E0, 1F
        mov     edx, eax                                ; 6F4D _ 89. C2
        mov     rax, qword [rbp-0B0H]                   ; 6F4F _ 48: 8B. 85, FFFFFF50
        mov     eax, dword [rax+84H]                    ; 6F56 _ 8B. 80, 00000084
        not     eax                                     ; 6F5C _ F7. D0
        shl     eax, 5                                  ; 6F5E _ C1. E0, 05
        or      eax, edx                                ; 6F61 _ 09. D0
        mov     byte [rbp-1BH], al                      ; 6F63 _ 88. 45, E5
        mov     rax, qword [rbp-0B0H]                   ; 6F66 _ 48: 8B. 85, FFFFFF50
        mov     eax, dword [rax+84H]                    ; 6F6D _ 8B. 80, 00000084
        shl     eax, 4                                  ; 6F73 _ C1. E0, 04
        and     eax, 0FFFFFF80H                         ; 6F76 _ 83. E0, 80
        mov     edx, eax                                ; 6F79 _ 89. C2
        mov     rax, qword [rbp-0B0H]                   ; 6F7B _ 48: 8B. 85, FFFFFF50
        movzx   eax, byte [rax+7EH]                     ; 6F82 _ 0F B6. 40, 7E
        not     eax                                     ; 6F86 _ F7. D0
        shl     eax, 3                                  ; 6F88 _ C1. E0, 03
        and     eax, 78H                                ; 6F8B _ 83. E0, 78
        or      edx, eax                                ; 6F8E _ 09. C2
        mov     rax, qword [rbp-0B0H]                   ; 6F90 _ 48: 8B. 85, FFFFFF50
        movzx   eax, byte [rax+81H]                     ; 6F97 _ 0F B6. 80, 00000081
        and     eax, 07H                                ; 6F9E _ 83. E0, 07
        or      eax, edx                                ; 6FA1 _ 09. D0
        mov     byte [rbp-1AH], al                      ; 6FA3 _ 88. 45, E6
        lea     rcx, [rbp-1CH]                          ; 6FA6 _ 48: 8D. 4D, E4
        mov     rax, qword [rbp-0A8H]                   ; 6FAA _ 48: 8B. 85, FFFFFF58
        mov     edx, 3                                  ; 6FB1 _ BA, 00000003
        mov     rsi, rcx                                ; 6FB6 _ 48: 89. CE
        mov     rdi, rax                                ; 6FB9 _ 48: 89. C7
        call    out_rawdata                             ; 6FBC _ E8, FFFFA583
        jmp     ?_0639                                  ; 6FC1 _ EB, 61

?_0638: mov     byte [rbp-1CH], 197                     ; 6FC3 _ C6. 45, E4, C5
        mov     rax, qword [rbp-0B0H]                   ; 6FC7 _ 48: 8B. 85, FFFFFF50
        mov     eax, dword [rax+84H]                    ; 6FCE _ 8B. 80, 00000084
        not     eax                                     ; 6FD4 _ F7. D0
        shl     eax, 5                                  ; 6FD6 _ C1. E0, 05
        and     eax, 0FFFFFF80H                         ; 6FD9 _ 83. E0, 80
        mov     edx, eax                                ; 6FDC _ 89. C2
        mov     rax, qword [rbp-0B0H]                   ; 6FDE _ 48: 8B. 85, FFFFFF50
        movzx   eax, byte [rax+7EH]                     ; 6FE5 _ 0F B6. 40, 7E
        not     eax                                     ; 6FE9 _ F7. D0
        shl     eax, 3                                  ; 6FEB _ C1. E0, 03
        and     eax, 78H                                ; 6FEE _ 83. E0, 78
        or      edx, eax                                ; 6FF1 _ 09. C2
        mov     rax, qword [rbp-0B0H]                   ; 6FF3 _ 48: 8B. 85, FFFFFF50
        movzx   eax, byte [rax+81H]                     ; 6FFA _ 0F B6. 80, 00000081
        and     eax, 07H                                ; 7001 _ 83. E0, 07
        or      eax, edx                                ; 7004 _ 09. D0
        mov     byte [rbp-1BH], al                      ; 7006 _ 88. 45, E5
        lea     rcx, [rbp-1CH]                          ; 7009 _ 48: 8D. 4D, E4
        mov     rax, qword [rbp-0A8H]                   ; 700D _ 48: 8B. 85, FFFFFF58
        mov     edx, 2                                  ; 7014 _ BA, 00000002
        mov     rsi, rcx                                ; 7019 _ 48: 89. CE
        mov     rdi, rax                                ; 701C _ 48: 89. C7
        call    out_rawdata                             ; 701F _ E8, FFFFA520
?_0639: jmp     ?_0672                                  ; 7024 _ E9, 000005F0

?_0640: mov     rax, qword [rbp-60H]                    ; 7029 _ 48: 8B. 45, A0
        mov     rdi, rax                                ; 702D _ 48: 89. C7
        call    absolute_op                             ; 7030 _ E8, FFFF9842
        test    al, al                                  ; 7035 _ 84. C0
        je      ?_0647                                  ; 7037 _ 0F 84, 000000FF
        mov     rax, qword [rbp-0B0H]                   ; 703D _ 48: 8B. 85, FFFFFF50
        movzx   eax, byte [rax+7BH]                     ; 7044 _ 0F B6. 40, 7B
        movzx   eax, al                                 ; 7048 _ 0F B6. C0
        mov     dword [rbp-80H], eax                    ; 704B _ 89. 45, 80
        mov     eax, dword [rbp-80H]                    ; 704E _ 8B. 45, 80
        sub     eax, 1                                  ; 7051 _ 83. E8, 01
        mov     edx, 2                                  ; 7054 _ BA, 00000002
        mov     ecx, eax                                ; 7059 _ 89. C1
        shl     rdx, cl                                 ; 705B _ 48: D3. E2
        mov     rax, rdx                                ; 705E _ 48: 89. D0
        mov     qword [rbp-40H], rax                    ; 7061 _ 48: 89. 45, C0
        mov     rax, qword [rbp-60H]                    ; 7065 _ 48: 8B. 45, A0
        mov     rax, qword [rax+28H]                    ; 7069 _ 48: 8B. 40, 28
        mov     qword [rbp-38H], rax                    ; 706D _ 48: 89. 45, C8
        cmp     qword [rbp-38H], 127                    ; 7071 _ 48: 83. 7D, C8, 7F
        jbe     ?_0646                                  ; 7076 _ 0F 86, 000000A3
        cmp     qword [rbp-38H], -129                   ; 707C _ 48: 81. 7D, C8, FFFFFF7F
        ja      ?_0646                                  ; 7084 _ 0F 87, 00000095
        mov     rax, qword [rbp-40H]                    ; 708A _ 48: 8B. 45, C0
        add     rax, -128                               ; 708E _ 48: 83. C0, 80
        cmp     qword [rbp-38H], rax                    ; 7092 _ 48: 39. 45, C8
        jc      ?_0641                                  ; 7096 _ 72, 0E
        mov     rax, qword [rbp-40H]                    ; 7098 _ 48: 8B. 45, C0
        sub     rax, 1                                  ; 709C _ 48: 83. E8, 01
        cmp     rax, qword [rbp-38H]                    ; 70A0 _ 48: 3B. 45, C8
        jnc     ?_0646                                  ; 70A4 _ 73, 79
?_0641: mov     dword [rbp-7CH], 983296                 ; 70A6 _ C7. 45, 84, 000F0100
        mov     eax, dword [rbp-7CH]                    ; 70AD _ 8B. 45, 84
        mov     edi, eax                                ; 70B0 _ 89. C7
        call    warn_active                             ; 70B2 _ E8, FFFF919C
        movzx   eax, al                                 ; 70B7 _ 0F B6. C0
        test    rax, rax                                ; 70BA _ 48: 85. C0
        jz      ?_0646                                  ; 70BD _ 74, 60
        mov     rax, qword [rbp-60H]                    ; 70BF _ 48: 8B. 45, A0
        mov     rax, qword [rax]                        ; 70C3 _ 48: 8B. 00
        mov     rdx, qword 100000000H                   ; 70C6 _ 48: BA, 0000000100000000
        and     rax, rdx                                ; 70D0 _ 48: 21. D0
        test    rax, rax                                ; 70D3 _ 48: 85. C0
        jnz     ?_0644                                  ; 70D6 _ 75, 27
        cmp     dword [rbp-80H], 16                     ; 70D8 _ 83. 7D, 80, 10
        jz      ?_0643                                  ; 70DC _ 74, 18
        cmp     dword [rbp-80H], 32                     ; 70DE _ 83. 7D, 80, 20
        jnz     ?_0642                                  ; 70E2 _ 75, 09
        lea     rax, [rel ?_1002]                       ; 70E4 _ 48: 8D. 05, 00000000(rel)
        jmp     ?_0645                                  ; 70EB _ EB, 19

?_0642: lea     rax, [rel ?_1104]                       ; 70ED _ 48: 8D. 05, 00000000(rel)
        jmp     ?_0645                                  ; 70F4 _ EB, 10

?_0643: lea     rax, [rel ?_1001]                       ; 70F6 _ 48: 8D. 05, 00000000(rel)
        jmp     ?_0645                                  ; 70FD _ EB, 07

?_0644: lea     rax, [rel ?_1105]                       ; 70FF _ 48: 8D. 05, 00000000(rel)
?_0645: lea     rsi, [rel ?_1106]                       ; 7106 _ 48: 8D. 35, 00000000(rel)
        mov     ecx, dword [rbp-7CH]                    ; 710D _ 8B. 4D, 84
        mov     rdx, rax                                ; 7110 _ 48: 89. C2
        mov     edi, ecx                                ; 7113 _ 89. CF
        mov     eax, 0                                  ; 7115 _ B8, 00000000
        call    nasm_warn_                              ; 711A _ E8, 00000000(PLT r)
?_0646: mov     rax, qword [rbp-38H]                    ; 711F _ 48: 8B. 45, C8
        movzx   edx, al                                 ; 7123 _ 0F B6. D0
        mov     rax, qword [rbp-0A8H]                   ; 7126 _ 48: 8B. 85, FFFFFF58
        mov     esi, edx                                ; 712D _ 89. D6
        mov     rdi, rax                                ; 712F _ 48: 89. C7
        call    out_rawbyte                             ; 7132 _ E8, FFFFA45C
        jmp     ?_0672                                  ; 7137 _ E9, 000004DD

?_0647: mov     rsi, qword [rbp-60H]                    ; 713C _ 48: 8B. 75, A0
        mov     rax, qword [rbp-0A8H]                   ; 7140 _ 48: 8B. 85, FFFFFF58
        mov     ecx, 0                                  ; 7147 _ B9, 00000000
        mov     edx, 1                                  ; 714C _ BA, 00000001
        mov     rdi, rax                                ; 7151 _ 48: 89. C7
        call    out_imm                                 ; 7154 _ E8, FFFFA5C0
        jmp     ?_0672                                  ; 7159 _ E9, 000004BB

?_0648: mov     rdx, qword [rbp-0B0H]                   ; 715E _ 48: 8B. 95, FFFFFF50
        mov     rax, qword [rbp-0A8H]                   ; 7165 _ 48: 8B. 85, FFFFFF58
        mov     rsi, rdx                                ; 716C _ 48: 89. D6
        mov     rdi, rax                                ; 716F _ 48: 89. C7
        call    emit_rex                                ; 7172 _ E8, FFFFE53F
        mov     rax, qword [rbp-60H]                    ; 7177 _ 48: 8B. 45, A0
        mov     rdi, rax                                ; 717B _ 48: 89. C7
        call    absolute_op                             ; 717E _ E8, FFFF96F4
        test    al, al                                  ; 7183 _ 84. C0
        jz      ?_0650                                  ; 7185 _ 74, 73
        mov     rax, qword [rbp-60H]                    ; 7187 _ 48: 8B. 45, A0
        mov     rax, qword [rax+28H]                    ; 718B _ 48: 8B. 40, 28
        mov     rdi, rax                                ; 718F _ 48: 89. C7
        call    is_hint_nop                             ; 7192 _ E8, 00000000(PLT r)
        xor     eax, 01H                                ; 7197 _ 83. F0, 01
        test    al, al                                  ; 719A _ 84. C0
        jz      ?_0649                                  ; 719C _ 74, 3B
        mov     dword [rbp-84H], 0                      ; 719E _ C7. 85, FFFFFF7C, 00000000
        mov     eax, dword [rbp-84H]                    ; 71A8 _ 8B. 85, FFFFFF7C
        mov     edi, eax                                ; 71AE _ 89. C7
        call    warn_active                             ; 71B0 _ E8, FFFF909E
        movzx   eax, al                                 ; 71B5 _ 0F B6. C0
        test    rax, rax                                ; 71B8 _ 48: 85. C0
        jz      ?_0649                                  ; 71BB _ 74, 1C
        lea     rdx, [rel ?_1107]                       ; 71BD _ 48: 8D. 15, 00000000(rel)
        mov     eax, dword [rbp-84H]                    ; 71C4 _ 8B. 85, FFFFFF7C
        mov     rsi, rdx                                ; 71CA _ 48: 89. D6
        mov     edi, eax                                ; 71CD _ 89. C7
        mov     eax, 0                                  ; 71CF _ B8, 00000000
        call    nasm_warn_                              ; 71D4 _ E8, 00000000(PLT r)
?_0649: mov     rax, qword [rbp-60H]                    ; 71D9 _ 48: 8B. 45, A0
        mov     rax, qword [rax+28H]                    ; 71DD _ 48: 8B. 40, 28
        movzx   edx, al                                 ; 71E1 _ 0F B6. D0
        mov     rax, qword [rbp-0A8H]                   ; 71E4 _ 48: 8B. 85, FFFFFF58
        mov     esi, edx                                ; 71EB _ 89. D6
        mov     rdi, rax                                ; 71ED _ 48: 89. C7
        call    out_rawbyte                             ; 71F0 _ E8, FFFFA39E
        jmp     ?_0672                                  ; 71F5 _ E9, 0000041F

?_0650: mov     rsi, qword [rbp-60H]                    ; 71FA _ 48: 8B. 75, A0
        mov     rax, qword [rbp-0A8H]                   ; 71FE _ 48: 8B. 85, FFFFFF58
        mov     ecx, 2                                  ; 7205 _ B9, 00000002
        mov     edx, 1                                  ; 720A _ BA, 00000001
        mov     rdi, rax                                ; 720F _ 48: 89. C7
        call    out_imm                                 ; 7212 _ E8, FFFFA502
        jmp     ?_0672                                  ; 7217 _ E9, 000003FD

?_0651: mov     rax, qword [rbp-58H]                    ; 721C _ 48: 8B. 45, A8
        lea     rdx, [rax+1H]                           ; 7220 _ 48: 8D. 50, 01
        mov     qword [rbp-58H], rdx                    ; 7224 _ 48: 89. 55, A8
        movzx   eax, byte [rax]                         ; 7228 _ 0F B6. 00
        mov     byte [rbp-9BH], al                      ; 722B _ 88. 85, FFFFFF65
        mov     rax, qword [rbp-58H]                    ; 7231 _ 48: 8B. 45, A8
        lea     rdx, [rax+1H]                           ; 7235 _ 48: 8D. 50, 01
        mov     qword [rbp-58H], rdx                    ; 7239 _ 48: 89. 55, A8
        movzx   eax, byte [rax]                         ; 723D _ 0F B6. 00
        mov     byte [rbp-9AH], al                      ; 7240 _ 88. 85, FFFFFF66
        movzx   eax, byte [rbp-9BH]                     ; 7246 _ 0F B6. 85, FFFFFF65
        and     eax, 03H                                ; 724D _ 83. E0, 03
        mov     dword [rbp-88H], eax                    ; 7250 _ 89. 85, FFFFFF78
        cmp     byte [rbp-9BH], 2                       ; 7256 _ 80. BD, FFFFFF65, 02
        seta    al                                      ; 725D _ 0F 97. C0
        movzx   eax, al                                 ; 7260 _ 0F B6. C0
        test    rax, rax                                ; 7263 _ 48: 85. C0
        jz      ?_0652                                  ; 7266 _ 74, 22
        lea     rdx, [rel ?_1013]                       ; 7268 _ 48: 8D. 15, 00000000(rel)
        lea     rsi, [rel __func__.4]                   ; 726F _ 48: 8D. 35, 00000000(rel)
        lea     rax, [rel ?_1108]                       ; 7276 _ 48: 8D. 05, 00000000(rel)
        mov     ecx, 2686                               ; 727D _ B9, 00000A7E
        mov     rdi, rax                                ; 7282 _ 48: 89. C7
        call    nasm_assert_failed                      ; 7285 _ E8, 00000000(PLT r)
?_0652: mov     rax, qword [rbp-60H]                    ; 728A _ 48: 8B. 45, A0
        mov     rdi, rax                                ; 728E _ 48: 89. C7
        call    absolute_op                             ; 7291 _ E8, FFFF95E1
        xor     eax, 01H                                ; 7296 _ 83. F0, 01
        movzx   eax, al                                 ; 7299 _ 0F B6. C0
        test    rax, rax                                ; 729C _ 48: 85. C0
        jz      ?_0653                                  ; 729F _ 74, 22
        lea     rdx, [rel ?_1013]                       ; 72A1 _ 48: 8D. 15, 00000000(rel)
        lea     rsi, [rel __func__.4]                   ; 72A8 _ 48: 8D. 35, 00000000(rel)
        lea     rax, [rel ?_1109]                       ; 72AF _ 48: 8D. 05, 00000000(rel)
        mov     ecx, 2687                               ; 72B6 _ B9, 00000A7F
        mov     rdi, rax                                ; 72BB _ 48: 89. C7
        call    nasm_assert_failed                      ; 72BE _ E8, 00000000(PLT r)
?_0653: mov     rax, qword [rbp-60H]                    ; 72C3 _ 48: 8B. 45, A0
        mov     rax, qword [rax+28H]                    ; 72C7 _ 48: 8B. 40, 28
        lea     rcx, [rel ?_1000]                       ; 72CB _ 48: 8D. 0D, 00000000(rel)
        mov     edx, dword [rbp-88H]                    ; 72D2 _ 8B. 95, FFFFFF78
        mov     esi, 1                                  ; 72D8 _ BE, 00000001
        mov     rdi, rax                                ; 72DD _ 48: 89. C7
        call    warn_overflow_out                       ; 72E0 _ E8, FFFF97FF
        mov     rax, qword [rbp-60H]                    ; 72E5 _ 48: 8B. 45, A0
        mov     rax, qword [rax+28H]                    ; 72E9 _ 48: 8B. 40, 28
        mov     edx, eax                                ; 72ED _ 89. C2
        movzx   eax, byte [rbp-9AH]                     ; 72EF _ 0F B6. 85, FFFFFF66
        xor     eax, edx                                ; 72F6 _ 31. D0
        movzx   edx, al                                 ; 72F8 _ 0F B6. D0
        mov     rax, qword [rbp-0A8H]                   ; 72FB _ 48: 8B. 85, FFFFFF58
        mov     esi, edx                                ; 7302 _ 89. D6
        mov     rdi, rax                                ; 7304 _ 48: 89. C7
        call    out_rawbyte                             ; 7307 _ E8, FFFFA287
        jmp     ?_0672                                  ; 730C _ E9, 00000308

?_0654: mov     rax, qword [rbp-60H]                    ; 7311 _ 48: 8B. 45, A0
        mov     eax, dword [rax+24H]                    ; 7315 _ 8B. 40, 24
        cmp     eax, -1                                 ; 7318 _ 83. F8, FF
        jz      ?_0655                                  ; 731B _ 74, 14
        lea     rax, [rel ?_1110]                       ; 731D _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 7324 _ 48: 89. C7
        mov     eax, 0                                  ; 7327 _ B8, 00000000
        call    nasm_panic                              ; 732C _ E8, 00000000(PLT r)
?_0655: mov     rax, qword [rbp-0B0H]                   ; 7331 _ 48: 8B. 85, FFFFFF50
        mov     rbx, qword [rax+0E8H]                   ; 7338 _ 48: 8B. 98, 000000E8
        mov     rax, qword [rbp-0B0H]                   ; 733F _ 48: 8B. 85, FFFFFF50
        mov     eax, dword [rax]                        ; 7346 _ 8B. 00
        mov     edi, eax                                ; 7348 _ 89. C7
        call    resb_bytes                              ; 734A _ E8, FFFF90DE
        cdqe                                            ; 734F _ 48: 98
        imul    rax, rbx                                ; 7351 _ 48: 0F AF. C3
        mov     rdx, rax                                ; 7355 _ 48: 89. C2
        mov     rax, qword [rbp-0A8H]                   ; 7358 _ 48: 8B. 85, FFFFFF58
        mov     rsi, rdx                                ; 735F _ 48: 89. D6
        mov     rdi, rax                                ; 7362 _ 48: 89. C7
        call    out_reserve                             ; 7365 _ E8, FFFFA2DC
        jmp     ?_0672                                  ; 736A _ E9, 000002AA

?_0656: cmp     dword [rbp-94H], 16                     ; 736F _ 83. BD, FFFFFF6C, 10
        jnz     ?_0657                                  ; 7376 _ 75, 07
        mov     eax, 3                                  ; 7378 _ B8, 00000003
        jmp     ?_0658                                  ; 737D _ EB, 05

?_0657: mov     eax, 5                                  ; 737F _ B8, 00000005
?_0658: movzx   edx, al                                 ; 7384 _ 0F B6. D0
        mov     rax, qword [rbp-0A8H]                   ; 7387 _ 48: 8B. 85, FFFFFF58
        mov     esi, edx                                ; 738E _ 89. D6
        mov     rdi, rax                                ; 7390 _ 48: 89. C7
        call    out_rawbyte                             ; 7393 _ E8, FFFFA1FB
        jmp     ?_0672                                  ; 7398 _ E9, 0000027C

?_0659: mov     edx, dword [rbp-8CH]                    ; 739D _ 8B. 95, FFFFFF74
        mov     rax, qword [rbp-0B0H]                   ; 73A3 _ 48: 8B. 85, FFFFFF50
        mov     esi, edx                                ; 73AA _ 89. D6
        mov     rdi, rax                                ; 73AC _ 48: 89. C7
        call    get_operand                             ; 73AF _ E8, FFFF943D
        mov     qword [rbp-48H], rax                    ; 73B4 _ 48: 89. 45, B8
        lea     rax, [rbp-1CH]                          ; 73B8 _ 48: 8D. 45, E4
        mov     qword [rbp-50H], rax                    ; 73BC _ 48: 89. 45, B0
        mov     rax, qword [rbp-50H]                    ; 73C0 _ 48: 8B. 45, B0
        lea     rdx, [rax+1H]                           ; 73C4 _ 48: 8D. 50, 01
        mov     qword [rbp-50H], rdx                    ; 73C8 _ 48: 89. 55, B0
        mov     rdx, qword [rbp-0B0H]                   ; 73CC _ 48: 8B. 95, FFFFFF50
        movzx   edx, byte [rdx+0A3H]                    ; 73D3 _ 0F B6. 92, 000000A3
        mov     byte [rax], dl                          ; 73DA _ 88. 10
        mov     rax, qword [rbp-0B0H]                   ; 73DC _ 48: 8B. 85, FFFFFF50
        movzx   eax, byte [rax+0A0H]                    ; 73E3 _ 0F B6. 80, 000000A0
        test    al, al                                  ; 73EA _ 84. C0
        jz      ?_0660                                  ; 73EC _ 74, 1C
        mov     rax, qword [rbp-50H]                    ; 73EE _ 48: 8B. 45, B0
        lea     rdx, [rax+1H]                           ; 73F2 _ 48: 8D. 50, 01
        mov     qword [rbp-50H], rdx                    ; 73F6 _ 48: 89. 55, B0
        mov     rdx, qword [rbp-0B0H]                   ; 73FA _ 48: 8B. 95, FFFFFF50
        movzx   edx, byte [rdx+0A4H]                    ; 7401 _ 0F B6. 92, 000000A4
        mov     byte [rax], dl                          ; 7408 _ 88. 10
?_0660: lea     rax, [rbp-1CH]                          ; 740A _ 48: 8D. 45, E4
        mov     rdx, qword [rbp-50H]                    ; 740E _ 48: 8B. 55, B0
        sub     rdx, rax                                ; 7412 _ 48: 29. C2
        lea     rcx, [rbp-1CH]                          ; 7415 _ 48: 8D. 4D, E4
        mov     rax, qword [rbp-0A8H]                   ; 7419 _ 48: 8B. 85, FFFFFF58
        mov     rsi, rcx                                ; 7420 _ 48: 89. CE
        mov     rdi, rax                                ; 7423 _ 48: 89. C7
        call    out_rawdata                             ; 7426 _ E8, FFFFA119
        mov     rax, qword [rbp-0B0H]                   ; 742B _ 48: 8B. 85, FFFFFF50
        movzx   eax, byte [rax+0A1H]                    ; 7432 _ 0F B6. 80, 000000A1
        movzx   eax, al                                 ; 7439 _ 0F B6. C0
        test    eax, eax                                ; 743C _ 85. C0
        jz      ?_0661                                  ; 743E _ 74, 07
        cmp     eax, 1                                  ; 7440 _ 83. F8, 01
        jz      ?_0662                                  ; 7443 _ 74, 0E
        jmp     ?_0663                                  ; 7445 _ EB, 5C

?_0661: mov     byte [rbp-9CH], 0                       ; 7447 _ C6. 85, FFFFFF64, 00
        jmp     ?_0670                                  ; 744E _ E9, 00000173

?_0662: mov     rax, qword [rbp-0B0H]                   ; 7453 _ 48: 8B. 85, FFFFFF50
        movzx   eax, byte [rax+0A6H]                    ; 745A _ 0F B6. 80, 000000A6
        movzx   edx, al                                 ; 7461 _ 0F B6. D0
        mov     rax, qword [rbp-0A8H]                   ; 7464 _ 48: 8B. 85, FFFFFF58
        mov     esi, edx                                ; 746B _ 89. D6
        mov     rdi, rax                                ; 746D _ 48: 89. C7
        call    out_rawbyte                             ; 7470 _ E8, FFFFA11E
        mov     rax, qword [rbp-0B0H]                   ; 7475 _ 48: 8B. 85, FFFFFF50
        movzx   eax, byte [rax+0A8H]                    ; 747C _ 0F B6. 80, 000000A8
        movzx   eax, al                                 ; 7483 _ 0F B6. C0
        test    eax, eax                                ; 7486 _ 85. C0
        setne   al                                      ; 7488 _ 0F 95. C0
        xor     eax, 01H                                ; 748B _ 83. F0, 01
        movzx   eax, al                                 ; 748E _ 0F B6. C0
        mov     byte [rbp-9CH], al                      ; 7491 _ 88. 85, FFFFFF64
        and     byte [rbp-9CH], 01H                     ; 7497 _ 80. A5, FFFFFF64, 01
        jmp     ?_0670                                  ; 749E _ E9, 00000123

?_0663: mov     rax, qword [rbp-0B0H]                   ; 74A3 _ 48: 8B. 85, FFFFFF50
        movzx   eax, byte [rax+0A5H]                    ; 74AA _ 0F B6. 80, 000000A5
        test    al, al                                  ; 74B1 _ 84. C0
        jz      ?_0664                                  ; 74B3 _ 74, 33
        mov     rax, qword [rbp-0B0H]                   ; 74B5 _ 48: 8B. 85, FFFFFF50
        movzx   eax, byte [rax+0A1H]                    ; 74BC _ 0F B6. 80, 000000A1
        movzx   edx, al                                 ; 74C3 _ 0F B6. D0
        mov     rcx, qword [rbp-48H]                    ; 74C6 _ 48: 8B. 4D, B8
        mov     rax, qword [rbp-0A8H]                   ; 74CA _ 48: 8B. 85, FFFFFF58
        mov     rsi, rcx                                ; 74D1 _ 48: 89. CE
        mov     rdi, rax                                ; 74D4 _ 48: 89. C7
        call    out_reladdr                             ; 74D7 _ E8, FFFFA317
        mov     byte [rbp-9CH], 0                       ; 74DC _ C6. 85, FFFFFF64, 00
        jmp     ?_0670                                  ; 74E3 _ E9, 000000DE

?_0664: mov     rax, qword [rbp-0B0H]                   ; 74E8 _ 48: 8B. 85, FFFFFF50
        movzx   eax, byte [rax+7CH]                     ; 74EF _ 0F B6. 40, 7C
        shr     al, 3                                   ; 74F3 _ C0. E8, 03
        movzx   eax, al                                 ; 74F6 _ 0F B6. C0
        mov     dword [rbp-6CH], eax                    ; 74F9 _ 89. 45, 94
        mov     rax, qword [rbp-0B0H]                   ; 74FC _ 48: 8B. 85, FFFFFF50
        movzx   eax, byte [rax+0A1H]                    ; 7503 _ 0F B6. 80, 000000A1
        movzx   eax, al                                 ; 750A _ 0F B6. C0
        cmp     eax, dword [rbp-6CH]                    ; 750D _ 3B. 45, 94
        jnc     ?_0665                                  ; 7510 _ 73, 07
        mov     ecx, 5                                  ; 7512 _ B9, 00000005
        jmp     ?_0666                                  ; 7517 _ EB, 05

?_0665: mov     ecx, 4                                  ; 7519 _ B9, 00000004
?_0666: mov     rax, qword [rbp-0B0H]                   ; 751E _ 48: 8B. 85, FFFFFF50
        movzx   eax, byte [rax+0A1H]                    ; 7525 _ 0F B6. 80, 000000A1
        movzx   edx, al                                 ; 752C _ 0F B6. D0
        mov     rsi, qword [rbp-48H]                    ; 752F _ 48: 8B. 75, B8
        mov     rax, qword [rbp-0A8H]                   ; 7533 _ 48: 8B. 85, FFFFFF58
        mov     rdi, rax                                ; 753A _ 48: 89. C7
        call    out_imm                                 ; 753D _ E8, FFFFA1D7
        mov     rax, qword [rbp-48H]                    ; 7542 _ 48: 8B. 45, B8
        mov     rax, qword [rax+28H]                    ; 7546 _ 48: 8B. 40, 28
        mov     edx, dword [rbp-6CH]                    ; 754A _ 8B. 55, 94
        mov     esi, edx                                ; 754D _ 89. D6
        mov     rdi, rax                                ; 754F _ 48: 89. C7
        call    overflow_general                        ; 7552 _ E8, FFFF8BB5
        test    al, al                                  ; 7557 _ 84. C0
        jnz     ?_0667                                  ; 7559 _ 75, 52
        mov     rax, qword [rbp-0B0H]                   ; 755B _ 48: 8B. 85, FFFFFF50
        movzx   eax, byte [rax+7CH]                     ; 7562 _ 0F B6. 40, 7C
        movzx   edx, al                                 ; 7566 _ 0F B6. D0
        mov     rax, qword [rbp-48H]                    ; 7569 _ 48: 8B. 45, B8
        mov     rax, qword [rax+28H]                    ; 756D _ 48: 8B. 40, 28
        mov     esi, edx                                ; 7571 _ 89. D6
        mov     rdi, rax                                ; 7573 _ 48: 89. C7
        call    sext                                    ; 7576 _ E8, FFFF8A9F
        mov     rbx, rax                                ; 757B _ 48: 89. C3
        mov     rax, qword [rbp-0B0H]                   ; 757E _ 48: 8B. 85, FFFFFF50
        movzx   eax, byte [rax+0A1H]                    ; 7585 _ 0F B6. 80, 000000A1
        movzx   eax, al                                 ; 758C _ 0F B6. C0
        lea     edx, [rax*8]                            ; 758F _ 8D. 14 C5, 00000000
        mov     rax, qword [rbp-48H]                    ; 7596 _ 48: 8B. 45, B8
        mov     rax, qword [rax+28H]                    ; 759A _ 48: 8B. 40, 28
        mov     esi, edx                                ; 759E _ 89. D6
        mov     rdi, rax                                ; 75A0 _ 48: 89. C7
        call    sext                                    ; 75A3 _ E8, FFFF8A72
        cmp     rbx, rax                                ; 75A8 _ 48: 39. C3
        jz      ?_0668                                  ; 75AB _ 74, 07
?_0667: mov     eax, 1                                  ; 75AD _ B8, 00000001
        jmp     ?_0669                                  ; 75B2 _ EB, 05

?_0668: mov     eax, 0                                  ; 75B4 _ B8, 00000000
?_0669: mov     byte [rbp-9CH], al                      ; 75B9 _ 88. 85, FFFFFF64
        and     byte [rbp-9CH], 01H                     ; 75BF _ 80. A5, FFFFFF64, 01
?_0670: cmp     byte [rbp-9CH], 0                       ; 75C6 _ 80. BD, FFFFFF64, 00
        jz      ?_0672                                  ; 75CD _ 74, 4A
        mov     rax, qword [rbp-0B0H]                   ; 75CF _ 48: 8B. 85, FFFFFF50
        movzx   eax, byte [rax+0A1H]                    ; 75D6 _ 0F B6. 80, 000000A1
        movzx   eax, al                                 ; 75DD _ 0F B6. C0
        lea     rdx, [rel ?_1111]                       ; 75E0 _ 48: 8D. 15, 00000000(rel)
        mov     esi, 0                                  ; 75E7 _ BE, 00000000
        mov     edi, eax                                ; 75EC _ 89. C7
        call    warn_overflow                           ; 75EE _ E8, FFFF940C
        jmp     ?_0672                                  ; 75F3 _ EB, 24

?_0671: movzx   edx, byte [rbp-9EH]                     ; 75F5 _ 0F B6. 95, FFFFFF62
        movzx   eax, byte [rbp-9EH]                     ; 75FC _ 0F B6. 85, FFFFFF62
        lea     rcx, [rel ?_1077]                       ; 7603 _ 48: 8D. 0D, 00000000(rel)
        mov     esi, eax                                ; 760A _ 89. C6
        mov     rdi, rcx                                ; 760C _ 48: 89. CF
        mov     eax, 0                                  ; 760F _ B8, 00000000
        call    nasm_panic                              ; 7614 _ E8, 00000000(PLT r)
?_0672: mov     rax, qword [rbp-58H]                    ; 7619 _ 48: 8B. 45, A8
        movzx   eax, byte [rax]                         ; 761D _ 0F B6. 00
        test    al, al                                  ; 7620 _ 84. C0
        jne     ?_0584                                  ; 7622 _ 0F 85, FFFFE9C4
        nop                                             ; 7628 _ 90
        mov     rax, qword [rbp-18H]                    ; 7629 _ 48: 8B. 45, E8
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        sub     rax, qword [fs:abs 28H]                 ; 762D _ 64 48: 2B. 04 25, 00000028
        jz      ?_0673                                  ; 7636 _ 74, 05
        call    __stack_chk_fail                        ; 7638 _ E8, 00000000(PLT r)
?_0673: mov     rbx, qword [rbp-8H]                     ; 763D _ 48: 8B. 5D, F8
        leave                                           ; 7641 _ C9
        ret                                             ; 7642 _ C3

regflag:; Local function
        push    rbp                                     ; 7643 _ 55
        mov     rbp, rsp                                ; 7644 _ 48: 89. E5
        sub     rsp, 16                                 ; 7647 _ 48: 83. EC, 10
        mov     qword [rbp-8H], rdi                     ; 764B _ 48: 89. 7D, F8
        mov     rax, qword [rbp-8H]                     ; 764F _ 48: 8B. 45, F8
        mov     eax, dword [rax+10H]                    ; 7653 _ 8B. 40, 10
        mov     edi, eax                                ; 7656 _ 89. C7
        call    is_register                             ; 7658 _ E8, FFFF8B1E
        xor     eax, 01H                                ; 765D _ 83. F0, 01
        test    al, al                                  ; 7660 _ 84. C0
        jz      ?_0674                                  ; 7662 _ 74, 14
        lea     rax, [rel ?_1112]                       ; 7664 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 766B _ 48: 89. C7
        mov     eax, 0                                  ; 766E _ B8, 00000000
        call    nasm_panic                              ; 7673 _ E8, 00000000(PLT r)
?_0674: mov     rax, qword [rbp-8H]                     ; 7678 _ 48: 8B. 45, F8
        mov     eax, dword [rax+10H]                    ; 767C _ 8B. 40, 10
        cdqe                                            ; 767F _ 48: 98
        lea     rdx, [rax*8]                            ; 7681 _ 48: 8D. 14 C5, 00000000
        lea     rax, [rel nasm_reg_flags]               ; 7689 _ 48: 8D. 05, 00000000(rel)
        mov     rax, qword [rdx+rax]                    ; 7690 _ 48: 8B. 04 02
        leave                                           ; 7694 _ C9
        ret                                             ; 7695 _ C3

regval: ; Local function
        push    rbp                                     ; 7696 _ 55
        mov     rbp, rsp                                ; 7697 _ 48: 89. E5
        sub     rsp, 16                                 ; 769A _ 48: 83. EC, 10
        mov     qword [rbp-8H], rdi                     ; 769E _ 48: 89. 7D, F8
        mov     rax, qword [rbp-8H]                     ; 76A2 _ 48: 8B. 45, F8
        mov     rax, qword [rax]                        ; 76A6 _ 48: 8B. 00
        and     eax, 02H                                ; 76A9 _ 83. E0, 02
        test    rax, rax                                ; 76AC _ 48: 85. C0
        jz      ?_0675                                  ; 76AF _ 74, 0A
        mov     rax, qword [rbp-8H]                     ; 76B1 _ 48: 8B. 45, F8
        mov     rax, qword [rax+28H]                    ; 76B5 _ 48: 8B. 40, 28
        jmp     ?_0677                                  ; 76B9 _ EB, 44

?_0675: mov     rax, qword [rbp-8H]                     ; 76BB _ 48: 8B. 45, F8
        mov     eax, dword [rax+10H]                    ; 76BF _ 8B. 40, 10
        mov     edi, eax                                ; 76C2 _ 89. C7
        call    is_register                             ; 76C4 _ E8, FFFF8AB2
        xor     eax, 01H                                ; 76C9 _ 83. F0, 01
        test    al, al                                  ; 76CC _ 84. C0
        jz      ?_0676                                  ; 76CE _ 74, 14
        lea     rax, [rel ?_1113]                       ; 76D0 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 76D7 _ 48: 89. C7
        mov     eax, 0                                  ; 76DA _ B8, 00000000
        call    nasm_panic                              ; 76DF _ E8, 00000000(PLT r)
?_0676: mov     rax, qword [rbp-8H]                     ; 76E4 _ 48: 8B. 45, F8
        mov     eax, dword [rax+10H]                    ; 76E8 _ 8B. 40, 10
        cdqe                                            ; 76EB _ 48: 98
        lea     rdx, [rax*4]                            ; 76ED _ 48: 8D. 14 85, 00000000
        lea     rax, [rel nasm_regvals]                 ; 76F5 _ 48: 8D. 05, 00000000(rel)
        mov     eax, dword [rdx+rax]                    ; 76FC _ 8B. 04 02
?_0677: leave                                           ; 76FF _ C9
        ret                                             ; 7700 _ C3

op_rexflags:; Local function
        push    rbp                                     ; 7701 _ 55
        mov     rbp, rsp                                ; 7702 _ 48: 89. E5
        sub     rsp, 32                                 ; 7705 _ 48: 83. EC, 20
        mov     qword [rbp-18H], rdi                    ; 7709 _ 48: 89. 7D, E8
        mov     dword [rbp-1CH], esi                    ; 770D _ 89. 75, E4
        mov     rax, qword [rbp-18H]                    ; 7710 _ 48: 8B. 45, E8
        mov     eax, dword [rax+10H]                    ; 7714 _ 8B. 40, 10
        mov     edi, eax                                ; 7717 _ 89. C7
        call    is_register                             ; 7719 _ E8, FFFF8A5D
        xor     eax, 01H                                ; 771E _ 83. F0, 01
        test    al, al                                  ; 7721 _ 84. C0
        jz      ?_0678                                  ; 7723 _ 74, 14
        lea     rax, [rel ?_1114]                       ; 7725 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 772C _ 48: 89. C7
        mov     eax, 0                                  ; 772F _ B8, 00000000
        call    nasm_panic                              ; 7734 _ E8, 00000000(PLT r)
?_0678: mov     rax, qword [rbp-18H]                    ; 7739 _ 48: 8B. 45, E8
        mov     eax, dword [rax+10H]                    ; 773D _ 8B. 40, 10
        cdqe                                            ; 7740 _ 48: 98
        lea     rdx, [rax*8]                            ; 7742 _ 48: 8D. 14 C5, 00000000
        lea     rax, [rel nasm_reg_flags]               ; 774A _ 48: 8D. 05, 00000000(rel)
        mov     rax, qword [rdx+rax]                    ; 7751 _ 48: 8B. 04 02
        mov     qword [rbp-8H], rax                     ; 7755 _ 48: 89. 45, F8
        mov     rax, qword [rbp-18H]                    ; 7759 _ 48: 8B. 45, E8
        mov     eax, dword [rax+10H]                    ; 775D _ 8B. 40, 10
        cdqe                                            ; 7760 _ 48: 98
        lea     rdx, [rax*4]                            ; 7762 _ 48: 8D. 14 85, 00000000
        lea     rax, [rel nasm_regvals]                 ; 776A _ 48: 8D. 05, 00000000(rel)
        mov     eax, dword [rdx+rax]                    ; 7771 _ 8B. 04 02
        mov     dword [rbp-0CH], eax                    ; 7774 _ 89. 45, F4
        mov     edx, dword [rbp-1CH]                    ; 7777 _ 8B. 55, E4
        mov     rcx, qword [rbp-8H]                     ; 777A _ 48: 8B. 4D, F8
        mov     eax, dword [rbp-0CH]                    ; 777E _ 8B. 45, F4
        mov     rsi, rcx                                ; 7781 _ 48: 89. CE
        mov     edi, eax                                ; 7784 _ 89. C7
        call    rexflags                                ; 7786 _ E8, 00000002
        leave                                           ; 778B _ C9
        ret                                             ; 778C _ C3

rexflags:; Local function
        push    rbp                                     ; 778D _ 55
        mov     rbp, rsp                                ; 778E _ 48: 89. E5
        sub     rsp, 32                                 ; 7791 _ 48: 83. EC, 20
        mov     dword [rbp-14H], edi                    ; 7795 _ 89. 7D, EC
        mov     qword [rbp-20H], rsi                    ; 7798 _ 48: 89. 75, E0
        mov     dword [rbp-18H], edx                    ; 779C _ 89. 55, E8
        mov     dword [rbp-4H], 0                       ; 779F _ C7. 45, FC, 00000000
        cmp     dword [rbp-14H], 0                      ; 77A6 _ 83. 7D, EC, 00
        js      ?_0679                                  ; 77AA _ 78, 18
        mov     rax, qword [rbp-20H]                    ; 77AC _ 48: 8B. 45, E0
        mov     rsi, rax                                ; 77B0 _ 48: 89. C6
        mov     edi, 1                                  ; 77B3 _ BF, 00000001
        call    is_class                                ; 77B8 _ E8, FFFF899F
        xor     eax, 01H                                ; 77BD _ 83. F0, 01
        test    al, al                                  ; 77C0 _ 84. C0
        jz      ?_0680                                  ; 77C2 _ 74, 0A
?_0679: mov     eax, 0                                  ; 77C4 _ B8, 00000000
        jmp     ?_0686                                  ; 77C9 _ E9, 00000089

?_0680: mov     eax, dword [rbp-14H]                    ; 77CE _ 8B. 45, EC
        and     eax, 08H                                ; 77D1 _ 83. E0, 08
        test    eax, eax                                ; 77D4 _ 85. C0
        jz      ?_0681                                  ; 77D6 _ 74, 04
        or      dword [rbp-4H], 07H                     ; 77D8 _ 83. 4D, FC, 07
?_0681: mov     eax, dword [rbp-14H]                    ; 77DC _ 8B. 45, EC
        and     eax, 10H                                ; 77DF _ 83. E0, 10
        test    eax, eax                                ; 77E2 _ 85. C0
        jz      ?_0682                                  ; 77E4 _ 74, 07
        or      dword [rbp-4H], 7000H                   ; 77E6 _ 81. 4D, FC, 00007000
?_0682: mov     rax, qword [rbp-20H]                    ; 77ED _ 48: 8B. 45, E0
        and     eax, 27000H                             ; 77F1 _ 25, 00027000
        test    rax, rax                                ; 77F6 _ 48: 85. C0
        jz      ?_0683                                  ; 77F9 _ 74, 09
        or      dword [rbp-4H], 70000H                  ; 77FB _ 81. 4D, FC, 00070000
        jmp     ?_0685                                  ; 7802 _ EB, 4D

?_0683: mov     rax, qword [rbp-20H]                    ; 7804 _ 48: 8B. 45, E0
        mov     rdx, qword 100000105H                   ; 7808 _ 48: BA, 0000000100000105
        mov     rsi, rax                                ; 7812 _ 48: 89. C6
        mov     rdi, rdx                                ; 7815 _ 48: 89. D7
        call    is_class                                ; 7818 _ E8, FFFF893F
        test    al, al                                  ; 781D _ 84. C0
        jz      ?_0685                                  ; 781F _ 74, 30
        mov     rax, qword [rbp-20H]                    ; 7821 _ 48: 8B. 45, E0
        mov     rdx, qword 150200105H                   ; 7825 _ 48: BA, 0000000150200105
        mov     rsi, rax                                ; 782F _ 48: 89. C6
        mov     rdi, rdx                                ; 7832 _ 48: 89. D7
        call    is_class                                ; 7835 _ E8, FFFF8922
        test    al, al                                  ; 783A _ 84. C0
        jz      ?_0684                                  ; 783C _ 74, 09
        or      dword [rbp-4H], 80H                     ; 783E _ 81. 4D, FC, 00000080
        jmp     ?_0685                                  ; 7845 _ EB, 0A

?_0684: cmp     dword [rbp-14H], 3                      ; 7847 _ 83. 7D, EC, 03
        jle     ?_0685                                  ; 784B _ 7E, 04
        or      dword [rbp-4H], 40H                     ; 784D _ 83. 4D, FC, 40
?_0685: mov     eax, dword [rbp-4H]                     ; 7851 _ 8B. 45, FC
        and     eax, dword [rbp-18H]                    ; 7854 _ 23. 45, E8
?_0686: leave                                           ; 7857 _ C9
        ret                                             ; 7858 _ C3

evexflags:; Local function
        push    rbp                                     ; 7859 _ 55
        mov     rbp, rsp                                ; 785A _ 48: 89. E5
        mov     word [rbp-12H], di                      ; 785D _ 66: 89. 7D, EE
        mov     dword [rbp-18H], esi                    ; 7861 _ 89. 75, E8
        mov     dword [rbp-4H], 0                       ; 7864 _ C7. 45, FC, 00000000
        movzx   eax, word [rbp-12H]                     ; 786B _ 0F B7. 45, EE
        and     eax, 10H                                ; 786F _ 83. E0, 10
        test    rax, rax                                ; 7872 _ 48: 85. C0
        jz      ?_0687                                  ; 7875 _ 74, 07
        or      dword [rbp-4H], 80000000H               ; 7877 _ 81. 4D, FC, 80000000
?_0687: movzx   eax, word [rbp-12H]                     ; 787E _ 0F B7. 45, EE
        and     eax, 0FH                                ; 7882 _ 83. E0, 0F
        test    rax, rax                                ; 7885 _ 48: 85. C0
        jz      ?_0688                                  ; 7888 _ 74, 0F
        movzx   eax, word [rbp-12H]                     ; 788A _ 0F B7. 45, EE
        shl     eax, 24                                 ; 788E _ C1. E0, 18
        and     eax, 7000000H                           ; 7891 _ 25, 07000000
        or      dword [rbp-4H], eax                     ; 7896 _ 09. 45, FC
?_0688: mov     eax, dword [rbp-4H]                     ; 7899 _ 8B. 45, FC
        and     eax, dword [rbp-18H]                    ; 789C _ 23. 45, E8
        pop     rbp                                     ; 789F _ 5D
        ret                                             ; 78A0 _ C3

op_evexflags:; Local function
        push    rbp                                     ; 78A1 _ 55
        mov     rbp, rsp                                ; 78A2 _ 48: 89. E5
        sub     rsp, 16                                 ; 78A5 _ 48: 83. EC, 10
        mov     qword [rbp-8H], rdi                     ; 78A9 _ 48: 89. 7D, F8
        mov     dword [rbp-0CH], esi                    ; 78AD _ 89. 75, F4
        mov     rax, qword [rbp-8H]                     ; 78B0 _ 48: 8B. 45, F8
        movzx   eax, word [rax+40H]                     ; 78B4 _ 0F B7. 40, 40
        mov     edx, dword [rbp-0CH]                    ; 78B8 _ 8B. 55, F4
        movzx   eax, ax                                 ; 78BB _ 0F B7. C0
        mov     esi, edx                                ; 78BE _ 89. D6
        mov     edi, eax                                ; 78C0 _ 89. C7
        call    evexflags                               ; 78C2 _ E8, FFFFFF92
        leave                                           ; 78C7 _ C9
        ret                                             ; 78C8 _ C3

find_match:; Local function
        push    rbp                                     ; 78C9 _ 55
        mov     rbp, rsp                                ; 78CA _ 48: 89. E5
        sub     rsp, 80                                 ; 78CD _ 48: 83. EC, 50
        mov     qword [rbp-48H], rdi                    ; 78D1 _ 48: 89. 7D, B8
        mov     rax, qword [rbp-48H]                    ; 78D5 _ 48: 8B. 45, B8
        movzx   eax, byte [rax+7AH]                     ; 78D9 _ 0F B6. 40, 7A
        movzx   eax, al                                 ; 78DD _ 0F B6. C0
        mov     dword [rbp-28H], eax                    ; 78E0 _ 89. 45, D8
        mov     rax, qword [rbp-48H]                    ; 78E3 _ 48: 8B. 45, B8
        mov     eax, dword [rax+30H]                    ; 78E7 _ 8B. 40, 30
        mov     dword [rbp-24H], eax                    ; 78EA _ 89. 45, DC
        mov     qword [rbp-10H], 0                      ; 78ED _ 48: C7. 45, F0, 00000000
        mov     rax, qword [rbp-48H]                    ; 78F5 _ 48: 8B. 45, B8
        mov     rdx, qword [rbp-10H]                    ; 78F9 _ 48: 8B. 55, F0
        mov     qword [rax+0B0H], rdx                   ; 78FD _ 48: 89. 90, 000000B0
        mov     dword [rbp-2CH], -1                     ; 7904 _ C7. 45, D4, FFFFFFFF
        mov     rax, qword [rbp-48H]                    ; 790B _ 48: 8B. 45, B8
        mov     edx, dword [rbp-2CH]                    ; 790F _ 8B. 55, D4
        mov     dword [rax+228H], edx                   ; 7912 _ 89. 90, 00000228
        cmp     dword [rbp-28H], 64                     ; 7918 _ 83. 7D, D8, 40
        jz      ?_0690                                  ; 791C _ 74, 1C
        cmp     dword [rbp-24H], 364                    ; 791E _ 81. 7D, DC, 0000016C
        jz      ?_0689                                  ; 7925 _ 74, 09
        cmp     dword [rbp-24H], 365                    ; 7927 _ 81. 7D, DC, 0000016D
        jnz     ?_0690                                  ; 792E _ 75, 0A
?_0689: mov     eax, 15                                 ; 7930 _ B8, 0000000F
        jmp     ?_0697                                  ; 7935 _ E9, 000000BA

?_0690: mov     dword [rbp-34H], 0                      ; 793A _ C7. 45, CC, 00000000
        mov     rax, qword [rbp-48H]                    ; 7941 _ 48: 8B. 45, B8
        mov     eax, dword [rax]                        ; 7945 _ 8B. 00
        cdqe                                            ; 7947 _ 48: 98
        shl     rax, 4                                  ; 7949 _ 48: C1. E0, 04
        mov     rdx, rax                                ; 794D _ 48: 89. C2
        lea     rax, [rel nasm_instructions]            ; 7950 _ 48: 8D. 05, 00000000(rel)
        add     rax, rdx                                ; 7957 _ 48: 01. D0
        mov     qword [rbp-8H], rax                     ; 795A _ 48: 89. 45, F8
        mov     rax, qword [rbp-8H]                     ; 795E _ 48: 8B. 45, F8
        mov     eax, dword [rax]                        ; 7962 _ 8B. 00
        mov     dword [rbp-20H], eax                    ; 7964 _ 89. 45, E0
        mov     rax, qword [rbp-8H]                     ; 7967 _ 48: 8B. 45, F8
        mov     rax, qword [rax+8H]                     ; 796B _ 48: 8B. 40, 08
        mov     qword [rbp-18H], rax                    ; 796F _ 48: 89. 45, E8
        mov     dword [rbp-30H], 0                      ; 7973 _ C7. 45, D0, 00000000
        jmp     ?_0693                                  ; 797A _ EB, 41

?_0691: mov     rdx, qword [rbp-48H]                    ; 797C _ 48: 8B. 55, B8
        mov     rax, qword [rbp-18H]                    ; 7980 _ 48: 8B. 45, E8
        mov     rsi, rdx                                ; 7984 _ 48: 89. D6
        mov     rdi, rax                                ; 7987 _ 48: 89. C7
        call    matches                                 ; 798A _ E8, 000000E8
        mov     dword [rbp-1CH], eax                    ; 798F _ 89. 45, E4
        mov     eax, dword [rbp-1CH]                    ; 7992 _ 8B. 45, E4
        cmp     dword [rbp-34H], eax                    ; 7995 _ 39. 45, CC
        jnc     ?_0692                                  ; 7998 _ 73, 1A
        mov     rax, qword [rbp-18H]                    ; 799A _ 48: 8B. 45, E8
        mov     qword [rbp-10H], rax                    ; 799E _ 48: 89. 45, F0
        mov     eax, dword [rbp-30H]                    ; 79A2 _ 8B. 45, D0
        mov     dword [rbp-2CH], eax                    ; 79A5 _ 89. 45, D4
        mov     eax, dword [rbp-1CH]                    ; 79A8 _ 8B. 45, E4
        mov     dword [rbp-34H], eax                    ; 79AB _ 89. 45, CC
        cmp     dword [rbp-34H], 30                     ; 79AE _ 83. 7D, CC, 1E
        jz      ?_0694                                  ; 79B2 _ 74, 13
?_0692: add     qword [rbp-18H], 80                     ; 79B4 _ 48: 83. 45, E8, 50
        add     dword [rbp-30H], 1                      ; 79B9 _ 83. 45, D0, 01
?_0693: mov     eax, dword [rbp-30H]                    ; 79BD _ 8B. 45, D0
        cmp     eax, dword [rbp-20H]                    ; 79C0 _ 3B. 45, E0
        jl      ?_0691                                  ; 79C3 _ 7C, B7
        jmp     ?_0695                                  ; 79C5 _ EB, 01

?_0694: nop                                             ; 79C7 _ 90
?_0695: cmp     dword [rbp-34H], 20                     ; 79C8 _ 83. 7D, CC, 14
        jbe     ?_0696                                  ; 79CC _ 76, 23
        mov     dword [rbp-34H], 30                     ; 79CE _ C7. 45, CC, 0000001E
        mov     rax, qword [rbp-48H]                    ; 79D5 _ 48: 8B. 45, B8
        mov     rdx, qword [rbp-10H]                    ; 79D9 _ 48: 8B. 55, F0
        mov     qword [rax+0B0H], rdx                   ; 79DD _ 48: 89. 90, 000000B0
        mov     rax, qword [rbp-48H]                    ; 79E4 _ 48: 8B. 45, B8
        mov     edx, dword [rbp-2CH]                    ; 79E8 _ 8B. 55, D4
        mov     dword [rax+228H], edx                   ; 79EB _ 89. 90, 00000228
?_0696: mov     eax, dword [rbp-34H]                    ; 79F1 _ 8B. 45, CC
?_0697: leave                                           ; 79F4 _ C9
        ret                                             ; 79F5 _ C3

get_broadcast_num:; Local function
        push    rbp                                     ; 79F6 _ 55
        mov     rbp, rsp                                ; 79F7 _ 48: 89. E5
        sub     rsp, 32                                 ; 79FA _ 48: 83. EC, 20
        mov     qword [rbp-18H], rdi                    ; 79FE _ 48: 89. 7D, E8
        mov     qword [rbp-20H], rsi                    ; 7A02 _ 48: 89. 75, E0
        mov     rax, qword [rbp-18H]                    ; 7A06 _ 48: 8B. 45, E8
        shr     rax, 32                                 ; 7A0A _ 48: C1. E8, 20
        and     eax, 0FFFFH                             ; 7A0E _ 25, 0000FFFF
        mov     dword [rbp-4H], eax                     ; 7A13 _ 89. 45, FC
        mov     rax, qword 800000000H                   ; 7A16 _ 48: B8, 0000000800000000
        cmp     rax, qword [rbp-20H]                    ; 7A20 _ 48: 3B. 45, E0
        jnc     ?_0698                                  ; 7A24 _ 73, 14
        lea     rax, [rel ?_1115]                       ; 7A26 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 7A2D _ 48: 89. C7
        mov     eax, 0                                  ; 7A30 _ B8, 00000000
        call    nasm_fatal                              ; 7A35 _ E8, 00000000(PLT r)
?_0698: mov     eax, dword [rbp-4H]                     ; 7A3A _ 8B. 45, FC
        shr     eax, 3                                  ; 7A3D _ C1. E8, 03
        mov     ecx, eax                                ; 7A40 _ 89. C1
        mov     rax, qword 800000000H                   ; 7A42 _ 48: B8, 0000000800000000
        mov     edx, 0                                  ; 7A4C _ BA, 00000000
        div     qword [rbp-20H]                         ; 7A51 _ 48: F7. 75, E0
        mov     rdx, rcx                                ; 7A55 _ 48: 89. CA
        imul    rdx, rax                                ; 7A58 _ 48: 0F AF. D0
        cmp     dword [rbp-4H], 8                       ; 7A5C _ 83. 7D, FC, 08
        seta    al                                      ; 7A60 _ 0F 97. C0
        movzx   eax, al                                 ; 7A63 _ 0F B6. C0
        mov     ecx, eax                                ; 7A66 _ 89. C1
        shr     rdx, cl                                 ; 7A68 _ 48: D3. EA
        mov     rax, rdx                                ; 7A6B _ 48: 89. D0
        mov     byte [rbp-5H], al                       ; 7A6E _ 88. 45, FB
        movzx   eax, byte [rbp-5H]                      ; 7A71 _ 0F B6. 45, FB
        leave                                           ; 7A75 _ C9
        ret                                             ; 7A76 _ C3

matches:; Local function
        push    rbp                                     ; 7A77 _ 55
        mov     rbp, rsp                                ; 7A78 _ 48: 89. E5
        sub     rsp, 304                                ; 7A7B _ 48: 81. EC, 00000130
        mov     qword [rbp-128H], rdi                   ; 7A82 _ 48: 89. BD, FFFFFED8
        mov     qword [rbp-130H], rsi                   ; 7A89 _ 48: 89. B5, FFFFFED0
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        mov     rax, qword [fs:abs 28H]                 ; 7A90 _ 64 48: 8B. 04 25, 00000028
        mov     qword [rbp-8H], rax                     ; 7A99 _ 48: 89. 45, F8
        xor     eax, eax                                ; 7A9D _ 31. C0
        mov     rax, qword [rbp-130H]                   ; 7A9F _ 48: 8B. 85, FFFFFED0
        movzx   eax, byte [rax+7AH]                     ; 7AA6 _ 0F B6. 40, 7A
        movzx   eax, al                                 ; 7AAA _ 0F B6. C0
        mov     dword [rbp-0F4H], eax                   ; 7AAD _ 89. 85, FFFFFF0C
        mov     rax, qword [rbp-130H]                   ; 7AB3 _ 48: 8B. 85, FFFFFED0
        movzx   eax, byte [rax+7DH]                     ; 7ABA _ 0F B6. 40, 7D
        movzx   eax, al                                 ; 7ABE _ 0F B6. C0
        mov     dword [rbp-0F0H], eax                   ; 7AC1 _ 89. 85, FFFFFF10
        mov     rax, qword 0F0000000000H                ; 7AC7 _ 48: B8, 00000F0000000000
        mov     qword [rbp-0C8H], rax                   ; 7AD1 _ 48: 89. 85, FFFFFF38
        mov     rax, qword [rbp-0C8H]                   ; 7AD8 _ 48: 8B. 85, FFFFFF38
        not     rax                                     ; 7ADF _ 48: F7. D0
        mov     rdx, rax                                ; 7AE2 _ 48: 89. C2
        mov     rax, qword 0FFFF00000000H               ; 7AE5 _ 48: B8, 0000FFFF00000000
        and     rax, rdx                                ; 7AEF _ 48: 21. D0
        mov     qword [rbp-0C0H], rax                   ; 7AF2 _ 48: 89. 85, FFFFFF40
        mov     rax, qword [rbp-128H]                   ; 7AF9 _ 48: 8B. 85, FFFFFED8
        mov     edx, dword [rax]                        ; 7B00 _ 8B. 10
        mov     rax, qword [rbp-130H]                   ; 7B02 _ 48: 8B. 85, FFFFFED0
        mov     eax, dword [rax]                        ; 7B09 _ 8B. 00
        cmp     edx, eax                                ; 7B0B _ 39. C2
        jz      ?_0699                                  ; 7B0D _ 74, 0A
        mov     eax, 0                                  ; 7B0F _ B8, 00000000
        jmp     ?_0785                                  ; 7B14 _ E9, 000011C3

?_0699: mov     rax, qword [rbp-128H]                   ; 7B19 _ 48: 8B. 85, FFFFFED8
        mov     eax, dword [rax+4H]                     ; 7B20 _ 8B. 40, 04
        cmp     dword [rbp-0F0H], eax                   ; 7B23 _ 39. 85, FFFFFF10
        jz      ?_0700                                  ; 7B29 _ 74, 0A
        mov     eax, 0                                  ; 7B2B _ B8, 00000000
        jmp     ?_0785                                  ; 7B30 _ E9, 000011A7

?_0700: mov     rax, qword [rbp-130H]                   ; 7B35 _ 48: 8B. 85, FFFFFED0
        mov     eax, dword [rax+94H]                    ; 7B3C _ 8B. 80, 00000094
        and     eax, 04H                                ; 7B42 _ 83. E0, 04
        shr     eax, 2                                  ; 7B45 _ C1. E8, 02
        and     eax, 01H                                ; 7B48 _ 83. E0, 01
        movzx   eax, al                                 ; 7B4B _ 0F B6. C0
        test    rax, rax                                ; 7B4E _ 48: 85. C0
        jz      ?_0701                                  ; 7B51 _ 74, 22
        mov     rax, qword [rbp-128H]                   ; 7B53 _ 48: 8B. 85, FFFFFED8
        mov     esi, 27                                 ; 7B5A _ BE, 0000001B
        mov     rdi, rax                                ; 7B5F _ 48: 89. C7
        call    itemp_has                               ; 7B62 _ E8, FFFF8849
        test    al, al                                  ; 7B67 _ 84. C0
        jz      ?_0701                                  ; 7B69 _ 74, 0A
        mov     eax, 0                                  ; 7B6B _ B8, 00000000
        jmp     ?_0785                                  ; 7B70 _ E9, 00001167

?_0701: mov     rax, qword [rbp-130H]                   ; 7B75 _ 48: 8B. 85, FFFFFED0
        mov     eax, dword [rax+30H]                    ; 7B7C _ 8B. 40, 30
        cmp     eax, 369                                ; 7B7F _ 3D, 00000171
        jg      ?_0708                                  ; 7B84 _ 0F 8F, 00000140
        cmp     eax, 367                                ; 7B8A _ 3D, 0000016F
        jge     ?_0703                                  ; 7B8F _ 7D, 52
        cmp     eax, 366                                ; 7B91 _ 3D, 0000016E
        jz      ?_0702                                  ; 7B96 _ 74, 22
        cmp     eax, 366                                ; 7B98 _ 3D, 0000016E
        jg      ?_0708                                  ; 7B9D _ 0F 8F, 00000127
        cmp     eax, 364                                ; 7BA3 _ 3D, 0000016C
        jz      ?_0704                                  ; 7BA8 _ 74, 62
        cmp     eax, 365                                ; 7BAA _ 3D, 0000016D
        je      ?_0706                                  ; 7BAF _ 0F 84, 000000CE
        jmp     ?_0708                                  ; 7BB5 _ E9, 00000110

?_0702: mov     rax, qword [rbp-128H]                   ; 7BBA _ 48: 8B. 85, FFFFFED8
        mov     esi, 65                                 ; 7BC1 _ BE, 00000041
        mov     rdi, rax                                ; 7BC6 _ 48: 89. C7
        call    itemp_has                               ; 7BC9 _ E8, FFFF87E2
        xor     eax, 01H                                ; 7BCE _ 83. F0, 01
        test    al, al                                  ; 7BD1 _ 84. C0
        je      ?_0713                                  ; 7BD3 _ 0F 84, 0000020E
        mov     eax, 15                                 ; 7BD9 _ B8, 0000000F
        jmp     ?_0785                                  ; 7BDE _ E9, 000010F9

?_0703: mov     rax, qword [rbp-128H]                   ; 7BE3 _ 48: 8B. 85, FFFFFED8
        mov     esi, 64                                 ; 7BEA _ BE, 00000040
        mov     rdi, rax                                ; 7BEF _ 48: 89. C7
        call    itemp_has                               ; 7BF2 _ E8, FFFF87B9
        xor     eax, 01H                                ; 7BF7 _ 83. F0, 01
        test    al, al                                  ; 7BFA _ 84. C0
        je      ?_0714                                  ; 7BFC _ 0F 84, 000001E8
        mov     eax, 15                                 ; 7C02 _ B8, 0000000F
        jmp     ?_0785                                  ; 7C07 _ E9, 000010D0

?_0704: cmp     dword [rbp-0F4H], 64                    ; 7C0C _ 83. BD, FFFFFF0C, 40
        jnz     ?_0705                                  ; 7C13 _ 75, 64
        mov     rax, qword [rbp-128H]                   ; 7C15 _ 48: 8B. 85, FFFFFED8
        mov     esi, 29                                 ; 7C1C _ BE, 0000001D
        mov     rdi, rax                                ; 7C21 _ 48: 89. C7
        call    itemp_has                               ; 7C24 _ E8, FFFF8787
        test    al, al                                  ; 7C29 _ 84. C0
        jnz     ?_0705                                  ; 7C2B _ 75, 4C
        mov     rax, qword [rbp-128H]                   ; 7C2D _ 48: 8B. 85, FFFFFED8
        mov     esi, 64                                 ; 7C34 _ BE, 00000040
        mov     rdi, rax                                ; 7C39 _ 48: 89. C7
        call    itemp_has                               ; 7C3C _ E8, FFFF876F
        test    al, al                                  ; 7C41 _ 84. C0
        jnz     ?_0705                                  ; 7C43 _ 75, 34
        mov     rax, qword [rbp-128H]                   ; 7C45 _ 48: 8B. 85, FFFFFED8
        mov     esi, 65                                 ; 7C4C _ BE, 00000041
        mov     rdi, rax                                ; 7C51 _ 48: 89. C7
        call    itemp_has                               ; 7C54 _ E8, FFFF8757
        test    al, al                                  ; 7C59 _ 84. C0
        jnz     ?_0705                                  ; 7C5B _ 75, 1C
        mov     rax, qword [rbp-128H]                   ; 7C5D _ 48: 8B. 85, FFFFFED8
        mov     esi, 49                                 ; 7C64 _ BE, 00000031
        mov     rdi, rax                                ; 7C69 _ 48: 89. C7
        call    itemp_has                               ; 7C6C _ E8, FFFF873F
        test    al, al                                  ; 7C71 _ 84. C0
        je      ?_0715                                  ; 7C73 _ 0F 84, 00000174
?_0705: mov     eax, 15                                 ; 7C79 _ B8, 0000000F
        jmp     ?_0785                                  ; 7C7E _ E9, 00001059

?_0706: cmp     dword [rbp-0F4H], 64                    ; 7C83 _ 83. BD, FFFFFF0C, 40
        jnz     ?_0707                                  ; 7C8A _ 75, 34
        mov     rax, qword [rbp-128H]                   ; 7C8C _ 48: 8B. 85, FFFFFED8
        mov     esi, 30                                 ; 7C93 _ BE, 0000001E
        mov     rdi, rax                                ; 7C98 _ 48: 89. C7
        call    itemp_has                               ; 7C9B _ E8, FFFF8710
        test    al, al                                  ; 7CA0 _ 84. C0
        jnz     ?_0707                                  ; 7CA2 _ 75, 1C
        mov     rax, qword [rbp-128H]                   ; 7CA4 _ 48: 8B. 85, FFFFFED8
        mov     esi, 65                                 ; 7CAB _ BE, 00000041
        mov     rdi, rax                                ; 7CB0 _ 48: 89. C7
        call    itemp_has                               ; 7CB3 _ E8, FFFF86F8
        test    al, al                                  ; 7CB8 _ 84. C0
        je      ?_0716                                  ; 7CBA _ 0F 84, 00000130
?_0707: mov     eax, 15                                 ; 7CC0 _ B8, 0000000F
        jmp     ?_0785                                  ; 7CC5 _ E9, 00001012

?_0708: mov     rax, qword [rbp-128H]                   ; 7CCA _ 48: 8B. 85, FFFFFED8
        mov     esi, 65                                 ; 7CD1 _ BE, 00000041
        mov     rdi, rax                                ; 7CD6 _ 48: 89. C7
        call    itemp_has                               ; 7CD9 _ E8, FFFF86D2
        test    al, al                                  ; 7CDE _ 84. C0
        jz      ?_0709                                  ; 7CE0 _ 74, 29
        lea     rax, [rel cpu]                          ; 7CE2 _ 48: 8D. 05, 00000000(rel)
        mov     esi, 65                                 ; 7CE9 _ BE, 00000041
        mov     rdi, rax                                ; 7CEE _ 48: 89. C7
        call    iflag_test                              ; 7CF1 _ E8, FFFF8608
        xor     eax, 01H                                ; 7CF6 _ 83. F0, 01
        test    al, al                                  ; 7CF9 _ 84. C0
        je      ?_0717                                  ; 7CFB _ 0F 84, 000000F2
        mov     eax, 12                                 ; 7D01 _ B8, 0000000C
        jmp     ?_0785                                  ; 7D06 _ E9, 00000FD1

?_0709: mov     rax, qword [rbp-128H]                   ; 7D0B _ 48: 8B. 85, FFFFFED8
        mov     esi, 64                                 ; 7D12 _ BE, 00000040
        mov     rdi, rax                                ; 7D17 _ 48: 89. C7
        call    itemp_has                               ; 7D1A _ E8, FFFF8691
        test    al, al                                  ; 7D1F _ 84. C0
        je      ?_0717                                  ; 7D21 _ 0F 84, 000000CC
        lea     rax, [rel cpu]                          ; 7D27 _ 48: 8D. 05, 00000000(rel)
        mov     esi, 64                                 ; 7D2E _ BE, 00000040
        mov     rdi, rax                                ; 7D33 _ 48: 89. C7
        call    iflag_test                              ; 7D36 _ E8, FFFF85C3
        xor     eax, 01H                                ; 7D3B _ 83. F0, 01
        test    al, al                                  ; 7D3E _ 84. C0
        jz      ?_0710                                  ; 7D40 _ 74, 0A
        mov     eax, 12                                 ; 7D42 _ B8, 0000000C
        jmp     ?_0785                                  ; 7D47 _ E9, 00000F90

?_0710: mov     rax, qword [rbp-128H]                   ; 7D4C _ 48: 8B. 85, FFFFFED8
        mov     esi, 28                                 ; 7D53 _ BE, 0000001C
        mov     rdi, rax                                ; 7D58 _ 48: 89. C7
        call    itemp_has                               ; 7D5B _ E8, FFFF8650
        test    al, al                                  ; 7D60 _ 84. C0
        jz      ?_0711                                  ; 7D62 _ 74, 3D
        lea     rax, [rel cpu]                          ; 7D64 _ 48: 8D. 05, 00000000(rel)
        mov     esi, 28                                 ; 7D6B _ BE, 0000001C
        mov     rdi, rax                                ; 7D70 _ 48: 89. C7
        call    iflag_test                              ; 7D73 _ E8, FFFF8586
        xor     eax, 01H                                ; 7D78 _ 83. F0, 01
        test    al, al                                  ; 7D7B _ 84. C0
        jz      ?_0717                                  ; 7D7D _ 74, 74
        lea     rax, [rel cpu]                          ; 7D7F _ 48: 8D. 05, 00000000(rel)
        mov     esi, 65                                 ; 7D86 _ BE, 00000041
        mov     rdi, rax                                ; 7D8B _ 48: 89. C7
        call    iflag_test                              ; 7D8E _ E8, FFFF856B
        test    al, al                                  ; 7D93 _ 84. C0
        jz      ?_0717                                  ; 7D95 _ 74, 5C
        mov     eax, 12                                 ; 7D97 _ B8, 0000000C
        jmp     ?_0785                                  ; 7D9C _ E9, 00000F3B

?_0711: mov     rax, qword [rbp-128H]                   ; 7DA1 _ 48: 8B. 85, FFFFFED8
        mov     esi, 49                                 ; 7DA8 _ BE, 00000031
        mov     rdi, rax                                ; 7DAD _ 48: 89. C7
        call    itemp_has                               ; 7DB0 _ E8, FFFF85FB
        test    al, al                                  ; 7DB5 _ 84. C0
        jz      ?_0717                                  ; 7DB7 _ 74, 3A
        cmp     dword [rbp-0F4H], 64                    ; 7DB9 _ 83. BD, FFFFFF0C, 40
        jnz     ?_0712                                  ; 7DC0 _ 75, 1B
        lea     rax, [rel cpu]                          ; 7DC2 _ 48: 8D. 05, 00000000(rel)
        mov     esi, 146                                ; 7DC9 _ BE, 00000092
        mov     rdi, rax                                ; 7DCE _ 48: 89. C7
        call    iflag_test                              ; 7DD1 _ E8, FFFF8528
        xor     eax, 01H                                ; 7DD6 _ 83. F0, 01
        test    al, al                                  ; 7DD9 _ 84. C0
        jz      ?_0717                                  ; 7DDB _ 74, 16
?_0712: mov     eax, 12                                 ; 7DDD _ B8, 0000000C
        jmp     ?_0785                                  ; 7DE2 _ E9, 00000EF5

?_0713: nop                                             ; 7DE7 _ 90
        jmp     ?_0718                                  ; 7DE8 _ EB, 0A

?_0714: nop                                             ; 7DEA _ 90
        jmp     ?_0718                                  ; 7DEB _ EB, 07

?_0715: nop                                             ; 7DED _ 90
        jmp     ?_0718                                  ; 7DEE _ EB, 04

?_0716: nop                                             ; 7DF0 _ 90
        jmp     ?_0718                                  ; 7DF1 _ EB, 01

?_0717: nop                                             ; 7DF3 _ 90
?_0718: mov     dword [rbp-104H], 0                     ; 7DF4 _ C7. 85, FFFFFEFC, 00000000
        jmp     ?_0722                                  ; 7DFE _ E9, 00000105

?_0719: mov     eax, dword [rbp-104H]                   ; 7E03 _ 8B. 85, FFFFFEFC
        movsxd  rdx, eax                                ; 7E09 _ 48: 63. D0
        mov     rax, rdx                                ; 7E0C _ 48: 89. D0
        shl     rax, 3                                  ; 7E0F _ 48: C1. E0, 03
        add     rax, rdx                                ; 7E13 _ 48: 01. D0
        shl     rax, 3                                  ; 7E16 _ 48: C1. E0, 03
        lea     rdx, [rax+0C0H]                         ; 7E1A _ 48: 8D. 90, 000000C0
        mov     rax, qword [rbp-130H]                   ; 7E21 _ 48: 8B. 85, FFFFFED0
        add     rax, rdx                                ; 7E28 _ 48: 01. D0
        mov     qword [rbp-0A0H], rax                   ; 7E2B _ 48: 89. 85, FFFFFF60
        mov     rax, qword [rbp-128H]                   ; 7E32 _ 48: 8B. 85, FFFFFED8
        mov     edx, dword [rbp-104H]                   ; 7E39 _ 8B. 95, FFFFFEFC
        movsxd  rdx, edx                                ; 7E3F _ 48: 63. D2
        mov     rax, qword [rax+rdx*8+8H]               ; 7E42 _ 48: 8B. 44 D0, 08
        mov     qword [rbp-98H], rax                    ; 7E47 _ 48: 89. 85, FFFFFF68
        mov     rax, qword [rbp-0A0H]                   ; 7E4E _ 48: 8B. 85, FFFFFF60
        mov     rax, qword [rax]                        ; 7E55 _ 48: 8B. 00
        and     rax, qword [rbp-0C0H]                   ; 7E58 _ 48: 23. 85, FFFFFF40
        mov     rdx, rax                                ; 7E5F _ 48: 89. C2
        mov     eax, dword [rbp-104H]                   ; 7E62 _ 8B. 85, FFFFFEFC
        cdqe                                            ; 7E68 _ 48: 98
        mov     qword [rbp+rax*8-90H], rdx              ; 7E6A _ 48: 89. 94 C5, FFFFFF70
        mov     rax, qword [rbp-0A0H]                   ; 7E72 _ 48: 8B. 85, FFFFFF60
        mov     rdx, qword [rax]                        ; 7E79 _ 48: 8B. 10
        mov     eax, dword [rbp-104H]                   ; 7E7C _ 8B. 85, FFFFFEFC
        cdqe                                            ; 7E82 _ 48: 98
        mov     rax, qword [rbp+rax*8-90H]              ; 7E84 _ 48: 8B. 84 C5, FFFFFF70
        sub     rdx, rax                                ; 7E8C _ 48: 29. C2
        mov     eax, dword [rbp-104H]                   ; 7E8F _ 8B. 85, FFFFFEFC
        cdqe                                            ; 7E95 _ 48: 98
        mov     qword [rbp+rax*8-30H], rdx              ; 7E97 _ 48: 89. 54 C5, D0
        mov     rax, qword [rbp-0A0H]                   ; 7E9C _ 48: 8B. 85, FFFFFF60
        mov     rdx, qword [rax]                        ; 7EA3 _ 48: 8B. 10
        mov     rax, qword [rbp-98H]                    ; 7EA6 _ 48: 8B. 85, FFFFFF68
        not     rax                                     ; 7EAD _ 48: F7. D0
        and     rax, rdx                                ; 7EB0 _ 48: 21. D0
        and     eax, 30H                                ; 7EB3 _ 83. E0, 30
        test    rax, rax                                ; 7EB6 _ 48: 85. C0
        jz      ?_0720                                  ; 7EB9 _ 74, 0A
        mov     eax, 0                                  ; 7EBB _ B8, 00000000
        jmp     ?_0785                                  ; 7EC0 _ E9, 00000E17

?_0720: mov     rax, qword [rbp-0A0H]                   ; 7EC5 _ 48: 8B. 85, FFFFFF60
        mov     eax, dword [rax+3CH]                    ; 7ECC _ 8B. 40, 3C
        test    eax, eax                                ; 7ECF _ 85. C0
        jz      ?_0721                                  ; 7ED1 _ 74, 2E
        mov     rax, qword [rbp-0A0H]                   ; 7ED3 _ 48: 8B. 85, FFFFFF60
        mov     eax, dword [rax+3CH]                    ; 7EDA _ 8B. 40, 3C
        mov     edx, eax                                ; 7EDD _ 89. C2
        mov     rax, qword [rbp-128H]                   ; 7EDF _ 48: 8B. 85, FFFFFED8
        mov     esi, edx                                ; 7EE6 _ 89. D6
        mov     rdi, rax                                ; 7EE8 _ 48: 89. C7
        call    itemp_has                               ; 7EEB _ E8, FFFF84C0
        xor     eax, 01H                                ; 7EF0 _ 83. F0, 01
        test    al, al                                  ; 7EF3 _ 84. C0
        jz      ?_0721                                  ; 7EF5 _ 74, 0A
        mov     eax, 20                                 ; 7EF7 _ B8, 00000014
        jmp     ?_0785                                  ; 7EFC _ E9, 00000DDB

?_0721: add     dword [rbp-104H], 1                     ; 7F01 _ 83. 85, FFFFFEFC, 01
?_0722: mov     eax, dword [rbp-104H]                   ; 7F08 _ 8B. 85, FFFFFEFC
        cmp     eax, dword [rbp-0F0H]                   ; 7F0E _ 3B. 85, FFFFFF10
        jl      ?_0719                                  ; 7F14 _ 0F 8C, FFFFFEE9
        mov     rax, qword [rbp-130H]                   ; 7F1A _ 48: 8B. 85, FFFFFED0
        movzx   eax, byte [rax+7BH]                     ; 7F21 _ 0F B6. 40, 7B
        movzx   eax, al                                 ; 7F25 _ 0F B6. C0
        mov     dword [rbp-100H], eax                   ; 7F28 _ 89. 85, FFFFFF00
        cmp     dword [rbp-0F4H], 64                    ; 7F2E _ 83. BD, FFFFFF0C, 40
        jnz     ?_0723                                  ; 7F35 _ 75, 2D
        mov     rax, qword [rbp-128H]                   ; 7F37 _ 48: 8B. 85, FFFFFED8
        mov     esi, 18                                 ; 7F3E _ BE, 00000012
        mov     rdi, rax                                ; 7F43 _ 48: 89. C7
        call    itemp_has                               ; 7F46 _ E8, FFFF8465
        test    al, al                                  ; 7F4B _ 84. C0
        jz      ?_0723                                  ; 7F4D _ 74, 15
        cmp     dword [rbp-100H], 32                    ; 7F4F _ 83. BD, FFFFFF00, 20
        jnz     ?_0723                                  ; 7F56 _ 75, 0C
        mov     eax, dword [rbp-0F4H]                   ; 7F58 _ 8B. 85, FFFFFF0C
        mov     dword [rbp-100H], eax                   ; 7F5E _ 89. 85, FFFFFF00
?_0723: mov     eax, dword [rbp-100H]                   ; 7F64 _ 8B. 85, FFFFFF00
        mov     edi, eax                                ; 7F6A _ 89. C7
        call    mode_to_op                              ; 7F6C _ E8, FFFF8859
        mov     qword [rbp-0B8H], rax                   ; 7F71 _ 48: 89. 85, FFFFFF48
        mov     rax, qword [rbp-128H]                   ; 7F78 _ 48: 8B. 85, FFFFFED8
        mov     esi, 21                                 ; 7F7F _ BE, 00000015
        mov     rdi, rax                                ; 7F84 _ 48: 89. C7
        call    itemp_has                               ; 7F87 _ E8, FFFF8424
        mov     byte [rbp-117H], al                     ; 7F8C _ 88. 85, FFFFFEE9
        mov     rax, qword [rbp-128H]                   ; 7F92 _ 48: 8B. 85, FFFFFED8
        mov     esi, 22                                 ; 7F99 _ BE, 00000016
        mov     rdi, rax                                ; 7F9E _ 48: 89. C7
        call    itemp_has                               ; 7FA1 _ E8, FFFF840A
        mov     byte [rbp-116H], al                     ; 7FA6 _ 88. 85, FFFFFEEA
        mov     dword [rbp-104H], 0                     ; 7FAC _ C7. 85, FFFFFEFC, 00000000
        jmp     ?_0741                                  ; 7FB6 _ E9, 000004B3

?_0724: mov     rax, qword [rbp-128H]                   ; 7FBB _ 48: 8B. 85, FFFFFED8
        mov     edx, dword [rbp-104H]                   ; 7FC2 _ 8B. 95, FFFFFEFC
        movsxd  rdx, edx                                ; 7FC8 _ 48: 63. D2
        mov     rax, qword [rax+rdx*8+8H]               ; 7FCB _ 48: 8B. 44 D0, 08
        mov     qword [rbp-0A8H], rax                   ; 7FD0 _ 48: 89. 85, FFFFFF58
        mov     rcx, qword [rbp-130H]                   ; 7FD7 _ 48: 8B. 8D, FFFFFED0
        mov     eax, dword [rbp-104H]                   ; 7FDE _ 8B. 85, FFFFFEFC
        movsxd  rdx, eax                                ; 7FE4 _ 48: 63. D0
        mov     rax, rdx                                ; 7FE7 _ 48: 89. D0
        shl     rax, 3                                  ; 7FEA _ 48: C1. E0, 03
        add     rax, rdx                                ; 7FEE _ 48: 01. D0
        shl     rax, 3                                  ; 7FF1 _ 48: C1. E0, 03
        add     rax, rcx                                ; 7FF5 _ 48: 01. C8
        add     rax, 256                                ; 7FF8 _ 48: 05, 00000100
        movzx   eax, word [rax]                         ; 7FFE _ 0F B7. 00
        mov     word [rbp-10AH], ax                     ; 8001 _ 66: 89. 85, FFFFFEF6
        mov     rax, qword [rbp-128H]                   ; 8008 _ 48: 8B. 85, FFFFFED8
        mov     edx, dword [rbp-104H]                   ; 800F _ 8B. 95, FFFFFEFC
        movsxd  rdx, edx                                ; 8015 _ 48: 63. D2
        add     rdx, 24                                 ; 8018 _ 48: 83. C2, 18
        movzx   eax, word [rax+rdx*2]                   ; 801C _ 0F B7. 04 50
        mov     word [rbp-108H], ax                     ; 8020 _ 66: 89. 85, FFFFFEF8
        movzx   eax, word [rbp-10AH]                    ; 8027 _ 0F B7. 85, FFFFFEF6
        and     eax, 20H                                ; 802E _ 83. E0, 20
        shr     rax, 5                                  ; 8031 _ 48: C1. E8, 05
        and     eax, 01H                                ; 8035 _ 83. E0, 01
        mov     byte [rbp-111H], al                     ; 8038 _ 88. 85, FFFFFEEF
        movzx   eax, byte [rbp-111H]                    ; 803E _ 0F B6. 85, FFFFFEEF
        xor     eax, 01H                                ; 8045 _ 83. F0, 01
        movzx   eax, al                                 ; 8048 _ 0F B6. C0
        test    rax, rax                                ; 804B _ 48: 85. C0
        jz      ?_0725                                  ; 804E _ 74, 20
        mov     rax, qword [rbp-0A8H]                   ; 8050 _ 48: 8B. 85, FFFFFF58
        and     rax, qword [rbp-0C0H]                   ; 8057 _ 48: 23. 85, FFFFFF40
        mov     rdx, rax                                ; 805E _ 48: 89. C2
        mov     eax, dword [rbp-104H]                   ; 8061 _ 8B. 85, FFFFFEFC
        cdqe                                            ; 8067 _ 48: 98
        mov     qword [rbp+rax*8-60H], rdx              ; 8069 _ 48: 89. 54 C5, A0
        jmp     ?_0728                                  ; 806E _ EB, 69

?_0725: movzx   eax, word [rbp-108H]                    ; 8070 _ 0F B7. 85, FFFFFEF8
; Note: Length-changing prefix causes delay on old Intel processors
        and     ax, 0F00H                               ; 8077 _ 66: 25, 0F00
        mov     word [rbp-106H], ax                     ; 807B _ 66: 89. 85, FFFFFEFA
        movzx   eax, word [rbp-108H]                    ; 8082 _ 0F B7. 85, FFFFFEF8
        not     eax                                     ; 8089 _ F7. D0
        cdqe                                            ; 808B _ 48: 98
        and     eax, 20H                                ; 808D _ 83. E0, 20
        test    rax, rax                                ; 8090 _ 48: 85. C0
        jz      ?_0726                                  ; 8093 _ 74, 0A
        mov     eax, 5                                  ; 8095 _ B8, 00000005
        jmp     ?_0785                                  ; 809A _ E9, 00000C3D

?_0726: cmp     word [rbp-106H], 0                      ; 809F _ 66: 83. BD, FFFFFEFA, 00
        jz      ?_0727                                  ; 80A7 _ 74, 1F
        movzx   eax, word [rbp-106H]                    ; 80A9 _ 0F B7. 85, FFFFFEFA
        mov     rdi, rax                                ; 80B0 _ 48: 89. C7
        call    brsize_to_size                          ; 80B3 _ E8, FFFF81CE
        mov     edx, dword [rbp-104H]                   ; 80B8 _ 8B. 95, FFFFFEFC
        movsxd  rdx, edx                                ; 80BE _ 48: 63. D2
        mov     qword [rbp+rdx*8-60H], rax              ; 80C1 _ 48: 89. 44 D5, A0
        jmp     ?_0728                                  ; 80C6 _ EB, 11

?_0727: mov     eax, dword [rbp-104H]                   ; 80C8 _ 8B. 85, FFFFFEFC
        cdqe                                            ; 80CE _ 48: 98
        mov     qword [rbp+rax*8-60H], 0                ; 80D0 _ 48: C7. 44 C5, A0, 00000000
?_0728: mov     rax, qword 60000000000H                 ; 80D9 _ 48: B8, 0000060000000000
        and     rax, qword [rbp-0A8H]                   ; 80E3 _ 48: 23. 85, FFFFFF58
        test    rax, rax                                ; 80EA _ 48: 85. C0
        setne   al                                      ; 80ED _ 0F 95. C0
        movzx   eax, al                                 ; 80F0 _ 0F B6. C0
        test    rax, rax                                ; 80F3 _ 48: 85. C0
        je      ?_0732                                  ; 80F6 _ 0F 84, 00000156
        mov     eax, dword [rbp-104H]                   ; 80FC _ 8B. 85, FFFFFEFC
        cdqe                                            ; 8102 _ 48: 98
        mov     rdx, qword [rbp+rax*8-90H]              ; 8104 _ 48: 8B. 94 C5, FFFFFF70
        mov     rax, qword 100000000H                   ; 810C _ 48: B8, 0000000100000000
        cmp     rdx, rax                                ; 8116 _ 48: 39. C2
        jnz     ?_0729                                  ; 8119 _ 75, 3B
        mov     eax, dword [rbp-104H]                   ; 811B _ 8B. 85, FFFFFEFC
        cdqe                                            ; 8121 _ 48: 98
        mov     rax, qword [rbp+rax*8-30H]              ; 8123 _ 48: 8B. 44 C5, D0
        mov     rdx, qword 40000000000H                 ; 8128 _ 48: BA, 0000040000000000
        or      rdx, rax                                ; 8132 _ 48: 09. C2
        mov     eax, dword [rbp-104H]                   ; 8135 _ 8B. 85, FFFFFEFC
        cdqe                                            ; 813B _ 48: 98
        mov     qword [rbp+rax*8-30H], rdx              ; 813D _ 48: 89. 54 C5, D0
        mov     eax, dword [rbp-104H]                   ; 8142 _ 8B. 85, FFFFFEFC
        cdqe                                            ; 8148 _ 48: 98
        mov     qword [rbp+rax*8-90H], 0                ; 814A _ 48: C7. 84 C5, FFFFFF70, 00000000
?_0729: mov     eax, dword [rbp-104H]                   ; 8156 _ 8B. 85, FFFFFEFC
        cdqe                                            ; 815C _ 48: 98
        mov     rax, qword [rbp+rax*8-30H]              ; 815E _ 48: 8B. 44 C5, D0
        mov     rdx, qword 40000000000H                 ; 8163 _ 48: BA, 0000040000000000
        and     rax, rdx                                ; 816D _ 48: 21. D0
        test    rax, rax                                ; 8170 _ 48: 85. C0
        jz      ?_0730                                  ; 8173 _ 74, 27
        mov     eax, dword [rbp-104H]                   ; 8175 _ 8B. 85, FFFFFEFC
        cdqe                                            ; 817B _ 48: 98
        mov     rax, qword [rbp+rax*8-30H]              ; 817D _ 48: 8B. 44 C5, D0
        mov     rdx, qword 0FFFFFDFFFFFFFFFFH           ; 8182 _ 48: BA, FFFFFDFFFFFFFFFF
        and     rdx, rax                                ; 818C _ 48: 21. C2
        mov     eax, dword [rbp-104H]                   ; 818F _ 8B. 85, FFFFFEFC
        cdqe                                            ; 8195 _ 48: 98
        mov     qword [rbp+rax*8-30H], rdx              ; 8197 _ 48: 89. 54 C5, D0
?_0730: mov     eax, dword [rbp-104H]                   ; 819C _ 8B. 85, FFFFFEFC
        cdqe                                            ; 81A2 _ 48: 98
        mov     rax, qword [rbp+rax*8-30H]              ; 81A4 _ 48: 8B. 44 C5, D0
        mov     rdx, qword 50000000000H                 ; 81A9 _ 48: BA, 0000050000000000
        and     rax, rdx                                ; 81B3 _ 48: 21. D0
        test    rax, rax                                ; 81B6 _ 48: 85. C0
        jnz     ?_0731                                  ; 81B9 _ 75, 2E
        mov     eax, dword [rbp-104H]                   ; 81BB _ 8B. 85, FFFFFEFC
        cdqe                                            ; 81C1 _ 48: 98
        mov     rdx, qword [rbp+rax*8-30H]              ; 81C3 _ 48: 8B. 54 C5, D0
        mov     rax, qword 20000000000H                 ; 81C8 _ 48: B8, 0000020000000000
        and     rax, qword [rbp-0A8H]                   ; 81D2 _ 48: 23. 85, FFFFFF58
        or      rdx, rax                                ; 81D9 _ 48: 09. C2
        mov     eax, dword [rbp-104H]                   ; 81DC _ 8B. 85, FFFFFEFC
        cdqe                                            ; 81E2 _ 48: 98
        mov     qword [rbp+rax*8-30H], rdx              ; 81E4 _ 48: 89. 54 C5, D0
?_0731: mov     rax, qword 60000000000H                 ; 81E9 _ 48: B8, 0000060000000000
        and     rax, qword [rbp-0A8H]                   ; 81F3 _ 48: 23. 85, FFFFFF58
        mov     rdx, rax                                ; 81FA _ 48: 89. C2
        mov     rax, qword 60000000000H                 ; 81FD _ 48: B8, 0000060000000000
        cmp     rdx, rax                                ; 8207 _ 48: 39. C2
        jnz     ?_0732                                  ; 820A _ 75, 46
        mov     eax, dword [rbp-104H]                   ; 820C _ 8B. 85, FFFFFEFC
        cdqe                                            ; 8212 _ 48: 98
        mov     rax, qword [rbp+rax*8-30H]              ; 8214 _ 48: 8B. 44 C5, D0
        mov     rdx, qword 90000000000H                 ; 8219 _ 48: BA, 0000090000000000
        and     rax, rdx                                ; 8223 _ 48: 21. D0
        test    rax, rax                                ; 8226 _ 48: 85. C0
        jnz     ?_0732                                  ; 8229 _ 75, 27
        mov     eax, dword [rbp-104H]                   ; 822B _ 8B. 85, FFFFFEFC
        cdqe                                            ; 8231 _ 48: 98
        mov     rax, qword [rbp+rax*8-30H]              ; 8233 _ 48: 8B. 44 C5, D0
        mov     rdx, qword 60000000000H                 ; 8238 _ 48: BA, 0000060000000000
        or      rdx, rax                                ; 8242 _ 48: 09. C2
        mov     eax, dword [rbp-104H]                   ; 8245 _ 8B. 85, FFFFFEFC
        cdqe                                            ; 824B _ 48: 98
        mov     qword [rbp+rax*8-30H], rdx              ; 824D _ 48: 89. 54 C5, D0
?_0732: mov     eax, dword [rbp-104H]                   ; 8252 _ 8B. 85, FFFFFEFC
        cdqe                                            ; 8258 _ 48: 98
        mov     rax, qword [rbp+rax*8-30H]              ; 825A _ 48: 8B. 44 C5, D0
        and     rax, qword [rbp-0A8H]                   ; 825F _ 48: 23. 85, FFFFFF58
        and     eax, 02H                                ; 8266 _ 83. E0, 02
        shr     rax, 1                                  ; 8269 _ 48: D1. E8
        and     eax, 01H                                ; 826C _ 83. E0, 01
        movzx   eax, al                                 ; 826F _ 0F B6. C0
        test    rax, rax                                ; 8272 _ 48: 85. C0
        je      ?_0735                                  ; 8275 _ 0F 84, 00000101
        mov     eax, dword [rbp-104H]                   ; 827B _ 8B. 85, FFFFFEFC
        cdqe                                            ; 8281 _ 48: 98
        mov     rdx, qword [rbp+rax*8-90H]              ; 8283 _ 48: 8B. 94 C5, FFFFFF70
        mov     rax, qword 100000000H                   ; 828B _ 48: B8, 0000000100000000
        cmp     rdx, rax                                ; 8295 _ 48: 39. C2
        jnz     ?_0733                                  ; 8298 _ 75, 57
        mov     rax, qword [rbp-0A8H]                   ; 829A _ 48: 8B. 85, FFFFFF58
        and     eax, 300000H                            ; 82A1 _ 25, 00300000
        test    rax, rax                                ; 82A6 _ 48: 85. C0
        je      ?_0734                                  ; 82A9 _ 0F 84, 0000008F
        mov     eax, dword [rbp-104H]                   ; 82AF _ 8B. 85, FFFFFEFC
        cdqe                                            ; 82B5 _ 48: 98
        mov     rdx, qword [rbp+rax*8-60H]              ; 82B7 _ 48: 8B. 54 C5, A0
        mov     eax, dword [rbp-104H]                   ; 82BC _ 8B. 85, FFFFFEFC
        cdqe                                            ; 82C2 _ 48: 98
        mov     qword [rbp+rax*8-90H], rdx              ; 82C4 _ 48: 89. 94 C5, FFFFFF70
        mov     eax, dword [rbp-104H]                   ; 82CC _ 8B. 85, FFFFFEFC
        cdqe                                            ; 82D2 _ 48: 98
        mov     rax, qword [rbp+rax*8-30H]              ; 82D4 _ 48: 8B. 44 C5, D0
        or      rax, 300000H                            ; 82D9 _ 48: 0D, 00300000
        mov     rdx, rax                                ; 82DF _ 48: 89. C2
        mov     eax, dword [rbp-104H]                   ; 82E2 _ 8B. 85, FFFFFEFC
        cdqe                                            ; 82E8 _ 48: 98
        mov     qword [rbp+rax*8-30H], rdx              ; 82EA _ 48: 89. 54 C5, D0
        jmp     ?_0734                                  ; 82EF _ EB, 4D

?_0733: mov     eax, dword [rbp-104H]                   ; 82F1 _ 8B. 85, FFFFFEFC
        cdqe                                            ; 82F7 _ 48: 98
        mov     rdx, qword [rbp+rax*8-90H]              ; 82F9 _ 48: 8B. 94 C5, FFFFFF70
        mov     rax, qword 400000000H                   ; 8301 _ 48: B8, 0000000400000000
        cmp     rdx, rax                                ; 830B _ 48: 39. C2
        jnz     ?_0734                                  ; 830E _ 75, 2E
        mov     rax, qword [rbp-0A8H]                   ; 8310 _ 48: 8B. 85, FFFFFF58
        and     eax, 0C00000H                           ; 8317 _ 25, 00C00000
        test    rax, rax                                ; 831C _ 48: 85. C0
        jz      ?_0734                                  ; 831F _ 74, 1D
        mov     eax, dword [rbp-104H]                   ; 8321 _ 8B. 85, FFFFFEFC
        cdqe                                            ; 8327 _ 48: 98
        mov     rdx, qword [rbp+rax*8-60H]              ; 8329 _ 48: 8B. 54 C5, A0
        mov     eax, dword [rbp-104H]                   ; 832E _ 8B. 85, FFFFFEFC
        cdqe                                            ; 8334 _ 48: 98
        mov     qword [rbp+rax*8-90H], rdx              ; 8336 _ 48: 89. 94 C5, FFFFFF70
?_0734: mov     rax, qword [rbp-128H]                   ; 833E _ 48: 8B. 85, FFFFFED8
        mov     esi, 23                                 ; 8345 _ BE, 00000017
        mov     rdi, rax                                ; 834A _ 48: 89. C7
        call    itemp_has                               ; 834D _ E8, FFFF805E
        xor     eax, 01H                                ; 8352 _ 83. F0, 01
        test    al, al                                  ; 8355 _ 84. C0
        jz      ?_0735                                  ; 8357 _ 74, 23
        mov     eax, dword [rbp-104H]                   ; 8359 _ 8B. 85, FFFFFEFC
        cdqe                                            ; 835F _ 48: 98
        mov     rax, qword [rbp+rax*8-30H]              ; 8361 _ 48: 8B. 44 C5, D0
        or      rax, 400002H                            ; 8366 _ 48: 0D, 00400002
        mov     rdx, rax                                ; 836C _ 48: 89. C2
        mov     eax, dword [rbp-104H]                   ; 836F _ 8B. 85, FFFFFEFC
        cdqe                                            ; 8375 _ 48: 98
        mov     qword [rbp+rax*8-30H], rdx              ; 8377 _ 48: 89. 54 C5, D0
?_0735: mov     eax, dword [rbp-104H]                   ; 837C _ 8B. 85, FFFFFEFC
        cdqe                                            ; 8382 _ 48: 98
        mov     rax, qword [rbp+rax*8-30H]              ; 8384 _ 48: 8B. 44 C5, D0
        not     rax                                     ; 8389 _ 48: F7. D0
        and     rax, qword [rbp-0A8H]                   ; 838C _ 48: 23. 85, FFFFFF58
        mov     rdx, rax                                ; 8393 _ 48: 89. C2
        mov     rax, qword 1F000000000000H              ; 8396 _ 48: B8, 001F000000000000
        or      rax, qword [rbp-0C0H]                   ; 83A0 _ 48: 0B. 85, FFFFFF40
        not     rax                                     ; 83A7 _ 48: F7. D0
        and     rax, rdx                                ; 83AA _ 48: 21. D0
        test    rax, rax                                ; 83AD _ 48: 85. C0
        jz      ?_0736                                  ; 83B0 _ 74, 0A
        mov     eax, 0                                  ; 83B2 _ B8, 00000000
        jmp     ?_0785                                  ; 83B7 _ E9, 00000920

?_0736: movzx   eax, word [rbp-108H]                    ; 83BC _ 0F B7. 85, FFFFFEF8
        not     eax                                     ; 83C3 _ F7. D0
        mov     edx, eax                                ; 83C5 _ 89. C2
        movzx   eax, word [rbp-10AH]                    ; 83C7 _ 0F B7. 85, FFFFFEF6
        and     eax, edx                                ; 83CE _ 21. D0
        cdqe                                            ; 83D0 _ 48: 98
        and     eax, 0FH                                ; 83D2 _ 83. E0, 0F
        test    rax, rax                                ; 83D5 _ 48: 85. C0
        jz      ?_0737                                  ; 83D8 _ 74, 0A
        mov     eax, 4                                  ; 83DA _ B8, 00000004
        jmp     ?_0785                                  ; 83DF _ E9, 000008F8

?_0737: movzx   eax, word [rbp-108H]                    ; 83E4 _ 0F B7. 85, FFFFFEF8
        not     eax                                     ; 83EB _ F7. D0
        mov     edx, eax                                ; 83ED _ 89. C2
        movzx   eax, word [rbp-10AH]                    ; 83EF _ 0F B7. 85, FFFFFEF6
        and     eax, edx                                ; 83F6 _ 21. D0
        cdqe                                            ; 83F8 _ 48: 98
        and     eax, 0D0H                               ; 83FA _ 25, 000000D0
        test    rax, rax                                ; 83FF _ 48: 85. C0
        jz      ?_0738                                  ; 8402 _ 74, 0A
        mov     eax, 7                                  ; 8404 _ B8, 00000007
        jmp     ?_0785                                  ; 8409 _ E9, 000008CE

?_0738: mov     rax, qword [rbp-0A8H]                   ; 840E _ 48: 8B. 85, FFFFFF58
        not     rax                                     ; 8415 _ 48: F7. D0
        mov     rdx, rax                                ; 8418 _ 48: 89. C2
        mov     eax, dword [rbp-104H]                   ; 841B _ 8B. 85, FFFFFEFC
        cdqe                                            ; 8421 _ 48: 98
        mov     rax, qword [rbp+rax*8-30H]              ; 8423 _ 48: 8B. 44 C5, D0
        and     rdx, rax                                ; 8428 _ 48: 21. C2
        mov     rax, qword 1F000000000000H              ; 842B _ 48: B8, 001F000000000000
        and     rax, rdx                                ; 8435 _ 48: 21. D0
        test    rax, rax                                ; 8438 _ 48: 85. C0
        jz      ?_0740                                  ; 843B _ 74, 2A
        mov     rax, qword 1F000000000000H              ; 843D _ 48: B8, 001F000000000000
        and     rax, qword [rbp-0A8H]                   ; 8447 _ 48: 23. 85, FFFFFF58
        test    rax, rax                                ; 844E _ 48: 85. C0
        jz      ?_0739                                  ; 8451 _ 74, 0A
        mov     eax, 18                                 ; 8453 _ B8, 00000012
        jmp     ?_0785                                  ; 8458 _ E9, 0000087F

?_0739: mov     eax, 19                                 ; 845D _ B8, 00000013
        jmp     ?_0785                                  ; 8462 _ E9, 00000875

?_0740: add     dword [rbp-104H], 1                     ; 8467 _ 83. 85, FFFFFEFC, 01
?_0741: mov     eax, dword [rbp-104H]                   ; 846E _ 8B. 85, FFFFFEFC
        cmp     eax, dword [rbp-0F0H]                   ; 8474 _ 3B. 85, FFFFFF10
        jl      ?_0724                                  ; 847A _ 0F 8C, FFFFFB3B
        mov     rax, qword [rbp-128H]                   ; 8480 _ 48: 8B. 85, FFFFFED8
        mov     eax, dword [rax+48H]                    ; 8487 _ 8B. 40, 48
        mov     eax, eax                                ; 848A _ 89. C0
        imul    rax, rax, 28                            ; 848C _ 48: 6B. C0, 1C
        lea     rdx, [rel insns_flags]                  ; 8490 _ 48: 8D. 15, 00000000(rel)
        mov     eax, dword [rax+rdx]                    ; 8497 _ 8B. 04 10
        and     eax, 7FFC00H                            ; 849A _ 25, 007FFC00
        mov     dword [rbp-0ECH], eax                   ; 849F _ 89. 85, FFFFFF14
        mov     qword [rbp-0D8H], 0                     ; 84A5 _ 48: C7. 85, FFFFFF28, 00000000
        mov     eax, dword [rbp-0ECH]                   ; 84B0 _ 8B. 85, FFFFFF14
        and     eax, 80000H                             ; 84B6 _ 25, 00080000
        test    eax, eax                                ; 84BB _ 85. C0
        jz      ?_0742                                  ; 84BD _ 74, 10
        mov     rax, qword [rbp-0B8H]                   ; 84BF _ 48: 8B. 85, FFFFFF48
        mov     qword [rbp-0D8H], rax                   ; 84C6 _ 48: 89. 85, FFFFFF28
        jmp     ?_0743                                  ; 84CD _ EB, 2B

?_0742: mov     eax, dword [rbp-0ECH]                   ; 84CF _ 8B. 85, FFFFFF14
        and     eax, 100000H                            ; 84D5 _ 25, 00100000
        test    eax, eax                                ; 84DA _ 85. C0
        jz      ?_0743                                  ; 84DC _ 74, 1C
        mov     rax, qword [rbp-130H]                   ; 84DE _ 48: 8B. 85, FFFFFED0
        movzx   eax, byte [rax+7CH]                     ; 84E5 _ 0F B6. 40, 7C
        movzx   eax, al                                 ; 84E9 _ 0F B6. C0
        mov     edi, eax                                ; 84EC _ 89. C7
        call    mode_to_op                              ; 84EE _ E8, FFFF82D7
        mov     qword [rbp-0D8H], rax                   ; 84F3 _ 48: 89. 85, FFFFFF28
?_0743: mov     rax, qword [rbp-128H]                   ; 84FA _ 48: 8B. 85, FFFFFED8
        mov     eax, dword [rax+48H]                    ; 8501 _ 8B. 40, 48
        mov     eax, eax                                ; 8504 _ 89. C0
        imul    rax, rax, 28                            ; 8506 _ 48: 6B. C0, 1C
        lea     rdx, [rel insns_flags]                  ; 850A _ 48: 8D. 15, 00000000(rel)
        mov     eax, dword [rax+rdx]                    ; 8511 _ 8B. 04 10
        shr     eax, 5                                  ; 8514 _ C1. E8, 05
        and     eax, 1FH                                ; 8517 _ 83. E0, 1F
        mov     dword [rbp-0E8H], eax                   ; 851A _ 89. 85, FFFFFF18
        mov     rax, qword [rbp-128H]                   ; 8520 _ 48: 8B. 85, FFFFFED8
        mov     eax, dword [rax+48H]                    ; 8527 _ 8B. 40, 48
        mov     eax, eax                                ; 852A _ 89. C0
        imul    rax, rax, 28                            ; 852C _ 48: 6B. C0, 1C
        lea     rdx, [rel insns_flags]                  ; 8530 _ 48: 8D. 15, 00000000(rel)
        mov     eax, dword [rax+rdx]                    ; 8537 _ 8B. 04 10
        and     eax, 1FH                                ; 853A _ 83. E0, 1F
        mov     dword [rbp-0E4H], eax                   ; 853D _ 89. 85, FFFFFF1C
        movzx   eax, byte [rbp-116H]                    ; 8543 _ 0F B6. 85, FFFFFEEA
        xor     eax, 01H                                ; 854A _ 83. F0, 01
        test    al, al                                  ; 854D _ 84. C0
        je      ?_0748                                  ; 854F _ 0F 84, 000000CA
        mov     dword [rbp-104H], 0                     ; 8555 _ C7. 85, FFFFFEFC, 00000000
        jmp     ?_0747                                  ; 855F _ E9, 000000A9

?_0744: mov     eax, dword [rbp-104H]                   ; 8564 _ 8B. 85, FFFFFEFC
        mov     edx, 1                                  ; 856A _ BA, 00000001
        mov     ecx, eax                                ; 856F _ 89. C1
        shl     edx, cl                                 ; 8571 _ D3. E2
        mov     eax, edx                                ; 8573 _ 89. D0
        mov     dword [rbp-0E0H], eax                   ; 8575 _ 89. 85, FFFFFF20
        mov     eax, dword [rbp-104H]                   ; 857B _ 8B. 85, FFFFFEFC
        cdqe                                            ; 8581 _ 48: 98
        mov     rax, qword [rbp+rax*8-90H]              ; 8583 _ 48: 8B. 84 C5, FFFFFF70
        test    rax, rax                                ; 858B _ 48: 85. C0
        jnz     ?_0746                                  ; 858E _ 75, 76
        mov     eax, dword [rbp-104H]                   ; 8590 _ 8B. 85, FFFFFEFC
        cdqe                                            ; 8596 _ 48: 98
        mov     rax, qword [rbp+rax*8-30H]              ; 8598 _ 48: 8B. 44 C5, D0
        mov     rsi, rax                                ; 859D _ 48: 89. C6
        mov     edi, 1                                  ; 85A0 _ BF, 00000001
        call    is_class                                ; 85A5 _ E8, FFFF7BB2
        test    al, al                                  ; 85AA _ 84. C0
        jz      ?_0745                                  ; 85AC _ 74, 31
        mov     eax, dword [rbp-104H]                   ; 85AE _ 8B. 85, FFFFFEFC
        cdqe                                            ; 85B4 _ 48: 98
        mov     rax, qword [rbp+rax*8-60H]              ; 85B6 _ 48: 8B. 44 C5, A0
        test    rax, rax                                ; 85BB _ 48: 85. C0
        jz      ?_0745                                  ; 85BE _ 74, 1F
        mov     eax, dword [rbp-104H]                   ; 85C0 _ 8B. 85, FFFFFEFC
        cdqe                                            ; 85C6 _ 48: 98
        mov     rdx, qword [rbp+rax*8-60H]              ; 85C8 _ 48: 8B. 54 C5, A0
        mov     eax, dword [rbp-104H]                   ; 85CD _ 8B. 85, FFFFFEFC
        cdqe                                            ; 85D3 _ 48: 98
        mov     qword [rbp+rax*8-90H], rdx              ; 85D5 _ 48: 89. 94 C5, FFFFFF70
        jmp     ?_0746                                  ; 85DD _ EB, 27

?_0745: mov     eax, dword [rbp-0E8H]                   ; 85DF _ 8B. 85, FFFFFF18
        and     eax, dword [rbp-0E0H]                   ; 85E5 _ 23. 85, FFFFFF20
        test    eax, eax                                ; 85EB _ 85. C0
        jz      ?_0746                                  ; 85ED _ 74, 17
        mov     eax, dword [rbp-104H]                   ; 85EF _ 8B. 85, FFFFFEFC
        cdqe                                            ; 85F5 _ 48: 98
        mov     rdx, qword [rbp-0D8H]                   ; 85F7 _ 48: 8B. 95, FFFFFF28
        mov     qword [rbp+rax*8-90H], rdx              ; 85FE _ 48: 89. 94 C5, FFFFFF70
?_0746: add     dword [rbp-104H], 1                     ; 8606 _ 83. 85, FFFFFEFC, 01
?_0747: mov     eax, dword [rbp-104H]                   ; 860D _ 8B. 85, FFFFFEFC
        cmp     eax, dword [rbp-0F0H]                   ; 8613 _ 3B. 85, FFFFFF10
        jl      ?_0744                                  ; 8619 _ 0F 8C, FFFFFF45
?_0748: mov     rax, qword [rbp-0C0H]                   ; 861F _ 48: 8B. 85, FFFFFF40
        mov     qword [rbp-0D0H], rax                   ; 8626 _ 48: 89. 85, FFFFFF30
        mov     byte [rbp-118H], 0                      ; 862D _ C6. 85, FFFFFEE8, 00
        cmp     dword [rbp-0E4H], 0                     ; 8634 _ 83. BD, FFFFFF1C, 00
        je      ?_0753                                  ; 863B _ 0F 84, 000000DF
        mov     dword [rbp-0FCH], 0                     ; 8641 _ C7. 85, FFFFFF04, 00000000
        mov     dword [rbp-104H], 0                     ; 864B _ C7. 85, FFFFFEFC, 00000000
        jmp     ?_0752                                  ; 8655 _ E9, 0000009B

?_0749: mov     eax, dword [rbp-104H]                   ; 865A _ 8B. 85, FFFFFEFC
        mov     edx, 1                                  ; 8660 _ BA, 00000001
        mov     ecx, eax                                ; 8665 _ 89. C1
        shl     edx, cl                                 ; 8667 _ D3. E2
        mov     eax, edx                                ; 8669 _ 89. D0
        mov     dword [rbp-0DCH], eax                   ; 866B _ 89. 85, FFFFFF24
        mov     eax, dword [rbp-104H]                   ; 8671 _ 8B. 85, FFFFFEFC
        cdqe                                            ; 8677 _ 48: 98
        mov     rax, qword [rbp+rax*8-90H]              ; 8679 _ 48: 8B. 84 C5, FFFFFF70
        test    rax, rax                                ; 8681 _ 48: 85. C0
        jz      ?_0750                                  ; 8684 _ 74, 29
        mov     eax, dword [rbp-0E4H]                   ; 8686 _ 8B. 85, FFFFFF1C
        and     eax, dword [rbp-0DCH]                   ; 868C _ 23. 85, FFFFFF24
        test    eax, eax                                ; 8692 _ 85. C0
        jz      ?_0751                                  ; 8694 _ 74, 58
        mov     eax, dword [rbp-104H]                   ; 8696 _ 8B. 85, FFFFFEFC
        cdqe                                            ; 869C _ 48: 98
        mov     rax, qword [rbp+rax*8-90H]              ; 869E _ 48: 8B. 84 C5, FFFFFF70
        and     qword [rbp-0D0H], rax                   ; 86A6 _ 48: 21. 85, FFFFFF30
        jmp     ?_0751                                  ; 86AD _ EB, 3F

?_0750: mov     eax, dword [rbp-104H]                   ; 86AF _ 8B. 85, FFFFFEFC
        cdqe                                            ; 86B5 _ 48: 98
        mov     rax, qword [rbp+rax*8-60H]              ; 86B7 _ 48: 8B. 44 C5, A0
        test    rax, rax                                ; 86BC _ 48: 85. C0
        jz      ?_0751                                  ; 86BF _ 74, 2D
        mov     eax, dword [rbp-104H]                   ; 86C1 _ 8B. 85, FFFFFEFC
        cdqe                                            ; 86C7 _ 48: 98
        mov     rax, qword [rbp+rax*8-30H]              ; 86C9 _ 48: 8B. 44 C5, D0
        mov     rsi, rax                                ; 86CE _ 48: 89. C6
        mov     edi, 1                                  ; 86D1 _ BF, 00000001
        call    is_class                                ; 86D6 _ E8, FFFF7A81
        xor     eax, 01H                                ; 86DB _ 83. F0, 01
        test    al, al                                  ; 86DE _ 84. C0
        jz      ?_0751                                  ; 86E0 _ 74, 0C
        mov     eax, dword [rbp-0DCH]                   ; 86E2 _ 8B. 85, FFFFFF24
        or      dword [rbp-0FCH], eax                   ; 86E8 _ 09. 85, FFFFFF04
?_0751: add     dword [rbp-104H], 1                     ; 86EE _ 83. 85, FFFFFEFC, 01
?_0752: mov     eax, dword [rbp-104H]                   ; 86F5 _ 8B. 85, FFFFFEFC
        cmp     eax, dword [rbp-0F0H]                   ; 86FB _ 3B. 85, FFFFFF10
        jl      ?_0749                                  ; 8701 _ 0F 8C, FFFFFF53
        mov     eax, dword [rbp-0FCH]                   ; 8707 _ 8B. 85, FFFFFF04
        not     eax                                     ; 870D _ F7. D0
        and     eax, dword [rbp-0E4H]                   ; 870F _ 23. 85, FFFFFF1C
        test    eax, eax                                ; 8715 _ 85. C0
        sete    al                                      ; 8717 _ 0F 94. C0
        mov     byte [rbp-118H], al                     ; 871A _ 88. 85, FFFFFEE8
?_0753: mov     dword [rbp-104H], 0                     ; 8720 _ C7. 85, FFFFFEFC, 00000000
        jmp     ?_0765                                  ; 872A _ E9, 00000295

?_0754: mov     eax, dword [rbp-104H]                   ; 872F _ 8B. 85, FFFFFEFC
        cdqe                                            ; 8735 _ 48: 98
        mov     rax, qword [rbp+rax*8-30H]              ; 8737 _ 48: 8B. 44 C5, D0
        mov     qword [rbp-0B0H], rax                   ; 873C _ 48: 89. 85, FFFFFF50
        mov     rcx, qword [rbp-130H]                   ; 8743 _ 48: 8B. 8D, FFFFFED0
        mov     eax, dword [rbp-104H]                   ; 874A _ 8B. 85, FFFFFEFC
        movsxd  rdx, eax                                ; 8750 _ 48: 63. D0
        mov     rax, rdx                                ; 8753 _ 48: 89. D0
        shl     rax, 3                                  ; 8756 _ 48: C1. E0, 03
        add     rax, rdx                                ; 875A _ 48: 01. D0
        shl     rax, 3                                  ; 875D _ 48: C1. E0, 03
        add     rax, rcx                                ; 8761 _ 48: 01. C8
        add     rax, 256                                ; 8764 _ 48: 05, 00000100
        movzx   eax, word [rax]                         ; 876A _ 0F B7. 00
        mov     word [rbp-110H], ax                     ; 876D _ 66: 89. 85, FFFFFEF0
        mov     rax, qword [rbp-128H]                   ; 8774 _ 48: 8B. 85, FFFFFED8
        mov     edx, dword [rbp-104H]                   ; 877B _ 8B. 95, FFFFFEFC
        movsxd  rdx, edx                                ; 8781 _ 48: 63. D2
        add     rdx, 24                                 ; 8784 _ 48: 83. C2, 18
        movzx   eax, word [rax+rdx*2]                   ; 8788 _ 0F B7. 04 50
        mov     word [rbp-10EH], ax                     ; 878C _ 66: 89. 85, FFFFFEF2
        movzx   eax, word [rbp-110H]                    ; 8793 _ 0F B7. 85, FFFFFEF0
        and     eax, 20H                                ; 879A _ 83. E0, 20
        shr     rax, 5                                  ; 879D _ 48: C1. E8, 05
        and     eax, 01H                                ; 87A1 _ 83. E0, 01
        mov     byte [rbp-115H], al                     ; 87A4 _ 88. 85, FFFFFEEB
        mov     eax, dword [rbp-104H]                   ; 87AA _ 8B. 85, FFFFFEFC
        mov     edx, dword [rbp-0E8H]                   ; 87B0 _ 8B. 95, FFFFFF18
        mov     ecx, eax                                ; 87B6 _ 89. C1
        shr     edx, cl                                 ; 87B8 _ D3. EA
        mov     eax, edx                                ; 87BA _ 89. D0
        mov     byte [rbp-114H], al                     ; 87BC _ 88. 85, FFFFFEEC
        and     byte [rbp-114H], 01H                    ; 87C2 _ 80. A5, FFFFFEEC, 01
        mov     eax, dword [rbp-104H]                   ; 87C9 _ 8B. 85, FFFFFEFC
        mov     edx, dword [rbp-0E4H]                   ; 87CF _ 8B. 95, FFFFFF1C
        mov     ecx, eax                                ; 87D5 _ 89. C1
        shr     edx, cl                                 ; 87D7 _ D3. EA
        mov     eax, edx                                ; 87D9 _ 89. D0
        mov     byte [rbp-113H], al                     ; 87DB _ 88. 85, FFFFFEED
        and     byte [rbp-113H], 01H                    ; 87E1 _ 80. A5, FFFFFEED, 01
        mov     rax, qword [rbp-0B0H]                   ; 87E8 _ 48: 8B. 85, FFFFFF50
        mov     rsi, rax                                ; 87EF _ 48: 89. C6
        mov     edi, 1                                  ; 87F2 _ BF, 00000001
        call    is_class                                ; 87F7 _ E8, FFFF7960
        mov     byte [rbp-112H], al                     ; 87FC _ 88. 85, FFFFFEEE
        mov     eax, dword [rbp-104H]                   ; 8802 _ 8B. 85, FFFFFEFC
        cdqe                                            ; 8808 _ 48: 98
        mov     rax, qword [rbp+rax*8-60H]              ; 880A _ 48: 8B. 44 C5, A0
        test    rax, rax                                ; 880F _ 48: 85. C0
        je      ?_0760                                  ; 8812 _ 0F 84, 000000A5
        mov     eax, dword [rbp-104H]                   ; 8818 _ 8B. 85, FFFFFEFC
        cdqe                                            ; 881E _ 48: 98
        mov     rdx, qword [rbp+rax*8-90H]              ; 8820 _ 48: 8B. 94 C5, FFFFFF70
        mov     eax, dword [rbp-104H]                   ; 8828 _ 8B. 85, FFFFFEFC
        cdqe                                            ; 882E _ 48: 98
        mov     rax, qword [rbp+rax*8-60H]              ; 8830 _ 48: 8B. 44 C5, A0
        cmp     rdx, rax                                ; 8835 _ 48: 39. C2
        jz      ?_0756                                  ; 8838 _ 74, 5D
        cmp     byte [rbp-114H], 0                      ; 883A _ 80. BD, FFFFFEEC, 00
        jz      ?_0755                                  ; 8841 _ 74, 2D
        cmp     byte [rbp-117H], 0                      ; 8843 _ 80. BD, FFFFFEE9, 00
        jnz     ?_0757                                  ; 884A _ 75, 4E
        movzx   eax, byte [rbp-116H]                    ; 884C _ 0F B6. 85, FFFFFEEA
        test    rax, rax                                ; 8853 _ 48: 85. C0
        jz      ?_0755                                  ; 8856 _ 74, 18
        movzx   eax, byte [rbp-112H]                    ; 8858 _ 0F B6. 85, FFFFFEEE
        xor     eax, 01H                                ; 885F _ 83. F0, 01
        test    al, al                                  ; 8862 _ 84. C0
        jz      ?_0755                                  ; 8864 _ 74, 0A
        mov     eax, 1                                  ; 8866 _ B8, 00000001
        jmp     ?_0785                                  ; 886B _ E9, 0000046C

?_0755: mov     eax, dword [rbp-104H]                   ; 8870 _ 8B. 85, FFFFFEFC
        cdqe                                            ; 8876 _ 48: 98
        mov     rax, qword [rbp+rax*8-90H]              ; 8878 _ 48: 8B. 84 C5, FFFFFF70
        test    rax, rax                                ; 8880 _ 48: 85. C0
        jz      ?_0758                                  ; 8883 _ 74, 18
        movzx   eax, byte [rbp-112H]                    ; 8885 _ 0F B6. 85, FFFFFEEE
        xor     eax, 01H                                ; 888C _ 83. F0, 01
        movzx   eax, al                                 ; 888F _ 0F B6. C0
        jmp     ?_0785                                  ; 8892 _ E9, 00000445

?_0756: nop                                             ; 8897 _ 90
        jmp     ?_0759                                  ; 8898 _ EB, 04

?_0757: nop                                             ; 889A _ 90
        jmp     ?_0759                                  ; 889B _ EB, 01

?_0758: nop                                             ; 889D _ 90
?_0759: cmp     byte [rbp-113H], 0                      ; 889E _ 80. BD, FFFFFEED, 00
        jz      ?_0761                                  ; 88A5 _ 74, 4A
        mov     eax, dword [rbp-104H]                   ; 88A7 _ 8B. 85, FFFFFEFC
        cdqe                                            ; 88AD _ 48: 98
        mov     rax, qword [rbp+rax*8-60H]              ; 88AF _ 48: 8B. 44 C5, A0
        and     qword [rbp-0D0H], rax                   ; 88B4 _ 48: 21. 85, FFFFFF30
        jmp     ?_0761                                  ; 88BB _ EB, 34

?_0760: movzx   eax, byte [rbp-116H]                    ; 88BD _ 0F B6. 85, FFFFFEEA
        test    rax, rax                                ; 88C4 _ 48: 85. C0
        jz      ?_0761                                  ; 88C7 _ 74, 28
        cmp     byte [rbp-114H], 0                      ; 88C9 _ 80. BD, FFFFFEEC, 00
        jz      ?_0761                                  ; 88D0 _ 74, 1F
        mov     eax, dword [rbp-104H]                   ; 88D2 _ 8B. 85, FFFFFEFC
        cdqe                                            ; 88D8 _ 48: 98
        mov     rax, qword [rbp+rax*8-90H]              ; 88DA _ 48: 8B. 84 C5, FFFFFF70
        test    rax, rax                                ; 88E2 _ 48: 85. C0
        jz      ?_0761                                  ; 88E5 _ 74, 0A
        mov     eax, 1                                  ; 88E7 _ B8, 00000001
        jmp     ?_0785                                  ; 88EC _ E9, 000003EB

?_0761: mov     rax, qword [rbp-0B0H]                   ; 88F1 _ 48: 8B. 85, FFFFFF50
        mov     rdx, qword 150200105H                   ; 88F8 _ 48: BA, 0000000150200105
        mov     rsi, rax                                ; 8902 _ 48: 89. C6
        mov     rdi, rdx                                ; 8905 _ 48: 89. D7
        call    is_class                                ; 8908 _ E8, FFFF784F
        test    al, al                                  ; 890D _ 84. C0
        jz      ?_0762                                  ; 890F _ 74, 18
        mov     rax, qword [rbp-130H]                   ; 8911 _ 48: 8B. 85, FFFFFED0
        mov     eax, dword [rax+30H]                    ; 8918 _ 8B. 40, 30
        test    eax, eax                                ; 891B _ 85. C0
        jz      ?_0762                                  ; 891D _ 74, 0A
        mov     eax, 0                                  ; 891F _ B8, 00000000
        jmp     ?_0785                                  ; 8924 _ E9, 000003B3

?_0762: cmp     byte [rbp-115H], 0                      ; 8929 _ 80. BD, FFFFFEEB, 00
        je      ?_0764                                  ; 8930 _ 0F 84, 00000087
        movzx   eax, word [rbp-10EH]                    ; 8936 _ 0F B7. 85, FFFFFEF2
; Note: Length-changing prefix causes delay on old Intel processors
        and     ax, 0F00H                               ; 893D _ 66: 25, 0F00
        mov     word [rbp-10CH], ax                     ; 8941 _ 66: 89. 85, FFFFFEF4
        mov     dword [rbp-0F8H], 0                     ; 8948 _ C7. 85, FFFFFF08, 00000000
        cmp     word [rbp-10CH], 0                      ; 8952 _ 66: 83. BD, FFFFFEF4, 00
        jz      ?_0763                                  ; 895A _ 74, 36
        mov     eax, dword [rbp-104H]                   ; 895C _ 8B. 85, FFFFFEFC
        cdqe                                            ; 8962 _ 48: 98
        mov     rdx, qword [rbp+rax*8-60H]              ; 8964 _ 48: 8B. 54 C5, A0
        mov     rax, qword [rbp-128H]                   ; 8969 _ 48: 8B. 85, FFFFFED8
        mov     ecx, dword [rbp-104H]                   ; 8970 _ 8B. 8D, FFFFFEFC
        movsxd  rcx, ecx                                ; 8976 _ 48: 63. C9
        mov     rax, qword [rax+rcx*8+8H]               ; 8979 _ 48: 8B. 44 C8, 08
        mov     rsi, rdx                                ; 897E _ 48: 89. D6
        mov     rdi, rax                                ; 8981 _ 48: 89. C7
        call    get_broadcast_num                       ; 8984 _ E8, FFFFF06D
        movzx   eax, al                                 ; 8989 _ 0F B6. C0
        mov     dword [rbp-0F8H], eax                   ; 898C _ 89. 85, FFFFFF08
?_0763: movzx   eax, word [rbp-110H]                    ; 8992 _ 0F B7. 85, FFFFFEF0
        shr     rax, 12                                 ; 8999 _ 48: C1. E8, 0C
        and     eax, 07H                                ; 899D _ 83. E0, 07
        mov     edx, 2                                  ; 89A0 _ BA, 00000002
        mov     ecx, eax                                ; 89A5 _ 89. C1
        shl     edx, cl                                 ; 89A7 _ D3. E2
        mov     eax, edx                                ; 89A9 _ 89. D0
        cmp     dword [rbp-0F8H], eax                   ; 89AB _ 39. 85, FFFFFF08
        jz      ?_0764                                  ; 89B1 _ 74, 0A
        mov     eax, 6                                  ; 89B3 _ B8, 00000006
        jmp     ?_0785                                  ; 89B8 _ E9, 0000031F

?_0764: add     dword [rbp-104H], 1                     ; 89BD _ 83. 85, FFFFFEFC, 01
?_0765: mov     eax, dword [rbp-104H]                   ; 89C4 _ 8B. 85, FFFFFEFC
        cmp     eax, dword [rbp-0F0H]                   ; 89CA _ 3B. 85, FFFFFF10
        jl      ?_0754                                  ; 89D0 _ 0F 8C, FFFFFD59
        cmp     dword [rbp-0E4H], 0                     ; 89D6 _ 83. BD, FFFFFF1C, 00
        jz      ?_0768                                  ; 89DD _ 74, 51
        cmp     qword [rbp-0D0H], 0                     ; 89DF _ 48: 83. BD, FFFFFF30, 00
        jnz     ?_0766                                  ; 89E7 _ 75, 0A
        mov     eax, 3                                  ; 89E9 _ B8, 00000003
        jmp     ?_0785                                  ; 89EE _ E9, 000002E9

?_0766: cmp     qword [rbp-0D0H], 0                     ; 89F3 _ 48: 83. BD, FFFFFF30, 00
        jz      ?_0767                                  ; 89FB _ 74, 29
        mov     rax, qword [rbp-0D0H]                   ; 89FD _ 48: 8B. 85, FFFFFF30
        sub     rax, 1                                  ; 8A04 _ 48: 83. E8, 01
        and     rax, qword [rbp-0D0H]                   ; 8A08 _ 48: 23. 85, FFFFFF30
        test    rax, rax                                ; 8A0F _ 48: 85. C0
        jnz     ?_0767                                  ; 8A12 _ 75, 12
        cmp     byte [rbp-116H], 0                      ; 8A14 _ 80. BD, FFFFFEEA, 00
        jz      ?_0768                                  ; 8A1B _ 74, 13
        cmp     byte [rbp-118H], 0                      ; 8A1D _ 80. BD, FFFFFEE8, 00
        jz      ?_0768                                  ; 8A24 _ 74, 0A
?_0767: mov     eax, 2                                  ; 8A26 _ B8, 00000002
        jmp     ?_0785                                  ; 8A2B _ E9, 000002AC

?_0768: mov     rax, qword [rbp-128H]                   ; 8A30 _ 48: 8B. 85, FFFFFED8
        mov     eax, dword [rax+48H]                    ; 8A37 _ 8B. 40, 48
        mov     eax, eax                                ; 8A3A _ 89. C0
        imul    rax, rax, 28                            ; 8A3C _ 48: 6B. C0, 1C
        lea     rdx, [rel insns_flags]                  ; 8A40 _ 48: 8D. 15, 00000000(rel)
        add     rax, rdx                                ; 8A47 _ 48: 01. D0
        lea     rdx, [rel cpu]                          ; 8A4A _ 48: 8D. 15, 00000000(rel)
        mov     rsi, rdx                                ; 8A51 _ 48: 89. D6
        mov     rdi, rax                                ; 8A54 _ 48: 89. C7
        call    iflag_cmp_cpu_level                     ; 8A57 _ E8, FFFF78EE
        test    eax, eax                                ; 8A5C _ 85. C0
        jle     ?_0769                                  ; 8A5E _ 7E, 0A
        mov     eax, 12                                 ; 8A60 _ B8, 0000000C
        jmp     ?_0785                                  ; 8A65 _ E9, 00000272

?_0769: cmp     dword [rbp-0F4H], 64                    ; 8A6A _ 83. BD, FFFFFF0C, 40
        jnz     ?_0770                                  ; 8A71 _ 75, 07
        mov     edx, 44                                 ; 8A73 _ BA, 0000002C
        jmp     ?_0771                                  ; 8A78 _ EB, 05

?_0770: mov     edx, 45                                 ; 8A7A _ BA, 0000002D
?_0771: mov     rax, qword [rbp-128H]                   ; 8A7F _ 48: 8B. 85, FFFFFED8
        mov     esi, edx                                ; 8A86 _ 89. D6
        mov     rdi, rax                                ; 8A88 _ 48: 89. C7
        call    itemp_has                               ; 8A8B _ E8, FFFF7920
        test    al, al                                  ; 8A90 _ 84. C0
        jz      ?_0772                                  ; 8A92 _ 74, 0A
        mov     eax, 13                                 ; 8A94 _ B8, 0000000D
        jmp     ?_0785                                  ; 8A99 _ E9, 0000023E

?_0772: mov     rax, qword [rbp-128H]                   ; 8A9E _ 48: 8B. 85, FFFFFED8
        mov     esi, 46                                 ; 8AA5 _ BE, 0000002E
        mov     rdi, rax                                ; 8AAA _ 48: 89. C7
        call    itemp_has                               ; 8AAD _ E8, FFFF78FE
        test    al, al                                  ; 8AB2 _ 84. C0
        jz      ?_0774                                  ; 8AB4 _ 74, 44
        mov     rax, qword [rbp-130H]                   ; 8AB6 _ 48: 8B. 85, FFFFFED0
        mov     edx, 360                                ; 8ABD _ BA, 00000168
        mov     esi, 5                                  ; 8AC2 _ BE, 00000005
        mov     rdi, rax                                ; 8AC7 _ 48: 89. C7
        call    has_prefix                              ; 8ACA _ E8, FFFF7DEE
        test    eax, eax                                ; 8ACF _ 85. C0
        jnz     ?_0773                                  ; 8AD1 _ 75, 1D
        mov     rax, qword [rbp-130H]                   ; 8AD3 _ 48: 8B. 85, FFFFFED0
        mov     edx, 361                                ; 8ADA _ BA, 00000169
        mov     esi, 5                                  ; 8ADF _ BE, 00000005
        mov     rdi, rax                                ; 8AE4 _ 48: 89. C7
        call    has_prefix                              ; 8AE7 _ E8, FFFF7DD1
        test    eax, eax                                ; 8AEC _ 85. C0
        jz      ?_0774                                  ; 8AEE _ 74, 0A
?_0773: mov     eax, 14                                 ; 8AF0 _ B8, 0000000E
        jmp     ?_0785                                  ; 8AF5 _ E9, 000001E2

?_0774: mov     rax, qword [rbp-130H]                   ; 8AFA _ 48: 8B. 85, FFFFFED0
        mov     edx, 370                                ; 8B01 _ BA, 00000172
        mov     esi, 7                                  ; 8B06 _ BE, 00000007
        mov     rdi, rax                                ; 8B0B _ 48: 89. C7
        call    has_prefix                              ; 8B0E _ E8, FFFF7DAA
        test    eax, eax                                ; 8B13 _ 85. C0
        jz      ?_0776                                  ; 8B15 _ 74, 51
        mov     rax, qword [rbp-128H]                   ; 8B17 _ 48: 8B. 85, FFFFFED8
        mov     esi, 31                                 ; 8B1E _ BE, 0000001F
        mov     rdi, rax                                ; 8B23 _ 48: 89. C7
        call    itemp_has                               ; 8B26 _ E8, FFFF7885
        xor     eax, 01H                                ; 8B2B _ 83. F0, 01
        test    al, al                                  ; 8B2E _ 84. C0
        jz      ?_0777                                  ; 8B30 _ 74, 58
        mov     rax, qword [rbp-128H]                   ; 8B32 _ 48: 8B. 85, FFFFFED8
        mov     esi, 51                                 ; 8B39 _ BE, 00000033
        mov     rdi, rax                                ; 8B3E _ 48: 89. C7
        call    itemp_has                               ; 8B41 _ E8, FFFF786A
        test    al, al                                  ; 8B46 _ 84. C0
        jnz     ?_0775                                  ; 8B48 _ 75, 14
        mov     rax, qword [rbp-130H]                   ; 8B4A _ 48: 8B. 85, FFFFFED0
        mov     eax, dword [rax+94H]                    ; 8B51 _ 8B. 80, 00000094
        and     eax, 04H                                ; 8B57 _ 83. E0, 04
        test    eax, eax                                ; 8B5A _ 85. C0
        jz      ?_0777                                  ; 8B5C _ 74, 2C
?_0775: mov     eax, 10                                 ; 8B5E _ B8, 0000000A
        jmp     ?_0785                                  ; 8B63 _ E9, 00000174

?_0776: mov     rax, qword [rbp-128H]                   ; 8B68 _ 48: 8B. 85, FFFFFED8
        mov     esi, 32                                 ; 8B6F _ BE, 00000020
        mov     rdi, rax                                ; 8B74 _ 48: 89. C7
        call    itemp_has                               ; 8B77 _ E8, FFFF7834
        test    al, al                                  ; 8B7C _ 84. C0
        jz      ?_0777                                  ; 8B7E _ 74, 0A
        mov     eax, 11                                 ; 8B80 _ B8, 0000000B
        jmp     ?_0785                                  ; 8B85 _ E9, 00000152

?_0777: mov     rax, qword [rbp-130H]                   ; 8B8A _ 48: 8B. 85, FFFFFED0
        mov     edx, 371                                ; 8B91 _ BA, 00000173
        mov     esi, 8                                  ; 8B96 _ BE, 00000008
        mov     rdi, rax                                ; 8B9B _ 48: 89. C7
        call    has_prefix                              ; 8B9E _ E8, FFFF7D1A
        test    eax, eax                                ; 8BA3 _ 85. C0
        jz      ?_0779                                  ; 8BA5 _ 74, 45
        mov     rax, qword [rbp-128H]                   ; 8BA7 _ 48: 8B. 85, FFFFFED8
        mov     esi, 35                                 ; 8BAE _ BE, 00000023
        mov     rdi, rax                                ; 8BB3 _ 48: 89. C7
        call    itemp_has                               ; 8BB6 _ E8, FFFF77F5
        xor     eax, 01H                                ; 8BBB _ 83. F0, 01
        test    al, al                                  ; 8BBE _ 84. C0
        jz      ?_0778                                  ; 8BC0 _ 74, 0A
        mov     eax, 8                                  ; 8BC2 _ B8, 00000008
        jmp     ?_0785                                  ; 8BC7 _ E9, 00000110

?_0778: mov     rax, qword [rbp-130H]                   ; 8BCC _ 48: 8B. 85, FFFFFED0
        mov     rax, qword [rax+0C0H]                   ; 8BD3 _ 48: 8B. 80, 000000C0
        and     eax, 01H                                ; 8BDA _ 83. E0, 01
        test    rax, rax                                ; 8BDD _ 48: 85. C0
        jnz     ?_0779                                  ; 8BE0 _ 75, 0A
        mov     eax, 9                                  ; 8BE2 _ B8, 00000009
        jmp     ?_0785                                  ; 8BE7 _ E9, 000000F0

?_0779: mov     rax, qword [rbp-128H]                   ; 8BEC _ 48: 8B. 85, FFFFFED8
        mov     esi, 48                                 ; 8BF3 _ BE, 00000030
        mov     rdi, rax                                ; 8BF8 _ 48: 89. C7
        call    itemp_has                               ; 8BFB _ E8, FFFF77B0
        xor     eax, 01H                                ; 8C00 _ 83. F0, 01
        test    al, al                                  ; 8C03 _ 84. C0
        jz      ?_0781                                  ; 8C05 _ 74, 44
        mov     rax, qword [rbp-130H]                   ; 8C07 _ 48: 8B. 85, FFFFFED0
        mov     edx, 362                                ; 8C0E _ BA, 0000016A
        mov     esi, 5                                  ; 8C13 _ BE, 00000005
        mov     rdi, rax                                ; 8C18 _ 48: 89. C7
        call    has_prefix                              ; 8C1B _ E8, FFFF7C9D
        test    eax, eax                                ; 8C20 _ 85. C0
        jnz     ?_0780                                  ; 8C22 _ 75, 1D
        mov     rax, qword [rbp-130H]                   ; 8C24 _ 48: 8B. 85, FFFFFED0
        mov     edx, 363                                ; 8C2B _ BA, 0000016B
        mov     esi, 5                                  ; 8C30 _ BE, 00000005
        mov     rdi, rax                                ; 8C35 _ 48: 89. C7
        call    has_prefix                              ; 8C38 _ E8, FFFF7C80
        test    eax, eax                                ; 8C3D _ 85. C0
        jz      ?_0781                                  ; 8C3F _ 74, 0A
?_0780: mov     eax, 16                                 ; 8C41 _ B8, 00000010
        jmp     ?_0785                                  ; 8C46 _ E9, 00000091

?_0781: mov     rax, qword [rbp-128H]                   ; 8C4B _ 48: 8B. 85, FFFFFED8
        mov     esi, 48                                 ; 8C52 _ BE, 00000030
        mov     rdi, rax                                ; 8C57 _ 48: 89. C7
        call    itemp_has                               ; 8C5A _ E8, FFFF7751
        test    al, al                                  ; 8C5F _ 84. C0
        jz      ?_0783                                  ; 8C61 _ 74, 41
        mov     rax, qword [rbp-130H]                   ; 8C63 _ 48: 8B. 85, FFFFFED0
        mov     edx, 356                                ; 8C6A _ BA, 00000164
        mov     esi, 5                                  ; 8C6F _ BE, 00000005
        mov     rdi, rax                                ; 8C74 _ 48: 89. C7
        call    has_prefix                              ; 8C77 _ E8, FFFF7C41
        test    eax, eax                                ; 8C7C _ 85. C0
        jnz     ?_0782                                  ; 8C7E _ 75, 1D
        mov     rax, qword [rbp-130H]                   ; 8C80 _ 48: 8B. 85, FFFFFED0
        mov     edx, 357                                ; 8C87 _ BA, 00000165
        mov     esi, 5                                  ; 8C8C _ BE, 00000005
        mov     rdi, rax                                ; 8C91 _ 48: 89. C7
        call    has_prefix                              ; 8C94 _ E8, FFFF7C24
        test    eax, eax                                ; 8C99 _ 85. C0
        jz      ?_0783                                  ; 8C9B _ 74, 07
?_0782: mov     eax, 17                                 ; 8C9D _ B8, 00000011
        jmp     ?_0785                                  ; 8CA2 _ EB, 38

?_0783: mov     rax, qword [rbp-128H]                   ; 8CA4 _ 48: 8B. 85, FFFFFED8
        mov     esi, 25                                 ; 8CAB _ BE, 00000019
        mov     rdi, rax                                ; 8CB0 _ 48: 89. C7
        call    itemp_has                               ; 8CB3 _ E8, FFFF76F8
        test    al, al                                  ; 8CB8 _ 84. C0
        jz      ?_0784                                  ; 8CBA _ 74, 1B
        mov     rdx, qword [rbp-128H]                   ; 8CBC _ 48: 8B. 95, FFFFFED8
        mov     rax, qword [rbp-130H]                   ; 8CC3 _ 48: 8B. 85, FFFFFED0
        mov     rsi, rdx                                ; 8CCA _ 48: 89. D6
        mov     rdi, rax                                ; 8CCD _ 48: 89. C7
        call    jmp_match                               ; 8CD0 _ E8, FFFF8F89
        jmp     ?_0785                                  ; 8CD5 _ EB, 05

?_0784: mov     eax, 30                                 ; 8CD7 _ B8, 0000001E
?_0785: mov     rdx, qword [rbp-8H]                     ; 8CDC _ 48: 8B. 55, F8
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        sub     rdx, qword [fs:abs 28H]                 ; 8CE0 _ 64 48: 2B. 14 25, 00000028
        jz      ?_0786                                  ; 8CE9 _ 74, 05
        call    __stack_chk_fail                        ; 8CEB _ E8, 00000000(PLT r)
?_0786: leave                                           ; 8CF0 _ C9
        ret                                             ; 8CF1 _ C3

memory_mod:; Local function
        push    rbp                                     ; 8CF2 _ 55
        mov     rbp, rsp                                ; 8CF3 _ 48: 89. E5
        push    rbx                                     ; 8CF6 _ 53
        sub     rsp, 40                                 ; 8CF7 _ 48: 83. EC, 28
        mov     dword [rbp-1CH], edi                    ; 8CFB _ 89. 7D, E4
        mov     qword [rbp-28H], rsi                    ; 8CFE _ 48: 89. 75, D8
        mov     qword [rbp-30H], rdx                    ; 8D02 _ 48: 89. 55, D0
        mov     byte [rbp-1DH], cl                      ; 8D06 _ 88. 4D, E3
        mov     byte [rbp-1EH], r8b                     ; 8D09 _ 44: 88. 45, E2
        mov     rax, qword [rbp-28H]                    ; 8D0D _ 48: 8B. 45, D8
        add     rax, 152                                ; 8D11 _ 48: 05, 00000098
        mov     qword [rbp-10H], rax                    ; 8D17 _ 48: 89. 45, F0
        mov     eax, dword [rbp-1CH]                    ; 8D1B _ 8B. 45, E4
        and     eax, 02H                                ; 8D1E _ 83. E0, 02
        test    eax, eax                                ; 8D21 _ 85. C0
        jz      ?_0787                                  ; 8D23 _ 74, 0A
        mov     eax, 2                                  ; 8D25 _ B8, 00000002
        jmp     ?_0794                                  ; 8D2A _ E9, 000000DD

?_0787: mov     rax, qword [rbp-28H]                    ; 8D2F _ 48: 8B. 45, D8
        mov     rdi, rax                                ; 8D33 _ 48: 89. C7
        call    get_disp8_shift                         ; 8D36 _ E8, FFFF77AB
        mov     edx, eax                                ; 8D3B _ 89. C2
        mov     rax, qword [rbp-10H]                    ; 8D3D _ 48: 8B. 45, F0
        mov     byte [rax+0FH], dl                      ; 8D41 _ 88. 50, 0F
        mov     rax, qword [rbp-10H]                    ; 8D44 _ 48: 8B. 45, F0
        movzx   eax, byte [rax+0FH]                     ; 8D48 _ 0F B6. 40, 0F
        movzx   eax, al                                 ; 8D4C _ 0F B6. C0
        mov     rdx, qword [rbp-30H]                    ; 8D4F _ 48: 8B. 55, D0
        mov     ecx, eax                                ; 8D53 _ 89. C1
        sar     rdx, cl                                 ; 8D55 _ 48: D3. FA
        mov     rax, rdx                                ; 8D58 _ 48: 89. D0
        mov     edx, eax                                ; 8D5B _ 89. C2
        mov     rax, qword [rbp-10H]                    ; 8D5D _ 48: 8B. 45, F0
        mov     byte [rax+0EH], dl                      ; 8D61 _ 88. 50, 0E
        cmp     byte [rbp-1DH], 0                       ; 8D64 _ 80. 7D, E3, 00
        jz      ?_0788                                  ; 8D68 _ 74, 44
        mov     rax, qword [rbp-10H]                    ; 8D6A _ 48: 8B. 45, F0
        movzx   eax, byte [rax+0EH]                     ; 8D6E _ 0F B6. 40, 0E
        movsx   rdx, al                                 ; 8D72 _ 48: 0F BE. D0
        mov     rax, qword [rbp-10H]                    ; 8D76 _ 48: 8B. 45, F0
        movzx   eax, byte [rax+0FH]                     ; 8D7A _ 0F B6. 40, 0F
        movzx   eax, al                                 ; 8D7E _ 0F B6. C0
        mov     rbx, rdx                                ; 8D81 _ 48: 89. D3
        mov     ecx, eax                                ; 8D84 _ 89. C1
        shl     rbx, cl                                 ; 8D86 _ 48: D3. E3
        mov     rax, qword [rbp-28H]                    ; 8D89 _ 48: 8B. 45, D8
        movzx   eax, byte [rax+7CH]                     ; 8D8D _ 0F B6. 40, 7C
        movzx   edx, al                                 ; 8D91 _ 0F B6. D0
        mov     rax, qword [rbp-30H]                    ; 8D94 _ 48: 8B. 45, D0
        mov     esi, edx                                ; 8D98 _ 89. D6
        mov     rdi, rax                                ; 8D9A _ 48: 89. C7
        call    sext                                    ; 8D9D _ E8, FFFF7278
        cmp     rbx, rax                                ; 8DA2 _ 48: 39. C3
        jnz     ?_0788                                  ; 8DA5 _ 75, 07
        mov     eax, 1                                  ; 8DA7 _ B8, 00000001
        jmp     ?_0789                                  ; 8DAC _ EB, 05

?_0788: mov     eax, 0                                  ; 8DAE _ B8, 00000000
?_0789: and     eax, 01H                                ; 8DB3 _ 83. E0, 01
        mov     rdx, qword [rbp-10H]                    ; 8DB6 _ 48: 8B. 55, F0
        mov     byte [rdx+10H], al                      ; 8DBA _ 88. 42, 10
        mov     eax, dword [rbp-1CH]                    ; 8DBD _ 8B. 45, E4
        and     eax, 01H                                ; 8DC0 _ 83. E0, 01
        test    eax, eax                                ; 8DC3 _ 85. C0
        jz      ?_0790                                  ; 8DC5 _ 74, 07
        mov     eax, 1                                  ; 8DC7 _ B8, 00000001
        jmp     ?_0794                                  ; 8DCC _ EB, 3E

?_0790: movzx   eax, byte [rbp-1DH]                     ; 8DCE _ 0F B6. 45, E3
        xor     eax, 01H                                ; 8DD2 _ 83. F0, 01
        test    al, al                                  ; 8DD5 _ 84. C0
        jz      ?_0791                                  ; 8DD7 _ 74, 07
        mov     eax, 2                                  ; 8DD9 _ B8, 00000002
        jmp     ?_0794                                  ; 8DDE _ EB, 2C

?_0791: cmp     qword [rbp-30H], 0                      ; 8DE0 _ 48: 83. 7D, D0, 00
        jnz     ?_0792                                  ; 8DE5 _ 75, 0D
        cmp     byte [rbp-1EH], 0                       ; 8DE7 _ 80. 7D, E2, 00
        jz      ?_0792                                  ; 8DEB _ 74, 07
        mov     eax, 0                                  ; 8DED _ B8, 00000000
        jmp     ?_0794                                  ; 8DF2 _ EB, 18

?_0792: mov     rax, qword [rbp-10H]                    ; 8DF4 _ 48: 8B. 45, F0
        movzx   eax, byte [rax+10H]                     ; 8DF8 _ 0F B6. 40, 10
        test    al, al                                  ; 8DFC _ 84. C0
        jz      ?_0793                                  ; 8DFE _ 74, 07
        mov     eax, 1                                  ; 8E00 _ B8, 00000001
        jmp     ?_0794                                  ; 8E05 _ EB, 05

?_0793: mov     eax, 2                                  ; 8E07 _ B8, 00000002
?_0794: mov     rbx, qword [rbp-8H]                     ; 8E0C _ 48: 8B. 5D, F8
        leave                                           ; 8E10 _ C9
        ret                                             ; 8E11 _ C3

process_ea:; Local function
        push    rbp                                     ; 8E12 _ 55
        mov     rbp, rsp                                ; 8E13 _ 48: 89. E5
        sub     rsp, 224                                ; 8E16 _ 48: 81. EC, 000000E0
        mov     qword [rbp-0B8H], rdi                   ; 8E1D _ 48: 89. BD, FFFFFF48
        mov     dword [rbp-0BCH], esi                   ; 8E24 _ 89. B5, FFFFFF44
        mov     qword [rbp-0C8H], rdx                   ; 8E2A _ 48: 89. 95, FFFFFF38
        mov     qword [rbp-0D0H], rcx                   ; 8E31 _ 48: 89. 8D, FFFFFF30
        mov     dword [rbp-0C0H], r8d                   ; 8E38 _ 44: 89. 85, FFFFFF40
        mov     qword [rbp-0D8H], r9                    ; 8E3F _ 4C: 89. 8D, FFFFFF28
        mov     rax, qword [rbp-0D0H]                   ; 8E46 _ 48: 8B. 85, FFFFFF30
        add     rax, 152                                ; 8E4D _ 48: 05, 00000098
        mov     qword [rbp-10H], rax                    ; 8E53 _ 48: 89. 45, F0
        mov     rax, qword [rbp-0D0H]                   ; 8E57 _ 48: 8B. 85, FFFFFF30
        movzx   eax, byte [rax+7AH]                     ; 8E5E _ 0F B6. 40, 7A
        cmp     al, 64                                  ; 8E62 _ 3C, 40
        sete    al                                      ; 8E64 _ 0F 94. C0
        mov     byte [rbp-0B0H], al                     ; 8E67 _ 88. 85, FFFFFF50
        mov     rax, qword [rbp-0D0H]                   ; 8E6D _ 48: 8B. 85, FFFFFF30
        movzx   eax, byte [rax+7CH]                     ; 8E74 _ 0F B6. 40, 7C
        movzx   eax, al                                 ; 8E78 _ 0F B6. C0
        mov     dword [rbp-70H], eax                    ; 8E7B _ 89. 45, 90
        mov     rax, qword [rbp-0B8H]                   ; 8E7E _ 48: 8B. 85, FFFFFF48
        mov     eax, dword [rax+34H]                    ; 8E85 _ 8B. 40, 34
        mov     dword [rbp-6CH], eax                    ; 8E88 _ 89. 45, 94
        mov     qword [rbp-38H], 0                      ; 8E8B _ 48: C7. 45, C8, 00000000
        mov     qword [rbp-38H], 0                      ; 8E93 _ 48: C7. 45, C8, 00000000
        mov     rax, qword [rbp-10H]                    ; 8E9B _ 48: 8B. 45, F0
        mov     edx, 20                                 ; 8E9F _ BA, 00000014
        mov     esi, 0                                  ; 8EA4 _ BE, 00000000
        mov     rdi, rax                                ; 8EA9 _ 48: 89. C7
        call    memset                                  ; 8EAC _ E8, 00000000(PLT r)
        mov     rax, qword [rbp-10H]                    ; 8EB1 _ 48: 8B. 45, F0
        mov     dword [rax], 1                          ; 8EB5 _ C7. 00, 00000001
        mov     rcx, qword [rbp-0C8H]                   ; 8EBB _ 48: 8B. 8D, FFFFFF38
        mov     eax, dword [rbp-0BCH]                   ; 8EC2 _ 8B. 85, FFFFFF44
        mov     edx, 278724                             ; 8EC8 _ BA, 000440C4
        mov     rsi, rcx                                ; 8ECD _ 48: 89. CE
        mov     edi, eax                                ; 8ED0 _ 89. C7
        call    rexflags                                ; 8ED2 _ E8, FFFFE8B6
        mov     rdx, qword [rbp-10H]                    ; 8ED7 _ 48: 8B. 55, F0
        mov     edx, dword [rdx+4H]                     ; 8EDB _ 8B. 52, 04
        or      edx, eax                                ; 8EDE _ 09. C2
        mov     rax, qword [rbp-10H]                    ; 8EE0 _ 48: 8B. 45, F0
        mov     dword [rax+4H], edx                     ; 8EE4 _ 89. 50, 04
        mov     rax, qword [rbp-0B8H]                   ; 8EE7 _ 48: 8B. 85, FFFFFF48
        mov     rax, qword [rax]                        ; 8EEE _ 48: 8B. 00
        mov     rsi, rax                                ; 8EF1 _ 48: 89. C6
        mov     edi, 1                                  ; 8EF4 _ BF, 00000001
        call    is_class                                ; 8EF9 _ E8, FFFF725E
        test    al, al                                  ; 8EFE _ 84. C0
        je      ?_0796                                  ; 8F00 _ 0F 84, 000000D9
        mov     rax, qword [rbp-0B8H]                   ; 8F06 _ 48: 8B. 85, FFFFFF48
        mov     eax, dword [rax+10H]                    ; 8F0D _ 8B. 40, 10
        mov     edi, eax                                ; 8F10 _ 89. C7
        call    is_register                             ; 8F12 _ E8, FFFF7264
        xor     eax, 01H                                ; 8F17 _ 83. F0, 01
        test    al, al                                  ; 8F1A _ 84. C0
        jne     ?_0897                                  ; 8F1C _ 0F 85, 0000121C
        mov     rax, qword [rbp-0B8H]                   ; 8F22 _ 48: 8B. 85, FFFFFF48
        mov     eax, dword [rax+10H]                    ; 8F29 _ 8B. 40, 10
        mov     esi, eax                                ; 8F2C _ 89. C6
        mov     edi, 5                                  ; 8F2E _ BF, 00000005
        call    is_reg_class                            ; 8F33 _ E8, FFFF726A
        xor     eax, 01H                                ; 8F38 _ 83. F0, 01
        test    al, al                                  ; 8F3B _ 84. C0
        jne     ?_0898                                  ; 8F3D _ 0F 85, 000011FE
        mov     rax, qword [rbp-0B8H]                   ; 8F43 _ 48: 8B. 85, FFFFFF48
        movzx   eax, word [rax+40H]                     ; 8F4A _ 0F B7. 40, 40
        movzx   eax, ax                                 ; 8F4E _ 0F B7. C0
        and     eax, 20H                                ; 8F51 _ 83. E0, 20
        test    rax, rax                                ; 8F54 _ 48: 85. C0
        jz      ?_0795                                  ; 8F57 _ 74, 10
        lea     rax, [rel ?_1116]                       ; 8F59 _ 48: 8D. 05, 00000000(rel)
        mov     qword [rbp-38H], rax                    ; 8F60 _ 48: 89. 45, C8
        jmp     ?_0920                                  ; 8F64 _ E9, 00001218

?_0795: mov     rax, qword [rbp-0B8H]                   ; 8F69 _ 48: 8B. 85, FFFFFF48
        mov     esi, 69825                              ; 8F70 _ BE, 000110C1
        mov     rdi, rax                                ; 8F75 _ 48: 89. C7
        call    op_rexflags                             ; 8F78 _ E8, FFFFE784
        mov     rdx, qword [rbp-10H]                    ; 8F7D _ 48: 8B. 55, F0
        mov     edx, dword [rdx+4H]                     ; 8F81 _ 8B. 52, 04
        or      edx, eax                                ; 8F84 _ 09. C2
        mov     rax, qword [rbp-10H]                    ; 8F86 _ 48: 8B. 45, F0
        mov     dword [rax+4H], edx                     ; 8F8A _ 89. 50, 04
        mov     rax, qword [rbp-10H]                    ; 8F8D _ 48: 8B. 45, F0
        mov     byte [rax+8H], 0                        ; 8F91 _ C6. 40, 08, 00
        mov     rax, qword [rbp-10H]                    ; 8F95 _ 48: 8B. 45, F0
        mov     byte [rax+9H], 0                        ; 8F99 _ C6. 40, 09, 00
        mov     eax, dword [rbp-0BCH]                   ; 8F9D _ 8B. 85, FFFFFF44
        shl     eax, 3                                  ; 8FA3 _ C1. E0, 03
        and     eax, 38H                                ; 8FA6 _ 83. E0, 38
        or      eax, 0FFFFFFC0H                         ; 8FA9 _ 83. C8, C0
        mov     ecx, eax                                ; 8FAC _ 89. C1
        mov     rax, qword [rbp-0B8H]                   ; 8FAE _ 48: 8B. 85, FFFFFF48
        mov     eax, dword [rax+10H]                    ; 8FB5 _ 8B. 40, 10
        cdqe                                            ; 8FB8 _ 48: 98
        lea     rdx, [rax*4]                            ; 8FBA _ 48: 8D. 14 85, 00000000
        lea     rax, [rel nasm_regvals]                 ; 8FC2 _ 48: 8D. 05, 00000000(rel)
        mov     eax, dword [rdx+rax]                    ; 8FC9 _ 8B. 04 02
        and     eax, 07H                                ; 8FCC _ 83. E0, 07
        or      eax, ecx                                ; 8FCF _ 09. C8
        mov     edx, eax                                ; 8FD1 _ 89. C2
        mov     rax, qword [rbp-10H]                    ; 8FD3 _ 48: 8B. 45, F0
        mov     byte [rax+0BH], dl                      ; 8FD7 _ 88. 50, 0B
        jmp     ?_0896                                  ; 8FDA _ E9, 00001129

?_0796: mov     rax, qword [rbp-0B8H]                   ; 8FDF _ 48: 8B. 85, FFFFFF48
        movzx   eax, word [rax+40H]                     ; 8FE6 _ 0F B7. 40, 40
        movzx   eax, ax                                 ; 8FEA _ 0F B7. C0
        and     eax, 0C0H                               ; 8FED _ 25, 000000C0
        test    rax, rax                                ; 8FF2 _ 48: 85. C0
        jz      ?_0797                                  ; 8FF5 _ 74, 10
        lea     rax, [rel ?_1117]                       ; 8FF7 _ 48: 8D. 05, 00000000(rel)
        mov     qword [rbp-38H], rax                    ; 8FFE _ 48: 89. 45, C8
        jmp     ?_0920                                  ; 9002 _ E9, 0000117A

?_0797: mov     rax, qword [rbp-0B8H]                   ; 9007 _ 48: 8B. 85, FFFFFF48
        mov     eax, dword [rax+10H]                    ; 900E _ 8B. 40, 10
        cmp     eax, -1                                 ; 9011 _ 83. F8, FF
        jne     ?_0814                                  ; 9014 _ 0F 85, 0000029E
        mov     rax, qword [rbp-0B8H]                   ; 901A _ 48: 8B. 85, FFFFFF48
        mov     eax, dword [rax+14H]                    ; 9021 _ 8B. 40, 14
        cmp     eax, -1                                 ; 9024 _ 83. F8, FF
        jz      ?_0798                                  ; 9027 _ 74, 12
        mov     rax, qword [rbp-0B8H]                   ; 9029 _ 48: 8B. 85, FFFFFF48
        mov     eax, dword [rax+18H]                    ; 9030 _ 8B. 40, 18
        test    eax, eax                                ; 9033 _ 85. C0
        jne     ?_0814                                  ; 9035 _ 0F 85, 0000027D
?_0798: cmp     byte [rbp-0B0H], 0                      ; 903B _ 80. BD, FFFFFF50, 00
        je      ?_0802                                  ; 9042 _ 0F 84, 00000108
        mov     rax, qword [rbp-0B8H]                   ; 9048 _ 48: 8B. 85, FFFFFF48
        mov     rax, qword [rax]                        ; 904F _ 48: 8B. 00
        mov     rsi, rax                                ; 9052 _ 48: 89. C6
        mov     edi, 2                                  ; 9055 _ BF, 00000002
        call    is_class                                ; 905A _ E8, FFFF70FD
        test    al, al                                  ; 905F _ 84. C0
        jz      ?_0800                                  ; 9061 _ 74, 49
        mov     rax, qword [rbp-0B8H]                   ; 9063 _ 48: 8B. 85, FFFFFF48
        mov     eax, dword [rax+34H]                    ; 906A _ 8B. 40, 34
        and     eax, 10H                                ; 906D _ 83. E0, 10
        test    eax, eax                                ; 9070 _ 85. C0
        jnz     ?_0800                                  ; 9072 _ 75, 38
        mov     rax, qword [rbp-0B8H]                   ; 9074 _ 48: 8B. 85, FFFFFF48
        mov     eax, dword [rax+34H]                    ; 907B _ 8B. 40, 34
        and     eax, 08H                                ; 907E _ 83. E0, 08
        test    eax, eax                                ; 9081 _ 85. C0
        jnz     ?_0799                                  ; 9083 _ 75, 0A
        mov     eax, dword [rel globl+4H]               ; 9085 _ 8B. 05, 00000000(rel)
        test    eax, eax                                ; 908B _ 85. C0
        jz      ?_0800                                  ; 908D _ 74, 1D
?_0799: mov     rax, qword [rbp-0B8H]                   ; 908F _ 48: 8B. 85, FFFFFF48
        mov     rax, qword [rax]                        ; 9096 _ 48: 8B. 00
        or      rax, 8000CH                             ; 9099 _ 48: 0D, 0008000C
        mov     rdx, rax                                ; 909F _ 48: 89. C2
        mov     rax, qword [rbp-0B8H]                   ; 90A2 _ 48: 8B. 85, FFFFFF48
        mov     qword [rax], rdx                        ; 90A9 _ 48: 89. 10
?_0800: mov     rax, qword [rbp-0B8H]                   ; 90AC _ 48: 8B. 85, FFFFFF48
        mov     rax, qword [rax]                        ; 90B3 _ 48: 8B. 00
        and     eax, 8000CH                             ; 90B6 _ 25, 0008000C
        cmp     rax, 524300                             ; 90BB _ 48: 3D, 0008000C
        jne     ?_0802                                  ; 90C1 _ 0F 85, 00000089
        call    pass_first                              ; 90C7 _ E8, FFFF71E8
        xor     eax, 01H                                ; 90CC _ 83. F0, 01
        test    al, al                                  ; 90CF _ 84. C0
        jz      ?_0802                                  ; 90D1 _ 74, 7D
        mov     rax, qword [rbp-0B8H]                   ; 90D3 _ 48: 8B. 85, FFFFFF48
        mov     rdi, rax                                ; 90DA _ 48: 89. C7
        call    absolute_op                             ; 90DD _ E8, FFFF7795
        test    al, al                                  ; 90E2 _ 84. C0
        jz      ?_0802                                  ; 90E4 _ 74, 6A
        mov     dword [rbp-68H], 196608                 ; 90E6 _ C7. 45, 98, 00030000
        mov     eax, dword [rbp-68H]                    ; 90ED _ 8B. 45, 98
        mov     edi, eax                                ; 90F0 _ 89. C7
        call    warn_active                             ; 90F2 _ E8, FFFF715C
        movzx   eax, al                                 ; 90F7 _ 0F B6. C0
        test    rax, rax                                ; 90FA _ 48: 85. C0
        jz      ?_0801                                  ; 90FD _ 74, 19
        lea     rdx, [rel ?_1118]                       ; 90FF _ 48: 8D. 15, 00000000(rel)
        mov     eax, dword [rbp-68H]                    ; 9106 _ 8B. 45, 98
        mov     rsi, rdx                                ; 9109 _ 48: 89. D6
        mov     edi, eax                                ; 910C _ 89. C7
        mov     eax, 0                                  ; 910E _ B8, 00000000
        call    nasm_warn_                              ; 9113 _ E8, 00000000(PLT r)
?_0801: mov     rax, qword [rbp-0B8H]                   ; 9118 _ 48: 8B. 85, FFFFFF48
        mov     rax, qword [rax]                        ; 911F _ 48: 8B. 00
        and     rax, 0FFFFFFFFFFF7FFF3H                 ; 9122 _ 48: 25, FFF7FFF3
        mov     rdx, rax                                ; 9128 _ 48: 89. C2
        mov     rax, qword [rbp-0B8H]                   ; 912B _ 48: 8B. 85, FFFFFF48
        mov     qword [rax], rdx                        ; 9132 _ 48: 89. 10
        mov     rax, qword [rbp-0B8H]                   ; 9135 _ 48: 8B. 85, FFFFFF48
        mov     rax, qword [rax]                        ; 913C _ 48: 8B. 00
        or      rax, 0CH                                ; 913F _ 48: 83. C8, 0C
        mov     rdx, rax                                ; 9143 _ 48: 89. C2
        mov     rax, qword [rbp-0B8H]                   ; 9146 _ 48: 8B. 85, FFFFFF48
        mov     qword [rax], rdx                        ; 914D _ 48: 89. 10
?_0802: cmp     byte [rbp-0B0H], 0                      ; 9150 _ 80. BD, FFFFFF50, 00
        jz      ?_0803                                  ; 9157 _ 74, 31
        mov     rax, qword [rbp-0B8H]                   ; 9159 _ 48: 8B. 85, FFFFFF48
        mov     rax, qword [rax]                        ; 9160 _ 48: 8B. 00
        not     rax                                     ; 9163 _ 48: F7. D0
        and     eax, 8000CH                             ; 9166 _ 25, 0008000C
        test    rax, rax                                ; 916B _ 48: 85. C0
        jnz     ?_0803                                  ; 916E _ 75, 1A
        mov     eax, dword [rbp-6CH]                    ; 9170 _ 8B. 45, 94
        and     eax, 40H                                ; 9173 _ 83. E0, 40
        test    eax, eax                                ; 9176 _ 85. C0
        jz      ?_0803                                  ; 9178 _ 74, 10
        lea     rax, [rel ?_1119]                       ; 917A _ 48: 8D. 05, 00000000(rel)
        mov     qword [rbp-38H], rax                    ; 9181 _ 48: 89. 45, C8
        jmp     ?_0920                                  ; 9185 _ E9, 00000FF7

?_0803: mov     eax, dword [rbp-6CH]                    ; 918A _ 8B. 45, 94
        and     eax, 01H                                ; 918D _ 83. E0, 01
        test    eax, eax                                ; 9190 _ 85. C0
        jnz     ?_0806                                  ; 9192 _ 75, 2E
        mov     eax, dword [rbp-6CH]                    ; 9194 _ 8B. 45, 94
        and     eax, 02H                                ; 9197 _ 83. E0, 02
        test    eax, eax                                ; 919A _ 85. C0
        jz      ?_0807                                  ; 919C _ 74, 56
        mov     rax, qword [rbp-0B8H]                   ; 919E _ 48: 8B. 85, FFFFFF48
        movzx   eax, byte [rax+43H]                     ; 91A5 _ 0F B6. 40, 43
        movzx   eax, al                                 ; 91A9 _ 0F B6. C0
        cmp     dword [rbp-70H], 16                     ; 91AC _ 83. 7D, 90, 10
        jz      ?_0804                                  ; 91B0 _ 74, 07
        mov     edx, 32                                 ; 91B2 _ BA, 00000020
        jmp     ?_0805                                  ; 91B7 _ EB, 05

?_0804: mov     edx, 16                                 ; 91B9 _ BA, 00000010
?_0805: cmp     edx, eax                                ; 91BE _ 39. C2
        jz      ?_0807                                  ; 91C0 _ 74, 32
?_0806: mov     dword [rbp-64H], 262144                 ; 91C2 _ C7. 45, 9C, 00040000
        mov     eax, dword [rbp-64H]                    ; 91C9 _ 8B. 45, 9C
        mov     edi, eax                                ; 91CC _ 89. C7
        call    warn_active                             ; 91CE _ E8, FFFF7080
        movzx   eax, al                                 ; 91D3 _ 0F B6. C0
        test    rax, rax                                ; 91D6 _ 48: 85. C0
        jz      ?_0807                                  ; 91D9 _ 74, 19
        lea     rdx, [rel ?_1120]                       ; 91DB _ 48: 8D. 15, 00000000(rel)
        mov     eax, dword [rbp-64H]                    ; 91E2 _ 8B. 45, 9C
        mov     rsi, rdx                                ; 91E5 _ 48: 89. D6
        mov     edi, eax                                ; 91E8 _ 89. C7
        mov     eax, 0                                  ; 91EA _ B8, 00000000
        call    nasm_warn_                              ; 91EF _ E8, 00000000(PLT r)
?_0807: mov     eax, dword [rbp-6CH]                    ; 91F4 _ 8B. 45, 94
        and     eax, 40H                                ; 91F7 _ 83. E0, 40
        test    eax, eax                                ; 91FA _ 85. C0
        jnz     ?_0808                                  ; 91FC _ 75, 20
        cmp     byte [rbp-0B0H], 0                      ; 91FE _ 80. BD, FFFFFF50, 00
        jz      ?_0809                                  ; 9205 _ 74, 54
        mov     rax, qword [rbp-0B8H]                   ; 9207 _ 48: 8B. 85, FFFFFF48
        mov     rax, qword [rax]                        ; 920E _ 48: 8B. 00
        not     rax                                     ; 9211 _ 48: F7. D0
        and     eax, 8000CH                             ; 9214 _ 25, 0008000C
        test    rax, rax                                ; 9219 _ 48: 85. C0
        jz      ?_0809                                  ; 921C _ 74, 3D
?_0808: mov     rax, qword [rbp-10H]                    ; 921E _ 48: 8B. 45, F0
        mov     byte [rax+8H], 1                        ; 9222 _ C6. 40, 08, 01
        mov     rax, qword [rbp-10H]                    ; 9226 _ 48: 8B. 45, F0
        mov     byte [rax+0CH], 37                      ; 922A _ C6. 40, 0C, 25
        mov     rax, qword [rbp-10H]                    ; 922E _ 48: 8B. 45, F0
        mov     byte [rax+9H], 4                        ; 9232 _ C6. 40, 09, 04
        mov     eax, dword [rbp-0BCH]                   ; 9236 _ 8B. 85, FFFFFF44
        shl     eax, 3                                  ; 923C _ C1. E0, 03
        and     eax, 38H                                ; 923F _ 83. E0, 38
        or      eax, 04H                                ; 9242 _ 83. C8, 04
        mov     edx, eax                                ; 9245 _ 89. C2
        mov     rax, qword [rbp-10H]                    ; 9247 _ 48: 8B. 45, F0
        mov     byte [rax+0BH], dl                      ; 924B _ 88. 50, 0B
        mov     rax, qword [rbp-10H]                    ; 924E _ 48: 8B. 45, F0
        mov     byte [rax+0DH], 0                       ; 9252 _ C6. 40, 0D, 00
        jmp     ?_0896                                  ; 9256 _ E9, 00000EAD

?_0809: mov     rax, qword [rbp-10H]                    ; 925B _ 48: 8B. 45, F0
        mov     byte [rax+8H], 0                        ; 925F _ C6. 40, 08, 00
        cmp     dword [rbp-70H], 16                     ; 9263 _ 83. 7D, 90, 10
        jz      ?_0810                                  ; 9267 _ 74, 07
        mov     edx, 4                                  ; 9269 _ BA, 00000004
        jmp     ?_0811                                  ; 926E _ EB, 05

?_0810: mov     edx, 2                                  ; 9270 _ BA, 00000002
?_0811: mov     rax, qword [rbp-10H]                    ; 9275 _ 48: 8B. 45, F0
        mov     byte [rax+9H], dl                       ; 9279 _ 88. 50, 09
        mov     eax, dword [rbp-0BCH]                   ; 927C _ 8B. 85, FFFFFF44
        shl     eax, 3                                  ; 9282 _ C1. E0, 03
        and     eax, 38H                                ; 9285 _ 83. E0, 38
        cmp     dword [rbp-70H], 16                     ; 9288 _ 83. 7D, 90, 10
        jz      ?_0812                                  ; 928C _ 74, 07
        mov     edx, 5                                  ; 928E _ BA, 00000005
        jmp     ?_0813                                  ; 9293 _ EB, 05

?_0812: mov     edx, 6                                  ; 9295 _ BA, 00000006
?_0813: or      eax, edx                                ; 929A _ 09. D0
        mov     edx, eax                                ; 929C _ 89. C2
        mov     rax, qword [rbp-10H]                    ; 929E _ 48: 8B. 45, F0
        mov     byte [rax+0BH], dl                      ; 92A2 _ 88. 50, 0B
        mov     rax, qword [rbp-10H]                    ; 92A5 _ 48: 8B. 45, F0
        movzx   edx, byte [rbp-0B0H]                    ; 92A9 _ 0F B6. 95, FFFFFF50
        mov     byte [rax+0DH], dl                      ; 92B0 _ 88. 50, 0D
        jmp     ?_0896                                  ; 92B3 _ E9, 00000E50

?_0814: mov     rax, qword [rbp-0B8H]                   ; 92B8 _ 48: 8B. 85, FFFFFF48
        mov     eax, dword [rax+14H]                    ; 92BF _ 8B. 40, 14
        mov     dword [rbp-0ACH], eax                   ; 92C2 _ 89. 85, FFFFFF54
        mov     rax, qword [rbp-0B8H]                   ; 92C8 _ 48: 8B. 85, FFFFFF48
        mov     eax, dword [rax+10H]                    ; 92CF _ 8B. 40, 10
        mov     dword [rbp-0A8H], eax                   ; 92D2 _ 89. 85, FFFFFF58
        mov     rax, qword [rbp-0B8H]                   ; 92D8 _ 48: 8B. 85, FFFFFF48
        mov     eax, dword [rax+18H]                    ; 92DF _ 8B. 40, 18
        mov     dword [rbp-0A4H], eax                   ; 92E2 _ 89. 85, FFFFFF5C
        mov     rax, qword [rbp-0B8H]                   ; 92E8 _ 48: 8B. 85, FFFFFF48
        mov     eax, dword [rax+38H]                    ; 92EF _ 8B. 40, 38
        and     eax, 04H                                ; 92F2 _ 83. E0, 04
        test    eax, eax                                ; 92F5 _ 85. C0
        jnz     ?_0815                                  ; 92F7 _ 75, 16
        mov     rax, qword [rbp-0B8H]                   ; 92F9 _ 48: 8B. 85, FFFFFF48
        mov     eax, dword [rax+24H]                    ; 9300 _ 8B. 40, 24
        cmp     eax, -1                                 ; 9303 _ 83. F8, FF
        jnz     ?_0815                                  ; 9306 _ 75, 07
        mov     eax, 1                                  ; 9308 _ B8, 00000001
        jmp     ?_0816                                  ; 930D _ EB, 05

?_0815: mov     eax, 0                                  ; 930F _ B8, 00000000
?_0816: mov     byte [rbp-0AFH], al                     ; 9314 _ 88. 85, FFFFFF51
        and     byte [rbp-0AFH], 01H                    ; 931A _ 80. A5, FFFFFF51, 01
        mov     rax, qword [rbp-0B8H]                   ; 9321 _ 48: 8B. 85, FFFFFF48
        mov     eax, dword [rax+1CH]                    ; 9328 _ 8B. 40, 1C
        mov     dword [rbp-60H], eax                    ; 932B _ 89. 45, A0
        mov     rax, qword [rbp-0B8H]                   ; 932E _ 48: 8B. 85, FFFFFF48
        mov     eax, dword [rax+20H]                    ; 9335 _ 8B. 40, 20
        mov     dword [rbp-5CH], eax                    ; 9338 _ 89. 45, A4
        cmp     dword [rbp-0A4H], 0                     ; 933B _ 83. BD, FFFFFF5C, 00
        jnz     ?_0817                                  ; 9342 _ 75, 0A
        mov     dword [rbp-0ACH], -1                    ; 9344 _ C7. 85, FFFFFF54, FFFFFFFF
?_0817: mov     eax, dword [rbp-0ACH]                   ; 934E _ 8B. 85, FFFFFF54
        mov     edi, eax                                ; 9354 _ 89. C7
        call    is_register                             ; 9356 _ E8, FFFF6E20
        test    al, al                                  ; 935B _ 84. C0
        jz      ?_0818                                  ; 935D _ 74, 41
        mov     eax, dword [rbp-0ACH]                   ; 935F _ 8B. 85, FFFFFF54
        cdqe                                            ; 9365 _ 48: 98
        lea     rdx, [rax*4]                            ; 9367 _ 48: 8D. 14 85, 00000000
        lea     rax, [rel nasm_regvals]                 ; 936F _ 48: 8D. 05, 00000000(rel)
        mov     eax, dword [rdx+rax]                    ; 9376 _ 8B. 04 02
        mov     dword [rbp-0A0H], eax                   ; 9379 _ 89. 85, FFFFFF60
        mov     eax, dword [rbp-0ACH]                   ; 937F _ 8B. 85, FFFFFF54
        cdqe                                            ; 9385 _ 48: 98
        lea     rdx, [rax*8]                            ; 9387 _ 48: 8D. 14 C5, 00000000
        lea     rax, [rel nasm_reg_flags]               ; 938F _ 48: 8D. 05, 00000000(rel)
        mov     rax, qword [rdx+rax]                    ; 9396 _ 48: 8B. 04 02
        mov     qword [rbp-30H], rax                    ; 939A _ 48: 89. 45, D0
        jmp     ?_0819                                  ; 939E _ EB, 12

?_0818: mov     dword [rbp-0A0H], -1                    ; 93A0 _ C7. 85, FFFFFF60, FFFFFFFF
        mov     qword [rbp-30H], 0                      ; 93AA _ 48: C7. 45, D0, 00000000
?_0819: mov     eax, dword [rbp-0A8H]                   ; 93B2 _ 8B. 85, FFFFFF58
        mov     edi, eax                                ; 93B8 _ 89. C7
        call    is_register                             ; 93BA _ E8, FFFF6DBC
        test    al, al                                  ; 93BF _ 84. C0
        jz      ?_0820                                  ; 93C1 _ 74, 41
        mov     eax, dword [rbp-0A8H]                   ; 93C3 _ 8B. 85, FFFFFF58
        cdqe                                            ; 93C9 _ 48: 98
        lea     rdx, [rax*4]                            ; 93CB _ 48: 8D. 14 85, 00000000
        lea     rax, [rel nasm_regvals]                 ; 93D3 _ 48: 8D. 05, 00000000(rel)
        mov     eax, dword [rdx+rax]                    ; 93DA _ 8B. 04 02
        mov     dword [rbp-9CH], eax                    ; 93DD _ 89. 85, FFFFFF64
        mov     eax, dword [rbp-0A8H]                   ; 93E3 _ 8B. 85, FFFFFF58
        cdqe                                            ; 93E9 _ 48: 98
        lea     rdx, [rax*8]                            ; 93EB _ 48: 8D. 14 C5, 00000000
        lea     rax, [rel nasm_reg_flags]               ; 93F3 _ 48: 8D. 05, 00000000(rel)
        mov     rax, qword [rdx+rax]                    ; 93FA _ 48: 8B. 04 02
        mov     qword [rbp-28H], rax                    ; 93FE _ 48: 89. 45, D8
        jmp     ?_0821                                  ; 9402 _ EB, 12

?_0820: mov     dword [rbp-9CH], -1                     ; 9404 _ C7. 85, FFFFFF64, FFFFFFFF
        mov     qword [rbp-28H], 0                      ; 940E _ 48: C7. 45, D8, 00000000
?_0821: mov     rax, qword [rbp-30H]                    ; 9416 _ 48: 8B. 45, D0
        or      rax, qword [rbp-28H]                    ; 941A _ 48: 0B. 45, D8
        and     eax, 7000H                              ; 941E _ 25, 00007000
        test    rax, rax                                ; 9423 _ 48: 85. C0
        je      ?_0842                                  ; 9426 _ 0F 84, 0000033C
        mov     rax, qword 0C00000000H                  ; 942C _ 48: B8, 0000000C00000000
        mov     qword [rbp-20H], rax                    ; 9436 _ 48: 89. 45, E0
        mov     rax, qword [rbp-0B8H]                   ; 943A _ 48: 8B. 85, FFFFFF48
        mov     rax, qword [rax+28H]                    ; 9441 _ 48: 8B. 40, 28
        mov     dword [rbp-44H], eax                    ; 9445 _ 89. 45, BC
        cmp     dword [rbp-0A0H], -1                    ; 9448 _ 83. BD, FFFFFF60, FF
        jz      ?_0822                                  ; 944F _ 74, 0E
        mov     rax, qword [rbp-28H]                    ; 9451 _ 48: 8B. 45, D8
        and     eax, 7000H                              ; 9455 _ 25, 00007000
        test    rax, rax                                ; 945A _ 48: 85. C0
        jz      ?_0825                                  ; 945D _ 74, 58
?_0822: cmp     dword [rbp-0A4H], 0                     ; 945F _ 83. BD, FFFFFF5C, 00
        jnz     ?_0823                                  ; 9466 _ 75, 0C
        mov     dword [rbp-0A4H], 1                     ; 9468 _ C7. 85, FFFFFF5C, 00000001
        jmp     ?_0824                                  ; 9472 _ EB, 0D

?_0823: cmp     dword [rbp-0A4H], 1                     ; 9474 _ 83. BD, FFFFFF5C, 01
        jne     ?_0899                                  ; 947B _ 0F 85, 00000CC3
?_0824: mov     eax, dword [rbp-9CH]                    ; 9481 _ 8B. 85, FFFFFF64
        mov     dword [rbp-48H], eax                    ; 9487 _ 89. 45, B8
        mov     eax, dword [rbp-0A0H]                   ; 948A _ 8B. 85, FFFFFF60
        mov     dword [rbp-9CH], eax                    ; 9490 _ 89. 85, FFFFFF64
        mov     eax, dword [rbp-48H]                    ; 9496 _ 8B. 45, B8
        mov     dword [rbp-0A0H], eax                   ; 9499 _ 89. 85, FFFFFF60
        mov     rax, qword [rbp-28H]                    ; 949F _ 48: 8B. 45, D8
        mov     qword [rbp-8H], rax                     ; 94A3 _ 48: 89. 45, F8
        mov     rax, qword [rbp-30H]                    ; 94A7 _ 48: 8B. 45, D0
        mov     qword [rbp-28H], rax                    ; 94AB _ 48: 89. 45, D8
        mov     rax, qword [rbp-8H]                     ; 94AF _ 48: 8B. 45, F8
        mov     qword [rbp-30H], rax                    ; 94B3 _ 48: 89. 45, D0
?_0825: cmp     dword [rbp-9CH], -1                     ; 94B7 _ 83. BD, FFFFFF64, FF
        jz      ?_0827                                  ; 94BE _ 74, 59
        mov     rax, qword [rbp-28H]                    ; 94C0 _ 48: 8B. 45, D8
        not     rax                                     ; 94C4 _ 48: F7. D0
        and     eax, 105H                               ; 94C7 _ 25, 00000105
        test    rax, rax                                ; 94CC _ 48: 85. C0
        jne     ?_0900                                  ; 94CF _ 0F 85, 00000C72
        mov     rax, qword [rbp-28H]                    ; 94D5 _ 48: 8B. 45, D8
        not     rax                                     ; 94D9 _ 48: F7. D0
        mov     rdx, rax                                ; 94DC _ 48: 89. C2
        mov     rax, qword 880000105H                   ; 94DF _ 48: B8, 0000000880000105
        and     rax, rdx                                ; 94E9 _ 48: 21. D0
        test    rax, rax                                ; 94EC _ 48: 85. C0
        jz      ?_0826                                  ; 94EF _ 74, 20
        mov     rax, qword [rbp-28H]                    ; 94F1 _ 48: 8B. 45, D8
        not     rax                                     ; 94F5 _ 48: F7. D0
        mov     rdx, rax                                ; 94F8 _ 48: 89. C2
        mov     rax, qword 480000105H                   ; 94FB _ 48: B8, 0000000480000105
        and     rax, rdx                                ; 9505 _ 48: 21. D0
        test    rax, rax                                ; 9508 _ 48: 85. C0
        jne     ?_0901                                  ; 950B _ 0F 85, 00000C39
?_0826: mov     rax, qword [rbp-28H]                    ; 9511 _ 48: 8B. 45, D8
        and     qword [rbp-20H], rax                    ; 9515 _ 48: 21. 45, E0
?_0827: mov     rax, qword [rbp-0B8H]                   ; 9519 _ 48: 8B. 85, FFFFFF48
        movzx   eax, byte [rax+43H]                     ; 9520 _ 0F B6. 40, 43
        cmp     al, 16                                  ; 9524 _ 3C, 10
        je      ?_0902                                  ; 9526 _ 0F 84, 00000C21
        mov     rax, qword [rbp-0B8H]                   ; 952C _ 48: 8B. 85, FFFFFF48
        movzx   eax, byte [rax+43H]                     ; 9533 _ 0F B6. 40, 43
        cmp     al, 64                                  ; 9537 _ 3C, 40
        je      ?_0902                                  ; 9539 _ 0F 84, 00000C0E
        cmp     dword [rbp-70H], 16                     ; 953F _ 83. 7D, 90, 10
        je      ?_0903                                  ; 9543 _ 0F 84, 00000C07
        cmp     dword [rbp-70H], 32                     ; 9549 _ 83. 7D, 90, 20
        jnz     ?_0828                                  ; 954D _ 75, 17
        mov     rax, qword 400000000H                   ; 954F _ 48: B8, 0000000400000000
        and     rax, qword [rbp-20H]                    ; 9559 _ 48: 23. 45, E0
        test    rax, rax                                ; 955D _ 48: 85. C0
        je      ?_0903                                  ; 9560 _ 0F 84, 00000BEA
?_0828: cmp     dword [rbp-70H], 64                     ; 9566 _ 83. 7D, 90, 40
        jnz     ?_0829                                  ; 956A _ 75, 17
        mov     rax, qword 800000000H                   ; 956C _ 48: B8, 0000000800000000
        and     rax, qword [rbp-20H]                    ; 9576 _ 48: 23. 45, E0
        test    rax, rax                                ; 957A _ 48: 85. C0
        je      ?_0903                                  ; 957D _ 0F 84, 00000BCD
?_0829: mov     rax, qword [rbp-30H]                    ; 9583 _ 48: 8B. 45, D0
        and     eax, 4000H                              ; 9587 _ 25, 00004000
        test    rax, rax                                ; 958C _ 48: 85. C0
        jnz     ?_0831                                  ; 958F _ 75, 1C
        mov     rax, qword [rbp-30H]                    ; 9591 _ 48: 8B. 45, D0
        and     eax, 2000H                              ; 9595 _ 25, 00002000
        test    rax, rax                                ; 959A _ 48: 85. C0
        jz      ?_0830                                  ; 959D _ 74, 07
        mov     eax, 3                                  ; 959F _ B8, 00000003
        jmp     ?_0832                                  ; 95A4 _ EB, 0C

?_0830: mov     eax, 2                                  ; 95A6 _ B8, 00000002
        jmp     ?_0832                                  ; 95AB _ EB, 05

?_0831: mov     eax, 4                                  ; 95AD _ B8, 00000004
?_0832: mov     rdx, qword [rbp-10H]                    ; 95B2 _ 48: 8B. 55, F0
        mov     dword [rdx], eax                        ; 95B6 _ 89. 02
        mov     rcx, qword [rbp-30H]                    ; 95B8 _ 48: 8B. 4D, D0
        mov     eax, dword [rbp-0A0H]                   ; 95BC _ 8B. 85, FFFFFF60
        mov     edx, 139458                             ; 95C2 _ BA, 000220C2
        mov     rsi, rcx                                ; 95C7 _ 48: 89. CE
        mov     edi, eax                                ; 95CA _ 89. C7
        call    rexflags                                ; 95CC _ E8, FFFFE1BC
        mov     rdx, qword [rbp-10H]                    ; 95D1 _ 48: 8B. 55, F0
        mov     edx, dword [rdx+4H]                     ; 95D5 _ 8B. 52, 04
        or      edx, eax                                ; 95D8 _ 09. C2
        mov     rax, qword [rbp-10H]                    ; 95DA _ 48: 8B. 45, F0
        mov     dword [rax+4H], edx                     ; 95DE _ 89. 50, 04
        mov     rcx, qword [rbp-28H]                    ; 95E1 _ 48: 8B. 4D, D8
        mov     eax, dword [rbp-9CH]                    ; 95E5 _ 8B. 85, FFFFFF64
        mov     edx, 69825                              ; 95EB _ BA, 000110C1
        mov     rsi, rcx                                ; 95F0 _ 48: 89. CE
        mov     edi, eax                                ; 95F3 _ 89. C7
        call    rexflags                                ; 95F5 _ E8, FFFFE193
        mov     rdx, qword [rbp-10H]                    ; 95FA _ 48: 8B. 55, F0
        mov     edx, dword [rdx+4H]                     ; 95FE _ 8B. 52, 04
        or      edx, eax                                ; 9601 _ 09. C2
        mov     rax, qword [rbp-10H]                    ; 9603 _ 48: 8B. 45, F0
        mov     dword [rax+4H], edx                     ; 9607 _ 89. 50, 04
        mov     eax, dword [rbp-0A0H]                   ; 960A _ 8B. 85, FFFFFF60
        and     eax, 07H                                ; 9610 _ 83. E0, 07
        mov     dword [rbp-40H], eax                    ; 9613 _ 89. 45, C0
        cmp     dword [rbp-0A4H], 8                     ; 9616 _ 83. BD, FFFFFF5C, 08
        jz      ?_0836                                  ; 961D _ 74, 5E
        cmp     dword [rbp-0A4H], 8                     ; 961F _ 83. BD, FFFFFF5C, 08
        jg      ?_0904                                  ; 9626 _ 0F 8F, 00000B27
        cmp     dword [rbp-0A4H], 4                     ; 962C _ 83. BD, FFFFFF5C, 04
        jz      ?_0835                                  ; 9633 _ 74, 3C
        cmp     dword [rbp-0A4H], 4                     ; 9635 _ 83. BD, FFFFFF5C, 04
        jg      ?_0904                                  ; 963C _ 0F 8F, 00000B11
        cmp     dword [rbp-0A4H], 1                     ; 9642 _ 83. BD, FFFFFF5C, 01
        jz      ?_0833                                  ; 9649 _ 74, 0E
        cmp     dword [rbp-0A4H], 2                     ; 964B _ 83. BD, FFFFFF5C, 02
        jz      ?_0834                                  ; 9652 _ 74, 11
        jmp     ?_0904                                  ; 9654 _ E9, 00000AFA

?_0833: mov     dword [rbp-94H], 0                      ; 9659 _ C7. 85, FFFFFF6C, 00000000
        jmp     ?_0837                                  ; 9663 _ EB, 23

?_0834: mov     dword [rbp-94H], 1                      ; 9665 _ C7. 85, FFFFFF6C, 00000001
        jmp     ?_0837                                  ; 966F _ EB, 17

?_0835: mov     dword [rbp-94H], 2                      ; 9671 _ C7. 85, FFFFFF6C, 00000002
        jmp     ?_0837                                  ; 967B _ EB, 0B

?_0836: mov     dword [rbp-94H], 3                      ; 967D _ C7. 85, FFFFFF6C, 00000003
        nop                                             ; 9687 _ 90
?_0837: cmp     dword [rbp-9CH], -1                     ; 9688 _ 83. BD, FFFFFF64, FF
        jnz     ?_0838                                  ; 968F _ 75, 16
        mov     dword [rbp-90H], 5                      ; 9691 _ C7. 85, FFFFFF70, 00000005
        mov     dword [rbp-98H], 0                      ; 969B _ C7. 85, FFFFFF68, 00000000
        jmp     ?_0839                                  ; 96A5 _ EB, 43

?_0838: mov     eax, dword [rbp-9CH]                    ; 96A7 _ 8B. 85, FFFFFF64
        and     eax, 07H                                ; 96AD _ 83. E0, 07
        mov     dword [rbp-90H], eax                    ; 96B0 _ 89. 85, FFFFFF70
        cmp     dword [rbp-90H], 5                      ; 96B6 _ 83. BD, FFFFFF70, 05
        setne   cl                                      ; 96BD _ 0F 95. C1
        mov     eax, dword [rbp-44H]                    ; 96C0 _ 8B. 45, BC
        movsxd  rdx, eax                                ; 96C3 _ 48: 63. D0
        movzx   edi, cl                                 ; 96C6 _ 0F B6. F9
        movzx   ecx, byte [rbp-0AFH]                    ; 96C9 _ 0F B6. 8D, FFFFFF51
        mov     rsi, qword [rbp-0D0H]                   ; 96D0 _ 48: 8B. B5, FFFFFF30
        mov     eax, dword [rbp-6CH]                    ; 96D7 _ 8B. 45, 94
        mov     r8d, edi                                ; 96DA _ 41: 89. F8
        mov     edi, eax                                ; 96DD _ 89. C7
        call    memory_mod                              ; 96DF _ E8, FFFFF60E
        mov     dword [rbp-98H], eax                    ; 96E4 _ 89. 85, FFFFFF68
?_0839: mov     rax, qword [rbp-10H]                    ; 96EA _ 48: 8B. 45, F0
        mov     byte [rax+8H], 1                        ; 96EE _ C6. 40, 08, 01
        cmp     dword [rbp-9CH], -1                     ; 96F2 _ 83. BD, FFFFFF64, FF
        jz      ?_0840                                  ; 96F9 _ 74, 13
        cmp     dword [rbp-98H], 2                      ; 96FB _ 83. BD, FFFFFF68, 02
        jz      ?_0840                                  ; 9702 _ 74, 0A
        mov     eax, dword [rbp-98H]                    ; 9704 _ 8B. 85, FFFFFF68
        mov     edx, eax                                ; 970A _ 89. C2
        jmp     ?_0841                                  ; 970C _ EB, 05

?_0840: mov     edx, 4                                  ; 970E _ BA, 00000004
?_0841: mov     rax, qword [rbp-10H]                    ; 9713 _ 48: 8B. 45, F0
        mov     byte [rax+9H], dl                       ; 9717 _ 88. 50, 09
        mov     eax, dword [rbp-98H]                    ; 971A _ 8B. 85, FFFFFF68
        shl     eax, 6                                  ; 9720 _ C1. E0, 06
        mov     edx, eax                                ; 9723 _ 89. C2
        mov     eax, dword [rbp-0BCH]                   ; 9725 _ 8B. 85, FFFFFF44
        shl     eax, 3                                  ; 972B _ C1. E0, 03
        and     eax, 38H                                ; 972E _ 83. E0, 38
        or      eax, edx                                ; 9731 _ 09. D0
        or      eax, 04H                                ; 9733 _ 83. C8, 04
        mov     edx, eax                                ; 9736 _ 89. C2
        mov     rax, qword [rbp-10H]                    ; 9738 _ 48: 8B. 45, F0
        mov     byte [rax+0BH], dl                      ; 973C _ 88. 50, 0B
        mov     eax, dword [rbp-94H]                    ; 973F _ 8B. 85, FFFFFF6C
        shl     eax, 6                                  ; 9745 _ C1. E0, 06
        mov     edx, eax                                ; 9748 _ 89. C2
        mov     eax, dword [rbp-40H]                    ; 974A _ 8B. 45, C0
        shl     eax, 3                                  ; 974D _ C1. E0, 03
        or      edx, eax                                ; 9750 _ 09. C2
        mov     eax, dword [rbp-90H]                    ; 9752 _ 8B. 85, FFFFFF70
        or      eax, edx                                ; 9758 _ 09. D0
        mov     edx, eax                                ; 975A _ 89. C2
        mov     rax, qword [rbp-10H]                    ; 975C _ 48: 8B. 45, F0
        mov     byte [rax+0CH], dl                      ; 9760 _ 88. 50, 0C
        jmp     ?_0895                                  ; 9763 _ E9, 00000964

?_0842: mov     rax, qword [rbp-30H]                    ; 9768 _ 48: 8B. 45, D0
        or      rax, qword [rbp-28H]                    ; 976C _ 48: 0B. 45, D8
        mov     rdx, qword 0C00000000H                  ; 9770 _ 48: BA, 0000000C00000000
        and     rax, rdx                                ; 977A _ 48: 21. D0
        test    rax, rax                                ; 977D _ 48: 85. C0
        je      ?_0877                                  ; 9780 _ 0F 84, 0000065E
        mov     rax, qword 0C00000000H                  ; 9786 _ 48: B8, 0000000C00000000
        mov     qword [rbp-18H], rax                    ; 9790 _ 48: 89. 45, E8
        mov     rax, qword [rbp-0B8H]                   ; 9794 _ 48: 8B. 85, FFFFFF48
        mov     rax, qword [rax+28H]                    ; 979B _ 48: 8B. 40, 28
        mov     dword [rbp-4CH], eax                    ; 979F _ 89. 45, B4
        cmp     dword [rbp-0A0H], -1                    ; 97A2 _ 83. BD, FFFFFF60, FF
        jz      ?_0844                                  ; 97A9 _ 74, 44
        mov     rax, qword [rbp-30H]                    ; 97AB _ 48: 8B. 45, D0
        not     rax                                     ; 97AF _ 48: F7. D0
        mov     rdx, rax                                ; 97B2 _ 48: 89. C2
        mov     rax, qword 880000105H                   ; 97B5 _ 48: B8, 0000000880000105
        and     rax, rdx                                ; 97BF _ 48: 21. D0
        test    rax, rax                                ; 97C2 _ 48: 85. C0
        jz      ?_0843                                  ; 97C5 _ 74, 20
        mov     rax, qword [rbp-30H]                    ; 97C7 _ 48: 8B. 45, D0
        not     rax                                     ; 97CB _ 48: F7. D0
        mov     rdx, rax                                ; 97CE _ 48: 89. C2
        mov     rax, qword 480000105H                   ; 97D1 _ 48: B8, 0000000480000105
        and     rax, rdx                                ; 97DB _ 48: 21. D0
        test    rax, rax                                ; 97DE _ 48: 85. C0
        jne     ?_0905                                  ; 97E1 _ 0F 85, 0000096F
?_0843: mov     rax, qword [rbp-30H]                    ; 97E7 _ 48: 8B. 45, D0
        and     qword [rbp-18H], rax                    ; 97EB _ 48: 21. 45, E8
?_0844: cmp     dword [rbp-9CH], -1                     ; 97EF _ 83. BD, FFFFFF64, FF
        jz      ?_0845                                  ; 97F6 _ 74, 3E
        mov     rax, qword [rbp-28H]                    ; 97F8 _ 48: 8B. 45, D8
        not     rax                                     ; 97FC _ 48: F7. D0
        and     eax, 105H                               ; 97FF _ 25, 00000105
        test    rax, rax                                ; 9804 _ 48: 85. C0
        jne     ?_0906                                  ; 9807 _ 0F 85, 0000094C
        mov     rax, qword [rbp-18H]                    ; 980D _ 48: 8B. 45, E8
        not     rax                                     ; 9811 _ 48: F7. D0
        and     rax, qword [rbp-28H]                    ; 9814 _ 48: 23. 45, D8
        mov     rdx, qword 0FFFF00000000H               ; 9818 _ 48: BA, 0000FFFF00000000
        and     rax, rdx                                ; 9822 _ 48: 21. D0
        test    rax, rax                                ; 9825 _ 48: 85. C0
        jne     ?_0907                                  ; 9828 _ 0F 85, 0000092E
        mov     rax, qword [rbp-28H]                    ; 982E _ 48: 8B. 45, D8
        and     qword [rbp-18H], rax                    ; 9832 _ 48: 21. 45, E8
?_0845: mov     rax, qword [rbp-0B8H]                   ; 9836 _ 48: 8B. 85, FFFFFF48
        movzx   eax, byte [rax+43H]                     ; 983D _ 0F B6. 40, 43
        cmp     al, 16                                  ; 9841 _ 3C, 10
        je      ?_0908                                  ; 9843 _ 0F 84, 00000916
        mov     rax, qword [rbp-0B8H]                   ; 9849 _ 48: 8B. 85, FFFFFF48
        movzx   eax, byte [rax+43H]                     ; 9850 _ 0F B6. 40, 43
        cmp     al, 64                                  ; 9854 _ 3C, 40
        je      ?_0908                                  ; 9856 _ 0F 84, 00000903
        cmp     dword [rbp-70H], 16                     ; 985C _ 83. 7D, 90, 10
        je      ?_0909                                  ; 9860 _ 0F 84, 000008FC
        cmp     dword [rbp-70H], 32                     ; 9866 _ 83. 7D, 90, 20
        jnz     ?_0846                                  ; 986A _ 75, 17
        mov     rax, qword 400000000H                   ; 986C _ 48: B8, 0000000400000000
        and     rax, qword [rbp-18H]                    ; 9876 _ 48: 23. 45, E8
        test    rax, rax                                ; 987A _ 48: 85. C0
        je      ?_0909                                  ; 987D _ 0F 84, 000008DF
?_0846: cmp     dword [rbp-70H], 64                     ; 9883 _ 83. 7D, 90, 40
        jnz     ?_0847                                  ; 9887 _ 75, 17
        mov     rax, qword 800000000H                   ; 9889 _ 48: B8, 0000000800000000
        and     rax, qword [rbp-18H]                    ; 9893 _ 48: 23. 45, E8
        test    rax, rax                                ; 9897 _ 48: 85. C0
        je      ?_0909                                  ; 989A _ 0F 84, 000008C2
?_0847: cmp     dword [rbp-0A4H], 1                     ; 98A0 _ 83. BD, FFFFFF5C, 01
        jnz     ?_0850                                  ; 98A7 _ 75, 78
        mov     eax, dword [rbp-9CH]                    ; 98A9 _ 8B. 85, FFFFFF64
        cmp     eax, dword [rbp-0A0H]                   ; 98AF _ 3B. 85, FFFFFF60
        jz      ?_0850                                  ; 98B5 _ 74, 6A
        cmp     dword [rbp-9CH], -1                     ; 98B7 _ 83. BD, FFFFFF64, FF
        jz      ?_0850                                  ; 98BE _ 74, 61
        cmp     dword [rbp-0A0H], -1                    ; 98C0 _ 83. BD, FFFFFF60, FF
        jz      ?_0850                                  ; 98C7 _ 74, 58
        mov     eax, dword [rbp-60H]                    ; 98C9 _ 8B. 45, A0
        cmp     eax, dword [rbp-0A8H]                   ; 98CC _ 3B. 85, FFFFFF58
        jnz     ?_0848                                  ; 98D2 _ 75, 06
        cmp     dword [rbp-5CH], 2                      ; 98D4 _ 83. 7D, A4, 02
        jz      ?_0849                                  ; 98D8 _ 74, 11
?_0848: mov     eax, dword [rbp-60H]                    ; 98DA _ 8B. 45, A0
        cmp     eax, dword [rbp-0ACH]                   ; 98DD _ 3B. 85, FFFFFF54
        jnz     ?_0850                                  ; 98E3 _ 75, 3C
        cmp     dword [rbp-5CH], 1                      ; 98E5 _ 83. 7D, A4, 01
        jnz     ?_0850                                  ; 98E9 _ 75, 36
?_0849: mov     eax, dword [rbp-9CH]                    ; 98EB _ 8B. 85, FFFFFF64
        mov     dword [rbp-48H], eax                    ; 98F1 _ 89. 45, B8
        mov     eax, dword [rbp-0A0H]                   ; 98F4 _ 8B. 85, FFFFFF60
        mov     dword [rbp-9CH], eax                    ; 98FA _ 89. 85, FFFFFF64
        mov     eax, dword [rbp-48H]                    ; 9900 _ 8B. 45, B8
        mov     dword [rbp-0A0H], eax                   ; 9903 _ 89. 85, FFFFFF60
        mov     rax, qword [rbp-28H]                    ; 9909 _ 48: 8B. 45, D8
        mov     qword [rbp-8H], rax                     ; 990D _ 48: 89. 45, F8
        mov     rax, qword [rbp-30H]                    ; 9911 _ 48: 8B. 45, D0
        mov     qword [rbp-28H], rax                    ; 9915 _ 48: 89. 45, D8
        mov     rax, qword [rbp-8H]                     ; 9919 _ 48: 8B. 45, F8
        mov     qword [rbp-30H], rax                    ; 991D _ 48: 89. 45, D0
?_0850: cmp     dword [rbp-9CH], -1                     ; 9921 _ 83. BD, FFFFFF64, FF
        jnz     ?_0852                                  ; 9928 _ 75, 40
        cmp     dword [rbp-0A4H], 1                     ; 992A _ 83. BD, FFFFFF5C, 01
        jnz     ?_0852                                  ; 9931 _ 75, 37
        mov     eax, dword [rbp-60H]                    ; 9933 _ 8B. 45, A0
        cmp     eax, dword [rbp-0ACH]                   ; 9936 _ 3B. 85, FFFFFF54
        jnz     ?_0851                                  ; 993C _ 75, 06
        cmp     dword [rbp-5CH], 2                      ; 993E _ 83. 7D, A4, 02
        jz      ?_0852                                  ; 9942 _ 74, 26
?_0851: mov     eax, dword [rbp-0A0H]                   ; 9944 _ 8B. 85, FFFFFF60
        mov     dword [rbp-9CH], eax                    ; 994A _ 89. 85, FFFFFF64
        mov     rax, qword [rbp-30H]                    ; 9950 _ 48: 8B. 45, D0
        mov     qword [rbp-28H], rax                    ; 9954 _ 48: 89. 45, D8
        mov     dword [rbp-0A0H], -1                    ; 9958 _ C7. 85, FFFFFF60, FFFFFFFF
        mov     qword [rbp-30H], 0                      ; 9962 _ 48: C7. 45, D0, 00000000
?_0852: mov     eax, dword [rbp-6CH]                    ; 996A _ 8B. 45, 94
        and     eax, 20H                                ; 996D _ 83. E0, 20
        test    eax, eax                                ; 9970 _ 85. C0
        je      ?_0854                                  ; 9972 _ 0F 84, 00000081
        cmp     dword [rbp-0A0H], -1                    ; 9978 _ 83. BD, FFFFFF60, FF
        jnz     ?_0853                                  ; 997F _ 75, 41
        mov     eax, dword [rbp-60H]                    ; 9981 _ 8B. 45, A0
        cmp     eax, dword [rbp-0A8H]                   ; 9984 _ 3B. 85, FFFFFF58
        jnz     ?_0853                                  ; 998A _ 75, 36
        cmp     dword [rbp-5CH], 2                      ; 998C _ 83. 7D, A4, 02
        jnz     ?_0853                                  ; 9990 _ 75, 30
        mov     eax, dword [rbp-9CH]                    ; 9992 _ 8B. 85, FFFFFF64
        mov     dword [rbp-0A0H], eax                   ; 9998 _ 89. 85, FFFFFF60
        mov     rax, qword [rbp-28H]                    ; 999E _ 48: 8B. 45, D8
        mov     qword [rbp-30H], rax                    ; 99A2 _ 48: 89. 45, D0
        mov     dword [rbp-9CH], -1                     ; 99A6 _ C7. 85, FFFFFF64, FFFFFFFF
        mov     qword [rbp-28H], 0                      ; 99B0 _ 48: C7. 45, D8, 00000000
        mov     dword [rbp-0A4H], 1                     ; 99B8 _ C7. 85, FFFFFF5C, 00000001
?_0853: cmp     dword [rbp-5CH], 3                      ; 99C2 _ 83. 7D, A4, 03
        jne     ?_0858                                  ; 99C6 _ 0F 85, 000000F0
        cmp     dword [rbp-9CH], -1                     ; 99CC _ 83. BD, FFFFFF64, FF
        jne     ?_0858                                  ; 99D3 _ 0F 85, 000000E3
        mov     eax, dword [rbp-0A0H]                   ; 99D9 _ 8B. 85, FFFFFF60
        mov     dword [rbp-9CH], eax                    ; 99DF _ 89. 85, FFFFFF64
        mov     rax, qword [rbp-30H]                    ; 99E5 _ 48: 8B. 45, D0
        mov     qword [rbp-28H], rax                    ; 99E9 _ 48: 89. 45, D8
        sub     dword [rbp-0A4H], 1                     ; 99ED _ 83. AD, FFFFFF5C, 01
        jmp     ?_0858                                  ; 99F4 _ E9, 000000C3

?_0854: cmp     dword [rbp-0A4H], 2                     ; 99F9 _ 83. BD, FFFFFF5C, 02
        jnz     ?_0855                                  ; 9A00 _ 75, 19
        cmp     dword [rbp-0A0H], 4                     ; 9A02 _ 83. BD, FFFFFF60, 04
        jz      ?_0855                                  ; 9A09 _ 74, 10
        mov     eax, dword [rbp-6CH]                    ; 9A0B _ 8B. 45, 94
        and     eax, 04H                                ; 9A0E _ 83. E0, 04
        test    eax, eax                                ; 9A11 _ 85. C0
        jz      ?_0856                                  ; 9A13 _ 74, 21
        cmp     dword [rbp-5CH], 3                      ; 9A15 _ 83. 7D, A4, 03
        jz      ?_0856                                  ; 9A19 _ 74, 1B
?_0855: cmp     dword [rbp-0A4H], 3                     ; 9A1B _ 83. BD, FFFFFF5C, 03
        jz      ?_0856                                  ; 9A22 _ 74, 12
        cmp     dword [rbp-0A4H], 5                     ; 9A24 _ 83. BD, FFFFFF5C, 05
        jz      ?_0856                                  ; 9A2B _ 74, 09
        cmp     dword [rbp-0A4H], 9                     ; 9A2D _ 83. BD, FFFFFF5C, 09
        jnz     ?_0857                                  ; 9A34 _ 75, 24
?_0856: cmp     dword [rbp-9CH], -1                     ; 9A36 _ 83. BD, FFFFFF64, FF
        jnz     ?_0857                                  ; 9A3D _ 75, 1B
        mov     eax, dword [rbp-0A0H]                   ; 9A3F _ 8B. 85, FFFFFF60
        mov     dword [rbp-9CH], eax                    ; 9A45 _ 89. 85, FFFFFF64
        mov     rax, qword [rbp-30H]                    ; 9A4B _ 48: 8B. 45, D0
        mov     qword [rbp-28H], rax                    ; 9A4F _ 48: 89. 45, D8
        sub     dword [rbp-0A4H], 1                     ; 9A53 _ 83. AD, FFFFFF5C, 01
?_0857: cmp     dword [rbp-0A0H], -1                    ; 9A5A _ 83. BD, FFFFFF60, FF
        jnz     ?_0858                                  ; 9A61 _ 75, 59
        mov     eax, dword [rbp-9CH]                    ; 9A63 _ 8B. 85, FFFFFF64
        and     eax, 07H                                ; 9A69 _ 83. E0, 07
        cmp     eax, 4                                  ; 9A6C _ 83. F8, 04
        jz      ?_0858                                  ; 9A6F _ 74, 4B
        mov     eax, dword [rbp-6CH]                    ; 9A71 _ 8B. 45, 94
        and     eax, 04H                                ; 9A74 _ 83. E0, 04
        test    eax, eax                                ; 9A77 _ 85. C0
        jz      ?_0858                                  ; 9A79 _ 74, 41
        mov     eax, dword [rbp-60H]                    ; 9A7B _ 8B. 45, A0
        cmp     eax, dword [rbp-0A8H]                   ; 9A7E _ 3B. 85, FFFFFF58
        jnz     ?_0858                                  ; 9A84 _ 75, 36
        cmp     dword [rbp-5CH], 2                      ; 9A86 _ 83. 7D, A4, 02
        jnz     ?_0858                                  ; 9A8A _ 75, 30
        mov     eax, dword [rbp-9CH]                    ; 9A8C _ 8B. 85, FFFFFF64
        mov     dword [rbp-0A0H], eax                   ; 9A92 _ 89. 85, FFFFFF60
        mov     rax, qword [rbp-28H]                    ; 9A98 _ 48: 8B. 45, D8
        mov     qword [rbp-30H], rax                    ; 9A9C _ 48: 89. 45, D0
        mov     dword [rbp-9CH], -1                     ; 9AA0 _ C7. 85, FFFFFF64, FFFFFFFF
        mov     qword [rbp-28H], 0                      ; 9AAA _ 48: C7. 45, D8, 00000000
        mov     dword [rbp-0A4H], 1                     ; 9AB2 _ C7. 85, FFFFFF5C, 00000001
?_0858: cmp     dword [rbp-0A4H], 1                     ; 9ABC _ 83. BD, FFFFFF5C, 01
        jnz     ?_0859                                  ; 9AC3 _ 75, 3F
        cmp     dword [rbp-0A0H], 4                     ; 9AC5 _ 83. BD, FFFFFF60, 04
        jnz     ?_0859                                  ; 9ACC _ 75, 36
        mov     eax, dword [rbp-0A0H]                   ; 9ACE _ 8B. 85, FFFFFF60
        mov     dword [rbp-48H], eax                    ; 9AD4 _ 89. 45, B8
        mov     eax, dword [rbp-9CH]                    ; 9AD7 _ 8B. 85, FFFFFF64
        mov     dword [rbp-0A0H], eax                   ; 9ADD _ 89. 85, FFFFFF60
        mov     eax, dword [rbp-48H]                    ; 9AE3 _ 8B. 45, B8
        mov     dword [rbp-9CH], eax                    ; 9AE6 _ 89. 85, FFFFFF64
        mov     rax, qword [rbp-30H]                    ; 9AEC _ 48: 8B. 45, D0
        mov     qword [rbp-8H], rax                     ; 9AF0 _ 48: 89. 45, F8
        mov     rax, qword [rbp-28H]                    ; 9AF4 _ 48: 8B. 45, D8
        mov     qword [rbp-30H], rax                    ; 9AF8 _ 48: 89. 45, D0
        mov     rax, qword [rbp-8H]                     ; 9AFC _ 48: 8B. 45, F8
        mov     qword [rbp-28H], rax                    ; 9B00 _ 48: 89. 45, D8
?_0859: cmp     dword [rbp-0A0H], 4                     ; 9B04 _ 83. BD, FFFFFF60, 04
        je      ?_0910                                  ; 9B0B _ 0F 84, 00000654
        cmp     dword [rbp-0A4H], 1                     ; 9B11 _ 83. BD, FFFFFF5C, 01
        jz      ?_0860                                  ; 9B18 _ 74, 28
        cmp     dword [rbp-0A4H], 2                     ; 9B1A _ 83. BD, FFFFFF5C, 02
        jz      ?_0860                                  ; 9B21 _ 74, 1F
        cmp     dword [rbp-0A4H], 4                     ; 9B23 _ 83. BD, FFFFFF5C, 04
        jz      ?_0860                                  ; 9B2A _ 74, 16
        cmp     dword [rbp-0A4H], 8                     ; 9B2C _ 83. BD, FFFFFF5C, 08
        jz      ?_0860                                  ; 9B33 _ 74, 0D
        cmp     dword [rbp-0A0H], -1                    ; 9B35 _ 83. BD, FFFFFF60, FF
        jne     ?_0910                                  ; 9B3C _ 0F 85, 00000623
?_0860: mov     rcx, qword [rbp-30H]                    ; 9B42 _ 48: 8B. 4D, D0
        mov     eax, dword [rbp-0A0H]                   ; 9B46 _ 8B. 85, FFFFFF60
        mov     edx, 139458                             ; 9B4C _ BA, 000220C2
        mov     rsi, rcx                                ; 9B51 _ 48: 89. CE
        mov     edi, eax                                ; 9B54 _ 89. C7
        call    rexflags                                ; 9B56 _ E8, FFFFDC32
        mov     rdx, qword [rbp-10H]                    ; 9B5B _ 48: 8B. 55, F0
        mov     edx, dword [rdx+4H]                     ; 9B5F _ 8B. 52, 04
        or      edx, eax                                ; 9B62 _ 09. C2
        mov     rax, qword [rbp-10H]                    ; 9B64 _ 48: 8B. 45, F0
        mov     dword [rax+4H], edx                     ; 9B68 _ 89. 50, 04
        mov     rcx, qword [rbp-28H]                    ; 9B6B _ 48: 8B. 4D, D8
        mov     eax, dword [rbp-9CH]                    ; 9B6F _ 8B. 85, FFFFFF64
        mov     edx, 69825                              ; 9B75 _ BA, 000110C1
        mov     rsi, rcx                                ; 9B7A _ 48: 89. CE
        mov     edi, eax                                ; 9B7D _ 89. C7
        call    rexflags                                ; 9B7F _ E8, FFFFDC09
        mov     rdx, qword [rbp-10H]                    ; 9B84 _ 48: 8B. 55, F0
        mov     edx, dword [rdx+4H]                     ; 9B88 _ 8B. 52, 04
        or      edx, eax                                ; 9B8B _ 09. C2
        mov     rax, qword [rbp-10H]                    ; 9B8D _ 48: 8B. 45, F0
        mov     dword [rax+4H], edx                     ; 9B91 _ 89. 50, 04
        cmp     dword [rbp-0A0H], -1                    ; 9B94 _ 83. BD, FFFFFF60, FF
        jne     ?_0865                                  ; 9B9B _ 0F 85, 000000E4
        mov     eax, dword [rbp-9CH]                    ; 9BA1 _ 8B. 85, FFFFFF64
        and     eax, 07H                                ; 9BA7 _ 83. E0, 07
        cmp     eax, 4                                  ; 9BAA _ 83. F8, 04
        je      ?_0865                                  ; 9BAD _ 0F 84, 000000D2
        mov     eax, dword [rbp-6CH]                    ; 9BB3 _ 8B. 45, 94
        and     eax, 40H                                ; 9BB6 _ 83. E0, 40
        test    eax, eax                                ; 9BB9 _ 85. C0
        jne     ?_0865                                  ; 9BBB _ 0F 85, 000000C4
        cmp     dword [rbp-9CH], -1                     ; 9BC1 _ 83. BD, FFFFFF64, FF
        jnz     ?_0861                                  ; 9BC8 _ 75, 16
        mov     dword [rbp-88H], 5                      ; 9BCA _ C7. 85, FFFFFF78, 00000005
        mov     dword [rbp-8CH], 0                      ; 9BD4 _ C7. 85, FFFFFF74, 00000000
        jmp     ?_0862                                  ; 9BDE _ EB, 43

?_0861: mov     eax, dword [rbp-9CH]                    ; 9BE0 _ 8B. 85, FFFFFF64
        and     eax, 07H                                ; 9BE6 _ 83. E0, 07
        mov     dword [rbp-88H], eax                    ; 9BE9 _ 89. 85, FFFFFF78
        cmp     dword [rbp-88H], 5                      ; 9BEF _ 83. BD, FFFFFF78, 05
        setne   cl                                      ; 9BF6 _ 0F 95. C1
        mov     eax, dword [rbp-4CH]                    ; 9BF9 _ 8B. 45, B4
        movsxd  rdx, eax                                ; 9BFC _ 48: 63. D0
        movzx   edi, cl                                 ; 9BFF _ 0F B6. F9
        movzx   ecx, byte [rbp-0AFH]                    ; 9C02 _ 0F B6. 8D, FFFFFF51
        mov     rsi, qword [rbp-0D0H]                   ; 9C09 _ 48: 8B. B5, FFFFFF30
        mov     eax, dword [rbp-6CH]                    ; 9C10 _ 8B. 45, 94
        mov     r8d, edi                                ; 9C13 _ 41: 89. F8
        mov     edi, eax                                ; 9C16 _ 89. C7
        call    memory_mod                              ; 9C18 _ E8, FFFFF0D5
        mov     dword [rbp-8CH], eax                    ; 9C1D _ 89. 85, FFFFFF74
?_0862: mov     rax, qword [rbp-10H]                    ; 9C23 _ 48: 8B. 45, F0
        mov     byte [rax+8H], 0                        ; 9C27 _ C6. 40, 08, 00
        cmp     dword [rbp-9CH], -1                     ; 9C2B _ 83. BD, FFFFFF64, FF
        jz      ?_0863                                  ; 9C32 _ 74, 13
        cmp     dword [rbp-8CH], 2                      ; 9C34 _ 83. BD, FFFFFF74, 02
        jz      ?_0863                                  ; 9C3B _ 74, 0A
        mov     eax, dword [rbp-8CH]                    ; 9C3D _ 8B. 85, FFFFFF74
        mov     edx, eax                                ; 9C43 _ 89. C2
        jmp     ?_0864                                  ; 9C45 _ EB, 05

?_0863: mov     edx, 4                                  ; 9C47 _ BA, 00000004
?_0864: mov     rax, qword [rbp-10H]                    ; 9C4C _ 48: 8B. 45, F0
        mov     byte [rax+9H], dl                       ; 9C50 _ 88. 50, 09
        mov     eax, dword [rbp-8CH]                    ; 9C53 _ 8B. 85, FFFFFF74
        shl     eax, 6                                  ; 9C59 _ C1. E0, 06
        mov     edx, eax                                ; 9C5C _ 89. C2
        mov     eax, dword [rbp-0BCH]                   ; 9C5E _ 8B. 85, FFFFFF44
        shl     eax, 3                                  ; 9C64 _ C1. E0, 03
        and     eax, 38H                                ; 9C67 _ 83. E0, 38
        or      edx, eax                                ; 9C6A _ 09. C2
        mov     eax, dword [rbp-88H]                    ; 9C6C _ 8B. 85, FFFFFF78
        and     eax, 07H                                ; 9C72 _ 83. E0, 07
        or      eax, edx                                ; 9C75 _ 09. D0
        mov     edx, eax                                ; 9C77 _ 89. C2
        mov     rax, qword [rbp-10H]                    ; 9C79 _ 48: 8B. 45, F0
        mov     byte [rax+0BH], dl                      ; 9C7D _ 88. 50, 0B
        jmp     ?_0895                                  ; 9C80 _ E9, 00000447

?_0865: cmp     dword [rbp-0A0H], -1                    ; 9C85 _ 83. BD, FFFFFF60, FF
        jnz     ?_0866                                  ; 9C8C _ 75, 13
        mov     dword [rbp-7CH], 4                      ; 9C8E _ C7. 45, 84, 00000004
        mov     dword [rbp-0A4H], 1                     ; 9C95 _ C7. 85, FFFFFF5C, 00000001
        jmp     ?_0867                                  ; 9C9F _ EB, 0C

?_0866: mov     eax, dword [rbp-0A0H]                   ; 9CA1 _ 8B. 85, FFFFFF60
        and     eax, 07H                                ; 9CA7 _ 83. E0, 07
        mov     dword [rbp-7CH], eax                    ; 9CAA _ 89. 45, 84
?_0867: cmp     dword [rbp-0A4H], 8                     ; 9CAD _ 83. BD, FFFFFF5C, 08
        jz      ?_0871                                  ; 9CB4 _ 74, 55
        cmp     dword [rbp-0A4H], 8                     ; 9CB6 _ 83. BD, FFFFFF5C, 08
        jg      ?_0911                                  ; 9CBD _ 0F 8F, 000004A5
        cmp     dword [rbp-0A4H], 4                     ; 9CC3 _ 83. BD, FFFFFF5C, 04
        jz      ?_0870                                  ; 9CCA _ 74, 36
        cmp     dword [rbp-0A4H], 4                     ; 9CCC _ 83. BD, FFFFFF5C, 04
        jg      ?_0911                                  ; 9CD3 _ 0F 8F, 0000048F
        cmp     dword [rbp-0A4H], 1                     ; 9CD9 _ 83. BD, FFFFFF5C, 01
        jz      ?_0868                                  ; 9CE0 _ 74, 0E
        cmp     dword [rbp-0A4H], 2                     ; 9CE2 _ 83. BD, FFFFFF5C, 02
        jz      ?_0869                                  ; 9CE9 _ 74, 0E
        jmp     ?_0911                                  ; 9CEB _ E9, 00000478

?_0868: mov     dword [rbp-80H], 0                      ; 9CF0 _ C7. 45, 80, 00000000
        jmp     ?_0872                                  ; 9CF7 _ EB, 1A

?_0869: mov     dword [rbp-80H], 1                      ; 9CF9 _ C7. 45, 80, 00000001
        jmp     ?_0872                                  ; 9D00 _ EB, 11

?_0870: mov     dword [rbp-80H], 2                      ; 9D02 _ C7. 45, 80, 00000002
        jmp     ?_0872                                  ; 9D09 _ EB, 08

?_0871: mov     dword [rbp-80H], 3                      ; 9D0B _ C7. 45, 80, 00000003
        nop                                             ; 9D12 _ 90
?_0872: cmp     dword [rbp-9CH], -1                     ; 9D13 _ 83. BD, FFFFFF64, FF
        jnz     ?_0873                                  ; 9D1A _ 75, 13
        mov     dword [rbp-78H], 5                      ; 9D1C _ C7. 45, 88, 00000005
        mov     dword [rbp-84H], 0                      ; 9D23 _ C7. 85, FFFFFF7C, 00000000
        jmp     ?_0874                                  ; 9D2D _ EB, 3D

?_0873: mov     eax, dword [rbp-9CH]                    ; 9D2F _ 8B. 85, FFFFFF64
        and     eax, 07H                                ; 9D35 _ 83. E0, 07
        mov     dword [rbp-78H], eax                    ; 9D38 _ 89. 45, 88
        cmp     dword [rbp-78H], 5                      ; 9D3B _ 83. 7D, 88, 05
        setne   cl                                      ; 9D3F _ 0F 95. C1
        mov     eax, dword [rbp-4CH]                    ; 9D42 _ 8B. 45, B4
        movsxd  rdx, eax                                ; 9D45 _ 48: 63. D0
        movzx   edi, cl                                 ; 9D48 _ 0F B6. F9
        movzx   ecx, byte [rbp-0AFH]                    ; 9D4B _ 0F B6. 8D, FFFFFF51
        mov     rsi, qword [rbp-0D0H]                   ; 9D52 _ 48: 8B. B5, FFFFFF30
        mov     eax, dword [rbp-6CH]                    ; 9D59 _ 8B. 45, 94
        mov     r8d, edi                                ; 9D5C _ 41: 89. F8
        mov     edi, eax                                ; 9D5F _ 89. C7
        call    memory_mod                              ; 9D61 _ E8, FFFFEF8C
        mov     dword [rbp-84H], eax                    ; 9D66 _ 89. 85, FFFFFF7C
?_0874: mov     rax, qword [rbp-10H]                    ; 9D6C _ 48: 8B. 45, F0
        mov     byte [rax+8H], 1                        ; 9D70 _ C6. 40, 08, 01
        cmp     dword [rbp-9CH], -1                     ; 9D74 _ 83. BD, FFFFFF64, FF
        jz      ?_0875                                  ; 9D7B _ 74, 13
        cmp     dword [rbp-84H], 2                      ; 9D7D _ 83. BD, FFFFFF7C, 02
        jz      ?_0875                                  ; 9D84 _ 74, 0A
        mov     eax, dword [rbp-84H]                    ; 9D86 _ 8B. 85, FFFFFF7C
        mov     edx, eax                                ; 9D8C _ 89. C2
        jmp     ?_0876                                  ; 9D8E _ EB, 05

?_0875: mov     edx, 4                                  ; 9D90 _ BA, 00000004
?_0876: mov     rax, qword [rbp-10H]                    ; 9D95 _ 48: 8B. 45, F0
        mov     byte [rax+9H], dl                       ; 9D99 _ 88. 50, 09
        mov     eax, dword [rbp-84H]                    ; 9D9C _ 8B. 85, FFFFFF7C
        shl     eax, 6                                  ; 9DA2 _ C1. E0, 06
        mov     edx, eax                                ; 9DA5 _ 89. C2
        mov     eax, dword [rbp-0BCH]                   ; 9DA7 _ 8B. 85, FFFFFF44
        shl     eax, 3                                  ; 9DAD _ C1. E0, 03
        and     eax, 38H                                ; 9DB0 _ 83. E0, 38
        or      eax, edx                                ; 9DB3 _ 09. D0
        or      eax, 04H                                ; 9DB5 _ 83. C8, 04
        mov     edx, eax                                ; 9DB8 _ 89. C2
        mov     rax, qword [rbp-10H]                    ; 9DBA _ 48: 8B. 45, F0
        mov     byte [rax+0BH], dl                      ; 9DBE _ 88. 50, 0B
        mov     eax, dword [rbp-80H]                    ; 9DC1 _ 8B. 45, 80
        shl     eax, 6                                  ; 9DC4 _ C1. E0, 06
        mov     edx, eax                                ; 9DC7 _ 89. C2
        mov     eax, dword [rbp-7CH]                    ; 9DC9 _ 8B. 45, 84
        shl     eax, 3                                  ; 9DCC _ C1. E0, 03
        or      edx, eax                                ; 9DCF _ 09. C2
        mov     eax, dword [rbp-78H]                    ; 9DD1 _ 8B. 45, 88
        or      eax, edx                                ; 9DD4 _ 09. D0
        mov     edx, eax                                ; 9DD6 _ 89. C2
        mov     rax, qword [rbp-10H]                    ; 9DD8 _ 48: 8B. 45, F0
        mov     byte [rax+0CH], dl                      ; 9DDC _ 88. 50, 0C
        jmp     ?_0895                                  ; 9DDF _ E9, 000002E8

?_0877: mov     rax, qword [rbp-0B8H]                   ; 9DE4 _ 48: 8B. 85, FFFFFF48
        mov     rax, qword [rax+28H]                    ; 9DEB _ 48: 8B. 40, 28
        mov     word [rbp-0AEH], ax                     ; 9DEF _ 66: 89. 85, FFFFFF52
        cmp     dword [rbp-70H], 64                     ; 9DF6 _ 83. 7D, 90, 40
        je      ?_0912                                  ; 9DFA _ 0F 84, 0000036B
        cmp     dword [rbp-0A8H], -1                    ; 9E00 _ 83. BD, FFFFFF58, FF
        jz      ?_0878                                  ; 9E07 _ 74, 2B
        cmp     dword [rbp-0A8H], 10                    ; 9E09 _ 83. BD, FFFFFF58, 0A
        jz      ?_0878                                  ; 9E10 _ 74, 22
        cmp     dword [rbp-0A8H], 12                    ; 9E12 _ 83. BD, FFFFFF58, 0C
        jz      ?_0878                                  ; 9E19 _ 74, 19
        cmp     dword [rbp-0A8H], 220                   ; 9E1B _ 81. BD, FFFFFF58, 000000DC
        jz      ?_0878                                  ; 9E25 _ 74, 0D
        cmp     dword [rbp-0A8H], 50                    ; 9E27 _ 83. BD, FFFFFF58, 32
        jne     ?_0913                                  ; 9E2E _ 0F 85, 0000033A
?_0878: cmp     dword [rbp-0ACH], -1                    ; 9E34 _ 83. BD, FFFFFF54, FF
        jz      ?_0879                                  ; 9E3B _ 74, 2B
        cmp     dword [rbp-0ACH], 10                    ; 9E3D _ 83. BD, FFFFFF54, 0A
        jz      ?_0879                                  ; 9E44 _ 74, 22
        cmp     dword [rbp-0ACH], 12                    ; 9E46 _ 83. BD, FFFFFF54, 0C
        jz      ?_0879                                  ; 9E4D _ 74, 19
        cmp     dword [rbp-0ACH], 220                   ; 9E4F _ 81. BD, FFFFFF54, 000000DC
        jz      ?_0879                                  ; 9E59 _ 74, 0D
        cmp     dword [rbp-0ACH], 50                    ; 9E5B _ 83. BD, FFFFFF54, 32
        jne     ?_0913                                  ; 9E62 _ 0F 85, 00000306
?_0879: mov     rax, qword [rbp-0B8H]                   ; 9E68 _ 48: 8B. 85, FFFFFF48
        movzx   eax, byte [rax+43H]                     ; 9E6F _ 0F B6. 40, 43
        cmp     al, 32                                  ; 9E73 _ 3C, 20
        je      ?_0914                                  ; 9E75 _ 0F 84, 000002F6
        mov     rax, qword [rbp-0B8H]                   ; 9E7B _ 48: 8B. 85, FFFFFF48
        movzx   eax, byte [rax+43H]                     ; 9E82 _ 0F B6. 40, 43
        cmp     al, 64                                  ; 9E86 _ 3C, 40
        je      ?_0914                                  ; 9E88 _ 0F 84, 000002E3
        cmp     dword [rbp-0A4H], 1                     ; 9E8E _ 83. BD, FFFFFF5C, 01
        jz      ?_0880                                  ; 9E95 _ 74, 0D
        cmp     dword [rbp-0ACH], -1                    ; 9E97 _ 83. BD, FFFFFF54, FF
        jne     ?_0915                                  ; 9E9E _ 0F 85, 000002D0
?_0880: cmp     dword [rbp-0A8H], -1                    ; 9EA4 _ 83. BD, FFFFFF58, FF
        jnz     ?_0881                                  ; 9EAB _ 75, 27
        cmp     dword [rbp-0ACH], -1                    ; 9EAD _ 83. BD, FFFFFF54, FF
        jz      ?_0881                                  ; 9EB4 _ 74, 1E
        mov     eax, dword [rbp-0A8H]                   ; 9EB6 _ 8B. 85, FFFFFF58
        mov     dword [rbp-58H], eax                    ; 9EBC _ 89. 45, A8
        mov     eax, dword [rbp-0ACH]                   ; 9EBF _ 8B. 85, FFFFFF54
        mov     dword [rbp-0A8H], eax                   ; 9EC5 _ 89. 85, FFFFFF58
        mov     eax, dword [rbp-58H]                    ; 9ECB _ 8B. 45, A8
        mov     dword [rbp-0ACH], eax                   ; 9ECE _ 89. 85, FFFFFF54
?_0881: cmp     dword [rbp-0A8H], 220                   ; 9ED4 _ 81. BD, FFFFFF58, 000000DC
        jz      ?_0882                                  ; 9EDE _ 74, 09
        cmp     dword [rbp-0A8H], 50                    ; 9EE0 _ 83. BD, FFFFFF58, 32
        jnz     ?_0883                                  ; 9EE7 _ 75, 27
?_0882: cmp     dword [rbp-0ACH], -1                    ; 9EE9 _ 83. BD, FFFFFF54, FF
        jz      ?_0883                                  ; 9EF0 _ 74, 1E
        mov     eax, dword [rbp-0A8H]                   ; 9EF2 _ 8B. 85, FFFFFF58
        mov     dword [rbp-54H], eax                    ; 9EF8 _ 89. 45, AC
        mov     eax, dword [rbp-0ACH]                   ; 9EFB _ 8B. 85, FFFFFF54
        mov     dword [rbp-0A8H], eax                   ; 9F01 _ 89. 85, FFFFFF58
        mov     eax, dword [rbp-54H]                    ; 9F07 _ 8B. 45, AC
        mov     dword [rbp-0ACH], eax                   ; 9F0A _ 89. 85, FFFFFF54
?_0883: mov     eax, dword [rbp-0A8H]                   ; 9F10 _ 8B. 85, FFFFFF58
        cmp     eax, dword [rbp-0ACH]                   ; 9F16 _ 3B. 85, FFFFFF54
        je      ?_0916                                  ; 9F1C _ 0F 84, 00000255
        cmp     dword [rbp-0ACH], -1                    ; 9F22 _ 83. BD, FFFFFF54, FF
        jz      ?_0884                                  ; 9F29 _ 74, 40
        cmp     dword [rbp-0A8H], -1                    ; 9F2B _ 83. BD, FFFFFF58, FF
        jz      ?_0884                                  ; 9F32 _ 74, 37
        cmp     dword [rbp-0ACH], 10                    ; 9F34 _ 83. BD, FFFFFF54, 0A
        je      ?_0917                                  ; 9F3B _ 0F 84, 00000239
        cmp     dword [rbp-0ACH], 12                    ; 9F41 _ 83. BD, FFFFFF54, 0C
        je      ?_0917                                  ; 9F48 _ 0F 84, 0000022C
        cmp     dword [rbp-0A8H], 220                   ; 9F4E _ 81. BD, FFFFFF58, 000000DC
        je      ?_0917                                  ; 9F58 _ 0F 84, 0000021C
        cmp     dword [rbp-0A8H], 50                    ; 9F5E _ 83. BD, FFFFFF58, 32
        je      ?_0917                                  ; 9F65 _ 0F 84, 0000020F
?_0884: cmp     dword [rbp-0A8H], -1                    ; 9F6B _ 83. BD, FFFFFF58, FF
        je      ?_0918                                  ; 9F72 _ 0F 84, 00000205
        mov     dword [rbp-74H], -1                     ; 9F78 _ C7. 45, 8C, FFFFFFFF
        cmp     dword [rbp-0ACH], -1                    ; 9F7F _ 83. BD, FFFFFF54, FF
        jz      ?_0889                                  ; 9F86 _ 74, 6E
        mov     eax, dword [rbp-0ACH]                   ; 9F88 _ 8B. 85, FFFFFF54
        shl     eax, 8                                  ; 9F8E _ C1. E0, 08
        mov     edx, eax                                ; 9F91 _ 89. C2
        mov     eax, dword [rbp-0A8H]                   ; 9F93 _ 8B. 85, FFFFFF58
        add     eax, edx                                ; 9F99 _ 01. D0
        cmp     eax, 56332                              ; 9F9B _ 3D, 0000DC0C
        jz      ?_0885                                  ; 9FA0 _ 74, 30
        cmp     eax, 56332                              ; 9FA2 _ 3D, 0000DC0C
        jg      ?_0894                                  ; 9FA7 _ 0F 8F, 000000AA
        cmp     eax, 56330                              ; 9FAD _ 3D, 0000DC0A
        jz      ?_0887                                  ; 9FB2 _ 74, 30
        cmp     eax, 56330                              ; 9FB4 _ 3D, 0000DC0A
        jg      ?_0894                                  ; 9FB9 _ 0F 8F, 00000098
        cmp     eax, 12810                              ; 9FBF _ 3D, 0000320A
        jz      ?_0888                                  ; 9FC4 _ 74, 27
        cmp     eax, 12812                              ; 9FC6 _ 3D, 0000320C
        jz      ?_0886                                  ; 9FCB _ 74, 0E
        jmp     ?_0894                                  ; 9FCD _ E9, 00000085

?_0885: mov     dword [rbp-74H], 0                      ; 9FD2 _ C7. 45, 8C, 00000000
        jmp     ?_0894                                  ; 9FD9 _ EB, 7C

?_0886: mov     dword [rbp-74H], 1                      ; 9FDB _ C7. 45, 8C, 00000001
        jmp     ?_0894                                  ; 9FE2 _ EB, 73

?_0887: mov     dword [rbp-74H], 2                      ; 9FE4 _ C7. 45, 8C, 00000002
        jmp     ?_0894                                  ; 9FEB _ EB, 6A

?_0888: mov     dword [rbp-74H], 3                      ; 9FED _ C7. 45, 8C, 00000003
        jmp     ?_0894                                  ; 9FF4 _ EB, 61

?_0889: cmp     dword [rbp-0A8H], 220                   ; 9FF6 _ 81. BD, FFFFFF58, 000000DC
        jz      ?_0890                                  ; A000 _ 74, 32
        cmp     dword [rbp-0A8H], 220                   ; A002 _ 81. BD, FFFFFF58, 000000DC
        jg      ?_0894                                  ; A00C _ 7F, 49
        cmp     dword [rbp-0A8H], 50                    ; A00E _ 83. BD, FFFFFF58, 32
        jz      ?_0891                                  ; A015 _ 74, 26
        cmp     dword [rbp-0A8H], 50                    ; A017 _ 83. BD, FFFFFF58, 32
        jg      ?_0894                                  ; A01E _ 7F, 37
        cmp     dword [rbp-0A8H], 10                    ; A020 _ 83. BD, FFFFFF58, 0A
        jz      ?_0892                                  ; A027 _ 74, 1D
        cmp     dword [rbp-0A8H], 12                    ; A029 _ 83. BD, FFFFFF58, 0C
        jz      ?_0893                                  ; A030 _ 74, 1D
        jmp     ?_0894                                  ; A032 _ EB, 23

?_0890: mov     dword [rbp-74H], 4                      ; A034 _ C7. 45, 8C, 00000004
        jmp     ?_0894                                  ; A03B _ EB, 1A

?_0891: mov     dword [rbp-74H], 5                      ; A03D _ C7. 45, 8C, 00000005
        jmp     ?_0894                                  ; A044 _ EB, 11

?_0892: mov     dword [rbp-74H], 6                      ; A046 _ C7. 45, 8C, 00000006
        jmp     ?_0894                                  ; A04D _ EB, 08

?_0893: mov     dword [rbp-74H], 7                      ; A04F _ C7. 45, 8C, 00000007
        nop                                             ; A056 _ 90
?_0894: cmp     dword [rbp-74H], -1                     ; A057 _ 83. 7D, 8C, FF
        je      ?_0919                                  ; A05B _ 0F 84, 0000011F
        cmp     dword [rbp-74H], 6                      ; A061 _ 83. 7D, 8C, 06
        setne   al                                      ; A065 _ 0F 95. C0
        movsx   rdx, word [rbp-0AEH]                    ; A068 _ 48: 0F BF. 95, FFFFFF52
        movzx   edi, al                                 ; A070 _ 0F B6. F8
        movzx   ecx, byte [rbp-0AFH]                    ; A073 _ 0F B6. 8D, FFFFFF51
        mov     rsi, qword [rbp-0D0H]                   ; A07A _ 48: 8B. B5, FFFFFF30
        mov     eax, dword [rbp-6CH]                    ; A081 _ 8B. 45, 94
        mov     r8d, edi                                ; A084 _ 41: 89. F8
        mov     edi, eax                                ; A087 _ 89. C7
        call    memory_mod                              ; A089 _ E8, FFFFEC64
        mov     dword [rbp-50H], eax                    ; A08E _ 89. 45, B0
        mov     rax, qword [rbp-10H]                    ; A091 _ 48: 8B. 45, F0
        mov     byte [rax+8H], 0                        ; A095 _ C6. 40, 08, 00
        mov     eax, dword [rbp-50H]                    ; A099 _ 8B. 45, B0
        mov     edx, eax                                ; A09C _ 89. C2
        mov     rax, qword [rbp-10H]                    ; A09E _ 48: 8B. 45, F0
        mov     byte [rax+9H], dl                       ; A0A2 _ 88. 50, 09
        mov     eax, dword [rbp-50H]                    ; A0A5 _ 8B. 45, B0
        shl     eax, 6                                  ; A0A8 _ C1. E0, 06
        mov     edx, eax                                ; A0AB _ 89. C2
        mov     eax, dword [rbp-0BCH]                   ; A0AD _ 8B. 85, FFFFFF44
        shl     eax, 3                                  ; A0B3 _ C1. E0, 03
        and     eax, 38H                                ; A0B6 _ 83. E0, 38
        or      edx, eax                                ; A0B9 _ 09. C2
        mov     eax, dword [rbp-74H]                    ; A0BB _ 8B. 45, 8C
        and     eax, 07H                                ; A0BE _ 83. E0, 07
        or      eax, edx                                ; A0C1 _ 09. D0
        mov     edx, eax                                ; A0C3 _ 89. C2
        mov     rax, qword [rbp-10H]                    ; A0C5 _ 48: 8B. 45, F0
        mov     byte [rax+0BH], dl                      ; A0C9 _ 88. 50, 0B
?_0895: mov     eax, dword [rbp-6CH]                    ; A0CC _ 8B. 45, 94
        and     eax, 08H                                ; A0CF _ 83. E0, 08
        test    eax, eax                                ; A0D2 _ 85. C0
        jz      ?_0896                                  ; A0D4 _ 74, 32
        mov     dword [rbp-3CH], 4456448                ; A0D6 _ C7. 45, C4, 00440000
        mov     eax, dword [rbp-3CH]                    ; A0DD _ 8B. 45, C4
        mov     edi, eax                                ; A0E0 _ 89. C7
        call    warn_active                             ; A0E2 _ E8, FFFF616C
        movzx   eax, al                                 ; A0E7 _ 0F B6. C0
        test    rax, rax                                ; A0EA _ 48: 85. C0
        jz      ?_0896                                  ; A0ED _ 74, 19
        lea     rdx, [rel ?_1121]                       ; A0EF _ 48: 8D. 15, 00000000(rel)
        mov     eax, dword [rbp-3CH]                    ; A0F6 _ 8B. 45, C4
        mov     rsi, rdx                                ; A0F9 _ 48: 89. D6
        mov     edi, eax                                ; A0FC _ 89. C7
        mov     eax, 0                                  ; A0FE _ B8, 00000000
        call    nasm_warn_                              ; A103 _ E8, 00000000(PLT r)
?_0896: mov     rax, qword [rbp-10H]                    ; A108 _ 48: 8B. 45, F0
        movzx   eax, byte [rax+8H]                      ; A10C _ 0F B6. 40, 08
        mov     edx, eax                                ; A110 _ 89. C2
        mov     rax, qword [rbp-10H]                    ; A112 _ 48: 8B. 45, F0
        movzx   eax, byte [rax+9H]                      ; A116 _ 0F B6. 40, 09
        add     eax, edx                                ; A11A _ 01. D0
        lea     edx, [rax+1H]                           ; A11C _ 8D. 50, 01
        mov     rax, qword [rbp-10H]                    ; A11F _ 48: 8B. 45, F0
        mov     byte [rax+0AH], dl                      ; A123 _ 88. 50, 0A
        mov     rax, qword [rbp-10H]                    ; A126 _ 48: 8B. 45, F0
        mov     eax, dword [rax]                        ; A12A _ 8B. 00
        cmp     dword [rbp-0C0H], eax                   ; A12C _ 39. 85, FFFFFF40
        jnz     ?_0921                                  ; A132 _ 75, 59
        mov     eax, 0                                  ; A134 _ B8, 00000000
        jmp     ?_0924                                  ; A139 _ E9, 00000097

?_0897: nop                                             ; A13E _ 90
        jmp     ?_0920                                  ; A13F _ EB, 40

?_0898: nop                                             ; A141 _ 90
        jmp     ?_0920                                  ; A142 _ EB, 3D

?_0899: nop                                             ; A144 _ 90
        jmp     ?_0920                                  ; A145 _ EB, 3A

?_0900: nop                                             ; A147 _ 90
        jmp     ?_0920                                  ; A148 _ EB, 37

?_0901: nop                                             ; A14A _ 90
        jmp     ?_0920                                  ; A14B _ EB, 34

?_0902: nop                                             ; A14D _ 90
        jmp     ?_0920                                  ; A14E _ EB, 31

?_0903: nop                                             ; A150 _ 90
        jmp     ?_0920                                  ; A151 _ EB, 2E

?_0904: nop                                             ; A153 _ 90
        jmp     ?_0920                                  ; A154 _ EB, 2B

?_0905: nop                                             ; A156 _ 90
        jmp     ?_0920                                  ; A157 _ EB, 28

?_0906: nop                                             ; A159 _ 90
        jmp     ?_0920                                  ; A15A _ EB, 25

?_0907: nop                                             ; A15C _ 90
        jmp     ?_0920                                  ; A15D _ EB, 22

?_0908: nop                                             ; A15F _ 90
        jmp     ?_0920                                  ; A160 _ EB, 1F

?_0909: nop                                             ; A162 _ 90
        jmp     ?_0920                                  ; A163 _ EB, 1C

?_0910: nop                                             ; A165 _ 90
        jmp     ?_0920                                  ; A166 _ EB, 19

?_0911: nop                                             ; A168 _ 90
        jmp     ?_0920                                  ; A169 _ EB, 16

?_0912: nop                                             ; A16B _ 90
        jmp     ?_0920                                  ; A16C _ EB, 13

?_0913: nop                                             ; A16E _ 90
        jmp     ?_0920                                  ; A16F _ EB, 10

?_0914: nop                                             ; A171 _ 90
        jmp     ?_0920                                  ; A172 _ EB, 0D

?_0915: nop                                             ; A174 _ 90
        jmp     ?_0920                                  ; A175 _ EB, 0A

?_0916: nop                                             ; A177 _ 90
        jmp     ?_0920                                  ; A178 _ EB, 07

?_0917: nop                                             ; A17A _ 90
        jmp     ?_0920                                  ; A17B _ EB, 04

?_0918: nop                                             ; A17D _ 90
        jmp     ?_0920                                  ; A17E _ EB, 01

?_0919: nop                                             ; A180 _ 90
?_0920: mov     rax, qword [rbp-10H]                    ; A181 _ 48: 8B. 45, F0
        mov     dword [rax], 0                          ; A185 _ C7. 00, 00000000
        jmp     ?_0922                                  ; A18B _ EB, 01

?_0921: nop                                             ; A18D _ 90
?_0922: cmp     qword [rbp-38H], 0                      ; A18E _ 48: 83. 7D, C8, 00
        jnz     ?_0923                                  ; A193 _ 75, 2D
        mov     eax, dword [rbp-70H]                    ; A195 _ 8B. 45, 90
        lea     rdx, [rel ?_1122]                       ; A198 _ 48: 8D. 15, 00000000(rel)
        lea     rdi, [rel invalid_address_msg.2]        ; A19F _ 48: 8D. 3D, 00000000(rel)
        mov     ecx, eax                                ; A1A6 _ 89. C1
        mov     esi, 40                                 ; A1A8 _ BE, 00000028
        mov     eax, 0                                  ; A1AD _ B8, 00000000
        call    snprintf                                ; A1B2 _ E8, 00000000(PLT r)
        lea     rax, [rel invalid_address_msg.2]        ; A1B7 _ 48: 8D. 05, 00000000(rel)
        mov     qword [rbp-38H], rax                    ; A1BE _ 48: 89. 45, C8
?_0923: mov     rax, qword [rbp-0D8H]                   ; A1C2 _ 48: 8B. 85, FFFFFF28
        mov     rdx, qword [rbp-38H]                    ; A1C9 _ 48: 8B. 55, C8
        mov     qword [rax], rdx                        ; A1CD _ 48: 89. 10
        mov     eax, 4294967295                         ; A1D0 _ B8, FFFFFFFF
?_0924: leave                                           ; A1D5 _ C9
        ret                                             ; A1D6 _ C3

add_asp:; Local function
        push    rbp                                     ; A1D7 _ 55
        mov     rbp, rsp                                ; A1D8 _ 48: 89. E5
        sub     rsp, 64                                 ; A1DB _ 48: 83. EC, 40
        mov     qword [rbp-38H], rdi                    ; A1DF _ 48: 89. 7D, C8
        mov     rax, qword [rbp-38H]                    ; A1E3 _ 48: 8B. 45, C8
        movzx   eax, byte [rax+7AH]                     ; A1E7 _ 0F B6. 40, 7A
        movzx   eax, al                                 ; A1EB _ 0F B6. C0
        mov     dword [rbp-18H], eax                    ; A1EE _ 89. 45, E8
        cmp     dword [rbp-18H], 64                     ; A1F1 _ 83. 7D, E8, 40
        jnz     ?_0925                                  ; A1F5 _ 75, 09
        mov     dword [rbp-28H], 96                     ; A1F7 _ C7. 45, D8, 00000060
        jmp     ?_0926                                  ; A1FE _ EB, 07

?_0925: mov     dword [rbp-28H], 48                     ; A200 _ C7. 45, D8, 00000030
?_0926: mov     rax, qword [rbp-38H]                    ; A207 _ 48: 8B. 45, C8
        mov     eax, dword [rax+20H]                    ; A20B _ 8B. 40, 20
        cmp     eax, 348                                ; A20E _ 3D, 0000015C
        jz      ?_0930                                  ; A213 _ 74, 37
        cmp     eax, 348                                ; A215 _ 3D, 0000015C
        jg      ?_0933                                  ; A21A _ 7F, 47
        cmp     eax, 347                                ; A21C _ 3D, 0000015B
        jz      ?_0929                                  ; A221 _ 74, 23
        cmp     eax, 347                                ; A223 _ 3D, 0000015B
        jg      ?_0933                                  ; A228 _ 7F, 39
        cmp     eax, 345                                ; A22A _ 3D, 00000159
        jz      ?_0927                                  ; A22F _ 74, 09
        cmp     eax, 346                                ; A231 _ 3D, 0000015A
        jz      ?_0928                                  ; A236 _ 74, 08
        jmp     ?_0933                                  ; A238 _ EB, 29

?_0927: and     dword [rbp-28H], 10H                    ; A23A _ 83. 65, D8, 10
        jmp     ?_0934                                  ; A23E _ EB, 24

?_0928: and     dword [rbp-28H], 20H                    ; A240 _ 83. 65, D8, 20
        jmp     ?_0934                                  ; A244 _ EB, 1E

?_0929: and     dword [rbp-28H], 40H                    ; A246 _ 83. 65, D8, 40
        jmp     ?_0934                                  ; A24A _ EB, 18

?_0930: cmp     dword [rbp-18H], 32                     ; A24C _ 83. 7D, E8, 20
        jnz     ?_0931                                  ; A250 _ 75, 07
        mov     eax, 16                                 ; A252 _ B8, 00000010
        jmp     ?_0932                                  ; A257 _ EB, 05

?_0931: mov     eax, 32                                 ; A259 _ B8, 00000020
?_0932: and     dword [rbp-28H], eax                    ; A25E _ 21. 45, D8
        jmp     ?_0934                                  ; A261 _ EB, 01

?_0933: nop                                             ; A263 _ 90
?_0934: mov     dword [rbp-2CH], 0                      ; A264 _ C7. 45, D4, 00000000
        jmp     ?_0951                                  ; A26B _ E9, 00000280

?_0935: mov     rcx, qword [rbp-38H]                    ; A270 _ 48: 8B. 4D, C8
        mov     eax, dword [rbp-2CH]                    ; A274 _ 8B. 45, D4
        movsxd  rdx, eax                                ; A277 _ 48: 63. D0
        mov     rax, rdx                                ; A27A _ 48: 89. D0
        shl     rax, 3                                  ; A27D _ 48: C1. E0, 03
        add     rax, rdx                                ; A281 _ 48: 01. D0
        shl     rax, 3                                  ; A284 _ 48: C1. E0, 03
        add     rax, rcx                                ; A288 _ 48: 01. C8
        add     rax, 192                                ; A28B _ 48: 05, 000000C0
        mov     rax, qword [rax]                        ; A291 _ 48: 8B. 00
        mov     rsi, rax                                ; A294 _ 48: 89. C6
        mov     edi, 12                                 ; A297 _ BF, 0000000C
        call    is_class                                ; A29C _ E8, FFFF5EBB
        test    al, al                                  ; A2A1 _ 84. C0
        je      ?_0950                                  ; A2A3 _ 0F 84, 00000243
        mov     rcx, qword [rbp-38H]                    ; A2A9 _ 48: 8B. 4D, C8
        mov     eax, dword [rbp-2CH]                    ; A2AD _ 8B. 45, D4
        movsxd  rdx, eax                                ; A2B0 _ 48: 63. D0
        mov     rax, rdx                                ; A2B3 _ 48: 89. D0
        shl     rax, 3                                  ; A2B6 _ 48: C1. E0, 03
        add     rax, rdx                                ; A2BA _ 48: 01. D0
        shl     rax, 3                                  ; A2BD _ 48: C1. E0, 03
        add     rax, rcx                                ; A2C1 _ 48: 01. C8
        add     rax, 212                                ; A2C4 _ 48: 05, 000000D4
        mov     eax, dword [rax]                        ; A2CA _ 8B. 00
        mov     edi, eax                                ; A2CC _ 89. C7
        call    is_register                             ; A2CE _ E8, FFFF5EA8
        xor     eax, 01H                                ; A2D3 _ 83. F0, 01
        test    al, al                                  ; A2D6 _ 84. C0
        jz      ?_0936                                  ; A2D8 _ 74, 0A
        mov     qword [rbp-10H], 0                      ; A2DA _ 48: C7. 45, F0, 00000000
        jmp     ?_0937                                  ; A2E2 _ EB, 3C

?_0936: mov     rcx, qword [rbp-38H]                    ; A2E4 _ 48: 8B. 4D, C8
        mov     eax, dword [rbp-2CH]                    ; A2E8 _ 8B. 45, D4
        movsxd  rdx, eax                                ; A2EB _ 48: 63. D0
        mov     rax, rdx                                ; A2EE _ 48: 89. D0
        shl     rax, 3                                  ; A2F1 _ 48: C1. E0, 03
        add     rax, rdx                                ; A2F5 _ 48: 01. D0
        shl     rax, 3                                  ; A2F8 _ 48: C1. E0, 03
        add     rax, rcx                                ; A2FC _ 48: 01. C8
        add     rax, 212                                ; A2FF _ 48: 05, 000000D4
        mov     eax, dword [rax]                        ; A305 _ 8B. 00
        cdqe                                            ; A307 _ 48: 98
        lea     rdx, [rax*8]                            ; A309 _ 48: 8D. 14 C5, 00000000
        lea     rax, [rel nasm_reg_flags]               ; A311 _ 48: 8D. 05, 00000000(rel)
        mov     rax, qword [rdx+rax]                    ; A318 _ 48: 8B. 04 02
        mov     qword [rbp-10H], rax                    ; A31C _ 48: 89. 45, F0
?_0937: mov     rcx, qword [rbp-38H]                    ; A320 _ 48: 8B. 4D, C8
        mov     eax, dword [rbp-2CH]                    ; A324 _ 8B. 45, D4
        movsxd  rdx, eax                                ; A327 _ 48: 63. D0
        mov     rax, rdx                                ; A32A _ 48: 89. D0
        shl     rax, 3                                  ; A32D _ 48: C1. E0, 03
        add     rax, rdx                                ; A331 _ 48: 01. D0
        shl     rax, 3                                  ; A334 _ 48: C1. E0, 03
        add     rax, rcx                                ; A338 _ 48: 01. C8
        add     rax, 208                                ; A33B _ 48: 05, 000000D0
        mov     eax, dword [rax]                        ; A341 _ 8B. 00
        mov     edi, eax                                ; A343 _ 89. C7
        call    is_register                             ; A345 _ E8, FFFF5E31
        xor     eax, 01H                                ; A34A _ 83. F0, 01
        test    al, al                                  ; A34D _ 84. C0
        jz      ?_0938                                  ; A34F _ 74, 0A
        mov     qword [rbp-8H], 0                       ; A351 _ 48: C7. 45, F8, 00000000
        jmp     ?_0939                                  ; A359 _ EB, 3C

?_0938: mov     rcx, qword [rbp-38H]                    ; A35B _ 48: 8B. 4D, C8
        mov     eax, dword [rbp-2CH]                    ; A35F _ 8B. 45, D4
        movsxd  rdx, eax                                ; A362 _ 48: 63. D0
        mov     rax, rdx                                ; A365 _ 48: 89. D0
        shl     rax, 3                                  ; A368 _ 48: C1. E0, 03
        add     rax, rdx                                ; A36C _ 48: 01. D0
        shl     rax, 3                                  ; A36F _ 48: C1. E0, 03
        add     rax, rcx                                ; A373 _ 48: 01. C8
        add     rax, 208                                ; A376 _ 48: 05, 000000D0
        mov     eax, dword [rax]                        ; A37C _ 8B. 00
        cdqe                                            ; A37E _ 48: 98
        lea     rdx, [rax*8]                            ; A380 _ 48: 8D. 14 C5, 00000000
        lea     rax, [rel nasm_reg_flags]               ; A388 _ 48: 8D. 05, 00000000(rel)
        mov     rax, qword [rdx+rax]                    ; A38F _ 48: 8B. 04 02
        mov     qword [rbp-8H], rax                     ; A393 _ 48: 89. 45, F8
?_0939: mov     rcx, qword [rbp-38H]                    ; A397 _ 48: 8B. 4D, C8
        mov     eax, dword [rbp-2CH]                    ; A39B _ 8B. 45, D4
        movsxd  rdx, eax                                ; A39E _ 48: 63. D0
        mov     rax, rdx                                ; A3A1 _ 48: 89. D0
        shl     rax, 3                                  ; A3A4 _ 48: C1. E0, 03
        add     rax, rdx                                ; A3A8 _ 48: 01. D0
        shl     rax, 3                                  ; A3AB _ 48: C1. E0, 03
        add     rax, rcx                                ; A3AF _ 48: 01. C8
        add     rax, 216                                ; A3B2 _ 48: 05, 000000D8
        mov     eax, dword [rax]                        ; A3B8 _ 8B. 00
        test    eax, eax                                ; A3BA _ 85. C0
        jnz     ?_0940                                  ; A3BC _ 75, 08
        mov     qword [rbp-10H], 0                      ; A3BE _ 48: C7. 45, F0, 00000000
?_0940: cmp     qword [rbp-10H], 0                      ; A3C6 _ 48: 83. 7D, F0, 00
        jnz     ?_0943                                  ; A3CB _ 75, 5C
        cmp     qword [rbp-8H], 0                       ; A3CD _ 48: 83. 7D, F8, 00
        jnz     ?_0943                                  ; A3D2 _ 75, 55
        mov     rcx, qword [rbp-38H]                    ; A3D4 _ 48: 8B. 4D, C8
        mov     eax, dword [rbp-2CH]                    ; A3D8 _ 8B. 45, D4
        movsxd  rdx, eax                                ; A3DB _ 48: 63. D0
        mov     rax, rdx                                ; A3DE _ 48: 89. D0
        shl     rax, 3                                  ; A3E1 _ 48: C1. E0, 03
        add     rax, rdx                                ; A3E5 _ 48: 01. D0
        shl     rax, 3                                  ; A3E8 _ 48: C1. E0, 03
        add     rax, rcx                                ; A3EC _ 48: 01. C8
        add     rax, 259                                ; A3EF _ 48: 05, 00000103
        movzx   eax, byte [rax]                         ; A3F5 _ 0F B6. 00
        movzx   eax, al                                 ; A3F8 _ 0F B6. C0
        mov     dword [rbp-14H], eax                    ; A3FB _ 89. 45, EC
        cmp     dword [rbp-18H], 64                     ; A3FE _ 83. 7D, E8, 40
        jz      ?_0941                                  ; A402 _ 74, 06
        cmp     dword [rbp-14H], 8                      ; A404 _ 83. 7D, EC, 08
        jg      ?_0942                                  ; A408 _ 7F, 14
?_0941: cmp     dword [rbp-18H], 64                     ; A40A _ 83. 7D, E8, 40
        jne     ?_0949                                  ; A40E _ 0F 85, 000000D7
        cmp     dword [rbp-14H], 16                     ; A414 _ 83. 7D, EC, 10
        jne     ?_0949                                  ; A418 _ 0F 85, 000000CD
?_0942: mov     eax, dword [rbp-14H]                    ; A41E _ 8B. 45, EC
        and     dword [rbp-28H], eax                    ; A421 _ 21. 45, D8
        jmp     ?_0949                                  ; A424 _ E9, 000000C2

?_0943: mov     rax, qword [rbp-8H]                     ; A429 _ 48: 8B. 45, F8
        not     rax                                     ; A42D _ 48: F7. D0
        mov     rdx, rax                                ; A430 _ 48: 89. C2
        mov     rax, qword 280000105H                   ; A433 _ 48: B8, 0000000280000105
        and     rax, rdx                                ; A43D _ 48: 21. D0
        test    rax, rax                                ; A440 _ 48: 85. C0
        jnz     ?_0944                                  ; A443 _ 75, 04
        and     dword [rbp-28H], 10H                    ; A445 _ 83. 65, D8, 10
?_0944: mov     rax, qword [rbp-8H]                     ; A449 _ 48: 8B. 45, F8
        not     rax                                     ; A44D _ 48: F7. D0
        mov     rdx, rax                                ; A450 _ 48: 89. C2
        mov     rax, qword 480000105H                   ; A453 _ 48: B8, 0000000480000105
        and     rax, rdx                                ; A45D _ 48: 21. D0
        test    rax, rax                                ; A460 _ 48: 85. C0
        jnz     ?_0945                                  ; A463 _ 75, 04
        and     dword [rbp-28H], 20H                    ; A465 _ 83. 65, D8, 20
?_0945: mov     rax, qword [rbp-8H]                     ; A469 _ 48: 8B. 45, F8
        not     rax                                     ; A46D _ 48: F7. D0
        mov     rdx, rax                                ; A470 _ 48: 89. C2
        mov     rax, qword 880000105H                   ; A473 _ 48: B8, 0000000880000105
        and     rax, rdx                                ; A47D _ 48: 21. D0
        test    rax, rax                                ; A480 _ 48: 85. C0
        jnz     ?_0946                                  ; A483 _ 75, 04
        and     dword [rbp-28H], 40H                    ; A485 _ 83. 65, D8, 40
?_0946: mov     rax, qword [rbp-10H]                    ; A489 _ 48: 8B. 45, F0
        not     rax                                     ; A48D _ 48: F7. D0
        mov     rdx, rax                                ; A490 _ 48: 89. C2
        mov     rax, qword 280000105H                   ; A493 _ 48: B8, 0000000280000105
        and     rax, rdx                                ; A49D _ 48: 21. D0
        test    rax, rax                                ; A4A0 _ 48: 85. C0
        jnz     ?_0947                                  ; A4A3 _ 75, 04
        and     dword [rbp-28H], 10H                    ; A4A5 _ 83. 65, D8, 10
?_0947: mov     rax, qword [rbp-10H]                    ; A4A9 _ 48: 8B. 45, F0
        not     rax                                     ; A4AD _ 48: F7. D0
        mov     rdx, rax                                ; A4B0 _ 48: 89. C2
        mov     rax, qword 480000105H                   ; A4B3 _ 48: B8, 0000000480000105
        and     rax, rdx                                ; A4BD _ 48: 21. D0
        test    rax, rax                                ; A4C0 _ 48: 85. C0
        jnz     ?_0948                                  ; A4C3 _ 75, 04
        and     dword [rbp-28H], 20H                    ; A4C5 _ 83. 65, D8, 20
?_0948: mov     rax, qword [rbp-10H]                    ; A4C9 _ 48: 8B. 45, F0
        not     rax                                     ; A4CD _ 48: F7. D0
        mov     rdx, rax                                ; A4D0 _ 48: 89. C2
        mov     rax, qword 880000105H                   ; A4D3 _ 48: B8, 0000000880000105
        and     rax, rdx                                ; A4DD _ 48: 21. D0
        test    rax, rax                                ; A4E0 _ 48: 85. C0
        jnz     ?_0950                                  ; A4E3 _ 75, 07
        and     dword [rbp-28H], 40H                    ; A4E5 _ 83. 65, D8, 40
        jmp     ?_0950                                  ; A4E9 _ EB, 01

?_0949: nop                                             ; A4EB _ 90
?_0950: add     dword [rbp-2CH], 1                      ; A4EC _ 83. 45, D4, 01
?_0951: mov     rax, qword [rbp-38H]                    ; A4F0 _ 48: 8B. 45, C8
        movzx   eax, byte [rax+7DH]                     ; A4F4 _ 0F B6. 40, 7D
        movzx   eax, al                                 ; A4F8 _ 0F B6. C0
        cmp     dword [rbp-2CH], eax                    ; A4FB _ 39. 45, D4
        jl      ?_0935                                  ; A4FE _ 0F 8C, FFFFFD6C
        cmp     dword [rbp-18H], 32                     ; A504 _ 83. 7D, E8, 20
        jnz     ?_0952                                  ; A508 _ 75, 09
        mov     dword [rbp-20H], 16                     ; A50A _ C7. 45, E0, 00000010
        jmp     ?_0953                                  ; A511 _ EB, 07

?_0952: mov     dword [rbp-20H], 32                     ; A513 _ C7. 45, E0, 00000020
?_0953: mov     eax, dword [rbp-28H]                    ; A51A _ 8B. 45, D8
        and     eax, dword [rbp-18H]                    ; A51D _ 23. 45, E8
        test    eax, eax                                ; A520 _ 85. C0
        jz      ?_0954                                  ; A522 _ 74, 0E
        mov     eax, dword [rbp-18H]                    ; A524 _ 8B. 45, E8
        mov     edx, eax                                ; A527 _ 89. C2
        mov     rax, qword [rbp-38H]                    ; A529 _ 48: 8B. 45, C8
        mov     byte [rax+7CH], dl                      ; A52D _ 88. 50, 7C
        jmp     ?_0958                                  ; A530 _ EB, 51

?_0954: mov     eax, dword [rbp-28H]                    ; A532 _ 8B. 45, D8
        and     eax, dword [rbp-20H]                    ; A535 _ 23. 45, E0
        test    eax, eax                                ; A538 _ 85. C0
        jz      ?_0957                                  ; A53A _ 74, 27
        cmp     dword [rbp-18H], 32                     ; A53C _ 83. 7D, E8, 20
        jnz     ?_0955                                  ; A540 _ 75, 07
        mov     edx, 345                                ; A542 _ BA, 00000159
        jmp     ?_0956                                  ; A547 _ EB, 05

?_0955: mov     edx, 346                                ; A549 _ BA, 0000015A
?_0956: mov     rax, qword [rbp-38H]                    ; A54E _ 48: 8B. 45, C8
        mov     dword [rax+20H], edx                    ; A552 _ 89. 50, 20
        mov     eax, dword [rbp-20H]                    ; A555 _ 8B. 45, E0
        mov     edx, eax                                ; A558 _ 89. C2
        mov     rax, qword [rbp-38H]                    ; A55A _ 48: 8B. 45, C8
        mov     byte [rax+7CH], dl                      ; A55E _ 88. 50, 7C
        jmp     ?_0958                                  ; A561 _ EB, 20

?_0957: lea     rax, [rel ?_1123]                       ; A563 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; A56A _ 48: 89. C7
        mov     eax, 0                                  ; A56D _ B8, 00000000
        call    nasm_nonfatal                           ; A572 _ E8, 00000000(PLT r)
        mov     eax, dword [rbp-18H]                    ; A577 _ 8B. 45, E8
        mov     edx, eax                                ; A57A _ 89. C2
        mov     rax, qword [rbp-38H]                    ; A57C _ 48: 8B. 45, C8
        mov     byte [rax+7CH], dl                      ; A580 _ 88. 50, 7C
?_0958: mov     rax, qword [rbp-38H]                    ; A583 _ 48: 8B. 45, C8
        movzx   eax, byte [rax+7CH]                     ; A587 _ 0F B6. 40, 7C
        cmp     al, 16                                  ; A58B _ 3C, 10
        jnz     ?_0959                                  ; A58D _ 75, 09
        mov     dword [rbp-24H], 16                     ; A58F _ C7. 45, DC, 00000010
        jmp     ?_0960                                  ; A596 _ EB, 07

?_0959: mov     dword [rbp-24H], 32                     ; A598 _ C7. 45, DC, 00000020
?_0960: mov     dword [rbp-2CH], 0                      ; A59F _ C7. 45, D4, 00000000
        jmp     ?_0965                                  ; A5A6 _ E9, 000000DA

?_0961: mov     rcx, qword [rbp-38H]                    ; A5AB _ 48: 8B. 4D, C8
        mov     eax, dword [rbp-2CH]                    ; A5AF _ 8B. 45, D4
        movsxd  rdx, eax                                ; A5B2 _ 48: 63. D0
        mov     rax, rdx                                ; A5B5 _ 48: 89. D0
        shl     rax, 3                                  ; A5B8 _ 48: C1. E0, 03
        add     rax, rdx                                ; A5BC _ 48: 01. D0
        shl     rax, 3                                  ; A5BF _ 48: C1. E0, 03
        add     rax, rcx                                ; A5C3 _ 48: 01. C8
        add     rax, 192                                ; A5C6 _ 48: 05, 000000C0
        mov     rax, qword [rax]                        ; A5CC _ 48: 8B. 00
        mov     rsi, rax                                ; A5CF _ 48: 89. C6
        mov     edi, 262156                             ; A5D2 _ BF, 0004000C
        call    is_class                                ; A5D7 _ E8, FFFF5B80
        xor     eax, 01H                                ; A5DC _ 83. F0, 01
        test    al, al                                  ; A5DF _ 84. C0
        jne     ?_0963                                  ; A5E1 _ 0F 85, 00000099
        mov     rcx, qword [rbp-38H]                    ; A5E7 _ 48: 8B. 4D, C8
        mov     eax, dword [rbp-2CH]                    ; A5EB _ 8B. 45, D4
        movsxd  rdx, eax                                ; A5EE _ 48: 63. D0
        mov     rax, rdx                                ; A5F1 _ 48: 89. D0
        shl     rax, 3                                  ; A5F4 _ 48: C1. E0, 03
        add     rax, rdx                                ; A5F8 _ 48: 01. D0
        shl     rax, 3                                  ; A5FB _ 48: C1. E0, 03
        add     rax, rcx                                ; A5FF _ 48: 01. C8
        add     rax, 259                                ; A602 _ 48: 05, 00000103
        movzx   eax, byte [rax]                         ; A608 _ 0F B6. 00
        movzx   eax, al                                 ; A60B _ 0F B6. C0
        mov     dword [rbp-1CH], eax                    ; A60E _ 89. 45, E4
        cmp     dword [rbp-1CH], 0                      ; A611 _ 83. 7D, E4, 00
        jnz     ?_0962                                  ; A615 _ 75, 06
        mov     eax, dword [rbp-24H]                    ; A617 _ 8B. 45, DC
        mov     dword [rbp-1CH], eax                    ; A61A _ 89. 45, E4
?_0962: mov     rax, qword [rbp-38H]                    ; A61D _ 48: 8B. 45, C8
        movzx   eax, byte [rax+7CH]                     ; A621 _ 0F B6. 40, 7C
        movzx   eax, al                                 ; A625 _ 0F B6. C0
        cmp     dword [rbp-1CH], eax                    ; A628 _ 39. 45, E4
        jz      ?_0964                                  ; A62B _ 74, 54
        mov     rcx, qword [rbp-38H]                    ; A62D _ 48: 8B. 4D, C8
        mov     eax, dword [rbp-2CH]                    ; A631 _ 8B. 45, D4
        movsxd  rdx, eax                                ; A634 _ 48: 63. D0
        mov     rax, rdx                                ; A637 _ 48: 89. D0
        shl     rax, 3                                  ; A63A _ 48: C1. E0, 03
        add     rax, rdx                                ; A63E _ 48: 01. D0
        shl     rax, 3                                  ; A641 _ 48: C1. E0, 03
        add     rax, rcx                                ; A645 _ 48: 01. C8
        add     rax, 192                                ; A648 _ 48: 05, 000000C0
        mov     rax, qword [rax]                        ; A64E _ 48: 8B. 00
        and     rax, 0FFFFFFFFFFFBFFFFH                 ; A651 _ 48: 25, FFFBFFFF
        mov     rcx, rax                                ; A657 _ 48: 89. C1
        mov     rsi, qword [rbp-38H]                    ; A65A _ 48: 8B. 75, C8
        mov     eax, dword [rbp-2CH]                    ; A65E _ 8B. 45, D4
        movsxd  rdx, eax                                ; A661 _ 48: 63. D0
        mov     rax, rdx                                ; A664 _ 48: 89. D0
        shl     rax, 3                                  ; A667 _ 48: C1. E0, 03
        add     rax, rdx                                ; A66B _ 48: 01. D0
        shl     rax, 3                                  ; A66E _ 48: C1. E0, 03
        add     rax, rsi                                ; A672 _ 48: 01. F0
        add     rax, 192                                ; A675 _ 48: 05, 000000C0
        mov     qword [rax], rcx                        ; A67B _ 48: 89. 08
        jmp     ?_0964                                  ; A67E _ EB, 01

?_0963: nop                                             ; A680 _ 90
?_0964: add     dword [rbp-2CH], 1                      ; A681 _ 83. 45, D4, 01
?_0965: mov     rax, qword [rbp-38H]                    ; A685 _ 48: 8B. 45, C8
        movzx   eax, byte [rax+7DH]                     ; A689 _ 0F B6. 40, 7D
        movzx   eax, al                                 ; A68D _ 0F B6. C0
        cmp     dword [rbp-2CH], eax                    ; A690 _ 39. 45, D4
        jl      ?_0961                                  ; A693 _ 0F 8C, FFFFFF12
        nop                                             ; A699 _ 90
        nop                                             ; A69A _ 90
        leave                                           ; A69B _ C9
        ret                                             ; A69C _ C3

set_initial_opsize:; Local function
        push    rbp                                     ; A69D _ 55
        mov     rbp, rsp                                ; A69E _ 48: 89. E5
        mov     qword [rbp-18H], rdi                    ; A6A1 _ 48: 89. 7D, E8
        mov     rax, qword [rbp-18H]                    ; A6A5 _ 48: 8B. 45, E8
        movzx   eax, byte [rax+7AH]                     ; A6A9 _ 0F B6. 40, 7A
        movzx   eax, al                                 ; A6AD _ 0F B6. C0
        mov     dword [rbp-4H], eax                     ; A6B0 _ 89. 45, FC
        mov     rax, qword [rbp-18H]                    ; A6B3 _ 48: 8B. 45, E8
        mov     eax, dword [rax+28H]                    ; A6B7 _ 8B. 40, 28
        cmp     eax, 353                                ; A6BA _ 3D, 00000161
        jz      ?_0966                                  ; A6BF _ 74, 25
        cmp     eax, 353                                ; A6C1 _ 3D, 00000161
        jg      ?_0972                                  ; A6C6 _ 7F, 57
        cmp     eax, 352                                ; A6C8 _ 3D, 00000160
        jz      ?_0971                                  ; A6CD _ 74, 46
        cmp     eax, 352                                ; A6CF _ 3D, 00000160
        jg      ?_0972                                  ; A6D4 _ 7F, 49
        cmp     eax, 350                                ; A6D6 _ 3D, 0000015E
        jz      ?_0969                                  ; A6DB _ 74, 24
        cmp     eax, 351                                ; A6DD _ 3D, 0000015F
        jz      ?_0970                                  ; A6E2 _ 74, 27
        jmp     ?_0972                                  ; A6E4 _ EB, 39

?_0966: cmp     dword [rbp-4H], 16                      ; A6E6 _ 83. 7D, FC, 10
        jnz     ?_0967                                  ; A6EA _ 75, 07
        mov     edx, 32                                 ; A6EC _ BA, 00000020
        jmp     ?_0968                                  ; A6F1 _ EB, 05

?_0967: mov     edx, 16                                 ; A6F3 _ BA, 00000010
?_0968: mov     rax, qword [rbp-18H]                    ; A6F8 _ 48: 8B. 45, E8
        mov     byte [rax+7BH], dl                      ; A6FC _ 88. 50, 7B
        jmp     ?_0975                                  ; A6FF _ EB, 38

?_0969: mov     rax, qword [rbp-18H]                    ; A701 _ 48: 8B. 45, E8
        mov     byte [rax+7BH], 16                      ; A705 _ C6. 40, 7B, 10
        jmp     ?_0975                                  ; A709 _ EB, 2E

?_0970: mov     rax, qword [rbp-18H]                    ; A70B _ 48: 8B. 45, E8
        mov     byte [rax+7BH], 32                      ; A70F _ C6. 40, 7B, 20
        jmp     ?_0975                                  ; A713 _ EB, 24

?_0971: mov     rax, qword [rbp-18H]                    ; A715 _ 48: 8B. 45, E8
        mov     byte [rax+7BH], 64                      ; A719 _ C6. 40, 7B, 40
        jmp     ?_0975                                  ; A71D _ EB, 1A

?_0972: cmp     dword [rbp-4H], 16                      ; A71F _ 83. 7D, FC, 10
        jnz     ?_0973                                  ; A723 _ 75, 07
        mov     edx, 16                                 ; A725 _ BA, 00000010
        jmp     ?_0974                                  ; A72A _ EB, 05

?_0973: mov     edx, 32                                 ; A72C _ BA, 00000020
?_0974: mov     rax, qword [rbp-18H]                    ; A731 _ 48: 8B. 45, E8
        mov     byte [rax+7BH], dl                      ; A735 _ 88. 50, 7B
        nop                                             ; A738 _ 90
?_0975: nop                                             ; A739 _ 90
        pop     rbp                                     ; A73A _ 5D
        ret                                             ; A73B _ C3

insn_early_setup:; Local function
        push    rbp                                     ; A73C _ 55
        mov     rbp, rsp                                ; A73D _ 48: 89. E5
        sub     rsp, 16                                 ; A740 _ 48: 83. EC, 10
        mov     qword [rbp-8H], rdi                     ; A744 _ 48: 89. 7D, F8
        mov     rax, qword [rbp-8H]                     ; A748 _ 48: 8B. 45, F8
        mov     rdi, rax                                ; A74C _ 48: 89. C7
        call    add_asp                                 ; A74F _ E8, FFFFFA83
        mov     rax, qword [rbp-8H]                     ; A754 _ 48: 8B. 45, F8
        mov     rdi, rax                                ; A758 _ 48: 89. C7
        call    set_initial_opsize                      ; A75B _ E8, FFFFFF3D
        nop                                             ; A760 _ 90
        leave                                           ; A761 _ C9
        ret                                             ; A762 _ C3

do_list_nonfinal_pass:; Local function
        push    rbp                                     ; A763 _ 55
        mov     rbp, rsp                                ; A764 _ 48: 89. E5
        sub     rsp, 176                                ; A767 _ 48: 81. EC, 000000B0
        mov     qword [rbp-0A8H], rdi                   ; A76E _ 48: 89. BD, FFFFFF58
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        mov     rax, qword [fs:abs 28H]                 ; A775 _ 64 48: 8B. 04 25, 00000028
        mov     qword [rbp-8H], rax                     ; A77E _ 48: 89. 45, F8
        xor     eax, eax                                ; A782 _ 31. C0
        lea     rax, [rbp-0A0H]                         ; A784 _ 48: 8D. 85, FFFFFF60
        mov     edx, 144                                ; A78B _ BA, 00000090
        mov     esi, 0                                  ; A790 _ BE, 00000000
        mov     rdi, rax                                ; A795 _ 48: 89. C7
        call    memset                                  ; A798 _ E8, 00000000(PLT r)
        mov     dword [rbp-90H], 0                      ; A79D _ C7. 85, FFFFFF70, 00000000
        mov     rax, qword [rel location]               ; A7A7 _ 48: 8B. 05, 00000000(rel)
        mov     rdx, qword [rel location+8H]            ; A7AE _ 48: 8B. 15, 00000000(rel)
        mov     qword [rbp-0A0H], rax                   ; A7B5 _ 48: 89. 85, FFFFFF60
        mov     qword [rbp-98H], rdx                    ; A7BC _ 48: 89. 95, FFFFFF68
        mov     rax, qword [rel location]               ; A7C3 _ 48: 8B. 05, 00000000(rel)
        sub     rax, qword [rbp-0A8H]                   ; A7CA _ 48: 2B. 85, FFFFFF58
        mov     qword [rbp-78H], rax                    ; A7D1 _ 48: 89. 45, 88
        mov     rax, qword [rbp-0A8H]                   ; A7D5 _ 48: 8B. 85, FFFFFF58
        mov     qword [rbp-0A0H], rax                   ; A7DC _ 48: 89. 85, FFFFFF60
        mov     rax, qword [rel lfmt]                   ; A7E3 _ 48: 8B. 05, 00000000(rel)
        mov     rdx, qword [rax+10H]                    ; A7EA _ 48: 8B. 50, 10
        lea     rax, [rbp-0A0H]                         ; A7EE _ 48: 8D. 85, FFFFFF60
        mov     rdi, rax                                ; A7F5 _ 48: 89. C7
        call    rdx                                     ; A7F8 _ FF. D2
        nop                                             ; A7FA _ 90
        mov     rax, qword [rbp-8H]                     ; A7FB _ 48: 8B. 45, F8
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        sub     rax, qword [fs:abs 28H]                 ; A7FF _ 64 48: 2B. 04 25, 00000028
        jz      ?_0976                                  ; A808 _ 74, 05
        call    __stack_chk_fail                        ; A80A _ E8, 00000000(PLT r)
?_0976: leave                                           ; A80F _ C9
        ret                                             ; A810 _ C3

list_nonfinal_pass:; Local function
        push    rbp                                     ; A811 _ 55
        mov     rbp, rsp                                ; A812 _ 48: 89. E5
        sub     rsp, 16                                 ; A815 _ 48: 83. EC, 10
        mov     qword [rbp-8H], rdi                     ; A819 _ 48: 89. 7D, F8
        mov     edi, 112                                ; A81D _ BF, 00000070
        call    list_option                             ; A822 _ E8, FFFF5F71
        test    al, al                                  ; A827 _ 84. C0
        jz      ?_0977                                  ; A829 _ 74, 0C
        mov     rax, qword [rbp-8H]                     ; A82B _ 48: 8B. 45, F8
        mov     rdi, rax                                ; A82F _ 48: 89. C7
        call    do_list_nonfinal_pass                   ; A832 _ E8, FFFFFF2C
?_0977: nop                                             ; A837 _ 90
        leave                                           ; A838 _ C9
        ret                                             ; A839 _ C3

process_one_insn:; Local function
        push    rbp                                     ; A83A _ 55
        mov     rbp, rsp                                ; A83B _ 48: 89. E5
        sub     rsp, 32                                 ; A83E _ 48: 83. EC, 20
        mov     qword [rbp-18H], rdi                    ; A842 _ 48: 89. 7D, E8
        mov     rcx, qword [rbp-18H]                    ; A846 _ 48: 8B. 4D, E8
        mov     rax, qword [rel location]               ; A84A _ 48: 8B. 05, 00000000(rel)
        mov     rdx, qword [rel location+8H]            ; A851 _ 48: 8B. 15, 00000000(rel)
        mov     qword [rcx+8H], rax                     ; A858 _ 48: 89. 41, 08
        mov     qword [rcx+10H], rdx                    ; A85C _ 48: 89. 51, 10
        call    pass_final                              ; A860 _ E8, FFFF5A60
        xor     eax, 01H                                ; A865 _ 83. F0, 01
        test    al, al                                  ; A868 _ 84. C0
        jz      ?_0978                                  ; A86A _ 74, 29
        mov     rax, qword [rbp-18H]                    ; A86C _ 48: 8B. 45, E8
        mov     rdi, rax                                ; A870 _ 48: 89. C7
        call    insn_size                               ; A873 _ E8, FFFF87D4
        mov     qword [rbp-8H], rax                     ; A878 _ 48: 89. 45, F8
        cmp     qword [rbp-8H], 0                       ; A87C _ 48: 83. 7D, F8, 00
        js      ?_0980                                  ; A881 _ 78, 62
        mov     rax, qword [rbp-18H]                    ; A883 _ 48: 8B. 45, E8
        mov     rax, qword [rax+8H]                     ; A887 _ 48: 8B. 40, 08
        mov     rdi, rax                                ; A88B _ 48: 89. C7
        call    list_nonfinal_pass                      ; A88E _ E8, FFFFFF7E
        jmp     ?_0979                                  ; A893 _ EB, 42

?_0978: mov     rax, qword [rbp-18H]                    ; A895 _ 48: 8B. 45, E8
        mov     rdi, rax                                ; A899 _ 48: 89. C7
        call    assemble                                ; A89C _ E8, FFFF7949
        mov     qword [rbp-8H], rax                     ; A8A1 _ 48: 89. 45, F8
        mov     rax, qword [rbp-8H]                     ; A8A5 _ 48: 8B. 45, F8
        shr     rax, 63                                 ; A8A9 _ 48: C1. E8, 3F
        movzx   eax, al                                 ; A8AD _ 0F B6. C0
        test    rax, rax                                ; A8B0 _ 48: 85. C0
        jz      ?_0979                                  ; A8B3 _ 74, 22
        lea     rdx, [rel ?_1013]                       ; A8B5 _ 48: 8D. 15, 00000000(rel)
        lea     rsi, [rel __func__.1]                   ; A8BC _ 48: 8D. 35, 00000000(rel)
        lea     rax, [rel ?_1124]                       ; A8C3 _ 48: 8D. 05, 00000000(rel)
        mov     ecx, 4087                               ; A8CA _ B9, 00000FF7
        mov     rdi, rax                                ; A8CF _ 48: 89. C7
        call    nasm_assert_failed                      ; A8D2 _ E8, 00000000(PLT r)
?_0979: mov     rax, qword [rbp-8H]                     ; A8D7 _ 48: 8B. 45, F8
        mov     rdi, rax                                ; A8DB _ 48: 89. C7
        call    increment_offset                        ; A8DE _ E8, 00000000(PLT r)
        jmp     ?_0981                                  ; A8E3 _ EB, 01

?_0980: nop                                             ; A8E5 _ 90
?_0981: leave                                           ; A8E6 _ C9
        ret                                             ; A8E7 _ C3

process_times_insn:; Local function
        push    rbp                                     ; A8E8 _ 55
        mov     rbp, rsp                                ; A8E9 _ 48: 89. E5
        sub     rsp, 624                                ; A8EC _ 48: 81. EC, 00000270
        mov     qword [rbp-268H], rdi                   ; A8F3 _ 48: 89. BD, FFFFFD98
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        mov     rax, qword [fs:abs 28H]                 ; A8FA _ 64 48: 8B. 04 25, 00000028
        mov     qword [rbp-8H], rax                     ; A903 _ 48: 89. 45, F8
        xor     eax, eax                                ; A907 _ 31. C0
        mov     rcx, qword [rbp-268H]                   ; A909 _ 48: 8B. 8D, FFFFFD98
        mov     rax, qword [rel location]               ; A910 _ 48: 8B. 05, 00000000(rel)
        mov     rdx, qword [rel location+8H]            ; A917 _ 48: 8B. 15, 00000000(rel)
        mov     qword [rcx+8H], rax                     ; A91E _ 48: 89. 41, 08
        mov     qword [rcx+10H], rdx                    ; A922 _ 48: 89. 51, 10
        call    pass_final                              ; A926 _ E8, FFFF599A
        xor     eax, 01H                                ; A92B _ 83. F0, 01
        test    al, al                                  ; A92E _ 84. C0
        je      ?_0986                                  ; A930 _ 0F 84, 000000BB
        mov     rax, qword [rbp-268H]                   ; A936 _ 48: 8B. 85, FFFFFD98
        mov     eax, dword [rax+74H]                    ; A93D _ 8B. 40, 74
        cdqe                                            ; A940 _ 48: 98
        mov     qword [rbp-258H], rax                   ; A942 _ 48: 89. 85, FFFFFDA8
        jmp     ?_0983                                  ; A949 _ EB, 7D

?_0982: mov     rdx, qword [rbp-268H]                   ; A94B _ 48: 8B. 95, FFFFFD98
        lea     rax, [rbp-240H]                         ; A952 _ 48: 8D. 85, FFFFFDC0
        mov     rcx, rdx                                ; A959 _ 48: 89. D1
        mov     edx, 560                                ; A95C _ BA, 00000230
        mov     rsi, rcx                                ; A961 _ 48: 89. CE
        mov     rdi, rax                                ; A964 _ 48: 89. C7
        call    memcpy                                  ; A967 _ E8, 00000000(PLT r)
        mov     rax, qword [rel location]               ; A96C _ 48: 8B. 05, 00000000(rel)
        mov     qword [rbp-238H], rax                   ; A973 _ 48: 89. 85, FFFFFDC8
        mov     rax, qword [rbp-258H]                   ; A97A _ 48: 8B. 85, FFFFFDA8
        mov     dword [rbp-1CCH], eax                   ; A981 _ 89. 85, FFFFFE34
        lea     rax, [rbp-240H]                         ; A987 _ 48: 8D. 85, FFFFFDC0
        mov     rdi, rax                                ; A98E _ 48: 89. C7
        call    insn_size                               ; A991 _ E8, FFFF86B6
        mov     qword [rbp-248H], rax                   ; A996 _ 48: 89. 85, FFFFFDB8
        cmp     qword [rbp-248H], 0                     ; A99D _ 48: 83. BD, FFFFFDB8, 00
        js      ?_0984                                  ; A9A5 _ 78, 31
        mov     rax, qword [rbp-248H]                   ; A9A7 _ 48: 8B. 85, FFFFFDB8
        mov     rdi, rax                                ; A9AE _ 48: 89. C7
        call    increment_offset                        ; A9B1 _ E8, 00000000(PLT r)
        mov     eax, dword [rbp-1CCH]                   ; A9B6 _ 8B. 85, FFFFFE34
        sub     eax, 1                                  ; A9BC _ 83. E8, 01
        cdqe                                            ; A9BF _ 48: 98
        mov     qword [rbp-258H], rax                   ; A9C1 _ 48: 89. 85, FFFFFDA8
?_0983: cmp     qword [rbp-258H], 0                     ; A9C8 _ 48: 83. BD, FFFFFDA8, 00
        jg      ?_0982                                  ; A9D0 _ 0F 8F, FFFFFF75
        jmp     ?_0985                                  ; A9D6 _ EB, 01

?_0984: nop                                             ; A9D8 _ 90
?_0985: mov     rax, qword [rbp-268H]                   ; A9D9 _ 48: 8B. 85, FFFFFD98
        mov     rax, qword [rax+8H]                     ; A9E0 _ 48: 8B. 40, 08
        mov     rdi, rax                                ; A9E4 _ 48: 89. C7
        call    list_nonfinal_pass                      ; A9E7 _ E8, FFFFFE25
        jmp     ?_0992                                  ; A9EC _ E9, 0000018C

?_0986: mov     rdx, qword [rbp-268H]                   ; A9F1 _ 48: 8B. 95, FFFFFD98
        lea     rax, [rbp-240H]                         ; A9F8 _ 48: 8D. 85, FFFFFDC0
        mov     rcx, rdx                                ; A9FF _ 48: 89. D1
        mov     edx, 560                                ; AA02 _ BA, 00000230
        mov     rsi, rcx                                ; AA07 _ 48: 89. CE
        mov     rdi, rax                                ; AA0A _ 48: 89. C7
        call    memcpy                                  ; AA0D _ E8, 00000000(PLT r)
        lea     rax, [rbp-240H]                         ; AA12 _ 48: 8D. 85, FFFFFDC0
        mov     rdi, rax                                ; AA19 _ 48: 89. C7
        call    assemble                                ; AA1C _ E8, FFFF77C9
        mov     qword [rbp-248H], rax                   ; AA21 _ 48: 89. 85, FFFFFDB8
        mov     rax, qword [rbp-248H]                   ; AA28 _ 48: 8B. 85, FFFFFDB8
        shr     rax, 63                                 ; AA2F _ 48: C1. E8, 3F
        movzx   eax, al                                 ; AA33 _ 0F B6. C0
        test    rax, rax                                ; AA36 _ 48: 85. C0
        jz      ?_0987                                  ; AA39 _ 74, 22
        lea     rdx, [rel ?_1013]                       ; AA3B _ 48: 8D. 15, 00000000(rel)
        lea     rsi, [rel __func__.0]                   ; AA42 _ 48: 8D. 35, 00000000(rel)
        lea     rax, [rel ?_1124]                       ; AA49 _ 48: 8D. 05, 00000000(rel)
        mov     ecx, 4132                               ; AA50 _ B9, 00001024
        mov     rdi, rax                                ; AA55 _ 48: 89. C7
        call    nasm_assert_failed                      ; AA58 _ E8, 00000000(PLT r)
?_0987: mov     rax, qword [rbp-248H]                   ; AA5D _ 48: 8B. 85, FFFFFDB8
        mov     rdi, rax                                ; AA64 _ 48: 89. C7
        call    increment_offset                        ; AA67 _ E8, 00000000(PLT r)
        mov     eax, dword [rbp-1CCH]                   ; AA6C _ 8B. 85, FFFFFE34
        cdqe                                            ; AA72 _ 48: 98
        mov     qword [rbp-250H], rax                   ; AA74 _ 48: 89. 85, FFFFFDB0
        cmp     qword [rbp-250H], 1                     ; AA7B _ 48: 83. BD, FFFFFDB0, 01
        jle     ?_0991                                  ; AA83 _ 0F 8E, 000000F3
        mov     rax, qword [rel lfmt]                   ; AA89 _ 48: 8B. 05, 00000000(rel)
        mov     rdx, qword [rax+20H]                    ; AA90 _ 48: 8B. 50, 20
        mov     rax, qword [rbp-250H]                   ; AA94 _ 48: 8B. 85, FFFFFDB0
        mov     rsi, rax                                ; AA9B _ 48: 89. C6
        mov     edi, 5                                  ; AA9E _ BF, 00000005
        call    rdx                                     ; AAA3 _ FF. D2
        sub     qword [rbp-250H], 1                     ; AAA5 _ 48: 83. AD, FFFFFDB0, 01
        jmp     ?_0990                                  ; AAAD _ E9, 000000A8

?_0988: mov     rdx, qword [rbp-268H]                   ; AAB2 _ 48: 8B. 95, FFFFFD98
        lea     rax, [rbp-240H]                         ; AAB9 _ 48: 8D. 85, FFFFFDC0
        mov     rcx, rdx                                ; AAC0 _ 48: 89. D1
        mov     edx, 560                                ; AAC3 _ BA, 00000230
        mov     rsi, rcx                                ; AAC8 _ 48: 89. CE
        mov     rdi, rax                                ; AACB _ 48: 89. C7
        call    memcpy                                  ; AACE _ E8, 00000000(PLT r)
        mov     rax, qword [rel location]               ; AAD3 _ 48: 8B. 05, 00000000(rel)
        mov     qword [rbp-238H], rax                   ; AADA _ 48: 89. 85, FFFFFDC8
        mov     rax, qword [rbp-250H]                   ; AAE1 _ 48: 8B. 85, FFFFFDB0
        mov     dword [rbp-1CCH], eax                   ; AAE8 _ 89. 85, FFFFFE34
        lea     rax, [rbp-240H]                         ; AAEE _ 48: 8D. 85, FFFFFDC0
        mov     rdi, rax                                ; AAF5 _ 48: 89. C7
        call    assemble                                ; AAF8 _ E8, FFFF76ED
        mov     qword [rbp-248H], rax                   ; AAFD _ 48: 89. 85, FFFFFDB8
        mov     rax, qword [rbp-248H]                   ; AB04 _ 48: 8B. 85, FFFFFDB8
        shr     rax, 63                                 ; AB0B _ 48: C1. E8, 3F
        movzx   eax, al                                 ; AB0F _ 0F B6. C0
        test    rax, rax                                ; AB12 _ 48: 85. C0
        jz      ?_0989                                  ; AB15 _ 74, 22
        lea     rdx, [rel ?_1013]                       ; AB17 _ 48: 8D. 15, 00000000(rel)
        lea     rsi, [rel __func__.0]                   ; AB1E _ 48: 8D. 35, 00000000(rel)
        lea     rax, [rel ?_1124]                       ; AB25 _ 48: 8D. 05, 00000000(rel)
        mov     ecx, 4146                               ; AB2C _ B9, 00001032
        mov     rdi, rax                                ; AB31 _ 48: 89. C7
        call    nasm_assert_failed                      ; AB34 _ E8, 00000000(PLT r)
?_0989: mov     rax, qword [rbp-248H]                   ; AB39 _ 48: 8B. 85, FFFFFDB8
        mov     rdi, rax                                ; AB40 _ 48: 89. C7
        call    increment_offset                        ; AB43 _ E8, 00000000(PLT r)
        mov     eax, dword [rbp-1CCH]                   ; AB48 _ 8B. 85, FFFFFE34
        sub     eax, 1                                  ; AB4E _ 83. E8, 01
        cdqe                                            ; AB51 _ 48: 98
        mov     qword [rbp-250H], rax                   ; AB53 _ 48: 89. 85, FFFFFDB0
?_0990: cmp     qword [rbp-250H], 0                     ; AB5A _ 48: 83. BD, FFFFFDB0, 00
        jne     ?_0988                                  ; AB62 _ 0F 85, FFFFFF4A
        mov     rax, qword [rel lfmt]                   ; AB68 _ 48: 8B. 05, 00000000(rel)
        mov     rax, qword [rax+28H]                    ; AB6F _ 48: 8B. 40, 28
        mov     edi, 5                                  ; AB73 _ BF, 00000005
        call    rax                                     ; AB78 _ FF. D0
        jmp     ?_0992                                  ; AB7A _ EB, 01

?_0991: nop                                             ; AB7C _ 90
?_0992: mov     rax, qword [rbp-8H]                     ; AB7D _ 48: 8B. 45, F8
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        sub     rax, qword [fs:abs 28H]                 ; AB81 _ 64 48: 2B. 04 25, 00000028
        jz      ?_0993                                  ; AB8A _ 74, 05
        call    __stack_chk_fail                        ; AB8C _ E8, 00000000(PLT r)
?_0993: leave                                           ; AB91 _ C9
        ret                                             ; AB92 _ C3

process_insn:; Function begin
        push    rbp                                     ; AB93 _ 55
        mov     rbp, rsp                                ; AB94 _ 48: 89. E5
        sub     rsp, 16                                 ; AB97 _ 48: 83. EC, 10
        mov     qword [rbp-8H], rdi                     ; AB9B _ 48: 89. 7D, F8
        mov     rax, qword [rbp-8H]                     ; AB9F _ 48: 8B. 45, F8
        mov     eax, dword [rax+74H]                    ; ABA3 _ 8B. 40, 74
        cmp     eax, 1                                  ; ABA6 _ 83. F8, 01
        sete    al                                      ; ABA9 _ 0F 94. C0
        movzx   eax, al                                 ; ABAC _ 0F B6. C0
        test    rax, rax                                ; ABAF _ 48: 85. C0
        jz      ?_0994                                  ; ABB2 _ 74, 0E
        mov     rax, qword [rbp-8H]                     ; ABB4 _ 48: 8B. 45, F8
        mov     rdi, rax                                ; ABB8 _ 48: 89. C7
        call    process_one_insn                        ; ABBB _ E8, FFFFFC7A
        jmp     ?_0996                                  ; ABC0 _ EB, 4F

?_0994: mov     rax, qword [rbp-8H]                     ; ABC2 _ 48: 8B. 45, F8
        mov     eax, dword [rax+74H]                    ; ABC6 _ 8B. 40, 74
        test    eax, eax                                ; ABC9 _ 85. C0
        jz      ?_0996                                  ; ABCB _ 74, 44
        mov     rax, qword [rbp-8H]                     ; ABCD _ 48: 8B. 45, F8
        mov     eax, dword [rax+74H]                    ; ABD1 _ 8B. 40, 74
        test    eax, eax                                ; ABD4 _ 85. C0
        setg    al                                      ; ABD6 _ 0F 9F. C0
        movzx   eax, al                                 ; ABD9 _ 0F B6. C0
        test    rax, rax                                ; ABDC _ 48: 85. C0
        jz      ?_0995                                  ; ABDF _ 74, 0E
        mov     rax, qword [rbp-8H]                     ; ABE1 _ 48: 8B. 45, F8
        mov     rdi, rax                                ; ABE5 _ 48: 89. C7
        call    process_times_insn                      ; ABE8 _ E8, FFFFFCFB
        jmp     ?_0996                                  ; ABED _ EB, 22

?_0995: mov     rax, qword [rbp-8H]                     ; ABEF _ 48: 8B. 45, F8
        mov     eax, dword [rax+74H]                    ; ABF3 _ 8B. 40, 74
        lea     rcx, [rel ?_1125]                       ; ABF6 _ 48: 8D. 0D, 00000000(rel)
        mov     edx, eax                                ; ABFD _ 89. C2
        mov     rsi, rcx                                ; ABFF _ 48: 89. CE
        mov     edi, 256                                ; AC02 _ BF, 00000100
        mov     eax, 0                                  ; AC07 _ B8, 00000000
        call    nasm_nonfatalf                          ; AC0C _ E8, 00000000(PLT r)
?_0996: nop                                             ; AC11 _ 90
        leave                                           ; AC12 _ C9
        ret                                             ; AC13 _ C3
; process_insn End of function


SECTION .data   align=1 noexec                          ; section number 2, data


SECTION .bss    align=32 noexec                         ; section number 3, bss

dbg.9:                                                  ; byte
        resq    1                                       ; 0000

?_0997: resq    1                                       ; 0008

?_0998: resd    4                                       ; 0010

invalid_address_msg.2:                                  ; byte
        resb    40                                      ; 0020


SECTION .rodata align=32 noexec                         ; section number 4, const

?_0999:                                                 ; byte
        db 69H, 6EH, 76H, 61H, 6CH, 69H, 64H, 20H       ; 0000 _ invalid 
        db 25H, 73H, 20H, 70H, 72H, 65H, 66H, 69H       ; 0008 _ %s prefi
        db 78H, 00H                                     ; 0010 _ x.

?_1000:                                                 ; byte
        db 62H, 79H, 74H, 65H, 00H                      ; 0012 _ byte.

?_1001:                                                 ; byte
        db 77H, 6FH, 72H, 64H, 00H                      ; 0017 _ word.

?_1002:                                                 ; byte
        db 64H, 77H, 6FH, 72H, 64H, 00H                 ; 001C _ dword.

?_1003:                                                 ; byte
        db 71H, 77H, 6FH, 72H, 64H, 00H                 ; 0022 _ qword.

?_1004:                                                 ; byte
        db 74H, 77H, 6FH, 72H, 64H, 00H                 ; 0028 _ tword.

?_1005:                                                 ; byte
        db 6FH, 77H, 6FH, 72H, 64H, 00H                 ; 002E _ oword.

?_1006:                                                 ; byte
        db 79H, 77H, 6FH, 72H, 64H, 00H                 ; 0034 _ yword.

?_1007:                                                 ; byte
        db 7AH, 77H, 6FH, 72H, 64H, 00H                 ; 003A _ zword.

?_1008:                                                 ; byte
        db 3FH, 3FH, 3FH, 00H                           ; 0040 _ ???.

?_1009:                                                 ; byte
        db 20H, 00H                                     ; 0044 _  .

?_1010:                                                 ; byte
        db 25H, 73H, 25H, 73H, 25H, 73H, 25H, 73H       ; 0046 _ %s%s%s%s
        db 25H, 73H, 20H, 65H, 78H, 63H, 65H, 65H       ; 004E _ %s excee
        db 64H, 73H, 20H, 62H, 6FH, 75H, 6EH, 64H       ; 0056 _ ds bound
        db 73H, 00H                                     ; 005E _ s.

?_1011:                                                 ; byte
        db 73H, 69H, 67H, 6EH, 65H, 64H, 00H            ; 0060 _ signed.

?_1012:                                                 ; byte
        db 75H, 6EH, 73H, 69H, 67H, 6EH, 65H, 64H       ; 0067 _ unsigned
        db 00H                                          ; 006F _ .

?_1013:                                                 ; byte
        db 2EH, 2FH, 61H, 73H, 6DH, 2FH, 61H, 73H       ; 0070 _ ./asm/as
        db 73H, 65H, 6DH, 62H, 6CH, 65H, 2EH, 63H       ; 0078 _ semble.c
        db 00H                                          ; 0080 _ .

?_1014:                                                 ; byte
        db 64H, 61H, 74H, 61H, 2DH, 3EH, 73H, 69H       ; 0081 _ data->si
        db 7AH, 65H, 20H, 3CH, 3DH, 20H, 38H, 00H       ; 0089 _ ze <= 8.

?_1015:                                                 ; byte
        db 61H, 62H, 73H, 6FH, 6CH, 75H, 74H, 65H       ; 0091 _ absolute
        db 00H                                          ; 0099 _ .

?_1016:                                                 ; byte
        db 72H, 65H, 6CH, 61H, 74H, 69H, 76H, 65H       ; 009A _ relative
        db 00H, 00H, 00H, 00H, 00H, 00H                 ; 00A2 _ ......

?_1017:                                                 ; byte
        db 25H, 75H, 2DH, 62H, 69H, 74H, 20H, 25H       ; 00A8 _ %u-bit %
        db 73H, 20H, 73H, 65H, 63H, 74H, 69H, 6FH       ; 00B0 _ s sectio
        db 6EH, 2DH, 63H, 72H, 6FH, 73H, 73H, 69H       ; 00B8 _ n-crossi
        db 6EH, 67H, 20H, 72H, 65H, 6CH, 6FH, 63H       ; 00C0 _ ng reloc
        db 61H, 74H, 69H, 6FH, 6EH, 00H, 00H, 00H       ; 00C8 _ ation...

?_1018:                                                 ; byte
        db 25H, 75H, 2DH, 62H, 69H, 74H, 20H, 73H       ; 00D0 _ %u-bit s
        db 69H, 67H, 6EH, 65H, 64H, 20H, 72H, 65H       ; 00D8 _ igned re
        db 6CH, 6FH, 63H, 61H, 74H, 69H, 6FH, 6EH       ; 00E0 _ location
        db 20H, 75H, 6EH, 73H, 75H, 70H, 70H, 6FH       ; 00E8 _  unsuppo
        db 72H, 74H, 65H, 64H, 20H, 62H, 79H, 20H       ; 00F0 _ rted by 
        db 6FH, 75H, 74H, 70H, 75H, 74H, 20H, 66H       ; 00F8 _ output f
        db 6FH, 72H, 6DH, 61H, 74H, 20H, 25H, 73H       ; 0100 _ ormat %s
        db 00H                                          ; 0108 _ .

?_1019:                                                 ; byte
        db 73H, 65H, 67H, 6DH, 65H, 6EH, 74H, 00H       ; 0109 _ segment.
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H            ; 0111 _ .......

?_1020:                                                 ; byte
        db 25H, 75H, 2DH, 62H, 69H, 74H, 20H, 25H       ; 0118 _ %u-bit %
        db 73H, 20H, 72H, 65H, 6CH, 6FH, 63H, 61H       ; 0120 _ s reloca
        db 74H, 69H, 6FH, 6EH, 20H, 7AH, 65H, 72H       ; 0128 _ tion zer
        db 6FH, 2DH, 65H, 78H, 74H, 65H, 6EH, 64H       ; 0130 _ o-extend
        db 65H, 64H, 20H, 66H, 72H, 6FH, 6DH, 20H       ; 0138 _ ed from 
        db 25H, 75H, 20H, 62H, 69H, 74H, 73H, 00H       ; 0140 _ %u bits.

?_1021:                                                 ; byte
        db 61H, 74H, 74H, 65H, 6DH, 70H, 74H, 20H       ; 0148 _ attempt 
        db 74H, 6FH, 20H, 61H, 73H, 73H, 65H, 6DH       ; 0150 _ to assem
        db 62H, 6CH, 65H, 20H, 63H, 6FH, 64H, 65H       ; 0158 _ ble code
        db 20H, 69H, 6EH, 20H, 5BH, 41H, 42H, 53H       ; 0160 _  in [ABS
        db 4FH, 4CH, 55H, 54H, 45H, 5DH, 20H, 73H       ; 0168 _ OLUTE] s
        db 70H, 61H, 63H, 65H, 00H, 00H, 00H, 00H       ; 0170 _ pace....

?_1022:                                                 ; byte
        db 73H, 65H, 67H, 6DH, 65H, 6EH, 74H, 20H       ; 0178 _ segment 
        db 72H, 65H, 66H, 65H, 72H, 65H, 6EH, 63H       ; 0180 _ referenc
        db 65H, 73H, 20H, 63H, 61H, 6EH, 6EH, 6FH       ; 0188 _ es canno
        db 74H, 20H, 62H, 65H, 20H, 72H, 65H, 6CH       ; 0190 _ t be rel
        db 61H, 74H, 69H, 76H, 65H, 00H, 00H, 00H       ; 0198 _ ative...

?_1023:                                                 ; byte
        db 73H, 65H, 67H, 6DH, 65H, 6EH, 74H, 20H       ; 01A0 _ segment 
        db 72H, 65H, 66H, 65H, 72H, 65H, 6EH, 63H       ; 01A8 _ referenc
        db 65H, 20H, 6DH, 75H, 73H, 74H, 20H, 62H       ; 01B0 _ e must b
        db 65H, 20H, 31H, 36H, 20H, 62H, 69H, 74H       ; 01B8 _ e 16 bit
        db 73H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 01C0 _ s.......

?_1024:                                                 ; byte
        db 69H, 6EH, 76H, 61H, 6CH, 69H, 64H, 20H       ; 01C8 _ invalid 
        db 75H, 73H, 65H, 20H, 6FH, 66H, 20H, 73H       ; 01D0 _ use of s
        db 65H, 6CH, 66H, 2DH, 72H, 65H, 6CH, 61H       ; 01D8 _ elf-rela
        db 74H, 69H, 76H, 65H, 20H, 65H, 78H, 70H       ; 01E0 _ tive exp
        db 72H, 65H, 73H, 73H, 69H, 6FH, 6EH, 00H       ; 01E8 _ ression.

?_1025:                                                 ; byte
        db 69H, 6EH, 76H, 61H, 6CH, 69H, 64H, 20H       ; 01F0 _ invalid 
        db 63H, 6FH, 6DH, 62H, 69H, 6EH, 61H, 74H       ; 01F8 _ combinat
        db 69H, 6FH, 6EH, 20H, 6FH, 66H, 20H, 6FH       ; 0200 _ ion of o
        db 70H, 63H, 6FH, 64H, 65H, 20H, 61H, 6EH       ; 0208 _ pcode an
        db 64H, 20H, 6FH, 70H, 65H, 72H, 61H, 6EH       ; 0210 _ d operan
        db 64H, 73H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0218 _ ds......

?_1026:                                                 ; byte
        db 69H, 6EH, 76H, 61H, 6CH, 69H, 64H, 20H       ; 0220 _ invalid 
        db 6FH, 70H, 65H, 72H, 61H, 6EH, 64H, 20H       ; 0228 _ operand 
        db 73H, 69H, 7AH, 65H, 73H, 20H, 66H, 6FH       ; 0230 _ sizes fo
        db 72H, 20H, 69H, 6EH, 73H, 74H, 72H, 75H       ; 0238 _ r instru
        db 63H, 74H, 69H, 6FH, 6EH, 00H                 ; 0240 _ ction.

?_1027:                                                 ; byte
        db 6FH, 70H, 65H, 72H, 61H, 74H, 69H, 6FH       ; 0246 _ operatio
        db 6EH, 20H, 73H, 69H, 7AH, 65H, 20H, 6EH       ; 024E _ n size n
        db 6FH, 74H, 20H, 73H, 70H, 65H, 63H, 69H       ; 0256 _ ot speci
        db 66H, 69H, 65H, 64H, 00H                      ; 025E _ fied.

?_1028:                                                 ; byte
        db 6DH, 69H, 73H, 6DH, 61H, 74H, 63H, 68H       ; 0263 _ mismatch
        db 20H, 69H, 6EH, 20H, 6FH, 70H, 65H, 72H       ; 026B _  in oper
        db 61H, 6EH, 64H, 20H, 73H, 69H, 7AH, 65H       ; 0273 _ and size
        db 73H, 00H, 00H, 00H, 00H                      ; 027B _ s....

?_1029:                                                 ; byte
        db 62H, 72H, 6FH, 61H, 64H, 63H, 61H, 73H       ; 0280 _ broadcas
        db 74H, 20H, 6EH, 6FH, 74H, 20H, 70H, 65H       ; 0288 _ t not pe
        db 72H, 6DH, 69H, 74H, 74H, 65H, 64H, 20H       ; 0290 _ rmitted 
        db 6FH, 6EH, 20H, 74H, 68H, 69H, 73H, 20H       ; 0298 _ on this 
        db 6FH, 70H, 65H, 72H, 61H, 6EH, 64H, 00H       ; 02A0 _ operand.

?_1030:                                                 ; byte
        db 6DH, 69H, 73H, 6DH, 61H, 74H, 63H, 68H       ; 02A8 _ mismatch
        db 20H, 69H, 6EH, 20H, 74H, 68H, 65H, 20H       ; 02B0 _  in the 
        db 6EH, 75H, 6DH, 62H, 65H, 72H, 20H, 6FH       ; 02B8 _ number o
        db 66H, 20H, 62H, 72H, 6FH, 61H, 64H, 63H       ; 02C0 _ f broadc
        db 61H, 73H, 74H, 69H, 6EH, 67H, 20H, 65H       ; 02C8 _ asting e
        db 6CH, 65H, 6DH, 65H, 6EH, 74H, 73H, 00H       ; 02D0 _ lements.

?_1031:                                                 ; byte
        db 6DH, 61H, 73H, 6BH, 20H, 6EH, 6FH, 74H       ; 02D8 _ mask not
        db 20H, 70H, 65H, 72H, 6DH, 69H, 74H, 74H       ; 02E0 _  permitt
        db 65H, 64H, 20H, 6FH, 6EH, 20H, 74H, 68H       ; 02E8 _ ed on th
        db 69H, 73H, 20H, 6FH, 70H, 65H, 72H, 61H       ; 02F0 _ is opera
        db 6EH, 64H, 00H, 00H, 00H, 00H, 00H, 00H       ; 02F8 _ nd......

?_1032:                                                 ; byte
        db 75H, 6EH, 73H, 75H, 70H, 70H, 6FH, 72H       ; 0300 _ unsuppor
        db 74H, 65H, 64H, 20H, 6DH, 6FH, 64H, 65H       ; 0308 _ ted mode
        db 20H, 64H, 65H, 63H, 6FH, 72H, 61H, 74H       ; 0310 _  decorat
        db 6FH, 72H, 20H, 66H, 6FH, 72H, 20H, 69H       ; 0318 _ or for i
        db 6EH, 73H, 74H, 72H, 75H, 63H, 74H, 69H       ; 0320 _ nstructi
        db 6FH, 6EH, 00H, 00H, 00H, 00H, 00H, 00H       ; 0328 _ on......

?_1033:                                                 ; byte
        db 6EH, 6FH, 20H, 69H, 6EH, 73H, 74H, 72H       ; 0330 _ no instr
        db 75H, 63H, 74H, 69H, 6FH, 6EH, 20H, 66H       ; 0338 _ uction f
        db 6FH, 72H, 20H, 74H, 68H, 69H, 73H, 20H       ; 0340 _ or this 
        db 63H, 70H, 75H, 20H, 6CH, 65H, 76H, 65H       ; 0348 _ cpu leve
        db 6CH, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0350 _ l.......

?_1034:                                                 ; byte
        db 69H, 6EH, 73H, 74H, 72H, 75H, 63H, 74H       ; 0358 _ instruct
        db 69H, 6FH, 6EH, 20H, 6EH, 6FH, 74H, 20H       ; 0360 _ ion not 
        db 73H, 75H, 70H, 70H, 6FH, 72H, 74H, 65H       ; 0368 _ supporte
        db 64H, 20H, 69H, 6EH, 20H, 25H, 64H, 2DH       ; 0370 _ d in %d-
        db 62H, 69H, 74H, 20H, 6DH, 6FH, 64H, 65H       ; 0378 _ bit mode
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0380 _ ........

?_1035:                                                 ; byte
        db 69H, 6EH, 73H, 74H, 72H, 75H, 63H, 74H       ; 0388 _ instruct
        db 69H, 6FH, 6EH, 20H, 6EH, 6FH, 74H, 20H       ; 0390 _ ion not 
        db 65H, 6EH, 63H, 6FH, 64H, 61H, 62H, 6CH       ; 0398 _ encodabl
        db 65H, 20H, 77H, 69H, 74H, 68H, 6FH, 75H       ; 03A0 _ e withou
        db 74H, 20H, 65H, 78H, 70H, 6CH, 69H, 63H       ; 03A8 _ t explic
        db 69H, 74H, 20H, 70H, 72H, 65H, 66H, 69H       ; 03B0 _ it prefi
        db 78H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 03B8 _ x.......

?_1036:                                                 ; byte
        db 69H, 6EH, 73H, 74H, 72H, 75H, 63H, 74H       ; 03C0 _ instruct
        db 69H, 6FH, 6EH, 20H, 6EH, 6FH, 74H, 20H       ; 03C8 _ ion not 
        db 65H, 6EH, 63H, 6FH, 64H, 61H, 62H, 6CH       ; 03D0 _ encodabl
        db 65H, 20H, 77H, 69H, 74H, 68H, 20H, 25H       ; 03D8 _ e with %
        db 73H, 20H, 70H, 72H, 65H, 66H, 69H, 78H       ; 03E0 _ s prefix
        db 00H                                          ; 03E8 _ .

?_1037:                                                 ; byte
        db 25H, 73H, 20H, 70H, 72H, 65H, 66H, 69H       ; 03E9 _ %s prefi
        db 78H, 20H, 69H, 73H, 20H, 6EH, 6FH, 74H       ; 03F1 _ x is not
        db 20H, 61H, 6CH, 6CH, 6FH, 77H, 65H, 64H       ; 03F9 _  allowed
        db 00H                                          ; 0401 _ .

?_1038:                                                 ; byte
        db 69H, 6EH, 76H, 61H, 6CH, 69H, 64H, 20H       ; 0402 _ invalid 
        db 72H, 65H, 67H, 69H, 73H, 74H, 65H, 72H       ; 040A _ register
        db 20H, 73H, 65H, 74H, 20H, 73H, 69H, 7AH       ; 0412 _  set siz
        db 65H, 00H, 00H, 00H, 00H, 00H                 ; 041A _ e.....

?_1039:                                                 ; byte
        db 72H, 65H, 67H, 69H, 73H, 74H, 65H, 72H       ; 0420 _ register
        db 20H, 73H, 65H, 74H, 20H, 6EH, 6FH, 74H       ; 0428 _  set not
        db 20H, 76H, 61H, 6CH, 69H, 64H, 20H, 66H       ; 0430 _  valid f
        db 6FH, 72H, 20H, 6FH, 70H, 65H, 72H, 61H       ; 0438 _ or opera
        db 6EH, 64H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0440 _ nd......

?_1040:                                                 ; byte
        db 6FH, 70H, 65H, 72H, 61H, 6EH, 64H, 2FH       ; 0448 _ operand/
        db 6FH, 70H, 65H, 72H, 61H, 74H, 6FH, 72H       ; 0450 _ operator
        db 20H, 69H, 6EH, 76H, 61H, 6CH, 69H, 64H       ; 0458 _  invalid
        db 20H, 66H, 6FH, 72H, 20H, 74H, 68H, 69H       ; 0460 _  for thi
        db 73H, 20H, 69H, 6EH, 73H, 74H, 72H, 75H       ; 0468 _ s instru
        db 63H, 74H, 69H, 6FH, 6EH, 00H, 00H, 00H       ; 0470 _ ction...

?_1041:                                                 ; byte
        db 7BH, 7AH, 75H, 7DH, 20H, 6EH, 6FH, 74H       ; 0478 _ {zu} not
        db 20H, 61H, 70H, 70H, 6CH, 69H, 63H, 61H       ; 0480 _  applica
        db 62H, 6CH, 65H, 20H, 74H, 6FH, 20H, 74H       ; 0488 _ ble to t
        db 68H, 69H, 73H, 20H, 69H, 6EH, 73H, 74H       ; 0490 _ his inst
        db 72H, 75H, 63H, 74H, 69H, 6FH, 6EH, 00H       ; 0498 _ ruction.

?_1042:                                                 ; byte
        db 7BH, 7AH, 75H, 7DH, 20H, 69H, 6EH, 76H       ; 04A0 _ {zu} inv
        db 61H, 6CH, 69H, 64H, 20H, 66H, 6FH, 72H       ; 04A8 _ alid for
        db 20H, 6EH, 6FH, 6EH, 2DH, 72H, 65H, 67H       ; 04B0 _  non-reg
        db 69H, 73H, 74H, 65H, 72H, 20H, 64H, 65H       ; 04B8 _ ister de
        db 73H, 74H, 69H, 6EH, 61H, 74H, 69H, 6FH       ; 04C0 _ stinatio
        db 6EH, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 04C8 _ n.......

?_1043:                                                 ; byte
        db 7BH, 6EH, 66H, 7DH, 20H, 6EH, 6FH, 74H       ; 04D0 _ {nf} not
        db 20H, 61H, 76H, 61H, 69H, 6CH, 61H, 62H       ; 04D8 _  availab
        db 6CH, 65H, 20H, 66H, 6FH, 72H, 20H, 74H       ; 04E0 _ le for t
        db 68H, 69H, 73H, 20H, 69H, 6EH, 73H, 74H       ; 04E8 _ his inst
        db 72H, 75H, 63H, 74H, 69H, 6FH, 6EH, 00H       ; 04F0 _ ruction.

?_1044:                                                 ; byte
        db 7BH, 6EH, 66H, 7DH, 20H, 72H, 65H, 71H       ; 04F8 _ {nf} req
        db 75H, 69H, 72H, 65H, 64H, 20H, 66H, 6FH       ; 0500 _ uired fo
        db 72H, 20H, 74H, 68H, 69H, 73H, 20H, 69H       ; 0508 _ r this i
        db 6EH, 73H, 74H, 72H, 75H, 63H, 74H, 69H       ; 0510 _ nstructi
        db 6FH, 6EH, 00H                                ; 0518 _ on.

?_1045:                                                 ; byte
        db 69H, 6EH, 76H, 61H, 6CH, 69H, 64H, 20H       ; 051B _ invalid 
        db 75H, 73H, 65H, 20H, 6FH, 66H, 20H, 69H       ; 0523 _ use of i
        db 6EH, 73H, 74H, 72H, 75H, 63H, 74H, 69H       ; 052B _ nstructi
        db 6FH, 6EH, 00H, 00H, 00H                      ; 0533 _ on...

?_1046:                                                 ; byte
        db 69H, 6EH, 74H, 65H, 67H, 65H, 72H, 20H       ; 0538 _ integer 
        db 73H, 75H, 70H, 70H, 6CH, 69H, 65H, 64H       ; 0540 _ supplied
        db 20H, 61H, 73H, 20H, 25H, 64H, 2DH, 62H       ; 0548 _  as %d-b
        db 69H, 74H, 20H, 64H, 61H, 74H, 61H, 00H       ; 0550 _ it data.

?_1047:                                                 ; byte
        db 20H, 3BH, 3BH, 3BH, 20H, 75H, 73H, 65H       ; 0558 _  ;;; use
        db 64H, 20H, 74H, 65H, 6DH, 70H, 6CH, 61H       ; 0560 _ d templa
        db 74H, 65H, 20H, 25H, 73H, 3AH, 25H, 64H       ; 0568 _ te %s:%d
        db 20H, 66H, 72H, 6FH, 6DH, 20H, 69H, 6EH       ; 0570 _  from in
        db 73H, 6EH, 73H, 2EH, 78H, 64H, 61H, 3AH       ; 0578 _ sns.xda:
        db 25H, 75H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0580 _ %u......

?_1048:                                                 ; byte
        db 60H, 69H, 6EH, 63H, 62H, 69H, 6EH, 27H       ; 0588 _ `incbin'
        db 3AH, 20H, 75H, 6EH, 61H, 62H, 6CH, 65H       ; 0590 _ : unable
        db 20H, 74H, 6FH, 20H, 6FH, 70H, 65H, 6EH       ; 0598 _  to open
        db 20H, 66H, 69H, 6CH, 65H, 20H, 60H, 25H       ; 05A0 _  file `%
        db 73H, 27H, 00H, 00H, 00H, 00H, 00H, 00H       ; 05A8 _ s'......

?_1049:                                                 ; byte
        db 60H, 69H, 6EH, 63H, 62H, 69H, 6EH, 27H       ; 05B0 _ `incbin'
        db 3AH, 20H, 75H, 6EH, 61H, 62H, 6CH, 65H       ; 05B8 _ : unable
        db 20H, 74H, 6FH, 20H, 67H, 65H, 74H, 20H       ; 05C0 _  to get 
        db 6CH, 65H, 6EH, 67H, 74H, 68H, 20H, 6FH       ; 05C8 _ length o
        db 66H, 20H, 66H, 69H, 6CH, 65H, 20H, 60H       ; 05D0 _ f file `
        db 25H, 73H, 27H, 00H, 00H, 00H, 00H, 00H       ; 05D8 _ %s'.....

?_1050:                                                 ; byte
        db 60H, 69H, 6EH, 63H, 62H, 69H, 6EH, 27H       ; 05E0 _ `incbin'
        db 3AH, 20H, 75H, 6EH, 61H, 62H, 6CH, 65H       ; 05E8 _ : unable
        db 20H, 74H, 6FH, 20H, 73H, 65H, 65H, 6BH       ; 05F0 _  to seek
        db 20H, 6FH, 6EH, 20H, 66H, 69H, 6CH, 65H       ; 05F8 _  on file
        db 20H, 60H, 25H, 73H, 27H, 00H, 00H, 00H       ; 0600 _  `%s'...

?_1051:                                                 ; byte
        db 60H, 69H, 6EH, 63H, 62H, 69H, 6EH, 27H       ; 0608 _ `incbin'
        db 3AH, 20H, 75H, 6EH, 65H, 78H, 70H, 65H       ; 0610 _ : unexpe
        db 63H, 74H, 65H, 64H, 20H, 45H, 4FH, 46H       ; 0618 _ cted EOF
        db 20H, 77H, 68H, 69H, 6CH, 65H, 20H, 72H       ; 0620 _  while r
        db 65H, 61H, 64H, 69H, 6EH, 67H, 20H, 66H       ; 0628 _ eading f
        db 69H, 6CH, 65H, 20H, 60H, 25H, 73H, 27H       ; 0630 _ ile `%s'
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0638 _ ........

?_1052:                                                 ; byte
        db 60H, 69H, 6EH, 63H, 62H, 69H, 6EH, 27H       ; 0640 _ `incbin'
        db 3AH, 20H, 65H, 72H, 72H, 6FH, 72H, 20H       ; 0648 _ : error 
        db 77H, 68H, 69H, 6CH, 65H, 20H, 72H, 65H       ; 0650 _ while re
        db 61H, 64H, 69H, 6EH, 67H, 20H, 66H, 69H       ; 0658 _ ading fi
        db 6CH, 65H, 20H, 60H, 25H, 73H, 27H, 00H       ; 0660 _ le `%s'.

?_1053:                                                 ; byte
        db 6EH, 65H, 76H, 65H, 72H, 20H, 69H, 6DH       ; 0668 _ never im
        db 70H, 6CH, 65H, 6DH, 65H, 6EH, 74H, 65H       ; 0670 _ plemente
        db 64H, 00H                                     ; 0678 _ d.

?_1054:                                                 ; byte
        db 6FH, 62H, 73H, 6FH, 6CH, 65H, 74H, 65H       ; 067A _ obsolete
        db 00H                                          ; 0682 _ .

?_1055:                                                 ; byte
        db 62H, 75H, 74H, 20H, 76H, 61H, 6CH, 69H       ; 0683 _ but vali
        db 64H, 20H, 6FH, 6EH, 00H                      ; 068B _ d on.

?_1056:                                                 ; byte
        db 61H, 6EH, 64H, 20H, 69H, 73H, 20H, 61H       ; 0690 _ and is a
        db 20H, 6EH, 6FH, 6FH, 70H, 20H, 6FH, 6EH       ; 0698 _  noop on
        db 00H                                          ; 06A0 _ .

?_1057:                                                 ; byte
        db 61H, 6EH, 64H, 20H, 69H, 6EH, 76H, 61H       ; 06A1 _ and inva
        db 6CH, 69H, 64H, 20H, 6FH, 6EH, 00H            ; 06A9 _ lid on.

?_1058:                                                 ; byte
        db 61H, 6EH, 64H, 20H, 72H, 65H, 6DH, 6FH       ; 06B0 _ and remo
        db 76H, 65H, 64H, 20H, 66H, 72H, 6FH, 6DH       ; 06B8 _ ved from
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 06C0 _ ........

?_1059:                                                 ; byte
        db 69H, 6EH, 73H, 74H, 72H, 75H, 63H, 74H       ; 06C8 _ instruct
        db 69H, 6FH, 6EH, 20H, 25H, 73H, 20H, 25H       ; 06D0 _ ion %s %
        db 73H, 20H, 74H, 68H, 65H, 20H, 74H, 61H       ; 06D8 _ s the ta
        db 72H, 67H, 65H, 74H, 20H, 43H, 50H, 55H       ; 06E0 _ rget CPU
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 06E8 _ ........

?_1060:                                                 ; byte
        db 69H, 6EH, 73H, 74H, 72H, 75H, 63H, 74H       ; 06F0 _ instruct
        db 69H, 6FH, 6EH, 20H, 6CH, 65H, 6EH, 67H       ; 06F8 _ ion leng
        db 74H, 68H, 20H, 63H, 68H, 61H, 6EH, 67H       ; 0700 _ th chang
        db 65H, 64H, 20H, 64H, 75H, 72H, 69H, 6EH       ; 0708 _ ed durin
        db 67H, 20H, 63H, 6FH, 64H, 65H, 20H, 67H       ; 0710 _ g code g
        db 65H, 6EH, 65H, 72H, 61H, 74H, 69H, 6FH       ; 0718 _ eneratio
        db 6EH, 20H, 28H, 25H, 75H, 20H, 2DH, 3EH       ; 0720 _ n (%u ->
        db 20H, 25H, 75H, 29H, 00H, 00H, 00H, 00H       ; 0728 _  %u)....

?_1061:                                                 ; byte
        db 64H, 61H, 74H, 61H, 2EH, 6CH, 6FH, 63H       ; 0730 _ data.loc
        db 2EH, 6FH, 66H, 66H, 73H, 65H, 74H, 20H       ; 0738 _ .offset 
        db 2DH, 20H, 73H, 74H, 61H, 72H, 74H, 20H       ; 0740 _ - start 
        db 3DH, 3DH, 20H, 64H, 61H, 74H, 61H, 2EH       ; 0748 _ == data.
        db 69H, 6EH, 73H, 6CH, 65H, 6EH, 00H            ; 0750 _ inslen.

?_1062:                                                 ; byte
        db 45H, 51H, 55H, 20H, 6EH, 6FH, 74H, 20H       ; 0757 _ EQU not 
        db 70H, 72H, 65H, 63H, 65H, 64H, 65H, 64H       ; 075F _ preceded
        db 20H, 62H, 79H, 20H, 6CH, 61H, 62H, 65H       ; 0767 _  by labe
        db 6CH, 00H                                     ; 076F _ l.

?_1063:                                                 ; byte
        db 62H, 61H, 64H, 20H, 73H, 79H, 6EH, 74H       ; 0771 _ bad synt
        db 61H, 78H, 20H, 66H, 6FH, 72H, 20H, 45H       ; 0779 _ ax for E
        db 51H, 55H, 00H, 00H, 00H, 00H, 00H            ; 0781 _ QU.....

?_1064:                                                 ; byte
        db 25H, 73H, 20H, 77H, 69H, 74H, 68H, 20H       ; 0788 _ %s with 
        db 74H, 68H, 69H, 73H, 20H, 69H, 6EH, 73H       ; 0790 _ this ins
        db 74H, 72H, 75H, 63H, 74H, 69H, 6FH, 6EH       ; 0798 _ truction
        db 20H, 72H, 65H, 71H, 75H, 69H, 72H, 65H       ; 07A0 _  require
        db 73H, 20H, 6CH, 6FH, 63H, 6BH, 00H, 00H       ; 07A8 _ s lock..

?_1065:                                                 ; byte
        db 25H, 73H, 20H, 69H, 6EH, 76H, 61H, 6CH       ; 07B0 _ %s inval
        db 69H, 64H, 20H, 77H, 69H, 74H, 68H, 20H       ; 07B8 _ id with 
        db 74H, 68H, 69H, 73H, 20H, 69H, 6EH, 73H       ; 07C0 _ this ins
        db 74H, 72H, 75H, 63H, 74H, 69H, 6FH, 6EH       ; 07C8 _ truction
        db 00H                                          ; 07D0 _ .

?_1066:                                                 ; byte
        db 65H, 6DH, 62H, 65H, 64H, 64H, 65H, 64H       ; 07D1 _ embedded
        db 20H, 72H, 6FH, 75H, 6EH, 64H, 69H, 6EH       ; 07D9 _  roundin
        db 67H, 00H                                     ; 07E1 _ g.

?_1067:                                                 ; byte
        db 73H, 75H, 70H, 70H, 72H, 65H, 73H, 73H       ; 07E3 _ suppress
        db 20H, 61H, 6CH, 6CH, 20H, 65H, 78H, 63H       ; 07EB _  all exc
        db 65H, 70H, 74H, 69H, 6FH, 6EH, 73H, 00H       ; 07F3 _ eptions.
        db 00H, 00H, 00H, 00H, 00H                      ; 07FB _ .....

?_1068:                                                 ; byte
        db 25H, 73H, 20H, 6EH, 6FH, 74H, 20H, 70H       ; 0800 _ %s not p
        db 6FH, 73H, 73H, 69H, 62H, 6CH, 65H, 20H       ; 0808 _ ossible 
        db 66H, 6FH, 72H, 20H, 25H, 64H, 2DH, 62H       ; 0810 _ for %d-b
        db 69H, 74H, 20H, 76H, 65H, 63H, 74H, 6FH       ; 0818 _ it vecto
        db 72H, 73H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0820 _ rs......

?_1069:                                                 ; byte
        db 69H, 6EH, 76H, 61H, 6CH, 69H, 64H, 20H       ; 0828 _ invalid 
        db 6FH, 70H, 65H, 72H, 61H, 6EH, 64H, 20H       ; 0830 _ operand 
        db 73H, 69H, 7AH, 65H, 20H, 70H, 72H, 65H       ; 0838 _ size pre
        db 66H, 69H, 78H, 20H, 25H, 73H, 2CH, 20H       ; 0840 _ fix %s, 
        db 6DH, 75H, 73H, 74H, 20H, 62H, 65H, 20H       ; 0848 _ must be 
        db 6FH, 31H, 36H, 00H, 00H, 00H, 00H, 00H       ; 0850 _ o16.....

?_1070:                                                 ; byte
        db 69H, 6EH, 73H, 74H, 72H, 75H, 63H, 74H       ; 0858 _ instruct
        db 69H, 6FH, 6EH, 20H, 6EH, 6FH, 74H, 20H       ; 0860 _ ion not 
        db 76H, 61H, 6CH, 69H, 64H, 20H, 77H, 69H       ; 0868 _ valid wi
        db 74H, 68H, 20H, 33H, 32H, 2DH, 62H, 69H       ; 0870 _ th 32-bi
        db 74H, 20H, 6FH, 70H, 65H, 72H, 61H, 6EH       ; 0878 _ t operan
        db 64H, 20H, 73H, 69H, 7AH, 65H, 00H, 00H       ; 0880 _ d size..

?_1071:                                                 ; byte
        db 69H, 6EH, 76H, 61H, 6CH, 69H, 64H, 20H       ; 0888 _ invalid 
        db 6FH, 70H, 65H, 72H, 61H, 6EH, 64H, 20H       ; 0890 _ operand 
        db 73H, 69H, 7AH, 65H, 20H, 70H, 72H, 65H       ; 0898 _ size pre
        db 66H, 69H, 78H, 20H, 25H, 73H, 2CH, 20H       ; 08A0 _ fix %s, 
        db 6DH, 75H, 73H, 74H, 20H, 62H, 65H, 20H       ; 08A8 _ must be 
        db 6FH, 33H, 32H, 00H, 00H, 00H, 00H, 00H       ; 08B0 _ o32.....

?_1072:                                                 ; byte
        db 69H, 6EH, 76H, 61H, 6CH, 69H, 64H, 20H       ; 08B8 _ invalid 
        db 6FH, 70H, 65H, 72H, 61H, 6EH, 64H, 20H       ; 08C0 _ operand 
        db 73H, 69H, 7AH, 65H, 20H, 70H, 72H, 65H       ; 08C8 _ size pre
        db 66H, 69H, 78H, 20H, 25H, 73H, 2CH, 20H       ; 08D0 _ fix %s, 
        db 6DH, 75H, 73H, 74H, 20H, 62H, 65H, 20H       ; 08D8 _ must be 
        db 6FH, 36H, 34H, 00H, 00H, 00H, 00H, 00H       ; 08E0 _ o64.....

?_1073:                                                 ; byte
        db 61H, 74H, 74H, 65H, 6DH, 70H, 74H, 20H       ; 08E8 _ attempt 
        db 74H, 6FH, 20H, 72H, 65H, 73H, 65H, 72H       ; 08F0 _ to reser
        db 76H, 65H, 20H, 6EH, 6FH, 6EH, 2DH, 63H       ; 08F8 _ ve non-c
        db 6FH, 6EH, 73H, 74H, 61H, 6EH, 74H, 20H       ; 0900 _ onstant 
        db 71H, 75H, 61H, 6EH, 74H, 69H, 74H, 79H       ; 0908 _ quantity
        db 20H, 6FH, 66H, 20H, 6DH, 65H, 6DH, 6FH       ; 0910 _  of memo
        db 72H, 79H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0918 _ ry......

?_1074:                                                 ; byte
        db 66H, 6FH, 72H, 77H, 61H, 72H, 64H, 20H       ; 0920 _ forward 
        db 72H, 65H, 66H, 65H, 72H, 65H, 6EH, 63H       ; 0928 _ referenc
        db 65H, 20H, 69H, 6EH, 20H, 25H, 73H, 20H       ; 0930 _ e in %s 
        db 63H, 61H, 6EH, 20H, 68H, 61H, 76H, 65H       ; 0938 _ can have
        db 20H, 75H, 6EH, 70H, 72H, 65H, 64H, 69H       ; 0940 _  unpredi
        db 63H, 74H, 61H, 62H, 6CH, 65H, 20H, 72H       ; 0948 _ ctable r
        db 65H, 73H, 75H, 6CH, 74H, 73H, 00H, 00H       ; 0950 _ esults..

?_1075:                                                 ; byte
        db 6AH, 6DH, 70H, 20H, 73H, 68H, 6FH, 72H       ; 0958 _ jmp shor
        db 74H, 20H, 64H, 6FH, 65H, 73H, 20H, 6EH       ; 0960 _ t does n
        db 6FH, 74H, 20H, 69H, 6EH, 69H, 74H, 20H       ; 0968 _ ot init 
        db 62H, 6EH, 64H, 20H, 72H, 65H, 67H, 73H       ; 0970 _ bnd regs
        db 20H, 2DH, 20H, 62H, 6EH, 64H, 20H, 70H       ; 0978 _  - bnd p
        db 72H, 65H, 66H, 69H, 78H, 20H, 64H, 72H       ; 0980 _ refix dr
        db 6FH, 70H, 70H, 65H, 64H, 00H                 ; 0988 _ opped.

?_1076:                                                 ; byte
        db 25H, 73H, 00H, 00H, 00H, 00H, 00H, 00H       ; 098E _ %s......
        db 00H, 00H                                     ; 0996 _ ..

?_1077:                                                 ; byte
        db 69H, 6EH, 74H, 65H, 72H, 6EH, 61H, 6CH       ; 0998 _ internal
        db 20H, 69H, 6EH, 73H, 74H, 72H, 75H, 63H       ; 09A0 _  instruc
        db 74H, 69H, 6FH, 6EH, 20H, 74H, 61H, 62H       ; 09A8 _ tion tab
        db 6CH, 65H, 20H, 63H, 6FH, 72H, 72H, 75H       ; 09B0 _ le corru
        db 70H, 74H, 3AH, 20H, 69H, 6EH, 73H, 74H       ; 09B8 _ pt: inst
        db 72H, 75H, 63H, 74H, 69H, 6FH, 6EH, 20H       ; 09C0 _ ruction 
        db 63H, 6FH, 64H, 65H, 20H, 5CH, 25H, 6FH       ; 09C8 _ code \%o
        db 20H, 28H, 30H, 78H, 25H, 30H, 32H, 58H       ; 09D0 _  (0x%02X
        db 29H, 20H, 67H, 69H, 76H, 65H, 6EH, 00H       ; 09D8 _ ) given.

?_1078:                                                 ; byte
        db 69H, 6EH, 73H, 74H, 72H, 75H, 63H, 74H       ; 09E0 _ instruct
        db 69H, 6FH, 6EH, 20H, 63H, 61H, 6EH, 6EH       ; 09E8 _ ion cann
        db 6FH, 74H, 20H, 75H, 73H, 65H, 20H, 68H       ; 09F0 _ ot use h
        db 69H, 67H, 68H, 20H, 72H, 65H, 67H, 69H       ; 09F8 _ igh regi
        db 73H, 74H, 65H, 72H, 73H, 00H, 00H, 00H       ; 0A00 _ sters...

?_1079:                                                 ; byte
        db 52H, 45H, 58H, 20H, 65H, 6EH, 63H, 6FH       ; 0A08 _ REX enco
        db 64H, 69H, 6EH, 67H, 20H, 6EH, 6FH, 74H       ; 0A10 _ ding not
        db 20H, 73H, 75H, 70H, 70H, 6FH, 72H, 74H       ; 0A18 _  support
        db 65H, 64H, 20H, 69H, 6EH, 20H, 25H, 64H       ; 0A20 _ ed in %d
        db 2DH, 62H, 69H, 74H, 20H, 6DH, 6FH, 64H       ; 0A28 _ -bit mod
        db 65H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0A30 _ e.......

?_1080:                                                 ; byte
        db 52H, 45H, 58H, 32H, 20H, 65H, 6EH, 63H       ; 0A38 _ REX2 enc
        db 6FH, 64H, 69H, 6EH, 67H, 20H, 6EH, 6FH       ; 0A40 _ oding no
        db 74H, 20H, 73H, 75H, 70H, 70H, 6FH, 72H       ; 0A48 _ t suppor
        db 74H, 65H, 64H, 20H, 69H, 6EH, 20H, 25H       ; 0A50 _ ted in %
        db 64H, 2DH, 62H, 69H, 74H, 20H, 6DH, 6FH       ; 0A58 _ d-bit mo
        db 64H, 65H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0A60 _ de......

?_1081:                                                 ; byte
        db 63H, 61H, 6EH, 6EH, 6FH, 74H, 20H, 75H       ; 0A68 _ cannot u
        db 73H, 65H, 20H, 68H, 69H, 67H, 68H, 20H       ; 0A70 _ se high 
        db 62H, 79H, 74H, 65H, 20H, 72H, 65H, 67H       ; 0A78 _ byte reg
        db 69H, 73H, 74H, 65H, 72H, 20H, 69H, 6EH       ; 0A80 _ ister in
        db 20H, 74H, 68H, 69H, 73H, 20H, 69H, 6EH       ; 0A88 _  this in
        db 73H, 74H, 72H, 75H, 63H, 74H, 69H, 6FH       ; 0A90 _ structio
        db 6EH, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0A98 _ n.......

?_1082:                                                 ; byte
        db 69H, 6EH, 76H, 61H, 6CH, 69H, 64H, 20H       ; 0AA0 _ invalid 
        db 6FH, 70H, 65H, 72H, 61H, 6EH, 64H, 73H       ; 0AA8 _ operands
        db 20H, 69H, 6EH, 20H, 6EH, 6FH, 6EH, 2DH       ; 0AB0 _  in non-
        db 36H, 34H, 2DH, 62H, 69H, 74H, 20H, 6DH       ; 0AB8 _ 64-bit m
        db 6FH, 64H, 65H, 00H, 00H, 00H, 00H, 00H       ; 0AC0 _ ode.....

?_1083:                                                 ; byte
        db 69H, 6EH, 76H, 61H, 6CH, 69H, 64H, 20H       ; 0AC8 _ invalid 
        db 68H, 69H, 67H, 68H, 2DH, 31H, 36H, 20H       ; 0AD0 _ high-16 
        db 72H, 65H, 67H, 69H, 73H, 74H, 65H, 72H       ; 0AD8 _ register
        db 20H, 69H, 6EH, 20H, 56H, 45H, 58H, 20H       ; 0AE0 _  in VEX 
        db 65H, 6EH, 63H, 6FH, 64H, 65H, 64H, 20H       ; 0AE8 _ encoded 
        db 69H, 6EH, 73H, 74H, 72H, 75H, 63H, 74H       ; 0AF0 _ instruct
        db 69H, 6FH, 6EH, 00H, 00H, 00H, 00H, 00H       ; 0AF8 _ ion.....

?_1084:                                                 ; byte
        db 69H, 6EH, 73H, 74H, 72H, 75H, 63H, 74H       ; 0B00 _ instruct
        db 69H, 6FH, 6EH, 20H, 6EH, 6FH, 74H, 20H       ; 0B08 _ ion not 
        db 65H, 6EH, 63H, 6FH, 64H, 61H, 62H, 6CH       ; 0B10 _ encodabl
        db 65H, 20H, 77H, 69H, 74H, 68H, 20H, 7BH       ; 0B18 _ e with {
        db 76H, 65H, 78H, 32H, 7DH, 20H, 70H, 72H       ; 0B20 _ vex2} pr
        db 65H, 66H, 69H, 78H, 00H, 00H, 00H, 00H       ; 0B28 _ efix....

?_1085:                                                 ; byte
        db 69H, 6EH, 76H, 61H, 6CH, 69H, 64H, 20H       ; 0B30 _ invalid 
        db 6FH, 70H, 65H, 72H, 61H, 6EH, 64H, 73H       ; 0B38 _ operands
        db 20H, 69H, 6EH, 20H, 25H, 64H, 2DH, 62H       ; 0B40 _  in %d-b
        db 69H, 74H, 20H, 6DH, 6FH, 64H, 65H, 00H       ; 0B48 _ it mode.

?_1086:                                                 ; byte
        db 69H, 6EH, 76H, 61H, 6CH, 69H, 64H, 20H       ; 0B50 _ invalid 
        db 6FH, 70H, 65H, 72H, 61H, 6EH, 64H, 73H       ; 0B58 _ operands
        db 20H, 69H, 6EH, 20H, 6EH, 6FH, 6EH, 2DH       ; 0B60 _  in non-
        db 41H, 50H, 58H, 20H, 6DH, 6FH, 64H, 65H       ; 0B68 _ APX mode
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0B70 _ ........

?_1087:                                                 ; byte
        db 74H, 68H, 69H, 73H, 20H, 75H, 73H, 65H       ; 0B78 _ this use
        db 20H, 6FH, 66H, 20H, 72H, 65H, 67H, 69H       ; 0B80 _  of regi
        db 73H, 74H, 65H, 72H, 73H, 20H, 31H, 36H       ; 0B88 _ sters 16
        db 2DH, 33H, 31H, 20H, 6EH, 6FH, 74H, 20H       ; 0B90 _ -31 not 
        db 73H, 75H, 70H, 70H, 6FH, 72H, 74H, 65H       ; 0B98 _ supporte
        db 64H, 20H, 66H, 6FH, 72H, 20H, 74H, 68H       ; 0BA0 _ d for th
        db 69H, 73H, 20H, 69H, 6EH, 73H, 74H, 72H       ; 0BA8 _ is instr
        db 75H, 63H, 74H, 69H, 6FH, 6EH, 00H            ; 0BB0 _ uction.

?_1088:                                                 ; byte
        db 69H, 6EH, 73H, 74H, 72H, 75H, 63H, 74H       ; 0BB7 _ instruct
        db 69H, 6FH, 6EH, 20H, 69H, 73H, 20H, 6EH       ; 0BBF _ ion is n
        db 6FH, 74H, 20H, 6CH, 6FH, 63H, 6BH, 61H       ; 0BC7 _ ot locka
        db 62H, 6CH, 65H, 00H, 00H, 00H, 00H, 00H       ; 0BCF _ ble.....
        db 00H                                          ; 0BD7 _ .

?_1089:                                                 ; byte
        db 73H, 75H, 70H, 65H, 72H, 66H, 6CH, 75H       ; 0BD8 _ superflu
        db 6FH, 75H, 73H, 20H, 4CH, 4FH, 43H, 4BH       ; 0BE0 _ ous LOCK
        db 20H, 70H, 72H, 65H, 66H, 69H, 78H, 20H       ; 0BE8 _  prefix 
        db 6FH, 6EH, 20H, 58H, 43H, 48H, 47H, 20H       ; 0BF0 _ on XCHG 
        db 69H, 6EH, 73H, 74H, 72H, 75H, 63H, 74H       ; 0BF8 _ instruct
        db 69H, 6FH, 6EH, 00H, 00H, 00H, 00H, 00H       ; 0C00 _ ion.....

?_1090:                                                 ; byte
        db 69H, 6EH, 76H, 61H, 6CH, 69H, 64H, 20H       ; 0C08 _ invalid 
        db 62H, 72H, 61H, 6EH, 63H, 68H, 20H, 68H       ; 0C10 _ branch h
        db 69H, 6EH, 74H, 20H, 70H, 72H, 65H, 66H       ; 0C18 _ int pref
        db 69H, 78H, 20H, 64H, 72H, 6FH, 70H, 70H       ; 0C20 _ ix dropp
        db 65H, 64H, 00H                                ; 0C28 _ ed.

?_1091:                                                 ; byte
        db 21H, 28H, 72H, 65H, 78H, 20H, 26H, 20H       ; 0C2B _ !(rex & 
        db 7EH, 52H, 45H, 58H, 5FH, 4CH, 29H, 00H       ; 0C33 _ ~REX_L).
        db 00H, 00H, 00H, 00H, 00H                      ; 0C3B _ .....

?_1092:                                                 ; byte
        db 69H, 6EH, 76H, 61H, 6CH, 69H, 64H, 20H       ; 0C40 _ invalid 
        db 70H, 72H, 65H, 66H, 69H, 78H, 20H, 25H       ; 0C48 _ prefix %
        db 73H, 20H, 66H, 6FH, 72H, 20H, 69H, 6EH       ; 0C50 _ s for in
        db 73H, 74H, 72H, 75H, 63H, 74H, 69H, 6FH       ; 0C58 _ structio
        db 6EH, 2CH, 20H, 72H, 65H, 73H, 75H, 6CH       ; 0C60 _ n, resul
        db 74H, 20H, 6DH, 61H, 79H, 20H, 62H, 65H       ; 0C68 _ t may be
        db 20H, 75H, 6EH, 65H, 78H, 70H, 65H, 63H       ; 0C70 _  unexpec
        db 74H, 65H, 64H, 00H, 00H, 00H, 00H, 00H       ; 0C78 _ ted.....

?_1093:                                                 ; byte
        db 25H, 73H, 20H, 73H, 65H, 67H, 6DH, 65H       ; 0C80 _ %s segme
        db 6EH, 74H, 20H, 6FH, 76H, 65H, 72H, 72H       ; 0C88 _ nt overr
        db 69H, 64H, 65H, 20H, 77H, 69H, 6CH, 6CH       ; 0C90 _ ide will
        db 20H, 62H, 65H, 20H, 69H, 67H, 6EH, 6FH       ; 0C98 _  be igno
        db 72H, 65H, 64H, 20H, 69H, 6EH, 20H, 36H       ; 0CA0 _ red in 6
        db 34H, 2DH, 62H, 69H, 74H, 20H, 6DH, 6FH       ; 0CA8 _ 4-bit mo
        db 64H, 65H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0CB0 _ de......

?_1094:                                                 ; byte
        db 31H, 36H, 2DH, 62H, 69H, 74H, 20H, 61H       ; 0CB8 _ 16-bit a
        db 64H, 64H, 72H, 65H, 73H, 73H, 69H, 6EH       ; 0CC0 _ ddressin
        db 67H, 20H, 69H, 73H, 20H, 6EH, 6FH, 74H       ; 0CC8 _ g is not
        db 20H, 73H, 75H, 70H, 70H, 6FH, 72H, 74H       ; 0CD0 _  support
        db 65H, 64H, 20H, 69H, 6EH, 20H, 36H, 34H       ; 0CD8 _ ed in 64
        db 2DH, 62H, 69H, 74H, 20H, 6DH, 6FH, 64H       ; 0CE0 _ -bit mod
        db 65H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0CE8 _ e.......

?_1095:                                                 ; byte
        db 36H, 34H, 2DH, 62H, 69H, 74H, 20H, 61H       ; 0CF0 _ 64-bit a
        db 64H, 64H, 72H, 65H, 73H, 73H, 69H, 6EH       ; 0CF8 _ ddressin
        db 67H, 20H, 69H, 73H, 20H, 6FH, 6EH, 6CH       ; 0D00 _ g is onl
        db 79H, 20H, 73H, 75H, 70H, 70H, 6FH, 72H       ; 0D08 _ y suppor
        db 74H, 65H, 64H, 20H, 69H, 6EH, 20H, 36H       ; 0D10 _ ted in 6
        db 34H, 2DH, 62H, 69H, 74H, 20H, 6DH, 6FH       ; 0D18 _ 4-bit mo
        db 64H, 65H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0D20 _ de......

?_1096:                                                 ; byte
        db 36H, 34H, 2DH, 62H, 69H, 74H, 20H, 6FH       ; 0D28 _ 64-bit o
        db 70H, 65H, 72H, 61H, 6EH, 64H, 20H, 73H       ; 0D30 _ perand s
        db 69H, 7AH, 65H, 20H, 69H, 73H, 20H, 6FH       ; 0D38 _ ize is o
        db 6EH, 6CH, 79H, 20H, 73H, 75H, 70H, 70H       ; 0D40 _ nly supp
        db 6FH, 72H, 74H, 65H, 64H, 20H, 69H, 6EH       ; 0D48 _ orted in
        db 20H, 36H, 34H, 2DH, 62H, 69H, 74H, 20H       ; 0D50 _  64-bit 
        db 6DH, 6FH, 64H, 65H, 00H                      ; 0D58 _ mode.

?_1097:                                                 ; byte
        db 69H, 6EH, 76H, 61H, 6CH, 69H, 64H, 20H       ; 0D5D _ invalid 
        db 75H, 73H, 65H, 20H, 6FH, 66H, 20H, 25H       ; 0D65 _ use of %
        db 73H, 20H, 70H, 72H, 65H, 66H, 69H, 78H       ; 0D6D _ s prefix
        db 00H                                          ; 0D75 _ .

?_1098:                                                 ; byte
        db 25H, 73H, 20H, 63H, 61H, 6EH, 6EH, 6FH       ; 0D76 _ %s canno
        db 74H, 20H, 62H, 65H, 20H, 75H, 73H, 65H       ; 0D7E _ t be use
        db 64H, 20H, 61H, 73H, 20H, 61H, 20H, 70H       ; 0D86 _ d as a p
        db 72H, 65H, 66H, 69H, 78H, 00H                 ; 0D8E _ refix.

?_1099:                                                 ; byte
        db 73H, 68H, 6FH, 72H, 74H, 20H, 6AH, 75H       ; 0D94 _ short ju
        db 6DH, 70H, 20H, 69H, 73H, 20H, 6FH, 75H       ; 0D9C _ mp is ou
        db 74H, 20H, 6FH, 66H, 20H, 72H, 61H, 6EH       ; 0DA4 _ t of ran
        db 67H, 65H, 00H, 00H                           ; 0DAC _ ge..

?_1100:                                                 ; byte
        db 76H, 61H, 6CH, 75H, 65H, 20H, 72H, 65H       ; 0DB0 _ value re
        db 66H, 65H, 72H, 65H, 6EH, 63H, 65H, 64H       ; 0DB8 _ ferenced
        db 20H, 62H, 79H, 20H, 46H, 41H, 52H, 20H       ; 0DC0 _  by FAR 
        db 69H, 73H, 20H, 6EH, 6FH, 74H, 20H, 72H       ; 0DC8 _ is not r
        db 65H, 6CH, 6FH, 63H, 61H, 74H, 61H, 62H       ; 0DD0 _ elocatab
        db 6CH, 65H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0DD8 _ le......

?_1101:                                                 ; byte
        db 6EH, 6FH, 6EH, 2DH, 61H, 62H, 73H, 6FH       ; 0DE0 _ non-abso
        db 6CH, 75H, 74H, 65H, 20H, 65H, 78H, 70H       ; 0DE8 _ lute exp
        db 72H, 65H, 73H, 73H, 69H, 6FH, 6EH, 20H       ; 0DF0 _ ression 
        db 6EH, 6FH, 74H, 20H, 70H, 65H, 72H, 6DH       ; 0DF8 _ not perm
        db 69H, 74H, 74H, 65H, 64H, 20H, 61H, 73H       ; 0E00 _ itted as
        db 20H, 61H, 72H, 67H, 75H, 6DH, 65H, 6EH       ; 0E08 _  argumen
        db 74H, 20H, 25H, 64H, 00H                      ; 0E10 _ t %d.

?_1102:                                                 ; byte
        db 69H, 73H, 34H, 20H, 61H, 72H, 67H, 75H       ; 0E15 _ is4 argu
        db 6DH, 65H, 6EH, 74H, 20H, 65H, 78H, 63H       ; 0E1D _ ment exc
        db 65H, 65H, 64H, 73H, 20H, 62H, 6FH, 75H       ; 0E25 _ eeds bou
        db 6EH, 64H, 73H, 00H, 00H, 00H, 00H, 00H       ; 0E2D _ nds.....
        db 00H, 00H, 00H                                ; 0E35 _ ...

?_1103:                                                 ; byte
        db 74H, 68H, 69H, 73H, 20H, 69H, 6EH, 73H       ; 0E38 _ this ins
        db 74H, 72H, 75H, 63H, 74H, 69H, 6FH, 6EH       ; 0E40 _ truction
        db 20H, 64H, 6FH, 65H, 73H, 6EH, 27H, 74H       ; 0E48 _  doesn't
        db 20H, 61H, 6CH, 6CH, 6FH, 77H, 20H, 7BH       ; 0E50 _  allow {
        db 6EH, 66H, 7DH, 00H                           ; 0E58 _ nf}.

?_1104:                                                 ; byte
        db 73H, 69H, 67H, 6EH, 65H, 64H, 20H, 64H       ; 0E5C _ signed d
        db 77H, 6FH, 72H, 64H, 00H                      ; 0E64 _ word.

?_1105:                                                 ; byte
        db 73H, 69H, 67H, 6EH, 65H, 64H, 20H, 62H       ; 0E69 _ signed b
        db 79H, 74H, 65H, 00H                           ; 0E71 _ yte.

?_1106:                                                 ; byte
        db 25H, 73H, 20H, 65H, 78H, 63H, 65H, 65H       ; 0E75 _ %s excee
        db 64H, 73H, 20H, 62H, 6FH, 75H, 6EH, 64H       ; 0E7D _ ds bound
        db 73H, 00H, 00H                                ; 0E85 _ s..

?_1107:                                                 ; byte
        db 6EH, 6FH, 74H, 20H, 61H, 20H, 76H, 61H       ; 0E88 _ not a va
        db 6CH, 69H, 64H, 20H, 68H, 69H, 6EH, 74H       ; 0E90 _ lid hint
        db 2DH, 4EH, 4FH, 50H, 20H, 6FH, 70H, 63H       ; 0E98 _ -NOP opc
        db 6FH, 64H, 65H, 20H, 28H, 30H, 44H, 2CH       ; 0EA0 _ ode (0D,
        db 20H, 31H, 38H, 2DH, 31H, 46H, 29H, 00H       ; 0EA8 _  18-1F).

?_1108:                                                 ; byte
        db 74H, 79H, 70H, 65H, 20H, 3CH, 3DH, 20H       ; 0EB0 _ type <= 
        db 32H, 00H                                     ; 0EB8 _ 2.

?_1109:                                                 ; byte
        db 61H, 62H, 73H, 6FH, 6CH, 75H, 74H, 65H       ; 0EBA _ absolute
        db 5FH, 6FH, 70H, 28H, 6FH, 70H, 78H, 29H       ; 0EC2 _ _op(opx)
        db 00H, 00H, 00H, 00H, 00H, 00H                 ; 0ECA _ ......

?_1110:                                                 ; byte
        db 6EH, 6FH, 6EH, 2DH, 63H, 6FH, 6EH, 73H       ; 0ED0 _ non-cons
        db 74H, 61H, 6EH, 74H, 20H, 42H, 53H, 53H       ; 0ED8 _ tant BSS
        db 20H, 73H, 69H, 7AH, 65H, 20H, 69H, 6EH       ; 0EE0 _  size in
        db 20H, 70H, 61H, 73H, 73H, 20H, 74H, 77H       ; 0EE8 _  pass tw
        db 6FH, 00H                                     ; 0EF0 _ o.

?_1111:                                                 ; byte
        db 64H, 69H, 73H, 70H, 6CH, 61H, 63H, 65H       ; 0EF2 _ displace
        db 6DH, 65H, 6EH, 74H, 00H, 00H                 ; 0EFA _ ment..

?_1112:                                                 ; byte
        db 69H, 6EH, 76H, 61H, 6CH, 69H, 64H, 20H       ; 0F00 _ invalid 
        db 6FH, 70H, 65H, 72H, 61H, 6EH, 64H, 20H       ; 0F08 _ operand 
        db 70H, 61H, 73H, 73H, 65H, 64H, 20H, 74H       ; 0F10 _ passed t
        db 6FH, 20H, 72H, 65H, 67H, 66H, 6CH, 61H       ; 0F18 _ o regfla
        db 67H, 28H, 29H, 00H, 00H, 00H, 00H, 00H       ; 0F20 _ g().....

?_1113:                                                 ; byte
        db 69H, 6EH, 76H, 61H, 6CH, 69H, 64H, 20H       ; 0F28 _ invalid 
        db 6FH, 70H, 65H, 72H, 61H, 6EH, 64H, 20H       ; 0F30 _ operand 
        db 70H, 61H, 73H, 73H, 65H, 64H, 20H, 74H       ; 0F38 _ passed t
        db 6FH, 20H, 72H, 65H, 67H, 76H, 61H, 6CH       ; 0F40 _ o regval
        db 28H, 29H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0F48 _ ()......

?_1114:                                                 ; byte
        db 69H, 6EH, 76H, 61H, 6CH, 69H, 64H, 20H       ; 0F50 _ invalid 
        db 6FH, 70H, 65H, 72H, 61H, 6EH, 64H, 20H       ; 0F58 _ operand 
        db 70H, 61H, 73H, 73H, 65H, 64H, 20H, 74H       ; 0F60 _ passed t
        db 6FH, 20H, 6FH, 70H, 5FH, 72H, 65H, 78H       ; 0F68 _ o op_rex
        db 66H, 6CH, 61H, 67H, 73H, 28H, 29H, 00H       ; 0F70 _ flags().

?_1115:                                                 ; byte
        db 73H, 69H, 7AH, 65H, 20H, 6FH, 66H, 20H       ; 0F78 _ size of 
        db 62H, 72H, 6FH, 61H, 64H, 63H, 61H, 73H       ; 0F80 _ broadcas
        db 74H, 69H, 6EH, 67H, 20H, 65H, 6CH, 65H       ; 0F88 _ ting ele
        db 6DH, 65H, 6EH, 74H, 20H, 69H, 73H, 20H       ; 0F90 _ ment is 
        db 67H, 72H, 65H, 61H, 74H, 65H, 72H, 20H       ; 0F98 _ greater 
        db 74H, 68H, 61H, 6EH, 20H, 36H, 34H, 20H       ; 0FA0 _ than 64 
        db 62H, 69H, 74H, 73H, 00H, 00H, 00H, 00H       ; 0FA8 _ bits....

?_1116:                                                 ; byte
        db 62H, 72H, 6FH, 61H, 64H, 63H, 61H, 73H       ; 0FB0 _ broadcas
        db 74H, 20H, 6EH, 6FH, 74H, 20H, 61H, 6CH       ; 0FB8 _ t not al
        db 6CH, 6FH, 77H, 65H, 64H, 20H, 77H, 69H       ; 0FC0 _ lowed wi
        db 74H, 68H, 20H, 72H, 65H, 67H, 69H, 73H       ; 0FC8 _ th regis
        db 74H, 65H, 72H, 20H, 6FH, 70H, 65H, 72H       ; 0FD0 _ ter oper
        db 61H, 6EH, 64H, 00H, 00H, 00H, 00H, 00H       ; 0FD8 _ and.....

?_1117:                                                 ; byte
        db 65H, 6DH, 62H, 65H, 64H, 64H, 65H, 64H       ; 0FE0 _ embedded
        db 20H, 72H, 6FH, 75H, 6EH, 64H, 69H, 6EH       ; 0FE8 _  roundin
        db 67H, 20H, 69H, 73H, 20H, 61H, 76H, 61H       ; 0FF0 _ g is ava
        db 69H, 6CH, 61H, 62H, 6CH, 65H, 20H, 6FH       ; 0FF8 _ ilable o
        db 6EH, 6CH, 79H, 20H, 77H, 69H, 74H, 68H       ; 1000 _ nly with
        db 20H, 72H, 65H, 67H, 69H, 73H, 74H, 65H       ; 1008 _  registe
        db 72H, 2DH, 72H, 65H, 67H, 69H, 73H, 74H       ; 1010 _ r-regist
        db 65H, 72H, 20H, 6FH, 70H, 65H, 72H, 61H       ; 1018 _ er opera
        db 74H, 69H, 6FH, 6EH, 73H, 00H, 00H, 00H       ; 1020 _ tions...

?_1118:                                                 ; byte
        db 61H, 62H, 73H, 6FH, 6CH, 75H, 74H, 65H       ; 1028 _ absolute
        db 20H, 61H, 64H, 64H, 72H, 65H, 73H, 73H       ; 1030 _  address
        db 20H, 63H, 61H, 6EH, 20H, 6EH, 6FH, 74H       ; 1038 _  can not
        db 20H, 62H, 65H, 20H, 52H, 49H, 50H, 2DH       ; 1040 _  be RIP-
        db 72H, 65H, 6CH, 61H, 74H, 69H, 76H, 65H       ; 1048 _ relative
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 1050 _ ........

?_1119:                                                 ; byte
        db 69H, 6EH, 73H, 74H, 72H, 75H, 63H, 74H       ; 1058 _ instruct
        db 69H, 6FH, 6EH, 20H, 72H, 65H, 71H, 75H       ; 1060 _ ion requ
        db 69H, 72H, 65H, 73H, 20H, 53H, 49H, 42H       ; 1068 _ ires SIB
        db 20H, 65H, 6EH, 63H, 6FH, 64H, 69H, 6EH       ; 1070 _  encodin
        db 67H, 2CH, 20H, 63H, 61H, 6EH, 6EH, 6FH       ; 1078 _ g, canno
        db 74H, 20H, 62H, 65H, 20H, 52H, 49H, 50H       ; 1080 _ t be RIP
        db 2DH, 72H, 65H, 6CH, 61H, 74H, 69H, 76H       ; 1088 _ -relativ
        db 65H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 1090 _ e.......

?_1120:                                                 ; byte
        db 64H, 69H, 73H, 70H, 6CH, 61H, 63H, 65H       ; 1098 _ displace
        db 6DH, 65H, 6EH, 74H, 20H, 73H, 69H, 7AH       ; 10A0 _ ment siz
        db 65H, 20H, 69H, 67H, 6EH, 6FH, 72H, 65H       ; 10A8 _ e ignore
        db 64H, 20H, 6FH, 6EH, 20H, 61H, 62H, 73H       ; 10B0 _ d on abs
        db 6FH, 6CH, 75H, 74H, 65H, 20H, 61H, 64H       ; 10B8 _ olute ad
        db 64H, 72H, 65H, 73H, 73H, 00H, 00H, 00H       ; 10C0 _ dress...

?_1121:                                                 ; byte
        db 69H, 6EH, 64H, 69H, 72H, 65H, 63H, 74H       ; 10C8 _ indirect
        db 20H, 61H, 64H, 64H, 72H, 65H, 73H, 73H       ; 10D0 _  address
        db 20H, 64H, 69H, 73H, 70H, 6CH, 61H, 63H       ; 10D8 _  displac
        db 65H, 6DH, 65H, 6EH, 74H, 73H, 20H, 63H       ; 10E0 _ ements c
        db 61H, 6EH, 6EH, 6FH, 74H, 20H, 62H, 65H       ; 10E8 _ annot be
        db 20H, 52H, 49H, 50H, 2DH, 72H, 65H, 6CH       ; 10F0 _  RIP-rel
        db 61H, 74H, 69H, 76H, 65H, 00H, 00H, 00H       ; 10F8 _ ative...

?_1122:                                                 ; byte
        db 69H, 6EH, 76H, 61H, 6CH, 69H, 64H, 20H       ; 1100 _ invalid 
        db 25H, 64H, 2DH, 62H, 69H, 74H, 20H, 65H       ; 1108 _ %d-bit e
        db 66H, 66H, 65H, 63H, 74H, 69H, 76H, 65H       ; 1110 _ ffective
        db 20H, 61H, 64H, 64H, 72H, 65H, 73H, 73H       ; 1118 _  address
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 1120 _ ........

?_1123:                                                 ; byte
        db 69H, 6DH, 70H, 6FH, 73H, 73H, 69H, 62H       ; 1128 _ impossib
        db 6CH, 65H, 20H, 63H, 6FH, 6DH, 62H, 69H       ; 1130 _ le combi
        db 6EH, 61H, 74H, 69H, 6FH, 6EH, 20H, 6FH       ; 1138 _ nation o
        db 66H, 20H, 61H, 64H, 64H, 72H, 65H, 73H       ; 1140 _ f addres
        db 73H, 20H, 73H, 69H, 7AH, 65H, 73H, 00H       ; 1148 _ s sizes.

?_1124:                                                 ; byte
        db 6CH, 20H, 3EH, 3DH, 20H, 30H, 00H            ; 1150 _ l >= 0.

?_1125:                                                 ; byte
        db 54H, 49H, 4DH, 45H, 53H, 20H, 76H, 61H       ; 1157 _ TIMES va
        db 6CH, 75H, 65H, 20H, 25H, 64H, 20H, 69H       ; 115F _ lue %d i
        db 73H, 20H, 6EH, 65H, 67H, 61H, 74H, 69H       ; 1167 _ s negati
        db 76H, 65H, 00H, 00H, 00H, 00H, 00H, 00H       ; 116F _ ve......
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 1177 _ ........
        db 00H                                          ; 117F _ .

__func__.11:                                            ; byte
        db 6EH, 61H, 73H, 6DH, 5FH, 6FH, 66H, 6DH       ; 1180 _ nasm_ofm
        db 74H, 5FH, 6FH, 75H, 74H, 70H, 75H, 74H       ; 1188 _ t_output
        db 00H                                          ; 1190 _ .

__func__.10:                                            ; dword
        dd 0074756FH                                    ; 1191 _ 7632239 
        db 00H, 00H, 00H                                ; 1195 _ ...

__func__.8:                                             ; byte
        db 61H, 73H, 73H, 65H, 6DH, 62H, 6CH, 65H       ; 1198 _ assemble
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 11A0 _ ........

__func__.7:                                             ; byte
        db 64H, 65H, 62H, 75H, 67H, 5FH, 73H, 65H       ; 11A8 _ debug_se
        db 74H, 5FH, 74H, 79H, 70H, 65H, 00H, 00H       ; 11B0 _ t_type..
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 11B8 _ ........

warn.6:                                                 ; yword
        db 02H, 00H, 00H, 00H, 02H, 00H, 00H, 00H       ; 11C0 _ ........
        db 00H, 00H, 00H, 00H, 01H, 00H, 00H, 00H       ; 11C8 _ ........
        db 02H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 11D0 _ ........
        db 00H, 00H, 00H, 00H, 01H, 00H, 00H, 00H       ; 11D8 _ ........

__func__.5:                                             ; byte
        db 63H, 61H, 6CH, 63H, 73H, 69H, 7AH, 65H       ; 11E0 _ calcsize
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 11E8 _ ........

__func__.4:                                             ; qword
        dq 0065646F636E6567H                            ; 11F0 _ 0065646F636E6567 

__func__.3:                                             ; byte
        db 65H, 6DH, 69H, 74H, 5FH, 72H, 65H, 78H       ; 11F8 _ emit_rex
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 1200 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 1208 _ ........

__func__.1:                                             ; byte
        db 70H, 72H, 6FH, 63H, 65H, 73H, 73H, 5FH       ; 1210 _ process_
        db 6FH, 6EH, 65H, 5FH, 69H, 6EH, 73H, 6EH       ; 1218 _ one_insn
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 1220 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 1228 _ ........

__func__.0:                                             ; byte
        db 70H, 72H, 6FH, 63H, 65H, 73H, 73H, 5FH       ; 1230 _ process_
        db 74H, 69H, 6DH, 65H, 73H, 5FH, 69H, 6EH       ; 1238 _ times_in
        db 73H, 6EH, 00H                                ; 1240 _ sn.


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
        dd __uint32_identity-$-20H                      ; 0020 _ 00000000 (rel)
        dd 0000000CH, 100E4100H                         ; 0024 _ 12 269369600 
        dd 0D430286H, 070C4706H                         ; 002C _ 222495366 118245126 
        dd 00000008H, 0000001CH                         ; 0034 _ 8 28 
        dd 0000003CH                                    ; 003C _ 60 
        dd __uint32_identity-$-34H                      ; 0040 _ 00000000 (rel)
        dd 0000000EH, 100E4100H                         ; 0044 _ 14 269369600 
        dd 0D430286H, 070C4906H                         ; 004C _ 222495366 118245638 
        dd 00000008H, 0000001CH                         ; 0054 _ 8 28 
        dd 0000005CH                                    ; 005C _ 92 
        dd __uint32_identity-$-46H                      ; 0060 _ 00000000 (rel)
        dd 0000004AH, 100E4100H                         ; 0064 _ 74 269369600 
        dd 0D430286H, 0C450206H                         ; 006C _ 222495366 205849094 
        dd 00000807H, 0000001CH                         ; 0074 _ 2055 28 
        dd 0000007CH                                    ; 007C _ 124 
        dd __uint32_identity-$-1CH                      ; 0080 _ 00000000 (rel)
        dd 00000048H, 100E4100H                         ; 0084 _ 72 269369600 
        dd 0D430286H, 0C430206H                         ; 008C _ 222495366 205718022 
        dd 00000807H, 0000001CH                         ; 0094 _ 2055 28 
        dd 0000009CH                                    ; 009C _ 156 
        dd __uint64_identity-$+0A0H                     ; 00A0 _ 00000000 (rel)
        dd 00000030H, 100E4100H                         ; 00A4 _ 48 269369600 
        dd 0D430286H, 070C6B06H                         ; 00AC _ 222495366 118254342 
        dd 00000008H, 0000001CH                         ; 00B4 _ 8 28 
        dd 000000BCH                                    ; 00BC _ 188 
        dd __uint32_identity-$+1CH                      ; 00C0 _ 00000000 (rel)
        dd 00000030H, 100E4100H                         ; 00C4 _ 48 269369600 
        dd 0D430286H, 070C6B06H                         ; 00CC _ 222495366 118254342 
        dd 00000008H, 0000001CH                         ; 00D4 _ 8 28 
        dd 000000DCH                                    ; 00DC _ 220 
        dd __uint32_identity-$+2CH                      ; 00E0 _ 00000000 (rel)
        dd 00000050H, 100E4100H                         ; 00E4 _ 80 269369600 
        dd 0D430286H, 0C4B0206H                         ; 00EC _ 222495366 206242310 
        dd 00000807H, 0000001CH                         ; 00F4 _ 2055 28 
        dd 000000FCH                                    ; 00FC _ 252 
        dd __uint32_identity-$+5CH                      ; 0100 _ 00000000 (rel)
        dd 0000001FH, 100E4100H                         ; 0104 _ 31 269369600 
        dd 0D430286H, 070C5A06H                         ; 010C _ 222495366 118249990 
        dd 00000008H, 0000001CH                         ; 0114 _ 8 28 
        dd 0000011CH                                    ; 011C _ 284 
        dd __uint32_identity-$+5BH                      ; 0120 _ 00000000 (rel)
        dd 00000027H, 100E4100H                         ; 0124 _ 39 269369600 
        dd 0D430286H, 070C6206H                         ; 012C _ 222495366 118252038 
        dd 00000008H, 0000001CH                         ; 0134 _ 8 28 
        dd 0000013CH                                    ; 013C _ 316 
        dd ?_0004-$+140H                                ; 0140 _ 00000000 (rel)
        dd 00000050H, 100E4100H                         ; 0144 _ 80 269369600 
        dd 0D430286H, 0C4B0206H                         ; 014C _ 222495366 206242310 
        dd 00000807H, 0000001CH                         ; 0154 _ 2055 28 
        dd 0000015CH                                    ; 015C _ 348 
        dd __uint32_identity-$+92H                      ; 0160 _ 00000000 (rel)
        dd 0000004DH, 100E4100H                         ; 0164 _ 77 269369600 
        dd 0D430286H, 0C480206H                         ; 016C _ 222495366 206045702 
        dd 00000807H, 0000001CH                         ; 0174 _ 2055 28 
        dd 0000017CH                                    ; 017C _ 380 
        dd __uint32_identity-$+0BFH                     ; 0180 _ 00000000 (rel)
        dd 00000014H, 100E4100H                         ; 0184 _ 20 269369600 
        dd 0D430286H, 070C4F06H                         ; 018C _ 222495366 118247174 
        dd 00000008H, 0000001CH                         ; 0194 _ 8 28 
        dd 0000019CH                                    ; 019C _ 412 
        dd __uint32_identity-$+0B3H                     ; 01A0 _ 00000000 (rel)
        dd 00000033H, 100E4100H                         ; 01A4 _ 51 269369600 
        dd 0D430286H, 070C6E06H                         ; 01AC _ 222495366 118255110 
        dd 00000008H, 0000001CH                         ; 01B4 _ 8 28 
        dd 000001BCH                                    ; 01BC _ 444 
        dd __uint32_identity-$+0C6H                     ; 01C0 _ 00000000 (rel)
        dd 00000022H, 100E4100H                         ; 01C4 _ 34 269369600 
        dd 0D430286H, 070C5D06H                         ; 01CC _ 222495366 118250758 
        dd 00000008H, 0000001CH                         ; 01D4 _ 8 28 
        dd 000001DCH                                    ; 01DC _ 476 
        dd __uint32_identity-$+0C8H                     ; 01E0 _ 00000000 (rel)
        dd 0000000CH, 100E4100H                         ; 01E4 _ 12 269369600 
        dd 0D430286H, 070C4706H                         ; 01EC _ 222495366 118245126 
        dd 00000008H, 0000001CH                         ; 01F4 _ 8 28 
        dd 000001FCH                                    ; 01FC _ 508 
        dd __uint32_identity-$+0B4H                     ; 0200 _ 00000000 (rel)
        dd 00000011H, 100E4100H                         ; 0204 _ 17 269369600 
        dd 0D430286H, 070C4C06H                         ; 020C _ 222495366 118246406 
        dd 00000008H, 0000001CH                         ; 0214 _ 8 28 
        dd 0000021CH                                    ; 021C _ 540 
        dd __uint32_identity-$+0A5H                     ; 0220 _ 00000000 (rel)
        dd 00000011H, 100E4100H                         ; 0224 _ 17 269369600 
        dd 0D430286H, 070C4C06H                         ; 022C _ 222495366 118246406 
        dd 00000008H, 0000001CH                         ; 0234 _ 8 28 
        dd 0000023CH                                    ; 023C _ 572 
        dd __uint32_identity-$+96H                      ; 0240 _ 00000000 (rel)
        dd 00000028H, 100E4100H                         ; 0244 _ 40 269369600 
        dd 0D430286H, 070C6306H                         ; 024C _ 222495366 118252294 
        dd 00000008H, 0000001CH                         ; 0254 _ 8 28 
        dd 0000025CH                                    ; 025C _ 604 
        dd __uint32_identity-$+9EH                      ; 0260 _ 00000000 (rel)
        dd 00000036H, 100E4100H                         ; 0264 _ 54 269369600 
        dd 0D430286H, 070C7106H                         ; 026C _ 222495366 118255878 
        dd 00000008H, 0000001CH                         ; 0274 _ 8 28 
        dd 0000027CH                                    ; 027C _ 636 
        dd __uint32_identity-$+0B4H                     ; 0280 _ 00000000 (rel)
        dd 00000016H, 100E4100H                         ; 0284 _ 22 269369600 
        dd 0D430286H, 070C5106H                         ; 028C _ 222495366 118247686 
        dd 00000008H, 0000001CH                         ; 0294 _ 8 28 
        dd 0000029CH                                    ; 029C _ 668 
        dd ?_0007-$+2A0H                                ; 02A0 _ 00000000 (rel)
        dd 0000003AH, 100E4100H                         ; 02A4 _ 58 269369600 
        dd 0D430286H, 03834506H                         ; 02AC _ 222495366 58934534 
        dd 08070C70H, 0000001CH                         ; 02B4 _ 134679664 28 
        dd 000002BCH                                    ; 02BC _ 700 
        dd __uint32_identity-$+0C4H                     ; 02C0 _ 00000000 (rel)
        dd 0000002CH, 100E4100H                         ; 02C4 _ 44 269369600 
        dd 0D430286H, 070C6706H                         ; 02CC _ 222495366 118253318 
        dd 00000008H, 0000001CH                         ; 02D4 _ 8 28 
        dd 000002DCH                                    ; 02DC _ 732 
        dd __uint32_identity-$+0D0H                     ; 02E0 _ 00000000 (rel)
        dd 00000035H, 100E4100H                         ; 02E4 _ 53 269369600 
        dd 0D430286H, 070C7006H                         ; 02EC _ 222495366 118255622 
        dd 00000008H, 0000001CH                         ; 02F4 _ 8 28 
        dd 000002FCH                                    ; 02FC _ 764 
        dd __uint32_identity-$+0E5H                     ; 0300 _ 00000000 (rel)
        dd 00000024H, 100E4100H                         ; 0304 _ 36 269369600 
        dd 0D430286H, 070C5F06H                         ; 030C _ 222495366 118251270 
        dd 00000008H, 0000001CH                         ; 0314 _ 8 28 
        dd 0000031CH                                    ; 031C _ 796 
        dd __uint32_identity-$+0E9H                     ; 0320 _ 00000000 (rel)
        dd 00000024H, 100E4100H                         ; 0324 _ 36 269369600 
        dd 0D430286H, 070C5F06H                         ; 032C _ 222495366 118251270 
        dd 00000008H, 0000001CH                         ; 0334 _ 8 28 
        dd 0000033CH                                    ; 033C _ 828 
        dd __uint32_identity-$+0EDH                     ; 0340 _ 00000000 (rel)
        dd 000000B9H, 100E4100H                         ; 0344 _ 185 269369600 
        dd 0D430286H, 0CB40206H                         ; 034C _ 222495366 213123590 
        dd 00000807H, 0000001CH                         ; 0354 _ 2055 28 
        dd 0000035CH                                    ; 035C _ 860 
        dd __uint32_identity-$+186H                     ; 0360 _ 00000000 (rel)
        dd 00000245H, 100E4100H                         ; 0364 _ 581 269369600 
        dd 0D430286H, 02400306H                         ; 036C _ 222495366 37749510 
        dd 0008070CH, 0000001CH                         ; 0374 _ 526092 28 
        dd 0000037CH                                    ; 037C _ 892 
        dd __uint32_identity-$+3ABH                     ; 0380 _ 00000000 (rel)
        dd 0000006DH, 100E4100H                         ; 0384 _ 109 269369600 
        dd 0D430286H, 0C680206H                         ; 038C _ 222495366 208142854 
        dd 00000807H, 0000001CH                         ; 0394 _ 2055 28 
        dd 0000039CH                                    ; 039C _ 924 
        dd __uint32_identity-$+3F8H                     ; 03A0 _ 00000000 (rel)
        dd 00000032H, 100E4100H                         ; 03A4 _ 50 269369600 
        dd 0D430286H, 070C6D06H                         ; 03AC _ 222495366 118254854 
        dd 00000008H, 0000001CH                         ; 03B4 _ 8 28 
        dd 000003BCH                                    ; 03BC _ 956 
        dd __uint32_identity-$+40AH                     ; 03C0 _ 00000000 (rel)
        dd 00000010H, 100E4100H                         ; 03C4 _ 16 269369600 
        dd 0D430286H, 070C4B06H                         ; 03CC _ 222495366 118246150 
        dd 00000008H, 0000001CH                         ; 03D4 _ 8 28 
        dd 000003DCH                                    ; 03DC _ 988 
        dd __uint32_identity-$+3FAH                     ; 03E0 _ 00000000 (rel)
        dd 00000017H, 100E4100H                         ; 03E4 _ 23 269369600 
        dd 0D430286H, 070C5206H                         ; 03EC _ 222495366 118247942 
        dd 00000008H, 0000001CH                         ; 03F4 _ 8 28 
        dd 000003FCH                                    ; 03FC _ 1020 
        dd __uint32_identity-$+3F1H                     ; 0400 _ 00000000 (rel)
        dd 00000043H, 100E4100H                         ; 0404 _ 67 269369600 
        dd 0D430286H, 070C7E06H                         ; 040C _ 222495366 118259206 
        dd 00000008H, 0000001CH                         ; 0414 _ 8 28 
        dd 0000041CH                                    ; 041C _ 1052 
        dd __uint32_identity-$+414H                     ; 0420 _ 00000000 (rel)
        dd 00000043H, 100E4100H                         ; 0424 _ 67 269369600 
        dd 0D430286H, 070C7E06H                         ; 042C _ 222495366 118259206 
        dd 00000008H, 0000001CH                         ; 0434 _ 8 28 
        dd 0000043CH                                    ; 043C _ 1084 
        dd __uint32_identity-$+437H                     ; 0440 _ 00000000 (rel)
        dd 00000046H, 100E4100H                         ; 0444 _ 70 269369600 
        dd 0D430286H, 0C410206H                         ; 044C _ 222495366 205586950 
        dd 00000807H, 0000001CH                         ; 0454 _ 2055 28 
        dd 0000045CH                                    ; 045C _ 1116 
        dd __uint32_identity-$+45DH                     ; 0460 _ 00000000 (rel)
        dd 00000028H, 100E4100H                         ; 0464 _ 40 269369600 
        dd 0D430286H, 070C6306H                         ; 046C _ 222495366 118252294 
        dd 00000008H, 0000001CH                         ; 0474 _ 8 28 
        dd 0000047CH                                    ; 047C _ 1148 
        dd __uint32_identity-$+465H                     ; 0480 _ 00000000 (rel)
        dd 00000060H, 100E4100H                         ; 0484 _ 96 269369600 
        dd 0D430286H, 0C5B0206H                         ; 048C _ 222495366 207290886 
        dd 00000807H, 0000001CH                         ; 0494 _ 2055 28 
        dd 0000049CH                                    ; 049C _ 1180 
        dd __uint32_identity-$+4A5H                     ; 04A0 _ 00000000 (rel)
        dd 000000BAH, 100E4100H                         ; 04A4 _ 186 269369600 
        dd 0D430286H, 0CB50206H                         ; 04AC _ 222495366 213189126 
        dd 00000807H, 0000001CH                         ; 04B4 _ 2055 28 
        dd 000004BCH                                    ; 04BC _ 1212 
        dd __uint32_identity-$+53FH                     ; 04C0 _ 00000000 (rel)
        dd 000000AAH, 100E4100H                         ; 04C4 _ 170 269369600 
        dd 0D430286H, 0CA50206H                         ; 04CC _ 222495366 212140550 
        dd 00000807H, 0000001CH                         ; 04D4 _ 2055 28 
        dd 000004DCH                                    ; 04DC _ 1244 
        dd __uint32_identity-$+5C9H                     ; 04E0 _ 00000000 (rel)
        dd 0000003BH, 100E4100H                         ; 04E4 _ 59 269369600 
        dd 0D430286H, 070C7606H                         ; 04EC _ 222495366 118257158 
        dd 00000008H, 0000001CH                         ; 04F4 _ 8 28 
        dd 000004FCH                                    ; 04FC _ 1276 
        dd __uint32_identity-$+5E4H                     ; 0500 _ 00000000 (rel)
        dd 000000B6H, 100E4100H                         ; 0504 _ 182 269369600 
        dd 0D430286H, 0CB10206H                         ; 050C _ 222495366 212926982 
        dd 00000807H, 0000001CH                         ; 0514 _ 2055 28 
        dd 0000051CH                                    ; 051C _ 1308 
        dd __uint32_identity-$+67AH                     ; 0520 _ 00000000 (rel)
        dd 00000085H, 100E4100H                         ; 0524 _ 133 269369600 
        dd 0D430286H, 0C800206H                         ; 052C _ 222495366 209715718 
        dd 00000807H, 0000001CH                         ; 0534 _ 2055 28 
        dd 0000053CH                                    ; 053C _ 1340 
        dd ?_0044-$+540H                                ; 0540 _ 00000000 (rel)
        dd 00000220H, 100E4100H                         ; 0544 _ 544 269369600 
        dd 0D430286H, 021B0306H                         ; 054C _ 222495366 35324678 
        dd 0008070CH, 00000020H                         ; 0554 _ 526092 32 
        dd 0000055CH                                    ; 055C _ 1372 
        dd __uint32_identity-$+8DFH                     ; 0560 _ 00000000 (rel)
        dd 00000705H, 100E4100H                         ; 0564 _ 1797 269369600 
        dd 0D430286H, 03834506H                         ; 056C _ 222495366 58934534 
        dd 0C06FB03H, 00000807H                         ; 0574 _ 201784067 2055 
        dd 0000001CH, 00000580H                         ; 057C _ 28 1408 
        dd __uint32_identity-$+0FC0H                    ; 0584 _ 00000000 (rel)
        dd 0000004FH, 100E4100H                         ; 0588 _ 79 269369600 
        dd 0D430286H, 0C4A0206H                         ; 0590 _ 222495366 206176774 
        dd 00000807H, 0000001CH                         ; 0598 _ 2055 28 
        dd 000005A0H                                    ; 05A0 _ 1440 
        dd __uint32_identity-$+0FEFH                    ; 05A4 _ 00000000 (rel)
        dd 00000042H, 100E4100H                         ; 05A8 _ 66 269369600 
        dd 0D430286H, 070C7D06H                         ; 05B0 _ 222495366 118258950 
        dd 00000008H, 0000001CH                         ; 05B8 _ 8 28 
        dd 000005C0H                                    ; 05C0 _ 1472 
        dd __uint32_identity-$+1011H                    ; 05C4 _ 00000000 (rel)
        dd 00000071H, 100E4100H                         ; 05C8 _ 113 269369600 
        dd 0D430286H, 0C6C0206H                         ; 05D0 _ 222495366 208404998 
        dd 00000807H, 0000001CH                         ; 05D8 _ 2055 28 
        dd 000005E0H                                    ; 05E0 _ 1504 
        dd __uint32_identity-$+1062H                    ; 05E4 _ 00000000 (rel)
        dd 00000036H, 100E4100H                         ; 05E8 _ 54 269369600 
        dd 0D430286H, 070C7106H                         ; 05F0 _ 222495366 118255878 
        dd 00000008H, 0000001CH                         ; 05F8 _ 8 28 
        dd 00000600H                                    ; 0600 _ 1536 
        dd __uint32_identity-$+1078H                    ; 0604 _ 00000000 (rel)
        dd 0000009DH, 100E4100H                         ; 0608 _ 157 269369600 
        dd 0D430286H, 0C980206H                         ; 0610 _ 222495366 211288582 
        dd 00000807H, 0000001CH                         ; 0618 _ 2055 28 
        dd 00000620H                                    ; 0620 _ 1568 
        dd __uint32_identity-$+10F5H                    ; 0624 _ 00000000 (rel)
        dd 000000DAH, 100E4100H                         ; 0628 _ 218 269369600 
        dd 0D430286H, 0CD50206H                         ; 0630 _ 222495366 215286278 
        dd 00000807H, 0000001CH                         ; 0638 _ 2055 28 
        dd 00000640H                                    ; 0640 _ 1600 
        dd __uint32_identity-$+11AFH                    ; 0644 _ 00000000 (rel)
        dd 000000BCH, 100E4100H                         ; 0648 _ 188 269369600 
        dd 0D430286H, 0CB70206H                         ; 0650 _ 222495366 213320198 
        dd 00000807H, 0000001CH                         ; 0658 _ 2055 28 
        dd 00000660H                                    ; 0660 _ 1632 
        dd __uint32_identity-$+124BH                    ; 0664 _ 00000000 (rel)
        dd 000003AFH, 100E4100H                         ; 0668 _ 943 269369600 
        dd 0D430286H, 03AA0306H                         ; 0670 _ 222495366 61473542 
        dd 0008070CH, 0000001CH                         ; 0678 _ 526092 28 
        dd 00000680H                                    ; 0680 _ 1664 
        dd __uint32_identity-$+15DAH                    ; 0684 _ 00000000 (rel)
        dd 0000017BH, 100E4100H                         ; 0688 _ 379 269369600 
        dd 0D430286H, 01760306H                         ; 0690 _ 222495366 24511238 
        dd 0008070CH, 0000001CH                         ; 0698 _ 526092 28 
        dd 000006A0H                                    ; 06A0 _ 1696 
        dd __uint32_identity-$+1735H                    ; 06A4 _ 00000000 (rel)
        dd 0000009FH, 100E4100H                         ; 06A8 _ 159 269369600 
        dd 0D430286H, 0C9A0206H                         ; 06B0 _ 222495366 211419654 
        dd 00000807H, 0000001CH                         ; 06B8 _ 2055 28 
        dd 000006C0H                                    ; 06C0 _ 1728 
        dd __uint32_identity-$+17B4H                    ; 06C4 _ 00000000 (rel)
        dd 00000035H, 100E4100H                         ; 06C8 _ 53 269369600 
        dd 0D430286H, 070C7006H                         ; 06D0 _ 222495366 118255622 
        dd 00000008H, 0000001CH                         ; 06D8 _ 8 28 
        dd 000006E0H                                    ; 06E0 _ 1760 
        dd __uint32_identity-$+17C9H                    ; 06E4 _ 00000000 (rel)
        dd 000002B9H, 100E4100H                         ; 06E8 _ 697 269369600 
        dd 0D430286H, 02B40306H                         ; 06F0 _ 222495366 45351686 
        dd 0008070CH, 0000001CH                         ; 06F8 _ 526092 28 
        dd 00000700H                                    ; 0700 _ 1792 
        dd __uint32_identity-$+1A62H                    ; 0704 _ 00000000 (rel)
        dd 00000084H, 100E4100H                         ; 0708 _ 132 269369600 
        dd 0D430286H, 0C7F0206H                         ; 0710 _ 222495366 209650182 
        dd 00000807H, 0000001CH                         ; 0718 _ 2055 28 
        dd 00000720H                                    ; 0720 _ 1824 
        dd __uint32_identity-$+1AC6H                    ; 0724 _ 00000000 (rel)
        dd 0000091AH, 100E4100H                         ; 0728 _ 2330 269369600 
        dd 0D430286H, 09150306H                         ; 0730 _ 222495366 152371974 
        dd 0008070CH, 0000001CH                         ; 0738 _ 526092 28 
        dd 00000740H                                    ; 0740 _ 1856 
        dd __uint32_identity-$+23C0H                    ; 0744 _ 00000000 (rel)
        dd 00000156H, 100E4100H                         ; 0748 _ 342 269369600 
        dd 0D430286H, 01510306H                         ; 0750 _ 222495366 22086406 
        dd 0008070CH, 0000001CH                         ; 0758 _ 526092 28 
        dd 00000760H                                    ; 0760 _ 1888 
        dd __uint32_identity-$+24F6H                    ; 0764 _ 00000000 (rel)
        dd 00000045H, 100E4100H                         ; 0768 _ 69 269369600 
        dd 0D430286H, 0C400206H                         ; 0770 _ 222495366 205521414 
        dd 00000807H, 0000001CH                         ; 0778 _ 2055 28 
        dd 00000780H                                    ; 0780 _ 1920 
        dd __uint32_identity-$+251BH                    ; 0784 _ 00000000 (rel)
        dd 000000EAH, 100E4100H                         ; 0788 _ 234 269369600 
        dd 0D430286H, 0CE50206H                         ; 0790 _ 222495366 216334854 
        dd 00000807H, 0000001CH                         ; 0798 _ 2055 28 
        dd 000007A0H                                    ; 07A0 _ 1952 
        dd __uint32_identity-$+25E5H                    ; 07A4 _ 00000000 (rel)
        dd 00000169H, 100E4100H                         ; 07A8 _ 361 269369600 
        dd 0D430286H, 01640306H                         ; 07B0 _ 222495366 23331590 
        dd 0008070CH, 00000020H                         ; 07B8 _ 526092 32 
        dd 000007C0H                                    ; 07C0 _ 1984 
        dd ?_0239-$+7C4H                                ; 07C4 _ 00000000 (rel)
        dd 0000015AH, 100E4100H                         ; 07C8 _ 346 269369600 
        dd 0D430286H, 03834506H                         ; 07D0 _ 222495366 58934534 
        dd 0C015003H, 00000807H                         ; 07D8 _ 201412611 2055 
        dd 0000001CH, 000007E4H                         ; 07E0 _ 28 2020 
        dd __uint32_identity-$+2864H                    ; 07E8 _ 00000000 (rel)
        dd 000001E3H, 100E4100H                         ; 07EC _ 483 269369600 
        dd 0D430286H, 01DE0306H                         ; 07F4 _ 222495366 31326982 
        dd 0008070CH, 0000001CH                         ; 07FC _ 526092 28 
        dd 00000804H                                    ; 0804 _ 2052 
        dd __uint32_identity-$+2A27H                    ; 0808 _ 00000000 (rel)
        dd 0000013EH, 100E4100H                         ; 080C _ 318 269369600 
        dd 0D430286H, 01390306H                         ; 0814 _ 222495366 20513542 
        dd 0008070CH, 0000001CH                         ; 081C _ 526092 28 
        dd 00000824H                                    ; 0824 _ 2084 
        dd __uint32_identity-$+2B45H                    ; 0828 _ 00000000 (rel)
        dd 0000018FH, 100E4100H                         ; 082C _ 399 269369600 
        dd 0D430286H, 018A0306H                         ; 0834 _ 222495366 25821958 
        dd 0008070CH, 0000001CH                         ; 083C _ 526092 28 
        dd 00000844H                                    ; 0844 _ 2116 
        dd __uint32_identity-$+2CB4H                    ; 0848 _ 00000000 (rel)
        dd 000000BFH, 100E4100H                         ; 084C _ 191 269369600 
        dd 0D430286H, 0CBA0206H                         ; 0854 _ 222495366 213516806 
        dd 00000807H, 00000020H                         ; 085C _ 2055 32 
        dd 00000864H                                    ; 0864 _ 2148 
        dd __uint32_identity-$+2D53H                    ; 0868 _ 00000000 (rel)
        dd 000020FBH, 100E4100H                         ; 086C _ 8443 269369600 
        dd 0D430286H, 03834806H                         ; 0874 _ 222495366 58935302 
        dd 0C20EE03H, 00000807H                         ; 087C _ 203484675 2055 
        dd 0000001CH, 00000888H                         ; 0884 _ 28 2184 
        dd __uint32_identity-$+4E2AH                    ; 088C _ 00000000 (rel)
        dd 000001BFH, 100E4100H                         ; 0890 _ 447 269369600 
        dd 0D430286H, 01BA0306H                         ; 0898 _ 222495366 28967686 
        dd 0008070CH, 0000001CH                         ; 08A0 _ 526092 28 
        dd 000008A8H                                    ; 08A8 _ 2216 
        dd __uint32_identity-$+4FC9H                    ; 08AC _ 00000000 (rel)
        dd 00000324H, 100E4100H                         ; 08B0 _ 804 269369600 
        dd 0D430286H, 031F0306H                         ; 08B8 _ 222495366 52364038 
        dd 0008070CH, 0000001CH                         ; 08C0 _ 526092 28 
        dd 000008C8H                                    ; 08C8 _ 2248 
        dd __uint32_identity-$+52CDH                    ; 08CC _ 00000000 (rel)
        dd 0000039FH, 100E4100H                         ; 08D0 _ 927 269369600 
        dd 0D430286H, 039A0306H                         ; 08D8 _ 222495366 60424966 
        dd 0008070CH, 00000020H                         ; 08E0 _ 526092 32 
        dd 000008E8H                                    ; 08E8 _ 2280 
        dd __uint32_identity-$+564CH                    ; 08EC _ 00000000 (rel)
        dd 0000170BH, 100E4100H                         ; 08F0 _ 5899 269369600 
        dd 0D430286H, 03834806H                         ; 08F8 _ 222495366 58935302 
        dd 0C16FE03H, 00000807H                         ; 0900 _ 202833411 2055 
        dd 0000001CH, 0000090CH                         ; 0908 _ 28 2316 
        dd __uint32_identity-$+6D33H                    ; 0910 _ 00000000 (rel)
        dd 00000053H, 100E4100H                         ; 0914 _ 83 269369600 
        dd 0D430286H, 0C4E0206H                         ; 091C _ 222495366 206438918 
        dd 00000807H, 0000001CH                         ; 0924 _ 2055 28 
        dd 0000092CH                                    ; 092C _ 2348 
        dd __uint32_identity-$+6D66H                    ; 0930 _ 00000000 (rel)
        dd 0000006BH, 100E4100H                         ; 0934 _ 107 269369600 
        dd 0D430286H, 0C660206H                         ; 093C _ 222495366 208011782 
        dd 00000807H, 0000001CH                         ; 0944 _ 2055 28 
        dd 0000094CH                                    ; 094C _ 2380 
        dd __uint32_identity-$+6DB1H                    ; 0950 _ 00000000 (rel)
        dd 0000008CH, 100E4100H                         ; 0954 _ 140 269369600 
        dd 0D430286H, 0C870206H                         ; 095C _ 222495366 210174470 
        dd 00000807H, 0000001CH                         ; 0964 _ 2055 28 
        dd 0000096CH                                    ; 096C _ 2412 
        dd __uint32_identity-$+6E1DH                    ; 0970 _ 00000000 (rel)
        dd 000000CCH, 100E4100H                         ; 0974 _ 204 269369600 
        dd 0D430286H, 0CC70206H                         ; 097C _ 222495366 214368774 
        dd 00000807H, 0000001CH                         ; 0984 _ 2055 28 
        dd 0000098CH                                    ; 098C _ 2444 
        dd __uint32_identity-$+6EC9H                    ; 0990 _ 00000000 (rel)
        dd 00000048H, 100E4100H                         ; 0994 _ 72 269369600 
        dd 0D430286H, 0C430206H                         ; 099C _ 222495366 205718022 
        dd 00000807H, 0000001CH                         ; 09A4 _ 2055 28 
        dd 000009ACH                                    ; 09AC _ 2476 
        dd __uint32_identity-$+6EF1H                    ; 09B0 _ 00000000 (rel)
        dd 00000028H, 100E4100H                         ; 09B4 _ 40 269369600 
        dd 0D430286H, 070C6306H                         ; 09BC _ 222495366 118252294 
        dd 00000008H, 0000001CH                         ; 09C4 _ 8 28 
        dd 000009CCH                                    ; 09CC _ 2508 
        dd __uint32_identity-$+6EF9H                    ; 09D0 _ 00000000 (rel)
        dd 0000012DH, 100E4100H                         ; 09D4 _ 301 269369600 
        dd 0D430286H, 01280306H                         ; 09DC _ 222495366 19399430 
        dd 0008070CH, 0000001CH                         ; 09E4 _ 526092 28 
        dd 000009ECH                                    ; 09EC _ 2540 
        dd __uint32_identity-$+7006H                    ; 09F0 _ 00000000 (rel)
        dd 00000081H, 100E4100H                         ; 09F4 _ 129 269369600 
        dd 0D430286H, 0C7C0206H                         ; 09FC _ 222495366 209453574 
        dd 00000807H, 0000001CH                         ; 0A04 _ 2055 28 
        dd 00000A0CH                                    ; 0A0C _ 2572 
        dd __uint32_identity-$+7067H                    ; 0A10 _ 00000000 (rel)
        dd 0000127BH, 100E4100H                         ; 0A14 _ 4731 269369600 
        dd 0D430286H, 12760306H                         ; 0A1C _ 222495366 309723910 
        dd 0008070CH, 00000020H                         ; 0A24 _ 526092 32 
        dd 00000A2CH                                    ; 0A2C _ 2604 
        dd __uint32_identity-$+82C2H                    ; 0A30 _ 00000000 (rel)
        dd 00000120H, 100E4100H                         ; 0A34 _ 288 269369600 
        dd 0D430286H, 03834506H                         ; 0A3C _ 222495366 58934534 
        dd 0C011603H, 00000807H                         ; 0A44 _ 201397763 2055 
        dd 0000001CH, 00000A50H                         ; 0A4C _ 28 2640 
        dd __uint32_identity-$+83BEH                    ; 0A54 _ 00000000 (rel)
        dd 000013C5H, 100E4100H                         ; 0A58 _ 5061 269369600 
        dd 0D430286H, 13C00306H                         ; 0A60 _ 222495366 331350790 
        dd 0008070CH, 0000001CH                         ; 0A68 _ 526092 28 
        dd 00000A70H                                    ; 0A70 _ 2672 
        dd __uint32_identity-$+9763H                    ; 0A74 _ 00000000 (rel)
        dd 000004C6H, 100E4100H                         ; 0A78 _ 1222 269369600 
        dd 0D430286H, 04C10306H                         ; 0A80 _ 222495366 79758086 
        dd 0008070CH, 0000001CH                         ; 0A88 _ 526092 28 
        dd 00000A90H                                    ; 0A90 _ 2704 
        dd __uint32_identity-$+9C09H                    ; 0A94 _ 00000000 (rel)
        dd 0000009FH, 100E4100H                         ; 0A98 _ 159 269369600 
        dd 0D430286H, 0C9A0206H                         ; 0AA0 _ 222495366 211419654 
        dd 00000807H, 0000001CH                         ; 0AA8 _ 2055 28 
        dd 00000AB0H                                    ; 0AB0 _ 2736 
        dd __uint32_identity-$+9C88H                    ; 0AB4 _ 00000000 (rel)
        dd 00000027H, 100E4100H                         ; 0AB8 _ 39 269369600 
        dd 0D430286H, 070C6206H                         ; 0AC0 _ 222495366 118252038 
        dd 00000008H, 0000001CH                         ; 0AC8 _ 8 28 
        dd 00000AD0H                                    ; 0AD0 _ 2768 
        dd __uint32_identity-$+9C8FH                    ; 0AD4 _ 00000000 (rel)
        dd 000000AEH, 100E4100H                         ; 0AD8 _ 174 269369600 
        dd 0D430286H, 0CA90206H                         ; 0AE0 _ 222495366 212402694 
        dd 00000807H, 0000001CH                         ; 0AE8 _ 2055 28 
        dd 00000AF0H                                    ; 0AF0 _ 2800 
        dd __uint32_identity-$+9D1DH                    ; 0AF4 _ 00000000 (rel)
        dd 00000029H, 100E4100H                         ; 0AF8 _ 41 269369600 
        dd 0D430286H, 070C6406H                         ; 0B00 _ 222495366 118252550 
        dd 00000008H, 0000001CH                         ; 0B08 _ 8 28 
        dd 00000B10H                                    ; 0B10 _ 2832 
        dd __uint32_identity-$+9D26H                    ; 0B14 _ 00000000 (rel)
        dd 000000AEH, 100E4100H                         ; 0B18 _ 174 269369600 
        dd 0D430286H, 0CA90206H                         ; 0B20 _ 222495366 212402694 
        dd 00000807H, 0000001CH                         ; 0B28 _ 2055 28 
        dd 00000B30H                                    ; 0B30 _ 2864 
        dd __uint32_identity-$+9DB4H                    ; 0B34 _ 00000000 (rel)
        dd 000002ABH, 100E4100H                         ; 0B38 _ 683 269369600 
        dd 0D430286H, 02A60306H                         ; 0B40 _ 222495366 44434182 
        dd 0008070CH, 00000020H                         ; 0B48 _ 526092 32 
        dd 00000B50H                                    ; 0B50 _ 2896 
        dd __uint32_identity-$+0A03FH                   ; 0B54 _ 00000000 (rel)
        dd 00000081H, 100E4100H                         ; 0B58 _ 129 269369600 
        dd 0D430286H, 0C7C0206H                         ; 0B60 _ 222495366 209453574 
        dd 00000807H, 00000000H                         ; 0B68 _ 2055 0 


