# tldr: whoami

## Description

Prints the username of the currently active user. One word, zero arguments, instant output. Sounds trivial but becomes essential when you're switching between accounts, using `sudo`, or debugging permission issues and need to confirm who the system thinks you are right now.

---

## Simple Example

```bash
whoami
# admin_user

sudo whoami
# root
```

---

## Composite Example

Confirming identity before and after switching users:

```bash
whoami
# admin_user

su - bushranger101
whoami
# bushranger101

exit
whoami
# admin_user
```

Verifying that `sudo` escalates to root:

```bash
whoami
# admin_user

sudo whoami
# root
```

---

## Notes for Students

- Run `whoami` any time you're unsure which account is active. This is especially important after switching users with `su` or connecting via SSH — the wrong user running the wrong command can cause real damage.
- `sudo whoami` returning `root` confirms your `sudo` access is working correctly.
- In a CTF or wargame, `whoami` is usually the first command a player runs after logging in to a new level — it confirms they're in the right account and their exploit or credential worked.
- `id` is a more detailed version of `whoami` — it shows your UID, GID, and all the groups you belong to. Useful when debugging permission issues where group membership matters.
