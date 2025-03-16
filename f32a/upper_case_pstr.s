    .data

buffer:          .byte  '________________________________'
input_addr:      .word  0x80
output_addr:     .word  0x84
dash_ascii:      .byte  0x5f
error_overflow:  .word  -1
buffer_size:     .word  0x20
byte_mask:       .byte  255


    .text

to_uppercase:
    @p output_addr b!        \;  b for output
    lit buffer lit 1 + a!    \;  a for buf addr + reserved byte for length
loop:
    a lit 0x20 - if end_loop \;  if a == 0x20 => buffer ended
    @+                       \;  buffer[i] -> stack
    @p byte_mask and         \;  cut to byte
    \;TODO:
end_loop:
    ;

read_line:
    @p input_addr b!                \; b for input (*output_addr -> stack, stack -> b)
    lit buffer lit 1 + a!           \; a for buf address (buffer -> stack, stack -> a)
    lit 0                           \; counter for string length
read_line_loop:
    dup                             \; duplicate counter in order not to lose it when comparing to zero
    @p buffer_size - if error       \; no free buffer? -> overflow
    @b                              \; mem[B] -> stack
    @p byte_mask and                \; cut to byte
    dup lit 10 - if read_line_ret   \; if (c == '\n') goto read_line_ret
    !                               \; save char to buffer
    lit -1 +                        \; decrement counter
    read_line_loop ;                \; jump to next iteration
read_line_ret:
    drop                            \; remove \n from top of the stack
    lit buffer a! !                 \; string_length -> buffer[0]
    ;

print_buf:
    \;TODO:
    ;

error:
    @p output_addr a!        \; a for output
    @p error_overflow !
    halt

_start:
    read_line
    to_uppercase
    print_buf
    halt
