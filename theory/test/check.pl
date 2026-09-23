:- prolog_load_context(directory, D), atom_concat(D, '/../../framework/prolog/framework', F), use_module(F).
:- prolog_load_context(directory, D), atom_concat(D, '/..', T), nb_setval(theory_dir, T).

:- begin_tests(theory).

% Pending is allowed: it is issued only when every dependency is provisional.
test(every_verdict_is_explains_refuses_or_pending, Bad == []) :-
    nb_getval(theory_dir, Dir),
    check(Dir, Verdicts),
    Verdicts \== [],   % check/2 returns [] for a missing directory
    exclude([verdict(_, O)]>>(O == explains ; O == refuses ; O = pending(_)), Verdicts, Bad).

:- end_tests(theory).

:- begin_tests(theory_prose).

test(every_prose_file_cites_the_core) :-
    nb_getval(theory_dir, Dir),
    atomic_list_concat([Dir, '/prose/*.md'], Pattern),
    expand_file_name(Pattern, Files),
    Files \== [],
    forall(member(F, Files), cites_core(F)).

:- end_tests(theory_prose).
