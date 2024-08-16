// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Utils} from "kopio/utils/Libs.sol";
import {PLog} from "kopio/vm/PLog.s.sol";
import {ForkBase} from "./base/ForkBase.s.sol";

contract fork is ForkBase {
    using PLog for *;
    using Utils for *;

    function setUp() public virtual {
        super.base("MNEMONIC_KOPIO", "arbitrum");
        super.cutterBase(protocolAddr, CreateMode.Create2);
    }

    function forkTx() public {
        prepare();
        setupFork(Fork.Usable);
    }

    function prepare() internal broadcasted(safe) {}
}
