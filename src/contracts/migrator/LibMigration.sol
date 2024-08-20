// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {kr} from "c/migrator/Kresko.sol";
import {Utils} from "kopio/utils/Libs.sol";
import {Log} from "kopio/vm/VmLibs.s.sol";
import {Migrator} from "c/migrator/Migrator.sol";
import {IData} from "kopio/support/IData.sol";
import {IKopioCore} from "kopio/IKopioCore.sol";

IData constant kopioData = IData(0xddDdDddDDd14aC7aB83F957b804e6b714b75179E);
IKopioCore constant kopioCore = IKopioCore(
    0x000000000000dcC1394A66cD4f84Fb38932a0fAB
);

library LibMigration {
    using Utils for *;
    using Log for *;

    function getAsset(
        Migrator.Transfer memory item
    ) internal pure returns (address result) {
        result = item.destination != address(0) ? item.destination : item.asset;
    }

    function getLeverage(
        Migrator.Transfer[] storage collaterals,
        Migrator.Transfer[] storage debts
    )
        internal
        returns (
            bool found,
            Migrator.Transfer storage,
            Migrator.Transfer storage
        )
    {
        uint256 collateral;
        uint256 debt;
        for (uint256 i; i < collaterals.length; i++) {
            Migrator.Transfer storage item = collaterals[i];
            if (item.amount == 0) continue;
            if (item.amountTransferred.pmul(102e2) < item.amount) {
                item.asset = LibMigration.getAsset(item);
                item.idx = (collateral = i);
                found = true;
                break;
            }
        }

        for (uint256 i; i < debts.length; i++) {
            Migrator.Transfer storage item = debts[i];
            if (item.amount == 0) continue;
            if (item.amountTransferred.pmul(102e2) < item.amount) {
                item.asset = LibMigration.getAsset(item);
                item.idx = (debt = i);
                found = !!found;
                break;
            }
            if (i == debts.length - 1) found = false;
        }

        return (found, collaterals[collateral], debts[debt]);
    }

    function getValues(
        address account,
        Migrator.MigrationResult memory out,
        bool before
    ) internal view returns (Migrator.MigrationResult memory) {
        out.account = account;

        uint256 krSCDP = kr.getAccountTotalDepositsValueSCDP(account);
        uint256 krColl = kr.getAccountTotalCollateralValue(account);
        uint256 krDebt = kr.getAccountTotalDebtValue(account);
        uint256 krTotal = krSCDP + krColl - krDebt;

        uint256 kopioSCDP = kopioCore.getAccountTotalDepositsValueSCDP(account);
        uint256 kopioColl = kopioCore.getAccountTotalCollateralValue(account);
        uint256 kopioDebt = kopioCore.getAccountTotalDebtValue(account);
        uint256 kopioTotal = kopioSCDP + kopioColl - kopioDebt;

        if (before) {
            out.kresko.valSCDPBefore = krSCDP;
            out.kresko.valCollBefore = krColl;
            out.kresko.valTotalBefore = krTotal;

            out.kopio.valSCDPBefore = kopioSCDP;
            out.kopio.valCollBefore = kopioColl;
            out.kopio.valDebtBefore = kopioDebt;
            out.kopio.valTotalBefore = kopioTotal;

            out.valueBefore = krTotal + kopioTotal;
        } else {
            out.kresko.valSCDP = krSCDP;
            out.kresko.valColl = krColl;
            out.kresko.valDebt = krDebt;
            out.kresko.valTotal = krTotal;

            out.kopio.valSCDP = kopioSCDP;
            out.kopio.valColl = kopioColl;
            out.kopio.valDebt = kopioDebt;
            out.kopio.valTotal = kopioTotal;

            out.valueNow = krTotal + kopioTotal;
        }

        return out;
    }
}
