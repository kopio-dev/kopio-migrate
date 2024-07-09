// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Tested} from "kr/utils/s/Tested.t.sol";
import {kred, Help, Log} from "s/kredits.s.sol";

contract testkred is kred, Tested {
    using Log for *;
    using Help for *;

    function setUp() public override {
        super.setUp();
        kredTx();
    }

    function test6Kred() public pranked(sender) {}
}
