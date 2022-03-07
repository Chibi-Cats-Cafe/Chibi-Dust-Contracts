//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ChibiDustICO is Ownable{

    IERC20 ChibiDust;

    uint boughtTotal;

    mapping(address=>uint) userBought;
    mapping(address=>uint) userClaimed;

    constructor(address _dust){
        ChibiDust = IERC20(_dust);
    }

    uint[] public unlockTimes = [1649289600,1657152000];

    function buyDust() external payable{
        require(msg.value > 0,"Can't buy 0 tokens");
        require(block.timestamp < 1648771200,"ICO Expired"); //1st April 12 AM UTC
        boughtTotal += msg.value;
        userBought[msg.sender] += msg.value;
    }

    function retrieveDust() external{
        require(amountToClaim(msg.sender) > 0,"Nothing to retrieve");
        uint amount = amountToClaim(msg.sender);
        userClaimed[msg.sender] += amount;
        boughtTotal -= amount;
        ChibiDust.transfer(msg.sender, amount);
    }

    function amountUnlocked(address _user) private view returns(uint){
        if(block.timestamp < unlockTimes[0]){
            return 0;
        }else if(block.timestamp < unlockTimes[1]){
            return userBought[_user]*(block.timestamp-unlockTimes[0])/(unlockTimes[1]-unlockTimes[0]);
        }else{
            return userBought[_user];
        }
    }    

    function amountToClaim(address _user) public view returns(uint){
        return (amountUnlocked(_user)-userClaimed[_user]);
    }

    function recoverDust() external onlyOwner{
        ChibiDust.transfer(msg.sender,ChibiDust.balanceOf(address(this))-boughtTotal);
    }

    function recoverONE() external onlyOwner{
        payable(msg.sender).transfer(address(this).balance);
    }

    function changeDustAddress(address _newDust) external onlyOwner{
        ChibiDust = IERC20(_newDust);
    }

}