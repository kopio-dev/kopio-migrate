// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import {PythView} from "kopio/vendor/Pyth.sol";

interface ISupport {
    struct TVL {
        uint256 total;
        uint256 diamond;
        uint256 vkiss;
        uint256 wraps;
    }
    struct TVLDec {
        string total;
        string diamond;
        string vkiss;
        string wraps;
    }

    function getTVL(PythView calldata) external view returns (TVL memory);

    function getTVL() external view returns (TVL memory);

    function getTVLDec() external view returns (TVLDec memory);

    function getTVLDec(PythView calldata) external view returns (TVLDec memory);
}
