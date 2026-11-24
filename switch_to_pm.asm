; switching to 32-protected mode

[bits 16]

switch_to_pm:

  cli ; disabling the interrupts until we reach to 32-bit protected mode
      ; because processor can still use BIOS IVT to handle interrupts
      ; which only work in real mode not protected mode

  lgdt[gdt_descriptor] ; loading the global descriptor table

  mov eax, cr0 ; setting the first bit of cr0 to 1 which enables
  or eax, 0x01 ; protected mode
  mov cr0, eax

  jmp CODE_SEG:init_pm ; far jump to flush all the 16-bit prefetch
                       ; instructions from the cpu pipeline when 
                       ; jumping to 32-bit protected mode and set cs
                       ; to store the index of code segment descriptor 
                       ; in gdt
[bits 32]
; Initializing 32-bit protected mode
init_pm:
  mov ax, DATA_SEG
  mov ds, ax ; storing the index of data segment descriptor in ds
  mov ss, ax ; storing the index of data segment descriptor in ss
  mov es, ax ; storing the index of data segment descriptor in es
  mov fs, ax
  mov gs, ax

  mov ebp, 0x9fc00 ; starting the stack in protected mode from the 
                   ; top of the free 637KB address space in the real
                   ; mode 1MB ram
  mov esp, ebp
  call .BEGIN_PM

.BEGIN_PM:
  mov edx, 0xB8000 ; storing the address of 80x25 vga text array in edx
  mov ecx, 0
  clear_screen:
    cmp ecx, 0x07D0 ; 0x7D0 = 2000 -> number of cells in the array
    jge .done
    mov ax, 0x0720 ; ah = 0x07(grey-on-black), al = 0x20(space character) 
    mov [edx], ax
    add edx, 0x2
    add ecx, 0x1
    jmp clear_screen

  .done:
    mov ebx, PROT_MODE_MSG
    call print_string_pm
    jmp $

PROT_MODE_MSG:
  db "Successfully jumped to 32-bit protected mode", 0
