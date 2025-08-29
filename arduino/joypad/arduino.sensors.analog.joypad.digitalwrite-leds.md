# problem: How can I turn on a LEFT LED or RIGHT LED depending on which way the joystick is pushed?

`arduino.sensors.analog.joypad.digitalwrite-leds`

We want to use the joystick’s X axis to control two LEDs:

* Push left → **LEFT LED** turns on.
* Push right → **RIGHT LED** turns on.
* In the center, both LEDs should be off.

## Solution

```cpp
// Joystick X axis
const int JOY_X = A0;

// LEDs
const int LEFT_LED  = 4;
const int RIGHT_LED = 5;

void setup() {
  pinMode(LEFT_LED, OUTPUT);
  pinMode(RIGHT_LED, OUTPUT);
  Serial.begin(9600);
}

void loop() {
  int xValue = analogRead(JOY_X);

  if (xValue < 400) {
    digitalWrite(LEFT_LED, HIGH);   // turn on LEFT LED
    digitalWrite(RIGHT_LED, LOW);   // turn off RIGHT LED
    Serial.println("LEFT");
  } else if (xValue > 600) {
    digitalWrite(RIGHT_LED, HIGH);  // turn on RIGHT LED
    digitalWrite(LEFT_LED, LOW);    // turn off LEFT LED
    Serial.println("RIGHT");
  } else {
    digitalWrite(LEFT_LED, LOW);    // center: both off
    digitalWrite(RIGHT_LED, LOW);
    Serial.println("CENTER");
  }

  delay(100);
}
```

**Technical discussion (how/why)**

* `pinMode(pin, OUTPUT)` prepares the Arduino to send signals to that pin.
* `digitalWrite(pin, HIGH)` sets the pin to +5V → LED turns on (with a resistor).
* `digitalWrite(pin, LOW)` sets the pin to 0V → LED turns off.
* We use an `if/else-if/else` chain so **only one of the LEDs can be on at once**.
* Thresholds (`<400` and `>600`) create a **dead zone** around the middle, so both LEDs are off when the stick is at rest.

## Discussion

* **Why should students care?** This is the classic way Arduino makes decisions visible with hardware. LEDs are the “hello world” of outputs — simple but powerful.
* **Where else used?** Status lights (battery low, Wi-Fi connected), directional signals (robot left/right), or feedback indicators (button pressed, system armed).

## Challenge

1. Use **both X and Y axes** to control **4 LEDs**: one each for LEFT, RIGHT, UP, and DOWN.
2. Instead of turning LEDs fully on or off, use `analogWrite()` to make them **brighter** the further the joystick is pushed in that direction.
