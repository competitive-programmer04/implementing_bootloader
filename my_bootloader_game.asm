; 16-bit real mode game

[bits 16]

my_game:
  mov ax, 0x0013 ; ah = 0x00(for graphics mode), al = 0x13(320x200 resolution)
                 ; where we will use the 256 color palatte
  int 0x10

  mov ax, 0xA000
  mov es, ax

  mov dx, 100 ; Y coordinate
  mov cx, 160 ; X coordinate
  mov ax, 320
  mul dx ; mul always multiply the operand register with ax
         ; and store the upper 16 bits of result in dx and
         ; lower 16 bits in ax
  add ax, cx ; 320*y + x
  mov bx, ax
  mov byte [es:bx], 0x0E ; 0xA0000 + 32160 -> (160, 100) at this
                         ; we store the color pointed by 0x0E in the
                         ; 256 color palatte array
  mov ah, 0x00
  int 0x16
  cmp al, 0x71 ; q for quit the graphics mode
  je quit_graphics

  jmp $

quit_graphics:
  mov ax, 0x0003 ; al = 0x03 for 80x25 vga text mode
  int 0x10
  ret
