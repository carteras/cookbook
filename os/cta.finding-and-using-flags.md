# Cognitive Task Analysis (CTA) Report

## 1. Project & Task Overview

* **Project Name:** CTF Flag Identification & Submission Workflow
* **Target Task/Process:** Locating a CTF flag (formatted as an MD5 hash) in terminal output and submitting it via a web-based scoring platform
* **Target Audience / User Persona:** Novice-to-intermediate CTF participant; comfortable with basic terminal use but not yet fluent in pattern recognition for flag formats
* **Ultimate Goal:** Correctly identify the flag string among other terminal output, transfer it without corruption, and submit it to the scoring platform to earn points
* **Operational Context / Environment:** Time-constrained (competition clock running), multi-window setup (terminal + browser), possible scoreboard pressure from competitors, output may be cluttered with debug text, ANSI color codes, or multiple hash-like strings

---

## 2. Task Decomposition (Behavioral & Cognitive)

| Step # | Physical Action <br>*(What the user does)* | Cognitive Demand <br>*(What the user thinks, recalls, or evaluates)* | Potential Pitfalls / Error Modes <br>*(Where things typically go wrong)* |
| :--- | :--- | :--- | :--- |
| **1** | Runs exploit/enumeration command in terminal | Anticipates what output format the flag will take; scans for anomalies vs. expected noise | Missing the flag if it scrolls past in a long output buffer |
| **2** | Visually scans terminal output for a 32-character hexadecimal string | Pattern-matches against MD5 structure (32 hex chars: 0-9, a-f); distinguishes flag from other hashes (e.g., file checksums, session IDs) present in output | Mistaking a non-flag hash (e.g., a hashed password or checksum) for the actual flag; missing a wrapper format like `flag{...}` or `FLAG:` prefix |
| **3** | Confirms flag format/context clues (e.g., preceding label like "Flag:" or surrounding braces) | Cross-checks contextual markers to validate this is *the* flag, not incidental data | Overlooking a required wrapper (some CTFs want `flag{md5hash}`, not just the raw hash) |
| **4** | Selects/highlights the string with mouse or keyboard (click-drag or double-click/triple-click) | Judges selection boundaries precisely — must not include trailing whitespace, newline, or adjacent characters | Accidentally including a trailing space, quote mark, or newline character in the selection |
| **5** | Copies selection (Ctrl+C / Cmd+C, or right-click → Copy) | Confirms copy action registered (visual highlight, or mental note of keystroke) | Overwriting clipboard with a different copy action before pasting; copy failing silently in some terminal emulators (need Ctrl+Shift+C) |
| **6** | Switches to browser window/tab with the submission form | Locates correct input field; may need to re-identify correct challenge among several open tabs | Pasting into the wrong challenge's submission box on a multi-challenge scoreboard |
| **7** | Clicks into flag submission text field | Confirms field is empty / clears any placeholder text | Pasting on top of unremoved placeholder text, corrupting the string |
| **8** | Pastes (Ctrl+V / Cmd+V, or right-click → Paste) | Visually verifies pasted text matches copied text (length, characters) | Silent paste failures; formatting characters inserted by some terminals/browsers; case-sensitivity mismatches if platform is strict |
| **9** | Submits the form (clicks Submit / presses Enter) | Anticipates system feedback (success/failure message) | Submitting before verifying paste accuracy, wasting an attempt on rate-limited platforms |
| **10** | Reads submission feedback | Interprets success/error message; if error, initiates root-cause diagnosis (wrong flag? wrong format? whitespace issue?) | Misreading "incorrect flag" as "wrong challenge entirely" and abandoning a correct approach prematurely |

---

## 3. Critical Decision Points (CDM Profile)

### Decision Point 1: "Which hex string is actually the flag?"
* **Triggering Cues:** Terminal output contains multiple 32-character hex strings (e.g., MD5 checksums of files, session tokens, the actual flag)
* **Primary Goals & Priorities:** Avoid wasting a submission attempt on a decoy or irrelevant hash; some platforms rate-limit or penalize wrong guesses
* **Alternatives Considered:** Submit the first hash-like string seen vs. search for contextual labels (e.g., "flag", "FLAG{}", nearby comments) vs. try all candidates sequentially
* **Heuristics / Mental Shortcuts Used:** Experienced players look for proximity to keywords ("flag", "congrat", "success"), unusual formatting (braces, distinct color if terminal supports ANSI), or output that appears deliberately "surfaced" rather than incidental to program execution

### Decision Point 2: "Is my copy-paste clean, or should I retype it?"
* **Triggering Cues:** Submission fails despite the flag appearing visually correct
* **Primary Goals & Priorities:** Diagnose whether the failure is due to an invalid flag (wrong approach) or a transcription/clipboard error (right flag, bad paste)
* **Alternatives Considered:** Re-copy and re-paste vs. manually retype the string vs. paste into a plain-text scratch area first to inspect for hidden characters
* **Heuristics / Mental Shortcuts Used:** Experienced users paste into a neutral text field (like a URL bar or notepad) first to visually inspect for stray whitespace, quotes, or line breaks before trusting the paste into the actual scoring form — a "verify before commit" habit

---

## 4. Knowledge, Skills, and Abilities (KSAs) Required

* **Declarative Knowledge ("Know-What"):**
  * MD5 hashes are always exactly 32 hexadecimal characters (0–9, a–f)
  * Common flag wrapper conventions (e.g., `flag{...}`, `FLAG:`, `CTF{...}`) vary by platform/competition and must match exactly
  * Clipboard behavior differences between terminal emulators (some require modifier keys for copy) and browsers

* **Procedural Knowledge ("Know-How"):**
  * Precise text selection techniques (double-click for word-select vs. click-drag for exact ranges) to avoid extraneous characters
  * Keyboard shortcuts for copy/paste across OS and application contexts
  * Verifying clipboard contents before submission (e.g., pasting into a scratch field first)

* **Situational Awareness ("Environmental Monitoring"):**
  * Tracking which browser tab/challenge corresponds to the terminal session currently active
  * Monitoring submission rate limits or attempt caps on the scoring platform
  * Watching for scrollback loss in the terminal if output exceeds buffer/history

---
## 5. Recommended Interventions / Training Aids

### 5.1 Quick-Reference: Spotting an MD5 Flag

**Core pattern:** MD5 hashes are always exactly **32 characters**, using only `0-9` and `a-f` (lowercase) or `A-F` (uppercase, less common).

**Regex to visually/mentally validate a candidate string:**
```
^[a-fA-F0-9]{32}$
```

**If the platform wraps flags** (common in many CTFs), the pattern extends to:
```
^flag\{[a-fA-F0-9]{32}\}$
```
or whatever the platform's specific wrapper is (`CTF{}`, `FLAG{}`, etc. — always check the challenge description or rules page for the exact format, since submitting an unwrapped hash when a wrapper is required is a common false-negative).

**Fast mental checklist when scanning output:**
- [ ] Is it exactly 32 characters long? (count in groups of 8 if unsure — 8+8+8+8)
- [ ] Does it contain *only* hex characters (no g–z, no symbols except inside a wrapper)?
- [ ] Is it near a contextual label (`flag`, `success`, `congrats`, a comment marker)?
- [ ] Is it different from other hashes visible in the same output (checksums, hashes of files, session tokens)?

If a string fails any of these, it's likely a decoy or unrelated hash (e.g., an md5sum of a downloaded file, a session cookie, a hashed password from a dumped database).

---

### 5.2 Copy-Paste Verification Checklist

Use this before clicking Submit — it takes 5 seconds and prevents wasted attempts:

1. **[ ] Select cleanly** — use double-click (word select) if the terminal treats the hash as one token, or click-drag with visual confirmation of start/end boundaries. Avoid trailing spaces or the newline at the end of the line.
2. **[ ] Copy** — confirm with a visual/audio cue if your terminal gives one; if unsure, some terminals need `Ctrl+Shift+C` instead of `Ctrl+C`.
3. **[ ] Paste into a scratch area first** (browser URL bar, notes app, or a blank text field) — *not* directly into the submission box.
4. **[ ] Visually inspect the scratch paste:**
   - Length looks like 32 characters (or wrapper + 32)
   - No leading/trailing whitespace
   - No stray quote marks, backticks, or line breaks
   - No duplicated/truncated characters
5. **[ ] Re-copy from the scratch area** (guarantees a clean clipboard) and paste into the actual submission field.
6. **[ ] Confirm the correct challenge/tab** is active before submitting — especially in multi-challenge competitions.
7. **[ ] Submit.**

---

### 5.3 Training Aid: Common Failure → Diagnosis Table

| Symptom | Likely Cause | Fix |
| :--- | :--- | :--- |
| Submission rejected, flag "looks right" | Trailing whitespace or newline in paste | Re-copy via scratch-area method (5.2) |
| Submission rejected, flag "looks right" | Case mismatch (some platforms are case-sensitive) | Check platform rules; retype in exact case shown |
| Submission rejected | Missing required wrapper (`flag{...}`) | Check challenge instructions for exact format |
| Submitted wrong hash entirely | Multiple hashes in output, wrong one selected | Apply 5.1 checklist to isolate correct candidate |
| Paste does nothing / pastes old clipboard content | Copy action didn't register before switching windows | Redo copy step, confirm before switching apps |
| Flag correct but attempt still fails | Submitted to wrong challenge's input box | Verify tab/challenge context before submitting |

