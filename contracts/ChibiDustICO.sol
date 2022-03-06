//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ChibiDustICO is Ownable{

    IERC20 ChibiDust;
    uint PRICE = 0.1 ether;

    uint boughtTotal;

    mapping(address=>uint) userBought;

    constructor(address _dust){
        ChibiDust = IERC20(_dust);
    }

    function buyDust(uint amount) external payable{
        require(msg.value >= PRICE);
        boughtTotal += amount;
    }

    function recoverDust() external onlyOwner{
        ChibiDust.transfer(msg.sender,ChibiDust.balanceOf(address(this))-boughtTotal);
    }

    function retrieveDust() external{

    }

    function changeDustAddress(address _newDust) external onlyOwner{
        ChibiDust = IERC20(_newDust);
    }

}