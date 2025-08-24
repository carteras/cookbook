# Bash `while` Loops — Cheat/Tutorial

## Basics

```bash
# Count 1..5
i=1
while [ $i -le 5 ]; do
  echo "$i"
  i=$((i+1))
done
```

```bash
# Count down 5..1
i=5
while [ $i -gt 0 ]; do
  echo "$i"
  i=$((i-1))
done
```

## Conditions

```bash
# Numeric tests (use -lt -le -eq -ne -ge -gt)
while [ "$x" -lt 10 ]; do :; done

# String tests
while [ "$s" != "quit" ]; do :; done

# File tests: -f file, -d dir, -s nonempty, -e exists
while [ ! -f "ready.flag" ]; do sleep 1; done
```

Tip: Prefer `[[ ... ]]` over `[ ... ]` for safer string ops and regex.

```bash
# [[ ... ]] – no pathname expansion, simpler quoting
while [[ "$name" != quit ]]; do read -r name; done

# Regex match
while read -r line; do
  [[ $line =~ ^# ]] && continue
  echo "$line"
done < file.txt
```

## Reading Input

```bash
# Prompt until "exit"
inp=
while [[ $inp != exit ]]; do
  read -rp ">> " inp
done
```

```bash
# Validate 1..5
n=0
while (( n<1 || n>5 )); do
  read -rp "1..5: " n
done
```

## Looping Over Files/Command Output

```bash
# File -> line by line (preserve whitespace, no backslash escapes)
while IFS= read -r line; do
  echo ">$line"
done < input.txt
```

```bash
# Command output safely (keep loop in current shell)
while IFS= read -r p; do
  echo "PID: $p"
done < <(ps -eo pid --no-headers)
```

**Avoid:**

```bash
# Subshell pitfall: changes inside won't persist outside on many shells
somecmd | while read -r line; do counter=$((counter+1)); done
echo "$counter"  # may be empty
```

**Use process substitution instead** (as above) if you need to keep state.

## Arithmetic Loops

```bash
# Using (( ... )) with while
i=1
while (( i<=10 )); do
  (( sum+=i, i++ ))
done
echo "$sum"
```

```bash
# Multiplication table (7 × 1..10)
n=7; m=1
while (( m<=10 )); do
  printf "%d x %d = %d\n" "$n" "$m" $((n*m))
  ((m++))
done
```

## Sleeping/Timing

```bash
# Countdown with 1s delay
t=10
while (( t>0 )); do
  echo "$t"
  sleep 1
  ((t--))
done
```

```bash
# Retry until success (exit code 0), with backoff
delay=1
while ! curl -fsS http://localhost:8080 >/dev/null; do
  echo "retrying in ${delay}s..."
  sleep "$delay"
  (( delay = delay<8 ? delay*2 : 8 ))
done
```

## Menus

```bash
choice=
while [[ $choice != quit ]]; do
  cat <<'MENU'
1) date
2) pwd
3) who
Type 'quit' to exit
MENU
  read -rp "> " choice
  case $choice in
    1) date ;;
    2) pwd ;;
    3) who ;;
    quit) : ;;
    *) echo "invalid" ;;
  esac
done
```

## Filesystem Waiting

```bash
# Wait for dir + file
while [[ ! -d logs ]]; do sleep 1; done
while [[ ! -f logs/error.log ]]; do sleep 1; done
echo "ready"
```

```bash
# Wait until file stops growing
f=data.csv; last=-1; size=0
while :; do
  size=$(stat -c%s "$f" 2>/dev/null || echo -1)
  [[ $size -ge 0 && $size -eq $last ]] && break
  last=$size; sleep 1
done
echo "stable"
```

## Progress Bar (simple)

```bash
i=0; max=20; bar=
while (( i<max )); do
  bar+="#"
  printf "\r[%s] %d%%" "$bar" $(( (i+1)*100/max ))
  sleep 0.2
  ((i++))
done
echo
```

## Arguments

```bash
# Shift through all args
while (( $# )); do
  echo "$1"
  shift
done
```

```bash
# Track longest arg
long=
while (( $# )); do
  [[ ${#1} -gt ${#long} ]] && long=$1
  shift
done
echo "longest: $long"
```

## Infinite Loops and Exit

```bash
# Infinite loop (Ctrl+C to stop)
while :; do
  date
  sleep 5
done
```

```bash
# Stop on timeout (120s)
start=$(date +%s)
while :; do
  now=$(date +%s)
  (( now-start >= 120 )) && break
  echo "tick"
  sleep 10
done
```

## `until` (inverse of `while`)

```bash
# Run until command succeeds
until curl -fsS http://localhost:3000 >/dev/null; do
  echo "waiting..."
  sleep 2
done
```

## Control Flow: `break` / `continue`

```bash
# Stop on ERROR line
while IFS= read -r line; do
  [[ $line == ERROR* ]] && { echo "found"; break; }
done < app.log
```

```bash
# Skip comments/blank lines
while IFS= read -r line; do
  [[ -z $line || $line == \#* ]] && continue
  echo "cfg: $line"
done < config.txt
```

## Best Practices / Pitfalls

* Use `#!/usr/bin/env bash` at top for portability.
* Prefer `[[ ... ]]` for string/regex tests; use `(( ... ))` for integers.
* When reading lines: `IFS= read -r line` to preserve whitespace and backslashes.
* Beware subshells with pipes: use process substitution `< <(cmd)` if you need to mutate variables.
* Quote variables in tests: `[ -f "$file" ]`, `[[ $var == foo ]]` (quotes not required in `[[ ]]`, but safe).
* Use `set -euo pipefail` in larger scripts (with care) to fail fast on errors.

```bash
# Template skeleton
#!/usr/bin/env bash
set -Eeuo pipefail

main() {
  # your while loops here
}

main "$@"
```

