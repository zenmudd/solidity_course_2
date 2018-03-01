pragma solidity ^0.4.19;
contract GiveMyMoneyBack{
    mapping (address => uint) public debtors;
    mapping (address => bool) public borrowed;
    
    event Error(string message);
    event ShowRepayAmount(uint amount);
    event DealIsCompleted(string message);
    event Borrowed(string message);
    
    function borrow(uint _amountBorrow) public returns(bool) {
        if(debtors[msg.sender] != 0 ){
            Error('you have borrowed already, repay first!');
            return  false; 
        }
        debtors[msg.sender] = _amountBorrow;
        borrowed[msg.sender] = true;
        Borrowed('I just bowwored you some cash');
        return true;
    }

    function repay(uint _amountRepay) public returns(bool){
        if (debtors[msg.sender] == 0){
            Error("you have nothing to repay");
            return false;
        } else if (debtors[msg.sender] < _amountRepay) {
            Error( 'there is too much, use leftToRepay() function to know the amount left to repay');
            return false;
        }
        debtors[msg.sender] -= _amountRepay;
        
        if(debtors[msg.sender] == 0){
            DealIsCompleted("you own me nothing, we're good");
        }
    }
    
    function leftToRepay() public returns(bool) {
        if(borrowed[msg.sender]){
            ShowRepayAmount(debtors[msg.sender]);
            return true;  
            
        } 
        Error('you have never borrowed from me');
        return false;
    }
}
