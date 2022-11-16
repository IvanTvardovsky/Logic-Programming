% М8О-201Б-21 Старцев Иван

swap([e, w, w], X) :- X = [w, e, w].
swap([e, w, b], X) :- X = [w, e, b].
swap([e, b, w], X) :- X = [w, b, e].

swap([w, b, e], X) :- X = [w, e, b].
swap([w, e, w], X) :- X = [w, w, e].

swap([b, e, w], X) :- X = [b, w, e]; X = [e, b, w].
swap([b, e, b], X) :- X = [e, b, b].
swap([b, b, e], X) :- X = [b, e, b].
swap([b, w, e], X) :- X = [e, w, b].


changePosition(Start, Finish) :- append(X, [A, B, C|T], Start), swap([A, B, C], G), append(X, G, H), append(H, T, Finish).

checkPath([X|T], [Y, X|T]) :- changePosition(X, Y), not(member(Y, [X|T])).

path(X, Y, P) :- bfs([[X]], Y, P), write(P).

bfs([[X|T]|_], X, [X|T]).
bfs([P|QW], X, R) :- findall(Z, checkPath(P, Z), T), append(QW, T, QE), !, bfs(QE, X, R).
bfs([_|T], Y, L) :- bfs(T, Y, L).

shortest(X, Y, P) :- counter(N), shortest(X, Y, P, N), !, write(P).
shortest(X, Y, P, N) :- continue([X], Y, P, N).

counter(1).
counter(N) :- counter(M), N is M+1.

continue([X|T], X, [X|T],_).
continue(X, Y, P, N) :- N>0, checkPath(X, ZXC), N1 is N-1, continue(ZXC, Y, P, N1).

time_bfs(X, Y, Time) :- get_time(Start), shortest(X, Y, _), get_time(End), Time is End - Start.

time_shortest(X, Y, Time) :- get_time(Start), path(X, Y, _), get_time(End), Time is End - Start.