
# Problem: How can you use a `while` loop to print the multiplication table for 7?

We want to generate and print the multiplication table of a number (here, `7`) using a `while` loop.

## Solution

```bash
#!/bin/bash

number=7
multiplier=1

while [ $multiplier -le 10 ]
do
  result=$((number * multiplier))
  echo "$number x $multiplier = $result"
  multiplier=$((multiplier + 1))
done
```

The loop begins with `multiplier=1` and runs while `multiplier` is less than or equal to `10`. On each iteration, the script calculates the product of `number` and `multiplier`, prints it in formatted form, and then increments the multiplier.

## Discussion

* **Why students should care about this?**
  Multiplication tables are a simple, structured example of iteration with arithmetic. They reinforce the idea of controlled repetition: repeat a calculation a fixed number of times while updating a counter.

* **Where else this kind of logic might be used?**
  Generating sequences, producing reports, building repeated calculations, or formatting structured output (like tables of values). This is the same logic used in loops that generate formatted results from data.

## Challenge

Write a script that:

1. Asks the user for a number `n` and prints its multiplication table up to `n x 10`.
2. Then prints the multiplication table for all numbers from 1 through `n`.


