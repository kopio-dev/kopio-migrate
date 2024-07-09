// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Tested} from "kr/utils/s/Tested.t.sol";
import {kredsafe, Help, Log} from "s/kredits-safe.s.sol";

contract testkredsafe is kredsafe, Tested {
    using Log for *;
    using Help for *;

    function setUp() public override {
        super.setUp();
        kredSafeTx();
    }

    function test5KredSafe() public pranked(sender) {}
}
