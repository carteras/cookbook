# Cognitive task analysis — `read` by line

> How a student thinks through accepting 10 lines of input and printing them back out

---

## Goal

| Overall goal |
|---|
| Accept 10 lines of input and print them back out — one line at a time, in order |

---

## Subgoals

| Subgoal 1 | Subgoal 2 | Subgoal 3 |
|-----------|-----------|-----------|
| **Capture each line from stdin** | **Hold all 10 values** | **Output each line in order** |
| Store each incoming line so it can be used later | Need somewhere to keep each line without overwriting the last | Print all 10 values, one per line, in the same sequence they arrived |

---

## Decisions

| Decision | Question | Answer |
|----------|----------|--------|
| 1 | How does input arrive? | Via a pipe — not typed interactively. `read` pulls from stdin, not the keyboard. |
| 2 | Does one `read` get everything? | No — `read` grabs one line at a time. 10 lines = 10 calls to `read`. |
| 3 | Use a new variable each time? | Yes for stage 1. Stage 2 replaces this with a loop and one variable name. |
| 4 | How to print? | `echo "$var"` is enough — always quote the variable to preserve spacing. |

---

## Actions — in order

| Step | Action | Detail |
|------|--------|--------|
| 01 | Write the shebang | `#!/bin/bash` — tells the OS this is a bash script |
| 02 | Call `read` 10 times | Each call waits for a line from stdin and stores it in a unique variable |
| 03 | Call `echo` 10 times | Print each variable in the same order they were read |
| 04 | Make the script executable | `chmod +x test.sh` before first use |
| 05 | Run and test | `cat passwords.txt \| ./test.sh` — verify output matches input |

---

## Common errors

| | Error | Fix |
|--|-------|-----|
| ⚠️ | Forgetting quotes: `echo $line` collapses spaces | Use `echo "$line"` |
| ⚠️ | Reusing the same variable: `read line` 10× overwrites each time | Use `line1`, `line2` ... or a loop |
| ⚠️ | Calling `read` fewer than 10 times | Remaining lines are silently dropped |
| ⚠️ | Printing in the wrong order | `echo` calls must match the `read` call order |
| ✅ | The while loop in stage 2 removes all four mistakes above at once | `while read -r line; do echo "$line"; done` |
