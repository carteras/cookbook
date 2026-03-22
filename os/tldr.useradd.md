# tldr: useradd

## Description

Creates a new user account on the system. On its own it creates the account entry in `/etc/passwd` but doesn't set a password or create a home folder unless you tell it to. You'll almost always want the `-m` flag.

---

## Simple Examples

```bash
# Create a user (no home directory — rarely what you want)
sudo useradd bushranger101

# Create a user WITH a home directory
sudo useradd -m bushranger101

# Create a user with a specific shell
sudo useradd -m -s /bin/bash bushranger101

# Create a user and add them to an existing group at the same time
sudo useradd -m -G wheel bushranger101
```

---

## Composite Example

Creating a wargame player account from scratch, then verifying they exist:

```bash
sudo useradd -m bushranger101
sudo passwd bushranger101
cat /etc/passwd | grep bushranger101
```

```
bushranger101:x:1003:1003::/home/bushranger101:/bin/bash
```

---

## Notes for Students

- **Always use `-m`** when creating real user accounts. Without it, the user has no home directory and their shell will dump them in `/` on login — confusing for everyone.
- The user account is created **locked** (no password) until you run `passwd`. They can't log in until then.
- `useradd` is the low-level tool. On some distros you'll see `adduser` instead, which is a friendlier interactive wrapper around `useradd`. On Fedora, `useradd` is the standard.
- To **remove** a user and their home directory when you're done: `sudo userdel -r bushranger101`
