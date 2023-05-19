pragma solidity ^0.8.0;

contract FuturesContract {
    // Contract owner
    address public owner;
    // Service fee percentage
    uint256 public serviceFee;
    // User balances
    mapping(address => uint256) public balances;
    // Underlying asset prices
    mapping(string => uint256) public prices;
    // Trade records
    mapping(address => Trade[]) public trades;
    // Trade struct
    struct Trade {
        address buyer;
        address seller;
        string asset;
        uint256 price;
        uint256 quantity;
        uint256 timestamp;
    }

    // Offer struct
    struct Offer {
        address seller;
        string asset;
        uint256 price;
        uint256 quantity;
    }

    // Published offers
    Offer[] public offers;

    event TradeEvent(
        address indexed buyer,
        address indexed seller,
        string asset,
        uint256 price,
        uint256 quantity
    );

    constructor(uint256 _serviceFee) {
        owner = msg.sender;
        serviceFee = _serviceFee;
    }

    function setPrice(string memory asset, uint256 price) public {
        require(msg.sender == owner, "Only owner can set price");
        prices[asset] = price;
    }

    function getPrice(string memory asset) public view returns (uint256) {
        return prices[asset];
    }

    function trade(
        address buyer,
        address seller,
        string memory asset,
        uint256 quantity
    ) public {
        uint256 price = prices[asset];
        require(price > 0, "Asset not found");
        uint256 totalCost = price * quantity;
        require(balances[buyer] >= totalCost, "Insufficient balance");
        balances[buyer] -= totalCost;
        uint256 fee = (totalCost * serviceFee) / 100;
        balances[owner] += fee;
        balances[seller] += totalCost - fee;

        Trade memory trade = Trade(
            buyer,
            seller,
            asset,
            price,
            quantity,
            block.timestamp
        );
        trades[buyer].push(trade);
        trades[seller].push(trade);

        emit TradeEvent(buyer, seller, asset, price, quantity);
    }

    // Publish a new offer
    function publishOffer(
        string memory asset,
        uint256 price,
        uint256 quantity
    ) public {
        Offer memory offer = Offer(msg.sender, asset, price, quantity);
        offers.push(offer);
    }

    // Get a user's trade records
    function getTrades(address user) public view returns (Trade[] memory) {
        return trades[user];
    }

    // Deposit funds into the contract
    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    // Withdraw funds from the contract
    function withdraw(uint256 amount) public {
      require(balances[msg.sender] >= amount, "Insufficient balance");
      balances[msg.sender] -= amount;
      payable(msg.sender).transfer(amount);
  }
}
