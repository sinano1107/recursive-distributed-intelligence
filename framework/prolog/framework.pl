:- module(framework, [load_theory/1, check/2, explains/2]).

:- dynamic claim/4, bridge/3, phenomenon/4, exclusion/4.

% ---- Loading a theory directory: core/, bridge/, phenomena/ -----------------

load_theory(Dir) :-
    retractall(claim(_, _, _, _)), retractall(bridge(_, _, _)),
    retractall(phenomenon(_, _, _, _)), retractall(exclusion(_, _, _, _)),
    forall(theory_term(Dir, core, T), store_core(T)),
    forall(theory_term(Dir, bridge, T), store_bridge(T)),
    forall(theory_term(Dir, phenomena, T), assertz(T)).

theory_term(Dir, Sub, Term) :-
    atomic_list_concat([Dir, '/', Sub, '/*.pl'], Pattern),
    expand_file_name(Pattern, Files),
    member(File, Files),
    read_file_to_terms(File, Terms, []),
    member(Term, Terms).

store_core(claim(Name, Status, Clause)) :-
    head_body(Clause, H, B), assertz(claim(Name, Status, H, B)).

store_bridge(bridge(Name, Clause)) :-
    head_body(Clause, H, B), assertz(bridge(Name, H, B)).

head_body((H :- B), H, B) :- !.
head_body(H, H, true).

% ---- Checking: one Verdict per test -----------------------------------------

check(Dir, Verdicts) :-
    load_theory(Dir),
    findall(verdict(Name, Outcome),
            ( test(Name, Dependencies, Raw),
              status_outcome(Dependencies, Raw, Outcome) ),
            Verdicts).

test(Name, Dependencies, Outcome) :-
    phenomenon(Name, Dependencies, _, _),
    explains(Name, Derivation),
    outcome(Derivation, Outcome).
test(Name, Dependencies, Outcome) :-
    exclusion(Name, Phenomenon, Obs, Excluded),
    phenomenon(Phenomenon, Dependencies, Facts, _),
    exclusion_outcome(Obs, Facts, Excluded, Outcome).

% Status: a test depending on an untested Claim is excluded (no Verdict).
% A failing test depending only on provisional Claims is pending; one
% depending on a required (or not yet written) Claim is failed.
status_outcome(Dependencies, _, _) :-
    member(D, Dependencies), claim(D, untested, _, _), !, fail.
status_outcome(Dependencies, failed(Reason), pending(Reason)) :-
    Dependencies \== [],
    forall(member(D, Dependencies), claim(D, provisional, _, _)), !.
status_outcome(_, Outcome, Outcome).

% An Exclusion test is violated when any Derivation of Obs passes through
% the excluded Claim (claim(Name)) or vocabulary item (Functor/Arity).
exclusion_outcome(Obs, Facts, Excluded, violates(Excluded)) :-
    derive(Obs, Facts, Trace),
    passes_through(Trace, Excluded), !.
exclusion_outcome(_, _, _, explains).

passes_through(Trace, claim(Name)) :- memberchk(via(claim(Name), _), Trace).
passes_through(Trace, F/A) :-
    member(Step, Trace), arg(_, Step, Goal), compound(Goal), functor(Goal, F, A), !.

outcome(Derivation, inconsistent) :- memberchk(inconsistent(_, _, _), Derivation), !.
outcome(Derivation, failed(underivable(Obs))) :- memberchk(underivable(Obs), Derivation), !.
outcome(Derivation, failed(unexpected(Obs))) :- memberchk(unexpected(Obs, _), Derivation), !.
outcome(Derivation, refuses) :- forall(member(S, Derivation), S = refused(_)), !.
outcome(_, explains).

% ---- Derivation: a meta-interpreter over Core + Bridge + Facts ------------

explains(Phenomenon, Derivation) :-
    phenomenon(Phenomenon, _, Facts, Expectations),
    maplist(expectation_step(Facts), Expectations, Derivation).

% Negation convention: not(Obs) is the declared negation of Obs in
% Observation vocabulary. A Phenomenon is inconsistent when both derive.
expectation_step(Facts, Expectation, inconsistent(Obs, Trace, NegTrace)) :-
    arg(1, Expectation, Obs),
    negation(Obs, Neg),
    once(derive(Obs, Facts, Trace)),
    once(derive(Neg, Facts, NegTrace)), !.
expectation_step(Facts, expect(Obs), derived(Obs, Trace)) :-
    once(derive(Obs, Facts, Trace)), !.
expectation_step(_, expect(Obs), underivable(Obs)).
expectation_step(Facts, refuse(Obs), unexpected(Obs, Trace)) :-
    once(derive(Obs, Facts, Trace)), !.
expectation_step(_, refuse(Obs), refused(Obs)).

negation(not(Obs), Obs) :- !.
negation(Obs, not(Obs)).

derive(true, _, []) :- !.
derive((A, B), Facts, Trace) :- !,
    derive(A, Facts, TA), derive(B, Facts, TB), append(TA, TB, Trace).
derive(G, Facts, [fact(G)]) :- member(G, Facts).
derive(G, Facts, [via(bridge(Name), G)|Trace]) :-
    bridge(Name, G, Body), derive(Body, Facts, Trace).
derive(G, Facts, [via(claim(Name), G)|Trace]) :-
    claim(Name, Status, G, Body), Status \== untested,
    derive(Body, Facts, Trace).
