; Disassembly of file: /tmp/tmp.4w1nVeCEtC.o
; Wed Sep 23 14:43:20 2026
; Type: ELF64
; Syntax: NASM
; Instruction set: 80386, x64

default rel

global copy_filename: function
global set_filename: function
global check_overwrite_files: function
global cleanup_filenames: function
global _filenames

extern nasm_free                                        ; near
extern nasm_nonfatal                                    ; near
extern nasm_compare_paths                               ; near
extern nasm_fatal                                       ; near
extern nasm_strdup                                      ; near
extern nasm_assert_failed                               ; near


SECTION .text   align=1 exec                            ; section number 1, code

get_filename:; Local function
        push    rbp                                     ; 0000 _ 55
        mov     rbp, rsp                                ; 0001 _ 48: 89. E5
        sub     rsp, 16                                 ; 0004 _ 48: 83. EC, 10
        mov     dword [rbp-4H], edi                     ; 0008 _ 89. 7D, FC
        cmp     dword [rbp-4H], 8                       ; 000B _ 83. 7D, FC, 08
        seta    al                                      ; 000F _ 0F 97. C0
        movzx   eax, al                                 ; 0012 _ 0F B6. C0
        test    rax, rax                                ; 0015 _ 48: 85. C0
        jz      ?_001                                   ; 0018 _ 74, 22
        lea     rdx, [rel ?_013]                        ; 001A _ 48: 8D. 15, 00000000(rel)
        lea     rsi, [rel __func__.0]                   ; 0021 _ 48: 8D. 35, 00000000(rel)
        lea     rax, [rel ?_014]                        ; 0028 _ 48: 8D. 05, 00000000(rel)
        mov     ecx, 49                                 ; 002F _ B9, 00000031
        mov     rdi, rax                                ; 0034 _ 48: 89. C7
        call    nasm_assert_failed                      ; 0037 _ E8, 00000000(PLT r)
?_001:  mov     eax, dword [rbp-4H]                     ; 003C _ 8B. 45, FC
        lea     rdx, [rax*8]                            ; 003F _ 48: 8D. 14 C5, 00000000
        lea     rax, [rel _filenames]                   ; 0047 _ 48: 8D. 05, 00000000(rel)
        mov     rax, qword [rdx+rax]                    ; 004E _ 48: 8B. 04 02
        leave                                           ; 0052 _ C9
        ret                                             ; 0053 _ C3

copy_filename:; Function begin
        push    rbp                                     ; 0054 _ 55
        mov     rbp, rsp                                ; 0055 _ 48: 89. E5
        sub     rsp, 16                                 ; 0058 _ 48: 83. EC, 10
        mov     dword [rbp-4H], edi                     ; 005C _ 89. 7D, FC
        mov     qword [rbp-10H], rsi                    ; 005F _ 48: 89. 75, F0
        mov     rax, qword [rbp-10H]                    ; 0063 _ 48: 8B. 45, F0
        mov     rdi, rax                                ; 0067 _ 48: 89. C7
        call    nasm_strdup                             ; 006A _ E8, 00000000(PLT r)
        mov     rdx, rax                                ; 006F _ 48: 89. C2
        mov     eax, dword [rbp-4H]                     ; 0072 _ 8B. 45, FC
        mov     rsi, rdx                                ; 0075 _ 48: 89. D6
        mov     edi, eax                                ; 0078 _ 89. C7
        call    set_filename                            ; 007A _ E8, 00000000(PLT r)
        leave                                           ; 007F _ C9
        ret                                             ; 0080 _ C3
; copy_filename End of function

set_filename:; Function begin
        push    rbp                                     ; 0081 _ 55
        mov     rbp, rsp                                ; 0082 _ 48: 89. E5
        sub     rsp, 32                                 ; 0085 _ 48: 83. EC, 20
        mov     dword [rbp-14H], edi                    ; 0089 _ 89. 7D, EC
        mov     qword [rbp-20H], rsi                    ; 008C _ 48: 89. 75, E0
        cmp     dword [rbp-14H], 8                      ; 0090 _ 83. 7D, EC, 08
        seta    al                                      ; 0094 _ 0F 97. C0
        movzx   eax, al                                 ; 0097 _ 0F B6. C0
        test    rax, rax                                ; 009A _ 48: 85. C0
        jz      ?_002                                   ; 009D _ 74, 22
        lea     rdx, [rel ?_015]                        ; 009F _ 48: 8D. 15, 00000000(rel)
        lea     rsi, [rel __func__.1]                   ; 00A6 _ 48: 8D. 35, 00000000(rel)
        lea     rax, [rel ?_014]                        ; 00AD _ 48: 8D. 05, 00000000(rel)
        mov     ecx, 35                                 ; 00B4 _ B9, 00000023
        mov     rdi, rax                                ; 00B9 _ 48: 89. C7
        call    nasm_assert_failed                      ; 00BC _ E8, 00000000(PLT r)
?_002:  mov     eax, dword [rbp-14H]                    ; 00C1 _ 8B. 45, EC
        lea     rdx, [rax*8]                            ; 00C4 _ 48: 8D. 14 C5, 00000000
        lea     rax, [rel _filenames]                   ; 00CC _ 48: 8D. 05, 00000000(rel)
        add     rax, rdx                                ; 00D3 _ 48: 01. D0
        mov     qword [rbp-10H], rax                    ; 00D6 _ 48: 89. 45, F0
        mov     rax, qword [rbp-10H]                    ; 00DA _ 48: 8B. 45, F0
        mov     rax, qword [rax]                        ; 00DE _ 48: 8B. 00
        mov     qword [rbp-8H], rax                     ; 00E1 _ 48: 89. 45, F8
        cmp     qword [rbp-8H], 0                       ; 00E5 _ 48: 83. 7D, F8, 00
        jz      ?_003                                   ; 00EA _ 74, 32
        mov     eax, dword [rbp-14H]                    ; 00EC _ 8B. 45, EC
        lea     rdx, [rax*8]                            ; 00EF _ 48: 8D. 14 C5, 00000000
        lea     rax, [rel filename_names]               ; 00F7 _ 48: 8D. 05, 00000000(rel)
        mov     rax, qword [rdx+rax]                    ; 00FE _ 48: 8B. 04 02
        mov     rcx, qword [rbp-20H]                    ; 0102 _ 48: 8B. 4D, E0
        mov     rdx, qword [rbp-8H]                     ; 0106 _ 48: 8B. 55, F8
        lea     rdi, [rel ?_016]                        ; 010A _ 48: 8D. 3D, 00000000(rel)
        mov     rsi, rax                                ; 0111 _ 48: 89. C6
        mov     eax, 0                                  ; 0114 _ B8, 00000000
        call    nasm_fatal                              ; 0119 _ E8, 00000000(PLT r)
?_003:  mov     rax, qword [rbp-10H]                    ; 011E _ 48: 8B. 45, F0
        mov     rdx, qword [rbp-20H]                    ; 0122 _ 48: 8B. 55, E0
        mov     qword [rax], rdx                        ; 0126 _ 48: 89. 10
        mov     rax, qword [rbp-10H]                    ; 0129 _ 48: 8B. 45, F0
        mov     rax, qword [rax]                        ; 012D _ 48: 8B. 00
        leave                                           ; 0130 _ C9
        ret                                             ; 0131 _ C3
; set_filename End of function

check_overwrite_files:; Function begin
        push    rbp                                     ; 0132 _ 55
        mov     rbp, rsp                                ; 0133 _ 48: 89. E5
        sub     rsp, 32                                 ; 0136 _ 48: 83. EC, 20
        mov     dword [rbp-18H], 0                      ; 013A _ C7. 45, E8, 00000000
        jmp     ?_010                                   ; 0141 _ E9, 000000A3

?_004:  mov     eax, dword [rbp-18H]                    ; 0146 _ 8B. 45, E8
        mov     edi, eax                                ; 0149 _ 89. C7
        call    get_filename                            ; 014B _ E8, FFFFFEB0
        mov     qword [rbp-10H], rax                    ; 0150 _ 48: 89. 45, F0
        cmp     qword [rbp-10H], 0                      ; 0154 _ 48: 83. 7D, F0, 00
        je      ?_008                                   ; 0159 _ 0F 84, 00000085
        mov     dword [rbp-14H], 1                      ; 015F _ C7. 45, EC, 00000001
        jmp     ?_007                                   ; 0166 _ EB, 74

?_005:  mov     eax, dword [rbp-14H]                    ; 0168 _ 8B. 45, EC
        mov     edi, eax                                ; 016B _ 89. C7
        call    get_filename                            ; 016D _ E8, FFFFFE8E
        mov     qword [rbp-8H], rax                     ; 0172 _ 48: 89. 45, F8
        cmp     qword [rbp-8H], 0                       ; 0176 _ 48: 83. 7D, F8, 00
        jz      ?_006                                   ; 017B _ 74, 5B
        mov     rdx, qword [rbp-8H]                     ; 017D _ 48: 8B. 55, F8
        mov     rax, qword [rbp-10H]                    ; 0181 _ 48: 8B. 45, F0
        mov     rsi, rdx                                ; 0185 _ 48: 89. D6
        mov     rdi, rax                                ; 0188 _ 48: 89. C7
        call    nasm_compare_paths                      ; 018B _ E8, 00000000(PLT r)
        test    eax, eax                                ; 0190 _ 85. C0
        jnz     ?_006                                   ; 0192 _ 75, 44
        mov     eax, dword [rbp-18H]                    ; 0194 _ 8B. 45, E8
        lea     rdx, [rax*8]                            ; 0197 _ 48: 8D. 14 C5, 00000000
        lea     rax, [rel filename_names]               ; 019F _ 48: 8D. 05, 00000000(rel)
        mov     rdx, qword [rdx+rax]                    ; 01A6 _ 48: 8B. 14 02
        mov     eax, dword [rbp-14H]                    ; 01AA _ 8B. 45, EC
        lea     rcx, [rax*8]                            ; 01AD _ 48: 8D. 0C C5, 00000000
        lea     rax, [rel filename_names]               ; 01B5 _ 48: 8D. 05, 00000000(rel)
        mov     rax, qword [rcx+rax]                    ; 01BC _ 48: 8B. 04 01
        mov     rcx, qword [rbp-10H]                    ; 01C0 _ 48: 8B. 4D, F0
        lea     rdi, [rel ?_017]                        ; 01C4 _ 48: 8D. 3D, 00000000(rel)
        mov     rsi, rax                                ; 01CB _ 48: 89. C6
        mov     eax, 0                                  ; 01CE _ B8, 00000000
        call    nasm_nonfatal                           ; 01D3 _ E8, 00000000(PLT r)
?_006:  add     dword [rbp-14H], 1                      ; 01D8 _ 83. 45, EC, 01
?_007:  cmp     dword [rbp-14H], 5                      ; 01DC _ 83. 7D, EC, 05
        jbe     ?_005                                   ; 01E0 _ 76, 86
        jmp     ?_009                                   ; 01E2 _ EB, 01

?_008:  nop                                             ; 01E4 _ 90
?_009:  add     dword [rbp-18H], 1                      ; 01E5 _ 83. 45, E8, 01
?_010:  cmp     dword [rbp-18H], 0                      ; 01E9 _ 83. 7D, E8, 00
        je      ?_004                                   ; 01ED _ 0F 84, FFFFFF53
        nop                                             ; 01F3 _ 90
        nop                                             ; 01F4 _ 90
        leave                                           ; 01F5 _ C9
        ret                                             ; 01F6 _ C3
; check_overwrite_files End of function

cleanup_filenames:; Function begin
        push    rbp                                     ; 01F7 _ 55
        mov     rbp, rsp                                ; 01F8 _ 48: 89. E5
        sub     rsp, 16                                 ; 01FB _ 48: 83. EC, 10
        mov     dword [rbp-4H], 0                       ; 01FF _ C7. 45, FC, 00000000
        jmp     ?_012                                   ; 0206 _ EB, 3C

?_011:  mov     eax, dword [rbp-4H]                     ; 0208 _ 8B. 45, FC
        lea     rdx, [rax*8]                            ; 020B _ 48: 8D. 14 C5, 00000000
        lea     rax, [rel _filenames]                   ; 0213 _ 48: 8D. 05, 00000000(rel)
        mov     rax, qword [rdx+rax]                    ; 021A _ 48: 8B. 04 02
        mov     rdi, rax                                ; 021E _ 48: 89. C7
        call    nasm_free                               ; 0221 _ E8, 00000000(PLT r)
        mov     eax, dword [rbp-4H]                     ; 0226 _ 8B. 45, FC
        lea     rdx, [rax*8]                            ; 0229 _ 48: 8D. 14 C5, 00000000
        lea     rax, [rel _filenames]                   ; 0231 _ 48: 8D. 05, 00000000(rel)
        mov     qword [rdx+rax], 0                      ; 0238 _ 48: C7. 04 02, 00000000
        add     dword [rbp-4H], 1                       ; 0240 _ 83. 45, FC, 01
?_012:  cmp     dword [rbp-4H], 8                       ; 0244 _ 83. 7D, FC, 08
        jbe     ?_011                                   ; 0248 _ 76, BE
        nop                                             ; 024A _ 90
        nop                                             ; 024B _ 90
        leave                                           ; 024C _ C9
        ret                                             ; 024D _ C3
; cleanup_filenames End of function


SECTION .data   align=1 noexec                          ; section number 2, data


SECTION .bss    align=32 noexec                         ; section number 3, bss

_filenames:                                             ; byte
        resb    72                                      ; 0000


SECTION .rodata align=8 noexec                          ; section number 4, const

?_013:                                                  ; byte
        db 69H, 6EH, 63H, 6CH, 75H, 64H, 65H, 2FH       ; 0000 _ include/
        db 66H, 69H, 6CH, 65H, 73H, 2EH, 68H, 00H       ; 0008 _ files.h.

?_014:                                                  ; byte
        db 28H, 73H, 69H, 7AH, 65H, 5FH, 74H, 29H       ; 0010 _ (size_t)
        db 66H, 6EH, 20H, 3CH, 20H, 41H, 52H, 52H       ; 0018 _ fn < ARR
        db 41H, 59H, 5FH, 53H, 49H, 5AH, 45H, 28H       ; 0020 _ AY_SIZE(
        db 5FH, 66H, 69H, 6CH, 65H, 6EH, 61H, 6DH       ; 0028 _ _filenam
        db 65H, 73H, 29H, 00H, 69H, 6EH, 70H, 75H       ; 0030 _ es).inpu
        db 74H, 00H, 6FH, 75H, 74H, 70H, 75H, 74H       ; 0038 _ t.output
        db 00H, 65H, 72H, 72H, 6FH, 72H, 00H, 6CH       ; 0040 _ .error.l
        db 69H, 73H, 74H, 00H, 64H, 65H, 70H, 65H       ; 0048 _ ist.depe
        db 6EH, 64H, 65H, 6EH, 63H, 79H, 00H, 6DH       ; 0050 _ ndency.m
        db 61H, 70H, 00H, 64H, 65H, 62H, 75H, 67H       ; 0058 _ ap.debug
        db 20H, 6DH, 61H, 70H, 70H, 65H, 64H, 20H       ; 0060 _  mapped 
        db 69H, 6EH, 70H, 75H, 74H, 00H, 6DH, 61H       ; 0068 _ input.ma
        db 6BH, 65H, 20H, 6DH, 61H, 70H, 70H, 65H       ; 0070 _ ke mappe
        db 64H, 20H, 6FH, 75H, 74H, 70H, 75H, 74H       ; 0078 _ d output
        db 00H                                          ; 0080 _ .

?_015:                                                  ; byte
        db 2EH, 2FH, 63H, 6FH, 6DH, 6DH, 6FH, 6EH       ; 0081 _ ./common
        db 2FH, 66H, 69H, 6CH, 65H, 73H, 2EH, 63H       ; 0089 _ /files.c
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H            ; 0091 _ .......

?_016:                                                  ; byte
        db 6DH, 6FH, 72H, 65H, 20H, 74H, 68H, 61H       ; 0098 _ more tha
        db 6EH, 20H, 6FH, 6EH, 65H, 20H, 25H, 73H       ; 00A0 _ n one %s
        db 20H, 66H, 69H, 6CH, 65H, 20H, 73H, 70H       ; 00A8 _  file sp
        db 65H, 63H, 69H, 66H, 69H, 65H, 64H, 3AH       ; 00B0 _ ecified:
        db 20H, 25H, 73H, 20H, 61H, 6EH, 64H, 20H       ; 00B8 _  %s and 
        db 25H, 73H, 00H, 00H, 00H, 00H, 00H, 00H       ; 00C0 _ %s......

?_017:                                                  ; byte
        db 25H, 73H, 20H, 66H, 69H, 6CH, 65H, 20H       ; 00C8 _ %s file 
        db 77H, 6FH, 75H, 6CH, 64H, 20H, 6FH, 76H       ; 00D0 _ would ov
        db 65H, 72H, 77H, 72H, 69H, 74H, 65H, 20H       ; 00D8 _ erwrite 
        db 25H, 73H, 20H, 66H, 69H, 6CH, 65H, 20H       ; 00E0 _ %s file 
        db 60H, 25H, 73H, 27H, 00H, 00H, 00H, 00H       ; 00E8 _ `%s'....

__func__.1:                                             ; byte
        db 73H, 65H, 74H, 5FH, 66H, 69H, 6CH, 65H       ; 00F0 _ set_file
        db 6EH, 61H, 6DH, 65H, 00H, 00H, 00H, 00H       ; 00F8 _ name....

__func__.0:                                             ; byte
        db 67H, 65H, 74H, 5FH, 66H, 69H, 6CH, 65H       ; 0100 _ get_file
        db 6EH, 61H, 6DH, 65H, 00H                      ; 0108 _ name.


SECTION .data.rel.ro.local align=32 noexec              ; section number 5, data

filename_names:                                         ; byte
        dq ?_013+34H                                    ; 0000 _ 0000000000000000 (d)
        dq ?_013+3AH                                    ; 0008 _ 0000000000000000 (d)
        dq ?_013+41H                                    ; 0010 _ 0000000000000000 (d)
        dq ?_013+47H                                    ; 0018 _ 0000000000000000 (d)
        dq ?_013+4CH                                    ; 0020 _ 0000000000000000 (d)
        dq ?_013+57H                                    ; 0028 _ 0000000000000000 (d)
        dq 0000000000000000H                            ; 0030 _ 0000000000000000 
        dq ?_013+5BH                                    ; 0038 _ 0000000000000000 (d)
        dq ?_013+6EH                                    ; 0040 _ 0000000000000000 (d)


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
        dd get_filename-$-20H                           ; 0020 _ 00000000 (rel)
        dd 00000054H, 100E4100H                         ; 0024 _ 84 269369600 
        dd 0D430286H, 0C4F0206H                         ; 002C _ 222495366 206504454 
        dd 00000807H, 0000001CH                         ; 0034 _ 2055 28 
        dd 0000003CH                                    ; 003C _ 60 
        dd get_filename-$+14H                           ; 0040 _ 00000000 (rel)
        dd 0000002DH, 100E4100H                         ; 0044 _ 45 269369600 
        dd 0D430286H, 070C6806H                         ; 004C _ 222495366 118253574 
        dd 00000008H, 0000001CH                         ; 0054 _ 8 28 
        dd 0000005CH                                    ; 005C _ 92 
        dd get_filename-$+21H                           ; 0060 _ 00000000 (rel)
        dd 000000B1H, 100E4100H                         ; 0064 _ 177 269369600 
        dd 0D430286H, 0CAC0206H                         ; 006C _ 222495366 212599302 
        dd 00000807H, 0000001CH                         ; 0074 _ 2055 28 
        dd 0000007CH                                    ; 007C _ 124 
        dd get_filename-$+0B2H                          ; 0080 _ 00000000 (rel)
        dd 000000C5H, 100E4100H                         ; 0084 _ 197 269369600 
        dd 0D430286H, 0CC00206H                         ; 008C _ 222495366 213910022 
        dd 00000807H, 0000001CH                         ; 0094 _ 2055 28 
        dd 0000009CH                                    ; 009C _ 156 
        dd get_filename-$+157H                          ; 00A0 _ 00000000 (rel)
        dd 00000057H, 100E4100H                         ; 00A4 _ 87 269369600 
        dd 0D430286H, 0C520206H                         ; 00AC _ 222495366 206701062 
        dd 00000807H                                    ; 00B4 _ 2055 


