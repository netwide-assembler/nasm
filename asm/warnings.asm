; Disassembly of file: /tmp/tmp.CZsHdfUd9r.o
; Wed Sep 23 14:43:23 2026
; Type: ELF64
; Syntax: NASM
; Instruction set: 8086, x64

default rel

global warning_state
global warning_default
global warning_name
global warning_alias
global warning_help


SECTION .text   align=1 exec                            ; section number 1, code


SECTION .data   align=1 noexec                          ; section number 2, data


SECTION .bss    align=32 noexec                         ; section number 3, bss

warning_state:                                          ; byte
        resb    69                                      ; 0000


SECTION .rodata align=32 noexec                         ; section number 4, const

        db 64H, 62H, 2DH, 65H, 6DH, 70H, 74H, 79H       ; 0000 _ db-empty
        db 00H, 64H, 69H, 72H, 65H, 63H, 74H, 69H       ; 0008 _ .directi
        db 76H, 65H, 2DH, 67H, 61H, 72H, 62H, 61H       ; 0010 _ ve-garba
        db 67H, 65H, 2DH, 65H, 6FH, 6CH, 00H, 65H       ; 0018 _ ge-eol.e
        db 61H, 2DH, 61H, 62H, 73H, 6FH, 6CH, 75H       ; 0020 _ a-absolu
        db 74H, 65H, 00H, 65H, 61H, 2DH, 64H, 69H       ; 0028 _ te.ea-di
        db 73H, 70H, 73H, 69H, 7AH, 65H, 00H, 66H       ; 0030 _ spsize.f
        db 6CH, 6FH, 61H, 74H, 2DH, 64H, 65H, 6EH       ; 0038 _ loat-den
        db 6FH, 72H, 6DH, 00H, 66H, 6CH, 6FH, 61H       ; 0040 _ orm.floa
        db 74H, 2DH, 6FH, 76H, 65H, 72H, 66H, 6CH       ; 0048 _ t-overfl
        db 6FH, 77H, 00H, 66H, 6CH, 6FH, 61H, 74H       ; 0050 _ ow.float
        db 2DH, 74H, 6FH, 6FH, 6CH, 6FH, 6EH, 67H       ; 0058 _ -toolong
        db 00H, 66H, 6CH, 6FH, 61H, 74H, 2DH, 75H       ; 0060 _ .float-u
        db 6EH, 64H, 65H, 72H, 66H, 6CH, 6FH, 77H       ; 0068 _ nderflow
        db 00H, 66H, 6FH, 72H, 77H, 61H, 72H, 64H       ; 0070 _ .forward
        db 00H, 69H, 6DH, 70H, 6CH, 69H, 63H, 69H       ; 0078 _ .implici
        db 74H, 2DH, 61H, 62H, 73H, 2DH, 64H, 65H       ; 0080 _ t-abs-de
        db 70H, 72H, 65H, 63H, 61H, 74H, 65H, 64H       ; 0088 _ precated
        db 00H, 6CH, 61H, 62H, 65H, 6CH, 2DH, 6FH       ; 0090 _ .label-o
        db 72H, 70H, 68H, 61H, 6EH, 00H, 6CH, 61H       ; 0098 _ rphan.la
        db 62H, 65H, 6CH, 2DH, 72H, 65H, 64H, 65H       ; 00A0 _ bel-rede
        db 66H, 00H, 6CH, 61H, 62H, 65H, 6CH, 2DH       ; 00A8 _ f.label-
        db 72H, 65H, 64H, 65H, 66H, 2DH, 6CH, 61H       ; 00B0 _ redef-la
        db 74H, 65H, 00H, 6EH, 75H, 6DH, 62H, 65H       ; 00B8 _ te.numbe
        db 72H, 2DH, 64H, 65H, 70H, 72H, 65H, 63H       ; 00C0 _ r-deprec
        db 61H, 74H, 65H, 64H, 2DH, 68H, 65H, 78H       ; 00C8 _ ated-hex
        db 00H, 6EH, 75H, 6DH, 62H, 65H, 72H, 2DH       ; 00D0 _ .number-
        db 6FH, 76H, 65H, 72H, 66H, 6CH, 6FH, 77H       ; 00D8 _ overflow
        db 00H, 6FH, 62H, 73H, 6FH, 6CH, 65H, 74H       ; 00E0 _ .obsolet
        db 65H, 2DH, 6EH, 6FH, 70H, 00H, 6FH, 62H       ; 00E8 _ e-nop.ob
        db 73H, 6FH, 6CH, 65H, 74H, 65H, 2DH, 72H       ; 00F0 _ solete-r
        db 65H, 6DH, 6FH, 76H, 65H, 64H, 00H, 6FH       ; 00F8 _ emoved.o
        db 62H, 73H, 6FH, 6CH, 65H, 74H, 65H, 2DH       ; 0100 _ bsolete-
        db 76H, 61H, 6CH, 69H, 64H, 00H, 70H, 68H       ; 0108 _ valid.ph
        db 61H, 73H, 65H, 00H, 70H, 70H, 2DH, 65H       ; 0110 _ ase.pp-e
        db 6CH, 73H, 65H, 2DH, 65H, 6CH, 69H, 66H       ; 0118 _ lse-elif
        db 00H, 70H, 70H, 2DH, 65H, 6CH, 73H, 65H       ; 0120 _ .pp-else
        db 2DH, 65H, 6CH, 73H, 65H, 00H, 70H, 70H       ; 0128 _ -else.pp
        db 2DH, 65H, 6DH, 70H, 74H, 79H, 2DH, 62H       ; 0130 _ -empty-b
        db 72H, 61H, 63H, 65H, 73H, 00H, 70H, 70H       ; 0138 _ races.pp
        db 2DH, 65H, 6EH, 76H, 69H, 72H, 6FH, 6EH       ; 0140 _ -environ
        db 6DH, 65H, 6EH, 74H, 00H, 70H, 70H, 2DH       ; 0148 _ ment.pp-
        db 6DH, 61H, 63H, 72H, 6FH, 2DH, 64H, 65H       ; 0150 _ macro-de
        db 66H, 2DH, 63H, 61H, 73H, 65H, 2DH, 73H       ; 0158 _ f-case-s
        db 69H, 6EH, 67H, 6CH, 65H, 00H, 70H, 70H       ; 0160 _ ingle.pp
        db 2DH, 6DH, 61H, 63H, 72H, 6FH, 2DH, 64H       ; 0168 _ -macro-d
        db 65H, 66H, 2DH, 67H, 72H, 65H, 65H, 64H       ; 0170 _ ef-greed
        db 79H, 2DH, 73H, 69H, 6EH, 67H, 6CH, 65H       ; 0178 _ y-single
        db 00H, 70H, 70H, 2DH, 6DH, 61H, 63H, 72H       ; 0180 _ .pp-macr
        db 6FH, 2DH, 64H, 65H, 66H, 2DH, 70H, 61H       ; 0188 _ o-def-pa
        db 72H, 61H, 6DH, 2DH, 73H, 69H, 6EH, 67H       ; 0190 _ ram-sing
        db 6CH, 65H, 00H, 70H, 70H, 2DH, 6DH, 61H       ; 0198 _ le.pp-ma
        db 63H, 72H, 6FH, 2DH, 64H, 65H, 66H, 61H       ; 01A0 _ cro-defa
        db 75H, 6CH, 74H, 73H, 00H, 70H, 70H, 2DH       ; 01A8 _ ults.pp-
        db 6DH, 61H, 63H, 72H, 6FH, 2DH, 70H, 61H       ; 01B0 _ macro-pa
        db 72H, 61H, 6DH, 73H, 2DH, 6CH, 65H, 67H       ; 01B8 _ rams-leg
        db 61H, 63H, 79H, 00H, 70H, 70H, 2DH, 6DH       ; 01C0 _ acy.pp-m
        db 61H, 63H, 72H, 6FH, 2DH, 70H, 61H, 72H       ; 01C8 _ acro-par
        db 61H, 6DH, 73H, 2DH, 6DH, 75H, 6CH, 74H       ; 01D0 _ ams-mult
        db 69H, 00H, 70H, 70H, 2DH, 6DH, 61H, 63H       ; 01D8 _ i.pp-mac
        db 72H, 6FH, 2DH, 70H, 61H, 72H, 61H, 6DH       ; 01E0 _ ro-param
        db 73H, 2DH, 73H, 69H, 6EH, 67H, 6CH, 65H       ; 01E8 _ s-single
        db 00H, 70H, 70H, 2DH, 6DH, 61H, 63H, 72H       ; 01F0 _ .pp-macr
        db 6FH, 2DH, 72H, 65H, 64H, 65H, 66H, 2DH       ; 01F8 _ o-redef-
        db 6DH, 75H, 6CH, 74H, 69H, 00H, 70H, 70H       ; 0200 _ multi.pp
        db 2DH, 6FH, 70H, 65H, 6EH, 2DH, 62H, 72H       ; 0208 _ -open-br
        db 61H, 63H, 65H, 73H, 00H, 70H, 70H, 2DH       ; 0210 _ aces.pp-
        db 6FH, 70H, 65H, 6EH, 2DH, 62H, 72H, 61H       ; 0218 _ open-bra
        db 63H, 6BH, 65H, 74H, 73H, 00H, 70H, 70H       ; 0220 _ ckets.pp
        db 2DH, 6FH, 70H, 65H, 6EH, 2DH, 73H, 74H       ; 0228 _ -open-st
        db 72H, 69H, 6EH, 67H, 00H, 70H, 70H, 2DH       ; 0230 _ ring.pp-
        db 72H, 65H, 70H, 2DH, 6EH, 65H, 67H, 61H       ; 0238 _ rep-nega
        db 74H, 69H, 76H, 65H, 00H, 70H, 70H, 2DH       ; 0240 _ tive.pp-
        db 72H, 65H, 73H, 65H, 72H, 76H, 65H, 64H       ; 0248 _ reserved
        db 00H, 70H, 70H, 2DH, 73H, 65H, 6CH, 2DH       ; 0250 _ .pp-sel-
        db 72H, 61H, 6EH, 67H, 65H, 00H, 70H, 70H       ; 0258 _ range.pp
        db 2DH, 74H, 72H, 61H, 69H, 6CH, 69H, 6EH       ; 0260 _ -trailin
        db 67H, 00H, 70H, 72H, 61H, 67H, 6DH, 61H       ; 0268 _ g.pragma
        db 2DH, 62H, 61H, 64H, 00H, 70H, 72H, 61H       ; 0270 _ -bad.pra
        db 67H, 6DH, 61H, 2DH, 65H, 6DH, 70H, 74H       ; 0278 _ gma-empt
        db 79H, 00H, 70H, 72H, 61H, 67H, 6DH, 61H       ; 0280 _ y.pragma
        db 2DH, 6EH, 61H, 00H, 70H, 72H, 61H, 67H       ; 0288 _ -na.prag
        db 6DH, 61H, 2DH, 75H, 6EH, 6BH, 6EH, 6FH       ; 0290 _ ma-unkno
        db 77H, 6EH, 00H, 70H, 72H, 65H, 66H, 69H       ; 0298 _ wn.prefi
        db 78H, 2DH, 62H, 61H, 64H, 6DH, 6FH, 64H       ; 02A0 _ x-badmod
        db 65H, 2DH, 6FH, 36H, 34H, 00H, 70H, 72H       ; 02A8 _ e-o64.pr
        db 65H, 66H, 69H, 78H, 2DH, 62H, 6EH, 64H       ; 02B0 _ efix-bnd
        db 00H, 70H, 72H, 65H, 66H, 69H, 78H, 2DH       ; 02B8 _ .prefix-
        db 68H, 69H, 6EH, 74H, 2DH, 64H, 72H, 6FH       ; 02C0 _ hint-dro
        db 70H, 70H, 65H, 64H, 00H, 70H, 72H, 65H       ; 02C8 _ pped.pre
        db 66H, 69H, 78H, 2DH, 68H, 6CH, 65H, 00H       ; 02D0 _ fix-hle.
        db 70H, 72H, 65H, 66H, 69H, 78H, 2DH, 69H       ; 02D8 _ prefix-i
        db 6EH, 76H, 61H, 6CH, 69H, 64H, 00H, 70H       ; 02E0 _ nvalid.p
        db 72H, 65H, 66H, 69H, 78H, 2DH, 6CH, 6FH       ; 02E8 _ refix-lo
        db 63H, 6BH, 2DH, 65H, 72H, 72H, 6FH, 72H       ; 02F0 _ ck-error
        db 00H, 70H, 72H, 65H, 66H, 69H, 78H, 2DH       ; 02F8 _ .prefix-
        db 6CH, 6FH, 63H, 6BH, 2DH, 78H, 63H, 68H       ; 0300 _ lock-xch
        db 67H, 00H, 70H, 72H, 65H, 66H, 69H, 78H       ; 0308 _ g.prefix
        db 2DH, 6FH, 70H, 73H, 69H, 7AH, 65H, 00H       ; 0310 _ -opsize.
        db 70H, 72H, 65H, 66H, 69H, 78H, 2DH, 73H       ; 0318 _ prefix-s
        db 65H, 67H, 00H, 70H, 74H, 72H, 00H, 72H       ; 0320 _ eg.ptr.r
        db 65H, 67H, 73H, 69H, 7AH, 65H, 00H, 72H       ; 0328 _ egsize.r
        db 65H, 6CH, 6FH, 63H, 2DH, 61H, 62H, 73H       ; 0330 _ eloc-abs
        db 2DH, 62H, 79H, 74H, 65H, 00H, 72H, 65H       ; 0338 _ -byte.re
        db 6CH, 6FH, 63H, 2DH, 61H, 62H, 73H, 2DH       ; 0340 _ loc-abs-
        db 64H, 77H, 6FH, 72H, 64H, 00H, 72H, 65H       ; 0348 _ dword.re
        db 6CH, 6FH, 63H, 2DH, 61H, 62H, 73H, 2DH       ; 0350 _ loc-abs-
        db 71H, 77H, 6FH, 72H, 64H, 00H, 72H, 65H       ; 0358 _ qword.re
        db 6CH, 6FH, 63H, 2DH, 61H, 62H, 73H, 2DH       ; 0360 _ loc-abs-
        db 77H, 6FH, 72H, 64H, 00H, 72H, 65H, 6CH       ; 0368 _ word.rel
        db 6FH, 63H, 2DH, 72H, 65H, 6CH, 2DH, 62H       ; 0370 _ oc-rel-b
        db 79H, 74H, 65H, 00H, 72H, 65H, 6CH, 6FH       ; 0378 _ yte.relo
        db 63H, 2DH, 72H, 65H, 6CH, 2DH, 64H, 77H       ; 0380 _ c-rel-dw
        db 6FH, 72H, 64H, 00H, 72H, 65H, 6CH, 6FH       ; 0388 _ ord.relo
        db 63H, 2DH, 72H, 65H, 6CH, 2DH, 71H, 77H       ; 0390 _ c-rel-qw
        db 6FH, 72H, 64H, 00H, 72H, 65H, 6CH, 6FH       ; 0398 _ ord.relo
        db 63H, 2DH, 72H, 65H, 6CH, 2DH, 77H, 6FH       ; 03A0 _ c-rel-wo
        db 72H, 64H, 00H, 73H, 65H, 63H, 74H, 69H       ; 03A8 _ rd.secti
        db 6FH, 6EH, 2DH, 61H, 6CH, 69H, 67H, 6EH       ; 03B0 _ on-align
        db 6DH, 65H, 6EH, 74H, 2DH, 72H, 6FH, 75H       ; 03B8 _ ment-rou
        db 6EH, 64H, 65H, 64H, 00H, 75H, 6EH, 6BH       ; 03C0 _ nded.unk
        db 6EH, 6FH, 77H, 6EH, 2DH, 77H, 61H, 72H       ; 03C8 _ nown-war
        db 6EH, 69H, 6EH, 67H, 00H, 75H, 73H, 65H       ; 03D0 _ ning.use
        db 72H, 00H, 77H, 61H, 72H, 6EH, 2DH, 73H       ; 03D8 _ r.warn-s
        db 74H, 61H, 63H, 6BH, 2DH, 65H, 6DH, 70H       ; 03E0 _ tack-emp
        db 74H, 79H, 00H, 7AH, 65H, 72H, 6FH, 69H       ; 03E8 _ ty.zeroi
        db 6EH, 67H, 00H, 7AH, 65H, 78H, 74H, 2DH       ; 03F0 _ ng.zext-
        db 72H, 65H, 6CH, 6FH, 63H, 00H, 6FH, 74H       ; 03F8 _ reloc.ot
        db 68H, 65H, 72H, 00H, 61H, 6CH, 6CH, 00H       ; 0400 _ her.all.
        db 62H, 61H, 64H, 2DH, 70H, 72H, 61H, 67H       ; 0408 _ bad-prag
        db 6DH, 61H, 00H, 62H, 6EH, 64H, 00H, 65H       ; 0410 _ ma.bnd.e
        db 6EH, 76H, 69H, 72H, 6FH, 6EH, 6DH, 65H       ; 0418 _ nvironme
        db 6EH, 74H, 00H, 68H, 6CH, 65H, 00H, 6CH       ; 0420 _ nt.hle.l
        db 6FH, 63H, 6BH, 00H, 6DH, 61H, 63H, 72H       ; 0428 _ ock.macr
        db 6FH, 2DH, 64H, 65H, 66H, 2DH, 63H, 61H       ; 0430 _ o-def-ca
        db 73H, 65H, 2DH, 73H, 69H, 6EH, 67H, 6CH       ; 0438 _ se-singl
        db 65H, 00H, 6DH, 61H, 63H, 72H, 6FH, 2DH       ; 0440 _ e.macro-
        db 64H, 65H, 66H, 2DH, 67H, 72H, 65H, 65H       ; 0448 _ def-gree
        db 64H, 79H, 2DH, 73H, 69H, 6EH, 67H, 6CH       ; 0450 _ dy-singl
        db 65H, 00H, 6DH, 61H, 63H, 72H, 6FH, 2DH       ; 0458 _ e.macro-
        db 64H, 65H, 66H, 2DH, 70H, 61H, 72H, 61H       ; 0460 _ def-para
        db 6DH, 2DH, 73H, 69H, 6EH, 67H, 6CH, 65H       ; 0468 _ m-single
        db 00H, 6DH, 61H, 63H, 72H, 6FH, 2DH, 64H       ; 0470 _ .macro-d
        db 65H, 66H, 61H, 75H, 6CH, 74H, 73H, 00H       ; 0478 _ efaults.
        db 6DH, 61H, 63H, 72H, 6FH, 2DH, 70H, 61H       ; 0480 _ macro-pa
        db 72H, 61H, 6DH, 73H, 2DH, 6CH, 65H, 67H       ; 0488 _ rams-leg
        db 61H, 63H, 79H, 00H, 6DH, 61H, 63H, 72H       ; 0490 _ acy.macr
        db 6FH, 2DH, 70H, 61H, 72H, 61H, 6DH, 73H       ; 0498 _ o-params
        db 2DH, 6DH, 75H, 6CH, 74H, 69H, 00H, 6DH       ; 04A0 _ -multi.m
        db 61H, 63H, 72H, 6FH, 2DH, 70H, 61H, 72H       ; 04A8 _ acro-par
        db 61H, 6DH, 73H, 2DH, 73H, 69H, 6EH, 67H       ; 04B0 _ ams-sing
        db 6CH, 65H, 00H, 6EH, 65H, 67H, 61H, 74H       ; 04B8 _ le.negat
        db 69H, 76H, 65H, 2DH, 72H, 65H, 70H, 00H       ; 04C0 _ ive-rep.
        db 6EH, 6FH, 74H, 2DH, 6DH, 79H, 2DH, 70H       ; 04C8 _ not-my-p
        db 72H, 61H, 67H, 6DH, 61H, 00H, 6FH, 72H       ; 04D0 _ ragma.or
        db 70H, 68H, 61H, 6EH, 2DH, 6CH, 61H, 62H       ; 04D8 _ phan-lab
        db 65H, 6CH, 73H, 00H, 75H, 6EH, 6BH, 6EH       ; 04E0 _ els.unkn
        db 6FH, 77H, 6EH, 2DH, 70H, 72H, 61H, 67H       ; 04E8 _ own-prag
        db 6DH, 61H, 00H, 00H, 00H, 00H, 00H, 00H       ; 04F0 _ ma......
        db 6EH, 6FH, 20H, 6FH, 70H, 65H, 72H, 61H       ; 04F8 _ no opera
        db 6EH, 64H, 20H, 66H, 6FH, 72H, 20H, 64H       ; 0500 _ nd for d
        db 61H, 74H, 61H, 20H, 64H, 65H, 63H, 6CH       ; 0508 _ ata decl
        db 61H, 72H, 61H, 74H, 69H, 6FH, 6EH, 00H       ; 0510 _ aration.
        db 67H, 61H, 72H, 62H, 61H, 67H, 65H, 20H       ; 0518 _ garbage 
        db 61H, 66H, 74H, 65H, 72H, 20H, 64H, 69H       ; 0520 _ after di
        db 72H, 65H, 63H, 74H, 69H, 76H, 65H, 00H       ; 0528 _ rective.
        db 61H, 62H, 73H, 6FH, 6CH, 75H, 74H, 65H       ; 0530 _ absolute
        db 20H, 61H, 64H, 64H, 72H, 65H, 73H, 73H       ; 0538 _  address
        db 20H, 63H, 61H, 6EH, 6EH, 6FH, 74H, 20H       ; 0540 _  cannot 
        db 62H, 65H, 20H, 52H, 49H, 50H, 2DH, 72H       ; 0548 _ be RIP-r
        db 65H, 6CH, 61H, 74H, 69H, 76H, 65H, 00H       ; 0550 _ elative.
        db 64H, 69H, 73H, 70H, 6CH, 61H, 63H, 65H       ; 0558 _ displace
        db 6DH, 65H, 6EH, 74H, 20H, 73H, 69H, 7AH       ; 0560 _ ment siz
        db 65H, 20H, 69H, 67H, 6EH, 6FH, 72H, 65H       ; 0568 _ e ignore
        db 64H, 20H, 6FH, 6EH, 20H, 61H, 62H, 73H       ; 0570 _ d on abs
        db 6FH, 6CH, 75H, 74H, 65H, 20H, 61H, 64H       ; 0578 _ olute ad
        db 64H, 72H, 65H, 73H, 73H, 00H, 66H, 6CH       ; 0580 _ dress.fl
        db 6FH, 61H, 74H, 69H, 6EH, 67H, 20H, 70H       ; 0588 _ oating p
        db 6FH, 69H, 6EH, 74H, 20H, 64H, 65H, 6EH       ; 0590 _ oint den
        db 6FH, 72H, 6DH, 61H, 6CH, 00H, 66H, 6CH       ; 0598 _ ormal.fl
        db 6FH, 61H, 74H, 69H, 6EH, 67H, 20H, 70H       ; 05A0 _ oating p
        db 6FH, 69H, 6EH, 74H, 20H, 6FH, 76H, 65H       ; 05A8 _ oint ove
        db 72H, 66H, 6CH, 6FH, 77H, 00H, 00H, 00H       ; 05B0 _ rflow...
        db 74H, 6FH, 6FH, 20H, 6DH, 61H, 6EH, 79H       ; 05B8 _ too many
        db 20H, 64H, 69H, 67H, 69H, 74H, 73H, 20H       ; 05C0 _  digits 
        db 69H, 6EH, 20H, 66H, 6CH, 6FH, 61H, 74H       ; 05C8 _ in float
        db 69H, 6EH, 67H, 2DH, 70H, 6FH, 69H, 6EH       ; 05D0 _ ing-poin
        db 74H, 20H, 6EH, 75H, 6DH, 62H, 65H, 72H       ; 05D8 _ t number
        db 00H, 66H, 6CH, 6FH, 61H, 74H, 69H, 6EH       ; 05E0 _ .floatin
        db 67H, 20H, 70H, 6FH, 69H, 6EH, 74H, 20H       ; 05E8 _ g point 
        db 75H, 6EH, 64H, 65H, 72H, 66H, 6CH, 6FH       ; 05F0 _ underflo
        db 77H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 05F8 _ w.......
        db 66H, 6FH, 72H, 77H, 61H, 72H, 64H, 20H       ; 0600 _ forward 
        db 72H, 65H, 66H, 65H, 72H, 65H, 6EH, 63H       ; 0608 _ referenc
        db 65H, 20H, 6DH, 61H, 79H, 20H, 68H, 61H       ; 0610 _ e may ha
        db 76H, 65H, 20H, 75H, 6EH, 70H, 72H, 65H       ; 0618 _ ve unpre
        db 64H, 69H, 63H, 74H, 61H, 62H, 6CH, 65H       ; 0620 _ dictable
        db 20H, 72H, 65H, 73H, 75H, 6CH, 74H, 73H       ; 0628 _  results
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0630 _ ........
        db 69H, 6DH, 70H, 6CH, 69H, 63H, 69H, 74H       ; 0638 _ implicit
        db 20H, 44H, 45H, 46H, 41H, 55H, 4CH, 54H       ; 0640 _  DEFAULT
        db 20H, 41H, 42H, 53H, 20H, 69H, 73H, 20H       ; 0648 _  ABS is 
        db 64H, 65H, 70H, 72H, 65H, 63H, 61H, 74H       ; 0650 _ deprecat
        db 65H, 64H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0658 _ ed......
        db 6CH, 61H, 62H, 65H, 6CH, 73H, 20H, 61H       ; 0660 _ labels a
        db 6CH, 6FH, 6EH, 65H, 20H, 6FH, 6EH, 20H       ; 0668 _ lone on 
        db 6CH, 69H, 6EH, 65H, 73H, 20H, 77H, 69H       ; 0670 _ lines wi
        db 74H, 68H, 6FH, 75H, 74H, 20H, 74H, 72H       ; 0678 _ thout tr
        db 61H, 69H, 6CH, 69H, 6EH, 67H, 20H, 3AH       ; 0680 _ ailing :
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0688 _ ........
        db 6CH, 61H, 62H, 65H, 6CH, 20H, 72H, 65H       ; 0690 _ label re
        db 64H, 65H, 66H, 69H, 6EH, 65H, 64H, 20H       ; 0698 _ defined 
        db 74H, 6FH, 20H, 61H, 6EH, 20H, 69H, 64H       ; 06A0 _ to an id
        db 65H, 6EH, 74H, 69H, 63H, 61H, 6CH, 20H       ; 06A8 _ entical 
        db 76H, 61H, 6CH, 75H, 65H, 00H, 00H, 00H       ; 06B0 _ value...
        db 6CH, 61H, 62H, 65H, 6CH, 20H, 28H, 72H       ; 06B8 _ label (r
        db 65H, 29H, 64H, 65H, 66H, 69H, 6EH, 65H       ; 06C0 _ e)define
        db 64H, 20H, 64H, 75H, 72H, 69H, 6EH, 67H       ; 06C8 _ d during
        db 20H, 63H, 6FH, 64H, 65H, 20H, 67H, 65H       ; 06D0 _  code ge
        db 6EH, 65H, 72H, 61H, 74H, 69H, 6FH, 6EH       ; 06D8 _ neration
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 06E0 _ ........
        db 24H, 20H, 70H, 72H, 65H, 66H, 69H, 78H       ; 06E8 _ $ prefix
        db 20H, 66H, 6FH, 72H, 20H, 68H, 65H, 78H       ; 06F0 _  for hex
        db 61H, 64H, 65H, 63H, 69H, 6DH, 61H, 6CH       ; 06F8 _ adecimal
        db 20H, 69H, 73H, 20H, 64H, 65H, 70H, 72H       ; 0700 _  is depr
        db 65H, 63H, 61H, 74H, 65H, 64H, 00H, 6EH       ; 0708 _ ecated.n
        db 75H, 6DH, 65H, 72H, 69H, 63H, 20H, 63H       ; 0710 _ umeric c
        db 6FH, 6EH, 73H, 74H, 61H, 6EH, 74H, 20H       ; 0718 _ onstant 
        db 64H, 6FH, 65H, 73H, 20H, 6EH, 6FH, 74H       ; 0720 _ does not
        db 20H, 66H, 69H, 74H, 00H, 00H, 00H, 00H       ; 0728 _  fit....
        db 69H, 6EH, 73H, 74H, 72H, 75H, 63H, 74H       ; 0730 _ instruct
        db 69H, 6FH, 6EH, 20H, 6FH, 62H, 73H, 6FH       ; 0738 _ ion obso
        db 6CH, 65H, 74H, 65H, 20H, 61H, 6EH, 64H       ; 0740 _ lete and
        db 20H, 69H, 73H, 20H, 61H, 20H, 6EH, 6FH       ; 0748 _  is a no
        db 6FH, 70H, 20H, 6FH, 6EH, 20H, 74H, 68H       ; 0750 _ op on th
        db 65H, 20H, 74H, 61H, 72H, 67H, 65H, 74H       ; 0758 _ e target
        db 20H, 43H, 50H, 55H, 00H, 00H, 00H, 00H       ; 0760 _  CPU....
        db 69H, 6EH, 73H, 74H, 72H, 75H, 63H, 74H       ; 0768 _ instruct
        db 69H, 6FH, 6EH, 20H, 6FH, 62H, 73H, 6FH       ; 0770 _ ion obso
        db 6CH, 65H, 74H, 65H, 20H, 61H, 6EH, 64H       ; 0778 _ lete and
        db 20H, 72H, 65H, 6DH, 6FH, 76H, 65H, 64H       ; 0780 _  removed
        db 20H, 6FH, 6EH, 20H, 74H, 68H, 65H, 20H       ; 0788 _  on the 
        db 74H, 61H, 72H, 67H, 65H, 74H, 20H, 43H       ; 0790 _ target C
        db 50H, 55H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0798 _ PU......
        db 69H, 6EH, 73H, 74H, 72H, 75H, 63H, 74H       ; 07A0 _ instruct
        db 69H, 6FH, 6EH, 20H, 6FH, 62H, 73H, 6FH       ; 07A8 _ ion obso
        db 6CH, 65H, 74H, 65H, 20H, 62H, 75H, 74H       ; 07B0 _ lete but
        db 20H, 76H, 61H, 6CH, 69H, 64H, 20H, 6FH       ; 07B8 _  valid o
        db 6EH, 20H, 74H, 68H, 65H, 20H, 74H, 61H       ; 07C0 _ n the ta
        db 72H, 67H, 65H, 74H, 20H, 43H, 50H, 55H       ; 07C8 _ rget CPU
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 07D0 _ ........
        db 70H, 68H, 61H, 73H, 65H, 20H, 65H, 72H       ; 07D8 _ phase er
        db 72H, 6FH, 72H, 20H, 64H, 75H, 72H, 69H       ; 07E0 _ ror duri
        db 6EH, 67H, 20H, 73H, 74H, 61H, 62H, 69H       ; 07E8 _ ng stabi
        db 6CH, 69H, 7AH, 61H, 74H, 69H, 6FH, 6EH       ; 07F0 _ lization
        db 00H, 25H, 65H, 6CH, 69H, 66H, 20H, 61H       ; 07F8 _ .%elif a
        db 66H, 74H, 65H, 72H, 20H, 25H, 65H, 6CH       ; 0800 _ fter %el
        db 73H, 65H, 00H, 25H, 65H, 6CH, 73H, 65H       ; 0808 _ se.%else
        db 20H, 61H, 66H, 74H, 65H, 72H, 20H, 25H       ; 0810 _  after %
        db 65H, 6CH, 73H, 65H, 00H, 65H, 6DH, 70H       ; 0818 _ else.emp
        db 74H, 79H, 20H, 25H, 7BH, 7DH, 20H, 63H       ; 0820 _ ty %{} c
        db 6FH, 6EH, 73H, 74H, 72H, 75H, 63H, 74H       ; 0828 _ onstruct
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0830 _ ........
        db 6EH, 6FH, 6EH, 65H, 78H, 69H, 73H, 74H       ; 0838 _ nonexist
        db 65H, 6EH, 74H, 20H, 65H, 6EH, 76H, 69H       ; 0840 _ ent envi
        db 72H, 6FH, 6EH, 6DH, 65H, 6EH, 74H, 20H       ; 0848 _ ronment 
        db 76H, 61H, 72H, 69H, 61H, 62H, 6CH, 65H       ; 0850 _ variable
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0858 _ ........
        db 73H, 69H, 6EH, 67H, 6CH, 65H, 2DH, 6CH       ; 0860 _ single-l
        db 69H, 6EH, 65H, 20H, 6DH, 61H, 63H, 72H       ; 0868 _ ine macr
        db 6FH, 20H, 64H, 65H, 66H, 69H, 6EH, 65H       ; 0870 _ o define
        db 64H, 20H, 62H, 6FH, 74H, 68H, 20H, 63H       ; 0878 _ d both c
        db 61H, 73H, 65H, 20H, 73H, 65H, 6EH, 73H       ; 0880 _ ase sens
        db 69H, 74H, 69H, 76H, 65H, 20H, 61H, 6EH       ; 0888 _ itive an
        db 64H, 20H, 69H, 6EH, 73H, 65H, 6EH, 73H       ; 0890 _ d insens
        db 69H, 74H, 69H, 76H, 65H, 00H, 73H, 69H       ; 0898 _ itive.si
        db 6EH, 67H, 6CH, 65H, 2DH, 6CH, 69H, 6EH       ; 08A0 _ ngle-lin
        db 65H, 20H, 6DH, 61H, 63H, 72H, 6FH, 00H       ; 08A8 _ e macro.
        db 73H, 69H, 6EH, 67H, 6CH, 65H, 2DH, 6CH       ; 08B0 _ single-l
        db 69H, 6EH, 65H, 20H, 6DH, 61H, 63H, 72H       ; 08B8 _ ine macr
        db 6FH, 20H, 64H, 65H, 66H, 69H, 6EH, 65H       ; 08C0 _ o define
        db 64H, 20H, 77H, 69H, 74H, 68H, 20H, 61H       ; 08C8 _ d with a
        db 6EH, 64H, 20H, 77H, 69H, 74H, 68H, 6FH       ; 08D0 _ nd witho
        db 75H, 74H, 20H, 70H, 61H, 72H, 61H, 6DH       ; 08D8 _ ut param
        db 65H, 74H, 65H, 72H, 73H, 00H, 00H, 00H       ; 08E0 _ eters...
        db 6DH, 61H, 63H, 72H, 6FH, 73H, 20H, 77H       ; 08E8 _ macros w
        db 69H, 74H, 68H, 20H, 6DH, 6FH, 72H, 65H       ; 08F0 _ ith more
        db 20H, 64H, 65H, 66H, 61H, 75H, 6CH, 74H       ; 08F8 _  default
        db 20H, 74H, 68H, 61H, 6EH, 20H, 6FH, 70H       ; 0900 _  than op
        db 74H, 69H, 6FH, 6EH, 61H, 6CH, 20H, 70H       ; 0908 _ tional p
        db 61H, 72H, 61H, 6DH, 65H, 74H, 65H, 72H       ; 0910 _ arameter
        db 73H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0918 _ s.......
        db 69H, 6DH, 70H, 72H, 6FH, 70H, 65H, 72H       ; 0920 _ improper
        db 6CH, 79H, 20H, 63H, 61H, 6CH, 6CH, 69H       ; 0928 _ ly calli
        db 6EH, 67H, 20H, 6DH, 75H, 6CH, 74H, 69H       ; 0930 _ ng multi
        db 2DH, 6CH, 69H, 6EH, 65H, 20H, 6DH, 61H       ; 0938 _ -line ma
        db 63H, 72H, 6FH, 20H, 66H, 6FH, 72H, 20H       ; 0940 _ cro for 
        db 6CH, 65H, 67H, 61H, 63H, 79H, 20H, 73H       ; 0948 _ legacy s
        db 75H, 70H, 70H, 6FH, 72H, 74H, 00H, 00H       ; 0950 _ upport..
        db 6DH, 75H, 6CH, 74H, 69H, 2DH, 6CH, 69H       ; 0958 _ multi-li
        db 6EH, 65H, 20H, 6DH, 61H, 63H, 72H, 6FH       ; 0960 _ ne macro
        db 20H, 63H, 61H, 6CH, 6CH, 73H, 20H, 77H       ; 0968 _  calls w
        db 69H, 74H, 68H, 20H, 77H, 72H, 6FH, 6EH       ; 0970 _ ith wron
        db 67H, 20H, 70H, 61H, 72H, 61H, 6DH, 65H       ; 0978 _ g parame
        db 74H, 65H, 72H, 20H, 63H, 6FH, 75H, 6EH       ; 0980 _ ter coun
        db 74H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0988 _ t.......
        db 73H, 69H, 6EH, 67H, 6CH, 65H, 2DH, 6CH       ; 0990 _ single-l
        db 69H, 6EH, 65H, 20H, 6DH, 61H, 63H, 72H       ; 0998 _ ine macr
        db 6FH, 20H, 63H, 61H, 6CH, 6CH, 73H, 20H       ; 09A0 _ o calls 
        db 77H, 69H, 74H, 68H, 20H, 77H, 72H, 6FH       ; 09A8 _ with wro
        db 6EH, 67H, 20H, 70H, 61H, 72H, 61H, 6DH       ; 09B0 _ ng param
        db 65H, 74H, 65H, 72H, 20H, 63H, 6FH, 75H       ; 09B8 _ eter cou
        db 6EH, 74H, 00H, 72H, 65H, 64H, 65H, 66H       ; 09C0 _ nt.redef
        db 69H, 6EH, 69H, 6EH, 67H, 20H, 6DH, 75H       ; 09C8 _ ining mu
        db 6CH, 74H, 69H, 2DH, 6CH, 69H, 6EH, 65H       ; 09D0 _ lti-line
        db 20H, 6DH, 61H, 63H, 72H, 6FH, 00H, 75H       ; 09D8 _  macro.u
        db 6EH, 74H, 65H, 72H, 6DH, 69H, 6EH, 61H       ; 09E0 _ ntermina
        db 74H, 65H, 64H, 20H, 25H, 7BH, 2EH, 2EH       ; 09E8 _ ted %{..
        db 2EH, 7DH, 00H, 75H, 6EH, 74H, 65H, 72H       ; 09F0 _ .}.unter
        db 6DH, 69H, 6EH, 61H, 74H, 65H, 64H, 20H       ; 09F8 _ minated 
        db 25H, 5BH, 2EH, 2EH, 2EH, 5DH, 00H, 75H       ; 0A00 _ %[...].u
        db 6EH, 74H, 65H, 72H, 6DH, 69H, 6EH, 61H       ; 0A08 _ ntermina
        db 74H, 65H, 64H, 20H, 73H, 74H, 72H, 69H       ; 0A10 _ ted stri
        db 6EH, 67H, 00H, 6EH, 65H, 67H, 61H, 74H       ; 0A18 _ ng.negat
        db 69H, 76H, 65H, 20H, 25H, 72H, 65H, 70H       ; 0A20 _ ive %rep
        db 20H, 63H, 6FH, 75H, 6EH, 74H, 00H, 00H       ; 0A28 _  count..
        db 72H, 65H, 73H, 65H, 72H, 76H, 65H, 64H       ; 0A30 _ reserved
        db 20H, 75H, 6EH, 69H, 6DH, 70H, 6CH, 65H       ; 0A38 _  unimple
        db 6DH, 65H, 6EH, 74H, 65H, 64H, 20H, 70H       ; 0A40 _ mented p
        db 72H, 65H, 70H, 72H, 6FH, 63H, 65H, 73H       ; 0A48 _ reproces
        db 73H, 6FH, 72H, 20H, 64H, 69H, 72H, 65H       ; 0A50 _ sor dire
        db 63H, 74H, 69H, 76H, 65H, 00H, 25H, 73H       ; 0A58 _ ctive.%s
        db 65H, 6CH, 28H, 29H, 20H, 61H, 72H, 67H       ; 0A60 _ el() arg
        db 75H, 6DH, 65H, 6EH, 74H, 20H, 6FH, 75H       ; 0A68 _ ument ou
        db 74H, 20H, 6FH, 66H, 20H, 72H, 61H, 6EH       ; 0A70 _ t of ran
        db 67H, 65H, 00H, 74H, 72H, 61H, 69H, 6CH       ; 0A78 _ ge.trail
        db 69H, 6EH, 67H, 20H, 67H, 61H, 72H, 62H       ; 0A80 _ ing garb
        db 61H, 67H, 65H, 20H, 69H, 67H, 6EH, 6FH       ; 0A88 _ age igno
        db 72H, 65H, 64H, 00H, 6DH, 61H, 6CH, 66H       ; 0A90 _ red.malf
        db 6FH, 72H, 6DH, 65H, 64H, 20H, 25H, 70H       ; 0A98 _ ormed %p
        db 72H, 61H, 67H, 6DH, 61H, 00H, 65H, 6DH       ; 0AA0 _ ragma.em
        db 70H, 74H, 79H, 20H, 25H, 70H, 72H, 61H       ; 0AA8 _ pty %pra
        db 67H, 6DH, 61H, 20H, 64H, 69H, 72H, 65H       ; 0AB0 _ gma dire
        db 63H, 74H, 69H, 76H, 65H, 00H, 00H, 00H       ; 0AB8 _ ctive...
        db 25H, 70H, 72H, 61H, 67H, 6DH, 61H, 20H       ; 0AC0 _ %pragma 
        db 6EH, 6FH, 74H, 20H, 61H, 70H, 70H, 6CH       ; 0AC8 _ not appl
        db 69H, 63H, 61H, 62H, 6CH, 65H, 20H, 74H       ; 0AD0 _ icable t
        db 6FH, 20H, 74H, 68H, 69H, 73H, 20H, 63H       ; 0AD8 _ o this c
        db 6FH, 6DH, 70H, 69H, 6CH, 61H, 74H, 69H       ; 0AE0 _ ompilati
        db 6FH, 6EH, 00H, 00H, 00H, 00H, 00H, 00H       ; 0AE8 _ on......
        db 75H, 6EH, 6BH, 6EH, 6FH, 77H, 6EH, 20H       ; 0AF0 _ unknown 
        db 25H, 70H, 72H, 61H, 67H, 6DH, 61H, 20H       ; 0AF8 _ %pragma 
        db 66H, 61H, 63H, 69H, 6CH, 69H, 74H, 79H       ; 0B00 _ facility
        db 20H, 6FH, 72H, 20H, 64H, 69H, 72H, 65H       ; 0B08 _  or dire
        db 63H, 74H, 69H, 76H, 65H, 00H, 00H, 00H       ; 0B10 _ ctive...
        db 6FH, 36H, 34H, 20H, 70H, 72H, 65H, 66H       ; 0B18 _ o64 pref
        db 69H, 78H, 20H, 69H, 6EH, 76H, 61H, 6CH       ; 0B20 _ ix inval
        db 69H, 64H, 20H, 69H, 6EH, 20H, 31H, 36H       ; 0B28 _ id in 16
        db 2FH, 33H, 32H, 2DH, 62H, 69H, 74H, 20H       ; 0B30 _ /32-bit 
        db 6DH, 6FH, 64H, 65H, 00H, 69H, 6EH, 76H       ; 0B38 _ mode.inv
        db 61H, 6CH, 69H, 64H, 20H, 42H, 4EH, 44H       ; 0B40 _ alid BND
        db 20H, 70H, 72H, 65H, 66H, 69H, 78H, 00H       ; 0B48 _  prefix.
        db 69H, 6EH, 76H, 61H, 6CH, 69H, 64H, 20H       ; 0B50 _ invalid 
        db 62H, 72H, 61H, 6EH, 63H, 68H, 20H, 68H       ; 0B58 _ branch h
        db 69H, 6EH, 74H, 20H, 70H, 72H, 65H, 66H       ; 0B60 _ int pref
        db 69H, 78H, 20H, 64H, 72H, 6FH, 70H, 70H       ; 0B68 _ ix dropp
        db 65H, 64H, 00H, 69H, 6EH, 76H, 61H, 6CH       ; 0B70 _ ed.inval
        db 69H, 64H, 20H, 48H, 4CH, 45H, 20H, 70H       ; 0B78 _ id HLE p
        db 72H, 65H, 66H, 69H, 78H, 00H, 00H, 00H       ; 0B80 _ refix...
        db 69H, 6EH, 76H, 61H, 6CH, 69H, 64H, 20H       ; 0B88 _ invalid 
        db 70H, 72H, 65H, 66H, 69H, 78H, 20H, 66H       ; 0B90 _ prefix f
        db 6FH, 72H, 20H, 69H, 6EH, 73H, 74H, 72H       ; 0B98 _ or instr
        db 75H, 63H, 74H, 69H, 6FH, 6EH, 00H, 00H       ; 0BA0 _ uction..
        db 4CH, 4FH, 43H, 4BH, 20H, 70H, 72H, 65H       ; 0BA8 _ LOCK pre
        db 66H, 69H, 78H, 20H, 6FH, 6EH, 20H, 75H       ; 0BB0 _ fix on u
        db 6EH, 6CH, 6FH, 63H, 6BH, 61H, 62H, 6CH       ; 0BB8 _ nlockabl
        db 65H, 20H, 69H, 6EH, 73H, 74H, 72H, 75H       ; 0BC0 _ e instru
        db 63H, 74H, 69H, 6FH, 6EH, 00H, 00H, 00H       ; 0BC8 _ ction...
        db 73H, 75H, 70H, 65H, 72H, 66H, 6CH, 75H       ; 0BD0 _ superflu
        db 6FH, 75H, 73H, 20H, 4CH, 4FH, 43H, 4BH       ; 0BD8 _ ous LOCK
        db 20H, 70H, 72H, 65H, 66H, 69H, 78H, 20H       ; 0BE0 _  prefix 
        db 6FH, 6EH, 20H, 58H, 43H, 48H, 47H, 20H       ; 0BE8 _ on XCHG 
        db 69H, 6EH, 73H, 74H, 72H, 75H, 63H, 74H       ; 0BF0 _ instruct
        db 69H, 6FH, 6EH, 00H, 69H, 6EH, 76H, 61H       ; 0BF8 _ ion.inva
        db 6CH, 69H, 64H, 20H, 6FH, 70H, 65H, 72H       ; 0C00 _ lid oper
        db 61H, 6EH, 64H, 20H, 73H, 69H, 7AH, 65H       ; 0C08 _ and size
        db 20H, 70H, 72H, 65H, 66H, 69H, 78H, 00H       ; 0C10 _  prefix.
        db 73H, 65H, 67H, 6DH, 65H, 6EH, 74H, 20H       ; 0C18 _ segment 
        db 70H, 72H, 65H, 66H, 69H, 78H, 20H, 69H       ; 0C20 _ prefix i
        db 67H, 6EH, 6FH, 72H, 65H, 64H, 20H, 69H       ; 0C28 _ gnored i
        db 6EH, 20H, 36H, 34H, 2DH, 62H, 69H, 74H       ; 0C30 _ n 64-bit
        db 20H, 6DH, 6FH, 64H, 65H, 00H, 00H, 00H       ; 0C38 _  mode...
        db 6EH, 6FH, 6EH, 2DH, 4EH, 41H, 53H, 4DH       ; 0C40 _ non-NASM
        db 20H, 6BH, 65H, 79H, 77H, 6FH, 72H, 64H       ; 0C48 _  keyword
        db 20H, 75H, 73H, 65H, 64H, 20H, 69H, 6EH       ; 0C50 _  used in
        db 20H, 6FH, 74H, 68H, 65H, 72H, 20H, 61H       ; 0C58 _  other a
        db 73H, 73H, 65H, 6DH, 62H, 6CH, 65H, 72H       ; 0C60 _ ssembler
        db 73H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0C68 _ s.......
        db 72H, 65H, 67H, 69H, 73H, 74H, 65H, 72H       ; 0C70 _ register
        db 20H, 73H, 69H, 7AH, 65H, 20H, 73H, 70H       ; 0C78 _  size sp
        db 65H, 63H, 69H, 66H, 69H, 63H, 61H, 74H       ; 0C80 _ ecificat
        db 69H, 6FH, 6EH, 20H, 69H, 67H, 6EH, 6FH       ; 0C88 _ ion igno
        db 72H, 65H, 64H, 00H, 00H, 00H, 00H, 00H       ; 0C90 _ red.....
        db 38H, 2DH, 62H, 69H, 74H, 20H, 61H, 62H       ; 0C98 _ 8-bit ab
        db 73H, 6FH, 6CH, 75H, 74H, 65H, 20H, 73H       ; 0CA0 _ solute s
        db 65H, 63H, 74H, 69H, 6FH, 6EH, 2DH, 63H       ; 0CA8 _ ection-c
        db 72H, 6FH, 73H, 73H, 69H, 6EH, 67H, 20H       ; 0CB0 _ rossing 
        db 72H, 65H, 6CH, 6FH, 63H, 61H, 74H, 69H       ; 0CB8 _ relocati
        db 6FH, 6EH, 00H, 00H, 00H, 00H, 00H, 00H       ; 0CC0 _ on......
        db 33H, 32H, 2DH, 62H, 69H, 74H, 20H, 61H       ; 0CC8 _ 32-bit a
        db 62H, 73H, 6FH, 6CH, 75H, 74H, 65H, 20H       ; 0CD0 _ bsolute 
        db 73H, 65H, 63H, 74H, 69H, 6FH, 6EH, 2DH       ; 0CD8 _ section-
        db 63H, 72H, 6FH, 73H, 73H, 69H, 6EH, 67H       ; 0CE0 _ crossing
        db 20H, 72H, 65H, 6CH, 6FH, 63H, 61H, 74H       ; 0CE8 _  relocat
        db 69H, 6FH, 6EH, 00H, 00H, 00H, 00H, 00H       ; 0CF0 _ ion.....
        db 36H, 34H, 2DH, 62H, 69H, 74H, 20H, 61H       ; 0CF8 _ 64-bit a
        db 62H, 73H, 6FH, 6CH, 75H, 74H, 65H, 20H       ; 0D00 _ bsolute 
        db 73H, 65H, 63H, 74H, 69H, 6FH, 6EH, 2DH       ; 0D08 _ section-
        db 63H, 72H, 6FH, 73H, 73H, 69H, 6EH, 67H       ; 0D10 _ crossing
        db 20H, 72H, 65H, 6CH, 6FH, 63H, 61H, 74H       ; 0D18 _  relocat
        db 69H, 6FH, 6EH, 00H, 00H, 00H, 00H, 00H       ; 0D20 _ ion.....
        db 31H, 36H, 2DH, 62H, 69H, 74H, 20H, 61H       ; 0D28 _ 16-bit a
        db 62H, 73H, 6FH, 6CH, 75H, 74H, 65H, 20H       ; 0D30 _ bsolute 
        db 73H, 65H, 63H, 74H, 69H, 6FH, 6EH, 2DH       ; 0D38 _ section-
        db 63H, 72H, 6FH, 73H, 73H, 69H, 6EH, 67H       ; 0D40 _ crossing
        db 20H, 72H, 65H, 6CH, 6FH, 63H, 61H, 74H       ; 0D48 _  relocat
        db 69H, 6FH, 6EH, 00H, 00H, 00H, 00H, 00H       ; 0D50 _ ion.....
        db 38H, 2DH, 62H, 69H, 74H, 20H, 72H, 65H       ; 0D58 _ 8-bit re
        db 6CH, 61H, 74H, 69H, 76H, 65H, 20H, 73H       ; 0D60 _ lative s
        db 65H, 63H, 74H, 69H, 6FH, 6EH, 2DH, 63H       ; 0D68 _ ection-c
        db 72H, 6FH, 73H, 73H, 69H, 6EH, 67H, 20H       ; 0D70 _ rossing 
        db 72H, 65H, 6CH, 6FH, 63H, 61H, 74H, 69H       ; 0D78 _ relocati
        db 6FH, 6EH, 00H, 00H, 00H, 00H, 00H, 00H       ; 0D80 _ on......
        db 33H, 32H, 2DH, 62H, 69H, 74H, 20H, 72H       ; 0D88 _ 32-bit r
        db 65H, 6CH, 61H, 74H, 69H, 76H, 65H, 20H       ; 0D90 _ elative 
        db 73H, 65H, 63H, 74H, 69H, 6FH, 6EH, 2DH       ; 0D98 _ section-
        db 63H, 72H, 6FH, 73H, 73H, 69H, 6EH, 67H       ; 0DA0 _ crossing
        db 20H, 72H, 65H, 6CH, 6FH, 63H, 61H, 74H       ; 0DA8 _  relocat
        db 69H, 6FH, 6EH, 00H, 00H, 00H, 00H, 00H       ; 0DB0 _ ion.....
        db 36H, 34H, 2DH, 62H, 69H, 74H, 20H, 72H       ; 0DB8 _ 64-bit r
        db 65H, 6CH, 61H, 74H, 69H, 76H, 65H, 20H       ; 0DC0 _ elative 
        db 73H, 65H, 63H, 74H, 69H, 6FH, 6EH, 2DH       ; 0DC8 _ section-
        db 63H, 72H, 6FH, 73H, 73H, 69H, 6EH, 67H       ; 0DD0 _ crossing
        db 20H, 72H, 65H, 6CH, 6FH, 63H, 61H, 74H       ; 0DD8 _  relocat
        db 69H, 6FH, 6EH, 00H, 00H, 00H, 00H, 00H       ; 0DE0 _ ion.....
        db 31H, 36H, 2DH, 62H, 69H, 74H, 20H, 72H       ; 0DE8 _ 16-bit r
        db 65H, 6CH, 61H, 74H, 69H, 76H, 65H, 20H       ; 0DF0 _ elative 
        db 73H, 65H, 63H, 74H, 69H, 6FH, 6EH, 2DH       ; 0DF8 _ section-
        db 63H, 72H, 6FH, 73H, 73H, 69H, 6EH, 67H       ; 0E00 _ crossing
        db 20H, 72H, 65H, 6CH, 6FH, 63H, 61H, 74H       ; 0E08 _  relocat
        db 69H, 6FH, 6EH, 00H, 73H, 65H, 63H, 74H       ; 0E10 _ ion.sect
        db 69H, 6FH, 6EH, 20H, 61H, 6CH, 69H, 67H       ; 0E18 _ ion alig
        db 6EH, 6DH, 65H, 6EH, 74H, 20H, 72H, 6FH       ; 0E20 _ nment ro
        db 75H, 6EH, 64H, 65H, 64H, 20H, 75H, 70H       ; 0E28 _ unded up
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0E30 _ ........
        db 75H, 6EH, 6BH, 6EH, 6FH, 77H, 6EH, 20H       ; 0E38 _ unknown 
        db 77H, 61H, 72H, 6EH, 69H, 6EH, 67H, 20H       ; 0E40 _ warning 
        db 69H, 6EH, 20H, 2DH, 57H, 2FH, 2DH, 77H       ; 0E48 _ in -W/-w
        db 20H, 6FH, 72H, 20H, 77H, 61H, 72H, 6EH       ; 0E50 _  or warn
        db 69H, 6EH, 67H, 20H, 64H, 69H, 72H, 65H       ; 0E58 _ ing dire
        db 63H, 74H, 69H, 76H, 65H, 00H, 25H, 77H       ; 0E60 _ ctive.%w
        db 61H, 72H, 6EH, 69H, 6EH, 67H, 20H, 64H       ; 0E68 _ arning d
        db 69H, 72H, 65H, 63H, 74H, 69H, 76H, 65H       ; 0E70 _ irective
        db 73H, 00H, 77H, 61H, 72H, 6EH, 69H, 6EH       ; 0E78 _ s.warnin
        db 67H, 20H, 73H, 74H, 61H, 63H, 6BH, 20H       ; 0E80 _ g stack 
        db 65H, 6DH, 70H, 74H, 79H, 00H, 00H, 00H       ; 0E88 _ empty...
        db 52H, 45H, 53H, 78H, 20H, 69H, 6EH, 20H       ; 0E90 _ RESx in 
        db 69H, 6EH, 69H, 74H, 69H, 61H, 6CH, 69H       ; 0E98 _ initiali
        db 7AH, 65H, 64H, 20H, 73H, 65H, 63H, 74H       ; 0EA0 _ zed sect
        db 69H, 6FH, 6EH, 20H, 62H, 65H, 63H, 6FH       ; 0EA8 _ ion beco
        db 6DH, 65H, 73H, 20H, 7AH, 65H, 72H, 6FH       ; 0EB0 _ mes zero
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0EB8 _ ........
        db 72H, 65H, 6CH, 6FH, 63H, 61H, 74H, 69H       ; 0EC0 _ relocati
        db 6FH, 6EH, 20H, 7AH, 65H, 72H, 6FH, 2DH       ; 0EC8 _ on zero-
        db 65H, 78H, 74H, 65H, 6EH, 64H, 65H, 64H       ; 0ED0 _ extended
        db 20H, 74H, 6FH, 20H, 6DH, 61H, 74H, 63H       ; 0ED8 _  to matc
        db 68H, 20H, 6FH, 75H, 74H, 70H, 75H, 74H       ; 0EE0 _ h output
        db 20H, 66H, 6FH, 72H, 6DH, 61H, 74H, 00H       ; 0EE8 _  format.
        db 61H, 6EH, 79H, 20H, 77H, 61H, 72H, 6EH       ; 0EF0 _ any warn
        db 69H, 6EH, 67H, 20H, 6EH, 6FH, 74H, 20H       ; 0EF8 _ ing not 
        db 61H, 73H, 73H, 69H, 67H, 6EH, 65H, 64H       ; 0F00 _ assigned
        db 20H, 74H, 6FH, 20H, 61H, 20H, 73H, 70H       ; 0F08 _  to a sp
        db 65H, 63H, 69H, 66H, 69H, 63H, 20H, 77H       ; 0F10 _ ecific w
        db 61H, 72H, 6EH, 69H, 6EH, 67H, 20H, 63H       ; 0F18 _ arning c
        db 6CH, 61H, 73H, 73H, 00H, 61H, 6CH, 6CH       ; 0F20 _ lass.all
        db 20H, 70H, 6FH, 73H, 73H, 69H, 62H, 6CH       ; 0F28 _  possibl
        db 65H, 20H, 77H, 61H, 72H, 6EH, 69H, 6EH       ; 0F30 _ e warnin
        db 67H, 73H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0F38 _ gs......

warning_default:                                        ; byte
        db 01H, 01H, 03H, 01H, 01H, 00H, 01H, 01H       ; 0F40 _ ........
        db 00H, 01H, 01H, 01H, 00H, 03H, 01H, 01H       ; 0F48 _ ........
        db 01H, 01H, 01H, 00H, 01H, 01H, 01H, 01H       ; 0F50 _ ........
        db 01H, 01H, 03H, 01H, 01H, 01H, 01H, 01H       ; 0F58 _ ........
        db 01H, 01H, 01H, 01H, 01H, 01H, 01H, 00H       ; 0F60 _ ........
        db 00H, 00H, 00H, 03H, 01H, 01H, 01H, 01H       ; 0F68 _ ........
        db 01H, 01H, 01H, 01H, 01H, 01H, 00H, 00H       ; 0F70 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 01H, 00H       ; 0F78 _ ........
        db 01H, 01H, 01H, 01H, 01H                      ; 0F80 _ .....


SECTION .data.rel.ro.local align=32 noexec              ; section number 5, data

warning_name:                                           ; byte
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0000 _ ........
        dq Unnamed_4_0                                  ; 0008 _ 0000000000000000 (d)
        dq Unnamed_4_0+9H                               ; 0010 _ 0000000000000000 (d)
        dq Unnamed_4_0+1FH                              ; 0018 _ 0000000000000000 (d)
        dq Unnamed_4_0+2BH                              ; 0020 _ 0000000000000000 (d)
        dq Unnamed_4_0+37H                              ; 0028 _ 0000000000000000 (d)
        dq Unnamed_4_0+44H                              ; 0030 _ 0000000000000000 (d)
        dq Unnamed_4_0+53H                              ; 0038 _ 0000000000000000 (d)
        dq Unnamed_4_0+61H                              ; 0040 _ 0000000000000000 (d)
        dq Unnamed_4_0+71H                              ; 0048 _ 0000000000000000 (d)
        dq Unnamed_4_0+79H                              ; 0050 _ 0000000000000000 (d)
        dq Unnamed_4_0+91H                              ; 0058 _ 0000000000000000 (d)
        dq Unnamed_4_0+9EH                              ; 0060 _ 0000000000000000 (d)
        dq Unnamed_4_0+0AAH                             ; 0068 _ 0000000000000000 (d)
        dq Unnamed_4_0+0BBH                             ; 0070 _ 0000000000000000 (d)
        dq Unnamed_4_0+0D1H                             ; 0078 _ 0000000000000000 (d)
        dq Unnamed_4_0+0E1H                             ; 0080 _ 0000000000000000 (d)
        dq Unnamed_4_0+0EEH                             ; 0088 _ 0000000000000000 (d)
        dq Unnamed_4_0+0FFH                             ; 0090 _ 0000000000000000 (d)
        dq Unnamed_4_0+10EH                             ; 0098 _ 0000000000000000 (d)
        dq Unnamed_4_0+114H                             ; 00A0 _ 0000000000000000 (d)
        dq Unnamed_4_0+121H                             ; 00A8 _ 0000000000000000 (d)
        dq Unnamed_4_0+12EH                             ; 00B0 _ 0000000000000000 (d)
        dq Unnamed_4_0+13EH                             ; 00B8 _ 0000000000000000 (d)
        dq Unnamed_4_0+14DH                             ; 00C0 _ 0000000000000000 (d)
        dq Unnamed_4_0+166H                             ; 00C8 _ 0000000000000000 (d)
        dq Unnamed_4_0+181H                             ; 00D0 _ 0000000000000000 (d)
        dq Unnamed_4_0+19BH                             ; 00D8 _ 0000000000000000 (d)
        dq Unnamed_4_0+1ADH                             ; 00E0 _ 0000000000000000 (d)
        dq Unnamed_4_0+1C4H                             ; 00E8 _ 0000000000000000 (d)
        dq Unnamed_4_0+1DAH                             ; 00F0 _ 0000000000000000 (d)
        dq Unnamed_4_0+1F1H                             ; 00F8 _ 0000000000000000 (d)
        dq Unnamed_4_0+206H                             ; 0100 _ 0000000000000000 (d)
        dq Unnamed_4_0+215H                             ; 0108 _ 0000000000000000 (d)
        dq Unnamed_4_0+226H                             ; 0110 _ 0000000000000000 (d)
        dq Unnamed_4_0+235H                             ; 0118 _ 0000000000000000 (d)
        dq Unnamed_4_0+245H                             ; 0120 _ 0000000000000000 (d)
        dq Unnamed_4_0+251H                             ; 0128 _ 0000000000000000 (d)
        dq Unnamed_4_0+25EH                             ; 0130 _ 0000000000000000 (d)
        dq Unnamed_4_0+26AH                             ; 0138 _ 0000000000000000 (d)
        dq Unnamed_4_0+275H                             ; 0140 _ 0000000000000000 (d)
        dq Unnamed_4_0+282H                             ; 0148 _ 0000000000000000 (d)
        dq Unnamed_4_0+28CH                             ; 0150 _ 0000000000000000 (d)
        dq Unnamed_4_0+29BH                             ; 0158 _ 0000000000000000 (d)
        dq Unnamed_4_0+2AEH                             ; 0160 _ 0000000000000000 (d)
        dq Unnamed_4_0+2B9H                             ; 0168 _ 0000000000000000 (d)
        dq Unnamed_4_0+2CDH                             ; 0170 _ 0000000000000000 (d)
        dq Unnamed_4_0+2D8H                             ; 0178 _ 0000000000000000 (d)
        dq Unnamed_4_0+2E7H                             ; 0180 _ 0000000000000000 (d)
        dq Unnamed_4_0+2F9H                             ; 0188 _ 0000000000000000 (d)
        dq Unnamed_4_0+30AH                             ; 0190 _ 0000000000000000 (d)
        dq Unnamed_4_0+318H                             ; 0198 _ 0000000000000000 (d)
        dq Unnamed_4_0+323H                             ; 01A0 _ 0000000000000000 (d)
        dq Unnamed_4_0+327H                             ; 01A8 _ 0000000000000000 (d)
        dq Unnamed_4_0+32FH                             ; 01B0 _ 0000000000000000 (d)
        dq Unnamed_4_0+33EH                             ; 01B8 _ 0000000000000000 (d)
        dq Unnamed_4_0+34EH                             ; 01C0 _ 0000000000000000 (d)
        dq Unnamed_4_0+35EH                             ; 01C8 _ 0000000000000000 (d)
        dq Unnamed_4_0+36DH                             ; 01D0 _ 0000000000000000 (d)
        dq Unnamed_4_0+37CH                             ; 01D8 _ 0000000000000000 (d)
        dq Unnamed_4_0+38CH                             ; 01E0 _ 0000000000000000 (d)
        dq Unnamed_4_0+39CH                             ; 01E8 _ 0000000000000000 (d)
        dq Unnamed_4_0+3ABH                             ; 01F0 _ 0000000000000000 (d)
        dq Unnamed_4_0+3C5H                             ; 01F8 _ 0000000000000000 (d)
        dq Unnamed_4_0+3D5H                             ; 0200 _ 0000000000000000 (d)
        dq Unnamed_4_0+3DAH                             ; 0208 _ 0000000000000000 (d)
        dq Unnamed_4_0+3EBH                             ; 0210 _ 0000000000000000 (d)
        dq Unnamed_4_0+3F3H                             ; 0218 _ 0000000000000000 (d)
        dq Unnamed_4_0+3FEH                             ; 0220 _ 0000000000000000 (d)
        dq Unnamed_4_0+404H                             ; 0228 _ 0000000000000000 (d)
        dq 0000000000000000H                            ; 0230 _ 0000000000000000 
        dq 0000000000000000H                            ; 0238 _ 0000000000000000 

warning_alias:                                          ; byte
        dq Unnamed_4_0+404H                             ; 0240 _ 0000000000000000 (d)
        dq 0000000000000045H                            ; 0248 _ 0000000000000045 
        dq Unnamed_4_0+408H                             ; 0250 _ 0000000000000000 (d)
        dq 0000000000000027H                            ; 0258 _ 0000000000000027 
        dq Unnamed_4_0+413H                             ; 0260 _ 0000000000000000 (d)
        dq 000000000000002CH                            ; 0268 _ 000000000000002C 
        dq Unnamed_4_0                                  ; 0270 _ 0000000000000000 (d)
        dq 0000000000000001H                            ; 0278 _ 0000000000000001 
        dq Unnamed_4_0+9H                               ; 0280 _ 0000000000000000 (d)
        dq 0000000000000002H                            ; 0288 _ 0000000000000002 
        dq Unnamed_4_0+1FH                              ; 0290 _ 0000000000000000 (d)
        dq 0000000000000003H                            ; 0298 _ 0000000000000003 
        dq Unnamed_4_0+2BH                              ; 02A0 _ 0000000000000000 (d)
        dq 0000000000000004H                            ; 02A8 _ 0000000000000004 
        dq Unnamed_4_0+417H                             ; 02B0 _ 0000000000000000 (d)
        dq 0000000000000017H                            ; 02B8 _ 0000000000000017 
        dq Unnamed_4_0+37H                              ; 02C0 _ 0000000000000000 (d)
        dq 0000000000000005H                            ; 02C8 _ 0000000000000005 
        dq Unnamed_4_0+44H                              ; 02D0 _ 0000000000000000 (d)
        dq 0000000000000006H                            ; 02D8 _ 0000000000000006 
        dq Unnamed_4_0+53H                              ; 02E0 _ 0000000000000000 (d)
        dq 0000000000000007H                            ; 02E8 _ 0000000000000007 
        dq Unnamed_4_0+61H                              ; 02F0 _ 0000000000000000 (d)
        dq 0000000000000008H                            ; 02F8 _ 0000000000000008 
        dq Unnamed_4_0+71H                              ; 0300 _ 0000000000000000 (d)
        dq 0000000000000009H                            ; 0308 _ 0000000000000009 
        dq Unnamed_4_0+423H                             ; 0310 _ 0000000000000000 (d)
        dq 000000000000002EH                            ; 0318 _ 000000000000002E 
        dq Unnamed_4_0+79H                              ; 0320 _ 0000000000000000 (d)
        dq 000000000000000AH                            ; 0328 _ 000000000000000A 
        dq Unnamed_4_0+91H                              ; 0330 _ 0000000000000000 (d)
        dq 000000000000000BH                            ; 0338 _ 000000000000000B 
        dq Unnamed_4_0+9EH                              ; 0340 _ 0000000000000000 (d)
        dq 000000000000000CH                            ; 0348 _ 000000000000000C 
        dq Unnamed_4_0+0AAH                             ; 0350 _ 0000000000000000 (d)
        dq 000000000000000DH                            ; 0358 _ 000000000000000D 
        dq Unnamed_4_0+427H                             ; 0360 _ 0000000000000000 (d)
        dq 0000000000000030H                            ; 0368 _ 0000000000000030 
        dq Unnamed_4_0+42CH                             ; 0370 _ 0000000000000000 (d)
        dq 0000000000000018H                            ; 0378 _ 0000000000000018 
        dq Unnamed_4_0+442H                             ; 0380 _ 0000000000000000 (d)
        dq 0000000000000019H                            ; 0388 _ 0000000000000019 
        dq Unnamed_4_0+45AH                             ; 0390 _ 0000000000000000 (d)
        dq 000000000000001AH                            ; 0398 _ 000000000000001A 
        dq Unnamed_4_0+471H                             ; 03A0 _ 0000000000000000 (d)
        dq 000000000000001BH                            ; 03A8 _ 000000000000001B 
        dq Unnamed_4_0+480H                             ; 03B0 _ 0000000000000000 (d)
        dq 000000000000001CH                            ; 03B8 _ 000000000000001C 
        dq Unnamed_4_0+494H                             ; 03C0 _ 0000000000000000 (d)
        dq 000000000000001DH                            ; 03C8 _ 000000000000001D 
        dq Unnamed_4_0+4A7H                             ; 03D0 _ 0000000000000000 (d)
        dq 000000000000001EH                            ; 03D8 _ 000000000000001E 
        dq Unnamed_4_0+4BBH                             ; 03E0 _ 0000000000000000 (d)
        dq 0000000000000023H                            ; 03E8 _ 0000000000000023 
        dq Unnamed_4_0+4C8H                             ; 03F0 _ 0000000000000000 (d)
        dq 0000000000000029H                            ; 03F8 _ 0000000000000029 
        dq Unnamed_4_0+0BBH                             ; 0400 _ 0000000000000000 (d)
        dq 000000000000000EH                            ; 0408 _ 000000000000000E 
        dq Unnamed_4_0+0D1H                             ; 0410 _ 0000000000000000 (d)
        dq 000000000000000FH                            ; 0418 _ 000000000000000F 
        dq Unnamed_4_0+0E1H                             ; 0420 _ 0000000000000000 (d)
        dq 0000000000000010H                            ; 0428 _ 0000000000000010 
        dq Unnamed_4_0+0EEH                             ; 0430 _ 0000000000000000 (d)
        dq 0000000000000011H                            ; 0438 _ 0000000000000011 
        dq Unnamed_4_0+0FFH                             ; 0440 _ 0000000000000000 (d)
        dq 0000000000000012H                            ; 0448 _ 0000000000000012 
        dq Unnamed_4_0+4D6H                             ; 0450 _ 0000000000000000 (d)
        dq 000000000000000BH                            ; 0458 _ 000000000000000B 
        dq Unnamed_4_0+3FEH                             ; 0460 _ 0000000000000000 (d)
        dq 0000000000000044H                            ; 0468 _ 0000000000000044 
        dq Unnamed_4_0+10EH                             ; 0470 _ 0000000000000000 (d)
        dq 0000000000000013H                            ; 0478 _ 0000000000000013 
        dq Unnamed_4_0+114H                             ; 0480 _ 0000000000000000 (d)
        dq 0000000000000014H                            ; 0488 _ 0000000000000014 
        dq Unnamed_4_0+121H                             ; 0490 _ 0000000000000000 (d)
        dq 0000000000000015H                            ; 0498 _ 0000000000000015 
        dq Unnamed_4_0+12EH                             ; 04A0 _ 0000000000000000 (d)
        dq 0000000000000016H                            ; 04A8 _ 0000000000000016 
        dq Unnamed_4_0+13EH                             ; 04B0 _ 0000000000000000 (d)
        dq 0000000000000017H                            ; 04B8 _ 0000000000000017 
        dq Unnamed_4_0+14DH                             ; 04C0 _ 0000000000000000 (d)
        dq 0000000000000018H                            ; 04C8 _ 0000000000000018 
        dq Unnamed_4_0+166H                             ; 04D0 _ 0000000000000000 (d)
        dq 0000000000000019H                            ; 04D8 _ 0000000000000019 
        dq Unnamed_4_0+181H                             ; 04E0 _ 0000000000000000 (d)
        dq 000000000000001AH                            ; 04E8 _ 000000000000001A 
        dq Unnamed_4_0+19BH                             ; 04F0 _ 0000000000000000 (d)
        dq 000000000000001BH                            ; 04F8 _ 000000000000001B 
        dq Unnamed_4_0+1ADH                             ; 0500 _ 0000000000000000 (d)
        dq 000000000000001CH                            ; 0508 _ 000000000000001C 
        dq Unnamed_4_0+1C4H                             ; 0510 _ 0000000000000000 (d)
        dq 000000000000001DH                            ; 0518 _ 000000000000001D 
        dq Unnamed_4_0+1DAH                             ; 0520 _ 0000000000000000 (d)
        dq 000000000000001EH                            ; 0528 _ 000000000000001E 
        dq Unnamed_4_0+1F1H                             ; 0530 _ 0000000000000000 (d)
        dq 000000000000001FH                            ; 0538 _ 000000000000001F 
        dq Unnamed_4_0+206H                             ; 0540 _ 0000000000000000 (d)
        dq 0000000000000020H                            ; 0548 _ 0000000000000020 
        dq Unnamed_4_0+215H                             ; 0550 _ 0000000000000000 (d)
        dq 0000000000000021H                            ; 0558 _ 0000000000000021 
        dq Unnamed_4_0+226H                             ; 0560 _ 0000000000000000 (d)
        dq 0000000000000022H                            ; 0568 _ 0000000000000022 
        dq Unnamed_4_0+235H                             ; 0570 _ 0000000000000000 (d)
        dq 0000000000000023H                            ; 0578 _ 0000000000000023 
        dq Unnamed_4_0+245H                             ; 0580 _ 0000000000000000 (d)
        dq 0000000000000024H                            ; 0588 _ 0000000000000024 
        dq Unnamed_4_0+251H                             ; 0590 _ 0000000000000000 (d)
        dq 0000000000000025H                            ; 0598 _ 0000000000000025 
        dq Unnamed_4_0+25EH                             ; 05A0 _ 0000000000000000 (d)
        dq 0000000000000026H                            ; 05A8 _ 0000000000000026 
        dq Unnamed_4_0+26AH                             ; 05B0 _ 0000000000000000 (d)
        dq 0000000000000027H                            ; 05B8 _ 0000000000000027 
        dq Unnamed_4_0+275H                             ; 05C0 _ 0000000000000000 (d)
        dq 0000000000000028H                            ; 05C8 _ 0000000000000028 
        dq Unnamed_4_0+282H                             ; 05D0 _ 0000000000000000 (d)
        dq 0000000000000029H                            ; 05D8 _ 0000000000000029 
        dq Unnamed_4_0+28CH                             ; 05E0 _ 0000000000000000 (d)
        dq 000000000000002AH                            ; 05E8 _ 000000000000002A 
        dq Unnamed_4_0+29BH                             ; 05F0 _ 0000000000000000 (d)
        dq 000000000000002BH                            ; 05F8 _ 000000000000002B 
        dq Unnamed_4_0+2AEH                             ; 0600 _ 0000000000000000 (d)
        dq 000000000000002CH                            ; 0608 _ 000000000000002C 
        dq Unnamed_4_0+2B9H                             ; 0610 _ 0000000000000000 (d)
        dq 000000000000002DH                            ; 0618 _ 000000000000002D 
        dq Unnamed_4_0+2CDH                             ; 0620 _ 0000000000000000 (d)
        dq 000000000000002EH                            ; 0628 _ 000000000000002E 
        dq Unnamed_4_0+2D8H                             ; 0630 _ 0000000000000000 (d)
        dq 000000000000002FH                            ; 0638 _ 000000000000002F 
        dq Unnamed_4_0+2E7H                             ; 0640 _ 0000000000000000 (d)
        dq 0000000000000030H                            ; 0648 _ 0000000000000030 
        dq Unnamed_4_0+2F9H                             ; 0650 _ 0000000000000000 (d)
        dq 0000000000000031H                            ; 0658 _ 0000000000000031 
        dq Unnamed_4_0+30AH                             ; 0660 _ 0000000000000000 (d)
        dq 0000000000000032H                            ; 0668 _ 0000000000000032 
        dq Unnamed_4_0+318H                             ; 0670 _ 0000000000000000 (d)
        dq 0000000000000033H                            ; 0678 _ 0000000000000033 
        dq Unnamed_4_0+323H                             ; 0680 _ 0000000000000000 (d)
        dq 0000000000000034H                            ; 0688 _ 0000000000000034 
        dq Unnamed_4_0+327H                             ; 0690 _ 0000000000000000 (d)
        dq 0000000000000035H                            ; 0698 _ 0000000000000035 
        dq Unnamed_4_0+32FH                             ; 06A0 _ 0000000000000000 (d)
        dq 0000000000000036H                            ; 06A8 _ 0000000000000036 
        dq Unnamed_4_0+33EH                             ; 06B0 _ 0000000000000000 (d)
        dq 0000000000000037H                            ; 06B8 _ 0000000000000037 
        dq Unnamed_4_0+34EH                             ; 06C0 _ 0000000000000000 (d)
        dq 0000000000000038H                            ; 06C8 _ 0000000000000038 
        dq Unnamed_4_0+35EH                             ; 06D0 _ 0000000000000000 (d)
        dq 0000000000000039H                            ; 06D8 _ 0000000000000039 
        dq Unnamed_4_0+36DH                             ; 06E0 _ 0000000000000000 (d)
        dq 000000000000003AH                            ; 06E8 _ 000000000000003A 
        dq Unnamed_4_0+37CH                             ; 06F0 _ 0000000000000000 (d)
        dq 000000000000003BH                            ; 06F8 _ 000000000000003B 
        dq Unnamed_4_0+38CH                             ; 0700 _ 0000000000000000 (d)
        dq 000000000000003CH                            ; 0708 _ 000000000000003C 
        dq Unnamed_4_0+39CH                             ; 0710 _ 0000000000000000 (d)
        dq 000000000000003DH                            ; 0718 _ 000000000000003D 
        dq Unnamed_4_0+3ABH                             ; 0720 _ 0000000000000000 (d)
        dq 000000000000003EH                            ; 0728 _ 000000000000003E 
        dq Unnamed_4_0+4E4H                             ; 0730 _ 0000000000000000 (d)
        dq 000000000000002AH                            ; 0738 _ 000000000000002A 
        dq Unnamed_4_0+3C5H                             ; 0740 _ 0000000000000000 (d)
        dq 000000000000003FH                            ; 0748 _ 000000000000003F 
        dq Unnamed_4_0+3D5H                             ; 0750 _ 0000000000000000 (d)
        dq 0000000000000040H                            ; 0758 _ 0000000000000040 
        dq Unnamed_4_0+3DAH                             ; 0760 _ 0000000000000000 (d)
        dq 0000000000000041H                            ; 0768 _ 0000000000000041 
        dq Unnamed_4_0+3EBH                             ; 0770 _ 0000000000000000 (d)
        dq 0000000000000042H                            ; 0778 _ 0000000000000042 
        dq Unnamed_4_0+3F3H                             ; 0780 _ 0000000000000000 (d)
        dq 0000000000000043H                            ; 0788 _ 0000000000000043 
        dq 0000000000000000H                            ; 0790 _ 0000000000000000 
        dq 0000000000000000H                            ; 0798 _ 0000000000000000 

warning_help:                                           ; byte
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 07A0 _ ........
        dq Unnamed_4_0+4F8H                             ; 07A8 _ 0000000000000000 (d)
        dq Unnamed_4_0+518H                             ; 07B0 _ 0000000000000000 (d)
        dq Unnamed_4_0+530H                             ; 07B8 _ 0000000000000000 (d)
        dq Unnamed_4_0+558H                             ; 07C0 _ 0000000000000000 (d)
        dq Unnamed_4_0+586H                             ; 07C8 _ 0000000000000000 (d)
        dq Unnamed_4_0+59EH                             ; 07D0 _ 0000000000000000 (d)
        dq Unnamed_4_0+5B8H                             ; 07D8 _ 0000000000000000 (d)
        dq Unnamed_4_0+5E1H                             ; 07E0 _ 0000000000000000 (d)
        dq Unnamed_4_0+600H                             ; 07E8 _ 0000000000000000 (d)
        dq Unnamed_4_0+638H                             ; 07F0 _ 0000000000000000 (d)
        dq Unnamed_4_0+660H                             ; 07F8 _ 0000000000000000 (d)
        dq Unnamed_4_0+690H                             ; 0800 _ 0000000000000000 (d)
        dq Unnamed_4_0+6B8H                             ; 0808 _ 0000000000000000 (d)
        dq Unnamed_4_0+6E8H                             ; 0810 _ 0000000000000000 (d)
        dq Unnamed_4_0+70FH                             ; 0818 _ 0000000000000000 (d)
        dq Unnamed_4_0+730H                             ; 0820 _ 0000000000000000 (d)
        dq Unnamed_4_0+768H                             ; 0828 _ 0000000000000000 (d)
        dq Unnamed_4_0+7A0H                             ; 0830 _ 0000000000000000 (d)
        dq Unnamed_4_0+7D8H                             ; 0838 _ 0000000000000000 (d)
        dq Unnamed_4_0+7F9H                             ; 0840 _ 0000000000000000 (d)
        dq Unnamed_4_0+80BH                             ; 0848 _ 0000000000000000 (d)
        dq Unnamed_4_0+81DH                             ; 0850 _ 0000000000000000 (d)
        dq Unnamed_4_0+838H                             ; 0858 _ 0000000000000000 (d)
        dq Unnamed_4_0+860H                             ; 0860 _ 0000000000000000 (d)
        dq Unnamed_4_0+89EH                             ; 0868 _ 0000000000000000 (d)
        dq Unnamed_4_0+8B0H                             ; 0870 _ 0000000000000000 (d)
        dq Unnamed_4_0+8E8H                             ; 0878 _ 0000000000000000 (d)
        dq Unnamed_4_0+920H                             ; 0880 _ 0000000000000000 (d)
        dq Unnamed_4_0+958H                             ; 0888 _ 0000000000000000 (d)
        dq Unnamed_4_0+990H                             ; 0890 _ 0000000000000000 (d)
        dq Unnamed_4_0+9C3H                             ; 0898 _ 0000000000000000 (d)
        dq Unnamed_4_0+9DFH                             ; 08A0 _ 0000000000000000 (d)
        dq Unnamed_4_0+9F3H                             ; 08A8 _ 0000000000000000 (d)
        dq Unnamed_4_0+0A07H                            ; 08B0 _ 0000000000000000 (d)
        dq Unnamed_4_0+0A1BH                            ; 08B8 _ 0000000000000000 (d)
        dq Unnamed_4_0+0A30H                            ; 08C0 _ 0000000000000000 (d)
        dq Unnamed_4_0+0A5EH                            ; 08C8 _ 0000000000000000 (d)
        dq Unnamed_4_0+0A7BH                            ; 08D0 _ 0000000000000000 (d)
        dq Unnamed_4_0+0A94H                            ; 08D8 _ 0000000000000000 (d)
        dq Unnamed_4_0+0AA6H                            ; 08E0 _ 0000000000000000 (d)
        dq Unnamed_4_0+0AC0H                            ; 08E8 _ 0000000000000000 (d)
        dq Unnamed_4_0+0AF0H                            ; 08F0 _ 0000000000000000 (d)
        dq Unnamed_4_0+0B18H                            ; 08F8 _ 0000000000000000 (d)
        dq Unnamed_4_0+0B3DH                            ; 0900 _ 0000000000000000 (d)
        dq Unnamed_4_0+0B50H                            ; 0908 _ 0000000000000000 (d)
        dq Unnamed_4_0+0B73H                            ; 0910 _ 0000000000000000 (d)
        dq Unnamed_4_0+0B88H                            ; 0918 _ 0000000000000000 (d)
        dq Unnamed_4_0+0BA8H                            ; 0920 _ 0000000000000000 (d)
        dq Unnamed_4_0+0BD0H                            ; 0928 _ 0000000000000000 (d)
        dq Unnamed_4_0+0BFCH                            ; 0930 _ 0000000000000000 (d)
        dq Unnamed_4_0+0C18H                            ; 0938 _ 0000000000000000 (d)
        dq Unnamed_4_0+0C40H                            ; 0940 _ 0000000000000000 (d)
        dq Unnamed_4_0+0C70H                            ; 0948 _ 0000000000000000 (d)
        dq Unnamed_4_0+0C98H                            ; 0950 _ 0000000000000000 (d)
        dq Unnamed_4_0+0CC8H                            ; 0958 _ 0000000000000000 (d)
        dq Unnamed_4_0+0CF8H                            ; 0960 _ 0000000000000000 (d)
        dq Unnamed_4_0+0D28H                            ; 0968 _ 0000000000000000 (d)
        dq Unnamed_4_0+0D58H                            ; 0970 _ 0000000000000000 (d)
        dq Unnamed_4_0+0D88H                            ; 0978 _ 0000000000000000 (d)
        dq Unnamed_4_0+0DB8H                            ; 0980 _ 0000000000000000 (d)
        dq Unnamed_4_0+0DE8H                            ; 0988 _ 0000000000000000 (d)
        dq Unnamed_4_0+0E14H                            ; 0990 _ 0000000000000000 (d)
        dq Unnamed_4_0+0E38H                            ; 0998 _ 0000000000000000 (d)
        dq Unnamed_4_0+0E66H                            ; 09A0 _ 0000000000000000 (d)
        dq Unnamed_4_0+0E7AH                            ; 09A8 _ 0000000000000000 (d)
        dq Unnamed_4_0+0E90H                            ; 09B0 _ 0000000000000000 (d)
        dq Unnamed_4_0+0EC0H                            ; 09B8 _ 0000000000000000 (d)
        dq Unnamed_4_0+0EF0H                            ; 09C0 _ 0000000000000000 (d)
        dq Unnamed_4_0+0F25H                            ; 09C8 _ 0000000000000000 (d)


SECTION .note.gnu.property align=8 noexec               ; section number 6, const

        db 04H, 00H, 00H, 00H, 20H, 00H, 00H, 00H       ; 0000 _ .... ...
        db 05H, 00H, 00H, 00H, 47H, 4EH, 55H, 00H       ; 0008 _ ....GNU.
        db 02H, 00H, 01H, 0C0H, 04H, 00H, 00H, 00H      ; 0010 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0018 _ ........
        db 01H, 00H, 01H, 0C0H, 04H, 00H, 00H, 00H      ; 0020 _ ........
        db 01H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0028 _ ........


