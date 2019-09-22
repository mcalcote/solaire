# solaire
CSE 579 KRR - ASU MCS Online

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

What the rules in the world.lp file is trying to do is given the init rules from the inst.lp files, we are trying to assign objects locations at time step 0.


Inst1.lp initial state:
![alt text](https://github.com/mcalcote/solaire/blob/master/inst1.PNG)



