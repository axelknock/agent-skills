---
name: planning
description: Use when work needs discovery, design, or a multi-step implementation plan. Skip for straightforward mechanical edits with clear requirements and low design risk.
---

# Planning

Use this skill to turn a request into an approved design and an implementation plan.

Do not use this skill for straightforward mechanical work such as small localized fixes, simple renames, obvious copy edits, or narrowly scoped changes with clear requirements and no meaningful design choices.

## Hard Gate

Do not implement, scaffold, or modify code until you have done the right amount of discovery for the task, presented the approach, and received user approval when the work changes behavior, introduces new structure, or carries meaningful product or technical ambiguity.

For very small tasks, the design can be brief. Do not force a long spec when a short written approach is enough. Scale the process to the task.

## Process

Complete these stages in order, but keep them proportionate to the size and risk of the work.

1. **Assess whether planning is needed**
   - Check whether the task is mechanical or requires discovery/design.
   - Skip this skill only when the change is obvious, localized, and low risk.
   - If the request spans multiple independent subsystems, stop and propose decomposition before going deeper.

2. **Explore project context**
   - Inspect relevant files, docs, and recent history.
   - Follow existing patterns.
   - Note any constraints, conventions, or adjacent code that affect the work.

3. **Clarify the request**
   - Ask questions only where uncertainty affects scope, behavior, or implementation choices.
   - Prefer multiple-choice questions when possible.
   - Identify purpose, constraints, success criteria, and non-goals.

4. **Propose approaches**
   - Present 2-3 valid approaches with trade-offs when there is a real design choice.
   - Present them as viable options before recommending one.
   - If the task is too small to justify multiple options, state the single obvious approach and why it is sufficient.

5. **Present the design**
   - Describe the intended architecture, components, data flow, error handling, and testing approach at the level the task warrants.
   - Keep the design concise for simple tasks and more structured for complex work.
   - Get user approval before moving to implementation planning when the work is behavior-changing, architectural, or ambiguous.

6. **Write the design artifact when warranted**
   - For substantial work, save the approved design to `docs/agents/specs/YYYY-MM-DD-<topic>.md`.
   - For small but non-mechanical work, an approved in-chat design summary is sufficient unless the user asks for a spec.

7. **Write the implementation plan**
   - Save plans to `docs/agents/plans/YYYY-MM-DD-<feature-name>.md` unless the repository specifies another location.
   - Produce a step-by-step plan that an engineer with little project context can execute reliably.

8. **Self-review the output**
   - Remove placeholders and vague instructions.
   - Check for contradictions, missing scope, and ambiguous requirements.
   - Verify the plan fully covers the approved design.

## Scope and Decomposition

If the request covers multiple independent subsystems, do not write one giant plan. Propose decomposition into smaller specs/plans. Each plan should produce something atomic, testable, and reviewable.

When decomposing work, consider whether parts of it can be tackled concurrently.

- Identify prerequisites and blocking tasks first.
- Separate truly independent work into parallelizable tracks when that will shorten execution or reduce idle time.
- Call out dependencies clearly so parallel work does not create avoidable conflicts.
- Do not force parallelism when sequential execution is simpler, safer, or easier to review.

## Design Guidance

- Prefer simple designs.
- Apply YAGNI ruthlessly.
- Break work into focused units with clear boundaries and interfaces.
- Stay consistent with the existing codebase unless a targeted structural improvement directly supports the task.
- Avoid unrelated refactors.

## Plan-Writing Guidance

Assume the implementing engineer is capable but has little context about this codebase, toolchain, or domain.

Before defining tasks, map out which files will be created or modified and what each file is responsible for.

### Plan header

Every plan must start with:

```markdown
# Implementation Plan for [Feature Name]

**Goal:** [One sentence describing what this builds]

**Architecture:** [2-3 sentences about approach]

**Tech Stack:** [Key technologies/libraries]

**Documentation:** [Where the documentation of this feature will live]
---
```

### Task granularity

Keep tasks bite-sized and ordered. Favor steps that take roughly 2-5 minutes each.

Where useful, group tasks into sequential and parallelizable tracks. Note parallelism only when tasks are genuinely independent and the dependency chain is clear.

Typical flow:
1. Write the failing test(s)
2. Run the test(s) and confirm failure
3. Write the minimal implementation
4. Run the test(s) and confirm success
5. Commit

### Task template

````markdown
### Task N: [Component Name]

**Files:**
- Create: `exact/path/to/file.py`
- Modify: `exact/path/to/existing.py:123-145`
- Test: `tests/exact/path/to/test.py`

- [ ] **Step 1: Write the failing test**

```python
def test_specific_behavior():
    result = function(input)
    assert result == expected
```

- [ ] **Step 2: Run test to verify it fails**

Run: `pytest tests/path/test.py::test_name -v`
Expected: FAIL with "function not defined"

- [ ] **Step 3: Write minimal implementation**

```python
def function(input):
    return expected
```

- [ ] **Step 4: Run test to verify it passes**

Run: `pytest tests/path/test.py::test_name -v`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add tests/path/test.py src/path/file.py
```

Commit changes following repository style.
````

## No Placeholders

Do not write:
- `TBD`, `TODO`, `implement later`, or other placeholders
- vague instructions like "add appropriate error handling"
- "write tests" without actual test content
- references to undefined functions, types, or methods
- "similar to Task N" instead of restating the needed details

If a step changes code, include the exact code. If a step runs verification, include the exact command and expected result.

## Self-Review

After writing the plan:

1. Check that each requirement from the approved design is covered.
2. Scan for placeholders or vague language.
3. Check type names, function names, and interfaces for consistency across tasks.
4. Make sure the plan is still scoped correctly; split it if it has become too large.

Fix issues inline before handing the plan off.

## Handoff

After saving the plan, offer execution options:

- **Subagent-driven** — execute task by task with review between tasks
- **Inline execution** — execute tasks in the current session with checkpoints
