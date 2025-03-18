  .data
input_addr:   .word 0x80
output_addr:  .word 0x84

  .text

.org 0x85

sqrt: ; t0 - input_number, t3 - return, a0 - counter, a1 - return address
  ; a0 = t3 * t3; a0 >= t0 ? ret ; t3++
  xor       t3, t3, t3
sqrt_loop:
  addi      t3, t3, 1
  mul       a0, t3, t3
  bgt       t0, a0, sqrt_loop
  jr        a1                              ; ret

_start:
  ; t0 - input_addr
  lui       t0, %hi(input_addr)             ; higher byte to higher byte
  addi      t0, t0, %lo(input_addr)         ; lower byte to lower byte
  lw        t0, 0(t0)                       ; load the input_addr itself
  ; t0 - input number, t1 - divisor, t2 - remainder, t3 - max divisor (for loop)
  lw        t0, 0(t0)                       ; load value from input
  xor       t1, t1, t1                      ; t1 = 0
  ble       t0, t1, error                   ; n < 1 ? goto error
  addi      t1, t1, 2                       ; t1 = 2
  bgt       t1, t0, not_prime               ; n < 2 ? goto not_prime
  beq       t1, t0, is_prime
  jal       a1, sqrt                        ; call sqrt
  ;div       t3, t0, t1                      ; t3 = n / 2
  ;addi      t3, t3, 1                       ; t3 = n / 2 + 1
loop:
  ; t2 = t0 % t1; t2 ? goto not_prime; t1++; t1 >= t3 ? goto is_prime
  rem       t2, t0, t1
  beqz      t2, not_prime
  addi      t1, t1, 1
  ble       t3, t1, is_prime
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

