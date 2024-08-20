// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;
import {IPyth, PriceFeed} from "kopio/vendor/Pyth.sol";
import {IERC20} from "kopio/token/IERC20.sol";

contract PythUpdater {
    IPyth pythEP = IPyth(0xff1a0f4744e8582DF1aE09D5611b887B6a12925C);
    mapping(address => bool) public authorized;

    error Unauthorized(address);
    modifier auth() {
        if (!authorized[msg.sender]) revert Unauthorized(msg.sender);
        _;
    }

    constructor(address owner) payable {
        authorized[owner] = true;
    }

    function withdraw(address what, address to) external auth {
        if (what == address(0)) payable(to).transfer(address(this).balance);
        IERC20(what).transfer(to, IERC20(what).balanceOf(address(this)));
    }

    function setPythEP(address _pythEP) external auth {
        pythEP = IPyth(_pythEP);
    }

    function authorize(address user, bool isAuthorized) external auth {
        authorized[user] = isAuthorized;
    }

    function updatePriceFeeds(bytes[] calldata prices) external payable {
        pythEP.updatePriceFeeds{value: pythEP.getUpdateFee(prices)}(prices);
    }

    function parsePriceFeedUpdates(
        bytes[] calldata data,
        bytes32[] calldata ids,
        uint64 minTime,
        uint64 maxTime
    ) external payable returns (PriceFeed[] memory) {
        return
            pythEP.parsePriceFeedUpdates{value: pythEP.getUpdateFee(data)}(
                data,
                ids,
                minTime,
                maxTime
            );
    }

    function updatePriceFeedsIfNecessary(
        bytes[] calldata updateData,
        bytes32[] calldata priceIds,
        uint64[] calldata publishTimes
    ) external payable {
        pythEP.updatePriceFeedsIfNecessary{
            value: pythEP.getUpdateFee(updateData)
        }(updateData, priceIds, publishTimes);
    }

    receive() external payable {}
}
