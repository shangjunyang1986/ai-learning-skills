<!-- Language: [中文](README.md) · **English** -->

# ai-learning-skills

[![license MIT](https://img.shields.io/badge/license-MIT-blue)](LICENSE) ![Claude Code skill](https://img.shields.io/badge/Claude_Code-skill-7c5cff) ![also Codex · Gemini · OpenCode](https://img.shields.io/badge/also-Codex_Gemini_OpenCode-22d3ee) ![output offline single HTML](https://img.shields.io/badge/output-offline_single_HTML-46c98b) ![personal use](https://img.shields.io/badge/use-personal-f5b94d)

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

## Preview

A **single repo** and a **whole organization** automatically get different structures:

| Single project (e.g. OmAgent) | Whole org (e.g. QwenLM) |
|---|---|
| ![](docs/images/01-overview-omagent.png) | ![](docs/images/02-org-mode-qwen.png) |
| Straight to the deep dive: what-it-is / architecture / principle / code structure / deploy | An extra layer: project map + selection guide + a profile per key repo + flagship deep dive |

Built into every page: sticky TOC with scroll-spy, click-to-zoom images, copy buttons on code, a searchable glossary.

## Samples (view live)

Learning pages **really generated** by these skills, deployed as a site — **click and they open, interactive, right in your browser** (live ~1 min after first deploy). More cases + screenshots in [`samples/`](samples/).

| Case | Skill | Open live |
|------|-------|-----------|
| OpenAI Whisper (single repo) | github-project-learn | [▶ open](https://shangjunyang1986.github.io/ai-learning-skills/samples/github-project-learn/whisper-learn/) |
| QwenLM (whole org) | github-project-learn | [▶ open](https://shangjunyang1986.github.io/ai-learning-skills/samples/github-project-learn/qwenlm-learn/) |
| 3D Gaussian Splatting (interactive demo) | domain-learn | [▶ open](https://shangjunyang1986.github.io/ai-learning-skills/samples/domain-learn/3dgs-learn/) |
| Dive into Deep Learning (chapters + quizzes) | textbook-learn | [▶ open](https://shangjunyang1986.github.io/ai-learning-skills/samples/textbook-learn/d2l-learn/) |
| Attention Is All You Need (attention demo + critical reading) | paper-learn | [▶ open](https://shangjunyang1986.github.io/ai-learning-skills/samples/paper-learn/attention-learn/) |
| Learning-library hub | learn | [▶ open](https://shangjunyang1986.github.io/ai-learning-skills/samples/learn-hub/) |

## What the output looks like

A folder with no build step, no server, fully offline:

```
<thing>-learn/
├── index.html   # self-contained (inline CSS+JS), double-click to open
└── assets/      # the source's real images / diagrams / media, downloaded
```

## Install & use

Two ways, take your pick.

**Option A · let the tool install it (easiest)** — in Claude Code / Codex / etc., just tell it:

- **Whole set**: "Install **all skills** from `https://github.com/shangjunyang1986/ai-learning-skills` into my skills directory."
- **Just one**: "Install only the `paper-learn` skill from that repo."

**Option B · copy from source** — clone, then copy into your skills directory (Claude Code uses `~/.claude/skills/`; other tools may differ):

```bash
git clone https://github.com/shangjunyang1986/ai-learning-skills
cd ai-learning-skills

cp -r skills/* ~/.claude/skills/             # whole set (four skills + the /learn entry)
cp -r skills/paper-learn ~/.claude/skills/   # or: just one
```

Then just say something like *"help me learn github.com/openai/whisper"* and the skill triggers.

## Notes

- **Not just Claude Code.** Written in the **standard skill format** (`SKILL.md` + `references/` + `scripts/` + `assets/`), so any tool that supports it can use these — Claude Code, Codex, Gemini, OpenCode, etc.
- **For personal use only.**
- **Not token-optimized — it can burn tokens.** On metered plans (Claude Pro, Codex Plus, …), keep an eye on your token usage.

## Roadmap

The four source skills + the `/learn` entry are all done (see the table above and [`samples/`](samples/)). Next:

- [ ] Go deeper: export textbook quizzes to Anki / spaced repetition; multi-source blends (one topic = paper + repo + field)
- [ ] Candidate new sources: video/course-learn (lecture series → transcript notes + timestamps), docs-learn (doc sites)
- [ ] Extract the shared core (the page shell is already shared; revisit the research/pedagogy layer)

> Adding a skill? See [docs/adding-a-new-skill.md](docs/adding-a-new-skill.md). `shared/` is the single source of truth for the design system (each skill bundles its own copy so it installs standalone).

## License

MIT — see [LICENSE](LICENSE).
