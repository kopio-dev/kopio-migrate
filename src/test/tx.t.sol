// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Tested} from "kopio/vm/Tested.t.sol";
import {ktx, Utils} from "s/tx.s.sol";
import {Log} from "kopio/vm/VmLibs.s.sol";

contract testktx is ktx, Tested {
    using Log for *;
    using Utils for *;

    function setUp() public override {
        super.setUp();
        prank(sender);
        kopioTx();
    }

    function test4Ktx() public pranked(sender) {}
}
