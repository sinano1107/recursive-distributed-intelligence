bridge(part_from_inside, (part_of(P, W) :- inside(P, W))).
bridge(kin_from_sibling, (kin(A, B) :- sibling(A, B))).
