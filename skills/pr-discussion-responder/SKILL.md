---
name: pr-discussion-responder
description: Fetch PR discussion using GitHub CLI `gh api`, then address review/issue comments by updating code or drafting replies. Use when asked to respond to PR feedback, resolve review comments, or act on a branch's PR discussion.
---

# PR Discussion Responder

**Requires**: GitHub CLI (`gh`) authenticated, `jq`, and git.

## Goal

Use `gh api` to pull all PR discussion for a branch or PR number, then turn the feedback into concrete actions. If intent is ambiguous, present clear options and ask the user to choose.

## Quick Start

```bash
scripts/fetch_pr_discussion.sh [<pr-number>|<branch>]
```

Outputs a JSON bundle with `pr`, `issue_comments`, `review_comments`, and `reviews`.

## Workflow

### Step 1: Identify the PR

Prefer the current branch unless the user specifies a PR number or branch name.

```bash
# Current branch PR discussion
scripts/fetch_pr_discussion.sh

# Specific branch
scripts/fetch_pr_discussion.sh my-branch

# Specific PR
scripts/fetch_pr_discussion.sh 1234
```

If the branch maps to multiple PRs, stop and ask the user to pick one.

### Step 2: Extract Actionable Items

From the discussion JSON, list each requested change or question. Track:

- Reviewer/author
- Comment URL
- Requested change or concern
- Suggested resolution (code change, explanation, or clarification needed)

### Step 3: Choose Actions and Ask When Unclear

Default to implementing clear changes. If a comment is ambiguous, offer 2-3 options and ask the user to choose. Example wording:

"This comment could mean: (1) rename X to Y, (2) add guard for null, or (3) leave as-is and clarify intent. Which do you prefer?"

### Step 4: Apply Changes

- Make code changes and run relevant tests if feasible.
- **IMPORTANT**: NEVER POST REPLIES TO THE PULL REQUEST

### Step 5: Report Back

Summarize:

- Actions taken
- Any remaining questions
- Links to comments that still need a response

## Notes

- Use `gh api` for all PR data retrieval.
- If `gh api` returns empty results, confirm the PR number/branch and repo.
