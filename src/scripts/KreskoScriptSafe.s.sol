// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import {SafeTx} from "c/safe/SafeTx.s.sol";
import {Utils} from "c/safe/Utils.s.sol";
import {KrBase} from "c/base/KrBase.s.sol";
import {Help, Log} from "kr/utils/Libs.s.sol";
import {Asset} from "kr/core/types/Data.sol";

contract KreskoScriptSafe is KrBase, SafeTx {
    using Log for *;
    using Help for *;

    function setUp() public virtual override(SafeTx, KrBase) {
        SafeTx.setUp();
        KrBase.setUp();

        sender.clg("Sender");
        SAFE_ADDRESS.clg("Safe Address");
        block.chainid.clg("Chain ID");
    }

    function execKreskoSafe() public {
        _exec();
    }

    function _exec() internal broadcasted(SAFE_ADDRESS) {
        kresko.setGatingManager(address(0));
        payable(sender).transfer(0.001 ether);
    }
}
