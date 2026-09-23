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

test(exclusion_test_explains_when_no_derivation_passes_through_the_excluded_item) :-
    fixture(lamps, Dir),
    check(Dir, Verdicts),
    memberchk(verdict(glows_without_dark, explains), Verdicts).

test(exclusion_test_names_the_violated_claim_or_vocabulary_item) :-
    fixture(lamps, Dir),
    check(Dir, Verdicts),
    memberchk(verdict(glows_without_power, violates(powered/1)), Verdicts),
    memberchk(verdict(glows_without_plugged_claim, violates(claim(powered_when_plugged))), Verdicts).

test(required_claim_fails_the_check_when_a_dependent_test_fails) :-
    fixture(lamps, Dir),
    check(Dir, Verdicts),
    memberchk(verdict(shed_lamp_never_switched, failed(underivable(glows(shed)))), Verdicts),
    memberchk(verdict(hall_lamp_plugged_and_on, failed(unexpected(glows(hall)))), Verdicts).

test(provisional_claim_leaves_a_failing_test_pending) :-
    fixture(lamps, Dir),
    check(Dir, Verdicts),
    memberchk(verdict(sunny_porch_lamp, explains), Verdicts),
    memberchk(verdict(dim_porch_lamp, pending(underivable(glows(porch)))), Verdicts).

test(untested_claim_is_excluded_from_the_core_and_its_tests_from_the_verdicts) :-
    fixture(lamps, Dir),
    check(Dir, Verdicts),
    \+ memberchk(verdict(enchanted_attic_lamp, _), Verdicts),
    memberchk(verdict(enchanted_attic_lamp_by_power, failed(underivable(glows(attic)))), Verdicts).

test(phenomenon_using_core_vocabulary_is_a_load_error,
     throws(theory_error(core_vocabulary_in_phenomenon(powered/1, _)))) :-
    fixture(core_vocabulary_in_phenomenon, Dir),
    check(Dir, _).

test(bridge_rule_inside_a_phenomenon_file_is_a_load_error,
     throws(theory_error(misplaced(bridge, _)))) :-
    fixture(bridge_in_phenomenon, Dir),
    check(Dir, _).

test(recursive_claims_terminate_with_exact_refusal_and_exclusion, timeout(10)) :-
    fixture(nesting, Dir),
    check(Dir, Verdicts),
    memberchk(verdict(gear_in_engine_in_car, explains), Verdicts),
    memberchk(verdict(tooth_in_gear_in_engine_in_car, explains), Verdicts),
    memberchk(verdict(car_is_unit, explains), Verdicts),
    memberchk(verdict(gear_holds_nothing, refuses), Verdicts),
    memberchk(verdict(nesting_without_whole, explains), Verdicts).

test(depth_bound_hit_during_a_refusal_or_exclusion_is_a_distinct_failure, timeout(30)) :-
    fixture(non_terminating, Dir),
    check(Dir, Verdicts),
    Verdicts == [verdict(never_finishes, failed(depth_exceeded(finished(never)))),
                 verdict(never_finishes_without_count, failed(depth_exceeded(finished(never))))].

test(derivation_through_no_dependent_claim_is_vacuous_and_never_pending) :-
    fixture(lamps, Dir),
    check(Dir, Verdicts),
    memberchk(verdict(cheap_glow, failed(vacuous(glows_cheaply(kitchen)))), Verdicts),
    memberchk(verdict(cheap_glow_provisional, failed(vacuous(glows_cheaply(kitchen)))), Verdicts).

test(claim_body_goal_that_is_no_claim_or_bridge_head_is_a_load_error,
     throws(theory_error(unresolved((\==)/2, claim(sibling_rule))))) :-
    fixture(unresolved_claim_body, Dir),
    check(Dir, _).

test(bridge_body_goal_that_is_no_head_and_no_stated_fact_is_a_load_error,
     throws(theory_error(unresolved(insid/2, bridge(part_from_inside))))) :-
    fixture(unresolved_bridge_body, Dir),
    check(Dir, _).

test(phenomenon_fact_read_by_no_bridge_rule_is_a_load_error,
     throws(theory_error(unresolved(holds/2, phenomenon(fact_is_observation))))) :-
    fixture(unresolved_phenomenon_fact, Dir),
    check(Dir, _).

test(two_templates_with_the_same_word_pattern_are_a_load_error,
     throws(theory_error(ambiguous_templates(adores/2, likes/2)))) :-
    fixture(ambiguous_templates, Dir),
    check(Dir, _).

test(template_word_that_is_reserved_by_the_template_language_is_a_load_error,
     throws(theory_error(reserved_word(and, sibling/2)))) :-
    fixture(reserved_template_word, Dir),
    check(Dir, _).

test(core_vocabulary_item_without_a_template_is_a_load_error,
     throws(theory_error(missing_template(part_of/2)))) :-
    fixture(missing_template, Dir),
    check(Dir, _).

test(core_vocabulary_item_with_two_templates_is_a_load_error,
     throws(theory_error(duplicate_template(contains/2)))) :-
    fixture(duplicate_template, Dir),
    check(Dir, _).

:- end_tests(check).
