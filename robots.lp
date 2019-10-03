%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% robots.lp
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sort and object declaration
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% valid moves
move(1,0;-1,0;0,1;0,-1).

% valid locations
loc(X,Y) :- location(object(node,N),pair(X,Y),0).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% state description
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Robots can only perform up to one action at a time
:- not {occurs(object(robot,R), A, T)} 1, object(robot,R), T = 0..m-1.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% effects and preconditions of actions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% the pickup action
% the robot is carrying a shelf if the pickup action is performed
carrying(R,S,T+1) :- occurs(object(robot,R),pickup,T), location(object(robot,R),pair(X,Y),T), location(object(shelf,S),pair(X,Y),T).

% only perform the pickup action if a robot is in the same location as a shelf (not strictly necessary but removes some extraneous steady models)
:- occurs(object(robot,R),pickup,T), location(object(robot,R),pair(X,Y),T), location(object(shelf,S),pair(X1,Y1),T), pair(X,Y)!=pair(X1,Y1).

% the move action
location(object(robot,R),pair(X+DX,Y+DY),T+1) :- occurs(object(robot,R),move(DX,DY),T), location(object(robot,R),pair(X,Y),T).

% move shelf if being carried by moving robot
location(object(shelf,S),pair(X+DX,Y+DY),T+1) :- occurs(object(robot,R),move(DX,DY),T), location(object(robot,R),pair(X,Y),T), carrying(R,S,T).

% two robots can't be in the same location at the same time
:- 2{location(object(robot,RR),pair(X,Y),T)}, loc(X,Y), T=0..m.

% prevent robot from going out of bounds
:- location(object(robot,R),pair(X,Y),T), not loc(X,Y). 

% prevent robot carrying a shelf from moving through another shelf
:- occurs(object(robot,R),move(DX,DY),T), location(object(robot,R),pair(X,Y),T), carrying(R,S,T), location(object(shelf,S1),pair(X+DX,Y+DY),T+1), S!=S1.

% prevent robots from switching places (passing through each other)
:- occurs(object(robot,R1),move(DX,DY),T+1), occurs(object(robot,R2),move(-DX,-DY),T+1), location(object(robot,R1),pair(X,Y),T), location(object(robot,R2),pair(X+DX,Y+DY),T).


% putdown action
{carrying(R,S,T+1)} 0 :-  occurs(object(robot,R),putdown,T), carrying(R,S,T).  % I'm not sure if this does what I think it does which is set the carrying(R,S,T) atom to false.

% prevent putdown in highway
:- occurs(object(robot,R),putdown,T), location(object(robot,R),pair(X,Y),T), location(object(highway,H),pair(X,Y),T).


% deliver action
% TODO: Write deliver action

%% If robot is in the same location as the picking station, and it is carrying a shelf with products that match the order
%occurs(object(robot,R),deliver(O,I,U),T) :- location(object(robot,R),pair(X,Y),T), location(object(pickingStation,P),pair(X,Y),T), carrying(R,S,T), on(object(product,PR), object(shelf,S), U, T)
%object(order,O,value(line,pair(I,U))), object(order,O,value(pickingStation,1)).
%% When you deliver a product, you subtract what you took from the shelf
%on(object(product,PR), object(shelf,S), U2-U1, T+1) :- occurs(object(robot,R),deliver(O,I,U1),T), on(object(product,PR), object(shelf,S), U2, T)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% domain independent axioms
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% fluents are initially exogenous

{location(object(node,N),pair(X,Y),0) : loc(X,Y)}=1				:- object(node,N).
{location(object(highway,H),pair(X,Y),0) : loc(X,Y)}=1			:- object(highway,H).
{location(object(pickingStation,P),pair(X,Y),0) : loc(X,Y)}=1	:- object(pickingStation,P).
{location(object(robot,R),pair(X,Y),0) : loc(X,Y)}=1			:- object(robot,R).
{location(object(shelf,S),pair(X,Y),0) : loc(X,Y)}=1			:- object(shelf,S).


% actions are exogenous

{occurs(object(robot,R),move(X,Y),T) : move(X,Y)}	:- object(robot,R), T=0..m-1.
{occurs(object(robot,R),pickup,T)}					:- object(robot,R), T=0..m-1.
{occurs(object(robot,R),putdown,T)}					:- object(robot,R), T=0..m-1.
{occurs(object(robot,R),deliver(O,I,U),T)}			:- object(robot,R), object(order,O), value(line,pair(I,U)), T=0..m-1.


% uniqueness and existence of value constraints

:- not {location(object(node,N),pair(X,Y),T)}=1, 			object(node,N),				T=1..m.
:- not {location(object(highway,H),pair(X,Y),T)}=1, 		object(highway,H),			T=1..m.
:- not {location(object(pickingStation,P),pair(X,Y),T)}=1,	object(pickingStation,P),	T=1..m.
:- not {location(object(robot,R),pair(X,Y),T)}=1,			object(robot,R),			T=1..m.
:- not {location(object(shelf,S),pair(X,Y),T)}=1,			object(shelf,S),			T=1..m.
% TODO: Fix uniqueness for shelf/product.   Currently not working - missing one order 4 shelf at time 1+
%:- not {on(object(product,I),object(shelf,S),U,T) : object(shelf,S)}=1, object(product,I), T=1..m.	


% commonsense law of inertia

{location(object(node,N),pair(X,Y),T+1)}			:- location(object(node,N),pair(X,Y),T), T<m.
{location(object(highway,H),pair(X,Y),T+1)} 		:- location(object(highway,H),pair(X,Y),T), T<m.
{location(object(pickingStation,P),pair(X,Y),T+1)} 	:- location(object(pickingStation,P),pair(X,Y),T), T<m.
{location(object(robot,R),pair(X,Y),T+1)}			:- location(object(robot,R),pair(X,Y),T), T<m.
{location(object(shelf,S),pair(X,Y),T+1)}			:- location(object(shelf,S),pair(X,Y),T), T<m.
{on(object(product,I),object(shelf,S),U,T+1)}		:- on(object(product,I),object(shelf,S),U,T), T<m.

% TODO: Minimize the number of time steps




%%% TEST OUTPUT BELOW %%%

%location(R, pair(X,Y), T, r) :- location(object(robot,R),pair(X,Y),T).
%location(S, pair(X,Y), T, s) :- location(object(shelf,S),pair(X,Y),T).
%occurs(object(robot,R),move(DX,DY),T, r) :- occurs(object(robot,R),move(DX,DY),T).
%occurs(object(robot,R),pickup,T, r) :- occurs(object(robot,R),pickup,T).

%#show occurs/4.
%#show location/4.

%#show occurs/3.
%#show carrying/4.
#show on/4.