// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

//import "@openzeppelin/contracts/token/ERC20/IERC20.sol";  // Import the ERC20 interface
import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol"; // Import the Chainlink Oracle interface

interface IERC20 {
    function totalSupply() external view returns (uint);

    function balanceOf(address account) external view returns (uint);

    function transfer(address recipient, uint amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint value);
}


contract ECR20_PToken is IERC20 {
    string public name;
    string public symbol;
    uint8 public decimals;
    uint public override totalSupply;
    mapping(address => uint) public balanceOf;
    address public owner;

    IERC20 public daiToken = IERC20(0x82fb927676b53b6eE07904780c7be9b4B50dB80b); // DAI address on sepolia
    IERC20 public usdcToken = IERC20(0x2B0974b96511a728CA6342597471366D3444Aa2a); // USDC address on mainnet
    IERC20 public linkToken = IERC20(0x6B904451abABB342D2b787C5126C6361dD815246); // LINK address on mainnet

    uint256 public daiRatio;
    uint256 public usdcRatio;
    uint256 public linkRatio;
 
    AggregatorV3Interface public daiPriceFeed = AggregatorV3Interface(0x14866185B1962B63C3Ea9E03Bc1da838bab34C19); // DAI/USD on sepolia
    AggregatorV3Interface public usdcPriceFeed = AggregatorV3Interface(0xA2F78ab2355fe2f984D808B5CeE7FD0A93D5270E); // USDC/USD on sepolia
    AggregatorV3Interface public linkPriceFeed = AggregatorV3Interface(0xc59E3633BAAC79493d908e63626716e204A45EdF); // LINK/USD on sepolia

    // address private owner;   // if you do not want to display owner's address after deploy the contract

    constructor(
        string memory _name,
        string memory _symbol,
        uint8 _decimals,
        uint _totalSupply,
        //address owner
        uint256 daiRatio_, 
        uint256 usdcRatio_, 
        uint256 linkRatio_,
        uint256 customIPRate
    ) {
        require(daiRatio_ + usdcRatio_ + linkRatio_ == 100, "Total ratio must be 100%");

        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        totalSupply = _totalSupply*(10 ** decimals);
        balanceOf[msg.sender] = _totalSupply*(10 ** decimals);
        emit Transfer(address(0), msg.sender, _totalSupply);
        owner = msg.sender;

        daiRatio = daiRatio_;
        usdcRatio = usdcRatio_;
        linkRatio = linkRatio_;

        customIPRate = customIPRate;
    }
         function getLatestPrice() public view returns (uint256) {
        (,int daiPrice,,,) = daiPriceFeed.latestRoundData();
        (,int usdcPrice,,,) = usdcPriceFeed.latestRoundData();
        (,int linkPrice,,,) = linkPriceFeed.latestRoundData();

        uint256 daiPrice18Decimals = uint256(daiPrice) * 10**10;
        uint256 usdcPrice18Decimals = uint256(usdcPrice) * 10**10;
        uint256 linkPrice18Decimals = uint256(linkPrice) * 10**10;

        uint256 totalDaiPrice = uint256(daiPrice18Decimals) * daiRatio;
        uint256 totalUsdcPrice = uint256(usdcPrice18Decimals) * usdcRatio;
        uint256 totalLinkPrice = uint256(linkPrice18Decimals) * linkRatio;

        return (totalDaiPrice + totalUsdcPrice + totalLinkPrice) / 100;
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

    // get contract creator's balance
    function getOwnerBalanceOf() external view returns (uint) {
        return balanceOf[msg.sender];
    }
}



