; Disassembly of file: /tmp/tmp.3i7T6TMH9g.o
; Wed Sep 23 14:43:27 2026
; Type: ELF64
; Syntax: NASM
; Instruction set: 80386, x64

default rel

global pp_token_hash: function
global pp_tasm_token_hash: function
global pp_directives_len
global pp_directives

extern strcasecmp                                       ; near
extern crc64i                                           ; near


SECTION .text   align=1 exec                            ; section number 1, code

pp_token_hash:; Function begin
        push    rbp                                     ; 0000 _ 55
        mov     rbp, rsp                                ; 0001 _ 48: 89. E5
        sub     rsp, 48                                 ; 0004 _ 48: 83. EC, 30
        mov     qword [rbp-28H], rdi                    ; 0008 _ 48: 89. 7D, D8
        mov     rax, qword [rbp-28H]                    ; 000C _ 48: 8B. 45, D8
        mov     rdx, qword 76259C3E291C26CH             ; 0010 _ 48: BA, 076259C3E291C26C
        mov     rsi, rax                                ; 001A _ 48: 89. C6
        mov     rdi, rdx                                ; 001D _ 48: 89. D7
        call    crc64i                                  ; 0020 _ E8, 00000000(PLT r)
        mov     qword [rbp-8H], rax                     ; 0025 _ 48: 89. 45, F8
        mov     rax, qword [rbp-8H]                     ; 0029 _ 48: 8B. 45, F8
        and     eax, 1FEH                               ; 002D _ 25, 000001FE
        mov     dword [rbp-10H], eax                    ; 0032 _ 89. 45, F0
        mov     rax, qword [rbp-8H]                     ; 0035 _ 48: 8B. 45, F8
        shr     rax, 32                                 ; 0039 _ 48: C1. E8, 20
        and     eax, 1FEH                               ; 003D _ 25, 000001FE
        add     eax, 1                                  ; 0042 _ 83. C0, 01
        mov     dword [rbp-0CH], eax                    ; 0045 _ 89. 45, F4
        mov     eax, dword [rbp-10H]                    ; 0048 _ 8B. 45, F0
        lea     rdx, [rax+rax]                          ; 004B _ 48: 8D. 14 00
        lea     rax, [rel hashdata.1]                   ; 004F _ 48: 8D. 05, 00000000(rel)
        movzx   eax, word [rdx+rax]                     ; 0056 _ 0F B7. 04 02
        mov     ecx, eax                                ; 005A _ 89. C1
        mov     eax, dword [rbp-0CH]                    ; 005C _ 8B. 45, F4
        lea     rdx, [rax+rax]                          ; 005F _ 48: 8D. 14 00
        lea     rax, [rel hashdata.1]                   ; 0063 _ 48: 8D. 05, 00000000(rel)
        movzx   eax, word [rdx+rax]                     ; 006A _ 0F B7. 04 02
        add     eax, ecx                                ; 006E _ 01. C8
        mov     word [rbp-12H], ax                      ; 0070 _ 66: 89. 45, EE
; Note: Length-changing prefix causes delay on old Intel processors
        cmp     word [rbp-12H], 183                     ; 0074 _ 66: 81. 7D, EE, 00B7
        jbe     ?_001                                   ; 007A _ 76, 07
        mov     eax, 4294967295                         ; 007C _ B8, FFFFFFFF
        jmp     ?_004                                   ; 0081 _ EB, 55

?_001:  movzx   eax, word [rbp-12H]                     ; 0083 _ 0F B7. 45, EE
        cdqe                                            ; 0087 _ 48: 98
        lea     rdx, [rax*8]                            ; 0089 _ 48: 8D. 14 C5, 00000000
        lea     rax, [rel pp_directives]                ; 0091 _ 48: 8D. 05, 00000000(rel)
        mov     rax, qword [rdx+rax]                    ; 0098 _ 48: 8B. 04 02
        test    rax, rax                                ; 009C _ 48: 85. C0
        jz      ?_002                                   ; 009F _ 74, 2C
        movzx   eax, word [rbp-12H]                     ; 00A1 _ 0F B7. 45, EE
        cdqe                                            ; 00A5 _ 48: 98
        lea     rdx, [rax*8]                            ; 00A7 _ 48: 8D. 14 C5, 00000000
        lea     rax, [rel pp_directives]                ; 00AF _ 48: 8D. 05, 00000000(rel)
        mov     rax, qword [rdx+rax]                    ; 00B6 _ 48: 8B. 04 02
        mov     rdx, qword [rbp-28H]                    ; 00BA _ 48: 8B. 55, D8
        mov     rsi, rdx                                ; 00BE _ 48: 89. D6
        mov     rdi, rax                                ; 00C1 _ 48: 89. C7
        call    strcasecmp                              ; 00C4 _ E8, 00000000(PLT r)
        test    eax, eax                                ; 00C9 _ 85. C0
        jz      ?_003                                   ; 00CB _ 74, 07
?_002:  mov     eax, 4294967295                         ; 00CD _ B8, FFFFFFFF
        jmp     ?_004                                   ; 00D2 _ EB, 04

?_003:  movzx   eax, word [rbp-12H]                     ; 00D4 _ 0F B7. 45, EE
?_004:  leave                                           ; 00D8 _ C9
        ret                                             ; 00D9 _ C3
; pp_token_hash End of function

pp_tasm_token_hash:; Function begin
        push    rbp                                     ; 00DA _ 55
        mov     rbp, rsp                                ; 00DB _ 48: 89. E5
        sub     rsp, 48                                 ; 00DE _ 48: 83. EC, 30
        mov     qword [rbp-28H], rdi                    ; 00E2 _ 48: 89. 7D, D8
        mov     rax, qword [rbp-28H]                    ; 00E6 _ 48: 8B. 45, D8
        mov     rdx, qword 76259C3E291C26CH             ; 00EA _ 48: BA, 076259C3E291C26C
        mov     rsi, rax                                ; 00F4 _ 48: 89. C6
        mov     rdi, rdx                                ; 00F7 _ 48: 89. D7
        call    crc64i                                  ; 00FA _ E8, 00000000(PLT r)
        mov     qword [rbp-8H], rax                     ; 00FF _ 48: 89. 45, F8
        mov     rax, qword [rbp-8H]                     ; 0103 _ 48: 8B. 45, F8
        and     eax, 1EH                                ; 0107 _ 83. E0, 1E
        mov     dword [rbp-10H], eax                    ; 010A _ 89. 45, F0
        mov     rax, qword [rbp-8H]                     ; 010D _ 48: 8B. 45, F8
        shr     rax, 32                                 ; 0111 _ 48: C1. E8, 20
        and     eax, 1EH                                ; 0115 _ 83. E0, 1E
        add     eax, 1                                  ; 0118 _ 83. C0, 01
        mov     dword [rbp-0CH], eax                    ; 011B _ 89. 45, F4
        mov     eax, dword [rbp-10H]                    ; 011E _ 8B. 45, F0
        lea     rdx, [rax+rax]                          ; 0121 _ 48: 8D. 14 00
        lea     rax, [rel hashdata.0]                   ; 0125 _ 48: 8D. 05, 00000000(rel)
        movzx   eax, word [rdx+rax]                     ; 012C _ 0F B7. 04 02
        mov     ecx, eax                                ; 0130 _ 89. C1
        mov     eax, dword [rbp-0CH]                    ; 0132 _ 8B. 45, F4
        lea     rdx, [rax+rax]                          ; 0135 _ 48: 8D. 14 00
        lea     rax, [rel hashdata.0]                   ; 0139 _ 48: 8D. 05, 00000000(rel)
        movzx   eax, word [rdx+rax]                     ; 0140 _ 0F B7. 04 02
        add     eax, ecx                                ; 0144 _ 01. C8
        mov     word [rbp-12H], ax                      ; 0146 _ 66: 89. 45, EE
; Note: Length-changing prefix causes delay on old Intel processors
        cmp     word [rbp-12H], 183                     ; 014A _ 66: 81. 7D, EE, 00B7
        jbe     ?_005                                   ; 0150 _ 76, 07
        mov     eax, 4294967295                         ; 0152 _ B8, FFFFFFFF
        jmp     ?_008                                   ; 0157 _ EB, 59

?_005:  movzx   eax, word [rbp-12H]                     ; 0159 _ 0F B7. 45, EE
        cdqe                                            ; 015D _ 48: 98
        lea     rdx, [rax*8]                            ; 015F _ 48: 8D. 14 C5, 00000000
        lea     rax, [rel pp_directives]                ; 0167 _ 48: 8D. 05, 00000000(rel)
        mov     rax, qword [rdx+rax]                    ; 016E _ 48: 8B. 04 02
        test    rax, rax                                ; 0172 _ 48: 85. C0
        jz      ?_006                                   ; 0175 _ 74, 30
        movzx   eax, word [rbp-12H]                     ; 0177 _ 0F B7. 45, EE
        cdqe                                            ; 017B _ 48: 98
        lea     rdx, [rax*8]                            ; 017D _ 48: 8D. 14 C5, 00000000
        lea     rax, [rel pp_directives]                ; 0185 _ 48: 8D. 05, 00000000(rel)
        mov     rax, qword [rdx+rax]                    ; 018C _ 48: 8B. 04 02
        lea     rdx, [rax+1H]                           ; 0190 _ 48: 8D. 50, 01
        mov     rax, qword [rbp-28H]                    ; 0194 _ 48: 8B. 45, D8
        mov     rsi, rax                                ; 0198 _ 48: 89. C6
        mov     rdi, rdx                                ; 019B _ 48: 89. D7
        call    strcasecmp                              ; 019E _ E8, 00000000(PLT r)
        test    eax, eax                                ; 01A3 _ 85. C0
        jz      ?_007                                   ; 01A5 _ 74, 07
?_006:  mov     eax, 4294967295                         ; 01A7 _ B8, FFFFFFFF
        jmp     ?_008                                   ; 01AC _ EB, 04

?_007:  movzx   eax, word [rbp-12H]                     ; 01AE _ 0F B7. 45, EE
?_008:  leave                                           ; 01B2 _ C9
        ret                                             ; 01B3 _ C3
; pp_tasm_token_hash End of function


SECTION .data   align=1 noexec                          ; section number 2, data


SECTION .bss    align=1 noexec                          ; section number 3, bss


SECTION .rodata align=32 noexec                         ; section number 4, const

        db 25H, 69H, 66H, 00H, 25H, 69H, 66H, 63H       ; 0000 _ %if.%ifc
        db 74H, 78H, 00H, 25H, 69H, 66H, 64H, 65H       ; 0008 _ tx.%ifde
        db 66H, 00H, 25H, 69H, 66H, 64H, 65H, 66H       ; 0010 _ f.%ifdef
        db 61H, 6CH, 69H, 61H, 73H, 00H, 25H, 69H       ; 0018 _ alias.%i
        db 66H, 64H, 69H, 66H, 69H, 00H, 25H, 69H       ; 0020 _ fdifi.%i
        db 66H, 64H, 69H, 72H, 65H, 63H, 74H, 69H       ; 0028 _ fdirecti
        db 76H, 65H, 00H, 25H, 69H, 66H, 65H, 6DH       ; 0030 _ ve.%ifem
        db 70H, 74H, 79H, 00H, 25H, 69H, 66H, 65H       ; 0038 _ pty.%ife
        db 6EH, 76H, 00H, 25H, 69H, 66H, 66H, 69H       ; 0040 _ nv.%iffi
        db 6CH, 65H, 00H, 25H, 69H, 66H, 69H, 64H       ; 0048 _ le.%ifid
        db 00H, 25H, 69H, 66H, 69H, 64H, 6EH, 00H       ; 0050 _ .%ifidn.
        db 25H, 69H, 66H, 69H, 64H, 6EH, 69H, 00H       ; 0058 _ %ifidni.
        db 25H, 69H, 66H, 6DH, 61H, 63H, 72H, 6FH       ; 0060 _ %ifmacro
        db 00H, 25H, 69H, 66H, 6EH, 75H, 6DH, 00H       ; 0068 _ .%ifnum.
        db 25H, 69H, 66H, 73H, 74H, 72H, 00H, 25H       ; 0070 _ %ifstr.%
        db 69H, 66H, 74H, 6FH, 6BH, 65H, 6EH, 00H       ; 0078 _ iftoken.
        db 25H, 69H, 66H, 75H, 73H, 61H, 62H, 6CH       ; 0080 _ %ifusabl
        db 65H, 00H, 25H, 69H, 66H, 75H, 73H, 69H       ; 0088 _ e.%ifusi
        db 6EH, 67H, 00H, 25H, 69H, 66H, 6EH, 00H       ; 0090 _ ng.%ifn.
        db 25H, 69H, 66H, 6EH, 63H, 74H, 78H, 00H       ; 0098 _ %ifnctx.
        db 25H, 69H, 66H, 6EH, 64H, 65H, 66H, 00H       ; 00A0 _ %ifndef.
        db 25H, 69H, 66H, 6EH, 64H, 65H, 66H, 61H       ; 00A8 _ %ifndefa
        db 6CH, 69H, 61H, 73H, 00H, 25H, 69H, 66H       ; 00B0 _ lias.%if
        db 6EH, 64H, 69H, 66H, 69H, 00H, 25H, 69H       ; 00B8 _ ndifi.%i
        db 66H, 6EH, 64H, 69H, 72H, 65H, 63H, 74H       ; 00C0 _ fndirect
        db 69H, 76H, 65H, 00H, 25H, 69H, 66H, 6EH       ; 00C8 _ ive.%ifn
        db 65H, 6DH, 70H, 74H, 79H, 00H, 25H, 69H       ; 00D0 _ empty.%i
        db 66H, 6EH, 65H, 6EH, 76H, 00H, 25H, 69H       ; 00D8 _ fnenv.%i
        db 66H, 6EH, 66H, 69H, 6CH, 65H, 00H, 25H       ; 00E0 _ fnfile.%
        db 69H, 66H, 6EH, 69H, 64H, 00H, 25H, 69H       ; 00E8 _ ifnid.%i
        db 66H, 6EH, 69H, 64H, 6EH, 00H, 25H, 69H       ; 00F0 _ fnidn.%i
        db 66H, 6EH, 69H, 64H, 6EH, 69H, 00H, 25H       ; 00F8 _ fnidni.%
        db 69H, 66H, 6EH, 6DH, 61H, 63H, 72H, 6FH       ; 0100 _ ifnmacro
        db 00H, 25H, 69H, 66H, 6EH, 6EH, 75H, 6DH       ; 0108 _ .%ifnnum
        db 00H, 25H, 69H, 66H, 6EH, 73H, 74H, 72H       ; 0110 _ .%ifnstr
        db 00H, 25H, 69H, 66H, 6EH, 74H, 6FH, 6BH       ; 0118 _ .%ifntok
        db 65H, 6EH, 00H, 25H, 69H, 66H, 6EH, 75H       ; 0120 _ en.%ifnu
        db 73H, 61H, 62H, 6CH, 65H, 00H, 25H, 69H       ; 0128 _ sable.%i
        db 66H, 6EH, 75H, 73H, 69H, 6EH, 67H, 00H       ; 0130 _ fnusing.
        db 25H, 65H, 6CH, 69H, 66H, 00H, 25H, 65H       ; 0138 _ %elif.%e
        db 6CH, 69H, 66H, 63H, 74H, 78H, 00H, 25H       ; 0140 _ lifctx.%
        db 65H, 6CH, 69H, 66H, 64H, 65H, 66H, 00H       ; 0148 _ elifdef.
        db 25H, 65H, 6CH, 69H, 66H, 64H, 65H, 66H       ; 0150 _ %elifdef
        db 61H, 6CH, 69H, 61H, 73H, 00H, 25H, 65H       ; 0158 _ alias.%e
        db 6CH, 69H, 66H, 64H, 69H, 66H, 69H, 00H       ; 0160 _ lifdifi.
        db 25H, 65H, 6CH, 69H, 66H, 64H, 69H, 72H       ; 0168 _ %elifdir
        db 65H, 63H, 74H, 69H, 76H, 65H, 00H, 25H       ; 0170 _ ective.%
        db 65H, 6CH, 69H, 66H, 65H, 6DH, 70H, 74H       ; 0178 _ elifempt
        db 79H, 00H, 25H, 65H, 6CH, 69H, 66H, 65H       ; 0180 _ y.%elife
        db 6EH, 76H, 00H, 25H, 65H, 6CH, 69H, 66H       ; 0188 _ nv.%elif
        db 66H, 69H, 6CH, 65H, 00H, 25H, 65H, 6CH       ; 0190 _ file.%el
        db 69H, 66H, 69H, 64H, 00H, 25H, 65H, 6CH       ; 0198 _ ifid.%el
        db 69H, 66H, 69H, 64H, 6EH, 00H, 25H, 65H       ; 01A0 _ ifidn.%e
        db 6CH, 69H, 66H, 69H, 64H, 6EH, 69H, 00H       ; 01A8 _ lifidni.
        db 25H, 65H, 6CH, 69H, 66H, 6DH, 61H, 63H       ; 01B0 _ %elifmac
        db 72H, 6FH, 00H, 25H, 65H, 6CH, 69H, 66H       ; 01B8 _ ro.%elif
        db 6EH, 75H, 6DH, 00H, 25H, 65H, 6CH, 69H       ; 01C0 _ num.%eli
        db 66H, 73H, 74H, 72H, 00H, 25H, 65H, 6CH       ; 01C8 _ fstr.%el
        db 69H, 66H, 74H, 6FH, 6BH, 65H, 6EH, 00H       ; 01D0 _ iftoken.
        db 25H, 65H, 6CH, 69H, 66H, 75H, 73H, 61H       ; 01D8 _ %elifusa
        db 62H, 6CH, 65H, 00H, 25H, 65H, 6CH, 69H       ; 01E0 _ ble.%eli
        db 66H, 75H, 73H, 69H, 6EH, 67H, 00H, 25H       ; 01E8 _ fusing.%
        db 65H, 6CH, 69H, 66H, 6EH, 00H, 25H, 65H       ; 01F0 _ elifn.%e
        db 6CH, 69H, 66H, 6EH, 63H, 74H, 78H, 00H       ; 01F8 _ lifnctx.
        db 25H, 65H, 6CH, 69H, 66H, 6EH, 64H, 65H       ; 0200 _ %elifnde
        db 66H, 00H, 25H, 65H, 6CH, 69H, 66H, 6EH       ; 0208 _ f.%elifn
        db 64H, 65H, 66H, 61H, 6CH, 69H, 61H, 73H       ; 0210 _ defalias
        db 00H, 25H, 65H, 6CH, 69H, 66H, 6EH, 64H       ; 0218 _ .%elifnd
        db 69H, 66H, 69H, 00H, 25H, 65H, 6CH, 69H       ; 0220 _ ifi.%eli
        db 66H, 6EH, 64H, 69H, 72H, 65H, 63H, 74H       ; 0228 _ fndirect
        db 69H, 76H, 65H, 00H, 25H, 65H, 6CH, 69H       ; 0230 _ ive.%eli
        db 66H, 6EH, 65H, 6DH, 70H, 74H, 79H, 00H       ; 0238 _ fnempty.
        db 25H, 65H, 6CH, 69H, 66H, 6EH, 65H, 6EH       ; 0240 _ %elifnen
        db 76H, 00H, 25H, 65H, 6CH, 69H, 66H, 6EH       ; 0248 _ v.%elifn
        db 66H, 69H, 6CH, 65H, 00H, 25H, 65H, 6CH       ; 0250 _ file.%el
        db 69H, 66H, 6EH, 69H, 64H, 00H, 25H, 65H       ; 0258 _ ifnid.%e
        db 6CH, 69H, 66H, 6EH, 69H, 64H, 6EH, 00H       ; 0260 _ lifnidn.
        db 25H, 65H, 6CH, 69H, 66H, 6EH, 69H, 64H       ; 0268 _ %elifnid
        db 6EH, 69H, 00H, 25H, 65H, 6CH, 69H, 66H       ; 0270 _ ni.%elif
        db 6EH, 6DH, 61H, 63H, 72H, 6FH, 00H, 25H       ; 0278 _ nmacro.%
        db 65H, 6CH, 69H, 66H, 6EH, 6EH, 75H, 6DH       ; 0280 _ elifnnum
        db 00H, 25H, 65H, 6CH, 69H, 66H, 6EH, 73H       ; 0288 _ .%elifns
        db 74H, 72H, 00H, 25H, 65H, 6CH, 69H, 66H       ; 0290 _ tr.%elif
        db 6EH, 74H, 6FH, 6BH, 65H, 6EH, 00H, 25H       ; 0298 _ ntoken.%
        db 65H, 6CH, 69H, 66H, 6EH, 75H, 73H, 61H       ; 02A0 _ elifnusa
        db 62H, 6CH, 65H, 00H, 25H, 65H, 6CH, 69H       ; 02A8 _ ble.%eli
        db 66H, 6EH, 75H, 73H, 69H, 6EH, 67H, 00H       ; 02B0 _ fnusing.
        db 25H, 61H, 6CH, 69H, 61H, 73H, 65H, 73H       ; 02B8 _ %aliases
        db 00H, 25H, 61H, 72H, 67H, 00H, 25H, 63H       ; 02C0 _ .%arg.%c
        db 6CH, 65H, 61H, 72H, 00H, 25H, 64H, 65H       ; 02C8 _ lear.%de
        db 70H, 65H, 6EH, 64H, 00H, 25H, 65H, 6CH       ; 02D0 _ pend.%el
        db 73H, 65H, 00H, 25H, 65H, 6EH, 64H, 69H       ; 02D8 _ se.%endi
        db 66H, 00H, 25H, 65H, 6EH, 64H, 6DH, 00H       ; 02E0 _ f.%endm.
        db 25H, 65H, 6EH, 64H, 6DH, 61H, 63H, 72H       ; 02E8 _ %endmacr
        db 6FH, 00H, 25H, 65H, 6EH, 64H, 72H, 65H       ; 02F0 _ o.%endre
        db 70H, 00H, 25H, 65H, 72H, 72H, 6FH, 72H       ; 02F8 _ p.%error
        db 00H, 25H, 65H, 78H, 69H, 74H, 6DH, 61H       ; 0300 _ .%exitma
        db 63H, 72H, 6FH, 00H, 25H, 65H, 78H, 69H       ; 0308 _ cro.%exi
        db 74H, 72H, 65H, 70H, 00H, 25H, 66H, 61H       ; 0310 _ trep.%fa
        db 74H, 61H, 6CH, 00H, 25H, 69H, 6EH, 63H       ; 0318 _ tal.%inc
        db 6CH, 75H, 64H, 65H, 00H, 25H, 6CH, 69H       ; 0320 _ lude.%li
        db 6EH, 65H, 00H, 25H, 6CH, 6FH, 63H, 61H       ; 0328 _ ne.%loca
        db 6CH, 00H, 25H, 6EH, 6FH, 74H, 65H, 00H       ; 0330 _ l.%note.
        db 25H, 6EH, 75H, 6CH, 6CH, 00H, 25H, 70H       ; 0338 _ %null.%p
        db 6FH, 70H, 00H, 25H, 70H, 72H, 61H, 67H       ; 0340 _ op.%prag
        db 6DH, 61H, 00H, 25H, 70H, 75H, 73H, 68H       ; 0348 _ ma.%push
        db 00H, 25H, 72H, 65H, 70H, 00H, 25H, 72H       ; 0350 _ .%rep.%r
        db 65H, 70H, 6CH, 00H, 25H, 72H, 65H, 71H       ; 0358 _ epl.%req
        db 75H, 69H, 72H, 65H, 00H, 25H, 72H, 6FH       ; 0360 _ uire.%ro
        db 74H, 61H, 74H, 65H, 00H, 25H, 73H, 74H       ; 0368 _ tate.%st
        db 61H, 63H, 6BH, 73H, 69H, 7AH, 65H, 00H       ; 0370 _ acksize.
        db 25H, 75H, 6EH, 64H, 65H, 66H, 00H, 25H       ; 0378 _ %undef.%
        db 75H, 6EH, 64H, 65H, 66H, 61H, 6CH, 69H       ; 0380 _ undefali
        db 61H, 73H, 00H, 25H, 75H, 73H, 65H, 00H       ; 0388 _ as.%use.
        db 25H, 77H, 61H, 72H, 6EH, 69H, 6EH, 67H       ; 0390 _ %warning
        db 00H, 25H, 61H, 73H, 73H, 69H, 67H, 6EH       ; 0398 _ .%assign
        db 00H, 25H, 69H, 61H, 73H, 73H, 69H, 67H       ; 03A0 _ .%iassig
        db 6EH, 00H, 25H, 64H, 65H, 66H, 61H, 6CH       ; 03A8 _ n.%defal
        db 69H, 61H, 73H, 00H, 25H, 69H, 64H, 65H       ; 03B0 _ ias.%ide
        db 66H, 61H, 6CH, 69H, 61H, 73H, 00H, 25H       ; 03B8 _ falias.%
        db 64H, 65H, 66H, 69H, 6EH, 65H, 00H, 25H       ; 03C0 _ define.%
        db 69H, 64H, 65H, 66H, 69H, 6EH, 65H, 00H       ; 03C8 _ idefine.
        db 25H, 64H, 65H, 66H, 73H, 74H, 72H, 00H       ; 03D0 _ %defstr.
        db 25H, 69H, 64H, 65H, 66H, 73H, 74H, 72H       ; 03D8 _ %idefstr
        db 00H, 25H, 64H, 65H, 66H, 74H, 6FH, 6BH       ; 03E0 _ .%deftok
        db 00H, 25H, 69H, 64H, 65H, 66H, 74H, 6FH       ; 03E8 _ .%idefto
        db 6BH, 00H, 25H, 6DH, 61H, 63H, 72H, 6FH       ; 03F0 _ k.%macro
        db 00H, 25H, 69H, 6DH, 61H, 63H, 72H, 6FH       ; 03F8 _ .%imacro
        db 00H, 25H, 70H, 61H, 74H, 68H, 73H, 65H       ; 0400 _ .%pathse
        db 61H, 72H, 63H, 68H, 00H, 25H, 69H, 70H       ; 0408 _ arch.%ip
        db 61H, 74H, 68H, 73H, 65H, 61H, 72H, 63H       ; 0410 _ athsearc
        db 68H, 00H, 25H, 72H, 6DH, 61H, 63H, 72H       ; 0418 _ h.%rmacr
        db 6FH, 00H, 25H, 69H, 72H, 6DH, 61H, 63H       ; 0420 _ o.%irmac
        db 72H, 6FH, 00H, 25H, 73H, 74H, 72H, 63H       ; 0428 _ ro.%strc
        db 61H, 74H, 00H, 25H, 69H, 73H, 74H, 72H       ; 0430 _ at.%istr
        db 63H, 61H, 74H, 00H, 25H, 73H, 74H, 72H       ; 0438 _ cat.%str
        db 6CH, 65H, 6EH, 00H, 25H, 69H, 73H, 74H       ; 0440 _ len.%ist
        db 72H, 6CH, 65H, 6EH, 00H, 25H, 73H, 75H       ; 0448 _ rlen.%su
        db 62H, 73H, 74H, 72H, 00H, 25H, 69H, 73H       ; 0450 _ bstr.%is
        db 75H, 62H, 73H, 74H, 72H, 00H, 25H, 78H       ; 0458 _ ubstr.%x
        db 64H, 65H, 66H, 69H, 6EH, 65H, 00H, 25H       ; 0460 _ define.%
        db 69H, 78H, 64H, 65H, 66H, 69H, 6EH, 65H       ; 0468 _ ixdefine
        db 00H, 25H, 75H, 6EH, 6DH, 61H, 63H, 72H       ; 0470 _ .%unmacr
        db 6FH, 00H, 25H, 75H, 6EH, 69H, 6DH, 61H       ; 0478 _ o.%unima
        db 63H, 72H, 6FH, 00H, 00H, 00H, 00H, 00H       ; 0480 _ cro.....
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0488 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0490 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0498 _ ........

pp_directives_len:                                      ; byte
        db 03H, 09H, 06H, 06H, 0BH, 07H, 0CH, 08H       ; 04A0 _ ........
        db 06H, 07H, 05H, 06H, 07H, 08H, 06H, 06H       ; 04A8 _ ........
        db 08H, 09H, 08H, 0BH, 0BH, 0BH, 0BH, 0BH       ; 04B0 _ ........
        db 0BH, 0BH, 0BH, 0BH, 0BH, 0BH, 0BH, 0BH       ; 04B8 _ ........
        db 04H, 0AH, 07H, 07H, 0CH, 08H, 0DH, 09H       ; 04C0 _ ........
        db 07H, 08H, 06H, 07H, 08H, 09H, 07H, 07H       ; 04C8 _ ........
        db 09H, 0AH, 09H, 0CH, 0CH, 0CH, 0CH, 0CH       ; 04D0 _ ........
        db 0CH, 0CH, 0CH, 0CH, 0CH, 0CH, 0CH, 0CH       ; 04D8 _ ........
        db 05H, 0BH, 08H, 08H, 0DH, 09H, 0EH, 0AH       ; 04E0 _ ........
        db 08H, 09H, 07H, 08H, 09H, 0AH, 08H, 08H       ; 04E8 _ ........
        db 0AH, 0BH, 0AH, 0DH, 0DH, 0DH, 0DH, 0DH       ; 04F0 _ ........
        db 0DH, 0DH, 0DH, 0DH, 0DH, 0DH, 0DH, 0DH       ; 04F8 _ ........
        db 06H, 0CH, 09H, 09H, 0EH, 0AH, 0FH, 0BH       ; 0500 _ ........
        db 09H, 0AH, 08H, 09H, 0AH, 0BH, 09H, 09H       ; 0508 _ ........
        db 0BH, 0CH, 0BH, 0EH, 0EH, 0EH, 0EH, 0EH       ; 0510 _ ........
        db 0EH, 0EH, 0EH, 0EH, 0EH, 0EH, 0EH, 0EH       ; 0518 _ ........
        db 08H, 04H, 06H, 07H, 05H, 06H, 05H, 09H       ; 0520 _ ........
        db 07H, 06H, 0AH, 08H, 06H, 08H, 05H, 06H       ; 0528 _ ........
        db 05H, 05H, 04H, 07H, 05H, 04H, 05H, 08H       ; 0530 _ ........
        db 07H, 0AH, 06H, 0BH, 04H, 08H, 07H, 08H       ; 0538 _ ........
        db 09H, 0AH, 07H, 08H, 07H, 08H, 07H, 08H       ; 0540 _ ........
        db 06H, 07H, 0BH, 0CH, 07H, 08H, 07H, 08H       ; 0548 _ ........
        db 07H, 08H, 07H, 08H, 08H, 09H, 08H, 09H       ; 0550 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0558 _ ........

hashdata.1:                                             ; byte
        db 00H, 00H, 55H, 55H, 00H, 00H, 55H, 55H       ; 0560 _ ..UU..UU
        db 00H, 00H, 00H, 00H, 00H, 00H, 55H, 55H       ; 0568 _ ......UU
        db 55H, 55H, 00H, 00H, 55H, 55H, 55H, 55H       ; 0570 _ UU..UUUU
        db 55H, 55H, 55H, 55H, 00H, 00H, 00H, 00H       ; 0578 _ UUUU....
        db 55H, 55H, 55H, 55H, 55H, 55H, 55H, 55H       ; 0580 _ UUUUUUUU
        db 55H, 55H, 55H, 55H, 00H, 00H, 0ABH, 00H      ; 0588 _ UUUU....
        db 55H, 55H, 55H, 55H, 55H, 55H, 55H, 55H       ; 0590 _ UUUUUUUU
        db 00H, 00H, 00H, 00H, 55H, 55H, 55H, 55H       ; 0598 _ ....UUUU
        db 55H, 55H, 0ABH, 00H, 00H, 00H, 00H, 00H      ; 05A0 _ UU......
        db 55H, 55H, 00H, 00H, 55H, 55H, 00H, 00H       ; 05A8 _ UU..UU..
        db 00H, 00H, 55H, 55H, 55H, 55H, 55H, 55H       ; 05B0 _ ..UUUUUU
        db 55H, 55H, 55H, 55H, 55H, 55H, 55H, 55H       ; 05B8 _ UUUUUUUU
        db 55H, 55H, 55H, 55H, 55H, 55H, 00H, 00H       ; 05C0 _ UUUUUU..
        db 55H, 55H, 55H, 55H, 55H, 55H, 55H, 55H       ; 05C8 _ UUUUUUUU
        db 55H, 55H, 55H, 55H, 83H, 00H, 55H, 55H       ; 05D0 _ UUUU..UU
        db 00H, 00H, 55H, 55H, 55H, 55H, 55H, 55H       ; 05D8 _ ..UUUUUU
        db 00H, 00H, 55H, 55H, 55H, 55H, 55H, 55H       ; 05E0 _ ..UUUUUU
        db 00H, 00H, 00H, 00H, 55H, 55H, 55H, 55H       ; 05E8 _ ....UUUU
        db 55H, 55H, 55H, 55H, 00H, 00H, 55H, 55H       ; 05F0 _ UUUU..UU
        db 55H, 55H, 81H, 00H, 60H, 0FFH, 55H, 55H      ; 05F8 _ UU..`.UU
        db 55H, 55H, 55H, 55H, 00H, 00H, 55H, 55H       ; 0600 _ UUUU..UU
        db 9EH, 00H, 00H, 00H, 55H, 55H, 55H, 55H       ; 0608 _ ....UUUU
        db 55H, 55H, 55H, 55H, 55H, 55H, 32H, 00H       ; 0610 _ UUUUUU2.
        db 55H, 55H, 55H, 55H, 00H, 00H, 55H, 55H       ; 0618 _ UUUU..UU
        db 55H, 55H, 00H, 00H, 55H, 55H, 00H, 00H       ; 0620 _ UU..UU..
        db 00H, 00H, 55H, 55H, 55H, 55H, 00H, 00H       ; 0628 _ ..UUUU..
        db 48H, 00H, 00H, 00H, 55H, 55H, 55H, 55H       ; 0630 _ H...UUUU
        db 00H, 00H, 00H, 00H, 55H, 55H, 00H, 00H       ; 0638 _ ....UU..
        db 55H, 55H, 55H, 55H, 55H, 55H, 55H, 55H       ; 0640 _ UUUUUUUU
        db 55H, 55H, 55H, 55H, 00H, 00H, 00H, 00H       ; 0648 _ UUUU....
        db 55H, 55H, 55H, 55H, 55H, 55H, 55H, 55H       ; 0650 _ UUUUUUUU
        db 00H, 00H, 55H, 55H, 55H, 55H, 8EH, 00H       ; 0658 _ ..UUUU..
        db 00H, 00H, 55H, 55H, 00H, 00H, 55H, 55H       ; 0660 _ ..UU..UU
        db 55H, 55H, 55H, 55H, 00H, 00H, 00H, 00H       ; 0668 _ UUUU....
        db 55H, 55H, 00H, 00H, 55H, 55H, 00H, 00H       ; 0670 _ UU..UU..
        db 68H, 00H, 86H, 00H, 55H, 55H, 0DH, 00H       ; 0678 _ h...UU..
        db 27H, 00H, 00H, 00H, 00H, 00H, 04H, 00H       ; 0680 _ '.......
        db 55H, 55H, 55H, 55H, 91H, 00H, 55H, 55H       ; 0688 _ UUUU..UU
        db 00H, 00H, 55H, 55H, 55H, 55H, 55H, 55H       ; 0690 _ ..UUUUUU
        db 55H, 55H, 62H, 00H, 55H, 55H, 55H, 55H       ; 0698 _ UUb.UUUU
        db 55H, 55H, 00H, 00H, 55H, 55H, 55H, 55H       ; 06A0 _ UU..UUUU
        db 75H, 0FFH, 55H, 55H, 55H, 55H, 00H, 00H      ; 06A8 _ u.UUUU..
        db 55H, 55H, 30H, 00H, 55H, 55H, 55H, 55H       ; 06B0 _ UU0.UUUU
        db 55H, 55H, 6BH, 00H, 55H, 55H, 52H, 00H       ; 06B8 _ UUk.UUR.
        db 55H, 55H, 47H, 00H, 00H, 00H, 55H, 55H       ; 06C0 _ UUG...UU
        db 25H, 00H, 00H, 00H, 00H, 00H, 0DCH, 0FFH     ; 06C8 _ %.......
        db 55H, 55H, 55H, 55H, 55H, 55H, 07H, 00H       ; 06D0 _ UUUUUU..
        db 75H, 0FFH, 55H, 55H, 55H, 55H, 55H, 55H      ; 06D8 _ u.UUUUUU
        db 55H, 55H, 00H, 00H, 55H, 55H, 0B4H, 00H      ; 06E0 _ UU..UU..
        db 55H, 55H, 55H, 55H, 0A2H, 0FFH, 4AH, 00H     ; 06E8 _ UUUU..J.
        db 55H, 55H, 88H, 00H, 55H, 55H, 00H, 00H       ; 06F0 _ UU..UU..
        db 00H, 00H, 31H, 01H, 99H, 0FFH, 55H, 55H      ; 06F8 _ ..1...UU
        db 55H, 55H, 55H, 55H, 55H, 55H, 55H, 55H       ; 0700 _ UUUUUUUU
        db 55H, 55H, 2DH, 00H, 00H, 00H, 0CAH, 0FFH     ; 0708 _ UU-.....
        db 55H, 55H, 55H, 55H, 55H, 55H, 00H, 00H       ; 0710 _ UUUUUU..
        db 0A9H, 0FFH, 00H, 00H, 55H, 55H, 55H, 55H     ; 0718 _ ....UUUU
        db 55H, 55H, 55H, 55H, 55H, 55H, 55H, 55H       ; 0720 _ UUUUUUUU
        db 00H, 00H, 55H, 55H, 55H, 55H, 55H, 55H       ; 0728 _ ..UUUUUU
        db 55H, 55H, 55H, 55H, 55H, 55H, 00H, 00H       ; 0730 _ UUUUUU..
        db 28H, 00H, 55H, 55H, 55H, 55H, 55H, 55H       ; 0738 _ (.UUUUUU
        db 55H, 55H, 00H, 00H, 55H, 55H, 55H, 55H       ; 0740 _ UU..UUUU
        db 55H, 55H, 00H, 00H, 55H, 55H, 55H, 55H       ; 0748 _ UU..UUUU
        db 55H, 55H, 00H, 00H, 55H, 55H, 55H, 55H       ; 0750 _ UU..UUUU
        db 55H, 55H, 55H, 55H, 00H, 00H, 55H, 55H       ; 0758 _ UUUU..UU
        db 00H, 00H, 55H, 55H, 55H, 55H, 55H, 55H       ; 0760 _ ..UUUUUU
        db 00H, 00H, 00H, 00H, 55H, 55H, 0A2H, 00H      ; 0768 _ ....UU..
        db 00H, 00H, 87H, 00H, 55H, 55H, 67H, 00H       ; 0770 _ ....UUg.
        db 00H, 00H, 55H, 55H, 55H, 55H, 55H, 55H       ; 0778 _ ..UUUUUU
        db 55H, 55H, 55H, 55H, 55H, 55H, 8CH, 00H       ; 0780 _ UUUUUU..
        db 55H, 55H, 72H, 00H, 55H, 55H, 55H, 55H       ; 0788 _ UUr.UUUU
        db 25H, 00H, 55H, 55H, 0A3H, 00H, 55H, 55H      ; 0790 _ %.UU..UU
        db 11H, 00H, 06H, 00H, 0D9H, 0FFH, 0ABH, 00H    ; 0798 _ ........
        db 55H, 55H, 55H, 55H, 55H, 55H, 55H, 55H       ; 07A0 _ UUUUUUUU
        db 55H, 55H, 33H, 01H, 55H, 55H, 55H, 55H       ; 07A8 _ UU3.UUUU
        db 48H, 00H, 00H, 00H, 55H, 55H, 55H, 55H       ; 07B0 _ H...UUUU
        db 6EH, 00H, 55H, 55H, 55H, 55H, 00H, 00H       ; 07B8 _ n.UUUU..
        db 55H, 55H, 55H, 55H, 55H, 55H, 55H, 55H       ; 07C0 _ UUUUUUUU
        db 55H, 55H, 55H, 55H, 0B5H, 00H, 55H, 55H      ; 07C8 _ UUUU..UU
        db 55H, 55H, 55H, 55H, 55H, 55H, 55H, 55H       ; 07D0 _ UUUUUUUU
        db 24H, 00H, 55H, 55H, 20H, 00H, 55H, 55H       ; 07D8 _ $.UU .UU
        db 55H, 55H, 0A9H, 00H, 55H, 55H, 23H, 00H      ; 07E0 _ UU..UU#.
        db 0A1H, 0FFH, 55H, 55H, 55H, 55H, 0B9H, 00H    ; 07E8 _ ..UUUU..
        db 0BH, 00H, 55H, 55H, 55H, 55H, 55H, 55H       ; 07F0 _ ..UUUUUU
        db 0ADH, 00H, 55H, 55H, 05H, 00H, 55H, 55H      ; 07F8 _ ..UU..UU
        db 55H, 55H, 55H, 55H, 9EH, 00H, 55H, 55H       ; 0800 _ UUUU..UU
        db 55H, 55H, 55H, 55H, 55H, 55H, 55H, 55H       ; 0808 _ UUUUUUUU
        db 55H, 55H, 0CBH, 0FFH, 55H, 55H, 55H, 55H     ; 0810 _ UU..UUUU
        db 55H, 55H, 00H, 00H, 55H, 55H, 55H, 55H       ; 0818 _ UU..UUUU
        db 96H, 00H, 55H, 55H, 78H, 00H, 55H, 55H       ; 0820 _ ..UUx.UU
        db 55H, 55H, 00H, 00H, 55H, 55H, 55H, 55H       ; 0828 _ UU..UUUU
        db 55H, 55H, 00H, 00H, 40H, 00H, 00H, 00H       ; 0830 _ UU..@...
        db 6FH, 00H, 55H, 55H, 55H, 55H, 55H, 55H       ; 0838 _ o.UUUUUU
        db 66H, 00H, 00H, 00H, 55H, 55H, 00H, 00H       ; 0840 _ f...UU..
        db 55H, 55H, 55H, 55H, 55H, 55H, 0E6H, 0FFH     ; 0848 _ UUUUUU..
        db 0A8H, 00H, 81H, 00H, 55H, 55H, 0B1H, 00H     ; 0850 _ ....UU..
        db 55H, 55H, 55H, 55H, 55H, 55H, 2FH, 00H       ; 0858 _ UUUUUU/.
        db 0B0H, 00H, 6DH, 00H, 55H, 55H, 01H, 00H      ; 0860 _ ..m.UU..
        db 71H, 00H, 46H, 00H, 63H, 00H, 2BH, 00H       ; 0868 _ q.F.c.+.
        db 4FH, 00H, 55H, 55H, 51H, 00H, 55H, 55H       ; 0870 _ O.UUQ.UU
        db 55H, 55H, 9BH, 00H, 0A7H, 0FFH, 55H, 55H     ; 0878 _ UU....UU
        db 55H, 55H, 55H, 55H, 55H, 55H, 55H, 55H       ; 0880 _ UUUUUUUU
        db 55H, 55H, 55H, 55H, 55H, 55H, 55H, 55H       ; 0888 _ UUUUUUUU
        db 64H, 00H, 0E3H, 0FFH, 94H, 00H, 6DH, 00H     ; 0890 _ d.....m.
        db 55H, 55H, 4BH, 00H, 55H, 55H, 0C3H, 00H      ; 0898 _ UUK.UU..
        db 0D9H, 0FFH, 55H, 55H, 0A7H, 00H, 28H, 00H    ; 08A0 _ ..UU..(.
        db 55H, 55H, 55H, 55H, 85H, 00H, 55H, 55H       ; 08A8 _ UUUU..UU
        db 86H, 0FFH, 55H, 55H, 8FH, 00H, 55H, 55H      ; 08B0 _ ..UU..UU
        db 55H, 55H, 42H, 00H, 55H, 55H, 65H, 00H       ; 08B8 _ UUB.UUe.
        db 55H, 55H, 55H, 55H, 50H, 00H, 55H, 55H       ; 08C0 _ UUUUP.UU
        db 55H, 55H, 55H, 55H, 98H, 00H, 49H, 00H       ; 08C8 _ UUUU..I.
        db 55H, 55H, 00H, 00H, 55H, 55H, 0AFH, 00H      ; 08D0 _ UU..UU..
        db 62H, 0FFH, 55H, 55H, 55H, 55H, 55H, 55H      ; 08D8 _ b.UUUUUU
        db 55H, 55H, 55H, 55H, 55H, 55H, 55H, 55H       ; 08E0 _ UUUUUUUU
        db 55H, 55H, 55H, 55H, 55H, 55H, 0ACH, 00H      ; 08E8 _ UUUUUU..
        db 4EH, 00H, 55H, 55H, 55H, 55H, 97H, 00H       ; 08F0 _ N.UUUU..
        db 0B6H, 00H, 55H, 55H, 55H, 55H, 0E9H, 0FFH    ; 08F8 _ ..UUUU..
        db 82H, 00H, 55H, 55H, 55H, 55H, 55H, 55H       ; 0900 _ ..UUUUUU
        db 55H, 55H, 55H, 55H, 55H, 55H, 9AH, 00H       ; 0908 _ UUUUUU..
        db 29H, 00H, 62H, 00H, 55H, 55H, 4CH, 00H       ; 0910 _ ).b.UUL.
        db 55H, 55H, 55H, 55H, 8BH, 00H, 10H, 00H       ; 0918 _ UUUU....
        db 57H, 0FFH, 04H, 00H, 55H, 55H, 55H, 55H      ; 0920 _ W...UUUU
        db 0CH, 00H, 55H, 55H, 8DH, 00H, 55H, 55H       ; 0928 _ ..UU..UU
        db 60H, 00H, 55H, 55H, 55H, 55H, 0A3H, 00H      ; 0930 _ `.UUUU..
        db 0E7H, 0FFH, 55H, 55H, 55H, 55H, 0EH, 00H     ; 0938 _ ..UUUU..
        db 0D3H, 0FFH, 55H, 55H, 89H, 00H, 69H, 00H     ; 0940 _ ..UU..i.
        db 0B7H, 00H, 55H, 55H, 55H, 55H, 55H, 55H      ; 0948 _ ..UUUUUU
        db 0AEH, 00H, 55H, 55H, 9DH, 00H, 55H, 55H      ; 0950 _ ..UU..UU
        db 55H, 55H, 55H, 55H, 55H, 55H, 55H, 55H       ; 0958 _ UUUUUUUU

hashdata.0:                                             ; zword
        db 55H, 55H, 00H, 00H, 00H, 00H, 55H, 55H       ; 0960 _ UU....UU
        db 55H, 55H, 55H, 55H, 55H, 55H, 00H, 00H       ; 0968 _ UUUUUU..
        db 55H, 55H, 85H, 00H, 00H, 00H, 0A3H, 00H      ; 0970 _ UU......
        db 40H, 00H, 03H, 00H, 00H, 00H, 00H, 00H       ; 0978 _ @.......
        db 8DH, 00H, 55H, 55H, 00H, 00H, 55H, 55H       ; 0980 _ ..UU..UU
        db 55H, 55H, 55H, 55H, 55H, 55H, 8FH, 00H       ; 0988 _ UUUUUU..
        db 84H, 00H, 55H, 55H, 7EH, 00H, 55H, 55H       ; 0990 _ ..UU~.UU
        db 80H, 0FFH, 55H, 55H, 55H, 55H, 55H, 55H      ; 0998 _ ..UUUUUU


SECTION .data.rel.ro.local align=32 noexec              ; section number 5, data

pp_directives:                                          ; byte
        dq Unnamed_4_0                                  ; 0000 _ 0000000000000000 (d)
        dq 0000000000000000H                            ; 0008 _ 0000000000000000 
        dq Unnamed_4_0+4H                               ; 0010 _ 0000000000000000 (d)
        dq Unnamed_4_0+0BH                              ; 0018 _ 0000000000000000 (d)
        dq Unnamed_4_0+12H                              ; 0020 _ 0000000000000000 (d)
        dq Unnamed_4_0+1EH                              ; 0028 _ 0000000000000000 (d)
        dq Unnamed_4_0+26H                              ; 0030 _ 0000000000000000 (d)
        dq Unnamed_4_0+33H                              ; 0038 _ 0000000000000000 (d)
        dq Unnamed_4_0+3CH                              ; 0040 _ 0000000000000000 (d)
        dq Unnamed_4_0+43H                              ; 0048 _ 0000000000000000 (d)
        dq Unnamed_4_0+4BH                              ; 0050 _ 0000000000000000 (d)
        dq Unnamed_4_0+51H                              ; 0058 _ 0000000000000000 (d)
        dq Unnamed_4_0+58H                              ; 0060 _ 0000000000000000 (d)
        dq Unnamed_4_0+60H                              ; 0068 _ 0000000000000000 (d)
        dq Unnamed_4_0+69H                              ; 0070 _ 0000000000000000 (d)
        dq Unnamed_4_0+70H                              ; 0078 _ 0000000000000000 (d)
        dq Unnamed_4_0+77H                              ; 0080 _ 0000000000000000 (d)
        dq Unnamed_4_0+80H                              ; 0088 _ 0000000000000000 (d)
        dq Unnamed_4_0+8AH                              ; 0090 _ 0000000000000000 (d)
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
        dq Unnamed_4_0+93H                              ; 0100 _ 0000000000000000 (d)
        dq 0000000000000000H                            ; 0108 _ 0000000000000000 
        dq Unnamed_4_0+98H                              ; 0110 _ 0000000000000000 (d)
        dq Unnamed_4_0+0A0H                             ; 0118 _ 0000000000000000 (d)
        dq Unnamed_4_0+0A8H                             ; 0120 _ 0000000000000000 (d)
        dq Unnamed_4_0+0B5H                             ; 0128 _ 0000000000000000 (d)
        dq Unnamed_4_0+0BEH                             ; 0130 _ 0000000000000000 (d)
        dq Unnamed_4_0+0CCH                             ; 0138 _ 0000000000000000 (d)
        dq Unnamed_4_0+0D6H                             ; 0140 _ 0000000000000000 (d)
        dq Unnamed_4_0+0DEH                             ; 0148 _ 0000000000000000 (d)
        dq Unnamed_4_0+0E7H                             ; 0150 _ 0000000000000000 (d)
        dq Unnamed_4_0+0EEH                             ; 0158 _ 0000000000000000 (d)
        dq Unnamed_4_0+0F6H                             ; 0160 _ 0000000000000000 (d)
        dq Unnamed_4_0+0FFH                             ; 0168 _ 0000000000000000 (d)
        dq Unnamed_4_0+109H                             ; 0170 _ 0000000000000000 (d)
        dq Unnamed_4_0+111H                             ; 0178 _ 0000000000000000 (d)
        dq Unnamed_4_0+119H                             ; 0180 _ 0000000000000000 (d)
        dq Unnamed_4_0+123H                             ; 0188 _ 0000000000000000 (d)
        dq Unnamed_4_0+12EH                             ; 0190 _ 0000000000000000 (d)
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
        dq Unnamed_4_0+138H                             ; 0200 _ 0000000000000000 (d)
        dq 0000000000000000H                            ; 0208 _ 0000000000000000 
        dq Unnamed_4_0+13EH                             ; 0210 _ 0000000000000000 (d)
        dq Unnamed_4_0+147H                             ; 0218 _ 0000000000000000 (d)
        dq Unnamed_4_0+150H                             ; 0220 _ 0000000000000000 (d)
        dq Unnamed_4_0+15EH                             ; 0228 _ 0000000000000000 (d)
        dq Unnamed_4_0+168H                             ; 0230 _ 0000000000000000 (d)
        dq Unnamed_4_0+177H                             ; 0238 _ 0000000000000000 (d)
        dq Unnamed_4_0+182H                             ; 0240 _ 0000000000000000 (d)
        dq Unnamed_4_0+18BH                             ; 0248 _ 0000000000000000 (d)
        dq Unnamed_4_0+195H                             ; 0250 _ 0000000000000000 (d)
        dq Unnamed_4_0+19DH                             ; 0258 _ 0000000000000000 (d)
        dq Unnamed_4_0+1A6H                             ; 0260 _ 0000000000000000 (d)
        dq Unnamed_4_0+1B0H                             ; 0268 _ 0000000000000000 (d)
        dq Unnamed_4_0+1BBH                             ; 0270 _ 0000000000000000 (d)
        dq Unnamed_4_0+1C4H                             ; 0278 _ 0000000000000000 (d)
        dq Unnamed_4_0+1CDH                             ; 0280 _ 0000000000000000 (d)
        dq Unnamed_4_0+1D8H                             ; 0288 _ 0000000000000000 (d)
        dq Unnamed_4_0+1E4H                             ; 0290 _ 0000000000000000 (d)
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
        dq Unnamed_4_0+1EFH                             ; 0300 _ 0000000000000000 (d)
        dq 0000000000000000H                            ; 0308 _ 0000000000000000 
        dq Unnamed_4_0+1F6H                             ; 0310 _ 0000000000000000 (d)
        dq Unnamed_4_0+200H                             ; 0318 _ 0000000000000000 (d)
        dq Unnamed_4_0+20AH                             ; 0320 _ 0000000000000000 (d)
        dq Unnamed_4_0+219H                             ; 0328 _ 0000000000000000 (d)
        dq Unnamed_4_0+224H                             ; 0330 _ 0000000000000000 (d)
        dq Unnamed_4_0+234H                             ; 0338 _ 0000000000000000 (d)
        dq Unnamed_4_0+240H                             ; 0340 _ 0000000000000000 (d)
        dq Unnamed_4_0+24AH                             ; 0348 _ 0000000000000000 (d)
        dq Unnamed_4_0+255H                             ; 0350 _ 0000000000000000 (d)
        dq Unnamed_4_0+25EH                             ; 0358 _ 0000000000000000 (d)
        dq Unnamed_4_0+268H                             ; 0360 _ 0000000000000000 (d)
        dq Unnamed_4_0+273H                             ; 0368 _ 0000000000000000 (d)
        dq Unnamed_4_0+27FH                             ; 0370 _ 0000000000000000 (d)
        dq Unnamed_4_0+289H                             ; 0378 _ 0000000000000000 (d)
        dq Unnamed_4_0+293H                             ; 0380 _ 0000000000000000 (d)
        dq Unnamed_4_0+29FH                             ; 0388 _ 0000000000000000 (d)
        dq Unnamed_4_0+2ACH                             ; 0390 _ 0000000000000000 (d)
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
        dq Unnamed_4_0+2B8H                             ; 0400 _ 0000000000000000 (d)
        dq Unnamed_4_0+2C1H                             ; 0408 _ 0000000000000000 (d)
        dq Unnamed_4_0+2C6H                             ; 0410 _ 0000000000000000 (d)
        dq Unnamed_4_0+2CDH                             ; 0418 _ 0000000000000000 (d)
        dq Unnamed_4_0+2D5H                             ; 0420 _ 0000000000000000 (d)
        dq Unnamed_4_0+2DBH                             ; 0428 _ 0000000000000000 (d)
        dq Unnamed_4_0+2E2H                             ; 0430 _ 0000000000000000 (d)
        dq Unnamed_4_0+2E8H                             ; 0438 _ 0000000000000000 (d)
        dq Unnamed_4_0+2F2H                             ; 0440 _ 0000000000000000 (d)
        dq Unnamed_4_0+2FAH                             ; 0448 _ 0000000000000000 (d)
        dq Unnamed_4_0+301H                             ; 0450 _ 0000000000000000 (d)
        dq Unnamed_4_0+30CH                             ; 0458 _ 0000000000000000 (d)
        dq Unnamed_4_0+315H                             ; 0460 _ 0000000000000000 (d)
        dq Unnamed_4_0+31CH                             ; 0468 _ 0000000000000000 (d)
        dq Unnamed_4_0+325H                             ; 0470 _ 0000000000000000 (d)
        dq Unnamed_4_0+32BH                             ; 0478 _ 0000000000000000 (d)
        dq Unnamed_4_0+332H                             ; 0480 _ 0000000000000000 (d)
        dq Unnamed_4_0+338H                             ; 0488 _ 0000000000000000 (d)
        dq Unnamed_4_0+33EH                             ; 0490 _ 0000000000000000 (d)
        dq Unnamed_4_0+343H                             ; 0498 _ 0000000000000000 (d)
        dq Unnamed_4_0+34BH                             ; 04A0 _ 0000000000000000 (d)
        dq Unnamed_4_0+351H                             ; 04A8 _ 0000000000000000 (d)
        dq Unnamed_4_0+356H                             ; 04B0 _ 0000000000000000 (d)
        dq Unnamed_4_0+35CH                             ; 04B8 _ 0000000000000000 (d)
        dq Unnamed_4_0+365H                             ; 04C0 _ 0000000000000000 (d)
        dq Unnamed_4_0+36DH                             ; 04C8 _ 0000000000000000 (d)
        dq Unnamed_4_0+378H                             ; 04D0 _ 0000000000000000 (d)
        dq Unnamed_4_0+37FH                             ; 04D8 _ 0000000000000000 (d)
        dq Unnamed_4_0+38BH                             ; 04E0 _ 0000000000000000 (d)
        dq Unnamed_4_0+390H                             ; 04E8 _ 0000000000000000 (d)
        dq Unnamed_4_0+399H                             ; 04F0 _ 0000000000000000 (d)
        dq Unnamed_4_0+3A1H                             ; 04F8 _ 0000000000000000 (d)
        dq Unnamed_4_0+3AAH                             ; 0500 _ 0000000000000000 (d)
        dq Unnamed_4_0+3B4H                             ; 0508 _ 0000000000000000 (d)
        dq Unnamed_4_0+3BFH                             ; 0510 _ 0000000000000000 (d)
        dq Unnamed_4_0+3C7H                             ; 0518 _ 0000000000000000 (d)
        dq Unnamed_4_0+3D0H                             ; 0520 _ 0000000000000000 (d)
        dq Unnamed_4_0+3D8H                             ; 0528 _ 0000000000000000 (d)
        dq Unnamed_4_0+3E1H                             ; 0530 _ 0000000000000000 (d)
        dq Unnamed_4_0+3E9H                             ; 0538 _ 0000000000000000 (d)
        dq Unnamed_4_0+3F2H                             ; 0540 _ 0000000000000000 (d)
        dq Unnamed_4_0+3F9H                             ; 0548 _ 0000000000000000 (d)
        dq Unnamed_4_0+401H                             ; 0550 _ 0000000000000000 (d)
        dq Unnamed_4_0+40DH                             ; 0558 _ 0000000000000000 (d)
        dq Unnamed_4_0+41AH                             ; 0560 _ 0000000000000000 (d)
        dq Unnamed_4_0+422H                             ; 0568 _ 0000000000000000 (d)
        dq Unnamed_4_0+42BH                             ; 0570 _ 0000000000000000 (d)
        dq Unnamed_4_0+433H                             ; 0578 _ 0000000000000000 (d)
        dq Unnamed_4_0+43CH                             ; 0580 _ 0000000000000000 (d)
        dq Unnamed_4_0+444H                             ; 0588 _ 0000000000000000 (d)
        dq Unnamed_4_0+44DH                             ; 0590 _ 0000000000000000 (d)
        dq Unnamed_4_0+455H                             ; 0598 _ 0000000000000000 (d)
        dq Unnamed_4_0+45EH                             ; 05A0 _ 0000000000000000 (d)
        dq Unnamed_4_0+467H                             ; 05A8 _ 0000000000000000 (d)
        dq Unnamed_4_0+471H                             ; 05B0 _ 0000000000000000 (d)
        dq Unnamed_4_0+47AH                             ; 05B8 _ 0000000000000000 (d)


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
        dd pp_token_hash-$-20H                          ; 0020 _ 00000000 (rel)
        dd 000000DAH, 100E4100H                         ; 0024 _ 218 269369600 
        dd 0D430286H, 0CD50206H                         ; 002C _ 222495366 215286278 
        dd 00000807H, 0000001CH                         ; 0034 _ 2055 28 
        dd 0000003CH                                    ; 003C _ 60 
        dd pp_token_hash-$+9AH                          ; 0040 _ 00000000 (rel)
        dd 000000DAH, 100E4100H                         ; 0044 _ 218 269369600 
        dd 0D430286H, 0CD50206H                         ; 004C _ 222495366 215286278 
        dd 00000807H                                    ; 0054 _ 2055 


