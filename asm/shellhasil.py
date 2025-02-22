from pwn import *

# Shellcode dalam bentuk hex (dari output pwn disasm)
shellcode_hex = "4831d231c031c031167e66af4431c031bba74889e68948314c5348bb31d231c04bb677435031c031106316205031c03148bb31d231c031c0442101314831c0314889e6894831d289c708e2f74831c0b0014831d742b7014831f64889e64831d2b21e0f054831c04883c03c4831ff0f05"

# Konversi hex ke bytes
shellcode = bytes.fromhex(shellcode_hex)

# Jalankan shellcode menggunakan run_assembly
p = run_assembly(shellcode)

# Interaksi dengan proses (opsional)
p.interactive()