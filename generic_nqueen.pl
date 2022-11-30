use_module(library(lists)).
/*
 * You can query with: genetic_four_queens(R).
 * Or alternatively if you want to set the initial population manually you can do:
 * genetic_four_queens([[1,2,3,4],[2,3,4,1]],R)
 *
 * Note that each possible solution is represented by a list of size 4: [A,B,C,D]
 * where A =\= B =\= C =\= D
 * */
genetic_four_queens(Result):-
    genetic_four_queens([[1,2,3,4],[4,3,2,1]],Result).

genetic_four_queens(Population, Result):-
    write('Population: '),
    writeln(Population),
    evaluate(Population,Scores),
    min_list(Scores,Min),
    Min =\= 0,
    sum_list(Scores,Tot),
  selection(Population,Tot,S),
    proper_length(S,Len),
    (   Len =\= 0 ->
        Survivors = S
      ;
        Survivors = Population
    ),
    write('Survivors: '),writeln(Survivors),
    crossover(Survivors, Cross),
    write('Reproduction:'),writeln(Cross),
    mutation(Cross, Mutants),
    list_to_set(Mutants, NewPopulation),
    genetic_four_queens(NewPopulation,Result).

genetic_four_queens(Population, Result):-
    evaluate(Population,Scores),
    min_list(Scores,Min),
    Min = 0,
    nth1(I,Scores,0),
    nth1(I,Population,Result),
  write('Solution: '),writeln(Result).

evaluate([],[]).
evaluate([QList|List], [R|Res]):-
    fitness(QList, F), % List is an array of arrays
  evaluate(List, Res),
    R is F.

selection([],_,[]).
selection([Q|List],Tot, Res):-
    fitness(Q,F),
    P is 1 - F/Tot,
    (maybe(P) ->
      Res = [R|Tail],
      R = Q,
      selection(List, Tot, Tail)
      ;
      selection(List, Tot, Res)
    ).
crossover([],[]).
crossover([Q|List], Res) :-
    try_crossing(Q,List,Crossings),
    crossover(List, R2),
    union([Q|R2],Crossings,Res).

try_crossing(_,[],[]).
try_crossing(Q,[C|List],Res):-
    cross(Q,C,C1,C2),
%    Res = [C,C1,C2 | Tail],
    try_crossing(Q,List, Tail),
    union([C1,C2],Tail,Res).
try_crossing(Q,[C|List],Res):-
    \+ cross(Q,C,_,_),
%    Res = [C,C1,C2 | Tail],
    try_crossing(Q,List, Tail),
    Res=Tail.

cross(Q,C, R1,R2) :-
    [Q1,Q2|Q_tail] = Q,
    [C1,C2,C3,C4] = C,
    Q1 =\= C3,
    Q1 =\= C4,
    Q2 =\= C3,
    Q2 =\= C4,
    R1 = [Q1,Q2,C3,C4],
    R2 = [C1,C2|Q_tail].

mutation([],[]).
mutation([Q|QList], [Q,M|RList]):-
    proper_length(Q,L),
    random_between(1,L,Rand1),
    random_between(1,L,Rand2),
    permute(Q,Rand1,Rand2,M),
    mutation(QList,RList).

permute(Q,X,Y,M):-
    nth1(X,Q, Ex),
    nth1(Y,Q, Ey),
    replace(Q,Y,Ex,M1),
    replace(M1,X,Ey,M).

replace([],_,_,[]).
replace([_|List],Index,Element,[N|NewList]):-
    Index = 1,
    N = Element,
    I is Index-1,
    replace(List,I,Element,NewList).

replace([L|List],Index,Element,[N|NewList]):-
    Index =\= 1,
    N = L,
    I is Index-1,
    replace(List,I,Element,NewList).

fitness([], 0).
fitness([Q|Qlist], Res) :-
    collisions(Q, Qlist, 1, Collisions),
    fitness(Qlist, R2),
    Res is R2 + Collisions.

collisions(_,[], _, 0).
collisions(Q,[Q1|Qlist],Xdist,Result) :-
  Q =\= Q1, %not on the same row
  Test is abs(Q1-Q),
  Test =\= Xdist, %it means non diagonal conflict
  Xdist1 is Xdist + 1,
  collisions(Q,Qlist,Xdist1, R2),
    Result is R2.

collisions(Q,[Q1|Qlist],Xdist,Result) :-
  Q =\= Q1, %not on the same row
  Test is abs(Q1-Q),
  Test = Xdist, %it means diagonal conflict
  Xdist1 is Xdist + 1,
  collisions(Q,Qlist,Xdist1, R2),
    Result is R2 + 1.
