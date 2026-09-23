% Cognitive transformation mechanisms. Core vocabulary: component_of/2,
% transformation/3, consumed_by/2, returns_to/2, task_criterion/2, held_by/2,
% mechanism_in/2, cognitive_system/1, capable_of/2, shared_in/2,
% self_correcting_system/1.

% A component is a mechanism of a system when another component of that
% system takes up what it transforms. Nothing is said about the component's
% own intelligence.
claim(mechanism_when_its_output_is_consumed, required,
    (mechanism_in(X, S) :-
        component_of(X, S), transformation(X, _, Out),
        consumed_by(Y, Out), component_of(Y, S))).

% Organisation alone makes a cognitive system: no task, no recurrence.
claim(whole_when_it_has_a_mechanism, required,
    (cognitive_system(S) :- mechanism_in(_, S))).

% Direction comes from a task criterion supplied to the system.
claim(capable_when_organised_and_tasked, required,
    (capable_of(S, T) :- cognitive_system(S), task_criterion(S, T))).

% Passive holding is a coupling surface, not a mechanism.
claim(shared_state_when_stored_and_consumed, required,
    (shared_in(R, S) :-
        held_by(X, R), component_of(X, S),
        consumed_by(Y, R), component_of(Y, S))).

% Recurrence: the component that takes up a mechanism's output feeds back
% into that mechanism.
claim(self_correcting_when_output_returns, required,
    (self_correcting_system(S) :-
        component_of(X, S), transformation(X, _, Out),
        consumed_by(Y, Out), component_of(Y, S), returns_to(Y, X))).

template(component_of(X, S), [X, is, a, component, of, S]).
template(transformation(X, In, Out), [X, transforms, In, into, Out]).
template(consumed_by(Y, R), [Y, takes, R, as, input]).
template(returns_to(Y, X), [Y, feeds, its, output, back, into, X]).
template(task_criterion(S, T), [S, is, given, the, task, T]).
template(held_by(X, R), [X, passively, holds, R]).
template(mechanism_in(X, S), [X, serves, as, a, cognitive, transformation, mechanism, in, S]).
template(cognitive_system(S), [S, is, an, organised, cognitive, system]).
template(capable_of(S, T), [S, is, intelligent, with, respect, to, T]).
template(shared_in(R, S), [R, is, a, coupling, surface, within, S]).
template(self_correcting_system(S), [S, corrects, itself, through, recurrence]).
