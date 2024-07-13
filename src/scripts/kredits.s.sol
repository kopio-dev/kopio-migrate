// SPDX-License-Identifier: UNLICENSED
// solhint-disable
pragma solidity ^0.8.13;

import {Help, Utils, Log} from "kr/utils/s/LibVm.s.sol";
import {KrBase} from "s/base/KrBase.s.sol";

contract kred is KrBase {
    using Log for *;
    using Help for *;
    using Utils for *;

    function setUp() public virtual {
        super.base("MNEMONIC");
        createSelectFork("KREDITS_NETWORK");
    }

    function kredTx() public {}
}
