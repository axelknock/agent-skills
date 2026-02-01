# Agent Notes

## Repository layout

- Skill definitions live under `skills/<skill-name>/SKILL.md`.
- `SKILL.md` requires YAML frontmatter with only `name` and `description`.
- Use imperative voice in skill instructions and keep content concise.

## Creating a new skill

- Manually create the `skills/<skill-name>/` folder if helper scripts are not available in this repo.
- Remove any extra boilerplate files; only `SKILL.md` is required unless the skill needs scripts, references, or assets.
- Avoid adding extra documentation files (README, changelog, etc.).

## Helpful context

- This repo does not include `init_skill.py` or `package_skill.py`. If needed, run those from the global pi toolchain; otherwise create skills by hand following the structure above.
