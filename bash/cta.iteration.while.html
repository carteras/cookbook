# Cognitive task analysis — `while read` loop

> How a student thinks through replacing 10 × `read` with a while loop

---

## Goal

| Overall goal |
|---|
| Process any number of input lines and print them back out — without knowing in advance how many lines there are |

---

## Subgoals

| Subgoal 1 | Subgoal 2 | Subgoal 3 | Subgoal 4 |
|-----------|-----------|-----------|-----------|
| **Recognise the repetition problem** | **Read one line per iteration** | **Do something with that line** | **Stop when input runs out** |
| 10 × `read` is doing the same thing over and over — that's a signal to use a loop | Each loop cycle grabs exactly one line from stdin and stores it | The body of the loop is where the work happens — for now, just `echo "$line"` | The loop must end cleanly when there are no more lines, without counting |

---

## Decisions

| Decision | Question | Answer |
|----------|----------|--------|
| 1 | What kind of loop? | `for` needs to know the count upfront. `while` keeps going until a condition fails — and `read` fails naturally at end of input. |
| 2 | What is the loop condition? | `read line` is both the condition and the action — it returns false when stdin is empty, which ends the loop. |
| 3 | Can I reuse the same variable name? | Yes — unlike 10 × `read`, the loop overwrites `$line` each iteration on purpose. |
| 4 | Where does input come from? | A pipe or a redirect. Both work, but `done < file` keeps variables in scope after the loop ends. |

---

## Actions — in order

| Step | Action | Detail |
|------|--------|--------|
| 01 | Write the shebang | `#!/bin/bash` |
| 02 | Open the loop | `while read -r line; do` — `read line` is the condition, runs before each iteration |
| 03 | Write the body | `  echo "$line"` — one `echo` handles all lines |
| 04 | Close the loop | `done` — sends control back to `while`, repeats until `read` fails |
| 05 | Run and test | `cat passwords.txt \| ./test.sh` — output should match input exactly |

---

## The mental model shift

| Stage 1 thinking | Stage 2 thinking |
|------------------|------------------|
| "I need to read line 1, then line 2, then line 3..." | "I need to do the same thing to every line until there are none left." |
| Counting-based. One instruction per line. | Pattern-based. Think about the action, not the count. |
| Breaks when the count is wrong. | Works regardless of how many lines arrive. |
| 20 lines of code for 10 inputs. | 3 lines of code for any input. |

---

## Common errors

| | Error | Fix |
|--|-------|-----|
| ⚠️ | Forgetting `do` or `done` | Both are required — the body sits between them |
| ⚠️ | Unquoted variable: `echo $line` | Always use `echo "$line"` — quotes preserve spaces |
| ⚠️ | Variable set inside loop disappears | Pipe creates a subshell — use `done < file` instead of `cat file \|` |
| ⚠️ | Missing `-r` flag | Without it, backslashes in input are swallowed silently |
| ✅ | The correct full script | `#!/bin/bash` then `while read -r line; do echo "$line"; done` |
