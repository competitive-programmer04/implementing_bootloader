; 16-bit real mode game

[bits 16]

my_game:
  ; CONSTANTS
  VIDEOGRAMEM equ 0xA000
  SCREENWID equ 320
  SCREENHIG equ 200
  BGCOLOR equ 0x01
  APPLECOLOR equ 0x04
  SNAKECOLOR equ 0x02
  TIMER equ  0x0046
  MAX_SNAKE_LEN equ 100
  SNAKE_XPOS_ARR:
    times MAX_SNAKE_LEN db 0x00
  SNAKE_YPOS_ARR:
    times MAX_SNAKE_LEN db 0x00

  ; 1 body part of snake is a 4x4 grid block
  ; number of columns = 320/4 = 80
  ; number of rows = 200/4 = 50
  MAX_WIDTH equ 80
  MAX_HEIGHT equ 50

  ; VARIABLES
  INI_SNAKE_XPOS:
    db 0x4F
  INI_SNAKE_YPOS:
    db 0x19
  APPLE_XPOS:
    db 0x27
  APPLE_YPOS:
    db 0x19
  CURR_SNAKE_LEN:
    db 0x01
  jmp my_game_start

my_game_start:
  ; switching to mode 0x13 => 320x200 vga graphics mode
  mov ax, 0x0013 ; ah = 0x00(video mode), al = 0x13(320x200 vga graphics mode)
  int 0x10

  mov ax, VIDEOGRAMEM
  mov es, ax
  xor di, di
  ; storing the initial position of the snake in both arrays
  mov al, [INI_SNAKE_XPOS]
  mov ah, [INI_SNAKE_YPOS]
  mov [SNAKE_XPOS_ARR + CURR_SNAKE_LEN - 1], al
  mov [SNAKE_YPOS_ARR + CURR_SNAKE_LEN - 1], ah
  jmp my_game_loop

my_game_loop:
  ;first clear the game screen
  call clear_game_screen

  ;second draw the snake here we also check for collisions and win condition
  call draw_snake

  ;listen for user input
  call listen_user_inp

  ; check for snake eat apple or not
  call snake_eat_apple_or_not

  ; repeat the whole process until you wins or loose
  jmp my_game_loop

clear_game_screen:
  ; do something
  mov dx, 0x00C8
  mov ax, 0x0140
  mul dx
  mov cx, ax
  mov ax, 0x0001
  cld
  rep stosw
  ret

draw_snake:
  ; do something


listen_user_inp:
  ; do something

check_snake_eat_apple_or_not:
  cmp al, [APPLE_XPOS]
  jne .snake_not_eat_apple
  cmp ah, [APPLE_YPOS]
  je .snake_eat_apple
  jmp .snake_not_eat_apple

.snake_not_eat_apple:
  ; do something
  ret

.snake_eat_apple:
  ; do something
  ret

end_game:
  mov ax, 0x0003 ; jumping back to 80x25 vga text mode
  int 0x10
  ret
