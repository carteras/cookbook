# Problem: Convert insights into testable, build-ready requirements

hci.user-research.persona.requirements

You’ve got patterns from your research and card sorting (e.g., “large, non-slip controls help one-handed use”). Now you need to turn those ideas into **clear, measurable requirements** so engineers can design, build, and check if the solution actually works—without relying on interviews or guesswork.

## Solution

---

## Steps that the student has to do to solve the problem

1. **Make a short list of priority tasks**
   Take your Top-10 task table. Circle the top 3–5 tasks (highest Importance, reasonable Difficulty).

2. **Write MUST/SHOULD statements**
   For each priority task, draft 3–7 requirements:

   * **MUST** = essential for the task to be possible.
   * **SHOULD** = strongly recommended; improves speed/safety/comfort.

3. **Make every requirement measurable**
   Add a number or condition you can check: size (mm), force (N), time (s), errors (count), reach (°/mm), contrast (ratio), steps (count).

4. **Add the “why” and the source**
   For each requirement, write a one-line **Rationale** tied to a task/insight, plus a **Source ID** (evidence log link). If you guessed a number, mark **Assumption=Y**.

5. **Choose a simple test method**
   For each requirement, define **How to test** using safe proxies: one-hand-only trials, gloves/weights for reduced grip, keyboard-only nav, low-contrast printouts, noise for voice tests.

6. **Check quick accessibility basics**
   Run fast checks that catch obvious issues: target size, spacing, contrast, keyboard/voice path, no required pinch grip, avoid long-press if possible.

7. **Add safety & failure notes**
   Note risks and safe limits (e.g., torque limits, sharp edges, heat). If a failure could hurt someone or damage gear, it’s a **MUST** with a clear limit.

8. **Put it into a requirements table**
   Columns: `ID | MUST/SHOULD | Statement | Measure | Method | Task | Rationale | Source | Assumption? | Priority (H/M/L)`

9. **Do a 5-minute sanity pass**

   * Is each statement testable by a classmate?
   * Does every requirement trace back to a task/insight?
   * Are assumptions clearly marked for later verification?

10. **Export and pin**
    Save as *hci.user-research.persona.requirements.csv* and print a one-page summary for the build team.

---

Technical discussion explaining how to do tasks.

* **Good requirement vs. vague wish**

  * *Vague:* “Make buttons big and grippy.”
  * *Good:* “MUST provide primary action targets **≥ 18 mm** diameter with **≥ 4 mm** spacing; surface friction high enough to prevent slip at **0.5 N** lateral force.”

* **Picking sensible numbers (when you don’t have users):**
  Start from your evidence (e.g., “larger targets reduce mis-presses”) and choose conservative values your team can build:

  * Touch/press targets for one-finger use: **14–20 mm** diameter is a practical starting range.
  * Avoid long-press: prefer **single press** or **press ≤ 0.5 s**; offer a safe **undo** instead.
  * Grip/actuation force: keep below what a light pinch can do (aim **≤ 10–15 N** for mechanical buttons; lower is kinder).
  * Session length: allow **task completion within 60–120 s** or support **pause/resume**.
    If you guess, label it **Assumption=Y** and plan to tune after bench tests.

* **Simple proxy tests you can run in class:**

  * **One-hand flow:** Tape one hand behind your back (or keep it flat on the desk). Complete the task 5 times; count misses, time, and hand-repositions.
  * **Grip reduction:** Wear a thick glove or hold a soft ball to limit finger movement.
  * **Vision/contrast:** Print UI at actual size in grayscale; check if targets and labels are still readable from **50–60 cm** away.
  * **Vibration/noise:** For voice controls, play background noise from a phone; check if commands still work.
  * **Fatigue:** If a step repeats many times, time how long until performance drops; design to reduce repetition.

* **Safety & hardware notes (mechatronics):**

  * **Torque/force limits:** Set caps that prevent sudden jerks (e.g., “MUST limit end-effector jerk to ≤ X m/s³ in assist mode”).
  * **Edges & pinch points:** “MUST have fillets ≥ 1 mm; no exposed pinch points in normal operation.”
  * **Mounting & stability:** “MUST operate on a lap/table without sliding; base friction coefficient ≥ X on smooth surface.”
  * **Haptics:** Provide a **low-intensity mode** or allow haptics **OFF** if strong vibration could cause unwanted muscle responses.

* **Traceability (why engineers love your table):**
  Every requirement maps to a **Task** (what it helps) and a **Source** (where the idea came from). This turns arguments into checklists and speeds design reviews.

* **Prioritising smartly:**

  * **MUST** items that **block** a task come first.
  * **SHOULD** items that boost speed/comfort come next.
  * Low-impact nice-to-haves become backlog.

* **Tiny template you can copy:**

  ```
  ID: R-1
  MUST/SHOULD: MUST
  Statement: Primary action target size ≥ 18 mm with ≥ 4 mm spacing; tactile cue present.
  Measure: Caliper/mm ruler; visual check for raised edge or texture.
  Method: Print/3D mockup at scale; 5 single-hand trials, record mis-presses.
  Task: T1 Navigate menu
  Rationale: Larger, tactile targets reduce mis-press and one-handed search time.
  Source: E12, E19 (evidence log)
  Assumption?: N
  Priority: High
  ```

## Discussion

* **Why should students care about this?**
  Clear, testable requirements turn “be empathetic” into **build steps**. They save time, prevent rework, and let you prove your design works using quick, safe tests you can run at school.

* **Where else is this deployed in Engineering?**
  Everywhere: medical device usability files (design inputs), automotive HMI specs (button size/force), robotics safety envelopes (speed/torque limits), aerospace checklists (human-in-the-loop constraints), and software acceptance criteria (pass/fail tests). The habit is the same: **write it, measure it, test it.**
