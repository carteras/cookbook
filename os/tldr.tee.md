# tldr: tee

## Description

Reads from standard input and writes to both a file **and** the terminal at the same time. The name comes from the T-shaped pipe fitting — input comes in one end and flows out two ways simultaneously. Its killer feature is that it can be combined with `sudo` to write to files owned by root, which plain `echo >` redirection cannot do.

---

## Simple Examples

```bash
# Write to a file and also display on screen
echo "some content" | tee output.txt

# Append to a file instead of overwriting
echo "another line" | tee -a output.txt

# Write to multiple files at once
echo "broadcast" | tee file1.txt file2.txt file3.txt

# Write to a root-owned file (the correct way)
echo "my config line" | sudo tee /etc/somefile

# Append to a root-owned file
echo "another line" | sudo tee -a /etc/somefile

# Write to a file but suppress the terminal output
echo "silent write" | tee output.txt > /dev/null
```

---

## Composite Example

Why `sudo echo >` fails and how `sudo tee` fixes it:

```bash
# This FAILS — the shell opens the file as you before sudo runs
sudo echo "Welcome. Authorised access only." > /etc/motd
# bash: /etc/motd: Permission denied

# This WORKS — tee is the thing opening the file, and sudo makes tee run as root
echo "Welcome. Authorised access only." | sudo tee /etc/motd
# Welcome. Authorised access only.   ← tee always prints what it wrote

# Verify
cat /etc/motd
# Welcome. Authorised access only.

# Now append a second line
echo "Contact admin for access issues." | sudo tee -a /etc/motd
cat /etc/motd
# Welcome. Authorised access only.
# Contact admin for access issues.
```

---

## Notes for Students

- **This is the correct way to write to system files.** When you're configuring SSH, editing network files, or writing to anything in `/etc`, you'll need `sudo tee`. Bookmark this pattern: `echo "content" | sudo tee /path/to/file`
- `tee` always prints to the terminal as confirmation. If you don't want to see the output, add `> /dev/null` at the end: `echo "content" | sudo tee /etc/file > /dev/null`
- The reason `sudo echo "text" > file` fails: the shell sets up the `>` redirect **before** running any commands. By the time `sudo echo` runs, the shell has already tried (and failed) to open the file as your regular user. `sudo` only elevates the `echo` part — too late.
- `tee -a` for append works the same way as `>>` does for regular redirection. Don't forget the `-a` if you don't want to overwrite.
- You'll use `tee` heavily when writing config files during server setup — network interfaces, SSH config, motd, cron jobs, and more.
