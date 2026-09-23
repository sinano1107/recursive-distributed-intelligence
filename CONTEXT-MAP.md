# Context Map

This repository holds two contexts. They are kept apart so that the framework can be extracted as an independent open-source package without carrying the theory's vocabulary with it.

## Contexts

- [Framework](./framework/CONTEXT.md): a test-first harness for a theory written as a deterministic formal core with a prose shell. Knows nothing about any particular theory.
- [Theory](./theory/CONTEXT.md): the recursive distributed-intelligence theory itself, expressed in the framework's terms.

## Relationships

- **Theory → Framework**: the theory supplies a Core, Phenomena, Bridge rules, and a Prose shell as inputs to the framework's check.
- **Framework → Theory**: the framework returns Verdicts and Statuses; it never edits the theory.
- **Rule**: the Framework context never references Theory vocabulary. Any term that only makes sense for one theory belongs in `theory/`.
