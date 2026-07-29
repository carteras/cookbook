# cat | command

> Pipe the output of `cat` into commands that read from stdin — no `xargs` needed.

---

## The pattern

```sh
cat file.txt | command
```

Most Unix tools read from stdin when given no filename argument, making them natural pipe targets. This is the foundation of the Unix philosophy: small tools chained together.

---

## Text processing

```sh
cat file.txt | grep "pattern"            # filter matching lines
cat file.txt | grep -v "pattern"         # filter non-matching lines
cat file.txt | grep -c "pattern"         # count matching lines

cat file.txt | sed 's/foo/bar/g'         # replace all occurrences
cat file.txt | sed '/pattern/d'          # delete matching lines
cat file.txt | sed -n '5,10p'            # print lines 5–10

cat file.txt | awk '{print $2}'          # print second field
cat file.txt | awk -F: '{print $1}'      # custom delimiter, first field
cat file.txt | awk 'NR % 2 == 0'        # print even-numbered lines

cat file.txt | cut -d',' -f1,3          # fields 1 and 3 from CSV
cat file.txt | cut -c1-10               # first 10 characters per line
```

## Sorting and uniqueness

```sh
cat file.txt | sort                      # sort alphabetically
cat file.txt | sort -r                   # sort in reverse
cat file.txt | sort -n                   # sort numerically
cat file.txt | sort -k2                  # sort by second field
cat file.txt | sort -u                   # sort and deduplicate

cat file.txt | uniq                      # collapse adjacent duplicates
cat file.txt | uniq -c                   # prefix lines with count
cat file.txt | uniq -d                   # print only duplicate lines
cat file.txt | uniq -u                   # print only unique lines

cat file.txt | sort | uniq -c | sort -rn # frequency count, most common first
```

## Counting and inspection

```sh
cat file.txt | wc -l                     # count lines
cat file.txt | wc -w                     # count words
cat file.txt | wc -c                     # count bytes

cat file.txt | head -20                  # first 20 lines
cat file.txt | tail -20                  # last 20 lines
cat file.txt | tail -f                   # follow (useful for logs)

cat file.txt | nl                        # number lines
cat file.txt | cat -A                    # show non-printing characters
```

## Transformation

```sh
cat file.txt | tr 'a-z' 'A-Z'           # lowercase to uppercase
cat file.txt | tr -d '\r'               # strip Windows line endings
cat file.txt | tr -s ' '               # squeeze repeated spaces
cat file.txt | tr -d '[:punct:]'        # strip punctuation

cat file.txt | fold -w 80               # wrap lines at 80 chars
cat file.txt | expand                   # tabs → spaces
cat file.txt | unexpand                 # spaces → tabs
```

## JSON, CSV, and structured data

```sh
cat file.json | jq '.key'               # extract a key
cat file.json | jq '.[] | .name'        # pluck field from array
cat file.json | jq 'length'             # count items
cat file.json | python3 -m json.tool    # pretty-print JSON

cat file.csv | mlr --csv sort-f name    # sort CSV by column (miller)
cat file.csv | csvcut -c 1,3            # select columns (csvkit)
```

## Encoding and hashing

```sh
cat file.txt | base64                   # encode to base64
cat file.b64 | base64 -d               # decode from base64

cat file.txt | md5sum                   # MD5 hash
cat file.txt | sha256sum                # SHA-256 hash
cat file.txt | sha1sum                  # SHA-1 hash

cat file.txt | gzip > file.txt.gz       # compress
```

## Network and transfer

```sh
cat file.txt | curl -X POST \
  -H "Content-Type: text/plain" \
  --data-binary @- \
  https://example.com/api               # POST file contents

cat file.txt | ssh user@host \
  "cat > /remote/path/file.txt"         # copy file over SSH without scp

cat file.txt | nc host 1234             # send to netcat listener
```

## Scripting patterns

```sh
cat file.txt | while IFS= read -r line; do
  echo "Processing: $line"
done                                     # process lines in a loop

cat file.txt | tee copy.txt | grep "ok" # write to file AND continue piping

cat file.txt | paste - - -              # merge every 3 lines into one
cat file.txt | pr -3 -t                 # format into 3 columns
```

---

## When to skip `cat`

Some commands accept filenames directly — piping `cat` into them adds a useless process (this is called a [useless use of cat](https://porkmail.org/era/unix/award.html)):

```sh
# redundant
cat file.txt | grep "pattern"

# preferred — grep reads the file itself
grep "pattern" file.txt
```

Use `cat | command` when:
- you're chaining multiple pipes and `cat` is the readable starting point
- the input is being constructed dynamically (`cat file1 file2 file3 | …`)
- the command genuinely only reads stdin (e.g. `base64`, `wc` with no args, custom scripts)

---

## Gotchas

**Buffering** — some commands buffer output when not connected to a terminal, which can make pipelines appear to hang. Use `grep --line-buffered`, `sed -u`, or `awk` with `fflush()` to force line-by-line output.

**Binary files** — `cat` passes bytes through unchanged, so piping binary files into text-processing tools (`grep`, `sed`, `awk`) can produce unexpected results. Add `grep -a` to treat binary as text, or use dedicated binary tools.

**Large files** — `cat largefile | sort` loads everything into memory. For very large files, `sort` can accept a filename directly and handles spill-to-disk more gracefully: `sort largefile`.

**Preserving newlines in `while read`** — the default `read` strips leading/trailing whitespace. Use `IFS= read -r line` to preserve the line exactly as-is.
