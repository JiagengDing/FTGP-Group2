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
    }
}
