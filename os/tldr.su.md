# tldr: su

## Description

Switches to another user account within the current terminal session. Short for "substitute user" (not "super user" — that's a common misconception). With `-` (or `-l`) it simulates a full login as that user, including their environment and home directory. Without `-` it switches the user but keeps your current environment.

---

## Simple Examples

```bash
# Switch to another user (prompts for their password)
su bushranger101

# Switch with a full login environment (starts fresh, like SSH-ing in as them)
su - bushranger101

# Switch to root (prompts for root's password)
su -

# Run a single command as another user, then return
su - bushranger101 -c "cat ~/secret.flag"

# Switch using sudo (no password for the target user needed)
sudo su - bushranger101
```

---

## Composite Example

Testing whether a wargame player can read their flag but not modify it:

```bash
# As admin_user, switch to the player account
su - bushranger101
# Password: (bushranger101's password)

# Confirm who we are
whoami
# bushranger101

# Try to read the flag (should work — group has r)
cat ~/secret.flag
# a43c1b0aa53a0c908810c06ab1ff3967

# Try to modify the flag (should fail — group only has r, not w)
echo "cheating" > ~/secret.flag
# bash: /home/bushranger101/secret.flag: Permission denied

# Return to admin_user
exit
whoami
# admin_user
```

---

## Notes for Students

- **Always use `su -` (with the dash)** when testing another user's environment. Without `-`, environment variables like `$HOME` and `$PATH` don't switch — you'll be user `bushranger101` but still looking at admin's home directory, which causes confusing results.
- `exit` (or Ctrl+D) returns you to the previous user's session.
- `su` requires the **target user's password**. `sudo su - username` uses **your** sudo password instead — useful when you're an admin and don't know (or haven't set) the target user's password yet.
- In wargames, `su - playername` is the fundamental way to test your own challenges before handing them to students. Always verify as the player that you can read the flag and can't modify it.
- `whoami` is your best friend when switching users — always confirm who you are before running commands, especially destructive ones.
