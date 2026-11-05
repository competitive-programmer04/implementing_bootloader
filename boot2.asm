;
; A simple boot sector that prints a message to the screen using a BIOS routine

mov ah, 0x0e ; teletype mode
mov al, 'H'
int 0x10 ; BIOS interrupt for handling screen related tasks
mov al, 'e'
int 0x10
mov al, 'l'
int 0x10
mov al, 'l'
int 0x10
mov al, 'o'
int 0x10

jmp $

times 510-($-$$) db 0
dw 0xaa55
