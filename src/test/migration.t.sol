// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Tested} from "kopio/vm/Tested.t.sol";
import {Migrator, MigrationDeploy, Utils} from "s/migration.s.sol";
import {Log} from "kopio/vm/VmLibs.s.sol";
import {Kresko} from "c/helpers/Kresko.sol";
import {KreskoSetup, TestUsers} from "t/migration-util.t.sol";
import {Role} from "kresko/core/types/Role.sol";

contract MigrationTest is TestUsers, Kresko, MigrationDeploy, Tested {
    using Log for *;
    using Utils for *;

    address depositor = makeAddr("depositor");

    function setUp() public override {
        base("MNEMONIC_KOPIO", "arbitrum", 244859328);
        syncTime();
        updatePyth();

        prank(sender);
        // deployMigrationRouter(sender);
        // vm.allowCheatcodes(routerAddr);

        setupKresko();
        setupKopio();

        prank(depositor);
        deal(usdceAddr, depositor, 10_000e6);
        usdce.approve(address(one), type(uint256).max);
        one.approve(address(core), type(uint256).max);
        one.vaultDeposit(usdceAddr, 10_000e6, depositor);
        core.depositSCDP(depositor, oneAddr, one.balanceOf(depositor));

        updateMigrationRouter();
    }

    function setupKopio() internal pranked(safe) {
        core.setOracleDeviation(10e2);

        bytes32[] memory markets = new bytes32[](3);
        bool[] memory statuses = new bool[](3);
        markets[0] = "FOREX";
        markets[1] = "XAG";
        markets[2] = "XAU";

        statuses[0] = true;
        statuses[1] = true;
        statuses[2] = true;
        marketStatus.setStatus(markets, statuses);
    }

    function setupKresko() internal pranked(krSafe) {
        kresko.executeInitializer(
            address(new KreskoSetup()),
            abi.encodeWithSelector(KreskoSetup.run.selector)
        );

        kresko.grantRole(Role.MANAGER, routerAddr);
    }

    function testMigrations() public {
        for (uint256 i; i < testUsers.length; i++) {
            _migrateUser(testUsers[i]).slippage.plg("Slippage");
        }
    }
    function testPreview() public {
        _migrateUser(0x0a7f988B6cEa3081EBa2896C4f0793c19d2A775E).slippage.plg(
            "Slippage"
        );
        migrator.previewMigrate(testUsers[0], pyth.update).slippage.plg("slip");
    }

    function _migrateUser(
        address user
    ) internal pranked(user) returns (Migrator.MigrationResult memory) {
        return migrator.migrate(user, pyth.update);
    }
}
