// backend.js
const express = require("express"), mqtt = require("mqtt"), bodyParser = require("body-parser"), app = express();
const PORT = 5000, BROKER = "mqtt://broker.hivemq.com", PREFIX = "repal_kucing_capstone/";
const TOPIC_DATA = `${PREFIX}iot/+/data`, TOPIC_RESP = `${PREFIX}iot/+/command_response`;
const mqttClient = mqtt.connect(BROKER, { clientId: `backend_${Math.random()}`, keepalive: 60 });

app.use(bodyParser.json());

mqttClient.on("connect", () => {
  console.log(`[MQTT] Connected to ${BROKER}`);
  [TOPIC_DATA, TOPIC_RESP].forEach(t => mqttClient.subscribe(t, { qos: 1 }, () => console.log(`[MQTT] Subscribed: ${t}`)));
});

mqttClient.on("message", (topic, msg) => {
  const payload = msg.toString();
  try {
    const data = JSON.parse(payload), parts = topic.split("/");
    const device = parts[2] || "unknown";
    console.log(`[MQTT] ${topic.includes("command_response") ? "Response" : "Data"} from '${device}':`, data);
  } catch (e) { console.error("[MQTT] JSON parse error:", e.message); }
});

app.get("/", (_, res) => res.json({ status: "ok", mqtt: BROKER, topic_prefix: PREFIX, send_command: "/api/esp/command (POST)" }));

app.post("/api/esp/command", (req, res) => {
  const { target_device_id, action, payload = {} } = req.body;
  if (!target_device_id || !action) 
    return res.status(400).json({ status: "error", message: "Missing 'target_device_id' or 'action'" });
  const command_id = `cmd_${target_device_id}_${Date.now()}`;
  const cmdTopic = `${PREFIX}iot/${target_device_id}/command`;
  const cmd = { command_id, action, payload, timestamp: Date.now() / 1000 };
  mqttClient.publish(cmdTopic, JSON.stringify(cmd), { qos: 1 }, err => {
    if (err) return res.status(500).json({ status: "error", message: "MQTT publish failed", error: err.message });
    res.json({ status: "success", message: `Command '${action}' sent`, command_id, mqtt_topic: cmdTopic });
  });
});

app.listen(PORT, () => console.log(`[API] Running on http://localhost:${PORT}`));