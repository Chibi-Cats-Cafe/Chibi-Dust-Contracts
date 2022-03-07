//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ChibiTeamVesting is Ownable{

    IERC20 ChibiDust;

    struct members{
        address memberAddress;
        uint share;
    }
    
    members[5] public teamMembers;
    uint[] unlockTime = [1646611200,1649289600,1651881600,1654560000,1657152000,1659830400,1662508800,1665100800];
    uint TOTAL = 15_000_000 ether;
    uint8 countsRetrieved;

    constructor(address _dust,address[5] memory teamAddress,uint[5] memory shares){
        ChibiDust = IERC20(_dust);
        for(uint i=0;i<5;i++){
            teamMembers[i] = members(teamAddress[i],shares[i]);
        }
        
    }

    function retrieveSalary() external onlyOwner{
        uint amountToSplit = TOTAL*125/1000;
        require(block.timestamp > unlockTime[countsRetrieved],"Not yet unlocked");
        countsRetrieved++;
        for(uint i = 0; i < 5; i++){
            address member = teamMembers[i].memberAddress;
            uint share = teamMembers[i].share;
            ChibiDust.transfer(member,amountToSplit*share/1000);
        }
    }
 
}