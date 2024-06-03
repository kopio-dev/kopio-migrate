// SPDX-License-Identifier: UNLICENSED
// solhint-disable
pragma solidity ^0.8.13;

import {Help, Log} from "kr/utils/Libs.s.sol";
import {Enums, VaultAsset} from "kr/core/types/Data.sol";
import {ArbDeployAddr} from "kr/info/ArbDeployAddr.sol";
import {Roles} from "kr/token/IKresko1155.sol";
import {ClaimEvent} from "kr/core/IKreditsDiamond.sol";
import {KrBase} from "c/base/KrBase.s.sol";

contract KreskoScript is KrBase {
    using Log for *;
    using Help for *;

    function setUp() public virtual override {
        KrBase.setUp();
        vm.createSelectFork(getEnv("KRESKO_NETWORK", "RPC_ARBITRUM_ALCHEMY"));
    }

    function execKresko() public broadcasted(sender) {
        fetchPythAndUpdate();
        weth.deposit{value: 0.01 ether}();
    }
}
