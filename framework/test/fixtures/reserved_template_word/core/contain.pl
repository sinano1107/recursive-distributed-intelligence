claim(siblings_share_a_whole, required, (sibling(A, B) :- part_of(A, W), part_of(B, W))).
template(part_of(P, W), [P, is, part, of, W]).
% "and" is the conjunction word of the Template language
template(sibling(A, B), [A, and, B, are, siblings]).
