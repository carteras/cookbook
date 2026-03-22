# tldr: cut

## Description

Extracts specific columns or fields from each line of text. You tell it what the delimiter (separator) between fields is, and which field number you want. Essential for pulling out a single piece of information from command output that gives you more than you need.

---

## Simple Examples

```bash
# Split on spaces, return field 1 (the first word)
echo "hello world foo" | cut -d " " -f1
# hello

# Split on spaces, return field 2
echo "hello world foo" | cut -d " " -f2
# world

# Split on colons, return field 1 (username from /etc/passwd)
echo "bushranger101:x:1003:1003::/home/bushranger101:/bin/bash" | cut -d ":" -f1
# bushranger101

# Split on colons, return field 6 (home directory from /etc/passwd)
echo "bushranger101:x:1003:1003::/home/bushranger101:/bin/bash" | cut -d ":" -f6
# /home/bushranger101

# Return a range of fields (fields 1 through 3)
echo "a:b:c:d:e" | cut -d ":" -f1-3
# a:b:c

# Return from field 3 to the end of the line
echo "a:b:c:d:e" | cut -d ":" -f3-
# c:d:e

# Extract by character position instead of field (characters 1 to 32)
echo "a43c1b0aa53a0c908810c06ab1ff3967  -" | cut -c1-32
# a43c1b0aa53a0c908810c06ab1ff3967
```

---

## Composite Example

Stripping the trailing `  -` from `md5sum` output to get a clean hash for a flag file:

```bash
# md5sum produces: hash + two spaces + dash
echo "my_flag" | md5sum
# a43c1b0aa53a0c908810c06ab1ff3967  -

# cut -d " " -f1 splits on the first space and returns only what's before it
echo "my_flag" | md5sum | cut -d " " -f1
# a43c1b0aa53a0c908810c06ab1ff3967
```

Extracting usernames from `/etc/passwd` to see who's on the system:

```bash
cat /etc/passwd | cut -d ":" -f1
# root
# daemon
# ...
# admin_user
# bushranger101
```

---

## Notes for Students

- `-d` sets the **delimiter** (the character that separates fields). Common delimiters: space (`" "`), colon (`":"`), comma (`","`), tab (`$'\t'`).
- `-f` sets the **field number** to return. Fields are counted from 1, not 0.
- `cut` is not smart about multiple spaces between fields — it treats each space as a separate delimiter. If your data has inconsistent spacing, `awk` is a better tool.
- You'll use `cut` constantly when parsing command output. Any time a command gives you `thing_you_want  other_stuff_you_dont_want`, `cut` is the right tool.
- In the wargame pipeline `echo "my_flag" | md5sum | cut -d " " -f1 > file`, `cut` is the "cleanup" step that makes the output usable. Think of it as trimming off the parts you didn't ask for.
