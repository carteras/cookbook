# tr — trimming spaces

> `tr` translates, squeezes, or deletes characters from stdin. It does not trim
> leading/trailing whitespace natively — but combined with other tools it handles
> most whitespace jobs cleanly.

---

## The basics

```sh
tr SET1 SET2          # replace characters in SET1 with corresponding chars in SET2
tr -d SET1            # delete characters in SET1
tr -s SET1            # squeeze runs of SET1 down to a single character
tr -s SET1 SET2       # squeeze, then translate
```

---

## Squeeze repeated spaces

```sh
# collapse multiple spaces into one
echo "too    many   spaces" | tr -s ' '
# → too many spaces

# squeeze any whitespace (spaces, tabs, newlines) down to a single space
echo -e "a  \t  b   c" | tr -s '[:space:]' ' '
# → a b c
```

---

## Delete spaces

```sh
# remove all spaces
echo "hello world" | tr -d ' '
# → helloworld

# remove all whitespace (spaces, tabs, newlines)
echo "  hello   world  " | tr -d '[:space:]'
# → helloworld

# remove only tabs
echo -e "col1\tcol2\tcol3" | tr -d '\t'
# → col1col2col3
```

---

## Trim leading and trailing spaces

`tr` has no concept of position — it acts on every character in the stream.
Use `sed` for leading/trailing trim, or combine tools:

```sh
# trim leading spaces
echo "   hello" | sed 's/^[[:space:]]*//'
# → hello

# trim trailing spaces
echo "hello   " | sed 's/[[:space:]]*$//'
# → hello

# trim both (two expressions)
echo "   hello   " | sed 's/^[[:space:]]*//;s/[[:space:]]*$//'
# → hello

# trim both (pipeline with tr to squeeze, sed to strip edges)
echo "   hello   world   " | tr -s ' ' | sed 's/^ //;s/ $//'
# → hello   world
```

---

## Tabs and newlines

```sh
# convert tabs to spaces
echo -e "col1\tcol2" | tr '\t' ' '
# → col1 col2

# convert spaces to tabs
echo "col1 col2 col3" | tr ' ' '\t'

# strip newlines (join all lines into one)
cat file.txt | tr -d '\n'

# replace newlines with spaces
cat file.txt | tr '\n' ' '

# replace newlines with spaces, then squeeze
cat file.txt | tr '\n' ' ' | tr -s ' '

# convert Windows line endings (CRLF → LF)
cat file.txt | tr -d '\r'
```

---

## Normalise whitespace in a file

```sh
# squeeze all runs of whitespace to a single space
cat file.txt | tr -s '[:space:]' ' '

# squeeze spaces only, preserve newlines
cat file.txt | tr -s ' '

# replace all whitespace with a single newline (one word per line)
cat file.txt | tr -s '[:space:]' '\n'

# strip blank lines
cat file.txt | tr -s '\n'
```

---

## Useful character classes

| Class          | Matches                              |
|----------------|--------------------------------------|
| `[:space:]`    | space, tab, newline, CR, FF, VT      |
| `[:blank:]`    | space and tab only                   |
| `[:print:]`    | printable characters including space |

```sh
# squeeze all blank characters (space + tab) to a single space
cat file.txt | tr -s '[:blank:]' ' '
```

---

## Common patterns

```sh
# clean up a CSV with inconsistent spacing around commas
echo "one , two , three" | tr -d ' '
# → one,two,three

# normalise a list of tags separated by irregular whitespace
echo "  foo   bar  baz  " | tr -s ' ' | sed 's/^ //;s/ $//'
# → foo bar baz

# convert a space-separated list to newline-separated (for further piping)
echo "one two three" | tr ' ' '\n'
# → one
#   two
#   three

# convert a newline-separated list back to space-separated
cat items.txt | tr '\n' ' '
```

---

## Gotchas

**`tr` reads stdin only** — it does not accept filenames. Always pipe into it:
`cat file.txt | tr ...` or redirect: `tr ... < file.txt`.

**No leading/trailing trim** — `tr -d ' '` removes every space, not just the
edges. Use `sed 's/^[[:space:]]*//;s/[[:space:]]*$//'` for proper trimming,
or `awk '{$1=$1};1'` as a compact alternative that also squeezes internal spaces.

**`-s` squeezes after translation** — `tr -s ' ' '_'` first replaces spaces
with underscores, then squeezes repeated underscores into one. The squeeze
applies to the output character, not the input.

**Character classes need the brackets** — `[:space:]` not `:space:`. Missing
the outer `[]` silently matches literal `:`, `s`, `p`, `a`, `c`, `e` instead.

**Newlines are characters too** — `tr -d '[:space:]'` will also delete newlines,
collapsing the entire file onto one line. Use `[:blank:]` instead if you want
to preserve line breaks.
