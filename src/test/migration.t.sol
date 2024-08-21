// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Tested} from "kopio/vm/Tested.t.sol";
import {Migrator, MigrationDeploy, Utils} from "s/migration.s.sol";
import {Log} from "kopio/vm/VmLibs.s.sol";
import {Kresko} from "c/helpers/Kresko.sol";
import {KreskoSetup, TestUsers} from "t/migration-util.t.sol";
import {IERC20} from "kopio/token/IERC20.sol";

contract MigrationTest is TestUsers, Kresko, MigrationDeploy, Tested {
    using Log for *;
    using Utils for *;

    address depositor = makeAddr("depositor");

    function setUp() public override {
        base("MNEMONIC_KOPIO", "arbitrum", 245269894);
        syncTime();
        updatePyth();

        prank(sender);
        updateMigrationRouter();
        setupKresko();
    }

    function setupKopio() internal pranked(safe) {
        core.setOracleDeviation(10e2);
    }

    function setupKresko() internal pranked(krSafe) {
        kresko.executeInitializer(
            address(new KreskoSetup()),
            abi.encodeWithSelector(KreskoSetup.run.selector)
        );
    }

    function testAllMigrations() public {
        for (uint256 i; i < testUsers.length; i++) {
            _log(_migrate(testUsers[i]));
        }
    }

    function _migrate(
        address user
    ) internal pranked(user) returns (Migrator.MigrationResult memory) {
        return migrator.migrate(user, pyth.update);
    }

    function _log(Migrator.MigrationResult memory result) internal view {
        if (result.valueBefore == 0 || result.valueNow == 0) {
            result.account.clg("No Migration Required: ");
            return;
        }
        Log.hr();
        for (uint256 i; i < result.icdpColl.length; i++) {
            Migrator.Transfer memory tf = result.icdpColl[i];
            IERC20 asset = IERC20(
                tf.destination != address(0) ? tf.destination : tf.asset
            );
            uint8 dec = asset.decimals();
            string memory info = string.concat(
                "Collateral: ",
                asset.symbol(),
                " Amount: ",
                tf.amount.dstr(dec),
                " Amount Transferred: ",
                tf.amountTransferred.dstr(dec),
                " Actual:",
                core
                    .getAccountCollateralAmount(result.account, address(asset))
                    .dstr(dec)
            );
            info.clg();
        }
        Log.hr();
        for (uint256 i; i < result.icdpDebt.length; i++) {
            Migrator.Transfer memory tf = result.icdpDebt[i];
            IERC20 asset = IERC20(tf.destination);
            string memory info = string.concat(
                "Debt: ",
                asset.symbol(),
                " Amount: ",
                tf.amount.dstr(),
                " Amount Transferred: ",
                tf.amountTransferred.dstr(),
                " Actual:",
                core.getAccountDebtAmount(result.account, address(asset)).dstr()
            );

            info.clg();
        }

        Log.hr();
        result.account.clg("Account: ");
        string memory scdpInfo = string.concat(
            "SCDP: ",
            result.kresko.valSCDPBefore.dstr(8),
            " -> ",
            result.kopio.valSCDP.dstr(8)
        );
        string memory collInfo = string.concat(
            "Collateral: ",
            result.kresko.valCollBefore.dstr(8),
            " -> ",
            result.kopio.valColl.dstr(8)
        );

        string memory debtInfo = string.concat(
            "Debt: ",
            result.kresko.valDebtBefore.dstr(8),
            " -> ",
            result.kopio.valDebt.dstr(8)
        );
        string memory totalInfo = string.concat(
            "Total: ",
            result.kresko.valTotalBefore.dstr(8),
            " -> ",
            result.kopio.valTotal.dstr(8)
        );
        scdpInfo.clg();
        collInfo.clg();
        debtInfo.clg();
        totalInfo.clg();
        result.slippage.plg("Slippage: ");
    }
}
