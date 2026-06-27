# Adding a new skill to the family

This family turns **a source** into **an interactive offline learning page**. Each new
skill keeps the same output shell and principles, and differs in three places:
**source, research strategy, and pedagogy**.

## The shared backbone (don't reinvent)
1. **Identify & scope** the source; confirm scope with the user before a long run.
2. **Research** with real fetches — never fabricate facts, numbers, or media URLs.
3. **Download media** with `shared/fetch-media.sh` (handles Git LFS + blocked-host proxies).
4. **Generate** a self-contained page from `shared/template.html` (keep CSS/JS, replace content).
5. **Be honest about gaps** — if something doesn't exist, the page says so.

See `shared/learning-page-design.md` for the page shell and component library.

## What each skill customizes
| Dimension | github-project-learn | domain-learn | textbook-learn | paper-learn |
|-----------|----------------------|--------------|----------------|-------------|
| Source | repo / org (GitHub API) | open web (papers, blogs, repos, videos) | one book / PDF | one paper / arXiv |
| Research | README + API + diagrams | multi-source + **citation & verification** (lean on a deep-research pattern) | **parse the book's TOC + chapters + exercises, sourced to a page** | **extract figures + equations + results, sourced to a section; sort claims by evidence** |
| Pedagogy | understand & onboard | **roadmap: beginner → advanced → hands-on** | **course: chapter map + deep-dive chapters + active recall** | **read-a-paper: motivation → figure-by-figure method → critical reading** |
| Interactivity | TOC, zoom, glossary search | **+ runnable demos / parameter sliders** | **+ self-grading quizzes, worked-example reveals, localStorage progress tracker** | **+ a mechanism demo, worked-example reveal, demonstrated/hypothesized claim-check cards** |

All four are now built — see `skills/<name>/` and a real sample under `samples/<name>/`.

## Conventions
- **Folder**: `skills/<name>/` with `SKILL.md` + `references/` + `scripts/` + `assets/`.
- **Naming**: keep the family legible (e.g. `*-learn`). Make the SKILL.md `description`
  disambiguate triggers across the family — e.g. a GitHub URL → `github-project-learn`;
  a bare topic like "学习 3DGS" → `domain-learn`; a book/PDF → `textbook-learn`.
- **Self-contained**: each skill bundles its **own copy** of the shared template/scripts
  (so it installs standalone). `shared/` is the source of truth — when you change the
  design system there, re-sync the copies into each skill:
  ```bash
  for s in skills/*/; do
    cp shared/template.html "$s/assets/template.html" 2>/dev/null
    cp shared/fetch-media.sh "$s/scripts/fetch-media.sh" 2>/dev/null
  done
  ```
- **Test it**: add `evals/evals.json` with a couple of realistic prompts and run the
  skill-creator eval loop (with-skill vs baseline) before calling it done.

## Don't over-abstract yet
Build the second skill concretely first. Once you can *see* what `domain-learn` and
`github-project-learn` genuinely share (beyond the page shell, which is already shared),
factor that out — not before. Rule of three.
