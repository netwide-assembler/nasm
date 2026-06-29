	db '*** ONCE ***', 0Ah
	incbin "incbin.data",32

	db '*** TWELVE ***', 0Ah
	times 12 incbin "incbin.data",32

	times 2 db '*** TIMES 2 ***', 0Ah
	db '<END>', 0Ah
