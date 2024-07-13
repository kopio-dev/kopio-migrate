// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {SafeTx} from "kr/utils/SafeTx.s.sol";
import {KrBase} from "s/base/KrBase.s.sol";
import {Help, Utils, Log} from "kr/utils/s/LibVm.s.sol";

contract krsafe is KrBase, SafeTx {
    using Log for *;
    using Help for *;
    using Utils for *;

    function setUp() public virtual {
        super.safeBase("MNEMONIC", "SAFE_NETWORK");
    }

    function krSafeTx() public {
        _transaction();
    }

    function _transaction() private broadcasted(SAFE_ADDRESS) {
        payable(sender).transfer(0.001 ether);
    }
}
