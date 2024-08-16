// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Tested} from "kopio/vm/Tested.t.sol";
import {safe, Utils, PLog} from "s/safe.s.sol";

contract testsafe is safe, Tested {
    using PLog for *;
    using Utils for *;

    function setUp() public override {
        super.setUp();
        safeTx();
    }

    function test2Safe() public pranked(SAFE_ADDRESS) {}
}
