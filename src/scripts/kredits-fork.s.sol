// SPDX-License-Identifier: UNLICENSED
// solhint-disable
pragma solidity ^0.8.13;

import {Utils} from "kr/utils/Libs.sol";
import {PLog} from "kr/utils/s/PLog.s.sol";
import {ForkBase} from "s/base/ForkBase.s.sol";

contract kredfork is ForkBase {
    using PLog for *;
    using Utils for *;

    function setUp() public virtual {
        super.base("MNEMONIC", "RPC_KREDITS_FORK");
    }

    function kredForkTx() public {
        broadcastWith(safe);
    }
}
