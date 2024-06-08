#include <Adafruit_GFX.h>
#include <Adafruit_ILI9341.h>
#include <NewPing.h>

#define TFT_CS    5
#define TFT_RST   4
#define TFT_DC    2
#define TFT_MOSI  23
#define TFT_CLK   18
#define TFT_MISO  19
#define TFT_LED   32
#define TFT_BL    33

#define TRIG_PIN 33
#define ECHO_PIN 32
#define MAX_DISTANCE 400

NewPing sonar(TRIG_PIN, ECHO_PIN, MAX_DISTANCE);
Adafruit_ILI9341 tft = Adafruit_ILI9341(TFT_CS, TFT_DC, TFT_RST);

// Game constants
const int birdWidth = 10;
const int birdHeight = 10;
const int gravity = 1;
const int jumpStrength = -6; // Lower jump strength
const int pipeWidth = 20;
const int pipeGap = 80; // Increase the gap between the pipes
int pipeSpeed = 2; // Initial pipe speed

int birdY;
int birdVelocity;
int pipeX;
int pipeHeight;
int score = 0;

bool birdInAir = false;
bool passedPipe = false;

void setup() {
  Serial.begin(115200);
  tft.begin();
  tft.setRotation(1);
  tft.fillScreen(ILI9341_BLACK);
  tft.setTextSize(2);
  tft.setTextColor(ILI9341_WHITE);

  pinMode(TFT_BL, OUTPUT);
  digitalWrite(TFT_BL, HIGH);

  birdY = tft.height() / 2;
  birdVelocity = 0;
  pipeX = tft.width();
  pipeHeight = random(tft.height() - pipeGap);

  // Create FreeRTOS tasks
  xTaskCreate(updateGame, "Update Game", 4096, NULL, 1, NULL);
  xTaskCreate(checkSensor, "Check Sensor", 2048, NULL, 1, NULL);
}

void loop() {
  // Empty loop as tasks are handled by FreeRTOS
}

void updateGame(void *pvParameters) {
  while (true) {
    tft.fillScreen(ILI9341_BLACK);

    // Update bird position
    birdY += birdVelocity;
    birdVelocity += gravity;

    // Prevent bird from going off the screen
    if (birdY < 0) {
      birdY = 0;
      birdVelocity = 0;
    }
    if (birdY > tft.height() - birdHeight) {
      birdY = tft.height() - birdHeight;
      birdVelocity = 0;
    }

    // Draw bird
    tft.fillRect(30, birdY, birdWidth, birdHeight, ILI9341_YELLOW);

    // Update pipe position
    pipeX -= pipeSpeed;
    if (pipeX < -pipeWidth) {
      pipeX = tft.width();
      pipeHeight = random(tft.height() - pipeGap);
      passedPipe = false; // Reset flag for new pipe
    }

    // Draw pipes
    tft.fillRect(pipeX, 0, pipeWidth, pipeHeight, ILI9341_GREEN);
    tft.fillRect(pipeX, pipeHeight + pipeGap, pipeWidth, tft.height() - pipeHeight - pipeGap, ILI9341_GREEN);

    // Check for collisions
    if (30 + birdWidth > pipeX && 30 < pipeX + pipeWidth) {
      if (birdY < pipeHeight || birdY + birdHeight > pipeHeight + pipeGap) {
        tft.fillScreen(ILI9341_RED);
        tft.setCursor(tft.width() / 2 - 50, tft.height() / 2 - 10);
        tft.print("Game Over");
        tft.setCursor(tft.width() / 2 - 50, tft.height() / 2 + 10);
        tft.print("Score: ");
        tft.print(score);
        vTaskDelete(NULL);
      }
    }

    // Update score and increase pipe speed
    if (pipeX + pipeWidth < 30 && !passedPipe) {
      score++;
      pipeSpeed = 2 + score / 2; // Increase speed every 5 points
      passedPipe = true; // Mark this pipe as passed
    }

    // Display score
    tft.setCursor(10, 10); // Display score in the top-left corner
    tft.print("Score: ");
    tft.print(score);

    vTaskDelay(30 / portTICK_PERIOD_MS); // 30 ms delay
  }
}

void checkSensor(void *pvParameters) {
  while (true) {
    unsigned int distance = sonar.ping_cm();

    if (distance > 3) {
      birdInAir = false;
    }

    if (distance <= 3 && !birdInAir) {
      birdVelocity = jumpStrength;
      birdInAir = true;
    }

    Serial.print("Distance: ");
    if (distance == 0) {
      Serial.println("Out of range");
    } else {
      Serial.print(distance);
      Serial.println(" cm");
    }

    vTaskDelay(50 / portTICK_PERIOD_MS); // 50 ms delay
  }
}
