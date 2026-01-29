---
name: github-read-file
description: Instructs the agent to use the gh CLI to browse and fetch arbitrary files from a GitHub repo using the GitHub API.
---

# GitHub File Fetching

Use the GitHub CLI (`gh`) to browse repository contents and fetch raw file data. Choose which files to read based on the task.

## Workflow

1. List a directory to discover candidate files:
   ```bash
   gh api repos/<owner>/<repo>/contents[/<subdir>] -f ref=<ref>
   ```
   - `ref` is optional (branch, tag, or SHA). Defaults to `HEAD`.
2. If you need to find a file by name or search deeper, list the full tree:
   ```bash
   gh api repos/<owner>/<repo>/git/trees/<ref> -f recursive=1
   ```
   Filter for paths that match your target filename, extension, or directory prefix.
3. Fetch raw file content once you know the path:
   ```bash
   gh api repos/<owner>/<repo>/contents/<path> \
     -H "Accept: application/vnd.github.raw" \
     -f ref=<ref>
   ```

## Notes

- Ensure `gh auth status` is logged in and has repo read access.
- Prefer the shortest relevant path when multiple candidates exist.
- Leave file selection to the agent based on the task context.
