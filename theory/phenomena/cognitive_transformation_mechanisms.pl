% Observation vocabulary.
% Facts: belongs(X, S), transforms(X, In, Out), consumes(Y, Out),
%        feeds_back(Y, X), task(S, T), stores(X, R).
% Observations: capable(S, T), serves_as_mechanism(X, S), cognitive_whole(X),
%               shared_state(R, S), self_correcting(S).

% E1: a team reviews what no member reviews; a person is not the privileged
% minimum unit.
phenomenon(team_reviews_what_no_member_reviews,
    [capable_when_organised_and_tasked, whole_when_it_has_a_mechanism,
     mechanism_when_its_output_is_consumed],
    [belongs(alice, team), belongs(bob, team),
     transforms(alice, draft, critique), consumes(bob, critique),
     transforms(bob, critique, revision), feeds_back(bob, alice),
     task(team, review)],
    [expect(capable(team, review)), refuse(capable(alice, review))]).

% E2: human + LLM + CI; no fact ascribes intelligence to any component.
phenomenon(human_llm_ci_composite,
    [capable_when_organised_and_tasked, whole_when_it_has_a_mechanism,
     mechanism_when_its_output_is_consumed],
    [belongs(llm, composite), belongs(dev, composite), belongs(ci, composite),
     transforms(llm, spec, patch), consumes(dev, patch), consumes(ci, patch),
     transforms(dev, patch, verdict), transforms(ci, patch, report), consumes(dev, report),
     feeds_back(dev, llm), task(composite, shipping)],
    [expect(capable(composite, shipping)), refuse(capable(llm, shipping))]).

% E3: nesting; the same entity is a whole at one boundary and a mechanism at
% a larger one. feeds_back(bob, alice) is there for the exclusion below.
phenomenon(person_is_whole_and_component,
    [whole_when_it_has_a_mechanism, mechanism_when_its_output_is_consumed],
    [belongs(perception, alice), belongs(recall, alice),
     transforms(perception, scene, cue), consumes(recall, cue),
     transforms(recall, cue, recollection), consumes(perception, recollection),
     belongs(alice, team), belongs(bob, team),
     transforms(alice, recollection, report), consumes(bob, report),
     transforms(bob, report, decision), consumes(alice, decision), feeds_back(bob, alice)],
    [expect(cognitive_whole(alice)), expect(cognitive_whole(team)),
     expect(serves_as_mechanism(alice, team))]).

% E4: a critic that adds information, and re-entry.
phenomenon(critic_in_a_design_loop,
    [mechanism_when_its_output_is_consumed, self_correcting_when_output_returns],
    [belongs(critic, design_loop), belongs(planner, design_loop),
     transforms(critic, proposal, review), consumes(planner, review),
     transforms(planner, review, proposal2), feeds_back(planner, critic)],
    [expect(serves_as_mechanism(critic, design_loop)), expect(self_correcting(design_loop))]).

% R1: identical uncoupled processors; more components are not better.
phenomenon(uncoupled_processors,
    [capable_when_organised_and_tasked, whole_when_it_has_a_mechanism,
     mechanism_when_its_output_is_consumed],
    [belongs(p1, farm), belongs(p2, farm), belongs(p3, farm),
     transforms(p1, input, out1), transforms(p2, input, out2), transforms(p3, input, out3),
     task(farm, sorting)],
    [refuse(capable(farm, sorting))]).

% R2: a filing cabinet is a coupling surface, not a mechanism.
phenomenon(filing_cabinet_is_not_a_mechanism,
    [mechanism_when_its_output_is_consumed, shared_state_when_stored_and_consumed],
    [belongs(cabinet, office), belongs(clerk, office), belongs(manager, office),
     stores(cabinet, records), consumes(clerk, records),
     transforms(clerk, records, summary), consumes(manager, summary)],
    [expect(serves_as_mechanism(clerk, office)), expect(shared_state(records, office)),
     refuse(serves_as_mechanism(cabinet, office))]).

% R3: a transformation nobody consumes; not every transformation is cognitive.
phenomenon(unconsumed_transformation,
    [mechanism_when_its_output_is_consumed],
    [belongs(zip, office), belongs(clerk, office),
     transforms(zip, log, archive)],
    [refuse(serves_as_mechanism(zip, office))]).

% R4: coupled but no task; direction is supplied from outside.
phenomenon(coupled_but_undirected,
    [whole_when_it_has_a_mechanism, capable_when_organised_and_tasked,
     mechanism_when_its_output_is_consumed],
    [belongs(alice, team), belongs(bob, team),
     transforms(alice, draft, critique), consumes(bob, critique),
     transforms(bob, critique, revision), feeds_back(bob, alice)],
    [expect(cognitive_whole(team)), refuse(capable(team, review))]).

% X1: the nesting derivation does not pass through recurrence.
exclusion(nesting_without_recurrence, person_is_whole_and_component,
    serves_as_mechanism(alice, team), feeds_back/2).
exclusion(nesting_without_recurrence_claim, person_is_whole_and_component,
    serves_as_mechanism(alice, team), claim(self_correcting_when_output_returns)).
