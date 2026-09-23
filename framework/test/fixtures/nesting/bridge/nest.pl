% Observation vocabulary: inside/2, holds/2, unit/1.
bridge(part_from_inside, (part_of(P, W) :- inside(P, W))).
bridge(holds_from_contains, (holds(W, P) :- contains(W, P))).
bridge(unit_from_whole, (unit(W) :- whole(W))).
