// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "./IUniswapV2Router01.sol";

contract Manage is ERC20 {
    AggregatorV3Interface internal DAIpriceFeed;
    AggregatorV3Interface internal WBNBpriceFeed;
    AggregatorV3Interface internal WETHpriceFeed;

    IERC20 public DAI;
    IERC20 public WBNB;
    IERC20 public WETH;

    IUniswapV2Router01 public uniswapRouter;

    address public creator;
    uint256 public outstandingShare = 0;
    address public _DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    address public _WBNB = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;
    address public _WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    constructor(
        string memory _Portfolio_Name,
        string memory _symbol
    
    ) ERC20(_Portfolio_Name, _symbol) {
        DAI = IERC20(_DAI);
        WBNB = IERC20(_WBNB);
        WETH = IERC20(_WETH);

        // Set the addresses for the Chainlink Price Feeds
        DAIpriceFeed = AggregatorV3Interface(_DAI); // Replace with the correct address
        WBNBpriceFeed = AggregatorV3Interface(_WBNB); // Replace with the correct address
        WETHpriceFeed = AggregatorV3Interface(_WETH); // Replace with the correct address

        // Set the address for the Uniswap Router
        uniswapRouter = IUniswapV2Router01(0xf164fC0Ec4E93095b804a4795bBe1e041497b92a); // Replace with the correct address

        creator = msg.sender;
    }

        function createNewPortfolio(uint256[3] memory percentages, uint256 ethAmount) external payable {
        require(msg.sender == creator, "Only the creator can call this function.");
        require(msg.value == ethAmount, "The sent ether amount must match the specified ethAmount.");
        uint256 buy_value = ethAmount;

        (, int256 DAIPrice, , , ) = DAIpriceFeed.latestRoundData();
        (, int256 WBNBPrice, , , ) = WBNBpriceFeed.latestRoundData();
        (, int256 WETHPrice, , , ) = WETHpriceFeed.latestRoundData();

        uint256 V_DAI = uint256(DAIPrice);
        uint256 V_WBNB = uint256(WBNBPrice);
        uint256 V_WETH = uint256(WETHPrice);

        uint256 n = buy_value / (V_DAI * percentages[0] + V_WBNB * percentages[1] + V_WETH * percentages[2]);

        uint deadline = block.timestamp + 300; // 5 minutes

        uniswapRouter.swapExactETHForTokens{value: msg.value * percentages[0] / 100}(
            n * percentages[0],
            getPathForETHToToken(address(DAI)),
            msg.sender,
            deadline
        );

        uniswapRouter.swapExactETHForTokens{value: msg.value * percentages[1] / 100}(
            n * percentages[1],
            getPathForETHToToken(address(WBNB)),
            msg.sender,
            deadline
        );

        uniswapRouter.swapExactETHForTokens{value: msg.value * percentages[2] / 100}(
            n * percentages[2],
            getPathForETHToToken(address(WETH)),
            msg.sender,
            deadline
        );

        // Mint new tokens and send them to the creator
        _mint(msg.sender, 1000);
        outstandingShare += 1000;
    }


    function getPathForETHToToken(address token) private view returns (address[] memory) {
        address[] memory path = new address[](2);
        path[0] = uniswapRouter.WETH();
        path[1] = token;

        return path;
    }
}
