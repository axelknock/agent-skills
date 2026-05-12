---
name: devenv
description: Manage and troubleshoot devenv-based developer environments. Use when creating or modifying devenv.nix/devenv.yaml, adding or removing packages, updating inputs/lockfiles, configuring scripts/tasks/processes/services, applying project-specific setup patterns, or fixing devenv evaluation/shell errors and direnv activation issues.
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
- Devenv retains state for services in .devenv/state/<service name>. Sometimes changes to `devenv.nix` are not propagated until this state is cleared (service directory removed) and re-initialized.
- Sometimes devenv's cache will overwrite new values, in which case commands should be evaluated with --no-eval-cache

## Project setup references

Read these references when setting up devenv for a matching project type:

- **Phoenix web app**: `references/phoenix.md` for Elixir/Phoenix with Postgres and `mix phx.server`.

## Devenv Reference

### File map

- `devenv.nix`: main Nix module for environment definition.
- `devenv.yaml`: inputs/imports configuration for modules and nixpkgs.
- `devenv.lock`: pinned inputs for reproducibility.
- `devenv.local.nix` / `devenv.local.yaml`: local overrides (not committed).
- `.envrc`: direnv integration (`use devenv`).

### Core commands

- `devenv init`: create starter files.
> *CRITICAL*: `devenv init` SHOULD BE EXCLUSIVELY USED TO PRODUCE `devenv.nix` and `devenv.yaml`. If neither of these files exist, do not create them yourself. Ask the user to run init to create them.
- `devenv shell`: enter the environment.
- `devenv up`: start defined processes/services.
- `devenv test`: run `enterTest` or `.test.sh`.
- `devenv search <name>`: search pinned nixpkgs packages.
- `devenv update`: update inputs and `devenv.lock`.
- `devenv info`: show environment summary.

### Editing devenv.nix

#### Add or remove packages

```
{ pkgs, ... }:
{
  packages = [
    pkgs.git
    pkgs.jq
  ];
}
```

#### Scripts

```
{ pkgs, ... }:
{
  scripts.format.exec = "nix fmt";
}
```

#### Tasks

```
{ pkgs, ... }:
{
  tasks."app:build" = {
    exec = "npm run build";
    cwd = "./frontend";
    execIfModified = [ "src/**/*.ts" "package.json" ];
  };
}
```

#### Processes

```
{ ... }:
{
  processes.web.exec = "npm run dev";
}
```

#### Services (example)

```
{ pkgs, ... }:
{
  services.postgres.enable = true;
  services.postgres.package = pkgs.postgresql_15;
}
```

#### Prefer tasks for shell setup

Use `tasks.*` with `before = [ "devenv:enterShell" ]` for ordered setup instead of large `enterShell` blocks.

### Editing devenv.yaml

#### Inputs and imports

```
inputs:
  nixpkgs:
    url: github:cachix/devenv-nixpkgs/rolling
imports:
  - ./frontend
  - ./backend
```

- After changing inputs, run `devenv update` to refresh `devenv.lock`.
- Use `follows` to align nested inputs (e.g., git-hooks nixpkgs follows your nixpkgs).

### Common modules

- `packages`: add CLI tools and libraries.
- `env.*`: add environment variables.
- `scripts.*`: helper commands; can include `packages` or `package`.
- `tasks.*`: dependency-aware tasks with caching and `execIfModified`.
- `processes.*`: long-running dev processes for `devenv up`.
- `services.*`: preconfigured databases/services (e.g., postgres, redis).
- `profiles.*`: alternate configurations activated via `--profile`.

### Troubleshooting

#### Evaluation errors

- Confirm Nix syntax (braces, semicolons, list commas).
- Verify option names against the reference (`devenv.sh/reference/options`).
- If a module option is missing, ensure the module is enabled or imported.

#### Package not found

- Run `devenv search <name>` and update to the exact package path in `pkgs`.
- If missing, add a new nixpkgs input or use a different channel.

#### Inputs out of date

- Run `devenv update` to refresh `devenv.lock`.

#### Automatic activation

*IMPORTANT*: Since version 2.1, Devenv no longer relies on external tools such as direnv to manage its activation.

##### How it works

The hook users add to their shell configuration runs on every directory change and:

- Walks up from the current directory looking for a devenv.yaml file.
- Checks the trust database to verify the project was allowed.
- If trusted, runs devenv shell in a subshell for that project.
- If a project has not been trusted yet, you will see a message asking you to run devenv allow:

```sh
devenv: /home/user/myproject is not allowed. Run 'devenv allow' to trust this directory
```
