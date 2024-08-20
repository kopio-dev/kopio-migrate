// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Utils} from "kopio/utils/Libs.sol";
import {Log} from "kopio/vm/VmLibs.s.sol";
import {Migrator} from "c/migrator/Migrator.sol";
import {IData} from "kopio/support/IData.sol";
import {IKopioCore} from "kopio/IKopioCore.sol";
import {kr} from "c/helpers/Kresko.sol";
import {IMigrator, MigratorState} from "c/migrator/IMigrator.sol";

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

using Utils for uint256;
using Utils for address[];

library Positions {
    using Utils for *;

    // address constant kreskoAddr = 0x0000000000177abD99485DCaea3eFaa91db3fe72;

    function _rank(
        IMigrator.Pos[] memory all,
        IMigrator.Pos memory p
    ) internal pure returns (uint256 idx) {
        for (uint256 i; i < all.length; i++) {
            if (all[i].valueAdj > p.valueAdj) idx++;
        }
    }

    function getRepayable(
        IMigrator.Pos storage coll,
        IMigrator.Pos[] storage debts
    ) internal view returns (bool found, uint256 idx) {
        uint256 debt;
        for (uint256 i; i < debts.length; i++) {
            uint256 debtVal = debts[i].value;
            if (debtVal == 0) continue;

            if (debt < debtVal && coll.value >= debtVal) {
                found = true;
                debt = debtVal;
                idx = i;
            }
        }
    }

    function sort(
        IMigrator.Pos[] storage c,
        IMigrator.Pos[] storage d
    )
        internal
        returns (IMigrator.Pos[] memory sColls, IMigrator.Pos[] memory sDebts)
    {
        sColls = new IMigrator.Pos[](c.length);
        sDebts = new IMigrator.Pos[](d.length);
        for (uint256 i; i < c.length; i++) sColls[_rank(c, c[i])] = c[i];
        for (uint256 i; i < d.length; i++) sDebts[_rank(d, d[i])] = d[i];

        for (uint256 i; i < sColls.length; i++) {
            c[i] = sColls[i];
        }

        for (uint256 i; i < sDebts.length; i++) {
            d[i] = sDebts[i];
        }
    }

    function get(
        address acc,
        address token,
        uint256 idx,
        bool coll
    ) internal view returns (IMigrator.Pos memory p) {
        (p.a, p.idx) = (getToken(token), idx);
        (p.amount, p.value, p.valueAdj) = getAmountValue(acc, token, coll);
    }

    function getValue(
        IMigrator.Token memory t,
        uint256 amt,
        uint256 fac
    ) internal view returns (uint256 value) {
        value = amt.toWad(t.asset.decimals).wmul(kr.getPrice(t.addr));
        if (fac != 0) value = value.wmul(fac);
    }
    function getToken(
        address addr
    ) internal view returns (IMigrator.Token memory tkn) {
        tkn.asset = kr.getAsset(addr);
        tkn.addr = addr;
    }

    function toAmount(
        IMigrator.Token memory t,
        uint256 val
    ) internal view returns (uint256) {
        uint256 wad = val.wdiv(kr.getPrice(t.addr));
        return wad.fromWad(t.asset.decimals);
    }

    function getAmountValue(
        address acc,
        address assetAddr,
        bool isColl
    ) internal view returns (uint256 a, uint256 v, uint256 va) {
        IMigrator.Token memory tkn = getToken(assetAddr);
        a = isColl
            ? kr.getAccountCollateralAmount(acc, assetAddr)
            : kr.getAccountDebtAmount(acc, assetAddr);
        v = getValue(tkn, a, 0);
        va = v.pmul(isColl ? tkn.asset.factor : tkn.asset.kFactor);
    }

    function getPositions(MigratorState storage ms, address acc) internal {
        address[] memory colls = kr.getAccountCollateralAssets(acc);
        address[] memory krs = kr.getAccountMintedAssets(acc);

        uint256 totalColl;
        uint256 totalDebt;
        for (uint256 i; i < colls.length; i++) {
            ms.posColl.push(get(acc, colls[i], i, true));
            totalColl += ms.posColl[i].value;
        }
        for (uint256 i; i < krs.length; i++) {
            ms.posDebt.push(get(acc, krs[i], i, false));
            totalDebt += ms.posDebt[i].value;
        }
        sort(ms.posColl, ms.posDebt);

        ms.collValue = totalColl;
        ms.debtValue = totalDebt;
    }
}
