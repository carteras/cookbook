# tldr: echo

## Description

Prints text to the terminal (standard output). Simple on its own, but becomes powerful when combined with redirection (`>`, `>>`) to write to files, or with pipes (`|`) to feed text into other commands.

---

## Simple Examples

```bash
# Print a string to the terminal
echo "Hello, world"

# Print a variable's value
echo $HOME
echo $USER

# Print without a trailing newline (-n flag)
echo -n "no newline at the end"

# Print with escape sequences enabled (-e flag)
echo -e "line one\nline two\ttabbed"

# Write text to a file (overwrites if it exists)
echo "this is a secret" > secret.flag

# Append text to a file (adds to the end, doesn't overwrite)
echo "another line" >> notes.txt
```

---

## Composite Example

Building a flag file using a pipeline — `echo` feeds text into `md5sum`, which gets cleaned up by `cut`, and the result is redirected into the file:

```bash
echo "my_flag" | md5sum | cut -d " " -f1 > /home/bushranger101/secret.flag
cat /home/bushranger101/secret.flag
```

```
a43c1b0aa53a0c908810c06ab1ff3967
```

Testing read/write access as different users:

```bash
# As admin_user — can write
echo "updated content" > secret.flag

# As bushranger101 — permission denied
echo "tampering" > secret.flag
# bash: secret.flag: Permission denied
```

---

## Notes for Students

- **`>` overwrites. `>>` appends.** This is one of the most common mistakes in the terminal. `echo "hello" > important_file` will silently destroy whatever was in `important_file`. Pause before pressing Enter.
- `echo` by itself doesn't need quotes around simple strings, but **always quote strings** that contain spaces, special characters (`$`, `!`, `*`), or variables you don't want expanded.
- `echo "text" > file` is the quickest way to create a file with content in a single command — no editor needed.
- When used in a pipeline (`echo "text" | somecommand`), `echo` is just a way to inject a string as input to another command. You'll use this constantly with `md5sum`, `grep`, `tee`, and many others.
- `echo $?` prints the exit code of the last command you ran — `0` means success, anything else means an error. Useful for debugging.
