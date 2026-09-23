---
status: accepted
---

# Phenomena are written in a vocabulary disjoint from the core, joined by shared bridge rules

A deterministic checker makes a new tautology possible: a phenomenon can be encoded so that its derivation is trivial. We prevent this by writing phenomena only in an observation vocabulary that shares no names with the core, and by connecting the two through bridge rules that live in one shared place (`theory/bridge/`) rather than inside each phenomenon.

## Consequences

- A phenomenon file is written before the core statement that explains it.
- A bridge rule that trivialises a test affects every phenomenon at once, so it is visible in the verdicts rather than hidden in one file.
- Refusal tests (observations the theory must not derive) and exclusion tests (derivations that must not pass through a named claim) are first-class, so the suite measures what the theory declines to explain as well as what it explains.
- This is the theory's own "evidence has a scope" principle applied to its test suite: an observation bears on a claim only through an explicit bridge.
