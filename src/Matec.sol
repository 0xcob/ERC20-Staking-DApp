pragma solidity ^0.8.19;

import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract Matec is ERC20{
    constructor() ERC20("MATEC", "MTE"){
        //mint 2000000 tokens 
        _mint(msg.sender, 2_000_000);
    }
}
