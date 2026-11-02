read_sector:
    mov ah, 0x02 ; for reading
    mov al, 0x01 ; only one sector to read
    int 0x13 ; interrupt for reading/writing data in the disk
    jc .fail ; jump if carry flag(CF) is set (failure)
    ret

.fail:
    mov si, read_err_msg
    call print_str

read_err_msg db "Disk Read Error", 0
