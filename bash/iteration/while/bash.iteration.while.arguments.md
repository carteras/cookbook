# Problem: How can you use a `while` loop to print each argument passed to the script?


We want to loop over all positional arguments given to the script (`$1`, `$2`, …) until none remain, printing each one in turn.

## Solution

```bash
#!/bin/bash

while [ $# -gt 0 ]
do
  echo "Argument: $1"
  shift
done
```

The special variable `$#` holds the number of positional arguments. The loop runs while that number is greater than zero. Inside the loop:

* `$1` represents the current argument.
* `shift` discards the first argument and moves the rest down, so `$2` becomes `$1`, `$3` becomes `$2`, etc.
  The loop continues until no arguments remain.

## Discussion

* **Why students should care about this?**
  Scripts often need to handle variable-length input from the command line. Understanding how to process arguments one by one is essential for writing flexible, reusable tools.

* **Where else this kind of logic might be used?**
  Parsing file lists, processing options, batch-processing user input, or handling commands passed to scripts. This is the foundation of writing custom command-line utilities.

## Challenge

Write a script that:

1. Prints each argument passed to it.
2. Counts how many arguments there were in total and prints the count at the end.

