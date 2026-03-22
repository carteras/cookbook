# tldr: grep

## Description

Searches for a pattern in text and prints only the lines that match. Works on files directly, or on piped input from another command. The name stands for "Global Regular Expression Print." One of the most used commands in Linux — once you know it, you'll reach for it constantly.

---

## Simple Examples

```bash
# Find lines containing "bushranger101" in a file
grep "bushranger101" /etc/passwd

# Case-insensitive search
grep -i "root" /etc/passwd

# Show line numbers alongside matches
grep -n "PasswordAuthentication" /etc/ssh/sshd_config

# Invert the match — show lines that do NOT contain the pattern
grep -v "nologin" /etc/passwd

# Count how many lines match
grep -c "bash" /etc/passwd

# Search recursively through all files in a directory
grep -r "secret" /home/bushranger101/

# Show N lines of context around each match (-A = after, -B = before, -C = both)
grep -A 2 "Match" /etc/ssh/sshd_config
```

---

## Composite Example

Searching `/etc/passwd` to confirm a user account was created:

```bash
cat /etc/passwd | grep bushranger101
# bushranger101:x:1003:1003::/home/bushranger101:/bin/bash
```

Filtering `ls -la` output to find a specific file:

```bash
ls -la /home/bushranger101/ | grep secret
# -rw-r----- 1 admin_user bushranger101 33 Jan 01 secret.flag
```

Checking SSH config to confirm a setting is active (not commented out):

```bash
grep "^PasswordAuthentication" /etc/ssh/sshd_config
# PasswordAuthentication yes
```

The `^` means "start of line" — this skips lines where the setting is commented out with `#`.

---

## Notes for Students

- `grep "pattern" file` and `cat file | grep "pattern"` do the same thing. The piped version is useful when the text is coming from another command rather than a file.
- `grep` uses **regular expressions**, not just plain text. Characters like `.`, `*`, `^`, `$`, `[`, `]` have special meaning. If your search string contains these, either quote it carefully or use `grep -F` for a plain fixed-string search.
- `^` anchors to the start of a line. `grep "^#"` finds lines that start with `#` (comments). `grep -v "^#"` finds lines that are NOT comments — useful for reading config files without the noise.
- `grep -r` to search through a whole directory tree is invaluable for CTF challenges — if a flag is hidden somewhere on the filesystem and you know part of the string, `grep -r "flag{" /` will find it (though it'll be slow and noisy on a full system).
- Combine with `wc -l` to count results: `grep "bash" /etc/passwd | wc -l` tells you how many users have bash as their shell.
