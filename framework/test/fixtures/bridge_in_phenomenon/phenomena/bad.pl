% A Bridge rule may only live in bridge/.
bridge(powered_from_connected, (powered(L) :- connected(L))).
phenomenon(kitchen_lamp, [lit_when_powered], [connected(kitchen)], [expect(lit(kitchen))]).
