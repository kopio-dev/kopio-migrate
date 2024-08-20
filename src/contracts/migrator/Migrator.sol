// SPDX-License-Identifier: MIT
// solhint-disable no-inline-assembly, one-contract-per-file, state-visibility, const-name-snakecase
pragma solidity ^0.8.0;

import {Utils} from "kopio/utils/Libs.sol";
import {MigrationLogic, TKresko} from "c/migrator/MigratorBase.sol";
import {LibMigration} from "c/migrator/LibMigration.sol";
import {ICollateralReceiver} from "c/migrator/IMigrator.sol";
import {PLog} from "kopio/vm/PLog.s.sol";
import {Positions} from "c/migrator/LibMigration.sol";

contract Migrator is ICollateralReceiver, MigrationLogic {
    using Utils for *;
    using PLog for *;

    function migrate(
        address account,
        bytes[] calldata prices
    ) public payable override returns (MigrationResult memory result) {
        result.account = account;

        pythEP.updatePriceFeeds{value: pythEP.getUpdateFee(prices)}(prices);

        result = LibMigration.getValues(account, result, true);
        if (
            result.kresko.valSCDPBefore == 0 && result.kresko.valCollBefore == 0
        ) return result;

        if (result.kresko.valSCDPBefore != 0)
            result.scdp = _handleSCDP(account);

        if (result.kresko.valCollBefore != 0) {
            _handleMinter(account);
            if (ms().txColl.length != 0) transferMinterPositions(account);
        }

        this.emitTransfers(account);

        result = LibMigration.getValues(account, result, false);

        result.slippage = result.valueNow.pdiv(result.valueBefore);
        result.icdpColl = ms().txColl;
        result.icdpDebt = ms().txDebt;

        if (msg.sender == address(this)) revert MigrationPreview(result);

        if (result.slippage < 100e2 - ms().maxSlippage) {
            revert Slippage(
                result.slippage,
                ms().maxSlippage,
                result.valueBefore,
                result.valueNow
            );
        }

        emit Migration(account, result.valueBefore, result.valueNow);
        clearState();
    }

    function _handleSCDP(
        address account
    ) internal returns (Transfer memory transfer) {
        transfer.asset = kissAddr;

        uint256 balBefore = bal(transfer.asset);
        transfer.destination = oneAddr;
        transfer.amount = kresko.getAccountDepositSCDP(account, transfer.asset);

        kresko.withdrawSCDP(
            TKresko.SCDPWithdrawArgs(
                account,
                transfer.asset,
                transfer.amount,
                address(this)
            ),
            new bytes[](0)
        );

        (address vasset, uint256 usdcIn) = _toUSDC(
            transfer.asset,
            bal(transfer.asset) - balBefore
        );

        one.vaultDeposit(vasset, usdcIn, address(this));

        core.depositSCDP(
            account,
            transfer.destination,
            bal(transfer.destination)
        );

        transfer.amountTransferred = core.getAccountDepositSCDP(
            account,
            transfer.destination
        );

        emit PositionTransferred(
            account,
            transfer.asset,
            transfer.destination,
            transfer.amount,
            transfer.amountTransferred
        );
    }

    function _handleMinter(address account) internal {
        Positions.getPositions(ms(), account);
        if (ms().collValue == 0) return;

        _withdrawUncheck(account, 0);

        for (uint256 i; i < ms().posColl.length; i++) {
            Pos storage pos = ms().posColl[i];

            ms().txColl.push(
                Transfer({
                    asset: pos.a.addr,
                    destination: ms().getAsset[pos.a.addr],
                    idx: pos.idx,
                    amount: pos.amount,
                    amountTransferred: 0,
                    value: pos.value
                })
            );
        }

        for (uint256 i; i < ms().posDebt.length; i++) {
            Pos storage pos = ms().posDebt[i];
            ms().txDebt.push(
                Transfer({
                    asset: pos.a.addr,
                    destination: ms().getAsset[pos.a.addr],
                    idx: pos.idx,
                    amount: pos.amount,
                    amountTransferred: 0,
                    value: pos.value
                })
            );
        }
    }

    function transferMinterPositions(address account) internal {
        for (uint256 i; i < ms().txColl.length; i++) {
            Transfer storage item = ms().txColl[i];
            if (item.amountTransferred != 0 || item.amount == 0) continue;
            if (isKrAsset(item.asset)) {
                _toAsset(item.asset, item.destination, item.amount);
            }
            _depositKopio(account, item);
        }

        for (uint256 i; i < ms().txDebt.length; i++) {
            Transfer storage item = ms().txDebt[i];
            if (item.amount == 0) continue;
            _mintKopioDebt(account, item);
        }

        _handleLeverage(account);
    }

    function onUncheckedCollateralWithdraw(
        address account,
        address collateral,
        uint256,
        uint256,
        bytes memory data
    ) external returns (bytes memory) {
        if (msg.sender != kreskoAddr) revert InvalidSender(msg.sender);

        uint256 idx = abi.decode(data, (uint256));
        if (idx < ms().posColl.length - 1) {
            ms().assetsUsed.pushUnique(collateral);
            _withdrawUncheck(account, ++idx);
        }

        uint256 feeValueApprox = ms().debtValue.pdiv(95e2) - ms().debtValue;
        kresko.depositCollateral(
            account,
            ms().posColl[0].a.addr,
            _toAmount(ms().posColl[0], feeValueApprox)
        );

        for (uint256 i; i < ms().posColl.length; i++) {
            Pos storage coll = ms().posColl[i];

            for (uint256 j; j < ms().posDebt.length; j++) {
                Pos storage debt = ms().posDebt[j];
                uint256 debtAmount = kresko.getAccountDebtAmount(
                    account,
                    debt.a.addr
                );
                if (debtAmount == 0) continue;
                uint256 burnAmount = _toDebtAsset(coll, debt, debtAmount);
                if (burnAmount == 0) continue;

                ms().assetsUsed.pushUnique(debt.a.addr);
                _burn(account, debt.a.addr, burnAmount);

                if (bal(debt.a.addr) != 0) {
                    _toAsset(debt.a.addr, coll.a.addr, bal(debt.a.addr));
                }
            }
        }

        _withdrawAll(account, ms().posColl[0].a.addr);

        return "";
    }
}
