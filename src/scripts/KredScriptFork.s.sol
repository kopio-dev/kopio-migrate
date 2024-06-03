// SPDX-License-Identifier: UNLICENSED
// solhint-disable
pragma solidity ^0.8.13;

import {Help, Log} from "kr/utils/Libs.s.sol";
import {cs} from "kr/core/States.sol";
import {Enums, VaultAsset} from "kr/core/types/Data.sol";
import {ArbDeployAddr} from "kr/info/ArbDeployAddr.sol";
import {Roles} from "kr/token/IKresko1155.sol";
import {ClaimEvent} from "kr/core/IKreditsDiamond.sol";
import {ForkBase} from "c/base/ForkBase.s.sol";

contract KredScriptFork is ForkBase {
    using Log for *;
    using Help for *;

    bytes32 constant merkleRoot =
        0x9bd4102d94bd2edf509bc57afb8b1bbe3a63c58fad443557aaf2bf9021eeaaab;

    function setUp() public virtual override {
        super.setUp();
        vm.createSelectFork(getEnv("RPC_KREDITS_FORK", "RPC_ARBITRUM_ALCHEMY"));
    }

    function execKredFork() public {
        ungate();
        looseOracles();
    }

    function ungate() public {
        giveAccess(addresses);
    }

    function check() public view {
        for (uint256 i = 0; i < addresses.length; i++) {
            address addr = addresses[i];
            addr.clg("addr");
            kredits.balanceOf(addr).clg("bal-kredit");
            kreskian.balanceOf(addr, 0).clg("bal-kreskian");
            kredits.getAccountInfo(addr).linkedId.clg("linkedId");
            Log.hr();
        }
    }

    function createClaim() public broadcasted(safe) {
        kredits.createClaim(
            ClaimEvent({
                merkleRoot: merkleRoot,
                startDate: uint128(block.timestamp),
                claimWindow: uint128(2 days),
                minting: true,
                burning: false
            })
        );
    }
}
