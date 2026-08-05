# `while read` — bash cheat sheet

> Process input line by line — works for 1 line or 1 million

---

## Basic syntax

```bash
while read line; do
  echo "$line"
done
```

The loop runs once per line. When there are no more lines, it stops automatically.

---

## Where input comes from

| From a pipe | From a file | From a variable |
|-------------|-------------|-----------------|
| `cat passwords.txt \| ./test.sh` | `while read line; do` | `data="line1` |
| | `  echo "$line"` | `line2` |
| Inside `test.sh`: | `done < passwords.txt` | `line3"` |
| `while read line; do` | | |
| `  echo "$line"` | Redirect keeps variables | `while read line; do` |
| `done` | in scope after `done` | `  echo "$line"` |
| | | `done <<< "$data"` |

---

## Common patterns

| Print each line | Count as you go | Do something with each | Split into parts |
|-----------------|-----------------|------------------------|-----------------|
| `while read line; do` | `count=0` | `while read password; do` | `# splits on whitespace` |
| `  echo "$line"` | `while read line; do` | `  echo "Checking: $password"` | `while read user pass; do` |
| `done` | `  count=$((count + 1))` | `done` | `  echo "User: $user"` |
| | `  echo "$count: $line"` | | `  echo "Pass: $pass"` |
| | `done` | | `done` |

---

## Useful flags

| Flag | Example | Description |
|------|---------|-------------|
| `-r` | `while read -r line` | Raw mode — don't treat `\` as escape. Use this by default. |
| `-d` | `while read -d , field` | Change the line delimiter (default is newline) |
| `-t N` | `while read -t 5 line` | Timeout after N seconds per line |

---

## The two-stage lesson

| Stage 1 — verbose | Stage 2 — while loop |
|-------------------|----------------------|
| `#!/bin/bash` | `#!/bin/bash` |
| `read p1` | `while read -r line; do` |
| `read p2` | `  echo "$line"` |
| `read p3` | `done` |
| `read p4` | |
| `read p5` | Works for any number of lines. |
| `read p6` | Nothing to change. |
| `read p7` | This is the refactor. |
| `read p8` | |
| `read p9` | |
| `read p10` | |
| `echo "$p1"` | |
| `echo "$p2"` ... | |
| Breaks if input has 9 or 11 lines | |

---

## How it works

```
stdin opens
    │
    ▼
while → read gets a line
    │
    ├── line exists → body runs → loop back to read
    │
    └── no more input → read returns false → exit loop
```

---

## The mental model shift

| Stage 1 thinking | Stage 2 thinking |
|------------------|------------------|
| "I need to read line 1, then line 2, then line 3..." | "I need to do the same thing to every line until there are none left." |
| Counting-based. One instruction per line. | Pattern-based. Think about the action, not the count. |
| Breaks when the count is wrong. | Works regardless of how many lines arrive. |
| 20 lines of code for 10 inputs. | 3 lines of code for any input. |

---

## Gotchas

| | |
|--|--|
| ⚠️ | **Missing `-r`** — without it, backslashes in input are swallowed. Use `while read -r line` as a habit. |
| ⚠️ | **Variable scope** — `cat file \| while read` runs the loop in a subshell. Variables set inside won't exist after `done`. Use `done < file` instead. |
| ⚠️ | **Missing quotes** — `echo $line` collapses spaces and breaks on special characters. Always use `echo "$line"`. |
| ✅ | **`while read` stops cleanly** — no need to count lines or check for end of file manually. |
| ✅ | **Use `done < file`** not `cat file \| while read` to keep variables in scope after the loop. |
