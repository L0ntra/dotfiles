---
description: Prime the session with a broad codebase brief, assembled by parallel subagents to keep the main context lean.
---

# Prime: Load Project Context

## Objective

Build broad codebase understanding at the start of a session **without polluting
the main context**. All heavy reading happens in disposable subagent contexts;
only their condensed briefs land here.

Best used before broad work: architecture decisions, cross-cutting refactors,
audits, or onboarding to an unfamiliar repo. For scoped tasks (a bug fix, a
small feature), skip priming — on-demand exploration is cheaper and sharper.

## Process

### 1. Quick state check (main thread — cheap)

```bash
git status && git log -10 --oneline
```

### 2. Parallel research (subagents — the heavy reading)

Launch **three Explore subagents simultaneously** — issue all three Agent tool
calls in a single message, `subagent_type: "Explore"`, breadth "medium".

**Sub-agent 1 — Structure & Architecture:**

> Map this codebase. Return a condensed brief covering: project type and
> purpose; directory structure with each major directory's role; entry points;
> architectural pattern (layered, MVC, event-driven, …) and data flow;
> service/component boundaries and integration points; build/config files and
> what they reveal about the toolchain. Return conclusions, not file contents.

**Sub-agent 2 — Conventions & Patterns:**

> Study this codebase's conventions. Return a condensed brief covering: naming
> conventions (files, functions, types); how modules/files are internally
> organized; error handling approach; logging patterns; how types/interfaces
> are defined; test framework, test file locations, and test structure; lint,
> format, and validation commands; anything CLAUDE.md or docs mandate. Include
> one representative `file:line` example per pattern. Return conclusions, not
> file contents.

**Sub-agent 3 — Domain & Data:**

> Explain this codebase's domain model. Return a condensed brief covering:
> core entities/models and their relationships; database schema or persistence
> approach if any; external services and APIs consumed or exposed; the main
> user-facing capabilities and which modules implement them; any docs (README,
> PRD, architecture notes) worth reading in full later — list paths only.
> Return conclusions, not file contents.

### 3. Synthesize

Merge the three briefs with the git state into one report:

## Output Report

Keep it scannable — bullets and short headers:

- **Project Overview** — purpose, type, tech stack with versions
- **Architecture** — structure, patterns, boundaries, data flow
- **Conventions** — naming, errors, logging, testing, with `file:line` examples
- **Domain** — entities, persistence, integrations
- **Validation** — the exact commands to build, test, lint
- **Current State** — branch, recent commits, apparent development focus
- **Pointers** — docs or files worth reading in full if the task demands it

Do not re-read files the subagents already covered unless the upcoming task
requires their exact contents.
