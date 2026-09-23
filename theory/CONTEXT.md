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

### Primitives

These terms are not defined by any Claim. They enter as facts a Phenomenon states, and the theory takes them as given:

- **Component** (`component_of/2`; Observation `belongs/2`): X lies inside the boundary drawn around S. Boundaries are analytical: whoever describes a Phenomenon draws them, and the same entity can lie inside several.
- **Transformation** (`transformation/3`; Observation `transforms/3`): defined below only as far as composition; that a component transforms is a primitive.
- **Uptake** (`takes_up/2`; Observation `consumes/2`): Y takes R as input.
- **Return** (`returns_to/2`; Observation `feeds_back/2`): Y's output goes back into X.
- **Task** (`task_criterion/2`; Observation `task/2`) and **Evaluator** (`evaluator_of/2`; Observation `judges_under/2`): a criterion attributed to S, and who judges under it.
- **Holding** (`retains/2`; Observation `stores/2`): X keeps R available without transforming it. "Passively" glosses the absence of a transformation by X.

### Cognitive transformation mechanisms

**Transformation** (`transformation/3`; Observation `transforms/3` for a stated one, `turns/3` for a derived one):
One representation or state turned into another by some component. Not every transformation is cognitive. A system transforms what a chain of its components transforms along uptake, and nothing that one component transforms alone, so a system's transformation is its integration and is derived from its organisation, never stated.
_Avoid_: computation, processing step

**Cognitive transformation** (`cognitive_transformation/3`):
A transformation whose output a component takes up and transforms in turn. Being cognitive is a relation to a taker, not a property of the transformation itself, and the relation has no boundary: a taker anywhere makes it cognitive. It need not reduce information and need not succeed. The taker may be the same component at a later time: the self is divided along time.
_Avoid_: compression, useful transformation, intrinsic property

**Cognitive transformation mechanism** (`mechanism/1`; Observation `is_mechanism/1`):
Whatever performs a cognitive transformation. It needs no system to belong to and is silent about its own intelligence. It serves as a mechanism in a particular system (`mechanism_in/2`; Observation `serves_as_mechanism/2`) when a component of that system takes its output up and transforms it: that is the boundary-relative role, and a taker inside the boundary that does nothing with the output does not confer it.
_Avoid_: agent, processor, node, sub-intelligence

**Coupling surface** (`shared_in/2`; Observation `shared_state/2`):
A state that one component passively holds and another component takes up. Holding is not transforming: a repository is a coupling surface, not a mechanism.
_Avoid_: memory, channel, interface

**Organised cognitive system** (`cognitive_system/1`; Observation `cognitive_whole/1`):
A system in which at least one component serves as a cognitive transformation mechanism. Organisation alone makes one; no task and no recurrence is required.
_Avoid_: collective, group mind, intelligent system

**Task criterion** (`task_criterion/2`; Observation `task/2`):
The task- or value-relative criterion under which a system's transitions count as effective. Attributed to a system by whoever draws its boundary; attribution alone directs nothing.
_Avoid_: goal, objective, utility, reward

**Direction** (`directed_by/2`):
A criterion directs a system when it enters the working: a component takes the criterion up, or an evaluator judging under it (`evaluator_of/2`; Observation `judges_under/2`) takes the system's output up and its response returns into the system. Neither requires an internal goal.
_Avoid_: agency, motivation, alignment

**Intelligence** (`realises_intelligence/2`; Observation `carries_out/2`):
The working of an organised cognitive system under a criterion that directs it. Not a capacity the system owns and not a label. The Core states only the two conditions; the vault's grading of intelligence is not formalised.
_Avoid_: capability, capacity, ability, IQ, scalar intelligence

**Recurrence** (`recurrent_system/1`; Observation `recurrent/1`):
Temporal re-entry: the component that takes up a mechanism's output and transforms it feeds its own output back into that mechanism. Distinct from recursive nesting.
_Avoid_: recursion, loop

**Revision through recurrence** (`can_revise/1`, provisional; Observation `revisable/1`):
A recurrent system can revise: a mechanism's later transformation acts on the response to its earlier output, so no state at that mechanism is final. Whether revision happens, corrects, or is affordable is not asserted.
_Avoid_: self-correction, learning, convergence

**Recursive nesting** (`nested_in/2`; Observation `nested/2`):
Scale-relative composition: an organised cognitive system at one boundary that serves as a cognitive transformation mechanism at a larger boundary. The same entity can be a system at one scale and a mechanism at another.
_Avoid_: recurrence, hierarchy, containment, part-whole
