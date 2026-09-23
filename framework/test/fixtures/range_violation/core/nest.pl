% W occurs in the head only: the Claim says every W is a whole, which no
% ground closure can enumerate.
claim(everything_whole, required, (whole(W) :- part_of(gear, engine))).
template(whole(W), [W, is, a, whole]).
template(part_of(P, W), [P, is, part, of, W]).
