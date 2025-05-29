from bitcoin import *

# Menghasilkan private key secara acak
private_key = random_key()

# Mendapatkan public key dari private key
public_key = privtopub(private_key)

# Mendapatkan alamat Bitcoin dari public key
bitcoin_address = pubtoaddr(public_key)

# Menampilkan hasil
print("Private Key (HEX):", private_key)
print("Public Key:", public_key)
print("Bitcoin Address:", bitcoin_address)
