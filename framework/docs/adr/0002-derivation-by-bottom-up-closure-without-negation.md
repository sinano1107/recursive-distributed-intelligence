---
status: accepted
supersedes: ADR 0001 (the meta-interpreter and stratified negation-as-failure parts only)
---

# Derivation is a bottom-up closure over ground atoms; Claim and Bridge bodies admit no negation

ADR 0001 planned a top-down meta-interpreter with stratified negation-as-failure. Probing the implementation with a recursive Claim (transitive containment) showed that top-down search cannot give exact refusals: a refuse or exclusion test must exhaust every derivation, and a plain depth bound turns `refuses` into "not within N", the same silent wrong verdict that ADR 0001 rejected LLM judges for. A variant-ancestor loop check was tried and is incomplete for left-recursive Claims. So the framework computes the set of true ground atoms bottom-up (a Datalog-style fixpoint over Core + Bridge rules + the Phenomenon's facts), which is exact and terminates for a range-restricted, function-free theory. Traces and the items a derivation passes through are then enumerated top-down over that finite ground set with an ancestor check, which is exact for acyclic derivations.

## Consequences

- Claims and Bridge rules must be range-restricted (every head variable occurs in the body) and may not use negation or built-ins in their bodies; each is a load error. `not/1` exists only as a Bridge head and in Observations, as the declared negation used for inconsistency.
- The search bound is a safety net for theories that build ever-new terms. Hitting it is a distinct failure, never a clean verdict.
- Stratified negation can be added later by stratifying the closure; nothing in the seams changes. Until a slice needs it, it stays out.
