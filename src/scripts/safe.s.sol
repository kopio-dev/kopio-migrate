// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {SafeTx} from "kopio/vm/SafeTx.s.sol";
import {Base} from "s/base/Base.s.sol";
import {Utils} from "kopio/utils/Libs.sol";
import {PLog} from "kopio/vm/PLog.s.sol";

contract safe is Base, SafeTx {
    using PLog for *;
    using Utils for *;

    function setUp() public virtual {
        super.safeBase("MNEMONIC_KOPIO", "SAFE_NETWORK");
    }

    function safeTx() public {
        _transaction();
    }

    function _transaction() private broadcasted(SAFE_ADDRESS) {
        payable(sender).transfer(0.0001 ether);
    }
}
