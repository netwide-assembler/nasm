; Disassembly of file: /tmp/tmp.1GI3acqyfx.o
; Wed Sep 23 14:43:26 2026
; Type: ELF64
; Syntax: NASM
; Instruction set: 80386, x64

default rel

global get_boolean_option: function

extern __stack_chk_fail                                 ; near
extern nasm_free                                        ; near
extern reloc_value                                      ; near
extern nasm_nonfatal                                    ; near
extern is_really_simple                                 ; near
extern evaluate                                         ; near
extern _GLOBAL_OFFSET_TABLE_                            ; byte
extern strcasecmp                                       ; near
extern stdscan                                          ; near
extern stdscan_reset                                    ; near
extern nasm_strdup                                      ; near
extern nasm_skip_spaces                                 ; near


SECTION .text   align=1 exec                            ; section number 1, code

get_boolean_option:; Function begin
        push    rbp                                     ; 0000 _ 55
        mov     rbp, rsp                                ; 0001 _ 48: 89. E5
        sub     rsp, 112                                ; 0004 _ 48: 83. EC, 70
        mov     qword [rbp-68H], rdi                    ; 0008 _ 48: 89. 7D, 98
        mov     qword [rbp-70H], rsi                    ; 000C _ 48: 89. 75, 90
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        mov     rax, qword [fs:abs 28H]                 ; 0010 _ 64 48: 8B. 04 25, 00000028
        mov     qword [rbp-8H], rax                     ; 0019 _ 48: 89. 45, F8
        xor     eax, eax                                ; 001D _ 31. C0
        cmp     qword [rbp-68H], 0                      ; 001F _ 48: 83. 7D, 98, 00
        jnz     ?_001                                   ; 0024 _ 75, 0A
        mov     eax, 0                                  ; 0026 _ B8, 00000000
        jmp     ?_011                                   ; 002B _ E9, 00000167

?_001:  mov     rax, qword [rbp-68H]                    ; 0030 _ 48: 8B. 45, 98
        mov     rdi, rax                                ; 0034 _ 48: 89. C7
        call    nasm_skip_spaces                        ; 0037 _ E8, 00000000(PLT r)
        mov     qword [rbp-68H], rax                    ; 003C _ 48: 89. 45, 98
        mov     rax, qword [rbp-68H]                    ; 0040 _ 48: 8B. 45, 98
        mov     rdi, rax                                ; 0044 _ 48: 89. C7
        call    nasm_strdup                             ; 0047 _ E8, 00000000(PLT r)
        mov     qword [rbp-50H], rax                    ; 004C _ 48: 89. 45, B0
        mov     dword [rbp-1CH], -1                     ; 0050 _ C7. 45, E4, FFFFFFFF
        mov     rax, qword [rbp-68H]                    ; 0057 _ 48: 8B. 45, 98
        mov     qword [rbp-28H], rax                    ; 005B _ 48: 89. 45, D8
        mov     rax, qword [rbp-50H]                    ; 005F _ 48: 8B. 45, B0
        mov     rdi, rax                                ; 0063 _ 48: 89. C7
        call    stdscan_reset                           ; 0066 _ E8, 00000000(PLT r)
        lea     rax, [rbp-40H]                          ; 006B _ 48: 8D. 45, C0
        mov     rsi, rax                                ; 006F _ 48: 89. C6
        mov     edi, 0                                  ; 0072 _ BF, 00000000
        call    stdscan                                 ; 0077 _ E8, 00000000(PLT r)
        mov     dword [rbp-5CH], eax                    ; 007C _ 89. 45, A4
        cmp     dword [rbp-5CH], 0                      ; 007F _ 83. 7D, A4, 00
        jz      ?_002                                   ; 0083 _ 74, 0C
        cmp     dword [rbp-5CH], 93                     ; 0085 _ 83. 7D, A4, 5D
        jz      ?_002                                   ; 0089 _ 74, 06
        cmp     dword [rbp-5CH], 44                     ; 008B _ 83. 7D, A4, 2C
        jnz     ?_003                                   ; 008F _ 75, 0C
?_002:  mov     rax, qword [rbp-70H]                    ; 0091 _ 48: 8B. 45, 90
        mov     byte [rax], 1                           ; 0095 _ C6. 00, 01
        jmp     ?_010                                   ; 0098 _ E9, 000000D6

?_003:  cmp     dword [rbp-5CH], 273                    ; 009D _ 81. 7D, A4, 00000111
        jnz     ?_007                                   ; 00A4 _ 75, 52
        mov     qword [rbp-58H], 0                      ; 00A6 _ 48: C7. 45, A8, 00000000
        jmp     ?_006                                   ; 00AE _ EB, 41

?_004:  mov     rax, qword [rbp-58H]                    ; 00B0 _ 48: 8B. 45, A8
        lea     rdx, [rax*8]                            ; 00B4 _ 48: 8D. 14 C5, 00000000
        lea     rax, [rel noyes.0]                      ; 00BC _ 48: 8D. 05, 00000000(rel)
        mov     rdx, qword [rdx+rax]                    ; 00C3 _ 48: 8B. 14 02
        mov     rax, qword [rbp-30H]                    ; 00C7 _ 48: 8B. 45, D0
        mov     rsi, rdx                                ; 00CB _ 48: 89. D6
        mov     rdi, rax                                ; 00CE _ 48: 89. C7
        call    strcasecmp                              ; 00D1 _ E8, 00000000(PLT r)
        test    eax, eax                                ; 00D6 _ 85. C0
        jnz     ?_005                                   ; 00D8 _ 75, 12
        mov     rax, qword [rbp-58H]                    ; 00DA _ 48: 8B. 45, A8
        and     eax, 01H                                ; 00DE _ 83. E0, 01
        mov     rdx, qword [rbp-70H]                    ; 00E1 _ 48: 8B. 55, 90
        mov     byte [rdx], al                          ; 00E5 _ 88. 02
        jmp     ?_010                                   ; 00E7 _ E9, 00000087

?_005:  add     qword [rbp-58H], 1                      ; 00EC _ 48: 83. 45, A8, 01
?_006:  cmp     qword [rbp-58H], 5                      ; 00F1 _ 48: 83. 7D, A8, 05
        jbe     ?_004                                   ; 00F6 _ 76, B8
?_007:  lea     rax, [rbp-40H]                          ; 00F8 _ 48: 8D. 45, C0
; Note: Unusual relocation type for this operand
        mov     rdx, qword [rel stdscan+$+??]           ; 00FC _ 48: 8B. 15, 00000000
        mov     rdi, rdx                                ; 0103 _ 48: 89. D7
        mov     r9d, 0                                  ; 0106 _ 41: B9, 00000000
        mov     r8d, 1                                  ; 010C _ 41: B8, 00000001
        mov     ecx, 0                                  ; 0112 _ B9, 00000000
        mov     rdx, rax                                ; 0117 _ 48: 89. C2
        mov     esi, 0                                  ; 011A _ BE, 00000000
        call    evaluate                                ; 011F _ E8, 00000000(PLT r)
        mov     qword [rbp-48H], rax                    ; 0124 _ 48: 89. 45, B8
        cmp     qword [rbp-48H], 0                      ; 0128 _ 48: 83. 7D, B8, 00
        jz      ?_009                                   ; 012D _ 74, 43
        mov     rax, qword [rbp-48H]                    ; 012F _ 48: 8B. 45, B8
        mov     rdi, rax                                ; 0133 _ 48: 89. C7
        call    is_really_simple                        ; 0136 _ E8, 00000000(PLT r)
        xor     eax, 01H                                ; 013B _ 83. F0, 01
        test    al, al                                  ; 013E _ 84. C0
        jz      ?_008                                   ; 0140 _ 74, 16
        lea     rax, [rel ?_013]                        ; 0142 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 0149 _ 48: 89. C7
        mov     eax, 0                                  ; 014C _ B8, 00000000
        call    nasm_nonfatal                           ; 0151 _ E8, 00000000(PLT r)
        jmp     ?_010                                   ; 0156 _ EB, 1B

?_008:  mov     rax, qword [rbp-48H]                    ; 0158 _ 48: 8B. 45, B8
        mov     rdi, rax                                ; 015C _ 48: 89. C7
        call    reloc_value                             ; 015F _ E8, 00000000(PLT r)
        test    rax, rax                                ; 0164 _ 48: 85. C0
        setne   dl                                      ; 0167 _ 0F 95. C2
        mov     rax, qword [rbp-70H]                    ; 016A _ 48: 8B. 45, 90
        mov     byte [rax], dl                          ; 016E _ 88. 10
        jmp     ?_010                                   ; 0170 _ EB, 01

?_009:  nop                                             ; 0172 _ 90
?_010:  mov     rax, qword [rbp-28H]                    ; 0173 _ 48: 8B. 45, D8
        mov     rdi, rax                                ; 0177 _ 48: 89. C7
        call    nasm_skip_spaces                        ; 017A _ E8, 00000000(PLT r)
        sub     rax, qword [rbp-50H]                    ; 017F _ 48: 2B. 45, B0
        add     qword [rbp-68H], rax                    ; 0183 _ 48: 01. 45, 98
        mov     rax, qword [rbp-50H]                    ; 0187 _ 48: 8B. 45, B0
        mov     rdi, rax                                ; 018B _ 48: 89. C7
        call    nasm_free                               ; 018E _ E8, 00000000(PLT r)
        mov     rax, qword [rbp-68H]                    ; 0193 _ 48: 8B. 45, 98
?_011:  mov     rdx, qword [rbp-8H]                     ; 0197 _ 48: 8B. 55, F8
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        sub     rdx, qword [fs:abs 28H]                 ; 019B _ 64 48: 2B. 14 25, 00000028
        jz      ?_012                                   ; 01A4 _ 74, 05
        call    __stack_chk_fail                        ; 01A6 _ E8, 00000000(PLT r)
?_012:  leave                                           ; 01AB _ C9
        ret                                             ; 01AC _ C3
; get_boolean_option End of function


SECTION .data   align=1 noexec                          ; section number 2, data


SECTION .bss    align=1 noexec                          ; section number 3, bss


SECTION .rodata align=8 noexec                          ; section number 4, const

?_013:                                                  ; byte
        db 62H, 6FH, 6FH, 6CH, 65H, 61H, 6EH, 20H       ; 0000 _ boolean 
        db 66H, 6CH, 61H, 67H, 20H, 65H, 78H, 70H       ; 0008 _ flag exp
        db 72H, 65H, 73H, 73H, 69H, 6FH, 6EH, 20H       ; 0010 _ ression 
        db 6DH, 75H, 73H, 74H, 20H, 62H, 65H, 20H       ; 0018 _ must be 
        db 61H, 20H, 63H, 6FH, 6EH, 73H, 74H, 61H       ; 0020 _ a consta
        db 6EH, 74H, 00H, 6EH, 6FH, 00H, 79H, 65H       ; 0028 _ nt.no.ye
        db 73H, 00H, 66H, 61H, 6CH, 73H, 65H, 00H       ; 0030 _ s.false.
        db 74H, 72H, 75H, 65H, 00H, 6FH, 66H, 66H       ; 0038 _ true.off
        db 00H, 6FH, 6EH, 00H                           ; 0040 _ .on.


SECTION .data.rel.ro.local align=32 noexec              ; section number 5, data

noyes.0:                                                ; byte
        dq ?_013+2BH                                    ; 0000 _ 0000000000000000 (d)
        dq ?_013+2EH                                    ; 0008 _ 0000000000000000 (d)
        dq ?_013+32H                                    ; 0010 _ 0000000000000000 (d)
        dq ?_013+38H                                    ; 0018 _ 0000000000000000 (d)
        dq ?_013+3DH                                    ; 0020 _ 0000000000000000 (d)
        dq ?_013+41H                                    ; 0028 _ 0000000000000000 (d)


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
        dd get_boolean_option-$-20H                     ; 0020 _ 00000000 (rel)
        dd 000001ADH, 100E4100H                         ; 0024 _ 429 269369600 
        dd 0D430286H, 01A80306H                         ; 002C _ 222495366 27788038 
        dd 0008070CH                                    ; 0034 _ 526092 


