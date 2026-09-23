bridge(part_from_inside, (part_of(P, W) :- inside(P, W))).
bridge(holds_from_contains, (holds(W, P) :- contains(W, P))).
