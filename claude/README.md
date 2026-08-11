# Claude Code config

User-level Claude Code configuration, symlinked into `~/.claude/` by
`../setup.sh` so it applies in every project:

- `commands/` → `~/.claude/commands/` — slash commands
- `skills/` → `~/.claude/skills/` — skills

Everything here must be **project-agnostic** — anything specific to a single
project belongs in that project's own `.claude/` directory instead. Edits take
effect immediately (symlinks, no sync step).

See [CONFIG-GUIDE.md](CONFIG-GUIDE.md) for what each command and skill does,
plus a playbook for working effectively with Claude Code.

Never commit Claude runtime state (`~/.claude/` credentials, history, session
transcripts, caches) to this repo.
