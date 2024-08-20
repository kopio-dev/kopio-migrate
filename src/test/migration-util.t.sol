// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ms, cs, Enums} from "kresko/core/States.sol";

abstract contract TestUsers {
    address[] testUsers = [
        0x0045E14AB4cafdCE9dFd2D2299fbACb593175b9a,
        0x01287890fA522335A858ac7986c949aBf7a3D5a8,
        0x0a7f988B6cEa3081EBa2896C4f0793c19d2A775E,
        0x0b4dD0D15616Db547bA4AEEc3459C01e29B9de76,
        0x13337e3C4a9aA3444e6AB80ea15AB3c3416d84Cd,
        0x1469a9B82DC41c49cb29F7b764Ba4268993C9239,
        0x19B95041fe2E2c4969C9C45Df664562F7B9Cd3Bb,
        0x1AeAC9C64E04a40DD476Ac8eCEB02A4c5eD0d205,
        0x1F427A6FCdb95A7393C58552093e10A932890FA8,
        0x0045E14AB4cafdCE9dFd2D2299fbACb593175b9a,
        0x01287890fA522335A858ac7986c949aBf7a3D5a8,
        0x0a7f988B6cEa3081EBa2896C4f0793c19d2A775E,
        0x0b4dD0D15616Db547bA4AEEc3459C01e29B9de76,
        0x13337e3C4a9aA3444e6AB80ea15AB3c3416d84Cd,
        0x216860d70Bb7D8F7d05C03888Cf3777A1A8133F4,
        0x260464e29E80a1D22fC0677B61bc7AD7c5c1F978,
        0x299776620339EA8d5a4aAA2597Fcf75481ADA0Af,
        0x2c45b9CE5fbD0f7538F820b78B7aA74AFa2ddd0b,
        0x42486570310823Fa68fF64F18F0B5b25632f3CBF,
        0x4f413814F1097DCd629C099B90da4E1141981d54,
        0x50f8f5724EF4b36AAAcADc3f89C6C022cD606920,
        0x5252a3C0eBa07bF5653648165abFcCbE5FEebcE3,
        0x5861100a189791b59A28a9270FA9D30e722C3Fd8,
        0x586634c272DFA3894Ee9B99836541DeE35660F34,
        0x59653fd9713a30C54237A6FD21fD97BA141aBbe0,
        0x5c247db149260f53Bd0ad079Ee215a64FA459f3e,
        0x5d47e5D242a8F66a6286b0a2353868875F5d6068,
        0x70d2Ecf98E93A6E05FeF3F5dd47A85b55F60FCfa,
        0x86A010f6877e1C45216A0bA541d9E6ac26cf489B,
        0x87431B9e4ec181e09dBB31E4342C66ED1F4A1799
    ];
}
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
