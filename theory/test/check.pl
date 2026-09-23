:- prolog_load_context(directory, D), atom_concat(D, '/../../framework/prolog/framework', F), use_module(F).
:- prolog_load_context(directory, D), atom_concat(D, '/..', T), nb_setval(theory_dir, T).

:- begin_tests(theory).

% Pending is allowed: it is issued only when every dependency is provisional.
test(every_phenomenon_and_exclusion_passes, Bad == []) :-
    nb_getval(theory_dir, Dir),
    check(Dir, Verdicts),
    exclude([verdict(_, O)]>>(O == explains ; O == refuses ; O = pending(_)), Verdicts, Bad).

:- end_tests(theory).
