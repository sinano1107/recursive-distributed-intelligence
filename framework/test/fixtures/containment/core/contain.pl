% A toy theory about parts and wholes. Core vocabulary: part_of/2, contains/2, whole/1.
claim(contains_direct, required, (contains(W, P) :- part_of(P, W))).
claim(contains_transitive, required, (contains(W, P) :- contains(W, M), part_of(P, M))).
claim(whole_if_contains, required, (whole(W) :- contains(W, _))).

template(part_of(P, W), [P, is, part, of, W]).
template(contains(W, P), [W, contains, P]).
template(whole(W), [W, is, a, whole]).
