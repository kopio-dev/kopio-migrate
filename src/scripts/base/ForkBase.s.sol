// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Enums, cs, ms} from "kopio/IKopioCore.sol";
import {PLog} from "kopio/vm/PLog.s.sol";
import {Base} from "s/base/Base.s.sol";
import {VaultAsset} from "kopio/IVault.sol";

abstract contract ForkBase is Base {
    using PLog for *;

    enum Fork {
        None,
        Funded,
        Usable,
        UsableFunded
    }
    address[] testAccs;
    function setupFork(Fork _mode) public {
        if (_mode == Fork.None) return;
        if (_mode == Fork.Funded) return fund(testAccs);

        looseOracles();

        if (_mode == Fork.UsableFunded) return fund(testAccs);
    }

    function fund(address[] memory _accs) public rebroadcasted(binanceAddr) {
        for (uint256 i; i < _accs.length; i++) {
            address addr = _accs[i];
            usdc.transfer(addr, 100_000e6);
            payable(addr).transfer(10 ether);
        }
    }

    function looseOracles() public rebroadcasted(safe) {
        core.executeInitializer(
            address(new ForkInitializer()),
            abi.encodeCall(ForkInitializer.run, ())
        );

        VaultAsset[] memory _tkns = vault.allAssets();

        for (uint256 i; i < _tkns.length; i++) {
            vault.setAssetFeed(
                address(_tkns[i].token),
                address(_tkns[i].feed),
                type(uint24).max
            );
        }
    }
}

contract ForkInitializer {
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
