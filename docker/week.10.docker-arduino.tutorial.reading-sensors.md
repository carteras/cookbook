# Temperature & Humidity Sensor Tutorial
### Using a DHT11 with Arduino Uno R4 WiFi or Arduino Mega

---

## What You'll Need

**Option A — Direct connection (no breadboard)**
- 1 × DHT11 temperature and humidity sensor module (3-pin)
- 3 × male-to-female jumper leads (any colour, but red/blue/black helps)
- 1 × Arduino Uno R4 WiFi or Arduino Mega

**Option B — Breadboard connection**
- 1 × DHT11 temperature and humidity sensor module (3-pin)
- 3 × male-to-male jumper leads
- 1 × breadboard
- 1 × Arduino Uno R4 WiFi or Arduino Mega

---

## Step 1 — Wire Up the Sensor

Your DHT11 module has three pins labelled **SIG**, **5V**, and **GND**. Connect them as follows:

| Sensor pin | Arduino pin |
|------------|-------------|
| SIG        | Pin 9       |
| 5V         | 5V          |
| GND        | GND         |

> **Option A (male-to-female leads):** Plug the female end directly onto the sensor pins and the male end into the Arduino header pins.
>
> **Option B (breadboard):** Push the sensor into the breadboard, then use male-to-male leads to connect from the breadboard rows to the Arduino.

---

## Step 2 — Install the Arduino IDE and Select Your Board

1. Open the **Arduino IDE**.
2. Go to **Tools → Board → Arduino AVR Boards** (for the Mega) or **Arduino UNO R4 Boards** (for the R4 WiFi) and select your board:
   - Arduino Mega: choose **Arduino Mega or Mega 2560**
   - Arduino Uno R4 WiFi: choose **Arduino Uno R4 WiFi**
3. Go to **Tools → Port** and select the port your Arduino is connected to.
   - On Windows it will look like `COM3` or similar.
   - On Mac/Linux it will look like `/dev/cu.usbmodem...` or `/dev/ttyUSB0`.
   - If you're not sure which port, unplug the Arduino, check the list, then plug it back in — the new entry that appears is your board.

> **Tip:** If your board doesn't appear in the board list, you may need to install its core. Go to **Tools → Board → Boards Manager**, search for your board name, and click Install.

---

## Step 3 — Install the DHT Sensor Library

The DHT11 needs a library to work. Here's how to install it:

1. In the Arduino IDE, go to **Sketch → Include Library → Manage Libraries...**
2. In the search box, type `DHT sensor library`.
3. Find **DHT sensor library** by **Adafruit** and click **Install**.
4. When prompted, click **Install All** to also install the required **Adafruit Unified Sensor** library.

Once installed, close the Library Manager.

---

## Step 4 — Upload the Code

Copy the sketch below into the Arduino IDE, then click the **Upload** button (the right-pointing arrow).

```cpp
#include "DHT.h"

#define DHTPIN 9       // SIG wire is connected to pin 9
#define DHTTYPE DHT11  // We have a DHT11 sensor

DHT dht(DHTPIN, DHTTYPE);

void setup() {
  Serial.begin(9600);
  dht.begin();
  Serial.println("DHT11 ready — reading every 2 seconds...");
}

void loop() {
  delay(2000); // DHT11 needs at least 2 seconds between readings

  float humidity = dht.readHumidity();
  float tempC    = dht.readTemperature();      // Celsius
  float tempF    = dht.readTemperature(true);  // Fahrenheit

  // Check that readings are valid before printing
  if (isnan(humidity) || isnan(tempC)) {
    Serial.println("Error: could not read from DHT11. Check your wiring.");
    return;
  }

  Serial.print("Humidity: ");
  Serial.print(humidity);
  Serial.print(" %    Temp: ");
  Serial.print(tempC);
  Serial.print(" C  /  ");
  Serial.print(tempF);
  Serial.println(" F");
}
```

---

## Step 5 — Open the Serial Monitor

1. Once the upload is complete, go to **Tools → Serial Monitor** (or press `Ctrl+Shift+M` / `Cmd+Shift+M`).
2. In the bottom-right of the Serial Monitor, set the baud rate to **9600**.
3. You should see a new reading appear every 2 seconds, like this:

```
DHT11 ready — reading every 2 seconds...
Humidity: 52.00 %    Temp: 23.00 C  /  73.40 F
Humidity: 51.00 %    Temp: 23.00 C  /  73.40 F
```

---

## Troubleshooting

**"Error: could not read from DHT11"**
Check that your SIG wire is connected to **pin 9** on the Arduino, and that 5V and GND are firmly connected.

**No port appears under Tools → Port**
Try a different USB cable — many cables are charge-only and don't carry data. Also make sure the Arduino is powered (the onboard LED should be on).

**Board not found in the board list**
Open **Tools → Board → Boards Manager**, search for your board, and install the correct core package.

**Readings seem wrong**
The DHT11 is accurate to ±2°C and ±5% humidity. Give it a minute after powering on to stabilise. Avoid placing it near heat sources or in direct sunlight.