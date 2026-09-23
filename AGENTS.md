## Agent skills

### Issue tracker

Issues are tracked as GitHub Issues in `sinano1107/recursive-distributed-intelligence` (via the `gh` CLI). See `docs/agents/issue-tracker.md`.

### Triage labels

The five canonical triage roles use their default label names (`needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix`). See `docs/agents/triage-labels.md`.

### Implementation

For a `ready-for-agent` issue use `/implement-rdi <issue>` (not `/implement`). `/implementation-delegation <issue>` picks the model, effort, and review strength first. Test seams are fixed by `docs/adr/0004`.

### Domain docs

Single-context: one `CONTEXT.md` and `docs/adr/` at the repo root. See `docs/agents/domain.md`.
