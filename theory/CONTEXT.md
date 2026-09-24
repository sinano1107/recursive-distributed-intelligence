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
- **Criterion** (`under_criterion/2`; Observation `criterion/2`) and **Evaluator** (`evaluator_of/2`; Observation `judges_under/2`): a criterion attributed to S, and who judges under it.
- **Holding** (`retains/2`; Observation `stores/2`): X keeps R available without transforming it. "Passively" glosses the absence of a transformation by X.

### Cognitive transformation mechanisms

**Transformation** (`transformation/3`; Observation `transforms/3` for a stated one, `turns/3` for a derived one):
One representation or state turned into another by some component. Not every transformation is cognitive. A system transforms what a chain of its components transforms along uptake, and nothing that one component transforms alone, so a system's transformation is its integration and is derived from its organisation, never stated.
_Avoid_: computation, processing step

**Uptake by the working** (`taken_up_by_working/2`):
The working of a directed system takes a state up when a component of the system takes it up and transforms it, or when an evaluator judging under the system's criterion takes it up, transforms it, and its response returns into the system. A taker that only records does not count; neither does a system that nothing directs, nor an evaluator that never replies.
_Avoid_: consumption, reception

**Cognitive transformation** (`cognitive_transformation/3`):
A transformation whose output the working of a directed system that the transformer belongs to takes up. Being cognitive is a role in a system, not a property of the transformation itself and not a relation to a lone taker; whoever describes the phenomenon draws the boundary. It need not reduce information and need not succeed. The taker may be the same component at a later time: the self is divided along time.
_Avoid_: compression, useful transformation, intrinsic property, context-sensitive

**Cognitive transformation mechanism** (`mechanism_in/2`; Observation `serves_as_mechanism/2`):
A component whose output the working of its directed system takes up: the boundary-relative role, and the only sense of the word. `mechanism/1` (Observation `is_mechanism/1`) says only that the component serves as a mechanism in some system. Silent about the mechanism's own intelligence. A taker inside the boundary that does nothing with the output does not confer the role, and neither does a system that nothing directs. Mechanism-hood extends to the environment when the boundary is drawn to include it.
_Avoid_: agent, processor, node, sub-intelligence, system-less mechanism

**Coupling surface** (`shared_in/2`; Observation `shared_state/2`):
A state that one component passively holds and another component takes up. Holding is not transforming: a repository is a coupling surface, not a mechanism.
_Avoid_: memory, channel, interface

**Organised cognitive system** (`cognitive_system/1`; Observation `cognitive_whole/1`):
A system in which at least one component serves as a cognitive transformation mechanism, which requires some criterion to direct the system. A system that merely transforms as a system (its components' transformations chain along uptake, Observation `turns/3`) is not cognitive. No recurrence is required.
_Avoid_: collective, group mind, intelligent system, organised system (for the undirected case say "transforms as a system")

**Criterion** (`under_criterion/2`; Observation `criterion/2`):
What a system's transitions are judged effective by. A task, a goal, a value gradient or an evaluator's standard can supply one; the Core does not say where it comes from. Attributed to a system by whoever draws its boundary; attribution alone directs nothing, and a criterion is not an obligation.
_Avoid_: task, goal, objective, utility, reward

**Direction** (`directed_by/2`):
A criterion directs a system when it enters the working: a component takes the criterion up, or an evaluator judging under it (`evaluator_of/2`; Observation `judges_under/2`) takes the system's output up and its response returns into the system. Neither requires an internal goal.
_Avoid_: agency, motivation, alignment

**Intelligence** (`realises_intelligence/2`; Observation `carries_out/2`):
The working of an organised cognitive system under the criterion that directs it. Not a capacity the system owns and not an attribution. Judged at a boundary: a mechanism in an intelligent system need not realise intelligence at its own boundary, so intelligence does not descend to the components. The Core states only the two conditions; the vault's grading of intelligence is not formalised.
_Avoid_: capability, capacity, ability, IQ, scalar intelligence

**Recurrence** (`recurrent_system/1`; Observation `recurrent/1`):
Temporal re-entry: the component that takes up a component's output and transforms it feeds its own output back into that component. Structural: a generator and an adder feeding each other random numbers are recurrent. Distinct from recursive nesting.
_Avoid_: recursion, loop

**Recurrent cognitive system** (`recurrent_cognitive_system/1`; Observation `recurrent_whole/1`):
A recurrent system that is an organised cognitive system: the re-entry happens inside a working that a criterion directs.
_Avoid_: feedback loop, control loop

**Revision through recurrence** (`can_revise/1`, provisional; Observation `revisable/1`):
A recurrent cognitive system can revise: a mechanism's later transformation acts on the response to its earlier output, so no state at that mechanism is final. For re-entry that nothing directs, revision is not derived. Whether revision happens, corrects, or is affordable is not asserted.
_Avoid_: self-correction, learning, convergence

**Recursive nesting** (`nested_in/2`; Observation `nested/2`):
Scale-relative composition: an organised cognitive system at one boundary that serves as a cognitive transformation mechanism at a larger boundary. The same entity can be a system at one scale and a mechanism at another. Both boundaries must be directed: a mechanism in a larger system that nothing directs at its own scale is not nested, only a mechanism.
_Avoid_: recurrence, hierarchy, containment, part-whole
