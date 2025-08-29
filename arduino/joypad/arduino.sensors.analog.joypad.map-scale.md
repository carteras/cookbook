# problem: How can I scale the joystick reading (0–1023) to a friendly 0–100% range using `map()`?

`arduino.sensors.analog.joypad.map-scale`

The joystick X axis gives numbers from **0** to **1023**. That’s not very friendly to read. Let’s convert it to **0–100%**, with a small **dead zone** around the middle so it doesn’t flicker.

## Solution

```cpp
// Joystick X axis on A0
const int JOY_X = A0;

// Treat values close to the center (≈512) as "no movement"
const int DEAD = 30; // adjust to taste

void setup() {
  Serial.begin(9600);
}

void loop() {
  int raw = analogRead(JOY_X);     // 0..1023 (about 512 at center)
  int pct;                         // 0..100 (50% ≈ center)

  // Dead zone: force to 50% when near center
  if (abs(raw - 512) <= DEAD) {
    pct = 50;
  }
  // Left side (below center): map to 0..50
  else if (raw < 512 - DEAD) {
    pct = map(raw, 0, 512 - DEAD, 0, 50);
  }
  // Right side (above center): map to 50..100
  else {
    pct = map(raw, 512 + DEAD, 1023, 50, 100);
  }

  // Safety clamp in case of tiny ADC noise
  pct = constrain(pct, 0, 100);

  // Show both raw and scaled values
  Serial.print("raw: ");
  Serial.print(raw);
  Serial.print("  pct: ");
  Serial.print(pct);
  Serial.print("%  ");

  // Simple text bar (every 5% adds one '#')
  int bars = pct / 5;
  for (int i = 0; i < bars; i++) Serial.print('#');
  Serial.println();

  delay(100);
}
```

**Technical discussion (focus on how/why)**

* `map(value, fromLow, fromHigh, toLow, toHigh)` linearly converts a number from one range into another. Here we map **0–1023** (ADC) into **0–100** (percent).
* We split the range into **three parts**: left, center (dead zone), and right. This keeps the output steady when the stick is near the middle.
* `abs(raw - 512)` measures how far from the center we are; `DEAD` sets how wide the quiet band is.
* `constrain(x, 0, 100)` clamps the result to a safe range in case of tiny overshoots from rounding.
* Integer math is fine here: `map()` and `constrain()` return integers, which is what we want for whole-percent output.

## Discussion

* **Why should students care about this?** Converting sensor numbers into useful scales (percent, degrees, pixels, PWM) is a core skill. It’s how raw data becomes something you can use to control lights, motors, and UI.
* **Where else might this be used?**

  * Mapping a light sensor to screen brightness.
  * Mapping a knob to audio volume (0–100%).
  * Mapping a temperature reading into a color or fan speed.

## Challenge

1. Drive hardware with two mappings at once:

   * Map X to **0–255** and use it to set an LED’s brightness with `analogWrite()` on a PWM pin.
   * Keep the **0–100%** printout from the sketch so you can see both views of the same input.

2. Turn the Y axis into **5 steps** using `map()` (e.g., 0..4) and print labels like `FAR-DOWN`, `DOWN`, `CENTER`, `UP`, `FAR-UP`. Make sure the center step lines up with the dead zone.
