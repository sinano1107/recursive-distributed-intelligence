:- prolog_load_context(directory, D), atom_concat(D, '/../prolog/framework', F), use_module(F).
:- prolog_load_context(directory, D), atom_concat(D, '/fixtures', L), nb_setval(fixtures_dir, L).

prose(Name, File) :- prose(lamps, Name, File).
prose(Theory, Name, File) :-
    nb_getval(fixtures_dir, D), atomic_list_concat([D, '/', Theory, '/prose/', Name], File).

:- begin_tests(cites_core).

test(prose_whose_every_sentence_cites_a_claim_passes) :-
    prose('lamps.md', File),
    cites_core(File).

test(substantive_sentence_without_a_citation_fails, fail) :-
    prose('uncited.md', File),
    cites_core(File).

test(citation_of_a_claim_not_in_the_core_fails, fail) :-
    prose('unknown-claim.md', File),
    cites_core(File).

test(abbreviation_before_a_lowercase_word_is_not_a_sentence_boundary) :-
    prose(nesting, 'nest.md', File),
    cites_core(File).

:- end_tests(cites_core).
