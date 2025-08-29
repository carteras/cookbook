# Primer: Understanding `while` Loops in Bash



## What is a `while` loop?

A `while` loop repeats a block of commands **as long as a condition is true**.

### General form:

```bash
while [ condition ]
do
  # commands to repeat
done
```

* The **condition** is checked before each loop iteration.
* If the condition evaluates to true (exit status `0`), the body executes.
* Once the condition becomes false (exit status non-zero), the loop stops.

Reminder: In bash, a condition is a command (often inside `[ … ]`, `[[ … ]]`, or as part of test) that evaluates to an exit status: `0` means true (success) and `any non-zero value` means false (failure). Conditions are typically used in control structures like if, while, and until to decide the flow of execution.

---

## Example: Simple counter

```bash
count=1
while [ $count -le 5 ]
do
  echo $count
  count=$((count + 1))
done
```

This prints numbers `1` through `5`.

---

## Key building blocks

### 1. **Conditions**

Bash conditions return true/false based on exit codes.

* Numeric: `-lt`, `-le`, `-eq`, `-ne`, `-ge`, `-gt`
* Strings: `=`, `!=`, `-z` (empty), `-n` (non-empty)
* Files: `-f` (file exists), `-d` (directory exists), `-e` (exists)

```bash
#!/bin/bash

# Numeric: count down from 5
num=5
while [ "$num" -gt 0 ]; do
  echo "Countdown: $num"
  num=$((num - 1))
done

# Strings: keep looping until input is "quit"
str=""
while [ "$str" != "quit" ]; do
  read -p "Type something (or 'quit' to exit): " str
  if [ -z "$str" ]; then
    echo "You entered an empty string"
  else
    echo "You typed: $str"
  fi
done

# Files: loop until a file exists
file="ready.txt"
while [ ! -e "$file" ]; do
  echo "Waiting for $file to appear..."
  sleep 2
done
echo "$file found!"

```

### 2. **Loop control**

* `break` → exits the loop immediately.
* `continue` → skips to the next iteration.

```bash
#!/bin/bash

count=0

while [ "$count" -lt 10 ]; do
  count=$((count + 1))

  # Skip even numbers
  if [ $((count % 2)) -eq 0 ]; then
    continue
  fi

  echo "Processing number: $count"

  # Stop the loop if number reaches 7
  if [ "$count" -eq 7 ]; then
    echo "Reached 7, breaking out of the loop."
    break
  fi
done

echo "Loop finished."


```



### 3. **Arithmetic**

Use `$(( ... ))` or `(( ... ))` for math:

```bash
((count++))   # increment
((sum += 5))  # add to variable
```

```bash
#!/bin/bash

# Example 1: Simple counter
count=0
while [ "$count" -lt 5 ]; do
  echo "Count is: $count"
  ((count++))   # increment by 1
done

echo "Final count: $count"


# Example 2: Accumulating a sum
sum=0
count=0
while [ "$count" -lt 5 ]; do
  ((sum += 5))  # add 5 each iteration
  ((count++))   # increment
  echo "Iteration $count → Sum is: $sum"
done

echo "Final sum: $sum"
```

---

## Infinite loops

Sometimes you want a loop that never ends, until interrupted:

```bash
while true
do
  echo "Running..."
  sleep 1
done
```

Press `Ctrl+C` to stop.

---

## Common patterns

* **Counting:** repeat something a fixed number of times.
* **User input:** keep asking until the user types the right thing.
* **File processing:** read a file line by line.
* **Monitoring:** wait for a file, process, or network to be ready.

```bash
#!/bin/bash

# 1. Counting: repeat something 5 times
count=1
while [ "$count" -le 5 ]; do
  echo "Iteration $count"
  ((count++))
done

# 2. User input: ask until user types "yes"
input=""
while [ "$input" != "yes" ]; do
  read -p "Type 'yes' to continue: " input
done
echo "Thanks!"

# 3. File processing: read file line by line
while IFS= read -r line; do
  echo "Line: $line"
done < myfile.txt

# 4. Monitoring: wait for a file to appear
while [ ! -e "ready.txt" ]; do
  echo "Waiting for ready.txt..."
  sleep 2
done
echo "ready.txt found!"
```

---

## Why it matters

* Loops let you **automate repetition** instead of writing the same command many times.
* They allow scripts to **adapt dynamically** to conditions (user input, files, system state).
* Mastering loops is the first step toward building interactive, resilient, and powerful shell scripts.
