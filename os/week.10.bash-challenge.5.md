# Fedora Server: Copying Files with `cp`

This tutorial builds on the previous four. The new concepts covered here are creating a fake flag file and using `cp` to place multiple copies of it — without a loop — alongside the real flag from the previous tutorial.

---

## What Changed

| Item | Before | After |
|------|--------|-------|
| `secret.flag` | Real flag (MD5 hash) | unchanged — still present |
| `secret.0.flag` | *(did not exist)* | fake flag |
| `secret.1.flag` | *(did not exist)* | fake flag |
| `secret.2.flag` | *(did not exist)* | fake flag |
| `secret.3.flag` | *(did not exist)* | **real flag** (MD5 hash) |
| `secret.4.flag` | *(did not exist)* | fake flag |
| `secret.5.flag` | *(did not exist)* | fake flag |

---

## Two New Variables

```bash
FAKE_FLAG="thisisnottheflag"
FAKE_FLAG_MD5=$(echo -n "$FAKE_FLAG" | md5sum | awk '{ print $1 }')
```

The fake flag follows the same MD5 pattern as the real one — the files look identical in structure, which is the point.

---

## Writing the Fake Flag Once, Then Copying

Rather than writing the same content six times, the approach here is:

1. Write the fake flag content to `secret.0.flag` once
2. Use `cp` to copy that file to the remaining fake flag positions

```bash
# Write the fake flag once
echo "${FAKE_FLAG_MD5}" > "${SECRET_PATH}/secret.0.flag"

# Copy it to the other fake positions
cp "${SECRET_PATH}/secret.0.flag" "${SECRET_PATH}/secret.1.flag"
cp "${SECRET_PATH}/secret.0.flag" "${SECRET_PATH}/secret.2.flag"
cp "${SECRET_PATH}/secret.0.flag" "${SECRET_PATH}/secret.4.flag"
cp "${SECRET_PATH}/secret.0.flag" "${SECRET_PATH}/secret.5.flag"
```

> Note: `secret.3.flag` is intentionally skipped here — it gets the real flag written to it separately in the next step.

---

## Writing the Real Flag to `secret.3.flag`

```bash
echo "${FLAG_MD5}" > "${SECRET_PATH}/secret.3.flag"
```

This is identical to how `secret.flag` was written in the previous tutorial — just a different destination filename.

---

## Applying Ownership and Permissions to All Six Files

Each file needs `chown` and `chmod` applied individually — no loop yet, so we repeat the pattern six times:

```bash
chown "${MASTER_USER}:${TEST_USER}" "${SECRET_PATH}/secret.0.flag"
chown "${MASTER_USER}:${TEST_USER}" "${SECRET_PATH}/secret.1.flag"
chown "${MASTER_USER}:${TEST_USER}" "${SECRET_PATH}/secret.2.flag"
chown "${MASTER_USER}:${TEST_USER}" "${SECRET_PATH}/secret.3.flag"
chown "${MASTER_USER}:${TEST_USER}" "${SECRET_PATH}/secret.4.flag"
chown "${MASTER_USER}:${TEST_USER}" "${SECRET_PATH}/secret.5.flag"

chmod 640 "${SECRET_PATH}/secret.0.flag"
chmod 640 "${SECRET_PATH}/secret.1.flag"
chmod 640 "${SECRET_PATH}/secret.2.flag"
chmod 640 "${SECRET_PATH}/secret.3.flag"
chmod 640 "${SECRET_PATH}/secret.4.flag"
chmod 640 "${SECRET_PATH}/secret.5.flag"
```

This repetition is intentional — it makes the next tutorial's introduction of loops feel earned.

---

## Updated Configuration Block

```bash
# -----------------------------------------------------------------------------
# Configuration — both arguments are optional, fall back to defaults
# -----------------------------------------------------------------------------
MASTER_USER="masteradmin"
TEST_USER="${1:-bashuser5}"
TEST_PASS="${1:-bashuser5}"
SECRET_DIR="${2:-inhere}"
FLAG_PLAINTEXT="supersecretflagvalue"
FAKE_FLAG="thisisnottheflag"
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
#   sudo ./setup_user.sh                        # user=bashuser5, dir=inhere
#   sudo ./setup_user.sh <username>             # user=<username>, dir=inhere
#   sudo ./setup_user.sh <username> <dir>       # user=<username>, dir=<dir>
# =============================================================================

set -euo pipefail

# -----------------------------------------------------------------------------
# Configuration — both arguments are optional, fall back to defaults
# -----------------------------------------------------------------------------
MASTER_USER="masteradmin"
TEST_USER="${1:-bashuser5}"
TEST_PASS="${1:-bashuser5}"
SECRET_DIR="${2:-inhere}"
FLAG_PLAINTEXT="supersecretflagvalue"
FAKE_FLAG="thisisnottheflag"

# -----------------------------------------------------------------------------
# Derived values
# -----------------------------------------------------------------------------
FLAG_MD5=$(echo -n "$FLAG_PLAINTEXT" | md5sum | awk '{ print $1 }')
FAKE_FLAG_MD5=$(echo -n "$FAKE_FLAG" | md5sum | awk '{ print $1 }')
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
# 4. Create the subdirectory for the flag files
# -----------------------------------------------------------------------------
echo "[*] Creating directory: ${SECRET_PATH}"

mkdir -p "${SECRET_PATH}"
chown "${MASTER_USER}:${TEST_USER}" "${SECRET_PATH}"
chmod 750 "${SECRET_PATH}"

# -----------------------------------------------------------------------------
# 5. Create secret.flag (real flag — from previous tutorial)
# -----------------------------------------------------------------------------
echo "[*] Creating ${SECRET_PATH}/secret.flag"

echo "${FLAG_MD5}" > "${SECRET_PATH}/secret.flag"
chown "${MASTER_USER}:${TEST_USER}" "${SECRET_PATH}/secret.flag"
chmod 640 "${SECRET_PATH}/secret.flag"

# -----------------------------------------------------------------------------
# 6. Write the fake flag once, copy to fake positions
# -----------------------------------------------------------------------------
echo "[*] Creating fake flag files (secret.0-2.flag, secret.4-5.flag)"

echo "${FAKE_FLAG_MD5}" > "${SECRET_PATH}/secret.0.flag"

cp "${SECRET_PATH}/secret.0.flag" "${SECRET_PATH}/secret.1.flag"
cp "${SECRET_PATH}/secret.0.flag" "${SECRET_PATH}/secret.2.flag"
cp "${SECRET_PATH}/secret.0.flag" "${SECRET_PATH}/secret.4.flag"
cp "${SECRET_PATH}/secret.0.flag" "${SECRET_PATH}/secret.5.flag"

# -----------------------------------------------------------------------------
# 7. Write the real flag to secret.3.flag
# -----------------------------------------------------------------------------
echo "[*] Creating real flag file (secret.3.flag)"

echo "${FLAG_MD5}" > "${SECRET_PATH}/secret.3.flag"

# -----------------------------------------------------------------------------
# 8. Set ownership and permissions on all six numbered flag files
# -----------------------------------------------------------------------------
echo "[*] Setting ownership and permissions on numbered flag files"

chown "${MASTER_USER}:${TEST_USER}" "${SECRET_PATH}/secret.0.flag"
chown "${MASTER_USER}:${TEST_USER}" "${SECRET_PATH}/secret.1.flag"
chown "${MASTER_USER}:${TEST_USER}" "${SECRET_PATH}/secret.2.flag"
chown "${MASTER_USER}:${TEST_USER}" "${SECRET_PATH}/secret.3.flag"
chown "${MASTER_USER}:${TEST_USER}" "${SECRET_PATH}/secret.4.flag"
chown "${MASTER_USER}:${TEST_USER}" "${SECRET_PATH}/secret.5.flag"

chmod 640 "${SECRET_PATH}/secret.0.flag"
chmod 640 "${SECRET_PATH}/secret.1.flag"
chmod 640 "${SECRET_PATH}/secret.2.flag"
chmod 640 "${SECRET_PATH}/secret.3.flag"
chmod 640 "${SECRET_PATH}/secret.4.flag"
chmod 640 "${SECRET_PATH}/secret.5.flag"

# -----------------------------------------------------------------------------
# Done
# -----------------------------------------------------------------------------
echo ""
echo "[+] Setup complete."
echo "    Test user   : ${TEST_USER}"
echo "    Master user : ${MASTER_USER}"
echo "    Secret dir  : ${SECRET_PATH}"
echo "    Real flag   : ${FLAG_MD5}  (secret.flag, secret.3.flag)"
echo "    Fake flag   : ${FAKE_FLAG_MD5}  (secret.0,1,2,4,5.flag)"
```

---

## Running the Script

```bash
# All defaults
sudo ./setup_user.sh

# Custom user, default dir
sudo ./setup_user.sh bashuser5

# Custom user and dir
sudo ./setup_user.sh bashuser5 vault
```

---

## Verifying the Result

```bash
# List all flag files
ls -la /home/bashuser5/inhere/

# Confirm the fake flags all match
md5sum /home/bashuser5/inhere/secret.{0,1,2,4,5}.flag

# Confirm the real flag differs
md5sum /home/bashuser5/inhere/secret.3.flag
md5sum /home/bashuser5/inhere/secret.flag
```

### Expected `ls -la` Output

```
-rw-r----- 1 masteradmin bashuser5  33 Apr 20 10:00 secret.0.flag
-rw-r----- 1 masteradmin bashuser5  33 Apr 20 10:00 secret.1.flag
-rw-r----- 1 masteradmin bashuser5  33 Apr 20 10:00 secret.2.flag
-rw-r----- 1 masteradmin bashuser5  33 Apr 20 10:00 secret.3.flag
-rw-r----- 1 masteradmin bashuser5  33 Apr 20 10:00 secret.4.flag
-rw-r----- 1 masteradmin bashuser5  33 Apr 20 10:00 secret.5.flag
-rw-r----- 1 masteradmin bashuser5  33 Apr 20 10:00 secret.flag
```

All files are indistinguishable by ownership, permissions, and size — only their content differs.

---

## Summary

| Concept | Syntax |
|---------|--------|
| Copy a file to a new name | `cp source destination` |
| Write fake content once, copy the rest | Write to `secret.0.flag`, `cp` to `1,2,4,5` |
| Write real content to a specific file | `echo "${FLAG_MD5}" > secret.3.flag` |
| `cp` does not preserve ownership | `chown` must still be applied to each copy |
| Repetition without a loop | Each file gets its own explicit `chown` and `chmod` line |