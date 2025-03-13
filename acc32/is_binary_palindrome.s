    .data

input_addr:      .word  0x80               ; input
output_addr:     .word  0x84               ; output
n:               .word  0x00               ; input variable
n1:              .word  0x00               ; copy of input
n2:              .word  0x00               ; variable to be compared with n1
i:               .word  0x00               ; var for loops
one:             .word  0x01               ; const for bitwise AND & shift left & decrement а че ваще декремента нет лоол)
alignment:       .word  '.......'

    .text

_start:
    load_ind     input_addr                  ; acc = *input_addr
    store        n                           ; n = acc
    store        n1                          ; n1 = acc

revert_n:
    load_imm     32                          ; counter for loop
    store        i                           ; i = 32

loop:
    load         i                           ; acc = i
    beqz         end_loop                    ; i == 0 ? -> end_loop
    sub          one                         ; i--
    store        i                           ; save i
    load         n2                          ; load n2
    shiftl       one                         ; n2 <<
    store        n2                          ; save n2
    load         n1                          ; acc = n1
    and          one                         ; n1 & 1
    add          n2                          ; n2 + n1 mod 2
    store        n2                          ; save n2
    load         n1
    shiftr       one                         ; n1 >>
    store        n1
    jmp          loop                        ; next iteration

end_loop:
    load         n                           ; acc = n
    sub          n2                          ; n1 - n2
    bnez         is_not_palindrome           ; n1 != n2 => not palindrome
is_palindrome:
    load_imm     1                           ; true
    store_ind    output_addr                 ; stdout
    halt
is_not_palindrome:
    load_imm     0                           ; false
    store_ind    output_addr                 ; stdout
    halt

