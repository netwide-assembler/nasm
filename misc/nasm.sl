% This file defines a NASM editor mode for the JED editor.
% JED's home page is http://space.mit.edu/~davis/jed.html.
%
% To install, copy this file into your JED_LIBRARY directory
% (/usr/local/jed/lib or C:\JED\LIB or whatever), then add the
% following lines to your .jedrc or jed.rc file:
%   autoload("nasm_mode", "nasm");
%   add_mode_for_extension("nasm", "asm");
% (you can of course replace "asm" with whatever file extension
% you like to use for your NASM source files).

variable Nasm_Instruction_Indent = 10;
variable Nasm_Comment_Column = 33;
variable Nasm_Comment_Space = 1;

variable nasm_kw_2 = strcat("ahalaxbhblbpbtbxchclcscxdbdddhdidldqdsdtdwdxes",
			    "fsgsinjajbjcjejgjljojpjsjzorsispssto");
variable nasm_kw_3 = strncat("a16a32aaaaadaamaasadcaddandbsfbsrbtcbtrbtscbw",
			     "cdqclccldclicmccmpcr0cr2cr3cr4cwddaadasdecdiv",
			     "dr0dr1dr2dr3dr6dr7eaxebpebxecxediedxequesiesp",
			     "farfldfsthltincintjaejbejgejlejmpjnajnbjncjne",
			     "jngjnljnojnpjnsjnzjpejpolarldslealeslfslgslsl",
			     "lssltrmm0mm1mm2mm3mm4mm5mm6mm7movmulnegnopnot",
			     "o16o32outpopporrclrcrrepretrolrorrsmsalsarsbb",
			     "segshlshrst0st1st2st3st4st5st6st7stcstdstistr",
			     "subtr3tr4tr5tr6tr7wrtxor", 9);
variable nasm_kw_4 = strncat("arplbytecallcltscwdeemmsfabsfaddfbldfchsfcom",
			     "fcosfdivfenifildfistfld1fldzfmulfnopfsinfstp",
			     "fsubftstfxamfxchidivimulinsbinsdinswint3into",
			     "invdiretjcxzjnaejnbejngejnlelahflgdtlidtlldt",
			     "lmswlocklongloopmovdmovqnearpandpopapopfpush",
			     "pxorreperepzresbresdreswretfretnsahfsetasetb",
			     "setcsetesetgsetlsetosetpsetssetzsgdtshldshrd",
			     "sidtsldtsmswtestverrverwwaitwordxaddxchg", 8);
variable nasm_kw_5 = strncat("boundbswapcmpsbcmpsdcmpswcpuiddwordenterf2xm1",
			     "faddpfbstpfclexfcompfdisifdivpfdivrffreefiadd",
			     "ficomfidivfimulfinitfistpfisubfldcwfldpifmulp",
			     "fpremfptanfsavefsqrtfstcwfstswfsubpfsubrfucom",
			     "fyl2xiretdiretwjecxzleavelodsblodsdlodswloope",
			     "loopzmovsbmovsdmovswmovsxmovzxoutsboutsdoutsw",
			     "paddbpadddpaddwpandnpopadpopawpopfdpopfwpslld",
			     "psllqpsllwpsradpsrawpsrldpsrlqpsrlwpsubbpsubd",
			     "psubwpushapushfqwordrdmsrrdtscrepnerepnzscasb",
			     "scasdscaswsetaesetbesetgesetlesetnasetnbsetnc",
			     "setnesetngsetnlsetnosetnpsetnssetnzsetpesetpo",
			     "shortstosbstosdstoswtimestwordwrmsrxlatb", 12);
variable nasm_kw_6 = strncat("fcomppfdivrpficompfidivrfisubrfldenvfldl2e",
			     "fldl2tfldlg2fldln2fpatanfprem1frstorfscale",
			     "fsetpmfstenvfsubrpfucompinvlpgloopneloopnz",
			     "paddsbpaddswpmulhwpmullwpsubsbpsubswpushad",
			     "pushawpushfdpushfwsetnaesetnbesetngesetnle",
			     "wbinvd", 6);
variable nasm_kw_7 = strncat("cmpxchgfdecstpfincstpfrndintfsincosfucompp",
			     "fxtractfyl2xp1paddusbpadduswpcmpeqbpcmpeqd",
			     "pcmpeqwpcmpgtbpcmpgtdpcmpgtwpmaddwdpsubusb",
			     "psubusw", 4);
variable nasm_kw_8 = "packssdwpacksswbpackuswb";
variable nasm_kw_9 = strcat("cmpxchg8bpunpckhbwpunpckhdqpunpckhwdpunpcklbw",
			    "punpckldqpunpcklwd");

define nasm_is_kw {
    variable word;
    variable len;
    variable list, min, max, pos, cmp;

    word = strlow(());
    len = strlen(word);

    switch (len)
    { case 0: return 1; }
    { case 2: list = nasm_kw_2; }
    { case 3: list = nasm_kw_3; }
    { case 4: list = nasm_kw_4; }
    { case 5: list = nasm_kw_5; }
    { case 6: list = nasm_kw_6; }
    { case 7: list = nasm_kw_7; }
    { case 8: list = nasm_kw_8; }
    { case 9: list = nasm_kw_9; }
    { pop(); return 0; }

    min = -1;
    max = strlen(list) / len;
    while (max - min >= 2) {
	pos = (max + min) / 2;
	cmp = strcmp(word, substr(list, pos * len + 1, len));
	if (cmp == 0)
	    return 1;		       % it's a keyword
	else if (cmp < 0)
	    max = pos;		       % bottom half
	else if (cmp > 0)
	    min = pos;		       % top half
    }
    return 0;
}

define nasm_indent_line() {
    variable word, len, e;

    e = eolp();

    push_spot();
    EXIT_BLOCK {
	pop_spot();
	if (what_column() <= Nasm_Instruction_Indent)
	    skip_white();
    }

    bol_skip_white();

    if (orelse
       {looking_at_char(';')}
       {looking_at_char('#')}
       {looking_at_char('[')}) {
	bol_trim();
	pop_spot();
	EXIT_BLOCK {
	}
	return;
    }

    push_mark();
    skip_chars("0-9a-zA-Z_.");
    word = bufsubstr();

    if (nasm_is_kw(word)) {
	bol_trim();
	whitespace(Nasm_Instruction_Indent);
    } else {
	push_spot();
	bol_trim();
	pop_spot();
	len = strlen(word);
	if (looking_at_char(':')) {
	    go_right_1();
	    len++;
	}
	trim();
	if (e or not(eolp())) {
	    if (len >= Nasm_Instruction_Indent) {
		pop();
		whitespace(1);
	    } else
		whitespace(Nasm_Instruction_Indent - len);
	    if (e) {
		pop_spot();
		eol();
		push_spot();
	    }
	}
    }
}

define nasm_newline_indent {
    push_spot();
    bol_skip_white();
    if (eolp())
	trim();
    pop_spot();
    newline();
    nasm_indent_line();
}

define nasm_bol_self_ins {
    push_spot();
    bskip_white();
    bolp();
    pop_spot();

    call("self_insert_cmd");

    % Grotty: force immediate update of the syntax highlighting.
    insert_char('.');
    deln(left(1));

    if (())
	nasm_indent_line();
}

define nasm_self_ins_ind {
    call("self_insert_cmd");

    % Grotty: force immediate update of the syntax highlighting.
    insert_char('.');
    deln(left(1));

    nasm_indent_line();
}

define nasm_insert_comment {
    variable spc;

    bol_skip_white();
    if (looking_at_char(';')) {
	bol_trim();
	go_right(1);
	skip_white();
	return;
    } else if (eolp()) {
	bol_trim();
	insert("; ");
	return;
    }

    forever {
	skip_chars("^;\n'\"");
	if (looking_at_char('\'')) {
	    go_right_1();
	    skip_chars("^'\n");
	    !if (eolp())
		go_right_1();
	} else if (looking_at_char('\"')) {
	    go_right_1();
	    skip_chars("^\"\n");
	    !if (eolp())
		go_right_1();
	} else if (looking_at_char(';')) {
	    !if (bolp()) {
		go_left_1();
		trim();
		!if (looking_at_char(';'))
		    go_right_1();
	    }
	    break;
	} else {
	    break;
	}
    }
    spc = Nasm_Comment_Column - what_column();
    if (spc < Nasm_Comment_Space)
	spc = Nasm_Comment_Space;
    whitespace(spc);
    if (eolp()) {
	insert("; ");
    } else {
	go_right_1();
	skip_white();
    }
}

$1 = "NASM";
create_syntax_table($1);

define_syntax (";", "", '%', $1);
define_syntax ("([", ")]", '(', $1);
define_syntax ('"', '"', $1);
define_syntax ('\'', '\'', $1);
define_syntax ("0-9a-zA-Z_.@#", 'w', $1);
define_syntax ("-+0-9a-fA-F.xXL", '0', $1);
define_syntax (",:", ',', $1);
define_syntax ('#', '#', $1);
define_syntax ("|^&<>+-*/%~", '+', $1);

set_syntax_flags($1,1);

#ifdef HAS_DFA_SYNTAX

enable_highlight_cache("nasm.dfa", $1);
define_highlight_rule(";.*$", "comment", $1);
define_highlight_rule("[A-Za-z_\\.\\?][A-Za-z0-9_\\.\\?\\$#@~]*",
		      "Knormal", $1);
define_highlight_rule("$([A-Za-z_\\.\\?][A-Za-z0-9_\\.\\?\\$#@~]*)?",
		      "normal", $1);
define_highlight_rule("[0-9]+(\\.[0-9]*)?([Ee][\\+\\-]?[0-9]*)?",
		      "number", $1);
define_highlight_rule("[0-9]+[QqBb]", "number", $1);
define_highlight_rule("(0x|\\$[0-9A-Fa-f])[0-9A-Fa-f]*", "number", $1);
define_highlight_rule("[0-9A-Fa-f]+[Hh]", "number", $1);
define_highlight_rule("\"[^\"]*\"", "string", $1);
define_highlight_rule("\"[^\"]*$", "string", $1);
define_highlight_rule("'[^']*'", "string", $1);
define_highlight_rule("'[^']*$", "string", $1);
define_highlight_rule("[\\(\\)\\[\\],:]*", "delimiter", $1);
define_highlight_rule("[\\|\\^&<>\\+\\-\\*/%~]*", "operator", $1);
define_highlight_rule("^[ \t]*#", "PQpreprocess", $1);
define_highlight_rule("@[0-9A-Za-z_\\.]*", "keyword1", $1);
define_highlight_rule("[ \t]*", "normal", $1);
define_highlight_rule(".", "normal", $1);
build_highlight_table($1);

#endif

define_keywords_n($1, nasm_kw_2, 2, 0);
define_keywords_n($1, nasm_kw_3, 3, 0);
define_keywords_n($1, nasm_kw_4, 4, 0);
define_keywords_n($1, nasm_kw_5, 5, 0);
define_keywords_n($1, nasm_kw_6, 6, 0);
define_keywords_n($1, nasm_kw_7, 7, 0);
define_keywords_n($1, nasm_kw_8, 8, 0);
define_keywords_n($1, nasm_kw_9, 9, 0);

!if (keymap_p ($1)) make_keymap ($1);
definekey("nasm_bol_self_ins", ";", $1);
definekey("nasm_bol_self_ins", "#", $1);
definekey("nasm_bol_self_ins", "[", $1);
definekey("nasm_self_ins_ind", ":", $1);
definekey("nasm_insert_comment", "^[;", $1);

define nasm_mode {
    set_mode("NASM", 4);
    use_keymap ("NASM");
    use_syntax_table ("NASM");
    set_buffer_hook ("indent_hook", "nasm_indent_line");
    set_buffer_hook ("newline_indent_hook", "nasm_newline_indent");
    runhooks("nasm_mode_hook");
}
