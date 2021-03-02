pragma solidity 0.7.5;
pragma abicoder v2;
import "./Ownable.sol";

contract MultisigWallet is Ownable {
    uint numOfSig; //Number of signatures that is needed for a transaction request
    uint balance; //Total balance of the wallet.
    
    //Transaction request
    struct TxRequest {
        uint txId;
        uint amount;
        address payable receiver;
        address[] acceptedTxReq;
    }
    
    //List of transaction requests
    TxRequest[] txRequests;
    
    constructor(address owner1, address owner2, address owner3, uint _numOfSig) Ownable(owner1, owner2, owner3) {
        numOfSig = _numOfSig;
    }
    
    //Deposit ether into the contract
    function deposit() public payable {
        balance += msg.value;
    }
    
    //Get the balance of the contract
    function getBalance() public view returns(uint) {
        return balance;
    }
    
    //Create one transaction request
    function txRequest(uint _amount, address payable _receiver) public onlyOwner {
        require(_amount <= balance);
        TxRequest memory _txReq;
        _txReq.amount = _amount;
        _txReq.txId = txRequests.length;
        _txReq.receiver = _receiver;
        txRequests.push(_txReq);
        txRequests[txRequests.length - 1].acceptedTxReq.push(msg.sender);
        assert(txRequests[txRequests.length - 1].amount == _amount);
        assert(txRequests[txRequests.length - 1].receiver == _receiver);
    }
    
    //Get all transaction requests in the contract
    function getTxRequests() public onlyOwner view returns (TxRequest[] memory) {
        return txRequests;
    }
    
    //Function that lets owner of the contract accepts different transfer requests made by other owners
    function acceptTxRequest(uint _txId) public onlyOwner {
        require(checkIfOwnerAccepted(msg.sender, _txId));
        require(countAcceptedSig(_txId) != true); //Enough owners has already accepted the transfer.
        require(txRequests[_txId].amount <= balance);
        txRequests[_txId].acceptedTxReq.push(msg.sender);
        if(countAcceptedSig(_txId)) {
            transfer(txRequests[_txId].receiver, txRequests[_txId].amount);
            balance -= txRequests[_txId].amount;
            delete txRequests[_txId];
        }
        assert(balance >= 0);
    }
    
    //Functions that transfer ether to a specific address
    function transfer(address payable _receiver, uint _amount) private {
        require(_amount <= balance);
        _receiver.transfer(_amount);
        assert(balance >= 0);
    }
    
    //Control if owner already accepted the transaction request
    function checkIfOwnerAccepted(address _owner, uint _txId) private view returns (bool) {
        for(uint i = 0; i < txRequests[_txId].acceptedTxReq.length; i++) {
            if(txRequests[_txId].acceptedTxReq[i] == _owner) {
                return false;
            }
        }
        return true;
    }
    
    //Check if enough owners has accepted the transaction request to let it through
    function countAcceptedSig(uint _txId) private view returns (bool) {
        uint _count = 0;
        for(uint i = 0; i < txRequests[_txId].acceptedTxReq.length; i++) {
            _count++;
            if(_count >= numOfSig) {
                return true;
            }
        }
        return false;
    }
}