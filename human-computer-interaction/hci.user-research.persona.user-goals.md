# Problem: Turn online findings into clear user goals and tasks (without interviews)

hci.user-research.persona.user-goals

You’ve gathered facts online about a user group (e.g., people with stroke-related one-handed use). Now you need to turn that information into a short, prioritized list of what users are actually trying to do, and the concrete tasks/steps they take—so engineers can design and test against something real.

## Solution


### Steps that the student has to do to solve the problem

1. **Pick one context**
   Choose one everyday situation your device/app will support (e.g., “use a gaming controller,” “operate a phone one-handed,” “launch a drone”).

2. **Harvest goals from sources**
   Skim your evidence log for sentences that sound like intentions: look for phrases like *wants to, needs to, tries to, has to*. Write each as a short **goal** (noun-ish): “play a racing game,” “answer calls,” “take off and land safely.”

3. **Convert goals → tasks**
   For each goal, write 1–3 **tasks** in verb form that someone actually does:

   * “Select game” → “navigate menu,” “start race,” “pause/quit.”
   * “Answer calls” → “unlock phone,” “accept call,” “switch to speaker.”

4. **Break tasks into steps**
   For each task, list 3–7 concrete **steps** (include what hand/device part is used). Keep steps observable: press/hold/move/say.

5. **Annotate context & constraints**
   Add details per task: where (lap/table/standing), tools (straps, mounts), and limits (reach, grip strength, target size, vision, fatigue). Pull these from your evidence log.

6. **Capture pains & common errors**
   For each step, note typical problems (e.g., “drops controller,” “mis-press on small buttons,” “long-press causes cramp”) with an evidence link.

7. **Define success criteria**
   Add simple, measurable outcomes per task: time-to-complete, max errors, max hand switches, can complete one-handed, can complete with rests.

8. **Score importance & difficulty**
   On 1–5 scales, rate each task’s **Importance** (how often + how critical) and **Difficulty** (constraints + errors). Use your sources; if unsure, mark as an assumption.

9. **Prioritise the top 10**
   Pick tasks with high Importance. If two tie, choose the one with lower Difficulty first (faster win). Put them in a **Top-10 Task Table**.

10. **Export your table**
    Columns: `Goal | Task | Steps | Context | Constraints | Pains/Errors | Success Criteria | Importance (1–5) | Difficulty (1–5) | Evidence Link | Assumption? (Y/N)`. Keep it to one page if you can.

---

Technical discussion explaining how to do tasks.

* **Goal vs Task vs Step (keep it clear):**

  * *Goal* = what the person wants (“play a game”).
  * *Task* = the action sequence to reach the goal (“navigate menu”).
  * *Step* = single observable action (“press A to select”). Writing in verbs helps you design inputs and test flows.

* **Finding goals from text:**
  Scan for verbs near people (“I need to…”, “I try to…”) in guides, forums, and manuals. Turn long sentences into short goal statements. If two sources say the same thing, that’s a good sign.

* **Making steps testable:**
  Write steps so someone else could try them exactly: “hold for 2 s,” “move stick right 10°,” “say ‘Pause’.” Avoid vague words like “handle” or “deal with.”

* **Constraints to watch (quick checklist):**
  Physical (reach, grip force, range of motion), Sensory (vision/contrast, vibration sensitivity), Cognitive (memory, timing), Environment (surface stability, noise). For robotics/mechatronics, each constraint often becomes a spec number later (e.g., target ≥ 16–20 mm, no required pinch grip).

* **Simple scoring that’s fair:**

  * **Importance (1–5):** frequency (1–3) + criticality (1–2).
  * **Difficulty (1–5):** number of steps (1–2) + constraint severity (1–2) + error risk (0–1).
    Use your evidence; if you guessed, mark `Assumption=Y` and flag it for later checking.

* **Common pitfalls (and fixes):**

  * Too many tasks → limit to 10; merge duplicates.
  * Vague success → add time/error/hand-switch limits.
  * Ignoring environment → add “where” (lap/table/standing) and any mounts/straps.

* **Quick self-checks (safe to do in class):**
  Try the task one-handed for 60–90 seconds with a harmless object (controller/phone). Count missed presses and hand-reposition events. This doesn’t replace real user testing, but it catches obvious issues.

## Discussion

* **Why should students care about this?**
  Turning fuzzy “user needs” into a short, scored task list gives you a build plan. It tells you which controls to design first, where to place them, what to measure in prototypes, and how to know when you’re done.

* **Where else is this deployed in Engineering?**
  Task analysis is standard in aerospace (checklists), automotive HMI (driver tasks), medical device usability (use errors), industrial ergonomics (workstation steps), and software DevOps (operational runbooks). The same “goal → task → step → measure” pattern shows up everywhere.
