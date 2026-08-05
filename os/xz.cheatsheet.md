# `xz` — bash cheat sheet

> Compress and decompress files using xz from the command line

---

## Basic syntax

```bash
xz file.txt          # compress — replaces file.txt with file.txt.xz
xz -d file.txt.xz   # decompress — replaces file.txt.xz with file.txt
unxz file.txt.xz    # decompress — same as xz -d
```

> ⚠️ xz replaces the original file by default. Use `-k` to keep it.

---

## Essential flags

| Flag | Meaning |
|------|---------|
| `-d` | **d**ecompress |
| `-k` | **k**eep the original file |
| `-c` | write to stdout — don't touch the original |
| `-v` | **v**erbose — show compression ratio and progress |
| `-t` | **t**est integrity without decompressing |
| `-l` | **l**ist compression info without decompressing |
| `-1` to `-9` | compression level — `-1` fastest, `-9` smallest (default is `-6`) |

---

## Compress vs decompress side by side

| | Compress | Decompress |
|-|----------|------------|
| Basic | `xz file.txt` | `xz -d file.txt.xz` |
| Keep original | `xz -k file.txt` | `xz -dk file.txt.xz` |
| Write to stdout | `xz -c file.txt > file.txt.xz` | `xz -dc file.txt.xz > file.txt` |
| Verbose | `xz -v file.txt` | `xz -dv file.txt.xz` |
| Multiple files | `xz file1 file2 file3` | `xz -d file1.xz file2.xz` |

---

## Common patterns

| Goal | Command |
|------|---------|
| Compress a file | `xz file.txt` |
| Decompress a file | `xz -d file.txt.xz` |
| Decompress with unxz | `unxz file.txt.xz` |
| Keep original when compressing | `xz -k file.txt` |
| Compress and pipe to another command | `xz -c file.txt \| wc -c` |
| Decompress and pipe to another command | `xz -dc file.txt.xz \| grep "password"` |
| Test archive integrity | `xz -t file.txt.xz` |
| List compression info | `xz -l file.txt.xz` |
| Maximum compression | `xz -9 file.txt` |
| Fastest compression | `xz -1 file.txt` |

---

## xz vs unxz vs xzcat

| Command | What it does |
|---------|-------------|
| `xz file` | Compress file, replace with `.xz` |
| `xz -d file.xz` | Decompress file, replace with original |
| `unxz file.xz` | Same as `xz -d` — shorter to type |
| `xzcat file.xz` | Decompress and print to stdout — original unchanged |

---

## xz vs gzip vs bzip2

| | xz | bzip2 | gzip |
|-|----|----|------|
| Extension | `.xz` | `.bz2` | `.gz` |
| tar flag | `-J` | `-j` | `-z` |
| Default level | `-6` | `-9` | `-6` |
| Compression ratio | Best | Middle | Fastest |
| Speed | Slowest | Slower | Fastest |
| Decompress shortcut | `unxz` | `bunzip2` | `gunzip` |
| Stdout read | `xzcat` | `bzcat` | `zcat` |
| Integrity test | `xz -t` | `bzip2 -t` | *(not available)* |
| List info | `xz -l` | *(not available)* | `gzip -l` |

---

## xz and tar

xz compresses single files only — it does not bundle multiple files. For multiple files, combine with `tar`:

| Goal | Command |
|------|---------|
| Bundle and compress | `tar -cJf archive.tar.xz folder/` |
| Decompress and extract | `tar -xJf archive.tar.xz` |
| xz an existing tar | `xz archive.tar` |
| Inspect a `.tar.xz` without extracting | `tar -tJf archive.tar.xz` |

> ⚠️ The `-J` flag for xz in tar is uppercase. `-j` is bzip2, `-z` is gzip.

---

## Gotchas

| | |
|--|--|
| ⚠️ | **xz deletes the original** — use `-k` if you need to keep the source file |
| ⚠️ | **xz only handles one file at a time** — to compress a folder use `tar -cJf` not `xz folder/` |
| ⚠️ | **`-c` does not create a file** — it writes to stdout, redirect it: `xz -c file.txt > file.txt.xz` |
| ⚠️ | **`-J` not `-j` in tar** — uppercase `J` for xz, lowercase `j` for bzip2. Easy to mix up. |
| ⚠️ | **xz is the slowest of the three** — higher compression ratio comes at a significant speed cost, especially at `-9` |
| ✅ | **`unxz` and `xz -d` are identical** — use whichever is easier to remember |
| ✅ | **`xzcat` is safe for inspection** — decompresses to stdout without touching the `.xz` file |
| ✅ | **`xz -l` gives useful metadata** — shows compressed size, uncompressed size, ratio, and integrity check type |
