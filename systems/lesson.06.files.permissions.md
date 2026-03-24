I can recreate Lesson 6 on `chmod` for you, following the same structure and style as your Lesson 5. Let me put it together:

---

# Lesson 6: File Permissions — `chmod`

## Concept

Every file and directory on a Linux system has **permissions** that control what can be done with it, and by whom.

Permissions are split across three categories:

1. **User (u)** — the file's owner
2. **Group (g)** — members of the file's group
3. **Other (o)** — everyone else

For each category, there are three types of permission:

- **r** — read
- **w** — write
- **x** — execute (run as a program, or enter a directory)

The `chmod` command (**ch**ange **mod**e) lets you change these permissions.

## Goals

- Understand how Linux permission bits work
- Read permissions from `ls -la` output
- Use `chmod` to change permissions symbolically and numerically

## At the End of This Lesson You Will Be Able To

- Decode permission strings like `drwxr-x---`
- Use `chmod u+x`, `chmod go-w`, and similar symbolic forms
- Use `chmod 755`, `chmod 644`, and similar numeric (octal) forms
- Explain the difference between permissions and ownership

## Glossary

| Command / Term | Meaning |
|----------------|---------|
| `chmod` | Change the permission mode of a file or directory |
| `chmod symbolic` | e.g. `chmod u+x file` — add/remove specific bits |
| `chmod octal` | e.g. `chmod 755 file` — set all bits at once with a number |
| `chmod -R` | Recursively change permissions on a directory and everything inside |
| `ls -la` | List files with long format, showing permissions |
| **r / w / x** | Read, write, execute |
| **u / g / o / a** | User, group, other, all |

---

## Background: Reading Permissions in `ls -la`

Run this command:

```bash
ls -la /home
```

You'll see something like:

```
total 16
drwxr-xr-x  4 root root    4096 Jan 01 10:00 .
drwxr-xr-x 23 root root    4096 Jan 01 09:00 ..
drwx------  4 adam adam    4096 Jan 01 09:30 adam
drwx------  2 adam notadam 4096 Jan 01 10:00 notadam
```

The first column is the permission string. Here's how to read it:

```
drwxr-x---
│└─┘└─┘└─┘
│ u   g   o
└── file type: d = directory, - = regular file
```

Each block of three characters represents `rwx` for that category. A `-` means that permission is not set:

| String | User | Group | Other |
|--------|------|-------|-------|
| `rwxr-x---` | read, write, execute | read, execute | nothing |
| `rw-r--r--` | read, write | read | read |
| `rwx------` | read, write, execute | nothing | nothing |

---

## The Problem: A Script You Can't Run

Let's say you've created a script:

```bash
echo '#!/bin/bash' > hello.sh
echo 'echo Hello, world!' >> hello.sh
```

Now try to run it:

```bash
./hello.sh
```

```
-bash: ./hello.sh: Permission denied
```

Check its permissions:

```bash
ls -la hello.sh
```

```
-rw-r--r-- 1 adam adam 32 Jan 01 10:00 hello.sh
```

The file has no `x` (execute) bit set for anyone. You need to add it.

---

## Instructions

### Step 1 — Check Current Permissions

```bash
ls -la hello.sh
```

```
-rw-r--r-- 1 adam adam 32 Jan 01 10:00 hello.sh
```

The owner (`adam`) can read and write, but nobody can execute it.

### Step 2 — Add Execute Permission (Symbolic)

```bash
chmod u+x hello.sh
```

Breaking this down:
- `chmod` — change mode command
- `u+x` — for the **u**ser owner, **add** e**x**ecute permission
- `hello.sh` — the file to change

### Step 3 — Verify the Change

```bash
ls -la hello.sh
```

```
-rwxr--r-- 1 adam adam 32 Jan 01 10:00 hello.sh
     ↑
     └── execute bit is now set for user
```

### Step 4 — Run the Script

```bash
./hello.sh
```

```
Hello, world!
```

---

## Symbolic vs Numeric (Octal) Mode

`chmod` accepts two styles of input.

**Symbolic** — readable, makes targeted changes:

```bash
chmod u+x file        # Add execute for user
chmod go-w file       # Remove write for group and other
chmod a+r file        # Add read for all (user, group, other)
chmod u=rwx,go=r file # Set exactly: user gets rwx, group and other get r only
```

**Numeric (octal)** — sets all permissions at once using a 3-digit number:

Each permission has a value: `r=4`, `w=2`, `x=1`. Add them up per category:

| # | Permissions |
|---|-------------|
| 7 | rwx (4+2+1) |
| 6 | rw- (4+2) |
| 5 | r-x (4+1) |
| 4 | r-- (4) |
| 0 | --- (0) |

So `chmod 755 file` means:
- User: `7` → rwx
- Group: `5` → r-x
- Other: `5` → r-x

Common patterns:

```bash
chmod 755 script.sh    # Owner full control; group/other can read and execute
chmod 644 file.txt     # Owner can read/write; group/other read-only
chmod 700 private/     # Owner full control; nobody else can see inside
chmod 600 secret.txt   # Owner read/write only; completely private
```

---

## Other Useful `chmod` Variations

```bash
# Recursively change permissions on a directory and all contents
chmod -R 755 /var/www/html

# Remove write permission for everyone
chmod a-w file.txt

# Give group the same permissions as the user
chmod g=u file.txt
```

---

## Summary

- Permissions control who can read, write, or execute a file
- `ls -la` shows a 10-character permission string in column 1
- The string is split into: file type, user bits, group bits, other bits
- `chmod` changes permissions — symbolically (`u+x`) or numerically (`755`)
- Permissions and ownership (covered in Lesson 5) work together to control access