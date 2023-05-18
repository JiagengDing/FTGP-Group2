// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;


interface IERC20 {
    function totalSupply() external view returns (uint);

    function balanceOf(address account) external view returns (uint);

    function transfer(address recipient, uint amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
}

contract ECR20_TestToken is IERC20 {
    string public name = "test";
    string public symbol = "TEST";
    uint8 public decimals = 18;
    // uint public override totalSupply = 100;
    uint public override totalSupply;
    mapping(address => uint) public balanceOf;
    address public owner;
    uint private current_totalsupply = 100;
    

    constructor(
        uint _buyNum1
        
    ) {
        uint _buyNum;
        _buyNum = _buyNum1 * (10**18);
        name = name;
        symbol = symbol;
        decimals = decimals;
        // totalSupply = totalSupply*(10 ** decimals);
        totalSupply = _buyNum + current_totalsupply *(10 ** decimals);
        balanceOf[msg.sender] = _buyNum;
        // emit Transfer(address(0), msg.sender, totalSupply);
        emit Transfer(address(0), msg.sender, balanceOf[msg.sender]);
        owner = msg.sender;
    }
    function transfer(address recipient, uint amount) external returns (bool) {
        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }


    // create the Portfolio tokens, and sent to msg.sender account
    function mint(uint amount) external {
        balanceOf[msg.sender] += amount;
        totalSupply += amount;
        emit Transfer(address(0), msg.sender, amount);
    }

    // destroy the Portfolio tokens ( less than the amount of msg.sender's balance
    function burn(uint amount) external {
        balanceOf[msg.sender] -= amount;
        totalSupply -= amount;
        emit Transfer(msg.sender, address(0), amount);
    }

    function getBalanceOf() external view returns (uint) {
        return balanceOf[msg.sender];
    }
}



