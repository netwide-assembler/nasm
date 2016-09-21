	db '*** ONCE ***', 0Ah
	incbin "incbin.data",32

	db '*** TWELVE ***', 0Ah
	times 12 incbin "incbin.data",32
