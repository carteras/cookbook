# `zip` and `unzip` — bash cheat sheet

> Compress and decompress zip archives from the command line

---

## Basic syntax

```bash
zip archive.zip file.txt        # compress a file
zip -r archive.zip folder/      # compress a folder (recursive)
unzip archive.zip               # extract everything
unzip archive.zip -d /target    # extract to a specific directory
```

> ✅ Unlike gzip, bzip2, and xz — zip keeps the original file by default.

---

## Essential flags — zip

| Flag | Meaning |
|------|---------|
| `-r` | **r**ecursive — include folders and their contents |
| `-v` | **v**erbose — show files as they are added |
| `-e` | **e**ncrypt with a password |
| `-u` | **u**pdate — add or replace files in an existing archive |
| `-d` | **d**elete a file from an existing archive |
| `-m` | **m**ove — delete originals after adding to archive |
| `-j` | **j**unk paths — don't store directory structure |
| `-1` to `-9` | compression level — `-1` fastest, `-9` smallest (default `-6`) |

## Essential flags — unzip

| Flag | Meaning |
|------|---------|
| `-d /path` | extract to a specific **d**irectory |
| `-l` | **l**ist contents without extracting |
| `-v` | **v**erbose list with compression details |
| `-o` | **o**verwrite existing files without prompting |
| `-n` | **n**ever overwrite existing files |
| `-P password` | supply decryption **p**assword |
| `-j` | **j**unk paths — extract all files into one directory |

---

## zip vs unzip side by side

| | zip (compress) | unzip (extract) |
|-|----------------|-----------------|
| Single file | `zip archive.zip file.txt` | `unzip archive.zip` |
| Folder | `zip -r archive.zip folder/` | `unzip archive.zip -d /target` |
| Verbose | `zip -rv archive.zip folder/` | `unzip -v archive.zip` |
| List contents | *(not applicable)* | `unzip -l archive.zip` |
| Password | `zip -e archive.zip file.txt` | `unzip -P password archive.zip` |
| Specific files | `zip archive.zip file1 file2` | `unzip archive.zip file1 file2` |

---

## Common patterns

| Goal | Command |
|------|---------|
| Compress a file | `zip archive.zip file.txt` |
| Compress a folder | `zip -r archive.zip folder/` |
| Extract everything | `unzip archive.zip` |
| Extract to a directory | `unzip archive.zip -d /target` |
| List contents without extracting | `unzip -l archive.zip` |
| Extract a single file | `unzip archive.zip specific-file.txt` |
| Extract without directory structure | `unzip -j archive.zip -d /target` |
| Add a file to existing archive | `zip -u archive.zip newfile.txt` |
| Delete a file from archive | `zip -d archive.zip unwanted.txt` |

---

## zip vs gzip / bzip2 / xz

| | zip | gzip / bzip2 / xz |
|-|-----|-------------------|
| Handles folders | Yes — with `-r` | No — use tar first |
| Keeps originals | Yes — by default | No — deletes by default |
| Multiple files | Yes | One file at a time |
| tar needed | No | Yes for folders |
| Cross-platform | Very — native on Windows/macOS | Less common outside Linux |
| Encryption | Yes — with `-e` | No |
| Compression ratio | Lower | Higher (especially xz) |

---

## zip and tar

zip handles folders directly so you do not need tar. However, `.tar.gz`, `.tar.bz2`, and `.tar.xz` are more common on Linux systems and preserve Unix file permissions. zip does not always preserve permissions.

| Goal | zip approach | tar approach |
|------|-------------|-------------|
| Compress a folder | `zip -r archive.zip folder/` | `tar -czf archive.tar.gz folder/` |
| Extract a folder | `unzip archive.zip -d /target` | `tar -xzf archive.tar.gz -C /target` |
| Preserve Unix permissions | ⚠️ not always | ✅ yes |
| Works natively on Windows | ✅ yes | ⚠️ needs tools |

---

## Gotchas

| | |
|--|--|
| ⚠️ | **Forgetting `-r` for folders** — `zip archive.zip folder/` without `-r` only adds the folder entry, not its contents |
| ⚠️ | **zip does not preserve Unix permissions reliably** — for Linux-to-Linux transfers, prefer tar |
| ⚠️ | **`-j` flattens directory structure** — all files end up in one directory, name collisions will overwrite silently |
| ⚠️ | **`-m` deletes originals** — the move flag removes source files after adding them to the archive |
| ✅ | **originals are kept by default** — unlike gzip/bzip2/xz, you do not need `-k` |
| ✅ | **`unzip -l` is safe** — inspect before extracting to know what you are getting |
| ✅ | **zip is the most cross-platform option** — use it when the archive needs to be opened on Windows or macOS |
