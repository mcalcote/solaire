# solaire
CSE 579 KRR - ASU MCS Online

What the rules in the world.lp file is trying to do is given the init rules from the inst.lp files, we are trying to assign objects locations at time step 0.

# Objects

Object tells you the type of object and its instance 

```Ex. object(node,1) means this is the 1 instance of a  node object```

Pair tells you an X/Y coordinate,

```Ex. pair(X,Y)```

Location is represented by location(object,X/Y Coordinate, Time)

```Ex. location(object(node,1),pair(1,1),0), meaning node 1 is at location (1,1) on the grid```

# Products
When we look at products, what we are doing is tying products to shelves S with a certain quantity U at time step Time. 

On tells us there is a product object PR on shelf S with a quantity of U at time T.

```Ex. on(product,shelf,quantity,time)```

# Example
Inst1.lp initial state:
![alt text](https://github.com/mcalcote/solaire/blob/master/inst1.PNG)

R denotes the robots, S denotes the shelves, PS denotes the picking stations, and the P denotes the products with the N x denoting the quanity of the product on the shelf. If P is by itself, that means there is only 1 on the shelf. The red highlighted area is the highway.

# TODO
- Tracking Orders to make sure they are complete (e.g. END STATES and goal)
- Minimize number of moves needed.
- Fix shelf duplicates
- Presentation
- ?????

