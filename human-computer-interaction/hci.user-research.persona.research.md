# Problem: Ground user understanding without direct access to users

hci.user-research.persona.research

You need reliable, practical knowledge about a specific group of users (people with acquired physical disabilities) but you cannot interview them directly. How do you collect trustworthy information online and turn it into an engineering-ready brief?

## Solution

---

## Steps that the student has to do to solve the problem

1. Define scope (10 min)

* Pick one acquired impairment (e.g., partal blindness, missing digits or limbs, shoulder/arm paralysis, sever hand burns, post-stroke hemiparesis) and one context (e.g., gaming consoles and controllers, smartphones, laptops, programming, 3D printers).

2. Build a source list (15 min)

* Find 2–3 authoritative sites (rehab orgs, gov health, standards bodies), 2 community sources (forums/blogs), and 1–2 product/assistive-tech manuals or demo videos.

3. Create an evidence log (5 min)

* Make a table with columns: `Snippet | What it means (fact only) | Source link | Date | Tag | Assumption? (Y/N)`.

4. Extract observable facts (25–35 min)

* From each source, record only what you can observe/verify (abilities, limitations, tools, environments, workarounds). Avoid opinions/diagnosis.

5. Tag and tally (10 min)

* Tag each row: `ability`, `limitation`, `tool`, `environment`, `workaround`, `risk`. Count the most frequent/impactful items.

6. Write the 1-page brief (20 min)

* Sections: Problem/Context (2–3 lines), Top 10 Facts (bullets, each with a link), Typical Environment & Tools, Common Workarounds/Risks, Glossary (5–8 terms), Open Assumptions (what you need to verify later).

7. Ethics & safety pass (5 min)

* Use respectful language, avoid medical advice/claims, remove any personally identifying information from examples.

### Technical discussion

* **Pick one clear focus.**
  Choose *one* disability and *one* situation, e.g., “stroke-related one-handed use + gaming controller.” Keeping it narrow makes your research faster and your results clearer.

* **Where to look (safe, reliable places).**

  * Official/teaching sites: rehab hospitals, government health pages, accessibility standards.
  * Community voices: forums, blogs, YouTube demos showing real workarounds.
  * Product info: manuals for assistive tools (reachers, one-hand keyboards, large-button remotes).
    Tip: start with 2–3 official sources, then add 2 community sources and 1 product/manual.

* **How to search smart (copy/paste-friendly).**
  Try mixing medical + everyday words + your context:

  * `"one-handed" AND gaming controller AND "button size"`
  * `hemiparesis AND kitchen AND "grip" OR "reach"`
  * `"assistive device" AND smartphone AND "touch target"`
    Use quotes for exact phrases; use `AND/OR` to combine ideas.

* **What counts as a *fact* vs an *assumption*.**

  * **Fact:** Something you could see, measure, or repeat.
    *Example:* “Many players use rubber grips to stop controllers slipping.”
  * **Assumption:** Your guess or a number you didn’t confirm.
    *Example:* “Buttons probably need to be at least 15 mm.”
    Mark assumptions clearly so you can check them later.

* **Keep an evidence log (tiny table is fine).**
  Make columns like: `Snippet | Meaning | Link | Date | Tag | Assumption?`
  Example row:
  `“Uses one-handed cutting board with clamps” | Stabilizing helps if one hand is weak | <link> | 2025-08-25 | tool, workaround | N`

* **Simple tags to organize notes.**
  Use 5–6 tags max so you don’t get lost:
  `ability, limitation, tool, environment, workaround, risk`
  You can add `task` when a note describes a step someone tries to do.

* **Find patterns the easy way.**
  Count how often tags show up. Circle anything that:

  1. appears a lot, or
  2. blocks a task (not just slows it).
     Write each pattern as a one-line “insight,” e.g., “Large, non-slip controls reduce drop errors.”


### Example

| Snippet (quote/paraphrase)                                        | What it means (fact only)                                                   | Link                                                                               | Date       | Tag                     | Assumption? |
| ----------------------------------------------------------------- | --------------------------------------------------------------------------- | ---------------------------------------------------------------------------------- | ---------- | ----------------------- | ----------- |
| “Often stabilizes the controller on lap/table to avoid dropping.” | Needs a stable surface; avoid designs that require continuous grip force.   | [https://example.org/rehab-guide](https://example.org/rehab-guide)                 | 2025-08-25 | environment, workaround | N           |
| “Silicone sleeves or rubber grips reduce slipping.”               | Non-slip texture reduces drop errors; consider high-friction materials.     | [https://example.org/forum-post](https://example.org/forum-post)                   | 2025-08-25 | tool, workaround        | N           |
| “Remapping buttons to one side improves reach.”                   | Allow full button remap; cluster key actions near dominant hand.            | [https://example.org/controller-remap](https://example.org/controller-remap)       | 2025-08-25 | tech, limitation        | N           |
| “Analog stick + D-pad combo is hard one-handed.”                  | Avoid simultaneous opposite-hand inputs; prefer single primary stick flows. | [https://example.org/usability-note](https://example.org/usability-note)           | 2025-08-25 | limitation, task        | N           |


* **Turn notes into a 1-page brief (keep it skimmable).**
  Sections:

  1. **Context:** who + where (2–3 lines)
  2. **Top 5 facts:** short bullets, each with a link
  3. **Environment & tools:** what’s around the user
  4. **Common workarounds/risks:** what they already do; what can go wrong
  5. **Glossary:** 5–8 tricky words in plain English
  6. **Open assumptions:** what you still need to verify


* **Be respectful and safe.**

  * Don’t share names or any private details you find online.
  * Describe people by what they *do* and *need*, not by labels (“prefers large targets” vs “the disabled”).
  * Don’t give medical advice; just report what you observed and where you found it.

* **Quick reality checks you can do yourself.**

  * Try one-hand-only for a minute on a controller or phone; notice where you struggle.
  * Increase button/target size in a mockup and see if you miss less.
  * Time how long common tasks take with and without a workaround (e.g., non-slip mat).


## Discussion

* Why should students care about this?

  * It prevents “designing for yourself,” reducing rework and failure in testing. It converts vague empathy into concrete, testable constraints (sizes, forces, timings, tolerances) that engineers can build against.

* Where else is this deployed in Engineering?

  * Medical device usability files, automotive human-factors (reach/vision envelopes), aerospace checklists, industrial ergonomics, assistive-tech product design, and standards-driven design reviews (design inputs/verification criteria).

## Outputs 

In groups of 2 or 3 create a slide deck presentation on your findings. 
