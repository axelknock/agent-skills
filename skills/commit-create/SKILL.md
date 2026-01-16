---
name: commit-create
description: Create git commits and commit messages using conventional commits. Use when preparing commits, splitting changes into multiple logical commits, or writing commit messages; include per-commit revert commands.
---

# Commit Creation

## Workflow

- Inspect working tree and diffs before proposing commits.
- Group changes into logically coherent commits; prefer smaller commits with clear scope over one large commit.
- Propose a commit plan when multiple commits are needed, then implement in order.
- Use conventional commits (`type(scope): summary`) with present-tense, imperative summaries.
- Include a revert section that lists concrete commands to undo each commit.

## Grouping Rules

- Separate independent features, fixes, refactors, and docs into distinct commits.
- Avoid mixing formatting/lint-only changes with behavioral changes.
- Keep tests aligned with the change they validate; test additions belong with the feature/fix commit.
- If changes are tightly coupled, keep them in one commit and explain why.

## Commit Message Guidance

- Use conventional commit types: `feat`, `fix`, `refactor`, `docs`, `test`, `chore`, `build`, `ci`, `perf`.
- Add a scope when it clarifies intent (module, package, area).
- Keep the summary short and specific; avoid vague words like "update" unless scoped.
- If the commit is centered on one or more specific issues, include that/those issue #(s) in the summary, ie `(#123)`, `(#123) (#456)`
- Add body content only when it adds context (tradeoffs, breaking changes, migration notes).
- If relevant PRs or issues are referenced in the conversation, include proper GitHub syntax (e.g., `#123`, `owner/repo#123`) in the body or footer.
- Always include a co-author footer for agent commits: `Co-authored with: <agent name> <email@example.com>`.

## Revert Commands (Always Include)

For every commit created, include a short list of commands to undo it, tailored to the situation:

- Safe, history-preserving: `git revert <sha>`
- If commit not pushed and user wants to rework: `git reset --soft <sha>^`
- If commit not pushed and user wants to discard: `git reset --hard <sha>^` (only if explicitly safe/approved)

## Output Template

Provide results in this order:

1. Commit plan (if multiple commits).
2. Each commit message and what changes it includes.
3. Revert commands per commit.
