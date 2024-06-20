// SPDX-License-Identifier: UNLICENSED
// solhint-disable
pragma solidity ^0.8.13;

import {Help, Log} from "kr/utils/Libs.s.sol";
import {ForkBase} from "c/base/ForkBase.s.sol";

contract kredfork is ForkBase {
    using Log for *;
    using Help for *;

    function setUp() public virtual {
        super.base("MNEMONIC", "RPC_KREDITS_FORK");
    }

    function kredForkTx() public {
        broadcastWith(safe);
    }
}
