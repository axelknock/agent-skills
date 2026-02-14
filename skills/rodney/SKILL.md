---
name: rodney
description: Automate websites with Rodney, a CLI for persistent headless Chrome control (navigation, element interaction, JS evaluation, screenshots, tab management, and accessibility queries). Use when tasks require scriptable browser automation from terminal commands.
---

# Rodney Browser Automation

Use Rodney commands directly from the shell and keep sessions deterministic.

## Workflow

1. Verify Rodney availability:
   ```bash
   rodney --help
   ```
2. Ensure a browser session is running:
   ```bash
   rodney status || rodney start
   ```
3. Navigate and wait before extracting or interacting:
   ```bash
   rodney open https://example.com
   rodney waitstable
   ```
4. Perform actions with explicit selectors, then validate results.
5. Stop Rodney when automation is complete unless the user wants to keep the session alive:
   ```bash
   rodney stop
   ```

## Core command patterns

- Extract data:
  - `rodney title`
  - `rodney text "h1"`
  - `rodney html "main"`
  - `rodney attr "a.primary" href`
- Run JavaScript expressions:
  - `rodney js 'document.querySelectorAll("a").length'`
- Interact with elements:
  - `rodney click "button[type=submit]"`
  - `rodney input "#email" "user@example.com"`
  - `rodney select "#country" "US"`
- Synchronize:
  - `rodney wait ".loaded"`
  - `rodney waitload`
  - `rodney waitstable`
  - `rodney waitidle`
- Capture artifacts:
  - `rodney screenshot page.png`
  - `rodney screenshot-el ".chart" chart.png`
  - `rodney pdf page.pdf`
- Work with tabs:
  - `rodney pages`
  - `rodney newpage https://example.com`
  - `rodney page 1`
  - `rodney closepage 1`

## Automation practices

- Prefer `waitstable` or selector-based `wait` before reading content or clicking.
- Use specific selectors (`#id`, stable data attributes) instead of broad CSS when possible.
- Use exit-code checks for branching in scripts:
  ```bash
  if rodney exists ".error"; then
    rodney text ".error"
  fi
  ```
- Keep scripts idempotent: open target URL, wait, then act.
- For accessibility checks, use `ax-find`, `ax-tree`, and `ax-node` with `--json` for machine-readable output.

## Troubleshooting

- If Rodney cannot start Chrome, set `ROD_CHROME_BIN` to the Chrome/Chromium binary path.
- If commands time out often, raise `ROD_TIMEOUT` (seconds).
- If session state is stale, run `rodney stop` and then `rodney start`.
- If using an authenticated proxy, set `HTTPS_PROXY`/`HTTP_PROXY` before `rodney start`.
