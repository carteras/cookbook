# problem: How can I check if the joystick has been pushed left past a certain point?

`arduino.sensors.analog.joypad.if-threshold`

When the joystick is in the middle, the X value is about **512**. If we push it left, the number gets smaller. We want to write a program that checks the joystick value, and if it’s smaller than a set limit, print `"LEFT"`.

## Solution

```cpp
const int JOY_X = A0;

void setup() {
  Serial.begin(9600);
}

void loop() {
  int xValue = analogRead(JOY_X);  // read X axis

  if (xValue < 350) {              // check if pushed left
    Serial.println("LEFT");
  }

  delay(100);
}
```

**Technical discussion (how/why)**

* The `if` statement runs the code inside the braces `{ }` **only when the condition is true**.
* Here the condition is `xValue < 350`. That means: “Is the joystick X number smaller than 350?”
* If yes, then Arduino prints `"LEFT"`. If not, nothing happens.
* 350 is just a chosen number — you can change it to make the joystick more or less sensitive.

## Discussion

* **Why should students care?** The `if` statement is one of the most important tools in programming. It lets the Arduino *decide* whether to act based on sensor input.
* **Where else used?** Checking if a button is pressed, if a light is too dim, if a temperature is too high, or any time you want your program to react only under certain conditions.

## Challenge

1. Make the program print `"RIGHT"` if the joystick X value is larger than 700.
2. Add another check so that `"CENTER"` is printed when the joystick X is between 350 and 700.

