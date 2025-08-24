# Problem: How can you create an infinite loop that stops only when the user presses `Ctrl+C`?

*Category:* `bash.iteration.while.infinite-loop`

We want a loop that runs endlessly, doing some repeated action, until the user manually interrupts it (e.g., with `Ctrl+C`).

## Solution

```bash
#!/bin/bash

while true
do
  echo "Looping... Press Ctrl+C to stop."
  sleep 2
done
```

* `while true` creates a loop that always runs since the condition `true` never fails.
* The body prints a message and then pauses for 2 seconds.
* The only way to exit is by manually interrupting the script (e.g., pressing `Ctrl+C`, which sends `SIGINT`).

## Discussion

* **Why students should care about this?**
  Infinite loops are a powerful tool when you need a script to keep running until told otherwise. They introduce the idea of external control (user or system signals) rather than internal exit conditions.

* **Where else this kind of logic might be used?**
  Monitoring scripts, background daemons, log watchers, or servers. Any script that must run continuously until stopped is built on this principle.

## Challenge

Write a script that:

1. Runs an infinite loop, printing the current date and time every 5 seconds.
2. Exits only when the user presses `Ctrl+C`.


