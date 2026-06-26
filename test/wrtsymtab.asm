;Testname=win32;  Arguments=-fwin32  -owrtsymtab.o -Ox --reproducible; Files=stdout stderr wrtsymtab.o
;Testname=win64;  Arguments=-fwin64  -owrtsymtab.o -Ox --reproducible; Files=stdout stderr wrtsymtab.o

; Just some symbols & code to work with.
abs_sym1 equ 0x12345678

section .text
extern   extrn_sym_unused
required extrn_sym1
mysymbol1:
        ret
        int3
        int3
mysymbol2:
        ret
        int3
mysymbol3_private:
.start_of_prolog:
mysymbol3:
global mysymbol3:function
        ret

oddsym1:
        ret

required extrn_sym2
required extrn_sym3
extern   extrn_sym4

section .data
abs_sym2 equ 0x91929394

section .rodata rdata
        ; Various uses with DD
        db      '  mysymbol1:'
        dd      mysymbol1 wrt ..symtab
        db      ' extrn_sym1:'
        dd      extrn_sym1 wrt ..symtab
        db      '   abs_sym1:'
        dd      abs_sym1 wrt ..symtab

        db      '  mysymbol2:'
        dd      mysymbol2 wrt ..symtab
        db      ' extrn_sym2:'
        dd      extrn_sym2 wrt ..symtab
        db      '   abs_sym2:'
        dd      abs_sym2 wrt ..symtab

        db      ' extrn_sym3:'
        dd      extrn_sym3 wrt ..symtab
        db      '  mysymbol3:'
        dd      mysymbol3 wrt ..symtab
        db      ' extrn_sym4:'
        dd      extrn_sym4 wrt ..symtab

        ; Uses with DB, DW, DD and DQ. Will generate warnings.
        db      '    db oddsym1:'
        db      oddsym1 wrt ..symtab
        db      '   dw oddsym1:'
        dw      oddsym1 wrt ..symtab
        db      ' dd oddsym1:'
        dd      oddsym1 wrt ..symtab    ; ok, no warning
        db      'dq same:'
        dq      oddsym1 wrt ..symtab

; a little closer to real life use.
section gehcont$y align=4 rdata
__guard_ehcont_main: dd main.cont wrt ..symtab

section .text
global main:function
main:
        call    mysymbol3
        xor     eax, eax
        ret
.cont:
        mov     eax, -1
        ret

