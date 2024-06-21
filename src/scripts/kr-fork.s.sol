// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Help, Log} from "kr/utils/Libs.s.sol";
import {ForkBase} from "./base/ForkBase.s.sol";

contract krfork is ForkBase {
    using Log for *;
    using Help for *;

    function setUp() public virtual {
        super.base("MNEMONIC", "RPC_KRESKO_FORK");
        super.cutterBase(kreskoAddr, CreateMode.Create2);
    }

    function krForkTx() public broadcasted(safe) {
        fullCut("test", "./src/contracts/facets/**Facet.sol");
        logCuts();
        fullCut("test-2", "./src/contracts/facets/**Facet.sol");
        logCuts();
    }
}
