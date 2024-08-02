// SPDX-License-Identifier: UNLICENSED
// solhint-disable
pragma solidity ^0.8.13;

import {Utils} from "kr/utils/Libs.sol";
import {PLog} from "kr/vm/PLog.s.sol";
import {KrBase} from "s/base/KrBase.s.sol";
import {deployData} from "c/helpers/Deploy.sol";

contract kr is KrBase {
    using PLog for *;
    using Utils for *;

    function setUp() public virtual {
        base("MNEMONIC", "RPC_ARBITRUM_ALCHEMY");
    }

    function krTx() public broadcasted(sender) {
        PLog.clg(address(deployData()));
    }
}
