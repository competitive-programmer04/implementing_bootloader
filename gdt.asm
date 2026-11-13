; Global segment descriptor table code in assembly

gdt_start:
  
  gdt_null: ; the required null descriptor
    dd 0x0 ; dd -> 4 bytes, dw -> 2 bytes, db -> 1 byte
    dd 0x0

  gdt_code: ; the code segment decriptor
    ; Base address -> 0x00000000
    ; Limit -> 0xFFFFF
    ; Acess Bytes -> P=1, DPL=00, S=1, E=1, Conforming=0, R=1, A=0
    ; Other Flags -> G=1, D/B=1, L=0, AVL=0
    dw 0xFFFF ; (Limit bits 0->15)
    dw 0x0000 ; (Base bits 0->15)
    db 0x00 ; (Base bits 16->23)
    db 10011010b ; (Access Flags)
    db 11001111b ; (first 4 bits other flags, last four bits Limit bits(16->19))
    db 0x00 ; (Base bits 24-31)

  gdt_data: ; the data segment descriptor
    ; Base address -> 0x00000000
    ; Limit -> 0xFFFFF
    ; Access Bytes -> P=1, DPL=00, S=1, E=0, Direction=0(grow upwards) R=1(writable), A=0
    ; Other Flags -> G=1, D/B=1, L=0, AVL=0
    dw 0xFFFF ;(Limit Bits 0->15)
    dw 0x0000 ; (Base Bits 0->15)
    db 0x00 ; (Base Bits 16->23)
    db 10010010b ; (Access Flags)
    db 11001111b ; (first 4 bits other flags, last four bits Limit Bits(16->19))
    db 0x00 ; (Base Bits 24->31)

gdt_end: ; We are putting the end label here so we can calculate the
         ; size of gdt and can put in the first 16 bits of gdt descriptor

gdt_descriptor:
  dw gdt_end-gdt_start-1
  dd gdt_start

  CODE_SEG equ gdt_code - gdt_start
  DATA_SEG equ gdt_data - gdt_start
  STACK_SEG equ gdt_data - gdt_start
