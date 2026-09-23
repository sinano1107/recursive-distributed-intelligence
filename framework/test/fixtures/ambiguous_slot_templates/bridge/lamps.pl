bridge(state_from_flipped, (state(L, S) :- flipped(L, S))).
bridge(glows_from_lit, (glows(L) :- lit(L))).
