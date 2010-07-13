%macro import 1
	%define %%incfile %!PROJECTBASEDIR/%{1}.inc
%endmacro

import foo

