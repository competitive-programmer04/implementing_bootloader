; 
; Reading some sectors from the disk
;

disk_read:
  push dx ; pushing dx to stack to save its value
  mov ah, 0x02 ; for reading data from the disk
  mov al, dh ; dh will store the number of sectors that we will read
  mov ch, 0x00 ; cylinder 0 (outermost track)
  mov dh, 0x00 ; top surface
  mov cl, 0x06 ; we will read from sixth sector
               ; because first is boot sector and 
               ; other 4 sectors are second stage of
               ; bootloader
  
  mov bx, 0x9000 ; load data at 0x0000:0x9000
  int 0x13 ; for disk i/o
  jc disk_error
  ; just an extra check
  pop dx
  cmp al, dh
  jne disk_error ; al != dh -> no. of sectors read != no. of sectors requested
  ret

disk_error:
  mov bx, stage2_disk_err_msg1
  call print_string
  mov bx, stage2_disk_err_msg2
  call print_string
  mov dx, ax
  call print_hex
  jmp $


stage2_disk_err_msg1:
  db "Disk Read Error", 0

stage2_disk_err_msg2:
  db 0x0D, 0x0A, "Error Code: ", 0
