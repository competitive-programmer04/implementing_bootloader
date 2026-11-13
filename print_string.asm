; In 16-bit real mode

; print_char:
  ; mov ah, 0x0E
  ; int 0x10
  ; ret

;print_string:
  ;my_loop:
    ;cmp byte [bx], 0
    ;je done
    ;mov al, [bx]
    ;call print_char
    ;add bx, 0x01
    ;jmp my_loop

;done:
  ;ret


; 32-bit protected mode

[bits 32]
; Defining some conatants
VIDEO_GRPHICS_ARR equ 0xb8000
WHITE_ON_BLACK equ 0x0f

; prints a null-terminated string pointed by ebx
print_string_pm:
  pusha
  mov edx, VIDEO_GRAPHICS_ARR ; Set edx to the start of the Video Graphics Array

print_string_pm_loop:
  ; In text mode we use the Video Graphics Array(VGA) which is 80x25 (80 Columns and 25 Rows)
  ; that means it has 2000 cells where each cell occupies 2 bytes
  ; first byte -> stores the ascii code of character
  ; second byte -> stores the color attributes of character

  mov al, [ebx] ; storing the character in the first byte
  mov ah, WHITE_ON_BLACK ; storing the color attributes in second byte
  cmp al, 0 ; string ends
  jmp print_string_pm_done

  add ebx, 1 ; mov ebx to the next character
  add edx, 2 ; mov edx to the next character cell
  jmp print_string_pm_loop

print_string_pm_done:
  popa
  ret ; Return from the function
