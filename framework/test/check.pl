:- prolog_load_context(directory, D), atom_concat(D, '/../prolog/framework', F), use_module(F).
:- prolog_load_context(directory, D), atom_concat(D, '/fixtures', L), nb_setval(fixtures_dir, L).

fixture(Name, Dir) :- nb_getval(fixtures_dir, F), atomic_list_concat([F, '/', Name], Dir).

:- begin_tests(check).

test(one_verdict_per_phenomenon_explains_refuses_or_inconsistent) :-
    fixture(lamps, Dir),
    check(Dir, Verdicts),
    memberchk(verdict(kitchen_lamp_on, explains), Verdicts),
    memberchk(verdict(hall_lamp_unplugged, refuses), Verdicts),
    memberchk(verdict(flickering_lamp, inconsistent), Verdicts).

:- end_tests(check).
