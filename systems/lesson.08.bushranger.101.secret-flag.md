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
├── secret.flag         ← The flag file
│   ├── owner:  your_username    (your admin account) — can read and write
│   ├── group:  bushranger101 (the player's account) — can read only
│   └── others:         — no access at all
│
├── .bashrc, .bash_logout, .bash_profile
│   ├── owner:  bushranger101 — can read and write
│   ├── group:  bushranger101 — can read only
│   └── others:         — no access at all
│
└── (the directory itself)
    ├── owner:  adam    — can read, write, and enter
    ├── group:  bushranger101 — can read and enter (but not create/delete files)
    └── others:         — no access at all
```

The player (`bushranger101`) can enter their own home directory and read the flag — but can't modify it. Your admin account (`adam`) owns and controls everything.

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
adam  bushranger101
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
1c629e9f1e8b7dd35dc99abf200ef56c  -
```

The `-` means "input came from stdin, not a file". We don't want that in our flag.

**Stage 3: `| cut -d " " -f1`**

`cut` splits each line by a delimiter (`-d " "` means split on spaces) and returns only the specified field (`-f1` means field 1 — the first part). This strips the ` -` from the end:

```bash
echo "my_flag" | md5sum | cut -d " " -f1
```
```
1c629e9f1e8b7dd35dc99abf200ef56c
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
1c629e9f1e8b7dd35dc99abf200ef56c
```

> 💡 **Tip for building real wargames:** Change `"my_flag"` to something secret that only you know — a phrase, a random string, anything. The MD5 hash is what the player finds; they don't need to know what you hashed to produce it. You can always regenerate the same hash by running the same `echo` again.

Check the file's current ownership and permissions:

```bash
ls -la /home/bushranger101/
```

```
total 24
drwx------ 2 bushranger101 bushranger101 4096 Jan 01 11:00 .
drwxr-xr-x 5 root    root    4096 Jan 01 11:00 ..
-rw-r--r-- 1 bushranger101 bushranger101  220 Jan 01 11:00 .bash_logout
-rw-r--r-- 1 bushranger101 bushranger101 3526 Jan 01 11:00 .bashrc
-rw-r--r-- 1 bushranger101 bushranger101  141 Jan 01 11:00 .bash_profile
-rw-r--r-- 1 adam    adam      33 Jan 01 11:00 secret.flag
```

Right now everything is too open. We need to lock it all down.

---

### Step 3 — Own the Flag File Correctly

We want:
- **User owner**: `adam` (your wheel/admin account) — already the case since you created it
- **Group owner**: `bushranger101` — so the player can read it via group permissions

```bash
sudo chown adam:bushranger101 /home/bushranger101/secret.flag
```

Verify:

```bash
ls -la /home/bushranger101/ | grep secret
```

```
-rw-r--r-- 1 adam    bushranger101   33 Jan 01 11:00 secret.flag
```

Group is now `bushranger101`. Good. Permissions still need work — others can currently read it.

---

### Step 4 — Set Permissions on the Flag File

Target permission scheme for `secret.flag`:

```
-  rw-  r--  ---
│   │    │    │
│   │    │    └── Others:         no access
│   │    └─────── Group (bushranger101): read only
│   └──────────── User  (adam):    read and write
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
-rw-r----- 1 adam    bushranger101   33 Jan 01 11:00 secret.flag
```

---

### Step 5 — Lock Down the Bash Config Files

The `.bash*` files in the player's directory should be readable by the player and their group, but completely invisible to everyone else.

Target permission scheme for `.bashrc`, `.bash_logout`, `.bash_profile`:

```
-  rw-  r--  ---
│   │    │    │
│   │    │    └── Others:          no access
│   │    └─────── Group (bushranger101): read only
│   └──────────── User  (bushranger101): read and write
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
drwxr-xr-x 5 root    root    4096 Jan 01 11:00 ..
-rw-r----- 1 bushranger101 bushranger101  220 Jan 01 11:00 .bash_logout
-rw-r----- 1 bushranger101 bushranger101 3526 Jan 01 11:00 .bashrc
-rw-r----- 1 bushranger101 bushranger101  141 Jan 01 11:00 .bash_profile
-rw-r----- 1 adam    bushranger101   33 Jan 01 11:00 secret.flag
```

All files now have `rw-r-----`. 

---

### Step 6 — Set Permissions on the Home Directory Itself

The directory itself needs its own permission scheme. We want:

- `adam` to be the owner (so we can manage the contents)
- `bushranger101` group to be able to enter and list the directory
- Others to have no access at all

First, transfer ownership of the directory to `adam`, keeping `bushranger101` as the group:

```bash
sudo chown adam:bushranger101 /home/bushranger101
```

Now set the directory permissions:

Target permission scheme for `/home/bushranger101/`:

```
d  rwx  r-x  ---
│   │    │    │
│   │    │    └── Others:          no access
│   │    └─────── Group (bushranger101): read and enter (but can't create/delete)
│   └──────────── User  (adam):    full control
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
drwxr-xr-x  5 root  root    4096 Jan 01 11:00 .
drwxr-xr-x 23 root  root    4096 Jan 01 09:00 ..
drwx------  4 adam  adam    4096 Jan 01 09:30 adam
drwxr-x---  2 adam  bushranger101 4096 Jan 01 11:00 bushranger101
```

The directory now shows `drwxr-x---` with `adam:bushranger101` ownership.

---

### Step 7 — Verify the Full Setup

Let's do a complete review of what we've built:

```bash
ls -la /home/bushranger101/
```

```
total 24
drwxr-x--- 2 adam    bushranger101 4096 Jan 01 11:00 .
drwxr-xr-x 5 root    root    4096 Jan 01 11:00 ..
-rw-r----- 1 bushranger101 bushranger101  220 Jan 01 11:00 .bash_logout
-rw-r----- 1 bushranger101 bushranger101 3526 Jan 01 11:00 .bashrc
-rw-r----- 1 bushranger101 bushranger101  141 Jan 01 11:00 .bash_profile
-rw-r----- 1 adam    bushranger101   33 Jan 01 11:00 secret.flag
```

Check it against our target:

| File | Owner | Group | Permissions | ✓ |
|------|-------|-------|-------------|---|
| `/home/bushranger101` (dir) | adam | bushranger101 | `rwxr-x---` | ✓ |
| `secret.flag` | adam | bushranger101 | `rw-r-----` | ✓ |
| `.bashrc` | bushranger101 | bushranger101 | `rw-r-----` | ✓ |
| `.bash_logout` | bushranger101 | bushranger101 | `rw-r-----` | ✓ |
| `.bash_profile` | bushranger101 | bushranger101 | `rw-r-----` | ✓ |

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
1c629e9f1e8b7dd35dc99abf200ef56c
```

The player can read the flag. Now try to modify it:

```bash
echo "cheating" > ~/secret.flag
```

```
bash: /home/bushranger101/secret.flag: Permission denied
```

And try to access another user's home directory:

```bash
ls /home/adam
```

```
ls: cannot open directory '/home/adam': Permission denied
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

# 3. Set flag ownership: admin owns it, bushranger101 group can read
sudo chown adam:bushranger101 /home/bushranger101/secret.flag

# 4. Set flag permissions: admin rw, bushranger101 group r, others nothing
sudo chmod u=rw,g=r,o= /home/bushranger101/secret.flag

# 5. Lock down bash config files: bushranger101 rw, group r, others nothing
sudo chmod u=rw,g=r,o= /home/bushranger101/.bash*

# 6. Give admin ownership of the directory, keep bushranger101 as group
sudo chown adam:bushranger101 /home/bushranger101

# 7. Set directory permissions: admin rwx, bushranger101 group rx, others nothing
sudo chmod u=rwx,g=rx,o= /home/bushranger101
```

---

## Summary

- `echo "text" | md5sum | cut -d " " -f1` generates a clean MD5 hash — a solid way to create reproducible flags
- Pipelines (`|`) chain commands so each one's output feeds the next's input
- `cut -d " " -f1` splits on a delimiter and extracts a specific field
- `chmod u=rw,g=r,o=` uses `=` to set permissions precisely rather than adding/removing incrementally
- A well-designed CTF level uses layered permissions: the directory controls entry, the file controls reading
- The player must satisfy **both** the directory permission and the file permission to read a flag
- `sudo userdel -r username` removes a user and their home directory cleanly