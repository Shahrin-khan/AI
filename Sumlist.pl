sumlist([],0).
sumlist([H|T],N):-sumlist(T,L),N is L+H.
