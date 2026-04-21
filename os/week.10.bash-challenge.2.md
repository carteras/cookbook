# Fedora Server: Passing User Credentials via CLI Arguments

This tutorial builds directly on the previous script. The only new concept covered here is replacing the hardcoded `TEST_USER` and `TEST_PASS` values with a single CLI argument — the username — and using that same value as the password.

---

## What Changed

| Variable | Before | After |
|----------|--------|-------|
| `TEST_USER` | `"bashuser2"` (hardcoded) | `"$1"` (CLI argument) |
| `TEST_PASS` | `"bashuser2"` (hardcoded) | `"$1"` (same value) |
| `MASTER_USER` | `"masteradmin"` | unchanged |
| `FLAG_PLAINTEXT` | `"supersecretflagvalue"` | unchanged |

---

## Positional Parameters

In Bash, arguments passed to a script on the command line are available as **positional parameters**:

| Variable | Meaning |
|----------|---------|
| `$0` | The script name itself |
| `$1` | The first argument |
| `$2` | The second argument |
| `$#` | The total number of arguments provided |

So when you run:

```bash
sudo ./setup_user.sh bashuser2
```

Inside the script, `$1` equals `bashuser2`.

---

## Validating That an Argument Was Provided

Before using `$1`, the script checks that it was actually supplied. If not, it prints a usage message and exits cleanly with code `1`:

```bash
if [[ $# -lt 1 ]]; then
    echo "Usage: $0 <username>"
    exit 1
fi
```

- `$#` — the count of arguments passed
- `-lt 1` — "less than 1", i.e. no arguments were given
- `$0` — the script name, used in the usage message so it stays accurate if the file is renamed
- `exit 1` — a non-zero exit code signals failure to the calling shell

---

## Updated Configuration Block

Replace the old hardcoded lines with:

```bash
# -----------------------------------------------------------------------------
# Validate argument
# -----------------------------------------------------------------------------
if [[ $# -lt 1 ]]; then
    echo "Usage: $0 <username>"
    exit 1
fi

# -----------------------------------------------------------------------------
# Hardcoded configuration
# -----------------------------------------------------------------------------
MASTER_USER="masteradmin"
TEST_USER="$1"
TEST_PASS="$1"
FLAG_PLAINTEXT="supersecretflagvalue"
```

Everything below this block — user creation, ownership, permissions, `secret.flag` — remains exactly as before.

---

## The Updated Script

```bash
#!/usr/bin/env bash
# =============================================================================
# setup_user.sh
# Creates a user account and configures home directory file ownership/permissions.
# Run as root or with sudo.
#
# Usage: sudo ./setup_user.sh <username>
# =============================================================================

set -euo pipefail

# -----------------------------------------------------------------------------
# Validate argument
# -----------------------------------------------------------------------------
if [[ $# -lt 1 ]]; then
    echo "Usage: $0 <username>"
    exit 1
fi

# -----------------------------------------------------------------------------
# Hardcoded configuration
# -----------------------------------------------------------------------------
MASTER_USER="masteradmin"
TEST_USER="$1"
TEST_PASS="$1"
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

## Running the Script

```bash
# Make it executable (if not already)
sudo chmod +x setup_user.sh

# Create a user — argument becomes both username and password
sudo ./setup_user.sh bashuser2
```

### Missing Argument — Expected Output

```
Usage: ./setup_user.sh <username>
```

### Successful Run — Expected Output

```
[*] Creating user: bashuser2
    User 'bashuser2' created successfully.
[*] Setting ownership of .bash* files to masteradmin:bashuser2
[*] Setting permissions on .bash* files (640)
[*] Creating /home/bashuser2/secret.flag
    MD5 hash written: a1b2c3d4e5f6...

[+] Setup complete.
    Test user   : bashuser2
    Master user : masteradmin
    Home dir    : /home/bashuser2
    Flag (MD5)  : a1b2c3d4e5f6...
```

---

## Summary

| Concept | Syntax |
|---------|--------|
| Read first CLI argument | `$1` |
| Count of arguments provided | `$#` |
| Script name (for usage messages) | `$0` |
| Guard against missing arguments | `if [[ $# -lt 1 ]]; then ... exit 1; fi` |
| Username and password from one arg | `TEST_USER="$1"` and `TEST_PASS="$1"` |