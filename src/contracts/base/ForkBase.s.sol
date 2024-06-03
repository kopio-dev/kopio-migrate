// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import {ArbDeployAddr} from "kr/info/ArbDeployAddr.sol";
import {cs} from "kr/core/States.sol";
import {Enums, VaultAsset} from "kr/core/types/Data.sol";
import {IKresko} from "kr/core/IKresko.sol";
import {IVault} from "kr/core/IVault.sol";
import {PLog} from "kr/utils/PLog.s.sol";
import {ArbDeploy} from "kr/info/ArbDeploy.sol";
import {Scripted} from "kr/utils/Scripted.s.sol";
import {Roles} from "kr/token/IKresko1155.sol";
import {IKreditsDiamond} from "kr/core/IKreditsDiamond.sol";
import {KrBase} from "c/base/KrBase.s.sol";

abstract contract ForkBase is KrBase {
    address binance = 0xB38e8c17e38363aF6EbdCb3dAE12e0243582891D;

    function giveAccess(address[] memory accounts) public broadcasted(safe) {
        if (!kreskian.hasRole(Roles.MINTER_ROLE, safe)) {
            kreskian.grantRole(Roles.MINTER_ROLE, safe);
        }
        if (!qfk.hasRole(Roles.MINTER_ROLE, safe)) {
            qfk.grantRole(Roles.MINTER_ROLE, safe);
        }

        for (uint256 i; i < accounts.length; i++) {
            address addr = accounts[i];
            if (kreskian.balanceOf(addr, 0) == 0) {
                kreskian.mint(addr, 0, 1);
            }
            if (qfk.balanceOf(addr, 0) == 0) {
                qfk.mint(addr, 0, 1);
            }
        }
    }

    function giveFunds(address[] memory accounts) public broadcasted(binance) {
        for (uint256 i; i < accounts.length; i++) {
            address addr = accounts[i];
            USDC.transfer(addr, 100_000e6);
            payable(addr).transfer(10 ether);
        }
    }

    function looseOracles() public broadcasted(safe) {
        kresko.executeInitializer(
            address(new LooserInitializer()),
            abi.encodeCall(LooserInitializer.run, ())
        );

        VaultAsset[] memory assets = vault.allAssets();

        for (uint256 i = 0; i < assets.length; i++) {
            PLog.clg(assets[i].staleTime);
            vault.setAssetFeed(
                address(assets[i].token),
                address(assets[i].feed),
                type(uint24).max
            );
        }
    }

    address[] addresses = [
        0x5a6B3E907b83DE2AbD9010509429683CF5ad5984, // dev
        0x99999A0B66AF30f6FEf832938a5038644a72180a, // self
        0x7e04f2812F952fB16df52C25aAefb96fcA7c8574, // miko
        0xADDB385343d851d92CC8639162e5aD18c16E47Df, // ayuush
        0xada18123Bf1788119Dd557DaCA618a2e92e1BE3c, // self
        0x13458523bFCb8F0c30C440e77945C392AaA5020f, // qual
        0xd6bEDEcDeC6Dc1C5900abeFD2CAB1663BCED8E22, // akira
        0x3dD318bE619FaaedCF49D582Efa9fb087C688670, // george?
        0x0E3DE118782bC7e4C7AFaFdD29Af762F4CdEcab5, // fenix
        0xFcbB93547B7C1936fEbfe56b4cEeD9Ab66dA1857, // dev
        0x36d50Cf7b7dfac786f3F14d251299F0593517E17 // miko
    ];
}

contract LooserInitializer is ArbDeployAddr {
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
