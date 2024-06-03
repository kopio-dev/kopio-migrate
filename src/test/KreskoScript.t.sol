// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {KrBase} from "c/base/KrBase.s.sol";
import {Tested} from "kr/utils/Tested.t.sol";
import {Help, Log} from "kr/utils/Libs.s.sol";
import {KreskoScript} from "s/KreskoScript.s.sol";

contract KreskoScriptTest is KreskoScript, Tested {
    using Log for *;
    using Help for *;

    uint256 valBefore;
    uint256 valAfter;

    function setUp() public override {
        super.setUp();
        vm.deal(sender, 1 ether);

        valBefore = sender.balance;
        execKresko();
    }

    function testKreskoScript() public {
        valAfter = sender.balance;
        assertLt(valAfter, valBefore, "bal-not-lt");
    }
}
