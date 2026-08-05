# `read` — bash cheat sheet
> Read input from stdin, one line at a time

---

## Basic syntax

```bash
read variable_name
read first last           # splits on whitespace into two vars
read -p "Enter name: " name  # shows a prompt first
```

---

## Common patterns

### Read a single line
```bash
read line
echo "You typed: $line"
```

### Read multiple lines manually
```bash
read line1
read line2
read line3
echo "$line1 $line2 $line3"
```

### Read all lines with a while loop
```bash
while read line; do
  echo "$line"
done
```

### Read into an array
```bash
mapfile -t lines < /dev/stdin

# access by index
echo "${lines[0]}"
echo "${lines[1]}"
```

---

## Useful flags

| Flag | Description |
|------|-------------|
| `-p "text"` | Show a prompt before reading |
| `-s` | Silent mode — hides input (good for passwords) |
| `-n N` | Stop after N characters (don't wait for Enter) |
| `-t N` | Timeout after N seconds |
| `-r` | Raw mode — don't treat backslash as escape |
| `-a arr` | Read words into an array instead of a string |

---

## How input arrives

### From a pipe
```bash
echo "hello" | ./test.sh

# inside test.sh:
read line   # gets "hello"
```

### From a file
```bash
while read line; do
  echo "$line"
done < passwords.txt
```

### Pipe + args together
```bash
echo "secret" | ./test.sh arg1 arg2

# inside test.sh:
read secret_val   # from pipe
arg1="$1"         # from args
```

### 10 lines from a pipe

```bash
cat passwords.txt | ./test.sh
```

**Stage 1 — verbose:**
```bash
read p1
read p2
read p3
read p4
read p5
read p6
read p7
read p8
read p9
read p10

echo "$p1"
echo "$p2"
# ... and so on
```

**Stage 2 — while loop refactor:**
```bash
while read p; do
  echo "$p"
done
```

---

## Gotchas

> **`read` only gets one line** — if you pipe 10 lines in and only call `read` once, you'll only get the first one.

> **Use `while read line`** when you don't know how many lines are coming — it handles 1 or 1000 without changes.

> **Use `-r`** if your input might contain backslashes (e.g. file paths) — otherwise bash will eat them.
