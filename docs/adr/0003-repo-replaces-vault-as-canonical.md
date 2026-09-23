---
status: accepted
---

# This repository, not the context vault, is the canonical home of the theory

The theory currently lives as about forty prose notes in the personal context vault under `knowledge/`. The vault's rules forbid content derivable from a git repository, and keeping two copies would drift. So the repository becomes canonical and the vault keeps only the purpose of the theory and a pointer here.

## Consequences

- Migration is per slice, not in bulk: when a note's claims are in the core and rendered, the note's prose moves into `theory/prose/` with citations added, and the vault note is replaced by a pointer.
- Notes not yet migrated remain authoritative in the vault until their slice lands. The boundary between migrated and unmigrated is always explicit.
- The existing vault prose serves as the independent source of expected verdicts while rebuilding, which keeps tests from being written to match the code.
