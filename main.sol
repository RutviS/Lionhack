// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;


import "./Heap.sol";
import "./Orderbook.sol";
import "./oracle.sol";
// import "./event.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/utils/SafeERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol";

contract driver is Heap, Ownable, Orderbook, ChainlinkPriceOracleETH{
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    struct Event {
        string name;
        uint target;
        uint date;
    }
    
    mapping(string => Orderbook) books;
    ChainlinkPriceOracleETH ethOracle;

    constructor() 
    {
        
    }

    function CreateOrderbook(string memory inname, uint intarget, uint indate) public returns(Orderbook){
        //create an Event 
        Event memory created_event = Event(inname, intarget, indate);
        books[inname] = new Orderbook();
        uint time = block.timestamp;
        books[inname].setTime(time);
    }

    //events for buttons 
    function onBuyYes(Event memory eventName, uint numShares, uint price) public{
        books[eventName.name].buying(true, numShares, price);
    }

    function onBuyNo(Event memory eventName, uint numShares, uint price) public{
        books[eventName.name].buying(false, numShares, price);
    }

    // function to get value from oracle 
    function oracle(Event memory eventname) payable public onlyOwner{
        string memory eth = "ETH";
        if (keccak256(bytes(eventname.name)) == keccak256(bytes(eth))){
            uint price = uint(ethOracle.getLatestPrice());
            if (price > eventname.target){
                // yes has won 
                books[eventname.name].endEventContract(true);
            }
            else {
                // no has won 
                books[eventname.name].endEventContract(false);
            }
        }
    }
}