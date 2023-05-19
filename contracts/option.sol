<<<<<<< HEAD
// Solidity version
pragma solidity ^0.8.0;

// Importing ERC20 token and SafeMath library
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

// LiquidityMining contract
contract LiquidityMining {
    using SafeMath for uint256;

    IERC20 public lpToken;// Token for liquidity provision
    IERC20 public rewardToken;// Token for rewards     
    uint256 public rewardPerBlock;// Amount of rewards per block     
    uint256 public startBlock;// Block number when mining starts    
    uint256 public endBlock;// Block number when mining ends     
    uint256 public lastUpdateBlock;// Block number when rewards were last updated     
    uint256 public totalSupply;// Total supply of liquidity tokens      
    uint256 public totalRewards;// Total amount of rewards    
    uint256 public rewardsPaid;// Total amount of rewards paid out    
    mapping(address => uint256) public balances;// Amount of liquidity tokens locked by each address    
    mapping(address => uint256) public lastUpdate;// Block number when rewards were last updated for each address    
    bool public miningEnded;// Whether mining has ended

    event Deposit(address indexed user, uint256 amount);
    event Withdraw(address indexed user, uint256 amount);
    event Claim(address indexed user, uint256 amount);

    constructor(
        IERC20 _lpToken,
        IERC20 _rewardToken,
        uint256 _rewardPerBlock,
        uint256 _startBlock,
        uint256 _endBlock
    ) {
        // Check for valid input parameters
        require(_lpToken != IERC20(address(0)), "Invalid LP token address");
        require(_rewardToken != IERC20(address(0)), "Invalid reward token address");
        require(_rewardPerBlock > 0, "Reward per block must be greater than zero");
        require(_startBlock > block.number, "Start block must be in the future");
        require(_startBlock < _endBlock, "End block must be greater than start block");

        // Initialize contract variables
        lpToken = _lpToken;
        rewardToken = _rewardToken;
        rewardPerBlock = _rewardPerBlock;
        startBlock = _startBlock;
        endBlock = _endBlock;
    }

    // Deposit function
    function deposit(uint256 _amount) external {
        // Check if mining has ended and amount is greater than zero
        require(!miningEnded, "Mining has ended");
        require(_amount > 0, "Amount must be greater than zero");

        // Update rewards
        updateRewards();

        // Transfer LP tokens from user to contract
        lpToken.transferFrom(msg.sender, address(this), _amount);

        // Update total supply, user balance and last update block
        totalSupply = totalSupply.add(_amount);
        balances[msg.sender] = balances[msg.sender].add(_amount);
        lastUpdate[msg.sender] = block.number;

        // Emit Deposit event
        emit Deposit(msg.sender, _amount);
    }

    // Withdraw function
    function withdraw(uint256 _amount) external {
        // Check if mining has ended, amount is greater than zero and user has sufficient balance
        require(!miningEnded, "Mining has ended");
        require(_amount > 0, "Amount must be greater than zero");
        require(balances[msg.sender] >= _amount, "Insufficient balance");

        // Update rewards
        updateRewards();

        // Update total supply, user balance and last update block
        totalSupply = totalSupply.sub(_amount);
        balances[msg.sender] = balances[msg.sender].sub(_amount);
        lastUpdate[msg.sender] = block.number;

        // Transfer LP tokens from contract to user
        lpToken.transfer(msg.sender, _amount);

        // Emit Withdraw event
        emit Withdraw(msg.sender, _amount);
    }

    // Claim function
    function claim() external {
        // Check if mining has ended
        require(!miningEnded, "Mining has ended");

        // Update rewards
        updateRewards();

        // Calculate rewards owing to user and check if greater than zero
        uint256 rewards = rewardsOwing(msg.sender);
        require(rewards > 0, "No rewards to claim");

        // Update rewards paid, transfer reward tokens to user and update last update block
        rewardsPaid = rewardsPaid.add(rewards);
        rewardToken.transfer(msg.sender, rewards);
        lastUpdate[msg.sender] = block.number;

        // Emit Claim event
        emit Claim(msg.sender, rewards);
    }

    // Function to calculate rewards owing to user
    function rewardsOwing(address _user) public view returns (uint256) {
        // Get current block number and set it to end block if greater than end block
        uint256 blockNumber = block.number;
        if (blockNumber > endBlock) {
            blockNumber = endBlock;
        }

        // Calculate blocks passed, user reward and return user reward
        uint256 blocksPassed = blockNumber.sub(lastUpdateBlock);
        uint256 userReward = balances[_user].mul(rewardPerBlock).mul(blocksPassed).div(totalSupply);
        return userReward;
    }

    // Function to update rewards
    function updateRewards() internal {
        // Return if current block number is less than or equal to last update block
        if (block.number <= lastUpdateBlock) {
            return;
        }

        // Set last update block to start block if less than start block
        if (lastUpdateBlock < startBlock) {
            lastUpdateBlock = startBlock;
        }

        // Return if last update block is greater than or equal to end block
        if (lastUpdateBlock >= endBlock) {
            return;
        }

        // Get current block number and set it to end block if greater than end block
        uint256 blockNumber = block.number;
        if (blockNumber > endBlock) {
            blockNumber = endBlock;
        }

        // Calculate blocks passed, reward amount, update total rewards and last update block
        uint256 blocksPassed = blockNumber.sub(lastUpdateBlock);
        uint256 rewardAmount = blocksPassed.mul(rewardPerBlock);
        totalRewards = totalRewards.add(rewardAmount);
        lastUpdateBlock = blockNumber;
    }

    // Function to end mining
    function endMining() external {
        // Check if caller is owner and mining has not ended
        require(msg.sender == owner(), "Only owner can end mining");
        require(!miningEnded, "Mining has already ended");

        // Update rewards and set miningEnded to true
        updateRewards();
        miningEnded = true;

        // Calculate remaining rewards and transfer to owner if greater than zero
        uint256 remainingRewards = rewardToken.balanceOf(address(this)).sub(rewardsPaid);
        if (remainingRewards > 0) {
            rewardToken.transfer(msg.sender, remainingRewards);
        }
    }

    // Function to get contract owner
    function owner() internal view returns (address) {
        return address(this// Return contract owner
        ); 
=======
pragma solidity ^0.8.0;

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function decimals() external view returns (uint8);
}

contract OptionContract {
    address public buyer; // Address of the option buyer
    address public seller; // Address of the option seller
    uint256 public strikePrice; // The price at which the option can be exercised
    uint256 public premium; // The price paid by the buyer to the seller for the option
    uint256 public expiryDate; // The date and time at which the option expires
    address public underlyingAsset; // The address of the underlying asset
    bool public isCallOption; // True if the option is a call option, false if it's a put option
    bool public isExercised; // True if the option has been exercised
    bool public isExpired; // True if the option has expired

    constructor(
        address _buyer,
        address _seller,
        uint256 _strikePrice,
        uint256 _premium,
        uint256 _expiryDate,
        address _underlyingAsset,
        bool _isCallOption
    ) {
        // Ensure that input parameters are valid
        require(_buyer != address(0), "Invalid buyer address");
        require(_seller != address(0), "Invalid seller address");
        require(_strikePrice > 0, "Invalid strike price");
        require(_premium > 0, "Invalid premium");
        require(_expiryDate > block.timestamp, "Invalid expiry date");
        require(_underlyingAsset != address(0), "Invalid underlying asset address");

        // Set input parameters as contract state variables
        buyer = _buyer;
        seller = _seller;
        strikePrice = _strikePrice;
        premium = _premium;
        expiryDate = _expiryDate;
        underlyingAsset = _underlyingAsset;
        isCallOption = _isCallOption;
    }

    function exercise() public {
        // Ensure that only the buyer can exercise the option
        require(msg.sender == buyer, "Only the buyer can exercise the option");
        // Ensure that the option hasn't been exercised or expired yet
        require(!isExercised, "The option has already been exercised");
        require(!isExpired, "The option has expired");
        // Ensure that the option hasn't expired yet
        require(block.timestamp < expiryDate, "The option has expired");

        // Mark the option as exercised
        isExercised = true;

        // Calculate the payout to the buyer based on the underlying asset balance and strike price
        uint256 underlyingAssetBalance = IERC20(underlyingAsset).balanceOf(address(this));
        uint256 strikePriceValue = strikePrice * 10 ** IERC20(underlyingAsset).decimals();
        uint256 payout = isCallOption ? underlyingAssetBalance - strikePriceValue : strikePriceValue - underlyingAssetBalance;

        // Ensure that the payout is greater than zero
        require(payout > 0, "The payout is zero or negative");

        // Transfer the payout to the buyer
        require(IERC20(underlyingAsset).transfer(buyer, payout), "Failed to transfer payout to the buyer");
    }

    function expire() public {
        // Ensure that only the seller can expire the option
        require(msg.sender == seller, "Only the seller can expire the option");
        // Ensure that the option hasn't expired yet
        require(!isExpired, "The option has already expired");
        require(block.timestamp >= expiryDate, "The option has not yet expired");

        // Mark the option as expired
        isExpired = true;

        // If the option hasn't been exercised, transfer the premium back to the seller
        if (!isExercised) {
            require(IERC20(underlyingAsset).transfer(seller, premium), "Failed to transfer premium to the seller");
        }
    }

    function cancel() public {
        // Ensure that only the seller can cancel the option
        require(msg.sender == seller, "Only the seller can cancel the option");
        // Ensure that the option hasn't been exercised or expired yet
        require(!isExercised, "The option has already been exercised");
        require(!isExpired, "The option has expired");

        // Transfer the premium back to the seller
        require(IERC20(underlyingAsset).transfer(seller, premium), "Failed to transfer premium to the seller");
    }

    function withdraw() public {
        // Ensure that only the buyer or seller can withdraw funds
        require(msg.sender == seller || msg.sender == buyer, "Only the buyer or seller can withdraw funds");

        // Calculate the seller and buyer shares based on the underlying asset balance, premium, and strike price
        uint256 underlyingAssetBalance = IERC20(underlyingAsset).balanceOf(address(this));
        uint256 sellerShare = (underlyingAssetBalance * premium) / (premium + strikePrice);
        uint256 buyerShare = underlyingAssetBalance - sellerShare;

        // Transfer the seller share to the seller
        if (sellerShare > 0) {
            require(IERC20(underlyingAsset).transfer(seller, sellerShare), "Failed to transfer seller share");
        }

        // Transfer the buyer share to the buyer
        if (buyerShare > 0) {
            require(IERC20(underlyingAsset).transfer(buyer, buyerShare), "Failed to transfer buyer share");
        }
>>>>>>> a87f83301560230296013d60db05d201772cb2b4
    }
}
