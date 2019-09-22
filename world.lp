% Maps a location of a node based on init
location(object(node,N),pair(X,Y),0) :- init(object(node,N),value(at,pair(X,Y))).
object(node,N) :- init(object(node,N),value(at,pair(X,Y))).

% Maps a location of a highway based on init
location(object(highway,H),pair(X,Y),0) :- init(object(highway,H),value(at,pair(X,Y))).
object(highway,H) :- init(object(highway,H),value(at,pair(X,Y))).

% Maps a location of a pickingStation based on init
location(object(pickingStation,P),pair(X,Y),0) :- init(object(pickingStation,P),value(at,pair(X,Y))).
object(pickingStation,P) :- init(object(pickingStation,P),value(at,pair(X,Y))).

% Maps a location of a robot based on init
location(object(robot,R),pair(X,Y),0) :- init(object(robot,R),value(at,pair(X,Y))).
object(robot,R) :- init(object(robot,R),value(at,pair(X,Y))).

% Extracts the shelf objects and their locations
location(object(shelf,S),pair(X,Y),0) :- init(object(shelf,S),value(at,pair(X,Y))).
object(shelf,S) :- init(object(shelf,S),value(at,pair(X,Y))).

% Extracts the product objects and their locations
on(object(product,PR), object(shelf,S), U, 0) :- init(object(product,PR),value(on,pair(S,U))).
object(product,PR) :- init(object(product,PR),value(on,pair(X,Y))).


% Extracts the order objects and their locations
object(order,O) :- init(object(order,O),value(line,pair(X,Y))).
value(line,pair(X,Y)) :- init(object(order,O),value(line,pair(X,Y))).

object(order,O) :- init(object(order,O),value(pickingStation,X)).
value(pickingStation,X) :- init(object(order,O),value(pickingStation,X)).


%#show value/2.

%:- not location(object(node,N),pair(X,Y)).
#show location/2.