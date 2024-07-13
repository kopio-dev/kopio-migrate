// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Utils} from "kr/utils/Libs.sol";
import {PLog} from "kr/utils/s/PLog.s.sol";
import {ForkBase} from "./base/ForkBase.s.sol";

contract krfork is ForkBase {
    using PLog for *;
    using Utils for *;

    function setUp() public virtual {
        super.base("MNEMONIC", "RPC_KRESKO_FORK");
        super.cutterBase(kreskoAddr, CreateMode.Create2);
    }

    function krForkTx() public {
        prepare();
        setupFork(Fork.Usable);
    }

    function prepare() internal broadcasted(safe) {}
}
