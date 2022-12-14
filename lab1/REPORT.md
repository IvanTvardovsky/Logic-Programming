# Отчет по лабораторной работе №1
## Работа со списками и реляционным представлением данных
## по курсу "Логическое программирование"

### студент: Старцев И.Р.

## Результат проверки

| Преподаватель     | Дата         |  Оценка       |
|-------------------|--------------|---------------|
| Сошников Д.В. |              |               |
| Левинская М.А.|              |               |

> *Комментарии проверяющих (обратите внимание, что более подробные комментарии возможны непосредственно в репозитории по тексту программы)*

## Введение

Список в языке программирования Пролог - это упорядоченная последовательность из элементов, имеющая произвольную длину. При работе со списками указывать тип данных элементов не нужно, но нужно, чтобы все они были одного типа. Элементами списка могут быть любые термы – константы, переменные и т. д.

Списки в Прологе напоминают статические массивы, списки в других языках программирования (но у них другая реализация и принцип работы), стеки, векторы (динамические массивы). Пролог представляет списки в формате "[Голова|Хвост]".

## Задание 1.1: Предикат обработки списка

**Реализация стандартных предикатов**
```prolog
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

mysublist([], []).
mysublist([H|L1], [H|L2]) :- mysublist(L1, L2).
mysublist(H, [_|L2]) :- mysublist(H, L2).
% ?-mysublist([1, 4], [1, 2, 3, 4]). 
```

**Специальный предикат обработки списка**

`delete_three_last(List, Res)` - удаление трёх последних элементов.

Примеры использования:
```prolog
?- delete_three_last([1, 2, 3, 4], X). 
X = [1].
        
?- delete_three_last([1, 2, 3, 4, 5], [1, 2]). 
true.

?- delete_three_last([1, Q, T, 2, 3], [1, Q]). 
true.

?- delete_three_last_n2([1, Q, T, 2, 3], [1, Q]). 
true.

?- delete_three_last_n2([1, 2, 3, 4], X).       
X = [1] ;
```

Реализация:
```prolog
% На основе стандартных предикатов обработки списков
delete_three_last(_, [], 3).
delete_three_last(X1, X2) :- mylen(X1, D), delete_three_last(X1, X2, D), !.
delete_three_last([H|T1], [H|T2], D) :- D1 is D - 1, delete_three_last(T1, T2, D1).

% Без их использования
delete_three_last_n2([_, _, _], []).
delete_three_last_n2([H|T1], [H|T2]) :- delete_three_last_n2(T1, T2).
```

## Задание 1.2: Предикат обработки числового списка

`check_order(List)` - проверка упорядоченности элементов по возрастанию.

Примеры использования:
```prolog
?- check_order([1, 2, 3, 4]).    
true.

?- check_order([1, 2, 3, 4, 1]). 
false.

?- check_order_n2([1, 2, 3, 4]).             
true.

?- check_order_n2([1, 2, 3, 4, 1]). 
false.
```

Реализация:
```prolog
% На основе стандартных предикатов обработки списков
check_order([_]) :- !.
check_order([X, Y|T]) :- X < Y, !, check_order([Y|T]).

% Без их использования
unsorted_std(L) :- myappend(_, [X, Y|_], L), X > Y.
chech_order_n2(L) :- not(unsorted_std(L)).
```

Отделяем из списка по два элемента, пока первый элемент меньше или равен второму. Работа программы заканчивается, когда в списке меньше двух элементов.

**Примеры совместного использования предикатов**

Сортировка, которая перебирает все перестановки элементов с помощью предиката `mypermute` и проверяет их на отсортированность предикатом `check_order`.
```prolog
permute_sort(X, Y) :- mypermute(X, Y), check_order(Y).
```
```prolog
?- permute_sort([5, 2, 7, 900, 1], X).    
X = [1, 2, 5, 7, 900] ;
false.
```


## Задание 2: Реляционное представление данных
К плюсам представления данных на языке Пролог можно отнести простоту записи данных и создания связей между ними. К минусам же - непривычный в сравнении с таблицами внешний вид и более трудное удаление элементов.

Представление из файла two.pl использует один предикат для описания связей между данными, что позволяет легко добавлять новые данные, в целом упрощает взаимодействие, но их количество постоянно растёт. Ещё к плюсам такого представления можно отнести возможность  использовать встроенные предикаты. Например: `findall` или `bagof`. 

`average(Subj, X)` - средний балл для предмета.

Примеры использования:
```prolog
?- average('Логическое программирование', X).
X = 3.9642857142857144.
?- average(X, Y).
X = 'Английский язык',
Y = 3.75 ;
X = 'Информатика',
Y = 3.9285714285714284 ;
X = 'Логическое программирование',
Y = 3.9642857142857144 ;
X = 'Математический анализ',
Y = 3.892857142857143 ;
X = 'Психология',
Y = 3.9285714285714284 ;
X = 'Функциональное программирование',
Y = 3.9642857142857144.
```

Реализация:
```prolog
average(Subj, X) :-
	bagof(Mark, Gr^St^grade(Gr, St, Subj, Mark), Res),
	sum_list(Res, Sum), length(Res, N),
	X is Sum / N.
```

Используем `bagof` для получения списка оценок для каждого конкретного предмета, `sum_list/2` для его суммы и длину. Ответ - сумма, делённая на длину.

`n_passed_gr(Gr, X)` - количество не сдавших студентов в группе.

Примеры использования:
```prolog
?- n_passed_gr(X, Y).
X = 101,
Y = 2 ;
X = 102,
Y = 5 ;
X = 103,
Y = 3 ;
X = 104,
Y = 2.
?- n_passed_gr(X, 1).
false.
?- n_passed_gr(103, X).
X = 3.
```

Реализация:
```prolog
n_passed_gr(Gr, X) :-
	setof(St, Subj^grade(Gr, St, Subj, 2), Res),
	length(Res, X).
```

Для каждой группы используем `setof`, потому что один студент мог не сдать несколько предметов. Ответ - длина списка.

`n_passed_subj(Subj, X)` - количество студентов, не сдавших предмет.

Примеры использования:
```prolog
?- n_passed_subj('Психология', X).
X = 1.
?- n_passed_subj(X, 2).
X = 'Информатика' ;
X = 'Логическое программирование' ;
false.
?- n_passed_subj(X, Y).
X = 'Английский язык',
Y = 4 ;
X = 'Информатика',
Y = 2 ;
X = 'Логическое программирование',
Y = 2 ;
X = 'Математический анализ',
Y = 3 ;
X = 'Психология',
Y = 1 ;
X = 'Функциональное программирование',
Y = 1.
```

Реализация:
```prolog
n_passed_subj(Subj, X) :-
	bagof(St, Gr^grade(Gr, St, Subj, 2), Res),
	length(Res, X).
```

Используем `bagof`, так как у одного студента есть единственная оценка за один предмет. Ответ - длина списка.


## Выводы

Благодаря данной лабораторной работе я научился работать со списками на языке Пролог, реализовывать различные предикаты для работы с ними, познакомился с реляционным представлением данных. Мне понравилось представление списков в виде [Head|Tail], это позволяет решать поставленные задачи разными методами.

Мне было очень сложно перестать мыслить в рамках концепта императивных языков, но меня действительно поражает возможность написать предикаты, а потом по-разному запросами к ним обращаться - проверять данные на истинность или, например, искать все подходящие на какое-то место переменные. Код на Прологе выглядит компактно и легко читаемо, но писать этот код по крайней мере мне довольно сложно, так как это новый опыт. Подводя итоги - мне было интересно абстрагироваться от старых привычек в программировании и взглянуть на него по-новому!
