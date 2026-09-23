bridge(num_from_counted, (num(N) :- counted(N))).
bridge(finished_from_num, (finished(N) :- num(N))).
