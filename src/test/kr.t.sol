// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Tested} from "kr/utils/s/Tested.t.sol";
import {kr, Utils, PLog} from "s/kr.s.sol";

contract testkr is kr, Tested {
    using PLog for *;
    using Utils for *;

    function setUp() public override {
        super.setUp();
        krTx();
    }

    function test3Kr() public pranked(sender) {}
}
