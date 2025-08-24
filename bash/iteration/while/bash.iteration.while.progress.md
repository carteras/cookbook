# Problem: How can you use a `while` loop to print a growing row of `#` symbols to simulate progress?

*Category:* `bash.iteration.while.progress`

We want to build a simple progress bar that grows step by step, using a `while` loop to add one symbol each iteration.

## Solution

```bash
#!/bin/bash

progress=0
limit=10
bar=""

while [ $progress -lt $limit ]
do
  bar="$bar#"
  echo -ne "\rProgress: [$bar]"
  sleep 1
  progress=$((progress + 1))
done

echo -e "\nDone!"
```

* The loop runs until `progress` reaches the limit (`10`).
* Each iteration appends one `#` to the variable `bar`.
* `echo -ne "\r..."` uses `\r` to return to the beginning of the line, so the bar updates in place instead of printing a new line each time.
* `sleep 1` slows down the updates for visibility.

## Discussion

* **Why students should care about this?**
  This demonstrates how loops can manage *state* across iterations, updating output in real time. It connects iteration with user experience, showing that loops can drive dynamic interfaces.

* **Where else this kind of logic might be used?**
  Progress bars for file downloads, backups, or long-running computations. More generally, any task where incremental updates need to be shown to the user.

## Challenge

Write a script that:

1. Prints a progress bar of length `20` characters.
2. Updates the bar by adding two `#` symbols per step, pausing one second between updates.
