---
name: github-readme
description: Fetch and inspect a GitHub repository README via the GitHub API using gh CLI. Supports targeting a specific subdirectory or filename, while defaulting to README.md/org/txt discovery.
---

# GitHub README Fetching

## Use the script (preferred)

Run the bundled script to find and print the README (or another file) contents:

```bash
skills/github-readme/scripts/fetch_readme.sh [--subdir <path>] [--file <filename>] <owner/repo> [ref]
```

- `ref` is optional (branch, tag, or SHA). Defaults to `HEAD`.
- Default search: find `README.(md|org|txt)` in the repo root, then fall back to a recursive search.
- `--subdir <path>` limits the search to a subdirectory (search that folder first, then recursively within it).
- `--file` / `--filename` fetches an exact filename (case-insensitive). Can be combined with `--subdir`.
- Output is the raw file content on stdout.

## Manual workflow (if script is not usable)

1. List root (or a subdirectory) contents:
   ```bash
   gh api repos/<owner>/<repo>/contents[/<subdir>] -f ref=<ref>
   ```
2. Pick the target file:
   - Default behavior: choose a file whose name matches `README.(md|org|txt)` case-insensitively.
   - If specifying a filename, select that file (optionally under the desired subdirectory).
3. If none in the initial directory, search recursively:
   ```bash
   gh api repos/<owner>/<repo>/git/trees/<ref> -f recursive=1
   ```
   Filter for paths whose basename matches the desired filename (or `README.(md|org|txt)`), and optionally that start with `<subdir>/`.
4. Fetch raw file content:
   ```bash
   gh api repos/<owner>/<repo>/contents/<path> \
     -H "Accept: application/vnd.github.raw" \
     -f ref=<ref>
   ```

## Notes

- Ensure `gh auth status` is logged in and has repo read access.
- Prefer the shortest path match when multiple candidates exist.
