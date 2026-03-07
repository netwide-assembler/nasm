	db "Have a day!!", 13, 10
	db 13, 10
	;; All these should produce U+1F610 in UTF-8
	db `\U0001f610`
	db `\u{1f610}`
	db `\u{0001f610}`
	db `\x{f0}\x{9f}\x{98}\x{90}`
	db `\xf0\x9f\x98\x90`
	db `\d240\d159\d152\d144`
	db `\d{240}\d{0159}\d{152}\d{144}`
	db `\360\237\230\220`
	db `\o{360}\o{0237}\o{230}\o{00220}`
	db `\o360\o237\o230\o220`

	db `\U0001F610`
	db `\u{1F610}`
	db `\u{0001F610}`
	db `\x{F0}\x{9F}\x{98}\x{90}`
	db `\xF0\x9F\x98\x90`

	db `\r\n`
