# Quizzes & worked examples — the highest-value part of a textbook page

Reading a textbook is passive; **active recall and worked examples are what make this page
beat reading the PDF.** They are to `textbook-learn` what the interactive demo is to
`domain-learn`. Build them from the book's own content, make them self-grade, and make the
result stick (the tracker persists in localStorage). A wrong answer key, though, drills a
falsehood — so correctness here is non-negotiable.

## The per-chapter unit
Every deep-dive chapter ends with the same three things, in order:
1. **例题精讲 (a worked example)** — one problem, fully reasoned, revealed step by step.
2. **A self-grading MCQ quiz** — 2+ questions that color right/wrong and explain.
3. **Free-recall flip cards** — 2 question→answer cards the learner tests themselves on.
Then the "读完本章" checkbox feeds the progress tracker.

## Worked examples (`.worked` + `reveal`)
- **Pick something the book actually works** (a derivation, a small numeric computation, a
  proof sketch, a "why does X fail" argument). The d2l template has four: deriving the normal
  equation, hand-computing softmax+cross-entropy, proving linear-layer collapse, and a 2D
  cross-correlation by hand.
- **Narrate the reasoning, not just the answer.** Use `ol.steps`; each step is one move. The
  learner clicks "展开解答" to reveal — so they can try first.
- **Be honest about numbers.** If the book doesn't print the specific values you use, compute
  them correctly and add a dim note: "演算示例，书中未印此数". Tie it back to the book's equation
  ("对应式 4.1.10").
- **End with the takeaway**, often a `.note.ok` — the one sentence to remember.

## MCQ quizzes (`.quiz` / `.q[data-correct]` / `pick`)
- **Source from real exercises + core claims.** Convert a real end-of-section exercise or a
  load-bearing takeaway into a question. Cite it in the explanation ("原书练习 1").
- **`data-correct` is a 0-based index** into the `.qopt` buttons. Set it honestly and
  double-check; the grader marks that option `.correct` and any wrong pick `.wrong`.
- **Write plausible distractors,** ideally common misconceptions (e.g. "平方损失对异常值最鲁棒"
  — wrong, that's absolute loss). A distractor that's obviously silly teaches nothing.
- **Always fill `.qexplain`** with the right answer letter + *why*, grounded in the book. The
  explanation is where the learning happens, win or lose.
- **2–3 questions per chapter** is plenty; quality over quantity.

## Free-recall flip cards (`.recall` / `.rcard` / `flip`)
- Pure active recall: a question on the front, the answer hidden until click. Use for the
  facts worth memorizing (a formula, a definition, a "when does X hold").
- Keep answers tight (one or two sentences). These complement the MCQs (recognition) with
  generation (harder, better for retention).

## Progress tracker (`.tracker` + localStorage)
- Two meters: **chapters read** (from the `.readbar` checkboxes) and **quiz accuracy** (from
  answered MCQs). Both persist under one localStorage key and survive reload; `resetProgress`
  clears them.
- **Wire it to your chapters:** edit `const chaps=['c3','c4','c5','c6']` in `updateTracker`
  and the "/ N" denominators to match your `data-chap` / `data-read` ids. If you add/remove a
  deep-dive chapter, update this list or the meter is wrong.
- localStorage on `file://` works in Chromium; the code wraps it in try/catch and degrades to
  in-session memory if a browser blocks it. Don't depend on cross-session persistence being
  guaranteed — it's a nicety, not load-bearing.

## The test
After a learner reads a chapter, does the worked example let them *try then check*, and do the
quiz + cards make them *retrieve* rather than reread? If a question can be answered without
having understood the chapter, it's a bad question — rewrite it. If every answer key is
verifiably correct against the book, ship it.
