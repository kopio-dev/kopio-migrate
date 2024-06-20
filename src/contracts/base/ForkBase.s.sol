// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {cs} from "kr/core/States.sol";
import {Enums} from "kr/core/types/Const.sol";
import {PLog} from "kr/utils/PLog.s.sol";
import {NFTRole} from "kr/core/types/Role.sol";
import {IViewFacet} from "kr/core/IKreditsDiamond.sol";
import {KrBase} from "c/base/KrBase.s.sol";
import {PLog} from "kr/utils/PLog.s.sol";
import {ArbDeployAddr} from "kr/info/ArbDeployAddr.sol";
import {VaultAsset} from "kr/core/IVault.sol";

abstract contract ForkBase is KrBase {
    using PLog for *;

    enum Fork {
        None,
        Funded,
        Usable,
        UsableFunded,
        UsableGated,
        UsableGatedFunded,
        UsableUngated,
        UsableUngatedFunded
    }

    function setupFork(Fork _mode) public {
        if (_mode == Fork.None) return;
        if (_mode == Fork.Funded) return fund(testAccs);

        looseOracles();

        if (_mode == Fork.UsableFunded) return fund(testAccs);

        if (
            _mode == Fork.UsableUngatedFunded || _mode == Fork.UsableGatedFunded
        ) {
            fund(testAccs);
        }

        if (_mode == Fork.UsableGated || _mode == Fork.UsableGatedFunded) {
            _gateAccounts(testAccs);
        }

        if (_mode == Fork.UsableUngated || _mode == Fork.UsableUngatedFunded) {
            _ungateAccounts(testAccs);
        }
    }

    function _ungateAccounts(
        address[] memory _accs
    ) public rebroadcasted(safe) {
        _grantNFTMinter(safe);
        for (uint256 i; i < _accs.length; i++) _mint1155s(_accs[i]);
    }

    function _gateAccounts(
        address[] memory _accs
    ) public rebroadcasted(safe) returns (uint256 removed) {
        _grantNFTMinter(safe);

        for (uint256 i; i < _accs.length; i++) _removeNFTs(_accs[i]);

        return
            kredits.balanceOf(address(0x1337)) +
            kreskian.balanceOf(address(0x1337), 0) +
            qfk.balanceOf(address(0x1337), 0);
    }

    function _mint1155s(address _account) public rebroadcasted(safe) {
        if (kreskian.balanceOf(_account, 0) == 0) kreskian.mint(_account, 0, 1);
        if (qfk.balanceOf(_account, 0) == 0) qfk.mint(_account, 0, 1);
    }

    function _removeNFTs(address _addr) internal rebroadcasted(_addr) {
        IViewFacet.AccountInfo memory info = kredits.getAccountInfo(_addr);
        if (info.linkedId != 0) {
            kredits.unlink();
            kredits.transferFrom(_addr, address(0x1337), info.linkedId);
        }

        if (info.walletProfileId != 0) {
            kredits.transferFrom(_addr, address(0x1337), info.walletProfileId);
        }

        if (kreskian.balanceOf(_addr, 0) != 0) {
            kreskian.safeTransferFrom(
                _addr,
                address(0x1337),
                0,
                kreskian.balanceOf(_addr, 0),
                ""
            );
        }
        if (qfk.balanceOf(_addr, 0) != 0) {
            qfk.safeTransferFrom(
                _addr,
                address(0x1337),
                0,
                qfk.balanceOf(_addr, 0),
                ""
            );
        }
    }

    function _grantNFTMinter(address _who) private rebroadcasted(safe) {
        if (!kreskian.hasRole(NFTRole.MINTER, _who))
            kreskian.grantRole(NFTRole.MINTER, _who);
        if (!qfk.hasRole(NFTRole.MINTER, _who))
            qfk.grantRole(NFTRole.MINTER, _who);
    }

    function fund(address[] memory _accs) public rebroadcasted(binance) {
        for (uint256 i; i < _accs.length; i++) {
            address addr = _accs[i];
            USDC.transfer(addr, 100_000e6);
            payable(addr).transfer(10 ether);
        }
    }

    function looseOracles() public rebroadcasted(safe) {
        kresko.executeInitializer(
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

    function gateCheck(address[] memory _addrs) public view {
        for (uint256 i = 0; i < _addrs.length; i++) {
            address addr = _addrs[i];
            PLog.clg("\n");
            addr.clg("Account:");
            kredits.balanceOf(addr).clg("bal-kredit");
            kreskian.balanceOf(addr, 0).clg("bal-kreskian");
            kredits.getAccountInfo(addr).linkedId.clg("linkedId");
            PLog.clg("************************************");
        }
    }
}

contract ForkInitializer is ArbDeployAddr {
    function run() external {
        cs()
        .oracles[bytes32("ETH")][Enums.OracleType.Chainlink]
            .staleTime = 1000000000000;

        cs()
        .oracles[bytes32("JPY")][Enums.OracleType.Chainlink]
            .staleTime = 1000000000000;

        cs()
        .oracles[bytes32("EUR")][Enums.OracleType.Chainlink]
            .staleTime = 1000000000000;

        cs()
        .oracles[bytes32("BTC")][Enums.OracleType.Chainlink]
            .staleTime = 1000000000000;

        cs()
        .oracles[bytes32("SOL")][Enums.OracleType.Chainlink]
            .staleTime = 1000000000000;
        cs()
        .oracles[bytes32("USDC")][Enums.OracleType.Chainlink]
            .staleTime = 1000000000000;
        cs()
        .oracles[bytes32("KISS")][Enums.OracleType.Chainlink]
            .staleTime = 1000000000000;

        cs().maxPriceDeviationPct = 50e2;
    }
}
