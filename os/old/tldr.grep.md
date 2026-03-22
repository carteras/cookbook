# Lesson 8: Setting Up a Wargame Challenge — Users, Flags, and Permissions

## Concept

In wargames like `bushranger`, the goal is simple: find a password (called a **flag**) hidden somewhere on the system, then use it to unlock the next level. The magic is in how those flags are protected — carefully crafted ownership and permissions mean only the right user (or someone clever enough to exploit a weakness) can read them.

In this lesson you're going to set up exactly that kind of challenge from scratch. You'll create a player account, generate a flag using a hash, and then lock it down so only the right people can access it. When you're done, you'll have a real, playable level that you could hand to a classmate.

## Goals

- Create a new user account for a wargame player
- Generate a flag using `md5sum` and shell pipelines
- Use `chown` and `chmod` to set up precise, intentional access control on the flag file and home directory

## At the End of This Lesson You Will Be Able To

- Chain multiple commands together with pipes (`|`) and redirection (`>`)
- Use `md5sum` to generate a reproducible hash
- Use `cut` to extract a specific field from command output
- Construct a complete permission scheme from a specification
- Reason about who can and cannot access a file, and why

## Glossary

| Command / Term | Meaning |
|----------------|---------|
| `md5sum` | Generates an MD5 hash (a fixed-length fingerprint) of its input |
| `cut -d " " -f1` | Split output on spaces (`-d " "`) and return only the first field (`-f1`) |
| `\|` | Pipe — feeds the output of one command as input to the next |
| `>` | Redirect — writes output to a file (overwrites if it exists) |
| **Flag** | A secret string a player must find to prove they've solved a challenge |
| **Hash** | A fixed-length string computed from input — same input always gives same output |
| **CTF** | Capture The Flag — a style of security competition or learning exercise |
| **Wargame** | A hands-on security challenge where you hack into progressively harder levels |
| `wheel` | The admin group on Fedora — members can use `sudo` |

---

## Background: How Wargame Flags Work

A flag is just a string — something like `d41d8cd98f00b204e9800998ecf8427e`. What makes it a challenge is that the file containing it is locked down so only a specific user can read it. The player has to figure out how to become that user, or find another way in.

The access control setup we're building looks like this:

```
/home/bushranger101/
│
├── secret.flag              ← The flag file
│   ├── owner:  admin_user   (your wheel account) — can read and write
│   ├── group:  bushranger101 (the player's account) — can read only
│   └── others:              — no access at all
│
├── .bashrc, .bash_logout, .bash_profile
│   ├── owner:  admin_user   (your wheel account) — can read and write
│   ├── group:  bushranger101 — can read only
│   └── others:              — no access at all
│
└── (the directory itself)
    ├── owner:  admin_user   — can read, write, and enter
    ├── group:  bushranger101 — can read and enter (but not create/delete)
    └── others:              — no access at all
```

The player (`bushranger101`) can enter their home directory and read the flag and config files — but can't modify any of them. Your admin account owns and controls everything.

---

## Instructions

### Step 1 — Create the Player Account

Create a new user called `bushranger101` with a home directory:

```bash
sudo useradd -m bushranger101
```

Set their password:

```bash
sudo passwd bushranger101
```

Verify the account exists:

```bash
cat /etc/passwd | grep bushranger101
```

```
bushranger101:x:1003:1003::/home/bushranger101:/bin/bash
```

Check their home directory was created:

```bash
ls /home
```

```
admin_user  bushranger101
```

---

### Step 2 — Generate the Flag

This is the interesting part. We're going to build the flag using a pipeline of three commands:

```bash
echo "my_flag" | md5sum | cut -d " " -f1 > /home/bushranger101/secret.flag
```

Let's break this pipeline down piece by piece before running it.

#### What each stage does

**Stage 1: `echo "my_flag"`**

Prints the text `my_flag` to the terminal (standard output).

```bash
echo "my_flag"
```
```
my_flag
```

**Stage 2: `| md5sum`**

Takes that text and computes its MD5 hash. `md5sum` outputs the hash followed by a dash:

```bash
echo "my_flag" | md5sum
```
```
a43c1b0aa53a0c908810c06ab1ff3967  -
```

The `-` means "input came from stdin, not a file". We don't want that in our flag.

**Stage 3: `| cut -d " " -f1`**

`cut` splits each line by a delimiter (`-d " "` means split on spaces) and returns only the specified field (`-f1` means field 1 — the first part). This strips the ` -` from the end:

```bash
echo "my_flag" | md5sum | cut -d " " -f1
```
```
a43c1b0aa53a0c908810c06ab1ff3967
```

**Stage 4: `> /home/bushranger101/secret.flag`**

Redirects that clean hash into the flag file:

```bash
echo "my_flag" | md5sum | cut -d " " -f1 > /home/bushranger101/secret.flag
```

No output means success.

#### Verify the flag was written

```bash
cat /home/bushranger101/secret.flag
```

```
a43c1b0aa53a0c908810c06ab1ff3967
```

> 💡 **Tip for building real wargames:** Change `"my_flag"` to something secret that only you know — a phrase, a random string, anything. The MD5 hash is what the player finds; they don't need to know what you hashed to produce it. You can always regenerate the same hash by running the same `echo` again.

Check the file's current ownership and permissions:

```bash
ls -la /home/bushranger101/
```

```
total 24
drwx------ 2 bushranger101 bushranger101 4096 Jan 01 11:00 .
drwxr-xr-x 5 root          root          4096 Jan 01 11:00 ..
-rw-r--r-- 1 bushranger101 bushranger101  220 Jan 01 11:00 .bash_logout
-rw-r--r-- 1 bushranger101 bushranger101 3526 Jan 01 11:00 .bashrc
-rw-r--r-- 1 bushranger101 bushranger101  141 Jan 01 11:00 .bash_profile
-rw-r--r-- 1 admin_user    admin_user      33 Jan 01 11:00 secret.flag
```

Right now everything is too open. We need to lock it all down.

---

### Step 3 — Own the Flag File Correctly

We want:
- **User owner**: `admin_user` (your wheel account) — already the case since you created it
- **Group owner**: `bushranger101` — so the player can read it via group permissions

```bash
sudo chown admin_user:bushranger101 /home/bushranger101/secret.flag
```

Verify:

```bash
ls -la /home/bushranger101/ | grep secret
```

```
-rw-r--r-- 1 admin_user    bushranger101   33 Jan 01 11:00 secret.flag
```

Group is now `bushranger101`. Good. Permissions still need work — others can currently read it.

---

### Step 4 — Set Permissions on the Flag File

Target permission scheme for `secret.flag`:

```
-  rw-  r--  ---
│   │    │    │
│   │    │    └── Others:                no access
│   │    └─────── Group (bushranger101): read only
│   └──────────── User  (admin_user):    read and write
└──────────────── Regular file
```

That's `640` in numeric notation. Let's set it:

```bash
sudo chmod u=rw,g=r,o= /home/bushranger101/secret.flag
```

- `u=rw` — set user to exactly read+write (nothing else)
- `g=r` — set group to exactly read (nothing else)
- `o=` — set others to exactly nothing

The `=` operator sets permissions precisely, replacing whatever was there before. This is safer than `+` and `-` when you want an exact final state.

Verify:

```bash
ls -la /home/bushranger101/ | grep secret
```

```
-rw-r----- 1 admin_user    bushranger101   33 Jan 01 11:00 secret.flag
```

---

### Step 5 — Take Ownership of and Lock Down the Bash Config Files

When `useradd` created the account, it placed `.bashrc`, `.bash_logout`, and `.bash_profile` in the directory owned by `bushranger101`. We want `admin_user` to own these — just like the flag file — while `bushranger101` gets read-only access via the group.

First, transfer ownership of all `.bash*` files to `admin_user`, keeping `bushranger101` as the group:

```bash
sudo chown admin_user:bushranger101 /home/bushranger101/.bash*
```

Now set the permissions. The target scheme for `.bashrc`, `.bash_logout`, `.bash_profile`:

```
-  rw-  r--  ---
│   │    │    │
│   │    │    └── Others:                no access
│   │    └─────── Group (bushranger101): read only
│   └──────────── User  (admin_user):    read and write
└──────────────── Regular file
```

```bash
sudo chmod u=rw,g=r,o= /home/bushranger101/.bash*
```

Verify:

```bash
ls -la /home/bushranger101/
```

```
total 24
drwx------ 2 bushranger101 bushranger101 4096 Jan 01 11:00 .
drwxr-xr-x 5 root          root          4096 Jan 01 11:00 ..
-rw-r----- 1 admin_user    bushranger101  220 Jan 01 11:00 .bash_logout
-rw-r----- 1 admin_user    bushranger101 3526 Jan 01 11:00 .bashrc
-rw-r----- 1 admin_user    bushranger101  141 Jan 01 11:00 .bash_profile
-rw-r----- 1 admin_user    bushranger101   33 Jan 01 11:00 secret.flag
```

All four files now have `rw-r-----` with `admin_user` as owner. This matches exactly what a real wargame level looks like — the player can read everything in their home directory, but can't tamper with any of it.

---

### Step 6 — Set Permissions on the Home Directory Itself

The directory itself needs its own permission scheme. We want:

- `admin_user` to be the owner (so we can manage the contents)
- `bushranger101` group to be able to enter and list the directory
- Others to have no access at all

First, transfer ownership of the directory to `admin_user`, keeping `bushranger101` as the group:

```bash
sudo chown admin_user:bushranger101 /home/bushranger101
```

Now set the directory permissions:

Target permission scheme for `/home/bushranger101/`:

```
d  rwx  r-x  ---
│   │    │    │
│   │    │    └── Others:                no access
│   │    └─────── Group (bushranger101): read and enter (but can't create/delete)
│   └──────────── User  (admin_user):    full control
└──────────────── Directory
```

```bash
sudo chmod u=rwx,g=rx,o= /home/bushranger101
```

Verify:

```bash
ls -la /home/
```

```
total 16
drwxr-xr-x  5 root        root          4096 Jan 01 11:00 .
drwxr-xr-x 23 root        root          4096 Jan 01 09:00 ..
drwx------  4 admin_user  admin_user    4096 Jan 01 09:30 admin_user
drwxr-x---  2 admin_user  bushranger101 4096 Jan 01 11:00 bushranger101
```

The directory now shows `drwxr-x---` with `admin_user:bushranger101` ownership.

---

### Step 7 — Verify the Full Setup

Let's do a complete review of what we've built:

```bash
ls -la /home/bushranger101/
```

```
total 24
drwxr-x--- 2 admin_user    bushranger101 4096 Jan 01 11:00 .
drwxr-xr-x 5 root          root          4096 Jan 01 11:00 ..
-rw-r----- 1 admin_user    bushranger101  220 Jan 01 11:00 .bash_logout
-rw-r----- 1 admin_user    bushranger101 3526 Jan 01 11:00 .bashrc
-rw-r----- 1 admin_user    bushranger101  141 Jan 01 11:00 .bash_profile
-rw-r----- 1 admin_user    bushranger101   33 Jan 01 11:00 secret.flag
```

Check it against our target:

| File | Owner | Group | Permissions | ✓ |
|------|-------|-------|-------------|---|
| `/home/bushranger101` (dir) | admin_user | bushranger101 | `rwxr-x---` | ✓ |
| `secret.flag` | admin_user | bushranger101 | `rw-r-----` | ✓ |
| `.bashrc` | admin_user | bushranger101 | `rw-r-----` | ✓ |
| `.bash_logout` | admin_user | bushranger101 | `rw-r-----` | ✓ |
| `.bash_profile` | admin_user | bushranger101 | `rw-r-----` | ✓ |

---

### Step 8 — Test It as the Player

Switch to `bushranger101` and try to read the flag:

```bash
su - bushranger101
```

```bash
cat ~/secret.flag
```

```
a43c1b0aa53a0c908810c06ab1ff3967
```

The player can read the flag. Now try to modify it:

```bash
echo "cheating" > ~/secret.flag
```

```
bash: /home/bushranger101/secret.flag: Permission denied
```

Try to modify a config file too:

```bash
echo "export PATH=/evil:$PATH" >> ~/.bashrc
```

```
bash: /home/bushranger101/.bashrc: Permission denied
```

And try to access another user's home directory:

```bash
ls /home/admin_user
```

```
ls: cannot open directory '/home/admin_user': Permission denied
```

Everything is locked down correctly. Type `exit` to return to your admin account.

---

### Step 9 — Test It as an Outsider

Create a quick test as a third user to confirm others are completely locked out. From your admin account:

```bash
sudo useradd -m outsider
sudo su - outsider
```

```bash
ls /home/bushranger101
```

```
ls: cannot open directory '/home/bushranger101': Permission denied
```

```bash
cat /home/bushranger101/secret.flag
```

```
cat: /home/bushranger101/secret.flag: Permission denied
```

The `o=` we set on the directory stops outsiders before they can even see inside. Type `exit` to return to your admin account, then clean up:

```bash
sudo userdel -r outsider
```

---

## Full Command Recap

Here's the complete setup from scratch, ready to adapt for your own challenges:

```bash
# 1. Create the player account
sudo useradd -m bushranger101
sudo passwd bushranger101

# 2. Generate and write the flag
echo "my_flag" | md5sum | cut -d " " -f1 > /home/bushranger101/secret.flag

# 3. Set flag ownership: admin_user owns it, bushranger101 group can read
sudo chown admin_user:bushranger101 /home/bushranger101/secret.flag

# 4. Set flag permissions: admin_user rw, bushranger101 group r, others nothing
sudo chmod u=rw,g=r,o= /home/bushranger101/secret.flag

# 5. Take ownership of bash config files and lock them down the same way
sudo chown admin_user:bushranger101 /home/bushranger101/.bash*
sudo chmod u=rw,g=r,o= /home/bushranger101/.bash*

# 6. Give admin_user ownership of the directory, keep bushranger101 as group
sudo chown admin_user:bushranger101 /home/bushranger101

# 7. Set directory permissions: admin_user rwx, bushranger101 group rx, others nothing
sudo chmod u=rwx,g=rx,o= /home/bushranger101
```

---

## Going Further

Now that you understand how these challenges are constructed, try these extensions:


**Extension 1 — Hidden in plain sight:** create `bushranger102` and instead of `secret.flag`, hide the flag in by using `.` Try making it in a hidden directory.

**Extension 2 — Multi-level chain:** Create `bushranger103` whose flag is hidden inside `bushranger102`'s directory. Only `bushranger102` can read it. The challenge: log in as `bushranger102` to find `bushranger103`'s flag, then use it to SSH in as `bushranger103` which will have it's own `secret.flag`.

---

## Summary

- `echo "text" | md5sum | cut -d " " -f1` generates a clean MD5 hash — a solid way to create reproducible flags
- Pipelines (`|`) chain commands so each one's output feeds the next's input
- `cut -d " " -f1` splits on a delimiter and extracts a specific field
- `chmod u=rw,g=r,o=` uses `=` to set permissions precisely rather than adding/removing incrementally
- A well-designed CTF level uses layered permissions: the directory controls entry, the file controls reading
- The player must satisfy **both** the directory permission and the file permission to read a flag
- `sudo userdel -r username` removes a user and their home directory cleanly