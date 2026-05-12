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
  # It is important to use a specific version of elixir/BEAM for
  # reproducability. New versions of BEAM/OTP are released on a yearly basis,
  # and elixir releases come with a frequency of about 6-12 months.
  
  # Elixir 1.19 was released October 16, 2025
  # Erlang/OTP 28.0 was released on May 21, 2025
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
