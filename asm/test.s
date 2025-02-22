global _start

section .text
_start:
    mov al, 255
    add al, 1

_start2:
    xor al, al
    mov al, -1
    add al, 1
    jmp _start3

_start3:
    xor al, al
    mov al, 127
    add al, 1
    add al, 1