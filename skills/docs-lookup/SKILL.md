---
name: docs-lookup
description: Ground answers in project documentation by checking README References sections first, then falling back to other discovery tools. Use when asked to consult docs, verify behavior against official sources, or find project documentation.
---

# Docs Lookup (README References-First)

Follow this workflow whenever documentation is needed.

## Workflow

1. Find README files in the relevant project scope.
2. Check each README for a `References` heading first (accept common variants like `## References`, `# References`, or `### References`).
3. If the heading exists, collect relevant links under that section and prioritize those sources.
4. Open the most relevant reference links and extract the needed facts.
5. If no suitable README references are found, use available tools (repo search, web search, official docs pages, API docs, etc.) to locate authoritative documentation.
6. After using a fallback source, tell the user which source was used and suggest adding it to the README `References` section.

## Source quality rules

- Prefer official vendor/project documentation over third-party summaries.
- Prefer version-specific docs when the user’s version is known.
- If multiple sources conflict, call out the conflict and prefer the most authoritative and up-to-date source.

## Output requirements

- Cite the documentation source(s) used.
- State whether the source came from README `References` or fallback discovery.
- If fallback was required, include a brief suggestion to add the discovered source to README `References`.
