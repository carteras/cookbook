# Cognitive Task Analysis (CTA) Report

## 1. Project & Task Overview
* **Project Name:** Initial Access & Reconnaissance — SSH Login Workflow
* **Target Task/Process:** Authenticating to a remote Linux host via SSH, orienting to the system via the login banner, and correctly classifying credential material (hashes) discovered during the session
* **Target Audience / User Persona:** Novice-to-mid-level operator (student, junior sysadmin, or early-career security practitioner) working through a guided or self-directed access exercise
* **Ultimate Goal:** Gain a validated, oriented foothold on the target system (`bushranger` / `10.13.37.10`) as user `os.00.00`, and correctly interpret any hash material encountered so it can be acted on appropriately
* **Operational Context / Environment:** Single-screen terminal session, self-paced (low external time pressure), but with a "first impression" risk — early missteps (misreading a prompt, skipping the MOTD, misclassifying a hash) tend to cascade into wasted effort later in the task

---

## 2. Task Decomposition (Behavioral & Cognitive)

| Step # | Physical Action *(What the user does)* | Cognitive Demand *(What the user thinks, recalls, or evaluates)* | Potential Pitfalls / Error Modes *(Where things typically go wrong)* |
| :--- | :--- | :--- | :--- |
| **1** | Types `ssh os.00.00@bushranger` or `ssh os.00.00@10.13.37.10` and presses enter | Recalls correct `user@host` syntax; recognizes hostname and IP as equivalent targets for the same machine | Typo in an IP octet or hostname; assuming the two targets are different machines; uncertainty about which credentials map to `os.00.00` |
| **2** | Reads the host-key fingerprint prompt and types `yes` | Understands trust-on-first-use (TOFU) — expected behavior on a first connection, not a warning to escalate | Reflexively accepting/dismissing without reading; not noticing a fingerprint *change* on a machine connected to before, which would be a genuine red flag |
| **3** | Enters password or key passphrase when prompted | Retrieves the correct credential; parses the resulting error (if any) to distinguish bad password vs. bad username vs. unreachable service | Mistyping the credential and misdiagnosing it as a network/connectivity problem |
| **4** | Runs the connect command *without* `-p 22` | Knows SSH's default port is 22; understands `-p` only overrides a non-default port; recognizes this host hasn't been reconfigured off default | Reflexively typing `-p 22` out of habit (harmless, but signals a gap in understanding); failing to try `-p <alt_port>` on a *different* box that refuses default-port connections |
| **5** | Pauses after login and reads the MOTD banner in full before running any command | Scans for version numbers, warnings, or anomalies (ASCII art, encoded strings); judges whether content is routine boilerplate or a deliberate signal | Clearing the screen or piping output away without reading it; dismissing the MOTD as decorative and missing an embedded clue |
| **6** | Locates and isolates a suspicious string from a file, dump, or the MOTD | Separates the string from surrounding labels/whitespace; judges whether it's a hash at all vs. some other data type | Including stray whitespace/characters that distort length-based identification |
| **7** | Counts characters, inspects the character set, and checks for a self-identifying prefix (`$1$`, `$2a$`, `$6$`, `$y$`, etc.) | Applies a length-to-algorithm lookup (32=MD5, 40=SHA-1, 64=SHA-256, etc.); distinguishes hex charset from Base64 charset; weighs source context (`/etc/shadow` vs. a web dump) | Assuming a 32-char hex string is automatically MD5 without checking context; confusing a reversible encoding (Base64/hex) with a one-way hash |
| **8** | Decides whether to attempt cracking the hash or move on | Understands hashing is one-way — there is no "decode" step, only guess-and-compare | Trying to "decode" a hash as if it were an encoding; spending time cracking a hash that isn't relevant to the task goal |

---

## 3. Critical Decision Points (CDM Profile)

### Decision Point 1: Accepting the Host-Key Fingerprint
* **Triggering Cues:** Terminal displays `The authenticity of host '...' can't be established` along with a key fingerprint, and blocks further input until answered
* **Primary Goals & Priorities:** Confirm this is genuinely the intended target before trusting it with credentials, without stalling the whole task over routine first-contact behavior
* **Alternatives Considered:** Reject the connection outright and investigate first (safe but often unnecessary on a known first-connection); accept immediately without reading (fast but skips the one moment where a real man-in-the-middle would surface); pause and cross-check the fingerprint against an out-of-band source if one is available
* **Heuristics / Mental Shortcuts Used:** "First connection to a known lab/target host → expected prompt → accept." This heuristic breaks down (and should trigger real scrutiny) if the *same* host previously had a *different* fingerprint — that pattern-mismatch is the actual trigger for suspicion, not the prompt itself

### Decision Point 2: Classifying and Acting on a Candidate Hash
* **Triggering Cues:** A string of unfamiliar characters appears in a file, dump, or banner — fixed-length-looking, not obviously readable text
* **Primary Goals & Priorities:** Correctly identify the hash type *before* investing time in cracking or further action, since a wrong guess wastes effort and a misclassification as "not a hash" causes a missed lead
* **Alternatives Considered:** Guess based on length alone (fast, but unreliable — several algorithms share output lengths); run an automated identifier tool immediately (fast and often reliable, but skips building the underlying skill and can mislabel ambiguous strings); manually cross-check length + charset + prefix + source context (slower, but most reliable, especially for prefixed formats)
* **Heuristics / Mental Shortcuts Used:** Experienced operators pattern-match on prefixes first (`$6$`, `$2a$`, etc.) as an instant classifier, and fall back to length/charset analysis only when no prefix is present. Novices tend to over-rely on length alone, which is the primary source of misclassification

---

## 4. Knowledge, Skills, and Abilities (KSAs) Required

* **Declarative Knowledge ("Know-What"):**
    * SSH default port (22) and the purpose of the `-p` flag
    * Fixed output lengths for common hash algorithms (MD5=32, SHA-1=40, SHA-256=64, etc.)
    * Self-identifying crypt prefixes (`$1$`, `$2a$/$2b$/$2y$`, `$5$`, `$6$`, `$y$`, `$argon2i$/$argon2id$`)
    * Conceptual distinction between hashing (one-way) and encoding (reversible, e.g. Base64/hex)
* **Procedural Knowledge ("Know-How"):**
    * Constructing and issuing an `ssh user@host` command correctly, with or without flags
    * Responding appropriately to host-key and authentication prompts
    * Manually inspecting a string's length and character set to narrow down a hash candidate
    * Using an identification tool (e.g., `hashid`) to confirm a manual hypothesis
* **Situational Awareness ("Environmental Monitoring"):**
    * Noticing anomalies in login banners (unexpected version strings, odd formatting, embedded encoded text)
    * Tracking whether a host's fingerprint is consistent across sessions (change = signal, not noise)
    * Recognizing when contextual source (e.g., which file a string came from) should override a purely mechanical length-based guess
