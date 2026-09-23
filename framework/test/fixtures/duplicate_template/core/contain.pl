claim(contains_direct, required, (contains(W, P) :- part_of(P, W))).
template(contains(W, P), [W, contains, P]).
template(contains(W, P), [W, holds, P]).
template(part_of(P, W), [P, is, part, of, W]).
