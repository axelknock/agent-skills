---
name: tea
description: Use Gitea's `tea` CLI to manage Gitea repositories, issues, pull requests, comments, releases, labels, organizations, notifications, webhooks, actions, and authenticated API requests. Use when tasks involve Gitea command-line workflows, repository-scoped Gitea operations, PR checkout/review/merge, issue triage, or configuring `tea` logins.
---

# tea Gitea CLI

Use `tea` for Gitea operations from the shell. Prefer repository-scoped commands from a checked-out repo, and use explicit `--repo`, `--remote`, or `--login` when context is ambiguous.

## Workflow

1. Verify the tool and inspect command-specific flags before using unfamiliar operations:
   ```bash
   tea --help
   tea <command> --help
   ```
2. Check authentication and configured logins:
   ```bash
   tea whoami
   tea login list
   tea login default
   ```
3. Confirm repository context before mutating state:
   ```bash
   git remote -v
   tea repo
   ```
4. Prefer machine-readable output for scripts and summaries:
   ```bash
   tea issue list --output json
   tea pr list --output json
   ```
5. After create, edit, close, merge, or delete operations, re-fetch the affected item to verify the result.

## Repository and login selection

- Use local git context when the current directory clearly maps to the target Gitea repository.
- Use `--repo owner/name` to target a repository explicitly.
- Use `--remote <name>` to discover the login/repo from a specific git remote.
- Use `--login <name>` when multiple Gitea servers or accounts are configured.
- Use `--debug` only for troubleshooting; redact tokens and server URLs if sharing output.

## Core patterns

- List or inspect repositories:
  ```bash
  tea repo list --output json
  tea repo owner/name --output json
  tea repo search <term> --output json
  ```
- Work with issues:
  ```bash
  tea issue list --state open --output json
  tea issue <index> --comments --output json
  tea issue create --title "Title" --description "Body"
  tea issue close <index>
  tea issue reopen <index>
  tea comment <index> "Comment body"
  ```
- Work with pull requests:
  ```bash
  tea pr list --state open --output json
  tea pr <index> --comments --output json
  tea pr checkout --branch <index>
  tea pr create --head <branch> --base <base> --title "Title" --description "Body"
  tea pr approve <index>
  tea pr reject <index>
  tea pr merge <index>
  ```
- Filter and format listings:
  ```bash
  tea issue list --labels bug,urgent --state open --limit 50 --output json
  tea pr list --fields index,title,state,author,url,updated --output table
  ```
- Use the API when the CLI lacks a high-level command:
  ```bash
  tea api repos/{owner}/{repo}/issues/{index}
  tea api --help
  ```

## Pull request workflow

- Ensure local changes are committed and pushed before `tea pr create`; `tea` assumes local git state is already published.
- Use `tea pr checkout --branch <index>` to create or update a local branch for review work.
- Fetch PR details with comments before responding to review feedback:
  ```bash
  tea pr <index> --comments --output json
  ```
- Prefer explicit `--head`, `--base`, `--title`, and `--description` for PR creation to avoid prompts and wrong targets.
- Confirm merge requirements and branch cleanup policy before running `tea pr merge` or `tea pr clean`.

## Safety

- Treat `repo delete`, `org delete`, branch deletion, webhook changes, release deletion, and PR merge as destructive; ask for confirmation unless the user explicitly requested the exact action.
- Prefer non-interactive flags (`--title`, `--description`, `--labels`, `--assignees`, `--repo`, `--login`) in automated sessions.
- Do not print or store access tokens. Use `tea login add` interactively or rely on existing configuration under `$XDG_CONFIG_HOME/tea`.
- Use `--output json` and parse structured data rather than scraping tables when making decisions.
