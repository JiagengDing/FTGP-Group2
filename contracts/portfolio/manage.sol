// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

// Import the Chainlink Oracle interface
import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol"; 


// Import the Reentrancy Guard library to protect from re-entrancy attacks
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";


contract ECR20_PTokenFactory {
    event PTokenCreated(address indexed tokenAddress, address indexed creator);

    mapping(address => address) public createdTokens;

    function createPToken(
        string memory _name,
        string memory _symbol,
        //uint8 _decimals,
        uint _totalSupply,
        uint8 _hopeRatio, 
        uint8 _usdcRatio,
        uint8 _linkRatio,
        uint8 _customIPRate
        // uint256 _collateral
        ) public returns (address) {

        ECR20_PToken newToken = new ECR20_PToken(
        _name,
        _symbol,
        //_decimals,
        _totalSupply,
        msg.sender,   // pass the user's address as the owner
        _hopeRatio,
        _usdcRatio,
        _linkRatio,
        _customIPRate
        // _collateral
    );

        address tokenAddress = address(newToken);
        createdTokens[msg.sender] = tokenAddress;
        emit PTokenCreated(tokenAddress, msg.sender);
        return tokenAddress;
    }
    
    function getTokenAddress() public view returns (address) {
        return createdTokens[msg.sender];
    }

}


// ERC20 Token Interface
interface IERC20 {
    function totalSupply() external view returns (uint);

    function balanceOf(address account) external view returns (uint);

    function transfer(address recipient, uint amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint value);

}

// ERC20 PToken Contract for New Portfolio
contract ECR20_PToken is IERC20, ReentrancyGuard {
    string public name;
    string public symbol;
    uint8 public decimals;
    uint public override totalSupply;
    // uint public collateral;
    mapping(address => uint) public balanceOf;    // balanceOf for the account Portfolio Balance for each user
    mapping(address => mapping(address => uint256)) public balances_asset;    //balances_asset for the account each Token Balance for each user
    address public owner;

    IERC20 public hopeToken = IERC20(0x82fb927676b53b6eE07904780c7be9b4B50dB80b); // HOPE address on ETH mainnet
    IERC20 public usdcToken = IERC20(0x2B0974b96511a728CA6342597471366D3444Aa2a); // USDC address on ETH mainnet
    IERC20 public linkToken = IERC20(0x6B904451abABB342D2b787C5126C6361dD815246); // LINK address on ETH mainnet

    uint8 public hopeRatio;
    uint8 public usdcRatio;
    uint8 public linkRatio;
 
    AggregatorV3Interface private hopePriceFeed = AggregatorV3Interface(0x14866185B1962B63C3Ea9E03Bc1da838bab34C19); // HOPE/ETH price feed on ETH mainnet
    AggregatorV3Interface private usdcPriceFeed = AggregatorV3Interface(0xA2F78ab2355fe2f984D808B5CeE7FD0A93D5270E); // USDC/ETH price feed on ETH mainnet
    AggregatorV3Interface private linkPriceFeed = AggregatorV3Interface(0xc59E3633BAAC79493d908e63626716e204A45EdF); // LINK/ETH price feedon ETH mainnet

    constructor(
    string memory _name,
    string memory _symbol,
    //uint8 _decimals,
    uint256 _totalSupply,
    // uint256 _collateral,
    address _owner,   // pass the owner's address as a parameter
    uint8 hopeRatio_, 
    uint8 usdcRatio_, 
    uint8 linkRatio_,
    uint8 customIPRate
    // uint256 collateral_
    ) {
        // make sure that the sum of the amount ratio of the component Tokens or NFTs are 100%
        require(hopeRatio_ + usdcRatio_ + linkRatio_ == 100, "Total ratio must be 100%");

        name = _name;
        symbol = _symbol;
        // decimals = _decimals;
        decimals = 18;
        totalSupply = _totalSupply*(10 ** decimals);
            balanceOf[_owner] = totalSupply; // assign the initial supply to _owner
        emit Transfer(address(0), _owner, _totalSupply);
        owner = _owner;

        hopeRatio = hopeRatio_;
        usdcRatio = usdcRatio_;
        linkRatio = linkRatio_;

        customIPRate = customIPRate;

        // collateral = _collateral;
    }

    // transfer or sell the Portfolio tokens to another user
    function transfer(address recipient, uint256 amount) external returns (bool) {
        require(balanceOf[msg.sender] - amount > 0);
        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    // create the Portfolio tokens, and sent to msg.sender account
    function mint(uint256 amount) external payable {
        balanceOf[msg.sender] += amount;
        totalSupply += amount;
        emit Transfer(address(0), msg.sender, amount);
    }

    // destroy the Portfolio tokens ( less than or equal to the amount of msg.sender's Portfolio Token balance
    function burn(uint256 amount) external {
        balanceOf[msg.sender] -= amount;
        totalSupply -= amount;
        emit Transfer(msg.sender, address(0), amount);
    }

    // get contract creator's balance
    function getOwnerBalanceOf() external view returns (uint256) {
        return balanceOf[msg.sender];
    }
    
    // get the address of this Portfolio Token contract
    function getContractAddress() public view returns (address) {
        return address(this);
    }

    // get the price of this Portfolio Token, according to the average weighted price of each composition assets (such as Hope Token, USDC Token, Link Token etc.)
    function getLatestPrice() public view returns (uint256) {
        (,int hopePrice,,,) = hopePriceFeed.latestRoundData();
        (,int usdcPrice,,,) = usdcPriceFeed.latestRoundData();
        (,int linkPrice,,,) = linkPriceFeed.latestRoundData();

        uint256 hopePrice18Decimals = uint256(hopePrice) * 10**18;
        uint256 usdcPrice18Decimals = uint256(usdcPrice) * 10**18;
        uint256 linkPrice18Decimals = uint256(linkPrice) * 10**18;

        uint256 totalHopePrice = uint256(hopePrice18Decimals) * hopeRatio;
        uint256 totalUsdcPrice = uint256(usdcPrice18Decimals) * usdcRatio;
        uint256 totalLinkPrice = uint256(linkPrice18Decimals) * linkRatio;

        //return (totalHopePrice + totalUsdcPrice + totalLinkPrice) / 100 * (collateral / 1000) / totalSupply;
        return (totalHopePrice + totalUsdcPrice + totalLinkPrice) / 100 ;
    }
    // get the current total supplyment of this Portfolio Token on the market. The displayed value is an uint (unsigned integer) including 18 decimals. 
    function getTotalSupply() public view returns (uint256){
        return totalSupply;
    }


    // collateral Asset (Hope Token, USDC Token, Link Token, other NFTs, etc.)
    function deposit_collaterals(uint256 amount) public {
        require(amount > 0, "Amount must be greater than zero");
        // Transfer Composition tokens of this Portfoilio from sender to contract
        require(hopeToken.transfer(address(this), amount*hopeRatio/100), "Token transfer failed");
        require(usdcToken.transfer(address(this), amount*usdcRatio/100), "Token transfer failed");
        require(linkToken.transfer(address(this), amount*linkRatio/100), "Token transfer failed");
        // Update balances
        balances_asset[msg.sender][address(hopeToken)] += amount*hopeRatio/100;
        balances_asset[msg.sender][address(hopeToken)] += amount*usdcRatio/100;
        balances_asset[msg.sender][address(hopeToken)] += amount*linkRatio/100;
    }

    
	// collateral Asset Withdrawal (When burn the Portfolio Token to redeem collateral Asset)
    // add a reentrancy lock, such as the nonReentrant modifier
    function withdraw_collaterals(uint256 amount) public nonReentrant{
        require(balanceOf[msg.sender] - amount > 0, "Users Portfolio Balance must be greater than zero");
        // Transfer tokens from contract to user
        require(hopeToken.transfer(msg.sender, amount*hopeRatio/100), "Token transfer failed");
        require(hopeToken.transfer(msg.sender, amount*usdcRatio/100), "Token transfer failed");
        require(hopeToken.transfer(msg.sender, amount*linkRatio/100), "Token transfer failed");
        // Update balances
        balances_asset[msg.sender][address(hopeToken)] -= amount*hopeRatio/100;
        balances_asset[msg.sender][address(hopeToken)] -= amount*usdcRatio/100;
        balances_asset[msg.sender][address(hopeToken)] -= amount*linkRatio/100;
    }

}








