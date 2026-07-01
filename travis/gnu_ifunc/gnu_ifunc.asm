section .text

global __foo_ifunc:function
global __foo_impl:function

__foo_impl:
	ret

__foo_ifunc:
    lea rax, [rel __foo_impl]
    ret

global foo:gnu_ifunc
foo equ __foo_ifunc
