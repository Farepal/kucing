import paho.mqtt.client as mqtt
import time
import json
import random

# --- Konfigurasi MQTT Broker (LOKAL) ---
MQTT_BROKER_HOST = "broker.hivemq.com"
MQTT_BROKER_PORT = 1883
MQTT_KEEP_ALIVE_INTERVAL = 60

# --- Topik Sederhana ---
# Anda bisa menambahkan prefix unik jika mau, tapi untuk lokal tidak wajib
DEVICE_ID = "esp_virtual_01"
TOPIC_DATA_PUBLISH = f"simulasi/{DEVICE_ID}/data"
TOPIC_COMMAND_SUBSCRIBE = f"simulasi/{DEVICE_ID}/command"

program_start_time = time.time()

def on_connect(client, userdata, flags, rc, properties=None):
    print("-" * 50)
    print("[ESP] Callback on_connect dipanggil.")
    print(f"[ESP]   Flags: {flags}")
    print(f"[ESP]   Kode hasil koneksi (rc): {rc} --- (0 = Sukses)")

    if rc == 0:
        print(f"[ESP] Berhasil terhubung ke Broker MQTT: {MQTT_BROKER_HOST}")
        
        print(f"[ESP]   Mencoba subscribe ke topik perintah: '{TOPIC_COMMAND_SUBSCRIBE}'")
        result, mid = client.subscribe(TOPIC_COMMAND_SUBSCRIBE, qos=1) # qos=1 agar lebih andal
        
        if result == mqtt.MQTT_ERR_SUCCESS:
            print(f"[ESP]   Subscribe ke '{TOPIC_COMMAND_SUBSCRIBE}' BERHASIL (mid: {mid})")
        else:
            print(f"[ESP-PERINGATAN] Subscribe ke '{TOPIC_COMMAND_SUBSCRIBE}' GAGAL, kode error: {result}")
            print(f"[ESP-PERINGATAN]   ESP TIDAK AKAN menerima perintah pada topik ini.")
    else:
        print(f"[ESP-PERINGATAN] GAGAL terhubung ke broker (rc: {rc}). Subscribe tidak akan dilakukan.")
    print("-" * 50)

def on_message(client, userdata, msg):
    # Print debug paling atas untuk memastikan fungsi ini terpanggil
    print(f"\n[ESP] Callback on_message DIPANGGIL untuk topik: '{msg.topic}'")
    payload_str = msg.payload.decode()
    print(f"[ESP]   Payload mentah diterima: '{payload_str}'")
    
    try:
        command_data = json.loads(payload_str)
        action = command_data.get("action")
        value = command_data.get("value")

        if action == "set_led":
            print(f"[ESP] AKSI: Mengatur LED ke status '{value}'")
        elif action == "print_message":
            print(f"[ESP] AKSI: Pesan dari backend -> '{value}'")
        else:
            print(f"[ESP] AKSI: Perintah tidak dikenal '{action}' dengan nilai '{value}'")

    except json.JSONDecodeError:
        print("[ESP-ERROR] Gagal mem-parse JSON dari perintah yang diterima.")
    except Exception as e:
        print(f"[ESP-ERROR] Terjadi error saat memproses pesan: {e}")

def on_publish(client, userdata, mid, properties=None, reasoncode=None):
    # print(f"[ESP] Data (mid: {mid}) berhasil dikirim ke broker.") # Bisa di-uncomment jika perlu
    pass

def on_disconnect(client, userdata, rc, properties=None):
    print(f"[ESP-INFO] Terputus dari broker dengan kode: {rc}")

# Inisialisasi MQTT Client
esp_client = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2, client_id=f"client_esp_{DEVICE_ID}")

# Tetapkan callback
esp_client.on_connect = on_connect
esp_client.on_message = on_message
esp_client.on_publish = on_publish
esp_client.on_disconnect = on_disconnect

print(f"[ESP] Mencoba terhubung ke broker LOKAL: {MQTT_BROKER_HOST}:{MQTT_BROKER_PORT}...")
try:
    esp_client.connect(MQTT_BROKER_HOST, MQTT_BROKER_PORT, MQTT_KEEP_ALIVE_INTERVAL)
except Exception as e:
    print(f"[ESP-ERROR] GAGAL KONEKSI AWAL: {e}. Pastikan broker MQTT lokal berjalan.")
    exit()

esp_client.loop_start() # Memulai thread untuk network loop

print("[ESP-INFO] Network loop MQTT dimulai. Menunggu callback koneksi...")

try:
    count = 0
    while True:
        count += 1
        temperature = round(random.uniform(20.0, 30.0), 2)
        
        data_payload = {
            "sensor_id": DEVICE_ID,
            "bacaan_ke": count,
            "suhu": temperature,
            "timestamp": time.time()
        }
        json_payload = json.dumps(data_payload)
        
        result = esp_client.publish(TOPIC_DATA_PUBLISH, json_payload, qos=1)
        
        if result.rc == mqtt.MQTT_ERR_SUCCESS:
            print(f"[ESP] Mengirim data: Suhu = {temperature}°C ke topik '{TOPIC_DATA_PUBLISH}'")
        else:
            print(f"[ESP-PERINGATAN] Gagal mengirim data, kode: {result.rc}")
            
        time.sleep(10) # Kirim data setiap 10 detik
except KeyboardInterrupt:
    print("\n[ESP] Simulasi ESP dihentikan.")
except Exception as e:
    print(f"[ESP-ERROR] Error pada loop utama: {e}")
finally:
    print("[ESP-INFO] Menghentikan koneksi MQTT...")
    esp_client.loop_stop()
    if esp_client.is_connected():
        esp_client.disconnect()
    print("[ESP-INFO] Selesai.")