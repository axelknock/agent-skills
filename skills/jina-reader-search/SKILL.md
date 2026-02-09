---
name: jina-reader-search
description: Use Jina Reader/Search APIs to fetch webpage content as markdown and run web searches. Use when the task needs clean markdown from URLs (primary via https://r.jina.ai/) or search results (via https://s.jina.ai/).
---

# Jina Reader + Search

Use Jina HTTP endpoints directly. Prefer `GET` and plain-text responses.

## Authentication

- Use `Authorization: Bearer <token>` when `JINA_API_KEY` is available.
- Expect `https://s.jina.ai/` search requests to fail with `401` without a token.
- If search fails for auth, ask the user for a Jina token and continue with reader-only tasks meanwhile.

## Read webpages as markdown (primary workflow)

1. Build the reader URL by appending the full target URL:
   - `https://r.jina.ai/http://example.com`
2. Request markdown/plain text:
   ```bash
   curl -sS \
     -H "Accept: text/plain" \
     -H "X-Respond-With: markdown" \
     "https://r.jina.ai/http://example.com"
   ```
3. Add optional headers when needed:
   - `X-No-Cache: true` (or `X-Cache-Tolerance: 0`)
   - `X-Timeout: <seconds>` (max 180)
   - `X-Engine: browser|direct|cf-browser-rendering`
   - `X-Retain-Images: none|all|alt|all_p|alt_p`
   - `X-Retain-Links: none|all|text|gpt-oss`

## Search workflow (secondary)

1. URL-encode the query and call `/{q}` on `s.jina.ai`:
   ```bash
   curl -sS \
     -H "Authorization: Bearer $JINA_API_KEY" \
     -H "Accept: text/plain" \
     "https://s.jina.ai/latest%20python%20release"
   ```
2. Use query params for control:
   - `provider=google|bing|reader`
   - `type=web|images|news` (default `web`)
   - `count` or `num` in `0..20`
   - `page`, `gl`, `hl`, `location`
   - `site`, `ext`, `filetype`, `intitle`, `loc`
3. Use `/search` for query-string style calls:
   - `https://s.jina.ai/search?q=...&count=5&type=web`

## Response handling

- Prefer `Accept: text/plain` for direct markdown/text output.
- Use `Accept: application/json` when envelope metadata is needed (`code`, `status`, `data`, `meta`).
- Surface API error payloads directly (especially auth and rate-limit errors).

## Common pattern

1. Search with `s.jina.ai` to gather candidate URLs.
2. Fetch each URL via `r.jina.ai` to get clean markdown.
3. Synthesize results from markdown, not raw HTML.
