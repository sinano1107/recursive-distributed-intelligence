---
status: accepted
---

# The formal core is canonical; prose is a rendering of it

The theory was written as English prose and the first design put an LLM judge over that prose to decide whether new claims followed from earlier ones and whether phenomena were explained. We rejected this because an LLM judge is non-deterministic, and the point of building the theory test-first is to make each step certain. Instead the theory's canonical form is a deterministic formal core; prose is derived from it by templates, and any LLM involvement is confined to non-authoritative roles (proposing formalisations that the checker verifies, or polishing rendered prose that is never fed back).

## Considered options

- LLM judge over prose, with a candidate/approved state on verdicts. Rejected: the theory would rest on a judge that gives different answers on different days.
- Formalise everything. Rejected: the theory's own guardrails say it is graded, multidimensional, and boundary-relative, and those claims do not survive crisp predicates.
- Formal core plus prose shell (chosen). Only the core runs red → green. Prose must cite core claims, and the citation is checked structurally; the prose's meaning is not checked at all.

## Consequences

- The core will be smaller than the prose. A claim that cannot be formalised is either `provisional` or is a modelling stance rather than a claim. That is a finding about the theory, not a tooling gap.
- The rebuild loop is: pick a claim, write the phenomenon it should explain (red), add core statements until the derivation passes (green), render, then a human compares the rendering against the existing prose. That comparison is a review gate, not an assertion; template output will never match hand-written prose word for word.
