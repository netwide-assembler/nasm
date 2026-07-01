%pragma list options +t
	times 16 db '.'
	db 10
	db __?LIST_OPTIONS?__, 10
	db __?LIST_OPTIONS_DEFAULT?__, 10

%pragma list options *t
	times 16 db '.'
	db 10
	db __?LIST_OPTIONS?__, 10
	db __?LIST_OPTIONS_DEFAULT?__, 10

%pragma list options -"t" "-bd"
	times 16 db '.'
	db 10
	db __?LIST_OPTIONS?__, 10
	db __?LIST_OPTIONS_DEFAULT?__, 10

%pragma list options -! +__?LIST_OPTIONS_DEFAULT?__
	times 16 db '.'
	db 10
	db __?LIST_OPTIONS?__, 10
	db __?LIST_OPTIONS_DEFAULT?__, 10

%pragma list options +"t"
	times 16 db '.'
	db 10
	db __?LIST_OPTIONS?__, 10
	db __?LIST_OPTIONS_DEFAULT?__, 10

%pragma list options *!
	times 16 db '.'
	db 10
	db __?LIST_OPTIONS?__, 10
	db __?LIST_OPTIONS_DEFAULT?__, 10
