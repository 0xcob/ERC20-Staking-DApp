pragma solidity ^0.8.20;

 abstract contract Ownable {
    
    address owner;
    event TransferOwnership(address indexed oldOwner, address indexed newOwner);

    constructor(address newOwner) {
        owner = newOwner;
        emit TransferOwnership(address(0), newOwner);
    }

    modifier onlyOwner(){
        require(msg.sender == owner, "UNAUTHORIZED");
        _;
    }

    function transferownerShip(address newOwner) public virtual  onlyOwner {
        owner = newOwner;
        emit TransferOwnership(msg.sender, owner);
    }
}
