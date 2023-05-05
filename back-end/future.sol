pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract FuturesContract {
    address public buyer; // address of the buyer
    address public seller; // address of the seller
    uint256 public price; // price of the futures contract
    uint256 public quantity; // quantity of the underlying asset
    uint256 public expiration; // expiration date of the contract
    uint256 public margin; // margin required to open a position
    uint256 public leverage; // leverage ratio of the position
    uint256 public stopLoss; // price at which a stop-loss order is triggered
    uint256 public marginCall; // margin level at which a margin call is triggered

    address private constant chainlinkOracleAddress =
        0x0d6276F2B557982E0C39928475eBBe7570F61850;
    AggregatorV3Interface internal priceFeed;

    // Define the state of the contract using an enum
    enum ContractState {
        Created, // the contract has been created but not yet locked
        Locked, // the contract has been locked and is active
        Inactive // the contract has expired, been settled or terminated
    }
    ContractState public state;

    // Define the events of the contract
    event ContractLocked();
    event ContractSettled(address indexed winner, uint256 payout);
    event MarketOrderExecuted(
        address indexed trader,
        uint256 quantity,
        uint256 price
    );
    event StopLossOrderExecuted(
        address indexed trader,
        uint256 quantity,
        uint256 price
    );
    event MarginCallTriggered(address indexed trader, uint256 marginLevel);

    // Define the constructor to initialize the contract parameters
    constructor(
        address _buyer, // address of the buyer
        address _seller, // address of the seller
        uint256 _price, // price of the futures contract
        uint256 _quantity, // quantity of the underlying asset
        uint256 _expiration, // expiration date of the contract
        uint256 _margin, // margin required to open a position
        uint256 _leverage, // leverage ratio of the position
        uint256 _stopLoss, // price at which a stop-loss order is triggered
        uint256 _marginCall // margin level at which a margin call is triggered
    ) {
        buyer = _buyer;
        seller = _seller;
        price = _price;
        quantity = _quantity;
        expiration = _expiration;
        margin = _margin;
        leverage = _leverage;
        stopLoss = _stopLoss;
        marginCall = _marginCall;
        state = ContractState.Created;
        priceFeed = AggregatorV3Interface(chainlinkOracleAddress);
    }

    // Lock the contract to activate it and open a position
    function lockContract() public payable {
        // Check that the caller is the buyer or the seller
        require(
            msg.sender == buyer || msg.sender == seller,
            "Only buyer or seller can lock the contract"
        );
        // Check that the contract is in the correct state to be locked
        require(
            state == ContractState.Created,
            "Contract is not in the correct state to be locked"
        );
        // Check that the margin is sufficient to open a position
        require(msg.value >= margin, "Insufficient margin to open a position");
        // Calculate the amount of the underlying asset that can be bought with the margin and leverage
        uint256 positionSize = (msg.value * leverage * price) / 1 ether;
        // Change the state of the contract to Locked
        state = ContractState.Locked;
        // Emit the ContractLocked event
        emit ContractLocked();
    }

    // Execute a market order to buy or sell the underlying asset
    function executeMarketOrder(bool isBuyOrder, uint256 quantity)
        public
        payable
    {
        // Check that the caller is either the buyer or the seller
        require(
            msg.sender == buyer || msg.sender == seller,
            "Only buyer or seller can execute a market order"
        );
        // Check that the contract is in the correct state to execute a market order
        require(
            state == ContractState.Locked,
            "Contract is not in the correct state to execute a market order"
        );
        // Calculate the cost of the order based on the price and quantity of the contract
        uint256 cost = price * quantity;
        // Check that the trader has sufficient funds or assets to execute the order
        if (isBuyOrder) {
            require(
                msg.sender == buyer,
                "Only the buyer can execute a buy order"
            );
            require(
                msg.value >= cost,
                "Insufficient funds to execute the buy order"
            );
            // Calculate the new position size after executing the order
            uint256 newPositionSize = ((msg.value - cost) * leverage * price) /
                1 ether;
            // Check if a margin call has been triggered
            if (newPositionSize * price < marginCall * margin) {
                // Trigger a margin call if the new position size falls below the margin call level
                emit MarginCallTriggered(
                    msg.sender,
                    (newPositionSize * price) / margin
                );
            }
        } else {
            require(
                msg.sender == seller,
                "Only the seller can execute a sell order"
            );
            require(
                quantity <= quantity - (msg.value / price),
                "Insufficient assets to execute the sell order"
            );
            // Calculate the new position size after executing the order
            uint256 newPositionSize = ((msg.value + cost) * leverage * price) /
                1 ether;
            // Check if a margin call has been triggered
            if (newPositionSize * price < marginCall * margin) {
                // Trigger a margin call if the new position size falls below the margin call level
                emit MarginCallTriggered(
                    msg.sender,
                    (newPositionSize * price) / margin
                );
            }
        }
        // Emit the MarketOrderExecuted event with the trader, quantity, and price as parameters
        emit MarketOrderExecuted(msg.sender, quantity, price);
    }

    // Execute a stop-loss order to limit potential losses
    function executeStopLossOrder(bool isBuyOrder, uint256 quantity)
        public
        payable
    {
        // Check that the caller is either the buyer or the seller
        require(
            msg.sender == buyer || msg.sender == seller,
            "Only buyer or seller can execute a stop-loss order"
        );
        // Check that the contract is in the correct state to execute a stop-loss order
        require(
            state == ContractState.Locked,
            "Contract is not in the correct state to execute a stop-loss order"
        );
        // Calculate the cost of the order based on the price and quantity of the contract
        uint256 cost = price * quantity;
        // Check that the trader has not exceeded the stop-loss price
        if (isBuyOrder) {
            require(
                price <= stopLoss,
                "Stop-loss price not reached for buy order"
            );
            // Calculate the new position size after executing the order
            uint256 newPositionSize = ((msg.value - cost) * leverage * price) /
                1 ether;
            // Check if a margin call has been triggered
            if (newPositionSize * price < marginCall * margin) {
                // Trigger a margin call if the new position size falls below the margin call level
                emit MarginCallTriggered(
                    msg.sender,
                    (newPositionSize * price) / margin
                );
            }
        } else {
            require(
                price >= stopLoss,
                "Stop-loss price not reached for sell order"
            );
            // Calculate the new position size after executing the order
            uint256 newPositionSize = ((msg.value + cost) * leverage * price) /
                1 ether;
            // Check if a margin call has been triggered
            if (newPositionSize * price < marginCall * margin) {
                // Trigger a margin call if the new position size falls below the margin call level
                emit MarginCallTriggered(
                    msg.sender,
                    (newPositionSize * price) / margin
                );
            }
        }
        // Emit the StopLossOrderExecuted event with the trader, quantity, and price as parameters
        emit StopLossOrderExecuted(msg.sender, quantity, price);
    }

    // Settle the contract by determining the winner and transferring the payout
    function settleContract() public {
        // Check that the contract is in the correct state to be settled
        require(
            state == ContractState.Locked,
            "Contract is not in the correct state to be settled"
        );
        // Calculate the payout based on the difference between the current price and the contract price
        uint256 payout = ((price - getPrice()) * quantity * leverage) / 1 ether;
        // Determine the winner based on the price of the underlying asset
        address winner = payout > 0 ? buyer : seller;
        // Transfer the payout to the winner
        payable(winner).transfer(payout);
        // Change the state of the contract to Inactive
        state = ContractState.Inactive;
        // Emit the ContractSettled event with the winner and payout as parameters
        emit ContractSettled(winner, payout);
    }

    function getPrice() public view returns (uint256) {
        (
            uint80 roundID,
            int256 price,
            uint256 startedAt,
            uint256 timeStamp,
            uint80 answeredInRound
        ) = priceFeed.latestRoundData();

        require(price > 0, "Price is not valid");
        return uint256(price);
    }

    // Terminate the contract and return the margin to the buyer
    function terminateContract() public {
        // Check that the contract is in the correct state to be terminated
        require(
            state == ContractState.Created || state == ContractState.Locked,
            "Contract is not in the correct state to be terminated"
        );
        // Check that the caller is the buyer
        require(
            msg.sender == buyer,
            "Only the buyer can terminate the contract"
        );
        // Transfer the margin back to the buyer
        payable(buyer).transfer(margin);
        // Change the state of the contract to Inactive
        state = ContractState.Inactive;
    }
}
