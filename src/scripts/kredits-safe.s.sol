// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {SafeTx} from "kr/utils/base/SafeTx.s.sol";
import {KrBase} from "s/base/KrBase.s.sol";
import {Help, Log} from "kr/utils/Libs.s.sol";

contract kredsafe is KrBase, SafeTx {
    using Log for *;
    using Help for *;

    function setUp() public virtual {
        super.safeBase("MNEMONIC", "SAFE_NETWORK");
    }

    function kredSafeTx() public {
        _transaction();
    }

    function _transaction() internal broadcasted(SAFE_ADDRESS) {
        payable(sender).transfer(0.0001 ether);
    }
}
