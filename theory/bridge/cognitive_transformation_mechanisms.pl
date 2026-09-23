% Each Bridge rule connects one Observation functor to one Core functor.
% Facts into the Core.
bridge(component_from_belongs, (component_of(X, S) :- belongs(X, S))).
bridge(transformation_from_transforms, (transformation(X, In, Out) :- transforms(X, In, Out))).
bridge(takes_up_from_consumes, (takes_up(Y, R) :- consumes(Y, R))).
bridge(returns_from_feeds_back, (returns_to(Y, X) :- feeds_back(Y, X))).
bridge(criterion_from_task, (task_criterion(S, T) :- task(S, T))).
bridge(retains_from_stores, (retains(X, R) :- stores(X, R))).
bridge(evaluator_from_judges_under, (evaluator_of(E, T) :- judges_under(E, T))).
% Core out to Observations.
bridge(turns_from_transformation, (turns(S, In, Out) :- transformation(S, In, Out))).
bridge(carries_out_from_realises_intelligence, (carries_out(S, T) :- realises_intelligence(S, T))).
bridge(is_mechanism_from_mechanism, (is_mechanism(X) :- mechanism(X))).
bridge(mechanism_from_mechanism_in, (serves_as_mechanism(X, S) :- mechanism_in(X, S))).
bridge(whole_from_cognitive_system, (cognitive_whole(S) :- cognitive_system(S))).
bridge(shared_state_from_shared_in, (shared_state(R, S) :- shared_in(R, S))).
bridge(nested_from_nested_in, (nested(X, S) :- nested_in(X, S))).
bridge(recurrent_from_recurrent_system, (recurrent(S) :- recurrent_system(S))).
bridge(revisable_from_can_revise, (revisable(S) :- can_revise(S))).
