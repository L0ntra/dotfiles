# dotfiles

Personal configuration, symlinked into place by `setup.sh`.

## What's here

| Directory / file | Linked to | Purpose |
|---|---|---|
| `zshrc`, `zsh/` | `~/.zshrc`, `~/.zsh` | Zsh configuration |
| `ghostty/` | `~/.config/ghostty` | Ghostty terminal config |
| `claude/commands`, `claude/skills`, `claude/settings.json` | `~/.claude/commands`, `~/.claude/skills`, `~/.claude/settings.json` | User-level Claude Code slash commands, skills, and settings — see [claude/README.md](claude/README.md) |
| `installers/` | — | Package install scripts (Arch Linux) |

## Setup

```bash
git clone git@github.com:L0ntra/dotfiles.git
cd dotfiles
./setup.sh
```

`setup.sh` is idempotent — it skips any symlink whose target already exists,
so it's safe to re-run after pulling changes. If a real file (not a symlink)
already occupies a target path, move it aside first.

Edits to files in this repo take effect immediately — everything is symlinked,
so there is no sync step.
