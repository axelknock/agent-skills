# Phoenix Web App

Use this pattern when configuring devenv for an Elixir/Phoenix application.

## devenv.nix

```nix
{
  pkgs,
  ...
}:
let
  app = baseNameOf ./.;
in
{
  languages.elixir.enable = true;
  languages.elixir.package = pkgs.beam28Packages.elixir_1_19;

  processes.phoenix.exec = "mix phx.server";

  services.postgres = {
    enable = true;

    listen_addresses = "localhost";
    port = 5432;

    initialDatabases = [
      { name = "${app}_dev"; }
      { name = "${app}_test"; }
    ];

    initialScript = ''
      CREATE ROLE postgres SUPERUSER LOGIN PASSWORD 'postgres';
    '';
  };
}
```

## Notes

- Derive `app` from `baseNameOf ./.` so database names follow the project directory.
- Start Phoenix with `devenv up`; it runs the `phoenix` process.
- Keep Postgres credentials aligned with Phoenix config files (usually `config/dev.exs` and `config/test.exs`).
