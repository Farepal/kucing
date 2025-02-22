section .text
    global _start

_start:
    xor rdx, rdx
    xor eax, eax
    xor eax, eax
    xor DWORD [rsi], edx
    jle 0x71
    scasd
    xor eax, r8d
    xor DWORD [rbx-0x1976b759], edi
    mov DWORD [rax+0x31], ecx
    push rbx
    movabs rbx, 0x4377b64bc031d231
    push rax
    xor eax, eax
    xor DWORD [rax], edx
    movsxd edx, DWORD [rsi]
    and BYTE [rax+0x31], dl
    shl BYTE [rcx], 0x48
    mov ebx, 0xc031d231
    xor eax, eax
    and DWORD [rcx], r8d
    xor DWORD [rax+0x31], ecx
    shl BYTE [rcx], 0x48
    mov esi, esp
    mov DWORD [rax+0x31], ecx
    ror BYTE [rcx-0x81df739], cl
    xor rax, rax
    mov al, 0x1
    xor rdi, rdx
    mov dil, 0x1
    xor rsi, rsi
    mov rsi, rsp
    xor rdx, rdx
    mov dl, 0x1e
    syscall
    xor rax, rax
    add rax, 0x3c
    xor rdi, rdi
    syscall