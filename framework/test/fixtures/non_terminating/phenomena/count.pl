phenomenon(never_finishes, [count_up], [counted(zero)], [refuse(finished(never))]).
exclusion(never_finishes_without_count, never_finishes, finished(never), claim(count_up)).
