# tldr: find

## Description

Searches the filesystem for files and directories matching criteria you specify — name, type, owner, permissions, size, modification time, and more. Unlike `grep` (which searches inside files), `find` searches for the files themselves. In CTF and wargame contexts it's the primary tool for locating hidden flags.

---

## Simple Examples

```bash
# Find all files named "secret.flag" anywhere under /home
find /home -name "secret.flag"

# Find files with a case-insensitive name match
find /home -iname "*.flag"

# Find only files (not directories)
find /home -type f -name "*.flag"

# Find only directories
find /home -type d

# Find files owned by a specific user
find /home -user bushranger101

# Find files owned by a specific group
find /home -group bushranger101

# Find files with specific permissions (exact match)
find /home -perm 640

# Find files modified in the last 24 hours
find /home -mtime -1

# Find files larger than 1MB
find /home -size +1M

# Find files and run a command on each result
find /home -name "*.flag" -exec cat {} \;
```

---

## Composite Example

The classic CTF scenario — a flag is hidden somewhere on the system and you need to find it:

```bash
# Search the whole filesystem for files named "secret.flag"
find / -name "secret.flag" 2>/dev/null
```

```
/home/bushranger101/secret.flag
```

The `2>/dev/null` redirects error messages (permission denied on directories you can't read) to `/dev/null` so they don't clutter your output.

Finding every file your user can read that belongs to a specific group:

```bash
find / -group bushranger101 -readable 2>/dev/null
```

Finding files with the SUID bit set (a common CTF target — files that run as their owner regardless of who executes them):

```bash
find / -perm -4000 -type f 2>/dev/null
```

---

## Notes for Students

- **`2>/dev/null` is almost always needed** when running `find` as a non-root user. Hundreds of "Permission denied" errors will bury your actual results. Redirect stderr to `/dev/null` to silence them.
- `-type f` means regular file. `-type d` means directory. `-type l` means symlink. Always specify `-type f` when looking for flags — you don't want directories cluttering your results.
- `-exec command {} \;` runs a command on every file found. The `{}` is replaced by the filename. The `\;` ends the command. This is how you chain `find` with `cat`, `chmod`, or anything else.
- In wargames, `find` with `-perm -4000` (SUID files), `-group targetuser` (files a group can access), and `-name` patterns are the three searches you'll use most.
- `find . -name "*.flag"` searches from the current directory downward. `find /` searches the whole filesystem from root. The starting path matters — start narrow and go wider if you don't find results.
