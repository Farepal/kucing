import requests
import json
import time

BACKEND_API_URL = "http://localhost:5000/api/esp/command" # Sesuaikan jika FLASK_HOST atau FLASK_PORT berbeda

def send_command_to_esp(target_device, action_name, action_payload=None):
    if action_payload is None:
        action_payload = {}

    request_body = {
        "target_device_id": target_device,
        "action": action_name,
        "payload": action_payload
    }

    headers = {
        "Content-Type": "application/json"
    }

    print(f"\n[KLIEN] Mengirim permintaan ke Backend API: {BACKEND_API_URL}")
    print(f"[KLIEN]   Target: {target_device}, Aksi: {action_name}, Payload Aksi: {action_payload}")

    try:
        response = requests.post(BACKEND_API_URL, headers=headers, data=json.dumps(request_body), timeout=10)
        response.raise_for_status() # Akan raise error jika status HTTP 4xx atau 5xx

        print(f"[KLIEN] Respons dari Backend API (Status: {response.status_code}):")
        try:
            print(json.dumps(response.json(), indent=2))
        except json.JSONDecodeError:
            print(response.text) # Jika respons bukan JSON

    except requests.exceptions.HTTPError as errh:
        print(f"[KLIEN] Http Error: {errh}")
        print(f"          Detail: {errh.response.text}")
    except requests.exceptions.ConnectionError as errc:
        print(f"[KLIEN] Error Koneksi: {errc} (Pastikan backend server dengan API sudah berjalan)")
    except requests.exceptions.Timeout as errt:
        print(f"[KLIEN] Timeout Error: {errt}")
    except requests.exceptions.RequestException as err:
        print(f"[KLIEN] Oops: Terjadi kesalahan: {err}")

if __name__ == "__main__":
    # Contoh penggunaan
    esp_target_id = "esp01_sim_001" # Pastikan ID ini sama dengan yang di ESP & Backend

    # 1. Perintah untuk menyalakan LED
    send_command_to_esp(
        target_device=esp_target_id,
        action_name="set_led",
        action_payload={"led_id": "main_indicator", "status": "on"}
    )
    time.sleep(2) # Jeda antar perintah
