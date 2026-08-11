---
description: Scaffold a CLAUDE.md file from a template, adapting sections based on project type.
---

# Create CLAUDE.md

Generate a `CLAUDE.md` file at the project root based on the template.

Use the following template structure, filling in sections based on the project's actual configuration, tech stack, and patterns found in the codebase.

---

# CLAUDE.md

This file provides guidance when working with code in this repository.

## Project Overview

<!-- What is this project? One paragraph description -->

{Project description and purpose}

---

## Tech Stack

<!-- List technologies used. Add/remove rows as needed -->

| Technology | Purpose |
|------------|---------|
| {tech} | {why it's used} |

---

## Commands

<!-- Common commands for this project. Adjust based on your package manager and setup -->

```bash
# Development
{dev-command}

# Build
{build-command}

# Test
{test-command}

# Lint
{lint-command}
```

---

## Project Structure

<!-- Describe your folder organization. This varies greatly by project type -->

```
{root}/
├── {dir}/     # {description}
├── {dir}/     # {description}
└── {dir}/     # {description}
```

---

## Architecture

<!-- Describe how the code is organized. Examples:
- Layered (routes → services → data)
- Component-based (features as self-contained modules)
- MVC pattern
- Event-driven
- etc.
-->

{Describe the architectural approach and data flow}

---

## Code Patterns

<!-- Key patterns and conventions used in this codebase -->

### Naming Conventions
- {convention}

### File Organization
- {pattern}

### Error Handling
- {approach}

---

## Testing

<!-- How to test and what patterns to follow -->

- **Run tests**: `{test-command}`
- **Test location**: `{test-directory}`
- **Pattern**: {describe test approach}

---

## Validation

<!-- Commands to run before committing -->

```bash
{validation-commands}
```

---

## Key Files

<!-- Important files to know about -->

| File | Purpose |
|------|---------|
| `{path}` | {description} |

---

## Notes

<!-- Any special instructions, constraints, or gotchas -->

- {note}
