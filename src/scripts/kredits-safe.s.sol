// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {SafeTx} from "c/safe/SafeTx.s.sol";
import {KrBase} from "c/base/KrBase.s.sol";
import {Help, Log} from "kr/utils/Libs.s.sol";
import {ClaimEvent} from "kr/core/IKreditsDiamond.sol";

contract kredsafe is KrBase, SafeTx {
    using Log for *;
    using Help for *;

    function setUp() public virtual {
        super.safeBase("MNEMONIC", "SAFE_NETWORK");
    }

    function kredSafeTx() public {
        broadcastWith(SAFE_ADDRESS);
    }

    function _doSomethingElse() internal broadcasted(SAFE_ADDRESS) {
        payable(sender).transfer(0.0001 ether);
    }
}
