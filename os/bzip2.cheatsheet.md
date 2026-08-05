# `bzip2` — bash cheat sheet

> Compress and decompress files using bzip2 from the command line

---

## Basic syntax

```bash
bzip2 file.txt          # compress — replaces file.txt with file.txt.bz2
bzip2 -d file.txt.bz2   # decompress — replaces file.txt.bz2 with file.txt
bunzip2 file.txt.bz2    # decompress — same as bzip2 -d
```

> ⚠️ bzip2 replaces the original file by default. Use `-k` to keep it.

---

## Essential flags

| Flag | Meaning |
|------|---------|
| `-d` | **d**ecompress |
| `-k` | **k**eep the original file |
| `-c` | write to stdout — don't touch the original |
| `-v` | **v**erbose — show compression ratio |
| `-t` | **t**est integrity without decompressing |
| `-1` to `-9` | compression level — `-1` fastest, `-9` smallest (default is `-9`) |

---

## Compress vs decompress side by side

| | Compress | Decompress |
|-|----------|------------|
| Basic | `bzip2 file.txt` | `bzip2 -d file.txt.bz2` |
| Keep original | `bzip2 -k file.txt` | `bzip2 -dk file.txt.bz2` |
| Write to stdout | `bzip2 -c file.txt > file.txt.bz2` | `bzip2 -dc file.txt.bz2 > file.txt` |
| Verbose | `bzip2 -v file.txt` | `bzip2 -dv file.txt.bz2` |
| Multiple files | `bzip2 file1 file2 file3` | `bzip2 -d file1.bz2 file2.bz2` |

---

## Common patterns

| Goal | Command |
|------|---------|
| Compress a file | `bzip2 file.txt` |
| Decompress a file | `bzip2 -d file.txt.bz2` |
| Decompress with bunzip2 | `bunzip2 file.txt.bz2` |
| Keep original when compressing | `bzip2 -k file.txt` |
| Compress and pipe to another command | `bzip2 -c file.txt \| wc -c` |
| Decompress and pipe to another command | `bzip2 -dc file.txt.bz2 \| grep "password"` |
| Test archive integrity | `bzip2 -t file.txt.bz2` |
| Maximum compression (default) | `bzip2 -9 file.txt` |
| Fastest compression | `bzip2 -1 file.txt` |

---

## bzip2 vs bunzip2 vs bzcat

| Command | What it does |
|---------|-------------|
| `bzip2 file` | Compress file, replace with `.bz2` |
| `bzip2 -d file.bz2` | Decompress file, replace with original |
| `bunzip2 file.bz2` | Same as `bzip2 -d` — shorter to type |
| `bzcat file.bz2` | Decompress and print to stdout — original unchanged |

---

## bzip2 vs gzip

| | bzip2 | gzip |
|-|-------|------|
| Extension | `.bz2` | `.gz` |
| tar flag | `-j` | `-z` |
| Default level | `-9` (maximum) | `-6` (balanced) |
| Compression | Better on text | Faster overall |
| Speed | Slower | Faster |
| Decompress shortcut | `bunzip2` | `gunzip` |
| Stdout read | `bzcat` | `zcat` |

---

## bzip2 and tar

bzip2 compresses single files only — it does not bundle multiple files. For multiple files, combine with `tar`:

| Goal | Command |
|------|---------|
| Bundle and compress | `tar -cjf archive.tar.bz2 folder/` |
| Decompress and extract | `tar -xjf archive.tar.bz2` |
| bzip2 an existing tar | `bzip2 archive.tar` |
| Inspect a `.tar.bz2` without extracting | `tar -tjf archive.tar.bz2` |

---

## Gotchas

| | |
|--|--|
| ⚠️ | **bzip2 deletes the original** — use `-k` if you need to keep the source file |
| ⚠️ | **bzip2 only handles one file at a time** — to compress a folder use `tar -cjf` not `bzip2 folder/` |
| ⚠️ | **`-c` does not create a file** — it writes to stdout, redirect it: `bzip2 -c file.txt > file.txt.bz2` |
| ⚠️ | **Default compression is `-9`** — bzip2 is slower than gzip by default because it always tries hardest |
| ✅ | **`bunzip2` and `bzip2 -d` are identical** — use whichever is easier to remember |
| ✅ | **`bzcat` is safe for inspection** — decompresses to stdout without touching the `.bz2` file |
| ✅ | **`-t` tests integrity** — useful to verify an archive is not corrupted before decompressing |
