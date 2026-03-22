# tldr: | (the pipe)

## Description

The pipe (`|`) connects two commands by feeding the **output** of the left command directly into the **input** of the right command. No temporary files, no intermediate steps — the data flows in real time between programs. It's one of the most powerful ideas in Linux: small, single-purpose tools chained together to do complex things.

The pipe symbol is typed with `Shift+\` (the backslash key, above Enter on most keyboards).

---

## The Mental Model

```
command1 | command2 | command3

     stdout ──►  stdin      stdout ──►  stdin
command1    ──►  command2   ──►  command3  ──►  terminal
```

Each command in the chain only sees the output of the one before it. The final command's output goes to your terminal (or to a file with `>`).

---

## Simple Examples

```bash
# See all users on the system, filtered to those with bash
cat /etc/passwd | grep bash

# Count how many users have bash as their shell
cat /etc/passwd | grep bash | wc -l

# See running processes, filtered to show only sshd
ps aux | grep sshd

# List files, sorted by size (largest first)
ls -lS /home/bushranger101/

# Page through a long file without it scrolling off the screen
cat /etc/ssh/sshd_config | less
# (press q to quit less)

# Show only the first 5 lines of a command's output
cat /etc/passwd | head -5

# Show only the last 5 lines
cat /etc/passwd | tail -5
```

---

## Composite Example

The full wargame flag pipeline — four commands chained together:

```bash
echo "my_flag" | md5sum | cut -d " " -f1 > /home/bushranger101/secret.flag
```

Step by step what each pipe does:

```
echo "my_flag"
    │
    │  "my_flag\n"
    ▼
md5sum
    │
    │  "a43c1b0aa53a0c908810c06ab1ff3967  -\n"
    ▼
cut -d " " -f1
    │
    │  "a43c1b0aa53a0c908810c06ab1ff3967\n"
    ▼
> /home/bushranger101/secret.flag
```

Another real example — finding which accounts on the system have a login shell and counting them:

```bash
cat /etc/passwd | grep -v nologin | grep -v false | cut -d ":" -f1
```

```
root
admin_user
bushranger101
```

Breaking it down:
1. `cat /etc/passwd` — read the full user database
2. `grep -v nologin` — remove system accounts that can't log in
3. `grep -v false` — remove accounts with `/bin/false` as shell
4. `cut -d ":" -f1` — extract just the username (field 1, colon-separated)

---

## Notes for Students

- **Pipes don't write to disk.** Data flows directly between programs in memory. This makes pipelines fast and means you're not cluttering up the filesystem with temporary files.
- **Each command in a pipe runs simultaneously**, not sequentially. `command1` starts writing, and `command2` starts reading at the same time. For large files, this is much faster than waiting for `command1` to finish before starting `command2`.
- **`|` vs `>`** — the pipe sends output to another *command*; `>` sends output to a *file*. You can combine them: `command1 | command2 > output.txt` pipes into `command2` and then redirects the final output into a file.
- **`2>/dev/null`** redirects error messages (stderr) to the bin. It's not a pipe — `2>` redirects the error stream, while `|` redirects the normal output stream. They're often used together: `find / -name "*.flag" 2>/dev/null | head -10`
- The pipe is the foundation of the Unix philosophy: write programs that do one thing well, and connect them together. Once you think in pipelines, the terminal becomes dramatically more powerful.
