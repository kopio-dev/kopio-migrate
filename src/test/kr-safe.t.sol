// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Tested} from "kr/utils/s/Tested.t.sol";
import {krsafe, Help, Utils, Log} from "s/kr-safe.s.sol";

contract testkrsafe is krsafe, Tested {
    using Log for *;
    using Help for *;
    using Utils for *;

    function setUp() public override {
        super.setUp();
        krSafeTx();
    }

    function test2KrSafe() public pranked(SAFE_ADDRESS) {}
}
