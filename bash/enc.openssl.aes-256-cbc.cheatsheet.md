# `openssl enc` — bash cheat sheet

> Encrypt and decrypt files using AES-256-CBC with PBKDF2 key derivation

---

## The two commands

```bash
# encrypt
openssl enc -aes-256-cbc -pbkdf2 -a -in plaintext.txt -out secret.enc.b64 -pass pass:password

# decrypt
openssl enc -aes-256-cbc -pbkdf2 -a -d -in secret.enc.b64 -out plaintext.txt -pass pass:password
```

The only difference between encrypt and decrypt is the `-d` flag.

---

## Breaking down the flags

| Flag | Meaning | Example |
|------|---------|---------|
| `enc` | use openssl's symmetric encryption mode | `openssl enc ...` |
| `-aes-256-cbc` | algorithm — AES, 256-bit key, CBC mode | same for encrypt and decrypt |
| `-pbkdf2` | derive the key from the password securely | same for encrypt and decrypt |
| `-a` | base64 encode the output — produces readable text | same for encrypt and decrypt |
| `-d` | **decrypt** — omit this flag to encrypt | only on decrypt |
| `-in` | input file to read from | `-in plaintext.txt` |
| `-out` | output file to write to | `-out secret.enc.b64` |
| `-pass pass:` | the password, inline | `-pass pass:password` |

---

## Encrypt vs decrypt side by side

| | Encrypt | Decrypt |
|-|---------|---------|
| Command | `openssl enc` | `openssl enc` |
| Algorithm | `-aes-256-cbc` | `-aes-256-cbc` |
| Key method | `-pbkdf2` | `-pbkdf2` |
| Encoding | `-a` | `-a` |
| Direction | *(no flag)* | `-d` |
| Input | `-in plaintext.txt` | `-in secret.enc.b64` |
| Output | `-out secret.enc.b64` | `-out plaintext.txt` |
| Password | `-pass pass:password` | `-pass pass:password` |

---

## What each stage produces

| Stage | File | Contents |
|-------|------|----------|
| Start | `plaintext.txt` | Human-readable text |
| After encrypt | `secret.enc.b64` | Base64-encoded encrypted text |
| After decrypt | `plaintext.txt` | Human-readable text again |

> ✅ The `-a` flag makes the encrypted output base64 — it looks like text but is unreadable without the password and key. This makes it safe to copy/paste or store in a file.

---

## Common variations

| Goal | Flag to change |
|------|---------------|
| Don't base64 encode output (binary) | Remove `-a` |
| Use a different password | Change `pass:password` to `pass:yourpassword` |
| Read password from a file | `-pass file:secret.txt` instead of `pass:password` |
| Use a different algorithm | Replace `-aes-256-cbc` with e.g. `-aes-128-cbc` |

---

## Gotchas

| | |
|--|--|
| ⚠️ | **Wrong password** — openssl will decrypt but produce garbage output, or fail with `bad decrypt` |
| ⚠️ | **Missing `-d`** — omitting `-d` on decrypt will encrypt the file again instead |
| ⚠️ | **Mismatched `-a`** — if you encrypted with `-a` you must decrypt with `-a`, and vice versa |
| ⚠️ | **Missing `-pbkdf2`** — if you encrypted with `-pbkdf2` you must decrypt with `-pbkdf2` |
| ✅ | **Flags must match** — every flag used during encryption must also be used during decryption except `-d` |
| ✅ | **Check your output** — after decrypting, `cat plaintext.txt` to confirm the content looks right |
