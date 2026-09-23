# Machine setup

Everything the workflow calls is vendored under `.agents/skills/`, so a clone has it, except two things that live outside this repo: the ponytail plugin, and the shell function that decides which ponytail mode a session starts in. SWI-Prolog is the third.

## SWI-Prolog

`brew install swi-prolog` (macOS) or the `ppa:swi-prolog/stable` package on Ubuntu, as `.github/workflows/framework.yml` does. Tests expect `swipl` 9.x on the path.

## ponytail

`.claude/settings.json` declares the marketplace and enables the plugin, so a fresh clone picks it up in Claude Code. Codex has no per-repository way to require a plugin; enable it on the Codex side.

## Design and build sessions

The workflow runs ponytail off while deciding and `full` while building (see [workflow.md](./workflow.md)). Which one a session gets is decided at launch by `PONYTAIL_DEFAULT_MODE`; the plugin's `SessionStart` hook re-reads it on every `startup`, `resume`, `clear`, and `compact`.

Ponytail's own default is `full`, so without the lines below a grilling session runs with ponytail on and argues you out of options before you have weighed them.

```zsh
# Ponytail off unless a build session asks for it
export PONYTAIL_DEFAULT_MODE=off

claude-design() { PONYTAIL_DEFAULT_MODE=off  command claude "$@"; }
claude-build()  { PONYTAIL_DEFAULT_MODE=full command claude "$@"; }
codex-design()  { PONYTAIL_DEFAULT_MODE=off  command codex  "$@"; }
codex-build()   { PONYTAIL_DEFAULT_MODE=full command codex  "$@"; }
```

Grill and spec in a design session; implement in a build one.
