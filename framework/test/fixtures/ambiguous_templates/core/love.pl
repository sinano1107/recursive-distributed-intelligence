claim(adoring_is_liking, required, (likes(X, Y) :- adores(X, Y))).
% two Templates with the same word pattern: parse/2 could not tell them apart
template(likes(X, Y), [X, loves, Y]).
template(adores(X, Y), [X, loves, Y]).
