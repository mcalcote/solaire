%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% world.lp
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Maps a location of a node based on init
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

location(object(node,N),pair(X,Y),0) :- init(object(node,N),value(at,pair(X,Y))).
object(node,N) :- init(object(node,N),value(at,pair(X,Y))).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Maps a location of a highway based on init
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

location(object(highway,H),pair(X,Y),0) :- init(object(highway,H),value(at,pair(X,Y))).
object(highway,H) :- init(object(highway,H),value(at,pair(X,Y))).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Maps a location of a pickingStation based on init
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

location(object(pickingStation,P),pair(X,Y),0) :- init(object(pickingStation,P),value(at,pair(X,Y))).
object(pickingStation,P) :- init(object(pickingStation,P),value(at,pair(X,Y))).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Maps a location of a robot based on init
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

location(object(robot,R),pair(X,Y),0) :- init(object(robot,R),value(at,pair(X,Y))).
object(robot,R) :- init(object(robot,R),value(at,pair(X,Y))).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Extracts the shelf objects and their locations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

location(object(shelf,S),pair(X,Y),0) :- init(object(shelf,S),value(at,pair(X,Y))).
object(shelf,S) :- init(object(shelf,S),value(at,pair(X,Y))).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Extracts the product objects and their locations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

on(object(product,PR), object(shelf,S), U, 0) :- init(object(product,PR),value(on,pair(S,U))).
object(product,PR) :- init(object(product,PR),value(on,pair(X,Y))).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Extracts the order objects and their locations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

object(order,O, value(line,pair(X,Y))) :- init(object(order,O),value(line,pair(X,Y))).
value(line,pair(X,Y)) :- init(object(order,O),value(line,pair(X,Y))).

object(order,O, value(pickingStation,X)) :- init(object(order,O),value(pickingStation,X)).
value(pickingStation,X) :- init(object(order,O),value(pickingStation,X)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GOAL STATE DERIVED FROM INITIAL INSTANCE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% I count the number of deliveries that need to be fulfilled and place it in this predicate needed_deliveries(C,T)
% I then also set it so that the goal is you want needed_deliveries to have  a zero value at time step m. 
needed_deliveries(C,0) :- C = #count{O,X,Y : object(order,O, value(line,pair(X,Y)))}.
:- not needed_deliveries(0,m).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Testing area to view outputs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%#show value/2.
%#show location/2.
%#show on/4.
%#show object/3.
%#show needed_deliveries/2.