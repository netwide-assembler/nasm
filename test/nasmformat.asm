
%if _NASM_FORMAT_ == 'bin'

db 'This is binary format file'

%elif _NASM_FORMAT_ == 'obj'

db 'This is object format file'

%else

db 'This is some other format file'

%endif
