// SPDX-License-Identifier:MIT
pragma solidity ^0.8.20;

// Introduce the standard IERC20 interface to instantiate the underlying assets (ERC20).
// Only after instantiation, ERC20 token methods can be called
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Option {

    // Option structure
    struct CallOption {
        // Expiration time
        uint256 expiration;
        // Exercise price
        uint256 strikePrice;
        // Asset address (ERC20 token address)
        address underlying;
        // Seller address
        address seller;
        // Buyer address
        address buyer;
        // Whether the option has been exercised
        bool exercised;
    }

    mapping(uint256 => CallOption) public options;

    // ID
    uint256 public nextOptionId;

    // Create option
    function createOption(
        // Expiration time
        uint256 _expiration,
        // Exercise price
        uint256 _strikePrice,
        // Asset address
        address _underlying,
        // Buyer address
        address _buyer
    ) external {
        // Store the parameters in the map
        options[nextOptionId] = CallOption({
            expiration: _expiration,
            strikePrice: _strikePrice,
            underlying: _underlying,
            // 
            seller: msg.sender,
            buyer: _buyer,
            // No option used by default
            exercised: false
        });

        // Option ID auto-increment
        nextOptionId++;
    }

    // The buyer exercises the option with ETH
    // The buyer pays the exercise price to the seller
    // Parameter: Option ID
	function buyOption(uint256 _optionId) external payable {
        
		CallOption storage option = options[_optionId];

        // Only the buyer specified in the option can  purchase
		require(msg.sender == option.buyer, "Only the buyer can buy the option");
        // The exercise price must be paid
		require(msg.value == option.strikePrice * 1e18, "Must pay the strike price");
        // Options cannot have expired
		require(block.timestamp < option.expiration, "Option has expired");
        // Options must be unexercised
		require(!option.exercised, "Option has already been exercised");

        // Mark this option as exercised
		option.exercised = true;

        // Buyer Payment
		payable(option.seller).transfer(msg.value);
	}

	// The seller re-sells the option to a new buyer
    // Parameters: Option ID, new buyer
	function sellOption(uint256 _optionId, address _newBuyer) external {
		CallOption storage option = options[_optionId];

        // Sellers can only amend own options
		require(msg.sender == option.seller, "Only the seller can sell the option");
        // Options must be unexercised
		require(!option.exercised, "Option has already been exercised");

        // Change to a new buyer
		option.buyer = _newBuyer;
	}

	// Buyers exercise options with tokens
    // Parameters: Option ID, number of tokens
	function buyTokenOption(uint256 _optionId, uint256 _amount) external {
		CallOption storage option = options[_optionId];

		require(msg.sender == option.buyer, "Only the buyer can buy the option");
		require(_amount == option.strikePrice, "Must pay the strike price");
		require(block.timestamp < option.expiration, "Option has expired");
		require(!option.exercised, "Option has already been exercised");
        // Check the buyer that the amount authorised for the contract is sufficient
        uint256 allowance = IERC20(option.underlying).allowance(msg.sender, address(this));
        require(allowance >= _amount, "Not enough tokens approved for transferFrom");

        // Instantiate the token address with the IERC20 interface 
        //then call the transferFrom method of the underlying ERC20 asset
        // Payment in tokens on behalf of buyers
		IERC20(option.underlying).transferFrom(msg.sender, option.seller, _amount);
        // Mark option exercised
		option.exercised = true;
	}

	// Cancel options
    // Options are not exercised and can be cancelled at the option of the buyer and seller
	function cancelOption(uint256 _optionId) external {
        
		CallOption storage option = options[_optionId];

        // Only the buyer and seller can cancel the option
		require(
			msg.sender == option.seller || msg.sender == option.buyer,
			"Only the seller or buyer can cancel the option"
		);
        // Options must be unexercised
		require(!option.exercised, "Option has already been exercised"); 

        // Delete options
		delete options[_optionId];
	}

	// Sellers modify the exercise price of options
	function changeStrikePrice(uint256 _optionId, uint256 _newStrikePrice) external {
        
		CallOption storage option = options[_optionId];
        // Only the seller can change the strike price
		require(msg.sender == option.seller, "Only the seller can change the strike price");
        
		require(!option.exercised, "Option has already been exercised");

        // Update price
		option.strikePrice = _newStrikePrice;
	}

	// Sellers change the expiry time of options
	function changeExpiration(uint256 _optionId, uint256 _newExpiration) external {
		CallOption storage option = options[_optionId];
		require(msg.sender == option.seller, "Only the seller can change the expiration");
		require(!option.exercised, "Option has already been exercised");

		option.expiration = _newExpiration; // Update price
	}

	// Sellers modify the underlying asset of an option
	function changeUnderlying(uint256 _optionId, address _newUnderlying) external {
		CallOption storage option = options[_optionId];
		require(msg.sender == option.seller, "Only the seller can change the underlying");
		require(!option.exercised, "Option has already been exercised");

		option.underlying = _newUnderlying;
	}

    // Check list of pending exercises
    function getUnexercisedOptions() external view returns(CallOption[] memory){

        uint count = 0;
        for (uint i = 0; i < nextOptionId; i++) {
            if (options[i].buyer == msg.sender && options[i].exercised == false) {
                count++;
            }
        }

        CallOption[] memory optionList = new CallOption[](count);
        uint index = 0;

        for (uint i = 0; i < nextOptionId; i++) {
            if (options[i].buyer == msg.sender && options[i].exercised == false) {
                optionList[index] = options[i];
                index++;
            }
        }

        return optionList;
    }

    // Check list of exercised rights
    // Take a list of all options where the buyer is me and has paid
    function getExercisedOptions() external view returns(CallOption[] memory){

        // Find out the number of my exercised list
        uint count = 0;
        for (uint i = 0; i < nextOptionId; i++) {
            if (options[i].buyer == msg.sender && options[i].exercised == true) {
                count++;
            }
        }

        // Create a fixed-length array
        CallOption[] memory optionList = new CallOption[](count);
        uint index = 0;

        // Assigning data to fixed-length arrays
        for (uint i = 0; i < nextOptionId; i++) {
            if (options[i].buyer == msg.sender && options[i].exercised == true) {
                optionList[index] = options[i];
                index++;
            }
        }

        return optionList;
    }

    // Check the list of options I have created
    function getCreatedOptions() external view returns(CallOption[] memory){

        uint count = 0;
        for (uint i = 0; i < nextOptionId; i++) {
            if (options[i].seller == msg.sender) {
                count++;
            }
        }

        CallOption[] memory optionList = new CallOption[](count);
        uint index = 0;

        for (uint i = 0; i < nextOptionId; i++) {
            if (options[i].seller == msg.sender) {
                optionList[index] = options[i];
                index++;
            }
        }

        return optionList;
    }
}
