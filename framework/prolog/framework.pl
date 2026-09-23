:- module(framework, [load_theory/1, check/2, explains/2]).

:- dynamic claim/4, bridge/3, phenomenon/4.

% ---- Loading a theory directory: core/, bridge/, phenomena/ -----------------

load_theory(Dir) :-
    retractall(claim(_, _, _, _)), retractall(bridge(_, _, _)),
    retractall(phenomenon(_, _, _, _)),
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
            ( phenomenon(Name, _, _, _),
              explains(Name, Derivation),
              outcome(Derivation, Outcome) ),
            Verdicts).

outcome(Derivation, inconsistent) :- memberchk(inconsistent(_, _, _), Derivation), !.
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
    once(derive(Obs, Facts, Trace)).
expectation_step(Facts, refuse(Obs), refused(Obs)) :-
    \+ derive(Obs, Facts, _).

negation(not(Obs), Obs) :- !.
negation(Obs, not(Obs)).

derive(true, _, []) :- !.
derive((A, B), Facts, Trace) :- !,
    derive(A, Facts, TA), derive(B, Facts, TB), append(TA, TB, Trace).
derive(G, Facts, [fact(G)]) :- member(G, Facts).
derive(G, Facts, [via(bridge(Name), G)|Trace]) :-
    bridge(Name, G, Body), derive(Body, Facts, Trace).
derive(G, Facts, [via(claim(Name), G)|Trace]) :-
    claim(Name, _, G, Body), derive(Body, Facts, Trace).
