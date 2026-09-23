% o(a,b) has one acyclic derivation: bridge, bridge, fact. sym is not in it.
phenomenon(pair, [sym], [f(a, b)], [expect(o(a, b))]).
exclusion(pair_without_sym, pair, o(a, b), claim(sym)).
% o(b,a) needs sym.
phenomenon(reversed_pair, [sym], [f(a, b)], [expect(o(b, a))]).
exclusion(reversed_without_sym, reversed_pair, o(b, a), claim(sym)).
