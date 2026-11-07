;
; A simple bootloader that will read 5 sectors from disk
; starting from sector 2

[org 0x7C00]

stage1_start:
  ; 1st stage of bootlaoder

  xor ax, ax
  mov ds, ax
  mov es, ax
  mov dl, 0x80 ; primary hard drive

  mov [BOOT_DRIVE], dl ; storing the value of dl in BOOT_DRIVE
                       ; because dl will store the boot drive 
                       ; where we read our second stage and next stage
                       ; code

  mov bp, 0x7C00 ; stack will start at memory address 0x7C00
                 ; and will grow downwards so it will always 
                 ; be below stage 1 bootloader
  mov sp, bp
  mov ah, 0x02
  mov al, 0x04
  mov ch, 0x00
  mov dh, 0x00
  mov cl, 0x02 ; we will read from 2nd sector
               ; because first is boot sector

  mov bx, 0x7E00 ; data of 2nd stage bootloader will be loaded
                 ; at memory address 0x0000:7E00 exactly where
                 ; the stage 1 bootloader is finished
                 ; [es:bx]
  
  int 0x13 ; for disk i/o
  jc disk_err

  ; jump to stage 2
  jmp 0x0000:0x7E00

disk_err:
  mov bx, stage1_disk_err_msg
  call print_string
  jmp $

stage1_disk_err_msg:
  db "Error occured in reading stage2", 0

BOOT_DRIVE: 
  db 0x00

  times 510-($-$$) db 0
  dw 0xaa55
 
stage2_start:
  ; 2nd stage of bootloader
  mov dh, 5 ; we have to read 5 sectors
  mov dl, [BOOT_DRIVE]
  call disk_read

  ; we will print the first words of 5th and 6th sector
  ; that are loaded into memory

  mov dx, [0x9000]
  call print_hex

  mov dx, [0x9000 + 512]
  call print_hex

  jmp $

  %include "print_hex.asm"
  %include "disk_reader.asm"
  %include "print_string.asm"

  ; we will fill sector 6th sector with some data
  times 2048-($-$$) db 0
