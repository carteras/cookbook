# tldr: userdel

## Description

Removes a user account from the system. By default it only removes the account entry — the home directory and files are left behind. The `-r` flag cleans everything up.

---

## Simple Examples

```bash
# Remove the account but leave the home directory behind
sudo userdel bushranger101

# Remove the account AND delete their home directory and mail spool
sudo userdel -r bushranger101
```

---

## Composite Example

Creating a temporary test account, using it, then cleaning it up completely:

```bash
sudo useradd -m outsider
sudo su - outsider
# ... test something ...
exit
sudo userdel -r outsider
```

Verify it's gone:

```bash
ls /home
# outsider directory is no longer there

cat /etc/passwd | grep outsider
# no output — account is gone
```

---

## Notes for Students

- **Always use `-r`** unless you have a specific reason to keep the files. Orphaned home directories with no owner are a security and housekeeping problem.
- If the user is currently logged in, `userdel` will refuse to remove them. You'd need to kill their session first.
- Any files that user owned **outside** their home directory (e.g. in `/tmp` or `/var`) are left behind with their old UID number as owner. Something to be aware of on production systems.
- The counterpart to `useradd` — you'll use these two together whenever you're managing challenge accounts.
