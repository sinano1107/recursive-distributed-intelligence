---
name: implement-rdi
description: Build a ready-for-agent framework issue end to end — branch, TDD and ponytail-review in a sub-agent at the decided model, two-axis code review, one commit per stage, a PR that records how every review finding was handled, and the filing of what the run found. Framework issues only; a change under theory/ is /theory-slice. Use this instead of /implement in this repo.
disable-model-invocation: true
argument-hint: "<issue> [decision already taken]"
---

# Implement (RDI)

A repo-local derivative of `/implement`, ported from tidepool's `implement-tidepool`. Upstream `/implement` is left untouched so skills that route to it keep pointing at the canonical one. In this repo, reach for this skill for a **framework issue**: code under `framework/`, tested at the four seams of ADR 0004. It adds the branch, the ponytail beats, the code-review follow-through, the filing of what the run found, and the pull request, and it takes the delegation decision when one has not been made yet.

An issue that changes anything under `theory/` is not built here: the theory is formalised with the user in the thread, by `/theory-slice`. A framework issue that a theory issue is waiting on (a new check, a rendering) still runs here; the theory issue resumes when it has merged.

`$ARGUMENTS` is the issue number, optionally followed by a delegation decision already taken, written however `/implementation-delegation` phrased it, e.g. `7 Opus 5 / high, review at Fable 5.1`.

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

1. Read the issue, its comments, and every ADR it references. `CONTEXT-MAP.md` and `framework/CONTEXT.md` supply the vocabulary for test names and predicate names. `framework/` must never contain theory vocabulary; the framework's own tests use the toy fixture theories.
2. Create the branch `issue-<n>-<slug>` from `main`.
3. Name the seams. They are fixed by ADR 0004; restate which of the four framework seams each acceptance criterion lands at, and confirm with the user. Handing a criterion to an existing test is a claim: break the implementation and watch that test go red before naming it.
4. Set `/ponytail full` in this thread before dispatching. The plugin's `SubagentStart` hook copies the live mode into sub-agents; it does not set it.

## The implementation sub-agent

Dispatch one sub-agent at the implementation model, carrying the issue number, the agreed seams, and the governing ADRs. It owns two commits and returns what it did:

1. **Implementation**: `/tdd` at the agreed seams, one red-green slice at a time. Prolog has no typecheck; in its place, load each changed file with `swipl -g halt <file>` and run the single plunit file as it goes. Full suite (`swipl -g run_tests -t halt framework/test/*.pl theory/test/*.pl`) green, then commit. `theory/test/` runs too: a framework change that flips a theory Verdict is a finding, not a fixture to adjust.
2. **ponytail-review**: `/ponytail-review` over its own diff, inline in the same thread, applying what it finds. Full suite green, then commit. This runs before `/code-review` so the review covers the code that ships; when the later review would reverse an earlier one, the documented standard decides and the PR records the reversal.

A stage with no diff produces no commit. Never amend: keeping the stages apart is what makes each change reviewable and revertible on its own.

Alongside the commits, it returns the problems it found and left alone: anything outside the issue's scope it would otherwise have fixed or worked around. For each, what and where (file and line, or the test that shows it), whether observed or only suspected, and the existing issue it seems to belong to, if any.

## Code review

Back in this thread, run `/code-review main` on both axes against this branch's merge-base, then apply the findings that should be applied and commit them as the next stage. Standards sources in this repo are `framework/README.md`, `framework/CONTEXT.md`, the ADRs, and `docs/agents/domain.md`.

Add two lines to each review sub-agent's brief: "Cite the documented standard behind each finding; a rule that no document states is a suggestion, not a finding." and "Separately, list anything wrong you noticed that the diff did not cause; where, and whether you observed it or only suspect it."

Judge each finding. One finding is never yours to apply: one that contradicts a decision recorded in an ADR. The ADR is the decision of record, and overturning it is a fresh decision, not a fix.

## Filing what the run found

Before opening the PR, gather everything the run surfaced: the sub-agent's report, the reviewers' notes on what the diff did not cause, review findings left unapplied because they lie outside the issue, and what you noticed yourself. Search the tracker for each, closed issues included (`gh issue list --state all --search "<words>"`), then settle it:

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
