% М8О-201Б-21 Старцев Иван
% Первая часть задания - предикаты работы со списками

mylen([], 0).
mylen([_|T], Z) :- mylen(T, Z1), Z is Z1 + 1.
% ?-mylen([1, 2, 3, 4], V).

mymember(H, [H|_]) :- !.
mymember(H, [_|T]) :- mymember(H, T).
% ?-mymember(3, [1, 2, 3, 4]).

myremove(X, [X|T], T).
myremove(X, [Y|T], [Y|T1]) :- myremove(X, T, T1).
% ?-myremove(3, [1, 2, 3, 4], V).

myappend([], L, L).
myappend([H|T], L, [H|TFin]) :- myappend(T, L, TFin).
% ?-myappend([1, 2, 3, 4], [0, 6], V).

mypermute([], []).
mypermute(L, [X|T]) :- myremove(X, L, L1), mypermute(L1, T).
% ?-mypermute([a, b, c], V).
% убираем голову, рекурсивно вызываем для оставшихся элементов в списке

mysublist([], []).
mysublist([H|L1], [H|L2]) :- mysublist(L1, L2).
mysublist(H, [_|L2]) :- mysublist(H, L2).
% ?-mysublist([1, 4], [1, 2, 3, 4]). 
% разбиваем на числа, рекурсивно проверяем для каждого элемента

% Удаление трех последних элементов

% На основе стандартных предикатов обработки списков
delete_three_last(_, [], 3).
delete_three_last(X1, X2) :- mylen(X1, D), delete_three_last(X1, X2, D), !.
delete_three_last([H|T1], [H|T2], D) :- D1 is D - 1, delete_three_last(T1, T2, D1).
% ?- delete_three_last([1, 2, 3, 4], X).

% Без их использования
delete_three_last_n2([_, _, _], []).
delete_three_last_n2([H|T1], [H|T2]) :- delete_three_last_n2(T1, T2).

% Вторая часть задания
% Проверка упорядоченности элементов по возрастанию

% На основе стандартных предикатов обработки списков
check_order([_]) :- !.
check_order([X, Y|T]) :- X < Y, !, check_order([Y|T]).

% Без их использования
unsorted_std(L) :- myappend(_, [X, Y|_], L), X > Y.
check_order_n2(L) :- not(unsorted_std(L)).

% Пример использования
permute_sort(X, Y) :- mypermute(X, Y), check_order(Y).