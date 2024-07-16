// SPDX-License-Identifier: UNLICENSED
// solhint-disable
pragma solidity ^0.8.13;

import {Utils} from "kr/utils/Libs.sol";
import {PLog} from "kr/utils/s/PLog.s.sol";
import {KrBase} from "s/base/KrBase.s.sol";

contract kr is KrBase {
    using PLog for *;
    using Utils for *;

    function setUp() public virtual {
        base("MNEMONIC", "RPC_ARBITRUM_ALCHEMY");
    }

    function krTx() public {}
}
