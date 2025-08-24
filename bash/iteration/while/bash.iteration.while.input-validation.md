
# Problem: How can you keep asking the user for a number between 1 and 5 until they enter a valid one?

We want to validate user input. The script should repeatedly prompt the user for a number until they provide a value in the correct range (1–5). This introduces `while` loops for input validation.

## Solution

```bash
#!/bin/bash

number=0

while [ $number -lt 1 ] || [ $number -gt 5 ]
do
  read -p "Enter a number between 1 and 5: " number
done

echo "You entered: $number"
```

The variable `number` starts at `0`, which is outside the valid range. The loop condition checks if `number` is **less than 1** or **greater than 5**. As long as that condition is true, the loop keeps asking for input. Once the input is within range, the loop exits.

## Discussion

* **Why students should care about this?**
  Input validation is a crucial skill for writing reliable scripts. Without checks, scripts may behave unpredictably if the user gives incorrect or unexpected input. This pattern enforces safe, expected values before continuing.

* **Where else this kind of logic might be used?**
  Input validation is everywhere: menus that require a valid option, scripts that only accept certain ranges (like port numbers or configuration values), or tools that prevent destructive behavior unless the input is correct.

## Challenge

Write a script that:

1. Asks the user for a number between 10 and 20 until they enter a valid one.
2. After that, ask them for a letter (`a`, `b`, or `c`) until they provide a correct choice.

