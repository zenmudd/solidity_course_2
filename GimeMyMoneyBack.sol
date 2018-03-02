pragma solidity ^0.4.19;
contract GiveMyMoneyBack{
    mapping (address => address) public whoFromWhom;   // wallet borrowed some cash => from another wallet
    mapping (address => uint) public amountToReturn; // wallet has to pay => certain amount of cash
    mapping (address => uint) public borrowed; // have wallet has barrowed cash? => 1 if yes, 0 if no
    
    event Error(string message);
    event Message(string message);
    event ShowRepayAmount(uint amount);
    event DealIsCompleted(string message);
    event Borrowed(string message);
    
    function borrow(uint _amountBorrow, address _fromWhom) public returns (bool, string, uint) {
        if(borrowed[msg.sender] == 1){
            Error('you have borrowed already, repay first!');
            return  (false, 'you have borrowed already, repay first!', 0) ; 
        }
        amountToReturn[msg.sender] = _amountBorrow;
        whoFromWhom[msg.sender] = _fromWhom;
        borrowed[msg.sender] = 1;
        
        Borrowed ('I just bowwored some cash from you');
        return (true, 'I just bowwored some cash from you', amountToReturn[msg.sender]);
    }

    function repay(address _whoRepays, uint _amountRepay) public returns(bool, string){
        if (_whoRepays == msg.sender){
            Error("you are cheating, you can't repay yourself");
            return (false, "you are cheating, you can't repay yourself");
        } else if (amountToReturn[_whoRepays] == 0){
            Error("you have nothing to repay");
            return (false, 'you have nothing to repay');
        } else if (amountToReturn[_whoRepays] < _amountRepay) {
            Error( 'there is too much, use leftToRepay() function to know the amount left to repay');
            return (false, 'there is too much, use leftToRepay() function to know the amount left to repay');
        } 
        
        amountToReturn[_whoRepays] -= _amountRepay;
        
        if(amountToReturn[_whoRepays] == 0){
            DealIsCompleted("you own me nothing, we're good");
            borrowed[_whoRepays] = 0;
            return (true, "you own me nothing, we're good");
        }
        Message("I got your cash, but you still have to pay more, use leftToRepay() function to know the amount left to repay");
        return (true, "I got your cash, but you still have to pay more, use leftToRepay() function to know the amount left to repay");
    }
    
    function leftToRepay(address _walletToRepay) public returns(bool, uint) {
        if(borrowed[_walletToRepay] == 1){
            ShowRepayAmount(amountToReturn[_walletToRepay]);
            return (true, amountToReturn[_walletToRepay]);  
        } else {
            Error('you have never borrowed from me');
            return (false, 0);
        }
    }
}
