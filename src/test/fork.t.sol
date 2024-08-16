// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Tested} from "kopio/vm/Tested.t.sol";
import {fork, PLog, Utils} from "s/fork.s.sol";
import {tbytes} from "kopio/utils/TBytes.sol";

contract testfork is fork, Tested {
    using PLog for *;
    using Utils for *;

    function setUp() public override {
        super.setUp();
        forkTx();
        setupFork(Fork.Usable);

        vm.deal(sender, 1 ether);

        vm.prank(sender);
        super.updatePyth();
    }

    function test1Fork() public pranked(sender) {}
}
