% М8О-201Б-21 Старцев Иван
% Вторая часть задания - реляционное представление предметной области
% Вариант 2

:- include("data.pl").

average(Subj, X) :-
	bagof(Mark, Gr^St^grade(Gr, St, Subj, Mark), Res),
	sum_list(Res, Sum), length(Res, N),
	X is Sum / N.

n_passed_gr(Gr, X) :-
	setof(St, Subj^grade(Gr, St, Subj, 2), Res),
	length(Res, X).

n_passed_subj(Subj, X) :-
	bagof(St, Gr^grade(Gr, St, Subj, 2), Res),
	length(Res, X).