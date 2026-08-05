# Cognitive task analysis — `while read` to process input

> How a student thinks through replacing 10 × `read` with a while loop

---

## Goal

<div style="display:flex;gap:12px;margin:1rem 0;">
  <div style="flex:1;border:1px solid #e0e0e0;border-radius:8px;padding:14px;background:#f0f4ff;">
    <strong>Overall goal</strong>
    <p style="margin:8px 0 0;font-size:13px;">Process any number of input lines and print them back out — without knowing in advance how many lines there are</p>
  </div>
</div>

---

## Subgoals

<div style="display:flex;gap:12px;margin:1rem 0;">
  <div style="flex:1;border:1px solid #e0e0e0;border-radius:8px;padding:14px;">
    <strong>Subgoal 1</strong>
    <p style="margin:8px 0 0;font-size:13px;">Recognise the repetition problem</p>
    <p style="margin:6px 0 0;font-size:12px;color:#666;">10 × <code>read</code> is doing the same thing over and over — that's a signal to use a loop</p>
  </div>
  <div style="flex:1;border:1px solid #e0e0e0;border-radius:8px;padding:14px;">
    <strong>Subgoal 2</strong>
    <p style="margin:8px 0 0;font-size:13px;">Read one line per iteration</p>
    <p style="margin:6px 0 0;font-size:12px;color:#666;">Each loop cycle should grab exactly one line from stdin and store it</p>
  </div>
  <div style="flex:1;border:1px solid #e0e0e0;border-radius:8px;padding:14px;">
    <strong>Subgoal 3</strong>
    <p style="margin:8px 0 0;font-size:13px;">Do something with that line</p>
    <p style="margin:6px 0 0;font-size:12px;color:#666;">The body of the loop is where the work happens — for now, just <code>echo "$line"</code></p>
  </div>
  <div style="flex:1;border:1px solid #e0e0e0;border-radius:8px;padding:14px;">
    <strong>Subgoal 4</strong>
    <p style="margin:8px 0 0;font-size:13px;">Stop when input runs out</p>
    <p style="margin:6px 0 0;font-size:12px;color:#666;">The loop must end cleanly when there are no more lines — without the student having to count</p>
  </div>
</div>

---

## Decisions

<div style="display:flex;gap:12px;margin:1rem 0;">
  <div style="flex:1;border:1px solid #fff3cd;background:#fffdf0;border-radius:8px;padding:14px;">
    <strong>Decision 1</strong>
    <p style="margin:8px 0 0;font-size:13px;">What kind of loop?</p>
    <p style="margin:6px 0 0;font-size:12px;color:#666;"><code>for</code> needs to know the count upfront. <code>while</code> keeps going until a condition fails — and <code>read</code> fails naturally at end of input</p>
  </div>
  <div style="flex:1;border:1px solid #fff3cd;background:#fffdf0;border-radius:8px;padding:14px;">
    <strong>Decision 2</strong>
    <p style="margin:8px 0 0;font-size:13px;">What is the loop condition?</p>
    <p style="margin:6px 0 0;font-size:12px;color:#666;"><code>read line</code> is both the condition and the action — it returns false when stdin is empty, which ends the loop</p>
  </div>
  <div style="flex:1;border:1px solid #fff3cd;background:#fffdf0;border-radius:8px;padding:14px;">
    <strong>Decision 3</strong>
    <p style="margin:8px 0 0;font-size:13px;">Can I reuse the same variable name?</p>
    <p style="margin:6px 0 0;font-size:12px;color:#666;">Yes — unlike the 10 × <code>read</code> approach, the loop overwrites <code>$line</code> each iteration on purpose</p>
  </div>
  <div style="flex:1;border:1px solid #fff3cd;background:#fffdf0;border-radius:8px;padding:14px;">
    <strong>Decision 4</strong>
    <p style="margin:8px 0 0;font-size:13px;">Where does input come from?</p>
    <p style="margin:6px 0 0;font-size:12px;color:#666;">A pipe (<code>cat file | ./test.sh</code>) or a redirect (<code>done &lt; file</code>) — both work, but redirect keeps variables in scope</p>
  </div>
</div>

---

## Actions — in order

<div style="display:flex;gap:12px;margin:1rem 0;">
  <div style="flex:1;border:1px solid #e0e0e0;border-radius:8px;padding:14px;">
    <strong>01 — Write the shebang</strong>
    <pre style="margin:8px 0 0;font-size:13px;"><code>#!/bin/bash</code></pre>
  </div>
  <div style="flex:1;border:1px solid #e0e0e0;border-radius:8px;padding:14px;">
    <strong>02 — Open the loop</strong>
    <pre style="margin:8px 0 0;font-size:13px;"><code>while read line; do</code></pre>
    <p style="margin:8px 0 0;font-size:12px;color:#666;"><code>read line</code> is the condition — it runs before each iteration</p>
  </div>
  <div style="flex:1;border:1px solid #e0e0e0;border-radius:8px;padding:14px;">
    <strong>03 — Write the body</strong>
    <pre style="margin:8px 0 0;font-size:13px;"><code>  echo "$line"</code></pre>
    <p style="margin:8px 0 0;font-size:12px;color:#666;">Indent the body — one <code>echo</code> handles all 10 lines</p>
  </div>
  <div style="flex:1;border:1px solid #e0e0e0;border-radius:8px;padding:14px;">
    <strong>04 — Close the loop</strong>
    <pre style="margin:8px 0 0;font-size:13px;"><code>done</code></pre>
    <p style="margin:8px 0 0;font-size:12px;color:#666;"><code>done</code> sends control back to <code>while</code> — the loop repeats until <code>read</code> fails</p>
  </div>
  <div style="flex:1;border:1px solid #e0e0e0;border-radius:8px;padding:14px;">
    <strong>05 — Run and test</strong>
    <pre style="margin:8px 0 0;font-size:13px;"><code>cat passwords.txt \
  | ./test.sh</code></pre>
    <p style="margin:8px 0 0;font-size:12px;color:#666;">Output should match input exactly, one line per line</p>
  </div>
</div>

---

## The mental model shift

<div style="display:flex;gap:12px;margin:1rem 0;">
  <div style="flex:1;border:1px solid #e0e0e0;border-radius:8px;padding:14px;">
    <strong>Stage 1 thinking</strong>
    <p style="margin:8px 0 0;font-size:13px;color:#666;">"I need to read line 1, then line 2, then line 3..."</p>
    <p style="margin:8px 0 0;font-size:13px;">Counting-based. The student thinks about each line individually and writes one instruction per line.</p>
  </div>
  <div style="flex:1;border:1px solid #e0e0e0;border-radius:8px;padding:14px;">
    <strong>Stage 2 thinking</strong>
    <p style="margin:8px 0 0;font-size:13px;color:#666;">"I need to do the same thing to every line until there are none left."</p>
    <p style="margin:8px 0 0;font-size:13px;">Pattern-based. The student thinks about the action, not the count. This is the leap into loop thinking.</p>
  </div>
</div>

---

## Common errors

<div style="display:flex;gap:12px;margin:1rem 0;">
  <div style="flex:1;border:1px solid #fde0e0;background:#fff8f8;border-radius:8px;padding:14px;">
    <strong>❌ Forgetting <code>do</code> or <code>done</code></strong>
    <pre style="margin:8px 0 0;font-size:13px;"><code>while read line
  echo "$line"   # syntax error</code></pre>
    <p style="margin:8px 0 0;font-size:12px;color:#666;">Both <code>do</code> and <code>done</code> are required — the loop body sits between them</p>
  </div>
  <div style="flex:1;border:1px solid #fde0e0;background:#fff8f8;border-radius:8px;padding:14px;">
    <strong>❌ Unquoted variable</strong>
    <pre style="margin:8px 0 0;font-size:13px;"><code>while read line; do
  echo $line   # breaks on spaces
done</code></pre>
    <p style="margin:8px 0 0;font-size:12px;color:#666;">Always use <code>"$line"</code> — quotes preserve spaces and special characters</p>
  </div>
  <div style="flex:1;border:1px solid #fde0e0;background:#fff8f8;border-radius:8px;padding:14px;">
    <strong>❌ Variable set inside loop disappears</strong>
    <pre style="margin:8px 0 0;font-size:13px;"><code>cat file | while read line; do
  count=$((count+1))
done
echo $count   # prints nothing</code></pre>
    <p style="margin:8px 0 0;font-size:12px;color:#666;">Pipe creates a subshell. Use <code>done &lt; file</code> instead to keep variables</p>
  </div>
  <div style="flex:1;border:1px solid #e0f8e0;background:#f8fff8;border-radius:8px;padding:14px;">
    <strong>✅ The correct full script</strong>
    <pre style="margin:8px 0 0;font-size:13px;"><code>#!/bin/bash
while read -r line; do
  echo "$line"
done</code></pre>
    <p style="margin:8px 0 0;font-size:12px;color:#666;"><code>-r</code> prevents backslash mangling. Quotes protect the value. Clean and complete.</p>
  </div>
</div>
