// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./Manage.sol";
import "./SimpleERC20Token.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "./IUniswapV2Router01.sol";



contract Trade {
    Manage public manageInstance;
    IERC20 public DAI;
    IERC20 public WBNB;
    IERC20 public WETH;
    IUniswapV2Router01 public uniswapRouter;
    address public tokenAddress;
    SimpleERC20Token public tokenInstance;

    constructor(
        address _manageAddress,
        address _DAI,
        address _WBNB,
        address _WETH,
        address _uniswapRouter,
        address _tokenAddress
    ) {
        manageInstance = Manage(_manageAddress);
        DAI = IERC20(_DAI);
        WBNB = IERC20(_WBNB);
        WETH = IERC20(_WETH);
        uniswapRouter = IUniswapV2Router01(_uniswapRouter);
        tokenAddress = _tokenAddress;
        tokenInstance = SimpleERC20Token(_tokenAddress);
    }
        
        function buy(uint256 buy_value) public payable {
           
            require(msg.sender != manageInstance.creator(), "Caller is the creator");

            // Get the latest prices from Chainlink
            uint256 V_DAI = uint256(manageInstance.getPriceFeedDAI().latestAnswer());
            uint256 V_WBNB = uint256(manageInstance.getPriceFeedWBNB().latestAnswer());
            uint256 V_WETH = uint256(manageInstance.getPriceFeedWETH().latestAnswer());

            uint256 a = manageInstance.a();
            uint256 b = manageInstance.b();
            uint256 c = manageInstance.c();

            uint256 n = buy_value / (V_DAI * a + V_WBNB * b + V_WETH * c);
            uint256 A_1 = n * a;
            uint256 B_1 = n * b;
            uint256 C_1 = n * c;

            uint256 outstandingShare = manageInstance.outstandingShare();
            uint256 A = manageInstance.A();
            uint256 New_Share = A_1 * outstandingShare / A;

            // Update outstanding shares
            manageInstance.setOutstandingShare(outstandingShare + New_Share);

            // Use Uniswap to swap ETH for DAI, WBNB, and WETH
            uint deadline = block.timestamp + 300; // 5 minutes

            uniswapRouter.swapExactETHForTokens{value: msg.value * a / 100}(
                A_1,
                getPathForETHToToken(address(DAI)),
                msg.sender,
                deadline
            );

            uniswapRouter.swapExactETHForTokens{value: msg.value * b / 100}(
                B_1,
                getPathForETHToToken(address(WBNB)),
                msg.sender,
                deadline
            );

            uniswapRouter.swapExactETHForTokens{value: msg.value * c / 100}(
                C_1,
                getPathForETHToToken(address(WETH)),
                msg.sender,
                deadline
            );

            // Mint new tokens and transfer to user1's MetaMask wallet
            tokenInstance.mint(msg.sender, New_Share);
        }

        function getPathForETHToToken(address token) private view returns (address[] memory) {
            address[] memory path = new address[](2);
            path[0] = uniswapRouter.WETH();
            path[1] = token;

            return path;
        }
}
