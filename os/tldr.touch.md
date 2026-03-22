# tldr: touch

## Description

Creates an empty file. If the file already exists, `touch` leaves the content alone and just updates its "last accessed" and "last modified" timestamps to right now. Most commonly used to quickly create placeholder files.

---

## Simple Examples

```bash
# Create a single empty file
touch secret.flag

# Create multiple files at once
touch file1.txt file2.txt file3.txt

# Update the timestamp on an existing file without changing its content
touch existingfile.txt

# Create a file at a specific path
touch /home/bushranger101/notes.txt

# Set a specific timestamp instead of now
touch -t 202401011200.00 file.txt
```

---

## Composite Example

Creating a flag file, then immediately setting ownership and permissions on it:

```bash
cd /home/bushranger101
touch secret.flag
sudo chown admin_user:bushranger101 secret.flag
sudo chmod u=rw,g=r,o= secret.flag
ls -la | grep secret
```

```
-rw-r----- 1 admin_user bushranger101 0 Jan 01 10:30 secret.flag
```

The file is empty (`0` bytes) — you'd then write content to it with `echo` or `tee`.

---

## Notes for Students

- `touch` creates an **empty** file. If you need a file with content, use `echo "text" > filename` instead.
- It's often used in scripts to create "marker" files — files whose existence (not content) signals that something has happened. For example, `touch /tmp/setup_complete` as a flag that a setup script has run.
- The timestamp-updating behaviour is why the command is called `touch` — you're just "touching" the file to update when it was last seen.
- `touch` will fail if the directory doesn't exist. Use `mkdir -p` first if you need to create the path.
- In CTF/wargame setup, `touch` is your quickest way to create the flag file before you fill it with `echo` or `tee`.
