# OpenSSL Encryption and Decryption

*A practical cookbook for the command line*

---

## Introduction

OpenSSL is a general-purpose cryptography toolkit. It does a lot of things — certificates, key generation, hashing, TLS inspection — but this cookbook focuses on one job: encrypting and decrypting files from the command line using symmetric encryption.

Symmetric encryption means the same password (or key) locks and unlocks the file. This is different from public/private key encryption. It is simpler, faster, and appropriate when you control both ends of the exchange.

All examples use `openssl enc`, which is OpenSSL's symmetric cipher command.

For the full list of supported algorithms and flags, see the official documentation:
- [`openssl enc` man page](https://www.openssl.org/docs/man3.0/man1/openssl-enc.html)
- [OpenSSL cookbook (full)](https://www.feistyduck.com/library/openssl-cookbook/)

---

## How `openssl enc` thinks

Before writing any command, it helps to understand what `openssl enc` is actually doing:

```
plaintext file
      │
      ▼
  derive a key from your password (PBKDF2)
      │
      ▼
  encrypt the data with that key (AES-256-CBC)
      │
      ▼
  optionally base64 encode the result (-a)
      │
      ▼
encrypted output file
```

Decryption reverses this exactly. Every flag you used to encrypt must be present when you decrypt, because OpenSSL needs to know how to reverse each step.

---

## Anatomy of the command

```bash
openssl enc -aes-256-cbc -pbkdf2 -a -in input.txt -out output.enc -pass pass:yourpassword
```

Every part has a job:

| Part | Job |
|------|-----|
| `openssl` | the toolkit |
| `enc` | use symmetric encryption mode |
| `-aes-256-cbc` | the cipher algorithm |
| `-pbkdf2` | how the password becomes a key |
| `-a` | base64 encode the output |
| `-in input.txt` | file to read |
| `-out output.enc` | file to write |
| `-pass pass:yourpassword` | the password |

Decryption is the same command with one addition: `-d`.

```bash
openssl enc -aes-256-cbc -pbkdf2 -a -d -in output.enc -out recovered.txt -pass pass:yourpassword
```

---

## Choosing an algorithm

The algorithm flag (`-aes-256-cbc` in these examples) controls how the data is scrambled. OpenSSL supports many algorithms. The one you choose should be driven by context, not habit.

For most practical purposes, AES-CBC variants are a solid default:

| Algorithm | Key size | Notes |
|-----------|----------|-------|
| `-aes-128-cbc` | 128-bit | Faster, still strong |
| `-aes-256-cbc` | 256-bit | Stronger, slightly slower |
| `-aes-256-gcm` | 256-bit | Authenticated encryption — detects tampering |

> To see every algorithm OpenSSL supports on your machine, run:
> ```bash
> openssl enc -list
> ```

The algorithm name you use to encrypt must exactly match the name you use to decrypt. OpenSSL does not detect mismatches gracefully.

---

## Key derivation: why `-pbkdf2` matters

Your password is not used as the encryption key directly. It goes through a key derivation function first — a process that turns a human-memorable password into a fixed-length cryptographic key.

Without `-pbkdf2`, OpenSSL falls back to an older, weaker method (`EVP_BytesToKey`). You will see a deprecation warning on modern OpenSSL versions if you omit it.

```bash
# Without -pbkdf2 (avoid this)
openssl enc -aes-256-cbc -in file.txt -out file.enc -pass pass:password
# WARNING : deprecated key derivation used.
```

```bash
# With -pbkdf2 (use this)
openssl enc -aes-256-cbc -pbkdf2 -in file.txt -out file.enc -pass pass:password
```

Always include `-pbkdf2`. If you encrypted with it, you must decrypt with it. If you encrypted without it, you must decrypt without it.

---

## The `-a` flag: binary vs base64

By default, `openssl enc` produces binary output — raw bytes that look like garbage in a text editor and may not survive copy/paste or being embedded in other files.

The `-a` flag base64 encodes the output, turning it into printable ASCII characters:

```bash
# Without -a — binary output
openssl enc -aes-256-cbc -pbkdf2 -in file.txt -out file.enc -pass pass:password

# With -a — base64 output, safe to read and share as text
openssl enc -aes-256-cbc -pbkdf2 -a -in file.txt -out file.enc.b64 -pass pass:password
```

A base64-encoded encrypted file looks something like this:

```
U2FsdGVkX1+3Yk5W8mFkO1vLz0QxAhFP...
```

Use `-a` when:
- The encrypted file needs to be readable as text
- You are storing it in a format that doesn't handle binary well
- You want to visually confirm the file was created correctly

If you encrypted with `-a`, you must decrypt with `-a`.

---

## Supplying the password

OpenSSL gives you several ways to pass the password. Each has different tradeoffs.

| Method | Example | Notes |
|--------|---------|-------|
| Inline | `-pass pass:password` | Simple, but password visible in process list |
| From a file | `-pass file:secret.txt` | Safer for scripts — put the password in a file |
| From environment | `-pass env:MY_PASS` | Good for CI/CD pipelines |
| Interactive prompt | *(omit `-pass`)* | OpenSSL asks you to type it — most secure for humans |

For learning and CTF challenges, inline `-pass pass:yourpassword` is fine. In production scripts, prefer `-pass file:` or `-pass env:`.

---

## Recipes

### Encrypt a file

```bash
openssl enc -aes-256-cbc -pbkdf2 -a \
  -in plaintext.txt \
  -out encrypted.b64 \
  -pass pass:yourpassword
```

### Decrypt a file

```bash
openssl enc -aes-256-cbc -pbkdf2 -a -d \
  -in encrypted.b64 \
  -out plaintext.txt \
  -pass pass:yourpassword
```

### Encrypt without base64 (binary output)

```bash
openssl enc -aes-256-cbc -pbkdf2 \
  -in plaintext.txt \
  -out encrypted.bin \
  -pass pass:yourpassword
```

### Decrypt and read without writing a file

```bash
openssl enc -aes-256-cbc -pbkdf2 -a -d \
  -in encrypted.b64 \
  -pass pass:yourpassword
```

This prints the plaintext directly to your terminal without creating an output file.

### Encrypt and pipe to another command

```bash
openssl enc -aes-256-cbc -pbkdf2 -a \
  -in plaintext.txt \
  -pass pass:yourpassword | wc -c
```

Omitting `-out` sends the output to stdout, which you can pipe anywhere.

---

## Reading an unknown encrypted file

If someone hands you an encrypted file and tells you to decrypt it, you need four things before you can write the command:

| What you need | Where to get it |
|---------------|-----------------|
| The algorithm | Ask, or look at the encrypt command |
| Whether `-pbkdf2` was used | Look at the encrypt command |
| Whether `-a` was used | Look at the encrypt command — or open the file in a text editor. If it looks like ASCII it was probably base64 encoded. |
| The password | Ask |

The safest approach is to look at the encrypt command and mirror it exactly — same algorithm, same flags, same password — then add `-d` and swap `-in` and `-out`.

---

## What can go wrong

| Symptom | Likely cause |
|---------|-------------|
| `bad decrypt` error | Wrong password, or flags don't match between encrypt and decrypt |
| Output file is garbage text | Decrypted successfully but the original was binary, not text |
| `unknown option` error | Typo in a flag name |
| Warning about deprecated key derivation | Missing `-pbkdf2` |
| No output, no error | Check that `-out` path is writable |
| Encrypted twice by accident | Ran the encrypt command again on an already-encrypted file |

---

## Further reading

- [`openssl enc` man page](https://www.openssl.org/docs/man3.0/man1/openssl-enc.html) — full flag reference
- [OpenSSL cookbook by Ivan Ristić](https://www.feistyduck.com/library/openssl-cookbook/) — deeper treatment of the whole toolkit
- [Cipher list](https://www.openssl.org/docs/man3.0/man1/openssl-ciphers.html) — all supported algorithms
