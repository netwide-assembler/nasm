; Scalar FP16 conversion disp8 scaling, including signed boundaries.
; SPDX-License-Identifier: BSD-2-Clause

bits 64

; vcvtsh2ss xmm0, xmm1, m16
vcvtsh2ss xmm0, xmm1, [rsi+2]
vcvtsh2ss xmm0, xmm1, [rsi+4]
vcvtsh2ss xmm0, xmm1, [rsi-2]
vcvtsh2ss xmm0, xmm1, [rsi-256]
vcvtsh2ss xmm0, xmm1, [rsi+254]
vcvtsh2ss xmm0, xmm1, [rsi+256]
vcvtsh2ss xmm0, xmm1, [rsi-258]
vcvtsh2ss xmm0, xmm1, [rsi+1]
vcvtsh2ss xmm0, xmm1, [r12+r13*2+4]
vcvtsh2ss xmm0, xmm1, xmm2

; vcvtsh2sd xmm0, xmm1, m16
vcvtsh2sd xmm0, xmm1, [rsi+2]
vcvtsh2sd xmm0, xmm1, [rsi+4]
vcvtsh2sd xmm0, xmm1, [rsi-2]
vcvtsh2sd xmm0, xmm1, [rsi-256]
vcvtsh2sd xmm0, xmm1, [rsi+254]
vcvtsh2sd xmm0, xmm1, [rsi+256]
vcvtsh2sd xmm0, xmm1, [rsi-258]
vcvtsh2sd xmm0, xmm1, [rsi+1]
vcvtsh2sd xmm0, xmm1, [r12+r13*2+4]
vcvtsh2sd xmm0, xmm1, xmm2

; vcvtsh2si eax, m16
vcvtsh2si eax, [rsi+2]
vcvtsh2si eax, [rsi+4]
vcvtsh2si eax, [rsi-2]
vcvtsh2si eax, [rsi-256]
vcvtsh2si eax, [rsi+254]
vcvtsh2si eax, [rsi+256]
vcvtsh2si eax, [rsi-258]
vcvtsh2si eax, [rsi+1]
vcvtsh2si eax, [r12+r13*2+4]
vcvtsh2si eax, xmm2

; vcvtsh2si rax, m16
vcvtsh2si rax, [rsi+2]
vcvtsh2si rax, [rsi+4]
vcvtsh2si rax, [rsi-2]
vcvtsh2si rax, [rsi-256]
vcvtsh2si rax, [rsi+254]
vcvtsh2si rax, [rsi+256]
vcvtsh2si rax, [rsi-258]
vcvtsh2si rax, [rsi+1]
vcvtsh2si rax, [r12+r13*2+4]
vcvtsh2si rax, xmm2

; vcvtsh2usi eax, m16
vcvtsh2usi eax, [rsi+2]
vcvtsh2usi eax, [rsi+4]
vcvtsh2usi eax, [rsi-2]
vcvtsh2usi eax, [rsi-256]
vcvtsh2usi eax, [rsi+254]
vcvtsh2usi eax, [rsi+256]
vcvtsh2usi eax, [rsi-258]
vcvtsh2usi eax, [rsi+1]
vcvtsh2usi eax, [r12+r13*2+4]
vcvtsh2usi eax, xmm2

; vcvtsh2usi rax, m16
vcvtsh2usi rax, [rsi+2]
vcvtsh2usi rax, [rsi+4]
vcvtsh2usi rax, [rsi-2]
vcvtsh2usi rax, [rsi-256]
vcvtsh2usi rax, [rsi+254]
vcvtsh2usi rax, [rsi+256]
vcvtsh2usi rax, [rsi-258]
vcvtsh2usi rax, [rsi+1]
vcvtsh2usi rax, [r12+r13*2+4]
vcvtsh2usi rax, xmm2

; vcvttsh2si eax, m16
vcvttsh2si eax, [rsi+2]
vcvttsh2si eax, [rsi+4]
vcvttsh2si eax, [rsi-2]
vcvttsh2si eax, [rsi-256]
vcvttsh2si eax, [rsi+254]
vcvttsh2si eax, [rsi+256]
vcvttsh2si eax, [rsi-258]
vcvttsh2si eax, [rsi+1]
vcvttsh2si eax, [r12+r13*2+4]
vcvttsh2si eax, xmm2

; vcvttsh2si rax, m16
vcvttsh2si rax, [rsi+2]
vcvttsh2si rax, [rsi+4]
vcvttsh2si rax, [rsi-2]
vcvttsh2si rax, [rsi-256]
vcvttsh2si rax, [rsi+254]
vcvttsh2si rax, [rsi+256]
vcvttsh2si rax, [rsi-258]
vcvttsh2si rax, [rsi+1]
vcvttsh2si rax, [r12+r13*2+4]
vcvttsh2si rax, xmm2

; vcvttsh2usi eax, m16
vcvttsh2usi eax, [rsi+2]
vcvttsh2usi eax, [rsi+4]
vcvttsh2usi eax, [rsi-2]
vcvttsh2usi eax, [rsi-256]
vcvttsh2usi eax, [rsi+254]
vcvttsh2usi eax, [rsi+256]
vcvttsh2usi eax, [rsi-258]
vcvttsh2usi eax, [rsi+1]
vcvttsh2usi eax, [r12+r13*2+4]
vcvttsh2usi eax, xmm2

; vcvttsh2usi rax, m16
vcvttsh2usi rax, [rsi+2]
vcvttsh2usi rax, [rsi+4]
vcvttsh2usi rax, [rsi-2]
vcvttsh2usi rax, [rsi-256]
vcvttsh2usi rax, [rsi+254]
vcvttsh2usi rax, [rsi+256]
vcvttsh2usi rax, [rsi-258]
vcvttsh2usi rax, [rsi+1]
vcvttsh2usi rax, [r12+r13*2+4]
vcvttsh2usi rax, xmm2

; Optional source, masking, and unchanged m32/m64/m16 controls.
vcvtsh2ss xmm0, [rsi+4]
vcvtsh2sd xmm0, [rsi+4]
vcvtsh2ss xmm0{k1}{z}, xmm1, [rsi+4]
vcvtsi2sh xmm0, xmm1, dword [rsi+4]
vcvtsi2sh xmm0, xmm1, qword [rsi+8]
vcvtusi2sh xmm0, xmm1, dword [rsi+4]
vcvtusi2sh xmm0, xmm1, qword [rsi+8]
vcvtss2sh xmm0, xmm1, [rsi+4]
vcvtsd2sh xmm0, xmm1, [rsi+8]
vaddsh xmm0, xmm1, [rsi+4]
