// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Option {
    struct CallOption {
        uint256 expiration;     // Option's expiration time
        uint256 strikePrice;    // The price at which the option can be exercised
        address underlying;    // Address of the underlying asset
        address seller;        // Address of the seller
        address buyer;         // Address of the buyer
        bool exercised;        // Whether the option has been exercised
    }

    mapping(uint256 => CallOption) public options;  // Stores all the options
    uint256 public nextOptionId;                    // ID for the next option

    // Creates a new option
    function createOption(
        uint256 _expiration,     // Expiration time
        uint256 _strikePrice,    // Strike price
        address _underlying,    // Address of the underlying asset
        address _buyer          // Address of the buyer
    ) external {
        options[nextOptionId] = CallOption({
            expiration: _expiration,
            strikePrice: _strikePrice,
            underlying: _underlying,
            seller: msg.sender,
            buyer: _buyer,
            exercised: false
        });
        nextOptionId++;
    }

    // Buyer exercises the option and pays the strike price to the seller
    function buyOption(uint256 _optionId) external payable {
        CallOption storage option = options[_optionId];
        require(msg.sender == option.buyer, "Only the buyer can buy the option");
        require(msg.value == option.strikePrice, "Must pay the strike price");
        require(block.timestamp < option.expiration, "Option has expired");
        require(!option.exercised, "Option has already been exercised");

        option.exercised = true;
        payable(option.seller).transfer(msg.value);
    }

    // Seller sells the option to a new buyer
    function sellOption(uint256 _optionId, address _newBuyer) external {
        CallOption storage option = options[_optionId];
        require(msg.sender == option.seller, "Only the seller can sell the option");
        require(!option.exercised, "Option has already been exercised");

        option.buyer = _newBuyer;
    }

    // Buyer buys the option with tokens and the tokens are transferred from buyer to the seller
    function buyTokenOption(uint256 _optionId, uint256 _amount) external {
        CallOption storage option = options[_optionId];
        require(msg.sender == option.buyer, "Only the buyer can buy the option");
        require(_amount == option.strikePrice, "Must pay the strike price");
        require(block.timestamp < option.expiration, "Option has expired");
        require(!option.exercised, "Option has already been exercised");

        IERC20(option.underlying).transferFrom(msg.sender, option.seller, _amount);
        option.exercised = true;
    }

    // Cancels an option, only the seller or buyer can cancel
    function cancelOption(uint256 _optionId) external {
        CallOption storage option = options[_optionId];
        require(
            msg.sender == option.seller || msg.sender == option.buyer,
            "Only the seller or buyer can cancel the option"
        );
        require(!option.exercised, "Option has already been exercised");

        delete options[_optionId];
    }

    // Changes the strike price of an option
    function changeStrikePrice(uint256 _optionId, uint256 _newStrikePrice)
        external
    {
        CallOption storage option = options[_optionId];
        require(msg.sender == option.seller, "Only the seller can change the strike price");
        require(!option.exercised, "Option has already been exercised");

        option.strikePrice = _newStrikePrice;
    }

    // Changes the expiration time of an option
    function changeExpiration(uint256 _optionId, uint256 _newExpiration)
        external
    {
        CallOption storage option = options[_optionId];
        require(msg.sender == option.seller, "Only the seller can change the expiration");
        require(!option.exercised, "Option has already been exercised");

        option.expiration = _newExpiration;
    }

    // Changes the underlying asset of an option
    function changeUnderlying(uint256 _optionId, address _newUnderlying)
        external
    {
        CallOption storage option = options[_optionId];
        require(msg.sender == option.seller, "Only the seller can change the underlying");
        require(!option.exercised, "Option has already been exercised");

        option.underlying = _newUnderlying;
    }
}
