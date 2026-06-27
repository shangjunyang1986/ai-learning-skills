# Media-fetching gotchas (learned the hard way)

Downloading the official media is what makes these pages worth more than the README,
but several hosts fight back. `scripts/fetch-media.sh` automates most of this; here's
the why, so you can adapt when it breaks.

## 1. GitHub images are frequently Git LFS

Many repos store README images in **Git LFS**. Hitting
`https://raw.githubusercontent.com/<owner>/<repo>/<branch>/<path>` then returns a tiny
(~130 byte) **pointer file**, not the image:

```
version https://git-lfs.github.com/spec/v1
oid sha256:...
size 350197
```

Fix: refetch from the LFS media endpoint — same path, different host:
`https://media.githubusercontent.com/media/<owner>/<repo>/<branch>/<path>`

Detection: downloaded file < 300 bytes and contains `git-lfs.github.com`.
`fetch-media.sh` does this automatically.

## 2. Branch is usually `main`, sometimes `master`

If a raw/media URL 404s, retry with the other branch before giving up.

## 3. Bilibili: direct TLS is blocked in this environment

`api.bilibili.com`, `www.bilibili.com`, and `i*.hdslb.com` fail TLS here
(curl schannel `SEC_E_INVALID_TOKEN`, .NET "connection closed", WebFetch
`WRONG_VERSION_NUMBER`). Two working detours:

- **Metadata (title / up / cover URL)**: read the page through the Jina reader proxy:
  `WebFetch https://r.jina.ai/https://www.bilibili.com/video/<BVID>/` and ask for the
  title, uploader, and the `og:image` (an `i*.hdslb.com` `.jpg`). The same trick works
  on the search page `https://r.jina.ai/https://search.bilibili.com/all?keyword=<kw>`
  to enumerate BV ids + covers.
- **Cover download**: route the hdslb URL through the weserv image proxy:
  `https://images.weserv.nl/?url=<hdslb-path-without-scheme>&w=640&output=jpg`
  (drop any `@...` resize suffix). `fetch-media.sh` does this for `hdslb`/`bilibili` URLs.

To find Bilibili videos, plain `WebSearch` with `allowed_domains:["bilibili.com"]`
surfaces real `BV...` links even though you can't fetch the site directly.

## 4. YouTube results pages don't scrape well

`WebFetch` on `youtube.com/results?...` returns truncated/JS-only content or 403,
and `r.jina.ai` on it often 403s too. Use `WebSearch` with
`allowed_domains:["youtube.com"]` instead. For niche research projects this frequently
returns **nothing** — that's a real finding; report "no dedicated video" rather than
substituting unrelated clips. YouTube thumbnails, when you do have a video id, are
deterministic: `https://img.youtube.com/vi/<ID>/hqdefault.jpg` (directly downloadable).

## 5. Always verify a download is a real image

A successful HTTP 200 can still be an error page or LFS stub. After downloading, check
size > ~1KB and that the first bytes are a real magic number (`\x89PNG`, `\xFF\xD8\xFF`
for JPEG). `fetch-media.sh` prints size + header per file so you can eyeball it.

## 6. Use the Bash tool's curl, not Windows cmd curl

In this Windows env, the Bash tool's git-bash curl reaches github / githubusercontent /
weserv / api.github.com fine. Windows `curl.exe` (schannel) and PowerShell `.NET` fail
on several of these hosts. Prefer the Bash tool for downloads.
