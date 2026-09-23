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
    forall(theory_term(Dir, phenomena, T, File), store_phenomenon(T, File)),
    validate_connectivity,
    validate_templates.

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

% Nothing may resolve to nothing: a Claim body goal must be a Claim or
% Bridge head; a Bridge body goal must be one of those or a fact some
% Phenomenon states; a Phenomenon fact must be read by some Bridge rule.
% (This also rules out built-ins in bodies.) not/1 is looked through.
validate_connectivity :-
    forall(( claim(Name, _, _, Body), body_goal(Body, G), \+ head_functor(G) ),
           unresolved(G, claim(Name))),
    forall(( bridge(Name, _, Body), body_goal(Body, G),
             \+ head_functor(G), \+ fact_functor(G) ),
           unresolved(G, bridge(Name))),
    forall(( phenomenon(Name, _, Facts, _), member(F, Facts), \+ read_by_bridge(F) ),
           unresolved(F, phenomenon(Name))).

% Templates: no reserved word, no two Templates with the same word pattern,
% and exactly one Template per Core vocabulary item.
validate_templates :-
    forall(( template(Head, Words), member(W, Words), nonvar(W), reserved_word(W) ),
           ( goal_functor(Head, FA), throw(theory_error(reserved_word(W, FA))) )),
    findall(FA-Shape, ( template(Head, Words), goal_functor(Head, FA),
                        copy_term(Words, Shape), term_variables(Shape, Vs),
                        maplist(=(slot), Vs) ), Shapes),
    forall(( member(FA1-S1, Shapes), member(FA2-S2, Shapes), FA1 @< FA2, S1 == S2 ),
           throw(theory_error(ambiguous_templates(FA1, FA2)))),
    forall(( setof(FA, core_vocabulary(FA), FAs), member(F/A, FAs),
             aggregate_all(count, ( template(Head, _), functor(Head, F, A) ), N),
             N \== 1 ),
           ( N == 0 -> throw(theory_error(missing_template(F/A)))
           ; throw(theory_error(duplicate_template(F/A))) )).

unresolved(Goal, Where) :-
    goal_functor(Goal, FA),
    throw(theory_error(unresolved(FA, Where))).

goal_functor(not(G), FA) :- !, goal_functor(G, FA).
goal_functor(G, F/A) :- functor(G, F, A).

head_functor(G) :-
    goal_functor(G, FA),
    ( claim(_, _, Head, _) ; bridge(_, Head, _) ),
    goal_functor(Head, FA), !.
fact_functor(G) :-
    goal_functor(G, FA),
    phenomenon(_, _, Facts, _), member(F, Facts),
    goal_functor(F, FA), !.
read_by_bridge(F) :-
    goal_functor(F, FA),
    bridge(_, _, Body), body_goal(Body, G),
    goal_functor(G, FA), !.

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
    softenable(Reason),
    Dependencies \== [],
    forall(member(D, Dependencies), claim(D, provisional, _, _)), !.
status_outcome(_, Outcome, Outcome).

softenable(underivable(_)).
softenable(unexpected(_)).

% An Exclusion test is violated when any Derivation of Obs passes through
% the excluded Claim (claim(Name)) or vocabulary item (Functor/Arity).
exclusion_outcome(Obs, Facts, Excluded, Outcome) :-
    closure(Facts, Closure, Completeness),
    (   derived(Closure, Obs, _, Items), memberchk(Excluded, Items)
    ->  Outcome = violates(Excluded)
    ;   Completeness == depth_exceeded
    ->  Outcome = failed(depth_exceeded(Obs))
    ;   Outcome = explains
    ).

outcome(Derivation, inconsistent) :- memberchk(inconsistent(_, _, _), Derivation), !.
outcome(Derivation, failed(depth_exceeded(Obs))) :- memberchk(depth_exceeded(Obs), Derivation), !.
outcome(Derivation, failed(vacuous(Obs))) :- memberchk(vacuous(Obs, _), Derivation), !.
outcome(Derivation, failed(underivable(Obs))) :- memberchk(underivable(Obs), Derivation), !.
outcome(Derivation, failed(unexpected(Obs))) :- memberchk(unexpected(Obs, _), Derivation), !.
outcome(Derivation, refuses) :- forall(member(S, Derivation), S = refused(_)), !.
outcome(_, explains).

% ---- Derivation: bottom-up closure of Core + Bridge rules over the Facts --
%
% closure(Facts, Closure): Closure holds d(Atom, Trace, Items) for every
% ground atom derivable from the Facts: one Derivation trace (the first
% found, nested; flatten/2 gives the step list) and the set of every Claim,
% Bridge rule and vocabulary item that occurs in any derivation of it.
% Iteration k adds the atoms of derivation depth k, so a theory without
% function symbols always reaches a fixpoint and refusals are exact. The
% depth bound is only a safety net for theories that build ever-new terms;
% hitting it makes every verdict of the Phenomenon depth_exceeded, never a
% clean refuses/explains.
% ponytail: max_depth(100) keeps the pathological case fast with the naive
% list closure; raise it (and index the closure) if a Phenomenon needs deeper chains.

max_depth(100).

explains(Phenomenon, Derivation) :-
    phenomenon(Phenomenon, Dependencies, Facts, Expectations),
    closure(Facts, Closure, Completeness),
    maplist(expectation_step(Closure, Completeness, Dependencies), Expectations, Derivation).

% Negation convention: not(Obs) is the declared negation of Obs in
% Observation vocabulary. A Phenomenon is inconsistent when both derive.
expectation_step(Closure, _, _, Expectation, inconsistent(Obs, Trace, NegTrace)) :-
    arg(1, Expectation, Obs),
    negation(Obs, Neg),
    derived(Closure, Obs, Trace, _),
    derived(Closure, Neg, NegTrace, _), !.
expectation_step(_, depth_exceeded, _, Expectation, depth_exceeded(Obs)) :- !,
    arg(1, Expectation, Obs).
% An expected Observation whose derivations pass through none of the
% Claims the Phenomenon depends on is vacuous (a trivialising Bridge rule
% or a fact restating the Observation), not explained.
expectation_step(Closure, _, Dependencies, expect(Obs), Step) :-
    derived(Closure, Obs, Trace, Items), !,
    (   member(D, Dependencies), memberchk(claim(D), Items)
    ->  Step = derived(Obs, Trace)
    ;   Step = vacuous(Obs, Trace)
    ).
expectation_step(_, _, _, expect(Obs), underivable(Obs)).
expectation_step(Closure, _, _, refuse(Obs), unexpected(Obs, Trace)) :-
    derived(Closure, Obs, Trace, _), !.
expectation_step(_, _, _, refuse(Obs), refused(Obs)).

negation(not(Obs), Obs) :- !.
negation(Obs, not(Obs)).

derived(Closure, Obs, Trace, Items) :-
    member(d(Obs, Nested, Items), Closure), !,
    flatten(Nested, Trace).

closure(Facts, Closure, Completeness) :-
    findall(d(F, [fact(F)], [Fun/Ar]),
            ( member(F, Facts), functor(F, Fun, Ar) ), Init),
    iterate(Init, 0, Closure, Completeness).

iterate(C0, Depth, C, Completeness) :-
    findall(New, instance(C0, New), News),
    foldl(merge, News, C0-false, C1-Changed),
    (   Changed == false -> C = C1, Completeness = complete
    ;   max_depth(Max), Depth >= Max -> C = C1, Completeness = depth_exceeded
    ;   Depth1 is Depth + 1, iterate(C1, Depth1, C, Completeness)
    ).

% One application of a rule to atoms already in the closure. An atom that
% is already known contributes only its Items; its Trace is never rebuilt.
instance(C, d(Head, Trace, Items)) :-
    rule(Name, Head, Body),
    body_instance(Body, C, BodyTrace, BodyItems),
    functor(Head, F, A),
    list_to_ord_set([Name, F/A], Own),
    ord_union(Own, BodyItems, Items),
    (   memberchk(d(Head, _, _), C)
    ->  Trace = known
    ;   Trace = [via(Name, Head), BodyTrace]
    ).

rule(claim(Name), Head, Body) :- claim(Name, Status, Head, Body), Status \== untested.
rule(bridge(Name), Head, Body) :- bridge(Name, Head, Body).

body_instance(true, _, [], []) :- !.
body_instance((A, B), C, [TA, TB], Items) :- !,
    body_instance(A, C, TA, IA),
    body_instance(B, C, TB, IB),
    ord_union(IA, IB, Items).
body_instance(Goal, C, Trace, Items) :- member(d(Goal, Trace, Items), C).

merge(d(Head, Trace, Items), C0-Changed0, C-Changed) :-
    (   select(d(Head, Trace0, Items0), C0, Rest)
    ->  ord_union(Items0, Items, Items1),
        (   Items1 == Items0
        ->  C = C0, Changed = Changed0
        ;   C = [d(Head, Trace0, Items1)|Rest], Changed = true
        )
    ;   C = [d(Head, Trace, Items)|C0], Changed = true
    ).

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
