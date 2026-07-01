; Convergence regression: a forward jcc/jmp self-shrink candidate with a
; position-dependent "align" between the jump and its target.
;
; The naive self-shrink re-check in jmp_match() predicts the post-shrink
; displacement assuming the span shifts rigidly. The "align 2" below
; breaks that assumption: shrinking `jmp B` changes the alignment
; padding, so the speculative SHORT does not fit. Unbounded, the jump
; oscillates NEAR<->SHORT and assembly stalls ("unable to find valid
; values for all labels ... giving up"). With bounded speculation the
; jump speculates once, reverts to NEAR, and assembly converges.

bits 32
        times 43 jmp A
        times 256 db 0
        je A
A:
        jmp B
        align 2
        times 127 db 0
B:
