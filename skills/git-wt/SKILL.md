---
name: git-wt
description: Use the `git wt` CLI to list, create, switch, and delete git worktrees with simpler commands than `git worktree`. Use when the task involves branch-specific worktrees, switching into an existing worktree, cleaning up worktrees, or configuring `git-wt` behavior.
---

# git-wt

Use `git wt` when the user wants worktree workflows through the `git-wt` CLI rather than raw `git worktree` commands.

## Workflow

1. Verify the tool is available and inspect supported flags if needed:
   ```bash
   git wt --help
   ```
2. List current worktrees before changing anything:
   ```bash
   git wt
   git wt --json
   ```
3. Resolve whether the target is a branch name, a worktree name under `wt.basedir`, or an explicit path.
4. For agent automation, prefer `--nocd` so the command prints the worktree path without relying on shell wrappers:
   ```bash
   git wt --nocd <target>
   ```
5. Run follow-up commands with that printed path as the working directory.

## Core patterns

- List worktrees:
  ```bash
  git wt
  git wt --json
  ```
- Create or switch to a worktree for a branch:
  ```bash
  git wt --nocd feature-branch
  ```
- Target a worktree directory name relative to `wt.basedir`:
  ```bash
  git wt --nocd some-worktree-dir
  ```
- Target an explicit existing path:
  ```bash
  git wt --nocd ../sibling-worktree
  git wt --nocd /absolute/path/to/worktree
  ```
- Safe delete a worktree and branch:
  ```bash
  git wt -d <target>
  ```
- Force delete when the user explicitly wants it:
  ```bash
  git wt -D <target>
  ```

## Target rules

- Treat `<branch>` as a git branch name when the request is branch-oriented.
- Treat `<worktree>` as a directory name under `wt.basedir` when the user refers to a named worktree folder.
- Treat `<path>` as an existing filesystem path when the user gives `.` or a relative or absolute path.
- Use the same target forms for deletion.

## Configuration

- Inspect repo-level config before changing behavior:
  ```bash
  git config --get-regexp '^wt\.'
  ```
- Set `wt.basedir` when the user wants worktrees stored outside the default `.wt` directory.
- Prefer a basedir outside the repo root, or under `.git/`, when tools should ignore worktrees during scans.
- Use `wt.copyignored`, `wt.copyuntracked`, `wt.copymodified`, `wt.copy`, and `wt.nocopy` only when the user wants local files copied into new worktrees.
- Use `wt.hook` for setup commands that should run only on worktree creation.
- Use `wt.deletehook` for cleanup commands that should run before deletion.
- Use `wt.nocd` or `--nocd` for automation that should not depend on shell integration.
- Use `wt.relative` when commands should land in the matching subdirectory inside the target worktree.

## Shell integration

- Use `git wt --init zsh`, `bash`, `fish`, or `powershell` only when the user wants interactive shell integration.
- Note that shell integration wraps the `git` command to enable automatic directory switching and may conflict with other wrappers.
- For agent-driven terminal work, prefer `--nocd` over shell integration.

## Safety

- Default to `-d` instead of `-D`.
- Do not delete the default branch unless the user explicitly requests `--allow-delete-default`.
- Re-list worktrees after create or delete operations to confirm the result.
- Prefer `--json` output when another command or script needs structured worktree data.
