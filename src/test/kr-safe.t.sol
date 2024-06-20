// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Tested} from "kr/utils/Tested.t.sol";
import {krsafe, Help, Log} from "s/kr-safe.s.sol";

contract testkrsafe is krsafe, Tested {
    using Log for *;
    using Help for *;

    function setUp() public override {
        super.setUp();
        kreskoSafeTx();

        vm.prank(sender);
        pythUpdate();
    }

    function test2KrSafe() public pranked(sender) {
        assertEq(true, true, "nope");
    }
}
