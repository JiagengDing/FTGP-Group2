// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

<<<<<<< HEAD
// Import Chainlink related contracts
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
    
    // New: Chainlink oracle-related variable
    AggregatorV3Interface internal priceFeed;
   
    // New: Mapping to store trade records for each trader
    mapping(address => Trade[]) public trades;
    
    // New: Struct to store trade records
    struct Trade {
        uint256 timestamp;
        uint256 quantity;
        uint256 price;
        bool isBuyOrder;
    }
=======
<<<<<<< HEAD
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
=======
contract FuturesContract {
    address public buyer; // address of the buyer
    address public seller; // address of the seller
    uint public price; // price of the futures contract
    uint public quantity; // quantity of the underlying asset
    uint public expiration; // expiration date of the contract
    uint public margin; // margin required to open a position
    uint public leverage; // leverage ratio of the position
    uint public stopLoss; // price at which a stop-loss order is triggered
    uint public marginCall; // margin level at which a margin call is triggered
>>>>>>> f021acf (Add files via upload)
>>>>>>> aaf2fd94d0fbd4c335cf2c3cee7ac922e50e9ed4

    // Define the state of the contract using an enum
    enum ContractState {
        Created, // the contract has been created but not yet locked
        Locked, // the contract has been locked and is active
        Inactive // the contract has expired, been settled or terminated
    }
    ContractState public state;

    // Define the events of the contract
    event ContractLocked();
<<<<<<< HEAD
    event ContractSettled(address indexed winner, uint256 payout);
    event MarketOrderExecuted(address indexed trader, uint256 quantity, uint256 price, bool isBuyOrder);
    event StopLossOrderExecuted(address indexed trader, uint256 quantity, uint256 price, bool isBuyOrder);
    event MarginCallTriggered(address indexed trader, uint256 marginLevel);
    
=======
<<<<<<< HEAD
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
=======
    event ContractSettled(address indexed winner, uint payout);
    event MarketOrderExecuted(address indexed trader, uint quantity, uint price);
    event StopLossOrderExecuted(address indexed trader, uint quantity, uint price);
    event MarginCallTriggered(address indexed trader, uint marginLevel);
>>>>>>> f021acf (Add files via upload)

>>>>>>> aaf2fd94d0fbd4c335cf2c3cee7ac922e50e9ed4
    // Define the constructor to initialize the contract parameters
    constructor(
        address _buyer, // address of the buyer
        address _seller, // address of the seller
<<<<<<< HEAD
=======
<<<<<<< HEAD
>>>>>>> aaf2fd94d0fbd4c335cf2c3cee7ac922e50e9ed4
        uint256 _price, // price of the futures contract
        uint256 _quantity, // quantity of the underlying asset
        uint256 _expiration, // expiration date of the contract
        uint256 _margin, // margin required to open a position
        uint256 _leverage, // leverage ratio of the position
        uint256 _stopLoss, // price at which a stop-loss order is triggered
        uint256 _marginCall // margin level at which a margin call is triggered
<<<<<<< HEAD
        address _priceFeedAddress // New: Chainlink oracle address parameter
=======
=======
        uint _price, // price of the futures contract
        uint _quantity, // quantity of the underlying asset
        uint _expiration, // expiration date of the contract
        uint _margin, // margin required to open a position
        uint _leverage, // leverage ratio of the position
        uint _stopLoss, // price at which a stop-loss order is triggered
        uint _marginCall // margin level at which a margin call is triggered
>>>>>>> f021acf (Add files via upload)
>>>>>>> aaf2fd94d0fbd4c335cf2c3cee7ac922e50e9ed4
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
<<<<<<< HEAD
        
        // New: Initialize Chainlink oracle
        priceFeed = AggregatorV3Interface(_priceFeedAddress);
=======
<<<<<<< HEAD
        priceFeed = AggregatorV3Interface(chainlinkOracleAddress);
=======
>>>>>>> f021acf (Add files via upload)
>>>>>>> aaf2fd94d0fbd4c335cf2c3cee7ac922e50e9ed4
    }

    // Lock the contract to activate it and open a position
    function lockContract() public payable {
        // Check that the caller is the buyer or the seller
<<<<<<< HEAD
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
=======
        require(msg.sender == buyer || msg.sender == seller, "Only buyer or seller can lock the contract");
        // Check that the contract is in the correct state to be locked
        require(state == ContractState.Created, "Contract is not in the correct state to be locked");
        // Check that the margin is sufficient to open a position
        require(msg.value >= margin, "Insufficient margin to open a position");
        // Calculate the amount of the underlying asset that can be bought with the margin and leverage
<<<<<<< HEAD
        uint256 positionSize = (msg.value * leverage * price) / 1 ether;
=======
        uint positionSize = (msg.value * leverage * price) / 1 ether;
>>>>>>> f021acf (Add files via upload)
>>>>>>> aaf2fd94d0fbd4c335cf2c3cee7ac922e50e9ed4
        // Change the state of the contract to Locked
        state = ContractState.Locked;
        // Emit the ContractLocked event
        emit ContractLocked();
    }

    // Execute a market order to buy or sell the underlying asset
<<<<<<< HEAD
    function executeMarketOrder(bool isBuyOrder, uint256 orderQuantity) public payable {
=======
<<<<<<< HEAD
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
=======
    function executeMarketOrder(bool isBuyOrder, uint quantity) public payable {
>>>>>>> aaf2fd94d0fbd4c335cf2c3cee7ac922e50e9ed4
        // Check that the caller is either the buyer or the seller
        require(msg.sender == buyer || msg.sender == seller, "Only buyer or seller can execute a market order");
        // Check that the contract is in the correct state to execute a market order
        require(state == ContractState.Locked, "Contract is not in the correct state to execute a market order");
        // Calculate the cost of the order based on the price and quantity of the contract
        
        uint256 currentPrice = getPrice();
        uint256 cost = price * quantity;
        
        // Check that the trader has sufficient funds or assets to execute the order
        if (isBuyOrder) {
            require(msg.sender == buyer, "Only the buyer can execute a buy order");
            require(msg.value >= cost, "Insufficient funds to execute the buy order");
            // Calculate the new position size after executing the order
            uint256 newPositionSize = ((msg.value - cost) * leverage * price) / 1 ether;
            // Check if a margin call has been triggered
            if (newPositionSize * price < marginCall * margin) {
                // Trigger a margin call if the new position size falls below the margin call level
                emit MarginCallTriggered(msg.sender, newPositionSize * price / margin);
            }
        } else {
            require(msg.sender == seller, "Only the seller can execute a sell order");
            require(quantity <= quantity - (msg.value / price), "Insufficient assets to execute the sell order");
            // Calculate the new position size after executing the order
            uint256 newPositionSize = ((msg.value + cost) * leverage * price) / 1 ether;
            // Check if a margin call has been triggered
            if (newPositionSize * price < marginCall * margin) {
                // Trigger a margin call if the new position size falls below the margin call level
                emit MarginCallTriggered(msg.sender, newPositionSize * price / margin);
>>>>>>> f021acf (Add files via upload)
            }
        }
        // Emit the MarketOrderExecuted event with the trader, quantity, and price as parameters
        emit MarketOrderExecuted(msg.sender, quantity, price);
    }
        
        // Add the executed trade to the trade history and emit the MarketOrderExecuted event
        Trade memory newTrade = Trade({
            timestamp: block.timestamp,
            quantity: orderQuantity,
            price: currentPrice,
            isBuyOrder: isBuyOrder
        });

        trades[msg.sender].push(newTrade);

        emit MarketOrderExecuted(msg.sender, orderQuantity, currentPrice, isBuyOrder);
    }

    // Execute a stop-loss order to limit potential losses
<<<<<<< HEAD
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
=======
    function executeStopLossOrder(bool isBuyOrder, uint quantity) public payable{
        // Check that the caller is either the buyer or the seller
        require(msg.sender == buyer || msg.sender == seller, "Only buyer or seller can execute a stop-loss order");
        // Check that the contract is in the correct state to execute a stop-loss order
        require(state == ContractState.Locked, "Contract is not in the correct state to execute a stop-loss order");
        // Calculate the cost of the order based on the price and quantity of the contract
        
        uint256 currentPrice = getPrice();
        uint256 cost = currentPrice * orderQuantity;
        
        // Check that the trader has not exceeded the stop-loss price
        if (isBuyOrder) {
            require(currentPrice <= stopLoss, "Stop-loss price not reached for buy order");
            // Calculate the new position size after executing the order
            uint256 newPositionSize = ((msg.value - cost) * leverage * price) / 1 ether;
            // Check if a margin call has been triggered
            if (newPositionSize * currentPrice < marginCall * margin) {
                // Trigger a margin call if the new position size falls below the margin call level
                emit MarginCallTriggered(msg.sender, newPositionSize * price / margin);
            }
        } else {
            require(currentPrice >= stopLoss, "Stop-loss price not reached for sell order");
            // Calculate the new position size after executing the order
            
            uint256 newPositionSize = ((msg.value + cost) * leverage * price) / 1 ether;
            // Check if a margin call has been triggered
            if (newPositionSize * currentPrice < marginCall * margin) {
                // Trigger a margin call if the new position size falls below the margin call level
                emit MarginCallTriggered(msg.sender, newPositionSize * price / margin);
>>>>>>> f021acf (Add files via upload)
            }
        }
        
        Trade memory newTrade = Trade({
            timestamp: block.timestamp,
            quantity: orderQuantity,
            price: currentPrice,
            isBuyOrder: isBuyOrder
        });

        trades[msg.sender].push(newTrade);
        
        // Emit the StopLossOrderExecuted event with the trader, quantity, and price as parameters
        emit StopLossOrderExecuted(msg.sender, quantity, price);
    }

    // Settle the contract by determining the winner and transferring the payout
    function settleContract() public {
        // Check that the contract is in the correct state to be settled
<<<<<<< HEAD
        require(
            state == ContractState.Locked,
            "Contract is not in the correct state to be settled"
        );
        // Calculate the payout based on the difference between the current price and the contract price
        uint256 payout = ((price - getPrice()) * quantity * leverage) / 1 ether;
=======
        require(state == ContractState.Locked, "Contract is not in the correct state to be settled");
        // Calculate the payout based on the difference between the current price and the contract price
<<<<<<< HEAD
        
        uint256 currentPrice = getPrice();
        uint256 payout = ((price - currentPrice) * quantity * leverage) / 1 ether;
        
=======
        uint payout = ((price - getPrice()) * quantity * leverage) / 1 ether;
>>>>>>> f021acf (Add files via upload)
>>>>>>> aaf2fd94d0fbd4c335cf2c3cee7ac922e50e9ed4
        // Determine the winner based on the price of the underlying asset
        address winner = payout > 0 ? buyer : seller;
        // Transfer the payout to the winner
        payable(winner).transfer(payout);
        
        // Change the state of the contract to Inactive
        state = ContractState.Inactive;
        // Emit the ContractSettled event with the winner and payout as parameters
        emit ContractSettled(winner, payout);
    }

<<<<<<< HEAD
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
=======
    // Get the current price of the underlying asset
<<<<<<< HEAD
    function getPrice() public view returns (uint256) {
        (
            uint80 roundID,
            int256 answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
        ) = priceFeed.latestRoundData();

        require(answer > 0, "Invalid price");

        return uint256(answer);
=======
    function getPrice() public view returns (uint) {
        // This function would query an oracle or other external data source to get the current price of the asset
        // For simplicity, we're just returning a random number between 1 and 1000
        return uint(keccak256(abi.encodePacked(block.timestamp))) % 1000 + 1;
>>>>>>> f021acf (Add files via upload)
>>>>>>> aaf2fd94d0fbd4c335cf2c3cee7ac922e50e9ed4
    }

    // Terminate the contract and return the margin to the buyer
    function terminateContract() public {
        // Check that the contract is in the correct state to be terminated
<<<<<<< HEAD
        require(
            state == ContractState.Created || state == ContractState.Locked,
            "Contract is not in the correct state to be terminated"
        );
        // Check that the caller is the buyer
        require(
            msg.sender == buyer,
            "Only the buyer can terminate the contract"
        );
=======
        require(state == ContractState.Created || state == ContractState.Locked, "Contract is not in the correct state to be terminated");
        // Check that the caller is the buyer
        require(msg.sender == buyer, "Only the buyer can terminate the contract");
>>>>>>> f021acf (Add files via upload)
        // Transfer the margin back to the buyer
        payable(buyer).transfer(margin);
        // Change the state of the contract to Inactive
        state = ContractState.Inactive;
    }
<<<<<<< HEAD
    
    function getTradeHistory(address trader) public view returns (Trade[] memory) {
        return trades[trader];
    }
=======
<<<<<<< HEAD
}
=======
}
>>>>>>> f021acf (Add files via upload)
>>>>>>> aaf2fd94d0fbd4c335cf2c3cee7ac922e50e9ed4
