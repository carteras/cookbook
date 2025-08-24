# Problem: How can you loop through a command’s output line by line?

*Category:* `bash.iteration.while.command-output`

We want to run a command (e.g., list running processes) and handle its output one line at a time inside a `while` loop.

## Solution

```bash
#!/bin/bash

# Example: iterate over running processes (PID and command)
# Using process substitution to keep the loop in the current shell
# and avoid subshell side-effects (e.g., losing variable changes).

while IFS= read -r line
do
  echo "PROCESS: $line"
done < <(ps -eo pid,comm --no-headers)
```

technical discussion <focus only on the technical how and why>

* `ps -eo pid,comm --no-headers` prints one process per line with PID and command. You can replace this with any command that emits line-oriented output.
* `while IFS= read -r line` reads one full line safely:

  * `IFS=` preserves leading/trailing whitespace.
  * `-r` stops backslash escapes from being interpreted.
* `done < <(command)` is **process substitution**. It feeds the command’s output to the loop as a file. This keeps the `while` loop in the **current shell**, so any variables you set or modify inside the loop persist after it finishes.
* If you instead used a pipe, like `command | while read ...; do ...; done`, many bash versions run the loop in a **subshell**, and variable changes would not persist outside the loop. Process substitution avoids that trap.

## Discussion

* **Why students should care about this?**
  Many scripts need to parse the output of other commands. Reading output line by line gives precise control for filtering, counting, or transforming data.

* **Where else this kind of logic might be used?**
  Parsing log lines from `journalctl`, iterating over files from `find`, processing network connections from `ss`/`netstat`, or scanning package lists from `dpkg`/`rpm`.

## Challenge

Write a script that:

1. Iterates over the lines of `ls -1 /bin` and counts how many entries start with the letter `g`.
2. Then iterates over `ps -eo comm --no-headers` and counts how many running commands contain the substring `ssh`.
   Print both counts at the end.
