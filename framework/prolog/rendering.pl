:- module(rendering, [render/2, parse/2, template/2, reserved_word/1]).

% Rendering: a Claim (Head :- Body) or a Core term becomes one English
% sentence built from one Template per Core vocabulary item. parse/2 is
% the exact inverse over that template language and nothing else.
%
% Template language: template(Head, Words) where Words is a list of atoms;
% variables in Words are argument slots. Arguments are atoms (one token
% each, never a single capital letter); nested terms are not supported.
% '$VAR'(N) renders as the capital letter A+N, so numbervars'd Claims
% round-trip too.  ponytail: 26 variables per Claim; extend var_name/2 if
% a Claim ever needs more.

:- dynamic template/2.

render(Term, English) :-
    phrase(sentence(Term), Words), !,
    atomic_list_concat(Words, ' ', Body),
    string_concat(Body, ".", English).

parse(English, Term) :-
    string_concat(Body, ".", English),
    split_string(Body, " ", "", Strings),
    maplist(atom_string, Words, Strings),
    phrase(sentence(Term), Words), !.

sentence((Head :- Body)) --> term(Head), [if], conjunction(Body).
sentence(Term) --> term(Term).

conjunction((A, B)) --> term(A), [and], conjunction(B).
conjunction(A) --> term(A).

term(Term) -->
    { template(Head, Pattern), mark_slots(Pattern, Marked), Head = Term },
    words(Marked).

mark_slots([], []).
mark_slots([X|Xs], [slot(X)|Ys]) :- var(X), !, mark_slots(Xs, Ys).
mark_slots([X|Xs], [X|Ys]) :- mark_slots(Xs, Ys).

words([]) --> [].
words([slot(V)|Ws]) --> !, argument(V), words(Ws).
words([W|Ws]) --> [W], words(Ws).

argument('$VAR'(N)) --> [W], { var_name(N, W) }.
argument(A) --> [A], { atom(A), \+ var_name(_, A) }.

% Words the Template language keeps for itself.
reserved_word(if).
reserved_word(and).
reserved_word(W) :- atom(W), var_name(_, W).

var_name(N, W) :- integer(N), !, C is 0'A + N, char_code(W, C).
var_name(N, W) :- atom(W), atom_length(W, 1), char_code(W, C),
    C >= 0'A, C =< 0'Z, N is C - 0'A.
