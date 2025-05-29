from bitcoin import *
import hashlib

# Menghasilkan private key secara acak
private_key = "3477deeeb88811c23b7bb31b52f41f4c56225a5fb42f8494b044cd4f7b691732"

# Mendapatkan public key dari private key
public_key = privtopub(private_key)

# Mendapatkan alamat Bitcoin dari public key
bitcoin_address = pubtoaddr(public_key)

# Membuat pesan untuk ditandatangani
message = "Hello, Bitcoin!"

# Membuat hash dari pesan
message_hash = hashlib.sha256(message.encode()).hexdigest()

# Membuat digital signature
signature = ecdsa_sign(message, private_key)

# Menampilkan hasil
print("Message Hash (HEX):", message_hash)
print("Private Key (HEX):", private_key)
print("Public Key:", public_key)
print("Bitcoin Address:", bitcoin_address)
print("Bitcoin Address (HEX):", bitcoin_address.encode('utf-8').hex())
print("\nDigital Signature:")
print(signature)
print("Signature (HEX):", base64.b64decode(signature).hex())
print("Message:", message)
print("Message Hash:", message_hash)