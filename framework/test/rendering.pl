:- prolog_load_context(directory, D), atom_concat(D, '/../prolog/framework', F), use_module(F).
:- prolog_load_context(directory, D), atom_concat(D, '/fixtures/lamps', L), nb_setval(lamps_dir, L).

:- begin_tests(rendering, [setup((nb_getval(lamps_dir, L), load_theory(L)))]).

test(render_then_parse_is_the_identity_over_the_template_language) :-
    Claim = (lit(kitchen) :- powered(kitchen), switch(kitchen, on)),
    render(Claim, English),
    English == "kitchen is lit if kitchen has power and the switch of kitchen is on.",
    parse(English, Parsed),
    Parsed == Claim.

test(round_trip_of_a_claim_with_variables) :-
    Claim = (dark('$VAR'(0)) :- switch('$VAR'(0), off)),
    render(Claim, English),
    English == "A is dark if the switch of A is off.",
    parse(English, Parsed),
    Parsed == Claim.

test(parse_never_accepts_free_prose, fail) :-
    parse("the kitchen lamp is lit because somebody switched it on.", _).

:- end_tests(rendering).
