// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Tested} from "kr/utils/Tested.t.sol";
import {KreskoScriptSafe} from "s/KreskoScriptSafe.s.sol";
import {Help, Log} from "kr/utils/Libs.s.sol";

contract KreskoScriptSafeTest is KreskoScriptSafe, Tested {
    using Log for *;
    using Help for *;

    uint256 safeBalBefore;
    uint256 safeBalAfter;

    function setUp() public override {
        super.setUp();
        safeBalBefore = SAFE_ADDRESS.balance;
        execKreskoSafe();
    }

    function testKreskoScriptSafe() public {
        safeBalAfter = SAFE_ADDRESS.balance;
        assertLt(safeBalAfter, safeBalBefore, "safe-bal-not-lt");
        assertEq(kresko.getGatingManager(), address(0), "val-not-zero");
    }
}
