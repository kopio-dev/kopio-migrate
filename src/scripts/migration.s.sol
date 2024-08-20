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
import {SafeScript} from "kopio/vm-ffi/SafeScript.s.sol";

contract MigrationDeploy is SafeScript, Base {
    using PLog for *;
    using Utils for *;

    Migrator migrator = Migrator(0xaaaaaAaAaAa186774266Ea9b3FC0B588B3232795);
    MigrationRouter router;
    address routerAddr = 0xaaaaaAaAaAa186774266Ea9b3FC0B588B3232795;

    Route[] internal routes;

    function setUp() public virtual {
        base("MNEMONIC_KOPIO", "arbitrum");
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

        bytes memory ctor = abi.encode(owner, getRoutes(_migrator, _extras));
        json(ctor, "ctor");
        bytes memory routerImpl = abi.encodePacked(
            type(MigrationRouter).creationCode,
            ctor
        );

        routerAddr = factory
            .deployCreate3(
                routerImpl,
                "",
                0x263519a90d43362f176df75009b92836e500b653ca82273b7bfad8045d85a470
            )
            .implementation;
        json(routerAddr, "router");

        router = MigrationRouter(payable(routerAddr));
        routerAddr = address(router);

        migrator = Migrator(address(router));

        MigrationExtras(routerAddr).initializeMigrationState();
        payable(routerAddr).transfer(1e9);
        router.authorize(safe);

        core.grantRole(keccak256("kopio.role.manager"), routerAddr);
        jsonKey();
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
