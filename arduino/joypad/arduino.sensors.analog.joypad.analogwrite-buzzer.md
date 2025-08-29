# problem: How can I use the joystick to change the loudness of a buzzer with `analogWrite()`?

`arduino.sensors.analog.joypad.analogwrite-buzzer`

A passive buzzer can be connected to a PWM pin. The `analogWrite()` function lets us set the duty cycle (how much of the time the signal is ON). A higher duty cycle makes the buzzer louder. We want to use the joystick’s Y axis to control the loudness.

## Solution

```cpp
// Joystick Y axis
const int JOY_Y = A1;

// Passive buzzer connected to PWM pin
const int BUZZER = 6;  // must be a PWM-capable pin (~ symbol on Arduino)

void setup() {
  pinMode(BUZZER, OUTPUT);
  Serial.begin(9600);
}

void loop() {
  int yValue = analogRead(JOY_Y);          // 0..1023
  int volume = map(yValue, 0, 1023, 0, 255); // scale to PWM range

  analogWrite(BUZZER, volume);  // control loudness
  Serial.println(volume);       // show the value being written

  delay(100);
}
```

**Technical discussion (how/why)**

* `analogRead(A1)` reads the joystick Y axis as a number from 0 to 1023.
* `map(value, 0, 1023, 0, 255)` converts that number into a PWM duty cycle (0–255).
* `analogWrite(pin, duty)` sends a PWM signal:

  * `0` → always off (silent).
  * `255` → always on (loudest).
  * Anything in between → signal is on part of the time, giving different loudness.
* On most Arduinos, the PWM frequency is \~490 or \~980 Hz, so the pitch will sound fixed; only the **volume** changes. (For pitch changes, use `tone()` instead.)
* The buzzer must be connected to a PWM-capable pin (marked with `~` on the board).

## Discussion

* **Why should students care?** This is the bridge from reading sensors to **controlling real-world devices**. Joystick → number → PWM → sound. The same logic controls motors, LEDs, and other analog-like outputs.
* **Where else used?**

  * Controlling motor speed.
  * Adjusting LED brightness.
  * Regulating fan or pump strength.

## Challenge

1. Use the **X axis** to control the buzzer’s *pitch* with `tone()` while still using the **Y axis** to control the *volume* with `analogWrite()`.
2. Add an `if` so the buzzer only plays when the joystick button is pressed.

