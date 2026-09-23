:- module(framework, [load_theory/1, check/2, explains/2, cites_core/1]).
:- use_module(library(dcg/basics)).
:- reexport(rendering).

:- dynamic claim/4, bridge/3, phenomenon/4, exclusion/4.

% ---- Loading a theory directory: core/, bridge/, phenomena/ -----------------

load_theory(Dir) :-
    retractall(claim(_, _, _, _)), retractall(bridge(_, _, _)),
    retractall(phenomenon(_, _, _, _)), retractall(exclusion(_, _, _, _)),
    retractall(template(_, _)),
    forall(theory_term(Dir, core, T, _), store_core(T)),
    forall(theory_term(Dir, bridge, T, _), store_bridge(T)),
    forall(theory_term(Dir, phenomena, T, File), store_phenomenon(T, File)).

% Each directory accepts only its own kinds of term.
allowed(core, claim). allowed(core, template). allowed(bridge, bridge).
allowed(phenomena, phenomenon). allowed(phenomena, exclusion).

theory_term(Dir, Sub, Term, File) :-
    atomic_list_concat([Dir, '/', Sub, '/*.pl'], Pattern),
    expand_file_name(Pattern, Files),
    member(File, Files),
    read_file_to_terms(File, Terms, []),
    member(Term, Terms),
    functor(Term, Kind, _),
    (   allowed(Sub, Kind) -> true
    ;   throw(theory_error(misplaced(Kind, File)))
    ).

store_core(claim(Name, Status, Clause)) :-
    head_body(Clause, H, B), assertz(claim(Name, Status, H, B)).
store_core(template(Head, Words)) :- assertz(template(Head, Words)).

store_bridge(bridge(Name, Clause)) :-
    head_body(Clause, H, B), assertz(bridge(Name, H, B)).

% Observation vocabulary must be disjoint from Core vocabulary: no fact or
% expected Observation of a Phenomenon may use a functor that occurs in a Claim.
store_phenomenon(phenomenon(Name, Deps, Facts, Expectations), File) :-
    forall(( member(Fact, Facts)
           ; member(E, Expectations), arg(1, E, Fact) ),
           observation_only(Fact, File)),
    assertz(phenomenon(Name, Deps, Facts, Expectations)).
store_phenomenon(Exclusion, _) :- assertz(Exclusion).

observation_only(not(Obs), File) :- !, observation_only(Obs, File).
observation_only(Obs, File) :-
    functor(Obs, F, A),
    (   core_vocabulary(F/A)
    ->  throw(theory_error(core_vocabulary_in_phenomenon(F/A, File)))
    ;   true
    ).

core_vocabulary(F/A) :-
    claim(_, _, Head, Body),
    body_goal((Head, Body), Goal),
    functor(Goal, F, A).

body_goal((A, B), G) :- !, ( body_goal(A, G) ; body_goal(B, G) ).
body_goal(true, _) :- !, fail.
body_goal(G, G).

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
    member(Step, Trace), step_goal(Step, Goal), functor(Goal, F, A), !.

step_goal(fact(Goal), Goal).
step_goal(via(_, Goal), Goal).

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

% ---- Prose shell: every substantive sentence cites a Claim ---------------
%
% Prose files are Markdown under <theory>/prose/. A Citation is [[claim_name]].
% Headings are ignored; the rest is split into sentences at . ! and ?.
% A sentence is substantive when it contains a letter. Meaning is never
% checked, only that each substantive sentence cites at least one Claim
% that exists in the Core.

cites_core(ProseFile) :-
    file_directory_name(ProseFile, ProseDir),
    file_directory_name(ProseDir, Dir),
    load_theory(Dir),
    read_file_to_string(ProseFile, Text, []),
    split_string(Text, "\n", "", Lines),
    exclude([L]>>string_concat("#", _, L), Lines, Body),
    atomic_list_concat(Body, ' ', Joined),
    split_string(Joined, ".!?", " \t", Sentences),
    forall(( member(S, Sentences), substantive(S) ), cited(S, ProseFile)).

substantive(Sentence) :-
    string_code(_, Sentence, C), code_type(C, alpha), !.

cited(Sentence, File) :-
    string_codes(Sentence, Codes),
    phrase(citations(Names), Codes),
    (   Names == []
    ->  print_message(error, format("~w: no Citation in: ~s", [File, Sentence])), fail
    ;   forall(member(N, Names), known_claim(N, File))
    ).

known_claim(Name, _) :- claim(Name, _, _, _), !.
known_claim(Name, File) :-
    print_message(error, format("~w: Citation of unknown Claim ~w", [File, Name])), fail.

citations([Name|Names]) -->
    string(_), "[[", string(Codes), "]]", !,
    { atom_codes(Name, Codes) }, citations(Names).
citations([]) --> remainder(_).
