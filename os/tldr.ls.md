# tldr: ls

## Description

Lists the contents of a directory. On its own it gives a basic list. With flags it shows ownership, permissions, file sizes, timestamps, and hidden files — making it one of the most important commands for understanding what's on a system and who controls it.

---

## Simple Examples

```bash
# List files in the current directory
ls

# List files in a specific directory
ls /home

# Long format — shows permissions, owner, group, size, date
ls -l /home/bushranger101/

# Long format including hidden files (those starting with .)
ls -la /home/bushranger101/

# Human-readable file sizes (KB, MB, GB instead of bytes)
ls -lh /home/bushranger101/

# Sort by modification time, newest first
ls -lt

# Reverse sort order
ls -ltr

# List just filenames, one per line (useful in scripts)
ls -1
```

---

## Composite Example

Verifying ownership and permissions after a full wargame setup:

```bash
ls -la /home/bushranger101/
```

```
drwxr-x--- 2 admin_user    bushranger101 4096 Jan 01 11:00 .
drwxr-xr-x 5 root          root          4096 Jan 01 11:00 ..
-rw-r----- 1 admin_user    bushranger101  220 Jan 01 11:00 .bash_logout
-rw-r----- 1 admin_user    bushranger101 3526 Jan 01 11:00 .bashrc
-rw-r----- 1 admin_user    bushranger101  141 Jan 01 11:00 .bash_profile
-rw-r----- 1 admin_user    bushranger101   33 Jan 01 11:00 secret.flag
```

Reading that output:

```
drwxr-x---  2  admin_user    bushranger101  4096  Jan 01  .
│           │  │             │              │     │       └── filename
│           │  │             │              │     └────────── date modified
│           │  │             │              └──────────────── size in bytes
│           │  │             └─────────────────────────────── group owner
│           │  └───────────────────────────────────────────── user owner
│           └──────────────────────────────────────────────── number of hard links
└──────────────────────────────────────────────────────────── type + permissions
```

Filtering output to find a specific file:

```bash
ls -la /home/bushranger101/ | grep secret
# -rw-r----- 1 admin_user bushranger101 33 Jan 01 secret.flag
```

---

## Notes for Students

- **`ls -la` is the version you'll use most.** `-l` for the long format (so you can see permissions and ownership), `-a` to include hidden files (dotfiles). Get used to typing it together.
- Hidden files start with `.` — they won't show up with plain `ls`. Always use `-a` when you're auditing a directory.
- The first column (`drwxr-x---`) is the most important for this course. `d` means directory, `-` means regular file, `l` means symlink. The next nine characters are the permissions in three groups of three.
- `ls -la /home` (with the path) vs `ls -la` (without) — without a path it lists your current directory. With a path it lists that directory. You don't need to `cd` somewhere to list it.
- On most Linux systems, `ls` colour-codes output — directories are blue, executables are green, symlinks are cyan. If colour is missing, try `ls --color=auto`.
