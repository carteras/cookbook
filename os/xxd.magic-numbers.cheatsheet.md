# `xxd` and magic numbers — bash cheat sheet

> Inspect the raw bytes of a file to identify what it really is

---

## Basic syntax

```bash
xxd file.txt                  # full hex dump
xxd -l 16 file.txt            # first 16 bytes only
xxd -l 8 file.txt             # first 8 bytes — enough for most magic numbers
xxd -p -l 8 file.txt          # plain hex, no formatting
```

---

## Reading the output

```bash
$ xxd -l 16 archive.zip
00000000: 504b 0304 1400 0000 0800 0000 0000 0000  PK..............
```

| Column | Example | Meaning |
|--------|---------|---------|
| Offset | `00000000:` | Position in the file (hex) |
| Hex bytes | `504b 0304 ...` | Raw bytes in hexadecimal, grouped in pairs |
| ASCII | `PK..............` | Printable characters — `.` means non-printable |

The first few bytes are the magic number — read left to right from the hex column.

---

## Common magic numbers

| Format | Magic bytes (hex) | ASCII hint | xxd command |
|--------|-------------------|------------|-------------|
| ZIP | `50 4B 03 04` | `PK..` | `xxd -l 4 file.zip` |
| 7-Zip | `37 7A BC AF 27 1C` | `7z....` | `xxd -l 6 file.7z` |
| RAR | `52 61 72 21 1A 07` | `Rar!..` | `xxd -l 6 file.rar` |
| gzip | `1F 8B` | `..` | `xxd -l 2 file.gz` |
| bzip2 | `42 5A 68` | `BZh` | `xxd -l 3 file.bz2` |
| xz | `FD 37 7A 58 5A 00` | `.7zXZ.` | `xxd -l 6 file.xz` |
| tar | `75 73 74 61 72` | `ustar` | `xxd -l 262 file.tar \| tail -1` |
| PNG | `89 50 4E 47 0D 0A 1A 0A` | `.PNG....` | `xxd -l 8 file.png` |
| JPEG | `FF D8 FF` | `...` | `xxd -l 3 file.jpg` |
| GIF | `47 49 46 38` | `GIF8` | `xxd -l 4 file.gif` |
| PDF | `25 50 44 46 2D` | `%PDF-` | `xxd -l 5 file.pdf` |

> ⚠️ **tar is special** — the magic string `ustar` appears at byte offset 257, not byte 0. Use `xxd -l 262 file.tar | tail -1` to see it.

---

## Useful flags

| Flag | Example | Description |
|------|---------|-------------|
| `-l N` | `xxd -l 8 file` | Only read first N bytes |
| `-p` | `xxd -p -l 8 file` | Plain hex output — no offset, no ASCII column |
| `-s N` | `xxd -s 257 -l 8 file` | Skip N bytes before reading |
| `-u` | `xxd -u -l 8 file` | Uppercase hex |
| `-c N` | `xxd -c 8 -l 16 file` | N bytes per row (default 16) |
| `-r` | `xxd -r file.hex file.bin` | Reverse — convert hex dump back to binary |

---

## Comparing magic bytes

```bash
# check what a file actually is
xxd -l 8 mystery.bin

# compare to a known format
xxd -l 8 known.zip

# plain hex for easy comparison in scripts
xxd -p -l 8 mystery.bin
```

---

## Gotchas

| | |
|--|--|
| ⚠️ | **File extensions lie** — a file named `.zip` may not be a zip. Always check the magic bytes, not the name. |
| ⚠️ | **tar has no magic at byte 0** — the `ustar` signature lives at offset 257. `-l 8` will not find it. |
| ⚠️ | **gzip magic is only 2 bytes** — `1F 8B` is short. `.gz` files that are actually something else will still show this. |
| ✅ | **`-l 8` covers most formats** — the first 8 bytes is enough for PNG, ZIP, RAR, 7z, bzip2, xz, JPEG, and GIF. |
| ✅ | **Use `-p` for scripting** — plain hex is much easier to match against with `grep` or `if` statements. |
