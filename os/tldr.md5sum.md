# tldr: md5sum

## Description

Computes an MD5 hash — a 32-character hexadecimal fingerprint of whatever you give it. The same input always produces the same hash. Even a single character change produces a completely different hash. Used to verify file integrity, generate flags, and check if two files are identical without reading them.

---

## Simple Examples

```bash
# Hash a string (piped in from echo)
echo "my_flag" | md5sum
# a43c1b0aa53a0c908810c06ab1ff3967  -

# Hash a file
md5sum secret.flag
# d41d8cd98f00b204e9800998ecf8427e  secret.flag

# Hash multiple files at once
md5sum file1.txt file2.txt file3.txt

# Check files against a saved list of expected hashes
md5sum -c checksums.md5
```

---

## Composite Example

Generating a clean flag hash and writing it to a file — the full pipeline used in the wargame setup:

```bash
# What md5sum produces raw
echo "my_flag" | md5sum
# a43c1b0aa53a0c908810c06ab1ff3967  -
#                                   ↑ this trailing "  -" needs to be removed

# cut strips the trailing "  -" leaving just the hash
echo "my_flag" | md5sum | cut -d " " -f1
# a43c1b0aa53a0c908810c06ab1ff3967

# Redirect the clean hash into the flag file
echo "my_flag" | md5sum | cut -d " " -f1 > /home/bushranger101/secret.flag

# Verify
cat /home/bushranger101/secret.flag
# a43c1b0aa53a0c908810c06ab1ff3967
```

Reproducing the same hash later to verify your flag is correct:

```bash
echo "my_flag" | md5sum | cut -d " " -f1
# a43c1b0aa53a0c908810c06ab1ff3967  ← same hash, every time
```

---

## Notes for Students

- The `  -` at the end of `md5sum` output means the input came from stdin (a pipe), not from a named file. It's harmless but needs to be stripped with `cut` if you're writing the hash to a file.
- **MD5 is not secure for passwords or cryptography** — it was broken years ago and collisions are easy to generate. But it's perfectly fine for generating reproducible flag strings in a learning environment.
- The same input **always** produces the same hash. This is why it's useful for wargames — you can always verify what the hash of your secret phrase should be without storing the plain-text secret anywhere.
- To verify a file hasn't been tampered with: hash it when you create it, save that hash, then hash it again later and compare. If they differ, the file changed.
- `sha256sum` works exactly like `md5sum` but produces a longer, more secure hash. You'll see it used in production environments for file verification.
