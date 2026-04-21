# Fedora Server: Creating Subdirectories with `mkdir`

This tutorial builds on the previous three. The only new concepts covered here are introducing a second CLI argument for a subdirectory name, creating that directory with `mkdir -p`, and placing `secret.flag` inside it.

---

## What Changed

| Variable | Before | After |
|----------|--------|-------|
| `TEST_USER` | `"${1:-bashuser4}"` | unchanged |
| `TEST_PASS` | `"${1:-bashuser4}"` | unchanged |
| `SECRET_DIR` | *(did not exist)* | `"${2:-inhere}"` |
| `secret.flag` location | `/home/$TEST_USER/` | `/home/$TEST_USER/$SECRET_DIR/` |

---

## The New Variable

```bash
SECRET_DIR="${2:-inhere}"
```

Same `${var:-default}` pattern from the previous tutorial, applied to `$2` — the second CLI argument. If omitted, it falls back to `inhere`.

| Invocation | `$1` | `$2` | Result |
|------------|------|------|--------|
| `sudo ./setup_user.sh` | *(empty)* | *(empty)* | user=`bashuser4`, dir=`inhere` |
| `sudo ./setup_user.sh bashuser4` | `bashuser4` | *(empty)* | user=`bashuser4`, dir=`inhere` |
| `sudo ./setup_user.sh bashuser4 vault` | `bashuser4` | `vault` | user=`bashuser4`, dir=`vault` |

---

## Creating the Directory: `mkdir -p`

```bash
mkdir -p "${USER_HOME}/${SECRET_DIR}"
```

- `mkdir` — makes a directory
- `-p` — two behaviours in one flag:
  - Creates any missing **parent directories** in the path
  - **Does not error** if the directory already exists

Without `-p`, running the script twice would fail because the directory would already be there. With `-p`, it's safe to run repeatedly.

---

## Setting Ownership and Permissions on the Directory

The directory itself needs the same ownership and permission treatment as the files inside it:

```bash
chown "${MASTER_USER}:${TEST_USER}" "${USER_HOME}/${SECRET_DIR}"
chmod 750 "${USER_HOME}/${SECRET_DIR}"
```

`750` gives the directory `u=rwx,g=rx,o=` :

| Who | Symbolic | Octal | Why |
|-----|----------|-------|-----|
| User (`masteradmin`) | `rwx` | 7 | Full control |
| Group (`testuser`) | `r-x` | 5 | Can enter and list contents |
| Others | `---` | 0 | No access |

> A directory needs the **execute** (`x`) bit to be *entered* (`cd`) or to have its contents accessed — read (`r`) alone only lets you list filenames. That is why the directory uses `750` rather than `640`.

---

## Updated `secret.flag` Path

The only other change is the destination path when writing the flag:

```bash
# Before
echo "${FLAG_MD5}" > "${USER_HOME}/secret.flag"
chown "${MASTER_USER}:${TEST_USER}" "${USER_HOME}/secret.flag"
chmod 640 "${USER_HOME}/secret.flag"

# After
echo "${FLAG_MD5}" > "${USER_HOME}/${SECRET_DIR}/secret.flag"
chown "${MASTER_USER}:${TEST_USER}" "${USER_HOME}/${SECRET_DIR}/secret.flag"
chmod 640 "${USER_HOME}/${SECRET_DIR}/secret.flag"
```

---

## Updated Configuration Block

```bash
# -----------------------------------------------------------------------------
# Configuration — both arguments are optional, fall back to defaults
# -----------------------------------------------------------------------------
MASTER_USER="masteradmin"
TEST_USER="${1:-bashuser4}"
TEST_PASS="${1:-bashuser4}"
SECRET_DIR="${2:-inhere}"
FLAG_PLAINTEXT="supersecretflagvalue"
```

---

## The Updated Script

```bash
#!/usr/bin/env bash
# =============================================================================
# setup_user.sh
# Creates a user account and configures home directory file ownership/permissions.
# Run as root or with sudo.
#
# Usage:
#   sudo ./setup_user.sh                        # user=bashuser4, dir=inhere
#   sudo ./setup_user.sh <username>             # user=<username>, dir=inhere
#   sudo ./setup_user.sh <username> <dir>       # user=<username>, dir=<dir>
# =============================================================================

set -euo pipefail

# -----------------------------------------------------------------------------
# Configuration — both arguments are optional, fall back to defaults
# -----------------------------------------------------------------------------
MASTER_USER="masteradmin"
TEST_USER="${1:-bashuser4}"
TEST_PASS="${1:-bashuser4}"
SECRET_DIR="${2:-inhere}"
FLAG_PLAINTEXT="supersecretflagvalue"

# -----------------------------------------------------------------------------
# Derived values
# -----------------------------------------------------------------------------
FLAG_MD5=$(echo -n "$FLAG_PLAINTEXT" | md5sum | awk '{ print $1 }')
USER_HOME="/home/${TEST_USER}"
SECRET_PATH="${USER_HOME}/${SECRET_DIR}"

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
# 4. Create the subdirectory for secret.flag
# -----------------------------------------------------------------------------
echo "[*] Creating directory: ${SECRET_PATH}"

mkdir -p "${SECRET_PATH}"
chown "${MASTER_USER}:${TEST_USER}" "${SECRET_PATH}"
chmod 750 "${SECRET_PATH}"

# -----------------------------------------------------------------------------
# 5. Create secret.flag with the MD5 hash of the flag
# -----------------------------------------------------------------------------
echo "[*] Creating ${SECRET_PATH}/secret.flag"

echo "${FLAG_MD5}" > "${SECRET_PATH}/secret.flag"
chown "${MASTER_USER}:${TEST_USER}" "${SECRET_PATH}/secret.flag"
chmod 640 "${SECRET_PATH}/secret.flag"

echo "    MD5 hash written: ${FLAG_MD5}"

# -----------------------------------------------------------------------------
# Done
# -----------------------------------------------------------------------------
echo ""
echo "[+] Setup complete."
echo "    Test user   : ${TEST_USER}"
echo "    Master user : ${MASTER_USER}"
echo "    Secret dir  : ${SECRET_PATH}"
echo "    Flag (MD5)  : ${FLAG_MD5}"
```

---

## Running the Script

```bash
# All defaults — creates bashuser4, dir=inhere
sudo ./setup_user.sh

# Custom user, default dir
sudo ./setup_user.sh bashuser4

# Custom user and custom dir
sudo ./setup_user.sh bashuser4 vault
```

---

## Verifying the Result

```bash
# Confirm directory ownership and permissions
ls -la /home/bashuser4/

# Confirm secret.flag is inside the subdirectory
ls -la /home/bashuser4/inhere/

# Read the flag
sudo -u bashuser4 cat /home/bashuser4/inhere/secret.flag
```

### Expected `ls -la` Output

```
drwxr-x--- 1 masteradmin bashuser4   /home/bashuser4/inhere/
-rw-r----- 1 masteradmin bashuser4   /home/bashuser4/inhere/secret.flag
```

---

## Summary

| Concept | Syntax |
|---------|--------|
| Second CLI argument with default | `"${2:-inhere}"` |
| Create a directory (safely, repeatedly) | `mkdir -p /path/to/dir` |
| Directory permissions (`u=rwx,g=rx,o=`) | `chmod 750` |
| Why directories need `x` not just `r` | `x` allows entering/traversing; `r` alone only lists names |
| Store derived path in a variable | `SECRET_PATH="${USER_HOME}/${SECRET_DIR}"` |