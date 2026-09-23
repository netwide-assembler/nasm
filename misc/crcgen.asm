; Disassembly of file: /tmp/tmp.L1XbTNBEHm.o
; Wed Sep 23 14:43:29 2026
; Type: ELF64
; Syntax: NASM
; Instruction set: 80386, x64

default rel

global main: function

extern __stack_chk_fail                                 ; near
extern printf                                           ; near
extern puts                                             ; near
extern __isoc23_strtoumax                               ; near


SECTION .text   align=1 exec                            ; section number 1, code

main:   ; Function begin
        push    rbp                                     ; 0000 _ 55
        mov     rbp, rsp                                ; 0001 _ 48: 89. E5
        sub     rsp, 2112                               ; 0004 _ 48: 81. EC, 00000840
        mov     dword [rbp-834H], edi                   ; 000B _ 89. BD, FFFFF7CC
        mov     qword [rbp-840H], rsi                   ; 0011 _ 48: 89. B5, FFFFF7C0
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        mov     rax, qword [fs:abs 28H]                 ; 0018 _ 64 48: 8B. 04 25, 00000028
        mov     qword [rbp-8H], rax                     ; 0021 _ 48: 89. 45, F8
        xor     eax, eax                                ; 0025 _ 31. C0
        mov     rax, qword [rbp-840H]                   ; 0027 _ 48: 8B. 85, FFFFF7C0
        add     rax, 8                                  ; 002E _ 48: 83. C0, 08
        mov     rax, qword [rax]                        ; 0032 _ 48: 8B. 00
        mov     edx, 0                                  ; 0035 _ BA, 00000000
        mov     esi, 0                                  ; 003A _ BE, 00000000
        mov     rdi, rax                                ; 003F _ 48: 89. C7
        call    __isoc23_strtoumax                      ; 0042 _ E8, 00000000(PLT r)
        mov     qword [rbp-818H], rax                   ; 0047 _ 48: 89. 85, FFFFF7E8
        lea     rax, [rel ?_016]                        ; 004E _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 0055 _ 48: 89. C7
        call    puts                                    ; 0058 _ E8, 00000000(PLT r)
        lea     rax, [rel ?_017]                        ; 005D _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 0064 _ 48: 89. C7
        call    puts                                    ; 0067 _ E8, 00000000(PLT r)
        mov     dword [rbp-828H], 0                     ; 006C _ C7. 85, FFFFF7D8, 00000000
        jmp     ?_006                                   ; 0076 _ EB, 7D

?_001:  mov     eax, dword [rbp-828H]                   ; 0078 _ 8B. 85, FFFFF7D8
        cdqe                                            ; 007E _ 48: 98
        mov     qword [rbp-820H], rax                   ; 0080 _ 48: 89. 85, FFFFF7E0
        mov     dword [rbp-824H], 0                     ; 0087 _ C7. 85, FFFFF7DC, 00000000
        jmp     ?_005                                   ; 0091 _ EB, 3B

?_002:  mov     rax, qword [rbp-820H]                   ; 0093 _ 48: 8B. 85, FFFFF7E0
        shr     rax, 1                                  ; 009A _ 48: D1. E8
        mov     rdx, rax                                ; 009D _ 48: 89. C2
        mov     rax, qword [rbp-820H]                   ; 00A0 _ 48: 8B. 85, FFFFF7E0
        and     eax, 01H                                ; 00A7 _ 83. E0, 01
        test    rax, rax                                ; 00AA _ 48: 85. C0
        jz      ?_003                                   ; 00AD _ 74, 09
        mov     rax, qword [rbp-818H]                   ; 00AF _ 48: 8B. 85, FFFFF7E8
        jmp     ?_004                                   ; 00B6 _ EB, 05

?_003:  mov     eax, 0                                  ; 00B8 _ B8, 00000000
?_004:  xor     rax, rdx                                ; 00BD _ 48: 31. D0
        mov     qword [rbp-820H], rax                   ; 00C0 _ 48: 89. 85, FFFFF7E0
        add     dword [rbp-824H], 1                     ; 00C7 _ 83. 85, FFFFF7DC, 01
?_005:  cmp     dword [rbp-824H], 7                     ; 00CE _ 83. BD, FFFFF7DC, 07
        jle     ?_002                                   ; 00D5 _ 7E, BC
        mov     eax, dword [rbp-828H]                   ; 00D7 _ 8B. 85, FFFFF7D8
        cdqe                                            ; 00DD _ 48: 98
        mov     rdx, qword [rbp-820H]                   ; 00DF _ 48: 8B. 95, FFFFF7E0
        mov     qword [rbp+rax*8-810H], rdx             ; 00E6 _ 48: 89. 94 C5, FFFFF7F0
        add     dword [rbp-828H], 1                     ; 00EE _ 83. 85, FFFFF7D8, 01
?_006:  cmp     dword [rbp-828H], 255                   ; 00F5 _ 81. BD, FFFFF7D8, 000000FF
        jle     ?_001                                   ; 00FF _ 0F 8E, FFFFFF73
        mov     dword [rbp-828H], 0                     ; 0105 _ C7. 85, FFFFF7D8, 00000000
        jmp     ?_010                                   ; 010F _ EB, 62

?_007:  cmp     dword [rbp-828H], 254                   ; 0111 _ 81. BD, FFFFF7D8, 000000FE
        jnz     ?_008                                   ; 011B _ 75, 09
        lea     rax, [rel ?_018]                        ; 011D _ 48: 8D. 05, 00000000(rel)
        jmp     ?_009                                   ; 0124 _ EB, 07

?_008:  lea     rax, [rel ?_019]                        ; 0126 _ 48: 8D. 05, 00000000(rel)
?_009:  mov     edx, dword [rbp-828H]                   ; 012D _ 8B. 95, FFFFF7D8
        add     edx, 1                                  ; 0133 _ 83. C2, 01
        movsxd  rdx, edx                                ; 0136 _ 48: 63. D2
        mov     rcx, qword [rbp+rdx*8-810H]             ; 0139 _ 48: 8B. 8C D5, FFFFF7F0
        mov     edx, dword [rbp-828H]                   ; 0141 _ 8B. 95, FFFFF7D8
        movsxd  rdx, edx                                ; 0147 _ 48: 63. D2
        mov     rdx, qword [rbp+rdx*8-810H]             ; 014A _ 48: 8B. 94 D5, FFFFF7F0
        mov     esi, dword [rbp-828H]                   ; 0152 _ 8B. B5, FFFFF7D8
        lea     rdi, [rel ?_020]                        ; 0158 _ 48: 8D. 3D, 00000000(rel)
        mov     r8, rax                                 ; 015F _ 49: 89. C0
        mov     eax, 0                                  ; 0162 _ B8, 00000000
        call    printf                                  ; 0167 _ E8, 00000000(PLT r)
        add     dword [rbp-828H], 2                     ; 016C _ 83. 85, FFFFF7D8, 02
?_010:  cmp     dword [rbp-828H], 255                   ; 0173 _ 81. BD, FFFFF7D8, 000000FF
        jle     ?_007                                   ; 017D _ 7E, 92
        lea     rax, [rel ?_021]                        ; 017F _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 0186 _ 48: 89. C7
        call    puts                                    ; 0189 _ E8, 00000000(PLT r)
        lea     rax, [rel ?_022]                        ; 018E _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 0195 _ 48: 89. C7
        call    puts                                    ; 0198 _ E8, 00000000(PLT r)
        lea     rax, [rel ?_023]                        ; 019D _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 01A4 _ 48: 89. C7
        call    puts                                    ; 01A7 _ E8, 00000000(PLT r)
        mov     dword [rbp-828H], 0                     ; 01AC _ C7. 85, FFFFF7D8, 00000000
        jmp     ?_014                                   ; 01B6 _ E9, 000000A5

?_011:  cmp     dword [rbp-828H], 254                   ; 01BB _ 81. BD, FFFFF7D8, 000000FE
        jnz     ?_012                                   ; 01C5 _ 75, 09
        lea     rax, [rel ?_018]                        ; 01C7 _ 48: 8D. 05, 00000000(rel)
        jmp     ?_013                                   ; 01CE _ EB, 07

?_012:  lea     rax, [rel ?_019]                        ; 01D0 _ 48: 8D. 05, 00000000(rel)
?_013:  mov     edx, dword [rbp-828H]                   ; 01D7 _ 8B. 95, FFFFF7D8
        add     edx, 1                                  ; 01DD _ 83. C2, 01
        movsxd  rdx, edx                                ; 01E0 _ 48: 63. D2
        mov     rdx, qword [rbp+rdx*8-810H]             ; 01E3 _ 48: 8B. 94 D5, FFFFF7F0
        mov     r8d, edx                                ; 01EB _ 41: 89. D0
        mov     edx, dword [rbp-828H]                   ; 01EE _ 8B. 95, FFFFF7D8
        add     edx, 1                                  ; 01F4 _ 83. C2, 01
        movsxd  rdx, edx                                ; 01F7 _ 48: 63. D2
        mov     rdx, qword [rbp+rdx*8-810H]             ; 01FA _ 48: 8B. 94 D5, FFFFF7F0
        shr     rdx, 32                                 ; 0202 _ 48: C1. EA, 20
        mov     ecx, edx                                ; 0206 _ 89. D1
        mov     edx, dword [rbp-828H]                   ; 0208 _ 8B. 95, FFFFF7D8
        movsxd  rdx, edx                                ; 020E _ 48: 63. D2
        mov     rdx, qword [rbp+rdx*8-810H]             ; 0211 _ 48: 8B. 94 D5, FFFFF7F0
        mov     r10d, edx                               ; 0219 _ 41: 89. D2
        mov     edx, dword [rbp-828H]                   ; 021C _ 8B. 95, FFFFF7D8
        movsxd  rdx, edx                                ; 0222 _ 48: 63. D2
        mov     rdx, qword [rbp+rdx*8-810H]             ; 0225 _ 48: 8B. 94 D5, FFFFF7F0
        shr     rdx, 32                                 ; 022D _ 48: C1. EA, 20
        mov     esi, edx                                ; 0231 _ 89. D6
        lea     rdi, [rel ?_024]                        ; 0233 _ 48: 8D. 3D, 00000000(rel)
        sub     rsp, 8                                  ; 023A _ 48: 83. EC, 08
        mov     edx, dword [rbp-828H]                   ; 023E _ 8B. 95, FFFFF7D8
        push    rdx                                     ; 0244 _ 52
        mov     r9, rax                                 ; 0245 _ 49: 89. C1
        mov     edx, r10d                               ; 0248 _ 44: 89. D2
        mov     eax, 0                                  ; 024B _ B8, 00000000
        call    printf                                  ; 0250 _ E8, 00000000(PLT r)
        add     rsp, 16                                 ; 0255 _ 48: 83. C4, 10
        add     dword [rbp-828H], 2                     ; 0259 _ 83. 85, FFFFF7D8, 02
?_014:  cmp     dword [rbp-828H], 255                   ; 0260 _ 81. BD, FFFFF7D8, 000000FF
        jle     ?_011                                   ; 026A _ 0F 8E, FFFFFF4B
        lea     rax, [rel ?_025]                        ; 0270 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 0277 _ 48: 89. C7
        call    puts                                    ; 027A _ E8, 00000000(PLT r)
        mov     eax, 0                                  ; 027F _ B8, 00000000
        mov     rdx, qword [rbp-8H]                     ; 0284 _ 48: 8B. 55, F8
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        sub     rdx, qword [fs:abs 28H]                 ; 0288 _ 64 48: 2B. 14 25, 00000028
        jz      ?_015                                   ; 0291 _ 74, 05
        call    __stack_chk_fail                        ; 0293 _ E8, 00000000(PLT r)
?_015:  leave                                           ; 0298 _ C9
        ret                                             ; 0299 _ C3
; main End of function


SECTION .data   align=1 noexec                          ; section number 2, data


SECTION .bss    align=1 noexec                          ; section number 3, bss


SECTION .rodata align=8 noexec                          ; section number 4, const

?_016:                                                  ; byte
        db 2FH, 2AH, 20H, 43H, 20H, 2AH, 2FH, 00H       ; 0000 _ /* C */.

?_017:                                                  ; byte
        db 73H, 74H, 61H, 74H, 69H, 63H, 20H, 63H       ; 0008 _ static c
        db 6FH, 6EH, 73H, 74H, 20H, 75H, 69H, 6EH       ; 0010 _ onst uin
        db 74H, 36H, 34H, 5FH, 74H, 20H, 63H, 72H       ; 0018 _ t64_t cr
        db 63H, 36H, 34H, 5FH, 74H, 61H, 62H, 5BH       ; 0020 _ c64_tab[
        db 32H, 35H, 36H, 5DH, 20H, 3DH, 20H, 7BH       ; 0028 _ 256] = {
        db 00H                                          ; 0030 _ .

?_018:                                                  ; byte
        db 00H                                          ; 0031 _ .

?_019:                                                  ; byte
        db 2CH, 00H, 00H, 00H, 00H, 00H                 ; 0032 _ ,.....

?_020:                                                  ; byte
        db 20H, 20H, 20H, 20H, 2FH, 2AH, 20H, 25H       ; 0038 _     /* %
        db 30H, 32H, 78H, 20H, 2AH, 2FH, 20H, 55H       ; 0040 _ 02x */ U
        db 49H, 4EH, 54H, 36H, 34H, 5FH, 43H, 28H       ; 0048 _ INT64_C(
        db 30H, 78H, 25H, 30H, 31H, 36H, 6CH, 78H       ; 0050 _ 0x%016lx
        db 29H, 2CH, 20H, 55H, 49H, 4EH, 54H, 36H       ; 0058 _ ), UINT6
        db 34H, 5FH, 43H, 28H, 30H, 78H, 25H, 30H       ; 0060 _ 4_C(0x%0
        db 31H, 36H, 6CH, 78H, 29H, 25H, 73H, 0AH       ; 0068 _ 16lx)%s.
        db 00H                                          ; 0070 _ .

?_021:                                                  ; byte
        db 7DH, 3BH, 0AH, 00H                           ; 0071 _ };..

?_022:                                                  ; byte
        db 23H, 20H, 70H, 65H, 72H, 6CH, 00H            ; 0075 _ # perl.

?_023:                                                  ; byte
        db 40H, 63H, 72H, 63H, 36H, 34H, 5FH, 74H       ; 007C _ @crc64_t
        db 61H, 62H, 20H, 3DH, 20H, 28H, 00H, 00H       ; 0084 _ ab = (..
        db 00H, 00H, 00H, 00H                           ; 008C _ ....

?_024:                                                  ; byte
        db 20H, 20H, 20H, 20H, 5BH, 30H, 78H, 25H       ; 0090 _     [0x%
        db 30H, 38H, 78H, 2CH, 20H, 30H, 78H, 25H       ; 0098 _ 08x, 0x%
        db 30H, 38H, 78H, 5DH, 2CH, 20H, 5BH, 30H       ; 00A0 _ 08x], [0
        db 78H, 25H, 30H, 38H, 78H, 2CH, 20H, 30H       ; 00A8 _ x%08x, 0
        db 78H, 25H, 30H, 38H, 78H, 5DH, 25H, 2DH       ; 00B0 _ x%08x]%-
        db 31H, 73H, 20H, 20H, 20H, 20H, 23H, 20H       ; 00B8 _ 1s    # 
        db 25H, 30H, 32H, 78H, 0AH, 00H                 ; 00C0 _ %02x..

?_025:                                                  ; byte
        db 29H, 3BH, 00H                                ; 00C6 _ );.


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
        dd main-$-20H                                   ; 0020 _ 00000000 (rel)
        dd 0000029AH, 100E4100H                         ; 0024 _ 666 269369600 
        dd 0D430286H, 02950306H                         ; 002C _ 222495366 43320070 
        dd 0008070CH                                    ; 0034 _ 526092 


