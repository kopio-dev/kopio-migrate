// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Tested} from "kr/utils/Tested.t.sol";
import {kredfork, Help, Log} from "s/kredits-fork.s.sol";

contract testkredfork is kredfork, Tested {
    using Log for *;
    using Help for *;

    uint256 balBefore;
    uint256 balAfter;

    function setUp() public override {
        super.setUp();
        balBefore = kredits.balanceOf(sender);
        kredForkTx();
    }

    function test4KredFork() public pranked(sender) {
        balAfter = kredits.balanceOf(sender);
        balAfter.clg("bal-after");
    }
}
