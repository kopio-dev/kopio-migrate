// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;
import {IMigrator} from "./IMigrator.sol";
import {IERC20} from "kopio/token/IERC20.sol";
import {IMigrationRouter} from "c/migrator/router/MigrationRouter.sol";
import {kredits} from "c/helpers/Kresko.sol";

// solhint-disable no-empty-blocks, gas-custom-errors

contract MigrationExtras is IMigrationRouter, IMigrator {
    function setMaxMigrationSlippage(uint256 value) external auth {
        ms().maxSlippage = value;
    }

    function initializeMigrationState() external auth {
        ms().maxSlippage = 2.00e2;

        ms().getAsset[kissAddr] = oneAddr;
        ms().getAsset[krETHAddr] = kETHAddr;
        ms().getAsset[krBTCAddr] = kBTCAddr;
        ms().getAsset[krSOLAddr] = kSOLAddr;
        ms().getAsset[krEURAddr] = kEURAddr;
        ms().getAsset[krJPYAddr] = kJPYAddr;
        ms().getAsset[krGBPAddr] = kGBPAddr;
        ms().getAsset[krXAUAddr] = kXAUAddr;
        ms().getAsset[krXAGAddr] = kXAGAddr;
        ms().getAsset[krDOGEAddr] = kDOGEAddr;

        ms().krAssets = [
            krETHAddr,
            krBTCAddr,
            krSOLAddr,
            krEURAddr,
            krJPYAddr,
            krGBPAddr,
            krXAUAddr,
            krXAGAddr,
            krDOGEAddr,
            kissAddr
        ];

        ms().kopios = [
            kETHAddr,
            kBTCAddr,
            kSOLAddr,
            kEURAddr,
            kJPYAddr,
            kGBPAddr,
            kXAUAddr,
            kXAGAddr,
            kDOGEAddr,
            oneAddr
        ];

        ms().exts = [
            usdcAddr,
            usdceAddr,
            wethAddr,
            usdtAddr,
            wbtcAddr,
            daiAddr,
            arbAddr
        ];

        _approvals();
    }

    function previewMigrate(
        address account,
        bytes[] calldata prices
    ) external payable override returns (MigrationResult memory) {
        try this.migrate(account, prices) returns (
            MigrationResult memory
        ) {} catch (bytes memory reason) {
            return this.getPreviewResult(reason);
        }

        revert("");
    }

    function getPreviewResult(
        bytes calldata _errorData
    ) external pure override returns (MigrationResult memory) {
        return abi.decode(_errorData[4:], (MigrationResult));
    }

    function getPoints(address account) public view returns (uint256) {
        return ms().points[account];
    }

    function _approvals() private {
        for (uint256 i; i < ms().krAssets.length; i++)
            _kreskoApprovals(ms().krAssets[i]);
        for (uint256 i; i < ms().kopios.length; i++)
            _kopioApprovals(ms().kopios[i]);
        for (uint256 i; i < ms().exts.length; i++) {
            _kreskoApprovals(ms().exts[i]);
            _kopioApprovals(ms().exts[i]);
        }
    }

    function _sendDust(address account) private {
        for (uint256 i; i < ms().krAssets.length; i++)
            _sendIfDust(account, ms().krAssets[i]);
        for (uint256 i; i < ms().exts.length; i++) {
            _sendIfDust(account, ms().exts[i]);
        }
    }

    function _sendIfDust(address account, address asset) private {
        uint256 bal = IERC20(asset).balanceOf(address(this));
        if (bal != 0) IERC20(asset).transfer(account, bal);
    }

    function _kreskoApprovals(address asset) private {
        IERC20(asset).approve(kreskoAddr, type(uint256).max);
        IERC20(asset).approve(kissAddr, type(uint256).max);
        IERC20(asset).approve(krVaultAddr, type(uint256).max);
        IERC20(asset).approve(krETHAddr, type(uint256).max);
        IERC20(asset).approve(krBTCAddr, type(uint256).max);
    }
    function _kopioApprovals(address asset) private {
        IERC20(asset).approve(oneAddr, type(uint256).max);
        IERC20(asset).approve(vaultAddr, type(uint256).max);
        IERC20(asset).approve(protocolAddr, type(uint256).max);
        IERC20(asset).approve(kETHAddr, type(uint256).max);
        IERC20(asset).approve(kBTCAddr, type(uint256).max);
    }

    function emitTransfers(address account) external override self {
        for (uint256 i; i < ms().posDebt.length; i++) {
            Pos storage item = ms().posDebt[i];
            Transfer storage transfer = ms().txDebt[i];
            address toAddr = ms().getAsset[item.a.addr];
            uint256 bal = IERC20(toAddr).balanceOf(address(this));
            if (bal != 0) core.depositCollateral(account, toAddr, bal);
            transfer.amountTransferred = core.getAccountDebtAmount(
                account,
                toAddr
            );
            transfer.destination = toAddr;
            emit PositionTransferred(
                account,
                item.a.addr,
                toAddr,
                item.amount,
                transfer.amountTransferred
            );
        }

        for (uint256 i; i < ms().posColl.length; i++) {
            Pos storage item = ms().posColl[i];
            Transfer storage transfer = ms().txColl[i];
            address toAddr = ms().getAsset[item.a.addr];
            address assetAddr = toAddr != address(0) ? toAddr : item.a.addr;
            uint256 bal = IERC20(assetAddr).balanceOf(address(this));
            if (bal != 0) core.depositCollateral(account, assetAddr, bal);
            transfer.amountTransferred = core.getAccountCollateralAmount(
                account,
                assetAddr
            );
            transfer.destination = assetAddr;
            emit PositionTransferred(
                account,
                item.a.addr,
                assetAddr,
                item.amount,
                transfer.amountTransferred
            );
        }

        _sendDust(account);
        _setKredits(account);
    }

    function _setKredits(address account) internal {
        if (ms().points[account] == 0) {
            ms().points[account] = kredits.getAccountInfo(account).points;
        }
    }
}
