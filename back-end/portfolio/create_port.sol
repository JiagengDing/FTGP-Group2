// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

// Key concepts introduced:
    // create new portfolio SC
        // connect to use's (new portfolio owner) metamask wallet
            // metamask address
            // metamask balance
        // name portfolio & descreiption
        // pay gas & commission fee to DApp
        // new portfolio successfully creates

    // portfolio SC
        // buy()  - buy proportion of portfolio
        // sell() - sell proportion of portfolio to others
        // redeem() - redeeom proportion of portfolio from portfolio, so that the outstanding shares decrease.


// contract for create new portfolio

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Create_New_Portfolio {
    address public owner;
    string public name;
    string public description;
    uint256 public feeRate;
    
    IERC20 public token1;
    IERC20 public token2;
    IERC20 public token3;
    
    uint256 public percentage1;
    uint256 public percentage2;
    uint256 public percentage3;
    
    uint256 constant DAPP_COMMISSION_FEE = 100000;
    
    event PortfolioCreated(address indexed owner, string name, string description, uint256 feeRate);
    
    constructor(
        address _owner,
        address _token1,
        address _token2,
        address _token3,
        uint256 _percentage1,
        uint256 _percentage2,
        string memory _name,
        string memory _description,
        uint256 _feeRate
    ) payable {
        require(_owner != address(0), "Invalid owner address");
        require(_token1 != address(0) && _token2 != address(0) && _token3 != address(0), "Invalid token addresses");
        require(_percentage1 + _percentage2 <= 100, "Invalid token percentages");
        
        owner = _owner;
        token1 = IERC20(_token1);
        token2 = IERC20(_token2);
        token3 = IERC20(_token3);
        
        percentage1 = _percentage1;
        percentage2 = _percentage2;
        percentage3 = 100 - _percentage1 - _percentage2;
        
        name = _name;
        description = _description;
        feeRate = _feeRate;
        
        require(msg.value >= DAPP_COMMISSION_FEE, "Insufficient ETH for commission fee");
        (bool success, ) = payable(owner).call{value: msg.value - DAPP_COMMISSION_FEE}("");
        require(success, "ETH transfer failed");
        
        emit PortfolioCreated(owner, name, description, feeRate);
    }
    
    function connectMetamask() public view returns (address, uint256) {
        return (msg.sender, token1.balanceOf(msg.sender));
    }
    
    // buy()

    // sell()
}
