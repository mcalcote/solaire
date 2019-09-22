% Extracts the node objects and their locations
object(node,N) :- init(object(node,N),value(at,pair(X,Y))).
value(at,pair(X,Y)) :- init(object(node,N),value(at,pair(X,Y))).

% Extracts the node objects and their locations
object(highway,H) :- init(object(highway,H),value(at,pair(X,Y))).
value(at,pair(X,Y)) :- init(object(highway,H),value(at,pair(X,Y))).

% Extracts the pickingStation objects and their locations
object(pickingStation,P) :- init(object(pickingStation,P),value(at,pair(X,Y))).
value(at,pair(X,Y)) :- init(object(pickingStation,P),value(at,pair(X,Y))).

% Extracts the robot objects and their locations
object(robot,R) :- init(object(robot,R),value(at,pair(X,Y))).
value(at,pair(X,Y)) :- init(object(robot,R),value(at,pair(X,Y))).

% Extracts the shelf objects and their locations
object(shelf,S) :- init(object(shelf,S),value(at,pair(X,Y))).
value(at,pair(X,Y)) :- init(object(shelf,S),value(at,pair(X,Y))).

% Extracts the product objects and their locations
object(product,PR) :- init(object(product,PR),value(at,pair(X,Y))).
value(at,pair(X,Y)) :- init(object(product,PR),value(at,pair(X,Y))).

% Extracts the order objects and their locations
object(order,O) :- init(object(order,O),value(at,pair(X,Y))).
value(at,pair(X,Y)) :- init(object(order,O),value(at,pair(X,Y))).


#show object/2.