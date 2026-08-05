# `if` string matching — bash cheat sheet

> Test strings in bash 5.2 using `[[ ]]`

---

## Basic syntax

```bash
if [[ condition ]]; then
  # runs if condition is true
fi
```

```bash
if [[ condition ]]; then
  # runs if true
else
  # runs if false
fi
```

---

## String comparisons

| Test | Meaning | Example |
|------|---------|---------|
| `[[ "$a" == "$b" ]]` | exact match | `[[ "$line" == "password" ]]` |
| `[[ "$a" != "$b" ]]` | not equal | `[[ "$line" != "password" ]]` |
| `[[ "$a" == *word* ]]` | contains (glob) | `[[ "$line" == *pass* ]]` |
| `[[ "$a" =~ pattern ]]` | regex match | `[[ "$line" =~ ^pass ]]` |
| `[[ -z "$a" ]]` | string is empty | `[[ -z "$line" ]]` |
| `[[ -n "$a" ]]` | string is not empty | `[[ -n "$line" ]]` |

> ⚠️ Always use `[[ ]]` not `[ ]` in bash 5.2 — double brackets handle spaces in variables safely and support `==` glob and `=~` regex matching.

---

## Exact match

```bash
while read -r line; do
  if [[ "$line" == "password" ]]; then
    echo "$line"
  fi
done
```

Only prints lines that are exactly `password` — nothing else.

---

## Common patterns

| Exact match | Contains (glob) | Starts with | Ends with |
|-------------|-----------------|-------------|-----------|
| `[[ "$line" == "password" ]]` | `[[ "$line" == *pass* ]]` | `[[ "$line" == pass* ]]` | `[[ "$line" == *word ]]` |
| Matches `password` only | Matches `password`, `passphrase`, `mypass` | Matches `password`, `pass123` | Matches `password`, `keyword` |

---

## Regex match with `=~`

```bash
while read -r line; do
  if [[ "$line" =~ ^pass ]]; then
    echo "$line"
  fi
done
```

| Pattern | Matches |
|---------|---------|
| `=~ ^pass` | starts with `pass` |
| `=~ word$` | ends with `word` |
| `=~ ^password$` | exactly `password` |
| `=~ [0-9]` | contains a digit |
| `=~ pass.+` | `pass` followed by one or more characters |

---

## Combining conditions

| Operator | Meaning | Example |
|----------|---------|---------|
| `&&` | and — both must be true | `[[ "$line" == *pass* && -n "$line" ]]` |
| `\|\|` | or — either can be true | `[[ "$line" == "password" \|\| "$line" == "pass" ]]` |
| `!` | not — inverts the result | `[[ ! "$line" == "password" ]]` |

---

## Useful flags

| Flag | Description |
|------|-------------|
| `==` | Glob pattern match — `*` means any characters |
| `=~` | Regex match — do not quote the pattern |
| `-z` | True if string is empty |
| `-n` | True if string is not empty |

> ✅ When using `=~` regex, do **not** quote the pattern: `[[ "$line" =~ ^pass ]]` not `[[ "$line" =~ "^pass" ]]` — quotes turn off regex matching.

---

## Gotchas

| | |
|--|--|
| ⚠️ | **Spaces around `[[ ]]`** — `[["$line"=="password"]]` fails. Always space it: `[[ "$line" == "password" ]]` |
| ⚠️ | **Quoting the regex pattern** — `[[ "$line" =~ "^pass" ]]` treats the pattern as a literal string, not regex |
| ⚠️ | **Glob vs regex** — `==` uses glob (`*`, `?`), `=~` uses regex (`.*`, `^`, `$`). They are not the same. |
| ✅ | **Always quote variables** — `[[ $line == "password" ]]` breaks if `$line` is empty or contains spaces |
| ✅ | **`[[ ]]` not `[ ]`** — single brackets don't support `==` glob or `=~` regex in the same way |
