// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import {SafeTx} from "c/safe/SafeTx.s.sol";
import {KrBase} from "c/base/KrBase.s.sol";
import {Help, Log} from "kr/utils/Libs.s.sol";

contract krsafe is KrBase, SafeTx {
    using Log for *;
    using Help for *;

    function setUp() public virtual {
        super.safeBase("MNEMONIC", "SAFE_NETWORK");
        SAFE_ADDRESS.clg("Safe Address");
        block.chainid.clg("Chain ID");
    }

    function kreskoSafeTx() public {
        _transaction();
    }

    function _transaction() private broadcasted(SAFE_ADDRESS) {
        kresko.setGatingManager(0xDfd3252C5D875a43A93b9ec882F209a0CC2E17a7);
    }
}
