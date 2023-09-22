// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

// Uncomment this line to use console.log

import "hardhat/console.sol";

/**
 * The multisig contract does this and that...
 */
contract multisig {
    //declaring of some public variables
    address[] public signers;
    mapping(address => bool) public isSigner;
    uint256 public minConfirmationsRequired;
    uint256 public txCount;
    
    struct Transaction {
        address to;
        uint256 value;
        bytes data;
        bool executed;
        //mapping(address => bool) isConfirmed;
        uint256 numConfirmations;
        uint256 numRevoke;
       // mapping(address => bool) isRevoked;
    }
    mapping(address => bool) isConfirmed;
    mapping(address => bool) isRevoked;

    Transaction[] public transactions;

    //instantiating the constructor
  constructor(address[] memory _signers, uint256 _minConfirmationsRequired) public {
    require(_signers.length > 0, 'signers can not be blank');
    require(_minConfirmationsRequired > 0, 'number of confirmations can not be zero');
    require(_minConfirmationsRequired < _signers.length, 'number of confirmations can not be more than the signers');
    signers = _signers;

    for(uint256 p = 0; p < _signers.length; p++){
        address signer = _signers[p];
        require(!isSigner[signer], 'the address is already an owner');
        require(signer != address(0), 'the signer can not be a null address');

        isSigner[signer] = true;
        signers.push(signer);
    }

    minConfirmationsRequired = _minConfirmationsRequired;
    
  }

function getConfirmed(uint256 _txCount) public returns(bool){
    return isConfirmed[msg.sender];
}
function getRevoked(uint256 _txCount) public returns(bool){
    return isRevoked[msg.sender] = true;
}

  //submitting a transaction by one of the signers

  function submitTransaction(address _to, uint256 _amount, bytes memory _data) public onlyOwner {
    txCount = transactions.length;

   //transactions.push(Transaction());

   transactions.push(Transaction(_to, _amount, _data, false, 0, 0));
    

    

    //newTransaction.to = _to;
   // newTransaction.value = _amount;
   // newTransaction.data = _data;
  //  newTransaction.executed = false;
  //  newTransaction.isConfirmed[msg.sender] = false;
   // newTransaction.numConfirmations = 0;
   // newTransaction.numRevoke = 0;
  //  newTransaction.isRevoked[msg.sender] = false;
    //emit submitTransaction();

  }

   modifier onlyOwner(){
    require(isSigner[msg.sender], 'Only a singer is allowed to sign this transaction');
    _;

  }

  modifier txValid(uint256 _txCount){
    require(_txCount <= transactions.length, 'Submit a valid Transaction');
    _;
  }


  modifier notExecuted(uint256 _txCount){
    require(!transactions[_txCount].executed, 'Submit a valid Transaction');
    _;
  }

  modifier notConfirmed(uint256 _txCount) {
    bool status = getConfirmed(_txCount);
    require(!status, 'transactions already confirmed by the signer');
    _;
  }

  function confirmTransaction(uint256 _txCount) public onlyOwner txValid(_txCount) notExecuted(_txCount) notConfirmed(_txCount) {
    Transaction storage transaction = transactions[_txCount];
    //transaction.isConfirmed[msg.sender] = true;
    isConfirmed[msg.sender] = true;
    transaction.numConfirmations = transaction.numConfirmations + 1;

  }

  function executeTransaction(uint256 _txCount) public payable onlyOwner txValid(_txCount) notExecuted(_txCount) notConfirmed(_txCount) {

    Transaction storage transaction = transactions[_txCount];
    require(transaction.numConfirmations >= minConfirmationsRequired, 'Minimum number of confirmations not met');

    uint256 value = transaction.value;
    address payable recipient = payable(transaction.to);
    bytes storage data = transaction.data;

    console.log('The tranasction value is ', transaction.value);
    console.log('The recipient is', recipient);
    console.log('Balance before transfer', address(this).balance);
    require(address(this).balance > value, 'Insufficient Contract balance');

    (bool success, ) = recipient.call{value : value}('');
    require(success, 'transaction failed');
    
    console.log('Balance after transfer', address(this).balance);

    transaction.executed = true;

    emit ExecuteTransaction(msg.sender, _txCount);
  }

  function revokeTransaction(uint256 _txCount) public onlyOwner txValid(_txCount) notExecuted(_txCount) notConfirmed(_txCount) {
    Transaction storage transaction = transactions[_txCount];
    bool status = getRevoked(_txCount);
    //transaction.isRevoked[msg.sender] = true;
    transaction.numRevoke = transaction.numRevoke + 1;
    transaction.executed = true;

    if(transaction.numRevoke > ((signers.length * 50 ) / 100)){
        require(false, 'Can not proceed with the transaction');
        emit RevokeTransaction(msg.sender, _txCount);
       // (bool failure, ) = transaction.to.call(transaction.amount)(transaction.data);
        //require(!)
    }


  }

  //fallback function to enable us deposit ethers to the contract

  fallback() payable external{
    emit Deposit(msg.sender, msg.value, address(this).balance);
  }

  receive() payable external{
    emit Deposit(msg.sender, msg.value, address(this).balance);

  }

  //declaring the various events

  event Deposit(address indexed from, uint256 indexed amount, uint256 current_balance);
  event RevokeTransaction(address indexed from, uint256 trIndex);
  event ExecuteTransaction(address indexed from, uint256 trIndex);

  
  


      
  
  
}


