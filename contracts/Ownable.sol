pragma solidity 0.7.5;

contract Ownable {
    
    address[3] owners; //Owners of the wallet
    
    constructor(address owner1, address owner2, address owner3) {
        owners[0] = owner1;
        owners[1] = owner2;
        owners[2] = owner3;
    }
    
    modifier onlyOwner {
        require(checkIfOwner(msg.sender));
        _;
    }
    
    //Check if an address is one of the owner in the smart contract.
    function checkIfOwner(address _sender) private view returns (bool) {
        for(uint i = 0; i < owners.length; i++) {
            if(owners[i] == _sender) {
                return true;
            }
        }
        return false;
    }
}