%%%%%%%%%%%%%%%%%%%%%%%%
% move
%%%%%%%%%%%%%%%%%%%%%%%%
% move is exogenous (sample rule)
{move(R,X,Y,T)} :- robot(R), loc(X,Y), T=0..time-1.

% effect of moving (sample rule)
at(R,X,Y,T+1) :- move(R,X,Y,T).

% moves have to be a valid node

% cannot move to a node a robot currently occupies

% if pickup true, then cannot move to a node a shelf currently occupies

% robots cannot pass through each other (serializable moves required)


%%%%%%%%%%%%%%%%%%%%%%%%
% pickup
%%%%%%%%%%%%%%%%%%%%%%%%
% pickup must be false

% robot and shelf at the same location at time-1


%%%%%%%%%%%%%%%%%%%%%%%%
% deliver
%%%%%%%%%%%%%%%%%%%%%%%%
% pickup must be true

% robot must be at order o pickingStation at time-1

% robot pickup shelf must have u many units of product i

% order o must be undelivered

% quanties of product i must be reduced, but not below 0


%%%%%%%%%%%%%%%%%%%%%%%%
% putdown
%%%%%%%%%%%%%%%%%%%%%%%%
% pickup must be true

% robot must be at the same location as time-1

% robot must not be on a highway