from pwn import *

# Atur konteks
context(os="linux", arch="amd64", log_level="error")

# Buat shellcode untuk execve("/bin/ls", ["/bin/ls"])
shellcode = asm(shellcraft.amd64.linux.execve("/bin/ls", ["/bin/ls"]))

# Jalankan shellcode
p = process('/bin/sh')
p.sendline(shellcode)
p.interactive()