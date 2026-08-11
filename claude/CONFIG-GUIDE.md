# Claude Code Config Guide

A reference for everything in this repo: what each command and skill does, how the settings files work, and a playbook for getting the most out of Claude Code.

---

## Part 1 — Quick Reference

### How this config gets loaded

Claude Code discovers configuration from two places, and the distinction matters:

| Location | Scope | What lives there |
|---|---|---|
| `~/.claude/` | **User-level** — active in every project | `settings.json`, `commands/`, `skills/`, `agents/`, `CLAUDE.md` |
| `<project>/.claude/` | **Project-level** — active only in that directory | Same file types, checked into the project repo |

**The dotfiles repo is the source of truth for user-level config.** `~/.claude/commands` and `~/.claude/skills` are symlinks into `claude/commands/` and `claude/skills/` here (created by `setup.sh`), so every command and skill is available in every project. Edits take effect immediately — no sync step.

### Commands at a glance

| Command | One-liner |
|---|---|
| `/prime` | Load broad codebase context at session start |
| `/plan-feature <desc>` | Deep research → write implementation plan to `.claude/plans/` |
| `/execute <plan>` | Implement a plan file task-by-task with validation gates |
| `/create-prd [path]` | Turn conversation context into a full PRD |

Only unique capabilities live here. Jobs covered by built-ins were removed:
CLAUDE.md generation (`/init`), committing (just say "commit this" — native
behavior writes a conventional-style message), code review (`/code-review`,
`/security-review`).

### Skills at a glance

| Skill | One-liner |
|---|---|
| `agent-browser` | Full CLI reference for browser automation: navigate, snapshot, click, fill, screenshot, record, mock network |
| `e2e-test` | Orchestrated end-to-end test run: 3 parallel research agents → start app → test every user journey with screenshots + DB verification → report |

### Settings files at a glance

| File | Purpose | Current contents |
|---|---|---|
| `~/.claude/settings.json` | User-level settings, all projects | `{"model": "claude-fable-5[1m]", "theme": "dark"}` |
| `<project>/.claude/settings.json` | Shared project settings (checked into that project) | — |
| `<project>/.claude/settings.local.json` | Personal/machine-local settings (gitignored) | — |

### Runtime state is never config

A live `~/.claude/` also contains `backups/`, `cache/`, `file-history/`, `history.jsonl`, `projects/` (session transcripts), `sessions/`, `shell-snapshots/`, `plugins/marketplaces/`, and `.credentials.json` (**OAuth credentials — never commit or share this file**). None of it belongs in version control — only `commands/` and `skills/` are symlinked from the dotfiles repo; everything else stays local to the machine.

---

## Part 2 — Commands in Detail

### `/prime`
**File:** `claude/commands/prime.md`

Front-loads project understanding at the start of a session — the subagent way. The main thread only checks git state; three parallel `Explore` subagents do the heavy reading (structure & architecture, conventions & patterns, domain & data) in their own disposable contexts and return condensed briefs, which get synthesized into one scannable report (overview, architecture, conventions with `file:line` examples, domain, validation commands, current state). Breadth without the context pollution of reading 20 files in the main thread.

**When to use it:** at the start of broad, cross-cutting sessions — architecture decisions, multi-module refactors, audits, onboarding to an unfamiliar repo. For a scoped task ("fix this bug in `auth.py`"), skip it — on-demand exploration is cheaper and sharper.

### `/plan-feature <feature description>`
**File:** `claude/commands/plan-feature.md`

The most sophisticated command here — a "context is king" planning workflow (PRP-style):

1. **Understand** the feature (problem, user story, complexity, affected systems)
2. **Gather codebase intelligence** via parallel subagents (structure, patterns, dependencies, testing conventions, integration points)
3. **Research externally** (docs, best practices, gotchas — with links)
4. **Think strategically** (edge cases, ordering, security, performance)
5. **Write a plan** to `.claude/plans/{kebab-case-name}.md` with mandatory-read file lists, step-by-step tasks (each with pattern references at `file:line`, imports, gotchas, and an executable validation command), a testing strategy, and acceptance criteria

The quality bar is explicit: the plan must pass a "no prior knowledge test" — someone unfamiliar with the codebase could implement from the plan alone.

### `/execute <path to plan>`
**File:** `claude/commands/execute.md`

The other half of the plan/execute pair. Reads the entire plan, implements tasks in order (verifying syntax/imports/types as it goes), implements the testing strategy, runs every validation command from the plan until all pass, then reports completed tasks, tests added, and validation output, ending ready to commit.

**Why the split matters:** planning and execution in one long session degrades both — the planner's exploration clutters the implementer's context. A plan file is a clean, durable handoff, and you can review/correct the plan before any code gets written. This is a genuine best practice.

### `/create-prd [output path]`
**File:** `claude/commands/create-prd.md`

Distills the current conversation into a 15-section PRD (executive summary, mission, personas, MVP in/out of scope, user stories, architecture, features, stack, security, API spec, success criteria, phased implementation plan, future work, risks, appendix), with style rules and a quality checklist. Defaults to `PRD.md`.

**When to use it:** after a design conversation, before `/plan-feature`. The natural pipeline is: **discuss → `/create-prd` → `/plan-feature` → `/execute` → `/e2e-test` → commit**.

---

## Part 3 — Skills in Detail

### `agent-browser`
**File:** `claude/skills/agent-browser/SKILL.md`

A complete command reference for the Vercel `agent-browser` CLI. The core loop:

```bash
agent-browser open <url>       # navigate
agent-browser snapshot -i      # get interactive elements as refs (@e1, @e2…)
agent-browser click @e1        # act on refs
agent-browser fill @e2 "text"
```

Covers navigation, snapshots (scoped/depth-limited), every interaction type, reading text/attributes/state, screenshots and PDF, video recording, waits (element/text/URL/network-idle/JS condition), device and viewport emulation, cookies/localStorage, network interception and mocking, tabs, iframes, dialogs, `eval`, semantic locators (`find role button click --name "Submit"`), saved auth state for skipping login, parallel sessions, `--json` output, and debugging (console, errors, traces, `--headed`).

The key discipline it teaches: **refs go stale after navigation or DOM changes — always re-snapshot.**

### `e2e-test`
**File:** `claude/skills/e2e-test/SKILL.md`

A full testing pipeline, and a good example of a well-designed "orchestrator" skill:

1. **Pre-flight:** platform check, frontend check, auto-install `agent-browser`
2. **Parallel research:** three simultaneous subagents — (a) app structure & every user journey, (b) DB schema & expected data flow per action with validation queries, (c) static bug hunt
3. **Start the app** in the background
4. **Task list:** one tracked task per user journey
5. **Test each journey:** snapshot → interact → wait → screenshot → analyze; verify DB records after every mutation (`psql`/`sqlite3` directly); **fix issues found and re-test**; responsive pass at mobile/tablet/desktop viewports
6. **Report:** journeys tested, issues found/fixed/remaining, optional markdown export

**When to use it:** after `/execute` completes, before code review — it catches integration issues unit tests miss.

---

## Part 4 — Settings, Permissions, and What Goes Where

### Precedence (highest wins)

1. Enterprise managed policy
2. Project `.claude/settings.local.json` (personal, per-machine)
3. Project `.claude/settings.json` (shared, checked in)
4. User `~/.claude/settings.json` (all projects)

### What settings.json can do (currently barely used)

- **`permissions.allow` / `deny`** — pre-approve safe commands (`Bash(uv run pytest:*)`, `Bash(git diff:*)`) so sessions don't stall on prompts; deny dangerous ones. The `/fewer-permission-prompts` skill can generate an allowlist from your actual usage history.
- **`hooks`** — shell commands the harness runs deterministically on events: e.g., auto-run a formatter after every file edit (PostToolUse), block edits to protected paths (PreToolUse), desktop-notify when Claude finishes (Stop). Hooks are guarantees; prompt instructions are suggestions.
- **`env`** — environment variables for every session.
- **`model`, `theme`, `statusLine`**, and more.

### Where each thing should live

| Item | Belongs in |
|---|---|
| Personal preferences (theme, model), universal commands/skills | `~/.claude/` |
| Project conventions, project-specific commands (startup runbooks, deploy steps), project CLAUDE.md | That project's repo |
| Machine-local permission grants | `settings.local.json` (gitignored) |
| Credentials, history, session transcripts | Nowhere shared — runtime state only |

---

## Part 5 — Optimization Playbook: Delivering Code with Claude

With an effectively unlimited token budget, the goal isn't spending fewer tokens — it's spending them where they buy correctness and speed. **The scarce resource is context quality, not tokens.** A focused 50k-token session outperforms a cluttered 200k-token one.

### 1. Protect the main thread's context

- **One task per session.** Start fresh (`/clear` or new session) for each feature or bug. Long sessions accumulate stale file reads and dead-end exploration that dilute attention and eventually get summarized away.
- **Push exploration into subagents.** "Find everywhere X is handled" as an `Explore` agent returns a conclusion, not 30 file dumps in your main context. Launch independent research agents in parallel — this is exactly what `/plan-feature` and `e2e-test` already do.
- **Don't front-load context you might need; let it be pulled on demand.** Reserve `/prime` for genuinely broad work.

### 2. Plan before building — and gate the plan

- Use **plan mode** (Shift+Tab) or `/plan-feature` for anything non-trivial. Reviewing a plan costs you minutes; reviewing a wrong 2,000-line diff costs you an afternoon.
- The plan file is your leverage point: correct it *before* execution, when changes are free.
- For unlimited-budget thoroughness, ask for **multiple approaches judged against each other** ("propose 3 designs and argue for one") — or opt into multi-agent orchestration with **workflows** (say "use a workflow" / "ultracode") for large sweeps: audits, migrations, adversarially-verified reviews.

### 3. Give Claude a way to know it's right

This is the single highest-leverage practice. Claude with a feedback loop self-corrects; Claude without one guesses.

- Every plan task should have an **executable validation command** (`/plan-feature` enforces this).
- Keep **fast test/lint/typecheck commands documented in CLAUDE.md** so any session can verify its own work.
- Use `e2e-test` after implementation — browser + database verification catches what unit tests can't.
- For UI work, have Claude **screenshot and look at the result** rather than assume.

### 4. Make CLAUDE.md earn its place

CLAUDE.md is loaded into *every* session — it's the most expensive real estate you have.

- Keep it short, accurate, and universally applicable: build/test/lint commands, hard conventions, gotchas.
- **Wrong or stale content is worse than missing content** — it misleads every future session (this repo's CLAUDE.md currently describes a different project).
- Don't duplicate what Claude Code auto-discovers (slash commands and skills are surfaced automatically).

### 5. Automate the deterministic parts

- **Hooks** for anything that should happen *every time*: format-on-edit, notify-on-finish, protect-these-files. Never spend prompt instructions on what a hook can guarantee.
- **Permission allowlists** so autonomous runs don't stall waiting for you to approve `pytest` for the 40th time.
- **Background processes** (`run_in_background`) for dev servers and long builds — Claude keeps working and gets notified.

### 6. Use git as your safety net

- Commit at every green checkpoint — cheap rollback beats careful forward-only progress.
- Ask for **worktrees** when you want parallel agents mutating files without collisions.
- Let Claude write the commits (say "commit this"), but keep staging explicit — never blanket-add untracked files.

### 7. Scale up deliberately

For big jobs (repo-wide migration, full audit, "find every bug"):
- Say **"use a workflow"** to opt into multi-agent orchestration: parallel finders → adversarial verifiers → synthesis.
- Structure as *discover → fan out → verify → synthesize* rather than one heroic session.
- For very long autonomous work, `/loop` (self-pacing recurring runs) and `/schedule` (cron-style cloud agents) exist.

### 8. The delivery pipeline this config supports

```
discuss idea → /create-prd → /plan-feature → [review the plan yourself]
→ /execute → /e2e-test → /code-review (built-in) → commit
```

Each stage produces a durable artifact (PRD → plan → code → test report → commit), each stage can run in a fresh, focused session, and each stage validates the previous one. That's the shape of high-throughput, high-trust AI-assisted delivery.
