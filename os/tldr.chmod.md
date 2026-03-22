# tldr: chmod

## Description

Changes the read, write, and execute permissions on a file or directory. Permissions are set separately for three groups: the user owner (`u`), the group owner (`g`), and everyone else (`o`). You can also use `a` as shorthand for all three at once.

---

## Permission Cheat Sheet

| Symbol | Who |
|--------|-----|
| `u` | user (the file's owner) |
| `g` | group |
| `o` | others (everyone else) |
| `a` | all (u + g + o) |

| Symbol | Permission |
|--------|-----------|
| `r` | read |
| `w` | write |
| `x` | execute (or enter, for directories) |

| Operator | Effect |
|----------|--------|
| `+` | add permission |
| `-` | remove permission |
| `=` | set exactly (replaces whatever was there) |

---

## Simple Examples

```bash
# Add execute for the owner
chmod u+x script.sh

# Remove read from others
chmod o-r secret.flag

# Give everyone read and execute
chmod a+rx program

# Set permissions exactly: owner rw, group r, others nothing
chmod u=rw,g=r,o= secret.flag

# Numeric shorthand — same result as above (640)
chmod 640 secret.flag

# Recursive — change permissions on a whole directory tree
chmod -R u=rwx,g=rx,o= /home/bushranger101/

# Recursive with capital X — adds execute for directories but NOT regular files
chmod -R a+rX /home/bushranger101/
```

---

## Numeric (Octal) Quick Reference

Each digit is a sum: read=4, write=2, execute=1.

| Value | Permissions |
|-------|-------------|
| `7` | rwx |
| `6` | rw- |
| `5` | r-x |
| `4` | r-- |
| `0` | --- |

Common combinations:

| Mode | String | Typical Use |
|------|--------|-------------|
| `755` | rwxr-xr-x | Directories, executables |
| `644` | rw-r--r-- | Regular files |
| `640` | rw-r----- | Files readable by group only |
| `600` | rw------- | Private files (SSH keys) |
| `750` | rwxr-x--- | Directories readable by group only |

---

## Composite Example

Locking down a wargame home directory — setting precise permissions on every piece:

```bash
# The flag and config files: owner rw, group r, others nothing
sudo chmod u=rw,g=r,o= /home/bushranger101/secret.flag
sudo chmod u=rw,g=r,o= /home/bushranger101/.bash*

# The directory itself: owner rwx, group rx (can enter and list), others nothing
sudo chmod u=rwx,g=rx,o= /home/bushranger101

# Verify
ls -la /home/bushranger101/
```

```
drwxr-x--- 2 admin_user bushranger101 4096 Jan 01 .
-rw-r----- 1 admin_user bushranger101   33 Jan 01 secret.flag
-rw-r----- 1 admin_user bushranger101  220 Jan 01 .bash_logout
```

---

## Notes for Students

- **Use `=` instead of `+`/`-` when you want a guaranteed final state.** `u=rw,g=r,o=` will always result in `640` regardless of what the permissions were before. `u+rw` only adds — if something unexpected was already set, it stays.
- **Directory execute (`x`) means "enter".** Without `x` on a directory, you can't `cd` into it even if you have `r`. This trips people up constantly.
- **`chmod` and `chown` are a pair.** Permissions mean nothing without the right ownership. A file with `rw-r-----` is useless to the group if the wrong group is set.
- Reading `ls -la` output: the first character is the type (`d` = directory, `-` = file), then three groups of three characters: `[user][group][others]`.
- `777` (everyone can do everything) is almost always wrong. If you find yourself typing it, stop and think about what access you actually need.
