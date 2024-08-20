// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ms, cs, Enums} from "kresko/core/States.sol";

contract KreskoSetup {
    function run() external {
        for (uint256 i; i < ms().collaterals.length; i++) {
            address asset = ms().collaterals[i];

            cs()
            .oracles[cs().assets[asset].ticker][Enums.OracleType.Chainlink]
                .staleTime = 1000000000000;
            cs()
            .oracles[cs().assets[asset].ticker][Enums.OracleType.Pyth]
                .staleTime = 1000000000000;
        }
        cs().maxPriceDeviationPct = 50e2;
    }
}
