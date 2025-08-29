# problem: How can I make the Arduino choose between `"LEFT"` and `"RIGHT"` depending on which way the joystick is pushed?

`arduino.sensors.analog.joypad.ifelse-left-right`

The joystick’s X value is around **512** when centered. When pushed left, the number goes smaller; when pushed right, it goes bigger. We want the Arduino to decide: print `"LEFT"` if it’s on the left side, or `"RIGHT"` if it’s on the right side.

## Solution

```cpp
const int JOY_X = A0;

void setup() {
  Serial.begin(9600);
}

void loop() {
  int xValue = analogRead(JOY_X);  // 0..1023

  if (xValue < 400) {
    Serial.println("LEFT");
  } else {
    Serial.println("RIGHT");
  }

  delay(100);
}
```

**Technical discussion (how/why)**

* The `if` statement checks one condition.
* Adding `else` tells Arduino: *“If the condition is NOT true, do this other thing instead.”*
* In this example:

  * If `xValue < 400` → print `"LEFT"`.
  * Otherwise (meaning `xValue >= 400`) → print `"RIGHT"`.
* This guarantees that one of the two options will always happen.

## Discussion

* **Why should students care?** `if/else` lets a program choose between two paths. This is useful when you always want one action or the other, never “nothing.”
* **Where else used?** Turning on a heater if it’s too cold, otherwise turning on a fan; moving a robot left vs. right; deciding win/lose in a game.

## Challenge

1. Use the Y axis instead of X, and print `"UP"` vs. `"DOWN"`.
2. Add a **dead zone**: if the joystick is between 450 and 600, print `"CENTER"` instead of left or right.
