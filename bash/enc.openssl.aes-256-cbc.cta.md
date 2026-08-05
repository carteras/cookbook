# Cognitive task analysis — `openssl enc` decrypt

> How a student thinks through decrypting a file they have been given

---

## Goal

| Overall goal |
|---|
| Use `openssl` to decrypt a base64-encoded AES-256-CBC encrypted file and read its contents |

---

## Subgoals

| Subgoal 1 | Subgoal 2 | Subgoal 3 |
|-----------|-----------|-----------|
| **Understand what you have been given** | **Build the decrypt command** | **Verify the output** |
| You have an encrypted, base64-encoded file and a password. You need to reverse the encryption. | Match every flag from the encrypt command — then add `-d` and swap `-in` and `-out` | Read the output file to confirm decryption worked |

---

## Decisions

| Decision | Question | Answer |
|----------|----------|--------|
| 1 | Which algorithm? | Must match encryption — `-aes-256-cbc` |
| 2 | Which key method? | Must match encryption — `-pbkdf2` |
| 3 | Was the output base64 encoded? | Yes — `-a` was used to encrypt, so `-a` must be used to decrypt |
| 4 | How do I tell openssl to decrypt not encrypt? | Add the `-d` flag — this is the only new flag needed |
| 5 | What is `-in`? | The encrypted file you were given — `secret.flag.enc.b64` |
| 6 | What is `-out`? | The file you want to write the plaintext to — `plaintext.txt` |
| 7 | Where is the password? | Inline with `-pass pass:password` |

---

## Reading the encrypt command

```bash
openssl enc -aes-256-cbc -pbkdf2 -a -in "$FLAG_LOCATION/$FLAG_FILE" -out "$FLAG_LOCATION/$ENC_B64" -pass pass:password
```

| Part | What it tells you |
|------|------------------|
| `enc` | symmetric encryption mode |
| `-aes-256-cbc` | algorithm you must match |
| `-pbkdf2` | key method you must match |
| `-a` | output is base64 — you must use `-a` to decrypt |
| `-in` | the plaintext that was encrypted — you don't have this |
| `-out` | the encrypted file you were given |
| `-pass pass:password` | the password you need |
| *(no `-d`)* | this was encryption — you need to add `-d` |

---

## Actions — in order

| Step | Action | Detail |
|------|--------|--------|
| 01 | Identify the encrypted file | `secret.flag.enc.b64` — this is your `-in` |
| 02 | Choose an output filename | `plaintext.txt` — this is your `-out` |
| 03 | Copy the algorithm flags from the encrypt command | `-aes-256-cbc -pbkdf2 -a` — must match exactly |
| 04 | Add the `-d` flag | This tells openssl to decrypt instead of encrypt |
| 05 | Add the password | `-pass pass:password` |
| 06 | Run the command | `openssl enc -aes-256-cbc -pbkdf2 -a -d -in secret.flag.enc.b64 -out plaintext.txt -pass pass:password` |
| 07 | Read the output | `cat plaintext.txt` |

---

## The full command

```bash
openssl enc -aes-256-cbc -pbkdf2 -a -d -in secret.flag.enc.b64 -out plaintext.txt -pass pass:password
```

---

## Encrypt vs decrypt mental model

| Thinking about encrypt | Thinking about decrypt |
|------------------------|------------------------|
| plaintext → scrambled output | scrambled input → plaintext |
| `-in` is the file you can read | `-in` is the file you cannot read |
| `-out` is the file no one can read | `-out` is the file you want to read |
| No `-d` flag | Add `-d` flag |
| All other flags stay the same | All other flags stay the same |

---

## Common errors

| | Error | Fix |
|--|-------|-----|
| ⚠️ | Forgetting `-d` | Without it you will encrypt the encrypted file again |
| ⚠️ | Wrong password | openssl may produce garbage output or print `bad decrypt` |
| ⚠️ | Missing `-a` on decrypt | If `-a` was used to encrypt, it must be used to decrypt |
| ⚠️ | Missing `-pbkdf2` on decrypt | If `-pbkdf2` was used to encrypt, it must be used to decrypt |
| ⚠️ | Swapping `-in` and `-out` | `-in` is what you have, `-out` is what you want to create |
| ✅ | Rule of thumb | Every flag from the encrypt command carries over to decrypt — just add `-d` and swap the filenames |
