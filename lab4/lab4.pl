% М8О-201Б-21 Старцев Иван

find([First|_], First).
find([_|End], First) :- find(End, First).

sizes(["big", "little"]).
positions(["under", "on"]).
places(["table"]).
objects(["pen", "book", "chich"]).
location(X, [["on", on(X)], ["under", under(X)]]).
colours(["red", "yellow"]).

size(X) :- sizes(List), find(List, X).
position(X) :- positions(List), find(List, X).
place(X) :- places(List), find(List, X).
object(X) :- objects(List), find(List, X).
colour(X) :- colours(List), find(List, X).

counter([],_, 0).
counter([First | End], List, Number) :- counter(End, List, Utility),
                                         find(List, First),
                                         Number = Utility + 1.
counter([First | End], List, Number) :- counter(End, List, Utility),
                                         not(find(List, First)),
                                         Number = Utility.

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