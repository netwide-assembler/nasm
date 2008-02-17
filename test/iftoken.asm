	db 'N "1": '
%iftoken 1
	db 'Yes', 10
%else
	db 'No', 10
%endif
	db 'C "1": '
%iftoken 1 ; With a comment!
	db 'Yes', 10
%else
	db 'No', 10
%endif
	db 'N "+1": '
%iftoken +1
	db 'Yes', 10
%else
	db 'No', 10
%endif
	db 'C "+1": '
%iftoken +1 ; With a comment!
	db 'Yes', 10
%else
	db 'No', 10
%endif
	db 'N "1 2": '
%iftoken 1 2
	db 'Yes', 10
%else
	db 'No', 10
%endif
	db 'C "1 2": '
%iftoken 1 2 ; With a comment!
	db 'Yes', 10
%else
	db 'No', 10
%endif
	db 'N "1,2": '
%iftoken 1,2
	db 'Yes', 10
%else
	db 'No', 10
%endif
	db 'C "1,2": '
%iftoken 1,2 ; With a comment!
	db 'Yes', 10
%else
	db 'No', 10
%endif
	db 'N "foo": '
%iftoken foo
	db 'Yes', 10
%else
	db 'No', 10
%endif
	db 'C "foo": '
%iftoken foo ; With a comment!
	db 'Yes', 10
%else
	db 'No', 10
%endif
	db 'N "foo bar": '
%iftoken foo bar
	db 'Yes', 10
%else
	db 'No', 10
%endif
	db 'C "foo bar": '
%iftoken foo bar ; With a comment!
	db 'Yes', 10
%else
	db 'No', 10
%endif
	db 'N "%": '
%iftoken %
	db 'Yes', 10
%else
	db 'No', 10
%endif
	db 'C "%": '
%iftoken % ; With a comment!
	db 'Yes', 10
%else
	db 'No', 10
%endif
	db 'N "+foo": '
%iftoken +foo
	db 'Yes', 10
%else
	db 'No', 10
%endif
	db 'C "+foo": '
%iftoken +foo ; With a comment!
	db 'Yes', 10
%else
	db 'No', 10
%endif
	db 'N "<<": '
%iftoken <<
	db 'Yes', 10
%else
	db 'No', 10
%endif
	db 'C "<<": '
%iftoken << ; With a comment!
	db 'Yes', 10
%else
	db 'No', 10
%endif
