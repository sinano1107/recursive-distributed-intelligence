% Observation vocabulary: connected/1, flipped/2, glows/1.
bridge(plugged_from_connected, (plugged(L) :- connected(L))).
bridge(switch_from_flipped, (switch(L, P) :- flipped(L, P))).
bridge(glows_from_lit, (glows(L) :- lit(L))).
bridge(not_glows_from_dark, (not(glows(L)) :- dark(L))).
bridge(magic_from_enchanted, (magic(L) :- enchanted(L))).
% a cheating Bridge rule that bypasses the Core entirely
bridge(cheat, (glows_cheaply(L) :- connected(L))).
