% A toy theory about lamps. Core vocabulary: powered/1, plugged/1, switch/2, lit/1.
claim(powered_when_plugged, required, (powered(L) :- plugged(L))).
claim(lit_when_powered_and_on, required, (lit(L) :- powered(L), switch(L, on))).
claim(dark_when_off, required, (dark(L) :- switch(L, off))).
claim(lit_when_bright_room, provisional, (lit(L) :- in_bright_room(L))).
claim(lit_by_magic, untested, (lit(L) :- magic(L))).

% Templates: one per Core vocabulary item. Variables are argument slots.
template(powered(L), [L, has, power]).
template(plugged(L), [L, is, plugged, in]).
template(switch(L, P), [the, switch, of, L, is, P]).
template(lit(L), [L, is, lit]).
template(dark(L), [L, is, dark]).
template(in_bright_room(L), [L, is, in, a, bright, room]).
template(magic(L), [L, is, magic]).
