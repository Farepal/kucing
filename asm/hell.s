global _start

section .text
_start:
    ; Simpan string "Hello HTB Academy!" di stack
    xor rax, rax          ; Clear RAX
    push rax              ; Null-terminator untuk string
    mov rbx, 'y!'         ; Bagian terakhir dari string
    push rbx              ; Push 'y!'
    mov rbx, 'B Academ'    ; Bagian tengah string
    push rbx              ; Push ' Academ'
    mov rbx, 'Hello HT'  ; Bagian awal string
    push rbx              ; Push 'Hello HTB'

    ; RSI menunjuk ke string di stack
    mov rsi, rsp          ; RSI = pointer ke string "Hello HTB Academy!"

    ; Contoh: Cetak string menggunakan syscall write (opsional)
    mov rax, 1            ; Syscall number untuk write
    mov rdi, 1            ; File descriptor 1 (stdout)
    mov rdx, 18           ; Panjang string "Hello HTB Academy!" (18 karakter)
    syscall               ; Panggil syscall

    ; Exit program (syscall exit)
    mov rax, 60           ; Syscall number untuk exit
    xor rdi, rdi          ; Exit code 0
    syscall