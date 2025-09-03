	[dollarhex off]

	section $$$bar
	global $foo, $$foo, $$$foo, $3
_start:
	mov eax,$$foo
$foo:
	nop
$$foo:
	nop
$$$foo:
	nop
$3:
	nop
