# Framework

A test-first harness for a theory whose canonical form is a deterministic formal core, with human-readable prose derived from it. The framework runs red → green over the core and treats prose as a rendering, never as the source of truth.

## Language

### Theory structure

**Core**:
The set of formal statements that constitute the theory. The Core is canonical: if the Core and the Prose shell disagree, the Core is right.
_Avoid_: model, knowledge base, ontology

**Claim**:
One formal statement in the Core, identified by name and carrying a Status.
_Avoid_: proposition, axiom, rule

**Prose shell**:
Human-readable exposition of the Core. Every substantive sentence in the Prose shell carries a Citation to one or more Claims. The Prose shell is never checked for meaning, only for Citations.
_Avoid_: documentation, notes, canonical text

**Citation**:
A reference from a sentence of the Prose shell to the Claim the sentence rests on. It says "judge this sentence by that Claim"; it does not say that the Claim entails the sentence, and the framework never checks meaning. Citations are the only deterministic link between prose and Core: a sentence without one cannot be written, and a sentence whose Claim disappears fails the check.
_Avoid_: link, reference, quotation

**Status**:
The strictness level attached to a Claim. `required` claims must pass every test that depends on them; `provisional` claims may leave tests pending; `untested` claims are excluded from checking.
_Avoid_: maturity, confidence

### Tests

**Phenomenon**:
A test case: a description of something in the world, written in Observation vocabulary, plus the Observations the theory is expected to derive or to refuse.
_Avoid_: example, scenario, fixture

**Observation vocabulary**:
The namespace in which Phenomena are written. It is disjoint from the Core's internal vocabulary, so a Phenomenon cannot restate a Claim.
_Avoid_: test predicates

**Bridge rule**:
A statement connecting Observation vocabulary to Core vocabulary. Bridge rules are shared across all Phenomena, so a rule that trivialises one test trivialises them all visibly.
_Avoid_: mapping, glue

**Derivation**:
The trace by which the framework obtains an Observation from the Core, the Bridge rules, and a Phenomenon's facts.
_Avoid_: proof, explanation

**Exclusion test**:
A test asserting that a Derivation must not pass through a named Claim or vocabulary item. Used to check that the theory keeps distinctions it says it keeps.
_Avoid_: guardrail, negative test

**Verdict**:
The outcome of checking one Phenomenon: `explains` (every expected Observation is derivable through at least one Claim the Phenomenon depends on), `refuses` (an Observation the theory is expected to reject is not derivable), `inconsistent` (the Core with the Phenomenon's facts contradicts itself), `failed` with a reason, or `pending` when the failure rests only on provisional Claims. A Derivation that reaches an Observation without passing through any depended-on Claim is `vacuous`, a failure: the Phenomenon did not test the theory. An Exclusion test yields `explains` or a named violation. A Verdict is never issued from an unfinished search; an unfinished search is itself a distinct failure.
_Avoid_: result, pass/fail

### Rendering

**Rendering**:
Deterministic conversion of a Claim or Derivation into English via templates. Rendering has an exact inverse over its own template language; that round trip is the renderer's only correctness test. Rendering does not parse free prose.
_Avoid_: generation, translation

**Template**:
The English pattern attached to one Core vocabulary item, together with composition rules.
_Avoid_: phrase, string
