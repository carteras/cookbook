# tldr: passwd

## Description

Sets or changes a user's password. Any user can change their own password. Only root (or a `sudo` user) can change someone else's password. Passwords are stored encrypted in `/etc/shadow` — never in plain text.

---

## Simple Examples

```bash
# Change YOUR OWN password (no sudo needed)
passwd

# Set or change another user's password (requires sudo)
sudo passwd bushranger101

# Lock an account so it cannot be logged into
sudo passwd -l bushranger101

# Unlock a previously locked account
sudo passwd -u bushranger101

# Force a user to change their password on next login
sudo passwd -e bushranger101
```

---

## Composite Example

Creating a new user and immediately setting their password so they can log in:

```bash
sudo useradd -m bushranger101
sudo passwd bushranger101
```

```
New password:
Retype new password:
passwd: password updated successfully
```

Then verify the account is no longer locked:

```bash
sudo passwd -S bushranger101
```

```
bushranger101 PS 2024-01-01 0 99999 7 -1 (Password set, SHA512 crypt.)
```

`PS` means "Password Set" — the account is active and usable.

---

## Notes for Students

- When you type a password at the prompt, **nothing appears on screen** — no dots, no asterisks. That's intentional. Just type it and press Enter.
- `passwd` (no arguments) changes **your own** password. You must type your current password first as verification.
- `sudo passwd username` changes **someone else's** password. You're not asked for their current password — only your own sudo password.
- New accounts created with `useradd` have a `!` in `/etc/shadow` meaning locked. Running `passwd` replaces that `!` with an encrypted hash, unlocking the account.
- On a wargame server, set the player's password to something they'll need to discover — the whole challenge is proving they found it.
