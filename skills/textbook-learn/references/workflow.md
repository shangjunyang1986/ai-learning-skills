# Detailed workflow

## Step 0 — Identify the book & confirm scope

The input is a **book** (a title, or a PDF/EPUB file/link), not a repo or a bare topic. Pin
down:
- The exact book + edition (e.g. "Dive into Deep Learning, v1.0.3 / the d2l.ai online
  version", not just "the deep learning book"). If the user gave a file, open it; if a title,
  find the authoritative source (official site, publisher page, the book's own repo).
- **Which chapters to go deep on.** A whole textbook is far too much for one page. Ask the
  user to pick **3–6 representative chapters**, or propose a set yourself (usually the
  foundational early chapters + one or two showcase ones) and confirm. The rest of the book is
  shown as a *map*, not deep-dived.
- Depth and audience (total beginner vs reviewing). This shapes how much intuition each
  chapter needs and how hard the quizzes are.

Tell the user you'll produce a single self-contained offline HTML page (double-click to open)
with the book's figures downloaded, **a worked example and an active-recall quiz per deep-dive
chapter**, and a progress tracker.

## Step 1 — Parse the book, sourced

**This is where textbook-learn lives or dies.** A learning page that teaches a wrong formula
or invents an exercise is worse than useless. Read `source-parsing.md` first.

Two layers of content:

1. **Whole-book structure (cheap, do for the entire book).** The real top-level table of
   contents in order. Group it into 3–5 stages for the chapter map. Note prerequisites the
   book states, the license, how to run/obtain it, and 2–3 honest facts (adoption, edition,
   where the code lives) — each sourced.
2. **Deep content (only for the chosen chapters).** For each, fetch the actual section and
   extract, faithfully and with a source:
   - 3–5 **core takeaways** a learner could verify against the page.
   - The **key equations / definitions / theorems** it presents (with the book's own
     numbering as a locator).
   - **One worked example** worth narrating step by step — ideally one the book itself works
     (a derivation, a small numeric computation, a proof sketch). If you compute numbers the
     book doesn't print, flag them as illustrative.
   - The chapter's real **exercises** (most textbooks end sections with them) — these are the
     faithful seed for quiz questions.
   - The chapter's **key figure(s)**: the real image path/URL (verify it exists), caption, and
     what it shows.

Fan out with subagents when available (one per chapter). Have each **flag what it couldn't
verify**. Prefer fewer, correct facts over a confident wall of text.

## Step 2 — View the key figures yourself

Download and Read the core figures before writing about them. Write the chapter's explanation
from what the figure actually shows, not a paraphrase of the prose.

## Step 3 — Design the chapter course

- **Chapter map:** group the full TOC into stages (打基础 → 核心架构 → 进阶 → 应用/专题), mark the
  deep-dive chapters with a ★, and give an explicit **"从这里开始读"** reading path.
- **Deep-dive order:** sequence the chosen chapters the way the book builds (don't deep-dive
  chapter 11 before chapter 3's prerequisite).

## Step 4 — Write each deep-dive chapter (the pedagogy)

Each deep-dive section is a consistent unit:
1. **Core takeaways** — a short `ul.clean` of the chapter's load-bearing ideas.
2. **Key figure** — the book's real diagram (lightbox-zoomable), with a sourced caption.
3. **Key equations / definitions** — rendered with the offline `.eq` / `.m` styles (NOT a
   KaTeX CDN). Tag each with the book's equation number and cite the section.
4. **例题精讲 (worked example)** — a `.worked` block: a prompt, then steps the learner reveals
   by clicking. Narrate the reasoning, not just the answer.
5. **Active-recall quiz** — a `.quiz` block: 2+ self-grading MCQs (right/wrong coloring +
   explanation) built from the chapter's real exercises/content, plus 2 free-recall flip
   cards. End with the "读完本章" checkbox that feeds the tracker.

See `quizzes-and-examples.md` for how to write good questions (and how NOT to).

## Step 5 — Download media

Use `scripts/fetch-media.sh <out>/assets name.ext=url …`. Pass filenames **with extensions**
(`singleneuron.svg=...`). It fixes Git LFS pointers, proxies blocked hosts, accepts SVG/PNG/
JPG, and **drops** anything that isn't a real image. Never reference a dropped file. Watch
sizes — skip giant assets.

## Step 6 — Generate the page

Copy `assets/template.html` to `<out>/index.html` and replace its content. Keep the CSS and
**all** the JavaScript: quiz grading (`pick`), worked-example reveal (`reveal`), flip cards
(`flip`), the localStorage progress tracker (`saveProgress`/`loadProgress`/`updateTracker`),
lightbox, scroll-spy, copy buttons, and the glossary filter. Edit the `GLOSSARY` array and the
tracker's chapter list (`['c3','c4',...]` in `updateTracker`) to match your chapters. Use
relative `assets/...` paths. See `page-design.md`.

## Step 7 — Verify it renders

Open the page in a headless browser if you have one. Confirm: every figure loads (no broken
`<img>`), a quiz MCQ grades correct/wrong and reveals its explanation, the worked example
expands, a flip card flips, the glossary filters, and the tracker counts (and survives a
reload via localStorage). Fix anything broken before calling it done.

Confirm scope (which chapters, what depth) with the user before the long parse+build run, and
tell them which approach you're using (single self-contained HTML + assets folder, offline).
