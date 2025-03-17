    .data

buffer:          .byte  '______________________________________'
buffer_to_word:  .byte  '___'
byte_to_word:    .byte  '\0___'
input_addr:      .word  0x80
output_addr:     .word  0x84
dash_ascii:      .byte  0x5f
error_overflow:  .word  0xCCCC_CCCC \; почему не -1?
buffer_size:     .word  0x20
byte_mask:       .word  255

    .text
.org 0x85
to_uppercase:dup lit 'a' inv lit 1 + + -if ok_go_on ;
ok_go_on:dup lit 'z' inv + -if to_uppercase_end lit 'a' inv lit 1 + + lit 'A' +
to_uppercase_end:;
read_line:@p input_addr b! lit buffer lit 1 + a! lit 0 lit 0 @p byte_to_word + !p buffer
read_line_loop:dup @p buffer_size over inv lit 1 + + if error @b @p byte_mask and dup lit -10 + if read_line_ret to_uppercase 
 @p byte_to_word + !+ lit 1 + read_line_loop ;
read_line_ret:drop lit buffer @p byte_mask and a! @p buffer + ! ;
print_buf:@p output_addr b! @p buffer @p byte_mask and lit buffer lit 1 + a!
print_buf_loop:dup if print_buf_end @+ @p byte_mask and !b lit -1 + print_buf_loop ;
print_buf_end:;
error:@p output_addr a! @p error_overflow ! halt
_start:read_line
 print_buf
 halt

