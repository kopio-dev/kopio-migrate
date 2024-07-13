// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Tested} from "kr/utils/s/Tested.t.sol";
import {kredfork, Help, Utils, Log} from "s/kredits-fork.s.sol";

contract testkredfork is kredfork, Tested {
    using Log for *;
    using Help for *;
    using Utils for *;

    function setUp() public override {
        super.setUp();
        kredForkTx();
    }

    function test4KredFork() public pranked(sender) {}
}
