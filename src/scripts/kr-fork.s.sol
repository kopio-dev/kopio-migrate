// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Help, Utils, Log} from "kr/utils/s/LibVm.s.sol";
import {ForkBase} from "./base/ForkBase.s.sol";

contract krfork is ForkBase {
    using Log for *;
    using Help for *;
    using Utils for *;

    function setUp() public virtual {
        super.base("MNEMONIC", "RPC_KRESKO_FORK");
        super.cutterBase(kreskoAddr, CreateMode.Create2);
    }

    function krForkTx() public {
        prepare();
        setupFork(Fork.UsableGated);
    }

    function prepare() internal broadcasted(safe) {}
}
