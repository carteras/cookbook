# Problem: How can you count down from 10 to 1 with a one-second delay between numbers?

We want a countdown timer that prints numbers in reverse order, pausing for one second between each step.

## Solution

```bash
#!/bin/bash

count=10

while [ $count -gt 0 ]
do
  echo $count
  sleep 1
  count=$((count - 1))
done

echo "Time's up!"
```

The loop starts with `count=10`. The condition `[ $count -gt 0 ]` ensures the loop runs while the counter is greater than zero. Inside, the script prints the current count, pauses for one second with `sleep`, and then decrements the counter by one. When the counter reaches zero, the loop ends.

## Discussion

* **Why students should care about this?**
  This introduces timing into loops, showing how bash can control not just repetition but also pacing. Timing is essential for scripts that monitor, delay, or coordinate actions.

* **Where else this kind of logic might be used?**
  Countdown timers, retry delays, progress indicators, monitoring intervals, or pacing automated tasks. For example, retrying a network request every 5 seconds until it succeeds.

## Challenge

Write a script that:

1. Counts down from 30 to 1 with a one-second delay.
2. Every 5 seconds, prints an extra message like `"Still counting..."`.


