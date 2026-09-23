% Builds ever-new terms, so the closure never reaches a fixpoint.
claim(count_up, required, (num(s(N)) :- num(N))).
template(num(N), [N, is, counted]).
