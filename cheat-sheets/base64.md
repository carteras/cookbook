# base64

> Encodes binary data as ASCII text using 64 printable characters — `A–Z a–z 0–9 + /` — with `=` padding.

---

## Encode

```sh
base64 file.bin                          # encode file → stdout
base64 < file.bin                        # encode from stdin
base64 -o out.txt file.bin               # encode to file (macOS)
base64 file.bin > out.txt                # encode to file (Linux)
echo -n "hello" | base64                 # encode a string (no newline)
printf '%s' "hello" | base64             # portable: encode string
```

## Decode

```sh
base64 -d file.txt                       # decode file (Linux)
base64 -D file.txt                       # decode file (macOS)
base64 -d <<< "aGVsbG8="                 # decode a string inline
echo "aGVsbG8=" | base64 -d              # pipe string to decode
base64 -d -i file.txt                    # ignore invalid chars (Linux)
base64 -d file.txt > out.bin             # decode back to binary
```

## Line wrapping

```sh
# Linux
base64 -w 0 file.bin                     # no line wrapping
base64 -w 76 file.bin                    # wrap at 76 chars

# macOS
base64 -b 0 file.bin                     # no line wrapping
base64 -b 76 file.bin                    # wrap at 76 chars
```

## URL-safe variant

Standard base64 uses `+` and `/`, which are unsafe in URLs. The URL-safe variant replaces them:

| Standard | URL-safe | Notes          |
|----------|----------|----------------|
| `+`      | `-`      |                |
| `/`      | `_`      |                |
| `=`      | omitted  | padding stripped |

There is no native CLI flag for this — use `tr`:

```sh
# Linux
base64 -w 0 | tr '+/' '-_' | tr -d '='

# macOS
base64 -b 0 | tr '+/' '-_' | tr -d '='
```

## Python, Node.js, OpenSSL

```sh
# OpenSSL
openssl base64 -in file.bin              # encode
openssl base64 -d -in file.txt           # decode

# Python 3
echo -n "hello" | python3 -c \
  "import base64,sys; print(base64.b64encode(sys.stdin.buffer.read()).decode())"

echo "aGVsbG8=" | python3 -c \
  "import base64,sys; sys.stdout.buffer.write(base64.b64decode(sys.stdin.read()))"

# Node.js
node -e "process.stdout.write(Buffer.from(process.argv[1]).toString('base64'))" "hello"
node -e "process.stdout.write(Buffer.from(process.argv[1],'base64').toString())" "aGVsbG8="
```

## Data URIs

```
data:image/png;base64,…
data:text/plain;base64,…
data:application/pdf;base64,…
```

---

## Quick reference

### Flag cheatsheet

| Action          | Linux      | macOS      |
|-----------------|------------|------------|
| Decode          | `-d`       | `-D`       |
| Disable wrapping | `-w 0`    | `-b 0`     |
| Wrap at N chars | `-w N`     | `-b N`     |
| Ignore invalid  | `-i`       | (default)  |

### Size overhead

Every 3 bytes of input produce exactly 4 characters of output, giving roughly **33% size overhead**.

```
n bytes  →  ⌈n/3⌉ × 4 chars

3 bytes  →  4 chars   (exact, no padding)
2 bytes  →  4 chars   (1× `=` padding)
1 byte   →  4 chars   (2× `=` padding)
```

### Alphabet

```
A–Z   →  values  0–25
a–z   →  values 26–51
0–9   →  values 52–61
+     →  value  62
/     →  value  63
=     →  padding (not a value)
```

---

## Gotchas

**Newline in `echo`** — `echo "hello" | base64` encodes a trailing newline, producing `aGVsbG8K` instead of `aGVsbG8=`. Always use `echo -n` or `printf '%s'` when encoding strings.

**Linux vs macOS flags** — decode is `-d` on Linux and `-D` on macOS. Scripts that work on one will silently fail on the other. Use `openssl base64` or Python as a portable alternative.

**No URL-safe flag** — standard `base64` has no built-in mode for URL-safe output. Pipe through `tr` or use a language library (`base64.urlsafe_b64encode()` in Python, `Buffer.toString('base64url')` in Node.js ≥ 16).

**Not encryption** — base64 is encoding, not encryption. It provides no confidentiality; anyone can decode it instantly.
