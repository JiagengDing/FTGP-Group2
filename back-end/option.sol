pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Option {
    struct CallOption {
        uint256 expiration;
        uint256 strikePrice;
        address underlying;
        address seller;
        address buyer;
        bool exercised;
    }

    mapping(uint256 => CallOption) public options;
    uint256 public nextOptionId;

    function createOption(
        uint256 _expiration,
        uint256 _strikePrice,
        address _underlying,
        address _buyer
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

    function buyOption(uint256 _optionId) external payable {
        CallOption storage option = options[_optionId];
        require(msg.sender == option.buyer, "Only the buyer can buy the option");
        require(msg.value == option.strikePrice, "Must pay the strike price");
        require(block.timestamp < option.expiration, "Option has expired");
        require(!option.exercised, "Option has already been exercised");

        option.exercised = true;
        payable(option.seller).transfer(msg.value);
    }

    function sellOption(uint256 _optionId, address _newBuyer) external {
        CallOption storage option = options[_optionId];
        require(msg.sender == option.seller, "Only the seller can sell the option");
        require(!option.exercised, "Option has already been exercised");

        option.buyer = _newBuyer;
    }

    function buyTokenOption(uint256 _optionId, uint256 _amount) external {
        CallOption storage option = options[_optionId];
        require(msg.sender == option.buyer, "Only the buyer can buy the option");
        require(_amount == option.strikePrice, "Must pay the strike price");
        require(block.timestamp < option.expiration, "Option has expired");
        require(!option.exercised, "Option has already been exercised");

        IERC20(option.underlying).transferFrom(msg.sender, option.seller, _amount);
        option.exercised = true;
    }

    function cancelOption(uint256 _optionId) external {
        CallOption storage option = options[_optionId];
        require(
            msg.sender == option.seller || msg.sender == option.buyer,
            "Only the seller or buyer can cancel the option"
        );
        require(!option.exercised, "Option has already been exercised");

        delete options[_optionId];
    }

    function changeStrikePrice(uint256 _optionId, uint256 _newStrikePrice)
        external
    {
        CallOption storage option = options[_optionId];
        require(msg.sender == option.seller, "Only the seller can change the strike price");
        require(!option.exercised, "Option has already been exercised");

        option.strikePrice = _newStrikePrice;
    }

    function changeExpiration(uint256 _optionId, uint256 _newExpiration)
        external
    {
        CallOption storage option = options[_optionId];
        require(msg.sender == option.seller, "Only the seller can change the expiration");
        require(!option.exercised, "Option has already been exercised");

        option.expiration = _newExpiration;
    }

    function changeUnderlying(uint256 _optionId, address _newUnderlying)
        external
    {
        CallOption storage option = options[_optionId];
        require(msg.sender == option.seller, "Only the seller can change the underlying");
        require(!option.exercised, "Option has already been exercised");

        option.underlying = _newUnderlying;
    }
}
