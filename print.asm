; print a single character stored in AL

print_char:
    mov ah, 0x0E ; teletype mode
    mov bh, 0x00 ; Display page 0
    mov bl, 0x07 ; White on black color and vice-versa
    int 0x10
    ret

; printing a null terminated string(DS:SI -> string)

print_str:
.print_loop:
    lodsb ; loading byte from [DS:SI] to al and incrementing SI
    cmp al, 0 ; comapring al from null terminator
    je .done
    call print_char
    jmp .print_loop

.done:
ret
