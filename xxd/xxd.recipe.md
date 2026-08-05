# Magic numbers and file metadata with `xxd`

*A practical cookbook for the command line*

---

## Introduction

Every file on a computer is ultimately a sequence of bytes. The operating system uses file extensions and filesystem metadata to decide what kind of file something is — but those can be wrong, renamed, or deliberately misleading. The bytes themselves cannot lie.

Most file formats embed a signature in their first few bytes — a fixed pattern that identifies the format regardless of what the file is named. These signatures are called **magic numbers**.

`xxd` is a hex dump tool that lets you read any file as raw bytes. Combined with a table of known magic numbers, it becomes a reliable way to identify what a file actually is.

This cookbook covers:
- What magic numbers are and why they exist
- How to read `xxd` output
- How to identify common archive formats by their bytes
- How file metadata relates to what you see with `xxd`

For the full `xxd` flag reference, see `man xxd` or the [xxd documentation](https://linux.die.net/man/1/xxd).
For a comprehensive magic number database, see the [file command's magic database](https://github.com/file/file/tree/master/magic) or the [Gary Kessler magic number list](https://www.garykessler.net/library/file_sigs.html).

---

## What is a magic number?

When a file format was designed, its authors chose a fixed sequence of bytes to place at the beginning of every file in that format. This sequence serves as a self-identifying stamp — open any valid ZIP file in the world and the first four bytes will always be `50 4B 03 04`.

The name "magic number" comes from Unix tradition. The `file` command on Linux and macOS uses a database of these signatures to identify files — it does not look at the file extension at all.

Magic numbers exist because:
- Extensions can be renamed, removed, or wrong
- Files transferred between systems may lose metadata
- Programs need a reliable way to verify they are reading the right kind of data before processing it

---

## How `xxd` shows you raw bytes

`xxd` prints a file's contents as hexadecimal. The output has three columns:

```bash
$ xxd -l 16 archive.gz
00000000: 1f8b 0808 9c65 e164 0003 6669 6c65 732e  .....e.d..files.
```

| Column | Content | Notes |
|--------|---------|-------|
| `00000000:` | Byte offset from the start of the file, in hex | `00000000` means "byte zero" — the very first byte |
| `1f8b 0808 ...` | The bytes themselves, in hexadecimal | Read left to right, two hex digits = one byte |
| `.....e.d..files.` | ASCII representation | Printable characters shown as-is, non-printable as `.` |

The magic number lives in the hex column, starting at offset `00000000`.

To keep output manageable, always limit how many bytes you read:

```bash
xxd -l 8 file     # first 8 bytes — covers most formats
xxd -l 2 file     # gzip only needs 2
xxd -l 6 file     # 7z, RAR, xz need 6
```

---

## Reading magic bytes in practice

### PNG image

PNG files begin with an 8-byte signature designed to catch common file transfer errors as well as identify the format.

```bash
$ xxd -l 8 photo.png
00000000: 8950 4e47 0d0a 1a0a                      .PNG....
```

The bytes `89 50 4E 47 0D 0A 1A 0A` break down as:

| Byte(s) | Value | Purpose |
|---------|-------|---------|
| `89` | Non-ASCII byte | Catches systems that strip high bytes |
| `50 4E 47` | `PNG` in ASCII | Human-readable format identifier |
| `0D 0A` | CR LF | Catches line ending conversions |
| `1A` | Control-Z | Stops display in some DOS tools |
| `0A` | LF | Catches the reverse line ending conversion |

The PNG designers thought carefully about what could go wrong during file transfer and built those failure modes into the signature itself. This is an unusually deliberate magic number.

---

### gzip compressed file

gzip uses only two magic bytes:

```bash
$ xxd -l 8 archive.gz
00000000: 1f8b 0808 9c65 e164 0003 6669 6c65 732e  .....e.d..files.
```

The magic number is just `1F 8B` — the first two bytes. The rest of the header contains compression method, flags, timestamp, and OS identifier. None of that is visible as ASCII, which is why the right column shows mostly dots.

---

### bzip2 compressed file

bzip2 has a three-byte magic number with a readable ASCII hint:

```bash
$ xxd -l 8 archive.bz2
00000000: 425a 6839 3141 5926 5359                 BZh91AY&SY
```

`42 5A 68` decodes as `BZh` in ASCII — easy to spot in the right column. The `9` that follows is part of the block size indicator, not the magic number.

---

### xz compressed file

```bash
$ xxd -l 8 archive.xz
00000000: fd37 7a58 5a00 0004 e6d6 b446            .7zXZ.......
```

The magic is `FD 37 7A 58 5A 00` — six bytes. The ASCII hint `.7zXZ.` is misleading because xz and 7z are entirely different formats. The leading `FD` (non-ASCII) distinguishes xz from 7z at the first byte.

---

### 7-Zip archive

```bash
$ xxd -l 8 archive.7z
00000000: 377a bcaf 271c 0004 6f6f 6f6f            7z..'.oooo
```

Magic: `37 7A BC AF 27 1C`. The first two bytes `37 7A` are ASCII `7z` — human readable. The following four bytes are non-ASCII and complete the signature.

---

### ZIP archive

```bash
$ xxd -l 8 archive.zip
00000000: 504b 0304 1400 0000 0800 81cc ed58 0000  PK...........X..
```

Magic: `50 4B 03 04`. The `PK` in the ASCII column stands for Phil Katz, the creator of the ZIP format. This is one of the most recognisable magic numbers — you will see `PK` appear in the ASCII column of any valid ZIP file.

---

### RAR archive

```bash
$ xxd -l 8 archive.rar
00000000: 5261 7221 1a07 0100 33d1 5700 0d00 0000  Rar!....3.W.....
```

Magic: `52 61 72 21 1A 07`. The ASCII hint `Rar!` is immediately recognisable.

---

### tar archive — a special case

tar is the odd one out. It has no magic number at byte zero. Instead, the string `ustar` appears at byte offset **257**:

```bash
$ xxd -s 257 -l 8 archive.tar
00000101: 7573 7461 7220 2000 0000 0000 0000 0000  ustar  .........
```

The `-s 257` flag tells `xxd` to skip the first 257 bytes before reading. The offset column confirms we are at `0x101` (decimal 257).

This is because tar was originally designed for sequential tape storage and its header structure puts the format identifier in a specific field rather than at the file's start.

---

### PDF — additional example

```bash
$ xxd -l 8 document.pdf
00000000: 2550 4446 2d31 2e37 0a25 c4e5 f2e5 eba7  %PDF-1.7.%......
```

Magic: `25 50 44 46 2D` — ASCII `%PDF-`. The version number follows immediately: `31 2e 37` is `1.7` in ASCII. PDF magic numbers are human-readable by design, which is why the right column shows `%PDF-1.7` clearly.

---

## Magic numbers vs file metadata

When you look at a file, there are two different sources of information about what it is:

| Source | What it contains | Can it lie? |
|--------|-----------------|-------------|
| File extension (`.zip`, `.png`) | A hint to the OS and user | Yes — trivially renamed |
| Filesystem metadata (inode, MIME type) | Type recorded by the OS or application | Sometimes — depends on how it was set |
| Magic number (first bytes of the file) | Self-describing identity baked into the content | No — the bytes are what they are |

The `file` command on Linux uses a combination of magic numbers and other heuristics (content patterns, encoding detection) to identify files. It does not use the extension at all:

```bash
$ file mystery.bin
mystery.bin: PNG image data, 800 x 600, 8-bit/color RGB, non-interlaced
```

`xxd` gives you the raw bytes so you can do this identification yourself, which is useful when:
- You are writing a script that needs to handle multiple file types
- You are investigating a file that has been deliberately mislabelled
- You want to understand what `file` is actually doing under the hood

---

## What comes after the magic number

The bytes immediately after the magic number are usually part of the file's header — structured metadata about the file's contents. What's in those bytes depends entirely on the format.

For a gzip file, bytes 2–9 contain:

| Offset | Field | Example |
|--------|-------|---------|
| 2 | Compression method | `08` = deflate |
| 3 | Flags | `08` = filename present |
| 4–7 | Timestamp | Unix timestamp of original file |
| 8 | Compression level hint | `00` = default |
| 9 | OS | `03` = Unix |

For a ZIP file, bytes 4–29 describe the first file entry in the archive — its compression method, modification time, CRC, size, and filename length.

You do not need to parse these fields manually. `xxd` is for identification and investigation. Once you know what format you are dealing with, use the appropriate tool (`gunzip`, `unzip`, `7z`, `tar`) to work with the actual contents.

---

## Recipes

### Identify a file by its magic bytes

```bash
xxd -l 8 mystery.bin
```

Read the first hex pair(s) and compare to the magic number table.

### Check for a specific format in a script

```bash
magic=$(xxd -p -l 4 mystery.bin)

if [[ "$magic" == "504b0304" ]]; then
  echo "ZIP file"
fi
```

`-p` gives plain hex output — no formatting, easy to compare as a string.

### Check tar specifically

```bash
magic=$(xxd -p -s 257 -l 5 mystery.bin)

if [[ "$magic" == "7573746172" ]]; then
  echo "tar archive"
fi
```

### Show the full first line of any file

```bash
xxd -l 16 mystery.bin
```

16 bytes gives you one full line of xxd output — useful for a quick look at the header region.

---

## Further reading

- [`man xxd`](https://linux.die.net/man/1/xxd) — full flag reference
- [`man file`](https://linux.die.net/man/1/file) — the file identification command that uses magic internally
- [Gary Kessler's file signature table](https://www.garykessler.net/library/file_sigs.html) — comprehensive magic number database
- [file command magic database](https://github.com/file/file/tree/master/magic) — the actual signatures `file` uses on your system
- [Wikipedia: list of file signatures](https://en.wikipedia.org/wiki/List_of_file_signatures) — broad reference
