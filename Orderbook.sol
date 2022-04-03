// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;


import "./Heap.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/utils/SafeERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol";


contract Orderbook is Heap, Ownable {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;
    
    IERC20 public USDc; // currency for 
    Heap buyYES = new Heap(); // priority queue of YES orders
    Heap buyNO = new Heap(); // priority queue of NO orders
    uint orderbooktimestamp; // assign unique timestamp to each order
    address[] participants; // allows us to keep track of who to give rewards to
    // how many shares of YES/NO someone has (+ = YES, - = NO, 0 = noshares)
    mapping(address => int) balances;
    address bowner;

    constructor() 
    {
        USDc = IERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48); // cUSD address
        //IERC20 USDC_CONTRACT = IERC20(cUSD);
        orderbooktimestamp = 1; // first timestamp
        bowner = msg.sender;
        buyYES.init();
        buyNO.init();
    }
    function setTime(uint time) public{
        orderbooktimestamp = time;
    }
    
    // price measured in wei = 10^-18 cUSD
    function buying(bool YESno, uint numShares, uint price) payable public 
    {
        // ensure user has enough funds 
        //USDc.safeTransferFrom(msg.sender, address(this), numShares * price);

        // add order to correct priority queue
        if (YESno){
            buyYES.insert(order(true, msg.sender, numShares, price, orderbooktimestamp));
        }
        else{
            buyNO.insert(order(false, msg.sender, numShares, price, orderbooktimestamp));
        }
        
        // check to see if any orders can be matched
        matchorders();
        
        // update timestamp
        orderbooktimestamp += 1;
    }
    
    function matchorders() private 
    {
        // check if both queues are non-empty
        while (buyYES.top().buyer != address(0) && buyNO.top().buyer != address(0))
        {
            // check to see if there exists no matching 
            if ((buyYES.top().price + buyNO.top().price) < 1 ether)
                return;
            
            // find amount to give    
            uint amount = uint(min(int(buyYES.top().numShares), int(buyNO.top().numShares)));
            
            addBalances(amount);
        }
    }
    
    function addBalances(uint numShares) private
    {
        // YES 
        
        // check if address has order for opposite trade
        if(balances[buyYES.top().buyer] < 0)
        {
            // find number of canceled shares
            int amount = min(-1 * balances[buyYES.top().buyer], int(numShares));
            
            // accounting for later
            balances[buyYES.top().buyer] -= amount;
            numShares -= uint(amount);
            
            // give out of treasury (1 ether per share) 
            //USDc.safeTransfer(msg.sender, numShares * 1 ether);
        }
        // normal case - no existing order or only YES shares
        // will also go if buying more shares than had shorted initially
        if (numShares > 0) 
        {
            if (balances[buyYES.top().buyer] == 0)
                participants.push(buyYES.top().buyer);
            balances[buyYES.top().buyer] += int(numShares);
        }
        
        
        // NO
        
        // check if address has order for opposite trade
        if(balances[buyNO.top().buyer] > 0)
        {
            // find number of canceled shares
            int amount = min(int(balances[buyNO.top().buyer]), int(numShares));
            
            // accounting for later
            balances[buyNO.top().buyer] += amount;
            numShares -= uint(amount);
            
            // give out of treasury (1 ether per share) 
            //USDc.safeTransfer(msg.sender, numShares * 1 ether);
        }
        // normal case - no existing order or only YES shares
        // will also go if buying more shares than had shorted initially
        if (numShares > 0) 
        {
            if (balances[buyNO.top().buyer] == 0)
                participants.push(buyNO.top().buyer);
            balances[buyNO.top().buyer] -= int(numShares);
        }
        
        // remove from priority queue as needed
        buyYES.top().numShares -= numShares;
        if(buyYES.top().numShares == 0)
            buyYES.popTop();
        buyNO.top().numShares -= numShares;
        if(buyNO.top().numShares == 0)
            buyNO.popTop();
    }
    
    function endEventContract(bool TRUEfalse) payable public onlyOwner
    {
        // give back money to users with incomplete orders

        // buyYES
        while (buyYES.top().buyer != address(0)) 
        {
            // find amount to return
            uint amount = buyYES.top().numShares * buyYES.top().price;

            // return
            //USDc.safeTransfer(buyYES.top().buyer, amount);

            // pop order
            buyYES.popTop();
        }

        // buyNO
        while (buyNO.top().buyer != address(0)) 
        {
            // find amount to return
            uint amount = buyNO.top().numShares * buyNO.top().price;

            // return
            // USDc.safeTransfer(buyNO.top().buyer, amount);

            // pop order
            buyNO.popTop();
        }

        // reward money to users with complete owners who won
        // remove users from balances
        for (uint i = 0; i < participants.length; i++)
        {
            if (balances[participants[i]]!=0 && TRUEfalse == true)
            {
                // give 1 cUSD per share
                
                uint amount = uint(balances[participants[i]]);
                if(TRUEfalse == false){
                    amount = 0;
                }
                // USDc.safeTransfer(participants[i], amount);
            }

            balances[participants[i]] = 0;
        }
    }


    function min(int a, int b) private pure returns (int) 
    {
        if (a > b)
            return b;
        return a;
    }
}