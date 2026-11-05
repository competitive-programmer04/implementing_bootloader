;
; a simple boot sector program that demonstrates addressing

[org 0x7c00]

mov ah, 0x0e

; First try
mov al, the_char
int 0x10

; second try
mov al, [the_char]
int 0x10

; third try
; this will print 'V' in the screen
mov bx, the_char
add bx, 0x7c00
mov al, [bx]
int 0x10

; fourth try
mov al, [0x7c1e]
int 0x10

the_char:
  db 'V'

times 510-($-$$) db 0
dw 0xaa55
