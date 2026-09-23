; Disassembly of file: /tmp/tmp.hWJs8suJry.o
; Wed Sep 23 14:43:21 2026
; Type: ELF64
; Syntax: NASM
; Instruction set: 8086, x64

default rel

global directive_tbl
global directive_hash


SECTION .text   align=1 exec                            ; section number 1, code


SECTION .data   align=1 noexec                          ; section number 2, data


SECTION .bss    align=1 noexec                          ; section number 3, bss


SECTION .rodata align=32 noexec                         ; section number 4, const

        db 61H, 62H, 73H, 6FH, 6CH, 75H, 74H, 65H       ; 0000 _ absolute
        db 00H, 62H, 69H, 74H, 73H, 00H, 63H, 6FH       ; 0008 _ .bits.co
        db 6DH, 6DH, 6FH, 6EH, 00H, 63H, 70H, 75H       ; 0010 _ mmon.cpu
        db 00H, 64H, 65H, 62H, 75H, 67H, 00H, 64H       ; 0018 _ .debug.d
        db 65H, 66H, 61H, 75H, 6CH, 74H, 00H, 64H       ; 0020 _ efault.d
        db 6FH, 6CH, 6CH, 61H, 72H, 68H, 65H, 78H       ; 0028 _ ollarhex
        db 00H, 65H, 78H, 74H, 65H, 72H, 6EH, 00H       ; 0030 _ .extern.
        db 66H, 6CH, 6FH, 61H, 74H, 00H, 67H, 6CH       ; 0038 _ float.gl
        db 6FH, 62H, 61H, 6CH, 00H, 6CH, 69H, 73H       ; 0040 _ obal.lis
        db 74H, 00H, 70H, 72H, 61H, 67H, 6DH, 61H       ; 0048 _ t.pragma
        db 00H, 72H, 65H, 71H, 75H, 69H, 72H, 65H       ; 0050 _ .require
        db 64H, 00H, 73H, 65H, 63H, 74H, 61H, 6CH       ; 0058 _ d.sectal
        db 69H, 67H, 6EH, 00H, 73H, 65H, 63H, 74H       ; 0060 _ ign.sect
        db 69H, 6FH, 6EH, 00H, 73H, 65H, 67H, 6DH       ; 0068 _ ion.segm
        db 65H, 6EH, 74H, 00H, 73H, 74H, 61H, 74H       ; 0070 _ ent.stat
        db 69H, 63H, 00H, 77H, 61H, 72H, 6EH, 69H       ; 0078 _ ic.warni
        db 6EH, 67H, 00H, 70H, 72H, 65H, 66H, 69H       ; 0080 _ ng.prefi
        db 78H, 00H, 73H, 75H, 66H, 66H, 69H, 78H       ; 0088 _ x.suffix
        db 00H, 70H, 6FH, 73H, 74H, 66H, 69H, 78H       ; 0090 _ .postfix
        db 00H, 67H, 70H, 72H, 65H, 66H, 69H, 78H       ; 0098 _ .gprefix
        db 00H, 67H, 73H, 75H, 66H, 66H, 69H, 78H       ; 00A0 _ .gsuffix
        db 00H, 67H, 70H, 6FH, 73H, 74H, 66H, 69H       ; 00A8 _ .gpostfi
        db 78H, 00H, 6CH, 70H, 72H, 65H, 66H, 69H       ; 00B0 _ x.lprefi
        db 78H, 00H, 6CH, 73H, 75H, 66H, 66H, 69H       ; 00B8 _ x.lsuffi
        db 78H, 00H, 6CH, 70H, 6FH, 73H, 74H, 66H       ; 00C0 _ x.lpostf
        db 69H, 78H, 00H, 64H, 62H, 00H, 64H, 77H       ; 00C8 _ ix.db.dw
        db 00H, 64H, 64H, 00H, 64H, 71H, 00H, 64H       ; 00D0 _ .dd.dq.d
        db 74H, 00H, 64H, 6FH, 00H, 64H, 79H, 00H       ; 00D8 _ t.do.dy.
        db 64H, 7AH, 00H, 72H, 65H, 73H, 62H, 00H       ; 00E0 _ dz.resb.
        db 72H, 65H, 73H, 77H, 00H, 72H, 65H, 73H       ; 00E8 _ resw.res
        db 64H, 00H, 72H, 65H, 73H, 71H, 00H, 72H       ; 00F0 _ d.resq.r
        db 65H, 73H, 74H, 00H, 72H, 65H, 73H, 6FH       ; 00F8 _ est.reso
        db 00H, 72H, 65H, 73H, 79H, 00H, 72H, 65H       ; 0100 _ .resy.re
        db 73H, 7AH, 00H, 69H, 6EH, 63H, 62H, 69H       ; 0108 _ sz.incbi
        db 6EH, 00H, 65H, 71H, 75H, 00H, 65H, 78H       ; 0110 _ n.equ.ex
        db 70H, 6FH, 72H, 74H, 00H, 67H, 72H, 6FH       ; 0118 _ port.gro
        db 75H, 70H, 00H, 69H, 6DH, 70H, 6FH, 72H       ; 0120 _ up.impor
        db 74H, 00H, 6CH, 69H, 62H, 72H, 61H, 72H       ; 0128 _ t.librar
        db 79H, 00H, 6DH, 61H, 70H, 00H, 6DH, 6FH       ; 0130 _ y.map.mo
        db 64H, 75H, 6CH, 65H, 00H, 6FH, 72H, 67H       ; 0138 _ dule.org
        db 00H, 6FH, 73H, 61H, 62H, 69H, 00H, 73H       ; 0140 _ .osabi.s
        db 61H, 66H, 65H, 73H, 65H, 68H, 00H, 75H       ; 0148 _ afeseh.u
        db 70H, 70H, 65H, 72H, 63H, 61H, 73H, 65H       ; 0150 _ ppercase
        db 00H, 6CH, 69H, 6DH, 69H, 74H, 00H, 6FH       ; 0158 _ .limit.o
        db 70H, 74H, 69H, 6FH, 6EH, 73H, 00H, 73H       ; 0160 _ ptions.s
        db 75H, 62H, 73H, 65H, 63H, 74H, 69H, 6FH       ; 0168 _ ubsectio
        db 6EH, 73H, 5FH, 76H, 69H, 61H, 5FH, 73H       ; 0170 _ ns_via_s
        db 79H, 6DH, 62H, 6FH, 6CH, 73H, 00H, 6EH       ; 0178 _ ymbols.n
        db 6FH, 5FH, 64H, 65H, 61H, 64H, 5FH, 73H       ; 0180 _ o_dead_s
        db 74H, 72H, 69H, 70H, 00H, 6DH, 61H, 78H       ; 0188 _ trip.max
        db 64H, 75H, 6DH, 70H, 00H, 6EH, 6FH, 64H       ; 0190 _ dump.nod
        db 65H, 70H, 65H, 6EH, 64H, 00H, 6EH, 6FH       ; 0198 _ epend.no
        db 73H, 65H, 63H, 6CH, 61H, 62H, 65H, 6CH       ; 01A0 _ seclabel
        db 73H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 01A8 _ s.......
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 01B0 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 01B8 _ ........

directive_hashvals:                                     ; byte
        db 00H, 00H, 55H, 55H, 00H, 00H, 55H, 55H       ; 01C0 _ ..UU..UU
        db 00H, 00H, 55H, 55H, 55H, 55H, 55H, 55H       ; 01C8 _ ..UUUUUU
        db 00H, 00H, 55H, 55H, 55H, 55H, 00H, 00H       ; 01D0 _ ..UUUU..
        db 55H, 55H, 55H, 55H, 00H, 00H, 55H, 55H       ; 01D8 _ UUUU..UU
        db 55H, 55H, 00H, 00H, 00H, 00H, 00H, 00H       ; 01E0 _ UU......
        db 55H, 55H, 13H, 00H, 00H, 00H, 00H, 00H       ; 01E8 _ UU......
        db 55H, 55H, 55H, 55H, 55H, 55H, 0DEH, 0FFH     ; 01F0 _ UUUUUU..
        db 0FH, 00H, 55H, 55H, 55H, 55H, 00H, 00H       ; 01F8 _ ..UUUU..
        db 55H, 55H, 00H, 00H, 55H, 55H, 55H, 55H       ; 0200 _ UU..UUUU
        db 00H, 00H, 55H, 55H, 55H, 55H, 3AH, 00H       ; 0208 _ ..UUUU:.
        db 55H, 55H, 00H, 00H, 55H, 55H, 00H, 00H       ; 0210 _ UU..UU..
        db 00H, 00H, 00H, 00H, 55H, 55H, 55H, 55H       ; 0218 _ ....UUUU
        db 55H, 55H, 55H, 55H, 55H, 55H, 55H, 55H       ; 0220 _ UUUUUUUU
        db 55H, 55H, 55H, 55H, 10H, 00H, 55H, 55H       ; 0228 _ UUUU..UU
        db 18H, 00H, 55H, 55H, 00H, 00H, 55H, 55H       ; 0230 _ ..UU..UU
        db 4BH, 00H, 55H, 55H, 00H, 00H, 00H, 00H       ; 0238 _ K.UU....
        db 00H, 00H, 3BH, 00H, 00H, 00H, 20H, 00H       ; 0240 _ ..;... .
        db 55H, 55H, 55H, 55H, 55H, 55H, 2FH, 00H       ; 0248 _ UUUUUU/.
        db 55H, 55H, 55H, 55H, 20H, 00H, 55H, 55H       ; 0250 _ UUUU .UU
        db 55H, 55H, 0F5H, 0FFH, 55H, 55H, 55H, 55H     ; 0258 _ UU..UUUU
        db 55H, 55H, 55H, 55H, 55H, 55H, 09H, 00H       ; 0260 _ UUUUUU..
        db 34H, 00H, 00H, 00H, 55H, 55H, 55H, 55H       ; 0268 _ 4...UUUU
        db 00H, 00H, 55H, 55H, 00H, 00H, 55H, 55H       ; 0270 _ ..UU..UU
        db 00H, 00H, 55H, 55H, 55H, 55H, 55H, 55H       ; 0278 _ ..UUUUUU
        db 55H, 55H, 55H, 55H, 55H, 55H, 55H, 55H       ; 0280 _ UUUUUUUU
        db 0EH, 00H, 55H, 55H, 00H, 00H, 55H, 55H       ; 0288 _ ..UU..UU
        db 55H, 55H, 55H, 55H, 55H, 55H, 00H, 00H       ; 0290 _ UUUUUU..
        db 55H, 55H, 1BH, 00H, 55H, 55H, 55H, 55H       ; 0298 _ UU..UUUU
        db 55H, 55H, 55H, 55H, 55H, 55H, 33H, 00H       ; 02A0 _ UUUUUU3.
        db 55H, 55H, 00H, 00H, 27H, 00H, 0E8H, 0FFH     ; 02A8 _ UU..'...
        db 55H, 55H, 0DH, 00H, 55H, 55H, 1FH, 00H       ; 02B0 _ UU..UU..
        db 55H, 55H, 13H, 00H, 1AH, 00H, 55H, 55H       ; 02B8 _ UU....UU
        db 0AH, 00H, 55H, 55H, 55H, 55H, 55H, 55H       ; 02C0 _ ..UUUUUU
        db 55H, 55H, 55H, 55H, 00H, 00H, 07H, 00H       ; 02C8 _ UUUU....
        db 55H, 55H, 31H, 00H, 55H, 55H, 55H, 55H       ; 02D0 _ UU1.UUUU
        db 55H, 55H, 55H, 55H, 55H, 55H, 03H, 00H       ; 02D8 _ UUUUUU..
        db 55H, 55H, 55H, 55H, 55H, 55H, 3EH, 00H       ; 02E0 _ UUUUUU>.
        db 0DBH, 0FFH, 21H, 00H, 55H, 55H, 55H, 55H     ; 02E8 _ ..!.UUUU
        db 00H, 00H, 55H, 55H, 55H, 55H, 0BH, 00H       ; 02F0 _ ..UUUU..
        db 55H, 55H, 55H, 55H, 55H, 55H, 55H, 55H       ; 02F8 _ UUUUUUUU
        db 55H, 55H, 0EH, 00H, 55H, 55H, 55H, 55H       ; 0300 _ UU..UUUU
        db 55H, 55H, 55H, 55H, 0FH, 00H, 55H, 55H       ; 0308 _ UUUU..UU
        db 55H, 55H, 55H, 55H, 55H, 55H, 55H, 55H       ; 0310 _ UUUUUUUU
        db 00H, 00H, 55H, 55H, 0F7H, 0FFH, 55H, 55H     ; 0318 _ ..UU..UU
        db 55H, 55H, 55H, 55H, 55H, 55H, 37H, 00H       ; 0320 _ UUUUUU7.
        db 3FH, 00H, 01H, 00H, 55H, 55H, 55H, 55H       ; 0328 _ ?...UUUU
        db 55H, 55H, 55H, 55H, 55H, 55H, 55H, 55H       ; 0330 _ UUUUUUUU
        db 2DH, 00H, 55H, 55H, 11H, 00H, 55H, 55H       ; 0338 _ -.UU..UU
        db 00H, 00H, 55H, 55H, 11H, 00H, 2AH, 00H       ; 0340 _ ..UU..*.
        db 00H, 00H, 55H, 55H, 55H, 55H, 55H, 55H       ; 0348 _ ..UUUUUU
        db 04H, 00H, 02H, 00H, 55H, 55H, 55H, 55H       ; 0350 _ ....UUUU
        db 55H, 55H, 28H, 00H, 00H, 00H, 55H, 55H       ; 0358 _ UU(...UU
        db 55H, 55H, 31H, 00H, 55H, 55H, 08H, 00H       ; 0360 _ UU1.UU..
        db 55H, 55H, 55H, 55H, 55H, 55H, 55H, 55H       ; 0368 _ UUUUUUUU
        db 55H, 55H, 55H, 55H, 55H, 55H, 05H, 00H       ; 0370 _ UUUUUU..
        db 55H, 55H, 06H, 00H, 55H, 55H, 55H, 55H       ; 0378 _ UU..UUUU
        db 55H, 55H, 55H, 55H, 55H, 55H, 55H, 55H       ; 0380 _ UUUUUUUU
        db 0CH, 00H, 0BH, 00H, 55H, 55H, 55H, 55H       ; 0388 _ ....UUUU
        db 35H, 00H, 0FCH, 0FFH, 55H, 55H, 55H, 55H     ; 0390 _ 5...UUUU
        db 3DH, 00H, 27H, 00H, 55H, 55H, 55H, 55H       ; 0398 _ =.'.UUUU
        db 55H, 55H, 08H, 00H, 55H, 55H, 55H, 55H       ; 03A0 _ UU..UUUU
        db 38H, 00H, 0DH, 00H, 55H, 55H, 15H, 00H       ; 03A8 _ 8...UU..
        db 1BH, 00H, 1BH, 00H, 55H, 55H, 55H, 55H       ; 03B0 _ ....UUUU
        db 55H, 55H, 55H, 55H, 04H, 00H, 55H, 55H       ; 03B8 _ UUUU..UU


SECTION .data.rel.ro.local align=32 noexec              ; section number 5, data

directive_tbl:                                          ; byte
        dq Unnamed_4_0                                  ; 0000 _ 0000000000000000 (d)
        dq Unnamed_4_0+9H                               ; 0008 _ 0000000000000000 (d)
        dq Unnamed_4_0+0EH                              ; 0010 _ 0000000000000000 (d)
        dq Unnamed_4_0+15H                              ; 0018 _ 0000000000000000 (d)
        dq Unnamed_4_0+19H                              ; 0020 _ 0000000000000000 (d)
        dq Unnamed_4_0+1FH                              ; 0028 _ 0000000000000000 (d)
        dq Unnamed_4_0+27H                              ; 0030 _ 0000000000000000 (d)
        dq Unnamed_4_0+31H                              ; 0038 _ 0000000000000000 (d)
        dq Unnamed_4_0+38H                              ; 0040 _ 0000000000000000 (d)
        dq Unnamed_4_0+3EH                              ; 0048 _ 0000000000000000 (d)
        dq Unnamed_4_0+45H                              ; 0050 _ 0000000000000000 (d)
        dq Unnamed_4_0+4AH                              ; 0058 _ 0000000000000000 (d)
        dq Unnamed_4_0+51H                              ; 0060 _ 0000000000000000 (d)
        dq Unnamed_4_0+5AH                              ; 0068 _ 0000000000000000 (d)
        dq Unnamed_4_0+64H                              ; 0070 _ 0000000000000000 (d)
        dq Unnamed_4_0+6CH                              ; 0078 _ 0000000000000000 (d)
        dq Unnamed_4_0+74H                              ; 0080 _ 0000000000000000 (d)
        dq Unnamed_4_0+7BH                              ; 0088 _ 0000000000000000 (d)
        dq Unnamed_4_0+83H                              ; 0090 _ 0000000000000000 (d)
        dq Unnamed_4_0+8AH                              ; 0098 _ 0000000000000000 (d)
        dq Unnamed_4_0+91H                              ; 00A0 _ 0000000000000000 (d)
        dq Unnamed_4_0+99H                              ; 00A8 _ 0000000000000000 (d)
        dq Unnamed_4_0+0A1H                             ; 00B0 _ 0000000000000000 (d)
        dq Unnamed_4_0+0A9H                             ; 00B8 _ 0000000000000000 (d)
        dq Unnamed_4_0+0B2H                             ; 00C0 _ 0000000000000000 (d)
        dq Unnamed_4_0+0BAH                             ; 00C8 _ 0000000000000000 (d)
        dq Unnamed_4_0+0C2H                             ; 00D0 _ 0000000000000000 (d)
        dq 0000000000000000H                            ; 00D8 _ 0000000000000000 
        dq Unnamed_4_0+0CBH                             ; 00E0 _ 0000000000000000 (d)
        dq Unnamed_4_0+0CEH                             ; 00E8 _ 0000000000000000 (d)
        dq Unnamed_4_0+0D1H                             ; 00F0 _ 0000000000000000 (d)
        dq Unnamed_4_0+0D4H                             ; 00F8 _ 0000000000000000 (d)
        dq Unnamed_4_0+0D7H                             ; 0100 _ 0000000000000000 (d)
        dq Unnamed_4_0+0DAH                             ; 0108 _ 0000000000000000 (d)
        dq Unnamed_4_0+0DDH                             ; 0110 _ 0000000000000000 (d)
        dq Unnamed_4_0+0E0H                             ; 0118 _ 0000000000000000 (d)
        dq Unnamed_4_0+0E3H                             ; 0120 _ 0000000000000000 (d)
        dq Unnamed_4_0+0E8H                             ; 0128 _ 0000000000000000 (d)
        dq Unnamed_4_0+0EDH                             ; 0130 _ 0000000000000000 (d)
        dq Unnamed_4_0+0F2H                             ; 0138 _ 0000000000000000 (d)
        dq Unnamed_4_0+0F7H                             ; 0140 _ 0000000000000000 (d)
        dq Unnamed_4_0+0FCH                             ; 0148 _ 0000000000000000 (d)
        dq Unnamed_4_0+101H                             ; 0150 _ 0000000000000000 (d)
        dq Unnamed_4_0+106H                             ; 0158 _ 0000000000000000 (d)
        dq Unnamed_4_0+10BH                             ; 0160 _ 0000000000000000 (d)
        dq Unnamed_4_0+112H                             ; 0168 _ 0000000000000000 (d)
        dq 0000000000000000H                            ; 0170 _ 0000000000000000 
        dq Unnamed_4_0+116H                             ; 0178 _ 0000000000000000 (d)
        dq Unnamed_4_0+11DH                             ; 0180 _ 0000000000000000 (d)
        dq Unnamed_4_0+123H                             ; 0188 _ 0000000000000000 (d)
        dq Unnamed_4_0+12AH                             ; 0190 _ 0000000000000000 (d)
        dq Unnamed_4_0+132H                             ; 0198 _ 0000000000000000 (d)
        dq Unnamed_4_0+136H                             ; 01A0 _ 0000000000000000 (d)
        dq Unnamed_4_0+13DH                             ; 01A8 _ 0000000000000000 (d)
        dq Unnamed_4_0+141H                             ; 01B0 _ 0000000000000000 (d)
        dq Unnamed_4_0+147H                             ; 01B8 _ 0000000000000000 (d)
        dq Unnamed_4_0+14FH                             ; 01C0 _ 0000000000000000 (d)
        dq 0000000000000000H                            ; 01C8 _ 0000000000000000 
        dq Unnamed_4_0+159H                             ; 01D0 _ 0000000000000000 (d)
        dq Unnamed_4_0+15FH                             ; 01D8 _ 0000000000000000 (d)
        dq Unnamed_4_0+167H                             ; 01E0 _ 0000000000000000 (d)
        dq Unnamed_4_0+17FH                             ; 01E8 _ 0000000000000000 (d)
        dq Unnamed_4_0+18DH                             ; 01F0 _ 0000000000000000 (d)
        dq Unnamed_4_0+195H                             ; 01F8 _ 0000000000000000 (d)
        dq Unnamed_4_0+19EH                             ; 0200 _ 0000000000000000 (d)
        dq 0000000000000000H                            ; 0208 _ 0000000000000000 
        dq 0000000000000000H                            ; 0210 _ 0000000000000000 
        dq 0000000000000000H                            ; 0218 _ 0000000000000000 

directive_hash:                                         ; byte
        db 6CH, 0C2H, 91H, 0E2H, 0C3H, 59H, 62H, 07H    ; 0220 _ l....Yb.
        db 0FEH, 00H, 00H, 00H, 41H, 00H, 00H, 00H      ; 0228 _ ....A...
        db 03H, 00H, 00H, 00H, 01H, 00H, 00H, 00H       ; 0230 _ ........
        dq directive_hashvals                           ; 0238 _ 0000000000000000 (d)
        dq directive_tbl                                ; 0240 _ 0000000000000000 (d)


SECTION .note.gnu.property align=8 noexec               ; section number 6, const

        db 04H, 00H, 00H, 00H, 20H, 00H, 00H, 00H       ; 0000 _ .... ...
        db 05H, 00H, 00H, 00H, 47H, 4EH, 55H, 00H       ; 0008 _ ....GNU.
        db 02H, 00H, 01H, 0C0H, 04H, 00H, 00H, 00H      ; 0010 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0018 _ ........
        db 01H, 00H, 01H, 0C0H, 04H, 00H, 00H, 00H      ; 0020 _ ........
        db 01H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0028 _ ........


