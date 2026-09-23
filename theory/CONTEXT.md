# Theory

The recursive distributed-intelligence theory, expressed in the framework's terms: a formal Core, shared Bridge rules, Phenomena, and a Prose shell. Terms of the theory itself enter this glossary one slice at a time, as each claim is moved from the context vault into the Core.

Until a term has been migrated, its definition lives in the context vault under `knowledge/`; the reading map there is `knowledge/recursive-relational-systems-map.md`.

## Status mapping

The vault's note markers map onto the framework's Status levels:

- canonical → `required`
- exploratory → `provisional`
- supporting → `untested`

## Language

Each term names its Core vocabulary item; the Observation vocabulary a Phenomenon uses for it is listed where one exists.

### Cognitive transformation mechanisms

**Transformation** (`transformation/3`; Observation `transforms/3` for a stated one, `turns/3` for a derived one):
One representation or state turned into another by some component. Not every transformation is cognitive. A system transforms what its components transform and what a chain of them transforms along uptake, so a system's transformation at a larger boundary is derived from its organisation, never stated.
_Avoid_: computation, processing step

**Cognitive transformation** (`cognitive_transformation/3`):
A transformation whose output another component takes up and transforms in turn. Being cognitive is a relation to a taker, not a property of the transformation itself: the same transformation is cognitive at a boundary that contains such a taker and not at one that does not. It need not reduce information and need not succeed.
_Avoid_: compression, useful transformation, intrinsic property

**Cognitive transformation mechanism** (`mechanism/1`; Observation `is_mechanism/1`):
Whatever performs a cognitive transformation. It needs no system to belong to and is silent about its own intelligence. It serves as a mechanism in a particular system (`mechanism_in/2`; Observation `serves_as_mechanism/2`) when it is a component of that system and its cognitive transformation is taken up within it: that is the boundary-relative role.
_Avoid_: agent, processor, node, sub-intelligence

**Coupling surface** (`shared_in/2`; Observation `shared_state/2`):
A state that one component passively holds and another component takes up. Holding is not transforming: a repository is a coupling surface, not a mechanism.
_Avoid_: memory, channel, interface

**Organised cognitive system** (`cognitive_system/1`; Observation `cognitive_whole/1`):
A system in which at least one component serves as a cognitive transformation mechanism. Organisation alone makes one; no task and no recurrence is required.
_Avoid_: collective, group mind, intelligent system

**Task criterion** (`task_criterion/2`):
The task- or value-relative criterion under which a system's transitions count as effective. Supplied to the system from outside; it need not be an internal goal of the system.
_Avoid_: goal, objective, utility, reward

**Intelligence** (`realises_intelligence/2`; Observation `carries_out/2`):
The working of an organised cognitive system under a task criterion supplied to it. Not a capacity the system owns and not a binary property of an entity; the Core states only the two conditions, and the prose keeps the grading and boundary relativity.
_Avoid_: capability, capacity, ability, IQ, scalar intelligence

**Recurrence** (`recurrent_system/1`; Observation `recurrent/1`):
Temporal re-entry: the component that takes up a mechanism's output feeds its own output back into that mechanism. Distinct from recursive nesting.
_Avoid_: recursion, loop

**Revision through recurrence** (`can_revise/1`, provisional; Observation `revisable/1`):
A recurrent system can revise: a mechanism's later transformation acts on the response to its earlier output, so no state at that mechanism is final. Whether revision happens, corrects, or is affordable is not asserted.
_Avoid_: self-correction, learning, convergence

**Recursive nesting** (`nested_in/2`; Observation `nested/2`):
Scale-relative composition: an organised cognitive system at one boundary that serves as a cognitive transformation mechanism at a larger boundary. The same entity can be a system at one scale and a mechanism at another.
_Avoid_: recurrence, hierarchy, containment, part-whole
