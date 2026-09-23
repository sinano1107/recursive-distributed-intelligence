claim(contains_direct, required, (contains(W, P) :- part_of(P, W))).
template(contains(W, P), [W, contains, P]).
