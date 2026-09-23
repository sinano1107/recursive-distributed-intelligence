% A symmetric Claim: every p(X,Y) atom sits on a cycle with p(Y,X).
claim(sym, required, (p(X, Y) :- p(Y, X))).
template(p(X, Y), [X, pairs, with, Y]).
