% A toy theory about lamps. Core vocabulary: powered/1, plugged/1, switch/2, lit/1.
claim(powered_when_plugged, required, (powered(L) :- plugged(L))).
claim(lit_when_powered_and_on, required, (lit(L) :- powered(L), switch(L, on))).
claim(dark_when_off, required, (dark(L) :- switch(L, off))).
