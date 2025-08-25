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

### 2. **Loop control**

* `break` → exits the loop immediately.
* `continue` → skips to the next iteration.

### 3. **Arithmetic**

Use `$(( ... ))` or `(( ... ))` for math:

```bash
((count++))   # increment
((sum += 5))  # add to variable
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

These patterns form the basis for all the recipes in the cookbook.

---

## Why it matters

* Loops let you **automate repetition** instead of writing the same command many times.
* They allow scripts to **adapt dynamically** to conditions (user input, files, system state).
* Mastering loops is the first step toward building interactive, resilient, and powerful shell scripts.
