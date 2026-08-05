# `while read` — bash cheat sheet

> Process input line by line — works for 1 line or 1 million

---

## Basic syntax

```bash
while read line; do
  echo "$line"
done
```

The loop runs once per line. When there are no more lines, it stops automatically.

---

## Where the input comes from

<div style="display:flex;gap:12px;margin:1rem 0;">
  <div style="flex:1;border:1px solid #e0e0e0;border-radius:8px;padding:14px;">
    <strong>From a pipe</strong>
    <pre style="margin:8px 0 0;font-size:13px;"><code>cat passwords.txt | ./test.sh

# inside test.sh:
while read line; do
  echo "$line"
done</code></pre>
  </div>
  <div style="flex:1;border:1px solid #e0e0e0;border-radius:8px;padding:14px;">
    <strong>From a file (redirect)</strong>
    <pre style="margin:8px 0 0;font-size:13px;"><code>while read line; do
  echo "$line"
done &lt; passwords.txt</code></pre>
  </div>
  <div style="flex:1;border:1px solid #e0e0e0;border-radius:8px;padding:14px;">
    <strong>From a variable</strong>
    <pre style="margin:8px 0 0;font-size:13px;"><code>data="line1
line2
line3"

while read line; do
  echo "$line"
done &lt;&lt;&lt; "$data"</code></pre>
  </div>
</div>

---

## Common patterns

<div style="display:flex;gap:12px;margin:1rem 0;">
  <div style="flex:1;border:1px solid #e0e0e0;border-radius:8px;padding:14px;">
    <strong>Print each line</strong>
    <pre style="margin:8px 0 0;font-size:13px;"><code>while read line; do
  echo "$line"
done</code></pre>
  </div>
  <div style="flex:1;border:1px solid #e0e0e0;border-radius:8px;padding:14px;">
    <strong>Count lines as you go</strong>
    <pre style="margin:8px 0 0;font-size:13px;"><code>count=0
while read line; do
  count=$((count + 1))
  echo "$count: $line"
done</code></pre>
  </div>
  <div style="flex:1;border:1px solid #e0e0e0;border-radius:8px;padding:14px;">
    <strong>Do something with each line</strong>
    <pre style="margin:8px 0 0;font-size:13px;"><code>while read password; do
  echo "Checking: $password"
done</code></pre>
  </div>
  <div style="flex:1;border:1px solid #e0e0e0;border-radius:8px;padding:14px;">
    <strong>Split each line into parts</strong>
    <pre style="margin:8px 0 0;font-size:13px;"><code># splits on whitespace
while read user pass; do
  echo "User: $user"
  echo "Pass: $pass"
done</code></pre>
  </div>
</div>

---

## How it compares to 10 × `read`

<div style="display:flex;gap:12px;margin:1rem 0;">
  <div style="flex:1;border:1px solid #e0e0e0;border-radius:8px;padding:14px;">
    <strong>Before — 10 reads</strong>
    <pre style="margin:8px 0 0;font-size:13px;"><code>read p1
read p2
read p3
read p4
read p5
read p6
read p7
read p8
read p9
read p10

echo "$p1"
echo "$p2"
echo "$p3"
echo "$p4"
echo "$p5"
echo "$p6"
echo "$p7"
echo "$p8"
echo "$p9"
echo "$p10"</code></pre>
    <p style="margin:10px 0 0;font-size:13px;color:#666;">Breaks if input has 9 or 11 lines.</p>
  </div>
  <div style="flex:1;border:1px solid #e0e0e0;border-radius:8px;padding:14px;">
    <strong>After — while loop</strong>
    <pre style="margin:8px 0 0;font-size:13px;"><code>while read line; do
  echo "$line"
done</code></pre>
    <p style="margin:10px 0 0;font-size:13px;color:#666;">Works for any number of lines. Nothing to change.</p>
  </div>
</div>

---

## Useful flags

| Flag | Example | Description |
|------|---------|-------------|
| `-r` | `while read -r line` | Raw mode — don't treat `\` as escape. Use this by default. |
| `-d` | `while read -d , field` | Change the line delimiter (default is newline) |
| `-t N` | `while read -t 5 line` | Timeout after N seconds per line |

---

## Flow diagram

```
stdin opens
    │
    ▼
┌─────────────────────┐
│  read gets a line   │◄─────────────┐
└────────┬────────────┘              │
         │                           │
    line exists?                     │
         │                           │
    yes  ▼                     no    │
┌─────────────────────┐        exit loop
│   body runs once    │──────────────┘
│   echo "$line"      │
└─────────────────────┘
```

---

## Gotchas

> **Missing `-r`** — without it, backslashes in input are swallowed. Use `while read -r line` as a habit.

> **Variable scope** — variables set inside the loop are lost after `done` if the loop runs in a subshell (e.g. via a pipe). Use `done < file` instead of `cat file |` to keep variables in scope.

> **Always quote `"$line"`** — unquoted variables collapse whitespace and break on special characters.

> **`while read` stops cleanly** — no need to count lines or check for end of file manually.
