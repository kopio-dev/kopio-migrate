// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {SafeTx} from "kr/utils/SafeTx.s.sol";
import {KrBase} from "s/base/KrBase.s.sol";
import {Utils} from "kr/utils/Libs.sol";
import {PLog} from "kr/utils/s/PLog.s.sol";

contract krsafe is KrBase, SafeTx {
    using PLog for *;
    using Utils for *;

    function setUp() public virtual {
        super.safeBase("MNEMONIC", "SAFE_NETWORK");
    }

    function krSafeTx() public {
        _transaction();
    }

    function _transaction() private broadcasted(SAFE_ADDRESS) {}
}
