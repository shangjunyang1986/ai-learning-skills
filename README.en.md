<!-- Language: [中文](README.md) · **English** -->

# ai-learning-skills

> Use AI to turn a **GitHub project / paper / technical book / unfamiliar field** into an
> **interactive, offline, shareable learning page** — fast.
> Built for **getting up to speed and personal learning** — deliberately lightweight: one
> self-contained HTML, double-click to open, usable on its own or combined.

![A study page generated for openai/whisper from a single sentence](docs/images/03-single-repo-whisper.png)

<p align="center"><sub>↑ Just say "help me learn github.com/openai/whisper" — generated automatically: left TOC, right content, the official architecture diagram downloaded locally, real star counts, click-to-zoom images.</sub></p>

---

## Sound familiar?

Your boss keeps dropping links on you: *"go learn this **GitHub project** / is this **arXiv paper** legit / research this **field** / get on top of this **book**."*
You open it and hit thousands of lines of README, a dozen repos with no obvious starting point, dozens of papers with no entry — **you'll learn it, but grinding through raw material is slow and easy to lose the plot.**

These skills let AI **digest, fact-check, and organize** the source into a structured learning page first — so you open it and start learning instead of hunting through a haystack.

## What it's for (and its boundaries)

- 🚀 **Built for learning fast / getting the lay of the land** — understand and get hands-on, not write an authoritative manual.
- 👤 **Personal learning first** — for yourself, not a team wiki, a docs site, or a knowledge-base system.
- 📄 **The output is a single static HTML, shareable** — self-contained, offline, double-click to open; no build, no server, no dependencies.
- 🧩 **Use one on its own, or combine them** — each skill installs and triggers standalone; want one entry point? `/learn` auto-routes.
- 🪶 **Deliberately lightweight** — one research-and-organize pass plus a static page; to update, just re-run it. No heavy infrastructure.

## The four skills (by source)

| Skill | Source it learns from |
|-------|----------------------|
| **[github-project-learn](skills/github-project-learn)** | A GitHub repo or a whole organization |
| **[domain-learn](skills/domain-learn)** | An open field (e.g. 3DGS, diffusion models) → beginner→advanced→hands-on roadmap + interactive demos |
| **[textbook-learn](skills/textbook-learn)** | A technical book / PDF → chapter course + worked examples + active-recall quizzes |
| **[paper-learn](skills/paper-learn)** | A paper / arXiv → figure-by-figure method walk + offline equations + mechanism demo + critical reading |

One front door, **[`/learn`](skills/learn)**: hand it any source and it auto-detects the type and routes to the right skill (asking one question when ambiguous). Each skill is also **self-contained and individually installable** — you don't need the whole repo to use one. And it's **faithful, never fabricated**: every number is from a real fetch, and if a thing doesn't exist the page says so.

> See real output now: [`samples/`](samples/) has offline-openable examples for every skill (just double-click `index.html`).

## Preview

A **single repo** and a **whole organization** automatically get different structures:

| Single project (e.g. OmAgent) | Whole org (e.g. QwenLM) |
|---|---|
| ![](docs/images/01-overview-omagent.png) | ![](docs/images/02-org-mode-qwen.png) |
| Straight to the deep dive: what-it-is / architecture / principle / code structure / deploy | An extra layer: project map + selection guide + a profile per key repo + flagship deep dive |

Built into every page: sticky TOC with scroll-spy, click-to-zoom images, copy buttons on code, a searchable glossary.

## What the output looks like

A folder with no build step, no server, fully offline:

```
<thing>-learn/
├── index.html   # self-contained (inline CSS+JS), double-click to open
└── assets/      # the source's real images / diagrams / media, downloaded
```

## Install & use

- **Packaged `.skill`**: download from a Release, drag it into Claude Code's skill installer.
- **From source**: `cp -r skills/<name> ~/.claude/skills/`.

Then just say something like *"help me learn github.com/openai/whisper"* and the skill triggers.

## Roadmap

The four source skills + the `/learn` entry are all done (see the table above and [`samples/`](samples/)). Next:

- [ ] Go deeper: export textbook quizzes to Anki / spaced repetition; multi-source blends (one topic = paper + repo + field)
- [ ] Candidate new sources: video/course-learn (lecture series → transcript notes + timestamps), docs-learn (doc sites)
- [ ] Extract the shared core (the page shell is already shared; revisit the research/pedagogy layer)

> Adding a skill? See [docs/adding-a-new-skill.md](docs/adding-a-new-skill.md). `shared/` is the single source of truth for the design system (each skill bundles its own copy so it installs standalone).

## License

MIT — see [LICENSE](LICENSE).
