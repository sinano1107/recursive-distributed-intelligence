:- module(rendering, [render/2, parse/2, template/2, reserved_word/1]).

% Rendering: a Claim (Head :- Body) or a Core term becomes one English
% sentence built from one Template per Core vocabulary item. parse/2 is
% the exact inverse over that template language and nothing else.
%
% Template language: template(Head, Words) where Words is a list of atoms;
% variables in Words are argument slots. Arguments are atoms of one token
% (no whitespace, not a reserved word); anything else is a domain_error.
% Variables render as the capital letters A, B, ... and parse back to fresh
% variables, so render/parse are inverses up to variable renaming (=@=).
% ponytail: 26 variables per Claim; extend var_name/2 if one ever needs more.

:- use_module(library(varnumbers)).

:- dynamic template/2.

render(Term, English) :-
    copy_term(Term, Numbered),
    numbervars(Numbered, 0, _),
    phrase(sentence(Numbered), Words), !,
    atomic_list_concat(Words, ' ', Body),
    string_concat(Body, ".", English).

parse(English, Term) :-
    string_concat(Body, ".", English),
    split_string(Body, " ", "", Strings),
    maplist(atom_string, Words, Strings),
    phrase(sentence(Numbered), Words), !,
    varnumbers(Numbered, Term).

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

argument(A) --> { nonvar(A) }, !, { argument_word(A, W) }, [W].
argument(A) --> [W], { \+ reserved_word(W) -> A = W ; var_name(N, W), A = '$VAR'(N) }.

argument_word('$VAR'(N), W) :- !, var_name(N, W).
argument_word(A, A) :-
    atom(A), A \== '', \+ reserved_word(A),
    \+ ( atom_codes(A, Codes), member(C, Codes), code_type(C, space) ), !.
argument_word(A, _) :- domain_error(template_argument, A).

% Words the Template language keeps for itself.
reserved_word(if).
reserved_word(and).
reserved_word(W) :- atom(W), var_name(_, W).

var_name(N, W) :- integer(N), !, C is 0'A + N, char_code(W, C).
var_name(N, W) :- atom(W), atom_length(W, 1), char_code(W, C),
    C >= 0'A, C =< 0'Z, N is C - 0'A.
