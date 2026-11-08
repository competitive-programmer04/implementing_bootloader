;
; A simple multistage bootloader that will read 5 sectors from disk
;

[org 0x7C00]
[bits 16]

SECTION .text

stage1_start:
  ; 1st stage of bootlaoder

  xor ax, ax
  mov es, ax
  mov ds, ax
  mov ss, ax

  mov [BOOT_DRIVE], dl

  mov bp, 0x7C00 ; stack will start at memory address 0x7C00
                 ; and will grow downwards so it will always 
                 ; be below stage 1 bootloader
  mov sp, bp
  mov dl, [BOOT_DRIVE]
  mov ah, 0x02
  mov al, stage2_sectors
  mov ch, 0x00
  mov dh, 0x00
  mov cl, 0x02 ; we will read from 2nd sector
               ; because first is boot sector

  mov bx, 0x7E00 ; data of 2nd stage bootloader will be loaded
                 ; at memory address 0x0000:0x7E00 exactly where
                 ; the stage 1 bootloader is finished
                 ; [es:bx]
  
  int 0x13 ; for disk i/o
  jc disk_err

  ; jump to stage 2
  jmp 0x0000:0x7E00

disk_err:
  jmp $ ; halt

BOOT_DRIVE:
  db 0x00

times 510-($-stage1_start) db 0
dw 0xaa55

stage2_start:
  ; 2nd stage of bootloader
  mov dx, 0x0000 ; clearing dx to store new value
  mov dh, 0x05 ; we have to read 5 sectors
  mov dl, [BOOT_DRIVE] 
  mov cx, 0x0000
  add cl, 0x01
  add cl, stage2_sectors
  add cl, 0x01 ; so cl will point to the next sector that I want to read
  mov bx, 0x9000
  call disk_read

  mov dx, [0x9000]
  call print_hex

  mov dx, [0x9000 + 512]
  call print_hex

  jmp $

  %include "disk_reader.asm"
  %include "print_hex.asm"
  %include "print_string.asm"

stage2_end:

stage2_bytes equ (stage2_end - stage2_start)
stage2_sectors equ (stage2_bytes + 511)/512

; we will fill our extra space with some data
times (stage2_sectors * 512)- stage2_bytes db 0

; we will write the other 5 sectors with some data
times 256 dw 0xabab
times 256 dw 0xcdcd
times 256 dw 0xefef
times 256 dw 0xface
times 256 dw 0xabce
