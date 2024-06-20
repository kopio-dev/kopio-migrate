// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Tested} from "kr/utils/Tested.t.sol";
import {krfork, Log, Help} from "s/kr-fork.s.sol";

contract testkrfork is krfork, Tested {
    using Log for *;
    using Help for *;

    uint256 val;

    function setUp() public override {
        vm.deal(sender, 1 ether);
        super.setUp();
        kreskoForkTx();
    }

    function test1KrFork() public pranked(sender) {
        val = kresko.getPrice(krEURAddr);
        val.clg("val");
    }
}
