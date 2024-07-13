// SPDX-License-Identifier: UNLICENSED
// solhint-disable
pragma solidity ^0.8.13;

import {Help, Utils, Log} from "kr/utils/s/LibVm.s.sol";
import {ForkBase} from "s/base/ForkBase.s.sol";

contract kredfork is ForkBase {
    using Log for *;
    using Help for *;
    using Utils for *;

    function setUp() public virtual {
        super.base("MNEMONIC", "RPC_KREDITS_FORK");
    }

    function kredForkTx() public {
        broadcastWith(safe);
    }
}
