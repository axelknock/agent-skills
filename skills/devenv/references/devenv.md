# Devenv Reference

## Table of Contents

- [File map](#file-map)
- [Core commands](#core-commands)
- [Editing devenv.nix](#editing-devenvnix)
- [Editing devenv.yaml](#editing-devenvyaml)
- [Common modules](#common-modules)
- [Troubleshooting](#troubleshooting)

## File map

- `devenv.nix`: main Nix module for environment definition.
- `devenv.yaml`: inputs/imports configuration for modules and nixpkgs.
- `devenv.lock`: pinned inputs for reproducibility.
- `devenv.local.nix` / `devenv.local.yaml`: local overrides (not committed).
- `.envrc`: direnv integration (`use devenv`).

## Core commands

- `devenv init`: create starter files.
- `devenv shell`: enter the environment.
- `devenv up`: start defined processes/services.
- `devenv test`: run `enterTest` or `.test.sh`.
- `devenv search <name>`: search pinned nixpkgs packages.
- `devenv update`: update inputs and `devenv.lock`.
- `devenv info`: show environment summary.

## Editing devenv.nix

### Add or remove packages

```
{ pkgs, ... }:
{
  packages = [
    pkgs.git
    pkgs.jq
  ];
}
```

### Scripts

```
{ pkgs, ... }:
{
  scripts.format.exec = "nix fmt";
}
```

### Tasks

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

### Processes

```
{ ... }:
{
  processes.web.exec = "npm run dev";
}
```

### Services (example)

```
{ pkgs, ... }:
{
  services.postgres.enable = true;
  services.postgres.package = pkgs.postgresql_15;
}
```

### Prefer tasks for shell setup

Use `tasks.*` with `before = [ "devenv:enterShell" ]` for ordered setup instead of large `enterShell` blocks.

## Editing devenv.yaml

### Inputs and imports

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

## Common modules

- `packages`: add CLI tools and libraries.
- `env.*`: add environment variables.
- `scripts.*`: helper commands; can include `packages` or `package`.
- `tasks.*`: dependency-aware tasks with caching and `execIfModified`.
- `processes.*`: long-running dev processes for `devenv up`.
- `services.*`: preconfigured databases/services (e.g., postgres, redis).
- `profiles.*`: alternate configurations activated via `--profile`.

## Troubleshooting

### Evaluation errors

- Confirm Nix syntax (braces, semicolons, list commas).
- Verify option names against the reference (`devenv.sh/reference/options`).
- If a module option is missing, ensure the module is enabled or imported.

### Package not found

- Run `devenv search <name>` and update to the exact package path in `pkgs`.
- If missing, add a new nixpkgs input or use a different channel.

### Inputs out of date

- Run `devenv update` to refresh `devenv.lock`.

### direnv not activating

- Confirm `.envrc` has `use devenv` (or `eval "$(devenv direnvrc)"`).
- Run `direnv allow` after editing `.envrc`.
