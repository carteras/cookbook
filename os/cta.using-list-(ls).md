# Cognitive Task Analysis (CTA) Report #1

## 1. Project & Task Overview
*   **Project Name:** CLI Fundamentals Training
*   **Target Task/Process:** Using `ls` to locate a known target file (`secret.flag`) within a filesystem
*   **Target Audience / User Persona:** Novice command-line user (e.g., new student, CTF beginner, junior sysadmin)
*   **Ultimate Goal:** Confirm the presence and exact path/location of `secret.flag` so it can be acted upon (read, moved, submitted, etc.)
*   **Operational Context / Environment:** Terminal session, single screen, low time-pressure in a learning context but potentially high time-pressure in a CTF/exam setting; no GUI file browser available

---

## 2. Task Decomposition (Behavioral & Cognitive)

| Step # | Physical Action <br>*(What the user does)* | Cognitive Demand <br>*(What the user thinks, recalls, or evaluates)* | Potential Pitfalls / Error Modes <br>*(Where things typically go wrong)* |
| :--- | :--- | :--- | :--- |
| **1** | Opens a terminal and orients to the current shell prompt | Recalls that filesystem navigation starts from a "current working directory"; may check prompt for cues (path shown in PS1) | Assuming the current directory without verifying (skipping `pwd`) |
| **2** | Types `pwd` (optional) to confirm current location | Builds a mental map of "where am I" relative to "where might the file be" | Skipping this step and getting lost later when `ls` output doesn't match expectations |
| **3** | Types `ls` and presses Enter | Anticipates a list of visible files; scans output for the string `secret.flag` | Missing the file because it's hidden (dotfile) and `ls` without flags won't show it |
| **4** | Reads the output list | Pattern-matches filenames against the target string; distinguishes files from directories (sometimes by color/suffix) | Confusing similarly named files (e.g., `secret.flag.bak`, `Secret.Flag` — case sensitivity) |
| **5** | If not found, types `ls -a` or `ls -la` | Recalls that some files are hidden by default; recalls flag syntax from memory or `man`/`--help` | Forgetting flag syntax; conflating `-a` (all) with `-l` (long format), leading to unnecessary confusion |
| **6** | If still not found, considers subdirectories | Reasons that the file may not be in the current directory; forms a search strategy (recursive search vs. manual `cd`) | Manually `cd`-ing into every directory one by one instead of using a more efficient approach (`ls -R`, `find`) |
| **7** | Types `ls -R` or navigates into a subdirectory and repeats `ls` | Tracks directory hierarchy mentally; avoids getting "lost" in nested paths | Losing track of current location in deep directory trees; forgetting to `cd ..` back |
| **8** | Locates `secret.flag` in the output | Confirms exact filename spelling/casing before use in the next command | Mistyping the filename when later referencing it (e.g., in `cat`) due to not copying it precisely |

---

## 3. Critical Decision Points (CDM Profile)

### Decision Point 1: Choosing to Reveal Hidden Files
*   **Triggering Cues:** Plain `ls` returns a file list that does not contain `secret.flag`
*   **Primary Goals & Priorities:** Determine whether the file is truly absent or simply hidden, without wasting time searching the wrong directory
*   **Alternatives Considered:** Re-running plain `ls` (assuming a typo/output was misread); immediately jumping to `find` or `locate`; giving up and asking for help
*   **Heuristics / Mental Shortcuts Used:** Rule of thumb — "files starting with a dot are hidden in Unix-like systems, so append `-a`"; this is often a memorized convention rather than derived reasoning

### Decision Point 2: Deciding Whether to Search Recursively or Navigate Manually
*   **Triggering Cues:** File not found even with `-a` in the current directory
*   **Primary Goals & Priorities:** Balance thoroughness (don't miss the file) against efficiency (don't waste time or commands)
*   **Alternatives Considered:** Manually `cd` into each visible subdirectory and re-run `ls`; use `ls -R` for a recursive listing; escalate to `find . -name "secret.flag"` (a different, more powerful tool)
*   **Heuristics / Mental Shortcuts Used:** Novices often default to trial-and-error manual navigation; more experienced users pattern-match to "if I don't know the location, use a search tool" and switch to `find`

---

## 4. Knowledge, Skills, and Abilities (KSAs) Required

*   **Declarative Knowledge ("Know-What"):**
    *   `ls` lists directory contents; default behavior hides dotfiles
    *   Filesystem structure is hierarchical (directories contain files/subdirectories)
    *   Filenames in Unix-like systems are case-sensitive
*   **Procedural Knowledge ("Know-How"):**
    *   Syntax for common flags: `-a` (show hidden), `-l` (long/detailed format), `-R` (recursive)
    *   How to combine flags (e.g., `ls -la`)
    *   How to change directories (`cd`) and return to a previous directory (`cd ..` or `cd -`)
*   **Situational Awareness ("Environmental Monitoring"):**
    *   Tracking current working directory throughout navigation
    *   Noticing color-coding or suffixes that distinguish files, directories, and symlinks in terminal output
    *   Watching for near-miss filenames that could be mistaken for the target

---

## 5. System Design & Training Recommendations

*   **User Interface (UI) / System Adjustments:**
    *   Configure shell prompts (PS1) to always display the current working directory, reducing the memory burden of tracking location
    *   Enable colorized `ls` output by default so file types are visually distinguishable at a glance
*   **Instructional / Training Needs:**
    *   Teach the "hidden file" convention explicitly and early, since it is a common silent failure point for novices
    *   Provide a scaffolded exercise progressing from `ls` → `ls -a` → `ls -R` → `find`, so learners build a mental model of when each tool is appropriate
    *   Emphasize precise filename verification (copy-paste habits) to prevent downstream typo errors in subsequent commands

---
