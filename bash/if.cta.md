# Cognitive task analysis — `if` string matching in bash

> How a student thinks through reading lines and printing only those that match a string

---

## Goal

| Overall goal |
|---|
| Read lines from stdin and print only the lines that match a target string — in this case, the word `password` |

---

## Subgoals

| Subgoal 1 | Subgoal 2 | Subgoal 3 |
|-----------|-----------|-----------|
| **Read each line** | **Test each line** | **Act on the result** |
| Loop through stdin one line at a time using `while read` | Check whether the current line matches the target string | Print the line if it matches, do nothing if it doesn't |

---

## Decisions

| Decision | Question | Answer |
|----------|----------|--------|
| 1 | How do I loop through the input? | Same as before — `while read -r line; do` reads one line per iteration |
| 2 | Where does the test go? | Inside the loop body, before the `echo` — test first, then act |
| 3 | Which bracket style — `[ ]` or `[[ ]]`? | Always `[[ ]]` in bash 5.2 — handles spaces safely, supports glob and regex |
| 4 | Exact match or pattern match? | Exact for now: `[[ "$line" == "password" ]]` — extend to glob or regex later |
| 5 | What happens when it doesn't match? | Nothing — no `else` needed if the goal is just to skip non-matching lines |

---

## Actions — in order

| Step | Action | Detail |
|------|--------|--------|
| 01 | Write the shebang | `#!/bin/bash` |
| 02 | Open the while loop | `while read -r line; do` — reads one line at a time from stdin |
| 03 | Open the if statement | `if [[ "$line" == "password" ]]; then` — test the current line |
| 04 | Write the body | `  echo "$line"` — only runs when the condition is true |
| 05 | Close the if | `fi` |
| 06 | Close the loop | `done` |
| 07 | Run and test | `cat passwords.txt \| ./test.sh` — should print `password` only |

---

## The full script

```bash
#!/bin/bash

while read -r line; do
  if [[ "$line" == "password" ]]; then
    echo "$line"
  fi
done
```

---

## The mental model

| Without `if` | With `if` |
|--------------|-----------|
| Every line passes through and gets printed | Each line is tested before anything happens |
| The loop body always runs | The loop body only runs when the condition is true |
| Output = all input | Output = filtered input |
| `echo "$line"` does the work | `[[ ]]` decides whether `echo` runs at all |

---

## Extending the pattern

| Goal | Condition to use |
|------|-----------------|
| Exact match: only `password` | `[[ "$line" == "password" ]]` |
| Contains `pass` anywhere | `[[ "$line" == *pass* ]]` |
| Starts with `pass` | `[[ "$line" == pass* ]]` |
| Matches a regex pattern | `[[ "$line" =~ ^pass[0-9]+$ ]]` |
| Does NOT match | `[[ "$line" != "password" ]]` |
| Match one of two words | `[[ "$line" == "password" \|\| "$line" == "pass" ]]` |

---

## Common errors

| | Error | Fix |
|--|-------|-----|
| ⚠️ | Missing spaces: `[["$line"=="password"]]` | Always space inside brackets: `[[ "$line" == "password" ]]` |
| ⚠️ | Using `[ ]` instead of `[[ ]]` | Single brackets don't handle spaces in variables or support glob/regex the same way |
| ⚠️ | Quoting regex pattern: `=~ "^pass"` | Don't quote the regex — `=~` treats quoted patterns as literal strings |
| ⚠️ | Unquoted variable: `[[ $line == "password" ]]` | Quote the variable: `[[ "$line" == "password" ]]` |
| ✅ | Correct full script | `while read -r line; do if [[ "$line" == "password" ]]; then echo "$line"; fi; done` |
