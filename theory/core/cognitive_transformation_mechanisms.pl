% Cognitive transformation mechanisms. Core vocabulary: component_of/2,
% transformation/3, takes_up/2, returns_to/2, task_criterion/2, retains/2,
% mechanism_in/2, cognitive_system/1, realises_intelligence/2, shared_in/2,
% nested_in/2, recurrent_system/1.

% A component is a mechanism of a system when another component of that
% system takes up what it transforms. Nothing is said about the component's
% own intelligence.
claim(mechanism_when_its_output_is_consumed, required,
    (mechanism_in(X, S) :-
        component_of(X, S), transformation(X, _, Out),
        takes_up(Y, Out), component_of(Y, S))).

% Organisation alone makes a cognitive system: no task, no recurrence.
claim(whole_when_it_has_a_mechanism, required,
    (cognitive_system(S) :- mechanism_in(_, S))).

% Intelligence is the working of an organised system under a task criterion
% supplied to it, not a capacity the system owns.
claim(intelligence_when_organised_and_tasked, required,
    (realises_intelligence(S, T) :- cognitive_system(S), task_criterion(S, T))).

% Passive holding is a coupling surface, not a mechanism.
claim(shared_state_when_stored_and_consumed, required,
    (shared_in(R, S) :-
        retains(X, R), component_of(X, S),
        takes_up(Y, R), component_of(Y, S))).

% Scale-relative nesting: a whole at one boundary is a mechanism at a larger one.
claim(nested_when_whole_is_mechanism, required,
    (nested_in(X, S) :- cognitive_system(X), mechanism_in(X, S))).

% Recurrence: the component that takes up a mechanism's output feeds back
% into that mechanism. It supports correction; it does not guarantee it.
claim(recurrent_when_output_returns, required,
    (recurrent_system(S) :-
        component_of(X, S), transformation(X, _, Out),
        takes_up(Y, Out), component_of(Y, S), returns_to(Y, X))).

template(component_of(X, S), [X, is, a, component, of, S]).
template(transformation(X, In, Out), [X, transforms, In, into, Out]).
template(takes_up(Y, R), [Y, takes, R, as, input]).
template(returns_to(Y, X), [Y, feeds, its, output, back, into, X]).
template(task_criterion(S, T), [S, is, given, the, task, T]).
template(retains(X, R), [X, passively, holds, R]).
template(mechanism_in(X, S), [X, serves, as, a, cognitive, transformation, mechanism, in, S]).
template(cognitive_system(S), [S, is, an, organised, cognitive, system]).
template(realises_intelligence(S, T), [S, realises, intelligence, under, the, task, T]).
template(shared_in(R, S), [R, is, a, coupling, surface, within, S]).
template(nested_in(X, S), [X, is, nested, in, S]).
template(recurrent_system(S), [S, supports, correction, through, recurrence]).
