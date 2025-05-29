import google.generativeai as genai
import os
import sys

# --- Cara Aman Mengambil API Key ---
api_key = "AIzaSyBKKU6hH6AA-pWP3r4cBLLp7uYzpod8WUQ"

if not api_key:
    print("Kesalahan: Environment variable 'GEMINI_API_KEY' belum diatur.")
    print("Silakan atur environment variable sebelum menjalankan skrip ini.")
    sys.exit(1) # Keluar dari skrip jika key tidak ditemukan

try:
    # Konfigurasi library dengan API Key
    genai.configure(api_key=api_key)

    # --- Pilih Model ---
    model = genai.GenerativeModel('gemini-2.0-flash')

    # --- Buat Prompt Sederhana ---
    prompt_tes = "Apa definisi dari kesehatan mental berdasarkan pendefinisian yang tepat dengan menggunakan genus dan differentia?"
    print(f"Mengirim prompt: '{prompt_tes}'")

    response = model.generate_content(prompt_tes)

    print("\n--- Respons dari Gemini ---")
    if response.text:
        print(response.text)
    else:
        print("Tidak menerima respons teks. Detail respons:")
        print(response) # Cetak seluruh objek respons untuk debugging

    print("\n--------------------------")
    print("Tes API Key berhasil jika Anda melihat respons di atas.")

except Exception as e:
    print("\n--- Terjadi Kesalahan ---")
    print(f"Error: {e}")
    print("Pastikan API Key Anda valid, environment variable sudah benar,")
    print("dan Anda memiliki koneksi internet serta kuota API yang cukup.")
    print("--------------------------")