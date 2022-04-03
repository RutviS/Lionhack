// SPDX-License-Identifier: MIT

/*
    TODO
    - figure out memory vs. order
    - test
*/

pragma solidity ^0.8.7;

/* Building a custom heap for my unique data structure
   "order" because I couldn't find a generalizable Heap,
   they were all int-specific.  
 */
    
contract Heap{ // default max-heap

    struct order {
        bool YESno; // 1 = YES, 0 = no
        address buyer;
        uint numShares;
        uint price;
        uint timestamp;
    }
    
    function priority(order memory OrderA, order memory OrderB) internal returns(order memory)
    {
        // ensure same time of order
        require(OrderA.YESno == OrderB.YESno, "Error: comparing two incompatible orders");
        
        // sort by price
        if (OrderA.price > OrderB.price)
            return OrderA;
        if (OrderA.price < OrderB.price)
            return OrderB;
        
        // sort by timestamp
        // guaranteed as timestamp is always unique
        // lower timestamp always wins 
        if (OrderA.timestamp < OrderB.timestamp)
            return OrderA;
        else
            return OrderB;
    }
    function equals(order memory OrderA, order memory OrderB) internal returns (bool){
        if (OrderA.YESno != OrderB.YESno){
            return false;
        } 
        if (OrderA.buyer != OrderB.buyer){
            return false;
        } 
        if (OrderA.numShares != OrderB.numShares){
            return false;
        } 
        if (OrderA.price != OrderB.price){
            return false;
        } 
        if (OrderA.timestamp != OrderB.timestamp){
            return false;
        } 
        return true;
    }
   
    uint constant ROOT_INDEX = 1;
    order[] nodes; // root is index 1; index 0 not used
    uint numOrders = 0;
    
    //call init before anything else
    // creates array with 0 index as we won't use that
    function init() public{
        if(nodes.length == 0) 
        {
            nodes.push(order(false, address(0), 0, 0, 0)); 
        }
    }
    
    // returns most prioritized
    function top() external view returns(order memory){
        if (numOrders == 0)
            return nodes[0];
        if (nodes.length == 1)
            return nodes[0];
        return nodes[1];
    }
    
    function insert(order memory Order) public 
    {
        //if(nodes.length == 0)
          //  { init(self); }// test on-the-fly-init
        if(nodes.length == 0){
            nodes.push(order(false, address(0), 0, 0, 0)); 
        }
    
        if (nodes.length > (numOrders + 1))
            nodes[numOrders+1] = Order;
        else
            nodes.push(Order);
            
        numOrders++;
        
        bubbleUp(numOrders);
    }
    
    function swap(order memory OrderA, order memory OrderB) private 
    {
        order memory temp = OrderA;
        OrderA = OrderB;
        OrderB = temp;
    }
    
    function bubbleUp(uint pos) private 
    {
        // check if high enough (ancestor or invalid)
        if (pos < 2)
            return;
            
        // check if parent is higher
        uint parent = (pos / 2);
        if (equals(priority(nodes[parent], nodes[pos]), nodes[parent]))
            return;
            
        // swap node + parent, recurse
        swap(nodes[parent], nodes[pos]);
        bubbleUp(parent);
    }
    
    function bubbleDown(uint pos) private
    {
        // check is leaf node
        if ((2 * pos) > numOrders)
            return;
            
        // find max child
        uint child = 2 * pos;
        if (child < numOrders)
            if (equals(priority(nodes[child], nodes[child+1]), nodes[child+1]))
                child++;
        
        // check if need to form switch
        if (equals(priority(nodes[child], nodes[pos]), nodes[pos]))
            return;
            
        // form switch, recurse
        swap(nodes[pos], nodes[child]);
        bubbleDown(child);
    }
    
    function popTop() public
    {
        nodes[1] = nodes[numOrders];
        numOrders--;
        bubbleDown(1);
    }
}