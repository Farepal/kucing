from pwn import *

# Set konteks (architecture dan OS)
context(arch='amd64', os='linux')

# Buat shellcode untuk menjalankan "ls"
shellcode = shellcraft.amd64.linux.ls()

# Cetak shellcode dalam bentuk assembly
print("Assembly Code:")
print(shellcode)

# Compile shellcode ke bentuk biner
binary_shellcode = asm(shellcode)

# Cetak shellcode dalam bentuk hex
print("\nShellcode (Hex):")
print(enhex(binary_shellcode))

# Cetak shellcode dalam format C
print("\nShellcode (C Format):")
print('unsigned char shellcode[] = "', end='')
for byte in binary_shellcode:
    print(f'\\x{byte:02x}', end='')
print('";')