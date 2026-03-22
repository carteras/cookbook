# Lesson 5: File Ownership — `chown`

## Concept

Every file and directory on a Linux system has **two owners**:

1. A **user** (also called the "owner") — one specific person
2. A **group** — a collection of users

Ownership determines who has control over a file. When you create a file, you automatically become its owner.

The `chown` command (**ch**ange **own**er) lets administrators change who owns a file or directory.

## Goals

- Understand user and group ownership on files
- Change the owner and group of a directory using `chown`
- Understand why ownership affects access

## At the End of This Lesson You Will Be Able To

- Read ownership information from `ls -la` output
- Use `chown user:group` to change ownership
- Explain why you can't access a directory you don't own

## Glossary

| Command / Term | Meaning |
|----------------|---------|
| `chown` | Change the owner (and optionally group) of a file/directory |
| `chown user:group path` | Set both user and group at once |
| `chown -R` | Recursively change ownership of a directory and everything inside it |
| `ls -la` | List files with long format, showing ownership |
| **Owner** | The user who owns the file |
| **Group** | A named collection of users; files can belong to a group |

---

## Background: Reading Ownership in `ls -la`

Run this command:

```bash
ls -la /home
```

You'll see something like:

```
total 16
drwxr-xr-x  4 root    root    4096 Jan 01 10:00 .
drwxr-xr-x 23 root    root    4096 Jan 01 09:00 ..
drwx------  4 adam    adam    4096 Jan 01 09:30 adam
drwx------  2 notadam notadam 4096 Jan 01 10:00 notadam
```

Reading the columns:

```
drwx------  2  notadam  notadam  4096  Jan 01 10:00  notadam
│           │  │        │
│           │  │        └── Group owner
│           │  └─────────── User owner
│           └────────────── Number of links
└────────────────────────── Permissions (we'll cover these in the next lesson)
```

---

## The Problem: You Can't Access Another User's Directory

Let's try to access `notadam`'s home directory:

```bash
cd /home/notadam
```

```
-bash: cd: /home/notadam: Permission denied
```

Why? Because `/home/notadam` is owned by `notadam`, and you're logged in as `adam`. You don't own it and you're not in the `notadam` group, so you're locked out.

Check who you are:

```bash
whoami
```

```
adam
```

---

## Instructions

### Step 1 — Check Current Ownership

```bash
ls -la /home
```

Notice that `notadam`'s directory is owned by `notadam:notadam` (user: notadam, group: notadam).

### Step 2 — Change the Owner

We want to give `adam` ownership of `notadam`'s directory, while keeping `notadam` as the group. This lets `adam` work in the directory while `notadam` can still access their own files as a group member.

```bash
sudo chown adam:notadam /home/notadam
```

Breaking this down:
- `sudo` — we need administrator rights to change ownership
- `chown` — change owner command
- `adam:notadam` — set user owner to `adam`, group owner to `notadam`
- `/home/notadam` — the directory to change

### Step 3 — Verify the Change

```bash
ls -la /home
```

```
total 16
drwxr-xr-x  5 root root    4096 Jan 01 10:00 .
drwxr-xr-x 23 root root    4096 Jan 01 09:00 ..
drwx------  4 adam adam    4096 Jan 01 09:30 adam
drwx------  2 adam notadam 4096 Jan 01 10:00 notadam
                ↑   ↑
                │   └── Group is still notadam
                └────── User owner is now adam
```

### Step 4 — Now Try to Access the Directory

```bash
cd /home/notadam
```

It works now! Let's look at what's inside:

```bash
ls -la
```

```
total 16
drwx------ 2 adam    notadam 4096 Jan 01 10:00 .
drwxr-xr-x 5 root    root    4096 Jan 01 10:00 ..
-rw-r--r-- 1 notadam notadam  220 Jan 01 10:00 .bash_logout
-rw-r--r-- 1 notadam notadam 3526 Jan 01 10:00 .bashrc
-rw-r--r-- 1 notadam notadam  141 Jan 01 10:00 .profile
```

Notice that the files **inside** the directory still belong to `notadam:notadam`. We only changed the ownership of the directory itself, not the files inside it.

---

## Other Useful `chown` Variations

```bash
# Change just the user owner (keep existing group)
sudo chown adam /home/notadam

# Change user and make group the same as user
sudo chown adam: /home/notadam

# Change ownership recursively (directory AND everything inside)
sudo chown -R adam:notadam /home/notadam

# Change a symbolic link's ownership (not the file it points to)
sudo chown -h adam path/to/symlink
```

---

## Summary

- Every file has a user owner and a group owner
- `ls -la` shows ownership in columns 3 and 4
- `sudo chown user:group path` changes both owner and group
- Ownership is separate from permissions (covered in the next lesson)
- You need `sudo` to change ownership of files you don't own