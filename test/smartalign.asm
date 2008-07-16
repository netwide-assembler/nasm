%use smartalign

	bits 32

	alignmode nop
	add ax,ax
	align 16

	alignmode generic
	add ax,ax
	align 16

	alignmode k7
	add ax,ax
	align 16

	alignmode k8
	add ax,ax
	align 16

	alignmode p6
	add ax,ax
	align 16
