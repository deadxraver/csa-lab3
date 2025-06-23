  .data
input_addr:     .word 0x80
output_addr:    .word 0x84
stack_top:      .word 0x500
  .text

error_range:
  move.l        -1, (A1)
  halt

error_overflow:
  move.l        0xCCCC_CCCC, (A1)
  halt

f_sum_odd_n:
  add.l         1, D0           ; ++n
  lsr.l         1, D0           ; n /= 2
  mul.l         D0, D0          ; n**2
  bvs           error_overflow
  rts

main:
  link          A6, -4          ; create stack frame
  move.l        D0, -4(A6)      ; save value from outer scope to stack
  move.l        (A0), D0        ; read n
  beq           error_range     ; if n == 0
  bmi           error_range     ; if n < 0

  jsr           f_sum_odd_n     ; call
 
  move.l        D0, (A1)        ; print
  move.l        -4(A6), D0      ; return old D0
  unlk          A6              ; destroy stack frame
  rts

  .data
.org 0x80
input_port:     .word 0
output_port:    .word 0

  .text

_start:
  movea.l       stack_top, A7
  movea.l       (A7), A7
  movea.l       input_addr, A0
  movea.l       (A0), A0        ; input addr to A0
  movea.l       output_addr, A1
  movea.l       (A1), A1        ; output_addr to A1

  jsr           main            ; call just for call
  halt
