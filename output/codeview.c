/* ----------------------------------------------------------------------- *
 *
 *   Copyright 1996-2016 The NASM Authors - All Rights Reserved
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

/*
 * codeview.c Codeview Debug Format support for COFF
 */

#include "version.h"
#include "compiler.h"

#include <stdio.h>
#include <stddef.h>
#include <stdlib.h>

#include "nasm.h"
#include "nasmlib.h"
#include "saa.h"
#include "output/outlib.h"
#include "output/pecoff.h"
#include "md5.h"

static void cv8_init(void);
static void cv8_linenum(const char *filename, int32_t linenumber,
        int32_t segto);
static void cv8_deflabel(char *name, int32_t segment, int64_t offset,
        int is_global, char *special);
static void cv8_typevalue(int32_t type);
static void cv8_output(int type, void *param);
static void cv8_cleanup(void);

struct dfmt df_cv8 = {
    "Codeview 8",               /* .fullname */
    "cv8",                      /* .shortname */
    cv8_init,                   /* .init */
    cv8_linenum,                /* .linenum */
    cv8_deflabel,               /* .debug_deflabel */
    null_debug_directive,       /* .debug_directive */
    cv8_typevalue,              /* .debug_typevalue */
    cv8_output,                 /* .debug_output */
    cv8_cleanup,                /* .cleanup */
};

/*******************************************************************************
 * dfmt callbacks
 ******************************************************************************/
struct source_file {
    char *name;
    unsigned char md5sum[MD5_HASHBYTES];
};

struct linepair {
    uint32_t file_offset;
    uint32_t linenumber;
};

enum symbol_type {
    SYMTYPE_CODE,
    SYMTYPE_PROC,
    SYMTYPE_LDATA,
    SYMTYPE_GDATA,

    SYMTYPE_MAX
};

struct cv8_symbol {
    enum symbol_type type;
    char *name;

    uint32_t secrel;
    uint16_t section;
    uint32_t size;
    uint32_t typeindex;

    enum symtype {
        TYPE_UNREGISTERED = 0x0000, /* T_NOTYPE */
        TYPE_BYTE = 0x0020,
        TYPE_WORD = 0x0021,
        TYPE_DWORD= 0x0022,
        TYPE_QUAD = 0x0023,

        TYPE_REAL32 = 0x0040,
        TYPE_REAL64 = 0x0041,
        TYPE_REAL80 = 0x0042,
        TYPE_REAL128= 0x0043,
        TYPE_REAL256= 0x0044,
        TYPE_REAL512= 0x0045
    } symtype;
};

struct cv8_state {
    int symbol_sect;
    int type_sect;

    uint32_t text_offset;

    struct source_file source_file;

    struct SAA *lines;
    uint32_t num_lines;

    struct SAA *symbols;
    struct cv8_symbol *last_sym;
    unsigned num_syms[SYMTYPE_MAX];
    unsigned symbol_lengths;
    unsigned total_syms;

    char *cwd;
};
struct cv8_state cv8_state;

static void cv8_init(void)
{
    const uint32_t sect_flags =     IMAGE_SCN_MEM_READ |
                    IMAGE_SCN_MEM_DISCARDABLE |
                    IMAGE_SCN_CNT_INITIALIZED_DATA |
                    IMAGE_SCN_ALIGN_1BYTES;

    cv8_state.symbol_sect = coff_make_section(".debug$S", sect_flags);
    cv8_state.type_sect = coff_make_section(".debug$T", sect_flags);

    cv8_state.text_offset = 0;

    cv8_state.lines = saa_init(sizeof(struct linepair));
    cv8_state.num_lines = 0;

    cv8_state.symbols = saa_init(sizeof(struct cv8_symbol));
    cv8_state.last_sym = NULL;

    cv8_state.cwd = nasm_realpath(".");
}

static void register_file(const char *filename);
static struct coff_Section *find_section(int32_t segto);

static void cv8_linenum(const char *filename, int32_t linenumber,
        int32_t segto)
{
    struct coff_Section *s;
    struct linepair *li;

    if (cv8_state.source_file.name == NULL)
        register_file(filename);

    s = find_section(segto);
    if (s == NULL)
        return;

    if ((s->flags & IMAGE_SCN_MEM_EXECUTE) == 0)
        return;

    li = saa_wstruct(cv8_state.lines);
    li->file_offset = cv8_state.text_offset;
    li->linenumber = linenumber;

    cv8_state.num_lines++;
}

static void cv8_deflabel(char *name, int32_t segment, int64_t offset,
        int is_global, char *special)
{
    struct cv8_symbol *sym;
    struct coff_Section *s;

    (void)special;

    s = find_section(segment);
    if (s == NULL)
        return;

    sym = saa_wstruct(cv8_state.symbols);

    if (s->flags & IMAGE_SCN_MEM_EXECUTE)
        sym->type = is_global ? SYMTYPE_PROC : SYMTYPE_CODE;
    else
        sym->type = is_global ?  SYMTYPE_GDATA : SYMTYPE_LDATA;
    cv8_state.num_syms[sym->type]++;
    cv8_state.total_syms++;

    sym->section = segment;
    sym->secrel = offset;
    sym->symtype = TYPE_UNREGISTERED;
    sym->size = 0;
    sym->typeindex = 0;

    sym->name = nasm_strdup(name);
    cv8_state.symbol_lengths += strlen(sym->name) + 1;

    if (cv8_state.last_sym && cv8_state.last_sym->section == segment)
        cv8_state.last_sym->size = offset - cv8_state.last_sym->secrel;
    cv8_state.last_sym = sym;
}

static void cv8_typevalue(int32_t type)
{
    if (!cv8_state.last_sym)
        return;
    if (cv8_state.last_sym->symtype != TYPE_UNREGISTERED)
        return;

    switch (TYM_TYPE(type)) {
    case TY_BYTE:
        cv8_state.last_sym->symtype = TYPE_BYTE;
        break;
    case TY_WORD:
        cv8_state.last_sym->symtype = TYPE_WORD;
        break;
    case TY_DWORD:
        cv8_state.last_sym->symtype = TYPE_DWORD;
        break;
    case TY_QWORD:
        cv8_state.last_sym->symtype = TYPE_QUAD;
        break;
    case TY_FLOAT:
        cv8_state.last_sym->symtype = TYPE_REAL32;
        break;
    case TY_TBYTE:
        cv8_state.last_sym->symtype = TYPE_REAL80;
        break;
    case TY_OWORD:
        cv8_state.last_sym->symtype = TYPE_REAL128;
        break;
    case TY_YWORD:
        cv8_state.last_sym->symtype = TYPE_REAL256;
        break;
    case TY_UNKNOWN:
        break;
    case TY_LABEL:
        break;
    }
}

static void cv8_output(int type, void *param)
{
    struct coff_DebugInfo *dinfo = param;

    (void)type;

    if (dinfo->section && dinfo->section->name &&
    !strncmp(dinfo->section->name, ".text", 5))
        cv8_state.text_offset += dinfo->size;
}

static void build_symbol_table(struct coff_Section *const sect);
static void build_type_table(struct coff_Section *const sect);

static void cv8_cleanup(void)
{
    struct cv8_symbol *sym;

    struct coff_Section *symbol_sect = coff_sects[cv8_state.symbol_sect];
    struct coff_Section *type_sect = coff_sects[cv8_state.type_sect];

    build_symbol_table(symbol_sect);
    build_type_table(type_sect);

    if (cv8_state.source_file.name != NULL)
        free(cv8_state.source_file.name);

    if (cv8_state.cwd != NULL)
        free(cv8_state.cwd);

    saa_free(cv8_state.lines);

    saa_rewind(cv8_state.symbols);
    while ((sym = saa_rstruct(cv8_state.symbols)))
        free(sym->name);
    saa_free(cv8_state.symbols);
}

/*******************************************************************************
 * implementation
 ******************************************************************************/
static void calc_md5(const char *const filename,
        unsigned char sum[MD5_HASHBYTES])
{
    int success = 0;
    unsigned char *file_buf;
    FILE *f;
    MD5_CTX ctx;

    f = fopen(filename, "r");
    if (!f)
        goto done;

    file_buf = nasm_zalloc(BUFSIZ);

    MD5Init(&ctx);
    while (!feof(f)) {
        size_t i = fread(file_buf, 1, BUFSIZ, f);
        if (ferror(f))
            goto done_0;
        else if (i == 0)
            break;
        MD5Update(&ctx, file_buf, i);
    }
    MD5Final(sum, &ctx);

    success = 1;
done_0:
    nasm_free(file_buf);
    fclose(f);
done:
    if (!success) {
        nasm_error(ERR_NONFATAL, "unable to hash file %s. "
                 "Debug information may be unavailable.\n",
                 filename);
    }
    return;
}

static void register_file(const char *filename)
{
    cv8_state.source_file.name = nasm_realpath(filename);
    memset(cv8_state.source_file.md5sum, 0, MD5_HASHBYTES);
    calc_md5(filename, cv8_state.source_file.md5sum);
}

static struct coff_Section *find_section(int32_t segto)
{
    int i;

    for (i = 0; i < coff_nsects; i++) {
        struct coff_Section *sec;

        sec = coff_sects[i];
        if (segto == sec->index)
            return sec;
    }
    return NULL;
}

static void register_reloc(struct coff_Section *const sect,
        char *sym, uint32_t addr, uint16_t type)
{
    struct coff_Reloc *r;
    struct coff_Section *sec;

    r = *sect->tail = nasm_malloc(sizeof(struct coff_Reloc));
    sect->tail = &r->next;
    r->next = NULL;
    sect->nrelocs++;

    r->address = addr;
    r->symbase = SECT_SYMBOLS;
    r->type = type;

    r->symbol = 0;
    for (int i = 0; i < coff_nsects; i++) {
        sec = coff_sects[i];
        if (!strcmp(sym, sec->name)) {
            return;
        }
        r->symbol += 2;
    }

    saa_rewind(coff_syms);
    for (uint32_t i = 0; i < coff_nsyms; i++) {
        struct coff_Symbol *s = saa_rstruct(coff_syms);
        r->symbol++;
        if (s->strpos == -1 && !strcmp(sym, s->name)) {
            return;
        } else if (s->strpos != -1) {
            int res;
            char *symname;

            symname = nasm_malloc(s->namlen + 1);
            saa_fread(coff_strs, s->strpos-4, symname, s->namlen);
            symname[s->namlen] = '\0';
            res = strcmp(sym, symname);
            nasm_free(symname);
            if (!res)
                return;
        }
    }
    nasm_panic(0, "codeview: relocation for unregistered symbol: %s", sym);
}

static inline void section_write32(struct coff_Section *sect, uint32_t val)
{
    saa_write32(sect->data, val);
    sect->len += 4;
}

static inline void section_write16(struct coff_Section *sect, uint16_t val)
{
    saa_write16(sect->data, val);
    sect->len += 2;
}

static inline void section_write8(struct coff_Section *sect, uint8_t val)
{
    saa_write8(sect->data, val);
    sect->len++;
}

static inline void section_wbytes(struct coff_Section *sect, const void *buf,
        size_t len)
{
    saa_wbytes(sect->data, buf, len);
    sect->len += len;
}

static void write_filename_table(struct coff_Section *const sect)
{
    uint32_t field_length = 0;
    size_t filename_len = strlen(cv8_state.source_file.name);

    field_length = 1 + filename_len + 1;

    section_write32(sect, 0x000000F3);
    section_write32(sect, field_length);

    section_write8(sect, 0);
    section_wbytes(sect, cv8_state.source_file.name, filename_len + 1);
}

static void write_sourcefile_table(struct coff_Section *const sect)
{
    uint32_t field_length = 0;

    field_length = 4 + 2 + MD5_HASHBYTES + 2;

    section_write32(sect, 0x000000F4);
    section_write32(sect, field_length);

    section_write32(sect, 1); /* offset of filename in filename str table */
    section_write16(sect, 0x0110);
    section_wbytes(sect, cv8_state.source_file.md5sum, MD5_HASHBYTES);
    section_write16(sect, 0);
}

static void write_linenumber_table(struct coff_Section *const sect)
{
    int i;
    uint32_t field_length = 0;
    size_t field_base;
    struct coff_Section *s;
    struct linepair *li;

    for (i = 0; i < coff_nsects; i++) {
        if (!strncmp(coff_sects[i]->name, ".text", 5))
            break;
    }

    if (i == coff_nsects)
        return;
    s = coff_sects[i];

    field_length = 12 + 12 + (cv8_state.num_lines * 8);

    section_write32(sect, 0x000000F2);
    section_write32(sect, field_length);

    field_base = sect->len;
    section_write32(sect, 0); /* SECREL, updated by relocation */
    section_write16(sect, 0); /* SECTION, updated by relocation*/
    section_write16(sect, 0); /* pad */
    section_write32(sect, s->len);

    register_reloc(sect, ".text", field_base,
        win64 ? IMAGE_REL_AMD64_SECREL : IMAGE_REL_I386_SECREL);

    register_reloc(sect, ".text", field_base + 4,
        win64 ? IMAGE_REL_AMD64_SECTION : IMAGE_REL_I386_SECTION);

    /* 1 or more source mappings (we assume only 1) */
    section_write32(sect, 0);
    section_write32(sect, cv8_state.num_lines);
    section_write32(sect, 12 + (cv8_state.num_lines * 8));

    /* the pairs */
    saa_rewind(cv8_state.lines);
    while ((li = saa_rstruct(cv8_state.lines))) {
        section_write32(sect, li->file_offset);
        section_write32(sect, li->linenumber |= 0x80000000);
    }
}

static uint16_t write_symbolinfo_obj(struct coff_Section *sect,
        const char sep)
{
    uint16_t obj_len;

    obj_len = 2 + 4 + strlen(cv8_state.cwd)+ 1 + strlen(coff_outfile) +1;

    section_write16(sect, obj_len);
    section_write16(sect, 0x1101);
    section_write32(sect, 0); /* ASM language */
    section_wbytes(sect, cv8_state.cwd, strlen(cv8_state.cwd));
    section_write8(sect, sep);
    section_wbytes(sect, coff_outfile, strlen(coff_outfile)+1);

    return obj_len;
}

static uint16_t write_symbolinfo_properties(struct coff_Section *sect,
        const char *const creator_str)
{
    uint16_t creator_len;

    creator_len = 2 + 4 + 4 + 4 + 4 + strlen(creator_str)+1 + 2;

    section_write16(sect, creator_len);
    section_write16(sect, 0x1116);
    section_write32(sect, 3); /* language */
    if (win64)
        section_write32(sect, 0x000000D0);
    else if (win32)
        section_write32(sect, 0x00000006);
    else
        nasm_assert(!"neither win32 nor win64 are set!");
    section_write32(sect, 0); /* flags*/
    section_write32(sect, 8); /* version */
    section_wbytes(sect, creator_str, strlen(creator_str)+1);
    /*
     * normally there would be key/value pairs here, but they aren't
     * necessary. They are terminated by 2B
     */
    section_write16(sect, 0);

    return creator_len;
}

static uint16_t write_symbolinfo_symbols(struct coff_Section *sect)
{
    uint16_t len = 0, field_len;
    uint32_t field_base;
    struct cv8_symbol *sym;

    saa_rewind(cv8_state.symbols);
    while ((sym = saa_rstruct(cv8_state.symbols))) {
        switch (sym->type) {
        case SYMTYPE_LDATA:
        case SYMTYPE_GDATA:
            field_len = 12 + strlen(sym->name) + 1;
            len += field_len - 2;
            section_write16(sect, field_len);
            if (sym->type == SYMTYPE_LDATA)
                section_write16(sect, 0x110C);
            else
                section_write16(sect, 0x110D);
            section_write32(sect, sym->symtype);

            field_base = sect->len;
            section_write32(sect, 0); /* SECREL */
            section_write16(sect, 0); /* SECTION */
            break;
        case SYMTYPE_PROC:
        case SYMTYPE_CODE:
            field_len = 9 + strlen(sym->name) + 1;
            len += field_len - 2;
            section_write16(sect, field_len);
            section_write16(sect, 0x1105);

            field_base = sect->len;
            section_write32(sect, 0); /* SECREL */
            section_write16(sect, 0); /* SECTION */
            section_write8(sect, 0); /* FLAG */
            break;
        default:
            nasm_assert(!"unknown symbol type");
        }

        section_wbytes(sect, sym->name, strlen(sym->name) + 1);

        register_reloc(sect, sym->name, field_base,
            win64 ? IMAGE_REL_AMD64_SECREL :
                IMAGE_REL_I386_SECREL);
        register_reloc(sect, sym->name, field_base + 4,
            win64 ? IMAGE_REL_AMD64_SECTION :
                IMAGE_REL_I386_SECTION);
    }

    return len;
}

static void write_symbolinfo_table(struct coff_Section *const sect)
{
    const char sep = '\\';
    const char *creator_str = "The Netwide Assembler " NASM_VER;


    uint16_t obj_length, creator_length, sym_length;
    uint32_t field_length = 0, out_len;

    /* signature, language, workingdir / coff_outfile NULL */
    obj_length = 2 + 4 + strlen(cv8_state.cwd)+ 1 + strlen(coff_outfile) +1;
    creator_length = 2 + 4 + 4 + 4 + 4 + strlen(creator_str)+1 + 2;

    sym_length =    ( cv8_state.num_syms[SYMTYPE_CODE] *  7) +
            ( cv8_state.num_syms[SYMTYPE_PROC] *  7) +
            ( cv8_state.num_syms[SYMTYPE_LDATA] * 10) +
            ( cv8_state.num_syms[SYMTYPE_GDATA] * 10) +
            cv8_state.symbol_lengths;

    field_length = 2 + obj_length +
               2 + creator_length +
               (4 * cv8_state.total_syms) + sym_length;

    section_write32(sect, 0x000000F1);
    section_write32(sect, field_length);

    /* for sub fields, length preceeds type */

    out_len = write_symbolinfo_obj(sect, sep);
    nasm_assert(out_len == obj_length);

    out_len = write_symbolinfo_properties(sect, creator_str);
    nasm_assert(out_len == creator_length);

    out_len = write_symbolinfo_symbols(sect);
    nasm_assert(out_len == sym_length);
}

static inline void align4_table(struct coff_Section *const sect)
{
    unsigned diff;
    uint32_t zero = 0;
    struct SAA *data = sect->data;

    if (data->wptr % 4 == 0)
        return;

    diff = 4 - (data->wptr % 4);
    if (diff)
        section_wbytes(sect, &zero, diff);
}

static void build_symbol_table(struct coff_Section *const sect)
{
    section_write32(sect, 0x00000004);

    write_filename_table(sect);
    align4_table(sect);
    write_sourcefile_table(sect);
    align4_table(sect);
    write_linenumber_table(sect);
    align4_table(sect);
    write_symbolinfo_table(sect);
    align4_table(sect);
}

static void build_type_table(struct coff_Section *const sect)
{
    uint16_t field_len;
    struct cv8_symbol *sym;

    section_write32(sect, 0x00000004);

    saa_rewind(cv8_state.symbols);
    while ((sym = saa_rstruct(cv8_state.symbols))) {
        if (sym->type != SYMTYPE_PROC)
            continue;

        /* proc leaf */

        field_len = 2 + 4 + 4 + 4 + 2;
        section_write16(sect, field_len);
        section_write16(sect, 0x1008); /* PROC type */

        section_write32(sect, 0x00000003); /* return type */
        section_write32(sect, 0); /* calling convention (default) */
        section_write32(sect, sym->typeindex);
        section_write16(sect, 0); /* # params */

        /* arglist */

        field_len = 2 + 4;
        section_write16(sect, field_len);
        section_write16(sect, 0x1201); /* ARGLIST */
        section_write32(sect, 0); /*num params */
    }
}


