# Cognitive task analysis — `gzip` compress and decompress

> How a student thinks through compressing and decompressing files with gzip

---

## Goal

| Overall goal |
|---|
| Use `gzip` to compress a file and decompress it again — without accidentally losing the original |

---

## Subgoals

| Subgoal 1 | Subgoal 2 | Subgoal 3 |
|-----------|-----------|-----------|
| **Decide what gzip can do** | **Choose the right operation** | **Control what happens to the original** |
| gzip compresses single files only — not folders. For folders, use tar first. | Compress with `gzip file` or decompress with `gzip -d file.gz` | By default gzip deletes the original. Use `-k` to keep it or `-c` to write to stdout. |

---

## Decisions — compressing

| Decision | Question | Answer |
|----------|----------|--------|
| 1 | Is it a single file or a folder? | Single file → `gzip`. Folder → `tar -czf` instead. |
| 2 | Keep the original? | Yes → add `-k`. No → omit it (default deletes original). |
| 3 | How much compression? | Default is fine for most cases. `-9` for smallest, `-1` for fastest. |
| 4 | Write to a specific output name? | Use `-c` and redirect: `gzip -c file.txt > newname.gz` |

---

## Decisions — decompressing

| Decision | Question | Answer |
|----------|----------|--------|
| 1 | `gzip -d` or `gunzip`? | Both do the same thing — use whichever is easier to remember |
| 2 | Keep the `.gz` file? | Yes → add `-k`. No → omit it (default deletes `.gz`). |
| 3 | Just want to read the contents? | Use `zcat file.gz` or `gzip -dc file.gz` — prints to stdout, nothing is deleted |
| 4 | Want to pipe the contents? | Use `gzip -dc file.gz \| grep "word"` — decompress directly into the next command |

---

## Actions — compress a file

| Step | Action | Detail |
|------|--------|--------|
| 01 | Check it is a single file | If it is a folder, use `tar -czf` instead |
| 02 | Decide whether to keep the original | Add `-k` if you need the original file to survive |
| 03 | Run gzip | `gzip -k file.txt` |
| 04 | Verify | `ls` — you should see both `file.txt` and `file.txt.gz` |
| 05 | Optional: check compression ratio | `gzip -l file.txt.gz` |

---

## Actions — decompress a file

| Step | Action | Detail |
|------|--------|--------|
| 01 | Confirm it is a gzip file | `xxd -l 2 file.gz` — should show `1f 8b` |
| 02 | Decide whether to keep the `.gz` | Add `-k` to keep the compressed file |
| 03 | Run decompress | `gzip -dk file.txt.gz` |
| 04 | Verify | `ls` — you should see `file.txt` (and `file.txt.gz` if you used `-k`) |
| 05 | Read the result | `cat file.txt` |

---

## The mental model

| | Compress | Decompress |
|-|----------|------------|
| Input | `file.txt` | `file.txt.gz` |
| Output | `file.txt.gz` | `file.txt` |
| Default behaviour | deletes `file.txt` | deletes `file.txt.gz` |
| Keep both | `gzip -k file.txt` | `gzip -dk file.txt.gz` |
| Stdout only | `gzip -c file.txt` | `gzip -dc file.txt.gz` |

---

## Worked example — decompress and search

```bash
# You have a compressed log file and want to find a line

# Option 1 — decompress first, then search
gzip -dk access.log.gz       # keep the .gz, create access.log
grep "ERROR" access.log

# Option 2 — pipe directly, no files created
gzip -dc access.log.gz | grep "ERROR"

# Option 3 — use zcat
zcat access.log.gz | grep "ERROR"
```

All three produce the same result. Option 2 and 3 are faster for one-off searches because no intermediate file is written to disk.

---

## Worked example — compress and verify

```bash
# Compress a file, keep the original
gzip -k -9 report.txt

# Check what gzip created
ls -lh report.txt report.txt.gz

# Inspect compression stats
gzip -l report.txt.gz
#          compressed        uncompressed  ratio uncompressed_name
#                1234               5678  78.3% report.txt
```

---

## gzip vs tar — knowing which to use

| Situation | Tool |
|-----------|------|
| Compress a single file | `gzip file.txt` |
| Compress multiple files | `tar -czf archive.tar.gz file1 file2` |
| Compress a folder | `tar -czf archive.tar.gz folder/` |
| Decompress a `.gz` file | `gzip -d file.gz` or `gunzip file.gz` |
| Decompress a `.tar.gz` | `tar -xzf archive.tar.gz` |
| Read without decompressing | `zcat file.gz` or `gzip -l file.gz` |

---

## Common errors

| | Error | Fix |
|--|-------|-----|
| ⚠️ | Running `gzip folder/` expecting a compressed folder | gzip doesn't bundle directories — use `tar -czf archive.tar.gz folder/` |
| ⚠️ | Original file is gone after `gzip file.txt` | Use `gzip -k file.txt` to keep the original |
| ⚠️ | `gzip -c file.txt` produces no file | `-c` writes to stdout — redirect it: `gzip -c file.txt > file.txt.gz` |
| ⚠️ | Trying to `gzip -d` a `.tar.gz` to get the folder contents | `gzip -d` only removes the gzip layer, leaving a `.tar` — use `tar -xzf` for the full extraction |
| ✅ | Use `zcat` or `gzip -dc` to read without risk | Nothing is deleted and no intermediate files are created |
