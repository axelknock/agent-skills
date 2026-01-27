---
name: devenv
description: Manage and troubleshoot devenv-based developer environments. Use when creating or modifying devenv.nix/devenv.yaml, adding or removing packages, updating inputs/lockfiles, configuring scripts/tasks/processes/services, or fixing devenv evaluation/shell errors and direnv activation issues.
---

# Devenv Configuration

## Workflow

- Inspect the repo for `devenv.nix`, `devenv.yaml`, `devenv.lock`, `devenv.local.nix`, `devenv.local.yaml`, and `.envrc` before changing anything.
- Prefer minimal, targeted edits that match the existing style and structure.
- Update both configuration and lockfile only when asked (or when required by an inputs change).
- When changing inputs, run `devenv update` unless the user requests a manual pin.
- When troubleshooting, collect the exact error message and identify the failing file or option.

## Common edits

- Add or remove packages by editing `packages = [ ... ];` in `devenv.nix`.
- Adjust inputs/imports in `devenv.yaml`; keep `devenv.lock` in sync.
- Prefer `tasks` over complex `enterShell` for ordered or repeatable setup steps.
- Use `scripts.*` for helper commands and `processes.*`/`services.*` for long-running dev services.

## Troubleshooting

- Use `devenv search <name>` to confirm package names in the pinned nixpkgs.
- Use `devenv info` to inspect resolved environment details.
- For evaluation errors, locate the invalid option or Nix syntax issue and correct it in the relevant file.
- For direnv issues, confirm `.envrc` contains `use devenv` (or the official `devenv direnvrc`) and rerun `direnv allow`.

## References

- Read `references/devenv.md` for common patterns, commands, and examples when implementing changes.
