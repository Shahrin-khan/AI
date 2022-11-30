and(Y,Z,X):- X is Y /\ Z.

or(Y,Z,X):- X is Y \/ Z.

x_or(Y,Z,X):- X is Y xor Z.

leftshift(Y,Z,X):- X is Y << Z.

rightshift(Y,Z,X):- X is Y >> Z.

complement(Z,X):- X is \ Z.



