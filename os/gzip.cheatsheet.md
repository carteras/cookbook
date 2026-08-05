# `gzip` — bash cheat sheet

> Compress and decompress files using gzip from the command line

---

## Basic syntax

```bash
gzip file.txt          # compress — replaces file.txt with file.txt.gz
gzip -d file.txt.gz    # decompress — replaces file.txt.gz with file.txt
gunzip file.txt.gz     # decompress — same as gzip -d
```

> ⚠️ gzip replaces the original file by default. Use `-k` to keep it.

---

## Essential flags

| Flag | Meaning |
|------|---------|
| `-d` | **d**ecompress |
| `-k` | **k**eep the original file |
| `-c` | write to stdout — don't touch the original |
| `-v` | **v**erbose — show compression ratio |
| `-r` | **r**ecursive — compress all files in a directory |
| `-l` | **l**ist compression info without decompressing |
| `-1` to `-9` | compression level — `-1` fastest, `-9` smallest |

---

## Compress vs decompress side by side

| | Compress | Decompress |
|-|----------|------------|
| Basic | `gzip file.txt` | `gzip -d file.txt.gz` |
| Keep original | `gzip -k file.txt` | `gzip -dk file.txt.gz` |
| Write to stdout | `gzip -c file.txt > file.txt.gz` | `gzip -dc file.txt.gz > file.txt` |
| Verbose | `gzip -v file.txt` | `gzip -dv file.txt.gz` |
| Multiple files | `gzip file1 file2 file3` | `gzip -d file1.gz file2.gz` |

---

## Common patterns

| Goal | Command |
|------|---------|
| Compress a file | `gzip file.txt` |
| Decompress a file | `gzip -d file.txt.gz` |
| Decompress with gunzip | `gunzip file.txt.gz` |
| Keep the original when compressing | `gzip -k file.txt` |
| Compress and pipe to another command | `gzip -c file.txt \| wc -c` |
| Decompress and pipe to another command | `gzip -dc file.txt.gz \| grep "password"` |
| Inspect without decompressing | `gzip -l file.txt.gz` |
| Maximum compression | `gzip -9 file.txt` |
| Fastest compression | `gzip -1 file.txt` |

---

## gzip vs gunzip vs zcat

| Command | What it does |
|---------|-------------|
| `gzip file` | Compress file, replace with `.gz` |
| `gzip -d file.gz` | Decompress file, replace with original |
| `gunzip file.gz` | Same as `gzip -d` — just shorter to type |
| `zcat file.gz` | Decompress and print to stdout — original unchanged |

---

## gzip and tar

gzip compresses single files only — it does not bundle multiple files. For multiple files, combine with `tar`:

| Goal | Command |
|------|---------|
| Bundle and compress | `tar -czf archive.tar.gz folder/` |
| Decompress and extract | `tar -xzf archive.tar.gz` |
| gzip an existing tar | `gzip archive.tar` |
| Inspect a .tar.gz without extracting | `tar -tzf archive.tar.gz` |

---

## Gotchas

| | |
|--|--|
| ⚠️ | **gzip deletes the original** — always use `-k` if you need to keep the source file |
| ⚠️ | **gzip only handles one file at a time** — to compress a folder, use `tar -czf` not `gzip folder/` |
| ⚠️ | **`-c` does not create a file** — it writes to stdout, so you must redirect: `gzip -c file.txt > file.txt.gz` |
| ✅ | **`gunzip` and `gzip -d` are identical** — use whichever is easier to remember |
| ✅ | **`zcat` is safe for inspection** — it decompresses to stdout without touching the `.gz` file |
| ✅ | **`gzip -l` is quick metadata** — shows compressed size, uncompressed size, and ratio without decompressing |
