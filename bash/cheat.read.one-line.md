# `read` — bash cheat sheet

> Read input from stdin, one line at a time

---

## Basic syntax

```bash
read variable_name           # read one line into a variable
read first last              # split on whitespace into two vars
read -p "Enter name: " name  # show a prompt before reading
```

---

## Common patterns

| Read a single line | Read multiple lines | Read with a while loop | Read into an array |
|--------------------|--------------------|-----------------------|-------------------|
| `read line` | `read line1` | `while read line; do` | `mapfile -t lines \` |
| `echo "$line"` | `read line2` | `  echo "$line"` | `  < /dev/stdin` |
| | `read line3` | `done` | `echo "${lines[0]}"` |
| | `echo "$line1"` | | `echo "${lines[1]}"` |
| | `echo "$line2"` | Works for any number of lines | |

---

## How input arrives

| From a pipe | From a file | Pipe + args together |
|-------------|-------------|----------------------|
| `echo "hello" \| ./test.sh` | `while read line; do` | `echo "secret" \| ./test.sh arg1` |
| | `  echo "$line"` | |
| Inside `test.sh`: | `done < passwords.txt` | Inside `test.sh`: |
| `read line  # gets "hello"` | | `read secret_val  # from pipe` |
| | | `arg1="$1"         # from args` |

---

## Useful flags

| Flag | Description |
|------|-------------|
| `-p "text"` | Show a prompt before reading |
| `-s` | Silent mode — hides input (good for passwords) |
| `-r` | Raw mode — don't treat `\` as escape. Use this by default. |
| `-n N` | Stop after N characters, don't wait for Enter |
| `-t N` | Timeout after N seconds |
| `-a arr` | Read words into an array instead of a string |

---

## The two-stage lesson

| Stage 1 — verbose | Stage 2 — while loop |
|-------------------|----------------------|
| `read p1` | `#!/bin/bash` |
| `read p2` | `while read -r line; do` |
| `read p3` | `  echo "$line"` |
| `read p4` | `done` |
| `read p5` | |
| `read p6` | Works for any number of lines. |
| `read p7` | Nothing to change. |
| `read p8` | This is the refactor. |
| `read p9` | |
| `read p10` | |
| `echo "$p1"` | |
| `echo "$p2"` ... | |
| Breaks if input has 9 or 11 lines | |

---

## How `read` works

```
stdin opens
    │
    ▼
read waits for a line
    │
    ├── line arrives → stored in variable → your code runs
    │
    └── no more input → read returns false → loop ends
```

---

## Gotchas

| | |
|--|--|
| ⚠️ | **`read` only gets one line** — pipe 10 lines in, call `read` once, and you get the first line only. The rest are dropped. |
| ⚠️ | **Missing quotes** — `echo $line` collapses spaces. Always use `echo "$line"`. |
| ⚠️ | **Reusing the same variable** — calling `read line` 10 times overwrites the value each time. Use different names or a loop. |
| ✅ | **Use `while read -r line`** as your default. The `-r` flag stops backslashes in input from being swallowed. |
| ✅ | **Use `done < file`** not `cat file \| while read` — the pipe runs the loop in a subshell and variables set inside won't survive after `done`. |
