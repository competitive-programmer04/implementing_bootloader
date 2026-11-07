print_char:
  mov ah, 0x0E
  int 0x10
  ret

print_string:
  my_loop:
    cmp byte [bx], 0
    je done
    mov al, [bx]
    call print_char
    add bx, 0x01
    jmp my_loop

done:
  ret
