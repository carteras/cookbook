
# Problem: How can you keep asking the user for numbers and calculate their sum until they type `"0"`?

*Category:* `bash.iteration.while.accumulation`

We want a loop that repeatedly asks the user for numbers, adds them up, and only stops when the user enters `0`.

## Solution

```bash
#!/bin/bash

sum=0
number=1   # start with a non-zero number to enter the loop

while [ $number -ne 0 ]
do
  read -p "Enter a number (0 to quit): " number
  sum=$((sum + number))
done

echo "Total sum: $sum"
```

Here, `sum` is initialized to `0` and `number` is initialized to a non-zero value to make sure the loop starts. The loop runs until the user enters `0`. Inside, the script reads a number and adds it to the running total with arithmetic expansion. When `0` is entered, the condition `[ $number -ne 0 ]` fails, and the loop exits.

## Discussion

* **Why students should care about this?**
  Accumulation shows how loops can not only repeat, but also *build up* results over time. This is a foundational concept in programming, forming the basis of statistics, counters, and aggregations.

* **Where else this kind of logic might be used?**
  Summing numbers, counting events, tallying results from logs, calculating averages, or combining data across multiple iterations. Almost every data-processing script needs this concept.

## Challenge

Write a script that:

1. Continuously asks the user for numbers until they type `0`.
2. At the end, print both the total sum and the average of all non-zero numbers entered.

---

Shall I move on to the next recipe: *`bash.iteration.while.multiplication-table` (generating multiplication tables)*?



