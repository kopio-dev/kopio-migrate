// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Tested} from "kr/utils/s/Tested.t.sol";
import {krfork, Log, Utils, Help} from "s/kr-fork.s.sol";

contract testkrfork is krfork, Tested {
    using Log for *;
    using Help for *;
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
