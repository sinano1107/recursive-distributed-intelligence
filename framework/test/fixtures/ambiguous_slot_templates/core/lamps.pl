claim(lit_when_on, required, (lit(L) :- state(L, on))).
% a slot matches any token, so "x is lit" parses as either
template(state(L, S), [L, is, S]).
template(lit(L), [L, is, lit]).
