# Alpine Linux Docker Container with Arduino USB Serial Control

Control an Arduino Uno's onboard LED over USB serial from inside an Alpine Linux Docker container, triggered by netcat commands from your host.

**Architecture:**
```
nc localhost 9000  →  Docker (Alpine + Python)  →  USB serial  →  Arduino Uno
```

**Command format:** `blink <count> <period_ms>`
Example: `blink 5 500` blinks the LED 5 times with a 500 ms period.

---

## Prerequisites

- Docker installed on your host machine
- Arduino IDE installed on your host machine (for uploading the sketch)
- Arduino Uno connected via USB
- Your USB device path — check with:

```bash
ls /dev/tty* | grep -E "ACM|USB"
# Typically /dev/ttyACM0 (Uno) or /dev/ttyUSB0 (clone)
```

---

## Step 1 — Write and upload the Arduino sketch

Upload this sketch to your Uno **before** building the Docker container. It reads newline-terminated strings from serial and parses the `blink` command.

```cpp
// blink_serial.ino
// Accepts: "blink <count> <period_ms>\n"

void setup() {
  Serial.begin(9600);
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  if (Serial.available() > 0) {
    String line = Serial.readStringUntil('\n');
    line.trim();

    if (line.startsWith("blink")) {
      int firstSpace  = line.indexOf(' ');
      int secondSpace = line.indexOf(' ', firstSpace + 1);

      int count  = line.substring(firstSpace + 1, secondSpace).toInt();
      int period = line.substring(secondSpace + 1).toInt();
      int half   = period / 2;

      for (int i = 0; i < count; i++) {
        digitalWrite(LED_BUILTIN, HIGH);
        delay(half);
        digitalWrite(LED_BUILTIN, LOW);
        delay(half);
      }
      Serial.println("done");
    }
  }
}
```

Upload via the Arduino IDE, then **close the IDE** (it holds the serial port open, which will block the container).

---

## Step 2 — Project structure

Create a directory with these three files:

```
arduino-docker/
├── Dockerfile
├── server.py
└── requirements.txt
```

---

## Step 3 — Write the Python server (`server.py`)

This script opens the serial port and listens for TCP connections on port 9000. Whatever is sent via netcat gets forwarded to the Arduino.

```python
#!/usr/bin/env python3
# server.py — TCP bridge to Arduino serial

import socket
import serial
import sys
import time

SERIAL_PORT = "/dev/ttyACM0"   # adjust if yours is /dev/ttyUSB0
BAUD_RATE   = 9600
TCP_HOST    = "0.0.0.0"
TCP_PORT    = 9000


def main():
    print(f"Opening serial port {SERIAL_PORT} at {BAUD_RATE} baud...", flush=True)
    try:
        ser = serial.Serial(SERIAL_PORT, BAUD_RATE, timeout=5)
    except serial.SerialException as e:
        print(f"Could not open serial port: {e}")
        sys.exit(1)

    # Arduino resets when serial opens; give it time to boot
    time.sleep(2)
    print("Serial ready.", flush=True)

    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as srv:
        srv.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        srv.bind((TCP_HOST, TCP_PORT))
        srv.listen(1)
        print(f"Listening on TCP {TCP_HOST}:{TCP_PORT}", flush=True)

        while True:
            conn, addr = srv.accept()
            print(f"Connection from {addr}", flush=True)
            with conn:
                data = conn.recv(1024)
                if not data:
                    continue

                command = data.decode("utf-8").strip()
                print(f"Received: {command!r}", flush=True)

                # Basic validation
                parts = command.split()
                if len(parts) == 3 and parts[0] == "blink":
                    try:
                        count  = int(parts[1])
                        period = int(parts[2])
                        if count < 1 or period < 50:
                            conn.sendall(b"error: count>=1 and period>=50\n")
                            continue
                    except ValueError:
                        conn.sendall(b"error: count and period must be integers\n")
                        continue
                else:
                    conn.sendall(b"error: usage: blink <count> <period_ms>\n")
                    continue

                # Forward to Arduino
                serial_msg = f"{command}\n".encode("utf-8")
                ser.write(serial_msg)
                ser.flush()

                # Wait for Arduino acknowledgement
                response = ser.readline().decode("utf-8").strip()
                print(f"Arduino: {response}", flush=True)
                conn.sendall(f"{response}\n".encode("utf-8"))


if __name__ == "__main__":
    main()
```

---

## Step 4 — Write `requirements.txt`

```
pyserial==3.5
```

---

## Step 5 — Write the `Dockerfile`

Alpine Linux is used as the base for a minimal image. The `dialout` group membership is required so the non-root user can access the serial device.

```dockerfile
FROM alpine:3.19

# Install Python 3 and pip
RUN apk add --no-cache python3 py3-pip

# Install pyserial into the system Python
# --break-system-packages is needed on Alpine's managed Python env
RUN pip3 install --break-system-packages pyserial==3.5

WORKDIR /app
COPY server.py .

# Expose the TCP port netcat will connect to
EXPOSE 9000

CMD ["python3", "server.py"]
```

> **Note:** We don't create a non-root user here because serial device access inside the container depends on group membership that gets resolved at runtime via the `--device` flag. For production use, add a `dialout` group matching the host GID.

---

## Step 6 — Build the image

From inside the `arduino-docker/` directory:

```bash
docker build -t arduino-blinker .
```

---

## Step 7 — Run the container

Pass the USB device through with `--device`. Replace `/dev/ttyACM0` with your actual device path.

```bash
docker run --rm -it \
  --device /dev/ttyACM0:/dev/ttyACM0 \
  -p 9000:9000 \
  arduino-blinker
```

You should see:
```
Opening serial port /dev/ttyACM0 at 9600 baud...
Serial ready.
Listening on TCP 0.0.0.0:9000
```

---

## Step 8 — Send commands with netcat

In a separate terminal on your host:

```bash
echo "blink 5 500" | nc localhost 9000
```

The Arduino's onboard LED will blink 5 times at 500 ms per cycle, and you'll get back:
```
done
```

More examples:

```bash
# Blink 3 times, 200 ms per blink (fast)
echo "blink 3 200" | nc localhost 9000

# Blink 10 times, 1000 ms per blink (slow, 1 second per cycle)
echo "blink 10 1000" | nc localhost 9000
```

---

## Troubleshooting

**Permission denied on `/dev/ttyACM0`**
The host user running Docker may not be in the `dialout` group:
```bash
sudo usermod -aG dialout $USER
# Log out and back in for it to take effect
```

**`/dev/ttyACM0` not found inside the container**
Double-check the device path on your host first:
```bash
ls -la /dev/tty* | grep -E "ACM|USB"
```
Then update both the `--device` flag and `SERIAL_PORT` in `server.py`.

**Arduino resets every time a serial connection opens**
This is normal — the Uno's DTR line triggers a reset. The `time.sleep(2)` in `server.py` accounts for this. If your board takes longer, increase that value.

**IDE holds the port**
Close the Arduino IDE (including the Serial Monitor) before running the container. Any process holding the port will prevent the container from opening it.

**Using a clone Uno (CH340 chip)**
The device will likely appear as `/dev/ttyUSB0` instead of `/dev/ttyACM0`. Update the `--device` flag and `SERIAL_PORT` accordingly.

---

## Summary of files

| File | Purpose |
|---|---|
| `blink_serial.ino` | Arduino sketch — parses serial commands and blinks LED |
| `server.py` | Python TCP server — bridges netcat to Arduino serial |
| `requirements.txt` | Python dependencies (pyserial) |
| `Dockerfile` | Alpine Linux image definition |