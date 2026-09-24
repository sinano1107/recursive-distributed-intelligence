% Observation vocabulary. DependsOn names the Claims a Phenomenon is written
% to test: each is passed through by some expected derivation, or is a Claim
% whose silence a refuse tests.
% Facts: belongs(X, S), transforms(X, In, Out), consumes(Y, Out),
%        feeds_back(Y, X), criterion(S, T), judges_under(E, T), stores(X, R).
% Observations: turns(S, In, Out), carries_out(S, T), is_mechanism(X), serves_as_mechanism(X, S),
%               cognitive_whole(X), shared_state(R, S), nested(X, S), recurrent(S),
%               recurrent_whole(S), revisable(S).

% E1: a team reviews what no member reviews; a person is not the privileged
% minimum unit. The criterion enters the working: alice takes the brief up.
phenomenon(team_reviews_what_no_member_reviews,
    [intelligence_when_organised_and_directed, directed_when_component_takes_up_criterion,
     whole_when_it_has_a_mechanism, mechanism_when_its_output_is_taken_up_in_a_directed_system],
    [belongs(alice, team), belongs(bob, team),
     transforms(alice, draft, critique), consumes(bob, critique),
     transforms(bob, critique, revision), feeds_back(bob, alice),
     criterion(team, review), consumes(alice, review)],
    [expect(carries_out(team, review)), refuse(carries_out(alice, review))]).

% E2: human + LLM + CI; no fact ascribes intelligence to any component.
phenomenon(human_llm_ci_composite,
    [intelligence_when_organised_and_directed, directed_when_component_takes_up_criterion,
     whole_when_it_has_a_mechanism, mechanism_when_its_output_is_taken_up_in_a_directed_system],
    [belongs(llm, composite), belongs(dev, composite), belongs(ci, composite),
     transforms(llm, spec, patch), consumes(dev, patch), consumes(ci, patch),
     transforms(dev, patch, verdict), transforms(ci, patch, report), consumes(dev, report),
     feeds_back(dev, llm), criterion(composite, shipping), consumes(dev, shipping)],
    [expect(carries_out(composite, shipping)), refuse(carries_out(llm, shipping))]).

% E3: nesting; the same entity is a whole at one boundary and a mechanism at
% a larger one. A criterion directs each scale: alice's recall takes up
% orientation, the team's bob takes up review. feeds_back(bob, alice) is
% there for the exclusion below.
phenomenon(person_is_whole_and_component,
    [nested_when_whole_is_mechanism, whole_when_it_has_a_mechanism,
     mechanism_when_its_output_is_taken_up_in_a_directed_system],
    [belongs(perception, alice), belongs(recall, alice),
     transforms(perception, scene, cue), consumes(recall, cue),
     transforms(recall, cue, recollection), consumes(perception, recollection),
     criterion(alice, orientation), consumes(recall, orientation),
     belongs(alice, team), belongs(bob, team),
     transforms(alice, recollection, report), consumes(bob, report),
     transforms(bob, report, decision), consumes(alice, decision), feeds_back(bob, alice),
     criterion(team, review), consumes(bob, review)],
    [expect(cognitive_whole(alice)), expect(cognitive_whole(team)),
     expect(serves_as_mechanism(alice, team)), expect(nested(alice, team))]).

% E4: a critic that adds information, and re-entry.
phenomenon(critic_in_a_studio,
    [mechanism_when_its_output_is_taken_up_in_a_directed_system, recurrent_when_output_returns,
     recurrent_cognitive_when_directed],
    [belongs(critic, studio), belongs(planner, studio),
     transforms(critic, proposal, review), consumes(planner, review),
     transforms(planner, review, proposal2), feeds_back(planner, critic),
     criterion(studio, buildability), consumes(planner, buildability)],
    [expect(serves_as_mechanism(critic, studio)), expect(recurrent(studio)),
     expect(recurrent_whole(studio))]).

% E4b: the provisional claim that a recurrent cognitive system can revise,
% tested on its own so that a failure stays pending.
phenomenon(studio_can_revise,
    [revision_when_recurrent],
    [belongs(critic, studio), belongs(planner, studio),
     transforms(critic, proposal, review), consumes(planner, review),
     transforms(planner, review, proposal2), feeds_back(planner, critic),
     criterion(studio, buildability), consumes(planner, buildability)],
    [expect(revisable(studio))]).

% R12: a generator and an adder that feed each other random numbers are
% recurrent, but nothing directs them: not a recurrent cognitive system.
phenomenon(random_adder_is_recurrent_not_cognitive,
    [recurrent_when_output_returns, recurrent_cognitive_when_directed],
    [belongs(rng, adder_pair), belongs(adder, adder_pair),
     transforms(rng, seed, number), consumes(adder, number),
     transforms(adder, number, sum), feeds_back(adder, rng)],
    [expect(recurrent(adder_pair)), refuse(recurrent_whole(adder_pair))]).
% R12b: revision is not derived for it; on its own so that a failure of the
% provisional Claim stays pending.
phenomenon(random_adder_cannot_revise,
    [revision_when_recurrent],
    [belongs(rng, adder_pair), belongs(adder, adder_pair),
     transforms(rng, seed, number), consumes(adder, number),
     transforms(adder, number, sum), feeds_back(adder, rng)],
    [refuse(revisable(adder_pair))]).

% E5: a mechanism belongs to no named system, but its taker does: the client
% transforms the translation inside a firm directed by the deal. Nobody
% transforms the reply.
phenomenon(translator_without_a_system,
    [mechanism_when_it_transforms_cognitively, cognitive_when_taken_up_into_a_directed_working,
     directed_when_component_takes_up_criterion],
    [transforms(translator, letter, translation), consumes(client, translation),
     transforms(client, translation, reply),
     belongs(client, firm), criterion(firm, deal), consumes(client, deal)],
    [expect(is_mechanism(translator)), refuse(is_mechanism(client))]).

% R1: identical uncoupled processors; more components are not better.
phenomenon(uncoupled_processors,
    [intelligence_when_organised_and_directed, whole_when_it_has_a_mechanism,
     mechanism_when_its_output_is_taken_up_in_a_directed_system],
    [belongs(p1, farm), belongs(p2, farm), belongs(p3, farm),
     transforms(p1, input, out1), transforms(p2, input, out2), transforms(p3, input, out3),
     criterion(farm, sorting), consumes(p1, sorting)],
    [refuse(cognitive_whole(farm)), refuse(carries_out(farm, sorting))]).

% R2: a filing cabinet is a coupling surface, not a mechanism. The manager
% transforms the summary; a taker that only records would not make the clerk
% a mechanism.
phenomenon(filing_cabinet_is_not_a_mechanism,
    [mechanism_when_its_output_is_taken_up_in_a_directed_system, shared_state_when_stored_and_consumed],
    [belongs(cabinet, office), belongs(clerk, office), belongs(manager, office),
     stores(cabinet, records), consumes(clerk, records),
     transforms(clerk, records, summary), consumes(manager, summary),
     transforms(manager, summary, decision),
     criterion(office, compliance), consumes(manager, compliance)],
    [expect(serves_as_mechanism(clerk, office)), expect(shared_state(records, office)),
     refuse(serves_as_mechanism(cabinet, office))]).

% R3: a transformation nobody consumes; not every transformation is cognitive.
phenomenon(unconsumed_transformation,
    [mechanism_when_its_output_is_taken_up_in_a_directed_system],
    [belongs(zip, office), belongs(clerk, office),
     transforms(zip, log, archive), criterion(office, compliance), consumes(clerk, compliance)],
    [refuse(serves_as_mechanism(zip, office))]).

% R4: coupled but under no criterion: the team transforms as a system, but
% nothing directs it, so it is not a cognitive system and realises nothing.
phenomenon(coupled_but_undirected,
    [whole_when_it_has_a_mechanism, intelligence_when_organised_and_directed,
     mechanism_when_its_output_is_taken_up_in_a_directed_system, transformation_when_components_chain],
    [belongs(alice, team), belongs(bob, team),
     transforms(alice, draft, critique), consumes(bob, critique),
     transforms(bob, critique, revision), feeds_back(bob, alice)],
    [expect(turns(team, draft, revision)), refuse(cognitive_whole(team)), refuse(carries_out(team, review))]).

% X1: the nesting derivation does not pass through recurrence.
exclusion(nesting_without_recurrence, person_is_whole_and_component,
    serves_as_mechanism(alice, team), feeds_back/2).
exclusion(nesting_without_recurrence_claim, person_is_whole_and_component,
    serves_as_mechanism(alice, team), claim(recurrent_when_output_returns)).

% E6: the one-step rule is asymmetric on purpose: a's transformation is
% cognitive because b, inside a directed system, takes it up and transforms
% it; b's is terminal here.
phenomenon(two_step_chain,
    [cognitive_when_taken_up_into_a_directed_working, mechanism_when_it_transforms_cognitively,
     directed_when_component_takes_up_criterion],
    [transforms(a, x, y), consumes(b, y), transforms(b, y, z),
     belongs(b, s), criterion(s, t), consumes(b, t)],
    [expect(is_mechanism(a)), refuse(is_mechanism(b))]).

% E7: the last transformation before action is taken up by the world. The
% boundary of the game is drawn to include the world, and the player b
% takes up winning, so the world is a component of a directed system.
phenomenon(action_taken_up_by_the_world,
    [cognitive_when_taken_up_into_a_directed_working, mechanism_when_it_transforms_cognitively,
     directed_when_component_takes_up_criterion],
    [transforms(a, x, y), consumes(b, y), transforms(b, y, move),
     consumes(world, move), transforms(world, move, position),
     belongs(b, game), belongs(world, game), criterion(game, winning), consumes(b, winning)],
    [expect(is_mechanism(b))]).

% E7b: and the world is a mechanism in the game once the player takes the
% position up and transforms it. Mechanism-hood extends to the environment
% when the boundary is drawn so.
phenomenon(world_as_mechanism_in_the_game,
    [cognitive_when_taken_up_into_a_directed_working, mechanism_when_it_transforms_cognitively,
     mechanism_when_its_output_is_taken_up_in_a_directed_system],
    [transforms(b, y, move), consumes(world, move), transforms(world, move, position),
     consumes(b, position), transforms(b, position, move2),
     belongs(b, game), belongs(world, game), criterion(game, winning), consumes(b, winning)],
    [expect(is_mechanism(world)), expect(serves_as_mechanism(world, game))]).

% E8/R5: uptake has no date. A paper read a century later was a cognitive
% transformation; one only archived was not.
phenomenon(paper_read_a_century_later,
    [cognitive_when_taken_up_into_a_directed_working, mechanism_when_it_transforms_cognitively,
     directed_when_component_takes_up_criterion],
    [transforms(author, thoughts, paper), consumes(reader, paper), transforms(reader, paper, understanding),
     belongs(reader, scholarship), criterion(scholarship, truth), consumes(reader, truth)],
    [expect(is_mechanism(author))]).
phenomenon(paper_never_read,
    [cognitive_when_taken_up_into_a_directed_working, mechanism_when_it_transforms_cognitively],
    [transforms(author, thoughts, paper), stores(archive, paper),
     belongs(archive, library), belongs(librarian, library),
     criterion(library, preservation), consumes(librarian, preservation)],
    [refuse(is_mechanism(author))]).

% E9: a work is a coupling surface across time, not a mechanism.
phenomenon(painting_as_coupling_surface,
    [shared_state_when_stored_and_consumed],
    [belongs(archive, culture), belongs(viewer, culture), stores(archive, painting),
     consumes(viewer, painting), transforms(viewer, painting, critique),
     criterion(culture, taste), consumes(viewer, taste)],
    [expect(shared_state(painting, culture)), refuse(serves_as_mechanism(archive, culture))]).

% E10: a feed-forward pipeline transforms as a system by composition (no
% fact states that it transforms) and serves as a mechanism in a larger
% directed system. Nothing directs it at its own scale, so it is not a
% cognitive system there and not a nested one: nesting is an intelligent
% whole at one scale serving as a mechanism at a larger one.
phenomenon(pipeline_as_mechanism_in_a_larger_system,
    [transformation_when_components_chain, nested_when_whole_is_mechanism,
     cognitive_when_taken_up_into_a_directed_working, mechanism_when_it_transforms_cognitively,
     mechanism_when_its_output_is_taken_up_in_a_directed_system,
     intelligence_when_organised_and_directed, directed_when_component_takes_up_criterion],
    [belongs(decoder, pipeline), belongs(checksum, pipeline),
     transforms(decoder, file, pixels), consumes(checksum, pixels), transforms(checksum, pixels, digest),
     belongs(pipeline, backup_system), belongs(verifier, backup_system),
     consumes(verifier, digest), transforms(verifier, digest, verdict),
     criterion(backup_system, safe_storage), consumes(verifier, safe_storage)],
    [expect(turns(pipeline, file, digest)), expect(is_mechanism(pipeline)),
     expect(serves_as_mechanism(pipeline, backup_system)),
     expect(carries_out(backup_system, safe_storage)),
     refuse(cognitive_whole(pipeline)), refuse(nested(pipeline, backup_system)),
     refuse(carries_out(pipeline, safe_storage))]).

% E10b: the same pipeline with its checksum taking up integrity is a
% cognitive system at its own boundary, and so nested in the backup system.
phenomenon(directed_pipeline_nested_in_a_larger_system,
    [nested_when_whole_is_mechanism, whole_when_it_has_a_mechanism,
     mechanism_when_its_output_is_taken_up_in_a_directed_system],
    [belongs(decoder, pipeline), belongs(checksum, pipeline),
     transforms(decoder, file, pixels), consumes(checksum, pixels), transforms(checksum, pixels, digest),
     criterion(pipeline, integrity), consumes(checksum, integrity),
     belongs(pipeline, backup_system), belongs(verifier, backup_system),
     consumes(verifier, digest), transforms(verifier, digest, verdict),
     criterion(backup_system, safe_storage), consumes(verifier, safe_storage)],
    [expect(cognitive_whole(pipeline)), expect(nested(pipeline, backup_system))]).

% R6/R7: the same pipeline alone transforms as a system, but nothing directs
% it: not a cognitive system, no intelligence, not recurrent.
phenomenon(pipeline_alone,
    [transformation_when_components_chain, whole_when_it_has_a_mechanism,
     intelligence_when_organised_and_directed, recurrent_when_output_returns],
    [belongs(decoder, pipeline), belongs(checksum, pipeline),
     transforms(decoder, file, pixels), consumes(checksum, pixels), transforms(checksum, pixels, digest)],
    [expect(turns(pipeline, file, digest)), refuse(cognitive_whole(pipeline)),
     refuse(carries_out(pipeline, integrity)), refuse(recurrent(pipeline))]).
phenomenon(pipeline_cannot_revise,
    [revision_when_recurrent],
    [belongs(decoder, pipeline), belongs(checksum, pipeline),
     transforms(decoder, file, pixels), consumes(checksum, pixels), transforms(checksum, pixels, digest)],
    [refuse(revisable(pipeline))]).

% R8/E11: a criterion that is only attributed does not direct the pipeline,
% so the pipeline is not even a cognitive system; a comparator that takes
% the criterion up makes it one and it realises intelligence under it.
phenomenon(pipeline_with_an_attributed_criterion,
    [intelligence_when_organised_and_directed, directed_when_component_takes_up_criterion,
     whole_when_it_has_a_mechanism],
    [belongs(decoder, pipeline), belongs(checksum, pipeline),
     transforms(decoder, file, pixels), consumes(checksum, pixels), transforms(checksum, pixels, digest),
     criterion(pipeline, integrity)],
    [refuse(cognitive_whole(pipeline)), refuse(carries_out(pipeline, integrity))]).
phenomenon(pipeline_with_a_comparator,
    [intelligence_when_organised_and_directed, directed_when_component_takes_up_criterion,
     whole_when_it_has_a_mechanism],
    [belongs(decoder, pipeline), belongs(checksum, pipeline), belongs(comparator, pipeline),
     transforms(decoder, file, pixels), consumes(checksum, pixels), transforms(checksum, pixels, digest),
     consumes(comparator, digest), transforms(comparator, digest, verdict),
     criterion(pipeline, integrity), consumes(comparator, integrity)],
    [expect(cognitive_whole(pipeline)), expect(carries_out(pipeline, integrity))]).

% E12: direction supplied from outside. No member takes the criterion up;
% an editor judging under it takes the team's revision up and replies to
% alice. The team's transformation is derived from the alice-bob chain.
phenomenon(team_directed_by_an_editor,
    [intelligence_when_organised_and_directed, directed_when_evaluator_returns,
     transformation_when_components_chain, cognitive_when_taken_up_by_an_evaluator],
    [belongs(alice, team), belongs(bob, team),
     transforms(alice, draft, critique), consumes(bob, critique),
     transforms(bob, critique, revision), feeds_back(bob, alice),
     criterion(team, publication), judges_under(editor, publication),
     consumes(editor, revision), transforms(editor, revision, notes), feeds_back(editor, alice)],
    [expect(carries_out(team, publication)), expect(is_mechanism(bob))]).

% E13: the taker may be the same component later: the self is divided
% along time. A solitary author who re-reads and reworks the draft is a
% mechanism, and the writing is a recurrent cognitive system.
phenomenon(author_rereads_own_draft,
    [cognitive_when_taken_up_into_a_directed_working, mechanism_when_it_transforms_cognitively,
     directed_when_component_takes_up_criterion,
     whole_when_it_has_a_mechanism, recurrent_when_output_returns, recurrent_cognitive_when_directed],
    [belongs(author, writing), transforms(author, thoughts, draft),
     consumes(author, draft), transforms(author, draft, revision), feeds_back(author, author),
     criterion(writing, clarity), consumes(author, clarity)],
    [expect(is_mechanism(author)), expect(cognitive_whole(writing)), expect(recurrent_whole(writing))]).

% E14: a system transforms what its chain transforms and nothing that one
% component transforms alone; the system's transformation is the integration.
phenomenon(system_transforms_only_what_its_chain_transforms,
    [transformation_when_components_chain],
    [belongs(a, box), belongs(b, box), transforms(a, x, y), consumes(b, y), transforms(b, y, z)],
    [expect(turns(box, x, z)), refuse(turns(box, x, y)), refuse(turns(box, y, z))]).

% E15: a chain of three. Only the recursive composition Claim reaches x -> w;
% the two-component base gives the sub-chains x -> z and y -> w.
phenomenon(three_step_chain,
    [transformation_composes_along_uptake, transformation_when_components_chain],
    [belongs(a, box), belongs(b, box), belongs(c, box),
     transforms(a, x, y), consumes(b, y), transforms(b, y, z), consumes(c, z), transforms(c, z, w)],
    [expect(turns(box, x, w))]).

% R9: a system whose internal taker does nothing with what it takes up is
% not a cognitive system, even if someone outside, inside a directed system
% of their own, transforms it. Organisation is integration inside the boundary.
phenomenon(taker_inside_that_does_nothing,
    [whole_when_it_has_a_mechanism, mechanism_when_its_output_is_taken_up_in_a_directed_system,
     mechanism_when_it_transforms_cognitively],
    [belongs(x, s), belongs(y, s), transforms(x, a, b), consumes(y, b),
     criterion(s, k), consumes(y, k),
     consumes(z, b), transforms(z, b, c), belongs(z, t), criterion(t, correctness), consumes(z, correctness)],
    [expect(is_mechanism(x)), refuse(serves_as_mechanism(x, s)), refuse(cognitive_whole(s))]).

% R10: an evaluator that judges under the criterion and takes the output up
% but never returns anything does not direct the team, so the team is not
% even a cognitive system.
phenomenon(team_judged_without_reply,
    [intelligence_when_organised_and_directed, directed_when_evaluator_returns,
     whole_when_it_has_a_mechanism],
    [belongs(alice, team), belongs(bob, team),
     transforms(alice, draft, critique), consumes(bob, critique),
     transforms(bob, critique, revision), feeds_back(bob, alice),
     criterion(team, publication), judges_under(editor, publication),
     consumes(editor, revision), transforms(editor, revision, notes)],
    [refuse(cognitive_whole(team)), refuse(carries_out(team, publication))]).

% R11: the weather is an uptake chain under no criterion. Nothing directs
% the sky, so the sun is not a mechanism and the sky is not a cognitive
% system, however much transforms and is taken up.
phenomenon(weather_is_not_cognitive,
    [cognitive_when_taken_up_into_a_directed_working, mechanism_when_it_transforms_cognitively,
     mechanism_when_its_output_is_taken_up_in_a_directed_system, whole_when_it_has_a_mechanism,
     transformation_when_components_chain],
    [belongs(sun, sky), belongs(cloud, sky),
     transforms(sun, water, vapour), consumes(cloud, vapour),
     transforms(cloud, vapour, rain)],
    [expect(turns(sky, water, rain)), refuse(is_mechanism(sun)), refuse(cognitive_whole(sky))]).
