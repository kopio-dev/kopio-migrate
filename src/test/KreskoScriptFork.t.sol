// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Tested} from "kr/utils/Tested.t.sol";
import {KreskoScriptFork} from "s/KreskoScriptFork.s.sol";
import {Help, Log} from "kr/utils/Libs.s.sol";

contract KreskoScriptForkTest is KreskoScriptFork, Tested {
    using Log for *;
    using Help for *;

    uint256 val;

    function setUp() public override {
        vm.deal(sender, 1 ether);
        super.setUp();
        execKreskoFork();
    }

    function testKreskoScriptFork() public {
        val = kresko.getPrice(krEURAddr);
        val.clg("val");
    }
}
