; Disassembly of file: /tmp/tmp.4fSsCeEicy.o
; Wed Sep 23 14:43:29 2026
; Type: ELF64
; Syntax: NASM
; Instruction set: 80386, x64

default rel

global main: function
global progname
global c_names
global c_lsegs
global c_groups
global c_extsym

extern fclose                                           ; near
extern perror                                           ; near
extern fopen                                            ; near
extern fwrite                                           ; near
extern stdout                                           ; qword
extern feof                                             ; near
extern free                                             ; near
extern ferror                                           ; near
extern fread                                            ; near
extern rewind                                           ; near
extern ftell                                            ; near
extern fseek                                            ; near
extern __stack_chk_fail                                 ; near
extern puts                                             ; near
extern putchar                                          ; near
extern __ctype_b_loc                                    ; near
extern printf                                           ; near
extern memcpy                                           ; near
extern realloc                                          ; near
extern malloc                                           ; near
extern exit                                             ; near
extern fprintf                                          ; near
extern stderr                                           ; qword


SECTION .text   align=1 exec                            ; section number 1, code

nulldie:; Local function
        push    rbp                                     ; 0000 _ 55
        mov     rbp, rsp                                ; 0001 _ 48: 89. E5
        sub     rsp, 16                                 ; 0004 _ 48: 83. EC, 10
        mov     qword [rbp-8H], rdi                     ; 0008 _ 48: 89. 7D, F8
        cmp     qword [rbp-8H], 0                       ; 000C _ 48: 83. 7D, F8, 00
        setne   al                                      ; 0011 _ 0F 95. C0
        movzx   eax, al                                 ; 0014 _ 0F B6. C0
        test    rax, rax                                ; 0017 _ 48: 85. C0
        jz      ?_001                                   ; 001A _ 74, 06
        mov     rax, qword [rbp-8H]                     ; 001C _ 48: 8B. 45, F8
        jmp     ?_002                                   ; 0020 _ EB, 2F

?_001:  mov     rdx, qword [rel progname]               ; 0022 _ 48: 8B. 15, 00000000(rel)
        mov     rax, qword [rel stderr]                 ; 0029 _ 48: 8B. 05, 00000000(rel)
        lea     rcx, [rel ?_150]                        ; 0030 _ 48: 8D. 0D, 00000000(rel)
        mov     rsi, rcx                                ; 0037 _ 48: 89. CE
        mov     rdi, rax                                ; 003A _ 48: 89. C7
        mov     eax, 0                                  ; 003D _ B8, 00000000
        call    fprintf                                 ; 0042 _ E8, 00000000(PLT r)
        mov     edi, 1                                  ; 0047 _ BF, 00000001
        call    exit                                    ; 004C _ E8, 00000000(PLT r)
?_002:  leave                                           ; 0051 _ C9
        ret                                             ; 0052 _ C3

xmalloc:; Local function
        push    rbp                                     ; 0053 _ 55
        mov     rbp, rsp                                ; 0054 _ 48: 89. E5
        sub     rsp, 16                                 ; 0057 _ 48: 83. EC, 10
        mov     qword [rbp-8H], rdi                     ; 005B _ 48: 89. 7D, F8
        mov     rax, qword [rbp-8H]                     ; 005F _ 48: 8B. 45, F8
        mov     rdi, rax                                ; 0063 _ 48: 89. C7
        call    malloc                                  ; 0066 _ E8, 00000000(PLT r)
        mov     rdi, rax                                ; 006B _ 48: 89. C7
        call    nulldie                                 ; 006E _ E8, FFFFFF8D
        leave                                           ; 0073 _ C9
        ret                                             ; 0074 _ C3

xrealloc:; Local function
        push    rbp                                     ; 0075 _ 55
        mov     rbp, rsp                                ; 0076 _ 48: 89. E5
        sub     rsp, 16                                 ; 0079 _ 48: 83. EC, 10
        mov     qword [rbp-8H], rdi                     ; 007D _ 48: 89. 7D, F8
        mov     qword [rbp-10H], rsi                    ; 0081 _ 48: 89. 75, F0
        mov     rdx, qword [rbp-10H]                    ; 0085 _ 48: 8B. 55, F0
        mov     rax, qword [rbp-8H]                     ; 0089 _ 48: 8B. 45, F8
        mov     rsi, rdx                                ; 008D _ 48: 89. D6
        mov     rdi, rax                                ; 0090 _ 48: 89. C7
        call    realloc                                 ; 0093 _ E8, 00000000(PLT r)
        mov     rdi, rax                                ; 0098 _ 48: 89. C7
        call    nulldie                                 ; 009B _ E8, FFFFFF60
        leave                                           ; 00A0 _ C9
        ret                                             ; 00A1 _ C3

expand_buffer:; Local function
        push    rbp                                     ; 00A2 _ 55
        mov     rbp, rsp                                ; 00A3 _ 48: 89. E5
        sub     rsp, 48                                 ; 00A6 _ 48: 83. EC, 30
        mov     qword [rbp-18H], rdi                    ; 00AA _ 48: 89. 7D, E8
        mov     qword [rbp-20H], rsi                    ; 00AE _ 48: 89. 75, E0
        mov     qword [rbp-28H], rdx                    ; 00B2 _ 48: 89. 55, D8
        mov     qword [rbp-30H], rcx                    ; 00B6 _ 48: 89. 4D, D0
        mov     rax, qword [rbp-20H]                    ; 00BA _ 48: 8B. 45, E0
        mov     rax, qword [rax]                        ; 00BE _ 48: 8B. 00
        mov     qword [rbp-8H], rax                     ; 00C1 _ 48: 89. 45, F8
        mov     rax, qword [rbp-8H]                     ; 00C5 _ 48: 8B. 45, F8
        cmp     qword [rbp-28H], rax                    ; 00C9 _ 48: 39. 45, D8
        setb    al                                      ; 00CD _ 0F 92. C0
        movzx   eax, al                                 ; 00D0 _ 0F B6. C0
        test    rax, rax                                ; 00D3 _ 48: 85. C0
        jz      ?_003                                   ; 00D6 _ 74, 06
        mov     rax, qword [rbp-18H]                    ; 00D8 _ 48: 8B. 45, E8
        jmp     ?_007                                   ; 00DC _ EB, 5C

?_003:  cmp     qword [rbp-8H], 8191                    ; 00DE _ 48: 81. 7D, F8, 00001FFF
        ja      ?_004                                   ; 00E6 _ 77, 0A
        mov     qword [rbp-8H], 8192                    ; 00E8 _ 48: C7. 45, F8, 00002000
        jmp     ?_005                                   ; 00F0 _ EB, 04

?_004:  shl     qword [rbp-8H], 1                       ; 00F2 _ 48: D1. 65, F8
?_005:  mov     rax, qword [rbp-8H]                     ; 00F6 _ 48: 8B. 45, F8
        cmp     qword [rbp-28H], rax                    ; 00FA _ 48: 39. 45, D8
        jc      ?_006                                   ; 00FE _ 72, 0C
        mov     rax, qword [rbp-28H]                    ; 0100 _ 48: 8B. 45, D8
        add     rax, 1                                  ; 0104 _ 48: 83. C0, 01
        mov     qword [rbp-8H], rax                     ; 0108 _ 48: 89. 45, F8
?_006:  mov     rax, qword [rbp-8H]                     ; 010C _ 48: 8B. 45, F8
        imul    rax, qword [rbp-30H]                    ; 0110 _ 48: 0F AF. 45, D0
        mov     rdx, rax                                ; 0115 _ 48: 89. C2
        mov     rax, qword [rbp-18H]                    ; 0118 _ 48: 8B. 45, E8
        mov     rsi, rdx                                ; 011C _ 48: 89. D6
        mov     rdi, rax                                ; 011F _ 48: 89. C7
        call    xrealloc                                ; 0122 _ E8, FFFFFF4E
        mov     qword [rbp-18H], rax                    ; 0127 _ 48: 89. 45, E8
        mov     rax, qword [rbp-20H]                    ; 012B _ 48: 8B. 45, E0
        mov     rdx, qword [rbp-8H]                     ; 012F _ 48: 8B. 55, F8
        mov     qword [rax], rdx                        ; 0133 _ 48: 89. 10
        mov     rax, qword [rbp-18H]                    ; 0136 _ 48: 8B. 45, E8
?_007:  leave                                           ; 013A _ C9
        ret                                             ; 013B _ C3

add_collection:; Local function
        push    rbp                                     ; 013C _ 55
        mov     rbp, rsp                                ; 013D _ 48: 89. E5
        sub     rsp, 16                                 ; 0140 _ 48: 83. EC, 10
        mov     qword [rbp-8H], rdi                     ; 0144 _ 48: 89. 7D, F8
        mov     qword [rbp-10H], rsi                    ; 0148 _ 48: 89. 75, F0
        mov     rax, qword [rbp-8H]                     ; 014C _ 48: 8B. 45, F8
        mov     rdx, qword [rax]                        ; 0150 _ 48: 8B. 10
        mov     rax, qword [rbp-8H]                     ; 0153 _ 48: 8B. 45, F8
        lea     rsi, [rax+8H]                           ; 0157 _ 48: 8D. 70, 08
        mov     rax, qword [rbp-8H]                     ; 015B _ 48: 8B. 45, F8
        mov     rax, qword [rax+10H]                    ; 015F _ 48: 8B. 40, 10
        mov     ecx, 8                                  ; 0163 _ B9, 00000008
        mov     rdi, rax                                ; 0168 _ 48: 89. C7
        call    expand_buffer                           ; 016B _ E8, FFFFFF32
        mov     rdx, qword [rbp-8H]                     ; 0170 _ 48: 8B. 55, F8
        mov     qword [rdx+10H], rax                    ; 0174 _ 48: 89. 42, 10
        mov     rax, qword [rbp-8H]                     ; 0178 _ 48: 8B. 45, F8
        mov     rsi, qword [rax+10H]                    ; 017C _ 48: 8B. 70, 10
        mov     rax, qword [rbp-8H]                     ; 0180 _ 48: 8B. 45, F8
        mov     rax, qword [rax]                        ; 0184 _ 48: 8B. 00
        lea     rcx, [rax+1H]                           ; 0187 _ 48: 8D. 48, 01
        mov     rdx, qword [rbp-8H]                     ; 018B _ 48: 8B. 55, F8
        mov     qword [rdx], rcx                        ; 018F _ 48: 89. 0A
        shl     rax, 3                                  ; 0192 _ 48: C1. E0, 03
        lea     rdx, [rsi+rax]                          ; 0196 _ 48: 8D. 14 06
        mov     rax, qword [rbp-10H]                    ; 019A _ 48: 8B. 45, F0
        mov     qword [rdx], rax                        ; 019E _ 48: 89. 02
        nop                                             ; 01A1 _ 90
        leave                                           ; 01A2 _ C9
        ret                                             ; 01A3 _ C3

get_collection:; Local function
        push    rbp                                     ; 01A4 _ 55
        mov     rbp, rsp                                ; 01A5 _ 48: 89. E5
        mov     qword [rbp-8H], rdi                     ; 01A8 _ 48: 89. 7D, F8
        mov     qword [rbp-10H], rsi                    ; 01AC _ 48: 89. 75, F0
        mov     qword [rbp-18H], rdx                    ; 01B0 _ 48: 89. 55, E8
        cmp     qword [rbp-10H], 0                      ; 01B4 _ 48: 83. 7D, F0, 00
        jz      ?_008                                   ; 01B9 _ 74, 0D
        mov     rax, qword [rbp-8H]                     ; 01BB _ 48: 8B. 45, F8
        mov     rax, qword [rax]                        ; 01BF _ 48: 8B. 00
        cmp     rax, qword [rbp-10H]                    ; 01C2 _ 48: 3B. 45, F0
        jnc     ?_009                                   ; 01C6 _ 73, 06
?_008:  mov     rax, qword [rbp-18H]                    ; 01C8 _ 48: 8B. 45, E8
        jmp     ?_010                                   ; 01CC _ EB, 1A

?_009:  mov     rax, qword [rbp-8H]                     ; 01CE _ 48: 8B. 45, F8
        mov     rax, qword [rax+10H]                    ; 01D2 _ 48: 8B. 40, 10
        mov     rdx, qword [rbp-10H]                    ; 01D6 _ 48: 8B. 55, F0
        shl     rdx, 3                                  ; 01DA _ 48: C1. E2, 03
        sub     rdx, 8                                  ; 01DE _ 48: 83. EA, 08
        add     rax, rdx                                ; 01E2 _ 48: 01. D0
        mov     rax, qword [rax]                        ; 01E5 _ 48: 8B. 00
?_010:  pop     rbp                                     ; 01E8 _ 5D
        ret                                             ; 01E9 _ C3

copy_name:; Local function
        push    rbp                                     ; 01EA _ 55
        mov     rbp, rsp                                ; 01EB _ 48: 89. E5
        sub     rsp, 32                                 ; 01EE _ 48: 83. EC, 20
        mov     qword [rbp-18H], rdi                    ; 01F2 _ 48: 89. 7D, E8
        mov     qword [rbp-20H], rsi                    ; 01F6 _ 48: 89. 75, E0
        mov     rax, qword [rbp-18H]                    ; 01FA _ 48: 8B. 45, E8
        add     rax, 1                                  ; 01FE _ 48: 83. C0, 01
        mov     rdi, rax                                ; 0202 _ 48: 89. C7
        call    xmalloc                                 ; 0205 _ E8, FFFFFE49
        mov     qword [rbp-8H], rax                     ; 020A _ 48: 89. 45, F8
        mov     rdx, qword [rbp-18H]                    ; 020E _ 48: 8B. 55, E8
        mov     rcx, qword [rbp-20H]                    ; 0212 _ 48: 8B. 4D, E0
        mov     rax, qword [rbp-8H]                     ; 0216 _ 48: 8B. 45, F8
        mov     rsi, rcx                                ; 021A _ 48: 89. CE
        mov     rdi, rax                                ; 021D _ 48: 89. C7
        call    memcpy                                  ; 0220 _ E8, 00000000(PLT r)
        mov     rdx, qword [rbp-8H]                     ; 0225 _ 48: 8B. 55, F8
        mov     rax, qword [rbp-18H]                    ; 0229 _ 48: 8B. 45, E8
        add     rax, rdx                                ; 022D _ 48: 01. D0
        mov     byte [rax], 0                           ; 0230 _ C6. 00, 00
        mov     rax, qword [rbp-8H]                     ; 0233 _ 48: 8B. 45, F8
        leave                                           ; 0237 _ C9
        ret                                             ; 0238 _ C3

hexdump_data:; Local function
        push    rbp                                     ; 0239 _ 55
        mov     rbp, rsp                                ; 023A _ 48: 89. E5
        sub     rsp, 48                                 ; 023D _ 48: 83. EC, 30
        mov     dword [rbp-14H], edi                    ; 0241 _ 89. 7D, EC
        mov     qword [rbp-20H], rsi                    ; 0244 _ 48: 89. 75, E0
        mov     qword [rbp-28H], rdx                    ; 0248 _ 48: 89. 55, D8
        mov     qword [rbp-30H], rcx                    ; 024C _ 48: 89. 4D, D0
        mov     dword [rbp-8H], 0                       ; 0250 _ C7. 45, F8, 00000000
        jmp     ?_025                                   ; 0257 _ E9, 00000187

?_011:  mov     edx, dword [rbp-8H]                     ; 025C _ 8B. 55, F8
        mov     eax, dword [rbp-14H]                    ; 025F _ 8B. 45, EC
        add     edx, eax                                ; 0262 _ 01. C2
        lea     rax, [rel ?_151]                        ; 0264 _ 48: 8D. 05, 00000000(rel)
        mov     esi, edx                                ; 026B _ 89. D6
        mov     rdi, rax                                ; 026D _ 48: 89. C7
        mov     eax, 0                                  ; 0270 _ B8, 00000000
        call    printf                                  ; 0275 _ E8, 00000000(PLT r)
        mov     dword [rbp-4H], 0                       ; 027A _ C7. 45, FC, 00000000
        jmp     ?_018                                   ; 0281 _ E9, 00000097

?_012:  cmp     dword [rbp-4H], 7                       ; 0286 _ 83. 7D, FC, 07
        jnz     ?_013                                   ; 028A _ 75, 06
        mov     byte [rbp-9H], 45                       ; 028C _ C6. 45, F7, 2D
        jmp     ?_014                                   ; 0290 _ EB, 04

?_013:  mov     byte [rbp-9H], 32                       ; 0292 _ C6. 45, F7, 20
?_014:  mov     edx, dword [rbp-8H]                     ; 0296 _ 8B. 55, F8
        mov     eax, dword [rbp-4H]                     ; 0299 _ 8B. 45, FC
        add     eax, edx                                ; 029C _ 01. D0
        mov     eax, eax                                ; 029E _ 89. C0
        cmp     rax, qword [rbp-28H]                    ; 02A0 _ 48: 3B. 45, D8
        jc      ?_015                                   ; 02A4 _ 72, 16
        lea     rax, [rel ?_152]                        ; 02A6 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 02AD _ 48: 89. C7
        mov     eax, 0                                  ; 02B0 _ B8, 00000000
        call    printf                                  ; 02B5 _ E8, 00000000(PLT r)
        jmp     ?_017                                   ; 02BA _ EB, 5D

?_015:  mov     edx, dword [rbp-8H]                     ; 02BC _ 8B. 55, F8
        mov     eax, dword [rbp-4H]                     ; 02BF _ 8B. 45, FC
        add     eax, edx                                ; 02C2 _ 01. D0
        mov     eax, eax                                ; 02C4 _ 89. C0
        cmp     rax, qword [rbp-30H]                    ; 02C6 _ 48: 3B. 45, D0
        jnc     ?_016                                   ; 02CA _ 73, 33
        movsx   edx, byte [rbp-9H]                      ; 02CC _ 0F BE. 55, F7
        mov     ecx, dword [rbp-8H]                     ; 02D0 _ 8B. 4D, F8
        mov     eax, dword [rbp-4H]                     ; 02D3 _ 8B. 45, FC
        add     eax, ecx                                ; 02D6 _ 01. C8
        mov     ecx, eax                                ; 02D8 _ 89. C1
        mov     rax, qword [rbp-20H]                    ; 02DA _ 48: 8B. 45, E0
        add     rax, rcx                                ; 02DE _ 48: 01. C8
        movzx   eax, byte [rax]                         ; 02E1 _ 0F B6. 00
        movzx   eax, al                                 ; 02E4 _ 0F B6. C0
        lea     rcx, [rel ?_153]                        ; 02E7 _ 48: 8D. 0D, 00000000(rel)
        mov     esi, eax                                ; 02EE _ 89. C6
        mov     rdi, rcx                                ; 02F0 _ 48: 89. CF
        mov     eax, 0                                  ; 02F3 _ B8, 00000000
        call    printf                                  ; 02F8 _ E8, 00000000(PLT r)
        jmp     ?_017                                   ; 02FD _ EB, 1A

?_016:  movsx   eax, byte [rbp-9H]                      ; 02FF _ 0F BE. 45, F7
        lea     rdx, [rel ?_154]                        ; 0303 _ 48: 8D. 15, 00000000(rel)
        mov     esi, eax                                ; 030A _ 89. C6
        mov     rdi, rdx                                ; 030C _ 48: 89. D7
        mov     eax, 0                                  ; 030F _ B8, 00000000
        call    printf                                  ; 0314 _ E8, 00000000(PLT r)
?_017:  add     dword [rbp-4H], 1                       ; 0319 _ 83. 45, FC, 01
?_018:  cmp     dword [rbp-4H], 15                      ; 031D _ 83. 7D, FC, 0F
        jbe     ?_012                                   ; 0321 _ 0F 86, FFFFFF5F
        lea     rax, [rel ?_155]                        ; 0327 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 032E _ 48: 89. C7
        mov     eax, 0                                  ; 0331 _ B8, 00000000
        call    printf                                  ; 0336 _ E8, 00000000(PLT r)
        mov     dword [rbp-4H], 0                       ; 033B _ C7. 45, FC, 00000000
        jmp     ?_024                                   ; 0342 _ E9, 00000084

?_019:  mov     edx, dword [rbp-8H]                     ; 0347 _ 8B. 55, F8
        mov     eax, dword [rbp-4H]                     ; 034A _ 8B. 45, FC
        add     eax, edx                                ; 034D _ 01. D0
        mov     eax, eax                                ; 034F _ 89. C0
        cmp     rax, qword [rbp-28H]                    ; 0351 _ 48: 3B. 45, D8
        jnc     ?_023                                   ; 0355 _ 73, 70
        mov     edx, dword [rbp-8H]                     ; 0357 _ 8B. 55, F8
        mov     eax, dword [rbp-4H]                     ; 035A _ 8B. 45, FC
        add     eax, edx                                ; 035D _ 01. D0
        mov     eax, eax                                ; 035F _ 89. C0
        cmp     rax, qword [rbp-30H]                    ; 0361 _ 48: 3B. 45, D0
        jnc     ?_021                                   ; 0365 _ 73, 54
        call    __ctype_b_loc                           ; 0367 _ E8, 00000000(PLT r)
        mov     rax, qword [rax]                        ; 036C _ 48: 8B. 00
        mov     ecx, dword [rbp-8H]                     ; 036F _ 8B. 4D, F8
        mov     edx, dword [rbp-4H]                     ; 0372 _ 8B. 55, FC
        add     edx, ecx                                ; 0375 _ 01. CA
        mov     ecx, edx                                ; 0377 _ 89. D1
        mov     rdx, qword [rbp-20H]                    ; 0379 _ 48: 8B. 55, E0
        add     rdx, rcx                                ; 037D _ 48: 01. CA
        movzx   edx, byte [rdx]                         ; 0380 _ 0F B6. 12
        movzx   edx, dl                                 ; 0383 _ 0F B6. D2
        add     rdx, rdx                                ; 0386 _ 48: 01. D2
        add     rax, rdx                                ; 0389 _ 48: 01. D0
        movzx   eax, word [rax]                         ; 038C _ 0F B7. 00
        movzx   eax, ax                                 ; 038F _ 0F B7. C0
        and     eax, 4000H                              ; 0392 _ 25, 00004000
        test    eax, eax                                ; 0397 _ 85. C0
        jz      ?_020                                   ; 0399 _ 74, 19
        mov     edx, dword [rbp-8H]                     ; 039B _ 8B. 55, F8
        mov     eax, dword [rbp-4H]                     ; 039E _ 8B. 45, FC
        add     eax, edx                                ; 03A1 _ 01. D0
        mov     edx, eax                                ; 03A3 _ 89. C2
        mov     rax, qword [rbp-20H]                    ; 03A5 _ 48: 8B. 45, E0
        add     rax, rdx                                ; 03A9 _ 48: 01. D0
        movzx   eax, byte [rax]                         ; 03AC _ 0F B6. 00
        movzx   eax, al                                 ; 03AF _ 0F B6. C0
        jmp     ?_022                                   ; 03B2 _ EB, 0C

?_020:  mov     eax, 46                                 ; 03B4 _ B8, 0000002E
        jmp     ?_022                                   ; 03B9 _ EB, 05

?_021:  mov     eax, 120                                ; 03BB _ B8, 00000078
?_022:  mov     edi, eax                                ; 03C0 _ 89. C7
        call    putchar                                 ; 03C2 _ E8, 00000000(PLT r)
?_023:  add     dword [rbp-4H], 1                       ; 03C7 _ 83. 45, FC, 01
?_024:  cmp     dword [rbp-4H], 15                      ; 03CB _ 83. 7D, FC, 0F
        jbe     ?_019                                   ; 03CF _ 0F 86, FFFFFF72
        mov     edi, 10                                 ; 03D5 _ BF, 0000000A
        call    putchar                                 ; 03DA _ E8, 00000000(PLT r)
        add     dword [rbp-8H], 16                      ; 03DF _ 83. 45, F8, 10
?_025:  mov     eax, dword [rbp-8H]                     ; 03E3 _ 8B. 45, F8
        cmp     rax, qword [rbp-28H]                    ; 03E6 _ 48: 3B. 45, D8
        jc      ?_011                                   ; 03EA _ 0F 82, FFFFFE6C
        nop                                             ; 03F0 _ 90
        nop                                             ; 03F1 _ 90
        leave                                           ; 03F2 _ C9
        ret                                             ; 03F3 _ C3

dump_unknown:; Local function
        push    rbp                                     ; 03F4 _ 55
        mov     rbp, rsp                                ; 03F5 _ 48: 89. E5
        sub     rsp, 32                                 ; 03F8 _ 48: 83. EC, 20
        mov     byte [rbp-1H], dil                      ; 03FC _ 40: 88. 7D, FF
        mov     qword [rbp-10H], rsi                    ; 0400 _ 48: 89. 75, F0
        mov     qword [rbp-18H], rdx                    ; 0404 _ 48: 89. 55, E8
        mov     rcx, qword [rbp-18H]                    ; 0408 _ 48: 8B. 4D, E8
        mov     rdx, qword [rbp-18H]                    ; 040C _ 48: 8B. 55, E8
        mov     rax, qword [rbp-10H]                    ; 0410 _ 48: 8B. 45, F0
        mov     rsi, rax                                ; 0414 _ 48: 89. C6
        mov     edi, 0                                  ; 0417 _ BF, 00000000
        call    hexdump_data                            ; 041C _ E8, FFFFFE18
        nop                                             ; 0421 _ 90
        leave                                           ; 0422 _ C9
        ret                                             ; 0423 _ C3

print_dostime:; Local function
        push    rbp                                     ; 0424 _ 55
        mov     rbp, rsp                                ; 0425 _ 48: 89. E5
        sub     rsp, 32                                 ; 0428 _ 48: 83. EC, 20
        mov     qword [rbp-18H], rdi                    ; 042C _ 48: 89. 7D, E8
        mov     rax, qword [rbp-18H]                    ; 0430 _ 48: 8B. 45, E8
        add     rax, 3                                  ; 0434 _ 48: 83. C0, 03
        movzx   eax, byte [rax]                         ; 0438 _ 0F B6. 00
        movzx   eax, al                                 ; 043B _ 0F B6. C0
        shl     eax, 8                                  ; 043E _ C1. E0, 08
        mov     edx, eax                                ; 0441 _ 89. C2
        mov     rax, qword [rbp-18H]                    ; 0443 _ 48: 8B. 45, E8
        add     rax, 2                                  ; 0447 _ 48: 83. C0, 02
        movzx   eax, byte [rax]                         ; 044B _ 0F B6. 00
        movzx   eax, al                                 ; 044E _ 0F B6. C0
        add     eax, edx                                ; 0451 _ 01. D0
        mov     word [rbp-4H], ax                       ; 0453 _ 66: 89. 45, FC
        mov     rax, qword [rbp-18H]                    ; 0457 _ 48: 8B. 45, E8
        add     rax, 1                                  ; 045B _ 48: 83. C0, 01
        movzx   eax, byte [rax]                         ; 045F _ 0F B6. 00
        movzx   eax, al                                 ; 0462 _ 0F B6. C0
        shl     eax, 8                                  ; 0465 _ C1. E0, 08
        mov     edx, eax                                ; 0468 _ 89. C2
        mov     rax, qword [rbp-18H]                    ; 046A _ 48: 8B. 45, E8
        movzx   eax, byte [rax]                         ; 046E _ 0F B6. 00
        movzx   eax, al                                 ; 0471 _ 0F B6. C0
        add     eax, edx                                ; 0474 _ 01. D0
        mov     word [rbp-2H], ax                       ; 0476 _ 66: 89. 45, FE
        movzx   eax, word [rbp-2H]                      ; 047A _ 0F B7. 45, FE
        add     eax, eax                                ; 047E _ 01. C0
        and     eax, 3FH                                ; 0480 _ 83. E0, 3F
        mov     edi, eax                                ; 0483 _ 89. C7
        movzx   eax, word [rbp-2H]                      ; 0485 _ 0F B7. 45, FE
        shr     ax, 5                                   ; 0489 _ 66: C1. E8, 05
        movzx   eax, ax                                 ; 048D _ 0F B7. C0
        and     eax, 3FH                                ; 0490 _ 83. E0, 3F
        mov     r9d, eax                                ; 0493 _ 41: 89. C1
        movzx   eax, word [rbp-2H]                      ; 0496 _ 0F B7. 45, FE
        shr     ax, 11                                  ; 049A _ 66: C1. E8, 0B
        movzx   r8d, ax                                 ; 049E _ 44: 0F B7. C0
        movzx   eax, word [rbp-4H]                      ; 04A2 _ 0F B7. 45, FC
        and     eax, 1FH                                ; 04A6 _ 83. E0, 1F
        mov     ecx, eax                                ; 04A9 _ 89. C1
        movzx   eax, word [rbp-4H]                      ; 04AB _ 0F B7. 45, FC
        shr     ax, 5                                   ; 04AF _ 66: C1. E8, 05
        movzx   eax, ax                                 ; 04B3 _ 0F B7. C0
        and     eax, 0FH                                ; 04B6 _ 83. E0, 0F
        mov     edx, eax                                ; 04B9 _ 89. C2
        movzx   eax, word [rbp-4H]                      ; 04BB _ 0F B7. 45, FC
        shr     ax, 9                                   ; 04BF _ 66: C1. E8, 09
        movzx   eax, ax                                 ; 04C3 _ 0F B7. C0
        lea     esi, [rax+7BCH]                         ; 04C6 _ 8D. B0, 000007BC
        lea     rax, [rel ?_156]                        ; 04CC _ 48: 8D. 05, 00000000(rel)
        sub     rsp, 8                                  ; 04D3 _ 48: 83. EC, 08
        push    rdi                                     ; 04D7 _ 57
        mov     rdi, rax                                ; 04D8 _ 48: 89. C7
        mov     eax, 0                                  ; 04DB _ B8, 00000000
        call    printf                                  ; 04E0 _ E8, 00000000(PLT r)
        add     rsp, 16                                 ; 04E5 _ 48: 83. C4, 10
        nop                                             ; 04E9 _ 90
        leave                                           ; 04EA _ C9
        ret                                             ; 04EB _ C3

dump_coment_depfile:; Local function
        push    rbp                                     ; 04EC _ 55
        mov     rbp, rsp                                ; 04ED _ 48: 89. E5
        sub     rsp, 32                                 ; 04F0 _ 48: 83. EC, 20
        mov     byte [rbp-1H], dil                      ; 04F4 _ 40: 88. 7D, FF
        mov     qword [rbp-10H], rsi                    ; 04F8 _ 48: 89. 75, F0
        mov     qword [rbp-18H], rdx                    ; 04FC _ 48: 89. 55, E8
        cmp     qword [rbp-18H], 4                      ; 0500 _ 48: 83. 7D, E8, 04
        jbe     ?_026                                   ; 0505 _ 76, 62
        mov     rax, qword [rbp-10H]                    ; 0507 _ 48: 8B. 45, F0
        add     rax, 4                                  ; 050B _ 48: 83. C0, 04
        movzx   eax, byte [rax]                         ; 050F _ 0F B6. 00
        movzx   edx, al                                 ; 0512 _ 0F B6. D0
        mov     rax, qword [rbp-18H]                    ; 0515 _ 48: 8B. 45, E8
        sub     rax, 5                                  ; 0519 _ 48: 83. E8, 05
        cmp     rdx, rax                                ; 051D _ 48: 39. C2
        jnz     ?_026                                   ; 0520 _ 75, 47
        lea     rax, [rel ?_157]                        ; 0522 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 0529 _ 48: 89. C7
        mov     eax, 0                                  ; 052C _ B8, 00000000
        call    printf                                  ; 0531 _ E8, 00000000(PLT r)
        mov     rax, qword [rbp-10H]                    ; 0536 _ 48: 8B. 45, F0
        mov     rdi, rax                                ; 053A _ 48: 89. C7
        call    print_dostime                           ; 053D _ E8, FFFFFEE2
        mov     rax, qword [rbp-10H]                    ; 0542 _ 48: 8B. 45, F0
        lea     rdx, [rax+5H]                           ; 0546 _ 48: 8D. 50, 05
        mov     rax, qword [rbp-18H]                    ; 054A _ 48: 8B. 45, E8
        sub     eax, 5                                  ; 054E _ 83. E8, 05
        mov     ecx, eax                                ; 0551 _ 89. C1
        lea     rax, [rel ?_158]                        ; 0553 _ 48: 8D. 05, 00000000(rel)
        mov     esi, ecx                                ; 055A _ 89. CE
        mov     rdi, rax                                ; 055C _ 48: 89. C7
        mov     eax, 0                                  ; 055F _ B8, 00000000
        call    printf                                  ; 0564 _ E8, 00000000(PLT r)
?_026:  mov     rcx, qword [rbp-18H]                    ; 0569 _ 48: 8B. 4D, E8
        mov     rdx, qword [rbp-18H]                    ; 056D _ 48: 8B. 55, E8
        mov     rax, qword [rbp-10H]                    ; 0571 _ 48: 8B. 45, F0
        mov     rsi, rax                                ; 0575 _ 48: 89. C6
        mov     edi, 2                                  ; 0578 _ BF, 00000002
        call    hexdump_data                            ; 057D _ E8, FFFFFCB7
        nop                                             ; 0582 _ 90
        leave                                           ; 0583 _ C9
        ret                                             ; 0584 _ C3

dump_coment:; Local function
        push    rbp                                     ; 0585 _ 55
        mov     rbp, rsp                                ; 0586 _ 48: 89. E5
        sub     rsp, 48                                 ; 0589 _ 48: 83. EC, 30
        mov     byte [rbp-11H], dil                     ; 058D _ 40: 88. 7D, EF
        mov     qword [rbp-20H], rsi                    ; 0591 _ 48: 89. 75, E0
        mov     qword [rbp-28H], rdx                    ; 0595 _ 48: 89. 55, D8
        cmp     qword [rbp-28H], 1                      ; 0599 _ 48: 83. 7D, D8, 01
        ja      ?_027                                   ; 059E _ 77, 20
        movzx   eax, byte [rbp-11H]                     ; 05A0 _ 0F B6. 45, EF
        mov     rdx, qword [rbp-28H]                    ; 05A4 _ 48: 8B. 55, D8
        mov     rsi, qword [rbp-20H]                    ; 05A8 _ 48: 8B. 75, E0
        mov     rcx, rdx                                ; 05AC _ 48: 89. D1
        mov     edx, 2                                  ; 05AF _ BA, 00000002
        mov     edi, eax                                ; 05B4 _ 89. C7
        call    hexdump_data                            ; 05B6 _ E8, FFFFFC7E
        jmp     ?_031                                   ; 05BB _ E9, 00000117

?_027:  mov     rax, qword [rbp-20H]                    ; 05C0 _ 48: 8B. 45, E0
        movzx   eax, byte [rax]                         ; 05C4 _ 0F B6. 00
        mov     byte [rbp-11H], al                      ; 05C7 _ 88. 45, EF
        mov     rax, qword [rbp-20H]                    ; 05CA _ 48: 8B. 45, E0
        add     rax, 1                                  ; 05CE _ 48: 83. C0, 01
        movzx   eax, byte [rax]                         ; 05D2 _ 0F B6. 00
        mov     byte [rbp-1H], al                       ; 05D5 _ 88. 45, FF
        movzx   eax, byte [rbp-1H]                      ; 05D8 _ 0F B6. 45, FF
        cdqe                                            ; 05DC _ 48: 98
        lea     rdx, [rax*8]                            ; 05DE _ 48: 8D. 14 C5, 00000000
        lea     rax, [rel coment_class.4]               ; 05E6 _ 48: 8D. 05, 00000000(rel)
        mov     rax, qword [rdx+rax]                    ; 05ED _ 48: 8B. 04 02
        test    rax, rax                                ; 05F1 _ 48: 85. C0
        setne   al                                      ; 05F4 _ 0F 95. C0
        movzx   eax, al                                 ; 05F7 _ 0F B6. C0
        and     eax, 01H                                ; 05FA _ 83. E0, 01
        test    al, al                                  ; 05FD _ 84. C0
        jz      ?_028                                   ; 05FF _ 74, 1B
        movzx   eax, byte [rbp-1H]                      ; 0601 _ 0F B6. 45, FF
        cdqe                                            ; 0605 _ 48: 98
        lea     rdx, [rax*8]                            ; 0607 _ 48: 8D. 14 C5, 00000000
        lea     rax, [rel coment_class.4]               ; 060F _ 48: 8D. 05, 00000000(rel)
        mov     rax, qword [rdx+rax]                    ; 0616 _ 48: 8B. 04 02
        jmp     ?_029                                   ; 061A _ EB, 07

?_028:  lea     rax, [rel ?_159]                        ; 061C _ 48: 8D. 05, 00000000(rel)
?_029:  movzx   r8d, byte [rbp-1H]                      ; 0623 _ 44: 0F B6. 45, FF
        movzx   edx, byte [rbp-11H]                     ; 0628 _ 0F B6. 55, EF
        mov     ecx, edx                                ; 062C _ 89. D1
        and     ecx, 3FH                                ; 062E _ 83. E1, 3F
        movzx   edx, byte [rbp-11H]                     ; 0631 _ 0F B6. 55, EF
        shr     dl, 6                                   ; 0635 _ C0. EA, 06
        movzx   edx, dl                                 ; 0638 _ 0F B6. D2
        and     edx, 01H                                ; 063B _ 83. E2, 01
        movzx   esi, byte [rbp-11H]                     ; 063E _ 0F B6. 75, EF
        shr     sil, 7                                  ; 0642 _ 40: C0. EE, 07
        movzx   esi, sil                                ; 0646 _ 40: 0F B6. F6
        and     esi, 01H                                ; 064A _ 83. E6, 01
        lea     rdi, [rel ?_160]                        ; 064D _ 48: 8D. 3D, 00000000(rel)
        mov     r9, rax                                 ; 0654 _ 49: 89. C1
        mov     eax, 0                                  ; 0657 _ B8, 00000000
        call    printf                                  ; 065C _ E8, 00000000(PLT r)
        movzx   eax, byte [rbp-1H]                      ; 0661 _ 0F B6. 45, FF
        cdqe                                            ; 0665 _ 48: 98
        lea     rdx, [rax*8]                            ; 0667 _ 48: 8D. 14 C5, 00000000
        lea     rax, [rel dump_coment_class]            ; 066F _ 48: 8D. 05, 00000000(rel)
        mov     rax, qword [rdx+rax]                    ; 0676 _ 48: 8B. 04 02
        test    rax, rax                                ; 067A _ 48: 85. C0
        jz      ?_030                                   ; 067D _ 74, 33
        movzx   eax, byte [rbp-1H]                      ; 067F _ 0F B6. 45, FF
        cdqe                                            ; 0683 _ 48: 98
        lea     rdx, [rax*8]                            ; 0685 _ 48: 8D. 14 C5, 00000000
        lea     rax, [rel dump_coment_class]            ; 068D _ 48: 8D. 05, 00000000(rel)
        mov     rcx, qword [rdx+rax]                    ; 0694 _ 48: 8B. 0C 02
        mov     rax, qword [rbp-28H]                    ; 0698 _ 48: 8B. 45, D8
        lea     rdx, [rax-2H]                           ; 069C _ 48: 8D. 50, FE
        mov     rax, qword [rbp-20H]                    ; 06A0 _ 48: 8B. 45, E0
        lea     rsi, [rax+2H]                           ; 06A4 _ 48: 8D. 70, 02
        movzx   eax, byte [rbp-1H]                      ; 06A8 _ 0F B6. 45, FF
        mov     edi, eax                                ; 06AC _ 89. C7
        call    rcx                                     ; 06AE _ FF. D1
        jmp     ?_031                                   ; 06B0 _ EB, 25

?_030:  mov     rax, qword [rbp-28H]                    ; 06B2 _ 48: 8B. 45, D8
        lea     rcx, [rax-2H]                           ; 06B6 _ 48: 8D. 48, FE
        mov     rax, qword [rbp-28H]                    ; 06BA _ 48: 8B. 45, D8
        lea     rdx, [rax-2H]                           ; 06BE _ 48: 8D. 50, FE
        mov     rax, qword [rbp-20H]                    ; 06C2 _ 48: 8B. 45, E0
        add     rax, 2                                  ; 06C6 _ 48: 83. C0, 02
        mov     rsi, rax                                ; 06CA _ 48: 89. C6
        mov     edi, 2                                  ; 06CD _ BF, 00000002
        call    hexdump_data                            ; 06D2 _ E8, FFFFFB62
?_031:  leave                                           ; 06D7 _ C9
        ret                                             ; 06D8 _ C3

get_index:; Local function
        push    rbp                                     ; 06D9 _ 55
        mov     rbp, rsp                                ; 06DA _ 48: 89. E5
        mov     qword [rbp-18H], rdi                    ; 06DD _ 48: 89. 7D, E8
        mov     rax, qword [rbp-18H]                    ; 06E1 _ 48: 8B. 45, E8
        mov     rax, qword [rax]                        ; 06E5 _ 48: 8B. 00
        lea     rcx, [rax+1H]                           ; 06E8 _ 48: 8D. 48, 01
        mov     rdx, qword [rbp-18H]                    ; 06EC _ 48: 8B. 55, E8
        mov     qword [rdx], rcx                        ; 06F0 _ 48: 89. 0A
        movzx   eax, byte [rax]                         ; 06F3 _ 0F B6. 00
        mov     byte [rbp-1H], al                       ; 06F6 _ 88. 45, FF
        movzx   eax, byte [rbp-1H]                      ; 06F9 _ 0F B6. 45, FF
        test    al, al                                  ; 06FD _ 84. C0
        jns     ?_032                                   ; 06FF _ 79, 29
        movzx   eax, byte [rbp-1H]                      ; 0701 _ 0F B6. 45, FF
        shl     eax, 8                                  ; 0705 _ C1. E0, 08
; Note: Length-changing prefix causes delay on old Intel processors
        and     ax, 7F00H                               ; 0708 _ 66: 25, 7F00
        mov     esi, eax                                ; 070C _ 89. C6
        mov     rax, qword [rbp-18H]                    ; 070E _ 48: 8B. 45, E8
        mov     rax, qword [rax]                        ; 0712 _ 48: 8B. 00
        lea     rcx, [rax+1H]                           ; 0715 _ 48: 8D. 48, 01
        mov     rdx, qword [rbp-18H]                    ; 0719 _ 48: 8B. 55, E8
        mov     qword [rdx], rcx                        ; 071D _ 48: 89. 0A
        movzx   eax, byte [rax]                         ; 0720 _ 0F B6. 00
        movzx   eax, al                                 ; 0723 _ 0F B6. C0
        add     eax, esi                                ; 0726 _ 01. F0
        jmp     ?_033                                   ; 0728 _ EB, 04

?_032:  movzx   eax, byte [rbp-1H]                      ; 072A _ 0F B6. 45, FF
?_033:  pop     rbp                                     ; 072E _ 5D
        ret                                             ; 072F _ C3

get_16: ; Local function
        push    rbp                                     ; 0730 _ 55
        mov     rbp, rsp                                ; 0731 _ 48: 89. E5
        mov     qword [rbp-18H], rdi                    ; 0734 _ 48: 89. 7D, E8
        mov     rax, qword [rbp-18H]                    ; 0738 _ 48: 8B. 45, E8
        mov     rax, qword [rax]                        ; 073C _ 48: 8B. 00
        movzx   eax, word [rax]                         ; 073F _ 0F B7. 00
        mov     word [rbp-2H], ax                       ; 0742 _ 66: 89. 45, FE
        mov     rax, qword [rbp-18H]                    ; 0746 _ 48: 8B. 45, E8
        mov     rax, qword [rax]                        ; 074A _ 48: 8B. 00
        lea     rdx, [rax+2H]                           ; 074D _ 48: 8D. 50, 02
        mov     rax, qword [rbp-18H]                    ; 0751 _ 48: 8B. 45, E8
        mov     qword [rax], rdx                        ; 0755 _ 48: 89. 10
        movzx   eax, word [rbp-2H]                      ; 0758 _ 0F B7. 45, FE
        pop     rbp                                     ; 075C _ 5D
        ret                                             ; 075D _ C3

get_32: ; Local function
        push    rbp                                     ; 075E _ 55
        mov     rbp, rsp                                ; 075F _ 48: 89. E5
        mov     qword [rbp-18H], rdi                    ; 0762 _ 48: 89. 7D, E8
        mov     rax, qword [rbp-18H]                    ; 0766 _ 48: 8B. 45, E8
        mov     rax, qword [rax]                        ; 076A _ 48: 8B. 00
        mov     eax, dword [rax]                        ; 076D _ 8B. 00
        mov     dword [rbp-4H], eax                     ; 076F _ 89. 45, FC
        mov     rax, qword [rbp-18H]                    ; 0772 _ 48: 8B. 45, E8
        mov     rax, qword [rax]                        ; 0776 _ 48: 8B. 00
        lea     rdx, [rax+4H]                           ; 0779 _ 48: 8D. 50, 04
        mov     rax, qword [rbp-18H]                    ; 077D _ 48: 8B. 45, E8
        mov     qword [rax], rdx                        ; 0781 _ 48: 89. 10
        mov     eax, dword [rbp-4H]                     ; 0784 _ 8B. 45, FC
        pop     rbp                                     ; 0787 _ 5D
        ret                                             ; 0788 _ C3

lname:  ; Local function
        push    rbp                                     ; 0789 _ 55
        mov     rbp, rsp                                ; 078A _ 48: 89. E5
        sub     rsp, 8                                  ; 078D _ 48: 83. EC, 08
        mov     dword [rbp-4H], edi                     ; 0791 _ 89. 7D, FC
        mov     eax, dword [rbp-4H]                     ; 0794 _ 8B. 45, FC
        cdqe                                            ; 0797 _ 48: 98
        lea     rdx, [rel ?_161]                        ; 0799 _ 48: 8D. 15, 00000000(rel)
        lea     rcx, [rel c_names]                      ; 07A0 _ 48: 8D. 0D, 00000000(rel)
        mov     rsi, rax                                ; 07A7 _ 48: 89. C6
        mov     rdi, rcx                                ; 07AA _ 48: 89. CF
        call    get_collection                          ; 07AD _ E8, FFFFF9F2
        leave                                           ; 07B2 _ C9
        ret                                             ; 07B3 _ C3

segment_name:; Local function
        push    rbp                                     ; 07B4 _ 55
        mov     rbp, rsp                                ; 07B5 _ 48: 89. E5
        sub     rsp, 24                                 ; 07B8 _ 48: 83. EC, 18
        mov     word [rbp-12H], di                      ; 07BC _ 66: 89. 7D, EE
        movzx   eax, word [rbp-12H]                     ; 07C0 _ 0F B7. 45, EE
        lea     rcx, [rel c_lsegs]                      ; 07C4 _ 48: 8D. 0D, 00000000(rel)
        mov     edx, 0                                  ; 07CB _ BA, 00000000
        mov     rsi, rax                                ; 07D0 _ 48: 89. C6
        mov     rdi, rcx                                ; 07D3 _ 48: 89. CF
        call    get_collection                          ; 07D6 _ E8, FFFFF9C9
        mov     qword [rbp-8H], rax                     ; 07DB _ 48: 89. 45, F8
        cmp     qword [rbp-8H], 0                       ; 07DF _ 48: 83. 7D, F8, 00
        jnz     ?_034                                   ; 07E4 _ 75, 09
        lea     rax, [rel ?_161]                        ; 07E6 _ 48: 8D. 05, 00000000(rel)
        jmp     ?_035                                   ; 07ED _ EB, 11

?_034:  mov     rax, qword [rbp-8H]                     ; 07EF _ 48: 8B. 45, F8
        movzx   eax, word [rax]                         ; 07F3 _ 0F B7. 00
        movzx   eax, ax                                 ; 07F6 _ 0F B7. C0
        mov     edi, eax                                ; 07F9 _ 89. C7
        call    lname                                   ; 07FB _ E8, FFFFFF89
?_035:  leave                                           ; 0800 _ C9
        ret                                             ; 0801 _ C3

group_name:; Local function
        push    rbp                                     ; 0802 _ 55
        mov     rbp, rsp                                ; 0803 _ 48: 89. E5
        sub     rsp, 24                                 ; 0806 _ 48: 83. EC, 18
        mov     word [rbp-12H], di                      ; 080A _ 66: 89. 7D, EE
        movzx   eax, word [rbp-12H]                     ; 080E _ 0F B7. 45, EE
        lea     rcx, [rel c_groups]                     ; 0812 _ 48: 8D. 0D, 00000000(rel)
        mov     edx, 0                                  ; 0819 _ BA, 00000000
        mov     rsi, rax                                ; 081E _ 48: 89. C6
        mov     rdi, rcx                                ; 0821 _ 48: 89. CF
        call    get_collection                          ; 0824 _ E8, FFFFF97B
        mov     qword [rbp-8H], rax                     ; 0829 _ 48: 89. 45, F8
        cmp     qword [rbp-8H], 0                       ; 082D _ 48: 83. 7D, F8, 00
        jnz     ?_036                                   ; 0832 _ 75, 09
        lea     rax, [rel ?_161]                        ; 0834 _ 48: 8D. 05, 00000000(rel)
        jmp     ?_037                                   ; 083B _ EB, 11

?_036:  mov     rax, qword [rbp-8H]                     ; 083D _ 48: 8B. 45, F8
        movzx   eax, word [rax]                         ; 0841 _ 0F B7. 00
        movzx   eax, ax                                 ; 0844 _ 0F B7. C0
        mov     edi, eax                                ; 0847 _ 89. C7
        call    lname                                   ; 0849 _ E8, FFFFFF3B
?_037:  leave                                           ; 084E _ C9
        ret                                             ; 084F _ C3

external_name:; Local function
        push    rbp                                     ; 0850 _ 55
        mov     rbp, rsp                                ; 0851 _ 48: 89. E5
        sub     rsp, 8                                  ; 0854 _ 48: 83. EC, 08
        mov     word [rbp-2H], di                       ; 0858 _ 66: 89. 7D, FE
        movzx   eax, word [rbp-2H]                      ; 085C _ 0F B7. 45, FE
        lea     rdx, [rel ?_161]                        ; 0860 _ 48: 8D. 15, 00000000(rel)
        lea     rcx, [rel c_extsym]                     ; 0867 _ 48: 8D. 0D, 00000000(rel)
        mov     rsi, rax                                ; 086E _ 48: 89. C6
        mov     rdi, rcx                                ; 0871 _ 48: 89. CF
        call    get_collection                          ; 0874 _ E8, FFFFF92B
        leave                                           ; 0879 _ C9
        ret                                             ; 087A _ C3

dump_lnames:; Local function
        push    rbp                                     ; 087B _ 55
        mov     rbp, rsp                                ; 087C _ 48: 89. E5
        sub     rsp, 64                                 ; 087F _ 48: 83. EC, 40
        mov     byte [rbp-21H], dil                     ; 0883 _ 40: 88. 7D, DF
        mov     qword [rbp-30H], rsi                    ; 0887 _ 48: 89. 75, D0
        mov     qword [rbp-38H], rdx                    ; 088B _ 48: 89. 55, C8
        mov     rax, qword [rbp-30H]                    ; 088F _ 48: 8B. 45, D0
        mov     qword [rbp-20H], rax                    ; 0893 _ 48: 89. 45, E0
        mov     rdx, qword [rbp-30H]                    ; 0897 _ 48: 8B. 55, D0
        mov     rax, qword [rbp-38H]                    ; 089B _ 48: 8B. 45, C8
        add     rax, rdx                                ; 089F _ 48: 01. D0
        mov     qword [rbp-18H], rax                    ; 08A2 _ 48: 89. 45, E8
        jmp     ?_041                                   ; 08A6 _ E9, 0000012A

?_038:  mov     rax, qword [rbp-20H]                    ; 08AB _ 48: 8B. 45, E0
        movzx   eax, byte [rax]                         ; 08AF _ 0F B6. 00
        movzx   eax, al                                 ; 08B2 _ 0F B6. C0
        mov     qword [rbp-10H], rax                    ; 08B5 _ 48: 89. 45, F0
        mov     rax, qword [rbp-10H]                    ; 08B9 _ 48: 8B. 45, F0
        cmp     qword [rbp-38H], rax                    ; 08BD _ 48: 39. 45, C8
        jnc     ?_039                                   ; 08C1 _ 73, 7B
        mov     rax, qword [rbp-20H]                    ; 08C3 _ 48: 8B. 45, E0
        lea     rdx, [rax+1H]                           ; 08C7 _ 48: 8D. 50, 01
        mov     rax, qword [rbp-38H]                    ; 08CB _ 48: 8B. 45, C8
        mov     rsi, rdx                                ; 08CF _ 48: 89. D6
        mov     rdi, rax                                ; 08D2 _ 48: 89. C7
        call    copy_name                               ; 08D5 _ E8, FFFFF910
        mov     qword [rbp-8H], rax                     ; 08DA _ 48: 89. 45, F8
        mov     rax, qword [rbp-8H]                     ; 08DE _ 48: 8B. 45, F8
        lea     rdx, [rel c_names]                      ; 08E2 _ 48: 8D. 15, 00000000(rel)
        mov     rsi, rax                                ; 08E9 _ 48: 89. C6
        mov     rdi, rdx                                ; 08EC _ 48: 89. D7
        call    add_collection                          ; 08EF _ E8, FFFFF848
        mov     rax, qword [rbp-10H]                    ; 08F4 _ 48: 8B. 45, F0
        sub     rax, qword [rbp-38H]                    ; 08F8 _ 48: 2B. 45, C8
        mov     rcx, rax                                ; 08FC _ 48: 89. C1
        mov     rax, qword [rbp-20H]                    ; 08FF _ 48: 8B. 45, E0
        lea     rsi, [rax+1H]                           ; 0903 _ 48: 8D. 70, 01
        mov     rax, qword [rbp-38H]                    ; 0907 _ 48: 8B. 45, C8
        sub     eax, 1                                  ; 090B _ 83. E8, 01
        mov     r10d, eax                               ; 090E _ 41: 89. C2
        mov     rdx, qword [rel c_names]                ; 0911 _ 48: 8B. 15, 00000000(rel)
        mov     rax, qword [rel c_names]                ; 0918 _ 48: 8B. 05, 00000000(rel)
        lea     rdi, [rel ?_162]                        ; 091F _ 48: 8D. 3D, 00000000(rel)
        mov     r9, rcx                                 ; 0926 _ 49: 89. C9
        mov     r8, rsi                                 ; 0929 _ 49: 89. F0
        mov     ecx, r10d                               ; 092C _ 44: 89. D1
        mov     rsi, rax                                ; 092F _ 48: 89. C6
        mov     eax, 0                                  ; 0932 _ B8, 00000000
        call    printf                                  ; 0937 _ E8, 00000000(PLT r)
        jmp     ?_040                                   ; 093C _ EB, 53

?_039:  mov     rax, qword [rbp-20H]                    ; 093E _ 48: 8B. 45, E0
        lea     rdx, [rax+1H]                           ; 0942 _ 48: 8D. 50, 01
        mov     rax, qword [rbp-10H]                    ; 0946 _ 48: 8B. 45, F0
        mov     rsi, rdx                                ; 094A _ 48: 89. D6
        mov     rdi, rax                                ; 094D _ 48: 89. C7
        call    copy_name                               ; 0950 _ E8, FFFFF895
        mov     qword [rbp-8H], rax                     ; 0955 _ 48: 89. 45, F8
        mov     rax, qword [rbp-8H]                     ; 0959 _ 48: 8B. 45, F8
        lea     rdx, [rel c_names]                      ; 095D _ 48: 8D. 15, 00000000(rel)
        mov     rsi, rax                                ; 0964 _ 48: 89. C6
        mov     rdi, rdx                                ; 0967 _ 48: 89. D7
        call    add_collection                          ; 096A _ E8, FFFFF7CD
        mov     rax, qword [rel c_names]                ; 096F _ 48: 8B. 05, 00000000(rel)
        mov     rdx, qword [rbp-8H]                     ; 0976 _ 48: 8B. 55, F8
        lea     rcx, [rel ?_163]                        ; 097A _ 48: 8D. 0D, 00000000(rel)
        mov     rsi, rax                                ; 0981 _ 48: 89. C6
        mov     rdi, rcx                                ; 0984 _ 48: 89. CF
        mov     eax, 0                                  ; 0987 _ B8, 00000000
        call    printf                                  ; 098C _ E8, 00000000(PLT r)
?_040:  mov     rax, qword [rbp-10H]                    ; 0991 _ 48: 8B. 45, F0
        lea     rsi, [rax+1H]                           ; 0995 _ 48: 8D. 70, 01
        mov     rax, qword [rbp-20H]                    ; 0999 _ 48: 8B. 45, E0
        sub     rax, qword [rbp-30H]                    ; 099D _ 48: 2B. 45, D0
        mov     edi, eax                                ; 09A1 _ 89. C7
        mov     rdx, qword [rbp-38H]                    ; 09A3 _ 48: 8B. 55, C8
        mov     rax, qword [rbp-20H]                    ; 09A7 _ 48: 8B. 45, E0
        mov     rcx, rdx                                ; 09AB _ 48: 89. D1
        mov     rdx, rsi                                ; 09AE _ 48: 89. F2
        mov     rsi, rax                                ; 09B1 _ 48: 89. C6
        call    hexdump_data                            ; 09B4 _ E8, FFFFF880
        mov     rax, qword [rbp-10H]                    ; 09B9 _ 48: 8B. 45, F0
        add     rax, 1                                  ; 09BD _ 48: 83. C0, 01
        add     qword [rbp-20H], rax                    ; 09C1 _ 48: 01. 45, E0
        mov     rax, qword [rbp-38H]                    ; 09C5 _ 48: 8B. 45, C8
        sub     rax, qword [rbp-10H]                    ; 09C9 _ 48: 2B. 45, F0
        sub     rax, 1                                  ; 09CD _ 48: 83. E8, 01
        mov     qword [rbp-38H], rax                    ; 09D1 _ 48: 89. 45, C8
?_041:  mov     rax, qword [rbp-20H]                    ; 09D5 _ 48: 8B. 45, E0
        cmp     rax, qword [rbp-18H]                    ; 09D9 _ 48: 3B. 45, E8
        jc      ?_038                                   ; 09DD _ 0F 82, FFFFFEC8
        nop                                             ; 09E3 _ 90
        nop                                             ; 09E4 _ 90
        leave                                           ; 09E5 _ C9
        ret                                             ; 09E6 _ C3

dump_segdef:; Local function
        push    rbp                                     ; 09E7 _ 55
        mov     rbp, rsp                                ; 09E8 _ 48: 89. E5
        sub     rsp, 80                                 ; 09EB _ 48: 83. EC, 50
        mov     byte [rbp-31H], dil                     ; 09EF _ 40: 88. 7D, CF
        mov     qword [rbp-40H], rsi                    ; 09F3 _ 48: 89. 75, C0
        mov     qword [rbp-48H], rdx                    ; 09F7 _ 48: 89. 55, B8
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        mov     rax, qword [fs:abs 28H]                 ; 09FB _ 64 48: 8B. 04 25, 00000028
        mov     qword [rbp-8H], rax                     ; 0A04 _ 48: 89. 45, F8
        xor     eax, eax                                ; 0A08 _ 31. C0
        movzx   eax, byte [rbp-31H]                     ; 0A0A _ 0F B6. 45, CF
        and     eax, 01H                                ; 0A0E _ 83. E0, 01
        mov     byte [rbp-2AH], al                      ; 0A11 _ 88. 45, D6
        mov     rax, qword [rbp-40H]                    ; 0A14 _ 48: 8B. 45, C0
        mov     qword [rbp-28H], rax                    ; 0A18 _ 48: 89. 45, D8
        mov     rdx, qword [rbp-40H]                    ; 0A1C _ 48: 8B. 55, C0
        mov     rax, qword [rbp-48H]                    ; 0A20 _ 48: 8B. 45, B8
        add     rax, rdx                                ; 0A24 _ 48: 01. D0
        mov     qword [rbp-20H], rax                    ; 0A27 _ 48: 89. 45, E0
        mov     edi, 6                                  ; 0A2B _ BF, 00000006
        call    xmalloc                                 ; 0A30 _ E8, FFFFF61E
        mov     qword [rbp-18H], rax                    ; 0A35 _ 48: 89. 45, E8
        mov     rax, qword [rbp-28H]                    ; 0A39 _ 48: 8B. 45, D8
        cmp     rax, qword [rbp-20H]                    ; 0A3D _ 48: 3B. 45, E0
        jnc     ?_058                                   ; 0A41 _ 0F 83, 0000031C
        mov     rax, qword [rbp-28H]                    ; 0A47 _ 48: 8B. 45, D8
        lea     rdx, [rax+1H]                           ; 0A4B _ 48: 8D. 50, 01
        mov     qword [rbp-28H], rdx                    ; 0A4F _ 48: 89. 55, D8
        movzx   eax, byte [rax]                         ; 0A53 _ 0F B6. 00
        mov     byte [rbp-29H], al                      ; 0A56 _ 88. 45, D7
        movzx   eax, byte [rbp-29H]                     ; 0A59 _ 0F B6. 45, D7
        and     eax, 01H                                ; 0A5D _ 83. E0, 01
        test    eax, eax                                ; 0A60 _ 85. C0
        jz      ?_042                                   ; 0A62 _ 74, 09
        lea     rax, [rel ?_164]                        ; 0A64 _ 48: 8D. 05, 00000000(rel)
        jmp     ?_043                                   ; 0A6B _ EB, 07

?_042:  lea     rax, [rel ?_165]                        ; 0A6D _ 48: 8D. 05, 00000000(rel)
?_043:  movzx   edx, byte [rbp-29H]                     ; 0A74 _ 0F B6. 55, D7
        and     edx, 02H                                ; 0A78 _ 83. E2, 02
        test    edx, edx                                ; 0A7B _ 85. D2
        jz      ?_044                                   ; 0A7D _ 74, 09
        lea     rdx, [rel ?_166]                        ; 0A7F _ 48: 8D. 15, 00000000(rel)
        jmp     ?_045                                   ; 0A86 _ EB, 07

?_044:  lea     rdx, [rel ?_161]                        ; 0A88 _ 48: 8D. 15, 00000000(rel)
?_045:  movzx   ecx, byte [rbp-29H]                     ; 0A8F _ 0F B6. 4D, D7
        shr     cl, 2                                   ; 0A93 _ C0. E9, 02
        movzx   ecx, cl                                 ; 0A96 _ 0F B6. C9
        and     ecx, 07H                                ; 0A99 _ 83. E1, 07
        mov     r8d, ecx                                ; 0A9C _ 41: 89. C8
        movzx   ecx, byte [rbp-29H]                     ; 0A9F _ 0F B6. 4D, D7
        shr     cl, 2                                   ; 0AA3 _ C0. E9, 02
        movzx   ecx, cl                                 ; 0AA6 _ 0F B6. C9
        and     ecx, 07H                                ; 0AA9 _ 83. E1, 07
        movsxd  rcx, ecx                                ; 0AAC _ 48: 63. C9
        lea     rsi, [rcx*8]                            ; 0AAF _ 48: 8D. 34 CD, 00000000
        lea     rcx, [rel combine.3]                    ; 0AB7 _ 48: 8D. 0D, 00000000(rel)
        mov     rcx, qword [rsi+rcx]                    ; 0ABE _ 48: 8B. 0C 0E
        movzx   esi, byte [rbp-29H]                     ; 0AC2 _ 0F B6. 75, D7
        shr     sil, 5                                  ; 0AC6 _ 40: C0. EE, 05
        movzx   esi, sil                                ; 0ACA _ 40: 0F B6. F6
        and     esi, 07H                                ; 0ACE _ 83. E6, 07
        mov     r10d, esi                               ; 0AD1 _ 41: 89. F2
        movzx   esi, byte [rbp-29H]                     ; 0AD4 _ 0F B6. 75, D7
        shr     sil, 5                                  ; 0AD8 _ 40: C0. EE, 05
        movzx   esi, sil                                ; 0ADC _ 40: 0F B6. F6
        and     esi, 07H                                ; 0AE0 _ 83. E6, 07
        movsxd  rsi, esi                                ; 0AE3 _ 48: 63. F6
        lea     rdi, [rsi*8]                            ; 0AE6 _ 48: 8D. 3C F5, 00000000
        lea     rsi, [rel alignment.2]                  ; 0AEE _ 48: 8D. 35, 00000000(rel)
        mov     rsi, qword [rdi+rsi]                    ; 0AF5 _ 48: 8B. 34 37
        lea     rdi, [rel ?_167]                        ; 0AF9 _ 48: 8D. 3D, 00000000(rel)
        sub     rsp, 8                                  ; 0B00 _ 48: 83. EC, 08
        push    rax                                     ; 0B04 _ 50
        mov     r9, rdx                                 ; 0B05 _ 49: 89. D1
        mov     edx, r10d                               ; 0B08 _ 44: 89. D2
        mov     eax, 0                                  ; 0B0B _ B8, 00000000
        call    printf                                  ; 0B10 _ E8, 00000000(PLT r)
        add     rsp, 16                                 ; 0B15 _ 48: 83. C4, 10
        movzx   eax, byte [rbp-29H]                     ; 0B19 _ 0F B6. 45, D7
        shr     al, 5                                   ; 0B1D _ C0. E8, 05
        movzx   eax, al                                 ; 0B20 _ 0F B6. C0
        and     eax, 07H                                ; 0B23 _ 83. E0, 07
        test    eax, eax                                ; 0B26 _ 85. C0
        jnz     ?_046                                   ; 0B28 _ 75, 5F
        mov     rax, qword [rbp-28H]                    ; 0B2A _ 48: 8B. 45, D8
        add     rax, 3                                  ; 0B2E _ 48: 83. C0, 03
        cmp     qword [rbp-20H], rax                    ; 0B32 _ 48: 39. 45, E0
        jc      ?_051                                   ; 0B36 _ 0F 82, 000001F2
        lea     rax, [rbp-28H]                          ; 0B3C _ 48: 8D. 45, D8
        mov     rdi, rax                                ; 0B40 _ 48: 89. C7
        call    get_16                                  ; 0B43 _ E8, FFFFFBE8
        movzx   eax, ax                                 ; 0B48 _ 0F B7. C0
        lea     rdx, [rel ?_168]                        ; 0B4B _ 48: 8D. 15, 00000000(rel)
        mov     esi, eax                                ; 0B52 _ 89. C6
        mov     rdi, rdx                                ; 0B54 _ 48: 89. D7
        mov     eax, 0                                  ; 0B57 _ B8, 00000000
        call    printf                                  ; 0B5C _ E8, 00000000(PLT r)
        mov     rax, qword [rbp-28H]                    ; 0B61 _ 48: 8B. 45, D8
        lea     rdx, [rax+1H]                           ; 0B65 _ 48: 8D. 50, 01
        mov     qword [rbp-28H], rdx                    ; 0B69 _ 48: 89. 55, D8
        movzx   eax, byte [rax]                         ; 0B6D _ 0F B6. 00
        movzx   eax, al                                 ; 0B70 _ 0F B6. C0
        lea     rdx, [rel ?_169]                        ; 0B73 _ 48: 8D. 15, 00000000(rel)
        mov     esi, eax                                ; 0B7A _ 89. C6
        mov     rdi, rdx                                ; 0B7C _ 48: 89. D7
        mov     eax, 0                                  ; 0B7F _ B8, 00000000
        call    printf                                  ; 0B84 _ E8, 00000000(PLT r)
?_046:  cmp     byte [rbp-2AH], 0                       ; 0B89 _ 80. 7D, D6, 00
        jz      ?_047                                   ; 0B8D _ 74, 38
        mov     rax, qword [rbp-28H]                    ; 0B8F _ 48: 8B. 45, D8
        add     rax, 4                                  ; 0B93 _ 48: 83. C0, 04
        cmp     qword [rbp-20H], rax                    ; 0B97 _ 48: 39. 45, E0
        jc      ?_052                                   ; 0B9B _ 0F 82, 00000190
        lea     rax, [rbp-28H]                          ; 0BA1 _ 48: 8D. 45, D8
        mov     rdi, rax                                ; 0BA5 _ 48: 89. C7
        call    get_32                                  ; 0BA8 _ E8, FFFFFBB1
        mov     edx, eax                                ; 0BAD _ 89. C2
        lea     rax, [rel ?_170]                        ; 0BAF _ 48: 8D. 05, 00000000(rel)
        mov     esi, edx                                ; 0BB6 _ 89. D6
        mov     rdi, rax                                ; 0BB8 _ 48: 89. C7
        mov     eax, 0                                  ; 0BBB _ B8, 00000000
        call    printf                                  ; 0BC0 _ E8, 00000000(PLT r)
        jmp     ?_048                                   ; 0BC5 _ EB, 37

?_047:  mov     rax, qword [rbp-28H]                    ; 0BC7 _ 48: 8B. 45, D8
        add     rax, 2                                  ; 0BCB _ 48: 83. C0, 02
        cmp     qword [rbp-20H], rax                    ; 0BCF _ 48: 39. 45, E0
        jc      ?_053                                   ; 0BD3 _ 0F 82, 0000015B
        lea     rax, [rbp-28H]                          ; 0BD9 _ 48: 8D. 45, D8
        mov     rdi, rax                                ; 0BDD _ 48: 89. C7
        call    get_16                                  ; 0BE0 _ E8, FFFFFB4B
        movzx   eax, ax                                 ; 0BE5 _ 0F B7. C0
        lea     rdx, [rel ?_171]                        ; 0BE8 _ 48: 8D. 15, 00000000(rel)
        mov     esi, eax                                ; 0BEF _ 89. C6
        mov     rdi, rdx                                ; 0BF1 _ 48: 89. D7
        mov     eax, 0                                  ; 0BF4 _ B8, 00000000
        call    printf                                  ; 0BF9 _ E8, 00000000(PLT r)
?_048:  lea     rax, [rel ?_161]                        ; 0BFE _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 0C05 _ 48: 89. C7
        call    puts                                    ; 0C08 _ E8, 00000000(PLT r)
        lea     rax, [rbp-28H]                          ; 0C0D _ 48: 8D. 45, D8
        mov     rdi, rax                                ; 0C11 _ 48: 89. C7
        call    get_index                               ; 0C14 _ E8, FFFFFAC0
        mov     rdx, qword [rbp-18H]                    ; 0C19 _ 48: 8B. 55, E8
        mov     word [rdx], ax                          ; 0C1D _ 66: 89. 02
        mov     rax, qword [rbp-28H]                    ; 0C20 _ 48: 8B. 45, D8
        cmp     qword [rbp-20H], rax                    ; 0C24 _ 48: 39. 45, E0
        jc      ?_054                                   ; 0C28 _ 0F 82, 00000109
        mov     rax, qword [rbp-18H]                    ; 0C2E _ 48: 8B. 45, E8
        movzx   eax, word [rax]                         ; 0C32 _ 0F B7. 00
        movzx   eax, ax                                 ; 0C35 _ 0F B7. C0
        mov     edi, eax                                ; 0C38 _ 89. C7
        call    lname                                   ; 0C3A _ E8, FFFFFB4A
        mov     qword [rbp-10H], rax                    ; 0C3F _ 48: 89. 45, F0
        mov     rax, qword [rbp-10H]                    ; 0C43 _ 48: 8B. 45, F0
        lea     rdx, [rel ?_172]                        ; 0C47 _ 48: 8D. 15, 00000000(rel)
        mov     rsi, rax                                ; 0C4E _ 48: 89. C6
        mov     rdi, rdx                                ; 0C51 _ 48: 89. D7
        mov     eax, 0                                  ; 0C54 _ B8, 00000000
        call    printf                                  ; 0C59 _ E8, 00000000(PLT r)
        lea     rax, [rbp-28H]                          ; 0C5E _ 48: 8D. 45, D8
        mov     rdi, rax                                ; 0C62 _ 48: 89. C7
        call    get_index                               ; 0C65 _ E8, FFFFFA6F
        mov     rdx, qword [rbp-18H]                    ; 0C6A _ 48: 8B. 55, E8
        mov     word [rdx+2H], ax                       ; 0C6E _ 66: 89. 42, 02
        mov     rax, qword [rbp-28H]                    ; 0C72 _ 48: 8B. 45, D8
        cmp     qword [rbp-20H], rax                    ; 0C76 _ 48: 39. 45, E0
        jc      ?_055                                   ; 0C7A _ 0F 82, 000000BA
        mov     rax, qword [rbp-18H]                    ; 0C80 _ 48: 8B. 45, E8
        movzx   eax, word [rax+2H]                      ; 0C84 _ 0F B7. 40, 02
        movzx   eax, ax                                 ; 0C88 _ 0F B7. C0
        mov     edi, eax                                ; 0C8B _ 89. C7
        call    lname                                   ; 0C8D _ E8, FFFFFAF7
        mov     qword [rbp-10H], rax                    ; 0C92 _ 48: 89. 45, F0
        mov     rax, qword [rbp-10H]                    ; 0C96 _ 48: 8B. 45, F0
        movzx   eax, byte [rax]                         ; 0C9A _ 0F B6. 00
        test    al, al                                  ; 0C9D _ 84. C0
        jz      ?_049                                   ; 0C9F _ 74, 1B
        mov     rax, qword [rbp-10H]                    ; 0CA1 _ 48: 8B. 45, F0
        lea     rdx, [rel ?_173]                        ; 0CA5 _ 48: 8D. 15, 00000000(rel)
        mov     rsi, rax                                ; 0CAC _ 48: 89. C6
        mov     rdi, rdx                                ; 0CAF _ 48: 89. D7
        mov     eax, 0                                  ; 0CB2 _ B8, 00000000
        call    printf                                  ; 0CB7 _ E8, 00000000(PLT r)
?_049:  lea     rax, [rbp-28H]                          ; 0CBC _ 48: 8D. 45, D8
        mov     rdi, rax                                ; 0CC0 _ 48: 89. C7
        call    get_index                               ; 0CC3 _ E8, FFFFFA11
        mov     rdx, qword [rbp-18H]                    ; 0CC8 _ 48: 8B. 55, E8
        mov     word [rdx+4H], ax                       ; 0CCC _ 66: 89. 42, 04
        mov     rax, qword [rbp-28H]                    ; 0CD0 _ 48: 8B. 45, D8
        cmp     qword [rbp-20H], rax                    ; 0CD4 _ 48: 39. 45, E0
        jc      ?_056                                   ; 0CD8 _ 72, 63
        mov     rax, qword [rbp-18H]                    ; 0CDA _ 48: 8B. 45, E8
        movzx   eax, word [rax+4H]                      ; 0CDE _ 0F B7. 40, 04
        movzx   eax, ax                                 ; 0CE2 _ 0F B7. C0
        mov     edi, eax                                ; 0CE5 _ 89. C7
        call    lname                                   ; 0CE7 _ E8, FFFFFA9D
        mov     qword [rbp-10H], rax                    ; 0CEC _ 48: 89. 45, F0
        mov     rax, qword [rbp-10H]                    ; 0CF0 _ 48: 8B. 45, F0
        movzx   eax, byte [rax]                         ; 0CF4 _ 0F B6. 00
        test    al, al                                  ; 0CF7 _ 84. C0
        jz      ?_050                                   ; 0CF9 _ 74, 1B
        mov     rax, qword [rbp-10H]                    ; 0CFB _ 48: 8B. 45, F0
        lea     rdx, [rel ?_174]                        ; 0CFF _ 48: 8D. 15, 00000000(rel)
        mov     rsi, rax                                ; 0D06 _ 48: 89. C6
        mov     rdi, rdx                                ; 0D09 _ 48: 89. D7
        mov     eax, 0                                  ; 0D0C _ B8, 00000000
        call    printf                                  ; 0D11 _ E8, 00000000(PLT r)
?_050:  mov     rax, qword [rbp-18H]                    ; 0D16 _ 48: 8B. 45, E8
        lea     rdx, [rel c_lsegs]                      ; 0D1A _ 48: 8D. 15, 00000000(rel)
        mov     rsi, rax                                ; 0D21 _ 48: 89. C6
        mov     rdi, rdx                                ; 0D24 _ 48: 89. D7
        call    add_collection                          ; 0D27 _ E8, FFFFF410
        jmp     ?_057                                   ; 0D2C _ EB, 10

?_051:  nop                                             ; 0D2E _ 90
        jmp     ?_057                                   ; 0D2F _ EB, 0D

?_052:  nop                                             ; 0D31 _ 90
        jmp     ?_057                                   ; 0D32 _ EB, 0A

?_053:  nop                                             ; 0D34 _ 90
        jmp     ?_057                                   ; 0D35 _ EB, 07

?_054:  nop                                             ; 0D37 _ 90
        jmp     ?_057                                   ; 0D38 _ EB, 04

?_055:  nop                                             ; 0D3A _ 90
        jmp     ?_057                                   ; 0D3B _ EB, 01

?_056:  nop                                             ; 0D3D _ 90
?_057:  mov     edi, 10                                 ; 0D3E _ BF, 0000000A
        call    putchar                                 ; 0D43 _ E8, 00000000(PLT r)
        mov     rcx, qword [rbp-48H]                    ; 0D48 _ 48: 8B. 4D, B8
        mov     rdx, qword [rbp-48H]                    ; 0D4C _ 48: 8B. 55, B8
        mov     rax, qword [rbp-40H]                    ; 0D50 _ 48: 8B. 45, C0
        mov     rsi, rax                                ; 0D54 _ 48: 89. C6
        mov     edi, 0                                  ; 0D57 _ BF, 00000000
        call    hexdump_data                            ; 0D5C _ E8, FFFFF4D8
        jmp     ?_059                                   ; 0D61 _ EB, 01

?_058:  nop                                             ; 0D63 _ 90
?_059:  mov     rax, qword [rbp-8H]                     ; 0D64 _ 48: 8B. 45, F8
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        sub     rax, qword [fs:abs 28H]                 ; 0D68 _ 64 48: 2B. 04 25, 00000028
        jz      ?_060                                   ; 0D71 _ 74, 05
        call    __stack_chk_fail                        ; 0D73 _ E8, 00000000(PLT r)
?_060:  leave                                           ; 0D78 _ C9
        ret                                             ; 0D79 _ C3

dump_grpdef:; Local function
        push    rbp                                     ; 0D7A _ 55
        mov     rbp, rsp                                ; 0D7B _ 48: 89. E5
        sub     rsp, 80                                 ; 0D7E _ 48: 83. EC, 50
        mov     byte [rbp-31H], dil                     ; 0D82 _ 40: 88. 7D, CF
        mov     qword [rbp-40H], rsi                    ; 0D86 _ 48: 89. 75, C0
        mov     qword [rbp-48H], rdx                    ; 0D8A _ 48: 89. 55, B8
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        mov     rax, qword [fs:abs 28H]                 ; 0D8E _ 64 48: 8B. 04 25, 00000028
        mov     qword [rbp-8H], rax                     ; 0D97 _ 48: 89. 45, F8
        xor     eax, eax                                ; 0D9B _ 31. C0
        mov     rax, qword [rbp-40H]                    ; 0D9D _ 48: 8B. 45, C0
        mov     qword [rbp-28H], rax                    ; 0DA1 _ 48: 89. 45, D8
        mov     rdx, qword [rbp-40H]                    ; 0DA5 _ 48: 8B. 55, C0
        mov     rax, qword [rbp-48H]                    ; 0DA9 _ 48: 8B. 45, B8
        add     rax, rdx                                ; 0DAD _ 48: 01. D0
        mov     qword [rbp-20H], rax                    ; 0DB0 _ 48: 89. 45, E0
        mov     edi, 2                                  ; 0DB4 _ BF, 00000002
        call    xmalloc                                 ; 0DB9 _ E8, FFFFF295
        mov     qword [rbp-18H], rax                    ; 0DBE _ 48: 89. 45, E8
        lea     rax, [rbp-28H]                          ; 0DC2 _ 48: 8D. 45, D8
        mov     rdi, rax                                ; 0DC6 _ 48: 89. C7
        call    get_index                               ; 0DC9 _ E8, FFFFF90B
        mov     word [rbp-2AH], ax                      ; 0DCE _ 66: 89. 45, D6
        mov     rax, qword [rbp-18H]                    ; 0DD2 _ 48: 8B. 45, E8
        movzx   edx, word [rbp-2AH]                     ; 0DD6 _ 0F B7. 55, D6
        mov     word [rax], dx                          ; 0DDA _ 66: 89. 10
        mov     rax, qword [rbp-28H]                    ; 0DDD _ 48: 8B. 45, D8
        cmp     qword [rbp-20H], rax                    ; 0DE1 _ 48: 39. 45, E0
        jc      ?_064                                   ; 0DE5 _ 0F 82, 000000EF
        mov     rax, qword [rbp-18H]                    ; 0DEB _ 48: 8B. 45, E8
        lea     rdx, [rel c_groups]                     ; 0DEF _ 48: 8D. 15, 00000000(rel)
        mov     rsi, rax                                ; 0DF6 _ 48: 89. C6
        mov     rdi, rdx                                ; 0DF9 _ 48: 89. D7
        call    add_collection                          ; 0DFC _ E8, FFFFF33B
        movzx   eax, word [rbp-2AH]                     ; 0E01 _ 0F B7. 45, D6
        mov     edi, eax                                ; 0E05 _ 89. C7
        call    lname                                   ; 0E07 _ E8, FFFFF97D
        mov     qword [rbp-10H], rax                    ; 0E0C _ 48: 89. 45, F0
        mov     rax, qword [rbp-10H]                    ; 0E10 _ 48: 8B. 45, F0
        lea     rdx, [rel ?_175]                        ; 0E14 _ 48: 8D. 15, 00000000(rel)
        mov     rsi, rax                                ; 0E1B _ 48: 89. C6
        mov     rdi, rdx                                ; 0E1E _ 48: 89. D7
        mov     eax, 0                                  ; 0E21 _ B8, 00000000
        call    printf                                  ; 0E26 _ E8, 00000000(PLT r)
        jmp     ?_063                                   ; 0E2B _ E9, 0000009A

?_061:  mov     rax, qword [rbp-28H]                    ; 0E30 _ 48: 8B. 45, D8
        movzx   eax, byte [rax]                         ; 0E34 _ 0F B6. 00
        cmp     al, 255                                 ; 0E37 _ 3C, FF
        jnz     ?_062                                   ; 0E39 _ 75, 3E
        mov     rax, qword [rbp-28H]                    ; 0E3B _ 48: 8B. 45, D8
        add     rax, 1                                  ; 0E3F _ 48: 83. C0, 01
        mov     qword [rbp-28H], rax                    ; 0E43 _ 48: 89. 45, D8
        lea     rax, [rbp-28H]                          ; 0E47 _ 48: 8D. 45, D8
        mov     rdi, rax                                ; 0E4B _ 48: 89. C7
        call    get_index                               ; 0E4E _ E8, FFFFF886
        movzx   eax, ax                                 ; 0E53 _ 0F B7. C0
        mov     edi, eax                                ; 0E56 _ 89. C7
        call    segment_name                            ; 0E58 _ E8, FFFFF957
        mov     rdx, rax                                ; 0E5D _ 48: 89. C2
        lea     rax, [rel ?_176]                        ; 0E60 _ 48: 8D. 05, 00000000(rel)
        mov     rsi, rdx                                ; 0E67 _ 48: 89. D6
        mov     rdi, rax                                ; 0E6A _ 48: 89. C7
        mov     eax, 0                                  ; 0E6D _ B8, 00000000
        call    printf                                  ; 0E72 _ E8, 00000000(PLT r)
        jmp     ?_063                                   ; 0E77 _ EB, 51

?_062:  mov     rax, qword [rbp-28H]                    ; 0E79 _ 48: 8B. 45, D8
        movzx   eax, byte [rax]                         ; 0E7D _ 0F B6. 00
        cmp     al, 254                                 ; 0E80 _ 3C, FE
        jnz     ?_065                                   ; 0E82 _ 75, 59
        mov     rax, qword [rbp-28H]                    ; 0E84 _ 48: 8B. 45, D8
        add     rax, 1                                  ; 0E88 _ 48: 83. C0, 01
        mov     qword [rbp-28H], rax                    ; 0E8C _ 48: 89. 45, D8
        lea     rax, [rbp-28H]                          ; 0E90 _ 48: 8D. 45, D8
        mov     rdi, rax                                ; 0E94 _ 48: 89. C7
        call    get_index                               ; 0E97 _ E8, FFFFF83D
        mov     word [rbp-2AH], ax                      ; 0E9C _ 66: 89. 45, D6
        movzx   eax, word [rbp-2AH]                     ; 0EA0 _ 0F B7. 45, D6
        mov     edi, eax                                ; 0EA4 _ 89. C7
        call    lname                                   ; 0EA6 _ E8, FFFFF8DE
        mov     qword [rbp-10H], rax                    ; 0EAB _ 48: 89. 45, F0
        mov     rax, qword [rbp-10H]                    ; 0EAF _ 48: 8B. 45, F0
        lea     rdx, [rel ?_177]                        ; 0EB3 _ 48: 8D. 15, 00000000(rel)
        mov     rsi, rax                                ; 0EBA _ 48: 89. C6
        mov     rdi, rdx                                ; 0EBD _ 48: 89. D7
        mov     eax, 0                                  ; 0EC0 _ B8, 00000000
        call    printf                                  ; 0EC5 _ E8, 00000000(PLT r)
?_063:  mov     rax, qword [rbp-28H]                    ; 0ECA _ 48: 8B. 45, D8
        cmp     rax, qword [rbp-20H]                    ; 0ECE _ 48: 3B. 45, E0
        jc      ?_061                                   ; 0ED2 _ 0F 82, FFFFFF58
        jmp     ?_066                                   ; 0ED8 _ EB, 04

?_064:  nop                                             ; 0EDA _ 90
        jmp     ?_066                                   ; 0EDB _ EB, 01

?_065:  nop                                             ; 0EDD _ 90
?_066:  mov     rcx, qword [rbp-48H]                    ; 0EDE _ 48: 8B. 4D, B8
        mov     rdx, qword [rbp-48H]                    ; 0EE2 _ 48: 8B. 55, B8
        mov     rax, qword [rbp-40H]                    ; 0EE6 _ 48: 8B. 45, C0
        mov     rsi, rax                                ; 0EEA _ 48: 89. C6
        mov     edi, 0                                  ; 0EED _ BF, 00000000
        call    hexdump_data                            ; 0EF2 _ E8, FFFFF342
        nop                                             ; 0EF7 _ 90
        mov     rax, qword [rbp-8H]                     ; 0EF8 _ 48: 8B. 45, F8
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        sub     rax, qword [fs:abs 28H]                 ; 0EFC _ 64 48: 2B. 04 25, 00000028
        jz      ?_067                                   ; 0F05 _ 74, 05
        call    __stack_chk_fail                        ; 0F07 _ E8, 00000000(PLT r)
?_067:  leave                                           ; 0F0C _ C9
        ret                                             ; 0F0D _ C3

dump_fixdat:; Local function
        push    rbp                                     ; 0F0E _ 55
        mov     rbp, rsp                                ; 0F0F _ 48: 89. E5
        sub     rsp, 48                                 ; 0F12 _ 48: 83. EC, 30
        mov     byte [rbp-21H], dil                     ; 0F16 _ 40: 88. 7D, DF
        mov     qword [rbp-30H], rsi                    ; 0F1A _ 48: 89. 75, D0
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        mov     rax, qword [fs:abs 28H]                 ; 0F1E _ 64 48: 8B. 04 25, 00000028
        mov     qword [rbp-8H], rax                     ; 0F27 _ 48: 89. 45, F8
        xor     eax, eax                                ; 0F2B _ 31. C0
        mov     rax, qword [rbp-30H]                    ; 0F2D _ 48: 8B. 45, D0
        mov     rax, qword [rax]                        ; 0F31 _ 48: 8B. 00
        mov     qword [rbp-10H], rax                    ; 0F34 _ 48: 89. 45, F0
        mov     rax, qword [rbp-10H]                    ; 0F38 _ 48: 8B. 45, F0
        lea     rdx, [rax+1H]                           ; 0F3C _ 48: 8D. 50, 01
        mov     qword [rbp-10H], rdx                    ; 0F40 _ 48: 89. 55, F0
        movzx   eax, byte [rax]                         ; 0F44 _ 0F B6. 00
        mov     byte [rbp-13H], al                      ; 0F47 _ 88. 45, ED
        movzx   eax, byte [rbp-13H]                     ; 0F4A _ 0F B6. 45, ED
        and     eax, 0C0H                               ; 0F4E _ 25, 000000C0
        cmp     eax, 192                                ; 0F53 _ 3D, 000000C0
        jnz     ?_068                                   ; 0F58 _ 75, 09
        lea     rdx, [rel ?_178]                        ; 0F5A _ 48: 8D. 15, 00000000(rel)
        jmp     ?_069                                   ; 0F61 _ EB, 07

?_068:  lea     rdx, [rel ?_161]                        ; 0F63 _ 48: 8D. 15, 00000000(rel)
?_069:  movzx   eax, byte [rbp-13H]                     ; 0F6A _ 0F B6. 45, ED
        sar     eax, 4                                  ; 0F6E _ C1. F8, 04
        and     eax, 07H                                ; 0F71 _ 83. E0, 07
        mov     esi, eax                                ; 0F74 _ 89. C6
        movzx   eax, byte [rbp-13H]                     ; 0F76 _ 0F B6. 45, ED
        test    al, al                                  ; 0F7A _ 84. C0
        jns     ?_070                                   ; 0F7C _ 79, 09
        lea     rax, [rel ?_179]                        ; 0F7E _ 48: 8D. 05, 00000000(rel)
        jmp     ?_071                                   ; 0F85 _ EB, 07

?_070:  lea     rax, [rel ?_180]                        ; 0F87 _ 48: 8D. 05, 00000000(rel)
?_071:  lea     rdi, [rel ?_181]                        ; 0F8E _ 48: 8D. 3D, 00000000(rel)
        mov     rcx, rdx                                ; 0F95 _ 48: 89. D1
        mov     edx, esi                                ; 0F98 _ 89. F2
        mov     rsi, rax                                ; 0F9A _ 48: 89. C6
        mov     eax, 0                                  ; 0F9D _ B8, 00000000
        call    printf                                  ; 0FA2 _ E8, 00000000(PLT r)
        movzx   eax, byte [rbp-13H]                     ; 0FA7 _ 0F B6. 45, ED
        test    al, al                                  ; 0FAB _ 84. C0
        js      ?_072                                   ; 0FAD _ 78, 3C
        movzx   eax, byte [rbp-13H]                     ; 0FAF _ 0F B6. 45, ED
        shr     al, 4                                   ; 0FB3 _ C0. E8, 04
        movzx   eax, al                                 ; 0FB6 _ 0F B6. C0
        and     eax, 07H                                ; 0FB9 _ 83. E0, 07
        add     eax, 8                                  ; 0FBC _ 83. C0, 08
        cdqe                                            ; 0FBF _ 48: 98
        lea     rdx, [rax*8]                            ; 0FC1 _ 48: 8D. 14 C5, 00000000
        lea     rax, [rel method_base]                  ; 0FC9 _ 48: 8D. 05, 00000000(rel)
        mov     rax, qword [rdx+rax]                    ; 0FD0 _ 48: 8B. 04 02
        lea     rdx, [rel ?_182]                        ; 0FD4 _ 48: 8D. 15, 00000000(rel)
        mov     rsi, rax                                ; 0FDB _ 48: 89. C6
        mov     rdi, rdx                                ; 0FDE _ 48: 89. D7
        mov     eax, 0                                  ; 0FE1 _ B8, 00000000
        call    printf                                  ; 0FE6 _ E8, 00000000(PLT r)
?_072:  movzx   eax, byte [rbp-13H]                     ; 0FEB _ 0F B6. 45, ED
        and     eax, 0C0H                               ; 0FEF _ 25, 000000C0
        test    eax, eax                                ; 0FF4 _ 85. C0
        jne     ?_075                                   ; 0FF6 _ 0F 85, 000000BE
        lea     rax, [rbp-10H]                          ; 0FFC _ 48: 8D. 45, F0
        mov     rdi, rax                                ; 1000 _ 48: 89. C7
        call    get_index                               ; 1003 _ E8, FFFFF6D1
        mov     word [rbp-12H], ax                      ; 1008 _ 66: 89. 45, EE
        movzx   eax, word [rbp-12H]                     ; 100C _ 0F B7. 45, EE
        lea     rdx, [rel ?_183]                        ; 1010 _ 48: 8D. 15, 00000000(rel)
        mov     esi, eax                                ; 1017 _ 89. C6
        mov     rdi, rdx                                ; 1019 _ 48: 89. D7
        mov     eax, 0                                  ; 101C _ B8, 00000000
        call    printf                                  ; 1021 _ E8, 00000000(PLT r)
        movzx   eax, byte [rbp-13H]                     ; 1026 _ 0F B6. 45, ED
        shr     al, 4                                   ; 102A _ C0. E8, 04
        test    al, al                                  ; 102D _ 84. C0
        jnz     ?_073                                   ; 102F _ 75, 27
        movzx   eax, word [rbp-12H]                     ; 1031 _ 0F B7. 45, EE
        mov     edi, eax                                ; 1035 _ 89. C7
        call    segment_name                            ; 1037 _ E8, FFFFF778
        mov     rdx, rax                                ; 103C _ 48: 89. C2
        lea     rax, [rel ?_184]                        ; 103F _ 48: 8D. 05, 00000000(rel)
        mov     rsi, rdx                                ; 1046 _ 48: 89. D6
        mov     rdi, rax                                ; 1049 _ 48: 89. C7
        mov     eax, 0                                  ; 104C _ B8, 00000000
        call    printf                                  ; 1051 _ E8, 00000000(PLT r)
        jmp     ?_075                                   ; 1056 _ EB, 62

?_073:  movzx   eax, byte [rbp-13H]                     ; 1058 _ 0F B6. 45, ED
        shr     al, 4                                   ; 105C _ C0. E8, 04
        cmp     al, 1                                   ; 105F _ 3C, 01
        jnz     ?_074                                   ; 1061 _ 75, 27
        movzx   eax, word [rbp-12H]                     ; 1063 _ 0F B7. 45, EE
        mov     edi, eax                                ; 1067 _ 89. C7
        call    group_name                              ; 1069 _ E8, FFFFF794
        mov     rdx, rax                                ; 106E _ 48: 89. C2
        lea     rax, [rel ?_184]                        ; 1071 _ 48: 8D. 05, 00000000(rel)
        mov     rsi, rdx                                ; 1078 _ 48: 89. D6
        mov     rdi, rax                                ; 107B _ 48: 89. C7
        mov     eax, 0                                  ; 107E _ B8, 00000000
        call    printf                                  ; 1083 _ E8, 00000000(PLT r)
        jmp     ?_075                                   ; 1088 _ EB, 30

?_074:  movzx   eax, byte [rbp-13H]                     ; 108A _ 0F B6. 45, ED
        shr     al, 4                                   ; 108E _ C0. E8, 04
        cmp     al, 2                                   ; 1091 _ 3C, 02
        jnz     ?_075                                   ; 1093 _ 75, 25
        movzx   eax, word [rbp-12H]                     ; 1095 _ 0F B7. 45, EE
        mov     edi, eax                                ; 1099 _ 89. C7
        call    external_name                           ; 109B _ E8, FFFFF7B0
        mov     rdx, rax                                ; 10A0 _ 48: 89. C2
        lea     rax, [rel ?_184]                        ; 10A3 _ 48: 8D. 05, 00000000(rel)
        mov     rsi, rdx                                ; 10AA _ 48: 89. D6
        mov     rdi, rax                                ; 10AD _ 48: 89. C7
        mov     eax, 0                                  ; 10B0 _ B8, 00000000
        call    printf                                  ; 10B5 _ E8, 00000000(PLT r)
?_075:  movzx   eax, byte [rbp-13H]                     ; 10BA _ 0F B6. 45, ED
        and     eax, 07H                                ; 10BE _ 83. E0, 07
        mov     edx, eax                                ; 10C1 _ 89. C2
        movzx   eax, byte [rbp-13H]                     ; 10C3 _ 0F B6. 45, ED
        and     eax, 08H                                ; 10C7 _ 83. E0, 08
        test    eax, eax                                ; 10CA _ 85. C0
        jz      ?_076                                   ; 10CC _ 74, 09
        lea     rax, [rel ?_179]                        ; 10CE _ 48: 8D. 05, 00000000(rel)
        jmp     ?_077                                   ; 10D5 _ EB, 07

?_076:  lea     rax, [rel ?_185]                        ; 10D7 _ 48: 8D. 05, 00000000(rel)
?_077:  lea     rcx, [rel ?_186]                        ; 10DE _ 48: 8D. 0D, 00000000(rel)
        mov     rsi, rax                                ; 10E5 _ 48: 89. C6
        mov     rdi, rcx                                ; 10E8 _ 48: 89. CF
        mov     eax, 0                                  ; 10EB _ B8, 00000000
        call    printf                                  ; 10F0 _ E8, 00000000(PLT r)
        movzx   eax, byte [rbp-13H]                     ; 10F5 _ 0F B6. 45, ED
        and     eax, 08H                                ; 10F9 _ 83. E0, 08
        test    eax, eax                                ; 10FC _ 85. C0
        jnz     ?_078                                   ; 10FE _ 75, 33
        movzx   eax, byte [rbp-13H]                     ; 1100 _ 0F B6. 45, ED
        and     eax, 07H                                ; 1104 _ 83. E0, 07
        cdqe                                            ; 1107 _ 48: 98
        lea     rdx, [rax*8]                            ; 1109 _ 48: 8D. 14 C5, 00000000
        lea     rax, [rel method_base]                  ; 1111 _ 48: 8D. 05, 00000000(rel)
        mov     rax, qword [rdx+rax]                    ; 1118 _ 48: 8B. 04 02
        lea     rdx, [rel ?_182]                        ; 111C _ 48: 8D. 15, 00000000(rel)
        mov     rsi, rax                                ; 1123 _ 48: 89. C6
        mov     rdi, rdx                                ; 1126 _ 48: 89. D7
        mov     eax, 0                                  ; 1129 _ B8, 00000000
        call    printf                                  ; 112E _ E8, 00000000(PLT r)
?_078:  movzx   eax, byte [rbp-13H]                     ; 1133 _ 0F B6. 45, ED
        and     eax, 08H                                ; 1137 _ 83. E0, 08
        test    eax, eax                                ; 113A _ 85. C0
        jne     ?_081                                   ; 113C _ 0F 85, 000000C0
        lea     rax, [rbp-10H]                          ; 1142 _ 48: 8D. 45, F0
        mov     rdi, rax                                ; 1146 _ 48: 89. C7
        call    get_index                               ; 1149 _ E8, FFFFF58B
        mov     word [rbp-12H], ax                      ; 114E _ 66: 89. 45, EE
        movzx   eax, word [rbp-12H]                     ; 1152 _ 0F B7. 45, EE
        lea     rdx, [rel ?_183]                        ; 1156 _ 48: 8D. 15, 00000000(rel)
        mov     esi, eax                                ; 115D _ 89. C6
        mov     rdi, rdx                                ; 115F _ 48: 89. D7
        mov     eax, 0                                  ; 1162 _ B8, 00000000
        call    printf                                  ; 1167 _ E8, 00000000(PLT r)
        movzx   eax, byte [rbp-13H]                     ; 116C _ 0F B6. 45, ED
        and     eax, 03H                                ; 1170 _ 83. E0, 03
        test    eax, eax                                ; 1173 _ 85. C0
        jnz     ?_079                                   ; 1175 _ 75, 27
        movzx   eax, word [rbp-12H]                     ; 1177 _ 0F B7. 45, EE
        mov     edi, eax                                ; 117B _ 89. C7
        call    segment_name                            ; 117D _ E8, FFFFF632
        mov     rdx, rax                                ; 1182 _ 48: 89. C2
        lea     rax, [rel ?_184]                        ; 1185 _ 48: 8D. 05, 00000000(rel)
        mov     rsi, rdx                                ; 118C _ 48: 89. D6
        mov     rdi, rax                                ; 118F _ 48: 89. C7
        mov     eax, 0                                  ; 1192 _ B8, 00000000
        call    printf                                  ; 1197 _ E8, 00000000(PLT r)
        jmp     ?_081                                   ; 119C _ EB, 64

?_079:  movzx   eax, byte [rbp-13H]                     ; 119E _ 0F B6. 45, ED
        and     eax, 03H                                ; 11A2 _ 83. E0, 03
        cmp     eax, 1                                  ; 11A5 _ 83. F8, 01
        jnz     ?_080                                   ; 11A8 _ 75, 27
        movzx   eax, word [rbp-12H]                     ; 11AA _ 0F B7. 45, EE
        mov     edi, eax                                ; 11AE _ 89. C7
        call    group_name                              ; 11B0 _ E8, FFFFF64D
        mov     rdx, rax                                ; 11B5 _ 48: 89. C2
        lea     rax, [rel ?_184]                        ; 11B8 _ 48: 8D. 05, 00000000(rel)
        mov     rsi, rdx                                ; 11BF _ 48: 89. D6
        mov     rdi, rax                                ; 11C2 _ 48: 89. C7
        mov     eax, 0                                  ; 11C5 _ B8, 00000000
        call    printf                                  ; 11CA _ E8, 00000000(PLT r)
        jmp     ?_081                                   ; 11CF _ EB, 31

?_080:  movzx   eax, byte [rbp-13H]                     ; 11D1 _ 0F B6. 45, ED
        and     eax, 03H                                ; 11D5 _ 83. E0, 03
        cmp     eax, 2                                  ; 11D8 _ 83. F8, 02
        jnz     ?_081                                   ; 11DB _ 75, 25
        movzx   eax, word [rbp-12H]                     ; 11DD _ 0F B7. 45, EE
        mov     edi, eax                                ; 11E1 _ 89. C7
        call    external_name                           ; 11E3 _ E8, FFFFF668
        mov     rdx, rax                                ; 11E8 _ 48: 89. C2
        lea     rax, [rel ?_184]                        ; 11EB _ 48: 8D. 05, 00000000(rel)
        mov     rsi, rdx                                ; 11F2 _ 48: 89. D6
        mov     rdi, rax                                ; 11F5 _ 48: 89. C7
        mov     eax, 0                                  ; 11F8 _ B8, 00000000
        call    printf                                  ; 11FD _ E8, 00000000(PLT r)
?_081:  movzx   eax, byte [rbp-13H]                     ; 1202 _ 0F B6. 45, ED
        and     eax, 04H                                ; 1206 _ 83. E0, 04
        test    eax, eax                                ; 1209 _ 85. C0
        jnz     ?_083                                   ; 120B _ 75, 51
        cmp     byte [rbp-21H], 0                       ; 120D _ 80. 7D, DF, 00
        jz      ?_082                                   ; 1211 _ 74, 26
        lea     rax, [rbp-10H]                          ; 1213 _ 48: 8D. 45, F0
        mov     rdi, rax                                ; 1217 _ 48: 89. C7
        call    get_32                                  ; 121A _ E8, FFFFF53F
        mov     edx, eax                                ; 121F _ 89. C2
        lea     rax, [rel ?_187]                        ; 1221 _ 48: 8D. 05, 00000000(rel)
        mov     esi, edx                                ; 1228 _ 89. D6
        mov     rdi, rax                                ; 122A _ 48: 89. C7
        mov     eax, 0                                  ; 122D _ B8, 00000000
        call    printf                                  ; 1232 _ E8, 00000000(PLT r)
        jmp     ?_083                                   ; 1237 _ EB, 25

?_082:  lea     rax, [rbp-10H]                          ; 1239 _ 48: 8D. 45, F0
        mov     rdi, rax                                ; 123D _ 48: 89. C7
        call    get_16                                  ; 1240 _ E8, FFFFF4EB
        movzx   eax, ax                                 ; 1245 _ 0F B7. C0
        lea     rdx, [rel ?_188]                        ; 1248 _ 48: 8D. 15, 00000000(rel)
        mov     esi, eax                                ; 124F _ 89. C6
        mov     rdi, rdx                                ; 1251 _ 48: 89. D7
        mov     eax, 0                                  ; 1254 _ B8, 00000000
        call    printf                                  ; 1259 _ E8, 00000000(PLT r)
?_083:  mov     edi, 10                                 ; 125E _ BF, 0000000A
        call    putchar                                 ; 1263 _ E8, 00000000(PLT r)
        mov     rdx, qword [rbp-10H]                    ; 1268 _ 48: 8B. 55, F0
        mov     rax, qword [rbp-30H]                    ; 126C _ 48: 8B. 45, D0
        mov     qword [rax], rdx                        ; 1270 _ 48: 89. 10
        nop                                             ; 1273 _ 90
        mov     rax, qword [rbp-8H]                     ; 1274 _ 48: 8B. 45, F8
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        sub     rax, qword [fs:abs 28H]                 ; 1278 _ 64 48: 2B. 04 25, 00000028
        jz      ?_084                                   ; 1281 _ 74, 05
        call    __stack_chk_fail                        ; 1283 _ E8, 00000000(PLT r)
?_084:  leave                                           ; 1288 _ C9
        ret                                             ; 1289 _ C3

dump_fixupp:; Local function
        push    rbp                                     ; 128A _ 55
        mov     rbp, rsp                                ; 128B _ 48: 89. E5
        sub     rsp, 80                                 ; 128E _ 48: 83. EC, 50
        mov     byte [rbp-31H], dil                     ; 1292 _ 40: 88. 7D, CF
        mov     qword [rbp-40H], rsi                    ; 1296 _ 48: 89. 75, C0
        mov     qword [rbp-48H], rdx                    ; 129A _ 48: 89. 55, B8
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        mov     rax, qword [fs:abs 28H]                 ; 129E _ 64 48: 8B. 04 25, 00000028
        mov     qword [rbp-8H], rax                     ; 12A7 _ 48: 89. 45, F8
        xor     eax, eax                                ; 12AB _ 31. C0
        movzx   eax, byte [rbp-31H]                     ; 12AD _ 0F B6. 45, CF
        and     eax, 01H                                ; 12B1 _ 83. E0, 01
        mov     byte [rbp-23H], al                      ; 12B4 _ 88. 45, DD
        mov     rax, qword [rbp-40H]                    ; 12B7 _ 48: 8B. 45, C0
        mov     qword [rbp-20H], rax                    ; 12BB _ 48: 89. 45, E0
        mov     rdx, qword [rbp-40H]                    ; 12BF _ 48: 8B. 55, C0
        mov     rax, qword [rbp-48H]                    ; 12C3 _ 48: 8B. 45, B8
        add     rax, rdx                                ; 12C7 _ 48: 01. D0
        mov     qword [rbp-18H], rax                    ; 12CA _ 48: 89. 45, E8
        jmp     ?_097                                   ; 12CE _ E9, 000001FD

?_085:  mov     rax, qword [rbp-20H]                    ; 12D3 _ 48: 8B. 45, E0
        mov     qword [rbp-10H], rax                    ; 12D7 _ 48: 89. 45, F0
        mov     rax, qword [rbp-20H]                    ; 12DB _ 48: 8B. 45, E0
        lea     rdx, [rax+1H]                           ; 12DF _ 48: 8D. 50, 01
        mov     qword [rbp-20H], rdx                    ; 12E3 _ 48: 89. 55, E0
        movzx   eax, byte [rax]                         ; 12E7 _ 0F B6. 00
        mov     byte [rbp-22H], al                      ; 12EA _ 88. 45, DE
        movzx   eax, byte [rbp-22H]                     ; 12ED _ 0F B6. 45, DE
        test    al, al                                  ; 12F1 _ 84. C0
        js      ?_093                                   ; 12F3 _ 0F 88, 00000105
        movzx   eax, byte [rbp-22H]                     ; 12F9 _ 0F B6. 45, DE
        and     eax, 40H                                ; 12FD _ 83. E0, 40
        shr     eax, 6                                  ; 1300 _ C1. E8, 06
        and     eax, 01H                                ; 1303 _ 83. E0, 01
        mov     byte [rbp-21H], al                      ; 1306 _ 88. 45, DF
        movzx   eax, byte [rbp-22H]                     ; 1309 _ 0F B6. 45, DE
        sar     eax, 3                                  ; 130D _ C1. F8, 03
        and     eax, 08H                                ; 1310 _ 83. E0, 08
        mov     edx, eax                                ; 1313 _ 89. C2
        movzx   eax, byte [rbp-22H]                     ; 1315 _ 0F B6. 45, DE
        sar     eax, 2                                  ; 1319 _ C1. F8, 02
        and     eax, 07H                                ; 131C _ 83. E0, 07
        or      eax, edx                                ; 131F _ 09. D0
        cdqe                                            ; 1321 _ 48: 98
        lea     rdx, [rax*8]                            ; 1323 _ 48: 8D. 14 C5, 00000000
        lea     rax, [rel method_base]                  ; 132B _ 48: 8D. 05, 00000000(rel)
        mov     rcx, qword [rdx+rax]                    ; 1332 _ 48: 8B. 0C 02
        movzx   eax, byte [rbp-22H]                     ; 1336 _ 0F B6. 45, DE
        sar     eax, 2                                  ; 133A _ C1. F8, 02
        and     eax, 07H                                ; 133D _ 83. E0, 07
        mov     r8d, eax                                ; 1340 _ 41: 89. C0
        movzx   eax, byte [rbp-22H]                     ; 1343 _ 0F B6. 45, DE
        and     eax, 40H                                ; 1347 _ 83. E0, 40
        test    eax, eax                                ; 134A _ 85. C0
        jz      ?_086                                   ; 134C _ 74, 08
        mov     r10d, 70                                ; 134E _ 41: BA, 00000046
        jmp     ?_087                                   ; 1354 _ EB, 06

?_086:  mov     r10d, 84                                ; 1356 _ 41: BA, 00000054
?_087:  movzx   eax, byte [rbp-22H]                     ; 135C _ 0F B6. 45, DE
        and     eax, 20H                                ; 1360 _ 83. E0, 20
        test    eax, eax                                ; 1363 _ 85. C0
        jz      ?_088                                   ; 1365 _ 74, 09
        lea     rdx, [rel ?_189]                        ; 1367 _ 48: 8D. 15, 00000000(rel)
        jmp     ?_089                                   ; 136E _ EB, 07

?_088:  lea     rdx, [rel ?_161]                        ; 1370 _ 48: 8D. 15, 00000000(rel)
?_089:  movzx   eax, byte [rbp-22H]                     ; 1377 _ 0F B6. 45, DE
        and     eax, 03H                                ; 137B _ 83. E0, 03
        mov     esi, eax                                ; 137E _ 89. C6
        cmp     byte [rbp-21H], 0                       ; 1380 _ 80. 7D, DF, 00
        jz      ?_090                                   ; 1384 _ 74, 09
        lea     rax, [rel ?_190]                        ; 1386 _ 48: 8D. 05, 00000000(rel)
        jmp     ?_091                                   ; 138D _ EB, 07

?_090:  lea     rax, [rel ?_191]                        ; 138F _ 48: 8D. 05, 00000000(rel)
?_091:  lea     rdi, [rel ?_192]                        ; 1396 _ 48: 8D. 3D, 00000000(rel)
        sub     rsp, 8                                  ; 139D _ 48: 83. EC, 08
        push    rcx                                     ; 13A1 _ 51
        mov     r9d, r8d                                ; 13A2 _ 45: 89. C1
        mov     r8d, r10d                               ; 13A5 _ 45: 89. D0
        mov     rcx, rdx                                ; 13A8 _ 48: 89. D1
        mov     edx, esi                                ; 13AB _ 89. F2
        mov     rsi, rax                                ; 13AD _ 48: 89. C6
        mov     eax, 0                                  ; 13B0 _ B8, 00000000
        call    printf                                  ; 13B5 _ E8, 00000000(PLT r)
        add     rsp, 16                                 ; 13BA _ 48: 83. C4, 10
        movzx   eax, byte [rbp-22H]                     ; 13BE _ 0F B6. 45, DE
        and     eax, 50H                                ; 13C2 _ 83. E0, 50
        cmp     eax, 80                                 ; 13C5 _ 83. F8, 50
        jz      ?_092                                   ; 13C8 _ 74, 25
        lea     rax, [rbp-20H]                          ; 13CA _ 48: 8D. 45, E0
        mov     rdi, rax                                ; 13CE _ 48: 89. C7
        call    get_index                               ; 13D1 _ E8, FFFFF303
        movzx   eax, ax                                 ; 13D6 _ 0F B7. C0
        lea     rdx, [rel ?_183]                        ; 13D9 _ 48: 8D. 15, 00000000(rel)
        mov     esi, eax                                ; 13E0 _ 89. C6
        mov     rdi, rdx                                ; 13E2 _ 48: 89. D7
        mov     eax, 0                                  ; 13E5 _ B8, 00000000
        call    printf                                  ; 13EA _ E8, 00000000(PLT r)
?_092:  mov     edi, 10                                 ; 13EF _ BF, 0000000A
        call    putchar                                 ; 13F4 _ E8, 00000000(PLT r)
        jmp     ?_096                                   ; 13F9 _ E9, 00000096

?_093:  movzx   eax, byte [rbp-22H]                     ; 13FE _ 0F B6. 45, DE
        shl     eax, 8                                  ; 1402 _ C1. E0, 08
        and     eax, 300H                               ; 1405 _ 25, 00000300
        mov     ecx, eax                                ; 140A _ 89. C1
        mov     rax, qword [rbp-20H]                    ; 140C _ 48: 8B. 45, E0
        lea     rdx, [rax+1H]                           ; 1410 _ 48: 8D. 50, 01
        mov     qword [rbp-20H], rdx                    ; 1414 _ 48: 89. 55, E0
        movzx   eax, byte [rax]                         ; 1418 _ 0F B6. 00
        movzx   eax, al                                 ; 141B _ 0F B6. C0
        add     ecx, eax                                ; 141E _ 01. C1
        movzx   eax, byte [rbp-22H]                     ; 1420 _ 0F B6. 45, DE
        sar     eax, 2                                  ; 1424 _ C1. F8, 02
        and     eax, 0FH                                ; 1427 _ 83. E0, 0F
        cdqe                                            ; 142A _ 48: 98
        lea     rdx, [rax*8]                            ; 142C _ 48: 8D. 14 C5, 00000000
        lea     rax, [rel location_descr]               ; 1434 _ 48: 8D. 05, 00000000(rel)
        mov     rdx, qword [rdx+rax]                    ; 143B _ 48: 8B. 14 02
        movzx   eax, byte [rbp-22H]                     ; 143F _ 0F B6. 45, DE
        sar     eax, 2                                  ; 1443 _ C1. F8, 02
        and     eax, 0FH                                ; 1446 _ 83. E0, 0F
        mov     esi, eax                                ; 1449 _ 89. C6
        movzx   eax, byte [rbp-22H]                     ; 144B _ 0F B6. 45, DE
        and     eax, 40H                                ; 144F _ 83. E0, 40
        test    eax, eax                                ; 1452 _ 85. C0
        jz      ?_094                                   ; 1454 _ 74, 09
        lea     rax, [rel ?_193]                        ; 1456 _ 48: 8D. 05, 00000000(rel)
        jmp     ?_095                                   ; 145D _ EB, 07

?_094:  lea     rax, [rel ?_194]                        ; 145F _ 48: 8D. 05, 00000000(rel)
?_095:  lea     rdi, [rel ?_195]                        ; 1466 _ 48: 8D. 3D, 00000000(rel)
        mov     r8d, ecx                                ; 146D _ 41: 89. C8
        mov     rcx, rdx                                ; 1470 _ 48: 89. D1
        mov     edx, esi                                ; 1473 _ 89. F2
        mov     rsi, rax                                ; 1475 _ 48: 89. C6
        mov     eax, 0                                  ; 1478 _ B8, 00000000
        call    printf                                  ; 147D _ E8, 00000000(PLT r)
        lea     rdx, [rbp-20H]                          ; 1482 _ 48: 8D. 55, E0
        movzx   eax, byte [rbp-23H]                     ; 1486 _ 0F B6. 45, DD
        mov     rsi, rdx                                ; 148A _ 48: 89. D6
        mov     edi, eax                                ; 148D _ 89. C7
        call    dump_fixdat                             ; 148F _ E8, FFFFFA7A
?_096:  mov     rax, qword [rbp-10H]                    ; 1494 _ 48: 8B. 45, F0
        sub     rax, qword [rbp-40H]                    ; 1498 _ 48: 2B. 45, C0
        mov     rcx, rax                                ; 149C _ 48: 89. C1
        mov     rax, qword [rbp-48H]                    ; 149F _ 48: 8B. 45, B8
        sub     rax, rcx                                ; 14A3 _ 48: 29. C8
        mov     rdx, rax                                ; 14A6 _ 48: 89. C2
        mov     rax, qword [rbp-20H]                    ; 14A9 _ 48: 8B. 45, E0
        sub     rax, qword [rbp-10H]                    ; 14AD _ 48: 2B. 45, F0
        mov     rsi, rax                                ; 14B1 _ 48: 89. C6
        mov     rax, qword [rbp-10H]                    ; 14B4 _ 48: 8B. 45, F0
        sub     rax, qword [rbp-40H]                    ; 14B8 _ 48: 2B. 45, C0
        mov     edi, eax                                ; 14BC _ 89. C7
        mov     rax, qword [rbp-10H]                    ; 14BE _ 48: 8B. 45, F0
        mov     rcx, rdx                                ; 14C2 _ 48: 89. D1
        mov     rdx, rsi                                ; 14C5 _ 48: 89. F2
        mov     rsi, rax                                ; 14C8 _ 48: 89. C6
        call    hexdump_data                            ; 14CB _ E8, FFFFED69
?_097:  mov     rax, qword [rbp-20H]                    ; 14D0 _ 48: 8B. 45, E0
        cmp     rax, qword [rbp-18H]                    ; 14D4 _ 48: 3B. 45, E8
        jc      ?_085                                   ; 14D8 _ 0F 82, FFFFFDF5
        nop                                             ; 14DE _ 90
        mov     rax, qword [rbp-8H]                     ; 14DF _ 48: 8B. 45, F8
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        sub     rax, qword [fs:abs 28H]                 ; 14E3 _ 64 48: 2B. 04 25, 00000028
        jz      ?_098                                   ; 14EC _ 74, 05
        call    __stack_chk_fail                        ; 14EE _ E8, 00000000(PLT r)
?_098:  leave                                           ; 14F3 _ C9
        ret                                             ; 14F4 _ C3

dump_ledata:; Local function
        push    rbp                                     ; 14F5 _ 55
        mov     rbp, rsp                                ; 14F6 _ 48: 89. E5
        sub     rsp, 80                                 ; 14F9 _ 48: 83. EC, 50
        mov     byte [rbp-31H], dil                     ; 14FD _ 40: 88. 7D, CF
        mov     qword [rbp-40H], rsi                    ; 1501 _ 48: 89. 75, C0
        mov     qword [rbp-48H], rdx                    ; 1505 _ 48: 89. 55, B8
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        mov     rax, qword [fs:abs 28H]                 ; 1509 _ 64 48: 8B. 04 25, 00000028
        mov     qword [rbp-8H], rax                     ; 1512 _ 48: 89. 45, F8
        xor     eax, eax                                ; 1516 _ 31. C0
        movzx   eax, byte [rbp-31H]                     ; 1518 _ 0F B6. 45, CF
        and     eax, 01H                                ; 151C _ 83. E0, 01
        mov     byte [rbp-29H], al                      ; 151F _ 88. 45, D7
        mov     rax, qword [rbp-40H]                    ; 1522 _ 48: 8B. 45, C0
        mov     qword [rbp-28H], rax                    ; 1526 _ 48: 89. 45, D8
        lea     rax, [rbp-28H]                          ; 152A _ 48: 8D. 45, D8
        mov     rdi, rax                                ; 152E _ 48: 89. C7
        call    get_index                               ; 1531 _ E8, FFFFF1A3
        movzx   eax, ax                                 ; 1536 _ 0F B7. C0
        lea     rcx, [rel c_lsegs]                      ; 1539 _ 48: 8D. 0D, 00000000(rel)
        mov     edx, 0                                  ; 1540 _ BA, 00000000
        mov     rsi, rax                                ; 1545 _ 48: 89. C6
        mov     rdi, rcx                                ; 1548 _ 48: 89. CF
        call    get_collection                          ; 154B _ E8, FFFFEC54
        mov     qword [rbp-18H], rax                    ; 1550 _ 48: 89. 45, E8
        lea     rax, [rel ?_196]                        ; 1554 _ 48: 8D. 05, 00000000(rel)
        mov     qword [rbp-20H], rax                    ; 155B _ 48: 89. 45, E0
        cmp     qword [rbp-18H], 0                      ; 155F _ 48: 83. 7D, E8, 00
        jz      ?_099                                   ; 1564 _ 74, 15
        mov     rax, qword [rbp-18H]                    ; 1566 _ 48: 8B. 45, E8
        movzx   eax, word [rax]                         ; 156A _ 0F B7. 00
        movzx   eax, ax                                 ; 156D _ 0F B7. C0
        mov     edi, eax                                ; 1570 _ 89. C7
        call    lname                                   ; 1572 _ E8, FFFFF212
        mov     qword [rbp-20H], rax                    ; 1577 _ 48: 89. 45, E0
?_099:  mov     rax, qword [rbp-20H]                    ; 157B _ 48: 8B. 45, E0
        lea     rdx, [rel ?_197]                        ; 157F _ 48: 8D. 15, 00000000(rel)
        mov     rsi, rax                                ; 1586 _ 48: 89. C6
        mov     rdi, rdx                                ; 1589 _ 48: 89. D7
        mov     eax, 0                                  ; 158C _ B8, 00000000
        call    printf                                  ; 1591 _ E8, 00000000(PLT r)
        cmp     byte [rbp-29H], 0                       ; 1596 _ 80. 7D, D7, 00
        jz      ?_100                                   ; 159A _ 74, 26
        lea     rax, [rbp-28H]                          ; 159C _ 48: 8D. 45, D8
        mov     rdi, rax                                ; 15A0 _ 48: 89. C7
        call    get_32                                  ; 15A3 _ E8, FFFFF1B6
        mov     edx, eax                                ; 15A8 _ 89. C2
        lea     rax, [rel ?_198]                        ; 15AA _ 48: 8D. 05, 00000000(rel)
        mov     esi, edx                                ; 15B1 _ 89. D6
        mov     rdi, rax                                ; 15B3 _ 48: 89. C7
        mov     eax, 0                                  ; 15B6 _ B8, 00000000
        call    printf                                  ; 15BB _ E8, 00000000(PLT r)
        jmp     ?_101                                   ; 15C0 _ EB, 25

?_100:  lea     rax, [rbp-28H]                          ; 15C2 _ 48: 8D. 45, D8
        mov     rdi, rax                                ; 15C6 _ 48: 89. C7
        call    get_16                                  ; 15C9 _ E8, FFFFF162
        movzx   eax, ax                                 ; 15CE _ 0F B7. C0
        lea     rdx, [rel ?_199]                        ; 15D1 _ 48: 8D. 15, 00000000(rel)
        mov     esi, eax                                ; 15D8 _ 89. C6
        mov     rdi, rdx                                ; 15DA _ 48: 89. D7
        mov     eax, 0                                  ; 15DD _ B8, 00000000
        call    printf                                  ; 15E2 _ E8, 00000000(PLT r)
?_101:  mov     rax, qword [rbp-28H]                    ; 15E7 _ 48: 8B. 45, D8
        sub     rax, qword [rbp-40H]                    ; 15EB _ 48: 2B. 45, C0
        mov     rdx, rax                                ; 15EF _ 48: 89. C2
        mov     rax, qword [rbp-48H]                    ; 15F2 _ 48: 8B. 45, B8
        sub     rax, rdx                                ; 15F6 _ 48: 29. D0
        mov     qword [rbp-10H], rax                    ; 15F9 _ 48: 89. 45, F0
        mov     rax, qword [rbp-28H]                    ; 15FD _ 48: 8B. 45, D8
        mov     rcx, qword [rbp-10H]                    ; 1601 _ 48: 8B. 4D, F0
        mov     rdx, qword [rbp-10H]                    ; 1605 _ 48: 8B. 55, F0
        mov     rsi, rax                                ; 1609 _ 48: 89. C6
        mov     edi, 0                                  ; 160C _ BF, 00000000
        call    hexdump_data                            ; 1611 _ E8, FFFFEC23
        nop                                             ; 1616 _ 90
        mov     rax, qword [rbp-8H]                     ; 1617 _ 48: 8B. 45, F8
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        sub     rax, qword [fs:abs 28H]                 ; 161B _ 64 48: 2B. 04 25, 00000028
        jz      ?_102                                   ; 1624 _ 74, 05
        call    __stack_chk_fail                        ; 1626 _ E8, 00000000(PLT r)
?_102:  leave                                           ; 162B _ C9
        ret                                             ; 162C _ C3

dump_pubdef:; Local function
        push    rbp                                     ; 162D _ 55
        mov     rbp, rsp                                ; 162E _ 48: 89. E5
        sub     rsp, 80                                 ; 1631 _ 48: 83. EC, 50
        mov     byte [rbp-31H], dil                     ; 1635 _ 40: 88. 7D, CF
        mov     qword [rbp-40H], rsi                    ; 1639 _ 48: 89. 75, C0
        mov     qword [rbp-48H], rdx                    ; 163D _ 48: 89. 55, B8
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        mov     rax, qword [fs:abs 28H]                 ; 1641 _ 64 48: 8B. 04 25, 00000028
        mov     qword [rbp-8H], rax                     ; 164A _ 48: 89. 45, F8
        xor     eax, eax                                ; 164E _ 31. C0
        movzx   eax, byte [rbp-31H]                     ; 1650 _ 0F B6. 45, CF
        and     eax, 01H                                ; 1654 _ 83. E0, 01
        mov     byte [rbp-23H], al                      ; 1657 _ 88. 45, DD
        mov     rax, qword [rbp-40H]                    ; 165A _ 48: 8B. 45, C0
        mov     qword [rbp-18H], rax                    ; 165E _ 48: 89. 45, E8
        mov     rdx, qword [rbp-40H]                    ; 1662 _ 48: 8B. 55, C0
        mov     rax, qword [rbp-48H]                    ; 1666 _ 48: 8B. 45, B8
        add     rax, rdx                                ; 166A _ 48: 01. D0
        mov     qword [rbp-10H], rax                    ; 166D _ 48: 89. 45, F0
        lea     rax, [rbp-18H]                          ; 1671 _ 48: 8D. 45, E8
        mov     rdi, rax                                ; 1675 _ 48: 89. C7
        call    get_index                               ; 1678 _ E8, FFFFF05C
        mov     word [rbp-22H], ax                      ; 167D _ 66: 89. 45, DE
        mov     rax, qword [rbp-18H]                    ; 1681 _ 48: 8B. 45, E8
        cmp     qword [rbp-10H], rax                    ; 1685 _ 48: 39. 45, F0
        jc      ?_111                                   ; 1689 _ 0F 82, 000001C8
        lea     rax, [rbp-18H]                          ; 168F _ 48: 8D. 45, E8
        mov     rdi, rax                                ; 1693 _ 48: 89. C7
        call    get_index                               ; 1696 _ E8, FFFFF03E
        mov     word [rbp-20H], ax                      ; 169B _ 66: 89. 45, E0
        mov     rax, qword [rbp-18H]                    ; 169F _ 48: 8B. 45, E8
        cmp     qword [rbp-10H], rax                    ; 16A3 _ 48: 39. 45, F0
        jc      ?_112                                   ; 16A7 _ 0F 82, 000001AD
        cmp     word [rbp-22H], 0                       ; 16AD _ 66: 83. 7D, DE, 00
        jnz     ?_103                                   ; 16B2 _ 75, 2E
        cmp     word [rbp-20H], 0                       ; 16B4 _ 66: 83. 7D, E0, 00
        jnz     ?_103                                   ; 16B9 _ 75, 27
        lea     rax, [rbp-18H]                          ; 16BB _ 48: 8D. 45, E8
        mov     rdi, rax                                ; 16BF _ 48: 89. C7
        call    get_16                                  ; 16C2 _ E8, FFFFF069
        movzx   eax, ax                                 ; 16C7 _ 0F B7. C0
        lea     rdx, [rel ?_200]                        ; 16CA _ 48: 8D. 15, 00000000(rel)
        mov     esi, eax                                ; 16D1 _ 89. C6
        mov     rdi, rdx                                ; 16D3 _ 48: 89. D7
        mov     eax, 0                                  ; 16D6 _ B8, 00000000
        call    printf                                  ; 16DB _ E8, 00000000(PLT r)
        jmp     ?_105                                   ; 16E0 _ EB, 6C

?_103:  lea     rax, [rel ?_201]                        ; 16E2 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 16E9 _ 48: 89. C7
        mov     eax, 0                                  ; 16EC _ B8, 00000000
        call    printf                                  ; 16F1 _ E8, 00000000(PLT r)
        cmp     word [rbp-20H], 0                       ; 16F6 _ 66: 83. 7D, E0, 00
        jz      ?_104                                   ; 16FB _ 74, 25
        movzx   eax, word [rbp-20H]                     ; 16FD _ 0F B7. 45, E0
        mov     edi, eax                                ; 1701 _ 89. C7
        call    segment_name                            ; 1703 _ E8, FFFFF0AC
        mov     rdx, rax                                ; 1708 _ 48: 89. C2
        lea     rax, [rel ?_202]                        ; 170B _ 48: 8D. 05, 00000000(rel)
        mov     rsi, rdx                                ; 1712 _ 48: 89. D6
        mov     rdi, rax                                ; 1715 _ 48: 89. C7
        mov     eax, 0                                  ; 1718 _ B8, 00000000
        call    printf                                  ; 171D _ E8, 00000000(PLT r)
?_104:  cmp     word [rbp-22H], 0                       ; 1722 _ 66: 83. 7D, DE, 00
        jz      ?_105                                   ; 1727 _ 74, 25
        movzx   eax, word [rbp-22H]                     ; 1729 _ 0F B7. 45, DE
        mov     edi, eax                                ; 172D _ 89. C7
        call    group_name                              ; 172F _ E8, FFFFF0CE
        mov     rdx, rax                                ; 1734 _ 48: 89. C2
        lea     rax, [rel ?_203]                        ; 1737 _ 48: 8D. 05, 00000000(rel)
        mov     rsi, rdx                                ; 173E _ 48: 89. D6
        mov     rdi, rax                                ; 1741 _ 48: 89. C7
        mov     eax, 0                                  ; 1744 _ B8, 00000000
        call    printf                                  ; 1749 _ E8, 00000000(PLT r)
?_105:  lea     rax, [rel ?_161]                        ; 174E _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 1755 _ 48: 89. C7
        call    puts                                    ; 1758 _ E8, 00000000(PLT r)
        jmp     ?_110                                   ; 175D _ E9, 000000E5

?_106:  mov     eax, dword [rel pub_names_count.1]      ; 1762 _ 8B. 05, 00000000(rel)
        add     eax, 1                                  ; 1768 _ 83. C0, 01
        mov     dword [rel pub_names_count.1], eax      ; 176B _ 89. 05, 00000000(rel)
        mov     rax, qword [rbp-18H]                    ; 1771 _ 48: 8B. 45, E8
        lea     rdx, [rax+1H]                           ; 1775 _ 48: 8D. 50, 01
        mov     qword [rbp-18H], rdx                    ; 1779 _ 48: 89. 55, E8
        movzx   eax, byte [rax]                         ; 177D _ 0F B6. 00
        movzx   eax, al                                 ; 1780 _ 0F B6. C0
        mov     dword [rbp-1CH], eax                    ; 1783 _ 89. 45, E4
        mov     rcx, qword [rbp-18H]                    ; 1786 _ 48: 8B. 4D, E8
        mov     eax, dword [rel pub_names_count.1]      ; 178A _ 8B. 05, 00000000(rel)
        mov     edx, dword [rbp-1CH]                    ; 1790 _ 8B. 55, E4
        lea     rdi, [rel ?_204]                        ; 1793 _ 48: 8D. 3D, 00000000(rel)
        mov     esi, eax                                ; 179A _ 89. C6
        mov     eax, 0                                  ; 179C _ B8, 00000000
        call    printf                                  ; 17A1 _ E8, 00000000(PLT r)
        mov     rdx, qword [rbp-18H]                    ; 17A6 _ 48: 8B. 55, E8
        mov     eax, dword [rbp-1CH]                    ; 17AA _ 8B. 45, E4
        cdqe                                            ; 17AD _ 48: 98
        add     rax, rdx                                ; 17AF _ 48: 01. D0
        mov     qword [rbp-18H], rax                    ; 17B2 _ 48: 89. 45, E8
        cmp     byte [rbp-23H], 0                       ; 17B6 _ 80. 7D, DD, 00
        jz      ?_107                                   ; 17BA _ 74, 26
        lea     rax, [rbp-18H]                          ; 17BC _ 48: 8D. 45, E8
        mov     rdi, rax                                ; 17C0 _ 48: 89. C7
        call    get_32                                  ; 17C3 _ E8, FFFFEF96
        mov     edx, eax                                ; 17C8 _ 89. C2
        lea     rax, [rel ?_205]                        ; 17CA _ 48: 8D. 05, 00000000(rel)
        mov     esi, edx                                ; 17D1 _ 89. D6
        mov     rdi, rax                                ; 17D3 _ 48: 89. C7
        mov     eax, 0                                  ; 17D6 _ B8, 00000000
        call    printf                                  ; 17DB _ E8, 00000000(PLT r)
        jmp     ?_108                                   ; 17E0 _ EB, 25

?_107:  lea     rax, [rbp-18H]                          ; 17E2 _ 48: 8D. 45, E8
        mov     rdi, rax                                ; 17E6 _ 48: 89. C7
        call    get_16                                  ; 17E9 _ E8, FFFFEF42
        movzx   eax, ax                                 ; 17EE _ 0F B7. C0
        lea     rdx, [rel ?_206]                        ; 17F1 _ 48: 8D. 15, 00000000(rel)
        mov     esi, eax                                ; 17F8 _ 89. C6
        mov     rdi, rdx                                ; 17FA _ 48: 89. D7
        mov     eax, 0                                  ; 17FD _ B8, 00000000
        call    printf                                  ; 1802 _ E8, 00000000(PLT r)
?_108:  lea     rax, [rbp-18H]                          ; 1807 _ 48: 8D. 45, E8
        mov     rdi, rax                                ; 180B _ 48: 89. C7
        call    get_index                               ; 180E _ E8, FFFFEEC6
        mov     word [rbp-1EH], ax                      ; 1813 _ 66: 89. 45, E2
        cmp     word [rbp-1EH], 0                       ; 1817 _ 66: 83. 7D, E2, 00
        jz      ?_109                                   ; 181C _ 74, 1A
        movzx   eax, word [rbp-1EH]                     ; 181E _ 0F B7. 45, E2
        lea     rdx, [rel ?_207]                        ; 1822 _ 48: 8D. 15, 00000000(rel)
        mov     esi, eax                                ; 1829 _ 89. C6
        mov     rdi, rdx                                ; 182B _ 48: 89. D7
        mov     eax, 0                                  ; 182E _ B8, 00000000
        call    printf                                  ; 1833 _ E8, 00000000(PLT r)
?_109:  lea     rax, [rel ?_161]                        ; 1838 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 183F _ 48: 89. C7
        call    puts                                    ; 1842 _ E8, 00000000(PLT r)
?_110:  mov     rax, qword [rbp-18H]                    ; 1847 _ 48: 8B. 45, E8
        cmp     rax, qword [rbp-10H]                    ; 184B _ 48: 3B. 45, F0
        jc      ?_106                                   ; 184F _ 0F 82, FFFFFF0D
        jmp     ?_113                                   ; 1855 _ EB, 04

?_111:  nop                                             ; 1857 _ 90
        jmp     ?_113                                   ; 1858 _ EB, 01

?_112:  nop                                             ; 185A _ 90
?_113:  mov     rcx, qword [rbp-48H]                    ; 185B _ 48: 8B. 4D, B8
        mov     rdx, qword [rbp-48H]                    ; 185F _ 48: 8B. 55, B8
        mov     rax, qword [rbp-40H]                    ; 1863 _ 48: 8B. 45, C0
        mov     rsi, rax                                ; 1867 _ 48: 89. C6
        mov     edi, 0                                  ; 186A _ BF, 00000000
        call    hexdump_data                            ; 186F _ E8, FFFFE9C5
        nop                                             ; 1874 _ 90
        mov     rax, qword [rbp-8H]                     ; 1875 _ 48: 8B. 45, F8
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        sub     rax, qword [fs:abs 28H]                 ; 1879 _ 64 48: 2B. 04 25, 00000028
        jz      ?_114                                   ; 1882 _ 74, 05
        call    __stack_chk_fail                        ; 1884 _ E8, 00000000(PLT r)
?_114:  leave                                           ; 1889 _ C9
        ret                                             ; 188A _ C3

dump_extdef:; Local function
        push    rbp                                     ; 188B _ 55
        mov     rbp, rsp                                ; 188C _ 48: 89. E5
        sub     rsp, 80                                 ; 188F _ 48: 83. EC, 50
        mov     byte [rbp-31H], dil                     ; 1893 _ 40: 88. 7D, CF
        mov     qword [rbp-40H], rsi                    ; 1897 _ 48: 89. 75, C0
        mov     qword [rbp-48H], rdx                    ; 189B _ 48: 89. 55, B8
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        mov     rax, qword [fs:abs 28H]                 ; 189F _ 64 48: 8B. 04 25, 00000028
        mov     qword [rbp-8H], rax                     ; 18A8 _ 48: 89. 45, F8
        xor     eax, eax                                ; 18AC _ 31. C0
        mov     rax, qword [rbp-40H]                    ; 18AE _ 48: 8B. 45, C0
        mov     qword [rbp-20H], rax                    ; 18B2 _ 48: 89. 45, E0
        mov     rdx, qword [rbp-40H]                    ; 18B6 _ 48: 8B. 55, C0
        mov     rax, qword [rbp-48H]                    ; 18BA _ 48: 8B. 45, B8
        add     rax, rdx                                ; 18BE _ 48: 01. D0
        mov     qword [rbp-18H], rax                    ; 18C1 _ 48: 89. 45, E8
        jmp     ?_117                                   ; 18C5 _ E9, 000000C2

?_115:  mov     eax, dword [rel ext_names_count.0]      ; 18CA _ 8B. 05, 00000000(rel)
        add     eax, 1                                  ; 18D0 _ 83. C0, 01
        mov     dword [rel ext_names_count.0], eax      ; 18D3 _ 89. 05, 00000000(rel)
        mov     rax, qword [rbp-20H]                    ; 18D9 _ 48: 8B. 45, E0
        lea     rdx, [rax+1H]                           ; 18DD _ 48: 8D. 50, 01
        mov     qword [rbp-20H], rdx                    ; 18E1 _ 48: 89. 55, E0
        movzx   eax, byte [rax]                         ; 18E5 _ 0F B6. 00
        movzx   eax, al                                 ; 18E8 _ 0F B6. C0
        mov     dword [rbp-24H], eax                    ; 18EB _ 89. 45, DC
        mov     rdx, qword [rbp-20H]                    ; 18EE _ 48: 8B. 55, E0
        mov     eax, dword [rbp-24H]                    ; 18F2 _ 8B. 45, DC
        cdqe                                            ; 18F5 _ 48: 98
        mov     rsi, rdx                                ; 18F7 _ 48: 89. D6
        mov     rdi, rax                                ; 18FA _ 48: 89. C7
        call    copy_name                               ; 18FD _ E8, FFFFE8E8
        mov     qword [rbp-10H], rax                    ; 1902 _ 48: 89. 45, F0
        mov     rax, qword [rbp-10H]                    ; 1906 _ 48: 8B. 45, F0
        lea     rdx, [rel c_extsym]                     ; 190A _ 48: 8D. 15, 00000000(rel)
        mov     rsi, rax                                ; 1911 _ 48: 89. C6
        mov     rdi, rdx                                ; 1914 _ 48: 89. D7
        call    add_collection                          ; 1917 _ E8, FFFFE820
        mov     rdx, qword [rbp-20H]                    ; 191C _ 48: 8B. 55, E0
        mov     eax, dword [rbp-24H]                    ; 1920 _ 8B. 45, DC
        cdqe                                            ; 1923 _ 48: 98
        add     rax, rdx                                ; 1925 _ 48: 01. D0
        mov     qword [rbp-20H], rax                    ; 1928 _ 48: 89. 45, E0
        mov     eax, dword [rel ext_names_count.0]      ; 192C _ 8B. 05, 00000000(rel)
        mov     rdx, qword [rbp-10H]                    ; 1932 _ 48: 8B. 55, F0
        lea     rcx, [rel ?_208]                        ; 1936 _ 48: 8D. 0D, 00000000(rel)
        mov     esi, eax                                ; 193D _ 89. C6
        mov     rdi, rcx                                ; 193F _ 48: 89. CF
        mov     eax, 0                                  ; 1942 _ B8, 00000000
        call    printf                                  ; 1947 _ E8, 00000000(PLT r)
        lea     rax, [rbp-20H]                          ; 194C _ 48: 8D. 45, E0
        mov     rdi, rax                                ; 1950 _ 48: 89. C7
        call    get_index                               ; 1953 _ E8, FFFFED81
        mov     word [rbp-26H], ax                      ; 1958 _ 66: 89. 45, DA
        cmp     word [rbp-26H], 0                       ; 195C _ 66: 83. 7D, DA, 00
        jz      ?_116                                   ; 1961 _ 74, 1A
        movzx   eax, word [rbp-26H]                     ; 1963 _ 0F B7. 45, DA
        lea     rdx, [rel ?_207]                        ; 1967 _ 48: 8D. 15, 00000000(rel)
        mov     esi, eax                                ; 196E _ 89. C6
        mov     rdi, rdx                                ; 1970 _ 48: 89. D7
        mov     eax, 0                                  ; 1973 _ B8, 00000000
        call    printf                                  ; 1978 _ E8, 00000000(PLT r)
?_116:  lea     rax, [rel ?_161]                        ; 197D _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 1984 _ 48: 89. C7
        call    puts                                    ; 1987 _ E8, 00000000(PLT r)
?_117:  mov     rax, qword [rbp-20H]                    ; 198C _ 48: 8B. 45, E0
        cmp     rax, qword [rbp-18H]                    ; 1990 _ 48: 3B. 45, E8
        jc      ?_115                                   ; 1994 _ 0F 82, FFFFFF30
        mov     rcx, qword [rbp-48H]                    ; 199A _ 48: 8B. 4D, B8
        mov     rdx, qword [rbp-48H]                    ; 199E _ 48: 8B. 55, B8
        mov     rax, qword [rbp-40H]                    ; 19A2 _ 48: 8B. 45, C0
        mov     rsi, rax                                ; 19A6 _ 48: 89. C6
        mov     edi, 0                                  ; 19A9 _ BF, 00000000
        call    hexdump_data                            ; 19AE _ E8, FFFFE886
        nop                                             ; 19B3 _ 90
        mov     rax, qword [rbp-8H]                     ; 19B4 _ 48: 8B. 45, F8
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        sub     rax, qword [fs:abs 28H]                 ; 19B8 _ 64 48: 2B. 04 25, 00000028
        jz      ?_118                                   ; 19C1 _ 74, 05
        call    __stack_chk_fail                        ; 19C3 _ E8, 00000000(PLT r)
?_118:  leave                                           ; 19C8 _ C9
        ret                                             ; 19C9 _ C3

dump_modend:; Local function
        push    rbp                                     ; 19CA _ 55
        mov     rbp, rsp                                ; 19CB _ 48: 89. E5
        sub     rsp, 48                                 ; 19CE _ 48: 83. EC, 30
        mov     byte [rbp-11H], dil                     ; 19D2 _ 40: 88. 7D, EF
        mov     qword [rbp-20H], rsi                    ; 19D6 _ 48: 89. 75, E0
        mov     qword [rbp-28H], rdx                    ; 19DA _ 48: 89. 55, D8
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        mov     rax, qword [fs:abs 28H]                 ; 19DE _ 64 48: 8B. 04 25, 00000028
        mov     qword [rbp-8H], rax                     ; 19E7 _ 48: 89. 45, F8
        xor     eax, eax                                ; 19EB _ 31. C0
        mov     rax, qword [rbp-20H]                    ; 19ED _ 48: 8B. 45, E0
        mov     qword [rbp-10H], rax                    ; 19F1 _ 48: 89. 45, F0
        mov     rax, qword [rbp-10H]                    ; 19F5 _ 48: 8B. 45, F0
        movzx   eax, byte [rax]                         ; 19F9 _ 0F B6. 00
        test    al, al                                  ; 19FC _ 84. C0
        jns     ?_119                                   ; 19FE _ 79, 0F
        lea     rax, [rel ?_209]                        ; 1A00 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 1A07 _ 48: 89. C7
        call    puts                                    ; 1A0A _ E8, 00000000(PLT r)
?_119:  mov     rax, qword [rbp-10H]                    ; 1A0F _ 48: 8B. 45, F0
        movzx   eax, byte [rax]                         ; 1A13 _ 0F B6. 00
        movzx   eax, al                                 ; 1A16 _ 0F B6. C0
        and     eax, 40H                                ; 1A19 _ 83. E0, 40
        test    eax, eax                                ; 1A1C _ 85. C0
        jz      ?_120                                   ; 1A1E _ 74, 38
        lea     rax, [rel ?_210]                        ; 1A20 _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 1A27 _ 48: 89. C7
        mov     eax, 0                                  ; 1A2A _ B8, 00000000
        call    printf                                  ; 1A2F _ E8, 00000000(PLT r)
        mov     rax, qword [rbp-10H]                    ; 1A34 _ 48: 8B. 45, F0
        add     rax, 1                                  ; 1A38 _ 48: 83. C0, 01
        mov     qword [rbp-10H], rax                    ; 1A3C _ 48: 89. 45, F0
        movzx   eax, byte [rbp-11H]                     ; 1A40 _ 0F B6. 45, EF
        and     eax, 01H                                ; 1A44 _ 83. E0, 01
        lea     rdx, [rbp-10H]                          ; 1A47 _ 48: 8D. 55, F0
        movzx   eax, al                                 ; 1A4B _ 0F B6. C0
        mov     rsi, rdx                                ; 1A4E _ 48: 89. D6
        mov     edi, eax                                ; 1A51 _ 89. C7
        call    dump_fixdat                             ; 1A53 _ E8, FFFFF4B6
?_120:  mov     rcx, qword [rbp-28H]                    ; 1A58 _ 48: 8B. 4D, D8
        mov     rdx, qword [rbp-28H]                    ; 1A5C _ 48: 8B. 55, D8
        mov     rax, qword [rbp-20H]                    ; 1A60 _ 48: 8B. 45, E0
        mov     rsi, rax                                ; 1A64 _ 48: 89. C6
        mov     edi, 0                                  ; 1A67 _ BF, 00000000
        call    hexdump_data                            ; 1A6C _ E8, FFFFE7C8
        nop                                             ; 1A71 _ 90
        mov     rax, qword [rbp-8H]                     ; 1A72 _ 48: 8B. 45, F8
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        sub     rax, qword [fs:abs 28H]                 ; 1A76 _ 64 48: 2B. 04 25, 00000028
        jz      ?_121                                   ; 1A7F _ 74, 05
        call    __stack_chk_fail                        ; 1A81 _ E8, 00000000(PLT r)
?_121:  leave                                           ; 1A86 _ C9
        ret                                             ; 1A87 _ C3

read_file:; Local function
        push    rbp                                     ; 1A88 _ 55
        mov     rbp, rsp                                ; 1A89 _ 48: 89. E5
        sub     rsp, 64                                 ; 1A8C _ 48: 83. EC, 40
        mov     qword [rbp-38H], rdi                    ; 1A90 _ 48: 89. 7D, C8
        mov     qword [rbp-40H], rsi                    ; 1A94 _ 48: 89. 75, C0
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        mov     rax, qword [fs:abs 28H]                 ; 1A98 _ 64 48: 8B. 04 25, 00000028
        mov     qword [rbp-8H], rax                     ; 1AA1 _ 48: 89. 45, F8
        xor     eax, eax                                ; 1AA5 _ 31. C0
        mov     qword [rbp-20H], 0                      ; 1AA7 _ 48: C7. 45, E0, 00000000
        mov     qword [rbp-28H], 0                      ; 1AAF _ 48: C7. 45, D8, 00000000
        mov     qword [rbp-18H], 0                      ; 1AB7 _ 48: C7. 45, E8, 00000000
        mov     rax, qword [rbp-38H]                    ; 1ABF _ 48: 8B. 45, C8
        mov     edx, 2                                  ; 1AC3 _ BA, 00000002
        mov     esi, 0                                  ; 1AC8 _ BE, 00000000
        mov     rdi, rax                                ; 1ACD _ 48: 89. C7
        call    fseek                                   ; 1AD0 _ E8, 00000000(PLT r)
        test    eax, eax                                ; 1AD5 _ 85. C0
        jz      ?_122                                   ; 1AD7 _ 74, 29
        mov     rax, qword [rbp-38H]                    ; 1AD9 _ 48: 8B. 45, C8
        mov     rdi, rax                                ; 1ADD _ 48: 89. C7
        call    ftell                                   ; 1AE0 _ E8, 00000000(PLT r)
        mov     qword [rbp-28H], rax                    ; 1AE5 _ 48: 89. 45, D8
        mov     rax, qword [rbp-28H]                    ; 1AE9 _ 48: 8B. 45, D8
        test    rax, rax                                ; 1AED _ 48: 85. C0
        jz      ?_122                                   ; 1AF0 _ 74, 10
        mov     rax, qword [rbp-28H]                    ; 1AF2 _ 48: 8B. 45, D8
        mov     rdi, rax                                ; 1AF6 _ 48: 89. C7
        call    xmalloc                                 ; 1AF9 _ E8, FFFFE555
        mov     qword [rbp-20H], rax                    ; 1AFE _ 48: 89. 45, E0
?_122:  mov     rax, qword [rbp-38H]                    ; 1B02 _ 48: 8B. 45, C8
        mov     rdi, rax                                ; 1B06 _ 48: 89. C7
        call    rewind                                  ; 1B09 _ E8, 00000000(PLT r)
?_123:  mov     rdx, qword [rbp-18H]                    ; 1B0E _ 48: 8B. 55, E8
        lea     rsi, [rbp-28H]                          ; 1B12 _ 48: 8D. 75, D8
        mov     rax, qword [rbp-20H]                    ; 1B16 _ 48: 8B. 45, E0
        mov     ecx, 1                                  ; 1B1A _ B9, 00000001
        mov     rdi, rax                                ; 1B1F _ 48: 89. C7
        call    expand_buffer                           ; 1B22 _ E8, FFFFE57B
        mov     qword [rbp-20H], rax                    ; 1B27 _ 48: 89. 45, E0
        mov     rax, qword [rbp-28H]                    ; 1B2B _ 48: 8B. 45, D8
        sub     rax, qword [rbp-18H]                    ; 1B2F _ 48: 2B. 45, E8
        mov     rcx, qword [rbp-20H]                    ; 1B33 _ 48: 8B. 4D, E0
        mov     rdx, qword [rbp-18H]                    ; 1B37 _ 48: 8B. 55, E8
        lea     rdi, [rcx+rdx]                          ; 1B3B _ 48: 8D. 3C 11
        mov     rdx, qword [rbp-38H]                    ; 1B3F _ 48: 8B. 55, C8
        mov     rcx, rdx                                ; 1B43 _ 48: 89. D1
        mov     rdx, rax                                ; 1B46 _ 48: 89. C2
        mov     esi, 1                                  ; 1B49 _ BE, 00000001
        call    fread                                   ; 1B4E _ E8, 00000000(PLT r)
        mov     qword [rbp-10H], rax                    ; 1B53 _ 48: 89. 45, F0
        mov     rax, qword [rbp-38H]                    ; 1B57 _ 48: 8B. 45, C8
        mov     rdi, rax                                ; 1B5B _ 48: 89. C7
        call    ferror                                  ; 1B5E _ E8, 00000000(PLT r)
        test    eax, eax                                ; 1B63 _ 85. C0
        jz      ?_124                                   ; 1B65 _ 74, 1E
        mov     rax, qword [rbp-20H]                    ; 1B67 _ 48: 8B. 45, E0
        mov     rdi, rax                                ; 1B6B _ 48: 89. C7
        call    free                                    ; 1B6E _ E8, 00000000(PLT r)
        mov     rax, qword [rbp-40H]                    ; 1B73 _ 48: 8B. 45, C0
        mov     qword [rax], 0                          ; 1B77 _ 48: C7. 00, 00000000
        mov     eax, 0                                  ; 1B7E _ B8, 00000000
        jmp     ?_127                                   ; 1B83 _ EB, 53

?_124:  mov     rax, qword [rbp-10H]                    ; 1B85 _ 48: 8B. 45, F0
        add     qword [rbp-18H], rax                    ; 1B89 _ 48: 01. 45, E8
        cmp     qword [rbp-10H], 0                      ; 1B8D _ 48: 83. 7D, F0, 00
        jz      ?_125                                   ; 1B92 _ 74, 14
        mov     rax, qword [rbp-38H]                    ; 1B94 _ 48: 8B. 45, C8
        mov     rdi, rax                                ; 1B98 _ 48: 89. C7
        call    feof                                    ; 1B9B _ E8, 00000000(PLT r)
        test    eax, eax                                ; 1BA0 _ 85. C0
        je      ?_123                                   ; 1BA2 _ 0F 84, FFFFFF66
?_125:  mov     rax, qword [rbp-40H]                    ; 1BA8 _ 48: 8B. 45, C0
        mov     rdx, qword [rbp-18H]                    ; 1BAC _ 48: 8B. 55, E8
        mov     qword [rax], rdx                        ; 1BB0 _ 48: 89. 10
        mov     rax, qword [rbp-28H]                    ; 1BB3 _ 48: 8B. 45, D8
        cmp     qword [rbp-18H], rax                    ; 1BB7 _ 48: 39. 45, E8
        jz      ?_126                                   ; 1BBB _ 74, 17
        mov     rdx, qword [rbp-18H]                    ; 1BBD _ 48: 8B. 55, E8
        mov     rax, qword [rbp-20H]                    ; 1BC1 _ 48: 8B. 45, E0
        mov     rsi, rdx                                ; 1BC5 _ 48: 89. D6
        mov     rdi, rax                                ; 1BC8 _ 48: 89. C7
        call    xrealloc                                ; 1BCB _ E8, FFFFE4A5
        mov     qword [rbp-20H], rax                    ; 1BD0 _ 48: 89. 45, E0
?_126:  mov     rax, qword [rbp-20H]                    ; 1BD4 _ 48: 8B. 45, E0
?_127:  mov     rdx, qword [rbp-8H]                     ; 1BD8 _ 48: 8B. 55, F8
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        sub     rdx, qword [fs:abs 28H]                 ; 1BDC _ 64 48: 2B. 14 25, 00000028
        jz      ?_128                                   ; 1BE5 _ 74, 05
        call    __stack_chk_fail                        ; 1BE7 _ E8, 00000000(PLT r)
?_128:  leave                                           ; 1BEC _ C9
        ret                                             ; 1BED _ C3

dump_omf:; Local function
        push    rbp                                     ; 1BEE _ 55
        mov     rbp, rsp                                ; 1BEF _ 48: 89. E5
        sub     rsp, 64                                 ; 1BF2 _ 48: 83. EC, 40
        mov     qword [rbp-38H], rdi                    ; 1BF6 _ 48: 89. 7D, C8
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        mov     rax, qword [fs:abs 28H]                 ; 1BFA _ 64 48: 8B. 04 25, 00000028
        mov     qword [rbp-8H], rax                     ; 1C03 _ 48: 89. 45, F8
        xor     eax, eax                                ; 1C07 _ 31. C0
        lea     rdx, [rbp-28H]                          ; 1C09 _ 48: 8D. 55, D8
        mov     rax, qword [rbp-38H]                    ; 1C0D _ 48: 8B. 45, C8
        mov     rsi, rdx                                ; 1C11 _ 48: 89. D6
        mov     rdi, rax                                ; 1C14 _ 48: 89. C7
        call    read_file                               ; 1C17 _ E8, FFFFFE6C
        mov     qword [rbp-18H], rax                    ; 1C1C _ 48: 89. 45, E8
        cmp     qword [rbp-18H], 0                      ; 1C20 _ 48: 83. 7D, E8, 00
        jnz     ?_129                                   ; 1C25 _ 75, 0A
        mov     eax, 4294967295                         ; 1C27 _ B8, FFFFFFFF
        jmp     ?_142                                   ; 1C2C _ E9, 00000211

?_129:  mov     rax, qword [rbp-18H]                    ; 1C31 _ 48: 8B. 45, E8
        mov     qword [rbp-20H], rax                    ; 1C35 _ 48: 89. 45, E0
        jmp     ?_140                                   ; 1C39 _ E9, 000001DA

?_130:  mov     rax, qword [rbp-20H]                    ; 1C3E _ 48: 8B. 45, E0
        movzx   eax, byte [rax]                         ; 1C42 _ 0F B6. 00
        mov     byte [rbp-2DH], al                      ; 1C45 _ 88. 45, D3
        mov     rax, qword [rbp-20H]                    ; 1C48 _ 48: 8B. 45, E0
        add     rax, 1                                  ; 1C4C _ 48: 83. C0, 01
        movzx   eax, word [rax]                         ; 1C50 _ 0F B7. 00
        movzx   eax, ax                                 ; 1C53 _ 0F B7. C0
        mov     qword [rbp-10H], rax                    ; 1C56 _ 48: 89. 45, F0
        movzx   eax, byte [rbp-2DH]                     ; 1C5A _ 0F B6. 45, D3
        cdqe                                            ; 1C5E _ 48: 98
        lea     rdx, [rax*8]                            ; 1C60 _ 48: 8D. 14 C5, 00000000
        lea     rax, [rel record_types]                 ; 1C68 _ 48: 8D. 05, 00000000(rel)
        mov     rax, qword [rdx+rax]                    ; 1C6F _ 48: 8B. 04 02
        test    rax, rax                                ; 1C73 _ 48: 85. C0
        setne   al                                      ; 1C76 _ 0F 95. C0
        movzx   eax, al                                 ; 1C79 _ 0F B6. C0
        and     eax, 01H                                ; 1C7C _ 83. E0, 01
        test    al, al                                  ; 1C7F _ 84. C0
        jz      ?_131                                   ; 1C81 _ 74, 1B
        movzx   eax, byte [rbp-2DH]                     ; 1C83 _ 0F B6. 45, D3
        cdqe                                            ; 1C87 _ 48: 98
        lea     rdx, [rax*8]                            ; 1C89 _ 48: 8D. 14 C5, 00000000
        lea     rax, [rel record_types]                 ; 1C91 _ 48: 8D. 05, 00000000(rel)
        mov     rax, qword [rdx+rax]                    ; 1C98 _ 48: 8B. 04 02
        jmp     ?_132                                   ; 1C9C _ EB, 07

?_131:  lea     rax, [rel ?_159]                        ; 1C9E _ 48: 8D. 05, 00000000(rel)
?_132:  movzx   esi, byte [rbp-2DH]                     ; 1CA5 _ 0F B6. 75, D3
        mov     rdx, qword [rbp-10H]                    ; 1CA9 _ 48: 8B. 55, F0
        lea     rdi, [rel ?_211]                        ; 1CAD _ 48: 8D. 3D, 00000000(rel)
        mov     rcx, rdx                                ; 1CB4 _ 48: 89. D1
        mov     rdx, rax                                ; 1CB7 _ 48: 89. C2
        mov     eax, 0                                  ; 1CBA _ B8, 00000000
        call    printf                                  ; 1CBF _ E8, 00000000(PLT r)
        mov     rax, qword [rbp-10H]                    ; 1CC4 _ 48: 8B. 45, F0
        add     rax, 3                                  ; 1CC8 _ 48: 83. C0, 03
        mov     rdx, qword [rbp-28H]                    ; 1CCC _ 48: 8B. 55, D8
        cmp     rdx, rax                                ; 1CD0 _ 48: 39. C2
        jnc     ?_133                                   ; 1CD3 _ 73, 24
        mov     rax, qword [rbp-28H]                    ; 1CD5 _ 48: 8B. 45, D8
        lea     rdx, [rax-3H]                           ; 1CD9 _ 48: 8D. 50, FD
        lea     rax, [rel ?_212]                        ; 1CDD _ 48: 8D. 05, 00000000(rel)
        mov     rsi, rdx                                ; 1CE4 _ 48: 89. D6
        mov     rdi, rax                                ; 1CE7 _ 48: 89. C7
        mov     eax, 0                                  ; 1CEA _ B8, 00000000
        call    printf                                  ; 1CEF _ E8, 00000000(PLT r)
        jmp     ?_141                                   ; 1CF4 _ E9, 00000138

?_133:  add     qword [rbp-20H], 3                      ; 1CF9 _ 48: 83. 45, E0, 03
        sub     qword [rbp-10H], 1                      ; 1CFE _ 48: 83. 6D, F0, 01
        mov     byte [rbp-2EH], 0                       ; 1D03 _ C6. 45, D2, 00
        mov     dword [rbp-2CH], -3                     ; 1D07 _ C7. 45, D4, FFFFFFFD
        jmp     ?_135                                   ; 1D0E _ EB, 17

?_134:  mov     eax, dword [rbp-2CH]                    ; 1D10 _ 8B. 45, D4
        movsxd  rdx, eax                                ; 1D13 _ 48: 63. D0
        mov     rax, qword [rbp-20H]                    ; 1D16 _ 48: 8B. 45, E0
        add     rax, rdx                                ; 1D1A _ 48: 01. D0
        movzx   eax, byte [rax]                         ; 1D1D _ 0F B6. 00
        sub     byte [rbp-2EH], al                      ; 1D20 _ 28. 45, D2
        add     dword [rbp-2CH], 1                      ; 1D23 _ 83. 45, D4, 01
?_135:  mov     rax, qword [rbp-10H]                    ; 1D27 _ 48: 8B. 45, F0
        cmp     dword [rbp-2CH], eax                    ; 1D2B _ 39. 45, D4
        jl      ?_134                                   ; 1D2E _ 7C, E0
        mov     eax, dword [rbp-2CH]                    ; 1D30 _ 8B. 45, D4
        movsxd  rdx, eax                                ; 1D33 _ 48: 63. D0
        mov     rax, qword [rbp-20H]                    ; 1D36 _ 48: 8B. 45, E0
        add     rax, rdx                                ; 1D3A _ 48: 01. D0
        movzx   eax, byte [rax]                         ; 1D3D _ 0F B6. 00
        movzx   eax, al                                 ; 1D40 _ 0F B6. C0
        lea     rdx, [rel ?_213]                        ; 1D43 _ 48: 8D. 15, 00000000(rel)
        mov     esi, eax                                ; 1D4A _ 89. C6
        mov     rdi, rdx                                ; 1D4C _ 48: 89. D7
        mov     eax, 0                                  ; 1D4F _ B8, 00000000
        call    printf                                  ; 1D54 _ E8, 00000000(PLT r)
        mov     eax, dword [rbp-2CH]                    ; 1D59 _ 8B. 45, D4
        movsxd  rdx, eax                                ; 1D5C _ 48: 63. D0
        mov     rax, qword [rbp-20H]                    ; 1D5F _ 48: 8B. 45, E0
        add     rax, rdx                                ; 1D63 _ 48: 01. D0
        movzx   eax, byte [rax]                         ; 1D66 _ 0F B6. 00
        cmp     byte [rbp-2EH], al                      ; 1D69 _ 38. 45, D2
        jnz     ?_136                                   ; 1D6C _ 75, 11
        lea     rax, [rel ?_214]                        ; 1D6E _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 1D75 _ 48: 89. C7
        call    puts                                    ; 1D78 _ E8, 00000000(PLT r)
        jmp     ?_137                                   ; 1D7D _ EB, 1A

?_136:  movzx   eax, byte [rbp-2EH]                     ; 1D7F _ 0F B6. 45, D2
        lea     rdx, [rel ?_215]                        ; 1D83 _ 48: 8D. 15, 00000000(rel)
        mov     esi, eax                                ; 1D8A _ 89. C6
        mov     rdi, rdx                                ; 1D8C _ 48: 89. D7
        mov     eax, 0                                  ; 1D8F _ B8, 00000000
        call    printf                                  ; 1D94 _ E8, 00000000(PLT r)
?_137:  movzx   eax, byte [rbp-2DH]                     ; 1D99 _ 0F B6. 45, D3
        cdqe                                            ; 1D9D _ 48: 98
        lea     rdx, [rax*8]                            ; 1D9F _ 48: 8D. 14 C5, 00000000
        lea     rax, [rel dump_type]                    ; 1DA7 _ 48: 8D. 05, 00000000(rel)
        mov     rax, qword [rdx+rax]                    ; 1DAE _ 48: 8B. 04 02
        test    rax, rax                                ; 1DB2 _ 48: 85. C0
        jz      ?_138                                   ; 1DB5 _ 74, 2F
        movzx   eax, byte [rbp-2DH]                     ; 1DB7 _ 0F B6. 45, D3
        cdqe                                            ; 1DBB _ 48: 98
        lea     rdx, [rax*8]                            ; 1DBD _ 48: 8D. 14 C5, 00000000
        lea     rax, [rel dump_type]                    ; 1DC5 _ 48: 8D. 05, 00000000(rel)
        mov     r8, qword [rdx+rax]                     ; 1DCC _ 4C: 8B. 04 02
        mov     rdx, qword [rbp-10H]                    ; 1DD0 _ 48: 8B. 55, F0
        mov     rcx, qword [rbp-20H]                    ; 1DD4 _ 48: 8B. 4D, E0
        movzx   eax, byte [rbp-2DH]                     ; 1DD8 _ 0F B6. 45, D3
        mov     rsi, rcx                                ; 1DDC _ 48: 89. CE
        mov     edi, eax                                ; 1DDF _ 89. C7
        call    r8                                      ; 1DE1 _ 41: FF. D0
        jmp     ?_139                                   ; 1DE4 _ EB, 16

?_138:  mov     rdx, qword [rbp-10H]                    ; 1DE6 _ 48: 8B. 55, F0
        mov     rcx, qword [rbp-20H]                    ; 1DEA _ 48: 8B. 4D, E0
        movzx   eax, byte [rbp-2DH]                     ; 1DEE _ 0F B6. 45, D3
        mov     rsi, rcx                                ; 1DF2 _ 48: 89. CE
        mov     edi, eax                                ; 1DF5 _ 89. C7
        call    dump_unknown                            ; 1DF7 _ E8, FFFFE5F8
?_139:  mov     rax, qword [rbp-10H]                    ; 1DFC _ 48: 8B. 45, F0
        add     rax, 1                                  ; 1E00 _ 48: 83. C0, 01
        add     qword [rbp-20H], rax                    ; 1E04 _ 48: 01. 45, E0
        mov     rax, qword [rbp-28H]                    ; 1E08 _ 48: 8B. 45, D8
        sub     rax, qword [rbp-10H]                    ; 1E0C _ 48: 2B. 45, F0
        sub     rax, 4                                  ; 1E10 _ 48: 83. E8, 04
        mov     qword [rbp-28H], rax                    ; 1E14 _ 48: 89. 45, D8
?_140:  mov     rax, qword [rbp-28H]                    ; 1E18 _ 48: 8B. 45, D8
        cmp     rax, 2                                  ; 1E1C _ 48: 83. F8, 02
        jbe     ?_141                                   ; 1E20 _ 76, 0F
        mov     rax, qword [rbp-20H]                    ; 1E22 _ 48: 8B. 45, E0
        movzx   eax, byte [rax]                         ; 1E26 _ 0F B6. 00
        cmp     al, 26                                  ; 1E29 _ 3C, 1A
        jne     ?_130                                   ; 1E2B _ 0F 85, FFFFFE0D
?_141:  mov     rax, qword [rbp-18H]                    ; 1E31 _ 48: 8B. 45, E8
        mov     rdi, rax                                ; 1E35 _ 48: 89. C7
        call    free                                    ; 1E38 _ E8, 00000000(PLT r)
        mov     eax, 0                                  ; 1E3D _ B8, 00000000
?_142:  mov     rdx, qword [rbp-8H]                     ; 1E42 _ 48: 8B. 55, F8
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        sub     rdx, qword [fs:abs 28H]                 ; 1E46 _ 64 48: 2B. 14 25, 00000028
        jz      ?_143                                   ; 1E4F _ 74, 05
        call    __stack_chk_fail                        ; 1E51 _ E8, 00000000(PLT r)
?_143:  leave                                           ; 1E56 _ C9
        ret                                             ; 1E57 _ C3

main:   ; Function begin
        push    rbp                                     ; 1E58 _ 55
        mov     rbp, rsp                                ; 1E59 _ 48: 89. E5
        sub     rsp, 32                                 ; 1E5C _ 48: 83. EC, 20
        mov     dword [rbp-14H], edi                    ; 1E60 _ 89. 7D, EC
        mov     qword [rbp-20H], rsi                    ; 1E63 _ 48: 89. 75, E0
        mov     rax, qword [rbp-20H]                    ; 1E67 _ 48: 8B. 45, E0
        mov     rax, qword [rax]                        ; 1E6B _ 48: 8B. 00
        mov     qword [rel progname], rax               ; 1E6E _ 48: 89. 05, 00000000(rel)
        cmp     dword [rbp-14H], 1                      ; 1E75 _ 83. 7D, EC, 01
        jg      ?_144                                   ; 1E79 _ 7F, 2A
        mov     rax, qword [rel stdout]                 ; 1E7B _ 48: 8B. 05, 00000000(rel)
        lea     rdi, [rel ?_216]                        ; 1E82 _ 48: 8D. 3D, 00000000(rel)
        mov     rcx, rax                                ; 1E89 _ 48: 89. C1
        mov     edx, 80                                 ; 1E8C _ BA, 00000050
        mov     esi, 1                                  ; 1E91 _ BE, 00000001
        call    fwrite                                  ; 1E96 _ E8, 00000000(PLT r)
        mov     eax, 0                                  ; 1E9B _ B8, 00000000
        jmp     ?_149                                   ; 1EA0 _ E9, 00000094

?_144:  mov     dword [rbp-0CH], 1                      ; 1EA5 _ C7. 45, F4, 00000001
        jmp     ?_148                                   ; 1EAC _ EB, 7A

?_145:  mov     eax, dword [rbp-0CH]                    ; 1EAE _ 8B. 45, F4
        cdqe                                            ; 1EB1 _ 48: 98
        lea     rdx, [rax*8]                            ; 1EB3 _ 48: 8D. 14 C5, 00000000
        mov     rax, qword [rbp-20H]                    ; 1EBB _ 48: 8B. 45, E0
        add     rax, rdx                                ; 1EBF _ 48: 01. D0
        mov     rax, qword [rax]                        ; 1EC2 _ 48: 8B. 00
        lea     rdx, [rel ?_217]                        ; 1EC5 _ 48: 8D. 15, 00000000(rel)
        mov     rsi, rdx                                ; 1ECC _ 48: 89. D6
        mov     rdi, rax                                ; 1ECF _ 48: 89. C7
        call    fopen                                   ; 1ED2 _ E8, 00000000(PLT r)
        mov     qword [rbp-8H], rax                     ; 1ED7 _ 48: 89. 45, F8
        cmp     qword [rbp-8H], 0                       ; 1EDB _ 48: 83. 7D, F8, 00
        jz      ?_146                                   ; 1EE0 _ 74, 10
        mov     rax, qword [rbp-8H]                     ; 1EE2 _ 48: 8B. 45, F8
        mov     rdi, rax                                ; 1EE6 _ 48: 89. C7
        call    dump_omf                                ; 1EE9 _ E8, FFFFFD00
        test    eax, eax                                ; 1EEE _ 85. C0
        jz      ?_147                                   ; 1EF0 _ 74, 26
?_146:  mov     eax, dword [rbp-0CH]                    ; 1EF2 _ 8B. 45, F4
        cdqe                                            ; 1EF5 _ 48: 98
        lea     rdx, [rax*8]                            ; 1EF7 _ 48: 8D. 14 C5, 00000000
        mov     rax, qword [rbp-20H]                    ; 1EFF _ 48: 8B. 45, E0
        add     rax, rdx                                ; 1F03 _ 48: 01. D0
        mov     rax, qword [rax]                        ; 1F06 _ 48: 8B. 00
        mov     rdi, rax                                ; 1F09 _ 48: 89. C7
        call    perror                                  ; 1F0C _ E8, 00000000(PLT r)
        mov     eax, 1                                  ; 1F11 _ B8, 00000001
        jmp     ?_149                                   ; 1F16 _ EB, 21

?_147:  mov     rax, qword [rbp-8H]                     ; 1F18 _ 48: 8B. 45, F8
        mov     rdi, rax                                ; 1F1C _ 48: 89. C7
        call    fclose                                  ; 1F1F _ E8, 00000000(PLT r)
        add     dword [rbp-0CH], 1                      ; 1F24 _ 83. 45, F4, 01
?_148:  mov     eax, dword [rbp-0CH]                    ; 1F28 _ 8B. 45, F4
        cmp     eax, dword [rbp-14H]                    ; 1F2B _ 3B. 45, EC
        jl      ?_145                                   ; 1F2E _ 0F 8C, FFFFFF7A
        mov     eax, 0                                  ; 1F34 _ B8, 00000000
?_149:  leave                                           ; 1F39 _ C9
        ret                                             ; 1F3A _ C3
; main End of function


SECTION .data   align=1 noexec                          ; section number 2, data


SECTION .bss    align=16 noexec                         ; section number 3, bss

progname:                                               ; qword
        resq    2                                       ; 0000

c_names:                                                ; byte
        resq    4                                       ; 0010

c_lsegs:                                                ; byte
        resb    32                                      ; 0030

c_groups:                                               ; byte
        resb    32                                      ; 0050

c_extsym:                                               ; byte
        resb    24                                      ; 0070

pub_names_count.1:                                      ; dword
        resd    1                                       ; 0088

ext_names_count.0:                                      ; dword
        resd    1                                       ; 008C


SECTION .rodata align=8 noexec                          ; section number 4, const

        db 54H, 48H, 45H, 41H, 44H, 52H, 00H, 4CH       ; 0000 _ THEADR.L
        db 48H, 45H, 41H, 44H, 52H, 00H, 43H, 4FH       ; 0008 _ HEADR.CO
        db 4DH, 45H, 4EH, 54H, 00H, 4DH, 4FH, 44H       ; 0010 _ MENT.MOD
        db 45H, 4EH, 44H, 31H, 36H, 00H, 4DH, 4FH       ; 0018 _ END16.MO
        db 44H, 45H, 4EH, 44H, 33H, 32H, 00H, 45H       ; 0020 _ DEND32.E
        db 58H, 54H, 44H, 45H, 46H, 00H, 54H, 59H       ; 0028 _ XTDEF.TY
        db 50H, 44H, 45H, 46H, 00H, 50H, 55H, 42H       ; 0030 _ PDEF.PUB
        db 44H, 45H, 46H, 31H, 36H, 00H, 50H, 55H       ; 0038 _ DEF16.PU
        db 42H, 44H, 45H, 46H, 33H, 32H, 00H, 4CH       ; 0040 _ BDEF32.L
        db 49H, 4EH, 4EH, 55H, 4DH, 31H, 36H, 00H       ; 0048 _ INNUM16.
        db 4CH, 49H, 4EH, 4EH, 55H, 4DH, 33H, 32H       ; 0050 _ LINNUM32
        db 00H, 4CH, 4EH, 41H, 4DH, 45H, 53H, 00H       ; 0058 _ .LNAMES.
        db 53H, 45H, 47H, 44H, 45H, 46H, 31H, 36H       ; 0060 _ SEGDEF16
        db 00H, 53H, 45H, 47H, 44H, 45H, 46H, 33H       ; 0068 _ .SEGDEF3
        db 32H, 00H, 47H, 52H, 50H, 44H, 45H, 46H       ; 0070 _ 2.GRPDEF
        db 00H, 46H, 49H, 58H, 55H, 50H, 50H, 31H       ; 0078 _ .FIXUPP1
        db 36H, 00H, 46H, 49H, 58H, 55H, 50H, 50H       ; 0080 _ 6.FIXUPP
        db 33H, 32H, 00H, 4CH, 45H, 44H, 41H, 54H       ; 0088 _ 32.LEDAT
        db 41H, 31H, 36H, 00H, 4CH, 45H, 44H, 41H       ; 0090 _ A16.LEDA
        db 54H, 41H, 33H, 32H, 00H, 4CH, 49H, 44H       ; 0098 _ TA32.LID
        db 41H, 54H, 41H, 31H, 36H, 00H, 4CH, 49H       ; 00A0 _ ATA16.LI
        db 44H, 41H, 54H, 41H, 33H, 32H, 00H, 43H       ; 00A8 _ DATA32.C
        db 4FH, 4DH, 44H, 45H, 46H, 00H, 42H, 41H       ; 00B0 _ OMDEF.BA
        db 4BH, 50H, 41H, 54H, 31H, 36H, 00H, 42H       ; 00B8 _ KPAT16.B
        db 41H, 4BH, 50H, 41H, 54H, 33H, 32H, 00H       ; 00C0 _ AKPAT32.
        db 4CH, 45H, 58H, 54H, 44H, 45H, 46H, 00H       ; 00C8 _ LEXTDEF.
        db 4CH, 50H, 55H, 42H, 44H, 45H, 46H, 31H       ; 00D0 _ LPUBDEF1
        db 36H, 00H, 4CH, 50H, 55H, 42H, 44H, 45H       ; 00D8 _ 6.LPUBDE
        db 46H, 33H, 32H, 00H, 4CH, 43H, 4FH, 4DH       ; 00E0 _ F32.LCOM
        db 44H, 45H, 46H, 00H, 43H, 45H, 58H, 54H       ; 00E8 _ DEF.CEXT
        db 44H, 45H, 46H, 00H, 43H, 4FH, 4DH, 44H       ; 00F0 _ DEF.COMD
        db 41H, 54H, 31H, 36H, 00H, 43H, 4FH, 4DH       ; 00F8 _ AT16.COM
        db 44H, 41H, 54H, 33H, 32H, 00H, 4CH, 49H       ; 0100 _ DAT32.LI
        db 4EH, 53H, 59H, 4DH, 31H, 36H, 00H, 4CH       ; 0108 _ NSYM16.L
        db 49H, 4EH, 53H, 59H, 4DH, 33H, 32H, 00H       ; 0110 _ INSYM32.
        db 41H, 4CH, 49H, 41H, 53H, 00H, 4EH, 42H       ; 0118 _ ALIAS.NB
        db 4BH, 50H, 41H, 54H, 31H, 36H, 00H, 4EH       ; 0120 _ KPAT16.N
        db 42H, 4BH, 50H, 41H, 54H, 33H, 32H, 00H       ; 0128 _ BKPAT32.
        db 4CH, 4CH, 4EH, 41H, 4DH, 45H, 53H, 00H       ; 0130 _ LLNAMES.
        db 56H, 45H, 52H, 4EH, 55H, 4DH, 00H, 56H       ; 0138 _ VERNUM.V
        db 45H, 4EH, 44H, 45H, 58H, 54H, 00H, 4CH       ; 0140 _ ENDEXT.L
        db 49H, 42H, 48H, 44H, 52H, 00H, 4CH, 49H       ; 0148 _ IBHDR.LI
        db 42H, 45H, 4EH, 44H, 00H                      ; 0150 _ BEND.

?_150:                                                  ; byte
        db 25H, 73H, 3AH, 20H, 6DH, 65H, 6DH, 6FH       ; 0155 _ %s: memo
        db 72H, 79H, 20H, 61H, 6CH, 6CH, 6FH, 63H       ; 015D _ ry alloc
        db 61H, 74H, 69H, 6FH, 6EH, 20H, 65H, 72H       ; 0165 _ ation er
        db 72H, 6FH, 72H, 0AH, 00H                      ; 016D _ ror..

?_151:                                                  ; byte
        db 20H, 20H, 20H, 25H, 30H, 34H, 78H, 3AH       ; 0172 _    %04x:
        db 20H, 00H                                     ; 017A _  .

?_152:                                                  ; byte
        db 20H, 20H, 20H, 00H                           ; 017C _    .

?_153:                                                  ; byte
        db 25H, 30H, 32H, 78H, 25H, 63H, 00H            ; 0180 _ %02x%c.

?_154:                                                  ; byte
        db 78H, 78H, 25H, 63H, 00H                      ; 0187 _ xx%c.

?_155:                                                  ; byte
        db 20H, 3AH, 20H, 20H, 00H                      ; 018C _  :  .

?_156:                                                  ; byte
        db 25H, 30H, 34H, 75H, 2DH, 25H, 30H, 32H       ; 0191 _ %04u-%02
        db 75H, 2DH, 25H, 30H, 32H, 75H, 20H, 25H       ; 0199 _ u-%02u %
        db 30H, 32H, 75H, 3AH, 25H, 30H, 32H, 75H       ; 01A1 _ 02u:%02u
        db 3AH, 25H, 30H, 32H, 75H, 00H                 ; 01A9 _ :%02u.

?_157:                                                  ; byte
        db 20H, 20H, 20H, 23H, 20H, 00H                 ; 01AF _    # .

?_158:                                                  ; byte
        db 20H, 20H, 25H, 2EH, 2AH, 73H, 0AH, 00H       ; 01B5 _   %.*s..

?_159:                                                  ; byte
        db 3FH, 3FH, 3FH, 00H, 00H, 00H, 00H, 00H       ; 01BD _ ???.....
        db 00H, 00H, 00H                                ; 01C5 _ ...

?_160:                                                  ; byte
        db 20H, 20H, 20H, 5BH, 4EH, 50H, 3DH, 25H       ; 01C8 _    [NP=%
        db 64H, 20H, 4EH, 4CH, 3DH, 25H, 64H, 20H       ; 01D0 _ d NL=%d 
        db 55H, 44H, 3DH, 25H, 30H, 32H, 58H, 5DH       ; 01D8 _ UD=%02X]
        db 20H, 25H, 30H, 32H, 58H, 20H, 25H, 73H       ; 01E0 _  %02X %s
        db 0AH, 00H                                     ; 01E8 _ ..

?_161:                                                  ; byte
        db 00H, 00H, 00H, 00H, 00H, 00H                 ; 01EA _ ......

?_162:                                                  ; byte
        db 20H, 20H, 20H, 23H, 20H, 25H, 34H, 7AH       ; 01F0 _    # %4z
        db 75H, 20H, 30H, 78H, 25H, 30H, 34H, 7AH       ; 01F8 _ u 0x%04z
        db 78H, 3AH, 20H, 22H, 25H, 2EH, 2AH, 73H       ; 0200 _ x: "%.*s
        db 2EH, 2EH, 2EH, 20H, 3CH, 25H, 7AH, 75H       ; 0208 _ ... <%zu
        db 20H, 6DH, 69H, 73H, 73H, 69H, 6EH, 67H       ; 0210 _  missing
        db 20H, 62H, 79H, 74H, 65H, 73H, 3EH, 0AH       ; 0218 _  bytes>.
        db 00H                                          ; 0220 _ .

?_163:                                                  ; byte
        db 20H, 20H, 20H, 5BH, 25H, 30H, 34H, 7AH       ; 0221 _    [%04z
        db 78H, 5DH, 20H, 27H, 25H, 73H, 27H, 0AH       ; 0229 _ x] '%s'.
        db 00H                                          ; 0231 _ .

?_164:                                                  ; byte
        db 55H, 53H, 45H, 33H, 32H, 00H                 ; 0232 _ USE32.

?_165:                                                  ; byte
        db 55H, 53H, 45H, 31H, 36H, 00H                 ; 0238 _ USE16.

?_166:                                                  ; byte
        db 4DH, 41H, 58H, 53H, 49H, 5AH, 45H, 20H       ; 023E _ MAXSIZE 
        db 00H                                          ; 0246 _ .

?_167:                                                  ; byte
        db 20H, 20H, 20H, 20H, 20H, 25H, 73H, 20H       ; 0247 _      %s 
        db 28H, 41H, 25H, 75H, 29H, 20H, 25H, 73H       ; 024F _ (A%u) %s
        db 20H, 28H, 43H, 25H, 75H, 29H, 20H, 25H       ; 0257 _  (C%u) %
        db 73H, 25H, 73H, 00H                           ; 025F _ s%s.

?_168:                                                  ; byte
        db 20H, 41H, 54H, 20H, 25H, 30H, 34H, 78H       ; 0263 _  AT %04x
        db 3AH, 00H                                     ; 026B _ :.

?_169:                                                  ; byte
        db 25H, 30H, 32H, 78H, 00H                      ; 026D _ %02x.

?_170:                                                  ; byte
        db 20H, 73H, 69H, 7AH, 65H, 20H, 25H, 30H       ; 0272 _  size %0
        db 38H, 78H, 00H                                ; 027A _ 8x.

?_171:                                                  ; byte
        db 20H, 73H, 69H, 7AH, 65H, 20H, 25H, 30H       ; 027D _  size %0
        db 34H, 78H, 00H                                ; 0285 _ 4x.

?_172:                                                  ; byte
        db 20H, 20H, 20H, 20H, 20H, 6EH, 61H, 6DH       ; 0288 _      nam
        db 65H, 20H, 27H, 25H, 73H, 27H, 00H            ; 0290 _ e '%s'.

?_173:                                                  ; byte
        db 2CH, 20H, 63H, 6CH, 61H, 73H, 73H, 20H       ; 0297 _ , class 
        db 27H, 25H, 73H, 27H, 00H                      ; 029F _ '%s'.

?_174:                                                  ; byte
        db 2CH, 20H, 6FH, 76H, 6CH, 20H, 27H, 25H       ; 02A4 _ , ovl '%
        db 73H, 27H, 00H                                ; 02AC _ s'.

?_175:                                                  ; byte
        db 20H, 20H, 20H, 20H, 20H, 6EH, 61H, 6DH       ; 02AF _      nam
        db 65H, 20H, 27H, 25H, 73H, 27H, 0AH, 00H       ; 02B7 _ e '%s'..

?_176:                                                  ; byte
        db 20H, 20H, 20H, 20H, 20H, 73H, 65H, 67H       ; 02BF _      seg
        db 6DH, 65H, 6EH, 74H, 20H, 27H, 25H, 73H       ; 02C7 _ ment '%s
        db 27H, 0AH, 00H                                ; 02CF _ '..

?_177:                                                  ; byte
        db 20H, 20H, 20H, 20H, 20H, 65H, 78H, 74H       ; 02D2 _      ext
        db 65H, 72H, 6EH, 61H, 6CH, 20H, 27H, 25H       ; 02DA _ ernal '%
        db 73H, 27H, 0AH, 00H, 53H, 45H, 47H, 44H       ; 02E2 _ s'..SEGD
        db 45H, 46H, 00H, 66H, 72H, 61H, 6DH, 65H       ; 02EA _ EF.frame
        db 23H, 00H, 75H, 6EH, 73H, 75H, 70H, 70H       ; 02F2 _ #.unsupp
        db 6FH, 72H, 74H, 65H, 64H, 00H, 70H, 72H       ; 02FA _ orted.pr
        db 65H, 76H, 2EH, 20H, 4CH, 45H, 44H, 41H       ; 0302 _ ev. LEDA
        db 54H, 41H, 20H, 53H, 45H, 47H, 20H, 69H       ; 030A _ TA SEG i
        db 6EH, 64H, 65H, 78H, 00H, 54H, 41H, 52H       ; 0312 _ ndex.TAR
        db 47H, 45H, 54H, 20H, 69H, 6EH, 64H, 65H       ; 031A _ GET inde
        db 78H, 00H, 69H, 6EH, 76H, 61H, 6CH, 69H       ; 0322 _ x.invali
        db 64H, 00H, 6CH, 6FH, 77H, 2DH, 6FH, 72H       ; 032A _ d.low-or
        db 64H, 65H, 72H, 20H, 62H, 79H, 74H, 65H       ; 0332 _ der byte
        db 00H, 31H, 36H, 2DH, 62H, 69H, 74H, 20H       ; 033A _ .16-bit 
        db 6FH, 66H, 66H, 73H, 65H, 74H, 00H, 31H       ; 0342 _ offset.1
        db 36H, 2DH, 62H, 69H, 74H, 20H, 73H, 65H       ; 034A _ 6-bit se
        db 67H, 6DH, 65H, 6EH, 74H, 00H, 33H, 32H       ; 0352 _ gment.32
        db 2DH, 62H, 69H, 74H, 20H, 66H, 61H, 72H       ; 035A _ -bit far
        db 20H, 70H, 74H, 72H, 00H, 68H, 69H, 2DH       ; 0362 _  ptr.hi-
        db 6FH, 72H, 64H, 65H, 72H, 20H, 62H, 79H       ; 036A _ order by
        db 74H, 65H, 00H, 31H, 36H, 2DH, 62H, 69H       ; 0372 _ te.16-bi
        db 74H, 20H, 6CH, 64H, 72H, 2DH, 72H, 65H       ; 037A _ t ldr-re
        db 73H, 6FH, 6CH, 76H, 65H, 64H, 20H, 6FH       ; 0382 _ solved o
        db 66H, 66H, 73H, 65H, 74H, 00H, 72H, 65H       ; 038A _ ffset.re
        db 73H, 65H, 72H, 76H, 65H, 64H, 00H, 75H       ; 0392 _ served.u
        db 6EH, 6BH, 6EH, 6FH, 77H, 6EH, 00H, 33H       ; 039A _ nknown.3
        db 32H, 2DH, 62H, 69H, 74H, 20H, 6FH, 66H       ; 03A2 _ 2-bit of
        db 66H, 73H, 65H, 74H, 00H, 34H, 38H, 2DH       ; 03AA _ fset.48-
        db 62H, 69H, 74H, 20H, 70H, 74H, 72H, 00H       ; 03B2 _ bit ptr.
        db 33H, 32H, 2DH, 62H, 69H, 74H, 20H, 6CH       ; 03BA _ 32-bit l
        db 64H, 72H, 2DH, 72H, 65H, 73H, 6FH, 6CH       ; 03C2 _ dr-resol
        db 76H, 65H, 64H, 20H, 6FH, 66H, 66H, 73H       ; 03CA _ ved offs
        db 65H, 74H, 00H                                ; 03D2 _ et.

?_178:                                                  ; byte
        db 3FH, 00H                                     ; 03D5 _ ?.

?_179:                                                  ; byte
        db 74H, 68H, 72H, 65H, 61H, 64H, 20H, 00H       ; 03D7 _ thread .

?_180:                                                  ; byte
        db 6DH, 65H, 74H, 68H, 6FH, 64H, 20H, 46H       ; 03DF _ method F
        db 00H                                          ; 03E7 _ .

?_181:                                                  ; byte
        db 0AH, 20H, 20H, 20H, 20H, 20H, 20H, 20H       ; 03E8 _ .       
        db 20H, 20H, 20H, 66H, 72H, 61H, 6DH, 65H       ; 03F0 _    frame
        db 20H, 25H, 73H, 25H, 64H, 25H, 73H, 00H       ; 03F8 _  %s%d%s.

?_182:                                                  ; byte
        db 20H, 28H, 25H, 73H, 29H, 00H                 ; 0400 _  (%s).

?_183:                                                  ; byte
        db 20H, 69H, 6EH, 64H, 65H, 78H, 20H, 25H       ; 0406 _  index %
        db 30H, 34H, 78H, 00H                           ; 040E _ 04x.

?_184:                                                  ; byte
        db 20H, 27H, 25H, 73H, 27H, 00H                 ; 0412 _  '%s'.

?_185:                                                  ; byte
        db 6DH, 65H, 74H, 68H, 6FH, 64H, 20H, 54H       ; 0418 _ method T
        db 00H                                          ; 0420 _ .

?_186:                                                  ; byte
        db 0AH, 20H, 20H, 20H, 20H, 20H, 20H, 20H       ; 0421 _ .       
        db 20H, 20H, 20H, 74H, 61H, 72H, 67H, 65H       ; 0429 _    targe
        db 74H, 20H, 25H, 73H, 25H, 64H, 00H            ; 0431 _ t %s%d.

?_187:                                                  ; byte
        db 20H, 64H, 69H, 73H, 70H, 20H, 25H, 30H       ; 0438 _  disp %0
        db 38H, 78H, 00H                                ; 0440 _ 8x.

?_188:                                                  ; byte
        db 20H, 64H, 69H, 73H, 70H, 20H, 25H, 30H       ; 0443 _  disp %0
        db 34H, 78H, 00H                                ; 044B _ 4x.

?_189:                                                  ; byte
        db 20H, 2BH, 66H, 6CH, 61H, 67H, 35H, 3FH       ; 044E _  +flag5?
        db 00H                                          ; 0456 _ .

?_190:                                                  ; byte
        db 66H, 72H, 61H, 6DH, 65H, 00H                 ; 0457 _ frame.

?_191:                                                  ; byte
        db 74H, 61H, 72H, 67H, 65H, 74H, 00H, 00H       ; 045D _ target..
        db 00H, 00H, 00H                                ; 0465 _ ...

?_192:                                                  ; byte
        db 20H, 20H, 20H, 54H, 48H, 52H, 45H, 41H       ; 0468 _    THREA
        db 44H, 20H, 25H, 2DH, 37H, 73H, 25H, 64H       ; 0470 _ D %-7s%d
        db 25H, 73H, 20H, 6DH, 65H, 74H, 68H, 6FH       ; 0478 _ %s metho
        db 64H, 20H, 25H, 63H, 25H, 64H, 20H, 28H       ; 0480 _ d %c%d (
        db 25H, 73H, 29H, 00H                           ; 0488 _ %s).

?_193:                                                  ; byte
        db 73H, 65H, 67H, 6DH, 65H, 6EH, 74H, 00H       ; 048C _ segment.

?_194:                                                  ; byte
        db 73H, 65H, 6CH, 66H, 00H, 00H, 00H, 00H       ; 0494 _ self....
        db 00H, 00H, 00H, 00H                           ; 049C _ ....

?_195:                                                  ; byte
        db 20H, 20H, 20H, 46H, 49H, 58H, 55H, 50H       ; 04A0 _    FIXUP
        db 20H, 20H, 25H, 73H, 2DH, 72H, 65H, 6CH       ; 04A8 _   %s-rel
        db 61H, 74H, 69H, 76H, 65H, 2CH, 20H, 74H       ; 04B0 _ ative, t
        db 79H, 70H, 65H, 20H, 25H, 64H, 20H, 28H       ; 04B8 _ ype %d (
        db 25H, 73H, 29H, 0AH, 20H, 20H, 20H, 20H       ; 04C0 _ %s).    
        db 20H, 20H, 20H, 20H, 20H, 20H, 72H, 65H       ; 04C8 _       re
        db 63H, 6FH, 72H, 64H, 20H, 6FH, 66H, 66H       ; 04D0 _ cord off
        db 73H, 65H, 74H, 20H, 25H, 30H, 34H, 78H       ; 04D8 _ set %04x
        db 00H                                          ; 04E0 _ .

?_196:                                                  ; byte
        db 28H, 6EH, 75H, 6CH, 6CH, 29H, 00H            ; 04E1 _ (null).

?_197:                                                  ; byte
        db 20H, 20H, 20H, 20H, 20H, 20H, 20H, 20H       ; 04E8 _         
        db 20H, 20H, 20H, 20H, 20H, 20H, 20H, 20H       ; 04F0 _         
        db 73H, 65H, 67H, 6DH, 65H, 6EH, 74H, 20H       ; 04F8 _ segment 
        db 27H, 25H, 73H, 27H, 2CH, 20H, 00H            ; 0500 _ '%s', .

?_198:                                                  ; byte
        db 6FH, 66H, 66H, 73H, 65H, 74H, 20H, 25H       ; 0507 _ offset %
        db 30H, 38H, 78H, 0AH, 00H                      ; 050F _ 08x..

?_199:                                                  ; byte
        db 6FH, 66H, 66H, 73H, 65H, 74H, 20H, 25H       ; 0514 _ offset %
        db 30H, 34H, 78H, 0AH, 00H                      ; 051C _ 04x..

?_200:                                                  ; byte
        db 20H, 20H, 20H, 20H, 20H, 66H, 72H, 61H       ; 0521 _      fra
        db 6DH, 65H, 20H, 25H, 30H, 34H, 78H, 00H       ; 0529 _ me %04x.

?_201:                                                  ; byte
        db 20H, 20H, 20H, 20H, 00H                      ; 0531 _     .

?_202:                                                  ; byte
        db 20H, 73H, 65H, 67H, 6DH, 65H, 6EH, 74H       ; 0536 _  segment
        db 20H, 27H, 25H, 73H, 27H, 00H                 ; 053E _  '%s'.

?_203:                                                  ; byte
        db 20H, 67H, 72H, 6FH, 75H, 70H, 20H, 27H       ; 0544 _  group '
        db 25H, 73H, 27H, 00H                           ; 054C _ %s'.

?_204:                                                  ; byte
        db 20H, 20H, 20H, 5BH, 25H, 30H, 34H, 78H       ; 0550 _    [%04x
        db 5DH, 20H, 70H, 75H, 62H, 6CH, 69H, 63H       ; 0558 _ ] public
        db 20H, 6EH, 61H, 6DH, 65H, 20H, 27H, 25H       ; 0560 _  name '%
        db 2EH, 2AH, 73H, 27H, 20H, 00H                 ; 0568 _ .*s' .

?_205:                                                  ; byte
        db 6FH, 66H, 66H, 73H, 65H, 74H, 20H, 25H       ; 056E _ offset %
        db 30H, 38H, 78H, 00H                           ; 0576 _ 08x.

?_206:                                                  ; byte
        db 6FH, 66H, 66H, 73H, 65H, 74H, 20H, 25H       ; 057A _ offset %
        db 30H, 34H, 78H, 00H                           ; 0582 _ 04x.

?_207:                                                  ; byte
        db 2CH, 20H, 74H, 79H, 70H, 65H, 20H, 25H       ; 0586 _ , type %
        db 64H, 00H                                     ; 058E _ d.

?_208:                                                  ; byte
        db 20H, 20H, 20H, 5BH, 25H, 30H, 34H, 78H       ; 0590 _    [%04x
        db 5DH, 20H, 65H, 78H, 74H, 65H, 72H, 6EH       ; 0598 _ ] extern
        db 61H, 6CH, 20H, 6EH, 61H, 6DH, 65H, 20H       ; 05A0 _ al name 
        db 27H, 25H, 73H, 27H, 00H                      ; 05A8 _ '%s'.

?_209:                                                  ; byte
        db 20H, 20H, 20H, 20H, 20H, 6DH, 61H, 69H       ; 05AD _      mai
        db 6EH, 20H, 6DH, 6FH, 64H, 75H, 6CH, 65H       ; 05B5 _ n module
        db 00H                                          ; 05BD _ .

?_210:                                                  ; byte
        db 20H, 20H, 20H, 20H, 20H, 73H, 74H, 61H       ; 05BE _      sta
        db 72H, 74H, 20H, 61H, 64H, 64H, 72H, 65H       ; 05C6 _ rt addre
        db 73H, 73H, 3AH, 00H                           ; 05CE _ ss:.

?_211:                                                  ; byte
        db 25H, 30H, 32H, 78H, 20H, 25H, 2DH, 31H       ; 05D2 _ %02x %-1
        db 30H, 73H, 20H, 25H, 34H, 7AH, 64H, 20H       ; 05DA _ 0s %4zd 
        db 62H, 79H, 74H, 65H, 73H, 00H                 ; 05E2 _ bytes.

?_212:                                                  ; byte
        db 0AH, 20H, 20H, 28H, 74H, 72H, 75H, 6EH       ; 05E8 _ .  (trun
        db 63H, 61H, 74H, 65H, 64H, 2CH, 20H, 6FH       ; 05F0 _ cated, o
        db 6EH, 6CH, 79H, 20H, 25H, 7AH, 64H, 20H       ; 05F8 _ nly %zd 
        db 62H, 79H, 74H, 65H, 73H, 20H, 6CH, 65H       ; 0600 _ bytes le
        db 66H, 74H, 29H, 0AH, 00H                      ; 0608 _ ft)..

?_213:                                                  ; byte
        db 2CH, 20H, 63H, 68H, 65H, 63H, 6BH, 73H       ; 060D _ , checks
        db 75H, 6DH, 20H, 25H, 30H, 32H, 58H, 00H       ; 0615 _ um %02X.

?_214:                                                  ; byte
        db 20H, 28H, 76H, 61H, 6CH, 69H, 64H, 29H       ; 061D _  (valid)
        db 00H                                          ; 0625 _ .

?_215:                                                  ; byte
        db 20H, 28H, 61H, 63H, 74H, 75H, 61H, 6CH       ; 0626 _  (actual
        db 20H, 3DH, 20H, 25H, 30H, 32H, 58H, 29H       ; 062E _  = %02X)
        db 0AH, 00H                                     ; 0636 _ ..

?_216:                                                  ; byte
        db 6FH, 6DH, 66H, 64H, 75H, 6DH, 70H, 20H       ; 0638 _ omfdump 
        db 2DH, 20H, 64H, 75H, 6DH, 70H, 20H, 63H       ; 0640 _ - dump c
        db 6FH, 6EH, 74H, 65H, 6EH, 74H, 73H, 20H       ; 0648 _ ontents 
        db 6FH, 66H, 20H, 6FH, 62H, 6AH, 65H, 63H       ; 0650 _ of objec
        db 74H, 20H, 6DH, 6FH, 64H, 75H, 6CH, 65H       ; 0658 _ t module
        db 20H, 66H, 69H, 6CH, 65H, 73H, 20H, 74H       ; 0660 _  files t
        db 6FH, 20H, 73H, 74H, 64H, 6FH, 75H, 74H       ; 0668 _ o stdout
        db 0AH, 55H, 73H, 61H, 67H, 65H, 3AH, 20H       ; 0670 _ .Usage: 
        db 6FH, 6DH, 66H, 64H, 75H, 6DH, 70H, 20H       ; 0678 _ omfdump 
        db 66H, 69H, 6CH, 65H, 2EH, 2EH, 2EH, 0AH       ; 0680 _ file....
        db 00H                                          ; 0688 _ .

?_217:                                                  ; byte
        db 72H, 62H, 00H, 54H, 72H, 61H, 6EH, 73H       ; 0689 _ rb.Trans
        db 6CH, 61H, 74H, 6FH, 72H, 00H, 43H, 6FH       ; 0691 _ lator.Co
        db 70H, 79H, 72H, 69H, 67H, 68H, 74H, 00H       ; 0699 _ pyright.
        db 4CH, 69H, 62H, 72H, 61H, 72H, 79H, 20H       ; 06A1 _ Library 
        db 73H, 70H, 65H, 63H, 69H, 66H, 69H, 65H       ; 06A9 _ specifie
        db 72H, 00H, 4DH, 53H, 2DH, 44H, 4FH, 53H       ; 06B1 _ r.MS-DOS
        db 20H, 76H, 65H, 72H, 73H, 69H, 6FH, 6EH       ; 06B9 _  version
        db 00H, 4DH, 65H, 6DH, 6FH, 72H, 79H, 20H       ; 06C1 _ .Memory 
        db 6DH, 6FH, 64H, 65H, 6CH, 00H, 44H, 4FH       ; 06C9 _ model.DO
        db 53H, 53H, 45H, 47H, 00H, 4CH, 69H, 62H       ; 06D1 _ SSEG.Lib
        db 72H, 61H, 72H, 79H, 20H, 73H, 65H, 61H       ; 06D9 _ rary sea
        db 72H, 63H, 68H, 00H, 4FH, 4DH, 46H, 20H       ; 06E1 _ rch.OMF 
        db 65H, 78H, 74H, 65H, 6EH, 73H, 69H, 6FH       ; 06E9 _ extensio
        db 6EH, 73H, 00H, 4EH, 65H, 77H, 20H, 4FH       ; 06F1 _ ns.New O
        db 4DH, 46H, 20H, 65H, 78H, 74H, 65H, 6EH       ; 06F9 _ MF exten
        db 73H, 69H, 6FH, 6EH, 00H, 4CH, 69H, 6EH       ; 0701 _ sion.Lin
        db 6BH, 20H, 70H, 61H, 73H, 73H, 20H, 73H       ; 0709 _ k pass s
        db 65H, 70H, 61H, 72H, 61H, 74H, 6FH, 72H       ; 0711 _ eparator
        db 00H, 4CH, 49H, 42H, 4DH, 4FH, 44H, 00H       ; 0719 _ .LIBMOD.
        db 45H, 58H, 45H, 53H, 54H, 52H, 00H, 49H       ; 0721 _ EXESTR.I
        db 4EH, 43H, 45H, 52H, 52H, 00H, 4EH, 4FH       ; 0729 _ NCERR.NO
        db 50H, 41H, 44H, 00H, 57H, 4BH, 45H, 58H       ; 0731 _ PAD.WKEX
        db 54H, 00H, 4CH, 5AH, 45H, 58H, 54H, 00H       ; 0739 _ T.LZEXT.
        db 43H, 6FH, 6DH, 6DH, 65H, 6EH, 74H, 00H       ; 0741 _ Comment.
        db 43H, 6FH, 6DH, 70H, 69H, 6CH, 65H, 72H       ; 0749 _ Compiler
        db 00H, 44H, 61H, 74H, 65H, 00H, 54H, 69H       ; 0751 _ .Date.Ti
        db 6DH, 65H, 73H, 74H, 61H, 6DH, 70H, 00H       ; 0759 _ mestamp.
        db 55H, 73H, 65H, 72H, 00H, 54H, 79H, 70H       ; 0761 _ User.Typ
        db 65H, 20H, 64H, 65H, 66H, 69H, 6EH, 69H       ; 0769 _ e defini
        db 74H, 69H, 6FH, 6EH, 00H, 46H, 69H, 6CH       ; 0771 _ tion.Fil
        db 65H, 6EH, 61H, 6DH, 65H, 00H, 44H, 65H       ; 0779 _ ename.De
        db 70H, 65H, 6EH, 64H, 65H, 6EH, 63H, 79H       ; 0781 _ pendency
        db 20H, 66H, 69H, 6CH, 65H, 00H, 43H, 6FH       ; 0789 _  file.Co
        db 6DH, 6DH, 61H, 6EH, 64H, 20H, 6CH, 69H       ; 0791 _ mmand li
        db 6EH, 65H, 00H, 50H, 52H, 49H, 56H, 41H       ; 0799 _ ne.PRIVA
        db 54H, 45H, 00H, 3FH, 43H, 4FH, 4DH, 4DH       ; 07A1 _ TE.?COMM
        db 4FH, 4EH, 00H, 50H, 55H, 42H, 4CH, 49H       ; 07A9 _ ON.PUBLI
        db 43H, 00H, 3FH, 43H, 4FH, 4DH, 42H, 49H       ; 07B1 _ C.?COMBI
        db 4EH, 45H, 00H, 3FH, 50H, 55H, 42H, 4CH       ; 07B9 _ NE.?PUBL
        db 49H, 43H, 00H, 53H, 54H, 41H, 43H, 4BH       ; 07C1 _ IC.STACK
        db 00H, 43H, 4FH, 4DH, 4DH, 4FH, 4EH, 00H       ; 07C9 _ .COMMON.
        db 41H, 42H, 53H, 00H, 42H, 59H, 54H, 45H       ; 07D1 _ ABS.BYTE
        db 00H, 57H, 4FH, 52H, 44H, 00H, 50H, 41H       ; 07D9 _ .WORD.PA
        db 52H, 41H, 00H, 50H, 41H, 47H, 45H, 00H       ; 07E1 _ RA.PAGE.
        db 44H, 57H, 4FH, 52H, 44H, 00H, 4CH, 54H       ; 07E9 _ DWORD.LT
        db 4CH, 00H, 3FH, 41H, 4CH, 49H, 47H, 4EH       ; 07F1 _ L.?ALIGN
        db 00H                                          ; 07F9 _ .


SECTION .data.rel.local align=32 noexec                 ; section number 5, data

record_types:                                           ; byte
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0000 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0008 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0010 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0018 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0020 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0028 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0030 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0038 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0040 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0048 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0050 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0058 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0060 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0068 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0070 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0078 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0080 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0088 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0090 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0098 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 00A0 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 00A8 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 00B0 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 00B8 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 00C0 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 00C8 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 00D0 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 00D8 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 00E0 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 00E8 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 00F0 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 00F8 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0100 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0108 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0110 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0118 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0120 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0128 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0130 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0138 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0140 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0148 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0150 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0158 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0160 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0168 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0170 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0178 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0180 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0188 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0190 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0198 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 01A0 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 01A8 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 01B0 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 01B8 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 01C0 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 01C8 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 01D0 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 01D8 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 01E0 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 01E8 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 01F0 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 01F8 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0200 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0208 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0210 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0218 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0220 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0228 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0230 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0238 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0240 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0248 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0250 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0258 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0260 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0268 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0270 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0278 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0280 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0288 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0290 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0298 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 02A0 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 02A8 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 02B0 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 02B8 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 02C0 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 02C8 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 02D0 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 02D8 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 02E0 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 02E8 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 02F0 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 02F8 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0300 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0308 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0310 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0318 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0320 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0328 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0330 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0338 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0340 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0348 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0350 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0358 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0360 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0368 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0370 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0378 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0380 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0388 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0390 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0398 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 03A0 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 03A8 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 03B0 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 03B8 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 03C0 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 03C8 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 03D0 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 03D8 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 03E0 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 03E8 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 03F0 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 03F8 _ ........
        dq Unnamed_4_0                                  ; 0400 _ 0000000000000000 (d)
        dq 0000000000000000H                            ; 0408 _ 0000000000000000 
        dq Unnamed_4_0+7H                               ; 0410 _ 0000000000000000 (d)
        dq 0000000000000000H                            ; 0418 _ 0000000000000000 
        dq 0000000000000000H                            ; 0420 _ 0000000000000000 
        dq 0000000000000000H                            ; 0428 _ 0000000000000000 
        dq 0000000000000000H                            ; 0430 _ 0000000000000000 
        dq 0000000000000000H                            ; 0438 _ 0000000000000000 
        dq Unnamed_4_0+0EH                              ; 0440 _ 0000000000000000 (d)
        dq 0000000000000000H                            ; 0448 _ 0000000000000000 
        dq Unnamed_4_0+15H                              ; 0450 _ 0000000000000000 (d)
        dq Unnamed_4_0+1EH                              ; 0458 _ 0000000000000000 (d)
        dq Unnamed_4_0+27H                              ; 0460 _ 0000000000000000 (d)
        dq 0000000000000000H                            ; 0468 _ 0000000000000000 
        dq Unnamed_4_0+2EH                              ; 0470 _ 0000000000000000 (d)
        dq 0000000000000000H                            ; 0478 _ 0000000000000000 
        dq Unnamed_4_0+35H                              ; 0480 _ 0000000000000000 (d)
        dq Unnamed_4_0+3EH                              ; 0488 _ 0000000000000000 (d)
        dq 0000000000000000H                            ; 0490 _ 0000000000000000 
        dq 0000000000000000H                            ; 0498 _ 0000000000000000 
        dq Unnamed_4_0+47H                              ; 04A0 _ 0000000000000000 (d)
        dq Unnamed_4_0+50H                              ; 04A8 _ 0000000000000000 (d)
        dq Unnamed_4_0+59H                              ; 04B0 _ 0000000000000000 (d)
        dq 0000000000000000H                            ; 04B8 _ 0000000000000000 
        dq Unnamed_4_0+60H                              ; 04C0 _ 0000000000000000 (d)
        dq Unnamed_4_0+69H                              ; 04C8 _ 0000000000000000 (d)
        dq Unnamed_4_0+72H                              ; 04D0 _ 0000000000000000 (d)
        dq 0000000000000000H                            ; 04D8 _ 0000000000000000 
        dq Unnamed_4_0+79H                              ; 04E0 _ 0000000000000000 (d)
        dq Unnamed_4_0+82H                              ; 04E8 _ 0000000000000000 (d)
        dq 0000000000000000H                            ; 04F0 _ 0000000000000000 
        dq 0000000000000000H                            ; 04F8 _ 0000000000000000 
        dq Unnamed_4_0+8BH                              ; 0500 _ 0000000000000000 (d)
        dq Unnamed_4_0+94H                              ; 0508 _ 0000000000000000 (d)
        dq Unnamed_4_0+9DH                              ; 0510 _ 0000000000000000 (d)
        dq Unnamed_4_0+0A6H                             ; 0518 _ 0000000000000000 (d)
        dq 0000000000000000H                            ; 0520 _ 0000000000000000 
        dq 0000000000000000H                            ; 0528 _ 0000000000000000 
        dq 0000000000000000H                            ; 0530 _ 0000000000000000 
        dq 0000000000000000H                            ; 0538 _ 0000000000000000 
        dq 0000000000000000H                            ; 0540 _ 0000000000000000 
        dq 0000000000000000H                            ; 0548 _ 0000000000000000 
        dq 0000000000000000H                            ; 0550 _ 0000000000000000 
        dq 0000000000000000H                            ; 0558 _ 0000000000000000 
        dq 0000000000000000H                            ; 0560 _ 0000000000000000 
        dq 0000000000000000H                            ; 0568 _ 0000000000000000 
        dq 0000000000000000H                            ; 0570 _ 0000000000000000 
        dq 0000000000000000H                            ; 0578 _ 0000000000000000 
        dq Unnamed_4_0+0AFH                             ; 0580 _ 0000000000000000 (d)
        dq 0000000000000000H                            ; 0588 _ 0000000000000000 
        dq Unnamed_4_0+0B6H                             ; 0590 _ 0000000000000000 (d)
        dq Unnamed_4_0+0BFH                             ; 0598 _ 0000000000000000 (d)
        dq Unnamed_4_0+0C8H                             ; 05A0 _ 0000000000000000 (d)
        dq 0000000000000000H                            ; 05A8 _ 0000000000000000 
        dq Unnamed_4_0+0D0H                             ; 05B0 _ 0000000000000000 (d)
        dq Unnamed_4_0+0DAH                             ; 05B8 _ 0000000000000000 (d)
        dq Unnamed_4_0+0E4H                             ; 05C0 _ 0000000000000000 (d)
        dq 0000000000000000H                            ; 05C8 _ 0000000000000000 
        dq 0000000000000000H                            ; 05D0 _ 0000000000000000 
        dq 0000000000000000H                            ; 05D8 _ 0000000000000000 
        dq Unnamed_4_0+0ECH                             ; 05E0 _ 0000000000000000 (d)
        dq 0000000000000000H                            ; 05E8 _ 0000000000000000 
        dq 0000000000000000H                            ; 05F0 _ 0000000000000000 
        dq 0000000000000000H                            ; 05F8 _ 0000000000000000 
        dq 0000000000000000H                            ; 0600 _ 0000000000000000 
        dq 0000000000000000H                            ; 0608 _ 0000000000000000 
        dq Unnamed_4_0+0F4H                             ; 0610 _ 0000000000000000 (d)
        dq Unnamed_4_0+0FDH                             ; 0618 _ 0000000000000000 (d)
        dq Unnamed_4_0+106H                             ; 0620 _ 0000000000000000 (d)
        dq Unnamed_4_0+10FH                             ; 0628 _ 0000000000000000 (d)
        dq Unnamed_4_0+118H                             ; 0630 _ 0000000000000000 (d)
        dq 0000000000000000H                            ; 0638 _ 0000000000000000 
        dq Unnamed_4_0+11EH                             ; 0640 _ 0000000000000000 (d)
        dq Unnamed_4_0+127H                             ; 0648 _ 0000000000000000 (d)
        dq Unnamed_4_0+130H                             ; 0650 _ 0000000000000000 (d)
        dq 0000000000000000H                            ; 0658 _ 0000000000000000 
        dq Unnamed_4_0+138H                             ; 0660 _ 0000000000000000 (d)
        dq 0000000000000000H                            ; 0668 _ 0000000000000000 
        dq Unnamed_4_0+13FH                             ; 0670 _ 0000000000000000 (d)
        dq 0000000000000000H                            ; 0678 _ 0000000000000000 
        dq 0000000000000000H                            ; 0680 _ 0000000000000000 
        dq 0000000000000000H                            ; 0688 _ 0000000000000000 
        dq 0000000000000000H                            ; 0690 _ 0000000000000000 
        dq 0000000000000000H                            ; 0698 _ 0000000000000000 
        dq 0000000000000000H                            ; 06A0 _ 0000000000000000 
        dq 0000000000000000H                            ; 06A8 _ 0000000000000000 
        dq 0000000000000000H                            ; 06B0 _ 0000000000000000 
        dq 0000000000000000H                            ; 06B8 _ 0000000000000000 
        dq 0000000000000000H                            ; 06C0 _ 0000000000000000 
        dq 0000000000000000H                            ; 06C8 _ 0000000000000000 
        dq 0000000000000000H                            ; 06D0 _ 0000000000000000 
        dq 0000000000000000H                            ; 06D8 _ 0000000000000000 
        dq 0000000000000000H                            ; 06E0 _ 0000000000000000 
        dq 0000000000000000H                            ; 06E8 _ 0000000000000000 
        dq 0000000000000000H                            ; 06F0 _ 0000000000000000 
        dq 0000000000000000H                            ; 06F8 _ 0000000000000000 
        dq 0000000000000000H                            ; 0700 _ 0000000000000000 
        dq 0000000000000000H                            ; 0708 _ 0000000000000000 
        dq 0000000000000000H                            ; 0710 _ 0000000000000000 
        dq 0000000000000000H                            ; 0718 _ 0000000000000000 
        dq 0000000000000000H                            ; 0720 _ 0000000000000000 
        dq 0000000000000000H                            ; 0728 _ 0000000000000000 
        dq 0000000000000000H                            ; 0730 _ 0000000000000000 
        dq 0000000000000000H                            ; 0738 _ 0000000000000000 
        dq 0000000000000000H                            ; 0740 _ 0000000000000000 
        dq 0000000000000000H                            ; 0748 _ 0000000000000000 
        dq 0000000000000000H                            ; 0750 _ 0000000000000000 
        dq 0000000000000000H                            ; 0758 _ 0000000000000000 
        dq 0000000000000000H                            ; 0760 _ 0000000000000000 
        dq 0000000000000000H                            ; 0768 _ 0000000000000000 
        dq 0000000000000000H                            ; 0770 _ 0000000000000000 
        dq 0000000000000000H                            ; 0778 _ 0000000000000000 
        dq Unnamed_4_0+147H                             ; 0780 _ 0000000000000000 (d)
        dq Unnamed_4_0+14EH                             ; 0788 _ 0000000000000000 (d)
        dq 0000000000000000H                            ; 0790 _ 0000000000000000 
        dq 0000000000000000H                            ; 0798 _ 0000000000000000 
        dq 0000000000000000H                            ; 07A0 _ 0000000000000000 
        dq 0000000000000000H                            ; 07A8 _ 0000000000000000 
        dq 0000000000000000H                            ; 07B0 _ 0000000000000000 
        dq 0000000000000000H                            ; 07B8 _ 0000000000000000 
        dq 0000000000000000H                            ; 07C0 _ 0000000000000000 
        dq 0000000000000000H                            ; 07C8 _ 0000000000000000 
        dq 0000000000000000H                            ; 07D0 _ 0000000000000000 
        dq 0000000000000000H                            ; 07D8 _ 0000000000000000 
        dq 0000000000000000H                            ; 07E0 _ 0000000000000000 
        dq 0000000000000000H                            ; 07E8 _ 0000000000000000 
        dq 0000000000000000H                            ; 07F0 _ 0000000000000000 
        dq 0000000000000000H                            ; 07F8 _ 0000000000000000 

location_descr:                                         ; byte
        dq Unnamed_4_0+32CH                             ; 0800 _ 0000000000000000 (d)
        dq Unnamed_4_0+33BH                             ; 0808 _ 0000000000000000 (d)
        dq Unnamed_4_0+349H                             ; 0810 _ 0000000000000000 (d)
        dq Unnamed_4_0+358H                             ; 0818 _ 0000000000000000 (d)
        dq Unnamed_4_0+367H                             ; 0820 _ 0000000000000000 (d)
        dq Unnamed_4_0+375H                             ; 0828 _ 0000000000000000 (d)
        dq Unnamed_4_0+390H                             ; 0830 _ 0000000000000000 (d)
        dq Unnamed_4_0+390H                             ; 0838 _ 0000000000000000 (d)
        dq Unnamed_4_0+399H                             ; 0840 _ 0000000000000000 (d)
        dq Unnamed_4_0+3A1H                             ; 0848 _ 0000000000000000 (d)
        dq Unnamed_4_0+399H                             ; 0850 _ 0000000000000000 (d)
        dq Unnamed_4_0+3AFH                             ; 0858 _ 0000000000000000 (d)
        dq Unnamed_4_0+399H                             ; 0860 _ 0000000000000000 (d)
        dq Unnamed_4_0+3BAH                             ; 0868 _ 0000000000000000 (d)
        dq Unnamed_4_0+399H                             ; 0870 _ 0000000000000000 (d)
        dq Unnamed_4_0+399H                             ; 0878 _ 0000000000000000 (d)

coment_class.4:                                         ; byte
        dq Unnamed_4_0+68CH                             ; 0880 _ 0000000000000000 (d)
        dq Unnamed_4_0+697H                             ; 0888 _ 0000000000000000 (d)
        dq 0000000000000000H                            ; 0890 _ 0000000000000000 
        dq 0000000000000000H                            ; 0898 _ 0000000000000000 
        dq 0000000000000000H                            ; 08A0 _ 0000000000000000 
        dq 0000000000000000H                            ; 08A8 _ 0000000000000000 
        dq 0000000000000000H                            ; 08B0 _ 0000000000000000 
        dq 0000000000000000H                            ; 08B8 _ 0000000000000000 
        dq 0000000000000000H                            ; 08C0 _ 0000000000000000 
        dq 0000000000000000H                            ; 08C8 _ 0000000000000000 
        dq 0000000000000000H                            ; 08D0 _ 0000000000000000 
        dq 0000000000000000H                            ; 08D8 _ 0000000000000000 
        dq 0000000000000000H                            ; 08E0 _ 0000000000000000 
        dq 0000000000000000H                            ; 08E8 _ 0000000000000000 
        dq 0000000000000000H                            ; 08F0 _ 0000000000000000 
        dq 0000000000000000H                            ; 08F8 _ 0000000000000000 
        dq 0000000000000000H                            ; 0900 _ 0000000000000000 
        dq 0000000000000000H                            ; 0908 _ 0000000000000000 
        dq 0000000000000000H                            ; 0910 _ 0000000000000000 
        dq 0000000000000000H                            ; 0918 _ 0000000000000000 
        dq 0000000000000000H                            ; 0920 _ 0000000000000000 
        dq 0000000000000000H                            ; 0928 _ 0000000000000000 
        dq 0000000000000000H                            ; 0930 _ 0000000000000000 
        dq 0000000000000000H                            ; 0938 _ 0000000000000000 
        dq 0000000000000000H                            ; 0940 _ 0000000000000000 
        dq 0000000000000000H                            ; 0948 _ 0000000000000000 
        dq 0000000000000000H                            ; 0950 _ 0000000000000000 
        dq 0000000000000000H                            ; 0958 _ 0000000000000000 
        dq 0000000000000000H                            ; 0960 _ 0000000000000000 
        dq 0000000000000000H                            ; 0968 _ 0000000000000000 
        dq 0000000000000000H                            ; 0970 _ 0000000000000000 
        dq 0000000000000000H                            ; 0978 _ 0000000000000000 
        dq 0000000000000000H                            ; 0980 _ 0000000000000000 
        dq 0000000000000000H                            ; 0988 _ 0000000000000000 
        dq 0000000000000000H                            ; 0990 _ 0000000000000000 
        dq 0000000000000000H                            ; 0998 _ 0000000000000000 
        dq 0000000000000000H                            ; 09A0 _ 0000000000000000 
        dq 0000000000000000H                            ; 09A8 _ 0000000000000000 
        dq 0000000000000000H                            ; 09B0 _ 0000000000000000 
        dq 0000000000000000H                            ; 09B8 _ 0000000000000000 
        dq 0000000000000000H                            ; 09C0 _ 0000000000000000 
        dq 0000000000000000H                            ; 09C8 _ 0000000000000000 
        dq 0000000000000000H                            ; 09D0 _ 0000000000000000 
        dq 0000000000000000H                            ; 09D8 _ 0000000000000000 
        dq 0000000000000000H                            ; 09E0 _ 0000000000000000 
        dq 0000000000000000H                            ; 09E8 _ 0000000000000000 
        dq 0000000000000000H                            ; 09F0 _ 0000000000000000 
        dq 0000000000000000H                            ; 09F8 _ 0000000000000000 
        dq 0000000000000000H                            ; 0A00 _ 0000000000000000 
        dq 0000000000000000H                            ; 0A08 _ 0000000000000000 
        dq 0000000000000000H                            ; 0A10 _ 0000000000000000 
        dq 0000000000000000H                            ; 0A18 _ 0000000000000000 
        dq 0000000000000000H                            ; 0A20 _ 0000000000000000 
        dq 0000000000000000H                            ; 0A28 _ 0000000000000000 
        dq 0000000000000000H                            ; 0A30 _ 0000000000000000 
        dq 0000000000000000H                            ; 0A38 _ 0000000000000000 
        dq 0000000000000000H                            ; 0A40 _ 0000000000000000 
        dq 0000000000000000H                            ; 0A48 _ 0000000000000000 
        dq 0000000000000000H                            ; 0A50 _ 0000000000000000 
        dq 0000000000000000H                            ; 0A58 _ 0000000000000000 
        dq 0000000000000000H                            ; 0A60 _ 0000000000000000 
        dq 0000000000000000H                            ; 0A68 _ 0000000000000000 
        dq 0000000000000000H                            ; 0A70 _ 0000000000000000 
        dq 0000000000000000H                            ; 0A78 _ 0000000000000000 
        dq 0000000000000000H                            ; 0A80 _ 0000000000000000 
        dq 0000000000000000H                            ; 0A88 _ 0000000000000000 
        dq 0000000000000000H                            ; 0A90 _ 0000000000000000 
        dq 0000000000000000H                            ; 0A98 _ 0000000000000000 
        dq 0000000000000000H                            ; 0AA0 _ 0000000000000000 
        dq 0000000000000000H                            ; 0AA8 _ 0000000000000000 
        dq 0000000000000000H                            ; 0AB0 _ 0000000000000000 
        dq 0000000000000000H                            ; 0AB8 _ 0000000000000000 
        dq 0000000000000000H                            ; 0AC0 _ 0000000000000000 
        dq 0000000000000000H                            ; 0AC8 _ 0000000000000000 
        dq 0000000000000000H                            ; 0AD0 _ 0000000000000000 
        dq 0000000000000000H                            ; 0AD8 _ 0000000000000000 
        dq 0000000000000000H                            ; 0AE0 _ 0000000000000000 
        dq 0000000000000000H                            ; 0AE8 _ 0000000000000000 
        dq 0000000000000000H                            ; 0AF0 _ 0000000000000000 
        dq 0000000000000000H                            ; 0AF8 _ 0000000000000000 
        dq 0000000000000000H                            ; 0B00 _ 0000000000000000 
        dq 0000000000000000H                            ; 0B08 _ 0000000000000000 
        dq 0000000000000000H                            ; 0B10 _ 0000000000000000 
        dq 0000000000000000H                            ; 0B18 _ 0000000000000000 
        dq 0000000000000000H                            ; 0B20 _ 0000000000000000 
        dq 0000000000000000H                            ; 0B28 _ 0000000000000000 
        dq 0000000000000000H                            ; 0B30 _ 0000000000000000 
        dq 0000000000000000H                            ; 0B38 _ 0000000000000000 
        dq 0000000000000000H                            ; 0B40 _ 0000000000000000 
        dq 0000000000000000H                            ; 0B48 _ 0000000000000000 
        dq 0000000000000000H                            ; 0B50 _ 0000000000000000 
        dq 0000000000000000H                            ; 0B58 _ 0000000000000000 
        dq 0000000000000000H                            ; 0B60 _ 0000000000000000 
        dq 0000000000000000H                            ; 0B68 _ 0000000000000000 
        dq 0000000000000000H                            ; 0B70 _ 0000000000000000 
        dq 0000000000000000H                            ; 0B78 _ 0000000000000000 
        dq 0000000000000000H                            ; 0B80 _ 0000000000000000 
        dq 0000000000000000H                            ; 0B88 _ 0000000000000000 
        dq 0000000000000000H                            ; 0B90 _ 0000000000000000 
        dq 0000000000000000H                            ; 0B98 _ 0000000000000000 
        dq 0000000000000000H                            ; 0BA0 _ 0000000000000000 
        dq 0000000000000000H                            ; 0BA8 _ 0000000000000000 
        dq 0000000000000000H                            ; 0BB0 _ 0000000000000000 
        dq 0000000000000000H                            ; 0BB8 _ 0000000000000000 
        dq 0000000000000000H                            ; 0BC0 _ 0000000000000000 
        dq 0000000000000000H                            ; 0BC8 _ 0000000000000000 
        dq 0000000000000000H                            ; 0BD0 _ 0000000000000000 
        dq 0000000000000000H                            ; 0BD8 _ 0000000000000000 
        dq 0000000000000000H                            ; 0BE0 _ 0000000000000000 
        dq 0000000000000000H                            ; 0BE8 _ 0000000000000000 
        dq 0000000000000000H                            ; 0BF0 _ 0000000000000000 
        dq 0000000000000000H                            ; 0BF8 _ 0000000000000000 
        dq 0000000000000000H                            ; 0C00 _ 0000000000000000 
        dq 0000000000000000H                            ; 0C08 _ 0000000000000000 
        dq 0000000000000000H                            ; 0C10 _ 0000000000000000 
        dq 0000000000000000H                            ; 0C18 _ 0000000000000000 
        dq 0000000000000000H                            ; 0C20 _ 0000000000000000 
        dq 0000000000000000H                            ; 0C28 _ 0000000000000000 
        dq 0000000000000000H                            ; 0C30 _ 0000000000000000 
        dq 0000000000000000H                            ; 0C38 _ 0000000000000000 
        dq 0000000000000000H                            ; 0C40 _ 0000000000000000 
        dq 0000000000000000H                            ; 0C48 _ 0000000000000000 
        dq 0000000000000000H                            ; 0C50 _ 0000000000000000 
        dq 0000000000000000H                            ; 0C58 _ 0000000000000000 
        dq 0000000000000000H                            ; 0C60 _ 0000000000000000 
        dq 0000000000000000H                            ; 0C68 _ 0000000000000000 
        dq 0000000000000000H                            ; 0C70 _ 0000000000000000 
        dq 0000000000000000H                            ; 0C78 _ 0000000000000000 
        dq 0000000000000000H                            ; 0C80 _ 0000000000000000 
        dq Unnamed_4_0+6A1H                             ; 0C88 _ 0000000000000000 (d)
        dq 0000000000000000H                            ; 0C90 _ 0000000000000000 
        dq 0000000000000000H                            ; 0C98 _ 0000000000000000 
        dq 0000000000000000H                            ; 0CA0 _ 0000000000000000 
        dq 0000000000000000H                            ; 0CA8 _ 0000000000000000 
        dq 0000000000000000H                            ; 0CB0 _ 0000000000000000 
        dq 0000000000000000H                            ; 0CB8 _ 0000000000000000 
        dq 0000000000000000H                            ; 0CC0 _ 0000000000000000 
        dq 0000000000000000H                            ; 0CC8 _ 0000000000000000 
        dq 0000000000000000H                            ; 0CD0 _ 0000000000000000 
        dq 0000000000000000H                            ; 0CD8 _ 0000000000000000 
        dq 0000000000000000H                            ; 0CE0 _ 0000000000000000 
        dq 0000000000000000H                            ; 0CE8 _ 0000000000000000 
        dq 0000000000000000H                            ; 0CF0 _ 0000000000000000 
        dq 0000000000000000H                            ; 0CF8 _ 0000000000000000 
        dq 0000000000000000H                            ; 0D00 _ 0000000000000000 
        dq 0000000000000000H                            ; 0D08 _ 0000000000000000 
        dq 0000000000000000H                            ; 0D10 _ 0000000000000000 
        dq 0000000000000000H                            ; 0D18 _ 0000000000000000 
        dq 0000000000000000H                            ; 0D20 _ 0000000000000000 
        dq 0000000000000000H                            ; 0D28 _ 0000000000000000 
        dq 0000000000000000H                            ; 0D30 _ 0000000000000000 
        dq 0000000000000000H                            ; 0D38 _ 0000000000000000 
        dq 0000000000000000H                            ; 0D40 _ 0000000000000000 
        dq 0000000000000000H                            ; 0D48 _ 0000000000000000 
        dq 0000000000000000H                            ; 0D50 _ 0000000000000000 
        dq 0000000000000000H                            ; 0D58 _ 0000000000000000 
        dq Unnamed_4_0+6B3H                             ; 0D60 _ 0000000000000000 (d)
        dq Unnamed_4_0+6C2H                             ; 0D68 _ 0000000000000000 (d)
        dq Unnamed_4_0+6CFH                             ; 0D70 _ 0000000000000000 (d)
        dq Unnamed_4_0+6D6H                             ; 0D78 _ 0000000000000000 (d)
        dq Unnamed_4_0+6E5H                             ; 0D80 _ 0000000000000000 (d)
        dq Unnamed_4_0+6F4H                             ; 0D88 _ 0000000000000000 (d)
        dq Unnamed_4_0+706H                             ; 0D90 _ 0000000000000000 (d)
        dq Unnamed_4_0+71AH                             ; 0D98 _ 0000000000000000 (d)
        dq Unnamed_4_0+721H                             ; 0DA0 _ 0000000000000000 (d)
        dq 0000000000000000H                            ; 0DA8 _ 0000000000000000 
        dq Unnamed_4_0+728H                             ; 0DB0 _ 0000000000000000 (d)
        dq Unnamed_4_0+72FH                             ; 0DB8 _ 0000000000000000 (d)
        dq Unnamed_4_0+735H                             ; 0DC0 _ 0000000000000000 (d)
        dq Unnamed_4_0+73BH                             ; 0DC8 _ 0000000000000000 (d)
        dq 0000000000000000H                            ; 0DD0 _ 0000000000000000 
        dq 0000000000000000H                            ; 0DD8 _ 0000000000000000 
        dq 0000000000000000H                            ; 0DE0 _ 0000000000000000 
        dq 0000000000000000H                            ; 0DE8 _ 0000000000000000 
        dq 0000000000000000H                            ; 0DF0 _ 0000000000000000 
        dq 0000000000000000H                            ; 0DF8 _ 0000000000000000 
        dq 0000000000000000H                            ; 0E00 _ 0000000000000000 
        dq 0000000000000000H                            ; 0E08 _ 0000000000000000 
        dq 0000000000000000H                            ; 0E10 _ 0000000000000000 
        dq 0000000000000000H                            ; 0E18 _ 0000000000000000 
        dq 0000000000000000H                            ; 0E20 _ 0000000000000000 
        dq 0000000000000000H                            ; 0E28 _ 0000000000000000 
        dq 0000000000000000H                            ; 0E30 _ 0000000000000000 
        dq 0000000000000000H                            ; 0E38 _ 0000000000000000 
        dq 0000000000000000H                            ; 0E40 _ 0000000000000000 
        dq 0000000000000000H                            ; 0E48 _ 0000000000000000 
        dq 0000000000000000H                            ; 0E50 _ 0000000000000000 
        dq 0000000000000000H                            ; 0E58 _ 0000000000000000 
        dq 0000000000000000H                            ; 0E60 _ 0000000000000000 
        dq 0000000000000000H                            ; 0E68 _ 0000000000000000 
        dq 0000000000000000H                            ; 0E70 _ 0000000000000000 
        dq 0000000000000000H                            ; 0E78 _ 0000000000000000 
        dq 0000000000000000H                            ; 0E80 _ 0000000000000000 
        dq 0000000000000000H                            ; 0E88 _ 0000000000000000 
        dq 0000000000000000H                            ; 0E90 _ 0000000000000000 
        dq 0000000000000000H                            ; 0E98 _ 0000000000000000 
        dq 0000000000000000H                            ; 0EA0 _ 0000000000000000 
        dq 0000000000000000H                            ; 0EA8 _ 0000000000000000 
        dq 0000000000000000H                            ; 0EB0 _ 0000000000000000 
        dq 0000000000000000H                            ; 0EB8 _ 0000000000000000 
        dq 0000000000000000H                            ; 0EC0 _ 0000000000000000 
        dq 0000000000000000H                            ; 0EC8 _ 0000000000000000 
        dq 0000000000000000H                            ; 0ED0 _ 0000000000000000 
        dq 0000000000000000H                            ; 0ED8 _ 0000000000000000 
        dq 0000000000000000H                            ; 0EE0 _ 0000000000000000 
        dq 0000000000000000H                            ; 0EE8 _ 0000000000000000 
        dq 0000000000000000H                            ; 0EF0 _ 0000000000000000 
        dq 0000000000000000H                            ; 0EF8 _ 0000000000000000 
        dq 0000000000000000H                            ; 0F00 _ 0000000000000000 
        dq 0000000000000000H                            ; 0F08 _ 0000000000000000 
        dq 0000000000000000H                            ; 0F10 _ 0000000000000000 
        dq 0000000000000000H                            ; 0F18 _ 0000000000000000 
        dq 0000000000000000H                            ; 0F20 _ 0000000000000000 
        dq 0000000000000000H                            ; 0F28 _ 0000000000000000 
        dq 0000000000000000H                            ; 0F30 _ 0000000000000000 
        dq 0000000000000000H                            ; 0F38 _ 0000000000000000 
        dq 0000000000000000H                            ; 0F40 _ 0000000000000000 
        dq 0000000000000000H                            ; 0F48 _ 0000000000000000 
        dq Unnamed_4_0+741H                             ; 0F50 _ 0000000000000000 (d)
        dq Unnamed_4_0+749H                             ; 0F58 _ 0000000000000000 (d)
        dq Unnamed_4_0+752H                             ; 0F60 _ 0000000000000000 (d)
        dq Unnamed_4_0+757H                             ; 0F68 _ 0000000000000000 (d)
        dq 0000000000000000H                            ; 0F70 _ 0000000000000000 
        dq Unnamed_4_0+761H                             ; 0F78 _ 0000000000000000 (d)
        dq 0000000000000000H                            ; 0F80 _ 0000000000000000 
        dq 0000000000000000H                            ; 0F88 _ 0000000000000000 
        dq 0000000000000000H                            ; 0F90 _ 0000000000000000 
        dq Unnamed_4_0+766H                             ; 0F98 _ 0000000000000000 (d)
        dq 0000000000000000H                            ; 0FA0 _ 0000000000000000 
        dq 0000000000000000H                            ; 0FA8 _ 0000000000000000 
        dq 0000000000000000H                            ; 0FB0 _ 0000000000000000 
        dq 0000000000000000H                            ; 0FB8 _ 0000000000000000 
        dq Unnamed_4_0+776H                             ; 0FC0 _ 0000000000000000 (d)
        dq Unnamed_4_0+77FH                             ; 0FC8 _ 0000000000000000 (d)
        dq 0000000000000000H                            ; 0FD0 _ 0000000000000000 
        dq 0000000000000000H                            ; 0FD8 _ 0000000000000000 
        dq 0000000000000000H                            ; 0FE0 _ 0000000000000000 
        dq 0000000000000000H                            ; 0FE8 _ 0000000000000000 
        dq 0000000000000000H                            ; 0FF0 _ 0000000000000000 
        dq 0000000000000000H                            ; 0FF8 _ 0000000000000000 
        dq 0000000000000000H                            ; 1000 _ 0000000000000000 
        dq 0000000000000000H                            ; 1008 _ 0000000000000000 
        dq 0000000000000000H                            ; 1010 _ 0000000000000000 
        dq 0000000000000000H                            ; 1018 _ 0000000000000000 
        dq 0000000000000000H                            ; 1020 _ 0000000000000000 
        dq 0000000000000000H                            ; 1028 _ 0000000000000000 
        dq 0000000000000000H                            ; 1030 _ 0000000000000000 
        dq 0000000000000000H                            ; 1038 _ 0000000000000000 
        dq 0000000000000000H                            ; 1040 _ 0000000000000000 
        dq 0000000000000000H                            ; 1048 _ 0000000000000000 
        dq 0000000000000000H                            ; 1050 _ 0000000000000000 
        dq 0000000000000000H                            ; 1058 _ 0000000000000000 
        dq 0000000000000000H                            ; 1060 _ 0000000000000000 
        dq 0000000000000000H                            ; 1068 _ 0000000000000000 
        dq 0000000000000000H                            ; 1070 _ 0000000000000000 
        dq Unnamed_4_0+78FH                             ; 1078 _ 0000000000000000 (d)


SECTION .data.rel.ro.local align=32 noexec              ; section number 6, data

dump_coment_class:                                      ; qword
        dq dump_coment_class                            ; 0000 _ 0000000000000000 (d)

        dq dump_coment_class                            ; 0008 _ 0000000000000000 (d)
        dq 0000000000000000H                            ; 0010 _ 0000000000000000 
        dq 0000000000000000H                            ; 0018 _ 0000000000000000 
        dq 0000000000000000H                            ; 0020 _ 0000000000000000 
        dq 0000000000000000H                            ; 0028 _ 0000000000000000 
        dq 0000000000000000H                            ; 0030 _ 0000000000000000 
        dq 0000000000000000H                            ; 0038 _ 0000000000000000 
        dq 0000000000000000H                            ; 0040 _ 0000000000000000 
        dq 0000000000000000H                            ; 0048 _ 0000000000000000 
        dq 0000000000000000H                            ; 0050 _ 0000000000000000 
        dq 0000000000000000H                            ; 0058 _ 0000000000000000 
        dq 0000000000000000H                            ; 0060 _ 0000000000000000 
        dq 0000000000000000H                            ; 0068 _ 0000000000000000 
        dq 0000000000000000H                            ; 0070 _ 0000000000000000 
        dq 0000000000000000H                            ; 0078 _ 0000000000000000 
        dq 0000000000000000H                            ; 0080 _ 0000000000000000 
        dq 0000000000000000H                            ; 0088 _ 0000000000000000 
        dq 0000000000000000H                            ; 0090 _ 0000000000000000 
        dq 0000000000000000H                            ; 0098 _ 0000000000000000 
        dq 0000000000000000H                            ; 00A0 _ 0000000000000000 
        dq 0000000000000000H                            ; 00A8 _ 0000000000000000 
        dq 0000000000000000H                            ; 00B0 _ 0000000000000000 
        dq 0000000000000000H                            ; 00B8 _ 0000000000000000 
        dq 0000000000000000H                            ; 00C0 _ 0000000000000000 
        dq 0000000000000000H                            ; 00C8 _ 0000000000000000 
        dq 0000000000000000H                            ; 00D0 _ 0000000000000000 
        dq 0000000000000000H                            ; 00D8 _ 0000000000000000 
        dq 0000000000000000H                            ; 00E0 _ 0000000000000000 
        dq 0000000000000000H                            ; 00E8 _ 0000000000000000 
        dq 0000000000000000H                            ; 00F0 _ 0000000000000000 
        dq 0000000000000000H                            ; 00F8 _ 0000000000000000 
        dq 0000000000000000H                            ; 0100 _ 0000000000000000 
        dq 0000000000000000H                            ; 0108 _ 0000000000000000 
        dq 0000000000000000H                            ; 0110 _ 0000000000000000 
        dq 0000000000000000H                            ; 0118 _ 0000000000000000 
        dq 0000000000000000H                            ; 0120 _ 0000000000000000 
        dq 0000000000000000H                            ; 0128 _ 0000000000000000 
        dq 0000000000000000H                            ; 0130 _ 0000000000000000 
        dq 0000000000000000H                            ; 0138 _ 0000000000000000 
        dq 0000000000000000H                            ; 0140 _ 0000000000000000 
        dq 0000000000000000H                            ; 0148 _ 0000000000000000 
        dq 0000000000000000H                            ; 0150 _ 0000000000000000 
        dq 0000000000000000H                            ; 0158 _ 0000000000000000 
        dq 0000000000000000H                            ; 0160 _ 0000000000000000 
        dq 0000000000000000H                            ; 0168 _ 0000000000000000 
        dq 0000000000000000H                            ; 0170 _ 0000000000000000 
        dq 0000000000000000H                            ; 0178 _ 0000000000000000 
        dq 0000000000000000H                            ; 0180 _ 0000000000000000 
        dq 0000000000000000H                            ; 0188 _ 0000000000000000 
        dq 0000000000000000H                            ; 0190 _ 0000000000000000 
        dq 0000000000000000H                            ; 0198 _ 0000000000000000 
        dq 0000000000000000H                            ; 01A0 _ 0000000000000000 
        dq 0000000000000000H                            ; 01A8 _ 0000000000000000 
        dq 0000000000000000H                            ; 01B0 _ 0000000000000000 
        dq 0000000000000000H                            ; 01B8 _ 0000000000000000 
        dq 0000000000000000H                            ; 01C0 _ 0000000000000000 
        dq 0000000000000000H                            ; 01C8 _ 0000000000000000 
        dq 0000000000000000H                            ; 01D0 _ 0000000000000000 
        dq 0000000000000000H                            ; 01D8 _ 0000000000000000 
        dq 0000000000000000H                            ; 01E0 _ 0000000000000000 
        dq 0000000000000000H                            ; 01E8 _ 0000000000000000 
        dq 0000000000000000H                            ; 01F0 _ 0000000000000000 
        dq 0000000000000000H                            ; 01F8 _ 0000000000000000 
        dq 0000000000000000H                            ; 0200 _ 0000000000000000 
        dq 0000000000000000H                            ; 0208 _ 0000000000000000 
        dq 0000000000000000H                            ; 0210 _ 0000000000000000 
        dq 0000000000000000H                            ; 0218 _ 0000000000000000 
        dq 0000000000000000H                            ; 0220 _ 0000000000000000 
        dq 0000000000000000H                            ; 0228 _ 0000000000000000 
        dq 0000000000000000H                            ; 0230 _ 0000000000000000 
        dq 0000000000000000H                            ; 0238 _ 0000000000000000 
        dq 0000000000000000H                            ; 0240 _ 0000000000000000 
        dq 0000000000000000H                            ; 0248 _ 0000000000000000 
        dq 0000000000000000H                            ; 0250 _ 0000000000000000 
        dq 0000000000000000H                            ; 0258 _ 0000000000000000 
        dq 0000000000000000H                            ; 0260 _ 0000000000000000 
        dq 0000000000000000H                            ; 0268 _ 0000000000000000 
        dq 0000000000000000H                            ; 0270 _ 0000000000000000 
        dq 0000000000000000H                            ; 0278 _ 0000000000000000 
        dq 0000000000000000H                            ; 0280 _ 0000000000000000 
        dq 0000000000000000H                            ; 0288 _ 0000000000000000 
        dq 0000000000000000H                            ; 0290 _ 0000000000000000 
        dq 0000000000000000H                            ; 0298 _ 0000000000000000 
        dq 0000000000000000H                            ; 02A0 _ 0000000000000000 
        dq 0000000000000000H                            ; 02A8 _ 0000000000000000 
        dq 0000000000000000H                            ; 02B0 _ 0000000000000000 
        dq 0000000000000000H                            ; 02B8 _ 0000000000000000 
        dq 0000000000000000H                            ; 02C0 _ 0000000000000000 
        dq 0000000000000000H                            ; 02C8 _ 0000000000000000 
        dq 0000000000000000H                            ; 02D0 _ 0000000000000000 
        dq 0000000000000000H                            ; 02D8 _ 0000000000000000 
        dq 0000000000000000H                            ; 02E0 _ 0000000000000000 
        dq 0000000000000000H                            ; 02E8 _ 0000000000000000 
        dq 0000000000000000H                            ; 02F0 _ 0000000000000000 
        dq 0000000000000000H                            ; 02F8 _ 0000000000000000 
        dq 0000000000000000H                            ; 0300 _ 0000000000000000 
        dq 0000000000000000H                            ; 0308 _ 0000000000000000 
        dq 0000000000000000H                            ; 0310 _ 0000000000000000 
        dq 0000000000000000H                            ; 0318 _ 0000000000000000 
        dq 0000000000000000H                            ; 0320 _ 0000000000000000 
        dq 0000000000000000H                            ; 0328 _ 0000000000000000 
        dq 0000000000000000H                            ; 0330 _ 0000000000000000 
        dq 0000000000000000H                            ; 0338 _ 0000000000000000 
        dq 0000000000000000H                            ; 0340 _ 0000000000000000 
        dq 0000000000000000H                            ; 0348 _ 0000000000000000 
        dq 0000000000000000H                            ; 0350 _ 0000000000000000 
        dq 0000000000000000H                            ; 0358 _ 0000000000000000 
        dq 0000000000000000H                            ; 0360 _ 0000000000000000 
        dq 0000000000000000H                            ; 0368 _ 0000000000000000 
        dq 0000000000000000H                            ; 0370 _ 0000000000000000 
        dq 0000000000000000H                            ; 0378 _ 0000000000000000 
        dq 0000000000000000H                            ; 0380 _ 0000000000000000 
        dq 0000000000000000H                            ; 0388 _ 0000000000000000 
        dq 0000000000000000H                            ; 0390 _ 0000000000000000 
        dq 0000000000000000H                            ; 0398 _ 0000000000000000 
        dq 0000000000000000H                            ; 03A0 _ 0000000000000000 
        dq 0000000000000000H                            ; 03A8 _ 0000000000000000 
        dq 0000000000000000H                            ; 03B0 _ 0000000000000000 
        dq 0000000000000000H                            ; 03B8 _ 0000000000000000 
        dq 0000000000000000H                            ; 03C0 _ 0000000000000000 
        dq 0000000000000000H                            ; 03C8 _ 0000000000000000 
        dq 0000000000000000H                            ; 03D0 _ 0000000000000000 
        dq 0000000000000000H                            ; 03D8 _ 0000000000000000 
        dq 0000000000000000H                            ; 03E0 _ 0000000000000000 
        dq 0000000000000000H                            ; 03E8 _ 0000000000000000 
        dq 0000000000000000H                            ; 03F0 _ 0000000000000000 
        dq 0000000000000000H                            ; 03F8 _ 0000000000000000 
        dq 0000000000000000H                            ; 0400 _ 0000000000000000 
        dq 0000000000000000H                            ; 0408 _ 0000000000000000 
        dq 0000000000000000H                            ; 0410 _ 0000000000000000 
        dq 0000000000000000H                            ; 0418 _ 0000000000000000 
        dq 0000000000000000H                            ; 0420 _ 0000000000000000 
        dq 0000000000000000H                            ; 0428 _ 0000000000000000 
        dq 0000000000000000H                            ; 0430 _ 0000000000000000 
        dq 0000000000000000H                            ; 0438 _ 0000000000000000 
        dq 0000000000000000H                            ; 0440 _ 0000000000000000 
        dq 0000000000000000H                            ; 0448 _ 0000000000000000 
        dq 0000000000000000H                            ; 0450 _ 0000000000000000 
        dq 0000000000000000H                            ; 0458 _ 0000000000000000 
        dq 0000000000000000H                            ; 0460 _ 0000000000000000 
        dq 0000000000000000H                            ; 0468 _ 0000000000000000 
        dq 0000000000000000H                            ; 0470 _ 0000000000000000 
        dq 0000000000000000H                            ; 0478 _ 0000000000000000 
        dq 0000000000000000H                            ; 0480 _ 0000000000000000 
        dq 0000000000000000H                            ; 0488 _ 0000000000000000 
        dq 0000000000000000H                            ; 0490 _ 0000000000000000 
        dq 0000000000000000H                            ; 0498 _ 0000000000000000 
        dq 0000000000000000H                            ; 04A0 _ 0000000000000000 
        dq 0000000000000000H                            ; 04A8 _ 0000000000000000 
        dq 0000000000000000H                            ; 04B0 _ 0000000000000000 
        dq 0000000000000000H                            ; 04B8 _ 0000000000000000 
        dq 0000000000000000H                            ; 04C0 _ 0000000000000000 
        dq 0000000000000000H                            ; 04C8 _ 0000000000000000 
        dq 0000000000000000H                            ; 04D0 _ 0000000000000000 
        dq 0000000000000000H                            ; 04D8 _ 0000000000000000 
        dq 0000000000000000H                            ; 04E0 _ 0000000000000000 
        dq 0000000000000000H                            ; 04E8 _ 0000000000000000 
        dq 0000000000000000H                            ; 04F0 _ 0000000000000000 
        dq 0000000000000000H                            ; 04F8 _ 0000000000000000 
        dq 0000000000000000H                            ; 0500 _ 0000000000000000 
        dq 0000000000000000H                            ; 0508 _ 0000000000000000 
        dq 0000000000000000H                            ; 0510 _ 0000000000000000 
        dq 0000000000000000H                            ; 0518 _ 0000000000000000 
        dq 0000000000000000H                            ; 0520 _ 0000000000000000 
        dq 0000000000000000H                            ; 0528 _ 0000000000000000 
        dq 0000000000000000H                            ; 0530 _ 0000000000000000 
        dq 0000000000000000H                            ; 0538 _ 0000000000000000 
        dq 0000000000000000H                            ; 0540 _ 0000000000000000 
        dq 0000000000000000H                            ; 0548 _ 0000000000000000 
        dq 0000000000000000H                            ; 0550 _ 0000000000000000 
        dq 0000000000000000H                            ; 0558 _ 0000000000000000 
        dq 0000000000000000H                            ; 0560 _ 0000000000000000 
        dq 0000000000000000H                            ; 0568 _ 0000000000000000 
        dq 0000000000000000H                            ; 0570 _ 0000000000000000 
        dq 0000000000000000H                            ; 0578 _ 0000000000000000 
        dq 0000000000000000H                            ; 0580 _ 0000000000000000 
        dq 0000000000000000H                            ; 0588 _ 0000000000000000 
        dq 0000000000000000H                            ; 0590 _ 0000000000000000 
        dq 0000000000000000H                            ; 0598 _ 0000000000000000 
        dq 0000000000000000H                            ; 05A0 _ 0000000000000000 
        dq 0000000000000000H                            ; 05A8 _ 0000000000000000 
        dq 0000000000000000H                            ; 05B0 _ 0000000000000000 
        dq 0000000000000000H                            ; 05B8 _ 0000000000000000 
        dq 0000000000000000H                            ; 05C0 _ 0000000000000000 
        dq 0000000000000000H                            ; 05C8 _ 0000000000000000 
        dq 0000000000000000H                            ; 05D0 _ 0000000000000000 
        dq 0000000000000000H                            ; 05D8 _ 0000000000000000 
        dq 0000000000000000H                            ; 05E0 _ 0000000000000000 
        dq 0000000000000000H                            ; 05E8 _ 0000000000000000 
        dq 0000000000000000H                            ; 05F0 _ 0000000000000000 
        dq 0000000000000000H                            ; 05F8 _ 0000000000000000 
        dq 0000000000000000H                            ; 0600 _ 0000000000000000 
        dq 0000000000000000H                            ; 0608 _ 0000000000000000 
        dq 0000000000000000H                            ; 0610 _ 0000000000000000 
        dq 0000000000000000H                            ; 0618 _ 0000000000000000 
        dq 0000000000000000H                            ; 0620 _ 0000000000000000 
        dq 0000000000000000H                            ; 0628 _ 0000000000000000 
        dq 0000000000000000H                            ; 0630 _ 0000000000000000 
        dq 0000000000000000H                            ; 0638 _ 0000000000000000 
        dq 0000000000000000H                            ; 0640 _ 0000000000000000 
        dq 0000000000000000H                            ; 0648 _ 0000000000000000 
        dq 0000000000000000H                            ; 0650 _ 0000000000000000 
        dq 0000000000000000H                            ; 0658 _ 0000000000000000 
        dq 0000000000000000H                            ; 0660 _ 0000000000000000 
        dq 0000000000000000H                            ; 0668 _ 0000000000000000 
        dq 0000000000000000H                            ; 0670 _ 0000000000000000 
        dq 0000000000000000H                            ; 0678 _ 0000000000000000 
        dq 0000000000000000H                            ; 0680 _ 0000000000000000 
        dq 0000000000000000H                            ; 0688 _ 0000000000000000 
        dq 0000000000000000H                            ; 0690 _ 0000000000000000 
        dq 0000000000000000H                            ; 0698 _ 0000000000000000 
        dq 0000000000000000H                            ; 06A0 _ 0000000000000000 
        dq 0000000000000000H                            ; 06A8 _ 0000000000000000 
        dq 0000000000000000H                            ; 06B0 _ 0000000000000000 
        dq 0000000000000000H                            ; 06B8 _ 0000000000000000 
        dq 0000000000000000H                            ; 06C0 _ 0000000000000000 
        dq 0000000000000000H                            ; 06C8 _ 0000000000000000 
        dq 0000000000000000H                            ; 06D0 _ 0000000000000000 
        dq 0000000000000000H                            ; 06D8 _ 0000000000000000 
        dq 0000000000000000H                            ; 06E0 _ 0000000000000000 
        dq 0000000000000000H                            ; 06E8 _ 0000000000000000 
        dq 0000000000000000H                            ; 06F0 _ 0000000000000000 
        dq 0000000000000000H                            ; 06F8 _ 0000000000000000 
        dq 0000000000000000H                            ; 0700 _ 0000000000000000 
        dq 0000000000000000H                            ; 0708 _ 0000000000000000 
        dq 0000000000000000H                            ; 0710 _ 0000000000000000 
        dq 0000000000000000H                            ; 0718 _ 0000000000000000 
        dq 0000000000000000H                            ; 0720 _ 0000000000000000 
        dq 0000000000000000H                            ; 0728 _ 0000000000000000 
        dq 0000000000000000H                            ; 0730 _ 0000000000000000 
        dq 0000000000000000H                            ; 0738 _ 0000000000000000 
        dq 0000000000000000H                            ; 0740 _ 0000000000000000 
        dq dump_coment_depfile                          ; 0748 _ 0000000000000000 (d)
        dq 0000000000000000H                            ; 0750 _ 0000000000000000 
        dq 0000000000000000H                            ; 0758 _ 0000000000000000 
        dq 0000000000000000H                            ; 0760 _ 0000000000000000 
        dq 0000000000000000H                            ; 0768 _ 0000000000000000 
        dq 0000000000000000H                            ; 0770 _ 0000000000000000 
        dq 0000000000000000H                            ; 0778 _ 0000000000000000 
        dq 0000000000000000H                            ; 0780 _ 0000000000000000 
        dq 0000000000000000H                            ; 0788 _ 0000000000000000 
        dq 0000000000000000H                            ; 0790 _ 0000000000000000 
        dq 0000000000000000H                            ; 0798 _ 0000000000000000 
        dq 0000000000000000H                            ; 07A0 _ 0000000000000000 
        dq 0000000000000000H                            ; 07A8 _ 0000000000000000 
        dq 0000000000000000H                            ; 07B0 _ 0000000000000000 
        dq 0000000000000000H                            ; 07B8 _ 0000000000000000 
        dq 0000000000000000H                            ; 07C0 _ 0000000000000000 
        dq 0000000000000000H                            ; 07C8 _ 0000000000000000 
        dq 0000000000000000H                            ; 07D0 _ 0000000000000000 
        dq 0000000000000000H                            ; 07D8 _ 0000000000000000 
        dq 0000000000000000H                            ; 07E0 _ 0000000000000000 
        dq 0000000000000000H                            ; 07E8 _ 0000000000000000 
        dq 0000000000000000H                            ; 07F0 _ 0000000000000000 
        dq 0000000000000000H                            ; 07F8 _ 0000000000000000 

method_base:                                            ; byte
        dq Unnamed_4_0+2E6H                             ; 0800 _ 0000000000000000 (d)
        dq Unnamed_4_0+72H                              ; 0808 _ 0000000000000000 (d)
        dq Unnamed_4_0+27H                              ; 0810 _ 0000000000000000 (d)
        dq Unnamed_4_0+2EDH                             ; 0818 _ 0000000000000000 (d)
        dq Unnamed_4_0+2E6H                             ; 0820 _ 0000000000000000 (d)
        dq Unnamed_4_0+72H                              ; 0828 _ 0000000000000000 (d)
        dq Unnamed_4_0+27H                              ; 0830 _ 0000000000000000 (d)
        dq Unnamed_4_0+2F4H                             ; 0838 _ 0000000000000000 (d)
        dq Unnamed_4_0+2E6H                             ; 0840 _ 0000000000000000 (d)
        dq Unnamed_4_0+72H                              ; 0848 _ 0000000000000000 (d)
        dq Unnamed_4_0+27H                              ; 0850 _ 0000000000000000 (d)
        dq Unnamed_4_0+2EDH                             ; 0858 _ 0000000000000000 (d)
        dq Unnamed_4_0+300H                             ; 0860 _ 0000000000000000 (d)
        dq Unnamed_4_0+317H                             ; 0868 _ 0000000000000000 (d)
        dq Unnamed_4_0+324H                             ; 0870 _ 0000000000000000 (d)
        dq Unnamed_4_0+2F4H                             ; 0878 _ 0000000000000000 (d)

dump_type:                                              ; virtual table or function pointer
        dq dump_coment_class                            ; 0880 _ 0000000000000000 (d)

        dq dump_coment_class                            ; 0888 _ 0000000000000000 (d)
        dq 0000000000000000H                            ; 0890 _ 0000000000000000 
        dq 0000000000000000H                            ; 0898 _ 0000000000000000 
        dq 0000000000000000H                            ; 08A0 _ 0000000000000000 
        dq 0000000000000000H                            ; 08A8 _ 0000000000000000 
        dq 0000000000000000H                            ; 08B0 _ 0000000000000000 
        dq 0000000000000000H                            ; 08B8 _ 0000000000000000 
        dq 0000000000000000H                            ; 08C0 _ 0000000000000000 
        dq 0000000000000000H                            ; 08C8 _ 0000000000000000 
        dq 0000000000000000H                            ; 08D0 _ 0000000000000000 
        dq 0000000000000000H                            ; 08D8 _ 0000000000000000 
        dq 0000000000000000H                            ; 08E0 _ 0000000000000000 
        dq 0000000000000000H                            ; 08E8 _ 0000000000000000 
        dq 0000000000000000H                            ; 08F0 _ 0000000000000000 
        dq 0000000000000000H                            ; 08F8 _ 0000000000000000 
        dq 0000000000000000H                            ; 0900 _ 0000000000000000 
        dq 0000000000000000H                            ; 0908 _ 0000000000000000 
        dq 0000000000000000H                            ; 0910 _ 0000000000000000 
        dq 0000000000000000H                            ; 0918 _ 0000000000000000 
        dq 0000000000000000H                            ; 0920 _ 0000000000000000 
        dq 0000000000000000H                            ; 0928 _ 0000000000000000 
        dq 0000000000000000H                            ; 0930 _ 0000000000000000 
        dq 0000000000000000H                            ; 0938 _ 0000000000000000 
        dq 0000000000000000H                            ; 0940 _ 0000000000000000 
        dq 0000000000000000H                            ; 0948 _ 0000000000000000 
        dq 0000000000000000H                            ; 0950 _ 0000000000000000 
        dq 0000000000000000H                            ; 0958 _ 0000000000000000 
        dq 0000000000000000H                            ; 0960 _ 0000000000000000 
        dq 0000000000000000H                            ; 0968 _ 0000000000000000 
        dq 0000000000000000H                            ; 0970 _ 0000000000000000 
        dq 0000000000000000H                            ; 0978 _ 0000000000000000 
        dq 0000000000000000H                            ; 0980 _ 0000000000000000 
        dq 0000000000000000H                            ; 0988 _ 0000000000000000 
        dq 0000000000000000H                            ; 0990 _ 0000000000000000 
        dq 0000000000000000H                            ; 0998 _ 0000000000000000 
        dq 0000000000000000H                            ; 09A0 _ 0000000000000000 
        dq 0000000000000000H                            ; 09A8 _ 0000000000000000 
        dq 0000000000000000H                            ; 09B0 _ 0000000000000000 
        dq 0000000000000000H                            ; 09B8 _ 0000000000000000 
        dq 0000000000000000H                            ; 09C0 _ 0000000000000000 
        dq 0000000000000000H                            ; 09C8 _ 0000000000000000 
        dq 0000000000000000H                            ; 09D0 _ 0000000000000000 
        dq 0000000000000000H                            ; 09D8 _ 0000000000000000 
        dq 0000000000000000H                            ; 09E0 _ 0000000000000000 
        dq 0000000000000000H                            ; 09E8 _ 0000000000000000 
        dq 0000000000000000H                            ; 09F0 _ 0000000000000000 
        dq 0000000000000000H                            ; 09F8 _ 0000000000000000 
        dq 0000000000000000H                            ; 0A00 _ 0000000000000000 
        dq 0000000000000000H                            ; 0A08 _ 0000000000000000 
        dq 0000000000000000H                            ; 0A10 _ 0000000000000000 
        dq 0000000000000000H                            ; 0A18 _ 0000000000000000 
        dq 0000000000000000H                            ; 0A20 _ 0000000000000000 
        dq 0000000000000000H                            ; 0A28 _ 0000000000000000 
        dq 0000000000000000H                            ; 0A30 _ 0000000000000000 
        dq 0000000000000000H                            ; 0A38 _ 0000000000000000 
        dq 0000000000000000H                            ; 0A40 _ 0000000000000000 
        dq 0000000000000000H                            ; 0A48 _ 0000000000000000 
        dq 0000000000000000H                            ; 0A50 _ 0000000000000000 
        dq 0000000000000000H                            ; 0A58 _ 0000000000000000 
        dq 0000000000000000H                            ; 0A60 _ 0000000000000000 
        dq 0000000000000000H                            ; 0A68 _ 0000000000000000 
        dq 0000000000000000H                            ; 0A70 _ 0000000000000000 
        dq 0000000000000000H                            ; 0A78 _ 0000000000000000 
        dq 0000000000000000H                            ; 0A80 _ 0000000000000000 
        dq 0000000000000000H                            ; 0A88 _ 0000000000000000 
        dq 0000000000000000H                            ; 0A90 _ 0000000000000000 
        dq 0000000000000000H                            ; 0A98 _ 0000000000000000 
        dq 0000000000000000H                            ; 0AA0 _ 0000000000000000 
        dq 0000000000000000H                            ; 0AA8 _ 0000000000000000 
        dq 0000000000000000H                            ; 0AB0 _ 0000000000000000 
        dq 0000000000000000H                            ; 0AB8 _ 0000000000000000 
        dq 0000000000000000H                            ; 0AC0 _ 0000000000000000 
        dq 0000000000000000H                            ; 0AC8 _ 0000000000000000 
        dq 0000000000000000H                            ; 0AD0 _ 0000000000000000 
        dq 0000000000000000H                            ; 0AD8 _ 0000000000000000 
        dq 0000000000000000H                            ; 0AE0 _ 0000000000000000 
        dq 0000000000000000H                            ; 0AE8 _ 0000000000000000 
        dq 0000000000000000H                            ; 0AF0 _ 0000000000000000 
        dq 0000000000000000H                            ; 0AF8 _ 0000000000000000 
        dq 0000000000000000H                            ; 0B00 _ 0000000000000000 
        dq 0000000000000000H                            ; 0B08 _ 0000000000000000 
        dq 0000000000000000H                            ; 0B10 _ 0000000000000000 
        dq 0000000000000000H                            ; 0B18 _ 0000000000000000 
        dq 0000000000000000H                            ; 0B20 _ 0000000000000000 
        dq 0000000000000000H                            ; 0B28 _ 0000000000000000 
        dq 0000000000000000H                            ; 0B30 _ 0000000000000000 
        dq 0000000000000000H                            ; 0B38 _ 0000000000000000 
        dq 0000000000000000H                            ; 0B40 _ 0000000000000000 
        dq 0000000000000000H                            ; 0B48 _ 0000000000000000 
        dq 0000000000000000H                            ; 0B50 _ 0000000000000000 
        dq 0000000000000000H                            ; 0B58 _ 0000000000000000 
        dq 0000000000000000H                            ; 0B60 _ 0000000000000000 
        dq 0000000000000000H                            ; 0B68 _ 0000000000000000 
        dq 0000000000000000H                            ; 0B70 _ 0000000000000000 
        dq 0000000000000000H                            ; 0B78 _ 0000000000000000 
        dq 0000000000000000H                            ; 0B80 _ 0000000000000000 
        dq 0000000000000000H                            ; 0B88 _ 0000000000000000 
        dq 0000000000000000H                            ; 0B90 _ 0000000000000000 
        dq 0000000000000000H                            ; 0B98 _ 0000000000000000 
        dq 0000000000000000H                            ; 0BA0 _ 0000000000000000 
        dq 0000000000000000H                            ; 0BA8 _ 0000000000000000 
        dq 0000000000000000H                            ; 0BB0 _ 0000000000000000 
        dq 0000000000000000H                            ; 0BB8 _ 0000000000000000 
        dq 0000000000000000H                            ; 0BC0 _ 0000000000000000 
        dq 0000000000000000H                            ; 0BC8 _ 0000000000000000 
        dq 0000000000000000H                            ; 0BD0 _ 0000000000000000 
        dq 0000000000000000H                            ; 0BD8 _ 0000000000000000 
        dq 0000000000000000H                            ; 0BE0 _ 0000000000000000 
        dq 0000000000000000H                            ; 0BE8 _ 0000000000000000 
        dq 0000000000000000H                            ; 0BF0 _ 0000000000000000 
        dq 0000000000000000H                            ; 0BF8 _ 0000000000000000 
        dq 0000000000000000H                            ; 0C00 _ 0000000000000000 
        dq 0000000000000000H                            ; 0C08 _ 0000000000000000 
        dq 0000000000000000H                            ; 0C10 _ 0000000000000000 
        dq 0000000000000000H                            ; 0C18 _ 0000000000000000 
        dq 0000000000000000H                            ; 0C20 _ 0000000000000000 
        dq 0000000000000000H                            ; 0C28 _ 0000000000000000 
        dq 0000000000000000H                            ; 0C30 _ 0000000000000000 
        dq 0000000000000000H                            ; 0C38 _ 0000000000000000 
        dq 0000000000000000H                            ; 0C40 _ 0000000000000000 
        dq 0000000000000000H                            ; 0C48 _ 0000000000000000 
        dq 0000000000000000H                            ; 0C50 _ 0000000000000000 
        dq 0000000000000000H                            ; 0C58 _ 0000000000000000 
        dq 0000000000000000H                            ; 0C60 _ 0000000000000000 
        dq 0000000000000000H                            ; 0C68 _ 0000000000000000 
        dq 0000000000000000H                            ; 0C70 _ 0000000000000000 
        dq 0000000000000000H                            ; 0C78 _ 0000000000000000 
        dq 0000000000000000H                            ; 0C80 _ 0000000000000000 
        dq 0000000000000000H                            ; 0C88 _ 0000000000000000 
        dq 0000000000000000H                            ; 0C90 _ 0000000000000000 
        dq 0000000000000000H                            ; 0C98 _ 0000000000000000 
        dq 0000000000000000H                            ; 0CA0 _ 0000000000000000 
        dq 0000000000000000H                            ; 0CA8 _ 0000000000000000 
        dq 0000000000000000H                            ; 0CB0 _ 0000000000000000 
        dq 0000000000000000H                            ; 0CB8 _ 0000000000000000 
        dq dump_coment                                  ; 0CC0 _ 0000000000000000 (d)
        dq 0000000000000000H                            ; 0CC8 _ 0000000000000000 
        dq dump_modend                                  ; 0CD0 _ 0000000000000000 (d)
        dq 0000000000000000H                            ; 0CD8 _ 0000000000000000 
        dq dump_extdef                                  ; 0CE0 _ 0000000000000000 (d)
        dq 0000000000000000H                            ; 0CE8 _ 0000000000000000 
        dq 0000000000000000H                            ; 0CF0 _ 0000000000000000 
        dq 0000000000000000H                            ; 0CF8 _ 0000000000000000 
        dq dump_pubdef                                  ; 0D00 _ 0000000000000000 (d)
        dq dump_pubdef                                  ; 0D08 _ 0000000000000000 (d)
        dq 0000000000000000H                            ; 0D10 _ 0000000000000000 
        dq 0000000000000000H                            ; 0D18 _ 0000000000000000 
        dq 0000000000000000H                            ; 0D20 _ 0000000000000000 
        dq 0000000000000000H                            ; 0D28 _ 0000000000000000 
        dq dump_lnames                                  ; 0D30 _ 0000000000000000 (d)
        dq 0000000000000000H                            ; 0D38 _ 0000000000000000 
        dq dump_segdef                                  ; 0D40 _ 0000000000000000 (d)
        dq dump_segdef                                  ; 0D48 _ 0000000000000000 (d)
        dq dump_grpdef                                  ; 0D50 _ 0000000000000000 (d)
        dq 0000000000000000H                            ; 0D58 _ 0000000000000000 
        dq dump_fixupp                                  ; 0D60 _ 0000000000000000 (d)
        dq dump_fixupp                                  ; 0D68 _ 0000000000000000 (d)
        dq 0000000000000000H                            ; 0D70 _ 0000000000000000 
        dq 0000000000000000H                            ; 0D78 _ 0000000000000000 
        dq dump_ledata                                  ; 0D80 _ 0000000000000000 (d)
        dq dump_ledata                                  ; 0D88 _ 0000000000000000 (d)
        dq 0000000000000000H                            ; 0D90 _ 0000000000000000 
        dq 0000000000000000H                            ; 0D98 _ 0000000000000000 
        dq 0000000000000000H                            ; 0DA0 _ 0000000000000000 
        dq 0000000000000000H                            ; 0DA8 _ 0000000000000000 
        dq 0000000000000000H                            ; 0DB0 _ 0000000000000000 
        dq 0000000000000000H                            ; 0DB8 _ 0000000000000000 
        dq 0000000000000000H                            ; 0DC0 _ 0000000000000000 
        dq 0000000000000000H                            ; 0DC8 _ 0000000000000000 
        dq 0000000000000000H                            ; 0DD0 _ 0000000000000000 
        dq 0000000000000000H                            ; 0DD8 _ 0000000000000000 
        dq 0000000000000000H                            ; 0DE0 _ 0000000000000000 
        dq 0000000000000000H                            ; 0DE8 _ 0000000000000000 
        dq 0000000000000000H                            ; 0DF0 _ 0000000000000000 
        dq 0000000000000000H                            ; 0DF8 _ 0000000000000000 
        dq 0000000000000000H                            ; 0E00 _ 0000000000000000 
        dq 0000000000000000H                            ; 0E08 _ 0000000000000000 
        dq 0000000000000000H                            ; 0E10 _ 0000000000000000 
        dq 0000000000000000H                            ; 0E18 _ 0000000000000000 
        dq 0000000000000000H                            ; 0E20 _ 0000000000000000 
        dq 0000000000000000H                            ; 0E28 _ 0000000000000000 
        dq 0000000000000000H                            ; 0E30 _ 0000000000000000 
        dq 0000000000000000H                            ; 0E38 _ 0000000000000000 
        dq 0000000000000000H                            ; 0E40 _ 0000000000000000 
        dq 0000000000000000H                            ; 0E48 _ 0000000000000000 
        dq 0000000000000000H                            ; 0E50 _ 0000000000000000 
        dq 0000000000000000H                            ; 0E58 _ 0000000000000000 
        dq 0000000000000000H                            ; 0E60 _ 0000000000000000 
        dq 0000000000000000H                            ; 0E68 _ 0000000000000000 
        dq 0000000000000000H                            ; 0E70 _ 0000000000000000 
        dq 0000000000000000H                            ; 0E78 _ 0000000000000000 
        dq 0000000000000000H                            ; 0E80 _ 0000000000000000 
        dq 0000000000000000H                            ; 0E88 _ 0000000000000000 
        dq 0000000000000000H                            ; 0E90 _ 0000000000000000 
        dq 0000000000000000H                            ; 0E98 _ 0000000000000000 
        dq 0000000000000000H                            ; 0EA0 _ 0000000000000000 
        dq 0000000000000000H                            ; 0EA8 _ 0000000000000000 
        dq 0000000000000000H                            ; 0EB0 _ 0000000000000000 
        dq 0000000000000000H                            ; 0EB8 _ 0000000000000000 
        dq 0000000000000000H                            ; 0EC0 _ 0000000000000000 
        dq 0000000000000000H                            ; 0EC8 _ 0000000000000000 
        dq dump_lnames                                  ; 0ED0 _ 0000000000000000 (d)
        dq 0000000000000000H                            ; 0ED8 _ 0000000000000000 
        dq 0000000000000000H                            ; 0EE0 _ 0000000000000000 
        dq 0000000000000000H                            ; 0EE8 _ 0000000000000000 
        dq 0000000000000000H                            ; 0EF0 _ 0000000000000000 
        dq 0000000000000000H                            ; 0EF8 _ 0000000000000000 
        dq 0000000000000000H                            ; 0F00 _ 0000000000000000 
        dq 0000000000000000H                            ; 0F08 _ 0000000000000000 
        dq 0000000000000000H                            ; 0F10 _ 0000000000000000 
        dq 0000000000000000H                            ; 0F18 _ 0000000000000000 
        dq 0000000000000000H                            ; 0F20 _ 0000000000000000 
        dq 0000000000000000H                            ; 0F28 _ 0000000000000000 
        dq 0000000000000000H                            ; 0F30 _ 0000000000000000 
        dq 0000000000000000H                            ; 0F38 _ 0000000000000000 
        dq 0000000000000000H                            ; 0F40 _ 0000000000000000 
        dq 0000000000000000H                            ; 0F48 _ 0000000000000000 
        dq 0000000000000000H                            ; 0F50 _ 0000000000000000 
        dq 0000000000000000H                            ; 0F58 _ 0000000000000000 
        dq 0000000000000000H                            ; 0F60 _ 0000000000000000 
        dq 0000000000000000H                            ; 0F68 _ 0000000000000000 
        dq 0000000000000000H                            ; 0F70 _ 0000000000000000 
        dq 0000000000000000H                            ; 0F78 _ 0000000000000000 
        dq 0000000000000000H                            ; 0F80 _ 0000000000000000 
        dq 0000000000000000H                            ; 0F88 _ 0000000000000000 
        dq 0000000000000000H                            ; 0F90 _ 0000000000000000 
        dq 0000000000000000H                            ; 0F98 _ 0000000000000000 
        dq 0000000000000000H                            ; 0FA0 _ 0000000000000000 
        dq 0000000000000000H                            ; 0FA8 _ 0000000000000000 
        dq 0000000000000000H                            ; 0FB0 _ 0000000000000000 
        dq 0000000000000000H                            ; 0FB8 _ 0000000000000000 
        dq 0000000000000000H                            ; 0FC0 _ 0000000000000000 
        dq 0000000000000000H                            ; 0FC8 _ 0000000000000000 
        dq 0000000000000000H                            ; 0FD0 _ 0000000000000000 
        dq 0000000000000000H                            ; 0FD8 _ 0000000000000000 
        dq 0000000000000000H                            ; 0FE0 _ 0000000000000000 
        dq 0000000000000000H                            ; 0FE8 _ 0000000000000000 
        dq 0000000000000000H                            ; 0FF0 _ 0000000000000000 
        dq 0000000000000000H                            ; 0FF8 _ 0000000000000000 
        dq 0000000000000000H                            ; 1000 _ 0000000000000000 
        dq 0000000000000000H                            ; 1008 _ 0000000000000000 
        dq 0000000000000000H                            ; 1010 _ 0000000000000000 
        dq 0000000000000000H                            ; 1018 _ 0000000000000000 
        dq 0000000000000000H                            ; 1020 _ 0000000000000000 
        dq 0000000000000000H                            ; 1028 _ 0000000000000000 
        dq 0000000000000000H                            ; 1030 _ 0000000000000000 
        dq 0000000000000000H                            ; 1038 _ 0000000000000000 
        dq 0000000000000000H                            ; 1040 _ 0000000000000000 
        dq 0000000000000000H                            ; 1048 _ 0000000000000000 
        dq 0000000000000000H                            ; 1050 _ 0000000000000000 
        dq 0000000000000000H                            ; 1058 _ 0000000000000000 
        dq 0000000000000000H                            ; 1060 _ 0000000000000000 
        dq 0000000000000000H                            ; 1068 _ 0000000000000000 
        dq 0000000000000000H                            ; 1070 _ 0000000000000000 
        dq 0000000000000000H                            ; 1078 _ 0000000000000000 

combine.3:                                              ; zword
        dq Unnamed_4_0+79CH                             ; 1080 _ 0000000000000000 (d)
        dq Unnamed_4_0+7A4H                             ; 1088 _ 0000000000000000 (d)
        dq Unnamed_4_0+7ACH                             ; 1090 _ 0000000000000000 (d)
        dq Unnamed_4_0+7B3H                             ; 1098 _ 0000000000000000 (d)
        dq Unnamed_4_0+7BCH                             ; 10A0 _ 0000000000000000 (d)
        dq Unnamed_4_0+7C4H                             ; 10A8 _ 0000000000000000 (d)
        dq Unnamed_4_0+7CAH                             ; 10B0 _ 0000000000000000 (d)
        dq Unnamed_4_0+7BCH                             ; 10B8 _ 0000000000000000 (d)

alignment.2:                                            ; zword
        dq Unnamed_4_0+7D1H                             ; 10C0 _ 0000000000000000 (d)
        dq Unnamed_4_0+7D5H                             ; 10C8 _ 0000000000000000 (d)
        dq Unnamed_4_0+7DAH                             ; 10D0 _ 0000000000000000 (d)
        dq Unnamed_4_0+7DFH                             ; 10D8 _ 0000000000000000 (d)
        dq Unnamed_4_0+7E4H                             ; 10E0 _ 0000000000000000 (d)
        dq Unnamed_4_0+7E9H                             ; 10E8 _ 0000000000000000 (d)
        dq Unnamed_4_0+7EFH                             ; 10F0 _ 0000000000000000 (d)
        dq Unnamed_4_0+7F3H                             ; 10F8 _ 0000000000000000 (d)


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
        dd nulldie-$-20H                                ; 0020 _ 00000000 (rel)
        dd 00000053H, 100E4100H                         ; 0024 _ 83 269369600 
        dd 0D430286H, 0C4E0206H                         ; 002C _ 222495366 206438918 
        dd 00000807H, 0000001CH                         ; 0034 _ 2055 28 
        dd 0000003CH                                    ; 003C _ 60 
        dd nulldie-$+13H                                ; 0040 _ 00000000 (rel)
        dd 00000022H, 100E4100H                         ; 0044 _ 34 269369600 
        dd 0D430286H, 070C5D06H                         ; 004C _ 222495366 118250758 
        dd 00000008H, 0000001CH                         ; 0054 _ 8 28 
        dd 0000005CH                                    ; 005C _ 92 
        dd nulldie-$+15H                                ; 0060 _ 00000000 (rel)
        dd 0000002DH, 100E4100H                         ; 0064 _ 45 269369600 
        dd 0D430286H, 070C6806H                         ; 006C _ 222495366 118253574 
        dd 00000008H, 0000001CH                         ; 0074 _ 8 28 
        dd 0000007CH                                    ; 007C _ 124 
        dd ?_001-$+80H                                  ; 0080 _ 00000000 (rel)
        dd 0000009AH, 100E4100H                         ; 0084 _ 154 269369600 
        dd 0D430286H, 0C950206H                         ; 008C _ 222495366 211091974 
        dd 00000807H, 0000001CH                         ; 0094 _ 2055 28 
        dd 0000009CH                                    ; 009C _ 156 
        dd nulldie-$+9CH                                ; 00A0 _ 00000000 (rel)
        dd 00000068H, 100E4100H                         ; 00A4 _ 104 269369600 
        dd 0D430286H, 0C630206H                         ; 00AC _ 222495366 207815174 
        dd 00000807H, 0000001CH                         ; 00B4 _ 2055 28 
        dd 000000BCH                                    ; 00BC _ 188 
        dd nulldie-$+0E4H                               ; 00C0 _ 00000000 (rel)
        dd 00000046H, 100E4100H                         ; 00C4 _ 70 269369600 
        dd 0D430286H, 0C410206H                         ; 00CC _ 222495366 205586950 
        dd 00000807H, 0000001CH                         ; 00D4 _ 2055 28 
        dd 000000DCH                                    ; 00DC _ 220 
        dd nulldie-$+10AH                               ; 00E0 _ 00000000 (rel)
        dd 0000004FH, 100E4100H                         ; 00E4 _ 79 269369600 
        dd 0D430286H, 0C4A0206H                         ; 00EC _ 222495366 206176774 
        dd 00000807H, 0000001CH                         ; 00F4 _ 2055 28 
        dd 000000FCH                                    ; 00FC _ 252 
        dd nulldie-$+139H                               ; 0100 _ 00000000 (rel)
        dd 000001BBH, 100E4100H                         ; 0104 _ 443 269369600 
        dd 0D430286H, 01B60306H                         ; 010C _ 222495366 28705542 
        dd 0008070CH, 0000001CH                         ; 0114 _ 526092 28 
        dd 0000011CH                                    ; 011C _ 284 
        dd nulldie-$+2D4H                               ; 0120 _ 00000000 (rel)
        dd 00000030H, 100E4100H                         ; 0124 _ 48 269369600 
        dd 0D430286H, 070C6B06H                         ; 012C _ 222495366 118254342 
        dd 00000008H, 0000001CH                         ; 0134 _ 8 28 
        dd 0000013CH                                    ; 013C _ 316 
        dd nulldie-$+2E4H                               ; 0140 _ 00000000 (rel)
        dd 000000C8H, 100E4100H                         ; 0144 _ 200 269369600 
        dd 0D430286H, 0CC30206H                         ; 014C _ 222495366 214106630 
        dd 00000807H, 0000001CH                         ; 0154 _ 2055 28 
        dd 0000015CH                                    ; 015C _ 348 
        dd nulldie-$+38CH                               ; 0160 _ 00000000 (rel)
        dd 00000099H, 100E4100H                         ; 0164 _ 153 269369600 
        dd 0D430286H, 0C940206H                         ; 016C _ 222495366 211026438 
        dd 00000807H, 0000001CH                         ; 0174 _ 2055 28 
        dd 0000017CH                                    ; 017C _ 380 
        dd nulldie-$+405H                               ; 0180 _ 00000000 (rel)
        dd 00000154H, 100E4100H                         ; 0184 _ 340 269369600 
        dd 0D430286H, 014F0306H                         ; 018C _ 222495366 21955334 
        dd 0008070CH, 0000001CH                         ; 0194 _ 526092 28 
        dd 0000019CH                                    ; 019C _ 412 
        dd nulldie-$+539H                               ; 01A0 _ 00000000 (rel)
        dd 00000057H, 100E4100H                         ; 01A4 _ 87 269369600 
        dd 0D430286H, 0C520206H                         ; 01AC _ 222495366 206701062 
        dd 00000807H, 0000001CH                         ; 01B4 _ 2055 28 
        dd 000001BCH                                    ; 01BC _ 444 
        dd nulldie-$+570H                               ; 01C0 _ 00000000 (rel)
        dd 0000002EH, 100E4100H                         ; 01C4 _ 46 269369600 
        dd 0D430286H, 070C6906H                         ; 01CC _ 222495366 118253830 
        dd 00000008H, 0000001CH                         ; 01D4 _ 8 28 
        dd 000001DCH                                    ; 01DC _ 476 
        dd nulldie-$+57EH                               ; 01E0 _ 00000000 (rel)
        dd 0000002BH, 100E4100H                         ; 01E4 _ 43 269369600 
        dd 0D430286H, 070C6606H                         ; 01EC _ 222495366 118253062 
        dd 00000008H, 0000001CH                         ; 01F4 _ 8 28 
        dd 000001FCH                                    ; 01FC _ 508 
        dd nulldie-$+589H                               ; 0200 _ 00000000 (rel)
        dd 0000002BH, 100E4100H                         ; 0204 _ 43 269369600 
        dd 0D430286H, 070C6606H                         ; 020C _ 222495366 118253062 
        dd 00000008H, 0000001CH                         ; 0214 _ 8 28 
        dd 0000021CH                                    ; 021C _ 540 
        dd nulldie-$+594H                               ; 0220 _ 00000000 (rel)
        dd 0000004EH, 100E4100H                         ; 0224 _ 78 269369600 
        dd 0D430286H, 0C490206H                         ; 022C _ 222495366 206111238 
        dd 00000807H, 0000001CH                         ; 0234 _ 2055 28 
        dd 0000023CH                                    ; 023C _ 572 
        dd nulldie-$+5C2H                               ; 0240 _ 00000000 (rel)
        dd 0000004EH, 100E4100H                         ; 0244 _ 78 269369600 
        dd 0D430286H, 0C490206H                         ; 024C _ 222495366 206111238 
        dd 00000807H, 0000001CH                         ; 0254 _ 2055 28 
        dd 0000025CH                                    ; 025C _ 604 
        dd nulldie-$+5F0H                               ; 0260 _ 00000000 (rel)
        dd 0000002BH, 100E4100H                         ; 0264 _ 43 269369600 
        dd 0D430286H, 070C6606H                         ; 026C _ 222495366 118253062 
        dd 00000008H, 0000001CH                         ; 0274 _ 8 28 
        dd 0000027CH                                    ; 027C _ 636 
        dd nulldie-$+5FBH                               ; 0280 _ 00000000 (rel)
        dd 0000016CH, 100E4100H                         ; 0284 _ 364 269369600 
        dd 0D430286H, 01670306H                         ; 028C _ 222495366 23528198 
        dd 0008070CH, 0000001CH                         ; 0294 _ 526092 28 
        dd 0000029CH                                    ; 029C _ 668 
        dd nulldie-$+747H                               ; 02A0 _ 00000000 (rel)
        dd 00000393H, 100E4100H                         ; 02A4 _ 915 269369600 
        dd 0D430286H, 038E0306H                         ; 02AC _ 222495366 59638534 
        dd 0008070CH, 0000001CH                         ; 02B4 _ 526092 28 
        dd 000002BCH                                    ; 02BC _ 700 
        dd nulldie-$+0ABAH                              ; 02C0 _ 00000000 (rel)
        dd 00000194H, 100E4100H                         ; 02C4 _ 404 269369600 
        dd 0D430286H, 018F0306H                         ; 02CC _ 222495366 26149638 
        dd 0008070CH, 0000001CH                         ; 02D4 _ 526092 28 
        dd 000002DCH                                    ; 02DC _ 732 
        dd nulldie-$+0C2EH                              ; 02E0 _ 00000000 (rel)
        dd 0000037CH, 100E4100H                         ; 02E4 _ 892 269369600 
        dd 0D430286H, 03770306H                         ; 02EC _ 222495366 58131206 
        dd 0008070CH, 0000001CH                         ; 02F4 _ 526092 28 
        dd 000002FCH                                    ; 02FC _ 764 
        dd nulldie-$+0F8AH                              ; 0300 _ 00000000 (rel)
        dd 0000026BH, 100E4100H                         ; 0304 _ 619 269369600 
        dd 0D430286H, 02660306H                         ; 030C _ 222495366 40239878 
        dd 0008070CH, 0000001CH                         ; 0314 _ 526092 28 
        dd 0000031CH                                    ; 031C _ 796 
        dd nulldie-$+11D5H                              ; 0320 _ 00000000 (rel)
        dd 00000138H, 100E4100H                         ; 0324 _ 312 269369600 
        dd 0D430286H, 01330306H                         ; 032C _ 222495366 20120326 
        dd 0008070CH, 0000001CH                         ; 0334 _ 526092 28 
        dd 0000033CH                                    ; 033C _ 828 
        dd nulldie-$+12EDH                              ; 0340 _ 00000000 (rel)
        dd 0000025EH, 100E4100H                         ; 0344 _ 606 269369600 
        dd 0D430286H, 02590306H                         ; 034C _ 222495366 39387910 
        dd 0008070CH, 0000001CH                         ; 0354 _ 526092 28 
        dd 0000035CH                                    ; 035C _ 860 
        dd nulldie-$+152BH                              ; 0360 _ 00000000 (rel)
        dd 0000013FH, 100E4100H                         ; 0364 _ 319 269369600 
        dd 0D430286H, 013A0306H                         ; 036C _ 222495366 20579078 
        dd 0008070CH, 0000001CH                         ; 0374 _ 526092 28 
        dd 0000037CH                                    ; 037C _ 892 
        dd nulldie-$+164AH                              ; 0380 _ 00000000 (rel)
        dd 000000BEH, 100E4100H                         ; 0384 _ 190 269369600 
        dd 0D430286H, 0CB90206H                         ; 038C _ 222495366 213451270 
        dd 00000807H, 0000001CH                         ; 0394 _ 2055 28 
        dd 0000039CH                                    ; 039C _ 924 
        dd nulldie-$+16E8H                              ; 03A0 _ 00000000 (rel)
        dd 00000166H, 100E4100H                         ; 03A4 _ 358 269369600 
        dd 0D430286H, 01610306H                         ; 03AC _ 222495366 23134982 
        dd 0008070CH, 0000001CH                         ; 03B4 _ 526092 28 
        dd 000003BCH                                    ; 03BC _ 956 
        dd nulldie-$+182EH                              ; 03C0 _ 00000000 (rel)
        dd 0000026AH, 100E4100H                         ; 03C4 _ 618 269369600 
        dd 0D430286H, 02650306H                         ; 03CC _ 222495366 40174342 
        dd 0008070CH, 0000001CH                         ; 03D4 _ 526092 28 
        dd 000003DCH                                    ; 03DC _ 988 
        dd nulldie-$+1A78H                              ; 03E0 _ 00000000 (rel)
        dd 000000E3H, 100E4100H                         ; 03E4 _ 227 269369600 
        dd 0D430286H, 0CDE0206H                         ; 03EC _ 222495366 215876102 
        dd 00000807H                                    ; 03F4 _ 2055 


