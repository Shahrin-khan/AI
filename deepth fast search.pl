s(a,b).
s(a,c).
s(b,d).
s(b,e).
s(c,a).
s(c,g).
s(d,h).
s(e,i).
s(e,j).
s(f,k).

goal(f).
goal(j).

member(X,[X|_]).
member(X,[_|Tail]):-member(X,Tail).

solve(Node,Solution):-
	dfs([],Node,Solution).

dfs(Path,Node,[Node|Path]):-
	goal(Node).

dfs(Path,Node,Sol):-
	s(Node,Node1),
	not(member(Node1,Path)),
	dfs([Node|Path],Node1,Sol).


