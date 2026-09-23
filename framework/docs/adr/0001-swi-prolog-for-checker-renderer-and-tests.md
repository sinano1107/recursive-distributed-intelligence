---
status: accepted
---

# SWI-Prolog for the checker, derivation inspection, renderer, and tests

The framework needs a deterministic checker with inspectable derivations, a template renderer with an exact inverse, and a test runner. We use SWI-Prolog for all of them: derivations via a small meta-interpreter, rendering via DCGs (which give the round trip for free), tests via plunit, CI via `swipl -g run_tests` on GitHub Actions.

## Considered options

- Answer set programming (clingo). Better default negation, but the implementing agents are far more fluent in Prolog, and the theory's negative claims are handled by stratified negation-as-failure. Revisit if genuine default reasoning is needed.
- Z3 / SMT via Argdown. Gives unsat cores, but the existing front ends are LLM-based and the notation is a second language to maintain.
- A host language (TypeScript or Python) wrapping a Prolog engine. Rejected for now: one language keeps the package small; a wrapper can be added later without changing the core.
- Controlled-English systems (ACE/RACE, Naproche). Used as reference designs for the renderer, not as the runtime: their grammars are restrictive and they are in maintenance mode.

## Consequences

- The framework has no build step beyond having `swipl` installed.
- Rendering parses only its own template language; it never attempts to parse free prose.
