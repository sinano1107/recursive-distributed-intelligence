% Each Bridge rule maps one Observation functor to one Core functor.
% Facts into the Core.
bridge(component_from_belongs, (component_of(X, S) :- belongs(X, S))).
bridge(transformation_from_transforms, (transformation(X, In, Out) :- transforms(X, In, Out))).
bridge(consumed_from_consumes, (consumed_by(Y, R) :- consumes(Y, R))).
bridge(returns_from_feeds_back, (returns_to(Y, X) :- feeds_back(Y, X))).
bridge(criterion_from_task, (task_criterion(S, T) :- task(S, T))).
bridge(held_from_stores, (held_by(X, R) :- stores(X, R))).
% Core out to Observations.
bridge(capable_from_capable_of, (capable(S, T) :- capable_of(S, T))).
bridge(mechanism_from_mechanism_in, (serves_as_mechanism(X, S) :- mechanism_in(X, S))).
bridge(whole_from_cognitive_system, (cognitive_whole(S) :- cognitive_system(S))).
bridge(shared_state_from_shared_in, (shared_state(R, S) :- shared_in(R, S))).
bridge(self_correcting_from_system, (self_correcting(S) :- self_correcting_system(S))).
