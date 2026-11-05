;
; A simple boot scetor program that demonstrates stack
;

[org 0x7c00]

mov ah, 0x0e

my_string:
  db "hello, world", 0

mov bx, my_string
add bx, 0x7c00

mov bp, 0x8000 ; stack will start from memory address 0x8000 which 
               ; will be in kb away form boot sector
mov sp, bp

my_push_loop:
  cmp [bx], 0
  je my_pop_loop
  push [bx]
  add bx, 0x1
  jmp my_push_loop

my_pop_loop:
  cmp sp, bp
  je done
  pop bx
  mov al, bl
  int 0x10
  jmp my_pop_loop

done:
  ret

times 510-($-$$) db 0
dw 0xaa55
