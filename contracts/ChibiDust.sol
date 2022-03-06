//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ChibiDust is ERC20,Ownable{

    uint public MAX_SUPPLY = 100_000_000 ether;

    constructor() ERC20("Chibi Dust","$DUST"){}

    function mint(uint amount) external onlyOwner{
        require(totalSupply() + amount < MAX_SUPPLY,"Can't exceed max supply");
        _mint(msg.sender,amount);
    }

}