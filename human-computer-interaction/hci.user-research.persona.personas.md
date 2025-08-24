# Problem: Communicate the user clearly on one page (so engineers can build)

hci.user-research.persona.personas

You’ve got research, tasks, insights, and requirements—but it’s still hard for a build team to picture the user. You need a **single, skimmable persona** that turns findings into a realistic profile with clear design implications, without stereotyping or sharing private details.

## Solution

---

## Steps that the student has to do to solve the problem

1. **Set the scope (2–3 lines).**
   Pick one acquired impairment + one context already studied (e.g., hemiparesis + console gaming). State what this persona is for (which product/task).

2. **Create the one-pager skeleton.**
   Sections: **ID stub**, **context**, **capabilities/limits**, **environment/tools**, **assistive tech**, **top goals (3–5)**, **top tasks (3–5)**, **pains/workarounds (3–5)**, **accessibility needs**, **success metrics**, **evidence quotes**, **design implications (3–5)**, **non-goals**, **assumptions**.

3. **Fill with evidence, not guesses.**
   For every claim, add a source ID from your evidence log (E#). Mark any guess as **Assumption=Y**.

4. **Make it skimmable.**
   Use short bullets, simple words, numbers where possible (mm, N, s). Prioritize “top 3–5” in each section. Keep to one page.

5. **Write 3–5 design implications.**
   Each implication should point to a requirement (e.g., “Targets ≥ 18 mm; no long-press; strap points for stable mounting”).

6. **Add non-goals & boundaries.**
   One line on what this persona **is not** (e.g., not two-handed expert play; not voice-only control).

7. **Tone & ethics check.**
   People-first language, no medical advice, no identifying details. Avoid stereotypes; focus on tasks and environments.

8. **Version and export.**
   Add version/date and a mini change log. Export to PDF and pin next to the requirements sheet.

---

Technical discussion explaining how to do tasks.

* **Persona ≠ stereotype.**
  Build from **tasks and constraints** you can design for; skip irrelevant hobbies. If a detail doesn’t change the design, leave it out.

* **Evidence mapping (traceability).**
  After each bullet, include `(E12, E19)` to point back to your log. If you used a number you chose (e.g., 18 mm), write `(Assumption)` until tested.

* **Keep numbers practical.**
  Express needs as testable specs: target size (mm), force (N), time (s), steps (count), reach (mm/°), contrast (ratio). These align with your requirements table.

* **Layout tips for a one-pager.**
  Left column: **Context**, **Capabilities/limits**, **Environment/tools**.
  Right column: **Goals/Tasks**, **Pains/Workarounds**, **Design implications**, **Success metrics**.
  Use icons/silhouettes instead of photos to avoid identifying anyone. Ensure good text contrast.

* **Good fields (copy/paste template):**

  ```
  Persona ID: “P1 – One-hand console play” (v1.0, 2025-08-25)
  Context (2–3 lines): One-handed use after stroke; plays seated on lap/table. (E03)
  Capabilities/Limits (top 5): Can use right thumb and palm; weak grip; fatigue after 10–15 min; prefers large, tactile targets. (E05, E12)
  Environment/Tools: Lap/table surface; silicone sleeve; strap points help. (E07)
  Assistive Tech: Button remap; optional foot pedal for secondary actions. (E09)
  Top Goals: Play racing games; navigate menus independently; pause fast. (E01, E04)
  Top Tasks: Select game; start race; pause/quit; remap controls. (E01, E10)
  Pains/Workarounds: Slips; mis-presses on small buttons; long-press cramps; uses non-slip sleeve. (E05, E08)
  Accessibility Needs: Targets ≥ 18 mm; ≥ 4 mm spacing; low-force actuation; no required long-press; stable base. (E12) (Assumption on exact mm)
  Success Metrics: Menu navigate ≤ 30 s; ≤ 1 mis-press per flow; complete one-handed; rest allowed between races. (E02)
  Quotes (short, cited): “Rubber grips stop slips.” (E05)
  Design Implications (3–5): Large, high-friction targets; strap-ready shell; full remap on one side; optional foot/voice for secondary. (E05, E09)
  Non-Goals: Competitive two-stick combos; reliance on pinch grip.
  Assumptions to Verify: 18 mm target size; 0.5 s max press. (A1, A2)
  ```

* **Mechatronics specifics to include.**
  Add physical envelopes (hand span range you’ll support), mounting options (lap/table), duty cycle (active use ≤ X min then rest), and safe forces/jerk limits if hardware moves near the user.

* **Fast classroom check.**
  Do a 2-minute “persona walk-through”: can P1 complete the top task **within the listed metrics** using your paper/3D mock? If not, update **Design Implications** first, then requirements.

## Discussion

* **Why should students care about this?**
  A crisp persona keeps everyone building the same thing for the same person. It turns scattered notes into one page of **constraints and checks**—fewer arguments, faster prototypes, better tests.

* **Where else is this deployed in Engineering?**
  Operator profiles in industrial robotics, driver archetypes in automotive HMI, patient profiles in medical devices, mission operator roles in aerospace, and “user classes” in safety/usability files—all are persona-style summaries that guide specs and testing.
