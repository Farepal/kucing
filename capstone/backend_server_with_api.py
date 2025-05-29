import paho.mqtt.client as mqtt
import time
import json
import threading
from flask import Flask, request, jsonify
import random

# --- Konfigurasi MQTT Online ---
MQTT_BROKER_HOST = "broker.hivemq.com" # Ganti ke broker online (HARUS SAMA dengan ESP01)
MQTT_BROKER_PORT = 1883
MQTT_KEEP_ALIVE_INTERVAL = 60

# --- Prefix Topik Unik ---
TOPIC_PREFIX = "repal_kucing_capstone/" # GANTI DENGAN PREFIX UNIK ANDA (HARUS SAMA dengan ESP01)

# Topik MQTT yang akan didengarkan oleh Backend
TOPIC_DATA_SUBSCRIBE = f"{TOPIC_PREFIX}iot/+/data" # Mendengarkan data dari semua perangkat dengan prefix ini
TOPIC_COMMAND_RESPONSE_SUBSCRIBE = f"{TOPIC_PREFIX}iot/+/command_response"

# --- Konfigurasi Flask API ---
FLASK_HOST = "0.0.0.0"
FLASK_PORT = 5000

# --- Inisialisasi MQTT Client untuk Backend ---
backend_mqtt_client_id = f"backend_server_api_{random.randint(1000,9999)}"
backend_mqtt_client = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2, client_id=backend_mqtt_client_id)

# --- Callback MQTT untuk Backend ---
def on_connect_backend(client, userdata, flags, rc, properties=None):
    if rc == 0:
        print(f"[BACKEND-MQTT] Terhubung ke Broker MQTT Online: {MQTT_BROKER_HOST}")
        client.subscribe(TOPIC_DATA_SUBSCRIBE, qos=1)
        print(f"[BACKEND-MQTT] Subscribe ke topik data: {TOPIC_DATA_SUBSCRIBE}")
        client.subscribe(TOPIC_COMMAND_RESPONSE_SUBSCRIBE, qos=1)
        print(f"[BACKEND-MQTT] Subscribe ke topik command response: {TOPIC_COMMAND_RESPONSE_SUBSCRIBE}")
    else:
        print(f"[BACKEND-MQTT] Gagal terhubung ke {MQTT_BROKER_HOST}, kode: {rc}")

def on_message_backend(client, userdata, msg):
    topic = msg.topic
    payload_str = msg.payload.decode()
    print(f"\n[BACKEND-MQTT] Pesan diterima pada topik '{topic}': {payload_str}")
    try:
        data = json.loads(payload_str)
        # Ekstrak device_id dari topik jika menggunakan wildcard dan prefix
        topic_parts = topic.split('/')
        device_id_from_topic = "unknown_device"
        if len(topic_parts) > 2 and topic_parts[0] == TOPIC_PREFIX.strip('/'): # Periksa prefix utama
             if len(topic_parts) > 3 and topic_parts[1] == "iot":
                 device_id_from_topic = topic_parts[2]


        if "command_response" in topic:
            print(f"[BACKEND-MQTT] Respons Perintah dari Perangkat '{device_id_from_topic}': {data}")
        elif "data" in topic:
            print(f"[BACKEND-MQTT] Data Sensor dari '{device_id_from_topic}': {data}")
        else:
            print(f"[BACKEND-MQTT] Pesan diterima di topik tidak dikenal dalam prefix yang benar: {topic}")

    except json.JSONDecodeError:
        print(f"[BACKEND-MQTT] Gagal mem-parse JSON dari topik {topic}.")
    except Exception as e:
        print(f"[BACKEND-MQTT] Error memproses pesan dari {topic}: {e}")

def on_publish_backend(client, userdata, mid, properties=None, reasoncode=None):
    print(f"[BACKEND-MQTT] Perintah/Pesan (mid: {mid}) berhasil dipublikasikan ke broker online.")

backend_mqtt_client.on_connect = on_connect_backend
backend_mqtt_client.on_message = on_message_backend
backend_mqtt_client.on_publish = on_publish_backend

try:
    print(f"[BACKEND-MQTT] Mencoba terhubung ke broker online {MQTT_BROKER_HOST}...")
    backend_mqtt_client.connect(MQTT_BROKER_HOST, MQTT_BROKER_PORT, MQTT_KEEP_ALIVE_INTERVAL)
    backend_mqtt_client.loop_start()
except OSError as e:
    print(f"[BACKEND-MQTT] KRITIKAL: Tidak dapat terhubung ke MQTT Broker Online. Masalah jaringan/DNS. {e}")
    exit()
except Exception as e:
    print(f"[BACKEND-MQTT] KRITIKAL: Tidak dapat terhubung ke MQTT Broker Online. {e}")
    exit()

# --- Inisialisasi Flask App ---
app = Flask(__name__)

@app.route('/')
def home():
    return jsonify({"message": "Backend API untuk Kontrol ESP (via Online MQTT) berjalan!",
                    "mqtt_broker": MQTT_BROKER_HOST,
                    "topic_prefix": TOPIC_PREFIX,
                    "endpoints": {"send_command": "/api/esp/command (POST)"}})

@app.route('/api/esp/command', methods=['POST'])
def control_esp_device():
    try:
        client_request_data = request.get_json()
        if not client_request_data:
            return jsonify({"status": "error", "message": "Request body harus JSON"}), 400

        target_device_id = client_request_data.get("target_device_id")
        action = client_request_data.get("action")
        payload = client_request_data.get("payload", {})

        if not target_device_id or not action:
            return jsonify({"status": "error", "message": "Parameter 'target_device_id' dan 'action' dibutuhkan"}), 400

        command_id = f"cmd_{target_device_id}_{int(time.time())}"
        mqtt_command_payload = {
            "command_id": command_id, "action": action,
            "payload": payload, "timestamp": time.time()
        }
        
        command_topic = f"{TOPIC_PREFIX}iot/{target_device_id}/command"
        
        print(f"[BACKEND-API] Menerima permintaan: Aksi '{action}' untuk perangkat '{target_device_id}'")
        print(f"[BACKEND-API] Mempublikasikan ke MQTT topik '{command_topic}': {mqtt_command_payload}")

        result = backend_mqtt_client.publish(command_topic, json.dumps(mqtt_command_payload), qos=1)
        
        if result.rc == mqtt.MQTT_ERR_SUCCESS:
            print(f"[BACKEND-API] Perintah berhasil dikirim ke antrian broker online untuk {target_device_id}.")
            return jsonify({
                "status": "success", "message": f"Perintah '{action}' dikirim ke perangkat '{target_device_id}'.",
                "command_id": command_id, "mqtt_topic": command_topic
            }), 200
        else:
            print(f"[BACKEND-API] Gagal mengirim perintah ke antrian broker online (Error code: {result.rc}).")
            return jsonify({
                "status": "error", "message": "Gagal mengirim perintah ke broker MQTT online.",
                "mqtt_error_code": result.rc
            }), 500

    except Exception as e:
        print(f"[BACKEND-API] Error pada endpoint /api/esp/command: {e}")
        return jsonify({"status": "error", "message": f"Internal server error: {e}"}), 500

def run_flask_app():
    print(f"[BACKEND-API] Menjalankan Flask API di http://{FLASK_HOST}:{FLASK_PORT}")
    app.run(host=FLASK_HOST, port=FLASK_PORT, debug=False, use_reloader=False)

if __name__ == '__main__':
    flask_thread = threading.Thread(target=run_flask_app)
    flask_thread.daemon = True
    flask_thread.start()

    print(f"[BACKEND] Backend server (MQTT Listener via {MQTT_BROKER_HOST} & API) berjalan.")
    print("[BACKEND] Tekan Ctrl+C untuk berhenti.")
    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        print("\n[BACKEND] Backend server dihentikan.")
    finally:
        print(f"[BACKEND] Menghentikan koneksi ke {MQTT_BROKER_HOST}...")
        backend_mqtt_client.loop_stop()
        backend_mqtt_client.disconnect()
        print("[BACKEND] Selesai.")