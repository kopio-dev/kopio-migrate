// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Route} from "./IMigrationRouter.sol";
import {MigrationRouter} from "./MigrationRouter.sol";
import {Based} from "kopio/vm/Based.s.sol";
import {MigrationExtras} from "../MigrationExtras.sol";
import {Migrator} from "c/migrator/Migrator.sol";
import {IMigrator} from "c/migrator/IMigrator.sol";
import {ArbDeployAddr} from "kopio/info/ArbDeployAddr.sol";

abstract contract MigrationRouterDeploy is ArbDeployAddr, Based {
    Migrator migrator;
    MigrationRouter router;
    address routerAddr;

    function deployMigrationRouter(address owner) internal broadcasted(owner) {
        address _migrator = address(new Migrator());
        address _init = address(new MigrationExtras());

        router = new MigrationRouter(owner, getRoutes(_migrator, _init));
        routerAddr = address(router);

        migrator = Migrator(address(router));
        MigrationExtras(routerAddr).initializeMigrationState();
        payable(routerAddr).transfer(1e9);
        router.authorize(safe);
    }

    Route[] internal routes;
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
