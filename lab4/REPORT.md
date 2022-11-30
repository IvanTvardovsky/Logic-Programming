## Отчет по лабораторной работе №4
## по курсу "Логическое программирование"

## Обработка естественного языка

### студент: Старцев И.Р.

## Результат проверки

| Преподаватель     | Дата         |  Оценка       |
|-------------------|--------------|---------------|
| Сошников Д.В. |              |               |
| Левинская М.А.|              |               |

> *Комментарии проверяющих (обратите внимание, что более подробные комментарии возможны непосредственно в репозитории по тексту программы)*


## Введение

Для обработки языков чаще всего используются два метода - лингвистический и статистический.
Лингвистический метод задействует лингвистический анализ, который состоит из разных уровней: семантический (смысл предложения), синтаксический (зависимости слов в высказывании), графематический (слова по отдельности), морфологический (соответственно морфологические характеристики слов).
В основе же статистического метода лежит идея, что в основном смысл текста заключается в его самых используемых словах.

Из-за своей специфики у Prolog есть возможность довольно просто сопоставлять объекты с паттерном, а значит он хорошо подходит для обработки текстов. Это даёт способность реализовывать различные редакторы текста и т. д.

Решение начинается с запроса, который делится на составляющие до тех пор, пока не будут получены самые маленькие элементы, с которыми нужно работать.

## Задание

Реализовать разбор предложений английского языка. В предложениях у объекта
(подлежащего) могут быть заданы цвет, размер, положение. В результате разбора
должны получиться структуры представленные в примере.

Запросы: 
```Prolog
?- sentence(["The", "big", "book", "is", "under", "the", "table"], X).
?- sentence(["The", "red", "book", "is", "on", "the", "table"], X).
?- sentence(["The", "little", "pen", "is", "red"], X).
```

Результаты: 
```Prolog
X= s(location(object(book,size(big)), under(table))),
X= s(location(object(book, color(red)), on(table))),
X= s(object(pen,size(little)), color(red)).
``` 

## Принцип решения

Начнём с поиска элемента в списке
```Prolog
find([First|_], First).
find([_|End], First):- find(End, First).
```

Далее зададим все возможные свойства объектов и сами объекты
```Prolog
sizes(["big", "little"]).
positions(["under", "on"]).
places(["table"]).
objects(["pen", "book", "chich"]).
location(X, [["on", on(X)], ["under", under(X)]]).
colours(["red", "yellow"]).
```

Следовательно зададим предикаты вхождения объектов и свойств по спискам
```Prolog
size(X) :- sizes(List), find(List, X).
position(X) :- positions(List), find(List, X).
place(X) :- places(List), find(List, X).
object(X) :- objects(List), find(List, X).
colour(X) :- colours(List), find(List, X).
```

Создадим счётчик
```Prolog
counter([],_, 0).
counter([First | End], List, Number) :- counter(End, List, Utility),
                                         find(List, First),
                                         Number = Utility + 1.
counter([First | End], List, Number) :- counter(End, List, Utility),
                                         not(find(List, First)),
                                         Number = Utility.
```

Описываем возможные варианты предложений. В нашем случае их три
```Prolog
sentence(Suggestion, s(location(object(O, colour(C))), X)) :- find(Suggestion, O), object(O),
                                                        find(Suggestion, C), colour(C),
                                                        sizes(List), counter(Suggestion, List, 0),
                                                        find(Suggestion, P), place(P),
                                                        find(Suggestion, Pos), position(Pos),
                                                        location(P, Locations), find(Locations, [Pos, X]).

sentence(Suggestion, s(location(object(O, size(S))), X)) :- find(Suggestion, O), object(O),
                                                      find(Suggestion, S), size(S),
                                                      colours(List), counter(Suggestion, List, 0),
                                                      find(Suggestion, P), place(P),
                                                      find(Suggestion, Pos), position(Pos),
                                                      location(P, Locations), find(Locations, [Pos, X]).

sentence(Suggestion, s(object(O, size(S)), colour(C))) :- find(Suggestion, O), object(O),
                                                    find(Suggestion, S), size(S),
                                                    find(Suggestion, C), colour(C),
                                                    positions(List), counter(Suggestion, List, 0).
```

## Результаты

```Prolog
6 ?- sentence(["The", "big", "book", "is", "under", "the", "table"], X).
X = s(location(object("book", size("big"))), under("table")) ;
false.

6 ?- sentence(["The", "red", "book", "is", "on", "the", "table"], X).
X = s(location(object("book", colour("red"))), on("table")) ;
false.

7 ?- sentence(["The", "little", "pen", "is", "red"], X).
X = s(object("pen", size("little")), colour("red")) ;
false.
```

## Выводы

Подытожив, можно сказать, что Prolog довольно удобен для грамматического разбора предложений, потому что нужно просто описать небольшое количество правил, по которым разбирается предложение, например, как в моём случае, на английском языке. Это возможно из-за специфики этого языка, что недоступно для его императивных аналогов. Практически всегда на других ЯП такая лабораторная работа делалась бы в несколько раз дольше.
