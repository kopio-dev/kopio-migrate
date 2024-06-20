// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Help, Log} from "kr/utils/Libs.s.sol";
import {ForkBase} from "c/base/ForkBase.s.sol";

contract krfork is ForkBase {
    using Log for *;
    using Help for *;

    function setUp() public virtual {
        super.base("MNEMONIC", "RPC_KRESKO_FORK");
        vm.prank(sender);
        pythUpdate();
    }

    function kreskoForkTx() public {
        setupFork(Fork.None);
    }
}
