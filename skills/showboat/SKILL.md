---
name: showboat
description: Create and maintain executable markdown demo documents using the showboat CLI. Use when the user asks for reproducible proof-of-work docs, step-by-step command demos with captured output, or verification of previously recorded demo documents.
---

# Showboat

Use `showboat` to build executable demo documents that mix explanation, commands, and captured output.

## Verify availability

1. Check if `showboat` is installed:
   ```bash
   showboat --help
   ```
2. If missing, prefer one-off usage:
   ```bash
   uvx showboat --help
   ```
3. If `uvx` is unavailable, ask the user before installing globally.

## Core workflow

1. Initialize the document:
   ```bash
   showboat init demo.md "<Title>"
   ```
2. Add narrative text:
   ```bash
   showboat note demo.md "<commentary>"
   ```
3. Execute commands and capture output:
   ```bash
   showboat exec demo.md bash "<command>"
   showboat exec demo.md python "<code>"
   ```
4. Add screenshots or other images:
   ```bash
   showboat image demo.md screenshot.png
   showboat image demo.md '![Alt text](screenshot.png)'
   ```
5. If the latest entry is wrong, remove it:
   ```bash
   showboat pop demo.md
   ```
6. Verify reproducibility before finishing:
   ```bash
   showboat verify demo.md
   ```

## Operating rules

- Keep notes concise and task-oriented.
- Run commands in the intended project directory (use `--workdir` when needed).
- Treat non-zero exit from `showboat exec` as command failure; fix and rerun, then remove bad entries with `showboat pop`.
- Run `showboat verify` after substantive edits and before handoff.
- Use `showboat extract demo.md` when you need to reconstruct or explain how a document was built.

## Handoff checklist

- Confirm the demo file path.
- Confirm `showboat verify` exit status.
- Summarize what the demo proves and any assumptions required to reproduce it.
