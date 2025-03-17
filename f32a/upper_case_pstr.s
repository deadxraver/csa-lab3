    .data

buffer:          .byte  '______________________________________'
buffer_to_word:  .byte  '___'
byte_to_word:    .byte  '\0___'
input_addr:      .word  0x80
output_addr:     .word  0x84
dash_ascii:      .byte  0x5f
error_overflow:  .word  -1
buffer_size:     .word  0x20
byte_mask:       .word  255
alignment:       .word '..........'

\; lit <value> inv lit 1 + +   ==    -value
    .text

to_uppercase:
    @p output_addr b!        \;  b for output
    lit buffer lit 1 + a!    \;  a for buf addr + reserved byte for length
loop:
    a @p buffer_size inv lit 1 + + if end_loop \;  if a == 0x20 => buffer ended
    @+                       \;  buffer[i] -> stack
    @p byte_mask and         \;  cut to byte
    \;TODO:
end_loop:
    ;

read_line:
    @p input_addr b!                \; b for input (*output_addr -> stack, stack -> b)
    lit buffer lit 1 + a!           \; a for buf address (buffer -> stack, stack -> a)
    lit 0 lit 0                     \; counter for string length
    @p byte_to_word +
    !p buffer
read_line_loop:
    dup                             \; duplicate counter in order not to lose it when comparing to zero
    @p buffer_size over inv lit 1 + + if error       \; no free buffer? -> overflow
    @b                              \; mem[B] -> stack
    @p byte_mask and                \; cut to byte
    dup lit -10 + if read_line_ret  \; if (c == '\n') goto read_line_ret
    @p byte_to_word +
    !+                              \; save char to buffer (buf[i++] = c)
    lit 1 +                         \; decrement counter
    read_line_loop ;                \; jump to next iteration
read_line_ret:
    drop                            \; remove \n from top of the stack
    lit buffer 
    @p byte_mask and
    a!
    @p buffer +
    !                 \; string_length -> buffer[0]
    ;

print_buf:
    @p output_addr b!               \; b for output
    @p buffer @p byte_mask and      \; str len on top of the stack
    lit buffer 
    lit 1 + 
    a!          \; a for char pointer, skipping len
print_buf_loop:
    dup
    if print_buf_end                \; len == 0 ? goto end
    @+ 
    @p byte_mask and
    !b                           \; buf[i] -> output
    lit -1 +                        \; i--
    print_buf_loop ;
print_buf_end:
    ;

error:
    @p output_addr a!        \; a for output
    @p error_overflow !
    halt

_start:
    read_line
    \to_uppercase
    print_buf
    halt
