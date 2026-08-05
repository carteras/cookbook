# Cognitive task analysis — identifying files with `xxd`

> How a student thinks through using xxd to find out what a file really is

---

## Goal

| Overall goal |
|---|
| Use `xxd` to read the first few bytes of an unknown file and match them against known magic numbers to identify the file format |

---

## Subgoals

| Subgoal 1 | Subgoal 2 | Subgoal 3 |
|-----------|-----------|-----------|
| **Read the raw bytes** | **Isolate the magic number** | **Match against known signatures** |
| Use `xxd` to dump the file in hex so the raw bytes are visible | The magic number is the first few bytes — limit the output so it isn't overwhelming | Compare what you see to the known magic bytes for common file formats |

---

## Decisions

| Decision | Question | Answer |
|----------|----------|--------|
| 1 | How many bytes do I need? | 8 bytes covers most formats. tar needs 262 bytes (offset 257). |
| 2 | Which output format? | Default `xxd` output for reading. `-p` plain hex for scripting or comparison. |
| 3 | Do I trust the file extension? | No — file extensions can be wrong or missing. Always check the bytes. |
| 4 | Where do I look in the output? | Far left of the hex column, first row. Read left to right. |
| 5 | What if the bytes don't match anything? | The file may be raw binary data, corrupted, or a less common format. |

---

## Actions — in order

| Step | Action | Detail |
|------|--------|--------|
| 01 | Run xxd with a byte limit | `xxd -l 8 mystery.bin` — first 8 bytes is enough for most formats |
| 02 | Read the hex column | Ignore the offset and ASCII columns for now — focus on the hex bytes |
| 03 | Note the first 2–8 bytes | e.g. `89 50 4E 47` or `1F 8B` |
| 04 | Compare to the magic number table | Match the bytes to a known format |
| 05 | Confirm with the ASCII column | The ASCII hint (e.g. `PK`, `BZh`, `7z`) is a quick sanity check |
| 06 | Handle special cases | If no match at offset 0, check if it could be tar (offset 257) |

---

## Reading the output

```bash
$ xxd -l 8 photo.bin
00000000: 8950 4e47 0d0a 1a0a                      .PNG....
```

| What you see | What it means |
|--------------|---------------|
| `00000000:` | Offset — we are at byte 0, the very start of the file |
| `8950 4e47 0d0a 1a0a` | The raw bytes in hex — this is the magic number |
| `.PNG....` | ASCII representation — the `PNG` tells us immediately what this is |

Match `89 50 4E 47` against the magic number table → **PNG image**.

---

## The mental model

| Thinking about files normally | Thinking about files with xxd |
|-------------------------------|-------------------------------|
| A file is what its name says it is | A file is what its first bytes say it is |
| `.zip` means it is a zip file | `50 4B 03 04` means it is a zip file |
| The extension is the identity | The magic number is the identity |
| Metadata can lie | Bytes don't lie |

---

## Worked examples

### Example 1 — PNG image

```bash
$ xxd -l 8 image.bin
00000000: 8950 4e47 0d0a 1a0a                      .PNG....
```

| Bytes seen | Match | Conclusion |
|------------|-------|------------|
| `89 50 4E 47 0D 0A 1A 0A` | PNG magic | This is a PNG image |

---

### Example 2 — gzip archive

```bash
$ xxd -l 8 archive.bin
00000000: 1f8b 0808 6b1e e164 0003 6669 6c65 2e74  ....k..d..file.t
```

| Bytes seen | Match | Conclusion |
|------------|-------|------------|
| `1F 8B` | gzip magic | This is a gzip compressed file |

---

### Example 3 — ZIP archive

```bash
$ xxd -l 8 package.bin
00000000: 504b 0304 1400 0000                      PK......
```

| Bytes seen | Match | Conclusion |
|------------|-------|------------|
| `50 4B 03 04` | ZIP magic | This is a ZIP archive — `PK` are the initials of Phil Katz, creator of the format |

---

### Example 4 — tar archive (special case)

```bash
$ xxd -s 257 -l 5 archive.bin
00000101: 7573 7461 72                              ustar
```

tar has no magic number at byte 0 — skip to offset 257 with `-s 257`.

| Bytes seen | Offset | Match | Conclusion |
|------------|--------|-------|------------|
| `75 73 74 61 72` | 257 | tar magic (`ustar`) | This is a tar archive |

---

### Additional example — PDF (the format used in the challenge)

```bash
$ xxd -l 8 document.bin
00000000: 2550 4446 2d31 2e34 0a25                 %PDF-1.4.%
```

| Bytes seen | Match | Conclusion |
|------------|-------|------------|
| `25 50 44 46 2D` | PDF magic (`%PDF-`) | This is a PDF file |

The `%PDF-` signature is followed by the version number (`1.4`, `1.7`, `2.0` etc.) immediately after the dash.

---

## All formats for this challenge

| Format | Check command | Magic bytes | ASCII |
|--------|--------------|-------------|-------|
| ZIP | `xxd -l 4 file` | `50 4B 03 04` | `PK..` |
| 7-Zip | `xxd -l 6 file` | `37 7A BC AF 27 1C` | `7z....` |
| RAR | `xxd -l 6 file` | `52 61 72 21 1A 07` | `Rar!..` |
| gzip | `xxd -l 2 file` | `1F 8B` | `..` |
| bzip2 | `xxd -l 3 file` | `42 5A 68` | `BZh` |
| xz | `xxd -l 6 file` | `FD 37 7A 58 5A 00` | `.7zXZ.` |
| tar | `xxd -s 257 -l 5 file` | `75 73 74 61 72` | `ustar` |
| PDF | `xxd -l 5 file` | `25 50 44 46 2D` | `%PDF-` |

---

## Common errors

| | Error | Fix |
|--|-------|-----|
| ⚠️ | Running `xxd file` with no `-l` on a large file | Use `-l 8` to limit output to the first 8 bytes |
| ⚠️ | Trusting the file extension | Always verify with xxd — extensions can be renamed or wrong |
| ⚠️ | Looking for tar magic at byte 0 | tar magic is at offset 257 — use `xxd -s 257 -l 5 file` |
| ⚠️ | Confusing hex pairs — `504b` is two bytes: `50` and `4b` | Read in pairs separated by spaces |
| ✅ | Most formats are identified by the first 8 bytes | `xxd -l 8 file` is a good default starting point |
