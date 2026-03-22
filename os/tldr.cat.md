# tldr: cat

## Description

Reads a file and prints its contents to the terminal. Short for "concatenate" — its original purpose was stitching multiple files together, but it's used most often to quickly display a file's contents. Also useful for feeding file contents into a pipeline.

---

## Simple Examples

```bash
# Display a file's contents
cat secret.flag

# Display multiple files one after another
cat file1.txt file2.txt

# Display a file with line numbers
cat -n /etc/passwd

# Display a file showing non-printing characters (tabs as ^I, etc.)
cat -A config.txt

# Concatenate two files into a new one
cat file1.txt file2.txt > combined.txt

# Append one file to another
cat extra.txt >> existing.txt
```

---

## Composite Example

Checking the flag after the wargame setup is complete:

```bash
cat /home/bushranger101/secret.flag
# a43c1b0aa53a0c908810c06ab1ff3967
```

Searching through `/etc/passwd` to verify a user exists (piping `cat` output into `grep`):

```bash
cat /etc/passwd | grep bushranger101
# bushranger101:x:1003:1003::/home/bushranger101:/bin/bash
```

---

## Notes for Students

- `cat` is the quickest way to see what's in a file. You'll use it constantly.
- For long files, `cat` dumps everything at once — it'll scroll past faster than you can read. Use `less filename` instead to page through it.
- `cat /etc/passwd` is a classic first command to run on a new Linux system — it shows you all the accounts on the machine, including system accounts.
- The `cat file | grep pattern` pattern (piping into grep) is one of the most common combinations in the terminal. It lets you search through file contents without opening an editor.
- `cat` on a **directory** will give you an error — use `ls` to see what's inside a directory instead.
