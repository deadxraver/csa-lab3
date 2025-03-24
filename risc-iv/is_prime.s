  .data
input_addr:   .word 0x80
output_addr:  .word 0x84
  .text

is_prime:
  ; args: t0 - number to be checked whether it is prime, a0 - return addres
  ; returns: t1 - 1 or 0 depending on whether the input number is prime
  addi      sp, sp, -4                    ; reserve 1 word in stack for return addr 
  sw        a0, 0(sp)                     ; push return address to stack

  xor       t1, t1, t1                    ; t1 = 0
  ble       t0, t1, is_prime_error        ; n < 1 => error
  addi      t1, t1, 2                     ; t1 = 2
  bgt       t1, t0, is_prime_false        ; n < 2 (n == 1) => not prime
  beq       t1, t0, is_prime_true         ; n == 2 ? => prime

is_prime_loop:
  rem       t2, t0, t1
  beqz      t2, is_prime_false
  mul       t2, t1, t1
  bleu      t0, t2, is_prime_true
  addi      t1, t1, 1
  j         is_prime_loop
is_prime_true:
  xor       t1, t1, t1
  addi      t1, t1, 1
  j         is_prime_ret
is_prime_false:
  xor       t1, t1, t1
  j         is_prime_ret
is_prime_error:
  xor       t1, t1, t1
  addi      t1, t1, -1
is_prime_ret:
  lw        a0, 0(sp)                     ; load return address from stack
  addi      sp, sp, 4                     ; free stack memory
  jr        a0                            ; ret


print_res:
  addi      sp, sp, -4
  sw        a0, 0(sp)

  lui       t0, %hi(output_addr)
  addi      t0, t0, %lo(output_addr)
  lw        t0, 0(t0)
  sw        t1, 0(t0)

  j         skip                          ; secret memory optimization
  mv        t0, t0                        ; =//=
  mv        t0, t0                        ; =//=
  skip:

  lw        a0, 0(sp)
  addi      sp, sp, 4
  jr        a0


_start:
  lui       t0, %hi(input_addr)             ; higher byte to higher byte
  addi      t0, t0, %lo(input_addr)         ; lower byte to lower byte
  lw        t0, 0(t0)                       ; load the input_addr itself

  lw        t0, 0(t0)                       ; load value from input

  jal       a0, is_prime                    ; call is_prime
  jal       a0, print_res
  halt


