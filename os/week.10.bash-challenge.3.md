# Fedora Server: Default Values with `${var:-default}`

This tutorial builds on the previous two. The only new concept covered here is Bash **default value expansion** — a way to make `$1` optional by falling back to a hardcoded value when no argument is supplied.

---

## What Changed

| Variable | Before | After |
|----------|--------|-------|
| `TEST_USER` | `"$1"` (required arg, exits if missing) | `"${1:-bashuser3}"` (optional arg, falls back to `bashuser3`) |
| `TEST_PASS` | `"$1"` (required arg) | `"${1:-bashuser3}"` (same fallback) |
| Argument validation block | Required — exits if `$#  -lt 1` | **Removed** — no longer needed |

---

## The Syntax: `${var:-default}`

```bash
TEST_USER="${1:-bashuser3}"
```

Bash evaluates this as:

> *"Use the value of `$1` if it was provided and is non-empty — otherwise use `bashuser3`."*

| Scenario | `$1` | Result |
|----------|------|--------|
| `sudo ./setup_user.sh bashuser2` | `bashuser2` | `TEST_USER="bashuser2"` |
| `sudo ./setup_user.sh` | *(empty)* | `TEST_USER="bashuser3"` |

This means the script is useful both ways — with an argument for flexibility, and without one for a predictable default.

---

## Removing the Validation Block

Because the script now always has a value for `TEST_USER`, the guard from the previous tutorial is no longer needed and can be removed entirely:

```bash
# This block is no longer required — remove it
if [[ $# -lt 1 ]]; then
    echo "Usage: $0 <username>"
    exit 1
fi
```

---

## Updated Configuration Block

```bash
# -----------------------------------------------------------------------------
# Configuration — argument is optional, falls back to default
# -----------------------------------------------------------------------------
MASTER_USER="masteradmin"
TEST_USER="${1:-bashuser3}"
TEST_PASS="${1:-bashuser3}"
FLAG_PLAINTEXT="supersecretflagvalue"
```

Everything below this block remains exactly as before.

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
#   sudo ./setup_user.sh              # creates bashuser3 (default)
#   sudo ./setup_user.sh <username>   # creates the specified user
# =============================================================================

set -euo pipefail

# -----------------------------------------------------------------------------
# Configuration — argument is optional, falls back to default
# -----------------------------------------------------------------------------
MASTER_USER="masteradmin"
TEST_USER="${1:-bashuser3}"
TEST_PASS="${1:-bashuser3}"
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
# Uses the default — creates bashuser3
sudo ./setup_user.sh

# Overrides the default — creates bashuser2
sudo ./setup_user.sh bashuser2
```

### No Argument — Expected Output

```
[*] Creating user: bashuser3
    User 'bashuser3' created successfully.
...
[+] Setup complete.
    Test user   : bashuser3
```

### With Argument — Expected Output

```
[*] Creating user: bashuser2
    User 'bashuser2' created successfully.
...
[+] Setup complete.
    Test user   : bashuser2
```

---

## Summary

| Concept | Syntax |
|---------|--------|
| Use `$1` or fall back to a default | `"${1:-bashuser3}"` |
| Works for any variable, not just positional params | `"${MY_VAR:-somedefault}"` |
| No argument validation block needed | Remove the `if [[ $# -lt 1 ]]` guard |