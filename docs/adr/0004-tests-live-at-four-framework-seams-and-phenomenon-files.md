---
status: accepted
---

# Automated tests live at four framework seams and, for the theory, only at phenomenon files

The tdd skill refuses to write a test at a seam that has not been agreed, and an implementing sub-agent cannot ask. So the seams are fixed here once, per context, rather than renegotiated per issue.

## Framework seams

1. `check(TheoryDir, Verdicts)`: load a theory directory and return one Verdict per Phenomenon and Exclusion test.
2. `explains(Phenomenon, Derivation)`: derive a Phenomenon's expected Observations from Core, Bridge rules, and the Phenomenon's facts, returning the Derivation trace; also detects refusal and inconsistency.
3. `render(Term, English)` / `parse(English, Term)`: exact inverse over the template language only. The round trip is the renderer's only correctness test.
4. `cites_core(ProseFile)`: structural check that prose cites existing Claims.

A behaviour is stated once, at the lowest seam it shows at. Internal predicates (the meta-interpreter, loaders, DCG helpers) are never tested directly.

## Theory seam

The theory is tested only through Phenomenon files run by `check/2`. No test may call a Core predicate directly, and no test may live inside `theory/core/` or `theory/bridge/`. This keeps the theory's tests independent of how the Core is encoded (ADR 0002).

## Consequences

- An issue that needs a new seam is a framework design change and gets its own grill and a supersession of this ADR, not an ad-hoc test.
- The framework's own tests use a toy fixture theory with no relation to the recursive distributed-intelligence theory (CONTEXT-MAP rule).
