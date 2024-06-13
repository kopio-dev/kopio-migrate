// SPDX-License-Identifier: UNLICENSED
// solhint-disable
pragma solidity ^0.8.13;

import {Help, Log} from "kr/utils/Libs.s.sol";
import {ClaimEvent} from "kr/core/IKreditsDiamond.sol";
import {KrBase} from "c/base/KrBase.s.sol";

contract KredScript is KrBase {
    using Log for *;
    using Help for *;

    bytes32 constant merkleRoot =
        0x9bd4102d94bd2edf509bc57afb8b1bbe3a63c58fad443557aaf2bf9021eeaaab;

    function setUp() public virtual override {
        super.setUp();
        vm.createSelectFork(getEnv("KREDITS_NETWORK", "RPC_ARBITRUM_ALCHEMY"));
    }

    function execKred() public {
        createClaim();
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
