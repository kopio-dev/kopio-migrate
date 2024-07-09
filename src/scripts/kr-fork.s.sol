// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Help, Log} from "kr/utils/s/LibVm.s.sol";
import {ForkBase} from "./base/ForkBase.s.sol";
import {IGatingManager} from "kr/core/States.sol";

contract krfork is ForkBase {
    using Log for *;
    using Help for *;

    bytes32 merkleRoot =
        0x6b79a7e683ff11153cef52b66d8989d356db68328c06a33e3af8fe22beada82c;

    function setUp() public virtual {
        super.base("MNEMONIC", "RPC_KRESKO_FORK");
        super.cutterBase(kreskoAddr, CreateMode.Create2);
    }

    function krForkTx() public {
        prepare();
        setupFork(Fork.UsableGated);
    }

    function prepare() internal broadcasted(safe) {
        IGatingManager(kresko.getGatingManager()).setPhase(0);
    }
}
