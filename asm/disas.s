global _start

section .text
_start:
  ; Push nilai-nilai ke stack
  mov rax, 0xa284ee5c7cde4bd7
  push rax
  mov rax, 0x935add110510849a
  push rax
  mov rax, 0x10b29a9dab697500
  push rax
  mov rax, 0x200ce3eb0d96459a
  push rax
  mov rax, 0xe64c30e305108462
  push rax
  mov rax, 0x69cd355c7c3e0c51
  push rax
  mov rax, 0x65659a2584a185d6
  push rax
  mov rax, 0x69ff00506c6c5000
  push rax
  mov rax, 0x3127e434aa505681
  push rax
  mov rax, 0x6af2a5571e69ff48
  push rax
  mov rax, 0x6d179aaff20709e6
  push rax
  mov rax, 0x9ae3f152315bf1c9
  push rax
  mov rax, 0x373ab4bb0900179a
  push rax
  mov rax, 0x69751244059aa2a3
  push rax

  ; Set kunci XOR di rbx
  mov rbx, 0x2144d2144d2144d2

  ; Simpan rsp (stack pointer) di rdx
  mov rdx, rsp

  ; Hitung jumlah elemen di stack (setiap elemen 8 byte)
  mov rcx, 14  ; Ada 14 nilai yang di-push ke stack

decode_loop:
  ; Lakukan operasi XOR antara nilai di [rdx] dan rbx
  xor qword [rdx], rbx

  ; Pindah ke 8-byte berikutnya di stack
  add rdx, 8

  ; Kurangi counter dan ulangi loop jika belum selesai
  loop decode_loop

  ; Exit program (syscall exit)
  mov rax, 60         ; syscall number for exit
  xor rdi, rdi        ; exit code 0
  syscall