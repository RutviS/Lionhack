// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;


import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/utils/SafeERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol";


contract Event {
    constructor(string inputName, uint intarget, uint indate) {
        string name = inputName;
        uint target = intarget;
        uint date = indate;
    }
}