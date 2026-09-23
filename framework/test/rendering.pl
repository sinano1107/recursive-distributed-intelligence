:- prolog_load_context(directory, D), atom_concat(D, '/../prolog/framework', F), use_module(F).
:- prolog_load_context(directory, D), atom_concat(D, '/fixtures/lamps', L), nb_setval(lamps_dir, L).

:- begin_tests(rendering, [setup((nb_getval(lamps_dir, L), load_theory(L)))]).

test(render_then_parse_is_the_identity_over_the_template_language) :-
    Claim = (lit(kitchen) :- powered(kitchen), switch(kitchen, on)),
    render(Claim, English),
    English == "kitchen is lit if kitchen has power and the switch of kitchen is on.",
    parse(English, Parsed),
    Parsed == Claim.

test(round_trip_of_a_claim_as_stored_with_unbound_variables) :-
    Claim = (dark(L) :- switch(L, off)),
    render(Claim, English),
    English == "A is dark if the switch of A is off.",
    parse(English, Parsed),
    Parsed =@= Claim.

test(argument_that_is_not_one_token_is_an_error,
     throws(error(domain_error(template_argument, 'big lamp'), _))) :-
    render(lit('big lamp'), _).

test(number_argument_is_an_error,
     throws(error(domain_error(template_argument, 7), _))) :-
    render(lit(7), _).

test(parse_never_accepts_free_prose, fail) :-
    parse("the kitchen lamp is lit because somebody switched it on.", _).

:- end_tests(rendering).
