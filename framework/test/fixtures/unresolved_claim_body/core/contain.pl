% A built-in in a Claim body resolves to nothing and would silently never derive.
claim(sibling_rule, required, (sibling(A, B) :- part_of(A, W), part_of(B, W), A \== B)).
