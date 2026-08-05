# Cognitive task analysis — `zip` and `unzip`

> How a student thinks through compressing and extracting zip archives

---

## Goal

| Overall goal |
|---|
| Use `zip` to compress files or folders into an archive and `unzip` to extract them — understanding how zip differs from gzip, bzip2, and xz |

---

## Subgoals

| Subgoal 1 | Subgoal 2 | Subgoal 3 |
|-----------|-----------|-----------|
| **Understand what makes zip different** | **Choose the right operation** | **Control where files land** |
| zip handles folders directly, keeps originals by default, and is a different tool to gzip/bzip2/xz | Compress with `zip` or extract with `unzip` — they are separate commands, not flags on the same tool | Use `-d /target` to control the destination, `-j` to flatten paths |

---

## Decisions — compressing

| Decision | Question | Answer |
|----------|----------|--------|
| 1 | Single file or folder? | Both work with zip directly — add `-r` for folders |
| 2 | Do I need to keep the originals? | Yes by default — zip does not delete originals unless you use `-m` |
| 3 | Do I need encryption? | Add `-e` — zip will prompt for a password |
| 4 | Do I want to preserve directory structure? | Yes by default — use `-j` to flatten everything into one level |
| 5 | Compression level? | Default `-6` is fine. `-9` for smallest, `-1` for fastest. |

---

## Decisions — extracting

| Decision | Question | Answer |
|----------|----------|--------|
| 1 | Where should files land? | Current directory by default — use `-d /target` to specify |
| 2 | What does the archive contain? | Run `unzip -l archive.zip` first to inspect before extracting |
| 3 | Overwrite existing files? | `unzip` prompts by default — use `-o` to always overwrite, `-n` to never |
| 4 | Extract everything or just some files? | List specific filenames after the archive to extract only those |
| 5 | Password protected? | Use `-P password` to supply it inline |

---

## Actions — compress a folder

| Step | Action | Detail |
|------|--------|--------|
| 01 | Remember the `-r` flag | Without it, zip adds the folder entry but not its contents |
| 02 | Name the archive first | `zip archive.zip` — the archive name comes before the files |
| 03 | List what to include | `folder/` or `file1 file2` — comes after the archive name |
| 04 | Run zip | `zip -r archive.zip folder/` |
| 05 | Verify | `unzip -l archive.zip` — list contents to confirm |

---

## Actions — extract an archive

| Step | Action | Detail |
|------|--------|--------|
| 01 | Inspect first | `unzip -l archive.zip` — see what is inside before extracting |
| 02 | Choose destination | Current directory or `-d /target` |
| 03 | Decide on overwrite behaviour | Default prompts — add `-o` or `-n` to automate |
| 04 | Run unzip | `unzip archive.zip -d /target` |
| 05 | Verify | `ls /target` — confirm files landed where expected |

---

## The mental model — zip vs the others

| | zip | gzip / bzip2 / xz |
|-|-----|-------------------|
| Handles folders | Yes — `-r` | No — needs tar |
| Two commands | `zip` and `unzip` | One tool with flags (`-d` to decompress) |
| Keeps originals | Yes — default | No — deletes by default |
| tar needed | No | Yes for folders |
| Compression | Lower ratio | Higher ratio |

The biggest mental shift from gzip/bzip2/xz is that **zip and unzip are separate commands** — you do not add a `-d` flag to `zip` to decompress. You use `unzip` instead.

---

## Worked example — compress and inspect

```bash
# Compress a folder
zip -r project.zip src/

# Verify contents
unzip -l project.zip
# Archive:  project.zip
#   Length      Date    Time    Name
# ---------  ---------- -----   ----
#      1234  2024-01-01 10:00   src/main.sh
#       567  2024-01-01 10:00   src/lib.sh
# ---------                     -------
#      1801                     2 files
```

---

## Worked example — extract to a specific directory

```bash
# Inspect first
unzip -l archive.zip

# Extract to /opt/project
unzip archive.zip -d /opt/project

# Verify
ls /opt/project
```

---

## Worked example — extract a single file

```bash
# Only extract one file from the archive
unzip archive.zip src/main.sh -d /opt/project

# The directory structure is preserved by default
ls /opt/project/src
# main.sh

# Use -j to flatten — extract the file without the src/ directory
unzip -j archive.zip src/main.sh -d /opt/project
ls /opt/project
# main.sh
```

---

## Parallel to gzip, bzip2, xz — what carries over and what doesn't

| Habit | gzip / bzip2 / xz | zip |
|-------|-------------------|-----|
| Keep original | need `-k` | default behaviour |
| Read without extracting | `zcat` / `bzcat` / `xzcat` | `unzip -l` (list only) |
| Pipe output | `gzip -dc \|` | `unzip -p archive.zip file \|` |
| Integrity test | `xz -t` / `bzip2 -t` | `unzip -t archive.zip` |
| Decompress command | same tool with `-d` | separate `unzip` command |
| Handles folders | no — needs tar | yes — use `-r` |

---

## Common errors

| | Error | Fix |
|--|-------|-----|
| ⚠️ | `zip archive.zip folder/` without `-r` | Add `-r` — without it the folder contents are not included |
| ⚠️ | Trying `zip -d archive.zip` to decompress | `-d` in zip *deletes a file from the archive* — use `unzip` to extract |
| ⚠️ | Files extracted into wrong place | Use `-d /target` with unzip to control the destination |
| ⚠️ | Name collisions when using `-j` | Flattening with `-j` silently overwrites files with the same name |
| ⚠️ | Using `-m` unintentionally | `-m` deletes source files after zipping — omit it unless you specifically want this |
| ✅ | `unzip -l` before extracting | Inspect the archive structure so you know what you are getting |
| ✅ | `unzip -t` to test integrity | Verifies the archive is not corrupted before committing to extraction |
