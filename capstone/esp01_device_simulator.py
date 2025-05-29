# esp_simulator.py
import paho.mqtt.client as mqtt, time, json, random

BROKER = "broker.hivemq.com"
PREFIX = "repal_kucing_capstone/"
DEVICE = "esp01_sim_001"
TOPIC_CMD = f"{PREFIX}iot/{DEVICE}/command"
TOPIC_RESP = f"{PREFIX}iot/{DEVICE}/command_response"
TOPIC_DATA = f"{PREFIX}iot/{DEVICE}/data"

client = mqtt.Client(client_id=f"esp_{random.randint(1000,9999)}")

client.on_connect = lambda c,u,f,rc,p=None: (print("[ESP] Connected"), c.subscribe(TOPIC_CMD)) if rc==0 else print("[ESP] Connect fail", rc)

def on_msg(c,u,msg):
    print(f"[ESP] Command: {msg.payload.decode()}")
    try:
        d = json.loads(msg.payload)
        res = {"command_id": d.get("command_id"), "device_id": DEVICE, "status": "error", "message": "Unknown action"}
        if d.get("action") == "set_led":
            res.update({"status": "success", "action_performed": "set_led", "led_id": d["payload"].get("led_id", "general"),
                        "new_status": d["payload"].get("status", "off"), "message": "LED updated"})
        c.publish(TOPIC_RESP, json.dumps(res), qos=1)
    except Exception as e: print("[ESP] Error handling command:", e)

client.on_message = on_msg
client.connect(BROKER, 1883, 60)
client.loop_start()

try:
    i = 0
    while True:
        i += 1
        data = {"reading_id": i, "timestamp": time.time(), "device_id": DEVICE,
                "temperature_celsius": round(random.uniform(18,28),2),
                "humidity_percent": round(random.uniform(50,75),2)}
        client.publish(TOPIC_DATA, json.dumps(data), qos=1)
        print("[ESP] Data sent")
        time.sleep(15)
except KeyboardInterrupt:
    print("[ESP] Stopped")
finally:
    client.loop_stop()
    client.disconnect()
