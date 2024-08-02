// SPDX-License-Identifier: UNLICENSED
// solhint-disable
pragma solidity ^0.8.13;

import {Utils} from "kr/utils/Libs.sol";
import {PLog} from "kr/vm/PLog.s.sol";
import {KrBase} from "s/base/KrBase.s.sol";

contract kred is KrBase {
    using PLog for *;
    using Utils for *;

    function setUp() public virtual {
        super.base("MNEMONIC");
        createSelectFork("KREDITS_NETWORK");
    }

    function kredTx() public {}
}
