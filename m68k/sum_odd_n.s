  .data
input_addr:     .word 0x80
output_addr:    .word 0x84
  .text

error_range:
  move.l        -1, (A1)
  halt

error_overflow:
  move.l        0xCCCC_CCCC, (A1)
  halt

_start:
  movea.l       input_addr, A0
  movea.l       (A0), A0
  movea.l       output_addr, A1
  movea.l       (A1), A1

  move.l        (A0), D0        ; read n
  beq           error_range     ; if n == 0
  bmi           error_range     ; if n < 0

  add.l         1, D0           ; ++n
  lsr.l         1, D0           ; n /= 2
  mul.l         D0, D0          ; n * n
  bvs           error_overflow
  
  move.l        D0, (A1)
  halt
