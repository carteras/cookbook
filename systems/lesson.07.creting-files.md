# Lesson 7: Creating Files and Putting It All Together — `touch`, redirection, and `tee`

## Concept

There are three common ways to create files in Linux, and each suits a different situation:

- **`touch`** — creates an empty file instantly, nothing inside
- **`echo "..." > filename`** — creates a file with content in one shot using shell redirection
- **`tee`** — writes content to a file AND displays it on screen at the same time; crucially, it can be combined with `sudo` to write to files you don't have direct permission to write to

Understanding all three is essential because you'll hit situations where each one is the right (or only) tool for the job.

This lesson also brings together everything from Lessons 3–6: creating a user, setting a password, changing ownership, and setting permissions — all applied to a new file.

## Goals

- Create files using `touch`, `echo` redirection, and `tee`
- Understand when to use each method
- Use `tee` with `sudo` to write to privileged files
- Apply `chown` and `chmod` to a newly created file
- See how ownership and permissions work together in a realistic scenario

## At the End of This Lesson You Will Be Able To

- Use `touch` to create empty files
- Use `echo "content" > file` to create files with content
- Explain the difference between `>` (overwrite) and `>>` (append)
- Use `sudo tee` to write to files owned by root
- Create a file as one user and reassign ownership to another
- Set precise permissions on a file
- Describe what each step achieves in terms of access control

## Glossary

| Command / Term | Meaning |
|----------------|---------|
| `touch filename` | Creates an empty file (or updates timestamps if it already exists) |
| `echo "text"` | Prints text to the terminal |
| `>` | Redirect operator — sends output into a file, **overwriting** it |
| `>>` | Append operator — adds output to the **end** of a file |
| `tee filename` | Reads from standard input, writes to a file AND to the terminal simultaneously |
| `sudo tee` | The correct way to write to a root-owned file without opening an editor as root |
| `ls -la \| grep flag` | List files, filtered to only show lines containing "flag" |
| `\|` | Pipe — sends the output of one command into another |
| `grep` | Searches for a pattern in text |

---

## Background: Three Ways to Create a File

### Method 1: `touch`

`touch` has two behaviours:

1. **If the file doesn't exist** — creates a new, empty file
2. **If the file already exists** — updates its "last accessed" and "last modified" timestamps to right now (without changing the content)

Use it when you need a placeholder file and don't care about content yet.

```bash
touch secret.flag
```

### Method 2: `echo "..." > filename`

The shell's `>` operator **redirects** the output of a command into a file. Combined with `echo`, this creates a file with content in a single step.

```bash
echo "this is a secret" > secret.flag
```

The `>` operator **overwrites** the file completely. If the file already exists, its old content is gone. If it doesn't exist, it's created.

To **add** to the end of a file without destroying what's already there, use `>>` (double arrow):

```bash
echo "a first line" > notes.txt
echo "a second line" >> notes.txt
cat notes.txt
```

```
a first line
a second line
```

> ⚠️ **Easy mistake:** `>` will silently destroy the contents of an existing file. If you meant `>>`, you'll lose data. Double-check which one you need before pressing Enter.

### Method 3: `echo "..." | sudo tee filename`

Here's the problem with `>` and `sudo`: the shell sets up the redirection **before** running your command, and it does so as **you**, not as root. So this doesn't work:

```bash
sudo echo "hello" > /etc/somefile   # FAILS — the > runs as you, not root
```

```
bash: /etc/somefile: Permission denied
```

The fix is `tee`. The `tee` command reads from its input and writes to a file — and since `tee` itself is the thing touching the file, `sudo tee` runs the file write as root:

```bash
echo "hello" | sudo tee /etc/somefile
```

```
hello          ← tee always prints what it wrote to the terminal too
```

`tee` also supports append mode with `-a`:

```bash
echo "another line" | sudo tee -a /etc/somefile
```

Here's a side-by-side comparison:

```
                    ┌─────────────────────────────────────────────┐
                    │         Creating files: when to use what     │
                    ├──────────────────┬──────────────────────────┤
                    │ Situation        │ Use                       │
                    ├──────────────────┼──────────────────────────┤
                    │ Empty file       │ touch filename            │
                    │ File with text   │ echo "..." > filename     │
                    │ Append to file   │ echo "..." >> filename    │
                    │ Write as root    │ echo "..." | sudo tee f   │
                    │ Append as root   │ echo "..." | sudo tee -a f│
                    └──────────────────┴──────────────────────────┘
```

---

## Instructions

This scenario: we're going to create a file called `secret.flag` in `notadam`'s home directory. We want `adam` to own it, but only `notadam` (via group membership) should be able to read it — no one else.

### Step 1 — Navigate to notadam's Directory

Make sure you've completed Lessons 3–6 first (user created, password set, ownership and permissions configured).

```bash
cd /home/notadam
```

### Step 2 — Create the File with `touch`

```bash
touch secret.flag
```

Check what was created:

```bash
ls -la
```

```
total 24
drwx------ 2 adam    notadam 4096 Jan 01 10:30 .
drwxr-xr-x 5 root    root    4096 Jan 01 10:00 ..
-rw-r----- 1 notadam notadam  220 Jan 01 10:00 .bash_logout
-rw-r----- 1 notadam notadam 3526 Jan 01 10:00 .bashrc
-rw-r----- 1 notadam notadam  141 Jan 01 10:00 .profile
-rw-rw-r-- 1 adam    adam       0 Jan 01 10:30 secret.flag
```

Notice the new file:
- Size is `0` bytes (it's empty — that's expected with `touch`)
- Owner is `adam:adam` (because **you** created it, so you own it)
- Permissions are `-rw-rw-r--` (owner and group can read/write, others can read)

### Step 3 — Change the Group to `notadam`

We want the `notadam` group to be the group owner. This means `notadam` (as a group member) will be able to access it via group permissions.

```bash
sudo chown adam:notadam secret.flag
```

Verify with a filtered `ls`:

```bash
ls -la | grep flag
```

```
-rw-rw-r-- 1 adam    notadam    0 Jan 01 10:30 secret.flag
```

The group is now `notadam`. Good.

### Step 4 — Tighten the Permissions

Currently, "others" can read the file. We want this to be a secret — let's remove group-write and other-read:

```bash
sudo chmod g-w,o-r secret.flag
```

- `g-w` — remove write from group (group should only read, not modify)
- `o-r` — remove read from others (no one outside the group should see it)

```bash
ls -la | grep flag
```

```
-rw-r----- 1 adam    notadam    0 Jan 01 10:30 secret.flag
```

Let's decode the final permissions:

```
-  rw-  r--  ---
│   │    │    │
│   │    │    └── Others:  no access at all
│   │    └─────── Group (notadam): read only
│   └──────────── User (adam):     read and write
└──────────────── Regular file
```

### Step 5 — Write Content Using `echo` Redirection

The file exists but is still empty. Let's put something in it using `echo` and `>`:

```bash
echo "this is a secret" > secret.flag
cat secret.flag
```

```
this is a secret
```

Now let's test who can actually access it.

**As adam (that's you):** You can read and write it — your permissions are `rw-`.

```bash
echo "updated secret" > secret.flag
cat secret.flag
```

```
updated secret
```

**As notadam:** They can read it (group permission `r--`), but not write to it.

```bash
su - notadam
cat /home/notadam/secret.flag
```

```
updated secret
```

```bash
echo "trying to modify" >> /home/notadam/secret.flag
```

```
bash: /home/notadam/secret.flag: Permission denied
```

Works as designed. Type `exit` to return to your account.

**As a third user (e.g., root or another user):** They cannot read it at all (permissions `---` for others).

---

### Step 6 — Writing to Privileged Files with `sudo tee`

Now let's look at a real-world scenario where `echo >` alone isn't enough.

Try writing to a system-owned file:

```bash
echo "my setting" > /etc/motd
```

```
bash: /etc/motd: Permission denied
```

The `>` redirection runs as **you**, not as root — even if you prefix `echo` with `sudo`. Let's prove it:

```bash
sudo echo "my setting" > /etc/motd
```

```
bash: /etc/motd: Permission denied
```

Still fails. The shell sets up the `>` redirect before `sudo` even runs, so the file is still opened as your regular user.

The solution is `tee`. Since `tee` is the command doing the writing, `sudo tee` runs the write as root:

```bash
echo "Welcome to the server. Authorised access only." | sudo tee /etc/motd
```

```
Welcome to the server. Authorised access only.
```

`tee` always prints what it wrote to the terminal — that's by design, so you can confirm the write happened.

Verify it worked:

```bash
cat /etc/motd
```

```
Welcome to the server. Authorised access only.
```

Now let's **append** a second line without overwriting the first, using `tee -a`:

```bash
echo "Contact admin@example.com for access issues." | sudo tee -a /etc/motd
```

```bash
cat /etc/motd
```

```
Welcome to the server. Authorised access only.
Contact admin@example.com for access issues.
```

> 💡 `/etc/motd` is the "message of the day" — it gets displayed to users when they log in over SSH. It's a good real-world target for practising `tee`.

---

## Putting It All Together: A Summary of the Full Workflow

Here's everything we've done across Lessons 3–7 as a quick-reference recap:

```bash
# 1. Create a new user with a home directory
sudo useradd -m notadam

# 2. Set their password
sudo passwd notadam

# 3. Change into their directory (after fixing ownership)
sudo chown adam:notadam /home/notadam
cd /home/notadam

# 4. Lock down their config files from outsiders
sudo chmod o-r .*

# 5. Create a new empty file
touch secret.flag

# 6. Set ownership: adam owns it, notadam group can access it
sudo chown adam:notadam secret.flag

# 7. Set permissions: adam rw, notadam group r, others nothing
sudo chmod g-w,o-r secret.flag

# 8. Write content into the file
echo "this is a secret" > secret.flag

# 9. Write to a root-owned system file
echo "Authorised access only." | sudo tee /etc/motd

# 10. Append to a root-owned system file
echo "Contact admin for access." | sudo tee -a /etc/motd
```

---

## Other `touch` Uses

```bash
# Create multiple files at once
touch file1.txt file2.txt file3.txt

# Create a file at a specific path
touch /home/notadam/documents/notes.txt

# Update timestamps on an existing file without changing content
touch existingfile.txt

# Set a specific timestamp (useful for scripting)
touch -t 202401011200.00 file.txt   # Set to Jan 1, 2024, 12:00
```

---

## Summary

- `touch filename` creates an empty file; if the file exists, it just updates its timestamps
- `echo "text" > file` creates (or overwrites) a file with content in one step
- `echo "text" >> file` appends to a file without destroying existing content
- `echo "text" | sudo tee file` is the correct way to write to a root-owned file — `sudo echo ... >` does NOT work because the shell opens the file as you before sudo runs
- `sudo tee -a` appends to a privileged file
- When you create a file, you automatically become its owner
- Use `chown` to transfer ownership or change the group
- Use `chmod` to control exactly who can read, write, or execute
- The combination of ownership + permissions gives Linux fine-grained access control