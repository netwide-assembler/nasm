struc A_STRUC
  ._a: resw 1
endstruc

a_struc:
  istruc A_STRUC
  at A_STRUC._a dw 1
  iend
