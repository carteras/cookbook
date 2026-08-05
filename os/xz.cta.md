# Cognitive task analysis — `xz` compress and decompress

> How a student thinks through compressing and decompressing files with xz

---

## Goal

| Overall goal |
|---|
| Use `xz` to compress a file and decompress it again — without accidentally losing the original |

---

## Subgoals

| Subgoal 1 | Subgoal 2 | Subgoal 3 |
|-----------|-----------|-----------|
| **Decide what xz can do** | **Choose the right operation** | **Control what happens to the original** |
| xz compresses single files only — not folders. For folders, use tar first. | Compress with `xz file` or decompress with `xz -d file.xz` | By default xz deletes the original. Use `-k` to keep it or `-c` to write to stdout. |

---

## Decisions — compressing

| Decision | Question | Answer |
|----------|----------|--------|
| 1 | Is it a single file or a folder? | Single file → `xz`. Folder → `tar -cJf` instead. |
| 2 | Keep the original? | Yes → add `-k`. No → omit it (default deletes original). |
| 3 | How much compression? | Default `-6` is balanced. Use `-9` for smallest output, `-1` for fastest. Note: xz at `-9` is very slow. |
| 4 | Write to a specific output name? | Use `-c` and redirect: `xz -c file.txt > newname.xz` |

---

## Decisions — decompressing

| Decision | Question | Answer |
|----------|----------|--------|
| 1 | `xz -d` or `unxz`? | Both do the same thing — use whichever is easier to remember |
| 2 | Keep the `.xz` file? | Yes → add `-k`. No → omit it (default deletes `.xz`). |
| 3 | Just want to read the contents? | Use `xzcat file.xz` or `xz -dc file.xz` — prints to stdout, nothing is deleted |
| 4 | Want to pipe the contents? | Use `xz -dc file.xz \| grep "word"` — decompress directly into the next command |
| 5 | Want to check integrity first? | Use `xz -t file.xz` before decompressing |

---

## Actions — compress a file

| Step | Action | Detail |
|------|--------|--------|
| 01 | Check it is a single file | If it is a folder, use `tar -cJf` instead |
| 02 | Decide whether to keep the original | Add `-k` if you need the original file to survive |
| 03 | Run xz | `xz -k file.txt` |
| 04 | Verify | `ls` — you should see both `file.txt` and `file.txt.xz` |
| 05 | Optional: check compression info | `xz -l file.txt.xz` |

---

## Actions — decompress a file

| Step | Action | Detail |
|------|--------|--------|
| 01 | Confirm it is an xz file | `xxd -l 6 file.xz` — should show `fd 37 7a 58 5a 00` |
| 02 | Optionally test integrity | `xz -t file.xz` — verifies the archive before touching anything |
| 03 | Decide whether to keep the `.xz` | Add `-k` to keep the compressed file |
| 04 | Run decompress | `xz -dk file.txt.xz` |
| 05 | Verify | `ls` — you should see `file.txt` (and `file.txt.xz` if you used `-k`) |
| 06 | Read the result | `cat file.txt` |

---

## The mental model

| | Compress | Decompress |
|-|----------|------------|
| Input | `file.txt` | `file.txt.xz` |
| Output | `file.txt.xz` | `file.txt` |
| Default behaviour | deletes `file.txt` | deletes `file.txt.xz` |
| Keep both | `xz -k file.txt` | `xz -dk file.txt.xz` |
| Stdout only | `xz -c file.txt` | `xz -dc file.txt.xz` |

---

## Worked example — decompress and search

```bash
# You have a compressed log file and want to find a line

# Option 1 — decompress first, then search
xz -dk access.log.xz          # keep the .xz, create access.log
grep "ERROR" access.log

# Option 2 — pipe directly, no files created
xz -dc access.log.xz | grep "ERROR"

# Option 3 — use xzcat
xzcat access.log.xz | grep "ERROR"
```

All three produce the same result. Options 2 and 3 are faster for one-off searches because no intermediate file is written to disk.

---

## Worked example — compress and inspect

```bash
# Compress a file, keep the original
xz -k report.txt

# Check what xz created
ls -lh report.txt report.txt.xz

# List compression metadata
xz -l report.txt.xz
# Strms  Blocks   Compressed Uncompressed  Ratio  Check   Filename
#     1       1      1,234 B      5,678 B  0.217  CRC64   report.txt.xz

# Test integrity
xz -t report.txt.xz
# (no output = test passed)
```

---

## The capital J problem

The most common mistake students make coming from gzip and bzip2 is using the wrong tar flag:

| Format | tar flag | Easy to remember |
|--------|----------|-----------------|
| gzip | `-z` | **z** for **z**ip-like |
| bzip2 | `-j` | lowercase j |
| xz | `-J` | UPPERCASE J |

```bash
# Wrong — this uses bzip2
tar -xjf archive.tar.xz

# Right — uppercase J for xz
tar -xJf archive.tar.xz
```

---

## Parallel to gzip and bzip2 — same habits apply

| Habit | gzip | bzip2 | xz |
|-------|------|-------|----|
| Keep original | `gzip -k` | `bzip2 -k` | `xz -k` |
| Decompress shortcut | `gunzip` | `bunzip2` | `unxz` |
| Read without extracting | `zcat` | `bzcat` | `xzcat` |
| Pipe output | `gzip -dc \|` | `bzip2 -dc \|` | `xz -dc \|` |
| tar flag | `-z` | `-j` | `-J` |
| Integrity test | *(none)* | `bzip2 -t` | `xz -t` |

---

## Common errors

| | Error | Fix |
|--|-------|-----|
| ⚠️ | Running `xz folder/` expecting a compressed folder | xz doesn't bundle directories — use `tar -cJf archive.tar.xz folder/` |
| ⚠️ | Original file is gone after `xz file.txt` | Use `xz -k file.txt` to keep the original |
| ⚠️ | `xz -c file.txt` produces no file | `-c` writes to stdout — redirect it: `xz -c file.txt > file.txt.xz` |
| ⚠️ | Using `-j` in tar for a `.tar.xz` | xz uses uppercase `-J` — `tar -xJf archive.tar.xz` |
| ⚠️ | Running `xz -9` and waiting a long time | xz at maximum compression is significantly slower than gzip or bzip2 — use `-1` or `-3` if speed matters |
| ✅ | Use `xzcat` or `xz -dc` to read without risk | Nothing is deleted and no intermediate files are created |
| ✅ | Use `xz -t` before decompressing important files | Catches corruption before you commit to extracting |
