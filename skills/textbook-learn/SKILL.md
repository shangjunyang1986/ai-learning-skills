---
name: textbook-learn
description: >-
  Turn a technical book or PDF into an offline, visual learning page that teaches it as a
  COURSE — a single self-contained HTML file with a left table of contents, a whole-book
  chapter map / reading path, a few chapters broken down deeply (core ideas + the book's
  own figures downloaded locally + a step-by-step worked example), and per-chapter
  ACTIVE-RECALL QUIZZES plus a progress tracker that remembers what you've read and how you
  scored. Use this whenever the user wants to LEARN, STUDY, or "从入门到掌握" a specific BOOK
  or PDF/EPUB — e.g. "帮我学《动手学深度学习》/ 把这本 PDF 做成逐章学习页 + 测验 / I want to
  work through SICP / make me a study guide for this textbook / 给这本书做个带测验的学习网页".
  Triggers on a book title or a PDF/EPUB file/link + intent to learn/work through it.
  Distinguish from siblings: a GitHub repo URL → use github-project-learn; a bare topic/field
  like "学习 3DGS" → use domain-learn; a specific BOOK or PDF → THIS skill. Not for: answering
  one factual question from a book (just answer it), or building generic web apps.
---

# textbook-learn

Turn a **book / PDF** into a **single, offline-openable learning page** that teaches it like
a course: a map of the whole book and a reading path, then a few chapters broken down deeply,
each ending with a **worked example (例题精讲)** and an **active-recall quiz** — with a
**progress tracker** that remembers what you read and how you scored. Left = table of
contents, right = the chapter content, with the book's own figures downloaded locally.

This is the family's third sibling, after `github-project-learn` and `domain-learn`. The
output shell is the same; what differs is the **source** (one book, not a repo or the open
web), the **research** (parsing the book's structure + sourcing every claim back to a page),
the **pedagogy** (a chapter course, not a beginner→frontier roadmap), and the
**interactivity** (self-grading quizzes + worked-example reveals + a read/score tracker,
instead of a parameter demo).

## When to use
The description covers triggering. In short: a **book title** or a **PDF/EPUB file/link** +
any "I want to learn / work through / study this" intent. Examples: "帮我学《动手学深度学习》",
"把这本 PDF 做成逐章学习页 + 测验", "make me a study guide for this textbook", "work through SICP".

## Output shape
A folder (default `<book-slug>-learn/`) containing:
- `index.html` — self-contained (inline CSS+JS), double-click to open, fully offline
- `assets/` — the book's real figures/diagrams (and cover), downloaded

## Workflow (high level)
1. **Identify the book & confirm scope.** Pin down the exact edition; ask the user **which
   chapters to go deep on** (a whole book is too much — pick 3–6 representative chapters) and
   the depth. Tell them you'll build a single self-contained offline page with quizzes.
2. **Get the book's structure & content, sourced.** Parse the real table of contents and, for
   the chosen chapters, the actual core ideas, key equations/definitions, figures, and the
   chapter's own **exercises** (most textbooks end sections with them — these seed the quiz
   faithfully). **Every load-bearing claim, formula, and figure must come from the real book,
   cited to a page/section.** See `references/source-parsing.md` — this is the make-or-break.
3. **Design the chapter course.** Group the full TOC into 3–5 stages (打基础 → 核心 → 进阶 → 应用)
   as a **chapter map** with a "从这里开始读" path, then deep-dive the chosen chapters.
4. **Write each deep-dive chapter** as: core takeaways → key equations/definitions (rendered
   offline, no KaTeX CDN) → the book's figure → **one worked example** the learner reveals
   step by step → an **active-recall quiz** (MCQs that self-grade + free-recall flip cards),
   built from the chapter's real exercises and content. See `references/quizzes-and-examples.md`.
5. **Download media** with `scripts/fetch-media.sh` into `assets/` (handles Git LFS, blocked
   hosts, and SVG; drops anything that isn't a real image). Use relative `assets/...` paths.
6. **Generate the page** by copying `assets/template.html` (a complete worked example — the
   *Dive into Deep Learning* page) and replacing its content, keeping the CSS, the JavaScript
   (quiz grading, worked-example reveal, flip cards, progress tracker with localStorage,
   lightbox, scroll-spy, glossary search), and the section scaffolding.
7. **Verify it renders.** Open the page (a headless browser if available), confirm every
   figure loads, a quiz grades right/wrong, the worked example reveals, and the tracker
   counts. Fix before calling it done.

Read `references/workflow.md` for step-by-step detail, `references/page-design.md` for the
section list + components, `references/source-parsing.md` before parsing the book, and
`references/quizzes-and-examples.md` before writing the pedagogy.

## Bundled resources
- `assets/template.html` — the proven page (a worked **Dive into Deep Learning** example).
  Copy it, keep its CSS + JS (quiz grading, worked-example reveal, flip cards, localStorage
  progress tracker, lightbox, scroll-spy, searchable glossary, copy buttons), replace all
  content.
- `scripts/fetch-media.sh` — `./fetch-media.sh <out>/assets name.ext=url …`. Auto-fixes Git
  LFS pointers, routes blocked hosts through a proxy, accepts SVG, and drops invalid images.
  Run via the Bash tool (git-bash curl), not Windows cmd curl.

## Principles that make the page good
- **Faithful, never fabricated — and *sourced to the book*.** Every formula, definition, and
  quiz answer must be checkable against an actual page/section; cite it (a "出处" link). If a
  worked example uses numbers the book doesn't print, **say so** ("演算示例，书中未印此数").
  A learning page that teaches a wrong formula is worse than none.
- **A course, not a summary.** Organize for working *through* the book: a reading path, a few
  chapters done deeply, recall built in — not an encyclopedia dump of every chapter.
- **Quizzes are the point.** Active recall + worked examples are what make this beat reading
  the PDF. Build them from the book's own exercises; make them self-grade and stick (progress
  persists in localStorage).
- **Don't boil the whole book.** Deep-dive a representative few chapters; map the rest. Be
  honest that the other chapters follow the same pattern.
- **Offline-first.** Relative `assets/` paths; render math without a CDN; verify every
  download is a real image before referencing it.
- **Confirm scope (which chapters, what depth) before a long run.**
