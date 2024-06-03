// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import {SafeTx} from "c/safe/SafeTx.s.sol";
import {KrBase} from "c/base/KrBase.s.sol";
import {Help, Log} from "kr/utils/Libs.s.sol";

contract KredScriptSafe is KrBase, SafeTx {
    using Log for *;
    using Help for *;

    function setUp() public virtual override(SafeTx, KrBase) {
        SafeTx.setUp();
        KrBase.setUp();

        sender.clg("Sender");
        SAFE_ADDRESS.clg("Safe Address");
        block.chainid.clg("Chain ID");
    }

    function execKredSafe() public {
        _doSomething();
        _doSomethingElse();
    }

    function _doSomething() internal broadcasted(SAFE_ADDRESS) {
        payable(sender).transfer(0.0001 ether);
    }

    function _doSomethingElse() internal broadcasted(SAFE_ADDRESS) {
        payable(sender).transfer(0.0001 ether);
    }
}
