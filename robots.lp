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


%%%%%%%%%%% pickup action %%%%%%%%%%%
% only perform the pickup action if a robot is in the same location as a shelf and hands are empty
ready_to_pickup(R,S,T) :- location(object(robot,R),pair(X,Y),T), location(object(shelf,S),pair(X,Y),T), not carrying(R,S,T).

% the robot is carrying a shelf if the pickup action is performed
carrying(R,S,T+1)	:- occurs(object(robot,R),pickup,T), ready_to_pickup(R,S,T).

%%%%%%%%%%% putdown action %%%%%%%%%%%

% the robot is no longer carrying a shelf if the putdown action is performed
not carrying(R,S,T+1)	:- carrying(R,S,T), occurs(object(robot,R),putdown,T), T=0..m-1.

% prevent putdown if not carrying anything
robot_loaded(R,T)	:- carrying(R,S,T).
:- occurs(object(robot,R),putdown,T), not robot_loaded(R,T).

% prevent putdown in highway
:- occurs(object(robot,R),putdown,T), location(object(robot,R),pair(X,Y),T), location(object(highway,H),pair(X,Y),T).

% prevent putdown in occupied location
:- occurs(object(robot,R),putdown,T), carrying(R,S1,T), location(object(robot,R),pair(X,Y),T), location(object(shelf,S1),pair(X,Y),T), location(object(shelf,S2),pair(X,Y),T), S1 != S2.
:- occurs(object(robot,R),putdown,T), carrying(R,S,T), location(object(robot,R),pair(X,Y),T), location(object(pickingStation,P),pair(X,Y),T).

%%%%%%%%%%% move action %%%%%%%%%%%

% change robots location if it moves
location(object(robot,R),pair(X+DX,Y+DY),T+1) :- occurs(object(robot,R),move(DX,DY),T), location(object(robot,R),pair(X,Y),T).

% move shelf if being carried by moving robot
location(object(shelf,S),pair(X+DX,Y+DY),T+1) :- occurs(object(robot,R),move(DX,DY),T), location(object(robot,R),pair(X,Y),T), carrying(R,S,T).

% two robots can't be in the same location at the same time
:- 2{location(object(robot,RR),pair(X,Y),T)}, loc(X,Y), T=0..m.

% two shelves can't be in the same location at the same time
:- 2{location(object(shelf,SS),pair(X,Y),T)}, loc(X,Y), T=0..m.

% prevent robot from going out of bounds
:- location(object(robot,R),pair(X,Y),T), not loc(X,Y). 

% prevent robots from switching places (passing through each other)
:- occurs(object(robot,R1),move(DX,DY),T), occurs(object(robot,R2),move(-DX,-DY),T), location(object(robot,R1),pair(X,Y),T), location(object(robot,R2),pair(X+DX,Y+DY),T).

% prevent robot carrying a shelf from moving through another shelf
:- occurs(object(robot,R),move(DX,DY),T), location(object(robot,R),pair(X,Y),T), carrying(R,S,T), location(object(shelf,S1),pair(X+DX,Y+DY),T+1), S!=S1.

% prevent a robot from just going back and forth (with the exception of moving out of the way for another robot)
:- occurs(object(robot,R1),move(DX,DY),T), occurs(object(robot,R1),move(-DX,-DY),T+1), location(object(robot,R1),pair(X,Y),T), location(object(robot,R2),pair(X,Y),T+1), R1!=R2, T<m-1.

%%%%%%%%%%% deliver action %%%%%%%%%%%

% If robot is in the same location as the picking station, and it is carrying a shelf with products that match the order
%occurs(object(robot,R),deliver(O,I,U),T) :- location(object(robot,R),pair(X,Y),T), location(object(pickingStation,P),pair(X,Y),T), carrying(R,S,T), 
%on(object(product,I), object(shelf,S), U, T), object(order,O,value(line,pair(I,U))), object(order,O,value(pickingStation,P)) .

shelf_stocked(S,I,U,T) :- on(object(product,I), object(shelf,S), U, T), U > 0.

% Robot is ready to deliver when it it as the location of the picking station and it has the product
ready_to_deliver(R,O,I,U,T) :-  location(object(robot,R),pair(X,Y),T), location(object(pickingStation,P),pair(X,Y),T), carrying(R,S,T), 
on(object(product,I), object(shelf,S), U, T), object(order,O,value(line,pair(I,U))), object(order,O,value(pickingStation,P)), shelf_stocked(S,I,U,T).

% Robot cannot deliver unless precondition is met above
:- occurs(object(robot,R),deliver(O,I,U),T), not ready_to_deliver(R,O,I,U,T).

% When you deliver a product, you subtract what you took from the shelf
on(object(product,I), object(shelf,S), U2-U1, T+1) :- occurs(object(robot,R),deliver(O,I,U1),T), on(object(product,I), object(shelf,S), U2, T).

% Whenever a delivery is completed at time step T, we should decrement the needed_deliveries count, that way when it hits zero at time step m, we are done.
needed_deliveries(C-1,T+1) :- occurs(object(robot,R),deliver(O,I,U),T), needed_deliveries(C,T).


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
{occurs(object(robot,R),deliver(O,I,U),T)}			:- object(robot,R), object(order,O,value(line,pair(I,U))), value(line,pair(I,U)) , T=0..m-1.


% uniqueness and existence of value constraints

:- not {location(object(node,N),pair(X,Y),T)}=1, 			object(node,N),				T=1..m.
:- not {location(object(highway,H),pair(X,Y),T)}=1, 		object(highway,H),			T=1..m.
:- not {location(object(pickingStation,P),pair(X,Y),T)}=1,	object(pickingStation,P),	T=1..m.
:- not {location(object(robot,R),pair(X,Y),T)}=1,			object(robot,R),			T=1..m.
:- not {location(object(shelf,S),pair(X,Y),T)}=1,			object(shelf,S),			T=1..m.
:- not {carrying(R,S,T+1)}=1, carrying(R,S,T), not occurs(object(robot,R),putdown,T), 	T=0..m-1.
% TODO: Fix uniqueness for shelf/product.   Currently not working - missing one order 4 shelf at time 1+
%:- not {on(object(product,I),object(shelf,S),U,T) : object(shelf,S)}=1, object(product,I), T=1..m.
% The following line along with the related line in the "commonsense law of inertia" will handle uniqueness for shelf/product for all time values.
% I removed the 0..U and replaced it with the two choices (0 and U) because when delivering, we need to be able to adjust the U value (and it will be all or nothing after delivery).
:- not {on(object(product,I),object(shelf,S),0,T+1) ; on(object(product,I),object(shelf,S),U,T+1)}=1, on(object(product,I),object(shelf,S),U,T), T=0..m-1.


% commonsense law of inertia

{location(object(node,N),pair(X,Y),T+1)}			:- location(object(node,N),pair(X,Y),T), T<m.
{location(object(highway,H),pair(X,Y),T+1)} 		:- location(object(highway,H),pair(X,Y),T), T<m.
{location(object(pickingStation,P),pair(X,Y),T+1)} 	:- location(object(pickingStation,P),pair(X,Y),T), T<m.
{location(object(robot,R),pair(X,Y),T+1)}			:- location(object(robot,R),pair(X,Y),T), T<m.
{location(object(shelf,S),pair(X,Y),T+1)}			:- location(object(shelf,S),pair(X,Y),T), T<m.
{on(object(product,I),object(shelf,S),U,T+1)}		:- on(object(product,I),object(shelf,S),U,T), T<m.
{carrying(R,S,T+1)}									:- carrying(R,S,T), T<m.
{needed_deliveries(C,T+1)}                          :- needed_deliveries(C,T), T<m.


% TODO: Minimize the number of time steps
% We want to minimize all occurances of object O actions A at time T
#minimize{1,O,A,T: occurs(O,A,T)}.


%%% TEST OUTPUT BELOW %%%

%#show location/3.
#show occurs/3.
%#show order_complete/1.
%#show carrying/3.
%#show ready_to_pickup/2.
%#show on/4.
%#show move/2.