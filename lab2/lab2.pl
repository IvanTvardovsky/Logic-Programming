% М8О-201Б-21 Старцев Иван

%Герман. 
%1. Дима единственный из нас, кто любит историю. 
%2. Олег и я увлекаемся одними и теми же предметами. 
%3. Мы все считаем биологию интереснейшей наукой. 
%4. Двое из нас любят и химию, и биологию. 
%Олег. 
%1. Нам всем очень нравится математика. 
%2. Герман завзятый историк. 
%3. В одном из увлечений мы расходимся с Димой. 
%4. Герман и Дима любят химию. 
%Дима. 
%1. Есть только один предмет, который любим мы все.
%2. Математикой увлекаюсь я один. 
%3. Каждый из нас любит разное сочетание дисциплин.
%4. Олег ошибается, говоря, что Герман и я увлекаемся химией. 
%Известно, что только два из утверждений каждого студента соответствуют действительности.

say(g, 1, [Ge, Ol, Di]) :- member(history, Di), not(member(history, Ge)), not(member(history, Ol)).
say(g, 2, [Ge, Ol,_]) :- joins(Ge, Ol, L), length(L, 3).
say(g, 3, [Ge, Ol, Di]) :- member(biology, Ge), member(biology, Ol), member(biology, Di).
say(g, 4, [Ge, Ol, Di]) :- fifty_fifty([Ge, Ol, Di]).

say(o, 1, [Ge, Ol, Di]) :- member(math, Ge), member(math, Ol), member(math, Di).
say(o, 2, [Ge,_,_]) :- member(history, Ge).
say(o, 3, [_, Ol, Di]) :- subtract(Ol, Di, L), length(L, 1).
say(o, 4, [Ge,_, Di]) :- member(chemistry, Ge), member(chemistry, Di).

say(d, 1, [Ge, Ol, Di]) :- joins(Ge, Ol, L1), joins(Di, L1, L2), length(L2, 1).
say(d, 2, [Ge, Ol, Di]) :- not(member(math, Ge)), not(member(math, Ol)), member(math, Di).
say(d, 3, [Ge, Ol, Di]) :- joins(Ge, Ol, L1), joins(Ge, Di, L2), joins(Di, Ol, L3),
                           length(L1, I1),length(L2, I2),length(L3, I3), I1 < 3, I2 < 3, I3 < 3.
say(d, 4, [Ge,_, Di]) :- not(say(o, 4, [Ge,_, Di])).

elems([T1, T2, L1, L2], T1, T2, L1, L2).

check(Z, V) :-
        permutation([1, 2, 3, 4], P), elems(P, T1, T2, L1, L2),
        say(Z, T1, V), say(Z, T2, V), not(say(Z, L1, V)), not(say(Z, L2, V)).

takethree([_|T], T) :- length(T, 3).
        
solve(Ger,Oleg,Dima) :-
        permutation([biology, chemistry, math, history], Ge),
        permutation([biology, chemistry, math, history], Ol),
        permutation([biology, chemistry, math, history], Di),
        takethree(Ge, Ger), takethree(Ol, Oleg), takethree(Di, Dima),
        check(g, [Ger, Oleg, Dima]), check(o, [Ger, Oleg, Dima]), check(d, [Ger, Oleg, Dima]), !.

memb(_, []) :- fail.
memb(X, [X|_]) :- !.
memb(X, [_|T]) :- memb(X, T).
 
fifty_fifty([Ger, Oleg,_]) :- member(biology, Ger), member(chemistry, Ger), member(biology, Oleg), member(chemistry, Oleg).
fifty_fifty([Ger,_, Dima]) :- member(biology, Ger), member(chemistry, Ger), member(biology, Dima), member(chemistry, Dima).
fifty_fifty([_, Oleg, Dima]) :- member(biology, Dima), member(chemistry, Dima), member(biology, Oleg), member(chemistry, Oleg).

joins([],_, []).
joins([H|T], Y, [H|R]) :- memb(H, Y), joins(T, Y, R), !.
joins([_|T], Y, R) :- joins(T, Y, R), !.

subtract([], _, []) :- !.
subtract([A|C], B, D) :- member(A, B), !, subtract(C, B, D).
subtract([A|B], C, [A|D]) :- subtract(B, C, D).