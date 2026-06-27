# Routing — pick the right family skill

The job: read the user's "I want to learn X" and hand off to the sibling whose **source type**
matches. Route, then let that skill do the faithful research + build.

## Decision table (first clear match wins)

| The input is… | Route to | Tells |
|---|---|---|
| a **github.com** repo or org URL | `github-project-learn` | `github.com/<owner>` or `/<owner>/<repo>` |
| an **arxiv.org / ar5iv** link, or a **named paper** + "精读/读这篇/explain this paper", or a PDF that is **one paper** | `paper-learn` | arXiv id `NNNN.NNNNN`; a paper title; a short PDF with abstract + references (~8–20 pp) |
| a **technical book** by name, or a PDF/EPUB that is a **textbook** | `textbook-learn` | a book title; a long PDF/EPUB with chapters + a TOC |
| a **bare topic / field**, no URL, not a specific book or paper | `domain-learn` | "学习 3DGS", "研究下扩散模型", "get into RL" |

## Disambiguation — when to ask one quick question

Don't guess when these collide; ask one `AskUserQuestion`, then route:

- **A PDF that could be a book or a paper.** Heuristic: many chapters / hundreds of pages →
  textbook; abstract + sections + references, ~8–20 pages → paper. If still unclear, ask.
- **A GitHub URL that's a paper's official code** (e.g. the repo for a method). Ask: learn the
  *codebase* (`github-project-learn`) or the *paper/method* (`paper-learn`)? Often the paper
  page is what they want, with the repo linked from it.
- **A topic that is really one famous paper or one book** ("学习 Transformer" could be the
  *field* of transformers → `domain-learn`, or the *paper* "Attention Is All You Need" →
  `paper-learn`). Ask which.
- **A topic vs a specific repo** ("学习 LangChain" — the *framework/repo* via
  `github-project-learn`, or the *area* of agent frameworks via `domain-learn`?). Ask if it
  matters.
- **An org with one obvious flagship** → `github-project-learn` already handles org-vs-repo
  internally; just route there.

## How to hand off

Invoke the chosen skill via the Skill tool, passing the user's source verbatim (the URL / file
/ title / topic). That skill owns scope confirmation, research, page generation, and
verification — **don't re-do its work here.** When it's done, offer Mode B (add the new page to
the library hub).

## Edge cases

- **Multiple sources at once** ("learn this repo and this paper"): route the primary one now,
  and offer to do the other next; or, if the user wants them blended, note that a multi-source
  "learn a topic from repo + paper + field" mode is a planned future capability — for now do
  them as separate pages and link them from the hub.
- **Not a learning request** (a quick factual question, "build me an app"): don't route into
  the family; answer directly or use the appropriate non-family skill.
- **Unsupported source** (a video course, a dataset, an API spec): say so honestly. Video/
  course and docs-site learning are candidate future siblings, not yet built — don't pretend a
  current skill covers them.
