# Problem: Turn messy notes into clear, prioritized insights

hci.user-research.persona.card-sorting

You’ve got lots of snippets from online research about users with acquired physical disabilities, plus a task list. It’s messy. How do you quickly find patterns and decide what really matters for design?

## Solution

---

## Steps that the student has to do to solve the problem

1. **Prep your cards (10–15 min)**

   * Collect 30–60 of your strongest snippets from the evidence log.
   * Make one card per snippet (paper or digital). Include: short phrase + source ID.
   * Pre-tag each card with one tag: `goal / pain / constraint / workaround / environment / tech`.

2. **Open sort (15 min)**

   * Lay out cards. Group by similarity (what feels related in real use).
   * Aim for 5–10 clusters. If a cluster grows past \~10 cards, split it.

3. **Name clusters (10 min)**

   * Give each cluster a short, action-focused name (e.g., “avoid slip,” “one-handed reach,” “reduce long-press”).
   * Write one sentence: “This cluster is about … because …”

4. **Score each cluster (10 min)**

   * For every cluster, rate on 1–5 scales:

     * **Frequency**: how often it appears in your cards.
     * **Impact**: does it **block** a task (5) or just **slow** it (2–3)?
     * **Confidence**: mix of source quality + agreement across sources.
   * Compute **Priority = Frequency + Impact + Confidence** (range 3–15).

5. **Write insight cards (15–20 min)**
   For the top 5–8 clusters, create one “insight card” each with:

   * **Title** (short, punchy)
   * **Evidence bullets** (2–4, with source IDs)
   * **Why it matters** (1–2 lines tied to a task)
   * **Design hint** (1–2 lines you could build/test)

6. **Sanity checks (5–10 min)**

   * Variety: do your insights cover different tags (not all “pains”)?
   * Balance: not all from one source or one person’s story.
   * Traceability: every claim links back to at least one card.

7. **Export deliverables (5 min)**

   * Save: *insights.md* (cards), *clusters.png* (photo/screenshot), and a CSV mapping `Card → Cluster`.

---

Technical discussion explaining how to do tasks.

* **What counts as “similar”?**
  Group by what would drive the same design move. Examples: “non-slip surfaces,” “large, tactile targets,” “stable mounting,” “single-hand flows,” “short interaction bursts (fatigue).”

* **Open vs. closed sort:**

  * *Open sort:* you invent cluster names as you go (good early on).
  * *Closed sort:* you sort into fixed buckets (use later for speed or to compare teams).

* **Keep clusters actionable:**
  Name them so an engineer immediately sees a direction:

  * Weak: “Buttons.”
  * Strong: “Buttons need bigger, more distinct shapes.”

* **Scoring tips (be fair, be fast):**

  * **Frequency:** count cards in the cluster, normalize to 1–5 (e.g., 1–2=1, 3–4=2, 5–6=3, 7–8=4, 9+=5).
  * **Impact:** 5=blocks task, 3=causes errors, 1=minor annoyance.
  * **Confidence:** 5=multiple high-quality sources agree; 3=mixed; 1=one anecdote.
  * If anything is a guess, add “(assumption)” and lower Confidence by 1.

* **Make great insight cards (template):**

  ```
  Title: Large, non-slip targets reduce drop errors
  Evidence: [E12], [E19], [E27]
  Why it matters: Critical for one-handed menu navigation (prevents task blocks).
  Design hint: Target size ≥ 16–20 mm and high-friction surface on controls.
  ```

  Keep each to <100 words so teams actually use them.

* **Team check for bias:**
  Have two students sort the same cards separately, then compare. If clusters are wildly different, discuss why and adjust names/scores (not the raw evidence).

* **When you’re stuck:**
  If a card fits two clusters, duplicate it temporarily; later, decide which design move it supports more strongly.

## Discussion

* **Why should students care about this?**
  Card sorting turns raw notes into 5–8 clear priorities you can design and test. It prevents “cool feature first” thinking and focuses effort where it helps users most.

* **Where else is this deployed in Engineering?**
  Affinity mapping appears in root-cause analysis (8D), FMEA prep (grouping failure modes), agile story mapping (grouping user stories), quality engineering (KJ method), and service reliability reviews (clustering incident causes).
