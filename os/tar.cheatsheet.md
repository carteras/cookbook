# `tar` — bash cheat sheet

> Create and extract tar archives from the command line

---

## Basic syntax

```bash
tar [flags] [archive] [files]

tar -czf archive.tar.gz files/   # compress
tar -xzf archive.tar.gz          # extract
```

---

## The essential flags

| Flag | Meaning |
|------|---------|
| `-c` | **c**reate a new archive |
| `-x` | e**x**tract from an archive |
| `-f` | **f**ilename — always followed by the archive name |
| `-z` | filter through g**z**ip (`.tar.gz` / `.tgz`) |
| `-j` | filter through b**z**ip2 (`.tar.bz2`) |
| `-J` | filter through **xz** (`.tar.xz`) |
| `-v` | **v**erbose — print each file as it is processed |
| `-t` | lis**t** contents without extracting |
| `--strip-components=N` | strip N leading directory levels when extracting |

> ✅ `-f` must always be followed immediately by the archive filename. It is almost always required.

---

## Create vs extract side by side

| | Create | Extract |
|-|--------|---------|
| Flag | `-c` | `-x` |
| gzip | `-czf archive.tar.gz folder/` | `-xzf archive.tar.gz` |
| bzip2 | `-cjf archive.tar.bz2 folder/` | `-xjf archive.tar.bz2` |
| xz | `-cJf archive.tar.xz folder/` | `-xJf archive.tar.xz` |
| uncompressed | `-cf archive.tar folder/` | `-xf archive.tar` |
| verbose | add `-v` anywhere | add `-v` anywhere |

---

## Common patterns

| Goal | Command |
|------|---------|
| Create a gzip archive | `tar -czf archive.tar.gz folder/` |
| Extract a gzip archive | `tar -xzf archive.tar.gz` |
| Extract to a specific directory | `tar -xzf archive.tar.gz -C /target/dir` |
| List contents without extracting | `tar -tzf archive.tar.gz` |
| Extract and strip 1 directory level | `tar -xzf archive.tar.gz --strip-components=1` |
| Extract and strip 2 directory levels | `tar -xzf archive.tar.gz --strip-components=2` |
| Verbose extract | `tar -xzvf archive.tar.gz` |

---

## `--strip-components=N`

When a tar archive is created it records the full path of each file. Stripping removes N leading directories from those paths on extraction.

```
Archive contains:        strip-components=1:    strip-components=2:
project/src/main.sh  →  src/main.sh         →  main.sh
project/src/lib.sh   →  src/lib.sh          →  lib.sh
project/README.md    →  README.md           →  (skipped — not enough levels)
```

> ⚠️ Files with fewer path components than N are silently skipped during extraction.

---

## Compression format quick reference

| Extension | Compression | Flag |
|-----------|-------------|------|
| `.tar` | none | *(no flag)* |
| `.tar.gz` or `.tgz` | gzip | `-z` |
| `.tar.bz2` | bzip2 | `-j` |
| `.tar.xz` | xz | `-J` |

---

## Gotchas

| | |
|--|--|
| ⚠️ | **`-f` must come last in a flag group** when combined — `tar -xzfv` fails, `tar -xzvf` works. Or just write them separately. |
| ⚠️ | **Wrong compression flag** — using `-z` on a `.tar.bz2` will error. Match the flag to the format. |
| ⚠️ | **`--strip-components` silently drops files** — any file with fewer path levels than N is skipped with no warning. |
| ⚠️ | **Forgetting `-C`** — without it, tar extracts into the current directory, which can create unexpected folders. |
| ✅ | **List before extracting** — use `-t` to inspect an archive's structure before committing to `-x`. |
| ✅ | **Modern tar detects compression automatically** — `tar -xf archive.tar.gz` works without `-z` on most systems, but being explicit is safer. |
