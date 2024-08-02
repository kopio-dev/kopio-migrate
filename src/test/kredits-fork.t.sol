// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Tested} from "kr/vm/Tested.t.sol";
import {kredfork, Utils, PLog} from "s/kredits-fork.s.sol";

contract testkredfork is kredfork, Tested {
    using PLog for *;
    using Utils for *;

    function setUp() public override {
        super.setUp();
        kredForkTx();
    }

    function test4KredFork() public pranked(sender) {}
}
