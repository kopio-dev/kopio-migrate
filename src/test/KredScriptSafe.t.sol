// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Tested} from "kr/utils/Tested.t.sol";
import {KredScriptSafe} from "s/KredScriptSafe.s.sol";
import {Help, Log} from "kr/utils/Libs.s.sol";

contract KredScriptSafeTest is KredScriptSafe, Tested {
    using Log for *;
    using Help for *;

    uint256 safeBalBefore;
    uint256 accBalBefore;
    uint256 accBalAfter;

    function setUp() public override {
        super.setUp();
        safeBalBefore = SAFE_ADDRESS.balance;
        accBalBefore = sender.balance;
        execKredSafe();
    }

    function testKredScriptSafe() public {
        accBalAfter = sender.balance;
        assertLt(SAFE_ADDRESS.balance, safeBalBefore, "safe-bal-not-lt");
        assertGt(sender.balance, accBalBefore, "acc-bal-not-gt");
    }
}
