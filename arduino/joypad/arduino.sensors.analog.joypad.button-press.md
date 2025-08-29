# problem: How can I detect when the joystick’s push-button is pressed using a clean, bounce-resistant logic level?

`arduino.sensors.analog.joypad.button-press`

You have a thumb joystick with an integrated push-button (SW pin). Wire SW → **D8**, GND → **GND**, +5V/VCC as required by your module. Use the Arduino’s internal pull-up so you don’t need an external resistor. Print `"BUTTON"` exactly once per press, ignoring mechanical bounce.

## Solution

```cpp
// Joystick button on D8, using internal pull-up
const int JOY_BTN = 8;

// simple debounce + edge-detect
bool lastStable = HIGH;         // HIGH = not pressed (because of pull-up)
bool lastReading = HIGH;
unsigned long lastChangeMs = 0;
const unsigned long DEBOUNCE_MS = 25;

void setup() {
  pinMode(JOY_BTN, INPUT_PULLUP);   // enables internal pull-up
  Serial.begin(115200);
}

void loop() {
  bool reading = digitalRead(JOY_BTN);  // LOW when pressed

  // Debounce: accept a change only if it stayed the same for DEBOUNCE_MS
  if (reading != lastReading) {
    lastChangeMs = millis();
    lastReading = reading;
  }

  if ((millis() - lastChangeMs) > DEBOUNCE_MS) {
    // stable state reached
    if (lastStable != reading) {
      lastStable = reading;

      // Edge-detect the press (HIGH->LOW transition)
      if (lastStable == LOW) {
        Serial.println("BUTTON");
      }
    }
  }

  // tiny pause is fine; logic is time-based via millis()
  delay(1);
}
```

**Technical discussion (how/why)**

* **INPUT\_PULLUP** configures an internal resistor that holds the pin at **HIGH** when the button is not pressed. Pressing the button connects the pin to **GND**, producing a **LOW**. This is called **active-low** logic.
* **digitalRead(pin)** samples the logic level. Because mechanical switches physically bounce, a single press may produce rapid HIGH/LOW flicker for a few milliseconds.
* The sketch uses a **time-based debounce**: when a change is detected, it waits `DEBOUNCE_MS` with no further changes before accepting the new state.
* **Edge detection** prints only on the **transition** to LOW (press), not while held, preventing repeated messages during a long press.
* Using `millis()` (instead of large `delay()`s) keeps the approach responsive and composable with other tasks.

## Discussion

* **Why care?** Buttons are the most common human input. Reading them reliably (pull-ups, active-low logic, debounce, edge detection) is foundational for every interactive project.
* **Where else used?** Menu navigation, game inputs, mode toggles, safety interlocks, start/stop controls, wake buttons, and any event-driven input that should trigger once per press.

## Challenge

Design a sketch that:

1. Prints `"SHORT"` on a quick tap and `"LONG"` when the button is held for more than 600 ms (use edge detection + timing).
2. Counts presses and toggles an LED every **third** valid press (debounced), while still classifying short vs. long presses in the serial output.
