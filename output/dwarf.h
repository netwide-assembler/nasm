/* ----------------------------------------------------------------------- *
 *   
 *   Copyright 1996-2009 The NASM Authors - All Rights Reserved
 *   See the file AUTHORS included with the NASM distribution for
 *   the specific copyright holders.
 *
 *   Redistribution and use in source and binary forms, with or without
 *   modification, are permitted provided that the following
 *   conditions are met:
 *
 *   * Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above
 *     copyright notice, this list of conditions and the following
 *     disclaimer in the documentation and/or other materials provided
 *     with the distribution.
 *     
 *     THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
 *     CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
 *     INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 *     MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 *     DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
 *     CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 *     SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 *     NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 *     LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 *     HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 *     CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
 *     OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
 *     EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * ----------------------------------------------------------------------- */

#ifndef OUTPUT_DWARF_H
#define OUTPUT_DWARF_H

#define    DW_TAG_compile_unit	0x11
#define    DW_TAG_subprogram    0x2e
#define    DW_AT_name           0x03
#define    DW_AT_stmt_list      0x10
#define    DW_AT_low_pc         0x11
#define    DW_AT_high_pc        0x12
#define    DW_AT_language       0x13
#define    DW_AT_producer       0x25
#define    DW_AT_frame_base     0x40
#define    DW_FORM_addr         0x01
#define    DW_FORM_data2        0x05
#define    DW_FORM_data4        0x06
#define    DW_FORM_string       0x08
#define    DW_LNS_extended_op   0
#define    DW_LNS_advance_pc    2
#define    DW_LNS_advance_line  3
#define    DW_LNS_set_file      4
#define    DW_LNE_end_sequence  1
#define    DW_LNE_set_address   2
#define    DW_LNE_define_file   3
#define    DW_LANG_Mips_Assembler  0x8001

#endif /* OUTPUT_DWARF_H */
