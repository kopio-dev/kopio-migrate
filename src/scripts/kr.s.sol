// SPDX-License-Identifier: UNLICENSED
// solhint-disable
pragma solidity ^0.8.13;

import {Help, Utils, Log} from "kr/utils/s/LibVm.s.sol";
import {KrBase} from "s/base/KrBase.s.sol";

contract kr is KrBase {
    using Log for *;
    using Help for *;
    using Utils for *;

    function setUp() public virtual {
        base("MNEMONIC", "RPC_ARBITRUM_ALCHEMY");
    }

    function krTx() public broadcasted(sender) returns (address) {}
}
