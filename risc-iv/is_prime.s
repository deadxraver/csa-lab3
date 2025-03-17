  .data
input_addr:   .word 0x80
output_addr:  .word 0x84

  .text 

.org 0x85
_start:
  halt
