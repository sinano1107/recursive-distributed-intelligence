## Agent skills

### Issue tracker

Issues are tracked as GitHub Issues in `sinano1107/recursive-distributed-intelligence` (via the `gh` CLI). See `docs/agents/issue-tracker.md`.

### Triage labels

The five canonical triage roles use their default label names (`needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix`). See `docs/agents/triage-labels.md`.

### Implementation

Two kinds of work. A change under `theory/` is formalised with the user in the thread: `/theory-slice <issue>`; sub-agents only review. A framework issue on `ready-for-agent` is built by `/implement-rdi <issue>` (not `/implement`), with `/implementation-delegation <issue>` picking the model, effort, and review strength first. Test seams are fixed by `docs/adr/0004`.

How the skills chain in this repo, why theory work is dialogic, session boundaries, and language: `docs/agents/workflow.md`. Per-machine prerequisites: `docs/agents/machine-setup.md`.

### Domain docs

Multi-context: `CONTEXT-MAP.md` at the repo root points to `framework/CONTEXT.md` and `theory/CONTEXT.md`. Repo-wide ADRs live in `docs/adr/`, framework-scoped ones in `framework/docs/adr/`, theory-scoped ones in `theory/docs/adr/`. See `docs/agents/domain.md`.
