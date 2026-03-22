# tldr: cd, pwd, mkdir

## Description

The three commands for navigating and creating the directory structure on your system.

- **`cd`** — Change Directory. Moves you from where you are to somewhere else.
- **`pwd`** — Print Working Directory. Tells you exactly where you currently are.
- **`mkdir`** — Make Directory. Creates a new directory.

These are the most fundamental navigation commands. You'll use them in every single terminal session.

---

## Simple Examples

### cd — Change Directory

```bash
# Move into a specific directory
cd /home/bushranger101

# Move up one level (to the parent directory)
cd ..

# Move up two levels
cd ../..

# Go back to your home directory (three equivalent ways)
cd
cd ~
cd $HOME

# Go back to the previous directory you were in
cd -

# Move into a directory relative to where you are now
cd documents/projects
```

### pwd — Print Working Directory

```bash
# Show your current location in the filesystem
pwd
# /home/admin_user

# Useful inside scripts to confirm the script's working directory
echo "Currently in: $(pwd)"
```

### mkdir — Make Directory

```bash
# Create a single directory
mkdir myfolder

# Create a directory at a specific path
mkdir /home/bushranger101/documents

# Create nested directories in one command (-p = make parents too)
mkdir -p /home/bushranger101/documents/notes/2024

# Create multiple directories at once
mkdir dir1 dir2 dir3

# Create a directory and set its permissions at the same time
mkdir -m 750 /home/bushranger101/private
```

---

## Composite Example

Setting up a directory structure for a multi-level wargame, then navigating into it:

```bash
# Start from home
cd ~
pwd
# /home/admin_user

# Create nested level directories in one command
mkdir -p /home/bushranger101/levels/level2/hints

# Verify they were created
ls -la /home/bushranger101/levels/
# drwxr-xr-x 3 admin_user admin_user 4096 Jan 01 level2

# Navigate in
cd /home/bushranger101/levels/level2
pwd
# /home/bushranger101/levels/level2

# Create a flag file here
echo "my_flag" | md5sum | cut -d " " -f1 > secret.flag

# Go back to home
cd ~
pwd
# /home/admin_user

# Jump back to where you just were
cd -
pwd
# /home/bushranger101/levels/level2
```

---

## Notes for Students

- **`cd` with no arguments always takes you home.** When you're lost in the filesystem, just type `cd` and press Enter — you'll be back in your home directory.
- **`cd -` is underrated.** It jumps back to the previous directory you were in. If you're constantly switching between two directories, `cd -` is much faster than typing the full path each time.
- **`pwd` before destructive commands.** Before running `rm -rf` or `chmod -R`, always run `pwd` to confirm you're in the right place. Running those commands in the wrong directory is a classic way to ruin your day.
- **`mkdir -p` is safe to run multiple times.** If the directory already exists, it does nothing rather than throwing an error. Useful in scripts.
- **Relative vs absolute paths:** Paths starting with `/` are absolute (from the root of the filesystem). Everything else is relative to where you currently are. `cd documents` works only if `documents` exists in your current directory; `cd /home/admin_user/documents` works from anywhere.
- The `~` symbol is a shorthand for your home directory. `cd ~/documents` and `cd /home/admin_user/documents` are identical if you're logged in as `admin_user`.
