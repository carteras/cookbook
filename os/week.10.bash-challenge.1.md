# Fedora Server: Automated User Setup with Secured Home Directory Files

This tutorial walks through a Bash script that creates a user account on a Fedora server, then configures ownership and permissions on key files in that user's home directory — including a `secret.flag` file containing an MD5-hashed value.

---

## Prerequisites

- Your fedora VM
- Basic familiarity with the terminal

---

## The Script

```bash
#!/usr/bin/env bash
# =============================================================================
# setup_user.sh
# Creates a test user and configures home directory file ownership/permissions.
# Run as root or with sudo.
# =============================================================================

set -euo pipefail

# -----------------------------------------------------------------------------
# Hardcoded configuration
# -----------------------------------------------------------------------------
MASTER_USER="masteradmin"
TEST_USER="bashuser1"
TEST_PASS="bashuser1"
FLAG_PLAINTEXT="supersecretflagvalue"

# -----------------------------------------------------------------------------
# Derived values
# -----------------------------------------------------------------------------
FLAG_MD5=$(echo -n "$FLAG_PLAINTEXT" | md5sum | awk '{ print $1 }')
USER_HOME="/home/${TEST_USER}"

# -----------------------------------------------------------------------------
# 1. Create the test user account
# -----------------------------------------------------------------------------
echo "[*] Creating user: ${TEST_USER}"

if id "${TEST_USER}" &>/dev/null; then
    echo "    User '${TEST_USER}' already exists — skipping creation."
else
    useradd --create-home --shell /bin/bash "${TEST_USER}"
    echo "${TEST_USER}:${TEST_PASS}" | chpasswd
    echo "    User '${TEST_USER}' created successfully."
fi

# -----------------------------------------------------------------------------
# 2. Set ownership of all .bash* files to master_user:test_user
# -----------------------------------------------------------------------------
echo "[*] Setting ownership of .bash* files to ${MASTER_USER}:${TEST_USER}"

chown "${MASTER_USER}:${TEST_USER}" "${USER_HOME}"/.bash* 2>/dev/null || true

# -----------------------------------------------------------------------------
# 3. Set permissions on all .bash* files  (u=rw, g=r, o=)
# -----------------------------------------------------------------------------
echo "[*] Setting permissions on .bash* files (640)"

chmod 640 "${USER_HOME}"/.bash* 2>/dev/null || true

# -----------------------------------------------------------------------------
# 4. Create secret.flag with the MD5 hash of the flag
# -----------------------------------------------------------------------------
echo "[*] Creating ${USER_HOME}/secret.flag"

echo "${FLAG_MD5}" > "${USER_HOME}/secret.flag"
chown "${MASTER_USER}:${TEST_USER}" "${USER_HOME}/secret.flag"
chmod 640 "${USER_HOME}/secret.flag"

echo "    MD5 hash written: ${FLAG_MD5}"

# -----------------------------------------------------------------------------
# Done
# -----------------------------------------------------------------------------
echo ""
echo "[+] Setup complete."
echo "    Test user   : ${TEST_USER}"
echo "    Master user : ${MASTER_USER}"
echo "    Home dir    : ${USER_HOME}"
echo "    Flag (MD5)  : ${FLAG_MD5}"
```

---

## Script Walkthrough

### Shebang & Safety Flags

```bash
#!/usr/bin/env bash
set -euo pipefail
```

| Flag | Effect |
|------|--------|
| `-e` | Exit immediately if any command returns a non-zero status |
| `-u` | Treat unset variables as errors |
| `-o pipefail` | A pipeline fails if *any* command in it fails (not just the last) |

---

### Hardcoded Configuration

```bash
MASTER_USER="masteradmin"
TEST_USER="bashuser1"
TEST_PASS="bashuser1"
FLAG_PLAINTEXT="supersecretflagvalue"
```

These four variables are the only values you need to change to adapt this script to your environment.

> ⚠️ **Note:** Hardcoding passwords in scripts is convenient for labs and tutorials but should **never** be done in production. Consider tools like [Vault](https://www.vaultproject.io/) or environment variables sourced from a secrets manager for real deployments.

---

### Generating the MD5 Hash

```bash
FLAG_MD5=$(echo -n "$FLAG_PLAINTEXT" | md5sum | awk '{ print $1 }')
```

- `echo -n` — prints the string *without* a trailing newline, ensuring the hash is of the value itself and not `value\n`
- `md5sum` — outputs `<hash>  -`
- `awk '{ print $1 }'` — strips the trailing `  -`, leaving just the hex digest

---

### Creating the User Account

```bash
useradd --create-home --shell /bin/bash "${TEST_USER}"
echo "${TEST_USER}:${TEST_PASS}" | chpasswd
```

- `--create-home` — creates `/home/bashuser1` and populates it with skeleton files (including `.bash_profile`, `.bashrc`, `.bash_logout`)
- `--shell /bin/bash` — assigns Bash as the login shell
- `chpasswd` — reads `user:password` pairs from stdin and sets them non-interactively

The `if id ...` guard prevents errors if the script is run more than once.

---

### Ownership: `.bash*` Files

```bash
chown "${MASTER_USER}:${TEST_USER}" "${USER_HOME}"/.bash*
```

This sets:

| Field | Value |
|-------|-------|
| **User (owner)** | `masteradmin` |
| **Group** | `bashuser1` |

Files typically matched by `.bash*`:

- `.bash_logout`
- `.bash_profile`
- `.bashrc`

---

### Permissions: `.bash*` Files

```bash
chmod 640 "${USER_HOME}"/.bash*
```

`640` maps to `u=rw,g=r,o=`:

| Who | Symbolic | Octal |
|-----|----------|-------|
| User (masteradmin) | `rw-` | 6 |
| Group (bashuser1) | `r--` | 4 |
| Others | `---` | 0 |

> The `bashuser1` can read (but not write) their own `.bashrc` and friends because they are a member of the `bashuser1` group.

---

### Creating `secret.flag`

```bash
echo "${FLAG_MD5}" > "${USER_HOME}/secret.flag"
chown "${MASTER_USER}:${TEST_USER}" "${USER_HOME}/secret.flag"
chmod 640 "${USER_HOME}/secret.flag"
```

The same ownership and permission model is applied to `secret.flag`:

- Only `masteradmin` (the owner) can **read or write** the file
- `bashuser1` (via group membership) can **read** the file
- Everyone else has **no access**

---

## Running the Script

```bash
# Save the script
sudo nano /usr/local/sbin/setup_user.sh

# Make it executable
sudo chmod +x /usr/local/sbin/setup_user.sh

# Run it as root
sudo /usr/local/sbin/setup_user.sh
```

### Expected Output

```
[*] Creating user: bashuser1
    User 'bashuser1' created successfully.
[*] Setting ownership of .bash* files to masteradmin:bashuser1
[*] Setting permissions on .bash* files (640)
[*] Creating /home/bashuser1/secret.flag
    MD5 hash written: a1b2c3d4e5f6...

[+] Setup complete.
    Test user   : bashuser1
    Master user : masteradmin
    Home dir    : /home/bashuser1
    Flag (MD5)  : a1b2c3d4e5f6...
```

---

## Verifying the Result

```bash
# Check the user exists
id bashuser1

# List home directory with ownership and permissions
ls -la /home/bashuser1/.bash* /home/bashuser1/secret.flag

# Read the flag (as masteradmin or bashuser1)
sudo -u bashuser1 cat /home/bashuser1/secret.flag
```

### Expected `ls -la` Output

```
-rw-r----- 1 masteradmin bashuser1  18 Apr 20 10:00 /home/bashuser1/.bash_logout
-rw-r----- 1 masteradmin bashuser1 141 Apr 20 10:00 /home/bashuser1/.bash_profile
-rw-r----- 1 masteradmin bashuser1 376 Apr 20 10:00 /home/bashuser1/.bashrc
-rw-r----- 1 masteradmin bashuser1  33 Apr 20 10:00 /home/bashuser1/secret.flag
```

---

## Summary

| Task | Command Used |
|------|-------------|
| Create user with home dir | `useradd --create-home` |
| Set password non-interactively | `chpasswd` |
| Generate MD5 hash of a string | `echo -n \| md5sum \| awk` |
| Set file owner and group | `chown owner:group` |
| Set `u=rw,g=r,o=` permissions | `chmod 640` |
| Write content to a file | `echo "..." > file` |