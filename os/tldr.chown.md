# tldr: chown

## Description

Changes the user owner and/or group owner of a file or directory. You need `sudo` to change ownership of files you don't own. Ownership and permissions work together — ownership determines *which* permission row (user/group/others) applies to you.

---

## Simple Examples

```bash
# Change just the user owner
sudo chown admin_user secret.flag

# Change both user owner and group owner
sudo chown admin_user:bushranger101 secret.flag

# Change only the group owner (note the colon with nothing before it)
sudo chown :bushranger101 secret.flag

# Change user owner and set group to match (trailing colon, no group name)
sudo chown admin_user: secret.flag

# Change ownership recursively (directory and everything inside)
sudo chown -R admin_user:bushranger101 /home/bushranger101/

# Change ownership of a symlink itself (not the file it points to)
sudo chown -h admin_user symlink_name
```

---

## Composite Example

Setting up a wargame directory where the admin owns all the files but the player group can read them:

```bash
# Take ownership of the directory
sudo chown admin_user:bushranger101 /home/bushranger101

# Take ownership of the flag and config files
sudo chown admin_user:bushranger101 /home/bushranger101/secret.flag
sudo chown admin_user:bushranger101 /home/bushranger101/.bash*

# Verify everything
ls -la /home/bushranger101/
```

```
drwxr-x--- 2 admin_user    bushranger101 4096 Jan 01 .
-rw-r----- 1 admin_user    bushranger101   33 Jan 01 secret.flag
-rw-r----- 1 admin_user    bushranger101  220 Jan 01 .bash_logout
```

---

## Notes for Students

- `chown` changes **who owns** a file. `chmod` changes **what they're allowed to do** with it. You need both to fully control access.
- The format `user:group` is the most common. Remember: user first, then colon, then group.
- You can read ownership in `ls -la` output — the third column is the user owner, the fourth is the group owner.
- `chown -R` (recursive) is powerful and dangerous — double-check your path before running it. Accidentally chowning `/` as root will ruin your day.
- Changing ownership of `.bash*` files to your admin account (rather than leaving them owned by the player) means the player can read their shell config but can't modify it — useful for wargames where you don't want players backdooring their own environment.
