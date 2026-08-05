# `read` — bash cheat sheet

> Read input from stdin, one line at a time

---

## Basic syntax

```bash
read variable_name
read first last            # splits on whitespace into two vars
read -p "Enter name: " name  # shows a prompt first
```

---

## Common patterns

<div style="display:flex;gap:12px;margin:1rem 0;">
  <div style="flex:1;border:1px solid #e0e0e0;border-radius:8px;padding:14px;">
    <strong>Read a single line</strong>
    <pre style="margin:8px 0 0;font-size:13px;"><code>read line
echo "You typed: $line"</code></pre>
  </div>
  <div style="flex:1;border:1px solid #e0e0e0;border-radius:8px;padding:14px;">
    <strong>Read multiple lines manually</strong>
    <pre style="margin:8px 0 0;font-size:13px;"><code>read line1
read line2
read line3
echo "$line1 $line2 $line3"</code></pre>
  </div>
  <div style="flex:1;border:1px solid #e0e0e0;border-radius:8px;padding:14px;">
    <strong>Read all lines with a while loop</strong>
    <pre style="margin:8px 0 0;font-size:13px;"><code>while read line; do
  echo "$line"
done</code></pre>
  </div>
  <div style="flex:1;border:1px solid #e0e0e0;border-radius:8px;padding:14px;">
    <strong>Read into an array</strong>
    <pre style="margin:8px 0 0;font-size:13px;"><code>mapfile -t lines &lt; /dev/stdin

echo "${lines[0]}"
echo "${lines[1]}"</code></pre>
  </div>
</div>

---

## Useful flags

| Flag | Description |
|------|-------------|
| `-p "text"` | Show a prompt before reading |
| `-s` | Silent mode — hides input (good for passwords) |
| `-n N` | Stop after N characters (don't wait for Enter) |
| `-t N` | Timeout after N seconds |
| `-r` | Raw mode — don't treat backslash as escape |
| `-a arr` | Read words into an array instead of a string |

---

## How input arrives

<div style="display:flex;gap:12px;margin:1rem 0;">
  <div style="flex:1;border:1px solid #e0e0e0;border-radius:8px;padding:14px;">
    <strong>From a pipe</strong>
    <pre style="margin:8px 0 0;font-size:13px;"><code>echo "hello" | ./test.sh

# inside test.sh:
read line   # gets "hello"</code></pre>
  </div>
  <div style="flex:1;border:1px solid #e0e0e0;border-radius:8px;padding:14px;">
    <strong>From a file</strong>
    <pre style="margin:8px 0 0;font-size:13px;"><code>while read line; do
  echo "$line"
done &lt; passwords.txt</code></pre>
  </div>
  <div style="flex:1;border:1px solid #e0e0e0;border-radius:8px;padding:14px;">
    <strong>Pipe + args together</strong>
    <pre style="margin:8px 0 0;font-size:13px;"><code>echo "secret" | ./test.sh arg1

# inside test.sh:
read secret_val   # from pipe
arg1="$1"         # from args</code></pre>
  </div>
</div>

---

## The two-stage lesson

<div style="display:flex;gap:12px;margin:1rem 0;">
  <div style="flex:1;border:1px solid #e0e0e0;border-radius:8px;padding:14px;">
    <strong>Stage 1 — verbose (10 reads)</strong>
    <pre style="margin:8px 0 0;font-size:13px;"><code>#!/bin/bash
read p1
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
  </div>
  <div style="flex:1;border:1px solid #e0e0e0;border-radius:8px;padding:14px;">
    <strong>Stage 2 — while loop refactor</strong>
    <pre style="margin:8px 0 0;font-size:13px;"><code>#!/bin/bash
while read line; do
  echo "$line"
done</code></pre>
    <p style="margin:12px 0 0;font-size:13px;color:#666;">Same result. Works for 10, 100, or 1000 lines without changing anything.</p>
  </div>
</div>

---

## Gotchas

> **`read` only gets one line** — if you pipe 10 lines in and only call `read` once, you get the first line only.

> **Use `while read line`** when you don't know how many lines are coming.

> **Always quote your variables** — `echo "$line"` not `echo $line` or spaces get collapsed.

> **Use `-r`** if your input might contain backslashes (e.g. file paths).
