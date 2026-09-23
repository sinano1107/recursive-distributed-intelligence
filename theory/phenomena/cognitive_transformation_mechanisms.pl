% Observation vocabulary.
% Facts: belongs(X, S), transforms(X, In, Out), consumes(Y, Out),
%        feeds_back(Y, X), task(S, T), judges_under(E, T), stores(X, R).
% Observations: turns(S, In, Out), carries_out(S, T), is_mechanism(X), serves_as_mechanism(X, S),
%               cognitive_whole(X), shared_state(R, S), nested(X, S), recurrent(S),
%               revisable(S).

% E1: a team reviews what no member reviews; a person is not the privileged
% minimum unit. The task enters the working: alice takes the brief up.
phenomenon(team_reviews_what_no_member_reviews,
    [intelligence_when_organised_and_directed, directed_when_component_takes_up_criterion,
     whole_when_it_has_a_mechanism, mechanism_when_its_output_is_consumed],
    [belongs(alice, team), belongs(bob, team),
     transforms(alice, draft, critique), consumes(bob, critique),
     transforms(bob, critique, revision), feeds_back(bob, alice),
     task(team, review), consumes(alice, review)],
    [expect(carries_out(team, review)), refuse(carries_out(alice, review))]).

% E2: human + LLM + CI; no fact ascribes intelligence to any component.
phenomenon(human_llm_ci_composite,
    [intelligence_when_organised_and_directed, whole_when_it_has_a_mechanism,
     mechanism_when_its_output_is_consumed],
    [belongs(llm, composite), belongs(dev, composite), belongs(ci, composite),
     transforms(llm, spec, patch), consumes(dev, patch), consumes(ci, patch),
     transforms(dev, patch, verdict), transforms(ci, patch, report), consumes(dev, report),
     feeds_back(dev, llm), task(composite, shipping), consumes(dev, shipping)],
    [expect(carries_out(composite, shipping)), refuse(carries_out(llm, shipping))]).

% E3: nesting; the same entity is a whole at one boundary and a mechanism at
% a larger one. feeds_back(bob, alice) is there for the exclusion below.
phenomenon(person_is_whole_and_component,
    [nested_when_whole_is_mechanism, whole_when_it_has_a_mechanism,
     mechanism_when_its_output_is_consumed],
    [belongs(perception, alice), belongs(recall, alice),
     transforms(perception, scene, cue), consumes(recall, cue),
     transforms(recall, cue, recollection), consumes(perception, recollection),
     belongs(alice, team), belongs(bob, team),
     transforms(alice, recollection, report), consumes(bob, report),
     transforms(bob, report, decision), consumes(alice, decision), feeds_back(bob, alice)],
    [expect(cognitive_whole(alice)), expect(cognitive_whole(team)),
     expect(serves_as_mechanism(alice, team)), expect(nested(alice, team))]).

% E5: a mechanism belongs to no named system; the client transforms the
% translation, nobody transforms the reply.
phenomenon(translator_without_a_system,
    [mechanism_when_it_transforms_cognitively, cognitive_when_taken_up_and_transformed],
    [transforms(translator, letter, translation), consumes(client, translation),
     transforms(client, translation, reply)],
    [expect(is_mechanism(translator)), refuse(is_mechanism(client))]).

% E4: a critic that adds information, and re-entry.
phenomenon(critic_in_a_design_loop,
    [mechanism_when_its_output_is_consumed, recurrent_when_output_returns],
    [belongs(critic, design_loop), belongs(planner, design_loop),
     transforms(critic, proposal, review), consumes(planner, review),
     transforms(planner, review, proposal2), feeds_back(planner, critic)],
    [expect(serves_as_mechanism(critic, design_loop)), expect(recurrent(design_loop))]).

% E4b: the provisional claim that recurrence supports revision, tested on
% its own so that a failure stays pending.
phenomenon(design_loop_can_revise,
    [revision_when_recurrent],
    [belongs(critic, design_loop), belongs(planner, design_loop),
     transforms(critic, proposal, review), consumes(planner, review),
     transforms(planner, review, proposal2), feeds_back(planner, critic)],
    [expect(revisable(design_loop))]).

% R1: identical uncoupled processors; more components are not better.
phenomenon(uncoupled_processors,
    [intelligence_when_organised_and_directed, whole_when_it_has_a_mechanism,
     mechanism_when_its_output_is_consumed],
    [belongs(p1, farm), belongs(p2, farm), belongs(p3, farm),
     transforms(p1, input, out1), transforms(p2, input, out2), transforms(p3, input, out3),
     task(farm, sorting)],
    [refuse(carries_out(farm, sorting))]).

% R2: a filing cabinet is a coupling surface, not a mechanism. The manager
% transforms the summary; a taker that only records would not make the clerk
% a mechanism.
phenomenon(filing_cabinet_is_not_a_mechanism,
    [mechanism_when_its_output_is_consumed, shared_state_when_stored_and_consumed],
    [belongs(cabinet, office), belongs(clerk, office), belongs(manager, office),
     stores(cabinet, records), consumes(clerk, records),
     transforms(clerk, records, summary), consumes(manager, summary),
     transforms(manager, summary, decision)],
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
    [whole_when_it_has_a_mechanism, intelligence_when_organised_and_directed,
     mechanism_when_its_output_is_consumed],
    [belongs(alice, team), belongs(bob, team),
     transforms(alice, draft, critique), consumes(bob, critique),
     transforms(bob, critique, revision), feeds_back(bob, alice)],
    [expect(cognitive_whole(team)), refuse(carries_out(team, review))]).

% X1: the nesting derivation does not pass through recurrence.
exclusion(nesting_without_recurrence, person_is_whole_and_component,
    serves_as_mechanism(alice, team), feeds_back/2).
exclusion(nesting_without_recurrence_claim, person_is_whole_and_component,
    serves_as_mechanism(alice, team), claim(recurrent_when_output_returns)).

% E6: the one-step rule is asymmetric on purpose: a's transformation is
% cognitive because b takes it up and transforms it; b's is terminal here.
phenomenon(two_step_chain,
    [cognitive_when_taken_up_and_transformed, mechanism_when_it_transforms_cognitively],
    [transforms(a, x, y), consumes(b, y), transforms(b, y, z)],
    [expect(is_mechanism(a)), refuse(is_mechanism(b))]).

% E7: the last transformation before action is taken up by the world.
phenomenon(action_taken_up_by_the_world,
    [cognitive_when_taken_up_and_transformed, mechanism_when_it_transforms_cognitively],
    [transforms(a, x, y), consumes(b, y), transforms(b, y, move),
     consumes(world, move), transforms(world, move, position)],
    [expect(is_mechanism(b))]).

% E8/R5: uptake has no date. A paper read a century later was a cognitive
% transformation; one only archived was not.
phenomenon(paper_read_a_century_later,
    [cognitive_when_taken_up_and_transformed, mechanism_when_it_transforms_cognitively],
    [transforms(author, thoughts, paper), consumes(reader, paper), transforms(reader, paper, understanding)],
    [expect(is_mechanism(author))]).
phenomenon(paper_never_read,
    [cognitive_when_taken_up_and_transformed, mechanism_when_it_transforms_cognitively],
    [transforms(author, thoughts, paper), stores(archive, paper)],
    [refuse(is_mechanism(author))]).

% E9: a work is a coupling surface across time, not a mechanism.
phenomenon(painting_as_coupling_surface,
    [shared_state_when_stored_and_consumed],
    [belongs(archive, culture), belongs(viewer, culture), stores(archive, painting),
     consumes(viewer, painting), transforms(viewer, painting, critique)],
    [expect(shared_state(painting, culture)), refuse(serves_as_mechanism(archive, culture))]).

% E10: a feed-forward pipeline is an organised cognitive system at its own
% boundary and, by composition, a mechanism nested in a larger one. No fact
% states that the pipeline transforms; the chain derives it.
phenomenon(pipeline_as_mechanism_in_a_larger_system,
    [transformation_of_component_is_of_system, transformation_composes_along_uptake,
     nested_when_whole_is_mechanism, intelligence_when_organised_and_directed],
    [belongs(decoder, pipeline), belongs(checksum, pipeline),
     transforms(decoder, file, pixels), consumes(checksum, pixels), transforms(checksum, pixels, digest),
     belongs(pipeline, backup_system), belongs(verifier, backup_system),
     consumes(verifier, digest), transforms(verifier, digest, verdict),
     task(backup_system, safe_storage), consumes(verifier, safe_storage)],
    [expect(turns(pipeline, file, digest)), expect(is_mechanism(pipeline)),
     expect(nested(pipeline, backup_system)), expect(carries_out(backup_system, safe_storage)),
     refuse(carries_out(pipeline, safe_storage))]).

% R6/R7: the same pipeline alone: organised, undirected, not recurrent.
phenomenon(pipeline_alone,
    [whole_when_it_has_a_mechanism, intelligence_when_organised_and_directed, recurrent_when_output_returns],
    [belongs(decoder, pipeline), belongs(checksum, pipeline),
     transforms(decoder, file, pixels), consumes(checksum, pixels), transforms(checksum, pixels, digest)],
    [expect(cognitive_whole(pipeline)), refuse(carries_out(pipeline, integrity)), refuse(recurrent(pipeline))]).
phenomenon(pipeline_cannot_revise,
    [revision_when_recurrent],
    [belongs(decoder, pipeline), belongs(checksum, pipeline),
     transforms(decoder, file, pixels), consumes(checksum, pixels), transforms(checksum, pixels, digest)],
    [refuse(revisable(pipeline))]).

% R8/E11: a task that is only a label does not direct the pipeline; a
% comparator that takes the criterion up does.
phenomenon(pipeline_with_a_label,
    [intelligence_when_organised_and_directed, directed_when_component_takes_up_criterion,
     whole_when_it_has_a_mechanism],
    [belongs(decoder, pipeline), belongs(checksum, pipeline),
     transforms(decoder, file, pixels), consumes(checksum, pixels), transforms(checksum, pixels, digest),
     task(pipeline, integrity)],
    [expect(cognitive_whole(pipeline)), refuse(carries_out(pipeline, integrity))]).
phenomenon(pipeline_with_a_comparator,
    [intelligence_when_organised_and_directed, directed_when_component_takes_up_criterion],
    [belongs(decoder, pipeline), belongs(checksum, pipeline), belongs(comparator, pipeline),
     transforms(decoder, file, pixels), consumes(checksum, pixels), transforms(checksum, pixels, digest),
     consumes(comparator, digest), transforms(comparator, digest, verdict),
     task(pipeline, integrity), consumes(comparator, integrity)],
    [expect(carries_out(pipeline, integrity))]).

% E12: direction supplied from outside. No member takes the criterion up;
% an editor judging under it takes the team's revision up and replies to
% alice. The team's transformation is derived by composition.
phenomenon(team_directed_by_an_editor,
    [intelligence_when_organised_and_directed, directed_when_evaluator_returns,
     transformation_composes_along_uptake],
    [belongs(alice, team), belongs(bob, team),
     transforms(alice, draft, critique), consumes(bob, critique),
     transforms(bob, critique, revision), feeds_back(bob, alice),
     task(team, publication), judges_under(editor, publication),
     consumes(editor, revision), transforms(editor, revision, notes), feeds_back(editor, alice)],
    [expect(carries_out(team, publication))]).
