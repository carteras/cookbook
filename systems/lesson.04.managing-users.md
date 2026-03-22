# Lesson 4: Managing Users — Setting a Password

## Concept

Creating a user with `useradd` doesn't give them a password. Until a password is set, the account is **locked** — the user literally cannot log in.

As an administrator, you use the `passwd` command to set or change passwords for any user on the system.

## Goals

- Set a password for a newly created user
- Understand where passwords are actually stored

## At the End of This Lesson You Will Be Able To

- Use `passwd` to set or change a user's password
- Explain the difference between `/etc/passwd` and `/etc/shadow`

## Glossary

| Command / Term | Meaning |
|----------------|---------|
| `passwd` | Changes a user's password |
| `sudo passwd username` | Changes another user's password (requires sudo) |
| `/etc/shadow` | Where encrypted passwords are actually stored (not `/etc/passwd`) |
| **Locked account** | A user account with no password — cannot be logged into |

---

## Background: Where Are Passwords Stored?

You might expect passwords to be in `/etc/passwd` — but they're not. That file has an `x` in the password field for every user.

The real (encrypted) passwords are in `/etc/shadow`:

```bash
sudo cat /etc/shadow | grep notadam
```

Before setting a password, you'll see something like:

```
notadam:!:19845:0:99999:7:::
```

The `!` means the account is **locked** (no password set). After setting a password, it will be replaced with a long encrypted hash.

> 🔒 Only `root` (or `sudo`) can read `/etc/shadow`. This is intentional — it prevents regular users from trying to crack each other's passwords.

---

## Instructions

### Step 1 — Set the Password

Use `passwd` with `sudo` to set a password for `notadam`:

```bash
sudo passwd notadam
```

You'll be prompted twice:

```
New password:
Retype new password:
passwd: password updated successfully
```

> ⚠️ **Password rules for the real world:**
> - At least 12 characters
> - Mix of uppercase, lowercase, numbers, and symbols
> - Don't use names, dates, or dictionary words
>
> For classroom exercises, a simpler password is fine — but develop good habits.

### Step 2 — Verify the Password Is Set

```bash
sudo cat /etc/shadow | grep notadam
```

The `!` will now be replaced with a long encrypted string starting with `$6$` (SHA-512 hash) or `$y$` (yescrypt):

```
notadam:$y$j9T$...(long hash)...:19845:0:99999:7:::
```

### Step 3 — Test the Login

You can switch to the new user to verify:

```bash
su - notadam
```

You'll be prompted for `notadam`'s password. Enter it and you should see the prompt change:

```bash
[notadam@fedora-server ~]$
```

Type `exit` to return to your own account:

```bash
exit
```

---

## Changing Your Own Password

Any user can change their **own** password without `sudo`:

```bash
passwd
```

You'll be asked for your current password first (to prove it's really you), then your new password twice.

---

## Summary

- New user accounts are locked until a password is set
- `sudo passwd username` sets a password for any user
- Passwords are stored encrypted in `/etc/shadow`, not in `/etc/passwd`
- Use `su - username` to switch to another user and test their login