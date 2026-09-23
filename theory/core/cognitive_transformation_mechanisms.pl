% Cognitive transformation mechanisms. Core vocabulary: component_of/2,
% transformation/3, takes_up/2, returns_to/2, under_criterion/2, retains/2,
% cognitive_transformation/3, mechanism/1, mechanism_in/2, cognitive_system/1,
% evaluator_of/2, directed_by/2, realises_intelligence/2, shared_in/2,
% nested_in/2, recurrent_system/1, can_revise/1.

% A system transforms what a chain of its components transforms along
% uptake, and nothing that one component transforms alone: the system's
% transformation is the integration. So a system's transformation at a
% larger boundary follows from its organisation instead of being stated.
claim(transformation_when_components_chain, required,
    (transformation(S, In, Out) :-
        component_of(X, S), transformation(X, In, Mid),
        component_of(Y, S), takes_up(Y, Mid), transformation(Y, Mid, Out))).
claim(transformation_composes_along_uptake, required,
    (transformation(S, In, Out) :-
        transformation(S, In, Mid), component_of(Y, S),
        takes_up(Y, Mid), transformation(Y, Mid, Out))).

% A transformation is cognitive when something takes its output up and
% transforms it in turn. Being cognitive is a relation to a taker, not a
% property of the transformation; a taker that only records is not one.
% The taker may be the same component at a later time: the self is divided
% along time, so X = Y is allowed on purpose (issue #9).
claim(cognitive_when_taken_up_and_transformed, required,
    (cognitive_transformation(X, In, Out) :-
        transformation(X, In, Out), takes_up(Y, Out), transformation(Y, Out, _))).

% A mechanism is whatever performs a cognitive transformation. It needs no
% system to belong to, and nothing is said about its own intelligence.
claim(mechanism_when_it_transforms_cognitively, required,
    (mechanism(X) :- cognitive_transformation(X, _, _))).

% The boundary-relative role: a component serves as a mechanism in a system
% when another component of that system takes its output up and transforms
% it. The taker must transform here too, so an organised system is exactly
% one that transforms something as a system (the composition base).
claim(mechanism_when_its_output_is_consumed, required,
    (mechanism_in(X, S) :-
        component_of(X, S), transformation(X, _, Out),
        component_of(Y, S), takes_up(Y, Out), transformation(Y, Out, _))).

% Organisation alone makes a cognitive system: no criterion, no recurrence.
claim(whole_when_it_has_a_mechanism, required,
    (cognitive_system(S) :- mechanism_in(_, S))).

% Direction is supplied, not attributed: a criterion directs a system when it
% enters the working, either because a component takes the criterion up or
% because an evaluator judging under it takes the system's output up and its
% response returns into the system. Neither needs an internal goal.
claim(directed_when_component_takes_up_criterion, required,
    (directed_by(S, T) :- under_criterion(S, T), component_of(X, S), takes_up(X, T))).
claim(directed_when_evaluator_returns, required,
    (directed_by(S, T) :-
        under_criterion(S, T), evaluator_of(E, T), transformation(S, _, Out),
        takes_up(E, Out), returns_to(E, X), component_of(X, S))).

% Intelligence is the working of an organised system under a criterion that
% directs it, not a capacity the system owns and not a label.
claim(intelligence_when_organised_and_directed, required,
    (realises_intelligence(S, T) :- cognitive_system(S), directed_by(S, T))).

% Passive holding is a coupling surface, not a mechanism.
claim(shared_state_when_stored_and_consumed, required,
    (shared_in(R, S) :-
        retains(X, R), component_of(X, S),
        takes_up(Y, R), component_of(Y, S))).

% Scale-relative nesting: a whole at one boundary is a mechanism at a larger one.
claim(nested_when_whole_is_mechanism, required,
    (nested_in(X, S) :- cognitive_system(X), mechanism_in(X, S))).

% Recurrence (temporal re-entry): the component that takes up a mechanism's
% output and transforms it feeds its output back into that mechanism.
claim(recurrent_when_output_returns, required,
    (recurrent_system(S) :-
        component_of(X, S), transformation(X, _, Out),
        component_of(Y, S), takes_up(Y, Out), transformation(Y, Out, _),
        returns_to(Y, X))).

% Recurrence supports revision: a mechanism's later transformation acts on
% the response to its earlier output. Provisional: the vault hedges it
% (recurrence can fail or become costly, and is not a proven necessary
% condition), and the Claim adds little beyond the loop's existence.
claim(revision_when_recurrent, provisional,
    (can_revise(S) :- recurrent_system(S))).

template(component_of(X, S), [X, is, a, component, of, S]).
template(transformation(X, In, Out), [X, transforms, In, into, Out]).
template(takes_up(Y, R), [Y, takes, R, as, input]).
template(returns_to(Y, X), [Y, feeds, its, output, back, into, X]).
template(under_criterion(S, T), [S, is, under, the, criterion, T]).
template(evaluator_of(E, T), [E, judges, under, the, criterion, T]).
template(directed_by(S, T), [S, is, directed, by, the, criterion, T]).
template(retains(X, R), [X, passively, holds, R]).
template(cognitive_transformation(X, In, Out), [X, performs, a, cognitive, transformation, of, In, into, Out]).
template(mechanism(X), [X, is, a, cognitive, transformation, mechanism]).
template(mechanism_in(X, S), [X, serves, as, a, cognitive, transformation, mechanism, in, S]).
template(cognitive_system(S), [S, is, an, organised, cognitive, system]).
template(realises_intelligence(S, T), [S, realises, intelligence, under, the, criterion, T]).
template(shared_in(R, S), [R, is, a, coupling, surface, within, S]).
template(nested_in(X, S), [X, is, nested, in, S]).
template(recurrent_system(S), [S, is, a, recurrent, cognitive, system]).
template(can_revise(S), [S, can, revise, through, recurrence]).
