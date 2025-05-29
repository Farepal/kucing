#!/bin/bash

# Cek dependency
command -v openssl >/dev/null 2>&1 || { echo >&2 "openssl tidak ditemukan."; exit 1; }
command -v btcdeb >/dev/null 2>&1 || { echo >&2 "btcdeb tidak ditemukan."; exit 1; }

# Step 1: Ambil public key uncompressed (65 byte hex)
PUBKEY_HEX=$(openssl ec -in privkey.pem -pubout -outform DER | tail -c 65 | xxd -p -c 65)
echo "[+] Public key (uncompressed): $PUBKEY_HEX"

# Step 2: Hitung pubKeyHash (RIPEMD160(SHA256(pubkey)))
PUBKEY_HASH=$(python3 -c "
import hashlib
pk=bytes.fromhex('$PUBKEY_HEX')
h=hashlib.new('ripemd160', hashlib.sha256(pk).digest()).hexdigest()
print(h)
")
echo "[+] pubKeyHash (HASH160): $PUBKEY_HASH"

# Step 3: Gunakan dummy signature (bukan signature valid, tapi cukup untuk btcdeb simulasi)
DUMMY_SIG="3045022100dff1d77f2a671c5f962d8e7f8aa1fa74018e15f0b8e4e693b7b5e0a4f9a456f5022032e7d1dff58d3258a166779f91ebc0a400000000"

# Step 4: Jalankan btcdeb
echo -e "\n[+] Menjalankan btcdeb..."
btcdeb -s "$DUMMY_SIG $PUBKEY_HEX" "OP_DUP OP_HASH160 $PUBKEY_HASH OP_EQUALVERIFY OP_CHECKSIG"

