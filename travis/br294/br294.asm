; Test for issue #294: leading and consecutive %+ tokens in preprocessor
%define test_lead %+ nop
%define test_consec no %+ %+ p
%define test_both %+ %+ nop
test_lead
test_consec
test_both
