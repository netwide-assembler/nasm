%define foo(x) (x+1)
%define bar(=x,y) (x*y)
%define baz(x+) %(x)

	dw %map(foo,1,2,3,4)
	dw %map(bar:2,1+2,3+4,5+6,7+8)
	dw %map(baz:2,1+2,3+4,5+6,7+8)
