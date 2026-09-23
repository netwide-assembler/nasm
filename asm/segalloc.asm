; Disassembly of file: /tmp/tmp.ejbjLlU18C.o
; Wed Sep 23 14:43:27 2026
; Type: ELF64
; Syntax: NASM
; Instruction set: 8086, x64

default rel

global seg_alloc: function


SECTION .text   align=1 exec                            ; section number 1, code

seg_alloc:; Function begin
        push    rbp                                     ; 0000 _ 55
        mov     rbp, rsp                                ; 0001 _ 48: 89. E5
        mov     eax, dword [rel next_seg]               ; 0004 _ 8B. 05, 00000000(rel)
        mov     dword [rbp-4H], eax                     ; 000A _ 89. 45, FC
        mov     eax, dword [rel next_seg]               ; 000D _ 8B. 05, 00000000(rel)
        add     eax, 2                                  ; 0013 _ 83. C0, 02
        mov     dword [rel next_seg], eax               ; 0016 _ 89. 05, 00000000(rel)
        mov     eax, dword [rbp-4H]                     ; 001C _ 8B. 45, FC
        pop     rbp                                     ; 001F _ 5D
        ret                                             ; 0020 _ C3
; seg_alloc End of function


SECTION .data   align=4 noexec                          ; section number 2, data

next_seg:                                               ; dword
        dd 00000002H                                    ; 0000 _ 2 


SECTION .bss    align=1 noexec                          ; section number 3, bss


SECTION .note.gnu.property align=8 noexec               ; section number 4, const

        db 04H, 00H, 00H, 00H, 20H, 00H, 00H, 00H       ; 0000 _ .... ...
        db 05H, 00H, 00H, 00H, 47H, 4EH, 55H, 00H       ; 0008 _ ....GNU.
        db 02H, 00H, 01H, 0C0H, 04H, 00H, 00H, 00H      ; 0010 _ ........
        db 01H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0018 _ ........
        db 01H, 00H, 01H, 0C0H, 04H, 00H, 00H, 00H      ; 0020 _ ........
        db 01H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0028 _ ........


SECTION .eh_frame align=8 noexec                        ; section number 5, const

        db 14H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0000 _ ........
        db 01H, 7AH, 52H, 00H, 01H, 78H, 10H, 01H       ; 0008 _ .zR..x..
        db 1BH, 0CH, 07H, 08H, 90H, 01H, 00H, 00H       ; 0010 _ ........
        db 1CH, 00H, 00H, 00H, 1CH, 00H, 00H, 00H       ; 0018 _ ........
        dd seg_alloc-$-20H                              ; 0020 _ 00000000 (rel)
        dd 00000021H, 100E4100H                         ; 0024 _ 33 269369600 
        dd 0D430286H, 070C5C06H                         ; 002C _ 222495366 118250502 
        dd 00000008H                                    ; 0034 _ 8 


