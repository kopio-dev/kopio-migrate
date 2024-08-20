// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;
import {Utils} from "kopio/utils/Libs.sol";
import {PLog} from "kopio/vm/PLog.s.sol";
import {Base} from "s/base/Base.s.sol";

import {Route} from "c/migrator/router/IMigrationRouter.sol";
import {MigrationExtras} from "c/migrator/MigrationExtras.sol";
import {Migrator} from "c/migrator/Migrator.sol";
import {IMigrator} from "c/migrator/IMigrator.sol";
import {MigrationRouter} from "c/migrator/router/MigrationRouter.sol";

contract MigrationDeploy is Base {
    using PLog for *;
    using Utils for *;

    Migrator migrator;
    MigrationRouter router;
    address routerAddr;

    Route[] internal routes;

    function setUp() public virtual {
        base("MNEMONIC_KOPIO", "arbitrum", 243519352);
    }

    function deployMigrationRouter(
        address owner
    ) internal broadcasted(owner) withJSON("MigrationRouter") {
        jsonKey("deployment");
        json(owner, "owner");
        address _migrator = address(new Migrator());
        json(_migrator, "migrator");
        address _extras = address(new MigrationExtras());
        json(_extras, "extras");

        router = new MigrationRouter(owner, getRoutes(_migrator, _extras));
        routerAddr = address(router);
        json(routerAddr, "router");

        migrator = Migrator(address(router));

        MigrationExtras(routerAddr).initializeMigrationState();
        payable(routerAddr).transfer(1e9);
        router.authorize(safe);
    }

    function getRoutes(
        address _logic,
        address _extras
    ) internal returns (Route[] memory) {
        routes = [
            Route({
                impl: _extras,
                sig: MigrationExtras.setMaxMigrationSlippage.selector
            }),
            Route({
                impl: _extras,
                sig: MigrationExtras.initializeMigrationState.selector
            }),
            Route({impl: _extras, sig: IMigrator.previewMigrate.selector}),
            Route({impl: _extras, sig: IMigrator.getPreviewResult.selector}),
            Route({impl: _extras, sig: IMigrator.emitTransfers.selector}),
            Route({impl: _logic, sig: IMigrator.migrate.selector}),
            Route({
                impl: _logic,
                sig: Migrator.onUncheckedCollateralWithdraw.selector
            })
        ];

        return routes;
    }
}
