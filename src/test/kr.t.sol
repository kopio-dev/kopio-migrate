// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Tested} from "kr/utils/Tested.t.sol";
import {kr, Help, Log} from "s/kr.s.sol";

contract testkr is kr, Tested {
    using Log for *;
    using Help for *;

    function setUp() public override {
        super.setUp();
        krTx();

        vm.deal(sender, 1 ether);
        prank(sender);
        super.updatePyth();
    }

    function test3Kr() public pranked(sender) {
        kresko.getParametersSCDP().minCollateralRatio.clg("MCR");
    }
}
