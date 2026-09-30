# Workflow

How work moves from a request to a merged pull request in this repo. The engineering skills carry the steps; this file records the routing between them, the places this repo deviates from what the skills assume, and the decisions about *how we work* that are not derivable from the code.

Ask `/ask-matt` when the question is "which skill fits". This file answers "how this repo strings them together".

## Two kinds of work, two ways of working

- **Theory work**: anything under `theory/`. The theory is the user's own thought, held in the vault; the repo formalises it. So theory work is **dialogic**: the user decides what the theory says, the session proposes formalisations and runs the checks, and sub-agents only review from a fresh context. Nothing about the theory is handed to an agent that works alone. The reasons are recorded in issue #23: two relays (thread, skill, sub-agent) lose the intent; the theory's picture of intelligence (a directed system's working, not a capacity that descends to its components) differs from the default an LLM learned, so a fresh agent drifts back to the default; and the decisions that shape the Core are taken in the gate dialogue, where writing the Core at once is faster and truer than briefing someone else to.
- **Framework work**: code under `framework/`, tested at the four seams of ADR 0004. Ordinary software: designed with the user, built by a sub-agent.

## Entry points

| The work arrives as | Start with |
| --- | --- |
| An issue someone else filed | `/triage` |
| Something is broken and resists a first look | `/diagnosing-bugs` |
| A framework design idea, or a change to how we work (a skill, this file) | `/grill-with-docs` |
| An effort too foggy to scope in one session | `/wayfinder`, rejoining at `/to-spec` when the map clears |
| A theory slice from the reading map, or a Verdict that contradicts the vault | File the issue (the observation, the vault passage it contradicts), then `/theory-slice <issue>` in a fresh session |
| A framework issue on `ready-for-agent` | `/implement-rdi <issue>` in a build session |

`/triage` and `/grill-with-docs` are two ways to reach the same place: an issue someone can build from. They do not chain.

## Labels

`ready-for-agent` is for framework issues: a sub-agent builds them. Theory issues go to `ready-for-human`: the user drives them in a `/theory-slice` session, and the label says an agent alone is not to start one. See [triage-labels.md](./triage-labels.md).

## What a grilling session lands

`/grill-with-docs` (framework design, workflow changes) is finished when the record is, not when the design tree is walked:

1. **ADRs** under `docs/adr/` (repo-wide) or `framework/docs/adr/` (framework-scoped): decision and rationale only. See the ADR landing convention in [domain.md](./domain.md).
2. **`CONTEXT-MAP.md` and `framework/CONTEXT.md`, updated as each term lands**, not batched. `framework/CONTEXT.md` never borrows a theory term.
3. **Findings outside the scope, split into their own issues.**
4. **The implementation work, written up** as issues (specs and tickets are GitHub issues here, not files).
5. **A commit on `main`**, not pushed.

## Theory work

`/theory-slice <issue>` carries the steps; what follows is the shape.

- **The issue is the session's memory.** Decisions go to the issue in the round they land, ADR-level ones to `theory/docs/adr/`, post-gate ones to PR comments. The other AIs the user consults read the issue and the vault, not the session, and a session that has to stop resumes from the issue.
- **Rounds, not a dispatch.** Phenomena first (the user chooses what the theory must explain, must refuse, and must keep apart), then Core and Bridge in rounds; each round ends with the user accepting, marking `provisional`, or sending back each Claim, judged on the `render/2` rendering, its Japanese translation, and a plain-language account of the phenomena's facts and boundaries. The gate closes when every Claim is accepted; reviews start only then.
- **Review is where sub-agents enter**: one independent fresh-context review, then `/ponytail-review`, then `/code-review`, in that order. A finding that touches what the theory says is the user's to judge; wording and layout the session applies itself.
- **Order of slices** follows the vault's reading map (`knowledge/recursive-relational-systems-map.md`). `evidence-has-a-scope` is **not** a slice: it is the test suite's own discipline (ADR 0002).
- **A claim that does not survive formalisation** is set `provisional` and filed; the finding is part of what the theory learns about itself (ADR 0001).
- **LLMs propose formalisations and may polish rendered prose. They never decide a Verdict, and polished prose is never fed back into the Core** (ADR 0001).

## Language

Everything in the repo (Core, prose, tests, ADRs, glossaries, skills written here) is English, because the framework is meant to be extracted as open source and the theory's prose already follows the vault's English convention. Issue and PR bodies may be Japanese; they are for the human and do not leave with the framework. Conversation is Japanese, and so is the translation the gate shows beside each rendering.

## Sessions

- **A theory issue is one session, from the phenomena grill to the open PR.** The gate and the Core writing interleave, so there is no design/build seam to split at. The context grows; the issue carries the decisions so that `/handoff` plus a fresh session can resume if it has to. Each theory issue gets its own session, so that one slice's phenomena do not bias the next slice's choice.
- **Framework work: design in one session, build in another.** A long grilling session replays its whole context on every implementation turn. Grill, land the record, then start a fresh build session for `/implement-rdi`.
- **One issue per session, cleared between them.** Two sessions in one checkout share an index and a `HEAD` and corrupt each other.
- **End a session with `/handoff`** when work continues elsewhere. The handoff is navigation, not canonical design storage: the record is the ADRs, the glossaries, and the issues.

## ponytail

`/ponytail` is a standing mode that biases how work gets done; `/ponytail-review` is a one-shot pass over a diff. Neither substitutes for the other.

The mode is chosen by the launcher, once per session (`claude-design` off, `claude-build` full); see [machine-setup.md](./machine-setup.md).

- **Theory sessions run off throughout.** Minimality of the Core is a theory decision (whether two Claims that share a body are one distinction or two is for the user, and an ADR may already have answered), so YAGNI pressure enters only as `/ponytail-review` findings put to the user, never as a standing mode over the thread. If the plugin's ruleset is in context during a theory session, stop and tell the user.
- **Framework sessions**: design (`/grill-with-docs`, `/to-spec`) off, so YAGNI pressure does not kill options before they are weighed; build (`/implement-rdi`) full. `/implement-rdi` sets `/ponytail full` itself before dispatching.

## Choosing the model

Framework issues only. `/implementation-delegation` decides the implementation model, the effort, and the review strength; `/implement-rdi` runs it when nothing follows the issue number. Claude Code sub-agents inherit the session's effort, so on Claude the effort has to be right at launch and the skill can only check it. A theory session has nothing to delegate: the thread's own model does the work, and the review sub-agents run at the same setting.

## Building the framework

`/implement-rdi <issue> [decision already taken]`. See [the skill](../../.agents/skills/implement-rdi/SKILL.md) for what one run does. The stage order after TDD is fixed: `ponytail-review` first, then `/code-review`, so the review covers the code that will actually ship.

Tests need SWI-Prolog (`swipl`, 9.x) on the path. There is no typecheck; loading a file with `swipl -g halt <file>` is the stand-in. `theory/test/` runs in the same suite, so a framework change that flips a theory Verdict shows up as a finding.

## Who decides what

Theory work:

- **The phenomena** a slice must explain, refuse, and keep apart: the user.
- **Every Claim**: accepted, `provisional`, or sent back by the user at the gate. A Core change after the gate is a re-gate.
- **Review findings that touch the theory's content**: the user.
- **Merging the pull request**: the user. The skill stops at an open PR; `Closes #<issue>` closes the issue on merge.

Framework work:

- **Agreeing the seams** before the first test. They are fixed by ADR 0004; the confirmation restates which seam each acceptance criterion lands at.
- **Merging the pull request**, as above.
