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
    }
}
