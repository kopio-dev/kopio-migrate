// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Tested} from "kr/utils/Tested.t.sol";
import {KredScript} from "s/KredScript.s.sol";
import {Help, Log} from "kr/utils/Libs.s.sol";

contract KredScriptTest is KredScript, Tested {
    using Log for *;
    using Help for *;

    uint256 balBefore;
    uint256 balAfter;

    function setUp() public override {
        super.setUp();
        balBefore = kredits.balanceOf(sender);
        execKred();
    }

    function testKredScript() public {
        balAfter = kredits.balanceOf(sender);
        balAfter.clg("bal-after");
    }
}
