// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Tested} from "kr/utils/Tested.t.sol";
import {KredScriptFork} from "s/KredScriptFork.s.sol";
import {Help, Log} from "kr/utils/Libs.s.sol";

contract KredScriptForkTest is KredScriptFork, Tested {
    using Log for *;
    using Help for *;

    uint256 balBefore;
    uint256 balAfter;

    function setUp() public override {
        super.setUp();
        balBefore = kredits.balanceOf(sender);
        execKredFork();
    }

    function testKredScripFork() public {
        balAfter = kredits.balanceOf(sender);
        balAfter.clg("bal-after");
    }
}
