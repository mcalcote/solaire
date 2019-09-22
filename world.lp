% Extracts the node objects and their locations
object(node,N) :- init(object(node,N),value(at,pair(X,Y))).
value(at,pair(X,Y)) :- init(object(node,N),value(at,pair(X,Y))).

% Extracts the node objects and their locations
object(highway,H) :- init(object(highway,H),value(at,pair(X,Y))).
value(at,pair(X,Y)) :- init(object(highway,H),value(at,pair(X,Y))).


#show object/2.