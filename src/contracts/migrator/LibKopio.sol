// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import {Log} from "kopio/vm/VmLibs.s.sol";
import {PythView} from "kopio/vendor/Pyth.sol";
import {IData} from "c/helpers/IData.sol";
import {IERC20} from "kopio/token/IERC20.sol";
import {IKopioCore} from "kopio/IKopioCore.sol";

IData constant kopioData = IData(0xddDdDddDDd14aC7aB83F957b804e6b714b75179E);
IKopioCore constant kopioCore = IKopioCore(
    0x000000000000dcC1394A66cD4f84Fb38932a0fAB
);

// library KopioLogger {
//     using Log for *;
//     function getView(
//         bytes calldata viewData
//     ) public pure returns (PythView memory) {
//         return abi.decode(viewData, (PythView));
//     }
//     function logMigrator(
//         address migrator,
//         PythView memory pythView
//     ) internal view {
//         user(migrator, pythView);
//     }
//     function user(address account, PythView memory pythView) internal view {
//         IData.A memory acc = kopioData.getAccount(
//             pythView,
//             account,
//             new address[](0)
//         );
//         Log.sr();
//         account.clg("Account");
//         Log.hr();
//         acc.icdp.totals.cr.plg("icdp CR");
//         acc.icdp.totals.valColl.dlg("icdp Collateral", 8);
//         acc.icdp.totals.valDebt.dlg("icdp Debt", 8);

//         Log.hr();
//         minter(account, pythView);
//         uint256 totalValKresko = scdp(acc) + acc.icdp.totals.valColl;
//         Log.sr();
//         bals(account, pythView);
//         Log.sr();
//         totalValKresko.dlg("Total Protocol Value", 8);

//         Log.sr();
//     }
//     function minter(address account, PythView memory pythView) internal view {
//         IData.A memory acc = kopioData.getAccount(
//             pythView,
//             account,
//             new address[](0)
//         );
//         for (uint256 i; i < acc.icdp.deposits.length; i++) {
//             acc.icdp.deposits[i].symbol.clg("Deposits");
//             uint256 decimals = IERC20(acc.icdp.deposits[i].addr).decimals();
//             acc.icdp.deposits[i].amount.dlg("Amount", decimals);
//             acc.icdp.deposits[i].val.dlg("Value", 8);
//         }

//         for (uint256 i; i < acc.icdp.debts.length; i++) {
//             acc.icdp.debts[i].symbol.clg("Debt");
//             acc.icdp.debts[i].amount.dlg("Amount");
//             acc.icdp.debts[i].val.dlg("Value", 8);
//         }
//     }

//     function scdp(IData.A memory acc) internal view returns (uint256 totalVal) {
//         for (uint256 i; i < acc.scdp.deposits.length; i++) {
//             acc.scdp.deposits[i].symbol.clg("SCDP Deposits");

//             uint256 decimals = IERC20(acc.scdp.deposits[i].addr).decimals();
//             acc.scdp.deposits[i].amount.dlg("Amount", decimals);
//             acc.scdp.deposits[i].val.dlg("Value", 8);
//             totalVal += acc.scdp.deposits[i].val;
//             Log.hr();
//         }
//     }

//     function bals(address account, PythView memory pythView) internal view {
//         IData.A memory acc = kopioData.getAccount(
//             pythView,
//             account,
//             new address[](0)
//         );
//         uint256 totalVal;
//         for (uint256 i; i < acc.tokens.length; i++) {
//             acc.tokens[i].symbol.clg("Wallet Balance");
//             acc.tokens[i].amount.dlg("Amount", acc.tokens[i].decimals);
//             acc.tokens[i].val.dlg("Value", acc.tokens[i].oracleDec);
//             totalVal += acc.tokens[i].val;
//             Log.hr();
//         }

//         totalVal.dlg("Total Wallet Value", 8);
//         account.balance.dlg("ETH Balance");
//     }
// }
