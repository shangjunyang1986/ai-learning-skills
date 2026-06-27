# Figure walk, demo & claim-check — the highest-value parts of a paper page

Reading a paper's abstract is easy; **understanding its method and judging its claims is the
hard part — and that's exactly what paper-learn front-loads.** Three things make a paper page
beat re-reading the PDF: the **figure-by-figure method walk**, **one interactive demo of the
core mechanism**, and the **claim-check** that separates what's proven from what's asserted.
These are to `paper-learn` what quizzes are to `textbook-learn` and the demo is to
`domain-learn`.

## The figure-by-figure method walk
- **Build it on the paper's own figures**, downloaded and lightbox-zoomable. For each figure,
  write from **what it actually shows** (its real caption + the section that describes it), not
  a paraphrase of the abstract.
- **Interleave equations.** Put each key equation in an `.eq` block right next to the figure /
  prose it belongs to, tagged with the paper's equation number. Render offline (`.eq`/`.m` +
  unicode) — no KaTeX CDN.
- **Add "why" callouts** for the non-obvious choices (the Transformer page has one for "why
  divide by √d_k"). These are where understanding actually happens.
- **Show data flow** with a `.flow` strip when the architecture has a clear pipeline.

## The interactive demo (`.demo` + `runDemo`)
- **Pick the paper's ONE core mechanism** and make it tangible: a knob the reader turns and a
  readout that changes. The bundled example lets you drag a query vector and watch scaled
  dot-product attention's softmax weights and output update live, with a toggle for the √d_k
  scaling (so you *see* why scaling matters).
- **Honesty is mandatory.** The caption must say it's a teaching simplification of the
  *mechanism's math* — NOT a trained model's real attention/output. A demo that implies "this
  is what the real model does" on invented weights is a lie. Teach the equation, not a
  pretend result.
- **Self-contained & offline.** Inline JS + DOM/canvas; no network, no CDN. Compute is cheap
  (recompute on input). Deterministic; no console errors.
- **If the paper has no clean tangible mechanism** (e.g. a pure theory or systems paper),
  don't bolt on a fake widget — replace the demo with a stronger figure walk / a step-through
  of the algorithm, and say why there's no slider.

## The claim-check cards (`.recall` + `.rcard` + `.verdict`)
This is paper-learn's signature and the most valuable reading skill it teaches: **sort the
paper's claims by evidence strength.** Each card = a claim on the front, a verdict badge, and
the reasoning revealed on flip.
- **Three verdicts** (already styled): `vd-ok` **demonstrated** (an experiment/result shows
  it — cite the table/section), `vd-hyp` **hypothesized** (asserted or used as motivation but
  not measured — quote the paper's hedge, e.g. "we suspect…", "may allow…"), `vd-part`
  **conditional** (true with caveats: cost, scope, "only on task Y").
- **Source every verdict.** The reasoning on the back should point to the section/table that
  justifies the label. The Transformer page's four cards are the model: "no recurrence still
  hits SOTA" (demonstrated, but MT-only), "sinusoidal PE beats learned" (hypothesized — the
  paper found them nearly identical), "self-attention always cheaper" (conditional — O(n²)),
  "multi-head attends to different subspaces" (motivation + qualitative figure, not a proof).
- **Never upgrade a hypothesis to a fact.** If you're unsure of the verdict, quote the paper
  and pick the more conservative label. Teaching a reader that a guess is proven is the exact
  failure this section exists to prevent.

## A short, labeled "what came after"
A paper's impact is worth a paragraph — but **mark it clearly as background, not the paper's
own claim** (the Transformer page says "这一段是后续发展的常识性背景，不是本论文自身的结论"
before mentioning BERT/GPT/ViT). Keep it qualitative; don't fabricate adoption numbers.

## The test
After reading the page, can the reader (1) explain the method from the figures, (2) feel the
core mechanism from the demo, and (3) correctly say which of the paper's claims were *shown*
vs *assumed*? If yes, ship it. If the demo could be mistaken for a real model's output, or any
claim verdict isn't sourced, fix it first.
