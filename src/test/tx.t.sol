// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Tested} from "kopio/vm/Tested.t.sol";
import {ktx, Utils} from "s/tx.s.sol";
import {Log} from "kopio/vm/VmLibs.s.sol";
import {VaultAsset} from "kopio/IVault.sol";
import {IERC20} from "kopio/token/IERC20.sol";
import {Vault, wadUSD} from "c/Vault.sol";
import {ITransparentUpgradeableProxy} from "kopio/vendor/TransparentUpgradeableProxy.sol";
import {IAggregatorV3} from "kopio/vendor/IAggregatorV3.sol";

contract testktx is ktx, Tested {
    using Log for *;
    using Utils for *;

    Vault newVault;

    function setUp() public override {
        super.setUp();
        prank(sender);
        bytes memory ctor = type(Vault).creationCode;
        // bytes memory initializer = abi.encodeCall(
        //     Vault.initialize,
        //     (
        //         "vONE",
        //         "vONE",
        //         18,
        //         sender,
        //         safe,
        //         0xFdB631F5EE196F0ed6FAa767959853A9F217697D
        //     )
        // );

        factory.upgradeAndCall(
            ITransparentUpgradeableProxy(vaultAddr),
            type(Vault).creationCode,
            ""
        );

        vault.setDepositFee(usdceAddr, 10);
        vault.setWithdrawFee(usdceAddr, 10);
        vault.addAsset(
            VaultAsset(
                IERC20(daiAddr),
                IAggregatorV3(0x50834F3163758fcC1Df9973b6e91f0F0F0434aD3),
                80000,
                0,
                0,
                0,
                type(uint248).max,
                true
            )
        );
        deal(daiAddr, sender, 100 ether);
        dai.approve(oneAddr, type(uint256).max);
        usdce.approve(oneAddr, type(uint256).max);
        usdce.approve(vaultAddr, type(uint256).max);
    }

    function testToWad() public {
        // uint256 wad = wadUSD(1 ether);
        // wad.dlg("wad");
    }
    function test1Mint() public pranked(sender) {
        uint256 fxRateBefore = vault.exchangeRate();
        uint256 balBefore = usdce.balanceOf(sender);

        (uint256 required, ) = vault.previewMint(usdceAddr, 1 ether);
        required.dlg("required", 6);

        usdce.approve(oneAddr, type(uint256).max);

        (uint256 assetsIn, ) = one.vaultMint(usdceAddr, 1 ether, sender);
        assetsIn.dlg("assetsIn", 6);

        uint256 balAfter = usdce.balanceOf(sender);
        uint256 fxRateAfter = vault.exchangeRate();

        (balBefore - balAfter).dlg("balAfter", 6);

        fxRateBefore.dlg("fxRateBefore", 18);
        fxRateAfter.dlg("fxRateAfter", 18);

        usdce.balanceOf(address(vault)).dlg("vaultBalance", 6);
        vault.totalSupply().dlg("vaultTotalSupply", 18);

        (uint256 required2, ) = vault.previewMint(usdceAddr, 1 ether);
        required2.dlg("required", 6);

        uint256 tAssets = vault.totalAssets();
        uint256 tSupply = vault.totalSupply();

        tAssets.dlg("tAssets", 18);
        tSupply.dlg("tSupply", 18);

        uint256 ratio = (tAssets * 1e18) / tSupply;

        ratio.dlg("ratio", 18);
    }

    function test2Diff() public pranked(sender) {
        Log.id("usdce-mint");
        uint256 desiredShares = 1 ether;
        (uint256 requiredAssets, ) = vault.previewMint(
            usdceAddr,
            desiredShares
        );
        (uint256 estimatedShares, ) = vault.previewDeposit(
            usdceAddr,
            requiredAssets
        );
        estimatedShares.dlg("estimatedShares");
        one.vaultMint(usdceAddr, desiredShares, sender);
        usdce.balanceOf(address(vault)).dlg("usdc-vault-bal", 6);
        vault.totalSupply().dlg("vault-supply");
        uint256 tAssets = vault.totalAssets();
        uint256 tSupply = vault.totalSupply();
        tAssets.dlg("deposit-tAssets", 18);
        tSupply.dlg("deposit-tSupply", 18);

        uint256 ratio = (tAssets * 1e18) / tSupply;

        ratio.dlg("ratio-after", 18);

        (uint256 preview, ) = vault.previewRedeem(usdceAddr, desiredShares);
        (uint256 previewW, ) = vault.previewWithdraw(usdceAddr, preview);
        preview.dlg("preview", 6);
        previewW.dlg("previewW");

        one.vaultWithdraw(usdceAddr, preview, sender, sender);
        usdce.balanceOf(address(vault)).dlg("usdc-vault-bal", 6);
        vault.totalSupply().dlg("vault-supply");
        vault.exchangeRate().dlg("exchangeRate", 18);
    }
    function test4Diff() public pranked(sender) {
        Log.id("dai-mint");
        uint256 desiredShares = 1 ether;
        (uint256 requiredAssets, ) = vault.previewMint(daiAddr, desiredShares);
        (uint256 estimatedShares, ) = vault.previewDeposit(
            daiAddr,
            requiredAssets
        );
        estimatedShares.dlg("estimatedShares");
        one.vaultMint(daiAddr, desiredShares, sender);
        dai.balanceOf(address(vault)).dlg("usdc-vault-bal");
        vault.totalSupply().dlg("vault-supply");
        uint256 tAssets = vault.totalAssets();
        uint256 tSupply = vault.totalSupply();
        tAssets.dlg("deposit-tAssets", 18);
        tSupply.dlg("deposit-tSupply", 18);

        uint256 ratio = (tAssets * 1e18) / tSupply;

        ratio.dlg("ratio-after", 18);
    }

    function test3Diff() public pranked(sender) {
        Log.id("usdce-deposit");
        uint256 desiredShares = 1 ether;
        (uint256 requiredAssets, ) = vault.previewMint(
            usdceAddr,
            desiredShares
        );
        (uint256 estimatedShares, ) = vault.previewDeposit(
            usdceAddr,
            requiredAssets
        );
        estimatedShares.dlg("estimatedShares");
        one.vaultDeposit(usdceAddr, requiredAssets, sender);
        usdce.balanceOf(address(vault)).dlg("usdc-vault-bal", 6);
        vault.totalSupply().dlg("vault-supply");
        uint256 tAssets = vault.totalAssets();
        uint256 tSupply = vault.totalSupply();
        tAssets.dlg("deposit-tAssets", 18);
        tSupply.dlg("deposit-tSupply", 18);

        uint256 ratio = (tAssets * 1e18) / tSupply;

        ratio.dlg("ratio-after", 18);
    }
}
