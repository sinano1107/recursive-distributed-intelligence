---
name: theory-slice
description: Formalise one theory issue with the user, in this thread — grill the phenomena, write Core, Bridge and phenomena round by round with the user accepting each Claim, then independent review, migration, and a PR that records every decision. Sub-agents only review. Use for any change under theory/.
disable-model-invocation: true
argument-hint: "<issue>"
---

# Theory slice

The theory is the user's own thought, held in the vault. This skill turns one issue's worth of it into Core statements the framework can check. The user decides what the theory says; this thread proposes formalisations, runs the checks, and keeps the record; sub-agents only review from a fresh context. Nothing about the theory is dispatched to an agent that works alone: two relays (thread, skill, sub-agent) lose the intent, and a fresh agent drifts back to the default picture of intelligence that this theory rejects (issue #23).

`$ARGUMENTS` is the issue number. The issue is either a **slice** (one vault note's claims enter `theory/`, ADR 0003) or a **revision** (a verdict that contradicts the vault, like #16). Both run the same rounds; a revision starts with the phenomenon that showed the contradiction.

## The record

The issue is the session's memory. Every decision the user takes is written to the issue in the round it lands, before the next round opens, so that a resumed session and the other AIs the user consults read the same record. ADRs carry decisions that overturn an earlier ADR (supersede; ADRs are immutable), `theory/CONTEXT.md` carries terms as they land, and PR comments carry decisions taken after the gate closed.

## Before the first round

In this thread:

1. Read the issue and its comments, every ADR it cites, `CONTEXT-MAP.md`, both `CONTEXT.md` files, and the vault note that is the source of expected verdicts (ADR 0003). For a slice, also the note's neighbours in `knowledge/recursive-distributed-intelligence-intellectual-neighbors.md` (the refuses come from there) and the Guardrails section (the exclusions come from there).
2. Create the branch `issue-<n>-<slug>` from `main`.
3. Confirm the session runs with ponytail off. If the plugin's ruleset is in context, stop and tell the user.

## Round 1: the phenomena

Grill (the `grilling` format: the whole frontier per round, a recommendation per question) until the user has chosen:

- the phenomena the theory must **explain**;
- the phenomena it must **refuse**, each one pinned to the condition under test, so that only that condition is absent;
- the **exclusion** tests from the Guardrails.

Choosing phenomena is the user's call because it sets the theory's discriminating power. Each phenomenon is put to the user as a plain-language account of its facts and boundary in the glossary's words, with the Observation term it expects or refuses. Round 1 closes when the chosen list is on the issue.

## Rounds 2 onward: formalising

Each round is one proposal, checked, then judged by the user.

1. **Write** in Observation vocabulary first: the phenomenon files (ADR 0002). A phenomenon without Bridge and Core is a load error, and that is the red (issue #7).
2. **Add** Core statements and shared Bridge rules under `theory/bridge/` until `check/2` returns the expected Verdicts. Each Bridge rule joins one Observation functor to one Core functor. The vault note is the source of expected verdicts and stays out of the Core: a Claim restates the note's meaning in Horn form, never its sentences.
3. **Check**: full suite (`swipl -g run_tests -t halt framework/test/*.pl theory/test/*.pl`) green; `check('theory', V)` all `explains` / `refuses`, with `pending` only on a `provisional` Claim; every `required` Claim on at least one derivation (`derivation/4` over the phenomena; until #21 lands the framework is silent about a dead Claim); `DependsOn` lists the Claims the phenomenon is written to test.
4. **Show** the user, per new or changed Claim: the rendering taken from `render/2` (never typed by hand), a Japanese translation of it, and for each phenomenon that needs a judgement, the facts and boundary in plain language in the glossary's words (`/wait-what` style). The user accepts the Claim, sets it `provisional`, or sends it back with the reason.
5. **Record**: accepted decisions to the issue; a decision that overturns an ADR to a new ADR under `theory/docs/adr/`; each term to `theory/CONTEXT.md` with its Core and Observation names and its _Avoid_ words. Commit the round.

A claim that does not survive formalisation is set `provisional` and filed (ADR 0001); the finding is part of what the theory learns about itself.

**The gate is closed** when every Claim on the branch has been accepted by the user, the user has compared the rendering with the vault prose (a judgement, not an assertion), and the checks in step 3 pass. Reviews start only then (issue #14): a review of a half-gated Core is stale by the time the gate closes.

## Review

Three passes, in this order. The user judges every finding that touches what the theory says (a Claim, a phenomenon, a glossary entry); this thread applies the rest (wording, layout, file placement) and says which it applied.

1. **Independent review**: one fresh-context sub-agent at this session's model, briefed with the issue, the diff against `main`, the vault note, the ADRs, `framework/README.md`, and both `CONTEXT.md` files. The brief cites documented standards only (README, `CONTEXT.md`, ADRs, `docs/agents/domain.md`) and asks for the theory-slice checklist: a Claim in `DependsOn` that no expected derivation passes through; a Bridge rule that joins more than one pair of functors; a refuse without an expect on the same Observation, or one whose facts lack more than the condition under test; an _Avoid_ word used as an identifier or in prose as the term's synonym; a glossary entry that says more or less than the Core does; a prose sentence whose Citation names a nearby Claim rather than the one it rests on. It also lists anything wrong the diff did not cause, with where and whether observed or suspected.
2. **`/ponytail-review`** over the branch's diff, in this thread. Minimality of the Core is a theory decision, so each finding goes to the user.
3. **`/code-review main`**, both axes. Add the same standards-only line and the same "did not cause" line to each brief.

When a later pass would reverse an earlier one, the documented standard decides, and the PR records the reversal (issue #23). A Core change after the gate is a re-gate: show the user the new rendering as in a round, and note the change in a PR comment.

Each pass with a diff is its own commit. Never amend.

## Migration (slice only)

After the reviews: move the note's prose into `theory/prose/` with a Citation on every substantive sentence, so that `cites_core/1` passes; sentences the Core is silent about go to issue #5 rather than under a nearby Claim. Replace the vault note with a pointer whose wording holds before and after the merge (the canonical home is the repository; the pull request is `#<n>`), via the context-vault MCP (`model` argument required). Commit as its own stage. If the PR is closed unmerged, restore the note from the vault's git history.

## Filing what the run found

Gather everything the run surfaced: the reviewers' "did not cause" notes, findings the user declined, Claims set `provisional`, and what you noticed. Search the tracker, closed issues included, then settle each:

- **Belongs to an existing issue**: comment there.
- **New, and observed**: `gh issue create --label needs-triage`, citing this issue and where the observation is (file, phenomenon, commit).
- **New, but only suspected**: `needs-info`, saying what observation would settle it.
- **Not worth an issue**: say so in the PR, with a checkable reason.

## The pull request

Push the branch and open a PR: a Japanese body with `## Summary`, `## 進め方` (this thread formalised with the user; which sub-agents reviewed, at which model), a `## Test plan` checklist, `## 決定` (the gate decisions, or a pointer to the issue and the PR comments that hold them), `## レビュー指摘の対応` (every finding from all three passes, with the commit that addresses it or the checkable reason it was declined; a filed one says `→ #n に起票`), `## 発見した問題`, and `Closes #<issue>`. After the last commit, `grep` every Claim name the body cites against `theory/core/`; a name the gate renamed is the usual miss.

## Where this stops

At the open pull request. The user merges; `Closes #<issue>` closes the issue with the merge.
