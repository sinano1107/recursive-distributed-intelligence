:- module(framework, [load_theory/1, check/2, explains/2, cites_core/1]).
:- use_module(library(dcg/basics)).
:- reexport(rendering, [render/2, parse/2]).

:- dynamic claim/4, bridge/3, phenomenon/4, exclusion/4.

% ---- Loading a theory directory: core/, bridge/, phenomena/ -----------------

load_theory(Dir) :-
    retractall(claim(_, _, _, _)), retractall(bridge(_, _, _)),
    retractall(phenomenon(_, _, _, _)), retractall(exclusion(_, _, _, _)),
    retractall(rendering:template(_, _)),
    forall(theory_term(Dir, core, T, Names, _), store_core(T, Names)),
    forall(theory_term(Dir, bridge, T, Names, _), store_bridge(T, Names)),
    forall(theory_term(Dir, phenomena, T, _, File), store_phenomenon(T, File)),
    validate_exclusions,
    validate_connectivity,
    validate_templates.

% Each directory accepts only its own kinds of term.
allowed(core, claim). allowed(core, template). allowed(bridge, bridge).
allowed(phenomena, phenomenon). allowed(phenomena, exclusion).

theory_term(Dir, Sub, Term, VarNames, File) :-
    atomic_list_concat([Dir, '/', Sub, '/*.pl'], Pattern),
    expand_file_name(Pattern, Files),
    member(File, Files),
    setup_call_cleanup(open(File, read, In), read_terms(In, Terms), close(In)),
    member(Term-VarNames, Terms),
    functor(Term, Kind, _),
    (   allowed(Sub, Kind) -> true
    ;   throw(theory_error(misplaced(Kind, File)))
    ).

read_terms(In, Terms) :-
    read_term(In, Term, [variable_names(VarNames)]),
    (   Term == end_of_file -> Terms = []
    ;   Terms = [Term-VarNames|Rest], read_terms(In, Rest)
    ).

store_core(claim(Name, Status, Clause), VarNames) :-
    head_body(Clause, H, B), valid_clause(H, B, VarNames, claim(Name)),
    assertz(claim(Name, Status, H, B)).
store_core(template(Head, Words), _) :- assertz(rendering:template(Head, Words)).

store_bridge(bridge(Name, Clause), VarNames) :-
    head_body(Clause, H, B), valid_clause(H, B, VarNames, bridge(Name)),
    assertz(bridge(Name, H, B)).

head_body((H :- B), H, B) :- !.
head_body(H, H, true).

% A clause is range restricted (every head variable occurs in the body, or
% the ground closure could not enumerate the atoms it stands for), has no
% variable as a goal, and no not/1 in its body (the closure never evaluates
% negation; not/1 is legal only as a Bridge head and in Observations).
valid_clause(Head, Body, VarNames, Where) :-
    term_variables(Head, HeadVars), term_variables(Body, BodyVars),
    (   member(V, HeadVars), \+ ( member(BV, BodyVars), BV == V )
    ->  ( member(Name=V0, VarNames), V0 == V -> true ; Name = '_' ),
        throw(theory_error(range_violation(Name, Where)))
    ;   true
    ),
    forall(body_goal((Head, Body), G),
           ( goal_functor(G, _) -> true ; throw(theory_error(variable_goal(Where))) )),
    forall(( body_goal(Body, G), nonvar(G), G = not(_) ),
           throw(theory_error(negation_in_body(Where)))).

body_goal(G, G) :- var(G), !.
body_goal((A, B), G) :- !, ( body_goal(A, G) ; body_goal(B, G) ).
body_goal(true, _) :- !, fail.
body_goal(G, G).

% Observation vocabulary must be disjoint from Core vocabulary: no fact or
% Observation of a Phenomenon or Exclusion test may use a functor that
% occurs in a Claim. Facts and Observations must be ground.
store_phenomenon(phenomenon(Name, Deps, Facts, Expectations), File) :-
    forall(( member(Fact, Facts)
           ; member(E, Expectations), arg(1, E, Fact) ),
           ( ground(Fact) -> observation_only(Fact, File)
           ; throw(theory_error(non_ground(Fact, phenomenon(Name)))) )),
    assertz(phenomenon(Name, Deps, Facts, Expectations)).
store_phenomenon(exclusion(Name, Phenomenon, Obs, Excluded), File) :-
    observation_only(Obs, File),
    assertz(exclusion(Name, Phenomenon, Obs, Excluded)).

observation_only(Obs, File) :-
    goal_functor(Obs, F/A),
    (   core_vocabulary(F/A)
    ->  throw(theory_error(core_vocabulary_in_phenomenon(F/A, File)))
    ;   true
    ).

core_vocabulary(F/A) :-
    claim(_, _, Head, Body),
    body_goal((Head, Body), Goal),
    functor(Goal, F, A).

goal_functor(G, _) :- var(G), !, fail.
goal_functor(not(G), FA) :- !, goal_functor(G, FA).
goal_functor(G, F/A) :- functor(G, F, A).

% An Exclusion test must name a Phenomenon, a Claim or a vocabulary item
% that exists.
validate_exclusions :-
    forall(( exclusion(Name, Phenomenon, _, _), \+ phenomenon(Phenomenon, _, _, _) ),
           throw(theory_error(unresolved(phenomenon(Phenomenon), exclusion(Name))))),
    forall(( exclusion(Name, _, _, claim(Claim)), \+ claim(Claim, _, _, _) ),
           throw(theory_error(unresolved(claim(Claim), exclusion(Name))))),
    forall(( exclusion(Name, _, _, F/A), \+ occurs(F/A) ),
           throw(theory_error(unresolved(F/A, exclusion(Name))))).

occurs(FA) :-
    (   ( claim(_, _, Head, Body) ; bridge(_, Head, Body) ), body_goal((Head, Body), G)
    ;   phenomenon(_, _, Facts, _), member(G, Facts)
    ),
    goal_functor(G, FA), !.

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

unresolved(Goal, Where) :-
    goal_functor(Goal, FA),
    throw(theory_error(unresolved(FA, Where))).

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

% Templates: no reserved word, no two Templates whose word patterns can
% match the same sentence (a slot matches any token), and exactly one
% Template per Core vocabulary item.
validate_templates :-
    forall(( rendering:template(Head, Words), member(W, Words), nonvar(W),
             rendering:reserved_word(W) ),
           ( goal_functor(Head, FA), throw(theory_error(reserved_word(W, FA))) )),
    findall(FA-Shape, ( rendering:template(Head, Words), goal_functor(Head, FA),
                        copy_term(Words, Shape), term_variables(Shape, Vs),
                        maplist(=(slot), Vs) ), Shapes),
    forall(( member(FA1-S1, Shapes), member(FA2-S2, Shapes), FA1 @< FA2,
             maplist(overlapping_word, S1, S2) ),
           throw(theory_error(ambiguous_templates(FA1, FA2)))),
    forall(( setof(FA, core_vocabulary(FA), FAs), member(F/A, FAs),
             aggregate_all(count, ( rendering:template(Head, _), functor(Head, F, A) ), N),
             N \== 1 ),
           ( N == 0 -> throw(theory_error(missing_template(F/A)))
           ; throw(theory_error(duplicate_template(F/A))) )).

overlapping_word(slot, _) :- !.
overlapping_word(_, slot) :- !.
overlapping_word(W, W).

% ---- Checking: one Verdict per test -----------------------------------------

check(Dir, Verdicts) :-
    load_theory(Dir),
    findall(verdict(Name, Outcome),
            ( verdict_of(Name, Dependencies, Raw),
              status_outcome(Dependencies, Raw, Outcome) ),
            Verdicts).

verdict_of(Name, Dependencies, Outcome) :-
    phenomenon(Name, Dependencies, _, _),
    explains(Name, Derivation),
    outcome(Derivation, Outcome).
verdict_of(Name, Dependencies, Outcome) :-
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

% An Exclusion test is violated when some acyclic derivation of Obs passes
% through the excluded Claim (claim(Name)) or vocabulary item (Functor/Arity).
exclusion_outcome(Obs, Facts, Excluded, Outcome) :-
    closure(Facts, closure(Atoms, Completeness)),
    (   memberchk(Obs, Atoms),
        derivation(Obs, Facts, Atoms, Trace),
        passes_through(Trace, Excluded)
    ->  Outcome = violates(Excluded)
    ;   Completeness == depth_exceeded
    ->  Outcome = failed(depth_exceeded(Obs))
    ;   Outcome = explains
    ).

passes_through(Trace, claim(Name)) :- memberchk(via(claim(Name), _), Trace).
passes_through(Trace, F/A) :-
    member(Step, Trace), step_goal(Step, Goal), functor(Goal, F, A), !.

step_goal(fact(Goal), Goal).
step_goal(via(_, Goal), Goal).

outcome(Derivation, inconsistent) :- memberchk(inconsistent(_, _, _), Derivation), !.
outcome(Derivation, failed(depth_exceeded(Obs))) :- memberchk(depth_exceeded(Obs), Derivation), !.
outcome(Derivation, failed(vacuous(Obs))) :- memberchk(vacuous(Obs, _), Derivation), !.
outcome(Derivation, failed(underivable(Obs))) :- memberchk(underivable(Obs), Derivation), !.
outcome(Derivation, failed(unexpected(Obs))) :- memberchk(unexpected(Obs, _), Derivation), !.
outcome(Derivation, refuses) :- forall(member(S, Derivation), S = refused(_)), !.
outcome(_, explains).

% ---- Derivation --------------------------------------------------------------
%
% Two questions, answered separately. Whether an atom is derivable is
% decided by the bottom-up closure of Core + Bridge rules over the Facts
% (closure/2): the exact truth set for a theory without function symbols.
% Iteration k adds the atoms of derivation depth k, so the depth bound is
% only a safety net for theories that build ever-new terms; hitting it
% makes every expectation of the Phenomenon depth_exceeded, except an
% inconsistency already proven within the settled part of the closure.
% Which Claims and vocabulary a derivation passes through is answered by
% enumerating the acyclic derivations of an atom top-down over that
% closure (derivation/4): goals are ground there, so the identical-ancestor
% check is exact and the enumeration terminates.
% ponytail: max_depth(100) keeps the pathological case fast with the naive
% list closure; raise it (and index the closure) if a Phenomenon needs deeper chains.

max_depth(100).

explains(Phenomenon, Derivation) :-
    phenomenon(Phenomenon, Dependencies, Facts, Expectations),
    closure(Facts, Closure),
    maplist(expectation_step(Closure, Facts, Dependencies), Expectations, Derivation).

% Negation convention: not(Obs) is the declared negation of Obs in
% Observation vocabulary. A Phenomenon is inconsistent when both derive.
expectation_step(closure(Atoms, _), Facts, _, Expectation, inconsistent(Obs, Trace, NegTrace)) :-
    arg(1, Expectation, Obs),
    negation(Obs, Neg),
    memberchk(Obs, Atoms), memberchk(Neg, Atoms), !,
    once(derivation(Obs, Facts, Atoms, Trace)),
    once(derivation(Neg, Facts, Atoms, NegTrace)).
expectation_step(closure(_, depth_exceeded), _, _, Expectation, depth_exceeded(Obs)) :- !,
    arg(1, Expectation, Obs).
% An expected Observation with no acyclic derivation through a Claim the
% Phenomenon depends on is vacuous (a trivialising Bridge rule or a fact
% restating the Observation), not explained.
expectation_step(closure(Atoms, _), Facts, Dependencies, expect(Obs), Step) :-
    memberchk(Obs, Atoms), !,
    (   derivation(Obs, Facts, Atoms, Trace),
        member(D, Dependencies), passes_through(Trace, claim(D))
    ->  Step = derived(Obs, Trace)
    ;   once(derivation(Obs, Facts, Atoms, Trace)),
        Step = vacuous(Obs, Trace)
    ).
expectation_step(_, _, _, expect(Obs), underivable(Obs)).
expectation_step(closure(Atoms, _), Facts, _, refuse(Obs), unexpected(Obs, Trace)) :-
    memberchk(Obs, Atoms), !,
    once(derivation(Obs, Facts, Atoms, Trace)).
expectation_step(_, _, _, refuse(Obs), refused(Obs)).

negation(not(Obs), Obs) :- !.
negation(Obs, not(Obs)).

closure(Facts, closure(Atoms, Completeness)) :-
    grow(Facts, 0, Atoms, Completeness).

grow(Atoms0, Depth, Atoms, Completeness) :-
    findall(Head, ( rule(_, Head, Body), body_holds(Body, Atoms0),
                    \+ memberchk(Head, Atoms0) ), New0),
    sort(New0, New),
    (   New == [] -> Atoms = Atoms0, Completeness = complete
    ;   max_depth(Max), Depth >= Max -> Atoms = Atoms0, Completeness = depth_exceeded
    ;   append(New, Atoms0, Atoms1), Depth1 is Depth + 1,
        grow(Atoms1, Depth1, Atoms, Completeness)
    ).

rule(claim(Name), Head, Body) :- claim(Name, Status, Head, Body), Status \== untested.
rule(bridge(Name), Head, Body) :- bridge(Name, Head, Body).

body_holds(true, _) :- !.
body_holds((A, B), Atoms) :- !, body_holds(A, Atoms), body_holds(B, Atoms).
body_holds(Goal, Atoms) :- member(Goal, Atoms).

% derivation(+Atom, +Facts, +Atoms, -Trace): on backtracking, every acyclic
% derivation of the ground Atom whose goals all lie in the closure Atoms.
% Trace lists the steps in pre-order: via(claim(N), G), via(bridge(N), G), fact(G).
derivation(Atom, Facts, Atoms, Trace) :-
    derivation(Atom, Facts, Atoms, [], Nested),
    flatten(Nested, Trace).

derivation(Atom, Facts, _, _, [fact(Atom)]) :- memberchk(Atom, Facts).
derivation(Atom, Facts, Atoms, Ancestors, [via(Name, Atom), BodyTrace]) :-
    rule(Name, Atom, Body),
    derive_body(Body, Facts, Atoms, [Atom|Ancestors], BodyTrace).

derive_body(true, _, _, _, []) :- !.
derive_body((A, B), Facts, Atoms, Ancestors, [TA, TB]) :- !,
    derive_body(A, Facts, Atoms, Ancestors, TA),
    derive_body(B, Facts, Atoms, Ancestors, TB).
derive_body(Goal, Facts, Atoms, Ancestors, Trace) :-
    member(Goal, Atoms),
    \+ ( member(Ancestor, Ancestors), Ancestor == Goal ),
    derivation(Goal, Facts, Atoms, Ancestors, Trace).

% ---- Prose shell: every substantive sentence cites a Claim ---------------
%
% Prose files are Markdown under <theory>/prose/. A Citation is [[claim_name]].
% Headings are ignored; the rest is split into sentences: . ! or ? ends
% one only at the end of the text or before whitespace and a character
% that is not a lowercase letter, so "e.g. a gear" stays in its sentence.
% A sentence is substantive when it contains a letter. Meaning is never
% checked, only that each substantive sentence cites a Claim in the Core.

cites_core(ProseFile) :-
    file_directory_name(ProseFile, ProseDir),
    file_directory_name(ProseDir, Dir),
    load_theory(Dir),
    read_file_to_string(ProseFile, Text, []),
    split_string(Text, "\n", "", Lines),
    exclude([L]>>string_concat("#", _, L), Lines, Body),
    atomic_list_concat(Body, ' ', Joined),
    string_codes(Joined, Codes),
    phrase(sentences(Sentences), Codes),
    forall(( member(S, Sentences), substantive(S) ), cited(S, ProseFile)).

sentences([S|Ss]) --> sentence(Codes), { Codes \== [] }, !,
    { string_codes(S0, Codes), normalize_space(string(S), S0) }, sentences(Ss).
sentences([]) --> [].

sentence([]) --> [C], { memberchk(C, `.!?`) }, \+ \+ ends_sentence, !.
sentence([C|Cs]) --> [C], !, sentence(Cs).
sentence([]) --> [].

ends_sentence --> blanks, eos.
ends_sentence --> blank, blanks, [L], { \+ code_type(L, lower) }.

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
