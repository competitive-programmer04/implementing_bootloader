[BITS 16]
[ORG 0x7C00]

start:
    ; Initialize segment registers to 0
    xor ax, ax
    mov es, ax
    mov ds, ax

    ; 2 Print initial msg
    mov si, msg
    call print_str 

    ; 3 calling read_sector to loat sector 2 at 0x0500
    mov ax, 0x0000
    mov es, ax ; Destination segment address
    mov bx , 0x0500 ; Destination segment offset
    mov dl, 0x00 ; primary floppy drive
    mov ch, 0x00 ; Cylinder 0(Outermost track)
    mov dh, 0x00 ; Head 0(Top surface)
    mov cl, 0x02 ; 2nd sector
    call read_sector

    ; 4 print the data loaded at 0x0500 to the terminal
    mov si, 0x0500
    call print_str

    ; 5 Loop forever (halt)
    jmp $

    msg db "Reading Sector 2...", 0
    %include "print.asm"
    %include "disk_read.asm"

    ; Boot Sector padding and signature
    times 510 - ($ - $$) db 0
    dw 0xAA55
