# Lesson 3: Managing Users — Adding a New User

## Concept

Linux is a **multi-user** operating system. From the very beginning, it was designed for multiple people to use the same machine at the same time. Every file, process, and resource on the system is owned by a user.

When you need to give someone else access to the system (or create an isolated environment for a service), you create a new user account. Understanding users is fundamental to Linux system administration.

## Goals

- Understand how Linux stores user information
- Create a new user with a home directory
- Verify the user was created successfully

## At the End of This Lesson You Will Be Able To

- Use `useradd` to create new user accounts
- Understand the format of `/etc/passwd`
- Explain what a home directory is and why it matters

## Glossary

| Command / Term | Meaning |
|----------------|---------|
| `useradd` | Creates a new user account |
| `useradd -m` | Creates a new user AND creates their home directory |
| `/etc/passwd` | A file listing all user accounts on the system |
| **Home directory** | A personal folder for each user, usually at `/home/username` |
| **UID** | User ID — a unique number identifying a user |
| **GID** | Group ID — a unique number identifying a group |

---

## Background: How Linux Tracks Users

Every user on a Linux system has an entry in `/etc/passwd`. Have a look:

```bash
cat /etc/passwd
```

You'll see many lines, one per account. Most of these are system accounts (used by services, not real people). Look for your own account near the bottom.

Each line follows this format:

```
username:password:userid:groupid:comment:home_path:shell
```

For example:

```
adam:x:1000:1000:Adam:/home/adam:/bin/bash
```

| Field | Value | Meaning |
|-------|-------|---------|
| username | `adam` | The login name |
| password | `x` | Password is stored elsewhere (in `/etc/shadow`) |
| userid | `1000` | Unique number for this user |
| groupid | `1000` | Primary group number |
| comment | `Adam` | Full name or description |
| home_path | `/home/adam` | Where this user's files live |
| shell | `/bin/bash` | The program that runs when they log in |

---

## Instructions

### Step 1 — Create a New User

We'll create a user called `notadam`. Replace this with whatever username you're told to use.

The `-m` flag creates a **home directory** for the user:

```bash
sudo useradd -m notadam
```

No output means success (Linux is quiet when things work).

> 💡 **Why `-m`?** Without it, the user is created but has no home folder. They'd have nowhere to store their files. Always use `-m` for real user accounts.

### Step 2 — Verify the User Was Created

```bash
cat /etc/passwd | grep notadam
```

You should see:

```
notadam:x:1002:1002::/home/notadam:/bin/bash
```

Breaking it down:

```
notadam : x  : 1002    : 1002     : : /home/notadam : /bin/bash
username  pwd   userid    groupid       home_path      shell
```

> 📌 The UID and GID numbers will vary depending on how many users already exist on your system.

### Step 3 — Verify the Home Directory Was Created

```bash
ls /home
```

You should see both your own home directory and the new one:

```
adam  notadam
```

Let's look inside it:

```bash
ls -la /home/notadam
```

```
total 16
drwx------ 2 notadam notadam 4096 Jan 01 10:00 .
drwxr-xr-x 4 root    root    4096 Jan 01 10:00 ..
-rw-r--r-- 1 notadam notadam  220 Jan 01 10:00 .bash_logout
-rw-r--r-- 1 notadam notadam 3526 Jan 01 10:00 .bashrc
-rw-r--r-- 1 notadam notadam  141 Jan 01 10:00 .profile
```

These hidden files (starting with `.`) are automatically created from a template. They set up the user's shell environment when they log in.

---

## What's Next?

The user exists, but they can't log in yet — they don't have a password. We'll set that in the next lesson.

---

## Summary

- `sudo useradd -m notadam` creates a new user with a home directory
- Every user is recorded in `/etc/passwd`
- The format is: `username:x:uid:gid:comment:home:shell`
- New users get default configuration files (`.bashrc`, `.profile`, etc.) placed in their home directory