---
name: implement-rdi
description: Build a ready-for-agent issue in this repo end to end — branch, TDD and ponytail-review in a sub-agent at the decided model, two-axis code review, one commit per stage, a PR that records how every review finding was handled, and the filing of what the run found. Handles both kinds of issue here: a framework issue (Prolog code) and a theory slice (phenomena, core, bridge, prose migration). Use this instead of /implement in this repo.
disable-model-invocation: true
argument-hint: "<issue> [decision already taken]"
---

# Implement (RDI)

A repo-local derivative of `/implement`, ported from tidepool's `implement-tidepool`. Upstream `/implement` is left untouched so skills that route to it keep pointing at the canonical one. In this repo, reach for this skill instead: it adds the branch, the ponytail beats, the code-review follow-through, the filing of what the run found, and the pull request, and it takes the delegation decision when one has not been made yet.

`$ARGUMENTS` is the issue number, optionally followed by a delegation decision already taken, written however `/implementation-delegation` phrased it, e.g. `7 Opus 5 / high, review at Fable 5.1`.

## Two kinds of issue

Decide which kind the issue is before anything else; the stages differ.

- **Framework issue**: changes under `framework/`. Code, tested at the four seams of ADR 0004. Follows the stages below as written.
- **Theory slice**: moves one vault note's claims into `theory/`. Tested only through phenomenon files (ADR 0004). Adds a grill before dispatch and a migration stage after the review gate; see **Theory slice stages**.

## Model and effort

`/implementation-delegation` picks the implementation model, the effort, and the review strength.

**Anything after the issue number is a decision already taken; do not run the delegation skill again.** Read it as prose (model names carry spaces). When it names one model, the review takes the same setting. With nothing after the issue number, run `/implementation-delegation <issue>` yourself and state what it decided.

Before touching the branch, say which models the run will use:

- **Implementation**: the TDD loop goes to a sub-agent at the implementation model.
- **`/code-review`**: its sub-agents take the review strength.
- **`/ponytail`** and **`/ponytail-review`**: never moved. Both run at the implementation's own setting. `/ponytail` is the standing mode that biases how code gets written; `/ponytail-review` is a one-shot pass over a diff.

Claude Code sub-agents inherit the session's effort, so the decided effort is a check: state the effort this session runs at, and if it is below the decision, stop and say so.

## Before writing code

Stay in this thread for all of these:

1. Read the issue, its comments, and every ADR it references. `CONTEXT-MAP.md` and the two `CONTEXT.md` files supply the vocabulary for test names and predicate names. `framework/` must never contain theory vocabulary.
2. Create the branch `issue-<n>-<slug>` from `main`.
3. Name the seams. They are fixed by ADR 0004; restate which of the four framework seams (or, for a theory slice, which phenomenon files) each acceptance criterion lands at, and confirm with the user. Handing a criterion to an existing test is a claim: break the implementation and watch that test go red before naming it.
4. Set `/ponytail full` in this thread before dispatching. The plugin's `SubagentStart` hook copies the live mode into sub-agents; it does not set it.

## The implementation sub-agent

Dispatch one sub-agent at the implementation model, carrying the issue number, the agreed seams, and the governing ADRs. It owns two commits and returns what it did:

1. **Implementation**: `/tdd` at the agreed seams, one red-green slice at a time. Prolog has no typecheck; in its place, load each changed file with `swipl -g halt <file>` and run the single plunit file as it goes. Full suite (`swipl -g run_tests -t halt` over `framework/test/` and `theory/test/`) green, then commit.
2. **ponytail-review**: `/ponytail-review` over its own diff, inline in the same thread, applying what it finds. Full suite green, then commit.

A stage with no diff produces no commit. Never amend: keeping the stages apart is what makes each change reviewable and revertible on its own.

Alongside the commits, it returns the problems it found and left alone: anything outside the issue's scope it would otherwise have fixed or worked around. For each, what and where (file and line, or the test that shows it), whether observed or only suspected, and the existing issue it seems to belong to, if any.

## Theory slice stages

A theory slice replaces the plain dispatch above with this sequence.

1. **Grill the phenomena, in this thread, with the user.** Before any file is written, agree: (a) the phenomena the note's claims must *explain*; (b) the phenomena the theory must *refuse* to explain (discriminating power against the neighbours in the vault's `recursive-distributed-intelligence-intellectual-neighbors.md`); (c) the exclusion tests taken from the note's Guardrails section. Choosing phenomena is the user's call because it sets the theory's discriminating power; a sub-agent would pick phenomena the theory trivially explains.
2. **Dispatch** the sub-agent with the agreed phenomena. Its order is fixed by ADR 0002: write the phenomenon files in Observation vocabulary first (red); then add Core statements and shared Bridge rules under `theory/bridge/` until `check/2` returns the expected Verdicts (green); then render the new Claims. The vault note is the independent source of expected verdicts and must not be pasted into the Core. Same two commits as above.
3. **Review gate, in this thread.** Compare the rendering with the vault prose. This is a human judgement, never an assertion (ADR 0001). Any claim that did not survive formalisation is set `provisional` and listed as a found problem below.
4. **Migration**, after code review: move the note's prose into `theory/prose/` with citations so that `cites_core/1` passes; add the slice's terms to `theory/CONTEXT.md`; replace the vault note with a pointer to the repo (ADR 0003; vault writes need the `model` argument on the context-vault MCP). Commit as its own stage.

## Code review

Back in this thread, run `/code-review main` on both axes against this branch's merge-base, then apply the findings that should be applied and commit them as the next stage. Standards sources in this repo are the `CONTEXT.md` files, the ADRs, and `docs/agents/domain.md`.

Add one line to each review sub-agent's brief: "Separately, list anything wrong you noticed that the diff did not cause; where, and whether you observed it or only suspect it."

Judge each finding. One finding is never yours to apply: one that contradicts a decision recorded in an ADR. The ADR is the decision of record, and overturning it is a fresh decision, not a fix.

## Filing what the run found

Before opening the PR, gather everything the run surfaced: the sub-agent's report, the reviewers' notes on what the diff did not cause, review findings left unapplied because they lie outside the issue, claims that did not survive formalisation, and what you noticed yourself. Search the tracker for each, closed issues included (`gh issue list --state all --search "<words>"`), then settle it:

- **Belongs to an existing issue**: comment there.
- **New, and observed**: `gh issue create --label needs-triage`, citing the originating issue and where the observation is (file, test, commit on this branch).
- **New, but only suspected**: file it `needs-info`, saying what observation would settle it. An issue is not an observation.
- **Not worth an issue**: say so in the PR, with a reason held to the same bar as a review finding.

## The pull request

Push the branch and open a PR: a Japanese body with `## Summary`, a `## Test plan` checklist, and `Closes #<issue>`. Record the delegation decision the run actually used.

Then add:

```markdown
## レビュー指摘の対応
```

List **every** finding `/ponytail-review` and `/code-review` raised, applied ones included. For each, say what was raised and either which commit addresses it or why it was not applied. A reason points at something checkable: an ADR number, a term in a `CONTEXT.md`, an existing test. "Out of scope" alone is not a reason. A finding that was filed says so on its own line (`→ #n に起票`).

Then `## 発見した問題` for the rest of what the filing step settled, each as filed `#<n>`, commented on `#<n>`, or not filed and why. Each problem appears in exactly one of the two sections.

## Where this stops

At the open pull request. Do not merge it, do not close the issue. The human merges, and `Closes #<issue>` closes the issue with the merge.
