// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract Option {
    address owner;
    address buyer;
    uint256 strikePrice;
    uint256 expirationTime;
    uint256 underlyingAssetAmount;
    bool exercised;

    constructor(address _owner, address _buyer, uint256 _strikePrice, uint256 _expirationTime, uint256 _underlyingAssetAmount) {
        owner = _owner;
        buyer = _buyer;
        strikePrice = _strikePrice;
        expirationTime = _expirationTime;
        underlyingAssetAmount = _underlyingAssetAmount;
    }

    function exercise() public {

    }

    function cancel() public {

    }
}
