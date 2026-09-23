; Disassembly of file: /tmp/tmp.OiWYn5p839.o
; Wed Sep 23 14:43:20 2026
; Type: ELF64
; Syntax: NASM
; Instruction set: 80386, x64

default rel

global reset_global_defaults: function
global register_name: function
global prefix_name: function
global is_hint_nop: function
global globl

extern nasm_reg_names                                   ; byte


SECTION .text   align=1 exec                            ; section number 1, code

is_register:; Local function
        push    rbp                                     ; 0000 _ 55
        mov     rbp, rsp                                ; 0001 _ 48: 89. E5
        mov     dword [rbp-4H], edi                     ; 0004 _ 89. 7D, FC
        cmp     dword [rbp-4H], 0                       ; 0007 _ 83. 7D, FC, 00
        jle     ?_001                                   ; 000B _ 7E, 10
        cmp     dword [rbp-4H], 344                     ; 000D _ 81. 7D, FC, 00000158
        jg      ?_001                                   ; 0014 _ 7F, 07
        mov     eax, 1                                  ; 0016 _ B8, 00000001
        jmp     ?_002                                   ; 001B _ EB, 05

?_001:  mov     eax, 0                                  ; 001D _ B8, 00000000
?_002:  and     eax, 01H                                ; 0022 _ 83. E0, 01
        pop     rbp                                     ; 0025 _ 5D
        ret                                             ; 0026 _ C3

reset_global_defaults:; Function begin
        push    rbp                                     ; 0027 _ 55
        mov     rbp, rsp                                ; 0028 _ 48: 89. E5
        mov     dword [rbp-4H], edi                     ; 002B _ 89. 7D, FC
        mov     eax, dword [rbp-4H]                     ; 002E _ 8B. 45, FC
        mov     dword [rel globl], eax                  ; 0031 _ 89. 05, 00000000(rel)
        mov     byte [rel globl+0CH], 0                 ; 0037 _ C6. 05, 00000000(rel), 00
        mov     dword [rel globl+4H], 0                 ; 003E _ C7. 05, 00000000(rel), 00000000
        mov     dword [rel globl+8H], 768               ; 0048 _ C7. 05, 00000000(rel), 00000300
        mov     byte [rel globl+0DH], 1                 ; 0052 _ C6. 05, 00000000(rel), 01
        nop                                             ; 0059 _ 90
        pop     rbp                                     ; 005A _ 5D
        ret                                             ; 005B _ C3
; reset_global_defaults End of function

register_name:; Function begin
        push    rbp                                     ; 005C _ 55
        mov     rbp, rsp                                ; 005D _ 48: 89. E5
        sub     rsp, 8                                  ; 0060 _ 48: 83. EC, 08
        mov     dword [rbp-4H], edi                     ; 0064 _ 89. 7D, FC
        mov     eax, dword [rbp-4H]                     ; 0067 _ 8B. 45, FC
        mov     edi, eax                                ; 006A _ 89. C7
        call    is_register                             ; 006C _ E8, FFFFFF8F
        test    al, al                                  ; 0071 _ 84. C0
        jz      ?_003                                   ; 0073 _ 74, 1D
        mov     eax, dword [rbp-4H]                     ; 0075 _ 8B. 45, FC
        sub     eax, 1                                  ; 0078 _ 83. E8, 01
        cdqe                                            ; 007B _ 48: 98
        lea     rdx, [rax*8]                            ; 007D _ 48: 8D. 14 C5, 00000000
        lea     rax, [rel nasm_reg_names]               ; 0085 _ 48: 8D. 05, 00000000(rel)
        mov     rax, qword [rdx+rax]                    ; 008C _ 48: 8B. 04 02
        jmp     ?_004                                   ; 0090 _ EB, 05

?_003:  mov     eax, 0                                  ; 0092 _ B8, 00000000
?_004:  leave                                           ; 0097 _ C9
        ret                                             ; 0098 _ C3
; register_name End of function

prefix_name:; Function begin
        push    rbp                                     ; 0099 _ 55
        mov     rbp, rsp                                ; 009A _ 48: 89. E5
        sub     rsp, 24                                 ; 009D _ 48: 83. EC, 18
        mov     dword [rbp-14H], edi                    ; 00A1 _ 89. 7D, EC
        mov     eax, dword [rbp-14H]                    ; 00A4 _ 8B. 45, EC
        mov     edi, eax                                ; 00A7 _ 89. C7
        call    register_name                           ; 00A9 _ E8, 00000000(PLT r)
        mov     qword [rbp-8H], rax                     ; 00AE _ 48: 89. 45, F8
        cmp     qword [rbp-8H], 0                       ; 00B2 _ 48: 83. 7D, F8, 00
        jnz     ?_005                                   ; 00B7 _ 75, 2B
        mov     eax, dword [rbp-14H]                    ; 00B9 _ 8B. 45, EC
        sub     eax, 345                                ; 00BC _ 2D, 00000159
        mov     dword [rbp-0CH], eax                    ; 00C1 _ 89. 45, F4
        cmp     dword [rbp-0CH], 28                     ; 00C4 _ 83. 7D, F4, 1C
        ja      ?_005                                   ; 00C8 _ 77, 1A
        mov     eax, dword [rbp-0CH]                    ; 00CA _ 8B. 45, F4
        lea     rdx, [rax*8]                            ; 00CD _ 48: 8D. 14 C5, 00000000
        lea     rax, [rel prefix_names.0]               ; 00D5 _ 48: 8D. 05, 00000000(rel)
        mov     rax, qword [rdx+rax]                    ; 00DC _ 48: 8B. 04 02
        mov     qword [rbp-8H], rax                     ; 00E0 _ 48: 89. 45, F8
?_005:  mov     rax, qword [rbp-8H]                     ; 00E4 _ 48: 8B. 45, F8
        leave                                           ; 00E8 _ C9
        ret                                             ; 00E9 _ C3
; prefix_name End of function

is_hint_nop:; Function begin
        push    rbp                                     ; 00EA _ 55
        mov     rbp, rsp                                ; 00EB _ 48: 89. E5
        mov     qword [rbp-8H], rdi                     ; 00EE _ 48: 89. 7D, F8
        mov     rax, qword [rbp-8H]                     ; 00F2 _ 48: 8B. 45, F8
        shr     rax, 16                                 ; 00F6 _ 48: C1. E8, 10
        test    rax, rax                                ; 00FA _ 48: 85. C0
        jz      ?_006                                   ; 00FD _ 74, 07
        mov     eax, 0                                  ; 00FF _ B8, 00000000
        jmp     ?_012                                   ; 0104 _ EB, 53

?_006:  mov     rax, qword [rbp-8H]                     ; 0106 _ 48: 8B. 45, F8
        shr     rax, 8                                  ; 010A _ 48: C1. E8, 08
        cmp     rax, 15                                 ; 010E _ 48: 83. F8, 0F
        jnz     ?_007                                   ; 0112 _ 75, 0D
        mov     rax, qword [rbp-8H]                     ; 0114 _ 48: 8B. 45, F8
        movzx   eax, al                                 ; 0118 _ 0F B6. C0
        mov     qword [rbp-8H], rax                     ; 011B _ 48: 89. 45, F8
        jmp     ?_008                                   ; 011F _ EB, 14

?_007:  mov     rax, qword [rbp-8H]                     ; 0121 _ 48: 8B. 45, F8
        shr     rax, 8                                  ; 0125 _ 48: C1. E8, 08
        test    rax, rax                                ; 0129 _ 48: 85. C0
        jz      ?_008                                   ; 012C _ 74, 07
        mov     eax, 0                                  ; 012E _ B8, 00000000
        jmp     ?_012                                   ; 0133 _ EB, 24

?_008:  mov     rax, qword [rbp-8H]                     ; 0135 _ 48: 8B. 45, F8
        and     rax, 0FFFFFFFFFFFFFFF8H                 ; 0139 _ 48: 83. E0, F8
        cmp     rax, 24                                 ; 013D _ 48: 83. F8, 18
        jz      ?_009                                   ; 0141 _ 74, 07
        cmp     qword [rbp-8H], 13                      ; 0143 _ 48: 83. 7D, F8, 0D
        jnz     ?_010                                   ; 0148 _ 75, 07
?_009:  mov     eax, 1                                  ; 014A _ B8, 00000001
        jmp     ?_011                                   ; 014F _ EB, 05

?_010:  mov     eax, 0                                  ; 0151 _ B8, 00000000
?_011:  and     eax, 01H                                ; 0156 _ 83. E0, 01
?_012:  pop     rbp                                     ; 0159 _ 5D
        ret                                             ; 015A _ C3
; is_hint_nop End of function


SECTION .data   align=1 noexec                          ; section number 2, data


SECTION .bss    align=16 noexec                         ; section number 3, bss

globl:                                                  ; oword
        resd    4                                       ; 0000


SECTION .rodata align=1 noexec                          ; section number 4, const

        db 61H, 31H, 36H, 00H, 61H, 33H, 32H, 00H       ; 0000 _ a16.a32.
        db 61H, 36H, 34H, 00H, 61H, 73H, 70H, 00H       ; 0008 _ a64.asp.
        db 6CH, 6FH, 63H, 6BH, 00H, 6FH, 31H, 36H       ; 0010 _ lock.o16
        db 00H, 6FH, 33H, 32H, 00H, 6FH, 36H, 34H       ; 0018 _ .o32.o64
        db 00H, 6FH, 73H, 70H, 00H, 72H, 65H, 70H       ; 0020 _ .osp.rep
        db 00H, 72H, 65H, 70H, 65H, 00H, 72H, 65H       ; 0028 _ .repe.re
        db 70H, 6EH, 65H, 00H, 72H, 65H, 70H, 6EH       ; 0030 _ pne.repn
        db 7AH, 00H, 72H, 65H, 70H, 7AH, 00H, 77H       ; 0038 _ z.repz.w
        db 61H, 69H, 74H, 00H, 78H, 61H, 63H, 71H       ; 0040 _ ait.xacq
        db 75H, 69H, 72H, 65H, 00H, 78H, 72H, 65H       ; 0048 _ uire.xre
        db 6CH, 65H, 61H, 73H, 65H, 00H, 62H, 6EH       ; 0050 _ lease.bn
        db 64H, 00H, 6EH, 6FH, 62H, 6EH, 64H, 00H       ; 0058 _ d.nobnd.
        db 7BH, 72H, 65H, 78H, 7DH, 00H, 7BH, 72H       ; 0060 _ {rex}.{r
        db 65H, 78H, 32H, 7DH, 00H, 7BH, 65H, 76H       ; 0068 _ ex2}.{ev
        db 65H, 78H, 7DH, 00H, 7BH, 76H, 65H, 78H       ; 0070 _ ex}.{vex
        db 7DH, 00H, 7BH, 76H, 65H, 78H, 33H, 7DH       ; 0078 _ }.{vex3}
        db 00H, 7BH, 76H, 65H, 78H, 32H, 7DH, 00H       ; 0080 _ .{vex2}.
        db 7BH, 6EH, 66H, 7DH, 00H, 7BH, 7AH, 75H       ; 0088 _ {nf}.{zu
        db 7DH, 00H, 7BH, 70H, 74H, 7DH, 00H, 7BH       ; 0090 _ }.{pt}.{
        db 70H, 6EH, 7DH, 00H                           ; 0098 _ pn}.


SECTION .data.rel.ro.local align=32 noexec              ; section number 5, data

prefix_names.0:                                         ; byte
        dq Unnamed_4_0                                  ; 0000 _ 0000000000000000 (d)
        dq Unnamed_4_0+4H                               ; 0008 _ 0000000000000000 (d)
        dq Unnamed_4_0+8H                               ; 0010 _ 0000000000000000 (d)
        dq Unnamed_4_0+0CH                              ; 0018 _ 0000000000000000 (d)
        dq Unnamed_4_0+10H                              ; 0020 _ 0000000000000000 (d)
        dq Unnamed_4_0+15H                              ; 0028 _ 0000000000000000 (d)
        dq Unnamed_4_0+19H                              ; 0030 _ 0000000000000000 (d)
        dq Unnamed_4_0+1DH                              ; 0038 _ 0000000000000000 (d)
        dq Unnamed_4_0+21H                              ; 0040 _ 0000000000000000 (d)
        dq Unnamed_4_0+25H                              ; 0048 _ 0000000000000000 (d)
        dq Unnamed_4_0+29H                              ; 0050 _ 0000000000000000 (d)
        dq Unnamed_4_0+2EH                              ; 0058 _ 0000000000000000 (d)
        dq Unnamed_4_0+34H                              ; 0060 _ 0000000000000000 (d)
        dq Unnamed_4_0+3AH                              ; 0068 _ 0000000000000000 (d)
        dq Unnamed_4_0+3FH                              ; 0070 _ 0000000000000000 (d)
        dq Unnamed_4_0+44H                              ; 0078 _ 0000000000000000 (d)
        dq Unnamed_4_0+4DH                              ; 0080 _ 0000000000000000 (d)
        dq Unnamed_4_0+56H                              ; 0088 _ 0000000000000000 (d)
        dq Unnamed_4_0+5AH                              ; 0090 _ 0000000000000000 (d)
        dq Unnamed_4_0+60H                              ; 0098 _ 0000000000000000 (d)
        dq Unnamed_4_0+66H                              ; 00A0 _ 0000000000000000 (d)
        dq Unnamed_4_0+6DH                              ; 00A8 _ 0000000000000000 (d)
        dq Unnamed_4_0+74H                              ; 00B0 _ 0000000000000000 (d)
        dq Unnamed_4_0+7AH                              ; 00B8 _ 0000000000000000 (d)
        dq Unnamed_4_0+81H                              ; 00C0 _ 0000000000000000 (d)
        dq Unnamed_4_0+88H                              ; 00C8 _ 0000000000000000 (d)
        dq Unnamed_4_0+8DH                              ; 00D0 _ 0000000000000000 (d)
        dq Unnamed_4_0+92H                              ; 00D8 _ 0000000000000000 (d)
        dq Unnamed_4_0+97H                              ; 00E0 _ 0000000000000000 (d)


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
        dd is_register-$-20H                            ; 0020 _ 00000000 (rel)
        dd 00000027H, 100E4100H                         ; 0024 _ 39 269369600 
        dd 0D430286H, 070C6206H                         ; 002C _ 222495366 118252038 
        dd 00000008H, 0000001CH                         ; 0034 _ 8 28 
        dd 0000003CH                                    ; 003C _ 60 
        dd is_register-$-19H                            ; 0040 _ 00000000 (rel)
        dd 00000035H, 100E4100H                         ; 0044 _ 53 269369600 
        dd 0D430286H, 070C7006H                         ; 004C _ 222495366 118255622 
        dd 00000008H, 0000001CH                         ; 0054 _ 8 28 
        dd 0000005CH                                    ; 005C _ 92 
        dd is_register-$-4H                             ; 0060 _ 00000000 (rel)
        dd 0000003DH, 100E4100H                         ; 0064 _ 61 269369600 
        dd 0D430286H, 070C7806H                         ; 006C _ 222495366 118257670 
        dd 00000008H, 0000001CH                         ; 0074 _ 8 28 
        dd 0000007CH                                    ; 007C _ 124 
        dd is_register-$+19H                            ; 0080 _ 00000000 (rel)
        dd 00000051H, 100E4100H                         ; 0084 _ 81 269369600 
        dd 0D430286H, 0C4C0206H                         ; 008C _ 222495366 206307846 
        dd 00000807H, 0000001CH                         ; 0094 _ 2055 28 
        dd 0000009CH                                    ; 009C _ 156 
        dd is_register-$+4AH                            ; 00A0 _ 00000000 (rel)
        dd 00000071H, 100E4100H                         ; 00A4 _ 113 269369600 
        dd 0D430286H, 0C6C0206H                         ; 00AC _ 222495366 208404998 
        dd 00000807H                                    ; 00B4 _ 2055 


