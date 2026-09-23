:- prolog_load_context(directory, D), atom_concat(D, '/../prolog/framework', F), use_module(F).
:- prolog_load_context(directory, D), atom_concat(D, '/fixtures/lamps', L), nb_setval(lamps_dir, L).

:- begin_tests(explains, [setup((nb_getval(lamps_dir, L), load_theory(L)))]).

test(derivation_passes_through_bridge_rules_and_claims) :-
    explains(kitchen_lamp_on, Derivation),
    Derivation == [derived(glows(kitchen),
                     [via(bridge(glows_from_lit), glows(kitchen)),
                      via(claim(lit_when_powered_and_on), lit(kitchen)),
                      via(claim(powered_when_plugged), powered(kitchen)),
                      via(bridge(plugged_from_connected), plugged(kitchen)),
                      fact(connected(kitchen)),
                      via(bridge(switch_from_flipped), switch(kitchen, on)),
                      fact(flipped(kitchen, on))])].

test(refusal_when_expected_observation_is_not_derivable) :-
    explains(hall_lamp_unplugged, Derivation),
    Derivation == [refused(glows(hall))].

test(inconsistent_when_an_observation_and_its_negation_both_derive) :-
    explains(flickering_lamp, [inconsistent(glows(cellar), Trace, NegTrace)]),
    memberchk(via(claim(lit_when_powered_and_on), _), Trace),
    memberchk(via(claim(dark_when_off), _), NegTrace).

:- end_tests(explains).
