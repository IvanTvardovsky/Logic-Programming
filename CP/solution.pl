% Task 2

% TOP SECRET

% Task 3: i. Шурин

shurin(Husband, Shurin) :-
    wife(Husband, Wife),
    sibling(Wife, Shurin).

% Task 4

wife(Husband, Wife) :-
    father(Husband, Child),
    mother(Wife, Child).

sibling(Person, Sibling) :-
    father(Father, Person),
    mother(Mother, Person),
    father(Father, Sibling),
    mother(Mother, Sibling).

child(Adult, Child) :-
    (father(Adult, Child); mother(Adult, Child)).

check(shurin, Husband, Shurin) :- shurin(Husband, Shurin).
check(husband, Wife, Husband) :- wife(Husband, Wife).
check(wife, Husband, Wife) :- wife(Wife, Husband).
check(father, Father, Child) :- father(Father, Child).
check(mother, Mother, Child) :- mother(Mother, Child).
check(child, Adult, Child) :- child(Adult, Child).
check(sibling, Person, Sibling) :- sibling(Person, Sibling).

next(X, Z) :- child(X, Z).
next(X, Z) :- child(Z, X).
next(X, Z) :- sibling(X, Z).

counter(1).
counter(M) :- counter(N), (N < 5 -> M is N + 1; !, fail).

search(Path, X, Y, N) :- N = 1, check(A, X, Y), Path = [A].
search(Path, X, Y, N) :- N > 1, next(X, Z), N1 is N-1, search(Res, Z, Y, N1), check(B, X, Z), append([B], Res, Path).

relative(Res, X, Y) :- var(Res), counter(N), N < 6,  search(Res, X, Y, N), Y \= X.
relative(Res, X, Y) :- nonvar(Res), length(Res, N), search(Res, X, Y, N), Y \= X.
