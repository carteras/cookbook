# Cognitive task analysis — `bzip2` compress and decompress

> How a student thinks through compressing and decompressing files with bzip2

---

## Goal

| Overall goal |
|---|
| Use `bzip2` to compress a file and decompress it again — without accidentally losing the original |

---

## Subgoals

| Subgoal 1 | Subgoal 2 | Subgoal 3 |
|-----------|-----------|-----------|
| **Decide what bzip2 can do** | **Choose the right operation** | **Control what happens to the original** |
| bzip2 compresses single files only — not folders. For folders, use tar first. | Compress with `bzip2 file` or decompress with `bzip2 -d file.bz2` | By default bzip2 deletes the original. Use `-k` to keep it or `-c` to write to stdout. |

---

## Decisions — compressing

| Decision | Question | Answer |
|----------|----------|--------|
| 1 | Is it a single file or a folder? | Single file → `bzip2`. Folder → `tar -cjf` instead. |
| 2 | Keep the original? | Yes → add `-k`. No → omit it (default deletes original). |
| 3 | How much compression? | Default (`-9`) is maximum — bzip2 always tries hardest unless told otherwise. Use `-1` for fastest. |
| 4 | Write to a specific output name? | Use `-c` and redirect: `bzip2 -c file.txt > newname.bz2` |

---

## Decisions — decompressing

| Decision | Question | Answer |
|----------|----------|--------|
| 1 | `bzip2 -d` or `bunzip2`? | Both do the same thing — use whichever is easier to remember |
| 2 | Keep the `.bz2` file? | Yes → add `-k`. No → omit it (default deletes `.bz2`). |
| 3 | Just want to read the contents? | Use `bzcat file.bz2` or `bzip2 -dc file.bz2` — prints to stdout, nothing is deleted |
| 4 | Want to pipe the contents? | Use `bzip2 -dc file.bz2 \| grep "word"` — decompress directly into the next command |
| 5 | Want to check integrity first? | Use `bzip2 -t file.bz2` before decompressing |

---

## Actions — compress a file

| Step | Action | Detail |
|------|--------|--------|
| 01 | Check it is a single file | If it is a folder, use `tar -cjf` instead |
| 02 | Decide whether to keep the original | Add `-k` if you need the original file to survive |
| 03 | Run bzip2 | `bzip2 -k file.txt` |
| 04 | Verify | `ls` — you should see both `file.txt` and `file.txt.bz2` |

---

## Actions — decompress a file

| Step | Action | Detail |
|------|--------|--------|
| 01 | Confirm it is a bzip2 file | `xxd -l 3 file.bz2` — should show `42 5a 68` (`BZh`) |
| 02 | Optionally test integrity | `bzip2 -t file.bz2` — verifies the archive before touching anything |
| 03 | Decide whether to keep the `.bz2` | Add `-k` to keep the compressed file |
| 04 | Run decompress | `bzip2 -dk file.txt.bz2` |
| 05 | Verify | `ls` — you should see `file.txt` (and `file.txt.bz2` if you used `-k`) |
| 06 | Read the result | `cat file.txt` |

---

## The mental model

| | Compress | Decompress |
|-|----------|------------|
| Input | `file.txt` | `file.txt.bz2` |
| Output | `file.txt.bz2` | `file.txt` |
| Default behaviour | deletes `file.txt` | deletes `file.txt.bz2` |
| Keep both | `bzip2 -k file.txt` | `bzip2 -dk file.txt.bz2` |
| Stdout only | `bzip2 -c file.txt` | `bzip2 -dc file.txt.bz2` |

---

## Worked example — decompress and search

```bash
# You have a compressed log file and want to find a line

# Option 1 — decompress first, then search
bzip2 -dk access.log.bz2      # keep the .bz2, create access.log
grep "ERROR" access.log

# Option 2 — pipe directly, no files created
bzip2 -dc access.log.bz2 | grep "ERROR"

# Option 3 — use bzcat
bzcat access.log.bz2 | grep "ERROR"
```

All three produce the same result. Options 2 and 3 are faster for one-off searches because no intermediate file is written to disk.

---

## Worked example — compress and verify

```bash
# Compress a file, keep the original
bzip2 -k report.txt

# Check what bzip2 created
ls -lh report.txt report.txt.bz2

# Test the archive is not corrupted
bzip2 -t report.txt.bz2
# (no output = test passed)
```

---

## bzip2 vs gzip — knowing which to use

| Situation | Tool |
|-----------|------|
| Speed matters more than size | `gzip` |
| Size matters more than speed | `bzip2` |
| Compressing text files | `bzip2` often wins on ratio |
| Compressing binary files | `gzip` is usually comparable and faster |
| tar with gzip | `tar -czf archive.tar.gz folder/` |
| tar with bzip2 | `tar -cjf archive.tar.bz2 folder/` |

---

## Parallel to gzip — same habits apply

| Habit | gzip | bzip2 |
|-------|------|-------|
| Keep original | `gzip -k` | `bzip2 -k` |
| Decompress shortcut | `gunzip` | `bunzip2` |
| Read without extracting | `zcat` | `bzcat` |
| Pipe output | `gzip -dc file.gz \|` | `bzip2 -dc file.bz2 \|` |
| tar flag | `-z` | `-j` |

---

## Common errors

| | Error | Fix |
|--|-------|-----|
| ⚠️ | Running `bzip2 folder/` expecting a compressed folder | bzip2 doesn't bundle directories — use `tar -cjf archive.tar.bz2 folder/` |
| ⚠️ | Original file is gone after `bzip2 file.txt` | Use `bzip2 -k file.txt` to keep the original |
| ⚠️ | `bzip2 -c file.txt` produces no file | `-c` writes to stdout — redirect it: `bzip2 -c file.txt > file.txt.bz2` |
| ⚠️ | Using `-z` flag with tar for a `.tar.bz2` | bzip2 uses `-j` not `-z` — `tar -xjf archive.tar.bz2` |
| ⚠️ | Trying to `bzip2 -d` a `.tar.bz2` to get the folder | `bzip2 -d` only removes the bzip2 layer, leaving a `.tar` — use `tar -xjf` for the full extraction |
| ✅ | Use `bzcat` or `bzip2 -dc` to read without risk | Nothing is deleted and no intermediate files are created |
| ✅ | Use `bzip2 -t` before decompressing important files | Catches corruption before you commit to extracting |
