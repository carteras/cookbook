# Cognitive task analysis — `tar` extract and compress

> How a student thinks through creating and extracting tar archives

---

## Goal

| Overall goal |
|---|
| Use `tar` to compress files into an archive and extract files from an archive — including stripping leading directory levels on extraction |

---

## Subgoals

| Subgoal 1 | Subgoal 2 | Subgoal 3 |
|-----------|-----------|-----------|
| **Choose the right operation** | **Choose the right compression** | **Control where files land** |
| Decide between create (`-c`) and extract (`-x`) before anything else | Match the compression flag to the archive format — `-z` for gzip, `-j` for bzip2, `-J` for xz | Use `-C` to target a directory and `--strip-components` to remove unwanted path levels |

---

## Decisions — creating an archive

| Decision | Question | Answer |
|----------|----------|--------|
| 1 | Create or extract? | Create — use `-c` |
| 2 | Which compression? | gzip (`-z`) is the most common default. Match to the target extension. |
| 3 | What is the output filename? | Pass it to `-f` — e.g. `-f archive.tar.gz` |
| 4 | What files to include? | List them after the archive name — `folder/` or `file1 file2` |
| 5 | Do I want to see progress? | Add `-v` for verbose output |

---

## Decisions — extracting an archive

| Decision | Question | Answer |
|----------|----------|--------|
| 1 | Create or extract? | Extract — use `-x` |
| 2 | Which compression? | Match to the file extension — `.tar.gz` = `-z`, `.tar.bz2` = `-j`, `.tar.xz` = `-J` |
| 3 | Where should files land? | Current directory by default — use `-C /target` to specify a destination |
| 4 | What does the archive contain? | Run `tar -tzf archive.tar.gz` first to inspect before extracting |
| 5 | Are there unwanted directory levels? | Use `--strip-components=N` to remove N leading path levels |

---

## Actions — create an archive

| Step | Action | Detail |
|------|--------|--------|
| 01 | Start with `tar -czf` | `-c` create, `-z` gzip, `-f` filename follows |
| 02 | Name the archive | `archive.tar.gz` — include the extension so the format is clear |
| 03 | List what to include | `folder/` or `file1 file2` — comes after the archive name |
| 04 | Run it | `tar -czf archive.tar.gz folder/` |
| 05 | Verify | `tar -tzf archive.tar.gz` — list contents to confirm |

---

## Actions — extract an archive

| Step | Action | Detail |
|------|--------|--------|
| 01 | Inspect first | `tar -tzf archive.tar.gz` — see the path structure before extracting |
| 02 | Note the directory depth | Count leading path components — e.g. `project/src/file.sh` has 2 levels above `file.sh` |
| 03 | Decide on strip level | Do you want `project/src/file.sh`, `src/file.sh`, or just `file.sh`? |
| 04 | Choose your destination | Current directory or `-C /target/dir` |
| 05 | Run the extract | `tar -xzf archive.tar.gz -C /target --strip-components=2` |
| 06 | Verify | `ls /target` — confirm the files landed where expected |

---

## Understanding `--strip-components`

### What the archive contains

```bash
$ tar -tzf archive.tar.gz
project/src/main.sh
project/src/lib.sh
project/README.md
```

Three files, two directory levels above the scripts (`project/src/`).

### What each strip level produces

| Command | Files extracted | Path result |
|---------|----------------|-------------|
| No strip | all 3 files | `project/src/main.sh`, `project/README.md` |
| `--strip-components=1` | all 3 files | `src/main.sh`, `README.md` |
| `--strip-components=2` | 2 files | `main.sh`, `lib.sh` — `README.md` is skipped (only 1 level deep) |

### The mental model

```
archive path:    project / src / main.sh
                 ───────   ───   ───────
strip level:        1       2    (kept)
```

`--strip-components=N` removes the first N path segments from every file. Files that don't have N segments to strip are silently dropped.

---

## Worked example — inspect then extract with strip

```bash
# Step 1 — inspect the archive structure
$ tar -tzf archive.tar.gz
release/bin/tool.sh
release/bin/helper.sh
release/docs/readme.txt

# Step 2 — decide: we only want the scripts, not release/bin/ prefix
# files are 2 levels deep (release/bin/) above the filenames

# Step 3 — extract, strip 2 levels, put files in /opt/tool
$ tar -xzf archive.tar.gz \
    --strip-components=2 \
    -C /opt/tool

# Step 4 — verify
$ ls /opt/tool
tool.sh  helper.sh
# readme.txt was silently dropped — only 2 levels deep (release/docs/)
```

---

## The mental model — create vs extract

| | Create | Extract |
|-|--------|---------|
| Core flag | `-c` | `-x` |
| `-f` points to | the archive you are creating | the archive you are reading |
| Files listed after `-f archive` | what goes in | not needed (extracts everything) |
| `-C` | not used | where files land |
| `--strip-components` | not used | removes leading path levels |
| `-t` | not applicable | inspect without extracting |

---

## Common errors

| | Error | Fix |
|--|-------|-----|
| ⚠️ | Using `-z` on a `.tar.bz2` file | Match flag to format: `-j` for bzip2, `-J` for xz |
| ⚠️ | Expecting `README.md` after `--strip-components=2` when it is only 1 level deep | Files with fewer levels than N are silently skipped — check with `-t` first |
| ⚠️ | Extracting into the wrong directory | Use `-C /target` to specify where files should land |
| ⚠️ | `-f` not followed immediately by the archive name | `-czf archive.tar.gz` works, `-cfz archive.tar.gz` does not |
| ✅ | Always inspect before extracting | `tar -tzf archive.tar.gz` takes seconds and prevents surprises |
