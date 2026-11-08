# Implementing Bootloader from scratch for intel 80386 processor

## Requirements
- nasm
 ```
 sudo apt install nasm
 ```
- qemu
 ```
 sudo apt install qemu-system
 ```

## How to and compile and run it

```
nasm my_bootloader.asm -f bin -o my_bootloader.bin

qemu-system-i386 my_bootloader.bin
```
Currently it will only print two 16 bits hexadecimal words on the qemu screen

## References
```
Writing a simple Operating System from Scratch by Nick Blundell
```
