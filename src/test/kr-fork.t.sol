// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Tested} from "kr/vm/Tested.t.sol";
import {krfork, PLog, Utils} from "s/kr-fork.s.sol";
import {tbytes} from "kr/utils/TBytes.sol";

contract testkrfork is krfork, Tested {
    using PLog for *;
    using Utils for *;

    function setUp() public override {
        super.setUp();
        krForkTx();
        setupFork(Fork.Usable);

        vm.deal(sender, 1 ether);

        vm.prank(sender);
        super.updatePyth();
    }

    function test1KrFork() public pranked(sender) {}
}
