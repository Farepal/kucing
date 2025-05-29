import paho.mqtt.client as mqtt
import time
import json
import random

# --- Konfigurasi MQTT Broker (LOKAL) ---
MQTT_BROKER_HOST = "broker.hivemq.com"
MQTT_BROKER_PORT = 1883
MQTT_KEEP_ALIVE_INTERVAL = 60

# --- Topik Sederhana (harus cocok dengan ESP) ---
DEVICE_ID_TARGET = "esp_virtual_01" # Target ESP yang akan dikontrol
TOPIC_DATA_SUBSCRIBE = f"simulasi/{DEVICE_ID_TARGET}/data"
TOPIC_COMMAND_PUBLISH = f"simulasi/{DEVICE_ID_TARGET}/command"

def on_connect_backend(client, userdata, flags, rc, properties=None):
    print("-" * 50)
    print("[BACKEND] Callback on_connect_backend dipanggil.")
    print(f"[BACKEND]   Kode hasil koneksi (rc): {rc} --- (0 = Sukses)")
    if rc == 0:
        print(f"[BACKEND] Berhasil terhubung ke Broker MQTT: {MQTT_BROKER_HOST}")
        print(f"[BACKEND]   Mencoba subscribe ke topik data: '{TOPIC_DATA_SUBSCRIBE}'")
        result, mid = client.subscribe(TOPIC_DATA_SUBSCRIBE, qos=1)
        if result == mqtt.MQTT_ERR_SUCCESS:
            print(f"[BACKEND]   Subscribe ke '{TOPIC_DATA_SUBSCRIBE}' BERHASIL (mid: {mid})")
        else:
            print(f"[BACKEND-PERINGATAN] Subscribe ke '{TOPIC_DATA_SUBSCRIBE}' GAGAL, kode: {result}")
    else:
        print(f"[BACKEND-PERINGATAN] GAGAL terhubung ke broker (rc: {rc}).")
    print("-" * 50)

def on_message_backend(client, userdata, msg):
    print(f"\n[BACKEND] Callback on_message_backend DIPANGGIL untuk topik: '{msg.topic}'")
    payload_str = msg.payload.decode()
    print(f"[BACKEND]   Payload mentah diterima: '{payload_str}'")
    try:
        data = json.loads(payload_str)
        print(f"[BACKEND] Data diterima dari ESP '{data.get('sensor_id')}': Suhu = {data.get('suhu')}°C")
        # Di sini Anda bisa menambahkan logika, misal simpan ke DB, dll.
    except json.JSONDecodeError:
        print("[BACKEND-ERROR] Gagal mem-parse JSON dari data ESP.")
    except Exception as e:
        print(f"[BACKEND-ERROR] Terjadi error saat memproses pesan dari ESP: {e}")

def on_publish_backend(client, userdata, mid, properties=None, reasoncode=None):
    print(f"[BACKEND] Perintah (mid: {mid}) berhasil dikirim ke broker.")

# Inisialisasi MQTT Client
backend_client = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2, client_id="client_backend_sederhana")

# Tetapkan callback
backend_client.on_connect = on_connect_backend
backend_client.on_message = on_message_backend
backend_client.on_publish = on_publish_backend

print(f"[BACKEND] Mencoba terhubung ke broker LOKAL: {MQTT_BROKER_HOST}:{MQTT_BROKER_PORT}...")
try:
    backend_client.connect(MQTT_BROKER_HOST, MQTT_BROKER_PORT, MQTT_KEEP_ALIVE_INTERVAL)
except Exception as e:
    print(f"[BACKEND-ERROR] GAGAL KONEKSI AWAL: {e}. Pastikan broker MQTT lokal berjalan.")
    exit()

backend_client.loop_start()

print("[BACKEND-INFO] Network loop MQTT dimulai. Menunggu callback koneksi...")

# Fungsi sederhana untuk mengirim perintah ke ESP
def kirim_perintah_ke_esp(client, action, value):
    command_payload = {
        "action": action,
        "value": value,
        "timestamp": time.time()
    }
    json_payload = json.dumps(command_payload)
    print(f"\n[BACKEND] Mengirim perintah ke '{TOPIC_COMMAND_PUBLISH}': Aksi='{action}', Value='{value}'")
    client.publish(TOPIC_COMMAND_PUBLISH, json_payload, qos=1)

try:
    # Tunggu koneksi stabil dulu
    time.sleep(2) # Beri waktu 2 detik untuk koneksi dan subscribe awal

    # Kirim beberapa perintah awal secara otomatis untuk demonstrasi
    if backend_client.is_connected(): # Pastikan terhubung sebelum mengirim
        kirim_perintah_ke_esp(backend_client, "set_led", "ON")
        time.sleep(5)
        kirim_perintah_ke_esp(backend_client, "print_message", "Halo dari Backend!")
        time.sleep(5)
        kirim_perintah_ke_esp(backend_client, "set_led", "OFF")
    else:
        print("[BACKEND-PERINGATAN] Tidak terhubung ke broker, perintah awal tidak dikirim.")

    print("\n[BACKEND] Backend berjalan. Menerima data dari ESP dan telah mengirim perintah awal.")
    print("[BACKEND] Tekan Ctrl+C untuk berhenti.")
    while True:
        # Loop utama backend bisa melakukan tugas lain atau hanya menunggu
        time.sleep(1)
        # Anda bisa menambahkan input keyboard di sini untuk mengirim perintah manual jika mau
        # contoh:
        # cmd = input("Ketik perintah (misal: led_on, led_off, msg_halo): ")
        # if cmd == "led_on":
        #     kirim_perintah_ke_esp(backend_client, "set_led", "ON_MANUAL")
        # elif ... dst.

except KeyboardInterrupt:
    print("\n[BACKEND] Simulasi Backend dihentikan.")
except Exception as e:
    print(f"[BACKEND-ERROR] Error pada loop utama: {e}")
finally:
    print("[BACKEND-INFO] Menghentikan koneksi MQTT...")
    backend_client.loop_stop()
    if backend_client.is_connected():
        backend_client.disconnect()
    print("[BACKEND-INFO] Selesai.")