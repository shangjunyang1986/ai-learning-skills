# Research & sourcing — the make-or-break of domain-learn

Unlike a single GitHub repo (one authoritative README), an **open topic** has no single
source of truth. The web is full of outdated numbers, marketing, and confident errors. A
learning page that quietly repeats a wrong "10× faster" or invents a paper is worse than
useless — it teaches falsehoods. So the bar here is higher: **source everything, verify
the load-bearing claims, and flag what you couldn't.**

## Rules

1. **Every non-obvious claim carries a source.** Numbers (FPS, accuracy, speedups, dates),
   "first to do X" claims, who-invented-what, and every external link must come from a real
   fetch. Put the source URL on the page (a "出处" link) or in the section.

2. **Prefer primary sources.** The paper's own abstract/tables > a blog's summary > a forum
   post. For the seminal work, fetch the **arXiv abstract page** and, when numbers matter,
   the **HTML/PDF** for the actual tables. For tools, fetch the **GitHub API** for stars and
   `pushed_at`, not a star count someone wrote in a blog last year.

3. **Cross-check load-bearing numbers.** If a headline number (e.g. "≥30 fps at 1080p")
   anchors the page, confirm it against the primary source verbatim. If two sources
   disagree, say so and cite the authoritative one. (Real example: a project page once
   showed "≥100 fps" while the paper abstract says "≥30 fps" — trust the paper, flag the
   discrepancy.)

4. **Flag uncertainty; never paper over it.** If you can't verify a channel name, a date, or
   whether a link resolves, say "unverified" rather than inventing a plausible value. A
   short honest "couldn't confirm X" is fine; a confident fabrication is not.

5. **Honesty about gaps is content, not failure.** "There is no good beginner video for this
   yet" or "no official implementation exists" is useful to a learner. Say it.

6. **Dates are absolute.** Convert "recently"/"last year" to actual dates, and stamp
   fetched data ("stars as of <date>").

## Media sourcing

- **Figures/diagrams:** the project page and the official GitHub repo's `assets/` are the
  best embeddable stills. GitHub images are often Git LFS — `raw.githubusercontent.com`
  returns a tiny pointer; `fetch-media.sh` auto-retries the `media.githubusercontent.com`
  endpoint. Verify each download is a real image (the script does and drops failures).
- **Status-check URLs** before relying on them; guessed image paths often 404. If you didn't
  successfully download it, don't reference it.
- **Videos:** YouTube via `WebSearch allowed_domains:["youtube.com"]`; thumbnails are
  deterministic at `img.youtube.com/vi/<ID>/hqdefault.jpg` (the script walks
  maxres→hq→mq and drops gray placeholders). Bilibili via
  `WebSearch allowed_domains:["bilibili.com"]` (direct fetch is blocked; for covers use the
  Jina reader `r.jina.ai/<bilibili-url>` to read the `og:image`, then download via the
  weserv proxy — see the family's media-gotchas notes). Confirm video **IDs/titles**; don't
  invent channel names.
- **Beware huge GIFs/videos** (tens of MB). Skip, or link instead of downloading, rather
  than bloating the page/repo.

## A good research return looks like

Structured data with, per claim, the value **and** its source URL; a clearly separated
"could not verify / flagged" section; and real GitHub-API stars+dates for any tools. If a
subagent hands back confident prose with no links, send it back for sources.
