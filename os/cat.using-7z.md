# Cognitive Task Analysis (CTA) Report #3

## 1. Project & Task Overview
*   **Project Name:** CLI Fundamentals Training
*   **Target Task/Process:** Using `7z` to extract the contents of a compressed archive file
*   **Target Audience / User Persona:** Novice command-line user who has located a `.7z`/`.zip`/other archive and needs its contents
*   **Ultimate Goal:** Successfully unpack the archive so that its contained file(s) (e.g., `secret.flag`) become accessible in the filesystem
*   **Operational Context / Environment:** Terminal session; may involve password-protected archives (common in CTF/security training contexts); low-to-moderate time pressure

---

## 2. Task Decomposition (Behavioral & Cognitive)

| Step # | Physical Action <br>*(What the user does)* | Cognitive Demand <br>*(What the user thinks, recalls, or evaluates)* | Potential Pitfalls / Error Modes <br>*(Where things typically go wrong)* |
| :--- | :--- | :--- | :--- |
| **1** | Confirms `7z` (p7zip) is installed by running `7z` or checking `--help` | Recalls that archive tools are often not installed by default; anticipates needing to install if missing | Assuming `7z` is available without checking, then being confused by a "command not found" error |
| **2** | Identifies the archive's exact filename and location (via prior `ls`) | Retrieves filename from memory/scrollback; confirms current working directory relative to the archive | Typing the wrong filename or extension (e.g., `.7z` vs `.zip` vs `.tar.gz`, which requires different tools/flags) |
| **3** | Chooses the correct 7z subcommand (`x` for extract-with-paths vs `e` for extract-flat) | Weighs whether preserving the internal folder structure matters for the task at hand | Using `e` (flat extract) when nested paths matter, causing filename collisions or loss of structure — or vice versa |
| **4** | Types `7z x archive.7z` and presses Enter | Anticipates a progress/output log and possibly a prompt for a password | Omitting an output directory flag (`-o`) when one is needed, causing files to extract into a crowded current directory |
| **5** | (If prompted) Enters a password | Recalls whether a password was provided/known, or decides a password needs to be found/cracked first | Assuming no password is needed and being surprised by a prompt; entering the wrong password without recognizing the retry cost |
| **6** | Watches extraction progress/output | Monitors for errors (e.g., "Wrong password", "Data Error", "CRC failed") mid-process | Missing an error buried in scrolling output and assuming success prematurely |
| **7** | Runs `ls` (or equivalent) on the extraction target to confirm results | Cross-checks that the expected file(s) now exist and are non-corrupted | Not verifying output, later discovering a partial/corrupted extraction only when trying to use the file |

---

## 3. Critical Decision Points (CDM Profile)

### Decision Point 1: Handling a Password-Protected Archive
*   **Triggering Cues:** `7z` prompts for a password immediately after the extract command is run
*   **Primary Goals & Priorities:** Determine whether a password is already known/available, or whether it must be obtained through another means (e.g., a hint, a separate file, a brute-force tool)
*   **Alternatives Considered:** Trying a commonly guessed/default password; searching nearby files or task context for a password hint; escalating to a password-cracking tool like `john` or `hashcat` if this is a security exercise
*   **Heuristics / Mental Shortcuts Used:** Experienced users check task context for a hint before attempting brute force; a common heuristic is "check for a README or hint file in the same directory first"

### Decision Point 2: Choosing Extract-with-Structure (`x`) vs. Flat Extract (`e`)
*   **Triggering Cues:** User realizes the archive contains nested folders, or discovers multiple files with the same name in different subfolders after a flat extraction
*   **Primary Goals & Priorities:** Preserve enough structure to correctly identify/locate the target file without cluttering the workspace
*   **Alternatives Considered:** Re-extracting with the other subcommand; manually specifying an output directory to contain the mess; inspecting archive contents first with `7z l archive.7z` (list) before extracting
*   **Heuristics / Mental Shortcuts Used:** A cautious pattern is "list before you extract" (`7z l`) to preview contents and avoid surprises — though novices often skip this and extract directly

---

## 4. Knowledge, Skills, and Abilities (KSAs) Required

*   **Declarative Knowledge ("Know-What"):**
    *   `7z` is an archive utility supporting multiple formats (7z, zip, tar, gzip, etc.)
    *   Archives may be password-protected and may preserve directory structure
    *   Difference between listing (`l`), extracting-with-paths (`x`), and extracting-flat (`e`)
*   **Procedural Knowledge ("Know-How"):**
    *   Correct command syntax: `7z x archive.7z`, `7z x archive.7z -o<directory>`, `7z l archive.7z`
    *   How to supply a password inline (`-p<password>`) vs. interactively when prompted
    *   How to install `7z`/`p7zip` if not already present (e.g., via package manager)
*   **Situational Awareness ("Environmental Monitoring"):**
    *   Watching extraction output for error/warning messages amid normal progress logs
    *   Noticing whether extracted content clutters the current directory vs. lands in a clean subfolder
    *   Being alert to context clues (hint files, filenames) that may indicate a password or next step

---

## 5. System Design & Training Recommendations

*   **User Interface (UI) / System Adjustments:**
    *   Encourage default use of an explicit output directory (`-o`) to avoid clutter and accidental overwrites
    *   Surface clear, distinguishable error messages for "wrong password" vs. "corrupted archive" vs. "unsupported format"
*   **Instructional / Training Needs:**
    *   Teach the "list before extract" habit (`7z l`) as a best practice to preview contents and avoid structural surprises
    *   Include a scenario with a password-protected archive to build the diagnostic habit of checking context for hints before escalating to brute-force tools
    *   Clarify the practical difference between `x` and `e` with a hands-on comparison exercise

---