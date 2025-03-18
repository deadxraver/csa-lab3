  .data
input_addr:   .word 0x80
output_addr:  .word 0x84

  .text

.org 0x85

_start:
  ; t0 - input_addr
  lui       t0, %hi(input_addr)             ; higher byte to higher byte
  addi      t0, t0, %lo(input_addr)         ; lower byte to lower byte
  lw        t0, 0(t0)                       ; load the input_addr itself
  ; t0 - input number, t1 - divisor, t2 - remainder/divisor^2
  lw        t0, 0(t0)                       ; load value from input
  xor       t1, t1, t1                      ; t1 = 0
  ble       t0, t1, error                   ; n < 1 ? goto error
  addi      t1, t1, 2                       ; t1 = 2
  bgt       t1, t0, not_prime               ; n < 2 ? goto not_prime
  beq       t1, t0, is_prime
loop:
  ; t2 = t0 % t1; t2 ? goto not_prime; t2 = t1^2; t2 >= t0 ? goto is_prime
  rem       t2, t0, t1
  beqz      t2, not_prime
  mul       t2, t1, t1
  ble       t0, t2, is_prime
  addi      t1, t1, 1
  j         loop
error:
  xor       t1, t1, t1
  addi      t1, t1, -1
  j         print_res
is_prime:
  xor       t1, t1, t1
  addi      t1, t1, 1
  j         print_res
not_prime:
  xor       t1, t1, t1
print_res:
  lui       t0, %hi(output_addr)
  addi      t0, t0, %lo(output_addr)
  lw        t0, 0(t0)
  sw        t1, 0(t0)
  halt

