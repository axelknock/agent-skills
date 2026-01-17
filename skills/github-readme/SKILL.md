---
name: github-readme
description: Fetch and inspect a GitHub repository README via the GitHub API using gh CLI, regardless of filename or extension (README.md, README.org, README.txt, etc.). Use when an agent must read a repo's README from GitHub by API rather than cloning.
---

# GitHub README Fetching

## Use the script (preferred)

Run the bundled script to find and print the README contents:

```bash
skills/github-readme/scripts/fetch_readme.sh <owner/repo> [ref]
```

- `ref` is optional (branch, tag, or SHA). Defaults to `HEAD`.
- The script searches root first, then falls back to a recursive tree search.
- Output is the raw README content on stdout.

## Manual workflow (if script is not usable)

1. List root contents:
   ```bash
   gh api repos/<owner>/<repo>/contents -f ref=<ref>
   ```
2. Pick a file whose name matches `README.*` case-insensitively.
3. If none in root, search recursively:
   ```bash
   gh api repos/<owner>/<repo>/git/trees/<ref> -f recursive=1
   ```
   Select a path whose basename matches `README.*`.
4. Fetch raw README content:
   ```bash
   gh api repos/<owner>/<repo>/contents/<path> \
     -H "Accept: application/vnd.github.raw" \
     -f ref=<ref>
   ```

## Notes

- Ensure `gh auth status` is logged in and has repo read access.
- Prefer the shortest path match when multiple README files exist.
