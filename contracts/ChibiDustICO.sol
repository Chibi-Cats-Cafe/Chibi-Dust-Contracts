//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ChibiDustICO is Ownable{

    IERC20 ChibiDust;

    uint public boughtTotal;
    uint public endTime = 1648771200;

    address cgAddress;

    bool public isPaused;

    mapping(address=>uint) public userBought;
    mapping(address=>uint) public userClaimed;

    constructor(address _dust){
        ChibiDust = IERC20(_dust);
    }

    uint[] public unlockTimes = [1649289600,1657152000];

    modifier isNotPaused{
        require(!isPaused,"Execution paused");
        _;
    }

    modifier onlyCg{
        require(msg.sender ==  cgAddress,"Sender not cg");
        require(cgAddress != address(0),"cg address not set");
        _;
    }

    function buyDust() external payable isNotPaused{
        require(msg.value > 0,"Can't buy 0 tokens");
        require(block.timestamp < endTime,"ICO Expired"); //1st April 12 AM UTC
        require(ChibiDust.balanceOf(address(this))-boughtTotal > 0,"No more tokens left to sell");
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

    function recoverDust() external onlyCg{
        ChibiDust.transfer(msg.sender,ChibiDust.balanceOf(address(this))-boughtTotal);
    }

    function recoverONE() external onlyCg{
        payable(msg.sender).transfer(address(this).balance);
    }

    function changeDustAddress(address _newDust) external onlyOwner{
        ChibiDust = IERC20(_newDust);
    }

    function editEndTime(uint _time) external onlyOwner{
        endTime = _time;
    } 

    function updateCgAddress(address _cgAddress) external onlyOwner{
        cgAddress = _cgAddress;
    }

    function claimStartEnd(uint index,uint _time) external onlyOwner{
        unlockTimes[index] = _time;
    }

    function pauseContract(bool _pause) external onlyOwner{
        isPaused = _pause;
    }

}