# Workflow

How work moves from a request to a merged pull request in this repo. The engineering skills carry the steps; this file records the routing between them, the places this repo deviates from what the skills assume, and the decisions about *how we work* that are not derivable from the code.

Ask `/ask-matt` when the question is "which skill fits". This file answers "how this repo strings them together".

## Two kinds of work

- **Framework work**: code under `framework/`, tested at the four seams of ADR 0004. Ordinary software issues.
- **Theory slices**: moving one vault note's claims into `theory/` as Core statements, Bridge rules, Phenomena, and Prose shell. See **Theory slices** below.

## Entry points

| The work arrives as | Start with |
| --- | --- |
| An issue someone else filed | `/triage` |
| Something is broken and resists a first look | `/diagnosing-bugs` |
| An idea of your own | `/grill-with-docs` |
| An effort too foggy to scope in one session | `/wayfinder`, rejoining at `/to-spec` when the map clears |
| A theory slice whose issue exists | `/implement-rdi <issue>` (its first stage is the phenomena grill) |

`/triage` and `/grill-with-docs` are two ways to reach the same place: an issue an agent can build from. They do not chain.

## What a grilling session lands

`/grill-with-docs` is finished when the record is, not when the design tree is walked:

1. **ADRs** under `docs/adr/` (repo-wide) or `framework/docs/adr/` (framework-scoped): decision and rationale only. See the ADR landing convention in [domain.md](./domain.md).
2. **`CONTEXT-MAP.md` and the two `CONTEXT.md` files, updated as each term lands**, not batched. `framework/CONTEXT.md` never borrows a theory term; `theory/CONTEXT.md` gains terms one slice at a time.
3. **Findings outside the scope, split into their own issues.**
4. **The implementation work, written up** as issues (specs and tickets are GitHub issues here, not files).
5. **A commit on `main`**, not pushed.

## Language

Everything in the repo (Core, prose, tests, ADRs, glossaries, skills written here) is English, because the framework is meant to be extracted as open source and the theory's prose already follows the vault's English convention. Issue and PR bodies may be Japanese; they are for the human and do not leave with the framework. Conversation is Japanese.

## Sessions

- **Design in one session, build in another.** A long grilling session replays its whole context on every implementation turn. Grill, land the record, then start a fresh session for `/implement-rdi`.
- **One issue per session, cleared between them.** Two implementation sessions in one checkout share an index and a `HEAD` and corrupt each other.
- **Theory slices each get their own session**, so that one slice's phenomena do not bias the next slice's choice of phenomena.
- **End a session with `/handoff`** when work continues elsewhere. The handoff is navigation, not canonical design storage: the record is the ADRs, the glossaries, and the issues.

## ponytail

`/ponytail` is a standing mode that biases how work gets done; `/ponytail-review` is a one-shot pass over a diff. Neither substitutes for the other.

The mode is chosen by the launcher, once per session (`claude-design` off, `claude-build` full); see [machine-setup.md](./machine-setup.md). Design sessions (`/grill-with-docs`, `/to-spec`) run off so YAGNI pressure does not kill options before they are weighed. Build sessions (`/to-tickets`, `/implement-rdi`) run full. If the plugin's ruleset is in context while you are grilling, stop and tell the user before going on.

## Choosing the model

`/implementation-delegation` decides the implementation model, the effort, and the review strength. `/implement-rdi` runs it when nothing follows the issue number. Claude Code sub-agents inherit the session's effort, so on Claude the effort has to be right at launch and the skill can only check it.

## Building

`/implement-rdi <issue> [decision already taken]`. See [the skill](../../.agents/skills/implement-rdi/SKILL.md) for what one run does. The stage order after TDD is fixed: `ponytail-review` first, then `/code-review`, so the review covers the code that will actually ship.

Tests need SWI-Prolog (`swipl`, 9.x) on the path. There is no typecheck; loading a file with `swipl -g halt <file>` is the stand-in.

## Theory slices

The theory is rebuilt from the vault, not copied. The loop per slice is fixed by ADR 0001 and ADR 0002 and carried by `/implement-rdi`'s theory-slice stages:

1. The human picks, in a short grill, the phenomena the slice must **explain**, the phenomena it must **refuse**, and the exclusion tests from the note's Guardrails. Choosing phenomena is never delegated: it sets the theory's discriminating power.
2. Phenomenon files first (red), in Observation vocabulary; then Core statements and shared Bridge rules (green); then rendering.
3. The human compares the rendering with the vault prose. This is a review gate, not an assertion.
4. Prose moves into `theory/prose/` with citations; the vault note becomes a pointer; the slice's terms enter `theory/CONTEXT.md`.

Order of slices follows the vault's reading map (`knowledge/recursive-relational-systems-map.md`), starting with `cognitive-transformation-mechanisms`. `evidence-has-a-scope` is **not** a slice: it is the test suite's own discipline (disjoint Observation vocabulary and explicit Bridge rules, ADR 0002).

A claim that does not survive formalisation is not a tooling failure. It is set `provisional` and filed, and the finding is part of what the theory learns about itself (ADR 0001).

LLMs may propose formalisations and may polish rendered prose. They never decide a Verdict, and polished prose is never fed back into the Core (ADR 0001).

## Where a human is required

- **Agreeing the seams** before the first test. They are fixed by ADR 0004; the confirmation restates which seam each acceptance criterion lands at.
- **Choosing the phenomena** of a theory slice.
- **The rendering review gate** of a theory slice.
- **Merging the pull request.** The skill stops at an open PR. `Closes #<issue>` closes the issue on merge; no further confirmation gates that.
