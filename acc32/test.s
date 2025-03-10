.data 
input_addr: .word 0x80
output_addr:  .word 0x84
alignment:    .word '..'
.text 

_start:
  load_ind  input_addr
  bcs       err
  bvs       err
  store_ind output_addr
  halt
err:
  clc
  clv
  load_imm  0xCC
  store_ind output_addr
  halt
