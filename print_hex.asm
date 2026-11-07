;
; code for printing hexadecimal value
;

print_hex:
  ; modifying hex_out to become 0x1fb6
  mov bx, HEX_OUT
  add bx, 0x02
  mov al, dh
  shr al, 0x04
  call convert_to_ascii
  mov byte [bx], al
  add bx, 0x01
  mov al, dh
  and al, 0x0F
  call convert_to_ascii
  mov byte [bx], al
  add bx, 0x01
  mov al, dl
  shr al, 0x04
  call convert_to_ascii
  mov byte [bx], al
  add bx, 0x01
  mov al, dl
  and al, 0x0F
  call convert_to_ascii
  mov byte [bx], al
  jmp .printing_string
  ret

.printing_string:
  mov bx, HEX_OUT
  call print_string

convert_to_ascii:
  cmp al, 10
  jl .is_digit ; it is a digit '0'-'9'. So add '0' to it
  add al, 7, ; there are 7 characters between '9' and 'A'
.is_digit:
  add al, 0x30 ; ascii value of '0' -> 48(0x30)
  ret  

HEX_OUT:
  db "0x0000", 0
