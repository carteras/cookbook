# Alpine Linux Docker Container with Arduino USB Serial Control

Control an Arduino Uno's onboard LED over USB serial from inside an Alpine Linux Docker container, triggered by netcat commands from your host.

The Docker container handles everything — it compiles the Arduino sketch, uploads it to the Uno, and then starts the TCP bridge server. No Arduino IDE required on the host.

**Architecture:**
```
docker run  →  arduino-cli compile + upload  →  Arduino Uno (flashed)
                                                        ↑
nc localhost 9000  →  Docker (Alpine + Python)  →  USB serial
```

**Command format:** `blink <count> <period_ms>`
Example: `blink 5 500` blinks the LED 5 times with a 500 ms period.

---

## Prerequisites

- Docker installed on your host machine
- Arduino Uno connected via USB
- Your USB device path — check with:

```bash
ls /dev/tty* | grep -E "ACM|USB"
# Typically /dev/ttyACM0 (genuine Uno) or /dev/ttyUSB0 (clone with CH340 chip)
```

That's it. No Arduino IDE needed.

---

## Project structure

Create this directory layout:

```
arduino-docker/
├── Dockerfile
├── server.py
├── requirements.txt
└── sketch/
    └── blink_serial/
        └── blink_serial.ino
```

> `arduino-cli` requires the `.ino` file to live inside a folder of the same name. This mirrors the Arduino IDE convention and is not optional.

---

## Step 1 — Write the Arduino sketch

```cpp
// sketch/blink_serial/blink_serial.ino
// Accepts: "blink <count> <period_ms>\n" over serial

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

---

## Step 2 — Write the Python server (`server.py`)

This script waits for TCP connections on port 9000, validates the command, forwards it to the Arduino over serial, and returns the acknowledgement.

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

## Step 3 — Write `requirements.txt`

```
pyserial==3.5
```

---

## Step 4 — Write the `Dockerfile`

### `Dockerfile.r4 wifi`

This is where the magic happens. The image installs `arduino-cli`, downloads the AVR toolchain at build time, and on startup compiles + uploads the sketch before launching the Python server.

```dockerfile
FROM alpine:3.19

# System dependencies
RUN apk add --no-cache \
    python3 \
    py3-pip \
    curl \
    bash \
    git

# Install pyserial
RUN pip3 install --break-system-packages pyserial==3.5

# Install arduino-cli into /usr/local/bin
RUN curl -fsSL https://raw.githubusercontent.com/arduino/arduino-cli/master/install.sh \
    | BINDIR=/usr/local/bin sh

# Initialise the arduino-cli config file
RUN arduino-cli config init

# Download the AVR platform (avr-gcc, avrdude, core libraries)
RUN arduino-cli core update-index && \
    arduino-cli core install arduino:avr

WORKDIR /app
COPY requirements.txt .
COPY server.py .
COPY sketch/ ./sketch/

# Compile at build time so students don't need to compile at runtime
RUN arduino-cli compile --fqbn arduino:avr:uno /app/sketch/blink_serial

EXPOSE 9000

# On container start: just upload the pre-built binary and start the server
CMD ["bash", "-c", \
    "arduino-cli upload --fqbn arduino:avr:uno --port /dev/ttyACM0 /app/sketch/blink_serial && \
     python3 server.py"]
```


### `Dockerfile.mega` 

```Dockerfile

FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 \
    python3-pip \
    curl \
    bash \
    git \
    && rm -rf /var/lib/apt/lists/*

RUN pip3 install --break-system-packages pyserial==3.5

RUN curl -fsSL https://raw.githubusercontent.com/arduino/arduino-cli/master/install.sh \
    | BINDIR=/usr/local/bin sh

RUN arduino-cli config init

RUN arduino-cli core update-index && \
    arduino-cli core install arduino:avr

WORKDIR /app
COPY requirements.txt .
COPY server.py .
COPY sketch/ ./sketch/

RUN arduino-cli compile --fqbn arduino:avr:mega /app/sketch/blink_serial

EXPOSE 9000

CMD ["bash", "-c", \
    "arduino-cli upload --fqbn arduino:avr:mega --port /dev/ttyACM0 /app/sketch/blink_serial && \
     python3 server.py"]

```

### Why `--fqbn arduino:avr:uno`?

FQBN stands for Fully Qualified Board Name. It tells `arduino-cli` exactly which board to compile for and which bootloader protocol to use when uploading. For other boards:

| Board | FQBN |
|---|---|
| Uno | `arduino:avr:uno` |
| Uno r4 wifi | `--fqbn arduino:renesas_uno:unor4wifi` |
| Nano (old bootloader) | `arduino:avr:nano:cpu=atmega328old` |
| Mega 2560 | `arduino:avr:mega` |
| Leonardo | `arduino:avr:leonardo` |

---

## Step 5 — Build the image

```bash
docker build -t arduino-blinker .
```

The first build will take a few minutes while it downloads the AVR toolchain (~150 MB). Subsequent builds are fast thanks to Docker layer caching — the toolchain layer only rebuilds if you change a line above the `COPY` instructions.

---

## Step 6 — Run the container

Pass the USB device through with `--device`. Replace `/dev/ttyACM0` with your actual device path.

```bash
docker run --rm -it \
  --device /dev/ttyACM0:/dev/ttyACM0 \
  -p 9000:9000 \
  arduino-blinker
```

On startup you will see the sketch compile, avrdude upload it, and then the server start:

```
Sketch uses 1234 bytes (3%) of program storage space.
Global variables use 56 bytes (2%) of dynamic memory.
avrdude: AVR device initialized and ready to accept instructions
...
avrdude done.  Thank you.

Opening serial port /dev/ttyACM0 at 9600 baud...
Serial ready.
Listening on TCP 0.0.0.0:9000
```

---

## Step 7 — Send commands with netcat

In a separate terminal on your host:

```bash
echo "blink 5 500" | nc localhost 9000
```

The onboard LED blinks 5 times at 500 ms per cycle and you'll get back:
```
done
```

More examples:

```bash
# Blink 3 times, 200 ms per blink (fast)
echo "blink 3 200" | nc localhost 9000

# Blink 10 times, 1000 ms per blink (slow)
echo "blink 10 1000" | nc localhost 9000
```

---

## Troubleshooting

**Permission denied on `/dev/ttyACM0`**
The host user running Docker may not be in the `dialout` group:
```bash
sudo usermod -aG dialout $USER
# Log out and back in for the change to take effect
```

**`/dev/ttyACM0` not found**
Double-check the device path on your host:
```bash
ls -la /dev/tty* | grep -E "ACM|USB"
```
Update both the `--device` flag and `SERIAL_PORT` in `server.py` to match.

**avrdude: stk500_recv(): programmer is not responding**
Something else is holding the serial port. Check with:
```bash
lsof /dev/ttyACM0
```
Kill any process listed, then retry.

**Using a clone Uno (CH340 chip)**
The device will appear as `/dev/ttyUSB0`. Update the `--device` flag and `SERIAL_PORT` in `server.py` accordingly. The FQBN stays the same (`arduino:avr:uno`).

**Sketch uploaded but LED does nothing**
The Arduino resets when `server.py` opens the serial port (DTR toggle). The `time.sleep(2)` handles this. If your board takes longer to boot, increase that value to 3 or 4 seconds.

**Building on ARM (Apple Silicon, Raspberry Pi)**
The `arduino-cli` install script detects the architecture automatically. If it fails, manually pull the ARM binary:
```dockerfile
RUN curl -fsSL https://downloads.arduino.cc/arduino-cli/arduino-cli_latest_Linux_ARM64.tar.gz \
    | tar -xz -C /usr/local/bin
```

---

## Summary of files

| File | Purpose |
|---|---|
| `sketch/blink_serial/blink_serial.ino` | Arduino sketch — parses serial commands and blinks the LED |
| `server.py` | Python TCP server — bridges netcat to Arduino serial |
| `requirements.txt` | Python dependencies (`pyserial`) |
| `Dockerfile` | Alpine image — installs arduino-cli, compiles + uploads sketch on startup, then runs server |