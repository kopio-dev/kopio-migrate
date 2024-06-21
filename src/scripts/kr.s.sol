// SPDX-License-Identifier: UNLICENSED
// solhint-disable
pragma solidity ^0.8.13;

import {Help, Log} from "kr/utils/Libs.s.sol";
import {KrBase} from "s/base/KrBase.s.sol";

contract kr is KrBase {
    using Log for *;
    using Help for *;

    function setUp() public virtual {
        super.base("MNEMONIC", "KRESKO_NETWORK");
    }

    function krTx() public broadcasted(sender) {}
}
